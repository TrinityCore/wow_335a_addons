local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local addon = spartan:GetModule("PlayerFrames");
----------------------------------------------------------------------------------------------------
oUF:SetActiveStyle("Spartan_PlayerFrames");

addon.player = oUF:Spawn("player","SUI_PlayerFrame");
addon.player:SetPoint("BOTTOMRIGHT",SpartanUI,"TOP",-72,-3);

do -- relocate the death knight rune frame
	hooksecurefunc(RuneFrame,"SetPoint",function(_,_,parent)
		if (parent ~= addon.player) then
			RuneFrame:ClearAllPoints();
			RuneFrame:SetPoint("TOPLEFT",addon.player,"BOTTOMLEFT",40,10);
		end
	end);
	RuneFrame:SetParent(SpartanUI); RuneFrame:SetFrameStrata("BACKGROUND");
	RuneFrame:SetFrameLevel(4); RuneFrame:SetScale(0.8); RuneFrame:ClearAllPoints();
	RuneFrame:SetPoint("TOPLEFT",addon.player,"BOTTOMLEFT",40,10);
end
do -- relocate the shaman totem frame
	for i = 1,4 do
		local timer = _G["TotemFrameTotem"..i.."Duration"];
		timer.Show = function() return; end
		timer:Hide();
	end	
	hooksecurefunc(TotemFrame,"SetPoint",function(_,_,parent)
		if (parent ~= addon.player) then
			TotemFrame:ClearAllPoints();
			TotemFrame:SetPoint("TOPLEFT",addon.player,"BOTTOMLEFT",60,18);
		end
	end);
	TotemFrame:SetParent(SpartanUI); TotemFrame:SetFrameStrata("BACKGROUND");
	TotemFrame:SetFrameLevel(4); TotemFrame:SetScale(0.59); TotemFrame:ClearAllPoints();
	TotemFrame:SetPoint("TOPLEFT",addon.player,"BOTTOMLEFT",60,18);
end
