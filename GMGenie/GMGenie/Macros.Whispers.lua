--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie.Macros.Whispers = {};

GMGenie.Macros.Whispers.curWhisperMessage = '';


function GMGenie.Macros.Whispers.run(name, title)
    GMGenie_Macros_Whispers_SubjectPopup:Hide();
    GMGenie_Macros_Whispers_SubjectPopup_Subject:SetText('');
    local msg = string.gsub(GMGenie_SavedVars.whispers[title], "NAME", name);
    if string.find(msg, "SUBJECT") then
        GMGenie.Macros.Whispers.curWhisperMessage = msg;
        GMGenie.Macros.Whispers.curName = name;
        GMGenie_Macros_Whispers_SubjectPopup:Show();
        GMGenie_Macros_Whispers_SubjectPopup_Subject:SetFocus();
    else
        local args = { strsplit("\n", msg) };
        for _, text in pairs(args) do
            SendChatMessage(text, "WHISPER", nil, name);
        end
    end
end

function GMGenie.Macros.Whispers.runFromSpy(self)
    CloseDropDownMenus();
    if GMGenie.Spy.currentRequest["name"] then
        GMGenie.Macros.Whispers.run(GMGenie.Spy.currentRequest["name"], self.value);
    end
end

function GMGenie.Macros.Whispers.sendWithSubject()
    GMGenie_Macros_Whispers_SubjectPopup:Hide();
    local subject = GMGenie_Macros_Whispers_SubjectPopup_Subject:GetText();
    GMGenie_Macros_Whispers_SubjectPopup_Subject:SetText('');

    local msg = string.gsub(GMGenie.Macros.Whispers.curWhisperMessage, "SUBJECT", subject);
    local args = { strsplit("\n", msg) };
    for _, text in pairs(args) do
        SendChatMessage(text, "WHISPER", nil, GMGenie.Macros.Whispers.curName);
    end

    GMGenie.Macros.Whispers.curWhisperMessage = '';
end

function GMGenie.Macros.Whispers.addToUnitMenu()
    UnitPopupMenus["GMGenie_Whispers"] = {};

    local whispersTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.whispers);
    for _, name in pairs(whispersTemp) do
        table.insert(UnitPopupMenus["GMGenie_Whispers"], "GMGenie_Whispers_" .. name);
        UnitPopupButtons["GMGenie_Whispers_" .. name] = { text = name, dist = 0, };
    end

    table.insert(UnitPopupMenus["GMGenie_Whispers"], "GMGenie_WhisperOptions");
    UnitPopupButtons["GMGenie_WhisperOptions"] = { text = "Manage macros", dist = 0, };
end

function GMGenie.Macros.Whispers.loadDropdown(_, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Whisper Macros";
    UIDropDownMenu_AddButton(info, level);

    local whispersTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.whispers);
    for _, name in pairs(whispersTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = GMGenie.Macros.Whispers.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = GMGenie.Macros.Whispers.showOptions;
    UIDropDownMenu_AddButton(info, level);
end
