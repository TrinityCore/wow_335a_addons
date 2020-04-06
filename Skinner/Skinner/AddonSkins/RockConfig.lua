-- This is a Framework

function Skinner:RockConfig()

--	self:Debug("RockConfig skin ,loaded")

	local function skinRC()

		local function hookChoicePO(obj)

			-- hook this to skin the ChoicePullout
			local btn = obj.button
			if not Skinner:IsHooked(btn, "OnClick") then
				Skinner:HookScript(btn, "OnClick", function(this)
--		 			Skinner:Debug("hookChoicePO: [%s]", this:GetName())
					Skinner.hooks[btn].OnClick(this)
					local framePO = _G["LibRockConfig-1.0_Frame_MainPane_ChoicePullout"]
					if not Skinner.skinned[framePO] then
						Skinner:applySkin(framePO)
					end
					Skinner:Unhook(btn, "OnClick")
				end)
			end

		end

		local frame = _G["LibRockConfig-1.0_Frame"]

		if not Skinner.skinned[frame] then
		-->>--	Main Frame
			Skinner:keepFontStrings(frame)
			Skinner:keepFontStrings(frame.header)
			Skinner:moveObject(frame.titleText, nil, nil, "-", 8)
			Skinner:moveObject(frame.closeButton, "+", 5, "+", 5)
			hookChoicePO(frame.addonChooser)
			Skinner:applySkin(frame.addonChooser.text)
			Skinner:applySkin(frame)
		-->>--	Treeview Frame
			Skinner:skinSlider(frame.treeView.scrollBar)
			Skinner:applySkin(frame.treeView)
		-->>--	Mainpane Frame
			Skinner:skinSlider(frame.mainPane.scrollBar)
			Skinner:applySkin(frame.mainPane)
		end

		if not Skinner:IsHooked(frame.mainPane, "Reposition") then
			-- hook this to allow skinning of choice dropdown text field(s)
			Skinner:SecureHook(frame.mainPane, "Reposition", function(this)
--				Skinner:Debug("LRC.MP_Reposition")
				for _, v in pairs(this.controls) do
--					Skinner:Debug("LRC.MP_R#2: [%s, %s, %s]", v, v:GetName(), v.type)
					if v.type == 'group' and v.groupType == 'inline' then
						for _, v2 in pairs(v.controls) do
--	 						Skinner:Debug("LRC.MP_R#3: [%s, %s, %s]", v2, v2:GetName(), v2.type)
							if v2.type == "choice" and not Skinner.skinned[v2] then
								Skinner:applySkin(_G[v2:GetName().."_Text"])
								hookChoicePO(v2)
							end
						end
					end
					if v.type == "choice"  and not Skinner.skinned[v] then
						Skinner:applySkin(_G[v:GetName().."_Text"])
						hookChoicePO(v)
					end
				end
			end)
		end

	end

	for object in Rock:IterateMixinObjects("LibRockConfig-1.0") do
--		self:Debug("Rock_IMO: [%s]", object)
		self:SecureHook(object, "OpenConfigMenu", function(this)
--			self:Debug("IMO OpenConfigMenu: [%s]", this)
			skinRC()
			self:Unhook(object, "OpenConfigMenu")
		end)
	end
	self:SecureHook(Rock("LibRockConfig-1.0"), "OpenConfigMenu", function(this)
--		self:Debug("LibRockConfig OpenConfigMenu: [%s]", this)
		skinRC()
		self:Unhook(Rock("LibRockConfig-1.0"), "OpenConfigMenu")
	end)

end
