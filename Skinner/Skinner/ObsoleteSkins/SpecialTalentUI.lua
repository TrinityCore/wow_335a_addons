
function Skinner:SpecialTalentUI()

	local function setMin()

		SpecialTalentFrame:SetWidth(SpecialTalentFrame:GetWidth() - 15)
		SpecialTalentFrame:SetHeight(SpecialTalentFrame:GetHeight() + 60)
		if not SpecialTalentFrameTab1.skinned then
			for i = 1, MAX_TALENT_TABS do
				Skinner:removeRegions(_G["SpecialTalentFrameTab"..i], {1})
				if i == 1 then
					Skinner:moveObject(_G["SpecialTalentFrameTab"..i], "+", 30, nil, nil)
				end
			end
			SpecialTalentFrameTab1.skinned = true
		end

	end

	local function setMax()

		SpecialTalentFrame:SetWidth(SpecialTalentFrame:GetWidth() - 15)
		SpecialTalentFrame:SetHeight(SpecialTalentFrame:GetHeight() + 60)

	end

	self:SecureHook("SpecialTalentFrame_Maximize", function() setMax() end)
	self:SecureHook("SpecialTalentFrame_Minimize", function() setMin() end)

	self:keepFontStrings(SpecialTalentFrame)
	self:moveObject(SpecialTalentFrameCloseButton, "+", 28, "+", 8)
	self:applySkin(SpecialTalentFrame)

	if SpecialTalentFrameSaved.frameMinimized then
		setMin()
	else
		setMax()
	end

end
