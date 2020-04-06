if not Skinner:isAddonEnabled("XPerl") then return end

local function colourBD(...)

	local frm = select(1, ...)
	local alpha = select(2, ...)
	local c = XPerlDB.colour.frame
	frm:SetBackdropColor(c.r, c.g, c.b, alpha or c.a)
	local c = XPerlDB.colour.border
	frm:SetBackdropBorderColor(c.r, c.g, c.b, alpha or c.a)

end

function Skinner:XPerl()

	-- Frame and Border colours
	local c = self.db.profile.Backdrop
	XPerlDB.colour.frame = {r = c.r, g = c.g, b = c.b, a = c.a}
	local c = self.db.profile.BackdropBorder
	XPerlDB.colour.border = {r = c.r, g = c.g, b = c.b, a = c.a}
	-- Gradient colours
	local c = self.db.profile.GradientMin
	XPerlDB.colour.gradient.e = {r = c.r, g = c.g, b = c.b, a = c.a}
	local c = self.db.profile.GradientMax
	XPerlDB.colour.gradient.s = {r = c.r, g = c.g, b = c.b, a = c.a}
	XPerlDB.colour.gradient.horizontal = self.db.profile.Gradient.rotate
	-- statusBar texture
	XPerlDB.bar.texture[2] = self.sbTexture
	XPerl_SetBarTextures()

	self:checkAndRunAddOn("XPerl_Player")
	self:checkAndRunAddOn("XPerl_Target")
	self:checkAndRunAddOn("XPerl_Party")
	self:checkAndRunAddOn("XPerl_RaidMonitor")

end

function Skinner:XPerl_Player()

-->>--	Player
	-- Put a border around the class icon
	local frame = XPerl_PlayerclassFrame
	self:applySkin(frame)
	self:adjWidth{obj=frame, adj=7}
	self:adjHeight{obj=frame, adj=6}
	self:moveObject(frame, "+", 3, "-", 2)
	local fTex = XPerl_PlayerclassFrametex
	self:adjWidth{obj=fTex, adj=-1}
	self:adjHeight{obj=fTex, adj=-2}
	self:moveObject(fTex, "-", 4, "+", 4)

end

function Skinner:XPerl_Target()


	local function skinClassIcon(frame)

		self:adjWidth{obj=frame, adj=-1}
		self:adjHeight{obj=frame, adj=-2}
		self:moveObject{obj=frame, y=2}
		self:addSkinButton(frame, frame)

	end
-->>--	Target
	-- Put a border around the class icon
	skinClassIcon(XPerl_TargettypeFramePlayer)
	RaiseFrameLevel(XPerl_TargetnameFrame)

-->>--	Focus
	-- Put a border around the class icon
	skinClassIcon(XPerl_FocustypeFramePlayer)

end

function Skinner:XPerl_Party()

	-- Put a border around the class icon
	for i = 1, 4 do
		local pfName = "XPerl_party"..i
		local pfLName = pfName.."levelFrame"
		local fTex = _G[pfLName.."classTexture"]
		self:adjWidth{obj=fTex, adj=-1}
		self:adjHeight{obj=fTex, adj=-2}
		self:moveObject{obj=fTex, x=-2, y=1}
		self:addSkinButton(fTex, _G[pfName], _G[pfLName])
	end

end

function Skinner:XPerl_RaidMonitor()

	self:applySkin(XPerl_RaidMonitor_Frame)

end

function Skinner:XPerl_RaidAdmin()

	-- hook this to change colours
	if not self:IsHooked("XPerl_SetupFrameSimple") then
		self:RawHook("XPerl_SetupFrameSimple", colourBD)
	end

	self:skinEditBox(XPerl_AdminFrame_Controls_Edit)
	self:moveObject{obj=XPerl_AdminFrame_Controls_Edit, x=-5}
	self:applySkin(XPerl_AdminFrame_Controls_Roster)
	self:applySkin(XPerl_AdminFrame)
-->>-- Item Checker Frame
	self:skinDropDown(XPerl_CheckButtonChannel)
	self:applySkin(XPerl_Check)
-->>-- Roster Text Frame
	self:skinScrollBar{obj=XPerl_RosterTexttextFramescroll}
	self:applySkin(XPerl_RosterTexttextFrame)
	self:applySkin(XPerl_RosterText)

end

function Skinner:XPerl_RaidHelper()

	-- hook this to change colours
	if not self:IsHooked("XPerl_SetupFrameSimple") then
		self:RawHook("XPerl_SetupFrameSimple", colourBD)
	end

	XPerl_SetupFrameSimple(XPerl_Frame)
	XPerl_SetupFrameSimple(XPerl_Assists_Frame)
	XPerl_SetupFrameSimple(XPerl_Target_AssistFrame)

	self:moveObject{obj=XPerl_Target_AssistFrame, y=1}

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then XPerl_BottomTip:SetBackdrop(self.Backdrop[1]) end
		self:skinTooltip(XPerl_BottomTip)
	end

end

function Skinner:XPerl_Options()

	-- hook these to manage backdrops
	for _, frm in pairs{"Options", "ColourPicker", "Options_TooltipConfig", "Options_TextureSelect", "OptionsQuestionDialog",  "Custom_Config"} do
		self:RawHook(_G["XPerl_"..frm], "Setup", function() end)
	end

-->>-- Options Frame
	colourBD(XPerl_Options)

	self:skinDropDown{obj=XPerl_Options_DropDown_LoadSettings}
	self:addSkinFrame{obj=XPerl_Options_Area_Align, x1=-2, y1=4, x2=2, y2=-2}
	self:skinEditBox{obj=XPerl_Options_Layout_Name, regs={9}}
	self:addSkinFrame{obj=XPerl_Options_Area_Global, x1=-2, y1=2, x2=2, y2=-2}
	self:addSkinFrame{obj=XPerl_Options_Layout_List, x1=-2, y1=2, x2=2, y2=-2}
	self:skinScrollBar{obj=XPerl_Options_Layout_ListScrollBar}
	self:addSkinFrame{obj=XPerl_Options_Area_Tabs, x1=-2, y1=1, x2=2, y2=-2}
	-- player alignment
	self:adjWidth{obj=XPerl_Options_Player_Gap, adj=-10}
	self:moveObject{obj=XPerl_Options_Player_Gap, x=-10}
	self:moveObject{obj=XPerl_Options_Player_BiggerGap, x=4}
	self:skinEditBox{obj=XPerl_Options_Player_Gap, regs={9}}
	-- party alignment
	self:skinDropDown{obj=XPerl_Options_Party_Anchor}
	self:moveObject{obj=XPerl_Options_Party_Gap, x=-6}
	self:moveObject{obj=XPerl_Options_Party_BiggerGap, x=6}
	self:skinEditBox{obj=XPerl_Options_Party_Gap, regs={9}}
	-- raid alignment
	self:skinDropDown{obj=XPerl_Options_Raid_Anchor}
	self:adjWidth{obj=XPerl_Options_Raid_Gap, adj=-10}
	self:moveObject{obj=XPerl_Options_Raid_Gap, x=-10}
	self:moveObject{obj=XPerl_Options_Raid_BiggerGap, x=4}
	self:skinEditBox{obj=XPerl_Options_Raid_Gap, regs={9}}
	-- separator line
	XPerl_Options_Global_Options_RangeFinderSeparator:Hide()

-->>-- Player Options subpanel
	self:addSkinFrame{obj=XPerl_Options_Player_Options_Buffs, x1=-2, y1=2, x2=2}
	self:addSkinFrame{obj=XPerl_Options_Player_Options_Totems, x1=-2, y1=2, x2=2}
-->>-- Pet Options subpanel
	self:addSkinFrame{obj=XPerl_Options_Pet_Options_PetTarget, x1=-2, y1=2, x2=2}
-->>-- Target Options subpanel
	self:addSkinFrame{obj=XPerl_Options_Target_Options_TargetTarget, x1=-2, y1=2, x2=2, y2=-6}
-->>-- Focus Options subpanel
	self:addSkinFrame{obj=XPerl_Options_Focus_Options_FocusTarget, x1=-2, y1=2, x2=2}
-->-- Party Options subpanel
	self:addSkinFrame{obj=XPerl_Options_Party_Options_PartyPets, x1=-2, y1=2, x2=2}
	if XPerl_Party_AnchorVirtual then
		self:addSkinFrame{obj=XPerl_Party_AnchorVirtual, x1=-2, y1=2, x2=2}
	end
-->>-- Raid Options subpanel
	self:addSkinFrame{obj=XPerl_Options_Raid_Options_Groups, x1=-2, y1=2, x2=2}
	if XPerl_Raid_Title1 then
		for i = 1, 10 do
			self:addSkinFrame{obj=_G["XPerl_Raid_Title"..i.."Virtual"]}
		end
	end
	self:addSkinFrame{obj=XPerl_Options_Raid_Options_Custom, x1=-2, y1=2, x2=2}
-->>-- Custom Raid Highlights Config
	self:skinEditBox{obj=XPerl_Custom_ConfigNew_Zone, regs={9}}
	self:skinEditBox{obj=XPerl_Custom_ConfigNew_Search, regs={9}}
	self:addSkinFrame{obj=XPerl_Custom_ConfigzoneList, y1=2, y2=-3}
	self:skinScrollBar{obj=XPerl_Custom_ConfigdebuffsscrollBar}
	self:addSkinFrame{obj=XPerl_Custom_Configdebuffs, y1=2, y2=-3}
--	self:glazeStatusBar(XPerl_Custom_ConfigiconCollect)
	self:addSkinFrame{obj=XPerl_Custom_Config, y1=-1}
-->>-- All Options subpanel
	self:addSkinFrame{obj=XPerl_Options_All_Options_AddOns, x1=-2, y1=2, x2=2}
-->>-- Colours Options subpanel
	self:addSkinFrame{obj=XPerl_Options_Colour_Options_BarColours, x1=-2, y1=2, x2=2}
	self:addSkinFrame{obj=XPerl_Options_Colour_Options_UnitReactions, x1=-2, y1=2, x2=2}
	self:addSkinFrame{obj=XPerl_Options_Colour_Options_Appearance, x1=-2, y1=2, x2=2}
	self:addSkinFrame{obj=XPerl_Options_Colour_Options_FrameColours, x1=-2, y1=2, x2=2}
-->>-- Helper Options subpanel
	self:addSkinFrame{obj=XPerl_Options_Helper_Options_Assists, x1=-2, y1=2, x2=2}

-->>-- Colour Picker Frame
	self:addSkinFrame{obj=XPerl_ColourPicker}
-->>--	Texture Select Frame
	self:skinScrollBar{obj=XPerl_Options_TextureSelectscrollBar}
	self:addSkinFrame{obj=XPerl_Options_TextureSelect}
-->>--	Options Question Dialog
	self:addSkinFrame{obj=XPerl_OptionsQuestionDialog}
-->>-- Tooltip Config
	self:addSkinFrame{obj=XPerl_Options_TooltipConfig}
	-- skin buttons
	self:skinAllButtons{obj=XPerl_Options}

end
