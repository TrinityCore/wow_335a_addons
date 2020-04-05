local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

local GlobalOptions = Root.GetOrNewModule("GlobalOptions");

local Engine = Root.GetOrNewModule("Engine");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Global Options Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles global options.
-- Global options are options that are used in all boss fights.
-- Generally global options are used in Shared methods.

-- WARNING: this module is a pseudo module. It does not have any handler
-- nor methods besides OnStart and setting methods.
-- Also, as a pseudo module, its access is not restricted, even if
-- another module is already running.

-- To edit the global options, simply call Open method.

-- --------------------------------------------------------------------
-- **                            Definition                          **
-- --------------------------------------------------------------------

-- Do NOT use locks nor "oneEnabledOnly" field in these settings.

local mySettings = {
    [1] = {
        id = "EventWatcherTimeScale",
        type = "NUMBER",
        label = {
            ["default"] = "Event watcher time scale",
            ["frFR"] = "Echelle de temps des évènements",
        },
        explain = {
            ["default"] = "Set the amount of time (in sec.) a tick represents in the event watcher.",
            ["frFR"] = "Règle à combien de temps (en sec.) correspond une graduation dans le visualisateur d'évènements.",
        },
        min = 1,
        max = 60,
        step = 1,
        defaultValue = 1,
    },
    [2] = {
        id = "AddonEnabled",
        type = "BOOLEAN",
        defaultValue = true,
        label = {
            ["default"] = "Enable BossEncounter2",
            ["frFR"] = "Activer BossEncounter2",
        },
        explain = {
            ["default"] = "Disabling this option will prevent BE2 from opening boss modules. It can be useful to change boss addons on the fly.",
            ["frFR"] = "Désactiver cette option empêchera BE2 d'ouvrir des modules de boss. Utile pour changer d'addon de boss à la volée.",
        },
    },
    [3] = {
        id = "ShowHealAssist",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Enable heal assist",
            ["frFR"] = "Activer l'assistant aux soins",
        },
        explain = {
            ["default"] = [[When enabled, this service puts a red border around the raid frames of people that are about to receive big amounts of damage.
The effectiveness of this service depends on the boss.

|cffff8000WARNING - This service is NOT compatible with custom raid frames implemented through AddOns.|r

|cff00ff00COMPATIBLE with: HealBot, Grid, Grid2, X-Perl.|r]],
            ["frFR"] = [[Quand activé, ce service affiche une bordure rouge autour des cadres de raid des personnes qui vont recevoir d'importants dégâts.
L'efficacité de ce service varie d'un boss à l'autre.

|cffff8000ATTENTION - Ce service n'est pas compatible avec les cadres de raid personnalisés mis en place via des AddOns.|r

|cff00ff00COMPATIBLE avec: HealBot, Grid, Grid2, X-Perl.|r]],
        },
    },
    [4] = {
        id = "ShowDifficultyMeter",
        type = "BOOLEAN",
        defaultValue = true,
        label = {
            ["default"] = "Show difficulty meter",
            ["frFR"] = "Afficher l'indicateur de difficulté",
        },
        explain = {
            ["default"] = "This meter tells briefly how hard the boss encounter will be on several criterias.",
            ["frFR"] = "Cet indicateur vous indique brièvement la difficulté du boss sur plusieurs critères.",
        },
    },
    [5] = {
        id = "ShowBerserkReminder",
        type = "BOOLEAN",
        defaultValue = true,
        label = {
            ["default"] = "Show berserk reminders",
            ["frFR"] = "Afficher les rappels du berserk",
        },
        explain = {
            ["default"] = "When this option is enabled, a timer will appear periodically in the middle of the screen to remind you of the berserk timer.",
            ["frFR"] = "Quand cette option est activée, un chrono apparaîtra périodiquement au milieu de l'écran pour vous rappeler le temps restant avant le berserk.",
        },
    },
    [6] = {
        id = "AllowSuperAlerts",
        type = "BOOLEAN",
        defaultValue = true,
        label = {
            ["default"] = "Allow aggressive alerts",
            ["frFR"] = "Autoriser les alertes agressives",
        },
        explain = {
            ["default"] = "When enabled, aggressive alerts will be displayed for events you are by no way allowed to miss, this special type of alerts is only used for things that could cause an instant death or wipe the raid out.",
            ["frFR"] = "Autorise BossEncounter2 à employer des alertes spéciales agressives pour les évènements que le joueur ne doit absolument pas manquer et qui pourraient tuer instantanément le joueur ou le raid.",
        },
    },
    [7] = {
        id = "UseGraphicalEventWarning",
        type = "BOOLEAN",
        defaultValue = true,
        label = {
            ["default"] = "Graphical event warnings",
            ["frFR"] = "Avertissements d'évènements graphiques",
        },
        explain = {
            ["default"] = "Replace the textual event warnings for incoming events by a time bar.",
            ["frFR"] = "Remplace les avertissements textuels des évènements imminents par une barre de temps.",
        },
    },
    [8] = {
        id = "UseAddHealthPercentage",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Add health in percentage",
            ["frFR"] = "Vie des adds en pourcentage",
        },
        explain = {
            ["default"] = "Replace the HP value of adds by their percentage of HP.",
            ["frFR"] = "Remplace la valeur de PV des adds par leur pourcentage de vie.",
        },
    },
    [9] = {
        id = "AutoReplyInCombat",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Enable auto-reply in combat",
            ["frFR"] = "Activer réponses auto en combat",
        },
        explain = {
            ["default"] = "When enabled, this service will automatically answer whispers from people outside from your party. They will be informed of the status of the fight.",
            ["frFR"] = "Quand activé, ce service répondra automatiquement aux chuchotements des personnes extérieures à votre groupe. Elles seront informées de l'état du combat.",
        },
    },
    [10] = {
        id = "AutomaticRole",
        type = "BOOLEAN",
        defaultValue = true,
        label = {
            ["default"] = "Determinate my role automatically",
            ["frFR"] = "Déterminer mon rôle automatiquement",
        },
        explain = {
            ["default"] = "When enabled, BossEncounter2 will automatically determinate your role (tank, damage dealer or healer). This saves you the burden of setting manually the Filter yourself (see below).",
            ["frFR"] = "Quand activé, BossEncounter2 déterminera automatiquement votre rôle (tank, DPS ou soigneur). Cela vous évite de devoir régler manuellement le filtre (voir plus bas).",
        },
    },
    [11] = {
        id = "RoleFilter",
        type = "BIT_TABLE",
        bits = 4,
        isPerCharacter = true,
        defaultValue = 0x00,
        label = {
            ["default"] = "Filter",
            ["frFR"] = "Filtre",
        },
        explain = {
            ["default"] = [[The filter allows you to hide or attenuate the importance of the various alerts throughout boss fights according to the role(s) you are currently performing.

To get all alerts, check all boxes.

|cffff8000WARNING - This will have no effect if "Determinate my role automatically" is enabled.|r]],
            ["frFR"] = [[Ce filtre vous permet de cacher ou d'atténuer l'importance des différentes alertes durant les combats de boss en fonction du(es) rôle(s) que vous remplissez actuellement.

Pour recevoir toutes les alertes, cochez toutes les cases.

|cffff8000ATTENTION - Ceci n'aura aucun effet si l'option "Déterminer mon rôle automatiquement" est cochée.|r]],
        },
        bitsTitle = {
            ["default"] = {
                [1] = "Melee DD",
                [2] = "Ranged DD",
                [3] = "Healer",
                [4] = "Tank",
            },
            ["frFR"] = {
                [1] = "Mêlée DPS",
                [2] = "Distance DPS",
                [3] = "Soigneur",
                [4] = "Tank",
            },
        },
    },
    nextOptions = "AdvancedOptions", -- Name of the module containing the following option set.
    version = 2,
};

local roleIds = {
    -- Roles that are directly asked in the option box.
    ["DPS_MELEE"] = 0x01,
    ["DPS_RANGED"] = 0x02,
    ["HEALER"] = 0x04,
    ["TANK"] = 0x08,

    -- Roles that are deduced from the roles chosen in the option box.
    ["DPS"] = 0x03, -- ( melee dps ) + ( ranged dps )
    ["CASTER"] = 0x06, -- ( ranged dps ) + ( heal )
    ["MELEE"] = 0x09, -- ( melee dps ) + ( tank )
    ["SHIELD"] = 0x0C, -- ( heal ) + ( tank )
    ["OFFENSIVE"] = 0x0B, -- ( dps ) + ( tank )
};

local rolePerClass = {
    -- Pure classes (all damage dealers, no ambiguity)

    ["HUNTER"] = 0x02,
    ["MAGE"] = 0x02,
    ["ROGUE"] = 0x01,
    ["WARLOCK"] = 0x02,

    -- Hybrid classes

    ["DEATHKNIGHT"] = { -- DKs with their OPed talents design are tricky to handle. Let's use arbitrary values and be done with it.
        [1] = 0x01, -- BLOD - Melee
        [2] = 0x08, -- FRST - Tank
        [3] = 0x01, -- UNHY - Melee
    },

    ["DRUID"] = {
        [1] = 0x02, -- BLNC - Ranged
        [2] = 0x09, -- FRAL - Melee + Tank
        [3] = 0x04, -- REST - Healer
    },

    ["PALADIN"] = {
        [1] = 0x04, -- HOLY - Healer
        [2] = 0x08, -- PROT - Tank
        [3] = 0x01, -- RETB - Melee
    },

    ["PRIEST"] = {
        [1] = 0x04, -- DISC - Healer
        [2] = 0x04, -- HOLY - Healer
        [3] = 0x02, -- SHDW - Ranged
    },

    ["SHAMAN"] = {
        [1] = 0x02, -- ELEM - Ranged
        [2] = 0x01, -- ENHC - Melee
        [3] = 0x04, -- REST - Healer
    },

    ["WARRIOR"] = {
        [1] = 0x01, -- ARMS - Melee
        [2] = 0x01, -- FURY - Melee
        [3] = 0x08, -- PROT - Tank
    },
};

GlobalOptions.loaded = false;

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

GlobalOptions.OnEnterWorld = function(self)
    if ( not self.loaded ) then
        self.loaded = true;
  else
        return;
    end

    self:InitializeSettings();
    Root.InvokeHandler("OnGlobalOptionsLoaded");
end;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

GlobalOptions.InitializeSettings = Shared.InitializeSettings;

GlobalOptions.GetSetting = function(self, id)
    -- On the contrary of other modules settings, the global options do not allow locks.
    return Shared.GetSetting(self, id, true);
end;

GlobalOptions.MayEditSettings = function(self)
    return true; -- Always accessable since it's not a real module.
end;

GlobalOptions.GetName = function(self)
    return "GlobalOptions";
end;

GlobalOptions.Open = function(self)
    local settingFrame = Manager:GetSettingFrame();
    if type(settingFrame) ~= "table" then return; end

    settingFrame:Open(self);
end;

GlobalOptions.HasRole = function(self, role)
    local myRoleBitTable = self:GetSetting("RoleFilter") or 0;
    if self:GetSetting("AutomaticRole") then
        myRoleBitTable = self:GetRealRole() or 0;
    end

    local matchBitTable = roleIds[role];
    if ( matchBitTable ) then
        return bit.band(myRoleBitTable, matchBitTable) ~= 0;
    end
    return true;
end;

GlobalOptions.GetRealRole = function(self)
    -- Get the real role of the player according to the talent spec and class.

    local class = select(2, UnitClass("player"));
    local info = rolePerClass[class];

    if ( not info ) then
        return 0x00;

elseif type(info) == "number" then
        -- No possible ambiguity
        return info;

elseif type(info) == "table" then
        -- The return value will depend on the current spec of the player.

        local threshold = math.floor((UnitLevel("player") - 10) / 2.5); -- Will be fine for chars <= Lv10 too.
        local bitTable = 0x00;
        local i, j, treeCount;

        for i=1, GetNumTalentTabs() do
            treeCount = 0;
            for j=1, GetNumTalents(i) do
                name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(i, j);
                treeCount = treeCount + rank;
            end
            if ( treeCount >= threshold ) then
                bitTable = bit.bor(bitTable, info[i]);
            end
        end

        return bitTable;
    end
end

GlobalOptions.OnSettingChanged = function(self, id)
    if ( id == "AddonEnabled" ) then
        local state = self:GetSetting("AddonEnabled");
        Root.SetEnabled(state);

        if ( not state ) then
            Engine:StopAnyModule();
        end
    end
end;

GlobalOptions.OnGlobalOptionsLoaded = function(self)
    Root.enabled = self:GetSetting("AddonEnabled");

    if ( not Root.enabled ) then
        Root.Print(Root.Localise("Console-BE2StartDisabled"), true);
    end
end;

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    GlobalOptions.settings = mySettings;
end