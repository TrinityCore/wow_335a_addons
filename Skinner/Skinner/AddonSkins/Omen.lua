if not Skinner:isAddonEnabled("Omen") then return end

function Skinner:Omen()

	local function skinOmen()
	
		OmenTitle:SetHeight(20)
		self:applySkin(OmenTitle)
		self:applySkin(OmenBarList)
		
	end
	
	skinOmen()
	self:SecureHook(Omen, "UpdateBackdrop", function() skinOmen() end)

end
