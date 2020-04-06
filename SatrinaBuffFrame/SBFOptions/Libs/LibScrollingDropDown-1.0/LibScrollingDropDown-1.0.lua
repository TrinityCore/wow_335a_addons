-- This is a beta version, and is subject to change before public release
-- Questions? satrina@evilempireguild.org

--[[
User Functions.  These functions are for you, the user!

****  ScrollingDropDown:AddItem(frame, item) 
Adds an item to a frame that a ScrollingDropDown will pop from
 * frame - Can be anything that you can click (dropdown, button, even a frame if you use OnMouseDown handlers)
 * item - the item to be added.  See below for item table structure
 
 Note that item is COPIED so don't make a new table every time you add an item.  Reuse the same table.  

 The item will be deep copied, with these exceptions: 
  - Frame objects will alwyas be reference copied
  - Any keys in items that are prefixed with _ will be only be reference copied 
    
    -- Good!
    -- UIParent is reference copied.  A reference copy of the addon's saved variables profile is made
    item.frame = UIParent
    item._var = MyAddon.db.profile
    ScrollingDropDown:AddItem(MyAddonFrameDropDown, item)
    
    -- Bad!
    -- UIParent is reference copied.  A deep copy of the addon's saved variables profile is made
    item.frame = UIParent
    item.var = MyAddon.db.profile
    ScrollingDropDown:AddItem(MyAddonFrameDropDown, item)

****  ScrollingDropDown:ClearItems(frame) - Clears a frame's items
All tables are recycled.

**** ScrollingDropDown:Open(frame)
Open the root ScrollingDropDown
 * frame - the frame 

**** ScrollingDropDown:SetSelected(frame, arg[, param])
Sets the selected item for a frame
 * frame - the frame to set the selection for
 * arg - the value to set selection by
 * param - the item parameter to set selection by (default is text)
 
Example 1: ScrollingDropDown:SetSelected(myFrame, "First", "text") 
This sets the currently selected item for myFrame based on its text fields. The item with text "First" will be selected, if it exists.

Example 2: ScrollingDropDown:SetSelected(myFrame, 1, "value") 
This sets the currently selected item for myFrame based on its value fields (which is a user defined field). The item with value 1 will be selected, if it exists.

**** Item Structure ****
  An item is a table. Reserved fields that do things are as follows:

  text (string)                   - The text to display in the ScrollingDropDown 
  callback (function)             - The function to invoke when this item is selected
  selected (nil, not-nil)         - This item is the selected item
  _textRGB {r=0-1, g=0-1, b=0-1}  - Reference to table containing colour information for text
  textRGB {r=0-1, g=0-1, b=0-1}   - Copied table of colour information (prefer using _textRGB when possible)
  colour {r=0-1, g=0-1, b=0-1}    - Swatch colour (also _colour as above)
  color {r=0-1, g=0-1, b=0-1}     - As above, so our American friends don't get tripped up (also _color as above)
  
  You may define any other fields as desired
  
]]

local vmajor, vminor = "LibScrollingDropDown-1.0", 11

local ScrollingDropDown, oldMinor = LibStub:NewLibrary(vmajor, vminor)
if not ScrollingDropDown then
	return
end

ScrollingDropDown.frames = {}

ScrollingDropDown.TEXT = "text"
ScrollingDropDown.VALUE = "value"

ScrollingDropDown.NOSORT = 0
ScrollingDropDown.SORTNAME = 1

ScrollingDropDown.ClearItems = function(self, frame)
  self:PutTable(frame.items)
  frame.items = nil
end

ScrollingDropDown.AddItem = function(self, frame, item)
  if not item.text then return false end
  if not frame.items then frame.items = self:GetTable() end
  for i,existing in ipairs(frame.items) do
    if (existing.text == item.text) then
      return false
    end
  end
  table.insert(frame.items, self:CopyTable(item))
  if item.isSelected then
    self:SetSelected(frame, item.text)
  end
  return true
end

ScrollingDropDown.Open = function(self, frame)
  assert(frame, "Must specify a frame for ScrollingDropDown:Open")
  if not frame.items or (#frame.items == 0) then
    return
  end
  
  if not self.frames[1] then
    self.frames[1] = self:CreateScrollingDropDown(1)
  end
  
  if self.isShown and (self.currentFrame == frame) then
    self.currentFrame = nil
    self.frames[1]:Hide()
    self.isShown = false
  else
    self.currentFrame = frame
    self.frames[1].hideTime = 2
    if frame.dropDownOptions and frame.dropDownOptions.hideTime then
      self.frames[1].hideTime = frame.dropDownOptions.hideTime
    end
    self.currentLevel = 1
    self.currentDD = self.frames[1]
    self.currentDD:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -1)
    self:SizeDropDown()
    self.currentDD.scrollFrame:SetVerticalScroll(0)
    if not frame.dropDownOptions or not frame.dropDownOptions.noSort then
      table.sort(frame.items, self.sort)
    end
    self:UpdateList()
    self.frames[1]:Show()
    self.isShown = true
  end
end

ScrollingDropDown.Close = function(self)
  if self.isOpen and self.frames[self.currentLevel]:IsShown() then
    self:HideAll()
  end
end

ScrollingDropDown.SetSelected = function(self, frame, arg, param)
  if not frame.items then
    return
  end
  if not param then 
    param = self.TEXT
  end
  if arg then
    for i,item in ipairs(frame.items) do
      if (item[param] == arg) then
        frame.selected = item
        if frame.text then
          frame.text:SetFormattedText("%s", item.text)
        end
      end
    end
  else
    frame.selected = nil
    if frame.text then
      frame.text:SetFormattedText("")
    end
  end
  if self.isOpen and self.frames[self.currentLevel]:IsShown() then
    self:UpdateList()
  end
end

ScrollingDropDown.IsShown = function(self)
  return self.isShown
end
--
-- Internal methods
--
ScrollingDropDown.UpdateList = function()
  local dd = ScrollingDropDown
  
  if not dd.currentFrame.items then
    return
  end
  
  local offset = FauxScrollFrame_GetOffset(dd.currentDD.scrollFrame)
  local listIndex, button, item
  local selected = false
  
  for i=1,10 do
    listIndex = offset + i
    button = dd.currentDD.listButtons[i]
    item = dd.currentFrame.items[listIndex]
    
    if item then
      button.index = listIndex
      button.item = item
      -- set text
      button.label:SetFormattedText("%s", item.text)
      local textRGB = item.textRGB or item._textRGB
      if textRGB then
        button.label:SetTextColor(textRGB.r, textRGB.g, textRGB.b)
      else
        button.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      end
      -- Set checked
      if dd.currentFrame.selected and (dd.currentFrame.selected == item) then
        button.check:Show()
      else
        button.check:Hide()
      end
      -- Set swatch
      local colour = item.color or item._color or item.colour or item._colour
      if colour then
        button.swatchTexture:SetVertexColor(colour.r, colour.g, colour.b)
        button.swatch:Show()
      else
        button.swatch:Hide()
      end
      button:Show()
    else	
      button:Hide()
    end

  end
  FauxScrollFrame_Update(dd.currentDD.scrollFrame, #dd.currentFrame.items, 10, 14)
end

ScrollingDropDown.sort = function(a,b)
  if not a or not a.text or a.forceLast then return false end
  if not b or not b.text or b.forceLast then return true end
  return a.text < b.text
end

ScrollingDropDown.HideAll = function(self)
  for i=1,self.currentLevel do
    self.frames[i]:Hide()
  end
end

ScrollingDropDown.SizeDropDown = function(self)
  local labelWidth = 0
  local buttonWidth
  local w
  local swatch = 0
  
  self.currentDD.listButtons[1].label:SetWidth(400)
  for k,v in pairs(self.currentFrame.items) do
    self.currentDD.listButtons[1].label:SetText(v.text)
    w = self.currentDD.listButtons[1].label:GetStringWidth()
    if (w > labelWidth) then
      labelWidth = w
    end
    if v.colour then
      swatch = 16
    end
  end
  
  buttonWidth = labelWidth + swatch + 25
  for i=1,10 do
    self.currentDD.listButtons[i].label:SetWidth(labelWidth)
    self.currentDD.listButtons[i]:SetWidth(buttonWidth)
    if self.currentDD.listButtons[i].highlight then
      self.currentDD.listButtons[i].highlight:SetWidth(buttonWidth - 10)
    end
  end
  
  if #self.currentFrame.items < 11 then
    self.currentDD:SetWidth(buttonWidth + 5)
    self.currentDD:SetHeight(#self.currentFrame.items * 14 + 8)
  else
    self.currentDD:SetWidth(buttonWidth + 28)
    self.currentDD:SetHeight(148)
  end
end

ScrollingDropDown.GetName = function(self)
  return "SDD"
end

ScrollingDropDown.WhoIsYourDaddy = function(self, frame, daddy)
  local p = frame:GetParent()
  if p then
    if p == daddy then
      return true
    else
      return self:WhoIsYourDaddy(p, daddy)
    end
  else
    return false
  end
end

local f, fp, fpp
ScrollingDropDown.OnUpdate = function(frame, elapsed)
  local sdd = ScrollingDropDown
  
  if not sdd.currentFrame:IsVisible() then
    frame:Hide()
  elseif sdd:WhoIsYourDaddy(GetMouseFocus(), frame) then
    frame.timeOut = 0
  else
    frame.timeOut = frame.timeOut + elapsed
    if (frame.timeOut >= frame.hideTime) then
      frame:Hide()
      frame.timeOut = 0
      if sdd.currentFrame.dropDownOptions then
        if sdd.currentFrame.dropDownOptions.clearOnHide then
          sdd:ClearItems(sdd.currentFrame)
        end
      end
    end
  end
end

ScrollingDropDown.OnHide = function(self)
  ScrollingDropDown.isShown = false
end

ScrollingDropDown.ListClick = function(obj)
  local sdd = ScrollingDropDown
  if not sdd.currentFrame.dropDownOptions or not sdd.currentFrame.dropDownOptions.noSelection then
    sdd.currentFrame.selected = obj.item
  end
  if not sdd.currentFrame.dropDownOptions or not sdd.currentFrame.dropDownOptions.stayOpen then
    obj:GetParent():Hide()
  end
  if obj.item.callback then
    obj.item.callback(obj.item)
  end
  if sdd.currentFrame.dropDownOptions and sdd.currentFrame.dropDownOptions.clearOnHide then
    sdd:ClearItems(sdd.currentFrame)
  end
end

ScrollingDropDown.OnEnterButton = function(obj)
  if obj.item.tooltipCallback then
    obj.item.tooltipCallback(obj.item)
  end
end

ScrollingDropDown.OnLeaveButton = function(self)
  GameTooltip:Hide()
end

ScrollingDropDown.OnVerticalScroll = function(self, offset)
  FauxScrollFrame_OnVerticalScroll(self, offset, 14, ScrollingDropDown.UpdateList)
end

ScrollingDropDown.tables = {}
ScrollingDropDown.GetTable = function(self, t)
  if (#self.tables == 0) then
    return {}
  end
  return table.remove(self.tables, 1)
end

ScrollingDropDown.PutTable = function(self, t)
  if not t then
    return
  end
  for k,v in pairs(t) do
    if (type(v) == "table") and not v.IsObjectType and (string.byte(k, 1) ~= 95) then
      self:PutTable(v)
    end
    t[k] = nil
  end
  table.insert(self.tables, t)
end

ScrollingDropDown.CopyTable = function(self, src)
  local dst = self:GetTable()
  for k,v in pairs(src) do
    if (type(v) == "table") and not v.IsObjectType and (string.byte(k, 1) ~= 95) then
      dst[k] = self:CopyTable(v)
    else
      dst[k] = v
    end
  end
  return dst
end

--
-- Frame Creation
--
ScrollingDropDown.frameName = "SDDFrame"
function ScrollingDropDown.CreateScrollingDropDown(self, index)
  local name = self.frameName..index
  local frame = CreateFrame("Frame", name, UIParent)
  frame:SetFrameStrata("TOOLTIP")
  frame:SetClampedToScreen(true)
  frame:SetToplevel(true)
  
  local backdrop = ScrollingDropDown:GetTable()
  backdrop.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
  backdrop.edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border"
  backdrop.tile = true
  backdrop.tileSize = 16
  backdrop.edgeSize = 16 
  backdrop.insets = ScrollingDropDown:GetTable()
  backdrop.insets.left, backdrop.insets.right, backdrop.insets.top, backdrop.insets.bottom = 2,2,2,2
  frame:SetBackdrop(backdrop)
  frame:SetBackdropColor(0,0,0,1)
  ScrollingDropDown:PutTable(backdrop)

  frame:SetWidth(231)
  frame:SetHeight(148)
  
  frame.listButtons = {}
  frame.listButtons[1] = self:CreateSDDButton(frame, 1)
  frame.listButtons[1]:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
  for i=2,10 do
    frame.listButtons[i] = self:CreateSDDButton(frame, i)
    frame.listButtons[i]:SetPoint("TOP", frame.listButtons[i-1], "BOTTOM")
  end

  frame.scrollFrame = CreateFrame("ScrollFrame", name.."ScrollList", frame, "FauxScrollFrameTemplate")
  frame.scrollFrame:SetPoint("TOPLEFT", frame.listButtons[1], "TOPLEFT")
  frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame.listButtons[10], "BOTTOMRIGHT")
  frame.scrollFrame:SetScript("OnVerticalScroll", ScrollingDropDown.OnVerticalScroll)

  frame:SetScript("OnUpdate", ScrollingDropDown.OnUpdate)
  frame:SetScript("OnHide", ScrollingDropDown.OnHide)

  frame.timeOut = 0
  frame:Hide()

  return frame
end

function ScrollingDropDown:CreateSDDButton(parent, index)
  local name = parent:GetName().."List"..index
  local frame = CreateFrame("Button", name, parent)
  frame:SetWidth(211)
  frame:SetHeight(14)
  frame:RegisterForClicks("LeftButtonUp")
  frame:SetScript("OnMouseUp", ScrollingDropDown.ListClick)
  frame:SetScript("OnEnter", ScrollingDropDown.OnEnterButton)
  frame:SetScript("OnLeave", ScrollingDropDown.OnLeaveButton)
  frame:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
  frame:GetHighlightTexture():SetBlendMode("ADD")
  
  frame.check = frame:CreateTexture()
  frame.check:SetHeight(16)
  frame.check:SetWidth(16)
  frame.check:SetPoint("LEFT", frame, "LEFT", 0, 0)
  frame.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
  
  frame.label = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
  frame.label:SetHeight(16)
  frame.label:SetWidth(175)
  frame.label:SetJustifyH("LEFT")
  frame.label:SetPoint("LEFT", frame, "LEFT", 18, 0)

  frame.swatch = CreateFrame("Button", name.."Swatch", frame)
  frame.swatch:SetHeight(16)
  frame.swatch:SetWidth(16)
  frame.swatch:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
  frame.swatch:SetNormalTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
  frame.swatchTexture = frame.swatch:GetNormalTexture()

  return frame
end
