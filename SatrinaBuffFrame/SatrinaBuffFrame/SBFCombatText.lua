local _G = _G
local sbf = _G.SBF

sbf.CombatTextExpiry = function(self, buff, var)
	if not buff.frame and not buff.name then
		self:msg(SBF.strings.INVALIDBUFF)
		return
	end

  local name = name

  if SCT then
    local frame = SCT:Get("SHOWFADE", SCT.FRAMES_TABLE) or 1
    local txt = string.format("-[%s]", name)
    if (frame == SCT.MSG) then
      SCT:DisplayMessage(txt, var.expiry.sctColour)
    else
      SCT:DisplayText(txt, var.expiry.sctColour, var.expiry.sctCrit, "event", frame)
    end
  elseif MikSBT then
    MikSBT.DisplayMessage(string.format("-[%s]", name), MikSBT.DISPLAYTYPE_NOTIFICATION, false, 
      var.expiry.sctColour.r*255, var.expiry.sctColour.g*255, var.expiry.sctColour.b*255)
  elseif (_G.SHOW_COMBAT_TEXT == "1") then
    CombatText_AddMessage(string.format(AURA_END, name), COMBAT_TEXT_SCROLL_FUNCTION, 0.1, 1.0, 0.1, nil, nil)
  elseif Parrot then
    Parrot:GetModule("Display"):CombatText_AddMessage("-("..name..")", nil, var.expiry.sctColour.r, var.expiry.sctColour.g, var.expiry.sctColour.b, 
      nil, nil, nil, var.icon)
  end
end

SBF.CombatTextWarning = function(self, buff, var)
	if not buff.frame and not buff.name then
		self:msg(SBF.strings.INVALIDBUFF)
		return
	end

  local name = tostring(buff.name)

	if var then
    if SCT then
      local frame = SCT:Get("SHOWFADE", SCT.FRAMES_TABLE) or 1
      local txt = string.format("[%s] %s", name, self.strings.BUFFEXPIRE)
      if (frame == SCT.MSG) then
        SCT:DisplayMessage(txt, var.expiry.sctColour)
      else
        SCT:DisplayText(txt, var.expiry.sctColour, var.expiry.sctCrit, "event", frame, nil, nil, buff.icon)
      end
    elseif MikSBT then
      MikSBT.DisplayMessage(string.format("%s %s", name, self.strings.BUFFEXPIRE), MikSBT.DISPLAYTYPE_NOTIFICATION, 
      var.expiry.sctCrit, var.expiry.sctColour.r*255, var.expiry.sctColour.g*255, var.expiry.sctColour.b*255)
    elseif (_G.SHOW_COMBAT_TEXT == "1") then
      CombatText_AddMessage(string.format("<%s> %s", name, self.strings.BUFFEXPIRE), CombatText_StandardScroll, 
        var.expiry.sctColour.r, var.expiry.sctColour.g, var.expiry.sctColour.b, (var.expiry.sctCrit and "crit"), nil)
    elseif Parrot then
      Parrot:GetModule("Display"):ShowMessage(string.format("%s %s", name, self.strings.BUFFEXPIRE), nil, var.expiry.sctCrit, 
        var.expiry.sctColour.r, var.expiry.sctColour.g, var.expiry.sctColour.b, nil, nil, nil, buff.icon)
    end
  end
end
