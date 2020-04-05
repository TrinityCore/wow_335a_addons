local L = LibStub("AceLocale-3.0"):GetLocale("Critline")
local module

local _, addon = ...


addon.reset = addon.templates:CreateList("CritlineReset")
module = addon.reset
module.button:SetText(RESET)
module.button:SetScript("OnClick", function()
	PlaySound("gsTitleOptionOK")
	module:ResetRecords()
end)

module.selectedSpells = {}

module.name = RESET
module.parent = "Critline"
InterfaceOptions_AddCategory(module)

module.resetAll = CreateFrame("CheckButton", nil, module, "OptionsBaseCheckButtonTemplate")
module.resetAll:SetPoint("TOPLEFT", module.tree, "BOTTOMLEFT", 15, 0)
module.resetAll:SetPushedTextOffset(0, 0)
module.resetAll:SetScript("OnClick", function(self)
	if self:GetChecked() then
		PlaySound("igMainMenuOptionCheckBoxOn")
	else
		PlaySound("igMainMenuOptionCheckBoxOff")
	end
end)

local fontString = module.resetAll:CreateFontString(nil, nil, "GameFontHighlight")
fontString:SetPoint("LEFT", module.resetAll, "RIGHT", 0, 1)
module.resetAll:SetFontString(fontString)
module.resetAll:SetText(L["Reset all records for this tree"])


function module:ResetRecords()
	local selectedTree = UIDropDownMenu_GetSelectedValue(self.tree)
	
	local spells = self.selectedSpells
	
	if self.resetAll:GetChecked() then
		wipe(CritlineDB[selectedTree])
		self.resetAll:SetChecked(false)
		addon:Message(format("Reset all %s records.", selectedTree))
	else
		-- remove selected spells from database
		for i = 1, table.maxn(spells) do
			if spells[i] then
				local tree = CritlineDB[selectedTree]
				local data = tree[i]
				if data.filtered then
					data.normal = nil
					data.crit = nil
					spells[i] = nil
				end
				addon:Message(format("Reset %s (%s) records.", addon:GetFullSpellName(selectedTree, data.spellName, data.isPeriodic), selectedTree))
			end
		end
		for i = table.maxn(spells), 1, -1 do
			if spells[i] then
				local tree = CritlineDB[selectedTree]
				tremove(tree, i)
			end
		end
	end
	
	wipe(spells)

	self:Update()
	addon.spellFilter:Update()
	addon:RebuildAllTooltips()
end