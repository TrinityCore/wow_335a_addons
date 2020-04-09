-- Author      : RisM
-- Create Date : 9/21/2009 1:47:17 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("parser.lua")

-------------------------------------------------------------------------------
-- SUBSTITUTION COMMAND PARSER
-------------------------------------------------------------------------------

-- 'text' is what comes between the <brackets> not including brackets
-- This returks a SubstitutionKey (sk) object
-- at this stage, we define the following
--	sk.text - the original text
--	sk.nonpossessive - a non-possessive version of the key, or nil if N/A
--	sk.me = the "me" text if applicable, or nil if N/A
--	sk.key - a simplified data mining key that is english and non-possessive, and doesn't have the "|me" text
function SpeakinSpell:ParseSubstitutionKey( text )
	local funcname = "ParseSubstitutionKey"
	
	-- set up a SubstitutionKey object tracking data about this substitution
	local sk = {
		text = text, -- 'text' is what comes between the <brackets> not including brackets
		key = string.lower( text ) -- for starters
	}

	-- separate <key|me>
	self:ParseThirdPersonOrMe( sk )

	-- separate <key*male*female>
	self:ParseGender( sk )
	
	-- tables only store values by un-possessive key names
	-- we'll make the result possessive in UnitOrMe as applicable
	sk.nonpossessive = self:MakeUnposessive( sk.key ) --returns nil if key is not possessive
	if sk.nonpossessive then
		sk.key = sk.nonpossessive
	end
	
	-- also localize the varkey, if it's German <ziel> change to <target>
	self:UnLocalizeSubstitutionKey( sk )
	
	--self:DebugMsg(funcname, "sk.key:"..sk.key)
	return sk
end



-- check for var = "<target|___>", or localized equivalent
-- Note also: "<target's|mine>"
-- this should normally work the same as <target>
-- however if the target is the player, then show ___ instead of the player's own name
-- For example "Hey no hitting on <target|me>!" results in
-- "Hey no hitting on Fred!" if cast on Fred
-- "Hey no hitting on me!" if cast on yourself
-- this function doesn't care if the "me" part will be used
-- we're only doing string parsing at this stage
-- <key*male*female|me> is also allowed
-- exit condition:
--	sk.me = the "me" text if applicable, or nil if N/A
--	sk.key = a simplified data mining key that no longer contains "|me"
--		the sk.key may still contain gender forms "key*male*female"
function SpeakinSpell:ParseThirdPersonOrMe( sk )
	local funcname = "ParseThirdPersonOrMe"
	
	-- look for "|me" text
	local index = string.find(sk.key, L["|"])
	if not (index and (index >= 0)) then
		return
	end
	
	-- separate <key|me>
	sk.key = string.sub(sk.key, 0, index-1)
	sk.me = string.sub(sk.text, index+1) -- NOTE: use original Case Sensitive text to get "me"
	
	-- KLUGE:
	-- behavior of string.sub seems inconsistent, sometimes ndxPipe+1 gets the | character, which then throws a LUA error
	-- but ndxPipe+2 sometimes misses the first letter of "me"
	-- so we use ndxPipe+1 and check for the leading |
	while string.find(sk.me,L["|"]) do
		self:DebugMsg(funcname, "kluge used")
		sk.me = string.sub(sk.me, 2)
	end
end

function SpeakinSpell:ParseGender( sk )
	local funcname = "ParseGender"
	
	-- look for "key*male*female" text
	local index = string.find(sk.key, "*")
	if not (index and (index >= 0)) then
		return
	end
	
	-- separate <key*malefemaleorme>
	sk.key = string.sub(sk.key, 0, index-1)
	sk.malefemaleorme = string.sub(sk.text, index+1)
	
	-- separate <malefemale|me>
	index = string.find(sk.malefemaleorme, L["|"])
	if (index and (index >= 0)) then
		sk.malefemale = string.sub(sk.malefemaleorme, 0, index-1)
	else
		sk.malefemale = sk.malefemaleorme
	end
	
	-- separate <male*female>
	index = string.find(sk.malefemale, L["*"])
	if (index and (index >= 0)) then
		sk.male = string.sub(sk.malefemale, 0, index-1)
		sk.female = string.sub(sk.malefemale, index+1)
		--self:DebugMsg(funcname, string.format("male<%s> female<%s>", sk.male, sk.female))
	end
end


-- if varkey is "zauberlink" in German we want to return "spelllink" 
-- to normalize for lowercase english key names only
-- set sk.key = english version of sk.key, if applicable
function SpeakinSpell:UnLocalizeSubstitutionKey( sk )
	local EnglishKey = SpeakinSpell.SubsToEnglish[sk.key]
	if EnglishKey then
		sk.key = EnglishKey
	end
end
