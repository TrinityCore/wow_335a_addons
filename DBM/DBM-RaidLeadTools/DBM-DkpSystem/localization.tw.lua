-- readjust by yleaf(yaroot@gmail.com)/Juha
if GetLocale() ~= "zhTW" then return end
local L = DBM_DKP_System_Translations

L.Local_TimeReached 		= "新增了一個時間性團隊事件"
L.Local_NoRaidPresent		= "使用DKP追蹤前請先加入一個團隊"
L.Local_RaidSaved		= "成功關閉現在的團隊"

L.AcceptDKPValue		= "DKP"

L.AreaHistory			= "事件記錄"
L.History_Line			= "[%s][%s]: %s (%d)" 		-- [date][zone] Hogger (playercount)

L.LocalError_AddItemNoRaid	= "沒有團隊運行以保存此裝備"

-- GUI
L.TabCategory_DKPSystem		= "DKP系統"
L.AreaGeneral			= "基本DKP系統選項"
L.Enable			= "啟用DKP系統追蹤團隊事件"
L.Enable_StarEvent		= "在團隊開始時創造事件"
L.Enable_TimeEvents		= "根據時間創造事件(例如:1小時1事件)"
L.Enable_BossEvents		= "根據BOSS擊殺創造事件"
L.Enable_SB_Users		= "計算就位的團隊成員"
L.Enable_5ppl_tracking		= "5人小隊副本中開啟DKP追蹤"

L.BossPoints			= "每一首領擊殺的點數"
L.TimePoints			= "每一時段的點數(例如:1小時10DKP)"
L.StartPoints			= "團隊開始的點數"

L.BossDescription		= "首領擊殺的敘述 (%s 是首領的名字)"
L.TimeDescription		= "時段的敘述"
L.StartDescription		= "團隊開始的敘述"

L.TimeToCount			= "每X分鐘"

L.AreaManageRaid		= "開始一個新的團隊或事件"
L.Button_StartDKPTracking	= "開始DKP追蹤"
L.Button_StopDKPTracking	= "停止DKP追蹤"

L.CustomPoint			= "給予的點數"
L.CustomDescription		= "此次事件的敘述"
L.CustomDefault			= "漂亮! 額外獎勵!"
L.Button_CreateEvent		= "創造一個特殊的事件"
L.Button_ResetHistory		= "清除歷史記錄"
L.Local_NoInformation		= "請註明點數以及該次事件的名稱"
L.Local_EventCreated		= "你的事件已經成功的創造"
L.Local_StartRaid		= "開始一個新的團隊"
L.Local_Debug_NoRaid		= "沒有玩家,事件沒有成功創造!請手動創造一個事件!"

L.AllPlayers			= "所有玩家"

L.TabCategory_History		= "團隊記錄"



