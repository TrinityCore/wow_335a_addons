local Root = BossEncounter2;

Root.Music = { };

local Music = Root["Music"];

Music.folder = Root.folder.."bgm\\";

-- --------------------------------------------------------------------
-- **                             Data                               **
-- --------------------------------------------------------------------

local musics = {
    ["SILENCE"] = Music.folder.."Silence.mp3",
    ["MINICLEAR"] = Music.folder.."Clear_Mini.mp3",
    ["NORMALCLEAR"] = Music.folder.."Clear_Normal.mp3",
    ["RAIDCLEAR"] = Music.folder.."Clear_Raid.mp3",
    ["FINALCLEAR"] = Music.folder.."Clear_Final.mp3",
};

local plugins = { };
local currentPlugin = nil;

local metaFields = { -- Meta fields are fields that are to be ignored when parsing a music plugin table. Those aren't counted as songs.
    ["name"] = true,
    ["folder"] = true,
    ["author"] = true,
    ["version"] = true,
    ["lastMinuteThemeDuration"] = true,
    -- Meta fields added at runtime:
    ["songs"] = true,
    ["deprecated"] = true,
};

local songList = {};

-- Will only track musics started by BossEncounter2.
-- Will not interrupt musics initiated by other means except
-- if the foreign PlayMusic was issued while we were expecting
-- a BossEncounter2 music playing.

local musicPlaying = false;
local musicDuration = 0;
local musicStart = 0;

local lastMinuteThemeDuration = 60;

-- --------------------------------------------------------------------
-- **                              API                               **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> Music -> Play(name, duration)                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the music to start, from the list above.    *
-- * >> duration: the amount of time the music should be playing.     *
-- * Once the amount of time is elapsed, it will switch to a          *
-- * persistent silence till the Stop API is used.                    *
-- ********************************************************************
-- * Plays a music.                                                   *
-- * If it is not found or for some reason can't be played, nil is    *
-- * returned; 1 elsewise is.                                         *
-- ********************************************************************
function Root.Music.Play(name, duration)
    local filename = musics[name];
    if ( filename ) then
        local success = PlayMusic(filename);
        if ( success == 1 ) then -- Seems bugged. Always return 1.
            musicPlaying = true;
            musicDuration = duration or 0;
            musicStart = GetTime();
        end
        return success;
    end
    return nil;
end

-- ********************************************************************
-- * Root -> Music -> Stop()                                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * N/A                                                              *
-- ********************************************************************
-- * Stops the currently played music.                                *
-- ********************************************************************
function Root.Music.Stop()
    if ( not musicPlaying ) then return; end
    musicPlaying = false;
    StopMusic();
end

-- ********************************************************************
-- * Root -> Music -> Merge(themeTable)                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> themeTable: the table associating music name <-> music file   *
-- * to be added to the global music list.                            *
-- ********************************************************************
-- * Complete the global music list with a custom music list.         *
-- * If a music exists in both the global and the theme tables, the   *
-- * theme table version will be kept.                                *
-- ********************************************************************
function Root.Music.Merge(themeTable)
    if type(themeTable) ~= "table" then return; end

    -- Count the number of songs and determinate if this plugin is deprecated.
    local field, value, songs, deprecated;
    songs = 0;
    deprecated = true;
    wipe(songList);
    for field, value in pairs(themeTable) do
        if type(field) == "string" then
            if ( not metaFields[field] ) then
                songList[value] = true;
          else
                if ( field == "folder" ) then
                    deprecated = false;
                end
            end
        end
    end
    for field in pairs(songList) do
        songs = songs + 1;
    end
    themeTable.songs = songs;
    themeTable.deprecated = deprecated;

    plugins[#plugins+1] = themeTable;

    if ( not currentPlugin ) then
        Root.Music.ActivatePlugin(1);
    end
end

-- ********************************************************************
-- * Root -> Music -> GetLastMinuteThemeDuration()                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the duration of the last minute theme currently loaded, so   *
-- * as to keep it nicely synchronized with the berserk timer.        *
-- ********************************************************************
function Root.Music.GetLastMinuteThemeDuration()
    return lastMinuteThemeDuration;
end

-- ********************************************************************
-- * Root -> Music -> GetNumPlugins()                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Returns the number of currently loaded music plugins.            *
-- ********************************************************************
function Root.Music.GetNumPlugins()
    return #plugins;
end

-- ********************************************************************
-- * Root -> Music -> GetPluginInfo(id)                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> id: the ID of the plugin.                                     *
-- * Provide "active" for the currently active plugin.                *
-- ********************************************************************
-- * Returns info about a plugin.                                     *
-- * Returns ID, name, numSongs, author, version, deprecated.         *
-- ********************************************************************
function Root.Music.GetPluginInfo(id)
    if ( id == "active" ) then
        return Root.Music.GetPluginInfo(currentPlugin);
  elseif type(id) == "number" then
        local plugin = plugins[id];
        if type(plugin) == "table" then
            return id, Root.ReadLocTable(plugin.name) or "???", plugin.folder or "", plugin.songs or 0, plugin.author or "?", plugin.version or 1, plugin.deprecated;
        end
    end
    return nil, nil, 0, "", 0, false;
end

-- ********************************************************************
-- * Root -> Music -> ActivatePlugin(id)                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> id: the ID of the plugin to activate.                         *
-- ********************************************************************
-- * Complete the global music list with a custom music list.         *
-- * If a music exists in both the global and the theme tables, the   *
-- * theme table version will be kept.                                *
-- ********************************************************************
function Root.Music.ActivatePlugin(id)
    local themeTable = plugins[id];
    if type(themeTable) ~= "table" then return false; end

    currentPlugin = id;

    local folder = select(3, Root.Music.GetPluginInfo(id));
    local name, filename;
    for name, filename in pairs(themeTable) do
        if type(name) == "string" then
            if ( not metaFields[name] ) then
                if ( folder == "" ) then
                    -- Old system using the plugin folder.
                    musics[name] = Music.folder..filename;
              else
                    -- Separate Addon system.
                    musics[name] = folder..filename;
                end

                if name == "LASTMINUTE" then
                    lastMinuteThemeDuration = themeTable["lastMinuteThemeDuration"] or 60;
                end
            end
        end
    end

    Root.Music.Stop();
    return true;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

Root.Music.OnUpdate = function(self, elapsed)
    if musicPlaying and musicDuration > 0 then
        if (GetTime() - musicStart) > musicDuration then
            -- Stop the music and prevent normal music from resuming by issuing the Silence music.
            if ( not Root.Music.Play("SILENCE") ) then
                -- In case Silence music is not available, we stop the music.
                Root.Music.Stop();
            end
        end
    end
end;