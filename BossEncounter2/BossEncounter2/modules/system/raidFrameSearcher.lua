local Root = BossEncounter2;

local RaidFrameSearcher = Root.GetOrNewModule("RaidFrameSearcher");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A functionnal module that determinates the raid frame that represents
-- a given character, taking in account some of the most popular frame AddOns.

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local function frameMatch(frame, name)
    if type(frame.numPulloutButtons) == "number" and frame:IsVisible() then
        local i, button;
        for i=1, frame.numPulloutButtons do
            button = frame.buttons[i];
            if ( UnitName(button.unit) == name ) then
                return true, button;
            end
        end
    end
    return false, nil;
end

-- INFO:
-- Put first healer specialized Addons, then generic unit frames Addons, then FrameXML.

local ADDONS = {
    { -- HealBot
        name = "HealBot",
        check = function()
            if type(HealBot_Action_HealUnit1) == "table" then
                return true;
            end
            return false;
        end,
        searcher = function(guid, name)
            local i;
            for i=1, 51 do
                b=getglobal("HealBot_Action_HealUnit"..i);
                if ( b ) and ( b:IsVisible() ) and ( b.guid == guid ) then
                    return b;
                end
            end
            return nil;
	end,
        offsetX = 0, offsetY = 0,
        expandX = 1, expandY = 1,
        layout = nil, -- Nil enforces no specific layout.
    },

    { -- Grid2 (go figure out why Grid2 is (almost) exactly the same as Grid with the "2" in addition...)
        name = "Grid2",
        check = function()
            if type(Grid2Frame) == "table" then
                return true;
            end
            return false;
        end,
        searcher = function(guid, name)
            local frame;
	    for _, frame in pairs(Grid2Frame.registeredFrames) do
                if ( frame:IsVisible() ) and ( frame.unitGUID == guid ) then
                    return frame;
                end
            end
            return nil;
	end,
        offsetX = 0, offsetY = 0,
        expandX = 6, expandY = 6,
        layout = nil, -- Nil enforces no specific layout.
    },

    { -- Grid
        name = "Grid",
        check = function()
            if type(GridFrame) == "table" then
                return true;
            end
            return false;
        end,
        searcher = function(guid, name)
            local frame;
	    for _, frame in pairs(GridFrame.registeredFrames) do
                if ( frame.frame:IsVisible() ) and ( frame.unitGUID == guid ) then
                    return frame.frame;
                end
            end
            return nil;
	end,
        offsetX = 0, offsetY = 0,
        expandX = 1, expandY = 1,
        layout = nil, -- Nil enforces no specific layout.
    },

    { -- X-Perl raid frames
        name = "X-Perl",
        check = function()
            if type(XPerl_Raid_GetUnitFrameByGUID) == "function" then
                return true;
            end
            return false;
        end,
        searcher = function(guid, name)
            return XPerl_Raid_GetUnitFrameByGUID(guid);
        end,
        offsetX = 0, offsetY = 0,
        expandX = 8, expandY = 8,
        layout = nil, -- Nil enforces no specific layout.
    },

    { -- Blizzard UI. **SHOULD ALWAYS BE LAST!!**
        name = "FrameXML",
        check = function() return true; end,
        searcher = function(guid, name)
            local i, pulloutFrame, flag, button;

            if type(NUM_RAID_PULLOUT_FRAMES) ~= "number" then return nil; end

            -- First check single frames.
            for i=1, NUM_RAID_PULLOUT_FRAMES do
                pulloutFrame = _G["RaidPullout"..i];
                if ( pulloutFrame.single ) then
                    flag, button = frameMatch(pulloutFrame, name);
                    if ( flag ) then return button; end
                end
            end

            -- Then check party frames.
            for i=1, NUM_RAID_PULLOUT_FRAMES do
                pulloutFrame = _G["RaidPullout"..i];
                if ( not pulloutFrame.single ) then
                    flag, button = frameMatch(pulloutFrame, name);
                    if ( flag ) then return button; end
                end
            end

            return nil;
        end,
        offsetX = 0, offsetY = 2,
        expandX = 8, expandY = 8,
        layout = nil, -- Nil enforces no specific layout.
    },
}

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * RaidFrameSearcher:SearchFrame(guid)                              *
-- ********************************************************************
-- * >> guid: the GUID of the unit whose frame is to be anchored.     *
-- ********************************************************************
-- * Find the raid frame that represents the given unit.              *
-- * Takes in account some of the most popular frame AddOns.          *
-- ********************************************************************

RaidFrameSearcher.SearchFrame = function(self, guid)
    -- First get the unit name.

    local uid = Root.Unit.GetUID(guid);
    if ( not uid ) then return nil; end

    local name = UnitName(uid);
    if ( not name ) then return nil; end

    -- Now look for frame Addons installed. If none is found, we will use Blizzard frames instead.

    local i, frame, offsetX, offsetY, expandX, expandY, layout;
    frame = nil;
    for i=1, #ADDONS do
        if ( not frame ) and ADDONS[i].check() then
            frame = ADDONS[i].searcher(guid, name);
            if ( frame ) then
                offsetX, offsetY, expandX, expandY, layout = ADDONS[i].offsetX, ADDONS[i].offsetY, ADDONS[i].expandX, ADDONS[i].expandY, ADDONS[i].layout;
            end
        end
    end
    return frame, offsetX, offsetY, expandX, expandY, layout;
end

-- ********************************************************************
-- * RaidFrameSearcher:Test(guid)                                     *
-- ********************************************************************
-- * >> guid: the GUID of the unit tested.                            *
-- ********************************************************************
-- * Find the raid frame that represents the given unit.              *
-- * Make this raid flame flashes for a few seconds0                  *
-- ********************************************************************

RaidFrameSearcher.Test = function(self, guid)
    if ( self.flashStopTime ) then return; end

    local f = self:SearchFrame(guid);
    if type(f) == "table" then
        self.flashFrame = f;
        self.flashStopTime = GetTime() + 3;
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

RaidFrameSearcher.OnUpdate = function(self, elapsed)
    if ( self.flashStopTime ) then
        if GetTime() > self.flashStopTime then
            self.flashFrame:SetAlpha(1);
            self.flashFrame = nil;
            self.flashStopTime = nil;
      else
            self.flashFrame:SetAlpha(0.5 + sin(GetTime()*360) * 0.4);
        end
    end
end

