if not Skinner:isAddonEnabled("ZOMGBuffs") then return end

function Skinner:ZOMGBuffs()

	--	Hook this to skin some of the frames
	local LZF = LibStub:GetLibrary('ZFrame-1.0', true)
	if LZF then
		self:RawHook(LZF, "Create", function(this, ...)
			local frame = self.hooks[this].Create(this, ...)
--			self:Debug("ZFrame Create:[%s]", frame)
			self:moveObject(frame.ZMain.title, nil, nil, "-", 0, frame.ZMain)
			self:skinButton{obj=frame.ZMain.close, cb=true, sap=true}
			self:moveObject(frame.ZMain.close, "-", 1, "+", 9, frame.ZMain)
			self:applySkin(frame.ZMain)
			return frame
		end, true)
	end
	self:RawHook(ZOMGBuffs, "CreateHelpFrame", function(this)
		local hf = self.hooks[this].CreateHelpFrame(this)
		self:skinButton{obj=self:getChild(hf, 1)} -- close button (N.B. hf.close doesn't work)
		self:applySkin(hf)
		self:Unhook(ZOMGBuffs, "CreateHelpFrame")
		return hf
	end, true)

	-- skin the icon button
	self:getRegion(ZOMGBuffs.icon, 7):SetAlpha(0) -- hide the normal texture
	self:addSkinButton{obj=ZOMGBuffs.icon, parent=ZOMGBuffs.icon}

	-- set the bar texture
	ZOMGBuffs.db.profile.bartexture = self.db.profile.StatusBar.texture

end

function Skinner:ZOMGBuffs_BlessingsManager()

	local ZBM = ZOMGBuffs:GetModule("ZOMGBlessingsManager")
	if ZBM then
		self:SecureHook(ZBM, "SplitInitialize", function(this)
--			self:Debug("ZBM SplitInitialize")
			local frame = this.splitframe
			for i = 1, #frame.column do
				self:applySkin(frame.column[i])
			end
		end)
		-- need to skin the panel buttons
	end

end
