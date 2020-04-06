if not Skinner:isAddonEnabled("HoloFriends") then return end

function Skinner:HoloFriends()

-->>--	HoloFriends Frame
	self:skinDropDown{obj=HoloFriendsDropDown}
	self:skinFFToggleTabs("HoloFriendsFrameToggleTab", 2)
	self:skinScrollBar{obj=HoloFriendsScrollFrame}
	-- m/p buttons
	if self.modBtns then
		for i = 1, 18 do
			self:skinButton{obj=_G["HoloFriendsNameButton"..i], mp=true}
		end
		self:skinButton{obj=HoloFriendsNameButtonDrag, mp=true}
		-- hook to manage changes to button textures
		self:SecureHook("HoloFriends_UpdateFriendsList", function()
			for i = 1, 18 do
				self:checkTex(_G["HoloFriendsNameButton"..i])
			end
		end)
	end
	
-->>--	HoloIgnore Frame
	self:skinDropDown{obj=HoloIgnoreDropDown}
	self:skinFFToggleTabs("HoloIgnoreFrameToggleTab")
	self:skinScrollBar{obj=HoloIgnoreScrollFrame}
	-- m/p buttons
	if self.modBtns then
		for i = 1, 18 do
			self:skinButton{obj=_G["HoloIgnoreNameButton"..i], mp=true}
		end
		self:skinButton{obj=HoloIgnoreNameButtonDrag, mp=true}
		-- hook to manage changes to button textures
		self:SecureHook("HoloIgnore_UpdateIgnoreList", function()
			for i = 1, 18 do
				self:checkTex(_G["HoloIgnoreNameButton"..i])
			end
		end)
	end

-->>-- Friends Share Frame
	self:skinScrollBar{obj=HoloFriends_ShareFrame_SourceScrollFrame}
	self:skinScrollBar{obj=HoloFriends_ShareFrame_TargetScrollFrame}
	-- m/p buttons
	if self.modBtns then
		for i = 1, 10 do
			self:skinButton{obj=_G["HoloFriends_ShareFrame_Source"..i], mp=true}
		end
		-- hook to manage changes to button textures
		self:SecureHook("HoloFriendsShare_SourceScrollFrame_Update", function()
			for i = 1, 10 do
				self:checkTex(_G["HoloFriends_ShareFrame_Source"..i])
			end
			for i = 1, 10 do
				self:checkTex(_G["HoloIgnore_ShareFrame_Source"..i])
			end
		end)
		for i = 1, 10 do
			self:skinButton{obj=_G["HoloFriends_ShareFrame_Target"..i], mp=true}
		end
		-- hook to manage changes to button textures
		self:SecureHook("HoloFriendsShare_TargetScrollFrame_Update", function()
			for i = 1, 10 do
				self:checkTex(_G["HoloFriends_ShareFrame_Target"..i])
			end
			for i = 1, 10 do
				self:checkTex(_G["HoloIgnore_ShareFrame_Target"..i])
			end
		end)
	end

-->>-- Ignore Share Frame
	self:skinScrollBar{obj=HoloIgnore_ShareFrame_SourceScrollFrame}
	self:skinScrollBar{obj=HoloIgnore_ShareFrame_TargetScrollFrame}
	-- m/p buttons
	if self.modBtns then
		for i = 1, 10 do
			self:skinButton{obj=_G["HoloIgnore_ShareFrame_Source"..i], mp=true}
		end
		for i = 1, 10 do
			self:skinButton{obj=_G["HoloIgnore_ShareFrame_Target"..i], mp=true}
		end
	end

-->>-- Options Frame
	self:skinScrollBar{obj=HoloFriends_OptionsFrameScroll}
-->>-- FAQ Frame
	self:skinScrollBar{obj=HoloFriends_FAQFrameScroll}
	
end
