﻿return{
    ["th10"] = "风神录",
    ["fsl"] = "风",
    
    --fsl001  势力：风 4血
    ["kanako"] = "八坂神奈子",
    ["#kanako"] = "山坡与湖水的化身",
    ["!kanako"] = "八坂神奈子",
	--["designer:kanako"] = "星野梦美 | 程序:fsu0413", 
	["illustrator:kanako"] = "sayori (p号:2272079)",
	--个人id:104409(国人)
	["illustrator:kanako_1"] = "だいん (p号:19171641)",
	--个人id:81259
	["illustrator:kanako_2"] = "砂雲 (p号:25008022)",
	--个人id:295604
	["illustrator:kanako_3"] = "かなりあ (p号:15512342)",
	--个人id:180460
	["illustrator:kanako_4"] = "栗 (p号:44206123)",
	--个人id:36168
	["cv:kanako"] = "暂无", 
	
    ["shende"] = "神德",
    ["~shende"] = "选择两张“神德”→点击“确定”。",
    ["@shende-twoCards"] = "你可以发动技能“神德”，将两张“神德”当【桃】使用。",
    [":shende"] ="当你使用或打出一张【杀】时，你可以摸一张牌，然后将一张手牌置于你的人物牌上，称为“神德”。你可以将两张“神德”当【桃】使用。",
    ["shendedummy"]="神德",
    ["shende-exchange"] ="请将一张手牌作为“神德”置于人物牌上。",
    ["qiankun"] = "乾坤",
    [":qiankun"] = "<font color=\"blue\"><b>锁定技，</b></font>你的手牌上限+2。",
    ["gongfeng"] = "供奉",
    [":gongfeng"] = "<font color=\"orange\"><b>主公技，</b></font><font color=\"green\"><b>其他风势力角色的出牌阶段限一次，</b></font>该角色可以将一张【杀】交给你。",
    ["gongfeng_attach"]="供奉给杀",
    [":gongfeng_attach"]="若你属于风势力，你可于出牌阶段将一张【杀】交给拥有主公技“供奉”的角色。每阶段限一次。",

--************************************************
    --fsl002  势力：风 3血
    ["suwako"] = "泄矢诹访子", 
    ["#suwako"] = "土著神的顶点",
    ["!suwako"] = "泄矢诹访子", 
	--["designer:suwako"] = "星野梦美 | 程序:幻兰幽梦", 
	["illustrator:suwako"] = "茶葉 (p号:3882007)",
	--个人id:13233
	["illustrator:suwako_1"] = "miya9 (p号:4102012)",
	--个人id:110090
	["illustrator:suwako_2"] = "カズ (p号:22348330)",
	--个人id:137496
	["illustrator:suwako_3"] = "伊吹のつ (p号:36385307)",
	--个人id:7013
	["illustrator:suwako_4"] = "An2A    (p号:无，个人id:173876)",
	--个人id:173876  p站没有原图
	["illustrator:suwako_5"] = "たまの毛太郎    (p号:34452052)",
	--个人id:16731
	["cv:suwako"] = "暂无", 
	
    ["bushu"] = "不输",
    [":bushu"] = "当你或你攻击范围内的一名角色受到伤害后，你可以与伤害来源拼点：若你赢，该角色回复1点体力；若你没赢，你获得伤害来源的拼点牌。",
    ["bushu:damage"] = "<font color=\"#FF8000\"><b> %src </b></font> 对 <font color=\"#00FF00\"><b> %dest </b></font> 造成了伤害，你可以发动“不输”。",
    ["chuancheng"] = "传承",
    [":chuancheng"] = "当你死亡时，你可令一名其他角色获得技能“乾坤”和“传承”，然后该角色获得你区域里的所有牌。",
    ["@chuancheng"] = "指定一名其他角色，该角色获得技能“传承”“乾坤”以及你区域里的所有牌。",
    
--************************************************
    --fsl003  势力：风 3血
    ["sanae"] = "东风谷早苗",
    ["#sanae"] = "被祭拜的风之人",
    ["!sanae"] = "东风谷早苗",
	  --["designer:sanae"] = "星野梦美 | 程序:三国有单", 
	["illustrator:sanae"] = "茨乃 (p号:3204312)",
	--个人id:67388
	["illustrator:sanae_1"] = "郁 (p号:37694260)",
	--个人id:4556900
	["illustrator:sanae_2"] = "郁 (p号:41107223)",
	--个人id:4556900
	["illustrator:sanae_3"] = "6U (p号:16318792)",
	--个人id:94883
	["illustrator:sanae_4"] = "non (p号:44910310)",
	--个人id:19068
	["cv:sanae"] = "暂无",
	
    ["zhunbei"] = "准备", 
    [":zhunbei"] = "摸牌阶段开始时，你可以放弃摸牌，若如此做，此回合结束时，你摸三张牌。", 
    ["qiji"] = "奇迹",
    [":qiji"] = "你可以将最后一张手牌当任意基本牌或非延时类锦囊牌使用或打出。<font color=\"green\"><b>每阶段限一次，</b></font>",
    ["~qiji"] = "选择最后一张手牌和目标→点击“确定”。",
    ["@qiji_target"]="是否发动“奇迹”，使用【%src】",
    ["qijipeach"]="奇迹出桃",
    ["qijislash"]="奇迹响应出杀",
    [":dfgzm_qiji_card"]="奇迹选牌",
    ["@qiji"]="奇迹已使用",
    ["dfgzm_qiji"]="奇迹选择使用牌",
    ["@response_slash"]="奇迹被动地使用一张【杀】",
    ["@qijisave"]="奇迹被动使用【桃】或【酒】",
    ["qiji_skill_slash"]="奇迹";
    ["qiji_skill_saveself"]="奇迹";
    
--************************************************
    --fsl004  势力：风 3血
    ["aya"] = "射命丸文",
    ["#aya"] = "最接近里的天狗",
    ["!aya"] = "射命丸文", 
	 --["designer:aya"] = "星野梦美 | 程序:幻兰幽梦", 
	["illustrator:aya"] = "sayori (p号:9560039)",
	--个人id:104409(国人)
	["illustrator:aya_1"] = "リリア (p号:10207828)",
	--个人id:997454
	["illustrator:aya_2"] = "しらび (p号:16988865)",
	--个人id:216403
	["illustrator:aya_3"] = "NEKO (p号:31067277)",
	--个人id:2600911 （国人）
	["illustrator:aya_4"] = "kirero (p号:33231066)",
	--个人id:35490
	["cv:aya"] = "暂无", 
	
    ["fengshen"] = "风神",
    [":fengshen"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以弃置一张红色手牌，令你攻击范围内的一名角色或距离为1的任意数量的角色各选择一项：弃置一张【杀】，或受到你造成的1点伤害。",
    ["@fengshen-discard"] = "请弃置一张【杀】，否则受到 <font color=\"#00FF00\"><b>%src </b></font> 对你造成的1点伤害",
    ["fengsu"] = "风速",
    [":fengsu"] = "<font color=\"blue\"><b>锁定技，</b></font>你与其他角色的距离-X（X为你已损失的体力值），其他角色与你的距离+X。",
    
--************************************************
    --fsl005  势力：风 3血
    ["nitori"] = "河城荷取",
    ["#nitori"] = "超妖怪弹头",
    ["!nitori"] = "河城荷取",
	    --["designer:nitori"] = "星野梦美 | 程序:幻兰幽梦", 
	["illustrator:nitori"] = "ne-on (p号:6607613)",
	--个人id:456107
	["illustrator:nitori_1"] = "しがらき (p号:18985064)",
	--个人id:1004274
	["illustrator:nitori_2"] = "bon (p号:16550844)",
	--个人id:1225738
	["illustrator:nitori_3"] = "pico (p号:15558347)",
	--个人id:347929
	["illustrator:nitori_4"] = "みや (p号:16295072)",
	--个人id:41977
	["cv:nitori"] = "暂无",
	
    ["xinshang"] = "心伤",
    [":xinshang"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可令一名其他角色摸一张牌，然后该角色选择一项：将一张<font size=\"5\", color=\"#808080\"><b>♠</b></font>手牌交给你，并令你于此回合内使用牌时无距离和使用次数限制；或令你依次弃置其两张牌。",
    ["@xinshang-spadecard"] = "请交给 <font color=\"#00FF00\"><b>%src </b></font> 一张<font size=\"5\", color=\"#808080\"><b>♠</b></font>手牌，否则将被 <font color=\"#00FF00\"><b>%src </b></font> 弃置两张牌。",
    ["micai"] = "迷彩",
    [":micai"] = "<font color=\"blue\"><b>锁定技，</b></font>当你受到伤害时，若此伤害多于X点（X为你的手牌数），将此伤害改为X点。",
    ["#micai01"]="%from 的 “%arg” 被触发，防止了 %arg2 点伤害。",

--************************************************
    --fsl006  势力：风 3血
    ["hina"] = "键山雏",
    ["#hina"] = "秘神流人偶",
    ["!hina"] = "键山雏",
  --["designer:hina"] = "星野梦美 | 程序:三国有单", 
	["illustrator:hina"] = "Lowlight.K (p号:6091680)",
	--个人id:904187（国人？）
	["illustrator:hina_1"] = "nyanya (p号:16162682)",
	--个人id:195891
	["illustrator:hina_2"] = "vima (p号:31240062)",
	--个人id:546819 （貌似可用 国人？）
	["illustrator:hina_3"] = "pico (p号:2984616)",
	--个人id:347929
	["illustrator:hina_4"] = "その (p号:29887849)",
	--个人id:375767
	["cv:hina"] = "暂无",
	
    ["jie"] = "集厄", 
	[":jie"] = "当其他角色受到伤害时，你可以摸一张牌，将此伤害转移给你。",
	["jie:transfer1"]=" <font color=\"#FF8000\"><b>%src </b></font> 将受到来自 <font color=\"#00FF00\"><b>%dest </b></font> 的%arg点伤害[%arg2]，你是否发动“集厄”。",
	["jie:transfer2"]=" <font color=\"#FF8000\"><b>%src </b></font> 将受到无来源的%arg点伤害[%arg2]，你是否发动“集厄”。",
	["liuxing"] = "流刑", 
	[":liuxing"] = "其他角色的结束阶段开始时，若你已受伤，你可以将一张黑色手牌交给该角色，令其选择一项：失去1点体力，或令你回复1点体力。",
	["@liuxing"] = "你可以发动“流刑”，交给 <font color=\"#00FF00\"><b>%src </b></font> 一张黑色手牌，" , 
	["liuxing:losehp"] = "失去一点体力",
    ["liuxing:recover"] = "令流刑技能人回复一点体力",
	
--************************************************
    --fsl007  势力：风 3血
    ["sanae_sp"] = "高中生早苗",
    ["#sanae_sp"] = "现代的女高中生",
    ["!sanae_sp"] = "SP高中生早苗",
	--["designer:sanae_sp"] = "星野梦美 | 程序:三国有单", 
	["illustrator:sanae_sp"] = "宮瀬まひろ (p号:28915592)",
	--个人id:544479
	["illustrator:sanae_sp_1"] = "宮瀬まひろ (p号:20577229)",
	--个人id:544479
	["illustrator:sanae_sp_2"] = "にいち (p号:29225835)",
	--个人id:1035047
	["cv:sanae_sp"] = "暂无",
	
    ["changshi"] = "常识", 
    [":changshi"] = "<font color=\"#808080\"><b>永久技，</b></font>你的回合开始时，你令所有其他角色的所有技能于此回合内失效（永久技除外），将所有处于特殊位置的牌置入弃牌堆，弃所有标记。", 
    ["#changshi01"]="%from 的 “%arg”被触发，%from 的回合内，所有技能均失效（永久技除外）。",
    ["@changshi"] = "常识",
    ["jinian"] = "纪念", 
    [":jinian"] = "当你失去的最后的手牌置入弃牌堆后，你可以获得之。<font color=\"green\"><b>每阶段限一次，</b></font>",

--************************************************
    --fsl008  势力：风 4血
    ["momizi"] = "犬走椛",
    ["#momizi"] = "山上的千里眼",
    ["!momizi"] = "犬走椛",
	--["designer:momizi"] = "星野梦美 | 程序:三国有单", 
	["illustrator:momizi"] = "啓々 (p号:4742307)",
	--个人id:30974 (非社团作品可以)
	["illustrator:momizi_1"] = "みや (p号:16407016)",
	--个人id:41977
	["illustrator:momizi_2"] = "kirero (p号:17035902)",
	--个人id:35490
	["illustrator:momizi_3"] = "イチゼン (p号:41627409)",
	--个人id:610073
	["illustrator:momizi_4"] = " 海緒ユカ (p号:36115216)",
	--个人id:179619
	["illustrator:momizi_5"] = "松吉 (p号:45607251)",
	--个人id:2344745
	["illustrator:momizi_6"] = "kittona (p号:45871178)",
	--个人id:1537530
	["cv:momizi"] = "暂无",
	
    ["tianyan"] = "天眼", 
    [":tianyan"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以摸X张牌（X为角色数且最多为4），然后将X张手牌以任意顺序置于牌堆顶。", 
    ["tianyan_exchange"]="请选择 %src 张要置于牌堆顶的牌。",
    ["$GuanxingTop"] = "置于牌堆顶的牌：%card",
    ["$GuanxingBottom"] = "置于牌堆底的牌：%card",
    
--************************************************
    --fsl009  势力：风 4血
    ["minoriko"] = "秋穰子",
    ["#minoriko"] = "丰收与成熟的象征",
    ["!minoriko"] = "秋穰子",
	  --["designer:minoriko"] = "星野梦美 | 程序:果然萝卜斩", 
	["illustrator:minoriko"] = "ツヤダシシュウジ  (p号:无,个人id:2022150)",
	--个人id:2022150
	["illustrator:minoriko_1"] = "Sui.  (p号:33263621)",
	--个人id:304123
	["illustrator:minoriko_2"] = "ファルまろ  (p号:45941278)",
	--个人id:1218472
	["illustrator:minoriko_3"] = "shinia  (p号:31553367)",
	--个人id:44778
	["cv:minoriko"] = "暂无",
	
    ["fengrang"] = "丰穰",
    [":fengrang"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可视为使用一张【五谷丰登】。",
    ["shouhuo"] = "收获",
    [":shouhuo"] = "<font color=\"blue\"><b>锁定技，</b></font>当指定了你为目标的【五谷丰登】结算时，额外亮出牌堆顶的一张牌。当你选择时，此【五谷丰登】不能被【无懈可击】响应，你额外获得展示的牌中的一张。",

--************************************************
    --fsl010  势力：风 4血
    ["shizuha"] = "秋静叶",
    ["#shizuha"] = "寂寞与终焉的象征",
    ["!shizuha"] = "秋静叶",
	  --["designer:shizuha"] = "星野梦美 | 程序:三国有单", 
	["illustrator:shizuha"] = "ポップル (p号:7048869)",
	--个人id:888775 已退p站
	["illustrator:shizuha_1"] = "c7肘 (p号:42826425)",
	--个人id:217707(国人,表态可以)
	["illustrator:shizuha_2"] = "平賀まつり (p号:1576775)",
	--个人id:38471
	["illustrator:shizuha_3"] = "姫神かをり (p号:34359840)",
	--个人id:4103725
	["cv:shizuha"] = "暂无",
	
    ["jiliao"] = "寂寥", 
    [":jiliao"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以将一名角色的装备区里的所有牌返回该角色手牌。然后若该角色的手牌数大于其手牌上限，你可以弃置该角色的一张手牌。", 
    ["jiliao:throwcard"] ="“寂寥”：<font color=\"#00FF00\"><b>%src </b></font> 的手牌数大于其手牌上限，你可以弃置其一张手牌。" ,
    ["zhongyan"] = "终焉", 
    ["@zhongyan"] = "终焉",
    [":zhongyan"] = "<font color=\"red\"><b>限定技，</b></font>当你受到其他角色对你造成的伤害时，你可以防止此伤害，并令该角色失去X点体力（X为该角色已损失的体力值且最少为1）。",
    ["zhongyan:target"] ="<font color=\"#00FF00\"><b>%src </b></font> 将对你造成伤害，你可以发动限定技“终焉”，防止此伤害，并令其失去 %dest 点体力。" ,
    ["$zhongyanAnimate"]="image=image/animate/zhongyan.png",
    
--************************************************
    --fsl011  势力：风 4血
    ["sanae_slm"] = "神灵庙sp早苗",
    ["&sanae_slm"] = "神灵庙早苗",
    ["#sanae_slm"] = "私欲的巫女",
    ["!sanae_slm"] = "神灵庙sp早苗",
	 --["designer:sanae_slm"] = "星野梦美 | 程序:三国有单", 
	["illustrator:sanae_slm"] = "小強 (p号:19757581)",
	--个人id:1754781(国人)
	["illustrator:sanae_slm_1"] = "An2A (p号:27724528)",
	--个人id:173876
	["illustrator:sanae_slm_2"] = "木shiyo (p号:34431982)",
	--个人id:40222
	["cv:sanae_slm"] = "暂无",
	
    ["yuwang_list"] = "欲望",
    ["dfgzmsiyu"] = "私欲",
    [":dfgzmsiyu"] ="<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以将一张手牌交给一名其他角色。此回合结束时，你观看该角色的手牌并获得其中的一张。",
    ["qishu"] = "奇术",
    [":qishu"] = "你使用最后的手牌时无距离限制。出牌阶段，当你对其他角色使用【杀】或非延时类锦囊牌时，若此牌是你最后的手牌，你可以额外指定任意数量的其他角色为目标。",
    ["~qishu"] = "第一个目标为持有武器的角色，第二个目标为出杀的目标。",
    ["@qishu-add"] = "请选择【%arg】的额外目标",
    ["#QishuAdd"] = "%from 发动了“%arg2”为【%arg】增加了额外目标 %to",
    
}
