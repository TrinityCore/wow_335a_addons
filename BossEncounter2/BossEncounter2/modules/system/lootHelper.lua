local Root = BossEncounter2;

local LootHelper = Root.GetOrNewModule("LootHelper");

local AdvancedOptions = Root.GetOrNewModule("AdvancedOptions");
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A functionnal module that manages loots in master loot mode.

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local CHECK_INTERVAL = 1.000;

-- The disenchant timer is the minimum timer before the disenchant command MAY be issued.

local disenchantTimer = {
    [0] = 10^9, -- May not disenchant
    [1] = 10^9, -- May not disenchant
    [2] =    0, -- Green
    [3] =   45, -- Blue
    [4] =   90, -- Purple
    [5] = 10^9, -- May not disenchant
    [6] = 10^9, -- May not disenchant
    [7] = 10^9, -- May not disenchant
};

LootHelper.lootOpened = false;
LootHelper.noEnchantWarning = false;
LootHelper.test = false;
LootHelper.blizzardLootBlocked = true;

LootHelper.seenLoots = { };

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * LootHelper:GetDisenchant()                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the enchanter to send the loots to.                          *
-- * The enchanter will be picked randomly.                           *
-- * Will return blank string if no enchanter is in the raid.         *
-- ********************************************************************
LootHelper.GetDisenchant = function(self)
    local validTable = Root.Table.Alloc();

    local i, name, uid;
    for i=1, LootHelper:GetNumEnchanters() do
        name = self:GetEnchanterName(i);
        uid = Root.Unit.GetUID(name);

        if ( uid ) and ( UnitInRaid(uid) or UnitInParty(uid) ) and ( UnitIsPlayer(uid) ) then
            tinsert(validTable, name);
        end
    end

    if ( #validTable == 0 ) then return ""; end

    local result = validTable[math.random(1, #validTable)];

    Root.Table.Recycle(validTable);

    return result;
end

-- ********************************************************************
-- * LootHelper:GetNumEnchanters()                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the number of known enchanters.                              *
-- ********************************************************************
LootHelper.GetNumEnchanters = function(self)
    return #self.enchanterDB;
end

-- ********************************************************************
-- * LootHelper:GetEnchanterName(index)                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> index: the index of the enchanter to get.                     *
-- ********************************************************************
-- * Get one enchanter from the enchanter list.                       *
-- ********************************************************************
LootHelper.GetEnchanterName = function(self, index)
    return self.enchanterDB[index];
end

-- ********************************************************************
-- * LootHelper:AddEnchanter(name)                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the enchanter.                              *
-- ********************************************************************
-- * Add an enchanter in the enchanter list.                          *
-- * Returns  1 if could be added.                                    *
-- * Returns  0 if already present.                                   *
-- * Returns -1 if target is invalid.                                 *
-- * A second return reminds the name of the operation's target.      *
-- ********************************************************************
LootHelper.AddEnchanter = function(self, name)
    name = self:RedirectName(name);
    if ( not name ) then return -1, ""; end

    local i;
    for i=1, self:GetNumEnchanters() do
        if ( self:GetEnchanterName(i) == name ) then
            return 0, name;
        end
    end
    tinsert(self.enchanterDB, name);
    return 1, name;
end

-- ********************************************************************
-- * LootHelper:RemoveEnchanter(index or name)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> index or name: the index or the name of the enchanter.        *
-- ********************************************************************
-- * Remove an enchanter from the loot list.                          *
-- * Returns  1 if could be removed.                                  *
-- * Returns  0 if not in the list.                                   *
-- * Returns -1 if target is invalid.                                 *
-- * A second return reminds the name of the operation's target.      *
-- ********************************************************************
LootHelper.RemoveEnchanter = function(self, index)
    if type(index) == "string" then
        index = self:RedirectName(index);
        if ( not index ) then return -1, ""; end

        local i;
        for i=self:GetNumEnchanters(), 1, -1 do
            if ( self:GetEnchanterName(i) == index ) then
                return self:RemoveEnchanter(i);
            end
        end
elseif type(index) == "number" then
        local name = self:GetEnchanterName(index);
        tremove(self.enchanterDB, index);
        return 1, name;
    end
    return 0, index;
end

-- ********************************************************************
-- * LootHelper:RedirectName(input)                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> input: the enchanter name input.                              *
-- * Can be the magic word "target".                                  *
-- ********************************************************************
-- * Automatically replace the magic word "target" by the name of     *
-- * your target. Elsewise returns the string unchanged.              *
-- * In case of invalid target, nil is returned.                      *
-- ********************************************************************
LootHelper.RedirectName = function(self, input)
    local magicWord = Root.Localise("Console-EnchantTargetMagicWord");
    if ( string.lower(input) == magicWord ) then
        if not UnitIsPlayer("target") then
            return nil;
      else
            local name = UnitName("target");
            return name;
        end
    end
    return input;
end

-- ********************************************************************
-- * LootHelper:GetLootStatus(itemLink, name)                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> itemLink: the item link of the loot distributed.              *
-- * >> name: the name of who should receive the loot.                *
-- ********************************************************************
-- * Determinate if it is reasonnable to give the loot to the given   *
-- * person. The system will try to determinate whenever possible     *
-- * a loot should not be given to a person.                          *
-- * Returns "OK", "CONFIRM", "UNUSABLE".                             *
-- ********************************************************************
LootHelper.GetLootStatus = function(self, itemLink, name)
    -- Query info from the item.

    local isEquippable = IsEquippableItem(itemLink);
    local itemRarity = select(3, GetItemInfo(itemLink));

    if ( itemRarity <= 2 ) then return "OK", itemRarity; end
    if ( not isEquippable ) then return "CONFIRM", itemRarity; end

    -- Try to get info from RaidMonitor if available

    if ( RaidMonitor ) then
        local A = RaidMonitor.Account;
        local current, max, fraction;

        max = A:GetHighestMerit();
        current = A:GetMerit("C:"..name);
        if ( max == 0 ) then
            fraction = 0;
      else
            fraction = current / max;
        end
        if ( fraction < 0.25 ) or ( current <= 15000 ) then
            return "MERIT", itemRarity;
        end
    end

    -- Query info from the potential wearer.

    local uid = Root.Unit.GetUID(name);
    local class = "UNKNOWN";
    if ( uid ) then
        class = select(2, UnitClass(uid));
  else
        return "INVALID", itemRarity;
    end

    -- OK, the big deal starts now.

    if ( not Root.ItemDatabase.IsProbablyUsable(itemLink, class) ) then
        return "UNUSABLE", itemRarity;
    end

    return "CONFIRM", itemRarity;
end

-- ********************************************************************
-- * LootHelper:Test(itemID)                                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> itemID: the item ID that will be used to test the system.     *
-- ********************************************************************
-- * Test the system on a loot.                                       *
-- ********************************************************************
LootHelper.Test = function(self, itemID)
    if ( itemID ) then
        local lootAssigner = Manager:GetFreeLootAssigner();
        if ( not lootAssigner ) then return; end

        lootAssigner:Start(itemID, true);
  else
        self.test = true;
    end
end

-- ********************************************************************
-- * LootHelper:GetDisenchantTimer(itemLink)                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> itemLink: the item link of the loot checked.                  *
-- ********************************************************************
-- * Determinate the amount of time remaining before authorizing the  *
-- * disenchanting of a loot.                                         *
-- ********************************************************************
LootHelper.GetDisenchantTimer = function(self, itemLink)
    local quality, max;
    quality = select(3, GetItemInfo(itemLink));
    max = disenchantTimer[quality];

    local seenTime = self.seenLoots[itemLink];
    if ( seenTime ) then
        return math.max(0, max + seenTime - GetTime()), math.max(1, max);
  else
        self.seenLoots[itemLink] = GetTime();
        return max, math.max(1, max);
    end
end

-- ********************************************************************
-- * LootHelper:IsLootAvailable()                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Determinate if loot is currently available for distribution.     *
-- ********************************************************************
LootHelper.IsLootAvailable = function(self)
    return self.lootOpened;
end

-- ********************************************************************
-- * LootHelper:HasMasterLoot()                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Return true if we have the master loot.                          *
-- ********************************************************************
LootHelper.HasMasterLoot = function(self)
    local lootMethod, masterLootPartyID, masterLootRaidID = GetLootMethod();
    local hasML = false;
    if ( lootMethod == "master" ) then
        if GetNumRaidMembers() > 0 and ( masterLootRaidID ) then
            if UnitIsUnit("raid"..masterLootRaidID, "player") then hasML = true; end
    elseif GetNumPartyMembers() > 0 and ( masterLootPartyID ) then
            if UnitIsUnit("party"..masterLootPartyID, "player") then hasML = true; end
        end
    end
    return hasML;
end

-- ********************************************************************
-- * LootHelper:TryLoot(lootID)                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> lootID: the ID of the loot we want to start assigning.        *
-- ********************************************************************
-- * Try to start a loot assigner for the given loot on the corpse.   *
-- *                                                                  *
-- * WARNING - This function cannot determinate if a loot can be      *
-- * assigned or not (exemple: badges cannot and it would be dumb to  *
-- * show an assigner frame for them)                                 *
-- *                                                                  *
-- * Returns true if an assigner was opened successfully.             *
-- * Returns false in all other cases. You should let Blizzard system *
-- * assign the loot if false is returned by this function.           *
-- ********************************************************************
LootHelper.TryLoot = function(self, lootID)
    if ( not self:IsLootAvailable() ) then return false; end
    if ( not LootHelper:HasMasterLoot() ) and ( not self.test ) then return false; end
    if ( not AdvancedOptions:GetSetting("UseLootHelper") ) then return false; end

    local lootIcon, lootName, lootQuantity, rarity, locked = GetLootSlotInfo(lootID);
    local itemLink = GetLootSlotLink(lootID);
    local assigner;

    if ( LootSlotIsItem(lootID) ) and ( not locked ) and ( rarity >= GetLootThreshold() or self.test ) then
        -- This loot is an item. We'll see if it is already being handled by a loot assigner.
        assigner = self:GetLootAssigner(itemLink);

        if ( not assigner ) then
            assigner = Manager:GetFreeLootAssigner();

            if ( assigner ) then
                assigner:Start(lootID, self.test);

                if ( not self.noEnchantWarning ) and ( self:GetNumEnchanters() == 0 ) then
                    self.noEnchantWarning = true;
                    Root.Print(Root.Localise("LA-NoEnchantExplain"), true);
                end

                return true;
            end
        end
    end
    return false;
end

-- ********************************************************************
-- * LootHelper:GetLootAssigner(itemLink)                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> itemLink: the item link to get the assigner of.               *
-- ********************************************************************
-- * Get the assigner used to handle a given loot.                    *
-- * Multiple instances of the same loot will be handled one by one:  *
-- * one assigner will pop-up to give the first instance, then once   *
-- * the instance is assigned, a second assigner will pop-up.         *
-- ********************************************************************
LootHelper.GetLootAssigner = function(self, itemLink)
    local assigner, i;
    for i=1, Manager:GetNumLootAssigners() do
        assigner = Manager:GetLootAssigner(i);
        if ( not assigner:IsFree() ) and ( assigner:GetLink() == itemLink ) then
            return assigner;
        end
    end
    return nil;
end

-- ********************************************************************
-- * LootHelper:UpdateAccess()                                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Enable/disable the events received by the loot system according  *
-- * to whether the system is enabled or not.                         *
-- ********************************************************************
LootHelper.UpdateAccess = function(self)
    self.enabled = AdvancedOptions:GetSetting("UseLootHelper");
    if ( self.enabled ) then
        LootFrame:UnregisterEvent("OPEN_MASTER_LOOT_LIST");
        LootFrame:UnregisterEvent("UPDATE_MASTER_LOOT_LIST");
  else
        LootFrame:RegisterEvent("OPEN_MASTER_LOOT_LIST");
        LootFrame:RegisterEvent("UPDATE_MASTER_LOOT_LIST");
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

LootHelper.OnStart = function(self)
    self.enchanterDB = Root.Save.Get("config", "enchanters", "active") or { };
    Root.Save.Set("config", "enchanters", self.enchanterDB, "active");

    self.enabled = false;
end

LootHelper.OnLootChange = function(self, event, ...)
    if ( event == "LOOT_OPENED" ) then
        self.lootOpened = true;
        self:UpdateAccess();
elseif ( event == "LOOT_CLOSED" ) then
        self.lootOpened = false;
    end
end

LootHelper.OnLootAssignBegin = function(self, ...)
    if ( not self.enabled ) then return; end

    local slot = LootFrame.selectedSlot;
    if ( not slot ) then return; end

    self.blizzardLootBlocked = self:TryLoot(slot);

    if ( not self.blizzardLootBlocked ) then
        LootFrame_OnEvent(LootFrame, "OPEN_MASTER_LOOT_LIST", ...);
    end
end

LootHelper.OnLootAssignUpdate = function(self, ...)
    if ( not self.enabled ) then return; end

    if ( not self.blizzardLootBlocked ) then
        LootFrame_OnEvent(LootFrame, "UPDATE_MASTER_LOOT_LIST", ...);
    end
end