if not Skinner:isAddonEnabled("TipTac") then return end

function Skinner:TipTac()
	if not self.db.profile.Tooltips.skin then return end

	-- set the TipTac backdrop settings to ours
	TipTac_Config.tipBackdropBG = self.backdrop.bgFile
	TipTac_Config.tipBackdropEdge = self.backdrop.edgeFile
	TipTac_Config.backdropEdgeSize = self.backdrop.edgeSize
	TipTac_Config.backdropInsets = self.backdrop.insets.left
	TipTac_Config.tipColor = CopyTable(self.bColour)
	TipTac_Config.tipBorderColor = CopyTable(self.bbColour)
	TipTac_Config.barTexture = self.sbTexture
	
	-- N.B. The ItemRefTooltip border will be set to reflect the item's quality by TipTac

	-- check to see if settings have been applied yet
	if not TipTac.VARIABLES_LOADED then
		TipTac:ApplySettings()
	end

	-- Anchor frame
	self:skinButton{obj=TipTac.close, cb=true, x1=2, y1=-2, x2=-2, y2=2}
	self:addSkinFrame{obj=TipTac, y1=1, y2=-1, nb=true}
	
end

function Skinner:TipTacOptions()

	local function skinCatPg()

		-- skin DropDowns & EditBoxes
		for _, child in ipairs{TipTacOptions:GetChildren()} do
			if child.InitSelectedItem
			and not Skinner.skinned[child]
			then
				child:SetBackdrop(nil)
				-- add a texture, if required
				if Skinner.db.profile.TexturedDD then
					child.ddTex = child:CreateTexture(nil, "BORDER")
					child.ddTex:SetTexture(Skinner.itTex)
					child.ddTex:ClearAllPoints()
					child.ddTex:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -2)
					child.ddTex:SetPoint("BOTTOMRIGHT", child, "BOTTOMRIGHT", -3, 3)
				end
			elseif child.edit then -- slider editbox
				Skinner:skinEditBox{obj=child.edit, noWidth=true, y=-2}
			elseif child:IsObjectType("EditBox") then
				Skinner:skinEditBox{obj=child, regs={child.text and 15 or nil}, noWidth=true}
			end
		end
		
	end

	-- hook this to skin new objects
	self:SecureHook(TipTacOptions, "BuildCategoryPage", function()
--		self:Debug("TTO_BCP")
		skinCatPg()
	end)

	-- hook this to skin the dropdown menu (also used by Examiner skin)
	if not self:IsHooked(AzDropDown, "ToggleMenu") then
		self:SecureHook(AzDropDown, "ToggleMenu", function(...)
			self:skinScrollBar{obj=_G["AzDropDownScroll"..AzDropDown.vers]}
			self:addSkinFrame{obj=_G["AzDropDownScroll"..AzDropDown.vers]:GetParent()}
			self:Unhook(AzDropDown, "ToggleMenu")
		end)
	end

	-- skin already created objects
	skinCatPg()
	self:addSkinFrame{obj=TipTacOptions.outline}
	self:addSkinFrame{obj=TipTacOptions}

end
