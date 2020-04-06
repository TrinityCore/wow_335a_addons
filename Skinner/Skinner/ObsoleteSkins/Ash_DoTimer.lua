
local function skinTimerFrames(this, targets, timers)
--	Skinner:Debug("skinTimerFrames: [%d, %d]", targets, timers)

	if targets == 0 then return end

	targets = math.max(targets, this.libraries["TimerLib"].totaltargets)
	timers  = math.max(timers, this.libraries["TimerLib"].totaltargets)
	local targetframe = this.libraries["TimerLib"].targetframe
	local timerframe  = this.libraries["TimerLib"].timerframe
	for i = 1, targets do
		for id = 1, timers do
			local timerstr = targetframe..i..timerframe..id
			Skinner:glazeStatusBar(_G[timerstr.."BarStatusFront"])
			Skinner:glazeStatusBar(_G[timerstr.."BarBackground"])
			local tex = _G[timerstr.."IconButtonTexture"]
			if not tex.skinned then
--				Skinner:Debug("Timerstring:[%s]", timerstr)
				local pFrame = _G[timerstr.."Icon"]
				Skinner:addSkinButton(tex, pFrame, pFrame)
				tex.skinned = true
			end
		end
	end

end

local function skinGUI(frame)

	if not frame.skinned then
		for i = 1, select("#", frame:GetChildren()) do
			local child = select(i, frame:GetChildren())
			if child.initialize then
				Skinner:keepFontStrings(child)
			elseif child:GetFrameType() == "EditBox" then
				Skinner:skinEditBox(child, {9})
			end
		end
		Skinner:applySkin(frame, true)
		frame.skinned = true
	end

end


function Skinner:Ash_Core()

	-- Hook to skin the Profile GUI
	self:SecureHook(ProfileLib, "ShowGUI", function(this)
--		self:Debug("PL_ShowGUI")
		skinGUI(ProfileMenuFrame)
		ProfileMenuFrame:SetWidth(ProfileMenuFrame:GetWidth() + 10)
	end)

	-- Hook these to Skin the DropDown frames
	self:SecureHook(DropDownLib, "CreateFrames", function(this, level, index)
--		self:Debug("DDL_CF: [%s, %s, %s]", this, level, index)
		local ddFrameObj = _G["DropDownLibList"..level]
		if ddFrameObj and not self:IsHooked(ddFrameObj, "OnShow") then
			self:RawHookScript(ddFrameObj, "OnShow", function(this)
				self:keepFontStrings(this)
				_G[this:GetName().."Backdrop"]:Hide()
				_G[this:GetName().."MenuBackdrop"]:Hide()
				self:applySkin(this)
				self.hooks[this].OnShow()
			end)
		end
	end)

end

function Skinner:Ash_DoTimer()

--	Hook to skin the Main GUI
	self:SecureHook(DoTimer, "ShowGUI", function(this)
--		self:Debug("DT_ShowGUI")
		skinGUI(DoTimerMenuFrame)
	end)

--	Hook to skin the Timer GUI
	self:SecureHook(DoTimer, "ShowTimerGUI", function(this)
--		self:Debug("DT_ShowTimerGUI")
		skinGUI(DoTimerTimerMenuFrame)
	end)

--	Hook to skin the DOT Timers
	self:SecureHook(DoTimer, "CreateFrames", function(this, targets, timers)
--		self:Debug("DT_CF: [%d, %d]", targets, timers)
		skinTimerFrames(this, targets, timers)
	end)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then SpellSystemScanningFrame:SetBackdrop(self.backdrop) end
		self:skinTooltip(SpellSystemScanningFrame)
	end

end

function Skinner:Ash_Cooldowns()

--	Hook to skin the Cooldowns GUI
	self:SecureHook(Cooldowns, "ShowGUI", function(this)
--		self:Debug("CD_ShowGUI")
		skinGUI(CooldownsMenuFrame)
	end)
--	Hook to skin the Cooldowns Timer GUI
	self:SecureHook(Cooldowns, "ShowTimerGUI", function(this)
--		self:Debug("DT_ShowTimerGUI")
		skinGUI(CooldownsTimerMenuFrame)
	end)
--	Hook to skin the Cooldown Timers
	self:SecureHook(Cooldowns, "CreateFrames", function(this, targets, timers)
--		self:Debug("CT_CF: [%s, %s]", targets, timers)
		skinTimerFrames(this, targets, timers)
	end)

end
