if not Skinner:isAddonEnabled("Vendorizer") then return end

function Skinner:Vendorizer()

	local c = self.db.profile.BackdropBorder
	-- hook this to manage skin alpha changes
	self:RawHook(VendorizerFrame, "SetBackdropBorderColor", function(this, r, g, b, a)
		Skinner.skinFrame[this]:SetBackdropBorderColor(c.r, c.g, c.b, a == 0 and a or c.a)
	end, true)
	
	VendorizerFrameBuyTab:DisableDrawLayer("BACKGROUND")
	VendorizerFrameSellTab:DisableDrawLayer("BACKGROUND")
	VendorizerFrameSaveTab:DisableDrawLayer("BACKGROUND")
	self:skinScrollBar{obj=VendorizerFrameContainerScrollFrame}
	self:skinEditBox{obj=VendorizerFrameContainerAdjQtyInputBox, regs={9}, noHeight=true, x=-5}
	VendorizerFrameProfit:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=VendorizerFrame, aso={bba=0}} -- turn off border alpha

end
