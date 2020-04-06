if not Skinner:isAddonEnabled("EditingUI") then return end

function Skinner:EditingUI()

	local kRegions = CopyTable(self.ebRegions)
	table.insert(kRegions, 9)

	local function skinEUIEB(frame)

		Skinner:keepRegions(frame, kRegions)

		local l, r, t, b = frame:GetTextInsets()
		frame:SetTextInsets(l + 5, r + 0, t, b)

		-- move the title(s) to the right
		if Skinner:getChild(frame, 1) then
			Skinner:moveObject{obj=Skinner:getChild(frame, 1), x=5}
		end
		if Skinner:getRegion(frame, 9) then
			Skinner:moveObject{obj=Skinner:getRegion(frame, 9), x=5}
		end

		Skinner:skinUsingBD2(frame)

	end

-->>--	Toggle Button
	self:skinButton{obj=EditingFrameToggleButton, mp2=true, plus=true}
	self:moveObject{obj=EditingFrameToggleButton, y=-18}
	self:moveObject{obj=EditingFrame, y=-18, relTo=UIParent}

-->>--	Title Panel
	self:addSkinFrame{obj=EditingFrameTitleBar, y2=1}
	skinEUIEB(EditingEditBox)

-->>--	Navigation Panel
	self:addSkinFrame{obj=EditingBoxNavigationFrame, y2=1}
	self:skinScrollBar{obj=EditingFrameParentScrollFrame}
	EditFrameParentHighlight:SetAlpha(1)
	self:skinScrollBar{obj=EditingFrameChildScrollFrame}
	EditFrameChildHighlight:SetAlpha(1)

-->>--	Anchor Panel
	self:addSkinFrame{obj=EditingFrameAnchorBar}
	skinEUIEB(EditingEditAnchorPoint)
	skinEUIEB(EditingEditRelativeTo)
	skinEUIEB(EditingEditRelativePoint)
	self:moveObject{obj=EditingEditX, x=-5}
	EditingEditX:SetWidth(40)
	skinEUIEB(EditingEditX)
	self:moveObject{obj=EditingEditY, x=-5}
	EditingEditY:SetWidth(40)
	skinEUIEB(EditingEditY)
	skinEUIEB(EditingEditWidth)
	skinEUIEB(EditingEditHeight)
	skinEUIEB(EditingFrameClipboard)

-->>--	Calculations Panel
	self:addSkinFrame{obj=EditingFrameCalculationsBar}
	skinEUIEB(EditingFrameR)
	skinEUIEB(EditingFrameG)
	skinEUIEB(EditingFrameB)
	skinEUIEB(EditingFrameTCoordWidth)
	skinEUIEB(EditingFrameTCoordHeight)
	skinEUIEB(EditingFrameTCoordLeft)
	skinEUIEB(EditingFrameTCoordRight)
	skinEUIEB(EditingFrameTCoordTop)
	skinEUIEB(EditingFrameTCoordBottom)

-->>--	Debug Panel
	self:addSkinFrame{obj=EditingFrameDebugBar}
	skinEUIEB(EditingFrameDebugPrint)
	skinEUIEB(EditingFrameRunScript)

-->>--	Tab Panel
	self:skinButton{obj=CalculationPlusButton, mp2=true, plus=true}
	self:applySkin(ExpandCalculationButton)
	self:skinButton{obj=DebugPlusButton, mp2=true, plus=true}
	self:applySkin(ExpandDebugButton)

end
