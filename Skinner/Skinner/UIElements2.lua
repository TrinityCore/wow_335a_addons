local _G = _G
local ftype = "u"

function Skinner:ModelFrames()
	if not self.db.profile.CharacterFrames then return end
--[[
[12:55:21] <dreyruugr> http://ace.pastey.net/551
[12:55:42] <dreyruugr> That should do framerate independant rotation of the model, based on how much the mouse moves
[13:12:43] <dreyruugr> Gngsk: http://ace.pastey.net/552 - This doesn't work quite right, but if you work on it you'll be able to zoom in on the character's face using the y offset of the mouse

This does the trick, but it might be worth stealing chester's code from SuperInspect

]]
	-- these are hooked to suppress the sound the normal functions use
	self:SecureHook("Model_RotateLeft", function(model, rotationIncrement)
		if not rotationIncrement then
			rotationIncrement = 0.03
		end
		model.rotation = model.rotation - rotationIncrement
		model:SetRotation(model.rotation)
	end)
	self:SecureHook("Model_RotateRight", function(model, rotationIncrement)
		if not rotationIncrement then
			rotationIncrement = 0.03
		end
		model.rotation = model.rotation + rotationIncrement
		model:SetRotation(model.rotation)
	end)

end

if IsMacClient() then
	function Skinner:MovieProgress()
		if not self.db.profile.MovieProgress or self.initialized.MovieProgress then return end
		self.initialized.MovieProgress = true

		self:getChild(MovieProgressBar, 1):SetBackdrop(nil)
		self:removeRegions(MovieProgressFrame)
		self:glazeStatusBar(MovieProgressBar, 0, self:getRegion(MovieProgressBar, 1))
		self:addSkinFrame{obj=MovieProgressFrame, ft=ftype, x1=-6, y1=6, x2=6, y2=-6}

	end
end

function Skinner:TimeManager()
	if not self.db.profile.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

-->>--	Time Manager Frame
	TimeManagerFrameTicker:Hide()
	self:keepFontStrings(TimeManagerStopwatchFrame)
	self:skinDropDown{obj=TimeManagerAlarmHourDropDown}
	TimeManagerAlarmHourDropDownMiddle:SetWidth(TimeManagerAlarmHourDropDownMiddle:GetWidth() + 8)
	self:skinDropDown{obj=TimeManagerAlarmMinuteDropDown}
	TimeManagerAlarmMinuteDropDownMiddle:SetWidth(TimeManagerAlarmMinuteDropDownMiddle:GetWidth() + 8)
	self:skinDropDown{obj=TimeManagerAlarmAMPMDropDown}
	self:skinEditBox{obj=TimeManagerAlarmMessageEditBox, regs={9}}
	self:addSkinFrame{obj=TimeManagerFrame, ft=ftype, kfs=true, x1=14, y1=-11, x2=-49, y2=9}

-->>--	Time Manager Clock Button
	self:removeRegions(TimeManagerClockButton, {1})
	if not self.db.profile.MinimalMMBtns then
		self:addSkinFrame{obj=TimeManagerClockButton, ft=ftype, x1=7, y1=-3, x2=-7, y2=3}
	end

-->>--	Stopwatch Frame
	self:keepFontStrings(StopwatchTabFrame)
	self:skinButton{obj=StopwatchCloseButton, cb=true, sap=true}
	self:addSkinFrame{obj=StopwatchFrame, ft=ftype, kfs=true, y1=-16, y2=2, nb=true}

end

function Skinner:Calendar()
	if not self.db.profile.Calendar or self.initialized.Calendar then return end
	self.initialized.Calendar = true

-->>--	Calendar Frame

	self:skinDropDown{obj=CalendarFilterFrame, noMove=true}
	-- adjust non standard dropdown
	CalendarFilterFrameMiddle:SetHeight(16)
	self:moveObject{obj=CalendarFilterButton, x=-8}
	self:moveObject{obj=CalendarFilterFrameText, x=-8}
	-- move close button
	self:moveObject{obj=CalendarCloseButton, y=14}
	self:adjHeight{obj=CalendarCloseButton, adj=-2}
	self:addSkinFrame{obj=CalendarFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=2, y2=-7}

-->>-- View Holiday Frame
	self:keepFontStrings(CalendarViewHolidayTitleFrame)
	self:moveObject{obj=CalendarViewHolidayTitleFrame, y=-6}
	self:removeRegions(CalendarViewHolidayCloseButton, {4})
	self:skinScrollBar{obj=CalendarViewHolidayScrollFrame}
	self:addSkinFrame{obj=CalendarViewHolidayFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=-2}

-->>-- View Raid Frame
	self:keepFontStrings(CalendarViewRaidTitleFrame)
	self:moveObject{obj=CalendarViewRaidTitleFrame, y=-6}
	self:removeRegions(CalendarViewRaidCloseButton, {4})
	self:skinScrollBar{obj=CalendarViewRaidScrollFrame}
	self:addSkinFrame{obj=CalendarViewRaidFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- View Event Frame
	self:keepFontStrings(CalendarViewEventTitleFrame)
	self:moveObject{obj=CalendarViewEventTitleFrame, y=-6}
	self:removeRegions(CalendarViewEventCloseButton, {4})
	self:addSkinFrame{obj=CalendarViewEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=CalendarViewEventDescriptionScrollFrame}
	self:keepFontStrings(CalendarViewEventInviteListSection)
	self:addSkinFrame{obj=CalendarViewEventInviteList, ft=ftype}
	self:addSkinFrame{obj=CalendarViewEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Create Event Frame
	CalendarCreateEventIcon:SetAlpha(1) -- show event icon
	self:keepFontStrings(CalendarCreateEventTitleFrame)
	self:moveObject{obj=CalendarCreateEventTitleFrame, y=-6}
	self:removeRegions(CalendarCreateEventCloseButton, {4})
	self:skinEditBox{obj=CalendarCreateEventTitleEdit, regs={9}}
	self:skinDropDown{obj=CalendarCreateEventTypeDropDown}
	self:skinDropDown{obj=CalendarCreateEventHourDropDown}
	CalendarCreateEventHourDropDownMiddle:SetWidth(CalendarCreateEventHourDropDownMiddle:GetWidth() + 8)
	self:skinDropDown{obj=CalendarCreateEventMinuteDropDown}
	CalendarCreateEventMinuteDropDownMiddle:SetWidth(CalendarCreateEventMinuteDropDownMiddle:GetWidth() + 8)
	self:skinDropDown{obj=CalendarCreateEventAMPMDropDown}
	self:skinDropDown{obj=CalendarCreateEventRepeatOptionDropDown}
	self:addSkinFrame{obj=CalendarCreateEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=CalendarCreateEventDescriptionScrollFrame}
	self:keepFontStrings(CalendarCreateEventInviteListSection)
	self:addSkinFrame{obj=CalendarCreateEventInviteList, ft=ftype}
	self:skinEditBox{obj=CalendarCreateEventInviteEdit, regs={9}}
	CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
	CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0)
	CalendarCreateEventCreateButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=CalendarCreateEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Mass Invite Frame
	self:keepFontStrings(CalendarMassInviteTitleFrame)
	self:moveObject{obj=CalendarMassInviteTitleFrame, y=-6}
	self:removeRegions(CalendarMassInviteCloseButton, {4})
	self:skinEditBox{obj=CalendarMassInviteGuildMinLevelEdit, regs={9}}
	self:skinEditBox{obj=CalendarMassInviteGuildMaxLevelEdit, regs={9}}
	self:skinDropDown{obj=CalendarMassInviteGuildRankMenu}
	self:addSkinFrame{obj=CalendarMassInviteFrame, ft=ftype, kfs=true, x1=4, y1=-3, x2=-3, y2=26}

-->>-- Event Picker Frame
	self:keepFontStrings(CalendarEventPickerTitleFrame)
	self:moveObject{obj=CalendarEventPickerTitleFrame, y=-6}
	self:keepFontStrings(CalendarEventPickerFrame)
	self:skinSlider(CalendarEventPickerScrollBar)
	self:removeRegions(CalendarEventPickerCloseButton, {7})
	self:addSkinFrame{obj=CalendarEventPickerFrame, ft=ftype, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Texture Picker Frame
	self:keepFontStrings(CalendarTexturePickerTitleFrame)
	self:moveObject{obj=CalendarTexturePickerTitleFrame, y=-6}
	self:skinSlider(CalendarTexturePickerScrollBar)
	CalendarTexturePickerCancelButtonBorder:SetAlpha(0)
	self:skinButton{obj=CalendarTexturePickerCancelButton}
	CalendarTexturePickerAcceptButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=CalendarTexturePickerFrame, ft=ftype, kfs=true, x1=5, y1=-3, x2=-3, y2=2}

-->>-- Class Button Container
	for i = 1, MAX_CLASSES do -- allow for the total button
		self:removeRegions(_G["CalendarClassButton"..i], {1})
	end
	self:keepFontStrings(CalendarClassTotalsButton)
	-- Class Totals button, texture & size changes
	if self.db.profile.TexturedDD then
    	CalendarClassTotalsButtonBackgroundMiddle:SetTexture(self.itTex)
    	self:moveObject{obj=CalendarClassTotalsButtonBackgroundMiddle, x=2}
    	CalendarClassTotalsButtonBackgroundMiddle:SetWidth(20)
    	CalendarClassTotalsButtonBackgroundMiddle:SetHeight(20)
    	CalendarClassTotalsButtonBackgroundMiddle:SetAlpha(1)
    end

-->>-- ContextMenus
	self:applySkin{obj=CalendarContextMenu}
	self:applySkin{obj=CalendarArenaTeamContextMenu}
	self:applySkin{obj=CalendarInviteStatusContextMenu}

end

function Skinner:MenuFrames()
	if not self.db.profile.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

-->>-- Game Menu Frame
	self:addSkinFrame{obj=GameMenuFrame, ft=ftype, kfs=true, hdr=true}
-->>-- Video Options
	self:addSkinFrame{obj=VideoOptionsFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=VideoOptionsFrameCategoryFrame, ft=ftype, kfs=true}
	self:skinSlider(VideoOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=VideoOptionsFramePanelContainer, ft=ftype}
	-- Resolution Panel
	self:skinDropDown{obj=VideoOptionsResolutionPanelResolutionDropDown}
	self:skinDropDown{obj=VideoOptionsResolutionPanelRefreshDropDown}
	self:skinDropDown{obj=VideoOptionsResolutionPanelMultiSampleDropDown}
	self:addSkinFrame{obj=VideoOptionsResolutionPanel, ft=ftype}
	-- Brightness subPanel
	self:addSkinFrame{obj=VideoOptionsResolutionPanelBrightness, ft=ftype}
	-- Effects Panel
	self:addSkinFrame{obj=VideoOptionsEffectsPanel, ft=ftype}
	self:addSkinFrame{obj=VideoOptionsEffectsPanelQuality, ft=ftype}
	self:addSkinFrame{obj=VideoOptionsEffectsPanelShaders, ft=ftype}

-->>-- Sound & Voice Options
	self:addSkinFrame{obj=AudioOptionsFrame, ft=ftype, kfs=true, hdr=true}
	self:skinSlider(AudioOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=AudioOptionsFrameCategoryFrame, ft=ftype, kfs=true}
	self:addSkinFrame{obj=AudioOptionsFramePanelContainer, ft=ftype}
	-- Sound Panel
	self:addSkinFrame{obj=AudioOptionsSoundPanel, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelPlayback, ft=ftype}
	self:skinDropDown{obj=AudioOptionsSoundPanelHardwareDropDown}
	self:addSkinFrame{obj=AudioOptionsSoundPanelHardware, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelVolume, ft=ftype}
	-- Voice Panel
	self:addSkinFrame{obj=AudioOptionsVoicePanel, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsVoicePanelTalking, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelInputDeviceDropDown}
	self:skinButton{obj=RecordLoopbackSoundButton, x1=-2, x2=2}
	self:skinButton{obj=PlayLoopbackSoundButton, x1=-2, x2=2}
	self:addSkinFrame{obj=LoopbackVUMeter:GetParent(), ft=ftype, aso={ng=true}, nb=true}
	self:glazeStatusBar(LoopbackVUMeter) -- no background required
	self:addSkinFrame{obj=AudioOptionsVoicePanelBinding, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelChatModeDropDown}
--	self:skinButton{obj=AudioOptionsVoicePanelChatMode1KeyBindingButton}
	self:addSkinFrame{obj=AudioOptionsVoicePanelListening, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelOutputDeviceDropDown}
	self:addSkinFrame{obj=VoiceChatTalkers, ft=ftype}

-->>-- Mac Options
	if IsMacClient() then
		self:addSkinFrame{obj=MacOptionsFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsFrameMovieRecording, ft=ftype, y1=-2}
		self:skinDropDown{obj=MacOptionsFrameResolutionDropDown}
		self:skinDropDown{obj=MacOptionsFrameFramerateDropDown}
		self:skinDropDown{obj=MacOptionsFrameCodecDropDown}
		-- popup frames
		self:addSkinFrame{obj=MacOptionsITunesRemote, ft=ftype, y1=-2}
		self:addSkinFrame{obj=MacOptionsCompressFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsCancelFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=FolderPicker, ft=ftype, kfs=true, hdr=true}
	end

-->>-- Interface
	self:addSkinFrame{obj=InterfaceOptionsFrame, ft=ftype, kfs=true, hdr=true}
	InterfaceOptionsFrameCategoriesList:SetBackdrop(nil)
	self:skinScrollBar{obj=InterfaceOptionsFrameCategoriesList}
	self:addSkinFrame{obj=InterfaceOptionsFrameCategories, ft=ftype, kfs=true}
	InterfaceOptionsFrameAddOnsList:SetBackdrop(nil)
	self:skinSlider(InterfaceOptionsFrameAddOnsListScrollBar)
	self:addSkinFrame{obj=InterfaceOptionsFrameAddOns, ft=ftype, kfs=true}
	self:addSkinFrame{obj=InterfaceOptionsFramePanelContainer, ft=ftype}
	-- skin toggle buttons
	for i = 1, #InterfaceOptionsFrameAddOns.buttons do
		self:skinButton{obj=InterfaceOptionsFrameAddOns.buttons[i].toggle, mp2=true}
	end

-->>-- Rating Menu
	self:addSkinFrame{obj=RatingMenuFrame, ft=ftype, hdr=true}--, x1=10, y1=-12, x2=-32, y2=71}

	-- Tabs
	for i = 1, 2 do
		local tabName = _G["InterfaceOptionsFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=-4}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[InterfaceOptionsFrame] = true

	local function checkKids(obj)

		local oName = obj.GetName and obj:GetName() or nil
		if oName and (oName:find("AceConfig") or oName:find("AceGUI"))then return end  -- ignore AceConfig/AceGUI objects

		for _, child in ipairs{obj:GetChildren()} do
		 	if Skinner:isDropDown(child) then Skinner:skinDropDown{obj=child}
			elseif child:IsObjectType("EditBox") then Skinner:skinEditBox{obj=child, regs={9}}
			else
				checkKids(child)
			end
		end

	end
	-- Hook these to skin any Interface Option panels and their elements
	self:SecureHook("InterfaceOptionsList_DisplayPanel", function(panel)
--		self:Debug("IOL_DP: [%s]", panel)
		if panel and panel.GetNumChildren and not self.skinFrame[panel] then
			self:ScheduleTimer(checkKids, 0.1, panel) -- wait for 1/10th second for panel to be populated
			self:ScheduleTimer("skinAllButtons", 0.1, panel) -- wait for 1/10th second for panel to be populated
			self:addSkinFrame{obj=panel, ft=ftype, kfs=true, nb=true}
		end
	end)

end

function Skinner:BindingUI()
	if not self.db.profile.MenuFrames or self.initialized.BindingUI then return end
	self.initialized.BindingUI = true

	self:skinScrollBar{obj=KeyBindingFrameScrollFrame}
	self:addSkinFrame{obj=KeyBindingFrame, ft=ftype, kfs=true, hdr=true, x2=-42, y2=10}

end

function Skinner:MacroUI()
	if not self.db.profile.MenuFrames or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

-->>-- Macro Frame
	self:skinFFToggleTabs("MacroFrameTab", 2)
	self:skinScrollBar{obj=MacroButtonScrollFrame}
	self:skinScrollBar{obj=MacroFrameScrollFrame}
	self:skinEditBox{obj=MacroFrameText, noSkin=true}
	self:addSkinFrame{obj=MacroFrameTextBackground, ft=ftype, y2=2}
	self:addSkinFrame{obj=MacroFrame, ft=ftype, kfs=true, hdr=true, x1=10, y1=-11, x2=-32, y2=71}

-->>-- Macro Popup Frame
	self:skinEditBox{obj=MacroPopupEditBox}
	self:skinScrollBar{obj=MacroPopupScrollFrame}
	self:addSkinFrame{obj=MacroPopupFrame, ft=ftype, kfs=true, x1=8, y1=-8, x2=-2, y2=4}

end

function Skinner:BankFrame()
	if not self.db.profile.BankFrame or self.initialized.BankFrame then return end
	self.initialized.BankFrame = true

	self:addSkinFrame{obj=BankFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-25, y2=91}

end

function Skinner:MailFrame()
	if not self.db.profile.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	self:addSkinFrame{obj=MailFrame, ft=ftype, kfs=true, x1=16, y1=-12, x2=-32, y2=69}

-->>--	Inbox Frame
	for i = 1, INBOXITEMS_TO_DISPLAY do
		self:keepFontStrings(_G["MailItem"..i])
	end
	self:moveObject{obj=InboxTooMuchMail, y=-24} -- move icon down
	self:skinButton{obj=InboxCloseButton, cb=true}

-->>--	Send Mail Frame
	self:keepFontStrings(SendMailFrame)
	self:skinScrollBar{obj=SendMailScrollFrame}
	for i = 1, ATTACHMENTS_MAX_SEND do
		local aTex = self:getRegion(_G["SendMailAttachment"..i], 1)
		aTex:SetTexture(self.esTex)
		aTex:SetWidth(64)
		aTex:SetHeight(64)
		aTex:SetTexCoord(0, 1, 0, 1)
		aTex:ClearAllPoints()
		aTex:SetPoint("CENTER", aTex:GetParent())
	end
	self:skinEditBox{obj=SendMailNameEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=SendMailSubjectEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=SendMailBodyEditBox, noSkin=true}
	local c = self.db.profile.BodyText
	SendMailBodyEditBox:SetTextColor(c.r, c.g, c.b)
	self:skinMoneyFrame{obj=SendMailMoney, moveSEB=true, moveGEB=true, noWidth=true}

-->>--	Open Mail Frame
	self:skinScrollBar{obj=OpenMailScrollFrame}
	OpenMailBodyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=OpenMailFrame, ft=ftype, kfs=true, x1=12, y1=-12, x2=-34, y2=70}

-->>-- Invoice Frame Text fields
	for _, v in pairs{"ItemLabel", "Purchaser", "BuyMode", "SalePrice", "Deposit", "HouseCut", "AmountReceived", "NotYetSent", "MoneyDelay"} do
		_G["OpenMailInvoice"..v]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

-->>--	FrameTabs
	for i = 1, MailFrame.numTabs do
		local tabName = _G["MailFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		if i == MailFrame.selectedTab then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[MailFrame] = true

end

function Skinner:AuctionUI()
	if not self.db.profile.AuctionUI or self.initialized.AuctionUI then return end
	self.initialized.AuctionUI = true

	-- hide filter texture when filter is clicked
	self:SecureHook("FilterButton_SetType", function(button, type, text, isLast)
		_G[button:GetName().."NormalTexture"]:SetAlpha(0)
	end)

	self:addSkinFrame{obj=AuctionFrame, ft=ftype, kfs=true, hdr=true, x1=10, y1=-11, y2=4}

-->>--	Browse Frame
	for k, v in pairs{"Name", "MinLevel", "MaxLevel"} do
		local obj = _G["Browse"..v]
		self:skinEditBox{obj=obj, regs={9}}
		self:moveObject{obj=obj, x=v=="MaxLevel" and -6 or -4, y=v~="MaxLevel" and 3 or 0}
	end
	self:skinDropDown{obj=BrowseDropDown}
	for _, v in pairs{"Quality", "Level", "Duration", "HighBidder", "CurrentBid"} do
		local obj = _G["Browse"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	self:skinScrollBar{obj=BrowseFilterScrollFrame}
	for i = 1, NUM_FILTERS_TO_DISPLAY do
		self:keepRegions(_G["AuctionFilterButton"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=_G["AuctionFilterButton"..i], ft=ftype, nb=true}
	end
	self:skinScrollBar{obj=BrowseScrollFrame}
	for i = 1, NUM_BROWSE_TO_DISPLAY do
		if _G["BrowseButton"..i].Orig then break end -- Auctioneer CompactUI loaded
		self:keepFontStrings(_G["BrowseButton"..i])
		if _G["BrowseButton"..i.."Highlight"] then _G["BrowseButton"..i.."Highlight"]:SetAlpha(1) end
		_G["BrowseButton"..i.."ItemCount"]:SetDrawLayer("ARTWORK") -- fix for 3.3.3 bug
	end
	self:skinMoneyFrame{obj=BrowseBidPrice, moveSEB=true}

-->>--	Bid Frame
	for _, v in pairs{"Quality", "Level", "Duration", "Buyout", "Status", "Bid"} do
		local obj = _G["Bid"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	for i = 1, NUM_BIDS_TO_DISPLAY do
		self:keepFontStrings(_G["BidButton"..i])
		if _G["BidButton"..i.."Highlight"] then _G["BidButton"..i.."Highlight"]:SetAlpha(1) end
	end
	self:skinScrollBar{obj=BidScrollFrame}
	self:skinMoneyFrame{obj=BidBidPrice, moveSEB=true}

-->>--	Auctions Frame
	local sTex = AuctionsItemButton:CreateTexture(nil, "BACKGROUND") -- add texture
	sTex:SetTexture(self.esTex)
	sTex:SetWidth(64)
	sTex:SetHeight(64)
	sTex:SetPoint("CENTER", AuctionsItemButton)
	for _, v in pairs{"Quality", "Duration", "HighBidder", "Bid"} do
		local obj = _G["Auctions"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		self:keepFontStrings(_G["AuctionsButton"..i])
		if _G["AuctionsButton"..i.."Highlight"] then _G["AuctionsButton"..i.."Highlight"]:SetAlpha(1) end
	end
	self:skinScrollBar{obj=AuctionsScrollFrame}
	self:getRegion(AuctionsItemButton, 2):SetAlpha(0) -- texture is changed in code
	self:skinEditBox{obj=AuctionsStackSizeEntry, regs={9}, noWidth=true}
	self:skinEditBox{obj=AuctionsNumStacksEntry, regs={9}, noWidth=true}
	self:skinDropDown{obj=PriceDropDown}
	self:skinDropDown{obj=DurationDropDown}
	AuctionProgressFrame:DisableDrawLayer("BACKGROUND")
	AuctionProgressFrame:DisableDrawLayer("ARTWORK")
	self:keepFontStrings(AuctionProgressBar)
	self:moveObject{obj=_G["AuctionProgressBar".."Text"], y=-2}
	self:glazeStatusBar(AuctionProgressBar, 0)
	self:skinMoneyFrame{obj=StartPrice, moveSEB=true}
	self:skinMoneyFrame{obj=BuyoutPrice, moveSEB=true}

-->>--	Auction DressUp Frame
	self:keepRegions(AuctionDressUpFrame, {3, 4}) --N.B. regions 3 & 4 are the background
	self:keepRegions(AuctionDressUpFrameCloseButton, {1}) -- N.B. region 1 is the button artwork
	self:makeMFRotatable(AuctionDressUpModel)
	self:moveObject{obj=AuctionDressUpFrame, x=6}
	self:addSkinFrame{obj=AuctionDressUpFrame, ft=ftype, x1=-6, y1=-3, x2=-2}
-->>--	Tabs
	for i = 1, AuctionFrame.numTabs do
		local tabName = _G["AuctionFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		if i == AuctionFrame.selectedTab then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[AuctionFrame] = true

end

function Skinner:MainMenuBar()
	if not self.db.profile.MainMenuBar.skin or self.initialized.MainMenuBar then return end
	self.initialized.MainMenuBar = true

	if self.db.profile.MainMenuBar.glazesb then
		self:glazeStatusBar(MainMenuExpBar, 0, self:getRegion(MainMenuExpBar, 6), {ExhaustionLevelFillBar})
		ExhaustionLevelFillBar:SetAlpha(0.75) -- increase alpha value to make it more visible
 		self:glazeStatusBar(ReputationWatchStatusBar, 0, ReputationWatchStatusBarBackground)
	end

	if IsAddOnLoaded("Dominos") then return end

	ExhaustionTick:SetAlpha(0)
	self:adjHeight{obj=MainMenuExpBar, adj=-2} -- shrink it so it moves up
	self:adjHeight{obj=ExhaustionLevelFillBar, adj=-2} -- mirror the XP bar
	local yOfs = IsAddOnLoaded("DragonCore") and -47 or -4
	self:addSkinFrame{obj=MainMenuBar, ft=ftype, noBdr=true, x1=-4, y1=-7, x2=4, y2=yOfs}
	self:keepFontStrings(MainMenuBarMaxLevelBar)
	self:keepFontStrings(MainMenuBarArtFrame)
	self:keepRegions(MainMenuExpBar, {1, 6, 7}) -- N.B. region 1 is rested XP, 6 is background, 7 is the normal XP
	self:keepRegions(ReputationWatchStatusBar, {9, 10}) -- 9 is background, 10 is the normal texture

	local function toggleActionButtons()

		if BonusActionBarFrame.mode == "show"
		or (BonusActionBarFrame.mode == "none" and BonusActionBarFrame.state == "top")
		then
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				_G["ActionButton"..i]:SetAlpha(0)
			end
		else
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				_G["ActionButton"..i]:SetAlpha(1)
			end
		end

	end

-->>-- Bonus Action Bar Frame
	self:keepFontStrings(BonusActionBarFrame)
	if BonusActionBarFrame.mode == "show" then
		toggleActionButtons()
	end
	-- hook these to hide/show ActionButtons when shapeshifting (Druid/Rogue)
	self:SecureHook("ShowBonusActionBar", function(this)
		toggleActionButtons()
	end)
	self:SecureHook("HideBonusActionBar", function(this)
		toggleActionButtons()
	end)
-->>-- Shapeshift Bar Frame
	self:keepFontStrings(ShapeshiftBarFrame)
	-- skin shapeshift buttons
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		local ssBtn = _G["ShapeshiftButton"..i]
		self:removeRegions(ssBtn, {6, 7, 8}) -- remove textures
		self:addSkinButton{obj=ssBtn, parent=ssBtn}
	end

-->>-- Possess Bar Frame
	self:keepFontStrings(PossessBarFrame)

-->>-- Pet Action Bar Frame
	self:keepFontStrings(PetActionBarFrame)

-->>-- Shaman's Totem Frame
	self:addSkinFrame{obj=MultiCastFlyoutFrame, kfs=true, ft=ftype, y1=-4, y2=-4}

-->>-- Vehicle Leave Button
	self:addSkinButton{obj=MainMenuBarVehicleLeaveButton, parent=MainMenuBarVehicleLeaveButton, hide=true}

end

function Skinner:CoinPickup()
	if not self.db.profile.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:addSkinFrame{obj=CoinPickupFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}

end

function Skinner:ItemSocketingUI()
	if not self.db.profile.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	local function colourSockets()

		for i = 1, GetNumSockets() do
			local colour = GEM_TYPE_INFO[GetSocketTypes(i)]
			self.sBut[_G["ItemSocketingSocket"..i]]:SetBackdropBorderColor(colour.r, colour.g, colour.b)
		end

	end
	-- hook this to colour the button border
	self:SecureHook("ItemSocketingFrame_Update", function()
		colourSockets()
	end)

	self:addSkinFrame{obj=ItemSocketingFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-4, y2=26}

	self:skinScrollBar{obj=ItemSocketingScrollFrame}

	for i = 1, MAX_NUM_SOCKETS do
		local isB = _G["ItemSocketingSocket"..i]
		_G["ItemSocketingSocket"..i.."Left"]:SetAlpha(0)
		_G["ItemSocketingSocket"..i.."Right"]:SetAlpha(0)
		self:getRegion(isB, 3):SetAlpha(0) -- button texture
		self:addSkinButton{obj=isB}
	end
	-- now colour the sockets
	colourSockets()

end

function Skinner:GuildBankUI()
	if not self.db.profile.GuildBankUI or self.initialized.GuildBankUI then return end
	self.initialized.GuildBankUI = true

-->>--	Main Frame
	GuildBankEmblemFrame:Hide()
	for i = 1, 7 do
		_G["GuildBankColumn"..i.."Background"]:SetAlpha(0)
	end
	self:addSkinFrame{obj=GuildBankFrame, ft=ftype, kfs=true, hdr=true, y1=-11, y2=1}

-->>--	Log Frame
	self:skinScrollBar{obj=GuildBankTransactionsScrollFrame}

-->>--	Info Frame
	self:skinScrollBar{obj=GuildBankInfoScrollFrame}

-->>--	GuildBank Popup Frame
	self:skinEditBox{obj=GuildBankPopupEditBox, regs={9}}
	self:skinScrollBar{obj=GuildBankPopupScrollFrame}
	self:addSkinFrame{obj=GuildBankPopupFrame, ft=ftype, kfs=true, hdr=true, x1=2, y1=-12, x2=-24, y2=24}

-->>--	GuildBank Tabs (side)
	for i = 1, MAX_GUILDBANK_TABS do
		local tabName = _G["GuildBankTab"..i]
		self:keepRegions(tabName, {7, 8})
	end

-->>--	GuildBank Frame Tabs (bottom)
	for i = 1, GuildBankFrame.numTabs do
		local tabName = _G["GuildBankFrameTab"..i]
		self:keepFontStrings(tabName)
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		if i == GuildBankFrame.selectedTab then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[GuildBankFrame] = true

end

function Skinner:Nameplates()
	if not self.db.profile.Nameplates or self.initialized.Nameplates then return end
	self.initialized.Nameplates = true

	local npEvt
	local function skinNameplates()

		for _, child in pairs{WorldFrame:GetChildren()} do
			if child:GetNumChildren() == 2 and child:GetNumRegions() == 11 then -- Nameplate frame
-- 				Skinner:ShowInfo(child, true)
				local shieldReg
				for k, reg in ipairs{child:GetRegions()} do -- process in key order
					-- region 1 is the flash texture, toggled using aggro warning option
					if k == 2 -- border texture
					or k == 3 -- border texture
					or k == 6 -- glow effect
					then reg:SetAlpha(0)
					elseif k == 4 then shieldReg = reg -- non-interruptible shield texture
					elseif k == 5 then Skinner:changeShield(shieldReg, reg) -- spell icon
					end
					-- regions 7 & 8 are text, 9 & 10 are raid icons, 11 is the elite icon
				end
				-- skin both status bars
				for _, grandchild in pairs{child:GetChildren()} do
					if not Skinner.sbGlazed[grandchild]	then
--						Skinner:ShowInfo(grandchild, true)
						Skinner:glazeStatusBar(grandchild, 0)
					end
				end
			end
		end

		-- if the nameplates are off then disable the skinning code
		local SHOW_ENEMIES = GetCVarBool("nameplateShowEnemies")
		local SHOW_FRIENDS = GetCVarBool("nameplateShowFriends")
		if not SHOW_ENEMIES and not SHOW_FRIENDS then
			Skinner:CancelTimer(npEvt, true)
			npEvt = nil
		end

	end

	local function showFunc()

		if not npEvt then
			npEvt = Skinner:ScheduleRepeatingTimer(skinNameplates, 0.2)
		end

	end

	self:SecureHook("SetCVar", function(varName, varValue, ...)
		if varName:find("nameplateShow") and varValue == 1 then showFunc() end
	end)

	local SHOW_ENEMIES = GetCVarBool("nameplateShowEnemies")
	local SHOW_FRIENDS = GetCVarBool("nameplateShowFriends")
	if SHOW_ENEMIES or SHOW_FRIENDS then showFunc() end

end

function Skinner:GMChatUI()
	if not self.db.profile.GMChatUI or self.initialized.GMChatUI then return end
	self.initialized.GMChatUI = true

-->>-- GM Chat Request frame
	self:addSkinFrame{obj=self:getChild(GMChatStatusFrame, 2), ft=ftype}

-->>-- GMChat Frame
	if self.db.profile.ChatFrames then
		self:addSkinFrame{obj=GMChatFrame, ft=ftype, x1=-4, y1=4, x2=4, y2=-8, nb=true}
	end
	self:skinButton{obj=GMChatFrameCloseButton, cb=true}

-->>-- GMChat Frame Tab
	self:addSkinFrame{obj=GMChatTab, kfs=true, ft=ftype, noBdr=self.isTT, y2=-4}

end

function Skinner:AutoComplete()

	self:addSkinFrame{obj=AutoCompleteBox, kfs=true, ft=ftype}

end

function Skinner:DebugTools()
	if not self.db.profile.DebugTools or self.initialized.DebugTools then return end
	self.initialized.DebugTools = true

	self:addSkinFrame{obj=EventTraceFrame, kfs=true, ft=ftype, x1=1, y1=-2, x2=-1, y2=4}
	self:skinSlider{obj=EventTraceFrameScroll, size=3}
	self:skinScrollBar{obj=ScriptErrorsFrameScrollFrame}
	self:addSkinFrame{obj=ScriptErrorsFrame, kfs=true, ft=ftype, x1=1, y1=-2, x2=-1, y2=4}

	if self.db.profile.Tooltips.skin then
        if self.db.profile.Tooltips.style == 3 then
            self:add2Table(self.ttList, "FrameStackTooltip")
            self:add2Table(self.ttList, "EventTraceTooltip")
        end
		self:HookScript(FrameStackTooltip, "OnUpdate", function(this)
			self:skinTooltip(this)
		end)
	end

end

function Skinner:LFDFrame()
	if not self.db.profile.LFDFrame or self.initialized.LFDFrame then return end
	self.initialized.LFDFrame = true

	-- LFD DungeonReady Popup a.k.a. ReadyCheck
	self:addSkinFrame{obj=LFDDungeonReadyStatus, kfs=true, ft=ftype}
	self:addSkinFrame{obj=LFDDungeonReadyDialog, kfs=true, ft=ftype}
	LFDDungeonReadyDialogRewardsFrameReward1Border:SetAlpha(0)
	LFDDungeonReadyDialogRewardsFrameReward2Border:SetAlpha(0)
	-- LFD RoleCheck Popup
	self:addSkinFrame{obj=LFDRoleCheckPopup, kfs=true, ft=ftype}
	-- Search Status Frame
	self:addSkinFrame{obj=LFDSearchStatus, ft=ftype}
	-- LFD Parent Frame
	self:addSkinFrame{obj=LFDParentFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-1}
	LowerFrameLevel(self.skinFrame[LFDParentFrame]) -- hopefully allow Random cooldown frame to appear in front now
	-- Portrait
	LFDParentFramePortraitTexture:SetAlpha(0)
	LFDParentFramePortraitIcon:SetAlpha(0)
	-- Queue Frame
	LFDQueueFrameBackground:SetAlpha(0)
	LFDQueueFrameLayout:SetAlpha(0)
	self:skinDropDown{obj=LFDQueueFrameTypeDropDown}
	self:skinScrollBar{obj=LFDQueueFrameRandomScrollFrame}
	LFDQueueFrameRandomScrollFrameChildFrameItem1NameFrame:SetTexture(nil)
	-- Specific List subFrame
	for i = 1, NUM_LFD_CHOICE_BUTTONS do
		local btn = "LFDQueueFrameSpecificListButton"..i.."ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
	end
	self:skinScrollBar{obj=LFDQueueFrameSpecificListScrollFrame}

end

function Skinner:LFRFrame()
	if not self.db.profile.LFRFrame or self.initialized.LFRFrame then return end
	self.initialized.LFRFrame = true

-->>-- LFR Parent Frame/ Queue Frame
	LFRQueueFrameLayout:SetAlpha(0)
	self:addSkinFrame{obj=LFRParentFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-1}
	-- Specific List subFrame
	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		local btn = "LFRQueueFrameSpecificListButton"..i.."ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
		self:moveObject{obj=_G[btn.."Highlight"], x=-3} -- move highlight to the left
	end
	self:skinScrollBar{obj=LFRQueueFrameSpecificListScrollFrame}

-->>-- LFR Browse Frame
	self:skinDropDown{obj=LFRBrowseFrameRaidDropDown}
	self:skinFFColHeads("LFRBrowseFrameColumnHeader", 7)
	self:skinScrollBar{obj=LFRBrowseFrameListScrollFrame}
	self:keepFontStrings(LFRBrowseFrame)

-->>-- Tabs
	for i = 1, LFRParentFrame.numTabs do
		local tabObj = _G["LFRParentFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[LFRParentFrame] = true

end

-- BattleNet additions (patch 3.3.5)
function Skinner:BNFrames()
	if not self.db.profile.BNFrames or self.initialized.BNFrames then return end
	self.initialized.BNFrames = true

-->>-- Toast frame
	self:addSkinFrame{obj=BNToastFrame, ft=ftype}
	self:reParentSB(BNToastFrameCloseButton, self.skinFrame[BNToastFrame])
	self:reParentSF(BNToastFrame)
-->>-- Report frame
	BNetReportFrameComment:DisableDrawLayer("BACKGROUND")
	self:skinScrollBar{obj=BNetReportFrameCommentScrollFrame}
	self:skinEditBox{obj=BNetReportFrameCommentBox, regs={6}}
	self:addSkinFrame{obj=BNetReportFrame, ft=ftype}
-->>-- ConversationInvite frame
	self:addSkinFrame{obj=BNConversationInviteDialogList, ft=ftype}
	self:skinScrollBar{obj=BNConversationInviteDialogListScrollFrame}
	self:addSkinFrame{obj=BNConversationInviteDialog, kfs=true, ft=ftype, hdr=true}

end
