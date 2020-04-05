-- yleaf(yaroot@gmail.com)
if GetLocale() ~= "zhCN" then return end
local L = DBM_BidBot_Translations

L.Prefix = "[BidBot]: "

L.Whisper_Queue 		= "另一个物品正在竞拍, 你的物品被自动加入到队列中."
L.Whisper_Bid_OK 		= "你的出价已经被接受: %d DKP."
L.Whisper_InUse 		= "<移除我>"
L.Message_StartBidding		= "对 %s 出价请密语 [%s]! 起拍: %d"
L.Message_DoBidding		= "%s 竞拍剩余时间: %d 秒."
L.Message_ItemGoesTo		= "%2$s 赢得了 %1$s (%d DKP)!"
L.Message_NoBidMade		= "没有人对 %s 出价."
L.Message_Biddings		= "%d. %s 出了 %d DKP."
L.Message_BiddingsVisible	= "%d 位玩家对此物品出价."
L.Message_BidPubMessage		= "新竞价: %s 出了 %d DKP"
L.Disenchant			= "分解"

L.PopUpAcceptDKP		= "保存 %s 的竞价. 分解请设置为 0 DKP."


-- GUI
L.TabCategory_BidBot	 	= "竞拍助手 [BidBot]"
L.TabCategory_History	 	= "物品历史"
L.AreaGeneral 			= "常规设置"
L.AreaItemHistory		= "物品历史"
L.Enable			= "开启竞价助手 (!bid [item])"
L.ChatChannel			= "输出频道"
L.Local				= "只在本地提示"
L.Guild				= "工会频道"
L.Raid				= "团队频道"
L.Party				= "小队频道"
L.Officer			= "工会官员频道"
L.Error_ChanNotFound		= "没有找到频道: %s"
L.MinBid			= "最低出价"
L.Duration			= "竞拍时间 (默认 30 秒)"
L.OutputBids			= "通告最高出价者数量 (默认前三位)"
L.PublicBids			= "发布明拍出价到聊天频道"
L.PayWhatYouBid			= "输入你出的价格, (否则为比第二位多1)"
L.NoHistoryAvailable		= "没有物品历史"

L.Button_ShowClients		= "显示插件版本"
L.Button_ResetClient		= "重设竞拍助手"
L.Local_NoRaid			= "在团队中才能使用此功能"

