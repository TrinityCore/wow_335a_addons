local L = AceLibrary("AceLocale-2.2"):new("XLootMonitor")

L:RegisterTranslations("koKR", function()
	return {
		catGrowth = "생성 방향",
		catLoot = "전리품",
		catPosSelf = "기준 위치...",
		catPosTarget = "방향...",
		catPosOffset = "프레임 위치...",
		catModules = "모듈",
		
		moduleHistory = "전리품 이력",
		moduleActive = "사용",
		
		historyTime = "시간별 표시",
		historyPlayer = "플레이어별 표시",
		historyClear = "현재 이력 삭제",
		historyEmpty = "표시할 이력이 없습니다",
				
		optStacks = "스택/고정위치",
		optLockAll = "모든 프레임 고정",
		optPositioning = "위치화",
		optMonitor = "XLoot 현황",
		optAnchor = "고정위치 표시",
		optPosVert = "수직 이동",
		optPosHoriz = "수평 이동",
		optTimeout = "표시 시간",
		optDirection = "표시 방향",
		optThreshold = "열 개수",
		optQualThreshold = "최하 품질",
		optSelfQualThreshold = "자신의 최하 품질",
		optUp = "위",
		optDown = "아래",
		optMoney = "획득한 돈 표시",
		
		descStacks = "각각의 개별적인 스택에 대한 위치 표시와 제한 시간같은 설정들을 변경합니다.",
		descPositioning = "스택내 줄의 위치와 정렬",
		descMonitor = "XLootMonitor 플러그인 환경설정",
		descAnchor = "해당 스택에 대한 고정위치 표시",
		descPosVert = "선택한 고정 위치에서 세로로 이동할 좌표",
		descPosHoriz = "선택한 고정 위치에서 가로로 이동할 좌표",
		descTimeout = "각 줄의 유지 시간 |cFFFF5522시간 제한 사라짐을 비활성화 하려면 0으로 설정하세요.",
		descDirection = "스택 생성 방향",
		descThreshold = "주어진 시간 내에 표시할 열의 최대 개수",
		descQualThreshold = "모든 획득한 전리품을 표시할 최하위 품질",
		descSelfQualThreshold = "자신이 획득한 전리품을 표시할 최하위 품질",
		descMoney = "파티에 속해 있을 때 획득한 돈의 분배 표시 |cFFFF0000솔로일 때의 돈은 아직 포함되지 않습니다.|r",
		
		optPos = {
			TOPLEFT = "좌측 상단 구석",
			TOP = "상단 끝",
			TOPRIGHT = "우측 상단 구석",
			RIGHT = "우측 끝",
			BOTTOMRIGHT = "우측 하단 구석",
			BOTTOM = "하단 끝",
			BOTTOMLEFT = "좌측 하단 구석",
			LEFT = "좌측 끝",
			TOPLEFT = "좌측 상단 구석",
		},
		
		linkErrorLength = "Linking would make the message too long. Send or clear the current message and try again.",
		
		playerself = "당신", 
	}
end)

