if not Skinner:isAddonEnabled("Chatr") then return end

function Skinner:Chatr()

	Chatr_BGColor = CopyTable(self.bColour)
	Chatr_BorderColor = CopyTable(self.bbColour)

	for i = 1, 20 do
		local cf = "Chatr"..i
		self:skinButton{obj=_G[cf.."Close"], cb=true}
		self:addSkinFrame{obj=_G[cf], nb=true}
		self:skinEditBox{obj=_G[cf.."EditBox"], regs={9}}
	end

	self:moveObject{obj=ChatrOptionsTitle, y=13}
	self:skinEditBox{obj=ChatrOptionsFmt, regs={9}}
	self:skinEditBox{obj=ChatrOptionsFmt2, regs={9}}
	self:addSkinFrame{obj=ChatrOptions, y1=5, x2=5, y2=7}

	if IsAddOnLoaded("ChatrAlterEgo") then
		self:skinScrollBar{obj=ChatrAlterEgoOptionsScrollFrame}
		ChatrAlterEgoOptionsScrollFrame:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=ChatrAlterEgoOptions, x1=2, y1=5, x2=-2}
	end
	if IsAddOnLoaded("ChatrBacklog") then
		self:addSkinFrame{obj=ChatrBacklogOptions, x1=2, y1=5, x2=-2}
	end
	if IsAddOnLoaded("ChatrBuddies") then
		self:addSkinFrame{obj=ChatrBuddiesFrame}
		self:addSkinFrame{obj=ChatrBuddiesOptions, x1=2, y1=5, x2=-2}
		self:skinEditBox{obj=ChatrBuddiesCustom, regs={9}}
	end
	if IsAddOnLoaded("ChatrChanneler") then
		self:addSkinFrame{obj=ChatrChannelerOptions, x1=2, y1=5, x2=-2}
	end
	if IsAddOnLoaded("ChatrCrayons") then
		self:skinScrollBar{obj=ChatrCrayonsOptionsScrollFrame}
		ChatrCrayonsOptionsScrollFrame:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=ChatrCrayonsOptions, x1=2, y1=5, x2=-2}
		self:addSkinFrame{obj=ChatrCrayonsHelp, y1=5}
	end
	if IsAddOnLoaded("ChatrFilter") then
		self:addSkinFrame{obj=ChatrFilterOptions, x1=2, y1=5, x2=-2}
		self:skinScrollBar{obj=ChatrFilterOptionsScrollFrame}
		ChatrFilterOptionsScrollFrame:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=ChatrFilterHelp, y1=5}
	end
	-- Menu
	self:skinAllButtons{obj=ChatrMenu}
	-- Dock
	self:skinButton{obj=ChatrDockClose, x1=-2, x2=2}
	for i = 1, 20 do
		self:skinButton{obj=_G["ChatrDockBtn"..i], y2=4}
	end

end
