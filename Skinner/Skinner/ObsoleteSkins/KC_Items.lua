
function Skinner:KC_Items()

	-- Hook this to skin Fence
	self:SecureHook(AuctionSpy, "BuildSideBar", function()
		if BrowseNameSort then
			self:keepRegions(BrowseNameSort, {4, 5, 6}) -- N.B. region 4 is text, 5 is the arrow, 6 is the highlight
			self:applySkin(BrowseNameSort)
		end
	end)

	-- Hook this to skin the AuctionSpy Frame
	self:RawHook(AuctionSpy, "CreateHasteFrame", function(AS, ...)
		local frame = self.hooks[AuctionSpy].CreateHasteFrame(AS, ...)
		self:moveObject(frame, "-", 2, "-", 9)
		frame:SetHeight(frame:GetHeight() * self.FyMult)
		self:moveObject(frame.Title, "+", 45, "+", 9, frame)
		frame.Title:SetTextColor(self.HTr, self.HTg, self.HTb)
		self:applySkin(frame)
		return frame
	end)

-->>--	tooltips
	if self.db.profile.Tooltips.style == 3 then
		kcTooltip:SetBackdrop(self.backdrop)
		kcItemRef:SetBackdrop(self.backdrop)
	end
	self:RawHookScript(kcTooltip, "OnShow", function()
		self.hooks[kcTooltip].OnShow()
		self:skinTooltip(kcTooltip)
	end)
	self:RawHookScript(kcItemRef, "OnShow", function()
		self.hooks[kcItemRef].OnShow()
		self:skinTooltip(kcItemRef)
	end)

end
