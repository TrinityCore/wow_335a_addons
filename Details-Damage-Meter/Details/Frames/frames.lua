function ActionButton_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end

function Main_HelpPlate_Button_OnEnter(self)
	HelpPlateTooltip.ArrowRIGHT:Show();
	HelpPlateTooltip.ArrowGlowRIGHT:Show();
	HelpPlateTooltip:SetPoint("LEFT", self, "RIGHT", 10, 0);
	HelpPlateTooltip.Text:SetText(MAIN_HELP_BUTTON_TOOLTIP)
	HelpPlateTooltip:Show();
end

function Main_HelpPlate_Button_OnLeave(self)
	HelpPlateTooltip.ArrowRIGHT:Hide();
	HelpPlateTooltip.ArrowGlowRIGHT:Hide();
	HelpPlateTooltip:ClearAllPoints();
	HelpPlateTooltip:Hide();
end

--Micro Button alerts
function MicroButtonAlert_OnLoad(self)
	self.Text:SetSpacing(4);
end

