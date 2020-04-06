if not Skinner:isAddonEnabled("DaemonMailAssist") then return end

function Skinner:DaemonMailAssist()

	self:skinButton{obj=sizeBtn}
	self:skinDropDown{obj=ddlSenders}
	self:skinButton{obj=btnGrab}
	RMAInboxComponent10:SetAlpha(0)
	self:addSkinFrame{obj=RMAInbox}

	self:addSkinFrame{obj=RMAOutboxPanel1, y2=-3}
	RMAOutboxPanel1Container1:SetBackdrop(nil)
	self:skinSlider{obj=slGuild}
	self:addSkinFrame{obj=txtGuild}
	self:skinSlider{obj=slFriends}
	self:addSkinFrame{obj=txtFriends}
	self:skinSlider{obj=slRecent}
	self:addSkinFrame{obj=txtRecent}
	
end
