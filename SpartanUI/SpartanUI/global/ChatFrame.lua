if (Prat or ChatMOD_Loaded or ChatSync or Chatter or PhanxChatDB) then return; end
local addon = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local module = addon:NewModule("ChatFrame");
---------------------------------------------------------------------------
local ChatHoverFunc = function(frame)
	if MouseIsOver(frame) then
		frame.UpButton:Show();
		frame.DownButton:Show();
		if frame == DEFAULT_CHAT_FRAME then ChatFrameMenuButton:Show(); end
	else
		frame.UpButton:Hide();
		frame.DownButton:Hide();
		if frame == DEFAULT_CHAT_FRAME then ChatFrameMenuButton:Hide(); end
	end
	if frame:AtBottom() then
		frame.BottomButton:Hide();
	else
		frame.BottomButton:Show();
	end
end;
local noop = function() return; end;
local hide = function(this) this:Hide(); end;
local NUM_SCROLL_LINES = 3;	
local scroll = function(this, arg1)
	if arg1 > 0 then
		if IsShiftKeyDown() then
			this:ScrollToTop()
		elseif IsControlKeyDown() then
			this:PageUp()
		else
			for i = 1, NUM_SCROLL_LINES do
				this:ScrollUp()
			end
		end
	elseif arg1 < 0 then
		if IsShiftKeyDown() then
			this:ScrollToBottom()
		elseif IsControlKeyDown() then
			this:PageDown()
		else
			for i = 1, NUM_SCROLL_LINES do
				this:ScrollDown()
			end
		end
	end
end;

function module:OnEnable()	
	for i = 1,7 do
		local frame = _G["ChatFrame"..i];				
		frame:SetMinResize(64,40); frame:SetFading(0);
		frame:EnableMouseWheel(true);
		frame:SetScript("OnMouseWheel",scroll);
		frame:SetFrameStrata("MEDIUM");
		frame:SetToplevel(false);
		frame:SetFrameLevel(2);
		
		frame.UpButton = _G["ChatFrame"..i.."UpButton"];
		frame.UpButton:ClearAllPoints(); frame.UpButton:SetScale(0.8);
		frame.UpButton:SetPoint("BOTTOMRIGHT",frame,"RIGHT",4,0);
		
		frame.DownButton = _G["ChatFrame"..i.."DownButton"];
		frame.DownButton:ClearAllPoints(); frame.DownButton:SetScale(0.8);
		frame.DownButton:SetPoint("TOPRIGHT",frame,"RIGHT",4,0);
			
		frame.BottomButton = _G["ChatFrame"..i.."BottomButton"];
		frame.BottomButton:ClearAllPoints(); frame.BottomButton:SetScale(0.8);
		frame.BottomButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -10);
		
		frame:HookScript("OnUpdate",ChatHoverFunc);
	end
		
	ChatFrameMenuButton:SetParent(DEFAULT_CHAT_FRAME);
	ChatFrameMenuButton:ClearAllPoints();
	ChatFrameMenuButton:SetScale(0.8);
	ChatFrameMenuButton:SetPoint("TOPRIGHT",DEFAULT_CHAT_FRAME,"TOPRIGHT",4,4);
	FCF_SetButtonSide = noop;
	
	ChatFrameEditBox:ClearAllPoints();
	ChatFrameEditBox:SetPoint("BOTTOMLEFT",  ChatFrame1, "TOPLEFT", 0, 2);
	ChatFrameEditBox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 0, 2);
end
