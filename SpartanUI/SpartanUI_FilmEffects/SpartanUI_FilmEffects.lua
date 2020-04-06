local f = CreateFrame("Frame", "FilmEffects", WorldFrame);
	f:SetHeight(64); f:SetWidth(64);
	f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -128, 256);
	f:SetFrameStrata("BACKGROUND");
	
	f:RegisterEvent("PLAYER_ENTERING_WORLD");
	f:SetScript("OnEvent",function(event) FG_OnLoad(event); end);
	f:SetScript("OnUpdate", function(self, elapsed) FG_OnUpdate(self, elapsed); end);
---------------------------------------------------------------------------
FEDB = FEDB or {};
FEDB.Interval = 12.5;
FEDB.animationInterval = 0;
FEDB.record = 1;
---------------------------------------------------------------------------
function FG_OnEvent(arg1, arg2)
	if not FE_Vignette and arg1=="vignette" then
		local t = f:CreateTexture("FE_Vignette", "OVERLAY")
		t:SetAllPoints(UIParent)
		t:SetTexture("Interface\\AddOns\\SpartanUI_FilmEffects\\media\\vignette")
		t:SetBlendMode("MOD")
		FEDB.vignette = true
	elseif arg1=="vignette" then
		if FE_Vignette:IsVisible() then
			FE_Vignette:Hide()
			FEDB.vignette = nil
		else
			FE_Vignette:Show()
			FEDB.vignette = true
		end
	end
	
	if arg1=="film" and arg2=="blur" then
		if not FG_Fuzzy then
			local t = f:CreateTexture("FG_Fuzzy", "OVERLAY")
			local t2 = f:CreateTexture("FG_Fuggly", "OVERLAY")
			t:SetTexture("Interface\\AddOns\\SpartanUI_FilmEffects\\media\\25ASA_Add")
			t2:SetTexture("Interface\\AddOns\\SpartanUI_FilmEffects\\media\\25ASA_Mod")
			t:SetBlendMode("ADD")
			t2:SetBlendMode("MOD")
			t:SetAlpha(.2)
			t2:SetAlpha(.05)
		
			local resolution =({GetScreenResolutions()})[GetCurrentResolution()];
			local x, y = strmatch(resolution, "(%d+)x(%d+)")
			
			t:SetHeight((tonumber(y))+256)
			t:SetWidth((tonumber(x))+256)
			t2:SetHeight((tonumber(y))+256)
			t2:SetWidth((tonumber(x))+256)
			
			t:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
			t2:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
			FEDB.animateGrainFuzzy = true
		else
			if FG_Fuzzy:IsVisible() then
				FG_Fuzzy:Hide()
				FG_Fuggly:Hide()
				FEDB.animateGrainFuzzy = nil
			else
				FG_Fuzzy:Show()
				FG_Fuggly:Show()
				FEDB.animateGrainFuzzy = true
			end
		end
	end
	
	if arg1=="film" and arg2=="crisp" then
		if not _G["FG_1_1_Add"] then
			local resolution =({GetScreenResolutions()})[GetCurrentResolution()];
			local x, y = strmatch(resolution, "(%d+)x(%d+)")
			
			local i = 1
			local ix = 1
			local iy = 1
			local xLimit = math.floor((tonumber(x))/512 + 1)
			local yLimit = math.floor((tonumber(y))/512 + 1)
			local iLimit = xLimit * yLimit
			local intensity = 1
			
			local fatherF = CreateFrame("Frame", "FG_Crispy", f)
			while i <= iLimit do
				local nameAdd = "FG_"..ix.."_"..iy.."_Add"
				local nameMod = "FG_"..ix.."_"..iy.."_Mod"
				local t = fatherF:CreateTexture(nameAdd, "OVERLAY")
				local t2 = fatherF:CreateTexture(nameMod, "OVERLAY")
				
				t:SetTexture("Interface\\AddOns\\SpartanUI_FilmEffects\\media\\25ASA_Add")
				t2:SetTexture("Interface\\AddOns\\SpartanUI_FilmEffects\\media\\25ASA_Mod")
				
				t:SetWidth(512)
				t:SetHeight(512)
				t2:SetWidth(512)
				t2:SetHeight(512)
				
				t:SetBlendMode("ADD")
				t2:SetBlendMode("MOD")
				t:SetAlpha(intensity * .45)
				t2:SetAlpha(intensity * .3)
			
						

				local father, anchor
				father = _G["FG_"..(ix-1).."_"..iy.."_Add"] or _G["FG_"..ix.."_"..(iy-1).."_Add"] or f
				
				if _G["FG_"..(ix-1).."_"..iy.."_Add"] then
					anchor = "TOPRIGHT"
				elseif _G["FG_"..ix.."_"..(iy-1).."_Add"] then
					anchor = "BOTTOMLEFT"
				else
					anchor = "TOPLEFT"
				end
				
				t:SetPoint("TOPLEFT", father, anchor, 0, 0)
				t2:SetPoint("TOPLEFT", t, "TOPLEFT", 0, 0)
				
				ix = ix + 1
				if ix > xLimit then
					ix = 1
					iy = iy + 1
				end
				i = i + 1
			end
			FEDB.animateGrainCrispy = true
		else
			if FG_Crispy:IsVisible() then
				FG_Crispy:Hide()
				FEDB.animateGrainCrispy = nil
			else
				FG_Crispy:Show()
				FEDB.animateGrainCrispy = true
			end
		end
	end
	
	if arg1=="reset" then
		if FE_Vignette then FE_Vignette:Hide(); end
		if FG_Fuzzy then FG_Fuzzy:Hide(); end
		if FG_Fuggly then FG_Fuggly:Hide(); end
		if FG_Crispy then FG_Crispy:Hide(); end
		
		FEDB.vignette = nil;
		FEDB.animateGrainFuzzy = nil;		
		FEDB.animateGrainCrispy = nil;		
	end		
end
function FG_OnUpdate(self, elapsed)
	FEDB.animationInterval = FEDB.animationInterval + elapsed
	if (FEDB.animationInterval > (0.02)) then		-- 50 FPS
		FEDB.animationInterval = 0
		
		local yOfs = math.random(0, 256)
		local xOfs = math.random(-128, 0)
		
		if FEDB.animateGrainFuzzy or FEDB.animateGrainCrispy then
			f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", xOfs, yOfs)
		end
	end
end
function FG_OnLoad(event)
	if not FEDB then return; end
	if FEDB.animateGrainCrispy then
		FG_OnEvent("film", "crisp");
	end
	if FEDB.animateGrainFuzzy then
		FG_OnEvent("film", "blur");
	end
	if FEDB.vignette then
		FG_OnEvent("vignette");
	end
end	
---------------------------------------------------------------------------
SlashCmdList["FILMEFF"] = function(msg)
	local msg = string.lower(msg)
	local cmd = strsplit(" ",msg);
	if (cmd == "vignette") then
		FG_OnEvent("vignette");
		if FEDB.vignette then 
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FilmEffects|r: Vignette Enabled");
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FilmEffects|r: Vignette Disabled");
		end
	elseif (cmd == "blur") then
		FG_OnEvent("film", "blur");
		if FEDB.animateGrainFuzzy then 
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FilmEffects|r: Blurry Film-Grain Enabled");
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FilmEffects|r: Blurry Film-Grain Disabled");
		end
	elseif (cmd == "crisp") then
		FG_OnEvent("film", "crisp");
		if FEDB.animateGrainCrispy then 
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FilmEffects|r: Crisp Film-Grain Enabled");
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FilmEffects|r: Crisp Film-Grain Disabled");
		end
	elseif (cmd == "reset") then
		FG_OnEvent("reset");
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FilmEffects|r: Everything Disabled");	
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FilmEffects|r: Arguments to |cffffff78/film|r");
		if FEDB.vignette then
			DEFAULT_CHAT_FRAME:AddMessage("    |cffffff78vignette|r - toggles shadows on the edges of the screen <|cff33ff99ACTIVE|r>");
		else
			DEFAULT_CHAT_FRAME:AddMessage("    |cffffff78vignette|r - toggles shadows on the edges of the screen");
		end
		if FEDB.animateGrainFuzzy then
			DEFAULT_CHAT_FRAME:AddMessage("    |cffffff78blur|r - toggles a blurry film-grain to the screen <|cff33ff99ACTIVE|r>");
		else
			DEFAULT_CHAT_FRAME:AddMessage("    |cffffff78blur|r - toggles a blurry film-grain to the screen");
		end
		if FEDB.animateGrainCrispy then
			DEFAULT_CHAT_FRAME:AddMessage("    |cffffff78crisp|r - toggles a sharp film-grain to the screen <|cff33ff99ACTIVE|r>");
		else
			DEFAULT_CHAT_FRAME:AddMessage("    |cffffff78crisp|r - toggles a sharp film-grain to the screen");
		end
		DEFAULT_CHAT_FRAME:AddMessage("    |cffffff78reset|r - disables all active film effects");		
	end
end;
SLASH_FILMEFF1 = "/film";
---------------------------------------------------------------------------
if (IsAddOnLoaded("SpartanUI")) then
	local options = LibStub("AceAddon-3.0"):GetAddon("SpartanUI").options;
	options.args["film"] = {
		name = "Toggle FilmEffects",
		type = "input", 
		set = function(info,val)
			SlashCmdList["FILMEFF"](val);
		end
	};
end