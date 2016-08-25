sgs.ai_skill_choice.ciyuan = function(self, choices, data)
	local choice_table = choices:split("+")
	if choices:match("cancel") then
		if not self.player:getCards("j"):isEmpty() then
			self.room:setPlayerMark(self.player, "ciyuan_ai", 5) --"finish"
			return "judge"
		end
		if self.player:hasSkill("shigui") then
			local useCount = 0
			for _,c in sgs.qlist(self.player:getCards("hs")) do
				if c:isKindOf("EquipCard") then
					useCount = useCount + 1
					continue
				end
				local dummy_use = { isDummy = true, to = sgs.SPlayerList() }
				if c:isKindOf("TrickCard") then
					self:useTrickCard(c, dummy_use)
				else
					self:useBasicCard(c, dummy_use)
				end
				if not dummy_use.to:isEmpty() then
					useCount = useCount + 1
				end
			end
			local draw = 4 - (self.player:getHandcardNum() - useCount)
			if draw >= 3 and self.player:getLostHp() < 3 then
				self.room:setPlayerFlag(self.player, "shigui_Not_Need_Bear")
				self.room:setPlayerMark(self.player, "ciyuan_ai", 5) --"finish"
				return "draw"
			end
			local remain = self.player:getHandcardNum() - useCount
			if self.player:isWounded() and remain <= 4 and self.player:getHandcardNum() >=2 then
				remain = math.max(remain, 2)
				self.room:setPlayerMark(self.player, "ciyuan_ai", remain - 1)
				return "play"
			end
		end
	else
		local index = self.player:getMark("ciyuan_ai")
		if index > 0 then
			return choice_table[index]
		end
	end

	if choices:match("cancel") then
		return "cancel"
	else
		return choice_table[1]
	end
end

sgs.ai_skill_invoke.shigui = function(self,data)
	local phase = self.player:getPhase()
	local pahseCount = self.player:getMark("shigui")
	local diff = math.abs(pahseCount - self.player:getHandcardNum())
	if phase == sgs.Player_Draw then
		if  diff > 2 then
			return true
		elseif pahseCount - self.player:getHandcardNum() == 2 then
			return not self:isWeak(self.player)
		end
	end
	if phase == sgs.Player_Play then
		if not self.player:isWounded() then return false end
		if  diff <= self:getOverflow(self.player) or pahseCount <= 4 then
			return true
		elseif self:isWeak(self.player) and diff <= 2 then
			return true
		end
	end
	return false
end

sgs.ai_need_bear.shigui = function(self, card,from,tos)
	from = from or self.player
	local pahseCount = from:getMark("shigui")
	if from:isWounded() then
		if not from:hasFlag("shigui_Not_Need_Bear")
			and from:getHandcardNum() > pahseCount and from:getHandcardNum() == pahseCount + 1 then
			return true
		end
	end
	return false
end

sgs.ai_skill_use["@@zhence"] = function(self, prompt)
	local change = self.player:getTag("zhence"):toPhaseChange()
	if change.to == sgs.Player_Draw or (change.to == sgs.Player_Play and self:getOverflow(self.player) < 2) then
		local card = sgs.cloneCard("fire_attack", sgs.Card_NoSuit, 0)
		card:setSkillName("zhence")
		local dummy_use = { isDummy = true, to = sgs.SPlayerList() }
		self:useTrickCard(card, dummy_use)
		if not dummy_use.card then return "." end
		if not dummy_use.to:isEmpty() then
			local target_objectname = {}
			for _, p in sgs.qlist(dummy_use.to) do
				table.insert(target_objectname, p:objectName())
			end
			return dummy_use.card:toString() .. "->" .. table.concat(target_objectname, "+")
		end
	end
	return "."
end

sgs.ai_skill_choice.shiqu = function(self, choices, data)
	local current = self.room:getCurrent()
	if self:isEnemy(current) and choices:match("shiqu_discard") and self:getOverflow(self.player) >= 2 then
		return "shiqu_discard"
	end
	if self:isFriend(current) then
		if choices:match("shiqu_draw") then
			return "shiqu_draw"
		end
		if choices:match("shiqu_play") and current:getHandcardNum() > 3 then
			return "shiqu_play"
		end
	end
	return "cancel"
end
sgs.ai_choicemade_filter.cardResponded["@shiqu-discard"] = function(self, player, args)
	local choice = player:getTag("shiqu"):toString()
	local current = self.room:getCurrent()
	if args[#args] ~= "_nil_" then
		if choice == "shiqu_discard" then
			sgs.updateIntention(player, current, 80)
		elseif choice == "shiqu_play" or choice == "shiqu_draw" then
			sgs.updateIntention(player, current, -80)
		end
	end
end


sgs.ai_trick_prohibit.jinfa = function(self, from, to, card)
	if not card:isKindOf("DelayedTrick")  then return false end
	if self:isFriend(from,to) then return false end
	return true
end


function SmartAI:qianyiPhase(target)
	--willSkipPlayPhase 没考虑跳判定
	if self:isEnemy(target) then
		if self:getOverflow(target) >= -1  then
			return sgs.Player_Play
		end
		return sgs.Player_Draw
	elseif self:isFriend(target) then
		return sgs.Player_Discard
	end
	return sgs.Player_NotActive
end
function SmartAI:qianyiValue(card, target, phase)
	local card1 = self:getSameEquip(card, target)
	local equipped
	if card1 and card1:getEffectiveId() > 0 then
		equipped = sgs.Sanguosha:getCard(card1:getEffectiveId())
	end
	local value = 0
	local value1 = 0
	local value2 = 0
	local value3 = 0
	if card:isKindOf("Weapon") then
		value1 = self:evaluateWeapon(card, self.player)
		value2 = self:evaluateWeapon(card, target)
		value3 = equipped and self:evaluateWeapon(equipped, target) or 0
	elseif card:isKindOf("Armor") then
		value1 = self:evaluateArmor(card, self.player)
		value2 = self:evaluateArmor(card, target)
		value3 = equipped and self:evaluateArmor(equipped, target) or 0
	else
		value1 = 3
		value2 = 3
		value3 = equipped and 3 or 0
	end
	if self:isFriend(target) then
		value = value - value1 + value2 - value3
		if phase == sgs.Player_Discard then
			if self:getOverflow(target) > 0 then
				value = value +  self:getOverflow(target)
			end
		end
	else
		value = value - value1 - value2 + value3
		if phase == sgs.Player_Draw then
			value = value + 5
		elseif phase == sgs.Player_Play then
			if self:getOverflow(target) >= -1 then
				value = value +  self:getOverflow(target) + 2
			end
		end
	end
	if self.player:isWounded() then
		value = value + 5
	end
	return value
end

sgs.ai_skill_cardask["@qianyi"] = function(self, data)
	local current = self.room:getCurrent()
	local phase = self:qianyiPhase(current)
	local cards = {}

	for _,c in sgs.qlist(self.player:getCards("e")) do
		local array={card = c, value=self:qianyiValue(c, current, phase)}
		table.insert(cards,array)
	end
	local compare_func = function(a, b)
		return a.value > b.value
	end
	table.sort(cards, compare_func)

	if cards[1].value > 0 then
		return "$" .. cards[1].card:getId()
	end
	return "."
end
sgs.ai_skill_choice.qianyi = function(self, choices, data)
	local current = self.room:getCurrent()
	local phase = self:qianyiPhase(current)
	if phase == sgs.Player_Discard then
		return "discard"
	elseif phase == sgs.Player_Play then
		return "play"
	elseif phase == sgs.Player_Draw then
		return "draw"
	end
	return "finish"
end
sgs.ai_choicemade_filter.skillChoice.qianyi = function(self, player, args)
	local choice = args[#args]
	local current = self.room:getCurrent()
	if not current then return end
	if  choice == "play" or choice == "draw" then
		sgs.updateIntention(player, current, 80)
	elseif choice == "discard" then
		sgs.updateIntention(player, current, -80)
	end
end


sgs.ai_skill_playerchosen.mengxiao = function(self, targets)
	local move = self.player:getTag("mengxiao"):toMoveOneTime()
	--暂时没管闪电等特殊情况
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			for _,c in sgs.qlist(p:getCards("j")) do
				for _,id in sgs.qlist(move.card_ids) do
					if sgs.Sanguosha:getCard(id):getSuit() == c:getSuit() then
						return p
					end
				end
			end
		end
	end
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then
			for _,c in sgs.qlist(p:getCards("e")) do
				for _,id in sgs.qlist(move.card_ids) do
					if sgs.Sanguosha:getCard(id):getSuit() == c:getSuit() then
						return p
					end
				end
			end
		end
	end
	return nil
end

sgs.ai_skill_cardchosen.mengxiao = function(self, who, flags)
	local cards = {}
	local flag = flags
	if self:isFriend(who) then
		flag = "j"
	elseif self:isEnemy(who) then
		flag = "e"
	end
	local move = self.player:getTag("mengxiao"):toMoveOneTime()
	for _,c in sgs.qlist(who:getCards(flag)) do
		for _,id in sgs.qlist(move.card_ids) do
			if sgs.Sanguosha:getCard(id):getSuit() == c:getSuit() then
				table.insert(cards,c)
			end
		end
	end
	if #cards>0 then
		return cards[1]
	end
end
sgs.ai_choicemade_filter.cardChosen.sidou = sgs.ai_choicemade_filter.cardChosen.snatch


function youyue_judge(self,target,card)
	if card:isKindOf("AmazingGrace") then
		return 2
	end
	if card:isKindOf("GodSalvation") then
		if target:isWounded() then
			return 2
		end
	end
	if card:isKindOf("IronChain") then
		if target:isChained() then
			return 2
		else
			return 1
		end
	end
	if   card:isKindOf("Dismantlement") or card:isKindOf("Snatch") then
		if self:isFriend(target) and target:getCards("j"):length()>0 then
			return 2
		end
		if self:isEnemy(target) and target:getCards("j"):length()>0  and target:isNude() then
			return 2
		end
		return 1
	end
	return 1
end
sgs.ai_skill_cardask["youyue-show"] = function(self, data)
	local target = self.player:getTag("youyue_target"):toPlayer()
	local use = data:toCardUse()
	local showcard = self.player:getTag("youyue_card"):toCard()
	local res = youyue_judge(self, target, use.card)

	if (res == 1 and self:isEnemy(target))  or (res== 2 and self:isFriend(target)) then
		local cards = {}
		for _,c in sgs.qlist(self.player:getCards("hs")) do
			if c:getTypeId() == showcard:getTypeId() then
				table.insert(cards, c)
			end
		end
		if #cards > 0 then
			self:sortByKeepValue(cards)
			return "$" .. cards[1]:getId()
		end
	end
	return "."
end

sgs.ai_skill_invoke.yeyan = true

local menghuanvs_skill = {}
menghuanvs_skill.name = "menghuan_attach"
table.insert(sgs.ai_skills, menghuanvs_skill)
menghuanvs_skill.getTurnUseCard = function(self)
	if self.player:hasFlag("Forbidmenghuan") then return nil end
	if self.player:getKingdom() ~="pc98" then return nil end

	local cards = self.player:getCards("hs")
	cards = sgs.QList2Table(cards)
	local card
	self:sortByUseValue(cards,true)
	for _,acard in ipairs(cards)  do
		if acard:isKindOf("TrickCard") then
			card = acard
			break
		end
	end
	if not card then return nil end

	local card_id = card:getEffectiveId()
	local card_str ="@MenghuanCard="..card_id
	local skillcard = sgs.Card_Parse(card_str)

	assert(skillcard)

	return skillcard
end

sgs.ai_skill_use_func.MenghuanCard = function(card, use, self)
	local targets = {}
	for _,friend in ipairs(self.friends_noself) do
		if friend:hasLordSkill("menghuan") then
			if not friend:hasFlag("menghuanInvoked") then
				table.insert(targets, friend)
			end
		end
	end

	if #targets > 0 then
		use.card = card
		if use.to then
			use.to:append(targets[1])
			if use.to:length()>=1 then return end
		end
	end
end

sgs.ai_card_intention.MenghuanCard = -40

sgs.ai_skill_invoke.huantong = true
local function  huantongValue(cards, self, damage, huantongDamage)
	local tmp = damage
	tmp.damage = huantongDamage
	local tmp = self:touhouDamage(tmp, tmp.from, tmp.to)
	local value = 0
	if (tmp.damage < damage.damage and self:isFriend(damage.to)) or 
	(tmp.damage > damage.damage and self:isEnemy(damage.to)) then
		value = value + 2 * math.abs(damage.damage - tmp.damage)
	end
	if  tmp.damage > damage.to:getHp() then
		if self:isFriend(damage.to) then
			if self:hasWeiya() then  value = value - 10 end
			value = value - 1
		else
			value = value + 1
		end
	end
	for _,c in ipairs(cards) do
		if c:isKindOf("Peach") or c:isKindOf("Analeptic") then
			if self:isFriend(damage.to) then
				value = value + 3 - tmp.damage
			else
				value = value - 2
			end
		else
			if self:isFriend(damage.to) then
				value = value + 1
			else
				value = value - 1
			end
		end
	end
	if tmp.damage >= 2 and self.player:hasSkill("mengyan") and self.player:isWounded() then
		-- recover count as 2 value
		value = value + self.player:getPile("dream"):length()
	end	
	return value
end
sgs.ai_skill_cardask["@huantong"] = function(self, data)
	local damage = data:toDamage()
	if not self:isFriend(damage.to) and not self:isEnemy(damage.to) then return "." end
	local ids = self.player:getPile("dream")
	local basics, others = {}, {}
	for _,id in sgs.qlist(ids) do
		local card=sgs.Sanguosha:getCard(id)
		if card:isKindOf("BasicCard") then 
			table.insert(basics, card)
		else
			table.insert(others, card)
		end
	end
	local inverse = self:isFriend(damage.to)
	self:sortByUseValue(basics, inverse)
	if self:cautionChangshi() then --有千年紫敌人，早点清除有价值的牌
		self:sortByUseValue(others, true)
	end
	
	local combines = {}
	if #basics >=2 then
		local cards = {basics[1], basics[2]}
		local arr = {combine = cards, value = huantongValue(cards, self, damage, 2)}
		table.insert(combines, arr)
	end
	if #basics > 0 and #others > 0 then
		local cards = {basics[1], others[1]}
		local arr = {combine = cards, value = huantongValue(cards, self, damage, 1)}
		table.insert(combines, arr)
	end
	if #others >=2 then
		cards = {others[1], others[2]}
		local arr = {combine = cards, value = huantongValue(cards, self, damage, 0)}
		table.insert(combines, arr)
	end
	
	local compare_func = function(a, b)
		return a.value > b.value
	end
	
	table.sort(combines, compare_func)
	if combines[1].value > 0 then
		local huantongIds = {}
		for _,c in ipairs (combines[1].combine) do
			table.insert(huantongIds, c:getId())
		end
		return "$" .. table.concat(huantongIds, "+")
	end
	return "."
end


sgs.ai_cardneed.huantong = function(to, card, self)
	if not self:willSkipPlayPhase(to) then
		return  (not to:getWeapon() and  getCardsNum("Weapon",to,self.player)<1 and card:isKindOf("Weapon"))
		or (not to:getOffensiveHorse() and  getCardsNum("OffensiveHorse",to,self.player)<1 and card:isKindOf("OffensiveHorse"))
	end
end

sgs.ai_skill_invoke.mengyan = true


sgs.ai_skill_use["@@sqchuangshi"] = function(self, prompt)
	local targets={}
	for _, p in ipairs(self.friends_noself) do
		table.insert(targets,p:objectName())
	end
	if #targets >1 then
		return "@SqChuangshiCard=.->" .. table.concat(targets, "+")
	end
	return "."
end

--暂时不考虑是否使得整个创史过程继续下去，以及源法有谁能摸牌的问题。
sgs.ai_skill_use["BasicCard+^Jink,TrickCard+^Nullification,EquipCard|.|.|sqchuangshi"] = function(self, prompt, method)
	local cards =  self:getCards("sqchuangshi", "hes")
	self:sortByUseValue(cards)
	for _, card in ipairs(cards) do
		if card:getTypeId() == sgs.Card_TypeTrick and not card:isKindOf("Nullification") then
			local dummy_use = { isDummy = true, to = sgs.SPlayerList() }
			self:useTrickCard(card, dummy_use)
			if dummy_use.card then
				if dummy_use.to:isEmpty() then
					if card:isKindOf("IronChain") then
						return "."
					end
					return dummy_use.card:toString()
				else
					local target_objectname = {}
					for _, p in sgs.qlist(dummy_use.to) do
						table.insert(target_objectname, p:objectName())
					end
					return dummy_use.card:toString() .. "->" .. table.concat(target_objectname, "+")
				end
			end
		elseif card:getTypeId() == sgs.Card_TypeBasic and not card:isKindOf("Jink") then
			local dummy_use = { isDummy = true, to = sgs.SPlayerList() }
			self:useBasicCard(card, dummy_use)
			if dummy_use.card then
				if dummy_use.to:isEmpty() then
					return dummy_use.card:toString()
				else
					local target_objectname = {}
					for _, p in sgs.qlist(dummy_use.to) do
						table.insert(target_objectname, p:objectName())
					end
					return dummy_use.card:toString() .. "->" .. table.concat(target_objectname, "+")
				end
			end
		elseif card:getTypeId() == sgs.Card_TypeEquip then
			local dummy_use = { isDummy = true }
			self:useEquipCard(card, dummy_use)
			if dummy_use.card then
				return dummy_use.card:toString()
			end
		end
	end
	return "."
end


sgs.ai_skill_invoke.yuanfa  = function(self)
	local f = 0
	local e = 0
	for _,p in sgs.qlist(self.room:getAllPlayers()) do
		if  p:getMark("yuanfa") == 0 then continue end
		if self:isFriend(p) then
			f = f + 1
		end
		if self:isEnemy(p) then
			e = e + 1
		end
	end
	return f > e
end


function turnUse_guaiqi(self)
	local piles = self.player:getPile("modian")
	local guaiqis = {}
	for _,id in sgs.qlist(piles) do
		local c = sgs.Sanguosha:getCard(id)
		if c:isKindOf("TrickCard") and not c:isKindOf("Nullification") and not table.contains(guaiqis,  c:objectName()) then
			table.insert(guaiqis, c:objectName())
		end
	end
	if #guaiqis == 0 then return nil end
	
	local cards = self.player:getHandcards()
	cards = self:touhouAppendExpandPileToList(self.player, cards)
	local slashes = {}
	for _,c in sgs.qlist(cards) do
		if (c:isKindOf("Slash")) then
			table.insert(slashes, c)
		end
	end
	if #slashes == 0 then return nil end
	self:sortByUseValue(slashes, true)
	
	
	local choices={}
	for i = 1, #guaiqis do
		local forbiden = guaiqis[i]
		forbid = sgs.cloneCard(forbiden, slashes[1]:getSuit(),slashes[1]:getNumber())
		if self.player:isCardLimited(forbid, sgs.Card_MethodUse, true) or not forbid:isAvailable(self.player) then
		else
			table.insert(choices,guaiqis[i])
		end
	end
	local suit = slashes[1]:getSuitString()
	local number = slashes[1]:getNumberString()
	local card_id = slashes[1]:getEffectiveId()

	local choice
	if not choice and table.contains(choices,"dismantlement") then
		for _,p in pairs(self.friends_noself) do
			if p:containsTrick("indulgence") or  p:containsTrick("supply_shortage")  then
				choice="dismantlement"
			end
		end
	end
	if not choice and table.contains(choices,"god_salvation") then
		local aoe = sgs.cloneCard("god_salvation",slashes[1]:getSuit(), slashes[1]:getNumber())
		if self:willUseGodSalvation(aoe) then
				choice="god_salvation"
		end
	end
	if not choice and table.contains(choices,"savage_assault") then
		local aoe = sgs.cloneCard("savage_assault",slashes[1]:getSuit(), slashes[1]:getNumber())
		if self:getAoeValue(aoe, self.player)>0 then
				choice="savage_assault"
		end
	end
	if not choice and table.contains(choices,"archery_attack") then
		local aoe = sgs.cloneCard("archery_attack",slashes[1]:getSuit(), slashes[1]:getNumber())
		if self:getAoeValue(aoe, self.player)>0 then
				choice="archery_attack"
		end
	end
	if not choice and table.contains(choices,"ex_nihilo")  then
		choice="ex_nihilo"
	end
	if not choice then
		choice = choices[1]
	end
	local str= (choice..":guaiqi[%s:%s]=%d"):format(suit, number, card_id)
	return str
end

local guaiqi_skill = {}
guaiqi_skill.name = "guaiqi"
table.insert(sgs.ai_skills, guaiqi_skill)
guaiqi_skill.getTurnUseCard = function(self)
	local str= turnUse_guaiqi(self)
	if not str then return nil end
	local parsed_card = sgs.Card_Parse(str)
	return parsed_card
end

function sgs.ai_cardsview_valuable.guaiqi(self, class_name, player)
	if class_name == "sqchuangshi" then
		return turnUse_guaiqi(self)
	end
	if class_name ~= "Nullification" then return nil end
	local hasNul = false
	local piles = self.player:getPile("modian")
	local modians = {}
	for _,id in sgs.qlist(piles) do
		local c = sgs.Sanguosha:getCard(id)
		if c:isKindOf("TrickCard") then
			table.insert(modians, c)
		end
		if c:isKindOf("Nullification") then
			hasNul = true
		end
	end
	if hasNul then
		local cards = self.player:getHandcards()
		cards = self:touhouAppendExpandPileToList(self.player, cards)
		for _,c in sgs.qlist(cards) do
			if (c:isKindOf("Slash")) then
				table.insert(modians, c)
			end
		end
	end
	
	if #modians == 0 then return nil end
	self:sortByUseValue(modians, true)
	
	local suit = modians[1]:getSuitString()
	local number = modians[1]:getNumberString()
	local card_id = modians[1]:getEffectiveId()
	return ("nullification:guaiqi[%s:%s]=%d"):format(suit, number, card_id)
end

local modianvs_skill = {}
modianvs_skill.name = "modian_attach"
table.insert(sgs.ai_skills, modianvs_skill)
function modianvs_skill.getTurnUseCard(self)
	if self.player:isKongcheng() then return nil end
	if self.player:hasFlag("Forbidmodian") then return nil end
		
	local cards = sgs.QList2Table(self.player:getCards("hs"))
	local card
	self:sortByUseValue(cards,true)
	for _,acard in ipairs(cards)  do
		if acard:isBlack() then
			card = acard
			break
		end
	end
	if not card then return nil end

	local skillcard = sgs.Card_Parse("@ModianCard="..card:getEffectiveId())

	assert(skillcard)
	return skillcard
end
local modianself_skill = {}
modianself_skill.name = "modian"
table.insert(sgs.ai_skills, modianself_skill)
function modianself_skill.getTurnUseCard(self)
	return modianvs_skill.getTurnUseCard(self)
end
sgs.ai_skill_use_func.ModianCard = function(card, use, self)
	local targets = {}
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("modian") and not friend:hasFlag("modianInvoked") then
			table.insert(targets, friend)
		end
	end
	if #targets > 0 then
		use.card = card
		if use.to then
			use.to:append(targets[1])
			return
		end
	end
end
sgs.ai_card_intention.ModianCard = -40

sgs.ai_skill_cardask["@modian"] = function(self, data)
	local ids = self.player:getPile("modian")
	local tricks = {}
	for _,id in sgs.qlist(ids) do
		local card = sgs.Sanguosha:getCard(id)
		if not card:isKindOf("TrickCard") then 
			return "$" .. id
		end
		table.insert(tricks, card)
	end
	self:sortByUseValue(tricks,true)
	return "$" .. tricks[1]:getId()
end

sgs.ai_skill_choice.modian = function(self, choices, data)
	if choices:match("recover") then return "recover" end
	return "draw"
end
