local addon = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local module = addon:NewModule("StatusBars");
----------------------------------------------------------------------------------------------------
suiChar.tipHover = suiChar.tipHover or 0;

local tooltip, xpframe, repframe;
local FACTION_BAR_COLORS = {
	[1] = {r = 1, g = 0.2, b = 0},
	[2] = {r = 0.8, g = 0.3, b = 0},
	[3] = {r = 0.8, g = 0.2, b = 0},
	[4] = {r = 1, g = 0.8, b = 0},
	[5] = {r = 0, g = 1, b = 0.1},
	[6] = {r = 0, g = 1, b = 0.2},
	[7] = {r = 0, g = 1, b = 0.3},
	[8] = {r = 0, g = 0.6, b = 0.1},
};
local GetFactionDetails = function(name)
	if (not name) then return; end
	local description = " ";
	for i = 1,GetNumFactions() do
		if name == GetFactionInfo(i) then
			_,description = GetFactionInfo(i)
		end
	end
	return description;
end

function module:OnInitialize()
	addon.options.args["tooltip"] = {
	type = "execute",
	name = "Change Tooltip Behavior",
	desc = "toggles between tooltip mechanics for the xp and rep bars",
	func = function()
		if (suiChar and suiChar.tipHover == 1) then
			suiChar.tipHover = 0;
			addon:Print("Tooltip Behavior set to OnClick");
		else
			suiChar.tipHover = 1;
			addon:Print("Tooltip Behavior set to OnMouseover");
		end
	end
	};
end
function module:OnEnable()
	do -- create the tooltip
		tooltip = CreateFrame("Frame","SUI_StatusBarTooltip",SpartanUI,"SUI_StatusBars_TooltipTemplate");
		tooltip:SetScript("OnHide",function()
			SUI_StatusBarTooltipHeader:SetText""
			SUI_StatusBarTooltipText:SetText""
		end);
		SUI_StatusBarTooltipHeader:SetJustifyH("LEFT");
		SUI_StatusBarTooltipText:SetJustifyH("LEFT");
		SUI_StatusBarTooltipText:SetJustifyV("TOP");
	end
	do -- experience bar
		local xptip1 = string.gsub(EXHAUST_TOOLTIP1,"\n"," "); -- %s %d%% of normal experience gained from monsters. (replaced single breaks with space)
		local xptip2 = string.gsub(EXHAUST_TOOLTIP3,"\n\n",""); -- In this condition, you can get\n%d more monster experience\nbefore the next rest state. (removed double break)
		xptip2 = string.gsub(xptip2,"\n"," "); -- In this condition, you can get %d more monster experience before the next rest state. (replaced single breaks with space)
		local XP_LEVEL_TEMPLATE = "(%d / %d) %d%% "..COMBAT_XP_GAIN; -- use Global Strings and regex to make the level string work in any locale
		local xprest = TUTORIAL_TITLE26.." (%d%%) -"; -- Rested (%d%%) -
	
		xpframe = CreateFrame("Frame","SUI_ExperienceBar",SpartanUI,"SUI_StatusBars_XPTemplate");
		xpframe:SetPoint("BOTTOMRIGHT","SpartanUI","BOTTOM",-80,0);
	
		SUI_ExperienceBarFill:SetVertexColor(0,0.6,1,0.7);
		SUI_ExperienceBarFillGlow:SetVertexColor(0,0.6,1,0.5);
		SUI_ExperienceBarLead:SetVertexColor(0,0.6,1,0.7);	
		SUI_ExperienceBarLeadGlow:SetVertexColor(0,0.6,1,0.5);
		
		local showTooltip = function()
			tooltip:ClearAllPoints();
			tooltip:SetPoint("BOTTOM",xpframe,"TOP",6,-1);
			SUI_StatusBarTooltipHeader:SetText(format(FRIENDS_LEVEL_TEMPLATE,UnitLevel("player"),format(XP_LEVEL_TEMPLATE,UnitXP("player"),UnitXPMax("player"),(UnitXP("player")/UnitXPMax("player")*100)))); -- Level 99 (9999 / 9999) 100% Experience
			-- talk about complicated. The string I was using got changed in 3.2; Hopefully this one stays put. Using GlobalStrings is important for cross-locale support, but it makes for some debugging when something changes in a patch
			local rested,text = GetXPExhaustion() or 0;
			if (rested > 0) then
				text = format(xptip1,format(xprest,(rested/UnitXPMax("player"))*100),200); -- Rested (15%) - 200% of normal experience gained from monsters.
				SUI_StatusBarTooltipText:SetText(format("%s "..xptip2,text,rested)); -- Rested (15%) - 200% of normal experience gained from monsters. In this condition, you can get 4587 more monster experience before the next rest state.
			else
				SUI_StatusBarTooltipText:SetText(format(xptip1,EXHAUST_TOOLTIP2,100)); -- You should rest at an Inn. 100% of normal experience gained from monsters.
			end
			tooltip:Show();
		end
		xpframe:SetScript("OnEnter",function()
			if (suiChar and suiChar.tipHover == 1) then showTooltip(); end
		end);
		xpframe:SetScript("OnLeave",function()
			tooltip:Hide();
		end);
		xpframe:SetScript("OnMouseDown",function()
			if (tooltip:IsVisible()) then tooltip:Hide();
			elseif (suiChar and suiChar.tipHover == 0) then showTooltip(); end
		end);
		xpframe:SetScript("OnEvent",function()
			local level,rested,now,goal = UnitLevel("player"),GetXPExhaustion() or 0,UnitXP("player"),UnitXPMax("player");
			if now == 0 then
				SUI_ExperienceBarFill:SetWidth(0.1);
			else
				SUI_ExperienceBarFill:SetWidth((now/goal)*400);
			end	
		end);
		xpframe:RegisterEvent("PLAYER_ENTERING_WORLD");
		xpframe:RegisterEvent("PLAYER_XP_UPDATE");
		xpframe:RegisterEvent("PLAYER_LEVEL_UP");
		
		xpframe:SetFrameStrata("BACKGROUND");
		xpframe:SetFrameLevel(2);
	end
	do -- reputation bar	
		repframe = CreateFrame("Frame","SUI_ReputationBar",SpartanUI,"SUI_StatusBars_RepTemplate");
		repframe:SetPoint("BOTTOMLEFT",SpartanUI,"BOTTOM",78,0);
	
		SUI_ReputationBarFill:SetVertexColor(0,1,0,0.7);
		SUI_ReputationBarFillGlow:SetVertexColor(0,1,0,0.2);
		SUI_ReputationBarLead:SetVertexColor(0,1,0,0.7);
		SUI_ReputationBarLeadGlow:SetVertexColor(0,1,0,0.2);
		
		
		local showTooltip = function()
			tooltip:ClearAllPoints();
			tooltip:SetPoint("BOTTOM",SUI_ReputationBar,"TOP",-2,-1);
			local name,react,low,high,current,text,ratio = GetWatchedFactionInfo();
			if name then
				text = GetFactionDetails(name);
				ratio = (current-low)/(high-low);
				SUI_StatusBarTooltipHeader:SetText(format("%s (%d / %d) %d%% %s",name,current-low,high-low,ratio*100,_G["FACTION_STANDING_LABEL"..react]));
				SUI_StatusBarTooltipText:SetText("|cffffd200"..text.."|r");
			else
				SUI_StatusBarTooltipHeader:SetText(REPUTATION);
				SUI_StatusBarTooltipText:SetText(REPUTATION_STANDING_DESCRIPTION);
			end
			tooltip:Show();
		end
		repframe:SetScript("OnEnter",function()
			if (suiChar and suiChar.tipHover == 1) then showTooltip(); end
		end);
		repframe:SetScript("OnLeave",function()
			tooltip:Hide();
		end);
		repframe:SetScript("OnMouseDown",function()
			if (tooltip:IsVisible()) then tooltip:Hide();
			elseif (suiChar and suiChar.tipHover == 0) then showTooltip(); end
		end);		
		repframe:SetScript("OnEvent",function()
			local ratio,name,reaction,low,high,current = 0,GetWatchedFactionInfo();
			if name then ratio = (current-low)/(high-low); end
			if ratio == 0 then
				SUI_ReputationBarFill:SetWidth(0.1);
			else
				SUI_ReputationBarFill:SetWidth(ratio*400);
				local color = FACTION_BAR_COLORS[reaction] or FACTION_BAR_COLORS[7];
				SUI_ReputationBarFill:SetVertexColor(color.r, color.g, color.b, 0.7);
				SUI_ReputationBarFillGlow:SetVertexColor(color.r, color.g, color.b, 0.2);
				SUI_ReputationBarLead:SetVertexColor(color.r, color.g, color.b, 0.7);
				SUI_ReputationBarLeadGlow:SetVertexColor(color.r, color.g, color.b, 0.2);
			end
		end);
		repframe:RegisterEvent("PLAYER_ENTERING_WORLD");
		repframe:RegisterEvent("UPDATE_FACTION");
		repframe:RegisterEvent("PLAYER_LEVEL_UP");
		repframe:RegisterEvent("CVAR_UPDATE");
	
		repframe:SetFrameStrata("BACKGROUND");
		repframe:SetFrameLevel(2);
	end
end
