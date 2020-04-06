if not Skinner:isAddonEnabled("PartyBuilder") then return end

function Skinner:PartyBuilder()

	local pbFrame = PartyBuilder_Zone_DropDown:GetParent():GetParent()
	
	-- SloganBox
	self:addSkinFrame{obj=self:getChild(pbFrame, 1), kfs=true}
	-- Invitation
	self:skinEditBox{obj=PartyBuilderInvitationTextBox, regs={9}, noHeight=true}
	-- Decline
	self:skinEditBox{obj=PartyBuilderDeclineTextBox, regs={9}}
	
	-- Main selector frame	
	local sFrame = PartyBuilder_Zone_DropDown:GetParent()
	self:addSkinFrame{obj=sFrame, kfs=true}
	-- Zone Selection
	self:skinDropDown{obj=PartyBuilder_Zone_DropDown}
	self:addSkinFrame{obj=PartyBuilder_Zone_DropDown.Menu, kfs=true}
	self:skinScrollBar{obj=PartyBuilderZoneScrollFrame}

	-- Who List
	self:skinScrollBar{obj=PartyBuilderWhoListScrollFrame}
	self:addSkinFrame{obj=PartyBuilderWhoListScrollFrame, kfs=true}
	self:addSkinFrame{obj=PartyBuilderWhoList, kfs=true}

	-- Message List
	self:skinScrollBar{obj=PartyBuilderMsgListScrollFrame}
	self:addSkinFrame{obj=PartyBuilderMsgListScrollFrame, kfs=true}
	self:addSkinFrame{obj=PartyBuilderMsgList, kfs=true}
	
	-- Blacklist
	self:skinScrollBar{obj=PartyBuilderBlacklistScrollFrame}
	self:addSkinFrame{obj=PartyBuilderBlacklistScrollFrame, kfs=true}
	
end
