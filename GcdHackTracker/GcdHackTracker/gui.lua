GHT_Gui = {}
GHT_Gui.__index = GHT_Gui

local L = LibStub("AceLocale-3.0"):GetLocale("GcdHackTracker", true)

----
-- Constructor of GUI Class.
-- Only one instance exists (instantiated in ght.lua).
function GHT_Gui:new()
	
	local self = {}
	setmetatable(self, GHT_Gui)
	
	self.width = 600
	self.height = 300
	self.frame = nil
	self.scroll = nil
	self.txtName = nil
	self.txtEvidence = nil
	self.fldName = nil
	self.fldEvidence = nil
	self.evidence = nil -- scroll for evidence
	self.btnDelete = nil
	self.btnShout = nil
	self.buttons = 0
	
	return self
end

----
-- creates the frame for tracking on-the-fly.
function GHT_Gui:createTrackFrame()
	
	-- BASIC FRAME
	self.frame = CreateFrame("Frame", "GHTracker", UIParent)
	self.frame:SetFrameStrata("HIGH")
	self.frame:SetWidth(self.width)
	self.frame:SetHeight(self.height)
	self.frame:SetPoint("Center", 0, 0)
	
	self.frame:SetBackdrop({
	  bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
	  --edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", 
	  edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
	  tile=1, tileSize=10, edgeSize=10, 
	  insets={left=3, right=3, top=3, bottom=3}
	})
	self.frame:SetMovable(true)
	self.frame:EnableMouse(true)
	self.frame:SetScript("OnMouseDown", self.frame.StartMoving)
	self.frame:SetScript("OnMouseUp", self.frame.StopMovingOrSizing)
	self.frame:Show()
	
	-- SCROLL FRAME
	--[[
	local s = CreateFrame("ScrollFrame", "$parentScroll", self.frame, "FauxScrollFrameTemplate")
	s:SetHeight(self.height-10)
	s:SetWidth(150)
	s:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -5)
	s:Show()
	s:SetScript("OnVerticalScroll", function()
		FauxScrollFrame_OnVerticalScroll(10, _G["GcdHackTracker"]:updateVerticalScrollFrame())
	end)
	self.scroll = s
	--]]
	
	local scf = CreateFrame("ScrollFrame", "$parentProofs", self.frame, "FauxScrollFrameTemplate")
	local scc = CreateFrame("Frame", "$parentScrollChildFrame", scf)
	scf:SetScrollChild(scc)
	scf:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 10, -10)
	scc:SetPoint("TOPLEFT", scf, "TOPLEFT", 0, 0)
	scf:SetWidth(150)
	scf:SetHeight(280)
	scc:SetWidth(150)
	scc:SetHeight(500)
	scf:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="", tile = false, tileSize = 0, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	scf:SetScript("OnVerticalScroll", function(s, o)
		FauxScrollFrame_OnVerticalScroll(s, o, 20, GHT_updateVerticalScrollFrame);
	end)
	scf:EnableMouse(true)
	scf:Show()
	scc:Show()
	
	self.scroll = scf
	
	-- CLOSE BUTTON
	self.btnClose = CreateFrame("Button", "$parentClose", self.frame)
	self.btnClose:SetHeight(32)
	self.btnClose:SetWidth(32)
	
	self.btnClose:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	self.btnClose:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	self.btnClose:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD")

	self.btnClose:SetPoint("TOPRIGHT" , self.frame, "TOPRIGHT", 0, 0)
	self.btnClose:SetScript("OnClick", function (s, b, d)
		s:GetParent():Hide()
		_G["GcdHackTracker"]:closeFrame()
	end)
	self.btnClose:Show()
	
	
	
	
	-- BUTTONS INSIDE SCROLL FRAME
	local btn, lastBtn
	for i=1, floor((scf:GetHeight()/20)+0.5) do
		
		btn = CreateFrame("Button", scf:GetName() .. "Entry" .. i, scf)
		btn:SetHeight(20)
		btn:SetWidth(170)
		btn:SetNormalFontObject("GameFontHighlightLeft")
		
		if (i == 1) then
			btn:SetPoint("TOPLEFT", scf, "TOPLEFT", 5, 0)
		else
			btn:SetPoint("TOPLEFT", lastBtn, "BOTTOMLEFT", 0, 0)
		end
		
		lastBtn = btn
		self.buttons = i
		
		btn:SetScript("OnClick", function(s)
			_G["GcdHackTracker"]:updateDetails(s:GetText())
		end)
		btn:SetScript("OnShow", function(s)
			s:GetFontString():SetTextColor(0.6, 0.6, 0.6)
		end)
	end
	
	
	-- TEXTSTRINGS
	self.txtName = self.frame:CreateFontString("$parentName", "ARTWORK", "GameFontNormal")
	self.txtName:SetText(L.RUN_NAME .. ":")
	self.txtName:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 220, -15)
	self.txtName:Show()
	
	self.txtEvidence = self.frame:CreateFontString("$parentName", "ARTWORK", "GameFontNormal")
	self.txtEvidence:SetText(L.RUN_EVIDENCEBIG .. ":")
	self.txtEvidence:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 220, -35)
	self.txtEvidence:Show()
	
	self.fldName = self.frame:CreateFontString("$parentName", "ARTWORK", "GameFontNormal")
	self.fldName:SetText("")
	self.fldName:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 320, -15)
	self.fldName:SetTextColor(1, 1, 1)
	self.fldName:Show()
	
	self.fldEvidence = self.frame:CreateFontString("$parentName", "ARTWORK", "GameFontNormal")
	self.fldEvidence:SetText("")
	self.fldEvidence:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 320, -35)
	self.fldEvidence:SetTextColor(1, 1, 1)
	self.fldEvidence:Show()
	
	
	-- ACTION BUTTONS
	self.btnDelete = CreateFrame("Button", "$parentDelete", self.frame, "UIPanelButtonTemplate")
	self.btnDelete:SetText(L.RUN_DELETEENTRY)
	self.btnDelete:SetWidth(130)
	self.btnDelete:SetHeight(30)
	self.btnDelete:SetPoint("TOPLEFT", self.frame, 220, -60)
	self.btnDelete:SetScript("OnClick", function()
		_G["GcdHackTracker"]:deleteEntry()
	end)
	
	self.btnShout = CreateFrame("Button", "$parentShout", self.frame, "UIPanelButtonTemplate")
	self.btnShout:SetText(L.RUN_SHOUT)
	self.btnShout:SetWidth(100)
	self.btnShout:SetHeight(30)
	self.btnShout:SetPoint("TOPLEFT", self.frame, 365, -60)
	self.btnShout:SetScript("OnClick", function()
		_G["GcdHackTracker"]:shoutEvidence()
	end)
	
	
	-- PROPERTY SCROLL FRAME
	local pscf = CreateFrame("ScrollFrame", "$parentDetail", self.frame, "FauxScrollFrameTemplate")
	local pscc = CreateFrame("Frame", "$parentScrollChildFrame", pscf)
	pscf:SetScrollChild(scc)
	pscf:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 220, -110)
	pscc:SetPoint("TOPLEFT", pscf, "TOPLEFT", 0, 0)
	pscf:SetWidth(345)
	pscf:SetHeight(180)
	pscc:SetWidth(345)
	pscc:SetHeight(200)
	pscf:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="", tile = false, tileSize = 0, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	pscf:SetScript("OnVerticalScroll", function(s, o)
		FauxScrollFrame_OnVerticalScroll(s, o, 45, GHT_updateVerticalScrollDetailFrame);
	end)
	pscf:EnableMouse(true)
	pscf:Show()
	pscc:Show()
	
	self.evidence = pscf
	
	-- PROPERTY TEXTS
	local txt, txt2, header, lastTxt
	for i=1, floor((pscf:GetHeight()/45)+0.5) do
		
		header = pscf:CreateFontString(pscf:GetName() .. "Head" .. i, "ARTWORK", "GameFontNormal")
		header:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
		header:SetText("")
		header:SetWordWrap(false)
		header:SetWidth(335)
		header:SetJustifyH("LEFT")
		if (not lastTxt) then
			header:SetPoint("TOPLEFT", pscc, 5, -5)
		else
			header:SetPoint("TOPLEFT", lastTxt, 0, -18)
		end
		
		txt = pscf:CreateFontString(pscf:GetName() .. "Head" .. i .. "Sub", "ARTWORK", "GameFontNormal")
		txt:SetFont("Fonts\\FRIZQT__.TTF", 10)
		txt:SetText("")
		txt:SetWidth(335)
		txt:SetWordWrap(false)
		txt:SetJustifyH("LEFT")
		txt:SetTextColor(1, 1, 1)
		txt:SetPoint("TOPLEFT", header, 0, -15)
		
		txt2 = pscf:CreateFontString(pscf:GetName() .. "Head" .. i .. "SubSub", "ARTWORK", "GameFontNormal")
		txt2:SetFont("Fonts\\FRIZQT__.TTF", 10)
		txt2:SetText("")
		txt2:SetWidth(335)
		txt2:SetWordWrap(false)
		txt2:SetJustifyH("LEFT")
		txt2:SetTextColor(1, 1, 1)
		txt2:SetPoint("TOPLEFT", txt, 0, -12)
		
		lastTxt = txt2
		
	end
	
	
end