DBM_BidBot_Translations = {}

local L = DBM_BidBot_Translations

L.Prefix = "[BidBot]: "

L.Whisper_Queue 			= "Another auction is currently running. Your Item has been queued."
L.Whisper_Bid_OK 			= "Your bid of %d DKP was accepted."
L.Whisper_Bid_DEL			= "Your bid has been removed!"
L.Whisper_Bid_DEL_failed	= "You can't delete bids in open bidding mode"
L.Whisper_InUse 			= "<remove me>"
L.Message_StartRaidWarn		= "Bid now on %s - whisper to [%s]!"
L.Message_StartBidding		= "Please bid on %s now by whispering to [%s]! Lowest possible bid: %d"
L.Message_DoBidding			= "Time remaining for %s: %d seconds."
L.Message_ItemGoesTo		= "%2$s won %1$s for %3$d DKP!"
L.Message_NoBidMade			= "There was no bid on %s."
L.Message_Biddings			= "%d. %s bid %d DKP."
L.Message_BiddingsVisible	= "%d players bid on this item."
L.Message_BidPubMessage		= "New bid: %s bids %d DKP"
L.Disenchant				= "Disenchant"

L.PopUpAcceptDKP			= "Save bid for %s. For disenchant please type in 0 DKP."


-- GUI
L.TabCategory_BidBot	 	= "BidBot (DKP)"
L.TabCategory_History	 	= "Item History"
L.AreaGeneral 				= "General BidBot Options"
L.AreaItemHistory			= "Item History"
L.Enable					= "Enable Bidbot (!bid [item])"
L.ShowinRaidWarn			= "Show Item as Raid Warning"
L.ChatChannel				= "Chat to use for output"
L.Local						= "only local output"
L.Guild						= "use guild chat"
L.Raid						= "use raid chat"
L.Party						= "use party chat"
L.Officer					= "use officer chat"
L.Error_ChanNotFound		= "Unknown channel for: %s"
L.MinBid					= "Minimum bid"
L.Duration					= "Time to bid in sec (default 30)"
L.OutputBids				= "How many top biddings to output (default top 3)"
L.PublicBids				= "Post bids to chat for public bidding"
L.PayWhatYouBid				= "Pay price of bid, (otherwise second bid + 1)"
L.NoHistoryAvailable		= "No history available"

L.Button_ShowClients		= "Show clients"
L.Button_ResetClient		= "reset bidbot"
L.Local_NoRaid				= "You have to be in a raid group to use this function"

-- PLEASE NEVER ADD THIS LINES OUTSIDE OF THE EN TRANSLATION, ADDON WILL BE BROKEN
L.DateFormat				= "%m/%d/%y %H:%M:%S"	-- DO NOT PASTE TO TRANSLATE, ONLY IN EN FILE!!!
L.Local_Version				= "%s: %s"		-- DO NOT PASTE TO TRANSLATE, ONLY IN EN FILE!!!

