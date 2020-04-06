if ( GetLocale() == "zhCN" ) then
  SBF.strings.DISABLE = "卸载SBF来禁用"
  SBF.strings.BUFFEXPIRE = "即将消失"
  SBF.strings.BUFFNOTICE = "已经消失"
  SBF.strings.NEWPLAYER = "Satrina Buff Frames 新玩家："
  SBF.strings.UPDATE = "更新到Satrina Buff Frames %.1f"
  SBF.strings.RESET = "此更新需要重置配置文件！"
  SBF.strings.EXCLUDE = "不显示该buff"
  SBF.strings.BUFFFRAME = "显示在buff框体"
  SBF.strings.NOFRAME = "清空框体"
  SBF.strings.ALWAYSWARN = "即将消失时始终警报"
  SBF.strings.CANCEL = "取消这个buff"
  SBF.strings.DESTROYTOTEM = "摧毁图腾"
  SBF.strings.CONFIGERROR = "加载SBF设置界面时错误：%s"
  SBF.strings.DRAGTAB = "SBF %d"
  SBF.strings.FRAMETITLE = "Buff框体%d"
  SBF.strings.ENCHANTS = "附魔"
  SBF.strings.DRAGTAB1 = "拖动来移动框体"
  SBF.strings.DRAGTAB2 = "Shift+click点击选择该框体"
  SBF.strings.SHOWATBUFFRAME = "Buff框体"
  SBF.strings.TEMPENCHANT = "临时附魔%d"
  SBF.strings.INVALIDBUFF = "试图为无效buff发出消失警报"
  SBF.strings.OPTIONS = "打开SBF设置"
  SBF.strings.HIDE = "强制隐藏系统buff框体"
  SBF.strings.SAFECALL = "为buff更新使用安全调用"
  SBF.strings.DEFAULT = "默认"
  SBF.strings.DEFAULTFRAME = "默认框体"

  SBF.strings.MAGIC = "魔法"
  SBF.strings.CURSE = "诅咒"
  SBF.strings.DISEASE = "疾病"
  SBF.strings.POISON = "中毒"
  SBF.strings.UNKNOWNBUFF = "未知buff"
  SBF.strings.BUFFERROR = "SBF错误：无法显示该buff的提示信息"
    
  SBF.strings.ERRBUFF_EXTENT = "获取框体%d后缀失败 - 框体不存在"
  SBF.strings.ERRBUFF_ENCHANTNAME = "无法在栏位%d找到临时物品附魔名称"
    
  SBF.strings.OLDOPTIONS = "SBF设置过期"
  SBF.strings.OPTIONSVERSION = "SBF设置版本|cff00ff66%s|r不兼容SBF版本|cff00ff66%s|r"
   
  SBF.strings.OF = SBF.strings.OF or "of"
  SBF.strings.OFTHE = SBF.strings.OFTHE or "of the"
  SBF.strings.NA = SBF.strings.NA or "N/A"
    
  SBF.strings.NOTRACKING = "无"
  SBF.strings.SPELL_COMBUSTION = "燃烧"
  SBF.strings.SPELL_FR_AURA = "火焰抗性光环"

  SBF.strings.SLASHTHROTTLE = "    |cff00ff66刷新频率|r - [|cff00aaff%.2f|r]设置事件刷新速度（0.00-1.00）"
  SBF.strings.INVALIDTHROTTLE = "事件刷新频率需介于0-1"
  SBF.strings.THROTTLECHANGED = "当前事件刷新频率设置为|cff00aaff%.2f|r"
  SBF.strings.SENTRYTOTEM = "岗哨图腾"  -- Keeps sentry totem from being destroyed when you click it

  SBF.strings.SLASHHEADER = "|cff00ff66Satrina Buff Frames|r版本|cff00aaff%s|r"
  SBF.strings.SLASHOPTIONS = {
    "    |cff00ff66options|r - 显示SBF设置",
    "    |cff00ff66hide|r - 强制隐藏默认buff框体",
  }

  SBF.strings.buffTotems = {
    "天怒图腾",
    "抗火图腾",
    "火舌图腾",
    "抗寒图腾",
    "地缚图腾",
    "自然抗性图腾",
    "岗哨图腾",
    "石肤图腾",
    "大地之力图腾",
    "空气之怒图腾",
    "风怒图腾",
    "风之优雅图腾", --?
    "风墙图腾", --?
    "风之宁静", --?
  }
    
  SBF.strings.sort = {
    "无",
    "时间升序",
    "时间降序",
    "名称升序",
    "名称降序",
  }
  SBF.strings.sounds =  {
  "Whoosh",
  "Clink",
  "Auction Bell",
  "Clunk",
  "Murloc!",
}
end

SBF.strings.castableExclude = SBF.strings.castableExclude or {
}