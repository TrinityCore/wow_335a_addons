-- This is a Framework

Skinner.ItemPimper = true -- to stop IP skinning its frame

local objectsToSkin = {}
local AceGUI = LibStub("AceGUI-3.0", true)

if AceGUI then
	Skinner:RawHook(AceGUI, "Create", function(this, objType)
		local obj = Skinner.hooks[this].Create(this, objType)
		objectsToSkin[obj] = objType
		return obj
	end, true)
end

function Skinner:Ace3()

	local bCr, bCg, bCb, bCa = unpack(self.bColour)
	local bbCr, bbCg, bbCb, bbCa = unpack(self.bbColour)

	local function skinAceGUI(obj, objType)


		local objVer = AceGUI.GetWidgetVersion and AceGUI:GetWidgetVersion(objType) or 0
        -- Skinner:Debug("skinAceGUI: [%s, %s, %s]", obj, objType, objVer)
		if obj and not Skinner.skinned[obj] then
			if objType == "BlizOptionsGroup" then
				Skinner:keepFontStrings(obj.frame)
				Skinner:applySkin(obj.frame)
			elseif objType == "Dropdown" then
				Skinner:skinDropDown{obj=obj.dropdown}
				Skinner:applySkin(obj.pullout.frame)
			elseif objType == "Dropdown-Pullout" then
				Skinner:applySkin(obj.frame)
			elseif objType == "DropdownGroup"
			or objType == "InlineGroup"
			or objType == "TabGroup"
			then
				if objVer < 20 then
					Skinner:keepFontStrings(obj.border)
					Skinner:applySkin(obj.border)
				else
					Skinner:keepFontStrings(obj.content:GetParent())
					Skinner:applySkin(obj.content:GetParent())
				end
			elseif objType == "EditBox"
			or objType == "NumberEditBox"
			then
				Skinner:skinEditBox{obj=obj.editbox, regs={9}, noHeight=true}
				Skinner:RawHook(obj.editbox, "SetTextInsets", function(this, left, right, top, bottom)
					return left + 6, right, top, bottom
				end, true)
				Skinner:skinButton{obj=obj.button, as=true}
				if objType == "NumberEditBox" then
					Skinner:skinButton{obj=obj.minus, as=true}
					Skinner:skinButton{obj=obj.plus, as=true}
				end
			elseif objType == "MultiLineEditBox" then
				Skinner:skinButton{obj=obj.button, as=true}
				if objVer < 20 then
					Skinner:skinScrollBar{obj=obj.scrollframe}
					Skinner:applySkin(obj.backdrop)
				else
					Skinner:skinScrollBar{obj=obj.scrollFrame}
					Skinner:applySkin{obj=Skinner:getChild(obj.frame, 2)} -- backdrop frame
				end
			elseif objType == "Slider" then
				Skinner:skinEditBox{obj=obj.editbox, regs={9}, noHeight=true}
				obj.editbox:SetHeight(20)
				obj.editbox:SetWidth(60)
			elseif objType == "Frame" then
				Skinner:keepFontStrings(obj.frame)
				Skinner:applySkin(obj.frame)
				if objVer < 20 then
					Skinner:skinButton{obj=obj.closebutton, y1=1}
					Skinner:applySkin(obj.statusbg)
				else
					Skinner:skinButton{obj=Skinner:getChild(obj.frame, 1), y1=1}
					Skinner:applySkin{obj=Skinner:getChild(obj.frame, 2)} -- backdrop frame
				end
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "Window" then
				Skinner:keepFontStrings(obj.frame)
				Skinner:applySkin(obj.frame)
				Skinner:skinButton{obj=obj.closebutton, cb=true}
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "ScrollFrame" then
				Skinner:keepRegions(obj.scrollbar, {1})
				Skinner:skinUsingBD{obj=obj.scrollbar}
			elseif objType == "TreeGroup" then
				Skinner:keepRegions(obj.scrollbar, {1})
				Skinner:skinUsingBD{obj=obj.scrollbar}
				Skinner:applySkin(obj.border)
				Skinner:applySkin(obj.treeframe)
				if Skinner.modBtns then
					-- hook to manage changes to button textures
					Skinner:SecureHook(obj, "RefreshTree", function()
						for i = 1, #obj.buttons do
							local button = obj.buttons[i]
							if not Skinner.skinned[button.toggle] then
								Skinner:skinButton{obj=button.toggle, mp2=true, plus=true} -- default to plus
							end
						end
					end)
				end
			elseif objType == "Button" then
				Skinner:skinButton{obj=obj.frame, as=true} -- just skin it otherwise text is hidden
			elseif objType == "Keybinding" then
				Skinner:skinButton{obj=obj.button, as=true}
				Skinner:applySkin{obj=obj.msgframe}

			-- Snowflake objects (Producer AddOn)
			elseif objType == "SnowflakeGroup" then
				Skinner:applySkin{obj=obj.frame}
				Skinner:skinSlider{obj=obj.slider, size=2}
				-- hook this for frame refresh
				Skinner:SecureHook(obj, "Refresh", function(this)
					this.frame:SetBackdrop(Skinner.Backdrop[1])
					this.frame:SetBackdropColor(bCr, bCg, bCb, bCa)
					this.frame:SetBackdropBorderColor(bbCr, bbCg, bbCb, bbCa)
				end)
			elseif objType == "SnowflakeEditBox" then
				Skinner:skinEditBox{obj=obj.box, regs={9}, noHeight=true}

			-- Producer objects
			elseif objType == "ProducerHead" then
				Skinner:applySkin{obj=obj.frame}
				Skinner:skinButton{obj=obj.close, cb2=true}
				obj.SetBorder = function() end -- disable background changes

			-- ListBox object (AuctionLite)
			elseif objType == "ListBox" then
				for _, child in pairs{obj.box:GetChildren()} do -- find scroll bar
					if child:IsObjectType("ScrollFrame") then
						child:SetBackdrop(nil)
						Skinner:skinScrollBar{obj=child}
						break
					end
				end
				Skinner:applySkin{obj=obj.box, kfs=true}

			-- LibSharedMedia objects
			elseif objType == "LSM30_Background"
			or objType == "LSM30_Border"
			or objType == "LSM30_Font"
			or objType == "LSM30_Sound"
			or objType == "LSM30_Statusbar"
			then
			    if not Skinner.db.profile.TexturedDD then
			        Skinner:keepFontStrings(obj.frame)
			    else
    				obj.frame.DLeft:SetAlpha(0)
    				obj.frame.DRight:SetAlpha(0)
    				obj.frame.DMiddle:SetHeight(20)
    				obj.frame.DMiddle:SetTexture(Skinner.itTex)
    				obj.frame.DMiddle:SetTexCoord(0, 1, 0, 1)
    				obj.frame.DMiddle:ClearAllPoints()
    				obj.frame.DMiddle:SetPoint("BOTTOMLEFT", obj.frame.DLeft, "RIGHT", -6, -8)
    				obj.frame.DMiddle:SetPoint("BOTTOMRIGHT", obj.frame.DRight, "LEFT", 6, -8)
    			end

			-- ignore these types for now
			elseif objType == "CheckBox"
			or objType == "Dropdown-Item-Execute"
			or objType == "Dropdown-Item-Toggle"
			or objType == "Label"
			or objType == "Heading"
			or objType == "ColorPicker"
			or objType == "SnowflakeButton"
			or objType == "SnowflakeEscape"
			or objType == "SnowflakePlain"
			or objType == "SnowflakeTitle"
			or objType == "SimpleGroup"
			then
			-- any other types
			else
				Skinner:Debug("AceGUI, unmatched type - %s", objType)
			end
		end

	end

	if self:IsHooked(AceGUI, "Create") then
		self:Unhook(AceGUI, "Create")
	end

	self:RawHook(AceGUI, "Create", function(this, objType)
		local obj = self.hooks[this].Create(this, objType)
		if not objectsToSkin[obj] then skinAceGUI(obj, objType) end -- Bugfix: ignore objects awaiting skinning
		return obj
	end, true)

	-- skin any objects created earlier
	for obj in pairs(objectsToSkin) do
		skinAceGUI(obj, objectsToSkin[obj])
	end
	wipe(objectsToSkin)

	-- hook this to skin AGSMW dropdown frame(s)
	local AGSMW = LibStub("AceGUISharedMediaWidgets-1.0", true)
	if AGSMW then
		self:RawHook(AGSMW, "GetDropDownFrame", function(this)
			local frame = self.hooks[this].GetDropDownFrame(this)
			local bdrop = frame:GetBackdrop()
			if bdrop.edgeFile:find("UI-DialogBox-Border", 1, true) then -- if default backdrop
				frame:SetBackdrop(nil)
				if not self.skinFrame[frame] then
					self:skinSlider{obj=frame.slider, size=4}
					self:addSkinFrame{obj=frame, x1=6, y1=-5, x2=-6, y2=5}
				end
			end
			return frame
		end, true)
	end

end
