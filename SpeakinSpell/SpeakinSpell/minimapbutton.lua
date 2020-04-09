-- Author      : RisM
-- Create Date : 9/21/2009 11:52:56 PM
--This was moved into the main Speakinspell directory because we want there to be a button
--to enable the GUI if it's not enabled.

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)

SpeakinSpell:PrintLoading("minimapbutton.lua")


-------------------------------------------------------------------------------
-- MINIMAP BUTTON SUPPORT
-------------------------------------------------------------------------------


function SpeakinSpell:MinimapButton_Create()
	local funcname = "MinimapButton_Create"
	
	if not (LDB and LDBIcon) then
		return
	end
	
	-- define which icons we'll use
	SpeakinSpell.iconpaths = {
		ON = "Interface\\Icons\\Ability_Warrior_BattleShout", --recognizable i guess
		OFF = "Interface\\Icons\\Ability_Rogue_Disguise", --this is OK for off
	}
	
	-- LDB launcher
	--self:DebugMsg(funcname,"entry")
	SpeakinSpell.Minimap = {
		--[[ SpeakinSpell.Minimap.Icon has moved to SpeakinSpellSavedData.MinimapIcon
		Icon = {
			hide = false,
			minimapPos = 220,
			radius = 80,
		},
		--]]
		LDBObject = LDB:NewDataObject(
			"SpeakinSpell",
			{
				type = "launcher",
				
				icon = SpeakinSpell.iconpaths.ON,
				text = "SpeakinSpell",
				
				OnClick = function(clickedframe, button)
					SpeakinSpell:MinimapButton_OnClick(clickedframe, button)
				end,
				
				OnTooltipShow = function(tt)
					local line = "SpeakinSpell"
					if SpeakinSpellSavedData.EnableAllMessages then
						line = line..tostring(SpeakinSpell.Colors.Minimap.ON)..L[" is ON"]
					else
						line = line..tostring(SpeakinSpell.Colors.Minimap.OFF)..L[" is OFF"]
					end
					tt:AddLine(line)
					tt:AddLine( tostring(SpeakinSpell.Colors.Minimap.Click) .. L["Click|r to toggle SpeakinSpell on/off"])
					tt:AddLine( tostring(SpeakinSpell.Colors.Minimap.Click) .. L["Right-click|r to open the options"])
				end,
			}
		),
		Registered = false,
	}

	-- show a different icon to indicate on/off status
	-- we assumed ON above, but init to OFF if we're disabled
	if not SpeakinSpellSavedData.EnableAllMessages then
		SpeakinSpell.Minimap.LDBObject.icon = SpeakinSpell.iconpaths.OFF
	end
	
	if SpeakinSpellSavedData.ShowMinimapButton then 
		self:MinimapButton_Register() --causes it to be shown initially
		self.RuntimeData.MinimapShowing = true
	end
end


function SpeakinSpell:MinimapButton_Register()
	local funcname = "MinimapButton_Register"
	--self:DebugMsg(funcname,"Register")
	SpeakinSpell.Minimap.Registered = true
	
	-- from instructions on http://wow.curse.com/downloads/wow-addons/details/libdbicon-1-0.aspx
	-- icon:Register("MyLDB", myLDB, savedVarTable)
	-- myLDB objdect is the Minimap.LDBObject
	-- saved vars for the position of the icon is in SpeakinSpellSavedData.MinimapIcon
	
	LDBIcon:Register("SpeakinSpell", SpeakinSpell.Minimap.LDBObject, SpeakinSpellSavedData.MinimapIcon)
end


function SpeakinSpell:MinimapButton_OnClick(clickedframe, button)
	if button == "RightButton" then 
		SpeakinSpell:ShowOptions_Toggle() 
	else 
		SpeakinSpellSavedData.EnableAllMessages = not SpeakinSpellSavedData.EnableAllMessages
		self:MinimapButton_Refresh()
		--self:RefreshFrame("General")
	end
end


function SpeakinSpell:MinimapButton_Refresh()
	local funcname = "MinimapButton_Refresh"

	-- make sure the correct icon is selected
	-- NOTE: do this even if 'ShowMinimapButton' option is disabled
	--		to support TitanPanel or other LDB frames
	if SpeakinSpellSavedData.EnableAllMessages then
		SpeakinSpell.Minimap.LDBObject.icon = SpeakinSpell.iconpaths.ON
	else
		SpeakinSpell.Minimap.LDBObject.icon = SpeakinSpell.iconpaths.OFF
	end

	if SpeakinSpellSavedData.ShowMinimapButton then 
		if not SpeakinSpell.Minimap.Registered then
			self:MinimapButton_Register()
		end
		
		-- make sure the button is showing
		--self:DebugMsg(funcname, "show")
		LDBIcon:Show("SpeakinSpell") 
		self.RuntimeData.MinimapShowing = true
	else 
		if not self.RuntimeData.MinimapShowing then
			return
		end
		-- make sure the button is hidden
		--self:DebugMsg(funcname, "hide")
		LDBIcon:Hide("SpeakinSpell")
		self.RuntimeData.MinimapShowing = false 
	end
end



function SpeakinSpell:MinimapButton_Show(show)
	SpeakinSpellSavedData.ShowMinimapButton = show
	self:MinimapButton_Refresh()
end

