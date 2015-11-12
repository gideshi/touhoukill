return
{
    ["th08"] = "永夜抄",
    ["yyc"] = "永",
    

    --yyc001  势力：永 4血 
    ["yyc001"] = "蓬莱山辉夜",
    ["#yyc001"] = "永远与须臾的罪人",
    ["!yyc001"] = "蓬莱山辉夜",
    ["yongheng"] = "永恒",
    [":yongheng"] = "<font color=\"blue\"><b>锁定技，</b></font>你须跳过弃牌阶段。你的回合外，若你的手牌数大于四，你须将手牌弃至四张。你的回合外，若你的手牌数小于四，你须将手牌摸至四张。",
        
    ["zhuqu"] = "竹取",
    [":zhuqu"] = "<font color=\"orange\"><b>主公技，</b></font>当其他永势力角色的<font size=\"5\", color=\"#FF0000\"><b>♦</b></font>判定牌生效后，其可令你回复1点体力。",
    ["@zhuqu"]="你可以指定拥有主公技“竹取”的角色，该角色回复1点体力。",
    
    --yyc002  势力：永 4血 
    ["yyc002"] ="八意永琳",
    ["#yyc002"] = "月之头脑",
    ["!yyc002"] ="八意永琳",
    ["ruizhi"] = "睿智",
    [":ruizhi"] = "在一张非延时类锦囊牌对你结算后，若你已受伤，你可以判定，若结果为红色，你回复1点体力。",
    ["ruizhi:invoke"]="非延时类锦囊牌【%src】对你结算完毕，你可以发动“睿智”。",
        
    ["miyao"] = "秘药",
    [":miyao"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可令一名有手牌的其他角色弃置一张手牌，然后该角色回复1点体力。",
    ["miyao_cardchosen"]="“秘药”：请弃置一张手牌。",

    --yyc003  势力：永 4血 
    ["yyc003"] = "藤原妹红",
    ["#yyc003"] = "蓬莱人之形",
    ["!yyc003"] = "藤原妹红",
    ["bumie"] = "不灭",
    [":bumie"] = "<font color=\"blue\"><b>锁定技，</b></font>你的体力最少为1。若你的体力为1且没有手牌，你摸一张牌并展示之，若此牌不为<font size=\"5\", color=\"#FF0000\"><b>♦</b></font>，你失去1点体力上限并回复体力至上限。",
    ["#bumie01"] = " %from 的 “%arg” 被触发， %from 最多扣减 %arg2 点体力。",
    ["#bumie02"] = "由于 “%arg” 的效果， %from 失去了一点体力上限，并将体力值恢复至 %arg2 点。",
        
    ["lizhan"]="历战",
    ["lizhan:target"]="<font color=\"#00FF00\"><b>%src </b></font>的弃牌阶段有不少于一张的【杀】进入弃牌堆。你可以发动“历战”，获得其中一张。",
    [":lizhan"] ="其他角色的弃牌阶段结束时，你可以获得一张于此阶段置入弃牌堆的【杀】，然后你可以对该角色使用一张【杀】。",
    ["@lizhan_slash"]="你可以发动“历战”，对<font color=\"#00FF00\"><b>%src </b></font>使用一张【杀】。",
        
    --yyc004  势力：永 4血 
    ["yyc004"]="铃仙·优昙华院·稻叶",
    ["&yyc004"]="铃仙",
    ["#yyc004"]="狂气的月兔",
    ["!yyc004"]="铃仙",
    ["kuangzao"]="狂躁",
    [":kuangzao"]="<font color=\"green\"><b>出牌阶段限一次，</b></font>你可令一名你在其攻击范围内的角色选择一项：对你使用一张【杀】，或受到无来源的1点伤害。",
    ["@kuangzao-slash"] = "<font color=\"#00FF00\"><b>%src </b></font>对你发动“狂躁”，请对其使用一张【杀】，否则你受到无来源的1点伤害。",
        
    ["huanshi"]="幻视",
    ["@huanshi"]="<font color=\"#00FF00\"><b>%src </b></font>使用【杀】指定了你，你可以发动“幻视”，指定<font color=\"#00FF00\"><b>%src </b></font>攻击范围内的一名角色，视为该角色也成为此【杀】的目标。",
    ["~huanshi"]="指定一名角色→点击“确定”。",
    [":huanshi"]="当你成为其他角色使用的【杀】的目标时，你可以指定其攻击范围内的一名角色（不能是此【杀】的目标），该角色成为此【杀】的目标（你仍是此【杀】的目标）。",
    
    --yyc005  势力：永 3血 
    ["yyc005"] = "上白泽慧音",
    ["#yyc005"] = "知识与历史的半兽",
    ["!yyc005"] = "上白泽慧音",
    ["shishi"] = "噬史", 
    [":shishi"] = "每当其他角色使用一张【杀】或非延时类锦囊牌时，若你的人物牌上没有“历史”，你可令此牌无效。若如此做，将此牌置于你的人物牌上，称为“历史”。",
    ["lishi"] = "历史", 
    ["shishi:use"] = "你使用发动“噬史”， 令<font color=\"#00FF00\"><b>%src </b></font> 使用的 【%dest】无效？”。" ,
        
    ["shouye"] = "授业", 
    [":shouye"] = "准备阶段开始时或每当你受到伤害后，你可以将所有“历史”加入一名其他角色的手牌。",
    ["@shouye"] = "你可以将所有“历史”交给一名其他角色", 

    --yyc006  势力：永 3血
    ["yyc006"] = "因幡帝",
    ["#yyc006"] = "幸运的白兔",
    ["!yyc006"] = "因幡帝",
    ["buxian"] = "布陷",
    [":buxian"] = "出牌阶段开始时或每当你受到伤害后，你可以将一张手牌置于牌堆顶，并令两名其他角色进行拼点。点数大的一方摸一张牌，并受到无来源的1点伤害。",
    ["@buxian"] = "你可以发动“布陷”。",
    ["~buxian"]="选择一张手牌→选择两名其他角色→点击确定。或者取消发动。",
        
    ["xingyun"] = "幸运",
    [":xingyun"] = "每当你获得一张<font size=\"5\", color=\"#FF0000\"><b>♥</b></font>牌后，你可以展示此牌并选择一项：回复1点体力，或令一名角色摸一张牌。",
    ["xingyun:letdraw"] = "令一名角色摸一张牌" ,
    ["xingyun:recover"] = "你回复1点体力" ,
    ["@xingyun-select"]="指定一名角色，该角色摸一张牌。",

    --yyc007  势力：永 3血
    ["yyc007"] = "米斯蒂娅·萝蕾拉",
    ["&yyc007"]="米斯蒂娅",
    ["#yyc007"] = "夜雀妖怪",
    ["!yyc007"] = "米斯蒂娅",
    ["gesheng"] = "歌声",
    [":gesheng"] = "其他角色的判定阶段开始时，若场上没有非<font size=\"5\", color=\"#FF0000\"><b>♦</b></font>的【乐不思蜀】，你可以摸一张牌。若如此做，此阶段结束时，你选择一项：将一张手牌当【乐不思蜀】对该角色使用，或失去2点体力。",
	["@gesheng"] = "你须发动“歌声”，对当前回合人<font color=\"#00FF00\"><b>%src </b></font>使用【乐不思蜀】,否则失去2点体力",
	["~gesheng"] ="选择一张手牌->确定",
	["yemang"] = "夜盲",
    [":yemang"] = "<font color=\"blue\"><b>锁定技，</b></font>若其他角色与你的距离不小于X（X为你的体力值），该角色使用【杀】时不能指定你为目标。",

    --yyc008  势力：永 3血
    ["yyc008"] = "莉格露•奈特巴格",
    ["&yyc008"] = "莉格露",
    ["#yyc008"] = "在黑暗中蠢动的光虫",
    ["!yyc008"] = "莉格露",
    ["yinghuo"] = "荧火", 
    [":yinghuo"] = "每当你需要使用或打出一张【闪】时，你可以展示一张【闪】，视为你使用或打出一张【闪】。", 
    ["@yinghuo"] = "你可以发动“荧火”，展示一张【闪】，视为你使用或打出一张【闪】", 

 
    ["chongqun"] = "虫群", 
    [":chongqun"] = "每当你使用或打出一张基本牌时，你可令一名有牌的其他角色弃置一张牌。",
    ["@chongqun_target"]="指定一名角色，该角色须弃置一张牌。",
    ["chongqun_discard"]="<font color=\"#00FF00\"><b>%src </b></font>对你发动了“虫群”：请弃置一张牌",


    --yyc009  势力：永 3血
    ["yyc009"] = "白泽",
    ["#yyc009"] = "治世之兆",
    ["!yyc009"] = "白泽",
    ["chuangshi"] = "创史", 
    [":chuangshi"] = "摸牌阶段开始时，你可以指定一名其他角色，视为其使用一张你指定的任意基本牌或非延时类锦囊牌（【酒】、【南蛮入侵】、【万箭齐发】、【桃园结义】除外）。若此牌需要指定目标，目标由你指定。若如此做，此阶段你少摸一张牌。",
	["chuangshi_victim"]="创史",
    ["@chuangshi_victim"]="请选择 <font color=\"#00FF00\"><b>%src </b></font> 使用创史牌【%dest】的目标。",
    ["@chuangshi_target"]="指定一名执行创史效果的角色。",
    ["chuangshi_user"]="创史执行人",
    ["@chuangshi_prompt"]="选择 <font color=\"#00FF00\"><b>%src </b></font> 使用创史牌的目标。",
    ["~chuangshi"]="若不须指定目标，直接确定。",
    
    ["wangyue"] = "望月", 
    [":wangyue"] = "每当你受到伤害后，你可令伤害来源将手牌弃至X张（X为你当前的体力值）。",
    ["wangyue:target"] = "<font color=\"#00FF00\"><b>%src </b></font>对你造成了伤害，你可以发动“望月”，令其将手牌弃至 %arg 张。", 
 
    --yyc010  势力：永 4血
    ["yyc010"] = "自警队妹红",
    ["#yyc010"] = "红之自警队",
    ["!yyc010"] = "SP自警队妹红",
    ["huwei"] = "护卫", 
    [":huwei"] = "出牌阶段外，每当你需要使用或打出一张【杀】时，你可以摸两张牌。出牌阶段外，每当你使用、打出或弃置一张【杀】时，你可令一名其他角色摸两张牌。", 
    ["@huwei_targetdraw"]="你可令一名其他角色摸两张牌（你还能发动 %src 次“护卫”）。",
 
    ["jinxi"] = "今昔", 
    ["@jinxi"]="浴火重生",
    [":jinxi"] = "<font color=\"red\"><b>限定技，</b></font>出牌阶段，若你已受伤，你可以回复体力至上限，然后将手牌摸至四张。",
    ["$jinxiAnimate"]="image=image/animate/jinxi.png",
 }
