if not Skinner:isAddonEnabled("Butsu") then return end

function Skinner:Butsu()
	if not self.db.profile.LootFrame then return end

	self:applySkin(Butsu)
	Butsu.SetBackdropBorderColor = function() end

end
