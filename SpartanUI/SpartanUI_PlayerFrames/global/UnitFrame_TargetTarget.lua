local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local addon = spartan:GetModule("PlayerFrames");
----------------------------------------------------------------------------------------------------
oUF:SetActiveStyle("Spartan_PlayerFrames");

addon.targettarget = oUF:Spawn("targettarget","SUI_TOTFrame");
addon.targettarget:SetPoint("BOTTOMLEFT",SpartanUI,"TOP",370,12);
