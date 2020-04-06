local addon = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local module = addon:NewModule("BottomBar");
----------------------------------------------------------------------------------------------------
local anchor, frame = SUI_AnchorFrame, SpartanUI;
local round = function(num) -- rounds a number to 2 decimal places
	return math.floor( (num*10^2)+0.5) / (10^2);
end;
local updateSpartanScale = function() -- scales SpartanUI based on setting or screen size
	suiChar = suiChar or {};
	if (not suiChar.scale) then -- make sure the variable exists, and auto-configured based on screen size
		local width, height = string.match(GetCVar("gxResolution"),"(%d+).-(%d+)");
		-- local width, height = string.match((({GetScreenResolutions()})[GetCurrentResolution()] or ""), "(%d+).-(%d+)");
		if (tonumber(width) / tonumber(height) > 4/3) then suiChar.scale = 0.92;
		else suiChar.scale = 0.78; end
	end
	if (suiChar.scale ~= round(SpartanUI:GetScale())) then
		frame:SetScale(suiChar.scale);
	end
end;
local updateSpartanOffset = function() -- handles SpartanUI offset based on setting or fubar / titan
	local fubar,offset = 0;
	if suiChar.offset then
		offset = max(suiChar.offset,1);
	else
		for i = 1,4 do
			if (_G["FuBarFrame"..i] and _G["FuBarFrame"..i]:IsVisible()) then
				local bar = _G["FuBarFrame"..i];
				local point = bar:GetPoint(1);
				if point == "BOTTOMLEFT" then fubar = fubar + bar:GetHeight(); 	end
			end
		end
		offset = max(fubar,1);
	end
	if (offset ~= round(anchor:GetHeight())) then anchor:SetHeight(offset); end
end;
local updateSpartanViewport = function() -- handles viewport offset based on settings
	if (suiChar and suiChar.viewport == 1) then
		WorldFrame:SetPoint("BOTTOMRIGHT",frame,"TOPRIGHT",0,-5);
	else
		WorldFrame:SetPoint("BOTTOMRIGHT");
	end
end;

function module:OnInitialize()
	do -- default interface modifications
		FramerateLabel:ClearAllPoints(); FramerateLabel:SetPoint("TOP", "WorldFrame", "TOP", -15, -50);
		MainMenuBar:Hide();
		hooksecurefunc(UIParent,"Hide",function() WorldFrame:SetPoint("BOTTOMRIGHT"); end);
		hooksecurefunc(UIParent,"Show",function()  updateSpartanViewport(); end);
		hooksecurefunc("updateContainerFrameAnchors",function() -- fix bag offsets
			local frame, xOffset, yOffset, screenHeight, freeScreenHeight, leftMostPoint, column
			local screenWidth = GetScreenWidth()
			local containerScale = 1
			local leftLimit = 0
			if ( BankFrame:IsShown() ) then
				leftLimit = BankFrame:GetRight() - 25
			end
			while ( containerScale > CONTAINER_SCALE ) do
				screenHeight = GetScreenHeight() / containerScale
				-- Adjust the start anchor for bags depending on the multibars
				xOffset = 1 / containerScale
				yOffset = 155;
				-- freeScreenHeight determines when to start a new column of bags
				freeScreenHeight = screenHeight - yOffset
				leftMostPoint = screenWidth - xOffset
				column = 1
				local frameHeight
				for index, frameName in ipairs(ContainerFrame1.bags) do
					frameHeight = getglobal(frameName):GetHeight()
					if ( freeScreenHeight < frameHeight ) then
						-- Start a new column
						column = column + 1
						leftMostPoint = screenWidth - ( column * CONTAINER_WIDTH * containerScale ) - xOffset
						freeScreenHeight = screenHeight - yOffset
					end
					freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING
				end
				if ( leftMostPoint < leftLimit ) then
					containerScale = containerScale - 0.01
				else
					break
				end
			end
			if ( containerScale < CONTAINER_SCALE ) then
				containerScale = CONTAINER_SCALE
			end
			screenHeight = GetScreenHeight() / containerScale
			-- Adjust the start anchor for bags depending on the multibars
			xOffset = 1 / containerScale
			yOffset = 154
			-- freeScreenHeight determines when to start a new column of bags
			freeScreenHeight = screenHeight - yOffset
			column = 0
			for index, frameName in ipairs(ContainerFrame1.bags) do
				frame = getglobal(frameName)
				frame:SetScale(containerScale)
				if ( index == 1 ) then
					-- First bag
					frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", -xOffset, (yOffset + (suiChar.offset or 1)) * (suiChar.scale or 1) )
				elseif ( freeScreenHeight < frame:GetHeight() ) then
					-- Start a new column
					column = column + 1
					freeScreenHeight = screenHeight - yOffset
					frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", -(column * CONTAINER_WIDTH) - xOffset, yOffset )
				else
					-- Anchor to the previous bag
					frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING)
				end
				freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING
			end
		end);
		hooksecurefunc(GameTooltip,"SetPoint",function(tooltip,point,parent,rpoint) -- fix GameTooltip offset
			if (point == "BOTTOMRIGHT" and parent == "UIParent" and rpoint == "BOTTOMRIGHT") then
				tooltip:ClearAllPoints();
				tooltip:SetPoint("BOTTOMRIGHT","SpartanUI","TOPRIGHT",0,10);
			end
		end);
	end
	addon.options.args["maxres"] = {
		type = "execute",
		name = "Toggle Default Scales",
		desc = "toggles between widescreen and standard scales",
		func = function()
			if (InCombatLockdown()) then 
				addon:Print(ERR_NOT_IN_COMBAT);
			else
				if (suiChar.scale >= 0.92) or (suiChar.scale < 0.78) then
					suiChar.scale = 0.78;
				else
					suiChar.scale = 0.92;
				end
				addon:Print("Relative Scale set to "..suiChar.scale);
			end
		end
	};
	addon.options.args["scale"] = {
		type = "range",
		name = "Configure Scale",
		desc = "sets a specific scale for SpartanUI between 0.5 and 1",
		min = 0.5, max = 1, step = 0.01, 
		set = function(info,val)
			if (InCombatLockdown()) then 
				addon:Print(ERR_NOT_IN_COMBAT);
			else
				suiChar.scale = min(1,max(0.5,val));
				addon:Print("Relative Scale set to "..suiChar.scale);
			end
		end,
		get = function(info) return suiChar.scale; end
	};
	addon.options.args["offset"] = {
		type = "input",
		name = "Configure Offset",
		desc = "offsets the bottom bar automatically, or on a set value",
		set = function(info,val)
			if (InCombatLockdown()) then 
				addon:Print(ERR_NOT_IN_COMBAT);
			else
				if (val == "") or (val == "auto") then
					suiChar.offset = nil;
					addon:Print("Panel Offset set to AUTO");
				else
					val = tonumber(val);
					if (type(val) == "number") then
						val = max(0,val);						
						suiChar.offset = max(val+1,1);					
						addon:Print("Panel Offset set to "..val);
					end
				end
			end
		end,
		get = function(info) return suiChar.offset; end
	};
	addon.options.args["viewport"] = {
		type = "execute",
		name = "Toggle Dynamic Viewport",
		desc = "toggles between dyamic and static viewports",
		func = function()
			if (InCombatLockdown()) then 
				addon:Print(ERR_NOT_IN_COMBAT);
			else
				if (suiChar.viewport == 1) then
					suiChar.viewport = 0;
					addon:Print("Dynamic Viewport Disabled");
				else -- this catches both nil and 0 values for suiChar.viewport
					suiChar.viewport = 1;
					addon:Print("Dynamic Viewport Enabled");
				end
				updateSpartanViewport();
			end
		end
	};
end
function module:OnEnable()
	anchor:SetFrameStrata("BACKGROUND"); anchor:SetFrameLevel(1);
	frame:SetFrameStrata("BACKGROUND"); frame:SetFrameLevel(1);
	
	updateSpartanScale();
	updateSpartanOffset();
	updateSpartanViewport();
	
	anchor:SetScript("OnUpdate",function()
		if (InCombatLockdown()) then return; end
		updateSpartanScale();
		updateSpartanOffset();
	end);
end
