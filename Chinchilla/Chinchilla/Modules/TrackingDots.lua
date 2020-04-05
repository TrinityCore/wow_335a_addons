
local TrackingDots = Chinchilla:NewModule("TrackingDots")
local L = LibStub("AceLocale-3.0"):GetLocale("Chinchilla")

TrackingDots.displayName = L["Tracking dots"]
TrackingDots.desc = L["Change how the tracking dots look on the minimap."]


local trackingDotStyles = {}
function TrackingDots:AddTrackingDotStyle(english, localized, texture)
	if type(english) ~= "string" then
		error(("Bad argument #2 to `AddTrackingDotStyle'. Expected %q, got %q"):format("string", type(english)), 2)
	elseif trackingDotStyles[english] then
		error(("Bad argument #2 to `AddTrackingDotStyle'. %q already provided"):format(english), 2)
	elseif type(localized) ~= "string" then
		error(("Bad argument #3 to `AddTrackingDotStyle'. Expected %q, got %q"):format("string", type(localized)), 2)
	elseif type(texture) ~= "string" then
		error(("Bad argument #4 to `AddTrackingDotStyle'. Expected %q, got %q"):format("string", type(texture)), 2)
	end

	trackingDotStyles[english] = { localized, texture }
end

Chinchilla.AddTrackingDotStyle = TrackingDots.AddTrackingDotStyle

TrackingDots:AddTrackingDotStyle("Blizzard",     L["Blizzard"],      [[Interface\MiniMap\ObjectIcons]])
TrackingDots:AddTrackingDotStyle("Nandini",        "Nandini",        [[Interface\AddOns\Chinchilla\Art\Blip-Nandini]])
TrackingDots:AddTrackingDotStyle("NandiniNew",     "Nandini New",    [[Interface\AddOns\Chinchilla\Art\Blip-Nandini-New]])
TrackingDots:AddTrackingDotStyle("BlizzardBig",  L["Big Blizzard"],  [[Interface\AddOns\Chinchilla\Art\Blip-BlizzardBig]])
TrackingDots:AddTrackingDotStyle("GlassSpheres", L["Glass Spheres"], [[Interface\AddOns\Chinchilla\Art\Blip-GlassSpheres]])
TrackingDots:AddTrackingDotStyle("SolidSpheres", L["Solid Spheres"], [[Interface\AddOns\Chinchilla\Art\Blip-SolidSpheres]])


function TrackingDots:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("TrackingDots", {
		profile = {
			trackingDotStyle = "Blizzard",
			enabled = true,
		},
	})

	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function TrackingDots:OnEnable()
	self:SetBlipTexture()
end

function TrackingDots:OnDisable()
	self:SetBlipTexture()
end


local function getBlipTexture(name)
	local style = trackingDotStyles[name] or trackingDotStyles["Blizzard"]
	local texture = style and style[2] or [[Interface\MiniMap\ObjectIcons]]
	return texture
end


function TrackingDots:SetBlipTexture(name)
	if not name then
		name = self.db.profile.trackingDotStyle
	else
		self.db.profile.trackingDotStyle = name
	end

	local texture = getBlipTexture(name)

	if not self:IsEnabled() then
		texture = [[Interface\MiniMap\ObjectIcons]]
	end

	Minimap:SetBlipTexture(texture)
end


function TrackingDots:GetOptions()
	local AceGUI = LibStub("AceGUI-3.0")

	local previewValues = {
		L["Party member or pet"],
		L["Friendly player"],
		L["Neutral player"],
		L["Enemy player"],

		L["Friendly npc"],
		L["Neutral npc"],
		L["Enemy npc"],
		L["Tracked resource"],

		L["Available quest"],
		L["Completed quest"],
		L["Available daily quest"],
		L["Completed daily quest"],
		L["New flight path"],
	}
	do
		local texCoords = {
			{ 0.875, 1, 0.5, 1 }, -- PARTY
			{ 0.5, 0.625, 0, 0.5 }, -- FRIEND
			{ 0.375, 0.5, 0, 0.5 }, -- NEUTRAL
			{ 0.25, 0.375, 0, 0.5 }, -- ENEMY

			{ 0.875, 1, 0, 0.5 }, -- FRIEND NPC
			{ 0.75, 0.875, 0, 0.5 }, -- NEUTRAL NPC
			{ 0.625, 0.75, 0, 0.5 }, -- ENEMY NPC
			{ 0, 0.125, 0.5, 1 }, -- TRACK

			{ 0.125, 0.25, 0.5, 1 }, -- AVAIL
			{ 0.25, 0.375, 0.5, 1 }, -- COMPLETE
			{ 0.375, 0.5, 0.5, 1 }, -- AVAIL DAILY
			{ 0.5, 0.625, 0.5, 1 }, -- COMPLETE DAILY
			{ 0.625, 0.75, 0.5, 1 }, -- FLIGHT
		}

		local min, max, floor = math.min, math.max, math.floor

		do
			local widgetType = "Chinchilla_TrackingDots_Item_Select"
			local widgetVersion = 1

			local function SetText(self, text, ...)
				if text and text ~= '' then
					self.texture:SetTexture(getBlipTexture(TrackingDots.db.profile.trackingDotStyle))
					self.texture:SetTexCoord(unpack(texCoords[text]))
				end

				self.text:SetText(previewValues[text] or "")
			end

			local function Constructor()
				local self = AceGUI:Create("Dropdown-Item-Toggle")
				self.type = widgetType
				self.SetText = SetText

				local texture = self.frame:CreateTexture(nil, "BACKGROUND")
				texture:SetTexture(0,0,0,0)
				texture:SetPoint("BOTTOMRIGHT", self.frame,"TOPLEFT",22,-17)
				texture:SetPoint("TOPLEFT", self.frame,"TOPLEFT",6,-1)
				self.texture = texture

				return self
			end

			AceGUI:RegisterWidgetType(widgetType, Constructor, widgetVersion)
		end

		do
			local widgetType = "Chinchilla_TrackingDots_Select"
			local widgetVersion = 1

			local function SetText(self, text)
				self.text:SetText(text or "")
			end

			local function AddListItem(self, value, text)
				local item = AceGUI:Create("Chinchilla_TrackingDots_Item_Select")
				item:SetText(text)
				item.userdata.obj = self
				item.userdata.value = value
				item.disabled = true
				self.pullout:AddItem(item)
			end

			local sortlist = {}
			local function SetList(self, list)
				self.list = list
				self.pullout:Clear()

				for v in pairs(self.list) do
					sortlist[#sortlist + 1] = v
				end

				table.sort(sortlist)

				for i, value in pairs(sortlist) do
					AddListItem(self, value, value)
					sortlist[i] = nil
				end
			end

			local function Constructor()
				local self = AceGUI:Create("Dropdown")
				self.type = widgetType
				self.SetText = SetText
				self.SetList = SetList

				local left = _G[self.dropdown:GetName() .. "Left"]
				local middle = _G[self.dropdown:GetName() .. "Middle"]
				local right = _G[self.dropdown:GetName() .. "Right"]

				local texture = self.dropdown:CreateTexture(nil, "ARTWORK")
				texture:SetPoint("BOTTOMRIGHT", right, "BOTTOMRIGHT" ,-39, 26)
				texture:SetPoint("TOPLEFT", left, "TOPLEFT", 24, -24)
				self.texture = texture

				return self
			end

			AceGUI:RegisterWidgetType(widgetType, Constructor, widgetVersion)
		end
	end


	return {
		style = {
			name = L["Style"],
			desc = L["Set the style of how the tracking dots should look."],
			type = 'select',
			values = function()
				local t = {}
				for k, v in pairs(trackingDotStyles) do
					t[k] = v[1]
				end
				return t
			end,
			get = function(info)
				return self.db.profile.trackingDotStyle
			end,
			set = function(info, value)
				self:SetBlipTexture(value)
			end,
			order = 2,
		},
		preview = {
			name = L["Preview"],
			desc = L["See how the tracking dots will look"],
			type = 'select',
			values = previewValues,
			get = function(info) end,
			set = function(info, value) end,
			order = 3,
			dialogControl = "Chinchilla_TrackingDots_Select",
		},
	}
end
