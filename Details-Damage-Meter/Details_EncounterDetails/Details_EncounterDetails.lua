local AceLocale = LibStub("AceLocale-3.0")
local Loc = AceLocale:GetLocale("Details_EncounterDetails")
local Graphics = LibStub:GetLibrary("LibGraph-2.0")

--> Needed locals
local _GetTime = GetTime --> wow api local
local _UFC = UnitAffectingCombat --> wow api local
local _IsInRaid = IsInRaid --> wow api local
local _IsInGroup = IsInGroup --> wow api local
local _UnitAura = UnitAura --> wow api local
local _GetSpellInfo = _details.getspellinfo --> wow api local
local _CreateFrame = CreateFrame --> wow api local
local _GetTime = GetTime --> wow api local
local _GetCursorPosition = GetCursorPosition --> wow api local
local _GameTooltip = GameTooltip --> wow api local

local _math_floor = math.floor --> lua library local
local _cstr = string.format --> lua library local
local _ipairs = ipairs --> lua library local
local _pairs = pairs --> lua library local
local _table_sort = table.sort --> lua library local
local _table_insert = table.insert --> lua library local
local _unpack = unpack --> lua library local


--> Create the plugin Object
--print("Initialize")
local EncounterDetails = _details:NewPluginObject("Details_EncounterDetails", DETAILSPLUGIN_ALWAYSENABLED)
--print("NewObject")
tinsert(UISpecialFrames, "Details_EncounterDetails")
--> Main Frame
local EncounterDetailsFrame = EncounterDetails.Frame

EncounterDetails:SetPluginDescription("Shows a summary for raid encounters containing dispels, interrupts, deaths, damage taken, graphic raid damage and more..")

--> container types
local class_type_damage = _details.attributes.damage --> damage
local class_type_misc = _details.attributes.misc --> misc
--> main combat object
local _combat_object

local CLASS_ICON_TCOORDS = _G._details.class_coords

EncounterDetails.name = "Encounter Details"
EncounterDetails.debugmode = false

local ability_type_table = {
	[0x1] = "|cFF00FF00"..Loc["STRING_HEAL"].."|r", 
	[0x2] = "|cFF710000"..Loc["STRING_LOWDPS"].."|r", 
	[0x4] = "|cFF057100"..Loc["STRING_LOWHEAL"].."|r", 
	[0x8] = "|cFFd3acff"..Loc["STRING_VOIDZONE"].."|r", 
	[0x10] = "|cFFbce3ff"..Loc["STRING_DISPELL"].."|r", 
	[0x20] = "|cFFffdc72"..Loc["STRING_INTERRUPT"].."|r", 
	[0x40] = "|cFFd9b77c"..Loc["STRING_POSITIONING"].."|r", 
	[0x80] = "|cFFd7ff36"..Loc["STRING_RUNAWAY"].."|r", 
	[0x100] = "|cFF9a7540"..Loc["STRING_TANKSWITCH"] .."|r", 
	[0x200] = "|cFFff7800"..Loc["STRING_MECHANIC"].."|r", 
	[0x400] = "|cFFbebebe"..Loc["STRING_CROWDCONTROL"].."|r", 
	[0x800] = "|cFF6e4d13"..Loc["STRING_TANKCOOLDOWN"].."|r", 
	[0x1000] = "|cFFffff00"..Loc["STRING_KILLADD"].."|r", 
	[0x2000] = "|cFFff9999"..Loc["STRING_SPREADOUT"].."|r", 
	[0x4000] = "|cFFffff99"..Loc["STRING_STOPCAST"].."|r",
	[0x8000] = "|cFFffff99"..Loc["STRING_FACING"].."|r",
	[0x10000] = "|cFFffff99"..Loc["STRING_STACK"].."|r",
	
}

--> main object frame functions
local function CreatePluginFrames(data)
	
	--> catch Details! main object
	local _details = _G._details
	local DetailsFrameWork = _details.gump

	--> saved data if any
	EncounterDetails.data = data or {}
	--> record if button is shown
	EncounterDetails.showing = false
	--> record if boss window is open or not
	EncounterDetails.window_open = false
	EncounterDetails.combat_boss_found = false
	
	--> OnEvent Table
	function EncounterDetails:OnDetailsEvent(event, ...)
	
		--> when main frame became hide
		if (event == "HIDE") then --> plugin hidded, disabled
			self.open = false
		
		--> when main frame is shown on screen
		elseif (event == "SHOW") then --> plugin hidded, disabled
			self.open = true
		
		--> when details finish his startup and are ready to work
		elseif (event == "DETAILS_STARTED") then

			--> check if details are in combat, if not check if the last fight was a boss fight
			if (not EncounterDetails:IsInCombat()) then
				--> get the current combat table
				_combat_object = EncounterDetails:GetCombat()
				--> check if was a boss fight
				EncounterDetails:WasEncounter()
			end
			
			local damage_done_func = function(support_table, time_table, tick_second)

				local current_total_damage = _details.table_current.totals_group[1]
				
				local current_damage = current_total_damage - support_table.last_damage
				
				time_table[tick_second] = current_damage
				
				if (current_damage > support_table.max_damage) then
					support_table.max_damage = current_damage
					time_table.max_damage = current_damage
				end
				
				support_table.last_damage = current_total_damage
			
			end
			
			local string_damage_done_func =[[
			
				-- this script takes the current combat and request the total of damage done by the group.
			
				-- first lets take the current combat and name it "current_combat".
				local current_combat = _details:GetCombat("current") --> getting the current combat
				
				-- now lets ask the combat for the total damage done by the raide group.
				local total_damage = current_combat:GetTotal( DETAILS_ATTRIBUTE_DAMAGE, nil, DETAILS_TOTALS_ONLYGROUP )
			
				-- checks if the result is valid
				if (not total_damage) then
					return 0
				end
			
				-- with the  number in hands, lets finish the code returning the amount
				return total_damage
			]]
			
			--_details:TimeDataRegister("Raid Damage Done", damage_done_func, {last_damage = 0, max_damage = 0}, "Encounter Details", "v1.0",[[Interface\ICONS\Ability_DualWield]], true)
			_details:TimeDataRegister("Raid Damage Done", string_damage_done_func, nil, "Encounter Details", "v1.0",[[Interface\ICONS\Ability_DualWield]], true, true)

			if (EncounterDetails.db.show_icon == 4) then
				EncounterDetails:ShowIcon()
			elseif (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			end
		
		elseif (event == "COMBAT_PLAYER_ENTER") then --> combat started
			if (EncounterDetails.showing and EncounterDetails.db.hide_on_combat) then
				--EncounterDetails:HideIcon()
				EncounterDetails:CloseWindow()
			end
			
			EncounterDetails.current_whisper_table = {}
		
		elseif (event == "COMBAT_PLAYER_LEAVE") then
			--> combat leave and enter always send current combat table
			_combat_object = select(1, ...)
			--> check if was a boss fight
			EncounterDetails:WasEncounter()
			if (EncounterDetails.combat_boss_found) then
				EncounterDetails.combat_boss_found = false
			end
			if (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			end

			local whisper_table = EncounterDetails.current_whisper_table
			if (_combat_object.is_boss and _combat_object.is_boss.name) then
				whisper_table.boss = _combat_object.is_boss.name
				tinsert(EncounterDetails.boss_emotes_table, 1, whisper_table)
				
				if (#EncounterDetails.boss_emotes_table > EncounterDetails.db.max_emote_segments) then
					table.remove(EncounterDetails.boss_emotes_table, EncounterDetails.db.max_emote_segments+1)
				end
			end
			
		elseif (event == "COMBAT_BOSS_FOUND") then
			EncounterDetails.combat_boss_found = true
			if (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			end

		elseif (event == "DETAILS_DATA_RESET") then
			if (_G.DetailsRaidDpsGraph) then
				_G.DetailsRaidDpsGraph:ResetData()
			end
			if (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			end
			--EncounterDetails:HideIcon()
			EncounterDetails:CloseWindow()
			
			--drop last combat table
			EncounterDetails.LastSegmentShown = nil
			
			--wipe emotes
			table.wipe(EncounterDetails.boss_emotes_table)
	
		elseif (event == "GROUP_ONENTER") then
			if (EncounterDetails.db.show_icon == 2) then
				EncounterDetails:ShowIcon()
			end
			
		elseif (event == "GROUP_ONLEAVE") then
			if (EncounterDetails.db.show_icon == 2) then
				EncounterDetails:HideIcon()
			end
			
		elseif (event == "ZONE_TYPE_CHANGED") then
			if (EncounterDetails.db.show_icon == 1) then
				if (select(1, ...) == "raid") then
					EncounterDetails:ShowIcon()
				else
					EncounterDetails:HideIcon()
				end
			end
		
		elseif (event == "PLUGIN_DISABLED") then
			EncounterDetails:HideIcon()
			EncounterDetails:CloseWindow()
			
		elseif (event == "PLUGIN_ENABLED") then
			if (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			elseif (EncounterDetails.db.show_icon == 4) then
				EncounterDetails:ShowIcon()
			end
		end
	end
	
	function EncounterDetails:WasEncounter()

		--> check if last combat was a boss encounter fight
		if (not EncounterDetails.debugmode) then
		
			if (not _combat_object.is_boss) then
				return
			elseif (_combat_object.is_boss.encounter == "pvp") then 
				return
			end
			
			if (_combat_object.instance_type ~= "raid") then
				return
			end
			
		end

		--> boss found, we need to show the icon
		EncounterDetails:ShowIcon()
	end
	
	--> show icon on toolbar
	function EncounterDetails:ShowIcon()
		EncounterDetails.showing = true
		-->[1] button to show[2] button animation: "star", "blink" or true(blink)
		EncounterDetails:ShowToolbarIcon(EncounterDetails.ToolbarButton, "star")
	end
	
	-->  hide icon on toolbar
	function EncounterDetails:HideIcon()
		EncounterDetails.showing = false
		EncounterDetails:HideToolbarIcon(EncounterDetails.ToolbarButton)
	end
	
	--> user clicked on button, need open or close window
	function EncounterDetails:OpenWindow()
		if (EncounterDetails.open) then
			return EncounterDetails:CloseWindow()
		end
		
		--> build all window data
		EncounterDetails.db.opened = EncounterDetails.db.opened + 1
		EncounterDetails:OpenAndRefresh()
		--> show
		EncounterDetailsFrame:Show()
		EncounterDetails.open = true
		
		if (EncounterDetailsFrame.ShowType == "graph") then
			EncounterDetails:BuildDpsGraphic()
		end
		return true
	end
	
	function EncounterDetails:CloseWindow()
		EncounterDetails.open = false
		EncounterDetailsFrame:Hide()
		return true
	end
	
	--> create the button to show on toolbar[1] function OnClick[2] texture[3] tooltip[4] width or 14[5] height or 14[6] frame name or nil
	--EncounterDetails.ToolbarButton = _details.ToolBar:NewPluginToolbarButton(EncounterDetails.OpenWindow, "Interface\\AddOns\\Details\\images\\ScenarioIcon-Boss", Loc["STRING_PLUGIN_NAME"], Loc["STRING_TOOLTIP"], 12, 12, "ENCOUNTERDETAILS_BUTTON") --"Interface\\COMMON\\help-i"
	EncounterDetails.ToolbarButton = _details.ToolBar:NewPluginToolbarButton(EncounterDetails.OpenWindow, "Interface\\AddOns\\Details_EncounterDetails\\images\\icon", Loc["STRING_PLUGIN_NAME"], Loc["STRING_TOOLTIP"], 16, 16, "ENCOUNTERDETAILS_BUTTON") --"Interface\\COMMON\\help-i"
	--> setpoint anchors mod if needed
	EncounterDetails.ToolbarButton.y = 0.5
	EncounterDetails.ToolbarButton.x = 0
	
	--> build all frames ans widgets
	_details.EncounterDetailsTempWindow(EncounterDetails)
	_details.EncounterDetailsTempWindow = nil
	
end

local IsShiftKeyDown = IsShiftKeyDown

local shift_monitor = function(self)
	if (IsShiftKeyDown()) then
		local spellname = GetSpellInfo(self.spellid)
		if (spellname) then
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetHyperlink("spell:"..self.spellid)
			GameTooltip:Show()
			self.showing_spelldesc = true
		end
	else
		if (self.showing_spelldesc) then
			self:GetScript("OnEnter")(self)
			self.showing_spelldesc = false
		end
	end
end

--> custom tooltip for dead details ---------------------------------------------------------------------------------------------------------

	local function KillInfo(deathTable, row)
		
		local eventos = deathTable[1]
		local hora_of_death = deathTable[2]
		local hp_max = deathTable[5]
		
		local battleress = false
		local lastcooldown = false
		
		local GameCooltip = GameCooltip
		
		GameCooltip:Reset()
		GameCooltip:SetType("tooltipbar")
		GameCooltip:SetOwner(row)
		
		GameCooltip:AddLine("Click to Report", nil, 1, "orange")
		GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 0.015625, 0.13671875, 0.4375, 0.59765625)
		GameCooltip:AddStatusBar(0, 1, 1, 1, 1, 1, false, {value = 100, color = {.3, .3, .3, 1}, specialSpark = false, texture =[[Interface\AddOns\Details\images\bar_serenity]]})

		--death parser
		for index, event in _ipairs(eventos) do 
		
			local hp = _math_floor(event[5]/hp_max*100)
			if (hp > 100) then 
				hp = 100
			end
			
			local evtype = event[1]
			local spellname, _, spellicon = _GetSpellInfo(event[2])
			local amount = event[3]
			local time = event[4]
			local source = event[6]

			if (type(evtype) == "boolean") then
				--> is damage or heal
				if (evtype) then
					--> damage
					GameCooltip:AddLine("" .. _cstr("%.1f", time - hora_of_death) .. "s " .. spellname .. "(" .. source .. ")", "-" .. _details:ToK(amount) .. "(" .. hp .. "%)", 1, "white", "white")
					GameCooltip:AddIcon(spellicon)
					
					if (event[9]) then
						--> friendly fire
						GameCooltip:AddStatusBar(hp, 1, "darkorange", true)
					else
						--> from a enemy
						GameCooltip:AddStatusBar(hp, 1, "red", true)
					end
				else
					--> heal
					GameCooltip:AddLine("" .. _cstr("%.1f", time - hora_of_death) .. "s " .. spellname .. "(" .. source .. ")", "+" .. _details:ToK(amount) .. "(" .. hp .. "%)", 1, "white", "white")
					GameCooltip:AddIcon(spellicon)
					GameCooltip:AddStatusBar(hp, 1, "green", true)
					
				end
				
			elseif (type(evtype) == "number") then
				if (evtype == 1) then
					--> cooldown
					GameCooltip:AddLine("" .. _cstr("%.1f", time - hora_of_death) .. "s " .. spellname .. "(" .. source .. ")", "cooldown(" .. hp .. "%)", 1, "white", "white")
					GameCooltip:AddIcon(spellicon)
					GameCooltip:AddStatusBar(100, 1, "yellow", true)
					
				elseif (evtype == 2 and not battleress) then
					--> battle ress
					battleress = event
					
				elseif (evtype == 3) then
					--> last cooldown used
					lastcooldown = event
					
				end
			end
		end

		GameCooltip:AddLine(deathTable[6] .. " " .. "died" , "-- -- -- ", 1, "white")
		GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\small_icons", 1, 1, nil, nil, .75, 1, 0, 1)
		GameCooltip:AddStatusBar(0, 1, .5, .5, .5, .5, false, {value = 100, color = {.5, .5, .5, 1}, specialSpark = false, texture =[[Interface\AddOns\Details\images\bar4_vidro]]})
		
		if (battleress) then
			local name_spell, _, icon_spell = _GetSpellInfo(battleress[2])
			GameCooltip:AddLine("+" .. _cstr("%.1f", battleress[4] - hora_of_death) .. "s " .. name_spell .. "(" .. battleress[6] .. ")", "", 1, "white")
			GameCooltip:AddIcon("Interface\\Glues\\CharacterSelect\\Glues-AddOn-Icons", 1, 1, nil, nil, .75, 1, 0, 1)
			GameCooltip:AddStatusBar(0, 1, .5, .5, .5, .5, false, {value = 100, color = {.5, .5, .5, 1}, specialSpark = false, texture =[[Interface\AddOns\Details\images\bar4_vidro]]})
		end
		
		if (lastcooldown) then
			if (lastcooldown[3] == 1) then 
				local name_spell, _, icon_spell = _GetSpellInfo(lastcooldown[2])
				GameCooltip:AddLine(_cstr("%.1f", lastcooldown[4] - hora_of_death) .. "s " .. name_spell .. "(" .. Loc["STRING_LAST_COOLDOWN"] .. ")")
				GameCooltip:AddIcon(icon_spell)
			else
				GameCooltip:AddLine(Loc["STRING_NOLAST_COOLDOWN"])
				GameCooltip:AddIcon([[Interface\CHARACTERFRAME\UI-Player-PlayTimeUnhealthy]], 1, 1, 18, 18)
			end
				GameCooltip:AddStatusBar(0, 1, 1, 1, 1, 1, false, {value = 100, color = {.3, .3, .3, 1}, specialSpark = false, texture =[[Interface\AddOns\Details\images\bar_serenity]]})
		end


		GameCooltip:SetOption("StatusBarHeightMod", -6)
		GameCooltip:SetOption("FixedWidth", 300)
		GameCooltip:SetOption("TextSize", 9)
		GameCooltip:SetOption("LeftBorderSize", -4)
		GameCooltip:SetOption("RightBorderSize", 5)
		GameCooltip:SetOption("StatusBarTexture",[[Interface\AddOns\Details\images\bar4_reverse]])
		GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0.64453125, 0}, {.8, .8, .8, 0.2}, true)
		
		GameCooltip:ShowCooltip()
	end

--> custom tooltip for dispells details ---------------------------------------------------------------------------------------------------------
local function DispellInfo(dispell, bar)
	
	local players = dispell[1] -->[name od player] = total
	local table_players = {}
	
	for name, tab in _pairs(players) do --> table =[1] total tomado[2] class
		table_players[#table_players + 1] = {name, tab[1], tab[2]}
	end
	
	_table_sort(table_players, function(a, b) return a[2] > b[2] end)
	
	_GameTooltip:ClearLines()
	_GameTooltip:AddLine(bar.text_left:GetText())
	
	for index, tab in _ipairs(table_players) do
		local coords = CLASS_ICON_TCOORDS[tab[3]]
		if (not coords) then
			GameTooltip:AddDoubleLine("|TInterface\\GossipFrame\\DailyActiveQuestIcon:14:14:0:0:16:16:0:1:0:1".."|t "..tab[1]..": ", tab[2], 1, 1, 1, 1, 1, 1)
		else
			GameTooltip:AddDoubleLine("|TInterface\\AddOns\\Details\\images\\classes_small:14:14:0:0:128:128:"..(coords[1]*128)..":"..(coords[2]*128)..":"..(coords[3]*128)..":"..(coords[4]*128).."|t "..tab[1]..": ", tab[2], 1, 1, 1, 1, 1, 1)
		end
	end
end

--> custom tooltip for kick details ---------------------------------------------------------------------------------------------------------

local function KickBy(spell, bar)

	local players = spell[1] -->[name od player] = total
	local table_players = {}
	
	for name, tab in _pairs(players) do --> table =[1] total tomado[2] class
		table_players[#table_players + 1] = {name, tab[1], tab[2]}
	end
	
	_table_sort(table_players, function(a, b) return a[2] > b[2] end)
	
	_GameTooltip:ClearLines()
	_GameTooltip:AddLine(bar.text_left:GetText())
	
	for index, tab in _ipairs(table_players) do
		local coords = CLASS_ICON_TCOORDS[tab[3]]
		GameTooltip:AddDoubleLine("|TInterface\\AddOns\\Details\\images\\classes_small:14:14:0:0:128:128:"..(coords[1]*128)..":"..(coords[2]*128)..":"..(coords[3]*128)..":"..(coords[4]*128).."|t "..tab[1]..": ", tab[2], 1, 1, 1, 1, 1, 1)
	end
end

--> custom tooltip for enemy abilities details ---------------------------------------------------------------------------------------------------------

local function EnemySkills(ability, bar)
	--> bar.player agora tem a table com -->[1] total damage causado[2] players que foram targets[3] players que castaram essa spell[4] ID da spell
	
	local total = ability[1]
	local players = ability[2] -->[name od player] = total
	
	local table_players = {}
	
	for name, tab in _pairs(players) do --> table =[1] total tomado[2] class
		table_players[#table_players + 1] = {name, tab[1], tab[2]}
	end
	
	_table_sort(table_players, function(a, b) return a[2] > b[2] end)
	
	_GameTooltip:ClearLines()
	_GameTooltip:AddLine(bar.text_left:GetText())
	
	for index, tab in _ipairs(table_players) do
		local coords = CLASS_ICON_TCOORDS[tab[3]]
		if (coords) then
			GameTooltip:AddDoubleLine("|TInterface\\AddOns\\Details\\images\\classes_small:14:14:0:0:128:128:"..(coords[1]*128)..":"..(coords[2]*128)..":"..(coords[3]*128)..":"..(coords[4]*128).."|t "..tab[1]..": ", _details:comma_value(tab[2]).."(".._cstr("%.1f",(tab[2]/total) * 100).."%)", 1, 1, 1, 1, 1, 1)
		end
		--GameTooltip:AddDoubleLine("|TInterface\\AddOns\\Details\\images\\classes_small:14:14:0:0:128:128:"..coords[1]..":"..coords[2]..":"..coords[3]..":"..coords[4].."|t "..table[1]..": ", _details:comma_value(table[2]).."(".._cstr("%.1f",(table[2]/total) * 100).."%)", 1, 1, 1, 1, 1, 1)
	end
	
end

--> custom tooltip for damage taken details ---------------------------------------------------------------------------------------------------------

local function DamageTakenDetails(player, bar)

	local agressores = player.damage_from
	local damage_taken = player.damage_taken
	
	local showing = _combat_object[class_type_damage] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable
	
	local mine_agressores = {}
	
	for name, _ in _pairs(agressores) do --> agressores seria a list de names
		local this_agressor = showing._ActorTable[showing._NameIndexTable[name]]
		if (this_agressor) then --> checagem por causa do total e do garbage collector que não limpa os names que deram damage
		
			local abilities = this_agressor.spell_tables._ActorTable
			for id, ability in _pairs(abilities) do 
			--print("oi - " .. this_agressor.name)
				local targets = ability.targets
				for index, dst in _ipairs(targets._ActorTable) do 
					--print("hello -> "..dst.name)
					if (dst.name == player.name) then
						mine_agressores[#mine_agressores+1] = {id, dst.total, this_agressor.name}
					end
				end
			end
		end
	end

	_table_sort(mine_agressores, function(a, b) return a[2] > b[2] end)
	
	_GameTooltip:ClearLines()
	_GameTooltip:AddLine(bar.text_left:GetText())

	local max = #mine_agressores
	if (max > 20) then
		max = 20
	end

	local teve_melee = false
	
	for i = 1, max do
	
		local name_spell, _, icon_spell = _GetSpellInfo(mine_agressores[i][1])
		
		if (mine_agressores[i][1] == 1) then 
			name_spell = "*"..mine_agressores[i][3]
			teve_melee = true
		end
		
		GameTooltip:AddDoubleLine(name_spell..": ", _details:comma_value(mine_agressores[i][2]).."(".._cstr("%.1f",(mine_agressores[i][2]/damage_taken) * 100).."%)", 1, 1, 1, 1, 1, 1)
		GameTooltip:AddTexture(icon_spell)
	end
	
	if (teve_melee) then
		GameTooltip:AddLine("* "..Loc["STRING_MELEE_DAMAGE"], 0, 1, 0)
	end
end

--> custom tooltip clicks on any bar ---------------------------------------------------------------------------------------------------------
function _details:BossInfoRowClick(bar, param1)
	
	if (type(self) == "table") then
		bar, param1 = self, bar
	end
	
	if (type(param1) == "table") then
		bar = param1
	end
	
	if (bar._no_report) then
		return
	end

	local report
	
	if (bar.TTT == "death") then --> deaths
		report = {bar.report_text .. " " .. bar.text_left:GetText()}
		for i = 1, GameCooltip:GetNumLines(), 1 do 
		
			local text_left, text_right = GameCooltip:GetText(i)

			if (text_left and text_right) then 
				text_left = text_left:gsub(("|T(.*)|t "), "")
				report[#report+1] = ""..text_left.." "..text_right..""
			end
		end
	else
		
		bar.report_text = bar.report_text or ""
		report = {bar.report_text .. " " .. _G.GameTooltipTextLeft1:GetText()}
		local numLines = _GameTooltip:NumLines()
		
		for i = 1, numLines, 1 do 
			local name_left = "GameTooltipTextLeft"..i
			local text_left = _G[name_left]
			text_left = text_left:GetText()
			
			local name_right = "GameTooltipTextRight"..i
			local text_right = _G[name_right]
			text_right = text_right:GetText()
			
			if (text_left and text_right) then 
				text_left = text_left:gsub(("|T(.*)|t "), "")
				report[#report+1] = ""..text_left.." "..text_right..""
			end
		end		
	end

	return _details:Report(report, {_no_current = true, _no_inverse = true, _custom = true})
	
end

--> custom tooltip that handle mouse enter and leave on customized rows ---------------------------------------------------------------------------------------------------------

local backdrop_bar_onenter = {bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16, edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 8, insets = {left = 1, right = 1, top = 0, bottom = 1}}
local backdrop_bar_onleave = {bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}}

function EncounterDetails:SetRowScripts(bar, index, container)

	bar:SetScript("OnMouseDown", function(self)
		if (self.fading_in) then
			return
		end
	
		self.mouse_down = _GetTime()
		local x, y = _GetCursorPosition()
		self.x = _math_floor(x)
		self.y = _math_floor(y)

		EncounterDetailsFrame:StartMoving()
		EncounterDetailsFrame.isMoving = true
		
	end)
	
	bar:SetScript("OnMouseUp", function(self)

		if (self.fading_in) then
			return
		end
	
		if (EncounterDetailsFrame.isMoving) then
			EncounterDetailsFrame:StopMovingOrSizing()
			EncounterDetailsFrame.isMoving = false
			--instance:SaveMainWindowPosition() --> precisa do algo pra salvar o trem
		end
	
		local x, y = _GetCursorPosition()
		x = _math_floor(x)
		y = _math_floor(y)
		if ((self.mouse_down+0.4 > _GetTime() and(x == self.x and y == self.y)) or(x == self.x and y == self.y)) then
			_details:BossInfoRowClick(self)
		end
	end)
	
	bar:SetScript("OnEnter", --> MOUSE OVER
		function(self) 
			--> aqui 1
			if (container.fading_in or container.faded) then
				return
			end
		
			self.mouse_over = true
			
			self:SetHeight(17)
			self:SetAlpha(1)
			
			self:SetBackdrop(backdrop_bar_onenter)	
			self:SetBackdropColor(.0, .0, .0, 0.3)
			self:SetBackdropBorderColor(.0, .0, .0, 0.5)
			
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			
			if (not self.TTT) then --> tool tip type
				return
			end
			
			if (self.TTT == "damage_taken") then --> damage taken
				DamageTakenDetails(self.player, bar)
				
			elseif (self.TTT == "abilities_inimigas") then --> enemy abilytes
				EnemySkills(self.player, self)
				self:SetScript("OnUpdate", shift_monitor)
				self.spellid = self.player[4]
				_GameTooltip:AddLine(" ")
				_GameTooltip:AddLine(Loc["STRING_HOLDSHIFT"])
				
			elseif (self.TTT == "total_interrupt") then
				KickBy(self.player, self)
				self:SetScript("OnUpdate", shift_monitor)
				self.spellid = self.player[3]
				_GameTooltip:AddLine(" ")
				_GameTooltip:AddLine(Loc["STRING_HOLDSHIFT"])
				
			elseif (self.TTT == "dispell") then
				DispellInfo(self.player, self)
				self:SetScript("OnUpdate", shift_monitor)
				self.spellid = self.player[3]
				_GameTooltip:AddLine(" ")
				_GameTooltip:AddLine(Loc["STRING_HOLDSHIFT"])
				
			elseif (self.TTT == "death") then --> deaths
				KillInfo(self.player, self) --> aqui 2
			end

			GameTooltip:Show()
		end)
	
	bar:SetScript("OnLeave", --> MOUSE OUT
		function(self) 
		
			self:SetScript("OnUpdate", nil)
		
			if (self.fading_in or self.faded or not self:IsShown() or self.hidden) then
				return
			end
			
			self:SetHeight(16)
			self:SetAlpha(0.9)
			
			self:SetBackdrop(backdrop_bar_onleave)
			self:SetBackdropColor(.0, .0, .0, 0.3)
			
			GameTooltip:Hide()
			_details.popup:ShowMe(false, "tooltip")
		
		end)
end

--> Here start the data mine ---------------------------------------------------------------------------------------------------------
function EncounterDetails:OpenAndRefresh(_, segment)
	
	local frame = EncounterDetailsFrame --alias
	local _combat_object = _combat_object
	
	if (not _combat_object) then
		return
	end
	
	if (segment) then
		--get combat segment, 1 more recently ...25 oldest
		_combat_object = EncounterDetails:GetCombat(segment)
		EncounterDetails._segment = segment
	else
		_G[frame:GetName().."SegmentsDropdown"].MyObject:Select(1, true)
		EncounterDetails._segment = 1
	end
	
	local boss_id
	local map_id
	local boss_info
	
	if (EncounterDetails.debugmode and not _combat_object.is_boss) then
		_combat_object.is_boss = {
			index = 1, 
			name = "Immerseus",
			zone = "Siege of Orggrimar", 
			mapid = 1136, 
			encounter = "Immerseus"
		}
	end
	
	if (not _combat_object.is_boss) then
		for _, combat in _ipairs(EncounterDetails:GetCombatSegments()) do 
			if (combat.is_boss and EncounterDetails:GetBossDetails(combat.is_boss.mapid, combat.is_boss.index)) then
				_combat_object = combat
				break
			end
		end
		if (not _combat_object.is_boss) then
			if (EncounterDetails.LastSegmentShown) then
				_combat_object = EncounterDetails.LastSegmentShown
			else
				return
			end
		end
	end
	
	boss_id = _combat_object.is_boss.index
	map_id = _combat_object.is_boss.mapid
	boss_info = _details:GetBossDetails(_combat_object.is_boss.mapid, _combat_object.is_boss.index)

	if (not boss_info) then
		if (EncounterDetails.LastSegmentShown) then
			_combat_object = EncounterDetails.LastSegmentShown
		else
			return EncounterDetails:Msg(Loc["STRING_BOSS_NOT_REGISTRED"])
		end
	end
	
	if (EncounterDetailsFrame.ShowType == "graph") then
		EncounterDetails:BuildDpsGraphic()
	end
	
	EncounterDetails.LastSegmentShown = _combat_object
	
-------------- set boss name and zone name --------------
	EncounterDetailsFrame.boss_name:SetText(_combat_object.is_boss.encounter)
	EncounterDetailsFrame.raid_name:SetText(_combat_object.is_boss.zone)

-------------- set portrait and background image --------------	
	local L, R, T, B, Texture = EncounterDetails:GetBossIcon(_combat_object.is_boss.mapid, _combat_object.is_boss.index)
	EncounterDetailsFrame.boss_icon:SetTexture(Texture)
	EncounterDetailsFrame.boss_icon:SetTexCoord(L, R, T, B)
	
	local file, L, R, T, B = EncounterDetails:GetRaidBackground(_combat_object.is_boss.mapid)
	EncounterDetailsFrame.raidbackground:SetTexture(file)
	EncounterDetailsFrame.raidbackground:SetTexCoord(L, R, T, B)
	EncounterDetailsFrame.raidbackground:SetAlpha(0.8)
	
-------------- set totals on down frame --------------
--[[ data mine:
	_combat_object["totals_group"] hold the total[1] damage //[2] heal //[3][energy_name] energies //[4][misc_name] miscs --]]

	--EncounterDetailsFrame.StatusBar_totaldamage:SetText(Loc["STRING_TOTAL_DAMAGE"]..": ".. _details:comma_value(_combat_object.totals_group[1])) -->[1] total damage
	--EncounterDetailsFrame.StatusBar_totalheal:SetText(Loc["STRING_TOTAL_HEAL"]..": ".. _details:comma_value(_combat_object.totals_group[2])) -->[2] total heal

	--> Container Overall Damage Taken
		--[[ data mine:
			combat tables have 4 containers[1] damage[2] heal[3] energy[4] misc each container have 2 tables: ._NameIndexTable and ._ActorTable --]]
		local DamageContainer = _combat_object[class_type_damage]
		
		local damage_taken = _details.attribute_damage:RefreshWindow({}, _combat_object, _, { key = "damage_taken", mode = _details.modes.group })
		
		local container = frame.overall_damagetaken.gump
		
		local amount = 0
		local damage_of_primeiro = 0
		
		for index, player in _ipairs(DamageContainer._ActorTable) do
			--> ta em ordem de quem tomou mais damage.
			
			if (not player.group) then --> só aparecer nego da raid
				break
			end
			
			if (player.class and player.class ~= "UNGROUPPLAYER" and player.class ~= "UNKNOW") then
				local bar = container.bars[index]
				if (not bar) then
					bar = EncounterDetails:CreateRow(index, container)
					_details:SetFontSize(bar.text_left, 9)
					_details:SetFontSize(bar.text_right, 9)
					_details:SetFontFace(bar.text_left, "Arial Narrow")
					bar.TTT = "damage_taken" -- tool tip type --> damage taken
					bar.report_text = Loc["STRING_PLUGIN_NAME"].."! "..Loc["STRING_DAMAGE_TAKEN_REPORT"] 
				end

				if (player.name:find("-")) then
					bar.text_left:SetText(player.name:gsub(("-.*"), ""))
				else
					bar.text_left:SetText(player.name)
				end
				
				bar.text_right:SetText(_details:comma_value(player.damage_taken))
				
				_details:name_space(bar)
				
				bar.player = player
				
				bar.texture:SetStatusBarColor(_unpack(_details.class_colors[player.class]))
				
				if (index == 1)  then
					bar.texture:SetValue(100)
					damage_of_primeiro = player.damage_taken
				else
					bar.texture:SetValue(player.damage_taken/damage_of_primeiro *100)
				end
				
				bar.icon:SetTexture("Interface\\AddOns\\Details\\images\\classes_small")
				if (CLASS_ICON_TCOORDS[player.class]) then
					bar.icon:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[player.class]))
				end
				
				bar:Show()
				amount = amount + 1
			end
		end
		
		EncounterDetails:JB_UpdateContainer(container, amount)
		
		if (amount < #container.bars) then
			for i = amount+1, #container.bars, 1 do 
			
				if (bar) then
					bar:Hide()
				end
			end
		end
		
	--> Fim do container Overall Damage Taken
	
	--> Container Overall Spells Inimigas
		local abilities_poll = {}
		
		--> pega as spells contínuas presentes em todas as fases
		if (boss_info.continuo) then
			for index, spellid in _ipairs(boss_info.continuo) do 
				abilities_poll[spellid] = true
			end
		end

		--> pega as abilities que pertence especificamente a cada fase
		local fases = boss_info.phases
		if (fases) then
			for fase_id, fase in _ipairs(fases) do 
				if (fase.spells) then
					for index, spellid in _ipairs(fase.spells) do 
						abilities_poll[spellid] = true
					end
				end
			end
		end
		
		local abilities_usadas = {}
		
		for index, player in _ipairs(DamageContainer._ActorTable) do
			local abilities = player.spell_tables._ActorTable
			for id, ability in _pairs(abilities) do
				if (abilities_poll[id]) then
					--> esse player usou uma ability do boss
					local this_ability = abilities_usadas[id] --> table não numerica, pq diferentes monstros podem castar a mesma spell
					if (not this_ability) then 
						this_ability = {0, {}, {}, id} -->[1] total damage causado[2] players que foram targets[3] players que castaram essa spell[4] ID da spell
						abilities_usadas[id] = this_ability
					end
					
					--> adiciona ao[1] total de damage que this ability causou
					this_ability[1] = this_ability[1] + ability.total
					
					 --> adiciona ao[3] total do player que castou
					if (not this_ability[3][player.name]) then
						this_ability[3][player.name] = 0
					end
					
					this_ability[3][player.name] = this_ability[3][player.name] + ability.total
					
					--> pega os targets e adiciona ao[2]
					local targets = ability.targets
					for index, player in _ipairs(targets._ActorTable) do 
					
						--> ele tem o name do player, vamos ver se this dst é realmente um player verificando na table do combat
						local table_damage_of_player = DamageContainer._ActorTable[DamageContainer._NameIndexTable[player.name]]
						if (table_damage_of_player and table_damage_of_player.group) then
							if (not this_ability[2][player.name]) then 
								this_ability[2][player.name] = {0, table_damage_of_player.class}
							end
							this_ability[2][player.name][1] = this_ability[2][player.name][1] + player.total
						end
					end
				end
			end
		end
		
		--> por em ordem
		local table_em_ordem = {}
		for id, tab in _pairs(abilities_usadas) do 
			table_em_ordem[#table_em_ordem+1] = tab
		end
		
		_table_sort(table_em_ordem, function(a, b) return a[1] > b[1] end)

		container = frame.overall_abilities.gump
		amount = 0
		damage_of_primeiro = 0
		
		--> mostra o resultado nas bars
		for index, ability in _ipairs(table_em_ordem) do
			--> ta em ordem das abilities que deram mais damage
			
			if (ability[1] > 0) then
			
				local bar = container.bars[index]
				if (not bar) then
					bar = EncounterDetails:CreateRow(index, container)
					bar.TTT = "abilities_inimigas" -- tool tip type --enemy abilities
					bar.report_text = Loc["STRING_PLUGIN_NAME"].."! " .. Loc["STRING_ABILITY_DAMAGE"]
					_details:SetFontSize(bar.text_left, 9)
					_details:SetFontSize(bar.text_right, 9)
					_details:SetFontFace(bar.text_left, "Arial Narrow")
					bar.t:SetVertexColor(1, .8, .8, .8)
				end
				
				local name_spell, _, icon_spell = _GetSpellInfo(ability[4])

				bar.text_left:SetText(name_spell)
				bar.text_right:SetText(_details:comma_value(ability[1]))
				
				_details:name_space(bar)
				
				bar.player = ability --> bar.player agora tem a table com -->[1] total damage causado[2] players que foram targets[3] players que castaram essa spell[4] ID da spell
				
				--bar.texture:SetStatusBarColor(_unpack(_details.class_colors[player.class]))
				--bar.texture:SetStatusBarColor(1, 1, 1, 1) --> a cor pode ser a spell school da spell
				
				if (index == 1)  then
					bar.texture:SetValue(100)
					damage_of_primeiro = ability[1]
				else
					bar.texture:SetValue(ability[1]/damage_of_primeiro *100)
				end
				
				bar.icon:SetTexture(icon_spell)
				--bar.icon:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[player.class]))
				
				bar:Show()
				amount = amount + 1
			
			end
		end
		
		--print(amount)
		EncounterDetails:JB_UpdateContainer(container, amount)
		
		if (amount < #container.bars) then
			for i = amount+1, #container.bars, 1 do 
				container.bars[i]:Hide()
			end
		end
	
	--> Fim do container Over Spells Inimigas
	
	--> Identificar os ADDs da fight:
	
		--> declara a pool onde serão armazenados os adds existentas na fight
		local adds_pool = {}
	
		--> pega as abilities que pertence especificamente a cada fase
		if (boss_info.phases) then
			for fase_id, fase in _ipairs(boss_info.phases) do 
				if (fase.adds) then
					for index, addId in _ipairs(fase.adds) do 
						adds_pool[addId] = true
					end
				end
			end
		end
		
		--> agora ja tenho a list de todos os adds da fight
		-- vasculhar o container de damage e achar os adds:
		-- ~add
		
		local adds = {}
		
		for index, player in _ipairs(DamageContainer._ActorTable) do
		
			--> só estou interessado nos adds, conferir pelo name
			--if (adds_pool[tonumber(player.serial:sub(9, 12), 16)] or(player.flag_original and bit.band(player.flag_original, 0x00000060) ~= 0)) then --> é um enemy ou neutro
			if (adds_pool[tonumber(player.serial:sub(9, 12), 16)]) then
				local name = player.name
				local tab = {name = name, total = 0, damage_em = {}, damage_em_total = 0, damage_from = {}, damage_from_total = 0}
			
				--> total de damage que ele causou
				tab.total = player.total
				
				--> em quem ele deu damage
				for _, dst in _ipairs(player.targets._ActorTable) do 
					--local this_player = DamageContainer._ActorTable[DamageContainer._NameIndexTable[dst.name]]
					local this_player = _combat_object(1, dst.name)
					if (this_player) then
						if (this_player.class and this_player.class ~= "UNGROUPPLAYER" and this_player.class ~= "UNKNOW") then
							tab.damage_em[#tab.damage_em +1] = {dst.name, dst.total, this_player.class}
							tab.damage_em_total = tab.damage_em_total + dst.total
						end
					else
						--print("actor not found: " ..dst.name )
					end
				end
				_table_sort(tab.damage_em, function(a, b) return a[2] > b[2] end)
				
				--> quem deu damage nele
				for agressor, _ in _pairs(player.damage_from) do 
					--local this_player = DamageContainer._ActorTable[DamageContainer._NameIndexTable[agressor]]
					local this_player = _combat_object(1, agressor)
					--if (this_player and this_player:IsPlayer()) then 
					if (this_player) then 
						for _, dst in _ipairs(this_player.targets._ActorTable) do 
							if (dst.name == name) then 
								tab.damage_from[#tab.damage_from+1] = {agressor, dst.total, this_player.class}
								tab.damage_from_total = tab.damage_from_total + dst.total
							end
						end
					end
				end
				_table_sort(tab.damage_from, 
								function(a, b) 
									if (a[3] ~= "PET" and b[3] ~= "PET") then 
										return a[2] > b[2] 
									elseif (a[3] == "PET" and b[3] ~= "PET") then
										return false
									elseif (a[3] ~= "PET" and b[3] == "PET") then
										return true
									else
										return a[2] > b[2] 
									end
								end)
				
				tinsert(adds, tab)
				
			end
			
		end
		
		--> montou a table, agora precisa mostrar no painel

		local function _DanoFeito(self)
		
			self.texture:SetBlendMode("ADD")
		
			local bar = self:GetParent()
			local tab = bar.player
			local damage_em = tab.damage_em
			
			GameTooltip:SetOwner(bar, "ANCHOR_TOPRIGHT")
			
			_GameTooltip:ClearLines()
			_GameTooltip:AddLine(bar.text_left:GetText().." ".. Loc["STRING_INFLICTED"]) 
			
			local damage_em_total = tab.damage_em_total
			for _, this_table in _pairs(damage_em) do 
				local coords = CLASS_ICON_TCOORDS[this_table[3]]
				GameTooltip:AddDoubleLine("|TInterface\\AddOns\\Details\\images\\classes_small:14:14:0:0:128:128:"..(coords[1]*128)..":"..(coords[2]*128)..":"..(coords[3]*128)..":"..(coords[4]*128).."|t "..this_table[1]..": ", _details:comma_value(this_table[2]).."(".. _cstr("%.1f", this_table[2]/damage_em_total*100) .."%)", 1, 1, 1, 1, 1, 1)
			end
			
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("CLICK to Report")
			
			GameTooltip:Show()	
		end

		local function _DanoReceived(self)
		
			self.texture:SetBlendMode("ADD")
		
			local bar = self:GetParent()
			local tab = bar.player
			local damage_from = tab.damage_from
			
			GameTooltip:SetOwner(bar, "ANCHOR_TOPRIGHT")
			
			GameTooltip:ClearLines()
			GameTooltip:AddLine(bar.text_left:GetText().." "..Loc["STRING_DAMAGE_TAKEN"])
			
			local damage_from_total = tab.damage_from_total

			for _, this_table in _pairs(damage_from) do 

				local coords = CLASS_ICON_TCOORDS[this_table[3]]
				if (coords) then
					GameTooltip:AddDoubleLine("|TInterface\\AddOns\\Details\\images\\classes_small:14:14:0:0:128:128:"..(coords[1]*128)..":"..(coords[2]*128)..":"..(coords[3]*128)..":"..(coords[4]*128).."|t "..this_table[1]..": ", _details:comma_value(this_table[2]).."(".. _cstr("%.1f", this_table[2]/damage_from_total*100) .."%)", 1, 1, 1, 1, 1, 1)
				else
					GameTooltip:AddDoubleLine(this_table[1],  _details:comma_value(this_table[2]).."(".. _cstr("%.1f", this_table[2]/damage_from_total*100) .."%)", 1, 1, 1, 1, 1, 1)
				end
			end
			
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("CLICK to Report")
			
			GameTooltip:Show()	
		end
		
		local function _OnHide(self)
			GameTooltip:Hide()
			self.texture:SetBlendMode("BLEND")
		end
		
		local y = 10
		local frame_adds = EncounterDetailsFrame.overall_adds
		container = frame_adds.gump
		local index = 1
		amount = 0
		
		table.sort(adds, function(t1, t2) return t1.name < t2.name end)
		
		for index, this_table in _ipairs(adds) do 
		
				local addName = this_table.name
		
				local bar = container.bars[index]
				if (not bar) then
					bar = EncounterDetails:CreateRow(index, container, -0)
					bar:SetBackdrop(backdrop_bar_onleave)
					bar:SetBackdropColor(.0, .0, .0, 0.3)
					
					bar:SetWidth(155)
					
					bar._no_report = true

					--> create 2 botão: um para o damage que add deu e outro para o damage que o add tomou
					local add_damage_taken = _CreateFrame("Button", nil, bar)
					add_damage_taken.report_text = "Details! "
					add_damage_taken.bar = bar
					add_damage_taken:SetWidth(16)
					add_damage_taken:SetHeight(16)
					add_damage_taken:EnableMouse(true)
					add_damage_taken:SetResizable(false)
					add_damage_taken:SetPoint("left", bar, "left", 0, 0)
					
					add_damage_taken:SetBackdrop({bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16})
					add_damage_taken:SetBackdropColor(.0, .5, .0, 0.5)
					
					add_damage_taken:SetScript("OnEnter", _DanoReceived)
					add_damage_taken:SetScript("OnLeave", _OnHide)
					add_damage_taken:SetScript("OnClick", EncounterDetails.BossInfoRowClick)
					
					add_damage_taken.texture = add_damage_taken:CreateTexture(nil, "overlay")
					add_damage_taken.texture:SetTexture("Interface\\AddOns\\Details\\images\\UI-MicroStream-Green")
					add_damage_taken.texture:SetWidth(16)
					add_damage_taken.texture:SetHeight(16)
					add_damage_taken.texture:SetTexCoord(0, 1, 1, 0)
					add_damage_taken.texture:SetPoint("center", add_damage_taken, "center")
					
					local add_damage_done = _CreateFrame("Button", nil, bar)
					add_damage_done.report_text = "Details! "
					add_damage_done.bar = bar
					add_damage_done:SetWidth(16)
					add_damage_done:SetHeight(16)
					add_damage_done:EnableMouse(true)
					add_damage_done:SetResizable(false)
					add_damage_done:SetPoint("left", add_damage_taken, "right", 0, 0)
					
					add_damage_done:SetBackdrop({bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16})
					add_damage_done:SetBackdropColor(.5, .0, .0, 0.5)
					
					add_damage_done.texture = add_damage_done:CreateTexture(nil, "overlay")
					add_damage_done.texture:SetTexture("Interface\\AddOns\\Details\\images\\UI-MicroStream-Red")
					add_damage_done.texture:SetWidth(16)
					add_damage_done.texture:SetHeight(16)
					add_damage_done.texture:SetPoint("topleft", add_damage_done, "topleft")
					
					add_damage_done:SetScript("OnEnter", _DanoFeito)
					add_damage_done:SetScript("OnLeave", _OnHide)
					add_damage_done:SetScript("OnClick", EncounterDetails.BossInfoRowClick)
					
					bar.text_left:SetPoint("left", add_damage_done, "right")
					bar.texture:SetStatusBarTexture(nil)
					_details:SetFontSize(bar.text_left, 9)
					_details:SetFontSize(bar.text_right, 9)
					
					--bar.TTT = "abilities_inimigas" -- tool tip type
				end

				bar.text_left:SetText(addName)
				bar.text_right:SetText(_details:ToK(this_table.total))
				bar.text_left:SetSize(bar:GetWidth() - bar.text_right:GetStringWidth() - 34, 15)
				
				bar.player = this_table --> bar.player agora tem a table com -->[1] total damage causado[2] players que foram targets[3] players que castaram essa spell[4] ID da spell
				
				--bar.texture:SetStatusBarColor(_unpack(_details.class_colors[player.class]))
				bar.texture:SetStatusBarColor(1, 1, 1, 1) --> a cor pode ser a spell school da spell
				bar.texture:SetValue(100)
				
				bar:Show()
				amount = amount + 1
				index = index +1
		end
		
		EncounterDetails:JB_UpdateContainer(container, amount, 4)
		
		if (amount < #container.bars) then
			for i = amount+1, #container.bars, 1 do 
				container.bars[i]:Hide()
			end
		end
		
	--> Fim do container Over ADDS
	
	--> Inicio do Container de Interrupts:
	
		local misc = _combat_object[class_type_misc]
		
		local total_interrompido = _details.attribute_misc:RefreshWindow({}, _combat_object, _, { key = "interrupt", mode = _details.modes.group })
		
		local frame_interrupts = EncounterDetailsFrame.overall_interrupt
		container = frame_interrupts.gump
		
		amount = 0
		local interrupt_of_primeiro = 0
		
		local abilities_interrompidas = {}
		
		for index, player in _ipairs(misc._ActorTable) do
			if (not player.group) then --> só aparecer nego da raid
				break
			end
			
			if (player.class and player.class ~= "UNGROUPPLAYER") then			
				local interrupts = player.interrupt				
				if (interrupts and interrupts > 0) then
					local oque_interrompi = player.interrompeu_oque
					--> vai ter[spellid] = amount
					
					for spellid, amt in _pairs(oque_interrompi) do 
						if (not abilities_interrompidas[spellid]) then --> se a spell não tiver na pool, cria a table dela
							abilities_interrompidas[spellid] = {{}, 0, spellid} --> table com quem interrompeu e o total de vezes que a ability foi interrompida
						end
						
						if (not abilities_interrompidas[spellid][1][player.name]) then --> se o player não tiver na pool dessa ability interrompida, cria um indice pra ele.
							abilities_interrompidas[spellid][1][player.name] = {0, player.class}
						end
						
						abilities_interrompidas[spellid][2] = abilities_interrompidas[spellid][2] + amt
						abilities_interrompidas[spellid][1][player.name][1] = abilities_interrompidas[spellid][1][player.name][1] + amt
					end
				end
			end
		end
		
		--> por em ordem
		table_em_ordem = {}
		for spellid, tab in _pairs(abilities_interrompidas) do 
			table_em_ordem[#table_em_ordem+1] = tab
		end
		_table_sort(table_em_ordem, function(a, b) return a[2] > b[2] end)

		index = 1
		
		for _, tab in _ipairs(table_em_ordem) do
		
			local bar = container.bars[index]
			if (not bar) then
				bar = EncounterDetails:CreateRow(index, container, 3, 3, -6)
				bar.TTT = "total_interrupt" -- tool tip type
				bar.report_text = "Details! ".. Loc["STRING_INTERRUPT_BY"]
				bar:SetBackdrop(backdrop_bar_onleave)
				bar:SetBackdropColor(.0, .0, .0, 0.3)
				bar:SetWidth(155)
			end
			
			local spellid = tab[3]
			
			local name_spell, _, icon_spell = _GetSpellInfo(tab[3])
			local successful = 0
			--> pegar quantas vezes a spell passou com sucesso. table
			for _, enemy_actor in _ipairs(DamageContainer._ActorTable) do
				if (enemy_actor.spell_tables._ActorTable[spellid]) then
					local spell = enemy_actor.spell_tables._ActorTable[spellid]
					successful = spell.successful_casted
				end
			end
			
			bar.text_left:SetText(name_spell)
			local total = successful + tab[2]
			bar.text_right:SetText(tab[2] .. " / ".. total)
			
			_details:name_space(bar)
			
			bar.player = tab
			
			--bar.texture:SetStatusBarColor(_unpack(_details.class_colors[player.class]))
			
			if (index == 1)  then
				bar.texture:SetValue(100)
				damage_of_primeiro = tab[2]
			else
				bar.texture:SetValue(tab[2]/damage_of_primeiro *100)
			end
			
			bar.icon:SetTexture(icon_spell)
			--bar.icon:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[player.class]))
			
			bar:Show()
			
			amount = amount + 1
			index = index + 1 
		end

		EncounterDetails:JB_UpdateContainer(container, amount, 4)
		
		if (amount < #container.bars) then
			for i = amount+1, #container.bars, 1 do 
				container.bars[i]:Hide()
			end
		end
	
	--> Fim do container dos Interrupts
	
	--> Inicio do Container dos Dispells:
		
		--> force refresh window behavior
		local total_dispelled = _details.attribute_misc:RefreshWindow({}, _combat_object, _, { key = "dispell", mode = _details.modes.group })
		
		local frame_dispell = EncounterDetailsFrame.overall_dispell
		container = frame_dispell.gump
		
		amount = 0
		local dispell_of_primeiro = 0
		
		local abilities_dispeladas = {}
		
		for index, player in _ipairs(misc._ActorTable) do
			if (not player.group) then --> só aparecer nego da raid
				break
			end

			if (player.class and player.class ~= "UNGROUPPLAYER") then

				local dispells = player.dispell
				if (dispells and dispells > 0) then
					local oque_dispelei = player.dispell_oque
					--> vai ter[spellid] = amount
					
					--print("dispell: " .. player.class .. " name: " .. player.name)
					
					for spellid, amt in _pairs(oque_dispelei) do 
						if (not abilities_dispeladas[spellid]) then --> se a spell não tiver na pool, cria a table dela
							abilities_dispeladas[spellid] = {{}, 0, spellid} --> table com quem dispolou e o total de vezes que a ability foi dispelada
						end
						
						if (not abilities_dispeladas[spellid][1][player.name]) then --> se o player não tiver na pool dessa ability interrompida, cria um indice pra ele.
							abilities_dispeladas[spellid][1][player.name] = {0, player.class}
							--print(player.name)
							--print(player.class)
						end
						
						abilities_dispeladas[spellid][2] = abilities_dispeladas[spellid][2] + amt
						abilities_dispeladas[spellid][1][player.name][1] = abilities_dispeladas[spellid][1][player.name][1] + amt
					end
				end
			end
		end
		
		--> por em ordem
		table_em_ordem = {}
		for spellid, tab in _pairs(abilities_dispeladas) do 
			table_em_ordem[#table_em_ordem+1] = tab
		end
		_table_sort(table_em_ordem, function(a, b) return a[2] > b[2] end)

		index = 1
		
		for _, tab in _ipairs(table_em_ordem) do
		
			local bar = container.bars[index]
			if (not bar) then
				bar = EncounterDetails:CreateRow(index, container, 3, 3, -6)
				bar.TTT = "dispell" -- tool tip type
				bar.report_text = "Details! ".. Loc["STRING_DISPELLED_BY"]
				bar:SetBackdrop(backdrop_bar_onleave)
				bar:SetBackdropColor(.0, .0, .0, 0.3)
				bar:SetWidth(160)
			end
			
			local name_spell, _, icon_spell = _GetSpellInfo(tab[3])
			
			bar.text_left:SetText(name_spell)
			bar.text_right:SetText(tab[2])
			
			_details:name_space(bar)
			
			bar.player = tab
			
			--bar.texture:SetStatusBarColor(_unpack(_details.class_colors[player.class]))
			
			if (index == 1)  then
				bar.texture:SetValue(100)
				damage_of_primeiro = tab[2]
			else
				bar.texture:SetValue(tab[2]/damage_of_primeiro *100)
			end
			
			bar.icon:SetTexture(icon_spell)
			--bar.icon:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[player.class]))
			
			bar:Show()
			
			amount = amount + 1
			index = index + 1 
		end
		
		EncounterDetails:JB_UpdateContainer(container, amount, 4)
		
		if (amount < #container.bars) then
			for i = amount+1, #container.bars, 1 do 
				container.bars[i]:Hide()
			end
		end
	
	--> Fim do container dos Dispells
	
	--> Inicio do Container das Deaths:
		local frame_deaths = EncounterDetailsFrame.overall_dead
		container = frame_deaths.gump
		
		amount = 0
	
		-- boss_info.spell_tables_info o erro de lua do boss é a ability dele que não foi declarada ainda
	
		local deaths = _combat_object.last_events_tables
		local abilities_info = boss_info.spell_mechanics or {} --bar.extra pega esse cara aqui --> então esse erro é das abilities que não tao
	
		for index, tab in _ipairs(deaths) do
			--> {this_death, time, this_player.name, this_player.class, _UnitHealthMax(dst_name), minutes.."m "..seconds.."s", ["dead"] = true}
			local bar = container.bars[index]
			if (not bar) then
				bar = EncounterDetails:CreateRow(index, container, 3, 0, -4)
				bar.TTT = "death" -- tool tip type
				bar.report_text = "Details! " .. Loc["STRING_DEAD_LOG"]
				_details:SetFontSize(bar.text_left, 9)
				_details:SetFontSize(bar.text_right, 9)
				_details:SetFontFace(bar.text_left, "Arial Narrow")
				bar:SetWidth(160)
			end
			
			if (tab[3]:find("-")) then
				bar.text_left:SetText(index..". "..tab[3]:gsub(("-.*"), ""))
			else
				bar.text_left:SetText(index..". "..tab[3])
			end

			bar.text_right:SetText(tab[6])
			
			_details:name_space(bar)
			
			bar.player = tab
			bar.extra = abilities_info
			
			bar.texture:SetStatusBarColor(_unpack(_details.class_colors[tab[4]]))
			bar.texture:SetValue(100)
			
			bar.icon:SetTexture("Interface\\AddOns\\Details\\images\\classes_small")
			bar.icon:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[tab[4]]))
			
			bar:Show()
			
			amount = amount + 1
		
		end
		
		EncounterDetails:JB_UpdateContainer(container, amount, 4)
		
		if (amount < #container.bars) then
			for i = amount+1, #container.bars, 1 do 
				container.bars[i]:Hide()
			end
		end
end

function EncounterDetails:OnEvent(_, event, ...)
	--print("OnEvent()")
	if (event == "ADDON_LOADED") then
		--print("ADDON_LOADED")
		local AddonName = select(1, ...)
		--print("AddonName: "..AddonName)
		if (AddonName == "Details_EncounterDetails") then
			--print("AddonName OK")
			if (_G._details and _G._details:InstallOkey()) then
				--print("Install OK")
				--> create widgets
				CreatePluginFrames(data)

				local PLUGIN_MINIMAL_DETAILS_VERSION_REQUIRED = 1
				local PLUGIN_TYPE = "TOOLBAR"
				local PLUGIN_LOCALIZED_NAME = Loc["STRING_PLUGIN_NAME"]
				local PLUGIN_REAL_NAME = "DETAILS_PLUGIN_ENCOUNTER_DETAILS"
				local PLUGIN_ICON =[[Interface\AddOns\Details\images\ScenarioIcon-Boss]]
				local PLUGIN_AUTHOR = "Details! Team"
				local PLUGIN_VERSION = "v1.06"
				
				local default_settings = {
					show_icon = 5, --automatic
					hide_on_combat = false, --hide the window when a new combat start
					max_emote_segments = 3,
					opened = 0,
				}

				--> Install
				local install, saveddata, is_enabled = _G._details:InstallPlugin(
					PLUGIN_TYPE,
					PLUGIN_LOCALIZED_NAME,
					PLUGIN_ICON,
					EncounterDetails, 
					PLUGIN_REAL_NAME,
					PLUGIN_MINIMAL_DETAILS_VERSION_REQUIRED, 
					PLUGIN_AUTHOR, 
					PLUGIN_VERSION, 
					default_settings
				)
				
				if (type(install) == "table" and install.error) then
					print(install.error)
				end
				
				EncounterDetails.charsaved = EncounterDetailsDB or {emotes = {}}
				EncounterDetailsDB = EncounterDetails.charsaved
				
				EncounterDetails.boss_emotes_table = EncounterDetails.charsaved.emotes
				
				--> Register needed events
				_G._details:RegisterEvent(EncounterDetails, "COMBAT_PLAYER_ENTER")
				_G._details:RegisterEvent(EncounterDetails, "COMBAT_PLAYER_LEAVE")
				_G._details:RegisterEvent(EncounterDetails, "COMBAT_BOSS_FOUND")
				_G._details:RegisterEvent(EncounterDetails, "DETAILS_DATA_RESET")
				
				_G._details:RegisterEvent(EncounterDetails, "GROUP_ONENTER")
				_G._details:RegisterEvent(EncounterDetails, "GROUP_ONLEAVE")
				
				_G._details:RegisterEvent(EncounterDetails, "ZONE_TYPE_CHANGED")
				
				EncounterDetails.BossWhispColors = {
					[1] = "RAID_BOSS_EMOTE",
					[2] = "RAID_BOSS_WHISPER",
					[3] = "MONSTER_EMOTE",
					[4] = "MONSTER_SAY",
					[5] = "MONSTER_WHISPER",
					[6] = "MONSTER_PARTY",
					[7] = "MONSTER_YELL",
				}
				
			end
		end
		
	end
end
