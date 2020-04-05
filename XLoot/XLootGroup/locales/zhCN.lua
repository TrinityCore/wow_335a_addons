--<CWDG>剜刀
local L = AceLibrary("AceLocale-2.2"):new("XLootGroup")

L:RegisterTranslations("zhCN", function()
	return {
		["Show countdown text"] = "显示倒计时文本",
		["Show small text beside the item indicating how much time remains"] = "在项目旁以小文字显示剩余时间",
		["Show current rolls"] = "显示当前Roll点",
		["Show small text beside the item indicating how many have chosen what to roll"] = "在项目旁以小文字显示当前Roll点情况",
		["Fade out rows"] = "淡出",
		["Smoothly fade rows out once rolled on."] = "Roll点后逐渐淡出该项目",
		["Roll button size"] = "按钮大小",
		["Size of the Need, Greed, Disenchant and Pass buttons"] = "需求,贪婪,放弃按钮的大小",
		["XLoot Group"] = "XLoot Group",
		["A stack of frames for showing group loot information"] = "队伍分配窗口加强",
		["Trim item names to..."] = "调整物品名称",
		["Length in characters to trim item names to"] = "调整显示物品名称的文字长度",
		["Prevent rolls on BoP items"] = "防止拾取BoP物品",
		["Locks the Need and Greed buttons for any BoP items"] = "当物品为BoP时,锁定需求、贪婪按钮.",
	}
end)

