if not Skinner:isAddonEnabled("TargetAnnounce") then return end

function Skinner:TargetAnnounce()

	self:keepFontStrings(TargetAnnounce_Frame)
	self:applySkin(TargetAnnounce_Frame)
	self:skinEditBox(Profile_EditBox, {9})
	self:applySkin(Profile_Frame)
	self:applySkin(ShowButton_Frame)
	self:applySkin(Suggest_Frame)

	for i = 1, 8 do
		local eb = _G["EditBox"..i]
		self:skinEditBox(eb, {9})
	end

end
