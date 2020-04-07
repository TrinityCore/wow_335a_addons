HealOrganizer = LibStub("AceAddon-3.0"):NewAddon("HealOrganizer", "AceConsole-3.0", "AceEvent-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("HealOrganizer", true);

local HO_SLASH_COMMANDS = {
    type = 'group',
    args = {
        dialog = {
            type = 'execute',
            name = 'Show/Hide Dialog',
            desc = L["SHOW_DIALOG"],
            func = function() HealOrganizer:Dialog() end,
        },
		raid = {
			type = 'execute',
			name = 'Broadcast Raid',
			desc = L["BROADCAST_RAID"],
			func = function() HealOrganizer:BroadcastRaid() end,
		},
		chan = {
			type = 'execute',
			name = 'Broadcast Channel',
			desc = L["BROADCAST_CHAN"],
			func = function() HealOrganizer:BroadcastChan() end,
		},
        autosort = {
            type = 'toggle',
            name = 'Autosort',
            desc = L["AUTOSORT_DESC"],
            get = function() return HealOrganizer.db.char.autosort end,
            set = function() HealOrganizer.db.char.autosort = not HealOrganizer.db.char.autosort end,
        },
    }
};


-- units
-- healer["name"] = "Rest"
-- Werte: Rest, 1, 2, 3, 4, 5, 6, 7, 8, 9
local healer = {};
-- name2unitid

local unitids = {};
local position = {};
local overrideSort = false;
local lastAction = 
{
    name = {},
    position = {},
    group = {},
};

local healingAssignment = 
{
    Rest = {},
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
};

local stats = 
{
    DRUID = 0,
    PRIEST = 0,
    PALADIN = 0,
    SHAMAN = 0,
}

local current_set = L["SET_DEFAULT"]

local grouplabels = {
    Rest = "GROUP_LOCALE_REMAINS",
    [1] = "GROUP_LOCALE_1",
    [2] = "GROUP_LOCALE_2",
    [3] = "GROUP_LOCALE_3",
    [4] = "GROUP_LOCALE_4",
    [5] = "GROUP_LOCALE_5",
    [6] = "GROUP_LOCALE_6",
    [7] = "GROUP_LOCALE_7",
    [8] = "GROUP_LOCALE_8",
    [9] = "GROUP_LOCALE_9",
}

-- nil, DRUID, PRIEST, PALADIN, SHAMAN
local groupclasses = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
}

local change_id = 0

-- button level speichern
local level_of_button = -1;

-- saves the healer-setup of other templates
--[[
-- tempsetup[setname] = healer-array
--]]
local tempsetup = {}

-- key bindings
BINDING_HEADER_HEALORGANIZER = "Heal Organizer"
BINDING_NAME_SHOWHEALORGANIZER =  L["SHOW_DIALOG"]

--[[ Example
dbexample = {
    "Name" = {
        Name = "Name",
        Beschriftungen = {
            Rest = "Rest",
            [1] = "%MT1%",
            ...
            [8] = "%MT8%",
            [9] = "Dispellen",
        },
        Restaktion = "ffa",
        Klassengruppen = {
            [1] = {
                [1] = "PALADIN",
                [2] = "PALADIN",
                [3] = "PRIEST",
            },
            [2] = {},
            ...
            [9] = {
                [2] = "DRUID",
            },
        },        
    },
    "Name3" = {
        ...
    },
}
--]]



HealOrganizer.CONST = {}
HealOrganizer.CONST.NUM_GROUPS = 9
HealOrganizer.CONST.NUM_SLOTS = 4


function HealOrganizer:Debug( msg )
	--self:Print( msg);
end;

function HealOrganizer:OnInitialize() -- {{{
    -- Called when the addon is loaded
    LibStub("AceConfig-3.0"):RegisterOptionsTable("HealOrganizer", HO_SLASH_COMMANDS, {"healorganizer", "hlorg","ho"})
	self:Debug( "Init: " .. type(self.db) );    
	
	self.db = LibStub("AceDB-3.0"):New("HealOrganizerDB", HO_DB_DEFAULTS );
    
    self:Debug( "Init: " .. type(self.db) );    
    
    self:RegisterEvent("CHAT_MSG_WHISPER");
    
    
    StaticPopupDialogs["HEALORGANIZER_EDITLABEL"] =
    { --{{{
        text = L["EDIT_LABEL"],
        button1 = TEXT(SAVE),
        button2 = TEXT(CANCEL),
        OnAccept = function(a,b,c)
            -- button gedrueckt, auf GetName/GetParent achten
            self:Debug("accept gedrueckt")
            self:Debug("ID ist "..change_id)
            self:SaveNewLabel(change_id, getglobal(self:GetParent():GetName().."EditBox"):GetText())
        end,
        OnHide = function()
            getglobal(self:GetName().."EditBox"):SetText("")
        end,
        OnShow = function()
            if grouplabels[change_id] ~= nil then
                getglobal(self:GetName().."EditBox"):SetText(grouplabels[change_id])
            end
        end,
	EditBoxOnEnterPressed = function()
            self:SaveNewLabel(change_id, self:GetText())
            self:GetParent():Hide()
        end,
        EditBoxOnEscapePressed = function()
            self:GetParent():Hide();
        end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1,
        hasEditBox = 1,
    }; --}}}
    
    StaticPopupDialogs["HEALORGANIZER_SETSAVEAS"] = 
    { --{{{
        text = L["SET_SAVEAS"],
        button1 = TEXT(SAVE),
        button2 = TEXT(CANCEL),
        OnAccept = function()
            -- button gedrueckt, auf GetName/GetParent achten
            self:SetSaveAs(getglobal(self:GetParent():GetName().."EditBox"):GetText())
        end,
        OnHide = function()
            getglobal(self:GetName().."EditBox"):SetText("")
        end,
        OnShow = function()
        end,
	    EditBoxOnEnterPressed = function()
            self:SetSaveAs(getglobal(self:GetParent():GetName().."EditBox"):GetText())
            self:GetParent():Hide()
        end,
        EditBoxOnEscapePressed = function()
            self:GetParent():Hide();
        end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1,
        hasEditBox = 1,
    }; --}}}
    
    
    current_set = L["SET_DEFAULT"]

    self:Debug("start localization")

    self:Debug( "1" .. type( HealOrganizerDialog ) );
    self:Debug( "2" .. type( HealOrganizerDialogEinteilung ) );
    self:Debug( "2" .. type( HealOrganizerDialogEinteilungTitle ) );
    HealOrganizerDialogEinteilungTitle:SetText(L["ARRANGEMENT"])
self:Debug( "d4" );
    for i=1, 20 do
        getglobal("HealOrganizerDialogEinteilungHealerpoolSlot"..i.."Label"):SetText(L["FREE"])
    end
    
    HealOrganizerDialogEinteilungOptionenTitle:SetText(L["OPTIONS"])
    HealOrganizerDialogEinteilungOptionenAutofill:SetText(L["AUTOFILL"])
    HealOrganizerDialogEinteilungStatsTitle:SetText(L["STATS"])
    HealOrganizerDialogEinteilungStatsPriests:SetText(L["PRIESTS"]..": "..5)
    HealOrganizerDialogEinteilungStatsPriests:SetTextColor(RAID_CLASS_COLORS["PRIEST"].r,
                                                           RAID_CLASS_COLORS["PRIEST"].g,
                                                           RAID_CLASS_COLORS["PRIEST"].b)
    HealOrganizerDialogEinteilungStatsDruids:SetText(L["DRUIDS"]..": "..6)
    HealOrganizerDialogEinteilungStatsDruids:SetTextColor(RAID_CLASS_COLORS["DRUID"].r,
                                                          RAID_CLASS_COLORS["DRUID"].g,
                                                          RAID_CLASS_COLORS["DRUID"].b)
    HealOrganizerDialogEinteilungStatsPaladin:SetText(L["PALADINS"]..": "..5)
    HealOrganizerDialogEinteilungStatsPaladin:SetTextColor(RAID_CLASS_COLORS["PALADIN"].r,
                                                          RAID_CLASS_COLORS["PALADIN"].g,
                                                          RAID_CLASS_COLORS["PALADIN"].b)
    HealOrganizerDialogEinteilungStatsShaman:SetText(L["SHAMANS"]..": "..5)
    HealOrganizerDialogEinteilungStatsShaman:SetTextColor(RAID_CLASS_COLORS["SHAMAN"].r,
                                                          RAID_CLASS_COLORS["SHAMAN"].g,
                                                          RAID_CLASS_COLORS["SHAMAN"].b)
    HealOrganizerDialogEinteilungRest:SetText(L["REMAINS"])
    HealOrganizerDialogEinteilungSetsTitle:SetText(L["LABELS"])
    HealOrganizerDialogEinteilungSetsSave:SetText(TEXT(SAVE))
    HealOrganizerDialogEinteilungSetsSaveAs:SetText(L["SAVEAS"])
    HealOrganizerDialogEinteilungSetsDelete:SetText(TEXT(DELETE))
    HealOrganizerDialogBroadcastTitle:SetText(L["BROADCAST"])
    HealOrganizerDialogBroadcastChannel:SetText(L["CHANNEL"])
    HealOrganizerDialogBroadcastRaid:SetText(L["RAID"])
    HealOrganizerDialogBroadcastWhisperText:SetText(L["WHISPER"]) -- api changed?
    HealOrganizerDialogClose:SetText(L["CLOSE"])
    HealOrganizerDialogReset:SetText(L["RESET"])
    -- }}}
    self:Debug("end localization")
    self:Debug("channel output: \""..self.db.profile.chan.."\"")
    -- standard fuer dropdown setzen 
    UIDropDownMenu_SetSelectedValue(HealOrganizerDialogEinteilungSetsDropDown, L["SET_DEFAULT"], L["SET_DEFAULT"]); 
    self:LoadCurrentLabels()
    self:UpdateDialogValues()
    
    self:Debug( "End init" );
end -- }}}

function HealOrganizer:OnEnable() -- {{{
    -- Called when the addon is enabled
end -- }}}

function HealOrganizer:OnDisable() -- {{{
    -- Called when the addon is disabled
end -- }}}

function HealOrganizer:RefreshTables() --{{{
    self:Debug( "initialize table")
    stats = {
        DRUID = 0,
        PRIEST = 0,
        PALADIN = 0,
        SHAMAN = 0,
    }
    local gruppen = {
        Rest = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
        [7] = 0,
        [8] = 0,
        [9] = 0,
    }
    -- heiler suchen
    for i=1, MAX_RAID_MEMBERS do
        if not UnitExists("raid"..i) then
            -- kein mitglied, also auch kein heiler
        else
            -- prüfen ob er ein heiler ist
            local class,engClass = UnitClass("raid"..i)
            local unitname = UnitName("raid"..i)
            if engClass == "DRUID" or engClass == "PRIEST" or
                    engClass == "PALADIN" or engClass == "SHAMAN" then
                -- ist ein heiler, aber schon eingeteilt?
                if healer[unitname] then
                    -- schon eingeteilt, nichts machen
                    if healer[unitname] ~= "Rest" then
                        if gruppen[healer[unitname]] >= self.CONST.NUM_SLOTS then
                            -- schon zu viele, mach ihm zum rest
                            healer[unitname] = "Rest"
                        end
                    end
                else
                    -- nicht eingeteilt, neu, "rest"
                    healer[unitname] = "Rest"
                    position[unitname] = 0
                end
                self:Debug(healer[unitname])
                gruppen[healer[unitname]] = gruppen[healer[unitname]] + 1
                stats[engClass] = stats[engClass] + 1                
            else
                -- ist kein heiler, nil
                healer[unitname] = nil
            end
        end
    end
    self:Debug("generate stats")
    -- healer[...] -> einteilungsarray
    -- einteilung resetten
    healingAssignment = 
    {
        Rest = {},
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {},
        [7] = {},
        [8] = {},
        [9] = {},
    }
    for name, ort in pairs(healer) do
        table.insert(healingAssignment[ort], name)    
    end
    self:Debug("sort assignments")
    -- einteilungstabelle sortieren (Klasse, Name)
    local function SortEinteilung(a, b) --{{{
        if (self.db.profile.autosort or overrideSort) then
            --[[
            -- Priester,
            -- Druiden,
            -- Paladine,
            -- Schamanen,
            --    NameA,
            --    NameZ
            --]]
            local unitIDa = self:GetUnitByName(a)
            local unitIDb = self:GetUnitByName(b)
            local classA, engClassA = UnitClass(unitIDa)
            local classB, engClassB = UnitClass(unitIDb)
            if engClassA ~= engClassB then
                    -- unterscheidung an der Klasse
                    -- ecken abfangen
                    if engClassA == "PRIEST" then -- (Priest, *)
                            return true
                    end
                    if engClassB == "PRIEST" then -- (*, Priest)
                            return false
                    end
                    if engClassB == "SHAMAN" then -- (*, Shaman)
                            return true
                    end
                    if engClassA == "SHAMAN" then -- (Shaman, *)
                            return false
                    end
                    -- inneren zwei
                    if engClassA == "DRUID" then -- (Druid, *)
                            return true
                    end
                    if engClassB == "DRUID" then -- (*, Druid)
                            return false
                    end
                    if engClassB == "PALADIN" then -- (*, Paladin)
                            return true
                    end
                    if engClassA == "PALADIN" then -- (Paladin, *)
                            return false
                    end
            else
                    -- klassen sind gleich, nach namen sortieren
                    return a<b
            end
            return true
	else 
            if (position[a] and position[b]) then
                self:Debug("sorting: ("..a..")"..position[a].." < ("..b..")"..position[b])
                if position[a] == position[b] and lastAction["position"] then
                    if lastAction["position"] == 0 then
                        if a == lastAction["name"] then -- Spieler a wurde verschoben
                            self:Debug("sortDebug: point1")
                            return true
                        elseif b == lastAction["name"] then -- Spieler b wurde verschoben
                            self:Debug("sortdebug: point2")
                            return false
                        end
                        return true
                    end
                    --Sonderfall - kann nur eintreten wenn ein Spieler AUF einen anderen gezogen wurde - also hier in die Richtung verschieben aus der der alte Spieler kommt
                    --lastAction ist die letzte Aktion die ausgefuehrt wurde + Position von der bewegt wurde
                    if a == lastAction["name"] then -- Spieler a wurde verschoben
                        if lastAction["position"] > position[a] then-- kommt von Unten
                            self:Debug("sortdebug: point3")
                            return true
                        else
                            self:Debug("sortdebug: point4")
                            return false
                        end
                    elseif b == lastAction["name"] then -- Spieler b wurde verschoben
                        if lastAction["position"] > position[b] then-- kommt von Unten
                            self:Debug("sortdebug: point5")
                            return false
                        else
                            self:Debug("sortdebug: point5")
                            return true
                        end
                    end
                end
                return position[a] < position[b] 
            end
            return true
        end
    end --}}}
    for key, tab in pairs(healingAssignment) do
        if key == "Rest" then --Nicht zugeordnete Heiler werden immer sortiert
                overrideSort = true
        end
        table.sort(healingAssignment[key], SortEinteilung)
        --Positionen entsprechend dem Index updaten 
        for index, name in pairs(healingAssignment[key]) do
                position[name] = index
        end
        overrideSort = false
    end
end -- }}}

function HealOrganizer:Dialog() -- {{{
    -- bei einem leeren raid die heilerzuteilung loeschen
    if GetNumRaidMembers() == 0 then
        self:ResetData()
    end
    self:UpdateDialogValues()
    if HealOrganizerDialog:IsShown() then
        self:Debug("dialog: Hide")
        HealOrganizerDialog:Hide()
    else
        self:Debug("dialog: Show")
        HealOrganizerDialog:Show()
    end
end -- }}}

function HealOrganizer:UpdateDialogValues() -- {{{
    self:RefreshTables()
    -- stats aktuallisieren {{{
    HealOrganizerDialogEinteilungStatsPriests:SetText(L["PRIESTS"]..": "..stats["PRIEST"])
    HealOrganizerDialogEinteilungStatsPriests:SetTextColor(RAID_CLASS_COLORS["PRIEST"].r,
                                                           RAID_CLASS_COLORS["PRIEST"].g,
                                                           RAID_CLASS_COLORS["PRIEST"].b)
    HealOrganizerDialogEinteilungStatsDruids:SetText(L["DRUIDS"]..": "..stats["DRUID"])
    HealOrganizerDialogEinteilungStatsDruids:SetTextColor(RAID_CLASS_COLORS["DRUID"].r,
                                                          RAID_CLASS_COLORS["DRUID"].g,
                                                          RAID_CLASS_COLORS["DRUID"].b)
    HealOrganizerDialogEinteilungStatsPaladin:SetText(L["PALADINS"]..": "..stats["PALADIN"])
    HealOrganizerDialogEinteilungStatsPaladin:SetTextColor(RAID_CLASS_COLORS["PALADIN"].r,
                                                          RAID_CLASS_COLORS["PALADIN"].g,
                                                          RAID_CLASS_COLORS["PALADIN"].b)
    HealOrganizerDialogEinteilungStatsShaman:SetText(L["SHAMANS"]..": "..stats["SHAMAN"])
    HealOrganizerDialogEinteilungStatsShaman:SetTextColor(RAID_CLASS_COLORS["SHAMAN"].r,
                                                          RAID_CLASS_COLORS["SHAMAN"].g,
                                                          RAID_CLASS_COLORS["SHAMAN"].b)
    -- }}}
    -- slot-lables aktuallisieren {{{
    for j=1, self.CONST.NUM_GROUPS do
        for i=1, self.CONST.NUM_SLOTS do
            local slotlabel = getglobal("HealOrganizerDialogEinteilungHealGroup"..j.."Slot"..i.."Label")
            local slotbutton = getglobal("HealOrganizerDialogEinteilungHealGroup"..j.."Slot"..i.."Color")
            slotlabel:SetText(self:GetLabelByClass(groupclasses[j][i]))
            local color = RAID_CLASS_COLORS[groupclasses[j][i]];
            if color then
                slotbutton:SetTexture(color.r/1.5, color.g/1.5, color.b/1.5, 0.5)
            else
                slotbutton:SetTexture(0.1, 0.1, 0.1) 
            end
        end
    end
    -- }}}
    -- {{{ gruppen-labels aktuallisieren
    HealOrganizerDialogEinteilungHealerpoolLabel:SetText(grouplabels["Rest"])
    for i=1,self.CONST.NUM_GROUPS do
        getglobal("HealOrganizerDialogEinteilungHealGroup"..i.."Label"):SetText(self:ReplaceTokens(grouplabels[i]))
    end
    -- }}}
    -- gruppen-klassen aktuallisieren {{{
    for i=1, self.CONST.NUM_GROUPS do
        for j=1, self.CONST.NUM_GROUPS do
        end
    end
    -- }}}
    HealOrganizerDialogBroadcastChannelEditbox:SetText(self.db.profile.chan)
    -- einteilungen aktuallisieren -- {{{
    -- alle buttons verstecken
    for i=1, 20 do
        getglobal("HealOrganizerDialogButton"..i):ClearAllPoints()
        getglobal("HealOrganizerDialogButton"..i):Hide()
    end
    local zaehler = 1
    -- Rest {{{
    for i=1, table.getn(healingAssignment.Rest) do
        -- max 20 durchläufe
        if zaehler > 20 then
            -- zu viel, abbrechen
            break
        end
        local button = getglobal("HealOrganizerDialogButton"..zaehler)
        local buttonlabel = getglobal(button:GetName().."Label")
        local buttoncolor = getglobal(button:GetName().."Color")
        -- habe den Button an sich, das Label und die Farbe, einstellen
        buttonlabel:SetText(healingAssignment.Rest[i])
        local class, engClass = UnitClass(self:GetUnitByName(healingAssignment.Rest[i]))
        local color = RAID_CLASS_COLORS[engClass];
        if color then
            buttoncolor:SetTexture(color.r, color.g, color.b)
        end
        -- ancher und position einstellen
        button:SetPoint("TOP", "HealOrganizerDialogEinteilungHealerpoolSlot"..i)
        button:Show()
        -- username im button speichern
        button.username = healingAssignment.Rest[i]
        zaehler = zaehler + 1
    end
    -- }}}
    -- MTs {{{
    for j=1, self.CONST.NUM_GROUPS do
        for i=1, table.getn(healingAssignment[j]) do
            -- max 20 durchläufe
            if zaehler > 20 then
                -- zu viel, abbrechen
                break
            end
            local button = getglobal("HealOrganizerDialogButton"..zaehler)
            local buttonlabel = getglobal(button:GetName().."Label")
            local buttoncolor = getglobal(button:GetName().."Color")
            -- habe den Button an sich, das Label und die Farbe, einstellen
            buttonlabel:SetText(healingAssignment[j][i])
            local class, engClass = UnitClass(self:GetUnitByName(healingAssignment[j][i]))
            local color = RAID_CLASS_COLORS[engClass];
            if color then
                buttoncolor:SetTexture(color.r, color.g, color.b)
            end
            -- ancher und position einstellen
            button:SetPoint("TOP", "HealOrganizerDialogEinteilungHealGroup"..j.."Slot"..i)
            button:Show()
            -- username im button speichern
            button.username = healingAssignment[j][i]
            zaehler = zaehler + 1
        end
    end
    -- }}}
    -- }}}
    -- {{{ Sets aktuallisieren 
    local function HealOrganizer_changeSet( frame )
    	local set = frame:GetText();
        self:Debug("HealOrganizer_changeSet: change set to "..set)
        UIDropDownMenu_SetSelectedValue(HealOrganizerDialogEinteilungSetsDropDown, set, set)
        -- healer temp save
        tempsetup[current_set] = {} -- komplett neu bzw. ueberschreiben
        for name, healingAssignment in pairs(healer) do
            tempsetup[current_set][name] = healingAssignment
        end
        current_set = set
        self:LoadCurrentLabels()
        self:UpdateDialogValues()
    end

	local function HealOrganizerDropDown_Initialize() 

	       local selectedValue = UIDropDownMenu_GetSelectedValue(HealOrganizerDialogEinteilungSetsDropDown)  
	       local info



	       local sorted
	       sorted = {}
	       for n in pairs(self.db.profile.sets) do table.insert(sorted, n) end 
	       table.sort(sorted) 
	       -- aus DB fuellen
	       for key, value in ipairs(sorted) do
	           info = {}
	           info.text = value
	           info.value = value
	           info.func = HealOrganizer_changeSet
	           info.arg1 = value
	           self:Debug("DropDown_Initialize: value "..info.value)
	           self:Debug("DropDown_Initialize: selectedValue: " .. selectedValue)
	           if ( info.value == selectedValue ) then 
	               info.checked = 1; 
	           end
	           UIDropDownMenu_AddButton(info);
	       end
	end
    -- }}} 
    -- dropdown initialisieren
    UIDropDownMenu_Initialize(HealOrganizerDialogEinteilungSetsDropDown, HealOrganizerDropDown_Initialize); 
    UIDropDownMenu_Refresh(HealOrganizerDialogEinteilungSetsDropDown)
    UIDropDownMenu_SetWidth(HealOrganizerDialogEinteilungSetsDropDown, 150); 
end -- }}}

function HealOrganizer:ResetData() -- {{{
    -- einfach alle heiler löschen und neu bauen
    self:Debug("ResetData: reset") 
    healer = {}
    self:Debug("ResetData: label reset")
    current_set = L["SET_DEFAULT"]
    self:LoadCurrentLabels()
    self:Debug("ResetData: reset slot data")
    groupclasses = {}
    for i=1, self.CONST.NUM_GROUPS do
        groupclasses[i] = {}
    end
    self:UpdateDialogValues()
end -- }}}

function HealOrganizer:BroadcastChan() --{{{
    self:Debug("BroadcastChan: broadcasting...")
    -- bin ich im chan?
    if GetNumRaidMembers() == 0 then
        self:ErrorMessage(L["NOT_IN_RAID"])
        return;
    end
    local id, name = GetChannelName(self.db.profile.chan)
    if id == 0 then
        -- nein, nicht drin
        self:Print(L["NO_CHANNEL"], self.db.profile.chan)
        return;
    end
    local messages = self:BuildMessages()
    self:Debug("BroadcastChan: Send to channel "..self.db.profile.chan)
    for _, message in pairs(messages) do
        ChatThrottleLib:SendChatMessage("NORMAL", "HO", message, "CHANNEL", nil, id)
    end
    self:SendToHealers()
end -- }}}

function HealOrganizer:BroadcastRaid() -- {{{
    self:Debug("BroadcastRaid: broadcasting...")
    if GetNumRaidMembers() == 0 then
        self:CustomPrint(1, 0.2, 0.2, self.printFrame, nil, " ", L["NOT_IN_RAID"])
        return;
    end
    local messages = self:BuildMessages()
    for _, message in pairs(messages) do
        ChatThrottleLib:SendChatMessage("NORMAL", "HO", message, "RAID")
    end
    self:SendToHealers()
end -- }}}

function HealOrganizer:BuildMessages() -- {{{
    local messages = {}
    table.insert(messages, L["HEALARRANGEMENT"]..":")
    -- 1-5, rest
    -- {{{ gruppen
    for i=1, self.CONST.NUM_GROUPS do
        local header = getglobal("HealOrganizerDialogEinteilungHealGroup"..i.."Label"):GetText()
        if getn(healingAssignment[i]) ~= 0 then
            local names={}
            for _, name in pairs(healingAssignment[i]) do
                if UnitExists(self:GetUnitByName(name)) then
                    table.insert(names, name)
                end
            end
            table.insert(messages, getglobal("HealOrganizerDialogEinteilungHealGroup"..i.."Label"):GetText()..": "..table.concat(names, ", "))
        end
    end
    -- }}}
    -- {{{ Rest
    local action = self:ReplaceTokens(HealOrganizerDialogEinteilungRestAction:GetText())
    if "" == action then
        action = L["FFA"]
    end
    table.insert(messages, L["REMAINS"]..": "..action)
    -- }}}
    table.insert(messages, L["MSG_HEAL_FOR_ARRANGEMENT"])
    return messages
end -- }}}

function HealOrganizer:SendToHealers() -- {{{
    -- {{{ gruppen
    local whisper = HealOrganizerDialogBroadcastWhisper:GetChecked()
    if whisper then
        for i=1, self.CONST.NUM_GROUPS do
            local header = getglobal("HealOrganizerDialogEinteilungHealGroup"..i.."Label"):GetText()
            if getn(healingAssignment[i]) ~= 0 then
                for _, name in pairs(healingAssignment[i]) do
                    if UnitExists(self:GetUnitByName(name)) then
                        ChatThrottleLib:SendChatMessage("NORMAL", 'HO', string.format(L["ARRANGEMENT_FOR"], header), "WHISPER", nil, name)
                    end
                end
            end
        end
    end
    -- }}}
end -- }}}

function HealOrganizer:ChangeChan() -- {{{
    self:Debug("ChangeChan: changing")
    self.db.profile.chan = HealOrganizerDialogBroadcastChannelEditbox:GetText()
end -- }}}

function HealOrganizer:HealerOnClick(a) -- {{{
    self:Debug("HealerOnClick: click")
    self:Debug("HealerOnClick: value " .. a)
end -- }}}

function HealOrganizer:HealerOnDragStart() -- {{{
    self:Debug("Healer OnDragStart")
    local cursorX, cursorY = GetCursorPosition()
    self:ClearAllPoints();

    self:StartMoving()
    level_of_button = self:GetFrameLevel();
    self:SetFrameLevel(self:GetFrameLevel()+30) -- sehr hoch
end -- }}}

function HealOrganizer:HealerOnDragStop() -- {{{
    self:Debug("Healer OnDragStop")
    self:SetFrameLevel(level_of_button)
    self:StopMovingOrSizing()

    local pools = {
        "HealOrganizerDialogEinteilungHealerpool",
        "HealOrganizerDialogEinteilungHealGroup1Slot1",
        "HealOrganizerDialogEinteilungHealGroup1Slot2",
        "HealOrganizerDialogEinteilungHealGroup1Slot3",
        "HealOrganizerDialogEinteilungHealGroup1Slot4",
        "HealOrganizerDialogEinteilungHealGroup2Slot1",
        "HealOrganizerDialogEinteilungHealGroup2Slot2",
        "HealOrganizerDialogEinteilungHealGroup2Slot3",
        "HealOrganizerDialogEinteilungHealGroup2Slot4",
        "HealOrganizerDialogEinteilungHealGroup3Slot1",
        "HealOrganizerDialogEinteilungHealGroup3Slot2",
        "HealOrganizerDialogEinteilungHealGroup3Slot3",
        "HealOrganizerDialogEinteilungHealGroup3Slot4",
        "HealOrganizerDialogEinteilungHealGroup4Slot1",
        "HealOrganizerDialogEinteilungHealGroup4Slot2",
        "HealOrganizerDialogEinteilungHealGroup4Slot3",
        "HealOrganizerDialogEinteilungHealGroup4Slot4",
        "HealOrganizerDialogEinteilungHealGroup5Slot1",
        "HealOrganizerDialogEinteilungHealGroup5Slot2",
        "HealOrganizerDialogEinteilungHealGroup5Slot3",
        "HealOrganizerDialogEinteilungHealGroup5Slot4",
        "HealOrganizerDialogEinteilungHealGroup6Slot1",
        "HealOrganizerDialogEinteilungHealGroup6Slot2",
        "HealOrganizerDialogEinteilungHealGroup6Slot3",
        "HealOrganizerDialogEinteilungHealGroup6Slot4",
        "HealOrganizerDialogEinteilungHealGroup7Slot1",
        "HealOrganizerDialogEinteilungHealGroup7Slot2",
        "HealOrganizerDialogEinteilungHealGroup7Slot3",
        "HealOrganizerDialogEinteilungHealGroup7Slot4",
        "HealOrganizerDialogEinteilungHealGroup8Slot1",
        "HealOrganizerDialogEinteilungHealGroup8Slot2",
        "HealOrganizerDialogEinteilungHealGroup8Slot3",
        "HealOrganizerDialogEinteilungHealGroup8Slot4",
        "HealOrganizerDialogEinteilungHealGroup9Slot1",
        "HealOrganizerDialogEinteilungHealGroup9Slot2",
        "HealOrganizerDialogEinteilungHealGroup9Slot3",
        "HealOrganizerDialogEinteilungHealGroup9Slot4",
    }
    for _, pool in pairs(pools) do
        poolframe = getglobal(pool)
        if MouseIsOver(poolframe) then
            self:Debug("Bin ueber "..poolframe:GetName())
            local _,_,group,slot = string.find(poolframe:GetName(), "HealOrganizerDialogEinteilungHealGroup(%d+)Slot(%d+)")
            group,slot = tonumber(group),tonumber(slot)
            if (slot and group) then
                    self:Debug("Parent HealOrganizerDialogEinteilungHealGroup"..group.." und slot: "..slot)
            end
            self:Debug("ich habe "..self:GetName())
            self:Debug("vorher "..healer[self.username])
            -- den heiler da zuordnen
            if "HealOrganizerDialogEinteilungHealerpool" == pool then
                healer[self.username] = "Rest"
		position[self.username] = 0
            else
                if group >= 1 and group <= self.CONST.NUM_GROUPS then
                        lastAction["group"] = healer[self.username]
                        healer[self.username] = group
                end
                if slot >= 1 and slot <= self.CONST.NUM_SLOTS then
                        lastAction["name"] = self.username
                        --Nur setzen wenn innerhalb einer Gruppe verschoben wird, 0 = Kommt von ausserhalb und wird an der position eingefuegt und Gruppe nach unten verschoben
                        if lastAction["group"] == group then
                                lastAction["position"] = position[self.username]
                        else
                                lastAction["position"] = 0
                        end
                        --neue Position
                        position[self.username] = slot
                end
            end
            self:Debug("nachher "..healer[self.username])
            break
        end
    end
    -- positionen aktuallisieren
    self:UpdateDialogValues()
end -- }}}

function HealOrganizer:HealerOnLoad() -- {{{
   -- self:Debug("OnLoad")
    -- 0 = pool, MT1-M5
    -- 1 = slots
    -- 2 = passt ;)
    self:SetFrameLevel(self:GetFrameLevel() + 2)
    self:RegisterForDrag("LeftButton")
end -- }}}

function HealOrganizer:EditGroupLabel(group) -- {{{
    self:Debug(group:GetName())
    self:Debug(group:GetID())
    if group:GetID() == 0 then
        return -- Rest nicht bearbeiten
    end
    change_id = group:GetID()
    StaticPopup_Show("HEALORGANIZER_EDITLABEL", group:GetID())    
end -- }}}

function HealOrganizer:SaveNewLabel(id, text) -- {{{
    if id == 0 then
        return
    end
    if text == "" then
        return
    end
    if grouplabels[id] ~= nil then
        grouplabels[id] = text
        self:UpdateDialogValues()
    end
end -- }}}

function HealOrganizer:LoadLabelsFromSet(set) -- {{{
    if not set then
        return nil
    end
    if self.db.profile.sets[set] then
        grouplabels.Rest = L["REMAINS"]
        groupclasses = {}
        for i=1, self.CONST.NUM_GROUPS do
            grouplabels[i] = self.db.profile.sets[set].Beschriftungen[i]
            groupclasses[i] = {}
            for j=1, self.CONST.NUM_SLOTS do
                groupclasses[i][j] = self.db.profile.sets[set].Klassengruppen[i][j]
            end
        end
        HealOrganizerDialogEinteilungRestAction:SetText(self.db.profile.sets[set].Restaktion)
        if tempsetup[set] then
            -- laden
            healer = {} -- reset
            for name, healingAssignment in pairs(tempsetup[set]) do
                if UnitName(self:GetUnitByName(name)) == name then
                    healer[name] = healingAssignment
                end
            end
        end
        return true
    end
    return nil
end -- }}}

function HealOrganizer:LoadCurrentLabels() -- {{{
    if not self:LoadLabelsFromSet(current_set) then
        self:LoadLabelsFromSet(L["SET_DEFAULT"])
    end
end -- }}}

function HealOrganizer:SetSave() -- {{{
    self:Debug("set speichern")
    if current_set == L["SET_DEFAULT"] then
        self:ErrorMessage(L["SET_CANNOT_SAVE_DEFAULT"])
        return
    end
    self.db.profile.sets[current_set].Beschriftungen = {}
    self.db.profile.sets[current_set].Klassengruppen = {}
    for i=1, self.CONST.NUM_GROUPS do
        self.db.profile.sets[current_set].Beschriftungen[i] = grouplabels[i]
        self.db.profile.sets[current_set].Klassengruppen[i] = {}
        for j=1, self.CONST.NUM_SLOTS do
            self.db.profile.sets[current_set].Klassengruppen[i][j] = groupclasses[i][j]
        end
    end
    self.db.profile.sets[current_set].Restaktion = HealOrganizerDialogEinteilungRestAction:GetText()
end -- }}}

function HealOrganizer:SetSaveAs(name) -- {{{
    if not name then
        return
    end
    if name == "" then
        return
    end
    if name == L["SET_DEFAULT"] then
        self:ErrorMessage(L["SET_CANNOT_SAVE_DEFAULT"])
        return
    end
    local count = 0
    for a,b in pairs(self.db.profile.sets) do
        count = count+1
    end
    self:Debug("anzahl sets:" ..count)
    if count >= 32 then
        self:ErrorMessage(L["SET_TO_MANY_SETS"])
        return
    end
    self:Debug("set speichern als :"..name)
    if self.db.profile.sets[name] then
        self:ErrorMessage(string.format(L["SET_ALREADY_EXISTS"], name))
        return
    end
    -- anlegen
    self.db.profile.sets[name] = {}
    self.db.profile.sets[name].Name = name
    self.db.profile.sets[name].Beschriftungen = {}
    self.db.profile.sets[name].Klassengruppen = {}
    for i=1, self.CONST.NUM_GROUPS do
        self.db.profile.sets[name].Beschriftungen[i] = grouplabels[i]
        self.db.profile.sets[name].Klassengruppen[i] = {}
        for j=1, self.CONST.NUM_SLOTS do
            self.db.profile.sets[name].Klassengruppen[i][j] = groupclasses[i][j]
        end
    end
    self.db.profile.sets[name].Restaktion = HealOrganizerDialogEinteilungRestAction:GetText()
    current_set = name
    self:LoadCurrentLabels()
    UIDropDownMenu_SetSelectedValue(HealOrganizerDialogEinteilungSetsDropDown, current_set)
    UIDropDownMenu_Refresh(HealOrganizerDialogEinteilungSetsDropDown)
    self:UpdateDialogValues()
end -- }}}

function HealOrganizer:SetDelete() -- {{{
    if current_set == L["SET_DEFAULT"] then
        self:ErrorMessage(L["SET_CANNOT_DELETE_DEFAULT"])
        return
    end
    self:Debug("set loeschen")
    if not self.db.profile.sets[current_set] then
        return
    end
    self.db.profile.sets[current_set] = nil
    current_set = L["SET_DEFAULT"]
    UIDropDownMenu_SetSelectedValue(HealOrganizerDialogEinteilungSetsDropDown, current_set)
    self:LoadCurrentLabels()
    self:UpdateDialogValues()
end -- }}}

function HealOrganizer:ErrorMessage(str) -- {{{
    if not str then
        return
    end
    if str == "" then
        return
    end
    self:CustomPrint(1, 0.2, 0.2, self.printFrame, nil, " ", str)
end -- }}}

function HealOrganizer:BuildUnitIDs() -- {{{
    unitids = {}
    for i=1, MAX_RAID_MEMBERS do
        if UnitExists("raid"..i) then
            unitids[UnitName("raid"..i)] = "raid"..i
        end
    end
end -- }}}

function HealOrganizer:GetUnitByName(str) -- {{{
    if not str then
        return nil
    end
    if not unitids[str] then
        self:BuildUnitIDs()
    end
    if not unitids[str] then
        -- alter Name, raid schon laengst verlassen.
        return "raid41"
    end
    if str ~= UnitName(unitids[str]) then
        self:BuildUnitIDs()
    end
    return unitids[str]
end -- }}}

function HealOrganizer:ReplaceTokens(str) -- {{{
    -- {{{MTs ersetzen: %MT1% -> MT1(Name) bzw. MT1
    local function GetMainTankLabel(i) -- {{{
        -- MTi(Name) bzw. MTi
        -- CTRaid
        if not i then
            return ""
        end
        if type(i) ~= "number" then
            return ""
        end
        if i < 1 or i > 10 then
            return ""
        end
        local s = L["MT"]..i
        if CT_RATarget then
            self:Debug("CTRAID found, i="..i)
            if CT_RATarget.MainTanks[i] and
                UnitExists("raid"..CT_RATarget.MainTanks[i][1]) and
                UnitName("raid"..CT_RATarget.MainTanks[i][1]) == CT_RATarget.MainTanks[i][2]
                then
                -- MTi vorhanden
                self:Debug("MT"..i.." vorhanden")
                s = s.."("..CT_RATarget.MainTanks[i][2]..")"      
            end
        elseif oRA and oRA.maintanktable then
            --self:Debug("oRA MT found, i="..i)
            if oRA.maintanktable[i] and
                UnitExists(self:GetUnitByName(oRA.maintanktable[i])) and
                UnitName(self:GetUnitByName(oRA.maintanktable[i])) == oRA.maintanktable[i]
                then
                self:Debug("oRA MT"..i.." vorhanden")
                s = s.."("..oRA.maintanktable[i]..")"
            end
        end
        return s
    end -- }}}
    for i=1,10 do
        str = string.gsub(str, "%%MT"..i.."%%", GetMainTankLabel(i))
    end
    -- }}}
    return str
end -- }}}

function HealOrganizer:CHAT_MSG_WHISPER( ... ) -- {{{
	local msg = select(2, ...);
	local user = select(3, ...);
    if GetNumRaidMembers() == 0 then
        -- bin nicht im raid, also auch keine zuteilung
        return
    end
    self:Debug("Der Spieler "..user.." schrieb: "..msg)
    if msg == "heal" then
        self:Debug("healanfrage")
        local reply = L["REPLY_NO_ARRANGEMENT"]
        if healer[user] then
            -- labels holen
            local text = grouplabels[healer[user]]
            if text == L["REMAINS"] then
            	text = HealOrganizerDialogEinteilungRestAction:GetText()
    			if text == "" then
        			text = L["FFA"]
    			end
    		end
            reply = string.format(L["REPLY_ARRANGEMENT_FOR"], self:ReplaceTokens(text))
        end
        self:Debug("Sende Spieler %s den Text %q", user, reply)
        ChatThrottleLib:SendChatMessage("NORMAL", 'HO', reply, "WHISPER", nil, user)
    end
end -- }}}

function HealOrganizer:OnMouseWheel(richtung) -- {{{
    if not self then
        return
    end
    self:Debug("Mausrad:")
    self:Debug(self)
    self:Debug(self and self:GetName())
    self:Debug(richtung)
    local _,_,group,slot = string.find(self:GetName(), "HealOrganizerDialogEinteilungHealGroup(%d+)Slot(%d+)")
    group,slot = tonumber(group),tonumber(slot)
    if not group or not slot then
        self:Debug("kein match o_O")
        self:Debug(group)
        self:Debug(slot)
        return
    end
    self:Debug("group "..group..", slot "..slot)
    if group < 1 or group > self.CONST.NUM_GROUPS or
        slot < 1 or slot > self.CONST.NUM_SLOTS then
        self:Debug("out of index...")
        return
    end
    local classdirection
    local faction = UnitFactionGroup("player")
    if faction == "Alliance" then
        classdirection = {"EMPTY", "PRIEST", "DRUID", "PALADIN"}
    else
        classdirection = {"EMPTY", "PRIEST", "DRUID", "SHAMAN"}
    end
    -- position im array suchen
    local pos = 1
    while (pos <= 4) do
        -- nil abfangen
        if groupclasses[group][slot] then
            if classdirection[pos] == groupclasses[group][slot] then
                break
            end
            -- naechster durchlauf
        else
            -- ist 1/nil/EMPTY
            break
        end
        pos = pos + 1
    end
    -- habe die position
    self:Debug("Label ist "..classdirection[pos])
    -- modulo, % klappte bei mir local nicht o_O
    pos = pos - richtung -- nach unten: PRIEST -> DRUID -> PALADIN -> nil -> PRIEST
    if 0 == pos then
        pos = 4
    end
    if 5 == pos then
        pos = 1
    end
    self:Debug("Neuer label ist "..classdirection[pos])
    if "EMPTY" == classdirection[pos] then
        self:Debug("ist EMPTY")
        groupclasses[group][slot] = nil
    else
        self:Debug("gueltig")
        groupclasses[group][slot] = classdirection[pos]
    end
    self:UpdateDialogValues()
end -- }}}

function HealOrganizer:GetLabelByClass(class) -- {{{
    if not class then
        return L["FREE"]
    end
    self:Debug("Klasse ist "..class)
    if "DRUID" ~= class and
       "PRIEST" ~= class and
       "PALADIN" ~= class and
       "SHAMAN" ~= class then
       return L["FREE"]
    end
    self:Debug("GetLabel: "..class.."-"..L[class])
    return L[class]
end -- }}}

function HealOrganizer:AutoFill() -- {{{
    self:Debug("autofill start")
    for group=1, self.CONST.NUM_GROUPS do
        for slot=1, self.CONST.NUM_SLOTS do
            self:Debug("group"..group.."slot"..slot)
            -- gucken ob was auf den slot soll
            if groupclasses[group][slot] then
                -- gucken ob schon was drauf ist
                if not healingAssignment[group][slot] then
                    -- ist platz, also draufpacken
                    self:Debug("ist platz")
                    -- Rest durchlaufen
                    for _, name in pairs(healingAssignment.Rest) do
                        -- klasse abfragen
                        local class, engClass = UnitClass(self:GetUnitByName(name))
                        if engClass == groupclasses[group][slot] then
                            -- der spieler passt, einteilen
                            healer[name] = group
                            -- neu aufbauen (impliziert refresh-tables)
                            self:UpdateDialogValues()
                            break; -- naechster durchlauf
                        else
                            -- der spieler passt nicht, naechster
                        end
                    end
                end
            end
        end
    end
end -- }}}



HO_DB_DEFAULTS = 
{	profile = 
	{
	    sets = 
	    {
	        [L["SET_DEFAULT"]] = 
	        {
	            Name = L["SET_DEFAULT"],
	            Beschriftungen = 
	            {
	                [1] = "%MT1%",
	                [2] = "%MT2%",
	                [3] = "%MT3%",
	                [4] = "%MT4%",
	                [5] = "%MT5%",
	                [6] = "%MT6%",
	                [7] = "%MT7%",
	                [8] = "%MT8%",
	                [9] = L["DISPEL"],
	            },
	            Restaktion = "ffa",
	            Klassengruppen = 
	            {
	                [1] = {},
	                [2] = {},
	                [3] = {},
	                [4] = {},
	                [5] = {},
	                [6] = {},
	                [7] = {},
	                [8] = {},
	                [9] = {},
	            }
	        }
	    },
		chan = "",
		autosort = true
	}
}
