-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local enUS = AceLocale:NewLocale("GoblinVendorFilter", "enUS", true)
if not enUS then return end

enUS["Show All"] = true
enUS["Filter All"] = true
enUS["Filter All desc"] = "Due to filters overlapping\nyou will most likely have to disable\ntwo or more filters after using\nthe Filter All button."
enUS["Already Known Filter Default"] = true
enUS["Affordable Filter Default"] = true
enUS['When selected only items you can afford will be displayed initially!'] = true
enUS['Affordable'] = true
enUS['When selected only unknown or not learnable items will be shown initially!'] = true
enUS['When selected this item quality will be shown'] = true
enUS["Usable Items Filter Default"] = true
enUS['When selected only usable items will be displayed initially!'] = true
enUS['Only Type/SubType combinations you have previously seen can be filtered by default'] = true
enUS['When selected this item type will be shown unless multible subtypes are found'] = true
enUS['Show this sub type'] = true
enUS['When selected this item equip location will be shown'] = true
enUS['Only equip location you have previously seen can be filtered by default'] = true
enUS['Only item stats you have previously seen can be filtered by default'] = true
enUS['|cFFFF0000<<WARNING>>|r|nIf you change these from the default grey checkmark you may missout on items with no stats.|nOnly item stats you have previously seen can be filtered by default'] = true
enUS['Yellow Checkmark:|nWe want this stat.|n|nGrey Checkmark:|nWe do not care if we have this stat or not.|n|nNo Checkmark:|nWe do not want this stat.'] = true
enUS["Don't Want:"] = true
enUS['Want:'] = true

--filters
enUS["Equip Location Filter"] = true
enUS["Item Quality Filter"] = true
enUS["Already Known Filter"] = true
enUS["Usable Items Filter"] = true
enUS["Item Type Filter"] = true
enUS["Item Stat Filter"] = true
enUS["Affordable Filter"] = true
