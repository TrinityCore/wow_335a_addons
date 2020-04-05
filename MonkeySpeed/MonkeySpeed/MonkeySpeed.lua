-- OnLoad Function
function MonkeySpeed_OnLoad(self)
	-- register events
	self:RegisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE")
	self:RegisterEvent("UNIT_EXITED_VEHICLE")
end

-- OnEvent Function
function MonkeySpeed_OnEvent(self, event, ...)
	local arg1 = ...
	if (event == "VARIABLES_LOADED") then
		MonkeySpeed_Init()
		return
	end
	if (event == "UNIT_ENTERED_VEHICLE") then
		if arg1 == "player" then
			MonkeySpeedTemp.currentUnit = "vehicle"
		end
	end
	if (event == "UNIT_EXITED_VEHICLE") then
		if arg1 == "player" then
			MonkeySpeedTemp.currentUnit = "player"
		end
	end
end

-- OnUpdate Function
function MonkeySpeed_OnUpdate(self, elapsed)
	-- how long since the last update?
	MonkeySpeedTemp.deltaTime = MonkeySpeedTemp.deltaTime + elapsed
	if (MonkeySpeedTemp.deltaTime >= .1) then
		local iSpeed = GetUnitSpeed(MonkeySpeedTemp.currentUnit)
		if iSpeed and iSpeed >= 0 then
			MonkeySpeedTemp.deltaTime = 0.0
			if (MonkeySpeedVars.absoluteSpeed == true) or not (IsSwimming() or IsFlying()) then
				MonkeySpeedTemp.currentSpeed = MonkeySpeed_Round(iSpeed/7 * 100)
			else
				MonkeySpeedTemp.currentSpeed = MonkeySpeed_Round((iSpeed/7 * 100) * math.cos(GetUnitPitch(MonkeySpeedTemp.currentUnit)))
			end
			if (MonkeySpeedVars.showPercent == true) then
				-- Set the text for the speedometer
				MonkeySpeedText:SetText(format("%d%%", MonkeySpeedTemp.currentSpeed))
			end
			if (MonkeySpeedVars.showBar == true) then
				-- Set the colour of the bar
				local var = MonkeySpeedVars
				if (MonkeySpeedTemp.currentSpeed == 0.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour1.r, var.speedColour1.g, var.speedColour1.b)
				elseif (MonkeySpeedTemp.currentSpeed < 100.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour2.r, var.speedColour2.g, var.speedColour2.b)
				elseif (MonkeySpeedTemp.currentSpeed == 100.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour3.r, var.speedColour3.g, var.speedColour3.b)
				elseif (MonkeySpeedTemp.currentSpeed < 200.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour4.r, var.speedColour4.g, var.speedColour4.b)
				elseif (MonkeySpeedTemp.currentSpeed == 200.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour5.r, var.speedColour5.g, var.speedColour5.b)
				elseif (MonkeySpeedTemp.currentSpeed < 380.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour6.r, var.speedColour6.g, var.speedColour6.b)
				elseif (MonkeySpeedTemp.currentSpeed == 380.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour7.r, var.speedColour7.g, var.speedColour7.b)
				elseif (MonkeySpeedTemp.currentSpeed < 410.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour8.r, var.speedColour8.g, var.speedColour8.b)
				elseif (MonkeySpeedTemp.currentSpeed == 410.0) then
					MonkeySpeedBar:SetVertexColor(var.speedColour9.r, var.speedColour9.g, var.speedColour9.b)
				else
					MonkeySpeedBar:SetVertexColor(var.speedColour10.r, var.speedColour10.g, var.speedColour10.b)
				end
			end
		else
			if (MonkeySpeedVars.showPercent == true) then
				-- Set the text for the speedometer
				MonkeySpeedText:SetText("???")
			end
			if (MonkeySpeedVars.showBar == true) then
				-- Set the colour of the bar
				MonkeySpeedBar:SetVertexColor(0.5, 0.5, 0.5)
			end
		end
	end
end

function MonkeySpeed_OnMouseDown(self, button)
	if (button == "LeftButton" and MonkeySpeedVars.frameLocked == false) then
		MonkeySpeedFrame:StartMoving()
		return
	end
	-- right button on the title or frame opens up the Blizzard Options
	if (button == "RightButton") then
		if (MonkeySpeedVars.rightClickOpensConfig == true) then
			InterfaceOptionsFrame_OpenToCategory("MonkeySpeed")
		end
	end
end

function MonkeySpeed_OnMouseUp(self, button)
	if (button == "LeftButton") then
		MonkeySpeedFrame:StopMovingOrSizing()
	end
end

function MonkeySpeed_Round(x)
	if(x - floor(x) > 0.5) then
		x = x + 0.5
	end
	return floor(x)
end

function MonkeySpeed_shown_Changed()
	if (MonkeySpeedVars.shown == false) then
		MonkeySpeedFrame:Hide()
	else
		local var = MonkeySpeedVars.frameColour
		MonkeySpeedFrame:SetBackdropColor(var.r, var.g, var.b, var.a)
		MonkeySpeedFrame:Show()
	end
end

function MonkeySpeed_frameColour_Changed(prevColour)
	local var = MonkeySpeedVars.frameColour
	if (MonkeySpeedOptions) then
		if (prevColour) then
			var.r = prevColour.r
			var.g = prevColour.g
			var.b = prevColour.b
		else
			var.a = OpacitySliderFrame:GetValue()
			var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
		end
		getglobal("MonkeySpeedC1_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
		MonkeySpeedFrame:SetBackdropColor(var.r, var.g, var.b, var.a)
	end
end

function MonkeySpeed_showBorder_Changed()
	local var = MonkeySpeedVars.borderColour
	if (MonkeySpeedVars.showBorder == false) then
		MonkeySpeedFrame:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0)
	else
		MonkeySpeedFrame:SetBackdropBorderColor(var.r, var.g, var.b)
	end
end

function MonkeySpeed_borderColour_Changed(prevColour)
	local var = MonkeySpeedVars.borderColour
	if (MonkeySpeedOptions) then
		if (prevColour) then
			var.r = prevColour.r
			var.g = prevColour.g
			var.b = prevColour.b
		else
			var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
		end
		MonkeySpeedVars.showBorder = true
		MonkeySpeedCB2:SetChecked(MonkeySpeedVars.showBorder)
		getglobal("MonkeySpeedC2_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
		MonkeySpeedFrame:SetBackdropBorderColor(var.r, var.g, var.b)
	end
end

function MonkeySpeed_frameLocked_Changed()
	if (MonkeySpeedVars.frameLocked == false and MonkeySpeedFrame:IsVisible()) then
		MonkeySpeedFrame:Hide()
		MonkeySpeedResizerBtn:Show()
		MonkeySpeedFrame:Show()
	elseif (MonkeySpeedVars.frameLocked == false) then
		MonkeySpeedResizerBtn:Show()
	elseif (MonkeySpeedVars.frameLocked == true) then
		MonkeySpeedResizerBtn:Hide()
	end
end

function MonkeySpeed_showPercent_Changed()
	if (MonkeySpeedVars.showPercent == false) then
		MonkeySpeedText:Hide()
	else
		MonkeySpeedText:Show()
	end
end

function MonkeySpeed_showBar_Changed()
	if (MonkeySpeedVars.showBar == false) then
		MonkeySpeedBar:Hide()
	else
		MonkeySpeedBar:Show()
	end
end

function MonkeySpeed_speedColour1_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour1
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC3_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour2_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour2
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC4_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour3_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour3
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC5_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour4_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour4
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC6_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour5_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour5
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC7_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour6_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour6
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC8_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour7_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour7
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC9_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour8_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour8
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC10_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour9_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour9
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC11_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeed_speedColour10_Changed(prevColour)
	local var = MonkeySpeedVars.speedColour10
	if (prevColour) then
		var.r = prevColour.r
		var.g = prevColour.g
		var.b = prevColour.b
	else
		var.r, var.g, var.b = ColorPickerFrame:GetColorRGB()
	end
	getglobal("MonkeySpeedC12_ColourBnt_SwatchTexture"):SetVertexColor(var.r, var.g, var.b)
end

function MonkeySpeedResizerBtn_OnMouseDown(self, button)
	if (button == "LeftButton") then
		this:GetParent():StartSizing()
	end
end

function MonkeySpeedResizerBtn_OnMouseUp(self, button)
	if (button == "LeftButton") then
		this:GetParent():StopMovingOrSizing()
	end
end
