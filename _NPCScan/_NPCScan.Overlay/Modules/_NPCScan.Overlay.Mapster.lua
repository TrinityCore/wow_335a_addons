--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * _NPCScan.Overlay.Mapster.lua - Adjusts WorldMap module with Mapster.       *
  ****************************************************************************]]


--------------------------------------------------------------------------------
-- Function Hooks / Execution
-----------------------------

if ( IsAddOnLoaded( "Mapster" ) ) then
	local Toggle = _NPCScan.Overlay.WorldMap.Toggle;
	local Mapster = LibStub( "AceAddon-3.0" ):GetAddon( "Mapster" );

	local function UpdateTogglePosition () -- Moves the checkbox so it doesn't overlap Mapster's stuff
		Toggle:ClearAllPoints();
		if ( WorldMapFrame.sizedDown ) then -- Bottom right corner of map
			local Label = _G[ Toggle:GetName().."Text" ];
			Toggle:SetPoint( "BOTTOM", MapsterOptionsButton, 0, -2 );
			Toggle:SetPoint( "RIGHT", WorldMapDetailFrame, -Label:GetStringWidth() - 12, 0 );
		else -- Left side, near Mapster options button
			Toggle:SetPoint( "LEFT", MapsterOptionsButton, "RIGHT", 8, 0 );
		end
	end

	-- Hook size up/down commands once Mapster creates its options button
	hooksecurefunc( Mapster, "OnEnable", function ()
		-- Options button created
		hooksecurefunc( Mapster, "SizeUp", UpdateTogglePosition );
		hooksecurefunc( Mapster, "SizeDown", UpdateTogglePosition );
		UpdateTogglePosition();
	end );
end
