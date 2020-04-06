local _G = getfenv(0)

function Skinner:CECB_Options()

	self:keepFontStrings(CECBOptionsFrame)
	self:moveObject(CECBOptionsFrameText, nil, nil, "-", 6)
	self:moveObject(CECBOptionsFrameCECB_status_check, nil, nil, "-", 6)
	self:moveObject(CECBOptionsFrameX, "+", 8, "+", 16)
	self:moveObject(CECBOptionsFrameHelp, nil, nil, "-", 6)
	self:applySkin(CECBOptionsFrame)

-->>--	Defaults Frame
	self:keepFontStrings(CECBApplyResetFrame)
	self:moveObject(CECBApplyResetFrameText, nil, nil, "-", 6)
	self:applySkin(CECBApplyResetFrame)

-->>--	Colours Frame
	self:keepFontStrings(CECBPickColorOptions)
	self:moveObject(CECBPickColorOptionsHeadline, nil, nil, "-", 6)
	self:applySkin(CECBPickColorOptions)

-->>--	Profiles Frame
	self:keepFontStrings(NECBProfilesFrame)
	self:moveObject(NECBProfilesFrameText, nil, nil, "-", 6)

	self:skinEditBox(NECBProfilesFrame_EditBox1, {9})
	self:skinEditBox(NECBProfilesFrame_EditBox2, {9})
	self:skinEditBox(NECBProfilesFrame_EditBox3, {9})
	self:skinEditBox(NECBProfilesFrame_EditBox4, {9})
	self:skinEditBox(NECBProfilesFrame_EditBox5, {9})
	self:applySkin(NECBProfilesFrame)

-->>--	Help Frame
	self:keepFontStrings(CECBHELPFrame)
	self:moveObject(CECBHELPFrameText, nil, nil, "-", 6)
	self:keepFontStrings(CECBHELPFrameScrollFrame)
	self:skinScrollBar(CECBHELPFrameScrollFrame)
	self:applySkin(CECBHELPFrame)

end

function Skinner:CEnemyCastBar()

	for i = 1, 18 do
		self:glazeStatusBar(_G["Carni_ECB_"..i.."_StatusBar"], 0)
	end
	self:glazeStatusBar(CECB_FPSBarFree_StatusBar, 0)
	self:glazeStatusBar(CECB_LatencyBarFree_StatusBar, 0)

end
