local _, Skinner = ...
local module = Skinner:NewModule("TopFrame")
local ftype = "s"

local db
local defaults = {
	profile = {
		shown = false,
		height = 64,
		width = 1920,
		fheight = 64,
		fixedfh = false,
		xyOff = true,
		borderOff = false,
		alpha = 0.9,
		invert = false,
		rotate = false,
	}
}

local function adjustTFOffset(db, reset)

	--	Adjust the UIParent TOP-OFFSET attribute if required
	if db.shown then
		local topOfs = -db.height
		local UIPtopOfs = -104
		if topOfs < UIPtopOfs and not reset then
			UIParent:SetAttribute("TOP_OFFSET", topOfs)
		elseif UIParent:GetAttribute("TOP_OFFSET") < UIPtopOfs then
			UIParent:SetAttribute("TOP_OFFSET", UIPtopOfs)
		end
	end

end

function module:OnInitialize()

	self.db = Skinner.db:RegisterNamespace("TopFrame", defaults)
	db = self.db.profile

	-- convert any old settings
	if Skinner.db.profile.TopFrame then
		for k, v in pairs(Skinner.db.profile.TopFrame) do
			db[k] = v
		end
		Skinner.db.profile.TopFrame = nil
	end

	if not db.shown then self:Disable() end -- disable ourself

end

function module:OnEnable()

	if db.shown then self:adjustTopFrame("init") end

end

local topframe
function module:adjustTopFrame(opt)

--	print("adjustTopFrame", opt)

	if db.shown then
		topframe = topframe or CreateFrame("Frame", nil, UIParent)
		topframe:SetFrameStrata("BACKGROUND")
		topframe:SetFrameLevel(0)
		topframe:EnableMouse(false)
		topframe:SetMovable(false)
		topframe:SetWidth(db.width)
		topframe:SetHeight(db.height)
		topframe:ClearAllPoints()
		if db.xyOff or db.borderOff then
			topframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -6, 6)
		else
			topframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -3, 3)
		end
		-- set the fade height
		local fh = nil
		if not Skinner.db.profile.FadeHeight.enable
		and db.fixedfh
		then
			fh = db.fheight <= ceil(topframe:GetHeight()) and db.fheight or ceil(topframe:GetHeight())
		end
		Skinner:applySkin{obj=topframe, ft=ftype, bba=db.borderOff and 0 or 1, ba=db.alpha, fh=fh, invert=db.invert or nil, rotate=db.rotate or nil}
		-- adjust the TopFrame offset
		adjustTFOffset(db)
		topframe:Show()
	elseif topframe then
		topframe:Hide()
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		order = 2,
		name = Skinner.L["Top Frame"],
		desc = Skinner.L["Change the TopFrame settings"],
		get = function(info) return module.db.profile[info[#info]] end,
		set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile.shown = true -- always enable if any option is changed
			module.db.profile[info[#info]] = value
			module:adjustTopFrame(info[#info])
		end,
		args = {
			shown = {
				type = "toggle",
				order = 1,
				name = Skinner.L["TopFrame Show"],
				desc = Skinner.L["Toggle the TopFrame"],
			},
			height = {
				type = "range",
				order = 6,
				name = Skinner.L["TF Height"],
				desc = Skinner.L["Change Height of the TopFrame"],
				min = 0, max = 500, step = 1,
			},
			width = {
				type = "range",
				order = 7,
				name = Skinner.L["TF Width"],
				desc = Skinner.L["Change Width of the TopFrame"],
				min = 0, max = 2600, step = 1,
			},
			fheight = {
				type = "range",
				order = 9,
				name = Skinner.L["TF Fade Height"],
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
				name = Skinner.L["TF Move Origin offscreen"],
				desc = Skinner.L["Hide Border on Left and Top"],
			},
			borderOff = {
				type = "toggle",
				order = 3,
				name = Skinner.L["TF Toggle Border"],
				desc = Skinner.L["Toggle the Border"],
			},
			alpha = {
				type = "range",
				order = 8,
				name = Skinner.L["TF Alpha"],
				desc = Skinner.L["Change Alpha value of the TopFrame"],
				min = 0, max = 1, step = 0.1,
			},
			invert = {
				type = "toggle",
				order = 4,
				name = Skinner.L["TF Invert Gradient"],
				desc = Skinner.L["Toggle the Inversion of the Gradient"],
			},
			rotate = {
				type = "toggle",
				order = 5,
				name = Skinner.L["TF Rotate Gradient"],
				desc = Skinner.L["Toggle the Rotation of the Gradient"],
			},
		},
	}
	return options

end
