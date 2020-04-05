local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Basic Encounter Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- When an NPC whose trigger is bound to the Basic Encounter module is selected,
-- we see if we can open a new encounter. If we can, we prepare basic widgets
-- such as boss bar and status frame.
-- No other widget is intended to be used for this module.

-- The handlers of this module are just mirrors from Shared handlers, which fit
-- for basic fights that do not involve complex timers, widgets and whatnot.

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "BasicEncounter";

-- The "extraTable" table that gets passed to the OnTrigger handler can contain fields expliciting the mechanisms of the BasicEncounter, thus rendering it not-so-basic:
-- Time fields are always in seconds.

-- FIELD                  |  POSSIBLE VALUES  |  DEFAULT  |  MEANING
-- ***********************|*******************|***********|*********************************************************************************************************************
-- timeOut                | [number]          | see below | The amount of time a boss must be unreachable (through a valid UID) before considering the encounter is a failure.
-- timeLimit              | [number]          | nil       | The amount of time before the boss goes berserk or the encounter becomes unfinishable.
-- music                  | [string]          | nil       | The theme that will be used for the encounter. See the music LUA file for a list of values.
-- preMusic               | [string]          | nil       | The theme that will be used before engaging the boss (= the preparation music).
-- title                  | [loc. table]      | nil       | A localisation table that contains the title of the encounter. If none is provided, the boss's name will be used.
-- ignoreCombatDelay      | false / true      | false     | Removes the pause that lasts until you get out of combat before showing the end sequence after a boss clear.
-- ignoreLeaveCombat      | false / true      | false     | When true, OnFailure handler is not fired when the mob gets out of combat mode.
-- ignoreWipe             | false / true      | false     | When true, OnFailure handler is not fired when all members of the raid are wiped out.
-- adds                   | {add1, add2, ...} | nil       | A list of known and invariant adds in the fight. Also add1, add2, ... must be the mobIDs.
-- ignoreAdds             | false / true      | false     | If false, adds will have to die to clear the fight (incl. the boss of course). If true, only boss death is needed.
-- ignoreAddsEngage       | false / true      | false     | If true, the boss fight will not be considered engaged when an add enters combat mode.
-- ignoreResults          | false / true      | false     | If true, no result sequence will be played upon an encounter clear, so no time/score display. :(
-- silentAddKills         | false / true      | false     | If true, no sound and no text will be played/displayed when an add is killed.
-- scoreBenchmark         | {*}               | nil       | Sets what can be considered a decent boss performance. See below.
-- clearSequence          | [string]          | nil       | The clear sequence that will be forcefully used if the boss is cleared. See the list below.
-- ignoreStandardClear    | flase / true      | false     | If true, OnCleared handler will not be fired when the boss (and its adds if there are any) dies.
-- clearTrigger           | [loc. table]      | nil       | If provided, the OnCleared handler will be fired when a yell message from this table is detected.
-- clearAnimation         | [string]          | "NORMAL"  | If provided, you can change the clear animation for the boss.
-- engageTrigger          | [loc. table]      | nil       | If provided, the OnEngaged handler will be fired when a yell message from this table is detected.
-- safeEngage             | false / true      | false     | If true, the boss will not engage until it targets a party or raid member even if it is in combat.
-- nullScore              | false / true      | false     | If true, the performance frame will not be displayed at the end of the fight.
-- wipeLockdown           | [number]          | 30 sec    | Sets the amount of time a boss module may not be retriggered after a wipe.
-- clearLockdown          | [number]          | 30 sec    | Sets the amount of time a boss module may not be retriggered after it has been cleared.

-- DEFAULT TIME-OUTS:
-- worldboss: 60s
-- elite: 30s
-- rareelite: 30s
-- rare: 30s
-- normal: 15s
-- default: 15s

-- *: The table must contain:
-- poorTime    : the time amount to kill the boss that will yield 0 pt in Speed criteria.
-- greatTime   : the time amount to kill the boss that will yield 100 pts in Speed criteria.
-- playerSlots : how many players can participate in the boss fight ? (optionnal in most cases)

-- POSSIBLE CLEAR SEQUENCES:
-- 1. "NORMAL"
-- 2. "MINI"
-- 3. "RAID"
-- 4. "FINAL"

-- POSSIBLE CLEAR ANIMATIONS:
-- 1. "NORMAL"
-- 2. "ALTERNATE"

-- In addition, BasicEncounter module is able to deploy some special widgets if the boss module asks for them in the "extraTable" table:

-- FIELD                  |  POSSIBLE VALUES  |  DEFAULT  |  MEANING
-- ***********************|*******************|***********|*********************************************************************************************************************
-- distanceChecker        | [number]          | nil       | Make the distance checker appear and lists all units that are closer than X yards.
-- healthThresholds       | {**}              | nil       | Display some indicators on the health bar telling what will happen when the boss gets below X% of health.

-- **: The table must be defined this way:
-- healthThresholds = {
--    { value = 0.85,
--      label = { ["default"] = "What is going to happen when the boss gets below 85% HP.",
--                ["frFR"] = "Ce qui va se produire quand le boss descendra en dessous de 85% PV.",
--      },
--    },
--    { value = 0.70,
--      label = { ["default"] = "What is going to happen when the boss gets below 70% HP.",
--                ["frFR"] = "Ce qui va se produire quand le boss descendra en dessous de 70% PV.",
--      },
--    },
--        etc.
-- }

-- --------------------------------------------------------------------
-- **                       Definition stuff                         **
-- --------------------------------------------------------------------

Root[THIS_MODULE] = {
    -- --------------------------------------------------------------------
    -- **                            Properties                          **
    -- --------------------------------------------------------------------

    running = false, -- Never set this to true.
    data = nil, -- Never set this.
    status = nil,

    -- --------------------------------------------------------------------
    -- **                             Handlers                           **
    -- --------------------------------------------------------------------

    OnStart = Shared.OnStart,

    OnTrigger = Shared.OnTrigger,

    OnFinish = Shared.OnFinish,

    OnEngaged = Shared.OnEngaged,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = Shared.OnCombatEvent,

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end