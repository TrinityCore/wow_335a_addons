if not Skinner:isAddonEnabled("AtlasLoot") then return end

function Skinner:AtlasLoot()

-->>--	Default Frame
	AtlasLootDefaultFrame_LootBackground:SetBackdrop(nil)
	self:keepFontStrings(AtlasLootDefaultFrame_LootBackground)
	self:skinEditBox{obj=AtlasLootDefaultFrameSearchBox, regs={9}}
	self:addSkinFrame{obj=AtlasLootDefaultFrame, kfs=true, y1=3}
	-- prevent style being changed
	AtlasLoot_SetNewStyle = function() end
	-- disable button textures
	AtlasLootDefaultFrameWishListButton:DisableDrawLayer("BACKGROUND")
	AtlasLootDefaultFrameSearchButton:DisableDrawLayer("BACKGROUND")
	AtlasLootDefaultFrameSearchClearButton:DisableDrawLayer("BACKGROUND")
	AtlasLootDefaultFrameLastResultButton:DisableDrawLayer("BACKGROUND")

-->>--	Items Frame
	AtlasLootItemsFrame_PREV:DisableDrawLayer("BACKGROUND")
	AtlasLootItemsFrame_NEXT:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=AtlasLootItemsFrame, kfs=true}

-->>--	Loot Panel
	self:skinEditBox(AtlasLootSearchBox, {9})
	self:addSkinFrame{obj=AtlasLootPanel, kfs=true}

-->>-- Filter Options panel
	local function skinFOpts()

		if self.modBtns then
			-- fix for buttons on filter page
			for _, child in pairs{AtlasLootFilterOptionsScrollInhalt:GetChildren()} do
	--			self:Debug("ALFOSI: [%s, %s]", child, self:isButton(child))
				if self:isButton(child) then
					self:skinButton{obj=child, as=true}
				end
			end
		end
		AtlasLootFilterOptionsScrollFrame:SetBackdrop(nil)
		self:addSkinFrame{obj=AtlasLootFilterOptionsScrollFrame:GetParent(), kfs=true, nb=true}
		self:skinScrollBar{obj=AtlasLootFilterOptionsScrollFrame}

	end
	if not AtlasLootFilterOptionsScrollFrame then
		self:SecureHook("AtlasLoot_CreateFilterOptions", function()
			skinFOpts()
			self:Unhook("AtlasLoot_CreateFilterOptions")
		end)
	else skinFOpts() end
-->>-- Wishlist Options panel
	local function skinWOpts()

		AtlasLootWishlistOwnOptionsScrollFrame:SetBackdrop(nil)
		self:skinScrollBar{obj=AtlasLootWishlistOwnOptionsScrollFrame}
		-- WishList Add frame
		self:addSkinFrame{obj=AtlasLootWishList_AddFrame, kfs=true}
		self:skinEditBox{obj=AtlasLootWishListNewName, regs={9}}
		self:skinScrollBar{obj=AtlasLootWishlistAddFrameIconList}

	end
	if not AtlasLootWishlistOwnOptionsScrollFrame then
		self:SecureHook("AtlasLoot_CreateWishlistOptions", function()
			skinWOpts()
			self:Unhook("AtlasLoot_CreateWishlistOptions")
		end)
	else skinWOpts() end
-->>-- Help Options panel
	self:SecureHook("AtlasLoot_DisplayHelp", function()
		AtlasLootHelpFrame_HelpTextFrameScroll:SetBackdrop(nil)
		self:skinScrollBar{obj=AtlasLootHelpFrame_HelpTextFrameScroll}
		self:Unhook("AtlasLoot_DisplayHelp")
	end)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AtlasLootTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(AtlasLootTooltip, "OnShow", function(this)
			self:skinTooltip(AtlasLootTooltip)
		end)
	end

end
