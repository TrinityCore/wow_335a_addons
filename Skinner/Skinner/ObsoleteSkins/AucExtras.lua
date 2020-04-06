
function Skinner:AucExtras()
	if self.initialized.AucExtras then return end
	self.initialized.AucExtras = true

	-- hook this to skin Slide bar
	local sblib = LibStub:GetLibrary("SlideBar")
	if sblib.frame then
		self:applySkin(sblib.frame)
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then sblib.tooltip:SetBackdrop(self.backdrop) end
			self:SecureHook(sblib.tooltip, "Show", function(this)
				self:skinTooltip(sblib.tooltip)
			end)
		end
	end

	-- hook this to skin Configator frames
	local clib = LibStub:GetLibrary("Configator")
	self:Hook(clib, "Create", function(this, ...)
		local frame = self.hooks[clib].Create(this, ...)
--		self:Debug("Configator_Create: [%s]", frame:GetName())
		if not frame.skinned then
			self:applySkin(frame)
			frame.skinned = true
		end

		-- skin the Tooltip
		if self.db.profile.Tooltips.skin then
			if not clib.tooltip.hooked then
				if self.db.profile.Tooltips.style == 3 then clib.tooltip:SetBackdrop(self.backdrop) end
				self:SecureHook(clib.tooltip, "Show", function(this)
					self:skinTooltip(clib.tooltip)
				end)
				clib.tooltip.hooked = true
			end
		end

		-- skin the Help frame
		if not clib.help.skinned then
			self:moveObject(clib.help.close, nil, nil, "-", 2)
			self:applySkin(clib.help)
			self:skinUsingBD2(clib.help.scroll.hScroll)
			self:skinUsingBD2(clib.help.scroll.vScroll)
			clib.help.skinned = true
		end

		-- hook this to skin various controls
		self:Hook(frame, "AddControl", function(this, id, cType, column, ...)
--		self:Debug("Configator_Create_AddControl: [%s, %s, %s, %s]", id, cType, column, ...)
			local control = self.hooks[frame].AddControl(this, id, cType, column, ...)
			-- skin the sub-frame if required
			if not this.tabs[id].frame.skinned then
				self:applySkin(this.tabs[id].frame)
				this.tabs[id].frame.skinned = true
			end
			-- skin the scroll bars
			if this.tabs[id].scroll and not this.tabs[id].scroll.skinned then
				self:skinUsingBD2(this.tabs[id].scroll.hScroll)
				self:skinUsingBD2(this.tabs[id].scroll.vScroll)
				this.tabs[id].scroll.skinned = true
			end
			-- skin the DropDown
			if cType == "Selectbox" then
				self:keepFontStrings(control)
				if not SelectBoxMenu.skinned then
					self:applySkin(SelectBoxMenu.back)
					SelectBoxMenu.skinned= true
				end
			end
			if cType == "Text" then self:skinEditBox(control, {9}) end
			if cType == "NumberBox" then self:skinEditBox(control, {9}) end
			if cType == "MoneyFrame" or cType == "MoneyFramePinned" then self:skinMoneyFrame(control) end
			return control
			end, true)
		return frame
	end, true)

	-- skin frames already created
	if clib.frames then
		for i = 1, #clib.frames do
			local frame = clib.frames[i]
			if frame then
				self:applySkin(frame)
				frame.skinned = true
			end
			if frame.tabs then
				for j = 1, #frame.tabs do
					local tab = frame.tabs[j]
					self:applySkin(tab.frame)
					tab.frame.skinned = true
					if tab.frame.ctrls then
						for k = 1, #tab.frame.ctrls do
							local tfc = tab.frame.ctrls[k]
							if tfc.kids then
								for l = 1, #tfc.kids do
									local tfck = tfc.kids[l]
									if tfck.stype then
										if tfck.stype == "EditBox" then
											self:skinEditBox(tfck, {9})
										end
										if tfck.stype == "SelectBox" then
											self:keepFontStrings(tfck)
										end
										if tfck.isMoneyFrame then
											self:skinMoneyFrame(tfck)
										end
									end
								end
							end
						end
					end
					if tab.scroll then
						self:skinUsingBD2(tab.scroll.hScroll)
						self:skinUsingBD2(tab.scroll.vScroll)
						tab.scroll.skinned = true
					end
				end
			end
		end
	end

	-- skin the Tooltip
	if self.db.profile.Tooltips.skin then
		if not clib.tooltip.hooked then
			if self.db.profile.Tooltips.style == 3 then clib.tooltip:SetBackdrop(self.backdrop) end
			self:SecureHook(clib.tooltip, "Show", function(this)
				self:skinTooltip(clib.tooltip)
			end)
			clib.tooltip.hooked = true
		end
	end

	-- skin the Help frame
	if clib.help then
		self:moveObject(clib.help.close, nil, nil, "-", 2)
		self:applySkin(clib.help)
		self:skinUsingBD2(clib.help.scroll.hScroll)
		self:skinUsingBD2(clib.help.scroll.vScroll)
		clib.help.skinned = true
	end
	-- skin DropDown menu
	if SelectBoxMenu then
		self:applySkin(SelectBoxMenu.back)
		SelectBoxMenu.skinned= true
	end

end
