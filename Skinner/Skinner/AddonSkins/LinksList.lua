if not Skinner:isAddonEnabled("LinksList") then return end

function Skinner:LinksList()

	self:keepFontStrings(LinksList_ToggleButton)
	LinksList_ToggleButton:ClearAllPoints()
	LinksList_ToggleButton:GetFontString():SetPoint("CENTER", LinksList_ToggleButton, "CENTER")
	self:applySkin(LinksList_ToggleButton)

	local llsfr = "LinksList_SearchFrame_Reusable"

	self:SecureHookScript(LinksList_ToggleButton, "OnClick", function()
		LinksList_ResultsFrame:SetWidth(LinksList_ResultsFrame:GetWidth() * self.FxMult)
		LinksList_ResultsFrame:SetHeight(LinksList_ResultsFrame:GetHeight() * self.FyMult)
		self:keepFontStrings(LinksList_ResultsFrame)
		self:moveObject(LinksList_ResultsFrame_TitleButton, nil, nil, "+", 8)
		self:moveObject(LinksList_ResultsFrame_CloseButton, "+", 30, "+", 8)
		self:skinDropDown(LinksList_ResultsFrame_SectionDD)
		self:skinDropDown(LinksList_ResultsFrame_SortTypeDD)
		self:removeRegions(LinksList_ResultsFrame_ScrollFrame)
		self:skinScrollBar(LinksList_ResultsFrame_ScrollFrame)
		self:moveObject(LinksList_ResultsFrame_AdvancedSearchButton, "+", 30, "-", 70)
		self:applySkin(LinksList_ResultsFrame)
		LinksList_ResultsFrame_QuickSearchFrame:SetWidth(200)
		self:moveObject(LinksList_ResultsFrame_QuickSearchFrame, "-", 5, "-", 70)
		self:applySkin(LinksList_ResultsFrame_QuickSearchFrame)
--		hook this to skin the Advanced Search Frame
		self:SecureHookScript(LinksList_ResultsFrame_AdvancedSearchButton, "OnClick", function()
			if not self.skinned[LinksList_SearchFrame] then
				self:keepFontStrings(LinksList_SearchFrame)
				self:moveObject(LinksList_SearchFrameTitleBoxText, nil, nil, "-", 7)
				self:applySkin(LinksList_SearchFrame_SectionParametersFrame)
				self:applySkin(LinksList_SearchFrame_SubsectionParametersFrame)
				self:skinDropDown(LinksList_SearchFrame_SubsectionParametersFrame_SubsectionDD)
				self:applySkin(LinksList_SearchFrame)
			end
			for i = 1, LinksList_SearchFrame:GetNumChildren() do
				local v = select(i, LinksList_SearchFrame:GetChildren())
				if not self.skinned[v] then
					local objName = v:GetName()
					if strmatch(objName, llsfr.."Frame") then self:skinDropDown(v)
					elseif strmatch(objName, llsfr.."EditBox") then
						self:skinEditBox(v, {9})
						v:SetWidth(v:GetWidth() - 5)
						v.SetHeight = function() end
					end
				end
			end
		end)
	self:Unhook(LinksList_ToggleButton, "OnClick")
	end)

end
