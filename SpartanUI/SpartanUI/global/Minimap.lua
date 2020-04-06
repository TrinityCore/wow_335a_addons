local addon = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local module = addon:NewModule("Minimap");
----------------------------------------------------------------------------------------------------
local map, Update_BattlefieldMinimap, Update_ArenaEnemyFrames, Update_MinimapButtons;
local checkThirdParty = function()
	local point, relativeTo, relativePoint, x, y = MinimapCluster:GetPoint();
	if (relativeTo ~= UIParent) then return true; end -- a third party minimap manager is involved
end
local updateButtons = function()
	if (not MouseIsOver(MinimapCluster)) and (suiChar.MapButtons) then
		GameTimeFrame:Hide();
		MiniMapTracking:Hide();
		MinimapZoomIn:Hide();
		MinimapZoomOut:Hide();
		MiniMapWorldMapButton:Hide();
	else
		GameTimeFrame:Show();
		MiniMapTracking:Show();
		MinimapZoomIn:Show();
		MinimapZoomOut:Show();
		MiniMapWorldMapButton:Show();
	end
end

function module:OnInitialize()
	addon.options.args["minimap"] = {
		name = "toggle Minimap Button Hiding", type="input",
		get = function(info) return suiChar and suiChar.MapButtons; end,
		set = function(info,val)
			if (val == "" and suiChar.MapButtons == true) or (val == "off") then
				suiChar.MapButtons = nil;
				addon:Print("Minimap Button Hiding Disabled");
			elseif (val == "" and not suiChar.MapButtons) or (val == "on") then
				suiChar.MapButtons = true;
				addon:Print("Minimap Button Hiding Enabled");
			end
		end
	};
end
function module:OnEnable()
	if (checkThirdParty()) then return; end
	map = CreateFrame("Frame");
	Update_BattlefieldMinimap = function()
		if ( BattlefieldMinimapTab and not BattlefieldMinimapTab:IsUserPlaced() ) then
			BattlefieldMinimapTab:ClearAllPoints()
			BattlefieldMinimapTab:SetPoint("RIGHT", "UIParent", "RIGHT",-144,150);
		end
	end
	Update_ArenaEnemyFrames = function()
		if ( ArenaEnemyFrames ) then
			ArenaEnemyFrames:ClearAllPoints();
			ArenaEnemyFrames:SetPoint("RIGHT", UIParent, "RIGHT",0,40);
		end
	end
	do -- minimap overlay		
		local overlay = Minimap:CreateTexture(nil,"OVERLAY");
		overlay:SetWidth(228); overlay:SetHeight(228); 
		overlay:SetPoint("CENTER");
		overlay:SetTexture("Interface\\AddOns\\SpartanUI\\media\\map_overlay");
		overlay:SetBlendMode("ADD");
	end
	do -- minimap coordinates
		MinimapZoneTextButton:ClearAllPoints();
		MinimapZoneTextButton:SetPoint("BOTTOM","SpartanUI","BOTTOM",0,24);		
		map.coords = MinimapZoneTextButton:CreateFontString(nil,"BACKGROUND","GameFontNormalSmall");
		map.coords:SetWidth(128); map.coords:SetHeight(12);
		map.coords:SetPoint("TOP","MinimapZoneTextButton","BOTTOM");
		map:HookScript("OnUpdate", function()
			updateButtons();
			do -- update minimap coordinates
				local x,y = GetPlayerMapPosition("player");
				if (not x) or (not y) then return; end
				map.coords:SetText(format("%.1f, %.1f",x*100,y*100));
			end
		end);
		map:HookScript("OnEvent",function()
			if (event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA") then
				if IsInInstance() then map.coords:Hide() else map.coords:Show() end
				if (WorldMapFrame:IsVisible()) then SetMapToCurrentZone(); end
			elseif (event == "ADDON_LOADED") then
				print(arg1);			
			end
			local LastFrame = UIErrorsFrame;
			for i = 1, NUM_EXTENDED_UI_FRAMES do
				local bar = _G["WorldStateCaptureBar"..i];
				if (bar and bar:IsShown()) then 			
					bar:ClearAllPoints();
					bar:SetPoint("TOP",LastFrame,"BOTTOM");			
					LastFrame = self;
				end
			end
		end);
	end
	do -- minimap modifications
		MinimapBorderTop:Hide();
		if (MinimapToggleButton) then -- this will occur on versions prior to 3.3.0
			MinimapToggleButton:Hide();
			GameTimeFrame:SetScale(0.6); GameTimeFrame:ClearAllPoints(); GameTimeFrame:SetPoint("TOPRIGHT",5,-5);
			MiniMapTracking:SetScale(0.8); MiniMapTracking:ClearAllPoints(); MiniMapTracking:SetPoint("TOPLEFT",20,-36);		
		end
		MinimapBorder:SetAlpha(0); 
		MinimapBackdrop:ClearAllPoints();
		MinimapBackdrop:SetPoint("CENTER","MinimapCluster","CENTER",-10,-24);		
		Minimap:ClearAllPoints();
		Minimap:SetPoint("CENTER","MinimapCluster","CENTER",0,2);
		MinimapCluster:ClearAllPoints();
		MinimapCluster:SetParent("SpartanUI");
		MinimapCluster:SetPoint("BOTTOM","SpartanUI","BOTTOM",0,20)
		MinimapCluster:SetScale(1.1);
		MinimapCluster:SetMovable(true);
		MinimapCluster:SetUserPlaced(true);
		MinimapCluster:EnableMouseWheel(true);
		MinimapCluster:SetScript("OnMouseWheel",function()
			if (arg1 > 0) then Minimap_ZoomIn()
			else Minimap_ZoomOut() end
		end);
	end
	do -- child frame modifications
		VehicleSeatIndicator:ClearAllPoints();
		VehicleSeatIndicator:SetPoint("RIGHT","UIParent","RIGHT",0,0);
		TemporaryEnchantFrame:ClearAllPoints();
		TemporaryEnchantFrame:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT",-10,-10);
	end
	hooksecurefunc(VehicleSeatIndicator,"SetPoint",function(_,_,parent) -- vehicle seat indicator
		if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
			VehicleSeatIndicator:ClearAllPoints();
			VehicleSeatIndicator:SetPoint("BOTTOMRIGHT","SpartanUI","TOPRIGHT",-5,5);
		end
	end);
	hooksecurefunc(WatchFrame,"SetPoint",function(_,_,parent) -- quest watch frame
		if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
			-- this only happens if the user isn't using the advanced quest watcher
			WatchFrame:ClearAllPoints();
			WatchFrame:SetPoint("TOPRIGHT","UIParent","TOPRIGHT",-4,-130);
			WatchFrame:SetPoint("BOTTOMRIGHT","UIParent","BOTTOMRIGHT",-4,160);
		end
	end);
	hooksecurefunc(DurabilityFrame,"SetPoint",function(self,_,parent) -- durability frame
		if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
			DurabilityFrame:ClearAllPoints();
			DurabilityFrame:SetPoint("BOTTOM","SpartanUI","TOP",0,70);
		end
	end);
	hooksecurefunc("AchievementAlertFrame_ShowAlert",function() -- achivement alerts
		if (AchievementAlertFrame1) then AchievementAlertFrame1:SetPoint("BOTTOM",UIParent,"CENTER"); end
	end);
	hooksecurefunc("UIParent_ManageFramePositions",function()
		Update_BattlefieldMinimap();
		Update_ArenaEnemyFrames();			
	end);	
	hooksecurefunc("ToggleBattlefieldMinimap",Update_BattlefieldMinimap);
	map:RegisterEvent("ZONE_CHANGED");
	map:RegisterEvent("ZONE_CHANGED_INDOORS");
	map:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	map:RegisterEvent("UPDATE_WORLD_STATES");	
	map:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");	
	map:RegisterEvent("PLAYER_ENTERING_WORLD");
	map:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
	map:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE");
end
