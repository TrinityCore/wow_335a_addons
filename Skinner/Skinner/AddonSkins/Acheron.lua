if not Skinner:isAddonEnabled("Acheron") then return end

function Skinner:Acheron()

	local obj = Acheron.frame
	self:keepFontStrings(obj.frame)
	obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -8)
	self:applySkin(obj.frame)
	self:applySkin(obj.statusbg)
	
	local kids = obj.children
	-- Filter options
	obj = kids[1] -- InlineGroup object
	self:keepFontStrings(obj.border)
	self:applySkin(obj.border)
	obj = kids[1].children[1] -- Dropdown object
	self:skinDropDown(obj.dropdown)
	self:applySkin(obj.pullout.frame)
	
	-- Report options
	obj = kids[2] -- InlineGroup object
	self:keepFontStrings(obj.border)
	self:applySkin(obj.border)
	obj = kids[2].children[2] -- Dropdown object
	self:skinDropDown(obj.dropdown)
	self:applySkin(obj.pullout.frame)
	obj = kids[2].children[3] -- EditBox object
	self:skinEditBox(obj.editbox, {9}, nil, true)
	self:RawHook(obj.editbox, "SetTextInsets", function(this, left, right, top, bottom)
		return left + 6, right, top, bottom
	end, true)

	-- Death Report panels
	obj = kids[6] -- TreeGroup object
	self:keepRegions(obj.scrollbar, {1})
	self:skinUsingBD2(obj.scrollbar)
	self:applySkin(obj.border)
	self:applySkin(obj.treeframe)
	self:SecureHook(obj, "RefreshTree", function()
		for i = 1, #obj.buttons do
			local button = obj.buttons[i]
			if button and button:GetNormalTexture() then
			    button:GetNormalTexture():SetAlpha(0)
			end
		end
	end)

end
