
function Skinner:WIM()

	local WIMSkinned = {}

	local function skinWIMFrames(respectSkin)

		for k, v in pairs(WIM_Windows) do
--			Skinner:Debug("WIM_SF: [%s, %s, %s, %s]", k, v, respectSkin, WIMSkinned[k] or "?")
			if WIM_Windows[k] and not (WIMSkinned[k] and respectSkin) then
				local frameName = WIM_Windows[k].frame
				Skinner:keepFontStrings(_G[frameName.."Backdrop"])
				if WIM_Data.characterInfo.classIcon then _G[frameName.."BackdropClassIcon"]:SetAlpha(1) end
				_G[frameName.."Backdrop"]:SetBackdrop(nil)
				Skinner:applySkin(_G[frameName.."IgnoreConfirm"])
				local eBox = _G[frameName.."MsgBox"]
				eBox:SetWidth(_G[frameName]:GetWidth() - 20)
				local _,_,_,xOfs,_ = _G[frameName.."ExitButton"]:GetPoint()
				xOfs = math.floor(xOfs)
--				Skinner:Debug("WIM_ExitPosn: [%s]", xOfs)
				if xOfs == 4 then
--					Skinner:Debug("WIM_SF_eb")
					eBox:SetHeight(eBox:GetHeight() - 5)
					Skinner:skinEditBox(eBox, {9})
					Skinner:moveObject(_G[frameName.."ExitButton"], "-", 2, nil, nil)
					Skinner:moveObject(eBox, "-", 12, "-", 3)
					Skinner:moveObject(_G[frameName.."BackdropClassIcon"], nil, nil, "-", 2)
				end
				Skinner:keepFontStrings(_G[frameName])
				Skinner:applySkin(_G[frameName])
				WIMSkinned[k] = true
			end
		end

	end

	-- Track this event to handle Windowed to Fullscreen and vice versa changes
	self:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS", skinWIMFrames)

-->>--	History Frame
	if not WIM_HistoryFrame.skinned then
		self:keepFontStrings(WIM_HistoryExportFormatMenu)
		self:keepFontStrings(WIM_HistoryFrameNameListScrollBar)
		self:skinScrollBar(WIM_HistoryFrameNameListScrollBar)
		self:keepFontStrings(WIM_HistoryFrameNameListTitle)
		self:applySkin(WIM_HistoryFrameNameList)
		self:keepFontStrings(WIM_HistoryFrameFilterListScrollBar)
		self:skinScrollBar(WIM_HistoryFrameFilterListScrollBar)
		self:keepFontStrings(WIM_HistoryFrameFilterListTitle)
		self:applySkin(WIM_HistoryFrameFilterList)
		self:keepFontStrings(WIM_HistoryFrameMessageListTitle)
		self:applySkin(WIM_HistoryFrameMessageList)
		self:keepFontStrings(WIM_HistoryViewerExportFormat)
		self:skinScrollBar(WIM_HistoryViewerExportFormat)
		self:applySkin(WIM_HistoryFrameTitle)
		self:applySkin(WIM_HistoryFrame)
		WIM_HistoryFrame.skinned = true
	end

-->>--	Help Frame
	WIM_HelpTitleBorder:Hide()
	self:moveObject(WIM_HelpExitButton, "+", 10, "+", 10)
	self:keepFontStrings(WIM_HelpScrollFrame)
	self:skinScrollBar(WIM_HelpScrollFrame)
	self:applySkin(WIM_HelpFrame)
	self:applySkin(WIM_Help)

-->>-- Conversation Menu
	self:applySkin(WIM_ConversationMenu)

-->>-- Toggle Window
	self:applySkin(WIM_ToggleWindow)

-->>--  Message Frame(s)
	self:SecureHook("WIM_PostMessage", function(user, msg, ttype, from, raw_msg, skipWhoQuery, msgID)
--		self:Debug("WIM_PM: [%s, %s, %s, %s, %s, %s, %s]", user, msg, ttype, from, raw_msg, skipWhoQuery, msgID)
		skinWIMFrames(false)
	end)
	-- Hook this to manage window size changes
	self:SecureHook("WIM_SetWindowProps", function(theWin)
		skinWIMFrames(false)
	end)

-->>--	Icon Tooltip (just a frame)
	self:applySkin(WIM_Icon_ToolTip)

end

function Skinner:WIM_Options()

-->>--	Options Frame
	WIM_OptionsTitleBorder:Hide()
	self:moveObject(WIM_OptionsExitButton, "+", 10, "+", 10)
	self:keepFontStrings(WIM_OptionsMiniMapCaption)
	self:applySkin(WIM_OptionsMiniMap)
	self:applySkin(WIM_OptionsTabbedFrame)
	self:keepFontStrings(WIM_OptionsDisplayCaption)
	self:applySkin(WIM_OptionsDisplay)
	self:keepFontStrings(WIM_OptionsDropDownFrame)
	self:keepFontStrings(WIM_Options_GeneralScroll)
	self:skinScrollBar(WIM_Options_GeneralScroll)
	self:keepFontStrings(WIM_OptionsTabbedFrameWindowWindowMode)
	self:keepFontStrings(WIM_OptionsTabbedFrameWindowCascadeDirection)
	self:keepFontStrings(WIM_OptionsTabbedFrameWindowTabSortOrder)
	self:keepFontStrings(WIM_OptionsTabbedFrameWindowTimeOutFriendMenu)
	self:keepFontStrings(WIM_OptionsTabbedFrameWindowTimeOutNonFriendMenu)
	self:keepFontStrings(WIM_OptionsTabbedFrameHistoryMessageCount)
	self:keepFontStrings(WIM_OptionsTabbedFrameHistoryMaxCount)
	self:keepFontStrings(WIM_OptionsTabbedFrameHistoryAutoDeleteTime)
	self:keepFontStrings(WIM_OptionsTabbedFrameFilterAliasPanelScrollBar)
	self:skinScrollBar(WIM_OptionsTabbedFrameFilterAliasPanelScrollBar)
	self:keepFontStrings(WIM_OptionsTabbedFrameFilterFilteringPanelScrollBar)
	self:skinScrollBar(WIM_OptionsTabbedFrameFilterFilteringPanelScrollBar)
	self:keepFontStrings(WIM_OptionsTabbedFrameHistoryPanelScrollBar)
	self:skinScrollBar(WIM_OptionsTabbedFrameHistoryPanelScrollBar)
	self:keepFontStrings(WIM_Options_PluginScroll)
	self:skinScrollBar(WIM_Options_PluginScroll)
	self:keepFontStrings(WIM_SkinnerOptionsStyles)
	self:keepFontStrings(WIM_SkinnerOptionsFonts)
	self:applySkin(WIM_Options)

-->>--	Alias Frame
	WIM_Options_AliasWindowTitleBorder:Hide()
	WIM_Options_AliasWindowPanel1:SetBackdrop(nil)
	WIM_Options_AliasWindowPanel2:SetBackdrop(nil)
	self:moveObject(WIM_Options_AliasWindow_Name, "-", 5, "-", 5)
	self:skinEditBox(WIM_Options_AliasWindow_Name)
	self:moveObject(WIM_Options_AliasWindow_Alias, "-", 5, "-", 5)
	self:skinEditBox(WIM_Options_AliasWindow_Alias)
	self:applySkin(WIM_Options_AliasWindow)
-->>--	Filter Frame
	WIM_Options_FilterWindowTitleBorder:Hide()
	WIM_Options_FilterWindowPanel1:SetBackdrop(nil)
	self:moveObject(WIM_Options_FilterWindow_Name, "-", 5, "-", 5)
	self:skinEditBox(WIM_Options_FilterWindow_Name)
	self:applySkin(WIM_Options_FilterWindow)
-->>--	Font Selector Frame
	self:keepFontStrings(WIM_Options_FontSelector)
	self:keepFontStrings(WIM_Options_FontSelectorListFrameScrollBar)
	self:skinScrollBar(WIM_Options_FontSelectorListFrameScrollBar)
	self:applySkin(WIM_Options_FontSelectorPreviewFrame)
	self:applySkin(WIM_Options_FontSelector, true)

end
