-- Note for translators:
-- You should never have 
--   SBFOptions.strings.X = SBFOptions.strings.X or "y"
-- You should only have
--   SBFOptions.strings.X = "y"

if (GetLocale() == "zhCN") then 
  -- General Tab
  SBFOptions.strings.GENERALCONFIG = "全局设置"
  SBFOptions.strings.FRAMEUNIT = "框体单位"
  SBFOptions.strings.FRAMENAME = "框体名称"
  SBFOptions.strings.FRAMEBUFFS = "显示buffs"
  SBFOptions.strings.FRAMEDEBUFFS = "显示debuffs"
  SBFOptions.strings.WHITELIST = "白名单"
  SBFOptions.strings.WHITELISTTT = "白名单意思是 \"只显示我允许的(与过滤相关)\""
  SBFOptions.strings.BLACKLIST = "黑名单"
  SBFOptions.strings.BLACKLISTTT = "黑名单意思是 \"不显示我不允许的(与过滤相关)\""
  SBFOptions.strings.CLICKTHROUGH = "点击穿透"
  SBFOptions.strings.CLICKTHROUGHTT = "允许鼠标点击穿透框体"

  -- Layout Tab
  SBFOptions.strings.BIG = "大图标"
  SBFOptions.strings.LAYOUTCONFIG = "样式"
  SBFOptions.strings.BUFF_SCALE = "缩放"
  SBFOptions.strings.OPACITY = "透明度"
  SBFOptions.strings.BUFFHORIZONTAL = "多行显示"
  SBFOptions.strings.BUFFFLIP = "翻转"
  SBFOptions.strings.REVERSEBUFF = "反向排列"
  SBFOptions.strings.XSPACING = "水平间距"
  SBFOptions.strings.YSPACING = "垂直间距"
  SBFOptions.strings.ROWCOUNT = "每行buff数量"
  SBFOptions.strings.COLCOUNT = "每列buff数量"
  SBFOptions.strings.BUFFCOUNT = "buff数量"
  SBFOptions.strings.BUFFSORT = "排序"
  SBFOptions.strings.BUFFRIGHTCLICK = "在这个框体内禁用右键点击"
  SBFOptions.strings.NOTOOLTIPS = "不显示鼠标提示"
  SBFOptions.strings.NOTOOLTIPSTT = "不显示该框体内的buff鼠标提示"
  SBFOptions.strings.MIRRORBUFFS = "镜像1号和2号框体内的buff"
  SBFOptions.strings.RIGHTCLICKTT = "右击不会取消buff"
  SBFOptions.strings.MIRRORTT1 = "Buff会同时在1号和这个框体内显示"
  SBFOptions.strings.MIRRORTT2 = "Debuff会同时在2号和这个框体内显示"
  SBFOptions.strings.VISIBILITY = "框体可见度"
  SBFOptions.strings.BUFFPOSITION = "Buff间距"
  SBFOptions.strings.BUFFGROWTH = "Buff增长"
  SBFOptions.strings.BUFFANCHOR = "停靠点"
  SBFOptions.strings.TOP = "顶部"
  SBFOptions.strings.BOTTOM = "底部"

  -- Timer tab
  SBFOptions.strings.SHOWTIMERS = "显示buff计时"
  SBFOptions.strings.TIMERCONFIG = "计时（%d）"
  SBFOptions.strings.TEXT_POSITIONY = "时间垂直位置"
  SBFOptions.strings.TEXT_POSITIONX = "时间水平位置"
  SBFOptions.strings.TEXT_FORMAT = "时间格式"
  SBFOptions.strings.TIMERCOLOUR = "时间文本颜色"
  SBFOptions.strings.EXPIRECOLOUR = "即将结束的时间文本颜色"
  SBFOptions.strings.TIMERPOSITION = "时间位置"
  SBFOptions.strings.TIMERNA = "将光环效果显示为N/A"
  SBFOptions.strings.TIMERMS = "显示小数点后一位秒数"
  SBFOptions.strings.TIMERMSTT = "当计时剩余五秒时显示小数点后一位秒数"

  -- Icon Tab
    SBFOptions.strings.SHOWICONS = "显示buff图标"
    SBFOptions.strings.ICONCONFIG = "图标（%d）"
    SBFOptions.strings.ICONPOSITION = "图标位置"
  SBFOptions.strings.ICONSIZE = "图标大小"
  SBFOptions.strings.COOLDOWN = "在图标显示冷却扫描"
  SBFOptions.strings.REVERSECOOLDOWN = "反转冷却扫描"
  SBFOptions.strings.SUPPRESSOMNICCTIMER = "使用OmniCC样式"

  -- Count Tab
    SBFOptions.strings.SHOWCOUNTS = "显示buff叠加数"
    SBFOptions.strings.COUNTCONFIG = "叠加数（%d）"
    SBFOptions.strings.STACKCOLOUR = "计数文本颜色"
    SBFOptions.strings.COUNTPOSITION = "计数文本位置"

  -- Bar Tab
    SBFOptions.strings.BARCONFIG = "计时条（%d）"
    SBFOptions.strings.SHOWBARS = "显示buff计时条"
    SBFOptions.strings.BARDIRECTION = "计时条方向"
    SBFOptions.strings.BARWIDTH = "宽度"
    SBFOptions.strings.BARHEIGHT = "高度"
    SBFOptions.strings.BARTEXTURE = "计时条材质"
  SBFOptions.strings.BARTEXTURE = "计时条材质"
    SBFOptions.strings.BARBUFFCOLOUR = "Buff计时条颜色"
    SBFOptions.strings.BARDEBUFFCOLOUR = "Debuff计时条颜色"
    SBFOptions.strings.BARBACKDROP = "计时条背景颜色"
    SBFOptions.strings.DEBUFFBARCOLOUR = "按debuff类型着色名称"
    SBFOptions.strings.DEBUFFBARCOLOURTT1 = "计时条会按照debuff的类型着色"
    SBFOptions.strings.DEBUFFBARCOLOURTT2 = "（诅咒、魔法、中毒等等）"
    SBFOptions.strings.BARPOSITION = "计时条位置"
    SBFOptions.strings.BARNOSPARK = "不显示闪烁"

  -- Name Tab
    SBFOptions.strings.SHOWNAMES = "显示buff名称"
    SBFOptions.strings.NAMECONFIG = "名称（%d）"
    SBFOptions.strings.NAMEBUFFCOLOUR = "Buff颜色"
    SBFOptions.strings.NAMEDEBUFFCOLOUR = "Debuff颜色"
    SBFOptions.strings.NAMECOUNT = "计数格式"
    SBFOptions.strings.NAMEFORMAT = "名称格式"
    SBFOptions.strings.NAMERANK = "等级格式"
    SBFOptions.strings.DEBUFFNAMECOLOUR = "按debuff类型着色名称"
    SBFOptions.strings.DEBUFFNAMECOLOURTT1 = "名称会按照debuff类型着色"
    SBFOptions.strings.DEBUFFNAMECOLOURTT2 = "（诅咒、魔法、中毒等等）"
    SBFOptions.strings.NAMEPOSITION = "名称位置"
  -- v3.1.5
    SBFOptions.strings.NAMEACTIVE = "激活鼠标"
    SBFOptions.strings.NAMEACTIVETT = "Buff名称显示提示,允许取消等" 

  -- Expiry Tab
    SBFOptions.strings.WARNCONFIG = "消隐（%d）"
    SBFOptions.strings.EXPIREWARN = "文本消隐提示"
    SBFOptions.strings.EXPIREWARNTT = "在某个buff即将消失时输出聊天提示"
    SBFOptions.strings.EXPIRENOTICE = "文本消隐警示"
    SBFOptions.strings.EXPIRENOTICETT = "在某个buff即将消失时输出聊天警示"
    SBFOptions.strings.EXPIRESOUND = "声音提示"
    SBFOptions.strings.SOUNDCHOOSE = "声音"
    SBFOptions.strings.WARNSOUND = "警报声音"
    SBFOptions.strings.MINTIME = "最短时间"
    SBFOptions.strings.EXPIRETIME = "警报时间下限"
    SBFOptions.strings.EXPIREFRAME = "聊天框体"
    SBFOptions.strings.EXPIREFRAMETEST = "Buff框体%d的消隐警报会在这里显示"
    SBFOptions.strings.SCTCOLOUR = "颜色"
    SBFOptions.strings.FASTBAR = "快速显示计时条消隐"
    SBFOptions.strings.SCTWARN = "在%s显示消失警报信息"
    SBFOptions.strings.SCTCRIT = "使用爆击动画显示" 
    SBFOptions.strings.SCTCRITTT1 = "如果SCT启用则使用SCT的爆击动画显示消失警报"
    SBFOptions.strings.SCTCRITTTM1 = "你已经设置SCT为使用消息框体渐隐显示Buff。"
    SBFOptions.strings.SCTCRITTTM2 = "当前SCT设置不允许信息显示为爆击"
    SBFOptions.strings.FLASHBUFF = "闪烁即将消失的Buff图标"
    SBFOptions.strings.USERWARN = "仅为选择的特定buff提示"
    SBFOptions.strings.ALLWARN = "所有buff"

  -- Frame stick tab
  SBFOptions.strings.FLOWCONFIG = SBFOptions.strings.FLOWCONFIG or "Buff滑动"
    SBFOptions.strings.STICKTOFRAME = "父框体"
    SBFOptions.strings.FLOWCHILDFRAME = "添加子框体"
    SBFOptions.strings.FLOWEXPIRY = "使用子框体设定消失"

  -- Spells Tab
  SBFOptions.strings.BLACKLISTCHECK = "不显示此buff"
  SBFOptions.strings.WHITELISTCHECK = "显示此buff"
    SBFOptions.strings.ALWAYSWARN = "即将消失时始终警报"
    SBFOptions.strings.MINE = "我施放的"
    SBFOptions.strings.CASTABLE = "本职业施放的"
    SBFOptions.strings.DEFAULTFRAME = "默认框体"
    SBFOptions.strings.SPELLFILTER = "搜索法术"
    SBFOptions.strings.AURA = "光环"
    SBFOptions.strings.CLEARSPELLS = "清除数据"
    SBFOptions.strings.CLEARSPELLSTT1 = "清除SBF的buff缓存数据"
    SBFOptions.strings.CLEARSPELLSTT2 = "如果你遇到了过滤或者buff显示问题请这么做一次"
    SBFOptions.strings.CLEARSPELLSTT3 = "（不会影响你的始终警报/框体分配/显示过滤设定）"
    SBFOptions.strings.SPELLCONFIG = "法术"
  SBFOptions.strings.LISTBUFFSTT = "显示列表中的buffs"
  SBFOptions.strings.LISTDEBUFFSTT = "显示列表中的debuffs"

  -- Global Tab
    SBFOptions.strings.GLOBALCONFIG = "全局设置"
    SBFOptions.strings.HOME = "主页"
    SBFOptions.strings.AURAMAXTIME = "光环效果显示为最大持续时间" 
    SBFOptions.strings.AURAMAXTIMETT1 = "选中后，光环类效果（无持续时间）"
    SBFOptions.strings.AURAMAXTIMETT2 = "会显示为持续时间为最大值的法术。"
    SBFOptions.strings.ENCHANTSFIRST = "优先显示物品附魔"
    SBFOptions.strings.DISABLEBF = "在SBF中禁用ButtonFacade"
    SBFOptions.strings.TOTEMNONBUFF = "不显示非buff图腾"
    SBFOptions.strings.TOTEMOUTOFRANGE = "超出距离也仍显示buff图腾"
    SBFOptions.strings.TOTEMTIMERS = "不显示图腾计时"
  SBFOptions.strings.HIDEPARTY = "使用 \"隐藏小队界面\" 选项"
  SBFOptions.strings.HIDEPARTYTT1 = "勾选此项使小队成员buff框体替换"
  SBFOptions.strings.HIDEPARTYTT2 = "在小队和团队界面的\"在团队中隐藏小队界面\" 选项"

  -- Misc
    SBFOptions.strings.VERSION2 = "Satrina Buff Frames |cff00ff00%s|r"
    SBFOptions.strings.HINT3 = "http://evilempireguild.org/SBF"
    SBFOptions.strings.HINT2 = "按住Alt移动我！"
    SBFOptions.strings.HINT = "有问题吗?  需要帮助? 来这里看看:"
    SBFOptions.strings.FRAME = "框体%d"
    SBFOptions.strings.USINGPROFILE = "正在使用的配置文件"
    SBFOptions.strings.COPYPROFILE = "复制配置文件"
    SBFOptions.strings.DELETEPROFILE = "删除配置文件"
    SBFOptions.strings.NEWPROFILE = "输入新配置文件名"
    SBFOptions.strings.CONFIRMREMOVEPROFILE = "确定要删除配置文件%s？"
    SBFOptions.strings.NEWPROFILEBUTTON = "新建配置文件"

    SBFOptions.strings.BUFFFRAME = "Buff框体"
    SBFOptions.strings.BUFFFRAMENUM = "Buff框体%d"
    SBFOptions.strings.CURRENTFRAME = "当前框体："
    SBFOptions.strings.NEWFRAME = "新建框体"
    SBFOptions.strings.REMOVE = "删除"
    SBFOptions.strings.REMOVEFRAME = "删除框体"
    SBFOptions.strings.REMOVEFRAMETT = "删除这个buff框体"
    SBFOptions.strings.DELETEERROR = "不能删除1号、2号buff框体以及物品附魔框体"
    SBFOptions.strings.DEFAULT_TOOLTIP = "重置框体的样式和消失设置"
    SBFOptions.strings.DEFAULTS = "默认值"
    SBFOptions.strings.DEBUFFTIMER = "按类型着色debuff时间"
    SBFOptions.strings.DEBUFFTIMERTT1 = "时间文本会按debuff类型着色"
    SBFOptions.strings.DEBUFFTIMERTT2 = "（诅咒、魔法、中毒等等）"
    SBFOptions.strings.NEWFRAMETT = "创建新buff框体"
    SBFOptions.strings.NONE = "无"
    SBFOptions.strings.HELP = "帮助"
    SBFOptions.strings.POSITIONBOTTOM = "按住Alt以10为步进调整"
    SBFOptions.strings.FRAMELEVEL = "框体层级%d"

    SBFOptions.strings.FONT = "字体"
    SBFOptions.strings.FONTSIZE = "字体大小（%d）"
    SBFOptions.strings.OUTLINEFONT = "文字描边"
      
    SBFOptions.strings.RESET = "重置框体"
    SBFOptions.strings.RESETFRAMESTT = "重置为SBF默认框体"

    SBFOptions.strings.SHOWINFRAMEDELETE = "不在框体%d内显示%s"
    SBFOptions.strings.SHOWFILTER = "匹配过滤%d:%s"
    SBFOptions.strings.FILTERBLOCKED = "过滤被buff框体%d强制显示所忽略"
    SBFOptions.strings.SHOWBUFFS = "显示buff"
    SBFOptions.strings.SHOWDEBUFFS = "显示debuff"
    SBFOptions.strings.DURATION = "持续时间"

    SBFOptions.strings.JUSTIFY = "对齐"
    SBFOptions.strings.JUSTIFYRIGHT = "右"
    SBFOptions.strings.JUSTIFYLEFT = "左"

    SBFOptions.strings.REFRESH = "Buff条更新频率"
    SBFOptions.strings.COPYFROM = "从...复制"
    SBFOptions.strings.TRACKING = "显示追踪"

  -- Filters Tab
    SBFOptions.strings.FILTERCONFIG = "过滤"
    SBFOptions.strings.FILTER = "新建过滤"
    SBFOptions.strings.ADDFILTER = "添加过滤"
    SBFOptions.strings.EDITFILTER = "编辑过滤"
    SBFOptions.strings.FILTERHELP = "过滤帮助"
    SBFOptions.strings.UP = "上升"
    SBFOptions.strings.DOWN = "下降"
    SBFOptions.strings.EDIT = "编辑"
    SBFOptions.strings.FILTERBLACKLIST = "过滤的buff将不会在此框体显示"
    SBFOptions.strings.FILTERWHITELIST = "过滤的buff将在此框体显示"
    SBFOptions.strings.COMMONFILTERS = "通用滤镜"
    SBFOptions.strings.USEDFILTERS = "使用中的滤镜"
    SBFOptions.strings.COMMONFILTERLIST =   {
    "光环",
    "持续时间少于15秒",
    "持续时间少于30秒",
    "持续时间少于60秒",
    "持续时间大于10分钟",
    "持续时间大于20分钟",
    "我可驱除的Buffs/debuffs",
    "我可施放的Buffs/debuffs",
    "我施放过的Buffs/debuffs",
    "图腾",
    "buff追踪",
    "魔法",
    "疾病",
    "中毒",
    "诅咒",
    "无类型",
  }

  -- Filters Help
  SBFOptions.strings.OPENHTML = SBFOptions.strings.OPENHTML or "<HTML><BODY><P>"
  SBFOptions.strings.CLOSEHTML = SBFOptions.strings.CLOSEHTML or "</P></BODY></HTML>"
  SBFOptions.strings.FILTERHELPHTML = SBFOptions.strings.FILTERHELPHTML or {
    {	"|cff00ff00过滤帮助|r<BR/>",
      "滤镜格式为 {|cffffcc00命令|r}{|cff00cc00操作符|r}{参数}<BR/>",
      "<BR/>",
      "它分为三部分:<BR/>",
      "|cffffcc00命令|r - 过滤调用的buff属性<BR/>",
      "|cff00cc00操作符|r - 过滤触发的比较条件<BR/>",
      "参数 - 过滤条件的比较值<BR/>",
      "<BR/>",
      "例如: |cff00d2ffD>20|r<BR/>",
      "<BR/>",
      "在这个例子中，这些部分分别是（细节显示在下一页）:<BR/>",
      "|cffffcc00D|r - 过滤监控buff的剩余时间<BR/>",
      "|cff00cc00>|r - 过滤使用大于比较<BR/>",
      "20 - 比较的阀值是20分钟<BR/>",
      "<BR/>",
      "所以, 过滤|cff00d2ffD>20|r 意思是 '任何持续时间大于20分钟的buff'.  如上, 符合过滤的buff如何操作将会取决于此框体是设定为黑名单还是白名单.<BR/>",
    },
    {	"|cff00ff00命令|r：<BR/>",
      "|cffffcc00n|r: 按名称过滤（不区分大小写）<BR/>",
      "|cffffcc00tt|r: 按提示文字过滤（不区分大小写）<BR/>",
      "|cffffcc00D|r: 按buff持续时间过滤（分钟）<BR/>",
      "|cffffcc00d|r: 按buff持续时间过滤（秒）<BR/>",
      "|cffffcc00r|r: 按buff剩余时间过滤（分钟）<BR/>",
      "|cffffcc00R|r: 按buff剩余时间过滤（秒）<BR/>",
      "|cffffcc00a|r: 光环效果（没有持续时间的buff，例如骑士光环、守护等）<BR/>",
      "|cffffcc00h|r: 过滤有害法术效果（debuff）<BR/>",
      "|cffffcc00e|r: 临时物品附魔（磨刀石，巫师油等）<BR/>",
      "|cffffcc00to|r: 你的图腾（对非萨满玩家无效）<BR/>",
      "|cffffcc00c|r: 过滤你的职业可施放的buff (不一定是自己施放)<BR/>",
      "|cffffcc00my|r: 过滤你可施放的buff<BR/>",
      "|cffffcc00s|r: 过滤你可偷取的buff<BR/>",
    "|cffffcc00v|r: Filter effects that are from your vehicle<BR/>", -- 3.1.13
    "|cffffcc00help|r: Filter effects that are on friendly units<BR/>", -- 3.1.13
    "|cffffcc00harm|r: Filter effects that are on enemy units<BR/>", -- 3.1.13
    "|cffffcc00player|r: Filter effects that are cast by players<BR/>", -- 3.1.13
    "|cffffcc00npc|r: Filter effects that are cast by NPCs<BR/>", -- 3.1.13
    "|cffffcc00party|r: Filter effects that are cast by people in your party or raid<BR/>", -- 3.1.13
      "<BR/>",
      "默认仅过滤buff，如果要过滤debuff就必须使用|cffffcc00h|r命令<BR/>",
      "<BR/>",
        "|cffffcc00hc|r 过滤诅咒<BR/>",
        "|cffffcc00hd|r 过滤疾病<BR/>",
        "|cffffcc00hm|r 过滤魔法<BR/>",
        "|cffffcc00hp|r 过滤中毒<BR/>",
        "|cffffcc00hu|r 过滤无类型的debuff<BR/>",
        "|cffffcc00ha|r 过滤你可以解除的debuff<BR/>",
    },
    {	"|cff00ff00操作符|r:<BR/>",
        "|cff00cc00=|r 完全匹配（对|cffffcc00n|r and |cffffcc00s|r有效）<BR/>",
        "|cff00cc00~|r 不完全匹配 （对 |cffffcc00ntt|r使用）<BR/>",
        "|cff00cc00&lt;|r 小于（对|cffffcc00dDrR|r使用）<BR/>",
        "|cff00cc00&lt;=|r 小于或等于（对|cffffcc00dDrR|r使用）<BR/>",
        "|cff00cc00&gt;|r 大于（对|cffffcc00dDrR|r使用）<BR/>",
        "|cff00cc00&gt;=|r 大于或等于（对|cffffcc00dDrR|r使用）<BR/>",
      "<BR/>",
      "否定运算符, |cff00ff00!|r, 可以和 |cffffcc00n|r, |cffffcc00tt|r, |cffffcc00hc/hd/hm/hp/hu/ha|r, 以及 |cffffcc00a|r 命令一起使用:<BR/>",
        "|cff00d2ffa!|r 意味着“不是光环类效果的buff”（有持续时间的buff）<BR/>",
        "|cff00d2ffn!~药剂|r 意味着“名称中不包含药剂的buff”<BR/>",
        "|cff00d2ffn!=奥术智慧|r 意味着“不是奥术智慧的buff”<BR/>",
        "|cff00d2fft!~智力|r 意味着“提示信息中不包含智力的buff”<BR/>",
        "|cff00d2ff!hc|r 意味着'非诅咒的buff'<BR/>",
      "<BR/>",
      "|cff00ff00参数|r:<BR/>",
      "字符串 - |cffffcc00n|r和|cffffcc00tt|r命令使用字符串来部分匹配（～）或完全匹配（=）名称或提示文字<BR/><BR/>",
      "数字 - |cffffcc00D|r、|cffffcc00d|r、|cffffcc00R|r和|cffffcc00r|r命令使用数字来比较buff的持续时间或剩余时间<BR/><BR/>",
      " |cffffcc00a|r, |cffffcc00e|r, |cffffcc00hc|r, |cffffcc00hd|r, |cffffcc00hm|r, |cffffcc00hp|r, |cffffcc00hu|r, |cffffcc00ha|r, |cffffcc00tr|r, |cffffcc00c|r, |cffffcc00my|r, 和 |cffffcc00to|r 命令不包含参数<BR/>",
    },
    {	"|cff00ff00多重过滤|r<BR/>",
      "你可以使用逻辑连接符与{&amp;}和非{||}来组成多重过滤，使用括号来强制分组。<BR/>",
        "|cff00d2ffn~合剂&amp;R&gt;60|r 在buff信息包含“合剂”和剩余时间大于60分钟时返回true<BR/>",
      "<BR/>",
      "|cff00ff00过滤示例|r:<BR/>",
      "|cff00d2ffn~药剂|r<BR/>",
      "过滤“法能药剂”、“掌控药剂”等<BR/><BR/>",
      "|cff00d2ffD&lt;=3|r<BR/>",
      "过滤所有的持续时间小于等于3分钟的buff<BR/><BR/>",
      "|cff00d2ffa|r<BR/>",
      "过滤所有的光环效果<BR/><BR/>",
      "|cff00d2ffe|r<BR/>",
      "过滤所有的临时物品增强效果<BR/><BR/>",
      "|cff00d2ffn=奥术智慧|r<BR/>",
      "过滤buff奥术智慧<BR/><BR/>",
      "|cff00d2ffn=活体炸弹&amp;my|r<BR/>",
      "过滤我施放在目标的活体炸弹效果<BR/><BR/>",
      "|cff00d2ffc|r<BR/>",
      "过滤我的职业施放在目标的效果",
    },
  }

    SBFOptions.strings.NAMEHELPHTML = {
      {	"|cff00ff00名称帮助|r<BR/>",
        "以下是名称的三种元素：<BR/>",
        "<BR/>",
        "|cffff0ccName|r - Buff的名称将如何显示<BR/>",
        "|cffffcc00Rank|r - Buff的等级将如何显示<BR/>",
        "|cff00cc00Count|r - Buff的叠加数将如何显示<BR/>",
        "<BR/>",
        "例如：|cffff00ccName[full]|r |cffffcc00Rank[Roman]|r |cff00cc00Count[(always)]|r<BR/>",
        "<BR/>",
        "在这个例子中，所有的元素都被显示了：<BR/>",
        "|cffff00ccName[full]|r - 显示完整buff名称（例如“奥术智慧”）<BR/>",
        "|cffffcc00Rank[Roman]|r - Buff等级用罗马数字显示<BR/>",
        "|cff00cc00Count[(XXX)]|r - Buff的叠加数将始终显示在英文括号内<BR/>",
        "<BR/>",
        "这个格式会使buff的名称如下显示|cff00d2ff奥术智慧VI (1)|r<BR/>",
        "<BR/>",
        "|cff00ff00元素格式化|r<BR/>",
        "单个元素的格式始终是|cff00d2ffElement[要显示的内容]|r<BR/>",
        "<BR/>",
        "每个元素类型都会有一些会被buff特定数据通配的关键词。你可以在元素标签里添加任何你想和关键词一起使用的文字，我保证它们会正确显示。<BR/>",
        "<BR/>",
        "例如：Count[(always)] vs. Count[always]<BR/>",
        "关键词always被通配后，Count[(always)]会显示为|cff00d2ff(6)|r<BR/>",
        "关键词always被通配后，Count[always]会显示为|cff00d2ff6|r<BR/>",
        "<BR/>",
        "关键词roman在“等级[Rank roman]”中被通配后，它将显示为|cff00d2ff等级IV|r<BR/>",
      },
      {	"|cff00ff00名称元素|r<BR/>",
        "对名称元素来说有3个关键词：<BR/>",
        "<BR/>",
        "|cffff00ccfull|r - Buff的全名（例如“野性印记”）<BR/>",
        "|cffff00ccshort|r - Buff名称的缩写（例如MotW，不过在中文客户端中似乎无效）<BR/>",
        "|cffff00ccxshort|r - 更短的名称（例如MW，不过在中文客户端中似乎同样无效）<BR/>",
      "|cffff00cctrunc:X|r - Buff的名称从第X个字母起截断。<BR/>",
      "|cffff00ccchop:X|r - 将buff的名称前X个字母切除<BR/>",
      "|cffff00ccof|r - 将buff名称中的“of”前的所有部分移除<BR/>",
      "(例如 Elixir of Draenic Wisdom -> Draenic Wisdom)<BR/>",
        "<BR/>",
        "<BR/>",
        "|cff00ff00等级元素|r<BR/>",
        "对等级元素来说有2个关键词：<BR/>",
        "<BR/>",
        "|cffffcc00arabic|r - Buff的等级用阿拉伯数字显示（例如6）<BR/>",
        "|cffffcc00roman|r - Buff的等级用罗马数字显示（例如VI）<BR/>",
        "<BR/>",
        "如果buff没有等级，等级元素将不显示<BR/>",
        "<BR/>",
        "<BR/>",
        "|cff00ff00叠加数元素|r<BR/>",
        "对叠加数元素来说有3个关键词：<BR/>",
        "<BR/>",
        "|cff00cc00normal|r - 叠加数仅在这个buff叠加了超过1层时显示<BR/>",
        "|cff00cc00stack|r - 叠加数仅在buff是一个可叠加buff时显示，即使这个buff只能叠加1层<BR/>",
        "|cff00cc00always|r - 叠加数始终显示，即使这个buff不可叠加<BR/>",
      },
      {	"|cff00ff00小贴士|r<BR/>",
        "|cffffcc00Rank[Rank roman]|r和'Rank |cffffcc00Rank[roman]|r'实际上区别很大，看这些名称格式：<BR/>",
        "|cffff00ccName[full]|r |cffffcc00Rank[Rank roman]|r和|cffff00ccName[full]|r Rank |cffffcc00Rank[roman]|r<BR/>",
        "<BR/>",
        "施放奥术智慧（等级6）后，它们会显示一样的内容：<BR/>",
        "|cff00d2ff奥术智慧Rank VI|r<BR/>",
        "<BR/>",
        "但是，如果获得了进食充分效果这个没有等级的buff，它们显示的结果会不太一样：<BR/>",
        "|cffff00ccName[full]|r |cffffcc00Rank[Rank roman]|r会显示|cff00d2ff进食充分|r<BR/>",
        "|cffff00ccName[full]|r Rank |cffffcc00Rank[roman]|r会显示|cff00d2ff进食充分Rank|r<BR/>",
        "<BR/>",
        "记得要始终把元素的条件文本写进标签内部！<BR/>",
      },
    }
    
    SBFOptions.strings.frameVisibility = {
      "始终",
      "从不",
      "战斗中",
      "战斗外",
      "鼠标移过",
    }

    SBFOptions.strings.timerFormats = {
      "暴雪默认样式",
      "分钟:秒",
      "秒",
      "仅显示大于60秒",
      "无计时器",
      "暴雪默认样式2",
      "OmniCC样式",
    }
    
    SBFOptions.strings.WARNTIMETT = {
      "消失警报启动时间",
      "在该buff剩余时间为此值时",
      "显示消失警报",
    }
      
    SBFOptions.strings.MINTIMETT = {
      "最小buff时间",
      "仅对持续时间长于该值",
      "仅对持续时间长于该值",
  }
end