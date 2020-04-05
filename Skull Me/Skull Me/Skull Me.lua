-- Create a AceAddon instance to reference
SkullMe = LibStub("AceAddon-3.0"):NewAddon("SkullMe", "AceConsole-3.0", "AceEvent-3.0")

local defaults = {
	char = {
		enabled = true,
		marking = 8,
		changetime = 5,
		slash1 = "sm",
		slash2 = "skullme",
		dbmbar=true,
		fps=0.25,
	}
}
		
function SkullMe:MarkingOrder(arg1)
	if arg1 == 8 then return 1
	elseif arg1 == 7 then return 2
	elseif arg1 == 2 then return 3
	elseif arg1 == 4 then return 4
	elseif arg1 == 1 then return 5
	elseif arg1 == 5 then return 6
	elseif arg1 == 6 then return 7
	elseif arg1 == 3 then return 8
	end
	return 8
end

function SkullMe:MarkingOrderReverse(arg1)
	if arg1 == 1 then return 8
	elseif arg1 == 2 then return 7
	elseif arg1 == 3 then return 2
	elseif arg1 == 4 then return 4
	elseif arg1 == 5 then return 1
	elseif arg1 == 6 then return 5
	elseif arg1 == 7 then return 6
	elseif arg1 == 8 then return 3
	end
	return 3
end

function SkullMe:NumberToText(arg1)
	if arg1 == 1 then return "Star"
	elseif arg1 == 2 then return "Circle"
	elseif arg1 == 3 then return "Diamond"
	elseif arg1 == 4 then return "Triangle"
	elseif arg1 == 5 then return "Moon"
	elseif arg1 == 6 then return "Square"
	elseif arg1 == 7 then return "Cross"
	elseif arg1 == 8 then return "Skull"
	end
	return "Unknown Mark"
end

function SkullMe:SetDefaults()
	self.db.char.enabled = true
	self.db.char.marking = 8
	self.db.char.changetime = 5
	self.db.char.slash1 = "sm"
	self.db.char.slash2 = "skullme"
	self.db.char.dbmbar = true
	self.db.char.fps = 0.25
end
	
function SkullMe:OnEnable()
    -- Called when the addon is enabled, There is no actual disable logic so using this as a delayed init
	-- as it should be called only once?
	-- Load Database
	self.db = LibStub("AceDB-3.0"):New("SkullMeDB", defaults)
	-- Register Events ZONE_CHANGED
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	-- Frame to we can set a OnUpdate
	local frame = CreateFrame("Frame", "SkullMeFrame")
	-- Set the OnUpdate 
	frame:SetScript("OnUpdate",self.OnUpdate)
	-- Set internal tables
	self.icons = {
		Skull = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8.blp",
		Cross = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7.blp",
		Square = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6.blp",
		Moon = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5.blp",
		Triangle = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4.blp",
		Diamond = "Interface\\TARGETINGFRAME\\UI-RAIDTARGETINGICON_3.BLP",
		Circle = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2.blp",
		Star = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1.blp"
		}
	-- Set internal values
	self.elasped = 0
	self.markingset = true
	self.marktimer = 0
	-- Init the DBM timer
	self:DBMTimerInit()
	-- Register Slash Handler
	SLASH_SKULLME1 = "/"..self.db.char.slash1
	SLASH_SKULLME2 = "/"..self.db.char.slash2
	SlashCmdList["SKULLME"] = function(msg)
		self:SlashHandle(msg) end
	-- Options GUI....This is long
	local options = {
    name = "Skull Me",
    type = "group",
    childGroups = "tab",
    args = {
		title = {
			order = 10,
			type = "description",
			name = "SkullMe was designed for tanks or dps to automaticly mark mobs",
			},
		titledesc = {
			order = 20,
			type = "description",
			name = "You can also option these options with /sm",
			},
		defaults = {
			order = 25,
			type = "execute",
			name = "Default Options",
			desc = "Sets all options to the defaults.",
			func = function()
					self:SetDefaults() end,
			},
		coretab = {
			order = 30,
			name = "Core",
			type = "group",
			args = {
				enable = {
					order = 10,
					name = "Enabled",
					type = "toggle",
					desc = "SkullMe is on when checked.",
					get = function()
							return self.db.char.enabled end,
					set = function(info, value)
							self.db.char.enabled = value end,
					},
				timevalue = {
					order = 30,
					name = "Sensitivity",
					type = "range",
					desc = "Time in seconds till the target becomes marked, after changing marks",
					min = 1,
					max = 20,
					step = 1,
					get = function()
						return self.db.char.changetime end,
					set = function(info, val)
						self.db.char.changetime = val end,
					},
				mark = {
					order = 40,
					name = "Mark",
					desc = "The mark to automaticly mark with",
					type =  "select",
					values = {
						[8] = "Skull",
						[7] = "Cross",
						[6] = "Square",
						[5] = "Moon",
						[4] = "Triangle",
						[3] = "Diamond",
						[2] = "Circle",
						[1] = "Star",
							},
					get = function()
							return self.db.char.marking end,
					set = function(info, value)
							self.db.char.marking = value end,
					},
				dbmtimer = {
					order = 50,
					name = "Deadly Boss Mods Timer",
					type = "toggle",
					desc = "Shows time till change in target.",
					get = function()
							return self.db.char.dbmbar end,
					set = function(info, value)
							self.db.char.dbmbar = value end,
					},
				},
			},
		advancedtab = {
			order = 50,
			name = "Advanced",
			type = "group",
			args = {
				disclaimer = {
					order = 10,
					name = "WARNING: This section is for beta or advanced functions. Wrong inputs may result in unexpected results.",
					type = "description",
					},
				cmdextra1 = {
					order = 20,
					name = "Extra Slash Handler",
					desc = "This will change your slash command handlers to the desired handle. Usefull if another addon interfers, or if SkullMe interfers with another. Requires a reload of UI to take effect.",
					type = "input",
					get = function()
						return self.db.char.slash1 end,
					set = function(info, value)
						self.db.char.slash1 = value end,
					},
				cmdextra2 = {
					order = 20,
					name = "Extra Slash Handler",
					desc = "This will change your slash command handlers to the desired handle. Usefull if another addon interfers, or if SkullMe interfers with another. Requires a reload of UI to take effect.",
					type = "input",
					get = function()
						return self.db.char.slash2 end,
					set = function(info, value)
						self.db.char.slash2 = value end,
					},
				fps = {
					order = 30,
					name = "FPS",
					desc = "The number of times SkullMe updates each second in a percent",
					type = "range",
					min = 0.05,
					max = 1,
					step = 0.05,
					get = function()
						return self.db.char.fps end,
					set = function(info, val)
						self.db.char.fps = val end,
					},
				},
			},
		},
	}
	
	local config = LibStub("AceConfig-3.0")
	local dialog = LibStub("AceConfigDialog-3.0")

	config:RegisterOptionsTable("SkullMe-Bliz", options)
	dialog:AddToBlizOptions("SkullMe-Bliz", "SkullMe")
end

function SkullMe:OnUpdate(elap)
	SkullMe:onupdate(elap)
end

function SkullMe:onupdate(elap)
	-- OnUpdate is called every frame, but not all of it is executed every frame.
	-- No need to call if not enabled and we arnt in a instance
	if (self.db.char.enabled == false or self.noinstance) then return end
	
	if (self.markingset == false) then self.marktimer = self.marktimer - elap end
	
	-- Throttle the OnUpdate checks, Place any code that needs to fire every frame BEFORE this
	self.elasped = self.elasped + elap
	if (self.elasped < self.db.char.fps) then return end
	self.elasped = 0
	
	-- Start the logical checks for a pending mark.
	-- markingset may be misleading. If false we have a pending mark and need to mark.  
	-- Also checks if the player is still targetting a unit.
	if ((self.markingset == false) and (UnitExists("target"))) then
		if (not(UnitIsFriend("target", "player")) and not(UnitInParty("target"))) then
		-- Check if we have completed the required timer.
			if (self.marktimer <= 0) then
		-- This returns nil if there is no target, throwing the else, or a value that will complete the If statement otherwise.
		-- If its not nil we need to check the marking order.		
				if GetRaidTargetIndex("target") then
		-- Marking Order Logic
					if (self:MarkingOrder(GetRaidTargetIndex("target"))>self:MarkingOrder(self.db.char.marking)) then
		-- Actually marking and clearing the pending mark
						self.markingset = true
						SetRaidTarget("target", self.db.char.marking)
					end
				else
		-- Actually marking and clearing the pending mark
					self.markingset = true
					SetRaidTarget("target", self.db.char.marking)
				end
			end
		end
	end
end
			
function SkullMe:PLAYER_TARGET_CHANGED()
	-- This is called when the player changes targets, and we need to set a pending mark if enabled and
	-- we also have target.  This is called when targets are cleared too, so we can remove pending marks.
	local _,_Instance = IsInInstance()
	if (_Instance == "party" or _Instance == "raid") then
		self.noinstance = false
	else
		self.noinstance = true
	end
	-- No need to call if not enabled and we arnt in a instance
	if (self.db.char.enabled == false or self.noinstance) then return end
	-- No target, No Call
	if not UnitExists("target") then return end
	if UnitInParty("target") then return end
	-- Check if we aquired a target, and its not friendly to us thus useless to mark
	if not(UnitIsFriend("target", "player")) then
	-- Changing MarkingSet to false means there is a pending mark.  marktimer is used to check if we have waited long enough
	-- before we automaticly mark the target.  We also create a DBM timer, the option to make them is checked in the function.
		self.markingset = false
		self.marktimer = self.db.char.changetime
		self:DBMCreateTimer(self.db.char.changetime, "AutoMark", self.icons[self:NumberToText(self.db.char.marking)], true)
	end
end


function SkullMe:DBMTimerInit()
	if DBT then
	self.DBT = DBT:New()
	end
end

function SkullMe:DBMCreateTimer(timer, id, icon, huge)
	if (self.db.char.dbmbar == true and self.DBT) then
	return self.DBT:CreateBar(timer, id, icon, huge)
	end
end

function SkullMe:SlashHandle(msg)
	if (msg == "enable") then self.db.char.enabled = true return end
	if (msg == "disable") then self.db.char.enabled = false return end
	local _identifier, _arg1, _arg2 = strsplit(" ",msg)
	if (_identifier == "time") then self.db.char.changetime = _arg1 or self.db.char.changetime return end
	if (_identifier == "mark") then self.db.char.mark = _arg1 or self.db.char.mark return end
	-- All else fails bring up options menu
	InterfaceOptionsFrame_OpenToCategory("SkullMe")
end