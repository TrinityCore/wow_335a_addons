--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function GMGenie.Macros.Discipline.optionsOnLoad()
    local panel = getglobal("GMGenie_Macros_Discipline_OptionsFrame");
    panel.name = "Discipline Macros";
    panel.parent = "GM Genie";
    InterfaceOptions_AddCategory(panel);

    GMGenie_Macros_Discipline_OptionsWindow_Title:SetText("Discipline Macros");
    GMGenie_Macros_Discipline_OptionsWindow_SubText:SetText("Here you add and update mute and ban macros, which will be available from the playerinfo window and the player context menus.");

    UIDropDownMenu_Initialize(getglobal("GMGenie_Macros_Discipline_OptionsWindow_Mute_Dropdownbuttons"), GMGenie.Macros.Discipline.Mute.loadOptionsDropdown, "MENU");
    UIDropDownMenu_Initialize(getglobal("GMGenie_Macros_Discipline_OptionsWindow_CharBan_Dropdownbuttons"), GMGenie.Macros.Discipline.CharBan.loadOptionsDropdown, "MENU");
    UIDropDownMenu_Initialize(getglobal("GMGenie_Macros_Discipline_OptionsWindow_AccBan_Dropdownbuttons"), GMGenie.Macros.Discipline.AccBan.loadOptionsDropdown, "MENU");
    UIDropDownMenu_Initialize(getglobal("GMGenie_Macros_Discipline_OptionsWindow_IpBan_Dropdownbuttons"), GMGenie.Macros.Discipline.IpBan.loadOptionsDropdown, "MENU");
end

function GMGenie.Macros.Discipline.showOptions()
    InterfaceOptionsFrame_OpenToCategory("Discipline Macros");
end


--Mute
GMGenie.Macros.Discipline.Mute.currentEditing = nil;

function GMGenie.Macros.Discipline.Mute.loadOptionsDropdown()
    local MuteTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.mute);
    for _, name in pairs(MuteTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = GMGenie.Macros.Discipline.Mute.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function GMGenie.Macros.Discipline.Mute.edit(self)
    GMGenie.Macros.Discipline.Mute.currentEditing = self.value;
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Name:SetText(self.value);
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Duration:SetText(GMGenie_SavedVars.mute[self.value]["duration"]);
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Reason:SetText(GMGenie_SavedVars.mute[self.value]["reason"]);
    GMGenie_Macros_Discipline_OptionsWindow_Mute_AnnounceToServer:SetChecked(GMGenie_SavedVars.mute[self.value]["announceToServer"]);
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Save:SetText("Save");
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Delete:Enable();
end

function GMGenie.Macros.Discipline.Mute.save()
    local name = GMGenie_Macros_Discipline_OptionsWindow_Mute_Name:GetText();
    local duration = GMGenie_Macros_Discipline_OptionsWindow_Mute_Duration:GetText();
    local reason = GMGenie_Macros_Discipline_OptionsWindow_Mute_Reason:GetText();
    local announceToServer = GMGenie_Macros_Discipline_OptionsWindow_Mute_AnnounceToServer:GetChecked();

    if name and duration and reason then
        GMGenie_SavedVars.mute[name] = { duration = duration, reason = reason, announceToServer = announceToServer };

        if GMGenie.Macros.Discipline.Mute.currentEditing then
            if (name ~= GMGenie.Macros.Discipline.Mute.currentEditing) then
                GMGenie_SavedVars.mute[GMGenie.Macros.Discipline.Mute.currentEditing] = nil;
                GMGenie.Macros.Discipline.Mute.currentEditing = name;
            end
        else
            GMGenie.Macros.Discipline.Mute.currentEditing = name;
            GMGenie_Macros_Discipline_OptionsWindow_Mute_Save:SetText("Save");
            GMGenie_Macros_Discipline_OptionsWindow_Mute_Delete:Enable();
        end
    end
    GMGenie.Macros.Discipline.Mute.addToUnitMenu();
end

function GMGenie.Macros.Discipline.Mute.delete()
    local name = GMGenie_Macros_Discipline_OptionsWindow_Mute_Name:GetText();

    if name and name ~= "" then
        GMGenie_SavedVars.mute[name] = nil;
        GMGenie.Macros.Discipline.Mute.cleanForm();
    end
    GMGenie.Macros.Discipline.Mute.addToUnitMenu();
end

function GMGenie.Macros.Discipline.Mute.cleanForm()
    GMGenie.Macros.Discipline.Mute.currentEditing = nil;
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Name:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Duration:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Reason:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_Mute_AnnounceToServer:SetChecked(false);
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Save:SetText("Add");
    GMGenie_Macros_Discipline_OptionsWindow_Mute_Delete:Disable();
end


--CharBan
GMGenie.Macros.Discipline.CharBan.currentEditing = nil;

function GMGenie.Macros.Discipline.CharBan.loadOptionsDropdown()
    local CharBanTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.charBan);
    for _, name in pairs(CharBanTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = GMGenie.Macros.Discipline.CharBan.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function GMGenie.Macros.Discipline.CharBan.edit(self)
    GMGenie.Macros.Discipline.CharBan.currentEditing = self.value;
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Name:SetText(self.value);
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Duration:SetText(GMGenie_SavedVars.charBan[self.value]["duration"]);
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Reason:SetText(GMGenie_SavedVars.charBan[self.value]["reason"]);
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_AnnounceToServer:SetChecked(GMGenie_SavedVars.charBan[self.value]["announceToServer"]);
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Save:SetText("Save");
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Delete:Enable();
end

function GMGenie.Macros.Discipline.CharBan.save()
    local name = GMGenie_Macros_Discipline_OptionsWindow_CharBan_Name:GetText();
    local duration = GMGenie_Macros_Discipline_OptionsWindow_CharBan_Duration:GetText();
    local reason = GMGenie_Macros_Discipline_OptionsWindow_CharBan_Reason:GetText();
    local announceToServer = GMGenie_Macros_Discipline_OptionsWindow_CharBan_AnnounceToServer:GetChecked();

    if name and duration and reason then
        GMGenie_SavedVars.charBan[name] = { duration = duration, reason = reason, announceToServer = announceToServer };

        if GMGenie.Macros.Discipline.CharBan.currentEditing then
            if (name ~= GMGenie.Macros.Discipline.CharBan.currentEditing) then
                GMGenie_SavedVars.charBan[GMGenie.Macros.Discipline.CharBan.currentEditing] = nil;
                GMGenie.Macros.Discipline.CharBan.currentEditing = name;
            end
        else
            GMGenie.Macros.Discipline.CharBan.currentEditing = name;
            GMGenie_Macros_Discipline_OptionsWindow_CharBan_Save:SetText("Save");
            GMGenie_Macros_Discipline_OptionsWindow_CharBan_Delete:Enable();
        end
    end
    GMGenie.Macros.Discipline.CharBan.addToUnitMenu();
end

function GMGenie.Macros.Discipline.CharBan.delete()
    local name = GMGenie_Macros_Discipline_OptionsWindow_CharBan_Name:GetText();

    if name and name ~= "" then
        GMGenie_SavedVars.charBan[name] = nil;
        GMGenie.Macros.Discipline.CharBan.cleanForm();
    end
    GMGenie.Macros.Discipline.CharBan.addToUnitMenu();
end

function GMGenie.Macros.Discipline.CharBan.cleanForm()
    GMGenie.Macros.Discipline.CharBan.currentEditing = nil;
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Name:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Duration:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Reason:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_AnnounceToServer:SetChecked(false);
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Save:SetText("Add");
    GMGenie_Macros_Discipline_OptionsWindow_CharBan_Delete:Disable();
end


--AccBan
GMGenie.Macros.Discipline.AccBan.currentEditing = nil;

function GMGenie.Macros.Discipline.AccBan.loadOptionsDropdown()
    local AccBanTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.accBan);
    for _, name in pairs(AccBanTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = GMGenie.Macros.Discipline.AccBan.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function GMGenie.Macros.Discipline.AccBan.edit(self)
    GMGenie.Macros.Discipline.AccBan.currentEditing = self.value;
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Name:SetText(self.value);
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Duration:SetText(GMGenie_SavedVars.accBan[self.value]["duration"]);
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Reason:SetText(GMGenie_SavedVars.accBan[self.value]["reason"]);
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_AnnounceToServer:SetChecked(GMGenie_SavedVars.accBan[self.value]["announceToServer"]);
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Save:SetText("Save");
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Delete:Enable();
end

function GMGenie.Macros.Discipline.AccBan.save()
    local name = GMGenie_Macros_Discipline_OptionsWindow_AccBan_Name:GetText();
    local duration = GMGenie_Macros_Discipline_OptionsWindow_AccBan_Duration:GetText();
    local reason = GMGenie_Macros_Discipline_OptionsWindow_AccBan_Reason:GetText();
    local announceToServer = GMGenie_Macros_Discipline_OptionsWindow_AccBan_AnnounceToServer:GetChecked();

    if name and duration and reason then
        GMGenie_SavedVars.accBan[name] = { duration = duration, reason = reason, announceToServer = announceToServer };

        if GMGenie.Macros.Discipline.AccBan.currentEditing then
            if (name ~= GMGenie.Macros.Discipline.AccBan.currentEditing) then
                GMGenie_SavedVars.accBan[GMGenie.Macros.Discipline.AccBan.currentEditing] = nil;
                GMGenie.Macros.Discipline.AccBan.currentEditing = name;
            end
        else
            GMGenie.Macros.Discipline.AccBan.currentEditing = name;
            GMGenie_Macros_Discipline_OptionsWindow_AccBan_Save:SetText("Save");
            GMGenie_Macros_Discipline_OptionsWindow_AccBan_Delete:Enable();
        end
    end
    GMGenie.Macros.Discipline.AccBan.addToUnitMenu();
end

function GMGenie.Macros.Discipline.AccBan.delete()
    local name = GMGenie_Macros_Discipline_OptionsWindow_AccBan_Name:GetText();

    if name and name ~= "" then
        GMGenie_SavedVars.accBan[name] = nil;
        GMGenie.Macros.Discipline.AccBan.cleanForm();
    end
    GMGenie.Macros.Discipline.AccBan.addToUnitMenu();
end

function GMGenie.Macros.Discipline.AccBan.cleanForm()
    GMGenie.Macros.Discipline.AccBan.currentEditing = nil;
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Name:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Duration:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Reason:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_AnnounceToServer:SetChecked(false);
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Save:SetText("Add");
    GMGenie_Macros_Discipline_OptionsWindow_AccBan_Delete:Disable();
end


--IpBan
GMGenie.Macros.Discipline.IpBan.currentEditing = nil;

function GMGenie.Macros.Discipline.IpBan.loadOptionsDropdown()
    local IpBanTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.ipBan);
    for _, name in pairs(IpBanTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = GMGenie.Macros.Discipline.IpBan.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function GMGenie.Macros.Discipline.IpBan.edit(self)
    GMGenie.Macros.Discipline.IpBan.currentEditing = self.value;
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Name:SetText(self.value);
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Duration:SetText(GMGenie_SavedVars.ipBan[self.value]["duration"]);
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Reason:SetText(GMGenie_SavedVars.ipBan[self.value]["reason"]);
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_AnnounceToServer:SetChecked(GMGenie_SavedVars.ipBan[self.value]["announceToServer"]);
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Save:SetText("Save");
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Delete:Enable();
end

function GMGenie.Macros.Discipline.IpBan.save()
    local name = GMGenie_Macros_Discipline_OptionsWindow_IpBan_Name:GetText();
    local duration = GMGenie_Macros_Discipline_OptionsWindow_IpBan_Duration:GetText();
    local reason = GMGenie_Macros_Discipline_OptionsWindow_IpBan_Reason:GetText();
    local announceToServer = GMGenie_Macros_Discipline_OptionsWindow_IpBan_AnnounceToServer:GetChecked();

    if name and duration and reason then
        GMGenie_SavedVars.ipBan[name] = { duration = duration, reason = reason, announceToServer = announceToServer };

        if GMGenie.Macros.Discipline.IpBan.currentEditing then
            if (name ~= GMGenie.Macros.Discipline.IpBan.currentEditing) then
                GMGenie_SavedVars.ipBan[GMGenie.Macros.Discipline.IpBan.currentEditing] = nil;
                GMGenie.Macros.Discipline.IpBan.currentEditing = name;
            end
        else
            GMGenie.Macros.Discipline.IpBan.currentEditing = name;
            GMGenie_Macros_Discipline_OptionsWindow_IpBan_Save:SetText("Save");
            GMGenie_Macros_Discipline_OptionsWindow_IpBan_Delete:Enable();
        end
    end
    GMGenie.Macros.Discipline.IpBan.addToUnitMenu();
end

function GMGenie.Macros.Discipline.IpBan.delete()
    local name = GMGenie_Macros_Discipline_OptionsWindow_IpBan_Name:GetText();

    if name and name ~= "" then
        GMGenie_SavedVars.ipBan[name] = nil;
        GMGenie.Macros.Discipline.IpBan.cleanForm();
    end
    GMGenie.Macros.Discipline.IpBan.addToUnitMenu();
end

function GMGenie.Macros.Discipline.IpBan.cleanForm()
    GMGenie.Macros.Discipline.IpBan.currentEditing = nil;
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Name:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Duration:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Reason:SetText("");
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_AnnounceToServer:SetChecked(false);
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Save:SetText("Add");
    GMGenie_Macros_Discipline_OptionsWindow_IpBan_Delete:Disable();
end
