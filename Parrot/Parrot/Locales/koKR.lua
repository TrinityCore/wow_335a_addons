local L = LibStub("AceLocale-3.0"):NewLocale("Parrot", "koKR")
if not L then return end
L["Control game options"] = "게임 옵션 조정"
L["Display realm in player names (in battlegrounds)"] = "전장에서 플레이어의 서버 이름을 표시합니다."
L["Floating Combat Text of awesomeness. Caw. It'll eat your crackers."] = "Floating Combat Text of awesomeness. Caw. It'll eat your crackers."
L["Game damage"] = "게임 공격력"
L["Game healing"] = "게임 치유량"
L["Game options"] = "게임 옵션"
L["General"] = "전체"
L["General settings"] = "전체 설정"
L["Inherit"] = "상속"
L["Load config"] = "설정 불러오기"
L["Load configuration options"] = "설정 옵션 불려오기"
L["Parrot"] = "Parrot"
L["Parrot Configuration"] = "Parrot 설정"
L["Show guardian events"] = "수호물 이벤트 표시"
L["Show realm name"] = "서버 이름 표시"
L["Whether events involving your guardian(s) (totems, ...) should be displayed"] = "당신의 수호물 (토템, ...)을 포함시킨 이벤트를 표시합니다."
L[ [=[Whether Parrot should control the default interface's options below.
These settings always override manual changes to the default interface options.]=] ] = "기본 인터페이스 옵션을 Parrot에서 조절할 수 있습니다. 이 설정은 기본 인터페이스 옵션을 변경합니다."
L["Whether to show damage over the enemy's heads."] = "적의 머리위에 공격력을 표시합니다."
L["Whether to show healing over the enemy's heads."] = "적의 머리위에 치유량을 표시합니다."


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_CombatEvents", "koKR")
L["Abbreviate"] = "약어"
L["Add a new filter."] = "새로운 필터 추가"
L["Add a new throttle."] = "새로운 속도를 추가합니다."
L["Always hide skill names even when present in the tag"] = "항상 기술 이름 태그를 숨깁니다."
L["Always hide unit names even when present in the tag"] = "항상 유닛 이름 태그를 숨깁니다."
L["Amount"] = "Amount"
L[" ([Amount] absorbed)"] = " ([Amount] 흡수됨)"
L[" ([Amount] blocked)"] = " ([Amount] 피해 방어)"
L[" ([Amount] overheal)"] = " ([Amount] 초과 치유)"
L[" ([Amount] overkill)"] = " ([Amount] 초과 피해)"
L[" ([Amount] resisted)"] = " ([Amount] 저항함)"
L[" ([Amount] vulnerable)"] = " ([Amount] 약점 보너스)"
L["Arcane"] = "비전"
L["Change event settings"] = "이벤트 설정을 변경합니다."
L["Classcolor names"] = "직업색상 이름"
L["Color"] = "색상"
L["Color by class"] = "직업 색상"
L["Color names in the texts with the color of the class"] = "직업 색상으로 문자 이름을 표시합니다."
L["Color of the text for the current event."] = "현재 이벤트에 대한 문자의 색상입니다."
L["Color unit names by class"] = "직업에 의한 유닛 이름 색상"
L["Critical hits/heals"] = "치명타/극대화"
L["Crushing blows"] = "강타당함"
L["Custom font"] = "사용자 글꼴"
L["Damage types"] = "피해 유형"
L["Disable CombatEvents when in a 10-man raid instance"] = "10-인 공격대 인스턴스에서 CombatEvents를 사용하지 않습니다."
L["Disable CombatEvents when in a 25-man raid instance"] = "25-인 공격대 인스턴스에서 CombatEvents를 사용하지 않습니다."
L["Disable in 10-man raids"] = "일반 공격대 비활성화" -- Needs review
L["Disable in 25-man raids"] = "영웅 공격대 비활성화" -- Needs review
L["Do not shorten spell names."] = "주문명을 줄이지 않습니다."
L["Do not show heal events when 100% of the amount is overheal"] = "생명력이 100%일때 초과 치유량 이벤트를 표시하지 않습니다."
L["Enabled"] = "사용"
L["Enable the current event."] = "현재 이벤트를 사용합니다."
L["Enable to show crits in the sticky style."] = "접착성 형태로 치명타를 표시합니다."
L["Event modifiers"] = "이벤트 수정"
L["Events"] = "이벤트"
L["Filter incoming spells"] = "들어오는 주문 필터"
L["Filter outgoing spells"] = "나가는 주문 필터"
L["Filters"] = "필터"
L["Filters that are applied to a single spell"] = "단 하나의 주문에 적용되어진 필터"
L["Filters to be checked for a minimum amount of damage/healing/etc before showing."] = "화면에 표시할 피해/치유/기타 등의 최소값을 설정할 수 있습니다."
L["Filter when amount is lower than this value (leave blank to filter everything)"] = "Filter when amount is lower than this value (leave blank to filter everything)"
L["Fire"] = "화염"
L["Font face"] = "글꼴체"
L["Font outline"] = "글꼴 외각선"
L["Font size"] = "글꼴 크기"
L["Frost"] = "냉기"
L["Frostfire"] = "냉기불꽃"
L["Froststorm"] = "냉기폭풍"
L["Gift of the Wild => Gift of t..."] = "야생의 선물 => 야생의 ..."
L["Gift of the Wild => GotW."] = "야생의 선물 => 야선"
L["Glancing hits"] = "빗맞음 타격"
L["Hide events used in triggers"] = "트리거에 사용된 이벤트 숨김"
L["Hide full overheals"] = "초과 치유 숨김"
L["Hide realm"] = "서버명 숨김"
L["Hide realm in player names (in battlegrounds)"] = "플레이어의 서버(전장에서)를 숨깁니다."
L["Hides combat events when they were used in triggers"] = "트리거 사용시 전투 이벤트 숨김"
L["Hide skill names"] = "기술 이름 숨김"
L["Hide unit names"] = "유닛 이름 숨김"
L["Holy"] = "신성"
L["How or whether to shorten spell names."] = "주문 이름을 짧게 표시합니다."
L["Incoming"] = "받는 메시지"
L["Incoming events are events which a mob or another player does to you."] = "받는 이벤트는 몹 혹은 다른 플레이어가 당신에게 행하는 이벤트입니다."
L["Inherit"] = "상속"
L["Inherit font size"] = "상속 글꼴 크기"
L["Interval for collecting data"] = "수집 데이터 간격"
L["Length"] = "길이"
L["Name or ID of the spell"] = "주문의 이름이나 ID"
L["Nature"] = "자연"
L["New filter"] = "새로운 필터"
L["New throttle"] = "새로운 속도"
L["None"] = "없음"
L["Notification"] = "알림 메시지"
L["Notification events are available to notify you of certain actions."] = "알림 이벤트는 당신의 특정 행동 알림에 이용할 수 있습니다."
L["Options for damage types."] = "피해 유형에 대한 설정입니다."
L["Options for event modifiers."] = "이벤트 수정에 대한 설정입니다."
L["Outgoing"] = "보내는 메시지"
L["Outgoing events are events which you do to a mob or another player."] = "보내는 이벤트는 당신이 몹 혹은 다른 플레이어에게 행하는 이벤트입니다."
L["Overheals"] = "초과 치유"
L["Overkills"] = "초과 피해"
L["Partial absorbs"] = "부분적인 흡수"
L["Partial blocks"] = "부분적인 방어"
L["Partial resists"] = "부분적인 저항"
L["Physical"] = "물리"
L["Remove"] = "제거"
L["Remove filter"] = "필터 제거"
L["Remove throttle"] = "속도 제거"
L["Scoll area where all events will be shown"] = "스크롤 영역에 모든 이벤트를 표시합니다."
L["Scroll area"] = "스크롤 영역"
L["Shadow"] = "암흑"
L["Shadowstorm"] = "암흑폭풍"
L["Shorten spell names"] = "주문 이름 줄임"
L["Short Texts"] = "문자 줄임"
L["Show guardian events"] = "수호물 이벤트 표시"
L["Sound"] = "소리"
L["Spell"] = "주문"
L["Spell filters"] = "주문 필터"
L["Spell throttles"] = "주문 속도"
L["Sticky"] = "접착성"
L["Sticky crits"] = "접착성 치명타"
L["Style"] = "스타일"
L["Tag"] = "태그"
L["<Tag>"] = "<태그>"
L["Tag to show for the current event."] = "현재 이벤트 표시를 위한 태그입니다."
L["Text"] = "문자"
L["<Text>"] = "<문자>"
L["[Text] (crit)"] = "[Text] (치명타)"
L["[Text] (crushing)"] = "[Text] (강타당함)"
L["[Text] (glancing)"] = "[Text] (빗맞음)"
L["Text options"] = "문자 옵션"
L["The amount of damage absorbed."] = "흡수된 피해량 입니다."
L["The amount of damage blocked."] = "방어한 피해량 입니다."
L["The amount of damage resisted."] = "저항한 피해량 입니다."
L["The amount of overhealing."] = "초과 치유량 입니다."
L["The amount of overkill."] = "초과 피해량 입니다."
L["The amount of vulnerability bonus."] = "약점 보너스 피해량 입니다."
L["The length at which to shorten spell names."] = "문자 길이가 몇글자 이상일때 주문명을 줄일지 정합니다."
L["The normal text."] = "일반 글자입니다."
L["Thick"] = "두껍게"
L["Thin"] = "얇게"
L["Throttle events"] = "이벤트 조절"
L["Throttles that are applied to a single spell"] = "단 하나의 주문에 적용되어진 속도"
L["Throttle time"] = "속도 시간"
L["Truncate"] = "생략"
L["Uncategorized"] = "분류"
L["Use short throttle-texts (like \"2++\" instead of \"2 crits\")"] = "짧은 문자를 사용합니다. (\"2 치명타\" 대신 \"2++\")"
L["Vulnerability bonuses"] = "약점 보너스"
L[ [=[What amount to filter out. Any amount below this will be filtered.
Note: a value of 0 will mean no filtering takes place.]=] ] = "필터링할 최소 값을 정합니다. 얼마든지 정해진 이하의 값을 가진 데이터는 출력하지 않습니다.\\n'0'값은 필터링을 하지 않습니다."
L["What color this damage type takes on."] = "받은 해당 피해 유형의 색상을 선택합니다."
L["What color this event modifier takes on."] = "받은 해당 이벤트 수정자의 색상을 선택합니다."
L["What sound to play when the current event occurs."] = "현재 이벤트 발생시 재생할 소리를 선택하세요."
L["What text this event modifier shows."] = "해당 이벤트 수정자 표시 문자를 선택합니다."
L[ [=[What timespan to merge events within.
Note: a time of 0s means no throttling will occur.]=] ] = "지정한 시간안에 발생하는 트리거를 합쳐서 표현 할지 정합니다.\\n팁: 값을 '0'으로 할 경우 트리거 합치기는 작동하지 않습니다."
L["Whether all events in this category are enabled."] = "이 카테고리의 모든 이벤트를 표시할지 선택합니다."
L["Whether events involving your guardian(s) (totems, ...) should be displayed"] = "당신의 수호물(토템,...) 이벤트를 표시할지 선택합니다"
L["Whether the current event should be classified as \"Sticky\""] = "현재 이벤트를 \"접착성\"으로 표시할지 선택합니다."
L["Whether this module is enabled"] = "이 모듈을 표시할지 선택합니다."
L["Whether to color damage types or not."] = "피해 유형에 따른 색상 사용을 선택합니다."
L["Whether to color event modifiers or not."] = "이벤트 수정자에 따른 색상 사용을 선택합니다."
L["Whether to enable showing this event modifier."] = "해당 이벤트 수정 표시 사용을 선택합니다."
L["Whether to merge mass events into single instances instead of excessive spam."] = "많은 이벤트로 인한 지나친 메시지 대신 단 하나의 메시지를 표시합니다."
L["Which scroll area to use."] = "사용할 스크롤 영역을 선택합니다."


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Display", "koKR")
L["Enable icons"] = "아이콘 사용"
L["How opaque/transparent icons should be."] = "아이콘들의 투명도를 조절합니다."
L["How opaque/transparent the text should be."] = "문자들의 투명도를 조절합니다."
L["Icon transparency"] = "아이콘 투명도"
L["Master font settings"] = "기본 글꼴 설정"
L["None"] = "없음"
L["Normal font"] = "일반 글꼴"
L["Normal font face."] = "일반 글꼴체 입니다."
L["Normal font size"] = "일반 글꼴 크기"
L["Normal outline"] = "일반 외곽선"
L["Set whether icons should be enabled or disabled altogether."] = "아이콘 기능을 사용할지 여부를 선택하세요."
L["Sticky font"] = "접착성 글꼴"
L["Sticky font face."] = "접착성 글꼴체입니다."
L["Sticky font size"] = "접착성 글꼴 크기"
L["Sticky outline"] = "접착성 외곽선"
L["Text transparency"] = "문자 투명도"
L["Thick"] = "두껍게"
L["Thin"] = "얇게"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_ScrollAreas", "koKR")
L["Add a new scroll area."] = "새로운 스크롤 영역을 추가합니다."
L["Animation style"] = "애니메이션 스타일"
L["Animation style for normal texts."] = "일반 문자에 대한 애니메이션 형태입니다."
L["Animation style for sticky texts."] = "접착성 문자에 대한 애니메이션 형태입니다."
L["Are you sure?"] = "정말로 하시겠습니까?"
L["Center of screen"] = "화면의 중앙"
L["Click and drag to the position you want."] = "원하는 위치로 이동하려면 클릭 후 드래그 하세요."
L["Configuration mode"] = "환경설정 모드"
L["Create"] = "생성"
L["Custom font"] = "사용자 글꼴"
L["Direction"] = "방향"
L["Direction for normal texts."] = "일반 문자의 방향을 설정합니다."
L["Direction for sticky texts."] = "접착성 텍스트의 방향을 설정합니다."
L["Disable"] = "사용 안함"
L["Edge of screen"] = "화면의 가장자리"
L["Enter configuration mode, allowing you to move around the scroll areas and see them in action."] = "스크롤 영역을 이동할 수 있는 환경 설정 모드로 변경합니다."
L["How fast the text scrolls by."] = "문자 스크롤의 속도를 설정합니다."
L["How large of an area to scroll."] = "스크롤 할 영역의 크기를 설정합니다."
L["Icon side"] = "아이콘 표시"
L["Incoming"] = "받는 메시지"
L["Inherit"] = "상속"
L["Left"] = "좌측"
L["Name"] = "이름"
L["<Name>"] = "<이름>"
L["Name of the scroll area."] = "스크롤 영역의 이름입니다."
L["New scroll area"] = "새 스크롤 영역"
L["None"] = "없음"
L["Normal"] = "일반"
L["Normal font face"] = "일반 글꼴체"
L["Normal font outline"] = "일반 글꼴 외곽선"
L["Normal font size"] = "일반 글꼴 크기"
L["Normal inherit font size"] = "일반 상속 글꼴 크기"
L["Notification"] = "알림 메시지"
L["Options for this scroll area."] = "해당 스크롤 영역에 대한 설정입니다."
L["Options regarding scroll areas."] = "스크롤 영역에 관한 설정입니다."
L["Outgoing"] = "보내는 메시지"
L["Position: %d, %d"] = "위치: %d, %d"
L["Position: horizontal"] = "위치: 수평"
L["Position: vertical"] = "위치: 수직"
L["Remove"] = "제거"
L["Remove this scroll area."] = "해당 스크롤 영역을 제거합니다."
L["Right"] = "우측"
L["Scroll areas"] = "스크롤 영역"
L["Scroll area: %s"] = "스크롤 영역: %s"
L["Scrolling speed"] = "스크롤 속도"
L["Seconds for the text to complete the whole cycle, i.e. larger numbers means slower."] = "문자가 1주기를 완료하는데 걸리는 시간(초)입니다. 큰 숫자일수록 느려집니다."
L["Send"] = "보냄"
L["Send a normal test message."] = "일반 테스트 메세지를 보냅니다."
L["Send a sticky test message."] = "접착성 테스트 메세지를 보냅니다."
L["Send a test message through this scroll area."] = "해당 스크롤 영역을 통해 테스트 메세지를 보냅니다."
L["Set the icon side for this scroll area or whether to disable icons entirely."] = "이 스크롤 영역에 아이콘을 표시할지 선택합니다."
L["Size"] = "크기"
L["Sticky"] = "접착성"
L["Sticky font face"] = "접착성 글꼴체"
L["Sticky font outline"] = "접착성 글꼴 외곽선"
L["Sticky font size"] = "접착성 글꼴 크기"
L["Sticky inherit font size"] = "접착성 상속 글꼴 크기"
L["Test"] = "테스트"
L["The position of the box across the screen"] = "박스가 화면에서 위치할 수평값을 정하세요."
L["The position of the box up-and-down the screen"] = "박스가 화면에서 위치할 수직값을 정하세요."
L["Thick"] = "두껍게"
L["Thin"] = "얇게"
L["Which animation style to use."] = "사용할 애니메이션 스타일을 선택합니다."
L["Which direction the animations should follow."] = "문자의 스크롤 방향을 설정합니다."


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Suppressions", "koKR")
L["Add a new suppression."] = "새로운 차단을 추가합니다."
L["<Any text> or <Lua search expression>"] = "<문자열> 혹은 <Lua 검색 표현식>"
L["Are you sure?"] = "정말로 하시겠습니까?"
L["Create"] = "생성"
L["Edit"] = "편집"
L["Edit search string"] = "검색 문자열을 편집합니다."
L["List of strings that will be squelched if found."] = "차단할 문자열을 목록에 등록합니다."
L["Lua search expression"] = "Lua 검색 표현식"
L["New suppression"] = "새로운 차단"
L["Remove"] = "제거"
L["Remove suppression"] = "차단 제거"
L["Suppressions"] = "차단"
L["Whether the search string is a lua search expression or not."] = "검색 문자열이 LUA 표현식인지 확인합니다."


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Triggers", "koKR")
L["Add a new primary condition"] = "새로운 1차 조건을 추가합니다."
L["Add a new secondary condition"] = "새로운 2차 조건을 추가합니다."
L["Are you sure?"] = "정말로 하시겠습니까?"
L["Check every XX seconds"] = "매 XX 초마다 체크"
L["Classes"] = "직업"
L["Classes affected by this trigger."] = "해당 트리거를 적용할 직업입니다."
L["Cleanup Triggers"] = "트리거 정리"
L["Color"] = "색상"
L["Color in which to flash"] = "깜박임 색상"
L["Color of the text for this trigger."] = "해당 트리거에 대한 문자의 색상입니다."
L["Create"] = "생성"
L["Create a new trigger"] = "새로운 트리거를 생성합니다."
L["Custom font"] = "사용자 글꼴"
L["Delete all Triggers that belong to a different locale"] = "다른 위치에 속한 모든 트리거를 삭제합니다."
L["Enabled"] = "사용"
L["Flash screen in specified color"] = "명시된 색상의 깜박임 화면"
L["Font face"] = "글꼴체"
L["Font outline"] = "글꼴 외각선"
L["Font size"] = "글꼴 크기"
L["Free %s!"] = "자유 %s!"
L["Icon"] = "아이콘"
L["Inherit"] = "상속"
L["Inherit font size"] = "상속 글꼴 크기"
L["Low Health!"] = "생명력 낮음!"
L["Low Mana!"] = "마나 낮음!"
L["Low Pet Health!"] = "소환수 생명력 낮음!"
L["New condition"] = "새로운 조건"
L["New trigger"] = "새로운 트리거"
L["None"] = "없음"
L["Output"] = "출력"
L["Primary conditions"] = "1차 조건"
L["Remove"] = "제거"
L["Remove a primary condition"] = "1차 조건을 제거합니다."
L["Remove a secondary condition"] = "2차 조건을 제거합니다."
L["Remove condition"] = "조건 제거"
L["Remove this trigger completely."] = "해당 트리거를 완전히 제거합니다."
L["Remove trigger"] = "트리거 제거"
L["%s!"] = "%s!"
L["Scroll area"] = "스크롤 영역"
L["Secondary conditions"] = "2차 조건"
L["Sound"] = "소리"
L["<Spell name> or <Item name> or <Path> or <SpellId>"] = "<주문명> 또는 <아이템 이름> 또는 <경로> 또는 <SpellId>"
L["Sticky"] = "접착성"
L["Test"] = "테스트"
L["Test how the trigger will look and act."] = "현재 트리거 작동시 보여지는 것을 미리 확인 하세요."
L["<Text to show>"] = "<표시할 문자>"
L["The icon that is shown"] = "표시할 아이콘"
L["The text that is shown"] = "표시할 문자"
L["Thick"] = "두껍게"
L["Thin"] = "얇게"
L["Trigger cooldown"] = "재사용 대기시간 트리거"
L["Triggers"] = "트리거"
L["What sound to play when the trigger is shown."] = "트리거 작동시 출력할 소리를 정합니다."
L["When all of these conditions apply, the trigger will be shown."] = "트리거가 작동할 두번째 조건을 선택하세요."
L["When any of these conditions apply, the secondary conditions are checked."] = "트리거가 작동할 첫번째 조건을 선택하세요."
L["Whether the trigger is enabled or not."] = "트리거를 사용하거나 사용하지 않습니다."
L["Whether to show this trigger as a sticky."] = "해당 트리거를 접착성으로 표시합니다."
L["Which scroll area to output to."] = "출력할 스크롤 영역을 선택합니다."


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_TriggerConditions", "koKR")


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_AnimationStyles", "koKR")
L["Action"] = "액션"
L["Action Sticky"] = "액션 접착성"
L["Alternating"] = "교차"
L["Angled"] = "모서리"
L["Down, alternating"] = "아래로, 교차"
L["Down, center-aligned"] = "아래로, 가운데 정렬"
L["Down, clockwise"] = "아래로, 시계 방향"
L["Down, counter-clockwise"] = "아래로, 반시계 방향"
L["Down, left"] = "아래로, 좌측"
L["Down, left-aligned"] = "아래로, 좌측 정렬"
L["Down, right"] = "아래로, 우측"
L["Down, right-aligned"] = "아래로, 우측 정렬"
L["Horizontal"] = "수평"
L["Left"] = "좌측"
L["Left, clockwise"] = "좌측, 시계 방향"
L["Left, counter-clockwise"] = "좌측, 반시계 방향"
L["Parabola"] = "곡선"
L["Pow"] = "지진"
L["Rainbow"] = "무지개"
L["Right"] = "우측"
L["Right, clockwise"] = "우측, 시계 방향"
L["Right, counter-clockwise"] = "우측, 반시계 방향"
L["Semicircle"] = "반원"
L["Sprinkler"] = "스프링클러"
L["Static"] = "고정"
L["Straight"] = "직선"
L["Up, alternating"] = "위로, 교차"
L["Up, center-aligned"] = "위로, 가운데 정렬"
L["Up, clockwise"] = "위로, 시계 방향"
L["Up, counter-clockwise"] = "위로, 반시계 방향"
L["Up, left"] = "위로, 좌측"
L["Up, left-aligned"] = "위로, 좌측 정렬"
L["Up, right"] = "위로, 우측"
L["Up, right-aligned"] = "위로, 우측 정렬"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Auras", "koKR")
L["Amount"] = "양"
L["Amount of stacks of the aura"] = "오라 중첩수"
L["Any"] = "아무것도"
L["Aura active"] = "오라 활성화"
L["Aura fade"] = "오라 사라짐"
L["Aura gain"] = "오라 획득"
L["Aura inactive"] = "오라 비활성화"
L["Auras"] = "지속효과"
L["Aura stack gain"] = "오라 중첩 획득"
L["Aura type"] = "오라 종류"
L["Both"] = "둘다"
L["Buff"] = "강화 효과"
L["Buff active"] = "강화 효과 활성화"
L["Buff fades"] = "강화 효과 사라짐"
L["Buff gains"] = "강화 효과 획득"
L["Buff inactive"] = "강화 효과 비활성화"
L["<Buff name>"] = "<강화 효과 이름>"
L["Buff name"] = "강화 효과 이름"
L["<Buff name or spell id>"] = "<강화 효과 이름이나 주문 ID>"
L["Buff name or spell id"] = "강화 효과 이름이나 주문 ID"
L["<Buff name or spell id>,<Number of stacks>"] = "<강화 효과 이름이나 주문 ID>,<중첩수>"
L["Buff stack gains"] = "강화 효과 중첩 획득"
L["Debuff"] = "약화 효과"
L["Debuff active"] = "약화 효과 활성화" -- Needs review
L["Debuff fades"] = "약화 효과 사라짐"
L["Debuff gains"] = "약화 효과 획득"
L["Debuff inactive"] = "약화 효과 비활성화" -- Needs review
L["<Debuff name>"] = "<약화 효과 이름>"
L["<Debuff name or spell id>"] = "<약화 효과 이름이나 주문 ID>"
L["Debuff stack gains"] = "약화 효과 중첩 획득"
L["Enemy buff fades"] = "적대적 대상 강화 효과 사라짐"
L["Enemy buff gains"] = "적대적 대상 강화 효과 획득"
L["Enemy debuff fades"] = "적대적 대상 약화 효과 사라짐"
L["Enemy debuff gains"] = "적대적 대상 약화 효과 획득"
L["Focus buff fade"] = "주시 대상 강화 효과 사라짐"
L["Focus buff gain"] = "주시 대상 강화 효과 획득"
L["Focus debuff fade"] = "주시 대상 약화 효과 사라짐"
L["Focus debuff gain"] = "주시 대상 약화 효과 획득"
L["Item buff active"] = "아이템 강화 효과 활성화"
L["Item buff fade"] = "아이템 강화 효과 사라짐"
L["Item buff fades"] = "아이템 강화 효과 사라짐"
L["Item buff gain"] = "아이템 강화 효과 획득"
L["Item buff gains"] = "아이템 강화 효과 획득"
L["<Item buff name>"] = "<아이템 강화 효과 이름>"
L["Main hand"] = "주장비"
L["New Amount of stacks of the buff."] = "새로운 강화 효과 중첩입니다."
L["New Amount of stacks of the debuff."] = "새로운 약화 효과 중첩입니다."
L["Off hand"] = "보조장비"
L["Only return true, if the Aura has been applied by yourself"] = "만약 오라가 자신에 의해 적용 된다면 다시 되돌립니다." -- Needs review
L["Own aura"] = "자신의 오라" -- Needs review
L["Pet buff fades"] = "소환수 강화 효과 사라짐"
L["Pet buff gains"] = "소환수 강화 효과 획득"
L["Pet debuff fades"] = "소환수 약화 효과 사라짐"
L["Pet debuff gains"] = "소환수 약화 효과 획득"
L["Self buff fade"] = "자신 강화 효과 사라짐"
L["Self buff gain"] = "자신 강화 효과 획득"
L["Self buff stacks gain"] = "자신 강화 효과 중첩 획득"
L["Self debuff fade"] = "자신 약화 효과 사라짐"
L["Self debuff gain"] = "자신 약화 효과 획득"
L["Self item buff fade"] = "자신 아이템 강화 효과 사라짐"
L["Self item buff gain"] = "자신 아이템 강화 효과 획득"
L["Spell"] = "주문"
L["Stack count"] = "중첩 갯수"
L["Target buff fade"] = "대상 강화 효과 사라짐"
L["Target buff gain"] = "대상 강화 효과 획득"
L["Target buff gains"] = "대상 강화 효과 획득"
L["Target buff stack gains"] = "대상 강화 효과 중첩 획득"
L["Target debuff fade"] = "대상 약화 효과 사라짐"
L["Target debuff gain"] = "대상 약화 효과 획득"
L["The enemy that gained the buff"] = "강화 효과를 획득한 적대적 대상입니다."
L["The enemy that gained the debuff"] = "약화 효과를 획득한 적대적 대상입니다."
L["The enemy that lost the buff"] = "강화 효과가 사라진 적대적 대상입니다."
L["The enemy that lost the debuff"] = "약화 효과가 사라진 적대적 대상입니다."
L["The name of the buff gained."] = "획득한 강화 효과 이름입니다."
L["The name of the buff lost."] = "사라진 강화 효과 이름입니다."
L["The name of the debuff gained."] = "획득한 약화 효과 이름입니다."
L["The name of the debuff lost."] = "사라진 약화 효과 이름입니다."
L["The name of the item buff gained."] = "획득한 아이템 강화 효과 이름입니다."
L["The name of the item buff lost."] = "사라진 아이템 강화 효과 이름입니다."
L["The name of the item, the buff has been applied to."] = "아이템, 강화 효과 획득 이름입니다."
L["The name of the item, the buff has faded from."] = "아이템, 강화 효과 사라짐 이름입니다."
L["The name of the pet that gained the buff"] = "강화 효과를 획득한 소환수의 이름입니다."
L["The name of the pet that gained the debuff"] = "약화 효과를 획득한 소환수의 이름입니다."
L["The name of the pet that lost the buff"] = "강화 효과를 잃은 소환수의 이름입니다."
L["The name of the pet that lost the debuff"] = "약화 효과를 잃은 소환수의 이름입니다."
L["The name of the unit that gained the buff."] = "강화 효과를 획득한 유닛의 이름입니다."
L["The number of stacks of the buff"] = "버프의 중첩 수"
L["The unit that is affected"] = "영향을 받는 유닛"
L["Type of the aura"] = "오라 종류"
L["Unit"] = "유닛"


-- L["The rank of the item buff gained."] = true -- not used anymore
-- L["The rank of the item buff lost."] = true -- not used anymore

L = LibStub("AceLocale-3.0"):NewLocale("Parrot_CombatEvents_Data", "koKR")
L["Ability blocks"] = "기술 방어"
L["Ability dodges"] = "기술 피함"
L["Ability misses"] = "기술 빗맞힘"
L["Ability parries"] = "기술 막음"
L["Amount of the damage that was missed."] = "적중되지 않는 피해량입니다."
L["Arcane"] = "비전"
L["Avoids"] = "회피"
L["Combat status"] = "전투 상황"
L["Combo point gain"] = "연계 포인트 획득"
L["Combo points"] = "연계 점수"
L["Combo points full"] = "연계 점수 충만"
L["Damage"] = "피해"
L[" (%d crits)"] = " (%d 치명타)"
L[" (%d gains)"] = " (%d 획득)"
L[" (%d heal, %d crit)"] = " (%d 치유, %d 극대화)"
L[" (%d heal, %d crits)"] = " (%d 치유, %d 극대화)"
L[" (%d heals)"] = " (%d 치유)"
L[" (%d heals, %d crit)"] = " (%d 치유, %d 극대화)"
L[" (%d heals, %d crits)"] = " (%d 치유, %d 극대화)"
L[" (%d hit, %d crit)"] = " (%d 피해, %d 치명타)"
L[" (%d hit, %d crits)"] = " (%d 피해, %d 치명타)"
L[" (%d hits)"] = " (%d 피해)"
L[" (%d hits, %d crit)"] = " (%d 피해, %d 치명타)"
L[" (%d hits, %d crits)"] = " (%d 피해, %d 치명타)"
L["Dispel"] = "무효화"
L["Dispel fail"] = "무효화 실패"
L[" (%d losses)"] = " (%d 손실)"
L["Dodge!"] = "피함!"
L["DoTs and HoTs"] = "지속적인 피해/치유"
L["Enter combat"] = "전투 시작"
L["Environmental damage"] = "환경 피해"
L["Evade!"] = "빗나감!"
L["Experience gains"] = "경험치 획득"
L["Extra attacks"] = "추가 공격"
L["Fire"] = "화염"
L["Frost"] = "냉기"
L["Heals"] = "치유"
L["Heals over time"] = "지속적인 치유"
L["Holy"] = "신성"
L["Honor gains"] = "명예 획득"
L["Immune!"] = "면역!"
L["Incoming damage"] = "들어오는 피해"
L["Incoming heals"] = "들어오는 치유"
L["Interrupt!"] = "차단!"
L["Killing Blow!"] = "죽임!"
L["Killing blows"] = "결정타"
L["Leave combat"] = "전투 종료"
L["Melee"] = "근접"
L["Melee absorbs"] = "근접 흡수"
L["Melee blocks"] = "근접 방어"
L["Melee damage"] = "근접 피해"
L["Melee deflects"] = "근접 공격 빗맞음"
L["Melee dodges"] = "근접 회피"
L["Melee evades"] = "근접 빗나감"
L["Melee immunes"] = "근접 면역"
L["Melee misses"] = "근접 빗맞힘"
L["Melee parries"] = "근접 막음"
L["Melee reflects"] = "근접 공격 반사"
L["Melee resists"] = "근접 공격 저항"
L["Miss!"] = "빗맞힘!"
L["Misses"] = "적중하지 않음"
L["Multiple"] = "복합"
L["Nature"] = "자연"
L["NPC killing blows"] = "NPC 죽음 알림"
L["[Num] CP"] = "[Num] 연계"
L["[Num] CP Finish It!"] = "[Num] 연계 포인트 마무리!"
L["Other"] = "기타"
L["Outgoing damage"] = "나가는 피해"
L["Outgoing heals"] = "나가는 치유"
L["Parry!"] = "막음!"
L["Pet ability blocks"] = "소환수 기술 방어"
L["Pet ability dodges"] = "수환수 기술 피함"
L["Pet ability misses"] = "소환수 기술 빗맞힘"
L["Pet ability parries"] = "소환수 기술 막음"
L["Pet Absorb!"] = "소환수 흡수!"
L["(Pet) -[Amount]"] = "(소환수) -[Amount]"
L["(Pet) +[Amount]"] = "(소환수) +[Amount]"
L["Pet [Amount] ([Skill])"] = "소환수 [Amount] ([Skill])"
L["Pet Block!"] = "소환수 방어!"
L["Pet damage"] = "소환수 피해"
L["Pet Dodge!"] = "소환수 피함!"
L["Pet Evade!"] = "소환수 빗나감!"
L["Pet heals"] = "소환수 치유"
L["Pet heals over time"] = "소환수 지속 치유"
L["Pet Immune!"] = "소환수 면역!"
L["Pet melee"] = "소환수 근접"
L["Pet melee absorbs"] = "소환수 근접 흡수"
L["Pet melee blocks"] = "소환수 근접 방어"
L["Pet melee damage"] = "소환수 근접 피해"
L["Pet melee deflects"] = "소환수 근접 공격 빗맞음"
L["Pet melee dodges"] = "소환수 근접 피함"
L["Pet melee evades"] = "소환수 근접 빗나감"
L["Pet melee immunes"] = "소환수 근접 면역"
L["Pet melee misses"] = "소환수 근접 빗맞힘"
L["Pet melee parries"] = "소환수 근접 막음"
L["Pet melee reflects"] = "소환수 근접 공격 반사"
L["Pet melee resists"] = "소환수 근접 공격 저항"
L["Pet Miss!"] = "소환수 빗맞힘!"
L["Pet misses"] = "소환수 적중하지 않음"
L["Pet Parry!"] = "소환수 막음!"
L["Pet Reflect!"] = "소환수 반사!"
L["Pet Resist!"] = "소환수 저항!"
L["Pet siege damage"] = "소환수 피해"
L["Pet skill"] = "소환수 기술"
L["Pet skill absorbs"] = "소환수 기술 흡수"
L["Pet skill blocks"] = "소환수 기술 방어"
L["Pet skill damage"] = "소환수 기술 피해"
L["Pet skill deflects"] = "소환수 기술 빗맞음"
L["Pet skill dodges"] = "소환수 기술 피함"
L["Pet skill DoTs"] = "소환수 지속 스킬"
L["Pet skill evades"] = "소환수 기술 빗나감"
L["Pet skill immunes"] = "소환수 기술 면역"
L["Pet skill interrupts"] = "소환수 기술 차단"
L["Pet skill misses"] = "소환수 기술 빗맞힘"
L["Pet skill parries"] = "소환수 기술 막음"
L["Pet skill reflects"] = "소환수 기술 반사"
L["Pet skill resists"] = "소환수 기술 저항"
L["Pet skills"] = "소환수 기술"
L["Pet spell resists"] = "소환수 주문 저항"
L["Physical"] = "물리"
L["Player killing blows"] = "플레이어 죽음 알림"
L["Power change"] = "파워 변동"
L["Power gain"] = "파워 획득"
L["Power gain/loss"] = "파워 획득/손실"
L["Power loss"] = "파워 손실"
L["Reactive skills"] = "기술 사용 가능 여부"
L["Reflect!"] = "반사!"
L["Reputation"] = "평판"
L["Reputation gains"] = "평판 획득"
L["Reputation losses"] = "평판 손실"
L["Resist!"] = "저항!"
L["%s!"] = "%s!"
L["Self heals"] = "자신 치유"
L["Self heals over time"] = "자신의 지속 치유"
L["%s failed"] = "%s 실패"
L["Shadow"] = "암흑"
L["Siege damage"] = "피해"
L["Skill absorbs"] = "기술 흡수"
L["Skill blocks"] = "기술 방어"
L["Skill damage"] = "기술 피해"
L["Skill deflects"] = "기술 빗맞음"
L["Skill dodges"] = "기술 피함"
L["Skill DoTs"] = "기술 지속 피해"
L["Skill evades"] = "기술 빗나감"
L["Skill gains"] = "기술 획득"
L["Skill immunes"] = "기술 면역"
L["Skill interrupts"] = "기술 차단"
L["Skill misses"] = "기술 빗맞힘"
L["Skill parries"] = "기술 막음"
L["Skill reflects"] = "기술 반사"
L["Skill resists"] = "기술 저항"
L["Skills"] = "기술"
L["Skills absorbs"] = "기술 흡수"
L["Skills blocks"] = "기술 방어"
L["Skills dodges"] = "기술 피함"
L["Skills evades"] = "기술 빗나감"
L["Skills immunes"] = "기술 면역"
L["Skills misses"] = "기술 빗맞힘"
L["Skills parries"] = "기술 막음"
L["Skills reflects"] = "기술 반사함"
L["Skills resists"] = "기술 저항함"
L["Skill your pet was interrupted in casting"] = "당신의 소환수가 시전 방해 받은 기술"
L["Skill you were interrupted in casting"] = "당신이 시전 방해 받은 기술"
L["Spell resists"] = "주문 저항"
L["Spell steal"] = "마법 훔치기"
L["%s stole %s"] = "%s의 %s 훔침"
L["The ability or spell take away your power."] = "파워를 감소시킨 능력이나 주문입니다."
L["The ability or spell used to gain power."] = "파워 획득에 사용된 능력이나 주문입니다."
L["The ability or spell your pet used."] = "당신의 소환수가 사용한 능력이나 주문입니다."
L["The amount of damage done."] = "입힌 피해량입니다."
L["The amount of experience points gained."] = "획득한 경험치량입니다."
L["The amount of healing done."] = "치유량량니다."
L["The amount of honor gained."] = "획득한 명예량입니다."
L["The amount of power gained."] = "획득한 파워량입니다."
L["The amount of power lost."] = "손실된 파워량입니다."
L["The amount of reputation gained."] = "획득한 평판량입니다."
L["The amount of reputation lost."] = "손실된 평판량입니다."
L["The amount of skill points currently."] = "현재 기술 포인트입니다."
L["The character that caused the power loss."] = "파워 손실을 일으킨 캐릭터입니다."
L["The character that the power comes from."] = "파워를 빼앗은 캐릭터입니다."
L["The current number of combo points."] = "현재 연계 점수 숫자입니다."
L["The name of the ally that healed you."] = "당신을 치유한 아군의 이름입니다."
L["The name of the ally that healed your pet."] = "당신의 소환수를 치유한 아군의 이름입니다."
L["The name of the ally you healed."] = "당신이 치유한 아군의 이름입니다."
L["The name of the enemy slain."] = "죽인 적의 이름입니다."
L["The name of the enemy that attacked you."] = "당신을 공격한 적의 이름입니다."
L["The name of the enemy that attacked your pet."] = "당신의 소환수를 공격한 적의 이름입니다."
L["The name of the enemy you attacked."] = "당신이 공격한 적의 이름입니다."
L["The name of the enemy your pet attacked."] = "당신의 소환수가 공격한 적의 이름입니다."
L["The name of the faction."] = "진영의 이름입니다."
L["The name of the spell or ability which provided the extra attacks."] = "추가 공격을 제공한 주문이나 기술입니다."
L["The name of the spell that has been dispelled."] = "무효화한 주문의 이름입니다."
L["The name of the spell that has been stolen."] = "훔친 주문의 이름입니다."
L["The name of the spell that has been used for dispelling."] = "무효화에 사용된 주문의 이름입니다."
L["The name of the spell that has been used for stealing."] = "훔치기에 사용된 주문의 이름입니다."
L["The name of the spell that has not been dispelled."] = "무효화 되지 않는 주문의 이름입니다."
L["The name of the unit from which the spell has been removed."] = "주문을 제거 당한 유닛의 이름입니다."
L["The name of the unit from which the spell has been stolen."] = "주문을 훔침 당한 유닛의 이름입니다."
L["The name of the unit from which the spell has not been removed."] = "주문 제거를 당하지 않은 유닛의 이름입니다."
L["The name of the unit that dispelled the spell from you"] = "당신의 주문을 무효화한 유닛의 이름입니다."
L["The name of the unit that failed dispelling the spell from you"] = "당신에게 주문 무효화를 실패한 유닛의 이름입니다."
L["The name of the unit that stole the spell from you"] = "당신의 주문을 훔친 유닛의 이름입니다."
L["The name of the unit that your pet healed."] = "당신의 소환수를 치유한 유닛의 이름입니다."
L["The rank of the enemy slain."] = "죽인 적의 계급입니다."
L["The skill which experienced a gain."] = "경험치를 획득한 기술입니다."
L["The spell or ability that the ally healed your pet with."] = "당신의 소환수를 치유한 대상의 주문이나 기술입니다."
L["The spell or ability that the ally healed you with."] = "당신을 치유한 아군의 주문이나 기술입니다."
L["The spell or ability that the enemy attacked your pet with."] = "적이 당신의 소환수를 공격한 주문이나 기술입니다."
L["The spell or ability that the enemy attacked you with."] = "당신을 공격한 적의 주문이나 기술입니다."
L["The spell or ability that the pet used to heal."] = "소환수를 치유한 주문이나 기술입니다."
L["The spell or ability that your pet used."] = "당신의 소환수가 사용한 주문이나 기술입니다."
L["The spell or ability that you used."] = "당신이 사용한 주문이나 기술입니다."
L["The spell or ability used to slay the enemy."] = "당신이 적에게 사용한 주문이나 기술입니다."
L["The spell you interrupted"] = "당신이 방해한 주문"
L["The spell your pet interrupted"] = "당신의 소환수가 방해한 주문"
L["The type of damage done."] = "입힌 피해의 유형입니다."
L["The type of power gained (Mana, Rage, Energy)."] = "파워 획득 유형입니다. (마나, 분노, 기력)"
L["The type of power lost (Mana, Rage, Energy)."] = "파워 손실 유형입니다. (마나, 분노, 기력)"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Cooldowns", "koKR")
L["Click to remove"] = "클릭시 제거"
L["Cooldowns"] = "재사용 대기시간"
L["Divine Shield"] = "천상의 보호막"
L["Fire traps"] = "불 덫"
L["Frost traps"] = "냉기 덫"
L["Ignore"] = "무시"
L["Ignore Cooldown"] = "재사용 대기시간 무시"
L["Item cooldown ready"] = "아이템 재사용 대기시간 준비"
L["<Item name>"] = "<아이템 이름>"
L["Judgements"] = "심판류"
L["Minimum time the cooldown must have (in seconds)"] = "최소 재사용 대시시간 (초)"
L["Shocks"] = "충격류"
L["Skill cooldown finish"] = "기술 재사용 대기시간 완료"
L["<Spell name>"] = "<주문 이름>"
L["[[Spell] ready!]"] = "[[Spell] 사용 가능!]"
L["Spell ready"] = "주문 준비 완료"
L["Spell usable"] = "유용한 주문"
L["%s Tree"] = "%s 계열"
L["The name of the spell or ability which is ready to be used."] = "사용할 준비가 된 주문이나 기술입니다."
L["Threshold"] = "수치" -- Needs review
L["Traps"] = "덫류"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Loot", "koKR")
L["Loot"] = "획득"
L["Loot +[Amount]"] = "+[Amount] 획득"
L["Loot items"] = "아이템 획득"
L["Loot money"] = "골드 획득"
L["Loot [Name] +[Amount]([Total])"] = "[Name] +[Amount]([Total] 획득)"
L["Soul shard gains"] = "영혼석 획득" -- Needs review
L["The amount of gold looted."] = "획득한 골드의 양입니다."
L["The amount of items looted."] = "획득한 아이템의 수량입니다."
L["The name of the item."] = "아이템의 이름입니다."
L["The name of the soul shard."] = "영혼석 이름입니다." -- Needs review
L["The total amount of items in inventory."] = "가방에 있는 아이템의 총 수량입니다."


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_TriggerConditions_Data", "koKR")
L["Active talents"] = "활성화된 특성"
L["Amount"] = "양"
L["Amount of damage to compare with"] = "비교할 피해량"
L["Amount of health to compare"] = "비교할 생명력 수치"
L["Amount of power to compare"] = "비교할 파워 수치"
L["Any"] = "아무"
L["Comparator Type"] = "비교 종류"
L["Deathknight presence"] = "죽음의 기사 존재"
L["Druid Form"] = "드루이드 변신"
L["Enemy target health percent"] = "적대적 대상 생명력 백분율"
L["Friendly target health percent"] = "우호적 대상 생명력 백분율"
L["Hostility"] = "적대적"
L["How to compare actual value with parameter"] = "실 수치를 변수와 비교하는 방법"
L["In a Group or Raid"] = "파티나 공격대시"
L["Incoming block"] = "들어오는 방어"
L["Incoming cast"] = "들어오는 주문"
L["Incoming crit"] = "들어오는 치명타"
L["Incoming damage"] = "들어오는 피해"
L["Incoming dodge"] = "들어오는 회피"
L["Incoming miss"] = "들어오는 빗맞힘"
L["Incoming parry"] = "들어오는 막음"
L["In vehicle"] = "차량"
L["Lua function"] = "Lua 기능"
L["Maximum target health percent"] = "최대 대상 생명력 백분율"
L["Minimum power amount"] = "최소 파워 수치"
L["Minimum power percent"] = "최소 파워 백분율"
L["Minimum target health"] = "최소 대상 생명력"
L["Minimum target health percent"] = "최소 대상 생명력 백분율"
L["Miss type"] = "빗맞힘 종류"
L["Mounted"] = "탈것"
L["Not Deathknight presence"] = "죽음의 기사 존재하지 않을때"
L["Not in Druid Form"] = "드루이드 변신 아닐때"
L["Not in vehicle"] = "차량 이용 아닐때"
L["Not in warrior stance"] = "전투태세 아닐때"
L["Not mounted"] = "탈것을 이용하고 있지 않을때"
L["Outgoing block"] = "나가는 방어"
L["Outgoing cast"] = "나가는 주문"
L["Outgoing crit"] = "나가는 치명타"
L["Outgoing damage"] = "나가는 피해"
L["Outgoing dodge"] = "나가는 회피"
L["Outgoing miss"] = "나가는 빗맞힘"
L["Outgoing parry"] = "나가는 막음"
L["Pet health percent"] = "소환수의 생명력 백분율"
L["Pet mana percent"] = "소환수 마나 백분율"
L["Power type"] = "파워 종류"
L["Primary"] = "1특성"
L["Reason for the miss"] = "빗맞음 이유"
L["Secondary"] = "2특성"
L["Self health percent"] = "자신의 생명력 백분율"
L["Self mana percent"] = "자신의 마나 백분율"
L["<Skill name>"] = "<기술 이름>"
L["<Sourcename>,<Destinationname>,<Spellname>"] = "<Sourcename>,<Destinationname>,<Spellname>"
L["Successful spell cast"] = "주문 시전 성공"
L["Target is NPC"] = "대상 NPC"
L["Target is player"] = "대상 플레이어"
L["The unit that attacked you"] = "당신을 공격한 유닛"
L["The unit that is affected"] = "영향을 받는 유닛"
L["The unit that you attacked"] = "당신이 공격한 유닛"
L["Type of power"] = "파워의 종류"
L["Unit"] = "유닛"
L["Unit health"] = "유닛 생명력"
L["Unit power"] = "유닛 파워"
L["Warrior stance"] = "전사 태세"
L["Whether the unit should be friendly or hostile"] = "유닛이 우호적인지 적대적인지 표시합니다."


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_CombatStatus", "koKR")
L["-Combat"] = "-전투"
L["+Combat"] = "+전투"
L["Combat status"] = "전투 상황"
L["Enter combat"] = "전투 시작"
L["In combat"] = "전투중"
L["Leave combat"] = "전투 종료"
L["Not in combat"] = "비전투중"

