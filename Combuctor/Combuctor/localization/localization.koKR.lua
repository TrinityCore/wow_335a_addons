--[[
	Localization.lua
		Translations for Combuctor

	Korean
	Translation by Bruteforce
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "koKR")
if not L then return end

L.Updated = 'v%s로 업데이트되었습니다.'

--binding actions
L.ToggleInventory = "인벤토리 토글"
L.ToggleBank = "은행 토글"

--frame titles
L.InventoryTitle = "%s의 인벤토리"
L.BankTitle = "%s의 은행"

--tooltips
L.Inventory = '인벤토리'
L.Bank = '은행'
L.TotalOnRealm = '%s의 총 금액'
L.ClickToPurchase = '<클릭>으로 구매'
L.Bags = '가방'
L.BagToggle = '<왼쪽 클릭>으로 가방 보기 토글'
L.InventoryToggle = '<오른쪽 클릭>으로 인벤토리 프레임 토글'
L.BankToggle = '<오른쪽 클릭>으로 은행 프레임 토글'
L.MoveTip = '<앨트-왼쪽 드래그>로 이동'
L.ResetPositionTip = '<오른쪽 클릭>으로 위치 초기화'

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

L.Normal = '일반'
L.Equipment = '장비'
L.Keys = '열쇠'
L.Trade = '전문 기술'
L.Ammo = '투사체'
L.Shards = '조각'
L.SoulShard = '영혼석'
L.Usable = '소비용품'