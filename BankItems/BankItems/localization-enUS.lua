-- BankItems enUS Locale File
-- Yes, there is only one line of localization in this file.

BANKITEMS_LOCALIZATION = setmetatable({}, {__index = function(self, key)
	self[key] = key
	return key
end})
local L = BANKITEMS_LOCALIZATION

L["BANKITEMS_CAUTION_TEXT"] = "CAUTION: Some items were not parsed/displayed in this report because they do not exist in your WoW local cache yet. A recent WoW patch or launcher update caused the local cache to be cleared. Log on this character and visit the bank to correct this OR hover your mouse on every item in every bag to query the server for each itemlink (this may disconnect you).\n"
