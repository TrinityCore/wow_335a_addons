-- Note for translators:
-- You should never have 
--   SBFOptions.strings.X = SBFOptions.strings.X or "y"
-- You should only have
--   SBFOptions.strings.X = "y"

if (GetLocale() == "koKR") then 
  -- General Tab
SBFOptions.strings.GENERALCONFIG = "기본설정"
SBFOptions.strings.FRAMEUNIT = "프레임 유닛"
SBFOptions.strings.FRAMENAME = "프레임 이름"
SBFOptions.strings.FRAMEBUFFS = "버프 보기"
SBFOptions.strings.FRAMEDEBUFFS ="디버프 보기"
SBFOptions.strings.WHITELIST = "화이트 리스트"
SBFOptions.strings.WHITELISTTT = "Whitelist 의미\"필터에서 선택한 것만 보여줍니다.\""
SBFOptions.strings.BLACKLIST = "블랙 리스트"
SBFOptions.strings.BLACKLISTTT = "Blacklist 의미 \"필터에서 선택한 것을 제외합니다.\""
SBFOptions.strings.CLICKTHROUGH = "Clickthrough"
SBFOptions.strings.CLICKTHROUGHTT = "A frame set to clickthrough will not accept any mouse input at all"

  -- Layout Tab
  SBFOptions.strings.BIG = "크게"
  SBFOptions.strings.LAYOUTCONFIG = "버프외형"
  SBFOptions.strings.BUFF_SCALE = "버프 크기"
  SBFOptions.strings.OPACITY = "투명도"
  SBFOptions.strings.BUFFHORIZONTAL = "가로로"
  SBFOptions.strings.BUFFFLIP = "뒤집기"
  SBFOptions.strings.REVERSEBUFF = "역순으로 정렬"
  SBFOptions.strings.XSPACING = "수평 간격"
  SBFOptions.strings.YSPACING = "수직 간격"
  SBFOptions.strings.ROWCOUNT = "행당 버프 갯수"
  SBFOptions.strings.COLCOUNT = "열당 버프 갯수"
  SBFOptions.strings.BUFFCOUNT = "버프 갯수"
  SBFOptions.strings.BUFFSORT = "정렬"
  SBFOptions.strings.BUFFRIGHTCLICK = "우클릭으로 이 프레임 비활성화"
  SBFOptions.strings.NOTOOLTIPS = "툴팁 없음"
  SBFOptions.strings.NOTOOLTIPSTT = "Do not show tooltips for buffs in this frame"
  SBFOptions.strings.MIRRORBUFFS = "프레임 1 & 2에도 중복해서 버프 표시"
  SBFOptions.strings.RIGHTCLICKTT = "Right click will not dismiss buffs"
  SBFOptions.strings.MIRRORTT1 = "Buffs will appear in buff frame 1 as well as in this frame"
  SBFOptions.strings.MIRRORTT2 = "Debuffs will appear in buff frame 2 as well as in this frame"
  SBFOptions.strings.VISIBILITY = "프레임 보이기"
  SBFOptions.strings.BUFFPOSITION = "버프간격"
  SBFOptions.strings.BUFFGROWTH = "버프성장"
  SBFOptions.strings.BUFFANCHOR = "버프앵커"
  SBFOptions.strings.TOP = "위"
  SBFOptions.strings.BOTTOM = "아래"

  -- Timer tab
SBFOptions.strings.SHOWTIMERS = "버프 시간 표시"
SBFOptions.strings.TIMERCONFIG = "버프시간"
SBFOptions.strings.TEXT_POSITIONY = "시간 수평위치"
SBFOptions.strings.TEXT_POSITIONX =  "시간 수직 위치"
SBFOptions.strings.TEXT_FORMAT = "시간 표시형태"
SBFOptions.strings.TIMERCOLOUR ="시간 색상"
SBFOptions.strings.EXPIRECOLOUR = "완료시간 색상"
SBFOptions.strings.TIMERPOSITION ="시간표시 위치"
SBFOptions.strings.TIMERNA = "N/A for auras"
SBFOptions.strings.TIMERMS = "1/10초 표시"
SBFOptions.strings.TIMERMSTT = "5초이하일 것일때 1/10초 표시"

-- Icon Tab
SBFOptions.strings.SHOWICONS = "버프아이콘 표시"
SBFOptions.strings.ICONCONFIG = "아이콘"
SBFOptions.strings.ICONPOSITION = "아이콘 위치"
SBFOptions.strings.ICONSIZE = "아이콘 크기"
SBFOptions.strings.COOLDOWN = "Cooldown sweep on icons"
SBFOptions.strings.REVERSECOOLDOWN = "Reverse cooldown sweep"
SBFOptions.strings.SUPPRESSOMNICCTIMER = "Suppress OmniCC timers on cooldown sweep"

-- Count Tab
SBFOptions.strings.SHOWCOUNTS = "버프 중첩 표시"
SBFOptions.strings.COUNTCONFIG = "버프중첩시간"
SBFOptions.strings.STACKCOLOUR = "중첩 글자 색상"
SBFOptions.strings.COUNTPOSITION = "중첩 위치"

-- Bar Tab
SBFOptions.strings.BARCONFIG = "아이콘/바 전환"
SBFOptions.strings.SHOWBARS = "버프바 표시"
SBFOptions.strings.BARDIRECTION = "바 방향"
SBFOptions.strings.BARWIDTH = "바 길이"
SBFOptions.strings.BARHEIGHT = "바 높이"
SBFOptions.strings.BARTEXTURE = "바 텍스처"
SBFOptions.strings.BARBUFFCOLOUR = "버프바 색상"
SBFOptions.strings.BARDEBUFFCOLOUR = "디버프바 색상"
SBFOptions.strings.BARBACKDROP = "바 배경 색상"
SBFOptions.strings.DEBUFFBARCOLOUR = "디버프 유형에 따른 색상"
SBFOptions.strings.DEBUFFBARCOLOURTT1 = "이름에 디버프 타입에 따른 색상 사용"
SBFOptions.strings.DEBUFFBARCOLOURTT2 = "(저주, 마법, 독, etc.)"
SBFOptions.strings.BARPOSITION = "바 위치"
SBFOptions.strings.BARNOSPARK =  "바에 스파크 표시안함"

-- Name Tab
SBFOptions.strings.SHOWNAMES = "버프 이름 표시"
SBFOptions.strings.NAMECONFIG = "버프이름"
SBFOptions.strings.NAMEBUFFCOLOUR ="버프 색상"
SBFOptions.strings.NAMEDEBUFFCOLOUR = "디버프 색상"
SBFOptions.strings.NAMECOUNT = "중첩 표시 형태"
SBFOptions.strings.NAMEFORMAT ="이름 표시 형태"
SBFOptions.strings.NAMERANK = "랭크 표시 형태"
SBFOptions.strings.DEBUFFNAMECOLOUR = "디버프 유형에 따른 색상"
SBFOptions.strings.DEBUFFNAMECOLOURTT1 = "이름에 디버프 타입에 따른 색상 사용"
SBFOptions.strings.DEBUFFNAMECOLOURTT2 = "(저주, 마법, 독, etc.)"
SBFOptions.strings.NAMEPOSITION = "이름 표시 위치"
-- v3.1.5
SBFOptions.strings.NAMEACTIVE =  "마우스 활성화"
SBFOptions.strings.NAMEACTIVETT = "Buff names will show tooltips, allow you to click to dismiss, etc." 

-- Expiry Tab
SBFOptions.strings.WARNCONFIG = "버프종료알림"
SBFOptions.strings.EXPIREWARN = "텍스트로 종료 경보"
SBFOptions.strings.EXPIREWARNTT = "Adds a notice in chat when a buff is close to expiring"
SBFOptions.strings.EXPIRENOTICE = "대화창에 종료 경보"
SBFOptions.strings.EXPIRENOTICETT ="Adds a notice in chat when a buff expires"
SBFOptions.strings.EXPIRESOUND = "소리로 종료 경보"
SBFOptions.strings.SOUNDCHOOSE = "종료 경보 효과음"
SBFOptions.strings.WARNSOUND = "경보 효과음"
SBFOptions.strings.MINTIME = "최소 간격"
SBFOptions.strings.EXPIRETIME = "경보 시간"
SBFOptions.strings.EXPIREFRAME = "대화창"
SBFOptions.strings.EXPIREFRAMETEST = "Expiry warnings for buff frame %d will appear here"
SBFOptions.strings.SCTCOLOUR = "색상"
SBFOptions.strings.FASTBAR = "빠른 바 종료"
SBFOptions.strings.SCTWARN = "%s에 종료 경보"
SBFOptions.strings.SCTCRIT = "치명타 형태로 표시"
SBFOptions.strings.SCTCRITTT1 =  "Will show expiry warnings in scrolling combat text as a critical hit, if available"
SBFOptions.strings.SCTCRITTTM1 = "You currently have SCT set up to show buffs fading as messages."
SBFOptions.strings.SCTCRITTTM2 = "This SCT setting does not permit the messages to be shown as crits"
SBFOptions.strings.FLASHBUFF = "종료시 버프 아이콘 깜빡임"
SBFOptions.strings.USERWARN = "선택한 버프만"
SBFOptions.strings.ALLWARN = "모든 버프"

-- Frame stick tab
SBFOptions.strings.FLOWCONFIG = "버프그룹정렬"
SBFOptions.strings.STICKTOFRAME = "기준 프레임"
SBFOptions.strings.FLOWCHILDFRAME = "하위 프레임"
SBFOptions.strings.FLOWEXPIRY = "Use child settings for expiry"

-- Spells Tab
SBFOptions.strings.BLACKLISTCHECK = "이 버프를 표시하지 않음"
SBFOptions.strings.WHITELISTCHECK = "이 버프 표시"
SBFOptions.strings.ALWAYSWARN = "만료시 항상 경보"
SBFOptions.strings.MINE = "내가 시전한"
SBFOptions.strings.CASTABLE = "Cast by anyone of my class"
SBFOptions.strings.DEFAULTFRAME = "기본 프레임"
SBFOptions.strings.SPELLFILTER = "주문검색"
SBFOptions.strings.AURA = "오라"
SBFOptions.strings.CLEARSPELLS = "데이타 삭제"
SBFOptions.strings.CLEARSPELLSTT1 = "Clear SBF's cache of buff data"
SBFOptions.strings.CLEARSPELLSTT2 = "Use this if you are having problems with filters or buff display"
SBFOptions.strings.CLEARSPELLSTT3 = "(will not affect your always warn/show in frame/do not show settings)"
SBFOptions.strings.SPELLCONFIG = "주문리스트"
SBFOptions.strings.LISTBUFFSTT = "Shows buffs in the list on this tab"
SBFOptions.strings.LISTDEBUFFSTT = "Shows debuffs in the list on this tab"

-- Global Tab
SBFOptions.strings.GLOBALCONFIG = "전체 설정"
SBFOptions.strings.HOME = "처음으로"
SBFOptions.strings.AURAMAXTIME = "오라는 최대 시간으로"
SBFOptions.strings.AURAMAXTIMETT1 = "When selected, auras (spells without duration)"
SBFOptions.strings.AURAMAXTIMETT2 = "will appear as the spells with the longest time remaining."
SBFOptions.strings.ENCHANTSFIRST = "아이템 강화 버프 우선"
SBFOptions.strings.DISABLEBF = "SBF에서 ButtonFacade 비활성화"
SBFOptions.strings.TOTEMNONBUFF = "버프로 표시되지 않는 토템 숨김"
SBFOptions.strings.TOTEMOUTOFRANGE = "거리 범위 밖의 토템 표시"
SBFOptions.strings.TOTEMTIMERS = "토템 타이머 숨김"
SBFOptions.strings.HIDEPARTY = "Use \"Hide Party Interface\" option flag"
SBFOptions.strings.HIDEPARTYTT1 = "Checking this makes buff frames for party members honour the"
SBFOptions.strings.HIDEPARTYTT2 = "\"Hide Party Interface in Raid\" option in the Interface/Party&Raid options"

-- Misc
SBFOptions.strings.VERSION2 = "Satrina Buff Frames |cff00ff00%s|r"
SBFOptions.strings.HINT3 = "http://evilempireguild.org/SBF"
SBFOptions.strings.HINT2 = "Alt+드래그로 이동"
SBFOptions.strings.HINT = SBFOptions.strings.HINT or "Have a question?  Need help? Try here first:"
SBFOptions.strings.FRAME = "프레임 %d"
SBFOptions.strings.USINGPROFILE = "프로파일 사용"
SBFOptions.strings.COPYPROFILE = "프로파일 복사"
SBFOptions.strings.DELETEPROFILE = "프로파일 삭제"
SBFOptions.strings.NEWPROFILE = "새 프로파일의 이름을 입력하십시오"
SBFOptions.strings.CONFIRMREMOVEPROFILE = "정말로 프로파일 %s를 삭제하시겠습니까?"
SBFOptions.strings.NEWPROFILEBUTTON = "새 프로파일"

SBFOptions.strings.BUFFFRAME = "버프 프레임"
SBFOptions.strings.BUFFFRAMENUM = "버프 프레임 %d"
SBFOptions.strings.CURRENTFRAME = "현재 프레임:"
SBFOptions.strings.NEWFRAME = "새 버프 프레임"
SBFOptions.strings.REMOVE = "삭제"
SBFOptions.strings.REMOVEFRAME = "프레임 삭제"
SBFOptions.strings.REMOVEFRAMETT = "이 버프 프레임 삭제"
SBFOptions.strings.DELETEERROR = "1,2 버프프레임과 인첸트 프레임은 삭제 하지 못합니다."
SBFOptions.strings.DEFAULT_TOOLTIP = "이 프레임의 레이아웃과 만료 셋팅을 기본값으로 초기화 합니다."
SBFOptions.strings.DEFAULTS = "기본"
SBFOptions.strings.DEBUFFTIMER = "디버프 유형에 따른 색상"
SBFOptions.strings.DEBUFFTIMERTT1 = "The timer will be coloured using the debuff type's colour"
SBFOptions.strings.DEBUFFTIMERTT2 = "(저주, 마법, 독, 기다.)"
SBFOptions.strings.NEWFRAMETT ="새 버프 프레임 생성"
SBFOptions.strings.NONE = "없음"
SBFOptions.strings.HELP = "도움말"
SBFOptions.strings.POSITIONBOTTOM = "(+ALT) 10씩 이동"
SBFOptions.strings.FRAMELEVEL = "프레임 레벨 %d"

SBFOptions.strings.FONT = "폰트"
SBFOptions.strings.FONTSIZE = "폰트 크기 (%d)"
SBFOptions.strings.OUTLINEFONT = "폰트 아웃라인"

SBFOptions.strings.RESET = "리셋 프레임"
SBFOptions.strings.RESETFRAMESTT = "SBF 기본 프레임으로 리셋"

SBFOptions.strings.SHOWINFRAMEDELETE = "Removing show in frame %d for %s"
SBFOptions.strings.SHOWFILTER = "Matching filter %d:%s"
SBFOptions.strings.FILTERBLOCKED = "Filter(s) overriden by show in buff frame %d"
SBFOptions.strings.SHOWBUFFS = "버프 리스트"
SBFOptions.strings.SHOWDEBUFFS = "디버프 리스트"
SBFOptions.strings.DURATION = "지속 시간"

SBFOptions.strings.JUSTIFY = "정렬"
SBFOptions.strings.JUSTIFYRIGHT = "오른쪽"
SBFOptions.strings.JUSTIFYLEFT = "왼쪽"

SBFOptions.strings.REFRESH = "바 갱신 속도"
SBFOptions.strings.COPYFROM = "..에서 복사"
SBFOptions.strings.TRACKING = "추적 표시"

-- Filters Tab
SBFOptions.strings.FILTERCONFIG = "필터"
SBFOptions.strings.FILTER = "새 필터"
SBFOptions.strings.ADDFILTER = "필터 추가"
SBFOptions.strings.EDITFILTER = "필터 편집"
SBFOptions.strings.FILTERHELP = "필터 도움말"
SBFOptions.strings.UP = "위로"
SBFOptions.strings.DOWN = "아래로"
SBFOptions.strings.EDIT = "편집"
SBFOptions.strings.FILTERBLACKLIST = "Filtered buffs are not being shown in this frame"
SBFOptions.strings.FILTERWHITELIST = "Filtered buffs are being shown in this frame"
SBFOptions.strings.COMMONFILTERS = "공통 필터"
SBFOptions.strings.USEDFILTERS = "Filters in use"
SBFOptions.strings.COMMONFILTERLIST ={
  "오라",
  "지속시간이 15초 보다 적은",
  "지속시간이 30초 보다 적은",
  "지속시간이 60초 보다 적은",
  "지속 시간이 10분 보다 긴",
  "지속 시간이 20분 보다 긴",
  "내가 해제 가능한 버프 디버프",
  "내가 시전 가능한 버프 디버프",
  "내가 시전한 버프 디버프",
  "토템",
  "추적",
  "마법 이펙트",
  "질병 이펙트",
  "독 이펙트",
  "저주 이펙트",
  "무속성 이펙트",
}

SBFOptions.strings.frameVisibility = SBFOptions.strings.frameVisibility or {
  "항상보임",
  "숨김",
  "전투중보임",
  "비전투중보임",
  "마우스오버시보임",
}
end
