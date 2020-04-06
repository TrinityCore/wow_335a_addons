if not Skinner:isAddonEnabled("GupPet") then return end

function Skinner:GupPet()

	local gpIOFname = "GupPet_InterfaceOptionsFrame"
	local gpCM, gpCMtab = IsAddOnLoaded("GupPet_CollectMe") and true, GupPet_CollectMe_MainTab3 or nil, nil
	
	-- Options panel
	local gio = GUPPET_INTERFACE_OPTIONFRAME
	self:addSkinFrame{obj=gio.AutoCallCompanionFrame}
	self:addSkinFrame{obj=gio.IngameButtonFrame}
	self:addSkinFrame{obj=gio.ExtraFrame}
	self:addSkinFrame{obj=gio.PreviewFrame}
	self:addSkinFrame{obj=gio.MinimapButton}
	if self.uCls == "DRUID"
	or self.uCls == "SHAMAN"
	or self.uCls == "MAGE"
	or self.uCls == "DEATHKNIGHT"
	then
		self:addSkinFrame{obj=gio.ClassFrame}
	end
	self:addSkinFrame{obj=_G[gpIOFname.."Options"]}
	-- Help panel
	self:addSkinFrame{obj=gio.SlashFrame}
	self:addSkinFrame{obj=_G[gpIOFname.."Help"]}
	-- Mounts & Companions panel
	local gim = GUPPET_INTERFACE_MAINFRAME
	self:addSkinFrame{obj=gim.Aquatic.Frame}
	self:addSkinFrame{obj=gim.SlowGround.Frame}
	self:addSkinFrame{obj=gim.FastGround.Frame}
	self:addSkinFrame{obj=gim.MultiGround.Frame}
	self:addSkinFrame{obj=gim.SlowFly.Frame}
	self:addSkinFrame{obj=gim.FastFly.Frame}
	self:addSkinFrame{obj=gim.Companion.Frame}
	self:addSkinFrame{obj=_G[gpIOFname.."MountsCompanionsLocations"]}
	-->> Location Tabs (treat like buttons)
	for _, v in pairs{"Add", "Remove"} do
		local tabObj = _G[gpIOFname.."MountsCompanionsLocationsTab"..v]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, x1=6, y1=-3, x2=-6, y2=-3}
	end
	--<< Location Tabs
	self:addSkinFrame{obj=_G[gpIOFname.."MountsCompanionsMain"]}
	-->> Main Tabs
	local mainTabs = {"Aquatic", "Ground", "Fly", "Companion"}
	local updMainTabs
	if self.isTT then
		function updMainTabs(thisTab)
			for _, v in pairs(mainTabs) do
				local tabObj = _G[gpIOFname.."MountsCompanionsMainTab"..v]
				local tabSF = self.skinFrame[tabObj]
				self:setInactiveTab(tabSF)
				if thisTab == tabObj then self:setActiveTab(tabSF) end
			end
		end
	end
	for _, v in pairs(mainTabs) do
		local tabObj = _G[gpIOFname.."MountsCompanionsMainTab"..v]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=-6}
		if self.isTT then
			local tabSF = self.skinFrame[tabObj]
			self:setInactiveTab(tabSF)
			if v == "Ground" then self:setActiveTab(tabSF) end -- default tab
			self:SecureHookScript(tabObj, "OnClick", function(this)
				updMainTabs(this)
			end)
		end
	end
	--<< Main Tabs
	self:addSkinFrame{obj=_G[gpIOFname.."MountsCompanions"]}
	-- CollectMe panel
	if gpCM then
		self:SecureHook("GupPet_CollectMe_Interface", function()
			local gcim = GUPPET_CN_INTERFACE_MAINFRAME
			self:glazeStatusBar(UnknownDataStatusBar, 0)
			self:getChild(UnknownDataStatusBar, 1):Hide() -- child button border
			self:skinSlider{obj=UnknownDataContainerScrollBar}
			UnknownDataContainerScrollBarBorder:SetBackdrop(nil)
			self:addSkinFrame{obj=gcim.Data.Frame}
			self:addSkinFrame{obj=gcim.Filter, y2=-2}
			self:addSkinFrame{obj=gcim.GameTooltip}
			self:Unhook("GupPet_CollectMe_Interface")
		end)
		self:addSkinFrame{obj=GupPet_CollectMe_Main}
		self:addSkinFrame{obj=GupPet_CollectMe_MainMain}
		-- Tabs
		local cmTabs = {"Mount", "Companion"}
		local updCMTabs
		if self.isTT then
			function updCMTabs(thisTab)
				for _, v in pairs(cmTabs) do
					local tabObj = _G["GupPet_CollectMe_MainMainTab"..v]
					local tabSF = self.skinFrame[tabObj]
					self:setInactiveTab(tabSF)
					if thisTab == tabObj then self:setActiveTab(tabSF) end
				end
			end
		end
		for _, v in pairs(cmTabs) do
			local tabObj = _G["GupPet_CollectMe_MainMainTab"..v]
			self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
			self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=-6}
			if self.isTT then
				local tabSF = self.skinFrame[tabObj]
				self:setInactiveTab(tabSF)
				if v == "Mount" then self:setActiveTab(tabSF) end -- default tab
				self:SecureHookScript(tabObj, "OnClick", function(this)
					updCMTabs(this)
				end)
			end
		end
		self:addSkinFrame{obj=GupPet_CollectMe_Where}
		self:addSkinFrame{obj=GupPet_CollectMe_Known}
		self:addSkinFrame{obj=GupPet_CollectMe_Preview}
	end
	-- Pet preview frame
	self:addSkinFrame{obj=GupPet_Preview}
	-- Icon popup frame
	self:addSkinFrame{obj=GupPet_IconPopupFrameDatafield}
	self:skinSlider{obj=GupPet_IconPopupScrollFrameScrollBar}--, size=2}
	GupPet_IconPopupScrollFrameScrollBarBorder:SetBackdrop(nil)
	self:addSkinFrame{obj=GupPet_IconPopupFrame}
	-- Tabs
	for i = 1, 4 do
		local tabObj = _G["GupPet_IconPopupFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=-6}
	end
	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("GupPet_IconPopupFrame_TabClick",function()
			for i = 1, 4 do
				local tabName = "GupPet_IconPopupFrameTab"..i
				local tabSF = self.skinFrame[_G[tabName]]
				if GupPet_Interface_GetSelected("IconTabs") == tabName then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	-- Main options frame
	GupPet_InterfaceOptionsFrameHeader:Hide()
	self:moveObject{obj=GupPet_InterfaceOptionsFrameHeaderText, y=-6}
	GupPet_InterfaceOptionsFrameVersionHeader:Hide()
	self:moveObject{obj=GupPet_InterfaceOptionsFrameVersionHeaderText, y=-6}
	self:skinAllButtons{obj=GupPet_InterfaceOptionsFrame, y1=1, y2=-3}
	self:addSkinFrame{obj=GupPet_InterfaceOptionsFrame, kfs=true, np=true}
-->>-- Tabs on Options Menu frame
	for i = 1, 3 do
		local tabObj = _G["GupPet_InterfaceOptionsFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=-6}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
		-- CollectMe
		if gpCM then
			self:keepRegions(gpCMtab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
			self:addSkinFrame{obj=gpCMtab, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=-6}
			self:setInactiveTab(self.skinFrame[gpCMtab])
		end
	end
	-- N.B. Tab 4, Close, is really a button
	self:keepRegions(GupPet_InterfaceOptionsFrameTab4, {7, 8}) -- N.B. region 7 is text, 8 is highlight
	self:addSkinFrame{obj=GupPet_InterfaceOptionsFrameTab4, ft=ftype, x1=6, y1=-3, x2=-6, y2=-3}
	if self.isTT then
		self:SecureHook("GupPet_Interface_Show", function(type, option, frame)
			if option == "Show" then
				local ltr = strsub(frame:GetName(), 29, 29) -- get 1st letter after common frame name
--				self:Debug("GP_I_S: [%s, %s, %s, %s]", type, option, frame, ltr)
				for i = 1, 3 do
					local tabObj = _G["GupPet_InterfaceOptionsFrameTab"..i]
					local tabSF = self.skinFrame[tabObj]
					self:setInactiveTab(tabSF)
					if i == 1 and ltr == "O"
					or i == 2 and ltr == "M"
					or i == 3 and ltr == "H"
					then self:setActiveTab(tabSF)
					end
				end
				-- CollectMe
				if gpCM then
					if frame == GupPet_CollectMe_Main then
						self:setActiveTab(self.skinFrame[gpCMtab])
					else
						self:setInactiveTab(self.skinFrame[gpCMtab])
					end
				end
			end
		end)
	end
	
end
