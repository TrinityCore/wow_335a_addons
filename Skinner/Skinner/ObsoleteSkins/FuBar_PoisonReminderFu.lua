
function Skinner:FuBar_PoisonReminderFu()

	-- hook this to skin if they don't exist yet
	self:SecureHook(PoisonReminderFu, "SetupFrames", function(this, hand, item)
--		self:Debug("PRF_SF: [%s, %s, %s]", this:GetName(), hand, item)
		if not this.frames[hand].skinned then
			self:applySkin(this.frames[hand].anchor)
			this.frames[hand].skinned = true
		end
	end)

	for k, v in pairs(PoisonReminderFu.frames) do
--		self:Debug("PRF_frames: [%s, %s]", k, v)
		self:applySkin(PoisonReminderFu.frames[k].anchor)
		PoisonReminderFu.frames[k].skinned = true
	end

end
