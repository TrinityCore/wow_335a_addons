if not Skinner:isAddonEnabled("LauncherMenu") then return end

function Skinner:LauncherMenu()

	-- first get the ldb dataobject
	local lm = LibStub('LibDataBroker-1.1'):GetDataObjectByName("LauncherMenu")
	
	-- then hook the OnClick function, where the frame is created
	-- N.B. DON'T use SecureHook it doesn't work here
	self:Hook(lm, "OnClick", function(frame)
--		self:Debug("LauncherMenu OnClick: [%s]", frame)
		self.hooks[lm].OnClick(frame)
		-- now find the menu frame
		for _, child in pairs{UIParent:GetChildren()} do
			if child
			and child.GetName
			and child:GetName() == nil
			and child.buttons
			and child.numButtons
			then
				self:applySkin{obj=child}
				-- hook the frame's OnShow script to adjust gradient as required
				self:HookScript(child, "OnShow", function(this)
					self.hooks[child].OnShow(this)
					self:applyGradient(child)
				end)
				break
			end
		end
		self:Unhook(lm, "OnClick")
	end)
	
end
