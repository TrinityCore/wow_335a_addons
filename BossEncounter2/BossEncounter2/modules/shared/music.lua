local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ======================================================
    -- Should be called to change music DURING the encounter.
    -- This method makes sure to not interrupt near victory
    -- or last minute themes.
    -- ======================================================

    ChangeMusic = function(self, theme)
        local nearVictory = self.data.nearVictory;
        if ( nearVictory ) then
            if ( nearVictory.triggered ) then return; end -- Special theme is playing. Abort.
        end
        Root.Music.Play(theme);
    end,

    -- ============================================================
    -- Set the condition on boss health, time passed and portion of
    -- raid alive to play Near Victory special theme in the fight
    -- ============================================================

    SetNearVictoryThreshold = function(self, healthFraction, timeThreshold, raidFraction)
        self.data.nearVictory = {
            health = healthFraction or 0.10,
            timeThreshold = timeThreshold or nil,
            raidFraction = raidFraction or 0.50,
            triggered = false,
        };
    end,

    -- =========================================================
    -- Check if conditions to trigger Near Victory theme are met
    -- =========================================================

    CheckNearVictory = function(self, healthFraction)
        local data = self.data;
        local nearVictory = data.nearVictory;

        if ( nearVictory ) then
           if ( healthFraction < nearVictory.health ) and ( not nearVictory.triggered ) then
                nearVictory.triggered = true;

                local okay = true;
                local raidFraction = self:CountNumValidMembers() / (data.startingPlayers or 1);

                if ( nearVictory.raidFraction ) and ( raidFraction < nearVictory.raidFraction ) then okay = false; end
                if ( nearVictory.timeThreshold ) and ( data.globalTimer > nearVictory.timeThreshold ) then okay = false; end

                if ( okay ) then
                    -- Almost won ! =)
                    Root.Music.Play("VICTORYNEAR");
                end
            end
        end
    end,

    -- ===============================
    -- Trigger the "last minute" theme
    -- ===============================

    TriggerLastMinuteTheme = function(self)
        local data = self.data;
        local nearVictory = data.nearVictory;

        if ( nearVictory ) then
            if ( nearVictory.triggered ) then return; end -- The last minute theme is exclusive with the near victory theme.
            nearVictory.triggered = true; -- Block the near victory theme if it were to occur after the last minute theme is fired.
        end

        -- The theme will be played for its full duration plus 5 safety seconds before switching to silence.
        Root.Music.Play("LASTMINUTE", Root.Music.GetLastMinuteThemeDuration() + 5);
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");