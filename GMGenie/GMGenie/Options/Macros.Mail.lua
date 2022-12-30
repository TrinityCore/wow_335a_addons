--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function GMGenie.Macros.Mail.optionsOnLoad()
    local panel = getglobal("GMGenie_Macros_Mail_OptionsWindow");
    panel.name = "Mail Macros";
    panel.parent = "GM Genie";

    InterfaceOptions_AddCategory(panel);

    getglobal(panel:GetName() .. "_Title"):SetText("Mail Macros");
    getglobal(panel:GetName() .. "_SubText"):SetText("Here you add and update mail macros, which will be available from the ticket interface and the player context menus.");
    GMGenie_Macros_Mail_OptionsWindow_Info_Text:SetText("Note: every newline in the mail macro will be a separate mail. It is not possible to have newlines within one mail.\nNote: If the text in the box turns red that means one of the lines (messages) has become too long and might get cut off when sending a mail.\n\nTip: use NAME (in full caps) to use the players' name in the mail text.");

    getglobal("GMGenie_Macros_Mail_OptionsWindow_Macro_Frame_Text"):SetScript("OnTextChanged", GMGenie.Macros.Mail.updateMacroText);

    UIDropDownMenu_Initialize(getglobal("GMGenie_Macros_Mail_OptionsWindow_Dropdownbuttons"), GMGenie.Macros.Mail.loadOptionsDropdown, "MENU");
end

function GMGenie.Macros.Mail.updateMacroText()
    ScrollingEdit_OnTextChanged(getglobal("GMGenie_Macros_Mail_OptionsWindow_Macro_Frame_Text"), getglobal("GMGenie_Macros_Mail_OptionsWindow_Macro_Frame"));
    GMGenie.Macros.Mail.checkMacroLength();
end

function GMGenie.Macros.Mail.checkMacroLength()
    local macro = GMGenie_Macros_Mail_OptionsWindow_Macro_Frame_Text:GetText();
    local macro = string.gsub(macro, "NAME", "abcdefghijkl");
    local lines = { strsplit("\n", macro) };

    local maxlength = 226 - string.len(GMGenie_Macros_Mail_OptionsWindow_Subject:GetText());
    if #lines > 1 then
        maxlength = maxlength - 4;
    end
    for _, line in pairs(lines) do
        if string.len(line) > maxlength then
            GMGenie_Macros_Mail_OptionsWindow_Macro_Frame_Text:SetTextColor(255, 0, 0);
        else
            GMGenie_Macros_Mail_OptionsWindow_Macro_Frame_Text:SetTextColor(255, 255, 255);
        end
    end
end

GMGenie.Macros.Mail.currentEditing = nil;

function GMGenie.Macros.Mail.loadOptionsDropdown()
    local MailTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.mail);
    for _, name in pairs(MailTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = GMGenie.Macros.Mail.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function GMGenie.Macros.Mail.test()
    if GMGenie.Macros.Mail.currentEditing then
        GMGenie.Macros.Mail.run(UnitName("player"), GMGenie.Macros.Mail.currentEditing);
    end
end

function GMGenie.Macros.Mail.edit(self)
    GMGenie.Macros.Mail.currentEditing = self.value;
    GMGenie_Macros_Mail_OptionsWindow_Name:SetText(self.value);
    GMGenie_Macros_Mail_OptionsWindow_Subject:SetText(GMGenie_SavedVars.mail[self.value]["subject"]);
    GMGenie_Macros_Mail_OptionsWindow_Macro_Frame_Text:SetText(GMGenie_SavedVars.mail[self.value]["macro"]);
    GMGenie_Macros_Mail_OptionsWindow_Save:SetText("Save");
    GMGenie_Macros_Mail_OptionsWindow_Delete:Enable();
end

function GMGenie.Macros.Mail.save()
    local name = GMGenie_Macros_Mail_OptionsWindow_Name:GetText();
    local subject = GMGenie_Macros_Mail_OptionsWindow_Subject:GetText();
    local macro = GMGenie_Macros_Mail_OptionsWindow_Macro_Frame_Text:GetText();

    if name and macro and subject and name ~= "" then
        GMGenie_SavedVars.mail[name] = { macro = macro, subject = subject };

        if GMGenie.Macros.Mail.currentEditing then
            if (name ~= GMGenie.Macros.Mail.currentEditing) then
                GMGenie_SavedVars.mail[GMGenie.Macros.Mail.currentEditing] = nil;
                GMGenie.Macros.Mail.currentEditing = name;
            end
        else
            GMGenie.Macros.Mail.currentEditing = name;
            GMGenie_Macros_Mail_OptionsWindow_Save:SetText("Save");
            GMGenie_Macros_Mail_OptionsWindow_Delete:Enable();
        end
    end
    GMGenie.Macros.Mail.addToUnitMenu();
end

function GMGenie.Macros.Mail.delete()
    local name = GMGenie_Macros_Mail_OptionsWindow_Name:GetText();

    if name and name ~= "" then
        GMGenie_SavedVars.mail[name] = nil;
        GMGenie.Macros.Mail.cleanForm();
    end
    GMGenie.Macros.Mail.addToUnitMenu();
end

function GMGenie.Macros.Mail.cleanForm()
    GMGenie.Macros.Mail.currentEditing = nil;
    GMGenie_Macros_Mail_OptionsWindow_Name:SetText("");
    GMGenie_Macros_Mail_OptionsWindow_Subject:SetText("");
    GMGenie_Macros_Mail_OptionsWindow_Macro_Frame_Text:SetText("");
    GMGenie_Macros_Mail_OptionsWindow_Save:SetText("Add");
    GMGenie_Macros_Mail_OptionsWindow_Delete:Disable();
end

function GMGenie.Macros.Mail.showOptions()
    InterfaceOptionsFrame_OpenToCategory("Mail Macros");
end
