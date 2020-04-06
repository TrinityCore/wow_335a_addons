if not Skinner:isAddonEnabled("Quartz") then return end

function Skinner:Quartz() -- Quartz3

	local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3", true)
	if not Quartz3 then return end

	local function skinSBs()

		for _, child in pairs{UIParent:GetChildren()} do
			-- if this is a Quartz Mirror/Buff Bar then skin it
			if child:IsObjectType('StatusBar')
			and child.timetext
			then
				if not Skinner.skinned[child] then
					child:SetBackdrop(nil)
					Skinner:glazeStatusBar(child, 0)
				end
			end
		end

	end

	-- set border colours
	local c = self.db.profile.Backdrop
	Quartz3.db.profile.backgroundcolor = {c.r, c.g, c.b}
	Quartz3.db.profile.backgroundalpha = c.a
	local c = self.db.profile.BackdropBorder
	Quartz3.db.profile.bordercolor = {c.r, c.g, c.b}
	Quartz3.db.profile.borderalpha = c.a

	for _, modName in pairs{"Player", "Target", "Focus", "Pet"} do
		local mod = Quartz3:GetModule(modName, true)
		if mod and mod:IsEnabled() then
			self:applySkin{obj=mod.Bar}
			self:glazeStatusBar(mod.Bar.Bar, 1)
			mod.Bar.backdrop = CopyTable(self.backdrop) -- make backdrop mirror Skinner's
			mod.db.profile.texture = self.db.profile.StatusBar.texture
			-- handle changes for interrupt toggle code in Quartz
			if not modName == "Player" then
				mod.config.noInterruptChangeColor = false
				mod.config.noInterruptChangeBorder = false
				mod.config.border = self.backdrop.edgeFile
			end
		end
	end
	local mod = Quartz3:GetModule("Swing", true)
	if mod and mod:IsEnabled() then
		self:applySkin(_G["Quartz3SwingBar"])
		self:glazeStatusBar(self:getChild(_G["Quartz3SwingBar"], 1))
	end
	local mod = Quartz3:GetModule("Latency", true)
	if mod and mod:IsEnabled() then
		mod.lagbox:SetTexture(self.sbTexture)
	end
-->>-- Mirror Status Bars
	local qMirror = Quartz3:GetModule("Mirror", true)
	if qMirror then
		self:SecureHook(qMirror, "ApplySettings", function()
			skinSBs()
		end)
		skinSBs()
	end
-->>-- Buff Status Bars
	local qBuff = Quartz3:GetModule("Buff", true)
	if qBuff then
		self:SecureHook(qBuff, "ApplySettings", function()
			skinSBs()
		end)
		skinSBs()
	end

end
