--------------------------------------------------------------------------------
-- Setup
--

local oRA = LibStub("AceAddon-3.0"):GetAddon("oRA3")
local util = oRA.util
local module = oRA:NewModule("Promote", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("oRA3")
local AceGUI = LibStub("AceGUI-3.0")

module.VERSION = tonumber(("$Revision: 435 $"):sub(12, -3))

--------------------------------------------------------------------------------
-- Locals
--

local guildRankDb = nil
local factionDb = nil
local queuePromotes = nil
local dontPromoteThisSession = {}

--------------------------------------------------------------------------------
-- GUI
--

local demoteButton = nil
local function updateDemoteButton()
	if not demoteButton then return end
	if IsRaidLeader() then
		demoteButton:SetDisabled(false)
	else
		demoteButton:SetDisabled(true)
	end
end

local ranks, showPane, hidePane
do
	local frame = nil
	-- Widgets (in order of appearance)
	local everyone, guild, add, delete

	local function onControlEnter(widget, event, value)
		if not oRA.db.profile.showHelpTexts then return end
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(widget.frame, "ANCHOR_CURSOR")
		GameTooltip:AddLine(widget.text:GetText())
		GameTooltip:AddLine(widget:GetUserData("tooltip"), 1, 1, 1, 1)
		GameTooltip:Show()
	end
	local function onControlLeave() GameTooltip:Hide() end

	local function everyoneCallback(widget, event, value)
		if guild then
			guild:SetDisabled(value)
			ranks:SetDisabled(value or factionDb.promoteGuild)
		end
		add:SetDisabled(value)
		delete:SetDisabled(value or #factionDb.promotes < 1)
		factionDb.promoteAll = value and true or false
		queuePromotes()
	end

	local function guildCallback(widget, event, value)
		ranks:SetDisabled(value)
		factionDb.promoteGuild = value and true or false
		queuePromotes()
	end

	local function ranksCallback(widget, event, rankIndex, value)
		guildRankDb[rankIndex] = value and true or nil
		queuePromotes()
	end

	local function addCallback(widget, event, value)
		if type(value) ~= "string" or value:trim():len() < 3 then return true end
		if util:inTable(factionDb.promotes, value) then return true end
		table.insert(factionDb.promotes, value)
		add:SetText()
		delete:SetList(factionDb.promotes)
		delete:SetDisabled(factionDb.promoteAll or #factionDb.promotes < 1)
		queuePromotes()
	end

	local function deleteCallback(widget, event, value)
		table.remove(factionDb.promotes, value)
		delete:SetList(factionDb.promotes)
		delete:SetValue("")
		delete:SetDisabled(factionDb.promoteAll or #factionDb.promotes < 1)
	end

	local function demoteRaid()
		if not IsRaidLeader() then return end
		for i = 1, GetNumRaidMembers() do
			local n, rank = GetRaidRosterInfo(i)
			if n and rank == 1 then
				DemoteAssistant(n)
			end
		end
	end

	local function createFrame()
		if frame then return end
		frame = AceGUI:Create("ScrollFrame")
		frame:SetLayout("List")

		local spacer = AceGUI:Create("Label")
		spacer:SetText(" ")

		demoteButton = AceGUI:Create("Button")
		demoteButton:SetText(L["Demote everyone"])
		demoteButton:SetUserData("tooltip", L["Demotes everyone in the current group."])
		demoteButton:SetCallback("OnEnter", onControlEnter)
		demoteButton:SetCallback("OnLeave", onControlLeave)
		demoteButton:SetCallback("OnClick", demoteRaid)
		demoteButton:SetFullWidth(true)
		updateDemoteButton()

		local massHeader = AceGUI:Create("Heading")
		massHeader:SetText(L["Mass promotion"])
		massHeader:SetFullWidth(true)

		everyone = AceGUI:Create("CheckBox")
		everyone:SetValue(factionDb.promoteAll)
		everyone:SetLabel(L["Everyone"])
		everyone:SetCallback("OnEnter", onControlEnter)
		everyone:SetCallback("OnLeave", onControlLeave)
		everyone:SetCallback("OnValueChanged", everyoneCallback)
		everyone:SetUserData("tooltip", L["Promote everyone automatically."])
		everyone:SetFullWidth(true)

		if guildRankDb then
			guild = AceGUI:Create("CheckBox")
			guild:SetValue(factionDb.promoteGuild)
			guild:SetLabel(L["Guild"])
			guild:SetCallback("OnEnter", onControlEnter)
			guild:SetCallback("OnLeave", onControlLeave)
			guild:SetCallback("OnValueChanged", guildCallback)
			guild:SetUserData("tooltip", L["Promote all guild members automatically."])
			guild:SetDisabled(factionDb.promoteAll)
			guild:SetFullWidth(true)

			ranks = AceGUI:Create("Dropdown")
			ranks:SetMultiselect(true)
			ranks:SetLabel(L["By guild rank"])
			ranks:SetList(oRA:GetGuildRanks())
			ranks:SetCallback("OnValueChanged", ranksCallback)
			ranks:SetDisabled(factionDb.promoteAll or factionDb.promoteGuild)
			ranks:SetFullWidth(true)

			local guildRanks = oRA:GetGuildRanks()
			ranks:SetList(guildRanks)
			for i, v in next, guildRanks do
				ranks:SetItemValue(i, guildRankDb[i])
			end
		end

		local individualHeader = AceGUI:Create("Heading")
		individualHeader:SetText(L["Individual promotions"])
		individualHeader:SetFullWidth(true)

		local description = AceGUI:Create("Label")
		description:SetText(L["Note that names are case sensitive. To add a player, enter a player name in the box below and hit Enter or click the button that pops up. To remove a player from being promoted automatically, just click his name in the dropdown below."])
		description:SetFontObject(GameFontHighlight)
		description:SetFullWidth(true)

		add = AceGUI:Create("EditBox")
		add:SetLabel(L["Add"])
		add:SetText()
		add:SetCallback("OnEnterPressed", addCallback)
		add:SetDisabled(factionDb.promoteAll)
		add:SetFullWidth(true)

		delete = AceGUI:Create("Dropdown")
		delete:SetValue("")
		delete:SetLabel(L["Remove"])
		delete:SetList(factionDb.promotes)
		delete:SetCallback("OnValueChanged", deleteCallback)
		delete:SetDisabled(factionDb.promoteAll or #factionDb.promotes < 1)
		delete:SetFullWidth(true)

		if guildRankDb then
			if oRA.db.profile.showHelpTexts then
				frame:AddChildren(demoteButton, massHeader, everyone, guild, ranks, spacer, individualHeader, description, add, delete)
			else
				frame:AddChildren(demoteButton, massHeader, everyone, guild, ranks, spacer, individualHeader, add, delete)
			end
		else
			if oRA.db.profile.showHelpTexts then 
				frame:AddChildren(demoteButton, massHeader, everyone, spacer, individualHeader, description, add, delete)
			else
				frame:AddChildren(demoteButton, massHeader, everyone, spacer, individualHeader, add, delete)
			end
		end
	end

	function showPane()
		if not frame then createFrame() end
		oRA:SetAllPointsToPanel(frame.frame, true)
		frame.frame:Show()
	end

	function hidePane()
		if frame then
			frame:Release()
			frame = nil
		end
	end
end

--------------------------------------------------------------------------------
-- Module
--

function module:OnRegister()
	local database = oRA.db:RegisterNamespace("Promote", {
		factionrealm = {
			promotes = {},
			promoteAll = nil,
			promoteGuild = nil,
			promoteRank = {
				['*'] = {},
			},
		},
	})
	factionDb = database.factionrealm
	
	oRA:RegisterPanel(
		L["Promote"],
		showPane,
		hidePane
	)
	oRA.RegisterCallback(self, "OnGroupChanged")
	oRA.RegisterCallback(self, "OnGuildRanksUpdate")
	oRA.RegisterCallback(self, "OnPromoted")
end

do
	local function shouldPromote(name)
		if dontPromoteThisSession[name] then return false end
		local gML = oRA:GetGuildMembers()
		if factionDb.promoteAll then return true
		elseif factionDb.promoteGuild and gML[name] then return true
		elseif gML[name] and guildRankDb[gML[name]] then return true
		elseif util:inTable(factionDb.promotes, name) then return true
		end
	end

	local promotes = {}

	local f = CreateFrame("Frame")
	f:Hide()
	local total = 0
	f:SetScript("OnHide", function() total = 0 end)
	f:SetScript("OnUpdate", function(self, elapsed)
		total = total + elapsed
		if total < 2 then return end
		for k in pairs(promotes) do
			PromoteToAssistant(k)
			promotes[k] = nil
		end
		f:Hide()
	end)
	function queuePromotes()
		if f:IsShown() then f:Hide() end
		if not IsRaidLeader() then return end
		for i = 1, GetNumRaidMembers() do
			local n, r = GetRaidRosterInfo(i)
			if n and r == 0 and shouldPromote(n) then
				promotes[n] = true
			end
		end
		if next(promotes) then
			f:Show()
		end
	end
	function module:OnGroupChanged(event, status, members)
		updateDemoteButton()
		if #members > 0 then
			queuePromotes()
		end
	end
	function module:OnPromoted()
		updateDemoteButton()
		queuePromotes()
	end

	function module:OnEnable()
		self:OnGuildRanksUpdate(nil, oRA:GetGuildRanks())
		self:RegisterEvent("GUILD_ROSTER_UPDATE")
		self:SecureHook("DemoteAssistant", function(player)
			dontPromoteThisSession[player] = true
		end)
	end
end

function module:GUILD_ROSTER_UPDATE()
	if IsInGuild() then
		local guildName = GetGuildInfo("player")
		guildRankDb = factionDb.promoteRank[guildName]
	end
end

function module:OnGuildRanksUpdate(event, r)
	if ranks then
		ranks:SetList(r)
		for i, v in next, r do
			ranks:SetItemValue(i, guildRankDb[i])
		end
	end
end

