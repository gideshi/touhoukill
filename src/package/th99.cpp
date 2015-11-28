#include "th99.h"

#include "general.h"
#include "skill.h"
#include "engine.h"
#include "standard.h"

#include "client.h"
#include "jsonutils.h"
#include "maneuvering.h" //for skill lianxi



QiuwenCard::QiuwenCard()
{
    mute = true;
    target_fixed = true;
}
void QiuwenCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    room->drawCards(source, 3);
}
class Qiuwen : public ZeroCardViewAsSkill
{
public:
    Qiuwen() : ZeroCardViewAsSkill("qiuwen")
    {
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("QiuwenCard");
    }

    virtual const Card *viewAs() const
    {
        return new QiuwenCard;
    }
};
class Zaozu : public TriggerSkill
{
public:
    Zaozu() : TriggerSkill("zaozu")
    {
        events << EventPhaseChanging << EventPhaseStart;
        frequency = Compulsory;
    }

    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {   
        if (!TriggerSkill::triggerable(player)) return QStringList();
        if (triggerEvent == EventPhaseChanging) {
            PhaseChangeStruct change = data.value<PhaseChangeStruct>();
            if (change.to == Player::Discard) 
                return QStringList(objectName());
        } else if (triggerEvent == EventPhaseStart) {
            if (player->getPhase() == Player::Finish &&player->getHandcardNum() > player->getMaxHp()) 
                 return QStringList(objectName());
        }
         return QStringList();
    }
    
    virtual bool effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        room->notifySkillInvoked(player, objectName());
        room->touhouLogmessage("#TriggerSkill", player, objectName());
        if (triggerEvent == EventPhaseChanging) {
            player->skip(Player::Discard);
        } else if (triggerEvent == EventPhaseStart) {
            room->loseHp(player);
        }
        return false;
    }
};

DangjiaCard::DangjiaCard()
{
    will_throw = false;
    handling_method = Card::MethodNone;
    m_skillName = "dangjiavs";
    mute = true;
}
bool DangjiaCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.isEmpty() && to_select->hasLordSkill("dangjia")
        && to_select != Self && !to_select->hasFlag("dangjiaInvoked")
        && !to_select->isKongcheng() && to_select->isWounded();
}
void DangjiaCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    ServerPlayer *akyu = targets.first();
    if (akyu->hasLordSkill("dangjia")) {
        room->setPlayerFlag(akyu, "dangjiaInvoked");

        room->notifySkillInvoked(akyu, "dangjia");
        if (!source->pindian(akyu, "dangjia", NULL)) {
            RecoverStruct recov;
            recov.who = source;
            room->recover(akyu, recov);
        }

        QList<ServerPlayer *> akyus;
        QList<ServerPlayer *> players = room->getOtherPlayers(source);
        foreach (ServerPlayer *p, players) {
            if (p->hasLordSkill("dangjia") && !p->hasFlag("dangjiaInvoked"))
                akyus << p;
        }
        if (akyus.isEmpty())
            room->setPlayerFlag(source, "Forbiddangjia");
    }
}
class DangjiaVS : public ZeroCardViewAsSkill
{
public:
    DangjiaVS() :ZeroCardViewAsSkill("dangjiavs")
    {
        attached_lord_skill = true;
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return  shouldBeVisible(player) && !player->hasFlag("Forbiddangjia") && !player->isKongcheng();
    }

    virtual bool shouldBeVisible(const Player *Self) const
    {
        return Self && Self->getKingdom() == "wai";
    }

    virtual const Card *viewAs() const
    {
        return new DangjiaCard;
    }
};
class Dangjia : public TriggerSkill
{
public:
    Dangjia() : TriggerSkill("dangjia$")
    {
        events << GameStart << EventAcquireSkill << EventLoseSkill << EventPhaseChanging;
    }

    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const{
        if (!player) return QStringList();
        if ((triggerEvent == GameStart && player->isLord())
            || (triggerEvent == EventAcquireSkill && data.toString() == "dangjia")) {
            QList<ServerPlayer *> lords;
            foreach (ServerPlayer *p, room->getAlivePlayers()) {
                if (p->hasLordSkill(objectName(), false, true))
                    lords << p;
            }
            if (lords.isEmpty()) return QStringList();

            QList<ServerPlayer *> players;
            if (lords.length() > 1)
                players = room->getAlivePlayers();
            else
                players = room->getOtherPlayers(lords.first());
            foreach (ServerPlayer *p, players) {
                if (!p->hasSkill("dangjiavs"))
                    room->attachSkillToPlayer(p, "dangjiavs");
            }
        } else if (triggerEvent == EventLoseSkill && data.toString() == "dangjia") {
            QList<ServerPlayer *> lords;
            foreach (ServerPlayer *p, room->getAlivePlayers()) {
                if (p->hasLordSkill(objectName(), false, true))
                    lords << p;
            }
            if (lords.length() > 2) return QStringList();

            QList<ServerPlayer *> players;
            if (lords.isEmpty())
                players = room->getAlivePlayers();
            else
                players << lords.first();
            foreach (ServerPlayer *p, players) {
                if (p->hasSkill("dangjiavs"))
                    room->detachSkillFromPlayer(p, "dangjiavs", true);
            }
        } else if (triggerEvent == EventPhaseChanging) {
            PhaseChangeStruct phase_change = data.value<PhaseChangeStruct>();
            if (phase_change.from != Player::Play)
                return QStringList();
            if (player->hasFlag("Forbiddangjia"))
                room->setPlayerFlag(player, "-Forbiddangjia");
            QList<ServerPlayer *> players = room->getOtherPlayers(player);
            foreach (ServerPlayer *p, players) {
                if (p->hasFlag("dangjiaInvoked"))
                    room->setPlayerFlag(p, "-dangjiaInvoked");
            }
        }
        return QStringList();
    }
};

XiufuCard::XiufuCard()
{
    will_throw = false;
    handling_method = Card::MethodNone;
    m_skillName = "xiufu";
    //target_fixed = true;
}
bool XiufuCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return  targets.isEmpty();
}
void XiufuCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    int equipid = subcards.first(); 
    const EquipCard *equip = qobject_cast<const EquipCard *>(Sanguosha->getCard(equipid)->getRealCard());
    ServerPlayer *target = targets.first();
	
    int equipped_id = -1;
    if (target->getEquip(equip->location()) != NULL)
        equipped_id = target->getEquip(equip->location())->getEffectiveId();
    QList<CardsMoveStruct> exchangeMove;
    if (equipped_id != -1) {
        CardsMoveStruct move2(equipped_id, NULL, Player::DiscardPile,
            CardMoveReason(CardMoveReason::S_REASON_CHANGE_EQUIP, target->objectName()));
        exchangeMove.push_back(move2);
    }
    CardsMoveStruct move1(equipid, target, Player::PlaceEquip,
        CardMoveReason(CardMoveReason::S_REASON_TRANSFER, source->objectName()));
    // this move has no client log?
    exchangeMove.push_back(move1);

    room->moveCardsAtomic(exchangeMove, true);
}

XiufuFakeMoveCard::XiufuFakeMoveCard()
{
    target_fixed = true;
	mute = true;
	m_skillName = "xiufu";//important for ai
}

const Card *XiufuFakeMoveCard::validate(CardUseStruct &card_use) const
{
	ServerPlayer *source = card_use.from;
	Room *room = card_use.from->getRoom();

	QList<int> able;
    QList<int> discardpile = room->getDiscardPile();
    foreach (int id, discardpile) {
        Card *tmp_card = Sanguosha->getCard(id);
        if (tmp_card->isKindOf("EquipCard"))
            able << id;
    }
    if (able.isEmpty()){
        room->setPlayerFlag(source, "Global_xiufuFailed");
		return NULL;
	}
	//move in pile  pile没有清空 导致重复加入pile？
     CardsMoveStruct move(able, NULL, source, Player::PlaceTable, Player::PlaceSpecial,
        CardMoveReason(CardMoveReason::S_REASON_PUT, source->objectName(), "xiufu", QString()));
		move.to_pile_name = "#xiufu";
        QList<CardsMoveStruct> moves;
        moves.append(move);
        QList<ServerPlayer *> _source;
        _source << source;
        room->notifyMoveCards(true, moves, false, _source);
        room->notifyMoveCards(false, moves, false, _source); 

	const Card *card = room->askForUseCard(source, "@@xiufu", "@xiufu",-1, Card::MethodNone);
	if (!card)
		room->setPlayerFlag(source, "Global_xiufuFailed");
	
		
    CardsMoveStruct move1(able, source, NULL, Player::PlaceSpecial, Player::PlaceTable,
                CardMoveReason(CardMoveReason::S_REASON_PUT, source->objectName(), "xiufu", QString()));
        move.from_pile_name = "#xiufu";
        QList<CardsMoveStruct> moves1;
        moves1.append(move1);
        QList<ServerPlayer *> _source1;
        _source1 << source;
        room->notifyMoveCards(true, moves1, false, _source1);
        room->notifyMoveCards(false, moves1, false, _source1);
    return NULL;
}


//version 1
class Xiufu : public ViewAsSkill
{
public:
    Xiufu() : ViewAsSkill("xiufu")
    {
		expand_pile = "#xiufu";
		response_pattern = "@@xiufu";
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return  !player->hasUsed("XiufuCard") && !player->hasFlag("Global_xiufuFailed");
    }


    virtual bool viewFilter(const QList<const Card *> &selected, const Card *to_select) const
    {
        QString pattern = Sanguosha->currentRoomState()->getCurrentCardUsePattern();
        if (pattern == "@@xiufu"){
			QList<int> ids = Self->getPile("#xiufu");
            return ids.contains(to_select->getEffectiveId());
		}
        return false;
    }

    virtual const Card *viewAs(const QList<const Card *> &cards) const
    {
        QString pattern = Sanguosha->currentRoomState()->getCurrentCardUsePattern();
        if (pattern == "@@xiufu"){
            if (cards.length() == 1) { 
                XiufuCard *card = new XiufuCard;
				card->addSubcards(cards);
                return card;
			}
		}
        else{
            return new XiufuFakeMoveCard;
        }
		return NULL;
    }
};


 //version 2
/* XiufuCard::XiufuCard()
{
    will_throw = false;
    handling_method = Card::MethodNone;
    m_skillName = "xiufu";
    mute = true;
    target_fixed = true;
}
void XiufuCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{

    QList<int> able;
    QList<int> discardpile = room->getDiscardPile();
    foreach (int id, discardpile) {
        Card *tmp_card = Sanguosha->getCard(id);
        if (tmp_card->isKindOf("EquipCard"))
            able << id;
    }
    if (able.isEmpty())
        return;
    room->fillAG(able, source);
    int equipid = room->askForAG(source, able, false, "xiufu");
    const EquipCard *equip = qobject_cast<const EquipCard *>(Sanguosha->getCard(equipid)->getRealCard());
    ServerPlayer *target = room->askForPlayerChosen(source, room->getAlivePlayers(), "xiufu", "@xiufu-select:" + equip->objectName(), false, true);
    room->clearAG(source);

    int equipped_id = -1;
    if (target->getEquip(equip->location()) != NULL)
        equipped_id = target->getEquip(equip->location())->getEffectiveId();
    QList<CardsMoveStruct> exchangeMove;
    if (equipped_id != -1) {
        CardsMoveStruct move2(equipped_id, NULL, Player::DiscardPile,
            CardMoveReason(CardMoveReason::S_REASON_CHANGE_EQUIP, target->objectName()));
        exchangeMove.push_back(move2);
    }
    CardsMoveStruct move1(equipid, target, Player::PlaceEquip,
        CardMoveReason(CardMoveReason::S_REASON_TRANSFER, source->objectName()));

    exchangeMove.push_back(move1);

    room->moveCardsAtomic(exchangeMove, true);

}


class Xiufu : public ZeroCardViewAsSkill
{
public:
    Xiufu() :ZeroCardViewAsSkill("xiufu")
    {
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("XiufuCard") && player->getMark("can_xiufu") > 0;
    }

    virtual const Card *viewAs() const
    {
        return new XiufuCard;
    }
};
//check discardpile
class XiufuCheck : public TriggerSkill
{
public:
    XiufuCheck() : TriggerSkill("#xiufu")
    {
        events << CardsMoveOneTime << EventAcquireSkill;
    }

    
    static bool findEquip(Room *room)
    {
        QList<int> discardpile = room->getDiscardPile();
        foreach (int id, discardpile) {
            Card *tmp_card = Sanguosha->getCard(id);
            if (tmp_card->isKindOf("EquipCard"))
                return true;
        }
        return false;
    }
    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const{
        if (!TriggerSkill::triggerable(player)) return QStringList();
        QList<ServerPlayer *> srcs = room->getAlivePlayers();
        if (triggerEvent == CardsMoveOneTime && player != NULL && player->isAlive()) {
            CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
            if (player->getMark("can_xiufu") > 0) {
                if (move.from_places.contains(Player::DrawPile) || move.from_places.contains(Player::DiscardPile)) {
                    if (!findEquip(room)) {
                        foreach(ServerPlayer *p, srcs)
                            room->setPlayerMark(p, "can_xiufu", 0);
                    }
                }
            } else {
                if (player->getMark("can_xiufu") == 0 && move.to_place == Player::DiscardPile) {
                    if (findEquip(room)) {
                        foreach(ServerPlayer *p, srcs)
                            room->setPlayerMark(p, "can_xiufu", 1);
                    }
                }
            }
        } else if ((triggerEvent == EventAcquireSkill && data.toString() == "xiufu")) {
            if (findEquip(room)) {
                foreach(ServerPlayer *p, srcs)
                    room->setPlayerMark(p, "can_xiufu", 1);
            } else {
                foreach(ServerPlayer *p, srcs)
                    room->setPlayerMark(p, "can_xiufu", 0);
            }
        }
        return QStringList();
    }
};
 */
class Fandu : public TriggerSkill
{
public:
    Fandu() : TriggerSkill("fandu")
    {
        events << EventPhaseStart << Damaged;
    }
    static void do_fandu(ServerPlayer *player)
    {
        player->drawCards(2);
        Room *room = player->getRoom();
        QList<ServerPlayer *> listt;
        foreach (ServerPlayer *p, room->getOtherPlayers(player)) {
            if (p->canDiscard(player, "h"))
                listt << p;
        }
        if (listt.isEmpty())
            return;
        ServerPlayer *target = room->askForPlayerChosen(player, listt, "fandu", "@fandu-select", false, true);
        int to_throw = room->askForCardChosen(target, player, "h", "fandu", false, Card::MethodDiscard);
        room->throwCard(to_throw, player, target);
    }
    
    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const{
        if (!TriggerSkill::triggerable(player)) return QStringList();
        if (triggerEvent == EventPhaseStart) {
            if (player->getPhase() == Player::Start) 
                return QStringList(objectName());
        }
        else if (triggerEvent == Damaged) 
            return QStringList(objectName());
        return QStringList();
    }
    
    
    
    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        if (triggerEvent == EventPhaseStart) {
            if (room->askForSkillInvoke(player, "fandu")) {
                do_fandu(player);
            }
        } else if (triggerEvent == Damaged) {
            DamageStruct damage = data.value<DamageStruct>();
            for (int var = 0; var < damage.damage; var++) {
                if (!room->askForSkillInvoke(player, "fandu"))
                    break;
                do_fandu(player);
            }
        }
        return false;
    }
};


class Taohuan : public TriggerSkill
{
public:
    Taohuan() : TriggerSkill("taohuan")
    {
        events << CardsMoveOneTime;
    }

    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const{
        if (!TriggerSkill::triggerable(player)) return QStringList();
        if (player->hasFlag("pindian") || !player->hasSkill(objectName()))
            return QStringList();
        CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
        //case 1:discard
        ServerPlayer *thrower;
        if (move.from != NULL && move.to_place == Player::DiscardPile && move.from == player
            && (move.reason.m_reason & CardMoveReason::S_MASK_BASIC_REASON) == CardMoveReason::S_REASON_DISCARD) {

            foreach (ServerPlayer *p, room->getAlivePlayers()) {
                if (p->objectName() == move.reason.m_playerId) {
                    thrower = p;
                    break;
                }
            }
            if (thrower != NULL && thrower != player) {
                foreach (int id, move.card_ids) {
                    if (move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceHand ||
                        move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceEquip) {
                        if (!Sanguosha->getCard(id)->isKindOf("BasicCard")) {
                            return QStringList(objectName()); 
                        }
                    }
                }
            }
        }
        //case 2:obtain
        //need check  move.to??
        ServerPlayer *obtainer;
        if (move.from != NULL && move.from == player) {
            if ((move.origin_to && move.origin_to != move.from && move.origin_to_place == Player::PlaceHand)
                || (move.to && move.to != move.from && move.to_place == Player::PlaceHand)) {
                Player *temp = move.to ? move.to : move.origin_to;
                foreach (ServerPlayer *p, room->getOtherPlayers(player)) {
                    if (p->objectName() == temp->objectName()) {
                        obtainer = p;
                        break;
                    }
                }
                if (obtainer != NULL && obtainer != player) {
                    foreach (int id, move.card_ids) {
                        if (room->getCardPlace(id) == Player::PlaceHand &&
                            (move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceTable
                            || move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceHand
                            || move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceEquip))
                            return QStringList(objectName());
                    }
                }
            }

        }
        return QStringList();
    }
    
    virtual bool effect(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
        //case 1:discard
        int count1 = 0;
        ServerPlayer *thrower;
        if (move.from != NULL && move.to_place == Player::DiscardPile && move.from == player
            && (move.reason.m_reason & CardMoveReason::S_MASK_BASIC_REASON) == CardMoveReason::S_REASON_DISCARD) {

            foreach (ServerPlayer *p, room->getAlivePlayers()) {
                if (p->objectName() == move.reason.m_playerId) {
                    thrower = p;
                    break;
                }
            }
            if (thrower != NULL && thrower != player) {
                foreach (int id, move.card_ids) {
                    if (move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceHand ||
                        move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceEquip) {
                        if (!Sanguosha->getCard(id)->isKindOf("BasicCard")) {
                            count1++;
                        }
                    }
                }
            }
        }
        //case 2:obtain
        //need check  move.to??
        int count2 = 0;
        ServerPlayer *obtainer;
        if (move.from != NULL && move.from == player) {
            if ((move.origin_to && move.origin_to != move.from && move.origin_to_place == Player::PlaceHand)
                || (move.to && move.to != move.from && move.to_place == Player::PlaceHand)) {
                Player *temp = move.to ? move.to : move.origin_to;
                foreach (ServerPlayer *p, room->getOtherPlayers(player)) {
                    if (p->objectName() == temp->objectName()) {
                        obtainer = p;
                        break;
                    }
                }
                if (obtainer != NULL && obtainer != player) {
                    foreach (int id, move.card_ids) {
                        if (room->getCardPlace(id) == Player::PlaceHand &&
                            (move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceTable
                            || move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceHand
                            || move.from_places.at(move.card_ids.indexOf(id)) == Player::PlaceEquip))
                            count2++;
                    }
                }
            }

        }
        ServerPlayer *target;
        int count = 0;
        if (thrower != NULL && count1 > 0) {
            target = thrower;
            count = count1;
        }
        if (obtainer != NULL && count2 > 0) {
            target = obtainer;
            count = count2;
        }
        if (target == NULL)
            return false;
        player->tag["taohuantarget"] = QVariant::fromValue(target);
        while (count > 0) {
            if (player->isKongcheng() || target->isKongcheng())
                break;
            if (!room->askForSkillInvoke(player, "taohuan", QVariant::fromValue(target)))
                break;
            room->doAnimate(QSanProtocol::S_ANIMATE_INDICATE, player->objectName(), target->objectName());

            player->setFlags("pindian");
            count--;
            if (player->pindian(target, "taohuan", NULL) && !target->isNude()) {
                int id = room->askForCardChosen(player, target, "he", objectName());
                room->obtainCard(player, id, room->getCardPlace(id) != Player::PlaceHand);
            }
        }
        player->setFlags("-pindian");
        return false;
    }
};


class Shitu : public TriggerSkill
{
public:
    Shitu() : TriggerSkill("shitu")
    {
        events << EventPhaseChanging << EventPhaseStart << DamageDone << Death;
    }

	virtual void record(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
		if (triggerEvent == DamageDone || triggerEvent == Death )
			room->setTag("shituDamageOrDeath", true);
		if (triggerEvent == EventPhaseChanging) {
            PhaseChangeStruct change = data.value<PhaseChangeStruct>();
            if (change.to == Player::NotActive) {
				if (room->getTag("shituDamageOrDeath").toBool())
				{
					room->setTag("shituDamageOrDeath", false);
					return;
				}
				if (!player || !player->hasSkill(objectName()))
					return;
				if (player->getMark("touhou-extra") > 0) {
                    player->removeMark("touhou-extra");
                    return;
                }
                if (room->canInsertExtraTurn())
                    player->tag["ShituInvoke"] = QVariant::fromValue(true);
			}
		}
	}
	
	
    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const{
        if (!TriggerSkill::triggerable(player)) return QStringList();
		if (triggerEvent == EventPhaseStart &&  player->getPhase() == Player::NotActive) {
            if (player->tag["ShituInvoke"].toBool()){
				player->tag["ShituInvoke"] = QVariant::fromValue(false);
                return QStringList(objectName());
			}
        }
        return QStringList();
    }
    
    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {

        ServerPlayer *target = room->askForPlayerChosen(player, room->getAlivePlayers(), objectName(), "@shitu-playerchoose", true, true);
        if (target != NULL) {
            room->notifySkillInvoked(player, objectName());
            room->setPlayerMark(target, "shitu", 1);
            target->gainAnExtraTurn();
            room->setPlayerMark(target, "shitu", 0);
        }
        return false;
    }
};

class Mengxian : public TriggerSkill
{
public:
    Mengxian() : TriggerSkill("mengxian")
    {
        events << EventPhaseStart;
        frequency = Wake;
    }
    virtual bool triggerable(const ServerPlayer *player) const
    {
        return (player != NULL &&  player->hasSkill(objectName())
            && player->getMark("mengxian") == 0 
            && player->getPhase() == Player::Start) && player->getPile("jingjie").length() >= 3;
    }
    
    
    virtual bool effect(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        int n = player->getPile("jingjie").length();
        
        room->doLightbox("$mengxianAnimate", 4000);
        room->touhouLogmessage("#MengxianWake", player, objectName(), QList<ServerPlayer *>(), QString::number(n));
        room->notifySkillInvoked(player, objectName());
        room->addPlayerMark(player, objectName());
        if (room->changeMaxHpForAwakenSkill(player)) {
            RecoverStruct recov;
            room->recover(player, recov);
            room->handleAcquireDetachSkills(player, "luanying");
        }
        return false;
    }
};

class Luanying : public TriggerSkill
{
public:
    Luanying() : TriggerSkill("luanying")
    {
        events << CardUsed  << CardResponded; //<< SlashEffected << CardEffected
    }


    virtual TriggerList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        TriggerList skill_list;
        if (triggerEvent == CardUsed || triggerEvent == CardResponded) {
            if (player == NULL || player->isDead())
                return TriggerList();
            bool isRed = true;
            if (triggerEvent == CardUsed) {
                CardUseStruct use = data.value<CardUseStruct>();
                if (!use.card->isKindOf("BasicCard") || use.card->getSuit() == Card::NoSuit)
                    return TriggerList();
                isRed = use.card->isRed();
            } else if (triggerEvent == CardResponded) {
                CardStar card_star = data.value<CardResponseStruct>().m_card;
                if (!card_star->isKindOf("BasicCard") || data.value<CardResponseStruct>().m_isRetrial
                    || data.value<CardResponseStruct>().m_isProvision || card_star->getSuit() == Card::NoSuit)
                    return TriggerList();
                isRed = card_star->isRed();
            }
            QList<ServerPlayer *> merrys = room->findPlayersBySkillName(objectName());
            foreach (ServerPlayer *merry, merrys) {
                if (merry == player) continue;
				foreach (int id, merry->getPile("jingjie")) {
                    if (Sanguosha->getCard(id)->isRed() == isRed)
                        skill_list.insert(merry, QStringList(objectName()));
                }
            }
        }
        return skill_list;
        
    }

    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *merry) const
    {
        if (triggerEvent == CardUsed || triggerEvent == CardResponded) {
            room->setTag("luanying_target", QVariant::fromValue(player));
            if (triggerEvent == CardUsed)
                merry->tag["luanying_use"] = data;
            if (room->askForSkillInvoke(merry, objectName(), data)) {
                room->removeTag("luanying_target");
                return true;
            }
            return false;
        }
        return false;
    }
    
    virtual bool effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *merry) const
    {
        if (triggerEvent == CardUsed || triggerEvent == CardResponded) {
            bool isRed = true;
            QString cardName;
            if (triggerEvent == CardUsed) {
                CardUseStruct use = data.value<CardUseStruct>();
                if (!use.card->isKindOf("BasicCard") || use.card->getSuit() == Card::NoSuit)
                    return false;
                isRed = use.card->isRed();
                cardName = use.card->objectName();
            } else if (triggerEvent == CardResponded) {
                CardStar card_star = data.value<CardResponseStruct>().m_card;
                if (!card_star->isKindOf("BasicCard") || data.value<CardResponseStruct>().m_isRetrial
                    || data.value<CardResponseStruct>().m_isProvision || card_star->getSuit() == Card::NoSuit)
                    return false;
                isRed = card_star->isRed();
                cardName = card_star->objectName();
            }


            QList<int> jingjies = merry->getPile("jingjie");
            QList<int> able;
            QList<int> disabled;
            foreach (int id, jingjies) {
                if (Sanguosha->getCard(id)->isRed() == isRed)
                    able << id;
                else
                    disabled << id;
            }
            if (able.isEmpty())
                return false;
            


            room->fillAG(jingjies, merry, disabled);
            int card_id = -1;
            card_id = room->askForAG(merry, able, true, "luanying");
            room->clearAG(merry);
            if (card_id > -1) {
                room->obtainCard(player, card_id, true);
                room->touhouLogmessage("#weiya", player, objectName(), QList<ServerPlayer *>(), cardName);
                if (triggerEvent == CardUsed){
                    CardUseStruct use = data.value<CardUseStruct>();
                    use.nullified_list << "_ALL_TARGETS";
                    data = QVariant::fromValue(use);                    
                    //room->setCardFlag(data.value<CardUseStruct>().card, "luanyingSkillNullify");    
                }else if (triggerEvent == CardResponded)
                    room->setPlayerFlag(player, "respNul");
            }
            
        } /* else if (triggerEvent == SlashEffected) {
            SlashEffectStruct effect = data.value<SlashEffectStruct>();
                return true;
        } else if (triggerEvent == CardEffected) {
            CardEffectStruct effect = data.value<CardEffectStruct>();
                return true;
        } */
        return false;
    }
};




LianxiCard::LianxiCard()
{
    will_throw = false;
    m_skillName = "lianxi";
    mute = true;
}
bool LianxiCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    if (targets.length() <= 1) {
        QList<const Player *> targets2;
        IronChain *card = new IronChain(Card::NoSuit, 0);
        card->deleteLater();
        return (card->isAvailable(Self) && !Self->isProhibited(to_select, card) && card->targetFilter(targets2, to_select, Self));
    } else
        return false;

}
bool LianxiCard::targetsFeasible(const QList<const Player *> &targets, const Player *Self) const
{
    return targets.length() <= 2;
}
const Card *LianxiCard::validate(CardUseStruct &use) const
{
    if (use.to.length() <= 2) {
        IronChain *card = new IronChain(Card::NoSuit, 0);
        card->setSkillName("lianxi");
        return card;
    }
    return use.card;
}


class LianxiVS : public ZeroCardViewAsSkill
{
public:
    LianxiVS() :ZeroCardViewAsSkill("lianxi")
    {
        response_pattern = "@@lianxi";
    }

    virtual const Card *viewAs() const
    {
        return new LianxiCard;
    }
};
class Lianxi : public TriggerSkill
{
public:
    Lianxi() : TriggerSkill("lianxi")
    {
        events << CardResponded << CardUsed;
        view_as_skill = new LianxiVS;
    }

    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        if (!TriggerSkill::triggerable(player)) return QStringList();
        if (triggerEvent == CardResponded) {
            CardStar card_star = data.value<CardResponseStruct>().m_card;
            if (card_star->isKindOf("Slash"))
                return QStringList(objectName());
        } else if (triggerEvent == CardUsed) {
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.card->isKindOf("Slash"))
                return QStringList(objectName());
        }
        return QStringList();
    }
    
    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        room->askForUseCard(player, "@@lianxi", "@lianxi");
        return false;
    }
};

class Yueshi : public TriggerSkill
{
public:
    Yueshi() : TriggerSkill("yueshi")
    {
        events << EventPhaseStart;
        frequency = Wake;
    }
    virtual bool triggerable(const ServerPlayer *player) const
    {
        return (player != NULL &&  player->hasSkill(objectName())
            && player->getMark("yueshi") == 0 
            && player->getPhase() == Player::Start && player->isChained());
    }
    
   virtual bool effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        
        room->doLightbox("$yueshiAnimate", 4000);
        room->touhouLogmessage("#YueshiWake", player, "yueshi");
        room->notifySkillInvoked(player, objectName());
        room->addPlayerMark(player, objectName());
        if (room->changeMaxHpForAwakenSkill(player, 1))
            room->handleAcquireDetachSkills(player, "ruizhi");
        
        return false;
    }
};


class Pingyi : public TriggerSkill
{
public:
    Pingyi() : TriggerSkill("pingyi")
    {
        events << Damaged;
    }
    virtual int getPriority(TriggerEvent) const
    {
        return -1;
    }
    static void skill_comeback(Room *room, ServerPlayer *player)
    {
        ServerPlayer * back;
        QString back_skillname;
        foreach (ServerPlayer *p, room->getOtherPlayers(player, true)) {
            if (p->getMark("@pingyi") > 0) {
                QString pingyi_record = player->objectName() + "pingyi" + p->objectName();
                back_skillname = room->getTag(pingyi_record).toString();
                if (back_skillname != NULL && back_skillname != "") {
                    back = p;
                    room->setTag(pingyi_record, QVariant());
                    break;
                }
            }
        }

        if (back != NULL) {

            room->setPlayerMark(player, "pingyi_steal", 0);
            if (back->isAlive()) {
                //room->setPlayerMark(back, "pingyi", back->getMark("pingyi") - 1);
                room->doAnimate(QSanProtocol::S_ANIMATE_INDICATE, player->objectName(), back->objectName());
            }
            room->handleAcquireDetachSkills(player, "-" + back_skillname);

            Json::Value arg(Json::arrayValue);
            arg[0] = (int)QSanProtocol::S_GAME_EVENT_HUASHEN;
            arg[1] = QSanProtocol::Utils::toJsonString(player->objectName());
            arg[2] = QSanProtocol::Utils::toJsonString(player->getGeneral()->objectName());
            arg[3] = QSanProtocol::Utils::toJsonString("clear");
            room->doBroadcastNotify(QSanProtocol::S_COMMAND_LOG_EVENT, arg);

            if (back->isAlive()) {
                //room->handleAcquireDetachSkills(back, back_skillname);
                room->setPlayerMark(back, "pingyi" + back_skillname, 0);
                Json::Value args;
                args[0] = QSanProtocol::S_GAME_EVENT_UPDATE_SKILL;
                room->doBroadcastNotify(QSanProtocol::S_COMMAND_LOG_EVENT, args);
                back->loseMark("@pingyi", 1);
                if (back->hasSkill(back_skillname))
                    room->touhouLogmessage("#pingyiReturnSkill", back, back_skillname);
            }
        }

    }
    
    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        if (!TriggerSkill::triggerable(player)) return QStringList();
        DamageStruct damage = data.value<DamageStruct>();
        if (damage.from && damage.from->isAlive() && damage.from != player) {
            if (player->isNude())
                return QStringList();
        
            foreach (const Skill *skill, damage.from->getVisibleSkillList()) {
                if (skill->isLordSkill() || skill->getFrequency() == Skill::Limited
                    || skill->getFrequency() == Skill::Wake || skill->isAttachedLordSkill()
                    || skill->getFrequency() == Skill::Eternal)
                    continue;
                else {
                    //need check skill both sides
                    if (!player->hasSkill(skill->objectName(), false, true) && damage.from->hasSkill(skill->objectName()))
                        return QStringList(objectName());
                }
            }
        }
        return QStringList();
    }
    
    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        DamageStruct damage = data.value<DamageStruct>();
        QStringList skill_names;
        skill_names << "cancel";

        foreach (const Skill *skill, damage.from->getVisibleSkillList()) {
            if (skill->isLordSkill() || skill->getFrequency() == Skill::Limited
                    || skill->getFrequency() == Skill::Wake || skill->isAttachedLordSkill()
                    || skill->getFrequency() == Skill::Eternal)
                    continue;
            else {
                    //need check skill both sides
                if (!player->hasSkill(skill->objectName(), false, true) && damage.from->hasSkill(skill->objectName()))
                    skill_names << skill->objectName();
            }
        }

        player->tag["pingyi_target"] = QVariant::fromValue(damage.from);

        QString skill_name = room->askForChoice(player, "pingyi", skill_names.join("+"));
        if (skill_name == "cancel")
            return false;

        const Card *card = room->askForCard(player, ".|.|.|.!", "@pingyi-discard:" + damage.from->objectName() + ":" + skill_name, data, Card::MethodDiscard, NULL, true, objectName());
        if (card != NULL) {

            if (player->getMark("pingyi_steal") > 0)
                skill_comeback(room, player);
                //record pingyi     relation and content.
            QString pingyi_record = player->objectName() + "pingyi" + damage.from->objectName();
            room->setTag(pingyi_record, skill_name);

            room->doAnimate(QSanProtocol::S_ANIMATE_INDICATE, player->objectName(), damage.from->objectName());


            room->setPlayerMark(player, "pingyi_steal", 1);
            room->setPlayerMark(damage.from, "pingyi" + skill_name, 1); // skill nullify mark, like Qingcheng
            room->handleAcquireDetachSkills(player, skill_name);

            Json::Value args;
            args[0] = QSanProtocol::S_GAME_EVENT_UPDATE_SKILL;
            room->doBroadcastNotify(QSanProtocol::S_COMMAND_LOG_EVENT, args);

            damage.from->gainMark("@pingyi"); // marks could be greater than 1,since it can be stealed any times.
            room->touhouLogmessage("#pingyiLoseSkill", damage.from, skill_name);

            Json::Value arg(Json::arrayValue);
            arg[0] = (int)QSanProtocol::S_GAME_EVENT_HUASHEN;
            arg[1] = QSanProtocol::Utils::toJsonString(player->objectName());
            arg[2] = QSanProtocol::Utils::toJsonString(damage.from->getGeneral()->objectName());
            arg[3] = QSanProtocol::Utils::toJsonString(skill_name);
            room->doBroadcastNotify(QSanProtocol::S_COMMAND_LOG_EVENT, arg);
        }
        
        return false;
    }
};
class PingyiHandler : public TriggerSkill
{
public:
    PingyiHandler() : TriggerSkill("#pingyi_handle")
    {
        events << EventLoseSkill << Death;
    }

    virtual int getPriority(TriggerEvent) const
    { //caution other skills at Death event ,like chuancheng
        return -1;
    }

    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        if  (player->getMark("@pingyi") == 0 && player->getMark("pingyi_steal") == 0)
            return QStringList();
        
        if (triggerEvent == EventLoseSkill && data.toString() == "pingyi") {
            if (player->getMark("pingyi_steal") > 0 && !player->hasSkill("pingyi"))
                Pingyi::skill_comeback(room, player);

        } else if (triggerEvent == Death) {
            DeathStruct death = data.value<DeathStruct>();
            if (death.who == player && player->getMark("pingyi_steal") > 0)
                Pingyi::skill_comeback(room, player);
            if (death.who == player && player->getMark("@pingyi") > 0) {

                foreach (ServerPlayer *p, room->getOtherPlayers(player)) {
                    if (p->getMark("pingyi_steal") > 0) {
                        QString pingyi_record = p->objectName() + "pingyi" + player->objectName();
                        QString back_skillname = room->getTag(pingyi_record).toString();
                        if (back_skillname != NULL && back_skillname != "")
                            Pingyi::skill_comeback(room, p);
                    }
                }
            }
        }
        return QStringList();
    }
};


ZhesheCard::ZhesheCard()
{
    will_throw = true;
    m_skillName = "zheshe";
    mute = true;
}
bool ZhesheCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.length() == 0;
}
void ZhesheCard::onEffect(const CardEffectStruct &effect) const
{
    Room *room = effect.to->getRoom();
    room->setPlayerMark(effect.to, "zheshetransfer", 1);

    DamageStruct damage; //effect.from->tag["zhesheDamage"].value<DamageStruct>();
    damage.from = effect.from;
    damage.to = effect.to;
    //damage.transfer = true;
    damage.reason = "zheshe";
    room->damage(damage);
}


class ZhesheVS : public OneCardViewAsSkill
{
public:
    ZhesheVS() :OneCardViewAsSkill("zheshe")
    {
        filter_pattern = ".|.|.|hand!";//"^EquipCard!" ;
        response_pattern = "@@zheshe";
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return false;
    }

    virtual const Card *viewAs(const Card *originalCard) const
    {
        ZhesheCard *card = new ZhesheCard;
        card->addSubcard(originalCard);

        return card;
    }
};
class Zheshe : public TriggerSkill
{
public:
    Zheshe() : TriggerSkill("zheshe")
    {
        events << DamageInflicted;
        view_as_skill = new ZhesheVS;
    }

    virtual bool trigger(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        DamageStruct damage = data.value<DamageStruct>();
        if (player == damage.from)
            return false;
        //if (damage.transfer)
        //return false;
        player->tag["zhesheDamage"] = data;
        const Card *card = room->askForUseCard(player, "@@zheshe", "@zheshe", -1, Card::MethodDiscard);
        if (card != NULL)
            return true;
        return false;
    }
};
class ZhesheEffect : public TriggerSkill
{
public:
    ZhesheEffect() : TriggerSkill("#zheshedraw")
    {
        events << DamageComplete;
    }
    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        DamageStruct damage = data.value<DamageStruct>();
        if (damage.to->isAlive() && damage.to->getMark("zheshetransfer") > 0 && damage.reason == "zheshe") 
            return QStringList(objectName());
        return QStringList();
    }
    virtual bool effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        DamageStruct damage = data.value<DamageStruct>();
        room->setPlayerMark(damage.to, "zheshetransfer", 0);
        damage.to->drawCards(damage.to->getLostHp());
        return false;
    }
};



class Tanchi : public TriggerSkill
{
public:
    Tanchi() : TriggerSkill("tanchi")
    {
        events << PreHpRecover;
        frequency = Compulsory;
    }

    virtual bool effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        room->touhouLogmessage("#TriggerSkill", player, objectName());
        room->notifySkillInvoked(player, objectName());
        RecoverStruct recover = data.value<RecoverStruct>();
        recover.recover = recover.recover + 1;
        data = QVariant::fromValue(recover);
        return false;
    }
};

ZhuonongCard::ZhuonongCard()
{
    m_skillName = "zhuonong";
    mute = true;
}
bool ZhuonongCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.length() == 0;
}
void ZhuonongCard::onEffect(const CardEffectStruct &effect) const
{
    Room *room = effect.to->getRoom();
    effect.from->tag["zhuonong_target"] = QVariant::fromValue(effect.to);
    QString choice = room->askForChoice(effect.from, "zhuonong", "rd+dr", QVariant::fromValue(effect.to));
    RecoverStruct recover;
    recover.who = effect.from;
    DamageStruct damage(objectName(), effect.from, effect.to, 1, DamageStruct::Fire);
    if (choice == "rd" && effect.to->isWounded())
        room->recover(effect.to, recover);
    room->damage(damage);
    if (choice == "dr" && effect.to->isWounded())
        room->recover(effect.to, recover);
}
class Zhuonong : public ZeroCardViewAsSkill
{
public:
    Zhuonong() :ZeroCardViewAsSkill("zhuonong")
    {
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("ZhuonongCard");
    }

    virtual const Card *viewAs() const
    {
        return new ZhuonongCard;
    }
};

class Jijing : public TriggerSkill
{
public:
    Jijing() : TriggerSkill("jijing")
    {
        events << Damaged;
        frequency = Compulsory;
    }
    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        DamageStruct damage = data.value<DamageStruct>();
        ServerPlayer *luna = room->findPlayerBySkillName(objectName());
        if (!luna || !luna->isCurrent())//luna->getPhase() == Player::NotActive
            return QStringList();
		if (damage.to->getMark("@jijing") > 0) 
            return QStringList();
        if (!damage.to  || damage.to->isDead() || damage.to == luna)
           return QStringList();
        return QStringList(objectName());
    }
    virtual bool effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        DamageStruct damage = data.value<DamageStruct>();
        ServerPlayer *luna = room->findPlayerBySkillName(objectName());
        
        room->notifySkillInvoked(luna, objectName());
        room->setFixedDistance(luna, damage.to, 1);
        damage.to->gainMark("@jijing", 1);
        room->setPlayerFlag(luna, "jijing");
        return false;
    }
};
class JijingClear : public TriggerSkill
{
public:
    JijingClear() : TriggerSkill("#jijing")
    {
        events << EventPhaseChanging;
    }
    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        PhaseChangeStruct change = data.value<PhaseChangeStruct>();
        if (change.to == Player::NotActive && player->hasFlag("jijing")) {
            foreach (ServerPlayer *p, room->getOtherPlayers(player)) {
                if (p->getMark("@jijing") > 0) {
                    room->setFixedDistance(player, p, -1);
                    p->loseAllMarks("@jijing");
                }
            }
        }
        return QStringList();
    }
};

class Ganying : public TriggerSkill
{
public:
    Ganying() : TriggerSkill("ganying")
    {
        events << GameStart << EventAcquireSkill; //<< EventLoseSkill //Debut??
    }
    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        if (triggerEvent == GameStart || (triggerEvent == EventAcquireSkill && data.toString() == "ganying")) {
            if (player && player->hasSkill(objectName())) {
                //reset distance record.
                room->setPlayerMark(player, "ganying_owner", 1);
                foreach (ServerPlayer *p, room->getOtherPlayers(player)) {
                    QString mark = player->objectName() + "_ganying_" + p->objectName();
                    //this data will be recorded by from
                    room->setPlayerMark(player, mark, player->distanceTo(p));
                    QString mark1 = p->objectName() + "_ganying_" + player->objectName();
                    room->setPlayerMark(p, mark1, p->distanceTo(player));
                }
                foreach (ServerPlayer *p, room->getAlivePlayers()) {
                    if (!p->hasSkill("#ganying_handle"))
                        room->acquireSkill(p, "#ganying_handle");
                }
            }
        }

        return QStringList();
    }
};

class GanyingHandler : public TriggerSkill
{
public:
    GanyingHandler() : TriggerSkill("#ganying_handle")
    {
        events << EventAcquireSkill << EventLoseSkill << HpChanged << Death << CardsMoveOneTime
            << MarkChanged;
        //<< EventPhaseChanging
    }

    static void ganying_effect(ServerPlayer *player, QList<ServerPlayer *> targets)
    {
        Room *room = player->getRoom();
        ServerPlayer *target = room->askForPlayerChosen(player, targets, "ganying", "@ganying", true, true);
        if (target == NULL)
            return;
        int id = room->askForCardChosen(player, target, "h", "ganying", false, Card::MethodDiscard);
        room->throwCard(id, target, player);
    }

    virtual void record(TriggerEvent triggerEvent, Room *room, ServerPlayer *mokou, QVariant &data) const
    {
        if (triggerEvent == EventAcquireSkill || triggerEvent == EventLoseSkill) {
            if (data.toString() == "ganying")
                return ;
        }
        if (triggerEvent == CardsMoveOneTime) {
            CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
            if (move.from != NULL && move.from->hasFlag("rengui_InTempMoving"))
                return;
        }
        if (triggerEvent == MarkChanged) {
            MarkChangeStruct change = data.value<MarkChangeStruct>();
            if (change.name != "@pingyi" && change.name != "@changshi")
                return;
        }
        foreach (ServerPlayer *p, room->getAlivePlayers()) {
            if (p->getMark("ganying_owner") > 0) {//cause skill "changshi", we need record distance any time.
                bool distance_change_one_time = false;
                //QList<ServerPlayer *> targets;
                QVariantList targets;
                foreach (ServerPlayer *target, room->getOtherPlayers(p)) {
                    QString markname = p->objectName() + "_ganying_" + target->objectName();
                    QString markname1 = target->objectName() + "_ganying_" + p->objectName();
                    int n = p->getMark(markname);
                    int n1 = target->getMark(markname1);
                    if ((n > 0 && n != p->distanceTo(target)) ||
                        n1 > 0 && n1 != target->distanceTo(p)) {
                        distance_change_one_time = true;
                        if (p->hasSkill("ganying") && p->canDiscard(target, "h"))
                            targets << target->getSeat();
                    }
                    room->setPlayerMark(p, markname, p->distanceTo(target));
                    room->setPlayerMark(target, markname1, target->distanceTo(p));
                }
                if (distance_change_one_time && p->hasSkill("ganying")) {
                    p->tag["ganyingInvoke"] = true;
                    p->tag["ganyingTargets"] = targets;
					
                }
            }
        }
    }
    
    
    virtual TriggerList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
		
		TriggerList skill_list;
        foreach (ServerPlayer *p, room->getAlivePlayers()) {
            if (p->hasSkill("ganying") && p->tag["ganyingInvoke"].toBool()){
                skill_list.insert(p, QStringList(objectName()));
			}
        }
        return skill_list;
    }
    
    
    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *p) const
    {
        p->tag["ganyingInvoke"] = false;
        if (room->askForSkillInvoke(p, "ganying", data)) 
            return true;
        p->tag.remove("ganyingTargets");
        return false;
    }
    
    virtual bool effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *p) const
    {
        QVariantList seats = p->tag["ganyingTargets"].toList();
        QList<ServerPlayer *> targets;
        foreach (ServerPlayer *target, room->getOtherPlayers(p)) {
            if (seats.contains(target->getSeat()))
                targets << target;
        }
        p->tag.remove("ganyingTargets");
        
        p->drawCards(1);
        ganying_effect(p, targets);
        return false;
    }
    
};

class Zhujiu : public TriggerSkill
{
public:
    Zhujiu() : TriggerSkill("zhujiu")
    {
        events << TargetConfirmed; 
    }

    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        if (!TriggerSkill::triggerable(player)) return QStringList();
        CardUseStruct use = data.value<CardUseStruct>();
        if (use.card->isKindOf("Peach") || use.card->isKindOf("Analeptic")) {
                foreach (ServerPlayer *to, use.to) {
                    if (player != to && !player->isNude())
                        return QStringList(objectName());
                }
        }
        return QStringList();
    }

    
    
    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        CardUseStruct use = data.value<CardUseStruct>();
        foreach (ServerPlayer *to, use.to) {
            if (player != to && !player->isNude()) {
                 player->tag["zhujiu_target"] = QVariant::fromValue(to);
                const Card *card = room->askForCard(player, "..", "@zhujiu:" + to->objectName(), data, Card::MethodNone); 
                if (card){
                    room->notifySkillInvoked(player, objectName());
                    room->touhouLogmessage("#InvokeSkill", player, objectName());
                    room->obtainCard(to, card->getEffectiveId(), room->getCardPlace(card->getEffectiveId()) != Player::PlaceHand);
                    player->drawCards(1);
                }
            }
        }
        return false;
    }
};


YushouCard::YushouCard()
{
    m_skillName = "yushou";
    mute = true;
}
bool YushouCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{

    if (targets.length() == 0) {
        return !to_select->getEquips().isEmpty();
    } else if (targets.length() == 1) {
        foreach (const Card *e, targets.first()->getEquips()) {
            const EquipCard *equip = qobject_cast<const EquipCard *>(e->getRealCard());
            if (!to_select->getEquip(equip->location()))
                return true;
        }
    }
    return false;
}
bool YushouCard::targetsFeasible(const QList<const Player *> &targets, const Player *Self) const
{
    return targets.length() == 2;
}

void YushouCard::onUse(Room *room, const CardUseStruct &card_use) const
{
    ServerPlayer *from = card_use.from;
    ServerPlayer *to1 = card_use.to.at(0);
    ServerPlayer *to2 = card_use.to.at(1);
    QList<ServerPlayer *>logto;
    logto << to1 << to2;
    room->touhouLogmessage("#ChoosePlayerWithSkill", from, "yushou", logto, "");
    room->notifySkillInvoked(card_use.from, "yushou");
    QList<int> disable;
    
    
    foreach (const Card *e, to1->getEquips()){
        const EquipCard *equip = qobject_cast<const EquipCard *>(e->getRealCard());
        if (to2->getEquip(equip->location())){
            disable << e->getEffectiveId();
        }        
    }
    from->tag["yushou_target"] = QVariant::fromValue(to2);
    to1->tag["yushou_target"] = QVariant::fromValue(to2);
    int card_id = room->askForCardChosen(from, to1, "e", "yushou", false, Card::MethodNone, disable);

    const Card *card = Sanguosha->getCard(card_id);
    room->moveCardTo(card, to1, to2, Player::PlaceEquip,
                             CardMoveReason(CardMoveReason::S_REASON_TRANSFER,
                                            from->objectName(), "yushou", QString()));
    
    QString choice = room->askForChoice(to1, "yushou", "damage+cancel");
    if (choice == "damage")
        room->damage(DamageStruct("yushou", to1, to2, 1, DamageStruct::Normal));

}
class Yushou : public ZeroCardViewAsSkill
{
public:
    Yushou() :ZeroCardViewAsSkill("yushou")
    {
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("YushouCard");
    }

    virtual const Card *viewAs() const
    {
        return new YushouCard;
    }
};

PanduCard::PanduCard()
{
    handling_method = Card::MethodUse;
    mute = true;
}
bool PanduCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.length() == 0 && !to_select->isKongcheng() && to_select != Self;
}
void PanduCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    ServerPlayer *target = targets.first();
    int card_id = room->askForCardChosen(source, target, "h", "pandu");
    room->showCard(target, card_id);
    Card *showcard = Sanguosha->getCard(card_id);
    if (showcard->isKindOf("Slash")) {
        if (!target->isCardLimited(showcard, Card::MethodUse))
            room->useCard(CardUseStruct(showcard, target, source), false);
    } else if (!showcard->isKindOf("BasicCard"))
        room->obtainCard(source, showcard, true);

}
class Pandu : public ZeroCardViewAsSkill
{
public:
    Pandu() : ZeroCardViewAsSkill("pandu")
    {
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("PanduCard");
    }

    virtual const Card *viewAs() const
    {
        return new PanduCard;
    }
};

class Bihuo : public TriggerSkill
{
public:
    Bihuo() : TriggerSkill("bihuo")
    {
        events << TargetConfirming;
    }

    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        if (!TriggerSkill::triggerable(player)) return QStringList();
         CardUseStruct use = data.value<CardUseStruct>();
        if (use.card->isKindOf("Slash") && !player->isKongcheng()) {
            foreach (ServerPlayer *p, room->getOtherPlayers(player)) {
                if (use.from->canSlash(p, use.card, false) || !use.to.contains(p))
                    return QStringList(objectName());
            }
        }
        return QStringList();
    }
    
    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        CardUseStruct use = data.value<CardUseStruct>();
        
        QList<ServerPlayer *> targets;
        foreach (ServerPlayer *p, room->getOtherPlayers(player)) {
            if (use.from->canSlash(p, use.card, false) && !use.to.contains(p))
                targets << p;
        }
        QString prompt = "@bihuo-playerchosen:" + use.from->objectName();
        ServerPlayer *target = room->askForPlayerChosen(player, targets, objectName(), prompt, true, true);
        if (target) {
            DummyCard *dummy = new DummyCard;
            dummy->deleteLater();
            dummy->addSubcards(player->getCards("h"));
            int num = dummy->subcardsLength();
            room->obtainCard(target, dummy, false);

            int tmp = player->tag["bihuo_num_" + player->objectName()].toInt();
            if (tmp == NULL)  tmp = 0;
            target->tag["bihuo_num_" + player->objectName()] = QVariant::fromValue(tmp + num);

            room->setPlayerFlag(target, "bihuo_" + player->objectName());


            use.to << target;
            use.to.removeOne(player);
            data = (QVariant::fromValue(use));

            QList<ServerPlayer *> logto;
            logto << player;
            QList<ServerPlayer *> logto1;
            logto1 << target;
            room->touhouLogmessage("$CancelTarget", use.from, use.card->objectName(), logto);
            room->touhouLogmessage("#huzhu_change", use.from, use.card->objectName(), logto1);

            room->getThread()->trigger(TargetConfirming, room, target, data);
        }
        
        return false;
    }
};

class BihuoReturn : public TriggerSkill
{
public:
    BihuoReturn() : TriggerSkill("#bihuo")
    {
        events << EventPhaseChanging;
    }
    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer* &) const
    {
        PhaseChangeStruct change = data.value<PhaseChangeStruct>();
        if (change.to == Player::NotActive) {
            foreach (ServerPlayer *s, room->getAlivePlayers()) {
                QString flag = "bihuo_" + s->objectName();
                foreach (ServerPlayer *p, room->getOtherPlayers(s)) {
                    if (p->hasFlag(flag)) {
                        p->setFlags("-" + flag);
                        int num = p->tag["bihuo_num_" + s->objectName()].toInt();
                        p->tag.remove("bihuo_num_" + s->objectName());
                        if (!p->isKongcheng()) {
                            int count = qMin(p->getHandcardNum(), num);
                            const Card *cards = room->askForExchange(p, "bihuo", count, false, "bihuo_exchange:" + QString::number(count) + ":" + s->objectName());
                            room->obtainCard(s, cards, false);
                        }
                    }
                }

            }
        }
        return QStringList();
    }
};



TH99Package::TH99Package()
    : Package("th99")
{
    General *wai001 = new General(this, "wai001$", "wai", 3, false);
    wai001->addSkill(new Qiuwen);
    wai001->addSkill(new Zaozu);
    wai001->addSkill(new Dangjia);

    General *wai002 = new General(this, "wai002", "wai", 4, true);
    wai002->addSkill(new Xiufu);
    //wai002->addSkill(new XiufuCheck);
    //related_skills.insertMulti("xiufu", "#xiufu");

    General *wai003 = new General(this, "wai003", "wai", 3, false);
    wai003->addSkill(new Fandu);
    wai003->addSkill(new Taohuan);

    General *wai004 = new General(this, "wai004", "wai", 4, false);
    wai004->addSkill(new Shitu);

    General *wai005 = new General(this, "wai005", "wai", 4, false);
    wai005->addSkill("jingjie");
    wai005->addSkill(new Mengxian);
    wai005->addRelateSkill("luanying");

    General *wai006 = new General(this, "wai006", "wai", 3, false);
    wai006->addSkill(new Lianxi);
    wai006->addSkill(new Yueshi);

    General *wai007 = new General(this, "wai007", "wai", 4, false);
    wai007->addSkill(new Pingyi);
    wai007->addSkill(new PingyiHandler);
    related_skills.insertMulti("pingyi", "#pingyi_handle");


    General *wai008 = new General(this, "wai008", "wai", 4, false);
    wai008->addSkill(new Zheshe);
    wai008->addSkill(new ZhesheEffect);
    wai008->addSkill(new Tanchi);
    related_skills.insertMulti("zheshe", "#zheshedraw");

    General *wai009 = new General(this, "wai009", "wai", 4, false);
    wai009->addSkill(new Zhuonong);
    wai009->addSkill(new Jijing);
    wai009->addSkill(new JijingClear);
    related_skills.insertMulti("jijing", "#jijing");

    General *wai010 = new General(this, "wai010", "wai", 4, false);
    wai010->addSkill(new Ganying);

    General *wai011 = new General(this, "wai011", "wai", 4, false);
    wai011->addSkill(new Zhujiu);
    wai011->addSkill(new Yushou);
    
    General *wai012 = new General(this, "wai012", "wai", 3, false);
    wai012->addSkill(new Pandu);
    wai012->addSkill(new Bihuo);
    wai012->addSkill(new BihuoReturn);
    related_skills.insertMulti("bihuo", "#bihuo");

    addMetaObject<QiuwenCard>();
    addMetaObject<DangjiaCard>();
    addMetaObject<XiufuCard>();
	addMetaObject<XiufuFakeMoveCard>();
    addMetaObject<LianxiCard>();
    addMetaObject<ZhesheCard>();
    addMetaObject<ZhuonongCard>();
    addMetaObject<YushouCard>();
    addMetaObject<PanduCard>();
    skills << new DangjiaVS << new Luanying << new GanyingHandler;
}

ADD_PACKAGE(TH99)

