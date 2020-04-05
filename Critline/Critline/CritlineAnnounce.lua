local L = LibStub("AceLocale-3.0"):GetLocale("Critline")
local module

local _, addon = ...


addon.announce = addon.templates:CreateList("CritlineAnnounce")
module = addon.announce
module:SetScript("OnShow", function(self)
	self.target:SetAutoFocus(false)
	self.target:Hide()
	self:ChannelInitialize()
	UIDropDownMenu_SetSelectedValue(self.channel, 14)
end)
module.button:SetText(CHAT_ANNOUNCE)
module.button:SetScript("OnClick", function()
	PlaySound("gsTitleOptionOK")
	module:Announce()
end)

-- this table will hold info about spells selected in the check list
module.selectedSpells = {}

module.name = CHAT_ANNOUNCE
module.parent = "Critline"
InterfaceOptions_AddCategory(module)

local channel = CreateFrame("Frame", "CritlineAnnounceChannel", module, "UIDropDownMenuTemplate")
channel:SetPoint("TOPLEFT", module.tree, "BOTTOMLEFT")
module.channel = channel

local target = CreateFrame("EditBox", nil, module)
target:SetSize(144, 32)
target:SetPoint("LEFT", channel, "RIGHT", 0, 2)
target:SetFontObject("ChatFontNormal")
target:Hide()
target:SetScript("OnEscapePressed", target.Hide)
target:SetScript("OnEnterPressed", function() module:Announce() end)
module.target = target

local leftTex = target:CreateTexture("BACKGROUND")
leftTex:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Left")
leftTex:SetSize(128, 32)
leftTex:SetPoint("LEFT")

local rightTex = target:CreateTexture("BACKGROUND")
rightTex:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Right")
rightTex:SetTexCoord(0.9375, 1, 0, 1)
rightTex:SetSize(16, 32)
rightTex:SetPoint("RIGHT")


local channels = {
	[11] = "GUILD",
	[12] = "PARTY",
	[13] = "RAID",
	[14] = "SAY",
	[15] = "WHISPER",
}


do
	local function onClick(self)
		UIDropDownMenu_SetSelectedValue(channel, self.value)
		if self.value == 15 then
			target:Show()
			target:SetFocus()
		else
			target:Hide()
		end
	end

	local info = {}

	function module:CreateChannel(channelID, channelName)
		wipe(info)
		info.text = channelName
		info.value = channelID
		info.func = onClick
		UIDropDownMenu_AddButton(info)
	end
end


function module:Announce()
	local channelID = UIDropDownMenu_GetSelectedValue(channel)
	local selectedTree = UIDropDownMenu_GetSelectedValue(self.tree)
	local channel = channels[channelID]
	
	if channel then
		if channelID == 15 then
			channelID = target:GetText()
			if #channelID == 0 then
				addon:Message(L["Invalid player name."])
				return
			end
		end
	else
		channel = "CHANNEL"
	end
	
	for i in pairs(self.selectedSpells) do
		local data = CritlineDB[selectedTree][i]
		local normal = data.normal and data.normal.amount
		local crit = data.crit and data.crit.amount
		SendChatMessage(format("%s - %s: %s %s: %s", addon:GetFullSpellName(selectedTree, data.spellName, data.isPeriodic), L["Normal"], (normal or "n/a"), L["Crit"], (crit or "n/a")), channel, nil, channelID)
	end
	
	wipe(self.selectedSpells)
	
	self:Update()
	target:SetText("")
end


-- get available channels to populate dropdown with
function module:LoadChannels()
	if IsInGuild() then
		module:CreateChannel(11, GUILD)
	end
	if GetNumPartyMembers() > 0 then
		module:CreateChannel(12, PARTY)
	end
	if GetNumRaidMembers() > 0 then
		module:CreateChannel(13, RAID)
	end
	
	module:CreateChannel(14, SAY)
	module:CreateChannel(15, WHISPER)
	
	for i = 1, 10 do
		local id, name = select((i * 2 - 1), GetChannelList())
		if id then
			module:CreateChannel(id, name)
		end
	end
end


function module:ChannelInitialize()
	UIDropDownMenu_Initialize(channel, module.LoadChannels)
	UIDropDownMenu_SetWidth(channel, 120)
end