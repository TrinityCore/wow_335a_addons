-- Author      : RisM
-- Create Date : 9/21/2009 3:08:17 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)
local HELPFILE = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell_HELPFILE", false)

SpeakinSpell:PrintLoading("gui/help.lua")

-------------------------------------------------------------------------------
-- GUI LAYOUT - HELP MANUAL
-------------------------------------------------------------------------------


SpeakinSpell.OptionsGUI.args.HelpRoot = {
	order = 20,
	type = "group",
	name = "unused_HelpRoot_name",
	desc = "unused_HelpRoot_desc",
	args = {
		Header = {
			order = 1,
			type = "header",
			--name = L["User's Manual"].."\n",
			name = function()
				SpeakinSpell:SetLastPageViewed( "HelpRoot", L["SpeakinSpell Help"] )
				return L["User's Manual"]
			end,
		},
		Caption = {
			order = 2,
			type = "description",
			name = L["Select a topic..."].."\n",
		},
	}, --end args
} --end HelpRoot
			
			
-------------------------------------------------------------------------------
-- OPTIONS GUI FUNCTIONS - HELP PAGES
-------------------------------------------------------------------------------


function SpeakinSpell:CreateGUI_HelpPages()
	local funcname = "CreateGUI_HelpPages"
	
	-- build help pages
	for Title,HelpChapter in pairs(HELPFILE.PAGES) do
		local FrameObjectName = string.format("HelpTopic%03d",HelpChapter.order)
		
		-- setup OptionGUI object
		self.OptionsGUI.args.HelpRoot.args[FrameObjectName] = {
			type = 'group',
			order = HelpChapter.order,
			name = Title, --L["1. About SpeakinSpell"],
			desc = HelpChapter.Summary,
			args = {
				Caption = {
					order = 1,
					type = "header",
					width = "full",
					name = Title, --L["1. About SpeakinSpell"],
				},
				Content = {
					order = 2,
					type = "description",
					width = "full",
					name = HelpChapter.Contents, --help CONTENTS
				},
			}, --end args
		} --end Chapter1
	end
end


function SpeakinSpell:HelpPages_SelectTopic( index )
-- TODOFUTURE: implement this ... can't figure out how to do it so far
--	local FrameObjectName = string.format("HelpTopic%03d",index)
--	local path = self.OptionsGUI.args.HelpRoot.args[FrameObjectName]
--	LibStub("AceConfigDialog-3.0"):SelectGroup( "SpeakinSpell", path )

	-- some notes on past efforts to open direectly to the slash commands help page in previous version
	-- these notes moved here from OnSlashCommand...
	
	-- NOTE: A Blizzard Bug won't open a tier 3 page unless the tree has already been expanded to show tier 2
	--		so we'll try to show the parent frame first
	-- NOTE: I tried to work aroubd it by first opening the root page, but it stayed there
	--		I guess there's a timing issue with the windows messages (?) that makes it stick on the first one
	--		or maybe you're not allowed and it stops executing when you call this function (?)

	-- the slash commands page is now tier 2 to avoid this issue and other general bugginess with tier 3 pages
	--InterfaceOptionsFrame_OpenToCategory(HELPFILE.SLASH_COMMANDS)
end

