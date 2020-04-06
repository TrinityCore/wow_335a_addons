
function Skinner:Bonuses()

	if self.db.profile.Tooltips.skin then
		for i = 1, 4 do
			local ttstt = _G["TooltipScan"..i]
			if self.db.profile.Tooltips.style == 3 then ttstt:SetBackdrop(self.backdrop) end
			self:skinTooltip(ttstt)
		end
	end

	self:SecureHook(TooltipScan, "CreateFrame", function()
		self:applySkin(BonusesOptionFrame)
		self:moveObject(BonusesOptionFrame.Title, nil, nil, "+", 6)
		self:moveObject(BonusesOptionFrame.Close, "-", 6, "+", 6)
	end)

end
