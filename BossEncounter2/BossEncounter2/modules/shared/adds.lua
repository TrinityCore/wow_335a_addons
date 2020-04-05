local Root = BossEncounter2;
local Manager = Root.GetOrNewModule("Manager");
local Anchor = Root.GetOrNewModule("Anchor");
local AdvancedOptions = Root.GetOrNewModule("AdvancedOptions");

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- The time amount there has to be before an add can go from dead-to-alive state.
local REVIVE_TRANSITION_DELAY = 0.100;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ========================================
    -- Initialize or reset the adds data system
    -- (ought to be called in OnTrigger)
    -- ========================================

    ResetAdds = function(self)
        local data = self.data;
        if ( not data ) then return; end
        if ( not data.adds ) then
            data.adds = { };
      else
            wipe(data.adds);
        end
        if ( not data.addsLookup ) then
            data.addsLookup = { };
      else
            wipe(data.addsLookup);
        end
        self.AddWindow:GetDriver():Clear();
    end,

    -- ==========================================================
    -- Register a new add. Preferably called in OnTrigger
    -- but can be called in the middle of the encounter if needed
    -- ==========================================================

    RegisterAdd = function(self, id, isAlly)
        self:RegisterAddEX(id, isAlly, "AUTO", nil, nil);
    end,

    -- ====================================================================================
    -- Register a new add in EX mode with more options.
    -- Click method specifies how the system will operate to make the add row clickable.
    -- AUTO will attempt to make the add row clickable once the mob can be accessed.
    -- DB will pre-emptively make the add row clickable through a mob name DB lookup.
    -- DISABLE will prevent the add row from being clickable.
    -- Class and role specify the class and role of the add, duh! Optionnal.
    -- ====================================================================================

    RegisterAddEX = function(self, id, isAlly, clickMethod, class, role)
        if ( not self.data ) or ( not self.data.adds ) then return; end

        self.data.adds[#self.data.adds+1] = {
            mobID = id,
            guid = nil,
            name = nil,
            ally = isAlly or false,
            dead = false,
            deathTime = 0,
        };

        local allowClick = AdvancedOptions:GetSetting("ClickableAddRow");
        if ( clickMethod == "DISABLE" ) or ( not allowClick ) then
            clickMethod = nil;
        end
        if ( clickMethod == "DB" ) then
            clickMethod = Root.MobNameDatabase.GetFromID(id) or nil;
        end

        self.AddWindow:Display();
        self.AddWindow:GetDriver():AddUnit(id, class, role, clickMethod); -- Input the mob ID while waiting to get the GUID.
    end,

    -- ==================================================================
    -- Remove an existing add data and row. It is recommanded you use
    -- this method ONLY IF the add is permanently removed from the fight.
    -- For mobs that die and respawn with a different GUID, you should
    -- use respawn add method, passing the mobID to it.
    -- GUID can also be passed in "index" argument.
    -- ==================================================================

    RemoveAdd = function(self, index)
        if ( not self.data ) or ( not self.data.adds ) then return; end

        if type(index) == "string" then
            -- GUID type.
            local i;
            for i=#self.data.adds, 1, -1 do
                if ( self.data.adds[i].guid == index ) then
                    self:RemoveAdd(i);
                end
            end
            return;
        end

        if ( index < 1 or index > #self.data.adds ) then return; end

        local add = self.data.adds[index];
        local update = (add.dead and (not add.ally));

        if ( add.guid ) then
            self.data.addsLookup[add.guid] = nil;
        end
        self.AddWindow:GetDriver():RemoveUnit(add.guid or add.mobID);

        -- Shuffle with other entries in the add table.
        tremove(self.data.adds, index);

        if ( update ) then
            self:UpdateAddsCount(false);
            self:CheckStandardClear();
        end
    end,

    -- ================================================================
    -- Respawn an add with a different GUID.
    -- This will make an add return to the first stage of searching for
    -- an unit matching the given mob ID.
    -- ================================================================

    RespawnAdd = function(self, id)
        if ( not self.data ) or ( not self.data.adds ) then return; end

        local i, add;
        for i=#self.data.adds, 1, -1 do
            add = self.data.adds[i];
            if ( add.mobID == id ) and ( add.guid ) then
                -- OK, found the add that has respawned. Apply the respawn, cancelling the death if necessary.
                self.data.addsLookup[add.guid] = nil;
                self.AddWindow:GetDriver():ReplaceUnit(add.guid, add.mobID);
                add.guid = nil;

                if ( add.dead ) then
                    add.dead = false;
                    if ( not add.ally ) then
                        self:UpdateAddsCount(false);
                        self:CheckStandardClear();
                    end
                end
            end
        end
    end,

    -- ===========================================================
    -- Release the add window and make it go away.
    -- This function is still here for retro-compatibility.
    -- (ought to be called in OnFailed/OnCleared/OnFinish)
    -- ===========================================================

    RemoveAddsWidgets = function(self)
        local data = self.data;
        if ( not data ) or ( not data.adds ) then return; end

        self.AddWindow:Remove();
    end,

    -- ================================
    -- Update currently watched adds
    -- (ought to be called in OnUpdate)
    -- ================================

    HandleAdds = function(self, elapsed)
        local data = self.data;
        if ( not data ) or ( not data.adds ) then return; end

        local i, add;
        for i=1, #data.adds do
            add = data.adds[i];
            if not ( add.guid ) then
                -- Find a GUID containing the add's mob ID. It must be alive.
                local guid = Root.Unit.GetGUIDFromMobID(add.mobID);
                local uid = Root.Unit.GetUID(guid);
                if ( guid and uid ) and ( UnitHealth(uid) > 0 ) then
                    -- Got the mob!
                    add.name = UnitName(uid);
                    add.guid = guid;
                    if ( not add.ally ) then
                        data.addsLookup[guid] = true;
                    end
                    self.AddWindow:GetDriver():ReplaceUnit(add.mobID, guid);
                end
            end
            if ( add.guid ) then
                local uid = Root.Unit.GetUID(add.guid);
                if ( uid ) then
                    if ( UnitIsDeadOrGhost(uid) ) and ( not add.dead ) then
                        -- The add has died.
                        self:FlagAddDeath(i, true);
                    end
                    if ( not UnitIsDeadOrGhost(uid) ) and ( add.dead ) then
                        -- The add has (been) resurrected. Rollback the death.
                        -- Make an additionnal check though: the health must be > 0.
                        if ( UnitHealth(uid) or 0 ) > 0 and ( GetTime() - add.deathTime ) > REVIVE_TRANSITION_DELAY then
                            self:FlagAddDeath(i, false);
                        end
                    end
                    if ( self:EvaluateEngage(uid) ) then
                        self:OnEngaged();
                    end
                    if ( UnitAffectingCombat(uid) and self.status == "ENGAGED" ) then
                        data.outOfCombatTimer = 0;
                    end

                    -- An add could be accessed. Prevent time-out.
                    data.timeOutTimer = 0;
              else
                    -- Add cannot be accessed.
                end
            end
        end
    end,

    -- =============================================================
    -- Check if dying entity <guid> is in one of the registered adds
    -- (ought to be called when a DEATH combat event is fired)
    -- =============================================================

    CheckAddDeath = function(self, guid)
        if ( not self.running ) then return; end

        local data = self.data;
        if ( not data ) or ( not data.adds ) then return; end

        local i, add;
        for i=1, #data.adds do
            add = data.adds[i];
            if ( add.mobID == Root.Unit.GetMobID(guid) ) then
                self:FlagAddDeath(i, true);
                data.timeOutTimer = 0;
            end
        end
    end,

    -- =========================================
    -- Set whether the given add is dead or not.
    -- =========================================

    FlagAddDeath = function(self, index, isDead)
        local data = self.data;
        if ( not data ) or ( not data.adds ) then return; end

        local add = data.adds[index];
        local oldState = add.dead;
        local updated = 0;

        if ( isDead ) and ( not oldState ) then
            -- Score the death.
            add.dead = true;
            add.deathTime = GetTime();
            updated = 1;

    elseif ( not isDead ) and ( oldState ) then
            -- Rollback the death.
            add.dead = false;
            add.deathTime = 0;
            updated = 2;
        end

        if ( updated > 0 ) and ( not add.ally ) then
            if ( not data.silentAddKills ) then
                self:UpdateAddsCount(updated == 1);
            end
            self:CheckStandardClear();
        end
    end,

    -- ============================================
    -- Returns if the given add matches the filter.
    -- Filters: nil (equivalent to ALL), ADD, ALLY
    -- ============================================

    GetAddMatchFlag = function(self, index, filter)
        local data = self.data;
        if ( not data ) or ( not data.adds ) then return false; end
        local add = data.adds[index];
        if ( not filter ) or ( filter == "ALL" ) then return true; end
        return ( filter == "ALLY" and add.ally ) or ( filter == "ADD" and (not add.ally));
    end,

    -- ================================
    -- Returns the number of alive adds
    -- ================================

    GetNumAddsAlive = function(self, filter)
        local data = self.data;
        if ( not data ) or ( not data.adds ) then return 0; end

        local count = 0;
        local i;
        for i=1, #data.adds do
            if ( not data.adds[i].dead ) and ( self:GetAddMatchFlag(i, filter) ) then
                count = count + 1;
            end
        end
        return count;
    end,

    -- ===============================
    -- Returns the number of dead adds
    -- ===============================

    GetNumAddsDead = function(self, filter)
        return self:GetNumAdds(filter) - self:GetNumAddsAlive(filter);
    end,

    -- ==========================
    -- Returns the number of adds
    -- ==========================

    GetNumAdds = function(self, filter)
        local data = self.data;
        if ( not data ) or ( not data.adds ) then return 0; end

        local count = 0;
        local i;
        for i=1, #data.adds do
            if ( self:GetAddMatchFlag(i, filter) ) then
                count = count + 1;
            end
        end
        return count;
    end,

    -- =====================================================
    -- Display X / Y in the status frame
    -- X is the number of dead adds, Y is the number of adds
    -- =====================================================

    UpdateAddsCount = function(self, notify)
        self.StatusFrame:SetStatus("TEXT", string.format("%d / %d", self:GetNumAddsDead("ADD"), self:GetNumAdds("ADD")), notify);
        if ( notify ) then
            Root.Sound.Play("ADDCHANGE");
        end
    end,

    -- =========================================================================
    -- Returns info about an add. GUID and name returns can be nil if the engine
    -- has not found the add yet. No filter can be used here, so be careful
    -- if you iterate with GetNumAdds: you must not use a filter.
    -- =========================================================================

    GetAddInfo = function(self, index)
        local data = self.data;
        if ( data ) and ( data.adds ) then
            if ( index >= 1 and index <= #data.adds ) then
                -- Valid add index. Grab infos.
                local add = data.adds[index];
                return add.mobID, add.guid or nil, add.name or nil, add.ally or false, add.dead or false;
            end
        end
        return nil, nil, nil, false, false;
    end,

    -- ======================================================
    -- Get an add GUID from a mob ID. The result might be nil 
    -- if the add could not be found yet.
    -- ======================================================

    GetAddGUID = function(self, mobID)
        local i, id, guid;
        for i=1, self:GetNumAdds() do
            id, guid = self:GetAddInfo(i);
            if ( id == mobID ) then
                return guid; -- Can be nil if the engine has not found the add yet.
            end
        end
    end,

    -- =============================================================================
    -- Register adds that will auto-revive themselves unless killed at the same time
    -- =============================================================================

    DefineRevivableAdds = function(self, list, reviveTimer)
        self.data.addReviveTimer = reviveTimer;
        self.data.addReviveList = list;
        self.data.addReviveDeath = { };
    end,

    -- ======================================================
    -- Determinate the time before an add auto-revives itself
    -- ======================================================

    GetReviveTimer = function(self, guid)
        if ( not self.data ) or ( not self.data.addReviveTimer ) then return 0, 0; end

        local deathTime = self.data.addReviveDeath[guid];
        if ( not deathTime ) then return 0, 0; end
        
        return max(0, deathTime + self.data.addReviveTimer - GetTime()), self.data.addReviveTimer;
    end,

    -- ===================================================
    -- Check if all adds belonging to the revive list have 
    -- been slain, thus interrupting the revive timer
    -- ===================================================

    CheckReviveInterrupt = function(self)
        -- If all revivable adds are flagged as dead, then interrupt all revival timers.

        local i, id, guid, name, ally, dead;
        for i=1, self:GetNumAdds() do
            id, guid, name, ally, dead = self:GetAddInfo(i);

            if ( self:IsRevivableAdd(id) ) and ( not dead ) then
                return;
            end
        end
        for guid in pairs(self.data.addReviveDeath) do
            self.data.addReviveDeath[guid] = nil;
        end
    end,

    -- ===============================================
    -- Specify if an add is flagged as a revivable add
    -- ===============================================

    IsRevivableAdd = function(self, id)
        if ( not self.data ) or ( not self.data.addReviveList ) then
            return false;
        end
        return self.data.addReviveList[id];
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");