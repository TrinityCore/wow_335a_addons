local _, Skinner = ...
local module = Skinner:NewModule("MiddleFrames")
local ftype = "s"

local db
local defaults = {
	profile = {
		fheight = 100,
		fixedfh = false,
		borderOff = false,
		lock = false,
		colour = {r = 0, g = 0, b = 0, a = 0.9},
	}
}
local MAX_MIDDLEFRAMES = 9
for i = 1, MAX_MIDDLEFRAMES do
	defaults.profile["mf"..i] = {shown = false, height = 100, width = 100, xOfs = -300, yOfs = 300, flevel = 0, fstrata = "BACKGROUND"}
end

local function OnMouseDown(self, mBtn)

	if mBtn == "LeftButton" and IsAltKeyDown() then
		self.isMoving = true
		self:StartMoving()
		self:Raise()
	end

	if mBtn == "LeftButton" and IsControlKeyDown() then
		self.isMoving = true
		self:StartSizing("BOTTOMRIGHT")
		self:Raise()
	end

end
local function OnMouseUp(self, mBtn)

	if mBtn == "LeftButton" then
		if self.isMoving then
			self:StopMovingOrSizing()
			self.isMoving = nil
			self:Lower()
			local x, y = self:GetCenter()
			local px, py = self:GetParent():GetCenter()
			self.db[self.key].xOfs = x - px
			self.db[self.key].yOfs = y - py
			self.db[self.key].width = floor(self:GetWidth())
			self.db[self.key].height = floor(self:GetHeight())
			Skinner:applyGradient(self)
		end
	end

end
local function OnHide(self)

	if self.isMoving then
		self:StopMovingOrSizing()
		self.isMoving = nil
	end

end
local function OnEnter(self)

	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:AddLine(Skinner.L[self.name])
	GameTooltip:AddLine(Skinner.L["Alt-Drag to move"], 1, 1, 1)
	GameTooltip:AddLine(Skinner.L["Ctrl-Drag to resize"], 1, 1, 1)
	GameTooltip:Show()

end
local function OnLeave(self)

	GameTooltip:Hide()

end
local frames, frame, fh = {}
local function adjustFrame(key)

--	print("adjustFrame", key, db[key].shown, frames[key])

	if db[key].shown then
		frame = frames[key] or CreateFrame("Frame", nil, UIParent)
		frame.db = db
		frame.key = key
		frame.name = "Middle Frame"..strsub(key, -1)
		frame:SetFrameStrata(db[key].fstrata)
		frame:SetFrameLevel(db[key].flevel)
		frame:SetMovable(true)
		frame:SetResizable(true)
		frame:SetWidth(db[key].width)
		frame:SetHeight(db[key].height)
		frame:SetPoint("CENTER", UIParent, "CENTER", db[key].xOfs, db[key].yOfs)
		frame:RegisterForDrag("LeftButtonUp")
		if db.lock then
			frame:SetScript("OnMouseDown", function() end)
			frame:EnableMouse(false)
		else
			frame:SetScript("OnMouseDown", OnMouseDown)
			frame:EnableMouse(true)
		end
		frame:SetScript("OnMouseUp", OnMouseUp)
		frame:SetScript("OnHide", OnHide)
		frame:SetScript("OnEnter", OnEnter)
		frame:SetScript("OnLeave", OnLeave)
		-- set the fade height
		fh = nil
		if not Skinner.db.profile.FadeHeight.enable
		and db.fixedfh
		then
			fh = db.fheight <= ceil(frame:GetHeight()) and db.fheight or ceil(frame:GetHeight())
		end
		Skinner:applySkin{obj=frame, ftype=ftype, bba=db.borderOff and 0 or 1, fh=fh}
		frame:SetBackdropColor(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
		frame:Show()
		frames[key] = frame
	elseif frames[key] then
		frames[key]:Hide()
	end
	
end

function module:OnInitialize()

	self.db = Skinner.db:RegisterNamespace("MiddleFrames", defaults)
	db = self.db.profile

	-- convert any old settings
	if Skinner.db.profile.MiddleFrame then
		for k, v in pairs(Skinner.db.profile.MiddleFrame) do
			db[k] = v
		end
		Skinner.db.profile.MiddleFrame = nil
	end
	for i = 1, MAX_MIDDLEFRAMES do
		if Skinner.db.profile["MiddleFrame"..i] then
			for k, v in pairs(Skinner.db.profile["MiddleFrame"..i]) do
				db["mf"..i][k] = v
			end
			Skinner.db.profile["MiddleFrame"..i] = nil
		end
	end

	local enable
	for i = 1, MAX_MIDDLEFRAMES do
		if db["mf"..i].shown then
			enable = true
			break
		end
	end
	if not enable then self:Disable() end -- disable ourself

end

function module:OnEnable()

	self:adjustMiddleFrames("init")

end

function module:adjustMiddleFrames(opt, key)

--	print("adjustMiddleFrames", opt, key)

	if not key then
		for i = 1, MAX_MIDDLEFRAMES do
			local key = "mf"..i
--			print("adjustMiddleFrames loop", key, db[key].shown)
			adjustFrame(key)
		end
	else
		adjustFrame(key)
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		order = 3,
		name = Skinner.L["Middle Frame(s)"],
		desc = Skinner.L["Change the MiddleFrame(s) settings"],
		get = function(info) return module.db.profile[info[#info]]	end,
		set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile[info[#info]] = value
			module:adjustMiddleFrames(info[#info])
		end,
		args = {
			fheight = {
				type = "range",
				order = 4,
				name = Skinner.L["MF Fade Height"],
				desc = Skinner.L["Change the Height of the Fade Effect"],
				min = 0, max = 500, step = 1,
			},
			fixedfh = {
				type = "toggle",
				order = 5,
				name = Skinner.L["Fixed Fade Height"],
				desc = Skinner.L["Fix the Height of the Fade Effect"],
			},
			borderOff = {
				type = "toggle",
				order = 2,
				name = Skinner.L["MF Toggle Border"],
				desc = Skinner.L["Toggle the Border"],
			},
			colour = {
				type = "color",
				order = 3,
				name = Skinner.L["MF Colour"],
				desc = Skinner.L["Change the Colour of the MiddleFrame(s)"],
				hasAlpha = true,
				get = function(info)
					local c = module.db.profile[info[#info]]
					return c.r, c.g, c.b, c.a
				end,
				set = function(info, r, g, b, a)
					if not module:IsEnabled() then module:Enable() end
					local c = module.db.profile[info[#info]]
					c.r, c.g, c.b, c.a = r, g, b, a
					module:adjustMiddleFrames("colour")
				end,
			},
			lock = {
				type = "toggle",
				order = 1,
				name = Skinner.L["MF Lock Frames"],
				desc = Skinner.L["Toggle the Frame Lock"],
			},
		},
	}

	local FrameStrata = {
		BACKGROUND = "Background",
		LOW = "Low",
		MEDIUM = "Medium",
		HIGH = "High",
		DIALOG = "Dialog",
		FULLSCREEN = "Fullscreen",
		FULLSCREEN_DIALOG = "Fullscreen_Dialog",
		TOOLTIP = "Tooltip",
	}

	-- setup middleframe(s) options
	local mfkey
	for i = 1, MAX_MIDDLEFRAMES do
		mfkey = {}
		mfkey.type = "group"
		mfkey.inline = true
		mfkey.name = Skinner.L["Middle Frame"..i]
		mfkey.desc = Skinner.L["Change MiddleFrame"..i.." settings"]
		mfkey.get = function(info)
			return module.db.profile[info[#info - 1]][info[#info]]
		end
		mfkey.set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile[info[#info - 1]].shown = true -- always enable if any option is changed
			module.db.profile[info[#info - 1]][info[#info]] = value
			module:adjustMiddleFrames(info[#info], info[#info - 1])
		end
		mfkey.args = {}
		mfkey.args.shown = {}
		mfkey.args.shown.type = "toggle"
		mfkey.args.shown.order = 1
		mfkey.args.shown.name = Skinner.L["MiddleFrame"..i.." Show"]
		mfkey.args.shown.desc = Skinner.L["Toggle the MiddleFrame"..i]
		mfkey.args.flevel = {}
		mfkey.args.flevel.type = "range"
		mfkey.args.flevel.name = Skinner.L["MF"..i.." Frame Level"]
		mfkey.args.flevel.desc = Skinner.L["Change the MF"..i.." Frame Level"]
		mfkey.args.flevel.min = 0
		mfkey.args.flevel.max = 20
		mfkey.args.flevel.step = 1
		mfkey.args.fstrata = {}
		mfkey.args.fstrata.type = "select"
		mfkey.args.fstrata.name = Skinner.L["MF"..i.." Frame Strata"]
		mfkey.args.fstrata.desc = Skinner.L["Change the MF"..i.." Frame Strata"]
		mfkey.args.fstrata.values = FrameStrata
		options.args["mf"..i] = mfkey
	end
	mfkey = nil

	return options

end
