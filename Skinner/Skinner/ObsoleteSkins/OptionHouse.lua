
function Skinner:OptionHouse()

	local optHouse = LibStub("OptionHouse-1.1", true)

	local function skinOptionHouse(obj, ...)

--		Skinner:Debug("skinOptionHouse: [%s, %s, %s, %s, %s]", obj, select(1, ...) or "nil", select(2, ...) or "nil", select(3, ...) or "nil", select(4, ...) or "nil")

		local function moveOHFrame(frame)
--			Skinner:Debug("moveOHFrame: [%s, %s]", frame:GetObjectType(), frame:GetName())

			if frame:GetObjectType() == "ScrollFrame" then
				if not frame.sbskinned then
					frame:SetPoint("TOPLEFT", frame:GetParent(), "TOPLEFT", 190, -53)
					Skinner:keepFontStrings(frame)
					Skinner:skinScrollBar(frame)
					frame.sbskinned = true
				end
			elseif not frame.moved then
				Skinner:moveObject(frame, nil, nil, "+", 50, frame:GetParent())
				frame.moved = true
			end

		end

		-- move the Addon's frame down
		local ohAFrame = obj:GetFrame("addon")
		if ohAFrame and ohAFrame.shownFrame then moveOHFrame(ohAFrame.shownFrame) end

		if obj.skinned then return end

		-- check to see if the frames have been created yet
		local ohFrame = obj:GetFrame("main")
		if not ohFrame then return end

--		Skinner:Debug("OH Main Frame: [%s]", ohFrame)
		ohFrame:SetHeight(ohFrame:GetHeight() * Skinner.FyMult + 10)
		Skinner:keepFontStrings(ohFrame)
		-- move the title
		Skinner:getRegion(ohFrame, 2):SetPoint("TOP", 0, -6)
		-- move the close button
		for i = 1, ohFrame:GetNumChildren() do
			local v = select(i, ohFrame:GetChildren())
--		for k, v in pairs({ ohFrame:GetChildren() }) do
			if v:GetObjectType() == "Button"
			and math.floor(v:GetWidth()) == 32
			and math.floor(v:GetHeight()) == 32 then
				v:SetPoint("TOPRIGHT", 0, 0)
				break
			end
		end
		Skinner:applySkin(ohFrame)

		-- Tabs
		for i = 1, #ohFrame.tabs do
			local tabName = ohFrame.tabs[i]
	--		Skinner:Debug("OH Tab: [%s, %s]", i, tabName:GetWidth())
			Skinner:keepRegions(tabName, {1, 2}) -- N.B. region 1 is the Text, 2 is the highlight
			if Skinner.db.profile.TexturedTab then Skinner:applySkin(tabName, nil, 0, 1)
			else Skinner:applySkin(tabName) end
			tabName:ClearAllPoints()
			if i == 1 then
				Skinner:setActiveTab(tabName)
				tabName:SetPoint("TOPLEFT", ohFrame, "BOTTOMLEFT", 15, 7)
			else
				Skinner:setInactiveTab(tabName)
				tabName:SetPoint("TOPLEFT", ohFrame.tabs[i - 1], "TOPRIGHT", -4, 0)
			end
			Skinner:RawHook(tabName, "SetPoint", function() end, true)
		end

		-- Hook this to manage the Sub Frames
		Skinner:SecureHook(obj, "RegisterFrame", function(this, type, frame)
	--		Skinner:Debug("OH_RF: [%s, %s]", type, frame)
			Skinner:keepFontStrings(frame.scroll)
			frame.scroll.bar:GetThumbTexture():SetAlpha(1)
			Skinner:skinUsingBD2(frame.scroll.bar)
			frame.scroll.bar:ClearAllPoints()
			frame.scroll.bar:SetPoint("TOPLEFT", frame.scroll, "TOPRIGHT", 6, 12)
			frame.scroll.bar:SetPoint("BOTTOMLEFT", frame.scroll, "BOTTOMRIGHT", 6, -10)
			Skinner:moveObject(frame.sortButtons[1], nil, nil, "+", 50, frame)
			if type == "manage" then
				Skinner:moveObject(frame.sortButtons[2], nil, nil, "+", 50, frame)
				Skinner:moveObject(frame.sortButtons[3], nil, nil, "+", 50, frame)
			end
		 	Skinner:skinEditBox(frame.search, {9})
			if Skinner.db.profile.TexturedTab then
				Skinner:SecureHook(frame, "Show", function(this)
					for i = 1, #ohFrame.tabs do
						local tabName = ohFrame.tabs[i]
						Skinner:setInactiveTab(tabName)
						if i == obj:GetFrame("main").selectedTab then Skinner:setActiveTab(tabName) end
					end
				end)
			end
		end)

	--	Addon Frame
		local ohAFrame = obj:GetFrame("addon")
	--	Skinner:Debug("OH Addon Frame: [%s]", ohAFrame)
		local sf = ohAFrame.scroll
		Skinner:keepFontStrings(sf)
		Skinner:skinUsingBD2(sf.bar)
		Skinner:moveObject(sf, nil, nil, "+", 45, ohAFrame)
		local thumb = sf.bar:GetThumbTexture()
		thumb:SetAlpha(1)
	 	Skinner:skinEditBox(ohAFrame.search, {9})
		-- hook Addons button OnClick
	 	for i = 1, 15 do
	 		local ohSFbutton = ohAFrame.buttons[i]
	 		if i == 1 then Skinner:moveObject(ohSFbutton, nil, nil, "+", 50, ohAFrame) end
	 		Skinner:keepRegions(ohSFbutton, {2, 4}) -- N.B. region 2 is the Text, 4 is the highlight
	 		local ohSFBGNT = ohSFbutton:GetNormalTexture()
	 		Skinner:RawHook(ohSFBGNT, "SetAlpha", function() end, true) -- stop the textures being shown
			-- hook this to manage the sub fields
			-- N.B. Don't unhook them as they are reallocated as required
			Skinner:HookScript(ohSFbutton, "OnClick", function(this)
				Skinner.hooks[this].OnClick(this)
	--			Skinner:Debug("OH_AF_OC: [%s, %s, %s, %s]", this, this.catText, this.type, this.data)
				if this.data and this.data.frame then moveOHFrame(this.data.frame) end
				if this.catText == "OptionHouse" and not this.data.skinned then
					Skinner:skinEditBox(OHConfigUIPerfSize, {9})
					Skinner:moveObject(OHConfigUIPerfSize, "-", 8, "+", 4, this.data.frame)
					Skinner:skinEditBox(OHConfigUIManageSize, {9})
					Skinner:moveObject(OHConfigUIManageSize, "-", 8, nil, nil, this.data.frame)
					Skinner:skinDropDown(OHConfigUIDepMode)
					Skinner:skinDropDown(OHConfigUIChildMode)
					this.data.skinned = true
				end
			end)
	 	end
		Skinner:SecureHook(ohAFrame, "Show", function(this)
			for i = 1, #ohFrame.tabs do
				local tabName = ohFrame.tabs[i]
				Skinner:setInactiveTab(tabName)
				if i == obj:GetFrame("main").selectedTab then Skinner:setActiveTab(tabName) end
			end
		end)

		obj.skinned = true

	end

	self:SecureHook(optHouse, "Open", function(this, ...)
--		self:Debug("OH Open: [%s, %s]", this, ...)
		skinOptionHouse(this, ...)
		self:Unhook(this, "Open")
	end)
	self:SecureHook(SlashCmdList, "OPTHOUSE", function()
--		self:Debug("OH SCL")
		skinOptionHouse(optHouse)
		self:Unhook(SlashCmdList, "OPTHOUSE")
	end)

end
