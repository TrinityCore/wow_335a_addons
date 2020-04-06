local addon = LibStub("AceAddon-3.0"):NewAddon("SpartanUI","AceConsole-3.0");
----------------------------------------------------------------------------------------------------
suiChar = suiChar or {};
addon.options = {name = "SpartanUI", type = "group", args = {}};

function addon:OnInitialize()
	addon.options.args["reset"] = {
		type = "execute",
		name = "Reset Options",
		desc = "resets all options to default",
		func = function()
			if (InCombatLockdown()) then 
				addon:Print(ERR_NOT_IN_COMBAT);
			else
				suiChar = nil;
				ReloadUI();
			end
		end
	};
end
function addon:OnEnable()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("SpartanUI", addon.options, {"sui", "spartanui"});
end
