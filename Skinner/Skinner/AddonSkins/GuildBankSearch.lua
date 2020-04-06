if not Skinner:isAddonEnabled("GuildBankSearch") then return end

function Skinner:GuildBankSearch()
	if not self.db.profile.GuildBankUI then return end

	local GBS = GuildBankSearch
	self:moveObject{obj=self:getChild(GBS, 9), x=-1, y=-1}
	self:skinEditBox{obj=GBS.NameEditBox, regs={9}}
	self:skinDropDown{obj=GBS.QualityMenu}
	self:skinEditBox{obj=GBS.ItemLevelMinEditBox, regs={9}}
	self:skinEditBox{obj=GBS.ItemLevelMaxEditBox, regs={9}}
	self:skinEditBox{obj=GBS.ReqLevelMaxEditBox, regs={9}}
	self:skinEditBox{obj=GBS.ReqLevelMinEditBox, regs={9}}
	self:addSkinFrame{obj=GBS.CategorySection}
	self:skinDropDown{obj=GBS.TypeMenu}
	self:skinDropDown{obj=GBS.SubTypeMenu}
	self:skinDropDown{obj=GBS.SlotMenu}
	self:addSkinFrame{obj=GuildBankSearch, kfs=true, x1=-2, y1=-4, x2=-3, y2=2}

end
