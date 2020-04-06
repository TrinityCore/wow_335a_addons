
function Skinner:TinyTip()

	if IsAddOnLoaded("TinyTipExtras") and ((TinyTipDB and TinyTipDB["ManaBar"]) or (TinyTipCharDB and TinyTipCharDB["ManaBar"])) then
		self:RawHookScript(TinyTipExtras_ManaBar, "OnShow", function()
	--		self:Debug("TinyTipExtras_ManaBar_OnShow")
			self.hooks[TinyTipExtras_ManaBar].OnShow()
			if not TinyTipExtras_ManaBar.skinned then
	    		self:glazeStatusBar(TinyTipExtras_ManaBar)
				TinyTipExtras_ManaBar.skinned = true
			end
		end)
	end

end
