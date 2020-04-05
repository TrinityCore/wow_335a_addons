
local Expander = Chinchilla:NewModule("Expander")
local L = LibStub("AceLocale-3.0"):GetLocale("Chinchilla")

Expander.displayName = L["Expander"]
Expander.desc = L["Show an expanded minimap on keypress"]


function Expander:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("Expander", {
		profile = {
			key = false,
			scale = 3,
			enabled = true,
		},
	})

	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local frame, minimap
function Expander:OnEnable()
	if not frame then
		frame = CreateFrame("Button", "Chinchilla_Expander_Button")
	end

	frame:SetScript("OnMouseDown", function(this, button)
		MinimapCluster:Hide()

		if not minimap then
			minimap = CreateFrame("Minimap", "Chinchilla_Expander_Minimap", UIParent)
			minimap:SetWidth(140 * self.db.profile.scale)
			minimap:SetHeight(140 * self.db.profile.scale)
			minimap:SetScale(1.2)
			minimap:SetPoint("CENTER")
			minimap:SetFrameStrata("TOOLTIP")
			minimap:EnableMouse(true)
			minimap:EnableMouseWheel(false)
			minimap:EnableKeyboard(false)
		end

		minimap:Show()

		local z = minimap:GetZoom()

		if z > 2 then minimap:SetZoom(z-1)
		else minimap:SetZoom(z+1) end

		minimap:SetZoom(z)

		if GatherMate then GatherMate:GetModule("Display"):ReparentMinimapPins(minimap) end
		if Routes and Routes.ReparentMinimap then Routes:ReparentMinimap(minimap) end
	end)

	frame:SetScript("OnMouseUp", function(this, button)
		minimap:Hide()
		MinimapCluster:Show()

		local z = Minimap:GetZoom()

		if z > 2 then Minimap:SetZoom(z-1)
		else Minimap:SetZoom(z+1) end

		Minimap:SetZoom(z)

		if GatherMate then GatherMate:GetModule("Display"):ReparentMinimapPins(Minimap) end
		if Routes and Routes.ReparentMinimap then Routes:ReparentMinimap(Minimap) end
	end)

	if self.db.profile.key then
		CreateFrame("Frame"):SetScript("OnUpdate", function(this)
			if InCombatLockdown() then return end
			SetBindingClick(self.db.profile.key, "Chinchilla_Expander_Button")
			this:Hide()
		end)
	end
end

function Expander:OnDisable()
	frame:SetScript("OnMouseDown", nil)
	frame:SetScript("OnMouseUp", nil)
end


function Expander:GetOptions()
	return {
		key = {
			name = L["Keybinding"],
			desc = L["The key to press to show the expanded minimap"],
			type = 'keybinding',
			get = function()
				return self.db.profile.key
			end,
			set = function(_, value)
				if self.db.profile.key then
					SetBinding(self.db.profile.key, nil)
				end

				self.db.profile.key = value

				if frame and value then
					SetBindingClick(value, "Chinchilla_Expander_Button")
				end
			end,
			disabled = InCombatLockdown,
		},
		scale = {
			name = L["Size"],
			desc = L["The size of the expanded minimap"],
			type = 'range',
			min = 0.5,
			max = 8,
			step = 0.01,
			bigStep = 0.05,
			isPercent = true,
			get = function()
				return self.db.profile.scale
			end,
			set = function(_, value)
				self.db.profile.scale = value

				if minimap then
					minimap:SetWidth(140 * self.db.profile.scale)
					minimap:SetHeight(140 * self.db.profile.scale)
				end
			end,
		},
	}
end
