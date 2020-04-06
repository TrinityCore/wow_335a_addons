
function Skinner:SpellBinder(LoD)

	if not LoD then
		self:SecureHook(SpellBinder, "Toggle", function()
			self:applySkin(SpellBinderFrame)
			self:Unhook(SpellBinder, "Toggle")
			end)
	else
		self:applySkin(SpellBinderFrame)
	end

end
