-- Author      : RisM
-- Create Date : 8/17/2010 3:57:34 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("guiwrapper.lua")


-------------------------------------------------------------------------------
-- ShowPage() functions - Open the Interface Options Panel to various pages
-------------------------------------------------------------------------------


function SpeakinSpell:LoadGUI()
	local loaded, message = LoadAddOn("SpeakinSpell_GUI")
	if (loaded) then
		if not self.IsGUILoaded then
			self:CreateGUI() --sets the IsGUILoaded flag before it succeeds
			--self.IsGUILoaded = true -- don't do this here in case CreateGUI is called elsewhere
		end
	end
	
	return self.IsGUILoaded
end


function SpeakinSpell:ShowOptions()
	local funcname = "ShowOptions"
	-- open interface options to show SpeakinSpell
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	InterfaceOptionsFrame_OpenToCategory( "SpeakinSpell" )
end


function SpeakinSpell:ShowOptions_Toggle()
	local funcname = "ShowOptions_Toggle"
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	-- open interface options to show SpeakinSpell
	-- if it's already open, close it
	if not SpeakinSpellSavedData.LastPageViewed then
		SpeakinSpellSavedData.LastPageViewed = {
			ObjectName = "General",
			InterfacePanel = "SpeakinSpell",
		}
	end
	local FrameName = SpeakinSpellSavedData.LastPageViewed.ObjectName
	self:DebugMsg(funcname, "FrameName:"..tostring(FrameName))
	if self.optionsFrames and FrameName and self.optionsFrames[FrameName] and self.optionsFrames[FrameName]:IsVisible() then
		self.optionsFrames[FrameName]:GetParent():GetParent():Hide()
	else
		self:ShowLastPageViewed()
	end
end


function SpeakinSpell:ShowLastPageViewed()
	local funcname = "ShowLastPageViewed"
	local InterfacePanel = SpeakinSpellSavedData.LastPageViewed.InterfacePanel
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	--self:DebugMsg(funcname, "InterfacePanel:"..tostring(InterfacePanel))
	InterfaceOptionsFrame_OpenToCategory( InterfacePanel )
end


function SpeakinSpell:ShowHelp()
	local funcname = "ShowHelp"
	-- open interface options to show SpeakinSpell
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	InterfaceOptionsFrame_OpenToCategory(L["SpeakinSpell Help"])
end


function SpeakinSpell:ShowImport()
	local funcname = "ShowImport"
	-- open interface options to show SpeakinSpell
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	InterfaceOptionsFrame_OpenToCategory(L["Import New Data"])
end


function SpeakinSpell:ShowColorsGUI()
	local funcname = "ShowColorsGUI"
	-- open interface options to show SpeakinSpell
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	InterfaceOptionsFrame_OpenToCategory(L["SpeakinSpell Colors"])
end


function SpeakinSpell:ShowCreateNew()
	local funcname = "ShowCreateNew"
	-- open interface options to show SpeakinSpell
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	InterfaceOptionsFrame_OpenToCategory(L["Create New..."])
end


function SpeakinSpell:ShowMessageOptions()
	local funcname = "ShowMessageOptions"
	-- open interface options to show SpeakinSpell
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	InterfaceOptionsFrame_OpenToCategory(L["Message Settings"])
end


function SpeakinSpell:ShowRandomSubsOptions()
	local funcname = "ShowRandomSubsOptions"
	-- open interface options to show SpeakinSpell
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	InterfaceOptionsFrame_OpenToCategory(L["Random Substutitions"])
end


function SpeakinSpell:ShowNetworkOptions()
	local funcname = "ShowNetworkOptions"
	-- open interface options to show SpeakinSpell
	if not self:LoadGUI() then
		self:DebugMsg(funcname, "failed to LoadGUI")
		return
	end
	InterfaceOptionsFrame_OpenToCategory(L["Data Sharing"])
end

