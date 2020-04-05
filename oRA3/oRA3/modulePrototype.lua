local addon = LibStub("AceAddon-3.0"):GetAddon("oRA3")

local prototype = {}

function prototype:OnInitialize()
	if self.VERSION and self.VERSION > addon.VERSION then
		addon.VERSION = self.VERSION
	end
	if type(self.OnRegister) == "function" then
		self:OnRegister()
	end
end

addon:SetDefaultModulePrototype(prototype)
