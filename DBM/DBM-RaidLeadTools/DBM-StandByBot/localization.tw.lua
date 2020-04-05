-- yleaf(yaroot@gmail.com)/Juha
if GetLocale() ~= "zhTW" then return end
local L = DBM_StandbyBot_Translations

L.InRaidGroup		= "對不起, 你在候補前必須離開團隊."
L.LeftRaidGroup 	= "你已經離開了團隊. 如果你不想候補請密語我\"!sb\"."
L.AddedSBUser		= "你現在在候補清單內. 請保持在線上直到我們需要你或者將你從候補清單中移除."
L.UserIsAllreadySB	= "對不起, 你已在候補清單內. 密語我\"!sb off\"."
L.NotStandby		= "對不起, 你不在候補清單中. 請密語與我聯繫."
L.NoLongerStandby	= "你已經不在候補清單中了. 你候補了 %d 小時 %d 分鐘."

L.PostStandybyList	= "目前候補:"

L.Local_AddedPlayer	= "[SB]: %s 候補中."
L.Local_RemovedPlayer	= "[SB]: %s 已不是候補."
L.Local_CantRemove	= "對不起, 不能移除玩家."
L.Local_CleanList	= "候補清單已清空 (%s 的請求)"

L.Current_StandbyTime	= "%s 候補時間:"
L.DateTimeFormat	= "%c"

L.History_OnJoin	= "[%s]: %s 在候補"
L.History_OnLeave	= "[%s]: %s 在 %s 分鐘後離開了候補清單"
L.SB_History_Saved	= "候補清單儲存為 %s"
L.SB_History_NotSaved	= "沒有玩家在候補 --> 沒有歷史記錄"

L.SB_History_Line	= "[ID=%d] %s 的團隊有 %d 名團員"


-- GUI
L.TabCategory_Standby	= "候補助手"
L.AreaGeneral		= "一般設定"
L.Enable		= "開啟候補助手 (!sb)"
L.SendWhispers		= "離開團隊時密語玩家"
L.AreaStandbyHistory	= "候補歷史"
L.NoHistoryAvailable	= "沒有記錄"

L.SB_Documentation	= [[這個候補助手可以讓團長管理目前不能參加活動的團員. 以下所有命令都可以用在公會頻道中.

!sb                   - 顯示候補玩家清單
!sb times             - 顯示已候補時間
!sb add <玩家名字>    - 增加一個玩家到候補清單中
!sb del <玩家名字>    - 將一名玩家從候補清單中移除
!sb save              - 保存目前清單
!sb reset             - 清空候補清單
!sb history [id]      - 顯示候補歷史

想要候補的玩家需要向安裝有本插件的玩家密語 '!sb'. 然後他會得到一些說明. 如果想離開清單可以直接密語 '!sb off'.
]]

L.Button_ShowClients		= "顯示客戶端版本"
L.Local_NoRaid			= "在團隊中才能使用此功能"
L.Local_Version			= "%s: %s"	-- Lacrosa: r123




