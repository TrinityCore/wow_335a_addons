if not Skinner:isAddonEnabled("EngBags") then return end

function Skinner:EngBags()
	if not self.db.profile.ContainerFrames then return end

--	self:Debug("EngBags")

	self:SecureHook("EngInventory_UpdateWindow", function()
--		self:Debug("EngInventory_UpdateWindow")
		for i = 1, EngBags_MAX_BARS do
			local frame = _G["EngInventory_frame_bar_"..i]
			self:applySkin(frame)
			frame.SetBackdropColor = function() end
			frame.SetBackdropBorderColor = function() end
		end
		self:keepRegions(EngInventory_frame)
		self:applySkin(EngInventory_frame)
		EngInventory_frame.SetBackdropColor = function() end
		EngInventory_frame.SetBackdropBorderColor = function() end
		self:Unhook("EngInventory_UpdateWindow")
	end)

	self:SecureHook("EngInventory_Options_InitWindow", function()
--		self:Debug("EngInventory_Options_InitWindow")
		self:keepRegions(EngInventory_OptsFrame)
		self:applySkin(EngInventory_OptsFrame)
		self:skinScrollBar(EngInventory_OptsFrame, "_")
		for i = 1, #ENGINVENTORY_OPTIONS_LIST_FRAMES do
			for j = 1, 4 do
				local eb = _G["EngInventory_OptsFrame_Line_"..i.."_Edit_"..j]
				self:skinEditBox(eb)
			end
		end
		EngInventory_OptsFrame.SetBackdropColor = function() end
		EngInventory_OptsFrame.SetBackdropBorderColor = function() end
		self:Unhook("EngInventory_Options_InitWindow")
	end)

	-- move the editboxes to the left
	self:SecureHook("EngInventory_Options_UpdateWindow", function()
--		self:Debug("EngInventory_Options_UpdateWindow")
		for i = 1, #ENGINVENTORY_OPTIONS_LIST_FRAMES do
			for j = 1, 4 do
				local eb = _G["EngInventory_OptsFrame_Line_"..i.."_Edit_"..j]
				self:moveObject(eb, "-", 10, nil, nil)
			end
		end
	end)

	self:moveObject(EngInventory_OptsFrame_Button_Close, nil, nil, "+", 10)

	self:SecureHook("EngBank_UpdateWindow", function()
--		self:Debug("EngBank_UpdateWindow")
		for i = 1, EngBags_MAX_BARS do
			local frame = _G["EngBank_frame_bar_"..i]
			self:applySkin(frame)
			frame.SetBackdropColor = function() end
			frame.SetBackdropBorderColor = function() end
		end
		self:applySkin(EngBank_frame)
		EngBank_frame.SetBackdropColor = function() end
		EngBank_frame.SetBackdropBorderColor = function() end
		self:Unhook("EngBank_UpdateWindow")
	end)

	self:SecureHook("EngBank_Options_InitWindow", function()
--		self:Debug("EngBank_Options_InitWindow")
		self:applySkin(EngBank_OptsFrame)
		self:skinScrollBar(EngBank_OptsFrame, "_")
		for i = 1, #EngBank_Options_LIST_FRAMES do
			for j = 1, 4 do
				local eb = _G["EngBank_OptsFrame_Line_"..i.."_Edit_"..j]
				self:skinEditBox(eb)
			end
		end
		EngBank_OptsFrame.SetBackdropColor = function() end
		EngBank_OptsFrame.SetBackdropBorderColor = function() end
		self:Unhook("EngBank_Options_InitWindow")
	end)

	-- move the editboxes to the left
	self:SecureHook("EngBank_Options_UpdateWindow", function()
--		self:Debug("EngBank_Options_UpdateWindow")
		for i = 1, #EngBank_Options_LIST_FRAMES do
			for j = 1, 4 do
				local eb = _G["EngBank_OptsFrame_Line_"..i.."_Edit_"..j]
				self:moveObject(eb, "-", 10, nil, nil)
			end
		end
	end)

	self:moveObject(EngBank_OptsFrame_Button_Close, nil, nil, "+", 10)

end
