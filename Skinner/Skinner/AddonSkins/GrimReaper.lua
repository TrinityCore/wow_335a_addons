if not Skinner:isAddonEnabled("GrimReaper") then return end

function Skinner:GrimReaper()

	-- unload XPerl_GrimReaper skin if loaded
	if type(self["XPerl_GrimReaper"]) == "function" then self["XPerl_GrimReaper"] = nil end

	local gr = GrimReaper
	self:SecureHook(gr, "CreateAttachment", function(this)
--		self:Debug("gr:CA")
		self:applySkin(this.attachment)
		self:Unhook(gr, "CreateAttachment")
	end)

	self:SecureHook(gr, "CreateExtraFrame", function(this)
--		self:Debug("gr:CEF")
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then this.extraInfoTip:SetBackdrop(self.backdrop) end
			self:skinTooltip(this.extraInfoTip)
		end
		self:Unhook(gr, "CreateExtraFrame")
	end)

	self:SecureHook(gr, "CreateTooltipFrame", function(this, number)
--		self:Debug("gr:CTF: [%d]", number)
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then this.spellTip[number]:SetBackdrop(self.backdrop) end
			self:skinTooltip(this.spellTip[number])
			this.spellTip[number].SetBackdropBorderColor = function() end
		end
		if this.spellTip and this.spellTip[1] and this.spellTip[2] then
			self:Unhook(gr, "CreateTooltipFrame")
		end
	end)

end
