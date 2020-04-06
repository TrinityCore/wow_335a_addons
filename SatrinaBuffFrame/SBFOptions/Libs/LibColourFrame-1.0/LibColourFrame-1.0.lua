-- LibColourFrame version 1.0
-- Adds RGB fields as well as cut and paste buttons to ColorPickerFrame
-- 2008 Satrina@Stormrage

-- This is a beta version, and is subject to change before public release
-- Questions? satrina@evilempireguild.org

-- Localisation is at the end of this file

--[[
User Functions.  These functions are for you, the user!

And they will be documented soon!
]]

local vmajor, vminor = "LibColourFrame-1.0", 8

local ColourFrame, oldMinor = LibStub:NewLibrary(vmajor, vminor)
if not ColourFrame then
	return
end

local _G = getfenv(0)

local fromhex = function(n)
	return floor(n * 1000 / 255 + 0.5)/1000
end

local tohex = function(n)
	return floor(n * 255 + 0.5)
end

local round = function(n)
  return floor(n * 1000 + 0.5)/1000
end

local ColorPickerFrame = ColorPickerFrame

--
-- User functions
--
ColourFrame.colour = {}
ColourFrame.origColour = {}
ColourFrame.strings = {}

function ColourFrame:Open(callback, r, g, b, a)
  assert((callback and type(callback) == "function"), "A callback function is required for LibColourFrame:Open")
  assert(tonumber(r) and tonumber(b) and tonumber(g), "Invalid r,g,b input to LibColourFrame:Open")
  self:CreateFrame()
  self:Cleanup()
  ColorPickerFrame.func = nil
  ColorPickerFrame.cancelFunc = nil
  ColorPickerFrame.opacityFunc = nil
  if a then
    ColorPickerFrame.hasOpacity = true
    ColorPickerFrame.opacity = 1 - a
    self.useOpacity = true
  else
    ColorPickerFrame.hasOpacity = false
    ColorPickerFrame.opacity = 0
    self.useOpacity = false
  end
  if not EnhCP then
    self.isShown = true
  end
  self:SetOriginalColour(r,g,b,(a or 0))
  self.callback = callback 
  self.lcfOpened = true
  ShowUIPanel(ColorPickerFrame)
end

function ColourFrame:IsShown()
  return ColorPickerFrame:IsShown()
end

function ColourFrame:AddCopy(name, r, g, b, a)
  self:CreateFrame()
  r = round(r)
  g = round(g)
  b = round(b)
  if a then 
    a = round(a)
  else
    a = 1
  end
  for k,v in pairs(self.copy) do
    if (tohex(v.r) == tohex(r)) and (tohex(v.g) == tohex(g)) and (tohex(v.b) == tohex(b)) and (floor(v.a * 100 + 0.5) == floor(a * 100 + 0.5)) then
      return
    end
  end
  table.insert(self.copy, {r = r, g = g, b = b, a = a, name = name})
end

--
-- Internal functions
--

function ColourFrame:OnKeyDown()
  if ColourFrame.lcfOpened then
    ColourFrame:Callback(true)
  end
  if ColourFrame.origOnKeyDown then 
    ColourFrame.origOnKeyDown()
  end
end

function ColourFrame:OnShow()
  if ColourFrame.origOnShow then 
    ColourFrame.origOnShow(ColorPickerFrame)
  end
  
  if ColourFrame.lcfOpened then
    if ColourFrame.isShown then
      ColorPickerFrame:SetHeight(235)
      ColorPickerOkayButton:Hide()
      ColorPickerCancelButton:Hide()
      ColourFrame.red:Show()	
      ColourFrame.green:Show()	
      ColourFrame.blue:Show()	
      ColourFrame.alpha:Show()	
      ColourFrame:EnableAlpha(ColourFrame.useOpacity)
      ColourFrame.okButton:Show()
      ColourFrame.cancelButton:Show()
      ColourFrame.copyButton:Show()
      ColourFrame.pasteButton:Show()
      ColourFrame.red:SetFocus()	
      ColourFrame.red:HighlightText()	
    end
    ColorPickerFrame.func = ColourFrame.ColorPickerRGBCallback
    ColorPickerFrame.cancelFunc = ColourFrame.Cancel
    ColorPickerFrame.opacityFunc = ColourFrame.ColorPickerOpacityCallback
  end
end

function ColourFrame:OnHide()
  if ColourFrame.origOnHide then 
    ColourFrame.origOnHide()
  end
  
  if ColourFrame.lcfOpened then
    ColorPickerFrame:SetHeight(200)
    ColorPickerOkayButton:Show()
    ColorPickerCancelButton:Show()
    ColourFrame.okButton:Hide()
    ColourFrame.cancelButton:Hide()
    ColourFrame.copyButton:Hide()
    ColourFrame.pasteButton:Hide()
    ColourFrame.red:Hide()	
    ColourFrame.green:Hide()	
    ColourFrame.blue:Hide()	
    ColourFrame.alpha:Hide()
  else
    ColourFrame:Cleanup()
  end
end

function ColourFrame:Cleanup()
  ColourFrame.oldFunc = nil
  ColourFrame.oldCancelFunc = nil
  ColourFrame.oldOpacityFunc = nil
  ColourFrame.callback = nil
  ColourFrame.isShown = false
  ColourFrame.lcfOpened = false
end

function ColourFrame:OK()
  CloseDropDownMenus(1)
  ColourFrame:Callback()
  HideUIPanel(ColorPickerFrame)
  ColourFrame:Cleanup()
end

function ColourFrame:Cancel()
  CloseDropDownMenus(1) 
  ColourFrame:Callback(true)
  HideUIPanel(ColorPickerFrame)
  ColourFrame:Cleanup()
end

function ColourFrame:Callback(isCancel)
  if self.callback then
    if isCancel then
      self.callback(self.origColour.r, self.origColour.g, self.origColour.b, self.origColour.a)
    else
      self.callback(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
    end
  end
end

function ColourFrame:Copy()
  ColourFrame:AddCopy(nil, ColourFrame.colour.r, ColourFrame.colour.g, ColourFrame.colour.b, ColourFrame.colour.a)
  if not _G.CurrentlyCopiedColor then
    _G.CurrentlyCopiedColor = {}
    _G.CurrentlyCopiedColor.r = ColourFrame.colour.r
    _G.CurrentlyCopiedColor.g = ColourFrame.colour.g
    _G.CurrentlyCopiedColor.b = ColourFrame.colour.b
    _G.CurrentlyCopiedColor.a = (ColourFrame.useOpacity and ColourFrame.colour.a) or 1
  end
end

function ColourFrame:PasteDropDown_Initialise()
  if _G.CurrentlyCopiedColor then
    ColourFrame:AddCopy(nil, _G.CurrentlyCopiedColor.r, _G.CurrentlyCopiedColor.g, _G.CurrentlyCopiedColor.b, (_G.CurrentlyCopiedColor.a or 1))
  end
  local info = UIDropDownMenu_CreateInfo()
  for k,v in pairs(ColourFrame.copy) do
    if ColourFrame.useOpacity or (v.a == 1) then
      if ColourFrame.useOpacity then
        info.text = v.name or string.format("(%d, %d, %d, %d%%)", tohex(v.r), tohex(v.g), tohex(v.b), (v.a*100))
      else
        info.text = v.name or string.format("(%d, %d, %d)", tohex(v.r), tohex(v.g), tohex(v.b))
      end
      info.value = v
      info.func = ColourFrame.PasteDropDown_Callback
      info.hasColorSwatch = true
      info.r = v.r
      info.g = v.g
      info.b = v.b
      info.opacity = v.a
      UIDropDownMenu_AddButton(info)
    end
  end
end

function ColourFrame.PasteDropDown_Callback(info)
  ColourFrame.colour.r = info.r
  ColourFrame.colour.g = info.g
  ColourFrame.colour.b = info.b
  ColourFrame.colour.a = info.a or 1 
  ColourFrame:UpdateFields()
  ColourFrame:UpdateColorPickerFrame()
  ColourFrame:Callback()
end

function ColourFrame:SetOriginalColour(r, g, b, a)
  self.origColour.r = r
  self.origColour.g = g
  self.origColour.b = b
  self.origColour.a = a
  self.colour.r = r
  self.colour.g = g
  self.colour.b = b
  self.colour.a = a
  self:UpdateFields() 
  self:UpdateColorPickerFrame()
end

function ColourFrame:UpdateFromFields()
  if ColourFrame.noCallback then
    return
  end
  self.colour.r = round(fromhex(self.red:GetText()))
  self.colour.g = round(fromhex(self.green:GetText()))
  self.colour.b = round(fromhex(self.blue:GetText()))
  if self.useOpacity then
    self.colour.a = round(tonumber(self.alpha:GetText())/100)
  else
    self.colour.a = 1
  end
  self:UpdateColorPickerFrame()
  self:Callback()
end

function ColourFrame.ColorPickerRGBCallback()
  if ColourFrame.noCallback then
    return
  end
  local r,g,b
  local r,g,b = ColorPickerFrame:GetColorRGB()
  ColourFrame.colour.r = round(r)
  ColourFrame.colour.g = round(g)
  ColourFrame.colour.b = round(b)
  ColourFrame:UpdateFields()
  if ColourFrame.oldFunc then
    ColourFrame.oldFunc()
  else
    ColourFrame:Callback()
  end
end

function ColourFrame.ColorPickerOpacityCallback()
  if ColourFrame.noCallback then
    return
  end
  ColourFrame.colour.a = 1 - round(OpacitySliderFrame:GetValue())
  ColourFrame:UpdateFields()
  if ColourFrame.oldOpacityFunc then
    ColourFrame.oldOpacityFunc()
  else
    ColourFrame:Callback()
  end
end

function ColourFrame:UpdateColorPickerFrame()
  ColourFrame.noCallback = true
  ColorPickerFrame:SetColorRGB(self.colour.r, self.colour.g, self.colour.b)
  if ColourFrame.useOpacity then
    OpacitySliderFrame:SetValue(1 - self.colour.a)
  end
  ColourFrame.noCallback = false
end

function ColourFrame:UpdateFields()
  if self.isShown then
    ColourFrame.noCallback = true
    self.red:SetNumber(tohex(self.colour.r))
    self.green:SetNumber(tohex(self.colour.g))
    self.blue:SetNumber(tohex(self.colour.b))
    if self.useOpacity then
      self.alpha:SetNumber(self.colour.a * 100)
    else
      self.alpha:SetText("")
    end
    self.red.last = self.colour.r
    self.green.last = self.colour.g
    self.blue.last = self.colour.b
    self.alpha.last = self.colour.a
    ColourFrame.noCallback = false
  end
end

function ColourFrame:ToggleDropDown()
  ToggleDropDownMenu(1, nil, ColourFramePasteButtonDropDown)
end

function ColourFrame:CreateFrame()
  if ColourFrame.created then
    return
  end
  
  
  ColourFrame.origOnShow = ColorPickerFrame:GetScript("OnShow")
  ColorPickerFrame:SetScript("OnShow", ColourFrame.OnShow)
  ColourFrame.origOnHide = ColorPickerFrame:GetScript("OnHide")
  ColorPickerFrame:SetScript("OnHide", ColourFrame.OnHide)
  ColourFrame.origOnKeyDown = ColorPickerFrame:GetScript("OnKeyDown")
  ColorPickerFrame:SetScript("OnKeyDown", ColourFrame.OnKeyDown)
  
  ColourFrame.red = ColourFrame:Edit_Create(ColorPickerFrame)
  ColourFrame.red:SetPoint("BOTTOM", ColorPickerFrame, "BOTTOM", -92, 35)
  ColourFrame.red.label:SetText(ColourFrame.strings.red)
  ColourFrame.red:Hide()
  
  ColourFrame.green = ColourFrame:Edit_Create(ColorPickerFrame)
  ColourFrame.green:SetPoint("LEFT", ColourFrame.red, "RIGHT", 40, 0)
  ColourFrame.green.label:SetText(ColourFrame.strings.green)
  ColourFrame.green:Hide()

  ColourFrame.blue = ColourFrame:Edit_Create(ColorPickerFrame)
  ColourFrame.blue:SetPoint("LEFT", ColourFrame.green, "RIGHT", 40, 0)
  ColourFrame.blue.label:SetText(ColourFrame.strings.blue)
  ColourFrame.blue:Hide()

  ColourFrame.alpha = ColourFrame:Edit_Create(ColorPickerFrame, true)
  ColourFrame.alpha:SetPoint("LEFT", ColourFrame.blue, "RIGHT", 40, 0)
  ColourFrame.alpha.label:SetText(ColourFrame.strings.alpha)
  ColourFrame.alpha:Hide()

  ColourFrame.red.next = ColourFrame.green
  ColourFrame.red.prev = ColourFrame.blue
  ColourFrame.green.next = ColourFrame.blue
  ColourFrame.green.prev = ColourFrame.red
  ColourFrame.blue.next = ColourFrame.alpha
  ColourFrame.blue.prev = ColourFrame.green
  ColourFrame.alpha.next = ColourFrame.red
  ColourFrame.alpha.prev = ColourFrame.blue
  
  ColourFrame.copyButton = CreateFrame("Button", "lcfCopyButton", ColorPickerFrame, "GameMenuButtonTemplate")
  ColourFrame.copyButton:SetText(ColourFrame.strings.copy)
  ColourFrame.copyButton:SetWidth(50)
  ColourFrame.copyButton:SetHeight(18)
  ColourFrame.copyButton:SetPoint("BOTTOMLEFT", ColorPickerFrame, "BOTTOMLEFT", 15, 13)
  ColourFrame.copyButton:SetScript("OnClick", ColourFrame.Copy)
  ColourFrame.copyButton:Hide()

  ColourFrame.pasteButton = CreateFrame("Button", "lcfPasteButton", ColorPickerFrame, "GameMenuButtonTemplate")
  ColourFrame.pasteButton:SetText(ColourFrame.strings.paste)
  ColourFrame.pasteButton:SetWidth(50)
  ColourFrame.pasteButton:SetHeight(18)
  ColourFrame.pasteButton:SetPoint("BOTTOMLEFT", ColorPickerFrame, "BOTTOMLEFT", 75, 13)
  ColourFrame.pasteButton:SetScript("OnClick", ColourFrame.ToggleDropDown)
  ColourFrame.pasteButton.dropDown = CreateFrame("Frame", "ColourFramePasteButtonDropDown", ColourFrame.pasteButton, "UIDropDownMenuTemplate")
  ColourFrame.pasteButton.dropDown:SetWidth(1)
  ColourFrame.pasteButton.dropDown:SetHeight(1)
  ColourFrame.pasteButton.dropDown:SetPoint("TOP", ColourFrame.pasteButton, "TOP")
  ColourFrame.pasteButton:Hide()

  ColourFrame.okButton = CreateFrame("Button", "lcfOkButton", ColorPickerFrame, "GameMenuButtonTemplate")
  ColourFrame.okButton:SetText(ColourFrame.strings.ok)
  ColourFrame.okButton:SetWidth(50)
  ColourFrame.okButton:SetHeight(18)
  ColourFrame.okButton:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", -75, 13)
  ColourFrame.okButton:SetScript("OnClick", ColourFrame.OK)
  ColourFrame.okButton:Hide()

  ColourFrame.cancelButton = CreateFrame("Button", "lcfCancelButton", ColorPickerFrame, "GameMenuButtonTemplate")
  ColourFrame.cancelButton:SetText(CANCEL)
  ColourFrame.cancelButton:SetWidth(50)
  ColourFrame.cancelButton:SetHeight(18)
  ColourFrame.cancelButton:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", -15, 13)
  ColourFrame.cancelButton:SetScript("OnClick", ColourFrame.Cancel)
  ColourFrame.cancelButton:Hide()

  ColourFrame.copy = {
    { r = RED_FONT_COLOR.r, g = RED_FONT_COLOR.g, b = RED_FONT_COLOR.b, a = 1, name = ColourFrame.strings.redColour},
    { r = GREEN_FONT_COLOR.r, g = GREEN_FONT_COLOR.g, b = GREEN_FONT_COLOR.b, a = 1, name = ColourFrame.strings.greenColour},
    { r = 0.1, g = 0.1, b = 1, a = 1, name = ColourFrame.strings.blueColour},
    { r = 0, g = 0, b = 0, a = 1, name = ColourFrame.strings.blackColour},
    { r = 1, g = 1, b = 1, a = 1, name = ColourFrame.strings.whiteColour},
    { r = GRAY_FONT_COLOR.r, g = GRAY_FONT_COLOR.g, b = GRAY_FONT_COLOR.b, a = 1, name = ColourFrame.strings.grayColour},
    { r = NORMAL_FONT_COLOR.r, g = NORMAL_FONT_COLOR.g, b = NORMAL_FONT_COLOR.b, a = 1, name = ColourFrame.strings.defaultColour },
  }
  UIDropDownMenu_Initialize(ColourFramePasteButtonDropDown, ColourFrame.PasteDropDown_Initialise, "MENU")
  
  ColourFrame.created = true
end

--
-- ColourFrame edit boxes
--

ColourFrame.Edit_Create = function(self, parent, isAlpha)
  local frame = CreateFrame("EditBox", "lcfEditBox", parent)
  frame.parent = parent
  frame:SetWidth(28)
  frame:SetHeight(20)
  frame:SetFontObject(GameFontNormalSmall)
  frame:SetAutoFocus(false)
  
  frame.label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.label:SetPoint("RIGHT", frame, "LEFT", -10, 0)
  
  frame.leftBG = frame:CreateTexture(nil, "BACKGROUND")
  frame.leftBG:SetTexture("Interface\\Common\\Common-Input-Border")
  frame.leftBG:SetTexCoord(0,0.0625, 0, 0.625)
  frame.leftBG:SetWidth(8)
  frame.leftBG:SetHeight(19)
  frame.leftBG:SetPoint("LEFT", frame, "LEFT", -6, 0)

  frame.midBG = frame:CreateTexture(nil, "BACKGROUND")
  frame.midBG:SetTexture("Interface\\Common\\Common-Input-Border")
  frame.midBG:SetTexCoord(0.0625, 0.9375, 0, 0.625)
  frame.midBG:SetWidth(25)
  frame.midBG:SetHeight(19)
  frame.midBG:SetPoint("CENTER", frame, "CENTER", 0, 0)

  frame.rightBG = frame:CreateTexture(nil, "BACKGROUND")
  frame.rightBG:SetTexture("Interface\\Common\\Common-Input-Border")
  frame.rightBG:SetTexCoord(0.9375, 1.0000, 0.0000, 0.6250)
  frame.rightBG:SetWidth(8)
  frame.rightBG:SetHeight(19)
  frame.rightBG:SetPoint("RIGHT", frame, "RIGHT", 6, 0)

  frame:SetScript("OnTabPressed", self.Edit_ChangeFocus)
  frame:SetScript("OnEnterPressed", self.Edit_ChangeFocus)
  if isAlpha then
    frame:SetScript("OnTextChanged", self.Edit_AlphaChanged)
  else
    frame:SetScript("OnTextChanged", self.Edit_RGBChanged)
  end
  frame:SetScript("OnEscapePressed", self.Edit_EscapePressed)
  
  return frame
end

ColourFrame.Edit_EscapePressed = function()
  self:HighlightText(0,0)
  self:ClearFocus()
end

ColourFrame.Edit_ChangeFocus = function()
  self:HighlightText(0,0)
  if IsShiftKeyDown() and self.prev then
    self.prev:SetFocus()
    self.prev:HighlightText()
  elseif self.next then
    self.next:SetFocus()
    self.next:HighlightText()
  else
    self:ClearFocus()
  end
end

ColourFrame.Edit_RGBChanged = function(frame)
  local n = frame:GetText()
  if (n == "") then
    return
  elseif not tonumber(n) or (tonumber(n) > 255) or (tonumber(n) < 0) then
    frame:SetText(self.last)
    frame:HighlightText()
  else
    ColourFrame:UpdateFromFields()
  end
end

ColourFrame.Edit_AlphaChanged = function(frame)
  local n = frame:GetText()
  if (n == "") then
    return
  elseif not tonumber(n) or (tonumber(n) > 100) or (tonumber(n) < 0) then
    frame:SetText(self.last)
    frame:HighlightText()
  else
    ColourFrame:UpdateFromFields()
  end
end

ColourFrame.EnableAlpha = function(frame, enable)
  if enable then
    ColourFrame.alpha.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    ColourFrame.alpha:EnableMouse(true)
    ColourFrame.alpha:EnableKeyboard(true)
    OpacitySliderFrame:GetThumbTexture():Show()
    ColourFrame.blue.next = ColourFrame.alpha
    ColourFrame.red.prev = ColourFrame.alpha
    ColourFrame.red:ClearAllPoints()
    ColourFrame.red:SetPoint("BOTTOM", ColorPickerFrame, "BOTTOM", -92, 35)
  else
    ColourFrame.alpha.label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
    ColourFrame.alpha:EnableMouse(false)
    ColourFrame.alpha:EnableKeyboard(false)
    ColourFrame.alpha:Hide()
    OpacitySliderFrame:GetThumbTexture():Hide()
    ColourFrame.blue.next = ColourFrame.red
    ColourFrame.red.prev = ColourFrame.blue
    ColourFrame.red:ClearAllPoints()
    ColourFrame.red:SetPoint("BOTTOM", ColorPickerFrame, "BOTTOM", -62, 35)
  end
end

ColourFrame.DisableAlpha = function(frame)
end

--
-- Localisation
--

if (GetLocale() == "frFR") then
  ColourFrame.strings.red = "R:"
  ColourFrame.strings.green = "V:"
  ColourFrame.strings.blue = "B:"
  ColourFrame.strings.copy = "Copy"
  ColourFrame.strings.paste = "Paste"
  ColourFrame.strings.ok = "OK"
  ColourFrame.strings.redColour = "Rouge"
  ColourFrame.strings.greenColour = "Vert"
  ColourFrame.strings.blueColour = "Bleu"
  ColourFrame.strings.grayColour = "Gris"
  ColourFrame.strings.whiteColour = "Blanc"
  ColourFrame.strings.blackColour = "Noir"
  ColourFrame.strings.defaultColour = "Normaux"
end

ColourFrame.strings.red = ColourFrame.strings.red or "R:"
ColourFrame.strings.green = ColourFrame.strings.green or "G:"
ColourFrame.strings.blue = ColourFrame.strings.blue or "B:"
ColourFrame.strings.alpha = ColourFrame.strings.alpha or "A:"
ColourFrame.strings.copy = ColourFrame.strings.copy or "Copy"
ColourFrame.strings.paste = ColourFrame.strings.paste or "Paste"
ColourFrame.strings.ok = ColourFrame.strings.ok or "OK"
ColourFrame.strings.redColour = ColourFrame.strings.redColour or "Red"
ColourFrame.strings.greenColour = ColourFrame.strings.greenColour or "Green"
ColourFrame.strings.blueColour = ColourFrame.strings.blueColour or "Blue"
ColourFrame.strings.grayColour = ColourFrame.strings.grayColour or "Gray"
ColourFrame.strings.whiteColour = ColourFrame.strings.whiteColour or "White"
ColourFrame.strings.blackColour = ColourFrame.strings.blackColour or "Black"
ColourFrame.strings.defaultColour = ColourFrame.strings.defaultColour or "Normal font"