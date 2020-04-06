if not Skinner:isAddonEnabled("Tukui") then return end

function Skinner:Tukui()

-->>-- Bags
	if TukuiBags then
		self:SecureHook(Stuffing, "CreateBagFrame", function(this, bType)
			self:skinButton{obj=_G["Stuffing_CloseButton"..bType], cb=true}
		end)
		self:skinEditBox{obj=StuffingFrameBags.editbox}
		StuffingFrameBags.editbox:ClearAllPoints()
		StuffingFrameBags.editbox:SetPoint("topleft", StuffingFrameBags, "topleft", 12, -9)
		StuffingFrameBags.editbox:SetPoint("bottomright", StuffingFrameBags, "topright", -40, -28)
		self:skinButton{obj=Stuffing_CloseButtonBags, cb=true}
	end

-->>-- Chat Copy frame
	if TukuiChat then
		for i = 1, NUM_CHAT_WINDOWS do
			self:SecureHookScript(_G["ButtonCF"..i], "OnClick", function(this)
				self:skinButton{obj=CopyCloseButton, cb=true}
				self:skinScrollBar{obj=CopyScroll}
				for i = 1, NUM_CHAT_WINDOWS do
					self:Unhook(_G["ButtonCF"..i], "OnClick")
				end
			end)
		end
	end

end

-- The following code handles the Initial setup of Skinner when the TukUI is loaded
function Skinner:TukuiInit()

	self:RawHook(self, "OnInitialize", function(this)
		-- Do these before we run the function

		-- setup the default DB values and register them
		self:checkAndRun("Defaults", true)
		self.Defaults = nil -- only need to run this once

		-- Register Textures
		self.LSM:Register("background", "Tukui Background", [[Interface\AddOns\Tukui\media\textures\blank]])
		self.LSM:Register("border", "Tukui Border", [[Interface\AddOns\Tukui\media\textures\blank]])
		self.LSM:Register("statusbar", "Tukui StatusBar", [[Interface\AddOns\Tukui\media\textures\normTex]])

		-- create and use a new db profile called Tukui
		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= "Tukui" then
			self.db:SetProfile("Tukui") -- create new profile
			self.db:CopyProfile(dbProfile) -- use settings from previous profile

			-- change settings
			self.db.profile.TooltipBorder  = {r = 0.6, g = 0.6, b = 0.6, a = 1}
			self.db.profile.BackdropBorder = {r = 0.6, g = 0.6, b = 0.6, a = 1}
			self.db.profile.Backdrop       = {r = 0.1, g = 0.1, b = 0.1, a = 1}
			self.db.profile.BdDefault = false
			self.db.profile.BdFile = "None"
			self.db.profile.BdEdgeFile = "None"
			self.db.profile.BdTexture = "Tukui Background"
			self.db.profile.BdBorderTexture = "Tukui Border"
			self.db.profile.StatusBar.texture = "Tukui StatusBar"
			self.db.profile.BdTileSize = 0
			self.db.profile.BdEdgeSize = 1
			self.db.profile.BdInset = -1
			self.db.profile.Gradient = {enable = false, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "Tukui Background"}
			self.db.profile.Buffs = false
			self.db.profile.Nameplates = false
			self.db.profile.ChatEditBox = {skin = false, style = 1}
			self.db.profile.StatusBar = {texture = "Tukui StatusBar", r = 0, g = 0.5, b = 0.5, a = 0.5}
			self.db.profile.WorldMap = {skin = false, size = 1}
		end

		-- run the function
		self.hooks[this].OnInitialize(this)

		-- Now do this after we have run the function
		-- setup backdrop(s)
		self.Backdrop[1] = self.backdrop
		self.Backdrop[2] = self.backdrop
		self.Backdrop[3] = self.backdrop
		self.Backdrop[4] = self.backdrop
		self.Backdrop[5] = self.backdrop
		self.Backdrop[6] = self.backdrop

		self:Unhook(self, "OnInitialize")
	end)

	-- hook to change Tab size
	self:SecureHook(self, "addSkinFrame", function(this, opts)
		local oName = opts.obj.GetName and opts.obj:GetName()
		if oName
		and (strfind(oName,'Tab(%d+)$') or strfind(oName,'TabButton(%d+)$'))
		then
			local xOfs1 = (opts.x1 or 0) + 4
			local yOfs1 = (opts.y1 or 0) - 6
			local xOfs2 = (opts.x2 or 0) - 4
			local yOfs2 = (opts.y2 or 0) + 6
			self.skinFrame[opts.obj]:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", xOfs1, yOfs1)
			self.skinFrame[opts.obj]:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)
		end
	end)
	-- hook to ignore Shapeshift button skinning
	self:RawHook(self, "addSkinButton", function(this, opts)
		local oName = opts.obj.GetName and opts.obj:GetName()
		if oName
		and strfind(oName, 'ShapeshiftButton(%d)$')
		then
			return
		end
		self.hooks[this].addSkinButton(this, opts)
	end)

	if self:GetModule("UIButtons", true):IsEnabled() then
		-- hook this as UIButton code is now in a module
		self:SecureHook(self, "OnEnable", function(this)
			-- hook to ignore minus/plus button skinning
			self:RawHook(self, "skinButton", function(this, opts)
				if opts.mp
				or opts.mp2
				or opts.mp3
				then
					return
				end
				self.hooks[this].skinButton(this, opts)
			end)
			self.checkTex = function() end
			self:Unhook(self, "OnEnable")
		end)
	end

	-- create a ButtonFacade skin
	local LBF = LibStub("LibButtonFacade", true)
	if LBF then
		local mediaPath = [[Interface\AddOns\Tukui\media\]]
		local bw, bh = 30, 30
		local scale = 0.835
		LBF:AddSkin("Tukui", {
			Backdrop = {
				Hide = true,
			},
			Icon = {
				Scale = scale,
				Width = bw - 2,
				Height = bh - 2,
				TexCoords = {0.1, 0.9, 0.1, 0.9},
			},
			Flash = {
				Scale = scale,
				Width = bw,
				Height = bh,
				Color = {1, 1, 1, 1},
				Texture = mediaPath.."flash",
			},
			Cooldown = {
				Scale = scale,
				Width = bw,
				Height = bh,
			},
			AutoCast = {
				Scale = scale,
				Width = bw,
				Height = bh,
			},
			Normal = {
				Scale = scale,
				Width = bw + 6,
				Height = bh + 6,
				Color = {0.6, 0.6, 0.6, 1},
				Texture = mediaPath.."gloss",
			},
			Pushed = {
				Scale = scale,
				Width = bw,
				Height = bh,
				Color = {1, 1, 1, 1},
				Texture = mediaPath.."pushed",
			},
			Border = {
				Scale = scale,
				Width = bw + 6,
				Height = bh + 6,
				Color = {1, 1, 1, 1},
				Texture = mediaPath.."gloss",
			},
			Disabled = {
				Scale = scale,
				Width = bw,
				Height = bh,
				Color = {0.4, 0.4, 0.4, 1},
				Texture = mediaPath.."gloss",
			},
			Checked = {
				Scale = scale,
				Width = bw,
				Height = bh,
				BlendMode = "ADD",
				Color = {1, 1, 1, 1},
				Texture = mediaPath.."checked",
			},
			AutoCastable = {
				Scale = scale,
				Width = bw,
				Height = bh,
				Texture = mediaPath.."gloss",
			},
			Highlight = {
				Scale = scale,
				Width = bw,
				Height = bh,
				BlendMode = "ADD",
				Color = {1, 1, 1, 1},
				Texture = mediaPath.."hover",
			},
			Gloss = {
				Hide = true,
			},
			HotKey = {
				Scale = scale,
				Width = bw,
				Height = 10,
			},
			Count = {
				Scale = scale,
				Width = bw,
				Height = 10,
			},
			Name = {
				Hide = true,
			},
		}, true)
	end

end

-- Load support for TukUI
local success, err = Skinner:checkAndRun("TukuiInit", true)
if not success then
	print("Error running", "Tukui", err)
end
