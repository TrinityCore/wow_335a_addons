--[[
  MoveAnything 3.3-9.1 (dev-13) by Wagthaa @ Earthen Ring EU

  Earlier versions were developed by:
		MoveAnything! V.2.66 by Vincent
		MoveAnything! vJ.11000.2 by Jason
		MA! 1.12 by Skrag
]]

local addonname, MOVANY = ...
local MAOptions

local function void() end

-- X: http://lua-users.org/wiki/CopyTable
local function tdeepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

local function tcopy(object)
	if type(object) ~= "table" then
		return object
	end
	local new_table = {}
	for index, value in pairs(object) do
		new_table[index] = value
	end
	return setmetatable(new_table, getmetatable(object))
end

local function tlen(t)
	local i = 0
	if t ~= nil then
		for k in pairs(t) do
			i = i + 1
		end
	end
	return i
end

local function dbg(s)
	maPrint(s)
end

MADB = {}

MovAny = {
	guiLines = -1,
	resetConfirm = "",
	bagFrames = {},
	cats = {},
	customCat = nil,
	defFrames = {},
	frames = {},
	framesCount = 0,
	framesIdx = {},
	framesUnsupported = {},
	initRun = nil,
	lastFrameName = nil,
	lAllowedTypes = {
		Frame = "Frame",
		FontString = "FontString",
		Texture = "Texture",
		Button = "Button",
		CheckButton = "CheckButton",
		StatusBar = "StatusBar",
		GameTooltip = "GameTooltip",
		MessageFrame = "MessageFrame",
		PlayerModel = "PlayerModel",
		ColorSelect = "ColorSelect",
		EditBox = "EbitBox",
	},
	lDisallowedFrames = {
		UIParent = "UIParent",
		WorldFrame = "WorldFrame",
		CinematicFrame = "CinematicFrame",
	},
	lDelayedSync = {
		PlayerTalentFrame = "PlayerTalentFrame",
	},
	lCreateBeforeInteract = {
		AchievementAlertFrame1 = "AchievementAlertFrameTemplate",
		AchievementAlertFrame2 = "AchievementAlertFrameTemplate",
		GroupLootFrame1 = "GroupLootFrameTemplate",
		GroupLootFrame2 = "GroupLootFrameTemplate",
		GroupLootFrame3 = "GroupLootFrameTemplate",
		GroupLootFrame4 = "GroupLootFrameTemplate",
	},
	lRunOnceBeforeInteract = {
		AchievementAlertFrame1 = AchievementFrame_LoadUI,
		AchievementAlertFrame2 = AchievementFrame_LoadUI,
		--[[ -- enable the following to auto load standard ui sub addons, will initially use more memory but will avoid the small hickups when they eventually do load. also makes more standard frames available for interaction
		AuctionFrame = AuctionFrame_LoadUI,
		BattlefieldMinimap = BattlefieldMinimap_LoadUI,
		BarberShopFrame = function() BarberShopFrame_LoadUI() ShowUIPanel(BarberShopFrame) HideUIPanel(BarberShopFrame) end,
		CalendarFrame = Calendar_LoadUI,
		ClassTrainerFrame = ClassTrainerFrame_LoadUI,
		GMSurveyFrame = GMSurveyFrame_LoadUI,
		GuildBankFrame = GuildBankFrame_LoadUI,
		InspectFrame = InspectFrame_LoadUI,
		PlayerTalentFrame = TalentFrame_LoadUI,
		MacroFrame = MacroFrame_LoadUI,
		TradeSkillFrame = TradeSkillFrame_LoadUI,
		TimeManagerClockButton = TimeManager_LoadUI,
		--]]
		PlayerTalentFrame = function()
			TalentFrame_LoadUI()
			if PlayerTalentFrame_Toggle then
				hooksecurefunc("PlayerTalentFrame_Toggle", MovAny.hPlayerTalentFrame_Toggle)
			end
		end,
		ReputationWatchBar = function()
			TalentFrame_LoadUI()
			if ReputationWatchBar_Update then
				hooksecurefunc("ReputationWatchBar_Update", MovAny.hReputationWatchBar_Update)
			end
		end,
		QuestLogDetailFrame = function()
			if not QuestLogDetailFrame:IsShown() then
				ShowUIPanel(QuestLogDetailFrame)
				HideUIPanel(QuestLogDetailFrame)
			end
		end,
	},
	lRunBeforeInteract = {
		MainMenuBar = function ()
			if not MovAny.frameOptions["VehicleMenuBar"] or not MovAny.frameOptions["VehicleMenuBar"].pos then
				local v = _G["VehicleMenuBar"]
				v:ClearAllPoints()
				v:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", UIParent:GetWidth()/2 - v:GetWidth()/2, 0)
			end
		end,
		MultiBarLeft = function()
			if MovAny:IsModified("MultiBarLeftHorizontalMover") then
				MovAny:ResetFrame("MultiBarLeftHorizontalMover")
			end
		end,
		MultiBarRight = function()
			if MovAny:IsModified("MultiBarRightHorizontalMover") then
				MovAny:ResetFrame("MultiBarRightHorizontalMover")
			end
		end,
		VehicleMenuBarActionButtonFrame = function()
			VehicleMenuBarActionButtonFrame:SetHeight(VehicleMenuBarActionButton1:GetHeight() + 2)
			VehicleMenuBarActionButtonFrame:SetWidth((VehicleMenuBarActionButton1:GetWidth() + 2) * VEHICLE_MAX_ACTIONBUTTONS)
		 end,
		 LFDSearchStatus = function()
			local opt = MovAny:GetFrameOptions("LFDSearchStatus")
			if not opt or not opt.frameStrata then
				LFDSearchStatus:SetFrameStrata("TOOLTIP")
			end
		 end,
	},
	lRunAfterInteract = {},
	lEnableMouse = {
		WatchFrame,
		DurabilityFrame,
		CastingBarFrame,
		WorldStateScoreFrame,
		WorldStateAlwaysUpFrame,
		AlwaysUpFrame1,
		AlwaysUpFrame2,
		WorldStateCaptureBar1,
		VehicleMenuBar,
		TargetFrameSpellBar,
		FocusFrameSpellBar,
		MirrorTimer1,
		MiniMapInstanceDifficulty,
	},
	lSimpleHide = {},
	lTranslate = {
		minimap = "MinimapCluster",
		tooltip = "TooltipMover",
		player = "PlayerFrame",
		target = "TargetFrame",
		tot = "TargetFrameToT",
		targetoftarget = "TargetFrameToT",
		pet = "PetFrame",
		focus = "FocusFrame",
		bags = "BagButtonsMover",
		keyring = "KeyRingFrame",
		castbar = "CastingBarFrame",
		buffs = "PlayerBuffsMover",
		debuffs = "PlayerDebuffsMover",
		GameTooltip = "TooltipMover",
		ShapeshiftBarFrame = "ShapeshiftButtonsMover",
	},
	lTranslateSec = {
		PVPFrame = "PVPParentFrame",
		ShapeshiftBarFrame = "ShapeshiftButtonsMover",
		BuffFrame = "PlayerBuffsMover",
		ConsolidatedBuffFrame = "PlayerBuffsMover",
	},
	lHideOnScale = {
		["MainMenuExpBar"] = {
			MainMenuXPBarTexture0,
			MainMenuXPBarTexture1,
			MainMenuXPBarTexture2,
			MainMenuXPBarTexture3,
			ExhaustionTick,
			ExhaustionTickNormal,
			ExhaustionTickHighlight,
			ExhaustionLevelFillBar,
			MainMenuXPBarTextureLeftCap,
			MainMenuXPBarTextureRightCap,
			MainMenuXPBarTextureMid,
			MainMenuXPBarDiv1,
			MainMenuXPBarDiv2,
			MainMenuXPBarDiv3,
			MainMenuXPBarDiv4,
			MainMenuXPBarDiv5,
			MainMenuXPBarDiv6,
			MainMenuXPBarDiv7,
			MainMenuXPBarDiv8,
			MainMenuXPBarDiv9,
			MainMenuXPBarDiv10,
			MainMenuXPBarDiv11,
			MainMenuXPBarDiv12,
			MainMenuXPBarDiv13,
			MainMenuXPBarDiv14,
			MainMenuXPBarDiv15,
			MainMenuXPBarDiv16,
			MainMenuXPBarDiv17,
			MainMenuXPBarDiv18,
			MainMenuXPBarDiv19,
		},
		["ReputationWatchBar"] = {
			ReputationWatchBarTexture0,
			ReputationWatchBarTexture1,
			ReputationWatchBarTexture2,
			ReputationWatchBarTexture3,
			ReputationXPBarTexture0,
			ReputationXPBarTexture1,
			ReputationXPBarTexture2,
			ReputationXPBarTexture3,
		},
	},
	lLinkedScaling = {
		["BasicActionButtonsMover"] = {
			ActionBarDownButton = "ActionBarDownButton",
			ActionBarUpButton = "ActionBarUpButton",
		},
		["ReputationWatchBar"] = {
			ReputationWatchStatusBar = "ReputationWatchStatusBar",
		},
		["PlayerFrame"] = {
			ComboFrame = "ComboFrame",
		}
	},
	rendered = nil,
	nextFrameIdx = 1,
	pendingActions = {},
	pendingFrames = {},
	SCROLL_HEIGHT = 24,
	currentMover = nil,
	moverPrefix = "MAMover",
	moverNextId = 1,
	movers = {},
	frameEditors = {},
	DDMPointList = {
		{text = "Top Left", value = "TOPLEFT"},
		{text = "Top", value = "TOP"},
		{text = "Top Right", value = "TOPRIGHT"},
		{text = "Left", value = "LEFT"},
		{text = "Center", value = "CENTER"},
		{text = "Right", value = "RIGHT"},
		{text = "Bottom Left", value = "BOTTOMLEFT"},
		{text = "Bottom", value = "BOTTOM"},
		{text = "Bottom Right", value = "BOTTOMRIGHT"},
	},
	DDMStrataList = {
		--{text = "Parent", value = "PARENT"},
		{text = "Background", value = "BACKGROUND"},
		{text = "Low", value = "LOW"},
		{text = "Medium", value = "MEDIUM"},
		{text = "High", value = "HIGH"},
		{text = "Dialog", value = "DIALOG"},
		{text = "Fullscreen", value = "FULLSCREEN"},
		{text = "Fullscreen Dialog", value = "FULLSCREEN_DIALOG"},
		{text = "Tooltip", value = "TOOLTIP"},
	},
	ScaleWH = {
		MainMenuExpBar = "MainMenuExpBar",
		ReputationWatchBar = "ReputationWatchBar",
		ReputationWatchStatusBar = "ReputationWatchStatusBar",
		WatchFrame = "WatchFrame",
	},
	DetachFromParent = {
		MainMenuBarPerformanceBarFrame = "UIParent",
		TargetofFocusFrame = "UIParent",
		PetFrame = "UIParent",
		PartyMemberFrame1PetFrame = "UIParent",
		PartyMemberFrame2PetFrame = "UIParent",
		PartyMemberFrame3PetFrame = "UIParent",
		PartyMemberFrame4PetFrame = "UIParent",
		DebuffButton1 = "UIParent",
		ReputationWatchBar = "UIParent",
		MainMenuExpBar = "UIParent",
		TimeManagerClockButton = "UIParent",
		--[[VehicleMenuBarHealthBar = "UIParent",
		VehicleMenuBarLeaveButton = "UIParent",
		VehicleMenuBarPowerBar = "UIParent",]]
		MultiCastActionBarFrame = "UIParent",
		MainMenuBarRightEndCap = "UIParent",
		MainMenuBarMaxLevelBar = "UIParent",
		TargetFrameSpellBar = "UIParent",
		FocusFrameSpellBar = "UIParent",
		--LFDSearchStatus = "UIParent",
		MultiBarBottomLeft = "UIParent",
		MANudger = "UIParent",
		MultiBarBottomRight = "UIParent",
		MultiBarBottomLeft = "UIParent",
		PlayerDebuffsMover = "UIParent",
	},
	HideList = {
		VehicleMenuBar = {
			{"VehicleMenuBar", "ARTWORK","BACKGROUND","BORDER","OVERLAY"},
			{"VehicleMenuBarArtFrame", "ARTWORK","BACKGROUND","BORDER","OVERLAY"},
			{"VehicleMenuBarActionButtonFrame", "ARTWORK","BACKGROUND","BORDER","OVERLAY"},
		},
		MAOptions = {
			{"MAOptions", "ARTWORK","BORDER"},
		},
		GameMenuFrame = {
			{"GameMenuFrame", "BACKGROUND","ARTWORK","BORDER"},
		},
		MainMenuBar = {
			{"MainMenuBarArtFrame", "BACKGROUND","ARTWORK"},
			{"PetActionBarFrame", "OVERLAY"},
			{"ShapeshiftBarFrame", "OVERLAY"},
			{"MainMenuBar", "DISABLEMOUSE"},
			{"BonusActionBarFrame", "OVERLAY", "DISABLEMOUSE"},
		},
		MinimapBackdrop = {
			{"MinimapBackdrop", "ARTWORK"},
		},
	},
	HideUsingWH = {},
	MoveOnlyWhenVisible = {
		WorldStateCaptureBar1 = "WorldStateCaptureBar1",
		AlwaysUpFrame1 = "AlwaysUpFrame1",
		AlwaysUpFrame2 = "AlwaysUpFrame2",
		VehicleMenuBarHealthBar = "VehicleMenuBarHealthBar",
		VehicleMenuBarPowerBar = "VehicleMenuBarPowerBar",
		ArenaEnemyFrame1 = "ArenaEnemyFrame1",
		ArenaEnemyFrame2 = "ArenaEnemyFrame2",
		ArenaEnemyFrame3 = "ArenaEnemyFrame3",
		ArenaEnemyFrame4 = "ArenaEnemyFrame4",
		ArenaEnemyFrame5 = "ArenaEnemyFrame5",
	},
	NoAlpha = {
		CastingBarFrame = "CastingBarFrame",
		TargetFrameSpellBar = "TargetFrameSpellBar",
		FocusFrameSpellBar = "FocusFrameSpellBar",
		MinimapBackdrop = "MinimapBackdrop",
		MinimapNorthTag = "MinimapNorthTag",
	},
	NoHide = {
		FramerateLabel = "FramerateLabel",
		UIPanelMover1 = "UIPanelMover1",
		UIPanelMover2 = "UIPanelMover2",
		WorldMapFrame = "WorldMapFrame",
	},
	NoMove = {
		PVPFrame = "PVPFrame",
		MinimapBackdrop = "MinimapBackdrop",
		MinimapNorthTag = "MinimapNorthTag",
		WorldMapFrame = "WorldMapFrame",
	},
	NoScale = {
		WorldStateAlwaysUpFrame = "WorldStateAlwaysUpFrame",
		MainMenuBarArtFrame = "MainMenuBarArtFrame",
		MainMenuBarMaxLevelBar = "MainMenuBarMaxLevelBar",
		MinimapBorderTop = "MinimapBorderTop",
		MinimapBackdrop = "MinimapBackdrop",
		MinimapNorthTag = "MinimapNorthTag",
		WorldMapFrame = "WorldMapFrame",
	},
	NoReparent = {
		TargetFrameSpellBar = "TargetFrameSpellBar",
		FocusFrameSpellBar = "FocusFrameSpellBar",
		VehicleMenuBarHealthBar = "VehicleMenuBarHealthBar",
		VehicleMenuBarLeaveButton = "VehicleMenuBarLeaveButton",
		VehicleMenuBarPowerBar = "VehicleMenuBarPowerBar",
	},
	NoUnanchorRelatives= {
		FramerateLabel = "FramerateLabel",
		WorldStateAlwaysUpFrame = "WorldStateAlwaysUpFrame",
	},
	NoUnanchoring = {
		BuffFrame = "BuffFrame",
		RuneFrame = "RuneFrame",
		TotemFrame = "TotemFrame",
		ComboFrame = "ComboFrame",
		MANudger = "MANudger",
		TimeManagerClockButton = "TimeManagerClockButton",
		TemporaryEnchantFrame = "TemporaryEnchantFrame",
		PartyMember1DebuffsMover = "PartyMember1DebuffsMover",
		PartyMember2DebuffsMover = "PartyMember2DebuffsMover",
		PartyMember3DebuffsMover = "PartyMember3DebuffsMover",
		PartyMember4DebuffsMover = "PartyMember4DebuffsMover",
		PetDebuffsMover = "PetDebuffsMover",
		TargetBuffsMover = "TargetBuffsMover",
		TargetDebuffsMover = "TargetDebuffsMover",
		FocusDebuffsMover = "FocusDebuffsMover",
		TargetFrameToTDebuffsMover = "TargetFrameToTDebuffsMover",
	},
	lAllowedMAFrames = {
		MAOptions = "MAOptions",
		MANudger = "MANudger",
		GameMenuButtonMoveAnything = "GameMenuButtonMoveAnything",
	},
	DefaultFrameList = {
		{"", "Achievements & Quests"},
		{"AchievementFrame", "Achievements"},
		{"AchievementAlertFrame1", "Achievement Alert 1"},
		{"AchievementAlertFrame2", "Achievement Alert 2"},
		{"WatchFrame", "Tracker"},
		{"QuestLogDetailFrame", "Quest Details"},
		{"QuestLogFrame", "Quest Log"},
		{"QuestTimerFrame", "Quest Timer"},

		{"", "Action Bars"},
		{"BasicActionButtonsMover", "Action Bar"},
		{"BasicActionButtonsVerticalMover", "Action Bar - Vertical"},
		{"MultiBarBottomLeft", "Bottom Left Action Bar"},
		{"MultiBarBottomRight", "Bottom Right Action Bar"},
		{"MultiBarRight", "Right Action Bar"},
		{"MultiBarRightHorizontalMover", "Right Action Bar - Horizontal"},
		{"MultiBarLeft", "Right Action Bar 2"},
		{"MultiBarLeftHorizontalMover", "Right Action Bar 2 - Horizontal"},
		{"MainMenuBarPageNumber", "Action Bar Page Number"},
		{"ActionBarUpButton", "Action Bar Page Up"},
		{"ActionBarDownButton", "Action Bar Page Down"},
		{"PetActionButtonsMover", "Pet Action Bar"},
		{"PetActionButtonsVerticalMover", "Pet Action Bar - Vertical"},
		{"ShapeshiftButtonsMover", "Stance / Aura / Shapeshift Buttons"},
		{"ShapeshiftButtonsVerticalMover", "Stance / Aura / Shapeshift - Vertical"},
		{"MultiCastActionBarFrame", "Timers"},

		{"", "Arena"},
		{"ArenaEnemyFrame1", "Arena Enemy 1"},
		{"ArenaEnemyFrame2", "Arena Enemy 2"},
		{"ArenaEnemyFrame3", "Arena Enemy 3"},
		{"ArenaEnemyFrame4", "Arena Enemy 4"},
		{"ArenaEnemyFrame5", "Arena Enemy 5"},
		{"PVPTeamDetails", "Arena Team Details"},
		{"ArenaFrame", "Arena Queue List"},
		{"ArenaRegistrarFrame", "Arena Registrar"},
		{"PVPBannerFrame", "Arena Banner"},

		{"", "Bags"},
		{"BagButtonsMover", "Bag Buttons"},
		{"BagButtonsVerticalMover", "Bag Buttons - Vertical"},
		{"BagFrame1", "Backpack"},
		{"BagFrame2", "Bag 1"},
		{"BagFrame3", "Bag 2"},
		{"BagFrame4", "Bag 3"},
		{"BagFrame5", "Bag 4"},
		{"KeyRingFrame", "Key Ring"},
		{"CharacterBag0Slot", "Bag Button 1"},
		{"CharacterBag1Slot", "Bag Button 2"},
		{"CharacterBag2Slot", "Bag Button 3"},
		{"CharacterBag3Slot", "Bag Button 4"},
		{"KeyRingButton", "Key Ring Button"},

		{"", "Bank"},
		{"BankFrame", "Bank"},
		{"BankBagFrame1", "Bank Bag 1"},
		{"BankBagFrame2", "Bank Bag 2"},
		{"BankBagFrame3", "Bank Bag 3"},
		{"BankBagFrame4", "Bank Bag 4"},
		{"BankBagFrame5", "Bank Bag 5"},
		{"BankBagFrame6", "Bank Bag 6"},
		{"BankBagFrame7", "Bank Bag 7"},
		
		{"", "Battlegrounds & PvP"},
		{"PVPParentFrame", "PVP Window"},
		{"BattlefieldMinimap", "Battlefield Minimap"},
		{"BattlefieldFrame", "Battleground Queue"},
		{"WorldStateScoreFrame", "Battleground Score"},
		{"WorldStateCaptureBar1", "Flag Capture Timer Bar"},

		{"", "Bottom Bar"},
		{"MainMenuBar", "Main Bar"},
		{"MainMenuBarLeftEndCap", "Left Gryphon"},
		{"MainMenuBarRightEndCap", "Right Gryphon"},
		{"MainMenuExpBar", "Experience Bar"},
		{"MainMenuBarMaxLevelBar", "Max Level Bar Filler"},
		{"ReputationWatchBar", "Reputation Tracker Bar"},
		{"MicroButtonsMover", "Micro Menu"},
		{"MicroButtonsVerticalMover", "Micro Menu - Vertical"},
		{"MainMenuBarVehicleLeaveButton", "Leave Vehicle Button"},

		{"", "Dungeons & Raids"},
		{"LFDParentFrame", "Dungeon Finder"},
		{"DungeonCompletionAlertFrame1", "Dungeon Completion Alert"},
		{"LFDSearchStatus", "Dungeon Search Status Tooltip"},
		{"LFDDungeonReadyDialog", "Dungeon Ready Dialog"},
		{"LFDDungeonReadyPopup", "Dungeon Ready Popup"},
		{"LFDDungeonReadyStatus", "Dungeon Ready Status"},
		{"LFDRoleCheckPopup", "Dungeon Role Check Popup"},
		{"RaidBossEmoteFrame", "Raid Boss Emotes"},
		{"Boss1TargetFrame", "Raid Boss Health Bar 1"},
		{"Boss2TargetFrame", "Raid Boss Health Bar 2"},
		{"Boss3TargetFrame", "Raid Boss Health Bar 3"},
		{"Boss4TargetFrame", "Raid Boss Health Bar 4"},
		{"LFRParentFrame", "Raid Browser"},
		{"RaidPullout1", "Raid Group Pullout 1"},
		{"RaidPullout2", "Raid Group Pullout 2"},
		{"RaidPullout3", "Raid Group Pullout 3"},
		{"RaidPullout4", "Raid Group Pullout 4"},
		{"RaidPullout5", "Raid Group Pullout 5"},
		{"RaidPullout6", "Raid Group Pullout 6"},
		{"RaidPullout7", "Raid Group Pullout 7"},
		{"RaidPullout8", "Raid Group Pullout 8"},
		{"RaidWarningFrame", "Raid Warnings"},

		{"", "Focus"},
		{"FocusFrame", "Focus"},
		{"FocusFrameSpellBar", "Focus Casting Bar"},
		{"FocusDebuffsMover", "Focus Debuffs"},
		{"FocusFrameToT", "Target of Focus"},
		{"FocusFrameToTDebuff1", "Target of Focus Debuffs"},

		{"", "Game Menu"},
		{"GameMenuFrame", "Game Menu"},
		{"VideoOptionsFrame", "Video Options"},
		{"AudioOptionsFrame", "Sound & Voice Options"},
		{"InterfaceOptionsFrame", "Interface Options"},
		{"KeyBindingFrame", "Keybinding Options"},

		{"", "Guild"},
		{"GuildBankFrame", "Guild Bank"},
		{"GuildInfoFrame", "Guild Info"},
		{"GuildMemberDetailFrame", "Guild Member Details"},
		{"GuildControlPopupFrame", "Guild Control"},
		{"GuildRegistrarFrame", "Guild Registrar"},

		{"", "Info Panels"},
		{"UIPanelMover1", "Generic Info Panel 1"},
		{"UIPanelMover2", "Generic Info Panel 2"},
		{"CharacterFrame", "Character / Pet / Reputation / Skills / Currency"},
		{"LFDParentFrame", "Dungeon Finder"},
		{"TaxiFrame", "Flight Paths"},
		{"FriendsFrame", "Social - Friends / Who / Guild / Chat / Raid"},
		{"GossipFrame", "Gossip"},
		{"InspectFrame", "Inspect"},
		{"LFRParentFrame", "Looking For Raid"},
		{"MacroFrame", "Macros"},
		{"MailFrame", "Mailbox"},
		{"MerchantFrame", "Merchant"},
		{"OpenMailFrame", "Open Mail"},
		{"PetStableFrame", "Pet Stable"},
		{"SpellBookFrame", "Spell Book"},
		{"TabardFrame", "Tabard Design"},
		{"PlayerTalentFrame", "Talents"},
		{"TradeFrame", "Trade"},
		{"TradeSkillFrame", "Trade Skills"},
		{"ClassTrainerFrame", "Trainer"},
		{"DressUpFrame", "Wardrobe"},

		{"", "Loot"},
		{"LootFrame", "Loot"},
		{"GroupLootFrame1", "Loot Roll 1"},
		{"GroupLootFrame2", "Loot Roll 2"},
		{"GroupLootFrame3", "Loot Roll 3"},
		{"GroupLootFrame4", "Loot Roll 4"},

		{"", "Minimap"},
		{"MinimapCluster", "MiniMap"},
		{"MinimapZoneTextButton", "Zone Text"},
		{"MinimapBorderTop", "Top Border"},
		{"MinimapBackdrop", "Round Border"},
		{"MinimapNorthTag", "North Indicator"},
		{"MiniMapBattlefieldFrame", "Battleground  Button"},
		{"GameTimeFrame", "Calendar Button"},
		{"TimeManagerClockButton", "Clock Button"},
		{"MiniMapInstanceDifficulty", "Dungeon Difficulty"},
		{"MiniMapLFGFrame", "LFD/R Button"},
		{"LFDSearchStatus", "LFD/R Search Status"},
		{"MiniMapMailFrame", "Mail Notification"},
		{"MiniMapTracking", "Tracking Button"},
		{"MinimapZoomIn", "Zoom In Button"},
		{"MinimapZoomOut", "Zoom Out Button"},
		{"MiniMapWorldMapButton", "World Map Button"},
		
		{"", "Miscellaneous"},
		{"TimeManagerFrame", "Alarm Clock"},
		{"AuctionFrame", "Auction House"},
		{"BarberShopFrame", "Barber Shop"},
		{"MirrorTimer1", "Breath/Fatigue Bar"},
		{"CalendarFrame", "Calendar"},
		{"CalendarViewEventFrame", "Calendar Event"},
		{"CastingBarFrame", "Casting Bar"},
		{"ChatConfigFrame", "Chat Channel Configuration"},
		{"ColorPickerFrame", "Color Picker"},
		{"TokenFramePopup", "Currency Options"},
		{"ItemRefTooltip", "Chat Popup"},
		--{"DebuffFrame1", "Debuffs"},
		{"DurabilityFrame", "Durability Figure"},
		{"UIErrorsFrame", "Errors & Warnings"},
		{"FramerateLabel", "Framerate"},
		{"GearManagerDialog", "Equipment Manager"},
		{"ItemSocketingFrame", "Gem Socketing"},
		{"HelpFrame", "GM Help"},
		{"MacroPopupFrame", "Macro Name & Icon"},
		{"StaticPopup1", "Static Popup 1"},
		{"StaticPopup2", "Static Popup 2"},
		{"StaticPopup3", "Static Popup 3"},
		{"StaticPopup4", "Static Popup 4"},
		{"ItemTextFrame", "Reading Materials"},
		{"ReputationDetailFrame", "Reputation Details"},
		{"TemporaryEnchantFrame", "Temporary item buffs"},
		{"TicketStatusFrame", "Ticket Status"},
		{"TooltipMover", "Tooltip"},
		{"BagItemTooltipMover", "Tooltip - Bag Item"},
		{"WorldStateAlwaysUpFrame", "Top Center Status Display"},
		--{"TutorialFrame", "Tutorials"},
		--{"TutorialFrameAlertButton", "Tutorials Alert Button"},
		{"VoiceChatTalkers", "Voice Chat Talkers"},
		{"ZoneTextFrame", "Zoning Zone Text"},
		{"SubZoneTextFrame", "Zoning Subzone Text"},

		{"", "MoveAnything"},
		{"MAOptions", "MoveAnything Window"},
		{"MANudger", "MoveAnything Nudger"},
		{"GameMenuButtonMoveAnything", "MoveAnything Game Menu Button"},

		{"", "Party"},
		{"PartyMemberFrame1", "Party Member 1"},
		{"PartyMember1DebuffsMover", "Party Member 1 Debuffs"},
		{"PartyMemberFrame2", "Party Member 2"},
		{"PartyMember2DebuffsMover", "Party Member 2 Debuffs"},
		{"PartyMemberFrame3", "Party Member 3"},
		{"PartyMember3DebuffsMover", "Party Member 3 Debuffs"},
		{"PartyMemberFrame4", "Party Member 4"},
		{"PartyMember4DebuffsMover", "Party Member 4 Debuffs"},

		{"", "Pets"},
		{"PetFrame", "Pet"},
		{"PetDebuffsMover", "Pet Debuffs"},
		{"PartyMemberFrame1PetFrame", "Party Pet 1"},
		{"PartyMemberFrame2PetFrame", "Party Pet 2"},
		{"PartyMemberFrame3PetFrame", "Party Pet 3"},
		{"PartyMemberFrame4PetFrame", "Party Pet 4"},

		{"", "Player"},
		{"PlayerFrame", "Player"},
		{"PlayerBuffsMover", "Player Buffs"},
		{"ConsolidatedBuffsTooltip", "Player Buffs - Consolidated Tooltip"},
		{"PlayerDebuffsMover", "Player Debuffs"},
		{"RuneFrame", "Deathknight Runes"},
		{"TotemFrame", "Shaman Totem Timers"},

		{"", "Target"},
		{"TargetFrame", "Target"},
		{"TargetBuffsMover", "Target Buffs"},
		{"ComboFrame", "Target Combo Points Display"},
		{"TargetDebuffsMover", "Target Debuffs"},
		{"TargetFrameSpellBar", "Target Casting Bar"},
		{"TargetFrameToT", "Target of Target"},
		{"TargetFrameToTDebuffsMover", "Target of Target Debuffs"},

		{"", "Vehicle"},
		{"VehicleMenuBar", "Vehicle Bar"},
		{"VehicleMenuBarActionButtonFrame", "Vehicle Action Bar"},
		{"VehicleMenuBarHealthBar", "Vehicle Health Bar"},
		{"VehicleMenuBarLeaveButton", "Vehicle Leave Button"},
		{"VehicleMenuBarPowerBar", "Vehicle Power Bar"},
		{"VehicleSeatIndicator", "Vehicle Seat Indicator"},

		{"", "Custom Frames"},
	},


----------------------------------------------------------------
--X: hook replacements

	ContainerFrame_GenerateFrame = function (frame, size, id)
		--dbg("ContainerFrame_GenerateFrame")
		MovAny:GrabContainerFrame(frame, MovAny:GetBag(id))
	end,

	CloseAllWindows = function ()
		local opt, f, fn
		-- should iterate frameSettings instead
		for i, v in pairs(MovAny.frames) do
			fn = v.name
			if v and v.name and MovAny:IsModified(fn) then
				opt = MovAny:GetFrameOptions(fn)
				if opt and opt.UIPanelWindows then
					f = _G[fn]
					if f ~= nil and f ~= GameMenuFrame then
						if f.IsShown and f:IsShown() then
							if InCombatLockdown() and MovAny:IsProtected(f) then
								local closure = function(f)
									return function()
										if MovAny:IsProtected(f) and InCombatLockdown() then
											return true
										end
										f:Hide()
									end
								end
								MovAny.pendingActions[fn..":Hide"] = closure(f)
							else
								f:Hide()
							end
						end
					end
				end
			end
		end
		if MADB.closeGUIOnEscape and MAOptions:IsShown() then
			MAOptions:Hide()
		end
	end,
	
	hCreateFrame = function(frameType, name, parent, inherit)
		if name and MovAny:IsModified(name) then
			if MovAny:HookFrame(name) then
				local f = _G[name]
				if f and MovAny:IsValidObject(f) then
					if not MovAny:IsProtected(f) or not InCombatLockdown() then
						MovAny:ApplyAll(f)
					else
						MovAny.pendingFrames[name] = MovAny:GetFrameOptions(name)
					end
				end
			end
		end
	end,

	ShowUIPanel = function (f)
		MovAny:SetLeftFrameLocation()
		MovAny:SetCenterFrameLocation()
	end,

	HideUIPanel = function (f)
		MovAny:SetLeftFrameLocation()
		MovAny:SetCenterFrameLocation()
	end,

	hPlayerTalentFrame_Toggle = function()
		if MovAny:IsModified("PlayerTalentFrame") then
			MovAny:SyncFrame("PlayerTalentFrame")
			MovAny.lDelayedSync["PlayerTalentFrame"] = nil
		end
	end,
	
	hReputationWatchBar_Update = function()
		if MovAny:IsModified("ReputationWatchBar") then
			MovAny:SyncFrame("ReputationWatchBar")
		end
	end,

	CaptureBar_Create = function(id)
		local f= MovAny.oCaptureBar_Create(id)
		local opts = MovAny:GetFrameOptions("WorldStateCaptureBar1")
		if opts then
			MovAny:ApplyAll(f, opts)
		end
		if not opts or not opts.pos then
			f:ClearAllPoints()
			f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, -175)
		end
		return f
	end,

	AchievementAlertFrame_OnLoad = function(f)
		f.RegisterForClicks = void
		MovAny.oAchievementAlertFrame_OnLoad(f)
		local opts = MovAny:GetFrameOptions(f:GetName())
		if opts then
			MovAny:ApplyAll(f, opts)
		end
	end,

	AchievementAlertFrame_GetAlertFrame = function()
		local f = MovAny.oAchievementAlertFrame_GetAlertFrame()
		if not f then
			return
		end
		local opts = MovAny:GetFrameOptions(f:GetName())
		if opts then
			MovAny:ApplyAll(f, opts)
		end
		return f
	end,
}

BINDING_HEADER_MOVEANYTHING = "MoveAnything"

MoveAnything_CustomFrames = {}
MoveAnything_CharacterSettings = {}
MoveAnything_UseCharacterSettings = nil

StaticPopupDialogs["MOVEANYTHING_RESET_PROFILE_CONFIRM"] = {
	text = MOVANY.PROFILE_RESET_CONFIRM,
	button1 = TEXT(YES),
	button2 = TEXT(NO),
	OnAccept = function()
		MovAny:ResetProfile()
	end,
	timeout = 0,
	exclusive = 0,
	showAlert = 1,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["MOVEANYTHING_RESET_ALL_CONFIRM"] = {
	text = MOVANY.RESET_ALL_CONFIRM,
	button1 = TEXT(YES),
	button2 = TEXT(NO),
	OnAccept = function()
		MovAny:ResetAllFrames()
		MovAny_OptionsOnShow()
	end,
	timeout = 0,
	exclusive = 0,
	showAlert = 1,
	whileDead = 1,
	hideOnEscape = 1
}

function MovAny:Boot()
	if self.inited then
		return
	end
	
	MAOptions = _G["MAOptions"]
	
	if not MADB.noMMMW and Minimap:GetScript("OnMouseWheel") == nil then
		Minimap:SetScript("OnMouseWheel", function(self, dir)
			if dir < 0 then
				Minimap_ZoomOut()
			else
				Minimap_ZoomIn()
			end
		end)
		Minimap:EnableMouseWheel(true)
	end
	
	local autoShowUI = nil
	if MoveAnything_CharacterSettings == nil then
		autoShowUI = true
	end

	self:VerifyData()

	local MADB_Defaults = {
		autoShowNext = nil,
		playSound = nil,
		alwaysShowNudger = nil,
		frameListRows = 18,
	}

	for i, v in pairs(MADB_Defaults) do
		if MADB[i] ~= nil then
		else
			MADB[i] = v
		end
	end
	
	MADB.collapsed = true
	
	if MADB.squareMM then
		Minimap:SetMaskTexture("Interface\\AddOns\\MoveAnything\\MinimapMaskSquare")
	end
	
	self:SetNumRows(MADB.frameListRows, false)
	
	MAOptionsMoveHeader:SetText(MOVANY.LIST_HEADING_MOVER)
	MAOptionsHideHeader:SetText(MOVANY.LIST_HEADING_HIDE)
	
	MAOptionsToggleFrameEditors:SetChecked(true)
	
	self:ParseData()

	-- hooks
	if not MADB.dontHookCreateFrame and CreateFrame then
		hooksecurefunc("CreateFrame", self.hCreateFrame)
	end
	if ContainerFrame_GenerateFrame then
		hooksecurefunc("ContainerFrame_GenerateFrame", self.ContainerFrame_GenerateFrame)
	end
	if CloseAllWindows then
		hooksecurefunc("CloseAllWindows", self.CloseAllWindows)
	end
	if ShowUIPanel then
		hooksecurefunc("ShowUIPanel", self.ShowUIPanel)
	end
	if HideUIPanel then
		hooksecurefunc("HideUIPanel", self.HideUIPanel)
	end
	if GameTooltip_SetDefaultAnchor then
		hooksecurefunc("GameTooltip_SetDefaultAnchor", self.hGameTooltip_SetDefaultAnchor)
	end
	if GameTooltip and GameTooltip.SetOwner then
		hooksecurefunc(GameTooltip, "SetOwner", self.hGameTooltip_SetOwner)
	end
	if updateContainerFrameAnchors then
		hooksecurefunc("updateContainerFrameAnchors", self.hUpdateContainerFrameAnchors)
	end
	
	if ExtendedUI and ExtendedUI.CAPTUREPOINT then
		self.oCaptureBar_Create = ExtendedUI.CAPTUREPOINT.create
		ExtendedUI.CAPTUREPOINT.create = self.CaptureBar_Create
	end

	if AchievementAlertFrame_OnLoad then
		self.oAchievementAlertFrame_OnLoad = AchievementAlertFrame_OnLoad
		AchievementAlertFrame_OnLoad = self.AchievementAlertFrame_OnLoad
	end

	if AchievementAlertFrame_GetAlertFrame then
		self.oAchievementAlertFrame_GetAlertFrame = AchievementAlertFrame_GetAlertFrame
		AchievementAlertFrame_GetAlertFrame = self.AchievementAlertFrame_GetAlertFrame
	end

	self.inited = true
	if MADB.autoShowNext == true then
		autoShowUI = true
		MADB.autoShowNext = nil
	end
	if autoShowUI == true then
		MAOptions:Show()
	end
end

function MovAny:OnPlayerLogout()
	if MAOptions:IsShown() then
		MADB.autoShowNext = true
	end
	
	if type(MoveAnything_CustomFrames) == "table" then
		for i, v in pairs(MoveAnything_CustomFrames) do
			v.idx = nil
			v.cat = nil
		end
	end
	MovAny:CleanProfile(MovAny:GetProfileName())
end

function MovAny:CleanProfile(pn)
	if pn and type(MoveAnything_CharacterSettings[pn]) == "table" then
		local f
		for i, v in pairs(MoveAnything_CharacterSettings[pn]) do
			f = _G[i]
			if f and f.SetUserPlaced and (f:IsMovable() or f:IsResizable()) then
				f:SetUserPlaced(nil)
				f:SetMovable(nil)
			end
			v.ignoreFramePositionManager = nil
			v.cat = nil
			v.originalScale = nil
			v.orgPos = nil
			v.MANAGED_FRAME = nil
			v.UIPanelWindows = nil
		end
	end
end

function MovAny:VerifyData()
	if MoveAnything_CharacterSettings[self:GetProfileName()] == nil then
		MoveAnything_CharacterSettings[self:GetProfileName()] = {}
	end
	
	local fRel
	local remList = {}
	for pi, profile in pairs(MoveAnything_CharacterSettings) do
		--dbg(" cleaning data for "..pi)
		table.wipe(remList)
		for fn, opt in pairs(profile) do
			--dbg(" cleaning "..i)
			if not opt or opt == nil then
				break
			end
			opt.cat = nil
			
			opt.originalLeft = nil
			opt.originalBottom = nil
				
			opt.originalWidth = nil
			opt.originalHeight = nil
			
			opt.orgPos = nil
			
			opt.originalScale = nil
			
			opt.MANAGED_FRAME = nil
			opt.UIPanelWindows = nil
			
			if opt.scale and opt.scale > 0.991 and opt.scale < 1.009 then
				opt.scale = 1
			end
			
			if opt.x ~= nil and opt.y ~= nil then
				f = _G[fn]
				
				fRel = self:ForcedDetachFromParent(fn, opt)
				if not fRel then
					p = f and f.GetParent and f:GetParent() ~= nil and f:GetParent():GetName() or "UIParent"
				end
				
				opt.pos = {"BOTTOMLEFT", p, "BOTTOMLEFT", opt.x, opt.y}
				opt.x = nil
				opt.y = nil
			else
				opt.x = nil
				opt.y = nil
			end
			--[[
			if opt.width and opt.originalWidth and opt.width == opt.originalWidth then
				opt.width = nil
			end
			if opt.height and opt.originalHeight and opt.height == opt.originalHeight then
				opt.height = nil
			end
			]]
			
			if not opt.hidden and opt.pos == nil and opt.scale == nil and opt.width == nil and opt.height == nil and opt.alpha == nil then
				tinsert(remList, fn)
			end
		end
		for i, v in ipairs(remList) do
			--dbg("pruning "..v.." from "..pi)
			MoveAnything_CharacterSettings[pi][v] = nil
		end
	end
end

function MovAny:ParseData()
	local sepLast = nil, sep
	
	if MADB.noList then
		for i, v in pairs(self.DefaultFrameList) do
			if v[1]  then
				if v[1] == "" then
					sep = {}
					sep.name = nil
					sep.helpfulName = v[2]
					sep.sep = true
					sep.collapsed = MADB.collapsed
					sepLast = sep
				end
			end
		end
		sep.idx = self.nextFrameIdx
		self.nextFrameIdx = self.nextFrameIdx + 1
		tinsert(self.frames, sepLast)
		tinsert(self.cats, sepLast)
		self.framesCount = self.framesCount + 1
	else
		for i, v in pairs(self.DefaultFrameList) do
			if v[1]  then
				if v[1] == "" then
					sep = {}
					sep.idx = self.nextFrameIdx
					self.nextFrameIdx = self.nextFrameIdx + 1
					sep.name = nil
					sep.helpfulName = v[2]
					sep.sep = true
					sep.collapsed = MADB.collapsed
					tinsert(self.frames, sep)
					tinsert(self.cats, sep)
					self.framesCount = self.framesCount + 1
					sepLast = sep
				else
					self:AddFrameToMovableList(v[1], v[2], 2)
					if sepLast then
						self.frames[ self.nextFrameIdx - 1 ].cat = sepLast
					end
					if not self.defFrames[ v[1] ] then
						self:AddCustomFrameIfNew(v[1])
					end
				end
			end
		end
	end
	
	self.DefaultFrameList = nil
	self.customCat = sepLast
	
	self.frameOptions = MoveAnything_CharacterSettings[self:GetProfileName()]
	
	table.sort(self.frameOptions, function(o1,o2)
		return o1.name:lower() < o2.name:lower()
	end)
	for i, v in pairs(self.frameOptions) do
		if not self:GetFrame(v.name) then
			self:AddFrameToMovableList(v.name, v.helpfulName, 1)
			self.frames[ self.nextFrameIdx - 1 ].cat = self.customCat
		end
	end
end

function MovAny:VerifyFrameData(fn)
	local opt = self:GetFrameOptions(fn)
	if opt and (not opt.hidden and opt.pos == nil and opt.scale == nil and opt.width == nil and opt.height == nil and opt.alpha == nil) then
		--dbg("purging "..fn)
		MovAny.frameOptions[fn] = nil
	end
end

function MovAny:AddCustomFrameIfNew(name)
	local found = nil
	for i in pairs(MoveAnything_CustomFrames) do
		if MoveAnything_CustomFrames[i].name == name then
			found = i
			break
		end
	end
	if found == nil then
		tinsert(MoveAnything_CustomFrames, {name = name, helpfulName = name})
		self.guiLines = -1
		self:UpdateGUIIfShown(true)
		return true
	end
end

function MovAny:ForcedDetachFromParent(fn, opt)
	if self.DetachFromParent[fn] then
		return self.DetachFromParent[fn]
	end
	if UIPanelWindows[fn] then
		return "UIParent"
	end
	if not opt then
		opt = self.frameOptions[fn]
		if not opt then
			return "UIParent"
		end
	end
	if opt.UIPanelWindows then
		return "UIParent"
	end
end

function MovAny:ErrorNotInCombat(f, quiet)
	if f and self:IsProtected(f) and InCombatLockdown() then
		if not quiet then
			maPrint(string.format(MOVANY.FRAME_PROTECTED_DURING_COMBAT, f:GetName()))
		end
		return true
	end
end

function MovAny:IsScalableFrame(f)
	if not f.SetScale then
		return
	end
	if self.NoScale[f:GetName()] or self.ScaleWH[f:GetName()] then
		return
	end
	return true
end

function MovAny:CanBeScaled(f)
	if f.GetName and self.ScaleWH[ f:GetName() ] then
		return true
	end
	if not f or not f.GetScale or self.NoScale[ f:GetName() ] or f:GetObjectType() == "FontString" then
		return
	end
	return true
end

function MovAny:IsValidObject(f, silent)
	if type(f) == "string" then
		f = _G[ f ]
	end
	if not f then
		return
	end
	if type(f) ~= "table" then
		if not silent then
			maPrint(string.format(MOVANY.UNSUPPORTED_TYPE, type(f)))
		end
		return
	end
	if self.lDisallowedFrames[f:GetName()] then
		if not silent then
			maPrint(string.format(MOVANY.UNSUPPORTED_FRAME, f:GetName()))
		end
		return
	end
	
	local type = f:GetObjectType()
	if not self.lAllowedTypes[type] then
		if not silent then
			maPrint(string.format(MOVANY.UNSUPPORTED_TYPE, f:GetObjectType()))
		end
		return
	end
	
	if MovAny:IsMAFrame(f:GetName()) then
		if MovAny.lAllowedMAFrames[f:GetName()] or string.sub(f:GetName(), 1, 5) == "MA_FE" then
			--dbg("MA Frame: "..f:GetName())
			return true
		end
		return
	end
	return true
end

function MovAny:IsDefaultFrame(f)
	if not f.GetName then
		return
	end
	local fn = f:GetName()
	for i, v in ipairs(MovAny.frames) do
		if v.name == fn then
			return v.default
		end
	end
end

function MovAny:SyncAllFrames(dontReset)
	if not self.rendered then
		dontReset = true
	end
	self.pendingFrames = tcopy(self.frameOptions)
	self:SyncFrames(dontReset)
end

function MovAny:SyncFrames(dontReset)
	if not self.inited or self.syncingFrames then
		return
	end
	
	local i = 0
	for k in pairs(self.pendingFrames) do
		i = i + 1
		break
	end
	--dbg("Syncing "..i.." frames")
	
	if i == 0 then
		return
	end

	self.syncingFrames = true

	local f, parent, handled
	local skippedFrames = {}
	
	if dontReset then
		for fn, opt in pairs(self.pendingFrames) do
			f = _G[fn]
			if f then
				self:UnanchorRelatives(f, opt)
			end
		end
	end
	
	for fn, opt in pairs(self.pendingFrames) do
		if not self:GetMoverByFrameName(fn) then
			handled = nil
			if self.lRunOnceBeforeInteract[fn] then
				if not self.lRunOnceBeforeInteract[fn]() then
					self.lRunOnceBeforeInteract[fn] = nil
				end
			end
			if not opt.disabled and not self.lDelayedSync[fn] then
				if not self.lRunBeforeInteract[fn] or not self.lRunBeforeInteract[fn]() then
					f = _G[fn]
					if f and self:IsValidObject(f, true) then
						if not self:IsProtected(f) or not InCombatLockdown() then
							if dontReset == nil or not dontReset then
								self:ResetAll(f, opt, true)
							end
							if self:IsModified(fn) then
								if self:HookFrame(fn, f, not dontReset) then
									self:ApplyAll(f, opt)
									handled = true
								end
							end
						end
					end
				end
				if self.lRunAfterInteract[fn] then
					self.lRunAfterInteract[fn](handled)
				end
			end
			if not handled then
				--dbg("   "..fn.." unsyncable at the moment")
				skippedFrames[fn] = opt
			end
		end
	end
	self.pendingFrames = skippedFrames
	
	local postponed = {}
	for k, f in pairs(self.pendingActions) do
		if f() then
			tinsert(postponed, f)
		end
	end
	self.pendingActions = postponed
	
	self:SetLeftFrameLocation()
	self:SetCenterFrameLocation()
	
	self.rendered = true
	self.syncingFrames = nil
end

function MovAny:SyncFrame(fn, opt, dontReset)
	if not opt then
		opt = self.frameOptions[fn]
		if not opt then
			return
		end
	end
	
	if opt.disabled then
		return
	end
	
	local handled = nil
	
	if self.lRunOnceBeforeInteract[fn] then
		self.lRunOnceBeforeInteract[fn]()
		self.lRunOnceBeforeInteract[fn] = nil
	end

	if not self.lRunBeforeInteract[fn] or not self.lRunBeforeInteract[fn]() then
		f = _G[fn]
		if f and self:IsValidObject(f, true) then
			if not self:IsProtected(f) or not InCombatLockdown() then
				local mover = self:GetMoverByFrameName(fn)
				if mover then
					MovAny:DetachMover(mover)
				end
				if not dontReset then
					self:ResetAll(f, opt, true)
				end
				if self:IsModified(fn) and self:HookFrame(fn, f) then
					self:ApplyAll(f, opt)
					handled = true
				end
				if mover then
					MovAny:AttachMover(fn)
				end
			end
		end
	end
	if self.lRunAfterInteract[fn] then
		self.lRunAfterInteract[fn](handled)
	end
	if not handled then
		self.pendingFrames[fn] = opt
	end
end

function MovAny:IsProtected(f)
	return f:IsProtected() or f.MAProtected
end

function MovAny:GetProfileName(override)
	local val = MoveAnything_UseCharacterSettings
	if override ~= nil then
		val = override
	end
	if val then
		return GetCVar("realmName").." "..UnitName("player")
	else
		return "default"
	end
end

function MovAny:CopySettings(fromName, toName)
	if MoveAnything_CharacterSettings[toName] == nil then
		MoveAnything_CharacterSettings[toName] = {}
	end
	local l
	for i, val in pairs(MoveAnything_CharacterSettings[fromName]) do
		l = tcopy(val)
		l.cat = nil
		MoveAnything_CharacterSettings[toName][i] = l
	end
end

function MovAny:UpdateProfile(profile)
	self:ResetProfile(true)
	--self:VerifyData()
	self.frameOptions = MoveAnything_CharacterSettings[self:GetProfileName()]
	self:SyncAllFrames(true)
	self:UpdateGUIIfShown(true)
end

function MovAny:GetFrameCount()
	return self.framesCount
end

function MovAny:ClearFrameOptions(fn)
	self.frameOptions[fn] = nil
	self:RemoveIfCustom(fn)
end

function MovAny:GetFrameOptions(fn, noSymLink, create)
	if MovAny.frameOptions == nil then
		return nil
	end
	
	if not noSymLink and not MovAny.frameOptions[fn] and MovAny.lTranslateSec[fn] then
		--dbg(""..fn.." translated to "..self.lTranslateSec[fn])
		fn = MovAny.lTranslateSec[fn]
	end
	
	if create and MovAny.frameOptions[fn] == nil then
		MovAny.frameOptions[fn] = {name = fn, cat = MovAny.customCat}
	end
	return MovAny.frameOptions[fn]
end

function MovAny:GetFrame(fn)
	for i,v in pairs(self.frames) do
		if v.name == fn then
			return v
		end
	end
end

function MovAny:GetFrameIDX(o)
	for i,v in pairs(self.frames) do
		if v == o then
			return i
		end
	end
end

function MovAny:RemoveIfCustom(fn)
	local removed = nil
	for i in pairs(MoveAnything_CustomFrames) do
		if MoveAnything_CustomFrames[i].name == fn then
			table.remove(MoveAnything_CustomFrames, i)
			self.guiLines = -1
			removed = true
			break
		end
	end

	if removed then
		for i in pairs(self.frames) do
			if self.frames[i].name == fn then
				table.remove(self.frames, i)
				self.framesCount = self.framesCount - 1
				break
			end
		end
	end
end

function MovAny.hShow(f, ...)
	--dbg(f:GetName()..":Show() hooked")
	if f.MAHidden then
		if MovAny:IsProtected(f) and InCombatLockdown() then
			local opt = MovAny:GetFrameOptions(f:GetName())
			if opt ~= nil then
				MovAny.pendingFrames[ f:GetName() ] = opt
			end
		else
			f.MAHidden = nil
			f:Hide()
			f.MAHidden = true
		end
	end
end

function MovAny:LockVisibility(f)
	f.MAHidden = true
	
	if not f.MAShowHook then
		hooksecurefunc(f, "Show", MovAny.hShow)
		f.MAShowHook = true
	end
	
	f.MAWasShown = f:IsShown()
	if f.MAWasShown then
		f:Hide()
	end

	if self.lSimpleHide[ f ] then
		--f:Hide()
		return
	end
	
	if f.attachedChildren then
		for i, v in pairs(f.attachedChildren) do
			self:LockVisibility(v)
		end
	end
end

function MovAny:UnlockVisibility(f)
	if not f.MAHidden then
		return
	end
	f.MAHidden = nil
	if self.lSimpleHide[ f ] then
		f:Show()
		return
	end
	
	if f.MAWasShown then
		f.MAWasShown = nil
		f:Show()
	end
	if f.attachedChildren then
		for i, v in pairs(f.attachedChildren) do
			self:UnlockVisibility(v)
		end
	end
end

function MovAny.hSetPoint(f, ...)
	--dbg(f:GetName()..":SetPoint hook called")
	if f.MAPoint then
		--dbg(f:GetName()..":SetPoint hook called. got locked point")
		local fn = f:GetName()
		if string.match(fn, "^ContainerFrame[1-9][0-9]*$") then
			fn = MovAny:GetBagInContainerFrame(f):GetName()
		end
		
		if InCombatLockdown() and MovAny:IsProtected(f) then
			MovAny.pendingFrames[fn] = MovAny:GetFrameOptions(fn)
		else
			local p = f.MAPoint
			f.MAPoint = nil
			f:ClearAllPoints()
			f:SetPoint(unpack(p))
			f.MAPoint = p
			p = nil
		end
	end
end

function MovAny:LockPoint( f )
	if not f.MAPoint then
		if not f.MALockPointHook then
			hooksecurefunc(f, "SetPoint", MovAny.hSetPoint)
			--hooksecurefunc(f, "ClearAllPoints", MovAny.hSetPoint)
			f.MALockPointHook = true
		end
		f.MAPoint = {f:GetPoint(1)}
	end
end

function MovAny:UnlockPoint( f )
	f.MAPoint = nil
end

function MovAny:LockParent(f)
	if not f.MAParented and not f.MAParentHook then
		hooksecurefunc(f, "SetParent", MovAny.hSetParent)
		f.MAParentHook = true
	end
	f.MAParented = f:GetParent()
end

function MovAny:UnlockParent(f)
	f.MAParented = nil
end

function MovAny.hSetParent(f, ...)
	if f.MAParented then
		if InCombatLockdown() and MovAny:IsProtected(f) then
			MovAny.pendingFrames[ f:GetName() ] = MovAny:GetFrameOptions(f:GetName())
		else
			--dbg("SetParent hook repositioning: "..fn)
			local p = f.MAParented
			MovAny:UnlockParent(f)
			f:SetParent(p)
			MovAny:LockParent(f)
		end
	end
end
--[[
function MovAny.hSetWidth(f, ...)
	if f.MAScaled then
		local fn = f:GetName()
		
		if string.match(fn, "^ContainerFrame[0-9]+$") then
			local bag = MovAny:GetBagInContainerFrame(f)
			fn = bag:GetName()
		end
		
		MovAny.pendingFrames[fn] = MovAny:GetFrameOptions(fn)
		if not MovAny:IsProtected(f) or not InCombatLockdown() then
			MovAny:SyncFrames()
		end
	end
end

function MovAny.hSetHeight(f, ...)
	if f.MAScaled then
		local fn = f:GetName()
		
		if string.match(fn, "^ContainerFrame[0-9]+$") then
			local bag = MovAny:GetBagInContainerFrame(f)
			fn = bag:GetName()
		end
		
		MovAny.pendingFrames[fn] = MovAny:GetFrameOptions(fn)
		if not MovAny:IsProtected(f) or not InCombatLockdown() then
			MovAny:SyncFrames()
		end
	end
end

function MovAny.hSetScale(f, ...)
	if f.MAScaled then
		local fn = f:GetName()
		
		if string.match(fn, "^ContainerFrame[0-9]+$") then
			local bag = MovAny:GetBagInContainerFrame(f)
			fn = bag:GetName()
		end
		
		MovAny.pendingFrames[fn] = MovAny:GetFrameOptions(fn)
		if not MovAny:IsProtected(f) or not InCombatLockdown() then
			MovAny:SyncFrames()
		end
	end
end

function MovAny:LockScale( f )
	if f.SetScale and not f.MAScaleLocked then
		--dbg("Locking scale on "..f:GetName())
		if not f.MAScaleHook then
			-- the following doesnt work. it needs to be hooked through the metatable somehow, these hooksecurefunc's never fires
			if f.SetWidth then
				hooksecurefunc(f, "SetWidth", MovAny.hSetWidth)
			end
			if f.SetHeight then
				hooksecurefunc(f, "SetHeight", MovAny.hSetHeight)
			end
			if f.SetScale then
				hooksecurefunc(f, "SetScale", MovAny.hSetScale)
			end
			f.MAScaleHook = true
		end
	end
end

function MovAny:UnlockScale( f )
	f.MAScaleLocked = nil
end
]]

function MovAny.hSetScale(f, ...)
	if f.MAScaled then
		--dbg(f:GetName()..":SetScale intercepted, locked scale: "..f.MAScaled)
		local fn = f:GetName()
		
		if string.match(fn, "^ContainerFrame[1-9][0-9]*$") then
			local bag = MovAny:GetBagInContainerFrame(f)
			fn = bag:GetName()
		end
		
		if MovAny:IsProtected(f) and InCombatLockdown() then
			MovAny.pendingFrames[fn] = MovAny:GetFrameOptions(fn)
			MovAny:SyncFrames()
		else
			MovAny:Rescale(f, f.MAScaled)
		end
	end
end

function MovAny:LockScale( f )
	if f.SetScale and not f.MAScaled then
		local meta = getmetatable(f).__index
		if not meta.MAScaleHook then
			if meta.SetScale then
				hooksecurefunc(meta, "SetScale", MovAny.hSetScale)
			end
			meta.MAScaleHook = true
		end
		f.MAScaled = f:GetScale()
	end
end

function MovAny:UnlockScale( f )
	f.MAScaled = nil
end

function MovAny:Rescale(f, scale)
	MovAny:UnlockScale(f)
	f:SetScale(scale)
	MovAny:LockScale(f)
end

function MovAny:HookFrame(fn, f, dontUnanchor)
	if not f then
		f = _G[fn]
	end
	if not f then
		return
	end
	
	if not self:IsValidObject(f) then
		return
	end
	
	--dbg("Hooking frame: "..fn)
	local opt = self:GetFrameOptions(fn, true, true)
	if opt.name == nil then
		opt.name = fn
	end
	
	if f.OnMAHook and f.OnMAHook(f) ~= nil then
		return
	end
	
	if opt.disabled then
		opt.disabled = nil
	end
	--f.MAOpts = opt
	
	if not opt.orgPos then
		MovAny:StoreOrgPoints(f, opt)
	end
	
	if not dontUnanchor and not self.NoUnanchorRelatives[fn] then
		self:UnanchorRelatives(f, opt)
	end
	
	if self.DetachFromParent[fn] and not self.NoReparent[fn] and not f.MAOrgParent then
		f.MAOrgParent = f:GetParent()
		f:SetParent(_G[ self.DetachFromParent[fn] ])
		--self:LockParent(f)
	end
	
	if f.OnMAPostHook and f.OnMAPostHook(f) ~= nil then
		return
	end
	
	return opt
end

-- XXX: verify that frame is properly hooked instead of just checking stored options?
function MovAny:IsModified( fn )
	if fn == nil then
		return
	end
	local opt = self:GetFrameOptions(fn)
	if opt and (opt.pos or opt.hidden or opt.scale ~= nil or opt.alpha ~= nil or opt.frameStrata ~= nil or
	   opt.disableLayerArtwork ~= nil or opt.disableLayerBackground ~= nil or opt.disableLayerBorder ~= nil or opt.disableLayerHighlight ~= nil or opt.disableLayerOverlay ~= nil) then
		return true
	end
	return
end

function MovAny:IsFrameHidden(fn, opt)
	if fn == nil then
		return
	end
	opt = opt or self:GetFrameOptions(fn)
	if opt and opt.hidden then
		return true
	end
	return
end

function MovAny:StoreOrgPoints(f, opt)
	local np = f:GetNumPoints()
	if np == 1 then
		opt.orgPos = self:GetSerializedPoint(f)
	elseif np > 1 then
		opt.orgPos = {}
		for i = 1, np, 1 do
			opt.orgPos[i] = self:GetSerializedPoint(f, i)
		end
	end
	if not opt.orgPos then
		if f == TargetFrameSpellBar then
			opt.orgPos = {"BOTTOM", "TargetFrame", "BOTTOM", -15, 10}
		elseif f == FocusFrameSpellBar then
			opt.orgPos = {"BOTTOM", "FocusFrame", "BOTTOM", 0, 0}
		elseif f == VehicleMenuBarHealthBar then
			opt.orgPos = {"BOTTOMLEFT", "VehicleMenuBarArtFrame", "BOTTOMLEFT", 119, 3}
		elseif f == VehicleMenuBarPowerBar then
			opt.orgPos = {"BOTTOMRIGHT", "VehicleMenuBarArtFrame", "BOTTOMRIGHT", -119, 3}
		elseif f == VehicleMenuBarLeaveButton then
			opt.orgPos = {"BOTTOMRIGHT", "VehicleMenuBar", "BOTTOMRIGHT", 177, 15}
		--[[
		elseif f == LFDDungeonReadyDialog then
			opt.orgPos = {"TOP", "UIParent", "TOP", 0, -135}
		elseif f == LFDDungeonReadyPopup then
			opt.orgPos = {"TOP", "UIParent", "TOP", 0, -135}
		elseif f == LFDDungeonReadyStatus then
		]]
		else
			--dbg("Unable to generate restore point for "..f:GetName()..". OrgPos set to default")
			opt.orgPos = {"TOP", "UIParent", "TOP", 0, -135}
		end
	end
end

function MovAny:RestoreOrgPoints(f, opt, readOnly)
	--dbg("Restoring point to "..f:GetName().."")
	f:ClearAllPoints()
	
	if opt then -- and not opt.UIPanelWindows
		if type(opt.orgPos) == "table" then
			if type(opt.orgPos[1]) == "table" then
				for i,v in pairs(opt.orgPos) do
					f:SetPoint(unpack(v))
				end
			else
				f:SetPoint(unpack(opt.orgPos))
			end
		end
		if not readOnly then
			opt.orgPos = nil
		end
	end
end

function MovAny:GetFirstOrgPoint(opt)
	if opt then -- and not opt.UIPanelWindows
		if type(opt.orgPos) == "table" then
			if type(opt.orgPos[1]) == "table" then
				return opt.orgPos[1]
			else
				return opt.orgPos
			end
		end
	end
end

function MovAny:GetSerializedPoint(f, num)
	num = num or 1
	--dbg("GetSerializedPoint"..(f.GetName and ": "..f:GetName() or ""))
	local point, rel, relPoint, x, y = f:GetPoint(num)
	if point then
		if rel and rel.GetName and rel:GetName() ~= "" then
			rel = rel:GetName()
		else
			rel = "UIParent"
		end
		--[[
		if f.GetEffectiveScale then
			x = x / f:GetEffectiveScale()
			y = y / f:GetEffectiveScale()
		else
			x = x / UIParent:GetEffectiveScale()
			y = y / UIParent:GetEffectiveScale()
		end
		--]]
		return {point, rel, relPoint, x, y}
	end
	return nil
end

function MovAny:GetRelativePoint(o, f, lockRel)
	if not o then
		o = {"BOTTOMLEFT", UIParent, "BOTTOMLEFT"}
	end
	local rel = o[2]
	if rel == nil then
		rel = UIParent
	end
	if type(rel) == "string" then
		rel = _G[rel]
	end
	if not rel then
		return
	end
	
	local point = o[1]
	local relPoint = o[3]
	
	if not lockRel then
		local newRel = self:ForcedDetachFromParent(f:GetName())
		if newRel then
			rel = _G[newRel]
			point = "BOTTOMLEFT"
			relPoint = "BOTTOMLEFT"
		end
		if not rel then
			return
		end
	end
	
	local rX, rY, pX, pY
	
	if rel:GetLeft() ~= nil then
		if relPoint == "TOPRIGHT" then
			rY = rel:GetTop()
			rX = rel:GetRight()
		elseif relPoint == "TOPLEFT" then
			rY = rel:GetTop()
			rX = rel:GetLeft()
		elseif relPoint == "TOP" then
			rY = rel:GetTop()
			rX = (rel:GetRight() + rel:GetLeft()) / 2
		elseif relPoint == "BOTTOMRIGHT" then
			rY = rel:GetBottom()
			rX = rel:GetRight()
		elseif relPoint == "BOTTOMLEFT" then
			rY = rel:GetBottom()
			rX = rel:GetLeft()
		elseif relPoint == "BOTTOM" then
			rY = rel:GetBottom()
			rX = (rel:GetRight() + rel:GetLeft()) / 2
		elseif relPoint == "CENTER" then
			rY = (rel:GetTop() + rel:GetBottom()) / 2
			rX = (rel:GetRight() + rel:GetLeft()) / 2
		elseif relPoint == "LEFT" then
			rY = (rel:GetTop() + rel:GetBottom()) / 2
			rX = rel:GetLeft()
		elseif relPoint == "RIGHT" then
			rY = (rel:GetTop() + rel:GetBottom()) / 2
			rX = rel:GetRight()
		else
			return
		end
		
		if rel.GetEffectiveScale then
			rY = rY * rel:GetEffectiveScale()
			rX = rX * rel:GetEffectiveScale()
		else
			rY = rY * UIParent:GetEffectiveScale()
			rX = rX * UIParent:GetEffectiveScale()
		end
	end
	
	if f:GetLeft() ~= nil then
		if point == "TOPRIGHT" then
			pY = f:GetTop()
			pX = f:GetRight()
		elseif point == "TOPLEFT" then
			pY = f:GetTop()
			pX = f:GetLeft()
		elseif point == "TOP" then
			pY = f:GetTop()
			pX = (f:GetRight() + f:GetLeft()) / 2
		elseif point == "BOTTOMRIGHT" then
			pY = f:GetBottom()
			pX = f:GetRight()
		elseif point == "BOTTOMLEFT" then
			pY = f:GetBottom()
			pX = f:GetLeft()
		elseif point == "BOTTOM" then
			pY = f:GetBottom()
			pX = (f:GetRight() + f:GetLeft()) / 2
		elseif point == "CENTER" then
			pY = (f:GetTop() + f:GetBottom()) / 2
			pX = (f:GetRight() + f:GetLeft()) / 2
		elseif point == "LEFT" then
			pY = (f:GetTop() + f:GetBottom()) / 2
			pX = f:GetLeft()
		elseif point == "RIGHT" then
			pY = (f:GetTop() + f:GetBottom()) / 2
			pX = f:GetRight()
		else
			return
		end
		
		if f.GetEffectiveScale then
			pY = pY * f:GetEffectiveScale()
			pX = pX * f:GetEffectiveScale()
		else
			pY = pY * UIParent:GetEffectiveScale()
			pX = pX * UIParent:GetEffectiveScale()
		end
	end
	
	if rY ~= nil and rX ~= nil and pY ~= nil and pX ~= nil then
		rX = pX - rX
		rY = pY - rY
		
		if f.GetEffectiveScale then
			rY = rY / f:GetEffectiveScale()
			rX = rX / f:GetEffectiveScale()
		else
			rY = rY / UIParent:GetEffectiveScale()
			rX = rX / UIParent:GetEffectiveScale()
		end
	else
		rX = 0
		rY = 0
	end
	
	return {point, rel:GetName(), relPoint, rX, rY}
end

function MovAny:AddFrameToMovableList( fn, helpfulName, default )
	if not self:GetFrame(fn) then
		if helpfulName == nil then
			helpfulName = fn
		end
		
		local opts = {}
		opts.name = fn
		opts.helpfulName = helpfulName
		opts.cat = self.customCat

		opts.idx = self.nextFrameIdx
		self.nextFrameIdx = self.nextFrameIdx + 1

		tinsert(self.frames, opts)
		self.framesCount = self.framesCount + 1

		if default == 2 then
			opts.default = true
			self.defFrames[ opts.name ] = opts
		else
			if default ~= 1 then
				tinsert(MoveAnything_CustomFrames, opts)
				self.guiLines = -1
			end
		end
		if self.inited then
			self:UpdateGUIIfShown()
		end
	end
end

function MovAny:AttachMover(fn, helpfulName)
	 if self.NoMove[fn] and self.NoScale[fn] and self.NoHide[fn] and self.NoAlpha[fn] then
		string.format(MOVANY.UNSUPPORTED_FRAME, fn)
		return
	 end
	 
	 if self.NoMove[fn] and self.NoScale[fn] and self.NoAlpha[fn] then
		maPrint(string.format(MOVANY.FRAME_VISIBILITY_ONLY, fn))
		return
	 end

	local f = _G[fn]
	
	if self.MoveOnlyWhenVisible[fn] and (f == nil or not f:IsShown()) then
		maPrint(string.format(MOVANY.ONLY_WHEN_VISIBLE, fn))
		return
	end
	
	if self:ErrorNotInCombat(f) then
		return
	end

	if not self:GetMoverByFrameName(fn) then
		if self.lRunOnceBeforeInteract[fn] then
			self.lRunOnceBeforeInteract[fn]()
			self.lRunOnceBeforeInteract[fn] = nil
		end
		if self.lRunBeforeInteract[fn] and self.lRunBeforeInteract[fn]() then
			return
		end
		local created = nil
		local handled = nil
		
		if self.lCreateBeforeInteract[fn] and _G[fn] == nil then
			CreateFrame("Frame", fn, UIParent, self.lCreateBeforeInteract[fn])
			created = true
		end
		f = _G[fn]
		
		self.lastFrameName = fn
		if self:IsValidObject(f) then
			local mover = self:GetAvailableMover()
			if f.OnMAOnAttach then
				f.OnMAOnAttach(f, mover)
			end
			self:AddFrameToMovableList(fn, helpfulName)
			if self:HookFrame(fn) then
				if self:AttachMoverToFrame(mover, f) then
					handled = true
					mover.createdTagged = created
					if f.OnMAPostAttach then
						f.OnMAPostAttach(f, mover)
					end
					self:UpdateGUIIfShown()
				end
			end
		end
		
		if self.lRunAfterInteract[fn] then
			self.lRunAfterInteract[fn](handled)
		end
		return true
	end
end

function MovAny:GetAvailableMover()
	local f
	for id = 1, 1000000, 1 do
		f = _G[self.moverPrefix..id]
		if not f then
			f = CreateFrame("Frame", self.moverPrefix..id, UIParent, "MAMoverTemplate")
			f:SetID(id)
			break
		end
		if not f.tagged then
			break
		end
	end
	
	if f then
		tinsert(self.movers, f)
		return f
	end
end

function MovAny:GetDefaultFrameParent(f)
	local c = f
	while c and c ~= UIParent and c ~= nil do
		if c.MAParent then
			return c.MAParent
			--c = c.MAParent
		end
		if c.GetName and c:GetName() ~= nil and c:GetName() ~= "" then
			local m = string.match(c:GetName(),"^ContainerFrame[1-9][0-9]*$")
			if m then
				local bag = self:GetBagInContainerFrame(_G[ m ])
				return _G[ bag:GetName() ]
			end
			
			local transName = self:Translate(c:GetName(),true,true)

			if self:GetFrameOptions(transName) ~= nil then
				return _G[ transName ]
			else
				local frame = self:GetFrame(transName)
				if frame then
					return _G[frame.name]
				end
			end
		end
		c = c:GetParent()
	end
	return nil
end

function MovAny:GetTopFrameParent(f)
	local c = f
	local l = nil
	local ln
	local n
	while c and c ~= UIParent do
		if c:IsToplevel() then
			n = c:GetName()
			if n ~= nil and n ~= "" then
				return c
			elseif ln ~= nil then
				return ln
			else
				maPrint(MOVANY.NO_NAMED_FRAMES_FOUND)
				return nil
			end
		end
		l = c
		n = c:GetName()
		if n ~= nil and n ~= "" then
			ln = c
		end
		c = c:GetParent()
	end
	if c == UIParent then
		return l
	end
	return nil
end

function MovAny:ToggleMove( fn )
	local ret = nil
	if self:GetMoverByFrameName( fn ) then
		ret = self:StopMoving( fn )
	else
		ret = self:AttachMover( fn )
	end
	
	self.lastFrameName = fn
	self:UpdateGUIIfShown(true)
	return ret
end

function MovAny:ToggleHide( fn )
	local ret = nil
	if self:IsFrameHidden(fn) then
		ret = self:ShowFrame(fn)
	else
		ret = self:HideFrame(fn)
	end
	
	self.lastFrameName = fn
	self:UpdateGUIIfShown(true)
	return ret
end

--X: bindings
function MovAny:SafeMoveFrameAtCursor()
	local obj = GetMouseFocus()
	while 1 == 1 and obj do
		while 1 == 1 and obj do
			if self:IsMAFrame(obj:GetName()) then
				if self:IsMover(obj:GetName()) then
					if obj.tagged then
						obj = obj.tagged
					else
						return
					end
				elseif not self:IsValidObject(obj, true) then
					obj = obj:GetParent()
					if not obj or obj == UIParent then
						return
					end
				else
					break
				end
			else
				break
			end
		end
		local transName = self:Translate(obj:GetName(), 1)

		if transName ~= obj:GetName() then
			self:ToggleMove(transName)
			break
		end
		
		local p = obj:GetParent()
		-- check for minimap button
		if (p == MinimapBackdrop or p == Minimap or p == MinimapCluster) and obj ~= Minimap then
			self:ToggleMove(obj:GetName())
			break
		end

		local objTest = self:GetDefaultFrameParent(obj)

		if objTest then
			self:ToggleMove(objTest:GetName())
			break
		end

		objTest = self:GetTopFrameParent(obj)
		if objTest then
			self:ToggleMove(objTest:GetName())
			break
		end

		if obj and obj ~= WorldFrame and obj ~= UIParent and obj.GetName then
			self:ToggleMove(obj:GetName())
		end
		break
	end

	self:UpdateGUIIfShown(true)
end

function MovAny:MoveFrameAtCursor()
	local obj = GetMouseFocus()
	if self:IsMAFrame(obj:GetName()) then
		if self:IsMover(obj:GetName()) and obj.tagged then
			obj = obj.tagged
		elseif not self:IsValidObject(obj) then
			return
		end
	end
	if obj and obj ~= WorldFrame and obj ~= UIParent and obj:GetName() then
		self:ToggleMove(obj:GetName())
	end
	
	self:UpdateGUIIfShown(true)
end

function MovAny:SafeHideFrameAtCursor()
	local obj = GetMouseFocus()

	while 1 do
		if self:IsMAFrame(obj:GetName()) then
			if self:IsMover(obj:GetName()) and obj.tagged then
				obj = obj.tagged
			elseif not self:IsValidObject(obj, true) then
				obj = obj:GetParent()
			end
		end
		local transName = self:Translate(obj:GetName(), 1)
		if transName ~= obj:GetName() then
			--dbg("Hiding translated "..transName)
			self:ToggleHide(transName)
			break
		end
		local objTest = self:GetDefaultFrameParent(obj)
		if objTest then
			--dbg("Hiding default "..objTest:GetName())
			self:ToggleHide(objTest:GetName())
			break
		end
		objTest = self:GetTopFrameParent(obj)
		if objTest then
			--dbg("Hiding top frame "..objTest:GetName())
			self:AddFrameToMovableList(objTest:GetName(), nil)
			self:ToggleHide(objTest:GetName())
			break
		end
		if obj and obj ~= WorldFrame and obj ~= UIParent then
			--dbg("Hiding "..obj:GetName())
			self:AddFrameToMovableList(obj:GetName(), nil)
			self:ToggleHide(obj:GetName())
			break
		end
		break
	end
	
	self:UpdateGUIIfShown(true)
end

function MovAny:HideFrameAtCursor()
	local obj = GetMouseFocus()
	if self:IsMAFrame(obj:GetName()) then
		if self:IsMover(obj:GetName()) and obj.tagged then
			obj = obj.tagged
		else
			return
		end
	end
	if obj and obj ~= WorldFrame and obj ~= UIParent then
		self:ToggleHide(obj:GetName())
	end
	
	self:UpdateGUIIfShown(true)
end

function MovAny:SafeResetFrameAtCursor()
	local obj = GetMouseFocus()
	local fn = obj:GetName()

	while 1 do
		if fn and self.frameOptions[fn] then
			self:ResetFrameConfirm(fn)
			break
		end
		if self:IsMAFrame(fn) then
			if self:IsMover(fn) and obj.tagged then
				obj = obj.tagged
				self:ResetFrameConfirm(obj:GetName())
				break
			elseif not self:IsValidObject(obj, true) then
				obj = obj:GetParent()
			end
			fn = obj:GetName()
		end
		
		local transName = self:Translate(fn, 1)
		if transName ~= fn and self.frameOptions[fn] then
			self:ResetFrameConfirm(fn)
			break
		end
		local objTest = self:GetDefaultFrameParent(obj)
		if objTest and self.frameOptions[ objTest:GetName() ] then
			self:ResetFrameConfirm(objTest:GetName())
			break
		end
		objTest = self:GetTopFrameParent(obj)
		if objTest and self.frameOptions[ objTest:GetName() ] then
			self:ResetFrameConfirm(objTest:GetName())
			break
		end
		if obj and obj ~= WorldFrame and obj ~= UIParent and self.frameOptions[fn] then
			self:ResetFrameConfirm(fn)
			break
		end
		break
	end
end

function MovAny:ResetFrameAtCursor()
	local obj = GetMouseFocus()
	if self:IsMAFrame(obj:GetName()) then
		if self:IsMover(obj:GetName()) and obj.tagged then
			obj = obj.tagged
		else
			return
		end
	end
	
	if InCombatLockdown() and MovAny:IsProtected(obj) then
		self:ErrorNotInCombat(obj)
		return
	end

	local fn = obj:GetName()

	if self.frameOptions[fn] then
		self:ResetFrameConfirm(fn)
	end
end

function MovAny:IsMover(fn)
	if fn ~= nil and string.match(fn, "^"..self.moverPrefix.."[0-9]+$") ~= nil then
		return true
	end
end

function MovAny:IsMAFrame(fn)
	if fn ~= nil and (string.match(fn, "^MoveAnything") ~= nil or string.match(fn, "^MA") ~= nil) then
		return true
	end
end

function MovAny:IsContainer(fn)
	if type(fn) == "string" and string.match(fn, "^ContainerFrame[1-9][0-9]*$") then
		return true
	end
end

function MovAny:Translate(f,secondary,nofirst)
	if not nofirst and self.lTranslate[ f ] then
		--dbg("primary translation: "..self.lTranslate[ f ])
		return self.lTranslate[ f ]
	end

	if secondary and self.lTranslateSec[ f ] then
		--dbg("secondary translation: "..self.lTranslateSec[ f ])
		return self.lTranslateSec[ f ]
	end

	if f == "last" then
		return MovAny.lastFrameName
	else
		return f
	end
end

function MovAny:GetMoverByFrameName( fn )
	if not fn then
		return
	end
	for i, m in ipairs(self.movers) do
		if type(m) ~= "nil" and m:IsShown() and m.tagged == _G[fn] then
			return m
		end
	end
	return nil
end

function MovAny:AttachMoverToFrame( mover, f )
	--[[
	if mover.tagged then
		self:DetachMover(mover)
	end
	]]--
	self:UnlockPoint(f)

	local listOptions = self:GetFrame(f:GetName())
	local frameOptions = self:GetFrameOptions(f:GetName())

	mover.helpfulName = listOptions.helpfulName

	if f.OnMAMoving then
		if not f:OnMAMoving() then
			self:DetachMover(mover)
			return
		end
	end

	local x, y
	x = 0
	y = 0
	if f:GetLeft() == nil and not f:IsShown() then
		f:Show()
		f:Hide()
	end
	
	--[[
	if f:GetLeft() == nil then
		maPrint(string.format(MOVANY.FRAME_UNPOSITIONED, f:GetName()))
		self:DetachMover(mover)
		return
	end
	]]
	
	mover.attaching = true
	mover.dontUpdate = nil
	
	mover:SetClampedToScreen(f:IsClampedToScreen())
	--[[
	if not f:IsShown() then
		mover.taggedShown = true
		f:Show()
	end
	]]
	
	local opt = self:GetFrameOptions(f:GetName())
	if not opt.pos then
		opt.pos = self:GetRelativePoint(self:GetFirstOrgPoint(opt), f)
	end
	
	mover:ClearAllPoints()
	mover:SetPoint("CENTER", f, "CENTER")

	mover:SetWidth( f:GetWidth() * MAGetScale( f , 1 ) / UIParent:GetScale() )
	mover:SetHeight( f:GetHeight()  * MAGetScale( f , 1 ) / UIParent:GetScale() )

	local p = self:GetRelativePoint({"BOTTOMLEFT", UIParent, "BOTTOMLEFT"}, mover)
	mover:ClearAllPoints()
	mover:SetPoint(unpack(p))

	if f.GetFrameLevel then
		mover:SetFrameLevel( f:GetFrameLevel() + 1 )
	end

	--dbg("  attaching "..f:GetName().." to "..mover:GetName())
	f:ClearAllPoints()
	f:SetPoint( "BOTTOMLEFT", mover, "BOTTOMLEFT", 0, 0 )
	
	if not self.NoMove[fn] then
		f.orgX = x
		f.orgY = y
	end
	
	mover.tagged = f
	
	local label = _G[ mover:GetName().."BackdropInfoLabel"]
	label:Hide()
	label:ClearAllPoints()
	label:SetPoint("CENTER", label:GetParent(), "CENTER", 0, 0)
	
	mover:Show()
	
	mover.attaching = nil
end

function MovAny:DetachMover( mover )
	if mover.tagged and not mover.attaching then
		if not mover.dontUpdate then
			self:MoverUpdatePosition( mover )
		end
		
		local f = mover.tagged
		
		self:ApplyPosition(f, self:GetFrameOptions(f:GetName()))
		--[[
		if mover.taggedShown then
			f:Hide()
		end
		]]
		if mover.createdTagged then
			mover.tagged:Hide()
		end
		if f.OnMAOnDetach then
			f.OnMAOnDetach(f, mover)
		end
	end
	
	mover:Hide()
	mover.tagged = nil
	mover.attaching = nil
	mover.infoShown = nil
	
	local found
	
	for i, m in ipairs(self.movers) do
		if m == mover then
			tremove(self.movers, i)
		end
	end
	
	if self.currentMover == mover then
		self:NudgerChangeMover(1)
	else
		self:NudgerFrameRefresh()
	end
end

function MovAny:StopMoving(fn)
	local mover = self:GetMoverByFrameName(fn)
	if mover and not self:ErrorNotInCombat(_G[fn]) then
		self:DetachMover(mover)
		self:UpdateGUIIfShown()
	end
end

function MovAny:ResetFrameConfirm(fn)
	local f = _G[fn]
	if InCombatLockdown() and self:IsProtected(f) then
		self:ErrorNotInCombat(f)
		return
	end
	if self.resetConfirm == fn and self.resetConfirmTime + 5 >= time() then
		self.resetConfirm = nil
		maPrint(string.format(MOVANY.RESETTING_FRAME, fn))
		self:ResetFrame(fn)
		return true
	else
		self.resetConfirm = fn
		self.resetConfirmTime = time()
		maPrint(string.format(MOVANY.RESET_FRAME_CONFIRM, fn))
	end
end

function MovAny:ResetFrame(f, dontUpdate, readOnly)
	if not f then
		return
	end
	local fn
	if type(f) == "string" then
		fn = f
		f = _G[fn]
	elseif f and f.GetName then
		fn = f:GetName()
	end
	if not fn then
		return
	end
	
	if self:ErrorNotInCombat(f) or (InCombatLockdown() and f.UMFP) then
		return
	end
	
	self:StopMoving(fn)
	
	self.lastFrameName = fn
	
	if not f then
		if not readOnly then
			self:ClearFrameOptions(fn)
		end
		if not dontUpdate then
			self:UpdateGUIIfShown(true)
		end
		return
	end

	local opt = self:GetFrameOptions(fn, true)
	if opt == nil then
		opt = {}
	end
	if not opt.disabled then
		if f.OnMAPreReset then
			f.OnMAPreReset(f, opt)
		end

		local width = nil
		local height = nil
		if opt then
			width = opt.originalWidth
			height = opt.originalHeight
		end

		self:ResetAll(f, opt, readOnly)
		
		if width then
			f:SetWidth(width)
		end
		if height then
			f:SetHeight(height)
		end
	end
	f.attachedChildren = nil

	if not readOnly then
		self:ClearFrameOptions(fn)
	end
	
	if f.OnMAPostReset then
		f.OnMAPostReset(f, readOnly)
	end
	
	if not dontUpdate then
		self:UpdateGUIIfShown(true)
	end
end

function MovAny:ToggleGUI()
	if MAOptions:IsShown() then
		MAOptions:Hide()
	else
		MAOptions:Show()
	end
end

function MovAny:OnMoveCheck(button)
	if not self:ToggleMove(self.frames[ button:GetParent().idx ].name) then
		button:SetChecked(nil)
		return
	end
end

function MovAny:OnHideCheck(button)
	if not self:ToggleHide(self.frames[ button:GetParent().idx ].name) then
		button:SetChecked(nil)
		return
	end
end

function MovAny:OnResetCheck(button)
	local f =  _G[self.frames[ button:GetParent().idx ].name]
	if f then
		if self:ErrorNotInCombat(f) then
			return
		end
	else
		f = self.frames[ button:GetParent().idx ].name
	end
	self:ResetFrame(f)
end

function MovAny:HideFrame(f, readOnly)
	local fn
	if type(f) == "string" then
		fn = f
		f = _G[fn]
	end
	if not fn then
		fn = f:GetName()
	end

	local opt
	if readOnly then
		opt = {}
	else
		opt = self:GetFrameOptions(fn, nil, true)
		opt.hidden = true
	end
	if not f then
		return true
	end
	
	if not self:IsValidObject(f) or not self:HookFrame( fn ) or self:ErrorNotInCombat(f) then
		return
	end
	
	f.MAWasShown = f:IsShown()
	
	if f.GetAttribute then
		opt.unit = f:GetAttribute("unit")
		if opt.unit then
			f:SetAttribute("unit", nil)
		end
	end
	
	if self.HideList[fn] then
		for hIndex, hideEntry in pairs(self.HideList[fn]) do
			local val = _G[hideEntry[1]]
			local hideType
			for i = 2, table.getn(hideEntry) do
				hideType = hideEntry[ i ]
				if type(hideType) == "function" then
					hideType(nil)
				elseif hideType == "DISABLEMOUSE" then
					val:EnableMouse(nil)
				elseif hideType == "FRAME" then
					self:LockVisibility(val)
				elseif hideType == "WH" then
					self:StopMoving(fn)
					val:SetWidth(1)
					val:SetHeight(1)
				else
					val:DisableDrawLayer( hideType )
				end
			end
		end
	elseif self.HideUsingWH[fn] then
		self:StopMoving(fn)
		f:SetWidth(1)
		f:SetHeight(1)
		self:LockVisibility(f)
	else
		self:LockVisibility(f)
	end
	if f.OnMAHide then
		f.OnMAHide(f, true)
	end
	
	return true
end

function MovAny:ShowFrame( f, readOnly )
	local fn
	if type(f) == "string" then
		fn = f
		f = _G[ f ]
	end
	if not fn then
		fn = f:GetName()
	end
	
	local opt = self:GetFrameOptions(fn)
	if readOnly == nil and opt then
		opt.hidden = nil
		opt.unit = nil
	end
	if not f then
		self:VerifyFrameData(fn)
		return true
	end
	if not self:IsValidObject(f) or not self:HookFrame(fn) or self:ErrorNotInCombat(f) then
		return
	end
	if opt.unit and f.SetAttribute then
		f:SetAttribute("unit", opt.unit)
	end
	if self.HideList[fn] then
		for hIndex, hideEntry in pairs(self.HideList[fn]) do
			local val = _G[hideEntry[1]]
			local hideType
			for i = 2, table.getn(hideEntry) do
				hideType = hideEntry[i]
				if type(hideType) == "function" then
					hideType(true)
				elseif hideType == "DISABLEMOUSE" then
					val:EnableMouse(true)
				elseif hideType == "FRAME" then
					self:UnlockVisibility(val)
				elseif hideType == "WH" then
					if type(opt.originalWidth) == "number" then
						val:SetWidth(opt.originalWidth)
					end
					if type(opt.originalHeight) == "number" then
						val:SetHeight(opt.originalHeight)
					end
				else
					val:EnableDrawLayer(hideType)
				end
			end
		end
		self:ApplyLayers(f, opt)
	elseif self.HideUsingWH[fn] then
		if type(opt.originalWidth) == "number" then
			f:SetWidth(opt.originalWidth)
		end
		if type(opt.originalHeight) == "number" then
			f:SetHeight(opt.originalHeight)
		end
		self:UnlockVisibility(f)
	else
		self:UnlockVisibility(f)
	end
	if f.OnMAHide then
		f.OnMAHide(f, nil)
	end
	self:VerifyFrameData(fn)
	return true
end

function MovAny:OnCheckCharacterSpecific( button )
	if InCombatLockdown() then
		button:SetChecked(not button:GetChecked())
		maPrint(MOVANY.PROFILES_CANT_SWITCH_DURING_COMBAT)
		return
	end
	local oldName = self:GetProfileName()
	if button:GetChecked() then
		MoveAnything_UseCharacterSettings = true
	else
		MoveAnything_UseCharacterSettings = nil
	end
	local newProfile = self:GetProfileName()
	
	local i = 0
	if MoveAnything_CharacterSettings[newProfile] == nil then
		MoveAnything_CharacterSettings[newProfile] = {}
	else
		for v in pairs(MoveAnything_CharacterSettings[newProfile]) do 
			i = i + 1
		end
	end
	if i == 0 then
		self:CopySettings(oldName, newProfile)
	end
	--MovAny:CleanProfile(oldName)
	self:UpdateProfile()
	
	local a = {}
	for i, o in pairs(MoveAnything_CharacterSettings) do
		tinsert(a, i)
	end
	table.sort(a, function(o1,o2)
		return o1:lower() < o2:lower()
	end)
	local s = ""
	for i, o in pairs(a) do
		s = s.."  "..o.."\n"
	end
	MAOptCharacterSpecific.tooltipText = "Use character specific settings\n\n Current profile: "..MovAny.GetProfileName().."\n\n Profiles: \n"..s.."\n\n Cmds:\n   /movelist\n   /moveimport\n   /moveexport\n   /movedelete"
end

function MovAny:OnCheckToggleCategories( button )
	local state = button:GetChecked()
	if state then
		MADB.collapsed = true
	else
		MADB.collapsed = nil
	end
	for i, v in pairs(self.cats) do
		v.collapsed = state
	end
	
	self:UpdateGUIIfShown(true)
end

function MovAny:OnCheckToggleModifiedFramesOnly( button )
	local state = button:GetChecked()
	if state then
		MADB.modifiedFramesOnly = true
	else
		MADB.modifiedFramesOnly = nil
	end
	
	self:UpdateGUIIfShown(true)
end

function MovAny:MoverUpdatePosition( mover )
	--dbg("MovAny:MoverUpdatePosition \""..mover:GetName().."\"  \""..mover.tagged:GetName().."\"")
	local x, y, parent
	x = nil
	y = nil
	parent = nil
	if mover.tagged  then
		local f = mover.tagged
		if self.NoMove[ f:GetName() ] then
			return
		end
		local opt = self:GetFrameOptions(f:GetName())
		opt.pos = self:GetRelativePoint(opt.pos or self:GetFirstOrgPoint(opt) or {"BOTTOMLEFT", "UIParent", "BOTTOMLEFT"}, f)
		
		if f.OnMAPosition then
			f.OnMAPosition(f)
		end
		
		self:UpdateGUIIfShown()
	end
end

function MovAny:MoverOnSizeChanged( mover )
	if mover.tagged then
		if mover.attaching then
			return
		end
		local s, w, h, f, opt
		f = mover.tagged
		opt = self:GetFrameOptions(f:GetName())
		if self.ScaleWH[ f:GetName() ] then
			if opt.width ~= mover:GetWidth() or opt.height ~= mover:GetHeight() then
				opt.width = mover:GetWidth()
				opt.height = mover:GetHeight()
				self:ApplyScale(f, opt)
				--dbg("MoverSizeChanged WH w: "..numfor(opt.width).." h: "..numfor(opt.height))
			end
		else
			if mover.MASizingAnchor == "LEFT" or mover.MASizingAnchor == "RIGHT" then
				w = mover:GetWidth()
				h = w * (f:GetHeight() / f:GetWidth())
				if h < 8 then
					h = 8
					w = h * (f:GetWidth() / f:GetHeight())
				end
			else
				h = mover:GetHeight()
				w = h * (f:GetWidth() / f:GetHeight())
				if w < 8 then
					w = 8
					h = w * (f:GetHeight() / f:GetWidth())
				end
			end
			s = mover:GetWidth() / f:GetWidth()
			s = s / MAGetScale(f:GetParent(), 1 ) * UIParent:GetScale()
			if s > 0.991 and s < 1 then
				s = 1
			end
			
			if mover.tagged.GetScale and s ~= mover.tagged:GetScale() then
				opt.scale = s
			
				--dbg("MoverSizeChanged w: "..numfor(w).." h: "..numfor(h).." s: "..numfor(s))
				self:ApplyScale(f, opt)
				--self:MoverUpdatePosition(mover)
			end
			mover:SetWidth(w)
			mover:SetHeight(h)
			
			local label = _G[ mover:GetName().."BackdropInfoLabel"]
			label:SetWidth(w+100)
			label:SetHeight(h)
		end
		
		local label = _G[ mover:GetName().."BackdropInfoLabel"]
		label:ClearAllPoints()
		label:SetPoint("TOP", label:GetParent(), "TOP", 0, 0)
		
		local brief, long
		if mover.tagged and MovAny:CanBeScaled(mover.tagged) then
			if MovAny.ScaleWH[mover.tagged:GetName()] then
				brief = "W: "..numfor(mover.tagged:GetWidth()).." H:"..numfor(mover.tagged:GetHeight())
				long = brief
			else
				brief = numfor(mover.tagged:GetScale())
				long = "Scale: "..brief
			end
			label:Show()
			label:SetText(brief)
			if mover == self.currentMover then
				_G[ "MANudgerInfoLabel"]:Show()
				_G[ "MANudgerInfoLabel"]:SetText(long)
			end
		end
		
		label = _G[ mover:GetName().."BackdropMovingFrameName" ]
		label:ClearAllPoints()
		label:SetPoint("TOP", label:GetParent(), "TOP", 0, 20)
		
		self:UpdateGUIIfShown(true)
	end
end

function MovAny:MoverOnMouseWheel(mover, arg1)
	if not mover.tagged or MovAny.NoAlpha[ mover.tagged:GetName() ] then
		return
	end
	local alpha = mover.tagged:GetAlpha()
	if arg1 > 0 then
		alpha = alpha + 0.05
	else
		alpha = alpha - 0.05
	end
	if alpha < 0 then
		alpha = 0
		mover.tagged.alphaAttempts = nil
	elseif alpha > 0.99 then
		alpha = 1
		mover.tagged.alphaAttempts = nil
	elseif alpha > 0.92 then
		if not mover.tagged.alphaAttempts then
			mover.tagged.alphaAttempts = 1
		elseif mover.tagged.alphaAttempts > 2 then
			alpha = 1
			mover.tagged.alphaAttempts = nil
		else
			mover.tagged.alphaAttempts = mover.tagged.alphaAttempts + 1
		end
	else
		mover.tagged.alphaAttempts = nil
	end
	
	alpha = tonumber(numfor(alpha))
	
	local opt = self:GetFrameOptions(mover.tagged:GetName())
	opt.alpha = alpha
	self:ApplyAlpha(mover.tagged, opt)
	
	if opt.alpha == opt.originalAlpha then
		opt.alpha = nil
		opt.originalAlpha = nil
	end
	
	local label = _G[ mover:GetName().."BackdropInfoLabel"]
	label:Show()
	label:SetText(numfor(alpha* 100).."%")
	if mover == self.currentMover then
		_G[ "MANudgerInfoLabel"]:Show()
		_G[ "MANudgerInfoLabel"]:SetText("Alpha:"..numfor(alpha * 100).."%")
	end
	
	self:UpdateGUIIfShown(true)
end

function MovAny:ResetProfile(readOnly)
	for i,v in pairs(self.frameOptions) do
		self:ResetFrame(v.name, true, true)
	end
	self:ReanchorRelatives()
	if not readOnly then
		self.frameOptions = {}
		MoveAnything_CharacterSettings[self:GetProfileName()] = self.frameOptions
	end
	
	self:UpdateGUIIfShown(true)
end

function MovAny:ResetAllFrames(confirm)
	for i,v in pairs(self.frameOptions) do
		self:ResetFrame(v.name, true, true)
	end
	self:ReanchorRelatives()
	
	if MADB.squareMM then
		Minimap:SetMaskTexture("Textures\\MinimapMask")
	end
	
	MoveAnything_UseCharacterSettings = false
	self.frameOptions = {}
	MoveAnything_CharacterSettings = {}
	MoveAnything_CharacterSettings[self:GetProfileName()] = self.frameOptions
	MoveAnything_CustomFrames = {}
	MADB = {}
	MADB.collapsed = true
	MAOptionsToggleCategories:SetChecked(true)
	MovAny:OnCheckToggleCategories(MAOptionsToggleCategories)
	
	self:UpdateGUIIfShown(true)
end

function MovAny:OnShow()
	if MADB.playSound then
		PlaySound("igMainMenuOpen")
	end

	MANudger:Show()
	self:NudgerFrameRefresh()
	self:UpdateGUI()

	for i,v in pairs(self.lEnableMouse) do
		if v and v.EnableMouse and ( not MovAny:IsProtected(v) or not InCombatLockdown()) then
			v:EnableMouse(true)
		end
	end
end

function MovAny:OnHide()
	if MADB.playSound then
		PlaySound("igMainMenuClose")
	end

	if not MADB.alwaysShowNudger then
		MANudger:Hide()
	end

	for i,v in pairs(self.lEnableMouse) do
		if v and v.EnableMouse and ( not MovAny:IsProtected(v) or not InCombatLockdown()) then
			v:EnableMouse(nil)
		end
	end
end

function MovAny:RowTitleClicked(title)
	local o = self.frames[ MAGetParent(title).idx ]

	if o.sep then
		if o.collapsed then
			o.collapsed = nil
		else
			o.collapsed = true
		end

		self:UpdateGUI(1)
	else
		if self.FrameEditor then
			self:FrameEditor(o.name)
		end
	end
end

function MovAny:CountGUIItems()
	local items = 0
	local nextSepItems = 0
	local curSep = nil
	
	if self.searchWord and self.searchWord ~= "" then
		for i, o in pairs(MovAny.frames) do
			if not o.sep and o.cat then
				if (not MADB.dontSearchFrameNames and string.match(string.lower(o.name), self.searchWord)) or (o.helpfulName and string.match(string.lower(o.helpfulName), self.searchWord)) then
					if MADB.modifiedFramesOnly then
						if MovAny:IsModified(o.name) then
							items = items + 1
						end
					else
						items = items + 1
					end
				end
			end
		end
	else
		for i, o in pairs(MovAny.frames) do
			if o.sep then
				if curSep then
					curSep.items = nextSepItems
					nextSepItems = 0
				end
				curSep = o
			else
				if MADB.modifiedFramesOnly then
					if MovAny:IsModified(o.name) then
						nextSepItems = nextSepItems + 1
					end
				else
					nextSepItems = nextSepItems + 1
				end
			end
		end

		if curSep then
			curSep.items = nextSepItems
		end
		
		for i, o in pairs(MovAny.frames) do
			if o.sep then
				if not MADB.modifiedFramesOnly then
					if o.collapsed then
						items = items + 1
					else
						items = items + o.items + 1
					end
				else
					if o.items > 0 then
						if o.collapsed then
							items = items + 1
						else
							items = items + o.items + 1
						end
					end
				end
			end
		end
	end
	self.guiLines = items
	--dbg("GUI line counted: "..items)
end

function MovAny:UpdateGUI(recount)
	if recount or MovAny.guiLines == -1 then
		MovAny:CountGUIItems()
	end
	
	FauxScrollFrame_Update(MAScrollFrame, MovAny.guiLines, MADB.frameListRows, MovAny.SCROLL_HEIGHT)
	local topOffset = FauxScrollFrame_GetOffset(MAScrollFrame)

	local displayList = {}
	
	if MovAny.searchWord and MovAny.searchWord ~= "" then
		local results = {}
		local skip = topOffset
		for i, o in pairs(MovAny.frames) do
			if not o.sep then
				if (not MADB.dontSearchFrameNames and string.match(string.lower(o.name), MovAny.searchWord)) or (o.helpfulName and string.match(string.lower(o.helpfulName), MovAny.searchWord)) then
					if MADB.modifiedFramesOnly then
						if MovAny:IsModified(o.name) then
							tinsert(results, o)
						end
					else
						tinsert(results, o)
					end
				end
			end
		end
		table.sort(results, function(o1,o2)
			return o1.helpfulName:lower() < o2.helpfulName:lower()
		end)
		for i, o in pairs(results) do
			if skip > 0 then
				skip = skip - 1
			else
				tinsert(displayList, o)
			end
		end
		results = nil
	else
		local startOffset = 0
		local hidden = 0
		local shown = 0
		local lastSep = nil
		for i, o in pairs(MovAny.frames) do
			if startOffset == 0 and shown >= topOffset then
				startOffset = topOffset + hidden
				break
			end

			if o.sep then
				lastSep = o
				if MADB.modifiedFramesOnly then
					if o.items == 0 then
						hidden = hidden + 1
					else
						shown = shown + 1
					end
				else
					shown = shown + 1
				end
			else
				if lastSep and lastSep.collapsed then
				elseif MADB.modifiedFramesOnly then
					if lastSep.items > 0 then
						shown = shown + 1
					else
						hidden = hidden + 1
					end
				else
					shown = shown + 1
				end
			end
		end
		
		if startOffset ~= 0 then
			-- X: fix off by one
			if startOffset > 0 then
				startOffset = startOffset + 1
			end
		end
		
		local sepOffset, wtfOffset
		sepOffset = 0
		wtfOffset = 0
		local skip = topOffset
		
		for i=1, MADB.frameListRows, 1 do
			local index = i + sepOffset + wtfOffset

			local o
			-- forward to next shown element
			while 1 do
				if index > MovAny.framesCount then
					--dbg("UpdateGUI - index out of bounds: "..index.." / "..MovAny.framesCount)
					o = nil
					break
				end
				o = MovAny.frames[ index ]
				if o.sep then
					if MADB.modifiedFramesOnly then
						if o.items > 0 then
							if skip > 0 then
								index = index + 1
								wtfOffset = wtfOffset + 1
								skip = skip -1
							else
								if o.sep and o.collapsed then
									sepOffset = sepOffset + o.items
								end
								break
							end
						else
							index = index + 1
							wtfOffset = wtfOffset + 1
						end
					else
						if skip > 0 then
							index = index + 1
							wtfOffset = wtfOffset + 1
							skip = skip -1
						else
							if o.sep and o.collapsed then
								sepOffset = sepOffset + o.items
							end
							break
						end
					end
				elseif o.cat then
					local c = o.cat
					if c.collapsed then
						index = index + 1
						wtfOffset = wtfOffset + 1
					else
						if MADB.modifiedFramesOnly then
							if MovAny:IsModified(o.name) then
								if skip > 0 then
									index = index + 1
									wtfOffset = wtfOffset + 1
									skip = skip -1
								else
									break
								end
							else
								index = index + 1
								wtfOffset = wtfOffset + 1
							end
						else
							if skip > 0 then
								index = index + 1
								wtfOffset = wtfOffset + 1
								skip = skip -1
							else
								break
							end
						end
					end
				else
					--dbg("UpdateGUI - Error: Element neither a frame or category.  index:"..index)
					index = index + 1
					wtfOffset = wtfOffset + 1
				end
			end
			if o then
				tinsert(displayList, o)
			else
				break
			end
		end
	end

	local prefix, move, backdrop, hide
	prefix = "MAMove"
	move = "Move"
	hide = "Hide"
	
	local skip = topOffset

	for i = 1, MADB.frameListRows, 1 do
		local o = displayList[i]
		local row = _G[ prefix..i ]

		if not o then
			row:Hide()
		else
			local fn = o.name
			local opts = MovAny:GetFrameOptions(fn)
			local moveCheck = _G[ prefix..i..move ]
			local hideCheck = _G[ prefix..i..hide ]
			local text, frameNameLabel
			local idx = MovAny:GetFrameIDX(o)
			
			frameNameLabel = _G[ prefix..i.."FrameName" ]
			frameNameLabel.idx = idx
			row.idx = idx
			row.name = o.name
			row:Show()

			
			if o.sep then
				text = _G[ prefix..i.."FrameNameText" ]
				text:Hide()
				text = _G[ prefix..i.."FrameNameHighlight" ]
				text:Show()
				if o.collapsed and o.items > 0 then
					text:SetText("+ "..o.helpfulName)
				else
					text:SetText("   "..o.helpfulName)
				end
				frameNameLabel.tooltipLines = nil
			else
				text = _G[ prefix..i.."FrameNameHighlight" ]
				text:Hide()
				text = _G[ prefix..i.."FrameNameText" ]
				text:Show()
				text:SetText((opts and opts.disabled and "*" or "")..o.helpfulName)
			end

			if fn then
				_G[ prefix..i.."Backdrop" ]:Show()
				
				if MovAny.NoMove[fn] and MovAny.NoScale[fn] and MovAny.NoAlpha[fn] then
					moveCheck:Hide()
				else
					moveCheck:SetChecked(MovAny:GetMoverByFrameName(fn) and 1 or nil)
					moveCheck:Show()
				end
				if MovAny.NoHide[fn] then
					hideCheck:Hide()
				else
					hideCheck:SetChecked(opts and opts.hidden or nil)
					hideCheck:Show()
				end

				if MovAny:IsModified(fn) then
					_G[ prefix..i.."Reset" ]:Show()
				else
					if o.default then
						_G[ prefix..i.."Reset" ]:Hide()
					else
						_G[ prefix..i.."Reset" ]:Show()
					end
				end
			else
				_G[ prefix..i.."Backdrop" ]:Hide()
				moveCheck:Hide()
				hideCheck:Hide()
				_G[ prefix..i.."Reset" ]:Hide()
			end
		end
	end
	
	MAOptionsToggleCategories:SetChecked(MADB.collapsed)
	MAOptionsToggleModifiedFramesOnly:SetChecked(MADB.modifiedFramesOnly)
	
	if MovAny.searchWord and MovAny.searchWord ~= "" then
		MAOptionsFrameNameHeader:SetText(string.format(MOVANY.LIST_HEADING_SEARCH_RESULTS, MovAny.guiLines))
	else
		MAOptionsFrameNameHeader:SetText(MOVANY.LIST_HEADING_CATEGORY_AND_FRAMES)
	end
	MovAny:TooltipHide()
end

function MovAny:UpdateGUIIfShown(recount, dontUpdateEditors)
	if recount then
		self.guiLines = -1
	end
	if MAOptions and MAOptions:IsShown() then
		self:UpdateGUI()
	end
	
	if not dontUpdateEditors then
		for fn, fe in pairs(self.frameEditors) do
			if fe:IsShown() and not fe.updating then
				fe:UpdateEditor()
			end
		end
	end
end

function MovAny:NudgerChangeMover(dir)
	local p
	local first, sel
	local cur = self.currentMover
	local matchNext = false
	
	for i, m in ipairs(self.movers) do
		if not first then
			first = m
		end
		if matchNext then
			self.currentMover = m
			matchNext = nil
			break
		end
		if m == cur then
			if dir < 0 then
				if first == m then
					for i2, m2 in ipairs(self.movers) do
						sel = m2
					end
					self.currentMover = sel
				else
					self.currentMover = p
				end
				break
			else
				matchNext = true
			end
		end
		p = m
	end
	if matchNext then
		self.currentMover = first
	end
	
	self:NudgerFrameRefresh()
end

function MovAny:GetFirstMover()
	for i, m in ipairs(self.movers) do
		if m and m.IsShown and m:IsShown() then
			return m
		end
	end
	return nil
end

function MovAny:MoverOnShow(mover)
	local mn = mover:GetName()
	
	MANudger:Show()
	self.currentMover = mover
	self:NudgerFrameRefresh()
	
	mover.startAlpha = mover.tagged:GetAlpha()
	_G[mn.."Backdrop"]:Show()
	_G[mn.."BackdropMovingFrameName"]:SetText( mover.helpfulName )
	if not mover.tagged or not MovAny:CanBeScaled(mover.tagged) then
		_G[mn.."Resize_TOP"]:Hide()
		_G[mn.."Resize_LEFT"]:Hide()
		_G[mn.."Resize_BOTTOM"]:Hide()
		_G[mn.."Resize_RIGHT"]:Hide()
	else
		_G[mn.."Resize_TOP"]:Show()
		_G[mn.."Resize_LEFT"]:Show()
		_G[mn.."Resize_BOTTOM"]:Show()
		_G[mn.."Resize_RIGHT"]:Show()
	end
	
	_G[ mn.."BackdropInfoLabel"]:SetText("")
	if mover == self.currentMover then
		_G[ "MANudgerInfoLabel"]:SetText("")
	end
end

function MovAny:MoverOnHide()
	local firstMover = self:GetFirstMover()
	if not MADB.alwaysShowNudger and firstMover == nil then
		MANudger:Hide()
	else
		self.currentMover = firstMover
		self:NudgerFrameRefresh()
	end
end

function MovAny:NudgerOnShow()
	if not MADB.alwaysShowNudger then
		local firstMover = self:GetFirstMover()
		if firstMover == nil then
			MANudger:Hide()
			return
		end
	end
	self:NudgerFrameRefresh()
end

function MovAny:NudgerFrameRefresh()
	local labelText = ""
	
	if self.currentMover ~= nil then
		local cur = 0
		for i, m in ipairs(self.movers) do
			cur = cur + 1
			if m == self.currentMover then
				break
			end
		end
		labelText = cur.." / "..#self.movers
		
		local f = self.currentMover.tagged
		if f then
			local fn = f:GetName()
			if fn then
				labelText = labelText.."\n"..fn
				MANudger.idx = MovAny:GetFrame(fn).idx
				if self.NoHide[fn] then
					MANudger_Hide:Hide()
				else
					MANudger_Hide:Show()
				end
			end
		end
	end
	if #self.movers > 1 then
		MANudger_MoverMinus:Show()
		MANudger_MoverPlus:Show()
	else
		MANudger_MoverMinus:Hide()
		MANudger_MoverPlus:Hide()
	end
	MANudgerTitle:SetText(labelText)
end

function MovAny:NudgerOnUpdate()
	local obj = GetMouseFocus()
	local text = ""
	local text2 = ""
	local label = MANudgerMouseOver
	local labelSafe = MANudgerMouseOver
	local name

	if obj and obj ~= WorldFrame and obj:GetName() then
		local objTest = self:GetDefaultFrameParent(obj)
		if objTest then
			name = objTest:GetName()
			if name then
				text = text.."Safe: "..name
			end
		else
			objTest = self:GetTopFrameParent(obj)
			if objTest then
				name = objTest:GetName()
				if name then
					text = text.."Safe: "..objTest:GetName()
				end
			end
		end
	end

	if obj and obj ~= WorldFrame and obj:GetName() then
		name = obj:GetName()
		if name then
			text2 = "Mouseover: "..text2..name
		end
		if obj:GetParent()  and obj:GetParent() ~= WorldFrame and obj:GetParent():GetName() then
			name = obj:GetParent():GetName()
			if name then
				text2 = text2.."\nParent: "..name
			end
			if obj:GetParent():GetParent() and obj:GetParent():GetParent() ~= WorldFrame and obj:GetParent():GetParent():GetName() then
				name = obj:GetParent():GetParent():GetName()
				if name then
					text2 = text2.."\nParent's Parent: "..name
				end
			end
		end
	end

	if not string.find(text2, "MANudger") then
		label:SetText(text2.."\n"..text)
	else
		label:SetText(text)
	end
end

function MovAny:Center(lock)
	local mover = self.currentMover
	if lock == 0 then
		-- Both
		mover:ClearAllPoints()
		mover:SetPoint("CENTER",0,0)
	else
		local x, y
		x = mover:GetLeft()
		y = mover:GetBottom()

		mover:ClearAllPoints()
		if lock == 1 then
			--Horizontal
			mover:SetPoint("CENTER",0,0)
			x = mover:GetLeft()
			mover:ClearAllPoints()
			mover:SetPoint("BOTTOMLEFT",x,y)
		elseif lock == 2 then
			-- Vertical
			mover:SetPoint("CENTER",0,0)
			y = mover:GetBottom()
			mover:ClearAllPoints()
			mover:SetPoint("BOTTOMLEFT",x,y)
		end
	end

	self:MoverUpdatePosition(mover)
end

function MovAny:Nudge(dir, button)
	local x, y, offsetX, offsetY, parent, mover, offsetAmount
	mover = self.currentMover

	if not mover:IsShown() then
		return
	end

	x = mover:GetLeft()
	y = mover:GetBottom()

	if button == "RightButton" then
		if IsShiftKeyDown() then
			offsetAmount = 250
		else
			offsetAmount = 50
		end
	else
		if IsShiftKeyDown() then
			offsetAmount = 10
		elseif IsAltKeyDown() then
			offsetAmount = 0.1
		else
			offsetAmount = 1
		end
	end

	if dir == 1 then
		offsetX = 0
		offsetY = offsetAmount
	elseif dir == 2 then
		offsetX = 0
		offsetY = -offsetAmount
	elseif dir == 3 then
		offsetX = -offsetAmount
		offsetY = 0
	elseif dir == 4 then
		offsetX = offsetAmount
		offsetY = 0
	end

	mover:ClearAllPoints()
	mover:SetPoint("BOTTOMLEFT","UIParent","BOTTOMLEFT",x + offsetX, y + offsetY)
	self:MoverUpdatePosition(mover)
end

function MovAny:SizingAnchor( button )
	local s, e = string.find( button:GetName(), "Resize_" )
	local anchorto = string.sub( button:GetName(), e + 1 )
	local anchor

	if anchorto == "LEFT"  then
		anchor = "RIGHT"
	elseif anchorto == "RIGHT" then
		anchor = "LEFT"
	elseif anchorto == "TOP"  then
		anchor = "BOTTOM"
	elseif anchorto == "BOTTOM" then
		anchor = "TOP"
	end
	return anchorto, anchor
end

function MovAny:SetLeftFrameLocation()
	local f = GetUIPanel("left")
	if f and (f ~= LootFrame or GetCVar("lootUnderMouse") ~= "1") and not self:IsModified(f:GetName()) and not self:GetMoverByFrameName(f:GetName()) then
		if self:IsModified("UIPanelMover1") then
			local closure = function(f)
				return function()
					if MovAny:IsProtected(f) and InCombatLockdown() then
						return true
					end
					MovAny:UnlockPoint(f)
					f:ClearAllPoints()
					f:SetPoint("TOPLEFT", "UIPanelMover1", "TOPLEFT")
					
					if not f.MAOrgScale then
						f.MAOrgScale = f:GetScale()
					end
					f:SetScale(MAGetScale( UIPanelMover1 ), 1)
					
					if not f.MAOrgAlpha then
						f.MAOrgAlpha = f:GetAlpha()
					end
					f:SetAlpha(UIPanelMover1:GetAlpha())
				end
			end
			if self:IsProtected(f) and InCombatLockdown() then
				MovAny.pendingActions[f:GetName()..":UIPanel"] = closure(f)
			else
				closure(f)()
			end
		else
			local closure = function(f)
				return function()
					if MovAny:IsProtected(f) and InCombatLockdown() then
						return true
					end
					if f.MAOrgScale then
						f:SetScale(f.MAOrgScale)
						f.MAOrgScale = nil
					end
					if f.MAOrgAlpha then
						f:SetAlpha(f.MAOrgAlpha)
						f.MAOrgAlpha = nil
					end
				end
			end
			if self:IsProtected(f) and InCombatLockdown() then
				MovAny.pendingActions[f:GetName()..":UIPanel"] = closure(f)
			else
				closure(f)()
			end
		end
	end
end

function MovAny:SetCenterFrameLocation()
	if GetUIPanel("left") then
		local f = GetUIPanel("center")
		if f and (f ~= LootFrame or GetCVar("lootUnderMouse") ~= "1") and not self:IsModified(f:GetName()) and not self:GetMoverByFrameName(f:GetName()) then
			if self:IsModified("UIPanelMover2" ) then
				local closure = function(f)
					return function()
						if MovAny:IsProtected(f) and InCombatLockdown() then
							return true
						end
						MovAny:UnlockPoint(f)
						f:ClearAllPoints()
						f:SetPoint("TOPLEFT", "UIPanelMover2", "TOPLEFT")
						
						if not f.OrgScale then
							f.OrgScale = f:GetScale()
						end
						f:SetScale(MAGetScale( UIPanelMover2 ), 1)
						
						if not f.OrgAlpha then
							f.OrgAlpha = f:GetAlpha()
						end
						f:SetAlpha(UIPanelMover2:GetAlpha())
					end
				end
				if self:IsProtected(f) and InCombatLockdown() then
					MovAny.pendingActions[f:GetName()..":UIPanel"] = closure(f)
				else
					closure(f)()
				end
			else
				local closure = function(f)
					return function()
						if MovAny:IsProtected(f) and InCombatLockdown() then
							return true
						end
						if f.OrgScale then
							f:SetScale(f.OrgScale)
							f.OrgScale = nil
						end
						if f.OrgAlpha then
							f:SetAlpha(f.OrgAlpha)
							f.OrgAlpha = nil
						end
					end
				end
				if self:IsProtected(f) and InCombatLockdown() then
					MovAny.pendingActions[f:GetName()..":UIPanel"] = closure(f)
				else
					closure(f)()
				end
			end
		end
	end
end

function MovAny:GetContainerFrame( id )
	local i = 1
	local container
	while 1 do
		container = _G["ContainerFrame"..i]
		if not container then
			break
		end
		if container:IsShown() and container:GetID() == id then
			return container
		end
		i = i + 1
	end
	return nil
end

function MovAny:GetBagInContainerFrame( f )
	return self:GetBag(f:GetID())
end

function MovAny:GetBag(id)
	return self.bagFrames[ id ]
end

function MovAny:SetBag(id, bag)
	self.bagFrames[ id ] = bag
end

function MovAny:GrabContainerFrame( container, movableBag )
	if movableBag and MovAny:IsModified(movableBag:GetName()) then
		movableBag:Show()

		MovAny:UnlockScale(container)
		container:SetScale(MAGetScale( movableBag ))
		MovAny:LockScale(container)
		
		MovAny:UnlockPoint(container)
		container:ClearAllPoints()
		--container:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", movableBag:GetLeft(), movableBag:GetBottom())
		container:SetPoint("CENTER", movableBag, "CENTER", 0, 0)
		MovAny:LockPoint(container)
		
		movableBag.attachedChildren = {}
		tinsert(movableBag.attachedChildren, container)
		
		--local opts = MovAny:GetFrameOptions(movableBag:GetName())
		--MovAny:ApplyAlpha(container, opts)
		container:SetAlpha(movableBag:GetAlpha())
	else
		local opts = {alpha = 1.0, scale = 1.0}
		MovAny:ApplyAlpha(container, opts)
		MovAny:ApplyScale(container, opts)
	end
end

function MovAny:ApplyAll(f, opt)
	opt = opt or MovAny:GetFrameOptions(f:GetName())
	if opt.disabled then
		return
	end
	--dbg("  applying stored settings to "..(f:GetName() or "unnamed frame"))
	MovAny:ApplyScale(f, opt)
	MovAny:ApplyPosition(f, opt)
	MovAny:ApplyAlpha(f, opt)
	MovAny:ApplyHide(f, opt)
	MovAny:ApplyLayers(f, opt)
	MovAny:ApplyMisc(f, opt)
end

function MovAny:ResetAll(f, opt, readOnly)
	opt = opt or MovAny:GetFrameOptions(f:GetName())
	
	MovAny:ResetScale(f, opt, readOnly)
	MovAny:ResetPosition(f, opt, readOnly)
	MovAny:ResetAlpha(f, opt, readOnly)
	MovAny:ResetHide(f, opt, readOnly)
	MovAny:ResetLayers(f, opt, readOnly)
	MovAny:ResetMisc(f, opt, readOnly)
end

function MovAny:UnanchorRelatives(f, opt)
	if f.GetName and f:GetName() ~= nil and (MovAny.NoUnanchorRelatives[ f:GetName() ] ) then
		-- semi nasty hack to avoid unanchoring buffs/debuffs
		-- or string.match(f:GetName(), "[Bb]uff")
		return
	end
	if not f.GetParent then
		return
	end
	local p = f:GetParent()
	if not p then
		return
	end
	
	opt = opt or self:GetFrameOptions(f:GetName())
	
	--dbg("searching for relatives to "..f:GetName().." in "..p:GetName())
	
	local named = {}
	
	self:_AddNamedChildren(named, f)
	
	local relatives = tcopy(named)
	relatives[ f ] = f
	
	if p.GetRegions then
		local children = {p:GetRegions()}
		if children ~= nil then
			--dbg(" regions: "..tlen(children))
			for i, v in ipairs(children) do
				self:_AddDependents(relatives, v)
			end
		end
	end
	
	if p.GetChildren then
		local children = {p:GetChildren()}
		if children ~= nil then
			--dbg(" siblings: "..tlen(children))
			for i, v in ipairs(children) do
				self:_AddDependents(relatives, v)
			end
		end
	end
	
	relatives[ f ] = nil
	relatives[GameTooltip] = nil
	
	for i, v in pairs(named) do
		relatives[ v ] = nil
	end
	
	--local fRel = self:ForcedDetachFromParent(f:GetName())
	local fRel = select(2, opt.orgPos)
	if fRel == nil then
		fRel = select(2, f:GetPoint(1))
	end
	local size = tlen(relatives)
	if size > 0 then
		--dbg("unanchoring relatives for "..f:GetName().." from "..p:GetName()..". children found: "..size)
		local unanchored = {}
		local x, y, i
		for i, v in pairs(relatives) do
			if --[[self:IsDefaultFrame(v) and ]]not self:IsContainer(v:GetName()) and not string.match(v:GetName(), "BagFrame[1-9][0-9]*") and not self.NoUnanchoring[ v:GetName() ] and not v.MAPoint then -- alternatively use not self:GetFrameOptions(v:GetName()) instead of v.MAPoint
				if v:GetRight() ~= nil and v:GetTop() ~= nil then
					--dbg(" unanchoring "..v:GetName().." from "..f:GetName())
					
					local p = {v:GetPoint(1)}
					p[2] = fRel
					p = MovAny:GetRelativePoint(p, v, true)
					--print(unpack(p))
					if MovAny:IsProtected(v) and InCombatLockdown() then
						MovAny:AddPendingPoint(v, p)
					else
						v.MAOrgPoint = {v:GetPoint(1)}
						MovAny:UnlockPoint(v)
						v:ClearAllPoints()
						v:SetPoint(unpack(p))
						MovAny:LockPoint(v)
					end
					unanchored[ i ] = v
				end
			--else
				--dbg(" skipping "..v:GetName().." <- "..f:GetName().."")
			end
		end
		if i ~= nil then
			f.MAUnanchoredRelatives = unanchored
		end
	end
end

function MovAny:_AddDependents(l, f)
	local p = select(2, f:GetPoint(1))
	if p and l[ p ] then
		l[ f ] = f
	end
end

function MovAny:_AddNamedChildren(l, f)
	local n
	
	if f.GetChildren then
		local children = {f:GetChildren()}
		if children ~= nil then
			for i, v in pairs(children) do
				self:_AddNamedChildren(l, v)
				if v.GetName then
					n = v:GetName()
					if n then
						l[ v ] = v
					end
				end
			end
		end
	end
	
	if f.attachedChildren then
		local children = f.attachedChildren
		if children ~= nil then
			for i, v in pairs(children) do
				self:_AddNamedChildren(l, v)
				if v.GetName then
					n = v:GetName()
					if n then
						l[ v ] = v
					end
				end
			end
		end
	end
end

function MovAny:ReanchorRelatives()
	local f
	for i,v in pairs(self.frameOptions) do
		f = _G[ v.name ]
		if f and f.MAUnanchoredRelatives then
			--dbg(f:GetName().." restoring relatives anchors")
			for k, r in pairs(f.MAUnanchoredRelatives) do
				--dbg(" restoring anchor to "..r:GetName().." ")
				if not MovAny:IsModified(r) then
					MovAny:UnlockPoint(r)
					if r.MAOrgPoint then
						r:SetPoint(unpack(r.MAOrgPoint))
						r.MAOrgPoint = nil
					end
				end
			end
			f.MAUnanchoredRelatives = nil
		end
	end
end

function MovAny:AddPendingPoint(f, p)
	local closure = function(f, p)
		return function()
			if MovAny:IsProtected(f) and InCombatLockdown() then
				return true
			end
			if not f.MAOrgPoint then
				f.MAOrgPoint = {f:GetPoint(1)}
			end
			MovAny:UnlockPoint(f)
			f:ClearAllPoints()
			--MovAny:SetPoint(f, p)
			f:SetPoint(unpack(p))
			MovAny:LockPoint(f)
		end
	end
	MovAny.pendingActions[fn..":Point"] = closure(f, p)
end

function MovAny:ApplyPosition(f, opt)
	if not opt or self.NoMove[ f:GetName() ] then
		return
	end
	
	if opt.pos then
		local fn = f:GetName()
		if opt.orgPos == nil and not self:IsContainer(f:GetName()) and string.match("BagFrame", f:GetName()) ~= nil then
			MovAny:StoreOrgPoints(f, opt)
		end
		
		if UIPARENT_MANAGED_FRAME_POSITIONS[fn] then
			f.ignoreFramePositionManager = true
		end
		
		self:UnlockPoint(f)
		f:ClearAllPoints()
		f:SetPoint(unpack(opt.pos))
		self:LockPoint(f)
		
		if f.OnMAPosition then
			f.OnMAPosition(f)
		end
		
		if f.attachedChildren then
			for i, v in pairs(f.attachedChildren) do
				if not v.ignoreFramePositionManager and v.GetName and UIPARENT_MANAGED_FRAME_POSITIONS[v:GetName()] and not v.ignoreFramePositionManager and not MovAny:IsModified(v) and v.GetName and UIPARENT_MANAGED_FRAME_POSITIONS[v:GetName()] then
					v.UMFP = true
					v.ignoreFramePositionManager = true
				end
			end
		end
		
		if UIPanelWindows[fn] and f ~= GameMenuFrame then
			local left = GetUIPanel("left")
			local center = GetUIPanel("center")

			if f == left then
				UIParent.left = nil
				if center then
					UIParent.center = nil
					UIParent.left = center
				end
			elseif f == center then
				UIParent.center = nil
			end
			
			local wasShown = f:IsShown()
			if wasShown and (not MovAny:IsProtected(f) or not InCombatLockdown()) then
				HideUIPanel(f)
			end
			local opt = self:GetFrameOptions(fn)
			if opt then
				opt.UIPanelWindows = UIPanelWindows[fn]
			end
			UIPanelWindows[fn] = nil
			f:SetAttribute("UIPanelLayout-enabled", false)
			
			if wasShown and f ~= MerchantFrame and (not MovAny:IsProtected(f) or not InCombatLockdown()) then
				f:Show()
			end
		end
	end
end

function MovAny:ResetPosition(f, opt, readOnly)
	if not opt or (f.GetName and MovAny.NoMove[ f:GetName() ]) then
		return
	end
	MovAny:UnlockPoint(f)
	
	local umfp = nil
	if f.ignoreFramePositionManager then
		umfp = true
		f.ignoreFramePositionManager = nil
	end
	
	if opt.orgPos then
		self:RestoreOrgPoints(f, opt, readOnly)
	else
		--f:ClearAllPoints()
		return
	end
	--[[
	if not readOnly and f.MAUnanchoredRelatives then
		--dbg(f:GetName().." got unanchored relatives")
		for i, v in pairs(f.MAUnanchoredRelatives) do
			if not MovAny:IsModified(v:GetName()) then
				--dbg(" restoring anchor to "..v:GetName().." ")
				MovAny:UnlockPoint(v)
				if v.MAOrgPoint then
					v:SetPoint(unpack(v.MAOrgPoint))
					v.MAOrgPoint = nil
				end
			--else
				--dbg("skipping hooked relative: "..v:GetName())
			end
		end
		f.MAUnanchoredRelatives = nil
	end
	--]]
	if f.OnMAPositionReset then
		f.OnMAPositionReset(f, opt, readOnly)
	end
	if not readOnly then
		opt.pos = nil
	end

	if f.attachedChildren then
		for i, v in pairs(f.attachedChildren) do
			if v and not MovAny:IsModified(v) and v.GetName and v.UMFP then
				v.UMFP = nil
				v.ignoreFramePositionManager = nil
				umfp = true
			end
		end
	end
	
	if opt.UIPanelWindows then
		UIPanelWindows[ f:GetName() ] = opt.UIPanelWindows
		if not readOnly then
			opt.UIPanelWindows = nil
		end
		f:SetAttribute("UIPanelLayout-enabled", true)
		if f:IsShown() and (not MovAny:IsProtected(f) or not InCombatLockdown()) then
			f:Hide()
			ShowUIPanel(f)
		end
	end
	
	if umfp and not InCombatLockdown() then
		UIParent_ManageFramePositions()
	end
	
	f.MAOrgParent = nil
end

function MovAny:ApplyAlpha(f, opt)
	if not opt or MovAny.NoAlpha[ f:GetName() ] then
		return
	end
	local alpha = opt.alpha
	
	if alpha and alpha >= 0 and alpha <= 1 then
		if opt.originalAlpha == nil then
			opt.originalAlpha = f:GetAlpha()
		end
		f:SetAlpha(alpha)
		
		if f.attachedChildren then
			for i, v in pairs(f.attachedChildren) do
				if v:GetAlpha() ~= 1 then
					v.MAOrgAlpha = v:GetAlpha()
				end
				v:SetAlpha(alpha)
			end
		end
		if f.OnMAAlpha then
			f.OnMAAlpha(f, alpha)
		end
	end
end

function MovAny:ResetAlpha(f, opt, readOnly)
	if not opt or MovAny.NoAlpha[ f:GetName() ] then
		return
	end
	
	local alpha = opt.originalAlpha
	if alpha == nil or alpha > 1 then
		alpha = 1
	elseif alpha < 0 then
		alpha = 0
	end
	
	f:SetAlpha(alpha)
	
	if f.attachedChildren then
		for i, v in pairs(f.attachedChildren) do
			v:SetAlpha(alpha)
		end
	end
	
	if f.OnMAAlpha then
		f.OnMAAlpha(f, alpha)
	end
end

function MovAny:ApplyHide(f, opt, readOnly)
	if not opt or MovAny.NoHide[ f:GetName() ] then
		return
	end

	-- HideFrame fires OnMAHide event now
	if opt.hidden then
		self:HideFrame(f, readOnly)
	end
end

function MovAny:ResetHide(f, opt, readOnly)
	if not opt or MovAny.NoHide[ f:GetName() ] then
		return
	end
	
	local wasHidden = opt.hidden
	if not readOnly then
		opt.hidden = nil
	end
	
	if wasHidden then
		self:ShowFrame(f, readOnly)
	end
	
	if f.OnMAHide then
		f.OnMAHide(f, nil)
	end
end

function MovAny:ApplyScale( f, opt, readOnly )
	if not opt or not self:CanBeScaled(f) then
		return
	end
	
	self:UnlockScale(f)
	if f.GetName and self.ScaleWH[ f:GetName() ] then
		if opt.width or opt.height then
			--dbg(f:GetName().."::ApplyScale WH w:"..opt.width.." h:"..opt.height)
		
			if opt.width and opt.originalWidth == nil then
				opt.originalWidth = f:GetWidth()
			end
			if opt.height and opt.originalHeight == nil then
				opt.originalHeight = f:GetHeight()
			end
			if self.lHideOnScale[ f:GetName() ] then
				for i,v in pairs(self.lHideOnScale[ f:GetName() ]) do
					self:LockVisibility(v)
				end
			end
			if opt.width ~= nil and opt.width > 0 then
				f:SetWidth(opt.width)
			end
			if opt.height ~= nil and opt.height > 0 then
				f:SetHeight(opt.height)
			end
			self:LockScale(f)
			if self.lLinkedScaling[ f:GetName() ] then
				for i,v in pairs(self.lLinkedScaling[ f:GetName() ]) do
					if not self:IsModified(v) then
						self:ApplyScale(_G[v], opt)
					end
				end
			end
			if f.OnMAScale then
				f.OnMAScale(f, opt.width, opt.height)
			end
		end
	elseif opt.scale ~= nil and opt.scale >= 0 then
		if readOnly == nil and not opt.originalScale then
			--dbg("no org scale, setting "..f:GetName().." to: "..f:GetScale())
			opt.originalScale = f:GetScale()
		end
		
		f:SetScale(opt.scale)
		self:LockScale(f)
		
		if self.lHideOnScale[ f:GetName() ] then
			for i,v in pairs(self.lHideOnScale[ f:GetName() ]) do
				self:LockVisibility(v)
			end
		end

		if f.attachedChildren and not f.MANoScaleChildren then
			for i, v in pairs(f.attachedChildren) do
				self:ApplyScale(v, opt)
			end
		end
		
		if self.lLinkedScaling[ f:GetName() ] then
			for i,v in pairs(self.lLinkedScaling[ f:GetName() ]) do
				if not self:IsModified(v) then
					self:ApplyScale(_G[v], opt)
				end
			end
		end
		if f.OnMAScale then
			f.OnMAScale(f, opt.scale)
		end
	end
end

function MovAny:ResetScale(f, opt, readonly)
	-- XX: should prolly change second condition to self:CanBeScaled(f)
	if not opt or (f.GetName and self.NoScale[ f:GetName() ]) then
		return
	end
	
	self:UnlockScale(f)
	if self.ScaleWH[ f:GetName() ] then
		if (opt.originalWidth and f:GetWidth() ~= opt.originalWidth) or (opt.originalHeight and f:GetHeight() ~= opt.originalHeight) then
			if opt.originalWidth ~= nil and opt.originalWidth > 0 then
				f:SetWidth(opt.originalWidth)
			end
			if opt.originalHeight ~= nil and opt.originalHeight > 0 then
				f:SetHeight(opt.originalHeight)
			end
			if self.lHideOnScale[ f:GetName() ] then
				for i,v in pairs(self.lHideOnScale[ f:GetName() ]) do
					self:UnlockVisibility(v)
				end
			end
			if self.lLinkedScaling[ f:GetName() ] then
				local lf
				for i,v in pairs(self.lLinkedScaling[ f:GetName() ]) do
					if not self:IsModified(v) then
						lf = _G[v]
						if self:CanBeScaled(lf) then
							if self:IsProtected(lf) and InCombatLockdown() then
								self.pendingFrames[v] = opt
							else
								self:ResetScale(lf, opt)
							end
						end
					end
				end
			end
			if f.OnMAScale then
				f.OnMAScale(f, {opt.width, opt.height})
			end
		end
	elseif self:IsScalableFrame(f) then
		local scale = opt.originalScale or 1
		if scale == nil then
			return
		end
		if scale ~= f:GetScale() then
			f:SetScale(scale)
		end
		
		if self.lHideOnScale[ f:GetName() ] then
			for i,v in pairs(self.lHideOnScale[ f:GetName() ]) do
				self:UnlockVisibility(v)
			end
		end
		if f.attachedChildren and not f.MANoScaleChildren then
			for i, v in pairs(f.attachedChildren) do
				if not self:IsModified(v) then
					if self:CanBeScaled(v) then
						if self:IsProtected(v) and InCombatLockdown() then
							self.pendingFrames[i] = opt
						else
							self:ResetScale(v, opt)
						end
					end
				end
			end
		end
		if self.lLinkedScaling[ f:GetName() ] then
			for i,v in pairs(self.lLinkedScaling[ f:GetName() ]) do
				self:ResetScale(_G[v], opt)
			end
		end
		if f.OnMAScale then
			f.OnMAScale(f, scale)
		end
	end
end

function MovAny:ApplyLayers(f, opt, readOnly)
	if not opt then
		return
	end
	if opt.disableLayerArtwork then
		f:DisableDrawLayer("ARTWORK")
	end
	if opt.disableLayerBackground then
		f:DisableDrawLayer("BACKGROUND")
	end
	if opt.disableLayerBorder then
		f:DisableDrawLayer("BORDER")
	end
	if opt.disableLayerHighlight then
		f:DisableDrawLayer("HIGHLIGHT")
	end
	if opt.disableLayerOverlay then
		f:DisableDrawLayer("OVERLAY")
	end
end

function MovAny:ResetLayers(f, opt, readOnly)
	if not opt then
		return
	end
	if not f.EnableDrawLayer then
		if not readOnly then
			opt.disableLayerArtwork = nil
			opt.disableLayerBackground = nil
			opt.disableLayerBorder = nil
			opt.disableLayerHighlight = nil
			opt.disableLayerOverlay = nil
			return
		end
	end
	if opt.disableLayerArtwork then
		f:EnableDrawLayer("ARTWORK")
		if not readOnly then
			opt.disableLayerArtwork = nil
		end
	end
	if opt.disableLayerBackground then
		f:EnableDrawLayer("BACKGROUND")
		if not readOnly then
			opt.disableLayerBackground = nil
		end
	end
	if opt.disableLayerBorder then
		f:EnableDrawLayer("BORDER")
		if not readOnly then
			opt.disableLayerBorder = nil
		end
	end
	if opt.disableLayerHighlight then
		f:EnableDrawLayer("HIGHLIGHT")
		if not readOnly then
			opt.disableLayerHighlight = nil
		end
	end
	if opt.disableLayerOverlay then
		f:EnableDrawLayer("OVERLAY")
		if not readOnly then
			opt.disableLayerOverlay = nil
		end
	end
end

function MovAny:ApplyMisc(f, opt, readOnly)
	if not opt then
		return
	end
	
	if opt.frameStrata then
		if not opt.orgFrameStrata then
			opt.orgFrameStrata = f:GetFrameStrata()
		end
		f:SetFrameStrata(opt.frameStrata)
	end
	
	if opt.clampToScreen then
		if not opt.orgClampToScreen then
			opt.orgClampToScreen = f:IsClampedToScreen()
		end
		f:SetClampedToScreen(opt.clampToScreen)
	end
	
	if opt.enableMouse ~= nil then
		opt.orgEnableMouse = f:IsMouseEnabled()
		f:EnableMouse(opt.enableMouse)
	end
	
	if opt.movable ~= nil then
		opt.orgMovable = f:IsMovable()
		f:SetMovable(opt.movable)
	end
end

function MovAny:ResetMisc(f, opt, readOnly)
	if not opt then
		return
	end
	if opt.orgFrameStrata then
		f:SetFrameStrata(opt.orgFrameStrata)
		if not readOnly then
			opt.frameStrata = nil
			opt.orgFrameStrata = nil
		end
	end
	
	if opt.orgEnableMouse then
		f:EnableMouse(opt.orgEnableMouse)
		if not readOnly then
			opt.orgEnableMouse = nil
			opt.enableMouse = nil
		end
	end
	
	if opt.orgMovable then
		f:SetMovable(opt.orgMovable)
		if not readOnly then
			opt.orgMovable = nil
			opt.movable = nil
		end
	end
end

-- modfied version of blizzards updateContainerFrameAnchors
-- to prevent this from hooking the original updateContainerFrameAnchors do a "/run MADB.noBags = true" followed by "/reload"
function MovAny:hUpdateContainerFrameAnchors()
  if MADB.noBags then
     return
  end
  local frame, xOffset, yOffset, screenHeight, freeScreenHeight, leftMostPoint, column
  local screenWidth = GetScreenWidth()
  local containerScale = 1
  local leftLimit = 0

  while ( containerScale > CONTAINER_SCALE ) do
    screenHeight = GetScreenHeight() / containerScale
    -- Adjust the start anchor for bags depending on the multibars
    xOffset = CONTAINER_OFFSET_X / containerScale
    yOffset = CONTAINER_OFFSET_Y / containerScale
    -- freeScreenHeight determines when to start a new column of bags
    freeScreenHeight = screenHeight - yOffset
    leftMostPoint = screenWidth - xOffset
    column = 1
    local frameHeight
    for index, frameName in ipairs(ContainerFrame1.bags) do
      frameHeight = _G[frameName]:GetHeight()
      if freeScreenHeight < frameHeight then
        -- Start a new column
        column = column + 1
        leftMostPoint = screenWidth - ( column * CONTAINER_WIDTH * containerScale ) - xOffset
        freeScreenHeight = screenHeight - yOffset
      end
      freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING
    end
    if leftMostPoint < leftLimit then
      containerScale = containerScale - 0.01
    else
      break
    end
  end

  if containerScale < CONTAINER_SCALE then
    containerScale = CONTAINER_SCALE
  end

  screenHeight = GetScreenHeight() / containerScale
  -- Adjust the start anchor for bags depending on the multibars
  xOffset = CONTAINER_OFFSET_X / containerScale
  yOffset = CONTAINER_OFFSET_Y / containerScale
  -- freeScreenHeight determines when to start a new column of bags
  freeScreenHeight = screenHeight - yOffset
  column = 0

  local bag = nil
  local lastBag = nil
  for index, frameName in ipairs(ContainerFrame1.bags) do
    frame = _G[frameName]
    bag = MovAny:GetBagInContainerFrame(frame)
    if not bag or ( bag and not MovAny:IsModified(bag:GetName()) and not MovAny:GetMoverByFrameName(bag:GetName()) ) then
		--dbg("uCFA: "..bag:GetName().."")
		
		MovAny:UnlockScale(frame)
	    frame:SetScale(containerScale)
		
		MovAny:UnlockPoint(frame)
	    frame:ClearAllPoints()
	    if lastBag == nil then
	      -- First bag
	      frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", GetScreenWidth()-xOffset-CONTAINER_WIDTH, yOffset )
	    elseif freeScreenHeight < frame:GetHeight() then
	      -- Start a new column
		  --dbg("new column: "..frame:GetName())
	      column = column + 1
	      freeScreenHeight = screenHeight - yOffset
	      frame:SetPoint("BOTTOMLEFT", frame:GetParent(), "BOTTOMLEFT", GetScreenWidth()-xOffset-(column * CONTAINER_WIDTH) - CONTAINER_WIDTH, yOffset )
	    else
	      -- Anchor to the previous bag
		  --dbg("attaching bag: "..frame:GetName().." to "..(select(4, lastBag:GetPoint(1)))..", "..(lastBag:GetTop() + CONTAINER_SPACING))
	      frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", select(4, lastBag:GetPoint(1)), lastBag:GetTop() + CONTAINER_SPACING)
	    end
	    freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING

	    lastBag = frame
	   end
  end
end

----------------------------------------------------------------
-- X: slash commands

SLASH_MAMOVE1 = "/move"
SlashCmdList["MAMOVE"] = function( msg )
	if msg == nil or string.len( msg ) == 0 then
		MovAny:ToggleGUI()
	else
		MovAny:ToggleMove(MovAny:Translate(msg))
	end
end

SLASH_MAUNMOVE1= "/unmove"
SlashCmdList["MAUNMOVE"] = function( msg )
	if msg then
		if MovAny.frameOptions[ msg ] then
			MovAny:ResetFrame(msg)
		elseif MovAny.frameOptions[ MovAny:Translate(msg) ] then
			MovAny:ResetFrame(MovAny:Translate(msg))
		end
	else
		maPrint(MOVANY.CMD_SYNTAX_UNMOVE)
	end
end

SLASH_MAHIDE1 = "/hide"
SlashCmdList["MAHIDE"] = function( msg )
	if msg == nil or string.len( msg ) == 0 then
		maPrint(MOVANY.CMD_SYNTAX_HIDE)
		return
	end
	MovAny:ToggleHide(MovAny:Translate(msg))
end

SLASH_MAIMPORT1 = "/moveimport"
SlashCmdList["MAIMPORT"] = function( msg )
	if msg == nil or string.len(msg) == 0 then
		maPrint(MOVANY.CMD_SYNTAX_IMPORT)
		return
	end

	if InCombatLockdown() then
		maPrint(MOVANY.DISABLED_DURING_COMBAT)
		return
	end
	
	if MoveAnything_CharacterSettings[msg] == nil then
		maPrint(string.format(MOVANY.PROFILE_UNKNOWN, msg))
		return
	end

	MovAny:CopySettings(msg, MovAny:GetProfileName())
	MovAny:UpdateProfile()
	maPrint(string.format(MOVANY.PROFILE_IMPORTED, msg))
end

SLASH_MAEXPORT1 = "/moveexport"
SlashCmdList["MAEXPORT"] = function( msg )
	if msg == nil or string.len(msg) == 0 then
		maPrint(MOVANY.CMD_SYNTAX_EXPORT)
		return
	end

	MovAny:CopySettings(MovAny:GetProfileName(), msg)
	maPrint(string.format(MOVANY.PROFILE_EXPORTED, msg))
end


SLASH_MALIST1 = "/movelist"
SlashCmdList["MALIST"] = function( msg )
	maPrint(MOVANY.PROFILES..":")
	for i, val in pairs(MoveAnything_CharacterSettings) do
		local str = " \""..i.."\""
		if  val == MovAny.frameOptions then
			str = str.." <- "..MOVANY.PROFILE_CURRENT
		end
		maPrint(str)
	end
end

SLASH_MADELETE1 = "/movedelete"
SLASH_MADELETE2 = "/movedel"
SlashCmdList["MADELETE"] = function( msg )
	if msg == nil or string.len( msg ) == 0 then
		maPrint(MOVANY.CMD_SYNTAX_DELETE)
		return
	end
	
	if MoveAnything_CharacterSettings[msg] == nil then
		maPrint(string.format(MOVANY.PROFILE_UNKNOWN, msg))
		return
	end

	if msg == MovAny:GetProfileName() then
		if InCombatLockdown() then
			maPrint(MOVANY.PROFILE_CANT_DELETE_CURRENT_IN_COMBAT)
			return
		end
		MovAny:ResetProfile()
	else
		MoveAnything_CharacterSettings[msg] = nil
	end
	maPrint(string.format(MOVANY.PROFILE_DELETED, msg))
end

----------------------------------------------------------------
-- X: global functions

function numfor(n, decimals)
	if n == nil then
		return "nil"
	end
	n = string.format("%."..(decimals or 2).."f", n)
	if decimals == nil then
		decimals = 2
	end
	while decimals > 0 do
		if string.sub(n, -1) == "0" then
			n = string.sub(n, 1, -2)
		end
		decimals = decimals - 1
	end
	if string.sub(n, -1) == "." then
		n = string.sub(n, 1, -2)
	end
	return n
end

function MAGetParent( f )
	if not f or not f.GetParent then
		return
	end
	local p = f:GetParent()
	if p == nil then
		return UIParent
	end

	return p
end

function MAGetScale( f, effective )
	if not f or not f.GetScale then
		return 1
	elseif MovAny.NoScale[f:GetName()] then
		return f:GetScale()
	else
		if not f.GetScale or f:GetScale() == nil then
			return 1
		end

		if effective then
			return f:GetEffectiveScale()
		else
			return f:GetScale()
		end
	end
end

function maPrint( msgKey, msgHighlight, msgAdditional, r, g, b, frame )
	local msgOutput
	if frame then
		msgOutput = frame
	else
		msgOutput = DEFAULT_CHAT_FRAME
	end

	if msgKey				 == "" then
		return
	end
	if msgKey        == nil then
		msgKey = "<nomsg>"
	end
	if msgHighlight == nil or msgHighlight == "" then
		msgHighlight  = " "
	end
	if msgAdditional == nil or msgAdditional == "" then
		msgAdditional = " "
	end
	if msgOutput then
		msgOutput:AddMessage( "|caaff0000MoveAnything|r|caaffff00>|r "..msgKey.." |caaaaddff"..msgHighlight.."|r"..msgAdditional, r, g, b )
	end
end

----------------------------------------------------------------
function MovAny:ToggleEnableFrame(fn, opt)
	local opt = opt or MovAny:GetFrameOptions(fn)
	if opt.disabled then
		self:EnableFrame(fn)
	else
		self:DisableFrame(fn)
	end
	MovAny:UpdateGUIIfShown()
end

function MovAny:EnableFrame(fn)
	if fn == nil then
		return
	end

	local opts = self:GetFrameOptions(fn)
	if not opts then
		return
	end
	opts.disabled = nil
	
	local f = _G[fn]
	if not f then
		return
	end
	if not self:HookFrame(fn, f) then
		return
	end
	self:ApplyAll(f, opts)
end

function MovAny:DisableFrame(fn)
	if fn==nil then
		return
	end
	self:StopMoving(fn)

	local opt = self:GetFrameOptions(fn, nil, true)
	if not opt then
		return
	end

	local f = _G[fn]
	if not f then
		return
	end
	self:ResetFrame(f, nil, true)
	opt.disabled = true
end

function MovAny:HookTooltip(mover)
	local l, r, t, b, anchor
	local tooltip = GameTooltip
	l = mover:GetLeft() * mover:GetEffectiveScale()
	r = mover:GetRight() * mover:GetEffectiveScale()
	t = mover:GetTop() * mover:GetEffectiveScale()
	b = mover:GetBottom() * mover:GetEffectiveScale()
	
	anchor = "CENTER"
	if ((b + t) / 2) < ((UIParent:GetTop() * UIParent:GetScale()) / 2) - 25 then
		anchor = "BOTTOM"
	elseif ((b + t) / 2) > ((UIParent:GetTop() * UIParent:GetScale()) / 2) + 25 then
		anchor = "TOP"
	end
	if anchor ~= "CENTER" then
		if ((l + r) / 2) > ((UIParent:GetRight() * UIParent:GetScale()) / 2) + 25 then
			anchor = anchor.."RIGHT"
		elseif ((l + r) / 2) < ((UIParent:GetRight() * UIParent:GetScale()) / 2) - 25 then
			anchor = anchor.."LEFT"
		end
	end
	MovAny:UnlockPoint(tooltip)
	tooltip:ClearAllPoints()
	
	if tooltip:GetOwner() then
		tooltip.MASkip = true
		tooltip:SetOwner(tooltip:GetOwner(), "ANCHOR_NONE")
		tooltip.MASkip = nil
	end
	
	tooltip:SetPoint(anchor, mover, anchor, 0, 0)
	tooltip:SetParent(mover)
	--tooltip.default = 1
	
	MovAny:LockPoint(tooltip)
	
	local opt = MovAny:GetFrameOptions(mover:GetName())
	--MovAny:ApplyScale(tooltip, opt, true)
	--MovAny:ApplyAlpha(tooltip, opt, true)
	MovAny:ApplyHide(tooltip, opt, true)
	mover.attachedChildren = {tooltip}
end

function MovAny:hGameTooltip_SetDefaultAnchor(relative)
	local tooltip = GameTooltip
	if tooltip.MASkip then
		return
	end
	--dbg("GTt SDA "..relative:GetName())
	if MovAny:IsModified("TooltipMover") then
		--dbg("Hooked: TooltipMover")
		MovAny:HookTooltip(_G["TooltipMover"])
	elseif MovAny:IsModified("BagItemTooltipMover") then
		--dbg("Hooked: BagItemTooltipMover")
		local opt = {alpha= 1.0, scale = 1.0}
		MovAny:UnlockPoint(tooltip)
		MovAny:ApplyScale(tooltip, opt, true)
		MovAny:ApplyAlpha(tooltip, opt, true)
		MovAny:ResetHide(tooltip, opt, true)
		if not tooltip:IsProtected() then
			tooltip.MASkip = true
			GameTooltip_SetDefaultAnchor(tooltip, relative)
			tooltip.MASkip = nil
		end
	end
end

function MovAny:hGameTooltip_SetOwner(owner, anchor)
	if GameTooltip.MASkip then
		return
	end
	--dbg("GTt SO ")
	if owner:GetName() ~= nil and string.match(owner:GetName(), "ContainerFrame[1-9][0-9]*") then
		if MovAny:IsModified("BagItemTooltipMover") then
			MovAny:HookTooltip(_G["BagItemTooltipMover"])
		end
	end
end

-- X: MA tooltip funcs
function MovAny:TooltipShow(self)
	if not self.tooltipText then
		return
	end
	if self.alwaysShowTooltip or (MADB.tooltips and not IsShiftKeyDown()) or (not MADB.tooltips and IsShiftKeyDown()) then
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.tooltipText)
		GameTooltip:Show()
	end
end

function MovAny:TooltipHide()
	GameTooltip:Hide()
end

function MovAny:TooltipShowMultiline(self)
	local tooltipLines = self.tooltipLines
	if tooltipLines == nil then
		tooltipLines = MovAny:GetFrameTooltipLines(MovAny.frames[ self.idx ].name)
	end
	if tooltipLines == nil then
		return
	end
	local g = 0
	for k in pairs(tooltipLines) do
		g = 1
		break
	end
	if i == 0 then
		return
	end
	if self.alwaysShowTooltip or (MADB.tooltips and not IsShiftKeyDown()) or (not MADB.tooltips and IsShiftKeyDown()) then
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:ClearLines()
		for i,v in ipairs(tooltipLines) do
			GameTooltip:AddLine(v)
		end
		GameTooltip:Show()
	end
end

function MovAny:GetFrameTooltipLines(fn)
	if not fn then
		return
	end
	
	local opts = MovAny:GetFrameOptions(fn)
	local o = MovAny:GetFrame(fn)
	local msgs = {}
	local enough = nil
	local added = nil
	
	tinsert(msgs, o.helpfulName or fn)
	if opts then
		if opts.hidden then
			if MovAny.HideList[fn] then
				tinsert(msgs, "Specially hidden")
			else
				tinsert(msgs, "Hidden")
			end
			enough = true
		end
	end
	if o and o.helpfulName and o.helpfulName ~= fn and fn ~= nil then
		tinsert(msgs, " ")
		tinsert(msgs, "Frame: "..fn)
	end
	if opts then
		if opts.pos then
			if not added then
				tinsert(msgs, " ")
			end
			tinsert(msgs, "Position: "..numfor(opts.pos[4])..", "..numfor(opts.pos[5]))
			enough = true
			added = true
		end
		if opts.scale then
			if not added then
				tinsert(msgs, " ")
			end
			tinsert(msgs, "Scale: "..numfor(opts.scale))
			enough = true
			added = true
		end
		if opts.alpha then
			if not added then
				tinsert(msgs, " ")
			end
			tinsert(msgs, "Alpha: "..numfor(opts.alpha))
			enough = true
			added = true
		end
		
		added = nil
		if opts.scale then
			if not added then
				tinsert(msgs, " ")
			end
			tinsert(msgs, "Original Scale: "..numfor(opts.originalScale or 1))
			enough = true
			added = true
		end
		if opts.alpha and opts.originalAlpha and opts.alpha ~= opts.originalAlpha then
			if not added then
				tinsert(msgs, " ")
			end
			tinsert(msgs, "Original Alpha: "..numfor(opts.originalAlpha))
			enough = true
			added = true
		end
	end
	--[[-- enable this to only show tooltips if actual modifications have been made to the frame
	if not enough then
		table.wipe(msgs)
	end
	--]]
	return msgs
end

----------------------------------------------------------------
-- X: debugging code

function echo(...)
	local msg = ""
	for k,v in pairs({...}) do
		msg = msg .. k .. "=[" .. tostring(v) .."] "
	end
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function decho(...)
	local msg = ""
	for k,v in pairs({...}) do
		if type(v) == "table" then
			msg = msg .. k .. "=[" .. dechoSub(v, 1) .."] \n"
		else
			msg = msg .. k .. "=[" .. tostring(v) .."] \n"
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function dechoSub(t, d)
	local msg = ""
	if d > 10 then
		return msg
	end
	for k,v in pairs(t) do
		if type(v) == "table" then
			msg = msg .. k .. "=[" .. dechoSub(v, d + 1) .."] \n"
		else
			msg = msg .. k .. "=[" .. tostring(v) .."] \n"
		end
	end
	return msg
end

function necho(...)
	local msg = ""
	for k,v in pairs({...}) do
		msg = msg .. k .. "=[" .. numfor(v) .."] "
	end
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function MovAny:DebugFrameAtCursor()
	local o = GetMouseFocus()
	if o then
		if self:IsMAFrame(o:GetName()) then
			if self:IsMover(o:GetName()) and o.tagged then
				o = o.tagged
			end
		end
		
		if o ~= WorldFrame and o ~= UIParent then
			MovAny:Dump(o)
		end
	end
end

function MovAny:Dump(o)
	if type(o) ~= "table" then
		maPrint(string.format(MOVANY.UNSUPPORTED_TYPE, type(o)))
		return
	end

	maPrint("Name: "..o:GetName())
	
	if o.GetObjectType then
		maPrint("Type: "..o:GetObjectType())
	end
	
	local p = o:GetParent()
	if p == nil then
		p = UIParent
	end
	if o ~= p then
		maPrint("Parent: "..(p:GetName() or "unnamed"))
	end
	
	if o.MAParent then
		maPrint("MA Parent: "..(o.MAParent:GetName() or "unnamed"))
	end
	
	local point = {o:GetPoint()}
	if point and point[1] and point[2] and point[3] and point[4] and point[5] then
		if not point[2] then
			point[2] = UIParent
		end
		maPrint("Point: "..point[1]..", "..point[2]:GetName()..", "..point[3]..", "..point[4]..", "..point[5])
	end
	
	if o:GetTop() then
		maPrint("Top: "..o:GetTop())
	end
	if o:GetRight() then
		maPrint("Right: "..o:GetRight())
	end
	if o:GetBottom() then
		maPrint("Bottom: "..o:GetBottom())
	end
	if o:GetLeft() then
		maPrint("Left: "..o:GetLeft())
	end
	if o:GetHeight() then
		maPrint("Height: "..o:GetHeight())
	end
	if o:GetWidth() then
		maPrint("Width: "..o:GetWidth())
	end
	if o.GetScale then
		maPrint("Scale: "..o:GetScale())
	end
	if o.GetEffectiveScale then
		maPrint("Scale Effective: "..o:GetEffectiveScale())
	end
	if o.GetAlpha then
		maPrint("Alpha: "..o:GetAlpha())
	end
	if o.GetEffectiveAlpha then
		maPrint("Alpha Effective: "..o:GetEffectiveAlpha())
	end
	if o.GetFrameLevel then
		maPrint("Level: "..o:GetFrameLevel())
	end
	if o.GetFrameStrata then
		maPrint("Strata: "..o:GetFrameStrata())
	end
	if o.IsUserPlaced then
		if o:IsUserPlaced() then
			maPrint("UserPlaced: true")
		else
			maPrint("UserPlaced: false")
		end
	end
	if o.IsMovable then
		if o:IsMovable() then
			maPrint("Movable: true")
		else
			maPrint("Movable: false")
		end
	end
	if o.IsResizable then
		if o:IsResizable() then
			maPrint("Resizable: true")
		else
			maPrint("Resizable: false")
		end
	end
	if o.IsTopLevel and o:IsToplevel() then
		maPrint("Top Level: true")
	end
	if o.IsProtected and o:IsProtected() then
		maPrint("Protected: true")
	elseif o.MAProtected then
		maPrint("Virtually protected: true")
	end
	if o.IsKeyboardEnabled then
		if o:IsKeyboardEnabled() then
			maPrint("KeyboardEnabled: true")
		else
			maPrint("KeyboardEnabled: false")
		end
	end
	if o.IsMouseEnabled then
		if o:IsMouseEnabled() then
			maPrint("MouseEnabled: true")
		else
			maPrint("MouseEnabled: false")
		end
	end
	if o.IsMouseWheelEnabled then
		if o:IsMouseWheelEnabled() then
			maPrint("MouseWheelEnabled: true")
		else
			maPrint("MouseWheelEnabled: false")
		end
	end

	local opts = self:GetFrameOptions(o:GetName())
	if opts ~= nil then
		maPrint("MA stored variables:")
		for i,v in pairs(opts) do
--[[
			if i == "cat" then
				maPrint("  category: "..v.helpfulName)
			elseif i ~= "name" then
			]]
			if i ~= "cat" and i ~= "name" then
				if v == nil then
					maPrint("  "..i..": nil")
				elseif v == true then
					maPrint("  "..i..": true")
				elseif v == false then
					maPrint("  "..i..": false")
				elseif type(v) == "number" then
					maPrint("  "..i..": "..numfor(v))
				elseif type(v) == "table" then
					maPrint(" "..i..": table")
					decho(v)
				else
					maPrint(" "..i.." is a "..type(v).."")
				end
			end
		end
	end
end

SLASH_MADBG1 = "/madbg"
SlashCmdList["MADBG"] = function( msg )
	if msg == nil or msg == "" then
		MADebug()
		return
	end
	local f = _G[msg]
	if f == nil then
		local tr = MovAny:Translate(msg)
		if tr then
			f = _G[tr]
		end
	end
	if f == nil then
		maPrint(string.format(MOVANY.ELEMENT_NOT_FOUND_NAMED, msg))
	else
		MovAny:Dump(f)
	end
end

function MADebug()
	local ct = 0
	--[[
	maPrint("Frames: "..table.getn(MovAny.frames))
	for i, o in pairs(MovAny.frames) do
		ct = ct + 1
		if o.sep then
			maPrint(ct.." Category: "..MovAny.frames[i].helpfulName)
		else
			maPrint(ct.." Frame: "..MovAny.frames[i].name)
		end
	end
	--]]
	ct = 0
	maPrint("Custom frames: "..tlen(MoveAnything_CustomFrames))
	for i, v in pairs(MoveAnything_CustomFrames) do
		ct = ct + 1
		maPrint(ct..": "..v.name)
	end
	
	ct = 0
	maPrint("Frame options: "..tlen(MovAny.frameOptions))
	for i, v in pairs(MovAny.frameOptions) do
		ct = ct + 1
		maPrint(ct..": "..v.name)
	end
end

MovAny.dbg = dbg

-- x: Blizzard Interface Options functions
function MovAny:OptionCheckboxChecked(button, var)
	if var == "squareMM" then
		if button:GetChecked() then
			Minimap:SetMaskTexture("Interface\\AddOns\\MoveAnything\\MinimapMaskSquare")
		else
			Minimap:SetMaskTexture("Textures\\MinimapMask")
		end
	end
	MADB[var] = button:GetChecked()
	MovAny:UpdateGUIIfShown()
end

function MovAny:SetOptions()
	MoveAnything_UseCharacterSettings = MAOptCharacterSpecific:GetChecked()
	
	MADB.alwaysShowNudger = MAOptAlwaysShowNudger:GetChecked()
	MADB.noBags = MAOptNoBags:GetChecked()
	MADB.noMMMW = MAOptNoMMMW:GetChecked()
	MADB.playSound = MAOptPlaySound:GetChecked()
	MADB.tooltips = MAOptShowTooltips:GetChecked()
	MADB.closeGUIOnEscape = MAOptCloseGUIOnEscape:GetChecked()
	MADB.squareMM = MAOptsSquareMM:GetChecked()
	MADB.dontSearchFrameNames = MAOptDontSearchFrameNames:GetChecked()
	MADB.frameListRows = MAOptRowsSlider:GetValue()
end

function MovAny:SetDefaultOptions()
	MoveAnything_UseCharacterSettings = nil
	if MADB.squareMM then
		Minimap:SetMaskTexture("Textures\\MinimapMask")
	end
	
	MADB.alwaysShowNudger = nil
	MADB.noBags = nil
	MADB.noMMMW = nil
	MADB.playSound = nil
	MADB.tooltips = nil
	MADB.closeGUIOnEscape = nil
	MADB.squareMM = nil
	MADB.dontSearchFrameNames = nil
	MADB.frameListRows = 18
	
	MovAny_OptionsOnShow()
	MovAny:UpdateGUIIfShown()
end

function MovAny_OptionsOnLoad(f)
	f.name = GetAddOnMetadata("MoveAnything", "Title")
	f.okay = MovAny.SetOptions
	f.default = MovAny.SetDefaultOptions
	InterfaceOptions_AddCategory(f)
end

function MovAny_OptionsOnShow()
	MAOptVersion:SetText("Version: |cffeeeeee"..GetAddOnMetadata("MoveAnything", "Version").."|r")
	MAOptAlwaysShowNudger:SetChecked(MADB.alwaysShowNudger)
	MAOptNoBags:SetChecked(MADB.noBags)
	MAOptPlaySound:SetChecked(MADB.playSound)
	MAOptShowTooltips:SetChecked(MADB.tooltips)
	MAOptCloseGUIOnEscape:SetChecked(MADB.closeGUIOnEscape)
	MAOptSquareMM:SetChecked(MADB.squareMM)
	MAOptNoMMMW:SetChecked(MADB.noMMMW)
	MAOptCharacterSpecific:SetChecked(MoveAnything_UseCharacterSettings)
	MAOptDontSearchFrameNames:SetChecked(MADB.dontSearchFrameNames)
	if MADB.frameListRows then
		MAOptRowsSlider:SetValue(MADB.frameListRows)
	end
	
	local a = {}
	for i, o in pairs(MoveAnything_CharacterSettings) do
		tinsert(a, i)
	end
	table.sort(a, function(o1,o2)
		return o1:lower() < o2:lower()
	end)
	local s = ""
	for i, o in pairs(a) do
		s = s.."  "..o.."\n"
	end
	MAOptCharacterSpecific.tooltipText = "Use character specific settings\n\n Current profile: "..MovAny.GetProfileName().."\n\n Profiles: \n"..s.."\n\n Cmds:\n   /movelist\n   /moveimport\n   /moveexport\n   /movedelete"
end

function MovAny:SetNumRows(num, dontUpdate)
	MADB.frameListRows = num
	
	local base = 0
	local h = 24
	
	MAOptions:SetHeight(base + 81 + (num * h))
	MAScrollFrame:SetHeight(base + 11 + (num * h))
	MAScrollBorder:SetHeight(base - 22 + (num * h))
	
	for i = 1, 100, 1 do
		local row = _G["MAMove"..i]
		if num >= i then
			if not row then
				row = CreateFrame("Frame", "MAMove"..i, MAOptions, "MAListRowTemplate")
				if i == 1 then
					row:SetPoint("TOPLEFT", "MAOptionsFrameNameHeader", "BOTTOMLEFT", -8, -4)
				else
					row:SetPoint("TOPLEFT", "MAMove"..(i - 1), "BOTTOMLEFT")
				end
				
				local label = _G[ "MAMove"..i.."FrameName" ]
				label:SetScript("OnEnter", MovAny_TooltipShowMultiline)
				label:SetScript("OnLeave", MovAny_TooltipHide)
			end
		else
			if row then
				row:Hide()
			end
		end
	end
	
	if not dontUpdate then
		self:UpdateGUIIfShown(true)
	end
end

function MovAny_TooltipShow(a,b,c,d,e)
	MovAny:TooltipShow(a,b,c,d,e)
end

function MovAny_TooltipHide(a,b,c,d,e)
	MovAny:TooltipHide(a,b,c,d,e)
end

function MovAny_TooltipShowMultiline(a,b,c,d,e)
	MovAny:TooltipShowMultiline(a,b,c,d,e)
end

function MovAny:Search(searchWord)
	if searchWord ~= MOVANY.SEARCH_TEXT then
		searchWord = string.gsub(string.gsub(string.lower(searchWord), "([%(%)%%%.%[%]%+%-%?])", "%%%1"), "%*", "[%%w %%c]*")
		if self.searchWord ~= searchWord then
			-- searchWord ~= MOVANY.SEARCH_TEXT
			self.searchWord = searchWord
			self:UpdateGUIIfShown(true)
		end
	else
		self.searchWord = nil
		self:UpdateGUIIfShown()
	end
end

function MovAny_OnEvent(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		--MovAny:SyncFrames()
	elseif event == "ADDON_LOADED" or event == "RAID_ROSTER_UPDATE" then
		MovAny:SyncFrames()
	elseif event == "PLAYER_LOGOUT" then
		MovAny.OnPlayerLogout()
	elseif event == "PLAYER_ENTERING_WORLD" then
		if MovAny.Boot ~= nil then
			MovAny:Boot()
			MovAny.Boot = nil
			MovAny.ParseData = nil
		end
		MovAny:SyncAllFrames()
	elseif event == "PLAYER_FOCUS_CHANGED" then
		if MovAny.frameOptions["FocusFrame"] then
			MovAny.pendingFrames["FocusFrame"] = MovAny.frameOptions["FocusFrame"]
			MovAny:SyncFrames()
		end
	else
		MovAny:SyncAllFrames()
	end
end

function MAMoverTemplate_OnMouseWheel(self, dir)
	MovAny:MoverOnMouseWheel(self, dir)
end

function MANudgeButton_OnClick(self, event, button)
	MovAny:Nudge(self.dir, button)
end

function MANudger_OnMouseWheel(self, dir)
	MovAny:NudgerChangeMover(dir)
end

function MovAny:Serialize(o)
	if type(o) ~= "table" then
		return MovAny:SerializeAtom(o)
	end
	local s = "{"
	if #o > 0 and tlen(o) == #o then
		for i, v in ipairs(o) do
			s = s.."["..i.."]="..MovAny:Serialize(v)..","
		end
	else
		for i, v in pairs(o) do
			if type(i) == "number" then
				s = s.."["..i.."]="..MovAny:Serialize(v)..","
			elseif type(i) == "string" then
				s = s.."[\""..i.."\"]="..MovAny:Serialize(v)..","
			else
				maPrint("non number/string index used in list. skipping")
			end
		end
	end
	s = s.."}"
	return s
end

function MovAny:SerializeAtom(o)
	if type(o) == "nil" then
		return "nil"
	elseif type(o) == "string" then
		return "\""..string.gsub(o, "[\n\r\"]", "\\%1").."\""
	elseif type(o) == "boolean" then
		return o and "true" or "false"
	else
		return o
	end
end