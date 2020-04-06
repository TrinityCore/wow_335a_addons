local SpinCamRunning, CameraDistanceMax;
SpinCamData = SpinCamData or {};
---------------------------------------------------------------------------
SlashCmdList["SPINCAM"] = function(msg)
	local msg = string.lower(msg)
	local cmd,arg1 = strsplit(" ",msg);
	if (arg1 ~= "on") and (arg1 ~= "off") then
		if (SpinCamData.Disable) then arg1 = "on"; else arg1 = "off"; end
	end
	if (arg1 == "on") then
		SpinCamData.Disable = nil;
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SpinCam|r: Feature Enabled");
	elseif (arg1 == "off") then
		SpinCamData.Disable = true;
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SpinCam|r: Feature Disabled");
	end
	if (SpinCamData.Disable) and (SpinCamRunning) then
		MoveViewRightStop();
		SetCVar("cameraYawMoveSpeed","230");
		SetCVar("cameraDistanceMax",CameraDistanceMax or 200);
		SetView(5);
	end
end;
SLASH_SPINCAM1 = "/spincam";
---------------------------------------------------------------------------
SetCVar("cameraYawMoveSpeed","230");
local frame = CreateFrame("Frame");
frame:RegisterEvent("CHAT_MSG_SYSTEM");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:SetScript("OnEvent",function()
	if event == "CHAT_MSG_SYSTEM" then
		if (arg1 == format(MARKED_AFK_MESSAGE,DEFAULT_AFK_MESSAGE)) and (not SpinCamData.Disable) then
			SetCVar("cameraYawMoveSpeed","8");
			MoveViewRightStart();
			SpinCamRunning = true;
			SetView(5);
		elseif (arg1 == CLEARED_AFK) and (SpinCamRunning) then
			MoveViewRightStop();
			SetCVar("cameraYawMoveSpeed","230");
			SpinCamRunning = nil;
			SetView(5);
		end
	elseif event == "PLAYER_LEAVING_WORLD" then
		if (SpinCamRunning) then
			MoveViewRightStop();
			SetCVar("cameraYawMoveSpeed","230");
			SpinCamRunning = nil;
			SetView(5);
		end
	end
end);
---------------------------------------------------------------------------
if (IsAddOnLoaded("SpartanUI")) then
	local options = LibStub("AceAddon-3.0"):GetAddon("SpartanUI").options;
	options.args["spincam"] = {
		type = "input",
		name = "Toggle SpinCam",
		desc = "Toggles SpinCam on and off",
		set = function(info,val)
			if val then val = " "..val; end
			SlashCmdList["SPINCAM"]("spincam"..val);
		end
	};
end
