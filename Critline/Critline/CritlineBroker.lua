local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local L = LibStub("AceLocale-3.0"):GetLocale("Critline")

local _, addon = ...

local display = addon.display
local settings = addon.settings


local feedData = {
	{
		name = "dmg",
		fullname = "damage",
		letter = "D",
	},
	{
		name = "heal",
		fullname = "healing",
		letter = "H",
	},
	{
		name = "pet",
		fullname = "pet",
		letter = "P",
	}
}

local feeds = {}

for i, feed in ipairs(feedData) do
	feeds[feed.name] = ldb:NewDataObject("Critline "..feed.fullname, {
		type = "data source",
		icon = display[feed.name.."Icon"],
		OnClick = function()
			if IsShiftKeyDown() then
				local normalRecord, critRecord, normalSpell, critSpell = addon:GetHighest(feed.name)
				local normal = L["Normal"]..": "..(normalSpell and format("%d (%s)", normalRecord, normalSpell) or "n/a")
				local crit = L["Crit"]..": "..(critSpell and format("%d (%s)", critRecord, critSpell) or "n/a")
				ChatFrame_OpenChat(normal.." - "..crit)
			else
				settings:OpenSettingsFrame()
			end
		end,
		OnTooltipShow = function()
			display:AddTooltipText(addon:GetSummaryRichText(feed.name))
		end
	})
end

addon:OnUpdateRegister(function()
	for i, feed in ipairs(feedData) do
		local normalRecord, critRecord = addon:GetHighest(feed.name)
		feeds[feed.name].text = format("%s%s: |r%s/%s", NORMAL_FONT_COLOR_CODE, feed.letter, normalRecord, critRecord)
	end
end)