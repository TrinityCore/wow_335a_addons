
function Skinner:ReadySpells()

	ReadySpells.db.profile.spacing = 5

	self:SecureHook(ReadySpells, "UpdateDisplaySlotsForUnit", function(this, unit, gcd, currentSlots)
--		self:Debug("RS_UDSFU: [%s, %s, %s]", unit, gcd, #currentSlots)
		if unit == "target" then
			for i = 1, #currentSlots do
				local tex = currentSlots[i].texture
				if not self.skinned[tex] then
					self:addSkinButton(tex, ReadySpellsFrame, tex, true)
				end
			end
		end
	end)

	self:applySkin(ReadySpellsAnchor)

end
