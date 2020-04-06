if not Skinner:isAddonEnabled("FramesResized_TalentUI") then return end

function Skinner:FramesResized_TalentUI()

	self:removeRegions(TalentFrame_MidTextures)
	self:removeRegions(PlayerTalentFrameScrollFrame_MidTextures)

end
