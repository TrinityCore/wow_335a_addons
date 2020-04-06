if not Skinner:isAddonEnabled("Factionizer") then return end

function Skinner:Factionizer()
	if not self.db.profile.CharacterFrames then return end

-->>--	Reputation Detail Frame
	self:skinScrollBar{obj=FIZ_UpdateListScrollFrame}
	self:addSkinFrame{obj=FIZ_ReputationDetailFrame, kfs=true, x1=5, y1=-6, x2=-6, y2=5}
-->>--	Options Frame
	self:moveObject{obj=FIZ_OptionsFrameTitle, y=-6}
	self:addSkinFrame{obj=FIZ_OptionsFrame, kfs=true, x1=4, y1=-4, x2=-4, y2=50}

end
