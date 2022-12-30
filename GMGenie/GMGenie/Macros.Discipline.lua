--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie.Macros.Discipline = {};
GMGenie.Macros.Discipline.Mute = {};
GMGenie.Macros.Discipline.CharBan = {};
GMGenie.Macros.Discipline.AccBan = {};
GMGenie.Macros.Discipline.IpBan = {};

function GMGenie.Macros.Discipline.Mute.run(name, title)
    if GMGenie_SavedVars.mute[title]["announceToServer"] then
        SendChatMessage('.name ' .. name .. ' has been muted for ' .. GMGenie_SavedVars.mute[title]["duration"] .. ' minutes. Reason: ' .. GMGenie_SavedVars.mute[title]["reason"], "GUILD");
    else
        SendChatMessage('.gmname ' .. name .. ' has been muted for ' .. GMGenie_SavedVars.mute[title]["duration"] .. ' minutes. Reason: ' .. GMGenie_SavedVars.mute[title]["reason"], "GUILD");
    end
    SendChatMessage('.mute ' .. name .. ' ' .. GMGenie_SavedVars.mute[title]["duration"] .. ' ' .. GMGenie_SavedVars.mute[title]["reason"], "GUILD");
end

function GMGenie.Macros.Discipline.Mute.runFromSpy(self)
    CloseDropDownMenus();
    if GMGenie.Spy.currentRequest["name"] then
        GMGenie.Macros.Discipline.Mute.run(GMGenie.Spy.currentRequest["name"], self.value);
    end
end

function GMGenie.Macros.Discipline.Mute.addToUnitMenu()
    UnitPopupMenus["GMGenie_Mute"] = {};
    local MuteTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.mute);
    for _, name in pairs(MuteTemp) do
        table.insert(UnitPopupMenus["GMGenie_Mute"], "GMGenie_Mute_" .. name);
        UnitPopupButtons["GMGenie_Mute_" .. name] = { text = name, dist = 0, };
    end

    table.insert(UnitPopupMenus["GMGenie_Mute"], "GMGenie_DisciplineOptions");
    UnitPopupButtons["GMGenie_DisciplineOptions"] = { text = "Manage macros", dist = 0, };
end

function GMGenie.Macros.Discipline.Mute.loadDropdown(_, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Mutes";
    UIDropDownMenu_AddButton(info, level);

    local MuteTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.mute);
    for _, name in pairs(MuteTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = GMGenie.Macros.Discipline.Mute.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = GMGenie.Macros.Discipline.showOptions;
    UIDropDownMenu_AddButton(info, level);
end



function GMGenie.Macros.Discipline.CharBan.run(name, title)
    if GMGenie_SavedVars.charBan[title]["announceToServer"] then
        SendChatMessage('.name ' .. name .. ' has been banned for ' .. GMGenie_SavedVars.charBan[title]["duration"] .. '. Reason: ' .. GMGenie_SavedVars.charBan[title]["reason"], "GUILD");
    else
        SendChatMessage('.gmname ' .. name .. ' has been banned for ' .. GMGenie_SavedVars.charBan[title]["duration"] .. '. Reason: ' .. GMGenie_SavedVars.charBan[title]["reason"], "GUILD");
    end
    SendChatMessage('.ban char ' .. name .. ' ' .. GMGenie_SavedVars.charBan[title]["duration"] .. ' ' .. GMGenie_SavedVars.charBan[title]["reason"], "GUILD");
end

function GMGenie.Macros.Discipline.CharBan.runFromSpy(self)
    CloseDropDownMenus();
    if GMGenie.Spy.currentRequest["name"] then
        GMGenie.Macros.Discipline.CharBan.run(GMGenie.Spy.currentRequest["name"], self.value);
    end
end

function GMGenie.Macros.Discipline.CharBan.addToUnitMenu()
    UnitPopupMenus["GMGenie_CharBan"] = {};
    local CharBanTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.charBan);
    for _, name in pairs(CharBanTemp) do
        table.insert(UnitPopupMenus["GMGenie_CharBan"], "GMGenie_CharBan_" .. name);
        UnitPopupButtons["GMGenie_CharBan_" .. name] = { text = name, dist = 0, };
    end

    table.insert(UnitPopupMenus["GMGenie_CharBan"], "GMGenie_DisciplineOptions");
    UnitPopupButtons["GMGenie_DisciplineOptions"] = { text = "Manage macros", dist = 0, };
end

function GMGenie.Macros.Discipline.CharBan.loadDropdown(_, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Character Bans";
    UIDropDownMenu_AddButton(info, level);

    local CharBanTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.charBan);
    for _, name in pairs(CharBanTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = GMGenie.Macros.Discipline.CharBan.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = GMGenie.Macros.Discipline.showOptions;
    UIDropDownMenu_AddButton(info, level);
end



function GMGenie.Macros.Discipline.AccBan.run(name, title)
    if GMGenie_SavedVars.accBan[title]["announceToServer"] then
        SendChatMessage('.name ' .. name .. ' has been account banned for ' .. GMGenie_SavedVars.accBan[title]["duration"] .. '. Reason: ' .. GMGenie_SavedVars.accBan[title]["reason"], "GUILD");
    else
        SendChatMessage('.gmname ' .. name .. ' has been account banned for ' .. GMGenie_SavedVars.accBan[title]["duration"] .. '. Reason: ' .. GMGenie_SavedVars.accBan[title]["reason"], "GUILD");
    end
    SendChatMessage('.ban playeraccount ' .. name .. ' ' .. GMGenie_SavedVars.accBan[title]["duration"] .. ' ' .. GMGenie_SavedVars.accBan[title]["reason"], "GUILD");
end

function GMGenie.Macros.Discipline.AccBan.runFromSpy(self)
    CloseDropDownMenus();
    if GMGenie.Spy.currentRequest["name"] then
        GMGenie.Macros.Discipline.AccBan.run(GMGenie.Spy.currentRequest["name"], self.value);
    end
end

function GMGenie.Macros.Discipline.AccBan.addToUnitMenu()
    UnitPopupMenus["GMGenie_AccBan"] = {};
    local AccBanTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.accBan);
    for _, name in pairs(AccBanTemp) do
        table.insert(UnitPopupMenus["GMGenie_AccBan"], "GMGenie_AccBan_" .. name);
        UnitPopupButtons["GMGenie_AccBan_" .. name] = { text = name, dist = 0, };
    end

    table.insert(UnitPopupMenus["GMGenie_AccBan"], "GMGenie_DisciplineOptions");
    UnitPopupButtons["GMGenie_DisciplineOptions"] = { text = "Manage macros", dist = 0, };
end

function GMGenie.Macros.Discipline.AccBan.loadDropdown(_, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Account Bans";
    UIDropDownMenu_AddButton(info, level);

    local AccBanTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.accBan);
    for _, name in pairs(AccBanTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = GMGenie.Macros.Discipline.AccBan.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = GMGenie.Macros.Discipline.showOptions;
    UIDropDownMenu_AddButton(info, level);
end










GMGenie.Macros.Discipline.IpBan.name = false;
GMGenie.Macros.Discipline.IpBan.duration = false;
GMGenie.Macros.Discipline.IpBan.reason = false;
GMGenie.Macros.Discipline.IpBan.announceToServer = false;

function GMGenie.Macros.Discipline.IpBan.processPin(ip)
    GMGenie.Macros.Discipline.IpBan.waitingForPin = false;

    if GMGenie.Macros.Discipline.IpBan.announceToServer then
        SendChatMessage('.name ' .. GMGenie.Macros.Discipline.IpBan.name .. ' has been ip banned for ' .. GMGenie.Macros.Discipline.IpBan.duration .. '. Reason: ' .. GMGenie.Macros.Discipline.IpBan.reason, "GUILD");
    end
    SendChatMessage('.gmname ' .. GMGenie.Macros.Discipline.IpBan.name .. ' has been ip banned (' .. ip .. ') for ' .. GMGenie.Macros.Discipline.IpBan.duration .. '. Reason: ' .. GMGenie.Macros.Discipline.IpBan.reason, "GUILD");

    SendChatMessage('.ban ip ' .. ip .. " " .. GMGenie.Macros.Discipline.IpBan.duration .. " " .. GMGenie.Macros.Discipline.IpBan.reason, "GUILD");
    Chronos.unscheduleByName('ipbanprotection');
end

function GMGenie.Macros.Discipline.IpBan.fail()
    GMGenie.Macros.Discipline.IpBan.waitingForPin = false;
    GMGenie.showGMMessage("IP ban on " .. GMGenie.Macros.Discipline.IpBan.name .. " failed. This could be due to server lag. Please try again.");
end

function GMGenie.Macros.Discipline.IpBan.run(name, title)
    GMGenie.Macros.Discipline.IpBan.waitingForPin = true;
    SendChatMessage('.pin ' .. name, "GUILD");
    GMGenie.Macros.Discipline.IpBan.name = name;
    GMGenie.Macros.Discipline.IpBan.duration = GMGenie_SavedVars.ipBan[title]["duration"];
    GMGenie.Macros.Discipline.IpBan.reason = GMGenie_SavedVars.ipBan[title]["reason"];
    GMGenie.Macros.Discipline.IpBan.announceToServer = GMGenie_SavedVars.ipBan[title]["announceToServer"];

    Chronos.scheduleByName('ipbanprotection', 2, GMGenie.Macros.Discipline.IpBan.fail);
end

function GMGenie.Macros.Discipline.IpBan.runFromSpy(self)
    CloseDropDownMenus();
    if GMGenie.Spy.currentRequest["name"] then
        GMGenie.Macros.Discipline.IpBan.run(GMGenie.Spy.currentRequest["name"], self.value);
    end
end

function GMGenie.Macros.Discipline.IpBan.addToUnitMenu()
    UnitPopupMenus["GMGenie_IpBan"] = {};
    local IpBanTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.ipBan);
    for _, name in pairs(IpBanTemp) do
        table.insert(UnitPopupMenus["GMGenie_IpBan"], "GMGenie_IpBan_" .. name);
        UnitPopupButtons["GMGenie_IpBan_" .. name] = { text = name, dist = 0, };
    end

    table.insert(UnitPopupMenus["GMGenie_IpBan"], "GMGenie_DisciplineOptions");
    UnitPopupButtons["GMGenie_DisciplineOptions"] = { text = "Manage macros", dist = 0, };
end

function GMGenie.Macros.Discipline.IpBan.loadDropdown(_, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Ip Bans";
    UIDropDownMenu_AddButton(info, level);

    local IpBanTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.ipBan);
    for _, name in pairs(IpBanTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = GMGenie.Macros.Discipline.IpBan.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = GMGenie.Macros.Discipline.showOptions;
    UIDropDownMenu_AddButton(info, level);
end
