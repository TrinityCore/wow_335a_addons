--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie = {};
GMGenie_SavedVars = {};

function GMGenie.showGMMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[GMGenie]|cffffffff: " .. msg);
end

function GMGenie.pairsByKeys(t, f)
    local a = {}
    local b = {}
    for n in pairs(t) do
        table.insert(a, n);
    end
    table.sort(a, f);
    for _, value in pairs(a) do
        table.insert(b, t[value]);
    end
    return b;
end

function GMGenie.pairsByKeys2(t, f)
    local a = {}
    local b = {}
    for n in pairs(t) do
        table.insert(a, n);
    end
    table.sort(a, f);
    for _, value in pairs(a) do
        table.insert(b, value);
    end
    return b;
end

function GMGenie.onLoad()
    GMGenie.loadSettings();

    GMGenie.Hud.onLoad();

    GMGenie.Macros.onLoad();
    GMGenie.Spawns.onLoad();

    UIDropDownMenu_Initialize(GMGenie_Spy_InfoWindow_DropdownbuttonsTwo, GMGenie.Spy.loadDropdown, "MENU");

    GMGenie.optionsOnLoad();
    GMGenie.Tickets.optionsOnLoad();
    GMGenie.Macros.Whispers.optionsOnLoad();
    GMGenie.Macros.Mail.optionsOnLoad();
    GMGenie.Macros.Tele.optionsOnLoad();
    GMGenie.Macros.Discipline.optionsOnLoad()
    GMGenie.Spawns.optionsOnLoad();

    GMGenie.minimap.reposition();
    GMGenie.Tickets.onLoad();

    -- Please do not remove the copyright notice, it would be a violation of the gpl.
    GMGenie.showGMMessage("GMGenie 0.7.3 by Chocochaos ((c) 2011-2014). The latest version of GM Genie can always be found at http://chocochaos.com/gmgenie/");
end

local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");

function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "GMGenie" then
        GMGenie.onLoad();
    end
end

frame:SetScript("OnEvent", frame.OnEvent);

GMGenie.minimap = {};

-- add this to your SavedVariables or as a separate SavedVariable to store its position


-- Call this in a mod's initialization to move the minimap button to its saved position (also used in its movement)
-- ** do not call from the mod's OnLoad, VARIABLES_LOADED or later is fine. **
function GMGenie.minimap.reposition()
    GMGenie_Minimap:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(GMGenie_SavedVars.minimapPos)), (80 * sin(GMGenie_SavedVars.minimapPos)) - 52)
end

-- Only while the button is dragged this is called every frame
function GMGenie.minimap.draggingFrame_OnUpdate()
    local xpos, ypos = GetCursorPosition()
    local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin - xpos / UIParent:GetScale() + 70 -- get coordinates as differences from the center of the minimap
    ypos = ypos / UIParent:GetScale() - ymin - 70

    GMGenie_SavedVars.minimapPos = math.deg(math.atan2(ypos, xpos)) -- save the degrees we are relative to the minimap center
    GMGenie.minimap.reposition() -- move the button
end

function GMGenie.loadWindow(window, title, refresh, refreshScript)
    local name = window:GetName();
    window:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    getglobal(name .. "_Title_Text"):SetText(title);
    if refresh then
        getglobal(name .. '_Refresh'):Show();
        getglobal(name .. '_Title'):SetWidth(window:GetWidth() - 32);
        if refreshScript then
            getglobal(name .. '_Refresh'):SetScript("OnClick", refreshScript);
        end
    else
        getglobal(name .. '_Refresh'):Hide();
        getglobal(name .. '_Title'):SetWidth(window:GetWidth() - 16);
    end

    getglobal(name .. '_Main'):SetWidth(window:GetWidth());
    getglobal(name .. '_Main'):SetHeight(window:GetHeight() - 14);
end

function GMGenie.loadEditBox(window)
    local name = window:GetName();

    getglobal(name .. '_Frame_Text'):SetTextInsets(5, 5, 5, 5);
    getglobal(name .. '_Frame'):SetWidth(window:GetWidth());
    getglobal(name .. '_Frame'):SetHeight(window:GetHeight());
    getglobal(name .. '_Frame_Text'):SetWidth(getglobal(name .. '_Frame'):GetWidth());
    getglobal(name .. '_Frame_Text'):SetHeight(getglobal(name .. '_Frame'):GetHeight());
end
