-- Author      : RisM
-- Create Date : 12/3/2009 2:43:45 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)
local ResComm = LibStub:GetLibrary("LibResComm-1.0");

-------------------------------------------------------------------------------
-- REZ DETECTION
-------------------------------------------------------------------------------

-- A bridge between LibResComm-1.0 and SpeakinSpell
-- converts LibResComm events into OnSpeechEvent

-- the problem with Rez spells is that the blizz API fails to report targets
-- for players who released their spirits

-- LibResComm fixes that, and adds more


function SpeakinSpell:Rez_Init()
	-- setup for LibResComm notifications
	ResComm.RegisterCallback(self, "ResComm_ResStart");
	ResComm.RegisterCallback(self, "ResComm_ResEnd");
	ResComm.RegisterCallback(self, "ResComm_Ressed");
	ResComm.RegisterCallback(self, "ResComm_CanRes");
	ResComm.RegisterCallback(self, "ResComm_ResExpired");
end


-- event is the name of the function, i.e. "ResComm_ResStart"
function SpeakinSpell:ResComm_ResStart(event, resser, endTime, target)
	--Note: Messages comming from oRA2 will not have a reliable endTime.
	local destub = {
		type = "REZ",
		--name = L["Start Casting"], -- varies by caster/target, see below
		caster = resser,
		target = target,
		--endtime = endTime, -- this is a number value, and not very useful to our purposes
	}
	-- use the player's role in this in the event name (and thus the key)
	if		resser == UnitName("player") then
		destub.name = L["Start Casting (I'm the caster)"]
	elseif	target == UnitName("player") then
		destub.name = L["Start Casting (I'm the target)"]
	else
		destub.name = L["Start Casting (I'm not involved)"]
	end
	
	self:OnSpeechEvent( destub )
end


function SpeakinSpell:ResComm_ResEnd(event, resser, target)
	--Fired when a resurrection cast ended. This can either mean it has failed or completed. 
	--Use ResComm_Ressed to check if someone actually ressed.
	local destub = {
		type = "REZ",
		--name = L["End Casting"], -- varies by caster/target, see below
		caster = resser,
		target = target,
	}
	-- use the player's role in this in the event name (and thus the key)
	if		resser == UnitName("player") then
		destub.name = L["End Casting (I'm the caster)"]
	elseif	target == UnitName("player") then
		destub.name = L["End Casting (I'm the target)"]
	else
		destub.name = L["End Casting (I'm not involved)"]
	end
	self:OnSpeechEvent( destub )
end


function SpeakinSpell:ResComm_Ressed(event, name)
	--Fired when someone actually sees the accept resurrection box.
	local destub = {
		type = "REZ",
		name = L["Received by target"],
		caster = name, -- TODOLATER: knowing this caster is tricky
		target = name,
	}
	self:OnSpeechEvent( destub )
end


function SpeakinSpell:ResComm_CanRes(event, name)
	--Fired when someone can use a soulstone or ankh.
	local destub = {
		type = "REZ",
		name = L["Someone can self-res (SS, Ankh)"],
		caster = name,
		target = name,
	}
	self:OnSpeechEvent( destub )
end


function SpeakinSpell:ResComm_ResExpired(event, name)
	--Fired when the accept resurrection box dissapears/is declined. 
	local destub = {
		type = "REZ",
		name = L["Expired or Declined"],
		caster = name, -- TODOLATER: knowing this caster is tricky
		target = name,
	}
	self:OnSpeechEvent( destub )
end
