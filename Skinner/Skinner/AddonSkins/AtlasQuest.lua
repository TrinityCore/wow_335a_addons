if not Skinner:isAddonEnabled("AtlasQuest") then return end

function Skinner:AtlasQuest()

	AQBACKGROUNDTEXTUR:SetAlpha(0)
	self:applySkin(AtlasQuestFrame)
	
-->>--	Options Frame
	self:keepFontStrings(AtlasQuestOptionFrame)
	self:applySkin(AtlasQuestOptionFrame)


-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AtlasQuestTooltip:SetBackdrop(self.backdrop) end
		self:SecureHook(AtlasQuestTooltip, "Show", function(this, ...)
			self:skinTooltip(AtlasQuestTooltip)
		end)
	end
	
end
