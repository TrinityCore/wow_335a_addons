if not Skinner:isAddonEnabled("GnomishAuctionShrinker") then return end

function Skinner:GnomishAuctionShrinker()

	-- skin new filters
	local cnt = AuctionFrameBrowse:GetNumChildren()
	for i = cnt, cnt - 3, -1 do -- last 4 children
		local filter = self:getChild(AuctionFrameBrowse, i)
		self:keepRegions(filter, {1, 5, 6}) -- N.B. region 1 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=filter}
	end

	self.GnomishAuctionShrinker = nil

end
