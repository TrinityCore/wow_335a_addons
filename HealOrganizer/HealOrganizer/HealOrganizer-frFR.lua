-- By mymycracra (http://www.curse-gaming.com/en/profile-14788.html)
local L = LibStub("AceLocale-3.0"):NewLocale("HealOrganizer", "frFR", false)

if L then
	L["CLOSE"] = "Ferme";
	L["RESET"] = "Reset";
	L["RAID"] = "Raid";
	L["CHANNEL"] = "Canal";
	L["DISPEL"] = "Dispel";
	L["MT"] = "MT";
	L["HEAL"] = "Soin";
	L["DECURSE"] = "Decurse";
	L["REMAINS"] = "Restant";
	L["ARRANGEMENT"] = "Arrangement";
	L["BROADCAST"] = "Broadcast";
	L["OPTIONS"] = "Options";
	L["STATS"] = "Statistiques";
	L["PALADIN"] = "Paladin";
	L["DRUID"] = "Druide";
	L["PRIEST"] = "Priester";
	L["SHAMAN"] = "Schamane";
	L["PALADINS"] = "Paladin";
	L["DRUIDS"] = "Druides";
	L["PRIESTS"] = "Pr\195\170tres";
	L["SHAMANS"] = "Chamans";
	L["HEALARRANGEMENT"] = "Organisation des soins";
	L["FFA"] = "ffa"; -- was der rest machen darf
	L["NO_CHANNEL"] = "Vous devez vous connecter sur le canal %q avant d'organiser les soins";
	L["NOT_IN_RAID"] = "Vous n'etes pas en raid";
	L["FREE"] = "libre";
	L["EDIT_LABEL"] = "New label for group %u";
	L["SHOW_DIALOG"] = "Show/Hide the dialog";
	L["LABELS"] = "Labels";
	L["SAVEAS"] = "Save as";
	L["SET_SAVEAS"] = "Enter a name for the new set";
	L["SET_DEFAULT"] = "Default";
	L["SET_CANNOT_DELETE_DEFAULT"] = "You cannot delete the default set";
	L["SET_CANNOT_SAVE_DEFAULT"] = "You cannot overwrite the default set";
	L["SET_ALREADY_EXISTS"] = "The Set %q already exists";
	L["SET_TO_MANY_SETS"] = "You cannot have more than 32 sets";
	L["AUTOSORT_DESC"] = "Autosort for groups";
	L["REPLY_NO_ARRANGEMENT"] = "You are not assigned ";
	L["REPLY_ARRANGEMENT_FOR"] = "You are assigned to %s";
	L["AUTOFILL"] = "Autofill";
	L["MSG_HEAL_FOR_ARRANGEMENT"] = "Whisper 'heal' for your assignment.";
	L["WHISPER"] = "Whisper";
	L["ARRANGEMENT_FOR"] = "Your arrangement: %s";
end