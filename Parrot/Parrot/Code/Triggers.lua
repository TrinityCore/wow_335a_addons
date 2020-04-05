local Parrot = Parrot
local Parrot_Triggers = Parrot:NewModule("Triggers", "AceTimer-3.0")
local self = Parrot_Triggers

--[===[@debug@
_G.Parrot_Triggers = self
--@end-debug@]===]

local L = LibStub("AceLocale-3.0"):GetLocale("Parrot_Triggers")
local LC = _G.LOCALIZED_CLASS_NAMES_MALE

local newList = Parrot.newList
local newSet = Parrot.newSet
local newDict = Parrot.newDict
local del = Parrot.del
local unpackDictAndDel= Parrot.unpackDictAndDel

local debug = Parrot.debug
local deepCopy = Parrot.deepCopy

local _,playerClass = UnitClass("player")

local SharedMedia = LibStub("LibSharedMedia-3.0")

--[[
	List of default Triggers:
	Index is starting at 1001. User-created triggers start at index 1.
	The reason is that when a new default-trigger is added, it will always get
	inserted into the db, even if the user created some custom triggers in the
	meanwhile.
--]]

local defaultTriggers = {
	[1001] = {
		-- 34939 = Backlash
		name = L["%s!"]:format(GetSpellInfo(34939)),
		icon = 34939,
		class = "WARLOCK",
		conditions = {
			["Aura gain"] = {
				{
					spell = GetSpellInfo(34939),
					unit = "player",
					auraType = "BUFF",
				}
			},
		},
		sticky = true,
		color = "ff00ff",
	},
	[1002] = {
		-- 16246 = Clearcasting (Priest) TODO
		name = L["%s!"]:format(GetSpellInfo(16246)),
		icon = 16246,
		class = "MAGE;PRIEST;SHAMAN",
		conditions = {
			["Aura gain"] = {
				{
					spell = GetSpellInfo(16246),
					unit = "player",
					auraType = "BUFF",
				}
			},
		},
		sticky = true,
		color = "ffff00",
	},
	[1003] = {
		-- 27067 = Counterattack
		name = L["%s!"]:format(GetSpellInfo(27067)),
		icon = 27067,
		class = "HUNTER",
		conditions = {
			["Incoming miss"] = { "PARRY",	},
		},
		secondaryConditions = {
			["Spell ready"] = {
				[1] = GetSpellInfo(27067),
			},
		},
		sticky = true,
		color = "ffff00",
	},
	[1004] = {
		-- 25236 = Execute
		name = L["%s!"]:format(GetSpellInfo(25236)),
		icon = 25236,
		class = "WARRIOR",
		conditions = {
			["Unit health"] = {
				{
					unit = "target",
					amount = 0.20,
					comparator = "<",
					friendly = 0,
				},
			},
		},
		secondaryConditions = {
			["Spell ready"] = {
				[1] = GetSpellInfo(25236),
			},
		},
		sticky = true,
		color = "ffff00",
	},
	[1005] = {
		-- Frostbite = 12497
		name = L["%s!"]:format(GetSpellInfo(12497)),
		icon = 12497,
		class = "MAGE",
		conditions = {
			["Aura gain"] = {
				{
					spell = GetSpellInfo(12497),
					unit = "target",
					auraType = "DEBUFF",
				}
			}
		},
		sticky = true,
		color = "0000ff",
	},
	[1006] = {
		-- 27180 - Hammer of Wrath
		name = L["%s!"]:format(GetSpellInfo(27180)),
		icon = 27180,
		class = "PALADIN",
		conditions = {
			["Unit health"] = {
				{
					unit = "target",
					amount = 0.20,
					comparator = "<",
					friendly = 0,
				},
			},
		},
		secondaryConditions = {
			["Spell ready"] = {
				[1] = GetSpellInfo(27180),
			},
		},
		sticky = true,
		color = "ffff00",
	},
	[1007] = {
		-- Impact = 11103
		name = L["%s!"]:format(GetSpellInfo(11103)),
		icon = 11103,
		class = "MAGE",
		conditions = {
			["Aura gain"] = {
				{
					spell = GetSpellInfo(11103),
					unit = "target",
					auraType = "DEBUFF",
				}
			},
		},
		sticky = true,
		color = "ff0000",
	},
	[1008] = {
		name = L["Low Health!"],
		class = "DRUID;HUNTER;MAGE;PALADIN;PRIEST;ROGUE;SHAMAN;WARLOCK;WARRIOR;DEATHKNIGHT",
		conditions = {
			["Unit health"] = {
				{
					unit = "player",
					amount = 0.40,
					comparator = "<=",
					friendly = 1,
				},
			},
		},
		secondaryConditions = {
			["Trigger cooldown"] = 3,
		},
		sticky = true,
		color = "ff7f7f",
	},
	[1009] = {
		name = L["Low Mana!"],
		class = "DRUID;HUNTER;MAGE;PALADIN;PRIEST;SHAMAN;WARLOCK",
		conditions = {
			["Unit power"] = {
				{
					unit = "player",
					amount = 0.35,
					comparator = "<=",
					friendly = 1,
					powerType = "MANA",
				},
			},
		},
		secondaryConditions = {
			["Trigger cooldown"] = 3,
		},
		sticky = true,
		color = "7f7fff",
	},
	[1010] = {
		name = L["Low Pet Health!"],
		class = "HUNTER;MAGE;WARLOCK;DEATHKNIGHT",
		conditions = {
			["Unit health"] = {
				[1] = {
					unit = "pet",
					amount = 0.40,
					comparator = "<=",
					friendly = 1,
				},
			},
		},
		secondaryConditions = {
			["Trigger cooldown"] = 3,
		},
		color = "ff7f7f",
	},
	[1011] = {
		-- 18095 = Nightfall
		name = L["%s!"]:format(GetSpellInfo(18095)),
		icon = 18095,
		class = "WARLOCK",
		conditions = {
			["Aura gain"] = {
				{
					spell = GetSpellInfo(17941),
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "7f007f",
	},
	[1012] = {
		-- 33154 Surge of Light
		name = L["%s!"]:format(GetSpellInfo(33154)),
		icon = 25364,
		class = "PRIEST",
		conditions = {
			["Aura gain"] = {
				{
					spell = GetSpellInfo(33154),
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		disabled = true,
		color = "ff0000",
	},
	[1013] = {
		-- Overpower = 11585
		name = L["%s!"]:format(GetSpellInfo(11585)),
		icon = 11585,
		class = "WARRIOR",
		conditions = {
			["Outgoing miss"] = { "DODGE", },
		},
		secondaryConditions = {
			["Spell ready"] = {
				[1] = GetSpellInfo(11585),
			},
			["Warrior stance"] = {
				[1] = "Battle Stance",
			},
		},
		sticky = true,
		color = "7f007f",
	},
	[1014] = {
		-- Revenge = 30357
		name = L["%s!"]:format(GetSpellInfo(30357)),
		icon = 30357,
		class = "WARRIOR",
		conditions = {
			["Incoming miss"] = { "BLOCK", "DODGE", "PARRY", },
		},
		secondaryConditions = {
			["Spell ready"] = {
				[1] = GetSpellInfo(30357),
			},
			["Warrior stance"] = {
				"Defensive Stance",
			},
		},
		sticky = true,
		color = "ffff00",
		disabled = true,
	},
	[1015] = {
		-- Riposte = 14251
		name = L["%s!"]:format(GetSpellInfo(14251)),
		icon = 14251,
		class = "ROGUE",
		conditions = {
			["Incoming miss"] = { "PARRY", },
		},
		secondaryConditions = {
			["Spell ready"] = {
				[1] = GetSpellInfo(14251),
			},
		},
		sticky = true,
		color = "ffff00",
	},--]]
	[1016] = {
		-- Maelstrom Weapon = 51532
		name = L["%s!"]:format(GetSpellInfo(51532)),
		icon = 51532,
		class = "SHAMAN",
		conditions = {
			["Aura stack gain"] = {
				{
					spell = GetSpellInfo(51532),
					unit = "player",
					auraType = "BUFF",
					amount = 5,
				},
			},
		},
		sticky = true,
		color = "0000ff",
	},
	-- Deathknight-triggers by waallen
	[1017] = {
		-- Freezing Fog = 59052
		name = L["%s!"]:format(GetSpellInfo(59052)),
		icon = 59052,
		class = "DEATHKNIGHT",
		conditions = {
			["Aura gain"] = {
				[1] = {
					spell = GetSpellInfo(59052),
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "0000ff",
	},
	[1018] = {
		-- Killing Machine	= 51130
		name = L["%s!"]:format(GetSpellInfo(51130)),
		icon = 51130,
		class = "DEATHKNIGHT",
		conditions = {
			["Aura gain"] = {
				[1] = {
					spell = GetSpellInfo(51130),
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "0000ff",
	},
	[1019] = {
		-- Rune Strike = 56816
		name = L["%s!"]:format(GetSpellInfo(56816)),
		icon = 56816,
		class = "DEATHKNIGHT",
		conditions = {
			["Incoming miss"] = { "DODGE", "PARRY", },
		},
		sticky = true,
		color = "0000ff",
		disabled = true,
	},
	[1020] = {
		-- Lock and Load = 56344
		name = L["%s!"]:format(GetSpellInfo(56344)),
		icon = 56344,
		class = "HUNTER",
		conditions = {
			["Aura gain"] = {
				[1] = {
					spell = GetSpellInfo(56344),
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "ff0000",
	},
	[1021] = {
		-- Brain Freeze = 57761
		name = L["%s!"]:format(GetSpellInfo(44549)),
		icon = 57761,
		class = "MAGE",
		conditions = {
			["Aura gain"] = {
				[1] = {
					spell = GetSpellInfo(57761),
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "0000ff",
	},
	[1022] = {
		-- Sudden Death 52437
		name = L["%s!"]:format(GetSpellInfo(52437)),
		icon = 52437,
		class = "WARRIOR",
		conditions = {
			["Aura gain"] = {
				[1] = {
					spell = GetSpellInfo(52437),
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "ff0000",
	},
	[1023] = {
		-- Eclipse
		id = 28,
		name = L["%s!"]:format(("%s %s"):format(GetSpellInfo(48518), GetSpellInfo(48465))), -- Starfire
		icon = 48518,
		class = "DRUID",
		conditions = {
			["Aura gain"] = {
				[1] = {
					spell = 48518,
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "ffffff",
	},
	[1024] = {
		name = L["%s!"]:format(("%s %s"):format(GetSpellInfo(48517), GetSpellInfo(48461))), -- Wrath
		icon = 48517,
		class = "DRUID",
		conditions = {
			["Aura gain"] = {
				[1] = {
					spell = 48517,
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "ffffff",
	},
	[1025] = {
		-- The Art of War
		name = L["%s!"]:format(GetSpellInfo(53489)),
		icon = 53489,
		class = "PALADIN",
		conditions = {
			["Aura gain"] = {
				[1] = {
					spell = GetSpellInfo(53489),
					unit = "player",
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "ffff00",
	},
	[1026] = {
		name = L["%s!"]:format(GetSpellInfo(53351)),
		icon = 53351,
		class = "HUNTER",
		conditions = {
			["Unit health"] = {
				[1] = {
					unit = "target",
					friendly = 0,
					amount = 0.2,
					comparator = "<=",
				},
			},
		},
		secondaryConditions = {
			["Spell ready"] = {
				[1] = GetSpellInfo(53351),
			},
		},
		sticky = true,
		color = "ff0000",
	},
	[1027] = { -- Molten Core
		name = L["%s!"]:format(GetSpellInfo(71165)),
		icon = 71165,
		class = "WARLOCK",
		conditions = {
			["Aura gain"] = {
				[1] = {
					unit = "player",
					spell = GetSpellInfo(71165),
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "7f007f",
	},
	[1028] = { -- Serendipity
		name = L["%s!"]:format(GetSpellInfo(63734)),
		icon = 63734,
		class = "PRIEST",
		conditions = {
			["Aura stack gain"] = {
				[1] = {
					["unit"] = "player",
					["spell"] = GetSpellInfo(63734),
					["auraType"] = "BUFF",
					["amount"] = 3,
				},
			},
		},
		sticky = true,
		disabled = true,
		color = "00c0ff",
	},
	[1029] = {
		-- 44401 = Missile Barrage
		name = L["%s!"]:format(GetSpellInfo(44401)),
		icon = 44401,
		class = "MAGE",
		conditions = {
			["Aura gain"] = {
				[1] = {
					["unit"] = "player",
					["spell"] = GetSpellInfo(44401),
					["auraType"] = "BUFF",
				},
			},
		},
		sticky = true,
		color = "cc00cc",
	},
	[1030] = {
		-- 63165 Decimation
		name = L["%s!"]:format(GetSpellInfo(63165)),
		icon = 63165,
		class = "WARLOCK",
		conditions = {
			["Aura gain"] = {
				[1] = {
					unit = "player",
					spell = GetSpellInfo(63165),
					auraType = "BUFF",
				},
			},
		},
		sticky = true,
		color = "ffbe00",
	},
	[1031] = {
		-- 44544 = Fingers of frost
		name = L["%s!"]:format(GetSpellInfo(44544)),
		icon = 44544,
		class = "MAGE",
		conditions = {
			["Aura gain"] = {
				[1] = {
					["unit"] = "player",
					["spell"] = GetSpellInfo(44544),
					["auraType"] = "BUFF",
				},
			},
		},
		sticky = true,
		color = "005ba9",
	},
}

local dbDefaults = {
	profile = {
		triggers2 = defaultTriggers,
		dbver = 0,
	},
}

local effectiveRegistry = {}
local periodicCheckTimer
local function rebuildEffectiveRegistry()
	for i = 1, #effectiveRegistry do
		effectiveRegistry[i] = nil
	end
	self:CancelTimer(periodicCheckTimer, true)
	periodicCheckTimer = nil
	local containsPeriodic = false
	for _,v in pairs(Parrot_Triggers.db1.profile.triggers2) do
		if not v.disabled then
			local classes = newSet((';'):split(v.class))
			if classes[playerClass] then
				effectiveRegistry[#effectiveRegistry+1] = v
				if v.conditions["Check every XX seconds"] then
					containsPeriodic = true
				end
			end
			classes = del(classes)
		end
	end
	if containsPeriodic then
		periodicCheckTimer = self:ScheduleRepeatingTimer(function()
			Parrot:FirePrimaryTriggerCondition("Check every XX seconds")
		end, 0.1)
	end
end

-- so triggers can be enabled/disabled from outside
function Parrot_Triggers:setTriggerEnabled(triggerindex, enabled)
	self.db1.profile.triggers2[triggerindex].disabled = not enabled
	rebuildEffectiveRegistry()
end

local cooldowns = {}
local currentTrigger
local Parrot_TriggerConditions
local Parrot_Display
local Parrot_ScrollAreas
local Parrot_CombatEvents

function Parrot_Triggers:OnInitialize()

	Parrot_Triggers.db1 = Parrot.db1:RegisterNamespace("Triggers", dbDefaults)
	self.db1.RegisterCallback(Parrot_Triggers, "OnNewProfile", "OnNewProfile")

	Parrot_Display = Parrot:GetModule("Display")
	Parrot_ScrollAreas = Parrot:GetModule("ScrollAreas")
	Parrot_TriggerConditions = Parrot:GetModule("TriggerConditions")
	Parrot_CombatEvents = Parrot:GetModule("CombatEvents")
end

--[[============================================================================
* This code is for converting Trigggers created before v1.10 to the
* triggers2-table
============================================================================--]]
local triggers2translation = {
	["Self buff gain"] = function(spell)
			local arg = {
				auraType = "BUFF",
				unit = "player",
				spell = spell,
			}
			return "Aura gain", arg
		end,
	["Self buff stacks gain"] = function(string)
			local spell, amount = (","):split(string)
			local arg = {
				auraType = "BUFF",
				unit = "player",
				spell = spell,
				amount = tonumber(amount),
			}
			return "Aura stack gain", arg
		end,
	["Self buff fade"] = function(spell)
			local arg = {
				auraType = "BUFF",
				unit = "player",
				spell = spell,
			}
			return "Aura fade", arg
		end,
	["Self debuff gain"] = function(spell)
			local arg = {
				auraType = "DEBUFF",
				unit = "player",
				spell = spell,
			}
			return "Aura gain", arg
		end,
	["Self debuff fade"] = function(spell)
			local arg = {
				auraType = "DEBUFF",
				unit = "player",
				spell = spell,
			}
			return "Aura fade", arg
		end,
	["Target buff gain"] = function(spell)
			local arg = {
				auraType = "BUFF",
				unit = "target",
				spell = spell,
			}
			return "Aura gain", arg
		end,
	["Target buff fade"] = function(spell)
			local arg = {
				auraType = "BUFF",
				unit = "target",
				spell = spell,
			}
			return "Aura fade", arg
		end,
	["Target debuff gain"] = function(spell)
			local arg = {
				auraType = "DEBUFF",
				unit = "target",
				spell = spell,
			}
			return "Aura gain", arg
		end,
	["Target debuff fade"] = function(spell)
			local arg = {
				auraType = "DEBUFF",
				unit = "target",
				spell = spell,
			}
			return "Aura fade", arg
		end,
	["Focus buff gain"] = function(spell)
			local arg = {
				auraType = "BUFF",
				unit = "focus",
				spell = spell,
			}
			return "Aura gain", arg
		end,
	["Focus buff fade"] = function(spell)
			local arg = {
				auraType = "BUFF",
				unit = "focus",
				spell = spell,
			}
			return "Aura fade", arg
		end,
	["Focus debuff gain"] = function(spell)
			local arg = {
				auraType = "DEBUFF",
				unit = "focus",
				spell = spell,
			}
			return "Aura gain", arg
		end,
	["Focus debuff fade"] = function(spell)
			local arg = {
				auraType = "DEBUFF",
				unit = "focus",
				spell = spell,
			}
			return "Aura fade", arg
		end,
	["Enter combat"] = true,
	["Leave combat"] = true,
	["Spell ready"] = function(spell)
			return "Spell ready", spell
		end,

	["Enemy target health percent"] = function(param)
			local arg = {
				unit = "target",
				friendly = 0,
				amount = param,
				comparator = "<=",
			}
			return "Unit health", arg
		end,
	["Friendly target health percent"] = function(param)
			local arg = {
				unit = "target",
				friendly = 1,
				amount = param,
				comparator = "<=",
			}
			return "Unit health", arg
		end,
	["Self health percent"] = function(param)
			local arg = {
				unit = "player",
				friendly = 1,
				amount = param,
				comparator = "<=",
			}
			return "Unit health", arg
		end,
	["Self mana percent"] = function(param)
			local arg = {
				unit = "player",
				friendly = 1,
				amount = param,
				comparator = "<=",
				powerType = "MANA",
			}
			return "Unit power", arg
		end,
	["Pet health percent"] = function(param)
			local arg = {
				unit = "pet",
				friendly = 1,
				amount = param,
				comparator = "<=",
			}
			return "Unit health", arg
		end,
	["Pet mana percent"] = function(param)
			local arg = {
				unit = "pet",
				friendly = 1,
				amount = param,
				comparator = "<=",
				powerType = "MANA",
			}
			return "Unit power", arg
		end,
	["Incoming Block"] = function()
			return "Incoming miss", "BLOCK"
		end,
	["Incoming Dodge"] = function()
			return "Incoming miss", "DODGE"
		end,
	["Incoming Parry"] = function()
			return "Incoming miss", "PARRY"
		end,
	["Outgoing Block"] = function()
			return "Outgoing miss", "BLOCK"
		end,
	["Outgoing Dodge"] = function()
			return "Outgoing miss", "DODGE"
		end,
	["Outgoing Parry"] = function()
			return "Outgoing miss", "PARRY"
		end,
	["Incoming crit"] = true,
	["Outgoing crit"] = true,
	["Outgoing cast"] = function(param)
			return "Outgoing cast", param
		end,
	["Incoming cast"] = function(param)
			return "Incoming cast", param
		end,
	["Successful spell cast"] = function(param)
			return "Successful spell cast", {}
		end,
	["Check every XX seconds"] = true,
	["Self item buff gain"] = function(param)
			local arg = {
				unit = "player",
				spell = param,
			}
			return "Item buff gain", arg
		end,
	["Self Item buff fade"] = function(param)
			local arg = {
				unit = "player",
				spell = param,
			}
			return "Item buff fade", arg
		end,
}

local triggers2secondary = {
	["Buff inactive"] = function(param)
			local arg = {
				unit = "player",
				byplayer = false,
				spell = param,
			}
			return "Buff inactive", arg
		end,
	["~Buff inactive"] = function(param)
			local arg = {
				unit = "player",
				byplayer = false,
				spell = param,
			}
			return "Aura active", arg
		end,
	["In combat"] = true,
	["~In combat"] = true,
	["Spell ready"] = function(param)
			return "Spell ready", param
		end,
	["Spell usable"] = function(param)
			return "Spell usable", param
		end,
	["Minimum power amount"] = function(param)
			local arg = {
				unit = "player",
				amount = param,
				friendly = 1,
				comparator = ">=",
				powerType = "MANA",
			}
			return "Unit power", arg
		end,
	["Minimum power percent"] = function(param)
			local arg = {
				unit = "player",
				amount = param,
				friendly = 1,
				comparator = ">=",
				powerType = "MANA",
			}
			return "Unit power", arg
		end,
	["Warrior stance"] = function(param)
			return "Warrior stance", param
		end,
	["~Warrior stance"] = function(param)
			return "~Warrior stance", param
		end,
	["Druid Form"] = function(param)
			return "Druid Form", param
		end,
	["~Druid Form"] = function(param)
			return "~Druid Form", param
		end,
	["Deathknight presence"] = function(param)
			return "Deathknight presence", param
		end,
	["~Deathknight presence"] = function(param)
			return "~Deathknight presence", param
		end,
	["Grouped"] = true,
	["Mounted"] = true,
	["InVehicle"] = true,
	["Target is player"] = true,
	["~Grouped"] = true,
	["~Mounted"] = true,
	["~InVehicle"] = true,
	["~Target is player"] = true,
	["Lua function"] = function(arg)
			return "Lua function", arg
		end,
	["Minimum target health"] = function(param)
			local arg = {
				unit = "target",
				amount = param,
				friendly = -1,
				comparator = ">=",
			}
			return "Unit health", arg
		end,
	["Minimum target health percent"] = function(param)
			local arg = {
				unit = "target",
				amount = param,
				friendly = -1,
				comparator = ">=",
			}
			return "Unit health", arg
		end,
	["Maximum target health percent"] = function(param)
			local arg = {
				unit = "target",
				amount = param,
				friendly = -1,
				comparator = "<=",
			}
			return "Unit health", arg
		end,
	["Trigger cooldown"] = true,
}

local function convertTriggers2()
	if not self.db1.profile.triggers then
		return
	end
	for i,t in ipairs(self.db1.profile.triggers) do
		local tmp = deepCopy(t)
		local cond = t.conditions
		tmp.conditions = {}
		for k,v in pairs(cond) do
			if triggers2translation[k] == true then
				tmp.conditions[k] = v
			elseif type(triggers2translation[k]) == 'function' then
				local name, arg = triggers2translation[k](v)
				if Parrot_TriggerConditions:IsExclusive(name) then
					tmp.conditions[name] = arg
				else
					if tmp.conditions[name] and type(tmp.conditions[name]) == 'table' then
						table.insert(tmp.conditions[name], arg)
					else
						tmp.conditions[name] = { arg, }
					end
				end
			else
				debug(k, " not found")
			end
		end
		cond = tmp.secondaryConditions
		if cond then
			tmp.secondaryConditions = {}
			for k,v in pairs(cond) do
				if triggers2secondary[k] == true then
					tmp.secondaryConditions[k] = v
				elseif type(triggers2secondary[k]) == 'function' then
					local name, arg = triggers2secondary[k](v)
					if Parrot_TriggerConditions:SecondaryIsExclusive(name) then
						tmp.secondaryConditions[name] = arg
					else
						if tmp.secondaryConditions[name] and type(tmp.secondaryConditions[name]) == 'table' then
							table.insert(tmp.secondaryConditions[name], arg)
						else
							tmp.secondaryConditions[name] = { arg, }
						end
					end
				else
					debug(k, " not found")
				end
			end
		end
		if tmp.id then
			tmp.id = nil
		end
		local index
		for k,t2 in pairs(defaultTriggers) do
			if t2.name == tmp.name then
				debug("matched ", t2.name, " from old triggers")
				index = k
				break
			end
		end
		if index then
			self.db1.profile.triggers2[index] = tmp
		else
			table.insert(self.db1.profile.triggers2, tmp)
		end
		-- deleting old triggers
--		self.db1.profile.triggers = nil
			self.db1.profile.version = nil
	end
end

alpha2alpah1translate = {
	["Aura inactive"] = function(param)
			local arg = {}
			for k,v in ipairs(param) do
				arg[k] = {
					unit = "player",
					byplayer = false,
					spell = v,
				}
			end
			return "Buff inactive", arg
		end,
	["~Aura inactive"] = function(param)
			local arg = {}
			for k,v in ipairs(param) do
				arg[k] = {
					unit = "player",
					byplayer = false,
					spell = v,
				}
			end
			return "Buff active", arg
		end,
}

local function alpha2alpha1()
	for i,t in pairs(self.db1.profile.triggers2) do
		if t.secondaryConditions then
			local news = {}
			for k,cond in pairs(t.secondaryConditions) do
				local func = alpha2alpah1translate[k]
				if func then
					local newk, newv = func(cond)
					news[newk] = newv
				else
					news[k] = cond
				end -- if func
			end -- for k,cond
			t.secondaryConditions = news
		end -- if t.secondaryConditions
	end-- for i,t
end

--[[
-- reset the Powertype for the low mana-trigger to MANA because previous
-- conversions (alpha->alpha) caused it to be "*".
--]]
local function resetLowManaPowerType()
	self.db1.profile.triggers2[1009].conditions["Unit power"][1].
		powerType = "MANA"
end

--[[============================================================================
* End of 1.9->1.10 conversion code
============================================================================--]]

--[[
* General purpose update-db-functions
--]]
local updateFuncs = {
	[1] = convertTriggers2,
	[2] = alpha2alpha1,
	[3] = resetLowManaPowerType,
}

function Parrot_Triggers:OnNewProfile(t, key)
	key.profile.dbver = #updateFuncs
end

local function updateDB()
	if not self.db1.profile.dbver then
		self.db1.profile.dbver = 0
	end
	for i = (self.db1.profile.dbver + 1), #updateFuncs do
		Parrot:Print(("updating DB %d->%d"):format(i-1, i))
		updateFuncs[i]()
		self.db1.profile.dbver = i
	end
end

function Parrot_Triggers:ApplyConfig()
	updateDB()
	Parrot.options.args.triggers = nil
	self:OnOptionsCreate()
	rebuildEffectiveRegistry()
end
local first = true
function Parrot_Triggers:OnEnable()

	updateDB()

	if first then
		Parrot_TriggerConditions:RegisterSecondaryTriggerCondition {
			name = "Trigger cooldown",
			localName = L["Trigger cooldown"],
			defaultParam = 3,
			param = {
				type = 'number',
				min = 0,
				max = 60,
				step = 0.1,
				bigStep = 1,
			},
			exclusive = true,
			check = function(param)
				-- special handling
					return true
			end,
		}

		Parrot:RegisterPrimaryTriggerCondition {
			name = "Check every XX seconds",
			localName = L["Check every XX seconds"],
			defaultParam = 3,
			param = {
				type = 'number',
				min = 0,
				max = 60,
				step = 0.1,
				bigStep = 1,
			},
			exclusive = true,
		}
		first = false
	end

	rebuildEffectiveRegistry()
end

local function hexColorToTuple(color)
	local num = tonumber(color, 16)
	return math.floor(num / 256^2)/255, math.floor((num / 256)%256)/255, (num%256)/255
end

-- to find the icon for old saved variables

local oldIconName = {
	["Backlash"] = 34939,
	["Clearcasting"] = 16246,
	["Counterattack"] = 27067,
	["Frostbite"] = 12497,
	["Impact"] = 12360,
	["Nightfall"] = 18095,
	["Overpower"] = 11585,
	["Rampage"] = 30033,
	["Revenge"] = 30357,
	["Riposte"] = 14251,
}

local function figureIconPath(icon)
	if not icon then
		return nil
	end

	local path
	-- if the icon is a number, it's most likly a spellid
	local spellId = tonumber(icon)
	if spellId then
		path = select(3,GetSpellInfo(spellId))
		return path
	end

	-- if the spell is in the spellbook, the icon can be retrieved that way
	path = select(3, GetSpellInfo(icon))
	if path then
		return path
	end

	-- the last chance is, that it's an option saved by an old parrot version
	-- the strings from the default-options can be resolved by the table provided above
	local oldIcon = oldIconName[icon]
	if oldIcon then
		path = select(3, GetSpellInfo(oldIcon))
		if path then
			return path
		end
	end

	-- perhaps it's an item
	local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(icon)
	if texture then
		return texture
	end
	-- nothing worked, either it's a path or a spell where the icon cannot be retrieved
	return icon
end

-- no weak table required, there are only very few entries
local iconcache = {}
local function getIconPath(icon)
	if not icon then
		return
	end

	local iconpath = iconcache[icon]
	if iconpath then
		return iconpath
	end

	iconpath = figureIconPath(icon)
	iconcache[icon] = iconpath
	return iconpath
end

local numberedConditions = {}
local timerCheck = {}

local function checkPrimaryCondition(condition, arg, check)
	if condition == true then
		return true
	elseif check and type(check) == 'function' then
		local good = check(condition, arg)
		return good
	else
		return condition == arg
	end
end

local function checkSecondaryCondition(name, value)
	return Parrot_TriggerConditions:DoesSecondaryTriggerConditionPass(name, value)
end

local function checkTriggerCooldown(t, value)
	if not cooldowns[t.name] then
		return true
	end
	local now = GetTime()
	return now - cooldowns[t.name] > value
end

local function performPeriodicCheck(name, param)
	local val = timerCheck[name]
	if not val then
		val = 0
	end
	if param == 0 then
		val = 0
	else
		val = (val + 0.1) % param
	end
	timerCheck[name] = val
	if val < 0.1 then
		return true
	else
		return false
	end
end

local function showTrigger(t)
	cooldowns[t.name] = GetTime()
	local r, g, b = hexColorToTuple(t.color or 'ffffff')
	local icon = getIconPath(t.icon)
	if t.useflash then
		local rf, gf, bf = hexColorToTuple(t.flashcolor or 'ffffff')
		Parrot_Display:Flash(rf,gf,bf)
	end

	Parrot_Display:ShowMessage(t.name, t.scrollArea or "Notification", t.sticky, r, g, b, t.font, t.fontSize, t.outline, icon)

	if t.sound then
		local sound = SharedMedia:Fetch('sound', t.sound)
		if sound then
			PlaySoundFile(sound)
		end
	end
end

function Parrot_Triggers:OnTriggerCondition(name, arg, uid, check)
	if UnitIsDeadOrGhost("player") then
		return
	end
	-- check all triggers in registry
	for _,t in ipairs(effectiveRegistry) do
		local conditions = t.conditions
		-- if trigger has primary conditions
		if conditions and conditions[name] then
			-- assume it does not fit (pessimistic)
			local good = false
			--this can be just a single value or a table of params
			local param = conditions[name]
			if type(param) == 'table' then
				for i, v in pairs(param) do
					-- if one condition matches, the trigger fires
					if checkPrimaryCondition(v, arg, check) then
						good = true
						break
					end
				end
			elseif name == "Check every XX seconds" then
				good = performPeriodicCheck(name, param)
			else
				good = checkPrimaryCondition(param, arg, check)
			end
			if good then
				-- check secondary conditions
				local secondaryConditions = t.secondaryConditions
				if secondaryConditions then
					-- check all conditions associated with the trigger
					currentTrigger = t.name
					for k, v in pairs(secondaryConditions) do
						if k == "Trigger cooldown" then
							good = checkTriggerCooldown(t, v) and good
						elseif type(v) == 'table' and #v > 0 then
						-- if the condition is not exclusive there may be multiple matchers
							for _,cond in pairs(v) do
								if not checkSecondaryCondition(k,cond) then
									good = false
									break
								end
							end
						else
							if not checkSecondaryCondition(k,v) then
								good = false
								break
							end
						end
					end
				end
				-- check a 0.1-seconds cooldown too
				if good and checkTriggerCooldown(t, 0.1) then
					showTrigger(t)
					if uid then
						Parrot_CombatEvents:CancelEventsWithUID(uid)
					end
				end
			end
		end -- if conditions then
	end -- for _,v in ipairs(effectiveRegistry) do
end

local function getSoundChoices()
	local t = newList()
	for _,v in ipairs(SharedMedia:List("sound")) do
		t[v] = v
	end
	return t
end

function Parrot_Triggers:OnOptionsCreate()

	local acetype = {
		['number'] = 'range',
		['string'] = 'input',
		['boolean'] = 'toggle',
	}

	local makeOption
	local remove
	local triggers_opt = {
		type = 'group',
		name = L["Triggers"],
		desc = L["Triggers"],
		disabled = function()
			return not self:IsEnabled()
		end,
		order = 3,
		args = {
			new = {
				type = 'execute',
--				buttonText = L["Create"],
				name = L["New trigger"],
				desc = L["Create a new trigger"],
				func = function()
					local t = {
						name = L["New trigger"],
						class = select(2, UnitClass("player")),
						conditions = {},
					}
					local registry = self.db1.profile.triggers2
					registry[#registry+1] = t
					makeOption(t)
					rebuildEffectiveRegistry()
				end,
				disabled = function()
					if not self.db1.profile.triggers2 then
						return true
					end
					for _,v in ipairs(self.db1.profile.triggers2) do
						if v.name == L["New trigger"] then
							return true
						end
					end
					return false
				end
			},
		}
	}
	Parrot:AddOption('triggers', triggers_opt)

	local function getFontFace(t)
		local font = t.arg.font
		if font == nil then
			return "1"
		else
			return font
		end
	end
	local function setFontFace(t, value)
		if value == "1" then
			value = nil
		end
		t.arg.font = value
	end
	local function getFontSize(t)
		return t.arg.fontSize
	end
	local function setFontSize(t, value)
		t.arg.fontSize = value
	end
	local function getFontSizeInherit(t)
		return t.arg.fontSize == nil
	end
	local function setFontSizeInherit(t, value)
		if value then
			t.arg.fontSize = nil
		else
			t.arg.fontSize = 18
		end
	end
	local function getFontOutline(t)
		local outline = t.arg.fontOutline
		if outline == nil then
			return L["Inherit"]
		else
			return outline
		end
	end
	local function setFontOutline(t, value)
		if value == L["Inherit"] then
			value = nil
		end
		t.arg.fontOutline = value
	end
	local fontOutlineChoices = {
		NONE = L["None"],
		OUTLINE = L["Thin"],
		THICKOUTLINE = L["Thick"],
		[L["Inherit"]] = L["Inherit"],
	}
	local function getEnabled(t)
		return not t.arg.disabled
	end
	local function setEnabled(t, value)
		t.arg.disabled = not value or nil
		rebuildEffectiveRegistry()
	end
	local function getScrollArea(t)
		return t.arg.scrollArea or "Notification"
	end
	local function setScrollArea(t, value)
		if value == "Notification" then
			value = nil
		end
		t.arg.scrollArea = value
	end
	-- not local, declared above
	function remove(t)
		triggers_opt.args[tostring(t.arg)] = nil
		for i,v in ipairs(self.db1.profile.triggers2) do
			if v == t.arg then
				table.remove(self.db1.profile.triggers2, i)
				break
			end
		end
		rebuildEffectiveRegistry()
	end
	local function getSticky(t)
		return t.arg.sticky
	end
	local function setSticky(t, value)
		t.arg.sticky = value
	end
	local function getName(t)
		return t.arg.name
	end
	local function setName(t, value)
		t.arg.name = value
		local opt = triggers_opt.args[tostring(t.arg)]
		opt.name = value
		opt.desc = value
		opt.order = value == L["New trigger"] and -110 or -100
	end

	local function getIcon(t)
		return tostring(t.arg.icon or "")
	end
	local function setIcon(t, value)
		if value == '' then
			value = nil
		end
		t.arg.icon = tonumber(value) or value
	end

	local function tupleToHexColor(r, g, b)
		return ("%02x%02x%02x"):format(r * 255, g * 255, b * 255)
	end

	local function getColor(t)
		return hexColorToTuple(t.arg.color or "ffffff")
	end
	local function setColor(t, r, g, b)
		local color = tupleToHexColor(r, g, b)
		if color == "ffffff" then
			color = nil
		end
		t.arg.color = color
	end

	local function getColor2(info)
		return info.arg.color
	end
	local function setColor2(info, value)
		info.arg.color = value
	end

	local function getFlashColor(t)
		return hexColorToTuple(t.arg.flashcolor or "ffffff")
	end
	local function setFlashColor(t, r, g, b)
		local color = tupleToHexColor(r, g, b)
		if color == "ffffff" then
			color = nil
		end
		t.arg.flashcolor = color
	end

	local function getUseFlash(info)
		return info.arg.useflash
	end
	local function setUseFlash(info, value)
		info.arg.useflash = value
	end
	

	local function getClass(t, class)
		local tmp = newSet((";"):split(t.arg.class))
		local value = tmp[class]
		tmp = del(tmp)
		return value
	end

	local function setClass(t, class, value)
		local tmp = newSet((";"):split(t.arg.class))
		tmp[class] = value or nil
		local tmp2 = newList()
		for k in pairs(tmp) do
			tmp2[#tmp2+1] = k
		end
		tmp = del(tmp)
		t.arg.class = table.concat(tmp2, ";")
		tmp2 = del(tmp2)
		if class == playerClass then
			rebuildEffectiveRegistry()
		end
	end

	local function getSound(t)
		return t.arg.sound or "None"
	end

	local function setSound(t, value)
		PlaySoundFile(SharedMedia:Fetch('sound', value))
		if value == "None" then
			value = nil
		end
		t.arg.sound = value
	end

	local function test(t)
		local t = t
		if t.arg then
			t = t.arg
		end
		local r, g, b = hexColorToTuple(t.color or 'ffffff')
		--TODO
		if t.useflash then
			local rf, gf, bf = hexColorToTuple(t.flashcolor or 'ffffff')
			Parrot_Display:Flash(rf,gf,bf)
		end
		Parrot_Display:ShowMessage(t.name, t.scrollArea or "Notification", t.sticky, r, g, b, t.font, t.fontSize, t.outline, figureIconPath(t.icon))
		if t.sound then
			local sound = SharedMedia:Fetch('sound', t.sound)
			if sound then
				PlaySoundFile(sound)
			end
		end
	end

	local classChoices = {
		DRUID = LC["DRUID"],
		ROGUE = LC["ROGUE"],
		SHAMAN = LC["SHAMAN"],
		PALADIN = LC["PALADIN"],
		MAGE = LC["MAGE"],
		WARLOCK = LC["WARLOCK"],
		PRIEST = LC["PRIEST"],
		WARRIOR = LC["WARRIOR"],
		HUNTER = LC["HUNTER"],
		DEATHKNIGHT = LC["DEATHKNIGHT"],
	}

	local function getConditionValue(info)
		local t, name, field, index, parse = info.arg.t, info.arg.name, info.arg.field,
				info.arg.index, info.arg.parse
		local result
		if not field then
			if index then
				result = t.conditions[name][index]
			else
				result = t.conditions[name]
			end
		else
			if index then
				result = t.conditions[name][index][field]
			else
				result = t.conditions[name][field]
			end
		end
		if parse then
			return parse(result)
		else
			return result
		end
	end
	local function setConditionValue(info, value)
		local t, name, field, index, save = info.arg.t, info.arg.name, info.arg.field,
				info.arg.index, info.arg.save
		if save then
			value = save(value)
		end
		if not field then
			if index then
				t.conditions[name][index] = value
			else
				t.conditions[name] = value
			end -- if index
		else
			if index then
				t.conditions[name][index][field] = value
			else
				t.conditions[name][field] = value
			end -- if index
		end -- if not field
	end -- setConditionValue()

	local function getSecondaryConditionValue(info)
		local t, name, field, index, parse = info.arg.t, info.arg.name, info.arg.field,
				info.arg.index, info.arg.parse
		local result
		if not field then
			if index then
				result = t.secondaryConditions[name][index]
			else
				result = t.secondaryConditions[name]
			end
		else
			if index then
				result = t.secondaryConditions[name][index][field]
			else
				result = t.secondaryConditions[name][field]
			end
		end
		if parse then
			return parse(result)
		else
			return result
		end
	end
	local function setSecondaryConditionValue(info, value)
		local t, name, field, index, save = info.arg.t, info.arg.name, info.arg.field,
				info.arg.index, info.arg.save
		if save then
			value = save(value)
		end
		if not field then
			if index then
				t.secondaryConditions[name][index] = value
			else
				t.secondaryConditions[name] = value
			end -- if index
		else
			if index then
				t.secondaryConditions[name][index][field] = value
			else
				t.secondaryConditions[name][field] = value
			end -- if index
		end -- if not field
	end -- setConditionValue()

	local function donothing()
	end

	local function removePrimaryCondition(info)
		local t, name, index = unpack(info.arg)
		local opt = triggers_opt.args[tostring(t)].args.primary
		if index then
			opt.args[name .. index] = del(opt.args[name .. index])
			t.conditions[name][index] = nil
		else
			opt.args[name] = del(opt.args[name])
		end
		-- delete the whole condition-table
		if not index or not next(t.conditions[name]) then
			t.conditions[name] = nil
		end
	end -- removeCondition()

	local function removeSecondaryCondition(info)
		local t, name, index = unpack(info.arg)
		local opt = triggers_opt.args[tostring(t)].args.secondary
		if index then
			opt.args[name .. index] = del(opt.args[name .. index])
			t.secondaryConditions[name][index] = nil
		else
			opt.args[name] = del(opt.args[name])
		end
		-- delete the whole condition-table
		if not index or not next(t.secondaryConditions[name]) then
			t.secondaryConditions[name] = nil
		end
	end -- removeCondition()

	local function addCondition(t, name, localName, index, primary)
		-- the only stuff that is different about adding primary and secondary conditions
		local opt, param, default
		local set, get, remove
		if primary then
			opt = triggers_opt.args[tostring(t)].args.primary
			param, default = Parrot_TriggerConditions:GetPrimaryConditionParamDetails(name)
			set, get = setConditionValue, getConditionValue
			remove = removePrimaryCondition
		else
			opt = triggers_opt.args[tostring(t)].args.secondary
			param, default = Parrot_TriggerConditions:GetSecondaryConditionParamDetails(name)
			set, get = setSecondaryConditionValue, getSecondaryConditionValue
			remove = removeSecondaryCondition
		end
		if not localName then
			if t.name then
				Parrot:Print("Trigger \"", t.name, "\" might be broken")
				Parrot:Print("The condition ", name, " was not found")
				Parrot:Print("Try to recreate the Trigger")
			end
			return
		end
		local tmp

		if param and param.type == 'group' then
			tmp = deepCopy(param)
			for k,v in pairs(tmp.args) do
				v.get = get
				v.set = set
				if acetype[v.type] then
					v.type = acetype[v.type]
				end
				v.arg = { t = t, name = name, field = k, index = index, parse = v.parse, save = v.save }
				v.save = nil
				v.parse = nil
			end
		else
			tmp = {
				type = 'group',
				args = {},
			}
			if not param then
				tmp.args.param = {
					type = 'execute',
					name = localName,
					desc = localName,
					func = donothing,
				}
			else
				local param_opt = deepCopy(param)
				tmp.args.param = param_opt
				param_opt.name = localName
				param_opt.desc = localName
				param_opt.get = get
				param_opt.set = set
				param_opt.arg = { t = t, name = name, index = index, parse = param_opt.parse, save = param_opt.save, }
				param_opt.save = nil
				param_opt.parse = nil
				if acetype[param_opt.type] then
					param_opt.type = acetype[param_opt.type]
				end
			end
		end

		tmp.name = localName
		tmp.desc = localName
		tmp.inline = true
		tmp.args.remove = {
			type = 'execute',
			name = L["Remove"],
			desc = L["Remove condition"],
			func = primary and removePrimaryCondition or removeSecondaryCondition,
			arg = {t, name, index,},
			order = -1,
		}
		opt.args[name .. (index or "")] = tmp
		if not param then
			return true
		end
		if default then
			if type(default) == 'table' then
				default = deepCopy(default)
			end
			return default
		end
		if type(param.min) == "number" and type(param.max) == "number" then
			return (param.max + param.min) / 2
		end
		if param.type == 'group' then
			return {}
		else
			return nil
		end
	end

	local function addPrimaryCondition(t, name, localName, index)
		return addCondition(t, name, localName, index, true)
	end
	local function newPrimaryCondition(info, name)
		local t = info.arg
		local opt = triggers_opt.args[tostring(t)].args.primary
		local localName = Parrot_TriggerConditions:GetPrimaryConditionChoices()[name]
		if Parrot_TriggerConditions:IsExclusive(name) then
			t.conditions[name] = addPrimaryCondition(t, name, localName)
			if name == "Check every XX seconds" then
				if not periodicCheckTimer then
					periodicCheckTimer = self:ScheduleRepeatingTimer(function()
							Parrot:FirePrimaryTriggerCondition("Check every XX seconds")
						end, 0.1)
				end
			end
		else
			local index
			if t.conditions[name] then
				index = #(t.conditions[name]) + 1
			else
				t.conditions[name] = {}
				index = 1
			end
			t.conditions[name][index] = addPrimaryCondition(t, name, localName, index)
		end
	end
	local function getAvailablePrimaryConditions(info)
		local t = info.arg
		if not t.conditions then
			return deepCopy(Parrot_TriggerConditions:GetPrimaryConditionChoices())
		end
		local tmp = newList()
		for k,v in pairs(Parrot_TriggerConditions:GetPrimaryConditionChoices()) do
			if not (t.conditions[k] and Parrot_TriggerConditions:IsExclusive(k)) then
				tmp[k] = v
			end
		end
		return tmp
	end

	local function addSecondaryCondition(...)
		return addCondition(...)
	end

	local function newSecondaryCondition(t, name)
		local t = t.arg
		local opt = triggers_opt.args[tostring(t)].args.secondary
		local localName = Parrot_TriggerConditions:GetSecondaryConditionChoices()[name]
		if not t.secondaryConditions then
			t.secondaryConditions = {}
		end
		if Parrot_TriggerConditions:SecondaryIsExclusive(name) then
			t.secondaryConditions[name] = addSecondaryCondition(t, name, localName)
		else
			local index
			if t.secondaryConditions[name] then
				index = #(t.secondaryConditions[name]) + 1
			else
				t.secondaryConditions[name] = {}
				index = 1
			end
			local tmp = addSecondaryCondition(t, name, localName, index)
			t.secondaryConditions[name][index] = tmp
		end
	end
	local function getAvailableSecondaryConditions(info)
		local t = info.arg
		if not t.secondaryConditions then
			return deepCopy(Parrot_TriggerConditions:GetSecondaryConditionChoices())
		end
		local tmp = newList()
		for k,v in pairs(Parrot_TriggerConditions:GetSecondaryConditionChoices()) do
		local kpos = k:gsub("^~", "")
			if Parrot_TriggerConditions:SecondaryIsExclusive(kpos) then
				if not t.secondaryConditions[k] and not t.secondaryConditions["~" .. k]
						and not t.secondaryConditions[kpos] then
					tmp[k] = v
				end
			else
				tmp[k] = v
			end
		end
		return tmp
	end

	function makeOption(t)
		local opt = {
			type = 'group',
			name = t.name,
			desc = t.name,
			order = t.name == L["New trigger"] and -110 or -100,
			args = {
				output = {
					type = 'input',
					name = L["Output"],
					desc = L["The text that is shown"],
					usage = L["<Text to show>"],
					get = getName,
					set = setName,
					arg = t,
					order = 1,
				},
				icon = {
					type = 'input',
					name = L["Icon"],
					desc = L["The icon that is shown"],--Note: Spells that are not in the Spellbook (i.e. some Talents) can only be identified by SpellId (retrievable at www.wowhead.com, looking at the URL)
					usage = L["<Spell name> or <Item name> or <Path> or <SpellId>"],
					get = getIcon,
					set = setIcon,
					arg = t,
					order = 2,
				},
				enabled = {
					type = 'toggle',
					name = L["Enabled"],
					desc = L["Whether the trigger is enabled or not."],
					get = getEnabled,
					set = setEnabled,
					arg = t,
					order = 3,
				},
				remove = {
					type = 'execute',
					-- buttonText = L["Remove"],
					name = L["Remove trigger"],
					desc = L["Remove this trigger completely."],
					func = remove,
					arg = t,
					-- TODO confirm
--					confirm = L["Are you sure?"],
					order = -2,
				},
				color = {
					name = L["Color"],
					desc = L["Color of the text for this trigger."],
					type = 'color',
					get = getColor,
					set = setColor,
					arg = t,
					order = 5,
				},
				color2 = {
					name = L["Color"],
					desc = L["Color of the text for this trigger."],
					type = 'input',
					get = getColor2,
					set = setColor2,
					arg = t,
					order = 6,
				},
				sticky = {
					type = 'toggle',
					name = L["Sticky"],
					desc = L["Whether to show this trigger as a sticky."],
					get = getSticky,
					set = setSticky,
					arg = t,
					order = 9,
				},
				classes = {
					type = 'multiselect',
					values = classChoices,
					name = L["Classes"],
					desc = L["Classes affected by this trigger."],
					get = getClass,
					set = setClass,
					arg = t,
					order = 7,
				},
				scrollArea = {
					type = 'select',
					values = Parrot_ScrollAreas:GetScrollAreasChoices(),
					name = L["Scroll area"],
					desc = L["Which scroll area to output to."],
					get = getScrollArea,
					set = setScrollArea,
					arg = t,
					order = 8,
				},
				sound = {
					type = 'select',
					control = "LSM30_Sound",
					values = getSoundChoices,
					name = L["Sound"],
					desc = L["What sound to play when the trigger is shown."],
					get = getSound,
					set = setSound,
					arg = t,
					order = 4,
				},
				useflash = {
					type = 'toggle',
					name = "Use flash",
					desc = L["Flash screen in specified color"],
					get = getUseFlash,
					set = setUseFlash,
					arg = t,
					order = 101,
				},
				flashcolor = {
					type = 'color',
					name = "Flash color",
					desc = L["Color in which to flash"],
					get = getFlashColor,
					set = setFlashColor,
					arg = t,
					order = 102,
				},
				test = {
					type = 'execute',
					-- buttonText = L["Test"],
					name = L["Test"],
					desc = L["Test how the trigger will look and act."],
					func = test,
					arg = t,
					order = -1,
				},
				font = {
					type = 'group',
					inline = true,
					name = L["Custom font"],
					desc = L["Custom font"],
					args = {
						fontface = {
							type = 'select',
							name = L["Font face"],
							desc = L["Font face"],
							values = Parrot.inheritFontChoices,
--							choiceFonts = SharedMedia:HashTable('font'),
							get = getFontFace,
							set = setFontFace,
							arg = t,
							order = 1,
						},
						fontSizeInherit = {
							type = 'toggle',
							name = L["Inherit font size"],
							desc = L["Inherit font size"],
							get = getFontSizeInherit,
							set = setFontSizeInherit,
							arg = t,
							order = 2,
						},
						fontSize = {
							type = 'range',
							name = L["Font size"],
							desc = L["Font size"],
							min = 12,
							max = 30,
							step = 1,
							get = getFontSize,
							set = setFontSize,
							disabled = getFontSizeInherit,
							arg = t,
							order = 3,
						},
						fontOutline = {
							type = 'select',
							name = L["Font outline"],
							desc = L["Font outline"],
							get = getFontOutline,
							set = setFontOutline,
							values = fontOutlineChoices,
							arg = t,
							order = 4,
						},
					},
				},
				primary = {
					type = 'group',
--					inline = true,
					name = L["Primary conditions"],
					desc = L["When any of these conditions apply, the secondary conditions are checked."],
					args = {
						new = {
							type = 'select',
							name = L["New condition"],
							desc = L["Add a new primary condition"],
							values = getAvailablePrimaryConditions,
							get = false,
							set = newPrimaryCondition,
							arg = t,
							order = 1,
						},
					}
				},
				secondary = {
					type = 'group',
--					inline = true,
					name = L["Secondary conditions"],
					desc = L["When all of these conditions apply, the trigger will be shown."],
					args = {
						new = {
							type = 'select',
							name = L["New condition"],
							desc = L["Add a new secondary condition"],
							values = getAvailableSecondaryConditions,
							get = false,
							set = newSecondaryCondition,
							arg = t,
							order = 1,
						},
					}
				},
			}
		}
		triggers_opt.args[tostring(t)] = opt
		for k,v in pairs(t.conditions) do
			if type(v) == 'table' then
				for i,cond in pairs(v) do
					local localName = Parrot_TriggerConditions:GetPrimaryConditionChoices()[k]
					addPrimaryCondition(t, k, localName, i)
				end
			else
				local localName = Parrot_TriggerConditions:GetPrimaryConditionChoices()[k]
				addPrimaryCondition(t, k, localName)
			end
		end
		if t.secondaryConditions then
			for k,v in pairs(t.secondaryConditions) do
				local localName = Parrot_TriggerConditions:GetSecondaryConditionChoices()[k]
				if type(v) == 'table' then
					for i in pairs(v) do
						addSecondaryCondition(t, k, localName, i)
					end
				else
					addSecondaryCondition(t, k, localName)
				end
			end
		end
	end

	for _,t in pairs(self.db1.profile.triggers2) do
		makeOption(t)
	end
end
