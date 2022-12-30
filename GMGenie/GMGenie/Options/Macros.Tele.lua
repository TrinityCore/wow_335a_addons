--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function GMGenie.Macros.Tele.optionsOnLoad()
    local panel = getglobal("GMGenie_Macros_Tele_OptionsWindow");
    panel.name = "Teleport Macros";
    panel.parent = "GM Genie";

    InterfaceOptions_AddCategory(panel);

    getglobal(panel:GetName() .. "_Title"):SetText("Teleport Macros");
    getglobal(panel:GetName() .. "_SubText"):SetText("Here you add and update teleport macros, which will be available from the ticket interface and the player context menus.");

    GMGenie_Macros_Tele_OptionsWindow_Info_Text:SetText("Tip: use RECALL (in full caps) as the location to return a player to wherever they were before they were teleported or summoned by a GM.");

    UIDropDownMenu_Initialize(getglobal("GMGenie_Macros_Tele_OptionsWindow_Dropdownbuttons"), GMGenie.Macros.Tele.loadOptionsDropdown, "MENU");
end

GMGenie.Macros.Tele.currentEditing = nil;

function GMGenie.Macros.Tele.loadOptionsDropdown()
    local TeleTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.tele);
    for _, name in pairs(TeleTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = GMGenie.Macros.Tele.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function GMGenie.Macros.Tele.test()
    if GMGenie.Macros.Tele.currentEditing then
        GMGenie.Macros.Tele.run(UnitName("player"), GMGenie.Macros.Tele.currentEditing);
    end
end

function GMGenie.Macros.Tele.edit(self)
    GMGenie.Macros.Tele.currentEditing = self.value;
    GMGenie_Macros_Tele_OptionsWindow_Name:SetText(self.value);
    GMGenie_Macros_Tele_OptionsWindow_Location:SetText(GMGenie_SavedVars.tele[self.value]);
    GMGenie_Macros_Tele_OptionsWindow_Save:SetText("Save");
    GMGenie_Macros_Tele_OptionsWindow_Delete:Enable();
end

function GMGenie.Macros.Tele.save()
    local name = GMGenie_Macros_Tele_OptionsWindow_Name:GetText();
    local location = GMGenie_Macros_Tele_OptionsWindow_Location:GetText();

    if name and location then
        GMGenie_SavedVars.tele[name] = location;

        if GMGenie.Macros.Tele.currentEditing then
            if (name ~= GMGenie.Macros.Tele.currentEditing) then
                GMGenie_SavedVars.tele[GMGenie.Macros.Tele.currentEditing] = nil;
                GMGenie.Macros.Tele.currentEditing = name;
            end
        else
            GMGenie.Macros.Tele.currentEditing = name;
            GMGenie_Macros_Tele_OptionsWindow_Save:SetText("Save");
            GMGenie_Macros_Tele_OptionsWindow_Delete:Enable();
        end
    end
    GMGenie.Macros.Tele.addToUnitMenu();
end

function GMGenie.Macros.Tele.delete()
    local name = GMGenie_Macros_Tele_OptionsWindow_Name:GetText();

    if name and name ~= "" then
        GMGenie_SavedVars.tele[name] = nil;
        GMGenie.Macros.Tele.cleanForm();
    end
    GMGenie.Macros.Tele.addToUnitMenu();
end

function GMGenie.Macros.Tele.cleanForm()
    GMGenie.Macros.Tele.currentEditing = nil;
    GMGenie_Macros_Tele_OptionsWindow_Name:SetText("");
    GMGenie_Macros_Tele_OptionsWindow_Location:SetText("");
    GMGenie_Macros_Tele_OptionsWindow_Save:SetText("Add");
    GMGenie_Macros_Tele_OptionsWindow_Delete:Disable();
end

function GMGenie.Macros.Tele.showOptions()
    InterfaceOptionsFrame_OpenToCategory("Teleport Macros");
end
