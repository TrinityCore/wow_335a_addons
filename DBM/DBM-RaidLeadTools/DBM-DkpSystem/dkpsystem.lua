-- **********************************************************
-- **             Deadly Boss Mods - DKP System            **
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
--    * zhTW: readjust by yleaf(yaroot@gmail.com)/Juha
--    * koKR: BlueNyx(bluenyx@gmail.com)
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
--

local default_settings = {
	enabled = false,
	grpandraid = false,		-- track 5ppl inis also!
	sb_as_raid = true,		-- count Standby Players as Raid Members

	time_event = false,		-- count raid attendance by time and bosskills
	time_to_count = 60,		-- count all 60 Min an Event "raid attendance"
	time_points = 10,		-- points to count on time events
	time_desc = "Raid Attendance",	-- name of the Event for Time Based DKP

	boss_event = true,		-- create Event for BossKills
	boss_points = 10, 		-- points to count for Bosskill
	boss_desc = "%s",		-- name of the Event for BossKills (Killed Boss: %s)

	start_event = true,		-- create a RaidStart Event
	start_points = 10,		-- points to get for Raidstart
	start_desc = "Raid Start",	-- name of the Event for EQDKP

	working_in = 0,			-- ID of actual History (for direct export to History)
	items = {},			-- items wating for event
	history = {},			-- history of raids

	lastevent = 0			-- we want to save our lastevnet
}

DBM_DKP_System_Settings = {}
local settings = default_settings

local L = DBM_DKP_System_Translations

--local lastevent = 0
local timespend = 0
local start_time = 0

-- functions
local RaidStart
local RaidEnd
local GetRaidList
local CreateEvent
local addDefaultOptions
local ShowExportString

do
	local function creategui()
		local panel = DBM_RaidLeadPanel:CreateNewPanel(L.TabCategory_DKPSystem, "option")
		do
			local area = panel:CreateArea(L.AreaManageRaid, nil, 150, true)

			local button = area:CreateButton(L.Button_StartDKPTracking, 200, 25)
			button:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 10, -20)
			button:SetScript("OnShow", function(self) 
				if settings.working_in > 0 then
					self:SetText(L.Button_StopDKPTracking)
				else 
					self:SetText(L.Button_StartDKPTracking)
				end
			end)
			button:SetScript("OnClick", function(self)
				if settings.working_in > 0 then
					RaidEnd()
					settings.working_in = 0 
					DBM_GUI_OptionsFrame:DisplayFrame(panel.frame)
				else
					if GetNumRaidMembers() == 0 then
						DBM:AddMsg(L.Local_NoRaidPresent)
					else
						RaidStart()
					end
				end
				self:GetScript("OnShow")(self)
			end)

			local neweventpoints 	= area:CreateEditBox(L.CustomPoint, "", 75)
			local neweventdescr 	= area:CreateEditBox(L.CustomDescription, L.CustomDefault, 250)
			neweventpoints:SetNumeric()
			neweventpoints:SetMaxLetters(5)
			neweventpoints:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 15, -25)
			neweventdescr:SetMaxLetters(30)
			neweventdescr:SetPoint("TOPLEFT", neweventpoints, "TOPRIGHT", 40, 0)

			local DKPto = "RAID"
			local pltable = {{text=L.AllPlayers, value="RAID"}}
			local dkpfor 	= area:CreateDropdown(L.ChatChannel, pltable, "RAID", function(value) DKPto = value end)
			dkpfor:SetPoint("TOPLEFT", neweventpoints, "BOTTOMLEFT", -25, -5)
			dkpfor:SetScript("OnShow", function(self)
				if GetNumRaidMembers() > 0 then
					table.wipe(pltable)
					table.insert(pltable, {text=L.AllPlayers, value="RAID"})
					for k,v in pairs(GetRaidList()) do
						table.insert(pltable, {text=v, value=v})
					end
				end
			end)

			local button = area:CreateButton(L.Button_CreateEvent, 200, 25)
			button:SetPoint("TOPRIGHT", neweventdescr, "BOTTOMRIGHT", 5, -5)
			button:SetScript("OnClick", function(self)
				if neweventpoints:GetNumber() <= 0 or neweventdescr:GetText() == "" then 
					DBM:AddMsg(L.Local_NoInformation)
				else
					local event = {
						event_type = "custom",
						zone = GetRealZoneText(),
						description = neweventdescr:GetText(),
						points = neweventpoints:GetNumber(),
						timestamp = time()
					}
					if DKPto == "RAID" then
						event.members = GetRaidList()
					else
						event.members = DKPto
					end
					CreateEvent(event)
					DBM:AddMsg(L.Local_EventCreated)
					neweventpoints:SetText("")
					neweventdescr:SetText("")
				end
			end)
		end
		do
			local area = panel:CreateArea(L.AreaGeneral, nil, 320, true)

			local enabled = area:CreateCheckButton(L.Enable, true)
			enabled:SetScript("OnShow", function(self) self:SetChecked(settings.enabled) end)
			enabled:SetScript("OnClick", function(self) settings.enabled = not not self:GetChecked() end)
			
			local in5pplinis = area:CreateCheckButton(L.Enable_5ppl_tracking, true)
			in5pplinis:SetScript("OnShow", function(self) self:SetChecked(settings.grpandraid) end)
			in5pplinis:SetScript("OnClick", function(self) settings.grpandraid = not not self:GetChecked() end)

			local sbusers = area:CreateCheckButton(L.Enable_SB_Users, true)
			sbusers:SetScript("OnShow", function(self) self:SetChecked(settings.sb_as_raid) end)
			sbusers:SetScript("OnClick", function(self) settings.sb_as_raid = not not self:GetChecked() end)

			-- Create Start Events
			local startevent 	= area:CreateCheckButton(L.Enable_StarEvent, true)
			local startpoints 	= area:CreateEditBox(L.StartPoints, settings.start_points, 75)
			local startdescr 	= area:CreateEditBox(L.StartDescription, settings.start_desc, 250)
			startevent:SetScript("OnShow", function(self) self:SetChecked(settings.start_event) end)
			startevent:SetScript("OnClick", function(self) settings.start_event = not not self:GetChecked() end)
			startpoints:SetNumeric()
			startpoints:SetMaxLetters(5)
			startpoints:SetPoint("TOPLEFT", startevent, "BOTTOMLEFT", 15, -10)
			startpoints:SetScript("OnShow", function(self) self:SetText(settings.start_points) end)
			startpoints:SetScript("OnTextChanged", function(self) settings.start_points = self:GetNumber() end)
			startdescr:SetMaxLetters(30)
			startdescr:SetPoint("TOPLEFT", startpoints, "TOPRIGHT", 40, 0)
			startdescr:SetScript("OnShow", function(self) self:SetText(settings.start_desc) end)
			startdescr:SetScript("OnTextChanged", function(self) settings.start_desc = self:GetText() end)

			-- Create Boss Events
			local bossevent 	= area:CreateCheckButton(L.Enable_BossEvents)
			local bosspoints 	= area:CreateEditBox(L.BossPoints, settings.boss_points, 75)
			local bossdescr 	= area:CreateEditBox(L.BossDescription, settings.boss_desc, 250)
			bossevent:SetScript("OnShow", function(self) self:SetChecked(settings.boss_event) end)
			bossevent:SetScript("OnClick", function(self) settings.boss_event = not not self:GetChecked() end)
			bossevent:SetPoint("TOPLEFT", startevent, "BOTTOMLEFT", 0, -40)
			bosspoints:SetNumeric()
			bosspoints:SetMaxLetters(5)
			bosspoints:SetPoint("TOPLEFT", bossevent, "BOTTOMLEFT", 15, -10)
			bosspoints:SetScript("OnShow", function(self) self:SetText(settings.boss_points) end)
			bosspoints:SetScript("OnTextChanged", function(self) settings.boss_points = self:GetNumber() end)
			bossdescr:SetMaxLetters(30)
			bossdescr:SetPoint("TOPLEFT", bosspoints, "TOPRIGHT", 40, 0)
			bossdescr:SetScript("OnShow", function(self) self:SetText(settings.boss_desc) end)
			bossdescr:SetScript("OnTextChanged", function(self) settings.boss_desc = self:GetText() end)

			-- Create Time Events
			local timeevent 	= area:CreateCheckButton(L.Enable_TimeEvents)
			local timepoints 	= area:CreateEditBox(L.TimePoints, settings.time_points, 75)
			local timecount		= area:CreateEditBox(L.TimeToCount, settings.time_to_count, 75)
			local timedescr 	= area:CreateEditBox(L.TimeDescription, settings.time_desc, 250)
			timeevent:SetScript("OnShow", function(self) self:SetChecked(settings.time_event) end)
			timeevent:SetScript("OnClick", function(self) settings.time_event = not not self:GetChecked() end)
			timeevent:SetPoint("TOPLEFT", startevent, "BOTTOMLEFT", 0, -105)
			timepoints:SetNumeric()
			timepoints:SetMaxLetters(5)
			timepoints:SetPoint("TOPLEFT", timeevent, "BOTTOMLEFT", 15, -10)
			timepoints:SetScript("OnShow", function(self) self:SetText(settings.time_points) end)
			timepoints:SetScript("OnTextChanged", function(self) settings.time_points = self:GetNumber() end)
			timecount:SetNumeric()
			timecount:SetMaxLetters(4)
			timecount:SetPoint("TOPLEFT", timepoints, "BOTTOMLEFT", 0, -15)
			timecount:SetScript("OnShow", function(self) self:SetText(settings.time_to_count) end)
			timecount:SetScript("OnTextChanged", function(self) settings.time_to_count = self:GetNumber() end)
			timedescr:SetMaxLetters(30)
			timedescr:SetPoint("TOPLEFT", timecount, "TOPRIGHT", 40, 0)
			timedescr:SetScript("OnShow", function(self) self:SetText(settings.time_desc) end)
			timedescr:SetScript("OnTextChanged", function(self) settings.time_desc = self:GetText() end)

			local resetdkphistory = area:CreateButton(L.Button_ResetHistory, 100, 16)
			resetdkphistory:SetPoint('BOTTOMRIGHT', area.frame, "TOPRIGHT", 0, 0)
			resetdkphistory:SetNormalFontObject(GameFontNormalSmall)
			resetdkphistory:SetHighlightFontObject(GameFontNormalSmall)
			resetdkphistory:SetScript("OnClick", function(self) 
				table.wipe(settings.items)
				table.wipe(settings.history)
				addDefaultOptions(settings, default_settings)

				DBM_GUI_OptionsFrame:Hide()
				DBM_GUI_OptionsFrame:Show()				
			end)

		end
		panel:SetMyOwnHeight()

		local historypanel = panel:CreateNewPanel(L.TabCategory_History, "option")
		do
			local area = historypanel:CreateArea(L.AreaHistory, nil, 360, true)

			local history = area:CreateScrollingMessageFrame(area.frame:GetWidth()-20, 150, nil, nil, GameFontNormalSmall)
			history:ClearAllPoints()
			history:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 5, -5)
			history:SetPoint("BOTTOMRIGHT", area.frame, "BOTTOMRIGHT", 5, 5)

			history:SetScript("OnShow", function(self)
				if #settings.history > 0 then
					local lastzone = ""
					self:SetMaxLines(100)
					for i=1, #settings.history, 1 do
						local raid = settings.history[i]
						if #raid.events > 0 then
							for k,event in pairs(raid.events) do
								if event.zone ~= lastzone then
									self:AddMessage(" ")
								end
								local link = "|HDBM:showdkp:"..i..":"..k.."|h|cff3588ff[show]|r|h"
								if type(event.members) ~= "table" then event.members = {} end
								self:AddMessage( link..L.History_Line:format(date(L.DateFormat, event.timestamp), event.zone, event.description, (#event.members or 0))  )
								lastzone = event.zone
							end
						end
					end
				else
					self:SetMaxLines(2)
				end
			end)
			history:SetScript("OnHyperlinkClick", function(self, link, string, button, ...)
				local linkType, arg1, history, event = strsplit(":", link)
				if linkType == "DBM" and arg1 == "showdkp" and history and event then
					history = tonumber(history)
					event = tonumber(event)
					--DBM:AddMsg("Opening DKP String for Event: "..event.." from Raid "..history)
					ShowExportString(history, event) 
				end
			end)

		end
		historypanel:SetMyOwnHeight()
	end
	DBM:RegisterOnGuiLoadCallback(creategui, 13)
end

-- EXPORT (event based) for EQDKP - RaidTracker Addon
function CreateExportString(raid_id, event_id)
	if not raid_id or type(raid_id) ~= "number" then return "raid_id failed", 0, 0 end
	if not event_id or type(event_id) ~= "number" then return "event_id failed", 0, 0 end

	local raid = settings.history[raid_id]
	local event = raid.events[event_id]
	if not raid or not event then return "failed to find event" end
	local text
	local players = ""
	local raid_start = date(L.DateFormat, event.timestamp)
	local raid_end = date(L.DateFormat, event.timestamp)

	-- Creating RaidEvent 
	text = "<RaidInfo><key>"..raid_start.."</key><start>"..raid_start.."</start><end>"..raid_end.."</end><zone>"..(event.zone or "").."</zone><note>"..(event.points or "").."</note><PlayerInfos>"

	-- Adding Players to this Event
	for i,name in ipairs(event.members) do
		text = text.."<key"..i.."><name>"..name.."</name></key"..i..">"
		players = players.."<key"..i.."><player>"..name.."</player><time>"..raid_start.."</time></key"..i..">"
	end
	text = text.."</PlayerInfos>"

	-- Adding BossKill
	text = text.."<BossKills><key1><name>"..event.description.."</name><time>"..date(L.DateFormat, event.timestamp).."</time><attendees/></key1></BossKills>"

	-- Adding the CTRaid Stuff for their Player Leave/Join Events
	text = text.."<note><![CDATA["..(event.zone or "").." - "..(event.description or "").."]]></note>"
	text = text.."<Join>"..players.."</Join><Leave>"..players.."</Leave>"

	-- Adding loot to the textblock
	text = text.."<Loot>"
	for k, item in pairs(event.items or {}) do
		local ItemName = GetItemInfo(item.item)
		local ItemID = select(2, strsplit(":", item.item))
		local color = string.sub(item.item:match("^|(%x+)|"), 2)

		text = text.."<key"..k.."><ItemName>"..(ItemName or "?").."</ItemName><ItemID>"..ItemID.."</ItemID>"
		text = text.."<Icon></Icon><Class></Class><SubClass></SubClass><Color>"..color.."</Color><Count>1</Count>"
		text = text.."<Player>"..item.player.."</Player><Costs>"..item.points.."</Costs><Time>"..date(L.DateFormat, event.timestamp).."</Time>"
		text = text.."<Zone></Zone><Boss>"..event.description.."</Boss>"
		text = text.."<Note><![CDATA[ - Zone: "..(event.zone or "unknown").." - Boss: "..(event.description or "unknown").." - "..(item.points or 0).." DKP]]></Note>"
		--text = text.."<Note>"..event.description.."</Note>"
		text = text.."</key"..k..">"
	end

	text = text.."</Loot></RaidInfo>"
	return text, raid, event
end	

do
	local content
	local raid
	local event

	StaticPopupDialogs["DBM_EXPORT_DKP_STRING"] = {
		text = "DKP String - %s",
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		OnShow = function(self)
			self.editBox:SetMaxLetters( content:len() + 10 )
			self.editBox:SetText(content)
			self.editBox:SetFocus()
			self.editBox:HighlightText()
		end,
		timeout = 0,
		exclusive = 0,
		hideOnEscape = 1
	}

	function ShowExportString(raid_id, event_id) 
		content, raid, event = CreateExportString(raid_id, event_id)
		StaticPopup_Show("DBM_EXPORT_DKP_STRING", "raid")
	end
end


function GetRaidList()
	if GetNumRaidMembers() == 0 then return false end
	local raidusers = {}
	for i=1, GetNumRaidMembers(), 1 do
		if UnitName("raid"..i) then
			table.insert(raidusers, (UnitName("raid"..i)))
		end
	end

	if settings.grpandraid then
		table.insert(raidusers, (UnitName("player")) )
		for i=1, GetNumPartyMembers(), 1 do
			if UnitName("party"..i) then
				table.insert(raidusers, (UnitName("party"..i)))
			end
		end
	end

	if settings.sb_as_raid then
		for k,v in pairs(DBM_Standby_Settings.sb_users) do
			table.insert(raidusers, k)
		end
	end
	return raidusers
end

function DBM_AddItemToDKP(itemtable)
	if not itemtable or type(itemtable) ~= "table" then
		DBM:AddMsg("Function DBM_AddItemToDKP(itemtable) call failed. Debugstack: "..debugstack())
		return false

	elseif settings.working_in == 0 then
		DBM:AddMsg(L.LocalError_AddItemNoRaid)
		return false
	end

	if settings.working_in > 0 and settings.history[settings.working_in] and #settings.history[settings.working_in].events > 0 then
		local events = settings.history[settings.working_in].events
		local event = events[#events]

		if not event.items or type(event.items) ~= "table" then event.items = {} end
		table.insert(event.items, itemtable)
	else 
		-- Item is queued to get added at the first event in this raid!
		table.insert(settings.items, itemtable)
	end
end

function CreateEvent(event)
	if settings.working_in == 0 or not settings.history[settings.working_in] then
		local history = {
			time_start = start_time,
			time_end = time(),
			events = {}
		}
		table.insert(settings.history, history)
		settings.working_in = #settings.history
	end
	settings.lastevent = time()

	if not event.items or type(event.items) ~= "table" then event.items = {} end
	if type(settings.items) == "table" and #settings.items > 0 then
		-- first event, adding pending loots (like epic drops before the first boss (and without start event))
		addDefaultOptions(event.items, settings.items)
		table.wipe(settings.items)
	end

	if not event.members then event.members = GetRaidList() end
	if type(event.members) ~= "table" then event.members = {} end
	if #event.members then
		table.insert(settings.history[settings.working_in].events, event)
	else
		DBM:AddMsg(L.Local_Debug_NoRaid)
	end
end

function DBM_DKP_BossKill(event, bossmod)
	if settings.boss_event then
		CreateEvent({
			event_type = "bosskill",
			zone = GetRealZoneText(),
			description = settings.boss_desc:format(bossmod.localization.general.name),
			points = settings.boss_points,
			timestamp = time()
		})		
	end
end
DBM:RegisterCallback("kill", DBM_DKP_BossKill)


function RaidStart()
	settings.lastevent = time()
	start_time = time()

	if settings.working_in == 0 or not settings.history[settings.working_in] then
		local history = {
			time_start = start_time,
			time_end = time(),
			events = {}
		}
		table.insert(settings.history, history)
		settings.working_in = #settings.history
	end

	if settings.start_event then
		CreateEvent({
			event_type = "raidstart",
			zone = GetRealZoneText(),
			description = settings.start_desc,
			points = settings.start_points,
			timestamp = time(),
		})
	end
	DBM:AddMsg(L.Local_StartRaid)
end

function RaidEnd()
	if settings.working_in == 0 or not settings.history[settings.working_in] then return end
	
	local raid = settings.history[settings.working_in]
	raid.time_end = time()

	DBM:AddMsg(L.Local_RaidSaved)
	start_time = 0
	settings.lastevent = 0
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

do
	local mainframe = CreateFrame("frame", "DBM_DKP_System", UIParent)
	mainframe:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and select(1, ...) == "DBM-RaidLeadTools" then

			mainframe:RegisterEvent("PLAYER_QUITING")

			-- Update settings of this Addon
			settings = DBM_DKP_System_Settings
			addDefaultOptions(settings, default_settings)
		end
	end)
	mainframe:SetScript("OnUpdate", function(self, e)
		if settings.lastevent == 0 then return end

		if time() - settings.lastevent > (settings.time_to_count*60) then
			DBM:AddMsg(L.Local_TimeReached)
			CreateEvent({
				event_type = "",
				zone = GetRealZoneText(),
				description = settings.time_desc,
				points = settings.time_points,
				timestamp = time(),
			})
		end
	end)
	mainframe:RegisterEvent("ADDON_LOADED")
end





