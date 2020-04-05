local Root = BossEncounter2;

Root.Save = { };

-- --------------------------------------------------------------------
-- **                    Saved variables data                        **
-- --------------------------------------------------------------------

local modifiedProfile = "none";

local DefaultSavedVariables = {
    ["anchor"] = {

    },

    ["config"] = {
        ["lastMusicPlugin"] = 1,
        ["enchanters"] = nil,
    },

    ["record"] = {
        ["encounter"] = { },
    },

    ["dev"] = {
        num = 0,
    },

    ["profiles"] = {},

    ["version"] = 1.000,
};

local SavedVariablesGlobalName = "BossEncounter2_SavedVariables";

setglobal(SavedVariablesGlobalName, {});
local SavedVariables = getglobal(SavedVariablesGlobalName);

-- --------------------------------------------------------------------
-- **                   SavedVariables functions                     **
-- --------------------------------------------------------------------

-- *** Saved vars basic operations and management ***

-- ********************************************************************
-- * Root -> Save -> Get(part, key, profileMode)                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> part: which side of sVars the data to fetch is stored into.   *
-- * >> key: what data to retrieve. If it is not found on SavedVars   *
-- * table, we will search into DefaultSavedVars. If still not        *
-- * found, nil will be returned.                                     *
-- * >> profileMode: whether this data can be character specific or   *
-- * not. You can provide nil, "none", "active" or "modified". If     *
-- * "active" is provided, the data will be read for the currently    *
-- * logged-in character. If "modified" is provided, the data will be *
-- * read for the currently edited character profile.                 *
-- ********************************************************************
-- * Returns a saved variable value (a variable which is "remembered" *
-- * between each game session).                                      *
-- ********************************************************************

function Root.Save.Get(part, key, profileMode)
    local partdata = SavedVariables[part];
    local defaultpartdata = DefaultSavedVariables[part];

    if ( partdata ) then
        if ( profileMode == "active" or profileMode == "modified" ) then
            local name, server, prefix;
            if ( profileMode == "active" ) then
                name, server, prefix = Root.Save.GetActiveProfile();
          else
                name, server, prefix = Root.Save.GetModifiedProfile();
            end
            if ( partdata[prefix..key] ) then
                return partdata[prefix..key];
            end
        end
        if ( partdata[key] ) then
            return partdata[key];
        end
    end

    if ( defaultpartdata ) and ( defaultpartdata[key] ) then
        return defaultpartdata[key];
    end

    return nil;
end

-- ********************************************************************
-- * Root -> Save -> Set(part, key, value, profileMode)               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> part: which side of sVars the data to set is stored into.     *
-- * >> key: where to store data.                                     *
-- * >> value: self-explanatory.                                      *
-- * >> profileMode: whether the modified data is character specific  *
-- * or not. You can provide nil, "none", "active" or "modified". If  *
-- * "active" is provided, the data will be set for the currently     *
-- * logged-in character. If "modified" is provided, the data will be *
-- * set for the currently edited character profile.                  *
-- ********************************************************************
-- * Changes a saved variable value.                                  *
-- ********************************************************************

function Root.Save.Set(part, key, value, profileMode)
    if not ( SavedVariables[part] ) then SavedVariables[part] = {}; end
    if ( profileMode == "active" or profileMode == "modified" ) then
        local name, server, prefix;
        if ( profileMode == "active" ) then
            name, server, prefix = Root.Save.GetActiveProfile();
      else
            name, server, prefix = Root.Save.GetModifiedProfile();
        end
        SavedVariables[part][prefix..key] = value;
  else
        SavedVariables[part][key] = value;
    end
    return 1;
end

-- ********************************************************************
-- * Root -> Save -> GetDefault(part, key)                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> part: which side of sVars the data to fetch is stored into.   *
-- * >> key: what data to retrieve.                                   *
-- ********************************************************************
-- * Returns the default value of a saved variable.                   *
-- ********************************************************************

function Root.Save.GetDefault(part, key)
    local defaultpartdata = DefaultSavedVariables[part];
    if ( defaultpartdata ) and ( defaultpartdata[key] ) then
        return defaultpartdata[key];
    end
    return nil;
end

-- ********************************************************************
-- * Root -> Save -> CheckVersion()                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * None                                                             *
-- ********************************************************************
-- * Compares saved variables defaults' version with saved variables' *
-- * version. If there is a difference, clear saved variables and     *
-- * return 1.                                                        *
-- ********************************************************************

function Root.Save.CheckVersion()
    SavedVariables = getglobal(SavedVariablesGlobalName);

    local currentVersion = DefaultSavedVariables.version;
    local savedVersion = SavedVariables.version;

    if not ( currentVersion ) then
        return nil;
    end

    if not ( savedVersion ) then
        -- Saved variables table has been formatted. This should occur the first time the mod is run.
        SavedVariables = {
            version = currentVersion,
        };
        setglobal(SavedVariablesGlobalName, SavedVariables);
        return nil;
  else
        if ( savedVersion ~= currentVersion ) then
            -- Reformats saved variables table, coz' version has changed.
            SavedVariables = {
                version = currentVersion,
            };
            setglobal(SavedVariablesGlobalName, SavedVariables);
            -- And also informs the caller.
            return 1;
        end
    end

    return nil;
end

-- ********************************************************************
-- * Root -> Save -> Clear()                                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * N/A                                                              *
-- ********************************************************************
-- * Clear all saved variables and formats a new saved vars table.    *
-- ********************************************************************

function Root.Save.Clear()
    SavedVariables = { };
    setglobal(SavedVariablesGlobalName, SavedVariables);
    Root.Save.CheckVersion();
end

-- *** Profile management ***

-- ********************************************************************
-- * Root -> Save -> GetActiveProfile()                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * N/A                                                              *
-- ********************************************************************
-- * Get the profile which will be used for the profile mode "active" *
-- * in saved vars read/write accesses.                               *
-- * Returns name, server and prefix.                                 *
-- ********************************************************************

function Root.Save.GetActiveProfile()
    local name = UnitName("player");
    local server = GetRealmName();
    local prefix = name.."/"..server.."|";
    return name, server, prefix;
end

-- ********************************************************************
-- * Root -> Save -> GetModifiedProfile()                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * N/A                                                              *
-- ********************************************************************
-- * Get the profile which will be used for the profile mode          *
-- * "modified" in saved vars read/write accesses.                    *
-- * Returns name, server and prefix. It will be the active profile   *
-- * if not specifically changed since the login on the game server.  *
-- ********************************************************************

function Root.Save.GetModifiedProfile()
    if ( type(modifiedProfile) == "number" ) then
        modifiedProfile = math.floor(modifiedProfile);
        if ( modifiedProfile > 0 and modifiedProfile <= Root.Save.GetNumProfiles() ) then
            return Root.Save.GetProfileInfo(modifiedProfile);
        end
    end

    if ( type(modifiedProfile) == "string" ) and ( modifiedProfile ~= "none" ) then
        local _, _, name, server = string.find(modifiedProfile, "(.+)%/(.+)");
        if ( name and server ) then
            return name, server, name.."/"..server.."|";
        end
    end

    return Root.Save.GetActiveProfile();
end

-- ********************************************************************
-- * Root -> Save -> SetModifiedProfile(index)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> index: the index in the profile list. You can also provide    *
-- * a string of the format "NNNNN/SSSSS" where NNNNN is the name of  *
-- * the character and SSSSS its realm.                               *
-- ********************************************************************
-- * Set the profile which will be used for savedvars write accesses. *
-- * Returns 1 if the modified profile has been successfully changed. *
-- ********************************************************************

function Root.Save.SetModifiedProfile(index)
    if ( type(index) == "string" ) then
        local _, _, name, server = string.find(index, "(.+)%/(.+)");
        if ( name and server ) then
            modifiedProfile = name.."/"..server;
            return 1;
        end
    end

    if ( type(index) == "number" ) then
        index = math.floor(index);
        if ( index > 0 and index <= Root.Save.GetNumProfiles() ) then
            modifiedProfile = index;
            return 1;
        end
    end

    return nil;
end

-- ********************************************************************
-- * Root -> Save -> GetNumProfiles()                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the number of profiles known by the mod.                     *
-- ********************************************************************

function Root.Save.GetNumProfiles()
    if not ( SavedVariables["profiles"] ) then SavedVariables["profiles"] = {}; end
    return #SavedVariables["profiles"];
end

-- ********************************************************************
-- * Root -> Save -> GetProfileInfo(index)                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> index: the index in the profile list.                         *
-- ********************************************************************
-- * Get info about one of the known profiles.                        *
-- ********************************************************************

function Root.Save.GetProfileInfo(index)
    if ( type(index) == "number" ) then
        index = math.floor(index);
        if ( index > 0 and index <= Root.Save.GetNumProfiles() ) then
            local profileString = SavedVariables["profiles"][index];
            local _, _, name, server = string.find(profileString, "(.+)%/(.+)");
            if ( name and server ) then
                return name, server, name.."/"..server.."|";
            end
        end
    end

    return "INVALID", "INVALID", "?/?|";
end

-- ********************************************************************
-- * Root -> Save -> UpdateProfile()                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Ensure active character is in the profile list. This API should  *
-- * be called once at startup of any game session.                   *
-- * Returns 1 if the active character profile has been created.      *
-- * In this case, the second return is the name of the character     *
-- * whose profile just got created.                                  *
-- ********************************************************************

function Root.Save.UpdateProfile()
    local name, server, _ = Root.Save.GetActiveProfile();
    local p, pName, pServer;
    for p=1, Root.Save.GetNumProfiles() do
        pName, pServer, _ = Root.Save.GetProfileInfo(p);
        if ( pName == name and pServer == server ) then
            return nil;
        end
    end
    SavedVariables["profiles"][#SavedVariables["profiles"] + 1] = name.."/"..server;
    return 1, string.format("%s (%s)", name, server);
end