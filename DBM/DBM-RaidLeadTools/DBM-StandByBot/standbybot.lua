-- **********************************************************
-- **             Deadly Boss Mods - StandbyBot            **
-- **             http://www.deadlybossmods.com            **
-- **********************************************************
--
-- This addon is written and copyrighted by:
--    * Martin Verges (Nitram @ EU-Azshara)
--    * Paul Emmerich (Tandanu @ EU-Aegwynn)
-- 
-- The localizations are written by:
--    * enGB/enUS: Nitram/Tandanu        http://www.deadlybossmods.com		
--    * deDE: Nitram/Tandanu             http://www.deadlybossmods.com
--    * zhCN: yleaf(yaroot@gmail.com)
--    * zhTW: yleaf(yaroot@gmail.com)/Juha
--    * (add your names here!)
--
-- 
-- This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License. (see license.txt)
--
--  You are free:
--    * to Share  to copy, distribute, display, and perform the work
--    * to Remix  to make derivative works
--  Under the following conditions:
--    * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
--    * Noncommercial. You may not use this work for commercial purposes.
--    * Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
--

local mainframe = CreateFrame("frame", "DBM_StandyByBot", UIParent)

local default_settings = {
	enabled = false,
	send_whisper = false,
	sb_users = {},		-- currently standby
	sb_times = {},		-- times since last reset
	history = {},		-- save history on raidleave
	log = {}		-- bla joins at xx   bla leaves at xx
}

DBM_Standby_Settings = {}
local settings = default_settings

local L = DBM_StandbyBot_Translations
local sbbot_clients = {}

local revision = ("$Revision: 99 $"):sub(12, -3)

local SaveTimeHistory
local amIactive

local addDefaultOptions


do 
	local function creategui()
		local panel = DBM_RaidLeadPanel:CreateNewPanel(L.TabCategory_Standby, "option")
		do
			local area = panel:CreateArea(L.AreaGeneral, nil, 240, true)
			local enabled = area:CreateCheckButton(L.Enable, true)
			enabled:SetScript("OnShow", function(self) self:SetChecked(settings.enabled) end)
			enabled:SetScript("OnClick", function(self) 
				if DBM:IsInRaid() then
					if settings.enabled then
						SendAddonMessage("DBM_SbBot", "bye!", "RAID")
					else
						SendAddonMessage("DBM_SbBot", "Hi!", "RAID")
					end
				end
				settings.enabled = not not self:GetChecked() 
				
			end)

			local sendwhisper = area:CreateCheckButton(L.SendWhispers, true)
			sendwhisper:SetScript("OnShow", function(self) self:SetChecked(settings.send_whisper) end)
			sendwhisper:SetScript("OnClick", function(self) settings.send_whisper = not not self:GetChecked() end)

			local checkclients = area:CreateButton(L.Button_ShowClients, 100, 16)
			checkclients:SetPoint('TOPRIGHT', area.frame, "TOPRIGHT", -10, -10)
			checkclients:SetNormalFontObject(GameFontNormalSmall)
			checkclients:SetHighlightFontObject(GameFontNormalSmall)
			checkclients:SetScript("OnClick", function(self) 
				if DBM:IsInRaid() then
					SendAddonMessage("DBM_SbBot", "showversion!", "RAID")
				else
					DBM:AddMsg(L.Local_NoRaid)
				end
			end)

			local ptext = panel:CreateText(L.SB_Documentation, nil, nil, GameFontHighlightSmall, "LEFT")
			ptext:ClearAllPoints()
			ptext:SetPoint('TOPLEFT', area.frame, "TOPLEFT", 20, -60)
			ptext:SetPoint('BOTTOMRIGHT', area.frame, "BOTTOMRIGHT", -20, 10)
			
		end
		do	
			local area = panel:CreateArea(L.AreaStandbyHistory, nil, 260, true)

			local resetdkphistory = area:CreateButton(L.Button_ResetHistory, 100, 16)
			resetdkphistory:SetPoint('BOTTOMRIGHT', area.frame, "TOPRIGHT", 0, 0)
			resetdkphistory:SetNormalFontObject(GameFontNormalSmall)
			resetdkphistory:SetHighlightFontObject(GameFontNormalSmall)
			resetdkphistory:SetScript("OnClick", function(self) 
				table.wipe(settings.log)
				table.wipe(settings.history)
				table.wipe(settings.sb_users)
				table.wipe(settings.sb_times)

				DBM_GUI_OptionsFrame:Hide()
				DBM_GUI_OptionsFrame:Show()				
			end)

			local history = area:CreateScrollingMessageFrame(area.frame:GetWidth()-40, 220, nil, nil, GameFontHighlightSmall)
			history:ClearAllPoints()
			history:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 5, -5)
			history:SetPoint("BOTTOMRIGHT", area.frame, "BOTTOMRIGHT", 5, 5)

			history:SetScript("OnShow", function(self)
				self:SetMaxLines(#settings.log+1)
				for k,v in pairs(settings.log) do
					self:AddMessage(v)
				end
			end)
		end
		panel:SetMyOwnHeight()
	end
	DBM:RegisterOnGuiLoadCallback(creategui, 13)
end

function addDefaultOptions(t1, t2)
	for i, v in pairs(t2) do
		if t1[i] == nil then
			t1[i] = v
		elseif type(v) == "table" then
			addDefaultOptions(v, t2[i])
		end
	end
end

local function FormatPlayerName(name)
	if name:len() < 2 then return name; end
	-- check for UTF start
	if bit.band(name:sub(0, 1):byte(), 128) == 128 then
		name = name:sub(0, 2):upper()..name:sub(3):lower()
	else
		name = name:sub(0, 1):upper()..name:sub(2):lower()
	end
	return name
end

local function table_empty(table)
	for _,v in pairs(table) do
		return false
	end
	return true 
end

local function table_count(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

local function raidtime(minutes)
	local hours = math.floor(minutes/60)
	local minutes = (minutes-(hours*60))
	return minutes, hours
end

local function setStandby(name, nowsb)
	-- set player StandBy
	if nowsb then
		if settings.sb_users[name] then return false end -- allready SB
		table.insert(settings.log, L.History_OnJoin:format(date("%c"), name))
		settings.sb_users[name] = time()

		if amIactive() then 
			SendAddonMessage("DBM_SbBot", "!sb add "..name, "RAID")
		end
		return true

	else -- remove from StandBy
		if not settings.sb_users[name] then return false end

		local sbtime = math.floor((time() - settings.sb_users[name]) / 60) 	-- time in minutes
		table.insert(settings.log, L.History_OnLeave:format(date("%c"), name, sbtime))
		
		if not settings.sb_times[name] then settings.sb_times[name] = 0 end
		settings.sb_times[name] = settings.sb_times[name] + sbtime

		if amIactive() then
			SendAddonMessage("DBM_SbBot", "!sb del "..name, "RAID")
		end

		settings.sb_users[name] = nil
		return settings.sb_times[name]
	end
end

-- Function to update (save) all times to prevent problems from disconnects / stuff like this!
-- also required for !sb times to show users their SB Time
local function UpdateTimes()
	for name, starttime in pairs(settings.sb_users) do
		settings.sb_times[name] = (settings.sb_times[name] or 0) + ((time() - starttime) / 60)
		-- math.round
		settings.sb_times[name] = math.floor(0.5 + settings.sb_times[name])
		settings.sb_users[name] = time()
	end
end

function amIactive()
	if not DBM:IsInRaid() then return false end

	local myname = UnitName("player")

	for k,v in pairs(sbbot_clients) do
		if DBM:GetRaidRank(k) >= 2 then	-- raidleader gefunden
			if k == myname then
				-- uhm jeha i'm the raidlead, so i'm the one who shall do the stuff!
				return true
			else
				-- we found a player with SB Bot and RaidLead Flag
				return false
			end
		end
	end
	for k,v in pairs(sbbot_clients) do
		if UnitIsConnected(DBM:GetRaidUnitId(k)) and k < myname then
			-- we don't need to start, the player with hightest name is used
			return false
		end
	end
	return true
end

local function AddStandbyMember(name, quiet)
	if not settings.enabled then return end
	if not name or name:len() < 2 then return false end
	if not amIactive() then quite = true end

	if settings.sb_users[name] == nil then
		-- a brand new member
		if not quiet then
			DBM:AddMsg( L.Local_AddedPlayer:format(name) )
			SendChatMessage("<DBM> "..L.AddedSBUser, "WHISPER", nil, name)
		end
		setStandby(name, true)
	else
		-- member allready on the list
		if not quiet then 
			SendChatMessage("<DBM> "..L.UserIsAllreadySB, "WHISPER", nil, name)
		end
	end
end

local function RemoveStandbyMember(name, quiet)
	if not settings.enabled then return false end
	if not name then return false end

	if not amIactive() then quite = true end

	if settings.sb_users[name] == nil then
		return false
	else
		-- remove user
		local sbtime = setStandby(name, false)
		if not quiet then
			DBM:AddMsg( L.Local_RemovedPlayer:format(name) )

			local minutes, hours = raidtime(sbtime)
			SendChatMessage("<DBM> "..L.NoLongerStandby:format(hours or 0, minutes or 0), "WHISPER", nil, name)
		end
		return true
	end
end

do
	function SaveTimeHistory()
		UpdateTimes()
		if not table_empty(settings.sb_times) then
			table.wipe(settings.sb_users)
			table.insert(settings.history, {
				["date"] = date(L.DateTimeFormat),
				["member"] = settings.sb_times
			})
			settings.sb_times = {}

			DBM:AddMsg( L.SB_History_Saved:format(#settings.history) )
		else
			DBM:AddMsg( L.SB_History_NotSaved )
		end
	end

	DBM:RegisterCallback("raidLeave", function(event, name)
		if settings.enabled and name and select(2, IsInInstance()) ~= "pvp" and select(2, IsInInstance()) ~= "arena" then
			if name == UnitName("player") then 
				SaveTimeHistory() 

			elseif amIactive() and settings.send_whisper then
				SendChatMessage("<DBM> "..L.LeftRaidGroup, "WHISPER", nil, name)
			end
		end
	end)
	DBM:RegisterCallback("raidJoin", function(event, ...) return RemoveStandbyMember(...) end)
end

do	
	local function RegisterEvents(...)
		for i = 1, select("#", ...) do
			mainframe:RegisterEvent(select(i, ...))
		end
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", 
		function(self, event, ...) 
			local msg = ...
			if not msg then -- old style pre ulduar patch
				return self:find("^!sb")
			else
				return msg:find("^!sb"), ... 
			end
		end
	)

	mainframe:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and select(1, ...) == "DBM-RaidLeadTools" then
			-- Update settings of this Addon
			settings = DBM_Standby_Settings
			addDefaultOptions(settings, default_settings)

			DBM:RegisterCallback("raidJoin", function(event, name)
				if settings.enabled and name and select(2, IsInInstance()) ~= "pvp" and select(2, IsInInstance()) ~= "arena" then
					if name == UnitName("player") then 
						SendAddonMessage("DBM_SbBot", "Hi!", "RAID")
					end 
				end
			end)

			RegisterEvents(
				"CHAT_MSG_GUILD",
				"CHAT_MSG_RAID",
				"CHAT_MSG_PARTY",
				"CHAT_MSG_OFFICER",
				"CHAT_MSG_RAID_LEADER",
				"CHAT_MSG_WHISPER",
				"CHAT_MSG_ADDON"
			)
	
		elseif settings.enabled and event == "CHAT_MSG_WHISPER" and DBM:IsInRaid() then
			local msg, author = select(1, ...)
			if msg == "!sb" then
				if DBM:GetRaidUnitId(author) == "none" then
					AddStandbyMember( author )
				else
					SendChatMessage("<DBM> "..L.InRaidGroup, "WHISPER", nil, author)
				end
			elseif msg == "!sb off" then
				RemoveStandbyMember( author )
			end

		elseif settings.enabled and event == "CHAT_MSG_ADDON" then
			local prefix, msg, channel, sender = select(1, ...)
			if prefix ~= "DBM_SbBot" then return end
			if sender == UnitName("player") then return end

			if msg == "Hi!" then
				sbbot_clients[sender] = true
				if channel == "RAID" then
					SendAddonMessage("DBM_SbBot", "Hi!", "WHISPER", sender)				
				end

			elseif msg == "showversion!" then
				if channel == "RAID" then
					SendAddonMessage("DBM_SbBot", "version: r"..tostring(revision), "WHISPER", sender)
				end

			elseif msg:sub(0, 9) == "version: " then
				DBM:AddMsg( L.Local_Version:format(sender, msg:sub(9)) )

			elseif msg == "refresh!" and sbbot_clients[sender] and amIactive() then
				UpdateTimes()
				SendAddonMessage("DBM_SbBot", "cleanup!", "WHISPER", sender)

				for k,v in pairs(settings.sb_times) do
					SendAddonMessage("DBM_SbBot", "TIMES:"..v..":"..k, "WHISPER", sender)
				end
				for k,v in pairs(settings.sb_users) do
					SendAddonMessage("DBM_SbBot", "SBUSER:"..v..":"..k, "WHISPER", sender)
				end

			elseif msg == "cleanup!" then
				DBM:AddMsg( L.Local_CleanList:format(sender) )
				table.wipe(settings.sb_times)
				table.wipe(settings.sb_users)

			elseif strsplit(":",msg) == 3 and select(1, strsplit(":",msg)) == "TIMES" then
				local value, key = select(2, strsplit(":",msg))
				settings.sb_times[key] = tonumber(value)

			elseif strsplit(":",msg) == 3 and select(1, strsplit(":",msg)) == "SBUSER" then
				local value, key = select(2, strsplit(":",msg))
				settings.sb_users[key] = tonumber(value)


			elseif msg == "bye!" then
				sbbot_clients[sender] = nil

			elseif msg:find("^!sb add") then
				AddStandbyMember(FormatPlayerName( strtrim(msg:sub(8)) ), true)

			elseif msg:find("^!sb del") then
				RemoveStandbyMember(FormatPlayerName( strtrim(msg:sub(8)) ), true)
			end
		end
		
		if settings.enabled and event:sub(0, 9) == "CHAT_MSG_" and event ~= "CHAT_MSG_WHISPER" and event ~= "CHAT_MSG_ADDON" then
			local active = amIactive()
			
			local msg, author = select(1, ...)
			if active and msg == "!sb" then
				local output = ""
				for k,v in pairs(settings.sb_users) do
					output = output..", "..k
				end
				output = output:sub(2)
				if output == "" then output = "none" end
				SendChatMessage("<DBM> "..L.PostStandybyList.." "..output, "WHISPER", nil, author)

			elseif msg == "!sb time" or msg == "!sb times" then
				UpdateTimes()
				if not table_empty(settings.sb_times) then
					SendChatMessage(L.Current_StandbyTime:format(date(L.DateTimeFormat)), "GUILD")
					local users = ""
					local count = 0
					
					for k,v in pairs(settings.sb_times) do
						count = count + 1 
						local minutes, hours = raidtime(v)
						users = users..k.."("..string.format("%02d", hours)..":"..string.format("%02d", minutes).."), "

						if count >= 3 then
							count = 0
							SendChatMessage(users:sub(0, -2), "GUILD")
							users = ""
						end
					end
					if count > 0 then
						SendChatMessage(users:sub(0, -2), "GUILD")
					end
				end
			elseif msg == "!sb history" then
				for i=#settings.history, 1, -1 do
					local raid = settings.history[i]
					SendChatMessage(L.SB_History_Line:format(i, raid.date, table_count(raid.member)), "GUILD")
					if #settings.history - i > 3 then return end
				end

			elseif msg:find("^!sb history") then
				local id = tonumber(strtrim(msg:sub(13))) or 0
				if id > 0 and settings.history[id] then
					local raid = settings.history[id]
					SendChatMessage(L.Current_StandbyTime:format(raid.date), "GUILD")
					local users = ""
					local count = 0
					
					for k,v in pairs(raid.member) do
						count = count + 1 
						local minutes, hours = raidtime(v)
						users = users..k.."("..string.format("%02d", hours)..":"..string.format("%02d", minutes).."), "

						if count >= 3 then
							count = 0
							SendChatMessage(users:sub(0, -2), "GUILD")
							users = ""
						end
					end
					if count > 0 then
						SendChatMessage(users:sub(0, -2), "GUILD")
					end
				end

			elseif active and msg:find("^!sb add") then
				local name = FormatPlayerName( strtrim(msg:sub(8)) )
				AddStandbyMember(name)

			elseif active and msg:find("^!sb del") then
				local name = FormatPlayerName( strtrim(msg:sub(8)) )
				if not RemoveStandbyMember(name) then
					DBM:AddMsg(L.Local_CantRemove)
				end

			elseif msg == "!sb reset" and author == UnitName("player") then
				table.wipe(settings.sb_times)
				table.wipe(settings.sb_users)

			elseif msg == "!sb save" and author == UnitName("player") then
				SaveTimeHistory()

			elseif msg == "!sb clients" then -- debuging 
				for k,v in pairs(sbbot_clients) do
					DBM:AddMsg(k)
				end
			end

		end
	end)
	
	-- lets register the Events
	RegisterEvents("ADDON_LOADED")

end


