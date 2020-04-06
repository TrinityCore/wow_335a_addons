if not Skinner:isAddonEnabled("QuestHelper") then return end

function Skinner:QuestHelper()

	 -- wait until QuestHelper has been initialized
	if not QuestHelper_Loadtime
	or not QuestHelper_Loadtime["bst_post.lua"]
	then
		self:ScheduleTimer("checkAndRunAddOn", 0.1, "QuestHelper")
		return
	end

	-- hook these to skin the menu frames
	self:RawHook(QuestHelper, "CreateMenu", function(this)
		local menu = self.hooks[this].CreateMenu(this)
		-- if menu has already been skinned then don't create another Gradient texture
		if self.skinned[menu] then ng = true
		else ng = false	end
		self:applySkin{obj=menu, ng=ng}
		return menu
	end, true)
	self:SecureHook(QuestHelper, "ReleaseFrame", function(this, frame)
		-- remove Gradient texture and reset skinned flag
		for _, reg in pairs{frame:GetRegions()} do
			if reg:IsObjectType("Texture") then
				reg:SetTexture()
				self.skinned[frame] = nil
			end
		end
	end)

-->>-- Text Viewer
	self:SecureHook(QuestHelper, "ShowText", function(this, ...)
		self:skinScrollBar{obj=QuestHelperTextViewer.scrollframe}
		self:addSkinFrame{obj=QuestHelperTextViewer}
		self:Unhook(QuestHelper, "ShowText")
	end)

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then QuestHelper.tooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(QuestHelper.tooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

-- button on world map
	if QuestHelper_Pref.map_button then
		self:SecureHook(QuestHelper, "InitMapButton", function(this)
			self:skinButton{obj=QuestHelper.MapButton}
			self:Unhook(QuestHelper, "InitMapButton")
		end)
	end

end
