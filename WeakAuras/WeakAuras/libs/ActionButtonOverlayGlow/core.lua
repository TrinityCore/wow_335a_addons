--local SAO = CreateFrame("Frame", "SpellActivationOverlay")


--Overlay stuff
local unusedOverlayGlows = {}
local numOverlays = 0

function ActionButton_CreateOverlayGlow()
	local f = CreateFrame("Frame", "ActionButtonOverlay"..numOverlays, UIParent)
	
--Spark
	local t = f:CreateTexture(nil, "BACKGROUND")
	t:SetTexture("Interface\\AddOns\\WeakAuras\\libs\\ActionButtonOverlayGlow\\IconAlert")
	t:SetTexCoord(0.00781250, 0.61718750, 0.00390625, 0.26953125)
	t:SetAlpha(1)
	--t:SetAllPoints()
	t:SetPoint("CENTER")
	f.spark = t
	
--InnerGlow
	local t = f:CreateTexture(nil, "ARTWORK")
	t:SetTexture("Interface\\AddOns\\WeakAuras\\libs\\ActionButtonOverlayGlow\\IconAlert")
	t:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
	t:SetAlpha(1)
	--t:SetAllPoints()
	t:SetPoint("CENTER")
	f.innerGlow = t
	
--InnerGlowOver
	local t = f:CreateTexture(nil, "ARTWORK")
	t:SetTexture("Interface\\AddOns\\WeakAuras\\libs\\ActionButtonOverlayGlow\\IconAlert")
	t:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)
	t:SetAlpha(1)
	--t:SetAllPoints()
	t:SetPoint("TOPLEFT", f.innerGlow, "TOPLEFT")
	t:SetPoint("BOTTOMRIGHT", f.innerGlow, "BOTTOMRIGHT")
	f.innerGlowOver = t
	
--OuterGlow
	local t = f:CreateTexture(nil, "ARTWORK")
	t:SetTexture("Interface\\AddOns\\WeakAuras\\libs\\ActionButtonOverlayGlow\\IconAlert")
	t:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
	t:SetAlpha(1)
	--t:SetAllPoints()
	t:SetPoint("CENTER")
	f.outerGlow = t
	
--OuterGlowOver
	local t = f:CreateTexture(nil, "ARTWORK")
	t:SetTexture("Interface\\AddOns\\WeakAuras\\libs\\ActionButtonOverlayGlow\\IconAlert")
	t:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)
	t:SetAlpha(1)
	--t:SetAllPoints()
	t:SetPoint("TOPLEFT", f.outerGlow, "TOPLEFT")
	t:SetPoint("BOTTOMRIGHT", f.outerGlow, "BOTTOMRIGHT")
	f.outerGlowOver = t
	
--Ants
	local t = f:CreateTexture(nil, "OVERLAY")
	t:SetTexture("Interface\\AddOns\\WeakAuras\\libs\\ActionButtonOverlayGlow\\IconAlertAnts")
	--t:SetTexCoord()
	t:SetAlpha(1)
	--t:SetAllPoints()
	t:SetPoint("CENTER")
	f.ants = t
	
	
--[[
	local t = f:CreateTexture(nil, "")
	t:SetTexture("Interface\\AddOns\\WeakAuras\\libs\\ActionButtonOverlayGlow\\IconAlert")
	t:SetTexCoord()
	t:SetAlpha(1)
	t:SetAllPoints()
	t:SetPoint()
	f. = t
]]

	
--Animation settings
	f.animIn = {
		elapsed = 0,
		config = {
			[1] = {
				name = "spark",
				scaleX = 1.5,
				scaleY = 1.5,
				alpha = 1,
				duration = 0.2
			},
			[2]  = {
				name = "innerGlow",
				scaleX = 1,
				scaleY = 1,
				duration = 0.3
			},
			[3] = {
				name = "innerGlowOver",
				scaleX = 1,
				scaleY = 1,
				alpha = -1,
				duration = 0.3
			},
			[4]  = {
				name = "outerGlow",
				scaleX = 1,
				scaleY = 1,
				duration = 0.3
			},
			[5] = {
				name = "outerGlowOver",
				scaleX = 1,
				scaleY = 1,
				alpha = -1,
				duration = 0.3
			},
			[6] = {
				name = "spark",
				startdelay = 0.2,
				scaleX = 1,
				scaleY = 1,
				alpha = -1,
				duration = 0.2
			},
			[7] = {
				name = "innerGlow",
				startdelay = 0.3,
				alpha = -1,
				duration = 0.2
			},
			[8] = {
				name = "ants",
				startdelay = 0.3,
				alpha = 1,
				duration = 0.2
			},
		},
		OnPlay = function()
			f.animIn.elapsed = 0
            local frameWidth, frameHeight = f:GetSize()
            f.spark:SetSize(frameWidth, frameHeight)
			f.spark.currentAlpha = 0.3
            f.spark:SetAlpha(f.spark.currentAlpha)
			f.innerGlow.currentScale = 0.5
            f.innerGlow:SetSize(frameWidth * f.innerGlow.currentScale, frameHeight * f.innerGlow.currentScale)
            f.innerGlow.currentAlpha = 1
			f.innerGlow:SetAlpha(f.innerGlow.currentAlpha)
			f.innerGlowOver.currentAlpha = 1
            f.innerGlowOver:SetAlpha(f.innerGlowOver.currentAlpha)
			f.outerGlow.currentScale = 2
            f.outerGlow:SetSize(frameWidth * f.outerGlow.currentScale, frameHeight * f.outerGlow.currentScale)
            f.outerGlow.currentAlpha = 1
			f.outerGlow:SetAlpha(f.outerGlow.currentAlpha)
			f.outerGlowOver.currentAlpha = 1
            f.outerGlowOver:SetAlpha(f.outerGlowOver.currentAlpha)
            f.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85)
			f.ants.currentAlpha = 0
            f.ants:SetAlpha(f.ants.currentAlpha)
            f:Show()
		end,
		OnFinished = function()
			f.animIn.IsPlaying = false
			f.animIn.elapsed = 0
            local frameWidth, frameHeight = f:GetSize()
            f.spark:SetAlpha(0)
            f.innerGlow:SetAlpha(0)
            f.innerGlow:SetSize(frameWidth, frameHeight)
            f.innerGlowOver:SetAlpha(0.0)
            f.outerGlow:SetSize(frameWidth, frameHeight)
            f.outerGlowOver:SetAlpha(0.0)
            f.outerGlowOver:SetSize(frameWidth, frameHeight)
            f.ants:SetAlpha(1.0)
		end
	}
	
	f.animOut = {
		elapsed = 0,
		config = {
			[1] = {
				name = "outerGlowOver",
				alpha = 1,
				duration = 0.2
			},
			[2] = {
				name = "ants",
				alpha = -1,
				duration = 0.2
			},
			[3] = {
				name = "outerGlowOver",
				startdelay = 0.2,
				alpha = -1,
				duration = 0.2
			},
			[4] = {
				name = "outerGlow",
				startdelay = 0.2,
				alpha = -1,
				duration = 0.2
			},
		},
		OnFinished = function()
			f.animOut.IsPlaying = false
			f.animOut.elapsed = 0
			ActionButton_OverlayGlowAnimOutFinished(f)
		end
	}
	
--Animation functions
	function f.animIn.Play()
		f.animIn.OnPlay()
		f.animIn.IsPlaying = true
	end
	
	function f.animIn.Stop()
		f.animIn.IsPlaying = false
		f.animIn.OnFinished()
	end
	
	function f.animOut.Play()
		f.animOut.IsPlaying = true
	end
	
	function f.animOut.Stop()
		f.animOut.IsPlaying = false
		f.animOut.OnFinished()
	end
	
	
--OnUpdate
	f:SetScript("OnUpdate", function(self,elapsed)
		
		if f.animIn.IsPlaying then
			f.animIn.elapsed = f.animIn.elapsed + elapsed
			
			local curDur = f.animIn.elapsed
			local activeAnim = 0
			
			for i=1,#f.animIn.config do
				local a = f.animIn.config[i]
				
				local delay = a.startDelay or 0
				
				if curDur >= delay then
					local start = curDur - delay
					local finish = delay + a.duration
					local progress = (curDur >= finish and 1) or 1/finish*start
					
					if a.scaleX and a.scaleY then
						local tex = f[a.name]
						local curScale = f[a.name].currentScale or 1
						local baseSizeX, baseSizeY = f:GetSize()
						tex:ClearAllPoints()
						tex:SetPoint("CENTER")
						tex:SetSize(baseSizeX*(curScale - (curScale - a.scaleX)*progress), baseSizeY*(curScale - (curScale - a.scaleY)*progress))
					end
					
					if a.alpha then
						f[a.name]:SetAlpha(f[a.name].currentAlpha - (a.alpha*progress))
					end
					
					if progress < 1 then
						activeAnim = activeAnim + 1
					end
					
				end
				
			end
			
			if activeAnim == 0 then
				f.animIn.OnFinished()
			end
			
		elseif f.animOut.IsPlaying then
			f.animOut.elapsed = f.animOut.elapsed + elapsed
			
			local curDur = f.animOut.elapsed
			local activeAnim = 0
			
			for i=1,#f.animOut.config do
				local a = f.animOut.config[i]
				
				local delay = a.startDelay or 0
				
				if curDur >= delay then
					local start = curDur - delay
					local finish = delay + a.duration
					local progress = (curDur >= finish and 1) or 1/finish*start
					
					if a.scaleX and a.scaleY then
						local tex = f[a.name]
						f[a.name].currentScale = (progress==1 and a.scaleX) or 1
						local curScale = f[a.name].currentScale
						local baseSize = f:GetSize()
						tex:ClearAllPoints()
						tex:SetPoint("CENTER")
						tex:SetSize(baseSize*(curScale+a.scaleX*progress), baseSize*(curScale+a.scaleY*progress))
					end
					
					if a.alpha then
						f[a.name]:SetAlpha(f[a.name].currentAlpha - (a.alpha*progress))
					end
					
					if progress < 1 then
						activeAnim = activeAnim + 1
					end
					
				end
				
			end
			
			if activeAnim == 0 then
				f.animOut.OnFinished()
			end
		end
		
		AnimateTexCoords2(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01)
	end)
	
--OnHide
	f:SetScript("OnHide", function(self)
		if self.animOut.IsPlaying then
          self.animOut:Stop()
          ActionButton_OverlayGlowAnimOutFinished(self.animOut)
        end
	end)
	
	return f
end

function AnimateTexCoords2(texture, textureWidth, textureHeight, frameWidth, frameHeight, numFrames, elapsed, throttle)
  if ( not texture.frame ) then
    -- initialize everything
    texture.frame = 1
    texture.throttle = throttle
    texture.numColumns = floor(textureWidth/frameWidth)
    texture.numRows = floor(textureHeight/frameHeight)
    texture.columnWidth = frameWidth/textureWidth
    texture.rowHeight = frameHeight/textureHeight
  end
  local frame = texture.frame
  if ( not texture.throttle or texture.throttle > throttle ) then
    local framesToAdvance = floor(texture.throttle / throttle)
    while ( frame + framesToAdvance > numFrames ) do
      frame = frame - numFrames
    end
    frame = frame + framesToAdvance
    texture.throttle = 0
    local left = mod(frame-1, texture.numColumns)*texture.columnWidth
    local right = left + texture.columnWidth
    local bottom = ceil(frame/texture.numColumns)*texture.rowHeight
    local top = bottom - texture.rowHeight
    texture:SetTexCoord(left, right, top, bottom)
 
    texture.frame = frame
  else
    texture.throttle = texture.throttle + elapsed
  end
end

function ActionButton_GetOverlayGlow()
  local overlay = tremove(unusedOverlayGlows)
  if ( not overlay ) then
    numOverlays = numOverlays + 1
    --overlay = CreateFrame("Frame", "ActionButtonOverlay"..numOverlays, UIParent, "ActionBarButtonSpellActivationAlert")
	overlay = ActionButton_CreateOverlayGlow()
  end
  return overlay
end
 
function ActionButton_UpdateOverlayGlow(self)
  local spellType, id, subType  = GetActionInfo(self.action)
  if ( spellType == "spell" and IsSpellOverlayed(id) ) then
    ActionButton_ShowOverlayGlow(self)
  else
    ActionButton_HideOverlayGlow(self)
  end
end
 
function ActionButton_ShowOverlayGlow(self)

  if self.overlay then
    if self.overlay.animOut.IsPlaying then
	  self.overlay.animOut.IsPlaying = false	--self.overlay.animOut:Stop()
      self.overlay.animIn:Play()
    end
  else
    self.overlay = ActionButton_GetOverlayGlow()
    local frameWidth, frameHeight = self:GetSize()
    self.overlay:SetParent(self)
    self.overlay:ClearAllPoints()
    self.overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * 0.2, frameHeight * 0.2)
    self.overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * 0.2, -frameHeight * 0.2)
    self.overlay.animIn:Play()
  end
end
 
function ActionButton_HideOverlayGlow(self)
  if self.overlay then
    if self.overlay.animIn.IsPlaying then
      self.overlay.animIn:Stop()
    end
    if self:IsVisible() then
      self.overlay.animOut:Play()
    else
      ActionButton_OverlayGlowAnimOutFinished(self.overlay.animOut)  --We aren't shown anyway, so we'll instantly hide it.
    end
  end
end
 
function ActionButton_OverlayGlowAnimOutFinished(overlay)
  local actionButton = overlay:GetParent()
  overlay:Hide()
  tinsert(unusedOverlayGlows, overlay)
  actionButton.overlay = nil
end
