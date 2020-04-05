--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = _G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers
	-- none

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> create a button which will be displayed on tooltip
	function _details.ToolBar:NewPluginToolbarButton(func, icon, pluginname, tooltip, w, h, framename)

		--> random name if nameless
		if (not framename) then
			framename = "DetailsToolbarButton" .. math.random(1, 100000)
		end

		--> create button from template
		local button = CreateFrame("button", framename, _details.listener, "DetailsToolbarButton")
		
		--> sizes
		if (w) then
			button:SetWidth(w)
		end
		if (h) then
			button:SetHeight(h)
		end
		
		button.x = 0
		button.y = 0
		
		--> tooltip and function on click
		button.tooltip = tooltip
		button:SetScript("OnClick", func)

		--> textures
		button:SetNormalTexture(icon)
		button:SetPushedTexture(icon)
		button:SetDisabledTexture(icon)
		button:SetHighlightTexture(icon, "ADD")
		button.__icon = icon
		button.__name = pluginname
		
		--> blizzard built-in animation
		local FourCornerAnimeFrame = CreateFrame("frame", framename.."Blink", button, "IconIntroAnimTemplate")
		FourCornerAnimeFrame:SetPoint("center", button)
		FourCornerAnimeFrame:SetWidth(w or 14)
		FourCornerAnimeFrame:SetHeight(w or 14)
		FourCornerAnimeFrame.glow:SetScript("OnFinished", nil)
		button.blink = FourCornerAnimeFrame
		
		_details.ToolBar.AllButtons[#_details.ToolBar.AllButtons+1] = button
		
		return button
	end
	
	--> show your plugin icon on tooltip
	function _details:ShowToolbarIcon(Button, Effect)

		local LastIcon
		
		--> get the lower number instance
		local lower_instance = _details:GetLowerInstanceNumber()
		if (not lower_instance) then
			return
		end
		
		local instance = _details:GetInstance(lower_instance)
		
		if (#_details.ToolBar.Shown > 0) then
			--> already shown
			if (_details:tableIN(_details.ToolBar.Shown, Button)) then
				return
			end
			LastIcon = _details.ToolBar.Shown[#_details.ToolBar.Shown]
		else
			LastIcon = instance.baseframe.header.report
		end
		
		local x = 0
		if (instance.consolidate) then
			LastIcon = instance.consolidateButtonTexture
			x = x - 3
		end

		_details.ToolBar.Shown[#_details.ToolBar.Shown+1] = Button
		Button:SetPoint("left", LastIcon.widget or LastIcon, "right", Button.x + x, Button.y)
		Button:Show()
		
		if (Effect) then
			if (type(Effect) == "string") then
				if (Effect == "blink") then
					Button.blink.glow:Play()
				elseif (Effect == "star") then
					Button.StarAnim:Play()
				end
			elseif (Effect) then
				Button.blink.glow:Play()
			end
		end
		
		_details.ToolBar:ReorganizeIcons(true)
		
		return true
	end

	--> hide your plugin icon from toolbar
	function _details:HideToolbarIcon(Button)
		
		local index = _details:tableIN(_details.ToolBar.Shown, Button)
		
		if (not index) then
			--> current not shown
			return
		end
		
		Button:Hide()
		table.remove(_details.ToolBar.Shown, index)
		
		--> reorganize icons
		_details.ToolBar:ReorganizeIcons(true)
		
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions

	--[[global]] function DetailsToolbarButtonOnEnter(button)
	
		local lower_instance = _details:GetLowerInstanceNumber()
		if (lower_instance) then
			_details.OnEnterMainWindow(_details:GetInstance(lower_instance), button, 3)
		end
	
		if (button.tooltip) then
		
			GameCooltip:Reset()
			
			--GameCooltip:SetOption("FixedWidth", 200)
			GameCooltip:SetOption("ButtonsYMod", -3)
			GameCooltip:SetOption("YSpacingMod", -3)
			GameCooltip:SetOption("IgnoreButtonAutoHeight", true)
			GameCooltip:SetColor(1, 0.5, 0.5, 0.5, 0.5)
			
			GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
			
			--[[title]] GameCooltip:AddLine(button.__name, nil, 1, "orange", nil, 12, SharedMedia:Fetch("font", "Friz Quadrata TT"))
				GameCooltip:AddIcon(button.__icon, 1, 1, 16, 16)
			----[[desc]] GameCooltip:AddLine(button.tooltip)
			
			GameCooltip:ShowCooltip(button, "tooltip")
		end
	end
	--[[global]] function DetailsToolbarButtonOnLeave(button)
	
		local lower_instance = _details:GetLowerInstanceNumber()
		if (lower_instance) then
			_details.OnLeaveMainWindow(_details:GetInstance(lower_instance), button, 3)
		end
	
		if (button.tooltip) then
			_details.popup:ShowMe(false)
		end
	end	

	_details:RegisterEvent(_details.ToolBar, "DETAILS_INSTANCE_OPEN", "OnInstanceOpen")
	_details:RegisterEvent(_details.ToolBar, "DETAILS_INSTANCE_CLOSE", "OnInstanceClose")
	_details.ToolBar.Enabled = true --> must have this member or wont receive the event
	_details.ToolBar.__enabled = true

	function _details.ToolBar:OnInstanceOpen() 
		_details.ToolBar:ReorganizeIcons(true)
	end
	function _details.ToolBar:OnInstanceClose() 
		_details.ToolBar:ReorganizeIcons(true)
	end

	function _details.ToolBar:ReorganizeIcons(just_refresh)
		--> get the lower number instance
		local lower_instance = _details:GetLowerInstanceNumber()
	
		if (not lower_instance) then
			for _, ThisButton in ipairs(_details.ToolBar.Shown) do 
				ThisButton:Hide()
			end
			return
		end

		local instance = _details:GetInstance(lower_instance)

		if (not just_refresh) then
			for _, instance in pairs(_details.table_instances) do 
				if (instance.baseframe and instance:IsActive()) then
					instance:ReadjustGump()
				end
			end

			instance:ChangeSkin()
		else
			--instance:SetMenuAlpha()
			instance:ToolbarMenuButtons()
		end
		
		return true
	end
