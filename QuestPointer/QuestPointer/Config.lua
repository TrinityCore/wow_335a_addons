local myname, ns = ...
local myfullname = GetAddOnMetadata(myname, "Title")

----------------------
--      Locals      --
----------------------

local tekcheck = LibStub("tekKonfig-Checkbox")
local tekslider = LibStub("tekKonfig-Slider")
local GAP = 8

---------------------
--      Panel      --
---------------------

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = myfullname
frame:Hide()
frame:SetScript("OnShow", function(frame)
	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, myfullname, ("General settings for %s."):format(myfullname))
	
	local tracked = tekcheck.new(frame, nil, "Tracked quests only", "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
	tracked.tiptext = "Only show icons on the minimap for quests you are tracking"
	local checksound = tracked:GetScript("OnClick")
	tracked:SetScript("OnClick", function(self)
		checksound(self)
		ns.db.watchedOnly = not ns.db.watchedOnly
		ns:UpdatePOIs()
	end)
	tracked:SetChecked(ns.db.watchedOnly)

	local useArrows = tekcheck.new(frame, nil, "Arrows on the edge", "TOPLEFT", tracked, "BOTTOMLEFT", -2, -GAP)
	useArrows.tiptext = "Change the POI icons to arrows when they're off the edge of the minimap"
	useArrows:SetScript("OnClick", function(self)
		checksound(self)
		ns.db.useArrows = not ns.db.useArrows
		ns:UpdatePOIs()
	end)
	useArrows:SetChecked(ns.db.useArrows)

	local scaleslider, scaleslidertext, scalecontainer = tekslider.new(frame, string.format("Icon scale: %.2f", ns.db.iconScale or 1), 0.3, 2, "TOPLEFT", useArrows, "BOTTOMLEFT", 2, -GAP)
	scaleslider.tiptext = "Set the POI icon scale."
	scaleslider:SetValue(ns.db.iconScale or 1)
	scaleslider:SetValueStep(.05)
	scaleslider:SetScript("OnValueChanged", function(self)
		ns.db.iconScale = self:GetValue()
		scaleslidertext:SetText(string.format("Icon scale: %.2f", ns.db.iconScale or 1))
		ns:UpdatePOIs()
	end)

	local ascaleslider, ascaleslidertext, ascalecontainer = tekslider.new(frame, string.format("Arrow scale: %.2f", ns.db.arrowScale or 1), 0.3, 2, "TOPLEFT", scalecontainer, "BOTTOMLEFT", 2, -GAP)
	ascaleslider.tiptext = "Set the POI arrow scale."
	ascaleslider:SetValue(ns.db.arrowScale or 1)
	ascaleslider:SetValueStep(.05)
	ascaleslider:SetScript("OnValueChanged", function(self)
		ns.db.arrowScale = self:GetValue()
		ascaleslidertext:SetText(string.format("Arrow scale: %.2f", ns.db.arrowScale or 1))
		ns:UpdatePOIs()
	end)
	
	local ialphaslider, ialphaslidertext, ialphacontainer = tekslider.new(frame, string.format("Icon alpha: %.2f", ns.db.iconAlpha or 1), 0.1, 1, "TOPLEFT", ascalecontainer, "BOTTOMLEFT", 2, -GAP)
	ialphaslider.tiptext = "Set the POI icon ialpha."
	ialphaslider:SetValue(ns.db.iconAlpha or 1)
	ialphaslider:SetValueStep(.05)
	ialphaslider:SetScript("OnValueChanged", function(self)
		ns.db.iconAlpha = self:GetValue()
		ialphaslidertext:SetText(string.format("Icon alpha: %.2f", ns.db.iconAlpha or 1))
		ns:UpdatePOIs()
	end)
	
	local aalphaslider, aalphaslidertext, aalphacontainer = tekslider.new(frame, string.format("Arrow alpha: %.2f", ns.db.arrowAlpha or 1), 0.1, 1, "TOPLEFT", ialphacontainer, "BOTTOMLEFT", 2, -GAP)
	aalphaslider.tiptext = "Set the POI icon aalpha."
	aalphaslider:SetValue(ns.db.arrowAlpha or 1)
	aalphaslider:SetValueStep(.05)
	aalphaslider:SetScript("OnValueChanged", function(self)
		ns.db.arrowAlpha = self:GetValue()
		aalphaslidertext:SetText(string.format("Arrow alpha: %.2f", ns.db.arrowAlpha or 1))
		ns:UpdatePOIs()
	end)
	
	local fadeEdge = tekcheck.new(frame, nil, "Fade non-arrow icons on the edge", "TOPLEFT", aalphacontainer, "BOTTOMLEFT", -2, -GAP)
	fadeEdge.tiptext = "Automatically set TomTom's CrazyArrow to point to the nearest quest POI. This will mess up anything else you're trying to do with TomTom, so be careful with it."
	fadeEdge:SetScript("OnClick", function(self)
		checksound(self)
		ns.db.fadeEdge = not ns.db.fadeEdge
		ns:UpdatePOIs()
	end)
	fadeEdge:SetChecked(ns.db.fadeEdge)

	local autoTomTom = tekcheck.new(frame, nil, "Automatically add to TomTom", "TOPLEFT", fadeEdge, "BOTTOMLEFT", -2, -GAP)
	autoTomTom.tiptext = "Automatically set TomTom's CrazyArrow to point to the nearest quest POI. This will mess up anything else you're trying to do with TomTom, so be careful with it."
	autoTomTom:SetScript("OnClick", function(self)
		checksound(self)
		ns.db.autoTomTom = not ns.db.autoTomTom
		ns:AutoTomTom()
	end)
	autoTomTom:SetChecked(ns.db.autoTomTom)

	frame:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(frame)

-----------------------------
--      Slash command      --
-----------------------------

_G["SLASH_".. myname:upper().."1"] = GetAddOnMetadata(myname, "X-LoadOn-Slash")
_G["SLASH_".. myname:upper().."2"] = "/qp"
SlashCmdList[myname:upper()] = function(msg)
	if msg:match("closest") and ns.TomTomClosestPOI then
		ns:TomTomClosestPOI()
	else
		InterfaceOptionsFrame_OpenToCategory(myname)
	end
end

----------------------------------------
--      Quicklaunch registration      --
----------------------------------------

LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(myname, {
	type = "launcher",
	icon = [[Interface\WorldMap\UI-WorldMap-QuestIcon.tga]],
	iconCoords = {0, 0.5, 0, 0.5},
	OnClick = function(self, button)
		if button == "RightButton" then
			InterfaceOptionsFrame_OpenToCategory(myname)
		elseif ns.TomTomClosestPOI then
			ns:TomTomClosestPOI()
		end
	end,
})
