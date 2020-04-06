local minor = 0

if not RoundedDropDownFrame or RoundedDropDownFrame.minor < minor then
  if not RoundedDropDownFrame then
    RoundedDropDownFrame = {}
  end
  
  RoundedDropDownFrame.OnLoad = function(self, obj)
    obj:SetBackdropColor(0,0,0,1)
    obj.label = _G[obj:GetName().."Label"]
    obj.label:SetWidth(obj:GetWidth())
    obj.text = _G[obj:GetName().."Text"]
    obj.text:SetWidth(obj:GetWidth() - 25)
    obj.text:SetHeight(14)
    obj.button = _G[obj:GetName().."Button"]
    obj.dropDownOptions = {}
    obj.Init = self.Init
    obj.SetText = self.SetText
    obj.SetFormattedText = self.SetFormattedText
    obj.SetLabel = self.SetLabel
    obj.SetCallback = self.SetCallback
    obj.Enable = RoundedDropDownFrame.Enable
    obj.Disable = RoundedDropDownFrame.Disable
  end
  
  RoundedDropDownFrame.Init = function(self, callback, labelFmt, ...)
    assert(callback, "RoundedDropDown:Init() - A callback must be specified")
    self.callback = callback
    if labelFmt then
      self:SetLabel(labelFmt, ...)
    end
  end

  RoundedDropDownFrame.SetCallback = function(self, callback)
    self.callback = callback
  end

  RoundedDropDownFrame.SetText = function(self, txt)
    self.text:SetFormattedText(txt)
  end

  RoundedDropDownFrame.SetFormattedText = function(self, fmt, ...)
    self.text:SetFormattedText(fmt, ...)
  end

  RoundedDropDownFrame.SetLabel = function(self, fmt, ...)
    self.label:SetFormattedText(fmt, ...)
  end

  RoundedDropDownFrame.OnEnter = function(self, frame)
    if frame.dropDownOptions.tooltip then
      GameTooltip:SetOwner(frame, "ANCHOR_TOP")
      if (type(frame.dropDownOptions.tooltip) == "table") then
        for i,line in pairs(frame.dropDownOptions.tooltip) do
          GameTooltip:AddLine(line)
        end
      elseif (type(frame.dropDownOptions.tooltip) == "string") then
        GameTooltip:AddLine(frame.dropDownOptions.tooltip)
      end
      GameTooltip:Show()
    end
  end

  RoundedDropDownFrame.OnLeave = function(self)
    GameTooltip:Hide()
  end

  RoundedDropDownFrame.Enable = function(self)
    self.text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    self.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    self.button:Enable()
  end

  RoundedDropDownFrame.Disable = function(self)
    self.text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
    self.label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
    self.button:Disable()
  end

  RoundedDropDownFrame.minor = minor
end