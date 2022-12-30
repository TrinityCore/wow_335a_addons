--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie.defaultSettings = {
    ["GMSyncChannel"] = "GM_Sync_Channel",
    ["whispers"] = {},
    ["mail"] = {},
    ["tele"] = {},
    ['objects'] = {},
    ['npcs'] = {},
    ['mute'] = {},
    ['charBan'] = {},
    ['accBan'] = {},
    ['ipBan'] = {},
    ["WIMIntegration"] = false,
    ["useSpy"] = true,
    ["swapTicketWindows"] = false,
    ["showOfflineTickets"] = false,
    ["minimapPos"] = 45,
    ['hudClosed'] = false,
    ['ticketsDone'] = 0,
}

function GMGenie.loadSettings()
    for name, value in pairs(GMGenie.defaultSettings) do
        if not GMGenie_SavedVars[name] then
            GMGenie_SavedVars[name] = value;
        end
    end
end

function GMGenie.setDefault(names)
    for _, name in ipairs(names) do
        GMGenie_SavedVars[name] = GMGenie.defaultSettings[name];
    end
end
