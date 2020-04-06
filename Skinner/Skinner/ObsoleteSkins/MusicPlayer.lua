local _G = getfenv(0)

function Skinner:MusicPlayer()

-->>--	Favourite Frame
	self:keepFontStrings(MusicPlayerFavoriteFrame)
	self:moveObject(MusicPlayerFavoriteFrameCloseButton, "+", 10, "+", 10)
	self:keepFontStrings(MusicPlayer_Favorite_DropDownFrame)
	self:keepFontStrings(MusicPlayerFavoriteFrame_ScrollFrame)
	self:skinScrollBar(MusicPlayerFavoriteFrame_ScrollFrame)
	self:skinEditBox(MusicPlayerFavoriteFrame_InsertSong, {9})
	self:applySkin(MusicPlayerFavoriteFrame, true)

-->>--	Enqueue Frame
	self:keepFontStrings(MusicPlayer_EnqueueFrame)
	self:keepFontStrings(MusicPlayer_EnqueueFrame_SongListFrame_ScrollFrame)
	self:skinScrollBar(MusicPlayer_EnqueueFrame_SongListFrame_ScrollFrame)
	self:skinEditBox(MusicPlayerEnqueueFrame_SearchBox, {9})
	self:applySkin(MusicPlayer_EnqueueFrame, true)

-->>--	Options Frame
	self:keepFontStrings(MusicPlayerOptionsFrame_PlaylistLocDropDown)
	self:keepFontStrings(MusicPlayerOptionsFrame_FrameStrataDropDown)
	self:keepFontStrings(MusicPlayerOptionsFrame_WhenFinished_DropDown)
	self:keepFontStrings(MusicPlayerOptionsFrame)
	self:applySkin(MusicPlayerOptionsFrame, true)

-->>--	Player Frame
	self:keepFontStrings(MusicPlayer_PlayerFrame_Playlist_List_ScrollFrame)
	self:skinScrollBar(MusicPlayer_PlayerFrame_Playlist_List_ScrollFrame)
	self:keepFontStrings(MusicPlayer_PlayerFrame_Playlist_List)
	self:keepFontStrings(MusicPlayer_PlayerFrame_Playlist)
	self:applySkin(MusicPlayer_PlayerFrame_Playlist, nil)
	self:keepFontStrings(MusicPlayer_PlayerFrame_StatusBar)
	self:keepFontStrings(MusicPlayer_PlayerFrame_Window)
	self:applySkin(MusicPlayer_PlayerFrame_Window, nil)
	self:glazeStatusBar(MusicPlayer_PlayerFrame_StatusBar, 0)
	self:keepFontStrings(MusicPlayer_PlayerFrame)
	self:applySkin(MusicPlayer_PlayerFrame, nil)

-->>--	Help Frame
	self:keepFontStrings(MusicPlayerHelpFrameDescFrameScrollFrame)
	self:skinScrollBar(MusicPlayerHelpFrameDescFrameScrollFrame)
	self:keepFontStrings(MusicPlayerHelpFrameDescFrame)
	self:removeRegions(MusicPlayerHelpFrame_Button_AddSongs, {1})
	self:removeRegions(MusicPlayerHelpFrame_Button_Slash, {1})
	self:removeRegions(MusicPlayerHelpFrame_Button_Options, {1})
	self:removeRegions(MusicPlayerHelpFrame_Button_Advanced, {1})

	for i = 1, 3 do
		local tabName = _G["MusicPlayerHelpFrameTab"..i]
		self:keepRegions(tabName, {7,8})
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:applySkin(tabName) end
		if i == tabID then
			self:moveObject(tabName, "-", 10, "+", 1)
			tabName:SetWidth(tabName:GetWidth() - 20)
			if self.db.profile.TexturedTab then
				self:setActiveTab(tabName)
				self:SecureHook("MusicPlayerOptionsFrame_HelpTab_Lesser_OnClick", function()
					tabID = this:GetID()
					for i = 1, 3 do
						local tabName = _G["MusicPlayerHelpFrameTab"..i]
						if i == tabID then
							self:setActiveTab(tabName)
						else
							self:setInactiveTab(tabName)
						end
					end
				end)
			end
		else
			self:moveObject(tabName, "+", 8, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
	end

	self:keepFontStrings(MusicPlayerHelpFrame)
	self:applySkin(MusicPlayerHelpFrame, true)

end
