local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local addon = spartan:GetModule("PlayerFrames");
----------------------------------------------------------------------------------------------------
oUF:SetActiveStyle("Spartan_PlayerFrames");

addon.target = oUF:Spawn("target","SUI_TargetFrame");
addon.target:SetPoint("BOTTOMLEFT",SpartanUI,"TOP",72,-3);
