
local RangeCircle = Chinchilla:NewModule("RangeCircle", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Chinchilla")

RangeCircle.displayName = L["Range circle"]
RangeCircle.desc = L["Show a circle on the minimap at a prefered range"]


function RangeCircle:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("RangeCircle", {
		profile = {
			range = 90,
			color = { 1, 0.82, 0, 0.5 },
			style = "Solid",
			combatRange = 90,
			combatColor = { 1, 0.82, 0, 0.25 },
			combatStyle = "Solid",
			enabled = false,
		},
	})

	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local styles = {
	Solid = {
		L["Solid"],
		[[Interface\AddOns\Chinchilla\Art\Range-Solid]],
	},
	Outline = {
		L["Outline"],
		[[Interface\AddOns\Chinchilla\Art\Range-Outline]],
	}
}

local minimapSize = { -- radius of minimap
	indoor = {
		[0] = 150,
		[1] = 120,
		[2] = 90,
		[3] = 60,
		[4] = 40,
		[5] = 25,
	},
	outdoor = {
		[0] = 233 + 1/3,
		[1] = 200,
		[2] = 166 + 2/3,
		[3] = 133 + 1/6,
		[4] = 100,
		[5] = 66 + 2/3,
	},
}

local texture, indoors
local inCombat = not not InCombatLockdown()

function RangeCircle:OnEnable()
	if not texture then
		texture = Minimap:CreateTexture("Chinchilla_RangeCircle_Circle", "BORDER")
		texture:SetPoint("CENTER")
	end

	texture:Show()

	self:RegisterEvent("MINIMAP_UPDATE_ZOOM")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:Update()

	self:SecureHook(Minimap, "SetZoom", "Minimap_SetZoom")
end

function RangeCircle:OnDisable()
	texture:Hide()
end

function RangeCircle:PLAYER_REGEN_ENABLED()
	inCombat = false
	self:Update()
end

function RangeCircle:PLAYER_REGEN_DISABLED()
	inCombat = true
	self:Update()
end

function RangeCircle:MINIMAP_UPDATE_ZOOM()
	local zoom = Minimap:GetZoom()

	if GetCVar("minimapZoom") == GetCVar("minimapInsideZoom") then
		Minimap:SetZoom(zoom < 2 and zoom + 1 or zoom - 1)
	end

	indoors = GetCVar("minimapZoom")+0 ~= Minimap:GetZoom()
	Minimap:SetZoom(zoom)

	self:Update()
end

function RangeCircle:Update()
	if not self:IsEnabled() then
		return
	end

	local style = styles[self.db.profile[inCombat and 'combatStyle' or 'style']] or styles.Solid
	local tex = style and style[2] or [[Interface\AddOns\Chinchilla\Art\Range-Solid]]

	texture:SetTexture(tex)
	texture:SetVertexColor(unpack(self.db.profile[inCombat and 'combatColor' or 'color']))

	local radius = minimapSize[indoors and "indoor" or "outdoor"][Minimap:GetZoom()]
	local range = self.db.profile[inCombat and 'combatRange' or 'range']
	local minimapWidth = Minimap:GetWidth()
	local size = minimapWidth * range/radius

	if size > minimapWidth then
		local ratio = minimapWidth/size

		texture:SetTexCoord(0.5 - ratio/2, 0.5 + ratio/2, 0.5 - ratio/2, 0.5 + ratio/2)
		texture:SetWidth(minimapWidth)
		texture:SetHeight(minimapWidth)
	else
		texture:SetTexCoord(0, 1, 0, 1)
		texture:SetWidth(size)
		texture:SetHeight(size)
	end
end

function RangeCircle:Minimap_SetZoom()
	self:Update()
end


function RangeCircle:GetOptions()
	local args = {
		range = {
			type = 'range',
			name = L["Radius"],
			desc = L["The radius in yards of how large the radius of the circle should be"],
			min = 5,
			max = 250,
			step = 1,
			bigStep = 5,
			get = function(info)
				local combat = info[#info - 1] == "inCombat"
				return self.db.profile[combat and 'combatRange' or 'range']
			end,
			set = function(info, value)
				local combat = info[#info - 1] == "inCombat"
				self.db.profile[combat and 'combatRange' or 'range'] = value
				if not combat == not inCombat then
					self:Update()
				end
			end
		},
		color = {
			type = 'color',
			name = L["Color"],
			desc = L["Color of the circle"],
			hasAlpha = true,
			get = function(info)
				local combat = info[#info - 1] == "inCombat"
				return unpack(self.db.profile[combat and 'combatColor' or 'color'])
			end,
			set = function(info, r, g, b, a)
				local combat = info[#info - 1] == "inCombat"
				local data = self.db.profile[combat and 'combatColor' or 'color']
				data[1] = r
				data[2] = g
				data[3] = b
				data[4] = a
				if not combat == not inCombat then
					self:Update()
				end
			end
		},
		style = {
			type = 'select',
			name = L["Style"],
			desc = L["What texture style to use for the circle"],
			values = function(info)
				local t = {}
				for k,v in pairs(styles) do
					t[k] = v[1]
				end
				return t
			end,
			get = function(info)
				local combat = info[#info - 1] == "inCombat"
				return self.db.profile[combat and 'combatStyle' or 'style']
			end,
			set = function(info, value)
				local combat = info[#info - 1] == "inCombat"
				self.db.profile[combat and 'combatStyle' or 'style'] = value
				if not combat == not inCombat then
					self:Update()
				end
			end
		}
	}

	return {
		outCombat = {
			type = 'group',
			inline = true,
			name = L["Out of combat"],
			desc = L["These settings apply when out of combat"],
			args = args,
			order = 2,
		},
		inCombat = {
			type = 'group',
			inline = true,
			name = L["In combat"],
			desc = L["These settings apply when in combat"],
			args = args,
			order = 3,
		},
	}
end
