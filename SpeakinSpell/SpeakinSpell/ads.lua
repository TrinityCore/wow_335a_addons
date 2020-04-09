-- Author      : RisM
-- Create Date : 9/25/2009 6:27:48 AM


local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local DEFAULT_SPEECHES = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell_DEFAULT_SPEECHES",	false)

SpeakinSpell:PrintLoading("ads.lua")

-------------------------------------------------------------------------------
-- Advertisement System
-------------------------------------------------------------------------------


function SpeakinSpell:Advertise(Channel, msgtarget)
	-- advertise into a channel for the kind of group you are in
	-- unless a channel has been specified
	if Channel == "" or Channel == nil then
		Channel = SpeakinSpell.DEFAULTS.AD_CHANNELS[ self:GetScenarioKey() ]
	end
	
	-- select a random ad that was not used last time
	local msg = self:GetRandomTableEntry( DEFAULT_SPEECHES.ADVERTISEMENTS, self.RuntimeData.LastAd )
	
	-- remember we selected this, so we don't repeat it next time
	self.RuntimeData.LastAd = msg

	-- process substitution variables on the randomized advertisements
	local DetectedEventStub = {
		-- event descriptors
		name = "ad",
		rank = "Silly",
		-- event-specific data for substitutions
		target = msgtarget,
		caster = UnitName("player"),
		type = "MACRO"
	}
	local DetectedEvent = self:CreateDetectedEvent( DetectedEventStub )
	msg = self:FormatSubs(msg, DetectedEvent)
	
	-- speak in chat
	SendChatMessage( SpeakinSpell.URL, Channel, nil, msgtarget)	
	SendChatMessage( msg,              Channel, nil, msgtarget)
end
