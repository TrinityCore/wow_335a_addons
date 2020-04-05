local oRA = LibStub("AceAddon-3.0"):GetAddon("oRA3")
local module = oRA:NewModule("ReadyCheck", "AceEvent-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("oRA3")

module.VERSION = tonumber(("$Revision: 417 $"):sub(12, -3))

local readycheck = {} -- table containing ready check results
local frame -- will be filled with our GUI frame

local readyAuthor = nil -- author of the current readycheck
local playerName = UnitName("player")
local topMemberFrames, bottomMemberFrames = {}, {} -- ready check member frames

-- local constants
local RD_RAID_MEMBERS_NOTREADY = L["The following players are not ready: %s"]
local RD_READY_CHECK_OVER_IN = L["Ready Check (%d seconds)"]
local RD_READY = L["Ready"]
local RD_NOTREADY = L["Not Ready"]
local RD_NORESPONSE = L["No Response"]
local RD_OFFLINE = L["Offline"]

local defaults = {
	profile = {
		sound = true,
		gui = true,
		autohide = true,
		hideReady = false,
	}
}

local options
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = READY_CHECK,
			get = function(k) return module.db.profile[k[#k]] end,
			set = function(k, v) module.db.profile[k[#k]] = v end,
			args = {
				sound = {
					type = "toggle",
					name = SOUND_LABEL,
					desc = L["Play a sound when a ready check is performed."],
					width = "full",
					order = 1,
				},
				gui = {
					type = "toggle",
					name = L["Show window"],
					desc = L["Show the window when a ready check is performed."],
					width = "full",
					order = 2,
				},
				autohide = {
					type = "toggle",
					name = L["Hide window when done"],
					desc = L["Automatically hide the window when the ready check is finished."],
					width = "full",
					order = 3,
				},
				hideReady = {
					type = "toggle",
					name = L["Hide players who are ready"],
					desc = L["Hide players that are marked as ready from the window."],
					width = "full",
					order = 4,
				},
			}
		}
	end
	return options
end

local function addIconAndName(frame)
	local rdc = frame:CreateTexture(nil, "OVERLAY")
	frame.IconTexture = rdc
	rdc:SetWidth(11)
	rdc:SetHeight(11)
	rdc:SetPoint("LEFT", frame)

	local rdt = frame:CreateFontString(nil, "OVERLAY")
	frame.NameText = rdt
	rdt:SetJustifyH("LEFT")
	rdt:SetFontObject(GameFontNormal)
	rdt:SetPoint("LEFT", rdc, "RIGHT", 3)
	rdt:SetHeight(14)
	rdt:SetWidth(120)

	local bg = frame:CreateTexture(nil, "ARTWORK")
	bg:SetTexture(1, 0, 0, 0.3)
	bg:SetAllPoints(rdt)
	frame.bg = bg
	bg:Hide()
end

local function createTopFrame()
	local f = CreateFrame("Frame", nil, frame)
	table.insert(topMemberFrames, f)
	local num = #topMemberFrames
	local xoff = 15
	local yoff = -17
	if num % 2 == 0 then xoff = 160 end
	yoff = yoff + ((math.floor(num / 2) + (num % 2)) * -14)
	f:SetWidth(150)
	f:SetHeight(14)
	f:SetPoint("TOPLEFT", frame, "TOPLEFT", xoff, yoff)
	addIconAndName(f)
	return f
end

local function createBottomFrame()
	local f = CreateFrame("Frame", nil, frame)
	table.insert(bottomMemberFrames, f)
	local num = #bottomMemberFrames
	local xoff = 7
	local yoff = 5
	if num % 2 == 0 then xoff = 160 end
	yoff = yoff + ((math.floor(num / 2) + (num % 2)) * -14)
	f:SetWidth(150)
	f:SetHeight(14)
	f:SetPoint("TOPLEFT", frame.bar, "TOPLEFT", xoff, yoff)
	addIconAndName(f)
	return f
end

local function setMemberStatus(num, bottom, name, class)
	local f
	if bottom then
		f = bottomMemberFrames[num] or createBottomFrame()
	else
		f = topMemberFrames[num] or createTopFrame()
	end
	local color = RAID_CLASS_COLORS[class]
	f.NameText:SetText(name)
	f.NameText:SetTextColor(color.r, color.g, color.b)
	f:SetAlpha(1)
	f:Show()
	if readycheck[name] == RD_READY then
		f.bg:Hide()
		f.IconTexture:SetTexture(READY_CHECK_READY_TEXTURE)
		if module.db.profile.hideReady then
			f:Hide()
		end
	elseif readycheck[name] == RD_NOTREADY then
		f.bg:Show()
		f.IconTexture:SetTexture(READY_CHECK_NOT_READY_TEXTURE)
	elseif readycheck[name] == RD_OFFLINE then
		f:SetAlpha(.5)
		f.bg:Show()
		f.IconTexture:SetTexture(READY_CHECK_AFK_TEXTURE)
	else
		f.bg:Show()
		f.IconTexture:SetTexture(READY_CHECK_WAITING_TEXTURE)
	end
end

local function updateWindow()
	for i, v in next, topMemberFrames do v:Hide() end
	for i, v in next, bottomMemberFrames do v:Hide() end

	frame.bar:Hide()

	local total = 0
	if oRA:InRaid() then
		local diff = GetInstanceDifficulty()
		local highgroup = 8 -- 40 man it
		if diff and diff == 1 then -- normal
			highgroup = 2
		elseif diff and diff == 2 then -- heroic
			highgroup = 5
		end

		local bottom, top = 0, 0
		for i = 1, GetNumRaidMembers() do
			local rname, _, subgroup, _, _, fileName = GetRaidRosterInfo(i)
			if rname then
				if subgroup > highgroup then
					bottom = bottom + 1
					setMemberStatus(bottom, true, rname, fileName)
				else
					top = top + 1
					setMemberStatus(top, false, rname, fileName)
				end
			end
		end
		total = bottom + top / 2

		-- position the spacer
		local yoff = ((math.ceil(top / 2) * 14) + 37) * -1
		frame.bar:ClearAllPoints()
		frame.bar:SetPoint("TOPLEFT", frame, 8, yoff)
		frame.bar:SetPoint("TOPRIGHT", frame, -6, yoff)

		if bottom > 0 then
			frame.bar:Show()
		end
	else
		total = 1
		setMemberStatus(total, false, playerName, select(2, UnitClass("player")))
		for i = 1, MAX_PARTY_MEMBERS do
			if GetPartyMember(i) then
				total = total + 1
				setMemberStatus(total, false, UnitName("party"..i), select(2,UnitClass("party"..i)) )
			end
		end
	end

	local height = math.max((total * 14) + 66, 128)
	frame:SetHeight(height)
end

local function createWindow()
	if frame then return end
	frame = CreateFrame("Frame", "oRA3ReadyCheck", UIParent)

	local f = frame
	f:SetWidth(320)
	f:SetHeight(300)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	if not oRA3:RestorePosition("oRA3ReadyCheck") then
		f:ClearAllPoints()
		f:SetPoint("CENTER", UIParent, 0, 180)
	end

	local titlebg = f:CreateTexture(nil, "BACKGROUND")
	titlebg:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Title-Background]])
	titlebg:SetPoint("TOPLEFT", 9, -6)
	titlebg:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -28, -24)
	
	local dialogbg = f:CreateTexture(nil, "BACKGROUND")
	dialogbg:SetTexture([[Interface\Tooltips\UI-Tooltip-Background]])
	dialogbg:SetPoint("TOPLEFT", 8, -24)
	dialogbg:SetPoint("BOTTOMRIGHT", -6, 8)
	dialogbg:SetVertexColor(0, 0, 0, .75)
	
	local topleft = f:CreateTexture(nil, "BORDER")
	topleft:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	topleft:SetWidth(64)
	topleft:SetHeight(64)
	topleft:SetPoint("TOPLEFT")
	topleft:SetTexCoord(0.501953125, 0.625, 0, 1)
	
	local topright = f:CreateTexture(nil, "BORDER")
	topright:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	topright:SetWidth(64)
	topright:SetHeight(64)
	topright:SetPoint("TOPRIGHT")
	topright:SetTexCoord(0.625, 0.75, 0, 1)
	
	local top = f:CreateTexture(nil, "BORDER")
	top:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	top:SetHeight(64)
	top:SetPoint("TOPLEFT", topleft, "TOPRIGHT")
	top:SetPoint("TOPRIGHT", topright, "TOPLEFT")
	top:SetTexCoord(0.25, 0.369140625, 0, 1)
	
	local bottomleft = f:CreateTexture(nil, "BORDER")
	bottomleft:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	bottomleft:SetWidth(64)
	bottomleft:SetHeight(64)
	bottomleft:SetPoint("BOTTOMLEFT")
	bottomleft:SetTexCoord(0.751953125, 0.875, 0, 1)
	
	local bottomright = f:CreateTexture(nil, "BORDER")
	bottomright:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	bottomright:SetWidth(64)
	bottomright:SetHeight(64)
	bottomright:SetPoint("BOTTOMRIGHT")
	bottomright:SetTexCoord(0.875, 1, 0, 1)
	
	local bottom = f:CreateTexture(nil, "BORDER")
	bottom:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	bottom:SetHeight(64)
	bottom:SetPoint("BOTTOMLEFT", bottomleft, "BOTTOMRIGHT")
	bottom:SetPoint("BOTTOMRIGHT", bottomright, "BOTTOMLEFT")
	bottom:SetTexCoord(0.376953125, 0.498046875, 0, 1)
	
	local left = f:CreateTexture(nil, "BORDER")
	left:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	left:SetWidth(64)
	left:SetPoint("TOPLEFT", topleft, "BOTTOMLEFT")
	left:SetPoint("BOTTOMLEFT", bottomleft, "TOPLEFT")
	left:SetTexCoord(0.001953125, 0.125, 0, 1)
	
	local right = f:CreateTexture(nil, "BORDER")
	right:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	right:SetWidth(64)
	right:SetPoint("TOPRIGHT", topright, "BOTTOMRIGHT")
	right:SetPoint("BOTTOMRIGHT", bottomright, "TOPRIGHT")
	right:SetTexCoord(0.1171875, 0.2421875, 0, 1)
	
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 1)
	close:SetScript("OnClick", function(self, button) f:Hide() end)
	
	local title = f:CreateFontString(nil, "ARTWORK")
	title:SetFontObject(GameFontNormal)
	title:SetPoint("TOPLEFT", 12, -8)
	title:SetPoint("TOPRIGHT", -32, -8)
	title:SetText(READY_CHECK)
	f.title = title
	
	local titlebutton = CreateFrame("Button", nil, f)
	titlebutton:SetPoint("TOPLEFT", titlebg)
	titlebutton:SetPoint("BOTTOMRIGHT", titlebg)
	titlebutton:RegisterForDrag("LeftButton")
	titlebutton:SetScript("OnDragStart", function()
		f.moving = true
		f:StartMoving()
	end)
	titlebutton:SetScript("OnDragStop", function()
		f.moving = nil
		f:StopMovingOrSizing()
		oRA3:SavePosition("oRA3ReadyCheck")
	end)

	local bar = CreateFrame("Button", nil, frame)
	frame.bar = bar
	bar:SetPoint("TOPLEFT", frame, 8, -150)
	bar:SetPoint("TOPRIGHT", frame, -6, -150)
	bar:SetHeight(8)

	local barmiddle = bar:CreateTexture(nil, "BORDER")
	barmiddle:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar")
	barmiddle:SetAllPoints(bar)
	barmiddle:SetTexCoord(0.29296875, 1, 0, 0.25)

	frame:SetScript("OnUpdate", function(self, elapsed)
		if self.timer and self.timer > 0 then
			self.timer = self.timer - elapsed
			if self.oldtimer - self.timer >= 1 or self.oldtimer == -1 then
				self.oldtimer = self.timer
				title:SetText(RD_READY_CHECK_OVER_IN:format(floor(self.timer)))
			end
		end
		if self.fadeTimer and self.fadeTimer > 0 then
			self.fadeTimer = self.fadeTimer - elapsed
			if self.fadeTimer <= 0 then
				self:SetAlpha(1) -- reset
				self.fadeTimer = nil -- reset
				self:Hide()
			else
				self:SetAlpha(self.fadeTimer)
			end
		end
	end)
end

function module:OnRegister()
	self.db = oRA.db:RegisterNamespace("ReadyCheck", defaults)
	oRA:RegisterModuleOptions("ReadyCheck", getOptions, READY_CHECK)
end

function module:OnEnable()
	-- Ready Check Events
	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("READY_CHECK_CONFIRM")
	self:RegisterEvent("READY_CHECK_FINISHED")

	self:RegisterChatCommand("rar", DoReadyCheck)
	self:RegisterChatCommand("raready", DoReadyCheck)
end

function module:READY_CHECK(event, name, duration)
	if self.db.profile.sound then PlaySoundFile("Sound\\interface\\levelup2.wav") end
	if not oRA:IsPromoted() then return end

	wipe(readycheck)
	-- fill with default 'no response' 
	if oRA:InRaid() then
		for i = 1, GetNumRaidMembers() do
			local rname, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			readycheck[rname] = online and RD_NORESPONSE or RD_OFFLINE
		end
	else
		readycheck[playerName] = -1
		for i = 1, MAX_PARTY_MEMBERS do
			if GetPartyMember(i) then
				readycheck[UnitName("party"..i)] = RD_NORESPONSE
			end
		end
	end
	readycheck[name] = RD_READY -- the sender is always ready
	readyAuthor = name

	-- show the readycheck result frame
	if self.db.profile.gui then
		createWindow()
		frame:SetAlpha(1) -- if we happen to have a readycheck while we're hiding
		frame.fadeTimer = nil -- if we happend to have a readycheck while we're hiding
		frame:Show()
		frame.timer = duration
		frame.oldtimer = -1
		updateWindow()
	end
end

function module:READY_CHECK_CONFIRM(event, id, confirm)
	-- this event only fires when promoted, no need to check
	--oRA:Print(event, id, confirm)
	local name = UnitName(id)
	if confirm then -- ready
		readycheck[name] = RD_READY
	elseif readycheck[name] ~= RD_OFFLINE then -- not ready, ignore offline
		readycheck[name] = RD_NOTREADY
	end
	if self.db.profile.gui and frame then
		updateWindow()
	end
end

local function sysPrint(msg)
	local c = ChatTypeInfo["SYSTEM"]
	DEFAULT_CHAT_FRAME:AddMessage(msg, c.r, c.g, c.b, c.id)
end

function module:READY_CHECK_FINISHED(event, someBoolean)
	-- This seems to be true in 5mans and false in raids, no matter what people actually click.
	if someBoolean then return end
	if not oRA:IsPromoted() then return end

	if frame then
		if self.db.profile.autohide then frame.fadeTimer = 1 end
		frame.timer = 0
		frame.title:SetText(READY_CHECK_FINISHED)
	end

	local noReply = {}
	local notReady = {}
	for name, ready in pairs(readycheck) do
		if ready == RD_NORESPONSE then
			noReply[#noReply + 1] = name
		elseif ready == RD_NOTREADY then
			notReady[#notReady + 1] = name
		end
	end

	-- mimic true readycheck results for assistants/leader that did not start the readycheck
	if readyAuthor ~= playerName then
		sysPrint(READY_CHECK_FINISHED)

		if #noReply > 0 then
			sysPrint(RAID_MEMBERS_AFK:format(table.concat(noReply, ", ")))
		elseif #notReady == 0 and #noReply == 0 then
			sysPrint(READY_CHECK_ALL_READY)
		elseif #noReply == 0 then
			sysPrint(READY_CHECK_NO_AFK)
		end
	end

	if #notReady > 0 then
		sysPrint(RD_RAID_MEMBERS_NOTREADY:format(table.concat(notReady, ", ")))
	end
end

