if not Skinner:isAddonEnabled("BetterInbox") then return end

function Skinner:BetterInbox(LoD)
	if not self.db.profile.MailFrame then return end

	local bib = LibStub('AceAddon-3.0'):GetAddon('BetterInbox', true)
	if not bib then return end
	
	local function skinBIb()

		bib.scrollframe.t1:SetAlpha(0)
		bib.scrollframe.t2:SetAlpha(0)
		Skinner:skinScrollBar{obj=bib.scrollframe}
		for i = 1, #bib.scrollframe.entries do
			self:removeRegions(bib.scrollframe.entries[i], {1, 2, 3})
		end
		-- skin the buttons
		Skinner:skinButton{obj=BetterInboxOpenButton}
		Skinner:skinButton{obj=BetterInboxCancelButton}

	end

	if not LoD then
		self:SecureHook(bib, "SetupGUI", function()
			skinBIb()
			self:Unhook(bib, "SetupGUI")
		end)
	else
		skinBIb()
	end

end
