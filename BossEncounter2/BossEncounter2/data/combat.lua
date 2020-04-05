local Root = BossEncounter2;

Root.Combat = Root.GetOrNewModule("Combat");

-- --------------------------------------------------------------------
-- **                         Combat data                            **
-- --------------------------------------------------------------------

local callbacks = { };

local SCHOOL_MASK_NONE	        = 0x00;
local SCHOOL_MASK_PHYSICAL	= 0x01;
local SCHOOL_MASK_HOLY	        = 0x02;
local SCHOOL_MASK_FIRE	        = 0x04;
local SCHOOL_MASK_NATURE	= 0x08;
local SCHOOL_MASK_FROST	        = 0x10;
local SCHOOL_MASK_SHADOW	= 0x20;
local SCHOOL_MASK_ARCANE	= 0x40;

local SPELL_POWER_MANA = 0;
local SPELL_POWER_RAGE = 1;
local SPELL_POWER_FOCUS = 2;
local SPELL_POWER_ENERGY = 3;
local SPELL_POWER_HAPPINESS = 4;
local SPELL_POWER_RUNES = 5;
local SPELL_POWER_RUNIC_POWER = 6;

-- ===========================================================
-- Possible events (in uppercase) with given additionnal data:
-- ===========================================================
-- DAMAGE: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overdamage, school, special, resisted, blocked, absorbed
-- MISS: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, missType, amountMissed, school
-- HEAL: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overheal, school, special, absorbed
-- ENERGIZE: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, powerType, school
-- DRAIN: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, powerType, school, gainedAmount
-- INTERRUPT: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, interruptedSpellId, interruptedSpellName, interruptedSchool
-- INSTAKILL: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school

-- KILL: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags
-- DEATH: guid, name, flags, subType

-- CAST_START: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school
-- CAST_SUCCESS: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school
-- SUMMON: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school

-- EFFECT_RESIST: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, meanSpellId, meanSpellName, meanSchool
-- EFFECT_DISPEL: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, meanSpellId, meanSpellName, meanSchool, effectType
-- EFFECT_STOLEN: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, meanSpellId, meanSpellName, meanSchool, effectType
-- EFFECT_BROKEN: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, meanSpellId, meanSpellName, meanSchool, effectType
-- EFFECT_GAIN: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount
-- EFFECT_FADE: actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount

-- ===============================
-- Special fields possible values:
-- ===============================
-- class = { "MELEE", "RANGED", "SPELL", "DAMAGESHIELD", "DAMAGESPLIT", "ENVIRONMENT" }
-- special = { "CRITICAL", "CRUSHING", "GLANCING" }
-- subType = { "DEATH", "DESTRUCTION" }
-- effectType = { "BUFF", "DEBUFF" }

-- --------------------------------------------------------------------
-- **                        Combat functions                        **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> Combat -> RegisterCallback(func[, table])                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> func: the function or method to call.                         *
-- * Can also be a table containing functions whose indexes are the   *
-- * names of all wanted events to be processed.                      *
-- * >> table: in case func is a method, table points to the object   *
-- * that owns it.                                                    *
-- ********************************************************************
-- * Adds a combat callback to the callback list.                     *
-- ********************************************************************

function Root.Combat.RegisterCallback(func, table)
    if type(func) ~= "function" and type(func) ~= "table" then return; end
    if type(table) == "table" then
        callbacks[#callbacks+1] = {func = func, table = table};
  else
        callbacks[#callbacks+1] = func;
    end
end

-- ********************************************************************
-- * Root -> Combat -> FireCallbacks(event, ...)                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> event: the combat event type.                                 *
-- * >> ...: the additionnal infos related to the event.              *
-- ********************************************************************
-- * Notifies all currently registered callbacks of a combat event.   *
-- ********************************************************************

function Root.Combat.FireCallbacks(event, ...)
    local i, callback;
    for i=1, #callbacks do
        callback = callbacks[i];

        -- Simple procedural way.
        if type(callback) == "function" then
            callback(event, ...);

    elseif type(callback) == "table" then
            -- Method and object-oriented way.
            if type(callback.func) == "function" then
                callback.func(callback.table, event, ...);

        elseif type(callback.func) == "table" then
                -- Object-oriented and one handler per event way.
                local callbackHandler = callback.func[event];
                if type(callbackHandler) == "function" then
                    callbackHandler(callback.table, ...);
                end
            end
        end
    end
end

-- ********************************************************************
-- * Root -> Combat -> HasSchool(schoolBitTable, schoolMask)          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> schoolBitTable: the big bit table containing school data.     *
-- * >> schoolMask: the school being checked.                         *
-- ********************************************************************
-- * Check if a school is in the given school bit table.              *
-- ********************************************************************

function Root.Combat.HasSchool(schoolBitTable, schoolMask)
    if not ( schoolMask ) then
        return nil;
  else
        return ( bit.band(schoolBitTable, schoolMask) ) > 0;
    end
end

-- ********************************************************************
-- * Root -> Combat -> GetSpecial(critical, glancing, crushing)       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> critical: whether it's a critical or not.                     *
-- * >> glancing: whether it's a glancing hit or not.                 *
-- * >> crushing: whether it's a crushing or not.                     *
-- ********************************************************************
-- * Converts the 3 separate values of crit/glancing/crushing to a    *
-- * single uppercase string, since each outcome is exclusive.        *
-- * Can return "CRITICAL" or "CRUSHING" or "GLANCING" or "NORMAL".   *
-- ********************************************************************

function Root.Combat.GetSpecial(critical, glancing, crushing)
    if critical then return "CRITICAL"; end
    if crushing then return "CRUSHING"; end
    if glancing then return "GLANCING"; end
    return "NORMAL";
end

-- --------------------------------------------------------------------
-- **                        Combat handlers                         **
-- --------------------------------------------------------------------

function Root.Combat.OnCombatEvent(self, ...)
    local timestamp, event, sGUID, sName, sFlags, tGUID, tName, tFlags = select(1, ...);

    local spellId, spellName, spellSchool;
    local extraSpellId, extraSpellName, extraSpellSchool;
    local amount, overdamage, school, resisted, blocked, absorbed, critical, glancing, crushing, overhealing;
    local missType, amountMissed;
    local auraType;
    local extraAmount;
    local powerType;
    local special = "NORMAL";

    -- Special note: we want full absorb events to be treated as normal damage events.

    if ( event == "PARTY_KILL" ) then

        Root.Combat.FireCallbacks("KILL", sGUID, sName, sFlags, tGUID, tName, tFlags);

elseif ( event == "UNIT_DIED" or event == "UNIT_DESTROYED" ) then
        if ( event == "UNIT_DIED" ) then
            Root.Combat.FireCallbacks("DEATH", tGUID, tName, tFlags, "DEATH");
      else
            Root.Combat.FireCallbacks("DEATH", tGUID, tName, tFlags, "DESTRUCTION");
        end
elseif ( event == "ENCHANT_APPLIED" ) then
        return;	
elseif ( event == "ENCHANT_REMOVED" ) then
        return;
    end

    if ( event == "SWING_DAMAGE" ) then 
        amount, overdamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(9, ...);
        special = Root.Combat.GetSpecial(critical, glancing, crushing);

        Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "MELEE", nil, nil, false, amount, overdamage, school, special, resisted, blocked, absorbed);

    elseif ( event == "SWING_MISSED" ) then
        missType, amountMissed = select(9, ...);

        if ( missType == "ABSORB" ) then 
            Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "MELEE", nil, nil, false, 0, 0, SCHOOL_MASK_PHYSICAL, special, 0, 0, amountMissed);
      else
            Root.Combat.FireCallbacks("MISS", sGUID, sName, sFlags, tGUID, tName, tFlags, "MELEE", nil, nil, false, missType, amountMissed, SCHOOL_MASK_PHYSICAL);
        end
    end

    if ( event == "RANGE_DAMAGE" ) then 
        spellId, spellName, spellSchool = select(9, ...);
        amount, overdamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...);
        special = Root.Combat.GetSpecial(critical, glancing, crushing);

        Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "RANGED", spellId, spellName, false, amount, overdamage, school, special, resisted, blocked, absorbed);

 elseif ( event == "RANGE_MISSED" ) then 
        spellId, spellName, spellSchool = select(9, ...);
        missType, amountMissed = select(12, ...);

        if ( missType == "ABSORB" ) then 
            Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "RANGED", spellId, spellName, false, 0, 0, spellSchool, special, 0, 0, amountMissed);
      else
            Root.Combat.FireCallbacks("MISS", sGUID, sName, sFlags, tGUID, tName, tFlags, "RANGED", spellId, spellName, false, missType, amountMissed, spellSchool);
        end
    end

    if ( event == "DAMAGE_SHIELD" ) then
        spellId, spellName, spellSchool = select(9, ...);
        amount, overdamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...);
        special = Root.Combat.GetSpecial(critical, glancing, crushing);

        Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "DAMAGESHIELD", spellId, spellName, false, amount, overdamage, school, special, resisted, blocked, absorbed);

 elseif ( event == "DAMAGE_SHIELD_MISSED" ) then 
        spellId, spellName, spellSchool = select(9, ...);
        missType, amountMissed = select(12, ...);

        if ( missType == "ABSORB" ) then 
            Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "DAMAGESHIELD", spellId, spellName, false, 0, 0, spellSchool, special, 0, 0, amountMissed);
      else
            Root.Combat.FireCallbacks("MISS", sGUID, sName, sFlags, tGUID, tName, tFlags, "DAMAGESHIELD", spellId, spellName, false, missType, amountMissed, spellSchool);
        end
    end

    if ( event == "ENVIRONMENTAL_DAMAGE" ) then
        amount, overdamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(10, ...);
        special = Root.Combat.GetSpecial(critical, glancing, crushing);

        Root.Combat.FireCallbacks("DAMAGE", nil, nil, nil, tGUID, tName, tFlags, "ENVIRONMENT", nil, nil, false, amount, overdamage, school, special, resisted, blocked, absorbed);
    end

    if ( event == "DAMAGE_SPLIT" ) then
	spellId, spellName, spellSchool = select(9, ...);
	amount, overdamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...);
        special = Root.Combat.GetSpecial(critical, glancing, crushing);

        Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "DAMAGESPLIT", spellId, spellName, false, amount, overdamage, school, special, resisted, blocked, absorbed);
    end

    if ( strsub(event, 1, 6) == "SPELL_" ) then
        spellId, spellName, spellSchool = select(9, ...);

        if ( event == "SPELL_DAMAGE" or event == "SPELL_BUILDING_DAMAGE" ) then
            amount, overdamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...);
            special = Root.Combat.GetSpecial(critical, glancing, crushing);

            Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, false, amount, overdamage, school, special, resisted, blocked, absorbed);

    elseif ( event == "SPELL_MISSED" ) then 
            missType, amountMissed = select(12, ...);

            if ( missType == "ABSORB" ) then 
                Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, false, 0, 0, spellSchool, special, 0, 0, amountMissed);
          else
                Root.Combat.FireCallbacks("MISS", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, false, missType, amountMissed, spellSchool);
            end

    elseif ( event == "SPELL_HEAL" or event == "SPELL_BUILDING_HEAL" ) then 
            amount, overhealing, absorbed, critical = select(12, ...);
            special = Root.Combat.GetSpecial(critical, false, false);

            Root.Combat.FireCallbacks("HEAL", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, false, amount, overhealing, spellSchool, special, absorbed);

    elseif ( event == "SPELL_ENERGIZE" ) then 
            amount, powerType = select(12, ...);

            Root.Combat.FireCallbacks("ENERGIZE", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, false, amount, powerType, spellSchool);

    elseif ( event == "SPELL_DRAIN" or event == "SPELL_LEECH" ) then
            amount, powerType, extraAmount = select(12, ...);

            Root.Combat.FireCallbacks("DRAIN", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, false, amount, powerType, spellSchool, extraAmount);

    elseif ( event == "SPELL_PERIODIC_MISSED" ) then
            missType, amountMissed = select(12, ...);

            if ( missType == "ABSORB" ) then 
                Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, true, 0, 0, spellSchool, special, 0, 0, amountMissed);
          else
                Root.Combat.FireCallbacks("MISS", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, true, missType, amountMissed, spellSchool);
            end

    elseif ( event == "SPELL_PERIODIC_DAMAGE" ) then
            amount, overdamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...);
            special = Root.Combat.GetSpecial(critical, glancing, crushing);

            Root.Combat.FireCallbacks("DAMAGE", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, true, amount, overdamage, school, special, resisted, blocked, absorbed);

    elseif ( event == "SPELL_PERIODIC_HEAL" ) then
            amount, overhealing, absorbed, critical = select(12, ...);
            special = Root.Combat.GetSpecial(critical, false, false);

            Root.Combat.FireCallbacks("HEAL", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, true, amount, overhealing, spellSchool, special, absorbed);

    elseif ( event == "SPELL_PERIODIC_ENERGIZE" ) then 
            amount, powerType = select(12, ...);

            Root.Combat.FireCallbacks("ENERGIZE", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, true, amount, powerType, spellSchool);

    elseif ( event == "SPELL_PERIODIC_DRAIN" or event == "SPELL_PERIODIC_LEECH" ) then
            amount, powerType, extraAmount = select(12, ...);

            Root.Combat.FireCallbacks("DRAIN", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, true, amount, powerType, spellSchool, extraAmount);

    elseif ( event == "SPELL_INTERRUPT" ) then
            extraSpellId, extraSpellName, extraSpellSchool = select(12, ...);

            Root.Combat.FireCallbacks("INTERRUPT", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool);

    elseif ( event == "SPELL_INSTAKILL" ) then

            Root.Combat.FireCallbacks("INSTAKILL", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool);

    elseif ( event == "SPELL_DISPEL_FAILED" ) then
            extraSpellId, extraSpellName, extraSpellSchool = select(12, ...);

            Root.Combat.FireCallbacks("EFFECT_RESIST", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool);

    elseif ( event == "SPELL_DISPEL" ) then
            extraSpellId, extraSpellName, extraSpellSchool, auraType = select(12, ...);

            Root.Combat.FireCallbacks("EFFECT_DISPEL", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool, auraType);

    elseif ( event == "SPELL_STOLEN" ) then
            extraSpellId, extraSpellName, extraSpellSchool, auraType = select(12, ...);

            Root.Combat.FireCallbacks("EFFECT_STOLEN", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool, auraType);

    elseif ( event == "SPELL_AURA_BROKEN" ) then
            auraType = select(12, ...);

            sName, tName = tName, sName;
            sGUID, tGUID = tGUID, sGUID;
            sFlags, tFlags = tFlags, sFlags;

            Root.Combat.FireCallbacks("EFFECT_BROKEN", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, nil, nil, SCHOOL_MASK_PHYSICAL, auraType);

    elseif ( event == "SPELL_AURA_BROKEN_SPELL" ) then
            extraSpellId, extraSpellName, extraSpellSchool, auraType = select(12, ...);

            sName, tName = tName, sName;
            sGUID, tGUID = tGUID, sGUID;
            sFlags, tFlags = tFlags, sFlags;

            Root.Combat.FireCallbacks("EFFECT_BROKEN", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool, auraType);

    elseif ( event == "SPELL_AURA_APPLIED" ) then
            auraType = select(12, ...);

            Root.Combat.FireCallbacks("EFFECT_GAIN", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, auraType, 1);

    elseif ( event == "SPELL_AURA_APPLIED_DOSE" ) then
            auraType, amount = select(12, ...);

            Root.Combat.FireCallbacks("EFFECT_GAIN", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, auraType, amount);

    elseif ( event == "SPELL_AURA_REMOVED" ) then
            auraType = select(12, ...);

            Root.Combat.FireCallbacks("EFFECT_FADE", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, auraType, 1);

    elseif ( event == "SPELL_AURA_REMOVED_DOSE" ) then
            auraType, amount = select(12, ...);

            Root.Combat.FireCallbacks("EFFECT_FADE", sGUID, sName, sFlags, tGUID, tName, tFlags, "SPELL", spellId, spellName, spellSchool, auraType, amount);

    elseif ( event == "SPELL_CAST_START" ) then

            Root.Combat.FireCallbacks("CAST_START", sGUID, sName, sFlags, tGUID, tName, tFlags, spellId, spellName, spellSchool);

    elseif ( event == "SPELL_CAST_SUCCESS" ) then

            Root.Combat.FireCallbacks("CAST_SUCCESS", sGUID, sName, sFlags, tGUID, tName, tFlags, spellId, spellName, spellSchool);

    elseif ( event == "SPELL_SUMMON" ) then

            Root.Combat.FireCallbacks("SUMMON", sGUID, sName, sFlags, tGUID, tName, tFlags, spellId, spellName, spellSchool);

    elseif ( event == "SPELL_CAST_FAILED" ) then
            return;
    elseif ( event == "SPELL_CREATE" ) then
            return;
    elseif ( event == "SPELL_RESURRECT" ) then
            return;
    elseif ( event == "SPELL_EXTRA_ATTACKS" ) then
            return;
    elseif ( event == "SPELL_DURABILITY_DAMAGE" ) then
            return;
    elseif ( event == "SPELL_DURABILITY_DAMAGE_ALL" ) then
            return;
        end
    end
end