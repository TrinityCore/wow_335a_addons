local L = AceLibrary("AceLocale-2.2"):new("XLootGroup")

L:RegisterTranslations("enUS", function()
	return {
		["Show countdown text"] = true,
		["Show small text beside the item indicating how much time remains"] = true,
		["Show current rolls"] = true,
		["Show small text beside the item indicating how many have chosen what to roll"] = true,
		["Fade out rows"] = true,
		["Smoothly fade rows out once rolled on."] = true,
		["Roll button size"] = true,
		["Size of the Need, Greed, Disenchant and Pass buttons"] = true,
		["XLoot Group"] = true,
		["A stack of frames for showing group loot information"] = true,
		["Trim item names to..."] = true,
		["Length in characters to trim item names to"] = true,
		["Prevent rolls on BoP items"] = true,
		["Locks the Need and Greed buttons for any BoP items"] = true,
	}
end)

