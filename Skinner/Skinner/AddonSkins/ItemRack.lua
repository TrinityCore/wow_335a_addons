if not Skinner:isAddonEnabled("ItemRack") then return end

function Skinner:ItemRack()

	self:addSkinFrame{obj=ItemRackMenuFrame}

end

if not Skinner:isAddonEnabled("ItemRackOptions") then return end

function Skinner:ItemRackOptions()

	self:addSkinFrame{obj=ItemRackOptFrame}

	for i = 1, 8 do
		local frame = _G["ItemRackOptSubFrame"..i]
		frame:SetBackdrop(nil)
		self:keepFontStrings(frame)
	end

-->>--	Events frame (sub frame 3)
	self:addSkinFrame{obj=ItemRackOptEventListFrame, kfs=true}
	self:skinScrollBar{obj=ItemRackOptEventListScrollFrame}

-->>--	Queues frame (sub frame 4)

-->>--	Config frame (sub frame 1)
	self:skinEditBox(ItemRackOptButtonSpacing, {9})
	self:skinEditBox(ItemRackOptAlpha, {9})
	self:skinEditBox(ItemRackOptMainScale, {9})
	self:skinEditBox(ItemRackOptMenuScale, {9})
	self:skinScrollBar{obj=ItemRackOptListScrollFrame}

-->>--	Sets frame (sub frame 2)
	self:skinEditBox(ItemRackOptSetsName, {9})
	self:skinScrollBar{obj=ItemRackOptSetsIconScrollFrame}
	self:addSkinFrame{obj=ItemRackOptSetsIconFrame, kfs=true}

-->>--	Pick Sets frame (sub frame 5)
	self:skinScrollBar{obj=ItemRackOptSetListScrollFrame}
	self:addSkinFrame{obj=self:getChild(ItemRackOptSubFrame5, 1), kfs=true}

-->>--	Binder frame
	ItemRackOptBindFrame:SetBackdrop(nil)
	self:keepFontStrings(ItemRackOptBindFrame)

-->>--	Slot keybindings frame (sub frame 6)

-->>-- Queue Events frame (sub frame 7)
	self:addSkinFrame{obj=self:getChild(ItemRackOptSubFrame7, 2), kfs=true}
	self:skinScrollBar{obj=ItemRackOptSortListScrollFrame}
	self:skinEditBox(ItemRackOptItemStatsDelay, {9})

-->>-- Event Edit frame (sub frame 8)
	self:skinEditBox{obj=ItemRackOptEventEditNameEdit, regs={9}}
	if not self.db.profile.TexturedDD then
		self:keepFontStrings(ItemRackOptEventEditTypeDrop)
	else
		ItemRackOptEventEditTypeDropTextureLeft:SetAlpha(0)
		ItemRackOptEventEditTypeDropTextureRight:SetAlpha(0)
		local midTex = ItemRackOptEventEditTypeDropTextureMiddle
		midTex:SetHeight(18)
		midTex:SetTexture(self.itTex)
		midTex:SetTexCoord(0, 1, 0, 1)
		-- move the middle texture
		midTex:ClearAllPoints()
		midTex:SetPoint("TOPLEFT", ItemRackOptEventEditTypeDrop, "TOPLEFT", -2, -1)
		midTex:SetPoint("BOTTOMRIGHT", ItemRackOptEventEditTypeDrop, "BOTTOMRIGHT", 0, 1)
	end
	self:addSkinFrame{obj=ItemRackOptEventEditPickTypeFrame, kfs=true}
	self:skinEditBox{obj=ItemRackOptEventEditBuffName, regs={9}}
	self:keepFontStrings(ItemRackOptEventEditBuffFrame)
	self:skinEditBox{obj=ItemRackOptEventEditStanceName, regs={9}}
	self:keepFontStrings(ItemRackOptEventEditStanceFrame)
	self:skinScrollBar{obj=ItemRackOptEventEditZoneEditScrollFrame}
	self:addSkinFrame{obj=ItemRackOptEventEditZoneEditBackdrop, kfs=true}
	self:keepFontStrings(ItemRackOptEventEditZoneFrame)
	self:skinEditBox{obj=ItemRackOptEventEditScriptTrigger, regs={9}}
	self:skinScrollBar{obj=ItemRackOptEventEditScriptEditScrollFrame}
	self:addSkinFrame{obj=ItemRackOptEventEditScriptEditBackdrop, kfs=true}
	
-->>-- Floating Editor frame
	self:addSkinFrame{obj=ItemRackFloatingEditorEditFrame}
	self:skinScrollBar{obj=ItemRackFloatingEditorScrollFrame}
	ItemRackFloatingEditorScrollFrame:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=ItemRackFloatingEditor}

end
