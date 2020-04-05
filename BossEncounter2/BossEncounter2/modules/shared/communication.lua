local Root = BossEncounter2;
local Manager = Root.GetOrNewModule("Manager");
local EncounterStats = Root.GetOrNewModule("EncounterStats");
local GlobalOptions = Root.GetOrNewModule("GlobalOptions");

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ==================================================
    -- Send a raid warning. You must have the permission.
    -- It will be displayed on party chat in a party.
    -- ==================================================

    AnnounceToRaid = function(self, message)
        if ( Root.CheckAuth("WARNING") ) then
            if ( GetNumRaidMembers() == 0 ) then
                -- We are issuing a warning in a party. Redirect the warning to the normal chat because raid alerts are no longer allowed in a party.
                SendChatMessage(message, "PARTY", nil, nil);
          else
                SendChatMessage(message, "RAID_WARNING", nil, nil);
            end
        end
    end,

    -- ================================================================================================
    -- Send a raid warning enumerating a list of people. Optionnally symbols can be put on each person.
    -- Once again, you must have the authorization to send the warning.
    -- ================================================================================================

    AnnounceUnitList = function(self, tbl, useSymbols, header, symbolRemoveTimer)
        -- Try to downgrade stuff if we do not have the required permissions.
        if ( useSymbols ) and ( not Root.CheckAuth("SYMBOL") ) then
            self:AnnounceUnitList(tbl, false, header, symbolRemoveTimer);
            return;
        end
        if ( not useSymbols ) and ( not Root.CheckAuth("WARNING") ) then
            return;
        end

        -- OK, we have permission for what we want to do.

        if type(header) == "string" then self:AnnounceToRaid(header); end

        local list = "";
        local i, uid, name, count;
        count = 0;

        for i=1, #tbl do
            uid = Root.Unit.GetUID(tbl[i]);
            if ( uid ) and ( count < 5 ) then
                name = UnitName(uid) or "?";
                count = count + 1;

                if ( useSymbols ) then
                    name = string.format("{rt%d} %s", count, name);
                    self:PlaceSymbol(uid, count, symbolRemoveTimer);
              else
                    name = string.format("%s", name);
                end

                if ( list == "" ) then
                    list = name;
              else
                    list = list .. " || " .. name;
                end
            end
        end

        list = ">> " .. list .. " <<";
        self:AnnounceToRaid(list);
    end,

    -- ====================================================================
    -- Clear all symbols in sight. If a mob is not selected,
    -- it may be not possible to remove its symbol. Authorization required.
    -- ====================================================================

    ClearSymbols = function(self)
        if ( not Root.CheckAuth("SYMBOL") ) then return; end
        local i, guid, name;
        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            self:PlaceSymbol(guid, 0);
        end
    end,

    -- ==================================================================
    -- Place a symbol on someone. Target can be an UID, a GUID or a name.
    -- Authorization required.
    -- ==================================================================

    PlaceSymbol = function(self, target, symbol, autoRemoveTimer)
        if ( not Root.CheckAuth("SYMBOL") ) or ( not target ) then return; end
        symbol = symbol or 0;
        local uid;
        if ( not UnitExists(target) ) then
            -- Invalid UID. Check if it's a GUID or name we have to map to a valid UID.
            uid = Root.Unit.GetUID(target);
      else
            uid = target;
        end
        if ( uid ) then
            if ( GetRaidTargetIndex(uid) ~= symbol ) then
                SetRaidTarget(uid, symbol);
            end
            if type(autoRemoveTimer) == "number" and self.EventWatcher then
                local guid = UnitGUID(uid);
                local ID = "ClearSymbol:"..guid;
                self.EventWatcher:GetDriver():ClearEvent(ID);
                self.EventWatcher:GetDriver():AddEvent(ID, autoRemoveTimer, "", "", "HIDDEN", self.PlaceSymbol, self, guid, 0);
            end
        end
    end,

    -- ====================================================
    -- Display a local alert message (not shown raid-wide).
    -- ====================================================

    AlertMe = function(self, message, showTime, holdTime, force)
        -- Find an unused major text, and show it.
        local majorText = Manager:GetFreeMajorText(force);
        if ( majorText ) then
            majorText:Display(message, showTime or 0.750, 3, holdTime or 4.000, showTime or 0.750, 3);
            Root.Sound.Play("TRIGGER");
        end
    end,

    -- ==============================================
    -- Display a local message (not shown raid-wide).
    -- ==============================================

    NotifyMe = function(self, message, showTime, holdTime, force)
        -- Find an unused minor text, and show it.
        local minorText = Manager:GetFreeMinorText(force);
        if ( minorText ) then
            minorText:Display(message, showTime or 0.500, holdTime or 3.000, showTime or 0.500);
        end
    end,

    -- ===============================================
    -- Display the current attempt number as a message
    -- and on the status frame.
    -- ===============================================

    PrintAttempt = function(self)
        local attempt = select(2, EncounterStats:GetInfo(self:GetID()));

        self.StatusFrame:SetStatus("TEXT", self:FormatLoc("Try", attempt), false);

        local majorText = Manager:GetFreeMajorText(false);
        if ( majorText ) then
            majorText:Display(self:FormatLoc("Try", attempt), 0.500, 1, 1.500, 0.500, 1);
        end
    end,

    -- ============================================================
    -- Attempt to display a super alert.
    -- Return false if the function is not authorized by the user.
    -- Message is an easy message to understand and instruction
    -- is what the player should do. For exemple, message can be
    -- "You are a bomb !" and instruction "Go away from the raid !"
    -- Set "tryTimerReminder" to true if you wish to do a timer
    -- reminder based alert if super alert is not allowed.
    -- Set hideInterface to true for alerts requiring movement from
    -- the player, to force him to stop looking at his UI.
    -- ============================================================

    SuperAlert = function(self, timer, message, instruction, hideInterface, tryTimerReminder)
        if ( GlobalOptions:GetSetting("AllowSuperAlerts") ) then
            self.SuperAlertFrame:Remove(true);
            self.SuperAlertFrame:Display(timer, message, instruction, hideInterface);
            Root.Sound.Play("TRIGGER");
            return true;
      else
            if ( tryTimerReminder ) then
                self:AlertMe(message, 0.300, timer);
                self.TimerReminder:GetDriver():Start(timer, timer+1, instruction);
            end
            return false;
        end
    end,

    -- ======================================
    -- Warn that a method call is deprecated.
    -- ======================================

    WarnDeprecated = function(self, methodName)
        if ( not self.running ) then return; end
        if ( not self.data.deprecatedCalls ) then self.data.deprecatedCalls = { }; end

        local t = self.data.deprecatedCalls;
        if ( t[methodName] ) then return; end

        t[methodName] = true;
        Root.Print(string.format("WARNING - %s boss module uses %s method, which is deprecated. This module should be rewritten.", self:GetName(), methodName));
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");