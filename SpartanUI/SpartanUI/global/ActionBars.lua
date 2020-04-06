local addon = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local module = addon:NewModule("ActionBars");
----------------------------------------------------------------------------------------------------
local default, plate = {
	popup1 = {anim = 1, alpha = 1, enable = 1},
	popup2 = {anim = 1, alpha = 1, enable = 1},
	bar1 = {alpha = 1, enable = 1},
	bar2 = {alpha = 1, enable = 1},
	bar3 = {alpha = 1, enable = 1},
	bar4 = {alpha = 1, enable = 1},
	bar5 = {alpha = 1, enable = 1},
	bar6 = {alpha = 1, enable = 1},
};
local UpdateSettings = function()
	suiChar.ActionBars = suiChar.ActionBars or {};
	for key,val in pairs(default) do
		if (not suiChar.ActionBars[key]) then suiChar.ActionBars[key] = {}; end
		setmetatable(suiChar.ActionBars[key],{__index = default[key]});
	end
end;
local SetupProfile = function()
	UpdateSettings();
end;
local SetupBartender = function()
	if (not Bartender4) then return; end
	local standard = "SpartanUI Standard";
	local settings = { -- actual settings being inserted into our custom profile
			ActionBars = {
				actionbars = { -- following settings are bare minimum, so that anything not defined is retained between resets
					{enabled = true,	buttons = 12,	rows = 1,	padding = 3,	skin = {Zoom = true},	position = {point = "LEFT",		parent = "SUI_ActionBarPlate",	x=0,		y=36,	scale = 0.85,	growHorizontal="RIGHT"}}, -- 1
					{enabled = true,	buttons = 12,	rows = 1,	padding = 3,	skin = {Zoom = true},	position = {point = "LEFT",		parent = "SUI_ActionBarPlate",	x=0,		y=-4,	scale = 0.85,	growHorizontal="RIGHT"}}, -- 2
					{enabled = true,	buttons = 12,	rows = 1,	padding = 3,	skin = {Zoom = true},	position = {point = "RIGHT",	parent = "SUI_ActionBarPlate",	x=-402,	y=36,	scale = 0.85,	growHorizontal="RIGHT"}}, -- 3
					{enabled = true,	buttons = 12,	rows = 1,	padding = 3,	skin = {Zoom = true},	position = {point = "RIGHT",	parent = "SUI_ActionBarPlate",	x=-402,	y=-4,	scale = 0.85,	growHorizontal="RIGHT"}}, -- 4
					{enabled = true,	buttons = 12,	rows = 3,	padding = 4,	skin = {Zoom = true},	position = {point = "LEFT",		parent = "SUI_ActionBarPlate",	x=-135,	y=36,	scale = 0.80,	growHorizontal="RIGHT"}}, -- 5
					{enabled = true,	buttons = 12,	rows = 3,	padding = 4,	skin = {Zoom = true},	position = {point = "RIGHT",	parent = "SUI_ActionBarPlate",	x=3,		y=36,	scale = 0.80,	growHorizontal="RIGHT"}}, -- 6
					{enabled = false}, -- 8
					{enabled = false}, -- 9
					{enabled = false} -- 10
				}
			},
			BagBar = {			enabled = true, padding = 0, 		position = {point = "TOPRIGHT",		parent = "SUI_ActionBarPlate",	x=-6,		y=-2,	scale = 0.70,	growHorizontal="LEFT"},	rows = 1, keyring = true},
			MicroMenu = {	enabled = true,	padding = -3,	position = {point = "TOPLEFT",		parent = "SUI_ActionBarPlate",	x=603,	y=0,	scale = 0.80,	growHorizontal="RIGHT"}},
			PetBar = {			enabled = true, padding = 1, 		position = {point = "TOPLEFT",		parent = "SUI_ActionBarPlate",	x=5,		y=-6,	scale = 0.7,	growHorizontal="RIGHT"},	rows = 1, skin = {Zoom = true}},
			StanceBar = {		enabled = true,	padding = 1, 	position = {point = "TOPRIGHT",		parent = "SUI_ActionBarPlate",	x=-605,	y=-2,	scale = 0.85,	growHorizontal="LEFT"},	rows = 1},
			MultiCast = {		enabled = true,								position = {point = "TOPRIGHT",		parent = "SUI_ActionBarPlate",	x=-777,	y=-4,	scale = 0.75}},
			Vehicle = {			enabled = false},
		};
	
	local lib = LibStub("LibWindow-1.1",true);
	if not lib then return; end
	function lib.RegisterConfig(frame, storage, names)
		if not lib.windowData[frame] then
			lib.windowData[frame] = {}
		end
		lib.windowData[frame].names = names
		lib.windowData[frame].storage = storage
		local parent = frame:GetParent();
		if (storage.parent) then
			frame:SetParent(storage.parent);
			if storage.parent == "SUI_ActionBarPlate" then
				frame:SetFrameStrata("LOW");
			end
		elseif (parent and parent:GetName() == "SUI_ActionBarPlate") then
			frame:SetParent(UIParent);
		end
	end
	SetupProfile = function() -- apply default settings into a custom BT4 profile
		UpdateSettings();
		if suiChar.ActionBars.Bartender4 then return; end
		Bartender4.db:SetProfile(standard);
		for k,v in LibStub("AceAddon-3.0"):IterateModulesOfAddon(Bartender4) do -- for each module (BagBar, ActionBars, etc..)
			if settings[k] and v.db.profile then
				v.db.profile = module:MergeData(v.db.profile,settings[k])
			end
		end
		Bartender4:UpdateModuleConfigs(); -- run ApplyConfig for all modules, so that the new settings are applied
		suiChar.ActionBars.Bartender4 = true;
	end
	plate:HookScript("OnUpdate",function()
		if (InCombatLockdown()) then return; end
		if (Bartender4.db:GetCurrentProfile() == standard) then
			if Bartender4.Locked then return; end
			addon:Print("The ability to unlock your bars is disabled when using the SpartanUI Default profile in Bartender4. Please change profiles to enable this functionality.");
			Bartender4:Lock();
		end
	end);	
end;

function module:MergeData(target,source)
	if type(target) ~= "table" then target = {} end
	for k,v in pairs(source) do
		if type(v) == "table" then
			target[k] = self:MergeData(target[k], v);
		else
			target[k] = v;
		end
	end
	return target;
end
function module:OnInitialize()
	do -- create bar plate and masks
		plate = CreateFrame("Frame","SUI_ActionBarPlate",SpartanUI,"SUI_ActionBarsTemplate");
		plate:SetFrameStrata("BACKGROUND"); plate:SetFrameLevel(1);
		plate:SetPoint("BOTTOM");
	
		plate.mask1 = CreateFrame("Frame","SUI_Popup1Mask",SpartanUI,"SUI_Popup1MaskTemplate");
		plate.mask1:SetFrameStrata("MEDIUM"); plate.mask1:SetFrameLevel(0);
		plate.mask1:SetPoint("BOTTOM",SUI_Popup1,"BOTTOM");
	
		plate.mask2 = CreateFrame("Frame","SUI_Popup2Mask",SpartanUI,"SUI_Popup2MaskTemplate");
		plate.mask2:SetFrameStrata("MEDIUM"); plate.mask2:SetFrameLevel(0);
		plate.mask2:SetPoint("BOTTOM",SUI_Popup2,"BOTTOM");
	end
	addon.options.args["backdrop"] = {
		name = "ActionBar Backdrops",
		desc = "configure actionbar backdrops",
		type = "group", args = {
			bar1 = {name = "toggle or set the alpha for bar1", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.bar1; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.bar1.enable == 1) or (val == "off") then
						suiChar.ActionBars.bar1.enable = 0;
						addon:Print("Backdrop1 Disabled");
					elseif (val == "" and suiChar.ActionBars.bar1.enable == 0) or (val == "on") then
						suiChar.ActionBars.bar1.enable = 1;
						addon:Print("Backdrop1 Enabled");
					else
						val = tonumber(val);
						if (type(val) == "number") then
							suiChar.ActionBars.bar1.alpha = val;
							addon:Print("Backdrop1 Alpha set to "..val);
						end
					end
				end
			},
			bar2 = {name = "toggle or set the alpha for bar2", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.bar2; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.bar2.enable == 1) or (val == "off") then
						suiChar.ActionBars.bar2.enable = 0;
						addon:Print("Backdrop2 Disabled");
					elseif (val == "" and suiChar.ActionBars.bar2.enable == 0) or (val == "on") then
						suiChar.ActionBars.bar2.enable = 1;
						addon:Print("Backdrop2 Enabled");
					else
						val = tonumber(val);
						if (type(val) == "number") then
							suiChar.ActionBars.bar2.alpha = val;
							addon:Print("Backdrop2 Alpha set to "..val);
						end
					end
				end
			},
			bar3 = {name = "toggle or set the alpha for bar3", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.bar3; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.bar3.enable == 0) or (val == "off") then
						suiChar.ActionBars.bar3.enable = 1;
						addon:Print("Backdrop3 Disabled");
					elseif (val == "" and suiChar.ActionBars.bar3.enable == 1) or (val == "on") then
						suiChar.ActionBars.bar3.enable = 0;
						addon:Print("Backdrop3 Enabled");
					else
						val = tonumber(val);
						if (type(val) == "number") then
							suiChar.ActionBars.bar3.alpha = val;
							addon:Print("Backdrop3 Alpha set to "..val);
						end
					end
				end
			},
			bar4 = {name = "toggle or set the alpha for bar4", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.bar4; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.bar4.enable == 1) or (val == "off") then
						suiChar.ActionBars.bar4.enable = 0;
						addon:Print("Backdrop4 Disabled");
					elseif (val == "" and suiChar.ActionBars.bar4.enable == 0) or (val == "on") then
						suiChar.ActionBars.bar4.enable = 1;
						addon:Print("Backdrop4 Enabled");
					else
						val = tonumber(val);
						if (type(val) == "number") then
							suiChar.ActionBars.bar4.alpha = val;
							addon:Print("Backdrop4 Alpha set to "..val);
						end
					end
				end
			},
			bar5 = {name = "toggle or set the alpha for bar5", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.bar5; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.bar5.enable == 1) or (val == "off") then
						suiChar.ActionBars.bar5.enable = 0;
						addon:Print("Backdrop5 Disabled");
					elseif (val == "" and suiChar.ActionBars.bar5.enable == 0) or (val == "on") then
						suiChar.ActionBars.bar5.enable = 1;
						addon:Print("Backdrop5 Enabled");
					else
						val = tonumber(val);
						if (type(val) == "number") then
							suiChar.ActionBars.bar5.alpha = val;
							addon:Print("Backdrop5 Alpha set to "..val);
						end
					end
				end
			},
			bar6 = {name = "toggle or set the alpha for bar6", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.bar6; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.bar6.enable == 1) or (val == "off") then
						suiChar.ActionBars.bar6.enable = 0;
						addon:Print("Backdrop6 Disabled");
					elseif (val == "" and suiChar.ActionBars.bar6.enable == 0) or (val == "on") then
						suiChar.ActionBars.bar6.enable = 1;
						addon:Print("Backdrop6 Enabled");
					else
						val = tonumber(val);
						if (type(val) == "number") then
							suiChar.ActionBars.bar6.alpha = val;
							addon:Print("Backdrop6 Alpha set to "..val);
						end
					end
				end
			},
			popup1 = {name = "toggle or set the alpha for popup1", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.popup1; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.popup1.enable == 1) or (val == "off") then
						suiChar.ActionBars.popup1.enable = 0;
						addon:Print("Popup1 Backdrop Disabled");
					elseif (val == "" and suiChar.ActionBars.popup1.enable == 0) or (val == "on") then
						suiChar.ActionBars.popup1.enable = 1;
						addon:Print("Popup1 Backdrop Enabled");
					else
						val = tonumber(val);
						if (type(val) == "number") then
							suiChar.ActionBars.popup1.alpha = val;
							addon:Print("Popup1 Alpha set to "..val);
						end
					end
				end
			},
			popup2 = {name = "toggle or set the alpha for popup2", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.popup2; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.popup2.enable == 1) or (val == "off") then
						suiChar.ActionBars.popup2.enable = 0;
						addon:Print("Popup2 Backdrop Disabled");
					elseif (val == "" and suiChar.ActionBars.popup2.enable == 0) or (val == "on") then
						suiChar.ActionBars.popup2.enable = 1;
						addon:Print("Popup2 Backdrop Enabled");
					else
						val = tonumber(val);
						if (type(val) == "number") then
							suiChar.ActionBars.popup2.alpha = val;
							addon:Print("Popup2 Alpha set to "..val);
					end
				end
			end
		},
			bars = {name = "toggle or set the alpha for all bars", type="input",
				get = function(info) return suiChar and suiChar.ActionBars; end,
				set = function(info,val)
					if (val == "" or val == "on" or val == "off") then
						if (val == "off" or suiChar.ActionBars.bar1.enable == 1) then
							for i = 1,6 do suiChar.ActionBars["bar"..i].enable = 0; end
							addon:Print("Backdrops for All Bars Disabled");
						elseif (val == "on" or suiChar.ActionBars.bar1.enable == 0) then
							for i = 1,6 do suiChar.ActionBars["bar"..i].enable = 1; end
							addon:Print("Backdrops for All Bars Enabled");
						end		
					else
						val = tonumber(val);
						if (type(val) == "number") then
							for i = 1,6 do suiChar.ActionBars["bar"..i].alpha = val; end
							addon:Print("Alpha for All Bar Backdrops set to "..val);
						end
					end
				end
			},
			popups = {name = "toggle or set the alpha for all popups", type="input",
				get = function(info) return suiChar.ActionBars; end,
				set = function(info,val)
					if (val == "" or val == "on" or val == "off") then
						if (val == "off" or suiChar.ActionBars.popup1.enable == 1) then
							for i = 1,2 do suiChar.ActionBars["popup"..i].enable = 0; end
							addon:Print("Backdrops for All Popups Disabled");
						elseif (val == "on" or suiChar.ActionBars.popup1.enable == 0) then
							for i = 1,2 do suiChar.ActionBars["popup"..i].enable = 1; end
							addon:Print("Backdrops for All Popups Enabled");
						end		
					else
						val = tonumber(val);
						if (type(val) == "number") then
							for i = 1,2 do suiChar.ActionBars["popup"..i].alpha = val; end
							addon:Print("Alpha for All Popup Backdrops set to "..val);
						end
					end
				end
			},
			all = {name = "toggle or set the alpha for all backdrops", type="input",
				get = function(info) return suiChar.ActionBars; end,
				set = function(info,val)
					if (val == "" or val == "on" or val == "off") then
						if (val == "off" or suiChar.ActionBars.bar1.enable == 1) then
							for i = 1,6 do suiChar.ActionBars["bar"..i].enable = 0; end
							for i = 1,2 do suiChar.ActionBars["popup"..i].enable = 0; end
							addon:Print("All Backdrops Disabled");
						elseif (val == "on" or suiChar.ActionBars.bar1.enable == 0) then
							for i = 1,6 do suiChar.ActionBars["bar"..i].enable = 1; end
							for i = 1,2 do suiChar.ActionBars["popup"..i].enable = 1; end
							addon:Print("All Backdrops Enabled");
						end		
					else
						val = tonumber(val);
						if (type(val) == "number") then
							for i = 1,6 do suiChar.ActionBars["bar"..i].alpha = val; end
							for i = 1,2 do suiChar.ActionBars["popup"..i].alpha = val; end
							addon:Print("Alpha for All Backdrops set to "..val);
						end
					end
				end
			}
		}
	};
	addon.options.args["resetbars"] = {
		type = "execute",
		name = "Reset ActionBars",
		desc = "resets all ActionBar options to default",
		func = function()
			if (InCombatLockdown()) then 
				addon:Print(ERR_NOT_IN_COMBAT);
			else
				suiChar.ActionBars = {};
				SetupProfile();
				addon:Print("ActionBar Options Reset");
			end
		end
	};
	addon.options.args["popup"] = {
		name = "PopupBar Animations",
		desc = "toggle popup bar animations",
		type = "group", args = {
			["1"] = {name = "toggle animations for popup1", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.popup1 and suiChar.ActionBars.popup1.anim; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.popup1.anim == 1) or (val == "off") then
						suiChar.ActionBars.popup1.anim = 0;
						addon:Print("Animations for Popup Bar1 Disabled");
					elseif (val == "" and suiChar.ActionBars.popup1.anim == 0) or (val == "on") then
						suiChar.ActionBars.popup1.anim = 1;
						addon:Print("Animations for Popup Bar1 Enabled");
					end
				end
			},
			["2"] = {name = "toggle animations for popup2", type="input",
				get = function(info) return suiChar and suiChar.ActionBars and suiChar.ActionBars.popup2 and suiChar.ActionBars.popup2.anim; end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.popup2.anim == 1) or (val == "off") then
						suiChar.ActionBars.popup2.anim = 0;
						addon:Print("Animations for Popup Bar2 Disabled");
					elseif (val == "" and suiChar.ActionBars.popup2.anim == 0) or (val == "on") then
						suiChar.ActionBars.popup2.anim = 1;
						addon:Print("Animations for Popup Bar2 Enabled");
					end
				end
			},
			all = {name = "toggle all popup animations", type = "input", 
				get = function(info)
					return suiChar.ActionBars;
				end,
				set = function(info,val)
					if (val == "" and suiChar.ActionBars.popup1.anim == 1) or (val == "off") then
						suiChar.ActionBars.popup1.anim = 0;
						suiChar.ActionBars.popup2.anim = 0;
						addon:Print("Animations for All Popup Bars Disabled");
					elseif (val == "" and suiChar.ActionBars.popup1.anim == 0) or (val == "on") then
						suiChar.ActionBars.popup1.anim = 1;
						suiChar.ActionBars.popup2.anim = 1;
						addon:Print("Animations for All Popup Bars Enabled");
					end
				end
			},
		}
	};
	SetupBartender();	
end
function module:OnEnable()	
	do -- create base module frames
		plate:HookScript("OnUpdate",function() -- backdrop and popup visibility changes (alpha, animation, hide/show)
			if (suiChar.ActionBars) then
				for b = 1,6 do -- for each backdrop
					if suiChar.ActionBars["bar"..b].enable == 1 then -- backdrop enabled
						_G["SUI_Bar"..b]:SetAlpha(suiChar.ActionBars["bar"..b].alpha or 1); -- apply alpha
					else -- backdrop disabled
						_G["SUI_Bar"..b]:SetAlpha(0);
					end
				end
				for p = 1,2 do -- for each popup
					if suiChar.ActionBars["popup"..p].enable == 1 then -- popup enabled
						_G["SUI_Popup"..p]:SetAlpha(suiChar.ActionBars["popup"..p].alpha or 1); -- apply alpha
						if suiChar.ActionBars["popup"..p].anim == 1 then --- animation enabled
							_G["SUI_Popup"..p.."MaskBG"]:SetAlpha(1);
						else -- animation disabled
							_G["SUI_Popup"..p.."MaskBG"]:SetAlpha(0);
						end						
					else -- popup disabled
						_G["SUI_Popup"..p]:SetAlpha(0);
						_G["SUI_Popup"..p.."MaskBG"]:SetAlpha(0);
					end
				end
				if (MouseIsOver(SUI_Popup1Mask)) then -- popup1 animation
					SUI_Popup1MaskBG:Hide();
					SUI_Popup2MaskBG:Show();
				elseif (MouseIsOver(SUI_Popup2Mask)) then -- popup2 animation
					SUI_Popup2MaskBG:Hide();
					SUI_Popup1MaskBG:Show();
				else -- animation at rest
					SUI_Popup1MaskBG:Show();
					SUI_Popup2MaskBG:Show();
				end
			end
		end);
	end
	do -- modify strata / levels of backdrops
		for i = 1,6 do
			_G["SUI_Bar"..i]:SetFrameStrata("BACKGROUND");
			_G["SUI_Bar"..i]:SetFrameLevel(3);
		end
		for i = 1,2 do
			_G["SUI_Popup"..i]:SetFrameStrata("BACKGROUND");
			_G["SUI_Popup"..i]:SetFrameLevel(3);
		end
	end
	SetupProfile();
end
