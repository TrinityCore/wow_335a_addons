--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie.Spy = {};
GMGenie.Spy.waitingForPin = false;
GMGenie.Spy.pinCache = "";

function GMGenie.Spy.antiCheat(name)
    GMGenie.Spy.spy(name);
    GMGenie.Spy.antiCheatPlayer();
    GMGenie.Hud.toggleVisibility(false);
    GMGenie.Spy.appear();
end

function GMGenie.Spy.spy(name)
    if not name or string.len(name) < 1 or name == "%t" then
        name = UnitName("target");
    end
    if name and string.len(name) > 1 then
        GMGenie.Spy.waitingForPin = true;
        GMGenie.Spy.currentRequest = { account = "", accountId = "", class = "", email = "", gmLevel = "", guid = "", guild = "", ip = "", latency = "", level = "", location = "", login = "", money = "", name = "", phase = "", playedTime = "", race = "" };
        GMGenie.Spy.clearCache();
        GMGenie.Spy.resetBoxes();
        GMGenie.Spy.currentRequest["name"] = name;

        GMGenie.Spy.clearCache();
        SendChatMessage(".pin " .. name, "GUILD");
    else
        GMGenie.showGMMessage("Please enter a name or make sure you have someone targeted.");
    end
end

function GMGenie.Spy.clearCache()
    GMGenie.Spy.pinCache = "";
end

function GMGenie.Spy.addToCache(pin)
    GMGenie.Spy.pinCache = GMGenie.Spy.pinCache .. pin .. "\n";
end

function GMGenie.Spy.processPin01(offline, name1, guid, pin)
    GMGenie.Spy.currentRequest["name"] = name1;
    GMGenie.Spy.currentRequest["offline"] = offline;
    GMGenie.Spy.currentRequest["guid"] = guid;

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin02(phase, pin)
    GMGenie.Spy.currentRequest["phase"] = phase;

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin03(account, accountId, gmLevel, pin)
    GMGenie.Spy.currentRequest["account"] = account;
    GMGenie.Spy.currentRequest["accountId"] = accountId;
    GMGenie.Spy.currentRequest["gmLevel"] = gmLevel;

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin04(login, failedLogins, pin)
    GMGenie.Spy.currentRequest["login"] = login;
    -- todo failedLogins

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin05(os, latency, pin)
    -- todo os
    GMGenie.Spy.currentRequest["latency"] = latency;

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin06(email, pin)
    GMGenie.Spy.currentRequest["email"] = email;

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin07(ip, locked, pin)
    GMGenie.Spy.currentRequest["ip"] = ip;
    -- todo locked

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin08(level, pin)
    GMGenie.Spy.currentRequest["level"] = level;

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin09(race, class, pin)
    GMGenie.Spy.currentRequest["race"] = race;
    GMGenie.Spy.currentRequest["class"] = class;

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin10(alive, pin)
    -- todo alive

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin11(money, pin)
    GMGenie.Spy.currentRequest["money"] = money;

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin12(map, area, zone, pin)
    GMGenie.Spy.currentRequest["location"] = map;
    if map ~= area then
        GMGenie.Spy.currentRequest["location"] = area .. ', ' .. GMGenie.Spy.currentRequest["location"];
    end
    if string.upper(zone) ~= '<UNKNOWN>' then
        GMGenie.Spy.currentRequest["location"] = zone .. ', ' .. GMGenie.Spy.currentRequest["location"];
    end

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin13(guild, guildId, pin)
    GMGenie.Spy.currentRequest["guild"] = '<' .. guild .. '> (' .. guildId .. ')';

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin14(guildRank, pin)
    GMGenie.Spy.currentRequest["guild"] = '"' .. guildRank .. '" of ' .. GMGenie.Spy.currentRequest["guild"];

    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin15(note, pin)
    -- todo note
    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin16(officerNote, pin)
    -- todo officerNote
    GMGenie.Spy.addToCache(pin);
end

function GMGenie.Spy.processPin17(playedTime, pin)
    GMGenie.Spy.currentRequest["playedTime"] = playedTime;

    GMGenie.Spy.addToCache(pin);

    GMGenie.Spy.waitingForPin = false;
    GMGenie.Spy.waitingForMail = true;
    Chronos.scheduleByName('mailinpinprotection', 2, GMGenie.Spy.abortWaitingForMail);
    GMGenie.Spy.resetBoxes();
    GMGenie_Spy_InfoWindow:Show();
end

function GMGenie.Spy.processPin18(read, total, pin)
    GMGenie.Spy.addToCache(pin);

    GMGenie.Spy.waitingForMail = false;
    Chronos.unscheduleByName('mailinpinprotection');
    GMGenie.Spy.resetBoxes();
    GMGenie_Spy_InfoWindow:Show();
end

function GMGenie.Spy.abortWaitingForMail()
    GMGenie.Spy.waitingForMail = false;
end

function GMGenie.Spy.resetBoxes()
    GMGenie_Spy_InfoWindow_Info_CharInfo:SetText("Level " .. GMGenie.Spy.currentRequest["level"] .. " " .. GMGenie.Spy.currentRequest["race"] .. " " .. GMGenie.Spy.currentRequest["class"]);
    GMGenie_Spy_InfoWindow_Info_Guild:SetText(GMGenie.Spy.currentRequest["guild"]);
    GMGenie_Spy_InfoWindow_Title_Text:SetText(GMGenie.Spy.currentRequest["name"]);
    GMGenie_Spy_InfoWindow_Character_Name:SetText(GMGenie.Spy.currentRequest["name"]);
    GMGenie_Spy_InfoWindow_Character_Id:SetText(GMGenie.Spy.currentRequest["guid"]);
    GMGenie_Spy_InfoWindow_Account_Name:SetText(GMGenie.Spy.currentRequest["account"]);
    GMGenie_Spy_InfoWindow_Account_Id:SetText(GMGenie.Spy.currentRequest["accountId"]);
    GMGenie_Spy_InfoWindow_Email_Email:SetText(GMGenie.Spy.currentRequest["email"]);
    GMGenie_Spy_InfoWindow_IpLat_Ip:SetText(GMGenie.Spy.currentRequest["ip"]);
    if tonumber(GMGenie.Spy.currentRequest["latency"]) and tonumber(GMGenie.Spy.currentRequest["latency"]) > 1000 then
        GMGenie_Spy_InfoWindow_IpLat_Latency:SetFontObject(GenieFontRedSmall);
    else
        GMGenie_Spy_InfoWindow_IpLat_Latency:SetFontObject(GenieFontHighlightSmall);
    end
    GMGenie_Spy_InfoWindow_IpLat_Latency:SetText(GMGenie.Spy.currentRequest["latency"]);
    GMGenie_Spy_InfoWindow_LastLogin_LastLogin:SetText(GMGenie.Spy.currentRequest["login"]);
    GMGenie_Spy_InfoWindow_PlayedGM_PlayedTime:SetText(GMGenie.Spy.currentRequest["playedTime"]);
    GMGenie_Spy_InfoWindow_PlayedGM_GM:SetText(GMGenie.Spy.currentRequest["gmLevel"]);
    GMGenie_Spy_InfoWindow_MoneyPhase_Money:SetText(GMGenie.Spy.currentRequest["money"]);
    GMGenie_Spy_InfoWindow_MoneyPhase_Phase:SetText(GMGenie.Spy.currentRequest["phase"]);
    GMGenie_Spy_InfoWindow_Location_Location:SetText(GMGenie.Spy.currentRequest["location"]);
    GMGenie_Spy_InfoWindow_Location_Location:SetCursorPosition(0);
end

function GMGenie.Spy.loadDropdown(_, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Ban Info';
    info.func = GMGenie.Spy.banInfo;
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Lookup Player';
    info.func = GMGenie.Spy.lookupPlayer;
    UIDropDownMenu_AddButton(info, level);
end

SLASH_SPY1 = "/spy";
SlashCmdList["SPY"] = GMGenie.Spy.spy;

function GMGenie.Spy.copyPin()
    GMGenie.showGMMessage(GMGenie.Spy.pinCache);
end

function GMGenie.Spy.whisper()
    ChatFrame_SendTell(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.summon()
    GMGenie.Macros.summon(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.appear()
    GMGenie.Macros.appear(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.revive()
    GMGenie.Macros.revive(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.freeze()
    GMGenie.Macros.freeze(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.unfreeze()
    GMGenie.Macros.unfreeze(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.rename()
    GMGenie.Macros.rename(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.antiCheatPlayer()
    GMGenie.Macros.antiCheatPlayer(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.customize()
    GMGenie.Macros.customize(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.changefaction()
    GMGenie.Macros.changefaction(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.changerace()
    GMGenie.Macros.changerace(GMGenie.Spy.currentRequest["name"]);
end

function GMGenie.Spy.banInfo()
    CloseDropDownMenus()
    SendChatMessage(".baninfo account " .. GMGenie.Spy.currentRequest["account"], "GUILD");
    SendChatMessage(".baninfo character " .. GMGenie.Spy.currentRequest["name"], "GUILD");
    SendChatMessage(".baninfo ip " .. GMGenie.Spy.currentRequest["ip"], "GUILD");
end

function GMGenie.Spy.lookupPlayer()
    CloseDropDownMenus()
    SendChatMessage(".lookup player account " .. GMGenie.Spy.currentRequest["account"], "GUILD");
    SendChatMessage(".lookup player email " .. GMGenie.Spy.currentRequest["email"], "GUILD");
    SendChatMessage(".lookup player ip " .. GMGenie.Spy.currentRequest["ip"], "GUILD");
end

local Saved_SetItemRef = SetItemRef;
function SetItemRef(link, text, button, chatFrame)
    if (strsub(link, 1, 9) == "anticheat") then
        local _, name = strsplit(":", link);
        if (button == "LeftButton") then
            GMGenie.Spy.antiCheat(name);
        elseif (button == "RightButton") then
            FriendsFrame_ShowDropdown(name, 1);
        end
        return;
    end
    Saved_SetItemRef(link, text, button, chatFrame);
end
