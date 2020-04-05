local panel = CreateFrame("FRAME", nil, InterfaceOptionsFramePanelContainer)
panel.name = "FramesResized"

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Elkano's FramesResized")

local subtext = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtext:SetHeight(32)
subtext:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtext:SetPoint("RIGHT", -32, 0)
subtext:SetJustifyH("LEFT")
subtext:SetJustifyV("TOP")
subtext:SetText("These settings control which frames should be increased in size or made moveable by FramesResized.\nMost changes will require you to reload the UI.")

-- -----
-- LootFrame
-- -----
local LootFrame_Box = CreateFrame("FRAME", "FramesResizedPanel_LootFrame_Box", panel, "OptionsBoxTemplate")
LootFrame_Box:SetHeight(36)
LootFrame_Box:SetWidth(186)
LootFrame_Box:SetPoint("TOPLEFT", 16, -96)
LootFrame_Box:SetBackdropBorderColor(0.4, 0.4, 0.4);
LootFrame_Box:SetBackdropColor(0.15, 0.15, 0.15);
_G["FramesResizedPanel_LootFrame_BoxTitle"]:SetText("LootFrame");

local LootFrame_Resize = CreateFrame("CHECKBUTTON", "FramesResizedPanel_LootFrame_Resize", panel, "InterfaceOptionsSmallCheckButtonTemplate")
LootFrame_Resize:SetPoint("TOPLEFT", LootFrame_Box, "TOPLEFT", 8, -6)
_G["FramesResizedPanel_LootFrame_ResizeText"]:SetText("Resize")
LootFrame_Resize.setFunc = function(v) FramesResized_SV.LootFrame_Resize = (v == "1") end

-- -----
-- RaidInfo
-- -----
local RaidInfo_Box = CreateFrame("FRAME", "FramesResizedPanel_RaidInfo_Box", panel, "OptionsBoxTemplate")
RaidInfo_Box:SetHeight(36)
RaidInfo_Box:SetWidth(186)
RaidInfo_Box:SetPoint("TOPLEFT", LootFrame_Box, "TOPRIGHT", 8, 0)
RaidInfo_Box:SetBackdropBorderColor(0.4, 0.4, 0.4);
RaidInfo_Box:SetBackdropColor(0.15, 0.15, 0.15);
_G["FramesResizedPanel_RaidInfo_BoxTitle"]:SetText("RaidInfo");

local RaidInfo_Resize = CreateFrame("CHECKBUTTON", "FramesResizedPanel_RaidInfo_Resize", panel, "InterfaceOptionsSmallCheckButtonTemplate")
RaidInfo_Resize:SetPoint("TOPLEFT", RaidInfo_Box, "TOPLEFT", 8, -6)
_G["FramesResizedPanel_RaidInfo_ResizeText"]:SetText("Resize")
RaidInfo_Resize.setFunc = function(v) FramesResized_SV.RaidInfo_Resize = (v == "1") end

-- -----
-- TraidSkillUI
-- -----
local TraidSkillUI_Box = CreateFrame("FRAME", "FramesResizedPanel_TraidSkillUI_Box", panel, "OptionsBoxTemplate")
TraidSkillUI_Box:SetHeight(60)
TraidSkillUI_Box:SetWidth(186)
TraidSkillUI_Box:SetPoint("TOPLEFT", LootFrame_Box, "BOTTOMLEFT", 0, -16)
TraidSkillUI_Box:SetBackdropBorderColor(0.4, 0.4, 0.4);
TraidSkillUI_Box:SetBackdropColor(0.15, 0.15, 0.15);
_G["FramesResizedPanel_TraidSkillUI_BoxTitle"]:SetText("TraidSkillUI");

local TraidSkillUI_Resize = CreateFrame("CHECKBUTTON", "FramesResizedPanel_TraidSkillUI_Resize", panel, "InterfaceOptionsSmallCheckButtonTemplate")
TraidSkillUI_Resize:SetPoint("TOPLEFT", TraidSkillUI_Box, "TOPLEFT", 8, -6)
_G["FramesResizedPanel_TraidSkillUI_ResizeText"]:SetText("Resize")
TraidSkillUI_Resize.setFunc = function(v) FramesResized_SV.TraidSkillUI_Resize = (v == "1") end

local TraidSkillUI_Moveable = CreateFrame("CHECKBUTTON", "FramesResizedPanel_TraidSkillUI_Moveable", panel, "InterfaceOptionsSmallCheckButtonTemplate")
TraidSkillUI_Moveable:SetPoint("TOPLEFT", TraidSkillUI_Resize, "BOTTOMLEFT", 0, 4)
_G["FramesResizedPanel_TraidSkillUI_MoveableText"]:SetText("Moveable")
TraidSkillUI_Moveable.setFunc = function(v) FramesResized_SV.TraidSkillUI_Moveable = (v == "1") end

-- -----
-- TrainerUI
-- -----
local TrainerUI_Box = CreateFrame("FRAME", "FramesResizedPanel_TrainerUI_Box", panel, "OptionsBoxTemplate")
TrainerUI_Box:SetHeight(60)
TrainerUI_Box:SetWidth(186)
TrainerUI_Box:SetPoint("TOPLEFT", RaidInfo_Box, "BOTTOMLEFT", 0, -16)
TrainerUI_Box:SetBackdropBorderColor(0.4, 0.4, 0.4);
TrainerUI_Box:SetBackdropColor(0.15, 0.15, 0.15);
_G["FramesResizedPanel_TrainerUI_BoxTitle"]:SetText("TrainerUI");

local TrainerUI_Resize = CreateFrame("CHECKBUTTON", "FramesResizedPanel_TrainerUI_Resize", panel, "InterfaceOptionsSmallCheckButtonTemplate")
TrainerUI_Resize:SetPoint("TOPLEFT", TrainerUI_Box, "TOPLEFT", 8, -6)
_G["FramesResizedPanel_TrainerUI_ResizeText"]:SetText("Resize")
TrainerUI_Resize.setFunc = function(v) FramesResized_SV.TrainerUI_Resize = (v == "1") end

local TrainerUI_Moveable = CreateFrame("CHECKBUTTON", "FramesResizedPanel_TrainerUI_Moveable", panel, "InterfaceOptionsSmallCheckButtonTemplate")
TrainerUI_Moveable:SetPoint("TOPLEFT", TrainerUI_Resize, "BOTTOMLEFT", 0, 4)
_G["FramesResizedPanel_TrainerUI_MoveableText"]:SetText("Moveable")
TrainerUI_Moveable.setFunc = function(v) FramesResized_SV.TrainerUI_Moveable = (v == "1") end

panel.refresh = function()
	LootFrame_Resize:SetChecked(FramesResized_SV.LootFrame_Resize)
	RaidInfo_Resize:SetChecked(FramesResized_SV.RaidInfo_Resize)
	TraidSkillUI_Resize:SetChecked(FramesResized_SV.TraidSkillUI_Resize)
	TraidSkillUI_Moveable:SetChecked(FramesResized_SV.TraidSkillUI_Moveable)
	TrainerUI_Resize:SetChecked(FramesResized_SV.TrainerUI_Resize)
	TrainerUI_Moveable:SetChecked(FramesResized_SV.TrainerUI_Moveable)
end

InterfaceOptions_AddCategory(panel)

SLASH_FRAMESRESIZED1 = "/fr"
SlashCmdList.FRAMESRESIZED = function() InterfaceOptionsFrame_OpenToCategory(panel) end
