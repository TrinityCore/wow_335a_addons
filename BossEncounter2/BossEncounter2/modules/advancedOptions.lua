local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

local AdvancedOptions = Root.GetOrNewModule("AdvancedOptions");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Advanced Options Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Same as global options, but contains advanced options.

-- --------------------------------------------------------------------
-- **                            Definition                          **
-- --------------------------------------------------------------------

-- Do NOT use locks nor "oneEnabledOnly" field in these settings.

local mySettings = {
    [1] = {
        id = "DebugMode",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Debug mode",
            ["frFR"] = "Mode débug",
        },
        explain = {
            ["default"] = "Enables a few debug messages.\n\nNormal users should not enable this.",
            ["frFR"] = "Active quelques messages de débug.\n\nLes utilisateurs normaux ne devraient pas activer ceci.",
        },
    },
    [2] = {
        id = "MaskEndSequence",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Mask end sequence for well known bosses",
            ["frFR"] = "Masquer la séquence de fin pour les boss bien connus",
        },
        explain = {
            ["default"] = "Skips the end sequence if the boss was defeated 3 times or more. If you get a new record the sequence will still be shown.",
            ["frFR"] = "Passe la séquence de fin si le boss a été vaincu 3 fois ou plus. Si vous obtenez un nouveau record, la séquence sera quand même affichée.",
        },
    },
    [3] = {
        id = "ClickableAddRow",
        type = "BOOLEAN",
        defaultValue = true,
        label = {
            ["default"] = "Make add window rows clickable",
            ["frFR"] = "Rendre les lignes de la fenêtre d'adds cliquables",
        },
        explain = {
            ["default"] = [[Allows you to click on add window rows to target adds.

|cffff8000WARNING - This will not work all the time for all adds and enabling this will put restrictions on add window during combat.|r]],
            ["frFR"] = [[Vous permet de cliquer sur les lignes de la fenêtre d'adds pour cibler.

|cffff8000ATTENTION - Ceci ne marchera pas tout le temps pour tous les adds et activer cette fonction ajoutera des contraintes à la fenêtre d'adds en combat.|r]],
        },
    },
    [4] = {
        id = "UseLootHelper",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Use loot assist",
            ["frFR"] = "Activer l'assistant de butin",
        },
        explain = {
            ["default"] = "When enabled, this service will enable the loot assignment system of BossEncounter2.\n\nThis option only affects ''master loot'' mode.",
            ["frFR"] = "Quand activé, ce service activera le système d'assignement de butin de BossEncounter2.\n\nCette option ne concerne que le mode ''maître du butin''.",
        },
    },
    [5] = {
        id = "Emulation-BigWigs",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Emulate BigWigs version query",
            ["frFR"] = "Emuler la requête de version de BigWigs",
        },
        explain = {
            ["default"] = "If enabled, BossEncounter2 will answer BigWigs version queries, making others believe you use an up-to-date version of BW.",
            ["frFR"] = "Si activé, BossEncounter2 répondra aux requêtes de version de BigWigs, faisant croire aux autres que vous utilisez une version à jour de BW.",
        },
    },
    [6] = {
        id = "Emulation-DeadlyBossMods",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Emulate DeadlyBossMods version query",
            ["frFR"] = "Emuler la requête de version de DeadlyBossMods",
        },
        explain = {
            ["default"] = "If enabled, BossEncounter2 will answer DeadlyBossMods version queries, making others believe you use an up-to-date version of DBM.",
            ["frFR"] = "Si activé, BossEncounter2 répondra aux requêtes de version de DeadlyBossMods, faisant croire aux autres que vous utilisez une version à jour de DBM.",
        },
    },
    nextOptions = "GlobalOptions", -- Name of the module containing the following option set.
    version = 1,
};

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

AdvancedOptions.OnEnterWorld = function(self)
    self:InitializeSettings();

    Root.debug = self:GetSetting("DebugMode");
end;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

AdvancedOptions.InitializeSettings = Shared.InitializeSettings;

AdvancedOptions.GetSetting = function(self, id)
    return Shared.GetSetting(self, id, true);
end;

AdvancedOptions.MayEditSettings = function(self)
    return true;
end;

AdvancedOptions.GetName = function(self)
    return "AdvancedOptions";
end;

AdvancedOptions.Open = function(self)
    local settingFrame = Manager:GetSettingFrame();
    if type(settingFrame) ~= "table" then return; end

    settingFrame:Open(self);
end;

AdvancedOptions.OnSettingChanged = function(self, id)
    if ( id == "DebugMode" ) then
        local newDebugMode = self:GetSetting("DebugMode");
        if ( Root.debug ~= newDebugMode ) then
            Root.debug = newDebugMode;
            if ( newDebugMode ) then
                Root.Print("Debug enabled.");
          else
                Root.Print("Debug disabled.");
            end
        end
    end
end;

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    AdvancedOptions.settings = mySettings;
end