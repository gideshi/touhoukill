-- translation for Standard General Package

return {
	["standard"] = "标准版",

	-- 魏势力
	["#caocao"] = "魏武帝",
	["caocao"] = "曹操",
	["jianxiong"] = "奸雄",
	[":jianxiong"] = "每当你受到一次伤害后，你可以获得对你造成伤害的牌。",
	["hujia"] = "护驾",
	[":hujia"] = "<font color=\"orange\"><b>主公技，</b></font>每当你需要使用或打出一张【闪】时，你可以令其他魏势力角色选择是否打出一张【闪】（视为由你使用或打出）。",
	["@hujia-jink"] = "请打出一张【闪】响应 %src “护驾”",

	["#simayi"] = "狼顾之鬼",
	["simayi"] = "司马懿",
	["fankui"] = "反馈",
	[":fankui"] = "每当你受到一次伤害后，你可以获得伤害来源的一张牌。",
	["guicai"] = "鬼才",
	[":guicai"] = "每当一名角色的判定牌生效前，你可以打出一张手牌代替之。",
	["@guicai-card"] = CommonTranslationTable["@askforretrial"],
	["~guicai"] = "选择一张手牌→点击确定",

	["#xiahoudun"] = "独眼的罗刹",
	["xiahoudun"] = "夏侯惇",
	["ganglie"] = "刚烈",
	[":ganglie"] = "每当你受到伤害后，你可以进行判定，若结果不为<font color=\"red\">♥</font>，来源选择一项：1.弃置两张手牌；2.受到你对其造成的1点伤害。",

	["#zhangliao"] = "前将军",
	["zhangliao"] = "张辽",
	["tuxi"] = "突袭",
	[":tuxi"] = "摸牌阶段开始时，你可以放弃摸牌并选择一至两名有手牌的其他角色，改为获得他们的各一张手牌。",
	["@tuxi-card"] = "你可以发动“突袭”",
	["~tuxi"] = "选择 1-2 名其他角色→点击确定",

	["#guojia"] = "早终的先知",
	["guojia"] = "郭嘉",
	["tiandu"] = "天妒",
	[":tiandu"] = "每当你的判定牌生效后，你可以获得之。",
	["yiji"] = "遗计",
	[":yiji"] = "每当你受到1点伤害后，你可以观看牌堆顶的两张牌，然后将一张牌交给一名角色，将另一张牌交给一名角色。",

	["#xuchu"] = "虎痴",
	["xuchu"] = "许褚",
	["luoyi"] = "裸衣",
	[":luoyi"] = "摸牌阶段，你可以少摸一张牌，若如此做，每当你于此回合内使用【杀】或【决斗】对目标角色造成伤害时，此伤害+1。",
	["#LuoyiBuff"] = "%from 的“<font color=\"yellow\"><b>裸衣</b></font>”效果被触发，伤害从 %arg 点增加至 %arg2 点",

	["#zhenji"] = "薄幸的美人",
	["zhenji"] = "甄姬",
	["luoshen"] = "洛神",
	[":luoshen"] = "准备阶段开始时，你可以进行判定，若结果为黑色，你获得生效后的判定牌且你可以重复此流程。",
	["qingguo"] = "倾国",
	[":qingguo"] = "你可以将一张黑色手牌当【闪】使用或打出。",

	-- 蜀势力
	["#liubei"] = "乱世的枭雄",
	["liubei"] = "刘备",
	["illustrator:liubei"] = "木美人",
	["rende"] = "仁德",
	[":rende"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以将至少一张手牌交给其他角色，若如此做，当你以此法交给其他角色的手牌首次达到两张或更多时，你回复1点体力。",
	["@rende"] = "你可以发动“仁德”",
	["jijiang"] = "激将",
	[":jijiang"] = "<font color=\"orange\"><b>主公技，</b></font>当你需要使用或打出一张【杀】时，你可令其他蜀势力角色打出一张【杀】（视为由你使用或打出）。",
	["@jijiang-slash"] = "请打出一张【杀】响应 %src “激将”",

	["#guanyu"] = "美髯公",
	["guanyu"] = "关羽",
	["wusheng"] = "武圣",
	[":wusheng"] = "你可以将一张红色牌当【杀】使用或打出。",

	["#zhangfei"] = "万夫不当",
	["zhangfei"] = "张飞",
	["paoxiao"] = "咆哮",
	[":paoxiao"] = "<font color=\"blue\"><b>锁定技，</b></font>你使用【杀】无次数限制。",

	["#zhugeliang"] = "迟暮的丞相",
	["zhugeliang"] = "诸葛亮",
	["guanxing"] = "观星",
	[":guanxing"] = "准备阶段开始时，你可以观看牌堆顶的X张牌，然后将任意数量的牌以任意顺序置于牌堆顶，将其余的牌以任意顺序置于牌堆底。（X为存活角色数且至多为5）",
	["kongcheng"] = "空城",
	[":kongcheng"] = "<font color=\"blue\"><b>锁定技，</b></font>若你没有手牌，你不能被选择为【杀】或【决斗】的目标。",
	["#GuanxingResult"] = "%from 的“<font color=\"yellow\"><b>观星</b></font>”结果：%arg 上 %arg2 下",
	["$GuanxingTop"] = "置于牌堆顶的牌：%card",
	["$GuanxingBottom"] = "置于牌堆底的牌：%card",

	["#zhaoyun"] = "少年将军",
	["zhaoyun"] = "赵云",
	["longdan"] = "龙胆",
	[":longdan"] = "你可以将一张【杀】当【闪】使用或打出，或将一张【闪】当【杀】使用或打出。",

	["#machao"] = "一骑当千",
	["machao"] = "马超",
	["mashu"] = "马术",
	[":mashu"] = "<font color=\"blue\"><b>锁定技，</b></font>你与其他角色的距离-1。\
♦此技能在1v1KOF模式下不可用。",
	["tieji"] = "铁骑",
	[":tieji"] = "每当你使用【杀】指定一名目标角色后，你可以进行判定，若结果为红色，该角色不能使用【闪】响应此【杀】。",

	["#huangyueying"] = "归隐的杰女",
	["huangyueying"] = "黄月英",
	["illustrator:huangyueying"] = "Ask",
	["jizhi"] = "集智",
	[":jizhi"] = "每当你使用锦囊牌选择目标后，你可以展示牌堆顶的一张牌。若此牌为基本牌，你选择一项：1.将之置入弃牌堆；2.用一张手牌替换之。若此牌不为基本牌，你获得之。",
	["@jizhi-exchange"] = "你可以用一张手牌替换展示的【%arg】",
	["qicai"] = "奇才",
	[":qicai"] = "<font color=\"blue\"><b>锁定技，</b></font>你使用锦囊牌无距离限制。你装备区里除坐骑牌外的牌不能被其他角色弃置。 ",

	-- 吴势力
	["#sunquan"] = "年轻的贤君",
	["sunquan"] = "孙权",
	["zhiheng"] = "制衡",
	[":zhiheng"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以弃置任意数量的牌，然后摸等量的牌。",
	["jiuyuan"] = "救援",
	[":jiuyuan"] = "<font color=\"orange\"><b>主公技，</b></font><font color=\"blue\"><b>锁定技，</b></font>其他吴势力角色对处于濒死状态的你使用的【桃】回复的体力+1。",
	["#JiuyuanExtraRecover"] = "%from 的“%arg”被触发，将额外回复 <font color=\"yellow\"><b>1</b></font> 点体力",

	["#ganning"] = "锦帆游侠",
	["ganning"] = "甘宁",
	["qixi"] = "奇袭",
	[":qixi"] = "你可以将一张黑色牌当【过河拆桥】使用。",

	["#lvmeng"] = "白衣渡江",
	["lvmeng"] = "吕蒙",
	["keji"] = "克己",
	[":keji"] = "若你未于出牌阶段内使用或打出【杀】，你可以跳过你的弃牌阶段。",

	["#zhouyu"] = "大都督",
	["zhouyu"] = "周瑜",
	["yingzi"] = "英姿",
	[":yingzi"] = "摸牌阶段，你可以额外摸一张牌。",
	["fanjian"] = "反间",
	[":fanjian"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>若你有手牌，你可以令一名其他角色选择一种花色，然后该角色先获得你的一张手牌再展示之，若此牌的花色与其所选的不同，你对其造成1点伤害。",

	["#huanggai"] = "轻身为国",
	["huanggai"] = "黄盖",
	["kurou"] = "苦肉",
	[":kurou"] = "出牌阶段，你可以失去1点体力，然后摸两张牌。",

	["#luxun"] = "儒生雄才",
	["luxun"] = "陆逊",
	["qianxun"] = "谦逊",
	[":qianxun"] = "<font color=\"blue\"><b>锁定技，</b></font>你不能被选择为【顺手牵羊】与【乐不思蜀】的目标。",
	["lianying"] = "连营",
	[":lianying"] = "每当你失去最后的手牌后，你可以摸一张牌。",

	["#daqiao"] = "矜持之花",
	["daqiao"] = "大乔",
	["guose"] = "国色",
	[":guose"] = "你可以将一张<font color=\"red\">♦</font>牌当【乐不思蜀】使用。",
	["liuli"] = "流离",
	[":liuli"] = "每当你成为【杀】的目标时，你可以弃置一张牌并选择你攻击范围内的一名其他角色（除此【杀】使用者），将此【杀】转移给该角色。",
	["~liuli"] = "选择一张牌→选择一名其他角色→点击确定",
	["@liuli"] = "%src 对你使用【杀】，你可以弃置一张牌发动“流离”",

	["#sunshangxiang"] = "弓腰姬",
	["sunshangxiang"] = "孙尚香",
	["jieyin"] = "结姻",
	[":jieyin"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以弃置两张手牌并选择一名已受伤的男性角色，你和该角色各回复1点体力。",
	["xiaoji"] = "枭姬",
	[":xiaoji"] = "每当你失去一张装备区的装备牌后，你可以摸两张牌。",

	-- 群雄
	["#lvbu"] = "武的化身",
	["lvbu"] = "吕布",
	["wushuang"] = "无双",
	[":wushuang"] = "<font color=\"blue\"><b>锁定技，</b></font>每当你使用【杀】指定一名目标角色后，其需依次使用两张【闪】才能抵消；锁定技，每当你使用【决斗】指定一名目标角色后，或成为一名角色使用【决斗】的目标后，其每次对你响应此【决斗】需依次打出两张【杀】。",
	["@wushuang-slash-1"] = "%src 对你【决斗】，你须连续打出两张【杀】",
	["@wushuang-slash-2"] = "%src 对你【决斗】，你须再打出一张【杀】",

	["#huatuo"] = "神医",
	["huatuo"] = "华佗",
	["qingnang"] = "青囊",
	[":qingnang"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以弃置一张手牌并选择一名已受伤的角色，令该角色回复1点体力。",
	["jijiu"] = "急救",
	[":jijiu"] = "你的回合外，你可以将一张红色牌当【桃】使用。",

	["#diaochan"] = "绝世的舞姬",
	["diaochan"] = "貂蝉",
	["illustrator:diaochan"] = "木美人",
	["lijian"] = "离间",
	[":lijian"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以弃置一张牌并选择两名男性角色，令其中一名男性角色视为对另一名男性角色使用一张【决斗】。",
	["biyue"] = "闭月",
	[":biyue"] = "结束阶段开始时，你可以摸一张牌。",

	["#st_yuanshu"] = "野心渐增",
	["st_yuanshu"] = "袁术",
	["illustrator:st_yuanshu"] = "LiuHeng",
	["wangzun"] = "妄尊",
	[":wangzun"] = "主公的准备阶段开始时，你可以摸一张牌，然后主公本回合手牌上限-1。",
	["tongji"] = "同疾",
	[":tongji"] = "<font color=\"blue\"><b>锁定技，</b></font>若你的手牌数大于你的体力值，且你在一名其他角色的攻击范围内，则其他角色不能被选择为该角色的【杀】的目标。",

	["#st_huaxiong"] = "飞扬跋扈",
	["st_huaxiong"] = "华雄",
	["illustrator:st_huaxiong"] = "地狱许",
	["yaowu"] = "耀武",
	[":yaowu"] = "<font color=\"blue\"><b>锁定技，</b></font>每当你受到一名角色使用的红色【杀】对你造成的伤害时，你令该角色选择一项：1.回复1点体力；2.摸一张牌。",
	["yaowu:recover"] = "回复1点体力",
	["yaowu:draw"] = "摸一张牌",

	-- Test
	["test"] = "测试",

	["zhiba_sunquan"] = "制霸孙权",
	["&zhiba_sunquan"] = "孙权",
	["super_zhiheng"] = "制衡",
	[":super_zhiheng"] = "出牌阶段限X+1次，你可以弃置任意数量的牌：若如此做，你摸等数量的牌。（X为你已损失的体力值）",
	["$super_zhiheng1"] = "容我三思。",
	["$super_zhiheng2"] = "且慢。",

	["wuxing_zhugeliang"] = "五星诸葛",
	["&wuxing_zhugeliang"] = "诸葛亮",
	["super_guanxing"] = "观星",
	[":super_guanxing"] = "准备阶段开始时，你可以观看牌堆顶的五张牌，然后将任意数量的牌以任意顺序置于牌堆顶，将其余的牌以任意顺序置于牌堆底。",

	["super_yuanshu"] = "袁术-测试",
	["&super_yuanshu"] = "袁术",
	["illustrator:super_yuanshu"] = "吴昊",
	["super_yongsi"] = "庸肆",
	[":super_yongsi"] = "<font color=\"blue\"><b>锁定技，</b></font>摸牌阶段，你额外摸X张牌。弃牌阶段开始时，你须弃置X张牌。",

	["super_caoren"] = "曹仁-测试",
	["&super_caoren"] = "曹仁",
	["super_jushou"] = "据守",
	[":super_jushou"] = "结束阶段开始时，你可以摸X张牌，然后将你的武将牌翻面。",

	["super_max_cards"] = "手牌上限",
	["super_offensive_distance"] = "距离-X",
	["super_defensive_distance"] = "距离+X",

	["#gaodayihao"] = "神威如龙",
	["gaodayihao"] = "高达一号",
	["&gaodayihao"] = "神赵云",
	["illustrator:gaodayihao"] = "巴萨小马",
	["nosjuejing"] = "绝境",
	[":nosjuejing"] = "<font color=\"blue\"><b>锁定技，</b></font>摸牌阶段，你不摸牌。每当你的手牌数变化后，若你的手牌数不为4，你须将手牌补至或弃置至四张。",
	["noslonghun"] = "龙魂",
	[":noslonghun"] = "你可以将一张牌按以下规则使用或打出：<font color=\"red\">♥</font>当【桃】；<font color=\"red\">♦</font>当火【杀】；♠当【无懈可击】；♣当【闪】。准备阶段开始时，若其他角色的装备区内有【青釭剑】，你可以获得之。",
	["#noslonghun_duojian"] = "龙魂",

	["nobenghuai_dongzhuo"] = "董卓-无崩",
	["&nobenghuai_dongzhuo"] = "董卓",
	["illustrator:nobenghuai_dongzhuo"] = "小冷",

	["#sujiang"] = "金童",
	["sujiang"] = "素将",
	["illustrator:sujiang"] = "巴萨小马",
	["#sujiangf"] = "玉女",
	["sujiangf"] = "素将(女)",
	["&sujiangf"] = "素将",
	["illustrator:sujiangf"] = "巴萨小马",
}

