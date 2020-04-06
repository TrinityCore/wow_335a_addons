if ( GetLocale() == "zhTW" ) then
  SBF.strings.DISABLE = "卸載SBF來禁用"
  SBF.strings.BUFFEXPIRE = "即將消失"
	SBF.strings.BUFFNOTICE = "已經消失"
	SBF.strings.VERSION = "Satrina Buff Frames |cff00ff00"
	SBF.strings.NEWPLAYER = "Satrina Buff Frames 新玩家："
	SBF.strings.UPDATE = "更新到Satrina Buff Frames %.1f"
	SBF.strings.RESET = "此更新需要重置配置文件！"
	SBF.strings.EXCLUDE = "不顯示該buff"
	SBF.strings.BUFFFRAME = "顯示在buff框體"
	SBF.strings.NOFRAME = "清空框體"
	SBF.strings.ALWAYSWARN = "即將消失時始終警報"
	SBF.strings.CANCEL = "取消這個buff"
	SBF.strings.DESTROYTOTEM = "摧毀圖騰"
	SBF.strings.CONFIGERROR = "加載SBF設置界面時錯誤：%s"
	SBF.strings.DRAGTAB = "SBF %d"
	SBF.strings.FRAMETITLE = "Buff框體%d"
	SBF.strings.ENCHANTS = "附魔"
	SBF.strings.DRAGTAB1 = "拖動來移動框體"
	SBF.strings.DRAGTAB2 = "Shift+click點擊選擇該框體"
	SBF.strings.SHOWATBUFFRAME = "Buff框體"
	SBF.strings.TEMPENCHANT = "臨時附魔%d"
	SBF.strings.INVALIDBUFF = "試圖為無效buff發出消失警報"
	SBF.strings.OPTIONS = "打開SBF設置"
  SBF.strings.HIDE = "強制隱藏系統buff框體"
  SBF.strings.SAFECALL = "為buff更新使用安全檢測"
	SBF.strings.DEFAULT = "預設"
	SBF.strings.DEFAULTFRAME = "預設框體"

	SBF.strings.MAGIC = "魔法"
	SBF.strings.CURSE = "詛咒"
	SBF.strings.DISEASE = "疾病"
	SBF.strings.POISON = "毒藥"
  SBF.strings.UNKNOWNBUFF = "未知buff"
  SBF.strings.BUFFERROR = "SBF錯誤：無法顯示該buff的提示訊息"
  
  SBF.strings.ERRBUFF_EXTENT = "獲取框體%d失敗 - 框體不存在"

  SBF.strings.OLDOPTIONS = "SBF設置過期"
  SBF.strings.OPTIONSVERSION = "SBF設置版本|cff00ff66%s|r不兼容SBF版本|cff00ff66%s|r"
  
  SBF.strings.NOTRACKING = "無"
  SBF.strings.SPELL_COMBUSTION = "燃燒"
  SBF.strings.SPELL_FR_AURA = "火焰抗性光環"
  
  SBF.strings.SLASHTHROTTLE = "    |cff00ff66刷新頻率|r - [|cff00aaff%.2f|r]設置事件刷新速度（0.00-1.00）"
  SBF.strings.INVALIDTHROTTLE = "事件刷新頻率需介於0-1"
  SBF.strings.THROTTLECHANGED = "當前事件刷新頻率設置為|cff00aaff%.2f|r"
  SBF.strings.SENTRYTOTEM = "崗哨圖騰"  -- Keeps sentry totem from being destroyed when you click it
  
  SBF.strings.SLASHHEADER = "|cff00ff66Satrina Buff Frames|r版本|cff00aaff%s|r"
  SBF.strings.SLASHOPTIONS = {
    "    |cff00ff66options|r - 顯示SBF設置",
    "    |cff00ff66hide|r - 強制隱藏默認buff框體",
  }

  SBF.strings.buffTotems = {
    "憤怒圖騰", 
    "抗火圖騰",
    "火舌圖騰",
    "抗寒圖騰",
    "地縛圖騰",
    "自然抗性圖騰",
    "崗哨圖騰",
    "石甲圖騰",
    "大地之力圖騰",
    "風懲圖騰",
    "風怒圖騰",
    "風之優雅圖騰", --?
    "風牆圖騰", --?
    "寧靜之風圖騰", --?
  }
  
	SBF.strings.sort = {
		"無",
		"時間升序",
		"時間降序",
		"名稱升序",
		"名稱降序",
	}
end