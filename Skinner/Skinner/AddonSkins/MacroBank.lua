if not Skinner:isAddonEnabled("MacroBank") then return end

function Skinner:MacroBank()
	if not self.db.profile.MenuFrames then return end
	
	self:SecureHook(MacroBank.MainFrame, "Show", function(this, ...)
		local frame = MacroBank.MainFrame
		frame.HeaderTexture:Hide()
		frame.HeaderTexture:SetPoint("TOP", frame, "TOP", 0, 7)
		self:applySkin{obj=frame, kfs=true}
		-- ToMacroBank frame
		self:applySkin{obj=frame.Macros.ToMacroBank}
		-- FromMacroBank frame
		self:applySkin{obj=frame.Macros.FromMacroBank}
		-- MacroList frame
		self:skinScrollBar{obj=frame.Macros.MacroList.ScrollFrame, size=3}
		self:applySkin(frame.Macros.MacroList)
		-- Macros frame
		self:skinEditBox(frame.Macros.MacroCategory, {9})
		self:skinEditBox(frame.Macros.MacroDescription, {9})
		self:skinEditBox(frame.Macros.MacroName, {9})
		-- IconChoice frame
		self:skinScrollBar{obj=frame.Macros.IconChoice.ScrollFrame}
		self:applySkin{obj=frame.Macros.IconChoice, kfs=true}
		-- MacroBody frame
		self:skinScrollBar{obj=frame.Macros.MacroBody.ScrollFrame, size=3}
		self:applySkin(frame.Macros.MacroBody)
		self:Unhook(MacroBank.MainFrame, "Show")
	end)

end
