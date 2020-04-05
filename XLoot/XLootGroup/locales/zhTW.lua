local L = AceLibrary("AceLocale-2.2"):new("XLootGroup")

L:RegisterTranslations("zhTW", function()
	return {
		["Show countdown text"] = "顯示倒數文字",
		["Show small text beside the item indicating how much time remains"] = "在物品側邊顯示剰餘時間",
		["Show current rolls"] = "顯示目前擲骰",
		["Show small text beside the item indicating how many have chosen what to roll"] = "在物品側邊顯示擲骰選擇",
		["Fade out rows"] = "淡出擲骰計時器",
		["Smoothly fade rows out once rolled on."] = "擲骰後平滑淡出擲骰計時器",
		["Roll button size"] = "擲骰按鍵大小",
		["Size of the Need, Greed, Disenchant and Pass buttons"] = "[需求][貪婪][略過]按鍵大小",
		["XLoot Group"] = "XLoot 隊伍",
		["A stack of frames for showing group loot information"] = "堆疊顯示隊伍捨取資訊",
		["Trim item names to..."] = "切齊物品名稱為...",
		["Length in characters to trim item names to"] = "設定物品名稱的切齊長度",
		["Prevent rolls on BoP items"] = "防止對 BoP 物品擲骰",
		["Locks the Need and Greed buttons for any BoP items"] = "對任何 BoP 物品鎖定[需求]和[貪婪]按鍵",
	}
end)

