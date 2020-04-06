if not Skinner:isAddonEnabled("sRaidFrames") then return end

function Skinner:sRaidFrames()

	-- set StatusBar Texture
	sRaidFrames.opt.Texture = self.db.profile.StatusBar.texture
	local sbTex = self.LSM:Fetch("statusbar", self.db.profile.StatusBar.texture)
	for _, f in pairs(sRaidFrames.frames) do
		f.hpbar:SetStatusBarTexture(sbTex)
		f.hpbar:GetStatusBarTexture():SetHorizTile(false)
		f.hpbar:GetStatusBarTexture():SetVertTile(false)
		f.mpbar:SetStatusBarTexture(sbTex)
		f.mpbar:GetStatusBarTexture():SetHorizTile(false)
		f.mpbar:GetStatusBarTexture():SetVertTile(false)
	end
	-- set Border Texture
	sRaidFrames.opt.BorderTexture = self.db.profile.BdBorderTexture
	local bdTex = self.LSM:Fetch("border", self.db.profile.BdBorderTexture)
	for _, frame in pairs(sRaidFrames.frames) do
		local backdrop = frame:GetBackdrop()
		backdrop.edgeFile = bdTex
		frame:SetBackdrop(backdrop)
	end
	-- set Backdrop colour
	local c = self.db.profile.Backdrop
	sRaidFrames.opt.BackgroundColor = {r = c.r, g = c.g, b = c.b, a = c.a}
	sRaidFrames:UpdateAllUnits()
	-- set backdrop border colour
	local c = self.db.profile.BackdropBorder
	sRaidFrames.opt.BorderColor = {r = c.r, g = c.g, b = c.b, a = c.a}
	for _, frame in pairs(sRaidFrames.frames) do
		frame:SetBackdropBorderColor(c.r, c.g, c.b, c.a)
	end

end
