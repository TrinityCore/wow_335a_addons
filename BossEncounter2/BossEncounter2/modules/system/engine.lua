local Root = BossEncounter2;

local Engine = Root.GetOrNewModule("Engine");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A functionnal module which detects boss mobs nearby through WoW events
-- and fire the appropriate modules methods that will handle their encounter.

-- --------------------------------------------------------------------
-- **                           Methods                              **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Engine:StopAnyModule(atOnce)                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> atOnce: if set, the OnFinish handler will be used instead of  *
-- * the OnFailed one, causing an instant shutdown.                   *
-- ********************************************************************
-- * End the execution of any running module. This will cause the     *
-- * OnFailed handler of the affected module to be fired.             *
-- ********************************************************************

Engine.StopAnyModule = function(self, atOnce)
    local module = Root.Encounter.GetActiveModule();
    if type(module) ~= "table" then return; end

    local stopMethod = module.OnFailed or module.OnFinish;
    if ( atOnce ) then stopMethod = module.OnFinish; end
    if type(stopMethod) ~= "function" then return; end

    if ( stopMethod == module.OnFailed ) and ( module.status == "ENGAGED" ) then
        -- The stop method is the OnFailed handler and the boss was being fought. Consider we have wiped.
        stopMethod(module, true);
  else
        stopMethod(module);
    end
end

-- ********************************************************************
-- * Engine:TriggerSpecialModule(name, ...)                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the special module to start.                *
-- * >> ...: arguments to pass to the OnTrigger handler.              *
-- * Do not pass nil parameters, use false instead.                   *
-- ********************************************************************
-- * Allows you to trigger at once a special module, regardless of    *
-- * whether another module is currently running or not.              *
-- ********************************************************************

Engine.TriggerSpecialModule = function(self, name, ...)
    local specialModule = Root[name];
    if type(specialModule) ~= "table" then return; end
    if ( specialModule.running ) then return; end

    -- Force the opening of the special anchor edit module, by closing ANY running module and removing the module switch cooldown.
    Engine:StopAnyModule(true);
    Root.Music.Stop(); -- Make sure music is stopped.
    Root.Encounter.ForceCooldownOff();
    specialModule:OnTrigger(...);
end

-- ********************************************************************
-- * Engine:TriggerBossModule(name, uid[, extraTable])                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the boss module to start.                   *

-- * >> uid: UID of the unit considered as the boss.                  *
-- * >> extraTable: additionnal info table to be passed to the        *
-- * OnTrigger handler. Usually only used by generic BasicEncounter   *

-- * bosses.                                                          *
-- ********************************************************************
-- * Allows you to trigger a normal boss module.                      *
-- * It will silently fail if another module is running.              *
-- ********************************************************************

Engine.TriggerBossModule = function(self, name, uid, extraTable)
    local ok = Root.PopModuleFromRepository(name);

    if ( ok ) then

        -- Module successfully pushed into global table of BE2.

        Root[name]:OnTrigger(uid, extraTable);

    end
end


-- ********************************************************************
-- * Engine:GetNumSelections(guid)                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> guid: the GUID of the unit checked.                           *
-- ********************************************************************
-- * Return the number of raid / party members that target the unit.  *
-- * Return count, outOf, percentage.                                 *
-- ********************************************************************

Engine.GetNumSelections = function(self, guid)
    if ( not guid ) then return 0, 0, 0; end

    -- Get the max
    local outOf = GetNumRaidMembers() or 0;
    if ( outOf == 0 ) then outOf = GetNumPartyMembers() or 0; end
    outOf = math.max(1, outOf);

    -- Get the count
    local count = 0;
    local i, targetUID;
    local UID = Root.Table.Alloc();
    Root.Unit.EnumerateRaid(UID);

    for i=1, #UID do
        if UnitIsUnit("player", UID[i]) then
            targetUID = "target";
      else
            targetUID = UID[i].."target";
        end
        if ( UnitGUID(targetUID) == guid ) then count = count + 1; end
    end

    Root.Table.Recycle(UID);
    return count, outOf, count * 100 / outOf;
end

-- ********************************************************************
-- * Engine:IsValidBoss(uid, bypass)                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> guid: the UID of the unit checked.                            *
-- ********************************************************************
-- * Determinate if the given unit is a valid boss.                   *
-- * Return its boss module name if it is as well as extraTable and   *
-- * volatile flag. Return nil if not.                                *
-- ********************************************************************

Engine.IsValidBoss = function(self, uid)
    if ( uid ) then
        if ( UnitExists(uid) ) and ( UnitName(uid) ~= UNKNOWN ) then
            if ( UnitHealth(uid) > 1 ) and ( not UnitIsDeadOrGhost(uid) ) then
                local guid = UnitGUID(uid);
                local id = Root.Unit.GetMobID(guid);
                local triggerInfo = Root.NPCDatabase.GetTriggerInfo(id);

                if ( triggerInfo and triggerInfo.module ) then
                    -- Phat guy is a boss.
                    if ( triggerInfo.bypass ) or ( not UnitIsFriend("player", uid) ) then
                        return triggerInfo.module, triggerInfo.extraTable, triggerInfo.volatile;
                    end
                end
            end
        end
    end
    return nil, nil, nil;
end

-- ********************************************************************
-- * Engine:Test(npcID, uid)                                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> npcID: the ID of the NPC.                                     *
-- * >> uid: the UID that will be arbitrarily designed as "the boss". *
-- ********************************************************************
-- * Test a boss module. This method is designed to be used in        *
-- * conjunction with bosses that use the BasicEncounter module.      *
-- ********************************************************************

Engine.Test = function(self, npcID, uid)
    local triggerInfo = Root.NPCDatabase.GetTriggerInfo(npcID);
    if ( triggerInfo and triggerInfo.module ) then

        Root.TestModule(triggerInfo.module, true, uid, triggerInfo.extraTable);
    end
end

-- --------------------------------------------------------------------
-- **                           Handlers                             **
-- --------------------------------------------------------------------

Engine.OnTargetChanged = function(self)
    if not Root.Encounter.CanOpen() then return; end -- Pointless to check for a new encounter if another one is in progress.

    local module, extraTable, volatile = self:IsValidBoss("target");

    if ( module ) then
        -- We have selected an unit which is referenced to as a boss and we have the module that shall handle it.
        self:TriggerBossModule(module, "target", extraTable);
    end
end

Engine.OnUnitListUpdated = function(self)
    if not Root.Encounter.CanOpen() then return; end -- Pointless to check for a new encounter if another one is in progress.

    -- Browse the unit list

    local i, guid, name, uid;
    local module, extraTable, volatile;

    for i=1, Root.Unit.GetNumUID() do
        guid, name = Root.Unit.GetUID(i);
        uid = Root.Unit.GetUID(guid);

        module, extraTable, volatile = self:IsValidBoss(uid);

        if ( module ) then
            -- Phat guy is a boss. Trigger him at once, or when 20% of the raid has selected him.
            if ( volatile ) or ( select(3, self:GetNumSelections(guid)) >= 20.00 ) then

                self:TriggerBossModule(module, uid, extraTable);
            end
        end
    end
end

-- --------------------------------------------------------------------
-- **                          Easter egg                            **
-- --------------------------------------------------------------------
--
-- DynamicMacro hidden system
--
-- DM system allows an user to put placeholder text in his macros which
-- will be auto-completed when out of combat according to gear equipped etc.
--
-- Currently supported instructions:
-- > Core                            |
-- #START                            | start of the block that will contain the command previously defined.
-- #END                              | end of the block that will contain the command previously defined.
--                                   |
-- > Commands                        |
-- #USE [conditionnal] 1|2|3|4       | try to use one of the listed items. Items are listed with their itemID. Only create the command if the item is equipped.

--[[

Engine.nextDMCheck = 30;
Engine.OnUpdate = function(self, elapsed)
    self.nextDMCheck = max(0, self.nextDMCheck - elapsed);
    if self.nextDMCheck == 0 then
        self:DynamicMacroUpdate();
    end
end

Engine.DynamicMacroUpdate = function(self)
    Engine.nextDMCheck = 30;
    if ( InCombatLockdown() ) then return; end

    -- Query each macro, look for DM instructions, and complete the macro.
    local i, name, texture, body;
    for i=1, 54 do
        name, texture, body, localVar = GetMacroInfo(i);
        self:DynamicMacroProcess(i, body);
    end
end

Engine.DynamicMacroProcess = function(self, index, body)
    local changed = false;
    local newBody = "";

    local numLines = select('#', strsplit("\n", body));
    local i, line, newLine, command, conditionnal, args;
    for i=1, numLines do
        line = select(i, strsplit("\n", body));
        newLine, command, cmdText, args = self:DynamicMacroParse(line, command, cmdText, args);

        newBody = newBody..newLine;
        if ( i < numLines ) then newBody = newBody.."\n"; end

        if ( newLine ~= line ) then
            changed = true;
        end
    end

    if ( changed ) then
        EditMacro(index, nil, nil, newBody, 1);
    end
end

local currentArgs = { };
Engine.DynamicMacroParse = function(self, line, activeCommand, cmdText, activeArgs)
    local lineLow = string.lower(line);
    local s, e = string.find(lineLow, "#use ");

    if ( e ) then
        cmdText = line;
    end
end
]]
