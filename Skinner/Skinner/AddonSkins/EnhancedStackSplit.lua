if not Skinner:isAddonEnabled("EnhancedStackSplit") then return end

function Skinner:EnhancedStackSplit()
	if not self.db.profile.StackSplit then return end

	if not self.skinFrame[StackSplitFrame] then
		self:ScheduleTimer("EnhancedStackSplit", 0.2) -- wait for 2/10th second for frame to be skinned
		return
	end

	-- hook these to show/hide stack split value
	self:SecureHookScript(StackSplitOkayButton, "OnShow", function(this)
		StackSplitText:Show()
	end)
	self:SecureHookScript(StackSplitOkayButton, "OnHide", function(this)
		StackSplitText:Hide()
	end)
	-- hook this to handle XL mode
	self:SecureHookScript(EnhancedStackSplitXLModeButton, "OnClick", function(this)
		if floor(EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
			self.skinFrame[StackSplitFrame]:SetPoint("BOTTOMRIGHT", StackSplitFrame, "BOTTOMRIGHT", 0, -45)
		else
			self.skinFrame[StackSplitFrame]:SetPoint("BOTTOMRIGHT", StackSplitFrame, "BOTTOMRIGHT", 0, -24)
		end
	end)
	-- resize skin frame if in XL mode
	if floor(EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
		self.skinFrame[StackSplitFrame]:SetPoint("BOTTOMRIGHT", StackSplitFrame, "BOTTOMRIGHT", 0, -45)
	end

	self:keepFontStrings(EnhancedStackSplitTopTextureFrame)
	self:keepFontStrings(EnhancedStackSplitBottomTextureFrame)
	self:keepFontStrings(EnhancedStackSplitBottom2TextureFrame)
	self:keepFontStrings(EnhancedStackSplitAutoTextureFrame)

	-- skin buttons
	self:skinButton{obj=EnhancedStackSplitAuto1Button}
	for i = 1, 16 do
		self:skinButton{obj=_G["EnhancedStackSplitButton"..i]}
	end
	self:skinButton{obj=EnhancedStackSplitModeTXTButton}
	self:skinButton{obj=EnhancedStackSplitAutoSplitButton}

end
