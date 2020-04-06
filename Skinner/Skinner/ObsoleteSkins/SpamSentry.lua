
function Skinner:SpamSentry()

	self:moveObject(OpenMailReportButton, nil, nil, "-", 10)

end

function Skinner:SpamSentry_report()

	self:keepFontStrings(SpamSentryUI)
	self:keepFontStrings(SpamSentryUIScrollFrame)
	self:skinScrollBar(SpamSentryUIScrollFrame)
	SpamSentryUIIcon:SetAlpha(1)
	self:applySkin(SpamSentryUI)
-->>--	Ticket UI
	self:keepFontStrings(SpamSentryTicketUI)
	self:keepFontStrings(SpamSentryTicketUIScrollFrame)
	self:skinScrollBar(SpamSentryTicketUIScrollFrame)
	SpamSentryTicketUIIcon:SetAlpha(1)
	self:applySkin(SpamSentryTicketUI)

end
