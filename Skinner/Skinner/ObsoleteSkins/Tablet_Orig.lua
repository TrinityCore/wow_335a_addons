local _G = getfenv(0)

function Skinner:Tablet()

	self:SecureHook(AceLibrary("Tablet-2.0"), "Open", function(tablet, parent)
--		self:Debug("TabletOpen: [%s, %s]", tablet, parent:GetName())
		self:Skin_Tablet()
	end)
	self:SecureHook(AceLibrary("Tablet-2.0"), "Detach", function(tablet, parent)
--		self:Debug("TabletDetach: [%s, %s]", tablet, parent:GetName())
		self:Skin_Tablet()
	end)

	self:Skin_Tablet()


end

local tabletsSkinned = {}

function Skinner:Skin_Tablet()
	if not self.db.profile.Tooltips.skin then return end

	if Tablet20Frame then
--		self:Debug("Tablet20Frame")
		local frame = Tablet20Frame
		if not tabletsSkinned["Tablet20Frame"] then
			tabletsSkinned["Tablet20Frame"] = true
			local r,g,b,a = frame:GetBackdropColor()
			self:applySkin(frame)
			local old_SetBackdropColor = frame.SetBackdropColor
			function frame:SetBackdropColor(r,g,b,a)
				old_SetBackdropColor(self,r,g,b,a)
				self.tfade:SetGradientAlpha(unpack(Skinner.db.profile.Gradient and self.gradientOn or self.gradientOff))
			end
			frame:SetBackdropColor(r,g,b,a)
			frame:SetBackdropBorderColor(1,1,1,a)
		end
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -math.ceil(frame:GetHeight()))
	end

	local i = 1
	while _G["Tablet20DetachedFrame" .. i] do
--		self:Debug("Tablet20DetachedFrame"..i)
		local frame = _G["Tablet20DetachedFrame"..i]
		if not tabletsSkinned["Tablet20DetachedFrame" .. i] then
			tabletsSkinned["Tablet20DetachedFrame" .. i] = true
			local r,g,b,a = frame:GetBackdropColor()
			self:applySkin(frame)
			local old_SetBackdropColor = frame.SetBackdropColor
			function frame:SetBackdropColor(r,g,b,a)
				old_SetBackdropColor(self,r,g,b,a)
				self.tfade:SetGradientAlpha(unpack(Skinner.db.profile.Gradient and self.gradientOn or self.gradientOff))
			end
			frame:SetBackdropColor(r,g,b,a)
			frame:SetBackdropBorderColor(1,1,1,a)
		end
		i = i + 1
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -math.ceil(frame:GetHeight()))
	end

end
