local aName, Skinner = ...
local _G = _G

-- check to see if required libraries are loaded
assert(LibStub, aName.." requires LibStub")
for _, lib in pairs{"CallbackHandler-1.0", "AceAddon-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceLocale-3.0", "LibSharedMedia-3.0", "AceDB-3.0", "AceDBOptions-3.0", "AceGUI-3.0",  "AceConfig-3.0", "AceConfigCmd-3.0", "AceConfigRegistry-3.0", "AceConfigDialog-3.0", "LibDataBroker-1.1", "LibDBIcon-1.0",} do
	assert(LibStub:GetLibrary(lib, true), aName.." requires "..lib)
end

-- create the addon
_G[aName] = LibStub("AceAddon-3.0"):NewAddon(Skinner, aName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

-- specify where debug messages go
Skinner.debugFrame = ChatFrame7

-- Get Locale
Skinner.L = LibStub("AceLocale-3.0"):GetLocale(aName)

-- pointer to LibSharedMedia-3.0 library
Skinner.LSM = LibStub("LibSharedMedia-3.0")

-- player class
Skinner.uCls = select(2, UnitClass("player"))

--check to see if running on PTR
Skinner.isPTR = FeedbackUI and true or false
--check to see if running on patch 0.3.5
--Skinner.isPatch = BATTLENET_FRIEND and true or false

local prdb
function Skinner:OnInitialize()
--	self:Debug("OnInitialize")

--[===[@debug@
	self:Print("Debugging is enabled")
	self:Debug("Debugging is enabled")
--@end-debug@]===]

--[===[@alpha@
	if self.isPTR then self:Debug("PTR detected") end
	if self.isPatch then self:Debug("Patch detected") end
--@end-alpha@]===]

	-- setup the default DB values and register them
	self:checkAndRun("Defaults", true)
	prdb = self.db.profile
--	local prdb = self.db.profile
	-- setup the Addon's options
	self:checkAndRun("Options")

	-- register the default background texture
	self.LSM:Register("background", "Blizzard ChatFrame Background", [[Interface\ChatFrame\ChatFrameBackground]])
	-- register the inactive tab texture
	self.LSM:Register("background", "Skinner Inactive Tab", [[Interface\AddOns\Skinner\textures\inactive]])
	-- register the texture used for EditBoxes & ScrollBars
	self.LSM:Register("border", "Skinner Border", [[Interface\AddOns\Skinner\textures\krsnik]])
	-- register the statubar texture used by Nameplates
	self.LSM:Register("statusbar", "Blizzard2", [[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])

	-- register any User defined textures used
    if prdb.BdFile and prdb.BdFile ~= "None" then
        self.LSM:Register("background", "Skinner User Backdrop", prdb.BdFile)
    end
	if prdb.BdEdgeFile and prdb.BdEdgeFile ~= "None" then
		self.LSM:Register("border", "Skinner User Border", prdb.BdEdgeFile)
	end
    if prdb.BgFile and prdb.BgFile ~= "None" then
        self.LSM:Register("background", "Skinner User Background", prdb.BgFile)
    end
    if prdb.TabDDFile and prdb.TabDDFile ~= "None" then
        self.LSM:Register("background", "Skinner User TabDDTexture", prdb.TabDDFile)
    end

	-- Heading and Body Text colours
	local c = prdb.HeadText
	self.HTr, self.HTg, self.HTb = c.r, c.g, c.b
	local c = prdb.BodyText
	self.BTr, self.BTg, self.BTb = c.r, c.g, c.b

	-- Frame multipliers (still used in older skins)
	self.FxMult, self.FyMult = 0.9, 0.87
	-- EditBox regions to keep
	self.ebRegions = {1, 2, 3, 4, 5} -- 1 is text, 2-5 are textures

	-- Gradient settings
	self.gradientTab = {prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .5, .5, .5, 1, .25, .25, .25, 0}
	self.gradientCBar = {prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .25, .25, .55, 1, 0, 0, 0, 1}
	self.gradientTex = self.LSM:Fetch("background", prdb.Gradient.texture)

	-- backdrop for Frames etc
	local bdTex = self.LSM:Fetch("background", "Blizzard ChatFrame Background")
	local bdbTex = self.LSM:Fetch("border", "Blizzard Tooltip")
	if prdb.BdDefault then
		self.backdrop = {
			bgFile = bdTex, tile = true, tileSize = 16,
			edgeFile = bdbTex, edgeSize = 16,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		}
	else
		if prdb.BdFile and prdb.BdFile ~= "None" then
            bdTex = self.LSM:Fetch("background", "Skinner User Backdrop")
        else
			bdTex = self.LSM:Fetch("background", prdb.BdTexture)
		end
		if prdb.BdEdgeFile and prdb.BdEdgeFile ~= "None" then
			bdbTex = self.LSM:Fetch("border", "Skinner User Border")
		else
			bdbTex = self.LSM:Fetch("border", prdb.BdBorderTexture)
		end
		local bdi = prdb.BdInset
		local bdt = prdb.BdTileSize > 0 and true or false
		self.backdrop = {
			bgFile = bdTex, -- use default (fix for texture tiling issue)
			tile = bdt, tileSize = prdb.BdTileSize,
			edgeFile = bdbTex, edgeSize = prdb.BdEdgeSize,
			insets = {left = bdi, right = bdi, top = bdi, bottom = bdi},
		}
	end
	self.Backdrop = {}
	self.Backdrop[1] = CopyTable(self.backdrop)
	-- backdrop for ScrollBars & EditBoxes
	local edgetex = self.LSM:Fetch("border", "Skinner Border")
	-- wide backdrop for ScrollBars (16,16,4)
	self.Backdrop[2] = CopyTable(self.backdrop)
	self.Backdrop[2].edgeFile = edgetex
	-- medium backdrop for ScrollBars (12,12,3)
	self.Backdrop[3] = CopyTable(self.Backdrop[2])
	self.Backdrop[3].tileSize = 12
	self.Backdrop[3].edgeSize = 12
	self.Backdrop[3].insets = {left = 3, right = 3, top = 3, bottom = 3}
	-- narrow backdrop for ScrollBars (8,8,2)
	self.Backdrop[4] = CopyTable(self.Backdrop[2])
    self.Backdrop[4].tileSize = 8
	self.Backdrop[4].edgeSize = 8
	self.Backdrop[4].insets = {left = 2, right = 2, top = 2, bottom = 2}
	-- these backdrops are for small UI buttons, e.g. minus/plus in QuestLog/IOP/Skills etc
	self.Backdrop[5] = CopyTable(self.backdrop)
	self.Backdrop[5].tileSize = 12
	self.Backdrop[5].edgeSize = 12
	self.Backdrop[5].insets = {left = 3, right = 3, top = 3, bottom = 3}
	self.Backdrop[6] = CopyTable(self.backdrop)
	self.Backdrop[6].tileSize = 10
	self.Backdrop[6].edgeSize = 10
	self.Backdrop[6].insets = {left = 3, right = 3, top = 3, bottom = 3}
	-- setup background texture
	if prdb.BgUseTex then
    	if prdb.BgFile and prdb.BgFile ~= "None" then
            self.bgTex = self.LSM:Fetch("background", "Skinner User Background")
        else
    		self.bgTex = self.LSM:Fetch("background", prdb.BgTexture)
    	end
    end
	-- these are used to disable frames from being skinned
	self.charKeys1 = {"CharacterFrames", "PVPFrame", "PetStableFrame", "SpellBookFrame", "GlyphUI", "TalentUI", "DressUpFrame", "AchievementUI", "FriendsFrame", "TradeSkillUI", "TradeFrame", "QuestLog", "RaidUI", "ReadyCheck", "Buffs", "VehicleMenuBar", "WatchFrame", "GearManager", "AlertFrames"}
	self.charKeys2 = {}
	self.npcKeys = {"MerchantFrames", "GossipFrame", "TrainerUI", "TaxiFrame", "QuestFrame", "Battlefields", "ArenaFrame", "ArenaRegistrar", "GuildRegistrar", "Petition", "Tabard", "BarbershopUI", "QuestInfo"}
	self.uiKeys1 = {"StaticPopups", "ChatMenus", "ChatTabs", "ChatFrames", "ChatConfig", "LootFrame", "StackSplit", "ItemText", "Colours", "HelpFrame", "Tutorial", "GMSurveyUI", "InspectUI", "BattleScore", "BattlefieldMm", "DropDowns", "MinimapButtons", "TimeManager", "Calendar", "MenuFrames", "BankFrame", "MailFrame", "AuctionUI", "CoinPickup", "ItemSocketingUI", "GuildBankUI", "Nameplates", "GMChatUI", "DebugTools", "LFDFrame", "LFRFrame", "ScriptErrors"}
	self.uiKeys2 = {"Tooltips", "MirrorTimers", "CastingBar", "ChatEditBox", "GroupLoot", "ContainerFrames", "WorldMap", "MainMenuBar"}

	-- optional/patched frames
	if IsMacClient() then self:add2Table(self.uiKeys1, "MovieProgress") end
	if self.isPTR then self:add2Table(self.uiKeys1, "FeedbackUI") end

	-- these are used to disable the gradient
	self.gradFrames = {["c"] = {}, ["u"] = {}, ["n"] = {}, ["s"] = {}}

	-- TooltipBorder colours
	local c = prdb.TooltipBorder
	self.tbColour = {c.r, c.g, c.b, c.a}
	-- StatusBar colours
	local c = prdb.StatusBar
	self.sbColour = {c.r, c.g, c.b, c.a}
	self.sbTexture = self.LSM:Fetch("statusbar", prdb.StatusBar.texture)
	-- Backdrop colours
	local c = prdb.Backdrop
	self.bColour = {c.r, c.g, c.b, c.a}
	-- BackdropBorder colours
	local c = prdb.BackdropBorder
	self.bbColour = {c.r, c.g, c.b, c.a}
	-- Inactive Tab & DropDowns texture
	if prdb.TabDDFile and prdb.TabDDFile ~= "None" then
        self.itTex = self.LSM:Fetch("background", "Skinner User TabDDTexture")
    else
		self.itTex = self.LSM:Fetch("background", prdb.TabDDTexture)
	end
	-- Empty Slot texture
	self.esTex = [[Interface\Buttons\UI-Quickslot2]]

	-- class table
	self.classTable = {"Druid", "Priest", "Paladin", "Hunter", "Rogue", "Shaman", "Mage", "Warlock", "Warrior", "DeathKnight"}

	-- store Addons managed by LoadManagers
	self.lmAddons = {}

	-- table to hold which functions have been actioned
	self.initialized = {}

	-- table to hold objects which have been skinned
	-- with a metatable having weak keys and automatically adding an entry if it doesn't exist
	self.skinned = setmetatable({}, {__mode = "k", __index = function(t, k) t[k] = true end})

	-- table to hold frames that have been added, with weak keys
	self.skinFrame = setmetatable({}, {__mode = "k"})

--	-- table to hold buttons that have been added, with weak keys
	self.sBut = setmetatable({}, {__mode = "k"})

	-- table to hold StatusBars that have been glazed, with weak keys
	self.sbGlazed = setmetatable({}, {__mode = "k"})

	-- shorthand for the TexturedTab profile setting
	self.isTT = prdb.TexturedTab and true or false

	-- hook to handle textured tabs on Blizzard & other Frames
	self.tabFrames = {}
	if self.isTT then
		self:SecureHook("PanelTemplates_SetTab", function(frame, id)
--			self:Debug("PT_ST: [%s, %s, %s, %s]", frame, id, frame.numTabs or "nil", frame.selectedTab or "nil")
			if not self.tabFrames[frame] then return end -- ignore frame
			for i = 1, frame.numTabs do
				local tabSF = self.skinFrame[_G[frame:GetName().."Tab"..i]]
				if i == id then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

end

function Skinner:OnEnable()
--	self:Debug("OnEnable")

	-- add support for UIButton skinning
	self.modBtns = self:GetModule("UIButtons", true):IsEnabled() and self:GetModule("UIButtons", true)
	self.checkTex = self.modBtns and self.modBtns.checkTex or function() end
	self.skinButton = self.modBtns and self.modBtns.skinButton or function() end
	self.isButton = self.modBtns and self.modBtns.isButton or function() end
	self.skinAllButtons = self.modBtns and self.modBtns.skinAllButtons or function() end

	self:RegisterEvent("AUCTION_HOUSE_SHOW")
	-- register for event after a slight delay as registering ADDON_LOADED any earlier causes it not to be registered if LoD modules are loaded on startup (e.g. SimpleSelfRebuff/LightHeaded)
	self:ScheduleTimer(function() self:RegisterEvent("ADDON_LOADED") end, self.db.profile.Delay.Init)
	-- skin the Blizzard frames
	self:ScheduleTimer("BlizzardFrames", self.db.profile.Delay.Init)
	-- skin the loaded AddOns frames
	self:ScheduleTimer("AddonFrames", self.db.profile.Delay.Init + self.db.profile.Delay.Addons + 0.1)

	-- handle profile changes
	self.db.RegisterCallback(self, "OnProfileChanged", "ReloadAddon")
	self.db.RegisterCallback(self, "OnProfileCopied", "ReloadAddon")
	self.db.RegisterCallback(self, "OnProfileReset", "ReloadAddon")

	-- handle statusbar changes
	self.LSM.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(mtype, override)
		if mtype == "statusbar" then
			self.db.profile.StatusBar.texture = override
			self:updateSBTexture()
		elseif mtype == "background" then
			self.db.profile.BdTexture = override
		elseif mtype == "border" then
			self.db.profile.BdBorderTexture = override
		end
	end)

--[===[@debug@
	self:SetupCmds()
--@end-debug@]===]

end

function Skinner:ReloadAddon(callback)
-- 	self:Debug("ReloadAddon:[%s]", callback)

	StaticPopupDialogs["Skinner_Reload_UI"] = {
		text = self.L["Confirm reload of UI to activate profile changes"],
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function()
			ReloadUI()
		end,
		OnCancel = function(this, data, reason)
			if reason == "timeout" or reason == "clicked" then
				self:CustomPrint(1, 1, 0, "The profile '"..Skinner.db:GetCurrentProfile().."' will be activated next time you Login or Reload the UI")
			end
		end,
		timeout = 0,
		whileDead = 1,
		exclusive = 1,
		hideOnEscape = 1
	}
	StaticPopup_Show("Skinner_Reload_UI")

end

function Skinner:getGradientInfo(invert, rotate)

	local c = prdb.GradientMin
	local MinR, MinG, MinB, MinA = c.r, c.g, c.b, c.a
	local c = prdb.GradientMax
	local MaxR, MaxG, MaxB, MaxA = c.r, c.g, c.b, c.a

	if prdb.Gradient.enable then
		if invert then
			return rotate and "HORIZONTAL" or "VERTICAL", MaxR, MaxG, MaxB, MaxA, MinR, MinG, MinB, MinA
		else
			return rotate and "HORIZONTAL" or "VERTICAL", MinR, MinG, MinB, MinA, MaxR, MaxG, MaxB, MaxA
		end
	else
		return rotate and "HORIZONTAL" or "VERTICAL", 0, 0, 0, 1, 0, 0, 0, 1
	end

end

-- Skinning functions
local function __addSkinButton(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		parent = object to parent to, default is the object's parent
		hook = object to hook Show/Hide methods, defaults to object
		hide = Hide button skin
		sap = SetAllPoints
		bg = set FrameStrata to "BACKGROUND"
		kfs = Remove all textures, only keep font strings
		aso = applySkin options
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object __aSB\n"..debugstack())
--@end-alpha@]===]

	-- remove all textures, if required
	if opts.kfs then Skinner:keepFontStrings(opts.obj) end

	opts.parent = opts.parent or opts.obj:GetParent()
	opts.hook = opts.hook or opts.obj

	local btn = CreateFrame("Button", nil, opts.parent)
	-- lower frame level
	LowerFrameLevel(btn)
	btn:EnableMouse(false) -- allow clickthrough
	Skinner.sBut[opts.hook] = btn
	-- hook Show/Hide methods if required
	if not Skinner:IsHooked(opts.hook, "Show") then
		Skinner:SecureHook(opts.hook, "Show", function(this) Skinner.sBut[this]:Show() end)
		Skinner:SecureHook(opts.hook, "Hide", function(this) Skinner.sBut[this]:Hide() end)
	end
	-- position the button skin
	if opts.sap then
		btn:SetAllPoints(opts.obj)
	else
		-- setup offset values
		local xOfs1 = opts.x1 or -4
		local yOfs1 = opts.y1 or 4
		local xOfs2 = opts.x2 or 4
		local yOfs2 = opts.y2 or -4
		btn:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", xOfs1, yOfs1)
		btn:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)
	end
	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = btn
	Skinner:applySkin(opts.aso)

	-- hide button skin, if required or not shown
	if opts.hide or not opts.obj:IsShown() then btn:Hide() end

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then	btn:SetFrameStrata("BACKGROUND") end

	-- change the draw layer of the Icon and Count, if necessary
	if opts.obj.GetNumRegions then
		for _, reg in pairs{opts.obj:GetRegions()} do
			local regOT = reg:GetObjectType()
			if regOT == "Texture" or regOT == "FontString" then
				local regName = reg:GetName()
				local regDL = reg:GetDrawLayer()
				local regTex = regOT == "Texture" and reg:GetTexture() or nil
				-- change the DrawLayer to make the Icon show if required
				if (regName and (regName:find("[Ii]con") or regName:find("[Cc]ount")))
				or (regTex and regTex:find("[Ii]con")) then
					if regDL == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
				end
			end
		end
	end

	return btn

end

function Skinner:addSkinButton(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object aSB\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.parent = select(2, ...) and select(2, ...) or nil
		opts.hook = select(3, ...) and select(3, ...) or nil
		opts.hide = select(4, ...) and select(4, ...) or nil
	end
	-- new style call
	return __addSkinButton(opts)

end

local hdrTexNames = {"Header", "_Header", "_HeaderBox", "_FrameHeader", "FrameHeader", "HeaderTexture", "HeaderFrame"}
local function hideHeader(obj)

	-- hide the Header Texture and move the Header text, if required
	for _, htex in pairs(hdrTexNames) do
		local hdr = _G[obj:GetName()..htex]
		if hdr then
			hdr:Hide()
			hdr:SetPoint("TOP", obj, "TOP", 0, 7)
			break
		end
	end

end

local function __addSkinFrame(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		ft = Frame Type (Skinner classification)
		kfs = Remove all textures, only keep font strings
		hat = Hide all textures
		hdr = Header Texture to be hidden
		bg = set FrameStrata to "BACKGROUND"
		noBdr = no border
		aso = applySkin options
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
		nb = don't skin UI buttons
		bgen = generations of button children to traverse
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object __aSF\n"..debugstack())
--@end-alpha@]===]

	-- remove the object's Backdrop if it has one
	if opts.obj.GetBackdrop and opts.obj:GetBackdrop() then opts.obj:SetBackdrop(nil) end

	-- store frame obj, if required
	if opts.ft then Skinner:add2Table(Skinner.gradFrames[opts.ft], opts.obj) end

	-- remove all textures, if required
	if opts.kfs or opts.hat then Skinner:keepFontStrings(opts.obj, opts.hat) end

	-- setup offset values
	local xOfs1 = opts.x1 or 0
	local yOfs1 = opts.y1 or 0
	local xOfs2 = opts.x2 or 0
	local yOfs2 = opts.y2 or 0

	-- add a frame around the current object
	local skinFrame = CreateFrame("Frame", nil, opts.obj)
	skinFrame:ClearAllPoints()
	if xOfs1 == 0 and yOfs1 == 0 and xOfs2 == 0 and yOfs2 == 0 then
	 	skinFrame:SetAllPoints(opts.obj)
	else
		skinFrame:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", xOfs1, yOfs1)
		skinFrame:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)
	end

	-- store reference to the frame
	Skinner.skinFrame[opts.obj] = skinFrame

	-- handle header, if required
	if opts.hdr then hideHeader(opts.obj) end

	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = skinFrame

	-- handle no Border, if required
	if opts.noBdr then opts.aso.bba = 0	end

	-- skin the frame using supplied options
	Skinner:applySkin(opts.aso)

	-- adjust frame level
	local success, err = pcall(LowerFrameLevel, skinFrame) -- catch any error, doesn't matter if already 0
	if not success then RaiseFrameLevel(opts.obj) end -- raise parent's Frame Level if 0

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then	skinFrame:SetFrameStrata("BACKGROUND") end

	-- skin the buttons unless not required
	if not opts.nb -- don't skin buttons
	and not opts.noBdr -- this is a tab/unit frame
	then
		Skinner:skinAllButtons{obj=opts.obj, bgen=opts.bgen}
	end

	return skinFrame

end

function Skinner:addSkinFrame(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object aSF\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.x1 = select(2, ...) and select(2, ...) or -3
		opts.y1 = select(3, ...) and select(3, ...) or 3
		opts.x2 = select(4, ...) and select(4, ...) or 3
		opts.y2 = select(5, ...) and select(5, ...) or -3
		opts.ft = select(6, ...) and select(6, ...) or nil
		opts.noBdr = select(7, ...) and select(7, ...) or nil
	end

	return __addSkinFrame(opts)

end

function Skinner:applyGradient(frame, fh, invert, rotate)

	-- don't apply a gradient if required
	if not prdb.Gradient.char then
		for _, v in pairs(self.gradFrames["c"]) do
			if v == frame then return end
		end
	end
	if not prdb.Gradient.ui then
		for _, v in pairs(self.gradFrames["u"]) do
			if v == frame then return end
		end
	end
	if not prdb.Gradient.npc then
		for _, v in pairs(self.gradFrames["n"]) do
			if v == frame then return end
		end
	end
	if not prdb.Gradient.skinner then
		for _, v in pairs(self.gradFrames["s"]) do
			if v == frame then return end
		end
	end

	if not frame.tfade then frame.tfade = frame:CreateTexture(nil, "BORDER") end
	frame.tfade:SetTexture(self.gradientTex)

	if prdb.FadeHeight.enable and (prdb.FadeHeight.force or not fh) then
		-- set the Fade Height if not already passed to this function or 'forced'
		-- making sure that it isn't greater than the frame height
		fh = prdb.FadeHeight.value <= ceil(frame:GetHeight()) and prdb.FadeHeight.value or ceil(frame:GetHeight())
	end
--	self:Debug("aG Fade Height: [%s, %s, %s, %s, %s]", frame:GetName(), frame:GetHeight(), fh, invert, rotate)

	frame.tfade:ClearAllPoints()
	if not invert -- fade from top
	and not rotate
	then
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		if fh then frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -(fh - 4))
		else frame.tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4) end
	elseif invert -- fade from bottom
	and not rotate
	then
		frame.tfade:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 4, 4)
		if fh then frame.tfade:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -4, (fh - 4))
		else frame.tfade:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4) end
	elseif not invert -- fade from right
	and rotate
	then
		frame.tfade:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
		if fh then frame.tfade:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -(fh - 4), 4)
		else frame.tfade:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 4, 4) end
	elseif invert -- fade from left
	and rotate
	then
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		if fh then frame.tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", fh - 4, 4)
		else frame.tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4) end
	end

	frame.tfade:SetBlendMode("ADD")
	frame.tfade:SetGradientAlpha(self:getGradientInfo(invert, rotate))

end

function Skinner:applyTexture(frame)

    frame.tbg = frame:CreateTexture(nil, "BORDER")
    frame.tbg:SetTexture(self.bgTex, true) -- have to use true for tiling to work
    frame.tbg:SetBlendMode("ADD") -- use existing frame alpha setting
    -- allow for border inset
    local bdi = self.db.profile.BdInset
    frame.tbg:SetPoint("TOPLEFT", frame, "TOPLEFT", bdi, -bdi)
    frame.tbg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -bdi, bdi)
    -- the texture will be stretched if the following tiling methods are set to false
    frame.tbg:SetHorizTile(self.db.profile.BgTile)
    frame.tbg:SetVertTile(self.db.profile.BgTile)

end

local function __applySkin(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		ft = Frame Type (Skinner classification)
		kfs = Remove all textures, only keep font strings
		hdr = Header Texture to be hidden
		bba = Backdrop Border Alpha value
		ba = Backdrop Alpha value
		fh = Fade Height
		bd = Backdrop table to use, default is 1
		ng = No Gradient effect
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object __aS\n"..debugstack())
--@end-alpha@]===]

	local hasIOT = assert(opts.obj.IsObjectType, "The Object passed isn't a Frame") -- throw an error here to get its original location reported
	if hasIOT and not opts.obj:IsObjectType("Frame") then
		if Skinner.db.profile.Errors then
			Skinner:CustomPrint(1, 0, 0, "Error skinning", opts.obj.GetName and opts.obj:GetName() or opts.obj, "not a Frame or subclass of Frame: ", opts.obj:GetObjectType())
			return
		end
	end

	-- store frame obj, if required
	if opts.ft then Skinner:add2Table(Skinner.gradFrames[opts.ft], opts.obj) end

	-- remove all textures, if required
	if opts.kfs then Skinner:keepFontStrings(opts.obj) end

	-- setup the backdrop
	opts.obj:SetBackdrop(opts.bd or Skinner.Backdrop[1])
	-- colour the backdrop
	local r, g, b, a = unpack(Skinner.bColour)
	opts.obj:SetBackdropColor(r, g, b, opts.ba or a)
	local r, g, b, a = unpack(Skinner.bbColour)
	opts.obj:SetBackdropBorderColor(r, g, b, opts.bba or a)

    -- fix for backdrop textures not tiling vertically
    -- using info from here: http://boss.wowinterface.com/forums/showthread.php?p=185868
    if Skinner.db.profile.BgUseTex then
        if not opts.obj.tbg then Skinner:applyTexture(opts.obj) end
	elseif opts.obj.tbg then
	    opts.obj.tbg = nil -- remove background texture if it exists
	end

	-- handle header, if required
	if opts.hdr then hideHeader(opts.obj) end

	-- apply the 'Skinner' effect
	if not opts.ng then
		Skinner:applyGradient(opts.obj, opts.fh, opts.invert or Skinner.db.profile.Gradient.invert, opts.rotate or Skinner.db.profile.Gradient.rotate)
	end

end

function Skinner:applySkin(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object aS\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.hdr = select(2, ...) and select(2, ...) or nil
		opts.bba = select(3, ...) and select(3, ...) or nil
		opts.ba = select(4, ...) and select(4, ...) or nil
		opts.fh = select(5, ...) and select(5, ...) or nil
		opts.bd = select(6, ...) and select(6, ...) or nil
	end
	__applySkin(opts)

end

local function __adjHeight(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		adj = value to adjust height by
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object __aH\n"..debugstack())
--@end-alpha@]===]
	if opts.adj == 0 then return end

	if not strfind(tostring(opts.adj), "+") then -- if not negative value
		opts.obj:SetHeight(opts.obj:GetHeight() + opts.adj)
	else
		opts.adj = opts.adj * -1 -- make it positive
		opts.obj:SetHeight(opts.obj:GetHeight() - opts.adj)
	end

end

function Skinner:adjHeight(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object aH\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.adj = select(2, ...) and select(2, ...) or 0
	end
	__adjHeight(opts)

end

local function __adjWidth(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		adj = value to adjust width by
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object __aH\n"..debugstack())
--@end-alpha@]===]
	if opts.adj == 0 then return end

	if not strfind(tostring(opts.adj), "+") then -- if not negative value
		opts.obj:SetWidth(opts.obj:GetWidth() + opts.adj)
	else
		opts.adj = opts.adj * -1 -- make it positive
		opts.obj:SetWidth(opts.obj:GetWidth() - opts.adj)
	end

end

function Skinner:adjWidth(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object aH\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.adj = select(2, ...) and select(2, ...) or 0
	end
	__adjWidth(opts)

end

function Skinner:glazeStatusBar(statusBar, fi, bgTex, otherTex)
--[===[@alpha@
	assert(statusBar and statusBar:IsObjectType("StatusBar"), "Not a StatusBar\n"..debugstack())
--@end-alpha@]===]

	if not statusBar or not statusBar:IsObjectType("StatusBar") then return end

	statusBar:SetStatusBarTexture(self.sbTexture)

	if not self.sbGlazed[statusBar] then
		self.sbGlazed[statusBar] = {}
	end
	local sbG = self.sbGlazed[statusBar]

	-- change StatusBar Texture's draw layer if required
	local sbTex = statusBar:GetStatusBarTexture()
	local sbDL = sbTex:GetDrawLayer()
	if sbDL == "BACKGROUND" then sbTex:SetDrawLayer("BORDER") end
	-- fix for tiling introduced in 3.3.3 (Thanks to foreverphk)
	sbTex:SetHorizTile(false)
	sbTex:SetVertTile(false)

	if fi then
		if not sbG.bg then
			sbG.bg = bgTex or statusBar:CreateTexture(nil, "BACKGROUND")
			sbG.bg:SetTexture(self.sbTexture)
			sbG.bg:SetVertexColor(unpack(self.sbColour))
			if not bgTex then
				sbG.bg:SetPoint("TOPLEFT", statusBar, "TOPLEFT", fi, -fi)
				sbG.bg:SetPoint("BOTTOMRIGHT", statusBar, "BOTTOMRIGHT", -fi, fi)
			end
		end
	end
	-- apply texture and store other texture objects
	if otherTex
	and type(otherTex) == "table"
	then
		for _, tex in pairs(otherTex) do
			tex:SetTexture(self.sbTexture)
			tex:SetVertexColor(unpack(self.sbColour))
			sbG[#sbG + 1] = tex
		end
	end

end

function Skinner:keepFontStrings(frame, hide)
--[===[@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if not frame then return end

--	self:Debug("keepFontStrings: [%s]", frame:GetName() or "???")
	for _, reg in pairs{frame:GetRegions()} do
		if not reg:IsObjectType("FontString") then
			if not hide then reg:SetAlpha(0) else reg:Hide() end
		end
	end

end

local function revTable(curTab)

	if not curTab then return end
	local revTab = {}

	for _, v in pairs(curTab) do
		revTab[v] = true
	end

	return revTab

end

function Skinner:keepRegions(frame, regions)
--[===[@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if not frame then return end
	regions	= revTable(regions)

--	self:Debug("keepRegions: [%s]", frame:GetName() or "<Anon>")
	for k, reg in pairs{frame:GetRegions()} do
		-- if we have a list, hide the regions not in that list
		if regions
		and not regions[k]
		then
--			self:Debug("hide region: [%s, %s]", i, reg:GetName() or "<Anon>")
			reg:SetAlpha(0)
--[===[@debug@
			if reg:IsObjectType("FontString") then self:Debug("kr FS: [%s, %s]", frame:GetName() or "<Anon>", k) end
--@end-debug@]===]
		end
	end

end

function Skinner:makeMFRotatable(modelFrame)
--[===[@alpha@
	assert(modelFrame and modelFrame:IsObjectType("PlayerModel"), "Not a PlayerModel\n"..debugstack())
--@end-alpha@]===]

	-- Don't make Model Frames Rotatable if CloseUp is loaded
	if IsAddOnLoaded("CloseUp") then return end

	--frame:EnableMouseWheel(true)
	modelFrame:EnableMouse(true)
	modelFrame.draggingDirection = nil
	modelFrame.cursorPosition = {}

	-- hide rotation buttons
	for _, child in pairs{modelFrame:GetChildren()} do
		local cName = child:GetName()
		if cName and cName:find("Rotate") then
			child:Hide()
		end
	end

	if not self:IsHooked(modelFrame, "OnUpdate") then
		self:SecureHookScript(modelFrame, "OnUpdate", function(this, elapsedTime, ...)
			if this.dragging then
				local x, y = GetCursorPosition()
				if this.cursorPosition.x > x then
					Model_RotateLeft(this, (this.cursorPosition.x - x) * elapsedTime * 2)
				elseif this.cursorPosition.x < x then
					Model_RotateRight(this, (x - this.cursorPosition.x) * elapsedTime * 2)
				end
				this.cursorPosition.x, this.cursorPosition.y = GetCursorPosition()
			end
		end)
		self:SecureHookScript(modelFrame, "OnMouseDown", function(this, button)
			if button == "LeftButton" then
				this.dragging = true
				this.cursorPosition.x, this.cursorPosition.y = GetCursorPosition()
			end
		end)
		self:SecureHookScript(modelFrame, "OnMouseUp", function(this, button)
			if this.dragging then
				this.dragging = false
				this.cursorPosition.x, this.cursorPosition.y = nil
			end
		end)
	end

	--[[ MouseWheel to zoom Modelframe - in/out works, but needs to be fleshed out
	modelFrame:SetScript("OnMouseWheel", function()
		local xPos, yPos, zPos = frame:GetPosition()
		if arg1 == 1 then
			modelFrame:SetPosition(xPos+00.1, 0, 0)
		else
			modelFrame:SetPosition(xPos-00.1, 0, 0)
		end
	end) ]]

end

local function __moveObject(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		x = left/right adjustment
		y = up/down adjustment
		relTo = object to move relative to
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object __mO\n"..debugstack())
--@end-alpha@]===]

	local point, relTo, relPoint, xOfs, yOfs = opts.obj:GetPoint()

--	Skinner:Debug("__mO: [%s, %s, %s, %s, %s]", point, relTo, relPoint, xOfs, yOfs)

	-- handle no Point info
	if not point then return end

	relTo = opts.relTo or relTo
--[===[@alpha@
	assert(relTo, "__moveObject relTo is nil\n"..debugstack())
--@end-alpha@]===]
	-- Workaround for relativeTo crash
	if not relTo then
		if Skinner.db.profile.Warnings then
			Skinner:CustomPrint(1, 0, 0, "moveObject (relativeTo) is nil: %s", opts.obj)
		end
		return
	end

	-- apply the adjustment
	xOfs = opts.x and xOfs + opts.x or xOfs
	yOfs = opts.y and yOfs + opts.y or yOfs

	-- now move it
	opts.obj:ClearAllPoints()
	opts.obj:SetPoint(point, relTo, relPoint, xOfs, yOfs)

end

function Skinner:moveObject(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object mO\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.x = select(3, ...) and select(3, ...) or nil
		if select(2, ...) and select(2, ...) == "-" then opts.x = opts.x * -1 end
		opts.y = select(5, ...) and select(5, ...) or nil
		if select(4, ...) and select(4, ...) == "-" then opts.y = opts.y * -1 end
		opts.relTo = select(6, ...) and select(6, ...) or nil
	end
	__moveObject(opts)

end

function Skinner:removeRegions(frame, regions)
--[===[@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if not frame then return end

	regions	= revTable(regions)

--	self:Debug("removeRegions: [%s]", frame:GetName() or "<Anon>")
	for k, reg in pairs{frame:GetRegions()} do
		if not regions
		or regions
		and regions[k]
		then
--			self:Debug("hide region: [%s, %s]", i, reg:GetName() or "<Anon>")
			reg:SetAlpha(0)
--[===[@debug@
			if reg:IsObjectType("FontString") then self:Debug("rr FS: [%s, %s]", frame:GetName() or "<Anon>", k) end
--@end-debug@]===]
		end
	end

end

function Skinner:setActiveTab(tabName)
--[===[@alpha@
	assert(tabName, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if not tabName then return end
	if not tabName.tfade then return end

--	self:Debug("setActiveTab : [%s]", tabName:GetName())

	tabName.tfade:SetTexture(self.gradientTex)
	tabName.tfade:SetGradientAlpha(self:getGradientInfo(prdb.Gradient.invert, prdb.Gradient.rotate))

end

function Skinner:setInactiveTab(tabName)
--[===[@alpha@
	assert(tabName, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if not tabName then return end
	if not tabName.tfade then return end

--	self:Debug("setInactiveTab : [%s]", tabName:GetName())

	tabName.tfade:SetTexture(self.itTex)
	tabName.tfade:SetAlpha(1)
--	tabName.tfade:SetGradientAlpha(self:getGradientInfo(prdb.Gradient.invert, prdb.Gradient.rotate))

end

function Skinner:setTTBBC()
-- 	self:Debug("setTTBBC: [%s, %s, %s, %s]", unpack(self.tbColour))

	if self.db.profile.Tooltips.border == 1 then
		return unpack(self.tbColour)
	else
		return unpack(self.bbColour)
	end

end

function Skinner:shrinkBag(frame, bpMF)
--[===[@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if not frame then return end

	local frameName = frame:GetName()
	local bgTop = _G[frameName.."BackgroundTop"]
	if floor(bgTop:GetHeight()) == 256 then -- this is the backpack
--		self:Debug("Backpack found")
		if bpMF then -- is this a backpack Money Frame
			local yOfs = select(5, _G[frameName.."MoneyFrame"]:GetPoint())
--			self:Debug("Backpack Money Frame found: [%s, %s]", yOfs, floor(yOfs))
			if floor(yOfs) == -216 or floor(yOfs) == -217 then -- is it still in its original position
--				self:Debug("Backpack Money Frame moved")
				self:moveObject(_G[frameName.."MoneyFrame"], nil, nil, "+", 22)
			end
		end
		self:moveObject(_G[frameName.."Item1"], nil, nil, "+", 19)
	end
	if ceil(bgTop:GetHeight()) == 94 then self:adjHeight{obj=frame, adj=-20} end
	if ceil(bgTop:GetHeight()) == 86 then self:adjHeight{obj=frame, adj=-20} end
	if ceil(bgTop:GetHeight()) == 72 then self:adjHeight{obj=frame, adj=2} end -- 6, 10 or 14 slot bag

	frame:SetWidth(frame:GetWidth() - 10)
	self:moveObject(_G[frameName.."Item1"], "+", 3)

	-- use default fade height
	local fh = self.db.profile.ContainerFrames.fheight <= ceil(frame:GetHeight()) and self.db.profile.ContainerFrames.fheight or ceil(frame:GetHeight())

	if self.db.profile.FadeHeight.enable and self.db.profile.FadeHeight.force then
	-- set the Fade Height
	-- making sure that it isn't greater than the frame height
		fh = self.db.profile.FadeHeight.value <= ceil(frame:GetHeight()) and self.db.profile.FadeHeight.value or ceil(frame:GetHeight())
	end
--	self:Debug("sB - Frame, Fade Height: [%s, %s]", frame:GetName(), fh)

	if fh and frame.tfade then frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -fh) end

end

local function __skinDropDown(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		noSkin = don't skin the DropDown
		noMove = don't move button & Text
		moveTex = move Texture up
		mtx = move Texture left/right
		mty = move Texture up/down
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object__sDD\n"..debugstack())
--@end-alpha@]===]

	if not (opts.obj and opts.obj.GetName and opts.obj:GetName() and _G[opts.obj:GetName().."Right"]) then return end -- ignore tekKonfig & Az dropdowns

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	if not Skinner.db.profile.TexturedDD or opts.noSkin then Skinner:keepFontStrings(opts.obj) return end

	_G[opts.obj:GetName().."Left"]:SetAlpha(0)
	_G[opts.obj:GetName().."Right"]:SetAlpha(0)
	_G[opts.obj:GetName().."Middle"]:SetTexture(Skinner.itTex)
	_G[opts.obj:GetName().."Middle"]:SetHeight(19)

	-- move Button Left and down, Text down
	if not opts.noMove then
		Skinner:moveObject{obj=_G[opts.obj:GetName().."Button"], x=-6, y=-2}
		Skinner:moveObject{obj=_G[opts.obj:GetName().."Text"], y=-2}
	end

	local mtx = opts.mtx or 0
	local mty = opts.moveTex and 2 or (opts.mty or 0)
	if mtx ~= 0 or mty ~= 0 then Skinner:moveObject{obj=_G[opts.obj:GetName().."Middle"], x=mtx, y=mty} end

end

function Skinner:skinDropDown(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object sDD\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.moveTex = select(2, ...) and select(2, ...) or nil
		opts.noSkin = select(3, ...) and select(3, ...) or nil
		opts.noMove = select(4, ...) and select(4, ...) or nil
	end
	__skinDropDown(opts)

end

local function __skinEditBox(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		regs = regions to keep
		noSkin = don't skin the frame
		noHeight = don't change the height
		noWidth = don't change the width
		noInsert = don't change the Inserts
		move = move the edit box, left and up
		x = move the edit box left/right
		y = move the edit box up/down
--]]
--[===[@alpha@
	assert(opts.obj and opts.obj:IsObjectType("EditBox"), "Not an EditBox\n"..debugstack())
--@end-alpha@]===]

	if not opts.obj then return end

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	opts.x = opts.x or 0
	opts.y = opts.y or 0

	local kRegions = CopyTable(Skinner.ebRegions)
	if opts.regs then
		for _, v in pairs(opts.regs) do
		    Skinner:add2Table(kRegions, v)
		end
	end
	Skinner:keepRegions(opts.obj, kRegions)

	if not opts.noInsert then
		-- adjust the left & right text inserts
		local l, r, t, b = opts.obj:GetTextInsets()
		opts.obj:SetTextInsets(l + 5, r + 5, t, b)
	end

	-- change height, if required
	if not (opts.noHeight or opts.obj:IsMultiLine()) then opts.obj:SetHeight(24) end

	-- change width, if required
	if not opts.noWidth then opts.obj:SetWidth(opts.obj:GetWidth() + 5) end

	-- apply the backdrop
	if not opts.noSkin then Skinner:skinUsingBD{obj=opts.obj} end

	-- move to the left & up, if required
	if opts.move then opts.x, opts.y = -2, 2 end

	-- move left/right & up/down, if required
	if opts.x ~= 0 or opts.y ~= 0 then Skinner:moveObject{obj=opts.obj, x=opts.x, y=opts.y} end

end

function Skinner:skinEditBox(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object sEB\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.regs = select(2, ...) and select(2, ...) or {}
		opts.noSkin = select(3, ...) and select(3, ...) or nil
		opts.noHeight = select(4, ...) and select(4, ...) or nil
		opts.noWidth = select(5, ...) and select(5, ...) or nil
		opts.move = select(6, ...) and select(6, ...) or nil
	end
	__skinEditBox(opts)

end

function Skinner:skinFFToggleTabs(tabName, tabCnt, noHeight)
--	self:Debug("skinFFToggleTabs: [%s, %s, %s]", tabName, tabCnt, noHeight)

	for i = 1, tabCnt or 3 do
		local togTab = _G[tabName..i]
		if not togTab then break end -- handle missing Tabs (e.g. Muted)
		if not self.skinned[togTab] then -- don't skin it twice
			self:keepRegions(togTab, {7, 8}) -- N.B. regions 7 & 8 are text & highlight
			if not noHeight then
				self:adjHeight{obj=togTab, adj=-5}
			end
			if i == 1 then self:moveObject{obj=togTab, y=3} end
			self:moveObject{obj=_G[togTab:GetName().."Text"], x=-2, y=3}
			self:moveObject{obj=_G[togTab:GetName().."HighlightTexture"], x=-2, y=5}
			self:addSkinFrame{obj=togTab}
		end
	end

end

function Skinner:skinFFColHeads(buttonName, noCols)
-- 	self:Debug("skinFFColHeads: [%s, %s]", buttonName, noCols)

	noCols = noCols or 4
	for i = 1, noCols do
		self:removeRegions(_G[buttonName..i], {1, 2, 3})
		self:addSkinFrame{obj=_G[buttonName..i]}
	end

end

local function __skinMoneyFrame(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		regs = regions to keep
		moveGIcon = move Gold Icon
		noWidth = don't change the width
		moveSEB = move the Silver edit box left
		moveGEB = move the Gold edit box left
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object __sMF\n"..debugstack())
--@end-alpha@]===]

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	local cbMode = GetCVarBool("colorblindMode")

	for k, v in pairs{"Gold", "Silver", "Copper"} do
		local fName = _G[opts.obj:GetName()..v]
		Skinner:skinEditBox{obj=fName, regs={9, 10}, noHeight=true, noWidth=true} -- N.B. region 9 is the icon, 10 is text
		-- move label to the right for colourblind mode
		if k ~= 1 or opts.moveGIcon then
			Skinner:moveObject{obj=fName.texture, x=10}
			Skinner:moveObject{obj=fName.label, x=10}
--			Skinner:moveObject{obj=Skinner:getRegion(fName, 9), x=10}
		end
		if not opts.noWidth and k ~= 1 then
			fName:SetWidth(fName:GetWidth() + 5)
		end
		if v == "Gold" and opts.moveGEB then
			Skinner:moveObject{obj=fName, x=-8}
		end
		if v == "Silver" and opts.moveSEB then
			Skinner:moveObject{obj=fName, x=-10}
		end
	end

end

function Skinner:skinMoneyFrame(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object sMF\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.moveGIcon = select(2, ...) and select(2, ...) or nil
		opts.noWidth = select(3, ...) and select(3, ...) or nil
		opts.moveSEB = select(4, ...) and select(4, ...) or nil
		opts.moveGEB = select(5, ...) and select(5, ...) or nil
	end
	__skinMoneyFrame(opts)

end

local function __skinScrollBar(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		sbPrefix = Prefix to use
		sbObj = ScrollBar object to use
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
		noRR = Don't remove regions
--]]
--[===[@alpha@
	assert(opts.obj and opts.obj:IsObjectType("ScrollFrame"), "Not a ScrollFrame\n"..debugstack())
--@end-alpha@]===]

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	-- remove all the object's regions, if required
	if not opts.noRR then Skinner:removeRegions(opts.obj)end

	-- get the actual ScrollBar object
	local sBar = opts.sbObj and opts.sbObj or _G[opts.obj:GetName()..(opts.sbPrefix or "").."ScrollBar"]

	-- skin it
	Skinner:skinUsingBD{obj=sBar, size=opts.size}

end

function Skinner:skinScrollBar(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object sSB\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.sbPrefix = select(2, ...) and select(2, ...) or nil
		opts.sbObj = select(3, ...) and select(3, ...) or nil
		opts.size = select(4, ...) and select(4, ...) or 2
	end
	__skinScrollBar(opts)

end

local function __skinSlider(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
--]]
--[===[@alpha@
	assert(opts.obj and opts.obj:IsObjectType("Slider"), "Not a Slider\n"..debugstack())
--@end-alpha@]===]

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	Skinner:keepFontStrings(opts.obj)
	opts.obj:SetAlpha(1)
	opts.obj:GetThumbTexture():SetAlpha(1)

	Skinner:skinUsingBD{obj=opts.obj, size=opts.size}

end

function Skinner:skinSlider(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object sS\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.size = select(2, ...) and select(2, ...) or 2
	end
	__skinSlider(opts)

end

function Skinner:skinTooltip(frame)
	if not self.db.profile.Tooltips.skin then return end
--[===[@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if not frame then return end

	if not prdb.Gradient.ui then return end

    -- add background texture if required
    if self.db.profile.Tooltips.style == 3 then
        if self.db.profile.BgUseTex then
            if not frame.tbg then self:applyTexture(frame) end
        elseif frame.tbg then
            frame.tbg = nil -- remove background texture if it exists
        end
    end

	local ttHeight = ceil(frame:GetHeight())

--    self:Debug("sT: [%s, %s, %s, %s]", frame, frame:GetName(), self.ttBorder, ttHeight)

	if not frame.tfade then frame.tfade = frame:CreateTexture(nil, "BORDER") end
	frame.tfade:SetTexture(self.gradientTex)

	if prdb.Tooltips.style == 1 then
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -6, -27)
	elseif prdb.Tooltips.style == 2 then
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
	else
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		-- set the Fade Height making sure that it isn't greater than the frame height
		local fh = prdb.FadeHeight.value <= ttHeight and prdb.FadeHeight.value or ttHeight
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -(fh - 4))
		frame:SetBackdropColor(unpack(self.bColour))
	end

	frame.tfade:SetBlendMode("ADD")
	frame.tfade:SetGradientAlpha(self:getGradientInfo(prdb.Gradient.invert, prdb.Gradient.rotate))

	-- Check to see if we need to colour the Border
	if not self.ttBorder then
		for _, tooltip in pairs(self.ttCheck) do
			if tooltip == frame:GetName() then
				local r, g, b, a = frame:GetBackdropBorderColor()
				r = ("%.2f"):format(r)
				g = ("%.2f"):format(g)
				b = ("%.2f"):format(b)
				a = ("%.2f"):format(a)
--				self:Debug("checkTTBBC: [%s, %s, %s, %s, %s]", frame:GetName(), r, g, b, a)
				if r ~= "1.00" or g ~= "1.00" or b ~= "1.00" or a ~= "1.00" then return end
			end
		end
	end

	frame:SetBackdropBorderColor(self:setTTBBC())

end

local function __skinUsingBD(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object __sUBD\n"..debugstack())
--@end-alpha@]===]

	opts.size = opts.size or 3 -- default to medium

	opts.obj:SetBackdrop(Skinner.Backdrop[opts.size])
	opts.obj:SetBackdropBorderColor(.2, .2, .2, 1)
	opts.obj:SetBackdropColor(.1, .1, .1, 1)

end

function Skinner:skinUsingBD(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object sUBD\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.size = select(2, ...) and select(2, ...) or 3
	end
	__skinUsingBD(opts)

end

function Skinner:skinUsingBD2(obj)

	self:skinUsingBD{obj=obj, size=2}

end
