local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local addon = spartan:GetModule("PartyFrames");
----------------------------------------------------------------------------------------------------
function addon:UpdateAuraVisibility()
	for i = 1,4 do
		local pet = _G["SUI_PartyFrameHeaderUnitButton"..i.."Pet"];
		local unit = _G["SUI_PartyFrameHeaderUnitButton"..i];
		if pet and pet.Auras then pet:PostUpdateAura(); end
		if unit and unit.Auras then unit:PostUpdateAura(); end
	end
end
function addon:OnInitialize()
	if not spartan.options.args.auras then
		spartan.options.args["auras"] = {
			name = "Unitframe Auras",
			desc = "unitframe aura settings",
			type = "group", args = {}
		};
	end
	spartan.options.args.auras.args.party = {
		name = "toggle party auras", type = "toggle", 
		get = function(info) return suiChar.PartyFrames.showAuras; end,
		set = function(info,val)
			if suiChar.PartyFrames.showAuras == 0 then
				suiChar.PartyFrames.showAuras = 1;
				spartan:Print("Party Auras Enabled");
			else
				suiChar.PartyFrames.showAuras = 0;
				spartan:Print("Party Auras Disabled");
			end
			addon:UpdateAuraVisibility();
		end
	};
	spartan.options.args["party"] = {
		type = "input",
		name = "lock, unlock or reset party frame positioning",
		set = function(info,val)
			if (InCombatLockdown()) then 
				spartan:Print(ERR_NOT_IN_COMBAT);
			else
				if (val == "" and addon.locked == 1) or (val == "unlock") then
					addon.locked = 0;
					SUI_PartyFrameHeader.mover:Show();
					spartan:Print("Party Position Unlocked");
				elseif (val == "" and addon.locked == 0) or (val == "lock") then
					addon.locked = 1;
					SUI_PartyFrameHeader.mover:Hide();
					spartan:Print("Party Position Locked");
				elseif val == "reset" then
					suiChar.PartyFrames.partyMoved = nil;
					addon.locked = 1;
					SUI_PartyFrameHeader.mover:Hide();
					addon:UpdatePartyPosition();
					spartan:Print("Party Position Reset");
				end
			end
		end,
		get = function(info) return suiChar and suiChar.PartyFrames and suiChar.PartyFrames.partyLock; end
	};
end
