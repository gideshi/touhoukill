return{
    ["th11"] = "地灵殿",
    ["dld"] = "地",    
    
    --dld001  势力：地 3血
    ["satori"] = "古明地觉",
    ["#satori"] = "连怨灵也恐惧的少女",
    ["!satori"] = "古明地觉",
	 --["designer:satori"] = "星野梦美 | 程序:三国有单", 
	["illustrator:satori"] = "かめ (p号:2776523)",
	--个人id:87447
	["illustrator:satori_1"] = "ななしな (p号:26084258)",
	--个人id:274594(貌似可)
	["illustrator:satori_2"] = "爽希 (p号:38729388)",
	--个人id:2318975
	["illustrator:satori_3"] = "栗 (p号:26035175)",
	--个人id:36168
	["illustrator:satori_4"] = "おいもとじろう (p号:16474477)",
	--个人id:7154
	["cv:satori"] = "暂无",
	
    ["xiangqi"] = "想起",
    [":xiangqi"] ="当你或你攻击范围内的一名角色受到另一名角色使用的牌造成的伤害后，若伤害来源不是你，你可以展示伤害来源的一张手牌：若与造成伤害的牌类别相同且该角色不是你，弃置之，你对该角色造成1点伤害；否则，该角色获得之。",
    ["xiangqi:show"]="<font color=\"#FF8000\"><b>%src </b></font> 使用【%arg】对 <font color=\"#00FF00\"><b>%dest </b></font> 造成了伤害，你可以发动“想起”。",    
    ["duxin"] = "读心",
    [":duxin"] = "<font color=\"blue\"><b>锁定技，</b></font>当你需要选择其他角色的手牌时，其手牌对你可见。",    
	["huzhu"] = "护主",
    [":huzhu"] = "<font color=\"orange\"><b>主公技，</b></font>当你成为【杀】的目标时，你可令其他地势力角色（不能是此【杀】的使用者或目标）依次选择是否代替你成为此【杀】的目标。",
    ["huzhu_change"]="护主",
    ["huzhu_change:slashtarget"]="你可以响应 <font color=\"#00FF00\"><b>%dest </b></font> 的主公技“护主”，代替 <font color=\"#00FF00\"><b>%dest </b></font> 成为 <font color=\"#FF8000\"><b>%src </b></font> 使用的【%arg】的目标。",    
    ["#huzhu_change"]="%to 代替其成为 %from 使用的 %arg 的目标。",

--*********************************************
    --dld002  势力：地 3血
    ["koishi"] = "古明地恋",
    ["#koishi"] = "紧闭着的恋之瞳",
    ["!koishi"] = "古明地恋",
	--["designer:koishi"] = "星野梦美 | 程序:幻兰幽梦", 
	["illustrator:koishi"] = "深崎暮人　(p号:)",
	--个人id:
	["illustrator:koishi_1"] = "bon　(p号:21914911)",
	--个人id:1225738
	["illustrator:koishi_2"] = "navio*　(p号:16403339)",
	--个人id:585267
	["illustrator:koishi_3"] = "その　(p号:28280279)",
	--个人id:375767
	["illustrator:koishi_4"] = "ばじりす9　(p号:46128559)",
	--个人id:6074371
	["illustrator:koishi_5"] = "ばじりす9　(p号:43629562)",
	--个人id:6074371
	["cv:koishi"] = "暂无",
	
    ["maihuo"] = "埋火",
    [":maihuo"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以将一张手牌置于牌堆顶，然后令一名其他角色展示并获得牌堆顶的两张牌，若均为红色，你可以选择一项：回复1点体力，或摸两张牌。",
    ["maihuo:draw"] = "摸两张牌" ,
    ["maihuo:recover"] = "回复1点体力" ,
    ["wunian"] = "无念",
    ["#wuniantr"]="无念",
    [":wunian"] = "<font color=\"blue\"><b>锁定技，</b></font>你即将造成的伤害视为无来源。若你已受伤，你不是其他角色使用的锦囊牌的合法目标。",

--*********************************************
    --dld003  势力：地 4血
    ["utsuho"] = "灵乌路空",
    ["#utsuho"] = "炽热焦躁的神之火" ,
    ["!utsuho"] = "灵乌路空",
	 --["designer:utsuho"] = "星野梦美 | 程序:fsu0413,三国有单", 
	["illustrator:utsuho"] = "皆村 (p号:9086872)",
	--个人id:6098
	["illustrator:utsuho_1"] = "asagi (p号:37458482)",
	--个人id:9638
	["illustrator:utsuho_2"] = "伊吹のつ (p号:41578982)",
	--个人id:7013
	["illustrator:utsuho_3"] = "NAbyssor (p号:30520942)",
	--个人id:467511
	["cv:utsuho"] = "暂无",
	
    ["yaoban"] = "耀斑" ,
    [":yaoban"] = "当一名角色受到火焰伤害后，你可以弃置一张手牌，对另一名角色造成1点伤害。" ,
    ["@yaoban"] = "<font color=\"#00FF00\"><b>%src </b></font> 受到了火焰伤害，你可以弃置一张手牌，对另一名角色造成1点伤害。" ,
    ["~yaoban"] = "选择一张手牌→指定一名角色→点击“确定”。" ,
    ["here"] = "核热" ,
    [":here"] = "<font color=\"blue\"><b>锁定技，</b></font>锁定技，每当你使用【杀】指定目标时或当你成为【杀】的目标时，此【杀】视为火【杀】。",
    ["#HereFilter"] ="由于“%arg”的效果， %from 使用的【杀】被视为具火焰伤害的【杀】。",
    
--*********************************************
    --dld004  势力：地 4血
    ["rin"] = "火焰猫燐",
    ["#rin"] = "地狱的车祸",
    ["!rin"] = "火焰猫燐",
	--["designer:rin"] = "星野梦美 | 程序:幻兰幽梦", 
	["illustrator:rin"] = "まるかた (p号:5227566)",
	--个人id:6359
	["illustrator:rin_1"] = "リリア (p号:12490103)",
	--个人id:997454
	["illustrator:rin_2"] = "NAbyssor (p号:30521004)",
	--个人id:467511(国人)
	["illustrator:rin_3"] = "Capura.L (p号:20096590)",
	--个人id:2475 (台湾 非商业作品的话，可以自由用)
	["illustrator:rin_4"] = "東天紅 (p号:32154481)",
	--个人id:3757061
	["illustrator:rin_5"] = "繭咲 悠 (p号:16412420)",
	--个人id:1358552
	["cv:rin"] = "暂无",
	
    ["yuanling"] = "怨灵",
    [":yuanling"] = "当你受到伤害后，你可以视为对伤害来源使用一张火【杀】。此【杀】不计入每阶段的使用限制。",
    ["yuanling:target"] = "<font color=\"#00FF00\"><b>%src </b></font> 对你造成了伤害，你可以发动“怨灵”，视为对其使用一张火【杀】。",
    ["songzang"] = "送葬",
    [":songzang"] = "当其他角色处于濒死状态并向你求【桃】前，你可以弃置一张<font size=\"5\", color=\"#808080\"><b>♠</b></font>牌，若如此做，该角色死亡（视为由你杀死）。",
    ["@songzang"] = "“送葬”: 弃置一张<font size=\"5\", color=\"#808080\"><b>♠</b></font>牌，令 <font color=\"#00FF00\"><b>%src </b></font> 死亡（视为由你杀死）。",

--*********************************************
    --dld005  势力：地 4血
    ["yugi"] = "星熊勇仪",
    ["#yugi"] = "人所谈论的怪力乱神",
    ["!yugi"] = "星熊勇仪",
	--["designer:yugi"] = "星野梦美 | 程序:幻兰幽梦", 
	["illustrator:yugi"] = "Ж (p号:3206198)",
	--个人id:7541
	["illustrator:yugi_1"] = "珠洲城くるみ (p号:1188598)",
	--个人id:8065 （可以使用 但许可范围不明）
	["illustrator:yugi_2"] = "藤ひょろね (p号:6218855)",
	--个人id:134118
	["illustrator:yugi_3"] = "Tro (p号:16639186)",
	--个人id:52449
	["cv:yugi"] = "暂无",
	
    ["guaili"] = "怪力",
    [":guaili"] = "当你使用的【杀】被目标角色使用的【闪】抵消时，你可以弃置一张红色手牌，然后摸一张牌，并令此【杀】依然对其生效。",
    ["@guaili"]="你你可以发动“怪力”弃置一张红色手牌，令此【杀】 对<font color=\"#00FF00\"><b>%src </b></font>依旧生效。",
    ["jiuhao"] = "酒豪",
	[":jiuhao"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>若你于此阶段内使用过【桃】或【酒】，你可以视为使用一张【杀】，此【杀】不计入每阶段的使用限制。",
    ["haoyin"] = "豪饮",
    [":haoyin"] = "<font color=\"blue\"><b>锁定技，</b></font>你使用的【酒】的效果+1。每当一名角色使用一张【酒】时，你须摸一张牌。",
    ["#haoyin1"]="%from 的 “%arg” 被触发,【酒】的回复效果+1。",
    ["#haoyin2"]="%from 的 “%arg” 被触发,【酒】的伤害效果+1。",    
    
--*********************************************
    --dld006  势力：地 3血
    ["parsee"]="水桥帕露西",
    ["#parsee"]="地壳下的嫉妒心",
    ["!parsee"]="水桥帕露西", 
  --["designer:parsee"] = "星野梦美 | 程序:幻兰幽梦", 
	["illustrator:parsee"] = "岩本ゼロゴ (p号:无，个人id:3080)",
	--个人id:3080
	["illustrator:parsee_1"] = "みきぷらす (p号:14442359)",
	--个人id:626832
	["illustrator:parsee_2"] = "あとき (p号:34576289)",
	--个人id:131432
	["illustrator:parsee_3"] = "甘党 (p号:23143317)",
	--个人id:298982
	["cv:parsee"] = "暂无",	
	
    ["jidu"]="嫉妒",
    [":jidu"]="你可以将一张手牌当【决斗】使用，体力值小于你的角色不是此【决斗】的合法目标。当你受到【决斗】造成的伤害后，你可以摸一张牌。",
    ["gelong"]="葛笼",
    [":gelong"]="<font color=\"blue\"><b>锁定技，</b></font>当你成为【杀】的目标时，此【杀】的使用者须选择一项：失去1点体力，然后摸一张牌；或将牌堆顶的一张牌当【兵粮寸断】置于其判定区里。",
    ["gelong:gelong1"]="失去1点体力，然后摸一张牌",
    ["gelong:gelong2"]="将牌堆顶的一张牌当【兵粮寸断】置于你的判定区里",
    
--*********************************************
    --dld007  势力：地 4血
    ["yamame"] = "黑谷山女",
    ["#yamame"] = "黑暗洞窟中明亮的网",
    ["!yamame"] = "黑谷山女",
	 --["designer:yamame"] = "星野梦美 | 程序:幻兰幽梦", 
	["illustrator:yamame"] = "ともかつ治臣 (p号:11886525)",
	--个人id:230418
	["illustrator:yamame_1"] = "銀児 (p号:35228783)",
	--个人id:1043393
	["illustrator:yamame_2"] = "紅緒 (p号:35615127)",
	--个人id:644229
	["cv:yamame"] = "暂无",
	
    ["chuanran"] = "传染",
    [":chuanran"] = "一名角色的判定阶段，当该角色判定区里的一张牌置入弃牌堆后，你可以弃置一张黑色牌，将此牌置于另一名角色的判定区里。若此牌不为延时类锦囊牌，此牌视为【兵粮寸断】。",
    ["@chuanran"]="将【%src】置于另一名角色的判定区里。",
    ["~chuanran"]="选择一张黑色牌，指定一名角色。",
    ["#chuanran_move"]=" %arg 被置于 %from 的判定区里。",
    ["rebing"]="热病",
    [":rebing"] = "当你受到伤害后，你可以获得一名判定区里有牌的其他角色的一张手牌。",
    ["@rebing"]="你可以发动“热病”，指定一名判定区里有牌的其他角色，获得其一张手牌。",
    
--*********************************************
    --dld008  势力：地 3血
    ["kisume"] = "琪斯美", 
    ["#kisume"] = "可怕的水井妖怪",
    ["!kisume"] = "琪斯美",
	 --["designer:kisume"] = "星野梦美 | 程序:三国有单", 
	["illustrator:kisume"] = "まるかた (p号:8537445)",
	--个人id:6359
	["illustrator:kisume_1"] = "くろぬこネーロ (p号:33450740)",
	--个人id:335493
	["illustrator:kisume_2"] = "LZH (p号:41926467)",
	--个人id:571766
	["cv:kisume"] = "暂无",
	
    ["diaoping"] = "钓瓶", 
    [":diaoping"] = "当其他角色使用【杀】指定目标后，若此【杀】指定了你或你攻击范围内的角色为目标，你可与此【杀】的使用者拼点：若你赢，此【杀】无效，此【杀】的使用者翻面；若你没赢，你可以重复此流程。", 
    ["diaoping:slashtarget"]="<font color=\"#FF8000\"><b>%src </b></font> 使用了【%dest】，你可以发动“钓瓶”。",      
    ["tongju"] = "桶居", 
    [":tongju"] = "<font color=\"blue\"><b>锁定技，</b></font>你不是【南蛮入侵】、【万箭齐发】、【铁索连环】的合法目标。", 

--*********************************************
    --dld009  势力：地 3血
    ["suika_sp"] = "地灵殿sp萃香" ,
    ["&suika_sp"] = "地灵殿萃香" ,
    ["#suika_sp"] = "小型的百鬼夜行" ,
    ["!suika_sp"] = "地灵殿sp萃香" ,
	 --["designer:suika_sp"] = "星野梦美 | 程序:fsu0413", 
	["illustrator:suika_sp"] = "黄泉洞 (p号:20578676)",
	--个人id:1067088(国人)
	["illustrator:suika_sp_1"] = "えれっと (p号:13980436)",
	--个人id:290340
	["illustrator:suika_sp_2"] = "トイト (p号:30846777)",
	--个人id:1965383
	["cv:suika_sp"] = "暂无",
	
    ["cuiji"] = "萃集" ,
    [":cuiji"] = "摸牌阶段，你可以少摸一至两张牌。每以此法少摸一张牌：你选择一种颜色，依次亮出牌堆顶的牌，直到出现与所选颜色相同的牌，获得之，将其余的牌置入弃牌堆。" ,
    ["red"] = "红色" ,
    ["black"] = "黑色" ,
    ["cuiji:red"] = "红色" ,
    ["cuiji:black"] = "黑色" ,
    ["cuiji:cancel"] = "直接摸牌" ,
    ["#cuiji_choice"]="%from 发动了 “%arg”，选择了 “%arg2”。",
    ["baigui"] = "百鬼" ,
    [":baigui"] = "你可以将一张<font size=\"5\", color=\"#808080\"><b>♠</b></font>手牌当【南蛮入侵】使用。" ,
    ["jiuchong"] = "酒虫" ,
    [":jiuchong"] = "你可以将一张<font size=\"5\", color=\"#FF0000\"><b>♥</b></font>手牌当【酒】使用。" ,

 }



