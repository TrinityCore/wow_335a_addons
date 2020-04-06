if not Skinner:isAddonEnabled("Violation") then return end

function Skinner:Violation()

	local violationsSkinned = {}

	local function skinViolation()

		local function skinVFrame(frame)

--		 	Skinner:Debug("VframeSkin: [%s, %s]",frame, violationsSkinned[frame])

			if not violationsSkinned[frame] then
				frame.header:SetWidth(frame:GetWidth() - 48)
				local yOfs = select(5, frame.header:GetPoint())
				yOfs = math.floor(yOfs)
--		 		Skinner:Debug("V_header_GP: [%s]", yOfs)
				if yOfs == -14 then
					Skinner:moveObject(frame.header, nil, nil, "+", 9, frame)
					Skinner:moveObject(frame.closebutton, nil, nil, "+", 9, frame)
					Skinner:moveObject(frame.prevbutton, nil, nil, "+", 9, frame)
					Skinner:moveObject(frame.nextbutton, nil, nil, "+", 9, frame)
				end
				Skinner:applySkin(frame)
				violationsSkinned[frame] = true
				frame.SetBackdropBorderColor = function() end
			end

		end

		for _, Vw in ipairs(Violation.windows) do
--			Skinner:Debug("V-window: [%s]", Vw)
			if Vw then
				-- hook this to manage the statusbars
				if not Skinner:IsHooked(Vw, "SetBar") then
					Skinner:SecureHook(Vw, "SetBar", function(this, count)
						local btn = this.currentBars[count]
--	 					Skinner:Debug("V-statusbar: [%s, %s]", btn, btn.statusbar)
						if btn then
--	 						Skinner:Debug("V: [%s, %s]", btn, btn:GetWidth())
							btn:ClearAllPoints()
							if count == 1 then
								btn:SetPoint("TOP", this.frame, "TOP", 0, -21)
							else
								btn:SetPoint("TOP", this.currentBars[count - 1], "BOTTOM", 0, -1)
							end
							btn:SetPoint("LEFT", this.frame, "LEFT", 4, 0)
							btn:SetPoint("RIGHT", this.frame, "RIGHT", -4, 0)
						end
					end)
				end
				local frame = Vw.frame
--	 			Skinner:Debug("V-frame: [%s, %s, %s, %s]", frame, violationsSkinned[frame], Vw.options.show, frame:IsShown())
				if Vw.options.show then
					if not violationsSkinned[frame] then
						skinVFrame(frame)
						-- hook this to manage the frame
						if not Skinner:IsHooked(frame, "OnShow") then
							Skinner:HookScript(frame, "OnShow", function(this)
								Skinner.hooks[this].OnShow(this)
								skinVFrame(this)
							end)
						end
					end
				end
			end
		end

	end

	self:SecureHook(Violation, "ToggleWindows", function(this, show)
-- 		self:Debug("V - ToggleWindows: [%s]", show)
		skinViolation()
	end)
	self:RawHook(Violation, "OpenWindows", function(this)
-- 		self:Debug("V - OpenWindows")
		skinViolation()
		self.hooks[this].OpenWindows(this)
	end, true)
	self:SecureHook(Violation, "SetupWindows", function(this)
-- 		self:Debug("V - SetupWindows")
		skinViolation()
	end)
	self:SecureHook(Violation, "UpdateWindows", function(this, sameamount)
-- 		self:Debug("V- UpdateWindows: [%s]", sameamount)
		skinViolation()
	end)
	self:SecureHook(Violation, "DeleteWindow", function(this, window)
-- 		self:Debug("V - DeleteWindow: [%s, %s]", window, window.frame)
		violationsSkinned[window.frame] = nil
		if self:IsHooked(frame, "OnShow") then self:Unhook(frame, "OnShow") end
	end)

	skinViolation()

end
