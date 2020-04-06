if not Skinner:isAddonEnabled("BlackList") then return end

function Skinner:BlackList()
	if not self.db.profile.FriendsFrame then return end

	-- Toggle Tabs
	for _, v in pairs{"Friend", "Ignore", "Muted"} do
		local tabName = v.."FrameToggleTab4"
		local tabObj = _G[tabName]
		tabObj:SetHeight(tabObj:GetHeight() - 5)
		self:moveObject{obj=_G[tabName.."Text"], x=-2, y=3}
		self:moveObject{obj=_G[tabName.."HighlightTexture"], x=-2, y=5}
		self:keepRegions(tabObj, {7, 8}) -- N.B. these regions are text & highlight
		self:addSkinFrame{obj=tabObj}
	end

-->>-- BlackList Frame
	self:skinFFToggleTabs("BlackListFrameToggleTab", 4)
	self:skinScrollBar{obj=FriendsFrameBlackListScrollFrame}
	self:keepFontStrings(BlackListFrame)
	-- fix tab size etc
	PanelTemplates_TabResize(BlackListFrameToggleTab4, -2)
	BlackListFrameToggleTab4HighlightTexture:SetWidth(BlackListFrameToggleTab4:GetTextWidth() + 31)
	self:SecureHook("VoiceChat_Toggle", function()
		if IsVoiceChatEnabled() then
			BlackListFrameToggleTab3:Enable()
			BlackListFrameToggleTab3:SetDisabledFontObject(GameFontHighlightSmall)
			BlackListFrameToggleTab3:Show()
		else
			BlackListFrameToggleTab3:Disable()
			BlackListFrameToggleTab3:SetDisabledFontObject(GameFontDisableSmall)
			BlackListFrameToggleTab3:Hide()
		end
	end)

-->>-- BlackList Details Frame
	self:addSkinFrame{obj=BlackListDetailsFrameReasonTextBackground, kfs=true}
	self:skinScrollBar{obj=BlackListDetailsFrameScrollFrame}
 	self:addSkinFrame{obj=BlackListDetailsFrame, kfs=true}

-->>-- BlackList EditDetails Frame
	BlackListEditDetailsFrameLevelBackground:SetBackdrop(nil)
	BlackListEditDetailsFrameLevel:SetWidth(30)
	self:moveObject{obj=BlackListEditDetailsFrameLevel, y=-5}
	self:skinEditBox{obj=BlackListEditDetailsFrameLevel, regs={9}, noWidth=true}
	self:skinDropDown{obj=BlackListEditDetailsFrameClassDropDown}
	self:skinDropDown{obj=BlackListEditDetailsFrameRaceDropDown}
	self:addSkinFrame{obj=BlackListEditDetailsFrame, kfs=true}

-->>-- Options Frame
	self:skinEditBox{obj=BL_RankBox, regs={9}, noWidth=true, move=true}
	self:addSkinFrame{obj=BlackListOptionsFrame, kfs=true, y1=2}

end
