--【求闻】ailocal qiuwen_skill = {}qiuwen_skill.name = "qiuwen"table.insert(sgs.ai_skills, qiuwen_skill)qiuwen_skill.getTurnUseCard = function(self)	local can_use=false	if self.player:hasUsed("qiuwenCard") then return nil end	if self.player:hasSkill("zaozu") then		if self:getOverflow() > 0 then			can_use=true		else			if self.player:getHp()>=3 then 				can_use=true			end		end	else		can_use=true	end	if can_use then		return sgs.Card_Parse("@qiuwenCard=.")	end	return nilendsgs.ai_skill_use_func.qiuwenCard=function(card,use,self)	use.card = cardendsgs.ai_use_value.qiuwenCard = 7sgs.ai_use_priority.qiuwenCard = 7--【早卒】ai 锁定技 不需要--【当家】ailocal dangjiavs_skill = {}dangjiavs_skill.name = "dangjiavs"table.insert(sgs.ai_skills, dangjiavs_skill)dangjiavs_skill.getTurnUseCard = function(self)	if self.player:getKingdom()~="wai" then return nil end	if self.player:isKongcheng() or self:needBear()  or self.player:hasFlag("Forbiddangjia") then return nil end		local lord	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do		if player:hasLordSkill("dangjia") and not player:isKongcheng() and not player:hasFlag("dangjiaInvoked") then			lord=player			break		end	end	if not lord then return nil end	if not lord:isWounded() then return nil end		if  lord:isKongcheng() then		return nil	end	--暂时不考虑反贼通过【当家】来获利	if self:isEnemy(lord)  then		return nil	end		return sgs.Card_Parse("@dangjiaCard=.")endsgs.ai_skill_use_func.dangjiaCard = function(card, use, self)	local lord	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do		if player:hasLordSkill("dangjia") and not player:isKongcheng() and not player:hasFlag("Forbiddangjia") then			lord=player			break		end	end	local cards = self.player:getHandcards()	local max_num = 0, max_card	local min_num = 14, min_card		for _, hcard in sgs.qlist(cards) do			if hcard:isKindOf("Peach") then continue end			if hcard:getNumber() > max_num then				max_num = hcard:getNumber()				max_card = hcard			end			if hcard:getNumber() <= min_num then				if hcard:getNumber() == min_num then					if min_card and self:getKeepValue(hcard) > self:getKeepValue(min_card) then						min_num = hcard:getNumber()						min_card = hcard					end				else					min_num = hcard:getNumber()					min_card = hcard				end			end		end	if not min_card then return nil end		--很大概率主公赢不了	if min_card:getNumber()>=12 then return nil end	if min_card:getNumber()>9 and lord:getHandcardNum()<=4 then		local lord_card = self:getMaxCard(lord)		if not lord_card or lord_card:getNumber() < min_card:getNumber() then			return nil		end	end	if self:isFriend(lord) then		self.dangjia_card = min_card:getEffectiveId()		--str="@dangjiaCard=."			use.card = card			if use.to then use.to:append(lord) end			return	endend--响应拼点者的应对function sgs.ai_skill_pindian.dangjia(minusecard, self, requestor, maxcard)	return self:getMaxCard()end--[[sgs.ai_card_intention.dangjiavs = function(self, card, from, to)	if to[1]:isWounded() then		sgs.updateIntentions(from, to, 0)	else		sgs.updateIntentions(from, to, 20)	endend]]sgs.ai_choicemade_filter.pindian.dangjia = function(self, from, promptlist)	local number = sgs.Sanguosha:getCard(tonumber(promptlist[4])):getNumber()	local lord = findPlayerByObjectName(self.room, promptlist[5])	if not lord then return end		if number < 6 then sgs.updateIntention(from, lord, -60)	elseif number > 8 and lord:getHandcardNum()<=4 and self:isEnemy(lord,from) then 	--反贼【当家】时 目前ai反贼不会利用当家 这个仇恨更新只能针对人类玩家		sgs.updateIntention(from, lord, 60) 	endend--只在filter event时调用 时机是出牌阶段结束时function SmartAI:dangjiaIntention(player)	local lord=self.room:getLord()	if lord and lord:hasLordSkill("dangjia") and lord:isWounded() and lord:getHandcardNum()>=5 		and not lord:hasFlag("dangjiaInvoked") 		and player:getKingdom()=="wai" and not  player:hasFlag("PlayPhaseTerminated") then				local overflow  =self:getOverflow(player)>0		if player:hasSkill("shoucang") then--目前没有弃牌阶段靠弃牌发动技能的			overflow  =self:getOverflow(player)>1		end		if overflow then			sgs.updateIntention(player, lord, 30)		end	endend--【修复】ailocal xiufu_skill = {}xiufu_skill.name = "xiufu"table.insert(sgs.ai_skills, xiufu_skill)xiufu_skill.getTurnUseCard = function(self)	if self.player:hasUsed("xiufuCard") then return nil end	if self.player:getMark("can_xiufu")==0 then return nil end	return sgs.Card_Parse("@xiufuCard=.")endsgs.ai_skill_use_func.xiufuCard=function(card,use,self)	use.card = cardendsgs.ai_skill_askforag.xiufu = function(self, card_ids)	--通用情况	local weapons={}	local armors={}	local dhorses={}	local ohorses={}	local treasures={}	local weapon_targets={}	local armor_targets={}	local dhorse_targets={}	local ohorse_targets={}	local treasure_targets={}	local wounded_silverlion		--对魔里沙的部分考虑得很简单	--天仪魔里沙暂时没考虑	local spades={}	local baoyi 	local baoyi_id			local chosen_cards_id=-1	local target		for _,card_id in pairs(card_ids) do		local card=sgs.Sanguosha:getCard(card_id)		if card:getSuit()==sgs.Card_Spade  then			table.insert(spades,card_id)		end		if card:isKindOf("Weapon") then 			table.insert(weapons,card_id)		elseif card:isKindOf("Armor") then 			table.insert(armors,card_id)		elseif card:isKindOf("DefensiveHorse") then			table.insert(dhorses,card_id)		elseif card:isKindOf("OffensiveHorse") then			table.insert(ohorses,card_id)		elseif card:isKindOf("Treasure") then			table.insert(treasures,card_id)		end	end		for  _,p in pairs(self.friends) do		if not p:getEquip(0) then			table.insert(weapon_targets,p)		end		if not p:getEquip(1) then			table.insert(armor_targets,p)		end		if not p:getEquip(2) then			table.insert(dhorse_targets,p)		end		if not p:getEquip(3) then			table.insert(ohorse_targets,p)		end		if not p:getEquip(4) then			table.insert(treasure_targets,p)		end		if p:hasSkills("baoyi|jiezou") then			for _,id in  pairs(spades) do				--local card=sgs.Sanguosha:getCard(id)				local card=sgs.Sanguosha:getCard(id):getRealCard():toEquipCard()				local n=card:location()				if not p:getEquip(n) then					baoyi_id=id					break				end			end							if not baoyi_id then				if not player:getEquip(0) then					baoyi_id=weapons[1]				elseif not player:getEquip(1) then					baoyi_id=armors[1]				elseif not player:getEquip(2) then					baoyi_id=dhorses[1]				elseif not player:getEquip(3) then									baoyi_id=ohorses[1]				end			end			if baoyi_id then				baoyi=p			end		end		if p:isWounded() and p:getEquip(1) and p:getEquip(1):isKindOf("SilverLion") then			wounded_silverlion=p		end	end	if baoyi and baoyi_id then		chosen_cards_id=baoyi_id		target=baoyi	elseif #armors>0 and wounded_silverlion then		chosen_cards_id=armors[1]		target=wounded_silverlion	elseif #armors>0 and #armor_targets>0 then		chosen_cards_id=armors[1]		self:sort(armor_targets,"hp")		target=armor_targets[1]	elseif #dhorses>0 and #dhorse_targets>0 then		chosen_cards_id=dhorses[1]		self:sort(dhorse_targets,"hp")		target=dhorse_targets[1]	elseif #treasures>0 and #treasure_targets>0 then		chosen_cards_id=treasures[1]		target=treasure_targets[1]	elseif #ohorses>0 and #ohorse_targets>0 then		chosen_cards_id=ohorses[1]		target=ohorse_targets[1]	elseif #weapons>0 and #weapon_targets>0 then		chosen_cards_id=weapons[1]		target=weapon_targets[1]	end	--优先度 防具 +1 -1 武器	if chosen_cards_id >-1  and target then		self.player:setTag("xiufu_equipid",sgs.QVariant(chosen_card_id))		 local _data = sgs.QVariant()        _data:setValue(target)		self.player:setTag("xiufu_target",_data)		return chosen_card_id 	end	self.player:setTag("xiufu_equipid",sgs.QVariant(card_ids[1]) )	return card_ids[1]endsgs.ai_skill_playerchosen.xiufu = function(self, targets)	card_id=self.player:getTag("xiufu_equipid"):toInt()	local target=self.player:getTag("xiufu_target"):toPlayer()	if not target then return self.friends[1] end	return targetend--sgs.ai_use_value.xiufu = 7--sgs.ai_use_priority.xiufu = 7sgs.ai_playerchosen_intention.xiufu = -60--【泛读】ai --其实还是有不适合泛读的时候。。。--方便讨还，选择敌人。sgs.ai_skill_invoke.fandu = truesgs.ai_skill_playerchosen.fandu = function(self, targets)	if #self.enemies==0  then return targets:first() end	local target_table={}	local return_table={}	local maybereturn_table={}	self:sort(self.enemies,"handcard")	for _,p in pairs(self.enemies) do		if p:getHandcardNum()==1 then			table.insert(target_table,p)		end		if p:getHandcardNum()==2 then			table.insert(return_table,p)		end		if p:getHandcardNum()>2 then			table.insert(maybereturn_table,p)		end	end	if #target_table==0 and #return_table==0 and #maybereturn_table==0 then		return targets:first()	end	local card_number=self:getMaxCard():getNumber()	local target	if #return_table>0 and card_number>7 then		target = return_table[1]	elseif #maybereturn_table>0 and card_number>10 then		target = maybereturn_table[1]	elseif #target_table>0 then			target = target_table[1]	elseif #return_table>0 then		target = return_table[1]	elseif #maybereturn_table>0 then		target = maybereturn_table[1]	end	if target then 		return target	end	return targets:first()end--【讨还】ai  sgs.ai_skill_invoke.taohuan = function(self)	local target=self.player:getTag("taohuantarget"):toPlayer()	if self:isFriend(target) then		return false	end	self.taohuan_card= self:getMaxCard():getEffectiveId()	return trueend--[[sgs.ai_skill_invoke.taohuanshow = function(self)	local target=self.player:getTag("taohuantarget"):toPlayer()	if self:isFriend(target) then		return false	end	return trueend]]function sgs.ai_skill_pindian.taohuan(minusecard, self, requestor, maxcard)	return self:getMaxCard()endsgs.ai_choicemade_filter.skillInvoke.taohuan = function(self, player, promptlist)	local to = player:getTag("taohuantarget"):toPlayer()	if  to and player:objectName()~= to:objectName() then		if promptlist[#promptlist] == "yes" then			sgs.updateIntention(player, to, 50)		else			sgs.updateIntention(player, to, -10)		end		endend--【识途】aisgs.ai_skill_playerchosen.shitu = function(self, targets)	local target_table = self:getFriends(self.player)	if #target_table==0 then return false end	local shitu_target	self:sort(target_table, "handcard")	for _,target in pairs(target_table) do			if not shitu_target then			shitu_target=target		end		if self:isWeak(target) then			shitu_target=target		end	end	if shitu_target then	return shitu_target	end	return nilendsgs.ai_playerchosen_intention.shitu = -60--【梦现】ai觉醒技 不需要sgs.ai_needToWake.yueshi=function(self,player)	--具体的pile数还需要细化	return "Damage","StartPhase"end--【乱影】ai  --还要分对敌压制对己保护两部分判断。。。--设计到源码改动处 暂时不细化此ai。。。sgs.ai_skill_invoke.luanying = function(self)	local target=self.room:getTag("luanying_target"):toPlayer()	self.room:removeTag("luanying_target")	if self:isEnemy(target) then		local use=self.player:getTag("luanying_use"):toCardUse()		if use and use.to then			for _,p in sgs.qlist(use.to) do				if use.card:isKindOf("Slash") and self:isFriend(p)then					return true				end				if (use.card:isKindOf("Analeptic") or use.card:isKindOf("Peach"))and self:isEnemy(p)then					return true				end			end			--主忠内 主内反 避免三方混战时有点坑。。。			return false		end		return true	end	return falseendsgs.ai_skill_askforag.luanying = function(self, card_ids)	--考虑神隐八云紫作为敌友的情况下，还要给牌排序....	local cards={}	for _,card_id in pairs(card_ids) do		local card=sgs.Sanguosha:getCard(card_id)		table.insert(cards,card)	end	self:sortByCardNeed(cards, false)	return cards[1]:getId()	--return card_ids[1]end--【连系】aisgs.ai_skill_use["@@lianxi"] = function(self, prompt)	local need_recast=false	if self:getOverflow() <=0 then 		need_recast=true	end	if self:getCardsNum("Slash")==0 then		need_recast=true	end	local dummy_use = { isDummy = true, to = sgs.SPlayerList() }		local card=sgs.Sanguosha:cloneCard("iron_chain", sgs.Card_NoSuit, 0)	card:setSkillName("lianxi")	local target		self:useTrickCard(card, dummy_use)	if not dummy_use.card then return false end	if dummy_use.to:isEmpty()  or need_recast then		return dummy_use.card:toString()	else		local target_objectname = {}		for _, p in sgs.qlist(dummy_use.to) do			table.insert(target_objectname, p:objectName())			if #target_objectname==2 then break end		end		return dummy_use.card:toString() .. "->" .. table.concat(target_objectname, "+")	end	return dummy_use.card:toString()endsgs.ai_cardneed.lianxi = function(to, card, self)	return  card:isKindOf("Slash")end--【月使】ai觉醒技function SmartAI:needWakeYueshi(player)	player = player or self.player	if not player:hasSkill("yueshi") then return false end	if player:getMark("yueshi")>0 then return false end	--由于铁锁状态容易被打乱	--所以要求座次		local current=self.room:getCurrent()	local enemy_num=0	local current_seat=current:getSeat()	local player_seat=player:getSeat()	if player:objectName()==current:objectName() then		for _,p in sgs.qlist(self.room:getOtherPlayers(player))do				if not self:isFriend(p,player) then					enemy_num=enemy_num+1				end		end	elseif player_seat>current_seat then		for _,p in sgs.qlist(self.room:getOtherPlayers(player))do			if p:getSeat()>=current_seat and 			p:getSeat()<player_seat then				if not self:isFriend(p,player) then					enemy_num=enemy_num+1				end			end		end	elseif player_seat>current_seat then		for _,p in sgs.qlist(self.room:getOtherPlayers(player))do			if p:getSeat()>=current_seat or 			p:getSeat()<player_seat then				if not self:isFriend(p,player) then					enemy_num=enemy_num+1				end			end		end	end	return enemy_num<=1endsgs.ai_needToWake.yueshi=function(self,player)	return "Chained","StartPhase"end--【凭依】ai --如何选择好技能。。。--队友的春意还可以拿来加上限。。。--可以拿掉队友的早卒？？--可以拿断罪？？--神恋和凭依说不清的关系。。。--1 eventfilter中 loseskill事件来更新仇恨local function pingyi_skillname(player)	local skillname	local room=player:getRoom()	for _,p in sgs.qlist(room:getOtherPlayers(player,true))do			if (p:getMark("pingyi")>0)then				local pingyi_record =player:objectName().."pingyi"..p:objectName()				skillname =room:getTag(pingyi_record):toString()				if (skillname and skillname ~="" ) then					return skillname				end			end	end	return nilendlocal goodSkills={"lingqi","mofa","saiqian","jiezou","shoucang","baoyi","chunxi","bllmwuyu","qiangyu",	"mingyun","shengyan","huisu","bolan","zhanyi","bingpo","zhenye","qiyue","juxian",	"sidie","jingjie","zhaoliao","jiaoxia","louguan","renou","yaoshu","jiyi","baochun","chunyi","mocao","shenyin","wangwu","hpymsiyu","juhe",	"yongheng","ruizhi","miyao","bumie","lxhuanshi","xushi","buxian","yemang","chongqun","chuangshi","tymhhuwei",	"shenpan","mingtu","weiya","judu","toupai","doujiu","feixiang","jingdian","kuaizhao",	"shende","qiankun","bushu","zhunbei","fengsu","fengshen","xinshang","micai","hina_jie","jinian","tianyan","shouhuo","jiliao","qishu",	"xiangqi","maihuo","yaoban","yuanling","songzang","baigui","guaili","jidu","chuanran","diaoping",	"jiushu","weizhuang","jinghua","zhengyi","chuannan","souji","jingxia","nuhuo",	"qingting","leishi","xiefa","chuanbi","duzhua","taotie","huisheng","chuixue","buming","qingyu",	"qiuwen","xiufu","fandu","shitu","luanying","lianxi","zheshe","zhuonong","ganying",	"rexue","sidou","sizhai","fanji","kexue",	"LuaKongpiao","beisha","xisan","jubao" ,"shanji","changqing",	"jiexian","zhouye","shenqiang","aoyi","jubian","cuixiang", "kuangyan","shiting","rengui","ningshi",	"shenshou","reimu_fengyin","quanjie","longwei","qiannian","chaoren","benwo","ziwo","chaowo"}local key_skills={"feixiang","mingyun","yongheng","qiuwen","xiangqi","jiushu"} 	local function pingyi_change(player,attacker)	--权衡新旧技能	if player:getMark("pingyi_steal")>0 then 		skillname=pingyi_skillname(player)		if skillname and table.contains(key_skills,skillname) then			return false		end	end	--新技能重要，无旧技能，或旧技能不重要 	for _,skill in sgs.qlist(attacker:getVisibleSkillList()) do 		if table.contains(key_skills,skill:objectName()) then			return true		end	end	--新技能不算重要，但自己还没有旧技能	if player:getMark("pingyi_steal")==0 then		for _,skill in sgs.qlist(attacker:getVisibleSkillList()) do 			if table.contains(goodSkills,skill:objectName()) then				return true			end		end	end	return falseendsgs.ai_skill_choice.pingyi=function(self, choices)	--拿技能的几个目的	--1破坏对手技能结构	--2自己需要攻击型技能（敌人需要被集火）	--3拿到对手防御性技能（自己需要防御型）	--4特殊 拿队友的特例	local target =self.player:getTag("pingyi_target"):toPlayer()	if self:isEnemy(target) then		local need_change=false		if not pingyi_change(self.player,target) then			return "cancel"		end		local choice_table = choices:split("+")		for index, achoice in ipairs(choice_table) do			if table.contains(key_skills,achoice)  then return achoice end		end		for index, achoice in ipairs(choice_table) do			if table.contains(goodSkills,achoice)  then return achoice end		end	end	return "cancel"endsgs.ai_skill_cardask["@pingyi"] = function(self, data)	local cards = self.player:getCards("he")	cards = sgs.QList2Table(cards)	if #cards==0 then return "." end	self:sortByUseValue(cards)	return "$" .. cards[1]:getId()end--需要卖血 目前只枚举了一个闪电时凭依改判sgs.ai_need_damaged.pingyi = function(self, attacker, player)	if self:isWeak(player) or player:isNude() then return false end	if not attacker then return false end	if attacker:hasSkill("wunian") then return false end	if not self:isEnemy(attacker,player) then return false end	--有闪电时优先拿下改判技能	for _,p in sgs.qlist(self.room:getAlivePlayers())do		if p:containsTrick("lightning") then			if  attacker:hasSkills("feixiang|mingyun") and  not player:hasSkills("feixiang|mingyun") then				return true			end		end	end	return pingyi_change(player,attacker)end--【折射】ai--sgs.ai_skill_use["@@zheshe"] = function(self, prompt)--基本照搬小乔。。。须根据东方杀体系再改良sgs.ai_skill_use["@@zheshe"] = function(self, data, method)	if not method then method = sgs.Card_MethodDiscard end	local friend_lost_hp = 10	local friend_hp = 0	local card_id	local target	local cant_use_skill	local dmg	if data == "@zheshe" then		dmg = self.player:getTag("zhesheDamage"):toDamage()	else		dmg = data	end	if not dmg then self.room:writeToConsole(debug.traceback()) return "." end	local cards = self.player:getCards("h")	cards = sgs.QList2Table(cards)	self:sortByUseValue(cards, true)	for _, card in ipairs(cards) do		if not self.player:isCardLimited(card, method) 		and not card:isKindOf("Peach") then  --and not card:isKindOf("EquipCard") 			card_id = card:getId()			break		end	end	if not card_id then return "." end	self:sort(self.enemies, "hp")	for _, enemy in ipairs(self.enemies) do		if (enemy:getHp() <= dmg.damage and enemy:isAlive()) then			if (enemy:getHandcardNum() <= 2 or enemy:hasSkills("guose|leiji|ganglie|enyuan|qingguo|wuyan|kongcheng") or enemy:containsTrick("indulgence"))				and self:canAttack(enemy, dmg.from or self.room:getCurrent(), dmg.nature)				and not (dmg.card and dmg.card:getTypeId() == sgs.Card_TypeTrick and enemy:hasSkill("wuyan")) then				--return "#zheshe:" ..card_id.. ":->" .. enemy:objectName()				return "@zhesheCard=" ..card_id.. "->" .. enemy:objectName()			end		end	end	for _, friend in ipairs(self.friends) do		if (friend:getLostHp() + dmg.damage > 1 and friend:isAlive()) then			if friend:isChained() and dmg.nature ~= sgs.DamageStruct_Normal and not self:isGoodChainTarget(friend, dmg.from, dmg.nature, dmg.damage, dmg.card) then			elseif friend:getHp() >= 2 and dmg.damage < 2					and (friend:hasSkills("yiji|buqu|nosbuqu|shuangxiong|zaiqi|yinghun|jianxiong|fangzhu")						or self:getDamagedEffects(friend, dmg.from or self.room:getCurrent())						or self:needToLoseHp(friend)						or (friend:getHandcardNum() < 3 and (friend:hasSkill("nosrende") or (friend:hasSkill("rende") and not friend:hasUsed("RendeCard"))))) then				return "@zhesheCard=" ..card_id.. "->" .. friend:objectName()				--"#zheshe:" ..card_id.. ":->" .. friend:objectName()				elseif dmg.card and dmg.card:getTypeId() == sgs.Card_TypeTrick and friend:hasSkill("wuyan") and friend:getLostHp() > 1 then					return "@zhesheCard=" ..card_id.. "->" .. friend:objectName()					--"#zheshe:" ..card_id.. ":->" .. friend:objectName()			elseif hasBuquEffect(friend) then  				return "@zhesheCard=" ..card_id.. "->" .. friend:objectName()				--"#zheshe:" ..card_id.. ":->" .. friend:objectName()			end		end	end	for _, enemy in ipairs(self.enemies) do		if (enemy:getLostHp() <= 1 or dmg.damage > 1) and enemy:isAlive() then			if (enemy:getHandcardNum() <= 2)				or enemy:containsTrick("indulgence") or enemy:hasSkills("guose|leiji|vsganglie|ganglie|enyuan|qingguo|wuyan|kongcheng")				and self:canAttack(enemy, (dmg.from or self.room:getCurrent()), dmg.nature)				and not (dmg.card and dmg.card:getTypeId() == sgs.Card_TypeTrick and enemy:hasSkill("wuyan")) then				return "@zhesheCard=" ..card_id.. "->" .. enemy:objectName() 			end		end	end	for i = #self.enemies, 1, -1 do		local enemy = self.enemies[i]		if not enemy:isWounded() and not self:hasSkills(sgs.masochism_skill, enemy) and enemy:isAlive()			and self:canAttack(enemy, dmg.from or self.room:getCurrent(), dmg.nature)			and (not (dmg.card and dmg.card:getTypeId() == sgs.Card_TypeTrick and enemy:hasSkill("wuyan") and enemy:getLostHp() > 0) or self:isWeak()) then			return "@zhesheCard=" ..card_id.. "->" .. enemy:objectName()		end	end	return "."endsgs.ai_card_intention.zhesheCard = function(self, card, from, tos)	local to = tos[1]	if self:getDamagedEffects(to) or self:needToLoseHp(to) then return end	local intention = 10	if hasBuquEffect(to) then intention = 0	elseif (to:getHp() >= 2 and self:hasSkills("yiji|shuangxiong|zaiqi|yinghun|jianxiong|fangzhu", to))		or (to:getHandcardNum() < 3 and (to:hasSkill("nosrende") or (to:hasSkill("rende") and not to:hasUsed("RendeCard")))) then		intention = -10	end	sgs.updateIntention(from, to, intention)endfunction SmartAI:touhouDamageTransfer(player)	if player:hasSkill("zheshe") and not player:isKongcheng() then		return true		--[[local cards = player:getHandcards()		for _,card in sgs.qlist(cards) do			local flag = string.format("%s_%s_%s", "visible", self.room:getCurrent():objectName(), player:objectName())			if player:objectName() == self.player:objectName() or card:hasFlag("visible") or card:hasFlag(flag) then				if not card:isKindOf("EquipCard") then					return true				end			else				return true			end		end]]	end	if player:hasSkill("zhengti") then		for _,p in sgs.qlist(self.room:getOtherPlayers(player))do			if p:getMark("@zhengti")>0 then				return true			end		end	end	return falseend--【贪吃】ai 锁定技 不需要--【捉弄】ai local zhuonong_skill = {}zhuonong_skill.name = "zhuonong"table.insert(sgs.ai_skills, zhuonong_skill)zhuonong_skill.getTurnUseCard = function(self)	if self.player:hasUsed("zhuonongCard") then return nil end	return sgs.Card_Parse("@zhuonongCard=.")endsgs.ai_skill_use_func.zhuonongCard = function(card, use, self)	local weaks={}	local notWounded={}	local chained={}	local goodTargets={}	local cankill = {}	local f =0	local e=0	--预估触发铁锁是赚是赔	for _,p in sgs.qlist(self.room:getAlivePlayers()) do		if p:isChained() then			table.insert(chained,p)			local n= p:hasArmorEffect("Vine") and 2 or 1			if self:isEnemy(p) then				e=e+n			elseif self:isFriend(p) then				f=f+n			end		end	end	local chain = e>f and  true or false	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do		if p:isChained() then			continue		end		if self:isEnemy(p) then			if self:touhouDamageTransfer(p) then				continue			end			if p:hasSkill("ganying")  and self.player:distanceTo(p) >1 then				continue			end			if not p:isWounded() then				table.insert(notWounded,p)			end			if p:getHp()<=2 and self:slashIsAvailable() 			and self:getCardsNum("Slash") > 0			and  self.player:canSlash(p,nil,true) then				table.insert(cankill,p)			end			if p:getHp()==1 then				table.insert(weaks,p)			end					if  p:hasArmorEffect("Vine") then				table.insert(goodTargets,p)				end		elseif self:isFriend(p) then			if p:hasArmorEffect("Vine") then				continue			end			if p:isWounded() and self:touhouDamageTransfer(p) then				table.insert(goodTargets,p)			end			if p:hasSkill("ganying") and self.player:distanceTo(p) >1 then				table.insert(goodTargets,p)			end		end	end	sgs.ai_use_priority.zhuonongCard = #cankill >0 and 0 or 5	local target--对象选择还是很简单。。。应该考虑铁锁对于己方敌方的伤害	if chain then		self:sort(chained,"hp")		for _,p in pairs(chained)do			if self:isFriend(p) then				target=p				break			end		end		if not target then			target=chained[1]		end	elseif #goodTargets>0 then		self:sort(goodTargets,"hp")		target=	goodTargets[1]	elseif #weaks>0 then		self:sort(weaks,"hp")		target=	weaks[1]	elseif #notWounded>0 then		self:sort(notWounded,"hp")		target=	notWounded[1]	end	if target then		use.card = card		if use.to then use.to:append(target) end	endendsgs.ai_skill_choice.zhuonong=function(self, choices)	local target=self.player:getTag("zhuonong_target"):toPlayer()	if self:isFriend(target) then		if target:isWounded() and target:getHp()<2 then			return "rd"		else			return "dr"		end	else		if target:isWounded() then			return "dr"		else			return "rd"		end	endendsgs.ai_use_value.zhuonongCard = sgs.ai_use_value.Slash+0.5sgs.ai_choicemade_filter.skillChoice.zhuonong = function(self, player, promptlist)	local choice = promptlist[#promptlist]	local target =player:getTag("zhuonong_target"):toPlayer()	if not target then return end	local friendly =false	if self:isFriend(player,target) then		if target:isWounded() and target:getHp()<2 then			if choice== "rd" then friendly =true end		else			if choice== "dr" then friendly =true end		end	end	if friendly then 		sgs.updateIntention(player, target, -20) 	else		sgs.updateIntention(player, target, 40)	endend--【寂静】ai --[[sgs.ai_skill_cardask["@jijing"] = function(self, data)    current=self.room:getCurrent()	if not self.player:isKongcheng() then return "." end	if not self:isEnemy(current) then return "." end	if not self:isWeak(self.player) then return "." end	if self:willSkipPlayPhase(current) then return "." end	local cards = sgs.QList2Table(self.player:getCards("h"))    --self:sortByUseValue(cards, true)	self:sortByCardNeed(cards)    return "$" .. cards[1]:getId()end]]--【感应】ai  --目前默认摸排--function SmartAI:doNotDiscard(to, flags, conservative, n, cant_choose)sgs.ai_skill_playerchosen.ganying = function(self, targets)	if self:isWeak(self.player) then return self.player end	for _,p in sgs.qlist(targets) do		if self:isEnemy(p)  then --and self:isWeak(p) and p:getHandcardNum()<4			return p		end	end	return nilend--暂时认为没有拆队友牌的必要sgs.ai_playerchosen_intention.ganying = 60sgs.ai_skill_invoke.ganying = truesgs.ai_cardneed.ganying = function(to, card, self)	if not self:willSkipPlayPhase(to) then		return  (not to:getDefensiveHorse() and  getCardsNum("DefensiveHorse",to,self.player)<1 and card:isKindOf("DefensiveHorse"))		or (not to:getOffensiveHorse() and  getCardsNum("OffensiveHorse",to,self.player)<1 and card:isKindOf("OffensiveHorse"))	endend--【判读】ai--cardchosen ai使用的时候没有player参数？local pandu_skill = {}pandu_skill.name = "pandu"table.insert(sgs.ai_skills, pandu_skill)pandu_skill.getTurnUseCard = function(self)	if self.player:hasUsed("panduCard") then return nil end	return sgs.Card_Parse("@panduCard=.")endsgs.ai_skill_use_func.panduCard=function(card,use,self)	local targets={}	local good_targets={}	self:sort(self.enemies, "handcard",false)	for _,p in pairs(self.enemies) do		if p:isKongcheng() then continue end		if p:hasSkill("taohuan") or self:touhouHandCardsFix(p) then			continue		end		if getCardsNum("Slash", p, self.player) < 1 or sgs.card_lack[p:objectName()]["Slash"] == 1 then			table.insert(good_targets,p)		else			local rate= getCardsNum("Slash", p, self.player)/ p:getHandcardNum()			if rate <= 1/2 then				table.insert(targets,p)			end		end	end	if #good_targets>0 or  #targets>0 then		use.card = card		if use.to then			if #good_targets>0 then				use.to:append(good_targets[1])				if use.to:length() >= 1 then return end			elseif #targets>0 then				use.to:append(targets[1])				if use.to:length() >= 1 then return end			end		end	endendsgs.ai_card_intention.panduCard = 50sgs.ai_use_priority.panduCard = sgs.ai_use_priority.Dismantlement -0.4sgs.ai_skill_playerchosen.bihuo = function(self, targets)	if #self.enemies ==0 then return nil end	local weak_targets={}--残血	--local chain_targets={}--连环效果暂时不考虑。。。	--local good_freinds={} 主动给队友先不考虑	local normal_targets={}	local temp_targets={}	local has_heart=false	for _,c in sgs.qlist(self.player:getCards("h")) do		if c:getSuit()== sgs.Card_Heart then			has_heart=true			break		end	end		for _,p in sgs.qlist(targets) do		if self:isEnemy(p) then			if p:hasSkills("chunxi|yfdxingyun") and has_heart then				continue			elseif  self:isWeak(p) or getCardsNum("Slash", p, self.player) < 1 or sgs.card_lack[p:objectName()]["Slash"] == 1 then				table.insert(weak_targets,p)			else				table.insert(normal_targets,p)			end		elseif not self:isFriend(p) then			if self.player:getRole() == "renegade" and p:isLord() then				continue			end			table.insert(temp_targets,p)		end	end	if #weak_targets>0 then		return weak_targets[1]	elseif #normal_targets>0 then		return normal_targets[1]	elseif #temp_targets>0 then			end	return nilend--sgs.ai_playerchosen_intention.bihuo = 40sgs.ai_playerchosen_intention.bihuo =function(self, from, to)	local intention = 50	sgs.updateIntention(from, to, intention)	--其实有时候该加仇恨		sgs.ai_bihuo_effect =trueendsgs.ai_slash_prohibit.bihuo = function(self, from, to, card)	if to:isKongcheng() then		return false	end	if self:isFriend(from,to) then		return false	end	if self.player:hasSkill("lizhi") then		return false	end	if self.player:hasSkill("sidie") and self.player:getPhase() ==sgs.Player_Play then		return false	end	for _,p in pairs (self.friends_noself)do		local fakeDamage=sgs.DamageStruct()		fakeDamage.card=card		fakeDamage.nature= sgs.DamageStruct_Normal		fakeDamage.damage=1		fakeDamage.from=self.player		fakeDamage.to=p		local effect= self:touhouDamage(fakeDamage,self.player,p).damage>0		if  self:slashIsEffective(card, p, from)  and effect then			continue		end		return true	end	return falseend--嘲讽值设定sgs.ai_chaofeng.wai001 = -1sgs.ai_chaofeng.wai002 = 0sgs.ai_chaofeng.wai003 = 1sgs.ai_chaofeng.wai004 = 1sgs.ai_chaofeng.wai005 = 3sgs.ai_chaofeng.wai006 = 1sgs.ai_chaofeng.wai007 = -2sgs.ai_chaofeng.wai008 = -1sgs.ai_chaofeng.wai009 = 2sgs.ai_chaofeng.wai010 = 0