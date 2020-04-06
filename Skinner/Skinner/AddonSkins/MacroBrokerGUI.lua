if not Skinner:isAddonEnabled("MacroBrokerGUI") then return end

function Skinner:MacroBrokerGUI()

	self:skinScrollBar{obj=MacroBroker_MacroButtonScrollFrame}
	self:skinButton{obj=MacroBrokerGUIFrameEditButton}
	self:skinScrollBar{obj=MacroBrokerGUIFrameScrollFrame}
	self:addSkinFrame{obj=MacroBrokerGUIFrameTextBackground, y2=2}
	self:skinFFToggleTabs("MacroBrokerGUIFrameTab", 2)
	self:skinButton{obj=MacroBrokerGUIFrameEditButton}
	self:skinButton{obj=MacroBrokerGUIFrameDeleteButton}
	self:skinButton{obj=MacroBrokerGUIFrameNewButton}
	self:skinButton{obj=MacroBrokerGUIFrameExitButton}
	self:skinButton{obj=MacroBrokerGUIFrameCloseButton, cb=true}
	self:skinEditBox{obj=MacroBrokerGUI_LabelEditBox}
	self:skinEditBox{obj=MacroBrokerGUI_TextEditBox}
	self:addSkinFrame{obj=MacroBrokerGUIFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}

-->>-- Icon Popup
	self:skinEditBox{obj=MacroBrokerGUI_IconPopupEditBox, x=-5}
	self:skinScrollBar{obj=MacroBrokerGUI_IconPopupScrollFrame}
	self:skinButton{obj=MacroBrokerGUI_IconPopupCancelButton}
	self:skinButton{obj=MacroBrokerGUI_IconPopupOkayButton}
	self:addSkinFrame{obj=MacroBrokerGUI_IconPopupFrame, kfs=true, x1=8, y1=-8, x2=-2, y2=4}

end
