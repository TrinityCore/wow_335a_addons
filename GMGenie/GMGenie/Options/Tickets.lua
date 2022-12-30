--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

-- ADD TicketTab = "General";

function GMGenie.Tickets.optionsOkay()
    if (GMGenie_Tickets_OptionsWindow_swapWindows:GetChecked()) then GMGenie_SavedVars.swapTicketWindows = true; else GMGenie_SavedVars.swapTicketWindows = false; end
    if (GMGenie_Tickets_OptionsWindow_useSpy:GetChecked()) then GMGenie_SavedVars.useSpy = true; else GMGenie_SavedVars.useSpy = false; end
end

function GMGenie.Tickets.toggleOfflineTickets()
    if GMGenie_SavedVars.showOfflineTickets then
        GMGenie_SavedVars.showOfflineTickets = false;
    else
        GMGenie_SavedVars.showOfflineTickets = true;
    end
    GMGenie.Tickets.optionsUpdate();
    GMGenie.Tickets.refresh();
end

function GMGenie.Tickets.optionsDefault()
    GMGenie.setDefault({ "showOfflineTickets", "swapTicketWindows", "useSpy" });
    GMGenie.Tickets.optionsUpdate();
end

function GMGenie.Tickets.optionsOnLoad()
    local panel = getglobal("GMGenie_Tickets_OptionsWindow");
    panel.name = "Tickets";
    panel.parent = "GM Genie";
    panel.okay = GMGenie.Tickets.optionsOkay;
    panel.cancel = GMGenie.Tickets.optionsUpdate;
    panel.default = GMGenie.Tickets.optionsDefault;

    InterfaceOptions_AddCategory(panel);

    getglobal("GMGenie_Tickets_OptionsWindow_Title"):SetText("Tickets");
    getglobal("GMGenie_Tickets_OptionsWindow_SubText"):SetText("Here you can change the settings for the ticket tracker.");

    GMGenie.Tickets.optionsUpdate();
end

function GMGenie.Tickets.optionsUpdate()
    getglobal("GMGenie_Tickets_OptionsWindow_showOffline"):SetChecked(GMGenie_SavedVars.showOfflineTickets);
    getglobal("GMGenie_Tickets_OptionsWindow_swapWindows"):SetChecked(GMGenie_SavedVars.swapTicketWindows);
    getglobal("GMGenie_Tickets_OptionsWindow_useSpy"):SetChecked(GMGenie_SavedVars.useSpy);
end

function GMGenie.Tickets.ShowOptions()
    InterfaceOptionsFrame_OpenToCategory("Tickets");
end