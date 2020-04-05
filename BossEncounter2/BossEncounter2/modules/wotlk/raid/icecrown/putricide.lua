local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Putricide Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Putricide fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Ooze"] = "Ooze",

        -- 3. Misc
        ["Title"] = "Putricide",
        ["AddSelf"] = "You're the target of %s!",
        ["AddAlert"] = ">> {rt7} %s target of %s {rt7} <<",
        ["GooAlert"] = "Do not stay here!",
        ["UnboundPlagueSelf"] = "Unbound Plague on you!",
        ["UnboundPlagueWarning"] = "{rt1} Unbound Plague on %s! {rt1}",
        ["UnboundPlagueTransfer"] = "{rt8} %s should give the Unbound Plague... {rt8}",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Ooze"] = "Limon",

        -- 3. Misc
        ["Title"] = "Putricide",
        ["AddSelf"] = "Vous êtes la cible de %s !",
        ["AddAlert"] = ">> {rt7} %s cible de %s {rt7} <<",
        ["GooAlert"] = "Ne restez pas là !",
        ["UnboundPlagueSelf"] = "Vous avez la peste !",
        ["UnboundPlagueWarning"] = "{rt1} Peste sur %s ! {rt1}",
        ["UnboundPlagueTransfer"] = "{rt8} Il est temps que %s donne sa peste... {rt8}",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnAddsTargets",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn adds targets",
            ["frFR"] = "Annoncer les cibles des adds",
        },
        explain = {
            ["default"] = "Display raid alerts and put symbols on gas clouds / volatile oozes targets.",
            ["frFR"] = "Affiche des alertes de raid et place des symboles sur les cibles des nuages de gaz / limons volatiles.",
        },
    },
    [2] = {
        id = "warnUnboundPlague",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Unbound Plagues",
            ["frFR"] = "Annoncer les pestes déliées",
        },
        explain = {
            ["default"] = "(Heroic only) Place a symbol and issue a warning when someone gets the Unbound Plague. Also issue a warning when it's time to transfer the plague.",
            ["frFR"] = "(Héroïque seulement) Place un symbole et envoie un avertissement quand quelqu'un obtient la peste déliée. Envoie aussi un avertissement quand la peste doit être transférée.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Putricide";

local adhesive = {
    [70447] = true,
    [72836] = true,
    [72837] = true,
    [72838] = true,
};

local bloat = {
    [70672] = true,
    [72455] = true,
    [72832] = true,
    [72833] = true,
};

local gooBall = {
    [72295] = true,
    [72615] = true,
    [72873] = true,
    [72874] = true,
};

local unboundPlague = {
    [70911] = true,
    [72854] = true,
    [72855] = true,
};

-- --------------------------------------------------------------------
-- **                       Definition stuff                         **
-- --------------------------------------------------------------------

Root[THIS_MODULE] = {
    -- --------------------------------------------------------------------
    -- **                            Properties                          **
    -- --------------------------------------------------------------------

    isWrathRaid = true,

    -- --------------------------------------------------------------------
    -- **                             Handlers                           **
    -- --------------------------------------------------------------------

    OnStart = Shared.OnStart,

    OnTrigger = function(self, uid, extraTable)
        if not self:TriggerMe() then return; end

        local data = self.data;

        data.title = self:Localize("Title");
        data.ignoreAdds = true;
        data.silentAddKills = true;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.90, 0.80, 1.00, 0.90, 0.90); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.70, 0.60, 0.70, 0.80, 0.70); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(600, true);

        self:ResetAdds();
        self:RegisterAddEX(37697, false, "DB"); -- Volatile
        self:RegisterAddEX(37562, false, "DB"); -- Gas
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(360, 600);

        self:ChangePhase(1, true);

        Root.Music.Play("THEME_NAXXRAMAS_ENDWING"); -- Hooray!

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.805, "Phase 2", self.OnPhaseTwo, self);
        self:RegisterHealthThreshold(0.355, "Phase 3", self.OnPhaseThree, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleOoze(25.25);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...)
            if ( self.running ) then
                if ( unboundPlague[spellId] ) and ( targetGUID ) then
                    self:OnUnboundPlagueDamage(targetGUID, select(3, ...));
                end
            end
            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...);
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( adhesive[spellId] or bloat[spellId] ) and ( actorName ) and ( targetGUID ) and ( targetName ) then
                    if ( adhesive[spellId] ) then
                        self:RespawnAdd(37697);
                  else
                        self:RespawnAdd(37562);
                    end
                    self:OnAddTarget(targetGUID, targetName, actorName);
                    self:RegisterHealAssist(targetGUID, 0, 15, spellId);
                end
                if ( unboundPlague[spellId] ) and ( targetGUID ) then
                    self:OnUnboundPlague(targetGUID);
                end
            end
        end,

        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( gooBall[spellId] ) and ( targetGUID ) then
                    self:OnGooBall();
                end
            end
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 70351 or spellId == 71966 ) then
                    self:OnExperiment();
                end
            end
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleOoze = function(self, timer)
        if ( self.data.phase >= 3 ) then return; end

	self.EventWatcher:GetDriver():AddEvent("Ooze", timer, "AUTO", self:Localize("Ooze"), "WARNING_NOREMINDER");
    end,

    ScanGooBallTarget = function(self)
        local guid = self:GetTargetInfo();
        if ( not guid ) then return; end

        local close = false;
        if ( UnitGUID("player") == guid ) then close = true; end
        local distance = self:GetDistance(guid);
        if ( distance ) and ( distance <= 15 ) then
            close = true;
        end
        if ( close ) then
            self:AlertMe(self:Localize("GooAlert"), 0.400, 3.000);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPhaseTwo = function(self)
        if ( self.data.phase >= 2 ) then return; end
        self:ChangePhase(2, true);

	self.EventWatcher:GetDriver():ClearEvent("Ooze");
        self:ScheduleOoze(42); -- I think it should be 25 sec if we used the yell instead.
    end,

    OnPhaseThree = function(self)
        if ( self.data.phase >= 3 ) then return; end
        self:ChangePhase(3, true);

        self:ChangeMusic("HURRYUP");

	self.EventWatcher:GetDriver():ClearEvent("Ooze");
    end,

    OnAddTarget = function(self, guid, name, mobName)
        if ( UnitGUID("player") == guid ) then
             self:AlertMe(self:FormatLoc("AddSelf", mobName), 0.400, 4.000);
        end
        if ( self:GetSetting("warnAddsTargets") ) then
            self:AnnounceToRaid(self:FormatLoc("AddAlert", name, mobName));
            self:PlaceSymbol(guid, 7);
        end
    end,

    OnGooBall = function(self)
        self.EventWatcher:GetDriver():AddEvent("ScanGooBallTarget", 0.200, "", "", "HIDDEN", self.ScanGooBallTarget, self);
    end,

    OnExperiment = function(self)
	self.EventWatcher:GetDriver():TriggerEvent("Ooze");

        self:ScheduleOoze(37.9);
    end,

    OnUnboundPlague = function(self, guid)
        if ( UnitGUID("player") == guid ) then
             self:AlertMe(self:Localize("UnboundPlagueSelf"), 0.400, 4.000);
        end
        local uid = Root.Unit.GetUID(guid);
        if ( uid ) and ( self:GetSetting("warnUnboundPlague") ) then
            local name = UnitName(uid);
            self:AnnounceToRaid(self:FormatLoc("UnboundPlagueWarning", name));
            self:PlaceSymbol(guid, 1);
        end
    end,

    OnUnboundPlagueDamage = function(self, guid, amount)
        local uid = Root.Unit.GetUID(guid);
        if ( amount >= 2500 ) and ( uid ) and ( self:GetSetting("warnUnboundPlague") ) then
            if ( not self:EvaluateCooldown("unboundPlague", 8) ) then return; end

            local name = UnitName(uid);
            self:AnnounceToRaid(self:FormatLoc("UnboundPlagueTransfer", name));
            self:PlaceSymbol(guid, 8);
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(36678, THIS_MODULE, false);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
