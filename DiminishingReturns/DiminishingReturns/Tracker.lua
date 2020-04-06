local addon = DiminishingReturns
if not addon then return end

local DRData = LibStub('DRData-1.0')
local SharedMedia = LibStub('LibSharedMedia-3.0')
local band = bit.band

local CATEGORIES = DRData:GetCategories()
addon.CATEGORIES = CATEGORIES

local CL_EVENTS = {
	SPELL_AURA_APPLIED = 0,
	SPELL_AURA_REFRESH = 1,
	SPELL_AURA_REMOVED = 1,
}

local CLO_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE
local CLO_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local CLO_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
local CLO_TYPE_PET_OR_PLAYER = bit.bor(COMBATLOG_OBJECT_TYPE_PET, COMBATLOG_OBJECT_TYPE_PLAYER)

local ICONS
do
	-- Basic icons
	ICONS = {
		taunt = 355, -- Taunt (Warrior)
		banish = 18647, -- Banish
		charge = 100, -- Charge
		cheapshot = 1833, -- Cheap Shot
		ctrlstun = [[Interface\Icons\Spell_Frost_FrozenCore]],
		cyclone = 33786, -- Cyclone
		disarm = 676, -- Disarm
		disorient = 1776, -- Gouge
		entrapment = 19184, -- Entrapment
		fear = 5782, -- Fear
		horror = 6789, -- Death Coil
		mc = 605, -- Mind Control
		rndroot = [[Interface\Icons\Ability_ShockWave]],
		rndstun = [[Interface\Icons\INV_Mace_02]],
		ctrlroot = [[Interface\Icons\Spell_Frost_FrostNova]],
		scatters = 19503, -- Scatter Shot
		silence =  2139, -- Counterspell
		sleep = 2637, -- Hibernate	
	}
	-- Update with class specific icons
	local _, pClass = UnitClass('player')
	if pClass == "DRUID" then
		ICONS.taunt = 6795 -- Growl (Druid)
		ICONS.cheapshot = 9005 -- Pounce
		ICONS.ctrlroot = 339 -- Entangling Roots
		ICONS.ctrlstun = 5211 -- Bash
	elseif pClass == "HUNTER" then
		ICONS.taunt = 20736 -- Distracting Shot
		ICONS.disorient = 3355 -- Freezing Trap
		ICONS.silence = 34490 -- Silencing Shot
		ICONS.disarm = 53359 -- Chimera Shot - Scorpid
		ICONS.ctrlstun = 19577 -- Intimidation
		ICONS.ctrlroot = 4167 -- Web (Spider)
		ICONS.fear = 1513 -- Scare Beast
	elseif pClass == "MAGE" then
		ICONS.disorient = 118 -- Polymorph
		ICONS.ctrlstun = 44572 -- Deep Freeze
		ICONS.rndstun = 12355 -- Impact
		ICONS.ctrlroot = 122 -- Frost Nova
		ICONS.rndroot = 12494 -- Frostbite
	elseif pClass == "ROGUE" then
		ICONS.silence = 1330 -- Garrote	
		ICONS.disarm = 51722 -- Dismantle
		ICONS.fear = 2094 -- Blind
		ICONS.ctrlstun = 408 -- Kidney Shot
	elseif pClass == "WARRIOR" then
		ICONS.silence = 18498 -- Gag Order (Warrior talent)	
		ICONS.fear = 5246 -- Intimidating Shout
		ICONS.ctrlstun = 12809 -- Concussion Blow
		ICONS.rndstun = 12798 -- Revenge Stun
		ICONS.rndroot = 23694 -- Improved Hamstring
	end
end
addon.ICONS = ICONS

local SPELLS = {}
for id, category in pairs(DRData:GetSpells()) do
	if CATEGORIES[category] then
		SPELLS[id] = category
	end
end
addon.SPELLS = SPELLS

local spellsResolved = false
do
	local function ResolveSpells()
		addon:UnregisterEvent('PLAYER_LOGIN', ResolveSpells)
		ResolveSpells = nil
		for id, category in pairs(SPELLS) do
			if type(id) == "number" then
				local name = GetSpellInfo(id)
				if name then
					SPELLS[name] = category
				--[===[@debug@
				else
					addon:Debug('Unknown spell', id, 'for', category)
				--@end-debug@]===]
				end
			end
		end
		for cat, icon in pairs(ICONS) do
			if type(icon) == "number" then
				ICONS[cat] = select(3, GetSpellInfo(icon))
			end
		end
		spellsResolved = true
	end
	if not IsLoggedIn() then
		addon:RegisterEvent('PLAYER_LOGIN', ResolveSpells)
	else
		ResolveSpells()
	end
end

local new, del
do
	local heap = setmetatable({},{__mode='k'})
	function new()
		local t = tremove(heap) or {}
		heap[t] = nil
		return t
	end
	function del(t)
		wipe(t)
		heap[t] = true
	end
end

local runningDR = {}
local timerFrame = CreateFrame("Frame")

local function RemoveDR(guid, cat)
	local targetDR = runningDR[guid]
	local dr = targetDR and targetDR[cat]
	if dr then
		if dr.count > 0 then
			addon:TriggerMessage('RemoveDR', guid, cat)
		end
		targetDR[cat] = del(dr)
		if not next(targetDR) then
			runningDR[guid] = del(targetDR)
			if not next(runningDR) then
				timerFrame:Hide()
			end
		end
	end
end

local function RemoveAllDR(guid)
	if runningDR[guid] then
		for cat in pairs(runningDR[guid]) do
			RemoveDR(guid, cat)
		end
	end
end

local function ParseCLEU(self, _, timestamp, event, _, srcName, srcFlags, guid, name, flags, spellId, spell)	
	-- Always process UNIT_DIED if we have information about the unit
	if event == 'UNIT_DIED' then
		if runningDR[guid] then
			RemoveAllDR(guid)
		end
		return
	end
	-- Ignore targetted friends
	if band(flags, CLO_REACTION_FRIENDLY) ~= 0 then return end
	-- Ignore any spell or event we are not interested with
	local increase, category = CL_EVENTS[event], SPELLS[spellId] or SPELLS[spell]
	if not increase or not category then return end
	-- Ignore mobs for non-PvE categories
	local isPlayer = band(flags, CLO_TYPE_PET_OR_PLAYER) ~= 0 or band(flags, CLO_CONTROL_PLAYER) ~= 0
	local prefs = addon.db.profile
	if not isPlayer and (not addon.db.profile.pveMode or not DRData:IsPVE(category)) then return end
	-- Category auto-learning
	if prefs.learnCategories and band(srcFlags, CLO_AFFILIATION_MINE) ~= 0 and not prefs.categories[category] then
		prefs.categories[category] = true
	end
	-- Now do the job
	local targetDR = runningDR[guid]
	if not targetDR then
		targetDR = new()
		runningDR[guid] = targetDR
	end
	local dr = targetDR[category]
	local now = GetTime()
	if not dr then
		dr = new()
		dr.texture = ICONS[category]
		dr.count = 0
		targetDR[category] = dr
	end
	dr.count = dr.count + increase
	local duration = prefs.resetDelay
	dr.expireTime = now + duration
	if dr.count > 0 then
		assert(type(duration) == "number")
		self:TriggerMessage('UpdateDR', guid, category, dr.texture, dr.count, duration, dr.expireTime)
	end
	timerFrame:Show()
end

local function WipeAll(self)
	for guid, drs in pairs(runningDR) do
		for category in pairs(drs) do
			RemoveDR(guid, category)
		end
	end
end

local timer = 0
timerFrame:Hide()
timerFrame:SetScript('OnShow', function() timer = 0 end)
timerFrame:SetScript('OnUpdate', function(self, elapsed)
	if timer > 0 then
		timer = timer - elapsed
		return
	end
	local now = GetTime()
	local watched = addon.db.profile.categories
	local hasReset = false
	timer = 0.1
	for guid, drs in pairs(runningDR) do
		for cat, dr in pairs(drs) do
			if now >= dr.expireTime then
				if dr.count > 0 and watched[cat] then
					hasReset = true
				end
				RemoveDR(guid, cat)
			end
		end
	end
	if hasReset and addon.db.profile.soundAtReset then
		local key = addon.db.profile.resetSound
		local media = SharedMedia:Fetch('sound', media)
		addon:Debug('PlaySound', key, media)
		PlaySound(media)
	end
end)

local function IterFunc(targetDR, cat)
	local dr
	cat, dr = next(targetDR, cat)
	if cat then
		return cat, dr.texture, dr.count, addon.db.profile.resetDelay, dr.expireTime
	end
end

local function noop() end

function addon:IterateDR(guid)
	if runningDR[guid] then
		return IterFunc, runningDR[guid]
	else
		return noop
	end
end

function addon:CheckActivation(event)
	local activate = false
	if spellsResolved then
		if addon.db.profile.pveMode then
			activate = not IsResting()
		else
			local _, instanceType = IsInInstance()
			activate = (instanceType ~= "raid" and instanceType ~= "party") and UnitIsPVP('player')
		end
	end
	if activate then
		if not addon.active then
			addon:Debug('CheckActivation, pveMode=', addon.db.profile.pveMode, ', activating')
			addon:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ParseCLEU)
			addon:RegisterEvent('PLAYER_LEAVING_WORLD', WipeAll)
			addon.active = true
			addon:TriggerMessage('EnableDR')
		end
	elseif addon.active then
		addon:Debug('CheckActivation, pveMode=', addon.db.profile.pveMode, ', disactivating')
		addon:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ParseCLEU)
		addon:UnregisterEvent('PLAYER_LEAVING_WORLD', WipeAll)
		WipeAll()
		addon.active = false
		addon:TriggerMessage('DisableDR')
	end
end

addon:RegisterEvent('PLAYER_ENTERING_WORLD', 'CheckActivation')
addon:RegisterEvent('PLAYER_UPDATE_RESTING', 'CheckActivation')
addon:RegisterEvent('UNIT_FACTION', function(self, event, unit)
	if unit == "player" then return addon:CheckActivation(event) end
end)
addon:RegisterEvent('OnConfigChanged', function(self, event, name)
	if name == "pveMode" then return addon:CheckActivation(event) end
end)
