if not Skinner:isAddonEnabled("AdiBags") then return end

function Skinner:AdiBags()

	local aBag = LibStub("AceAddon-3.0"):GetAddon("AdiBags")
	
	-- hook this for bag panel creation
	self:RawHook(aBag, "CreateBagSlotPanel", function(this, ...)
		local bPanel = self.hooks[this].CreateBagSlotPanel(this, ...)
		self:addSkinFrame{obj=bPanel}
		return bPanel
	end, true)
	-- hook this for bag creation
	aBag:HookBagFrameCreation(self, function(bag)
		self:ScheduleTimer(function(bag) 
--			self:Debug("OnBagFrameCreated: [%s, %s]", bag, bag.bagName)
			local frame = bag:GetFrame()
			self:addSkinFrame{obj=frame}
			if bag.bagName == "Backpack" then self:skinEditBox{obj=AdiBagsSearchEditBox, regs={9}} end
		end, 0.2, bag) -- wait for 2/10th second for frame to be created fully
	end)

end
