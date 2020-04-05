local oRA = LibStub("AceAddon-3.0"):GetAddon("oRA3")
local module = oRA:NewModule("Resurrection", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("oRA3")
local res = LibStub("LibResComm-1.0")

module.VERSION = tonumber(("$Revision: 163 $"):sub(12, -3))

local textFormat = L["%s is ressing %s."]
local text = nil

local f = CreateFrame("Frame")
local function onUpdate(self, elapsed)
	local n = UnitName(self.unit)
	local is, resser = res:IsUnitBeingRessed(n)
	if n and is then
		local x, y = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		text:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
		text:SetFormattedText(textFormat, resser, n)
		text:Show()
	else
		self:SetScript("OnUpdate", nil)
		text:Hide()
	end
end

local function checkUnit(unit)
	if not UnitIsPlayer(unit) or not UnitIsFriend(unit, "player") then return end
	if not UnitIsDeadOrGhost(unit) or not UnitIsCorpse(unit) then return end
	f:SetScript("OnUpdate", onUpdate)
	f.unit = unit
	return true
end

function module:OnRegister()
	text = UIParent:CreateFontString("oRA3ResurrectionAlert", "OVERLAY", GameFontHighlightLarge)
	text:SetFontObject(GameFontHighlightLarge)
	text:SetTextColor(0.7, 0.7, 0.2, 0.8)

	GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip, ...)
		local unit = select(2, tooltip:GetUnit())
		if not unit then return end
		local ret = checkUnit(unit)
		if ret then
			local n = UnitName(unit)
			local is, resser = res:IsUnitBeingRessed(n)
			tooltip:AddLine(textFormat:format(resser, n), 0.7, 0.7, 0.2, 1)
		end
	end)
	oRA.RegisterCallback(self, "OnStartup")
	oRA.RegisterCallback(self, "OnShutdown")
end

function module:OnStartup()
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function module:OnShutdown()
	self:UnregisterAllEvents()
end

function module:UPDATE_MOUSEOVER_UNIT()
	checkUnit("mouseover")
end

