if not Skinner:isAddonEnabled("Auctionsnatch") then return end

function Skinner:Auctionsnatch()

	AS.mainframe.closebutton:SetHeight(16)
	AS.mainframe.closebutton:SetText("X")
	self:skinEditBox{obj=AS.mainframe.headerframe.editbox, regs={9}, noWidth=true, x=-14}
	AS.mainframe.headerframe.additembutton:SetWidth(80)
	self:moveObject{obj=AS.mainframe.headerframe.additembutton, x=-4, y=7}
	self:skinScrollBar{obj=AS.mainframe.listframe.scrollbarframe}
	self:addSkinFrame{obj=ASmainframe, y1=2, x2=2}
	-- Option frame (appears on right click on an item in the list)
	self:addSkinFrame{obj=AS.optionframe}
	-- DropDown frame (below frame)
	self:skinDropDown{obj=ASdropDownMenu}
	-- Prompt frame
	AS.prompt.icon:SetNormalTexture(self.esTex)
	self:skinEditBox{obj=AS.prompt.priceoverride, regs={9}}
	self:skinAllButtons{obj=ASpromptframe, x1=-6, x2=6}
	self:addSkinFrame{obj=ASpromptframe, nb=true}

end
