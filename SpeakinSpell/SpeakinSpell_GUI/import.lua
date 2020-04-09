-- Author      : RisM
-- Create Date : 9/25/2009 3:02:13 AM


local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("gui/import.lua")

-------------------------------------------------------------------------------
-- Import New Speeches GUI LAYOUT
-------------------------------------------------------------------------------

SpeakinSpell.OptionsGUI.args.ImportGUI = {
	order = 5,
	type = "group",
	name = "ImportGUI",
	desc = L["Import New Content"],
	args = {
		Header = {
			order = 1,
			type = "header",
			--name = L["Import New Data"].."\n",
			name = function()
				SpeakinSpell:SetLastPageViewed( "ImportGUI", L["Import New Data"] )
				return L["Import New Data"]
			end,
		}, --L["Import New Data"]
		Caption = {
			order = 1,
			type = "description",
			name = L[
[[New content is not currently loaded in memory.

Click the button below to continue.

This will scan for new content among:
- The default speeches that come with SpeakinSpell
- Your alternate characters
- Data collected from other SpeakinSpell users
]]
			],
			hidden = function()
				return not SpeakinSpell:IsTableEmpty( SpeakinSpell.DEFAULTS.Templates )
			end,
		},
		CheckForTemplates = {
			order = 2,
			type = "execute",
			name = L["Search for New Data"],
			desc = L["Search for new content that you are not currently using"],
			hidden = function()
				return not SpeakinSpell:IsTableEmpty( SpeakinSpell.DEFAULTS.Templates )
			end,
			func = function() SpeakinSpell:ImportGUI_OnSearchForNewData() end,
		},
		AllTemplates = { -- "All Templates"
			order = 3,
			type = "group",
			guiInline = true,
			name = L["New Content Browser"],
			hidden = function() 
				return SpeakinSpell:IsTableEmpty( SpeakinSpell.DEFAULTS.Templates ) 
			end,
			args = {
--				Description = {
--					order = 1,
--					type = "description",
--					name = L["This group includes All Templates"],
--				}, --L["This group includes All Templates\n"],
				ShowImportProgress = {
					order = 2,
					type = "toggle",
					width = "full",
					name = L["Show Import Progress"],
					desc = L["Report import processing results in the chat frame"],
					get = function() return SpeakinSpellSavedData.ShowImportProgress end,
					set = function(_, value) SpeakinSpellSavedData.ShowImportProgress = value end,
				}, -- [X] L["Show Import Progress"]
				GetAll = {
					order = 3,
					type = "execute",
					name = tostring(SpeakinSpell.Colors.ImportNewData.USE)..L["Use All"],
					desc = L["Import all content from all templates"],
					func = function() SpeakinSpell:ImportGUI_ImportAllTemplates() end,
					hidden = function()
						return SpeakinSpell:IsTableEmpty( SpeakinSpell.DEFAULTS.Templates )
					end,
				}, --L["Import All Templates"],
				DeleteAll = {
					order = 4,
					type = "execute",
					name = tostring(SpeakinSpell.Colors.ImportNewData.GREY)..L["Hide All"],
					desc = L["Hide all remaining new content and unload it from memory"],
					func = function() SpeakinSpell.DEFAULTS.Templates = nil end,
					hidden = function()
						return SpeakinSpell:IsTableEmpty( SpeakinSpell.DEFAULTS.Templates )
					end,
				},
				SelectTemplate = {
					order = 5,
					type = "select",
					width = "full",
					name = L["Select a Content Pack"],
					desc = L["Each of these packs contain new content which you might enjoy using in SpeakinSpell"],
					values = function()
						local values = {}
						for key,Template in pairs( SpeakinSpell.DEFAULTS.Templates ) do
							values[key] = Template.name
						end
						return values
					end,
					get = function() return  SpeakinSpell:ImportGUI_OnTemplateSelect("GET",nil) end,
					set = function(_, value) SpeakinSpell:ImportGUI_OnTemplateSelect("SET",value) end,
				}, --L["Select a Template"]
				Gap = {
					order = 6,
					type = "description",
					name = "\n",
				},
				SelectedTemplate = { -- i.e. "MagePortals (Alliance)"
					order = 7,
					type = "group",
					guiInline = true,
					name = function() 
						return L["Import From: "] .. tostring(SpeakinSpellSavedData.Colors.SelectedItem) .. SpeakinSpell:ImportGUI_GetSelectedTemplateName() 
					end,
					args = {
						Description = {
							order = 1,
							type = "description",
							name = function() return "\n"..SpeakinSpell:ImportGUI_GetSelectedTemplateDesc().."\n" end,
						}, -- i.e. "Mage Portal Announcements for Alliance Cities"
						GetAll = {
							order = 2,
							type = "execute",
							name = tostring(SpeakinSpell.Colors.ImportNewData.USE)..L["Use All"],
							desc = L["Import all new content from the selected content pack"],
							func = function() SpeakinSpell:ImportGUI_ImportOneSelectedTemplate() end,
						}, --L["Import Whole Template"]
						DeleteAll = {
							order = 3,
							type = "execute",
							name = tostring(SpeakinSpell.Colors.ImportNewData.GREY)..L["Hide All"],
							desc = L["Hide all remaining new content in the selected content pack and unload it from memory"],
							func = function() 
								local Template = SpeakinSpell:ImportGUI_GetSelectedTemplate()
								SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
							end,
						},
						Gap = {
							order = 4,
							type = "description",
							name = "\n",
							hidden = function() 
								local EventTable = SpeakinSpell:ImportGUI_GetSelectedEventTable()
								return SpeakinSpell:IsTableEmpty( EventTable )
							end,
						},
						EventsGroup = { --L["Import Events"]
							order = 5,
							type = "group",
							guiInline = true,
							name = L["Import Events"],
							hidden = function() 
								local EventTable = SpeakinSpell:ImportGUI_GetSelectedEventTable()
								return SpeakinSpell:IsTableEmpty( EventTable )
							end,
							args = {
--								Description = {
--									order = 1,
--									type = "description",
--									name = function() return SpeakinSpell:ImportGUI_GetSelectedTemplateDesc().."\n" end,
--								}, -- i.e. "Mage Portal Announcements for Alliance Cities"
								GetAll = {
									order = 2,
									type = "execute",
									name = tostring(SpeakinSpell.Colors.ImportNewData.USE)..L["Use All"],
									desc = L["Import all speech events, and their speeches, for the selected content pack"],
									func = function() SpeakinSpell:ImportGUI_ImportAllEvents() end,
								}, --L["Import All Speech Events for the Selected Template"]
								DeleteAll = {
									order = 3,
									type = "execute",
									name = tostring(SpeakinSpell.Colors.ImportNewData.GREY)..L["Hide All"],
									desc = L["Hide all remaining speech events for the selected content pack, and unload them from memory"],
									func = function()
										local Template = SpeakinSpell:ImportGUI_GetSelectedTemplate()
										Template.Content.EventTable = nil
										if SpeakinSpell:IsTableEmpty( Template.Content ) then
											SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
										end
									end,
								},
--								Gap = {
--									order = 4,
--									type = "description",
--									name = "\n",
--								},
								EventSelect = {
									order = 5,
									type = "select",
									width = "full",
									name = L["Select a Speech Event"],
									desc = L["Select a spell from the list to configure the random announcements for that spell."],
									values = function()
										local values = {}
										local EventTable = SpeakinSpell:ImportGUI_GetSelectedEventTable()
										if not EventTable then
											return values
										end
										for key,ete in pairs( EventTable ) do
											values[key] = SpeakinSpell:FormatDisplayName( ete.DetectedEvent )
										end
										return values
									end,
									get = function()
										SpeakinSpell:ImportGUI_ValidateSelectedEvent()
										return SpeakinSpell.RuntimeData.OptionsGUIStates.ImportGUI.SelectedEvent
									end,
									set = function(_, value)
										SpeakinSpell.RuntimeData.OptionsGUIStates.ImportGUI.SelectedEvent = value
									end,
								}, --L["Select a Speech Event"]
								SelectedEvent = {
									order = 6,
									type = "group",
									name = function()
										local DetectedEvent = SpeakinSpell:ImportGUI_GetSelectedDetectedEvent()
										local DisplayNameFormat = {
											BaseColor = SpeakinSpellSavedData.Colors.SelectedItem,
										}
										return L["Selected Event: "] .. SpeakinSpell:FormatDisplayName( DetectedEvent, DisplayNameFormat )
									end,
									args = {
										GetAllSpeeches = {
											order = 1,
											type = "execute",
											name = tostring(SpeakinSpell.Colors.ImportNewData.USE) .. L["Use All"],
											desc = L["Import all speeches for the selected event"],
											func = function() SpeakinSpell:ImportGUI_ImportAllSpeeches() end,
										}, -- L["Import All speeches for the Selected Speech Event"]
										DeleteAll = {
											order = 3,
											type = "execute",
											name = tostring(SpeakinSpell.Colors.ImportNewData.GREY)..L["Hide All"],
											desc = L["Hide all remaining speeches for the selected event, and unload the selected event template from memory"],
											func = function()
												SpeakinSpell:ImportGUI_OnClickDeleteSelectedEvent()
											end,
										},
										-- CreateGUI_AddSpeechBoxes will add more controls per speech
										-- local args = SpeakinSpell.OptionsGUI.args.ImportGUI.args.AllTemplates.args.SelectedTemplate.args.EventsGroup.args
										-- args["Speech%02d"] = { group }
									},
								},
							},
						}, -- L["Import Events"]
						Gap2 = {
							order = 7,
							type = "description",
							name = "\n",
							hidden = function() 
								local RandomSubs = SpeakinSpell:ImportGUI_GetSelectedRandomSubs()
								return SpeakinSpell:IsTableEmpty( RandomSubs )
							end,
						},
						RandomSubsGroup = { --L["Import Random Substitutions"]
							order = 8,
							type = "group",
							guiInline = true,
							name = L["Import Random Substitutions"],
							hidden = function() 
								local RandomSubs = SpeakinSpell:ImportGUI_GetSelectedRandomSubs()
								return SpeakinSpell:IsTableEmpty( RandomSubs )
							end,
							args = {
--								Description = {
--									order = 1,
--									type = "description",
--									name = function() return SpeakinSpell:ImportGUI_GetSelectedTemplateDesc() end,
--								}, -- i.e. "All <randomsubs> for MagePortals (Alliance)"
								GetAll = {
									order = 2,
									type = "execute",
									name = tostring(SpeakinSpell.Colors.ImportNewData.USE)..L["Use All"],
									desc = L["Import all <randomsub> word lists for the selected content pack"],
									func = function() SpeakinSpell:ImportGUI_ImportAllRandomSubs() end,
								}, --L["Import All <randomsubs>"]
								DeleteAll = {
									order = 3,
									type = "execute",
									name = tostring(SpeakinSpell.Colors.ImportNewData.GREY)..L["Hide All"],
									desc = L["Hide all <randomsub> word lists for the selected content pack, and unload them from memory"],
									func = function()
										local Template = SpeakinSpell:ImportGUI_GetSelectedTemplate()
										Template.Content.RandomSubs = nil
										if SpeakinSpell:IsTableEmpty( Template.Content ) then
											SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
										end
									end,
								},
								Gap = {
									order = 4,
									type = "description",
									name = "",
									width = "full",
								},
								RandomSubSelect = {
									order = 5,
									type = "select",
									--width = "full",
									name = L["Select a <substitution>"],
									desc = L["Select a Randomized Substitution\n\nThese substitutions may be used in speeches when announcing events, and a random result from the list below will be selected."],
									values = function()
										local values = {}
										local RandomSubs = SpeakinSpell:ImportGUI_GetSelectedRandomSubs()
										if not RandomSubs then
											return values
										end
										for key,_ in pairs( RandomSubs ) do
											values[key] = "<"..key..">"
										end
										return values
									end,
									get = function() return  SpeakinSpell:ImportGUI_OnRandomSubSelect("GET",nil) end,
									set = function(_, value) SpeakinSpell:ImportGUI_OnRandomSubSelect("SET",value) end,
								}, --L["Select a <substitution>"]
--								Gap = {
--									order = 6,
--									type = "description",
--									name = "",
--									width = "full",
--								},
								SelectedRandomSub = {
									type = "group",
									name = function()
										local subs = {
											colorcode = tostring(SpeakinSpellSavedData.Colors.SelectedItem),
											substitution = L["<"]..tostring(SpeakinSpell.RuntimeData.OptionsGUIStates.ImportGUI.SelectedRandomSub)..L[">"],
										}
										return SpeakinSpell:FormatSubs( L["Import words for: <colorcode><substitution>"], subs )
									end,
									order = 7,
									args = {
										GetAllWords = {
											order = 1,
											type = "execute",
											name = tostring(SpeakinSpell.Colors.ImportNewData.USE) .. L["Use All"],
											desc = L["Import all \"words\" for the selected <randomsub>"],
											func = function() SpeakinSpell:ImportGUI_ImportAllRandomWords() end,
										}, --L["Import All Words"]
										DeleteAll = {
											order = 2,
											type = "execute",
											name = tostring(SpeakinSpell.Colors.ImportNewData.GREY)..L["Hide All"],
											desc = L["Hide all remaining \"words\" for the selected <randomsub>, and unload the selected <randomsub> template from memory"],
											func = function()
												SpeakinSpell:ImportGUI_OnClickDeleteAllWords()
											end,
										},
										-- CreateGUI_AddRandomWordBoxes will add more controls per speech
										-- local args = SpeakinSpell.OptionsGUI.args.ImportGUI.args.AllTemplates.args.SelectedTemplate.args.RandomSubsGroup.args
										-- args["Word%02d"] = { group }
									},
								},
							},
						}, -- L["Import Random Substitutions"]
					},
				},  -- i.e. "MagePortals (Alliance)"
			},
		},
	},
} -- end SpeakinSpell.OptionsGUI.args.ImportGUI



-------------------------------------------------------------------------------
-- CreateGUI - Import Templates GUI
-------------------------------------------------------------------------------


function SpeakinSpell:CreateGUI_AddSpeechBoxes()
	local funcname = "CreateGUI_AddSpeechBoxes"
	
	-- Add Random Speech boxes
	local args = SpeakinSpell.OptionsGUI.args.ImportGUI.args.AllTemplates.args.SelectedTemplate.args.EventsGroup.args.SelectedEvent.args
	for index=1,SpeakinSpell.MAX.MESSAGES_PER_SPELL,1 do
		local frameName = string.format( "Speech%02d", index )
		local subs = {
			number = index,
			red = SpeakinSpell.Colors.ImportNewData.RED,
			normalcolor = "|r",
		}
		args[frameName] = { -- "Random Speech 1" (group)
			order = index + 100,
			type = "group",
			name = SpeakinSpell:FormatSubs( L["Random Speech <number>"], subs ),
			hidden = function()
				local speech = self:ImportGUI_GetSpeech( index )
				return (speech == nil) or (speech == "")
			end,
			args = {
				Speech = {
					order = 1,
					type = "description",
					name = function() return SpeakinSpell:ImportGUI_GetSpeech( index ) end,
					hidden = function()
					end,
				}, -- "Foo",
				Use = {
					order = 2,
					type = "execute",
					name = tostring(SpeakinSpell.Colors.ImportNewData.USE)..USE,
					desc = L["Use this Random Speech for the selected Event"],
					func = function() SpeakinSpell:ImportGUI_ImportSpeech( index ) end,
				}, -- "Use This Speech",
				Delete = {
					order = 3,
					type = "execute",
					name = tostring(SpeakinSpell.Colors.ImportNewData.GREY)..HIDE,
					desc = SpeakinSpell:FormatSubs( L["<red>Don't<normalcolor> Use this Random Speech for the selected Event"], subs ),
					func = function() SpeakinSpell:ImportGUI_DeleteSpeech( index ) end,
				}, -- "Delete This Speech",
			},
		}
	end
end


function SpeakinSpell:CreateGUI_AddRandomWordBoxes()
	-- add more controls per random word input box (group)
	local args = SpeakinSpell.OptionsGUI.args.ImportGUI.args.AllTemplates.args.SelectedTemplate.args.RandomSubsGroup.args.SelectedRandomSub.args
	for index=1,SpeakinSpell.MAX.TEXTS_PER_RANDOM_SUB,1 do
		local frameName = string.format( "Word%02d", index )
		local subs = {
			number = index,
			red = SpeakinSpell.Colors.ImportNewData.RED,
			normalcolor = "|r",
		}
		args[frameName] = { -- "Random Word 1" (group)
			order = index + 100,
			type = "group",
			name = SpeakinSpell:FormatSubs( L["Random Word <number>"], subs ),
			hidden = function()
				local word = self:ImportGUI_GetRandomWord( index )
				return (word == nil) or (word == "")
			end,
			args = {
				Word = {
					order = 1,
					type = "description",
					name = function() return tostring( self:ImportGUI_GetRandomWord( index ) ) end,
				}, -- "Foo",
				Use = {
					order = 2,
					type = "execute",
					name = tostring(SpeakinSpell.Colors.ImportNewData.USE)..USE,
					desc = L["Use this Random Word for the selected <substitution>"],
					func = function() SpeakinSpell:ImportGUI_ImportRandomWord( index ) end,
				}, -- "Use This Word",
				Delete = {
					order = 3,
					type = "execute",
					name = tostring(SpeakinSpell.Colors.ImportNewData.GREY)..HIDE,
					desc = SpeakinSpell:FormatSubs( L["<red>Don't<normalcolor> Use this Random Word for the selected <substitution>"], subs ),
					func = function() SpeakinSpell:ImportGUI_DeleteRandomWord( index ) end,
				}, -- "Delete This Word",
			},
		}
	end
end


-------------------------------------------------------------------------------
-- Validate Selection
-------------------------------------------------------------------------------


function SpeakinSpell:ImportGUI_ValidateSelectionInTable( sel, Table )
	if not Table then
		return nil
	end
	if sel and Table[ sel ] then
		return sel
	end
	for sel,_ in pairs( Table ) do
		return sel
	end
	return nil
end


function SpeakinSpell:ImportGUI_ValidateSelectedTemplate()
	self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedTemplate = 
		self:ImportGUI_ValidateSelectionInTable(
			self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedTemplate,
			SpeakinSpell.DEFAULTS.Templates )
end


function SpeakinSpell:ImportGUI_ValidateSelectedEvent()
	self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedEvent = 
		self:ImportGUI_ValidateSelectionInTable(
			self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedEvent,
			self:ImportGUI_GetSelectedEventTable() )
end


function SpeakinSpell:ImportGUI_ValidateSelectedRandomSubs()
	self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedRandomSub = 
		self:ImportGUI_ValidateSelectionInTable(
			self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedRandomSub,
			self:ImportGUI_GetSelectedRandomSubs() )
end


-------------------------------------------------------------------------------
-- Safely Get Objects
-------------------------------------------------------------------------------


function SpeakinSpell:ImportGUI_GetSelectedTemplate()
	self:ImportGUI_ValidateSelectedTemplate()

	local sel = self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedTemplate
	if sel then
		return SpeakinSpell.DEFAULTS.Templates[ sel ]
	else
		return nil
	end
end


function SpeakinSpell:ImportGUI_GetSelectedTemplateName()
	local Template = self:ImportGUI_GetSelectedTemplate()
	if Template then
		return Template.name
	else
		return ""
	end
end


function SpeakinSpell:ImportGUI_GetSelectedTemplateDesc()
	local Template = self:ImportGUI_GetSelectedTemplate()
	if Template then
		return Template.desc
	else
		return ""
	end
end


function SpeakinSpell:ImportGUI_GetSelectedEventTable()
	local Template = self:ImportGUI_GetSelectedTemplate()
	if Template and
	   Template.Content then
		return Template.Content.EventTable
	else
		return nil
	end
end


function SpeakinSpell:ImportGUI_GetSelectedRandomSubs()
	local Template = self:ImportGUI_GetSelectedTemplate()
	if Template and
	   Template.Content then
		return Template.Content.RandomSubs
	else
		return nil
	end
end


function SpeakinSpell:ImportGUI_GetSelectedMessages()
	local funcname = "ImportGUI_GetSelectedMessages"
	
	local EventTable = self:ImportGUI_GetSelectedEventTable()
	if not EventTable then
		return nil
	end
	
	local ete = EventTable[ self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedEvent ]
	if not ete then
		return nil
	end
	
	return ete.Messages
end


function SpeakinSpell:ImportGUI_GetSelectedEventKey()
	self:ImportGUI_ValidateSelectedEvent()
	return self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedEvent
end


function SpeakinSpell:ImportGUI_GetSelectedSubstitutionKey()
	self:ImportGUI_ValidateSelectedRandomSubs()
	return self.RuntimeData.OptionsGUIStates.ImportGUI.SelectedRandomSub
end


-------------------------------------------------------------------------------
-- ImportGUI - EventsGroup
-------------------------------------------------------------------------------


function SpeakinSpell:ImportGUI_GetSpeech( index )
	local funcname = "ImportGUI_GetSpeech"
	
	local Messages = self:ImportGUI_GetSelectedMessages()
	if Messages and
	   Messages[ index ] then
		return Messages[ index ]
	else
		return ""
	end
end


function SpeakinSpell:ImportGUI_ImportSpeech( index )
	local funcname = "ImportGUI_ImportSpeech"
	
	local Messages = self:ImportGUI_GetSelectedMessages()
	if not Messages then
		self:ErrorMsg(funcname, "Messages is nil")
		return
	end
	
	local msg = Messages[index]
	if (msg == nil) or (msg == "") then
		self:ErrorMsg(funcname, "msg is empty")
		return
	end

	local key = self:ImportGUI_GetSelectedEventKey()
	if not key then
		self:ErrorMsg(funcname, "key is nil")
		return
	end
	
	local Template = self:ImportGUI_GetSelectedTemplate()
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	
	-- OK to import the speech 
	-- NOTE: this will copy other essential elements of the event if necessary
	self:ImportTemplate_AddOneSpeech( Template, key, index )
end


function SpeakinSpell:ImportGUI_DeleteSpeech( index )
	local Template = self:ImportGUI_GetSelectedTemplate()
	if Template then
		-- if that was the last new speech in the template, delete it
		local key = self:ImportGUI_GetSelectedEventKey()
		self:Template_DeleteOneSpeech( Template, key, index )
	end
end


-------------------------------------------------------------------------------
-- ImportGUI - RandomSubsGroup
-------------------------------------------------------------------------------

function SpeakinSpell:ImportGUI_GetRandomWord( index )
	local RandomSubs = self:ImportGUI_GetSelectedRandomSubs()
	if not RandomSubs then
		return nil
	end
	
	local key = self:ImportGUI_GetSelectedSubstitutionKey()
	if not key then
		return nil
	end
	
	local List = RandomSubs[key]
	if not List then
		return nil
	end
	
	return List[index]
end


function SpeakinSpell:ImportGUI_ImportRandomWord( index )
	local funcname = "ImportGUI_ImportRandomWord"
	
	if not index then
		self:ErrorMsg(funcname, "index is nil")
		return
	end
	
	local RandomSubs = self:ImportGUI_GetSelectedRandomSubs()
	if not RandomSubs then
		self:ErrorMsg(funcname, "Randomsubs is nil")
		return
	end
	
	local key = self:ImportGUI_GetSelectedSubstitutionKey()
	if not key then
		self:ErrorMsg(funcname, "key is nil")
		return
	end
	
	local Template = self:ImportGUI_GetSelectedTemplate()
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	
	self:ImportTemplate_AddOneRandomWord( Template, key, index )
end


function SpeakinSpell:ImportGUI_DeleteRandomWord( index )
	local Template = self:ImportGUI_GetSelectedTemplate()
	if Template then
		-- also delete empty parent tables
		local key = self:ImportGUI_GetSelectedSubstitutionKey()
		self:Template_DeleteOneRandomWord( Template, key, index )
	end
end


-------------------------------------------------------------------------------
-- Button Handlers
-------------------------------------------------------------------------------


function SpeakinSpell:ImportGUI_OnClickDeleteSelectedEvent()
	-- safely drill down to the pertinent objects
	local Template = SpeakinSpell:ImportGUI_GetSelectedTemplate()
	if not Template then
		SpeakinSpell:ErrorMsg(funcname,"abort: Template is nil")
		return
	end
	
	local EventTable = Template.Content.EventTable
	if not EventTable then
		SpeakinSpell:ErrorMsg(funcname,"abort: EventTable is nil")
		return
	end
	
	local key = SpeakinSpell:ImportGUI_GetSelectedEventKey()
	if not key then
		SpeakinSpell:ErrorMsg(funcname,"abort: key is nil")
		return
	end
	
	-- actually delete the selected event
	EventTable[key] = nil
	
	-- delete empty parent tables
	if self:IsTableEmpty( EventTable ) then
		Template.Content.EventTable = nil
	end
	
	if SpeakinSpell:IsTableEmpty( Template.Content ) then
		SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
	end
end


function SpeakinSpell:ImportGUI_OnClickDeleteAllWords()
	-- safely drill down to the pertinent objects
	local Template = SpeakinSpell:ImportGUI_GetSelectedTemplate()
	if not Template then
		SpeakinSpell:ErrorMsg(funcname,"abort: Template is nil")
		return
	end
	
	local RandomSubs = Template.Content.RandomSubs
	if not RandomSubs then
		SpeakinSpell:ErrorMsg(funcname,"abort: RandomSubs is nil")
		return
	end
	
	local key = SpeakinSpell.RuntimeData.OptionsGUIStates.ImportGUI.SelectedRandomSub
	if not key then
		SpeakinSpell:ErrorMsg(funcname,"abort: key is nil")
		return
	end
	
	-- actually delete the word list
	RandomSubs[key] = nil
	
	-- delete empty parent tables
	if self:IsTableEmpty( RandomSubs ) then
		Template.Content.RandomSubs = nil
	end
	
	if SpeakinSpell:IsTableEmpty( Template.Content ) then
		SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
	end
end


function SpeakinSpell:ImportGUI_OnSearchForNewData()
	self:Templates_Load() -- removes redundant and inapplicable data while/after loading
	if self:IsTableEmpty( SpeakinSpell.DEFAULTS.Templates ) then
		self:Print(L["You are already using all of the available content"]) --TODOFUTURE: popup? show on the GUI? tricky to keep the status known
	end
end


--name = L["Import All Templates"],
--desc = L["Import All Content for All Templates"],
function SpeakinSpell:ImportGUI_ImportAllTemplates()
	for index,Template in pairs( SpeakinSpell.DEFAULTS.Templates ) do
		self:ImportTemplate( Template )
	end
end


--name = L["Import Whole Template"],
--desc = L["Import All Content for the Selected Template"],
function SpeakinSpell:ImportGUI_ImportOneSelectedTemplate()
	local Template = self:ImportGUI_GetSelectedTemplate()
	self:ImportTemplate( Template )
end


--name = L["Import All Events"],
--desc = L["Import All Speech Events for the Selected Template"],
function SpeakinSpell:ImportGUI_ImportAllEvents()
	local Template = self:ImportGUI_GetSelectedTemplate()
	self:ImportTemplate_Events( Template )
end


--name = L["Import All Speeches"],
--desc = L["Import All speeches for the Selected Speech Event"],
function SpeakinSpell:ImportGUI_ImportAllSpeeches()
	local Template = self:ImportGUI_GetSelectedTemplate()
	local key = self:ImportGUI_GetSelectedEventKey()
	self:ImportTemplate_AllSpeeches( Template, key )
end


function SpeakinSpell:ImportGUI_GetSelectedDetectedEvent()
	local EventTable = self:ImportGUI_GetSelectedEventTable()
	if not EventTable then
		return nil
	end
	
	local key = self:ImportGUI_GetSelectedEventKey()
	if not key then
		return nil
	end
	
	local ete = EventTable[key]
	if not ete then
		return nil
	end
	
	return ete.DetectedEvent
end


--name = L["Import All <randomsubs>"],
--desc = L["Import All <randomsubs> for the Selected Template"],
function SpeakinSpell:ImportGUI_ImportAllRandomSubs()
	local Template = self:ImportGUI_GetSelectedTemplate()
	self:ImportTemplate_RandomSubs( Template )
end


--name = L["Import All Words"],
--desc = L["Import All \"Words\" for the Selected <randomsub>"],
function SpeakinSpell:ImportGUI_ImportAllRandomWords()
	local Template = self:ImportGUI_GetSelectedTemplate()
	local key = self:ImportGUI_GetSelectedSubstitutionKey()
	self:ImportTemplate_AllRandomWords( Template, key )
end


-------------------------------------------------------------------------------
-- OnSelect handlers
-------------------------------------------------------------------------------


function SpeakinSpell:ImportGUI_OnTemplateSelect( getset, value )
	local ImportGUIState = self.RuntimeData.OptionsGUIStates.ImportGUI
	if "GET" == getset then
		self:ImportGUI_ValidateSelectedTemplate()
		return ImportGUIState.SelectedTemplate
	else
		ImportGUIState.SelectedTemplate = value
	end
end


function SpeakinSpell:ImportGUI_OnRandomSubSelect( getset, value)
	local ImportGUIState = self.RuntimeData.OptionsGUIStates.ImportGUI
	if "GET" == getset then
		self:ImportGUI_ValidateSelectedRandomSubs()
		return ImportGUIState.SelectedRandomSub
	else
		ImportGUIState.SelectedRandomSub = value
	end
end


-------------------------------------------------------------------------------
-- CreateGUI - ImportGUI Main CreateGUI Entry
-------------------------------------------------------------------------------


function SpeakinSpell:CreateGUI_Import()
	self:CreateGUI_AddSpeechBoxes()
	self:CreateGUI_AddRandomWordBoxes()
end

