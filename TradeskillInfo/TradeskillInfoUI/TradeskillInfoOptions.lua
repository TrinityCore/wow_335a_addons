local L = LibStub("AceLocale-3.0"):GetLocale("TradeskillInfoUI", true)
local TradeskillInfo = LibStub("AceAddon-3.0"):GetAddon("TradeskillInfo")

local function getOption(info)
	local key = info.arg
	return TradeskillInfo.db.profile[key]
end

local function setOption(info, value)
	local key = info.arg
	TradeskillInfo.db.profile[key] = value
end

local function getColor(info)
	local key = info.arg
	return TradeskillInfo.db.profile[key].r, TradeskillInfo.db.profile[key].g, TradeskillInfo.db.profile[key].b
end

local function setColor(info, r, g, b)
	local key = info.arg
	TradeskillInfo.db.profile[key] = { r = r, g = g, b = b}
end

local function getSelect(info)
	local key = info.arg
	return TradeskillInfo.db.profile[key]
end

local function setSelect(info, value)
	local key = info.arg
	TradeskillInfo.db.profile[key] = value
end

local function getMultiSelect(info, val)
	local key = info.arg
	return TradeskillInfo.db.profile[key][val]
end

local function setMultiSelect(info, val, state)
	local key = info.arg
	TradeskillInfo.db.profile[key][val] = state
end

local function getRange(info)
	local key = info.arg
	return TradeskillInfo.db.profile[key]
end

local function setRange(info, value)
	local key = info.arg
	TradeskillInfo.db.profile[key] = value
end

-- The multiselect value for "Known by", "Learnable by", etc.
-- It is all the skills we know about, plus recipes.
local knownSelect = {
	R = L["Recipes"],
}

for x, y in pairs(TradeskillInfo.vars.tradeskills) do
	knownSelect[x] = y
end

local tooltipOptions = {
	name = L["Tooltip"],
	type = "group",
	desc = L["Tooltip Options"],
	order = 1,
	args = {
		flags = {
			name = L["Flags"],
			type = "group",
			get = getOption,
			set = setOption,
			inline = true,
			order = 1,
			args = {
				source = {
					name = L["Source"],
					desc = L["Show the source of the item"],
					type = "toggle",
					arg = "TooltipSource",
				},
				usedin = {
					name = L["Used in"],
					desc = L["Show what tradeskill an item is used"],
					type = "toggle",
					arg = "TooltipUsedIn",
				},
				usableby = {
					name = L["Usable by"],
					desc = L["Show who can use an item"],
					type = "toggle",
					arg = "TooltipUsableBy",
					order = 800,
				},
				colorusableby = {
					name = L["Color usable by"],
					desc = L["Color the alt names in tooltip according to maximum combine difficulty"],
					type = "toggle",
					arg = "TooltipColorUsableBy",
					disabled = function() return not TradeskillInfo.db.profile["TooltipUsableBy"] end,
					order = 801,
				},
				sep1 = {
					name = "",
					type = "description",
					order = 899,
				},
				known = {
					name = L["Known by"],
					desc = L["Show who knows a recipe"],
					type = "multiselect",
					control = "Dropdown",
					values = knownSelect,
					order = 900,
					get = getMultiSelect,
					set = setMultiSelect,
					arg = "TooltipKnownBy",
				},
				learn = {
					name = L["Learnable by"],
					desc = L["Show who can learn a recipe"],
					type = "multiselect",
					control = "Dropdown",
					values = knownSelect,
					order = 910,
					get = getMultiSelect,
					set = setMultiSelect,
					arg = "TooltipLearnableBy",
				},
				willbe = {
					name = L["Will be able to learn"],
					desc = L["Show who will be able to learn a recipe"],
					type = "multiselect",
					control = "Dropdown",
					values = knownSelect,
					order = 920,
					get = getMultiSelect,
					set = setMultiSelect,
					arg = "TooltipAvailableTo",
				},
				itemid = {
					name = L["ItemID"],
					desc = L["Show the item's ID"],
					type = "toggle",
					arg = "TooltipID",
				},
				stacksize = {
					name = L["Stack Size"],
					desc = L["Show the item's stack size"],
					type = "toggle",
					arg = "TooltipStack",
				},
				marketvalue = {
					name = L["Market Value"],
					desc = L["Show the profit calculation from Auctioneer Market Value"],
					type = "toggle",
					arg = "TooltipMarketValue",
				},
				recipesource = {
					name = L["Recipe Source"],
					desc = L["Show the source of recipes"],
					type = "toggle",
					arg = "TooltipRecipeSource",
				},
				recipeprice = {
					name = L["Recipe Price"],
					desc = L["Show the price of recipes sold by vendors"],
					type = "toggle",
					arg = "TooltipRecipePrice",
				},
				banked = {
					name = L["Banked"],
					desc = L["Show how many you have in the bank (Req CharacterInfoStorage)"],
					type = "toggle",
					arg = "TooltipBankedAmount",
					disabled = function() return not CharacterInfoStorage end,
				},
				altamount = {
					name = L["Alt Amount"],
					desc = L["Show how many you have on alt's  (Req CharacterInfoStorage)"],
					type = "toggle",
					arg = "TooltipAltAmount",
					disabled = function() return not CharacterInfoStorage end,
				},
			}
		},
		colors = {
			name = L["Colors"],
			type = "group",
			get = getColor,
			set = setColor,
			inline = true,
			order = 2,
			args = {
				source = {
					name = L["Source"],
					desc = L["Show the source of the item"],
					type = "color",
					arg = "ColorSource",
				},
				usedin = {
					name = L["Used in"],
					desc = L["Show what tradeskill an item is used"],
					type = "color",
					arg = "ColorSource",
				},
				usableby = {
					name = L["Usable by"],
					desc = L["Show who can use an item"],
					type = "color",
					arg = "ColorUsableBy",
				},
				known = {
					name = L["Known by"],
					desc = L["Show who knows a recipe"],
					type = "color",
					arg = "ColorKnownBy",
				},
				learn = {
					name = L["Learnable by"],
					desc = L["Show who can learn a recipe"],
					type = "color",
					arg = "ColorLearnableBy",
				},
				willbe = {
					name = L["Will be able to learn"],
					desc = L["Show who will be able to learn a recipe"],
					type = "color",
					arg = "ColorAvailableTo",
				},
				itemid = {
					name = L["ItemID"],
					desc = L["Show the item's ID"],
					type = "color",
					arg = "ColorID",
				},
				stacksize = {
					name = L["Stack Size"],
					type = "color",
					arg = "ColorStack",
				},
				marketvalue = {
					name = L["Market Value"],
					desc = L["Show the profit calculation from Auctioneer Market Value"],
					type = "color",
					arg = "ColorMarketValue",
				},
				recipesource = {
					name = L["Recipe Source"],
					desc = L["Show the source of recipes"],
					type = "color",
					arg = "ColorRecipeSource",
				},
				recipeprice = {
					name = L["Recipe Price"],
					desc = L["Show the price of recipes sold by vendors"],
					type = "color",
					arg = "ColorRecipePrice",
				},
				banked = {
					name = L["Banked"],
					desc = L["Show how many you have in the bank (Req CharacterInfoStorage)"],
					type = "color",
					arg = "ColorBankedAmount",
					disabled = function() return not CharacterInfoStorage end,
				},
				altamount = {
					name = L["Alt Amount"],
					desc = L["Show how many you have on alt's  (Req CharacterInfoStorage)"],
					type = "color",
					arg = "ColorAltAmount",
					disabled = function() return not CharacterInfoStorage end,
				},
			}
		}
	}
}

local tradeskillOptions = {
	name = L["Trade Skill"],
	desc = L["Trade Skill Window options"],
	type = "group",
	order = 2,
	get = getOption,
	set = setOption,
	args = {
		skillreq = {
			name = L["Skill required"],
			desc = L["Show skill required"],
			type = "toggle",
			arg = "ShowSkillLevel",
			width = "full",
		},
		combinecost = {
			name = L["Combine cost"],
			desc = L["Show combine cost"],
			type = "toggle",
			arg = "ShowSkillProfit",
			width = "full",
		}
	}
}

local trainerOptions = {
	name = L["Trainer Window"],
	desc = L["Trainer Window options"],
	type = "group",
	order = 3,
	args = {
		skillreq = {
			name = L["Reagents"],
			desc = L["Show recipe reagents in tooltip at trainer"],
			type = "toggle",
			arg = "TrainerReagents",
			get = getOption,
			set = setOption,
		},
		combinecost = {
			name = L["Reagents Color"],
			desc = L["Color of recipe reagents in tooltip at trainer"],
			type = "color",
			arg = "ColorTrainerReagents",
			disabled = function() return not TradeskillInfo.db.profile["TrainerReagents"] end,
			get = getColor,
			set = setColor,
		}
	}
}

mouseSelect = {
	[1] = L["Left Button"],
	[2] = L["Right Button"]
}

modSelect = {
	[1] = L["Shift"],
	[2] = L["Control"],
	[3] = L["Alt"]
}

strataSelect = {
	[1] = L["LOW"],
	[2] = L["MEDIUM"],
	[3] = L["HIGH"]
}

local uiOptions = {
	name = L["UI"],
	desc = L["UI Options"],
	type = "group",
	order = 4,
	args = {
		quickSearch = {
			name = L["Quick Search"],
			desc = L["Enable Quick Search"],
			type = "toggle",
			arg = "QuickSearch",
			get = getOption,
			set = setOption,
			order = 10
		},
		sep1 = {
			name = "",
			type = "description",
			order = 19,
		},
		mouse = {
			name = L["Search Mouse Button"],
			desc = L["Mouse button that does a quick search"],
			type  = "select",
			values = mouseSelect,
			get = getSelect,
			set = setSelect,
			arg = "SearchMouseButton",
			disabled = function() return not TradeskillInfo.db.profile["QuickSearch"] end,
			order = 30
		},
		modifier = {
			name = L["Search Modifier Key"],
			desc = L["Modifier key to be held down for quick search"],
			type  = "select",
			values = modSelect,
			get = getSelect,
			set = setSelect,
			arg = "SearchShiftKey",
			disabled = function() return not TradeskillInfo.db.profile["QuickSearch"] end,
			order = 20
		},
		saveframe = {
			name = L["Save Frame Position"],
			desc = L["Remember TradeskillInfoUI frame position"],
			type = "toggle",
			arg = "SavePosition",
			get = getOption,
			set = setOption,
			order = 40
		},
		sep2 = {
			name = "",
			type = "description",
			order = 49,
		},
		strata = {
			name = L["Frame Strata"],
			desc = L["Set TradeskillInfoUI frame strata"],
			values = strataSelect,
			type = "select",
			get = getSelect,
			set = setSelect,
			arg = "FrameStrata",
			order = 50
		},
		scale = {
			name = L["UI Scale"],
			type = "range",
			desc = L["Change scale of user interface"],
			min = 0.5,
			max = 2,
			step = 0.05,
			isPercent = false,
			get = getRange,
			set = setRange,
			order = 60,
			arg = "UIScale",
		},
	}
}

local ahOptions = {
	name = L["Auction"],
	desc = L["Auction House Options"],
	type = "group",
	order = 5,
	get = getColor,
	set = setColor,
	args = {
		ahdesc = {
			name = L["Auction House related options"],
			type = "description",
			order = 1,
		},
		ahcolor = {
			name = L["Color Recipes"],
			desc =L["Color recipes in the Auction House"],
			type = "toggle",
			arg = "ColorAHRecipes",
			get = getOption,
			set = setOption,
			width = "full",
			order = 10,
		},
		playercan = {
			name = L["You can learn"],
			type = "color",
			arg = "AHColorLearnable",
			width = "full",
			disabled = function() return not TradeskillInfo.db.profile["ColorAHRecipes"] end,
			order = 20,
		},
		altcan = {
			name = L["An alt can learn"],
			type = "color",
			arg = "AHColorAltLearnable",
			width = "full",
			disabled = function() return not TradeskillInfo.db.profile["ColorAHRecipes"] end,
			order = 30,
		},
		playerwill = {
			name = L["You will be able to learn"],
			type = "color",
			arg = "AHColorWillLearn",
			width = "full",
			disabled = function() return not TradeskillInfo.db.profile["ColorAHRecipes"] end,
			order = 40,
		},
		altwill = {
			name = L["An alt will be able to learn"],
			type = "color",
			arg = "AHColorAltWillLearn",
			width = "full",
			disabled = function() return not TradeskillInfo.db.profile["ColorAHRecipes"] end,
			order = 50,
		},
		unavailable = {
			name = L["Unavailable or already known"],
			type = "color",
			arg = "AHColorUnavailable",
			width = "full",
			disabled = function() return not TradeskillInfo.db.profile["ColorAHRecipes"] end,
			order = 60,
		}
	}
}

local options = {
	name = "TradeskillInfo",
	type = "group",
	childGroups = "tab",
	args = {
		tooltip = tooltipOptions,
		tradeskill = tradeskillOptions,
		trainer = trainerOptions,
		ui = uiOptions,
		auction = ahOptions,
	},
}

-- Start registering the tables
local AceConfigRegistry = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(TradeskillInfo.db)

AceConfigRegistry:RegisterOptionsTable("TradeskillInfo", options)
TradeskillInfo.OptionsPanel =
	AceConfigDialog:AddToBlizOptions("TradeskillInfo", "TradeskillInfo")

--[[
TradeskillInfo.OptionsPanel =
	AceConfigDialog:AddToBlizOptions("TradeskillInfo", "TradeskillInfo", nil, "general")
AceConfigDialog:AddToBlizOptions("TradeskillInfo", L["Tooltip"], "TradeskillInfo", "tooltip")
AceConfigDialog:AddToBlizOptions("TradeskillInfo", L["Tradeskill"], "TradeskillInfo", "tradeskill")
AceConfigDialog:AddToBlizOptions("TradeskillInfo", L["Trainer"], "TradeskillInfo", "trainer")
AceConfigDialog:AddToBlizOptions("TradeskillInfo", L["UI"], "TradeskillInfo", "ui")
AceConfigDialog:AddToBlizOptions("TradeskillInfo", L["Auction House"], "TradeskillInfo", "auction")
AceConfigDialog:AddToBlizOptions("TradeskillInfo", L["Profile"], "TradeskillInfo", "profile")
]]--
