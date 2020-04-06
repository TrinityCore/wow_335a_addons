-- ButtonFacade support

if IsAddOnLoaded("ButtonFacade") then
  local bf = LibStub("AceAddon-3.0"):GetAddon("ButtonFacade")
  local lbf = LibStub("LibButtonFacade")
  local SBFBF = {}
  local bfGroup = nil

  -- arg,SkinID,Gloss,Backdrop,Group,Button,Colors
  SBFBF.SkinCallback = function(self, skin, gloss, backdrop, frameName, _, colours)
    if not frameName or not SBFBF.db[frameName] then 
      return 
    end
    SBFBF.db[frameName].skin = skin
    SBFBF.db[frameName].gloss = gloss
    SBFBF.db[frameName].backdrop = backdrop
    SBFBF.db[frameName].colours = colours
    SBF:ForceAll()
  end

  SBFBF.SetupGroups = function(self)
    for k,v in pairs(SBF.frames) do
      self:SetupGroup(v._var.general.frameName)
    end
  end
  
  SBFBF.SetupGroup = function(self, frameName, vars)
    local btndata
    local frameGroup = lbf:Group("SBF", frameName)
    local f = SBF:FindFrame(frameName)
    if f.slots then
      for index,slot in ipairs(f.slots) do
        if slot and slot.icon then
          if not slot.icon.bfBtndata then
            slot.icon.bfBtndata = {}
          end
          frameGroup:AddButton(slot.icon, slot.icon.bfBtndata)
        end
      end
    end
    if not SBFBF.db[frameName] then
      if not vars then
        SBFBF.db[frameName] = { skin = "Blizzard", gloss = 0, backdrop = false, colours = {}, }
      else
        SBFBF.db[frameName] = { skin = vars.skin, gloss = vars.gloss, backdrop = vars.backdrop, colours = vars.colours, }
      end
    end
    frameGroup:Skin(SBFBF.db[frameName].skin, SBFBF.db[frameName].gloss, SBFBF.db[frameName].backdrop, SBFBF.db[frameName].colours)
  end

  SBFBF.UndoGroup = function(self, frameName, delete)
    local frameGroup = lbf:Group("SBF", frameName)
    if frameGroup then
      local f = SBF:FindFrame(frameName)
      if f.slots then
        for index,slot in ipairs(f.slots) do
          if slot and slot.icon then
            frameGroup:RemoveButton(slot.icon)
          end
        end
      end
      if delete then
        SBFBF.db[frameName] = nil
        bfGroup:RemoveSubGroup(frameGroup)
      end
    end
  end
  
  SBFBF.HasGroups = function(self)
    local g = lbf:Group("SBF")
    if g and g.SubList then
        return (#g.SubList > 0)
    end
    return false
  end
  
  SBFBFLoad = function()
    if not SBF.db.global.disableBF then
      if not SBF.db.profile.buttonFacade then
        SBF.db.profile.buttonFacade = {}
      end
      bfGroup = lbf:Group("SBF")
      
      SBFBF.db = SBF.db.profile.buttonFacade
      lbf:RegisterSkinCallback("SBF", SBFBF.SkinCallback, SBFBF)
      SBFBF.skins = lbf:GetSkins()
      return SBFBF
    end
    return nil
  end
else
  SBFBFLoad = function() return nil end
end

