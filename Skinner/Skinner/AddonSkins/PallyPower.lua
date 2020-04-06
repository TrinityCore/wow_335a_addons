if not Skinner:isAddonEnabled("PallyPower") then return end

function Skinner:PallyPower()

	-- Hook this as the config frame changes height
	self:SecureHookScript(PallyPowerConfigFrame, "OnShow", function(this)
--		self:Debug("PPCF_OnShow: [%s]", #AllPallys)
		local fh = 14 + 24 + 56 + (#AllPallys * 56) + 22
		self:applySkin(PallyPowerConfigFrame, nil, nil, nil, fh)
	end)

-->>-- Skin buttons
	for i = 1, PALLYPOWER_MAXCLASSES do
		local cBtn = PallyPower.classButtons[i]
		self:applySkin(cBtn)
		for j = 1, PALLYPOWER_MAXPERCLASS do
			local pBtn = PallyPower.playerButtons[i][j]
			self:applySkin(pBtn)
		end
	end

-->-- Other buttons
	self:applySkin(PallyPowerAura)
	self:applySkin(PallyPowerAuto)
	self:applySkin(PallyPowerRF)
	
end
