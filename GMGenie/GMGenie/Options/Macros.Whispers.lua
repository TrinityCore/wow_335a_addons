--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function GMGenie.Macros.Whispers.optionsOnLoad()
    local panel = getglobal("GMGenie_Macros_Whispers_OptionsWindow");
    panel.name = "Whisper Macros";
    panel.parent = "GM Genie";

    InterfaceOptions_AddCategory(panel);

    getglobal(panel:GetName() .. "_Title"):SetText("Whisper Macros");
    getglobal(panel:GetName() .. "_SubText"):SetText("Here you add and update whisper macros, which will be available from the ticket interface and the player context menus.");
    GMGenie_Macros_Whispers_OptionsWindow_Info_Text:SetText("Note: every newline in the whisper macro will be a separate whisper. It is not possible to have newlines within one whisper.\nNote: If the text in the box turns red that means one of the lines (messages) has become too long and might get cut off when sending a whisper.\n\nTip: use NAME (in full caps) to use the players' name in the whisper text. Use SUBJECT (also in full caps), to get a pop up box where you can enter a subject for the message. SUBJECT in your macro will be replaced by this.");

    getglobal("GMGenie_Macros_Whispers_OptionsWindow_Macro_Frame_Text"):SetScript("OnTextChanged", GMGenie.Macros.Whispers.updateMacroText);

    UIDropDownMenu_Initialize(getglobal("GMGenie_Macros_Whispers_OptionsWindow_Dropdownbuttons"), GMGenie.Macros.Whispers.loadOptionsDropdown, "MENU");
end

function GMGenie.Macros.Whispers.updateMacroText()
    ScrollingEdit_OnTextChanged(getglobal("GMGenie_Macros_Whispers_OptionsWindow_Macro_Frame_Text"), getglobal("GMGenie_Macros_Whispers_OptionsWindow_Macro_Frame"));
    GMGenie.Macros.Whispers.checkMacroLength();
end

function GMGenie.Macros.Whispers.checkMacroLength()
    local macro = GMGenie_Macros_Whispers_OptionsWindow_Macro_Frame_Text:GetText();
    local macro = string.gsub(macro, "NAME", "abcdefghijkl");
    local lines = { strsplit("\n", macro) };

    for _, line in pairs(lines) do
        if string.len(line) > 255 then
            GMGenie_Macros_Whispers_OptionsWindow_Macro_Frame_Text:SetTextColor(255, 0, 0);
        else
            GMGenie_Macros_Whispers_OptionsWindow_Macro_Frame_Text:SetTextColor(255, 255, 255);
        end
    end
end


GMGenie.Macros.Whispers.currentEditing = nil;

function GMGenie.Macros.Whispers.loadOptionsDropdown()
    local whispersTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.whispers);
    for _, name in pairs(whispersTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = GMGenie.Macros.Whispers.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function GMGenie.Macros.Whispers.edit(self)
    GMGenie.Macros.Whispers.currentEditing = self.value;
    GMGenie_Macros_Whispers_OptionsWindow_Name:SetText(self.value);
    GMGenie_Macros_Whispers_OptionsWindow_Macro_Frame_Text:SetText(GMGenie_SavedVars.whispers[self.value]);
    GMGenie_Macros_Whispers_OptionsWindow_Save:SetText("Save");
    GMGenie_Macros_Whispers_OptionsWindow_Delete:Enable();
end

function GMGenie.Macros.Whispers.save()
    local name = GMGenie_Macros_Whispers_OptionsWindow_Name:GetText();
    local macro = GMGenie_Macros_Whispers_OptionsWindow_Macro_Frame_Text:GetText();

    if name and macro and name ~= "" then
        GMGenie_SavedVars.whispers[name] = macro;

        if GMGenie.Macros.Whispers.currentEditing then
            if (name ~= GMGenie.Macros.Whispers.currentEditing) then
                GMGenie_SavedVars.whispers[GMGenie.Macros.Whispers.currentEditing] = nil;
                GMGenie.Macros.Whispers.currentEditing = name;
            end
        else
            GMGenie.Macros.Whispers.currentEditing = name;
            GMGenie_Macros_Whispers_OptionsWindow_Save:SetText("Save");
            GMGenie_Macros_Whispers_OptionsWindow_Delete:Enable();
        end
    end
    GMGenie.Macros.Whispers.addToUnitMenu();
end

function GMGenie.Macros.Whispers.delete()
    local name = GMGenie_Macros_Whispers_OptionsWindow_Name:GetText();

    if name and name ~= "" then
        GMGenie_SavedVars.whispers[name] = nil;
        GMGenie.Macros.Whispers.cleanForm();
    end
    GMGenie.Macros.Whispers.addToUnitMenu();
end

function GMGenie.Macros.Whispers.cleanForm()
    GMGenie.Macros.Whispers.currentEditing = nil;
    GMGenie_Macros_Whispers_OptionsWindow_Name:SetText("");
    GMGenie_Macros_Whispers_OptionsWindow_Macro_Frame_Text:SetText("");
    GMGenie_Macros_Whispers_OptionsWindow_Save:SetText("Add");
    GMGenie_Macros_Whispers_OptionsWindow_Delete:Disable();
end

function GMGenie.Macros.Whispers.showOptions()
    InterfaceOptionsFrame_OpenToCategory("Whisper Macros");
end

function GMGenie.Macros.Whispers.test()
    if GMGenie.Macros.Whispers.currentEditing then
        GMGenie.Macros.Whispers.run(UnitName("player"), GMGenie.Macros.Whispers.currentEditing);
    end
end
