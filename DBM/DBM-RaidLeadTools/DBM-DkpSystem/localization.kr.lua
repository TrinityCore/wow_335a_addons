if GetLocale() ~= "koKR" then return end

local L = DBM_DKP_System_Translations

L.Local_TimeReached 			= "새로운 레이드 이벤트(Time-base)를 작성하였습니다."
L.Local_NoRaidPresent		= "DKP 추적기를 시작한 이후 공격대에 참여해주세요."
L.Local_RaidSaved			= "현재 레이드를 정상적으로 닫았습니다."

L.AcceptDKPValue			= "DKP"

L.AreaHistory				= "이벤트 기록"
L.History_Line				= "[%s][%s]: %s (%d)" 		-- [date][zone] Hogger (playercount)

L.LocalError_AddItemNoRaid	= "레이드가 진행중이지 않으므로, 이 아이템을 저장할 수가 없습니다."

-- GUI
L.TabCategory_DKPSystem		= "DKP System"
L.AreaGeneral				= "일반적인 DKP System 설정"
L.Enable					= "레이드 이벤트 추척을 위한 DKP System 켜기"
L.Enable_StarEvent			= "레이드 시작에 대한 이벤트 만들기"
L.Enable_TimeEvents			= "시간을 기본으로 하는 이벤트 만들기(예 : 시간당 1 이벤트)"
L.Enable_BossEvents			= "보스킬 이벤트 만들기"
L.Enable_SB_Users			= "Count players on standby as raid members"
L.Enable_5ppl_tracking		= "5인 던전에서 DKP 추적 허용"

L.BossPoints				= "보스 킬 포인트"
L.TimePoints				= "시간 포인트(예 : 시간당 10 DKP)"
L.StartPoints				= "레이드시작 포인트"

L.BossDescription			= "보스 킬에 대한 설명 (%s 는 보스의 이름)"
L.TimeDescription			= "시간 이벤트에 대한 설명"
L.StartDescription			= "레이드 시작에 대한 설명"

L.TimeToCount				= "every X 분"

L.AreaManageRaid			= "새로운 레이드 또는 이벤트 시작"
L.Button_StartDKPTracking	= "DKP 추적 시작"
L.Button_StopDKPTracking	= "DKP 추적 중지"

L.CustomPoint				= "포인트 임의 부여"
L.CustomDescription			= "현재 이벤트에 대한 설명"
L.CustomDefault				= "업적 달성, 빠른 진행, 추가 dkp등 작성"
L.Button_CreateEvent		= "특별 이벤트 만들기"
L.Button_ResetHistory		= "기록 초기화"
L.Local_NoInformation		= "이 이벤트의 이름과 포인트를 지정해주세요."
L.Local_EventCreated		= "당신의 이벤트가 성공적으로 만들어졌습니다."
L.Local_StartRaid			= "새로운 레이드가 시작됐습니다."
L.Local_Debug_NoRaid		= "플레이어가 없으므로, 이벤트가 작성 되지 않았습니다! 이벤트를 수동으로 만들어주세요."

L.AllPlayers				= "모든 플레이어"

L.TabCategory_History		= "레이드 기록"

-- PLEASE NEVER ADD THIS LINES OUTSIDE OF THE EN TRANSLATION, ADDON WILL BE BROKEN
L.DateFormat			= "%y/%m/%d %H:%M:%S"	-- DO NOT PASTE TO TRANSLATE, ONLY IN EN FILE!!!
L.Local_Version			= "%s: %s"		-- DO NOT PASTE TO TRANSLATE, ONLY IN EN FILE!!
