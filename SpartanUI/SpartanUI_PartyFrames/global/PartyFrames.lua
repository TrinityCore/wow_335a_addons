local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local addon = spartan:GetModule("PartyFrames");
----------------------------------------------------------------------------------------------------
oUF:SetActiveStyle("Spartan_PartyFrames");

local party = oUF:Spawn("header","SUI_PartyFrameHeader");
do -- party header configuration
	party:SetParent("SpartanUI");
	party:SetClampedToScreen(true);
	party:SetManyAttributes(
		--"showSolo",						true,
		--"showPlayer",						true,
		"showParty",						true,
		"yOffset",							-16,
		"xOffset",							0,
		"columnAnchorPoint",	"TOPLEFT",
		"initial-anchor",				"TOPLEFT",
		"template",						"SUI_PartyMemberTemplate");
	PartyMemberBackground.Show = function() return; end
	PartyMemberBackground:Hide();
end
do -- scripts to make it movable
	party.mover = CreateFrame("Frame");	
	party.mover:SetWidth(205); party.mover:SetHeight(332);
	party.mover:SetPoint("TOPLEFT",party,"TOPLEFT");	
	party.mover:EnableMouse(true);
	
	party.bg = party.mover:CreateTexture(nil,"BACKGROUND");
	party.bg:SetAllPoints(party.mover);
	party.bg:SetTexture(1,1,1,0.5);
	
	party.mover:SetScript("OnMouseDown",function()
		party.isMoving = true;
		suiChar.PartyFrames.partyMoved = true;
		party:SetMovable(true);
		party:StartMoving();
	end);
	party.mover:SetScript("OnMouseUp",function()
		if party.isMoving then
			party.isMoving = nil;
			party:StopMovingOrSizing();
		end
	end);
	party.mover:SetScript("OnHide",function()
		party.isMoving = nil;
		party:StopMovingOrSizing();
	end);
	party.mover:SetScript("OnEvent",function()
		addon.locked = 1;
		party.mover:Hide();
	end);
	party.mover:RegisterEvent("VARIABLES_LOADED");
	party.mover:RegisterEvent("PLAYER_REGEN_DISABLED");
	
	function addon:UpdatePartyPosition()
		if suiChar.PartyFrames.partyMoved then
			party:SetMovable(true);
		else
			party:SetMovable(false);
			if spartan:GetModule("PlayerFrames",true) then
				party:SetPoint("TOPLEFT",UIParent,"TOPLEFT",10,-20);
			else
				party:SetPoint("TOPLEFT",UIParent,"TOPLEFT",10,-140);
			end
		end
	end	
	addon:UpdatePartyPosition();
end
do -- hide party frame in raid, if option enabled
	local partyWatch = CreateFrame("Frame");
	partyWatch:RegisterEvent('PLAYER_LOGIN');
	partyWatch:RegisterEvent('RAID_ROSTER_UPDATE');
	partyWatch:RegisterEvent('PARTY_LEADER_CHANGED');
	partyWatch:RegisterEvent('PARTY_MEMBERS_CHANGED');
	partyWatch:RegisterEvent('CVAR_UPDATE');
	partyWatch:SetScript('OnEvent', function(self)
		if InCombatLockdown() then self:RegisterEvent('PLAYER_REGEN_ENABLED'); return; end
		if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent('PLAYER_REGEN_ENABLED'); end
		-- we aren't in combat
		if (tonumber(GetCVar("hidePartyInRaid")) == 1) and (GetNumRaidMembers() > 0) then
			-- we are in a raid, and the hidePartyInRaid option is enabled
			party:Hide();
		else
			party:Show();
		end
	end);
end
