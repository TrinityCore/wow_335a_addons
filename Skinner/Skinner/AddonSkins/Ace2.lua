-- This is a Framework

function Skinner:Ace2()

	if LibStub("AceAddon-2.0").prototype.OpenDonationFrame then
		-- Skin the AceAddon Donation Frame
		self:SecureHook(LibStub("AceAddon-2.0").prototype, "OpenDonationFrame", function()
			self:skinScrollBar{obj=AceAddon20FrameScrollFrame}
			self:skinButton{obj=AceAddon20FrameButton}
			self:addSkinFrame{obj=AceAddon20Frame}
			self:Unhook(LibStub("AceAddon-2.0").prototype, "OpenDonationFrame")
		end)
	end
	
	-- Skin the AceAddon About Frame
	self:SecureHook(LibStub("AceAddon-2.0").prototype, "PrintAddonInfo", function()
		self:skinButton{obj=AceAddon20AboutFrameButton}
		self:addSkinFrame{obj=AceAddon20AboutFrame}
		self:skinButton{obj=AceAddon20AboutFrameDonateButton}
		self:Unhook(LibStub("AceAddon-2.0").prototype, "PrintAddonInfo")
	end)

end
