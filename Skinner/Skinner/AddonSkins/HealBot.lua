-- many thanks to acirac for the updated skin
if not Skinner:isAddonEnabled("HealBot") then return end

function Skinner:HealBot() -- version 3.3.5.0
	if not self.db.profile.Tooltips.skin then return end

-->>--	Tooltips
	if self.db.profile.Tooltips.style == 3 then
		HealBot_ScanTooltip:SetBackdrop(self.backdrop)
		HealBot_Tooltip:SetBackdrop(self.backdrop)
	end
	self:skinTooltip(HealBot_ScanTooltip)
	self:skinTooltip(HealBot_Tooltip)

-- Tabs
	self:resizeTabs(HealBot_Options)
	for i = 1, 7 do
		local tabName = _G["HealBot_OptionsTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if i == 1 then self:moveObject(tabName, "+", 2, "-", 1)
		else self:moveObject(tabName, "+", 9, nil, nil) end
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:applySkin(tabName) end
	end

	if self.db.profile.TexturedTab then
		for i = 1, 7 do
			local tabName = _G["HealBot_OptionsTab"..i]
			self:setInactiveTab(tabName)
		end
		self:setActiveTab(HealBot_OptionsTab1)
		self:SecureHook("HealBot_Options_ShowPanel", function(this)
			for i = 1, 7 do
				local tabName = _G["HealBot_OptionsTab"..i]
				if i == HealBot_Options.selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

	self:keepFontStrings(HealBot_Options_SelectHealSpellsCombo)
	self:keepFontStrings(HealBot_Options_SelectOtherSpellsCombo)
	self:keepFontStrings(HealBot_Options_SelectMacrosCombo)
	self:keepFontStrings(HealBot_Options_SelectItemsCombo)
	self:keepFontStrings(HealBot_Options_SelectCmdsCombo)
	
	self:keepFontStrings(HealBot_Options_hbCommands)
	self:keepFontStrings(HealBot_Options_HealCommMethod)
	self:keepFontStrings(HealBot_Options_EmergencyFilter)
	self:keepFontStrings(HealBot_Options_BarHealthNumFormatAggro)
	self:keepFontStrings(HealBot_Options_AggroAlertLevel)	
	self:keepFontStrings(HealBot_Options_CastButton)
	self:keepFontStrings(HealBot_Options_ButtonCastMethod)
	self:keepFontStrings(HealBot_Options_ExtraSort)
	self:keepFontStrings(HealBot_Options_ExtraSubSort)
	self:keepFontStrings(HealBot_Options_FilterHoTctl)
	self:keepFontStrings(HealBot_Options_Class_HoTctlName)
	self:keepFontStrings(HealBot_Options_Class_HoTctlAction)
	
	self:keepFontStrings(HealBot_Options_BarHealthIncHeal)
	self:keepFontStrings(HealBot_Options_BarHealthType)
	self:keepFontStrings(HealBot_Options_BarHealthNumFormat1)
	self:keepFontStrings(HealBot_Options_BarHealthNumFormat2)
	
	self:keepFontStrings(HealBot_Options_ExtraOptFrame)
	self:applySkin(HealBot_Options_ExtraOptFrame, nil)
	self:keepFontStrings(HealBot_Options_HealTargetFrame)
	self:applySkin(HealBot_Options_HealTargetFrame, nil)
	self:keepFontStrings(HealBot_Options_EmergencyFClass)
	self:keepFontStrings(HealBot_Options_EmergLFrame)
	self:applySkin(HealBot_Options_EmergLFrame, nil)	
	
	self:keepFontStrings(HealBot_Options_BuffTxt1)
	self:keepFontStrings(HealBot_Options_BuffTxt2)
	self:keepFontStrings(HealBot_Options_BuffTxt3)
	self:keepFontStrings(HealBot_Options_BuffTxt4)
	self:keepFontStrings(HealBot_Options_BuffTxt5)
	self:keepFontStrings(HealBot_Options_BuffTxt6)
	self:keepFontStrings(HealBot_Options_BuffTxt7)
	self:keepFontStrings(HealBot_Options_BuffTxt8)
	self:keepFontStrings(HealBot_Options_BuffTxt9)
	self:keepFontStrings(HealBot_Options_BuffTxt10)
	
	self:keepFontStrings(HealBot_Options_BuffGroups1)
	self:keepFontStrings(HealBot_Options_BuffGroups2)
	self:keepFontStrings(HealBot_Options_BuffGroups3)
	self:keepFontStrings(HealBot_Options_BuffGroups4)
	self:keepFontStrings(HealBot_Options_BuffGroups5)
	self:keepFontStrings(HealBot_Options_BuffGroups6)
	self:keepFontStrings(HealBot_Options_BuffGroups7)
	self:keepFontStrings(HealBot_Options_BuffGroups8)
	self:keepFontStrings(HealBot_Options_BuffGroups9)
	self:keepFontStrings(HealBot_Options_BuffGroups10)
	
	self:keepFontStrings(HealBot_Options_CDCTxt1)
	self:keepFontStrings(HealBot_Options_CDCTxt2)
	self:keepFontStrings(HealBot_Options_CDCTxt3)
	
	self:keepFontStrings(HealBot_Options_CDCGroups1)
	self:keepFontStrings(HealBot_Options_CDCGroups2)
	self:keepFontStrings(HealBot_Options_CDCGroups3)
	
	self:keepFontStrings(HealBot_Options_CDCPriority1)
	self:keepFontStrings(HealBot_Options_CDCPriority2)
	self:keepFontStrings(HealBot_Options_CDCPriority3)
	self:keepFontStrings(HealBot_Options_CDCPriority4)
	
	self:keepFontStrings(HealBot_Options_CDebuffCat)
	self:keepFontStrings(HealBot_Options_CDCPriorityC)
	
	self:keepFontStrings(HealBot_Options_CDCWarnRange1)
	self:keepFontStrings(HealBot_Options_CDCWarnRange2)
	self:keepFontStrings(HealBot_Options_CDCWarnRange3)
	self:keepFontStrings(HealBot_Options_CDCWarnRange4)
	
	self:keepFontStrings(HealBot_Options_BuffsPanel)
	self:applySkin(HealBot_Options_BuffsPanel, nil)	
	self:keepFontStrings(HealBot_Options_ComboClassButton)
	self:keepFontStrings(HealBot_Options_ActionBarsCombo)
	self:keepFontStrings(HealBot_Options_MouseWheelModKey)
	self:keepFontStrings(HealBot_Options_SkinPartyRaidDefault)
	self:keepFontStrings(HealBot_Options_KeysFrame)
	self:applySkin(HealBot_Options_KeysFrame, nil)
	self:keepFontStrings(HealBot_Options_DisabledBarPanel)
	self:applySkin(HealBot_Options_DisabledBarPanel, nil)	
	self:keepFontStrings(HealBot_Options_SelectSpellsFrame)
	self:applySkin(HealBot_Options_SelectSpellsFrame, nil)
	self:keepFontStrings(HealBot_Options_HealAlertFrame)
	self:applySkin(HealBot_Options_HealAlertFrame, nil)
	self:keepFontStrings(HealBot_Options_HealRaidFrame)
	self:applySkin(HealBot_Options_HealRaidFrame, nil)	
	self:keepFontStrings(HealBot_Options_HealSortFrame)
	self:applySkin(HealBot_Options_HealSortFrame, nil)	
	self:keepFontStrings(HealBot_Options_AggroSkinsFrame)
	self:applySkin(HealBot_Options_AggroSkinsFrame, nil)
	self:keepFontStrings(HealBot_Options_IconTextSkinsFrame)
	self:applySkin(HealBot_Options_IconTextSkinsFrame, nil)	
	
	self:keepFontStrings(HealBot_Options_TooltipPos)
	self:keepFontStrings(HealBot_Options_TooltipsPanel)
	self:applySkin(HealBot_Options_TooltipsPanel, nil)
	self:keepFontStrings(HealBot_Options_TooltipsPanel2)
	self:applySkin(HealBot_Options_TooltipsPanel2, nil)
	self:keepFontStrings(HealBot_Options_incHealsPanel)
	self:applySkin(HealBot_Options_incHealsPanel, nil)
	self:keepFontStrings(HealBot_Options_FrameCols)
	self:applySkin(HealBot_Options_FrameCols, nil)
	self:keepFontStrings(HealBot_Options_Skins_HoTs2)
	self:applySkin(HealBot_Options_Skins_HoTs2, nil)
	self:keepFontStrings(HealBot_Options_Skins_Bars2)
	self:applySkin(HealBot_Options_Skins_Bars2, nil)
	self:keepFontStrings(HealBot_Options_GeneralSkinsFrame)
	self:applySkin(HealBot_Options_GeneralSkinsFrame, nil)
	self:keepFontStrings(HealBot_Options_HealingSkinsFrame)
	self:applySkin(HealBot_Options_HealingSkinsFrame, nil)			
	self:keepFontStrings(HealBot_Options_IncHealsSkinsFrame)
	self:applySkin(HealBot_Options_IncHealsSkinsFrame, nil)
	self:keepFontStrings(HealBot_Options_ChatSkinsFrame)
	self:applySkin(HealBot_Options_ChatSkinsFrame, nil)	
	self:keepFontStrings(HealBot_Options_HeadersSkinsFrame)
	self:applySkin(HealBot_Options_HeadersSkinsFrame, nil)	
	self:keepFontStrings(HealBot_Options_BarsSkinsFrame)
	self:applySkin(HealBot_Options_BarsSkinsFrame, nil)	
	self:keepFontStrings(HealBot_Options_TextSkinsFrame)
	self:applySkin(HealBot_Options_TextSkinsFrame, nil)	
	self:keepFontStrings(HealBot_Options_IconsSkinsFrame)
	self:applySkin(HealBot_Options_IconsSkinsFrame, nil)	
		
	self:keepFontStrings(HealBot_Options_CureDispelCleanseWarn)
	self:applySkin(HealBot_Options_CureDispelCleanseWarn, nil)
	
	self:keepFontStrings(HealBot_Options_CustomCureFrame)
	self:applySkin(HealBot_Options_CustomCureFrame, nil)
	self:keepFontStrings(HealBot_Options_WarningCureFrame)
	self:applySkin(HealBot_Options_WarningCureFrame, nil)
	
	self:keepFontStrings(HealBot_Options_CustomDebuffCol)	
	self:keepFontStrings(HealBot_Options_CureDispelCleanseCol)
	self:applySkin(HealBot_Options_CureDispelCleanseCol, nil)	
	self:keepFontStrings(HealBot_Options_CDebuffTxt1)
	self:keepFontStrings(HealBot_Options_CureDispelCleanse)
	self:applySkin(HealBot_Options_CureDispelCleanse, nil)	
	self:keepFontStrings(HealBot_Options_Skins)
	self:keepFontStrings(HealBot_Options_Skins2)
	self:keepFontStrings(HealBot_Options_ShareSkin)
	self:keepFontStrings(HealBot_Options_Scale)
	self:applySkin(HealBot_Options_Scale, nil)
	self:keepFontStrings(HealBot_Options_HeaderFrame)
	self:applySkin(HealBot_Options_HeaderFrame, nil)	
	self:keepFontStrings(HealBot_Options_Chat)
	self:applySkin(HealBot_Options_Chat, nil)
	self:keepFontStrings(HealBot_Options_ActionAnchor)
	self:keepFontStrings(HealBot_Options_ActionBarsAnchor)
	self:keepFontStrings(HealBot_Options_GenFrame)
	self:applySkin(HealBot_Options_GenFrame, nil)
	self:keepFontStrings(HealBot_Options_BuffTimers)
	self:applySkin(HealBot_Options_BuffTimers, nil)	
	
	self:moveObject(HealBot_Options_ActionBarsCombo, nil, nil, "+", 5)
	self:moveObject(HealBot_Options_CastButton, nil, nil, "+", 5)
	self:moveObject(HealBot_ComboButtons_ButtonText, nil, nil, "+", 12)
	self:moveObject(HealBot_ComboButtons_Button1, nil, nil, "+", 12)
	self:moveObject(HealBot_AutoTarget_ButtonText, nil, nil, "+", 15)
	self:moveObject(HealBot_AutoTrinket_ButtonText, nil, nil, "+", 15)
	self:moveObject(HealBot_Options_Click, nil, nil, "+", 15)
	self:moveObject(HealBot_Options_EnableMouseWheel, nil, nil, "+", 5)
	self:moveObject(HealBot_Options_NewCDebuff, nil, nil, "+", 4)
	self:moveObject(HealBot_Options_NewSkin, nil, nil, "+", 4)
	self:moveObject(HealBot_Options_NewCDebuffBtn, "-", 5, nil, nil)
	self:moveObject(HealBot_Options_NewSkinb, "-", 5, nil, nil)
	self:moveObject(HealBot_Options_NotifyHealMsg, nil, nil, "+", 2)
	self:moveObject(HealBot_Options_NotifyOtherMsg, nil, nil, "+", 3)
			
	self:skinEditBox(HealBot_Options_NotifyChan, {9})
	self:skinEditBox(HealBot_Options_NotifyOtherMsg, {9,10})
	self:skinEditBox(HealBot_Options_NotifyHealMsg, {9,10})
	self:skinEditBox(HealBot_Options_Click, {9})
	self:skinEditBox(HealBot_Options_Shift, {9})
	self:skinEditBox(HealBot_Options_Ctrl, {9})
	self:skinEditBox(HealBot_Options_Alt, {9})
	self:skinEditBox(HealBot_Options_CtrlShift, {9})
	self:skinEditBox(HealBot_Options_AltShift, {9})
	self:skinEditBox(HealBot_Options_NewCDebuff, {9,10})
	self:skinEditBox(HealBot_Options_NewSkin, {9,10})
	
	self:keepFontStrings(HealBot_Options)
	self:applySkin(HealBot_Options, true)
	
end
