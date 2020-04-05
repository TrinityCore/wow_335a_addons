
if GetLocale() ~= "deDE" then return end

local L = DBM_BidBot_Translations

L.Whisper_Queue 			= "Zur Zeit wird noch geboten. Item(s) landen in der Warteschlange."
L.Whisper_Bid_OK 			= "Dein Gebot von %d DKP wurde akzeptiert."
L.Whisper_Bid_DEL			= "Dein Gebot wurde gelöscht!"
L.Whisper_InUse 			= "Zur Zeit wird noch auf %s geboten."

L.Message_StartRaidWarn		= "Gebote für %s - absofort bei [%s]!"
L.Message_StartBidding		= "Jetzt für %s bei %s bieten! Mindestgebot: %d"
L.Message_DoBidding			= "Verbleibende Zeit für %s: %d Sekunden."

L.Message_ItemGoesTo		= "%s geht an %s für %d Punkte. Gratz!"
L.Message_NoBidMade			= "Keiner hat auf %s geboten."

L.Message_Biddings			= "%d. %s hat %d DKP geboten."
L.Message_BiddingsVisible	= "es wurden nur %d Gebote angezeigt."
L.Message_BidPubMessage		= "Neues Gebot: %s hat %d DKP geboten."

L.Disenchant				= "Disenchant"
L.PopUpAcceptDKP			= "Speichere Gebot für %s. Bei Disenchant bitte 0 DKP eingeben."

-- GUI
L.TabCategory_BidBot	 	= "BidBot (DKP)"
L.TabCategory_History	 	= "Gegenstands Historie"
L.AreaGeneral 				= "Allgemeine BidBot Einstellungen"
L.AreaItemHistory			= "Gegenstands Historie des BidBots"
L.Enable					= "Aktiviere Bidbot (!bid [item])"
L.ShowinRaidWarn			= "Item als Raidwarnung Anzeigen"
L.ChatChannel				= "Chat für Ausgaben"
L.Local						= "nur lokal ausgeben"
L.Guild						= "nutze Gilden Chat"
L.Raid						= "nutze Schlachtzug Chat"
L.Party						= "nutze Gruppen Chat"
L.Officer					= "nutze Offiziers Chat"
L.Error_ChanNotFound		= "Unbekannter Chat für: %s"
L.MinBid					= "Minimum Gebot"
L.Duration					= "Zeit zum Bieten in Sec (standard 30)"
L.OutputBids				= "Zeige Top X gebote (standard Top 3)"
L.PublicBids				= "Zeige Gebote öffentlich im Chat"
L.PayWhatYouBid				= "Bezahlt wird was geboten wird (ansonsten zweites gebot +1)"
L.NoHistoryAvailable		= "Es ist keine Historie verfügbar"

L.Button_ShowClients		= "Zeige BidBot Versionen"
L.Button_ResetClient		= "Einstellungen zurücksetzen"
L.Local_NoRaid				= "Du musst in einer Schlachtgruppe sein um diese Funktion zu nutzen."


