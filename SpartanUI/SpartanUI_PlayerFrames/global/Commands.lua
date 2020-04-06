local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local addon = spartan:GetModule("PlayerFrames");
----------------------------------------------------------------------------------------------------
suiChar.PlayerFrames = suiChar.PlayerFrames or {};
local default = {player = 0,target = 1,targettarget = 0,pet = 1,focus = 1};
setmetatable(suiChar.PlayerFrames,{__index = default});

function addon:OnInitialize()
	spartan.options.args["auras"] = {
		name = "Unitframe Auras",
		desc = "unitframe aura settings",
		type = "group", args = {
			player = {name = "toggle player auras", type = "toggle", 
				get = function(info) return suiChar.PlayerFrames.player; end,
				set = function(info,val)
					if suiChar.PlayerFrames.player == 0 then
						suiChar.PlayerFrames.player = 1;
						spartan:Print("Player Auras Enabled. Default buffs are NOT disabled with this command. You will need a third-party addon such as HideBlizzard to hide them");						
					else
						suiChar.PlayerFrames.player = 0;
						spartan:Print("Player Auras Disabled");
					end
					addon.player:PostUpdateAura(nil,"player");
				end
			},
			target = {name = "toggle target auras", type = "toggle", 
				get = function(info) return suiChar.PlayerFrames.target; end,
				set = function(info,val)
					if suiChar.PlayerFrames.target == 0 then
						suiChar.PlayerFrames.target = 1;
						spartan:Print("Target Auras Enabled");					
					else
						suiChar.PlayerFrames.target = 0;
						spartan:Print("Target Auras Disabled");					
					end
					addon.target:PostUpdateAura(nil,"target");
				end
			},
			targettarget = {name = "toggle target of target auras", type = "toggle", 
				get = function(info) return suiChar.PlayerFrames.targettarget; end,
				set = function(info,val)
					if suiChar.PlayerFrames.targettarget == 0 then
						suiChar.PlayerFrames.targettarget = 1;
						spartan:Print("Target of Target Auras Enabled");					
					else
						suiChar.PlayerFrames.targettarget = 0;
						spartan:Print("Target of Target Auras Disabled");					
					end
					addon.targettarget:PostUpdateAura(nil,"targettarget");
				end
			},
			pet = {name = "toggle pet auras", type = "toggle", 
				get = function(info) return suiChar.PlayerFrames.pet; end,
				set = function(info,val)
					if suiChar.PlayerFrames.pet == 0 then
						suiChar.PlayerFrames.pet = 1;
						spartan:Print("Pet Auras Enabled");					
					else
						suiChar.PlayerFrames.pet = 0;
						spartan:Print("Pet Auras Disabled");					
					end
					addon.pet:PostUpdateAura(nil,"pet");
				end
			},
			focus = {name = "toggle focus auras", type = "toggle", 
				get = function(info) return suiChar.PlayerFrames.focus; end,
				set = function(info,val)
					if suiChar.PlayerFrames.focus == 0 then
						suiChar.PlayerFrames.focus = 1;
						spartan:Print("Focus Auras Enabled");					
					else
						suiChar.PlayerFrames.focus = 0;
						spartan:Print("Focus Auras Disabled");					
					end
					addon.focus:PostUpdateAura(nil,"focus");
				end
			}
		}
	};
end
function addon:OnEnable()
	for k,v in pairs(default) do addon[k]:PostUpdateAura(nil,k); end
end