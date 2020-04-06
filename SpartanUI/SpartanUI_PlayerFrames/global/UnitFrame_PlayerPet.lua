local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local addon = spartan:GetModule("PlayerFrames");
----------------------------------------------------------------------------------------------------
oUF:SetActiveStyle("Spartan_PlayerFrames");

addon.pet = oUF:Spawn("pet","SUI_PetFrame");
addon.pet:SetPoint("BOTTOMRIGHT",SpartanUI,"TOP",-370,12);

do -- fix for certain elements on the pet frame not updating properly
	local Update = function(self,event)
		if self.Name then self.Name:UpdateTag(self.unit); end
		if self.Level then self.Level:UpdateTag(self.unit); end
	end
	addon.pet:RegisterEvent("UNIT_PET",Update);
end
	
	
