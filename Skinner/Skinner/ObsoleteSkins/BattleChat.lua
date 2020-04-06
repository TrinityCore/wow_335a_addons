
function Skinner:BattleChat()

	self:applySkin(BattleChat.frame)
	BattleChat.frame:SetBackdropColor(0, 0, 0, BattleChat.db.profile.alpha * 0.01)
	BattleChat.frame:SetBackdropBorderColor(0, 0, 0, BattleChat.db.profile.alpha * 0.01 * 4/3)

end
