--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function GMGenie.Spawns.optionsOnLoad()
    local panel = getglobal("GMGenie_Spawns_OptionsWindow");
    panel.name = "Builder";
    panel.parent = "GM Genie";

    InterfaceOptions_AddCategory(panel);

    getglobal(panel:GetName() .. "_Title"):SetText("Builder Presets");
    getglobal(panel:GetName() .. "_SubText"):SetText("Here you add and update preset NPCs and objects, which will be available from the builder interface.");

    UIDropDownMenu_Initialize(getglobal("GMGenie_Spawns_OptionsWindow_Objects_Dropdownbuttons"), GMGenie.Spawns.Objects.loadOptionsDropdown, "MENU");
    UIDropDownMenu_Initialize(getglobal("GMGenie_Spawns_OptionsWindow_Npcs_Dropdownbuttons"), GMGenie.Spawns.Npcs.loadOptionsDropdown, "MENU");
end

function GMGenie.Spawns.showOptions()
    InterfaceOptionsFrame_OpenToCategory("Builder");
end

GMGenie.Spawns.Objects = {};

function GMGenie.Spawns.Objects.loadOptionsDropdown()
    local objectsTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.objects);
    for _, name in pairs(objectsTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = GMGenie.Spawns.Objects.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function GMGenie.Spawns.Objects.edit(self)
    GMGenie.Spawns.Objects.currentEditing = self.value;
    GMGenie_Spawns_OptionsWindow_Objects_Id:SetText(GMGenie_SavedVars.objects[self.value]);
    GMGenie_Spawns_OptionsWindow_Objects_Name:SetText(self.value);
    GMGenie_Spawns_OptionsWindow_Objects_Save:SetText("Save");
    GMGenie_Spawns_OptionsWindow_Objects_Delete:Enable();
end

function GMGenie.Spawns.Objects.save()
    local id = GMGenie_Spawns_OptionsWindow_Objects_Id:GetText();
    local name = GMGenie_Spawns_OptionsWindow_Objects_Name:GetText();

    if id and name then
        GMGenie_SavedVars.objects[name] = id;

        if GMGenie.Spawns.Objects.currentEditing then
            if (id ~= GMGenie.Spawns.Objects.currentEditing) then
                GMGenie_SavedVars.objects[GMGenie.Spawns.Objects.currentEditing] = nil;
                GMGenie.Spawns.Objects.currentEditing = name;
            end
        else
            GMGenie.Spawns.Objects.currentEditing = name;
            GMGenie_Spawns_OptionsWindow_Objects_Save:SetText("Save");
            GMGenie_Spawns_OptionsWindow_Objects_Delete:Enable();
        end
    end
end

function GMGenie.Spawns.Objects.delete()
    local name = GMGenie_Spawns_OptionsWindow_Objects_Name:GetText();

    if name and name ~= "" then
        GMGenie_SavedVars.objects[name] = nil;
        GMGenie.Spawns.Objects.cleanForm();
    end
end

function GMGenie.Spawns.Objects.cleanForm()
    GMGenie.Spawns.Objects.currentEditing = nil;
    GMGenie_Spawns_OptionsWindow_Objects_Id:SetText("");
    GMGenie_Spawns_OptionsWindow_Objects_Name:SetText("");
    GMGenie_Spawns_OptionsWindow_Objects_Save:SetText("Add");
    GMGenie_Spawns_OptionsWindow_Objects_Delete:Disable();
end

GMGenie.Spawns.Npcs = {};

function GMGenie.Spawns.Npcs.loadOptionsDropdown()
    local npcsTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.npcs);
    for _, name in pairs(npcsTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = GMGenie.Spawns.Npcs.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function GMGenie.Spawns.Npcs.edit(self)
    GMGenie.Spawns.Npcs.currentEditing = self.value;
    GMGenie_Spawns_OptionsWindow_Npcs_Id:SetText(GMGenie_SavedVars.npcs[self.value]);
    GMGenie_Spawns_OptionsWindow_Npcs_Name:SetText(self.value);
    GMGenie_Spawns_OptionsWindow_Npcs_Save:SetText("Save");
    GMGenie_Spawns_OptionsWindow_Npcs_Delete:Enable();
end

function GMGenie.Spawns.Npcs.save()
    local id = GMGenie_Spawns_OptionsWindow_Npcs_Id:GetText();
    local name = GMGenie_Spawns_OptionsWindow_Npcs_Name:GetText();

    if id and name then
        GMGenie_SavedVars.npcs[name] = id;

        if GMGenie.Spawns.Npcs.currentEditing then
            if (id ~= GMGenie.Spawns.Npcs.currentEditing) then
                GMGenie_SavedVars.npcs[GMGenie.Spawns.Npcs.currentEditing] = nil;
                GMGenie.Spawns.Npcs.currentEditing = name;
            end
        else
            GMGenie.Spawns.Npcs.currentEditing = name;
            GMGenie_Spawns_OptionsWindow_Npcs_Save:SetText("Save");
            GMGenie_Spawns_OptionsWindow_Npcs_Delete:Enable();
        end
    end
end

function GMGenie.Spawns.Npcs.delete()
    local name = GMGenie_Spawns_OptionsWindow_Npcs_Name:GetText();

    if name and name ~= "" then
        GMGenie_SavedVars.npcs[name] = nil;
        GMGenie.Spawns.Npcs.cleanForm();
    end
end

function GMGenie.Spawns.Npcs.cleanForm()
    GMGenie.Spawns.Npcs.currentEditing = nil;
    GMGenie_Spawns_OptionsWindow_Npcs_Id:SetText("");
    GMGenie_Spawns_OptionsWindow_Npcs_Name:SetText("");
    GMGenie_Spawns_OptionsWindow_Npcs_Save:SetText("Add");
    GMGenie_Spawns_OptionsWindow_Npcs_Delete:Disable();
end
