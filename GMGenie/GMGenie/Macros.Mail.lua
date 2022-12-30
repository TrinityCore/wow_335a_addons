--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie.Macros.Mail = {};

GMGenie.Macros.Mail.curMailMessage = '';


function GMGenie.Macros.Mail.run(name, title)
    local text = GMGenie_SavedVars.mail[title].macro;
    local text = string.gsub(text, "NAME", name);
    local lines = { strsplit("\n", text) };
    local subject = GMGenie_SavedVars.mail[title].subject;

    for index, line in pairs(lines) do
        local command = '.send mail ' .. name .. ' "' .. subject;
        if #lines > 1 then
            command = command .. ' ' .. index .. '/' .. (#lines);
        end
        local command = command .. '" "' .. line .. '"';
        SendChatMessage(command, "GUILD");
    end
end

function GMGenie.Macros.Mail.runFromSpy(self)
    CloseDropDownMenus();
    if GMGenie.Spy.currentRequest["name"] then
        GMGenie.Macros.Mail.run(GMGenie.Spy.currentRequest["name"], self.value);
    end
end

function GMGenie.Macros.Mail.addToUnitMenu()
    UnitPopupMenus["GMGenie_Mail"] = {};
    local MailTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.mail);
    for _, name in pairs(MailTemp) do
        table.insert(UnitPopupMenus["GMGenie_Mail"], "GMGenie_Mail_" .. name);
        UnitPopupButtons["GMGenie_Mail_" .. name] = { text = name, dist = 0, };
    end

    table.insert(UnitPopupMenus["GMGenie_Mail"], "GMGenie_MailOptions");
    UnitPopupButtons["GMGenie_MailOptions"] = { text = "Manage macros", dist = 0, };
end

function GMGenie.Macros.Mail.loadDropdown(_, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Mail Macros";
    UIDropDownMenu_AddButton(info, level);

    local MailTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.mail);
    for _, name in pairs(MailTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = GMGenie.Macros.Mail.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = GMGenie.Macros.Mail.showOptions;
    UIDropDownMenu_AddButton(info, level);
end
