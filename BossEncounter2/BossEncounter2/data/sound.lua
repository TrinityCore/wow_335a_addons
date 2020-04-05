local Root = BossEncounter2;

Root.Sound = { };

local Sound = Root["Sound"];

Sound.folder = Root.folder.."sfx\\";

-- --------------------------------------------------------------------
-- **                             Data                               **
-- --------------------------------------------------------------------

local sounds = {
    ["CLEARED"] = "Cleared.mp3",
    ["CLEAREDALTERNATE"] = "ClearedAlternate.mp3",
    ["EPICFAIL"] = "EpicFail.wav",
    ["TRIGGER"] = "Trigger.wav",
    ["NEWRECORD"] = "NewRecord.wav",
    ["TIMETICK"] = "TimeTick.wav",
    ["COUPDEGRACE"] = "CoupDeGrace.mp3",
    ["ADDCHANGE"] = "AddChange.wav",
    ["PHASECHANGE"] = "PhaseChange.wav",
    ["TICK"] = "Tick.wav",
};

local soundCVars = {
    Sound_EnableSFX = "boolean",
    Sound_EnableMusic = "boolean",
    Sound_EnableAmbience = "boolean",

    Sound_SFXVolume = "number",
    Sound_MusicVolume = "number",
    Sound_AmbienceVolume = "number",
};

local originalSoundSettings = {};
local transitionStartSettings = {};
local transitionEndSettings = {};
local userConfiguration = false;

local transitionRunning = false;
local transitionTimer = 0;
local transitionMaxTimer = 0;

-- --------------------------------------------------------------------
-- **                              API                               **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> Sound -> Play(name)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the sound to start, from the list above.    *
-- ********************************************************************
-- * Plays a sound. Note that SFX playback cannot be stopped.         *
-- * If it is not found or for some reason can't be played, nil is    *
-- * returned; 1 elsewise is.                                         *
-- ********************************************************************
function Root.Sound.Play(name)
    local filename = sounds[name];
    if ( filename ) then
        return PlaySoundFile(Sound.folder..filename);
    end
    return nil;
end

-- ********************************************************************
-- * Root -> Sound -> SetTemporarySettings(info, duration)            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> info: a table containing the new volume rules to use for      *
-- * a temporary duration.                                            *
-- * >> duration: the time we use to do the transition between the    *
-- * current sound settings and the new ones.                         *   
-- ********************************************************************
-- * Temporarily change the SFX, music and ambience volumes according *
-- * to the info contained in the "info" table over X sec.            *
-- * Call revert volume function to smoothly revert the sound to its  *
-- * previous state.                                                  *
-- * Return 1 if successful, nil if not. Function will fail if the    *
-- * master sound is off.                                             *
-- ********************************************************************
function Root.Sound.SetTemporarySettings(info, duration)
    if ( GetCVar("Sound_EnableAllSound") ~= "1" ) then
        return nil;
    end

    if ( not userConfiguration ) then
        userConfiguration = true;
        Root.Sound.StoreCurrentSettings(originalSoundSettings);
    end

    duration = max(0.10, duration);

    Root.Sound.StoreCurrentSettings(transitionStartSettings);
    transitionEndSettings = info;

    transitionRunning = true;
    transitionTimer = 0;
    transitionMaxTimer = duration;

    -- Apply boolean changes at once

    local k, v;
    for k, v in pairs(soundCVars) do
        if ( v == "boolean" ) and ( transitionEndSettings[k] ~= nil ) then
            SetCVar(k, transitionEndSettings[k]);
        end
    end

    return 1;
end

-- ********************************************************************
-- * Root -> Sound -> RevertSettings(duration)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> duration: the time we use to do the transition between the    *
-- * current sound settings and the normal ones.                      *   
-- ********************************************************************
-- * Smoothly revert the sound to its previous state after calling    *
-- * the set temporary settings function.                             *
-- ********************************************************************
function Root.Sound.RevertSettings(duration)
    if ( not userConfiguration ) then return; end

    duration = max(0.10, duration);

    userConfiguration = false;

    Root.Sound.StoreCurrentSettings(transitionStartSettings);
    transitionEndSettings = originalSoundSettings;

    transitionRunning = true;
    transitionTimer = 0;
    transitionMaxTimer = duration;

    -- Apply boolean changes at once

    local k, v;
    for k, v in pairs(soundCVars) do
        if ( v == "boolean" ) and ( transitionEndSettings[k] ~= nil ) then
            SetCVar(k, transitionEndSettings[k]);
        end
    end
end

-- ********************************************************************
-- * Root -> Sound -> StoreCurrentSettings(table)                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> table: the table the settings will be stored into.            * 
-- ********************************************************************
-- * Store the current sound config in the given table.               *
-- * The table will be cleaned from any previous value.               *
-- ********************************************************************
function Root.Sound.StoreCurrentSettings(table)
    local k;
    for k in pairs(table) do table[k] = nil; end

    for k in pairs(soundCVars) do
        table[k] = GetCVar(k);
    end
end

-- ********************************************************************
-- * Root -> Sound -> RestoreDefaults()                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        * 
-- ********************************************************************
-- * Instantly restores the default sound settings.                   *
-- ********************************************************************
function Root.Sound.RestoreDefaults()
    local k;
    for k in pairs(soundCVars) do
        SetCVar(k, GetCVarDefault(k));
    end
end

-- ********************************************************************
-- * Root -> Sound -> FixMusicInterruption(delay)       - TEMPORARY - *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> delay: the delay before performing the fix.                   *
-- * Zero or nil means at once.                                       * 
-- ********************************************************************
-- * Fixes (till Blizzard puts its fingers out of its arse) the       *
-- * interruption of custom music when all SFX channels are being     *
-- * used. This is done by allocating a BIGGER number of sound        *
-- * channels, so big it's unlikely all of them will be filled up.    *
-- ********************************************************************
function Root.Sound.FixMusicInterruption(delay)
    if ( not delay ) or ( delay == 0 ) then
        Root.Sound.doChannelExtension = nil;
        SetCVar("Sound_NumChannels", "256", true);
        Sound_GameSystem_RestartSoundSystem();
  else
        Root.Sound.doChannelExtension = delay;
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

Root.Sound.OnStart = function(self)
    Root.Sound.FixMusicInterruption(1.000);
end

Root.Sound.OnUpdate = function(self, elapsed)
    if ( self.doChannelExtension ) and ( not InCombatLockdown() ) then
        self.doChannelExtension = self.doChannelExtension - elapsed;
        if ( self.doChannelExtension <= 0 ) then
            Root.Sound.FixMusicInterruption(0);
        end
    end

    if ( not transitionRunning ) then return; end

    transitionTimer = min(transitionTimer + elapsed, transitionMaxTimer);

    local k, v;
    for k, v in pairs(soundCVars) do
        if ( v == "number" ) and ( transitionStartSettings[k] ~= nil ) and ( transitionEndSettings[k] ~= nil ) then
            SetCVar(k, transitionStartSettings[k] + ( transitionEndSettings[k] - transitionStartSettings[k] ) * ( transitionTimer / transitionMaxTimer ));
        end
    end

    if ( transitionTimer == transitionMaxTimer ) then
        transitionRunning = false;
    end
end;