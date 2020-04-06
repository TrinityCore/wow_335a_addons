-- This is a Library

Skinner.ignoreLQTT = {}

function Skinner:LibQTip()
	if not self.db.profile.Tooltips.skin or self.initialized.LibQTip then return end
	self.initialized.LibQTip = true

	local lqt = LibStub("LibQTip-1.0", true)
	if lqt then
		local function skinLTTooltips(lib)
	
			for key, tooltip in lib:IterateTooltips() do
--	 			Skinner:Debug("%s:[%s, %s]", ttLib, key, tooltip)
				-- ignore tooltips if required
				if not Skinner.ignoreLQTT[key] then
					if not Skinner.skinned[tooltip] then
						Skinner:applySkin{obj=tooltip}
					end
				end
			end
		
		end
		-- hook this to handle new tooltips
		self:SecureHook(lqt, "Acquire", function(this, key, ...)
			skinLTTooltips(this)
		end)
		-- hook this to handle tooltips being released
		self:SecureHook(lqt, "Release", function(this, tt)
			if tt then self.skinned[tt] = nil end
		end)
		-- skin any existing ones
		skinLTTooltips(lqt)
	end

end
