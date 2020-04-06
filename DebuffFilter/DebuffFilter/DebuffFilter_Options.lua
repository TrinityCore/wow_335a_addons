local DebuffFilterOptions = {};
-- settings for the current player
local DebuffFilter_PlayerConfig;

-- list of debuffs/buffs, used to display in options screen
DebuffFilterOptions.items = {};

-- prefix for string needed to grab proper list of debuffs/buffs
DebuffFilterOptions.target = "";
-- suffix for string needed to grab proper list of debuffs/buffs
DebuffFilterOptions.type = "debuff";

DebuffFilterOptions.Frames = DebuffFilterFrames;

-- direction that debuffs/buffs are positioned
DebuffFilterOptions.LayoutTable = {
	rightdown = {1, "Right-Down"},
	rightup = {2, "Right-Up"},
	leftdown = {3, "Left-Down"},
	leftup = {4, "Left-Up"},
}

-- debuff/buff that is selected in options screen
DebuffFilterOptions_Selection = "";

function DebuffFilterOptions_Initialize()
	-- DebuffFilter_Player is a global variable taken from DebuffFilter.lua
	DebuffFilter_PlayerConfig = DebuffFilter_Config[DebuffFilter_Player];

	UIPanelWindows["DebuffFilterOptionsFrame"] = {area = "center", pushable = 0, whileDead = 1}
	DebuffFilterOptions_UpdateItems();
	DebuffFilterOptions_Title:SetText("Debuff Filter " .. GetAddOnMetadata("DebuffFilter", "Version"));
end

function DebuffFilterOptions_TargetDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, DebuffFilterOptions_TargetDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(self, 1);
	UIDropDownMenu_SetWidth(self, 72);

	self.tooltipText = DFILTER_OPTIONS_TARGET_TOOLTIP;
end

function DebuffFilterOptions_TargetDropDown_Initialize()
	local info = {};
	info.text = "Target";
	info.value = "";
	info.func = DebuffFilterOptions_TargetDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info.checked = nil;
	info.text = "Player";
	info.value = "p";
	info.func = DebuffFilterOptions_TargetDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info.checked = nil;
	info.text = "Focus";
	info.value = "f";
	info.func = DebuffFilterOptions_TargetDropDown_OnClick;
	UIDropDownMenu_AddButton(info);
end

function DebuffFilterOptions_TargetDropDown_OnClick(self)
	UIDropDownMenu_SetSelectedID(DebuffFilterOptions_TargetDropDown, self:GetID());
	DebuffFilterOptions.target = self.value;

	-- dont show self applied option if debuffs/buffs on self are shown
	if (self.value ~= "p") then
		DebuffFilterOptions_CheckButtonSelfApplied:Show();
	else
		DebuffFilterOptions_CheckButtonSelfApplied:Hide();
	end

	DebuffFilterOptions_ClearSelection();
end

function DebuffFilterOptions_GrowDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, DebuffFilterOptions_GrowDropDown_Initialize);
	UIDropDownMenu_SetWidth(self, 102);

	self.tooltipText = DFILTER_OPTIONS_GROW_TOOLTIP;
end

-- direction that debuffs/buffs are positioned
function DebuffFilterOptions_GrowDropDown_Initialize()
	local info = {};
	info.text = "Right-Down";
	info.value = "rightdown";
	info.func = DebuffFilterOptions_GrowDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info.checked = nil;
	info.text = "Right-Up";
	info.value = "rightup";
	info.func = DebuffFilterOptions_GrowDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info.checked = nil;
	info.text = "Left-Down";
	info.value = "leftdown";
	info.func = DebuffFilterOptions_GrowDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info.checked = nil;
	info.text = "Left-Up";
	info.value = "leftup";
	info.func = DebuffFilterOptions_GrowDropDown_OnClick;
	UIDropDownMenu_AddButton(info);
end

function DebuffFilterOptions_GrowDropDown_OnClick(self)
	DebuffFilterOptions_ModifyLayout("grow", self.value, self:GetID());
end

function DebuffFilterOptions_Tab_OnClick(type)
	DebuffFilterOptions.type = type;

	DebuffFilterOptions_ClearSelection();
end

-- taken from bongos
function DebuffFilterOptions_SetScale(scale)
	local ratio, x, y;

	DebuffFilter_PlayerConfig.scale = scale;
	ratio = DebuffFilterFrame:GetScale() / scale

	for k in pairs(DebuffFilterOptions.Frames) do
		x, y = _G[k]:GetLeft() * ratio, _G[k]:GetTop() * ratio;
		_G[k]:ClearAllPoints();
		_G[k]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y);
	end

	DebuffFilterFrame:SetScale(scale);
end

function DebuffFilterOptions_UpdateItems()
	for k in pairs(DebuffFilterOptions.items) do
		DebuffFilterOptions.items[k] = nil;
	end

	local targettype = DebuffFilterOptions.target .. DebuffFilterOptions.type;

	DebuffFilterOptions.list = targettype .. "_list";
	DebuffFilterOptions.layout = targettype .. "_layout";

	for k in pairs(DebuffFilter_PlayerConfig[DebuffFilterOptions.list]) do
		table.insert(DebuffFilterOptions.items, k);
	end

	table.sort(DebuffFilterOptions.items);
	DebuffFilterOptions.count = table.getn(DebuffFilterOptions.items);
end

-- update list of debuffs/buffs and highlight the current selection
function DebuffFilterOptions_ScrollFrame_Update()
	local button, name;

	local offset = FauxScrollFrame_GetOffset(DebuffFilterOptions_ScrollFrame);
	FauxScrollFrame_Update(DebuffFilterOptions_ScrollFrame, DebuffFilterOptions.count, 14, 16);

	for i = 1, 14 do
		button = _G["DebuffFilterOptions_Item" .. i];

		if (DebuffFilterOptions.count >= i + offset) then
			name = DebuffFilterOptions.items[i + offset];

			if (name == DebuffFilterOptions_Selection) then
				button:LockHighlight();
			else
				button:UnlockHighlight();
			end

			button:SetText(name);
			button:Show();
		else
			button:Hide();
		end
	end
end

function DebuffFilterOptions_ModifyLayout(type, value, id)
	if (type == "grow") then
		DebuffFilter_PlayerConfig[DebuffFilterOptions.layout].grow = value;
		UIDropDownMenu_SetSelectedID(DebuffFilterOptions_GrowDropDown, id);
	else
		DebuffFilter_PlayerConfig[DebuffFilterOptions.layout].per_row = value;
	end

	for k, v in pairs(DebuffFilterOptions.Frames) do
		if (v.list_key == DebuffFilterOptions.list) then
			DebuffFilter_UpdateLayout(k);
			
			break;
		end
	end
end

function DebuffFilterOptions_ModifyList(arg)
	local item = DebuffFilterOptions_EditBox:GetText();
	local texture = DebuffFilterOptions_EditBox2:GetText();
	local selfapplied = DebuffFilterOptions_CheckButtonSelfApplied:GetChecked();
	local dontcombine = DebuffFilterOptions_CheckButtonDontCombine:GetChecked();

	if (item ~= "") then
		-- add debuff/buff
		if (arg == "add") then
			DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item] = {};
			DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item].selfapplied = selfapplied;
			DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item].dontcombine = dontcombine;

			if (texture ~= "") then
				DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item].texture = texture;
			else
				DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item].texture = nil;
			end

			DebuffFilterOptions_ClearSelection();
		elseif (arg == "selfapplied" or arg == "dontcombine") then
			if (DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item]) then
				DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item].selfapplied = selfapplied;
				DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item].dontcombine = dontcombine;
			end
		else
			DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item] = nil;

			DebuffFilterOptions_ClearSelection();
		end

		-- update the frame for the current list of debuffs/buffs
		for k, v in pairs(DebuffFilterOptions.Frames) do
			if (v.list_key == DebuffFilterOptions.list) then
				DebuffFilter_Frame_Update(k);
				
				break;
			end
		end
	else
		DebuffFilterOptions_ClearSelection();
	end
end

-- clear everything except for checkboxes in settings, and refresh lots of stuff
function DebuffFilterOptions_ClearSelection()
	DebuffFilterOptions_Selection = "";
	DebuffFilterOptions_EditBox:SetText("");
	DebuffFilterOptions_EditBox2:SetText("");
	DebuffFilterOptions_CheckButtonSelfApplied:SetChecked(0);
	DebuffFilterOptions_CheckButtonDontCombine:SetChecked(0);

	DebuffFilterOptions_ScrollFrameScrollBar:SetValue(0);
	DebuffFilterOptions_UpdateItems();
	DebuffFilterOptions_ScrollFrame_Update();

	DebuffFilterOptions_GetLayout();
end

-- display number of debuffs/buffs per row and how they are positioned
function DebuffFilterOptions_GetLayout()
	local grow = DebuffFilter_PlayerConfig[DebuffFilterOptions.layout].grow;

	UIDropDownMenu_SetSelectedID(DebuffFilterOptions_GrowDropDown, DebuffFilterOptions.LayoutTable[grow][1]);
	UIDropDownMenu_SetText(DebuffFilterOptions_GrowDropDown, DebuffFilterOptions.LayoutTable[grow][2]);

	DebuffFilterOptions_RowSlider:SetValue(DebuffFilter_PlayerConfig[DebuffFilterOptions.layout].per_row);
end

function DebuffFilterOptions_GetOptions(item)
	DebuffFilterOptions_CheckButtonSelfApplied:SetChecked(DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item].selfapplied);
	DebuffFilterOptions_CheckButtonDontCombine:SetChecked(DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item].dontcombine);
	DebuffFilterOptions_EditBox2:SetText(DebuffFilter_PlayerConfig[DebuffFilterOptions.list][item].texture or "");
end