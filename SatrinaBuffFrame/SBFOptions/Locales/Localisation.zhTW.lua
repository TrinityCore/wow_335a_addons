-- Note for translators:
-- You should never have 
--   SBFOptions.strings.X = SBFOptions.strings.X or "y"
-- You should only have
--   SBFOptions.strings.X = "y"

if ( GetLocale() == "zhTW" ) then
  SBFOptions.strings.LAYOUTCONFIG = "樣式（%d）"
  SBFOptions.strings.BUFF_SCALE = "縮放"
  SBFOptions.strings.OPACITY = "透明度"
  SBFOptions.strings.BUFFHORIZONTAL = "多行顯示"
  SBFOptions.strings.REVERSEBUFF = "反向排列"
  SBFOptions.strings.XSPACING = "水準間距"
  SBFOptions.strings.YSPACING = "垂直間距"
  SBFOptions.strings.ROWCOUNT = "每行buff數量"
  SBFOptions.strings.COLCOUNT = "每列buff數量"
  SBFOptions.strings.BOTTOM = "從底部開始"
  SBFOptions.strings.BUFFCOUNT = "buff數量"
  SBFOptions.strings.BUFFSORT = "排序"
  SBFOptions.strings.BUFFRIGHTCLICK = "在這個框體內禁用右鍵點擊"
  SBFOptions.strings.NOTOOLTIPS = "不顯示滑鼠提示"
  SBFOptions.strings.NOTOOLTIPSTT = "不顯示該框體內的buff滑鼠提示"
  SBFOptions.strings.MIRRORBUFFS = "鏡像1號和2號框體內的buff"
  SBFOptions.strings.RIGHTCLICKTT = "右擊不會取消buff"
  SBFOptions.strings.MIRRORTT1 = "Buff會同時在1號和這個框體內顯示"
  SBFOptions.strings.MIRRORTT2 = "Debuff會同時在2號和這個框體內顯示"
  SBFOptions.strings.VISIBILITY = "框體可見度"
  SBFOptions.strings.BUFFPOSITION = "Buff間距"

  -- Timer tab
  SBFOptions.strings.SHOWTIMERS = "顯示buff計時"
  SBFOptions.strings.TIMERCONFIG = "計時（%d）"
  SBFOptions.strings.TEXT_POSITIONY = "時間垂直位置"
  SBFOptions.strings.TEXT_POSITIONX = "時間水準位置"
  SBFOptions.strings.TEXT_FORMAT = "時間格式"
  SBFOptions.strings.TIMERCOLOUR = "時間文本顏色"
  SBFOptions.strings.EXPIRECOLOUR = "即將結束的時間文本顏色"
  SBFOptions.strings.TIMERPOSITION = "時間位置"
  SBFOptions.strings.TIMERNA =  "將光環效果顯示為N/A"

  -- Icon Tab
  SBFOptions.strings.SHOWICONS = "顯示buff圖示"
  SBFOptions.strings.ICONCONFIG = "圖示（%d）"
  SBFOptions.strings.ICONPOSITION = "圖示位置"

  -- Count Tab
  SBFOptions.strings.SHOWCOUNTS = "顯示buff疊加數"
  SBFOptions.strings.COUNTCONFIG = "疊加數（%d）"
  SBFOptions.strings.STACKCOLOUR = "計數文本顏色"
  SBFOptions.strings.COUNTPOSITION = "計數文本位置"

  -- Bar Tab
  SBFOptions.strings.BARCONFIG = "計時條（%d）"
  SBFOptions.strings.SHOWBARS = "顯示buff計時條"
  SBFOptions.strings.BARDIRECTION = "計時條方向"
  SBFOptions.strings.BARWIDTH = "計時條寬度"
  SBFOptions.strings.BARTEXTURE = "計時條材質"
  SBFOptions.strings.BARBUFFCOLOUR = "Buff計時條顏色"
  SBFOptions.strings.BARDEBUFFCOLOUR = "Debuff計時條顏色"
  SBFOptions.strings.BARBACKDROP = "計時條背景顏色"
  SBFOptions.strings.DEBUFFBARCOLOUR = "按debuff類型著色名稱"
  SBFOptions.strings.DEBUFFBARCOLOURTT1 = "計時條會按照debuff的類型著色"
  SBFOptions.strings.DEBUFFBARCOLOURTT2 = "（詛咒、魔法、毒藥等等）"
  SBFOptions.strings.BARPOSITION = "計時條位置"

  -- Name Tab
  SBFOptions.strings.SHOWNAMES = "顯示buff名稱"
  SBFOptions.strings.NAMECONFIG = "名稱（%d）"
  SBFOptions.strings.NAMEBUFFCOLOUR = "Buff顏色"
  SBFOptions.strings.NAMEDEBUFFCOLOUR = "Debuff顏色"
  SBFOptions.strings.NAMECOUNT = "計數格式"
  SBFOptions.strings.NAMEFORMAT = "名稱格式"
  SBFOptions.strings.NAMERANK = "等級格式"
  SBFOptions.strings.DEBUFFNAMECOLOUR = "按debuff類型著色名稱"
  SBFOptions.strings.DEBUFFNAMECOLOURTT1 = "名稱會按照debuff類型著色"
  SBFOptions.strings.DEBUFFNAMECOLOURTT2 = "（詛咒、魔法、毒藥等等）"
  SBFOptions.strings.NAMEPOSITION = "名稱位置"

  -- Expiry Tab
  SBFOptions.strings.WARNCONFIG = "消隱（%d）"
  SBFOptions.strings.EXPIREWARN = "文本消隱提示"
  SBFOptions.strings.EXPIREWARNTT = "在某個buff即將消失時輸出聊天提示"
  SBFOptions.strings.EXPIRENOTICE = "文本消隱警示"
  SBFOptions.strings.EXPIRENOTICETT = "在某個buff即將消失時輸出聊天警示"
  SBFOptions.strings.EXPIRESOUND = "聲音提示"
  SBFOptions.strings.SOUNDCHOOSE = "聲音"
  SBFOptions.strings.WARNSOUND = "警報聲音"
  SBFOptions.strings.MINTIME = "最短時間"
  SBFOptions.strings.EXPIRETIME = "警報時間下限"
  SBFOptions.strings.EXPIREFRAME = "聊天框體"
  SBFOptions.strings.EXPIREFRAMETEST = "Buff框體%d的消隱警報會在這裡顯示"
  SBFOptions.strings.SCTCOLOUR = "顏色"
  SBFOptions.strings.FASTBAR = "快速顯示計時條消隱"
  SBFOptions.strings.SCTWARN = "在%s顯示消失警報資訊"
  SBFOptions.strings.SCTCRIT = "使用爆擊動畫顯示" 
  SBFOptions.strings.SCTCRITTT1 = "如果SCT啟用則使用SCT的爆擊動畫顯示消失警報"
  SBFOptions.strings.SCTCRITTTM1 = "你已經設置SCT為使用訊息方塊體漸隱顯示Buff。"
  SBFOptions.strings.SCTCRITTTM2 = "當前SCT設置不允許資訊顯示為爆擊"
  SBFOptions.strings.FLASHBUFF = "閃爍即將消失的Buff圖示"
  SBFOptions.strings.USERWARN = "僅為選擇的特定buff提示"
  SBFOptions.strings.ALLWARN = "所有buff"

  -- Frame stick tab
  SBFOptions.strings.STICKYCONFIG = "粘附"
  SBFOptions.strings.STICKTOFRAME = "父框體"
  SBFOptions.strings.STICKYCHILDFRAME = "添加子框體"

  -- Units Tab
  SBFOptions.strings.UNITSCONFIG = "單位"
  SBFOptions.strings.UNITBUFFS = "此框體顯示buff"
  SBFOptions.strings.UNITDEBUFFALL = "此框體顯示debuff"
  SBFOptions.strings.UNITDEBUFFCASTABLE = "可施放的debuff"
  SBFOptions.strings.UNITDEBUFFMINE = "我的debuff"
  SBFOptions.strings.UNITLABEL = "當前單位：|cffffffff%s|r"
  SBFOptions.strings.UNITFRAMETAKEN = "框體%d已經被%s使用"
SBFOptions.strings.UNITFRAMEOWNEDFILTER =  "框體%d已經被|cff00d2ff%s|r過濾分配給了玩家，請選擇另外一個"
SBFOptions.strings.UNITFRAMEOWNEDSHOW =  "框體%d已經被通過|cff00d2ff%s|r的框體顯示分配給玩家，請選擇另外一個"
SBFOptions.strings.UNITFRAMEOWNERCHANGE =  "將框體%d的所有權由%s轉移給%s"

  -- Spells Tab
  SBFOptions.strings.EXCLUDE = "不顯示的buff"
  SBFOptions.strings.ALWAYSWARN = "即將消失時始終警報"
  SBFOptions.strings.SHOWING = "顯示到"
  SBFOptions.strings.DEFAULTFRAME = "默認框體"
  SBFOptions.strings.SPELLFILTER = "搜索法術"
  SBFOptions.strings.AURA = "光環"
  SBFOptions.strings.CLEARSPELLS = "清除資料"
  SBFOptions.strings.CLEARSPELLSTT1 = "清除SBF的buff緩存資料"
  SBFOptions.strings.CLEARSPELLSTT2 = "如果你遇到了過濾或者buff顯示問題請這麼做一次"
  SBFOptions.strings.CLEARSPELLSTT3 = "（不會影響你的始終警報/框體分配/顯示過濾設定）"
  SBFOptions.strings.SPELLCONFIG = "法術"

  -- Global Tab
  SBFOptions.strings.GLOBALCONFIG = "全域設置"
  SBFOptions.strings.HOME = "主頁"
  SBFOptions.strings.AURAMAXTIME = "光環效果顯示為最大持續時間" 
  SBFOptions.strings.AURAMAXTIMETT1 = "選中後，光環類效果（無持續時間）"
  SBFOptions.strings.AURAMAXTIMETT2 = "會顯示為持續時間為最大值的法術。"
  SBFOptions.strings.ENCHANTSFIRST = "優先顯示物品附魔"
  SBFOptions.strings.DISABLEBF = "在SBF中禁用ButtonFacade"
  SBFOptions.strings.TOTEMNONBUFF = "不顯示非buff圖騰"
  SBFOptions.strings.TOTEMOUTOFRANGE = "超出距離也仍顯示buff圖騰"
  SBFOptions.strings.TOTEMTIMERS = "不顯示圖騰計時"

  -- Misc
  SBFOptions.strings.VERSION2 = "Satrina Buff Frames |cff00ff00%s|r"
  SBFOptions.strings.HINT = "http://evilempireguild.org/SBF"
  SBFOptions.strings.HINT2 = "Alt+移動我！"
  SBFOptions.strings.FRAME = "框體%d"
  SBFOptions.strings.USINGPROFILE = "正在使用的設定檔"
  SBFOptions.strings.COPYPROFILE = "複製設定檔"
  SBFOptions.strings.DELETEPROFILE = "刪除設定檔"
  SBFOptions.strings.NEWPROFILE = "輸入新設定檔名"
  SBFOptions.strings.CONFIRMREMOVEPROFILE = "確定要刪除設定檔%s？"
  SBFOptions.strings.NEWPROFILEBUTTON = "新建設定檔"

  SBFOptions.strings.BUFFFRAME = "Buff框體"
  SBFOptions.strings.BUFFFRAMENUM = "Buff框體%d"
  SBFOptions.strings.CURRENTFRAME = "當前框體："
  SBFOptions.strings.NEWFRAME = "新建框體"
  SBFOptions.strings.REMOVE = "刪除"
  SBFOptions.strings.REMOVEFRAME = "刪除框體"
  SBFOptions.strings.REMOVEFRAMETT = "刪除這個buff框體"
  SBFOptions.strings.DELETEERROR = "不能刪除1號、2號buff框體以及物品附魔框體"
  SBFOptions.strings.DEFAULT_TOOLTIP = "重置框體的樣式和消失設置"
  SBFOptions.strings.DEFAULTS = "預設值"
  SBFOptions.strings.DEBUFFTIMER = "按類型著色debuff時間"
  SBFOptions.strings.DEBUFFTIMERTT1 = "時間文本會按debuff類型著色"
  SBFOptions.strings.DEBUFFTIMERTT2 = "（詛咒、魔法、毒藥等等）"
  SBFOptions.strings.NEWFRAMETT = "創建新buff框體"
  SBFOptions.strings.NONE = "無"
  SBFOptions.strings.HELP = "幫助"
  SBFOptions.strings.POSITIONBOTTOM = "按住Alt以10為步進調整"
  SBFOptions.strings.FRAMELEVEL = "框體層級%d"

  SBFOptions.strings.FONT = "字體"
  SBFOptions.strings.FONTSIZE = "字體大小（%d）"
  SBFOptions.strings.OUTLINEFONT = "文字描邊"

  SBFOptions.strings.RESET = "重置框體"
  SBFOptions.strings.RESETFRAMESTT = "重置為SBF默認框體"

  SBFOptions.strings.FILTERDELET = "刪除過濾%s"
  SBFOptions.strings.FILTERREFORMAT = "將過濾%s應用到框體%d"
  SBFOptions.strings.SHOWINFRAMEDELETE = "不在框體%d內顯示%s"
  SBFOptions.strings.SHOWFILTER = "匹配過濾%d:%s"
  SBFOptions.strings.FILTERBLOCKED = "過濾被buff框體%d強制顯示所忽略"
  SBFOptions.strings.SHOWBUFFS = "顯示buff"
  SBFOptions.strings.SHOWDEBUFFS = "顯示debuff"
  SBFOptions.strings.DURATION = "持續時間"

  SBFOptions.strings.JUSTIFY = "對齊"
  SBFOptions.strings.JUSTIFYRIGHT = "右"
  SBFOptions.strings.JUSTIFYLEFT = "左"

  SBFOptions.strings.REFRESH = "Buff條更新頻率"
  SBFOptions.strings.COPYFROM = "從...複製"
  SBFOptions.strings.TRACKING = "顯示追蹤"

    -- Filters Tab
  SBFOptions.strings.FILTERCONFIG = "過濾"
  SBFOptions.strings.ENABLEFILTERS = "啟用過濾"
  SBFOptions.strings.ENABLEFILTERSTT = "啟用除了根據buff剩餘時間工作的過濾以外的其他全部過濾"
  SBFOptions.strings.ENABLERFILTERS = "啟用根據buff剩餘時間工作的過濾"
  SBFOptions.strings.ENABLERFILTERSTT = "啟用根據buff剩餘時間工作的過濾（R和r）"
  SBFOptions.strings.FILTER = "新建過濾"
  SBFOptions.strings.ADDFILTER = "添加過濾"
  SBFOptions.strings.EDITFILTER = "編輯過濾"
  SBFOptions.strings.FILTERHELP = "過濾幫助"
  SBFOptions.strings.UP = "上升"
  SBFOptions.strings.DOWN = "下降"
  SBFOptions.strings.EDIT = "編輯"
  SBFOptions.strings.COMMONFILTERLIST =  {
    "Auras",
    "Duration less than 15 seconds",
    "Duration less than 30 seconds",
    "Duration less than 60 seconds",
    "Duration longer than 10 minutes",
    "Duration longer than 20 minutes",
    "Buffs/debuffs I can dispel",
    "Buffs/debuffs I can cast",
    "Buffs/debuffs I did cast",
    "Totems",
    "Tracking buff",
    "Magic effects",
    "Disease effects",
    "Poison effects",
    "Curse effects",
    "Untyped effects",
  }
  
  frameVisibility = {
    "始終",
    "從不",
    "戰鬥中",
    "戰鬥外",
  }

  timerFormats = {
    "暴雪預設樣式",
    "分鐘:秒",
    "秒",
    "僅顯示大於60秒",
    "無計時器",
    "暴雪預設樣式2",
    "OmniCC樣式",
  }

  WARNTIMETT = {
    "消失警報啟動時間",
    "在該buff剩餘時間為此值時",
    "顯示消失警報",
  }

  MINTIMETT = {
    "最小buff時間",
    "僅對持續時間長於該值",
    "僅對持續時間長於該值",
  }

end
