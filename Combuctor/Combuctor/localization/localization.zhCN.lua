--[[
	Localization.lua
	简体中文 zhCN
		Translations for Combuctor
--]]


local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "zhCN")
if not L then return end

L.Updated = 'Updated to v%s'

--binding actions
L.ToggleInventory = "显示背包"
L.ToggleBank = "显示银行"

--frame titles
L.InventoryTitle = "%s的背包"
L.BankTitle = "%s的银行"

--tooltips
L.Inventory = '整合背包'
L.Bank = '银行'
L.TotalOnRealm = '总计 %s'
L.ClickToPurchase = '<点击> 购买'
L.Bags = '背包'
L.BagToggle = '<左键点击> 切换是否显示背包'
L.InventoryToggle = '<右键点击> 显示整合背包'
L.BankToggle = '<右键点击> 显示银行'
L.MoveTip = '<Alt+左键拖拽> 移动'
L.ResetPositionTip = '<右键点击> 恢复初始位置'

--default sets (need to be here because of a flaw in how I save things
--these are automatically localized (aka, don't translate them :)
do
	L.All = ALL

	L.Weapon, L.Armor, L.Container, L.Consumable, L.Glyph, L.TradeGood, 
 	L.Projectile, L.Quiver, L.Recipe, L.Gem, L.Misc, L.Quest = GetAuctionItemClasses()

	L.Trinket = getglobal('INVTYPE_TRINKET')

	L.Devices, L.Explosives = select(10, GetAuctionItemSubClasses(6))

	L.SimpleGem = select(8, GetAuctionItemSubClasses(7))
end

L.Normal = '常规'
L.Equipment = '装备'
L.Keys = '钥匙'
L.Trade = '商业'
L.Ammo = '弹药'
L.Shards = '碎片'
L.Usable = '消耗品'