local Root = BossEncounter2;
local Manager = Root.GetOrNewModule("Manager");
local Anchor = Root.GetOrNewModule("Anchor");

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local NUM_MAJOR_TEXTS = 3;
local NUM_MINOR_TEXTS = 2;
local NUM_HEAL_ASSISTS = 10;
local NUM_EVENT_WARNINGS = 2;
local NUM_LOOT_ASSIGNERS = 6;

-- --------------------------------------------------------------------
-- **                            Methods                             **
-- --------------------------------------------------------------------

-- All GetFreeX methods return the slotID as their second return value.

Manager.GetBossBar = function(self)
    return self.bossBar;
end

Manager.GetEventWatcher = function(self)
    return self.eventWatcher;
end

Manager.GetStatusFrame = function(self)
    return self.statusFrame;
end

Manager.GetClearedAnimation = function(self)
    return self.clearedAnimation;
end

Manager.GetResultSequence = function(self)
    return self.resultSequence;
end

Manager.GetTimerReminder = function(self)
    return self.timerReminder;
end

Manager.GetSuperAlert = function(self)
    return self.superAlert;
end

Manager.GetUnitList = function(self)
    return self.unitList;
end

Manager.GetSpecialBar = function(self)
    return self.specialBar;
end

Manager.GetSettingFrame = function(self)
    return self.settingFrame;
end

Manager.GetDifficultyMeter = function(self)
    return self.difficultyMeter;
end

Manager.GetAnchorControlFrame = function(self)
    return self.anchorControlFrame;
end

Manager.GetAddWindow = function(self)
    return self.addWindow;
end

Manager.GetFreeMajorText = function(self, force)
    local i, text;
    for i=1, NUM_MAJOR_TEXTS do
        text = self.majorText[i];
        if ( text.status == "READY" ) then
            return text, i;
        end
    end
    if ( force ) then
        return self.majorText[1], 1;
    end
    return nil;
end

Manager.GetFreeMinorText = function(self, force)
    local i, text;
    for i=1, NUM_MINOR_TEXTS do
        text = self.minorText[i];
        if ( text.status == "READY" ) then
            return text, i;
        end
    end
    if ( force ) then
        return self.minorText[1], 1;
    end
    return nil;
end

Manager.GetFreeAnchorGhost = function(self)
    local i, anchorGhost;
    for i=1, #self.anchorGhost do
        anchorGhost = self.anchorGhost[i];
        if ( anchorGhost:GetStatus() == "STANDBY" or anchorGhost:GetStatus() == "CLOSING" ) then
            return anchorGhost, i;
        end
    end
    return nil;
end

Manager.GetNumHealAssistWidgets = function(self)
    return #self.healAssist;
end

Manager.GetFreeHealAssistWidget = function(self)
    local i, widget;
    for i=1, NUM_HEAL_ASSISTS do
        widget = self.healAssist[i];
        if ( widget.status == "STANDBY" ) then
            return widget;
        end
    end
    return nil;
end

Manager.GetFreeEventWarning = function(self)
    local i, eventWarning;
    for i=1, NUM_EVENT_WARNINGS do
        eventWarning = self.eventWarning[i];
        if ( eventWarning:IsFree() ) then
            return eventWarning;
        end
    end
    return nil;
end

Manager.GetFreeLootAssigner = function(self)
    local i, lootAssigner;
    for i=1, NUM_LOOT_ASSIGNERS do
        lootAssigner = self.lootAssigner[i];
        if ( lootAssigner:IsFree() ) then
            return lootAssigner;
        end
    end
    return nil;
end

Manager.GetNumLootAssigners = function(self)
    return NUM_LOOT_ASSIGNERS;
end

Manager.GetLootAssigner = function(self, index)
    return self.lootAssigner[index];
end

-- --------------------------------------------------------------------
-- **                            Handlers                            **
-- --------------------------------------------------------------------

Manager.OnStart = function(self)
    local i;

    -- Create boss bar frame. Currently only one needed.
    self.bossBar = CreateFrame("Frame", nil, UIParent, "BossEncounter2_BossBarTemplate");

    -- Create event watcher frame. Only one needed.
    self.eventWatcher = CreateFrame("Frame", nil, UIParent, "BossEncounter2_EventWatcherTemplate");

    -- Create status frame. Only one needed.
    self.statusFrame = CreateFrame("Frame", nil, UIParent, "BossEncounter2_StatusFrameTemplate");

    -- Create cleared animation frame. Only one needed.
    self.clearedAnimation = CreateFrame("Frame", nil, WorldFrame, "BossEncounter2_ClearedAnimationTemplate");

    -- Create result sequence frame. Only one needed.
    self.resultSequence = CreateFrame("Frame", nil, WorldFrame, "BossEncounter2_ResultSequenceTemplate");

    -- Create timer reminder frame. Only one needed.
    self.timerReminder = CreateFrame("Frame", nil, UIParent, "BossEncounter2_TimerReminderTemplate");
    self.timerReminder:Setup(0.50, 30);

    -- Create super alert. Only one needed.
    self.superAlert = CreateFrame("Frame", nil, WorldFrame, "BossEncounter2_SuperAlertTemplate");

    -- Create unit list frame. Only one needed.
    self.unitList = CreateFrame("Frame", nil, UIParent, "BossEncounter2_UnitListTemplate");

    -- Create special bar frame. Only one needed.
    self.specialBar = CreateFrame("StatusBar", nil, UIParent, "BossEncounter2_SpecialBarTemplate");

    -- Create setting frame. Only one needed.
    self.settingFrame = CreateFrame("Frame", nil, UIParent, "BossEncounter2_SettingFrameTemplate");

    -- Create difficulty meter. Only one needed.
    self.difficultyMeter = CreateFrame("Frame", nil, WorldFrame, "BossEncounter2_DifficultyMeterTemplate");

    -- Create anchor control frame. Only one needed.
    self.anchorControlFrame = CreateFrame("Frame", nil, UIParent, "BossEncounter2_AnchorControlFrameTemplate");

    -- Create add window frame. Only one needed.
    self.addWindow = CreateFrame("Frame", nil, UIParent, "BossEncounter2_AddWindowTemplate");

    -- Create major texts.
    self.majorText = { };
    for i=1, NUM_MAJOR_TEXTS do
        self.majorText[i] = CreateFrame("Frame", nil, UIParent, "BossEncounter2_MajorTextTemplate");
        self.majorText[i]:SetID(i);
    end

    -- Create minor texts.
    self.minorText = { };
    for i=1, NUM_MINOR_TEXTS do
        self.minorText[i] = CreateFrame("Frame", nil, UIParent, "BossEncounter2_MinorTextTemplate");
        self.minorText[i]:SetID(i);
    end

    -- Create heal assist widgets.
    self.healAssist = { };
    for i=1, NUM_HEAL_ASSISTS do
        self.healAssist[i] = CreateFrame("Frame", nil, UIParent, "BossEncounter2_HealAssistTemplate");
    end

    -- Create event warning widgets.
    self.eventWarning = { };
    for i=1, NUM_EVENT_WARNINGS do
        self.eventWarning[i] = CreateFrame("Frame", nil, UIParent, "BossEncounter2_EventWarningTemplate");
        self.eventWarning[i]:SetID(i);
    end
    local refEventWarning = self.eventWarning[1];

    -- Create loot assigner widgets. Names are required for them because of their dropdowns.
    self.lootAssigner = { };
    for i=1, NUM_LOOT_ASSIGNERS do
        self.lootAssigner[i] = CreateFrame("Frame", "BossEncounter2_LootAssigner"..i, UIParent, "BossEncounter2_LootAssignerTemplate");
        self.lootAssigner[i]:SetID(i);
    end

    -- Registers all anchors. The anchors will apparear in the anchor edit mode.
    Anchor:Register("mainbossbar",      "BOX",                             384,                               24, true); -- Bars are of variable length, but their max width is 384 px.
    Anchor:Register("maineventwatcher", "BOX",    self.eventWatcher:GetWidth(),    self.eventWatcher:GetHeight(), true);
    Anchor:Register("mainstatusframe",  "BOX",     self.statusFrame:GetWidth(),     self.statusFrame:GetHeight(), false);
    Anchor:Register("mainunitlist",     "BOX",        self.unitList:GetWidth(),        self.unitList:GetHeight(), true);
    Anchor:Register("majortext",       "AXIS",                             300,                               32, false);
    Anchor:Register("minortext",       "AXIS",                             300,                               32, false);
    Anchor:Register("specialbar",       "BOX",                             166,                               24, true);
    Anchor:Register("eventwarning",     "BOX",      refEventWarning:GetWidth(),      refEventWarning:GetHeight(), false);
    Anchor:Register("addwindow",        "BOX",       self.addWindow:GetWidth(),                      4 * 20 + 24, true);

    -- Set defaults and labels for all anchors.
    Anchor:SetConstants("mainbossbar",      0.50, 0.30,                                                             Root.Localise("Anchor-BossBar"));
    Anchor:SetConstants("maineventwatcher", 0.75, 0.55,                                                             Root.Localise("Anchor-EventWatcher"));
    Anchor:SetConstants("mainstatusframe",  0.50, 1 - (16 + self.statusFrame:GetHeight()/2) / UIParent:GetHeight(), Root.Localise("Anchor-StatusFrame"));
    Anchor:SetConstants("mainunitlist",     0.75, 0.35,                                                             Root.Localise("Anchor-UnitList"));
    Anchor:SetConstants("majortext",        0.50, 0.60,                                                             Root.Localise("Anchor-MajorText"));
    Anchor:SetConstants("minortext",        0.50, 0.70,                                                             Root.Localise("Anchor-MinorText"));
    Anchor:SetConstants("specialbar",       0.75, 0.65,                                                             Root.Localise("Anchor-SpecialBar"));
    Anchor:SetConstants("eventwarning",     0.50, 0.37,                                                             Root.Localise("Anchor-EventWarning"));
    Anchor:SetConstants("addwindow",        0.75, 0.75,                                                             Root.Localise("Anchor-AddWindow"));

    -- Bind anchors to appropriate widgets, particularly widgets that are static and single.
    Anchor:BindToWidget(self.bossBar, "mainbossbar");
    Anchor:BindToWidget(self.eventWatcher, "maineventwatcher");
    Anchor:BindToWidget(self.statusFrame, "mainstatusframe");
    Anchor:BindToWidget(self.unitList, "mainunitlist");
    Anchor:BindToWidget(self.specialBar, "specialbar");
    Anchor:BindToWidget(self.addWindow, "addwindow");

    for i=1, NUM_MAJOR_TEXTS do
        Anchor:BindToWidget(self.majorText[i], "majortext");
    end
    for i=1, NUM_MINOR_TEXTS do
        Anchor:BindToWidget(self.minorText[i], "minortext");
    end
    for i=1, NUM_EVENT_WARNINGS do
        Anchor:BindToWidget(self.eventWarning[i], "eventwarning");
    end

    -- Create enough anchor ghosts.
    self.anchorGhost = { };
    for i=1, Anchor:GetNumAnchors() do
        self.anchorGhost[i] = CreateFrame("Frame", nil, UIParent, "BossEncounter2_AnchorGhostTemplate");
    end
end