if not Skinner:isAddonEnabled("CallToArms") then return end

function Skinner:CallToArms()

	-- Information Dialog
	self:applySkin(CTA_InformationDialog)

	-- Main Frame
	self:keepFontStrings(CTA_MainFrame)
	CTA_MainFrame:SetHeight(CTA_MainFrame:GetHeight() + 20)
	CTA_MainFrame:SetAlpha(1)
	self:applySkin(CTA_MainFrame)
	
	-- Main Frame Tabs
	for _, v in pairs{"Search", "MyRaid", "LFG", "MFF"} do
		local tabName = _G["CTA_Show"..v.."Button"]
		self:keepRegions(tabName, {7, 8})
		if v == "Search" then self:moveObject(tabName, "-", 5, "+", 28)
		elseif v == "MFF" then self:moveObject(tabName, nil, nil, "+", 28)
		else self:moveObject(tabName, "+", 10, nil, nil)
		end
		self:moveObject(self:getRegion(tabName, 7), nil, nil, "-", 8)
		self:moveObject(self:getRegion(tabName, 8), nil, nil, "-", 8)
		self:applySkin(tabName)
	end
	
	-- Search Frame
	for _, v in pairs{"Results", "Options"} do
		local butName = _G["CTA_Show"..v.."Button"]
		self:keepRegions(butName, {7, 8})
		if v == "Results" then self:moveObject(butName, nil, nil, "-", 10) end
		self:moveObject(self:getRegion(butName, 7), nil, nil, "+", 5)
		self:moveObject(self:getRegion(butName, 8), nil, nil, "+", 7)
		self:applySkin(butName)
	end
	-- Results SubFrame
	self:keepFontStrings(CTA_SearchDropDown)
	-- Filters SubFrame
	self:applySkin(CTA_SearchFrame_Filters_PlayerInternalFrame)
	self:keepFontStrings(CTA_PlayerClassDropDown)
	self:applySkin(CTA_SearchFrame_Filters_GroupInternalFrame)
	
	-- My Raid Frame
	self:keepFontStrings(CTA_RoleplayDropDown)
	
	-- LFG Frame
	
	-- More Features Frame
	for _, v in pairs{"ShowBlacklist", "SettingsFrame", "LogFrame"} do
		local butName = _G["CTA_"..v.."Button"]
		self:keepRegions(butName, {7, 8})
		if v == "ShowBlacklist" then self:moveObject(butName, nil, nil, "-", 10) end
		self:moveObject(self:getRegion(butName, 7), nil, nil, "+", 5)
		self:moveObject(self:getRegion(butName, 8), nil, nil, "+", 7)
		self:applySkin(butName)
	end
	-- Settings SubFrame
	self:applySkin(CTA_SettingsFrameMinimapSettings)
	self:applySkin(CTA_SettingsFrameLFxSettings)
	-- Blacklist SubFrame
	self:applySkin(CTA_GreyListItemEditFrame)
	-- Add Player Frame
	self:applySkin(CTA_AddPlayerFrame)
	-- Log SubFrame
	self:applySkin(CTA_LogFrameInternalFrame)
	
end
