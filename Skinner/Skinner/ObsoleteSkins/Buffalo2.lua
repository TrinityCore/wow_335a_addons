
function Skinner:Buffalo2()

	local function skinB2Button(obj)
	--	self:Debug("skinB2Button: [%s]", obj:GetName())

		if not obj.skinned then
			Skinner:addSkinButton(obj)
			obj.skinned = true
		end

	end

	self:RawHook(Buffalo2, "GetButton", function(this, container)
--		self:Debug("Buffalo2_GetButton: [%s, %s]", this, container:GetName())
		local button = self.hooks[this].GetButton(this, container)
--		self:Debug("Buffalo2_GetButton#2: [%s]", button)
		self:SecureHook(button, "Show", function(this)
			skinB2Button(this.frame)
			self:Unhook(button, "Show")
			end)
		return button
	end, true)

	for _, container in pairs(Buffalo2.ActiveContainers) do
		for _, button in container.buttons:Iterator() do
--			self:Debug("B2: [%s, %s]", container:GetName(), button.frame:GetName())
			skinB2Button(button.frame)
		end
	end
end
