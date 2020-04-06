if not Skinner:isAddonEnabled("Bagnon") then return end
--This Skin is for the Original Bagnon/Banknon Addon found here: http://wowui.incgamers.com/ui.php?id=4060
-- and here http://wow.curse.com/downloads/details/2090/
-- and also for the Bagnon Addon formerly known as vBagnon, found here: http://wow-en.curse-gaming.com/files/details/2090/vbagnon/ or here http://wowui.incgamers.com/ui.php?id=3197

-- Updated 26.06.09
-- vBagnon no longer is supported
-- Now supports the newest version found on Curse

function Skinner:Bagnon(LoD)
	if not self.db.profile.ContainerFrames or self.initialized.Bagnon then return end
	self.initialized.Bagnon = true

	--	if Addon is LoD then it's the original one
	if LoD then
		self:applySkin(Bagnon)
		Bagnon.SetBackdropColor = function() end
		Bagnon.SetBackdropBorderColor = function() end
		
	-- it's the newest version from Curse	
	else
		local Bagnon = LibStub('AceAddon-3.0'):GetAddon('Bagnon')
		-- skin the bag frame
		self:RawHook(Bagnon.Frame, "New", function(this, frameID)
--			self:Debug("Bagnon.Frame_New: [%s, %s]", this, frameID)
			local frame = self.hooks[Bagnon.Frame].New(this, frameID)
			self:applySkin(frame)
			frame.SetBackdropColor = function() end
			frame.SetBackdropBorderColor = function() end
			return frame
		end)
		-- skin the Search EditBox
		self:RawHook(Bagnon.SearchFrame, "New", function(this, ...)
			local eb = self.hooks[Bagnon.SearchFrame].New(this, ...)
			self:skinEditBox{obj=eb, regs={9}}
			return eb
		end)

	end

end

function Skinner:Banknon()
	if not self.db.profile.ContainerFrames then return end

	self:applySkin(Banknon)
	Bagnon.SetBackdropColor = function() end
	Bagnon.SetBackdropBorderColor = function() end

end

function Skinner:Bagnon_Forever()
	if not self.db.profile.ContainerFrames then return end

	self:SecureHook(BagnonDB, "ToggleDropdown", function(this)
		self:keepFontStrings(BagnonDBCharSelect)
		self:Unhook(BagnonDB, "ToggleDropdown")
	end)

end

function Skinner:Bagnon_Options()

	self:applySkin(BagnonRightClickMenu)
	self:skinDropDown(BagnonRightClickMenuPanelSelector)

end
