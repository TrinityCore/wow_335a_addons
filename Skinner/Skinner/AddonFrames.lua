
function Skinner:BlizzardFrames()
--    self:Debug("BlizzardFrames")

	local blizzFrames = {
		"CharacterFrames", "PetStableFrame", "SpellBookFrame", "DressUpFrame", "AlertFrames", -- cf1
		"FriendsFrame", "TradeFrame", "ReadyCheck", "Buffs", "VehicleMenuBar", "WatchFrame", "GearManager", --cf2
		"MerchantFrames", "GossipFrame", "TaxiFrame", "QuestFrame", "Battlefields", "ArenaFrame", "ArenaRegistrar", "GuildRegistrar", "Petition", "Tabard", -- npc
		"MirrorTimers", "StaticPopups", "ChatMenus", "ChatTabs", "ChatFrames", "ChatEditBox", "LootFrame", "GroupLoot", "ContainerFrames", "StackSplit", "ItemText", "ColorPicker", "WorldMap", "HelpFrame", "Tutorial", "WorldState", "ScriptErrors", "DropDowns", -- uie1
		"AutoComplete", "MenuFrames", "BankFrame", "MailFrame", "CoinPickup", "PVPFrame", "LFDFrame", "LFRFrame", "BNFrames", -- uie2
	}

	-- optional frames
	if IsMacClient() then self:checkAndRun("MovieProgress") end
	if self.isPTR then tinsert(blizzFrames, "FeedbackUI") else self.FeedbackUI = nil end -- uie1
	-- patched frames

	for _, v in pairs(blizzFrames) do
		self:checkAndRun(v)
	end
	blizzFrames = nil

	-- handle non standard ones here
	self:ScheduleTimer("checkAndRun", 1, "MinimapButtons") -- wait for a second before skinning the minimap buttons
	self:checkAndRun("ChatConfig") -- done here even though it's LoD, as it is always loaded with Blizzard_CombatLog

--[=[
	QuestLog -- checked with EQL3 & QuestGuru below
	CastingBar -- checked with Quartz below
	Tooltips -- checked below
	MainMenuBar -- checked with Bongos below
	Nameplates -- checked with Aloft below
	ModelFrames -- checked with CloseUp below
--]=]

end

local blizzLoDFrames = {
	 "AchievementUI", "BarbershopUI", "BattlefieldMinimap", "BindingUI", "Calendar", "DebugTools", "GlyphUI", "GMChatUI", "GMSurveyUI", "GuildBankUI", "InspectUI", "ItemSocketingUI", "MacroUI", "RaidUI", "TalentUI", "TimeManager", "TradeSkillUI", "TrainerUI",
}
--[=[
	AuctionUI -- loaded when AUCTION_HOUSE_SHOW event is fired
	ArenaUI -- unitframes not currently skinned
	CombatLog -- managed with ChatConfig skin
	CombatText -- nothing to skin
	TokenUI -- part of CharacterFrames skinning process
--]=]
local blizzLoD = {}
for _, v in pairs(blizzLoDFrames) do
	blizzLoD["Blizzard_"..v] = v
end
blizzLoDFrames = nil

Skinner.addonSkins = {
	"_NPCScan",
	"Accomplishment", "Accountant", "Acheron", "AckisRecipeList", "ACP", "AdiBags", "AdvancedTradeSkillWindow", "AlleyMap", "Altoholic", "Analyst", "AnnounceIt", "Ara_Broker_Guild_Friends", "ArkInventory", "ArkInventoryRules", "Armory", "ArmoryGuildBank", "Atlas", "AtlasLoot", "AtlasQuest", "AuctionLite", "Auctionsnatch", "AutoDecline", "AutoPartyButtons", "AutoProfit",
	"Badapples", "Baggins", "Bagnon", "Bagnon_Forever", "BankItems", "BasicChatMods", "BaudBag", "BeanCounter", "beql", "BetterInbox", "BindPad", "BlackList", "BossNotes", "BriefQuestComplete", "Broker_Transport", "Buffalo", "BugSack", "Butsu", "BuyEmAll",
	"CalendarNotify", "CallToArms", "Capping", "Carbonite", "Cauldron", "CFM", "ChatBar", "Chatr", "Chatter", "Chinchilla", "Clique", "CloseUp", "Collectinator", "Combuctor", "ConcessionStand", "Converse", "Cork", "CowTip", "CT_MailMod", "CT_RaidTracker",
	"DaemonMailAssist", "DailiesQuestTracker", "DamageMeters", "Dominos", "DragonCore",
	"EasyUnlock", "EavesDrop", "EditingUI", "EggTimer", "ElitistGroup", "EnchantMe", "EngBags", "EnhancedFlightMap", "EnhancedStackSplit", "EnhancedTradeSkills", "epgp", "EquipCompare", "EventEquip", "EveryQuest", "Examiner", "ExtendedRaidInfo",
	"Factionizer", "FBagOfHolding", "FeedMachine", "FishingBuddy", "FlightMap", "FramesResized", "FreierGeist_InstanceTime",
	"Gatherer", "GearScore", "GemHelper", "GemMe", "GnomeWorks", "GnomishVendorShrinker", "Gobling", "Gossipmonger", "Grid", "GrimReaper", "GroupCalendar", "GroupCalendar5", "GuildAds", "GuildBankAccount", "GuildGreet", "GuildLaunchCT_RaidTracker", "GupCharacter", "GupPet",
	"Hack", "Hadar_FocusFrame", "HatTrick", "HeadCount", "HealBot", "HealOrganizer", "Highlight", "HitsMode", "HoloFriends",
	"InspectEquip", "IntricateChatMods", "InventoryOnPar", "IPopBar", "ItemDB", "ItemRack", "ItemSync",
	"LauncherMenu", "LazyAFK", "LightHeaded", "Links", "LinksList", "LinkWrangler", "Livestock", "Ludwig", "Luggage",
	"MacroBank", "MacroBrokerGUI", "MailTo", "MakeRocketGoNow", "Mapster", "MinimapButtonFrame", "Misdirectionhelper", "MobMap", "MonkeyQuest", "MonkeyQuestLog", "Mountiful", "MoveAnything", "MTLove", "MuffinMOTD", "MyBags", "myClock",
	"NeatFreak", "Necrosis", "NeonChat", "nQuestLog",
	"Odyssey", "Omen", "OneBag3", "OneBank3", "oRA3", "Outfitter", "Overachiever",
	"PallyPower", "Panda", "PartyBuilder", "PassLoot", "Pawn", "Perl_CombatDisplay", "Perl_Focus", "Perl_Party", "Perl_Party_Pet", "Perl_Party_Target", "Perl_Player", "Perl_Player_Pet", "Perl_Target", "Perl_Target_Target", "PetListPlus", "PhoenixStyle", "Planner", "PlayerExpBar", "PlusOneTable", "PoMTracker", "Possessions", "Postal", "PowerAuras", "Producer", "ProfessionsBook", "PvpMessages",
	"Quartz", "Quelevel", "QuestAgent", "QuestGuru", "QuestHelper", "QuestHistory", "QuickMark",
	"RABuffs", "RaidAchievement", "RaidBuffStatus", "RaidTracker", "RaidyCheck", "RandomPet30", "Recap", "RecipeBook", "RecipeRadar", "Recount", "RicoMiniMap",
	"ShadowDancer3", "sienasGemViewer", "Skada", "Skillet", "SmoothQuest", "Spew", "Squeenix", "sRaidFrames",
	"tabDB", "Talented", "TargetAnnounce", "tekBlocks", "tekDebug", "tekErr", "tekPad", "TheCollector", "TinyPad", "TipTac", "tomQuest2", "TomTom", "TooManyAddons", "Toons", "TotemCaddy", "TourGuide", "Tukui", "TwinValkyr_shieldmonitor",
	"UberQuest", "UrbanAchiever",
	"vBagnon", "Vendorizer", "VendorSearch", "Violation", "Visor2GUI", "Volumizer",
	"WebDKP", "WIM", "WoWEquip",
	"xcalc", "XLoot", "XLootGroup", "XLootMonitor", "xMerchant", "XPerl", "XPerl_RaidAdmin", "XPerl_RaidHelper",
	"zfpoison", "ZOMGBuffs"
}
Skinner.oddlyNamedAddons = {
	"!Swatter", "Auc-Advanced", "Auto-Bag", "DBM-Core", "Enchantrix-Barker", "Ogri'Lazy", "Prat-3.0", "WoW-Pro"
}
function Skinner:AddonFrames()
--     self:Debug("AddonFrames")

	-- these addons colour the Tooltip Border
	if IsAddOnLoaded("Chippu")
	or IsAddOnLoaded("TipTac")
	then
	    self.ttBorder = false
	end

    -- skin tooltips here after checking whether the ttBorder setting needed changing
	self:checkAndRun("Tooltips")

	-- skin the QuestLog if EQL3 or QuestGuru aren't loaded
	-- N.B. Do it here as other Addons use the QuestLog size
	if not IsAddOnLoaded("EQL3")
	and not IsAddOnLoaded("QuestGuru")
	then
		self:checkAndRun("QuestLog")
	end

	-- skin the CastingBar if Quartz isn't loaded
	if not IsAddOnLoaded("Quartz") then self:checkAndRun("CastingBar") end

	-- skin the MenuBar if Bongos isn't loaded
	if not IsAddOnLoaded("Bongos")
	and not IsAddOnLoaded("Bongos2")
	then
		self:checkAndRun("MainMenuBar")
	end

	-- skin the Nameplates if other nameplate addons aren't loaded
	if not IsAddOnLoaded("Aloft")
	and not IsAddOnLoaded("nerNameplates")
	and not IsAddOnLoaded("TidyPlates")
	and not IsAddOnLoaded("DocsUI_Nameplates")
	then
		self:checkAndRun("Nameplates")
	end

	--	don't make Model Frames Rotatable if CloseUp is loaded
	if not IsAddOnLoaded("CloseUp") then self:checkAndRun("ModelFrames") end

	-- used for Addons that aren't LoadOnDemand
	for _, v in pairs(self.addonSkins) do
		self:checkAndRunAddOn(v)
	end
	self.addonSkins = nil

	-- handle Addons with odd names here
	for _, v in pairs(self.oddlyNamedAddons) do
		v2, _ = v:gsub("[-_!'\.]", "")
		self:checkAndRunAddOn(v, nil, v2)
	end
	self.oddlyNamedAddons = nil

	-- this addon has a relation
	self:checkAndRunAddOn("EnhancedTradeSkills", nil, "EnhancedTradeCrafts")

	-- skin the Blizzard LoD frames if they have already been loaded by other addons
	for k, v in pairs(blizzLoD) do
		if IsAddOnLoaded(k) then self:checkAndRun(v) end
	end

	-- load MSBTOptions here if FuBar_MSBTFu is loaded
	if IsAddOnLoaded("FuBar_MSBTFu") then
		self:checkAndRunAddOn("MSBTOptions", true) -- use true so it isn't treated as a LoadManaged Addon
	end

	-- skin Dewdrop, Ace2, Tablet, Waterfall, Ace3GUI, LibSimpleOptions, Configator, LibExtraTip, tektip, LibQTip & LibSimpleFrame library objects
	local libsToSkin = {
		["Dewdrop-2.0"] = "Dewdrop",
		["AceAddon-2.0"] = "Ace2",
		["Tablet-2.0"] = "Tablet",
		["Waterfall-1.0"] = "Waterfall",
		["AceGUI-3.0"] = "Ace3",
		["LibSimpleOptions-1.0"] = "LibSimpleOptions",
		["Configator"] = "Configator",
		["LibExtraTip-1"] = "LibExtraTip",
		["tektip-1.0"] = "tektip",
		["LibQTip-1.0"] = "LibQTip",
		["LibSimpleFrame-Mod-1.0"] = "LibSimpleFrame",
	}
	for k, v in pairs(libsToSkin) do
--		self:Debug("skin Libs:[%s, %s]", k, v)
		if LibStub(k, true) then
			if self[v] then self:checkAndRun(v) -- not an addon in its own right
			else
				if self.db.profile.Warnings then
					self:CustomPrint(1, 0, 0, v, "loaded but skin not found in SkinMe directory")
				end
			end
		end
	end
	libsToSkin = nil

	-- skin Rock Config
	if Rock and Rock:HasLibrary("LibRockConfig-1.0") then
		if self.RockConfig then self:checkAndRun("RockConfig") -- not an addon in its own right
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, "RockConfig", "loaded but skin not found in SkinMe directory")
			end
		end
	end

	-- skin KeyboundDialog frame
	if self.db.profile.MenuFrames then
		if LibStub('LibKeyBound-1.0', true) then
			self:skinButton{obj=KeyboundDialogOkay} -- this is a CheckButton object
			self:skinButton{obj=KeyboundDialogCancel} -- this is a CheckButton object
			self:addSkinFrame{obj=KeyboundDialog, kfs=true, y1=4, y2=6}
		end
	end

	-- skin tekKonfig library objects
	if self.tekKonfig then self:checkAndRun("tekKonfig") end -- not an addon in its own right

end

local lodFrames = {
	"Altoholic_Achievements", "AzCastBarOptions",
	"Bagnon", "Bagnon_Options", "Banknon", "BetterBindingFrame",
	"DockingStation_Config", "Dominos_Config", "DoTimer_Options",
	"Enchantrix", "EnhTooltip",
	"FramesResized_TalentUI",
	"GnomishAuctionShrinker", "GuildBankSearch",
	"ItemRackOptions",
	"LilSparkysWorkshop",
	"MrTrader_SkillWindow", "MSBTOptions",
	"oRA2_Leader", "oRA2_Participant", "Overachiever_Tabs",
	"Perl_Config_Options", "PhoenixStyleMod_Coliseum", "PhoenixStyleMod_Ulduar", "PhoenixStyleMod_Icecrown",
	"RaidAchievement_Icecrown", "RaidAchievement_Naxxramas", "RaidAchievement_Ulduar", "RaidAchievement_WotlkHeroics",
	"Talented_GlyphFrame", "TradeTabs", "TipTacOptions",
	"WIM_Options",
	"XPerl_Options",
	"ZOMGBuffs_BlessingsManager",
}
Skinner.lodAddons = {}
for _, v in pairs(lodFrames) do
	Skinner.lodAddons[v] = v
end
lodFrames = nil
for i = 1, 8 do
	Skinner.lodAddons["MobMapDatabaseStub"..i] = "MobMapDatabaseStub"..i
end
Skinner.lodAddons["MobMapDatabaseStub6"] = nil -- ignore stub6

function Skinner:LoDFrames(addon)
--    self:Debug("LoDFrames: [%s]", addon)

	if addon == prev_addon then return end
	local prev_addon = addon

	-- used for Blizzard LoadOnDemand Addons
	if blizzLoD[addon] then self:checkAndRun(blizzLoD[addon]) end

	-- used for User LoadOnDemand Addons
	if self.lodAddons[addon] then self:checkAndRunAddOn(self.lodAddons[addon], true) end

	-- handle renamed DBM-GUI addon
	if addon == "DBM-GUI" then
		self:checkAndRunAddOn(addon, true, "DBM_GUI")
	end

	-- handle addons linked to the InspectUI
	if addon == "Blizzard_InspectUI" then
		--	This addon is dependent upon the Inspect Frame
		self:checkAndRunAddOn("Spyglass")
	end

	-- deal with Addons under the control of an LoadManager
	-- use lowercase addonname (lazyafk issue)
	if self.lmAddons[addon:lower()] then
		self:checkAndRunAddOn(addon, true, self.lmAddons[addon:lower()])
		self.lmAddons[addon:lower()] = nil
	end

	-- handle FramesResized changes
	if IsAddOnLoaded("FramesResized") then
		if addon == "Blizzard_TradeSkillUI" and self.FR_TradeSkillUI then self:checkAndRun("FR_TradeSkillUI") -- not an addon in its own right
		elseif addon == "Blizzard_TrainerUI" and self.FR_TrainerUI then self:checkAndRun("FR_TrainerUI") -- not an addon in its own right
		end
	end

end

function Skinner:ADDON_LOADED(event, addon)
--	self:Debug("ADDON_LOADED: [%s]", addon)

	self:ScheduleTimer("LoDFrames", self.db.profile.Delay.LoDs, addon)

end

function Skinner:AUCTION_HOUSE_SHOW()
--	self:Debug("AUCTION_HOUSE_SHOW")

	self:checkAndRun("AuctionUI")
	-- trigger these when AH loads otherwise errors occur
	self:checkAndRunAddOn("BtmScan")
	self:checkAndRunAddOn("AuctionFilterPlus")
	self:checkAndRunAddOn("Auctionator")

	self:UnregisterEvent("AUCTION_HOUSE_SHOW")

end
