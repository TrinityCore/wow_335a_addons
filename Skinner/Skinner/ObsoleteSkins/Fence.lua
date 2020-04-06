
function Skinner:Fence()
	if not self.db.profile.AuctionUI then return end

	if Fence:HasModule('Sort') then
		self:keepRegions(BrowseNameSort, {4, 5, 6}) -- N.B. region 4 is text, 5 is the arrow, 6 is the highlight
		self:applySkin(BrowseNameSort)
	end

	if Fence:HasModule('Wipe') then
		self:moveObject(FWButton, "-", 5, "+", 8)
	end

end
