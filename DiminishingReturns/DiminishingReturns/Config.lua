local OPTION_CATEGORY = 'Diminishing Returns'

-- AddonLoader support
if AddonLoader and AddonLoader.RemoveInterfaceOptions then
	AddonLoader:RemoveInterfaceOptions(OPTION_CATEGORY)
end

local addon = DiminishingReturns
if not addon then return end

-----------------------------------------------------------------------------
-- Option table
-----------------------------------------------------------------------------

local L = addon.L
local SharedMedia = LibStub('LibSharedMedia-3.0')

local options, frameOptions

local function CreateOptions()
	local drdata = LibStub('DRData-1.0')
	local categoryGroup = {}
	local tmp = {}
	for cat, name in pairs(addon.CATEGORIES) do
		wipe(tmp)
		for spellId, spellCat in pairs(drdata:GetSpells()) do
			if spellCat == cat then
				local name, _, icon = GetSpellInfo(spellId)
				if name and not tmp[name] then
					tinsert(tmp, string.format('|T%s:0|t %s', icon, name))
					tmp[name] = true
				end
			end
		end
		local key, label, icon = cat, name, addon.ICONS[cat]
		if icon then
			label = string.format("|T%s:24|t %s", icon, name)
		end
		categoryGroup[key] = {
			name = label,
			desc = string.format(L['This category is triggered by the following effects:\n%s'], table.concat(tmp, '\n')),
			type = 'toggle',
			get = function()
				return addon.db.profile.categories[key]
			end,
			set = function(_, value)
				addon.db.profile.categories[key] = value
				addon:TriggerMessage('OnConfigChanged', 'categories,'..key, value)
			end
		}
	end

	options = {
		name = OPTION_CATEGORY,
		type = 'group',
		args = {
			learnCategories = {
				name = L['Learn categories to show'],
				desc = L['When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them.'],
				type = 'toggle',
				width = 'double',
				get = function() return addon.db.profile.learnCategories end,
				set = function(_, value)
					addon.db.profile.learnCategories = value
					addon:TriggerMessage('OnConfigChanged', 'learnCategories', value)
				end,
				order = 10,
			},
			categories = {
				name = L['Shown categories'],
				desc = L['Select diminishing returns categories to display.'],
				type = 'group',
				inline = true,
				args = categoryGroup,
				order = 20,
			},
			resetDelay = {
				name = L['Reset duration'],
				desc = L['This is the delay between the end of an effect and the time it can be applied at full length again. This delay is officialy 15 seconds but higher values have been recorded. You can do some tests and adjust this value accordingly. This will not affect running diminishing returns.'],
				type = 'range',
				min = 15,
				max = 20,
				step = 0.1,
				bigStep = 1,
				get = function() return addon.db.profile.resetDelay end,
				set = function(_, value) addon.db.profile.resetDelay = value end,
				order = 30,
			},
			bigTimer = {
				name = L['Big timer'],
				desc = L['Check this box to swap diminishing and timer texts.'],
				type = 'toggle',
				get = function() return addon.db.profile.bigTimer end,
				set = function(_, value)
					addon.db.profile.bigTimer = value
					addon:TriggerMessage('OnConfigChanged', 'bigTimer', value)
				end,
				order = 40,
			},
			pveMode = {
				name = L['PvE mode'],
				desc = L['Check this box to display diminishing returns on mobs. Please remember that diminishing returns usually do not apply to mobs.'],
				type = 'toggle',
				get = function() return addon.db.profile.pveMode end,
				set = function(_, value)
					addon.db.profile.pveMode = value
					addon:TriggerMessage('OnConfigChanged', 'pveMode', value)				
				end,
				order = 15,
			},
			testMode = {
				name = L['Enable test mode'],
				desc = L['Check this to display bogus icons on every supported frames.'],
				type = 'toggle',
				get = function() return addon.testMode end,
				set = function(_, value) addon:SetTestMode(value) end,
				order = 17,
			},
			soundAtReset = {
				name = L['Play sound at reset'],
				desc = L['Check this to play a sound when the diminishing return of a watched category is reset on any target.'],
				type = 'toggle',
				get = function() return addon.db.profile.soundAtReset end,
				set = function(_, value)
					addon.db.profile.soundAtReset = value
					addon:TriggerMessage('OnConfigChanged', 'soundAtReset', value)				
				end,
				order = 60,
			},
			resetSound = {
				name = L['"Reset" sound'],
				desc = L['Select the sound to play at reset. See SharedMedia documentation to know how to add new sounds.'],
				type = 'select',
				dialogControl = 'LSM30_Sound',
				values = SharedMedia:HashTable('sound'),
				get = function() return addon.db.profile.resetSound end,
				set = function(_, value)
					addon.db.profile.resetSound = value
					addon:TriggerMessage('OnConfigChanged', 'resetSound', value)				
				end,
				disabled = function() return not addon.db.profile.soundAtReset end,
				order = 65,
			},
		}
	}
	
	local alOption = {
			name = L['Postponed loading'],
			desc = L["Use this option to postpone loading. Once loaded, DiminishingReturns is always active outside of PvE instances.\nThis option requires AddonLoader."],
			type = 'select',
			order = 60,
	}
	
	if AddonLoader and AddonLoaderSV and AddonLoaderSV.overrides then
		local DEFAULT_VALUE = "DEFAULT"
		local loadOnSlash = "X-LoadOn-Slash: /drtest\n"
		local addonName = 'DiminishingReturns'
		alOption.get = function()
			return AddonLoaderSV.overrides[addonName] or DEFAULT_VALUE
		end
		alOption.set = function(_, value)
			AddonLoaderSV.overrides[addonName] = (value ~= DEFAULT_VALUE) and value or nil
		end
		alOption.values = {
			[DEFAULT_VALUE] = L['Always'],
			["X-LoadOn-PvPFlagged: yes\n"..loadOnSlash] = L['Being PvP flagged'],
			["X-LoadOn-Arena: yes\nX-LoadOn-Battleground: yes\n"..loadOnSlash] = L['Entering battleground or arena'],
			["X-LoadOn-Arena: yes\n"..loadOnSlash] = L['Entering arena only'],
		}
	else
		alOption.disabled = true
		alOption.get = function() return "always" end
		alOption.values = { always = L['Always'] }
	end
	
	options.args.addonLoader = alOption
	
	local pointValues = {
		TOPLEFT = L['Top left'],
		TOP = L['Top'],
		TOPRIGHT = L['Top right'],
		LEFT = L['Left'],
		CENTER = L['Center'],
		RIGHT = L['Right'],
		BOTTOMLEFT = L['Bottom left'],
		BOTTOM = L['Bottom'],
		BOTTOMRIGHT = L['Bottom right'],
	}
	
	local frameOptionProto = {
		type = 'group',
		get = function(info)
			local db, key = info.handler:GetDatabase(), info[#info]
			return db[key]
		end,
		set = function(info, value)
			local key = info[#info]
			local db = info.handler:GetDatabase()
			db[key] = value
			addon:TriggerMessage("OnFrameConfigChanged", key, value)
		end,
		args = {
			enabled = {
				name = L['Enabled'],
				desc = L['Check this box to attach diminishing return icons to this/these frame/s.'],
				type = 'toggle',
				order = 5,
			},
			iconSize = {
				name = L['Icon size'],
				desc = L['Use this to set the icon size, in pixels.'],
				type = 'range',
				min = 8,
				max = 64,
				step = 1,
				order = 10,
			},
			direction = {
				name = L['Direction'],
				desc = L['Select in which direction the icons are layed out.'],
				type = 'select',
				values = {
					LEFT = L['Left'],
					RIGHT = L['Right'],
					TOP = L['Top'],
					BOTTOM = L['Bottom'],
				},
				order = 20,
			},
			spacing = {
				name = L['Icon spacing'],
				desc = L['Use this to set the size of the gap between icons, in pixels.'],
				type = 'range',
				min = 0,
				max = 20,				
				step = 1,
				order = 30,
			},
			screenAnchor = {
				name = L['Anchor to screen'],
				desc = L['Check this to anchor the icon bar to the screen instead of the unit frame. This allows you to place it whereever you want.'],
				type = 'toggle',				
				order = 35,
			},
			anchorPoint = {
				name = L['Icon anchor'],
				desc = L['Select which side of the icon bar is attached to the unit frame.'],
				type = 'select',
				values = pointValues,
				order = 40,
			},
			relPoint = {
				name = L['Frame side'],
				desc = L['Select to which side of the unit frame the icon bar is attached.'],
				type = 'select',
				values = pointValues,
				order = 50,
			},
			xOffset = {
				name = L['X offset'],
				desc = L['Use this to set a vertical offset between the icon anchor and the unit frame attach point, in pixels.'],
				type = 'range',
				min = -1000,
				max = 1000,
				step = 1,
				bigStep = 10,
				order = 60,
			},
			yOffset = {
				name = L['Y offset'],
				desc = L['Use this to set an horizontal offset between the icon anchor and the unit frame attach point, in pixels.'],
				type = 'range',
				min = -1000,
				max = 1000,
				step = 1,
				bigStep = 10,
				order = 70,
			},
		},
	}

	frameOptions = {
		name = L['Frame options'],
		type = 'group',
		childGroups = 'select',
		args = {
			empty = {
				name = L['No supported addon has been loaded yet.'],
				type = 'description',
			},
		}
	}
	
	-- Replace registry function
	function addon:RegisterFrameConfig(label, getDatabaseCallback)
		local key = label:gsub('[^%w]', '_')
		local opts = {
			name = label,
			handler = handler,
			handler = { GetDatabase = getDatabaseCallback },
		}
		for k, v in pairs(frameOptionProto) do
			opts[k] = v
		end
		frameOptions.args.empty = nil
		frameOptions.args[key] = opts
	end
	
	-- Register existing config
	if addon.pendingFrameConfig then
		for label, getDatabaseCallback in pairs(addon.pendingFrameConfig) do
			addon:RegisterFrameConfig(label, getDatabaseCallback)
		end
		addon.pendingFrameConfig = nil
	end
end

-----------------------------------------------------------------------------
-- Setup
-----------------------------------------------------------------------------

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Main options
AceConfig:RegisterOptionsTable('DimRet-main', function() if not options then CreateOptions() end return options end)
AceConfigDialog:AddToBlizOptions('DimRet-main', OPTION_CATEGORY)

-- Frame options
AceConfig:RegisterOptionsTable('DimRet-frames', function() if not frameOptions then CreateOptions() end return frameOptions end)
AceConfigDialog:AddToBlizOptions('DimRet-frames', L['Frame options'], OPTION_CATEGORY)

-- Profile options
local dbOptions = LibStub('AceDBOptions-3.0'):GetOptionsTable(addon.db)
if addon.LibDualSpec then
	addon.LibDualSpec:EnhanceOptions(dbOptions, addon.db)
end
AceConfig:RegisterOptionsTable('DimRet-profiles', dbOptions)
AceConfigDialog:AddToBlizOptions('DimRet-profiles', dbOptions.name, OPTION_CATEGORY)

-- Slash command
_G['SLASH_DIMRET1'] = '/dimret'
SlashCmdList.DIMRET = function() InterfaceOptionsFrame_OpenToCategory(OPTION_CATEGORY) end

