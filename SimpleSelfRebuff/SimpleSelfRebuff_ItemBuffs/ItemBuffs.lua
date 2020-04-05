if not SimpleSelfRebuff then return end
local SimpleSelfRebuff = SimpleSelfRebuff

local ItemBuffs = SimpleSelfRebuff:NewModule("ItemBuffs")

function ItemBuffs:OnEnable()

	local L = SimpleSelfRebuff.L
	local new, del, err = SimpleSelfRebuff.new, SimpleSelfRebuff.del, SimpleSelfRebuff.err
	local PT3

	-- Shameless rip from PT3 (revision 46)
	local setStrings = {
		["Consumable.Weapon Buff.Firestone"]="41170:7,41169:14,41172:28,40773:35,41173:42",
		["Consumable.Weapon Buff.Oil.Mana"]="20745:4,20747:8,20748:12,22521:14",
		["Consumable.Weapon Buff.Oil.Wizard"]="20744:8,20746:16,20750:24,20749:36,22522:42",
		["Consumable.Weapon Buff.Poison.Anesthetic"]="21835:153,43237:231",
		["Consumable.Weapon Buff.Poison.Crippling"]="3775:50",
		["Consumable.Weapon Buff.Poison.Deadly"]="2892:36,2893:52,8984:80,8985:108,20844:136,22053:144,22054:180,43232:244",
		["Consumable.Weapon Buff.Poison.Instant"]="6947:22,6949:34,6950:50,8926:76,8927:105,8928:130,21927:170,43230:245",
		["Consumable.Weapon Buff.Poison.Mind Numbing"]="5237:60",
		["Consumable.Weapon Buff.Poison.Wound"]="10918:17,10920:25,10921:38,10922:53,22055:112,43234:188,43235:231",
		["Consumable.Weapon Buff.Spellstone"]="41191:10,41192:20,41193:30,41194:40,36896:20",
		["Consumable.Weapon Buff.Stone.Sharpening Stone"]="23122,2862:2,2863:3,2871:4,7964:6,12404:8,18262,23528:12,23529:14",
		["Consumable.Weapon Buff.Stone.Weight Stone"]="3239:2,3240:3,3241:4,7965:6,12643:8,28420:12,28421",
	}

	local SOURCE_ITEM = 'itemset'
	SimpleSelfRebuff.SOURCE_ITEM = SOURCE_ITEM

	local ItemBuff = SimpleSelfRebuff.classes.BuffSource:new(SOURCE_ITEM, isUsableSetItem, getSetItemCooldown)
	LibStub("AceBucket-3.0"):Embed(ItemBuff)
	SimpleSelfRebuff.buffTypes.ItemBuff = ItemBuff

	function ItemBuff:OnEnable()
		if next(self.allBuffs) then
			self:RegisterBucketEvent('BAG_UPDATE', 0.5, 'FindBestItems')
			self:FindBestItems()
		end
	end

	function ItemBuff:OnBuffRegister(buff)
		local setName = buff.setName
		if not setName then
			err("setName is missing for ItemBuff %q", buff.name)
		end
		if PT3 == nil then
			PT3 = LibStub('LibPeriodicTable-3.1', true) or false
		end

		local itemids = new()
		local values = new()

		buff.itemids = itemids
		buff.found = true
		
		local setString = setStrings[setName]
		if not setString then
			err("Unknown item set %q for ItemBuff %q", setName, buff.name)
		end
		local pt3String = PT3 and PT3:GetSetString(setName)
		if pt3String then
			setString = setString .. ',' .. pt3String
		end
		
		local texture, minLevel
		for itemid, value in setString:gmatch("(%d+):(%d+)") do
			itemid = tonumber(itemid)
			if not values[itemid] then
				tinsert(itemids, itemid)
				values[itemid] = tonumber(value) or 1
				
				local itemMinLevel, _, _, _, _, itemTexture = select(5, GetItemInfo(itemid))
				texture = texture or itemTexture
				if type(itemMinLevel) == "number" then
					minLevel = minLevel and math.min(minLevel, itemMinLevel) or itemMinLevel
				end
			end
		end
		buff.texture = texture
		buff.minLevel = minLevel

		local function sorter(a,b)
			return values[a] > values[b]
		end
		table.sort(itemids, sorter)

		values = del(values)
	end

	function ItemBuff:FindBestItems()
		for buff in pairs(self.allBuffs) do
			local newItemid, newItemName
			for i,itemid in ipairs(buff.itemids) do
				if GetItemCount(itemid) > 0 then
					newItemid, newItemName = itemid, GetItemInfo(itemid)
					break
				end
			end
			if newItemid ~= buff.currentItemid then
				self:Debug("New item for %q: %q (%q)", buff.name, newItemid, itemName)
				buff.currentItemid = newItemid
				buff.currentItemName = newItemName
			end
		end
	end

	function ItemBuff:SetupSecureButton(buff, button)
		self:Debug('Setup %s using item %q', buff.name, buff.currentItemName)
		button:SetAttribute('*type*', 'item')
		button:SetAttribute('*item*', buff.currentItemName)
	end

	function ItemBuff:_IsBuffUsable(buff)
		return buff and buff.currentItemid and IsUsableItem(buff.currentItemid)
	end

	function ItemBuff:_GetBuffCooldown(buff)
		if buff and buff.currentItemid then
			return GetItemCooldown(buff.currentItemid)
		end
	end

	-------------------------------------------------------------------------------
	-- Items declaration
	-------------------------------------------------------------------------------

	SimpleSelfRebuff:RegisterBuffSetup(function(self, L)
		local class = select(2, UnitClass('player'))
		
		local function registerItems(categoryName)

			local category = self:GetCategory(categoryName)
			category.source = SOURCE_ITEM
			
			-- Stones
			if
				class == 'ROGUE'  or class == 'WARRIOR' or class == 'PALADIN' or
				class == 'SHAMAN' or class == 'DRUID'
			then
				category
					:add( L["Sharpening Stone"], 'setName', "Consumable.Weapon Buff.Stone.Sharpening Stone" )
					:add( L["Weight Stone"], 'setName', "Consumable.Weapon Buff.Stone.Weight Stone" )
			end

			-- Oils
			if
				class == 'WARLOCK' or class == 'DRUID'  or class == 'MAGE' or class == 'SHAMAN' or
				class == 'PALADIN' or class == 'PRIEST' or class == 'HUNTER'
			then

				-- Mana Oils
				category:add( L["Mana Oil"], 'setName', "Consumable.Weapon Buff.Oil.Mana" )

				-- Wizard Oils
				if class ~= 'HUNTER' then
					category:add( L["Wizard Oil"], 'setName', "Consumable.Weapon Buff.Oil.Wizard" )
				end

			end

			-- Rogue poisons
			if class == 'ROGUE' then
				local function addPoison(itemId, setName)
					local itemName = GetItemInfo(itemId) or (setName .. ' Poison')
					category:add( itemName, 'setName', 'Consumable.Weapon Buff.Poison.'..setName)
				end
				addPoison( 3775, 'Crippling' )
				addPoison( 6947, 'Instant' )
				addPoison( 5237, 'Mind Numbing' ) 
				addPoison( 2892, 'Deadly' )
				addPoison(10918, 'Wound' ) 
				addPoison(21835, 'Anesthetic' )
			end
			
			-- Warlock stones
			if class == 'WARLOCK' then
				category
					:add( GetItemInfo(41169) or 'Firestone', 'setName', "Consumable.Weapon Buff.Firestone" )
					:add( GetItemInfo(41191) or 'Spellstone', 'setName', "Consumable.Weapon Buff.Spellstone" )
			end

		end

		registerItems(self.CATEGORY_MAINHAND)
		registerItems(self.CATEGORY_OFFHAND)

	end)

end
