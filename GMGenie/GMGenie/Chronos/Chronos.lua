--[[
--
--	Chronos
--		Keeper of Time
--
--	By AnduinLothar, Alexander Brazie, and Thott 
--
--	Chronos manages time. You can schedule a function to be called
--	in X seconds, with or without an id. You can request a timer, 
--	which tracks the elapsed duration since the timer was started. 
--
--  To use as an embeddable addon:
--	- Put the Chronos folder inside your Interface/AddOns/<YourAddonName>/ folder.
--	- Add Chronos\Chronos.xml to your toc or load it in your xml before your localization files.
--	- Add Chronos to the OptionalDeps in your toc
--	
--	To use as an addon library:
--	- Put the Chronos folder inside your Interface/AddOns/ folder.
--	- Add Chronos to the Dependencies in your toc
--
--	Please see below or see http://www.wowwiki.com/Chronos_(addon) for details.
--
--	$LastChangedBy: karlkfi $
--	$Date: 2006-12-21 06:19:14 -0600 (Thu, 21 Dec 2006) $
--	$Rev: 4467 $
--	
--]]

local CHRONOS_REV = 2.12;

local isBetterInstanceLoaded = (Chronos and Chronos.version and Chronos.version >= CHRONOS_REV);

if (not isBetterInstanceLoaded) then

    if (not Chronos) then
        Chronos = {};
    end

    Chronos.version = CHRONOS_REV;

    ------------------------------------------------------------------------------
    --[[ Variables ]] --
    ------------------------------------------------------------------------------

    Chronos.online = true;

    CHRONOS_DEBUG = false;
    CHRONOS_DEBUG_WARNINGS = false;

    -- Chronos Data
    if (not ChronosData) then
        ChronosData = {};
    end

    -- Chronos Recycled Tables Storage
    if (not Chronos.tables) then
        Chronos.tables = {};
    end

    -- Initialize the Timers
    if (not ChronosData.timers) then
        ChronosData.timers = {};
    end

    -- Initialize the perform-over-time task list
    if (not ChronosData.tasks) then
        ChronosData.tasks = {};
    end

    -- Maximum items per frame
    Chronos.MAX_TASKS_PER_FRAME = 100;

    -- Maximum steps per task
    Chronos.MAX_STEPS_PER_TASK = 300;

    -- Maximum time delay per frame
    Chronos.MAX_TIME_PER_STEP = .3;

    Chronos.emptyTable = {};

    ------------------------------------------------------------------------------
    --[[ User Functions ]] --
    ------------------------------------------------------------------------------

    --[[
    -- debug(boolean)
    --
    -- Toggles debug mode
    ]] --
    function Chronos.debug(enable)
        if (enable) then
            ChronosFrame:SetScript("OnUpdate", Chronos.OnUpdate_Debug);
            CHRONOS_DEBUG = true;
            CHRONOS_DEBUG_WARNINGS = true;
        else
            ChronosFrame:SetScript("OnUpdate", Chronos.OnUpdate_Quick);
            CHRONOS_DEBUG = false;
            CHRONOS_DEBUG_WARNINGS = false;
        end
    end

    --[[
    -- Scheduling functions
    -- Parts rewritten by AnduinLothar for efficiency
    -- Parts rewritten by Thott for speed
    -- Written by Alexander
    -- Original by Thott
    --
    -- Usage: Chronos.schedule(when,handler,arg1,arg2,etc)
    --
    -- After <when> seconds pass (values less than one and fractional values are
    -- fine), handler is called with the specified arguments, i.e.:
    --	 handler(arg1,arg2,etc)
    --
    -- If you'd like to have something done every X seconds, reschedule
    -- it each time in the handler or preferably use scheduleRepeating.
    --
    -- Also, please note that there is a limit to the number of
    -- scheduled tasks that can be performed per xml object at the
    -- same time.
    --]]
    function Chronos.schedule(when, handler, ...)
        if (not Chronos.online) then
            return;
        end
        if (not handler) then
            Chronos.printError("ERROR: nil handler passed to Chronos.schedule()");
            return;
        end

        --local memstart = collectgarbage("count");
        -- -- Assign an id
        -- local id = "";
        -- if ( not this ) then
        -- 	id = "Keybinding";
        -- else
        -- 	id = self:GetName();
        -- end
        -- if ( not id ) then
        -- 	id = "_DEFAULT";
        -- end
        -- if ( not when ) then
        -- 	Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: ", id , " has sent no interval for this function. ", when );
        -- 	return;
        -- end

        -- -- Ensure we're not looping ChronosFrame
        -- if ( id == "ChronosFrame" and ChronosData.lastID ) then
        -- 	id = ChronosData.lastID;
        -- end

        -- use recycled tables to avoid excessive garbage collection -AnduinLothar
        --tinsert(ChronosData.sched, Chronos.getTable())
        --local i = #ChronosData.sched
        local recTable = Chronos.getTable()
        -- ChronosData.sched[i].id = id;
        recTable.time = when + GetTime();
        recTable.handler = handler;
        recTable.args = Chronos.getArgTable(...);

        -- task list is a heap, add new
        local i = #ChronosData.sched + 1
        while (i > 1) do
            if (recTable.time < ChronosData.sched[i - 1].time) then
                i = i - 1;
            else
                break
            end
        end
        tinsert(ChronosData.sched, i, recTable)

        -- Debug print
        --Chronos.printDebugError("CHRONOS_DEBUG", "Scheduled "..handler.." in "..when.." seconds from "..id );
        --Chronos.printError("Memory change in schedule: "..memstart.."->"..memend.." = "..memend-memstart);
    end


    --[[
    --	Chronos.scheduleByName(name, delay, function, arg1, ... );
    --
    -- Same as Chronos.schedule, except it takes a schedule name argument.
    -- Only one event can be scheduled with a given name at any one time.
    -- Thus if one exists, and another one is scheduled, the first one
    -- is deleted, then the second one added.
    --
    --]]
    function Chronos.scheduleByName(name, when, handler, ...)
        if (not name) then
            Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: No name specified to Chronos.scheduleByName");
            return;
        end
        local namedSchedule = ChronosData.byName[name];
        if (namedSchedule and handler) then
            Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: scheduleByName is reasigning \"" .. name .. "\".");
            Chronos.releaseTable(ChronosData.byName[name]);
        else
            if (not handler) then
                if (not namedSchedule) then
                    Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: No handler specified to Chronos.scheduleByName, no previous entry found for scheduled entry \"" .. name .. "\".");
                    return;
                end
                if (not namedSchedule.handler) then
                    Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: No handler specified to Chronos.scheduleByName, no handler could be found in previous entry of \"" .. name .. "\" either.");
                    return;
                end
                handler = namedSchedule.handler;
                Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos: scheduleByName is updating \"" .. name .. "\" to time: " .. when);
            else
                Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos: scheduleByName is asigning \"" .. name .. "\".");
            end
        end
        ChronosData.byName[name] = Chronos.getTable();
        namedSchedule = ChronosData.byName[name];
        namedSchedule.time = when + GetTime()
        namedSchedule.handler = handler;
        namedSchedule.args = Chronos.getArgTable(...);
    end

    --[[
    --	unscheduleByName(name);
    --
    --		Removes an entry that was created with scheduleByName()
    --
    --	Args:
    --		name - the name used
    --
    --]]
    function Chronos.unscheduleByName(name)
        if (not Chronos.online) then
            return;
        end
        if (not name) then
            Chronos.printError("No name specified to Chronos.unscheduleByName");
            return;
        end
        if (ChronosData.byName[name]) then
            Chronos.releaseTable(ChronosData.byName[name]);
            ChronosData.byName[name] = nil;
        end

        -- Debug print
        --Chronos.printDebugError("CHRONOS_DEBUG", "Cancelled scheduled timer of name ",name);
    end

    --[[
    --	unscheduleRepeating(name);
    --		Mirrors unscheduleByName for backwards compatibility
    --]]
    Chronos.unscheduleRepeating = Chronos.unscheduleByName;

    --[[
    --	isScheduledByName(name)
    --		Returns the amount of time left if it is indeed scheduled by name!
    --
    --	returns:
    --		number - time remaining
    --		nil - not scheduled
    --
    --]]
    function Chronos.isScheduledByName(name)
        if (not Chronos.online) then
            return;
        end
        if (not name) then
            Chronos.printError("No name specified to Chronos.isScheduledByName " .. (self:GetName() or "unknown"));
            return;
        end
        local namedSchedule = ChronosData.byName[name];
        if (namedSchedule) then
            return namedSchedule.time - GetTime();
        end

        -- Debug print
        --Chronos.printDebugError("CHRONOS_DEBUG", "Did not find timer of name ",name);
        return nil;
    end

    --[[
    --	isScheduledRepeating(name)
    --		Mirrors isScheduledByName for backwards compatibility
    --]]
    Chronos.isScheduledRepeating = Chronos.isScheduledByName;

    --[[
    --	Chronos.scheduleRepeating(name, delay, function);
    --
    -- Same as Chronos.scheduleByName, except it repeats without recalling and takes no arguments.
    --
    --]]
    function Chronos.scheduleRepeating(name, when, handler)
        if (not name) then
            Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: No name specified to Chronos.scheduleRepeating");
            return;
        end
        local namedSchedule = ChronosData.byName[name];
        if (namedSchedule and handler) then
            Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: scheduleRepeating is reasigning " .. name);
            Chronos.releaseTable(ChronosData.byName[name]);
        else
            if (not handler) then
                if (not namedSchedule) then
                    Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: No handler specified to Chronos.scheduleRepeating, no previous entry found for scheduled entry '" .. name .. "'.");
                    return;
                end
                if (not namedSchedule.handler) then
                    Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: No handler specified to Chronos.scheduleRepeating, no handler could be found in previous entry '" .. name .. "' either.");
                    return;
                end
                handler = namedSchedule.handler;
                Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos: scheduleRepeating is updating '" .. name .. "' to time: " .. when);
            else
                Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos: scheduleRepeating is asigning '" .. name .. "'.");
            end
        end
        ChronosData.byName[name] = Chronos.getTable();
        namedSchedule = ChronosData.byName[name];
        namedSchedule.time = when + GetTime();
        namedSchedule.period = when;
        namedSchedule.handler = handler;
        namedSchedule.repeating = true;
    end

    --[[
    --	Chronos.flushByName(name, when);
    --
    -- Updates the ByName or Repeating event to flush at the time specified.  If no time is specified flush will be immediate. If it is a Repeating event the timer will be reset.
    --
    --]]
    function Chronos.flushByName(name, when)
        if (not name) then
            Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: No name specified to Chronos.flushByName");
            return;
        elseif (not ChronosData.byName[name]) then
            Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos Error Detection: no previous entry found for Chronos.flushByName entry '" .. name .. "'.");
            return;
        end
        if (not when) then
            Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos: flushing '" .. name .. "'.");
            when = GetTime();
        else
            Chronos.printDebugError("CHRONOS_DEBUG_WARNINGS", "Chronos: flushing '" .. name .. "' in " .. when .. " seconds.");
            when = when + GetTime();
        end
        ChronosData.byName[name].time = when;
    end

    --[[
    --	Chronos.startTimer([ID]);
    --		Starts a timer on a particular
    --
    --	Args
    --		ID - optional parameter to identify who is asking for a timer.
    --
    --		If ID does not exist, self:GetName() is used.
    --
    --	When you want to get the amount of time passed since startTimer(ID) is called,
    --	call getTimer(ID) and it will return the number in seconds.
    --
    --]]
    function Chronos.startTimer(id)
        if (not Chronos.online) then
            return;
        end

        if (not id) then
            id = self:GetName();
        end

        -- Create a table for this id's timers
        if (not ChronosData.timers[id]) then
            ChronosData.timers[id] = Chronos.getTable();
        end

        -- Clear out an entry if the table is too big.
        if (#ChronosData.timers[id] > Chronos.MAX_TASKS_PER_FRAME) then
            Chronos.printError("Too many Chronos timers created for id " .. tostring(id));
            return;
        end

        -- Add a new timer entry
        table.insert(ChronosData.timers[id], GetTime());
    end


    --[[
    --	endTimer([id]);
    --
    --		Ends the timer and returns the amount of time passed.
    --
    --	args:
    --		id - ID for the timer. If not specified, then ID will
    --		be self:GetName()
    --
    --	returns:
    --		(Number delta, Number start, Number end)
    --
    --		delta - the amount of time passed in seconds.
    --		start - the starting time
    --		now - the time the endTimer was called.
    --]]

    function Chronos.endTimer(id)
        if (not Chronos.online) then
            return;
        end

        if (not id) then
            id = self:GetName();
        end

        if (not ChronosData.timers[id] or #ChronosData.timers[id] == 0) then
            return nil;
        end

        local now = GetTime();

        -- Grab the last timer called
        local startTime = tremove(ChronosData.timers[id]);

        return (now - startTime), startTime, now;
    end


    --[[
    --	getTimer([id]);
    --
    --		Gets the timer and returns the amount of time passed.
    --		Does not terminate the timer.
    --
    --	args:
    --		id - ID for the timer. If not specified, then ID will
    --		be self:GetName()
    --
    --	returns:
    --		(Number delta, Number start, Number end)
    --
    --		delta - the amount of time passed in seconds.
    --		start - the starting time
    --		now - the time the endTimer was called.
    --]]

    function Chronos.getTimer(id)
        if (not Chronos.online) then
            return;
        end

        if (not id) then
            id = self:GetName();
        end

        local now = GetTime();
        if (not ChronosData.timers[id] or #ChronosData.timers[id] == 0) then
            return 0, 0, now;
        end

        -- Grab the last timer called
        local startTime = ChronosData.timers[id][#ChronosData.timers[id]];

        return (now - startTime), startTime, now;
    end

    --[[
    --	isTimerActive([id])
    --		returns true if the timer exists.
    --
    --	args:
    --		id - ID for the timer. If not specified, then ID will
    --		be self:GetName()
    --
    --	returns:
    --		true - exists
    --		false - does not
    --]]
    function Chronos.isTimerActive(id)
        if (not Chronos.online) then
            return;
        end

        if (not id) then
            id = self:GetName();
        end

        -- Create a table for this id's timers
        if (not ChronosData.timers[id]) then
            return false;
        end

        return true;
    end

    --[[
    --	getTime()
    --
    --		returns the Chronos internal elapsed time.
    --
    --	returns:
    --		(elapsedTime)
    --
    --		elapsedTime - time in seconds since Chronos initialized
    --]]
    function Chronos.getTime()
        return ChronosData.elapsedTime;
    end

    --[[
    --	Chronos.afterInit(func, ...)
    --		Performs func after the game has truely started.
    --	By Thott
    --]]
    function Chronos.afterInit(func, ...)
        local id;
        if (this) then
            id = self:GetName();
        else
            id = "unknown";
        end
        --if(id == "SkyFrame") then
        --	Chronos.printError("Ignoring Sky init");
        --	return;
        --end
        if (ChronosData.initialized) then
            func(...);
        else
            if (not ChronosData.afterInit) then
                ChronosData.afterInit = Chronos.getTable();
                Chronos.schedule(0.2, Chronos.initCheck);
            end
            local recTable = Chronos.getTable();
            recTable.func = func;
            recTable.args = Chronos.getArgTable(...);
            recTable.id = id;
            tinsert(ChronosData.afterInit, recTable);
        end
    end


    ------------------------------------------------------------------------------
    --[[ Table Recycling ]] --
    ------------------------------------------------------------------------------
    function Chronos.getTable(...)
        local stack = Chronos.tables;
        if (not stack) then
            Chronos.tables = {};
            stack = Chronos.tables;
            return {};
        end
        local recTable;
        if (#stack >= 1) then
            recTable = tremove(stack)
        else
            recTable = {};
        end
        for i = 1, select("#", ...) do
            recTable[i] = select(i, ...);
        end
        return recTable;
    end

    -- Release a table to be nilled and used again.
    -- Optionally pass in an unpack(...) as the 2nd arg so that you can return the args:
    -- return Chronos.releaseTable(t1, unpack(t1))
    function Chronos.releaseTable(t1, ...)
        if (type(t1) ~= "table") then
            return;
        end

        local stack = Chronos.tables;
        if (not stack) then
            Chronos.tables = {};
            stack = Chronos.tables;
        end

        for k, v in pairs(t1) do
            t1[k] = nil;
        end

        tinsert(stack, t1);
        return ...;
    end


    ------------------------------------------------------------------------------
    --[[ Helpers Functions ]] --
    ------------------------------------------------------------------------------
    function Chronos.getArgTable(...)
        if (select('#', ...) == 0) then
            return Chronos.emptyTable;
        else
            return Chronos.getTable(...);
        end
    end

    function Chronos.run(func, args)
        if (func) then
            if (args) then
                return func(unpack(args));
            else
                return func();
            end
        end
    end

    function Chronos.printError(text)
        ChatFrame1:AddMessage(text, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, 1.0, UIERRORS_HOLD_TIME);
    end

    function Chronos.printDebugError(var, text)
        if (var) and (getglobal(var)) then
            Chronos.printError(text);
        end
    end

    ------------------------------------------------------------------------------
    --[[ Frame Script Helpers ]] --
    ------------------------------------------------------------------------------
    function Chronos.chatColorsInit()
        ChronosData.chatColorsInitialized = true;
        ChronosFrame:UnregisterEvent("UPDATE_CHAT_COLOR");
    end

    function Chronos.initCheck()
        if (not ChronosData.initialized) then
            if (UnitName("player") and UnitName("player") ~= UKNOWNBEING and UnitName("player") ~= UNKNOWNBEING and UnitName("player") ~= UNKNOWNOBJECT and ChronosData.variablesLoaded and ChronosData.enteredWorld and ChronosData.chatColorsInitialized) then
                ChronosData.initialized = true;
                Chronos.schedule(1, Chronos.initCheck);
                return;
            else
                Chronos.schedule(0.2, Chronos.initCheck);
                return;
            end
        end
        if (ChronosData.afterInit) then
            local i = ChronosData.afterInit_i;
            if (not i) then
                i = 1;
            end
            ChronosData.afterInit_i = i + 1;
            --Chronos.printError("afterInit: processing ",i," of ",ChronosData.afterInit.n," initialization functions, id: ",ChronosData.afterInit[i].id);
            Chronos.run(ChronosData.afterInit[i].func, ChronosData.afterInit[i].args);
            if (i == #ChronosData.afterInit) then
                for i, v in ipairs(ChronosData.afterInit) do
                    Chronos.releaseTable(v);
                end
                Chronos.releaseTable(ChronosData.afterInit);
                ChronosData.afterInit = nil;
                ChronosData.afterInit_i = nil;
            else
                Chronos.schedule(0.1, Chronos.initCheck);
                return;
            end
        end
    end

    --[[
    --	Sends a chat command through the standard editbox
    --]]
    function Chronos.SendChatCommand(command)
        local text = ChatFrameEditBox:GetText();
        ChatFrameEditBox:SetText(command);
        ChatEdit_SendText(ChatFrameEditBox);
        ChatFrameEditBox:SetText(text);
    end

    function Chronos.RegisterSlashCommands()
        --Needs to be able Variables load if you want to use Sky
        local chronosFunc = function(msg)
            local _, _, seconds, command = string.find(msg, "([%d\.]+)%s+(.*)");
            if (seconds and command) then
                Chronos.schedule(seconds, Chronos.SendChatCommand, command);
            else
                Chronos.printError(SCHEDULE_USAGE1);
                Chronos.printError(SCHEDULE_USAGE2);
            end
        end
        if (Satellite) then
            Satellite.registerSlashCommand({
                id = "Schedule";
                commands = SCHEDULE_COMM;
                onExecute = chronosFunc;
                helpText = SCHEDULE_DESC;
                replace = true;
            });
        else
            SlashCmdList["CHRONOS_SCHEDULE"] = chronosFunc;
            for i = 1, #SCHEDULE_COMM do setglobal("SLASH_CHRONOS_SCHEDULE" .. i, SCHEDULE_COMM[i]); end
        end
    end

    ------------------------------------------------------------------------------
    --[[ Frame Scripts ]] --
    ------------------------------------------------------------------------------
    function Chronos.OnLoad()
        Chronos.framecount = 0;

        if (not ChronosData.byName) then
            ChronosData.byName = {};
        end
        if (not ChronosData.repeating) then
            ChronosData.repeating = {};
        end
        if (not ChronosData.sched) then
            ChronosData.sched = {};
        end
        ChronosData.elapsedTime = 0;

        Chronos.afterInit(Chronos.RegisterSlashCommands);
    end

    function Chronos.OnEvent(self, event, ...)
        if (event == "ADDON_LOADED") then
            ChronosData.variablesLoaded = true;
            ChronosFrame:Show();
        elseif (event == "PLAYER_ENTERING_WORLD") then
            ChronosData.enteredWorld = true;
            Chronos.online = true;
        elseif (event == "PLAYER_LEAVING_WORLD") then
            Chronos.online = false;
        elseif (event == "UPDATE_CHAT_COLOR") then
            Chronos.scheduleByName("ChronosAfterChatColorInit", 1, Chronos.chatColorsInit);
        end
    end

    function Chronos.OnUpdate_Quick(self, arg1)
        if (not Chronos.online) then
            return;
        end
        if (not ChronosData.variablesLoaded) then
            return;
        end

        if (ChronosData.elapsedTime) then
            ChronosData.elapsedTime = ChronosData.elapsedTime + arg1;
        else
            ChronosData.elapsedTime = arg1;
        end

        -- Execute scheduled tasks that are ready, pulling them off the front of the list queue.
        local now = GetTime();
        local i;
        local task;
        while (#ChronosData.sched > 0) do
            if (not ChronosData.sched[1].time) then
                --Sea.io.printTable(ChronosData.sched[1]);
                tremove(ChronosData.sched, 1);
            elseif (ChronosData.sched[1].time <= now) then
                task = tremove(ChronosData.sched, 1);
                Chronos.run(task.handler, task.args);
                Chronos.releaseTable(task);
            else
                break;
            end
        end

        -- Execute named scheduled tasks that are ready.
        local k, v = next(ChronosData.byName);
        local newK, newV;
        while (k ~= nil) do
            newK, newV = next(ChronosData.byName, k);
            if (not v.time) then
                --Sea.io.printTable(v);
                ChronosData.byName[k] = nil;
            elseif (v.time <= now) then
                if (v.repeating) then
                    ChronosData.byName[k].time = now + v.period;
                    v.handler();
                else
                    Chronos.run(v.handler, v.args);
                    Chronos.releaseTable(ChronosData.byName[k]);
                    ChronosData.byName[k] = nil;
                end
            end
            k, v = newK, newV;
        end
    end

    function Chronos.OnUpdate_Debug(self, arg1)
        if (not Chronos.online) then
            return;
        end
        if (not ChronosData.variablesLoaded) then
            return;
        end
        local memstart = collectgarbage("count");

        if (ChronosData.elapsedTime) then
            ChronosData.elapsedTime = ChronosData.elapsedTime + arg1;
        else
            ChronosData.elapsedTime = arg1;
        end

        local now = GetTime();
        local i;
        local task;
        -- Execute scheduled tasks that are ready, popping them off the heap.
        while (#ChronosData.sched > 0) do
            if (ChronosData.sched[1].time <= now) then
                task = tremove(ChronosData.sched, 1);
                Chronos.run(task.handler, task.args);
                Chronos.releaseTable(task);
            else
                break;
            end
        end

        local memend = collectgarbage("count");
        if (memend - memstart > 0) then
            Chronos.printError("gcmemleak from ChronosData.sched in OnUpdate: " .. (memend - memstart));
        end

        -- Execute named scheduled tasks that are ready.
        memstart = memend;
        local k, v = next(ChronosData.byName);
        local newK, newV;
        while (k ~= nil) do
            newK, newV = next(ChronosData.byName, k);
            if (v.time <= now) then
                local m = collectgarbage("count");
                if (v.repeating) then
                    ChronosData.byName[k].time = now + v.period;
                    v.handler();
                else
                    Chronos.run(v.handler, v.args);
                    Chronos.releaseTable(ChronosData.byName[k]);
                    ChronosData.byName[k] = nil;
                end
                local mm = collectgarbage("count");
                memstart = memstart + mm - m;
            end
            k, v = newK, newV;
        end

        memend = collectgarbage("count");
        if (memend - memstart > 0) then
            Chronos.printError("gcmemleak from ChronosData.byName in OnUpdate: " .. (memend - memstart));
        end
    end

    ------------------------------------------------------------------------------
    --[[ Frame Script Assignment ]] --
    ------------------------------------------------------------------------------

    Chronos.OnUpdate_Quick();

    --Event Driver
    if (not ChronosFrame) then
        CreateFrame("Frame", "ChronosFrame");
    end
    ChronosFrame:Hide();
    --Event Registration
    ChronosFrame:RegisterEvent("ADDON_LOADED");
    ChronosFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
    ChronosFrame:RegisterEvent("PLAYER_LEAVING_WORLD");
    ChronosFrame:RegisterEvent("UPDATE_CHAT_COLOR");
    --Frame Scripts
    ChronosFrame:SetScript("OnEvent", Chronos.OnEvent);
    ChronosFrame:SetScript("OnUpdate", Chronos.OnUpdate_Quick);
    --OnLoad Call
    Chronos.OnLoad();
end

