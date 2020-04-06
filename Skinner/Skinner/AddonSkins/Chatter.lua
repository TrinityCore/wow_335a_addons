if not Skinner:isAddonEnabled("Chatter") then return end

function Skinner:Chatter()

	if Chatter:GetModule("Chat Copy") then
		self:removeRegions(ChatterCopyScroll)
		self:skinScrollBar(ChatterCopyScroll)
		self:applySkin(ChatterCopyFrame)
	end

	-- disable Chatter module if enabled
	if self.db.profile.ChatFrames then
		if Chatter:GetModule("Borders/Background").enabledState then
			Chatter.db.profile.modules["Borders/Background"] = false
			Chatter:DisableModule("Borders/Background")
		end
	end

	-- set the Chatter EditBox values to match the Skinner ones
	local ebp = Chatter:GetModule("Edit Box Polish")
	local prof = ebp.db.profile

	if self.db.profile.ChatEditBox.skin then
		local prdb = self.db.profile
		if prdb.BdDefault then
			prof.background = "Blizzard ChatFrame Background"
			prof.border = "Blizzard Tooltip"
		else
			if prdb.BdFile and prdb.BdFile ~= "None" then
				prof.background = "Skinner User Background"
			else
				prof.background = prdb.BdTexture
			end
			if prdb.BdEdgeFile and prdb.BdEdgeFile ~= "None" then
				prof.border = "Skinner User Border"
			else
				prof.border = prdb.BdBorderTexture
			end
		end
		local bkd = CopyTable(self.Backdrop[1])
		prof.inset = bkd.insets.left
		prof.tileSize = bkd.tileSize
		prof.edgeSize = bkd.edgeSize
		local bc = prof.backgroundColor
		bc.r, bc.g, bc.b, bc.a = unpack(self.bColour)
		local bbc = prof.borderColor
		bbc.r, bbc.g, bbc.b, bbc.a = unpack(self.bbColour)
		if self.db.profile.ChatEditBox.style == 2 then -- Editbox
			prof.border = "Skinner Border"
			prof.inset = 4
			prof.tileSize = 16
			prof.edgeSize = 16
			bc.r, bc.g, bc.b, bc.a = .1, .1, .1, 1
			bbc.r, bbc.g, bbc.b, bbc.a = .2, .2, .2, 1
		elseif self.db.profile.ChatEditBox.style == 3 then -- borderless
			bba = 0
		end
		prof.hasBeenSkinned = nil
		-- then apply these changes to the ChatEditBoxes
		ebp:SetBackdrop()
	end

	if not self.db.profile.ChatEditBox.style == 2 then
		-- apply the fade/gradient to the ChatEditBoxes
		for _, cfeb in pairs(ebp.frames) do
			self:applyGradient(cfeb)
		end
	end

end
