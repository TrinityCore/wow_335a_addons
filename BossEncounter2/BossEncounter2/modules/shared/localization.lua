local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- =======================================================================================
    -- Localize a string. This method looks into the private localization table of the module.
    -- If the localization is not found, then the global localization table is used.
    -- =======================================================================================

    Localize = function(self, key)
        -- Try the module's private localization table.
        local localeTable = self.localization;

        if type(localeTable) == "table" then
            local myLocale = localeTable[GetLocale()];
            local defaultLocale = localeTable["default"];

            if ( myLocale ) and ( myLocale[key] ) then
                return myLocale[key];
          else
                if ( defaultLocale ) and ( defaultLocale[key] ) then
                    return defaultLocale[key];
                end
            end
        end

        -- Past this point asks the root localization system in no error mode, to assure a string-type return value.
        return Root.Localize(key, true);
    end,

    -- ===================================
    -- Localize + format at the same time.
    -- ===================================

    FormatLoc = function(self, key, ...)
        return string.format(self:Localize(key), ...);
    end,
};

-- Mirror methods for convenience

me.Localise = me.Localize;

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");