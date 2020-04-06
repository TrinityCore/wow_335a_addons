-- This is a Framework

local allHooked, tKDd, tKG, tKS, tKAP, tkB, ver
	
function Skinner:tekKonfig()
	if not self.db.profile.MenuFrames then return end
	
	if allHooked then return end
	
--	self:Debug("tekKonfig skin")
	
	if LibStub("tekKonfig-Dropdown", true) and not tKDd then
		tKDd, ver = LibStub("tekKonfig-Dropdown")
		self:RawHook(tKDd, "new", function(parent, label, ...)
--			self:Debug("tKDd:[%s, %s]", parent, label)
			local frame, text, container = self.hooks[tKDd].new(parent, label, ...)
			if not self.db.profile.TexturedDD then self:keepFontStrings(frame)
			else
				local leftTex, midTex, rightTex
				if ver == 2 then
					leftTex, midTex, rightTex = frame:GetRegions()
				else
					leftTex, rightTex, midTex = frame:GetRegions()
				end
				leftTex:SetAlpha(0)
				midTex:SetTexture(self.itTex)
				midTex:SetHeight(18)
				midTex:SetTexCoord(0, 1, 0, 1)
				rightTex:SetAlpha(0)
			end
			return frame, text, container
		end, true)
	end

	if LibStub("tekKonfig-Group", true) and not tKG then
		tKG = LibStub("tekKonfig-Group")
		self:RawHook(tKG, "new", function(parent, label, ...)
--			self:Debug("tKG:[%s, %s]", parent, label)
			local box = self.hooks[tKG].new(parent, label, ...)
			self:applySkin(box)
			return box
		end, true)
	end

	if LibStub("tekKonfig-Scroll", true) and not tKS then
		tKS = LibStub("tekKonfig-Scroll")
		self:RawHook(tKS, "new", function(parent, offset, step)
--			self:Debug("tKS:[%s, %s, %s]", parent, offset, step)
			local frame, up, down, border = self.hooks[tKS].new(parent, offset, step)
			self:skinSlider{obj=frame, size=3}
			border:SetBackdrop(nil)
			return frame, up, down, border
		end, true)
	end

	if LibStub("tekKonfig-AboutPanel", true) and not tKAP then
		tKAP = LibStub("tekKonfig-AboutPanel")
		self:SecureHook(tKAP, "OpenEditbox", function(this)
--			self:Debug("tKAP:[%s, %s]", this, tKAP.editbox)
			if not self.skinned[tKAP.editbox] then
				tKAP.editbox:SetHeight(24)
				local l, r, t, b = tKAP.editbox:GetTextInsets()
				tKAP.editbox:SetTextInsets(l + 5, r + 5, t, b)
				self:keepFontStrings(tKAP.editbox)
				self:skinUsingBD2(tKAP.editbox)
			end
			tKAP.editbox:SetPoint("LEFT", -5, 0)
		end)
	end

	if LibStub("tekKonfig-Button", true) and not tkB then
		tkB = LibStub("tekKonfig-Button")
		self:RawHook(tkB, "new", function(...)
		local btn = self.hooks[tkB].new(...)
		self:skinButton{obj=btn}
		return btn
		end)
	end

	if tKDd and tKG and tKS and tKAP and tkB then allHooked = true end
	
end
