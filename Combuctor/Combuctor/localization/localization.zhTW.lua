--[[
	Localization.lua
		Translations for Combuctor

	Traditional Chinese
	01Dec2008	Irene Wang <xares.vossen@gmail.com>
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "zhTW")
if not L then return end


L.Updated = '更新到%s版'

--binding actions
L.ToggleInventory = "打開或關閉背包"
L.ToggleBank = "打開或關閉銀行"

--frame titles
L.InventoryTitle = "%s的背包"
L.BankTitle = "%s的銀行"

--tooltips
L.Inventory = '背包'
L.Bank = '銀行'
L.TotalOnRealm = '%s的總資金'
L.ClickToPurchase = '<點選>購買'
L.Bags = '容器'
L.BagToggle = '<左鍵點選>顯示或隱藏容器'
L.InventoryToggle = '<右鍵點選>打開或關閉背包視窗'
L.BankToggle = '<右鍵點選>打開或關閉銀行視窗'
L.MoveTip = '<Alt-左鍵拖曳>移動'
L.ResetPositionTip = '<右鍵點選>重設位置'

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

L.Normal = '一般'
L.Equipment = '裝備'
L.Keys = '鑰匙'
L.Trade = '商業'
L.Ammo = '彈藥'
L.Shards = '碎片'
L.SoulShard = '靈魂碎片'
L.Usable = '消耗品'