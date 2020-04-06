if not Skinner:isAddonEnabled("Enchantrix") then return end

function Skinner:Enchantrix()

-->>-- Manifest frame
	self:SecureHook(Enchantrix_Manifest, "ShowMessage", function(this, msg)
		self:addSkinFrame{obj=Enchantrix_Manifest.messageFrame, kfs=true}
		self:Unhook(Enchantrix_Manifest, "ShowMessage")
	end)

-->>-- AutoDisenchant prompt
	local eVer = tonumber(GetAddOnMetadata("Enchantrix", "Version"):match("%d\.%d\.(%d%d%d%d)"))
	local height = eVer == 4293 and 130 or 170
	local auto_de_prompt = self:findFrame2(UIParent, "Frame", height, 400)
	if auto_de_prompt then self:addSkinFrame{obj=auto_de_prompt, kfs=true} end

end
