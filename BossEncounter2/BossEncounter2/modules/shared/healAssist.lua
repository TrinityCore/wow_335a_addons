local Root = BossEncounter2;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ============================================================
    -- Prepare the heal assist system. This should be called before
    -- RegisterHealAssistTarget can be called by the module.
    -- ============================================================

    InitializeHealAssistSystem = function(self)
        local data = self.data;
        if ( not data ) then return; end
        if ( not data.healAssist ) then
            data.healAssist = { };
      else
            wipe(data.healAssist);
        end
    end,

    -- ================================================================
    -- Notify someone is about to take loads of damage. Time specifies
    -- for how long the indicator should stay up, and effectFade
    -- specifies (if applicable) which debuff should fade from the unit
    -- before hiding the indicator, whichever condition comes first.
    -- preTime is the amount of time the indicator will be displayed as
    -- green, meaning that there is a few seconds left before the
    -- damage comes (warning - time ticks down even if preTime is > 0).
    -- effectFade can also be a table (like {234, 5092}).
    -- ================================================================

    RegisterHealAssist = function(self, guid, preTime, time, effectFade)
        if ( not self.data ) or ( not self.data.healAssist ) then return; end

        -- Try to merge first with existing assists.
        local i, info;
        for i=1, #self.data.healAssist do
            info = self.data.healAssist[i];
            if ( info.guid == guid ) then
                info.preTime = min(info.preTime, preTime);
                info.time = max(info.time, time);
                info.effect = effectFade or info.effect; -- Lame but oh well.
                return;
            end
        end

        local newWidget = Manager:GetFreeHealAssistWidget();
        if ( not newWidget ) then return; end

        local num = #self.data.healAssist+1;
        self.data.healAssist[num] = {
            widget = newWidget,
            guid = guid,
            preTime = preTime or 0,
            time = time,
            effect = effectFade,
        };

        newWidget:Start(guid);
        if ( not preTime ) or ( preTime == 0 ) then
            newWidget:TurnRed(0);
        end
    end,

    -- =====================================================
    -- Remove an existing heal assist and associated widget.
    -- GUID can also be passed in "index" argument.
    -- =====================================================

    RemoveHealAssist = function(self, index)
        if ( not self.data ) or ( not self.data.healAssist ) then return; end

        if type(index) == "string" then
            -- GUID type.
            local i;
            for i=#self.data.healAssist, 1, -1 do
                if ( self.data.healAssist[i].guid == index ) then
                    self:RemoveHealAssist(i);
                    break;
                end
            end
            return;
        end

        local num = #self.data.healAssist;
        if ( index < 1 or index > num ) then return; end

        self.data.healAssist[index].widget:Remove();

        -- Shuffle with other entries in the heal assist table.
        local i;
        for i=index, num-1 do
            self.data.healAssist[i] = self.data.healAssist[i+1];
        end
        self.data.healAssist[num] = nil;
    end,

    -- ===================================================
    -- Release heal assist widgets.
    -- (ought to be called in OnFailed/OnCleared/OnFinish)
    -- ===================================================

    RemoveHealAssistWidgets = function(self)
        local data = self.data;
        if ( not data ) or ( not data.healAssist ) then return; end

        local i, healee;
        for i=1, #data.healAssist do
            healee = data.healAssist[i];
            healee.widget:Remove();
        end
    end,

    -- ================================
    -- Update active heal assists.
    -- (ought to be called in OnUpdate)
    -- ================================

    HandleHealAssists = function(self, elapsed)
        local data = self.data;
        if ( not data ) or ( not data.healAssist ) then return; end

        local i, healee, removeMe;
        for i=#data.healAssist, 1, -1 do
            healee = data.healAssist[i];
            removeMe = false;

            local uid = Root.Unit.GetUID(healee.guid);
            if ( uid ) then
                if ( UnitIsDeadOrGhost(uid) ) then
                    -- The guy is dead :(
                    removeMe = true;
                end
          else
                -- Healee cannot be accessed.
            end

            if ( healee.time ) then
                healee.time = max(0, healee.time - elapsed);
                if ( healee.time == 0 ) then
                    removeMe = true;
                end
            end

            if ( healee.preTime > 0 ) then
                healee.preTime = max(0, healee.preTime - elapsed);
                if ( healee.preTime == 0 ) then
                    healee.widget:TurnRed(0.5);
                end
            end

            if ( removeMe ) then
                self:RemoveHealAssist(i);
            end
        end
    end,

    -- =============================================
    -- Remove units in heal assist that were waiting
    -- for the given effect to fade from them.
    -- =============================================

    CheckHealAssistFade = function(self, fadeGUID, spellId)
        if ( not self.running ) then return; end

        local i, ii, removeMe;
        local guid, preTime, time, effect, widget;

        for i=self:GetNumHealAssists(), 1, -1 do
            removeMe = false;
            guid, preTime, time, effect, widget = self:GetHealAssistInfo(i);

            if ( fadeGUID == guid ) then
                if ( type(effect) == "number" ) and ( spellId == effect ) then
                    removeMe = true;
            elseif ( type(effect) == "table" ) then
                    for ii=1, #effect do
                        if ( spellId == effect[ii] ) then
                            removeMe = true;
                        end
                    end
                end
            end

            if ( removeMe ) then
                self:RemoveHealAssist(i);
            end
        end
    end,

    -- ==================================================
    -- Get the number of units registered in heal assist.
    -- ==================================================

    GetNumHealAssists = function(self)
        local data = self.data;
        if ( not data ) or ( not data.healAssist ) then return 0; end
        return #data.healAssist;
    end,

    -- =====================================================
    -- Returns info about an unit registered in heal assist.
    -- =====================================================

    GetHealAssistInfo = function(self, index)
        local data = self.data;
        if ( data ) and ( data.healAssist ) then
            if ( index >= 1 and index <= #data.healAssist ) then
                -- Valid index. Grab infos.
                local healee = data.healAssist[index];
                return healee.guid, healee.preTime or 0, healee.time or nil, healee.effect or nil, healee.widget;
            end
        end
        return nil, nil, nil, nil, nil;
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");