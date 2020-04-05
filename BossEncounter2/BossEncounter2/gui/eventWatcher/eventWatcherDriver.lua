local Root = BossEncounter2;
local Manager = Root.GetOrNewModule("Manager");
local Widgets = Root.GetOrNewModule("Widgets");

Widgets["EventWatcherDriver"] = { };
local EventWatcherDriver = Widgets["EventWatcherDriver"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local COLOR_INFO = {
    ["WARNING"] = { r = 1.00, g = 0.90, b = 0.10 },
    ["ALERT"] = { r = 1.00, g = 0.10, b = 0.10 },
};

local WARNING_THRESHOLD = 5;
local ALERT_THRESHOLD = 10;
local ALERT_TICK_THRESHOLD = 5;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(ownedEventWatcher)                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher driver.                               *
-- * >> ownedEventWatcher: the event watcher that will be controlled  *
-- * by the driver.                                                   *
-- ********************************************************************
-- * Setup the driver of an event watcher.                            *
-- ********************************************************************
local function Setup(self, ownedEventWatcher)
    if type(self) ~= "table" or type(ownedEventWatcher) ~= "table" then return; end

    self.ownedEventWatcher = ownedEventWatcher;
    self:ClearAllEvents();
end

-- ********************************************************************
-- * self:ClearAllEvents()                                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher driver.                               *
-- ********************************************************************
-- * Clear all scheduled events in the driver. No event callback will *
-- * get fired. This should be use at the end of an encounter to      *
-- * reset the auto event counter to 0 instead of clearing events     *
-- * individually.                                                    *
-- ********************************************************************
local function ClearAllEvents(self)
    if type(self) ~= "table" then return; end

    local i;
    for i=#self.events, 1, -1 do
        self:ClearEvent(i);
    end 

    self.autoEventCounter = 0;
    self.remindedEvent = nil;
end

-- ********************************************************************
-- * self:ClearEvent(event)                                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher driver.                               *
-- * >> event: the index or name of the event to clear.               *
-- ********************************************************************
-- * Clear a specific event in the driver. It can be accessed with    *
-- * either name or index. In case of deleting an event by name, it   *
-- * is possible that more than one event gets deleted if some events *
-- * share the same name. No event callback will get fired.           *
-- ********************************************************************
local function ClearEvent(self, event)
    if type(self) ~= "table" then return; end

    local i;

    if type(event) == "number" and event > 0 and event <= #self.events then
        -- Make sure all features are stopped before removing the event data.
        local warningFrame = self.events[event].warningFrame;
        if ( warningFrame ) then warningFrame:Remove(); end
        self:CheckReminderChange(self.events[event], "STOP");

        -- Remove the event data and raise the events below in the data table.
        for i=event, #self.events-1 do
            self.events[i] = self.events[i+1];
        end
        self.events[#self.events] = nil;

elseif type(event) == "string" then
        for i=#self.events, 1, -1 do
            if ( self.events[i].name == event ) then
                self:ClearEvent(i);
            end
        end
    end  
end

-- ********************************************************************
-- * self:AddEvent(name, timer, icon, label[,                         *
-- *               eventType, callback, ...])                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher driver.                               *
-- * >> name: the internal name of the event (not displayed).         *
-- * >> timer: the timer before the event triggers.                   *
-- * >> icon: the icon to display for this event.                     *
-- * Use "AUTO" or nil to use the event counter.                      *
-- * >> label: the displayed explanation.                             *
-- * >> eventType: the type of event (defaulted to "NORMAL").         *
-- * >> callback: the function that should be called upon triggering. *
-- * >> ...: parameters to pass to callback. Avoid using "nil" !!     *
-- ********************************************************************
-- * Schedules a new event in the driver.                             *
-- *                                                                  *
-- * The following types of events are possible:                      *
-- * NORMAL - No warning / trigger message displayed.                 *
-- * WARNING - 5 sec prior activation warning / trigger message shown.*
-- * WARNING_NOREMINDER - Like warning, but no trigger message.       *
-- * ALERT - 10 sec prior activation warning / 5 sec countdown shown. *
-- * REMINDER - The event timer is reminded throughout the fight.     *
-- * HIDDEN - No warning and not displayed in the event watcher.      *
-- *                                                                  *
-- * Please note there can only be 1 "REMINDER"-type event at a time. *
-- ********************************************************************
local function AddEvent(self, name, timer, icon, label, eventType, callback, ...)
    if type(self) ~= "table" then return; end
    if ( not name ) or ( not timer ) then return; end

    if ( eventType ~= "HIDDEN" ) then
        self.autoEventCounter = self.autoEventCounter + 1;
    end

    if ( not icon ) or ( icon == "AUTO" ) then
        icon = self.autoEventCounter;
    end

    local newEvent = {
        name = name,
        timer = timer,
        icon = icon,
        label = label or "???",
        type = eventType or "NORMAL",
        callback = callback,
        args = {...},
        triggered = false,
        warned = false,
        alertStep = nil,
        frozen = false,
        warningFrame = nil,
    };

    self.events[#self.events+1] = newEvent;

    self:CheckReminderChange(newEvent, "START");
end

-- ********************************************************************
-- * self:TriggerEvent(event, dropAcknowledgment)                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher driver.                               *
-- * >> event: the index or name of the event to trigger.             *
-- * >> dropAcknowledgment: if set, the event will be removed at once *
-- * after being triggered. This means the player will not be able to *
-- * see it in the red portion of the event watcher.                  *
-- ********************************************************************
-- * Trigger an event by either index or name. Already triggered      *
-- * events cannot be triggered a second time. Triggering an event    *
-- * reduces its timer to a maximum of 0 and fires its callback.      *
-- ********************************************************************
local function TriggerEvent(self, event, dropAcknowledgment)
    if type(self) ~= "table" then return; end

    if type(event) == "number" and event > 0 and event <= #self.events then
        local me = self.events[event];
        if ( not me.triggered ) then
            if ( me.type == "WARNING" ) and ( self.warningMode == "TEXTUAL" ) then
                -- We do a recall for warnings but none for alerts, alerts have already a lot of love.
                local minorText = Manager:GetFreeMinorText();
                if ( minorText ) then
                    minorText:Display(me.label, 0.500, 2.500, 0.500);
                end
            end
            if ( me.warningFrame ) then
                me.warningFrame:Remove();
                me.warningFrame = nil;
            end
            me.triggered = true;
            me.timer = min(0, me.timer);
            me.frozen = false;
            if ( me.callback ) then
                me.callback(unpack(me.args));
            end
        end
        if ( dropAcknowledgment ) then
            self:ClearEvent(event);
        end

elseif type(event) == "string" then
        local i;
        for i=#self.events, 1, -1 do
            if ( self.events[i].name == event ) then
                self:TriggerEvent(i, dropAcknowledgment);
            end
        end
    end  
end

-- ********************************************************************
-- * self:ChangeEvent(event[, timer, icon, label, eventType,          *
-- *                  callback, ...])                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher driver.                               *
-- * >> event: the index or name of the event to change.              *
-- * >> timer: the overide to the old timer field.                    *
-- * >> icon: the new icon to use. Can't use "AUTO" in this method.   *
-- * >> label: the overide to the old label field.                    *
-- * >> eventType: the overide to the old event type field.           *
-- * >> callback: the overide to the old callback field.              *
-- * >> ...: if the callback overide is provided, these contain       *
-- * the new parameters to pass to the new callback.                  *
-- ********************************************************************
-- * Change an on-going event without modifying its internal name or  *
-- * ID. All fields can be changed. Passing nil will not cause change *
-- * to the matching field. Setting a timer smaller than 0 will       *
-- * set the triggered flag. Setting it above will clear it.          *
-- ********************************************************************
local function ChangeEvent(self, event, timer, icon, label, eventType, callback, ...)
    if type(self) ~= "table" then return; end

    if type(event) == "number" and event > 0 and event <= #self.events then
        local me = self.events[event];
        if ( timer ) then
            me.frozen = false;
            me.timer = timer;
            if ( timer < 0 ) then
                me.triggered = true;
                me.warned = true; -- It'd be stupid to warn an event that's already expired.
                self:CheckReminderChange(me, "STOP");
          else
                me.triggered = false;
                me.warned = false;
                self:CheckReminderChange(me, "START");
            end
            if ( me.warningFrame ) then
                me.warningFrame:Remove();
                me.warningFrame = nil;
            end
        end
        if ( icon ) then
            me.icon = icon;
        end
        if ( label ) then
            me.label = label;
        end
        if ( eventType ) then
            me.type = eventType;
            CheckReminderChange(self, me, "STOP");
            CheckReminderChange(self, me, "START");
        end
        if ( callback ) then
            me.callback = callback;
            me.args = unpack(...);
        end

elseif type(event) == "string" then
        local i;
        for i=#self.events, 1, -1 do
            if ( self.events[i].name == event ) then
                self:ChangeEvent(i, timer, icon, label, eventType, callback, ...);
            end
        end
    end  
end

-- ********************************************************************
-- * self:FreezeEvent(event, state)                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher driver.                               *
-- * >> event: the index or name of the event.                        *
-- * >> state: whether to pause or unpause the event.                 *
-- ********************************************************************
-- * Pause or unpause the time flow of an event in the given event    *
-- * handler driver.                                                  *
-- ********************************************************************
local function FreezeEvent(self, event, state)
    if type(self) ~= "table" then return; end

    if type(event) == "number" and event > 0 and event <= #self.events then
        local me = self.events[event];
        if ( not me.triggered ) then
            me.frozen = state;
        end
        if ( state ) and ( me.warningFrame ) then
            me.warningFrame:Remove();
            me.warningFrame = nil;
        end

elseif type(event) == "string" then
        local i;
        for i=#self.events, 1, -1 do
            if ( self.events[i].name == event ) then
               self:FreezeEvent(i, state);
            end
        end
    end
end

-- ********************************************************************
-- * self:GetEventTimer(event)                                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher driver.                               *
-- * >> event: the index or name of the event to get timer of.        *
-- ********************************************************************
-- * Get the time left to an event in the given event watcher driver. *
-- * Also return the frozen flag of the event: true if it's paused.   *
-- ********************************************************************
local function GetEventTimer(self, event)
    if type(self) ~= "table" then return nil, nil; end

    if type(event) == "number" and event > 0 and event <= #self.events then
        return self.events[event].timer, self.events[event].frozen;

elseif type(event) == "string" then
        local i;
        for i=#self.events, 1, -1 do
            if ( self.events[i].name == event ) then
                return self:GetEventTimer(i);
            end
        end
    end

    return nil, nil;
end

-- ********************************************************************
-- * self:ToggleWarningMode(mode)                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher driver.                               *
-- * >> mode: the new warning mode. Either "TEXTUAL" or "GRAPHICAL".  *
-- ********************************************************************
-- * Set the warning mode used for events that are about to expire.   *
-- ********************************************************************
local function ToggleWarningMode(self, mode)
    if type(self) ~= "table" then return; end
    if ( mode ~= "TEXTUAL" and mode ~= "GRAPHICAL" ) then return; end

    self.warningMode = mode;
end

-- --------------------------------------------------------------------
-- **                         Private methods                        **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:CheckEventForWarning(eventData)                 - PRIVATE - *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher frame.                                *
-- * >> eventData: the event table of the event we want to check      *
-- * warnings for. It's not the same thing as event's index or name ! *
-- ********************************************************************
-- * Check if a given event should fire a (loud) warning/alert.       *
-- ********************************************************************
local function CheckEventForWarning(self, eventData)
    if type(eventData) ~= "table" then return; end

    local me = eventData;

    if ( self.warningMode == "TEXTUAL" ) then
        if ( me.type == "WARNING" or me.type == "WARNING_NOREMINDER" or me.type == "ALERT" ) and ( not me.warned ) and ( not me.triggered ) then
            if ( (me.type == "WARNING" or me.type == "WARNING_NOREMINDER") and me.timer <= WARNING_THRESHOLD ) or ( me.type == "ALERT" and me.timer <= ALERT_THRESHOLD ) then
                me.warned = true;
                local minorText = Manager:GetFreeMinorText();
                if ( minorText ) then
                    minorText:Display(Root.FormatLoc("EventWatcherWarning", me.label, math.floor(me.timer + 0.5)), 0.500, 2.500, 0.500);
                    PlaySound("RaidBossEmoteWarning");
                end
            end
        end
        if ( me.type == "ALERT" ) then
            local secondTick = math.floor(me.timer) + 1;
            if ( secondTick > 0 ) and ( secondTick <= ALERT_TICK_THRESHOLD ) and ( secondTick ~= me.alertStep ) then
                me.alertStep = secondTick;
                local minorText = Manager:GetFreeMinorText(true); -- Display the text, even if no text is available !
                if ( minorText ) then
                    minorText:Display("|cffff0000"..secondTick.."|r", 0.200, 0.500, 0.200);
                end
            end
        end
elseif ( self.warningMode == "GRAPHICAL" ) then
        if ( me.type == "WARNING" or me.type == "WARNING_NOREMINDER" or me.type == "ALERT" ) and ( not me.warned ) and ( not me.triggered ) then
            if ( (me.type == "WARNING" or me.type == "WARNING_NOREMINDER") and me.timer <= WARNING_THRESHOLD ) or ( me.type == "ALERT" and me.timer <= ALERT_THRESHOLD ) then
                me.warned = true;
                me.warningFrame = Manager:GetFreeEventWarning();
                if ( me.warningFrame ) then
                    me.warningFrame:Display(me.timer, me.label);
                    PlaySound("RaidBossEmoteWarning");
                end
            end
        end
    end
end

-- ********************************************************************
-- * self:CheckReminderChange(eventData, operation)       - PRIVATE - *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher frame.                                *
-- * >> eventData: the event data of the event that is being checked. *
-- * >> operation: START or STOP.                                     *
-- ********************************************************************
-- * Check if the reminded event has been just executed, removed,     *
-- * updated and if so, update the reminder timer accordingly.        *
-- ********************************************************************
local function CheckReminderChange(self, eventData, operation)
    local timerReminder = Manager:GetTimerReminder();

    if ( operation == "STOP" ) and ( eventData.name == self.remindedEvent ) then
        self.remindedEvent = nil;

        if ( timerReminder ) then
            timerReminder:GetDriver():Clear();
        end
    end

    if ( operation == "START" ) and ( not self.remindedEvent ) and ( eventData.type == "REMINDER" ) then
        self.remindedEvent = eventData.name;
    end

    if ( operation == "START" ) and ( self.remindedEvent == eventData.name ) then -- Refresh the timer.
        if ( timerReminder ) then
            timerReminder:GetDriver():Clear(); -- Make sure the timer reminder driver is free of task.
            timerReminder:GetDriver():Start(eventData.timer, 20);
        end
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function EventWatcherDriver.OnLoad(self)
    -- Properties
    self.ownedEventWatcher = nil;
    self.events = { };
    self.order = { };
    self.autoEventCounter = 0;
    self.remindedEvent = nil;
    self.warningMode = "TEXTUAL";

    -- Methods
    self.Setup = Setup;
    self.ClearAllEvents = ClearAllEvents;
    self.ClearEvent = ClearEvent;
    self.AddEvent = AddEvent;
    self.TriggerEvent = TriggerEvent;
    self.ChangeEvent = ChangeEvent;
    self.FreezeEvent = FreezeEvent;
    self.GetEventTimer = GetEventTimer;
    self.ToggleWarningMode = ToggleWarningMode;

    -- Private methods
    self.CheckEventForWarning = CheckEventForWarning;
    self.CheckReminderChange = CheckReminderChange;
end

function EventWatcherDriver.OnUpdate(self, elapsed)
    local myEventWatcher = self.ownedEventWatcher;
    if ( not myEventWatcher ) then return; end

    local i, me, thisArrow, icon, timer;

    -- Update all events
    for i=#self.events, 1, -1 do
        me = self.events[i];

        if ( not me.frozen ) then
            if type(me.timer) ~= "number" then
                Root.Print(string.format("ERROR DETECTED: event '%s' (value: %s)", me.name, tostring(me.timer or "nil")));
                self:ClearEvent(i);
          else
                me.timer = me.timer - elapsed;
                self:CheckEventForWarning(me);

                -- Boom !
                if ( me.timer <= 0.00 ) and ( not me.triggered ) then
                    self:TriggerEvent(i, false);
                end

                if ( me.timer <= -5.00 ) then -- Completely expired event and no longer visible on display.
                    self:ClearEvent(i);
                end
            end
        end
    end

    -- Ok, now we prepare the display on the owned event watcher.
    wipe(self.order);
    for i=1, #self.events do
        if ( self.events[i].type ~= "HIDDEN" ) then
            self.order[#self.order+1] = self.events[i]; -- Populate it, except hidden events.
        end
    end
    Root.Sort.ByNumericField(self.order, "timer", false);

    -- Position and update the arrows.
    for i=1, myEventWatcher:GetNumArrows() do
        thisArrow = myEventWatcher:GetArrow(i);
        if ( i <= #self.order ) then
            thisArrow:Display(self.order[i].timer, self.order[i].icon);
      else
            -- This arrow is useless.
            thisArrow:Hide();
        end
    end

    local timeScale = myEventWatcher:GetTimeScale();

    -- Update the rows.
    local o = 1;
    local assigned;
    for i=1, myEventWatcher:GetNumRows() do
        assigned = false;
        while ( o <= #self.order ) and ( not assigned ) do
            if ( self.order[o].timer > 0 ) then
                assigned = true;
                icon, timer = self.order[o].icon, self.order[o].timer;

                -- Find the appropriate color.
                local r, g, b = 1, 1, 1;
                if ( timer <= (timeScale * 5) ) then r, g, b = 1, 1, 0.2; end
                if ( self.order[o].frozen ) then r, g, b = 0.45, 0.45, 0.45; end

                -- Use the appropriate format pattern.
                local pattern;
                if ( timer >= 60 ) then
                    pattern = "%M : %S";
              else
                    pattern = "%S . %C";
                end

                myEventWatcher:ChangeRow(i, icon, self.order[o].label, Root.FormatCountdownString(pattern, timer), r, g, b);
            end
            o = o + 1;
        end
        if ( not assigned ) then
            -- This row is useless.
            myEventWatcher:ChangeRow(i, nil, nil);
        end
    end
end