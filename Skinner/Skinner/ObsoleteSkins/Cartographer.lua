
function Skinner:Cartographer()
	if not self.db.profile.WorldMap.skin then return end

	if CartographerLookNFeelNonOverlayHolder then
		self:keepFontStrings(CartographerLookNFeelNonOverlayHolder)
		self:addSkinFrame{obj=WorldMapFrame, kfs=true, bg=true, y1=1, x2=1}
	end

	if Cartographer_Notes then self:Cartographer_Notes() end

end

function Skinner:Cartographer_Notes()
	if self.initialized.Cartographer_Notes then return end
	self.initialized.Cartographer_Notes = true

	local function skinNNF()

		local CNNNF = CartographerNotesNewNoteFrame
		if not Skinner.skinned[CNNNF] then
			Skinner:keepFontStrings(CNNNF)
			Skinner:moveObject(CNNNF.header, nil, nil, "+", 6, CNNNF)
			local last = nil
			for i = 1, CNNNF:GetNumChildren() do
				local v = select(i, CNNNF:GetChildren())
				if v:GetObjectType() == "EditBox"  then
					Skinner:skinEditBox(v, {9})
					if last then
						Skinner:moveObject(v, nil, nil, "+", 15, last)
					end
					last = v
				end
			end
			Skinner:keepRegions(CartographerNotesNewNoteFrameIcon, {4, 5}) -- N.B region 4 is text, 5 is the icon
			Skinner:applySkin(CNNNF)
		end

	end

	self:SecureHook(Cartographer_Notes, "OpenNewNoteFrame", function(this)
		skinNNF()
	end)

	self:SecureHook(Cartographer_Notes, "ShowEditDialog", function(this)
		skinNNF()
	end)

end

function Skinner:Cartographer_QuestInfo()

	-- use a timer here as the addon also uses a timer before adding the textures
	if Cartographer_QuestInfo.db.profile.wideQuestLog then
		self:ScheduleTimer(function() self:keepFontStrings(QuestLogFrame) end, 1)
	end

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then CQI_Tooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHook(CQI_Tooltip, "Show", function()
			self:skinTooltip(CQI_Tooltip)
		end)
	end
	
end
