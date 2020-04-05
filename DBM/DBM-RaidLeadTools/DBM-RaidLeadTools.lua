-- **********************************************************
-- **                Deadly Boss Mods - GUI                **
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

local Revision = ("$Revision: 101 $"):sub(12, -3)

local L = DBM_Raidlead_Translation

DBM_RaidLead_Settings = {}
local default_settings = {
	WarnWhenNoLootmaster = false,
	StickyIcons = false,
	IconUpdateTime = 1
}
local settings = default_settings

local mainframe = CreateFrame("Frame", "DBM_Raidleadtool", UIParent)

local function createpanel()
	if GetLocale() ~= "zhTW" then
		DBM_RaidLeadPanel = DBM_GUI:CreateNewPanel("Raidlead Tools - r"..Revision, "option")
	else
		DBM_RaidLeadPanel = DBM_GUI:CreateNewPanel("團隊隊長工具 - r"..Revision, "option")
	end

	local area = DBM_RaidLeadPanel:CreateArea(L.Area_Raidleadtool, nil, 180, true)

	local warnLootMaster = area:CreateCheckButton(L.ShowWarningForLootMaster, true)
	warnLootMaster:SetScript("OnShow", function(self) self:SetChecked(settings.WarnWhenNoLootmaster) end)
	warnLootMaster:SetScript("OnClick", function(self)
		settings.WarnWhenNoLootmaster = not not self:GetChecked()
	end)

	local StickyIcons = area:CreateCheckButton(L.StickyIcons, true)
	StickyIcons:SetScript("OnShow", function(self) self:SetChecked(settings.StickyIcons) end)
	StickyIcons:SetScript("OnClick", function(self)
		settings.StickyIcons = not not self:GetChecked()
	end)
end

do 
	-- StickyIcon Stuff
	local is_active = false
	local function combat_end()	is_active = false end

	local raidicons = {}
	local function scanIcons()				-- create a list of Icons used when combat starts
		table.wipe(raidicons)
		if GetNumRaidMembers() >= 1 then
			for i = 1, GetNumRaidMembers() do
				local icon = GetRaidTargetIndex("raid"..i)
				if icon then
					raidicons[icon] = "raid"..i
				end
			end
			is_active = true
		end
	end

	local icons_used = {}
	local function resetIcons()
		table.wipe(icons_used)				-- create a list of currently used icons
		if GetNumRaidMembers() >= 1 then
			for i = 1, GetNumRaidMembers() do
				local icon = GetRaidTargetIndex("raid"..i)
				if icon then
					icons_used[icon] = "raid"..i
				end
			end
		end
		for i, v in pairs(raidicons) do
			if not icons_used[i] and not GetRaidTargetIndex(v) then		-- only reSet icon when not in use and currently non present
				SetRaidTarget(v, i)
			end
		end
	end

	do
		local TimeSinceLastUpdate = 0
		local function updater(self, elapsed, ...)
			if is_active then
				TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
				if TimeSinceLastUpdate > settings.IconUpdateTime then
					TimeSinceLastUpdate = TimeSinceLastUpdate - settings.IconUpdateTime
		
					resetIcons()
				end
			end
		end
		mainframe:SetScript("OnUpdate", updater)
	end
	

	local function addDefaultOptions(t1, t2)
		for i, v in pairs(t2) do
			if t1[i] == nil then
				t1[i] = v
			elseif type(v) == "table" then
				addDefaultOptions(v, t2[i])
			end
		end
	end
	mainframe:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and select(1, ...) == "DBM-RaidLeadTools" then
			-- Update settings of this Addon
			settings = DBM_RaidLead_Settings
			addDefaultOptions(settings, default_settings)

			-- StickyIcons
			DBM:RegisterCallback("pull", scanIcons)
			DBM:RegisterCallback("wipe", combat_end)
			DBM:RegisterCallback("kill", combat_end)

			-- WarnforLootmaster
			DBM:RegisterCallback("pull", function()
				if DBM_BidBot_Translations.WarnWhenNoLootmaster and GetLootMethod() ~= "master" then
					DBM:AddMsg(L.Warning_NoLootMaster)
				end
			end)			
		end
	end)
	mainframe:RegisterEvent("ADDON_LOADED")
end

DBM:RegisterOnGuiLoadCallback(createpanel, 10)

