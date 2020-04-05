local Root = BossEncounter2;
local Manager = Root.GetOrNewModule("Manager");
local GlobalOptions = Root.GetOrNewModule("GlobalOptions");

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ==============================================================================================
    -- Set the difficulty meter. Each critera must be between 0-1.
    -- Power: the overall difficulty of the fight (tanking/dps/healing).
    -- Burst: evaluation of the burst involved (critical situations).
    -- AoE: evaluation of AoE damage on the raid.
    -- Chaos: evaluation of how messy a fight appears (lots of movement, adds, unpredictable things).
    -- Skill: the skill required by the raid as a whole.
    -- ==============================================================================================

    SetDifficultyMeter = function(self, power, burst, aoe, chaos, skill) -- P/B/A/C/S
        self.data.difficulty = {
            POWER = power,
            BURST = burst,
            AOE = aoe,
            CHAOS = chaos,
            SKILL = skill,
        };
    end,

    -- ====================================================================
    -- Get the value of one of the difficulty meter's criterias. See above.
    -- ====================================================================

    GetDifficultyMeter = function(self, criteria)
        if ( not self.data ) then return nil; end
        if type(self.data.difficulty) ~= "table" then return nil; end
        if ( criteria ) then
            return self.data.difficulty[criteria] or 0;
      else
            return self.data.difficulty;
        end
    end,

    -- =================================
    -- Open the difficulty meter window.
    -- =================================

    OpenDifficultyMeter = function(self)
        if ( not GlobalOptions:GetSetting("ShowDifficultyMeter") ) then return; end
        if type(self:GetDifficultyMeter()) ~= "table" then return; end
        local DM = Manager:GetDifficultyMeter();
        if type(DM) ~= "table" then return; end
        DM:Open(self);
    end,

    -- ==================================
    -- Close the difficulty meter window.
    -- ==================================

    CloseDifficultyMeter = function(self, atOnce)
        local DM = Manager:GetDifficultyMeter();
        if type(DM) ~= "table" then return; end
        DM:Close(atOnce);
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");