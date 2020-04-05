--------------------------------------------------------------------------------
-- Setup
--

local oRA = LibStub("AceAddon-3.0"):GetAddon("oRA3")
local module = oRA:NewModule("Cooldowns", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("oRA3")
local AceGUI = LibStub("AceGUI-3.0")
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")

module.VERSION = tonumber(("$Revision: 437 $"):sub(12, -3))

--------------------------------------------------------------------------------
-- Locals
--

local mType = media and media.MediaType and media.MediaType.STATUSBAR or "statusbar"
local playerName = UnitName("player")
local _, playerClass = UnitClass("player")
local bloodlustId = UnitFactionGroup("player") == "Alliance" and 32182 or 2825
local runningCooldowns = {}

local glyphCooldowns = {
	[55455] = {2894, 300},   -- Fire Elemental Totem, 5min
	[58618] = {47476, 20},   -- Strangulate, 20sec
	[56373] = {31687, 30},   -- Summon Water Elemental, 30sec
	[63229] = {47585, 45},   -- Dispersion, 45sec
	[63329] = {871, 120},    -- Shield Wall, 2min
	[57903] = {5384, 5},     -- Feign Death, 5sec
	[57858] = {5209, 30},    -- Challenging Roar, 30sec
	[55678] = {6346, 60},    -- Fear Ward, 60sec
	[58376] = {12975, 60},   -- Last Stand, 1min
	[57955] = {48788, 300},  -- Lay on Hands, 5min
	[63252] = {51690, 45},   -- Killing Spree, 45sec
}

local spells = {
	DRUID = {
		[48477] = 600,  -- Rebirth
		[29166] = 180,  -- Innervate
		[17116] = 180,  -- Nature's Swiftness
		[5209] = 180,   -- Challenging Roar
		[61336] = 180,  -- Survival Instincts
		[22812] = 60,   -- Barkskin
	},
	HUNTER = {
		[34477] = 30,   -- Misdirect
		[5384] = 30,    -- Feign Death
		[62757] = 300,  -- Call Stabled Pet
		[781] = 25,     -- Disengage
		[34490] = 20,   -- Silencing Shot
		[13809] = 30,   -- Frost Trap
	},
	MAGE = {
		[45438] = 300,  -- Iceblock
		[2139] = 24,    -- Counterspell
		[31687] = 180,  -- Summon Water Elemental
		[12051] = 240,  -- Evocation
		[66] = 180,     -- Invisibility
	},
	PALADIN = {
		[31821] = 120,  -- Aura Mastery
		[20216] = 120,  -- Divine Favor
		[31842] = 180,  -- Divine Illumination
		[19752] = 600,  -- Divine Intervention
		[642] = 300,    -- Divine Shield
		[64205] = 120,  -- Divine Sacrifice
		[54428] = 60,   -- Divine Plea
		[498] = 180,    -- Divine Protection
		[1044] = 25,    -- Hand of Freedom
		[10278] = 300,  -- Hand of Protection
		[6940] = 120,   -- Hand of Sacrifice
		[1038] = 120,   -- Hand of Salvation
		[48788] = 1200, -- Lay on Hands
		[66233] = 120,  -- Ardent Defender
	},
	PRIEST = {
		[33206] = 180,  -- Pain Suppression
		[47788] = 180,  -- Guardian Spirit
		[6346] = 180,   -- Fear Ward
		[64843] = 480,  -- Divine Hymn
		[64901] = 360,  -- Hymn of Hope
		[34433] = 300,  -- Shadowfiend
		[10060] = 120,  -- Power Infusion
		[47585] = 180,  -- Dispersion
	},
	ROGUE = {
		[31224] = 90,   -- Cloak of Shadows
		[38768] = 10,   -- Kick
		[1725] = 30,    -- Distract
		[13750] = 180,  -- Adrenaline Rush
		[13877] = 120,  -- Blade Flurry
		[14177] = 180,  -- Cold Blood
		[11305] = 180,  -- Sprint
		[26889] = 180,  -- Vanish
		[57934] = 30,   -- Tricks of the Trade
		[2094] = 180,   -- Blind
		[26669] = 180,  -- Evasion
		[14185] = 480,  -- Preparation
		[36554] = 30,   -- Shadowstep
		[14177] = 180,  -- Cold Blood
		[51690] = 120,  -- Killing Spree
		[51713] = 60,   -- Shadow Dance
		[14183] = 20,   -- Premeditation
	},
	SHAMAN = {
		[bloodlustId] = 300, -- Bloodlust/Heroism
		[20608] = 1800, -- Reincarnation
		[16190] = 300,  -- Mana Tide Totem
		[2894] = 600,   -- Fire Elemental Totem
		[2062] = 600,   -- Earth Elemental Totem
		[16188] = 180,  -- Nature's Swiftness
		[57994] = 6,    -- Wind Shear
	},
	WARLOCK = {
		-- [47883] = 900, -- Soulstone Resurrection, removed this spellcast_success is hit with 6203 for all ranks
		[6203] = 900,   -- Soulstone
		[29858] = 180,  -- Soulshatter
		[47241] = 180,  -- Metamorphosis
		[18708] = 900,  -- Fel Domination
		[698] = 120,    -- Ritual of Summoning
		[58887] = 300,  -- Ritual of Souls
	},
	WARRIOR = {
		[871] = 300,    -- Shield Wall
		[1719] = 300,   -- Recklessness
		[20230] = 300,  -- Retaliation
		[12975] = 180,  -- Last Stand
		[6554] = 10,    -- Pummel
		[1161] = 180,   -- Challenging Shout
		[5246] = 180,   -- Intimidating Shout
		[64380] = 300,  -- Shattering Throw (could be 64382)
		[55694] = 180,  -- Enraged Regeneration
		[72] = 12,      -- Shield Bash
	},
	DEATHKNIGHT = {
		[48792] = 120,  -- Icebound Fortitude
		[42650] = 600,  -- Army of the Dead
		[61999] = 600,  -- Raise Ally
		[49028] = 90,   -- Dancing Rune Weapon
		[49206] = 180,  -- Summon Gargoyle
		[47476] = 120,  -- Strangulate
		[49576] = 35,   -- Death Grip
		[51271] = 120,  -- Unbreakable Armor
		[55233] = 60,  -- Vampiric Blood
		[49222] = 120,  -- Bone Shield
		[47528] = 10,   -- Mind Freeze
		[48707] = 45,   -- Anti-Magic Shell
	},
}

-- Special handling of some spells that are only triggered by SPELL_AURA_APPLIED.
local spellAuraApplied = {
	[66233] = true,  -- Ardent Defender
}
local allSpells = {}
local classLookup = {}
for class, spells in pairs(spells) do
	for id, cd in pairs(spells) do
		allSpells[id] = cd
		classLookup[id] = class
	end
end

local classes = {}
do
	local hexColors = {}
	for k, v in pairs(RAID_CLASS_COLORS) do
		hexColors[k] = "|cff" .. string.format("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
	end
	for class in pairs(spells) do
		classes[class] = hexColors[class] .. LOCALIZED_CLASS_NAMES_MALE[class] .. "|r"
	end
	wipe(hexColors)
	hexColors = nil
end

local db = nil
local cdModifiers = {}
local broadcastSpells = {}


local options, restyleBars
local lockDisplay, unlockDisplay, isDisplayLocked, showDisplay, hideDisplay, isDisplayShown
local showPane, hidePane
local textures = media:List(mType)
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = L["Cooldowns"],
			get = function(k) return db[k[#k]] end,
			set = function(k, v)
				local key = k[#k]
				db[key] = v
				if key:find("^bar") then
					restyleBars()
				elseif key == "showDisplay" then
					if v then
						showDisplay()
					else
						hideDisplay()
					end
				elseif key == "lockDisplay" then
					if v then
						lockDisplay()
					else
						unlockDisplay()
					end
				end
			end,
			args = {
				showDisplay = {
					type = "toggle",
					name = L["Show monitor"],
					desc = L["Show or hide the cooldown bar display in the game world."],
					order = 1,
					width = "full",
				},
				lockDisplay = {
					type = "toggle",
					name = L["Lock monitor"],
					desc = L["Note that locking the cooldown monitor will hide the title and the drag handle and make it impossible to move it, resize it or open the display options for the bars."],
					order = 2,
					width = "full",
				},
				onlyShowMine = {
					type = "toggle",
					name = L["Only show my own spells"],
					desc = L["Toggle whether the cooldown display should only show the cooldown for spells cast by you, basically functioning as a normal cooldown display addon."],
					order = 3,
					width = "full",
				},
				neverShowMine = {
					type = "toggle",
					name = L["Never show my own spells"],
					desc = L["Toggle whether the cooldown display should never show your own cooldowns. For example if you use another cooldown display addon for your own cooldowns."],
					order = 4,
					width = "full",
				},
				separator = {
					type = "description",
					name = " ",
					order = 10,
					width = "full",
				},
				shownow = {
					type = "execute",
					name = L["Open monitor"],
					func = showDisplay,
					width = "full",
					order = 11,
				},
				test = {
					type = "execute",
					name = L["Spawn test bar"],
					func = function()
						module:SpawnTestBar()
					end,
					width = "full",
					order = 12,
				},
				settings = {
					type = "group",
					name = L["Bar Settings"],
					order = 20,
					width = "full",
					inline = true,
					args = {
						barClassColor = {
							type = "toggle",
							name = L["Use class color"],
							order = 13,
						},
						barColor = {
							type = "color",
							name = L["Custom color"],
							get = function() return unpack(db.barColor) end,
							set = function(info, r, g, b)
								db.barColor = {r, g, b, 1}
								restyleBars()
							end,
							order = 14,
							disabled = function() return db.barClassColor end,
						},
						barHeight = {
							type = "range",
							name = L["Height"],
							order = 15,
							min = 8,
							max = 32,
							step = 1,
						},
						barScale = {
							type = "range",
							name = L["Scale"],
							order = 15,
							min = 0.1,
							max = 5.0,
							step = 0.1,
						},
						barTexture = {
							type = "select",
							name = L["Texture"],
							order = 17,
							values = textures,
							get = function()
								for i, v in next, textures do
									if v == db.barTexture then
										return i
									end
								end
							end,
							set = function(_, v)
								db.barTexture = textures[v]
								restyleBars()
							end,
						},
						barLabelAlign = {
							type = "select",
							name = L["Label Align"],
							order = 18,
							values = {LEFT = "Left", CENTER = "Center", RIGHT = "Right"},
						},
						barGrowUp = {
							type = "toggle",
							name = L["Grow up"],
							order = 19,
							width = "full",
						},
						show = {
							type = "group",
							name = L["Show"],
							order = 20,
							width = "full",
							inline = true,
							args = {
								barShowIcon = {
									type = "toggle",
									name = L["Icon"],
								},
								barShowDuration = {
									type = "toggle",
									name = L["Duration"],
								},
								barShowUnit = {
									type = "toggle",
									name = L["Unit name"],
								},
								barShowSpell = {
									type = "toggle",
									name = L["Spell name"],
								},
								barShorthand = {
									type = "toggle",
									name = L["Short Spell name"],
								},
							},
						},
					},
				},
			},
		}
	end
	return options
end

--------------------------------------------------------------------------------
-- GUI
--

do
	local frame = nil
	local tmp = {}
	local group = nil

	local function spellCheckboxCallback(widget, event, value)
		local id = widget:GetUserData("id")
		if not id then return end
		db.spells[id] = value and true or false
	end

	local function dropdownGroupCallback(widget, event, key)
		widget:PauseLayout()
		widget:ReleaseChildren()
		wipe(tmp)
		if spells[key] then
			-- Class spells
			for id in pairs(spells[key]) do
				tmp[#tmp + 1] = id
			end
			table.sort(tmp) -- ZZZ Sorted by spell ID, oh well!
			for i, v in next, tmp do
				local name = GetSpellInfo(v)
				if not name then break end
				local checkbox = AceGUI:Create("CheckBox")
				checkbox:SetLabel(name)
				checkbox:SetValue(db.spells[v] and true or false)
				checkbox:SetUserData("id", v)
				checkbox:SetCallback("OnValueChanged", spellCheckboxCallback)
				checkbox:SetFullWidth(true)
				widget:AddChild(checkbox)
			end
		end
		widget:ResumeLayout()
		-- DoLayout the parent to update the scroll bar for the new height of the dropdowngroup
		frame:DoLayout()
	end

	local function createFrame()
		if frame then return end
		frame = AceGUI:Create("ScrollFrame")
		frame:SetLayout("List")

		local moduleDescription = AceGUI:Create("Label")
		moduleDescription:SetText(L["Select which cooldowns to display using the dropdown and checkboxes below. Each class has a small set of spells available that you can view using the bar display. Select a class from the dropdown and then configure the spells for that class according to your own needs."])
		moduleDescription:SetFontObject(GameFontHighlight)
		moduleDescription:SetFullWidth(true)

		group = AceGUI:Create("DropdownGroup")
		group:SetLayout("List")
		group:SetTitle(L["Select class"])
		group:SetGroupList(classes)
		group:SetCallback("OnGroupSelected", dropdownGroupCallback)
		group:SetGroup(playerClass)
		group:SetFullWidth(true)

		if oRA.db.profile.showHelpTexts then
			frame:AddChildren(moduleDescription, group)
		else
			frame:AddChild(group)
		end
	end

	function showPane()
		if not frame then createFrame() end
		oRA:SetAllPointsToPanel(frame.frame, true)
		frame.frame:Show()
	end

	function hidePane()
		if frame then
			frame:Release()
			frame = nil
		end
	end
end

--------------------------------------------------------------------------------
-- Bar display
--

local startBar, setupCooldownDisplay, barStopped, stopAll
do
	local display = nil
	local maximum = 10
	local bars = {}
	local visibleBars = {}
	local locked = nil
	local shown = nil
	function isDisplayLocked() return locked end
	function isDisplayShown() return shown end
	
	function module:GetBars()
		return visibleBars
	end

	local function utf8trunc(text, num)
		local len = 0
		local i = 1
		local text_len = #text
		while len < num and i <= text_len do
			len = len + 1
			local b = text:byte(i)
			if b <= 127 then
				i = i + 1
			elseif b <= 223 then
				i = i + 2
			elseif b <= 239 then
				i = i + 3
			else
				i = i + 4
			end
		end
		return text:sub(1, i-1)
	end

	local shorts = setmetatable({}, {__index =
		function(self, key)
			if type(key) == "nil" then return nil end
			local p1, p2, p3, p4 = string.split(" ", (string.gsub(key,":", " :")))
			if not p2 then
				self[key] = utf8trunc(key, 4)
			elseif not p3 then
				self[key] = utf8trunc(p1, 1) .. utf8trunc(p2, 1)
			elseif not p4 then
				self[key] = utf8trunc(p1, 1) .. utf8trunc(p2, 1) .. utf8trunc(p3, 1)
			else
				self[key] = utf8trunc(p1, 1) .. utf8trunc(p2, 1) .. utf8trunc(p3, 1) .. utf8trunc(p4, 1)
			end
			return self[key]
		end
	})
	
	local function restyleBar(bar)
		bar:SetHeight(db.barHeight)
		bar:SetIcon(db.barShowIcon and bar:Get("ora3cd:icon") or nil)
		bar:SetTimeVisibility(db.barShowDuration)
		bar:SetScale(db.barScale)
		bar:SetTexture(media:Fetch(mType, db.barTexture))
		local spell = bar:Get("ora3cd:spell")
		if db.barShorthand then spell = shorts[spell] end
		if db.barShowSpell and db.barShowUnit and not db.onlyShowMine then
			bar:SetLabel(("%s: %s"):format(bar:Get("ora3cd:unit"), spell))
		elseif db.barShowSpell then
			bar:SetLabel(spell)
		elseif db.barShowUnit and not db.onlyShowMine then
			bar:SetLabel(bar:Get("ora3cd:unit"))
		else
			bar:SetLabel()
		end
		bar.candyBarLabel:SetJustifyH(db.barLabelAlign)
		if db.barClassColor then
			local c = RAID_CLASS_COLORS[bar:Get("ora3cd:unitclass")]
			bar:SetColor(c.r, c.g, c.b, 1)
		else
			bar:SetColor(unpack(db.barColor))
		end
	end
	
	
	function stopAll()
		for bar in pairs(visibleBars) do
			bar:Stop()
		end
	end
	
	local function barSorter(a, b)
		return a.remaining < b.remaining and true or false
	end
	local tmp = {}
	local function rearrangeBars()
		wipe(tmp)
		for bar in pairs(visibleBars) do
			tmp[#tmp + 1] = bar
		end
		table.sort(tmp, barSorter)
		local lastBar = nil
		for i, bar in next, tmp do
			bar:ClearAllPoints()
			if i <= maximum then
				if not lastBar then
					if db.barGrowUp then
						bar:SetPoint("BOTTOMLEFT", display, 4, 4)
						bar:SetPoint("BOTTOMRIGHT", display, -4, 4)
					else
						bar:SetPoint("TOPLEFT", display, 4, -4)
						bar:SetPoint("TOPRIGHT", display, -4, -4)
					end
				else
					if db.barGrowUp then
						bar:SetPoint("BOTTOMLEFT", lastBar, "TOPLEFT")
						bar:SetPoint("BOTTOMRIGHT", lastBar, "TOPRIGHT")
					else
						bar:SetPoint("TOPLEFT", lastBar, "BOTTOMLEFT")
						bar:SetPoint("TOPRIGHT", lastBar, "BOTTOMRIGHT")
					end
				end
				lastBar = bar
				bar:Show()
			else
				bar:Hide()
			end
		end
	end

	function restyleBars()
		for bar in pairs(visibleBars) do
			restyleBar(bar)
		end
		rearrangeBars()
	end
	
	function barStopped(event, bar)
		if visibleBars[bar] then
			visibleBars[bar] = nil
			rearrangeBars()
		end
	end

	local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end
	local function OnDragHandleMouseUp(self, button) self.frame:StopMovingOrSizing() end
	local function onResize(self, width, height)
		oRA3:SavePosition("oRA3CooldownFrame")
		maximum = math.floor(height / db.barHeight)
		-- if we have that many bars shown, hide the ones that overflow
		rearrangeBars()
	end

	local function displayOnMouseDown(self, mouseButton)
		if mouseButton ~= "RightButton" then return end
		InterfaceOptionsFrame_OpenToCategory(L["Cooldowns"])
	end
	
	local function onDragStart(self) self:StartMoving() end
	local function onDragStop(self)
		self:StopMovingOrSizing()
		oRA3:SavePosition("oRA3CooldownFrame")
	end

	function lockDisplay()
		if locked then return end
		if not display then setupCooldownDisplay() end
		display:EnableMouse(false)
		display:SetMovable(false)
		display:SetResizable(false)
		display:RegisterForDrag()
		display:SetScript("OnSizeChanged", nil)
		display:SetScript("OnDragStart", nil)
		display:SetScript("OnDragStop", nil)
		display:SetScript("OnMouseDown", nil)
		display.drag:Hide()
		display.header:Hide()
		display.bg:SetTexture(0, 0, 0, 0)
		locked = true
	end
	function unlockDisplay()
		if not locked then return end
		if not display then setupCooldownDisplay() end
		display:EnableMouse(true)
		display:SetMovable(true)
		display:SetResizable(true)
		display:RegisterForDrag("LeftButton")
		display:SetScript("OnSizeChanged", onResize)
		display:SetScript("OnDragStart", onDragStart)
		display:SetScript("OnDragStop", onDragStop)
		display:SetScript("OnMouseDown", displayOnMouseDown)
		display.bg:SetTexture(0, 0, 0, 0.3)
		display.drag:Show()
		display.header:Show()
		locked = nil
	end
	function showDisplay()
		if not display then setupCooldownDisplay() end
		display:Show()
		shown = true
	end
	function hideDisplay()
		if not display then return end
		display:Hide()
		shown = nil
	end

	local function setup()
		if display then
			if db.showDisplay then showDisplay() end
			return
		end
		display = CreateFrame("Frame", "oRA3CooldownFrame", UIParent)
		display:SetFrameStrata("BACKGROUND")
		display:SetMinResize(100, 20)
		display:SetWidth(200)
		display:SetHeight(148)
		oRA3:RestorePosition("oRA3CooldownFrame")
		local bg = display:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(display)
		bg:SetBlendMode("BLEND")
		bg:SetTexture(0, 0, 0, 0.3)
		display.bg = bg
		local header = display:CreateFontString(nil, "OVERLAY")
		header:SetFontObject(GameFontNormal)
		header:SetText(L["Cooldowns"])
		header:SetPoint("BOTTOM", display, "TOP", 0, 4)
		local help = display:CreateFontString(nil, "HIGHLIGHT")
		help:SetFontObject(GameFontNormal)
		help:SetText(L["Right-Click me for options!"])
		help:SetAllPoints(display)
		display.header = header

		local drag = CreateFrame("Frame", nil, display)
		drag.frame = display
		drag:SetFrameLevel(display:GetFrameLevel() + 10) -- place this above everything
		drag:SetWidth(16)
		drag:SetHeight(16)
		drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
		drag:EnableMouse(true)
		drag:SetScript("OnMouseDown", OnDragHandleMouseDown)
		drag:SetScript("OnMouseUp", OnDragHandleMouseUp)
		drag:SetAlpha(0.5)
		display.drag = drag

		local tex = drag:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\AddOns\\oRA3\\images\\draghandle")
		tex:SetWidth(16)
		tex:SetHeight(16)
		tex:SetBlendMode("ADD")
		tex:SetPoint("CENTER", drag)

		if db.lockDisplay then
			locked = nil
			lockDisplay()
		else
			locked = true
			unlockDisplay()
		end
		if db.showDisplay then
			shown = true
			showDisplay()
		else
			shown = nil
			hideDisplay()
		end
	end
	setupCooldownDisplay = setup
	
	local function start(unit, id, name, icon, duration)
		setup()
		local bar
		for b, v in pairs(visibleBars) do
			if b:Get("ora3cd:unit") == unit and b:Get("ora3cd:spell") == name then
				bar = b
				break
			end
		end
		if not bar then
			bar = candy:New("Interface\\AddOns\\oRA3\\images\\statusbar", display:GetWidth(), db.barHeight)
		end
		visibleBars[bar] = true
		bar:Set("ora3cd:unitclass", classLookup[id])
		bar:Set("ora3cd:unit", unit)
		bar:Set("ora3cd:spell", name)
		bar:Set("ora3cd:icon", icon)
		bar:SetDuration(duration)
		restyleBar(bar)
		bar:Start()
		rearrangeBars()
	end
	startBar = start
end

--------------------------------------------------------------------------------
-- Module
--

function module:OnRegister()
	local database = oRA.db:RegisterNamespace("Cooldowns", {
		profile = {
			spells = {
				[6203] = true,
				[19752] = true,
				[20608] = true,
				[27239] = true,
			},
			showDisplay = true,
			onlyShowMine = nil,
			neverShowMine = nil,
			lockDisplay = false,
			barShorthand = false,
			barHeight = 14,
			barScale = 1.0,
			barShowIcon = true,
			barShowDuration = true,
			barShowUnit = true,
			barShowSpell = true,
			barClassColor = true,
			barGrowUp = false,
			barLabelAlign = "CENTER",
			barColor = { 0.25, 0.33, 0.68, 1 },
			barTexture = "oRA3",
		},
	})
	for k, v in pairs(database.profile.spells) do
		if not classLookup[k] then
			database.profile.spells[k] = nil
		end
	end
	db = database.profile

	oRA:RegisterPanel(
		L["Cooldowns"],
		showPane,
		hidePane
	)

	-- These are the spells we broadcast to the raid
	for spell, cd in pairs(spells[playerClass]) do
		local name = GetSpellInfo(spell)
		if name then broadcastSpells[name] = spell end
	end
	
	if media then
		media:Register(mType, "oRA3", "Interface\\AddOns\\oRA3\\images\\statusbar")
	end
	
	oRA.RegisterCallback(self, "OnStartup")
	oRA.RegisterCallback(self, "OnShutdown")
	candy.RegisterCallback(self, "LibCandyBar_Stop", barStopped)
	oRA:RegisterModuleOptions("CoolDowns", getOptions, L["Cooldowns"])
end

do
	local spellList, reverseClass = nil, nil
	function module:SpawnTestBar()
		if not spellList then
			spellList = {}
			reverseClass = {}
			for k in pairs(allSpells) do spellList[#spellList + 1] = k end
			for name, class in pairs(oRA._testUnits) do reverseClass[class] = name end
		end
		local spell = spellList[math.random(1, #spellList)]
		local name, _, icon = GetSpellInfo(spell)
		if not name then return end
		local unit = reverseClass[classLookup[spell]]
		local duration = (allSpells[spell] / 30) + math.random(1, 120)
		startBar(unit, spell, name, icon, duration)
	end
end

local function getCooldown(spellId)
	local cd = spells[playerClass][spellId]
	if cdModifiers[spellId] then
		cd = cd - cdModifiers[spellId]
	end
	return cd
end

local inGroup = nil
do
	local band = bit.band
	local group = 0x7
	if COMBATLOG_OBJECT_AFFILIATION_MINE then
		group = COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
	end
	function module:ADDON_LOADED(event, addon)
		if addon == "Blizzard_CombatLog" then
			group = COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
		end
	end
	function inGroup(source) return band(source, group) ~= 0 end
end

function module:OnStartup()
	setupCooldownDisplay()
	oRA.RegisterCallback(self, "OnCommCooldown")
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "UpdateCooldownModifiers")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateCooldownModifiers")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_ALIVE", "UpdateCooldownModifiers")
	self:UpdateCooldownModifiers()
	if playerClass == "SHAMAN" then
		-- If we try to check the spell cooldown when UseSoulstone
		-- is invoked, GetSpellCooldown returns 0, so we delay
		-- until SPELL_UPDATE_COOLDOWN.
		self:SecureHook("UseSoulstone", function()
			self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		end)
	end
end

do
	-- 6min is the res timer, right? Hope so.
	local six = 60 * 6
	function module:SPELL_UPDATE_COOLDOWN()
		self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		local start, duration = GetSpellCooldown(20608)
		if start > 0 and duration > 0 then
			local t = GetTime()
			if (start + six) > t then
				oRA:SendComm("Cooldown", 20608, getCooldown(20608) - 1)
			end
		end
	end
end

function module:OnShutdown()
	stopAll()
	hideDisplay()
	oRA.UnregisterCallback(self, "OnCommCooldown")
	self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnhookAll()
end

function module:OnCommCooldown(commType, sender, spell, cd)
	--print("We got a cooldown for " .. tostring(spell) .. " (" .. tostring(cd) .. ") from " .. tostring(sender))
	if type(spell) ~= "number" or type(cd) ~= "number" then error("Spell or number had the wrong type.") end
	if not db.spells[spell] then return end
	if db.onlyShowMine and sender ~= playerName then return end
	if db.neverShowMine and sender == playerName then return end
	if not db.showDisplay then return end
	local name, _, icon = GetSpellInfo(spell)
	if not name or not icon then return end
	startBar(sender, spell, name, icon, cd)
end

local function addMod(s, m)
	if m == 0 then return end
	if not cdModifiers[s] then
		cdModifiers[s] = m
	else
		cdModifiers[s] = cdModifiers[s] + m
	end
end

local function getRank(tab, talent)
	local _, _, _, _, rank = GetTalentInfo(tab, talent)
	return rank or 0
end

local talentScanners = {
	PALADIN = function()
		addMod(10278, getRank(2, 4) * 60)
		addMod(48788, getRank(1, 8) * 120)
		local rank = getRank(2, 14)
		addMod(642, rank * 30)
		addMod(498, rank * 30)
	end,
	SHAMAN = function()
		addMod(20608, getRank(3, 3) * 600)
	end,
	WARRIOR = function()
		local rank = getRank(3, 13)
		addMod(871, rank * 30)
		addMod(1719, rank * 30)
		addMod(20230, rank * 30)
	end,
	DEATHKNIGHT = function()
		addMod(49576, getRank(3, 6) * 5)
		addMod(42650, getRank(3, 13) * 120)
	end,
	HUNTER = function()
		addMod(781, getRank(3, 11) * 2)
	end,
	MAGE = function()
		local rank = getRank(1, 24)
		addMod(12051, rank * 60)
		if rank > 0 then
			local percent = rank * 15
			local currentCd = getCooldown(66)
			addMod(66, (currentCd * percent) / 100)
		end
	end,
	PRIEST = function()
		local rank = getRank(1, 23)
		if rank > 0 then
			local percent = rank * 10
			local currentCd = getCooldown(10060)
			addMod(10060, (currentCd * percent) / 100)
			currentCd = getCooldown(33206)
			addMod(33206, (currentCd * percent) / 100)
		end
	end,
	ROGUE = function()
		-- 2, 7 = Combat/Endurance
		local endurance = getRank(2, 7)
		-- Sprint, Evasion
		addMod(11305, endurance * 30)
		addMod(26669, endurance * 30)

		-- 3, 26 = Subtlety/Filthy Tricks
		local filthyTricks = getRank(3, 26)
		-- Distract, Tricks, Shadowstep
		addMod(1725, filthyTricks * 5)
		addMod(57934, filthyTricks * 5)
		addMod(36554, filthyTricks * 5)
		-- Preparation
		addMod(14185, filthyTricks * 90)
		
		-- 3, 7 = Subtlety/Elusiveness
		local elusiveness = getRank(3, 7)
		-- Vanish, Blind
		addMod(26889, elusiveness * 30)
		addMod(2094, elusiveness * 30)
		-- Cloak of Shadows
		addMod(31224, elusiveness * 15)
	end,
}

function module:UpdateCooldownModifiers()
	wipe(cdModifiers)
	for i = 1, GetNumGlyphSockets() do
		local enabled, _, spellId = GetGlyphSocketInfo(i)
		if enabled and spellId and glyphCooldowns[spellId] then
			local info = glyphCooldowns[spellId]
			addMod(info[1], info[2])
		end
	end
	if talentScanners[playerClass] then
		talentScanners[playerClass]()
	end
end

function module:UNIT_SPELLCAST_SUCCEEDED(event, unit, spell)
	if unit ~= "player" then return end
	if broadcastSpells[spell] then
		local spellId = broadcastSpells[spell]
		oRA:SendComm("Cooldown", spellId, getCooldown(spellId)) -- Spell ID + CD in seconds
	end
end

function module:COMBAT_LOG_EVENT_UNFILTERED(event, _, clueevent, _, source, srcFlags, _, _, _, spellId, spellName)
	-- These spells are not caught by the UNIT_SPELLCAST_SUCCEEDED event
	if clueevent == "SPELL_AURA_APPLIED" and spellAuraApplied[spellId] then
		if source == playerName then
			oRA:SendComm("Cooldown", spellId, getCooldown(spellId)) -- Spell ID + CD in seconds
		elseif inGroup(srcFlags) then
			self:OnCommCooldown("RAID", source, spellId, allSpells[spellId])
		end
		return
	end

	if clueevent ~= "SPELL_RESURRECT" and clueevent ~= "SPELL_CAST_SUCCESS" then return end
	if not source or source == playerName then return end
	if allSpells[spellId] and inGroup(srcFlags) then
		self:OnCommCooldown("RAID", source, spellId, allSpells[spellId])
	end
end

