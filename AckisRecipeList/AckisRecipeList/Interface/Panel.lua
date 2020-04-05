--[[
************************************************************************
Panel.lua
************************************************************************
File date: 2010-07-15T11:57:44Z
File hash: be2512a
Project hash: 9458672
Project version: v2.01-8-g9458672
************************************************************************
Please see http://www.wowace.com/addons/arl/ for more information.
************************************************************************
This source code is released under All Rights Reserved.
************************************************************************
@class file
@name Panel.lua
************************************************************************
]]--

-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

local string = _G.string
local sformat = string.format
local strlower = string.lower
local smatch = string.match

local select = _G.select

local table = _G.table

local ipairs, pairs = _G.ipairs, _G.pairs

local tonumber = _G.tonumber
local tostring = _G.tostring

-------------------------------------------------------------------------------
-- Localized Blizzard API.
-------------------------------------------------------------------------------
local GetItemQualityColor = _G.GetItemQualityColor

-- GLOBALS: CreateFrame, GameTooltip, UIParent

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local LibStub = LibStub

local MODNAME	= "Ackis Recipe List"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

local BFAC	= LibStub("LibBabble-Faction-3.0"):GetLookupTable()
local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)

-- Set up the private intra-file namespace.
local private	= select(2, ...)

local Player	= private.Player

-------------------------------------------------------------------------------
-- Upvalues
-------------------------------------------------------------------------------
local AcquireTable = private.AcquireTable
local ReleaseTable = private.ReleaseTable
local SetTextColor = private.SetTextColor
local GenericCreateButton = private.GenericCreateButton
local SetTooltipScripts = private.SetTooltipScripts

local A = private.acquire_types

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local ORDERED_PROFESSIONS	= private.ordered_professions

local FACTION_HORDE		= BFAC["Horde"]
local FACTION_ALLIANCE		= BFAC["Alliance"]
local FACTION_NEUTRAL		= BFAC["Neutral"]

function private.InitializeFrame()
	-------------------------------------------------------------------------------
	-- Create the MainPanel and set its values
	-------------------------------------------------------------------------------
	local MainPanel = CreateFrame("Frame", "ARL_MainPanel", UIParent)

	-- The panel width changes when contracting and expanding - store it for later use.
	MainPanel.normal_width = 384
	MainPanel.expanded_width = 768

	MainPanel:SetWidth(MainPanel.normal_width)
	MainPanel:SetHeight(512)
	MainPanel:SetFrameStrata("MEDIUM")
	MainPanel:SetToplevel(true)
	MainPanel:SetClampedToScreen(true)
	MainPanel:SetClampRectInsets(0, -35, 0, 53)

	MainPanel:SetHitRectInsets(0, 35, 0, 53)
	MainPanel:EnableMouse(true)
	MainPanel:EnableKeyboard(true)
	MainPanel:SetMovable(true)

	MainPanel.is_expanded = false

	-- Let the user banish the MainPanel with the ESC key.
	table.insert(UISpecialFrames, "ARL_MainPanel")
	addon.Frame = MainPanel

	do
		local top_left = MainPanel:CreateTexture(nil, "ARTWORK")
		top_left:SetTexture("Interface\\QuestFrame\\UI-QuestLog-TopLeft")
		top_left:SetPoint("TOPLEFT", MainPanel, "TOPLEFT", 0, 0)
		MainPanel.top_left = top_left

		local top_right = MainPanel:CreateTexture(nil, "ARTWORK")
		top_right:SetTexture("Interface\\QuestFrame\\UI-QuestLog-TopRight")
		top_right:SetPoint("TOPRIGHT", MainPanel, "TOPRIGHT", 0, 0)
		MainPanel.top_right = top_right

		local bottom_left = MainPanel:CreateTexture(nil, "ARTWORK")
		bottom_left:SetTexture("Interface\\QuestFrame\\UI-QuestLog-BotLeft")
		bottom_left:SetPoint("BOTTOMLEFT", MainPanel, "BOTTOMLEFT", 0, 0)
		MainPanel.bottom_left = bottom_left

		local bottom_right = MainPanel:CreateTexture(nil, "ARTWORK")
		bottom_right:SetTexture("Interface\\QuestFrame\\UI-QuestLog-BotRight")
		bottom_right:SetPoint("BOTTOMRIGHT", MainPanel, "BOTTOMRIGHT", 0, 0)
		MainPanel.bottom_right = bottom_right

		local title_bar = MainPanel:CreateFontString(nil, "ARTWORK")
		title_bar:SetFontObject("GameFontHighlightSmall")
		title_bar:SetPoint("TOPLEFT", MainPanel, "TOPLEFT", 20, -20)
		title_bar:SetPoint("TOPRIGHT", MainPanel, "TOPRIGHT", -40, -20)
		title_bar:SetJustifyH("CENTER")
		MainPanel.title_bar = title_bar

		MainPanel:Hide()
	end	-- do block

	-------------------------------------------------------------------------------
	-- MainPanel scripts/functions.
	-------------------------------------------------------------------------------
	MainPanel:SetScript("OnHide",
			    function(self)
				    for spell_id, recipe in pairs(private.recipe_list) do
					    recipe:RemoveState("RELEVANT")
					    recipe:RemoveState("VISIBLE")
				    end
				    addon:ClosePopups()
			    end)

	MainPanel:SetScript("OnMouseDown", MainPanel.StartMoving)

	MainPanel:SetScript("OnMouseUp",
			    function(self, button)
				    self:StopMovingOrSizing()

				    local opts = addon.db.profile.frameopts
				    local from, _, to, x, y = self:GetPoint()

				    opts.anchorFrom = from
				    opts.anchorTo = to

				    if self.is_expanded then
					    if opts.anchorFrom == "TOPLEFT" or opts.anchorFrom == "LEFT" or opts.anchorFrom == "BOTTOMLEFT" then
						    opts.offsetx = x
					    elseif opts.anchorFrom == "TOP" or opts.anchorFrom == "CENTER" or opts.anchorFrom == "BOTTOM" then
						    opts.offsetx = x - 151/2
					    elseif opts.anchorFrom == "TOPRIGHT" or opts.anchorFrom == "RIGHT" or opts.anchorFrom == "BOTTOMRIGHT" then
						    opts.offsetx = x - 151
					    end
				    else
					    opts.offsetx = x
				    end
				    opts.offsety = y
			    end)

	-------------------------------------------------------------------------------
	-- Displays the main GUI frame.
	-------------------------------------------------------------------------------
	function MainPanel:Display(profession, is_linked)
		self.is_linked = is_linked

		-------------------------------------------------------------------------------
		-- Set the profession.
		-------------------------------------------------------------------------------
		local prev_profession = self.profession

		if profession == private.mining_name then
			self.profession = 11 -- Smelting
			self.prof_name = profession
		else
			for index, name in ipairs(ORDERED_PROFESSIONS) do
				if name == profession then
					self.profession = index
					break
				end
			end
			self.prof_name = nil
		end

		if self.profession ~= prev_profession then
			self.prev_profession = self.profession
		end
		self.prof_button:ChangeTexture(private.profession_textures[self.profession])

		local editbox = self.search_editbox

		if self.profession ~= self.prev_profession then
			editbox.prev_search = nil
		end
		editbox:SetText(editbox.prev_search or _G.SEARCH)

		-- If there is no current tab, this is the first time the panel has been
		-- shown so things must be initialized. In this case, MainPanel.list_frame:Update()
		-- will be called by the tab's OnClick handler.
		if not self.current_tab then
			local current_tab = self.tabs[addon.db.profile.current_tab]
			local on_click = current_tab:GetScript("OnClick")

			on_click(current_tab)

			self.current_tab = addon.db.profile.current_tab
		else
			MainPanel.list_frame:Update(nil, false)
		end
		self.sort_button:SetTextures()
		self.filter_toggle:SetTextures()

		self:UpdateTitle()
		self:Show()
	end

	do
		-------------------------------------------------------------------------------
		-- Restore the panel's position on the screen.
		-------------------------------------------------------------------------------
		local function Reset_Position(self)
			local opts = addon.db.profile.frameopts
			local FixedOffsetX = opts.offsetx

			self:ClearAllPoints()

			if opts.anchorTo == "" then	-- no values yet, clamp to whatever frame is appropriate
				if _G.ATSWFrame then
					self:SetPoint("CENTER", _G.ATSWFrame, "CENTER", 490, 0)
				elseif _G.CauldronFrame then
					self:SetPoint("CENTER", _G.CauldronFrame, "CENTER", 490, 0)
				elseif _G.Skillet then
					self:SetPoint("CENTER", _G.SkilletFrame, "CENTER", 468, 0)
				else
					self:SetPoint("TOPLEFT", _G.TradeSkillFrame, "TOPRIGHT", 10, 0)
				end
			else
				if self.is_expanded then
					if opts.anchorFrom == "TOPLEFT" or opts.anchorFrom == "LEFT" or opts.anchorFrom == "BOTTOMLEFT" then
						FixedOffsetX = opts.offsetx
					elseif opts.anchorFrom == "TOP" or opts.anchorFrom == "CENTER" or opts.anchorFrom == "BOTTOM" then
						FixedOffsetX = opts.offsetx + 151/2
					elseif opts.anchorFrom == "TOPRIGHT" or opts.anchorFrom == "RIGHT" or opts.anchorFrom == "BOTTOMRIGHT" then
						FixedOffsetX = opts.offsetx + 151
					end
				end
				self:SetPoint(opts.anchorFrom, UIParent, opts.anchorTo, FixedOffsetX, opts.offsety)
			end
			self:SetScale(addon.db.profile.frameopts.uiscale)
		end

		MainPanel:SetScript("OnShow", Reset_Position)
	end	-- do-block

	do
		local VALID_CATEGORY = {
			["general"]	= true,
			["obtain"]	= true,
			["binding"]	= true,
			["item"]	= true,
			["quality"]	= true,
			["player"]	= true,
			["rep"]		= true,
			["misc"]	= true,
		}

		function MainPanel:ToggleState()
			local x, y = self:GetLeft(), self:GetBottom()

			if self.is_expanded then
				-- Hide the category buttons
				for category in pairs(self.filter_menu) do
					if VALID_CATEGORY[category] then
						self["menu_toggle_" .. category]:Hide()
					end
				end
				self.filter_reset:Hide()
				self.filter_menu:Hide()

				PlaySound("igCharacterInfoClose")

				self:SetWidth(self.normal_width)
				self:SetHitRectInsets(0, 35, 0, 53)
				self:SetClampRectInsets(0, -35, 0, 53)

				self.top_left:SetTexture("Interface\\QuestFrame\\UI-QuestLog-TopLeft")
				self.top_right:SetTexture("Interface\\QuestFrame\\UI-QuestLog-TopRight")
				self.bottom_left:Show()
				self.bottom_right:Show()

				self.xclose_button:ClearAllPoints()
				self.xclose_button:SetPoint("TOPRIGHT", self, "TOPRIGHT", -30, -8)
			else
				local found_active = false

				-- Show the category buttons. If one has been selected, show its information in the panel.
				for category in pairs(MainPanel.filter_menu) do
					local toggle = "menu_toggle_" .. category

					if VALID_CATEGORY[category] then
						MainPanel[toggle]:Show()

						if MainPanel[toggle]:GetChecked() then
							found_active = true
							MainPanel.filter_menu[category]:Show()
							MainPanel.filter_menu:Show()
						end
					end
				end

				-- If nothing was checked, default to the general filters.
				if not found_active then
					MainPanel.menu_toggle_general:SetChecked(true)
					MainPanel.filter_menu.general:Show()
					MainPanel.filter_menu:Show()
				end
				MainPanel.filter_reset:Show()

				PlaySound("igCharacterInfoOpen")

				self:SetWidth(self.expanded_width)
				self:SetHitRectInsets(0, 90, 0, 53)
				self:SetClampRectInsets(0, -90, 0, 53)

				self.top_left:SetTexture("Interface\\QuestFrame\\UI-QuestLogDualPane-Left")
				self.top_right:SetTexture("Interface\\QuestFrame\\UI-QuestLogDualPane-Right")
				self.bottom_left:Hide()
				self.bottom_right:Hide()

				self.xclose_button:ClearAllPoints()
				self.xclose_button:SetPoint("TOPRIGHT", self, "TOPRIGHT", -84, -8)
			end
			self.is_expanded = not self.is_expanded

			self:ClearAllPoints()
			self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y)
			self:UpdateTitle()
		end
	end	-- do-block

	function MainPanel:UpdateTitle()
		local current_prof = ORDERED_PROFESSIONS[self.profession]

		if not self.is_expanded then
			self.title_bar:SetFormattedText(SetTextColor(private.basic_colors["normal"], "ARL (%s) - %s"), addon.version, current_prof)
			return
		end
		local total, active = 0, 0

		for filter, info in pairs(self.filter_menu.value_map) do
			if info.svroot then
				if info.svroot[filter] == true then
					active = active + 1
				end
				total = total + 1
			end
		end
		self.title_bar:SetFormattedText(SetTextColor(private.basic_colors["normal"], "ARL (%s) - %s (%d/%d %s)"), addon.version, current_prof, active, total, _G.FILTERS)
	end

	-------------------------------------------------------------------------------
	-- Create the profession-cycling button and assign its values.
	-------------------------------------------------------------------------------
	local ProfCycle = CreateFrame("Button", nil, MainPanel, "UIPanelButtonTemplate")
	ProfCycle:SetWidth(64)
	ProfCycle:SetHeight(64)
	ProfCycle:SetPoint("TOPLEFT", MainPanel, "TOPLEFT", 5, -4)
	ProfCycle:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	ProfCycle._normal = ProfCycle:CreateTexture(nil, "BACKGROUND")
	ProfCycle._pushed = ProfCycle:CreateTexture(nil, "BACKGROUND")
	ProfCycle._disabled = ProfCycle:CreateTexture(nil, "BACKGROUND")

	MainPanel.prof_button = ProfCycle

	-------------------------------------------------------------------------------
	-- ProfCycle scripts/functions.
	-------------------------------------------------------------------------------
	ProfCycle:SetScript("OnClick",
			    function(self, button, down)
				    -- Known professions should be in Player.professions

				    -- This loop is gonna be weird. The reason is because we need to
				    -- ensure that we cycle through all the known professions, but also
				    -- that we do so in order. That means that if the currently displayed
				    -- profession is the last one in the list, we're actually going to
				    -- iterate completely once to get to the currently displayed profession
				    -- and then iterate again to make sure we display the next one in line.
				    -- Further, there is the nuance that the person may not know any
				    -- professions yet at all. Users are so annoying.
				    local startLoop = 0
				    local endLoop = 0
				    local displayProf = 0

				    local NUM_PROFESSIONS = 12

				    -- ok, so first off, if we've never done this before, there is no "current"
				    -- and a single iteration will do nicely, thank you
				    if button == "LeftButton" then
					    -- normal profession switch
					    if MainPanel.profession == 0 then
						    startLoop = 1
						    endLoop = NUM_PROFESSIONS + 1
					    else
						    startLoop = MainPanel.profession + 1
						    endLoop = MainPanel.profession
					    end
					    local index = startLoop

					    while index ~= endLoop do
						    if index > NUM_PROFESSIONS then
							    index = 1
						    elseif Player.professions[ORDERED_PROFESSIONS[index]] then
							    displayProf = index
							    MainPanel.profession = index
							    break
						    else
							    index = index + 1
						    end
					    end
				    elseif button == "RightButton" then
					    -- reverse profession switch
					    if MainPanel.profession == 0 then
						    startLoop = NUM_PROFESSIONS + 1
						    endLoop = 0
					    else
						    startLoop = MainPanel.profession - 1
						    endLoop = MainPanel.profession
					    end
					    local index = startLoop

					    while index ~= endLoop do
						    if index < 1 then
							    index = NUM_PROFESSIONS
						    elseif Player.professions[ORDERED_PROFESSIONS[index]] then
							    displayProf = index
							    MainPanel.profession = index
							    break
						    else
							    index = index - 1
						    end
					    end
				    end
				    local trade_frame = _G.GnomeWorksFrame or _G.Skillet or _G.MRTSkillFrame or _G.ATSWFrame or _G.CauldronFrame or _G.TradeSkillFrame
				    local is_shown = trade_frame:IsVisible()
				    local sfx

				    PlaySound("igCharacterNPCSelect")

				    -- If not shown, save the current sound effects setting then set it to 0.
				    if not is_shown then
					    sfx = tonumber(GetCVar("Sound_EnableSFX"))
					    SetCVar("Sound_EnableSFX", 0)
				    end
				    CastSpellByName(ORDERED_PROFESSIONS[MainPanel.profession])
				    addon:Scan()

				    if not is_shown then
					    CloseTradeSkill()
					    SetCVar("Sound_EnableSFX", sfx)
				    end
			    end)

	function ProfCycle:ChangeTexture(texture)
		local normal, pushed, disabled = self._normal, self._pushed, self._disabled

		normal:SetTexture([[Interface\Addons\AckisRecipeList\img\]] .. texture .. [[_up]])
		normal:SetTexCoord(0, 1, 0, 1)
		normal:SetAllPoints(self)
		self:SetNormalTexture(normal)

		pushed:SetTexture([[Interface\Addons\AckisRecipeList\img\]] .. texture .. [[_down]])
		pushed:SetTexCoord(0, 1, 0, 1)
		pushed:SetAllPoints(self)
		self:SetPushedTexture(pushed)

		disabled:SetTexture([[Interface\Addons\AckisRecipeList\img\]] .. texture .. [[_up]])
		disabled:SetTexCoord(0, 1, 0, 1)
		disabled:SetAllPoints(self)
		self:SetDisabledTexture(disabled)
	end

	-------------------------------------------------------------------------------
	-- The search entry box and associated methods.
	-------------------------------------------------------------------------------
	local SearchRecipes
	do
		local acquire_names = private.acquire_names
		local location_list = private.location_list

		local search_params = {
			"name",
			"skill_level",
			--[===[@debug@
			-- "item_id",
			--@end-debug@]===]
			"specialty",
		}
		-- Scans through the recipe database and toggles the flag on if the item is in the search criteria
		function SearchRecipes(pattern)
			if not pattern then
				return
			end
			local current_prof = ORDERED_PROFESSIONS[MainPanel.profession]

			pattern = pattern:lower()

			for index, entry in pairs(private.recipe_list) do
				entry:RemoveState("RELEVANT")

				if entry.profession == current_prof then
					local found = false

					for index, field in ipairs(search_params) do
						local str = entry[field] and tostring(entry[field]):lower() or nil

						if str and str:find(pattern) then
							entry:AddState("RELEVANT")
							found = true
							break
						end
					end

					if not found then
						for acquire_type in pairs(acquire_names) do
							local str = acquire_names[acquire_type]:lower()

							if str and str:find(pattern) and entry.acquire_data[acquire_type] then
								entry:AddState("RELEVANT")
								found = true
								break
							end
						end
					end

					if not found then
						for location_name in pairs(location_list) do
							local breakout = false

							for spell_id in pairs(location_list[location_name].recipes) do
								if spell_id == entry.spell_id then
									local str = location_name:lower()

									if str and str:find(pattern) then
										entry:AddState("RELEVANT")
										breakout = true
										break
									end
								end
							end

							if breakout then
								break
							end
						end
					end
				end
			end	-- if entry.profession
		end	-- for
	end	-- do

	-------------------------------------------------------------------------------
	-- Search EditBox
	-------------------------------------------------------------------------------
	local SearchBox = CreateFrame("EditBox", nil, MainPanel, "InputBoxTemplate")

	SearchBox:EnableMouse(true)
	SearchBox:SetAutoFocus(false)
	SearchBox:SetFontObject(ChatFontSmall)
	SearchBox:SetWidth(130)
	SearchBox:SetHeight(12)
	SearchBox:SetPoint("TOPLEFT", MainPanel, "TOPLEFT", 75, -39)
	SearchBox:Show()

	MainPanel.search_editbox = SearchBox

	SearchBox:SetText(_G.SEARCH)
	SearchBox:SetHistoryLines(10)

	-- Allow removal of focus from the SearchBox by clicking on the WorldFrame.
	do
		local old_x, old_y, click_time

		WorldFrame:HookScript("OnMouseDown",
				      function(frame, ...)
					      if not SearchBox:HasFocus() then
						      return
					      end
					      old_x, old_y = GetCursorPosition()
					      click_time = GetTime()
				      end)

		WorldFrame:HookScript("OnMouseUp",
				      function(frame, ...)
					      if not SearchBox:HasFocus() then
						      return
					      end
					      local x, y = GetCursorPosition()

					      if not old_x or not old_y or not x or not y or not click_time then
						      SearchBox:ClearFocus()
						      return
					      end

					      if (_G.math.abs(x - old_x) + _G.math.abs(y - old_y)) <= 5 and GetTime() - click_time < .5 then
						      SearchBox:ClearFocus()
					      end
				      end)
	end

	-- Resets the SearchBox text and the state of all MainPanel.list_frame and recipe_list entries.
	function SearchBox:Reset()
		for index, recipe in pairs(private.recipe_list) do
			recipe:RemoveState("RELEVANT")
		end
		self.prev_search = nil

		self:SetText(_G.SEARCH)

		if self:HasFocus() then
			self:HighlightText()
		end
		MainPanel.list_frame:Update(nil, false)
	end

	-- If there is text in the search box, return the recipe's RELEVANT state.
	function SearchBox:MatchesRecipe(recipe)
		local editbox_text = self:GetText()

		if editbox_text ~= "" and editbox_text ~= _G.SEARCH then
			return recipe:HasState("RELEVANT")
		end
		return true
	end

	SearchBox:SetScript("OnEnterPressed",
			    function(self)
				    local searchtext = self:GetText()
				    searchtext = searchtext:trim()

				    if not searchtext or searchtext == "" then
					    self:Reset()
					    return
				    end
				    self:HighlightText()

				    if searchtext == _G.SEARCH then
					    return
				    end
				    self.prev_search = searchtext

				    self:AddHistoryLine(searchtext)
				    SearchRecipes(searchtext)
				    MainPanel.list_frame:Update(nil, false)
			    end)

	SearchBox:SetScript("OnEditFocusGained", SearchBox.HighlightText)

	SearchBox:SetScript("OnEditFocusLost",
			    function(self)
				    local text = self:GetText()

				    if text == "" or text == _G.SEARCH then
					    self:Reset()
					    return
				    end

				    -- Ensure that the highlight is cleared.
				    self:SetText(text)

				    self:AddHistoryLine(text)
			    end)


	SearchBox:SetScript("OnTextSet",
			    function(self)
				    local text = self:GetText()

				    if text ~= "" and text ~= _G.SEARCH and text ~= self.prev_search then
					    self:HighlightText()
				    else
					    self:Reset()
				    end
			    end)

	do
		local last_update = 0
		local updater = CreateFrame("Frame", nil, UIParent)

		updater:Hide()
		updater:SetScript("OnUpdate",
				  function(self, elapsed)
					  last_update = last_update + elapsed

					  if last_update >= 0.5 then
						  last_update = 0

						  SearchRecipes(SearchBox:GetText())
						  MainPanel.list_frame:Update(nil, false)
						  self:Hide()
					  end
				  end)

		SearchBox:SetScript("OnTextChanged",
				    function(self, is_typed)
					    if not is_typed then
						    return
					    end
					    local text = self:GetText()

					    if text ~= "" and text ~= _G.SEARCH and text ~= self.prev_search then
						    updater:Show()
					    else
						    self:Reset()
					    end
				    end)
	end	-- do

	-------------------------------------------------------------------------------
	-- Create the expand button and set its scripts.
	-------------------------------------------------------------------------------
	local ExpandButtonFrame = CreateFrame("Frame", nil, MainPanel)

	ExpandButtonFrame:SetHeight(20)
	ExpandButtonFrame:SetPoint("TOPLEFT", SearchBox, "BOTTOMLEFT", -12, -5)

	ExpandButtonFrame.left = ExpandButtonFrame:CreateTexture(nil, "BACKGROUND")
	ExpandButtonFrame.left:SetWidth(8)
	ExpandButtonFrame.left:SetHeight(22)
	ExpandButtonFrame.left:SetPoint("TOPLEFT", ExpandButtonFrame, 0, 4)
	ExpandButtonFrame.left:SetTexture("Interface\\QuestFrame\\UI-QuestLogSortTab-Left")

	ExpandButtonFrame.right = ExpandButtonFrame:CreateTexture(nil, "BACKGROUND")
	ExpandButtonFrame.right:SetWidth(8)
	ExpandButtonFrame.right:SetHeight(22)
	ExpandButtonFrame.right:SetPoint("TOPRIGHT", ExpandButtonFrame, 0, 4)
	ExpandButtonFrame.right:SetTexture("Interface\\QuestFrame\\UI-QuestLogSortTab-Right")

	ExpandButtonFrame.middle = ExpandButtonFrame:CreateTexture(nil, "BACKGROUND")
	ExpandButtonFrame.middle:SetHeight(22)
	ExpandButtonFrame.middle:SetPoint("LEFT", ExpandButtonFrame.left, "RIGHT")
	ExpandButtonFrame.middle:SetPoint("RIGHT", ExpandButtonFrame.right, "LEFT")
	ExpandButtonFrame.middle:SetTexture("Interface\\QuestFrame\\UI-QuestLogSortTab-Middle")

	local ExpandButton = GenericCreateButton(nil, MainPanel, 16, 16, "GameFontNormalSmall", _G.ALL, "LEFT", L["EXPANDALL_DESC"], 2)

	-- Make sure the button frame is large enough to hold the localized word for "All"
	ExpandButtonFrame:SetWidth(27 + ExpandButton:GetFontString():GetStringWidth())

	MainPanel.expand_button = ExpandButton

	ExpandButton:SetPoint("LEFT", ExpandButtonFrame.left, "RIGHT", -3, -3)

	ExpandButton.text:ClearAllPoints()
	ExpandButton.text:SetPoint("LEFT", ExpandButton, "Right", 0, 0)

	ExpandButton:SetScript("OnClick",
			       function(self, mouse_button, down)
				       local current_tab = MainPanel.tabs[MainPanel.current_tab]
				       local expanded = current_tab["expand_button_"..MainPanel.profession]
				       local expand_mode

				       if not expanded then
					       if _G.IsShiftKeyDown() then
						       expand_mode = "deep"
					       else
						       expand_mode = "normal"
					       end
				       else
					       local prof_name = ORDERED_PROFESSIONS[MainPanel.profession]

					       table.wipe(current_tab[prof_name.." expanded"])
				       end
				       -- MainPanel.list_frame:Update() must be called before the button can be expanded or contracted, since
				       -- the button is contracted from there.
				       -- If expand_mode is nil, that means expand nothing.
				       MainPanel.list_frame:Update(expand_mode, false)

				       if expanded then
					       self:Contract(current_tab)
				       else
					       self:Expand(current_tab)
				       end
			       end)

	function ExpandButton:Expand(current_tab)
		current_tab["expand_button_"..MainPanel.profession] = true

		self:SetNormalTexture("Interface\\BUTTONS\\UI-MinusButton-Up")
		self:SetPushedTexture("Interface\\BUTTONS\\UI-MinusButton-Down")
		self:SetHighlightTexture("Interface\\BUTTONS\\UI-PlusButton-Hilight")
		self:SetDisabledTexture("Interface\\BUTTONS\\UI-MinusButton-Disabled")

		SetTooltipScripts(self, L["CONTRACTALL_DESC"])
	end

	function ExpandButton:Contract(current_tab)
		current_tab["expand_button_"..MainPanel.profession] = nil

		self:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
		self:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
		self:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
		self:SetDisabledTexture("Interface\\Buttons\\UI-PlusButton-Disabled")

		SetTooltipScripts(self, L["EXPANDALL_DESC"])
	end

	-------------------------------------------------------------------------------
	-- "Skill Level" checkbox.
	-------------------------------------------------------------------------------
	local SkillToggle = CreateFrame("CheckButton", nil, MainPanel, "UICheckButtonTemplate")
	SkillToggle:SetPoint("TOPLEFT", SearchBox, "TOPRIGHT", 0, 0)
	SkillToggle:SetHeight(16)
	SkillToggle:SetWidth(16)

	SkillToggle.text = SkillToggle:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	SkillToggle.text:SetPoint("LEFT", SkillToggle, "RIGHT", 0, 0)

	SkillToggle:SetScript("OnClick",
			      function(self, button, down)
				      addon.db.profile.skill_view = not addon.db.profile.skill_view
				      MainPanel.list_frame:Update(nil, false)
			      end)

	SkillToggle:SetScript("OnShow",
			      function(self)
				      self:SetChecked(addon.db.profile.skill_view)
			      end)

	SkillToggle.text:SetText(_G.SKILL)
	SetTooltipScripts(SkillToggle, L["SKILL_TOGGLE_DESC"], 1)

	-------------------------------------------------------------------------------
	-- "Display Exclusions" checkbox.
	-------------------------------------------------------------------------------
	local ExcludeToggle = CreateFrame("CheckButton", nil, MainPanel, "UICheckButtonTemplate")
	ExcludeToggle:SetPoint("TOP", SkillToggle, "BOTTOM", 0, 1)
	ExcludeToggle:SetHeight(16)
	ExcludeToggle:SetWidth(16)

	ExcludeToggle.text = ExcludeToggle:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	ExcludeToggle.text:SetPoint("LEFT", ExcludeToggle, "RIGHT", 0, 0)

	ExcludeToggle:SetScript("OnClick",
				function(self, button, down)
					addon.db.profile.ignoreexclusionlist = not addon.db.profile.ignoreexclusionlist
					MainPanel.list_frame:Update(nil, false)
				end)

	ExcludeToggle:SetScript("OnShow",
				function(self)
					self:SetChecked(addon.db.profile.ignoreexclusionlist)
				end)

	ExcludeToggle.text:SetText(L["Display Exclusions"])
	SetTooltipScripts(ExcludeToggle, L["DISPLAY_EXCLUSION_DESC"], 1)

	-------------------------------------------------------------------------------
	-- Create the X-close button, and set its scripts.
	-------------------------------------------------------------------------------
	MainPanel.xclose_button = CreateFrame("Button", nil, MainPanel, "UIPanelCloseButton")
	MainPanel.xclose_button:SetPoint("TOPRIGHT", MainPanel, "TOPRIGHT", -30, -8)

	MainPanel.xclose_button:SetScript("OnClick",
					  function(self, button, down)
						  MainPanel:Hide()
					  end)

	-------------------------------------------------------------------------------
	-- Create MainPanel.filter_toggle, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local function Toggle_OnClick(self, button, down)
			-- The first time this button is clicked, everything in the expanded section of the MainPanel must be created.
			if private.InitializeFilterPanel then
				private.InitializeFilterPanel()
			end
			SetTooltipScripts(self, MainPanel.is_expanded and L["FILTER_OPEN_DESC"] or L["FILTER_CLOSE_DESC"])

			MainPanel:ToggleState()
			self:SetTextures()
		end

		local filter_toggle = GenericCreateButton(nil, MainPanel, 24, 24, nil, nil, nil, L["FILTER_OPEN_DESC"], 2)
		filter_toggle:SetPoint("TOPLEFT", MainPanel, "TOPLEFT", 323, -41)

		filter_toggle:SetScript("OnClick", Toggle_OnClick)

		filter_toggle:SetHighlightTexture([[Interface\CHATFRAME\UI-ChatIcon-BlinkHilight]])
		
		function filter_toggle:SetTextures()
			if MainPanel.is_expanded then
				self:SetNormalTexture([[Interface\BUTTONS\UI-SpellbookIcon-PrevPage-Up]])
				self:SetPushedTexture([[Interface\BUTTONS\UI-SpellbookIcon-PrevPage-Down]])
				self:SetDisabledTexture([[Interface\BUTTONS\UI-SpellbookIcon-PrevPage-Disabled]])
			else
				self:SetNormalTexture([[Interface\BUTTONS\UI-SpellbookIcon-NextPage-Up]])
				self:SetPushedTexture([[Interface\BUTTONS\UI-SpellbookIcon-NextPage-Down]])
				self:SetDisabledTexture([[Interface\BUTTONS\UI-SpellbookIcon-NextPage-Disabled]])
			end
		end
		MainPanel.filter_toggle = filter_toggle
	end	-- do-block

	-------------------------------------------------------------------------------
	-- Sort-mode toggle button.
	-------------------------------------------------------------------------------
	local SortToggle = GenericCreateButton(nil, MainPanel, 24, 24, nil, nil, nil, L["SORTING_DESC"], 2)

	MainPanel.sort_button = SortToggle

	SortToggle:SetPoint("LEFT", ExpandButtonFrame, "RIGHT", 0, 2)

	SortToggle:SetScript("OnClick",
			     function(self, button, down)
				     local sort_type = addon.db.profile.sorting

				     addon.db.profile.sorting = (sort_type == "Ascending" and "Descending" or "Ascending")

				     self:SetTextures()
				     MainPanel.list_frame:Update(nil, false)
			     end)

	SortToggle:SetHighlightTexture([[Interface\CHATFRAME\UI-ChatIcon-BlinkHilight]])

	function SortToggle:SetTextures()
		local sort_type = addon.db.profile.sorting

		if sort_type == "Ascending" then
			self:SetNormalTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollDown-Up]])
			self:SetPushedTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollDown-Down]])
			self:SetDisabledTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollDown-Disabled]])
		else
			self:SetNormalTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollUp-Up]])
			self:SetPushedTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollUp-Down]])
			self:SetDisabledTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollUp-Disabled]])
		end
	end

	-------------------------------------------------------------------------------
	-- Create MainPanel.progress_bar and set its scripts
	-------------------------------------------------------------------------------
	do
		local progress_bar = CreateFrame("StatusBar", nil, MainPanel)
		progress_bar:SetWidth(216)
		progress_bar:SetHeight(18)
		progress_bar:SetPoint("BOTTOMLEFT", MainPanel, 17, 80)
		progress_bar:SetBackdrop({
						 bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
						 tile = true,
						 tileSize = 16,
					 })

		progress_bar:SetStatusBarTexture([[Interface\TARGETINGFRAME\UI-StatusBar]])
		progress_bar:SetOrientation("HORIZONTAL")
		progress_bar:SetStatusBarColor(0.37, 0.45, 1.0)

		local border = progress_bar:CreateTexture(nil, "OVERLAY")
		border:SetWidth(288)
		border:SetHeight(78)
		border:SetPoint("TOPLEFT", progress_bar, "TOPLEFT", -36, 31)
		border:SetTexture([[Interface\CastingBar\UI-CastingBar-Border]])

		local text = progress_bar:CreateFontString(nil, "ARTWORK")
		text:SetWidth(195)
		text:SetHeight(14)
		text:SetFontObject("GameFontHighlightSmall")
		text:SetPoint("CENTER", progress_bar, "CENTER", 0, 0)
		text:SetJustifyH("CENTER")
		text:SetJustifyV("CENTER")

		progress_bar.text = text
		MainPanel.progress_bar = progress_bar
	end	-- do

	-------------------------------------------------------------------------------
	-- Create the close button, and set its scripts.
	-------------------------------------------------------------------------------
	MainPanel.close_button = GenericCreateButton(nil, MainPanel, 24, 111, "GameFontNormalSmall", _G.EXIT, "CENTER", L["CLOSE_DESC"], 1)
	MainPanel.close_button:SetPoint("LEFT", MainPanel.progress_bar, "RIGHT", 3, 1)

	MainPanel.close_button:SetScript("OnClick",
					 function(self, button, down)
						 MainPanel:Hide()
					 end)

	-------------------------------------------------------------------------------
	-- Initialize components defined in other files.
	-------------------------------------------------------------------------------
	private.InitializeListFrame()
	private.InitializeTabs()

	private.InitializeFrame = nil
end
