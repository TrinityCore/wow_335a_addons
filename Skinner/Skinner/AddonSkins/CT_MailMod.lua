if not Skinner:isAddonEnabled("CT_MailMod") then return end

function Skinner:CT_MailMod()
	if not self.db.profile.MailFrame then return end

	-- move MailItem1 position
	self:moveObject(MailItem1, "-", 5, "-", 5)
	-- move MailLog button
	self:moveObject(self:findFrame2(InboxFrame, "Button", "BOTTOM", InboxFrame, "BOTTOM", 0, 90), "-", 20, "-", 10)

	-- skin the Mail Log frame
	self:SecureHook(CT_MailMod, "getFrame", function()
--		self:Debug("CT_MM_gF")
		if CT_MailMod_MailLog then
			self:removeRegions(CT_MailMod_MailLog_ScrollFrame)
			self:skinScrollBar(CT_MailMod_MailLog_ScrollFrame)
			self:applySkin(CT_MailMod_MailLog)
			self:Unhook(CT_MailMod, "getFrame")
		end
	end)

end
