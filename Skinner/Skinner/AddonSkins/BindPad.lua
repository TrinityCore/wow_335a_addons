if not Skinner:isAddonEnabled("BindPad") then return end

function Skinner:BindPad()

-->>-- Main frame
	self:skinFFToggleTabs("BindPadFrameTab", 4)
-->>-- Tabs (side)
	for i = 1, 5 do
		self:removeRegions(_G["BindPadProfileTab"..i], {1}) -- N.B. other regions are icon and highlight
	end
	-- plus buttons
	for i = 1, 42 do
		self:skinButton{obj=_G["BindPadSlot"..i.."AddButton"], mp2=true, plus=true}
	end
	self:addSkinFrame{obj=BindPadFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}
-->>-- Bind frame
	self:addSkinFrame{obj=BindPadBindFrame, kfs=true, hdr=true}
-->>-- Macro Popup frame
	self:skinEditBox{obj=BindPadMacroPopupEditBox}
	self:skinScrollBar{obj=BindPadMacroPopupScrollFrame}
	self:addSkinFrame{obj=BindPadMacroPopupFrame, ft=ftype, kfs=true, x1=8, y1=-8, x2=-2, y2=4}
-->>-- Macro Text frame
	self:skinScrollBar{obj=BindPadMacroTextFrameScrollFrame}
	BindPadMacroTextFrameTextBackground:SetAlpha(0)
	self:addSkinFrame{obj=BindPadMacroTextFrame, kfs=true, x1=10, y1=-12, x2=-32, y2=71}

end
