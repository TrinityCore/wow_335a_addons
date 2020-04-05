-- yleaf@cwdg(yaroot@gmail.com)
if GetLocale() ~= "zhCN" then return end
local L = DBM_DKP_System_Translations

L.Local_TimeReached 		= "一个新记录被创建"
L.Local_NoRaidPresent		= "请在使用DKP自动追踪前加入一个团队"
L.Local_RaidSaved		= "成功保存当前团队"

L.AcceptDKPValue		= "DKP"

L.AreaHistory			= "RIAD历史"
L.History_Line			= "[%s][%s]: %s (%d)" 		-- [date][zone] Hogger (playercount)

L.LocalError_AddItemNoRaid	= "没有RIAD记录来添加这个物品"

-- GUI
L.TabCategory_DKPSystem		= "DKP助手"
L.AreaGeneral			= "常规设置"
L.Enable			= "开启DKP助手来追踪RAID记录"
L.Enable_StarEvent		= "RAID开始时创建事件"
L.Enable_TimeEvents		= "定时创建记录 (例如每小时创建一次记录)"
L.Enable_BossEvents		= "BOSS击杀时创建记录"
L.Enable_SB_Users		= "将待命列表中的玩家也保存到记录中"
L.Enable_5ppl_tracking		= "5人小队副本中启用DKP追踪"

L.BossPoints			= "击杀分"
L.TimePoints			= "时间分 (例如每小时10分)"
L.StartPoints			= "集合分"

L.BossDescription		= "说明 (%s 表示BOSS名字)"
L.TimeDescription		= "说明"
L.StartDescription		= "说明"

L.TimeToCount			= "每隔 X 分钟"

L.AreaManageRaid		= "开始一个新的记录"
L.Button_StartDKPTracking	= "开启DKP追踪"
L.Button_StopDKPTracking	= "关闭DKP追踪"

L.CustomPoint			= "额外奖励"
L.CustomDescription		= "说明"
L.CustomDefault			= "漂亮! 额外奖励!"
L.Button_CreateEvent		= "创建特殊记录"
L.Button_ResetHistory		= "清除历史记录"
L.Local_NoInformation		= "请指定分数和记录名字"
L.Local_EventCreated		= "记录成功创建"
L.Local_StartRaid		= "开始一个新的RAID"
L.Local_Debug_NoRaid		= "沒有玩家, 记录创建失败! 请手动创建!"

L.AllPlayers			= "所有玩家"

L.TabCategory_History		= "RAID历史"

