local aName, Skinner = ...

function Skinner:Defaults()

	local defaults = { profile = {
		-- Colours
		TooltipBorder	= {r = 0.5, g = 0.5, b = 0.5, a = 1},
		BackdropBorder	= {r = 0.5, g = 0.5, b = 0.5, a = 1},
		Backdrop		= {r = 0, g = 0, b = 0, a = 0.9},
		HeadText		= {r = 0.8, g = 0.8, b = 0.0},
		BodyText		= {r = 0.7, g = 0.7, b = 0.0},
		GradientMin		= {r = 0.1, g = 0.1, b = 0.1, a = 0},
		GradientMax		= {r = 0.25, g = 0.25, b = 0.25, a = 1},
		-- Backdrop Settings
		BdDefault		= true,
		BdFile			= "None",
		BdTexture		= "Blizzard ChatFrame Background",
		BdTileSize		= 16,
		BdEdgeFile		= "None",
		BdBorderTexture = "Blizzard Tooltip",
		BdEdgeSize		= 16,
		BdInset			= 4,
		-- Background Texture settings
		BgUseTex        = false,
		BgFile          = "None",
		BgTexture       = "None",
		BgTile          = false,
		-- Tab and DropDown Texture settings
		TexturedTab		= false,
		TexturedDD		= false,
		TabDDFile		= "None",
		TabDDTexture	= "Skinner Inactive Tab",
		-- Other
		Warnings		= true,
		Errors			= true,
		Gradient		= {enable = true, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "Blizzard ChatFrame Background"},
		FadeHeight		= {enable = false, value = 500, force = false},
		Delay			= {Init = 0.5, Addons = 0.5, LoDs = 0.5},
		StatusBar		= {texture = "Blizzard", r = 0, g = 0.5, b = 0.5, a = 0.5},
		-- Character Frames
		CharacterFrames = true,
		PVPFrame  		= true,
		PetStableFrame  = true,
		SpellBookFrame  = true,
		TalentUI		= true,
		DressUpFrame    = true,
		FriendsFrame    = true,
		TradeSkillUI	= true,
		TradeFrame      = true,
		QuestLog        = true,
		RaidUI          = true,
		ReadyCheck      = true,
		Buffs           = true,
		AchievementUI	= true,
		VehicleMenuBar	= true,
		WatchFrame		= false,
		GearManager		= true,
		AlertFrames		= true,
		-- UI Frames
		Tooltips        = {skin = true, style = 1, glazesb = true, border = 1},
		MirrorTimers    = {skin = true, glaze = true},
		CastingBar      = {skin = true, glaze = true},
		StaticPopups    = true,
		ChatMenus       = true,
		ChatConfig      = true,
		ChatTabs        = false,
		ChatFrames      = false,
		CombatLogQBF    = false,
		ChatEditBox     = {skin = true, style = 3},
		LootFrame       = true,
		GroupLoot       = {skin = true, size = 1},
		ContainerFrames = {skin = true, fheight = 100},
		StackSplit      = true,
		ItemText        = true,
		Colours         = true,
		WorldMap        = {skin = true, size = 1},
		HelpFrame       = true,
		Tutorial        = true,
		GMSurveyUI      = true,
		Feedback        = self.isPTR and true or nil,
		InspectUI		= true,
		BattleScore     = true, -- a.k.a. WorldState
		BattlefieldMm   = true,
		ScriptErrors	= true,
		DebugTools		= true,
		DropDowns       = true,
		MinimapButtons  = false,
		MinimapGloss    = false,
		MinimalMMBtns	= false,
		MovieProgress   = IsMacClient() and true or nil,
		TimeManager     = true,
		Calendar        = true,
		MenuFrames      = true, -- inc. MacroUI & BindingUI
		BankFrame       = true,
		MailFrame       = true,
		AuctionUI	    = true,
		MainMenuBar     = {skin = true, glazesb = true},
		CoinPickup      = true,
		LFDFrame        = true,
		LFRFrame        = true,
		ItemSocketingUI = true,
		GuildBankUI     = true,
		Nameplates      = true,
		GMChatUI		= true,
		BNFrames		= true,
		-- NPC Frames
		MerchantFrames  = true,
		GossipFrame     = true,
		TrainerUI	    = true,
		TaxiFrame       = true,
		QuestFrame      = true,
		Battlefields    = true,
		ArenaFrame      = true,
		ArenaRegistrar  = true,
		GuildRegistrar  = true,
		Petition        = true,
		Tabard          = true,
		BarbershopUI	= true,
		-- DBIcon settings
		MinimapIcon		= {hide = false, minimapPos = 210, radius = 80},
		-- disabled skins table
		DisabledSkins	= {},

	}}

	self.db = LibStub("AceDB-3.0"):New("SkinnerDB", defaults, "Default")

end

local DBIcon = LibStub("LibDBIcon-1.0")
function Skinner:Options()

	local db = self.db.profile
	local dflts = self.db.defaults.profile

	local optTables = {

		General = {
			type = "group",
	    	name = aName,
			get = function(info) return db[info[#info]] end,
			set = function(info, value) db[info[#info]] = value end,
			args = {
				desc = {
					type = "description",
					order = 1,
					name = self.L["UI Enhancement"] .." - "..GetAddOnMetadata(aName, "Version").. "\n",
				},
				longdesc = {
					type = "description",
					order = 2,
					name = self.L["Provides a Minimalist UI by removing the Blizzard textures"] .. "\n",
				},
				Errors = {
					type = "toggle",
					order = 3,
					name = self.L["Show Errors"],
					desc = self.L["Toggle the Showing of Errors"],
				},
				Warnings = {
					type = "toggle",
					order = 4,
					name = self.L["Show Warnings"],
					desc = self.L["Toggle the Showing of Warnings"],
				},
				MinimapIcon = {
					type = "toggle",
					order = 5,
					name = self.L["Minimap icon"],
					desc = self.L["Toggle the minimap icon"],
					get = function(info) return not db.MinimapIcon.hide end,
					set = function(info, value)
						db.MinimapIcon.hide = not value
						if value then DBIcon:Show(aName) else DBIcon:Hide(aName) end
					end,
					hidden = function() return not DBIcon end,
				},
				DropDowns = {
					type = "toggle",
					order = 6,
					name = self.L["DropDowns"],
					desc = self.L["Toggle the skin of the DropDowns"],
				},
				TabDDTextures = {
					type = "group",
					order = 10,
					inline = true,
					name = self.L["Inactive Tab & DropDown Texture Settings"],
					args = {
						TexturedDD = {
							type = "toggle",
							order = 1,
							name = self.L["Textured DropDown"],
							desc = self.L["Toggle the Texture of the DropDowns"],
						},
						TexturedTab = {
							type = "toggle",
							order = 2,
							name = self.L["Textured Tab"],
							desc = self.L["Toggle the Texture of the Tabs"],
							set = function(info, value)
								db[info[#info]] = value
								self.isTT = db[info[#info]] and true or false
							end,
						},
		                TabDDFile = {
		                    type = "input",
		                    order = 3,
		                    width = "full",
		                    name = self.L["Inactive Tab & DropDown Texture File"],
		                    desc = self.L["Set Inactive Tab & DropDown Texture Filename"],
		                },
		                TabDDTexture = AceGUIWidgetLSMlists and {
		                    type = "select",
		                    order = 4,
		                    width = "double",
		                    name = self.L["Inactive Tab & DropDown Texture"],
		                    desc = self.L["Choose the Texture for the Inactive Tab & DropDowns"],
		                    dialogControl = "LSM30_Background",
		                    values = AceGUIWidgetLSMlists.background,
		                } or nil,
					},
				},
				Delay = {
					type = "group",
					order = 21,
					inline = true,
					name = self.L["Skinning Delays"],
					desc = self.L["Change the Skinning Delays settings"],
					get = function(info) return db.Delay[info[#info]] end,
					set = function(info, value) db.Delay[info[#info]] = value end,
					args = {
						Init = {
							type = "range",
							order = 1,
							name = self.L["Initial Delay"],
							desc = self.L["Set the Delay before Skinning Blizzard Frames"],
							min = 0, max = 10, step = 0.5,
						},
						Addons = {
							type = "range",
							order = 2,
							name = self.L["Addons Delay"],
							desc = self.L["Set the Delay before Skinning Addons Frames"],
							min = 0, max = 10, step = 0.5,
						},
						LoDs = {
							type = "range",
							order = 3,
							name = self.L["LoD Addons Delay"],
							desc = self.L["Set the Delay before Skinning Load on Demand Frames"],
							min = 0, max = 10, step = 0.5,
						},
					},
				},
				FadeHeight = {
					type = "group",
					order = 22,
					inline = true,
					name = self.L["Fade Height"],
					desc = self.L["Change the Fade Height settings"],
					get = function(info) return db.FadeHeight[info[#info]] end,
					set = function(info, value) db.FadeHeight[info[#info]] = value end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = self.L["Global Fade Height"],
							desc = self.L["Toggle the Global Fade Height"],
						},
						value = {
							type = "range",
							order = 2,
							name = self.L["Fade Height value"],
							desc = self.L["Change the Height of the Fade Effect"],
							min = 0, max = 1000, step = 10,
						},
						force = {
							type = "toggle",
							order = 3,
							name = self.L["Force the Global Fade Height"],
							desc = self.L["Force ALL Frame Fade Height's to be Global"],
						},
					},
				},
				StatusBar = {
					type = "group",
					order = 23,
					inline = true,
					name = self.L["StatusBar"],
					desc = self.L["Change the StatusBar settings"],
					args = {
						texture = AceGUIWidgetLSMlists and {
							type = "select",
							order = 1,
							name = self.L["Texture"],
							desc = self.L["Choose the Texture for the Status Bars"],
							dialogControl = "LSM30_Statusbar",
							values = AceGUIWidgetLSMlists.statusbar,
							get = function(info) return db.StatusBar.texture end,
							set = function(info, value)
								db.StatusBar.texture = value
								self:checkAndRun("updateSBTexture")
							end,
						} or nil,
						bgcolour = {
							type = "color",
							order = 2,
							name = self.L["Background Colour"],
							desc = self.L["Change the Colour of the Status Bar Background"],
							hasAlpha = true,
							get = function(info)
								local c = db.StatusBar
								return c.r, c.g, c.b, c.a
							end,
							set = function(info, r, g, b, a)
								local c = db.StatusBar
								c.r, c.g, c.b, c.a = r, g, b, a
								self:checkAndRun("updateSBTexture")
							end,
						},
					},
				},
				WatchFrame = {
					type = "toggle",
					order = 8,
					name = self.L["Watch Frame"],
					desc = self.L["Toggle the skin of the Watch Frame"],
					set = function(info, value)
						db[info[#info]] = value
						self:checkAndRun(info[#info])
					end,
				},
			},
		},

        Backdrop = {
            type = "group",
            name = self.L["Default Backdrop"],
            get = function(info) return db[info[#info]] end,
            set = function(info, value)
                db[info[#info]] = value == "" and "None" or value
                if info[#info] ~= "BdDefault" then db.BdDefault = false end
            end,
            args = {
                BdDefault = {
                    type = "toggle",
                    order = 1,
                    width = "double",
                    name = self.L["Use Default Backdrop"],
                    desc = self.L["Toggle the Default Backdrop"],
                },
                BdFile = {
                    type = "input",
                    order = 2,
                    width = "full",
                    name = self.L["Backdrop Texture File"],
                    desc = self.L["Set Backdrop Texture Filename"],
                },
                BdTexture = AceGUIWidgetLSMlists and {
                    type = "select",
                    order = 3,
                    width = "double",
                    name = self.L["Backdrop Texture"],
                    desc = self.L["Choose the Texture for the Backdrop"],
                    dialogControl = "LSM30_Background",
                    values = AceGUIWidgetLSMlists.background,
                } or nil,
                BdTileSize = {
                    type = "range",
                    order = 4,
                    name = self.L["Backdrop TileSize"],
                    desc = self.L["Set Backdrop TileSize"],
                    min = 0, max = 128, step = 4,
                },
                BdEdgeFile = {
                    type = "input",
                    order = 5,
                    width = "full",
                    name = self.L["Border Texture File"],
                    desc = self.L["Set Border Texture Filename"],
                },
                BdBorderTexture = AceGUIWidgetLSMlists and {
                    type = "select",
                    order = 6,
                    width = "double",
                    name = self.L["Border Texture"],
                    desc = self.L["Choose the Texture for the Border"],
                    dialogControl = 'LSM30_Border',
                    values = AceGUIWidgetLSMlists.border,
                } or nil,
                BdEdgeSize = {
                    type = "range",
                    order = 7,
                    name = self.L["Border Width"],
                    desc = self.L["Set Border Width"],
                    min = 0, max = 32, step = 2,
                },
                BdInset = {
                    type = "range",
                    order = 8,
                    name = self.L["Border Inset"],
                    desc = self.L["Set Border Inset"],
                    min = 0, max = 8, step = 1,
                },
            },
        },

        Background = {
            type = "group",
            name = self.L["Background Settings"],
            get = function(info) return db[info[#info]] end,
            set = function(info, value)
                db[info[#info]] = value == "" and "None" or value
                if info[#info] ~= "BgUseTex" then db.BgUseTex = true end
                if db.BgUseTex then db.Tooltips.style = 3 end -- set Tooltip style to Custom
            end,
            args = {
                BgUseTex = {
                    type = "toggle",
                    order = 1,
                    width = "double",
                    name = self.L["Use Background Texture"],
                    desc = self.L["Toggle the Background Texture"],
                },
                BgFile = {
                    type = "input",
                    order = 2,
                    width = "full",
                    name = self.L["Background Texture File"],
                    desc = self.L["Set Background Texture Filename"],
                },
                BgTexture = AceGUIWidgetLSMlists and {
                    type = "select",
                    order = 3,
                    width = "double",
                    name = self.L["Background Texture"],
                    desc = self.L["Choose the Texture for the Background"],
                    dialogControl = "LSM30_Background",
                    values = AceGUIWidgetLSMlists.background,
                } or nil,
                BgTile = {
                    type = "toggle",
                    order = 4,
                    name = self.L["Tile Background"],
                    desc = self.L["Tile or Stretch Background"],
                },
            },
        },

		Colours = {
			type = "group",
			name = self.L["Default Colours"],
			get = function(info)
				local c = db[info[#info]]
				return c.r, c.g, c.b, c.a
			end,
			set = function(info, r, g, b, a)
				local c = db[info[#info]]
				c.r, c.g, c.b, c.a = r, g, b, a
			end,
			args = {
				TooltipBorder = {
					type = "color",
					order = 1,
					width = "double",
					name = self.L["Tooltip Border Colors"],
					desc = self.L["Set Tooltip Border Colors"],
					hasAlpha = true,
				},
				Backdrop = {
					type = "color",
					order = 2,
					width = "double",
					name = self.L["Backdrop Colors"],
					desc = self.L["Set Backdrop Colors"],
					hasAlpha = true,
				},
				BackdropBorder = {
					type = "color",
					order = 3,
					width = "double",
					name = self.L["Border Colors"],
					desc = self.L["Set Backdrop Border Colors"],
					hasAlpha = true,
				},
				HeadText = {
					type = "color",
					order = 4,
					width = "double",
					name = self.L["Text Heading Colors"],
					desc = self.L["Set Text Heading Colors"],
				},
				BodyText = {
					type = "color",
					order = 5,
					width = "double",
					name = self.L["Text Body Colors"],
					desc = self.L["Set Text Body Colors"],
				},
				GradientMin = {
					type = "color",
					order = 6,
					width = "double",
					name = self.L["Gradient Minimum Colors"],
					desc = self.L["Set Gradient Minimum Colors"],
					hasAlpha = true,
				},
				GradientMax = {
					type = "color",
					order = 7,
					width = "double",
					name = self.L["Gradient Maximum Colors"],
					desc = self.L["Set Gradient Maximum Colors"],
					hasAlpha = true,
				},
			},
		},

		Gradient = {
			type = "group",
			name = self.L["Gradient"],
			get = function(info) return db.Gradient[info[#info]] end,
			set = function(info, value) db.Gradient[info[#info]] = value end,
			args = {
				enable = {
					type = "toggle",
					order = 1,
					width = "double",
					name = self.L["Gradient Effect"],
					desc = self.L["Toggle the Gradient Effect"],
				},
				texture = AceGUIWidgetLSMlists and {
					type = "select",
					order = 2,
					width = "double",
					name = self.L["Gradient Texture"],
					desc = self.L["Choose the Texture for the Gradient"],
					dialogControl = "LSM30_Background",
					values = AceGUIWidgetLSMlists.background,
				} or nil,
				invert = {
					type = "toggle",
					order = 3,
					width = "double",
					name = self.L["Invert Gradient"],
					desc = self.L["Invert the Gradient Effect"],
				},
				rotate = {
					type = "toggle",
					order = 4,
					width = "double",
					name = self.L["Rotate Gradient"],
					desc = self.L["Rotate the Gradient Effect"],
				},
				char = {
					type = "toggle",
					order = 5,
					width = "double",
					name = self.L["Enable Character Frames Gradient"],
					desc = self.L["Enable the Gradient Effect for the Character Frames"],
				},
				ui = {
					type = "toggle",
					order = 6,
					width = "double",
					name = self.L["Enable UserInterface Frames Gradient"],
					desc = self.L["Enable the Gradient Effect for the UserInterface Frames"],
				},
				npc = {
					type = "toggle",
					order = 7,
					width = "double",
					name = self.L["Enable NPC Frames Gradient"],
					desc = self.L["Enable the Gradient Effect for the NPC Frames"],
				},
				skinner = {
					type = "toggle",
					order = 8,
					width = "double",
					name = self.L["Enable Skinner Frames Gradient"],
					desc = self.L["Enable the Gradient Effect for the Skinner Frames"],
				},
			},
		},

		Modules = {
			type = "group",
			name = self.L["Module settings"],
			childGroups = "tab",
			args = {
				desc = {
					type = "description",
					name = self.L["Change the Module's settings"],
				},
			},
		},

		NPCFrames = {
			type = "group",
			name = self.L["NPC Frames"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				local uiOpt = info[#info]:match("UI" , -2)
				-- handle Blizzard UI LoD Addons
				if uiOpt then
					if IsAddOnLoaded("Blizzard_"..info[#info]) then
						self:checkAndRun(info[#info])
					end
				else self:checkAndRun(info[#info]) end
			end,
			args = {
				none = {
					type = "execute",
					order = 1,
					width = "full",
					name = self.L["Disable all NPC Frames"],
					desc = self.L["Disable all the NPC Frames from being skinned"],
					func = function()
						local bVal = IsAltKeyDown() and true or false
						for _, keyName in pairs(self.npcKeys) do
							db[keyName] = bVal
						end
					end,
				},
				MerchantFrames = {
					type = "toggle",
					name = self.L["Merchant Frames"],
					desc = self.L["Toggle the skin of the Merchant Frame"],
				},
				GossipFrame = {
					type = "toggle",
					name = self.L["Gossip Frame"],
					desc = self.L["Toggle the skin of the Gossip Frame"],
				},
				TrainerUI = {
					name = self.L["Class Trainer Frame"],
					desc = self.L["Toggle the skin of the Class Trainer Frame"],
					type = "toggle",
				},
				TaxiFrame = {
					type = "toggle",
					name = self.L["Taxi Frame"],
					desc = self.L["Toggle the skin of the Taxi Frame"],
				},
				QuestFrame = {
					type = "toggle",
					name = self.L["Quest Frame"],
					desc = self.L["Toggle the skin of the Quest Frame"],
				},
				Battlefields = {
					type = "toggle",
					name = self.L["Battlefields Frame"],
					desc = self.L["Toggle the skin of the Battlefields Frame"],
				},
				ArenaFrame = {
					type = "toggle",
					name = self.L["Arena Frame"],
					desc = self.L["Toggle the skin of the Arena Frame"],
				},
				ArenaRegistrar = {
					type = "toggle",
					name = self.L["Arena Registrar Frame"],
					desc = self.L["Toggle the skin of the Arena Registrar Frame"],
				},
				GuildRegistrar = {
					type = "toggle",
					name = self.L["Guild Registrar Frame"],
					desc = self.L["Toggle the skin of the Guild Registrar Frame"],
				},
				Petition = {
					type = "toggle",
					name = self.L["Petition Frame"],
					desc = self.L["Toggle the skin of the Petition Frame"],
				},
				Tabard = {
					type = "toggle",
					name = self.L["Tabard Frame"],
					desc = self.L["Toggle the skin of the Tabard Frame"],
				},
				BarbershopUI = {
					type = "toggle",
					name = self.L["Barbershop Frame"],
					desc = self.L["Toggle the skin of the Barbershop Frame"],
				},
			},
		},

		PlayerFrames = {
			type = "group",
			name = self.L["Character Frames"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				-- handle Blizzard UI LoD Addons
				local uiOpt = info[#info]:match("UI" , -2)
				if uiOpt then
					if IsAddOnLoaded("Blizzard_"..info[#info]) then
						self:checkAndRun(info[#info])
					end
				else self:checkAndRun(info[#info]) end
			end,
			args = {
				none = {
					type = "execute",
					order = 1,
					width = "full",
					name = self.L["Disable all Character Frames"],
					desc = self.L["Disable all the Character Frames from being skinned"],
					func = function()
						local bVal = IsAltKeyDown() and true or false
						for _, keyName in pairs(self.charKeys1) do
							db[keyName] = bVal
						end
						for _, keyName in pairs(self.charKeys2) do
							db[keyName].skin = bVal
						end
					end,
				},
				AchievementUI = {
					type = "toggle",
					name = self.L["AchievementUI"],
					desc = self.L["Toggle the skin of the AchievementUI"],
				},
				AlertFrames = {
					type = "toggle",
					name = self.L["Alert Frames"],
					desc = self.L["Toggle the skin of the Alert Frames"],
				},
				CharacterFrames = {
					type = "toggle",
					name = self.L["Character Frames"],
					desc = self.L["Toggle the skin of the Character Frames"],
				},
				PVPFrame = {
					type = "toggle",
					name = self.L["PVP Frame"],
					desc = self.L["Toggle the skin of the PVP Frame"],
				},
				PetStableFrame = {
					type = "toggle",
					name = self.L["Stable Frame"],
					desc = self.L["Toggle the skin of the Stable Frame"],
				},
				SpellBookFrame = {
					type = "toggle",
					name = self.L["SpellBook Frame"],
					desc = self.L["Toggle the skin of the SpellBook Frame"],
				},
				TalentUI = {
					type = "toggle",
					name = self.L["Talent Frame"],
					desc = self.L["Toggle the skin of the Talent Frame"],
				},
				DressUpFrame = {
					type = "toggle",
					name = self.L["DressUp Frame"],
					desc = self.L["Toggle the skin of the DressUp Frame"],
				},
				FriendsFrame = {
					type = "toggle",
					name = self.L["Social Frame"],
					desc = self.L["Toggle the skin of the Social Frame"],
				},
				TradeSkillUI = {
					type = "toggle",
					name = self.L["Trade Skill Frame"],
					desc = self.L["Toggle the skin of the Trade Skill Frame"],
				},
				TradeFrame = {
					type = "toggle",
					name = self.L["Trade Frame"],
					desc = self.L["Toggle the skin of the Trade Frame"],
				},
				QuestLog = {
					type = "toggle",
					name = self.L["Quest Log Frame"],
					desc = self.L["Toggle the skin of the Quest Log Frame"],
				},
				RaidUI = {
					type = "toggle",
					name = self.L["RaidUI Frame"],
					desc = self.L["Toggle the skin of the RaidUI Frame"],
				},
				ReadyCheck = {
					type = "toggle",
					name = self.L["ReadyCheck Frame"],
					desc = self.L["Toggle the skin of the ReadyCheck Frame"],
				},
				Buffs = {
					type = "toggle",
					name = self.L["Buffs Buttons"],
					desc = self.L["Toggle the skin of the Buffs Buttons"],
				},
				VehicleMenuBar = {
					type = "toggle",
					name = self.L["Vehicle Menu Bar"],
					desc = self.L["Toggle the skin of the Vehicle Menu Bar"],
				},
				GearManager = {
					type = "toggle",
					name = self.L["Gear Manager Frame"],
					desc = self.L["Toggle the skin of the Gear Manager Frame"],
				},
			},
		},

		UIFrames = {
			type = "group",
			name = self.L["UI Frames"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				local uiOpt = info[#info]:match("UI" , -2)
				if info[#info] == "Colours" then self:checkAndRun("ColorPicker")
				elseif info[#info] == "Feedback" then self:checkAndRun("FeedbackUI")
				elseif info[#info] == "CombatLogQBF" then return
				elseif info[#info] == "BattlefieldMm" then
					if IsAddOnLoaded("Blizzard_BattlefieldMinimap") then
						self:checkAndRun("BattlefieldMinimap")
					end
				elseif info[#info] == "TimeManager" or info[#info] == "Calendar" then
					if IsAddOnLoaded(info[#info]) then
						self:checkAndRun(info[#info])
					end
				-- handle Blizzard UI LoD Addons
				elseif uiOpt then
					if IsAddOnLoaded("Blizzard_"..info[#info]) then
						self:checkAndRun(info[#info])
					end
				else self:checkAndRun(info[#info]) end
			end,
			args = {
				none = {
					type = "execute",
					order = 1,
					width = "full",
					name = self.L["Disable all UI Frames"],
					desc = self.L["Disable all the UI Frames from being skinned"],
					func = function()
						local bVal = IsAltKeyDown() and true or false
						for _, keyName in pairs(self.uiKeys1) do
							db[keyName] = bVal
						end
						for _, keyName in pairs(self.uiKeys2) do
							db[keyName].skin = bVal
						end
					end,
				},
				Tooltips = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Tooltips"],
					desc = self.L["Change the Tooltip settings"],
					get = function(info) return db.Tooltips[info[#info]] end,
					set = function(info, value) db.Tooltips[info[#info]] = value end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Tooltip Skin"],
							desc = self.L["Toggle the skin of the Tooltips"],
						},
						glazesb = {
							type = "toggle",
							order = 2,
							width = "double",
							name = self.L["Glaze Status Bar"],
							desc = self.L["Toggle the glazing Status Bar"],
						},
						style = {
							type = "range",
							order = 3,
							name = self.L["Tooltips Style"],
							desc = self.L["Set the Tooltips style (Rounded, Flat, Custom)"],
							min = 1, max = 3, step = 1,
							set = function(info, value) db.Tooltips.style = value end,
						},
						border = {
							type = "range",
							order = 4,
							name = self.L["Tooltips Border Colour"],
							desc = self.L["Set the Tooltips Border colour (Default, Custom)"],
							min = 1, max = 2, step = 1,
						},
					},
				},
				MirrorTimers = {
					type = "group",
					inline = true,
					order = -2,
					name = self.L["Timer Frames"],
					desc = self.L["Change the Timer Settings"],
					get = function(info) return db.MirrorTimers[info[#info]] end,
					set = function(info, value)
						db.MirrorTimers[info[#info]] = value
						self:checkAndRun("MirrorTimers")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Timer Skin"],
							desc = self.L["Toggle the skin of the Timer"],
						},
						glaze = {
							type = "toggle",
							order = 2,
							name = self.L["Glaze Timer"],
							desc = self.L["Toggle the glazing Timer"],
						},
					},
				},
				CastingBar = {
					type = "group",
					inline = true,
					order = -10,
					name = self.L["Casting Bar Frame"],
					desc = self.L["Change the Casting Bar Settings"],
					get = function(info) return db.CastingBar[info[#info]] end,
					set = function(info, value)
						db.CastingBar[info[#info]] = value
						self:checkAndRun("CastingBar")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Casting Bar Skin"],
							desc = self.L["Toggle the skin of the Casting Bar"],
						},
						glaze = {
							type = "toggle",
							order = 2,
							name = self.L["Glaze Casting Bar"],
							desc = self.L["Toggle the glazing Casting Bar"],
						},
					},
				},
				StaticPopups = {
					type = "toggle",
					name = self.L["Static Popups"],
					desc = self.L["Toggle the skin of Static Popups"],
				},
				chatopts = {
					type = "group",
					inline = true,
					order = -8,
					name = self.L["Chat Sub Frames"],
					desc = self.L["Change the Chat Sub Frames"],
					args = {
						ChatMenus = {
							type = "toggle",
							order = 1,
							name = self.L["Chat Menus"],
							desc = self.L["Toggle the skin of the Chat Menus"],
						},
						ChatConfig = {
							type = "toggle",
							order = 2,
							name = self.L["Chat Config"],
							desc = self.L["Toggle the skinning of the Chat Config Frame"],
						},
						ChatTabs = {
							type = "toggle",
							order = 3,
							name = self.L["Chat Tabs"],
							desc = self.L["Toggle the skin of the Chat Tabs"],
						},
						ChatFrames = {
							type = "toggle",
							order = 4,
							name = self.L["Chat Frames"],
							desc = self.L["Toggle the skin of the Chat Frames"],
						},
						CombatLogQBF = {
							type = "toggle",
							width = "double",
							name = self.L["CombatLog Quick Button Frame"],
							desc = self.L["Toggle the skin of the CombatLog Quick Button Frame"],
						},
					},
				},
				ChatEditBox = {
					type = "group",
					inline = true,
					order = -9,
					name = self.L["Chat Edit Box"],
					desc = self.L["Change the Chat Edit Box settings"],
					get = function(info) return db.ChatEditBox[info[#info]] end,
					set = function(info, value)
						db.ChatEditBox[info[#info]] = value
						self:checkAndRun("ChatEditBox")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Chat Edit Box Skin"],
							desc = self.L["Toggle the skin of the Chat Edit Box Frame"],
						},
						style = {
							type = "range",
							order = 2,
							name = self.L["Chat Edit Box Style"],
							desc = self.L["Set the Chat Edit Box style (Frame, EditBox, Borderless)"],
							min = 1, max = 3, step = 1,
						},
					},
				},
				LootFrame = {
					type = "toggle",
					name = self.L["Loot Frame"],
					desc = self.L["Toggle the skin of the Loot Frame"],
				},
				GroupLoot = {
					type = "group",
					inline = true,
					order = -6,
					name = self.L["Group Loot Frame"],
					desc = self.L["Change the GroupLoot settings"],
					get = function(info) return db.GroupLoot[info[#info]] end,
					set = function(info, value)
						db.GroupLoot[info[#info]] = value
						self:checkAndRun("GroupLoot")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["GroupLoot Skin"],
							desc = self.L["Toggle the skin of the GroupLoot Frame"],
						},
						size = {
							type = "range",
							order = 2,
							name = self.L["GroupLoot Size"],
							desc = self.L["Set the GroupLoot size (Normal, Small, Micro)"],
							min = 1, max = 3, step = 1,
						},
					},
				},
				ContainerFrames = {
					type = "group",
					inline = true,
					order = -7,
					name = self.L["Container Frames"],
					desc = self.L["Change the Container Frames settings"],
					get = function(info) return db.ContainerFrames[info[#info]] end,
					set = function(info, value)
						db.ContainerFrames[info[#info]] = value
						self:checkAndRun("ContainerFrames")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Containers Skin"],
							desc = self.L["Toggle the skin of the Container Frames"],
						},
						fheight = {
							type = "range",
							order = 2,
							name = self.L["CF Fade Height"],
							desc = self.L["Change the Height of the Fade Effect"],
							min = 0, max = 300, step = 1,
						},
					},
				},
				StackSplit = {
					type = "toggle",
					name = self.L["Stack Split Frame"],
					desc = self.L["Toggle the skin of the Stack Split Frame"],
				},
				ItemText = {
					type = "toggle",
					name = self.L["Item Text Frame"],
					desc = self.L["Toggle the skin of the Item Text Frame"],
				},
				Colours = {
					type = "toggle",
					name = self.L["Color Picker Frame"],
					desc = self.L["Toggle the skin of the Color Picker Frame"],
				},
				WorldMap = {
					type = "toggle",
					type = "group",
					inline = true,
					order = -1,
					name = self.L["World Map Frame"],
					desc = self.L["Change the World Map settings"],
					get = function(info) return db.WorldMap[info[#info]] end,
					set = function(info, value)
						db.WorldMap[info[#info]] = value
						self:checkAndRun("WorldMap")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["World Map Skin"],
							desc = self.L["Toggle the skin of the World Map Frame"],
						},
						size = {
							type = "range",
							order = 2,
							name = self.L["World Map Size"],
							desc = self.L["Set the World Map size (Normal, Fullscreen)"],
							min = 1, max = 2, step = 1,
						},
					},
				},
				helpframes = {
					type = "group",
					inline = true,
					order = -5,
					name = self.L["Help Request Frames"],
					desc = self.L["Change the Help Request Frames"],
					args = {
						HelpFrame = {
							type = "toggle",
							name = self.L["Help Frame"],
							desc = self.L["Toggle the skin of the Help Frame"],
						},
						Tutorial = {
							type = "toggle",
							name = self.L["Tutorial Frame"],
							desc = self.L["Toggle the skin of the Tutorial Frame"],
						},
						GMSurveyUI = {
							type = "toggle",
							name = self.L["GM Survey UI Frame"],
							desc = self.L["Toggle the skin of the GM Survey UI Frame"],
						},
						Feedback = self.isPTR and {
							type = "toggle",
							name = self.L["Feedback"],
							desc = self.L["Toggle the skin of the Feedback Frame"],
						} or nil,
					},
				},
				InspectUI = {
					type = "toggle",
					name = self.L["Inspect Frame"],
					desc = self.L["Toggle the skin of the Inspect Frame"],
				},
				BattleScore = {
					type = "toggle",
					name = self.L["Battle Score Frame"],
					desc = self.L["Toggle the skin of the Battle Score Frame"],
				},
				BattlefieldMm = {
					type = "toggle",
					name = self.L["Battlefield Minimap Frame"],
					desc = self.L["Toggle the skin of the Battlefield Minimap Frame"],
				},
				ScriptErrors = {
					type = "toggle",
					name = self.L["Script Errors Frame"],
					desc = self.L["Toggle the skin of the Script Errors Frame"],
				},
				DebugTools = {
					type = "toggle",
					name = self.L["Debug Tools Frames"],
					desc = self.L["Toggle the skin of the Debug Tools Frames"],
				},
				minimapopts = {
					type = "group",
					inline = true,
					order = -3,
					name = self.L["Minimap Options"],
					desc = self.L["Change the Minimap Options"],
					args = {
						MinimapButtons = {
							type = "toggle",
							order = 2,
							name = self.L["Minimap Buttons"],
							desc = self.L["Toggle the skin of the Minimap Buttons"],
						},
						MinimapGloss = {
							type = "toggle",
							name = self.L["Minimap Gloss Effect"],
							desc = self.L["Toggle the Gloss Effect for the Minimap"],
							order = 1,
							set = function(info, value)
								db.MinimapGloss = value
								if self.minimapskin then
									if not value then LowerFrameLevel(self.minimapskin)
									else RaiseFrameLevel(self.minimapskin) end
								end
							end,
						},
						MinimalMMBtns = {
							type = "toggle",
							order = 3,
							name = self.L["Minimal Minimap Buttons"],
							desc = self.L["Toggle the style of the Minimap Buttons"],
							set = function(info, value) db[info[#info]] = value end
						},
					},
				},
				TimeManager = {
					type = "toggle",
					name = self.L["Time Manager"],
					desc = self.L["Toggle the skin of the Time Manager Frame"],
				},
				Calendar = {
					type = "toggle",
					name = self.L["Calendar"],
					desc = self.L["Toggle the skin of the Calendar Frame"],
				},
				MenuFrames = {
					type = "toggle",
					name = self.L["Menu Frames"],
					desc = self.L["Toggle the skin of the Menu Frames"],
				},
				BankFrame = {
					type = "toggle",
					name = self.L["Bank Frame"],
					desc = self.L["Toggle the skin of the Bank Frame"],
				},
				MailFrame = {
					type = "toggle",
					name = self.L["Mail Frame"],
					desc = self.L["Toggle the skin of the Mail Frame"],
				},
				AuctionUI = {
					type = "toggle",
					name = self.L["Auction Frame"],
					desc = self.L["Toggle the skin of the Auction Frame"],
				},
				MainMenuBar = {
					type = "group",
					inline = true,
					order = -4,
					name = self.L["Main Menu Bar"],
					desc = self.L["Change the Main Menu Bar Frame Settings"],
					get = function(info) return db.MainMenuBar[info[#info]] end,
					set = function(info, value)
						db.MainMenuBar[info[#info]] = value
						self:checkAndRun("MainMenuBar")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Main Menu Bar Skin"],
							desc = self.L["Toggle the skin of the Main Menu Bar"],
						},
						glazesb = {
							type = "toggle",
							order = 2,
							width = "double",
							name = self.L["Glaze Main Menu Bar Status Bar"],
							desc = self.L["Toggle the glazing Main Menu Bar Status Bar"],
						},
					},
				},
				CoinPickup = {
					type = "toggle",
					name = self.L["Coin Pickup Frame"],
					desc = self.L["Toggle the skin of the Coin Pickup Frame"],
				},
				ItemSocketingUI = {
					type = "toggle",
					name = self.L["ItemSocketingUI Frame"],
					desc = self.L["Toggle the skin of the ItemSocketingUI Frame"],
				},
				GuildBankUI = {
					type = "toggle",
					name = self.L["GuildBankUI Frame"],
					desc = self.L["Toggle the skin of the GuildBankUI Frame"],
				},
				Nameplates = {
					type = "toggle",
					name = self.L["Nameplates"],
					desc = self.L["Toggle the skin of the Nameplates"],
				},
				GMChatUI = {
					type = "toggle",
					name = self.L["GMChatUI Frame"],
					desc = self.L["Toggle the skin of the GMChatUI Frame"],
				},
				LFDFrame = {
					type = "toggle",
					name = self.L["LFD Frame"],
					desc = self.L["Toggle the skin of the LFD Frame"],
				},
				LFRFrame = {
					type = "toggle",
					name = self.L["LFR Frame"],
					desc = self.L["Toggle the skin of the LFR Frame"],
				},
				BNFrames = {
					type = "toggle",
					name = self.L["BattleNet Frames"],
					desc = self.L["Toggle the skin of the BattleNet Frames"],
				},
			},
		},

		DisabledSkins = {
			type = "group",
			name = self.L["Disable Addon Skins"],
			get = function(info) return db.DisabledSkins[info[#info]] end,
			set = function(info, value) db.DisabledSkins[info[#info]] = value end,
			args = {
			},
		},

	}

	-- module options
	for _, mod in self:IterateModules() do
		if mod.GetOptions then
			optTables["Modules"].args[mod.name] = mod.GetOptions()
		end
	end

	-- optional options
	if self.isPTR then
		optTables.UIFrames.args["Feedback"] = {
			type = "toggle",
			name = self.L["FeedbackUI"],
			desc = self.L["Toggle the skinning of FeedbackUI"],
		}
	end
	if IsMacClient() then
		optTables.UIFrames.args["MovieProgress"] = {
			type = "toggle",
			name = self.L["Movie Progress"],
			desc = self.L["Toggle the skinning of Movie Progress"],
		}
	end

	-- add these if Baggins & its skin are loaded
	if IsAddOnLoaded("Baggins") and self.Baggins then
		-- setup option to change the Bank Bags colour
		local bbckey = {}
		bbckey.type = "color"
		bbckey.order = -1
		bbckey.width = "double"
		bbckey.name = self.L["Baggins Bank Bags Colour"]
		bbckey.desc = self.L["Set Baggins Bank Bags Colour"]
		bbckey.hasAlpha = true
		-- add to the colour submenu
		optTables.Colours.args["BagginsBBC"] = bbckey
		bbckey = nil
	end

	-- add DisabledSkins options
	local function addDSOpt(name)
		optTables["DisabledSkins"].args[name] = {
			type = "toggle",
			name = name,
			desc = self.L["Toggle the skinning of "]..name,
			width = name:len() > 20 and "double" or nil,
		}

	end
	for _, addonName in ipairs(self.addonSkins) do
		addDSOpt(addonName)
	end
	for _, addonName in ipairs(self.oddlyNamedAddons) do
		addDSOpt(addonName)
	end
	for _, addonName in ipairs(self.lodAddons) do
		addDSOpt(addonName)
	end

	-- add DB profile options
	optTables.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	-- option tables list
	local optNames = {
		"Backdrop", "Background", "Colours", "Gradient", "Modules", "NPCFrames", "PlayerFrames", "UIFrames", "DisabledSkins", "Profiles"
	}
	-- register the options tables and add them to the blizzard frame
	local ACR = LibStub("AceConfigRegistry-3.0")
	local ACD = LibStub("AceConfigDialog-3.0")

	LibStub("AceConfig-3.0"):RegisterOptionsTable(aName, optTables.General, {aName, "skin"})
	self.optionsFrame = ACD:AddToBlizOptions(aName, aName)

	-- register the options, add them to the Blizzard Options
	-- build the table used by the chatCommand function
	local optCheck = {}
	for _, v in ipairs(optNames) do
--		self:Debug("options: [%s]", v)
		local optTitle = (" "):join(aName, v)
		ACR:RegisterOptionsTable(optTitle, optTables[v])
		self.optionsFrame[self.L[v]] = ACD:AddToBlizOptions(optTitle, self.L[v], aName)
		optCheck[v:lower()] = v
	end

	-- runs when the player clicks "Defaults"
    self.optionsFrame[self.L["Backdrop"]].default = function()
        db.BdDefault = dflts.BdDefault
        db.BdFile = dflts.BdFile
        db.BdTexture = dflts.BdTexture
        db.BdTileSize = dflts.BdTileSize
        db.BdEdgeFile = dflts.BdEdgeFile
        db.BdBorderTexture = dflts.BdBorderTexture
        db.BdEdgeSize = dflts.BdEdgeSize
        db.BdInset = dflts.BdInset
        -- refresh panel
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Backdrop"]])
    end
    self.optionsFrame[self.L["Background"]].default = function()
        db.BgUseTex = dflts.BgUseTex
        db.BgFile = dflts.BgFile
        db.BgTexture = dflts.BgTexture
        db.BgTile = dflts.BgTile
        -- refresh panel
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Background"]])
    end
	self.optionsFrame[self.L["Colours"]].default = function()
		db.TooltipBorder = dflts.TooltipBorder
		db.BackdropBorder = dflts.BackdropBorder
		db.Backdrop = dflts.Backdrop
		db.HeadText = dflts.HeadText
		db.BodyText = dflts.BodyText
		db.GradientMin = dflts.GradientMin
		db.GradientMax = dflts.GradientMax
		-- refresh panel
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Colours"]])
	end
	self.optionsFrame[self.L["Gradient"]].default = function()
		db.Gradient.enable = dflts.Gradient.enable
		db.Gradient.invert = dflts.Gradient.invert
		db.Gradient.rotate = dflts.Gradient.rotate
		db.Gradient.char = dflts.Gradient.char
		db.Gradient.ui = dflts.Gradient.ui
		db.Gradient.npc = dflts.Gradient.npc
		db.Gradient.skinner = dflts.Gradient.skinner
		db.Gradient.texture = dflts.Gradient.texture
		-- refresh panel
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Gradient"]])
	end

	-- Slash command handler
	local function chatCommand(input)

		if not input or input:trim() == "" then
			-- Open general panel if there are no parameters
			InterfaceOptionsFrame_OpenToCategory(Skinner.optionsFrame)
		elseif optCheck[input:lower()] then
			InterfaceOptionsFrame_OpenToCategory(Skinner.optionsFrame[optCheck[input:lower()]])
		else
			LibStub("AceConfigCmd-3.0"):HandleCommand(aName, aName, input)
		end
	end

	-- Register slash command handlers
	self:RegisterChatCommand(aName, chatCommand)
	self:RegisterChatCommand("skin", chatCommand)

	-- setup the DB object
	self.DBObj = LibStub("LibDataBroker-1.1"):NewDataObject(aName, {
		type = "launcher",
		icon = [[Interface\Icons\INV_Misc_Pelt_Wolf_01]],
		OnClick = function() InterfaceOptionsFrame_OpenToCategory(Skinner.optionsFrame) end,
	})

	-- register the data object to the Icon library
	DBIcon:Register(aName, self.DBObj, db.MinimapIcon)

end
