if not Skinner:isAddonEnabled("WoWEquip") then return end

function Skinner:WoWEquip()

	-- Main Frame
	self:addSkinFrame{obj=WoWEquip.frame, kfs=true, x1=-3, y1=3, x2=2, y2=-2}
	
	-- Bonus Frame
	self:skinEditBox{obj=WoWEquip.frame.BonusFrame.LevelInputBox, noMove=true}
	self:skinScrollBar{obj=WoWEquip_BonusScrollFrame}
	
	-- Equip Frame
	self:skinEditBox{obj=WoWEquip_EquipFrame.InputBox, noMove=true}
	self:skinScrollBar{obj=WoWEquip_EquipFrame.ListScrollFrame}
	self:addSkinFrame{obj=WoWEquip_EquipFrame.SearchResultFrame}
	self:addSkinFrame{obj=WoWEquip.EquipFrame, kfs=true, x1=4, y1=-2, x2=-1, y2=3}

	-- Load/Save/Send Frame
	WoWEquip_SaveFrame.NameInputFrame:SetBackdrop(nil)
	self:skinEditBox{obj=WoWEquip_SaveFrame.NameInputBox, noMove=true}
	self:skinScrollBar{obj=WoWEquip_SaveFrame.DescEditScrollFrame}
	self:addSkinFrame{obj=WoWEquip_SaveFrame.DescFrame}
	self:skinScrollBar{obj=WoWEquip_ProfilesScrollFrame}
	self:addSkinFrame{obj=WoWEquip_SaveFrame.ProfilesFrame, kfs=true}
	self:addSkinFrame{obj=WoWEquip_SaveFrame, kfs=true, x1=4, y1=-2, x2=-1, y2=4}
	
end
