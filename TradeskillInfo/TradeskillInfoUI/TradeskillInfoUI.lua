TradeskillInfoUI = LibStub("AceAddon-3.0"):NewAddon("TradeskillInfoUI", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeskillInfoUI")

TradeskillInfoUI.version = GetAddOnMetadata("TradeskillInfoUI", "Version")
TradeskillInfoUI.date = string.sub("$Date: 2008-11-05 16:45:52 +0200 (Wed, 05 Nov 2008) $", 8, 17);


TradeskillInfoUI.cons = {};
TradeskillInfoUI.cons.skillsDisplayed = 16;
TradeskillInfoUI.cons.maxSkillReagents = 8;
TradeskillInfoUI.cons.skillHeight = 16;
TradeskillInfoUI.cons.strata = { "LOW", "MEDIUM", "HIGH" };

TradeskillInfoUI.options = {};
TradeskillInfoUI.options.buttons = {
	["TradeskillInfoOpposingButton"] = { text = L["Opposing"], var = "ShowOpposing", tooltip=L["Include recipes from opposing faction"] },
	["TradeskillInfoNameButton"] = { text = L["Name"], var = "SearchName", tooltip=L["Search for name"]},
	["TradeskillInfoReagentButton"] = { text = L["Reagent"], var = "SearchReagent", tooltip=L["Search for reagents"]},
};

--UIPanelWindows["TradeskillInfoFrame"] =	{ area = "right", pushable = 3 };

TradeskillInfoUI.vars = {};
TradeskillInfoUI.vars.selectionIndex = 2;
TradeskillInfoUI.vars.searchResult = {};
TradeskillInfoUI.vars.availability = {
	L["Player known"],
	L["Player can learn"],
	L["Player will be able to learn"],
	L["Alt known"],
	L["Alt can learn"],
	L["Alt will be able to learn"],
	L["Unavailable"],
};
TradeskillInfoUI.vars.faction = {
	L["Neutral"],
	L["Alliance"],
	L["Horde"],
};
-- 0123456789ABCDEF
-- 1  1   1   1   1
TradeskillInfoUI.vars.TradeSkillTypeColor = {
	["playerknown"] = { r = 1.00, g = 1.00, b = 1.00 }, -- ffffff
	["playerlearn"] = { r = 0.25, g = 1.00, b = 0.25 }, -- 33ff33
	["playerhigh"] = { r = 1.00, g = 0.75, b = 0.25 }, -- ff7733
	["altknown"] = { r = 0.75, g = 0.75, b = 0.75 },
	["altlearn"] = { r = 0.00, g = 0.75, b = 0.00 },
	["althigh"] = { r = 0.75, g = 0.50, b = 0.00 },
	["unavailable"] = { r = 1.00, g = 0.00, b = 0.00 },
	["header"]	= { r = 1.00, g = 0.82, b = 0 },
};

function TradeskillInfoUI:OnInitialize()
	local dbDefaults = {
		profile = {
			tradeskills = {['A']=true,['B']=true,['D']=true,['E']=true,['J']=true,['L']=true,['T']=true,['W']=true,['X']=true,['Y']=true,['I']=true},
			expanded = {['A']=true,['B']=true,['D']=true,['E']=true,['J']=true,['L']=true,['T']=true,['W']=true,['X']=true,['Y']=true,['I']=true},
			availability = {true,true,true,true,true,true,true},
			ShowOpposing = false,
			SearchName = true,
			SearchReagent = true,
		}
	}
	self.db = LibStub("AceDB-3.0"):New("TradeskillInfoUIDB", dbDefaults)
end

function TradeskillInfoUI:OnEnable()
	if oSkin and oSkin.applySkin then
		oSkin:applySkin(TradeskillInfoFrame);
	elseif Skinner and Skinner.applySkin then
		Skinner:removeRegions(TradeskillInfoAvailabilityDropDown);
		Skinner:removeRegions(TradeskillInfoTradeskillsDropDown);
		Skinner:removeRegions(TradeskillInfoListScrollFrame);
		Skinner:skinScrollBar(TradeskillInfoListScrollFrame);
		Skinner:removeRegions(TradeskillInfoDetailScrollFrame);
		Skinner:skinScrollBar(TradeskillInfoDetailScrollFrame);

		Skinner:applySkin(TradeskillInfoFrame);
	end
	TradeskillInfoKnown:ClearAllPoints()
	TradeskillInfoKnown:SetPoint("TOPLEFT", TradeskillInfoRecipe, "BOTTOMLEFT",0,-3)
end

function TradeskillInfoUI:Frame_Show()
	CloseDropDownMenus();
	TradeskillInfoTradeskillsDropDown:Hide();
	TradeskillInfoTradeskillsDropDown:Show();
	TradeskillInfoAvailabilityDropDown:Hide();
	TradeskillInfoAvailabilityDropDown:Show();
	TradeskillInfoDetailScrollFrameScrollBar:Hide();
	TradeskillInfoDetailScrollFrameScrollBarScrollDownButton:Hide();
	TradeskillInfoDetailScrollFrameScrollBarScrollUpButton:Hide();
	TradeskillInfoDetailScrollFrameScrollBarThumbTexture:Hide();
	TradeskillInfoDetailScrollFrameTop:Hide();
	TradeskillInfoDetailScrollFrameBottom:Hide();

	for key,val in pairs(self.options.buttons) do
		local button = getglobal(key);
		button:SetText(val.text);
		if val.tooltip then
			button.tooltipText = val.tooltip;
		end
		if self.db.profile[val.var] then
			button:LockHighlight();
		else
			button:UnlockHighlight();
		end
	end

	self:UpdateFramePosition();
	self:UpdateFrameStrata()
	ShowUIPanel(TradeskillInfoFrame);

	self:RegisterMessage("TradeskillInfo_Update", "OnTradeskillInfoUpdate")

	FauxScrollFrame_SetOffset(TradeskillInfoListScrollFrame, 0);
	TradeskillInfoListScrollFrameScrollBar:SetMinMaxValues(0, 0);
	TradeskillInfoListScrollFrameScrollBar:SetValue(0);
	self:Search();
	self:Frame_SetSelection(TradeskillInfoUI.vars.selectionIndex);
	self:Frame_Update();
end

function TradeskillInfoUI:Frame_Hide()
	self:UnregisterEvent("TradeskillInfo_Update")
	HideUIPanel(TradeskillInfoFrame);
end

function TradeskillInfoUI:Frame_Toggle()
	if TradeskillInfoFrame:IsVisible() then
		TradeskillInfoUI:Frame_Hide()
	else
		TradeskillInfoUI:Frame_Show()
	end
end

function TradeskillInfoUI:UpdateFramePosition()
	TradeskillInfoFrame:SetScale(TradeskillInfo.db.profile["UIScale"]);
	if TradeskillInfo.db.profile.SavePosition then
		local s = TradeskillInfoFrame:GetEffectiveScale();
		if TradeskillInfo.db.profile.PositionX and TradeskillInfo.db.profile.PositionY then
			TradeskillInfoFrame:ClearAllPoints();
			TradeskillInfoFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",
						TradeskillInfo.db.profile.PositionX / s, TradeskillInfo.db.profile.PositionY / s);
		end
		if TradeskillInfo.db.profile.Width then
			TradeskillInfoFrame:SetWidth(TradeskillInfo.db.profile.Width)
		end
		if TradeskillInfo.db.profile.Height then
			TradeskillInfoFrame:SetHeight(TradeskillInfo.db.profile.Height)
		end
	end
end

function TradeskillInfoUI:SetUiScale(scale)
	-- rescale main UI frame
	local s = TradeskillInfoFrame:GetEffectiveScale()
	local x = TradeskillInfoFrame:GetLeft() * s
	local y = TradeskillInfoFrame:GetTop() * s
	local w = TradeskillInfoFrame:GetWidth()
	local h = TradeskillInfoFrame:GetHeight()
	TradeskillInfoFrame:SetScale(scale)
	s = TradeskillInfoFrame:GetEffectiveScale()
	TradeskillInfoFrame:ClearAllPoints()
	TradeskillInfoFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x/s, y/s)
	TradeskillInfoFrame:SetWidth(w)
	TradeskillInfoFrame:SetHeight(h)
end

function TradeskillInfoUI:SaveFramePosition()
	if TradeskillInfo.db.profile.SavePosition then
		local s = TradeskillInfoFrame:GetEffectiveScale()
		TradeskillInfo.db.profile.PositionX = TradeskillInfoFrame:GetLeft() * s
		TradeskillInfo.db.profile.PositionY = TradeskillInfoFrame:GetTop() * s
		TradeskillInfo.db.profile.Width = TradeskillInfoFrame:GetWidth()
		TradeskillInfo.db.profile.Height = TradeskillInfoFrame:GetHeight()
	end
end

function TradeskillInfoUI:UpdateFrameStrata()
	if TradeskillInfo.db.profile.FrameStrata then
		TradeskillInfoFrame:SetFrameStrata(self.cons.strata[TradeskillInfo.db.profile.FrameStrata]);
	end
end

function TradeskillInfoUI:OnTradeskillInfoUpdate()
	self:Search();
	local selectionIndex
	if self.vars.selectionIndex == 0 then
		selectionIndex = self:GetFirstTradeSkill();
	else
		selectionIndex = self.vars.selectionIndex;
	end
	if ( self.vars.selectionIndex > 1 and self.vars.selectionIndex <= self:GetNumTradeSkills() ) then
		self:Frame_SetSelection(selectionIndex);
		if selectionIndex < FauxScrollFrame_GetOffset(TradeskillInfoListScrollFrame) then
			FauxScrollFrame_SetOffset(TradeskillInfoListScrollFrame, selectionIndex-1);
			TradeskillInfoListScrollFrameScrollBar:SetValue((selectionIndex-1)*TradeskillInfoUI.cons.skillHeight);
		elseif selectionIndex > (FauxScrollFrame_GetOffset(TradeskillInfoListScrollFrame) + TradeskillInfoUI.cons.skillsDisplayed) then
			FauxScrollFrame_SetOffset(TradeskillInfoListScrollFrame, selectionIndex-TradeskillInfoUI.cons.skillsDisplayed);
			TradeskillInfoListScrollFrameScrollBar:SetValue((selectionIndex-TradeskillInfoUI.cons.skillsDisplayed)*TradeskillInfoUI.cons.skillHeight);
		end
	else
		FauxScrollFrame_SetOffset(TradeskillInfoListScrollFrame, 0);
		TradeskillInfoListScrollFrameScrollBar:SetValue(0);
	end
	self:Frame_Update();
end

----------------------------------------------------------------------
--- Draw Tradeskills List
----------------------------------------------------------------------

TradeskillInfoUI.vars.numSkillButtons = 0

local function getSkillButton(i)
	local skillButton = getglobal("TradeskillInfoSkill"..i)
	if not skillButton then
		-- Create a new button. Assume button (i-1) was already created
		skillButton = CreateFrame("Button", "TradeskillInfoSkill"..i, TradeskillInfoListFrame, "TradeskillInfoSkillButtonTemplate")
	skillButton:SetPoint("TOPLEFT", "TradeskillInfoSkill"..(i-1), "BOTTOMLEFT")
		skillButton:SetFrameLevel(TradeskillInfoListFrame:GetFrameLevel() + 1)
		skillButton:SetNormalTexture("");
		skillButton:SetText("");
	end

	TradeskillInfoUI.vars.numSkillButtons = math.max(i, TradeskillInfoUI.vars.numSkillButtons)

	return skillButton
end

function TradeskillInfoUI:Frame_Update()
	local self = TradeskillInfoUI
	if self.vars.coUpdate_Frame and coroutine.status(self.vars.coUpdate_Frame) ~= "dead" then
		-- Tell the running coroutine to restart drawing
		self.vars.coUpdate_FrameRestart = true
		-- We'll redraw. No need to wait for the operation to complete properly.
		coroutine.resume(self.vars.coUpdate_Frame)
		return
	end
	self.vars.coUpdate_Frame = coroutine.create(self.CoroutineFrame_Update)
	if self.vars.coUpdate_Frame then
		local status, err = coroutine.resume(self.vars.coUpdate_Frame, self)
		if not status then
			self:Print("Cannot update the recipe list - " .. (err or "<no reason>"))
		end
	else
		self:Print("Cannot update the recipe list")
	end
end

function TradeskillInfoUI:CoroutineFrame_Update()
	local finished = false
	repeat
		self:DoFrameUpdate()

		-- If we need to restart ... go back to the beginning of loop
		finished = not self.vars.coUpdate_FrameRestart
		self.vars.coUpdate_FrameRestart = false
	until finished
end

function TradeskillInfoUI:DoFrameUpdate()
	-- Draw frame with tradeskill info
	local self = TradeskillInfoUI;
	local numTradeSkills = self:GetNumTradeSkills();
	local skillOffset = FauxScrollFrame_GetOffset(TradeskillInfoListScrollFrame);
	if ( numTradeSkills == 0 ) then
		TradeskillInfoSkillName:Hide();
		TradeskillInfoSkillIcon:Hide();
		TradeskillInfoRequirementLabel:Hide();
		TradeskillInfoRequirementText:SetText("");
		TradeskillInfoDescription:SetText("");
		TradeskillInfoRecipe:SetText("");
		TradeskillInfoKnown:SetText("");
		TradeskillInfoCollapseAllButton:Disable();
		for i=1, TradeskillInfoUI.cons.maxSkillReagents, 1 do
			getglobal("TradeskillInfoReagent"..i):Hide();
		end
	else
		TradeskillInfoCollapseAllButton:Enable();
	end

	-- ScrollFrame update
	local buttonCount = TradeskillInfoListScrollFrame:GetHeight() / TradeskillInfoUI.cons.skillHeight
	buttonCount = math.floor(buttonCount)

	FauxScrollFrame_Update(TradeskillInfoListScrollFrame, numTradeSkills, buttonCount, TradeskillInfoUI.cons.skillHeight, nil, nil, nil, TradeskillInfoHighlightFrame, 293, 316 );

	--
	-- First adjust the visibility of buttons
	--

	TradeskillInfoHighlightFrame:Hide();
	for i=1, buttonCount do
		local skillButton = getSkillButton(i)
		skillButton:Show()
	end

	for i = buttonCount + 1, TradeskillInfoUI.vars.numSkillButtons do
		local skillButton = getSkillButton(i)
		skillButton:Hide()
	end

	-- If we are still resizing, stop here
	if TradeskillInfoFrame.isResizing then return end

	TradeskillInfoHighlightFrame:Hide();
	for i=1, buttonCount do
		local skillButton = getSkillButton(i)
		skillButton:SetText("***");
	end
	for i=1, buttonCount do
		local skillIndex = i + skillOffset;
		local skillButton = getSkillButton(i)
		local skillButtonText = getglobal(skillButton:GetName() .. "Text")
		-- Adjust width of buttons and their texts
		skillButton:SetWidth(TradeskillInfoListScrollFrame:GetWidth()-34)
		skillButtonText:SetWidth(TradeskillInfoListScrollFrame:GetWidth()-34)
		if ( skillIndex <= numTradeSkills ) then
			local skillName, skillType, isExpanded = self:GetTradeSkillInfo(skillIndex)
			-- If we got ???? or an ID instead of a skill name ...
			if skillName == "????" or
			   string.match(skillName, "-?%d+") == skillName then
				-- ... update the local cache ...
				self:UpdateCacheIndex(self.vars.searchResult[skillIndex], self.vars.coUpdate_Frame)
				-- .. If we need to restart drawing, return early. We'll be called again ...
				if self.vars.coUpdate_FrameRestart then
					return
				end
				-- ... otherwise try to obtain the infgo again. It should be there now.
				skillName, skillType, isExpanded = self:GetTradeSkillInfo(skillIndex);
			end
			skillType = self:GetTradeSkillAvailability(skillIndex);
			-- Set button widths if scrollbar is shown or hidden
			if ( TradeskillInfoListScrollFrame:IsVisible() ) then
				skillButton:SetWidth(293);
			else
				skillButton:SetWidth(323);
			end
			local color = self.vars.TradeSkillTypeColor[skillType];
			if ( color ) then
				if (skillButtonText) then skillButtonText:SetVertexColor(color.r, color.g, color.b) end
			end

			skillButton:SetID(skillIndex);
			skillButton:Show();
			local skillButtonHighlight = getglobal(skillButton:GetName() .. "Highlight")
			-- Handle headers
			if ( skillType == "header" ) then
				skillButton:SetText(skillName);
				if ( isExpanded ) then
					skillButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				else
					skillButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				end
				skillButtonHighlight:SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
				skillButton:UnlockHighlight();
			else
				if ( not skillName ) then
					return;
				end
				skillButton:SetNormalTexture("");
				skillButtonHighlight:SetTexture("");
				skillButton:SetText(" "..skillName);

				-- Place the highlight and lock the highlight state
				if ( self.vars.selectionIndex == skillIndex ) then
					TradeskillInfoHighlightFrame:SetPoint("TOPLEFT", "TradeskillInfoSkill"..i, "TOPLEFT", 0, 0);
					TradeskillInfoHighlightFrame:Show();
					skillButton:LockHighlight();
				else
					skillButton:UnlockHighlight();
				end
			end
		else
			skillButton:Hide();
		end
	end

	-- Set the expand/collapse all button texture
	local numHeaders = 0;
	local notExpanded = 0;
	for i=1, numTradeSkills, 1 do
		local skillName, skillType, isExpanded = self:GetTradeSkillInfo(i);
		if ( skillName and skillType == "header" ) then
			numHeaders = numHeaders + 1;
			if ( not isExpanded ) then
				notExpanded = notExpanded + 1;
			end
		end
	end
	-- If all headers are not expanded then show collapse button, otherwise show the expand button
	if ( notExpanded ~= numHeaders ) then
		TradeskillInfoCollapseAllButton.collapsed = nil;
		TradeskillInfoCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	else
		TradeskillInfoCollapseAllButton.collapsed = 1;
		TradeskillInfoCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	end
end

----------------------------------------------------------------------
--- Draw selected tradeskill info. Item + reagents
----------------------------------------------------------------------
function TradeskillInfoUI:Frame_SetSelection(id)
	if self.vars.coFrame_SetSelection and coroutine.status(self.vars.coFrame_SetSelection) ~= "dead" then
		-- Tell the coroutine to restart using a new ID
		self.vars.coFrame_SetSelectionNewId = id
		-- We're changing data. No need to wait for operation to complete properly.
		coroutine.resume(self.vars.coFrame_SetSelection)
		return
	end
	self.vars.coFrame_SetSelection = coroutine.create(self.CoroutineFrame_SetSelection)
	if self.vars.coFrame_SetSelection then
		local status, err = coroutine.resume(self.vars.coFrame_SetSelection, self, id)
		if not status then
			self:Print("Cannot update recipe details - " .. (err or "<no reason>"))
		end
	else
		self:Print("Cannot update the recipe details")
	end
end

function TradeskillInfoUI:CoroutineFrame_SetSelection(id)
	while id do
		self:DoFrameSetSelection(id)

		-- If we have an update id, then we probably returned early from
		-- DoFrameSetSelection(). We'll just need to call it with the updated id.
		id = self.vars.coFrame_SetSelectionNewId
		self.vars.coFrame_SetSelectionNewId = nil
	end
end

function TradeskillInfoUI:DoFrameSetSelection(id)
	if ( id > self:GetNumTradeSkills() ) then
		return;
	end
	-- Hide all reagents at start.
	-- When there is a cache update, misleading information appears on screen.
	for i=1, TradeskillInfoUI.cons.maxSkillReagents, 1 do
		local reagent = getglobal("TradeskillInfoReagent"..i);
		reagent:Hide();
		reagent.tooltip = nil;
		reagent.known = nil;
		reagent.link = nil;
		reagent.name = nil;
	end
	if id == 0 then
		TradeskillInfoSkillName:Hide();
		TradeskillInfoSkillIcon:Hide();
		TradeskillInfoSkillIcon.tooltip = nil;
		TradeskillInfoSkillIcon.known = nil;
		TradeskillInfoSkillIcon.link = nil;
		TradeskillInfoSkillIcon.name = nil;
		TradeskillInfoRequirementLabel:Hide();
		TradeskillInfoRequirementText:SetText("");
		TradeskillInfoDescription:SetText("");
		TradeskillInfoRecipe:SetText("");
		TradeskillInfoKnown:SetText("");
		return;
	end
	local skillName, skillType, isExpanded = self:GetTradeSkillInfo(id);
	TradeskillInfoHighlightFrame:Show();
	if ( skillType == "header" ) then
		TradeskillInfoHighlightFrame:Hide();
		if ( isExpanded ) then
			self:CollapseHeader(id);
		else
			self:ExpandHeader(id);
		end
		return;
	end
	self.vars.selectionIndex = id;
	skillType = self:GetTradeSkillAvailability(id);
	local color = self.vars.TradeSkillTypeColor[skillType];
	if ( color ) then
		TradeskillInfoHighlight:SetVertexColor(color.r, color.g, color.b);
	end

	TradeskillInfoSkillName:SetText(skillName);
	TradeskillInfoSkillName:Show();
	local skillTexture,skillLink,skillItemString = self:GetTradeSkillIcon(id)
	if not skillLink then
		-- ... update the local cache ...
		self:UpdateCacheIndex(self.vars.searchResult[id], self.vars.coFrame_SetSelection)
		-- ... if we need to draw a new selection, return early. We'll be called again ...
		if self.vars.coFrame_SetSelectionNewId then
			return
		end
		-- ... therwise try to get info again. It should succeed
		skillTexture,skillLink,skillItemString = self:GetTradeSkillIcon(id)
	end
	TradeskillInfoSkillIcon:SetNormalTexture(skillTexture);
	TradeskillInfoSkillIcon.tooltip = skillItemString;
	TradeskillInfoSkillIcon.known = skillLink ~= nil;
	TradeskillInfoSkillIcon.link = skillLink;
	TradeskillInfoSkillIcon.name = skillName;
	TradeskillInfoSkillIcon.id = id; --self.vars.searchResult[id];
	TradeskillInfoSkillIcon:Show();

	local numMade = self:GetTradeSkillNumMade(id);
	if numMade and numMade > 1 then
		TradeskillInfoSkillIconCount:SetText(numMade);
	else
		TradeskillInfoSkillIconCount:SetText("");
	end

	local skill,spec,level = self:GetTradeSkillSkillLevel(id)
	local skillName = self:GetTradeSkillName(skill);
	local specName = self:GetTradeSkillSpecializationName(spec);
	TradeskillInfoRequirementLabel:Show();
	if specName then
		TradeskillInfoRequirementText:SetText(skillName.."("..level.."), "..specName);
	else
		TradeskillInfoRequirementText:SetText(skillName.."("..level..")");
	end

	local skillDescription = self:GetTradeSkillDescription(id);
	if skillDescription then
		TradeskillInfoDescription:SetText(skillDescription);
	else
		TradeskillInfoDescription:SetText("");
	end

	local height, skillSource = self:GetTradeSkillRecipe(id);
	-- hack to get correct height for simplehtml frame
	if skillSource then
		TradeskillInfoRecipe1:SetText(skillSource);
	else
		TradeskillInfoRecipe1:SetText("");
	end
		height = TradeskillInfoRecipe1:GetHeight()
		-- end hack
	if not height or height==0 then height = 1 end
	TradeskillInfoRecipe:SetHeight(tonumber(height));
	if skillSource then
		TradeskillInfoRecipe:SetText(skillSource);
	else
		TradeskillInfoRecipe:SetText("");
	end

	local skillAvailable = self:GetTradeSkillBy(id);
	if skillAvailable then
		TradeskillInfoKnown:SetText(skillAvailable);
	else
		TradeskillInfoKnown:SetText("");
	end

	local extraData =self:GetTradeSkillExtraData(id)
	if extraData then
		TradeskillInfoExtraData:SetText(extraData)
		local _, height = TradeskillInfoExtraData:GetFont()
	else
		TradeskillInfoExtraData:SetText("")
	end
	-- Reagents
	local numReagents = self:GetTradeSkillNumReagents(id);
	for i=1, numReagents, 1 do
		local reagentName, reagentTexture, reagentCount, reagentLink, reagentItemString = self:GetTradeSkillReagentInfo(i)

		if not reagentLink then
			-- ... update the local cache ...
			self:UpdateCacheIndex(self:GetTradeSkillReagentId(i), self.vars.coFrame_SetSelection)
			-- ... if we need to draw a new selection, return early. We'll be called again ...
			if self.vars.coFrame_SetSelectionNewId then
				return
			end
			-- ... therwise try to get info again. It should succeed.
			-- We need to call GetTradeSkillNumReagents() to obtain new local cache.
			self:GetTradeSkillNumReagents(id)
			reagentName, reagentTexture, reagentCount, reagentLink, reagentItemString = self:GetTradeSkillReagentInfo(i)
		end

		local reagent = getglobal("TradeskillInfoReagent"..i)
		local name = getglobal("TradeskillInfoReagent"..i.."Name");
		local count = getglobal("TradeskillInfoReagent"..i.."Count");
		if ( not reagentName or not reagentTexture ) then
			reagent:Hide();
		else
			reagent:Show();
			SetItemButtonTexture(reagent, reagentTexture);
			reagent.tooltip = reagentItemString;
			reagent.known = reagentLink ~= nil;
			reagent.link = reagentLink;
			reagent.name = reagentName;
			name:SetText(reagentName);
			SetItemButtonTextureVertexColor(reagent, 1.0, 1.0, 1.0);
			name:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			count:SetText(reagentCount);
		end
	end

	local botLeftIdx = math.floor((numReagents-1)/2)*2 + 1

	TradeskillInfoExtraData:SetPoint("TOPLEFT",
	                                 "TradeskillInfoReagent" .. botLeftIdx,
	                                 "BOTTOMLEFT",
	                                 3, -6)

	-- Fix for Enchants. Show tooltip if all reagents are known
	if skillLink == nil and self:IsSafeToShowTooltip(id) then
		TradeskillInfoSkillIcon.known = true;
	end
	TradeskillInfoDetailScrollFrame:UpdateScrollChildRect();
end

----------------------------------------------------------------------
--- Called after a forced item lookup to update icons
----------------------------------------------------------------------
function TradeskillInfoUI:Frame_Refresh()
	self:Frame_SetSelection(self.vars.selectionIndex);
end

----------------------------------------------------------------------
--- Clicked tradeskill name
----------------------------------------------------------------------
function TradeskillInfoUI:SkillButton_OnClick(frame, button)
	if ( button == "LeftButton" ) then
		if IsShiftKeyDown() and ChatFrameEditBox:IsVisible() then
			self:PasteRecipie(frame:GetID());
		else
			self:Frame_SetSelection(frame:GetID());
			self:Frame_Update();
		end
	end
end

----------------------------------------------------------------------
--- Click on vendor coordinates
----------------------------------------------------------------------
function TradeskillInfoUI:RecipeSource_OnHyperlinkClick(frame, link)
	local zone,x,y,note = link:match("^tsicoord:([^:]*):([^:]+):([^:]+):(.*)")
	x=tonumber(x)
	y=tonumber(y)
	if ( TomTom ) and ( type(TomTom.AddZWaypoint) == "function" ) then
		if zone ~= "" then
			local c = GetCurrentMapContinent();
			local z = GetCurrentMapZone();
			local contKey, contVal, zoneKey, zoneVal;
			local continentNames = { GetMapContinents() } ;
			for contKey, contVal in pairs(continentNames) do
				local zoneNames= { GetMapZones(contKey) };
					for zoneKey, zoneVal in pairs(zoneNames) do
						if zone == zoneVal then
							c = contKey;
							z = zoneKey;
						end
					end
			end
			TomTom:AddZWaypoint(c, z, x, y, note)
		else
			TomTom:AddWaypoint(x, y, note)
		end
	elseif ( Cartographer_Waypoints ) and ( type(Cartographer_Waypoints.AddWaypoint) == "function" ) then
		Cartographer_Waypoints:AddWaypoint(NotePoint:new(zone, x/100, y/100, note))

	end
end

----------------------------------------------------------------------
--- Click on item or reagent icon
----------------------------------------------------------------------
function TradeskillInfoUI:ReagentIcon_OnClick(frame, button)
	if self:Item_OnClick(frame, button) then return end
	if ( button == "LeftButton" ) then
		if ( IsControlKeyDown() ) then
			DressUpItemLink(frame.tooltip);
		elseif IsShiftKeyDown() then
			if ChatFrameEditBox:IsVisible() then
				if frame.link then
					ChatFrameEditBox:Insert(frame.link);
				else
					ChatFrameEditBox:Insert(frame.name);
				end
			end
		elseif IsAltKeyDown() then
			if ChatFrameEditBox:IsVisible() then
				self:PasteRecipie(frame.id);
			end
		else
			TradeskillInfoUI:UpdateCacheItem(frame.tooltip)
		end
	elseif ( button == "RightButton" ) then
			if AuctionFrameBrowse and AuctionFrameBrowse:IsVisible() then
				BrowseName:SetText(frame.name)
				BrowseMinLevel:SetText("")
				BrowseMaxLevel:SetText("")
				AuctionFrameBrowse.selectedInvtype = nil
				AuctionFrameBrowse.selectedInvtypeIndex = nil
				AuctionFrameBrowse.selectedClass = nil
				AuctionFrameBrowse.selectedClassIndex = nil
				AuctionFrameBrowse.selectedSubclass = nil
				AuctionFrameBrowse.selectedSubclassIndex = nil
				AuctionFrameFilters_Update()
				IsUsableCheckButton:SetChecked(0)
				UIDropDownMenu_SetSelectedValue(BrowseDropDown, -1)
				AuctionFrameBrowse_Search()
				BrowseNoResultsText:SetText(BROWSE_NO_RESULTS)
			end
	end
end
function TradeskillInfoUI:Item_OnClick(frame, button)
	if not TradeskillInfo.db.profile.QuickSearch then return end
	if button == TradeskillInfo.vars.MouseButtons[TradeskillInfo.db.profile.SearchMouseButton] then
		local accept = true
		for i, func in ipairs(TradeskillInfo.vars.ShiftKeys) do
			if i == TradeskillInfo.db.profile.SearchShiftKey then
				accept = accept and func()
			else
				accept = accept and not func()
			end
		end

		if accept then
			local _,_,item = string.find(frame.tooltip,":(%d+):");
			self:SetSearchText("id="..item.." "..frame.name);
			self:Search_OnClick();
			return true;
		end
	end
end

----------------------------------------------------------------------
--- Show Reagent or Item tooltip on mouse over
----------------------------------------------------------------------
function TradeskillInfoUI:ShowReagentTooltip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");
	if frame.known then
		GameTooltip:SetHyperlink(frame.tooltip);
		CursorUpdate(frame)
	else
		GameTooltip:SetText(frame.name);
		GameTooltip:AddLine(L["Item not in local cache."]);
		GameTooltip:AddLine(L["Click to try to update local cache."]);
		GameTooltip:Show()
	end
end

function TradeskillInfoUI:CollapseAllButton_OnClick(frame)
	if (frame.collapsed) then
		frame.collapsed = nil;
		self:ExpandHeader(0);
	else
		frame.collapsed = true;
		TradeskillInfoListScrollFrameScrollBar:SetValue(0);
		self:CollapseHeader(0);
	end
end

----------------------------------------------------------------------
--- Sort Drop Down Menu functions
----------------------------------------------------------------------
function TradeskillInfoUI:SortDropDown_OnLoad()
	UIDropDownMenu_SetWidth(TradeskillInfoSortDropDown, 120);
end

function TradeskillInfoUI:SortDropDown_OnShow(frame)
	UIDropDownMenu_SetSelectedValue(frame, 1)
	UIDropDownMenu_Initialize(frame, TradeskillInfoUI.SortDropDown_Initialize);
	UIDropDownMenu_SetText(TradeskillInfoSortDropDown, L["Sort by"]);
end

local sortInfoCache = {}
local searchSortInitFunc = nil
local searchSortCleanFunc = nil
local searchSortSortFunc = nil

function TradeskillInfoUI:SetFuncSet(info)
	searchSortInitFunc = info.initfunc
	searchSortCleanFunc = info.cleanfunc
	searchSortSortFunc = info.sortfunc
end

function TradeskillInfoUI.SortDropDown_Initialize()
	-- Information for sorting the search results correctly.
	-- The caching is used to bring the sorting speed down to acceptable levels
	-- The weird way the caching is used is to make better use of arrays to minimize the
	-- garbage collection of arrays.
	local sortInfo = {
		{
			name = L["Difficulty"],
			initfunc = function(searchResult)
				local skill, spec, level, subgrp
				for i, v in ipairs(searchResult) do
					if type(v) == "string" then
						skill, spec, level, subgrp = v,"",-1,0
					else
						skill, spec, level = TradeskillInfo:GetCombineSkill(v);
						subgrp = TradeskillInfo:GetCombineEnchantId(v)
						if subgrp < 0 then subgrp = 2
						else subgrp = 1 end
					end
					if not sortInfoCache[v] then sortInfoCache[v] = {} end
					sortInfoCache[v].skill = skill
					sortInfoCache[v].spec = spec
					sortInfoCache[v].level = level
					sortInfoCache[v].subgrp = subgrp
				end
			end,
			cleanfunc = function()
				for _, v in pairs(sortInfoCache) do
					v.skill = nil
					v.spec = nil
					v.level = nil
					v.subgrp = nil
				end
			end,
			sortfunc = function(a,b)
				local ac, bc;
				ac = sortInfoCache[a].skill
				bc = sortInfoCache[b].skill
				if ac == bc then
					ac = sortInfoCache[a].spec
					bc = sortInfoCache[b].spec
				end
				if ac == bc then
					ac = sortInfoCache[a].subgrp
					bc = sortInfoCache[b].subgrp
				end
				if ac == bc then
					ac = sortInfoCache[a].level
					bc = sortInfoCache[b].level
				end
				if (ac < bc) then
					return true
				end
				return false
			end
		},
		{
			name = L["Name"],
			initfunc = function(searchResult)
				local skill, name, subgrp
				for i, v in ipairs(searchResult) do
					if type(v) == "string" then
						skill, name, subgrp = v, "", 0
					else
						skill = TradeskillInfo:GetCombineSkill(v)
						name = TradeskillInfo:GetCombineName(v)
						if not name then name = "" end
						subgrp = TradeskillInfo:GetCombineEnchantId(v)
						if subgrp < 0 then subgrp = 2
						else subgrp = 1 end
					end
					if not sortInfoCache[v] then sortInfoCache[v] = {} end
					sortInfoCache[v].skill = skill
					sortInfoCache[v].name = name
					sortInfoCache[v].subgrp = subgrp
				end
			end,
			cleanfunc = function()
				for _, v in pairs(sortInfoCache) do
					v.skill = nil
					v.name = nil
					v.subgrp = nil
				end
			end,
			sortfunc = function(a,b)
				local ac,bc
				ac = sortInfoCache[a].skill
				bc = sortInfoCache[b].skill
				if ac == bc then
					ac = sortInfoCache[a].subgrp
					bc = sortInfoCache[b].subgrp
				end
				if ac == bc then
					ac = sortInfoCache[a].name
					bc = sortInfoCache[b].name
				end
				bn = sortInfoCache[b].name

				if ac < bc then
					return true
				end
				return false
			end
		},
		{
			name = L["Auction Profit"],
			initfunc = function(searchResult)
				local skill, profit, subgrp
				for i, v in ipairs(searchResult) do
					if type(v) == "string" then
						skill, profit, subgrp = v, -1, 0
					else
						skill = TradeskillInfo:GetCombineSkill(v)
						profit = select(3,TradeskillInfo:GetCombineAuctioneerCost(v))
						if not profit then
							profit = select(3,TradeskillInfo:GetCombineCost(v))
						end
						subgrp = TradeskillInfo:GetCombineEnchantId(v)
						if subgrp < 0 then subgrp = 2
						else subgrp = 1 end
					end
					if not sortInfoCache[v] then sortInfoCache[v] = {} end
					sortInfoCache[v].skill = skill
					sortInfoCache[v].profit = profit
					sortInfoCache[v].subgrp = subgrp
				end
			end,
			cleanfunc = function()
				for _, v in pairs(sortInfoCache) do
					v.skill = nil
					v.profit = nil
					v.subgrp = nil
				end
			end,
			sortfunc = function(a,b)
				local ac,bc
				ac = sortInfoCache[a].skill
				bc = sortInfoCache[b].skill
				if ac == bc then
					ac = sortInfoCache[a].subgrp
					bc = sortInfoCache[b].subgrp
				end
				if ac == bc then
					ac = -sortInfoCache[a].profit
					bc = -sortInfoCache[b].profit
				end
				if ac < bc then
					return true
				end
				return false
			end,
		},
		{
			name = L["Vendor Profit"],
			initfunc = function(searchResult)
				local skill, profit, subgrp
				for i, v in ipairs(searchResult) do
					if type(v) == "string" then
						skill, profit, subgrp = v, -1, 0
					else
						skill = TradeskillInfo:GetCombineSkill(v)
						profit = select(3,TradeskillInfo:GetCombineCost(v))
						subgrp = TradeskillInfo:GetCombineEnchantId(v)
						if subgrp < 0 then subgrp = 2
						else subgrp = 1 end
					end
					if not sortInfoCache[v] then sortInfoCache[v] = {} end
					sortInfoCache[v].skill = skill
					sortInfoCache[v].profit = profit
					sortInfoCache[v].subgrp = subgrp
				end
			end,
			cleanfunc = function()
				for _, v in pairs(sortInfoCache) do
					v.skill = nil
					v.profit = nil
					v.subgrp = nil
				end
			end,
			sortfunc = function(a,b)
				local ac,bc
				ac = sortInfoCache[a].skill
				bc = sortInfoCache[b].skill
				if ac == bc then
					ac = sortInfoCache[a].subgrp
					bc = sortInfoCache[b].subgrp
				end
				if ac == bc then
					ac = -sortInfoCache[a].profit
					bc = -sortInfoCache[b].profit
				end
				if ac > bc then
					return true
				end
				return false
			end
		},
	}
	local self = TradeskillInfoUI
	local selectedValue = UIDropDownMenu_GetSelectedValue(TradeskillInfoSortDropDown)
	local info = {}
	for i,n in ipairs(sortInfo) do
		info.text = n.name
		info.value = i
		info.func = function(frame, self, val) self:SortDropDown_OnClick(frame, val) end
		info.arg1 = self
		info.arg2 = n
		if selectedValue == i then
			info.checked = true
		else
			info.checked = false
		end
		UIDropDownMenu_AddButton(info)
	end
	TradeskillInfoUI:SetFuncSet(sortInfo[1])
end

function TradeskillInfoUI:SortDropDown_OnClick(button, info)
	TradeskillInfoUI:SetFuncSet(info)
	UIDropDownMenu_SetSelectedValue(TradeskillInfoSortDropDown, button.value)
	self:SendMessage("TradeskillInfo_Update")
end

----------------------------------------------------------------------
--- Availablity Drop Down Menu functions
----------------------------------------------------------------------
function TradeskillInfoUI:AvailabilityDropDown_OnLoad()
	UIDropDownMenu_SetWidth(TradeskillInfoAvailabilityDropDown, 120);
	UIDropDownMenu_SetText(TradeskillInfoAvailabilityDropDown, L["Availability"]);
end

function TradeskillInfoUI:AvailabilityDropDown_OnShow(frame)
	UIDropDownMenu_Initialize(frame, TradeskillInfoUI.AvailabilityDropDown_Initialize);
	UIDropDownMenu_SetText(TradeskillInfoAvailabilityDropDown, L["Availability"]);
end

function TradeskillInfoUI.AvailabilityDropDown_Initialize()
	local self = TradeskillInfoUI;
	local info = {};
	for i,n in pairs(self.vars.availability) do
		info.text = n;
		info.value = i;
		info.checked = self.db.profile.availability[i];
		info.keepShownOnClick = 1;
		info.func = function(frame, self, val) self:AvailabilityDropDown_OnClick(val) end
		info.arg1 = self;
		info.arg2 = i;
		UIDropDownMenu_AddButton(info);
	end
end

function TradeskillInfoUI:AvailabilityDropDown_OnClick(val)
	self.db.profile.availability[val] = not self.db.profile.availability[val];
	self:SendMessage("TradeskillInfo_Update");
end

----------------------------------------------------------------------
--- Tradeskills Drop Down Menu functions
----------------------------------------------------------------------
function TradeskillInfoUI:TradeskillsDropDown_OnLoad()
	UIDropDownMenu_SetWidth(TradeskillInfoTradeskillsDropDown, 120);
	UIDropDownMenu_SetText(TradeskillInfoTradeskillsDropDown, L["Tradeskills"]);
end

function TradeskillInfoUI:TradeskillsDropDown_OnShow(frame)
	UIDropDownMenu_Initialize(frame, TradeskillInfoUI.TradeskillsDropDown_Initialize);
	UIDropDownMenu_SetText(TradeskillInfoTradeskillsDropDown, L["Tradeskills"]);
end

function TradeskillInfoUI.TradeskillsDropDown_Initialize()
	local self = TradeskillInfoUI;
	local info = {};
	for i,n in pairs(TradeskillInfo.vars.tradeskills) do
		info.text = n;
		info.value = i;
		info.checked = self.db.profile.tradeskills[i];
		info.keepShownOnClick = 1;
		info.func = function(frame, self, val) self:TradeskillsDropDown_OnClick(val) end
		info.arg1 = self;
		info.arg2 = i;
		UIDropDownMenu_AddButton(info);
	end
end

function TradeskillInfoUI:TradeskillsDropDown_OnClick(val)
	self.db.profile.tradeskills[val] = not self.db.profile.tradeskills[val];
	self:SendMessage("TradeskillInfo_Update");
end

----------------------------------------------------------------------
--- Search Button
----------------------------------------------------------------------
function TradeskillInfoUI:Search_OnClick()
	self:SendMessage("TradeskillInfo_Update");
end

function TradeskillInfoUI:ToggleButton(frame, button)
	local var = self.options.buttons[frame:GetName()].var
	if self.db.profile[var] then
		frame:UnlockHighlight();
		self.db.profile[var] = false;
	else
		frame:LockHighlight();
		self.db.profile[var] = true;
	end
	self:SendMessage("TradeskillInfo_Update");
end
----------------------------------------------------------------------
--- Reset Button
----------------------------------------------------------------------
function TradeskillInfoUI:Reset_OnClick()
	self:SetSearchText("");
	for i, _ in pairs(self.db.profile.tradeskills) do
		self.db.profile.tradeskills[i] = true
	end
	for i, _ in ipairs(self.db.profile.availability) do
		self.db.profile.availability[i] = true
	end
	self:SendMessage("TradeskillInfo_Update");
end

----------------------------------------------------------------------
--- UI support functions
----------------------------------------------------------------------

function TradeskillInfoUI:Search()
	local oldSelection = self.vars.searchResult[self.vars.selectionIndex];
	local searchText = string.lower(TradeskillInfoInputBox:GetText());
	local foundSkills = {};
	local searchArea = {};
	self.vars.searchResult = {};

	local _,_,searchItem = string.find(searchText,"^id=([-]?%d+)")
	if searchItem and searchItem ~= "" then
		searchItem = tonumber(searchItem);
		searchText = "";
		if self.db.profile.SearchName then
			TradeskillInfo:GetItemCrafted(searchItem,searchArea);
		end
		if self.db.profile.SearchReagent then
			TradeskillInfo:GetItemUsedIn(searchItem,searchArea);
		end
	else
		searchArea = TradeskillInfo.vars.combines;
	end

	for i in pairs(searchArea) do
		local skill = TradeskillInfo:GetCombineSkill(i);
		if self.db.profile.tradeskills[skill] then
			local player,alt = TradeskillInfo:GetCombineAvailability(i);
			if (self.db.profile.availability[1] and player==1) or
				 (self.db.profile.availability[2] and player==2) or
				 (self.db.profile.availability[3] and player==3) or
				 (self.db.profile.availability[4] and alt==1) or
				 (self.db.profile.availability[5] and alt==2) or
				 (self.db.profile.availability[6] and alt==3) or
				 (self.db.profile.availability[7] and player==0 and alt==0) then
				if self.db.profile.ShowOpposing or TradeskillInfo:GetCombineFactionAvailable(i) then
					local found = true;
					if searchText ~= "" then
						found = false;
						if self.db.profile.SearchName then
							skillName = TradeskillInfo:GetCombineName(i);
							if string.find(string.lower(skillName), searchText) then
								found = true;
							end
						end
						if self.db.profile.SearchReagent then
							local components = TradeskillInfo:GetCombineComponents(i);
							for _,c in ipairs(components) do
								if c and c.name and string.find(string.lower(c.name), searchText) then
									found = true;
									break;
								end
							end
							components = nil;
						end
					end
					if found then
						if not foundSkills[skill] then
							foundSkills[skill] = true;
							table.insert(self.vars.searchResult, skill);
						end
						if self.db.profile.expanded[skill] then
							table.insert(self.vars.searchResult, i);
						end
					end
				end
			end
		end
	end
	foundSkills = nil;

	-- Init cache for the sort
	searchSortInitFunc(self.vars.searchResult)
	-- sort search results
	table.sort(self.vars.searchResult, searchSortSortFunc)
	-- Cleanup cache
	searchSortCleanFunc()

	self.vars.selectionIndex = 0;
	if oldSelection then
		for i,v in ipairs(self.vars.searchResult) do
			if v == oldSelection then
				self.vars.selectionIndex = i;
				break;
			end
		end
	end
	if self.vars.selectionIndex == 0 then
		self.vars.selectionIndex = self:GetFirstTradeSkill();
	end
end

function TradeskillInfoUI:SetSearchText(text)
	TradeskillInfoInputBox:SetText(text);
end

function TradeskillInfoUI:GetNumTradeSkills()
	return table.getn(self.vars.searchResult);
end

function TradeskillInfoUI:GetFirstTradeSkill()
	for i,s in ipairs(self.vars.searchResult) do
		if type(s) ~= "string" then
			return i;
		end
	end
	return 0;
end

function TradeskillInfoUI:GetTradeSkillInfo(index)
	if not self.vars.searchResult[index] then return end
	local skillName
	if type(self.vars.searchResult[index]) == "string" then
		skillName = TradeskillInfo.vars.tradeskills[self.vars.searchResult[index]];
		local isExpanded = self.db.profile.expanded[self.vars.searchResult[index]];
		return skillName, "header", isExpanded;
	end
	skillName = TradeskillInfo:GetCombineName(self.vars.searchResult[index]);
	return skillName, "combine", true;
end

function TradeskillInfoUI:GetTradeSkillDescription(index)
	if not self.vars.searchResult[index] then return end
	return TradeskillInfo:GetCombineDescription(self.vars.searchResult[index]);
end

function TradeskillInfoUI:GetTradeSkillNumMade(index)
	if not self.vars.searchResult[index] then return end
	return TradeskillInfo:GetCombineYield(self.vars.searchResult[index]);
end

function TradeskillInfoUI:GetTradeSkillAvailability(index)
	if not self.vars.searchResult[index] then return end
	local skillType
	if type(self.vars.searchResult[index]) == "string" then
		return "header";
	end
	local player,alt = TradeskillInfo:GetCombineAvailability(self.vars.searchResult[index]);
	if player > 0 then
		skillType = player == 1 and "playerknown" or player == 2 and "playerlearn" or player == 3 and "playerhigh";
	elseif alt > 0 then
		skillType = alt == 1 and "altknown" or alt == 2 and "altlearn" or alt == 3 and "althigh";
	else
		skillType = "unavailable";
	end
	return skillType;
end

function TradeskillInfoUI:GetTradeSkillRecipe(index)
	if not self.vars.searchResult[index] then return end
	local text, height, sources
	local id = TradeskillInfo:GetCombineRecipe(self.vars.searchResult[index]);
	if id then
		height, sources = TradeskillInfo:GetRecipeSources(id,self.db.profile.ShowOpposing);
		if sources then
			text = L["Recipe"] .. ": "..sources;
		end
	end
	return height, text;
end

function TradeskillInfoUI:GetTradeSkillBy(index)
	local knownBy = TradeskillInfo:GetCombineKnownBy(self.vars.searchResult[index])
	local learnableBy = TradeskillInfo:GetCombineLearnableBy(self.vars.searchResult[index])
	local availableTo = TradeskillInfo:GetCombineAvailableTo(self.vars.searchResult[index])
	local text = ""
	if knownBy then
		text = "|Cffffffff" .. L["Known by"] .. ": " .. knownBy .. "|r\n"
	end
	if learnableBy then
		text = text .. "|Cff33ff33" .. L["Learnable by"] .. ": " .. learnableBy .. "|r\n"
	end
	if availableTo then
		text = text .. "|Cffff7733" .. L["Will be learnable by"] .. ": " .. availableTo.."|r"
	end
	return text
end

function TradeskillInfoUI:GetTradeSkillIcon(index)
	if not self.vars.searchResult[index] then return end
	return TradeskillInfo:GetCombineTexture(self.vars.searchResult[index])
end


function TradeskillInfoUI:GetTradeSkillNumReagents(index)
	if self.vars.components then
		self.vars.components = nil;
	end
	if not self.vars.searchResult[index] then return end
	self.vars.components = TradeskillInfo:GetCombineComponents(self.vars.searchResult[index])
	return table.getn(self.vars.components);
end

function TradeskillInfoUI:GetTradeSkillReagentInfo(i)
	if not self.vars.components[i] then return end
	return self.vars.components[i].name, self.vars.components[i].texture, self.vars.components[i].num, self.vars.components[i].link, self.vars.components[i].itemString, self.vars.components[i].id;
end

function TradeskillInfoUI:GetTradeSkillReagentId(i)
	if not self.vars.components[i] then return end
	return self.vars.components[i].id;
end


function TradeskillInfoUI:GetTradeSkillExtraData(index)
	if not self.vars.searchResult[index] then return end
	return TradeskillInfo:GetExtraItemDataText(self.vars.searchResult[index], true, true, true);
end

function TradeskillInfoUI:IsSafeToShowTooltip(index)
	local known = false;
	if self.vars.searchResult[index] < 0 then
		known = true;
		for i,c in ipairs(self.vars.components) do
			if not c.link then
				known = false;
			end
		end
	end
	return known;
end


function TradeskillInfoUI:GetTradeSkillSkillLevel(index)
	return TradeskillInfo:GetCombineSkill(self.vars.searchResult[index]);
end

function TradeskillInfoUI:GetTradeSkillName(skill)
	return TradeskillInfo.vars.tradeskills[skill];
end

function TradeskillInfoUI:GetTradeSkillSpecializationName(spec)
	return TradeskillInfo.vars.specializations[spec];
end

function TradeskillInfoUI:CollapseHeader(index)
	if self.vars.searchResult[index] and type(self.vars.searchResult[index]) == "string" then
		self.db.profile.expanded[self.vars.searchResult[index]] = false;
		self:SendMessage("TradeskillInfo_Update");
	elseif index == 0 then
		for i,_ in pairs(self.db.profile.expanded) do
			self.db.profile.expanded[i] = false;
		end
		self:SendMessage("TradeskillInfo_Update");
	end
end

function TradeskillInfoUI:ExpandHeader(index)
	if self.vars.searchResult[index] and type(self.vars.searchResult[index]) == "string" then
		self.db.profile.expanded[self.vars.searchResult[index]] = true;
		self:SendMessage("TradeskillInfo_Update");
	elseif index == 0 then
		for i,_ in pairs(self.db.profile.expanded) do
			self.db.profile.expanded[i] = true;
		end
		self:SendMessage("TradeskillInfo_Update");
	end
end


function TradeskillInfoUI:PasteRecipie(id)
	local skillName, skillType, _ = self:GetTradeSkillInfo(id);
	if not skillName or skillType == "header" then return end
	local _,skillLink,_ = self:GetTradeSkillIcon(id);
	local numMade = self:GetTradeSkillNumMade(id);
	local skill,spec,level = self:GetTradeSkillSkillLevel(id)
	local profType = self:GetTradeSkillName(skill);
	local specName = self:GetTradeSkillSpecializationName(spec);
	local text;

	skillLink = nil;
	local enchantName
	local enchantId=TradeskillInfo:GetCombineEnchantId(self.vars.searchResult[id]);
	if profType == "Enchanting" and self.vars.searchResult[id] < 0 then enchantName = skillName end
	if enchantId then
		if not enchantName then
			enchantName = profType .. ": " .. skillName;
		end
		skillLink = "|cffffd000|Henchant:" .. enchantId .. "|h[" .. enchantName .. "]|h|r";
		if skillLink then
			ChatFrameEditBox:Insert(skillLink);
			return;
		end
	end
	if numMade and numMade > 1 then
		numMade = tostring(numMade);
	else
		numMade = "";
	end
--	if skillLink then
--		text = numMade .. skillLink .. " : ";
--	else
		text = numMade .. skillName .. " : ";
--	end

	local numReagents = self:GetTradeSkillNumReagents(id);
	for i=1, numReagents, 1 do
		local reagentName, reagentTexture, reagentCount, reagentLink, reagentItemString = self:GetTradeSkillReagentInfo(i);
		if i > 1 then
			text = text .. ", ";
		end
--		if reagentLink then
--			text = text .. reagentCount .. "*" .. reagentLink;
--		else
			text = text .. reagentCount .. "*" .. reagentName;
--		end
	end

	skillName=profType;
	if specName then
		text = text .. " : " .. skillName .. "(" .. level .. "), " .. specName;
	else
		text = text .. " : " .. skillName .. "(" .. level .. ")";
	end

	ChatFrameEditBox:Insert(text);
end

do
	-- tooltip frame for forcing a local cache update
	local tipframe = CreateFrame("GameTooltip", "TSI_Tooltip", nil, "GameTooltipTemplate")
	-- Action table. Indexes are item (positive) or spell (negative) ids. Values are either
	-- functions or threads. When a tooltip information is updated, functions are called,
	-- and threads are resumed for the id of the tooltip.
	local idAction = {}

	-- Perform the action of an item or spell Id. Uses idAction table.
	local performIdAction = function(id)
		if type(idAction[id]) == "thread" then
			if coroutine.status(idAction[id]) == "suspended" then
				coroutine.resume(idAction[id])
			end
		elseif type(idAction[id]) == "function" then
			idAction[id]()
		end
	end

	tipframe:SetOwner(UIParent, "ANCHOR_NONE")

	tipframe:SetScript("OnTooltipSetItem", function()
		local _, itemLink = tipframe:GetItem()
		local itemId = tonumber(string.match(itemLink, "item:(%d+):"))
		performIdAction(itemId)
	end)

	tipframe:SetScript("OnTooltipSetSpell", function()
		local _, _, spellId = tipframe:GetSpell()
		performIdAction(-spellId)
	end)

	-- Update the cache of the specified item or spell, and refresh the details frame.
	-- TODO: Not sure this will be needed anymore.
	function TradeskillInfoUI:UpdateCacheItem(itemLink)
		-- extract id from a link. The link may be an item, spell, or enchant link.
		local id = tonumber(string.match(itemLink, "item:(%d+):"))
		if not id then
			id = tonumber(string.match(itemLink, "spell:(%d+):"))
		end
		if not id then
			id = tonumber(string.match(itemLink, "enchant:(%d+):"))
		end
		if not id then return end

		-- Update local cache, and redraw details frame.
		idAction[id] = function()
			idAction[id] = nil
			self:Frame_Refresh()
		end
		tipframe:SetHyperlink(itemLink)
	end

	-- Update local cache for the specified index, and wait until update is complete.
	-- NOTE: This must be called from within a coroutine.
	function TradeskillInfoUI:UpdateCacheIndex(id, coObj)
		tipframe:SetOwner(UIParent, "ANCHOR_NONE")
		idAction[id] = coObj
		local skillLink

		if id > 0 then
			-- it could be a specialcase ID. Get the real item ID.
			id = TradeskillInfo:GetSpecialCase(id)
			skillLink = "item:" .. id .. ":0:0:0:0:0:0:0"
		else
			skillLink = "spell:" .. -id
		end
		-- Try up to three times to get the info before giving up.
		-- For some reason blizzard calls the script even when the local cache is not updated
		-- once or twice. The retries handle these cases.
		for retries = 1,3 do
			-- deadlock prevention: Assume update will complete in 2 seconds.
			-- This should be unnecessary, but better than risking
			-- locking down the coroutine forever.
			local hTimer = self:ScheduleTimer(performIdAction, 2, id)
			tipframe:SetHyperlink(skillLink)
			coroutine.yield()
			self:CancelTimer(hTimer)
			local name
			if id > 0 then
				name = GetItemInfo(id)
			else
				name = GetSpellInfo(id)
			end
			-- If we update successfully, stop. Otherwise, try again.
			if name then break end
		end
		idAction[id] = nil
    end
end
