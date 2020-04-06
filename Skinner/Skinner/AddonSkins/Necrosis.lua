if not Skinner:isAddonEnabled("Necrosis") then return end

function Skinner:Necrosis()

	self:SecureHook(Necrosis, "OpenConfigPanel", function()
		self:addSkinFrame{obj=NecrosisGeneralFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=71}
	-->>-- Tabs (side)
		for i = 1, 6 do
			self:removeRegions(_G["NecrosisGeneralTab"..i], {1}) -- N.B. other regions are icon and highlight
		end
		tinsert(UISpecialFrames,"NecrosisGeneralFrame") -- make it closeable via the Esc key
		self:Unhook(Necrosis, "OpenConfigPanel")
	end)
	self:SecureHook(Necrosis, "SetMessagesConfig", function()
		-- Message Settings panel
		self:skinDropDown{obj=NecrosisLanguageSelection}
		self:Unhook(Necrosis, "SetMessagesConfig")
	end)
	self:SecureHook(Necrosis, "SetSphereConfig", function()
		-- Sphere Settings panel
		self:skinDropDown{obj=NecrosisSkinSelection}
		self:skinDropDown{obj=NecrosisEventSelection}
		self:skinDropDown{obj=NecrosisSpellSelection}
		self:skinDropDown{obj=NecrosisCountSelection}
		self:Unhook(Necrosis, "SetSphereConfig")
	end)
	self:SecureHook(Necrosis, "SetButtonsConfig", function()
		-- Button Settings panel
		self:skinAllButtons{obj=NecrosisButtonsConfig}
		self:Unhook(Necrosis, "SetButtonsConfig")
	end)
	self:SecureHook(Necrosis, "SetMenusConfig", function()
		-- Menus Settings panel
		self:skinAllButtons{obj=NecrosisMenusConfig}
		self:skinDropDown{obj=NecrosisBuffVector}
		self:skinDropDown{obj=NecrosisDemonVector}
		self:skinDropDown{obj=NecrosisCurseVector}
		self:Unhook(Necrosis, "SetMenusConfig")
	end)
	self:SecureHook(Necrosis, "SetTimersConfig", function()
		-- Timers Settings panel
		self:skinDropDown{obj=NecrosisTimerSelection}
		self:Unhook(Necrosis, "SetTimersConfig")
	end)
--[=[
	self:SecureHook(Necrosis, "SetMiscConfig", function()
		-- Misc Settings panel
		self:Unhook(Necrosis, "SetMiscConfig")
	end)
--]=]
	
end
