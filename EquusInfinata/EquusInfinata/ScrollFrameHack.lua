--[[-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------]]--

local round = function (num) return math.floor(num + .5); end

function HSF_OnLoad (self)
	self:EnableMouse(true);
end

function HSF_OnValueChanged (self, value)
	HSF_SetOffset(self, value);
	HSF_UpdateButtonStates(self, value);
end
	
function HSF_UpdateButtonStates(self, currValue)
	if ( not currValue ) then
		currValue = self.scrollBar:GetValue();
	end
	
	self.scrollUp:Enable();
	self.scrollDown:Enable();

	local minVal, maxVal = self.scrollBar:GetMinMaxValues();
	if ( currValue >= maxVal ) then
		self.scrollBar.thumbTexture:Show();
		if ( self.scrollDown ) then
			self.scrollDown:Disable()
		end
	end
	if ( currValue <= minVal ) then
		self.scrollBar.thumbTexture:Show();
		if ( self.scrollUp ) then
			self.scrollUp:Disable();
		end
	end
end

function HSF_OnMouseWheel (self, delta, stepSize)
	if ( not self.scrollBar:IsVisible() ) then
		return;
	end
	
	local minVal, maxVal = 0, self.range;
	stepSize = stepSize or self.stepSize or 15;
	if ( delta == 1 ) then
		self.scrollBar:SetValue(max(minVal, self.scrollBar:GetValue() - stepSize));
	else
		self.scrollBar:SetValue(min(maxVal, self.scrollBar:GetValue() + stepSize));
	end
end

function HSFScrollButton_OnUpdate (self, elapsed)
	self.timeSinceLast = self.timeSinceLast + elapsed;
	if ( self.timeSinceLast >= ( self.updateInterval or 0.08 ) ) then
		if ( not IsMouseButtonDown("LeftButton") ) then
			self:SetScript("OnUpdate", nil);
		elseif ( MouseIsOver(self) ) then
			local parent = self.parent or self:GetParent():GetParent();
			HSF_OnMouseWheel (parent, self.direction, (self.stepSize or 15));
			self.timeSinceLast = 0;
		end
	end
end

function HSFScrollButton_OnClick (self, button, down)
	local parent = self.parent or self:GetParent():GetParent();
	
	if ( down ) then
		self.timeSinceLast = (self.timeToStart or -0.2);
		self:SetScript("OnUpdate", HSFScrollButton_OnUpdate);
		HSF_OnMouseWheel (parent, self.direction);
		PlaySound("UChatScrollButton");
	else
		self:SetScript("OnUpdate", nil);
	end
end

function HSF_Update (self, totalHeight, displayedHeight)
	local range = totalHeight - self:GetHeight();
	if ( range > 0 and self.scrollBar ) then
		local minVal, maxVal = self.scrollBar:GetMinMaxValues();
		if ( math.floor(self.scrollBar:GetValue()) >= math.floor(maxVal) ) then
			self.scrollBar:SetMinMaxValues(0, range)
			if ( math.floor(self.scrollBar:GetValue()) ~= math.floor(range) ) then
				self.scrollBar:SetValue(range);
			else
				HSF_SetOffset(self, range); -- If we've scrolled to the bottom, we need to recalculate the offset.
			end
		else
			self.scrollBar:SetMinMaxValues(0, range)
		end
		self.scrollBar:Enable();
		HSF_UpdateButtonStates(self);
		self.scrollBar:Show();
	elseif ( self.scrollBar ) then
		self.scrollBar:SetValue(0);
		self.scrollBar:Disable();
		self.scrollUp:Disable();
		self.scrollDown:Disable();
		self.scrollBar.thumbTexture:Hide();
	end
	
	self.range = range;
	self:UpdateScrollChildRect();
end

function HSF_GetOffset (self)
	return math.floor(self.offset or 0), (self.offset or 0);
end

function HSFScrollChild_OnLoad (self)
	self:GetParent().scrollChild = self;
end

function HSF_ExpandButton (self, offset, height)
	self.largeButtonTop = round(offset);
	self.largeButtonHeight = round(height)
	HSF_SetOffset(self, self.scrollBar:GetValue());
end

function HSF_CollapseButton (self)
	self.largeButtonTop = nil;
	self.largeButtonHeight = nil;
end

function HSF_SetOffset (self, offset)
	self:SetVerticalScroll(offset);
end

function HSF_CreateButtons (self, buttonTemplate, initialOffsetX, initialOffsetY, initialPoint, initialRelative, offsetX, offsetY, point, relativePoint)
	local scrollChild = self.scrollChild;
	local button, buttonHeight, buttons, numButtons;
	
	local buttonName = self:GetName() .. "Button";
	
	initialPoint = initialPoint or "TOPLEFT";
	initialRelative = initialRelative or "TOPLEFT";
	point = point or "TOPLEFT";
	relativePoint = relativePoint or "BOTTOMLEFT";
	offsetX = offsetX or 0;
	offsetY = offsetY or 0;
	
	if ( self.buttons ) then
		buttons = self.buttons;
		buttonHeight = buttons[1]:GetHeight();
	else
		button = CreateFrame("BUTTON", buttonName .. 1, scrollChild, buttonTemplate);
		buttonHeight = button:GetHeight();
		button:SetPoint(initialPoint, scrollChild, initialRelative, initialOffsetX, initialOffsetY);
		buttons = {}
		tinsert(buttons, button);
	end
	
	self.buttonHeight = round(buttonHeight);
	
	local numButtons = math.ceil(self:GetHeight() / buttonHeight) + 1;
	
	for i = #buttons + 1, numButtons do
		button = CreateFrame("BUTTON", buttonName .. i, scrollChild, buttonTemplate);
		button:SetPoint(point, buttons[i-1], relativePoint, offsetX, offsetY);
		tinsert(buttons, button);
	end
	
	scrollChild:SetWidth(self:GetWidth())
	scrollChild:SetHeight(numButtons * buttonHeight);
	self:SetVerticalScroll(0);
	self:UpdateScrollChildRect();
	
	self.buttons = buttons;
	local scrollBar = self.scrollBar;	
	scrollBar:SetMinMaxValues(0, numButtons * buttonHeight)
	scrollBar:SetValueStep(.005);
	scrollBar:SetValue(0);
end
