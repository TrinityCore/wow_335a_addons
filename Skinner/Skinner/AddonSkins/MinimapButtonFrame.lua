if not Skinner:isAddonEnabled("MinimapButtonFrame") then return end

function Skinner:MinimapButtonFrame()

	self:applySkin(MBFRestoreButtonFrame)
	self:applySkin(MinimapButtonFrame)

	-- create a button skin
	MBFAddSkin("Skinner", nil, nil, 35)

	MinimapButtonFrame.SetBackdropColor = function() end
	MinimapButtonFrame.SetBackdropBorderColor = function() end

end
