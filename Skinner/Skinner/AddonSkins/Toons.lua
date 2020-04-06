if not Skinner:isAddonEnabled("Toons") then return end

function Skinner:Toons()

	-- remove duplicate entry if present
	if FRIENDSFRAME_SUBFRAMES[8] == "ToonsFrame"
	and FRIENDSFRAME_SUBFRAMES[9] == "ToonsFrame"
	then
		FRIENDSFRAME_SUBFRAMES[9] = nil
	end

	self:skinDropDown{obj=ToonsFrameServerDropDown}
	self:skinDropDown{obj=ToonsFramePageDropDown}
	self:keepFontStrings(ToonsFrame)

	-- Stats panel
	self:skinFFColHeads("ToonsFrameStatsColumnHeader", 5)
	-- Played panel
	self:skinFFColHeads("ToonsFramePlayedColumnHeader", 3)
	-- Guild panel
	self:skinFFColHeads("ToonsFrameGuildColumnHeader")
	-- Assets panel
	self:skinFFColHeads("ToonsFrameAssetsColumnHeader")
	-- Tradeskill panel
	self:skinFFColHeads("ToonsFrameTradeskillColumnHeader", 5)
	-- Marks panel
	self:skinFFColHeads("ToonsFrameMarksColumnHeader", 7)
	-- XP panel
	self:skinFFColHeads("ToonsFrameXPColumnHeader", 6)
	-- Honor panel
	self:skinFFColHeads("ToonsFrameHonorColumnHeader")
	-- Daily panel
	self:skinFFColHeads("ToonsFrameDailyColumnHeader", 3)
	-- Secondary panel
	self:skinFFColHeads("ToonsFrameSecondaryColumnHeader")
	-- Achieve panel
	self:skinFFColHeads("ToonsFrameAchieveColumnHeader")

end
