#ifndef _th08_H
#define _th08_H

#include "package.h"
#include "card.h"


class miyaoCard : public SkillCard {
    Q_OBJECT

public:
    Q_INVOKABLE miyaoCard();

    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    virtual void onEffect(const CardEffectStruct &effect) const;
};

class kuangzaoCard : public SkillCard {
    Q_OBJECT

public:
    Q_INVOKABLE kuangzaoCard();

    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

/*class lxhuanshiCard: public SkillCard {
    Q_OBJECT

public:
    Q_INVOKABLE lxhuanshiCard();

    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};*/

class buxianCard : public SkillCard {
    Q_OBJECT

public:
    Q_INVOKABLE buxianCard();

    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    virtual bool targetsFeasible(const QList<const Player *> &targets, const Player *Self) const;
    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};


class chuangshiCard : public SkillCard{
    Q_OBJECT

public:
    Q_INVOKABLE chuangshiCard();


    virtual void onUse(Room *room, const CardUseStruct &card_use) const;
    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    virtual bool targetsFeasible(const QList<const Player *> &targets, const Player *Self) const;
    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;


};





class tymhhuweiCard : public SkillCard {
    Q_OBJECT

public:
    Q_INVOKABLE tymhhuweiCard();

    virtual const Card *validate(CardUseStruct &card_use) const;
};

class jinxiCard : public SkillCard {
    Q_OBJECT

public:
    Q_INVOKABLE jinxiCard();

    virtual void onUse(Room *room, const CardUseStruct &card_use) const;
    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class th08Package : public Package {
    Q_OBJECT

public:
    th08Package();
};

#endif
