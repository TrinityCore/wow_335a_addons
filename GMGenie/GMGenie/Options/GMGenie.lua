--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

-- ADD TicketTab = "General";

function GMGenie.optionsOkay()
    GMGenie_SavedVars.GMSyncChannel = GMGenie_OptionsWindow_GMSyncChannel:GetText();
    if (GMGenie_OptionsWindow_EnableWIMIntergration:GetChecked()) then GMGenie_SavedVars.WIMIntegration = true; else GMGenie_SavedVars.WIMIntegration = false; end
end

function GMGenie.optionsDefault()
    GMGenie.setDefault({ "WIMIntegration", "GMSyncChannel" });
    GMGenie.Tickets.optionsUpdate();
end

function GMGenie.optionsOnLoad()
    local panel = getglobal("GMGenie_OptionsWindow");
    panel.name = "GM Genie";
    panel.parent = nil;
    panel.okay = GMGenie.optionsOkay;
    panel.cancel = GMGenie.optionsUpdate;
    panel.default = GMGenie.optionsDefault;

    InterfaceOptions_AddCategory(panel);

    getglobal("GMGenie_OptionsWindow_Title"):SetText("Game Master Genie");
    getglobal("GMGenie_OptionsWindow_SubText"):SetText("Here you can change the settings for GM Genie.");

    GMGenie.optionsUpdate();
end

function GMGenie.optionsUpdate()
    GMGenie_OptionsWindow_GMSyncChannel:SetText(GMGenie_SavedVars.GMSyncChannel);
    GMGenie_OptionsWindow_EnableWIMIntergration:SetChecked(GMGenie_SavedVars.WIMIntegration);
end

function GMGenie.showOptions()
    InterfaceOptionsFrame_OpenToCategory("GM Genie");
end