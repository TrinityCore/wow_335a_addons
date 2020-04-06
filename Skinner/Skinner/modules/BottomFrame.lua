local _, Skinner = ...
local module = Skinner:NewModule("BottomFrame")
local ftype = "s"

local db
local defaults = {
	profile = {
		shown = false,
		height = 200,
		width = 1920,
		fheight = 200,
		fixedfh = false,
		xyOff = true,
		borderOff = false,
		alpha = 0.9,
		invert = false,
		rotate = false,
	}
}

function module:OnInitialize()

	self.db = Skinner.db:RegisterNamespace("BottomFrame", defaults)
	db = self.db.profile

	-- convert any old settings
	if Skinner.db.profile.BottomFrame then
		for k, v in pairs(Skinner.db.profile.BottomFrame) do
			db[k] = v
		end
		Skinner.db.profile.BottomFrame = nil
	end

	if not db.shown then self:Disable() end -- disable ourself

end

function module:OnEnable()

	if db.shown then self:adjustBottomFrame("init") end

end

local btmframe
function module:adjustBottomFrame(opt)

--	print("adjustBottomFrame", opt)

	if db.shown then
		btmframe = btmframe or CreateFrame("Frame", nil, UIParent)
		btmframe:SetFrameStrata("BACKGROUND")
		btmframe:SetFrameLevel(0)
		btmframe:EnableMouse(false)
		btmframe:SetMovable(false)
		btmframe:SetWidth(db.width)
		btmframe:SetHeight(db.height)
		btmframe:ClearAllPoints()
		if db.xyOff or db.borderOff then
			btmframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -6, -6)
		else
			btmframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3, -3)
		end
		-- set the fade height
		local fh = nil
		if not Skinner.db.profile.FadeHeight.enable
		and db.fixedfh
		then
			fh = db.fheight <= ceil(btmframe:GetHeight()) and db.fheight or ceil(btmframe:GetHeight())
		end
		Skinner:applySkin{obj=btmframe, ft=ftype, bba=db.borderOff and 0 or 1, ba=db.alpha, fh=fh, invert=db.invert or nil, rotate=db.rotate or nil}
		btmframe:Show()
	elseif btmframe then
		btmframe:Hide()
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		order = 4,
		name = Skinner.L["Bottom Frame"],
		desc = Skinner.L["Change the BottomFrame settings"],
		get = function(info) return module.db.profile[info[#info]] end,
		set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile.shown = true -- always enable if any option is changed
			module.db.profile[info[#info]] = value
			module:adjustBottomFrame(info[#info])
		end,
		args = {
			shown = {
				type = "toggle",
				order = 1,
				name = Skinner.L["BottomFrame Show"],
				desc = Skinner.L["Toggle the BottomFrame"],
			},
			height = {
				type = "range",
				order = 6,
				name = Skinner.L["BF Height"],
				desc = Skinner.L["Change Height of the BottomFrame"],
				min = 0, max = 500, step = 1,
			},
			width = {
				type = "range",
				order = 7,
				name = Skinner.L["BF Width"],
				desc = Skinner.L["Change Width of the BottomFrame"],
				min = 0, max = 2600, step = 1,
			},
			fheight = {
				type = "range",
				order = 9,
				name = Skinner.L["BF Fade Height"],
				desc = Skinner.L["Change the Height of the Fade Effect"],
				min = 0, max = 500, step = 1,
			},
			fixedfh = {
				type = "toggle",
				order = 10,
				name = Skinner.L["Fixed Fade Height"],
				desc = Skinner.L["Fix the Height of the Fade Effect"],
			},
			xyOff = {
				type = "toggle",
				order = 2,
				width = "double",
				name = Skinner.L["BF Move Origin offscreen"],
				desc = Skinner.L["Hide Border on Left and Bottom"],
			},
			borderOff = {
				type = "toggle",
				order = 3,
				name = Skinner.L["BF Toggle Border"],
				desc = Skinner.L["Toggle the Border"],
			},
			alpha = {
				type = "range",
				order = 8,
				name = Skinner.L["BF Alpha"],
				desc = Skinner.L["Change Alpha value of the BottomFrame"],
				min = 0, max = 1, step = 0.1,
			},
			invert = {
				type = "toggle",
				order = 4,
				name = Skinner.L["BF Invert Gradient"],
				desc = Skinner.L["Toggle the Inversion of the Gradient"],
			},
			rotate = {
				type = "toggle",
				order = 5,
				name = Skinner.L["BF Rotate Gradient"],
				desc = Skinner.L["Toggle the Rotation of the Gradient"],
			},
		},
	}
	return options

end
