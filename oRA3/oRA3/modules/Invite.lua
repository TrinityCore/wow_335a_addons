local oRA = LibStub("AceAddon-3.0"):GetAddon("oRA3")
local module = oRA:NewModule("Invite", "AceEvent-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("oRA3")
local AceGUI = LibStub("AceGUI-3.0")

module.VERSION = tonumber(("$Revision: 441 $"):sub(12, -3))

local frame = nil
local db = nil
local peopleToInvite = {}
local rankButtons = {}

local function canInvite()
	return (oRA:InGroup() and oRA:IsPromoted()) or not oRA:InGroup()
end

local function showConfig()
	if not frame then module:CreateFrame() end
	oRA:SetAllPointsToPanel(frame.frame, true)
	frame.frame:Show()
end

local function hideConfig()
	if frame then
		frame:ReleaseChildren()
		frame:Release()
		frame = nil
		wipe(rankButtons)
	end
end

local doActualInvites = nil
local actualInviteFrame = CreateFrame("Frame")
local aiTotal = 0
local function _convertToRaid(self, elapsed)
	aiTotal = aiTotal + elapsed
	if aiTotal > 1 then
		aiTotal = 0
		if UnitInRaid("player") then
			doActualInvites()
			self:SetScript("OnUpdate", nil)
		end
	end
end

local function _waitForParty(self, elapsed)
	aiTotal = aiTotal + elapsed
	if aiTotal > 1 then
		aiTotal = 0
		if GetNumPartyMembers() > 0 then
			ConvertToRaid()
			self:SetScript("OnUpdate", _convertToRaid)
		end
	end
end

function doActualInvites()
	if not UnitInRaid("player") then
		local pNum = GetNumPartyMembers() + 1 -- 1-5
		if pNum == 5 then
			if #peopleToInvite > 0 then
				ConvertToRaid()
				actualInviteFrame:SetScript("OnUpdate", _convertToRaid)
			end
		else
			local tmp = {}
			for i = 1, (5 - pNum) do
				local u = table.remove(peopleToInvite)
				if u then tmp[u] = true end
			end
			if #peopleToInvite > 0 then
				actualInviteFrame:SetScript("OnUpdate", _waitForParty)
			end
			for k in pairs(tmp) do
				InviteUnit(k)
			end
		end
		return
	end
	for i, v in next, peopleToInvite do
		InviteUnit(v)
	end
	wipe(peopleToInvite)
end

local function doGuildInvites(level, zone, rank)
	for i = 1, GetNumGuildMembers() do
		local name, _, rankIndex, unitLevel, _, unitZone, _, _, online = GetGuildRosterInfo(i)
		if name and online and not UnitInParty(name) and not UnitInRaid(name) then
			if level and level <= unitLevel then
				peopleToInvite[#peopleToInvite + 1] = name
			elseif zone and zone == unitZone then
				peopleToInvite[#peopleToInvite + 1] = name
			-- See the wowwiki docs for GetGuildRosterInfo, need to add +1 to the rank index
			elseif rank and (rankIndex + 1) <= rank then
				peopleToInvite[#peopleToInvite + 1] = name
			end
		end
	end
	doActualInvites()
end

local inviteFrame = CreateFrame("Frame")
local total = 0
local function onUpdate(self, elapsed)
	total = total + elapsed
	if total > 10 then
		doGuildInvites(self.level, self.zone, self.rank)
		self:SetScript("OnUpdate", nil)
		total = 0
	end
end

local function chat(msg, channel)
	SendChatMessage(msg, channel)
	--print(msg .. "#" .. channel)
end

local function inviteGuild()
	if not canInvite() then return end
	GuildRoster()
	chat((L["All max level characters will be invited to raid in 10 seconds. Please leave your groups."]):format(MAX_PLAYER_LEVEL), "GUILD")
	inviteFrame.level = MAX_PLAYER_LEVEL
	inviteFrame.zone = nil
	inviteFrame.rank = nil
	inviteFrame:SetScript("OnUpdate", onUpdate)
end

local function inviteZone()
	if not canInvite() then return end
	GuildRoster()
	local currentZone = GetRealZoneText()
	chat((L["All characters in %s will be invited to raid in 10 seconds. Please leave your groups."]):format(currentZone), "GUILD")
	inviteFrame.level = nil
	inviteFrame.zone = currentZone
	inviteFrame.rank = nil
	inviteFrame:SetScript("OnUpdate", onUpdate)
end

local function inviteRank(rank, name)
	if not canInvite() then return end
	GuildRoster()
	GuildControlSetRank(rank)
	local _, _, ochat = GuildControlGetRankFlags()
	local channel = ochat and "OFFICER" or "GUILD"
	chat((L["All characters of rank %s or higher will be invited to raid in 10 seconds. Please leave your groups."]):format(name), channel)
	inviteFrame.level = nil
	inviteFrame.zone = nil
	inviteFrame.rank = rank
	inviteFrame:SetScript("OnUpdate", onUpdate)
end

local function inviteRankCommand(input)
	local ranks = oRA:GetGuildRanks()
	local r, n = nil, nil
	for i, rank in next, ranks do
		if rank:lower():find(input) then
			r = i
			n = rank
			break
		end
	end
	if not r or not n then return end
	inviteRank(r, n)
end

function module:OnRegister()
	local database = oRA.db:RegisterNamespace("Invite", {
		global = {
			keyword = nil,
		},
	})
	db = database.global

	oRA:RegisterPanel(
		L["Invite"],
		showConfig,
		hideConfig
	)
	oRA.RegisterCallback(self, "OnGuildRanksUpdate")

	self:RegisterChatCommand("rainv", inviteGuild)
	self:RegisterChatCommand("rainvite", inviteGuild)
	self:RegisterChatCommand("razinv", inviteZone)
	self:RegisterChatCommand("razinvite", inviteZone)
	self:RegisterChatCommand("rarinv", inviteRankCommand)
	self:RegisterChatCommand("rarinvite", inviteRankCommand)
end

local function handleWhisper(event, msg, author)
	if (db.keyword and msg == db.keyword) or (db.guildkeyword and msg == db.guildkeyword and oRA:IsGuildMember(author)) and canInvite() then
		local isIn, instanceType = IsInInstance()
		local party = GetNumPartyMembers()
		local raid = GetNumRaidMembers()
		if isIn and instanceType == "party" and party == 4 then
			SendChatMessage(L["<oRA3> Sorry, the group is full."], "WHISPER", nil, author)
		elseif party == 4 and raid == 0 then
			peopleToInvite[#peopleToInvite + 1] = author
			doActualInvites()
		elseif raid == 40 then
			SendChatMessage(L["<oRA3> Sorry, the group is full."], "WHISPER", nil, author)
		else
			InviteUnit(author)
		end
	end
end

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("CHAT_MSG_WHISPER", handleWhisper)
end

function module:CHAT_MSG_BN_WHISPER(event, msg, author)
	for i = 1, BNGetNumFriends() do
		local _, firstName, lastName, toonName, _, client = BNGetFriendInfo(i)
		if client == BNET_CLIENT_WOW and firstName.." "..lastName == author then
			handleWhisper(event, msg, toonName)
			break
		end
	end
end

local function onControlEnter(widget, event, value)
	if not oRA.db.profile.showHelpTexts then return end
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(widget.frame, "ANCHOR_CURSOR")
	GameTooltip:AddLine(widget.text and widget.text:GetText() or widget.label:GetText())
	GameTooltip:AddLine(widget:GetUserData("tooltip"), 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end

local function updateRankButtons()
	if not frame then return end
	if not IsInGuild() then
		frame:ResumeLayout()
		frame:DoLayout()
		return
	end
	frame:PauseLayout()
	for i, button in next, rankButtons do
		button:Release()
	end
	wipe(rankButtons)
	local ranks = oRA:GetGuildRanks()
	for i = 1, #ranks do
		local rankName = ranks[i]
		local button = AceGUI:Create("Button")
		button:SetText(rankName)
		button:SetUserData("tooltip", L["Invite all guild members of rank %s or higher."]:format(rankName))
		button:SetUserData("rank", i)
		button:SetCallback("OnEnter", onControlEnter)
		button:SetCallback("OnLeave", onControlLeave)
		button:SetCallback("OnClick", function()
			inviteRank(i, rankName)
		end)
		button:SetRelativeWidth(0.33)
		table.insert(rankButtons, button)
		frame:AddChild(button)
	end
	frame:ResumeLayout()
	frame:DoLayout()
end

function module:OnGuildRanksUpdate(event, ranks)
	updateRankButtons()
end

local function saveKeyword(widget, event, value)
	if type(value) == "string" and value:trim():len() < 2 then value = nil end
	local key = widget:GetUserData("key")
	db[key] = value
	widget:SetText(value)
end

function module:CreateFrame()
	if frame then return end
	local inGuild = IsInGuild()
	frame = AceGUI:Create("ScrollFrame")
	frame:PauseLayout()
	frame:SetLayout("Flow")

	local kwDescription = AceGUI:Create("Label")
	kwDescription:SetText(L["When people whisper you the keywords below, they will automatically be invited to your group. If you're in a party and it's full, you will convert to a raid group. The keywords will only stop working when you have a full raid of 40 people. Setting a keyword to nothing will disable it."])
	kwDescription:SetFullWidth(true)
	kwDescription:SetFontObject(GameFontHighlight)

	local keyword = AceGUI:Create("EditBox")
	keyword:SetLabel(L["Keyword"])
	keyword:SetText(db.keyword)
	keyword:SetUserData("key", "keyword")
	keyword:SetUserData("tooltip", L["Anyone who whispers you this keyword will automatically and immediately be invited to your group."])
	keyword:SetCallback("OnEnter", onControlEnter)
	keyword:SetCallback("OnLeave", onControlLeave)
	keyword:SetCallback("OnEnterPressed", saveKeyword)
	keyword:SetRelativeWidth(0.5)
	
	local guildonlykeyword = AceGUI:Create("EditBox")
	guildonlykeyword:SetLabel(L["Guild Keyword"])
	guildonlykeyword:SetText(db.guildkeyword)
	guildonlykeyword:SetUserData("key", "guildkeyword")
	guildonlykeyword:SetUserData("tooltip", L["Any guild member who whispers you this keyword will automatically and immediately be invited to your group."])
	guildonlykeyword:SetCallback("OnEnter", onControlEnter)
	guildonlykeyword:SetCallback("OnLeave", onControlLeave)
	guildonlykeyword:SetCallback("OnEnterPressed", saveKeyword)
	guildonlykeyword:SetRelativeWidth(0.5)
	
	local guild, zone, rankHeader, rankDescription
	if inGuild then
		guild = AceGUI:Create("Button")
		guild:SetText(L["Invite guild"])
		guild:SetUserData("tooltip", L["Invite everyone in your guild at the maximum level."])
		guild:SetCallback("OnEnter", onControlEnter)
		guild:SetCallback("OnLeave", onControlLeave)
		guild:SetCallback("OnClick", inviteGuild)
		-- Default height is 24, per AceGUIWidget-Button.lua
		-- FIXME: Jesus christ that looks crappy, buttons apparently only have 3 textures,
		-- left, middle and right, so making it higher actually stretches the texture.
		--guild:SetHeight(24 * 2)
		guild:SetFullWidth(true)
	
		zone = AceGUI:Create("Button")
		zone:SetText(L["Invite zone"])
		zone:SetUserData("tooltip", L["Invite everyone in your guild who are in the same zone as you."])
		zone:SetCallback("OnEnter", onControlEnter)
		zone:SetCallback("OnLeave", onControlLeave)
		zone:SetCallback("OnClick", inviteZone)
		zone:SetFullWidth(true)

		rankHeader = AceGUI:Create("Heading")
		rankHeader:SetText(L["Guild rank invites"])
		rankHeader:SetFullWidth(true)
	
		rankDescription = AceGUI:Create("Label")
		rankDescription:SetText(L["Clicking any of the buttons below will invite anyone of the selected rank AND HIGHER to your group. So clicking the 3rd button will invite anyone of rank 1, 2 or 3, for example. It will first post a message in either guild or officer chat and give your guild members 10 seconds to leave their groups before doing the actual invites."])
		rankDescription:SetFullWidth(true)
		rankDescription:SetFontObject(GameFontHighlight)
	end

	if inGuild then
		if oRA.db.profile.showHelpTexts then
			frame:AddChildren(guild, zone, kwDescription, keyword, guildonlykeyword, rankHeader, rankDescription)
		else
			frame:AddChildren(guild, zone, keyword, guildonlykeyword, rankHeader)
		end
	else
		if oRA.db.profile.showHelpTexts then
			frame:AddChildren(kwDescription, keyword)
		else
			frame:AddChild(keyword)
		end
	end

	-- updateRankButtons will ResumeLayout and DoLayout
	updateRankButtons()
end

