-- Author      : RisM
-- Create Date : 9/21/2009 3:16:52 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("gui/trade.lua")

-------------------------------------------------------------------------------
-- GUI LAYOUT - TRADE BARKER
-------------------------------------------------------------------------------


SpeakinSpell.OptionsGUI.args.Trade = {
	order = 1,
	type = "group",
	name = "unused_Trade_name",
	desc = "unused_Trade_desc",
	args = {
		CaptionNormalMode = {
			order = 1,
			type = "description",
			name = "Coming Soon... randomized trade spam for all of your professional and class services, portals, LFG, LFW",
		},
	}, --end args
} --end Trade


