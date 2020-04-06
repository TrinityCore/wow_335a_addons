if not Skinner:isAddonEnabled("PlayerExpBar") then return end

function Skinner:PlayerExpBar()

	for _, suffix in pairs{"Main", "Pet", "_RepWatch"} do
		self:keepFontStrings(_G["PlayerExpBar"..suffix])
		self:glazeStatusBar(_G["PlayerExpBar"..(suffix~="Main" and suffix or "").."StatusBar"], 0)
	end

-->>--	Config Frame
	self:keepFontStrings(PlayerExpBarOptionsFrame)
	self:applySkin(PlayerExpBarOptionsFrame)
	self:SecureHook(PlayerExpBarOptionsFrame, "Show", function()
		self:moveObject(self:getRegion(PlayerExpBarOptionsFrame, 2), nil, nil, "-", 6)
		self:Unhook(PlayerExpBarOptionsFrame, "Show")
	end)

end
