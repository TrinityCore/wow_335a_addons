-- Author      : RisM
-- Create Date : 6/28/2009 4:02:20 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("wowevents.lua")

-------------------------------------------------------------------------------
-- WOW GAME EVENT HANDLERS
-------------------------------------------------------------------------------


function SpeakinSpell:RegisterAllEvents()
	local funcname = "RegisterAllEvents"
	self:DebugMsg(funcname, "entry")
	
	-- register for spellcasting events
	-- which is our hook too know when to speak for a spell
	-- among other things
	
	-- startup and loading events
	--self:RegisterEvent("VARIABLES_LOADED") -- wowwiki recommends using ADDON_LOADED instead after WoW 3.0
	-- see additional comments around these two event handler functions
	self:RegisterEvent("ADDON_LOADED")
	
	-- combat events
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PLAYER_DEAD")
	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("PLAYER_UNGHOST")
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE")

	-- enter and exit combat
	-- NOTE: PLAYER_ENTER_COMBAT and PLAYER_LEAVE_COMBAT are not what they sound like
	--		Those 2 events are auto-attack on/off notifications
	--		To detect when the combat flag goes on and off from getting/losing aggro
	--		which is what we generally mean by "entering combat" and "exiting combat"
	--		we must check for Regen enabled/disabled, which is our only valid notification
	--		see also: http://www.wowwiki.com/Events/Combat
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	-- change zones --
	--self:RegisterEvent("MINIMAP_ZONE_CHANGED") --for subzone changes - does not appear to be needed
	self:RegisterEvent("ZONE_CHANGED_INDOORS") --for subzone changes inside an instance
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA") --for large scale zone changes
	self:RegisterEvent("ZONE_CHANGED") --covers both small and large scale zone changes?
	
	-- chat events, such as receiving a whisper
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_GUILD")
	self:RegisterEvent("CHAT_MSG_PARTY")

	-- detecting /follow
	self:RegisterEvent("AUTOFOLLOW_BEGIN")
	self:RegisterEvent("AUTOFOLLOW_END")
	
	-- Achievements
	self:RegisterEvent("ACHIEVEMENT_EARNED")
	self:RegisterEvent("CHAT_MSG_ACHIEVEMENT")
	self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")

	-- NPC interaction
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("BARBER_SHOP_OPEN")
	self:RegisterEvent("BARBER_SHOP_CLOSE")
	self:RegisterEvent("MAIL_SHOW")
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("QUEST_GREETING")
	self:RegisterEvent("TAXIMAP_OPENED")
	self:RegisterEvent("TRAINER_SHOW")
	
	-- more miscellaneous events
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("RESURRECT_REQUEST")
	self:RegisterEvent("TRADE_SHOW")
end


---------------------------------------------------------------------------
-- STARTUP AND LOADING EVENTS
---------------------------------------------------------------------------

-- 2010/04/17
-- wowwiki recommends using ADDON_LOADED instead of VARIABLES_LOADED
-- it has never been a problem for me to use VARIABLES_LOADED
-- but every so often someone has complained that installing a new version of SS
-- erased their old saved data, which should not occur (See oldversions.lua)
-- however the load order changes from WoW 3.0 described here:
-- http://www.wowwiki.com/AddOn_loading_process
-- http://www.wowwiki.com/Events/V
-- http://www.wowwiki.com/Events_A-B_%28ActionBar,_Auction,_AutoEquip,_AutoFollow,_Bag,_BankFrame,_BattleFields,_Billing%29#ADDON_LOADED
-- suggest that perhaps switching to ADDON_LOADED will fix this problem (/shrug?)
-- It still seems more likely to me that those other users suffered some other problem
-- and blamed SS incorrectly, but it doesn't hurt to update to the new best practice here

--[[ mothballed

function SpeakinSpell:VARIABLES_LOADED()
	local funcname = "VARIABLES_LOADED"
	self:DebugMsg(funcname, "entry")
	
	--self:OnVariablesLoaded() -- redirected to SpeakinSpell.lua near OnLoad and OnInitialize
end

--]]


function SpeakinSpell:ADDON_LOADED(_,name)
	local funcname = "ADDON_LOADED"
	self:DebugMsg(funcname, "entry, name:"..tostring(name))
	
	if name == "SpeakinSpell" then
		self:OnVariablesLoaded() -- redirected to SpeakinSpell.lua near OnLoad and OnInitialize
	end
end


---------------------------------------------------------------------------
-- COMBAT EVENTS
---------------------------------------------------------------------------


function SpeakinSpell:SPELL_AURA_APPLIED(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	local funcname = "SPELL_AURA_APPLIED"
	-- we're only concerned with buffs we receive
	if dstName ~= UnitName("player") then
		--self:DebugMsg(funcname, "not cast on you")
		return
	end
	
	-- extra parameters provided with "SPELL_" prefix
	local spellId, spellName, spellSchool = select(1, ...)
	-- extra parameters provided with "_AURA_APPLIED" suffix (same for _AURA_REFRESH)
	local auraType = select(4, ...)

--	self:DebugMsg(funcname, "( srcName, dstName, auraType, spellName )")
--	self:DebugMsgDumpString("srcName",srcName)
--	self:DebugMsgDumpString("dstName",dstName)
--	self:DebugMsgDumpString("auraType",auraType)
--	self:DebugMsgDumpString("spellName",spellName)
	
	local DetectedEventStub = {
		-- event descriptors
		name = spellName,
		type = "SPELL_AURA_APPLIED_"..tostring(auraType),
		--rank = "", -- no rank known
		-- event-specific data for substitutions
		caster = srcName,
		target = dstName,
		spellid = spellId,
	}
	
	-- buffs cast on me by someone other than me are treated differently than buffs I cast on myself
	if srcName ~= UnitName("player") then
		self:DebugMsg(funcname, "not cast by you")
		DetectedEventStub.type = tostring(DetectedEventStub.type).."_FOREIGN"
	end
	
	-- process the spell
	-- this function is shared with the UNIT_SPELLCAST_SENT event handler
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:SPELL_DAMAGE(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
	-- extra parameters provided with "SPELL_" prefix
	local spellId, spellName, spellSchool = select(1, ...)
	-- extra parameters provided with "_DAMAGE" suffix
	local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(4, ...)
	-- transfer to shared function
	self:DamageEvent(eventtype, spellId, spellName, srcName, dstName, amount, overkill, school, critical)
end


function SpeakinSpell:SWING_DAMAGE(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
	-- extra parameters provided with "SWING_" prefix
	--none
	-- extra parameters provided with "_DAMAGE" suffix
	local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(1, ...)
	-- transfer to shared function
	-- NOTE: melee swings don't have a spell name or spellId
	self:DamageEvent(eventtype, nil, L["Melee Swing"], srcName, dstName, amount, overkill, school, critical)
end


function SpeakinSpell:RANGE_DAMAGE(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
	--RANGE_DAMAGE is triggered for a hunter's bow or a mage's wand, etc.
	-- extra parameters provided with "RANGE_" prefix
	local spellId, spellName, spellSchool = select(1, ...)
	-- extra parameters provided with "_DAMAGE" suffix
	local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(4, ...)
	-- transfer to shared function
	self:DamageEvent(eventtype, spellId, spellName, srcName, dstName, amount, overkill, school, critical)
end

--[[ Not ready yet
function SpeakinSpell:SPELL_MISSED(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
	--We only care about blocks/parries/etc. if it happens to the player
	--REVIEW: No, other way around... we only care if this is the player's miss, i.e. the player is the source
	if srcName ~= UnitName("player") then
		return
	end
	--extra parameters with "SPELL_" prefix
	local spellId, spellName, spellSchool = select(1, ...)
	-- extra parameters provided with "_MISSED" suffix
	local missType, amountMissed = select(4, ...)
	--This makes the event name "%2$s was ___ed by %4$s"
	local eventname = _G["ACTION_SPELL_MISSED_"..missType.."_FULL_TEXT_NO_SOURCE"]
	--Replace the regexes with the words "player" and "attack". This 
	eventname = gsub(gsub(eventname, "%4$s", PLAYER),"%2$s",ATTACK)
	--REVIEW: that looks more like a display name... what does eventname actually say now? "<spellname> was blocked by <caster>"? that doesn't seem right
	local DetectedEventStub = {
			type = "COMBAT", --REVIEW: this might want to be SPELL_MISS for special handling of display names
			
			--REVIEW: which of these generates the key? which *should* generate it? the one that includes the name of the spell would probably be ideal, because you only want to announce when Taunt misses, not regular damage spells (probably)
			name		= eventname,
			eventname	= _G[missType], -- this formats the miss type to be localized and not all caps
			
			-- I don't think this stuff is necessary, but we'll see
			-- it's needed for "My <spellname> missed!" i.e. for a Taunt
			spellid = spellId,
			spellname = spellName,
			
			-- spell/ability was cast by source on dest
			caster = srcName,
			target = dstName,
			
			-- event-specific substitions
			misstype = missType, --might as well support this in case you use a shared speech list
			damage = amountMissed, --"Dang, that <spellname> would have hit for <damage>... but I missed! ack!"
		}
		self:OnSpeechEvent( DetectedEventStub )
end
]]

function SpeakinSpell:DamageEvent(eventtype, spellId, spellName, srcName, dstName, amount, overkill, school, critical) 
	local funcname = "DamageEvent"
	
	-- we only care about damage done by me
	if srcName ~= UnitName("player") then
		return
	end

--	self:DebugMsg(funcname, "eventtype:"..tostring(eventtype))
--	self:DebugMsg(funcname, "overkill:"..tostring(overkill))
--	self:DebugMsg(funcname, "critical:"..tostring(critical))
	
	if critical then
		local DetectedEventStub = {
			type = "COMBAT",
			
			name		= L["Critical Strike"],
			eventname	= L["Critical Strike"],
			
			-- replace the default spellname = eventname = name logic, to provide info about the actual spell
			spellid = spellId,
			spellname = spellName,
			
			-- spell/ability was cast by source on dest
			caster = srcName,
			target = dstName,
			
			-- event-specific substitions
			damage		= amount or 0,
			overkill	= overkill or 0,
			school		= self:DamageSchoolCodeNumberToString(school), --spellSchool is the same code number
		}
		-- override the display link format used by the Report Detected Speech Events diagnostic feature, to achieve this results:
		-- self:Print( "Combat Event: Critical Strike: [Seal of Righteousness]" )
		DetectedEventStub.displaylink = self:FormatSubs( "<eventtypeprefix><eventname>: <spelllink>", DetectedEventStub)
		
		self:OnSpeechEvent( DetectedEventStub )
	end
	
	--TODOFUTURE: this is only going to catch MOST killing blows
	--	if you kill something by exactly the right amount of damage, your overkill can be 0
	--	that's extremely unlikely, but for perfection we could use UNIT_DIED or PARTY_KILL
	--	Unfortunately, both of those provide GUID parameters instead of names
	--	which is just annoying, so I'm leaving it based on overkill damage for now
	if overkill and overkill > 0 then
		local DetectedEventStub = {
			type = "COMBAT",
			
			name		= L["Killing Blow"],
			eventname	= L["Killing Blow"],
			
			-- replace the default spellname = eventname = name logic, to provide info about the actual spell
			spellid = spellId,
			spellname = spellName,
			
			-- spell/ability was cast by source on dest
			caster = srcName,
			target = dstName,
			
			-- event-specific substitions
			damage		= amount or 0,
			overkill	= overkill or 0,
			school		= self:DamageSchoolCodeNumberToString(school), --spellSchool is the same code number
		}
		-- override the display link format used by the Report Detected Speech Events diagnostic feature, to achieve this results:
		-- self:Print( "Combat Event: Critical Strike: [Seal of Righteousness]" )
		DetectedEventStub.displaylink = self:FormatSubs( "<eventtypeprefix><eventname>: <spelllink>", DetectedEventStub)
		
		self:OnSpeechEvent( DetectedEventStub )
	end
end



-- This is like RegisterEvent: set up a table mapping the eventtype to a function
SpeakinSpell.CombatLogEvents = {
	["SPELL_AURA_APPLIED"] = function(  timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		-- buff gains
		SpeakinSpell:SPELL_AURA_APPLIED(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
	end,
	["SPELL_AURA_REFRESH"] = function(  timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		-- buff timer refreshed (Recast on you without wearing off all the way first)
		-- NOTE: the function is called SPELL_AURA_APPLIED because it's shared, but still pass eventtype=SPELL_AURA_REFRESH
		SpeakinSpell:SPELL_AURA_APPLIED(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
	end,
	["SPELL_DAMAGE"] = function(  timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		-- any spell or other special ability landed a hit (or crit) to deal damage
		SpeakinSpell:SPELL_DAMAGE( timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
	end,
	["SWING_DAMAGE"] = function(  timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		-- melee swings (white hits)
		SpeakinSpell:SWING_DAMAGE( timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
	end,
	["RANGE_DAMAGE"] = function(  timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		-- white hits with a ranged attack, such as a hunter's bow, or a mage's wand, etc.
		SpeakinSpell:RANGE_DAMAGE( timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
	end,
--	["SPELL_MISSED"] = function(  timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		-- Special ability misses, is blocked, absorbed, parried, etc,
--		SpeakinSpell:SPELL_MISSED( timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...) 
--	end,
}

function SpeakinSpell:COMBAT_LOG_EVENT_UNFILTERED(_,timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	--self:DebugMsg("COMBAT_LOG_EVENT_UNFILTERED",tostring(eventtype))
	
	local func = SpeakinSpell.CombatLogEvents[eventtype]
	if func then
		func(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	end
end


function SpeakinSpell:UNIT_THREAT_LIST_UPDATE(_,mob)
	local funcname = "UNIT_THREAT_LIST_UPDATE"
	self:DebugMsg(funcname, "mob:"..tostring(mob))
	-- Omen comments say the mob will only be "target" or "focus"
	-- that seems to be true
	if not mob then
		-- we get this event at login with mob=nil, which causes UnitDetailedThreatSituation to throw an error
		return
	end
	local hasAggro,_,_,_,_ = UnitDetailedThreatSituation("player", mob);
	local situation = ""
	if self.RuntimeData.hasAggro and (not hasAggro) then
		--If you were tanking before and now you don't, do lost aggro event
		situation = L["I Lost Aggro"]
		self.RuntimeData.hasAggro = false
		self:DebugMsg(funcname, "Signal System Event: Losing Aggro")
	elseif (not self.RuntimeData.hasAggro) and hasAggro then
		--If you weren't tanking before and now you are, do the gain aggro event
		situation = L["I Gained Aggro"]
		self.RuntimeData.hasAggro = true
		self:DebugMsg(funcname, "Signal System Event: Gaining Aggro")
	else
		-- aggro has stayed the same
		return
	end
	local DetectedEventStub = {
		-- event descriptors
		type = "COMBAT",
		name = situation,
		-- event-specific data for substitutions
		caster = UnitName(mob),
		target = UnitName("player"),
	}
	self:OnSpeechEvent( DetectedEventStub )
end

function SpeakinSpell:UNIT_SPELLCAST_StandardHandler(event, caster, target, spellname, spellrank)
	local funcname = event

--	self:DebugMsg(funcname,"(caster, spellname, spellrank, target)")
--	self:DebugMsgDumpString("event",event) -- the event name is already the funcname
--	self:DebugMsgDumpString("caster",caster)
--	self:DebugMsgDumpString("spellname",spellname)
--	self:DebugMsgDumpString("spellrank",spellrank)
--	self:DebugMsgDumpString("target",target)
	
	-- only speak for spells cast by the player, or our pet, not anyone else
	--NOTE: UNIT_SPELLCAST_SUCCEEDED appears to be the only pet event that actually occurs in WoW 3.3.5
	local isPetAction = false
	if caster == "player" then
		caster = UnitName("player")
	elseif caster == "pet" then --it's not UnitName("pet")
		isPetAction = true
	else
		--self:DebugMsg(funcname,"caster is not the player or pet")
		return
	end
	
	-- process the spell
	local DetectedEventStub = {
		-- event descriptors
		type = event,
		name = spellname,
		rank = spellrank,
		-- event-specific data for substitutions
		caster = caster,
		target = target,
		spellid = self:GetSpellID(spellname, spellrank),
	}
	if isPetAction then
		DetectedEventStub.type = "PET"..event
	end
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:UNIT_SPELLCAST_SENT(event, caster, spellname, spellrank, target)
	--subsequent UNIT_SPELLCAST notifications don't include this target info
	-- for some spells like arcane missiles, this target applies
	-- for others like summoning stones, there is no preceding UNIT_SPELLCAST_SENT, it just goes straight to channeling
	-- so this should not be used lightly as a replacement for <target> in all cases, but it does become useful to know
	-- this supports <lasttarget> and 
	--REVIEW: should this only apply to spells cast by the player? this is probably catching all spell casts sent by anyone
	self.RuntimeData.LastSpellcastSentTarget = target
	self.RuntimeData.LastInterrupt = nil -- new spell cast can be interrupted again - see UNIT_SPELLCAST_INTERRUPTED
	self:UNIT_SPELLCAST_StandardHandler(event, caster, target, spellname, spellrank)
end

function SpeakinSpell:UNIT_SPELLCAST_INTERRUPTED(event, caster, spellname, spellrank)
	-- these messages can be redundant for a single interrupt notified 3 times
	if self.RuntimeData.LastInterrupt == spellname then
		self:DebugMsg(nil,"suppressed redundant UNIT_SPELLCAST_INTERRUPTED for "..tostring(spellname))
		return
	end
	self.RuntimeData.LastInterrupt = spellname
	-- REVIEW: is it really appropriate to assume that the unknown target of this interrupted spell is the self.RuntimeData.LastSpellcastSentTarget?
	self:UNIT_SPELLCAST_StandardHandler(event, caster, self.RuntimeData.LastSpellcastSentTarget, spellname, spellrank)
end

-- REVIEW: is it really appropriate to assume that the unknown target of this failed spell 
--		is the self.RuntimeData.LastSpellcastSentTarget?
--		not all events are always preceded by UNIT_SPELLCAST_SENT -- cast in point: summoning stone effect
function SpeakinSpell:UNIT_SPELLCAST_FAILED(event, caster, --[[target unknown, --]]                  spellname, spellrank)
	self:UNIT_SPELLCAST_StandardHandler    (event, caster, self.RuntimeData.LastSpellcastSentTarget, spellname, spellrank)
	--self.RuntimeData.LastSpellcastSentTarget = nil
end


-- NOTE: the target is unknown for UNIT_SPELLCAST_CHANNEL_START / STOP
--		The target of the last UNIT_SPELLCAST_SENT (<lasttarget>) is valid for some spells like arcane missiles
--		However, in the case of the summoning stone effect, and maybe other spells, 
--		the channeling event is not preceded by UNIT_SPELLCAST_SENT, so that value is incorrect
function SpeakinSpell:UNIT_SPELLCAST_CHANNEL_START  (event, caster,      spellname, spellrank)
	             self:UNIT_SPELLCAST_StandardHandler(event, caster, nil, spellname, spellrank)
end

function SpeakinSpell:UNIT_SPELLCAST_CHANNEL_STOP   (event, caster,      spellname, spellrank)
	             self:UNIT_SPELLCAST_StandardHandler(event, caster, nil, spellname, spellrank)
end

-- REVIEW: is it really appropriate to assume that the unknown target of this stopped spell 
--		is the self.RuntimeData.LastSpellcastSentTarget?
--		not all events are always preceded by UNIT_SPELLCAST_SENT -- cast in point: summoning stone effect
function SpeakinSpell:UNIT_SPELLCAST_STOP           (event, caster, --[[target unknown, --]]                  spellname, spellrank)
	             self:UNIT_SPELLCAST_StandardHandler(event, caster, self.RuntimeData.LastSpellcastSentTarget, spellname, spellrank)
end

-- REVIEW: is it really appropriate to assume that the unknown target of this stopped spell 
--		is the self.RuntimeData.LastSpellcastSentTarget?
--		not all events are always preceded by UNIT_SPELLCAST_SENT -- cast in point: summoning stone effect
function SpeakinSpell:UNIT_SPELLCAST_SUCCEEDED      (event, caster, --[[target unknown, --]]                  spellname, spellrank)
	             self:UNIT_SPELLCAST_StandardHandler(event, caster, self.RuntimeData.LastSpellcastSentTarget, spellname, spellrank)
end


function SpeakinSpell:PLAYER_DEAD(event)
	local funcname = "PLAYER_DEAD"

	-- Blizzard apparently has a bug that is triggering this event multiple times
	-- so use this flag to suppress redundant PLAYER_DEAD events until PLAYER_ALIVE/PLAYER_UNGHOST
	if self.RuntimeData.dead then
		self:DebugMsg(funcname, "suppressing redundant PLAYER_DEAD event (Blizzard API bug)")
		return
	end
	self.RuntimeData.dead = true
	
	local DetectedEventStub = {
		-- event descriptors
		type = "COMBAT",
		name = L["I Died"],
		--rank = spellrank,
		-- event-specific data for substitutions
		--caster = caster,
		target = UnitName("player"),
		--spellid = self:GetSpellID(spellname, spellrank),
	}
	self:OnSpeechEvent( DetectedEventStub )
end


-- Blizzard apparently has a bug that is triggering this event multiple times
-- so use this flag to suppress redundant PLAYER_DEAD events until PLAYER_ALIVE/PLAYER_UNGHOST

--[[
PLAYER_ALIVE
Fired when the player:

    * Releases from death to a graveyard.
    * Accepts a resurrect before releasing their spirit. 

Does not fire when the player is alive after being a ghost. PLAYER_UNGHOST is triggered in that case. 

PLAYER_UNGHOST
Fired when the player is alive after being a ghost. Called after one of:

    * Performing a successful corpse run and the player accepts the 'Resurrect Now' box.
    * Accepting a resurrect from another player after releasing from a death.
    * Zoning into an instance where the player is dead.
    * When the player accept a resurrect from a Spirit Healer. 

The player is alive when this event happens. Does not fire when the player is resurrected before releasing. PLAYER_ALIVE is triggered in that case. 
--]]

-- TODOFUTURE: Combat Event: I'm Alive Again
--	it's tricky because of the weird overlap

function SpeakinSpell:PLAYER_ALIVE(event)
	--NOTE: you might actually still be dead, and released to a graveyard as a ghost
	--		but the only use of this flag is to suppress redundant PLAYER_DEAD notifications
	--		which does not seem to occur after releasing to a GY, so this is adequate
	self.RuntimeData.dead = false
end

function SpeakinSpell:PLAYER_UNGHOST(event)
	self.RuntimeData.dead = false
end


---------------------------------------------------------------------------
-- ENTERING AND EXITING COMBAT
---------------------------------------------------------------------------
-- NOTE: PLAYER_ENTER_COMBAT and PLAYER_LEAVE_COMBAT are not what they sound like
--		Those 2 events are auto-attack on/off notifications
--		To detect when the combat flag goes on and off from getting/losing aggro
--		which is what we generally mean by "entering combat" and "exiting combat"
--		we must check for Regen enabled/disabled, which is our only valid notification
--		see also: http://www.wowwiki.com/Events/Combat


function SpeakinSpell:PLAYER_REGEN_DISABLED()
	local funcname = "PLAYER_REGEN_DISABLED"

	-- update combat status flags for "limit once per combat" feature
	self.RuntimeData.InCombat = true
	self:ResetOncePerCombatFlags()

	-- Signal the Entering Combat event
	self:DebugMsg(funcname, "Signal System Event: Entering Combat")
	local DetectedEventStub = {
		-- event descriptors
		name = L["Entering Combat"],
		type = "COMBAT",
		-- event-specific data for substitutions
		-- None
	}
	self:OnSpeechEvent( DetectedEventStub ) 
end


function SpeakinSpell:PLAYER_REGEN_ENABLED()
	local funcname = "PLAYER_REGEN_ENABLED"

	-- update combat status flags for "limit once per combat" feature
	self.RuntimeData.InCombat = false
	self:ResetOncePerCombatFlags()
	
	-- we can't have aggro on the current target now that we're out of combat
	-- if we deselected our target before exiting combat, the UNIT_THREAT_LIST_UPDATE won't tell us that we lost aggro
	self.RuntimeData.hasAggro = false

	-- Signal the Exiting Combat event
	self:DebugMsg(funcname, "Signal System Event: Exiting Combat")
	local DetectedEventStub = {
		-- event descriptors
		name = L["Exiting Combat"],
		type = "COMBAT",
		-- event-specific data for substitutions
		-- None
	}
	self:OnSpeechEvent( DetectedEventStub ) 
end


---------------------------------------------------------------------------
-- MOVING TO A DIFFERENT ZONE OR REGION
---------------------------------------------------------------------------


function SpeakinSpell:OnZoneChange(minoronly)
	local funcname = "OnZoneChange"

	-- Signal the zone change event
	self:DebugMsg(funcname, "Signal System Event: Zone Changed, minoronly="..tostring(minoronly))
	local DetectedEventStub = {
		-- event descriptors
		name = L["Changed Zone"],
		rank = "",
		type = "EVENT",
		-- treat these special events as cast by the player on himself
		caster = UnitName("player"),
		target = UnitName("player"),
		-- event-specific data for substitutions
		-- None
	}
	
	if minoronly then
		DetectedEventStub.name = L["Changed Sub-Zone"]
	end
	
	self:OnSpeechEvent( DetectedEventStub ) 
end


--for subzone changes -- does not appear to be needed
--[[
function SpeakinSpell:MINIMAP_ZONE_CHANGED()
	local funcname = "MINIMAP_ZONE_CHANGED"
	self:DebugMsg(funcname, "entry")
	
	self:OnZoneChange(true)
end
--]]

--for subzone changes inside an instance
function SpeakinSpell:ZONE_CHANGED_INDOORS()
	local funcname = "ZONE_CHANGED_INDOORS"
	self:DebugMsg(funcname, "entry")
	
	self:OnZoneChange(true)
end

--for large scale zone changes
function SpeakinSpell:ZONE_CHANGED_NEW_AREA()
	local funcname = "ZONE_CHANGED_NEW_AREA"
	self:DebugMsg(funcname, "entry")
	
	self:OnZoneChange(false)
end

--covers both small and large scale zone changes?
function SpeakinSpell:ZONE_CHANGED()
	local funcname = "ZONE_CHANGED"
	self:DebugMsg(funcname, "entry")
	
	self:OnZoneChange(true)
end


---------------------------------------------------------------------------
-- PARSE CHAT MESSAGES
---------------------------------------------------------------------------


--[[
"CHAT_MSG_WHISPER"
	Category: Communication
  	

Fired when a whisper is received from another player.

The rest of the arguments appear to be nil

arg1 
    Message received 
arg2 
    Author 
arg3 
    Language (or nil if universal, like messages from GM) (always seems to be an empty string; argument may have been kicked because whispering in non-standard language doesn't seem to be possible [any more?]) 
arg6 
    status (like "DND" or "GM") 
arg7 
    (number) message id (for reporting spam purposes?) (default: 0) 
arg8 
    (number) unknown (default: 0) 
--]]
function SpeakinSpell:CHAT_MSG_WHISPER(event, msg, author, language, status, id, ...)
	-- Chat Event: Whispered While In-Combat
	if	self.RuntimeData.InCombat		and 
		type(author) == "string"		and
		author ~= UnitName("player")	then

		local DetectedEventStub = {
			type = "CHAT",
			name = L["Whispered While In-Combat"],
			caster = author, -- the name of the player who whispered to you
			target = UnitName("player"), -- the target of the whisper is you, the player
			-- event-specific substitution
			text = msg -- the contents of the message that was whispered to you
		}
		self:OnSpeechEvent( DetectedEventStub )
	end
	
	-- TODOFUTURE: more whisper-response based features could go here
	--	allow other people to trigger /ss commands by whispering to you, similar to auctioneer's whisper activated price lookup feature
	--	auto-advertise in response to "what addon is that?"
end


--[[
"CHAT_MSG_GUILD"
	Category: Communication,Guild
  	
Fired when a message is sent or received in the Guild channel.

arg1 
    Message that was sent 
arg2 
    Author 
arg3 
    Language that the message was sent in 
--]]
function SpeakinSpell:CHAT_MSG_GUILD(event, ...)
	-- "Chat Event: A Guild Member said 'ding'"
	-- match whole word, not "raiding" or other substring match
	if self:ContainsWholeWord( arg1, strsub(EMOTE389_CMD1,2)) then --EMOTE389_CMD1 is "/ding"
		local DetectedEventStub = {
			type = "CHAT",
			name = L[
[[A guild member said "ding"]]
			],
			caster = arg2,
			target = SpeakinSpell:GetGuildName(),
		}
		self:OnSpeechEvent( DetectedEventStub )
	end
end


function SpeakinSpell:CHAT_MSG_PARTY(event, ...)
	-- "Chat Event: A Party Member said 'ding'"
	-- match whole word, not "raiding" or other substring match
	if self:ContainsWholeWord( arg1, strsub(EMOTE389_CMD1,2)) then --EMOTE389_CMD1 is "/ding"
		local DetectedEventStub = {
			type = "CHAT",
			name = L[
[[A party member said "ding"]]
			],
			caster = arg2,
			--target = SpeakinSpell:GetGuildName(), -- assume default target logic
		}
		self:OnSpeechEvent( DetectedEventStub )
	end
end


---------------------------------------------------------------------------
-- ANNOUNCING /FOLLOW
---------------------------------------------------------------------------

-- AUTOFOLLOW_END doesn't indicate the name of the target
-- so we store that name when we get AUTOFOLLOW_BEGIN
-- we sometimes see AUTOFOLLOW_END 3 times in a row for the same ending of auto-follow
-- so we also use the name as a flag to link one end to one begin


function SpeakinSpell:AUTOFOLLOW_BEGIN(event, unit)
--	local funcname = "AUTOFOLLOW_BEGIN"
--	self:DebugMsg(funcname, "unit:"..tostring(unit))
	
	self.RuntimeData.AutoFollowTarget = unit -- saved for AUTOFOLLOW_END
	local DetectedEventStub = {
		type = "EVENT",
		name = L["Begin /follow"],
		target = unit,
	}
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:AUTOFOLLOW_END(event, ...)
--	local funcname = "AUTOFOLLOW_END"
--	self:DebugMsg(funcname, "AutoFollowTarget:"..tostring(self.RuntimeData.AutoFollowTarget))
	
	if self.RuntimeData.AutoFollowTarget then
		local DetectedEventStub = {
			type = "EVENT",
			name = L["End /follow"],
			target = self.RuntimeData.AutoFollowTarget,
		}
		self.RuntimeData.AutoFollowTarget = nil
		self:OnSpeechEvent( DetectedEventStub )
	end
end


---------------------------------------------------------------------------
-- ACHIEVEMENTS
---------------------------------------------------------------------------

function SpeakinSpell:ACHIEVEMENT_EARNED(event, AchievementID)
	local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo( AchievementID )
	local DetectedEventStub = {
		type = "ACHIEVEMENT",
		name = COMBATLOG_FILTER_STRING_ME, -- DisplayName = "Achievement Earned by <name>"
		-- NOTE: we don't want the name of this achievement to be in the type or name of this stub, defined above, 
		--		because we want ALL differently-named achievements to share the same speech event settings
		--		so we'll use an event-specific custom data name to support substitution the name of this achievement in the speech
		achievement = Name,
		-- and the achievement link also relays the achievement name, via the standard <spelllink> substitution
		spelllink = GetAchievementLink( AchievementID ),
		-- and standard meaning for target and caster OF THE EVENT
		target = UnitName("player"),
		caster = UnitName("player"),
		-- and let's include (most of) the rest of the achievement info for substitutions, why not?
		points = Points,
		desc = Description,
		reward = RewardText,
	}
	-- Blizzard Bug: GetAchievementLink() returns "[Achievement]!" with an extra exclamation point
	DetectedEventStub.spelllink = string.sub(DetectedEventStub.spelllink, -1)
	self:OnSpeechEvent( DetectedEventStub )
end


--[[
from wowwiki.com, plus added comments to fill in missing details

"CHAT_MSG_ACHIEVEMENT"
	Category: Communication,Guild,Achievements
  	

Fired when a player in your vicinity completes an achievement.

arg1 (ChatMessage)
    The full body of the broadcast message. ("%s has earched the achievement [clickable link]")
arg2, arg5 (EarnedBy)
    The name of player who has just completed the achievement. 
arg7, arg8 
    Some integer. (Ris: the achievement ID???)
--]]
function SpeakinSpell:CHAT_MSG_ACHIEVEMENT(event, ChatMessage, EarnedBy, ...)
	if EarnedBy == UnitName("player") then -- don't congratulate myself (we DO get this message for our own achievements)
		return
	end
	local ndx = string.find(ChatMessage, "|") -- find the clickable link in the achievement message
	local achievement = string.sub(ChatMessage, ndx, string.len(ChatMessage))
	local DetectedEventStub = {
		type = "ACHIEVEMENT",
		name = L["Someone Nearby"], -- DisplayName = "Achievement Earned by <name>"
		-- NOTE: we don't want the name of this achievement to be in the type or name of this stub, defined above, 
		--		because we want ALL differently-named achievements to share the same speech event settings
		--		so we'll use an event-specific custom data name to support substitution the name of this achievement in the speech
		--TODOFUTURE: ? parse this for the achievement name or link instead of the full chat message text ?
		--	for now, providing <achievement> and <desc> as both the complete message, for similarity to ACHIEVEMENT_EARNED
		achievement = achievement, 
		desc = achievement,
		spelllink = achievement,
		-- and standard meaning for target and caster OF THE EVENT (the player who earned the achievement)
		target = EarnedBy,
		caster = EarnedBy,
	}
	self:OnSpeechEvent( DetectedEventStub )
end


--[[
"CHAT_MSG_GUILD_ACHIEVEMENT" (same as CHAT_MSG_ACHIEVEMENT)
	Category: Communication,Guild,Achievements
  	
Fired when a guild member completes an achievement.

arg1 
    The full body of the broadcast message. 
arg2, arg5 
    The name of player who has just completed the achievement. 
arg7, arg8, arg11 
    Some integer that (but not the achievement ID, or the total number of achievement points for the player; this seems to increment if two consecutive achievements are posted (needs to be verified)). 
--]]
function SpeakinSpell:CHAT_MSG_GUILD_ACHIEVEMENT(event, ChatMessage, EarnedBy, ...)
	--NOTE: EarnedBy will not be the player
	local ndx = string.find(ChatMessage, "|") -- find the clickable link in the achievement message
	local achievement = string.sub(ChatMessage, ndx, string.len(ChatMessage))
	local DetectedEventStub = {
		type = "ACHIEVEMENT",
		name = L["a Guild Member"], -- DisplayName = "Achievement Earned by <name>"
		-- NOTE: we don't want the name of this achievement to be in the type or name of this stub, defined above, 
		--		because we want ALL differently-named achievements to share the same speech event settings
		--		so we'll use an event-specific custom data name to support substitution the name of this achievement in the speech
		--TODOFUTURE: ? parse this for the achievement name or link instead of the full chat message text ?
		--	for now, providing <achievement> and <desc> as both the complete message, for similarity to ACHIEVEMENT_EARNED
		achievement = achievement, 
		desc = achievement,
		spelllink = achievement,
		-- and standard meaning for target and caster OF THE EVENT (the player who earned the achievement)
		target = EarnedBy,
		caster = EarnedBy,
	}
	self:OnSpeechEvent( DetectedEventStub )
end


---------------------------------------------------------------------------
-- NPC INTERACTION
---------------------------------------------------------------------------


function SpeakinSpell:GOSSIP_SHOW()
	local DetectedEventStub = {
		type = "NPC",
		name = L["Open Gossip Window"],
	}
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:BARBER_SHOP_OPEN()
	local DetectedEventStub = {
		type = "NPC",
		name = L["Enter Barber Chair"],
	}
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:BARBER_SHOP_CLOSE()
	local DetectedEventStub = {
		type = "NPC",
		name = L["Exit Barber Chair"],
	}
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:MAIL_SHOW()
	local DetectedEventStub = {
		type = "NPC",
		name = L["Open Mailbox"],
	}
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:MERCHANT_SHOW()
	local DetectedEventStub = {
		type = "NPC",
		name = L["Talk to Vendor"],
	}
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:QUEST_GREETING()
	local DetectedEventStub = {
		type = "NPC",
		name = L["Talk to Quest-Giver"],
	}
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:TAXIMAP_OPENED()
	local DetectedEventStub = {
		type = "NPC",
		name = L["Talk to Flight Master"],
	}
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:TRAINER_SHOW() -- fired for any class and profession trainers
	local DetectedEventStub = {
		type = "NPC",
		name = L["Talk to Trainer"],
	}
	self:OnSpeechEvent( DetectedEventStub )
end


---------------------------------------------------------------------------
-- MORE MISC. EVENTS
---------------------------------------------------------------------------

--[[
"PLAYER_LEVEL_UP"
	Category: Player
  	

Fired when a player levels up.

arg1 
    New player level. Note that UnitLevel("player") will most likely return an incorrect value when called in this event handler or shortly after, so use this value. 
arg2 
    Hit points gained from leveling. 
arg3 
    Mana points gained from leveling. 
arg4 
    Talent points gained from leveling. Should always be 1 unless the player is between levels 1 to 9. 
arg5 - arg9 
    Attribute score increases from leveling. Strength (5) / Agility (6) / Stamina (7) / Intellect (8) / Spirit (9). 
--]]
function SpeakinSpell:PLAYER_LEVEL_UP(event, ...)
	local DetectedEventStub = {
		type = "EVENT",
		name = PLAYER_LEVEL_UP,
	}
	self:OnSpeechEvent( DetectedEventStub )
end


--[[
"RESURRECT_REQUEST"
	Category: Death
  	
Fired when another player resurrects you

arg1 
    player name 
--]]
function SpeakinSpell:RESURRECT_REQUEST(event, caster)
	local DetectedEventStub = {
		type = "EVENT",
		name = L["a player sent me a rez"],
		caster = caster,
		target = UnitName("player"),
	}
	self:OnSpeechEvent( DetectedEventStub )
end


function SpeakinSpell:TRADE_SHOW()
	local DetectedEventStub = {
		type = "EVENT",
		name = L["Open Trade Window"],
	}
	self:OnSpeechEvent( DetectedEventStub )
end