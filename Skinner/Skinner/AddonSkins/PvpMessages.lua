if not Skinner:isAddonEnabled("PvpMessages") then return end

function Skinner:PvpMessages()

-->>--	BG Message Frame
	self:applySkin(BgMsg_Frame)
	self:skinEditBox(BgMsg_EditBox, {9})
	self:moveObject(BgMsg_EditBox, nil, nil, "-", 5)
-->>--	Config Frame
	self:keepFontStrings(PvPMsg_Config_Frame)
	self:applySkin(PvPMsg_Config_Frame)
--	PvPMsgConfigFrameHeader:Hide()
	self:moveObject(self:getRegion(PvPMsg_Config_Frame, 2), nil, nil, "-", 8)
-->>--	WSG Frame
	self:applySkin(PvPMsg_WSG_Frame)

end
