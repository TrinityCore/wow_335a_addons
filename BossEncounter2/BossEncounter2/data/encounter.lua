local Root = BossEncounter2;

Root.Encounter = { };

-- --------------------------------------------------------------------
-- **                            Data                                **
-- --------------------------------------------------------------------

-- This local table is granted to the currently operationnal encounter handling module through an API.
-- Other encounter modules will be denied its access until the currently operationnal encounter handling
-- module closes its transaction and release it.
-- This make sure only 1 encounter handling module is enabled at a time.

local free = true;
local currentEncounter = { };
local currentModule = nil;

local ENCOUNTER_COOLDOWN = GetTime() + 5.00;
local SPECIFIC_COOLDOWN = { };

-- --------------------------------------------------------------------
-- **                          Functions                             **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> Encounter -> CanOpen(module)                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> module: the module you are considering opening. Can be nil.   *
-- ********************************************************************
-- * Determinate if the encounter handler allows an encounter to be   *
-- * opened by an encounter handling module.                          *
-- * Return true or false.                                            *
-- * False means an encounter is already being handled.               *
-- ********************************************************************
function Root.Encounter.CanOpen(module)
    if ( not Root.enabled ) then return false; end
    if ( GetTime() < ENCOUNTER_COOLDOWN ) then return false; end
    if ( type(module) == "table" ) and ( module.GetName ) then
        if ( GetTime() < (SPECIFIC_COOLDOWN[module:GetName()] or -1) ) then
            return false;
        end
    end

    local localPlayer = UnitName("player");
    if Root.IsBlacklisted(localPlayer) then return false; end -- Piss off.

    return free;
end

-- ********************************************************************
-- * Root -> Encounter -> Open(module)                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> module: the module which asks to open an encounter.           *
-- ********************************************************************
-- * Open a new encounter if no encounter is currently running.       *
-- * This function will return the table that should be used by the   *
-- * encounter handling module to store the encounter's data.         *
-- * Nil means an encounter is already being handled and that the     *
-- * open request cannot be accepted for now.                         *
-- ********************************************************************
function Root.Encounter.Open(module)
    if type(module) ~= "table" then return nil; end
    if ( Root.Encounter.CanOpen(module) ) then
        free = false;
        currentModule = module;

        -- Populate the encounter data table with some environment data / basic variables
        currentEncounter.raidMode, currentEncounter.raidSize = Root.GetInstanceFormat();
        currentEncounter.globalTimer = 0;
        currentEncounter.triggerTime = GetTime();

        return currentEncounter;
  else
        return nil;
    end
end

-- ********************************************************************
-- * Root -> Encounter -> Release(encounterTable)                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- *   <none>                                                         *
-- ********************************************************************
-- * Use by the currently active encounter handling module to         *
-- * indicate the encounter handler that it has finished processing   *
-- * the encounter. The table that was given to the module with the   *
-- * Open API has to be given as parameter to the Release API as a    *
-- * security check and a clean up.                                   *
-- ********************************************************************
function Root.Encounter.Release(encounterTable)
    if not ( encounterTable == currentEncounter ) then
        return;
    end
    wipe(encounterTable);
    free = true;
    currentModule = nil;
    ENCOUNTER_COOLDOWN = GetTime() + 1.00;
end

-- ********************************************************************
-- * Root -> Encounter -> GetActiveModule()                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- *   <none>                                                         *
-- ********************************************************************
-- * Get the table object of the module which currently owns the      *
-- * encounter data table.                                            *
-- ********************************************************************
function Root.Encounter.GetActiveModule()
    if ( free ) then return nil; end
    return currentModule or nil;
end

-- ********************************************************************
-- * Root -> Encounter -> ForceCooldownOff()                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- *   <none>                                                         *
-- ********************************************************************
-- * Remove the currently active cooldown on opening modules.         *
-- * Useful for special modules, to make sure the user does not have  *
-- * to wait when he wants to open them.                              *
-- ********************************************************************
function Root.Encounter.ForceCooldownOff()
    ENCOUNTER_COOLDOWN = -1;
end

-- ********************************************************************
-- * Root -> Encounter -> PutSpecificCooldown(module, duration)       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> module: the module to put a cooldown for.                     *
-- * >> duration: duration of the specific cooldown.                  *
-- ********************************************************************
-- * Put a cooldown on a specific module, to prevent it from being    *
-- * (re)triggered too soon.                                          *
-- ********************************************************************
function Root.Encounter.PutSpecificCooldown(module, duration)
    if type(module) ~= "table" then return; end
    if ( not module.GetName ) then return; end
    SPECIFIC_COOLDOWN[module:GetName()] = GetTime() + duration;
end