if not Skinner:isAddonEnabled("MSBTOptions") then return end

function Skinner:MSBTOptions()

	-- hook this the skin all the popup frames
	self:SecureHook(MSBTOptions.Main, "RegisterPopupFrame", function(pframe)
--		self:Debug("Main_RegisterPopupFrame: [%s]", pframe)
		-- hook the show method so we can skin the popup frame
		if not self:IsHooked(pframe, "Show") then
			self:SecureHook(pframe, "Show", function(this)
--				self:Debug("PopupFrame_Show: [%s, %s]", pframe, pframe:GetName() or "???")
				if not self.skinned[this] then
					self:applySkin(this)
					-- skin the sliders
					if this.mainConditionsListbox and this.mainConditionsListbox.sliderFrame then
						self:skinUsingBD2(this.mainConditionsListbox.sliderFrame)
					end
					if this.secondaryConditionsListbox and this.secondaryConditionsListbox.sliderFrame then
						self:skinUsingBD2(this.secondaryConditionsListbox.sliderFrame)
					end
					if this.triggerEventsListbox and this.triggerEventsListbox.sliderFrame then
						self:skinUsingBD2(this.triggerEventsListbox.sliderFrame)
					end
					if this.skillsListbox and this.skillsListbox.sliderFrame then
						self:skinUsingBD2(this.skillsListbox.sliderFrame)
					end
				end
				self:Unhook(pframe, "Show")
			end)
		end
	end)

	-- hook these to skin the dropdowns & editboxes
	self:RawHook(MSBTOptions.Controls, "CreateDropdown", function(parent)
--		self:Debug("Controls_CreateDropdown:[%s]", parent)
		local obj = self.hooks[MSBTOptions.Controls].CreateDropdown(parent)
		self:keepFontStrings(obj)
		self.skinned[obj] = true
		return obj
	end)
	self:RawHook(MSBTOptions.Controls, "CreateEditbox", function(parent)
--		self:Debug("Controls_CreateEditbox:[%s]", parent)
		local obj = self.hooks[MSBTOptions.Controls].CreateEditbox(parent)
		self:skinEditBox(obj.editboxFrame, {9})
		self:moveObject(obj.labelFontString, "+", 8, "+", 3, obj)
		self.skinned[obj] = true
		return obj
	end)

	-- handle being invoked as LoD or normal addon
	local function skinMSBTOptions()

	-->>-- Main Frame
		for i = 2, 8 do
			local cframe = Skinner:getChild(MSBTMainOptionsFrame, i)
			Skinner:moveObject(cframe, nil, nil, "+", 40) -- move the child frame up
			if i > 3 then
				-- hook the show method so we can skin the Option tab frame elements
				Skinner:SecureHook(cframe, "Show", function(this)
					for i = 1, this:GetNumChildren() do
						local obj = select(i, this:GetChildren())
						if obj:IsObjectType("Frame") and not Skinner.skinned[obj] then
							if obj.selectedItem then -- it's a dropdown
--								Skinner:Debug("obj has .selectedItem [%s, %s]", obj, obj.selectedItem)
								Skinner:keepFontStrings(obj)
							end
						end
					end
					-- skin sliders
					if this.controls.eventsListbox and this.controls.eventsListbox.sliderFrame then
						Skinner:skinUsingBD2(this.controls.eventsListbox.sliderFrame)
					end
					if this.controls.triggersListbox and this.controls.triggersListbox.sliderFrame then
						Skinner:skinUsingBD2(this.controls.triggersListbox.sliderFrame)
					end
					Skinner:Unhook(cframe, "Show")
				end)
			end
		end
--		Skinner:applySkin(MSBTMainOptionsFrame)
		Skinner:addSkinFrame{obj=MSBTMainOptionsFrame, kfs=true, x1=16, y1=-11, x2=-6, y2=38}

	-->>--	TabList frame
		local tabList = Skinner:getChild(MSBTMainOptionsFrame, 2)
		Skinner:skinUsingBD2(tabList.sliderFrame)
		Skinner:addSkinFrame{obj=tabList, x1=-2, y1=4}
		Skinner.skinned[tabList] = true

	-->>--	Options Frame profile dropdown
		Skinner:keepFontStrings(Skinner:getChild(Skinner:getChild(MSBTMainOptionsFrame, 4), 2))

	-->>--	dropdown listbox frame
		for _, child in pairs{UIParent:GetChildren()} do
			if child:IsObjectType("Frame")
			and child:GetName() == nil
			then
				local backdrop = child:GetBackdrop()
				if backdrop and backdrop.bgFile == [[Interface\Addons\MSBTOptions\Artwork\PlainBackdrop]] then
					if not Skinner.skinned[child] then
						Skinner:skinUsingBD2(child.listbox.sliderFrame)
						Skinner:applySkin(child)
					end
				end
			end
		end

	end

	if MSBTMainOptionsFrame then
		skinMSBTOptions()
	else
		self:SecureHook(MSBTOptions.Main, "ShowMainFrame", function()
			skinMSBTOptions()
			self:Unhook(MSBTOptions.Main, "ShowMainFrame")
		end)
	end

end
