if not Skinner:isAddonEnabled("NeonChat") then return end

function Skinner:NeonChat()
	if not self.db.profile.ChatEditBox.skin then return end

	for i = 1, NUM_CHAT_WINDOWS do
		local cfeb = _G["ChatFrame"..i.."EditBox"]
		self:removeRegions(cfeb, {6, 7, 8})
		self:addSkinFrame{obj=cfeb, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
	end

end
