if not Skinner:isAddonEnabled("InventoryOnPar") then return end

function Skinner:InventoryOnPar()

-->>--	UI Frame
	self:skinScrollBar{obj=InventoryOnParUIFrameTableScrollFrame}
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerInfo)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderScore)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerName)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerLevel)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerClass)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerGuild)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderLastSeen)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderIOPScore)
	self:addSkinFrame{obj=InventoryOnParUIFrameTable, kfs=true}
	self:moveObject{obj=InventoryOnParUIFrameTitleText, y=-6}
	self:addSkinFrame{obj=InventoryOnParUIFrame, kfs=true, x1=10, x2=-10, y2=10}

-->>--	PaperDoll Frame
	self:addSkinFrame{obj=IOP_PaperDollFrame, kfs=true, x1=10, y1=-12, x2=-33, y2=12}

-->>--	Option Frame
	self:skinDropDown{obj=InventoryOnParOptionDropDownUpdateMinutes}
	self:skinEditBox{obj=InventoryOnParOptionMinLevel, regs={9}}
	self:skinEditBox{obj=InventoryOnParOptionMaxLevel, regs={9}}
	self:skinEditBox{obj=InventoryOnParOptionDateFormat, regs={9}}
	self:moveObject{obj=InventoryOnParOptionFrameTitleText, y=-6}
	self:addSkinFrame{obj=InventoryOnParOptionFrame, kfs=true}

end
