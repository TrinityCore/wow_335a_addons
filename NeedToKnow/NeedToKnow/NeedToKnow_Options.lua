NEEDTOKNOW.MAXBARSPACING = 24;
NEEDTOKNOW.MAXBARPADDING = 12;

local LSM = LibStub("LibSharedMedia-3.0", true);
local textureList = LSM:List("statusbar");
local fontList = LSM:List("font");

function NeedToKnow.SlashCommand(cmd)
    if ( cmd == NEEDTOKNOW.CMD_RESET ) then
        NeedToKnow.Reset();
    elseif ( cmd == NEEDTOKNOW.CMD_SHOW ) then
        NeedToKnow.Show(true);
    elseif ( cmd == NEEDTOKNOW.CMD_HIDE ) then
        NeedToKnow.Show(false);
    else 
        NeedToKnow.LockToggle();
    end
end

function NeedToKnow.LockToggle()
    if ( NeedToKnow_Settings["Locked"] ) then
        NeedToKnow_Settings["Locked"] = false;
    else
        NeedToKnow_Settings["Locked"] = true;
    end
    NeedToKnow.Show(true);
    PlaySound("UChatScrollButton");
    NeedToKnow.last_cast = {};
    NeedToKnow.Update();
end


-- -----------------------------
-- INTERFACE OPTIONS PANEL: MAIN
-- -----------------------------

function NeedToKnow.UIPanel_OnLoad(self)
    local panelName = self:GetName();
    local numberbarsLabel = _G[panelName.."NumberbarsLabel"];
    local fixedDurationLabel = _G[panelName.."FixedDurationLabel"];    
    _G[panelName.."Version"]:SetText(NEEDTOKNOW.VERSION);
    _G[panelName.."SubText1"]:SetText(NEEDTOKNOW.UIPANEL_SUBTEXT1);
    numberbarsLabel:SetText(NEEDTOKNOW.UIPANEL_NUMBERBARS);
    numberbarsLabel:SetWidth(50);
    fixedDurationLabel:SetText(NEEDTOKNOW.UIPANEL_FIXEDDURATION);
    fixedDurationLabel:SetWidth(50);
end

function NeedToKnow.UIPanel_OnShow()
    NeedToKnow_OldSettings = CopyTable(NeedToKnow_Settings);
    NeedToKnow.UIPanel_Update();
end

function NeedToKnow.UIPanel_Update()
    local panelName = "InterfaceOptionsNeedToKnowPanel";
    if not _G[panelName]:IsVisible() then return end

    local settings = NeedToKnow_Settings;

    for groupID = 1, NEEDTOKNOW.MAXGROUPS do
        NeedToKnow.GroupEnableButton_Update(groupID);
        NeedToKnow.NumberbarsWidget_Update(groupID);
        _G[panelName.."Group"..groupID.."FixedDurationBox"]:SetText(settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["FixedDuration"] or "");
    end
end

function NeedToKnow.GroupEnableButton_Update(groupID)
    local button = _G["InterfaceOptionsNeedToKnowPanelGroup"..groupID.."EnableButton"];
    button:SetChecked(NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Enabled"]);
end

function NeedToKnow.GroupEnableButton_OnClick(self)
    local groupID = self:GetParent():GetID();
    if ( self:GetChecked() ) then
        NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Enabled"] = true;
    else
        NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Enabled"] = false;
    end
    NeedToKnow.Update();
end

function NeedToKnow.NumberbarsWidget_Update(groupID)
    local widgetName = "InterfaceOptionsNeedToKnowPanelGroup"..groupID.."NumberbarsWidget";
    local text = _G[widgetName.."Text"];
    local leftButton = _G[widgetName.."LeftButton"];
    local rightButton = _G[widgetName.."RightButton"];
    local numberBars = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["NumberBars"];
    text:SetText(numberBars);
    leftButton:Enable();
    rightButton:Enable();
    if ( numberBars == 1 ) then
        leftButton:Disable();
    elseif ( numberBars == NEEDTOKNOW.MAXBARS ) then
        rightButton:Disable();
    end
end

function NeedToKnow.NumberbarsButton_OnClick(self, increment)
    local groupID = self:GetParent():GetParent():GetID();
    local oldNumber = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["NumberBars"];
    if ( oldNumber == 1 ) and ( increment < 0 ) then 
        return;
    elseif ( oldNumber == NEEDTOKNOW.MAXBARS ) and ( increment > 0 ) then
        return;
    end
    NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["NumberBars"] = oldNumber + increment;
    NeedToKnow.Group_Update(groupID);
    NeedToKnow.NumberbarsWidget_Update(groupID);
end

function NeedToKnow.FixedDurationEditBox_OnTextChanged(self)
    local enteredText = self:GetText();
    if enteredText == "" then
        NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][self:GetParent():GetID()]["FixedDuration"] = nil;
    else
        NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][self:GetParent():GetID()]["FixedDuration"] = enteredText;
    end
    NeedToKnow.Update();
end

function NeedToKnow.Reset()
    NeedToKnow_Settings = CopyTable(NEEDTOKNOW.DEFAULTS);
    NeedToKnow_Settings["Spec"][1]["Groups"][1]["Enabled"] = true;
    NeedToKnow_Settings["Spec"][2]["Groups"][1]["Enabled"] = true;
    for groupID = 1, NEEDTOKNOW.MAXGROUPS do
        local group = _G["NeedToKnow_Group"..groupID];
        group:ClearAllPoints();
        group:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 100, -100 - 100*groupID);
    end
    NeedToKnow.Update();
    NeedToKnow.UIPanel_Update();
    NeedToKnow.UIPanel_Appearance_Update();
end

function NeedToKnow.Cancel()
    NeedToKnow_Settings = CopyTable(NeedToKnow_OldSettings);
    NeedToKnow.Update();
end


-- -----------------------------------
-- INTERFACE OPTIONS PANEL: APPEARANCE
-- -----------------------------------

function NeedToKnow.UIPanel_Appearance_OnLoad(self)
    local panelName = self:GetName();
    _G[panelName.."Version"]:SetText(NEEDTOKNOW.VERSION);
    _G[panelName.."SubText1"]:SetText(NEEDTOKNOW.UIPANEL_SUBTEXT1);
end

function NeedToKnow.UIPanel_Appearance_OnShow()
    NeedToKnow.UIPanel_Appearance_Update();
end

function NeedToKnow.UIPanel_Appearance_Update()
    local panelName = "InterfaceOptionsNeedToKnowAppearancePanel";
    if not _G[panelName]:IsVisible() then return end
    
    local settings = NeedToKnow_Settings;
    local barSpacingSlider = _G[panelName.."BarSpacingSlider"];
    local barPaddingSlider = _G[panelName.."BarPaddingSlider"];

    -- Mimic the behavior of the context menu, and force the alpha to one in the swatch
    local r,g,b = unpack(settings.BkgdColor);
    _G[panelName.."BackgroundColorButtonNormalTexture"]:SetVertexColor(r,g,b,1);

    barSpacingSlider:SetMinMaxValues(0, NEEDTOKNOW.MAXBARSPACING);
    barSpacingSlider:SetValue(settings.BarSpacing);
    barPaddingSlider:SetMinMaxValues(0, NEEDTOKNOW.MAXBARPADDING);
    barPaddingSlider:SetValue(settings.BarPadding);

	NeedToKnow.UpdateBarTextureDropDown(panelName);
	NeedToKnow.UpdateBarFontDropDown(panelName);
end


function NeedToKnow.UpdateBarTextureSlider(info, value)
    getglobal(info:GetName().."Label"):SetText(textureList[value]);
    NeedToKnow_Settings["BarTexture"] = textureList[value];
    NeedToKnow.Update();
end

function NeedToKnow.UpdateBarFontSlider(info, value)
    local fontName = fontList[value];
    local fontPath = LSM:Fetch("font", fontName);
    getglobal(info:GetName().."Label"):SetText(fontName);
    NeedToKnow_Settings["BarFont"] = fontPath;
    NeedToKnow.Update();
    NeedToKnow.UIPanel_Appearance_Update();
end


function NeedToKnow.ChooseColor(variable)
    info = UIDropDownMenu_CreateInfo();
    info.r, info.g, info.b, info.opacity = unpack(NeedToKnow_Settings[variable]);
    info.opacity = 1 - info.opacity;
    info.hasOpacity = true;
    info.opacityFunc = NeedToKnow.SetOpacity;
    info.swatchFunc = NeedToKnow.SetColor;
    info.cancelFunc = NeedToKnow.CancelColor;
    info.extraInfo = variable;
    -- Not sure if I should leave this state around or not.  It seems like the
    -- correct strata to have it at anyway, so I'm going to leave it there for now
    ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG");
    OpenColorPicker(info);
end

function NeedToKnow.SetColor()
    local variable = ColorPickerFrame.extraInfo;
    local r,g,b = ColorPickerFrame:GetColorRGB();
    NeedToKnow_Settings[variable][1] = r;
    NeedToKnow_Settings[variable][2] = g;
    NeedToKnow_Settings[variable][3] = b;
    NeedToKnow.Update();
    NeedToKnow.UIPanel_Appearance_Update();
end

function NeedToKnow.SetOpacity()
    local variable = ColorPickerFrame.extraInfo;
    NeedToKnow_Settings[variable][4] = 1 - OpacitySliderFrame:GetValue();
    NeedToKnow.Update();
    NeedToKnow.UIPanel_Appearance_Update();
end

function NeedToKnow.CancelColor(previousValues)
    if ( previousValues ) then
        local variable = ColorPickerFrame.extraInfo;
        NeedToKnow_Settings[variable] = {previousValues.r, previousValues.g, previousValues.b, previousValues.opacity};
        NeedToKnow.Update();
        NeedToKnow.UIPanel_Appearance_Update();
    end
end

function NeedToKnow.UpdateBarTextureDropDown(panelName)
    local barTextureSlider = _G[panelName.."BarTextureSlider"];
    barTextureSlider:SetMinMaxValues(1, #(textureList));
    barTextureSlider:SetValueStep(1);
    getglobal(panelName.."BarTextureSliderLow"):SetText('');
    getglobal(panelName.."BarTextureSliderHigh"):SetText('');
    local textureLabel = getglobal(panelName.."BarTextureSliderLabel");
    textureLabel:SetText(NeedToKnow_Settings["BarTexture"]);
    local fn = textureLabel:GetFont();
    textureLabel:SetFont(fn, 10); -- There's got to be some way to say this in the xml
    getglobal(panelName.."BarTextureSliderText"):SetText(NEEDTOKNOW.UIPANEL_BARTEXTURE);
    for i=1, #(textureList) do
        if textureList[i] == NeedToKnow_Settings.BarTexture then 
            barTextureSlider:SetValue(i); 
        end
    end
end

function NeedToKnow.UpdateBarFontDropDown(panelName)
    local barFontSlider = _G[panelName.."BarFontSlider"];
    barFontSlider:SetMinMaxValues(1, #(fontList));
    barFontSlider:SetValueStep(1);
    getglobal(panelName.."BarFontSliderLow"):SetText('');
    getglobal(panelName.."BarFontSliderHigh"):SetText('');
    getglobal(panelName.."BarFontSliderText"):SetText(NEEDTOKNOW.UIPANEL_BARFONT);
    
    for i=1, #(fontList) do
        if ( LSM:Fetch("font", fontList[i]) == NeedToKnow_Settings.BarFont ) then 
            barFontSlider:SetValue(i); 
            local lbl = getglobal(panelName.."BarFontSliderLabel");
            lbl:SetText(fontList[i]);
            lbl:SetFont(NeedToKnow_Settings.BarFont, 10);
        end
    end
end

-- --------
-- BAR GUI
-- --------

NeedToKnow.CurrentBar = { groupID = 1, barID = 1 };        -- a dirty hack, i know.  

StaticPopupDialogs["NEEDTOKNOW.CHOOSENAME_DIALOG"] = {
    text = NEEDTOKNOW.CHOOSENAME_DIALOG,
    button1 = ACCEPT,
    button2 = CANCEL,
    hasEditBox = 1,
    maxLetters = 255,
    OnAccept = function(self)
        local text = self.editBox:GetText();
        local variable = self.variable;
        if ( nil ~= variable ) then
            NeedToKnow.BarMenu_ChooseName(text, variable);
        end
    end,
    EditBoxOnEnterPressed = function(self)
        local text = self:GetParent().editBox:GetText();
        local variable = self:GetParent().variable;
        if ( nil ~= variable ) then
            NeedToKnow.BarMenu_ChooseName(text, variable);
        end
        self:GetParent():Hide();
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide();
    end,
    OnHide = function(self)
    -- Removed for wow 3.3.5, it seems like there is a focu stack
    -- now that obsoletes this anyway.  If not, there isn't a 
    -- single ChatFrameEditBox anymore, there's ChatFrame1EditBox etc.
        -- if ( ChatFrameEditBox:IsVisible() ) then
        --    ChatFrameEditBox:SetFocus();
        -- end
        self.editBox:SetText("");
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
};

NeedToKnow.BarMenu_MoreOptions = {
    { VariableName = "Enabled", MenuText = NEEDTOKNOW.BARMENU_ENABLE },
    { VariableName = "AuraName", MenuText = NEEDTOKNOW.BARMENU_CHOOSENAME, Type = "Dialog", DialogText = "CHOOSENAME_DIALOG" },
    { VariableName = "BuffOrDebuff", MenuText = NEEDTOKNOW.BARMENU_BUFFORDEBUFF, Type = "Submenu" },
    { VariableName = "Options", MenuText = "Settings", Type = "Submenu" },
    {},
    { VariableName = "TimeFormat", MenuText = NEEDTOKNOW.BARMENU_TIMEFORMAT, Type = "Submenu" }, 
    { VariableName = "Show", MenuText = "Show...", Type = "Submenu" }, -- FIXME: Localization
    { VariableName = "VisualCastTime", MenuText = NEEDTOKNOW.BARMENU_VISUALCASTTIME, Type = "Submenu" },
    { VariableName = "BlinkSettings", MenuText = "Blink Settings", Type = "Submenu" }, -- FIXME: Localization
    { VariableName = "BarColor", MenuText = NEEDTOKNOW.BARMENU_BARCOLOR, Type = "Color" },
}

NeedToKnow.BarMenu_SubMenus = {
    -- the keys on this table need to match the settings variable names
    BuffOrDebuff = {
          { Setting = "HELPFUL", MenuText = NEEDTOKNOW.BARMENU_HELPFUL },
          { Setting = "HARMFUL", MenuText = NEEDTOKNOW.BARMENU_HARMFUL },
          { Setting = "TOTEM", MenuText = NEEDTOKNOW.BARMENU_TOTEM },
          { Setting = "CASTCD", MenuText = NEEDTOKNOW.BARMENU_CASTCD },
          { Setting = "BUFFCD", MenuText = NEEDTOKNOW.BARMENU_BUFFCD },
          { Setting = "USABLE", MenuText = NEEDTOKNOW.BARMENU_USABLE },
    },
    TimeFormat = {
          { Setting = "Fmt_SingleUnit", MenuText = NEEDTOKNOW.FMT_SINGLEUNIT },
          { Setting = "Fmt_TwoUnits", MenuText = NEEDTOKNOW.FMT_TWOUNITS },
          { Setting = "Fmt_Float", MenuText = NEEDTOKNOW.FMT_FLOAT },
    },
    Unit = {
        { Setting = "player", MenuText = NEEDTOKNOW.BARMENU_PLAYER }, 
        { Setting = "target", MenuText = NEEDTOKNOW.BARMENU_TARGET }, 
        { Setting = "targettarget", MenuText = NEEDTOKNOW.BARMENU_TARGETTARGET }, 
        { Setting = "focus", MenuText = NEEDTOKNOW.BARMENU_FOCUS }, 
        { Setting = "pet", MenuText = NEEDTOKNOW.BARMENU_PET }, 
        { Setting = "vehicle", MenuText = NEEDTOKNOW.BARMENU_VEHICLE }, 
        { Setting = "mhand", MenuText = NEEDTOKNOW.BARMENU_MAIN_HAND },
        { Setting = "ohand", MenuText = NEEDTOKNOW.BARMENU_OFF_HAND },
    },
    Opt_HELPFUL = {
      { VariableName = "Unit", MenuText = NEEDTOKNOW.BARMENU_CHOOSEUNIT, Type = "Submenu" },
      { VariableName = "bDetectExtends", MenuText = "Track duration increases" }, -- FIXME: Localization
      { VariableName = "OnlyMine", MenuText = NEEDTOKNOW.BARMENU_ONLYMINE },
      { VariableName = "show_all_stacks", MenuText = "Sum stacks from all casters" },
    },
    Opt_TOTEM = {},
    Opt_CASTCD = 
    {
        { VariableName = "append_cd", MenuText = "Append \"CD\"" }, -- FIXME: Localization
    },
    Opt_BUFFCD = 
    {
        { VariableName = "buffcd_duration", MenuText = "Cooldown duration...", Type = "Dialog", DialogText = "BUFFCD_DURATION_DIALOG", Numeric=true },
        { VariableName = "append_cd", MenuText = "Append \"CD\"" }, -- FIXME: Localization
    },
    Opt_USABLE =
    {
        { VariableName = "usable_duration", MenuText = "Usable duration...",  Type = "Dialog", DialogText = "USABLE_DURATION_DIALOG", Numeric=true },
        { VariableName = "append_usable", MenuText = "Append \"Usable\"" }, -- FIXME: Localization
    },
    VisualCastTime = {
        { VariableName = "vct_enabled", MenuText = NEEDTOKNOW.BARMENU_VCT_ENABLE },
        { VariableName = "vct_color", MenuText = NEEDTOKNOW.BARMENU_VCT_COLOR, Type = "Color" },
        { VariableName = "vct_spell", MenuText = NEEDTOKNOW.BARMENU_VCT_SPELL, Type = "Dialog", DialogText = "CHOOSE_VCT_SPELL_DIALOG" },
        { VariableName = "vct_extra", MenuText = NEEDTOKNOW.BARMENU_VCT_EXTRA, Type = "Dialog", DialogText = "CHOOSE_VCT_EXTRA_DIALOG", Numeric=true },
    },
    Show = {
        { VariableName = "show_icon", MenuText = "Icon" },
        { VariableName = "show_text", MenuText = "Aura Name" },
        { VariableName = "show_count", MenuText = "Stack Count" },
        { VariableName = "show_time", MenuText = "Time Remaining" },
        { VariableName = "show_spark", MenuText = "Spark" },
        { VariableName = "show_mypip", MenuText = "Indicator if mine" },
        { VariableName = "show_text_user", MenuText = "Override Aura Name", Type = "Dialog", DialogText = "CHOOSE_OVERRIDE_TEXT", Checked = function(settings) return "" ~= settings.show_text_user end },
    },
    BlinkSettings = {
        { VariableName = "blink_enabled", MenuText = NEEDTOKNOW.BARMENU_VCT_ENABLE },
        { VariableName = "blink_label", MenuText = "Bar text while blinking...", Type = "Dialog", DialogText="CHOOSE_BLINK_TITLE_DIALOG" }, 
        { VariableName = "MissingBlink", MenuText = "Bar color when blinking...", Type = "Color" }, -- FIXME: Localization
        { VariableName = "blink_ooc", MenuText = "Blink out of combat" }, -- FIXME: Localization
        { VariableName = "blink_boss", MenuText = "Blink only for bosses" }, -- FIXME: Localization
    },
};

NeedToKnow.BarMenu_SubMenus.Opt_HARMFUL = NeedToKnow.BarMenu_SubMenus.Opt_HELPFUL;

function NeedToKnow.Bar_OnMouseUp(self, button)
    if ( button == "RightButton" ) then
        PlaySound("UChatScrollButton");
        NeedToKnow.CurrentBar["barID"] = self:GetID();
        NeedToKnow.CurrentBar["groupID"] = self:GetParent():GetID();
        if not NeedToKnow.DropDown then
            NeedToKnow.DropDown = CreateFrame("Frame", "NeedToKnowDropDown", nil, "NeedToKnow_DropDownTemplate") 
        end
        
	-- There's no OpenDropDownMenu that forces it to show in the new place,
	-- so we have to check if the first Toggle opened or closed it
        ToggleDropDownMenu(1, nil, NeedToKnow.DropDown, "cursor", 0, 0);
        if not DropDownList1:IsShown() then
            ToggleDropDownMenu(1, nil, NeedToKnow.DropDown, "cursor", 0, 0);
        end
     end
end

function NeedToKnow.BarMenu_AddButton(barSettings, i_desc, i_parent)
    info = UIDropDownMenu_CreateInfo();
    local item_type = i_desc["Type"];
    info.text = i_desc["MenuText"];
    info.value = i_desc["VariableName"];
    if ( nil == info.value and nil ~= i_desc["Setting"]) then
        info.value = i_parent;
        item_type = "SetVar";
    end;
    
    local varSettings = barSettings[info.value];
    if ( not varSettings and (item_type == "Check" or item_type == "Color") ) then
        print (string.format("NTK: Could not find %s in", info.value), barSettings); 
        return
    end
    
    info.hasArrow = false;
    local b = i_desc["Checked"]
    if b then
        if type(b) == "function" then
            info.checked = b(barSettings)
        else
            info.checked = b
        end
    end
    --info.notCheckable = true; -- Doesn't prevent checking, just formats the line differently
    info.keepShownOnClick = true;

    if ( not item_type and not text and not info.value ) then
        info.func = NeedToKnow.BarMenu_IgnoreToggle;
        info.disabled = true;
    elseif ( nil == item_type or item_type == "Check" ) then
        info.func = NeedToKnow.BarMenu_ToggleSetting;
        info.checked = (nil ~= varSettings and varSettings);
        info.notCheckable = false;
    elseif ( item_type == "SetVar" ) then
        info.func = NeedToKnow.BarMenu_ChooseSetting;
        info.value = i_desc["Setting"];
        info.checked = (varSettings == info.value);
        info.notCheckable = false;
        info.keepShownOnClick = false;
    elseif ( item_type == "Submenu" ) then
        info.hasArrow = true;
        --info.notCheckable = true;
        -- The above doesn't really do what we want, so do it ourselves
        info.func = NeedToKnow.BarMenu_IgnoreToggle;
    elseif ( item_type == "Dialog" ) then
        info.func = NeedToKnow.BarMenu_ShowNameDialog;
        info.keepShownOnClick = false;
        info.value = {variable = i_desc.VariableName, text = i_desc.DialogText, numeric = i_desc.Numeric };
    elseif ( item_type == "Color" ) then
        info.hasColorSwatch = 1;
        info.hasOpacity = true;
        info.r = varSettings.r;
        info.g = varSettings.g;
        info.b = varSettings.b;
        info.opacity = 1 - varSettings.a;
        info.swatchFunc = NeedToKnow.BarMenu_SetColor;
        info.opacityFunc = NeedToKnow.BarMenu_SetOpacity;
        info.cancelFunc = NeedToKnow.BarMenu_CancelColor;

        info.func = UIDropDownMenuButton_OpenColorPicker;
        info.keepShownOnClick = false;
    end
  
    UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
    
    if ( item_type == "Color" ) then
        -- Sadly, extraInfo isn't a field propogated to the button
        -- Code to get the button copied from UIDropDownMenu_AddButton
        local level = UIDROPDOWNMENU_MENU_LEVEL;
        local listFrame = _G["DropDownList"..level];
        local index = listFrame and (listFrame.numButtons) or 1;
        local listFrameName = listFrame:GetName();
        local button = _G[listFrameName.."Button"..index];
        button.extraInfo = info.value;
    end
end

function NeedToKnow.BarMenu_Initialize()
    local groupID = NeedToKnow.CurrentBar["groupID"];
    local barID = NeedToKnow.CurrentBar["barID"];
    local barSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Bars"][barID];

    if ( barSettings.MissingBlink.a == 0 ) then
        barSettings.blink_enabled = false;
    end
    NeedToKnow.BarMenu_SubMenus.Options = NeedToKnow.BarMenu_SubMenus["Opt_"..barSettings.BuffOrDebuff];
   
    if ( UIDROPDOWNMENU_MENU_LEVEL > 1 ) then
        if ( UIDROPDOWNMENU_MENU_VALUE == "VisualCastTime" ) then
            -- Create a summary title for the visual cast time submenu
            local title = "";
            if ( barSettings.vct_spell and "" ~= barSettings.vct_spell ) then
                title = title .. barSettings.vct_spell;
            end
            local fExtra = tonumber(barSettings.vct_extra);
            if ( fExtra and fExtra > 0 ) then
                if ("" ~= title) then
                    title = title .. " + ";
                end
                title = title .. string.format("%0.1fs", fExtra);
            end
            if ( "" ~= title ) then
                local info = UIDropDownMenu_CreateInfo();
                info.text = title;
                info.isTitle = true;
                UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
            end
        end
        local subMenus = NeedToKnow.BarMenu_SubMenus;
        for index, value in ipairs(subMenus[UIDROPDOWNMENU_MENU_VALUE]) do
            NeedToKnow.BarMenu_AddButton(barSettings, value, UIDROPDOWNMENU_MENU_VALUE);
        end

        if ( false == barSettings.OnlyMine and UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
            NeedToKnow.BarMenu_UncheckAndDisable(2, "bDetectExtends", false);
        end
        return;
    end
    
    -- show name
    if ( barSettings.AuraName ) and ( barSettings.AuraName ~= "" ) then
        local info = UIDropDownMenu_CreateInfo();
        info.text = barSettings.AuraName;
        info.isTitle = true;
        UIDropDownMenu_AddButton(info);
    end

    local moreOptions = NeedToKnow.BarMenu_MoreOptions;
    for index, value in ipairs(moreOptions) do
        NeedToKnow.BarMenu_AddButton(barSettings, moreOptions[index]);
    end

    info = UIDropDownMenu_CreateInfo();
    info.disabled = true;
    UIDropDownMenu_AddButton(info);

    -- clear settings
    info = UIDropDownMenu_CreateInfo();
    info.text = NEEDTOKNOW.BARMENU_CLEARSETTINGS;
    info.func = NeedToKnow.BarMenu_ClearSettings;
    UIDropDownMenu_AddButton(info);

    NeedToKnow.BarMenu_UpdateSettings(barSettings);
end

function NeedToKnow.BarMenu_IgnoreToggle(self, a1, a2, checked)
    local button = NeedToKnow.BarMenu_GetItem(NeedToKnow.BarMenu_GetItemLevel(self), self.value);
    if ( button ) then
        local checkName = button:GetName() .. "Check";
        _G[checkName]:Hide();
        button.checked = false;
    end
end

function NeedToKnow.BarMenu_ToggleSetting(self, a1, a2, checked)
    local groupID = NeedToKnow.CurrentBar["groupID"];
    local barID = NeedToKnow.CurrentBar["barID"];
    local barSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Bars"][barID];
    barSettings[self.value] = self.checked;
    local level = NeedToKnow.BarMenu_GetItemLevel(self);
    
    if ( self.value == "OnlyMine" ) then 
        if ( false == self.checked ) then
            NeedToKnow.BarMenu_UncheckAndDisable(level, "bDetectExtends", false);
        else
            NeedToKnow.BarMenu_EnableItem(level, "bDetectExtends");
            NeedToKnow.BarMenu_CheckItem(level, "show_all_stacks", false);
        end
    elseif ( self.value == "blink_enabled" ) then
        if ( true == self.checked and barSettings.MissingBlink.a == 0 ) then
            barSettings.MissingBlink.a = 0.5
        end
    elseif ( self.value == "show_all_stacks" ) then
        if ( true == self.checked ) then
            NeedToKnow.BarMenu_CheckItem(level, "OnlyMine", false);
        end
    end
    NeedToKnow.Bar_Update(groupID, barID);
end

function NeedToKnow.BarMenu_GetItemLevel(i_button)
    local path = i_button:GetName();
    local levelStr = path:match("%d+");
    return tonumber(levelStr);
end

function NeedToKnow.BarMenu_GetItem(i_level, i_valueName)
    local listFrame = _G["DropDownList"..i_level];
    local listFrameName = listFrame:GetName();
    local n = listFrame.numButtons;
    for index=1,n do
        local button = _G[listFrameName.."Button"..index];
        local txt = button.value;
        if ( txt == i_valueName ) then
            return button;
        end
    end
    return nil;
end

function NeedToKnow.BarMenu_CheckItem(i_level, i_valueName, i_bCheck)
    local button = NeedToKnow.BarMenu_GetItem(i_level, i_valueName);
    if ( button ) then
        local checkName = button:GetName() .. "Check";
        local check = _G[checkName];
        if ( i_bCheck ) then
            check:Show();
            button.checked = true;
        else
            check:Hide();
            button.checked = false;
        end
        NeedToKnow.BarMenu_ToggleSetting(button);
    end
end

function NeedToKnow.BarMenu_EnableItem(i_level, i_valueName)
    local button = NeedToKnow.BarMenu_GetItem(i_level, i_valueName)
    if ( button ) then
        button:Enable();
    end
end

function NeedToKnow.BarMenu_UncheckAndDisable(i_level, i_valueName)
    local button = NeedToKnow.BarMenu_GetItem(i_level, i_valueName);
    if ( button ) then
        NeedToKnow.BarMenu_CheckItem(i_level, i_valueName, false);
        button:Disable();
    end
end

function NeedToKnow.BarMenu_UpdateSettings(barSettings)
    local type = barSettings.BuffOrDebuff;
    local Opt = NeedToKnow.BarMenu_SubMenus["Opt_"..type];
    if ( not Opt ) then Opt = {} end
    NeedToKnow.BarMenu_SubMenus.Options = Opt;
    local button = NeedToKnow.BarMenu_GetItem(1, "Options");
    if button then
        local arrow = _G[button:GetName().."ExpandArrow"]
        local lbl = ""
        if #Opt == 0 then
            lbl = lbl .. "No "
            button:Disable();
            arrow:Hide();
        else
            button:Enable();
            arrow:Show();
        end
        lbl = lbl .. NEEDTOKNOW["BARMENU_"..type].. " Settings";
        button:SetText(lbl);
    end
end

function NeedToKnow.BarMenu_ChooseSetting(self, a1, a2, checked)
    local groupID = NeedToKnow.CurrentBar["groupID"];
    local barID = NeedToKnow.CurrentBar["barID"];
    local barSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Bars"][barID]
    barSettings[UIDROPDOWNMENU_MENU_VALUE] = self.value;
    NeedToKnow.Bar_Update(groupID, barID);
    
    if ( UIDROPDOWNMENU_MENU_VALUE == "BuffOrDebuff" ) then
        NeedToKnow.BarMenu_UpdateSettings(barSettings)
    end
end

-- TODO: There has to be a better way to do this, this has pretty bad user feel
function NeedToKnow.EditBox_Numeric_OnTextChanged(self, isUserInput)
    if ( isUserInput ) then
        local txt = self:GetText();
        local culled = txt:gsub("[^0-9.]",""); -- Remove non-digits
        local iPeriod = culled:find("[.]");
        if ( nil ~= iPeriod ) then
            local before = culled:sub(1, iPeriod);
            local after = string.gsub( culled:sub(iPeriod+1), "[.]", "" );
            culled = before .. after;
        end
        if ( txt ~= culled ) then
            self:SetText(culled);
        end
    end
    
    if ( NeedToKnow.EditBox_Original_OnTextChanged ) then
        NeedToKnow.EditBox_Original_OnTextChanged(self, isUserInput);
    end
end

function NeedToKnow.BarMenu_ShowNameDialog(self, a1, a2, checked)
    StaticPopupDialogs["NEEDTOKNOW.CHOOSENAME_DIALOG"].text = NEEDTOKNOW[self.value.text];
    local dialog = StaticPopup_Show("NEEDTOKNOW.CHOOSENAME_DIALOG");
    dialog.variable = self.value.variable;

    local edit = _G[dialog:GetName().."EditBox"];
    local groupID = NeedToKnow.CurrentBar["groupID"];
    local barID = NeedToKnow.CurrentBar["barID"];
    local barSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Bars"][barID];
    local curval;
    if ( dialog.variable ~= "ImportExport" ) then
        curval = barSettings[dialog.variable];
--    else
--        curval = NeedToKnow.ExportSettingsToString(barSettings);
    end

    local numeric = self.value.numeric or false;
    -- TODO: There has to be a better way to do this, this has pretty bad user  feel
    if ( nil == NeedToKnow.EditBox_Original_OnTextChanged ) then
        NeedToKnow.EditBox_Original_OnTextChanged = edit:GetScript("OnTextChanged");
    end
    if ( numeric ) then
        edit:SetScript("OnTextChanged", NeedToKnow.EditBox_Numeric_OnTextChanged);
    else
        edit:SetScript("OnTextChanged", NeedToKnow.EditBox_Original_OnTextChanged);
    end
    
    edit:SetFocus();
    edit:SetText(curval);
end

function NeedToKnow.BarMenu_ChooseName(text, variable)
    local groupID = NeedToKnow.CurrentBar["groupID"];
    local barID = NeedToKnow.CurrentBar["barID"];
    local barSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Bars"][barID];
    if ( variable ~= "ImportExport" ) then
        barSettings[variable] = text;
--    else
--        NeedToKnow.ImportSettingsFromString(text, barSettings);
    end

    NeedToKnow.Bar_Update(groupID, barID);
end

function MemberDump(v, bIndex, filter)
    if not v then 
        print("nil")
        return
    elseif type(v) == "table" then
    print("members")
    for index, value in pairs(v) do
        if (not filter) or (type(index) == "string" and index:find(filter)) then
            print(" ", index, value);
        end
    end
    local mt = getmetatable(v)
    if ( mt ) then
        print("metatable")
        for index, value in pairs(mt) do
            if (not filter) or (type(index) == "string" and index:find(filter)) then
                print(" ", index, value);
            end
        end
        if ( mt.__index and bIndex) then
            print("__index")
            for index, value in pairs(mt.__index) do
                if (not filter) or (type(index) == "string" and index:find(filter)) then
                    print(" ", index, value);
                end
            end
        end
    end
    else
        print(v)
    end
    
end

function NeedToKnow.BarMenu_SetColor()
    local groupID = NeedToKnow.CurrentBar["groupID"];
    local barID = NeedToKnow.CurrentBar["barID"];
    local varSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Bars"][barID][ColorPickerFrame.extraInfo];

    varSettings.r,varSettings.g,varSettings.b = ColorPickerFrame:GetColorRGB();
    NeedToKnow.Bar_Update(groupID, barID);
end

function NeedToKnow.BarMenu_SetOpacity()
    local groupID = NeedToKnow.CurrentBar["groupID"];
    local barID = NeedToKnow.CurrentBar["barID"];
    local varSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Bars"][barID][ColorPickerFrame.extraInfo];

    varSettings.a = 1 - OpacitySliderFrame:GetValue();
    NeedToKnow.Bar_Update(groupID, barID);
end

function NeedToKnow.BarMenu_CancelColor(previousValues)
    if ( previousValues.r ) then
        local groupID = NeedToKnow.CurrentBar["groupID"];
        local barID = NeedToKnow.CurrentBar["barID"];
        local varSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Bars"][barID][ColorPickerFrame.extraInfo];

        varSettings.r = previousValues.r;
        varSettings.g = previousValues.g;
        varSettings.b = previousValues.b;
        varSettings.a = 1 - previousValues.opacity;
        NeedToKnow.Bar_Update(groupID, barID);
    end
end

function NeedToKnow.BarMenu_ClearSettings()
    local groupID = NeedToKnow.CurrentBar["groupID"];
    local barID = NeedToKnow.CurrentBar["barID"];
    NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Bars"][barID] = CopyTable(NEEDTOKNOW.BAR_DEFAULTS);
    NeedToKnow.Bar_Update(groupID, barID);
    CloseDropDownMenus();
end


-- -------------
-- RESIZE BUTTON
-- -------------

function NeedToKnow.Resizebutton_OnEnter(self)
    local tooltip = _G["GameTooltip"];
    GameTooltip_SetDefaultAnchor(tooltip, self);
    tooltip:AddLine(NEEDTOKNOW.RESIZE_TOOLTIP, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
    tooltip:Show();
end

function NeedToKnow.StartSizing(self, button)
    local group = self:GetParent();
    local groupID = self:GetParent():GetID();
    group.oldScale = group:GetScale();
    group.oldX = group:GetLeft();
    group.oldY = group:GetTop();
    --    group:ClearAllPoints();
    --    group:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", group.oldX, group.oldY);
    self.oldCursorX, self.oldCursorY = GetCursorPosition(UIParent);
    self.oldWidth = _G[group:GetName().."Bar1"]:GetWidth();
    self:SetScript("OnUpdate", NeedToKnow.Sizing_OnUpdate);
end

function NeedToKnow.Sizing_OnUpdate(self)
    local uiScale = UIParent:GetScale();
    local cursorX, cursorY = GetCursorPosition(UIParent);
    local group = self:GetParent();
    local groupID = self:GetParent():GetID();

    -- calculate & set new scale
    local newYScale = group.oldScale * (cursorY/uiScale - group.oldY*group.oldScale) / (self.oldCursorY/uiScale - group.oldY*group.oldScale) ;
    local newScale = max(0.6, newYScale);
    
    -- clamp the scale so the group is a whole number of pixels tall
    local bar1 = _G[group:GetName().."Bar1"]
    local barHeight = bar1:GetHeight()
    local newHeight = newScale * barHeight
    newHeight = math.floor(newHeight + 0.0002)
    newScale = newHeight / barHeight
    group:SetScale(newScale);

    -- set new frame coords to keep same on-screen position
    local newX = group.oldX * group.oldScale / newScale;
    local newY = group.oldY * group.oldScale / newScale;
    group:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", newX, newY);

    -- calculate & set new bar width
    local newWidth = max(50, ((cursorX - self.oldCursorX)/uiScale + self.oldWidth * group.oldScale)/newScale);
    NeedToKnow.SetWidth(groupID, newWidth);
    
end

function NeedToKnow.SetWidth(groupID, width)    
    for barID = 1, NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["NumberBars"] do
        local bar = _G["NeedToKnow_Group"..groupID.."Bar"..barID];
        local background = _G[bar:GetName().."Background"];
        local text = _G[bar:GetName().."Text"];
        bar:SetWidth(width);
        text:SetWidth(width-60);
        NeedToKnow.SizeBackground(bar, bar.settings.show_icon);
    end
    NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Width"] = width;        -- move this to StopSizing?
end

function NeedToKnow.StopSizing(self, button)
    self:SetScript("OnUpdate", nil)
    local groupID = self:GetParent():GetID();
    NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Scale"] = self:GetParent():GetScale();
    NeedToKnow.SavePosition(self:GetParent(), groupID);
end

function NeedToKnow.SavePosition(group, groupID)
    groupID = groupID or group:GetID();
    local point, _, relativePoint, xOfs, yOfs = group:GetPoint();
    NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]["Position"] = {point, relativePoint, xOfs, yOfs};
end
