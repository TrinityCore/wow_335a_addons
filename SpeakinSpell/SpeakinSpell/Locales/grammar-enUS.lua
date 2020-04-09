-- Author      : RisM
-- Create Date : 9/21/2009 1:50:05 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("Locales/grammar-enUS.lua")

-------------------------------------------------------------------------------
-- GRAMMAR FUNCTIONS
-------------------------------------------------------------------------------

-- TODOFUTURE: make extensible

-- Stonarius' or Meneldill's with the proper apostrophe
function SpeakinSpell:MakePossessive(name)
	if self:EndsWith(tostring(name), "s") then
		return tostring(name).."\'" -- Stonarius'
	else
		return tostring(name).."\'s"-- Meneldill's
	end
end


function SpeakinSpell:MakeUnposessive(names)
	if self:EndsWith(tostring(names), "'s") then
		local name = string.sub(names, 0, string.len(names)-2)
		return name
	elseif self:EndsWith(tostring(names), "'") then
		local name = string.sub(names, 0, string.len(names)-1)
		return name
	else
		return nil
	end
end

