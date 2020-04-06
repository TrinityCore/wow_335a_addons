
function Skinner:OneBag()
	if not self.db.profile.ContainerFrames or self.initialized.OneBag then return end
	self.initialized.OneBag = true

	self:HookScript(OneBagFrame, "OnShow", function(this)
		self.hooks[this].OnShow(this)
		self:applySkin(OneBagFrame)
		self:Hook(OneBagFrame, "SetBackdropColor", function() end, true)
		self:Unhook(OneBagFrame, "OnShow")
	end)

	self:applySkin(OBBagFram)
	self:Hook(OBBagFram, "SetBackdropColor", function() end, true)

	if OneRingFrame then
		self:applySkin(OneRingFrame)
		self:Hook(OneRingFrame, "SetBackdropColor", function() end, true)
	end

	if OneViewFrame then
		self:applySkin(OneViewFrame)
		self:Hook(OneViewFrame, "SetBackdropColor", function() end, true)
	end

end
