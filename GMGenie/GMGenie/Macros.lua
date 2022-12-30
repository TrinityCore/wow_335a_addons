--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie.Macros = {};

function GMGenie.Macros.onLoad()
    GMGenie.Macros.menuItems = {};

    UnitPopupButtons["GMGenie_Commands"] = { text = "Quick Commands", dist = 0, nested = 1 };
    table.insert(GMGenie.Macros.menuItems, "Commands");
    UnitPopupMenus["GMGenie_Commands"] = {};

    UnitPopupButtons["GMGenie_Revive"] = { text = "Revive", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Commands"], "GMGenie_Revive");
    UnitPopupButtons["GMGenie_Appear"] = { text = "Appear", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Commands"], "GMGenie_Appear");
    UnitPopupButtons["GMGenie_Summon"] = { text = "Summon", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Commands"], "GMGenie_Summon");
    UnitPopupButtons["GMGenie_Freeze"] = { text = "Freeze", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Commands"], "GMGenie_Freeze");
    UnitPopupButtons["GMGenie_Unfreeze"] = { text = "Unfreeze", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Commands"], "GMGenie_Unfreeze");
    UnitPopupButtons["GMGenie_Spy"] = { text = "Spy", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Commands"], "GMGenie_Spy");

    UnitPopupButtons["GMGenie_Character"] = { text = "Character", dist = 0, nested = 1 };
    table.insert(GMGenie.Macros.menuItems, "Character");
    UnitPopupMenus["GMGenie_Character"] = {};

    UnitPopupButtons["GMGenie_Character_Rename"] = { text = "Rename", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Character"], "GMGenie_Character_Rename");
    UnitPopupButtons["GMGenie_Character_Customize"] = { text = "Customize", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Character"], "GMGenie_Character_Customize");
    UnitPopupButtons["GMGenie_Character_Changerace"] = { text = "Change Race", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Character"], "GMGenie_Character_Changerace");
    UnitPopupButtons["GMGenie_Character_Changefaction"] = { text = "Change Faction", dist = 0 };
    table.insert(UnitPopupMenus["GMGenie_Character"], "GMGenie_Character_Changefaction");

    UnitPopupButtons["GMGenie_Whispers"] = { text = "Whisper Macros", dist = 0, nested = 1 };
    table.insert(GMGenie.Macros.menuItems, "Whispers");
    GMGenie.Macros.Whispers.addToUnitMenu();

    UnitPopupButtons["GMGenie_Mail"] = { text = "Mail Macros", dist = 0, nested = 1 };
    table.insert(GMGenie.Macros.menuItems, "Mail");
    GMGenie.Macros.Mail.addToUnitMenu();

    UnitPopupButtons["GMGenie_Tele"] = { text = "Teleport Macros", dist = 0, nested = 1 };
    table.insert(GMGenie.Macros.menuItems, "Tele");
    GMGenie.Macros.Tele.addToUnitMenu();

    UnitPopupButtons["GMGenie_Mute"] = { text = "Mutes", dist = 0, nested = 1 };
    table.insert(GMGenie.Macros.menuItems, "Mute");
    GMGenie.Macros.Discipline.Mute.addToUnitMenu();

    UnitPopupButtons["GMGenie_CharBan"] = { text = "Character Bans", dist = 0, nested = 1 };
    table.insert(GMGenie.Macros.menuItems, "CharBan");
    GMGenie.Macros.Discipline.CharBan.addToUnitMenu();

    UnitPopupButtons["GMGenie_AccBan"] = { text = "Account Bans", dist = 0, nested = 1 };
    table.insert(GMGenie.Macros.menuItems, "AccBan");
    GMGenie.Macros.Discipline.AccBan.addToUnitMenu();

    UnitPopupButtons["GMGenie_IpBan"] = { text = "Ip Bans", dist = 0, nested = 1 };
    table.insert(GMGenie.Macros.menuItems, "IpBan");
    GMGenie.Macros.Discipline.IpBan.addToUnitMenu();

    for _, button in ipairs(GMGenie.Macros.menuItems) do
        table.insert(UnitPopupMenus["PLAYER"], #UnitPopupMenus["PLAYER"] - 1, "GMGenie_" .. button);
        table.insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"] - 1, "GMGenie_" .. button);
        table.insert(UnitPopupMenus["PARTY"], #UnitPopupMenus["PARTY"] - 1, "GMGenie_" .. button);
        table.insert(UnitPopupMenus["RAID_PLAYER"], #UnitPopupMenus["RAID_PLAYER"] - 1, "GMGenie_" .. button);
        table.insert(UnitPopupMenus["TEAM"], #UnitPopupMenus["TEAM"] - 1, "GMGenie_" .. button);
        table.insert(UnitPopupMenus["CHAT_ROSTER"], #UnitPopupMenus["CHAT_ROSTER"] - 1, "GMGenie_" .. button);
    end

    hooksecurefunc("UnitPopup_OnClick", GMGenie.Macros.contextMenuClick);
    UIDropDownMenu_Initialize(GMGenie_Spy_InfoWindow_DropdownbuttonsOne, GMGenie.Macros.loadDropdown, "MENU");
end

function GMGenie.Macros.contextMenuClick(self)
    local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
    local button = self.value;
    local name = dropdownFrame.name;
    local startPos = string.find(button, "GMGenie_");

    if (startPos == 1) then
        button = string.sub(button, 9);

        if button == "Revive" then
            GMGenie.Macros.revive(name);
        elseif button == "Appear" then
            GMGenie.Macros.appear(name);
        elseif button == "Summon" then
            GMGenie.Macros.summon(name);
        elseif button == "Freeze" then
            GMGenie.Macros.freeze(name);
        elseif button == "Unfreeze" then
            GMGenie.Macros.unfreeze(name);
        elseif button == "Spy" then
            GMGenie.Spy.spy(name);
        elseif button == "Character_Rename" then
            GMGenie.Macros.rename(name);
        elseif button == "Character_Customize" then
            GMGenie.Macros.customize(name);
        elseif button == "Character_Changerace" then
            GMGenie.Macros.changerace(name);
        elseif button == "Character_Changefaction" then
            GMGenie.Macros.changefaction(name);
        elseif button == "WhisperOptions" then
            GMGenie.Macros.Whispers.showOptions();
        elseif button == "MailOptions" then
            GMGenie.Macros.Mail.showOptions();
        elseif button == "TeleOptions" then
            GMGenie.Macros.Tele.showOptions();
        elseif button == "DisciplineOptions" then
            GMGenie.Macros.Discipline.showOptions();
        else
            local isWhisperMacro = string.find(button, "Whispers_");
            local isMailMacro = string.find(button, "Mail_");
            local isTeleMacro = string.find(button, "Tele_");
            local isMuteMacro = string.find(button, "Mute_");
            local isCharBanMacro = string.find(button, "CharBan_");
            local isAccBanMacro = string.find(button, "AccBan_");
            local isIpBanMacro = string.find(button, "IpBan_");
            if isWhisperMacro == 1 then
                GMGenie.Macros.Whispers.run(name, string.sub(button, 10));
            elseif isMailMacro == 1 then
                GMGenie.Macros.Mail.run(name, string.sub(button, 6));
            elseif isTeleMacro == 1 then
                GMGenie.Macros.Tele.run(name, string.sub(button, 6));
            elseif isMuteMacro == 1 then
                GMGenie.Macros.Discipline.Mute.run(name, string.sub(button, 6));
            elseif isCharBanMacro == 1 then
                GMGenie.Macros.Discipline.CharBan.run(name, string.sub(button, 9));
            elseif isAccBanMacro == 1 then
                GMGenie.Macros.Discipline.AccBan.run(name, string.sub(button, 8));
            elseif isIpBanMacro == 1 then
                GMGenie.Macros.Discipline.IpBan.run(name, string.sub(button, 7));
            end
        end
    end

    CloseDropDownMenus();
end

function GMGenie.Macros.loadDropdown(self, level)
    local level = level or 1;

    if level == 1 then
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Character";
        info.value = "character";
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Whisper Macros";
        info.value = "whispers";
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Mail Macros";
        info.value = "mail";
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Teleport Macros";
        info.value = "tele";
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Mutes";
        info.value = "mute";
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Character Bans";
        info.value = "charBan";
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Account Bans";
        info.value = "accBan";
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Ip Bans";
        info.value = "ipBan";
        UIDropDownMenu_AddButton(info, level);

    elseif level == 2 then
        if UIDROPDOWNMENU_MENU_VALUE == "character" then
            local info = UIDropDownMenu_CreateInfo();
            info.hasArrow = false;
            info.notCheckable = true;
            info.text = "Rename";
            info.func = GMGenie.Spy.rename;
            UIDropDownMenu_AddButton(info, level);

            local info = UIDropDownMenu_CreateInfo();
            info.hasArrow = false;
            info.notCheckable = true;
            info.text = "Customize";
            info.func = GMGenie.Spy.customize;
            UIDropDownMenu_AddButton(info, level);

            local info = UIDropDownMenu_CreateInfo();
            info.hasArrow = false;
            info.notCheckable = true;
            info.text = "Change Faction";
            info.func = GMGenie.Spy.changefaction;
            UIDropDownMenu_AddButton(info, level);

            local info = UIDropDownMenu_CreateInfo();
            info.hasArrow = false;
            info.notCheckable = true;
            info.text = "Change Race";
            info.func = GMGenie.Spy.changerace;
            UIDropDownMenu_AddButton(info, level);

        elseif UIDROPDOWNMENU_MENU_VALUE == "whispers" then
            GMGenie.Macros.Whispers.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "mail" then
            GMGenie.Macros.Mail.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "tele" then
            GMGenie.Macros.Tele.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "mute" then
            GMGenie.Macros.Discipline.Mute.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "charBan" then
            GMGenie.Macros.Discipline.CharBan.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "accBan" then
            GMGenie.Macros.Discipline.AccBan.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "ipBan" then
            GMGenie.Macros.Discipline.IpBan.loadDropdown(self, level);
        end
    end
end

function GMGenie.Macros.revive(name)
    SendChatMessage(".revive " .. name, "GUILD");
end

function GMGenie.Macros.appear(name)
    SendChatMessage(".appear " .. name, "GUILD");
end

function GMGenie.Macros.summon(name)
    SendChatMessage(".summon " .. name, "GUILD");
end

function GMGenie.Macros.freeze(name)
    SendChatMessage(".freeze " .. name, "GUILD");
end

function GMGenie.Macros.unfreeze(name)
    SendChatMessage(".unfreeze " .. name, "GUILD");
end

function GMGenie.Macros.antiCheatPlayer(name)
    SendChatMessage(".anticheat player " .. name, "GUILD");
end

function GMGenie.Macros.rename(name)
    SendChatMessage(".char rename " .. name, "GUILD");
end

function GMGenie.Macros.customize(name)
    SendChatMessage(".char customize " .. name, "GUILD");
end

function GMGenie.Macros.changefaction(name)
    SendChatMessage(".char changefaction " .. name, "GUILD");
end

function GMGenie.Macros.changerace(name)
    SendChatMessage(".char changerace " .. name, "GUILD");
end
