if not Skinner:isAddonEnabled("XLoot") then return end

local function skinXLoot(frame)

--	Skinner:Debug("skinXLoot [%s, %s]", frame:GetName(), rawget(Skinner.skinned, frame))

	if not Skinner.skinned[frame] then
		Skinner:applySkin(frame)
		frame.SetBackdropBorderColor = function() end
		if strfind(frame:GetName(), "Wrapper") then
			LowerFrameLevel(frame)
			frame.SetBackdrop = function() end
			local button = frame:GetParent()
			frame:SetWidth(button:GetWidth() + 9)
			frame:SetHeight(button:GetHeight() + 9)
			local xlr = strfind(frame:GetName(), "XLRow")
			if xlr and button.border then
				button.border:SetTexture(nil)
				button.border.Show = function() end
			end
		end
	end

end

function Skinner:XLoot()

	-- Hook the XLoot copy of the original skinning function
	self:RawHook(XLoot, "Skin", function(this, frame)
--		self:Debug("XL_Skin [%s, %s]", this, frame:GetName())
		skinXLoot(frame)
	end, true)

	self:SecureHook(XLoot, "AddLootFrame", function(this, id)
--		self:Debug("XL_ALF [%s, %s]", this, id)
		skinXLoot(XLoot.frames[id])
		skinXLoot(XLoot.buttons[id].wrapper)
	end)

	self:skinButton{obj=XLootCloseButton, cb=true}
	skinXLoot(XLoot.frame)
	skinXLoot(XLoot.frames[1])
	skinXLoot(XLoot.buttons[1].wrapper)

end

function Skinner:XLootGroup()

	self:applySkin(XLootGroup.AA.stacks.roll.frame)

end

function Skinner:XLootMonitor()

	self:applySkin(XLootMonitor.AA.stacks.loot.frame)

	self:SecureHook(XLootMonitor, "HistoryExportCopier", function(text)
		self:applySkin(XLootHistoryEditFrame)
		self:Unhook(XLootMonitor, "HistoryExportCopier")
	end)

end
