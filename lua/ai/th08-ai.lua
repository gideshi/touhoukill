--【永恒】ai 锁定技--修改 SmartAI:getLeastHandcardNum(player)--进而影响 SmartAI:hasLoseHandcardEffective(player)--进而影响SmartAI:doNotDiscard--五谷相关--【竹取】aisgs.ai_skill_playerchosen.zhuqu = function(self, targets)	target_table =sgs.QList2Table(targets)	if #target_table==0 then return false end	for _,target in pairs(target_table) do			if  self:isFriend(target) then			return target			--break		end	end	return nilendsgs.ai_playerchosen_intention.zhuqu = -80--【睿智】aisgs.ai_skill_invoke.ruizhi  = function(self)	return self:invokeTouhouJudge()end--改判系在场满血主动卖sgs.ai_need_damaged.ruizhi = function(self, attacker, player)	if not attacker then return end	if player:getHp()<player:getMaxHp() then return end	effect=self.player:getTag("ruizhi_effect"):toCardEffect()	if not effect or not effect.card  then return end	local damageTrick = self:touhouIsDamageCard(effect.card)	if damageTrick and not self:needtouhouDamageJudge()  then		return false 	end	if damageTrick and self:touhouDamage(effect.card,effect.from,effect.to) >=2 then		return false	end	return damageTrickend--【秘药】ailocal miyao_skill = {}miyao_skill.name = "miyao"table.insert(sgs.ai_skills, miyao_skill)function miyao_skill.getTurnUseCard(self)    if self.player:hasUsed("miyaoCard") then return nil end	 return sgs.Card_Parse("@miyaoCard=.")endsgs.ai_skill_use_func.miyaoCard = function(card, use, self)        local kaguya		local friendtarget		self:sort(self.friends_noself,"hp")        for _, p in ipairs(self.friends_noself) do            if self:touhouHandCardsFix(p) then				kaguya=p			end			if p:isWounded() and not p:isKongcheng() then    				friendtarget=p				break			end        end				sgs.ai_use_priority.miyaoCard = friendtarget and 3 or 8				if friendtarget then			use.card = card			if use.to then				use.to:append(friendtarget)				if use.to:length() >= 1 then return end			end		end		self:sort(self.enemies,"handcard")        for _, p in ipairs(self.enemies) do            if (not p:isWounded()) and (not p:isKongcheng()) 			and not  self:touhouHandCardsFix(p) then    				use.card = card                if use.to then                        use.to:append(p)                        if use.to:length() >= 1 then return end                end			end        end		if kaguya then 			use.card = card            if use.to then                use.to:append(kaguya)                if use.to:length() >= 1 then return end            end		endendsgs.ai_use_value.miyaoCard = 10sgs.ai_card_intention.miyaoCard = function(self, card, from, to)	--to是table？	if to[1]:isWounded() then		sgs.updateIntentions(from, to, -90)	else		if self:touhouHandCardsFix(to[1]) then			sgs.updateIntentions(from, to, -10)		else			sgs.updateIntentions(from, to, 40)		end	endendsgs.ai_skill_discard.miyao = function(self)	local to_discard = {}	local cards = self.player:getHandcards()	cards = sgs.QList2Table(cards)	self:sortByKeepValue(cards)	table.insert(to_discard, cards[1]:getEffectiveId())	return to_discardend--【不灭】ai 锁定技 不需要--但是需要写一些策略--修改smart-ai下SmartAI:damageIsEffective(to, nature, from)--保证1血时的敌人对策--function SmartAI:isWeak--【历战】aifunction lizhan_slash(player,objectName)	local ids=player:getTag("lizhan"):toIntList()	for _,id in sgs.qlist(ids) do									local card = sgs.Sanguosha:getCard(id)		if objectName=="notNatureSlash" then			if not card:isKindOf("NatureSlash") then				return id			end		else			if (card:isKindOf(objectName)) then 												return id			end		end			end	return -1endsgs.ai_skill_invoke.lizhan = function(self)	return true	--[[local target=self.player:getTag("lizhan_target"):toPlayer()	if target and self:isEnemy(target)  then		return true	end	if target and self:isFriend(target)  then		if target:hasSkill("wushou") and target:getHp()<=3 		and target:hasArmorEffect("Vine") then			id=lizhan_slash(self.player,"notNatureSlash")			if id ~=-1 then				return true			end		end	end	return false]]endsgs.ai_skill_askforag.lizhan = function(self, card_ids)	--local target=self.player:getTag("lizhan_target"):toPlayer()	--目前对友军只有【无寿】	--if target and self:isFriend(target)  then	--	return lizhan_slash(self.player,"notNatureSlash")	--end	--不能直接引用useslash来自动选择id么。。。	local id= lizhan_slash(self.player,"FireSlash")	if id ==-1 then		id= lizhan_slash(self.player,"ThunderSlash")	end	if id ==-1 then		id = lizhan_slash(self.player,"notNatureSlash")	end	if id ~=-1 then		return id	end	return card_ids[1]end--【狂躁】ailocal kuangzao_skill = {}kuangzao_skill.name = "kuangzao"table.insert(sgs.ai_skills, kuangzao_skill)function kuangzao_skill.getTurnUseCard(self)	if self.player:hasUsed("kuangzaoCard") then return nil end    return sgs.Card_Parse("@kuangzaoCard=.")endsgs.ai_skill_use_func.kuangzaoCard = function(card, use, self)--sgs.ai_skill_use_func["#kuangzao"] = function(card, use, self)		local slash=sgs.cloneCard("slash")		self:sort(self.enemies,"handcard")        for _, p in ipairs(self.enemies) do			if p:inMyAttackRange(self.player) then				if (getCardsNum("Slash", p, self.player) < 1 				or sgs.card_lack[p:objectName()]["Slash"] == 1) 				or self:getCardsNum("Jink") >1 then				--(self:getCardsNum("Jink") >0 and  math.abs(self:touhouCanHuanshi(slash,p,self.player))>0)then				--if self:isTiaoxinTarget(p) then					use.card = card					if use.to then                        use.to:append(p)                        if use.to:length() >= 1 then return end					end				end			end        endendsgs.ai_use_value.kuangzaoCard = 8sgs.ai_use_priority.kuangzaoCard = 0sgs.ai_card_intention.kuangzaoCard = 50--【幻视】ai--幻视的仇恨值还得修改--1function SmartAI:isPriorFriendOfSlash--2修改sgs.ai_card_intention.Slash 队友利用幻视扩大杀伤面时，仇恨为0--[[sgs.ai_skill_use["@@lxhuanshi"] = function(self, prompt)	local use=self.player:getTag("huanshi_source"):toCardUse()	local s=use.from	local targets={}    for _, p in sgs.qlist(self.room:getOtherPlayers(self.player)) do        if s:canSlash(p,use.card,true) and s:objectName()~=p:objectName() 		and not use.to:contains(p) and  s:inMyAttackRange(p)  then			if self:isEnemy(p) then				table.insert(targets,p:objectName())			end			if self:isFriend(s) and s:hasSkills("sidie|lizhi") then				if self:isFriend(p) then					table.insert(targets,p:objectName())				end			end		end    end		 		if #targets ==0 then return "."	 end	--return "#lxhuanshi:.:->" .. table.concat(targets, "+")	return "@lxhuanshiCard=.->" .. table.concat(targets, "+")endsgs.ai_card_intention.lxhuanshiCard = function(self, card, from, to)--sgs.ai_card_intention.lxhuanshi = function(self, card, from, to)	local use=from:getTag("huanshi_source"):toCardUse()	local s=use.from	if s:hasSkills("sidie|lizhi") and self:isFriend(s,from)then		for _,p in pairs (to) do			if self:isFriend(p,from) then			else				sgs.updateIntention(from, p, 50)			end		end	else		sgs.updateIntentions(from, to, 50)	end	sgs.ai_lxhuanshi_effect = trueend]]sgs.ai_skill_playerchosen.lxhuanshi = function(self, targets)	local enemies={}	local attacker=self.player:getTag("huanshi_source"):toCardUse().from	for _,p in sgs.qlist(targets) do		if self:isEnemy(p) then			table.insert(enemies,p)		end	end	if #enemies>0 then		self:sort(enemies, "defenseSlash")		return enemies[1]	end	return nilendsgs.ai_playerchosen_intention.lxhuanshi = 60--[[sgs.ai_slash_prohibit.lxhuanshi = function(self, from, to, card)	if to:hasSkill("lxhuanshi") then		if self:touhouCanHuanshi(card, from, to)>0 then			return false		end		if self:touhouCanHuanshi(card, from, to)==0 then			if self:isEnemy(from,to) and self:isWeak(to) then				return false			end		end		return true	end	return falseend]]--【噬史】aisgs.ai_skill_invoke.shishi =function(self,data)	local use=self.player:getTag("shishi_use"):toCardUse()	if self:isEnemy(use.from) then		return true	else		if self:touhouIsDamageCard(use.card) then			local f=0			for _,p in sgs.qlist(use.to) do				if self:isFriend(p) then					f=f+1				end			end			if f>0 and use.to:length()-f<f then				return true			end		end	end	return falseend--【授业】aisgs.ai_skill_playerchosen.sbzhyshouye = function(self, targets)	local target =self:touhouFindPlayerToDraw(false, 1)	if not target and #self.friends_noself>0 then		target= self.friends_noself[1] 	end		if  target then		return target	end	return nilendsgs.ai_playerchosen_intention.sbzhyshouye = -80--【布陷】ai  不好推敲。。。。sgs.ai_skill_use["@@buxian"] = function(self, prompt)	local handcards = sgs.QList2Table(self.player:getHandcards())    self:sortByUseValue(handcards)	if #handcards==0 then return "." end		self:sort(self.enemies,"handcard")    targets={}	for _, p in ipairs(self.enemies) do        if not p:isKongcheng()  then    			table.insert(targets,p:objectName())		end		if #targets==2 then			break		end    end	if #targets >1 then		--return "#buxian:".. handcards[1]:getId() ..":->" .. table.concat(targets, "+")		return "@buxianCard=".. handcards[1]:getId() .."->" .. table.concat(targets, "+")	end	return "."	 endsgs.ai_card_intention.buxianCard = 50--【幸运】aisgs.ai_skill_invoke.yfdxingyun = truesgs.ai_skill_choice.yfdxingyun="recover"sgs.ai_skill_playerchosen.yfdxingyun = function(self, targets)	target_table = self:getFriends(self.player)	if #target_table==0 then return false end	local xingyun_target	self:sort(target_table, "handcard")		for _,target in pairs(target_table) do			--if self:isFriend(target) then		if not xingyun_target then			xingyun_target=target		else			if self:isWeak(target) and (not self:isWeak(xingyun_target)) then				xingyun_target=target			end		end	end	if xingyun_target  then		return xingyun_target	end	return nilendsgs.ai_playerchosen_intention.yfdxingyun = -60sgs.ai_cardneed.yfdxingyun = function(to, card, self)	return card:getSuit()==sgs.Card_Heartendsgs.yfdxingyun_suit_value = {	heart = 4.8}--【歌声】ailocal gesheng_skill = {}gesheng_skill.name = "gesheng"table.insert(sgs.ai_skills, gesheng_skill)gesheng_skill.getTurnUseCard = function(self, inclusive)		if self.player:hasFlag("gesheng") then return nil end		local cards = self.player:getCards("h")		cards=self:touhouAppendExpandPileToList(self.player,cards)		for _,c in sgs.qlist(self.player:getCards("e")) do			if  c:isKindOf("DefensiveHorse") and self.player:hasSkill("yemang") then			else				cards:append(c)			end		end		if cards:length()==0 then return nil end		        cards = sgs.QList2Table(cards)        self:sortByUseValue(cards, true)		        if cards[1] then				local suit = cards[1]:getSuitString()                local number = cards[1]:getNumberString()                local card_id = cards[1]:getEffectiveId()                local str = ("indulgence:gesheng[%s:%s]=%d"):format(suit, number, card_id)                local indl = sgs.Card_Parse(str)                                assert(indl)                return indl        endendsgs.ai_use_value.gesheng = 7sgs.ai_use_priority.gesheng = sgs.ai_use_priority.Indulgence -0.1--【夜盲】ai  禁止技 不需要--【萤火】aisgs.ai_skill_cardask["@yinghuo"] = function(self, data)	local ecards=self.player:getCards("h")	if ecards:length()==0 then return "." end	for _,c in sgs.qlist(ecards) do		if c:isKindOf("Jink")then			 return "$" .. c:getId()		end	end	return "." endsgs.ai_cardneed.yinghuo = function(to, card, self)	return getCardsNum("Jink", to, self.player) <1		and card:isKindOf("Jink")endsgs.yinghuo_keep_value = {	Jink = 8.9}sgs.ai_slash_prohibit.yinghuo = function(self, from, to, card)	if self:isFriend(from,to) then		return false	end	if getCardsNum("Jink", to, from) >0  then		if from:hasWeapon("Axe") and from:getCards("he"):length()>=3 then			return false		end		return true	end	return falseend--【虫群】aisgs.ai_skill_playerchosen.chongqun = function(self, targets)	targets=sgs.QList2Table(targets)	self:sort(targets,"handcard")	for _,p in pairs(targets)do		if self:isEnemy(p) and not self:touhouHandCardsFix(p) then			return p		end	end	return nilendsgs.ai_playerchosen_intention.chongqun =function(self, from, to)	local intention = 50	if self:touhouHandCardsFix(to)  then		intention = 0 	end	sgs.updateIntention(from, to, intention)end--【创史】ai  --card:setSkillName("_chuangshi")--ai更新仇恨值--sgs.ai_card_intention.Duelsgs.ai_skill_playerchosen.chuangshi = function(self, targets)	if self.player:getMark("chuangshi")>0 then return nil end		--先要判断场上形势	--目前只考虑两种情况，离间类  和 助人类	if #self.friends_noself>0 then		self:sort(self.friends_noself, "hp")		for _,p in pairs(self.friends_noself) do			if self:isWeak(p) and p:isWounded() then --hp上限为1时也是weak				self.player:setTag("chuangshi_mode",sgs.QVariant("save"))				return p			end		end	end	local weaker	local attacker	if #self.enemies>0 then		self:sort(self.enemies, "hp")		for _,p in pairs(self.enemies) do			if self:isWeak(p) then						weaker=p				break			end		end	end	if weaker then		local _data=sgs.QVariant()		_data:setValue(weaker)		self.player:setTag("chuangshi_victim",_data)		self:sort(self.friends_noself, "handcard",true)		if #self.friends_noself>0 then 			self.player:setTag("chuangshi_mode",sgs.QVariant("kill1"))			_data=sgs.QVariant()			_data:setValue(self.friends_noself[1])			self.player:setTag("chuangshi_attacker",_data)			return self.friends_noself[1]		end	end	if #self.enemies>1 then		self.player:setTag("chuangshi_mode",sgs.QVariant("kill2"))		_data=sgs.QVariant()		_data:setValue(self.enemies[2])		self.player:setTag("chuangshi_attacker",_data)		if not weaker then			_data=sgs.QVariant()			_data:setValue(self.enemies[1])			self.player:setTag("chuangshi_victim",_data)		end		return self.enemies[2]	end	return nilendsgs.ai_skill_use["@@chuangshi"] = function(self, prompt)	--目前还没有考虑到被选中者不能使用杀和决斗时的情况	local str=self.player:getTag("chuangshi_mode"):toString()	self.player:removeTag("chuangshi_mode")	local user	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do			if (p:getMark("chuangshi_user") >0 ) then				user= p				break			end	end	   	local cardname	if str =="save" then cardname= "peach"	elseif str =="kill1" then 		local killer=self.player:getTag("chuangshi_attacker"):toPlayer()		local target=self.player:getTag("chuangshi_victim"):toPlayer()		self.player:removeTag("chuangshi_attacker")		if killer:canSlash(target,nil,true) then			cardname="fire_slash"		else			cardname="duel"		end	elseif str =="kill2" then 		self.player:removeTag("chuangshi_attacker")		cardname="duel"	end		local target	target=self.player:getTag("chuangshi_victim"):toPlayer()	self.player:removeTag("chuangshi_victim")		--simulate a process of chuangshi	--it is a dirty trick insteading of  real chuangshiCard...	if cardname and user then		self.room:setPlayerMark(self.player, "chuangshi", self.player:getMark("chuangshi")+1);		self.room:setPlayerMark(user, "chuangshi_user", 0);		local chuangshicard = sgs.Sanguosha:cloneCard(cardname)        chuangshicard:setSkillName("_chuangshi")		local carduse=sgs.CardUseStruct()					carduse.card=chuangshicard		carduse.from=user		if target then			carduse.to:append(target)		end		self.room:useCard(carduse,false)		--self.room:useCard(sgs.CardUseStruct(chuangshicard,user,target),false)	end		--local dummy_use = { isDummy = true}	--self:useSkillCard(sgs.Card_Parse("@chuangshiCard=.:"..cardname), dummy_use)	--local card_str	--if dummy_use.card then 	--	card_str=dummy_use.card:toString()	--end		--if card_str then	--	return "@chuangshiCard=.:"..cardname.."->" .. target:objectName()	--	--return "@chuangshiCard=.:"..cardname	--else		return "."	--endendlocal chuangshi_filter = function(self, player, carduse)	if carduse.card:getSkillName(true)=="chuangshi" then		sgs.ai_chuangshi_effect = true	endendsgs.ai_skill_use_func.chuangshiCard=function(card,use,self)	local userstring=card:toString()	local target=self.player:getTag("chuangshi_victim"):toPlayer()	use.card=card	local target=self.player:getTag("chuangshi_victim"):toPlayer()	if use.to and  target then		use.to:appnd(target)		return	endend--【望月】aisgs.ai_skill_invoke.wangyue =function(self,data)	local target=self.player:getTag("wangyue_target"):toPlayer()	if target and self:isEnemy(target) then		return true	end	return falseendsgs.ai_choicemade_filter.skillInvoke.wangyue = function(self, player, promptlist)	local damage = self.room:getTag("CurrentDamageStruct"):toDamage()	local from=damage.from	if from:getHandcardNum()>player:getHp() then		if promptlist[#promptlist] == "yes" then			sgs.updateIntention(player, from, 60)		else			sgs.updateIntention(player, from, -60)		end	endendsgs.ai_need_damaged.wangyue = function(self, attacker, player)	if not attacker then return end	if attacker:hasSkill("wunian") then return false end	--if self:getDamagedEffects(attacker, player) then return self:isFriend(attacker, player) end	if  self:isEnemy(attacker,player) then		if player:getLostHp()>0 then--目前只卖第一滴血			return false		else			if attacker:getHandcardNum() >= 5  and not self:touhouDrawCardsInNotActive(attacker) then				return true					end		end	end	return falseend--【护卫】ai sgs.ai_skill_invoke.tymhhuwei = truesgs.ai_skill_playerchosen.tymhhuwei = function(self, targets)	--[[local huwei_target	local kaguya	self:sort(self.friends_noself, "handcard")	for _,target in pairs(self.friends_noself) do			if (not huwei_target) then			huwei_target=target		end		if self:isWeak(target) and (target:getHandcardNum()<3 or huwei_target:getHandcardNum()>target:getHandcardNum())		and not self:touhouHandCardsFix(target) then			huwei_target=target			break		end	end]]	local target =self:touhouFindPlayerToDraw(false, 2)	if target then return target end	if #self.friends_noself>0 then return self.friends_noself[1] end	return nilendfunction sgs.ai_cardsview_valuable.tymhhuwei(self, class_name, player)	local tmpslash = sgs.cloneCard("slash", sgs.Card_NoSuit, 0)	if player:isCardLimited(tmpslash, sgs.Card_MethodUse) then  return nil end	if class_name == "Slash" and (sgs.Sanguosha:getCurrentCardUseReason() == sgs.CardUseStruct_CARD_USE_REASON_RESPONSE_USE)  then		 if not player:hasFlag("Global_huweiFailed") and player:getPhase() ~=sgs.Player_Play then			--return "#tymhhuwei:.:"			return "@tymhhuweiCard=."		 end	endendsgs.ai_playerchosen_intention.tymhhuwei = -60sgs.ai_no_playerchosen_intention.tymhhuwei =function(self, from)	local lord =self.room:getLord()	if lord  then		if lord:getPhase() ==sgs.Player_NotActive then			if not lord:hasSkills("gaoao|yongheng")  then				sgs.updateIntention(from, lord, 10)			end		else			sgs.updateIntention(from, lord, 10)		end	endendsgs.ai_trick_prohibit.tymhhuwei = function(self, from, to, card)	if not card:isKindOf("Duel")  then return false end	if self:isFriend(from,to) then return false end	return trueendsgs.ai_cardneed.tymhhuwei = function(to, card, self)	return  card:isKindOf("Slash")end--【今昔】ai local jinxi_skill = {}jinxi_skill.name = "jinxi"table.insert(sgs.ai_skills, jinxi_skill)function jinxi_skill.getTurnUseCard(self)    if self.player:getMark("@jinxi")==0 then return nil end	cards=self.player:getCards("h")	hp=self.player:getHp()	if cards:length()+hp <=3 then		return sgs.Card_Parse("@jinxiCard=.")	end	return nilendsgs.ai_skill_use_func.jinxiCard=function(card,use,self)	use.card = cardendsgs.ai_use_value.jinxiCard = 2sgs.ai_use_priority.jinxiCard = 0--嘲讽值设定--[[sgs.ai_chaofeng.yyc001 = 0sgs.ai_chaofeng.yyc002 = 3sgs.ai_chaofeng.yyc003 = -2sgs.ai_chaofeng.yyc004 = 1sgs.ai_chaofeng.yyc005 = 0sgs.ai_chaofeng.yyc006 = 2sgs.ai_chaofeng.yyc007 = 1sgs.ai_chaofeng.yyc008 = -1sgs.ai_chaofeng.yyc009 = 3sgs.ai_chaofeng.yyc010 = -1]]