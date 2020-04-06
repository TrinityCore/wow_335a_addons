-- This is a Library

function Skinner:Configator()

	-- hook this to skin Slide bars
	local sblib = LibStub("SlideBar", true)
	if sblib and sblib.frame then
		self:applySkin(sblib.frame)
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then sblib.tooltip:SetBackdrop(self.Backdrop[1]) end
			self:SecureHook(sblib.tooltip, "Show", function(this)
				self:skinTooltip(sblib.tooltip)
			end)
		end
	end

	local clib = LibStub("Configator", true)
	local function skinHelp()

		self:moveObject{obj=clib.help.close, y=-2}
		self:skinButton{obj=clib.help.close, cb=true}
		self:skinUsingBD{obj=clib.help.scroll.hScroll}
		self:skinUsingBD{obj=clib.help.scroll.vScroll}
		self:addSkinFrame{obj=clib.help}

	end
	-- hook this to skin Configator frames
	if clib then
		self:RawHook(clib, "Create", function(this, ...)
			local frame = self.hooks[clib].Create(this, ...)
--			self:Debug("Configator_Create: [%s]", frame:GetName())
			if not self.skinFrame[frame.Backdrop] then
				self:skinButton{obj=frame.Done}
				self:addSkinFrame{obj=frame.Backdrop}
			end

			-- skin the Tooltip
			if self.db.profile.Tooltips.skin then
				if not self:IsHooked(clib.tooltip, "Show") then
					if self.db.profile.Tooltips.style == 3 then clib.tooltip:SetBackdrop(self.Backdrop[1]) end
					self:SecureHook(clib.tooltip, "Show", function(this)
						self:skinTooltip(clib.tooltip)
					end)
				end
			end

			-- skin the Help frame
			if not self.skinFrame[clib.help] then skinHelp() end

			-- hook this to skin various controls
			self:RawHook(frame, "AddControl", function(this, id, cType, column, ...)
				local control = self.hooks[frame].AddControl(this, id, cType, column, ...)
--	 			self:Debug("Configator_Create_AddControl: [%s, %s, %s, %s, %s]", control, id, cType, column, ...)
				-- skin the sub-frame if required
				if not self.skinFrame[this.tabs[id].frame] then
					self:addSkinFrame{obj=this.tabs[id].frame}
				end
				-- skin the scroll bars
				if this.tabs[id].scroll and not self.skinned[this.tabs[id].scroll] then
					self:skinUsingBD{obj=this.tabs[id].scroll.hScroll}
					self:skinUsingBD{obj=this.tabs[id].scroll.vScroll}
				end
				-- skin the DropDown
				if cType == "Selectbox" then
					self:skinDropDown{obj=control}
					if not self.skinFrame[SelectBoxMenu.back] then
						self:addSkinFrame{obj=SelectBoxMenu.back}
					end
				elseif cType == "Text" or cType == "TinyNumber" or cType == "NumberBox" then
					self:skinEditBox{obj=control, regs={9}}
				elseif cType == "NumeriSlider" or cType == "NumeriWide" or cType == "NumeriTiny" then
					self:skinEditBox{obj=control.slave, regs={9}}
				elseif cType == "MoneyFrame" or cType == "MoneyFramePinned" then
					self:skinMoneyFrame{obj=control, noWidth=true, moveSEB=true}
				elseif cType == "Button" then
					self:skinButton{obj=control, as=true} -- just skin it otherwise text is hidden
				end
				return control
			end, true)
			return frame
		end, true)
	end

	-- skin frames already created
	if clib and clib.frames then
		for i = 1, #clib.frames do
			local frame = clib.frames[i]
			if frame then
				self:addSkinFrame{obj=frame}
			end
			if frame.tabs then
				for j = 1, #frame.tabs do
					local tab = frame.tabs[j]
					self:addSkinFrame{obj=tab.frame}
					if tab.frame.ctrls then
						for k = 1, #tab.frame.ctrls do
							local tfc = tab.frame.ctrls[k]
							if tfc.kids then
								for l = 1, #tfc.kids do
									local tfck = tfc.kids[l]
									if tfck.stype then
										if tfck.stype == "EditBox" then
											self:skinEditBox{obj=tfck, regs={9}}
										end
										if tfck.stype == "Slider" and tfck.slave then
											self:skinEditBox{obj=tfck.slave, regs={9}}
										end
										if tfck.stype == "SelectBox" then
											self:keepFontStrings(tfck)
										end
										if tfck.isMoneyFrame then
											self:skinMoneyFrame{obj=tfck, noWidth=true, moveSEB=true}
										end
									end
								end
							end
						end
					end
					if tab.scroll then
						self:skinUsingBD{obj=tab.scroll.hScroll}
						self:skinUsingBD{obj=tab.scroll.vScroll}
						self.skinned[tab.scroll] = true
					end
				end
			end
		end
	end

	-- skin the Tooltip
	if self.db.profile.Tooltips.skin then
		if clib and not self:IsHooked(clib.tooltip, "Show") then
			if self.db.profile.Tooltips.style == 3 then clib.tooltip:SetBackdrop(self.backdrop) end
			self:SecureHook(clib.tooltip, "Show", function(this)
				self:skinTooltip(clib.tooltip)
			end)
		end
	end

	-- skin the Help frame
	if clib and clib.help then skinHelp() end
	-- skin DropDown menu
	if SelectBoxMenu then self:addSkinFrame{obj=SelectBoxMenu.back}	end

	-- skin ScrollSheets
	local sslib = LibStub("ScrollSheet", true)
	if sslib then
		self:RawHook(sslib, "Create", function(this, parent, ...)
			local sheet = self.hooks[sslib].Create(this, parent, ...)
			self:skinUsingBD{obj=sheet.panel.hScroll}
			self:skinUsingBD{obj=sheet.panel.vScroll}
			self:applySkin{obj=parent} -- just skin it otherwise text is hidden
			return sheet
		end, true)
	end

end
