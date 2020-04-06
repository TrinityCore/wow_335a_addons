if not Skinner:isAddonEnabled("Capping") then return end

local hb, nrw

function Skinner:Capping()
	if not self.db.profile.BattlefieldMm then return end

--	self:Debug("Capping loaded")

	Capping.db.hidemapborder = true

	self:SecureHook(Capping, "ModMap", "Capping_ModMap")

	self:Capping_ModMap()

end

function Skinner:Capping_ModMap(...)

--	self:Debug("Capping_ModMap")

	if not BattlefieldMinimap then return end
	if not self.skinFrame[BattlefieldMinimap] then return end

	local skinFrame = self.skinFrame[BattlefieldMinimap]
	local bmmbw = floor(BattlefieldMinimapBackground:GetWidth())
--	self:Debug("Capping_ModMap#2: [%s, %s]", bmmw, bmmbw)

	if Capping.db.narrow then
--		self:Debug("C_MM_narrow")
		if bmmbw == 128 then
			skinFrame:SetWidth(122)
			if not nrw then
--				self:Debug("C_MM move right")
				self:moveObject(skinFrame, "+", 56, nil, nil)
				nrw = true
			end
		end
	elseif not Capping.db.narrow then
--		self:Debug("C_MM_normal")
		if bmmbw == 256 then
			skinFrame:SetWidth(229)
			if nrw then
--				self:Debug("C_MM move left")
				self:moveObject(skinFrame, "-", 56, nil, nil)
				nrw = false
			end
		end
	end
	if Capping.db.hidemapborder then
--		self:Debug("C_MM_hideborder: [%s, %s]", ftt, hb)
		if not hb then
--			self:Debug("C_MM move up and left")
			self:moveObject(skinFrame, "-", 5, "+", 5)
			hb = true
		end
	else
--		self:Debug("C_MM_showborder: [%s, %s]", ftt, hb)
		BattlefieldMinimapBackground:Hide()
		BattlefieldMinimapCorner:Hide()
	end

end
