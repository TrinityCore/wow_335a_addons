if not Skinner:isAddonEnabled("AnnounceIt") then return end

function Skinner:AnnounceIt()

	self:skinEditBox{obj=AnnounceItSetMessage_Text1, regs={9}}
	self:skinEditBox{obj=AnnounceItSetMessage_Text2, regs={9}}
	self:skinEditBox{obj=AnnounceItSetMessage_Text3, regs={9}}
	self:skinEditBox{obj=AnnounceItSetMessage_Text4, regs={9}}
	self:skinEditBox{obj=AnnounceItSetMessage_Text5, regs={9}}
	self:skinEditBox{obj=AnnounceItSetMessage_Label, regs={9}}
	self:skinButton{obj=AnnounceItSetMessageApply}
	self:skinButton{obj=AnnounceItSetMessageReset}
	self:addSkinFrame{obj=AnnounceItSetMessage}

end
