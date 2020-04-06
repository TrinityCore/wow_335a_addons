
function Skinner:DiamondThreatMeter()

-->>--	config Intro Panel
	self:applySkin(DTM_RingButton)
	self:applySkin(DTM_RingButton_HoldFrame)
-->>--	config Engine Panel
	self:applySkin(DTM_ConfigurationFrame_EnginePanel_EmulationPanel)
-->>--	config Version Panel
	self:applySkin(DTM_ConfigurationFrame_VersionPanel_ResultPanel)
-->>--	error Console
	self:applySkin(DTM_ErrorConsole_BackgroundFrame)
	self:removeRegions(DTM_ErrorConsole_ScrollFrame)
	self:skinScrollBar(DTM_ErrorConsole_ScrollFrame)
	self:applySkin(DTM_ErrorConsole)
-->>--	skin Manager
	self:skinDropDown(DTM_SkinManager_DropDown)
	self:applySkin(DTM_SkinManager)
-->>--	skin Editor
	self:keepFontStrings(DTM_SkinEditor)
	self:moveObject(DTM_SkinEditor_TitleText, nil, nil, "-", 4)
	self:applySkin(DTM_SkinEditor_TestList)
	self:applySkin(DTM_SkinEditor)
	self:SecureHook(DTM_SkinEditor, "Show", function()
		for i = 1, DTM_SkinSchema_GetNumCategories() do
			local cFrame = DTM_SkinEditor.categories[i]
			self:keepFontStrings(cFrame)
			self:moveObject(_G[cFrame:GetName().."_TitleText"], nil, nil, "-", 4)
			self:applySkin(cFrame)
			for j = 1, cFrame.numWidgets do
				local obj = cFrame.widgets[j]
				if self:isDropDown(obj) then self:skinDropDown(obj)
				elseif obj:IsObjectType("EditBox") then self:skinEditBox(obj, {9})
				end
			end
		end
		self:Unhook(DTM_SkinEditor, "Show")
	end)
	DTM_SkinEditor_TestList.SetBackdrop = function() end
	DTM_SkinEditor_TestList.SetBackdropColor = function() end
	DTM_SkinEditor_TestList.SetBackdropBorderColor = function() end

-->>--	Target Threat List
	self:glazeStatusBar(DTM_GUI_TargetThreatList_HealthBar, 0)
	self:applySkin(DTM_GUI_TargetThreatList)
	DTM_GUI_TargetThreatList.SetBackdrop = function() end
	DTM_GUI_TargetThreatList.SetBackdropColor = function() end
	DTM_GUI_TargetThreatList.SetBackdropBorderColor = function() end
-->>--	Focus Threat List
	self:glazeStatusBar(DTM_GUI_FocusThreatList_HealthBar, 0)
	self:applySkin(DTM_GUI_FocusThreatList)
	-- both the TargetThreatList & FocusThreatList use this function
	self:SecureHook("DTM_ThreatListFrame_OnLoad", function()
		for i = 1, DTM_GUI_GetMaxThreatListRows() do
			self:glazeStatusBar(DTM_GUI_TargetThreatList.row[i], 0)
			self:glazeStatusBar(DTM_GUI_FocusThreatList.row[i], 0)
		end
		self:Unhook("DTM_ThreatListFrame_OnLoad")
	end)
	DTM_GUI_FocusThreatList.SetBackdrop = function() end
	DTM_GUI_FocusThreatList.SetBackdropColor = function() end
	DTM_GUI_FocusThreatList.SetBackdropBorderColor = function() end
-->>--	Player Overview List
	self:applySkin(DTM_GUI_PlayerOverviewList)
	self:SecureHook("DTM_OverviewListFrame_OnLoad", function()
		for i = 1, DTM_GUI_GetMaxOverviewListRows() do
			self:glazeStatusBar(DTM_GUI_PlayerOverviewList.row[i], 0)
		end
		self:Unhook("DTM_OverviewListFrame_OnLoad")
	end)
	DTM_GUI_PlayerOverviewList.SetBackdrop = function() end
	DTM_GUI_PlayerOverviewList.SetBackdropColor = function() end
	DTM_GUI_PlayerOverviewList.SetBackdropBorderColor = function() end
-->>--	Player Regain List
	self:applySkin(DTM_GUI_PlayerRegainList)
	self:SecureHook("DTM_RegainListFrame_OnLoad", function()
		for i = 1, DTM_GUI_GetMaxRegainListRows() do
			self:glazeStatusBar(DTM_GUI_PlayerRegainList.row[i], 0)
		end
		self:Unhook("DTM_RegainListFrame_OnLoad")
	end)
	DTM_GUI_PlayerRegainList.SetBackdrop = function() end
	DTM_GUI_PlayerRegainList.SetBackdropColor = function() end
	DTM_GUI_PlayerRegainList.SetBackdropBorderColor = function() end

end
