-- yleaf@cwdg(yaroot@gmail.com)
if GetLocale() ~= "zhCN" then return end
local L = DBM_StandbyBot_Translations

L.InRaidGroup		= "对不起, 你在待命前必须离开团队."
L.LeftRaidGroup 	= "你已经离开了团队. 如果你不想待命请密语我\"!sb\"."
L.AddedSBUser		= "你现在在待命列表内. 请一直在线直到我们需要你或者将你从待命列表中移除."
L.UserIsAllreadySB	= "对不起, 你已在待命列表内. 密语我\"!sb off\"."
L.NotStandby		= "对不起, 你不在待命列表中. 请密语联系我."
L.NoLongerStandby	= "你已经不在待命列表中了. 你待命了 %d 小时 %d 分钟."

L.PostStandybyList	= "当前待命:"

L.Local_AddedPlayer	= "[SB]: %s 在待命."
L.Local_RemovedPlayer	= "[SB]: %s 已不再待命."
L.Local_CantRemove	= "对不起, 不能移除玩家."
L.Local_CleanList	= "待命列表已清空 (%s 的请求)"

L.Current_StandbyTime	= "%s 待命时间:"
L.DateTimeFormat	= "%c"

L.History_OnJoin	= "[%s]: %s 在待命"
L.History_OnLeave	= "[%s]: %s 在 %s 分钟后离开了待命列表"
L.SB_History_Saved	= "待命列表保存为 %s"
L.SB_History_NotSaved	= "没有玩家在待命 --> 没有历史记录"

L.SB_History_Line	= "[ID=%d] %s 的团队有 %d 名团员"


-- GUI
L.TabCategory_Standby	= "待命助手"
L.AreaGeneral		= "常规设置"
L.Enable		= "开启待命助手 (!sb)"
L.SendWhispers		= "离开团队时密语玩家"
L.AreaStandbyHistory	= "待命历史"
L.NoHistoryAvailable	= "没有记录"

L.Button_ResetHistory	= "清空记录"
L.SB_Documentation	= [[待命助手可以让RL管理当前不能参加活动的团员. 以下所有命令都可以用在工会频道中.

!sb                   - 显示待命玩家列表
!sb times             - 显示已待命时间
!sb add <玩家名字>    - 增加一个玩家到待命列表中
!sb del <玩家名字>    - 将一名玩家从待命列表中移除
!sb save              - 保存当前列表
!sb reset             - 清空待命列表
!sb history [id]      - 显示待命历史

想要待命的玩家需要向安装有本插件的玩家密语 '!sb'. 然后他会得到一些说明. 如果想离开列表可以直接密语 '!sb off'.
]]

L.Button_ShowClients		= "显示客户端版本"
L.Local_NoRaid			= "你必须在团队中才能使用此功能"
--L.Local_Version			= "%s: %s"	-- Lacrosa: r123




