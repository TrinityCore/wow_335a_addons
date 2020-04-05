local revision = tonumber(string.sub("$Revision: 151 $", 12, -3)) or 1
if revision > ElkBuffBars.revision then ElkBuffBars.revision = revision end

local _G = getfenv(0)
local abacus = LibStub("LibAbacus-3.0")
local LSM3 = LibStub("LibSharedMedia-3.0")

local ipairs				= _G.ipairs
local tonumber				= _G.tonumber
local unpack				= _G.unpack

local math_max				= _G.math.max
local math_min				= _G.math.min

local string_format			= _G.string.format
local string_match			= _G.string.match
local string_utf8len		= _G.string.utf8len

EBB_Bar = AceLibrary("AceOO-2.0").Class()
local EBB_Bar = EBB_Bar
local ElkBuffBars

function EBB_Bar:ToString()
	return "EBB_Bar"
end

function EBB_Bar.prototype:init(arg)
	EBB_Bar.super.prototype.init(self)
	if not ElkBuffBars then ElkBuffBars = _G.ElkBuffBars end
	self.frames = {}
end

function EBB_Bar.prototype:Reset()
	local frames = self.frames
	frames.container:SetScript("OnUpdate", nil)
	frames.container:Hide()
	frames.container:ClearAllPoints()
	self.layout = nil
	self.data = nil
	self.timeleft = 0
	self:SetParent()
end

function EBB_Bar.prototype:GetContainer()
	return self.frames.container
end

function EBB_Bar.prototype:SetParent(parent)
	if self.frames.container then
		self.frames.container:SetParent(parent and parent.frames.container or UIParent)
	end
	self.parent = parent
end

local playerunits = {
	pet = true,
	player = true,
	vehicle = true,
}

function EBB_Bar.prototype:OnClick(button)
	if button == "LeftButton" then
		if IsAltKeyDown() then
			self.parent:ToggleAnchor()
		elseif IsShiftKeyDown() then

			local activeWindow = ChatEdit_GetActiveWindow()
			if activeWindow then
				if self.data.untilcancelled then
					activeWindow:Insert(self:GetDataString("NAMERANK"))
				else
					activeWindow:Insert(self:GetDataString("NAMERANK").." - "..self:GetTimeString(self.timeleft, self.layout.timeformat))
				end
			end
		end
	elseif button == "RightButton" then
		if not playerunits[self.parent.layout.target] then return end
		if self.data.realtype == "BUFF" then
			CancelUnitBuff(self.parent.layout.target, self.data.id)
		elseif self.data.realtype == "TENCH" then
			CancelItemTempEnchantment(self.data.id - 15)
		elseif self.data.realtype == "TRACKING" then
			if ( GameTooltip:GetOwner() == self.frames.container ) then
				GameTooltip:Hide()
			end
			ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self.frames.container, 0, -5)
		end
	end
end

function EBB_Bar.prototype:OnEnter()
	local realtype = self.data.realtype
	if self.layout.tooltipanchor == "default" then
		GameTooltip_SetDefaultAnchor(GameTooltip, self.frames.container)
	else
		GameTooltip:SetOwner(self.frames.container, self.layout.tooltipanchor)
	end
	if self.parent.layout.target == "player" then
		if realtype == "BUFF" then
			GameTooltip:SetUnitAura("player", self.data.id, "HELPFUL")
		elseif realtype == "DEBUFF" then
			GameTooltip:SetUnitAura("player", self.data.id, "HARMFUL")
		elseif realtype == "TENCH" then
			GameTooltip:SetInventoryItem("player", self.data.id)
		elseif realtype == "TRACKING" then
			GameTooltip:SetTracking()
		end
	else
		if realtype == "BUFF" then
			GameTooltip:SetUnitAura(self.parent.layout.target, self.data.id, "HELPFUL")
		elseif realtype == "DEBUFF" then
			GameTooltip:SetUnitAura(self.parent.layout.target, self.data.id, "HARMFUL")
		end
	end
end

function EBB_Bar.prototype:OnLeave()
	GameTooltip:Hide()
end

function EBB_Bar.prototype:OnUpdate(elapsed)
	local frames = self.frames

	self.timeleft = math_max(0, self.timeleft - elapsed)
	if self.timeleft == 0 then
		frames.container:SetScript("OnUpdate", nil)
	end

	if not (frames.bar and frames.bar:IsShown()) then return end

	local data = self.data
	local frames = self.frames
	local layout = self.layout
	local fraction = math_max(0, math_min(self.timeleft / data.timemax, 1))

--~ 	if fraction > 1.001 then
--~ 		ElkBuffBars:Print(string.format("|cffff0000[EBB] ERROR:|r (EBB_Bar:OnUpdate) %d - %s - %f / %f", data.id, data.name, self.timeleft, data.timemax))
--~ 		fraction = 0
--~ 	end

	local barwidth = self.barwidth_total * fraction
	if barwidth + .2 < self.barwidth then -- this could be a visual change
		if barwidth < 1 then
			frames.bar:Hide()
			if frames.spark then frames.spark:Hide() end
		else
			frames.bar:SetWidth(barwidth)
			if layout.barright then
				frames.bar:SetTexCoord(1 - fraction, 1, 0, 1)
			else
				frames.bar:SetTexCoord(0, fraction, 0, 1)
			end
		end
		self.barwidth = barwidth
	end
end

function EBB_Bar.prototype:UpdateLayout(layout)
	if layout then
		self.layout = layout
	else
		layout = self.layout
		if not layout then
			return
		end
	end
	
	local frames = self.frames
	
-- container
	if not frames.container then
		frames.container = CreateFrame("button", nil, UIParent)
		frames.container:SetFrameStrata("BACKGROUND")
		frames.container.bar = self
		frames.container:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		frames.container:SetScript("OnClick", function(this, button) this.bar:OnClick(button) end )
		frames.container:SetScript("OnEnter", function(this) this.bar:OnEnter() end )
		frames.container:SetScript("OnLeave", function(this) this.bar:OnLeave() end )
	end
	if layout.clickthrough then
		frames.container:EnableMouse(false)
	else
		frames.container:EnableMouse(true)
	end
	frames.container:SetHeight(layout.height)
	frames.container:SetWidth(layout.width)
--~ 	frames.container:SetAlpha(layout.alpha)
	local leftoffset = 0
	local rightoffset = 0

-- icon
	if layout.icon then
		if not frames.icon then
			frames.icon = frames.container:CreateTexture(nil, "BACKGROUND")
		end
		frames.icon:ClearAllPoints()
		frames.icon:SetHeight(layout.height)
		frames.icon:SetWidth(layout.height)
		if layout.icon == "LEFT" then
			leftoffset = layout.height
			frames.icon:SetPoint("LEFT", frames.container)
			
		end
		if layout.icon == "RIGHT" then
			rightoffset = -layout.height
			frames.icon:SetPoint("RIGHT", frames.container)
			
		end
		frames.icon:Show()
	else
		if frames.icon then frames.icon:Hide() end
	end

-- iconcount
	if layout.icon and layout.iconcount then
		if not frames.iconcount then
			frames.iconcount = frames.container:CreateFontString(nil, "OVERLAY")
		end
		frames.iconcount:ClearAllPoints()
		frames.iconcount:SetPoint(layout.iconcountanchor, frames.icon, layout.iconcountanchor, (string_match(layout.iconcountanchor, "LEFT") and 3) or (string_match(layout.iconcountanchor, "RIGHT") and -3) or 0, (string_match(layout.iconcountanchor, "TOP") and -3) or (string_match(layout.iconcountanchor, "BOTTOM") and 3) or 0)
		frames.iconcount:SetFont(LSM3:Fetch("font", layout.iconcountfont), layout.iconcountfontsize, "OUTLINE")
		frames.iconcount:SetTextColor(layout.iconcountcolor[1], layout.iconcountcolor[2], layout.iconcountcolor[3], 1)
		frames.iconcount:Show()
	else
		if frames.iconcount then frames.iconcount:Hide() end
	end

-- iconborder
	if layout.icon then
		if not frames.iconborder then
			frames.iconborder = frames.container:CreateTexture(nil, "OVERLAY")
		end
		frames.iconborder:ClearAllPoints()
		frames.iconborder:SetPoint("TOPLEFT", frames.icon)
		frames.iconborder:SetPoint("BOTTOMRIGHT", frames.icon)
		frames.iconborder:Show()
	else
		if frames.iconborder then frames.iconborder:Hide() end
	end

-- bar
	if layout.bgbar then
		if not frames.bgbar then
			frames.bgbar = frames.container:CreateTexture(nil, "BACKGROUND")
		end
		frames.bgbar:ClearAllPoints()
		frames.bgbar:SetPoint("TOPLEFT", frames.container, "TOPLEFT", leftoffset, 0)
		frames.bgbar:SetPoint("BOTTOMRIGHT", frames.container, "BOTTOMRIGHT", rightoffset, 0)
		frames.bgbar:SetTexture(LSM3:Fetch("statusbar", layout.bartexture))
		frames.bgbar:Show()
	else
		if frames.bgbar then frames.bgbar:Hide() end
	end

	if layout.bar then
		if not frames.bar then
			frames.bar = frames.container:CreateTexture(nil, "ARTWORK")
		end
		frames.bar:ClearAllPoints()
		if layout.barright then
			frames.bar:SetPoint("TOPRIGHT",		frames.container,	"TOPRIGHT",		rightoffset,	0)
			frames.bar:SetPoint("BOTTOMRIGHT",	frames.container,	"BOTTOMRIGHT",	rightoffset,	0)
		else
			frames.bar:SetPoint("TOPLEFT",		frames.container,	"TOPLEFT",		leftoffset,		0)
			frames.bar:SetPoint("BOTTOMLEFT",	frames.container,	"BOTTOMLEFT",	leftoffset,		0)
		end
		frames.bar:SetWidth(0)
		frames.bar:SetTexture(LSM3:Fetch("statusbar", layout.bartexture))
		frames.bar:Show()
	else
		if frames.bar then frames.bar:Hide() end
	end

	if layout.bar and layout.spark then
		if not frames.spark then
			frames.spark = frames.container:CreateTexture(nil, "OVERLAY")
			frames.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
			frames.spark:SetWidth(16)
			frames.spark:SetBlendMode("ADD")
		end
		frames.spark:ClearAllPoints()
		if layout.barright then
			frames.spark:SetPoint("TOP", frames.bar, "TOPLEFT", 0, 7)
			frames.spark:SetPoint("BOTTOM", frames.bar, "BOTTOMLEFT", 0, -7)
			frames.spark:SetTexCoord(1, 0, 0, 1)
		else
			frames.spark:SetPoint("TOP", frames.bar, "TOPRIGHT", 0, 7)
			frames.spark:SetPoint("BOTTOM", frames.bar, "BOTTOMRIGHT", 0, -7)
			frames.spark:SetTexCoord(0, 1, 0, 1)
		end
		frames.spark:Show()
	else
		if frames.spark then frames.spark:Hide() end
	end
	
	local padding = layout.padding
-- textTL
	if layout.textTL then
		if not frames.textTL then
			frames.textTL = frames.container:CreateFontString(nil, "OVERLAY")
		end
		frames.textTL:ClearAllPoints()
		frames.textTL:SetPoint("TOPLEFT", frames.container, "TOPLEFT", leftoffset + padding, -padding)
		frames.textTL:SetFontObject(GameFontNormal)
		frames.textTL:SetFont(LSM3:Fetch("font", layout.textTLfont), layout.textTLfontsize)
		frames.textTL:SetTextColor(layout.textTLcolor[1], layout.textTLcolor[2], layout.textTLcolor[3], 1)
		if not layout.textTR then
			frames.textTL:SetPoint("TOPRIGHT", frames.container, "TOPRIGHT", rightoffset - padding, -padding)
			frames.textTL:SetJustifyH(layout.textTLalign)
		else
			frames.textTL:SetJustifyH("LEFT")
		end
		if not layout.textBL then
			frames.textTL:SetPoint("BOTTOMLEFT", frames.container, "BOTTOMLEFT", leftoffset + padding, padding)
			frames.textTL:SetJustifyV("CENTER")
		else
			frames.textTL:SetJustifyV("TOP")
		end
		frames.textTL:Show()
	else
		if frames.textTL then frames.textTL:Hide() end
	end

-- textTR
	if layout.textTR then
		if not frames.textTR then
			frames.textTR = frames.container:CreateFontString(nil, "OVERLAY")
		end
		frames.textTR:ClearAllPoints()
		frames.textTR:SetPoint("TOPRIGHT", frames.container, "TOPRIGHT", rightoffset - padding, -padding)
		frames.textTR:SetFontObject(GameFontNormal)
		frames.textTR:SetFont(LSM3:Fetch("font", layout.textTRfont), layout.textTRfontsize)
		frames.textTR:SetTextColor(layout.textTRcolor[1], layout.textTRcolor[2], layout.textTRcolor[3], 1)
		frames.textTR:SetJustifyH("RIGHT")
		if not layout.textBL then
			frames.textTR:SetPoint("BOTTOMRIGHT", frames.container, "BOTTOMRIGHT", rightoffset - padding, padding)
			frames.textTR:SetJustifyV("CENTER")
		else
			frames.textTR:SetJustifyV("TOP")
		end
		if layout.textTL then
			frames.textTR:SetPoint("TOPLEFT", frames.textTL, "TOPLEFT", 10, 0)
		end
		frames.textTR:Show()
	else
		if frames.textTR then frames.textTR:Hide() end
	end

-- textBL
	if layout.textTL and layout.textBL then
		if not frames.textBL then
			frames.textBL = frames.container:CreateFontString(nil, "OVERLAY")
		end
		frames.textBL:ClearAllPoints()
		frames.textBL:SetPoint("BOTTOMLEFT", frames.container, "BOTTOMLEFT", leftoffset + padding, padding)
		frames.textBL:SetFontObject(GameFontNormal)
		frames.textBL:SetFont(LSM3:Fetch("font", layout.textBLfont), layout.textBLfontsize)
		frames.textBL:SetTextColor(layout.textBLcolor[1], layout.textBLcolor[2], layout.textBLcolor[3], 1)
		if not layout.textBR then
			frames.textBL:SetPoint("BOTTOMRIGHT", frames.container, "BOTTOMRIGHT", rightoffset - padding, padding)
			frames.textBL:SetJustifyH(layout.textBLalign)
		else
			frames.textBL:SetJustifyH("LEFT")
		end
		frames.textBL:Show()
	else
		if frames.textBL then frames.textBL:Hide() end
	end

-- textBR
	if layout.textTL and layout.textBR then
		if not frames.textBR then
			frames.textBR = frames.container:CreateFontString(nil, "OVERLAY")
		end
		frames.textBR:ClearAllPoints()
		frames.textBR:SetPoint("BOTTOMRIGHT", frames.container, "BOTTOMRIGHT", rightoffset - padding, padding)
		frames.textBR:SetFontObject(GameFontNormal)
		frames.textBR:SetFont(LSM3:Fetch("font", layout.textBRfont), layout.textBRfontsize)
		frames.textBR:SetTextColor(layout.textBRcolor[1], layout.textBRcolor[2], layout.textBRcolor[3], 1)
		frames.textBR:SetJustifyH("RIGHT")
		if layout.textBL then
			frames.textBR:SetPoint("BOTTOMLEFT", frames.textBL, "BOTTOMLEFT", 10, 0)
		end
		frames.textBR:Show()
	else
		if frames.textBR then frames.textBR:Hide() end
	end

-- precomputations
	self.barwidth_total = layout.width - leftoffset + rightoffset		-- rightoffset is <= 0
	self.barwidth_padded = self.barwidth_total - 2 * layout.padding
	self.trdwidth = self.barwidth_padded / 3

end

local updateFunc = function(self, elapsed) self.bar:OnUpdate(elapsed) end

function EBB_Bar.prototype:UpdateData(data)
	if data then
		self.data = data
	else
		data = self.data
		if not data then
			return
		end
	end

	self.timeleft = data.expirytime and math_max(0, data.expirytime - GetTime()) or 0

	local frames = self.frames
	local layout = self.layout

	if layout.icon then
		frames.icon:SetTexture(data.icon)
		if data.type == "DEBUFF" then
			frames.iconborder:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
			frames.iconborder:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
			local debuffcolor = DebuffTypeColor[data.debufftype or "none"] or DebuffTypeColor["none"]
			frames.iconborder:SetVertexColor(debuffcolor.r, debuffcolor.g, debuffcolor.b)
			frames.iconborder:Show()
		elseif data.type == "TENCH" then
			frames.iconborder:SetTexture("Interface\\Buttons\\UI-TempEnchant-Border")
			frames.iconborder:SetTexCoord(0, 1, 0, 1)
			frames.iconborder:Show()
		else
			frames.iconborder:Hide()
		end
		if layout.iconcount then
			if data.maxcharges then
				frames.iconcount:SetText(data.charges)
				frames.iconcount:Show()
			else
				frames.iconcount:Hide()
			end
		end
	end
	if layout.bar then
		if data.untilcancelled then
			if layout.timelessfull then
				frames.bar:SetWidth(self.barwidth_total)
				frames.bar:SetTexCoord(0, 1, 0, 1)
				frames.bar:Show()
			else
				frames.bar:SetWidth(0)
				frames.bar:Hide()
			end
			if frames.spark then frames.spark:Hide() end
		else

			local fraction = math_max(0, math_min(self.timeleft / data.timemax, 1))

--~ 			if fraction > 1.001 then
--~ 				ElkBuffBars:Print(string.format("|cffff0000[EBB] ERROR:|r (EBB_Bar:UpdateData) %d - %s - %f / %f", data.id, data.name, self.timeleft, data.timemax))
--~ 				fraction = 0
--~ 			end

			local barwidth = self.barwidth_total * fraction
			self.barwidth = barwidth

			if barwidth < 1 then
				frames.bar:Hide()
			else
				frames.bar:SetWidth(barwidth)
				if layout.barright then
					frames.bar:SetTexCoord(1 - fraction, 1, 0, 1)
				else
					frames.bar:SetTexCoord(0, fraction, 0, 1)
				end
				frames.bar:Show()
			end
			if layout.spark then frames.spark:Show() end
		end
		local barcolorR, barcolorG, barcolorB, barcolorA = unpack(layout["barcolor"])
		if data.type == "DEBUFF" and layout.debufftypecolor then
			local debuffcolor = DebuffTypeColor[data.debufftype or "none"] or DebuffTypeColor["none"]
			barcolorR, barcolorG, barcolorB = debuffcolor.r, debuffcolor.g, debuffcolor.b
		end
		frames.bar:SetVertexColor(barcolorR, barcolorG, barcolorB, barcolorA)
	end
	if layout.bgbar then 
		frames.bgbar:SetVertexColor(unpack(layout["barbgcolor"]))
	end

	if data.id >= 0 and not data.untilcancelled then -- no scripts for Blessing of Demonstration
		frames.container:SetScript("OnUpdate", updateFunc)
	else
		frames.container:SetScript("OnUpdate", nil)
	end
	self:UpdateText()
end

local romandigits = {	{["r"] = "M",  ["a"] = 1000},
						{["r"] = "CM", ["a"] =  900},
						{["r"] = "D",  ["a"] =  500},
						{["r"] = "CD", ["a"] =  400},
						{["r"] = "C",  ["a"] =  100},
						{["r"] = "XC", ["a"] =   90},
						{["r"] = "L",  ["a"] =   50},
						{["r"] = "XL", ["a"] =   40},
						{["r"] = "X",  ["a"] =   10},
						{["r"] = "IX", ["a"] =    9},
						{["r"] = "V",  ["a"] =    5},
						{["r"] = "IV", ["a"] =    4},
						{["r"] = "I",  ["a"] =    1}
					}

local arabic_to_roman = setmetatable({}, {__index=function(self,arabic)
	arabic = tonumber(arabic)
	if not arabic then
		return nil
	end
	local roman = ""
	for i,v in ipairs(romandigits) do
		while arabic >= v.a do
			arabic = arabic - v.a
			roman = roman .. v.r
		end
	end
	self[arabic] = roman
	return roman
end})

function EBB_Bar.prototype:GetDataString(datatype)
	if datatype == "NAME" then return self:GetNameString() end
	if datatype == "NAMERANK" then return self:GetNameString()..(self.data.rank and (" "..arabic_to_roman[self.data.rank]) or "") end
	if datatype == "NAMECOUNT" then return self:GetNameString()..((self.data.maxcharges) and " x"..self.data.charges or "") end
	if datatype == "NAMERANKCOUNT" then return self:GetNameString()..(self.data.rank and (" "..arabic_to_roman[self.data.rank]) or "")..((self.data.maxcharges) and " x"..self.data.charges or "") end
	if datatype == "RANK" then return self.data.rank and arabic_to_roman[self.data.rank] or "" end
	if datatype == "COUNT" then return ((self.data.maxcharges) and "x"..self.data.charges or "") end
	if datatype == "TIMELEFT" then return self:GetTimeString(self.timeleft, self.layout.timeformat) end
	if datatype == "DEBUFFTYPE" then return self.data.debufftype end
	return "???"
end

function EBB_Bar.prototype:GetNameString()
	local layout = self.layout
	local name = self.data.name
	if layout.abbreviate_name > 0 and string_utf8len(name) > layout.abbreviate_name then
		return ElkBuffBars.ShortName[name]
	else
		return name
	end
end

function EBB_Bar.prototype:GetTimeString(time, format)
	if self.data.untilcancelled then return "" end
	if format == "DEFAULT" then return string_format(SecondsToTimeAbbrev(time)) end
	if format == "EXTENDED" then return abacus:FormatDurationExtended(time) end
	if format == "FULL" then return abacus:FormatDurationFull(time) end
	if format == "SHORT" then return abacus:FormatDurationShort(time) end
	if format == "CONDENSED" then return abacus:FormatDurationCondensed(time) end
	return "???"
end

function EBB_Bar.prototype:UpdateText()
	local frames = self.frames
	local layout = self.layout
	if layout.textTL then
		frames.textTL:SetText(self:GetDataString(layout.textTL))
	end
	if layout.textTR then
		frames.textTR:SetText(self:GetDataString(layout.textTR))
	end
	if layout.textTL and layout.textBL then
		frames.textBL:SetText(self:GetDataString(layout.textBL))
	end
	if layout.textTL and layout.textBR then
		frames.textBR:SetText(self:GetDataString(layout.textBR))
	end
	self:UpdateTextWidth()
end

function EBB_Bar.prototype:UpdateTimeleft()
	if self.data.untilcancelled then return end
	local frames = self.frames
	local layout = self.layout
	
	if layout.textTL == "TIMELEFT" then
		frames.textTL:SetText(self:GetTimeString(self.timeleft, layout.timeformat))
	end
	if layout.textTR == "TIMELEFT" then
		frames.textTR:SetText(self:GetTimeString(self.timeleft, layout.timeformat))
	end
	if layout.textTL and layout.textBL == "TIMELEFT" then
		frames.textBL:SetText(self:GetTimeString(self.timeleft, layout.timeformat))
	end
	if layout.textTL and layout.textBR == "TIMELEFT" then
		frames.textBR:SetText(self:GetTimeString(self.timeleft, layout.timeformat))
	end
	self:UpdateTextWidth()
end

function EBB_Bar.prototype:UpdateTextWidth()
	local frames = self.frames
	local layout = self.layout
	local trdwidth = self.trdwidth
	if layout.textTL and layout.textTR then
		local TLwidth = frames.textTL:GetStringWidth() + 5
		local TRwidth = frames.textTR:GetStringWidth() + 5
		if TLwidth < trdwidth then
			frames.textTL:SetWidth(TLwidth)
		elseif TRwidth < trdwidth then
			frames.textTL:SetWidth(self.barwidth_padded - TRwidth)
		else
			frames.textTL:SetWidth(trdwidth + (TLwidth * trdwidth)/(TLwidth + TRwidth))
		end
	end
	if layout.textTL and layout.textBL and layout.textBR then
		local BLwidth = frames.textBL:GetStringWidth() + 5
		local BRwidth = frames.textBR:GetStringWidth() + 5
		if BLwidth < trdwidth then
			frames.textBL:SetWidth(BLwidth)
		elseif BRwidth < trdwidth then
			frames.textBL:SetWidth(self.barwidth_padded - BRwidth)
		else
			frames.textBL:SetWidth(trdwidth + (BLwidth * trdwidth)/(BLwidth + BRwidth))
		end
	end
end
