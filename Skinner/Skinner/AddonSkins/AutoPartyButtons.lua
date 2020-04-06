if not Skinner:isAddonEnabled("AutoPartyButtons") then return end

function Skinner:AutoPartyButtons()

	self:addSkinFrame{obj=AutoPartyButtonsMainFrame}

	self:RawHook(AutoPartyButtons, "MakeButton", function(this, ...)
		local btn = self.hooks[AutoPartyButtons].MakeButton(this, ...)
		self:addSkinFrame{obj=btn, x1=4, y1=-4, x2=-4, y2=4}
		return btn
	end, true)
	-- skin existing buttons
	for k, btn in pairs(AutoPartyButtons.buttons) do
		self:addSkinFrame{obj=btn, x1=4, y1=-4, x2=-4, y2=4}
	end

end
