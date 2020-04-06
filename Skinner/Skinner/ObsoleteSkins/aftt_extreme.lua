
function Skinner:aftt_extreme()

	bd = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	}

	self:applySkin(aftt_descriptFrame, nil, nil, nil, nil, bd)
	self:applySkin(aftt_targettargetframe, nil, nil, nil, nil, bd)
	self:applySkin(aftt_tooltipFrame, nil, nil, nil, nil, bd)

end
