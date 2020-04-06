-- HEADER
local Capping = CreateFrame("Button", "Capping", UIParent)
local self = Capping
local L = CappingLocale

-- LIBRARIES
local media = LibStub("LibSharedMedia-3.0")
media:Register("statusbar", "BantoBarReverse", "Interface\\AddOns\\Capping\\BantoBarReverse")

-- GLOBALS MADE LOCAL
local _G = getfenv(0)
local format, strmatch, strlower, type = format, strmatch, strlower, type
local min, floor, math_sin, math_pi, tonumber = min, floor, math.sin, math.pi, tonumber
local GetTime, time = GetTime, time

-- LOCAL VARS
local db, wasInBG, bgmap, bgtab, realm, _, instance
local activebars, bars, currentq, bgdd = { }, { }, { }, { }
local av, ab, eots, wsg, winter, ioc = L["Alterac Valley"], L["Arathi Basin"], L["Eye of the Storm"], L["Warsong Gulch"], L["Wintergrasp"], L["Isle of Conquest"]
local stamin = 1 / 60
local narrowed, borderhidden, pointset, ACountText, HCountText
Capping.backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", }
Capping.activebars = activebars

-- LOCAL FUNCS
local ShowOptions
local oSetPoint = Capping.SetPoint
local nofunc = function() end
local function ToggleAnchor()
	if self:IsShown() then
		self:Hide()
	else 
		self:Show()
	end
end
local function SetPoints(this, lp, lrt, lrp, lx, ly, rp, rrt, rrp, rx, ry)
	this:ClearAllPoints()
	this:SetPoint(lp, lrt, lrp, lx, ly)
	if rp then this:SetPoint(rp, rrt, rrp, rx, ry) end
end
local function SetWH(this, w, h)
	this:SetWidth(w)
	this:SetHeight(h)
end
local function NewText(parent, font, fontsize, justifyH, justifyV, overlay)
	local t = parent:CreateFontString(nil, overlay or "OVERLAY")
	if fontsize then
		t:SetFont(font, fontsize)
		t:SetShadowColor(0, 0, 0)
		t:SetShadowOffset(1, -1)
	else
		t:SetFontObject(font)
	end
	t:SetJustifyH(justifyH) 
	t:SetJustifyV(justifyV)
	return t
end

local StartWinterGraspTimer, warned
local function WGInProgress()
	if GetMapInfo() == "LakeWintergrasp" then
		Capping:StopBar(_G.WINTERGRASP_IN_PROGRESS or "WG in Progress")
	elseif StartWinterGraspTimer() then
		Capping:StopBar(_G.WINTERGRASP_IN_PROGRESS or "WG in Progress")
	end
end
local function WGSoon(remain)
	if remain < 60 and remain > 59 and not Capping.wgwarned then
		Capping.wgwarned = true
		RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", format(PVPBATTLEGROUND_WINTERGRASPTIMER_TOOLTIP, "1m"))
	end
end
local function WGStarting()
	if GetMapInfo() ~= "LakeWintergrasp" then
		Capping:StartBar(_G.WINTERGRASP_IN_PROGRESS or "WG in Progress", 1805, 1805, "Interface\\Icons\\INV_EssenceOfWintergrasp", "info2", 10, true, nil, nil, WGInProgress)
	end
end
StartWinterGraspTimer = function()
	if not db.winter or IsInInstance() then return end
	local duration = GetWintergraspWaitTime() or 0
	if duration < 1 then
		db[realm] = nil
		return Capping:StopBar(winter)
	end
	db[realm] = time() + duration
	Capping.wgwarned = nil
	Capping:StartBar(winter, (duration > 900 and 8400) or 900, duration, "Interface\\Icons\\INV_EssenceOfWintergrasp", "info1", true, true, nil, WGStarting, WGSoon)
	return true
end
local function StartMoving(this) this:StartMoving() end
local function CreateMover(oldframe, w, h, dragstopfunc)
	local mover = oldframe or CreateFrame("Button", nil, UIParent)
	SetWH(mover, w, h)
	mover:SetBackdrop(Capping.backdrop)
	mover:SetBackdropColor(0, 0, 0, 0.7)
	mover:SetMovable(true)
	mover:RegisterForDrag("LeftButton")
	mover:SetScript("OnDragStart", StartMoving)
	mover:SetScript("OnDragStop", dragstopfunc)
	mover:SetClampedToScreen(true)
	mover:SetFrameStrata("HIGH")
	mover.close = CreateFrame("Button", nil, mover, "UIPanelCloseButton")
	SetWH(mover.close, 20, 20)
	mover.close:SetPoint("TOPRIGHT", 5, 5)
	return mover
end 
hooksecurefunc(WorldStateAlwaysUpFrame, "SetPoint", function()
	if not db or not db.sbx then return end
	oSetPoint(WorldStateAlwaysUpFrame, "TOP", UIParent, "TOPLEFT", db.sbx, db.sby)
end)
local function wsaufu()
	if not db or not db.cbx then return end
	local nexty = 0
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local cb = _G["WorldStateCaptureBar"..i]
		if cb and cb:IsShown() then
			cb:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", db.cbx, db.cby - nexty)
			nexty = nexty + cb:GetHeight()
		end
	end
end
hooksecurefunc("WorldStateAlwaysUpFrame_Update", wsaufu)
hooksecurefunc(VehicleSeatIndicator, "SetPoint", function()
	if not db or not db.seatx then return end
	oSetPoint(VehicleSeatIndicator, "TOPRIGHT", UIParent, "BOTTOMLEFT", db.seatx, db.seaty)
end)
local function UpdateZoneMapVisibility()
	if (not bgmap or not bgmap:IsShown()) and GetCVar("showBattlefieldMinimap") ~= "0" then
		if not bgmap then
			LoadAddOn("Blizzard_BattlefieldMinimap")
		end
		bgmap:Show()
	end
end
hooksecurefunc("WorldMapZoneMinimapDropDown_OnClick", function()
	if GetMapInfo() == "LakeWintergrasp" then
		UpdateZoneMapVisibility()
	end
end)


-- EVENT HANDLERS
local elist, clist = {}, {}
Capping:SetScript("OnEvent", function(this, event, ...)
	this[elist[event] or event](this, ...)
end)
function Capping:RegisterTempEvent(event, other)
	self:RegisterEvent(event)
	elist[event] = other or event
end
function Capping:CheckCombat(func)  -- check combat for secure functions
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		tinsert(clist, func)
	else
		func(self)
	end
end
function Capping:PLAYER_REGEN_ENABLED()  -- run queue when combat ends
	for k, v in ipairs(clist) do
		v(self)
	end
	wipe(clist)
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end


Capping:RegisterEvent("ADDON_LOADED")
---------------------------------
function Capping:ADDON_LOADED(a1)
---------------------------------
	if a1 ~= "Capping" then return end
	
	-- saved variables database setup
	CappingDB = CappingDB or {}
	db = CappingCharDB or (CappingDB.profiles and CappingDB.profiles.Default) or CappingDB
	self.db = db
	if db.dbinit ~= 6 then 
		db.dbinit = 6
		local function SetDefaults(db, t)
			for k, v in pairs(t) do
				if type(db[k]) == "table" then
					SetDefaults(db[k], v)
				else
					db[k] = (db[k] ~= nil and db[k]) or v
				end
			end
		end
		SetDefaults(db, {
			av = true, avquest = true, ab = true, wsg = true, arena = true, eots = true, winter = true, ioc = true,
			port = true, wait = true,
			mapscale = 1.3, narrow = true, hidemapborder = false,
			texture = "BantoBarReverse",
			width = 200, height = 15, inset = 0, spacing = 1,
			mainup = false, reverse = false, fill = false,
			iconpos = "<-", timepos = "<-",
			font = "Friz Quadrata TT", fontsize = 10,
			colors = {
				alliance = { r=0.0, g=0.0, b=1.0, a=1.0, },
				horde = { r=1.0, g=0.0, b=0.0, a=1.0, },
				info1 = { r=0.6, g=0.6, b=0.6, a=1.0, },
				info2 = { r=1.0, g=1.0, b=0.0, a=1.0, },
				font = { r=1, g=1, b=1, a=1, },
			},
		})
	end
	db.colors.spark = db.colors.spark or { r=1, g=1, b=1, a=1, }
  	SlashCmdList.CAPPING = ShowOptions
   	SLASH_CAPPING1 = "/capping"
   	
   	realm = GetCVar("realmName")

   	-- adds Capping config to default UI Interface Options
	local panel = CreateFrame("Frame")
	panel.name = "Capping"
	panel:SetScript("OnShow", function(this)
		local t1 = NewText(this, GameFontNormalLarge, nil, "LEFT", "TOP", "ARTWORK")
		t1:SetPoint("TOPLEFT", 16, -16)
		t1:SetText(this.name)
		
		local t2 = NewText(this, GameFontHighlightSmall, nil, "LEFT", "TOP", "ARTWORK")
		t2:SetHeight(43)
		SetPoints(t2, "TOPLEFT", t1, "BOTTOMLEFT", 0, -8, "RIGHT", this, "RIGHT", -32, 0)
		t2:SetNonSpaceWrap(true)
		local function GetInfo(field)
			return GetAddOnMetadata("Capping", field) or "N/A"
		end
		t2:SetFormattedText("Notes: %s\nAuthor: %s\nVersion: %s", GetInfo("Notes"), GetInfo("Author"), GetInfo("Version"))
	
		local b = CreateFrame("Button", nil, this, "UIPanelButtonTemplate")
		SetWH(b, 120, 20)
		b:SetText(_G.GAMEOPTIONS_MENU)
		b:SetScript("OnClick", ShowOptions)
		b:SetPoint("TOPLEFT", t2, "BOTTOMLEFT", -2, -8)
		this:SetScript("OnShow", nil)
	end)
	InterfaceOptions_AddCategory(panel)
	
	-- anchor frame
	self:Hide()
	if db.x then
		self:SetPoint(db.p or "TOPLEFT", UIParent, db.rp or "TOPLEFT", db.x, db.y)	
	else
		self:SetPoint("CENTER", UIParent, "CENTER", 200, -100)
	end
	CreateMover(self, db.width, 10, function(this) 
		this:StopMovingOrSizing()
		local a,b,c,d,e = this:GetPoint()
		db.p, db.rp, db.x, db.y = a, c, floor(d + 0.5), floor(e + 0.5)
	end)
	self:RegisterForClicks("RightButtonUp")
	self:SetScript("OnClick", ShowOptions)
	self:SetNormalFontObject(GameFontHighlightSmall)
	self:SetText("Capping")

	if db.sbx then WorldStateAlwaysUpFrame:SetPoint("TOP") end  -- world state info frame positioning
	if db.cbx then wsaufu() end  -- capturebar position
	if db.seatx then VehicleSeatIndicator:SetPoint("TOPRIGHT") end  -- vehicle seat position
	
	if BattlefieldMinimap then  -- battlefield minimap setup
		self:InitBGMap()
	else
		function Capping:ADDON_LOADED(a1)
			if a1 ~= "Blizzard_BattlefieldMinimap" then return end
			self:InitBGMap()
		end
	end
	if IsLoggedIn() then
		self:PLAYER_ENTERING_WORLD()
	else
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
	end
end

----------------------------
function Capping:InitBGMap()
----------------------------
	bgmap, bgtab = BattlefieldMinimap, BattlefieldMinimapTab
	BattlefieldMinimapOptions = BattlefieldMinimapOptions or { opacity = 0.7, locked = true, showPlayers = true, }

	bgmap:UnregisterEvent("PLAYER_LOGOUT")
	bgmap:UnregisterEvent("ADDON_LOADED")

	bgdd.text, bgdd.func = "Capping", ShowOptions
	hooksecurefunc("BattlefieldMinimapTabDropDown_Initialize", function() UIDropDownMenu_AddButton(bgdd, 1) end)
	
	hooksecurefunc(bgtab, "StopMovingOrSizing", function()
		local x, y = bgtab:GetCenter()
		BattlefieldMinimapOptions.position = BattlefieldMinimapOptions.position or { }
		BattlefieldMinimapOptions.position.x = floor((x or (GetScreenWidth() - 225)) - (narrowed and pointset and 153 or 0) + 0.5)
		BattlefieldMinimapOptions.position.y = floor((y or BATTLEFIELD_TAB_OFFSET_Y) + 0.5)
		db.bgmapx, db.bgmapy = BattlefieldMinimapOptions.position.x, BattlefieldMinimapOptions.position.y
	end)

	if BattlefieldMinimapOptions.position and BattlefieldMinimapOptions.position.x then
		bgtab:SetPoint("CENTER", UIParent, "BOTTOMLEFT", BattlefieldMinimapOptions.position.x, BattlefieldMinimapOptions.position.y)
	elseif db.bgmapx then
		bgtab:SetPoint("CENTER", UIParent, "BOTTOMLEFT", db.bgmapx, db.bgmapy)
	end
	
	bgtab:StopMovingOrSizing()
	bgtab:SetUserPlaced(true)
	BattlefieldMinimap_OnEvent(nil, "ADDON_LOADED", "Blizzard_BattlefieldMinimap")
	self:ModMap()
	self:UnregisterEvent("ADDON_LOADED")
	self.InitBGMap, self.ADDON_LOADED = nil, nofunc
end

----------------------------------------
function Capping:PLAYER_ENTERING_WORLD()
----------------------------------------
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
	self:UPDATE_BATTLEFIELD_STATUS()
	self:ZoneCheck()
	if db.winter and not StartWinterGraspTimer() and db[realm] and time() < db[realm] then
		self:StartBar(winter, 9225, db[realm] - time(), "Interface\\Icons\\INV_EssenceOfWintergrasp", "info1", 1500, true)
	end
	PVPBattlegroundFrame:HookScript("OnShow", StartWinterGraspTimer)
	self.PLAYER_ENTERING_WORLD = nil
end

----------------------------------------
function Capping:ZONE_CHANGED_NEW_AREA()
----------------------------------------
	if wasInBG then
		self:ResetAll()
	end
	self:ZoneCheck()
end


local tohide = { }
local function HideProtectedStuff()
	for _, v in ipairs(tohide) do
		v:Hide()
	end
end
--------------------------------------
function Capping:AddFrameToHide(frame)  -- secure frames that are hidden upon zone change
--------------------------------------
	tinsert(tohide, frame)
end
---------------------------
function Capping:ResetAll()  -- reset all timers and unregister temp events
---------------------------
	wasInBG = false
	for event in pairs(elist) do  -- unregister all temp events
		elist[event] = nil
		self:UnregisterEvent(event)
	end
	for value, _ in pairs(activebars) do  -- close all temp timerbars
		self:StopBar(value)
		activebars[value] = nil
	end
	self:CheckCombat(HideProtectedStuff)  -- hide secure frames
	if ACountText then ACountText:SetText("") end
	if HCountText then HCountText:SetText("") end
end
----------------------------
function Capping:ZoneCheck()  -- check if new zone is a battleground
----------------------------
	SetMapToCurrentZone()
	_, instance = IsInInstance()
	if instance == "pvp" then
		local z = GetMapInfo()
		wasInBG = true
		if z == "WarsongGulch" and db.wsg then
			self:StartWSG()
		elseif z == "NetherstormArena" and db.eots then
			self:StartEotS()
		elseif z == "ArathiBasin" and db.ab then
			self:StartAB()
		elseif z == "AlteracValley" and db.av then
			self:StartAV()
		elseif z == "IsleofConquest" and db.ioc then
			self:StartIoC()
		end
		if not self.bgtotals then  -- frame to display roster count
			self.bgtotals = CreateFrame("Frame", nil, AlwaysUpFrame1)
			self.bgtotals:SetScript("OnUpdate", function(this, elapsed)
				this.elapsed = (this.elapsed or 0) + elapsed
				if this.elapsed < 4 then return end
				this.elapsed = 0
				RequestBattlefieldScoreData()
			end)
			self:AddFrameToHide(self.bgtotals)
		end
		self.bgtotals:Show()
		
		self:RegisterTempEvent("UPDATE_BATTLEFIELD_SCORE", "UpdateCountText")
		self:RegisterTempEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL", "CheckStartTimer")
		RequestBattlefieldScoreData()
		
		UpdateZoneMapVisibility()
	elseif GetMapInfo() == "LakeWintergrasp" then
		StartWinterGraspTimer()
		UpdateZoneMapVisibility()
		wasInBG = true
		Capping.CheckWinterEnd = StartWinterGraspTimer
		self:RegisterTempEvent("CHAT_MSG_RAID_BOSS_EMOTE", "CheckWinterEnd")
		if db.winter then
			self:StartWintergrasp()
		end
	else
		if instance == "arena" then
			self:RegisterTempEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL", "CheckStartTimer")
			wasInBG = true
		else
			StartWinterGraspTimer()
		end
		if bgmap and bgmap:IsShown() and GetCVar("showBattlefieldMinimap") ~= "2" then
			bgmap:Hide()
		end
	end
	self:ModMap()
end

--------------------------------
function Capping:ModMap(disable)  -- alter the default minimap
--------------------------------
	if not bgmap then return end
	bgmap:SetScale(db.mapscale)
	disable = instance ~= "pvp" or disable

	if db.narrow and not narrowed and not disable then  -- narrow setting
		BattlefieldMinimap1:Hide() BattlefieldMinimap4:Hide() BattlefieldMinimap5:Hide()
		BattlefieldMinimap8:Hide() BattlefieldMinimap9:Hide() BattlefieldMinimap12:Hide()
		BattlefieldMinimapBackground:SetWidth(256 / 2)
		BattlefieldMinimapBackground:SetPoint("TOPLEFT", -12 + 64, 12)
		BattlefieldMinimapCorner:SetPoint("TOPRIGHT", -2 - 52, 3 + 1)
		SetWH(BattlefieldMinimapCorner, 24, 24)
		BattlefieldMinimapCloseButton:SetPoint("TOPRIGHT", bgmap, "TOPRIGHT", 2 - 53, 7)
		SetWH(BattlefieldMinimapCloseButton, 24, 24)
		narrowed = 1
	elseif disable or (not db.narrow and narrowed) then  -- setting things back to blizz's default
		BattlefieldMinimap1:Show() BattlefieldMinimap4:Show() BattlefieldMinimap5:Show()
		BattlefieldMinimap8:Show() BattlefieldMinimap9:Show() BattlefieldMinimap12:Show()
		BattlefieldMinimapBackground:SetWidth(256)
		BattlefieldMinimapBackground:SetPoint("TOPLEFT", -12, 12)
		BattlefieldMinimapCorner:SetPoint("TOPRIGHT", -2, 3)
		SetWH(BattlefieldMinimapCorner, 32, 32)
		BattlefieldMinimapCloseButton:SetPoint("TOPRIGHT", bgmap, "TOPRIGHT", 2, 7)
		SetWH(BattlefieldMinimapCloseButton, 32, 32)
		narrowed = nil
	end

	if narrowed and not db.narrowanchorleft and not pointset then  -- set anchoring after map narrowing
		local tx, ty = bgtab:GetCenter()
		if tx then
			bgtab:ClearAllPoints()
			bgtab:SetPoint("CENTER", UIParent, "BOTTOMLEFT", tx + (116 * db.mapscale), ty)
			bgtab:SetUserPlaced(true)
			pointset = true
		end
	elseif not narrowed and pointset then
		local tx, ty = bgtab:GetCenter()
		bgtab:ClearAllPoints()
		bgtab:SetPoint("CENTER", UIParent, "BOTTOMLEFT", tx - (116 * db.mapscale), ty)
		pointset = nil
	end

	if db.hidemapborder and not borderhidden then  -- Hide border
		BattlefieldMinimapBackground:Hide()
		BattlefieldMinimapCorner:Hide()
		BattlefieldMinimapCloseButton:SetParent(bgtab)
		BattlefieldMinimapCloseButton:SetScale(db.mapscale)
		BattlefieldMinimapCloseButton:HookScript("OnClick", function() bgmap:Hide() end)
		borderhidden = true
	elseif not db.hidemapborder and borderhidden then  -- Show border
		BattlefieldMinimapBackground:Show()
		BattlefieldMinimapCorner:Show()
		BattlefieldMinimapCloseButton:SetParent(bgmap)
		BattlefieldMinimapCloseButton:SetScale(1)
		borderhidden = nil
	end
	bgmap:SetPoint("TOPLEFT", bgtab, "BOTTOMLEFT", (narrowed and -64) or 0, (borderhidden and 0) or -5)
end

do  -- estimated wait timer and port timer
	local q, p = L["Queue: %s"], L["Port: %s"]
	local maxq = MAX_BATTLEFIELD_QUEUES
	local GetBattlefieldStatus = GetBattlefieldStatus
	local GetBattlefieldPortExpiration = GetBattlefieldPortExpiration
	local GetBattlefieldEstimatedWaitTime, GetBattlefieldTimeWaited = GetBattlefieldEstimatedWaitTime, GetBattlefieldTimeWaited
	--------------------------------------------
	function Capping:UPDATE_BATTLEFIELD_STATUS()
	--------------------------------------------
		if not db.port and not db.wait then return end
		
		for map in pairs(currentq) do  -- tag each entry to see if it's changed after updating the list
			currentq[map] = 0
		end
		for i = 1, maxq, 1 do  -- check the status of each queue
			local status, map, _, _, _, teamsize, _ = GetBattlefieldStatus(i)
			if map and (teamsize or 0) > 0 then -- arena
				map = format("%s (%dv%d)", map, teamsize, teamsize)
			end
			if status == "confirm" and db.port then
				self:StopBar(format(q, map))
				self:StartBar(format(p, map), instance == "pvp" and 20 or 40, GetBattlefieldPortExpiration(i), "Interface\\Icons\\Ability_TownWatch", "info2", true, true)
				currentq[map] = i
			elseif status == "queued" and db.wait then
				local esttime = GetBattlefieldEstimatedWaitTime(i) * 0.001
				local estremain = esttime - GetBattlefieldTimeWaited(i) * 0.001
				self:StartBar(format(q, map), esttime > 1 and esttime or 1, estremain > 1 and estremain or 1, "Interface\\Icons\\INV_Misc_Note_03", "info1", 1500, true)
				currentq[map] = i
			end
		end
		for map, flag in pairs(currentq) do  -- stop inactive bars
			if flag == 0 then
				self:StopBar(format(p, map))
				self:StopBar(format(q, map))
				currentq[map] = nil
			end
		end
	end
end


local temp = { }
local function CheckActive(barid)
	local f = bars[barid]
	if f and f:IsShown() then return f end
end
local function DoReport(this, chan)  -- format chat reports
	if not activebars[this.name] then return end
	local faction = (this.color == "horde" and _G.FACTION_HORDE) or (this.color == "alliance" and _G.FACTION_ALLIANCE) or ""
	SendChatMessage(format(L["%s: %s - %d:%02d"], faction, this.displaytext:GetText(), this.remaining * stamin, this.remaining % 60), chan)
end
local function CheckQueue(name, join)
	local qid = currentq[gsub(name, "^(.+): ", "")]
	if type(qid) == "number" then
		AcceptBattlefieldPort(qid, join) -- leave queue
		return true
	else
		local mode, submode = GetLFGMode()
		if mode == "queued" then
			LeaveLFG()
			return true
		end
	end
end
local function ReportBG(barid)  -- report timer to /bg
	local this = CheckActive(barid)
	if not this then return end
	if not CheckQueue(this.name, true) then
		DoReport(this, "BATTLEGROUND")
	end
end
local function ReportSAY(barid)  -- report timer to /s
	local this = CheckActive(barid)
	if not this then return end
	DoReport(this, "SAY")
end
local function CancelBar(barid)  -- close bar, leave queue if a queue timer
	local this = CheckActive(barid)
	if not this then return end
	if not CheckQueue(this.name, nil) then
		Capping:StopBar(nil, this)
	end
end
local function BarOnClick(this, button)
	if button == "LeftButton" then
		if IsShiftKeyDown() then
			ReportSAY(this.id)
		elseif IsControlKeyDown() then
			ReportBG(this.id)
		else
			ToggleAnchor()
		end
	elseif button == "RightButton" then
		if IsControlKeyDown() then
			CancelBar(this.id)
		else
			ShowOptions(nil, this.id)
		end
	end
end

local function SetDepleteValue(this, remain, duration)
	this.bar:SetValue( (remain > 0 and remain or 0.0001) / duration )
end
local function SetFillValue(this, remain, duration)
	this.bar:SetValue( ((remain > 0 and duration - remain) or duration) / duration )
end
local function BarOnUpdate(this, a1)
	this.elapsed = this.elapsed + a1
	if this.elapsed < this.throt then return end
	this.elapsed = 0

	local remain = this.endtime - GetTime()
	this.remaining = remain
	
	this:SetValue(remain, this.duration)
	this.pfunction(remain)
	if remain < 60 then
		if remain < 10 then  -- fade effects
			if remain > 0.5 then
				this:SetAlpha(0.75 + 0.25 * math_sin(remain * math_pi))
			elseif remain > -1.5 then
				this:SetAlpha((remain + 1.5) * 0.5)
			elseif this.noclose then
				if remain < -this.noclose then
					Capping:StopBar(nil, this)
				else
					this:SetAlpha(0.7)
					this.throt = 10
				end
				this.endfunction()
				return
			else
				this.endfunction()
				return Capping:StopBar(nil, this)
			end
			this.throt = 0.05
		end
		this.timetext:SetFormattedText("%d", remain < 0 and 0 or remain)
	elseif remain < 600 then
		this.timetext:SetFormattedText("%d:%02d", remain * stamin, remain % 60)
	elseif remain < 3600 then
		this.timetext:SetFormattedText("%dm", remain * stamin)
	else
		this.timetext:SetFormattedText("|cffaaaaaa%d:%02d|r", remain / 3600, remain % 3600 * stamin)
	end
end
local function lsort(a, b)
	return bars[a].remaining < bars[b].remaining
end
local function SortBars()
	for i = 1, #bars, 1 do
		temp[i] = i
	end
	sort(temp, lsort)
	local pdown, pup = -1, -1
	for _, k in ipairs(temp) do
		local f = bars[k]
		if f:IsShown() then
			if f.down then
				SetPoints(f, "TOPLEFT", bars[pdown] or Capping, "BOTTOMLEFT", 0, -(db.spacing or 1))
				pdown = k
			else
				SetPoints(f, "BOTTOMLEFT", bars[pup] or Capping, "TOPLEFT", 0, db.spacing or 1)
				pup = k
			end
		end
	end
end
local function SetValue(this, frac)
	frac = (frac < 0.0001 and 0.0001) or (frac > 1 and 1) or frac
	this:SetWidth(frac * this.basevalue)
	this:SetTexCoord(0, frac, 0, 1)
end
local function SetReverseValue(this, frac)
	frac = (frac < 0.0001 and 0.0001) or (frac > 1 and 1) or frac
	this:SetWidth(frac * this.basevalue)
	this:SetTexCoord(frac, 0, 0, 1)
end
local function UpdateBarLayout(f)
	local inset, w, h, tc = db.inset or 0, db.width or 200, db.height or 12, db.colors.font
	local icon, bar, barback, spark, timetext, displaytext = f.icon, f.bar, f.barback, f.spark, f.timetext, f.displaytext
	local nh = h * (db.altstyle and 0.25 or 1)
	local ih = nh - 2 * inset
	ih = ih > 0 and ih or 0.5
	SetWH(f, w, h)
	SetWH(icon, h, h)
	SetWH(barback, w - h, nh)
	bar:SetHeight(ih)
	spark:SetHeight(2.35 * ih)
	spark:SetVertexColor(db.colors.spark.r, db.colors.spark.g, db.colors.spark.b, db.colors.spark.a)
	timetext:SetTextColor(tc.r, tc.g, tc.b, tc.a)
	displaytext:SetTextColor(tc.r, tc.g, tc.b, tc.a)
	f.SetValue = db.fill and SetFillValue or SetDepleteValue
	if db.iconpos == "X" then  -- icon position
		icon:Hide()
		barback:SetWidth(w)
		SetPoints(barback, "BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
	elseif db.iconpos == "->" then
		icon:Show()
		SetPoints(icon, "RIGHT", f, "RIGHT", 0, 0)
		SetPoints(barback, "BOTTOMRIGHT", icon, "BOTTOMLEFT", 0, 0)
	else
		icon:Show()
		SetPoints(icon, "LEFT", f, "LEFT", 0, 0)
		SetPoints(barback, "BOTTOMLEFT", icon, "BOTTOMRIGHT", 0, 0)
	end
	if db.timepos == "->" then  -- time text placement
		SetPoints(timetext, "RIGHT", barback, "RIGHT", -(4 + inset), db.altstyle and (0.5 * h) or 0)
		SetPoints(displaytext, "LEFT", barback, "LEFT", (4 + inset), db.altstyle and (0.5 * h) or 0, "RIGHT", timetext, "LEFT", -(4 + inset), 0)
	else
		SetPoints(displaytext, "LEFT", barback, "LEFT", db.fontsize * 3, db.altstyle and (0.5 * h) or 0, "RIGHT", barback, "RIGHT", -(4 + inset), 0)
		SetPoints(timetext, "RIGHT", displaytext, "LEFT", -db.fontsize / 2.2, 0)
	end
	if db.reverse then  -- horizontal flip of bar growth
		SetPoints(bar, "RIGHT", barback, "RIGHT", -inset, 0)
		spark:SetPoint("CENTER", bar, "LEFT", 0, 0)
		bar.SetValue = SetReverseValue
	else
		SetPoints(bar, "LEFT", barback, "LEFT", inset, 0)
		spark:SetPoint("CENTER", bar, "RIGHT", 0, 0)
		bar.SetValue = SetValue
	end
	f:EnableMouse(not db.lockbar)
	bar.basevalue = (w - h) - (2 * inset)
	if f:IsShown() then
		BarOnUpdate(f, 11)
	end
end
-------------------------------------
function Capping:GetBar(name, getone)  -- get active bar or unused/new one
-------------------------------------
	local f, tf
	for k, b in ipairs(bars) do  -- find already assigned bar
		if b.name == name then
			f = b
		elseif getone and not tf and not b:IsShown() then
			tf = b
		end
	end
	if not getone then return f end -- don't assign a new bar

	f = f or tf
	if not f then  -- no available bar, create new one
		local texture = media:Fetch("statusbar", db.texture)
		local font = media:Fetch("font", db.font)
		
		f = CreateFrame("Button", nil, UIParent)
		f:Hide()
		f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		f:SetScript("OnClick", BarOnClick)
		f:SetScript("OnUpdate", BarOnUpdate)
		f.icon = f:CreateTexture(nil, "ARTWORK")
		f.barback = f:CreateTexture(nil, "BACKGROUND")
		f.barback:SetTexture(texture)
		f.bar = f:CreateTexture(nil, "ARTWORK")
		f.bar:SetTexture(texture)
		
		local spark = f:CreateTexture(nil, "OVERLAY")
		spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		spark:SetBlendMode("ADD")
		spark:SetAlpha(0.8)
		spark:SetWidth(18)
		f.spark = spark
		
		f.timetext = NewText(f, font, db.fontsize, "RIGHT", "CENTER")
		f.displaytext = NewText(f, font, db.fontsize, "LEFT", "CENTER")
		
		UpdateBarLayout(f)
		tinsert(bars, f)
		f.id = #bars
	end
	return f
end

----------------------------------------------------------------------------------------------------------------------------------------
function Capping:StartBar(name, duration, remaining, icondata, colorid, nonactive, separate, specialText, endfunction, periodicfunction)
----------------------------------------------------------------------------------------------------------------------------------------
	if not duration or not remaining then return end
	local icon, l, r, t, b
	if icondata == self.iconpath then
		icon, l, r, t, b = icondata[1], icondata[2], icondata[3], icondata[4], icondata[5]
	else
		icon, l, r, t, b = icondata, 0.07, 0.93, 0.07, 0.93
	end
	local c = db.colors[colorid or "info1"] or db.colors.info1
	if db.onegroup then
		separate = db.mainup
	elseif db.mainup then 
		separate = not separate 
	end
	duration = (duration < remaining and remaining) or duration
	
	local f = self:GetBar(name, true)
	f.name = name
	f.color = colorid
	f.endtime = GetTime() + remaining
	f.duration = duration
	f.remaining = remaining
	f.down = not separate
	f.noclose = type(nonactive) == "number" and nonactive
	f.throt = (duration < 300 and 0.1) or (duration < 600 and 0.25) or 0.5
	f.elapsed = f.throt - 0.01
	f.endfunction = endfunction or nofunc
	f.pfunction = periodicfunction or nofunc
	
	f.displaytext:SetText(specialText or name)
	f.icon:SetTexture(icon)
	f.icon:SetTexCoord(l or 0, r or 1, t or 0, b or 1)
	f.bar:SetVertexColor(c.r, c.g, c.b, c.a or 0.9)
	f.barback:SetVertexColor(c.r * 0.3, c.g * 0.3, c.b * 0.3, db.bgalpha or 0.7)
	f:SetAlpha(1)
	
	activebars[name] = (not nonactive and colorid) or nil
	f:Show()
	SortBars()
end
------------------------------------
function Capping:StopBar(name, this)
------------------------------------
	local f = this or self:GetBar(name)
	if f then
		f.name = ""
		f:Hide()
		SortBars()
	end
end

local timetil
------------------------------------
function Capping:CheckStartTimer(a1)  -- timer for when a battleground begins
------------------------------------
	timetil = timetil or {
		[strlower(L["1 minute"])] = 62,
		[strlower(L["One minute until"])] = 62,
		[strlower(L["60 seconds"])] = 62,
		[strlower(L["30 seconds"])] = 31,
		[strlower(L["15 seconds"])] = 16,
		[strlower(L["Forty five seconds"])] = 46,
		[strlower(L["Thirty seconds until"])] = 31,
		[strlower(L["Fifteen seconds until"])] = 16,
	}
	a1 = strlower(a1)
	for text, duration in pairs(timetil) do
		if strmatch(a1, text) then
			self:StartBar(L["Battle Begins"], 62, duration, "Interface\\Icons\\Spell_Holy_PrayerOfHealing", "info2")
			break
		end
	end
	if instance == "arena" and strmatch(a1, strlower(L["has begun"])) then  -- Shadow Sight spawn timer
		local spell, _, icon = GetSpellInfo(34709)
		self:StartBar(spell, 93, 93, icon, "info2")
	end
end

local GetBattlefieldScore, GetNumBattlefieldScores = GetBattlefieldScore, GetNumBattlefieldScores
----------------------------------
function Capping:UpdateCountText()  -- roster counts
----------------------------------
	if not AlwaysUpFrame2 then return end
	local na, nh
	for i = 1, GetNumBattlefieldScores(), 1 do
		local _, _, _, _, _, ifaction = GetBattlefieldScore(i)
		if ifaction == 0 then
			nh = (nh or 0) + 1
		elseif ifaction == 1 then
			na = (na or 0) + 1
		end
	end
	ACountText = ACountText or self:CreateText(AlwaysUpFrame1, 10, "CENTER", AlwaysUpFrame1Icon, 3, 2, AlwaysUpFrame1Icon, -19, 16)
	HCountText = HCountText or self:CreateText(AlwaysUpFrame2, 10, "CENTER", AlwaysUpFrame2Icon, 3, 2, AlwaysUpFrame2Icon, -19, 16)
	ACountText:SetText(na or "")
	HCountText:SetText(nh or "")
	
	local offset = ((not AlwaysUpFrame1Icon:GetTexture() or AlwaysUpFrame1Icon:GetTexture() == "") and 1) or 0
	SetPoints(ACountText, "TOPLEFT", _G["AlwaysUpFrame"..(1 + offset).."Icon"], "TOPLEFT", 3, 2, "BOTTOMRIGHT", _G["AlwaysUpFrame"..(1 + offset).."Icon"], "BOTTOMRIGHT", -19, 16)
	SetPoints(HCountText, "TOPLEFT", _G["AlwaysUpFrame"..(2 + offset).."Icon"], "TOPLEFT", 3, 2, "BOTTOMRIGHT", _G["AlwaysUpFrame"..(2 + offset).."Icon"], "BOTTOMRIGHT", -19, 16)
end

---------------------------------------------------------------------------------------
function Capping:CreateText(parent, fontsize, justifyH, tlrp, tlx, tly, brrp, brx, bry)  -- create common text fontstring
---------------------------------------------------------------------------------------
	local text = NewText(parent, GameFontNormal:GetFont(), fontsize, justifyH, "CENTER")
	SetPoints(text, "TOPLEFT", tlrp, "TOPLEFT", tlx, tly, "BOTTOMRIGHT", brrp, "BOTTOMRIGHT", brx, bry)
	text:SetShadowColor(0,0,0)
	text:SetShadowOffset(-1, -1)
	return text
end

local CappingDD, barid, Exec
function ShowOptions(a1, id)
	barid = type(id) == "number" and id
	if not CappingDD then
	CappingDD = CreateFrame("Frame", "CappingDD", Capping)
	CappingDD.displayMode = "MENU"
	local info = { }
	local abbrv = { av = av, ab = ab, eots = eots, wsg = wsg, winter = winter, ioc = ioc, }
	local offsetvalue, offsetcount, lastb
	local sbmover, cbmover, seatmover
	local function UpdateLook(k)
		local texture = media:Fetch("statusbar", db.texture)
		local font = media:Fetch("font", db.font)
		local fc = db.colors.font
		Capping:SetWidth(db.width)
		for index, f in pairs(bars) do
			f.bar:SetTexture(texture)
			f.barback:SetTexture(texture)
			f.timetext:SetFont(font, db.fontsize-1)
			f.displaytext:SetFont(font, db.fontsize)
			f:SetHeight(db.height)
			if k == "colors" or k == "bgalpha" then
				local bc = db.colors[f.color]
				f.bar:SetVertexColor(bc.r, bc.g, bc.b, bc.a or 1)
				f.barback:SetVertexColor(bc.r * 0.3, bc.g * 0.3, bc.b * 0.3, db.bgalpha or 0.7)
			end
			if k == "mainup" then f.down = not f.down end
			if k == "onegroup" and db.onegroup then f.down = not db.mainup end
			UpdateBarLayout(f)
		end
		SortBars()
		Capping:ModMap()
	end
	local function HideCheck(b)
		if b and b.GetName and _G[b:GetName().."Check"] then
			_G[b:GetName().."Check"]:Hide()
		end
	end
	local function CloseMenu(b) 
		if not b or not b:GetParent() then return end
		CloseDropDownMenus(b:GetParent():GetID())
	end
	hooksecurefunc("ToggleDropDownMenu", function(...) lastb = select(8, ...) end)
	Exec = function(b, k, value)
		if b then HideCheck(b) end
		if k == "showoptions" then CloseMenu(b) ShowOptions()
		elseif k == "anchor" then ToggleAnchor()
		elseif k == "syncav" and GetRealZoneText() == av then Capping:SyncAV()
		elseif k == "reportbg" then CloseMenu(b) ReportBG(value)
		elseif k == "reportsay" then CloseMenu(b) ReportSAY(value)
		elseif k == "enterbattle" then CloseMenu(b) ReportBG(value)
		elseif k == "leavequeue" or k == "canceltimer" then CloseMenu(b) CancelBar(value)
		elseif (k == "less" or k == "more") and lastb then
			local off = (k == "less" and -8) or 8
			if offsetvalue == value then
				offsetcount = offsetcount + off
			else
				offsetvalue, offsetcount = value, off
			end
			local tb = _G[gsub(lastb:GetName(), "ExpandArrow", "")]
			CloseMenu(b)
			ToggleDropDownMenu(b:GetParent():GetID(), tb.value, nil, nil, nil, nil, tb.menuList, tb)
		elseif k == "test" then
			local testicon = "Interface\\Icons\\Ability_ThunderBolt"
			Capping:StartBar(L["Test"].." - ".._G.OTHER.."1", 100, 100, testicon, "info1", true, true)
			Capping:StartBar(L["Test"].." - ".._G.OTHER.."2", 75, 75, testicon, "info2", true, true)
			Capping:StartBar(L["Test"].." - ".._G.FACTION_ALLIANCE, 45, 45, testicon, "alliance", true)
			Capping:StartBar(L["Test"].." - ".._G.FACTION_HORDE, 100, 100, testicon, "horde", true)
			Capping:StartBar(L["Test"], 75, 75, testicon, "info2", true)
		elseif k == "movesb" then
			sbmover = sbmover or CreateMover(nil, 220, 48, function(this)
				this:StopMovingOrSizing()
				db.sbx, db.sby = floor(this:GetLeft() + 50.5), floor(this:GetTop() - GetScreenHeight() + 10.5)
				WorldStateAlwaysUpFrame:SetPoint("TOP")
			end)
			sbmover:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", WorldStateAlwaysUpFrame:GetLeft() - 50, WorldStateAlwaysUpFrame:GetTop() - 10)
			sbmover:Show()
		elseif k == "movecb" then
			cbmover = cbmover or CreateMover(nil, 173, 27, function(this)
				this:StopMovingOrSizing()
				db.cbx, db.cby = floor(this:GetRight() + 0.5), floor(this:GetTop() + 0.5)
				wsaufu()
			end)
			local x, y = db.cbx or max(0, MinimapCluster:GetRight() - CONTAINER_OFFSET_X), db.cby or max(20, MinimapCluster:GetBottom())
			cbmover:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", x, y)
			cbmover:Show()
		elseif k == "moveseat" then
			seatmover = seatmover or CreateMover(nil, 128, 128, function(this)
				this:StopMovingOrSizing()
				db.seatx, db.seaty = floor(this:GetRight() + 0.5), floor(this:GetTop() + 0.5)
				VehicleSeatIndicator:SetPoint("TOPRIGHT")
			end)
			seatmover:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", VehicleSeatIndicator:GetRight(), VehicleSeatIndicator:GetTop())
			seatmover:Show()
		elseif k == "resetmap" and bgtab then
			bgtab:ClearAllPoints()
			bgtab:SetPoint("CENTER")
		elseif k == "resetall" and IsShiftKeyDown() then
			CappingDB = nil
			ReloadUI()
		end
	end
	local function Set(b, k)
		if not k then return end
		db[k] = not db[k]
		if abbrv[k] then  -- enable/disable a battleground while in it
			if GetRealZoneText() == abbrv[k] then
				Capping:ZONE_CHANGED_NEW_AREA()
			elseif k == "winter" and not v then
				Capping:StopBar(winter)
			end
		elseif k == "perchar" then
			if CappingCharDB then
				CappingCharDB = nil
			else
				CappingCharDB = db
			end
			ReloadUI()
		else  -- update visual options
			UpdateLook(k)
		end
	end
	local function SetSelect(b, a1)
		db[a1] = tonumber(b.value) or b.value
		local level, num = strmatch(b:GetName(), "DropDownList(%d+)Button(%d+)")
		level, num = tonumber(level) or 0, tonumber(num) or 0
		for i = 1, UIDROPDOWNMENU_MAXBUTTONS, 1 do
			local b = _G["DropDownList"..level.."Button"..i.."Check"]
			if b then
				b[i == num and "Show" or "Hide"](b)
			end
		end
		UpdateLook(a1)
	end
	local function SetColor(a1)
		local dbc = db.colors[UIDROPDOWNMENU_MENU_VALUE]
		if not dbc then return end
		if a1 then
			local pv = ColorPickerFrame.previousValues
			dbc.r, dbc.g, dbc.b, dbc.a = pv.r, pv.g, pv.b, 1 - pv.opacity
		else
			dbc.r, dbc.g, dbc.b = ColorPickerFrame:GetColorRGB()
			dbc.a = 1 - OpacitySliderFrame:GetValue()
		end
		UpdateLook("colors")
	end
	local function AddButton(lvl, text, keepshown)
		info.text = text
		info.keepShownOnClick = keepshown
		UIDropDownMenu_AddButton(info, lvl)
		wipe(info)
	end
	local function AddToggle(lvl, text, value)
		info.arg1 = value
		info.func = Set
		if value == "perchar" then
			info.checked = CappingCharDB and true
		else
			info.checked = db[value]
		end
		AddButton(lvl, text, 1)
	end
	local function AddExecute(lvl, text, arg1, arg2)
		info.arg1 = arg1
		info.arg2 = arg2
		info.func = Exec
		AddButton(lvl, text, 1)
	end
	local function AddColor(lvl, text, value)
		local dbc = db.colors[value]
		if not dbc then return end
		info.hasColorSwatch = true
		info.hasOpacity = 1
		info.r, info.g, info.b, info.opacity = dbc.r, dbc.g, dbc.b, 1 - dbc.a
		info.swatchFunc, info.opacityFunc, info.cancelFunc = SetColor, SetColor, SetColor
		info.value = value
		info.func = UIDropDownMenuButton_OpenColorPicker
		AddButton(lvl, text, nil)
	end
	local function AddList(lvl, text, value)
		info.value = value
		info.hasArrow = true
		info.func = HideCheck
		AddButton(lvl, text, 1)
	end
	local function AddSelect(lvl, text, arg1, value)
		info.arg1 = arg1
		info.func = SetSelect
		info.value = value
		if tonumber(value) and tonumber(db[arg1] or "blah") then
			if floor(100 * tonumber(value)) == floor(100 * tonumber(db[arg1])) then
				info.checked = true
			end
		else
			info.checked = (db[arg1] == value)
		end
		AddButton(lvl, text, 1)
	end
	local function AddFakeSlider(lvl, value, minv, maxv, step, tbl)
		local cvalue = 0
		local dbv = db[value]
		if type(dbv) == "string" and tbl then
			for i, v in ipairs(tbl) do
				if dbv == v then
					cvalue = i
					break
				end
			end
		else
			cvalue = dbv or ((maxv - minv) / 2)
		end
		local adj = (offsetvalue == value and offsetcount) or 0
		local starti = max(minv, cvalue - (7 - adj) * step)
		local endi = min(maxv, cvalue + (8 + adj) * step)
		if starti == minv then
			endi = min(maxv, starti + 16 * step)
		elseif endi == maxv then
			starti = max(minv, endi - 16 * step)
		end
		if starti > minv then
			AddExecute(lvl, "--", "less", value)
		end
		if tbl then
			for i = starti, endi, step do
				AddSelect(lvl, tbl[i], value, tbl[i])
			end
		else
			local fstring = (step >= 1 and "%d") or (step >= 0.1 and "%.1f") or "%.2f"
			for i = starti, endi, step do
				AddSelect(lvl, format(fstring, i), value, i)
			end
		end
		if endi < maxv then
			AddExecute(lvl, "++", "more", value)
		end
	end
	CappingDD.initialize = function(this, lvl)
		if lvl == 1 then
			if type(barid) == "number" then
				local bname = bars[barid].name
				info.isTitle = true
				AddButton(lvl, bname)
				if bname == winter then
					AddExecute(lvl, L["Cancel Timer"], "canceltimer", barid)
				elseif not activebars[bname] then
					AddExecute(lvl, _G.ENTER_BATTLE, "enterbattle", barid)
					AddExecute(lvl, _G.LEAVE_QUEUE, "leavequeue", barid)
				else
					AddExecute(lvl, L["Send to BG"], "reportbg", barid)
					AddExecute(lvl, L["Send to SAY"], "reportsay", barid)
					AddExecute(lvl, L["Cancel Timer"], "canceltimer", barid)
				end
				
				info.isTitle = true
				AddButton(lvl, " ")
				AddExecute(lvl, _G.GAMEOPTIONS_MENU, "showoptions")
			else
				info.isTitle = true
				AddButton(lvl, "|cff5555ffCapping|r")
				AddList(lvl, _G.BATTLEFIELDS, "battlegrounds")
				AddList(lvl, L["Bar"], "bars")
				AddList(lvl, _G.BATTLEFIELD_MINIMAP, "bgmap")
				AddList(lvl, _G.OTHER, "other")
				AddExecute(lvl, L["Show/Hide Anchor"], "anchor")
			end
		elseif lvl == 2 then
			local sub = UIDROPDOWNMENU_MENU_VALUE
			if sub == "battlegrounds" then
				AddToggle(lvl, av, "av")
				AddToggle(lvl, " -"..L["Auto Quest Turnins"], "avquest")
				AddExecute(lvl, " -"..L["Request Sync"], "syncav")
				AddToggle(lvl, ab, "ab")
				AddToggle(lvl, eots, "eots")
				AddToggle(lvl, ioc, "ioc")
				AddToggle(lvl, wsg, "wsg")
				AddToggle(lvl, winter, "winter")
			elseif sub == "bars" then
				AddList(lvl, L["Texture"], "texture")
				AddList(lvl, L["Width"], "width")
				AddList(lvl, L["Height"], "height")
				AddList(lvl, L["Border Width"], "inset")
				AddList(lvl, L["Spacing"], "spacing")
				AddList(lvl, _G.EMBLEM_SYMBOL or "Icon", "iconpos")
				AddList(lvl, L["Font"], "font")
				AddList(lvl, _G.FONT_SIZE, "fontsize")
				AddList(lvl, L["Time Position"], "timepos")
				AddList(lvl, _G.COLORS, "color")
				AddList(lvl, _G.BACKGROUND.." ".._G.OPACITY, "bgalpha")
				AddList(lvl, _G.OTHER, "more")
				AddExecute(lvl, L["Test"], "test")
			elseif sub == "bgmap" then
				AddToggle(lvl, L["Narrow Map Mode"], "narrow")
				AddToggle(lvl, L["Narrow Anchor Left"], "narrowanchorleft")
				AddToggle(lvl, L["Hide Border"], "hidemapborder")
				AddList(lvl, L["Map Scale"], "mapscale")
				AddExecute(lvl, _G.RESET or "Reset", "resetmap")
			elseif sub == "other" then
				AddToggle(lvl, L["Port Timer"], "port")
				AddToggle(lvl, L["Wait Timer"], "wait")
				AddExecute(lvl, L["Move Scoreboard"], "movesb")
				AddExecute(lvl, L["Move Capture Bar"], "movecb")
				AddExecute(lvl, L["Move Vehicle Seat"], "moveseat")
				AddToggle(lvl, _G.CHARACTER.." ".._G.SAVE, "perchar")
				AddExecute(lvl, _G.RESET_TO_DEFAULT.." (".._G.SHIFT_KEY_TEXT..")", "resetall")
			end
		elseif lvl == 3 then
			local sub = UIDROPDOWNMENU_MENU_VALUE
			if sub == "texture" or sub == "font" then
				local t = media:List(sub == "texture" and "statusbar" or sub)
				AddFakeSlider(lvl, sub, 1, #t, 1, t)
			elseif sub == "more" then
				AddToggle(lvl, _G.OTHER.." "..L["Bar"], "altstyle")
				AddToggle(lvl, L["Fill Grow"], "fill")
				AddToggle(lvl, L["Fill Right"], "reverse")
				AddToggle(lvl, L["Flip Growth"], "mainup")
				AddToggle(lvl, L["Single Group"], "onegroup")
				AddToggle(lvl, _G.MAKE_UNINTERACTABLE or _G.LOCK, "lockbar")
			elseif sub == "width" then
				AddFakeSlider(lvl, sub, 20, 600, 2, nil)
			elseif sub == "height" then
				AddFakeSlider(lvl, sub, 2, 100, 1, nil)
			elseif sub == "inset" then
				AddFakeSlider(lvl, sub, 0, 8, 1, nil)
			elseif sub == "iconpos" then
				AddSelect(lvl, "<-", sub, "<-")
				AddSelect(lvl, "->", sub, "->")
				AddSelect(lvl, "X", sub, "X")
			elseif sub == "spacing" then
				AddFakeSlider(lvl, sub, 0, 10, 1, nil)
			elseif sub == "fontsize" then
				AddFakeSlider(lvl, sub, 4, 28, 1, nil)
			elseif sub == "timepos" then
				AddSelect(lvl, "<-", sub, "<-")
				AddSelect(lvl, "->", sub, "->")
			elseif sub == "color" then
				AddColor(lvl, _G.FACTION_ALLIANCE, "alliance")
				AddColor(lvl, _G.FACTION_HORDE, "horde")
				AddColor(lvl, _G.OTHER.."1", "info1")
				AddColor(lvl, _G.OTHER.."2", "info2")
				AddColor(lvl, L["Font"], "font")
				AddColor(lvl, "Spark", "spark")
			elseif sub == "bgalpha" then
				AddFakeSlider(lvl, sub, 0, 1, 0.1, nil)
			elseif sub == "mapscale" then
				AddFakeSlider(lvl, sub, 0.2, 5, 0.05, nil)
			end
		end
	end
	end  -- end if not CappingDD then
	ToggleDropDownMenu(1, nil, CappingDD, "cursor")
end

CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
CONFIGMODE_CALLBACKS.Capping = function(action, mode)
	if action == "ON" then
		if not CappingDD then
			ShowOptions()
			ToggleDropDownMenu(1, nil, CappingDD, "cursor")
		end
		if CappingDD and self then
			Exec(nil, "test")
			self:Show()
			UpdateZoneMapVisibility()
		end
	elseif action == "OFF" and CappingDD and self then
		self:Hide()
		if bgmap and bgmap:IsShown() and GetCVar("showBattlefieldMinimap") ~= "2" then
			bgmap:Hide()
		end
	end
end

