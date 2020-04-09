TACTIC_MSG_CH = "TTC2";
TACTIC_TEMP_MSG = {};
local lastSelected = 0;
function Tacticator_toggle_visible()
  if(Tacticator:IsShown()) then
    Tacticator:Hide();
    TacticatorActors:Hide();
  else
    Tacticator:Show();
--    TacticatorActors:Show();
  end
end

function TacticDisplay_Toggle_Visible()
	if(TacticDisplay:IsShown()) then
		TacticDisplay:Hide();
	else
		TacticDisplay:Show();
	end
end

function Tacticator_OnLoad(self)
  local version = GetAddOnMetadata("Tacticator", "Version");
  Tacticator_SetVariables();
  self:RegisterEvent("VARIABLES_LOADED");

  SlashCmdList["Tacticator"] = function(msg)
    Tacticator_SlashCommand(msg);
  end;
  --SLASH_Tacticator1 = "/tactic";
  SLASH_Tacticator1 = "/tacticator";
  
  if( DEFAULT_CHAT_FRAME ) then
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00Tacticator v"..version.." loaded");
  end
  UIErrorsFrame:AddMessage("Tacticator v"..version.." AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
  if moblist then
  	TacticatorTacticGD:Enable();
  else
  	TacticatorTacticGD:Disable();
  end
  Tacticator:Hide();
end

function TacticDisplay_OnLoad(self)
  self:RegisterEvent("CHAT_MSG_ADDON");
  TacticDisplay:Hide();
  TacticatorActors:Hide();
end

function Tacticator_OnEvent()
	if (event=="VARIABLES_LOADED") then
		Tacticator:ClearAllPoints();
		Tacticator:SetPoint("BOTTOMLEFT","UIParent", "BOTTOMLEFT", TacticatorSavings.dispx, TacticatorSavings.dispy);
		TacticDisplay:SetPoint("BOTTOMLEFT","UIParent", "BOTTOMLEFT", TacticatorSavings.historyDispx, TacticatorSavings.historyDispy);
		local i;
		if not(TacticatorSavings.TACTIC_INSTANCE) then
			TacticatorSavings.TACTIC_INSTANCE = {};
		end
		TacticatorDropDownInstance_Initialize();
		TacticatorConfig_OnCancelOrLoad();
	end
end

function TacticatorConfig_OnCancelOrLoad()
	TacticatorConfigFrameRaid:SetChecked(TacticatorSavings.showRaid);
	TacticatorConfigFrameParty:SetChecked(TacticatorSavings.showParty);
	TacticatorConfigFrameBG:SetChecked(TacticatorSavings.showBG);
	TacticatorConfigFramePopup:SetChecked(TacticatorSavings.showPopup);
	TacticatorConfigFramePopupOwn:SetChecked(TacticatorSavings.showPopupOwn);
end

function Tacticator_SetVariables()
  if not(TacticatorSavings) then
    TacticatorSavings = {};
    TacticatorSavings.dispx = GetScreenWidth()/2 - 200;
    TacticatorSavings.dispy = GetScreenHeight()/2 - 200;
	TacticatorSavings.historyDispx = GetScreenWidth()/2 - 200;
	TacticatorSavings.historyDispy = GetScreenHeight()/2 - 200;
    TacticatorSavings.TACTIC_INSTANCE = {};
    TacticatorSavings.showRaid = true;
    TacticatorSavings.showParty = true;
    TacticatorSavings.showBG = true;
    TacticatorSavings.showPopup = true;
    TacticatorSavings.showPopupOwn = false;
  end
  TacticatorDropDownInstance_Initialize();
end

function Tacticator_SlashCommand(msg)
  if(msg) then
    local command = string.lower(msg);
    if(command == "hide") then
      Tacticator:Hide();
    else
	  if(command == "history") then
	    TacticDisplay:Show();
	  else
        Tacticator:Show();
      end
    end
  end
end

function Tacticator_SavePosition(self)
  TacticatorSavings.dispx = self:GetLeft();
  TacticatorSavings.dispy = self:GetBottom();
end

function TacticatorDisplay_SavePosition(self)
  TacticatorSavings.historyDispx = self:GetLeft();
  TacticatorSavings.historyDispy = self:GetBottom();
end

function Tacticator_OnSave()
	local instance = UIDropDownMenu_GetSelectedID(TacticatorDropDownInstance);
	local box = getglobal("TacticatorScrollContainerScrollFrameEditBox");
	local tacticText = box:GetText();
	if (instance == 0) then
		instance = lastSelected;
	end
	if(instance == 0) then
		return;
	end
	if tacticText and not(tacticText == "") and instance then
		TacticatorSavings.TACTIC_INSTANCE[instance].tactic = tacticText;
		if not(TacticatorSavings.TACTIC_INSTANCE[instance].actors) then
			TacticatorSavings.TACTIC_INSTANCE[instance].actors = {};
		end
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["h1"] = TacticatorActorsHealerTabH1:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["h2"] = TacticatorActorsHealerTabH2:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["h3"] = TacticatorActorsHealerTabH3:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["h4"] = TacticatorActorsHealerTabH4:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["h5"] = TacticatorActorsHealerTabH5:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["h6"] = TacticatorActorsHealerTabH6:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["h7"] = TacticatorActorsHealerTabH7:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["h8"] = TacticatorActorsHealerTabH8:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["h9"] = TacticatorActorsHealerTabH9:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["t1"] = TacticatorActorsTankTabT1:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["t2"] = TacticatorActorsTankTabT2:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["t3"] = TacticatorActorsTankTabT3:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["t4"] = TacticatorActorsTankTabT4:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["t5"] = TacticatorActorsTankTabT5:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["t6"] = TacticatorActorsTankTabT6:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["t7"] = TacticatorActorsTankTabT7:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["t8"] = TacticatorActorsTankTabT8:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["t9"] = TacticatorActorsTankTabT9:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["d1"] = TacticatorActorsDPSTabD1:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["d2"] = TacticatorActorsDPSTabD2:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["d3"] = TacticatorActorsDPSTabD3:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["d4"] = TacticatorActorsDPSTabD4:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["d5"] = TacticatorActorsDPSTabD5:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["d6"] = TacticatorActorsDPSTabD6:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["d7"] = TacticatorActorsDPSTabD7:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["d8"] = TacticatorActorsDPSTabD8:GetText();
		TacticatorSavings.TACTIC_INSTANCE[instance].actors["d9"] = TacticatorActorsDPSTabD9:GetText();
	end
end

function Tacticator_OnAdd()
	local instance = getglobal("TacticatorInstance");
	local text = instance:GetText();
	if text and not(text == "") then
		tactic = {
			name = text;
			tactic = "";
		};
		TacticatorSavings.TACTIC_INSTANCE[getn(TacticatorSavings.TACTIC_INSTANCE) + 1] = tactic;
	end
	instance:SetText("");
	TacticatorDropDownInstance_Initialize();
end

function Tacticator_OnRename()
	local instance = getglobal("TacticatorInstance");
	local instanceSelected = UIDropDownMenu_GetSelectedID(TacticatorDropDownInstance);
	local text = instance:GetText();
	if text and not(text == "") and instanceSelected and (instanceSelected > 0) then
		TacticatorSavings.TACTIC_INSTANCE[instanceSelected].name = text;
		instance:SetText("");
		UIDropDownMenu_ClearAll(TacticatorDropDownInstance);
		TacticatorDropDownInstance_Initialize();
		UIDropDownMenu_SetSelectedID(TacticatorDropDownInstance, instanceSelected);
		UIDropDownMenu_SetText(TacticatorDropDownInstance, text);
	end
end

function Tacticator_OnClear()
  local obj = getglobal("TacticatorScrollContainerScrollFrameEditBox");
  obj:SetText("");
end

function Tacticator_OnClose()
  Tacticator:Hide();
  TacticatorActors:Hide();
end

function TacticDisplay_OnClose()
  TacticDisplay:Hide();
end

function TacticatorDropDownInstance_OnShow()
	UIDropDownMenu_Initialize(TacticatorDropDownInstance, TacticatorDropDownInstance_Initialize);
	UIDropDownMenu_SetSelectedID(TacticatorDropDownInstance, 0);
	UIDropDownMenu_SetWidth(TacticatorDropDownInstance, 100);
end

function TacticatorDropDownInstance_Initialize()
	local i;
	if not TacticatorSavings then
		Tacticator_SetVariables();
	end
	if(getn(TacticatorSavings.TACTIC_INSTANCE) > 0) then
		for i = 1, getn(TacticatorSavings.TACTIC_INSTANCE), 1 do
			info = {
				text = TacticatorSavings.TACTIC_INSTANCE[i].name;
				func = TacticatorDropDownInstance_OnClick;
			};
			UIDropDownMenu_AddButton(info);
			i = i + 1;
		end
	end
end

function TacticDisplayDropDownReceived_OnShow()
	UIDropDownMenu_Initialize(TacticDisplayDropDownReceived, TacticDisplayDropDownReceived_Initialize);
	UIDropDownMenu_SetSelectedID(TacticDisplayDropDownReceived, 0);
	UIDropDownMenu_SetWidth(TacticDisplayDropDownReceived, 100);
end

function TacticDisplayDropDownReceived_Initialize()
	local i;
	if(getn(TACTIC_TEMP_MSG) > 0) then
		for i = 1, getn(TACTIC_TEMP_MSG), 1 do
			info = {
				text = TACTIC_TEMP_MSG[i].sender.." : "..i;
				func = TacticDisplayDropDownReceived_OnClick;
			};
			UIDropDownMenu_AddButton(info);
			i = i + 1;
		end
		UIDropDownMenu_SetSelectedID(TacticDisplayDropDownReceived, getn(TACTIC_TEMP_MSG));
	end
end

function TacticDisplayDropDownReceived_OnClick(self)
	local thisID = self:GetID();
	UIDropDownMenu_SetSelectedID(TacticDisplayDropDownReceived, thisID);
	local box = getglobal("TacticDisplayScrollContainerScrollFrameEditBox");
	box:SetText(strsub(TACTIC_TEMP_MSG[thisID].tactic, 1, strlen(TACTIC_TEMP_MSG[thisID].tactic)-1));
end

function Tacticator_OnDelete()
	local id = UIDropDownMenu_GetSelectedID(TacticatorDropDownInstance);
	tremove(TacticatorSavings.TACTIC_INSTANCE, id);
	UIDropDownMenu_ClearAll(TacticatorDropDownInstance);
	TacticatorDropDownInstance_Initialize();
	local box = getglobal("TacticatorScrollContainerScrollFrameEditBox");
	box:SetText("");	
end

function TacticatorDropDownInstance_OnClick(self)
	local thisID = self:GetID();
	UIDropDownMenu_SetSelectedID(TacticatorDropDownInstance, thisID);
	lastSelected = thisID;
	local box = getglobal("TacticatorScrollContainerScrollFrameEditBox");
	box:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].tactic);
	if(TacticatorSavings.TACTIC_INSTANCE[thisID].actors) then
		TacticatorActorsHealerTabH1:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["h1"]);
		TacticatorActorsHealerTabH2:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["h2"]);
		TacticatorActorsHealerTabH3:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["h3"]);
		TacticatorActorsHealerTabH4:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["h4"]);
		TacticatorActorsHealerTabH5:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["h5"]);
		TacticatorActorsHealerTabH6:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["h6"]);
		TacticatorActorsHealerTabH7:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["h7"]);
		TacticatorActorsHealerTabH8:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["h8"]);
		TacticatorActorsHealerTabH9:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["h9"]);
		TacticatorActorsTankTabT1:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["t1"]);
		TacticatorActorsTankTabT2:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["t2"]);
		TacticatorActorsTankTabT3:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["t3"]);
		TacticatorActorsTankTabT4:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["t4"]);
		TacticatorActorsTankTabT5:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["t5"]);
		TacticatorActorsTankTabT6:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["t6"]);
		TacticatorActorsTankTabT7:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["t7"]);
		TacticatorActorsTankTabT8:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["t8"]);
		TacticatorActorsTankTabT9:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["t9"]);
		TacticatorActorsDPSTabD1:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["d1"]);
		TacticatorActorsDPSTabD2:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["d2"]);
		TacticatorActorsDPSTabD3:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["d3"]);
		TacticatorActorsDPSTabD4:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["d4"]);
		TacticatorActorsDPSTabD5:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["d5"]);
		TacticatorActorsDPSTabD6:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["d6"]);
		TacticatorActorsDPSTabD7:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["d7"]);
		TacticatorActorsDPSTabD8:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["d8"]);
		TacticatorActorsDPSTabD9:SetText(TacticatorSavings.TACTIC_INSTANCE[thisID].actors["d9"]);
	else 
		TacticatorActorsHealerTabH1:SetText("");
		TacticatorActorsHealerTabH2:SetText("");
		TacticatorActorsHealerTabH3:SetText("");
		TacticatorActorsHealerTabH4:SetText("");
		TacticatorActorsHealerTabH5:SetText("");
		TacticatorActorsHealerTabH6:SetText("");
		TacticatorActorsHealerTabH7:SetText("");
		TacticatorActorsHealerTabH8:SetText("");
		TacticatorActorsHealerTabH9:SetText("");
		TacticatorActorsTankTabT1:SetText("");
		TacticatorActorsTankTabT2:SetText("");
		TacticatorActorsTankTabT3:SetText("");
		TacticatorActorsTankTabT4:SetText("");
		TacticatorActorsTankTabT5:SetText("");
		TacticatorActorsTankTabT6:SetText("");
		TacticatorActorsTankTabT7:SetText("");
		TacticatorActorsTankTabT8:SetText("");
		TacticatorActorsTankTabT9:SetText("");
		TacticatorActorsDPSTabD1:SetText("");
		TacticatorActorsDPSTabD2:SetText("");
		TacticatorActorsDPSTabD3:SetText("");
		TacticatorActorsDPSTabD4:SetText("");
		TacticatorActorsDPSTabD5:SetText("");
		TacticatorActorsDPSTabD6:SetText("");
		TacticatorActorsDPSTabD7:SetText("");
		TacticatorActorsDPSTabD8:SetText("");
		TacticatorActorsDPSTabD9:SetText("");
	end
end

function Tacticator_OnSayClick()
	getglobal("TacticatorCheckParty"):SetChecked(false);
	getglobal("TacticatorCheckSay"):SetChecked(true);
	getglobal("TacticatorCheckRaid"):SetChecked(false);
	getglobal("TacticatorCheckRaidWarning"):SetChecked(false);
	getglobal("TacticatorCheckBattleground"):SetChecked(false);
	getglobal("TacticatorCheckChannelNo"):SetChecked(false);
end

function Tacticator_OnPartyClick()
	getglobal("TacticatorCheckParty"):SetChecked(true);
	getglobal("TacticatorCheckSay"):SetChecked(false);
	getglobal("TacticatorCheckRaid"):SetChecked(false);
	getglobal("TacticatorCheckRaidWarning"):SetChecked(false);
	getglobal("TacticatorCheckBattleground"):SetChecked(false);
	getglobal("TacticatorCheckChannelNo"):SetChecked(false);
end

function Tacticator_OnRaidClick()
	getglobal("TacticatorCheckParty"):SetChecked(false);
	getglobal("TacticatorCheckSay"):SetChecked(false);
	getglobal("TacticatorCheckRaid"):SetChecked(true);
	getglobal("TacticatorCheckRaidWarning"):SetChecked(false);
	getglobal("TacticatorCheckBattleground"):SetChecked(false);
	getglobal("TacticatorCheckChannelNo"):SetChecked(false);
end

function Tacticator_OnRaidWarningClick()
	getglobal("TacticatorCheckParty"):SetChecked(false);
	getglobal("TacticatorCheckSay"):SetChecked(false);
	getglobal("TacticatorCheckRaid"):SetChecked(false);
	getglobal("TacticatorCheckRaidWarning"):SetChecked(true);
	getglobal("TacticatorCheckBattleground"):SetChecked(false);
	getglobal("TacticatorCheckChannelNo"):SetChecked(false);
end

function Tacticator_OnBattlegroundClick()
	getglobal("TacticatorCheckParty"):SetChecked(false);
	getglobal("TacticatorCheckSay"):SetChecked(false);
	getglobal("TacticatorCheckRaid"):SetChecked(false);
	getglobal("TacticatorCheckRaidWarning"):SetChecked(false);
	getglobal("TacticatorCheckBattleground"):SetChecked(true);
	getglobal("TacticatorCheckChannelNo"):SetChecked(false);
end

function Tacticator_OnChannelNoClick()
	getglobal("TacticatorCheckParty"):SetChecked(false);
	getglobal("TacticatorCheckSay"):SetChecked(false);
	getglobal("TacticatorCheckRaid"):SetChecked(false);
	getglobal("TacticatorCheckRaidWarning"):SetChecked(false);
	getglobal("TacticatorCheckBattleground"):SetChecked(false);
	getglobal("TacticatorCheckChannelNo"):SetChecked(true);
end

function Tacticator_OnSend()
	local box = getglobal("TacticatorScrollContainerScrollFrameEditBox");
	local tacticText = box:GetText();
	tacticText = gsub(tacticText, "{T1}", TacticatorActorsTankTabT1:GetText());
	tacticText = gsub(tacticText, "{T2}", TacticatorActorsTankTabT2:GetText());
	tacticText = gsub(tacticText, "{T3}", TacticatorActorsTankTabT3:GetText());
	tacticText = gsub(tacticText, "{T4}", TacticatorActorsTankTabT4:GetText());
	tacticText = gsub(tacticText, "{T5}", TacticatorActorsTankTabT5:GetText());
	tacticText = gsub(tacticText, "{T6}", TacticatorActorsTankTabT6:GetText());
	tacticText = gsub(tacticText, "{T7}", TacticatorActorsTankTabT7:GetText());
	tacticText = gsub(tacticText, "{T8}", TacticatorActorsTankTabT8:GetText());
	tacticText = gsub(tacticText, "{T9}", TacticatorActorsTankTabT9:GetText());
	tacticText = gsub(tacticText, "{H1}", TacticatorActorsHealerTabH1:GetText());
	tacticText = gsub(tacticText, "{H2}", TacticatorActorsHealerTabH2:GetText());
	tacticText = gsub(tacticText, "{H3}", TacticatorActorsHealerTabH3:GetText());
	tacticText = gsub(tacticText, "{H4}", TacticatorActorsHealerTabH4:GetText());
	tacticText = gsub(tacticText, "{H5}", TacticatorActorsHealerTabH5:GetText());
	tacticText = gsub(tacticText, "{H6}", TacticatorActorsHealerTabH6:GetText());
	tacticText = gsub(tacticText, "{H7}", TacticatorActorsHealerTabH7:GetText());
	tacticText = gsub(tacticText, "{H8}", TacticatorActorsHealerTabH8:GetText());
	tacticText = gsub(tacticText, "{H9}", TacticatorActorsHealerTabH9:GetText());
	tacticText = gsub(tacticText, "{D1}", TacticatorActorsDPSTabD1:GetText());
	tacticText = gsub(tacticText, "{D2}", TacticatorActorsDPSTabD2:GetText());
	tacticText = gsub(tacticText, "{D3}", TacticatorActorsDPSTabD3:GetText());
	tacticText = gsub(tacticText, "{D4}", TacticatorActorsDPSTabD4:GetText());
	tacticText = gsub(tacticText, "{D5}", TacticatorActorsDPSTabD5:GetText());
	tacticText = gsub(tacticText, "{D6}", TacticatorActorsDPSTabD6:GetText());
	tacticText = gsub(tacticText, "{D7}", TacticatorActorsDPSTabD7:GetText());
	tacticText = gsub(tacticText, "{D8}", TacticatorActorsDPSTabD8:GetText());
	tacticText = gsub(tacticText, "{D9}", TacticatorActorsDPSTabD9:GetText());
	local continueVar = true;
	local channel = "RAID";
	local no = nil;
	local channelRequired = false;
	if(getglobal("TacticatorCheckParty"):GetChecked()) then
		channel = "PARTY";
	else
		if(getglobal("TacticatorCheckSay"):GetChecked()) then
			channel = "SAY";
		else
			if(getglobal("TacticatorCheckRaidWarning"):GetChecked()) then
				channel = "RAID_WARNING";
			else
				if(getglobal("TacticatorCheckBattleground"):GetChecked()) then
					channel = "BATTLEGROUND";
				else
					if(getglobal("TacticatorCheckChannelNo"):GetChecked()) then
						channel = "CHANNEL";
						no = getglobal("TacticatorChannelNo"):GetText();
						channelRequired = true;
					end
				end
			end
		end
	end
	local tempChannel;
	if(channel == "PARTY" or channel == "RAID" or channel == "BATTLEGROUND" or channel == "RAID_WARNING") then
		if(channel == "RAID_WARNING") then
			tempChannel = "RAID";
		else
			tempChannel = channel;
		end
	end
	if((not(no) or (no == "")) and channelRequired) then
	else
		while (continueVar == true) do
			local pos1 = strfind(tacticText, strchar(10));
			if(not(pos1) and (strlen(tacticText)+strlen(TACTIC_MSG_CH)+strlen(UnitName("player")) > 253 )) then
				pos1 = 253-strlen(TACTIC_MSG_CH)-strlen(UnitName("player"));
			end
			if(pos1) then
				if(pos1+strlen(TACTIC_MSG_CH)+strlen(UnitName("player")) > 253) then
					pos1 = 253 - strlen(TACTIC_MSG_CH)-strlen(UnitName("player"));
				end
				if(no) then
					SendChatMessage(strsub(tacticText,1,pos1), channel, nil, no);
				else
					SendChatMessage(strsub(tacticText,1,pos1), channel);
				end
				if(tempChannel) then
					SendAddonMessage(TACTIC_MSG_CH, UnitName("player")..":"..strsub(tacticText,1,pos1), tempChannel);
				end
				tacticText = strsub(tacticText, pos1+1);
			else
				if(strlen(tacticText) > 0) then
					if(no) then
						SendChatMessage(tacticText, channel, nil, no);
					else
						SendChatMessage(tacticText, channel);
					end
				end
				if(tempChannel) then
					SendAddonMessage(TACTIC_MSG_CH, UnitName("player")..":"..tacticText, tempChannel);
				end
				continueVar = false;
			end
		end
		SendAddonMessage(TACTIC_MSG_CH, UnitName("player")..":"..strchar(23), tempChannel);
	end
end

function TacticDisplay_OnEvent()
	if(event =="CHAT_MSG_ADDON") then
		TacticDisplay_HandleMessage(arg1, arg2, arg3);
	end
end

function TacticDisplay_HandleMessage(prefix, text, channel)
	if(prefix == TACTIC_MSG_CH and ((channel == "RAID" and TacticatorSavings.showRaid) or (channel == "PARTY" and TacticatorSavings.showParty) or (channel == "BATTLEGROUND" and TacticatorSavings.showBG))) then
		local token = strfind(text, ":");
  		if(token) then
  			local inSender = strsub(text, 1, token -1);
  			local inTactic = strsub(text, token+1);
  			local matched = false;
  			if (TacticatorSavings.showPopupOwn or not(inSender == UnitName("player"))) then
  				if TacticatorSavings.showPopup then
					TacticDisplay:Show();
				end
  				if(getn(TACTIC_TEMP_MSG) > 0) then
		  			for i = 1, getn(TACTIC_TEMP_MSG), 1 do
  						if (TACTIC_TEMP_MSG[i].sender == inSender) and not(strsub(TACTIC_TEMP_MSG[i].tactic, strlen(TACTIC_TEMP_MSG[i].tactic))==strchar(23)) then
		  					TACTIC_TEMP_MSG[i].tactic = TACTIC_TEMP_MSG[i].tactic .. inTactic;
  							matched = true;
  						end
  					end
  				end
  				if (not matched) then
					local new = {
  						sender = inSender;
  						tactic = inTactic;
  					};
  					TACTIC_TEMP_MSG[getn(TACTIC_TEMP_MSG)+1] = new;
  				end
  				if strbyte(TACTIC_TEMP_MSG[getn(TACTIC_TEMP_MSG)].tactic, strlen(TACTIC_TEMP_MSG[getn(TACTIC_TEMP_MSG)].tactic)) == 23 then
	  				TacticDisplayDropDownReceived_Initialize();
	  				UIDropDownMenu_SetSelectedID(TacticDisplayDropDownReceived, getn(TACTIC_TEMP_MSG));
					local box = getglobal("TacticDisplayScrollContainerScrollFrameEditBox");
					box:SetText(gsub(TACTIC_TEMP_MSG[getn(TACTIC_TEMP_MSG)].tactic, strchar(23), ""));
				end
			end
  		end
	end
end

function TacticatorConfigFrame_OnLoad(panel)
    panel.name = "Tacticator " .. GetAddOnMetadata("Tacticator", "Version");
    panel.okay = function(self) TacticatorConfig_Ok(); end;
    panel.cancel = function(self)  TacticatorConfig_OnCancelOrLoad();  end;
    InterfaceOptions_AddCategory(panel);
end

function TacticatorConfig_Ok()
    TacticatorSavings.showRaid = TacticatorConfigFrameRaid:GetChecked();
    TacticatorSavings.showParty = TacticatorConfigFrameParty:GetChecked();
    TacticatorSavings.showBG = TacticatorConfigFrameBG:GetChecked();
    TacticatorSavings.showPopup = TacticatorConfigFramePopup:GetChecked();
    TacticatorSavings.showPopupOwn = TacticatorConfigFramePopupOwn:GetChecked();
end

function TacticDisplay_OnCopy()
	local i = getn(TacticatorSavings.TACTIC_INSTANCE)+1;
	local box = getglobal("TacticDisplayScrollContainerScrollFrameEditBox");
	local nameIn = getglobal("TacticDisplayName"):GetText();
	local id = UIDropDownMenu_GetSelectedID(TacticDisplayDropDownReceived);
	if(not nameIn or nameIn == "") then
		nameIn = TACTIC_TEMP_MSG[id].sender..":"..id;
	end
	local new = {
		name = nameIn;
		tactic = box:GetText();
	};
	TacticatorSavings.TACTIC_INSTANCE[i] = new;
end

function Tacticator_RaidTarget(tag)
	TacticatorScrollContainerScrollFrameEditBox:Insert(tag);
end

function Tacticator_TargetRaidTarget(tag)
	SetRaidTarget("target", tag);
end

function Tacticator_ImportGD()
	local mobname = UnitName("target");
	for mob in pairs(moblist) do
		for nameidx in pairs(moblist[mob].name) do
			if (moblist[mob].name[nameidx]==mobname) then
				Tacticator_DescribeGD(moblist[mob]);
				return;
			end
		end
		for nameidx in pairs(moblist[mob].shortName) do
			if (moblist[mob].shortName[nameidx]==mobname) then
				Tacticator_DescribeGD(moblist[mob]);
				return;
			end
		end
	end
  if( DEFAULT_CHAT_FRAME ) then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff2222Mob not found");
  end
end

function Tacticator_DescribeGD(mob)
	for line in pairs(mob.description) do
		TacticatorScrollContainerScrollFrameEditBox:Insert(mob.description[line]);
		TacticatorScrollContainerScrollFrameEditBox:Insert(strchar(10));
	end
end

function Tacticator_ActorInsert(act)
	TacticatorScrollContainerScrollFrameEditBox:Insert("{"..act.."}");
end

function Tacticator_ActorCopy(buttonId)
	local box = getglobal("TacticatorActors"..buttonId);
	local actorName = UnitName("target");
	if (actorName) then
		box:SetText(actorName);
	end
end

function Tacticator_OpenActors()
	if(TacticatorActors:IsShown()) then
		TacticatorActors:Hide();
	else
		TacticatorActors:Show();
	end
end