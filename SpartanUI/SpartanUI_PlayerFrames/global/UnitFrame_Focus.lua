local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local addon = spartan:GetModule("PlayerFrames");
----------------------------------------------------------------------------------------------------
oUF:SetActiveStyle("Spartan_PlayerFrames");

local focus = oUF:Spawn("focus","SUI_FocusFrame");
addon.focus = focus; addon.focus:SetPoint("CENTER",UIParent,"CENTER");

do -- scripts to make it movable
	focus.mover = CreateFrame("Frame");	
	focus.mover:SetWidth(220); focus.mover:SetHeight(90);
	focus.mover:SetPoint("CENTER",focus,"CENTER");	
	focus.mover:EnableMouse(true);
	
	focus.bg = focus.mover:CreateTexture(nil,"BACKGROUND");
	focus.bg:SetAllPoints(focus.mover);
	focus.bg:SetTexture(1,1,1,0.2);
	
	focus.mover:SetScript("OnMouseDown",function(self,button)
		if button == "RightButton" then
			ToggleDropDownMenu(1, nil, FocusFrameDropDown, 'cursor');
		else
			focus.isMoving = true;
			suiChar.PlayerFrames.focusMoved = true;
			focus:SetMovable(true);
			focus:StartMoving();
		end
	end);
	focus.mover:SetScript("OnMouseUp",function()
		if focus.isMoving then
			focus.isMoving = nil;
			focus:StopMovingOrSizing();
		end
	end);
	focus.mover:SetScript("OnHide",function()
		focus.isMoving = nil;
		focus:StopMovingOrSizing();
	end);
	focus.mover:SetScript("OnEvent",function()
		if (FocusFrame_IsLocked()) then
			focus.mover:Hide();
		else
			if (event == "PLAYER_REGEN_DISABLED") then
				focus.mover:Hide();
				focus.mover:RegisterEvent("PLAYER_REGEN_ENABLED");
			elseif (event == "PLAYER_REGEN_ENABLED") then
				focus.mover:Show();
				focus.mover:UnregisterEvent("PLAYER_REGEN_ENABLED");
			end
		end			
	end);
	focus.mover:RegisterEvent("VARIABLES_LOADED");
	focus.mover:RegisterEvent("PLAYER_REGEN_DISABLED");
	hooksecurefunc("FocusFrame_SetLock",function(toggle)
		if (toggle) then
			focus.mover:Hide();
		else
			focus.mover:Show();
		end
	end);
	
	function addon:UpdateFocusPosition()
		if suiChar.PlayerFrames.focusMoved then
			focus:SetMovable(true);
		else
			focus:SetMovable(false);
			focus:SetPoint("BOTTOMLEFT",SpartanUI,"TOP",200,200);
		end
	end	
	addon:UpdateFocusPosition();
end
