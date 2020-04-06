if not Skinner:isAddonEnabled("GuildGreet") then return end

function Skinner:GuildGreet()

-->>-- Greet List frame
	GuildGreetListTitleTexture:Hide()
	self:skinButton{obj=GuildGreetListClose, cb=true}
	self:addSkinFrame{obj=GuildGreetList, x1=-2, y1=3, x2=2}
	
-->>-- Paste List frame
    self:skinScrollBar{obj=GLDG_PasteList.List.Scroll}
    self:addSkinFrame{obj=GLDG_PasteList.List}

-->>-- Configuration main frame
	self:moveObject{obj=GuildGreetFrameTitle, y=-6}
	self:addSkinFrame{obj=GuildGreetFrame, kfs=true}
	for i = 1, GuildGreetFrame.numTabs do
		local tabObj = _G["GuildGreetFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[GuildGreetFrame] = true
-->>-- Configuration sub frame(es)
	-- Settings - General
	self:skinDropDown{obj=GuildGreetFrameSettingsGeneralChannelNameDropboxButton}
	-- Settings - Greeting
	self:skinEditBox{obj=GuildGreetFrameSettingsGreetingGuildAliasEditbox, regs={9}}
	-- Greetings
	self:skinScrollBar{obj=GuildGreetFrameGreetingsCollectbar}
	self:skinEditBox{obj=GuildGreetFrameGreetingsSubNewEditbox, regs={9}}
	self:skinScrollBar{obj=GuildGreetFrameGreetingsScrollbar}
	self:skinEditBox{obj=GuildGreetFrameGreetingsEditbox, regs={9}}
	-- Characters (a.k.a. Players)
	self:skinScrollBar{obj=GuildGreetFramePlayersPlayerbar}
	self:skinEditBox{obj=GuildGreetFramePlayersSubAliasEditbox, regs={9}}
	self:skinEditBox{obj=GuildGreetFramePlayersSubGuildEditbox, regs={9}}
	self:skinEditBox{obj=GuildGreetFramePlayersSubNoteEditbox, regs={9}}
	self:skinScrollBar{obj=GuildGreetFramePlayersSubMainAltScrollbar}
	-- Information (a.k.a Todo)
	self:SecureHook("GLDG_TodoShow", function(frame)
--      self:Debug("GLDG_TodoShow: [%s]", frame)
		self:skinScrollBar{obj=GuildGreetFrameTodoScroll}
		self:addSkinFrame{obj=GuildGreetFrameTodoList}
		self:Unhook("GLDG_TodoShow")
	end)
	self:addSkinFrame{obj=GuildGreetFrameSettings, kfs=true, y1=-8}
	for i = 1, GuildGreetFrameSettings.numTabs do
		local tabObj = _G["GuildGreetFrameSettingsTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[GuildGreetFrameSettings] = true
-->>-- ColorPicker frame
	self:skinEditBox{obj=GuildGreetColourFrameRed, regs={9}}
	self:skinEditBox{obj=GuildGreetColourFrameGreen, regs={9}}
	self:skinEditBox{obj=GuildGreetColourFrameBlue, regs={9}}
	self:skinEditBox{obj=GuildGreetColourFrameOpacity, regs={9}}
	self:addSkinFrame{obj=GLDG_ColorPickerFrame, hdr=true}--, x1=10, y1=-12, x2=-32, y2=71}

end
