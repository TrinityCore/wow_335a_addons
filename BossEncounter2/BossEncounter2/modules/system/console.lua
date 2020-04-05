local Root = BossEncounter2;

local Engine = Root.GetOrNewModule("Engine");
local GlobalOptions = Root.GetOrNewModule("GlobalOptions");
local Version = Root.GetOrNewModule("Version");
local LootHelper = Root.GetOrNewModule("LootHelper");

local Manager = Root.GetOrNewModule("Manager");
local EncounterStats = Root.GetOrNewModule("EncounterStats");
local Distance = Root.GetOrNewModule("Distance");

local Console = Root.GetOrNewModule("Console");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A functionnal module which detects slash commands and interpret them.

-- --------------------------------------------------------------------
-- **                           Definitions                          **
-- --------------------------------------------------------------------

local inputPortions = {};

-- /!\ Do not set "call" fields to directly a function. Sets it to a function name instead, as when this code will be executed,
-- functions themselves won't be defined yet. /!\

Console.data = {
    ["default"] = {
        unknownHelp = "/BE <command>\nCommands: start | stop | clear | author | anchor | wipedata | options | version | music | enchanter | replaysequence",

        [1] = {
            type = "METHOD",
            input = "clear",
            object = Engine,
            call = "StopAnyModule",
            arguments = {},
            invalidHelp = "/BE clear",
        },

        [2] = {
            type = "METHOD",
            input = "start",
            object = Console,
            call = "StartAddon",
            arguments = {},
            invalidHelp = "/BE start",
        },

        [3] = {
            type = "METHOD",
            input = "stop",
            object = Console,
            call = "StopAddon",
            arguments = {},
            invalidHelp = "/BE stop",
        },

        [4] = {
            type = "METHOD",
            input = "author",
            object = Console,
            call = "PrintAuthorInfo",
            arguments = {},
            invalidHelp = "/BE author",
        },

        [5] = {
            type = "METHOD",
            input = "anchor",
            object = Console,
            call = "EnterAnchorMode",
            arguments = {},
            invalidHelp = "/BE anchor",
        },

        [6] = {
            type = "METHOD",
            input = "wipedata",
            object = Console,
            call = "WipeAllData",
            arguments = {},
            invalidHelp = "/BE wipedata",
        },

        [7] = {
            type = "METHOD",
            input = "options",
            object = GlobalOptions,
            call = "Open",
            arguments = {},
            invalidHelp = "/BE options",
        },

        [8] = {
            type = "METHOD",
            input = "version",
            object = Console,
            call = "DoVersionCheck",
            arguments = {
                [1] = "string",
            },
            invalidHelp = "/BE version [guild/group/player name]",
        },

        [9] = {
            type = "METHOD",
            input = "replaysequence",
            object = Console,
            call = "ReplayLastSequence",
            arguments = {},
            invalidHelp = "/BE replay",
        },

        [10] = {
            type = "METHOD",
            input = "printdps",
            object = Console,
            call = "PrintLastDPS",
            arguments = {
                [1] = "string",
            },
            invalidHelp = "/BE printdps [mode/player name]\nMode specifies where the result is displayed: 1=Self, 2=Group, 3=Guild, 4=Officer.\nYou can also whisper by providing a player name instead of a digit.",
        },

        [11] = {
            type = "CATEGORY",
            input = "music",
            unknownHelp = "/BE music <command>\nCommands: explain | list | activate",

            [1] = {
                type = "METHOD",
                input = "explain",
                object = Console,
                call = "MusicPluginExplain",
                arguments = {},
                invalidHelp = "/BE music explain",
            },

            [2] = {
                type = "METHOD",
                input = "list",
                object = Console,
                call = "MusicPluginList",
                arguments = {},
                invalidHelp = "/BE music list",
            },

            [3] = {
                type = "METHOD",
                input = "activate",
                object = Console,
                call = "MusicPluginActivate",
                arguments = {
                    [1] = "number",
                },
                invalidHelp = "/BE music activate [plugin number]",
            },
        },

        [12] = {
            type = "CATEGORY",
            input = "enchanter",
            unknownHelp = "/BE enchanter <command>\nCommands: list | add | remove\nN.B: this section is useless if you do not use BE2 loot assist system.",

            [1] = {
                type = "METHOD",
                input = "list",
                object = Console,
                call = "PrintEnchanter",
                arguments = {},
                invalidHelp = "/BE enchanter list",
            },

            [2] = {
                type = "METHOD",
                input = "add",
                object = Console,
                call = "AddEnchanter",
                arguments = {
                    [1] = "string",
                },
                invalidHelp = "/BE enchanter add X, where X is:\neither the magic word ''target''\neither the name of the player (mind the capital letters).",
            },

            [3] = {
                type = "METHOD",
                input = "remove",
                object = Console,
                call = "RemoveEnchanter",
                arguments = {
                    [1] = "string",
                },
                invalidHelp = "/BE enchanter remove X, where X is:\neither the magic word ''target''\neither the number got with /BE enchanter list\neither a name (mind the capital letters).",
            },
        },
    },

    ["frFR"] = {
        unknownHelp = "/BE <commande>\nCommandes: lancer | stop | nettoyer | auteur | attache | raz | options | version | musique | enchanteur | rejouersequence",

        [1] = {
            type = "METHOD",
            input = "nettoyer",
            object = Engine,
            call = "StopAnyModule",
            arguments = {},
            invalidHelp = "/BE nettoyer",
        },

        [2] = {
            type = "METHOD",
            input = "lancer",
            object = Console,
            call = "StartAddon",
            arguments = {},
            invalidHelp = "/BE lancer",
        },

        [3] = {
            type = "METHOD",
            input = "stop",
            object = Console,
            call = "StopAddon",
            arguments = {},
            invalidHelp = "/BE stop",
        },

        [4] = {
            type = "METHOD",
            input = "auteur",
            object = Console,
            call = "PrintAuthorInfo",
            arguments = {},
            invalidHelp = "/BE auteur",
        },

        [5] = {
            type = "METHOD",
            input = "attache",
            object = Console,
            call = "EnterAnchorMode",
            arguments = {},
            invalidHelp = "/BE attache",
        },

        [6] = {
            type = "METHOD",
            input = "raz",
            object = Console,
            call = "WipeAllData",
            arguments = {},
            invalidHelp = "/BE raz",
        },

        [7] = {
            type = "METHOD",
            input = "options",
            object = GlobalOptions,
            call = "Open",
            arguments = {},
            invalidHelp = "/BE options",
        },

        [8] = {
            type = "METHOD",
            input = "version",
            object = Console,
            call = "DoVersionCheck",
            arguments = {
                [1] = "string",
            },
            invalidHelp = "/BE version [guilde/groupe/nom de joueur]",
        },

        [9] = {
            type = "METHOD",
            input = "rejouersequence",
            object = Console,
            call = "ReplayLastSequence",
            arguments = {},
            invalidHelp = "/BE rejouersequence",
        },

        [10] = {
            type = "METHOD",
            input = "afficherdps",
            object = Console,
            call = "PrintLastDPS",
            arguments = {
                [1] = "string",
            },
            invalidHelp = "/BE afficherdps [mode/nom de joueur]\nMode indique où afficher le résultat: 1=Soi-même, 2=Groupe, 3=Guilde, 4=Officier.\nVous pouvez aussi chuchoter en donnant un nom de joueur au lieu d'un chiffre.",
        },

        [11] = {
            type = "CATEGORY",
            input = "musique",
            unknownHelp = "/BE musique <commande>\nCommandes: explication | liste | activer",

            [1] = {
                type = "METHOD",
                input = "explication",
                object = Console,
                call = "MusicPluginExplain",
                arguments = {},
                invalidHelp = "/BE musique explication",
            },

            [2] = {
                type = "METHOD",
                input = "liste",
                object = Console,
                call = "MusicPluginList",
                arguments = {},
                invalidHelp = "/BE musique liste",
            },

            [3] = {
                type = "METHOD",
                input = "activer",
                object = Console,
                call = "MusicPluginActivate",
                arguments = {
                    [1] = "number",
                },
                invalidHelp = "/BE musique activer [numéro du plugin]",
            },
        },

        [12] = {
            type = "CATEGORY",
            input = "enchanteur",
            unknownHelp = "/BE enchanteur <commande>\nCommandes: liste | ajouter | retirer\nN.B: cette section est inutile si vous n'utilisez pas l'assistant de butin de BE2.",

            [1] = {
                type = "METHOD",
                input = "liste",
                object = Console,
                call = "PrintEnchanter",
                arguments = {},
                invalidHelp = "/BE enchanteur liste",
            },

            [2] = {
                type = "METHOD",
                input = "ajouter",
                object = Console,
                call = "AddEnchanter",
                arguments = {
                    [1] = "string",
                },
                invalidHelp = "/BE enchanteur ajouter X, où X est:\nsoit le mot magique ''cible''\nsoit le nom de la personne (en respectant les majuscules).",
            },

            [3] = {
                type = "METHOD",
                input = "retirer",
                object = Console,
                call = "RemoveEnchanter",
                arguments = {
                    [1] = "string",
                },
                invalidHelp = "/BE enchanteur retirer X, où X est:\nsoit le mot magique ''cible''\nsoit le numéro obtenu avec /BE enchanteur liste\nsoit un nom (en respectant les majuscules).",
            },
        },

        [13] = { -- For debug / development purposes
            type = "METHOD",
            input = "spell",
            object = Console,
            call = "ExtractSpellID",
            arguments = {
                [1] = "string",
            },
            invalidHelp = "/BE spell |cff8080ff[spellLink]|r",
        },

        [14] = { -- For debug / development purposes
            type = "METHOD",
            input = "npc",
            object = Console,
            call = "ExtractNPCID",
            arguments = {},
            invalidHelp = "/BE npc",
        },

        [15] = { -- For debug / development purposes
            type = "METHOD",
            input = "distance",
            object = Console,
            call = "GetMapDistance",
            arguments = {},
            invalidHelp = "/BE distance",
        },

        [16] = { -- For debug / development purposes
            type = "CATEGORY",
            input = "dev",

            [1] = {
                type = "METHOD",
                input = "new",
                object = Console,
                call = "DevelopmentNew",
                arguments = {},
                invalidHelp = "/BE dev new",
            },

            [2] = {
                type = "METHOD",
                input = "get",
                object = Console,
                call = "DevelopmentGet",
                arguments = {
                    [1] = "number",
                },
                invalidHelp = "/BE dev get <number> [0 allows you to get the list]",
            },

            [3] = {
                type = "METHOD",
                input = "delete",
                object = Console,
                call = "DevelopmentDelete",
                arguments = {
                    [1] = "number",
                },
                invalidHelp = "/BE dev delete <number>",
            },

            unknownHelp = "/BE dev <command>\nCommands: new | get | delete",
        },
    },
};

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ^^^^^^^^^^^^^^^^^^^
-- A. Main interpreter
-- vvvvvvvvvvvvvvvvvvv

local function ProtectBrackets(x)
    if type(x) ~= "string" or #x == 0 then return ""; end
    return "["..string.gsub(x, " ", "_").."]";
end

local function RestoreBrackets(x)
    if type(x) ~= "string" or #x == 0 then return ""; end
    return "["..string.gsub(x, "_", " ").."]";
end

-- ********************************************************************
-- * Console:Execute(input, feedback)                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> input: what we asked the console to do.                       *
-- * >> feedback: if set, the console will print feedback             *
-- * in case of unknown commands, bad syntaxes etc..                  *
-- ********************************************************************

Console.Execute = function(self, input, feedback)
    -- STEP 1 - Decomposes each word of the input. Also take care of item links.

    local k, v;
    local portions = 0;

    -- Protect spaces inside a bracket.
    input = string.gsub(input, "%[(.+)%]", ProtectBrackets);

    for k, v in ipairs(inputPortions) do
        inputPortions[k] = nil;
    end

    for w in string.gmatch(input, "[^ ]+") do
        portions = portions + 1;
        inputPortions[portions] = string.gsub(w, "%[(.+)%]", RestoreBrackets);
    end

    -- STEP 2 - Grab the appropriate console table.

    if not ( self.data ) then
        -- Uh ? Console data have been deleted from the cosmos !
        return;
    end

    local data = self.data[GetLocale()];
    if not ( data ) then
        data = self.data["default"];
    end
    if not ( data ) then
        -- Uh ? No console data at all !
        return;
    end

    -- STEP 3 - Enter the loop ! Oh yeah baby enter the loop =))

    local unknownHelp;
    local invalidHelp;
    local level = 0;
    local levelData;

    local continue = 1;
    local isValid = 1; -- 1 if the command exists. If isValid is nil and feedback set, a message saying you entered an unknown command will fire.
    local hasSyntaxError = nil; -- 1 if the command was a real command and the user passed missing/invalid arguments to it.
    local functionMissing = nil; -- 1 if command was provided good arguments, but the function itself to call did not exist !

    while ( continue ) do
        unknownHelp = nil;
        invalidHelp = nil;

        if ( level == 0 ) then
            -- Root level dude.
            unknownHelp = data.unknownHelp;
            levelData = data;
      else
            -- We're somewhere deep in the tree.
            unknownHelp = levelData.unknownHelp;
        end

        isValid = nil;
        continue = nil;

        for k, nodeData in ipairs(levelData) do
            if ( nodeData.input and inputPortions[level+1] ) and ( strlower(nodeData.input) == strlower(inputPortions[level+1]) ) then
                -- This command matches.
                isValid = 1;

                if ( nodeData.type == "COMMAND" or nodeData.type == "METHOD" ) then
                    local a;
                    local providedArgument = nil;
                    local awaiting = nil;

                    continue = nil;

                    -- It has initially a good syntax..
                    hasSyntaxError = nil;
                    invalidHelp = nodeData.invalidHelp;

                    for a=1, #nodeData.arguments do
                        awaiting = nodeData.arguments[a];
                        providedArgument = inputPortions[level+1+a];
                        
                        if ( awaiting == "number" ) and not ( tonumber(providedArgument) ) then
                            hasSyntaxError = 1;
                        end
                        if ( awaiting == "string" ) then
                            providedArgument = providedArgument or '';
                            if ( strlen( providedArgument ) <= 0 ) then
                                hasSyntaxError = 1;
                            end
                        end
                    end

                    -- The console system is strict; you can't pass more arguments than the function expects.
                    if ( (portions-level-1) > #nodeData.arguments ) then
                        hasSyntaxError = 1;
                    end

                    -- Ok, seems like it's safe to pass arguments to the func without making the system crashes :P
                    if not ( hasSyntaxError ) then
                        if ( nodeData.type == "COMMAND" ) then
                            local funcToCall = nodeData.call;
                            if ( type(funcToCall) == "string" ) then
                                funcToCall = getglobal(funcToCall);
                                if ( type(funcToCall) == "function" ) then
                                    -- Ok, prepare the arguments and deliver them to the function.
                                    -- Up to 5 arguments. It's enough for 99% of cases I guess ^_^'..
                                    funcToCall(inputPortions[level+2], inputPortions[level+3],inputPortions[level+4],inputPortions[level+5], inputPortions[level+6]);
                              else
                                    functionMissing = 1;
                                end
                          else
                                functionMissing = 1;
                            end
                    elseif ( nodeData.type == "METHOD" ) then
                            local funcToCall = nodeData.object[nodeData.call];
                            if ( type(funcToCall) == "function" ) then
                                funcToCall(nodeData.object, inputPortions[level+2], inputPortions[level+3], inputPortions[level+4], inputPortions[level+5], inputPortions[level+6]);
                          else
                                functionMissing = 1;
                            end
                        end
                    end

            elseif ( nodeData.type == "CATEGORY" ) then
                    continue = 1;
                    levelData = levelData[k];  -- Progress in the tree.
                    level = level + 1;
              else
                    -- Unknown type. Ignore & exit loop.
                    continue = nil;
                end

                break;
            end
        end

        if not ( isValid ) then
            continue = nil;
        end
    end

    -- STEP 4 - If enabled, tells the user anything that could have gone wrong.

    if ( feedback ) then
        local errorMessage = nil;

        if not ( isValid ) and ( unknownHelp ) then
            errorMessage = Root.Localise("Console-Unknown") .. unknownHelp;

    elseif ( hasSyntaxError ) and ( invalidHelp ) then
            errorMessage = Root.Localise("Console-BadSyntax") .. invalidHelp;

    elseif ( functionMissing ) then
            errorMessage = Root.Localise("Console-Broken");
        end

        if ( errorMessage ) then
            Root.Print(errorMessage, true);
        end
    end
end

-- ^^^^^^^^^^^^^^^^^^^^
-- B. Utility functions
-- vvvvvvvvvvvvvvvvvvvv

local modeTable = {
    [1] = "SELF",
    [2] = "GROUP",
    [3] = "GUILD",
    [4] = "OFFICER",
};

Console.PrintAuthorInfo = function(self)
    Root.Print(Root.Localise("Console-Author"));
end

Console.EnterAnchorMode = function(self)
    if InCombatLockdown() then return; end
    Engine:TriggerSpecialModule("AnchorMode");
end

Console.ExtractSpellID = function(self, spellLink)
    local _, _, spellString = string.find(spellLink, "^|c%x+|H(.+)|h%[.*%]");
    if ( spellString ) then
        local _, _, spellId = string.find(spellString, "^spell:(%d*)");
        if ( spellId ) then
            Root.Print("SPELL ID: "..spellId);
        end
    end
end

Console.ExtractNPCID = function(self)
    if ( not UnitExists("target") ) then return; end
    local guid = UnitGUID("target");
    if ( not guid ) then return; end
    local id = Root.Unit.GetMobID(guid);
    Root.Print("NPC ID: "..(id or "nil"));
end

local firstPointSet = { };
Console.GetMapDistance = function(self)
    local pX, pY = GetPlayerMapPosition("player");
    if ( pX == 0 and pY == 0 ) then
        Root.Print("You are not on a supported map.");
        return;
    end
    if ( firstPointSet.x ) and ( firstPointSet.y ) then
        distance = Root.MapDistance(firstPointSet.x, firstPointSet.y, pX, pY);
        firstPointSet.x = nil;
        firstPointSet.y = nil;
        Root.Print(string.format("The normalized map distance between these two points is: %.5f", distance));
  else
        if UnitExists("target") then
            if self:DeterminateMeterScale() then
                return;
            end
        end
        firstPointSet.x = pX;
        firstPointSet.y = pY;
        Root.Print("First point set. Move to the second point and use this command again.");
    end
end

local determinateSpellByClass = {
    ["DRUID"] = 5185,
    ["PRIEST"] = 2060,
    ["SHAMAN"] = 331,
    ["PALADIN"] = 635,
};

Console.DeterminateMeterScale = function(self)
    local class = select(2, UnitClass("player"));
    local spell = determinateSpellByClass[class];
    if ( not spell ) then return false; end

    local started = Distance:Determinate(spell);
    if ( started ) then
        Root.Print("Get out of range of your target, then get back in range as slowly with the best framerate as possible. Make sure you are on a plane surface.");
  else
        Root.Print("Cannot start the determination system yet.");
    end
    return true;
end

Console.WipeAllData = function(self, confirmed)
    if ( confirmed ) then
        Root.Save.Clear();
        ReloadUI();
  else
        StaticPopup_Show("BE2_WIPE_ALL_DATA");
    end
end

Console.DoVersionCheck = function(self, recipient)
    local upper = string.upper(recipient);
    local guild = Root.Localise("Console-VersionGuild");
    local group = Root.Localise("Console-VersionGroup");

    if ( upper == guild ) then
        recipient = "GUILD";
elseif ( upper == group ) then
        recipient = "GROUP";
  else
        -- It is probably a player name.
    end

    local okay = Version:Query(recipient);
    if ( okay ) then
        Root.Print(Root.Localise("Console-VersionQueryStarted"), true);
  else
        Root.Print(Root.Localise("Console-VersionQueryForbidden"), true);
    end
end

Console.ReplayLastSequence = function(self)
    local name = EncounterStats:GetCurrentInfo();
    if ( name ) then
        if ( not Root.Encounter.GetActiveModule() ) then
            Manager:GetResultSequence():Play();
        end
  else
        Root.Print(Root.Localise("Console-NoSequenceReplay"), true);
    end
end

Console.PrintLastDPS = function(self, mode)
    local name, _, _, _, _, _, _, _, _, _, dps = EncounterStats:GetCurrentInfo();
    if ( name and dps ) then
        local tryNumber = tonumber(mode);
        if tryNumber then mode = tryNumber; end

        EncounterStats:PrintDPSToChat(dps, modeTable[mode or 1] or mode or "SELF");
  else
        Root.Print(Root.Localise("Console-NoSequenceReplay"), true);
    end
end

Console.StartAddon = function(self)
    GlobalOptions.settingsValue["AddonEnabled"] = true;
    GlobalOptions:OnSettingChanged("AddonEnabled");
end

Console.StopAddon = function(self)
    GlobalOptions.settingsValue["AddonEnabled"] = false;
    GlobalOptions:OnSettingChanged("AddonEnabled");
end

-- ^^^^^^^^^^^^^^^^^^^^^^^^
-- C. Development functions
-- vvvvvvvvvvvvvvvvvvvvvvvv

Console.DevelopmentNew = function(self)
    Engine:TriggerSpecialModule("Development", "target");
end

Console.DevelopmentGet = function(self, id)
    id = tonumber(id) or 0;
    local mod = Root["Development"];
    if ( id == 0 ) then
        mod:ListSamples();
  else
        mod:ReadSample(id);
    end
end

Console.DevelopmentDelete = function(self, id)
    id = tonumber(id) or 0;
    local mod = Root["Development"];
    mod:DeleteSample(id);
end

-- ^^^^^^^^^^^^^^^^^^^^^^^^^
-- D. Music plugin functions
-- vvvvvvvvvvvvvvvvvvvvvvvvv

Console.MusicPluginExplain = function(self)
    local num = Root.Music.GetNumPlugins();
    if ( num > 0 ) then
        StaticPopup_Show("BE2_MUSICPLUGIN_USAGE", num);
  else
        StaticPopup_Show("BE2_MUSICPLUGIN_NOPLUGIN");
    end
end

Console.MusicPluginList = function(self)
    local num = Root.Music.GetNumPlugins();
    local i, id, name, folder, numSongs, author, version;
    Root.Print(Root.FormatLoc("Console-MusicPluginListHeader", num), true);
    for i=1, num do
        id, name, folder, numSongs, author, version, deprecated = Root.Music.GetPluginInfo(i);
        Root.Print(Root.FormatLoc("Console-MusicPluginListEntry", id, name, version, numSongs, author), true);
    end
end

Console.MusicPluginActivate = function(self, id)
    id = tonumber(id) or 1;
    local success = Root.Music.ActivatePlugin(id);
    if ( success ) then
        local id, name = Root.Music.GetPluginInfo(id);
        Root.Print(Root.FormatLoc("Console-MusicPluginActivateSuccess", id, name), true);
        Root.Save.Set("config", "lastMusicPlugin", id);
  else
        Root.Print(Root.Localise("Console-MusicPluginActivateFailure"), true);
    end
end

-- ^^^^^^^^^^^^^^^^^^^^^^
-- E. Enchanter functions
-- vvvvvvvvvvvvvvvvvvvvvv

Console.PrintEnchanter = function(self)
    local num = LootHelper:GetNumEnchanters();
    local i, name;
    Root.Print(Root.FormatLoc("Console-EnchantList", num), true);
    for i=1, num do
        name = LootHelper:GetEnchanterName(i);
        Root.Print(string.format("%d. %s", i, name), true);
    end
end

Console.AddEnchanter = function(self, input)
    local result, name = LootHelper:AddEnchanter(input);
    if ( result == -1 ) then
        Root.Print(Root.Localise("Console-EnchantTargetError"), true);
elseif ( result ==  0 ) then
        Root.Print(Root.FormatLoc("Console-EnchantAddFailure", name), true);
elseif ( result ==  1 ) then
        Root.Print(Root.FormatLoc("Console-EnchantAddSuccess", name), true);
    end
end

Console.RemoveEnchanter = function(self, input)
    local ID = tonumber(input);
    if ( ID ) then input = ID; end

    local result, name = LootHelper:RemoveEnchanter(input);
    if ( result == -1 ) then
        Root.Print(Root.Localise("Console-EnchantTargetError"), true);
elseif ( result ==  0 ) then
        Root.Print(Root.FormatLoc("Console-EnchantRemoveFailure", name), true);
elseif ( result ==  1 ) then
        Root.Print(Root.FormatLoc("Console-EnchantRemoveSuccess", name), true);
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

Console.OnStart = function(self)
    -- Register slash commands
    SlashCmdList["BOSSENCOUNTER"] = Console.OnSlashCommand;
    SLASH_BOSSENCOUNTER1 = "/BossEncounter2"; -- Nevermind the "2": The original BossEncounter never had a console interpreter.
    SLASH_BOSSENCOUNTER2 = "/BossEncounter";
    SLASH_BOSSENCOUNTER3 = "/BE2";
    SLASH_BOSSENCOUNTER4 = "/BE";

    -- Register some static popups

    StaticPopupDialogs["BE2_WIPE_ALL_DATA"] = {
	text = Root.Localise("Console-WipeAllData"),
	button1 = YES,
	button2 = NO,
	timeout = 0,
	showAlert = 1,
	whileDead = 1,
	OnAccept = function(self) Console:WipeAllData(true); end,
    };
end

Console.OnSlashCommand = function(msg)
    Console:Execute(msg, true);
end
