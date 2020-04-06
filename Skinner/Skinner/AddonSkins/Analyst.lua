if not Skinner:isAddonEnabled("Analyst") then return end

function Skinner:Analyst()

	self:skinDropDown{obj=EconomyFramePeriodDropDown}
	self:addSkinFrame{obj=EconomyFrameTopStats}
	self:skinDropDown{obj=EconomyFrameLeftStatsReportDropDown}
	self:skinDropDown{obj=EconomyFrameRightStatsReportDropDown}
	self:addSkinFrame{obj=EconomyFrameLeftStats}
	self:addSkinFrame{obj=EconomyFrameRightStats}
	self:addSkinFrame{obj=EconomyFrame, kfs=true, x1=10, y1=-12, x2=-31, y2=71}

end
