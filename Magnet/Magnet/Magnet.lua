--[[

Last modified by eddie2 @ 2010-07-25T19:30:01Z

--]]
Magnet = LibStub("AceAddon-3.0"):NewAddon("Magnet", "AceConsole-3.0", "AceEvent-3.0","AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Magnet")
local TipHooker = LibStub:GetLibrary("LibTipHooker-1.1")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local PT = LibStub:GetLibrary("LibPeriodicTable-3.1")

local itemName
local item
local buttonMagnetize
local lootClosing = false

Magnet.constants = {
	qualilty = {
		POOR = 0,
		COMMON = 1,
		UNCOMMON = 2,
		RARE = 3,
		EPIC = 4,
		LEGENDARY = 5,
		ARTIFACT = 6
	},
	qualityOptions = {
	   none=L["Disabled"],
	   q0 = ITEM_QUALITY_COLORS[0].hex..ITEM_QUALITY0_DESC,
	   q1 = ITEM_QUALITY_COLORS[1].hex..ITEM_QUALITY1_DESC,
	   q2 = ITEM_QUALITY_COLORS[2].hex..ITEM_QUALITY2_DESC,
	   q3 = ITEM_QUALITY_COLORS[3].hex..ITEM_QUALITY3_DESC,
	   q4 = ITEM_QUALITY_COLORS[4].hex..ITEM_QUALITY4_DESC,
	   q5 = ITEM_QUALITY_COLORS[5].hex..ITEM_QUALITY5_DESC,
	   q6 = ITEM_QUALITY_COLORS[6].hex..ITEM_QUALITY6_DESC,
	},
	spells = {
		Prospecting = L["Prospecting"],
		Mining = L["Mining"],
		Gathering = L["Herb Gathering"],
		Disenchanting = L["Disenchant"],
		Milling = L["Milling"],
		Skinning = L["Skinning"],
		PickPocket = L["Pick Pocket"],
		Engineering = L["Engineering"],
	},
	difficulty = {
		TRIVIAL = 0,
		EASY = 1,
		MEDIUM = 2,
		OPTIMAL = 3,
		DIFFICULT = 4,
	},
}

--[[ Events
]]
function Magnet:OnInitialize()
	if ldb ~= nil then
		ldb:NewDataObject("Magnet", {
		 type = "launcher",
		 OnClick = function(clickedframe, button)
				InterfaceOptionsFrame:Hide()
				LibStub("AceConfigDialog-3.0"):SetDefaultSize("Magnet", 620, 660)
				LibStub("AceConfigDialog-3.0"):Open("Magnet")
		 end,
		 })
	end

	Magnet.isInParty = false
	Magnet.isInRaid = false
	Magnet.isProspecting = false
	Magnet.isMining = false
	Magnet.isGathering = false
	Magnet.isDisenchanting = false
	Magnet.isMilling = false
	Magnet.isSkinning = false
	Magnet.isPickPocketing = false
	Magnet.isEngineering = false
    Magnet.deleteAttract = "";
    Magnet.deleteRepel = "";

	local defaults = {
		char = {
			enabled = true,
			items = {},
			lootGold = true,
			lootQuest = false,
			lootQuality = { none = true },
			lootQualityRepel = { none = true },
			verbose = false,
			autoCloseLootWindow = false,
			autoClearList = true,
			attractFishLoot = true,
			attractGathering = true,
			attractProspecting = true,
			attractMining = true,
			attractDisenchant = true,
			attractMilling = true,
			attractSkinning = true,
			attractPickPocket = true,
			attractEngineering = true,
			attractReagents = false,
			autoConfirmBoP = false,
			showToolTipInfo = true,
			farmMode = false,
			reagentThreshold = Magnet.constants.difficulty.MEDIUM,
			skillList = {},
			party = {
			   lootQuality = { none = true },
			   lootQualityRepel = { none = true },
			},
			raid = {
			   lootQuality = { none = true },
			   lootQualityRepel = { none = true },
			},
			gold = 0,
			silver = 0,
			copper = 0,
			minimumPrice = false,
			useStackPrice = false,
            useSkillMode = false,
            creaturesSkinned = {}, -- Skinning
            creaturesMined = {}, -- Mining
            creaturesGathered = {}, -- Herbalism
            creaturesSalvaged = {}, -- Enigneering
		}
	}
	self.db = LibStub("AceDB-3.0"):New("MagnetDB", defaults, "Default")
    local _, englishClass = UnitClass("player")
	if englishClass ~= "ROGUE" then self.db.char.attractPickPocket = false end
	if self.CreateOptions then
		self:CreateOptions()
	end
	
	CreateFrame( "GameTooltip", "MagnetScanningTooltip" );
	MagnetScanningTooltip:SetOwner( WorldFrame, "ANCHOR_NONE" );
	MagnetScanningTooltip:AddFontStrings(
		MagnetScanningTooltip:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
		MagnetScanningTooltip:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" )
	);
	
end

function Magnet:OnEnable()
	self:RegisterEvent("LOOT_OPENED")
	self:RegisterEvent("LOOT_CLOSED")
	self:RegisterEvent("BAG_UPDATE") -- Inventory updates
	self:RegisterEvent("BAG_OPEN") -- Container opens (not the inventory!!)
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("TRADE_SKILL_UPDATE")
	if TipHooker ~= nil then TipHooker:Hook(self.ProcessTooltip, "item") end

    Magnet.cachedReagents = {}
	Magnet.lootedItems = {}
	self.db.char.enabled = true
	if PT then Magnet:UpdateIngredientsCache() end
	
	self:verbose(L["Magnet enabled"])
end

function Magnet:LOOT_OPENED()
	lootClosing = false
	if (lootClosing == false) then
		self:verbose(L["Handling loot window"])
		self:Update()
	end
end

function Magnet:LOOT_CLOSED()
	lootClosing = true
	self.isProspecting = false
	self.isMining = false
	self.isGathering = false
	self.isDisenchanting = false
	self.isSkinning = false
	self.isMilling = false
	self.isPickPocketing = false
	self.isEngineering = false
end

function Magnet:IsInTable(t, searchValue)
    local r = false
    for key, value in ipairs(t) do
        if value == searchValue then 
            r = true 
            break
        end
    end
    return r
end

function Magnet:UNIT_SPELLCAST_SUCCEEDED(event, unit, name, rank)
	if(unit ~= "player") then return end

	local spell = Magnet.constants.spells
	self.isProspecting = (name == spell.Prospecting)
	self.isMining = (name == spell.Mining)
	self.isGathering = (name == spell.Gathering)
	self.isDisenchanting = (name == spell.Disenchanting)
	self.isMilling = (name == spell.Milling)
	self.isSkinning = (name == spell.Skinning)
	self.isPickPocketing = (name == spell.PickPocket)
	self.isEngineering = (name == spell.Engineering)
    
    if(not self.db.char.useSkillMode) then return end
    
    local unitName = UnitName("target")
    if(unitName == nil) then return end
    if (self.isMining and not Magnet:IsInTable(self.db.char.creaturesMined, unitName)) then
        self:verbose(string.format(L["Creature %s can be mined, adding to the list"], unitName))
        table.insert(self.db.char.creaturesMined, unitName)
    elseif (self.isGathering and not Magnet:IsInTable(self.db.char.creaturesGathered, unitName)) then
        self:verbose(string.format(L["Creature %s can be gathered from, adding to the list"], unitName))
        table.insert(self.db.char.creaturesGathered, unitName)
    elseif (self.isSkinning and not Magnet:IsInTable(self.db.char.creaturesSkinned, unitName)) then
        self:verbose(string.format(L["Creature %s can be skinned, adding to the list"], unitName))
        table.insert(self.db.char.creaturesSkinned, unitName)
    elseif(self.isEngineering and not Magnet:IsInTable(self.db.char.creaturesSalvaged, unitName)) then
        self:verbose(string.format(L["Creature %s can be salvaged, adding to the list"], unitName))
        table.insert(self.db.char.creaturesSalvaged, unitName)
    end

    
end

function Magnet:PARTY_MEMBERS_CHANGED()
	Magnet.isInParty = (GetNumPartyMembers() > 0)
	Magnet.isInRaid = (GetNumRaidMembers() > 0)
end

function Magnet:BAG_UPDATE(event, containerID)
	if not self.db.char.farmMode then return end
	if #(Magnet.lootedItems) == 0 then return end
	self:CleanupBags()
end

function Magnet:BAG_OPEN(event, containerID)
end

function Magnet:OnProfileChanged()
	local enabled = self.db.char.enabled
	if enabled ~= self:IsEnabled() then
		if enabled then
			self:Enable()
		else
			self:Disable()
		end
	else
		if enabled then
			self:OnEnable()
		else
			self:OnDisable()
		end
	end
end

function Magnet:OnDisable()
	self:verbose(L["Magnet disabled"])
	self.db.char.enabled = false
	self:UnregisterAllEvents()
	if TipHooker ~= nil then TipHooker:Unhook(self.ProcessTooltip, "item") end
end


--[[ Helpers
]]
function Magnet:SetLootQuality(key, checked, use)
	-- Key "none" means disabled
	if (key == "none" and checked) then
			if(use == 's') then Magnet.db.char.lootQuality = {}
		elseif(use == 'p') then Magnet.db.char.party.lootQuality = {}
		elseif(use == 'r') then Magnet.db.char.raid.lootQuality = {}
		else
			Magnet:verbose(string.format("Error in function SetLootQuality. Excpected 'use' of 's', 'p' or 'r'. Got '%s'", use))
			return
		end
   end

	local table
	if(use == 's') then table = Magnet.db.char.lootQuality
   elseif(use == 'p') then table = Magnet.db.char.party.lootQuality
   elseif(use == 'r') then table = Magnet.db.char.raid.lootQuality
	else
		Magnet:verbose(string.format("Error in function SetLootQuality. Excpected 'use' of 's', 'p' or 'r'. Got '%s'", use))
		return
   end

   Magnet:UpdateList(key, checked, table)
end

function Magnet:SetLootQualityRepel(key, checked, use)
	-- Key "none" means disabled
	if (key == "none" and checked) then
			if(use == 's') then Magnet.db.char.lootQualityRepel = {}
		elseif(use == 'p') then Magnet.db.char.party.lootQualityRepel = {}
		elseif(use == 'r') then Magnet.db.char.raid.lootQualityRepel = {}
		else
			Magnet:verbose(string.format("Error in function SetLootQualityRepel. Excpected 'use' of 's', 'p' or 'r'. Got '%s'", use))
			return
		end
   end

	local table = {}
	if(use == 's') then table = Magnet.db.char.lootQualityRepel
   elseif(use == 'p') then table = Magnet.db.char.party.lootQualityRepel
   elseif(use == 'r') then table = Magnet.db.char.raid.lootQualityRepel
   else
   	Magnet:verbose(string.format("Error in function SetLootQualityRepel. Excpected 'use' of 's', 'p' or 'r'. Got '%s'", use))
   	return
   end

   Magnet:UpdateList(key, checked, table)
end

function Magnet:UpdateList(key, checked, table)

   table[key] = checked

   -- Check to see if anything is checked
   local i = 0
   for option, isChecked in pairs(table) do
      if(isChecked and option ~= "none") then i = i + 1 end
   end

   -- Nothing checked, enable the Disabled option
   if (i == 0) then
      table["none"] = true
   else
   	if(key ~= "none") then
	   	table["none"] = false
   	end
   end

end

function Magnet:LootItemInSlot(slot)
	local _, itemName, _, rarity, locked = GetLootSlotInfo(slot)
	if locked == 1 then 
		self:verbose(L["Item is locked. Can't loot."])
		return false
	end
	MagnetScanningTooltip:ClearLines()
	MagnetScanningTooltip:SetLootItem(slot)
    for i=1,MagnetScanningTooltip:NumLines() do
		local mytext = getglobal("MagnetScanningTooltipTextLeft"..i)
		if(mytext ~= nil) then
			local text = mytext:GetText()
			if(Magnet:trim(text) == Magnet:trim(ITEM_BIND_ON_PICKUP)) then
				bop = true
			end
		end

		if(bop or i > 5) then break end
	end

    if(bop) then 
		local one, iLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType = GetItemInfo(itemName)
		self:verbose(string.format(L["Item %s is Bind on Pickup"], iLink or itemName)) 
	end

	LootSlot(slot)
	if bop then
		if self.db.char.farmMode then
			StaticPopup_Hide("LOOT_BIND")
			StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
			ConfirmLootSlot(slot)
			return true
		end
		
		if self.db.char.autoConfirmBoP then
			StaticPopup_Hide("LOOT_BIND")
			StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
			ConfirmLootSlot(slot)
			return true
		else
			return false
		end
	end
	
	return true
end

function Magnet:getQualityDescription(quality)
		 if(quality == 0) then return ITEM_QUALITY_COLORS[quality].hex..ITEM_QUALITY0_DESC.."|r"
	elseif(quality == 1) then return ITEM_QUALITY_COLORS[quality].hex..ITEM_QUALITY1_DESC.."|r"
	elseif(quality == 2) then return ITEM_QUALITY_COLORS[quality].hex..ITEM_QUALITY2_DESC.."|r"
	elseif(quality == 3) then return ITEM_QUALITY_COLORS[quality].hex..ITEM_QUALITY3_DESC.."|r"
	elseif(quality == 4) then return ITEM_QUALITY_COLORS[quality].hex..ITEM_QUALITY4_DESC.."|r"
	elseif(quality == 5) then return ITEM_QUALITY_COLORS[quality].hex..ITEM_QUALITY5_DESC.."|r"
	elseif(quality == 6) then return ITEM_QUALITY_COLORS[quality].hex..ITEM_QUALITY6_DESC.."|r"
	end
end

function Magnet:tradeSkillDifficultyToNumber(difficulty)
	    if(difficulty == "trivial") then return Magnet.constants.difficulty.TRIVIAL
	elseif(difficulty == "easy") then return Magnet.constants.difficulty.EASY
	elseif(difficulty == "medium") then return Magnet.constants.difficulty.MEDIUM
	elseif(difficulty == "optimal") then return Magnet.constants.difficulty.OPTIMAL
	elseif(difficulty == "difficult") then return Magnet.constants.difficulty.DIFFICULT
	end
end

function Magnet.ProcessTooltip(tooltip, name, link)
	if not Magnet.db.char.showToolTipInfo then return end

	local found, _, itemString = string.find(link, "^|c%x+|H(.+)|h%[.+%]")
	local char = Magnet.db.char
	name = string.lower(name)

	if(found) then
		local sName, sLink, iQuality, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(itemString)
		local sQuality = "q"..iQuality

		-- Solo
		-- Attract by quality
		if(char.lootQuality[sQuality]) then
			tooltip:AddLine(L["Magnetized by quality (solo)"])
		end
		-- Repel by quality
		if(char.lootQualityRepel[sQuality]) then
			tooltip:AddLine(L["Repelled by quality (solo)"])
		end

		-- Party
		-- Attract by quality
		if(char.party.lootQuality[sQuality]) then
			tooltip:AddLine(L["Magnetized by quality (party)"])
		end
		-- Repel by quality
		if(char.party.lootQualityRepel[sQuality]) then
			tooltip:AddLine(L["Repelled by quality (party)"])
		end

		-- Raid
		-- Attract by quality
		if(char.raid.lootQuality[sQuality]) then
			tooltip:AddLine(L["Magnetized by quality (raid)"])
		end

		-- Repel by quality
		if(char.raid.lootQualityRepel[sQuality]) then
			tooltip:AddLine(L["Repelled by quality (raid)"])
		end

        -- Reagents information        
        if Magnet.cachedReagents[Magnet:GetItemID(link)] then
            tooltip:AddLine(
                string.format(L["Magnetized as a reagent for \n    %s"], 
                    table.concat(Magnet.cachedReagents[Magnet:GetItemID(link)], "\n    ")
                    )
                )    
        end
	end

	-- Specific items
	if(char.items[name] == true) then
		tooltip:AddLine(L["Magnetized"])
	elseif(char.items[name] == false) then
		tooltip:AddLine(L["Repelled"])
	end

	tooltip:Show()
end

function Magnet:verbose(...)
	if(Magnet.db.char.verbose) then
		Magnet:Print(...)
	end
end

--[[ Functions
]]
function Magnet:GetMinimumPrice()
	local gold, silver, copper
	gold = self.db.char.gold or 0
	silver = self.db.char.silver or 0
	copper = self.db.char.copper or 0
	return copper + (silver * 100) + (gold * 100 * 100)
end

function Magnet:Repel(itemLink, slotNumber)
   local _, itemName, _, itemRarity, locked = GetLootSlotInfo(slotNumber)
   local one, iLink, rarity, itemLevel, itemMinLevel, itemType, itemSubType = GetItemInfo(itemName)
   
   	if locked == 1 then
		self:verbose(L["Item is locked. Repelling..."])
		return true
	end

	-- Never repel fishing loot
	if(self.db.char.attractFishLoot and IsFishingLoot()) then return false end

	-- Never repel Gold
	-- TODO: Check money?
	if (LootSlotIsCoin(slotNumber)) then return false end
    
    if Magnet:ShouldRepel(itemLink or iLink, itemRarity) then
		local button
		if(getglobal("XLootButton"..slotNumber) ~= nil) then button = getglobal("XLootButton"..slotNumber)
		elseif(getglobal("ButsuSlot"..slotNumber) ~= nil) then button = getglobal("ButsuSlot"..slotNumber)
		else button = getglobal("LootButton"..slotNumber)
		end

		self:verbose(string.format(L["Repelling %s"], itemLink or iLink))
		
		if button ~= nil then button:SetAlpha(0.50) end
		
		return true
    end
   
   return false
end

function Magnet:Attract(itemLink, slotNumber)
   local _, itemName, _, rarity, locked = GetLootSlotInfo(slotNumber)   
   
    -- Attract gold 
   if LootSlotIsCoin(slotNumber) then  
		if (self.db.char.lootGold) then
			self:verbose(L["Attracting money"]..": "..string.gsub(itemName,"\n"," "))
		    LootSlot(slotNumber)
		    return true
		end
		return false
   end
   
   local one, iLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType = GetItemInfo(itemName)
   local _, _, _, _, _, _, _, itemStackCount, _, _, itemPrice = GetItemInfo(itemLink or iLink)
   local sQuality
   if(rarity ~= nil) then sQuality = "q"..rarity	end
   if(itemRarity ~= nil) then sQuality = "q"..itemRarity	end
   if (itemRarity == nil) then itemRarity = rarity end
   local iName = itemName
   local itemName = string.lower(itemName)
   local bop = false
   
   if (self.db.char.lootGold) then
		if(itemSubType == "Money" and
   			(	itemType == 0 -- Stonekeeper's Shard
   				or itemType == 80  -- Emblem of Heroism
				)
			) then
		    self:verbose(L["Attracting money"]..": "..string.gsub(itemName,"\n"," "))
		    LootSlot(slotNumber)
		    return true
		end
   end

    
  	if(itemSubType == "Money" and not(itemType == 0 or itemType == 80)) then
		self:verbose("Money: type="..itemType..", subtype="..itemSubType..", name="..itemName)
	end

    -- Attract fishingloot
	if(self.db.char.attractFishLoot and IsFishingLoot()) then
      self:verbose(L["Attracting fishingloot"]..": "..itemLink)
	  return self:LootItemInSlot(slotNumber)	  
	end

	-- Prospecting!
	if(self.db.char.attractProspecting and self.isProspecting) then
      self:verbose(L["Attracting prospected item"]..": "..itemLink)
      return self:LootItemInSlot(slotNumber)	  
	end

	-- Mining!
	if(self.db.char.attractMining and self.isMining) then
      self:verbose(L["Attracting mined item"]..": "..itemLink)
	  return self:LootItemInSlot(slotNumber)	  
	end

	-- Herb gathering!
	if(self.db.char.attractGathering and self.isGathering) then
      self:verbose(L["Attracting gathered item"]..": "..itemLink)
      return self:LootItemInSlot(slotNumber)	  
	end

	-- Disenchanting!
	if(self.db.char.attractDisenchant and self.isDisenchanting) then
      self:verbose(L["Attracting disenchanted item"]..": "..itemLink)
      return self:LootItemInSlot(slotNumber)	  
	end

	-- Milling!
	if(self.db.char.attractMilling and self.isMilling) then
      self:verbose(L["Attracting milled item"]..": "..itemLink)
      return self:LootItemInSlot(slotNumber)	  
	end

	-- Skinning!
	if(self.db.char.attractSkinning and self.isSkinning) then
      self:verbose(L["Attracting skinned item"]..": "..itemLink)
      return self:LootItemInSlot(slotNumber)	  
	end

	-- Pickpocketing!
	if(self.isPickPocketing and self.db.char.attractPickPocket) then
		self:verbose(L["Attracting pick pocketed item"]..": "..itemLink)
      return self:LootItemInSlot(slotNumber)	  
	end
	
	-- Engineering!
	if(self.isEngineering and self.db.char.attractEngineering) then
		self:verbose(string.format(L["Attracting salvaged item %s"], itemLink))
		return self:LootItemInSlot(slotNumber)	  
	end

	-- Attract quest items
	if (self.db.char.lootQuest and Magnet:IsQuestItem(itemName)) then 
		self:verbose(string.format(L["Attracting quest item %s"], itemLink))
		return self:LootItemInSlot(slotNumber)
   end

   -- Don't attract over loot threshold!
   if(self.isInParty or self.isInRaid) then
		local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
		if(lootmethod == "group" or lootmethod == "master" or lootmethod == "needbeforegreed") then
			local lootThreshold = GetLootThreshold()
			if(itemRarity ~= nil and tonumber(itemRarity) >= tonumber(lootThreshold)) then
				self:verbose("Skipping loot, it is at or over loot threshold (threshold: "..lootThreshold.."; item: "..itemRarity..")"..": "..itemLink)
				return false
			end
		end
	end
	
   -- Attract reagents
   if(self.db.char.attractReagents) then        
        if Magnet.cachedReagents[Magnet:GetItemID(itemLink)] then
            self:verbose(string.format(L["Attracting %s because it is a ingredient for %s"], itemLink, table.concat(Magnet.cachedReagents[Magnet:GetItemID(itemLink)], ", ")))
            return self:LootItemInSlot(slotNumber)	  
        end
   end
    
   -- Always attract in Battlefields?
   local status
   local inBattlefield
	for i=1, MAX_BATTLEFIELD_QUEUES do
		status =  GetBattlefieldStatus(i)
		if (status == "active") then
			inBattlefield = true
			break;
		end
	end

	if(inBattlefield) then
		self:verbose(L["Attracting item in battlefield"]..": "..itemLink)
		return self:LootItemInSlot(slotNumber)	  
	end

   local t
	local group

		 if(self.isInRaid) then
			t = self.db.char.raid.lootQuality
			group = L["raid"]
	elseif(self.isInParty) then
		 t = self.db.char.party.lootQuality
		 group = L["party"]
	else
		t = self.db.char.lootQuality
		group = L["solo"]
	end

	-- Attract items on quality
	if(t["none"] == false) then
		if t[sQuality] then
			self:verbose(L["Attracting item by quality"].." ("..group.."): "..itemLink)
			if(self.db.char.autoClearList == true and self.db.char.items[itemName] == true) then
				self:verbose(L["Auto removing from attract list"]..": "..itemLink)
				self.db.char.items[itemName] = nil
			end
			return self:LootItemInSlot(slotNumber)	  
		end
	end

	-- Check any remaining items
   if (self.db.char.items[itemName]) then
      self:verbose(L["Attracting"].." "..itemLink)
      return self:LootItemInSlot(slotNumber)	  
   end

   -- Check for minimum price
   if self.db.char.minimumPrice then
		local v = itemPrice
		if self.db.char.useStackPrice and itemStackCount > 1 then v = v * itemStackCount end
		if v ~= nil and v >= self:GetMinimumPrice() then
			self:verbose(L["Attracting"].." "..itemLink.." because vendor price is above minimum price.")
			return self:LootItemInSlot(slotNumber)	  
		end
	end

	return false
end

function Magnet:Update()
	local autoLootingSet = (GetCVar("autoLootDefault") == "1")
	local autoLootingOverride = (IsModifiedClick("AUTOLOOTTOGGLE") == 1)
    local tradeSkillLoot = self.db.char.useSkillMode and not (self.isMining or self.isGathering or self.isSkinning or self.isEngineering)
    tradeSkillLoot = tradeSkillLoot and Magnet:CanUseTradeSkillOnCreature(UnitName("target"))
	if autoLootingSet and not autoLootingOverride then
		Magnet:verbose(L["You have autoloot enabled and not used the autoloot modifer key. This will bypass Magnet."])
		return
	end
	if not autoLootingSet and autoLootingOverride then
		Magnet:verbose(L["You have chosen to autoloot using the modifier key. This will bypass Magnet."])
		return
	end
	
	local attracts, repels, total = 0, 0, GetNumLootItems()
	local link
	for i=1, total do
		link = GetLootSlotLink(i)
		local _, itemName = GetLootSlotInfo(i)
		if self.db.char.farmMode then
			if LootSlotIsCoin(i) then				
				if Magnet:LootItemInSlot(i) then
					self:verbose(string.format(L["Farm mode: Looting %s"], string.gsub(itemName,"\n"," ")))
				end
			else				
				if Magnet:LootItemInSlot(i) then
					self:verbose(string.format(L["Farm mode: Looting %s"], link or itemName))
					local found = false
					if link then
						for k, v in ipairs(Magnet.lootedItems) do 
							found = (v == Magnet:GetItemID(link))
							if found then break end
						end
						if not found then
							table.insert(Magnet.lootedItems, Magnet:GetItemID(link))
						end
					end
				end
			end
		else
            if tradeSkillLoot then
                if Magnet:LootItemInSlot(i) then
					self:verbose(string.format(L["Skillmode: looting %s"], link or itemName))
					local found = false
					if link then
						for k, v in ipairs(Magnet.lootedItems) do 
							found = (v == Magnet:GetItemID(link))
							if found then break end
						end
						if not found then
							table.insert(Magnet.lootedItems, Magnet:GetItemID(link))
						end
					end
				end
            else
                local button
                if(getglobal("XLootButton"..i) ~= nil) then button = getglobal("XLootButton"..i)
                elseif(getglobal("ButsuSlot"..i) ~= nil) then button = getglobal("ButsuSlot"..i)
                else button = getglobal("LootButton"..i)
                end
                if button ~= nil then button:SetAlpha(1.0) end

                -- Process Repel list first!
                    if (Magnet:Repel(link, i)) then repels = repels + 1
                elseif (Magnet:Attract(link, i)) then attracts = attracts + 1
                end
            end
		end
    end
 
	
	if(attracts + repels == total or total == 0) then
		if (Magnet.db.char.autoClose and not lootClosing and total == 0) then
			self:verbose(L["No items in lootwindow. Closing loot window."])
			lootClosing = true
			CloseLoot()
		elseif(Magnet.db.char.autoClose and not lootClosing and repels > 0) then
			self:verbose(L["No worthy items remaining. Closing loot window."])
			lootClosing = true
			CloseLoot()
		end
		--lootClosing = true
	else
		lootClosing = false
	end

end

function Magnet:ShouldRepel(itemLink, itemRarity)

	if itemLink == nil then return end
   local itemName, iLink, rarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, _, _, itemPrice = GetItemInfo(itemLink)--GetItemInfo(itemLink)
   local sQuality
   if(rarity ~= nil) then sQuality = "q"..rarity	end
   if(itemRarity ~= nil) then sQuality = "q"..itemRarity	end
   local iName = itemName
   local itemName = string.lower(itemName)

	-- Never repel Prospecting and Disenchanting loot
	if(self.isProspecting or self.isDisenchanting) then return false end

	-- Never repel Mining, Herb Gathering and Skinning loot
	if(self.isMining or self.isGathering) then return false end

	-- Never repel Milling and Skinning
	if(self.isMilling or self.isSkinning) then return false end

	if(self.isEngineering) then return false end
	
   -- Never repel in Battlefields?
   local status, mapName, instanceID, minlevel, maxlevel;
   local inBattlefield
	for i=1, MAX_BATTLEFIELD_QUEUES do
		status =  GetBattlefieldStatus(i)
		if (status == "active") then
			inBattlefield = true
			break
		end
	end

	if(inBattleField) then return false end

	-- Never repel if vendor value is above minimum price
	if self.db.char.minimumPrice  then
		local v = itemPrice				
		if self.db.char.useStackPrice and itemStackCount > 1 then v = v * itemStackCount end		
		if v ~= nil and v >= self:GetMinimumPrice() then
			return false
		end
	end

	-- Never repel when pickpocketing
	if(self.isPickPocketing and self.db.char.attractPickPocket) then return false end

	-- Never repel quest items
	if self.db.char.lootQuest and Magnet:IsQuestItem(itemName)
		then return false end
		
	local t
	local group

		 if(self.isInRaid) then
			t = self.db.char.raid.lootQualityRepel
			group = L["raid"]
	elseif(self.isInParty) then
		 t = self.db.char.party.lootQualityRepel
		 group = L["party"]
	else
		t = self.db.char.lootQualityRepel
		group = L["solo"]
	end

	-- Repel items on quality
	if(t["none"] == false) and t[sQuality] then
		if(self.db.char.autoClearList == true and self.db.char.items[itemName] == false) then
            self:verbose(L["Auto removing from repel list"]..": "..itemLink)
         	self.db.char.items[itemName] = nil
      	end
		return true
	end

	-- Check any remaining items
	if (self.db.char.items[itemName] == false) then
		return true
	end

	return false
	
end

function Magnet:CanUseTradeSkillOnCreature(unitName)
    if(unitName == nil) then return end
    
    local c = self.db.char

    return (Magnet:IsInTable(c.creaturesMined, unitName)
        or Magnet:IsInTable(c.creaturesGathered, unitName)
        or Magnet:IsInTable(c.creaturesSkinned, unitName)
        or Magnet:IsInTable(c.creaturesSalvaged, unitName))
end

function Magnet:CleanupBags()
	if not self.db.char.farmMode then return end
	if #(Magnet.lootedItems) == 0 then return end
	
	for bag = 0, NUM_BAG_SLOTS do
		for slot=1, GetContainerNumSlots(bag) do
			local _, _, _, _, _, _, link = GetContainerItemInfo(bag, slot)
			if (link ~= nil) then
				local found = false
				local pos = 0
				for pos = #(Magnet.lootedItems), 1, -1 do
					if Magnet:GetItemID(link) == Magnet.lootedItems[pos] then 
						found = true
						break
					end
				end
				if found then
					local _, _, rarity, _, _, _, _ = GetItemInfo(link)
					if self:ShouldRepel(link, rarity) then
						self:verbose(string.format(L["Farm mode: Destroying %s"], link))
						PickupContainerItem(bag, slot)
						DeleteCursorItem()
						table.remove(Magnet.lootedItems, pos)
					end
				end
				
			end
		end
	end
end
 
function PT:ItemSearch(item, searchSet)
	local matches = {}
	for k, s in pairs(PT:GetSetTable(searchSet)) do
	    if type(s) == "table" then
	        for m, l in pairs(s) do
	            local _, set = PT:ItemInSet(item, l)
                if set then
                    local have
                    for _,v in ipairs(matches) do
                        if v == set then
                            have = true
                        end
                    end
                    if not have then
                        table.insert(matches, set)
                    end
                end
	        end	    
	    else
            local _, set = PT:ItemInSet(item, s)
            if set then
                local have
                for _,v in ipairs(matches) do
                    if v == set then
                        have = true
                    end
                end
                if not have then
                    table.insert(matches, set)
                end
            end
        end    
	end
	if #matches > 0 then
		return matches
	end
end

function Magnet:TRADE_SKILL_UPDATE()
	local tsLink = GetTradeSkillListLink()
	
	-- "Mining", or rather "Smelting", does not have a TradeSkillListLink. Why not?
	if not tsLink then return end
	
	local playerGUID = UnitGUID("player")
	local playerID = string.sub(playerGUID, 4)
	local tsPlayerID = string.match(tsLink, ".*:(.+):.*$")
	
	-- Only cache the players skill
	if playerID ~= tsPlayerID then return end
	
    local sName, sCurrentLevel, sMaxLevel = GetTradeSkillLine()
    local skillUp = false
    local newSkill = false
    local skill = Magnet.db.char.skillList[sName]
    
    if not skill then
        newSkill = true
        skill = {
            ["currentLevel"] = sCurrentLevel,
            ["maximumLevel"]  = sMaxLevel,
            ["items"] = {},
        }
		Magnet.db.char.skillList[sName] = skill
    else
        if tonumber(sCurrentLevel) > tonumber(skill.currentLevel) then skillUp = true else skillUp = false end
        skill["currentLevel"] = sCurrentLevel
        skill["maximumLevel"]  = sMaxLevel
    end
    
    -- Check for new items to create
    local total = 0
    for i = 0, GetNumTradeSkills() do
        local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(i)
        if(skillName and skillType ~= "header") then total = total + 1 end
 	end	
 	
 	local totalSaved = 0
 	for k, v in pairs(skill.items) do
        totalSaved = totalSaved + 1
 	end	
 	-- Pretent we have a new skill so the cache gets updated
 	if total > totalSaved then newSkill = true end
 	
    --[[
        If we've never come across this skill before (newSkill == true)
            or (the current level of the skill is divisible by 5
                and we've just skilled up)
            then we need to update the cache.
            
        For code clarity, the above is negated, so we can exit the function here.
    --]]
    if not (newSkill or (tonumber(sCurrentLevel) % 5 == 0 and skillUp)) then
    	self:verbose(string.format("Not skilled-up or %s is not divisible by 5", sCurrentLevel))
        return
    end
    
    for i = 0, GetNumTradeSkills() do
        local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(i)
        if(skillName and skillType ~= "header") then
            local itemLink = GetTradeSkillItemLink(i)
			
            if not skill.items[skillName] then
				local new = {                
					["item"] = itemLink,
					["difficulty"] = Magnet:tradeSkillDifficultyToNumber(skillType),
				}
				skill.items[skillName] = new
			else
				skill.items[skillName].item = itemLink
				skill.items[skillName].difficulty = Magnet:tradeSkillDifficultyToNumber(skillType)
			end
        end    
    end
    
    if (PT) then Magnet:UpdateIngredientsCache() end
end

function Magnet:GetIngredients(item)
    local na, li = GetItemInfo(item)
    if not li then li = item end
    
    local sets = PT:ItemSearch(li, "TradeskillResultMats.Forward")
    if not sets then return end
    
    -- Iterate all sets that contains the item
    for k, setName in ipairs(sets) do
        if setName then
            -- Iterate all the ingredients in the set
            for it, value, se in PT:IterateSet(setName) do
                -- Check to see if the item in the set is the same as the item we're looking for
                if it ==  Magnet:GetItemID(li) or it ==  -1 * Magnet:GetItemID(li) then
                    -- Iterate all the ingredients in the setitem. It is in the format: <itemid>x<count>
                    for m, i, count in string.gmatch(value, "(%-?)(%d+)x?(%d+);?") do
                        i = tonumber(i)
                        local n, l = GetItemInfo(i)
                        if l then
                            local q = Magnet.cachedReagents[i]
                            if not q then
                                q = {}	
                                Magnet.cachedReagents[i] = q		            
                            end
                            
                            -- Check if the item is already in the cache
                            local t = false
                            for x, y in ipairs(q) do
                                if Magnet:GetItemID(y) == Magnet:GetItemID(li) then 
                                    t = true 
                                    break
                                end
                            end
                            
                            if not t then 
                                table.insert(q,li) 
                                -- Recursive function
                                -- Get the ingredients for the ingredient.
                                -- Example: Imbued Frostweave Cloth -> Infinite dust + Bolt of Frostweave
                                --      Bolt of Frostweave -> Frostweave Cloth
                                Magnet:GetIngredients(li)
                            end    
                        end
                    end  -- for ingredients
               end -- if item check
            end -- for items in set
        end -- if setname check
    end -- for setnames
end

-- Function ripped from Periodic Table
function Magnet:GetItemID(item)
	-- accepts either an item string ie "item:12345:0:0:0:2342:123324:12:1", hyperlink, or an itemid.
	-- returns a number'ified itemid.
	return (item == nil and 0) or tonumber(item) or tonumber(item:match("item:(%d+)")) or (((item:match("enchant:(%d+)") or item:match("spell:(%d+)")) or 0))
end

function Magnet:UpdateIngredientsCacheSkill(skill, reagentThreshold)
    local sk = Magnet.db.char.skillList[skill]
    if not reagentThreshold then reagentThreshold = Magnet.db.char.reagentThreshold end
    if not sk then return end
    local items = sk.items
    if not items then return end
    local itemsToRemove = {}
    for s, result in pairs(items) do
    --[[ 
        s -> "Smelt Tin", result => {
                    ["item"] = "|cffffffff|Hitem:3576:0:0:0:0:0:0:0:43|h[Tin Bar]|h|r",
                    ["difficulty"] = 0,
                }   
    ]]
        if result.difficulty ~= nil then
        	if	result.difficulty >= reagentThreshold then -- Need to autoloot ingredients for this skill
            	Magnet:GetIngredients(result.item)
	        end	
        end    
    end
end

function Magnet:UpdateIngredientsCache()
    if(PT) then
	    -- Construct cache table of ingredients
	    self:verbose("Constructing ingredients cache...")
	    Magnet.cachedReagents = {}
	    if Magnet.db.char.attractReagents then 
			local listSkills = Magnet.db.char.skillList
			local reagentThreshold = Magnet.db.char.reagentThreshold
			if not listSkills then
				listSkills = {} 
			end
			
			for key, skill in pairs(listSkills) do 
				Magnet:UpdateIngredientsCacheSkill(key, reagentThreshold)
			end
		end
							
		if(Magnet.db.char.verbose) then
			for key, value in pairs(Magnet.cachedReagents) do
				iName, iLink = GetItemInfo(key)
				self:verbose(iLink, " is used in ", table.concat(value, ","))
			end
		end

        self:verbose("Done constructing ingredients cache!")
	--[[

	Tradeskill.Crafted.First Aid -> item: Heavy Frostweave Bandage, value=skill: 400 (learnable @ 400?)
	TradeskillResultMats.Forward.First Aid -> item: Heavy Frostweave Bandage, value=table,item:2 x Frostweave Cloth
	TradeskillResultMats.Reverse.First Aid -> item: Frostweave Cloth, value=table,item: Heavy Frostweave Bandage (x2)
	TradeskillLevels.First Aid -> item: Heavy Frostweave Bandage, value=levelrange: orange/yellow/green/gray

	]]
	--[[
		local name, link = GetItemInfo("Netherweave Cloth")
		--local set = PT:ItemSearch(link, "Tradeskill.Recipe")
		local n, set = PT:ItemInSet(link, "TradeskillResultMats.Reverse.First Aid")
		--self:verbose(PT:GetSetString(set))
		--self:verbose(n,set)
		--for itemId, setname in pairs(set) do
			--for item, value, sett in PT:IterateSet("TradeskillResultMats.Forward.First Aid") do
			for item, value, sett in PT:IterateSet("TradeskillLevels.First Aid") do
				local n, l = GetItemInfo(item)
				--self:verbose(l, value, type(value))
				if type(value) == "string" then
					local it = 1
					local s = ""
					for  orange, yellow, green, gray in string.gmatch(value, "(.+)/(.+)/(.+)/(.+)") do
						if it == 1 then s = "Orange @ "..orange end
						if it == 1 then s = s..", Yellow @ " ..yellow end
						if it == 1 then s = s..", Green @ " ..green end
						if it == 1 then s = s..", Gray @ " ..gray end
						--it = it + 1
					end
					if l ~= nil then self:verbose(l, s) end
				end
				--local n, l = GetItemInfo(item)
				--self:verbose(l, value, type(value))
				if l ~= nil and type(value) == "string" then
					local s = ""
					for i, count in string.gmatch(value, "(%d+)x?(%d+);?") do --> TradeskillResultMats Heavy Frostweave Bandage need 2 Frostweave Cloth
						iName, iLink = GetItemInfo(tonumber(i))
						if iLink ~= nil then
							if s ~= "" then s = s.."and" end
							s = s..l.." needs "..(count or 1).." "..iLink
						end
					end
					if s ~= "" then self:verbose(s) end
				end
			end


			--iName, iLink = GetItemInfo(itemId)
			--self:verbose(link, " reagent for ", iLink)
		--end]]
	end
end

function Magnet:IsQuestItem(itemName)
	local numQuestEntries, numQuests = GetNumQuestLogEntries()
	for questIndex = 1, numQuestEntries do
		local questLink = GetQuestLink(questIndex)
		if(questLink ~= nil) then
			local found, _, questid = string.find(questLink, "^|c%x.+|Hquest:(.+):.+|h.+|r")
			local numQuestLogLeaderBoards = GetNumQuestLeaderBoards(questIndex)
			for questItems = 1, numQuestLogLeaderBoards do
				local leaderboardTxt, questItemType, isDone = GetQuestLogLeaderBoard (questItems, questIndex);
				if(questItemType == "item" and leaderboardTxt ~= nil and isDone ~= 1) then
					local _, _, questItemName, questItemNumItems, questItemNumNeeded = string.find(leaderboardTxt, "(.*):%s*([%d]+)%s*/%s*([%d]+)")
					local name = string.lower(questItemName)
					if name == string.lower(itemName) then return true end
				end
			end
		end
	end
	
	return false
end

-- remove trailing and leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
function Magnet:trim(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
