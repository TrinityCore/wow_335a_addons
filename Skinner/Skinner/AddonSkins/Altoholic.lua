if not Skinner:isAddonEnabled("Altoholic") then return end

function Skinner:Altoholic()

	self:skinEditBox{obj=AltoholicFrame_SearchEditBox, regs={9}}
	self:addSkinFrame{obj=AltoholicFrame, kfs=true, y1=-11}

-->>-- Message Box
	self:addSkinFrame{obj=AltoMsgBox, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

-->>--	Other Frames
	for _, v in pairs({"Activity", "Auctions", "BagUsage", "Containers", "Equipment", "GuildMembers", "GuildProfessions", "GuildBankTabs", "Mail", "Quests", "Recipes", "Reputations", "Search", "Skills", "Summary"}) do
		local rcmObj = _G["AltoholicFrame"..v.."RightClickMenu"]
		local sfObj = _G["AltoholicFrame"..v.."ScrollFrame"]
		if rcmObj then self:skinDropDown{obj=rcmObj} end
		self:skinScrollBar{obj=sfObj}
	end

-->>--	Tabbed Frames
	local obj
	-- Summary tab
	self:skinDropDown{obj=AltoholicTabSummary_SelectLocation}

	for i = 1, 9 do -- menu items
		obj = _G["AltoholicTabSummaryMenuItem"..i]
		if not obj then break end
		self:keepRegions(obj, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	for i = 1, 9 do -- sort headers
		obj = _G["AltoholicTabSummary_Sort"..i]
		if i == 1 then self:moveObject(obj, nil, nil, "+", 6) end
		if not obj then break end
		self:adjHeight{obj=obj, adj=3}
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		self:applySkin(obj)
	end
	-- skin minus/plus buttons
	for i = 1, 14 do
		self:skinButton{obj=_G["AltoholicFrameSummaryEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameActivityEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameBagUsageEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameGuildBankTabsEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameGuildBankTabsEntry"..i.."UpdateTab"]}
		self:skinButton{obj=_G["AltoholicFrameGuildMembersEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameGuildProfessionsEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameQuestsEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameRecipesEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameSkillsEntry"..i.."Collapse"], mp2=true}
	end
	self:skinButton{obj=AltoholicTabSummaryToggleView, mp2=true, plus=true}

	-- Characters tab
	self:skinDropDown{obj=AltoholicTabCharacters_SelectRealm}
	self:skinDropDown{obj=AltoholicTabCharacters_SelectChar}
	for i = 1, 9 do -- sort headers
		obj = _G["AltoholicTabCharacters_Sort"..i]
		if not obj then break end
		if i == 1 then self:moveObject(obj, nil, nil, "+", 6) end
		self:adjHeight{obj=obj, adj=3}
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		self:applySkin(obj)
	end
	-- Container View
	self:skinDropDown{obj=AltoholicFrameContainers_SelectContainerView}
	self:skinDropDown{obj=AltoholicFrameContainers_SelectRarity}
	-- Companions/Mounts View
	self:skinDropDown{obj=AltoholicFramePets_SelectPetView}
	self:makeMFRotatable(AltoholicFramePetsNormal_ModelFrame)
	-- Search Tab
	self:skinScrollBar{obj=AltoholicSearchMenuScrollFrame}
	self:skinEditBox{obj=AltoholicTabSearch_MinLevel, regs={9}}
	self:skinEditBox{obj=AltoholicTabSearch_MaxLevel, regs={9}}
	self:skinDropDown{obj=AltoholicTabSearch_SelectRarity}
	self:skinDropDown{obj=AltoholicTabSearch_SelectSlot}
	self:skinDropDown{obj=AltoholicTabSearch_SelectLocation}
	for i = 1, 20 do
		obj = _G["AltoholicTabSearchMenuItem"..i]
		if not obj then break end
		self:keepRegions(obj, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	for i = 1, 9 do
		obj = _G["AltoholicTabSearch_Sort"..i]
		if not obj then break end
		if i == 1 then self:moveObject(obj, nil, nil, "+", 4) end
		self:adjHeight{obj=obj, adj=2}
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		self:applySkin(obj)
	end
	-- GuildBank tab
	self:skinDropDown{obj=AltoholicTabGuildBank_SelectGuild}
	self:skinDropDown{obj=AltoholicTabGuildBank_DeleteGuildButton}
	for i = 1, 9 do
		obj = _G["AltoholicTabGuildBankMenuItem"..i]
		if not obj then break end
		self:keepRegions(obj , {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	-- Achievements tab, now a separate addon (r83)

-->>-- Tabs
	for i = 1, 9 do
		local tabObj = _G["AltoholicFrameTab"..i]
		if not tabObj then break end
		if i == 1 then
			self:moveObject(tabObj, nil, nil, "-", 4)
		else
			self:moveObject(tabObj, "+", 4, nil, nil)
		end
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabObj)
			else self:setInactiveTab(tabObj) end
		else self:applySkin(tabObj) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook(Altoholic.Tabs, "OnClick", function(this, ...)
			for i = 1, 9 do
				local tabObj = _G["AltoholicFrameTab"..i]
				if not tabObj then break end
				if i == AltoholicFrame.selectedTab then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end)
	end

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AltoTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(AltoTooltip, "OnShow", function(this)
			self:skinTooltip(AltoTooltip)
		end)
	end

-->>-- Account Sharing option menu panel (buttons and panels)
	-- make sure icons are visible by changing their draw layer
	AltoholicAccountSharingOptionsIconNever:SetDrawLayer("OVERLAY")
	AltoholicAccountSharingOptionsIconAsk:SetDrawLayer("OVERLAY")
	AltoholicAccountSharingOptionsIconAuto:SetDrawLayer("OVERLAY")
	self:skinScrollBar{obj=AltoholicFrameSharingClientsScrollFrame}
	self:addSkinFrame{obj=AltoholicFrameSharingClients}
	self:skinScrollBar{obj=AltoholicFrameSharedContentScrollFrame}
-->>-- SharedContent option menu panel
	self:skinButton{obj=AltoholicSharedContent_ToggleAll, mp2=true}
	self:addSkinFrame{obj=AltoholicFrameSharedContent}
	for i = 1, 10 do
		self:skinButton{obj=_G["AltoholicFrameSharedContentEntry"..i.."Collapse"], mp2=true}
	end

-->>-- Account Sharing frame
	self:skinEditBox{obj=AltoAccountSharing_AccNameEditBox, regs={9}}
	self:skinButton{obj=AltoAccountSharing_ToggleAll, mp2=true}
	self:skinEditBox{obj=AltoAccountSharing_AccTargetEditBox, regs={9}}
	self:skinScrollBar{obj=AltoholicFrameAvailableContentScrollFrame}
	for i = 1, 10 do
		self:skinButton{obj=_G["AltoholicFrameAvailableContentEntry"..i.."Collapse"], mp2=true}
	end
	self:addSkinFrame{obj=AltoholicFrameAvailableContent}
	self:addSkinFrame{obj=AltoAccountSharing}

end

function Skinner:Altoholic_Achievements()

	self:skinScrollBar{obj=AltoholicAchievementsMenuScrollFrame}
	for i = 1, 20 do
		obj = _G["AltoholicTabAchievementsMenuItem"..i]
		if not obj then break end
		self:keepRegions(obj , {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	self:skinScrollBar{obj=AltoholicFrameAchievementsScrollFrame}

end
