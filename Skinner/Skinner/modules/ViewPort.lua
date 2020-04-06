local _, Skinner = ...
local module = Skinner:NewModule("ViewPort")

local db
local defaults = {
	profile = {
		shown = false,
		overlay = false,
		top = 64,
		bottom = 64,
		left = 128,
		right = 128,
		colour = {r = 0, g = 0,	b = 0, a = 1},
		XRes = 768,
		YRes = 1050,
	}
}

local vpoF
local function checkOverlay()

--	print("checkOverlay", db.shown, db.overlay, vpoF)

	if db.shown then
		if db.overlay then
			local xScale = db.XRes / 1050
			local yScale = 768 / db.YRes
			if not vpoF then
				vpoF = CreateFrame("Frame", nil)
				vpoF:SetAllPoints(UIParent)
				vpoF:SetFrameLevel(0)
				vpoF:SetFrameStrata("BACKGROUND")
				vpoF:EnableMouse(false)
				vpoF:SetMovable(false)
				vpoF.top = vpoF:CreateTexture(nil, "BACKGROUND")
				vpoF.btm = vpoF:CreateTexture(nil, "BACKGROUND")
				vpoF.left = vpoF:CreateTexture(nil, "BACKGROUND")
				vpoF.right = vpoF:CreateTexture(nil, "BACKGROUND")
			end
			vpoF.top:SetTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
			vpoF.btm:SetTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
			vpoF.left:SetTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
			vpoF.right:SetTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
			vpoF.top:ClearAllPoints()
			vpoF.top:SetPoint("TOPLEFT")
			vpoF.top:SetPoint("BOTTOMRIGHT", vpoF, "TOPRIGHT", 0, -(db.top * yScale))
			vpoF.btm:ClearAllPoints()
			vpoF.btm:SetPoint("BOTTOMLEFT")
			vpoF.btm:SetPoint("TOPRIGHT", vpoF, "BOTTOMRIGHT", 0, (db.bottom * yScale))
			vpoF.left:ClearAllPoints()
			vpoF.left:SetPoint("TOPLEFT", vpoF, "TOPLEFT", 0, -(db.top * yScale))
			vpoF.left:SetPoint("BOTTOMRIGHT", vpoF, "BOTTOMLEFT", (db.left * yScale), (db.bottom * yScale))
			vpoF.right:ClearAllPoints()
			vpoF.right:SetPoint("TOPRIGHT", vpoF, "TOPRIGHT", 0, -(db.top * yScale))
			vpoF.right:SetPoint("BOTTOMLEFT", vpoF, "BOTTOMRIGHT", -(db.right * yScale), (db.bottom * yScale))
			-- show the overlay frame
			vpoF:Show()
		elseif vpoF then
			vpoF:Hide()
		end
	elseif vpoF then
		vpoF:Hide()
	end

end

function module:OnInitialize()

	-- check to see if any other Viewport Addons are enabled
	if Skinner:isAddonEnabled("Aperture")
	or Skinner:isAddonEnabled("Btex")
	or Skinner:isAddonEnabled("CT_Viewport")
	or Skinner:isAddonEnabled("SunnArt")
	then
		self:Disable() -- disable ourself
		return
	end

	self.db = Skinner.db:RegisterNamespace("ViewPort", defaults)
	db = self.db.profile

	-- convert any old settings
	if Skinner.db.profile.ViewPort then
		for k, v in pairs(Skinner.db.profile.ViewPort) do
			db[k] = v
		end
		Skinner.db.profile.ViewPort = nil
	end

	if not db.shown then self:Disable() end -- disable ourself

end

function module:OnEnable()

	if db.shown then self:adjustViewPort("init") end

end

function module:adjustViewPort(opt)

--	print("adjustViewPort", opt)

	local xScale = db.XRes / 1050
	local yScale = 768 / db.YRes

	if (opt == "init" and db.shown)
	or (opt == "shown" and db.shown)
	or (opt == "top" and db.shown)
	or (opt == "bottom" and db.shown)
	or (opt == "left" and db.shown)
	or (opt == "right" and db.shown)
	or (opt == "XRes" and db.shown)
	or (opt == "YRes" and db.shown)
	then
		WorldFrame:SetPoint("TOPLEFT", (db.left * xScale), -(db.top * yScale))
		WorldFrame:SetPoint("BOTTOMRIGHT", -(db.right * xScale), (db.bottom * yScale))
		checkOverlay()
	elseif opt == "overlay"
	or opt == "colour"
	then
		checkOverlay()
	elseif opt == "shown" and not db.shown
	then
		WorldFrame:ClearAllPoints()
		WorldFrame:SetPoint("TOPLEFT")
		WorldFrame:SetPoint("BOTTOMRIGHT")
		checkOverlay()
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		order = 1,
		name = Skinner.L["View Port"],
		desc = Skinner.L["Change the ViewPort settings"],
		get = function(info) return module.db.profile[info[#info]] end,
		set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile.shown = true -- always enable if any option is changed
			module.db.profile[info[#info]] = value
			module:adjustViewPort(info[#info])
		end,
		args = {
			shown = {
				type = "toggle",
				order = 1,
				width = "full",
				name = Skinner.L["ViewPort Show"],
				desc = Skinner.L["Toggle the ViewPort"],
			},
			top = {
				type = "range",
				order = 4,
				name = Skinner.L["VP Top"],
				desc = Skinner.L["Change Height of the Top Band"],
				min = 0, max = 256, step = 1,
			},
			bottom = {
				type = "range",
				order = 5,
				name = Skinner.L["VP Bottom"],
				desc = Skinner.L["Change Height of the Bottom Band"],
				min = 0, max = 256, step = 1,
			},
			left = {
				type = "range",
				order = 6,
				name = Skinner.L["VP Left"],
				desc = Skinner.L["Change Width of the Left Band"],
				min = 0, max = 1800, step = 1,
			},
			right = {
				type = "range",
				order = 7,
				name = Skinner.L["VP Right"],
				desc = Skinner.L["Change Width of the Right Band"],
				min = 0, max = 1800, step = 1,
			},
			XRes = {
				type = "range",
				order = 8,
				name = Skinner.L["VP XResolution"],
				desc = Skinner.L["Change X Resolution"],
				min = 0, max = 1600, step = 2,
			},
			YRes = {
				type = "range",
				order = 9,
				name = Skinner.L["VP YResolution"],
				desc = Skinner.L["Change Y Resolution"],
				min = 0, max = 2600, step = 2,
			},
			overlay = {
				type = "toggle",
				order = 2,
				name = Skinner.L["ViewPort Overlay"],
				desc = Skinner.L["Toggle the ViewPort Overlay"],
			},
			colour = {
				type = "color",
				order = 3,
				width = "double",
				name = Skinner.L["ViewPort Colors"],
				desc = Skinner.L["Set ViewPort Colors"],
				hasAlpha = true,
				get = function(info)
					local c = module.db.profile[info[#info]]
					return c.r, c.g, c.b, c.a
				end,
				set = function(info, r, g, b, a)
					local c = module.db.profile[info[#info]]
					c.r, c.g, c.b, c.a = r, g, b, a
					module.db.profile.shown = true -- enable viewport
					module.db.profile.overlay = true -- enable overlay
					module:adjustViewPort("colour")
				end,
			},
		}
	}
	return options

end
