

local _details	= 	_G._details
local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )

local CreateFrame = CreateFrame
local pairs = pairs 
local UIParent = UIParent
local UnitGUID = UnitGUID 
local tonumber= tonumber 
local LoggingCombat = LoggingCombat

SLASH_DETAILS1, SLASH_DETAILS2, SLASH_DETAILS3 = "/details", "/dt", "/de"

function SlashCmdList.DETAILS(msg, editbox)

	local command, rest = msg:match("^(%S*)%s*(.-)$")
	
	if (command == Loc["STRING_SLASH_NEW"] or command == "new") then
		_details:Createinstance(nil, true)
		
	elseif (command == Loc["STRING_SLASH_HIDE"] or command == Loc["STRING_SLASH_HIDE_ALIAS1"] or command == "hide") then
		_details:ShutDownAllInstances()
	
	elseif (command == Loc["STRING_SLASH_SHOW"] or command == Loc["STRING_SLASH_SHOW_ALIAS1"] or command == "show") then
		_details:ReopenAllInstances()
	
	elseif (command == Loc["STRING_SLASH_WIPECONFIG"] or command == "reinstall") then
		_details:WipeConfig()
	
	elseif (command == Loc["STRING_SLASH_DISABLE"] or command == "disable") then
	
		_details:CaptureSet(false, "damage", true)
		_details:CaptureSet(false, "heal", true)
		_details:CaptureSet(false, "energy", true)
		_details:CaptureSet(false, "miscdata", true)
		_details:CaptureSet(false, "aura", true)
		print(Loc["STRING_DETAILS1"] .. Loc["STRING_SLASH_CAPTUREOFF"])
	
	elseif (command == Loc["STRING_SLASH_ENABLE"] or command == "enable") then
	
		_details:CaptureSet(true, "damage", true)
		_details:CaptureSet(true, "heal", true)
		_details:CaptureSet(true, "energy", true)
		_details:CaptureSet(true, "miscdata", true)
		_details:CaptureSet(true, "aura", true)
		print(Loc["STRING_DETAILS1"] .. Loc["STRING_SLASH_CAPTUREON"])
	
	elseif (command == Loc["STRING_SLASH_OPTIONS"] or command == "options") then
	
		if (rest and tonumber(rest)) then
			local instanceN = tonumber(rest)
			if (instanceN > 0 and instanceN <= #_details.table_instances) then
				local instance = _details:GetInstance(instanceN)
				_details:OpenOptionsWindow(instance)
			end
		else
			local lower_instance = _details:GetLowerInstanceNumber()
			if (not lower_instance) then
				local instance = _details:GetInstance(1)
				_details.Createinstance(_, _, 1)
				_details:OpenOptionsWindow(instance)
			else
				_details:OpenOptionsWindow(_details:GetInstance(lower_instance))
			end
			
		end
	
	elseif (command == Loc["STRING_SLASH_WORLDBOSS"] or command == "worldboss") then
		
		--local questIds = {Galleon = 32098, Sha = 32099, Oondasta = 32519, Celestials = 33117, Ordos = 33118, Nalak = 32518}
		local questIds = {{"The Celestials", 33117}, {"Ordos", 33118}, {"Nalak", 32518}, {"Oondasta", 32519}, {"Salyis's Warband(Galleon)", 32098}, {"Sha of Anger", 32099}}
		for _, _table in pairs(questIds) do 
			print(format("%s: \124cff%s\124r", _table[1], IsQuestFlaggedCompleted(_table[2]) and "ff0000"..Loc["STRING_KILLED"] or "00ff00"..Loc["STRING_ALIVE"]))
		end
		
	elseif (command == Loc["STRING_SLASH_CHANGES"] or command == Loc["STRING_SLASH_CHANGES_ALIAS1"] or command == Loc["STRING_SLASH_CHANGES_ALIAS2"] or command == "news" or command == "updates") then
		_details:OpenNewsWindow()
	
-------- debug ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	elseif (msg == "realmsync") then
		
		_details.realm_sync = not _details.realm_sync
		_details:Msg("Realm Sync: ", _details.realm_sync and "Enabled" or "Disabled")
		
		if (not _details.realm_sync) then
			LeaveChannelByName("Details")
		else
			_details:CheckChatOnLeaveGroup()
		end
	
	elseif (msg == "owner2") then
	
		local tip = CreateFrame('GameTooltip', 'GuardianOwnerTooltip', nil, 'GameTooltipTemplate')
		function GetGuardianOwner(guid)
			tip:SetOwner(WorldFrame, 'ANCHOR_NONE')
			tip:SetHyperlink('unit:' .. guid or '')
			local text = GuardianOwnerTooltipTextLeft2
			--return strmatch(text and text:GetText() or '', "^([^%s']+)'")
			return text:GetText()
		end
	
		print(GetGuardianOwner(UnitGUID("target")))
	
	elseif (msg == "chat") then
	
	
	elseif (msg == "chaticon") then
		_details:Msg("|TInterface\\AddOns\\Details\\images\\icons_bar:" .. 14 .. ":" .. 14 .. ":0:0:256:32:0:32:0:32|ttest")
	
	elseif (msg == "align") then
		local c = RightChatPanel
		local w,h = c:GetSize()
		print(w,h)
		
		local instance1 = _details.table_instances[1]
		local instance2 = _details.table_instances[2]
		
		instance1.baseframe:ClearAllPoints()
		instance2.baseframe:ClearAllPoints()

		instance1.baseframe:SetSize(w/2 - 4, h-20-21-8)
		instance2.baseframe:SetSize(w/2 - 4, h-20-21-8)
		
		instance1.baseframe:SetPoint("bottomleft", RightChatDataPanel, "topleft", 1, 1)
		instance2.baseframe:SetPoint("bottomright", RightChatToggleButton, "topright", -1, 1)
		
	elseif (msg == "addcombat") then
		
		local combat = _details.combat:Newtable(true, _details.table_overall, 1)
		local self = combat[1]:CatchCombatant(UnitGUID("player"), UnitName("player"), 1297, true)
		self.total = 100000
		self.total_without_pet = 100000
		
		if (not _details.um___) then
			_details.um___ = 0
			_details.next_um = 3
		end
		
		local cima = true
		
		_details.um___ = _details.um___ + 1
		
		if (_details.um___ == _details.next_um) then
			_details.next_um = _details.next_um + 3
			cima = false
		end
		
		if (cima) then
			local frostbolt = self.spell_tables:CatchSpell(116, true, "SPELL_DAMAGE")
			local frostfirebolt = self.spell_tables:CatchSpell(44614, true, "SPELL_DAMAGE")
			local icelance = self.spell_tables:CatchSpell(30455, true, "SPELL_DAMAGE")
			
			self.spell_tables._ActorTable[116].total = 50000
			self.spell_tables._ActorTable[44614].total = 25000
			self.spell_tables._ActorTable[30455].total = 25000
		else
			local frostbolt = self.spell_tables:CatchSpell(84721, true, "SPELL_DAMAGE")
			local frostfirebolt = self.spell_tables:CatchSpell(113092, true, "SPELL_DAMAGE")
			local icelance = self.spell_tables:CatchSpell(122, true, "SPELL_DAMAGE")
			
			self.spell_tables._ActorTable[84721].total = 50000
			self.spell_tables._ActorTable[113092].total = 25000
			self.spell_tables._ActorTable[122].total = 25000
		end
		
		combat.start_time = time()-30
		combat.end_time = time()
		
		combat.totals_group[1] = 100000
		combat.totals[1] = 100000
	
		--combat.instance_type = "raid"
		--combat.is_trash = true
	
		_details.table_current = combat
		
		_details.table_history:adicionar(combat)
	
		_details:instanceCallFunction(_details.gump.Fade, "in", nil, "bars")
		_details:instanceCallFunction(_details.UpdateSegments) -- atualiza o instance.showing para as news tables criadas
		_details:instanceCallFunction(_details.UpdateSoloMode_AfertReset) -- verifica se precisa zerar as table da window solo mode
		_details:instanceCallFunction(_details.ResetGump) --_details:ResetGump("de todas as instances")
		_details:UpdateGumpMain(-1, true) --atualiza todas as instances
		
		

	elseif (msg == "pets") then
		local f = _details:CreateListPanel()
		
		local i = 1
		for k, v in pairs(_details.table_pets.pets) do
			if (v[6] == "Guardian of Ancient Kings") then
				_details.ListPanel:add( k.. ": " ..  v[1] .. " | " .. v[2] .. " | " .. v[3] .. " | " .. v[6], i)
				i = i + 1
			end
		end
		
		f:Show()
		
	elseif (msg == "savepets") then
		
		_details.table_current.saved_pets = {}
		
		for k, v in pairs(_details.table_pets.pets) do
			_details.table_current.saved_pets[k] = {v[1], v[2], v[3]}
		end
		
		_details:Msg("pet table has been saved on current combat.")

	elseif (msg == "move") then
	
		print("moving...")
		
		local instance = _details.table_instances[1]
		instance.baseframe:ClearAllPoints()
		--instance.baseframe:SetPoint("CENTER", UIParent, "CENTER", 300, 100)
		instance.baseframe:SetPoint("left", DetailsWelcomeWindow, "right", 10, 0)
	
	elseif (msg == "model") then
		local frame = CreateFrame("PlayerModel");
		frame:SetPoint("center",UIParent,"center");
		frame:SetHeight(600);
		frame:SetWidth(300);
		frame:SetDisplayInfo(49585);
		
	elseif (msg == "ej2") then
	
		--[[ get the EJ_ raid id
		local wantRaids = true -- set false to get 5-man list
		for i=1,1000 do
		    instanceID,name,description,bgImage,buttonImage,loreImage, dungeonAreaMapID, link = EJ_GetInstanceByIndex(i,wantRaids)
		    if not instanceID then break end
		    DEFAULT_CHAT_FRAME:AddMessage(      instanceID.." "..name ,1,0.7,0.5)
		end
		--]]
		
		local iid=362

		for i=1, 100 do
		    local name, description, encounterID, rootSectionID, link = EJ_GetEncounterInfoByIndex(i, iid)

		    if not encounterID then break end
		    local msg = encounterID .. " , " ..  name .. ", ".. rootSectionID.. ", "..link
		    DEFAULT_CHAT_FRAME:AddMessage(msg, 1,0.7,0.5)
		end
		
	elseif (msg == "ej") then
		function PrintAllEncounterSections(encounterID, difficultyID)
			EJ_SetDifficulty(difficultyID)
			local stack, encounter, _, _, curSectionID = {}, EJ_GetEncounterInfo(encounterID)
			print(stack, encounter, _, _, curSectionID)
			repeat
				local title, desc, depth, icon, model, siblingID, nextSectionID, filteredByDifficulty, link, _, f1, f2, f3, f4 = EJ_GetSectionInfo(curSectionID)
				if not filteredByDifficulty then
					--print(("  "):rep(depth) .. link .. ": " .. desc)
					--npcs nao tem icon e possuel modelo diferente de zero.
					--spells tem icon e possuel modelo = zero
					print(title, icon, model, siblingID)
				end
				table.insert(stack, siblingID)
				table.insert(stack, nextSectionID)
				curSectionID = table.remove(stack)
			until not curSectionID
		end
		
		-- Print everything in 25-man Normal Madness of Deathwing:
		PrintAllEncounterSections(869, 4)		
		
	elseif (msg == "time") then
		print("GetTime()", GetTime())
		print("time()", time())

	elseif (msg == "buffs") then
	
		for buffIndex = 1, 41 do
		
			--local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura("player", buffIndex, nil, "HELPFUL")
			--if (name) then
			--	print(name, unitCaster, spellid)
			--end
			
			local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura("raid1", buffIndex, nil, "HELPFUL")
			if (name) then
				print(name, unitCaster, spellid)
			end
			
			local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura("raid2", buffIndex, nil, "HELPFUL")
			if (name) then
				print(name, unitCaster, spellid)
			end
		
		end
	
		
	elseif (msg == "malkorok") then
	
		print("name | count | unitCaster | spellId |  isBossDebuff | value1 | value2 | value3")
	
		do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3  = UnitDebuff("player", 1)
			if (name) then
				print(name, " | ", count, " | ", unitCaster, " | ",spellId, " | ", isBossDebuff, " | ", value1, " | ", value2, " | ", value3)
			end
		end
		do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3  = UnitDebuff("player", 2)
			if (name) then
				print(name, " | ", count, " | ", unitCaster, " | ",spellId, " | ", isBossDebuff, " | ", value1, " | ", value2, " | ", value3)
			end
		end
		do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3  = UnitDebuff("player", 3)
			if (name) then
				print(name, " | ", count, " | ", unitCaster, " | ",spellId, " | ", isBossDebuff, " | ", value1, " | ", value2, " | ", value3)
			end
		end
		
	elseif (msg == "copy") then
		_G.DetailsCopy:Show()
		_G.DetailsCopy.MyObject.text:HighlightText()
		_G.DetailsCopy.MyObject.text:SetFocus()
	
	elseif (msg == "garbage") then
		local a = {}
		for i = 1, 10000 do 
			a[i] = {math.random(50000)}
		end
		table.wipe(a)
	
	elseif (msg == "unitname") then
	
		local name, realm = UnitName("target")
		if (realm) then
			name = name.."-"..realm
		end
		print(name, realm)
	
	elseif (msg == "raid") then
	
		local player, realm = "Ditador", "Azralon"
	
		local actorName
		if (realm ~= GetRealmName()) then
			actorName = player.."-"..realm
		else
			actorName = player
		end
		
		print(actorName)
	
		local guid = _details:FindGUIDFromName("Ditador")
		print(guid)
		
		for i = 1, GetNumPartyMembers(), 1 do 
			local name, realm = UnitName("party"..i)
			print(name, " -- ", realm)
		end

	elseif (msg == "cacheparser") then
		_details:PrintParserCacheIndexes()
	elseif (msg == "parsercache") then
		_details:PrintParserCacheIndexes()
	
	elseif (msg == "captures") then
		for k, v in pairs(_details.capture_real) do 
			print("real -",k,":",v)
		end
		for k, v in pairs(_details.capture_current) do 
			print("current -",k,":",v)
		end
	
	elseif (msg == "slider") then
		
		local f = CreateFrame("frame", "TESTEDESCROLL", UIParent)
		f:SetPoint("center", UIParent, "center", 200, -2)
		f:SetWidth(300)
		f:SetHeight(150)
		f:SetBackdrop({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		f:SetBackdropColor(0, 0, 0, 1)
		f:EnableMouseWheel(true)
		
		local rows = {}
		for i = 1, 7 do 
			local row = CreateFrame("frame", nil, UIParent)
			row:SetPoint("topleft", f, "topleft", 10, -(i-1)*21)
			row:SetWidth(200)
			row:SetHeight(20)
			row:SetBackdrop({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
			local t = row:CreateFontString(nil, "overlay", "GameFontNormalSmall")
			t:SetPoint("left", row, "left")
			row.text = t
			rows[#rows+1] = row
		end
		
		local data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
		
		
	
	elseif (msg == "bcollor") then
	
		--local instance = _details.table_instances[1]
		_details.ResetButton.Middle:SetVertexColor(1, 1, 0, 1)
		
		--print(_details.ResetButton:GetHighlightTexture())
		
		local t = _details.ResetButton:GetHighlightTexture()
		t:SetVertexColor(0, 1, 0, 1)
		--print(t:GetObjectType())
		--_details.ResetButton:SetHighlightTexture(t)
		_details.ResetButton:SetNormalTexture(t)
		
		print("backdrop", _details.ResetButton:GetBackdrop())
		
		_details.ResetButton:SetBackdropColor(0, 0, 1, 1)
		
		--vardump(_details.ResetButton)
	
	elseif (command == "mini") then
		local instance = _details.table_instances[1]
		--vardump()
		--print(instance, instance.StatusBar.options, instance.StatusBar.left)
		print(instance.StatusBar.options[instance.StatusBar.left.mainPlugin.real_name].textSize)
		print(instance.StatusBar.left.options.textSize)
	
	elseif (command == "owner") then
	
		local petname = rest:match("^(%S*)%s*(.-)$")
		local petGUID = UnitGUID("target")

		if (not _G.DetailsScanTooltip) then
			local scanTool = CreateFrame("GameTooltip", "DetailsScanTooltip", nil, "GameTooltipTemplate")
			scanTool:SetOwner(WorldFrame, "ANCHOR_NONE")
		end
		
		function getPetOwner(petName)
			local scanTool = _G.DetailsScanTooltip
			local scanText = _G["DetailsScanTooltipTextLeft2"] -- This is the line with <[Player]'s Pet>
			
			scanTool:ClearLines()
			
			print(petName)
			scanTool:SetUnit(petName)
			
			local ownerText = scanText:GetText()
			if (not ownerText) then 
				return nil 
			end
			local owner, _ = string.split("'", ownerText)

			return owner -- This is the pet's owner
		end
		
		--print(getPetOwner(petname))
		print(getPetOwner(petGUID))

	
	elseif (command == "buffsof") then
		
		local playername, segment = rest:match("^(%S*)%s*(.-)$")
		segment = tonumber(segment or 0)
		print("dumping buffs of ", playername, segment)
		
		local c = _details:GetCombat("current")
		if (c) then
		
			local playerActor
		
			if (segment and segment ~= 0) then
				local c = _details:GetCombat(segment)
				playerActor = c(4, playername)
				print("using segment", segment, c, "player actor:", playerActor)
			else
				playerActor = c(4, playername)
			end
			
			print("actor table: ", playerActor)
			
			if (not playerActor) then
				print("actor table not found")
				return
			end
			
			if (playerActor and playerActor.buff_uptime_spell_tables and playerActor.buff_uptime_spell_tables._ActorTable) then
				for spellid, spellTable in pairs(playerActor.buff_uptime_spell_tables._ActorTable) do 
					local spellname = GetSpellInfo(spellid)
					if (spellname) then
						print(spellid, spellname, spellTable.uptime)
					end
				end
			end
		end
	
	elseif (msg == "alert") then
		
		local instance = _details.table_instances[1]
		local f = function() print("test") end
		instance:InstanceAlert(Loc["STRING_PLEASE_WAIT"], {[[Interface\AddOns\Details\images\StreamCircle]], 22, 22, true}, 5, {f, "param1", "param2"})
	
	
	elseif (msg == "comm") then
		
		if (GetNumRaidMembers() > 0) then
			for i = 1, GetNumRaidMembers() do 
				local nname, server = UnitName("raid"..i)
				print(nname, server)
				--nname = nname.."-"..server
			end
		end

	elseif (msg == "test") then
		
		local a, b = _details:GetEncounterEnd(530, 4)
		print(a, unpack(b))
		
	elseif (msg == "yesno") then
		--_details:Show()
	
	elseif (msg == "imageedit") then
		
		local callback = function(width, height, overlayColor, alpha, texCoords)
			print(width, height, alpha)
			print("overlay: ", unpack(overlayColor))
			print("crop: ", unpack(texCoords))
		end
		
		_details.gump:ImageEditor(callback, "Interface\\AddOns\\Details\\images\\bg-paladin-holy", nil, {1, 1, 1, 1}) -- {0.25, 0.25, 0.25, 0.25}

	elseif (msg == "chat") then
	
		local name, fontSize, r, g, b, a, shown, locked = FCF_GetChatWindowInfo(1);
		print(name,"|",fontSize,"|", r,"|", g,"|", b,"|", a,"|", shown,"|", locked)
		
		--local fontFile, unused, fontFlags = self:GetFont();
		--self:SetFont(fontFile, fontSize, fontFlags);
	
	elseif (msg == "error") then
		a = nil + 1
		
	--> debug
	elseif (command == "resetcapture") then
		_details.capture_real = {
			["damage"] = true,
			["heal"] = true,
			["energy"] = true,
			["miscdata"] = true,
			["aura"] = true,
		}
		_details.capture_current = _details.capture_real
		_details:CaptureRefresh()
		print(Loc["STRING_DETAILS1"] .. "capture has been reseted.")

	--> debug
	elseif (command == "bar") then 
	
		local which_bar = rest and tonumber(rest) or 1
	
		local instance = _details.table_instances[1]
		local bar = instance.bars[which_bar]
		
		for i = 1, bar:GetNumPoints() do 
			local point, relativeTo, relativePoint, xOfs, yOfs = bar:GetPoint(i)
			print(point, relativeTo, relativePoint, xOfs, yOfs)
		end
	
	elseif (msg == "opened") then 
		print("Instances opened: " .. _details.opened_windows)
	
	--> debug, get a guid of something
	elseif (command == "backdrop") then --> localize-me
		local f = MacroFrameTextBackground
		local backdrop = MacroFrameTextBackground:GetBackdrop()
		
		vardump(backdrop)
		vardump(backdrop.insets)
		
		print("bgcolor:",f:GetBackdropColor())
		print("bordercolor",f:GetBackdropBorderColor())
	
	elseif (command == "myguid") then --> localize-me
	
		local g = UnitGUID("player")
		print(type(g))
		print(g)
		print(string.len(g))
		local serial = g:sub(12, 18)
		serial = tonumber("0x"..serial)
		print(serial)
		
		--tonumber((UnitGUID("target")):sub(-12, -9), 16))
		
	elseif (command == "callfunction") then
	
		_details:InstanceCall(_details.SetCombatAlpha, nil, nil, true)
	
	elseif (command == "guid") then --> localize-me
	
		local pass_guid = rest:match("^(%S*)%s*(.-)$")
	
		if (not _details.id_frame) then 
		
			local backdrop = {
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			tile = true, edgeSize = 1, tileSize = 5,
			}
		
			_details.id_frame = CreateFrame("Frame", "DetailsID", UIParent)
			_details.id_frame:SetHeight(14)
			_details.id_frame:SetWidth(120)
			_details.id_frame:SetPoint("center", UIParent, "center")
			_details.id_frame:SetBackdrop(backdrop)
			
			tinsert(UISpecialFrames, "DetailsID")
			
			_details.id_frame.text = CreateFrame("editbox", nil, _details.id_frame)
			_details.id_frame.text:SetPoint("topleft", _details.id_frame, "topleft")
			_details.id_frame.text:SetAutoFocus(false)
			_details.id_frame.text:SetFontObject(GameFontNormalSmall)			
			_details.id_frame.text:SetHeight(14)
			_details.id_frame.text:SetWidth(120)
			_details.id_frame.text:SetJustifyH("CENTER")
			_details.id_frame.text:EnableMouse(true)
			_details.id_frame.text:SetBackdrop(ManualBackdrop)
			_details.id_frame.text:SetBackdropColor(0, 0, 0, 0.5)
			_details.id_frame.text:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80)
			_details.id_frame.text:SetText("") --localize-me
			_details.id_frame.text.lost_focus = nil
			
			_details.id_frame.text:SetScript("OnEnterPressed", function() 
				_details.id_frame.text:ClearFocus()
				_details.id_frame:Hide() 
			end)
			
			_details.id_frame.text:SetScript("OnEscapePressed", function() 
				_details.id_frame.text:ClearFocus()
				_details.id_frame:Hide() 
			end)
			
		end
		
		_details.id_frame:Show()
		_details.id_frame.text:SetFocus()
		
		if (pass_guid == "-") then
			local guid = UnitGUID("target")
			if (guid) then 
				print(guid.. " -> " .. tonumber(guid:sub(9, 12), 16))
				_details.id_frame.text:SetText(""..tonumber(guid:sub(9, 12), 16))
				_details.id_frame.text:HighlightText()
			end
		
		else
			print(pass_guid.. " -> " .. tonumber(pass_guid:sub(9, 12), 16))
			_details.id_frame.text:SetText(""..tonumber(pass_guid:sub(9, 12), 16))
			_details.id_frame.text:HighlightText()
		end
		
	--> debug
	
	elseif (msg == "auras") then
		if (GetNumRaidMembers() > 0) then
			for raidIndex = 1, GetNumRaidMembers() do 
				for buffIndex = 1, 41 do
					local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura("raid"..raidIndex, buffIndex, nil, "HELPFUL")
					print(name, unitCaster, "==", "raid"..raidIndex)
					if (name and unitCaster == "raid"..raidIndex) then
						
						local playerName, realmName = UnitName("raid"..raidIndex)
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end
						
						_details.parser:add_buff_uptime(nil, GetTime(), UnitGUID("raid"..raidIndex), playerName, 0x00000417, UnitGUID("raid"..raidIndex), playerName, 0x00000417, spellid, name, in_or_out)
						
					else
						--break
					end
				end
			end
		end
		
	elseif (command == "profile") then
	
		local profile = rest:match("^(%S*)%s*(.-)$")
		
		print("Force apply profile: ", profile)
		
		_details:ApplyProfile(profile, false)
	
	elseif (msg == "users") then
		_details.users = {}
		_details.sent_highfive = GetTime()
		_details:SendRaidData(_details.network.ids.HIGHFIVE_REQUEST)
		print(Loc["STRING_DETAILS1"] .. "highfive sent.")
	
	elseif (command == "showusers") then
		local users = _details.users
		if (not users) then
			return _details:Msg("there is no users.")
		end
		
		local f = _details.ListPanel
		if (not f) then
			f = _details:CreateListPanel()
		end
		
		local i = 0
		for _, t in ipairs(users) do 
			i = i + 1
			f:add(t[1] .. " | " .. t[2] .. " | " .. t[3] , i)
		end
		
		print(i, "users found.")
	
		f:Show()
	
	elseif (command == "names") then
		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber(t)
		if (not t) then
			return print("not T found.")
		end

		local f = _details.ListPanel
		if (not f) then
			f = _details:CreateListPanel()
		end
		
		local container = _details.table_current[t]._NameIndexTable
		
		local i = 0
		for name, _ in pairs(container) do 
			i = i + 1
			f:add(name, i)
		end
		
		print(i, "names found.")
	
		f:Show()
		
	elseif (command == "actors") then
	
		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber(t)
		if (not t) then
			return print("not T found.")
		end

		local f = _details.ListPanel
		if (not f) then
			f = _details:CreateListPanel()
		end
		
		local container = _details.table_current[t]._ActorTable
		print(#container, "actors found.")
		for index, actor in ipairs(container) do 
			f:add(actor.name, index, filter)
		end
	
		f:Show()
	
	--> debug
	elseif (msg == "save") then
		print("running... this is a debug command, details wont work until next /reload.")
		_details:PrepareTablesForSave()
	
	elseif (msg == "id") then
		local one, two = rest:match("^(%S*)%s*(.-)$")
		if (one ~= "") then
			print("NPC ID:", one:sub(9, 12), 16)
			print("NPC ID:", tonumber((one):sub(9, 12), 16))
		else
			print("NPC ID:", tonumber((UnitGUID("target")):sub(9, 12), 16) )
		end

	--> debug
	elseif (msg == "debug") then
		if (_details.debug) then
			_details.debug = false
			print(Loc["STRING_DETAILS1"] .. "diagnostic mode has been turned off.")
		else
			_details.debug = true
			print(Loc["STRING_DETAILS1"] .. "diagnostic mode has been turned on.")
		end
	
	--> debug combat log
	elseif (msg == "combatlog") then
		if (_details.isLoggingCombat) then
			LoggingCombat(false)
			print("Wow combatlog record turned OFF.")
			_details.isLoggingCombat = nil
		else
			LoggingCombat(true)
			print("Wow combatlog record turned ON.")
			_details.isLoggingCombat = true
		end
		
	elseif (msg == "gs") then
		_details:test_grayscale()
		
	elseif (msg == "outline") then
	
		local instance = _details.table_instances[1]
		for _, bar in ipairs(instance.bars) do 
			local _, _, flags = bar.text_left:GetFont()
			print("outline:",flags)
		end
	
	else
		
		--if (_details.opened_windows < 1) then
		--	_details:Createinstance()
		--end
		
		print(" ")
		print(Loc["STRING_DETAILS1"] .. "(" .. _details.userversion .. ") " ..  Loc["STRING_COMMAND_LIST"])
		print("|cffffaeae/details " .. Loc["STRING_SLASH_NEW"] .. "|r: " .. Loc["STRING_SLASH_NEW_DESC"])
		print("|cffffaeae/details " .. Loc["STRING_SLASH_SHOW"] .. "|r: " .. Loc["STRING_SLASH_SHOW_DESC"])
		print("|cffffaeae/details " .. Loc["STRING_SLASH_HIDE"] .. "|r: " .. Loc["STRING_SLASH_HIDE_DESC"])
		print("|cffffaeae/details " .. Loc["STRING_SLASH_ENABLE"] .. "|r: " .. Loc["STRING_SLASH_ENABLE_DESC"])
		print("|cffffaeae/details " .. Loc["STRING_SLASH_DISABLE"] .. "|r: " .. Loc["STRING_SLASH_DISABLE_DESC"])
		print("|cffffaeae/details " .. Loc["STRING_SLASH_OPTIONS"] .. "|r|cfffcffb0 <instance number>|r: " .. Loc["STRING_SLASH_OPTIONS_DESC"])
		print("|cffffaeae/details " .. Loc["STRING_SLASH_CHANGES"] .. "|r: " .. Loc["STRING_SLASH_CHANGES_DESC"])
		print("|cffffaeae/details " .. Loc["STRING_SLASH_WIPECONFIG"] .. "|r: " .. Loc["STRING_SLASH_WIPECONFIG_DESC"])
		print("|cffffaeae/details " .. Loc["STRING_SLASH_WORLDBOSS"] .. "|r: " .. Loc["STRING_SLASH_WORLDBOSS_DESC"])
		print(" ")

	end
end

function _details:CreateListPanel()

	local f = _details.ListPanel
	if (f) then
		return f
	end

	_details.ListPanel = _details.gump:NewPanel(UIParent, nil, "DetailsActorsFrame", nil, 300, 600)
	_details.ListPanel:SetPoint("center", UIParent, "center", 300, 0)
	_details.ListPanel.bars = {}
	
	tinsert(UISpecialFrames, "DetailsActorsFrame")
	_details.ListPanel.close_with_right = true

	local container_bars_window = CreateFrame("ScrollFrame", "Details_ActorsBarsScroll", _details.ListPanel.widget) 
	local container_bars = CreateFrame("Frame", "Details_ActorsBars", container_bars_window)
	_details.ListPanel.container = container_bars

	_details.ListPanel.width = 500
	_details.ListPanel.locked = false
	
	container_bars_window:SetBackdrop({
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-gold-Border", tile = true, tileSize = 16, edgeSize = 5,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})
	container_bars_window:SetBackdropBorderColor(0, 0, 0, 0)
	
	container_bars:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})		
	container_bars:SetBackdropColor(0, 0, 0, 0)

	container_bars:SetAllPoints(container_bars_window)
	container_bars:SetWidth(500)
	container_bars:SetHeight(150)
	container_bars:EnableMouse(true)
	container_bars:SetResizable(false)
	container_bars:SetMovable(true)
	
	container_bars_window:SetWidth(460)
	container_bars_window:SetHeight(550)
	container_bars_window:SetScrollChild(container_bars)
	container_bars_window:SetPoint("TOPLEFT", _details.ListPanel.widget, "TOPLEFT", 21, -10)

	_details.gump:NewScrollBar(container_bars_window, container_bars, -10, -17)
	container_bars_window.slider:Altura(560)
	container_bars_window.slider:cimaPoint(0, 1)
	container_bars_window.slider:baixoPoint(0, -3)
	container_bars_window.slider:SetFrameLevel(10)

	container_bars_window.ultimo = 0
	
	container_bars_window.gump = container_bars
	
	function _details.ListPanel:add(text, index, filter)
		local row = _details.ListPanel.bars[index]
		if (not row) then
			row = {text = _details.ListPanel.container:CreateFontString(nil, "overlay", "GameFontNormal")}
			_details.ListPanel.bars[index] = row
			row.text:SetPoint("topleft", _details.ListPanel.container, "topleft", 0, -index * 15)
		end
		
		if (filter and text:find(filter)) then
			row.text:SetTextColor(1, 1, 0)
		else
			row.text:SetTextColor(1, 1, 1)
		end
		
		row.text:SetText(text)
	end	
	
	return _details.ListPanel
end
