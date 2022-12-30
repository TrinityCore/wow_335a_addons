--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie.Macros.Tele = {};

function GMGenie.Macros.Tele.run(name, title)
    if GMGenie_SavedVars.tele[title] == "RECALL" then
        SendChatMessage('.recall ' .. name, "GUILD");
    else
        SendChatMessage('.tele name ' .. name .. ' ' .. GMGenie_SavedVars.tele[title], "GUILD");
    end
end

function GMGenie.Macros.Tele.runFromSpy(self)
    CloseDropDownMenus();
    if GMGenie.Spy.currentRequest["name"] then
        GMGenie.Macros.Tele.run(GMGenie.Spy.currentRequest["name"], self.value);
    end
end

function GMGenie.Macros.Tele.addToUnitMenu()
    UnitPopupMenus["GMGenie_Tele"] = {};
    local TeleTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.tele);
    for _, name in pairs(TeleTemp) do
        table.insert(UnitPopupMenus["GMGenie_Tele"], "GMGenie_Tele_" .. name);
        UnitPopupButtons["GMGenie_Tele_" .. name] = { text = name, dist = 0, };
    end

    table.insert(UnitPopupMenus["GMGenie_Tele"], "GMGenie_TeleOptions");
    UnitPopupButtons["GMGenie_TeleOptions"] = { text = "Manage macros", dist = 0, };
end

function GMGenie.Macros.Tele.loadDropdown(_, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Teleport Macros";
    UIDropDownMenu_AddButton(info, level);

    local TeleTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.tele);
    for _, name in pairs(TeleTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = GMGenie.Macros.Tele.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = GMGenie.Macros.Tele.showOptions;
    UIDropDownMenu_AddButton(info, level);
end
