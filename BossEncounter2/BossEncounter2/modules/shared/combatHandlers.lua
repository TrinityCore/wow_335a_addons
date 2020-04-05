local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ==================================================================
    -- Default combat event handlers.
    -- Missing handlers will be completed by those handlers.
    -- You can put a null function / invalid value to void them.
    -- ==================================================================

    OnCombatEvent = {
        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                self:CheckAddDeath(guid);

                self:CreditPendingDamage(guid);

                if ( self.data.guid == guid ) then
                    self.data.bossDead = true;
                    self:CheckStandardClear();
                end

                local id = Root.Unit.GetMobID(guid);
                if ( self:IsRevivableAdd(id) ) then
                    self.data.addReviveDeath[guid] = GetTime();
                    self:CheckReviveInterrupt();
                end

                self:RemoveHealAssist(guid);
            end
        end,

        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overkill, school, special, resisted, blocked, absorbed)
            if ( self.running ) and ( targetGUID ) then
                local damage = amount - (overkill or 0) + (absorbed or 0);
                if ( actorGUID ) and ( bit.band(actorFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0 ) then -- Optimization to immediately drop damage done by unfriendly sources.
                    self:CreditDamage(actorGUID, targetGUID, damage);
                end

                local dead = (overkill or 0) > 0;
                local id = Root.Unit.GetMobID(targetGUID);
                if ( dead ) and ( self:IsRevivableAdd(id) ) then
                    self.OnCombatEvent["DEATH"](self, targetGUID, targetName, targetFlags);
                end
            end
        end,

        ["HEAL"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overheal, school, special, absorbed)
            if ( self.running ) and ( targetGUID ) then
                local healing = amount - (overheal or 0) - (absorbed or 0);
                if ( not self.data.ignoreHealing ) then
                    self:RollbackDamage(targetGUID, healing);
                end
            end
        end,

        ["KILL"] = function(self, sGUID, sName, sFlags, tGUID, tName, tFlags)
            if ( self.running ) and ( sGUID and tGUID ) and ( self.data.guid == tGUID ) then
                self.data.coupDeGrace = sGUID;
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                self:CheckHealAssistFade(targetGUID, spellId);
            end
        end,
    },
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");
