--    * koKR: BlueNyx(bluenyx@gmail.com)
if GetLocale() ~= "koKR" then return end

local L = DBM_AutoInvite_Translations

L.TabCategory_AutoInvite 	= "자동 초대 도구"
L.AreaGeneral 				= "일반 초대 옵션"
L.AllowGuildMates 			= "길드원의 자동 초대 허용"
L.AllowFriends 				= "친구 목록의 자동 초대 허용"
L.AllowOthers 				= "모든 사람의 자동 초대 허용"
L.Activate 					= "자동 초대 실행 키워드"
L.KeyWord 					= "귀속말로 키워드를 보낼때 초대"
L.InviteFailed 				= "%s 님을 초대 할 수 없습니다."
L.ConvertRaid 				= "공격대 구성"
L.WhisperMsg_RaidIsFull 		= "죄송합니다. 당신을 초대할 수가 없습니다. 공격대 인원이 모두 채워졌습니다."
L.WhisperMsg_NotLeader 		= "죄송합니다. 당신을 초대할 수가 없습니다. 제게 초대 권한이 없습니다."
L.WarnMsg_NoRaid			= "공격대 초대를 하기전에 파티를 공격대로 구성해 주세요."
L.WarnMsg_NotLead			= "죄송합니다. 당신이 공대장 혹은 권한이 있을 경우만 이 명령어를 실행할 수 있습니다."
L.WarnMsg_InviteIncoming	= "<DBM> 공격대 초대가 들어왔습니다! 당신의 파티를 탈퇴해 주세요."
L.Button_AOE_Invite			= "공격대 길드 초대"
L.AOEbyGuildRank			= "길드원의 모든 플레이어 초대 또는 현재 랭크를 포함"

-- RaidInvite Options
L.AreaRaidOptions			= "공격대 옵션"
L.PromoteEveryone			= "모든 공대원 승급 (재시작 필요)"
L.PromoteGuildRank			= "길드 랭크"
L.PromoteByNameList			= "다음의 공대원은 자동으로 승급 (띄어쓰기로 구분)"

L.DontPromoteAnyRank		= "길드 랭크 조건에 의해 자동 승급 정지"

L.Button_ResetSettings		= "초기화"