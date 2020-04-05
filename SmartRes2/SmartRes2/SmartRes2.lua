--- SmartRes2
-- @class file
-- @name SmartRes2.lua
-- @author Myrroddin of Llane

-- localise global variables for faster access ------------------------------
local _G = getfenv(0)
local string = _G.string
local table = _G.table
local tinsert = table.insert
local tremove = table.remove
local tsort = table.sort
local wipe = table.wipe
local pairs = _G.pairs
local ipairs = _G.ipairs

-- Upvalued Blizzard API ----------------------------------------------------
local GetAddOnMetadata = _G.GetAddOnMetadata
local GetNumRaidMembers = _G.GetNumRaidMembers
local GetNumPartyMembers = _G.GetNumPartyMembers
local GetSpellInfo = _G.GetSpellInfo
local IsSpellInRange = _G.IsSpellInRange
local SendChatMessage = _G.SendChatMessage
local UnitCastingInfo = _G.UnitCastingInfo
local UnitClass = _G.UnitClass
local UnitInRaid = _G.UnitInRaid
local UnitInRange = _G.UnitInRange
local UnitIsDead = _G.UnitIsDead
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local UnitIsGhost = _G.UnitIsGhost
local UnitIsUnit = _G.UnitIsUnit
local UnitLevel = _G.UnitLevel
local UnitName = _G.UnitName

-- declare addon ------------------------------------------------------------
local LibStub = _G.LibStub

local SmartRes2 = LibStub("AceAddon-3.0"):NewAddon("SmartRes2", "AceConsole-3.0", "AceEvent-3.0", "LibBars-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("SmartRes2", true)

-- get version from .toc - set to Development if no version
local version = GetAddOnMetadata("SmartRes2", "Version")

-- add localisation to addon
SmartRes2.L = L
-- declare the database
local db
-- additional libraries -----------------------------------------------------
-- LibDataBroker used for LDB enabled addons like ChocolateBars
local DataBroker = LibStub:GetLibrary("LibDataBroker-1.1")
-- LibBars used for bars
local Bars = LibStub:GetLibrary("LibBars-1.0")
-- LibResComm used for communication
local ResComm, ResCommMinor = LibStub:GetLibrary("LibResComm-1.0")
if ResCommMinor < 90051 then
	StaticPopupDialogs["SMARTRES2_ERROR_FRAME"] = {
		text = L["SmartRes2 works best with LibResComm-1.0 version r51 or newer. Please update at wowace.com"],
		button1 = L["OK"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	StaticPopup_Show("SMARTRES2_ERROR_FRAME");
end

-- LibSharedMedia used for more textures
local Media = LibStub:GetLibrary("LibSharedMedia-3.0")
-- register the res bar textures with LibSharedMedia-3.0
Media:Register("statusbar", "Blizzard", [[Interface\TargetingFrame\UI-StatusBar]])

-- local variables ----------------------------------------------------------
local doingRessing = {}
local waitingForAccept = {}
local resBars = {}
local orientation
local icon
local LastRes

-- variable to use for multiple PLAYER_REGEN_DISABLED calls (see SmartRes2:PLAYER_REGEN_DISABLED below)
local in_combat = false

-- addon defaults -----------------------------------------------------------
local defaults = {
	profile = {
		autoResKey = "",
		barHeight = 16,
		barWidth = 128,
		borderThickness = 10,
		chatOutput = "0-none",
		classColours = true,
		collisionBarsColour = { r = 1, g = 0, b = 0, a = 1 },
		enableAddon = true,
		fontFlags = "0-nothing",
		fontScale = 12,
		fontType = "Friz Quadrata TT",
		guessResses = true,
		hideAnchor = true,
		horizontalOrientation = "RIGHT",
		manualResKey = "",
		notifyCollision = "0-off",
		notifySelf = true,
		randMsgs = false,
		customchatmsg = "",
		resBarsColour = { r = 0, g = 1, b = 0, a = 1 },
		resBarsIcon = true,		
		resBarsAlpha = 1,
		resBarsBorder = nil,
		resBarsTexture = "Blizzard",
		resBarsX = 0,
		resBarsY = 600,
		reverseGrowth = false,
		scale = 1,
		showBattleRes = false,		
		visibleResBars = true,
		waitingBarsColour = { r = 0, g = 0, b = 1, a = 1 }
	}
}

-- standard methods ---------------------------------------------------------

function SmartRes2:OnInitialize()
	-- register saved variables with AceDB
	db = LibStub("AceDB-3.0"):New("SmartRes2DB", defaults, "Default")
	db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileReset", "OnNewProfile")
	db.RegisterCallback(self, "OnNewProfile", "OnNewProfile")
	defaults = nil -- done with the table, so get rid of it
	self.db = db
	self:FillRandChatDefaults()	
	
	-- prepare spells
	local resSpells = { -- getting the spell names
		PRIEST = GetSpellInfo(2006), -- Resurrection
		SHAMAN = GetSpellInfo(2008), -- Ancestral Spirit
		DRUID = GetSpellInfo(50769), -- Revive
		PALADIN = GetSpellInfo(7328) -- Redemption
	}
	self.resSpellIcons = { -- need the icons too, for the res bars
		PRIEST = select(3, GetSpellInfo(2006)), 	-- Resurrection
		SHAMAN = select(3, GetSpellInfo(2008)), 	-- Ancestral Spirit
		DRUID = select(3, GetSpellInfo(50769)), 	-- Revive
		PALADIN = select(3, GetSpellInfo(7328)) 	-- Redemption
	}  
	self.playerClass = select(2, UnitClass("player"))
	self.playerSpell = resSpells[self.playerClass]

	-- addon options table
	local options = {
		name = "SmartRes2",
		handler = SmartRes2,
		type = "group",
		childGroups = "tab",
		args = {
			barsOptionsTab = {
				name = L["Res Bars"],
				desc = L["Options for the res bars"],
				type = "group",
				order = 1,
				args = {
					barsOptionsHeader = {
						order = 1,
						type = "header",
						name = L["Res Bars"]
					},
					hideAnchor = {
						order = 20,
						type = "toggle",
						name = L["Hide Anchor"],
						desc = L["Toggles the anchor for the res bars so you can move them"],
						get = function() return self.db.profile.hideAnchor end,
						set = function(info, value)
							self.db.profile.hideAnchor = value
							if value then
								self.res_bars:HideAnchor()
								self.res_bars:Lock()
							else
								self.res_bars:ShowAnchor()
								self.res_bars:Unlock()
								self.res_bars:SetClampedToScreen(true)
							end
						end
					},
					enableAddon = {
						order = 30,
						type = "toggle",
						name = L["Enable SmartRes2"],
						desc = L["Uncheck to disable Smartres2"],
						get = function() return self.db.profile.enableAddon end,
						set = function(info, value)
							self.db.profile.enableAddon = value
							if value then
								self:Enable()
							else
								self:Disable()
							end
						end
					},					
					visibleResBars = { 
						order = 40,
						type = "toggle",
						name = L["Show Bars"],
						desc = L["Show or hide the res bars. Everything else will still work"],
						get = function() return self.db.profile.visibleResBars end,
						set = function(info, value) self.db.profile.visibleResBars = value end
					},
					guessResses = {
						order = 45,
						type = "toggle",
						name = L["Non-CTRA compatible res monitoring"],
						desc = L["Picks up res casts that are not broadcast via LibResComm or CTRA. This could have erroneous results, especially with mouseover or click casting"],
						get = function() return self.db.profile.guessResses end,
						set = function(info, value) self.db.profile.guessResses = value
							if self.db.profile.guessResses then
								self:StartGuessing()
							else
								self:StopGuessing()
							end
						end
					},
					reverseGrowth = {
						order = 50,
						type = "toggle",
						name = L["Grow Upwards"],
						desc = L["Make the res bars grow up instead of down"],
						get = function() return self.db.profile.reverseGrowth end,
						set = function(info, value)
							self.db.profile.reverseGrowth = value
							self.res_bars:ReverseGrowth(value)
						end
					},					
					resBarsIcon = {
						order = 60,
						type = "toggle",
						name = L["Show Icon"],
						desc = L["Show or hide the icon for res spells"],
						get = function() return	self.db.profile.resBarsIcon end,
						set = function(info, value)
							self.db.profile.resBarsIcon = value
							if value then
								self.res_bars:ShowIcon()
							else
								self.res_bars:HideIcon()
							end
						end
					},					
					showBattleRes = {
						order = 70,
						type = "toggle",
						name = L["Show Battle Resses"],
						desc = L["Show bars for Rebirth"],
						get = function() return self.db.profile.showBattleRes end,
						set = function(info, value)	self.db.profile.showBattleRes = value end
					},					
					classColours = {
						order = 80,
						type = "toggle",
						name = L["Class Colours"],
						desc = L["Use class colours for the target on the res bars"],
						get = function() return self.db.profile.classColours end,
						set = function(info, value)	self.db.profile.classColours = value end
					},
					barHeight = {
						order = 83,
						type = "range",
						name = L["Bar Height"],
						desc = L["Control the height of the res bars"],
						get = function() return self.db.profile.barHeight end,
						set = function(info, value)
							self.db.profile.barHeight = value
							self.res_bars:SetHeight(value)
						end,
						min = 6,
						max = 64,
						step = 1
					},
					barWidth = {
						order = 87,
						type = "range",
						name = L["Bar Width"],
						desc = L["Control the width of the res bars"],
						get = function() return self.db.profile.barWidth end,
						set = function(info, value)
							self.db.profile.barWidth = value
							self.res_bars:SetWidth(value)
						end,
						min = 24,
						max = 512,
						step = 1
					},
					scale = {
						order = 90,
						type = "range",
						name = L["Scale"],
						desc = L["Set the scale for the res bars"],
						get = function() return self.db.profile.scale end,
						set = function(info, value)
							self.db.profile.scale = value
							self.res_bars:SetScale(value)
						end,
						min = 0.5,
						max = 2,
						step = 0.05
					},
					resBarsAlpha = {
						order = 100,
						type = "range",
						name = L["Alpha"],
						desc = L["Set the Alpha for the res bars"],
						get = function() return self.db.profile.resBarsAlpha end,
						set = function(info, value)
							self.db.profile.resBarsAlpha = value
							self.res_bars:SetAlpha(value)
						end,
						min = 0.1,
						max = 1,
						step = 0.1
					},
					borderThickness = {
						order = 110,
						type = "range",
						name = L["Border Thickness"],
						desc = L["Set the thickness of the res bars border"],
						get = function() return self.db.profile.borderThickness end,
						set = function(info, value) self.db.profile.borderThickness = value end,
						min = 1,
						max = 10,
						step = 1
					},
					resBarsTexture = {
						order = 120,
						type = "select",
						dialogControl = "LSM30_Statusbar",
						name = L["Texture"],
						desc = L["Select the texture for the res bars"],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function() return self.db.profile.resBarsTexture end,
						set = function(info, value)	self.db.profile.resBarsTexture = value end
					},
					resBarsBorder = {
						order = 130,
						type = "select",
						dialogControl = "LSM30_Border",
						name = L["Border"],
						desc = L["Select the border for the res bars"],
						values = AceGUIWidgetLSMlists.border,
						get = function() return self.db.profile.resBarsBorder end,
						set = function(info, value) self.db.profile.resBarsBorder = value end
					},					
					horizontalOrientation = {
						order = 140,
						type = "select",
						name = L["Horizontal Direction"],
						desc = L["Change the horizontal direction of the res bars"],
						values = {
							["LEFT"] = L["Right to Left"],
							["RIGHT"] = L["Left to Right"]
						},
						get = function() return self.db.profile.horizontalOrientation end,
						set = function(info, value) self.db.profile.horizontalOrientation = value end
					},
					resBarsColour = {
						order = 150,
						type = "color",
						name = L["Bar Colour"],
						desc = L["Pick the colour for non-collision (not a duplicate) res bar"],
						hasAlpha = true,
						get = function()
							local t = self.db.profile.resBarsColour
							return t.r, t.g, t.b, t.a
						end,
						set = function(info, r, g, b, a)
							local t = self.db.profile.resBarsColour
							t.r, t.g, t.b, t.a = r, g, b, a
						end
					},
					collisionBarsColour = {
						order = 160,
						type = "color",
						name = L["Duplicate Bar Colour"],
						desc = L["Pick the colour for collision (duplicate) res bars"],
						hasAlpha = true,
						get = function()
							local t = self.db.profile.collisionBarsColour
							return t.r, t.g, t.b, t.a
						end,
						set = function(info, r, g, b, a)
							local t = self.db.profile.collisionBarsColour
							t.r, t.g, t.b, t.a = r, g, b, a
						end
					},
					waitingBarsColour = {
						order = 170,
						type = "color",
						name = L["Waiting Bar Colour"],
						desc = L["Pick the colour for collision (player waiting for accept) res bars"],
						hasAlpha = true,
						get = function()
							local t = self.db.profile.waitingBarsColour
							return t.r, t.g, t.b, t.a
						end,
						set = function(info, r, g, b, a)
							local t = self.db.profile.waitingBarsColour
							t.r, t.g, t.b, t.a = r, g, b, a
						end
					},
					resBarsTestBars = {
						order = 200,
						type = "execute",
						name = L["Test Bars"],
						desc = L["Show the test bars"],
						func = function() self:StartTestBars() end
					}
				}
			},
			resChatTextTab = {
				name = L["Chat Output"],
				desc = L["Chat output options"],
				type = "group",
				order = 20,
				args = {
					resChatHeader = {
						order = 1,
						type = "header",
						name = L["Chat Output"]
					},
					randMsgs = {
						order = 20,
						type = "toggle",
						name = L["Random Res Messages"],
						desc = L["Turn random res messages on or keep the same message. Default is off"],
						get = function() return self.db.profile.randMsgs end,
						set = function(info, value)	self.db.profile.randMsgs = value end
					},
					notifySelf = {
						order = 30,
						type = "toggle",
						name = L["Self Notification"],
						desc = L["Prints a message to yourself whom you are ressing"],
						get = function() return self.db.profile.notifySelf end,
						set = function(info, value)	self.db.profile.notifySelf = value end
					},
					chatOutput = {
						order = 40,
						type = "select",
						name = L["Chat Output Type"],
						desc = L["Where to print the res message. Raid, Party, Say, Yell, Guild, smart Group, or None"],
						values = {
							["0-none"] = L["None"],
							group = L["Group"],
							guild = L["Guild"],
							party = L["Party"],
							raid = L["Raid"],
							say = L["Say"],
							whisper = L["Whisper"],
							yell = L["Yell"]							
						},
						get = function() return self.db.profile.chatOutput end,
						set = function(info, value)	self.db.profile.chatOutput = value end
					},					
					notifyCollision = {
						order = 50,
						type = "select",
						name = L["Duplicate Res Targets"],
						desc = L["Notify a resser they created a collision. Could get very spammy"],
						values = {
							["0-off"] = L["Off"],
							group = L["Group"],
							guild = L["Guild"],
							party = L["Party"],
							raid = L["Raid"],
							say = L["Say"],
							whisper = L["Whisper"],
							yell = L["Yell"]
						},
						get = function() return self.db.profile.notifyCollision end,
						set = function(info, value)	self.db.profile.notifyCollision = value	end
					},
					customMessage = {
						order = 60,
						type = "input",
						name = L["Custom Message"],
						desc = L["Your message.  Use 'me' for yourself and 'you' for target"],
						get = function() return self.db.profile.customchatmsg end,
						set = function(info, value) self:AddCustomMsg(value) end
					},
					addRndMessage = {
						order = 70,
						type = "input",
						name = L["Add to Random Table"],
						desc = L["ADD_OUTPUT_KEY"],
						get = function() return "" end,
						set = function(info, value)
							-- Insert non-empty values into the table
							if value and value:trim() ~= "" then
								tinsert(self.db.profile.randChatTbl, value) 
							end
						end
					},
					removeRndMessge = {
						order = 80,
						type = "multiselect",
						dialogControl = "Dropdown",
						name = L["Remove Random Messages"],
						desc = L["Remove messages from the table you no longer want"],
						width = "double",
						values = function()
							-- Return the list of values
							return self.db.profile.randChatTbl
						end,
						get = function(info, index)
							-- All values are always enabled
							return true
						end,
						set = function(info, index, value)
							-- The only possible value for "value" is false (because get always returns true), so we don't bother checking it and remove the entry from the table
							tremove(self.db.profile.randChatTbl, index)
						end
					}
				}
			},
			fontTab = {
				name = L["Fonts"],
				desc = L["Control fonts on the res bars"],
				type = "group",
				order = 25,
				args = {
					fontType = {
						order = 1,
						type = "select",
						dialogControl = "LSM30_Font",
						name = L["Font Type"],
						desc = L["Select a font for the text on the res bars"],
						values = AceGUIWidgetLSMlists.font,
						get = function() return self.db.profile.fontType end,
						set = function(info, value) self.db.profile.fontType = value end					
					},
					fontFlags = {
						order = 25,
						type = "select",
						name = L["Font Style"],
						desc = L["Nothing, outline, thick outline, or monochrome"],						
						values = {
							["0-nothing"] = L["Nothing"],
							outline = L["Outline"],
							thickOut = L["THICK_OUTLINE"],
							monoChrome = L["Monochrome"]
						},
						get = function() return self.db.profile.fontFlags end,
						set = function(info, value) self.db.profile.fontFlags = value end
					},					
					fontSize = {
						order = 20,
						type = "range",
						name = L["Font Scale"],
						desc = L["Resize the res bars font"],
						get = function() return self.db.profile.fontScale end,
						set = function(info, value) self.db.profile.fontScale = value end,
						min = 3,
						max = 20,
						step = 1
					}
				}			
			},
			keyBindingsTab = {
				name = L["Key Bindings"],
				desc = L["Set the keybindings"],
				type = "group",
				order = 30,
				args = {
					autoResKey = {
						order = 1,
						type = "keybinding",
						name = L["Auto Res Key"],
						desc = L["For ressing targets who have not released their ghosts"],
						get = function() return self.db.profile.autoResKey end,
						set = function(info, value)	self.db.profile.autoResKey = value end
					},
					manualResKey = {
						order = 2,
						type = "keybinding",
						name = L["Manual Target Key"],
						desc = L["Gives you the pointer to click on corpses"],
						get = function() return self.db.profile.manualResKey end,
						set  = function(info, value) self.db.profile.manualResKey = value end
					},
					castCommand = {
						order = 3,
						type = "description",
						name = L["The command \"cast\" will fire the smart Resurrection function. Usage: /sr cast or /smartres cast. Not necessary if you use the auto res key"]
					}
				}
			},
			creditsTab = {
				name = L["SmartRes2 Credits"],
				desc = L["About the author and SmartRes2"],
				type = "group",
				order = 60,
				args = {
					creditsHeader1 = {
						order = 1,
						type = "header",
						name = L["Credits"]
					},
					creditsDesc1 = {
						order = 2,
						type = "description",
						name = "* "..L["Massive kudos to Maia, Kyahx, and Poull for the original SmartRes. SmartRes2 was largely possible because of DathRarhek's LibResComm-1.0 so a big thanks to him."]
					},
					creditsDesc2 = {
						order = 3,
						type = "description",
						name = "* "..L["I would personally like to thank Jerry on the wowace forums for coding the new, smarter, resurrection function."]
					},
					creditsDesc3 = {
						order = 4,
						type = "description",
						name = "* "..L["Many bugfixes and development help from Onaforeignshore"]
					},
					creditsDesc5 = {
						order = 5,
						type = "description",
						name = "* "..L["Thank you translators!"]
					}
				}
			}
		}
	}
	-- add the 'Profiles' section
	options.args.profilesTab = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	options.args.profilesTab.order = 50

	-- Register your options with AceConfigRegistry
	LibStub("AceConfig-3.0"):RegisterOptionsTable("SmartRes2", options)

	-- Add your options to the Blizz options window using AceConfigDialog
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SmartRes2", "SmartRes2")	

	-- support for LibAboutPanel
	if LibStub:GetLibrary("LibAboutPanel", true) then
		self.optionsFrame[L["About"]] = LibStub("LibAboutPanel").new("SmartRes2", "SmartRes2")
	end

	-- add console commands
	self:RegisterChatCommand("sr", "SlashHandler")
	self:RegisterChatCommand("smartres", "SlashHandler")	
	
	-- create DataBroker Launcher
	if DataBroker then
		local launcher = DataBroker:NewDataObject("SmartRes2", {
			type = "launcher",
			icon = self.resSpellIcons[self.playerClass] or self.resSpellIcons.PRIEST,
			OnClick = function(clickedframe, button)
				if button == "LeftButton" then
					-- keep our options table in sync with the ldb object state
					self.db.profile.hideAnchor = not self.db.profile.hideAnchor
					if self.db.profile.hideAnchor then
						self.res_bars:HideAnchor()
						self.res_bars:Lock()
					else
						self.res_bars:ShowAnchor()
						self.res_bars:Unlock()
						self.res_bars:SetClampedToScreen(true)
					end
					LibStub("AceConfigRegistry-3.0"):NotifyChange("SmartRes2")
				elseif button == "RightButton" then
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
				elseif button == "MiddleButton" then
					self:StartTestBars()
				end
			end,
			OnTooltipShow = function(self)
			GameTooltip:AddLine("SmartRes2".." "..version, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			GameTooltip:AddLine(L["Left click to lock/unlock the res bars. Right click for configuration."].."\n"..L["Middle click for Test Bars."], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			GameTooltip:Show()
		end})
		self.launcher = launcher
	end	

	-- create a secure button for ressing
	local resButton = CreateFrame("button", "SmartRes2Button", UIParent, "SecureActionButtonTemplate")
	resButton:SetAttribute("type", "spell")
	resButton:SetScript("PreClick", function() self:Resurrection() end)
	self.resButton = resButton

	-- create the Res Bars and set the user preferences
	self.res_bars = self:NewBarGroup("SmartRes2", self.db.horizontalOrientation, 300, 15, "SmartRes2_ResBars")
	self.res_bars:SetPoint("CENTER", UIParent, "CENTER", self.db.profile.resBarsX, self.db.profile.resBarsY)
	self.res_bars:SetUserPlaced(true)
	if self.db.profile.hideAnchor then
		self.res_bars:HideAnchor()
		self.res_bars:Lock()
	else
		self.res_bars:ShowAnchor()
		self.res_bars:Unlock()
		self.res_bars:SetClampedToScreen(true)
	end
	
	self.db.profile.disableAddon = nil -- do not need this as of 2.1.1 or higher
end

function SmartRes2:OnEnable()
	-- called when SmartRes2 is enabled
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	Media.RegisterCallback(self, "OnValueChanged", "UpdateMedia")
	ResComm.RegisterCallback(self, "ResComm_ResStart")
	ResComm.RegisterCallback(self, "ResComm_ResEnd")
	ResComm.RegisterCallback(self, "ResComm_Ressed")
	ResComm.RegisterCallback(self, "ResComm_ResExpired")
	self.res_bars.RegisterCallback(self, "FadeFinished")
	self.res_bars.RegisterCallback(self, "AnchorMoved", "ResAnchorMoved")
	self:BindKeys()
	if self.db.profile.guessResses then
		self:StartGuessing()
	end
end

-- process slash commands ---------------------------------------------------
function SmartRes2:SlashHandler(input)
	input = input:lower()
	if input == "cast" then
		self:Resurrection()
	else
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	end
end

-- disable SmartRes2 completely ----------------------------------------------
function SmartRes2:OnDisable()
	self:UnBindKeys()
	self:UnregisterAllEvents()
	Media.UnregisterAllCallbacks(self)
	ResComm.UnregisterAllCallbacks(self)
	self.res_bars.UnregisterAllCallbacks(self)
	wipe(doingRessing)
	wipe(waitingForAccept)
	wipe(resBars)
	LastRes = nil
end

-- General callback functions -----------------------------------------------

function SmartRes2:FillRandChatDefaults()
	if self.db.profile.randChatTbl then return end
		
	self.db.profile.randChatTbl = {}
	local randomMessages = {
		[1] = L["%%p%% is bringing %%t%% back to life!"],
		[2] = L["Filthy peon! %%p%% has to resurrect %%t%%!"],
		[3] = L["%%p%% has to wake %%t%% from eternal slumber."],
		[4] = L["%%p%% is ending %%t%%'s dirt nap."],
		[5] = L["No fallen heroes! %%p%% needs %%t%% to march forward to victory!"],
		[6] = L["%%p%% doesn't think %%t%% is immortal, but after this res cast, it is close enough."],
		[7] = L["Sleeping on the job? %%p%% is disappointed in %%t%%."],
		[8] = L["%%p%% knew %%t%% couldn't stay out of the fire. *Sigh*"],
		[9] = L["Once again, %%p%% pulls %%t%% and their bacon out of the fire."],
		[10] = L["%%p%% thinks %%t%% should work on their Dodge skill."],
		[11] = L["%%p%% refuses to accept blame for %%t%%'s death, but kindly undoes the damage."],
		[12] = L["%%p%% grabs a stick. A-ha! %%t%% was only temporarily dead."],
		[13] = L["%%p%% is ressing %%t%%"],
		[14] = L["%%p%% knows %%t%% is faking. It was only a flesh wound!"],
		[15] = L["Oh. My. God. %%p%% has to breathe life back into %%t%% AGAIN?!?"],
		[16] = L["%%p%% knows that %%t%% dying was just an excuse to see another silly random res message."],
		[17] = L["Think that was bad? %%p%% proudly shows %%t%% the scar tissue caused by Hogger."],
		[18] = L["Just to be silly, %%p%% tickles %%t%% until they get back up."],
		[19] = L["FOR THE HORDE! FOR THE ALLIANCE! %%p%% thinks %%t%% should be more concerned about yelling FOR THE LICH KING! and prevents that from happening."],
		[20] = L["And you thought the Scourge looked bad. In about 10 seconds, %%p%% knows %%t%% will want a comb, some soap, and a mirror."],
		[21] = L["Somewhere, the Lich King is laughing at %%p%%, because he knows %%t%% will just die again eventually. More meat for the grinder!!"],
		[22] = L["%%p%% doesn't want the Lich King to get another soldier, so is bringing %%t%% back to life."],
		[23] = L["%%p%% wonders about these stupid res messages. %%t%% should just be happy to be alive."],
		[24] = L["%%p%% prays over the corpse of %%t%%, and a miracle happens!"],
		[25] = L["In a world of resurrection spells, why are NPC deaths permanent? It doesn't matter, since %%p%% is making sure %%t%%'s death isn't permanent."],
		[26] = L["%%p%% performs a series of lewd acts on %%t%%'s still warm corpse. Ew."]
	}
	for idx, message in ipairs(randomMessages) do
		tinsert(self.db.profile.randChatTbl, message)
	end
end

-- called when new profile is created
function SmartRes2:OnNewProfile()
	self:FillRandChatDefaults()
end

-- called when user changes profile
function SmartRes2:OnProfileChanged()
	db = self.db
	self:FillRandChatDefaults()
end

-- called when user changes the texture of the bars
function SmartRes2:UpdateMedia(callback, type, handle)
	local flags = self.db.profile.fontFlags:upper()
	if flags == "0-NOTHING" then
		flags = nil
	elseif flags == thickOut then
		flags = "THICKOUTLINE"
	end
	if type == "statusbar" then
		self.res_bars:SetTexture(Media:Fetch("statusbar", self.db.profile.resBarsTexture))
	elseif type == "border" then
		self.res_bars:SetBackdrop({
			edgeFile = Media:Fetch("border", self.db.profile.resBarsBorder),
			tile = false,
			tileSize = self.db.profile.scale + 1,
			edgeSize = self.db.profile.borderThickness,
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
	elseif type == "font" then
		self.res_bars:SetFont(Media:Fetch("font", self.db.profile.fontType), self.db.profile.fontScale, flags)
	end
end

function SmartRes2:AddCustomMsg(msg)
	msg = string.gsub(msg, "me", "%%%%p%%%%")
	msg = string.gsub(msg, "you", "%%%%t%%%%")
	self.db.profile.customchatmsg = msg
end

function SmartRes2:StartGuessing()
	if in_combat and not self.db.profile.showBattleRes then return end
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
end

function SmartRes2:StopGuessing()
	self:UnregisterEvent("UNIT_SPELLCAST_START")
	self:UnregisterEvent("UNIT_SPELLCAST_STOP")
	self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
	self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
end

-- ResComm library callback functions ---------------------------------------

function SmartRes2:CheckResTarget(target, newsender)
	for sender, info in pairs(doingRessing) do
		if info.target == target and sender ~= newsender then return sender end
	end
	return nil
end

-- ResComm events - called when res is started
function SmartRes2:ResComm_ResStart(event, sender, endTime, target)
	-- check if we have the person in our table yet, and if not, add them
	if doingRessing[sender] then return end
	
	doingRessing[sender] = {
		endTime = endTime,
		target = target
	}
	self:CreateResBar(sender)

	if waitingForAccept[target] then
		self:AddWaitingBars(sender, target)
	end

	local oldsender = self:CheckResTarget(target, sender) 
	if oldsender then	--target already being ressed
		self:AddCollisionBars(sender, target, oldsender)
	end
	
	-- make sure only the player is sending messages
	if not UnitIsUnit(sender, "player")	then return end

	local name, realm = UnitName(target)
	if name == "Myrroddin" or name == "Jelia" or name == "Badash" or name == "Vanhoeffen" and realm == "Llane" then
		self:Print("You are ressing the Creator!!")
	end
	local channel = self.db.profile.chatOutput:upper()

	if channel == "GROUP" then
		if UnitInRaid("player") then
			channel = "RAID"
		elseif GetNumPartyMembers() > 0 then
			channel = "PARTY"
		end
	end

	if channel ~= "0-NONE" then -- if it is "none" then don't send any chat messages
		local msg = L["%%p%% is ressing %%t%%"]

		if self.db.profile.randMsgs then
			msg = self.db.profile.randChatTbl[math.random(#self.db.profile.randChatTbl)]
		elseif self.db.profile.customchatmsg ~= "" then
			msg = self.db.profile.customchatmsg
		end
		msg = string.gsub(msg, "%%%%p%%%%", sender)
		msg = string.gsub(msg, "%%%%t%%%%", target)

		SendChatMessage(msg, channel, nil, (channel == "WHISPER") and target or nil)
	end
	if self.db.profile.notifySelf then
		self:Print((L["You are ressing %s"]):format(target))
	end
end

-- ResComm events - called when res ends or is cancelled
function SmartRes2:ResComm_ResEnd(event, sender, target, complete)
	-- did the cast fail or complete? mystery.
	if not doingRessing[sender] then return end
	
	self:DeleteResBar(sender)
	-- add the target to our waiting list, and save who the last person to res him was
	if complete then
		waitingForAccept[target] = doingRessing[sender].endTime
	end
	doingRessing[sender] = nil
		
	if self.db.profile.visibleResBars then 
		local oldsender = self:CheckResTarget(target, sender) 
		if oldsender and not self:CheckResTarget(target, oldsender) then	--collision bar existed and only 1 exists
			self:DeleteCollisionBars(sender, target, oldsender)
		end
	end
end

-- ResComm events - called when cast is complete (res dialog shown)
function SmartRes2:ResComm_Ressed(event, target)
	-- target ressed, add to list
	waitingForAccept[target] = GetTime()
end

-- ResComm events - called when res box disappears or player declines res
function SmartRes2:ResComm_ResExpired(event, target)
	-- target declined, remove from list
	waitingForAccept[target] = nil
end

do
	local otherResSpells = {
		[(GetSpellInfo(2006))] = true, --Resurrection
		[(GetSpellInfo(2008))] = true, --Ancestral Spirit
		[(GetSpellInfo(7328))] = true, --Redemption
		[(GetSpellInfo(50769))] = true, --Revive
		[(GetSpellInfo(20484))] = true, --Rebirth
		[(GetSpellInfo(8342))] = true, --Defibrillate (Goblin Jumper Cables)
		[(GetSpellInfo(22999))] = true, -- Defibrillate (Goblin Jumper Cables XL)
		[(GetSpellInfo(54732))] = true -- Defribillate (Gnomish Army Knife)
	}

	function SmartRes2:UNIT_SPELLCAST_START(_, unit, spellName)
		if not otherResSpells[spellName] or UnitIsUnit(unit, "player") or doingRessing[UnitName(unit)] then return end
		
		local spell, _, _, _, startTime, endTime = UnitCastingInfo(unit)
		local sender = UnitName(unit)
		local target = UnitName(unit .. "target")
		if spell and target and UnitIsDeadOrGhost(target) then
			self:ResComm_ResStart(nil, sender, (endTime / 1000), target)
		end
	end

	function SmartRes2:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName)
		if UnitIsUnit(unit, "player") or not doingRessing[UnitName(unit)] then return end
		
		local sender = UnitName(unit)
		self:ResComm_ResEnd(nil, sender, doingRessing[sender].target, true)
	end

	function SmartRes2:UNIT_SPELLCAST_STOP(_, unit)
		if UnitIsUnit(unit, "player") or not doingRessing[UnitName(unit)] then return end
		
		local sender = UnitName(unit)
		self:ResComm_ResEnd(nil, sender, doingRessing[sender].target)
	end
	SmartRes2.UNIT_SPELLCAST_FAILED = SmartRes2.UNIT_SPELLCAST_STOP
	SmartRes2.UNIT_SPELLCAST_INTERRUPTED = SmartRes2.UNIT_SPELLCAST_STOP
end

-- Blizzard callback functions ----------------------------------------------

-- Important Note: Since the release of patch 3.2, certain fights in the game fire the 
-- "PLAYER_REGEN_DISABLED" event continuously during combat causing any subsequent events
-- we might trigger as a result to also fire continuously. It is recommended therefore to
-- use a checking variable that is set to 'on/1/etc' when entering combat and back to
-- 'off/0/etc' only when exiting combat and then use this as the final determinant on
-- whether or not to action a subsequent event.
function SmartRes2:PLAYER_REGEN_DISABLED()
	-- don't confuse the variable below with being in combat - we use it to see if we've run
	-- the code below on entry into combat already so that we only run it once
	if not in_combat then
		self:UnBindKeys()
		-- disable callbacks during battle if we don't want to see battle resses
		if not self.db.profile.showBattleRes then
			ResComm.UnregisterAllCallbacks(self)
			self:StopGuessing()
		end
		-- clear the ressing tables
		wipe(doingRessing)
		wipe(waitingForAccept)
		wipe(resBars)
		LastRes = nil
	end
	in_combat = true
end

function SmartRes2:PLAYER_REGEN_ENABLED()
	self:BindKeys()
	-- reenable callbacks during battle if we don't want to see battle resses
	if not self.db.profile.showBattleRes then
		ResComm.RegisterCallback(self, "ResComm_ResStart")
		ResComm.RegisterCallback(self, "ResComm_ResEnd")
		ResComm.RegisterCallback(self, "ResComm_Ressed")
		ResComm.RegisterCallback(self, "ResComm_ResExpired")
		self.res_bars.RegisterCallback(self, "FadeFinished")
	end
	in_combat = false
	if self.db.profile.guessResses then
		self:StartGuessing()
	end
end

-- key binding functions ----------------------------------------------------

function SmartRes2:BindKeys()
	-- only binds keys if the player can cast an out of combat res spell
	if not self.playerSpell then return end
	SetOverrideBindingClick(self.resButton, false, self.db.profile.autoResKey, "SmartRes2Button")
	SetOverrideBindingSpell(self.resButton, false, self.db.profile.manualResKey, self.playerSpell)
end

function SmartRes2:UnBindKeys()
	ClearOverrideBindings(self.resButton)
end

-- anchor management functions ----------------------------------------------

function SmartRes2:ResAnchorMoved(_, _, x, y)
	self.db.profile.resBarsX, self.db.profile.resBarsY = x, y
end

-- smart ressurection determination functions -------------------------------
local raidUpdated

function SmartRes2:PARTY_MEMBERS_CHANGED()
	raidUpdated = true
end

function SmartRes2:RAID_ROSTER_UPDATE()
	raidUpdated = true
end

local unitOutOfRange, unitBeingRessed, unitDead, unitWaiting, unitGhost, UnitAFK
local SortedResList = {}
local CLASS_PRIORITIES = {
	-- There might be 10 classes, but SHAMANs and DRUIDs res at equal efficiency, so no preference
	-- non healers who use Mana should be followed after healers, as they are usually buffers
	-- or pet summoners (ie: Mana burners)
	-- res non Mana users last (HUNTERs will get moved once Catalclysm hits)
	PRIEST = 1, 
	PALADIN = 2, 
	SHAMAN = 3, 
	DRUID = 3, 
	MAGE = 4, 
	WARLOCK = 4, 
	HUNTER = 4,
	DEATHKNIGHT = 5,
	ROGUE = 5,
	WARRIOR = 5
}

-- create resurrection tables
local function getClassOrder(unit)
	local _, c = UnitClass(unit)
	local lvl = UnitLevel(unit)
	return CLASS_PRIORITIES[c] or 9, lvl
end

local function verifyUnit(unit)
	-- unit is the next candidate. there is NO way to check LoS, so don't ask!
	if UnitIsAFK(unit) then unitAFK = true return nil end
	if UnitIsGhost(unit) then
		unitGhost = true
		unitDead = true
		return nil
	end
	if not UnitIsDead(unit) then return nil end
	unitDead = true
	if unit == LastRes then return nil end
	if ResComm:IsUnitBeingRessed(unit) then unitBeingRessed = true return nil end
	if waitingForAccept[unit] then unitWaiting = true return nil end
	if IsSpellInRange(SmartRes2.playerSpell, unit) ~= 1 then unitOutOfRange = true return nil end
	return true
end

--sort function only called when raid has actually changed (avoided looking up unit names/classes everytime we click the res button)
local function SortCurrentRaiders()
	local num = GetNumRaidMembers()
	local member = "raid"
	if num == 0 then
		num = GetNumPartyMembers()
		member = "party"
	end
	wipe(SortedResList)
	for i = 1, num do
		local id = member .. i
		local name = UnitName(id)
		local resprio, lvl = getClassOrder(name)
		tinsert(SortedResList, {name = name, resprio = resprio, level = lvl})
	end
	tsort(SortedResList, function(a,b) 
		if a.resprio == b.resprio then
			return a.level > b.level
		else 
			return a.resprio < b.resprio
		end
	end)
	raidUpdated = nil
end

local function getBestCandidate()
	unitOutOfRange, unitBeingRessed, unitDead, unitWaiting, unitGhost, UnitAFK = nil, nil, nil, nil, nil, nil
	if raidUpdated then SortCurrentRaiders() end	--only resort if raid changed	
	for _, data in ipairs(SortedResList) do
		local unit = data.name
		local validUnit = verifyUnit(unit)
		if validUnit then
			return unit
		end
	end
	return nil
end

function SmartRes2:Resurrection()
	local resButton = self.resButton
	resButton:SetAttribute("unit", nil)

	if GetNumPartyMembers() == 0 and not UnitInRaid("player") then
		self:Print(L["You are not in a group."])
		return
	else
		resButton:SetAttribute("spell", self.playerSpell)
	end

	-- check if the player has enough Mana to cast a res spell. if not, no point in continuing. same if player is not a sender 
	local _, outOfMana = IsUsableSpell(self.playerSpell) 
	if outOfMana == 1 then 
	   self:Print(L["You don't have enough Mana to cast a res spell."]) 
	   return
	end

	local unit = getBestCandidate()
	if unit then
		resButton:SetAttribute("unit", unit)		
		LastRes = unit
	else
		if unitOutOfRange then
			self:Print(L["There are no bodies in range to res."])
		elseif unitBeingRessed or unitWaiting then
			self:Print(L["All dead units are being ressed."])
		elseif not unitDead then
			self:Print(L["Everybody is alive. Congratulations!"])
			wipe(waitingForAccept)
		elseif unitGhost then
			self:Print(L["All dead units have released."])
		elseif UnitAFK then
			self:Print(L["Remaining units are away from keyboard."])
		end
	end
end

-- resbar functions ---------------------------------------------------------

local function ClassColouredName(name)
	if not name then return "|cffcccccc"..L["Unknown"].."|r" end
	local _, class = UnitClass(name)
	if not class then return "|cffcccccc"..name.."|r" end
	local c = RAID_CLASS_COLORS[class]
	return ("|cff%02X%02X%02X%s|r"):format(c.r * 255, c.g * 255, c.b * 255, name)
end

function SmartRes2:CreateResBar(sender)
	if not self.db.profile.visibleResBars then return end
	local text
	local senderClass = select(2, UnitClass(sender))
	if senderClass == "DRUID" and in_combat then
		icon = select(3, GetSpellInfo(20484))
	else		
		icon = self.resSpellIcons[senderClass] or self.resSpellIcons.PRIEST
	end
	local info = doingRessing[sender]
	local time = info.endTime - GetTime()
	local flags = self.db.profile.fontFlags:upper()
	if flags == "0-NOTHING" then
		flags = nil
	elseif flags == thickOut then
		flags = "THICKOUTLINE"
	end
	
	if self.db.profile.classColours then
		text = (L["%s is ressing %s"]):format(ClassColouredName(sender), ClassColouredName(info.target))
	else
		text = (L["%s is ressing %s"]):format(sender, info.target)
	end

	-- args are as follows: lib:NewTimerBar(name, text, time, maxTime, icon, flashTrigger)
	local bar = self.res_bars:NewTimerBar(sender, text, time, nil, icon, 0)	
	local t = self.db.profile.resBarsColour
	bar:SetBackgroundColor(t.r, t.g, t.b, t.a)
	bar:SetColorAt(0, 0, 0, 0, 1) -- set bars to be black behind the cast bars
	orientation = (self.db.profile.horizontalOrientation == "RIGHT") and Bars.RIGHT_TO_LEFT or Bars.LEFT_TO_RIGHT
	bar:SetOrientation(orientation)
	bar:SetPoint("CENTER", UIParent, "CENTER", self.db.profile.resBarsX, self.db.profile.resBarsY) -- redundancy check #1
	if self.db.profile.resBarsIcon then -- redundancy check #2
		bar:ShowIcon()
	else
		bar:HideIcon()
	end
	bar:SetHeight(self.db.profile.barHeight)
	bar:SetWidth(self.db.profile.barWidth)
	bar:SetFont(Media:Fetch("font", self.db.profile.fontType), self.db.profile.fontScale, flags)
	bar:SetTexture(Media:Fetch("statusbar", self.db.profile.resBarsTexture))
	bar:SetBackdrop({
		edgeFile = Media:Fetch("border", self.db.profile.resBarsBorder),
		tile = false,
		tileSize = self.db.profile.scale + 1,
		edgeSize = self.db.profile.borderThickness,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	resBars[sender] = bar
end

function SmartRes2:DeleteResBar(sender)
	local info = doingRessing[sender]
	if not info then return end
	resBars[sender]:Fade(0.1)
	resBars[sender] = nil
end

-- LibBars event - called when bar finished fading
function SmartRes2:FadeFinished(event, bar, name)
	self.res_bars:ReleaseBar(bar)
end

function SmartRes2:AddCollisionBars(sender, target, collisionsender)
	if self.db.profile.visibleResBars then 
		local t = self.db.profile.collisionBarsColour
		resBars[sender]:SetBackgroundColor(t.r, t.g, t.b, t.a)
	end
	local chatType = self:GetChatType()
	if chatType ~= "0-OFF" and not UnitIsUnit(sender, "player") then
		SendChatMessage((L["SmartRes2 would like you to know that %s is already being ressed by %s."]):format(target, collisionsender), chatType, nil, sender)
	end
end

function SmartRes2:AddWaitingBars(sender, target)
	if self.db.profile.visibleResBars then 
		local t = self.db.profile.waitingBarsColour
		resBars[sender]:SetBackgroundColor(t.r, t.g, t.b, t.a)
	end
end

function SmartRes2:DeleteCollisionBars(sender, target, collisionsender)
	local t = self.db.profile.resBarsColour
	resBars[collisionsender]:SetBackgroundColor(t.r, t.g, t.b, t.a)
end

function SmartRes2:GetChatType()
	local chatType = self.db.profile.notifyCollision:upper()
	if chatType == "GROUP" then
		if GetNumRaidMembers() > 0 then
			chatType = "RAID"
		elseif GetNumPartyMembers() > 0 then
			chatType = "PARTY"
		end
	end
	return chatType
end

function SmartRes2:StartTestBars()
	-- we don't want the test bars to throw an error if notify collision is on
	local settings = self.db.profile.notifyCollision
	if settings ~= "0-off" then
		self.db.profile.notifyCollision = "0-off"
	end

	-- set up the test bars
	--waitingForAccept["Someone"] = { target = "Someone", sender = "Dummy", endTime = GetTime() - 6 }
	waitingForAccept["Someone"] = GetTime() - 6
	self:ResComm_ResStart(nil, "Nursenancy", GetTime() + 4, "Frankthetank")
	self:ResComm_ResStart(nil, "Dummy", GetTime() + 8, "Frankthetank")
	self:ResComm_ResStart(nil, "Gabriel", GetTime() + 6, "Someone")
		
	-- clean up
	doingRessing["Nursenancy"] = nil
	doingRessing["Dummy"] = nil
	doingRessing["Gabriel"] = nil
	waitingForAccept["Someone"] = nil
	
	-- set the collision back to user preferences
	self.db.profile.notifyCollision = settings
end