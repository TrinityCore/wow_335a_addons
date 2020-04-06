if not Skinner:isAddonEnabled("FBagOfHolding") then return end

function Skinner:FBagOfHolding()
	if not self.db.profile.ContainerFrames.skin then return end

	local function skinFBoHBags(obj)
--		Skinner:Debug("skinFBoHBags:[%s, %s]", obj, obj.view:GetName())

	-->>--	Frame
		local bfObj = obj.view
		local bfName = bfObj:GetName()
		local bfSearch = _G[bfName.."_SearchEdit"]
		local bfIF = _G[bfName.."_ItemsFrame"]
		local bfIFILSFS = _G[bfName.."_ItemsFrame_ItemListScrollFrame_Scroll"]
		local bfIFIGSFS = _G[bfName.."_ItemsFrame_ItemGridScrollFrame_Scroll"]
		if bfObj and not Skinner.skinned[bfObj] then
			Skinner:skinEditBox(bfSearch, {9})
			Skinner:applySkin(bfIF)
			Skinner:removeRegions(bfIFILSFS)
			Skinner:skinScrollBar(bfIFILSFS)
			Skinner:removeRegions(bfIFIGSFS)
			Skinner:skinScrollBar(bfIFIGSFS)
			Skinner:applySkin(bfObj)
		end
	-->>--	Tabs
		for i, _ in ipairs(obj.viewDef.tabs) do
			local tabObj = obj.tabData[i].button
			if tabObj and not Skinner.skinned[tabObj] then
				Skinner:keepRegions(tabObj, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
				if Skinner.db.profile.TexturedTab then
					Skinner:applySkin(tabObj, nil, 0, 1)
					if i == obj.viewDef.activeTab then Skinner:setActiveTab(tabObj)
					else Skinner:setInactiveTab(tabObj) end
				else Skinner:applySkin(tabObj) end
				if i == 1 then Skinner:moveObject(tabObj, nil, nil, "-", 4)
				else Skinner:moveObject(tabObj, "-", 6, nil, nil) end
				Skinner:moveObject(Skinner:getRegion(tabObj, 4), nil, nil, "+", 5)
				Skinner:moveObject(Skinner:getRegion(tabObj, 5), "+", 5, "+", 7)
				-- hook this to handle the resizing of the tab highlight width
				Skinner:SecureHook(tabObj, "UpdateTabModel", function(this, model)
--					Skinner:Debug("FBoH_VTT_UTM:[%s, %s]", this, model)
					Skinner:getRegion(this, 5):SetWidth(this:GetWidth() - 10) -- shrink highlight
				end)
			end
		end
		if Skinner.db.profile.TexturedTab then
			Skinner:SecureHook(obj, "SelectTab", function(this, tabIndex)
--				Skinner:Debug("FBoH_VM.p:ST:[%s, %s]", this, tabIndex)
				for i, _ in ipairs(this.viewDef.tabs) do
					local tabObj = this.tabData[i].button
					if i == tabIndex then Skinner:setActiveTab(tabObj)
					else Skinner:setInactiveTab(tabObj) end
					if i == 1 then Skinner:moveObject(tabObj, nil, nil, "-", 4)
					else Skinner:moveObject(tabObj, "-", 6, nil, nil) end
				end
			end)
		end

	end

	-- hook this to manage New Views
	self:SecureHook(FBoH, "CreateNewView", function()
		skinFBoHBags(FBoH.bagViews[#(FBoH.bagViews)])
	end)

	-- hook this to manage New Undocked Views
	self:SecureHook(FBoH, "UndockView", function(this, sourceView, sourceTab)
		skinFBoHBags(FBoH.bagViews[#(FBoH.bagViews)])
	end)

	if FBoH.bagViews then
		for _, v in pairs(FBoH.bagViews) do
			skinFBoHBags(v)
		end
	end

-->>--	Configure Frame
	self:keepFontStrings(FBoH_Configure)
	self:moveObject(FBoH_Configure_CloseButton, "-", 3, nil, nil)
	self:skinEditBox(FBoH_Configure_Base_NameEdit, {9})
	self:moveObject(FBoH_Configure_Base_NameEdit, nil, nil, "+", 5)
	for _, v in pairs({ "_Left", "_Right" }) do
		for i = 1, 2 do
			local cframe = "FBoH_Configure_Frame"..i..v
			local frameObj = _G[cframe]
			local scrollObj = _G[cframe.."_Scroll"]
			self:keepFontStrings(frameObj)
			self:removeRegions(scrollObj)
			self:skinScrollBar(scrollObj)
			self:applySkin(frameObj)
		end
	end
	self:applySkin(FBoH_Configure)

-->>--	Configure Tabs
	for i = 1, 2 do
		local tabObj = _G["FBoH_ConfigureTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabObj)
			else self:setInactiveTab(tabObj) end
		else
			self:applySkin(tabObj)
		end
		if i == 1 then
			self:moveObject(tabObj, "-", 15, "-", 1)
		else
			self:moveObject(tabObj, "+", 13, nil, nil)
		end
	end

	-- hook this to manage the tabs
	if self.db.profile.TexturedTab then
		self:SecureHook(FBoH_Configure, "ShowTab", function(this, tabID)
--			self:Debug("FBoH_C_ST:[%s, %s]", this, tabID)
			for i = 1, 2 do
				local tabObj = _G["FBoH_ConfigureTab"..i]
				if i == tabID then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end)
	end

end
