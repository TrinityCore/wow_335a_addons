if not Skinner:isAddonEnabled("TourGuide") then return end

function Skinner:TourGuide()

	-- hook this as buttons only created here
	self:SecureHook(TourGuide, "CreateObjectivePanel", function()
		self:skinSlider{obj=self:getChild(TourGuide.objectiveframe, 3), size=3}
		self:addSkinFrame{obj=TourGuide.objectiveframe}
		self:Unhook(TourGuide, "CreateObjectivePanel")
	end, true)

-->>-- Status Frame
	self:addSkinFrame{obj=TourGuide.statusframe}

-->>-- Item button
	self:addSkinButton{obj=TourGuideItemFrame, bg=true}

end
