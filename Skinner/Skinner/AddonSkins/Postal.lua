if not Skinner:isAddonEnabled("Postal") then return end

function Skinner:Postal()

-->>-- Buttons
	if PostalOpenAllButton then self:skinButton{obj=PostalOpenAllButton} end
	if PostalSelectOpenButton then self:skinButton{obj=PostalSelectOpenButton} end
	if PostalSelectReturnButton then self:skinButton{obj=PostalSelectReturnButton} end

-->>-- About frame
	self:SecureHook(Postal, "CreateAboutFrame", function()
		if PostalAboutFrame then
			self:skinButton{obj=self:getChild(PostalAboutFrame, 2), cb=true}
			self:skinScrollBar{obj=PostalAboutScroll}
			self:applySkin{obj=PostalAboutFrame}
		end
		self:Unhook(Postal, "CreateAboutFrame")
	end)

end
