-- ----------------------
-- NeedToKnow
-- by Kitjan, lieandswell
-- ----------------------


if not trace then trace = print end

-- -------------
-- ADDON GLOBALS
-- -------------

NeedToKnow = {}

-- NEEDTOKNOW = {} is defined in the localization file, which must be loaded before this file

NEEDTOKNOW.VERSION = "3.1.7"
NEEDTOKNOW.MAXGROUPS = 4
NEEDTOKNOW.MAXBARS = 6
NEEDTOKNOW.UPDATE_INTERVAL = 0.05
NEEDTOKNOW.CURRENTSPEC = 1

-- Get the localized name of spell 75, which is "Auto Shot" in US English
NEEDTOKNOW.AUTO_SHOT = GetSpellInfo(75)

-- COMBAT_LOG_EVENT_UNFILTERED events where select(6,...) is the caster, 9 is the spellid, and 10 is the spell name
-- (used for Target-of-target monitoring)
NEEDTOKNOW.AURAEVENTS = {
    SPELL_AURA_APPLIED = true,
    SPELL_AURA_REMOVED = true,
    SPELL_AURA_APPLIED_DOSE = true,
    SPELL_AURA_REMOVED_DOSE = true,
    SPELL_AURA_REFRESH = true,
    SPELL_AURA_BROKEN = true,
    SPELL_AURA_BROKEN_SPELL = true
}
    
    
NEEDTOKNOW.BAR_DEFAULTS = {
    Enabled         = true,
    AuraName        = "",
    Unit            = "player",
    BuffOrDebuff    = "HELPFUL",
    OnlyMine        = true,
    BarColor        = { r=0.6, g=0.6, b=0.6, a=1.0 },
    MissingBlink    = { r=0.9, g=0.1, b=0.1, a=0.5 },
    TimeFormat      = "Fmt_SingleUnit",
    vct_enabled     = false,
    vct_color       = { r=0.6, g=0.6, b=0.0, a=0.3 },
    vct_spell       = "",
    vct_extra       = 0,
    bDetectExtends  = false,
    show_text       = true,
    show_count      = true,
    show_time       = true,
    show_spark      = true,
    show_icon       = false,
    show_mypip      = false,
    show_all_stacks = false,
    show_text_user  = "",
    blink_enabled   = false,
    blink_ooc       = true,
    blink_boss      = false,
    blink_label     = "",
    buffcd_duration = 0,
    usable_duration = 0,
    append_cd       = true,
    append_usable   = false,
}
NEEDTOKNOW.GROUP_DEFAULTS = {
    Enabled          = false,
    NumberBars       = 3,
    Scale            = 1.0,
    Width            = 270,
    Bars             = {},
    Position         = { "TOPLEFT", "TOPLEFT", 100, -100 },
    FixedDuration    = nil, 
}
NEEDTOKNOW.DEFAULTS = {
    Version       = NEEDTOKNOW.VERSION,
    Locked        = false,
    BarTexture    = "BantoBar",
    BarFont       = "DEFAULT",
    BkgdColor     = { 0, 0, 0, 0.8 },
    BarSpacing    = 3,
    BarPadding    = 3,
    Spec          = {},
}
NEEDTOKNOW.SPEC_DEFAULTS = {
    Groups      = {},
}

for barID = 1, NEEDTOKNOW.MAXBARS do
    NEEDTOKNOW.GROUP_DEFAULTS["Bars"][barID] = NEEDTOKNOW.BAR_DEFAULTS
end

for groupID = 1, NEEDTOKNOW.MAXGROUPS do
    NEEDTOKNOW.SPEC_DEFAULTS["Groups"][groupID] = NEEDTOKNOW.GROUP_DEFAULTS
end

for specID = 1, 2 do
    NEEDTOKNOW.DEFAULTS["Spec"][specID] = NEEDTOKNOW.SPEC_DEFAULTS
end

function NeedToKnow.Test(stuff)
    if ( stuff ) then
        DEFAULT_CHAT_FRAME:AddMessage("NeedToKnow test: "..stuff)
    else
        DEFAULT_CHAT_FRAME:AddMessage("NeedToKnow test: "..self:GetName())
    end
end

-- -------------------
-- SharedMedia Support
-- -------------------

    NeedToKnow.LSM = LibStub("LibSharedMedia-3.0", true)
    
    if not NeedToKnow.LSM:Fetch("statusbar", "Aluminum", true) then NeedToKnow.LSM:Register("statusbar", "Aluminum",           [[Interface\Addons\NeedToKnow\Textures\Aluminum.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Armory", true) then NeedToKnow.LSM:Register("statusbar", "Armory",             [[Interface\Addons\NeedToKnow\Textures\Armory.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "BantoBar", true) then NeedToKnow.LSM:Register("statusbar", "BantoBar",           [[Interface\Addons\NeedToKnow\Textures\BantoBar.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "DarkBottom", true) then NeedToKnow.LSM:Register("statusbar", "DarkBottom",         [[Interface\Addons\NeedToKnow\Textures\Darkbottom.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Default", true) then NeedToKnow.LSM:Register("statusbar", "Default",            [[Interface\Addons\NeedToKnow\Textures\Default.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Flat", true) then NeedToKnow.LSM:Register("statusbar", "Flat",               [[Interface\Addons\NeedToKnow\Textures\Flat.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Glaze", true) then NeedToKnow.LSM:Register("statusbar", "Glaze",              [[Interface\Addons\NeedToKnow\Textures\Glaze.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Gloss", true) then NeedToKnow.LSM:Register("statusbar", "Gloss",              [[Interface\Addons\NeedToKnow\Textures\Gloss.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Graphite", true) then NeedToKnow.LSM:Register("statusbar", "Graphite",           [[Interface\Addons\NeedToKnow\Textures\Graphite.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Minimalist", true) then NeedToKnow.LSM:Register("statusbar", "Minimalist",         [[Interface\Addons\NeedToKnow\Textures\Minimalist.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Otravi", true) then NeedToKnow.LSM:Register("statusbar", "Otravi",             [[Interface\Addons\NeedToKnow\Textures\Otravi.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Smooth", true) then NeedToKnow.LSM:Register("statusbar", "Smooth",             [[Interface\Addons\NeedToKnow\Textures\Smooth.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Smooth v2", true) then NeedToKnow.LSM:Register("statusbar", "Smooth v2",          [[Interface\Addons\NeedToKnow\Textures\Smoothv2.tga]]) end
    if not NeedToKnow.LSM:Fetch("statusbar", "Striped", true) then NeedToKnow.LSM:Register("statusbar", "Striped",            [[Interface\Addons\NeedToKnow\Textures\Striped.tga]]) end

-- ---------------
-- EXECUTIVE FRAME
-- ---------------

function NeedToKnow.ExecutiveFrame_OnEvent(self, event, ...)
    if ( event == "ADDON_LOADED" and  select(1,...) == "NeedToKnow") then

        if ( not NeedToKnow_Settings ) then
            NeedToKnow_Settings = CopyTable(NEEDTOKNOW.DEFAULTS)
            NeedToKnow_Settings["Spec"][1]["Groups"][1]["Enabled"] = true
            NeedToKnow_Settings["Spec"][2]["Groups"][1]["Enabled"] = true
        else 
            NeedToKnow.SafeUpgrade()
        end
        
        if ( not NeedToKnow_Settings.BarFont or NeedToKnow_Settings["BarFont"] == "DEFAULT" ) then
            NeedToKnow_Settings["BarFont"] = GameFontHighlight:GetFont()
        end
        
        if ( not NeedToKnow_Visible ) then
            NeedToKnow_Visible = true
        end
        
        NeedToKnow.last_cast = {} -- [spell][guidTarget] = { time, dur }
        NeedToKnow.nSent = 0
        NeedToKnow.totem_drops = {} -- array 1-4 of precise times the totems appeared
        
        SlashCmdList["NEEDTOKNOW"] = NeedToKnow.SlashCommand
        SLASH_NEEDTOKNOW1 = "/needtoknow"
        SLASH_NEEDTOKNOW2 = "/ntk"

        NeedToKnow.Update()
        NeedToKnow.UIPanel_Update()
    else 
        local fnName = "ExecutiveFrame_"..event
        local fn = NeedToKnow[fnName]
        if ( fn ) then
            fn(...)
        end
    end
end

function NeedToKnow.ExecutiveFrame_UNIT_SPELLCAST_SUCCEEDED(unit, spell, rank)
    if unit == "player" then
        local r = NeedToKnow.last_cast[spell]
        if ( r and r.state == 1 ) then
            r.state = 2
            
            -- A little extra safety just in case we get two SUCCEEDED entries
            -- before we get the combat log events for them (though I don't
            -- think this is possible.)
            NeedToKnow.last_success = spell
            
            -- We need the actual target, which we can only get from the combat log.
            -- Thankfully, the combat log event always comes after this one, so we
            -- don't need to register for the combat log for long at all.
            NeedToKnow_ExecutiveFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

            if ( NeedToKnow.nSent > 1 ) then
                NeedToKnow.nSent = NeedToKnow.nSent - 1
            else
                NeedToKnow.nSent = 0
                NeedToKnow_ExecutiveFrame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
            end
        end
    end
end

function NeedToKnow.ExecutiveFrame_COMBAT_LOG_EVENT_UNFILTERED(time, event, guidCaster, ...)
    -- the time that's passed in appears to be time of day, not game time like everything else.
    time = GetTime() 
    -- TODO: Is checking r.state sufficient or must event be checked instead?
    if ( guidCaster == NeedToKnow.guidPlayer ) then
        local guidTarget, _, _, _, spell = select(3, ...)
        local r = NeedToKnow.last_cast[spell]
        if ( r and r.state == 2) then
            r.state = 0
            -- record this spellcast
            if ( not r[guidTarget] ) then
                r[guidTarget] = { time = time, dur = 0 }
            else
                r[guidTarget].time = time
                r[guidTarget].dur = 0
            end
            
            -- Use this event to expire some targets. This should limit us to 
            -- two combats' worth of targets (since GC doesn't happen in combat)
            for kG, vG in pairs(r) do
                if ( type(vG) == "table" and ( vG.time + 300 < time ) ) then
                    r[kG] = nil
                end
            end
        end

        if ( spell == NeedToKnow.last_success ) then
            -- We saw our spell, we can disconnect from the spam hose
            NeedToKnow_ExecutiveFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
    end
end

function NeedToKnow.ExecutiveFrame_PLAYER_LOGIN()
    -- save group positions if upgrading from version that used layout-local.txt
    if ( not NeedToKnow_Settings.OldVersion or
         NeedToKnow_Settings.OldVersion < "2.1" ) then    
        for groupID = 1, NEEDTOKNOW.MAXGROUPS do
            NeedToKnow.SavePosition(_G["NeedToKnow_Group"..groupID], groupID)
        end
        
    elseif (NeedToKnow_Settings["Version"] < "2.4") then
        NeedToKnow.UIPanel_Update()
    end        

    NeedToKnow.guidPlayer = UnitGUID("player")
    NEEDTOKNOW.CURRENTSPEC = GetActiveTalentGroup()

    local _, player_CLASS = UnitClass("player")
    if player_CLASS == "DEATHKNIGHT" then
    NeedToKnow.is_DK = 1
    end

    NeedToKnow.Update()
    NeedToKnow.UIPanel_Update()
end

function NeedToKnow.ExecutiveFrame_PLAYER_TALENT_UPDATE()
    NEEDTOKNOW.CURRENTSPEC = GetActiveTalentGroup()
    NeedToKnow.Update()
    NeedToKnow.UIPanel_Update()
end
    
function NeedToKnow.ExecutiveFrame_COMMENTATOR_ENTER_WORLD()
    NeedToKnow.Update()
end


local function SetStatusBarValue(bar,texture,value,value0)
  local pct0 = 0
  if value0 then
    pct0 = value0 / bar.max_value
    if pct0 > 1 then pct0 = 1 end
  end
  
  local pct = value / bar.max_value
  texture.cur_value = value
  if pct > 1 then pct = 1 end
  local w = (pct-pct0) * bar:GetWidth()
  if w < 1 then 
      texture:Hide()
  else
      texture:SetWidth(w)
      texture:SetTexCoord(pct0,0, pct0,1, pct,0, pct,1)
      texture:Show()
  end
end


function NeedToKnow.SafeUpgrade()
    -- If there had been an error during the previous upgrade, NeedToKnow_Settings 
    -- may be in an inconsistent, halfway state.  
    local bCorruptUpgrade = false
    if ( NeedToKnow_Settings["Spec"] ) then
        for idxSpec = 1,2 do
            local specSettings = NeedToKnow_Settings.Spec[idxSpec]
            if ( not specSettings or not specSettings.Groups ) then
                bCorruptUpgrade = true
            else
                for idxGroup = 1,NEEDTOKNOW.MAXGROUPS do
                    local groupSettings = specSettings.Groups[idxGroup]
                    if not groupSettings then
                        bCorruptUpgrade = true
                    end
                end
            end
        end
        if ( not bCorruptUpgrade and NeedToKnow_Settings["Version"] < "2.4" ) then
            NeedToKnow_Settings.OldVersion = NeedToKnow_Settings["Version"]
            NeedToKnow_Settings["Version"] = NEEDTOKNOW.VERSION
        end
    end
       
    if ( bCorruptUpgrade or NeedToKnow_Settings["Version"] < "2.0" ) then            -- total settings clear if v1.x
        print("Old NeedToKnow settings not compatible with current version... starting from scratch")
        NeedToKnow_Settings = CopyTable(NEEDTOKNOW.DEFAULTS)
        NeedToKnow_Settings["Spec"][1]["Groups"][1]["Enabled"] = true
        NeedToKnow_Settings["Spec"][2]["Groups"][1]["Enabled"] = true

    -- if before dual spec support, copy old settings to both specs    
    elseif (NeedToKnow_Settings["Version"] < "2.4") then    
        local tempSettings = CopyTable(NeedToKnow_Settings)
        NeedToKnow.Reset()
        NeedToKnow_Settings["Locked"] = tempSettings["Locked"]
        NeedToKnow_Settings["BarTexture"] = tempSettings["BarTexture"]
        NeedToKnow_Settings["BkgdColor"] = tempSettings["BkgdColor"]
        NeedToKnow_Settings["BarSpacing"] = tempSettings["BarSpacing"]
        NeedToKnow_Settings["BarPadding"] = tempSettings["BarPadding"]
        NeedToKnow_Settings["Version"] = tempSettings["Version"]
        
        for i = 1, NEEDTOKNOW.MAXGROUPS do
            NeedToKnow_Settings["Spec"][1]["Groups"][i] = tempSettings["Groups"][i]
            NeedToKnow_Settings["Spec"][2]["Groups"][i] = tempSettings["Groups"][i]
        end
    end
    NeedToKnow_Settings.OldVersion = NeedToKnow_Settings["Version"]
    NeedToKnow_Settings["Version"] = NEEDTOKNOW.VERSION
    
    -- Add any new settings
    for iS,vS in ipairs(NeedToKnow_Settings["Spec"]) do
        for kD, vD in pairs(NEEDTOKNOW.SPEC_DEFAULTS) do
            if nil == vS[kD] then
                vS[kD] = NeedToKnow.deepcopy(vD)
            end
        end
        for iG,vG in ipairs(vS["Groups"]) do
            for kD, vD in pairs(NEEDTOKNOW.GROUP_DEFAULTS) do
                if nil == vG[kD] then
                    vG[kD] = NeedToKnow.deepcopy(vD)
                end
            end
            for iB, vB in ipairs(vG["Bars"]) do
                if nil == vB.blink_enabled and vB.MissingBlink then
                    vB.blink_enabled = vB.MissingBlink.a > 0
                end
                for kD, vD in pairs(NEEDTOKNOW.BAR_DEFAULTS) do
                    if nil == vB[kD] then
                        vB[kD] = NeedToKnow.deepcopy(vD)
                    end
                end
            end
        end
    end
end

-- Copies anything (int, table, whatever).  Unlike CopyTable, deepcopy can 
-- recreate a recursive reference structure (CopyTable will stack overflow.)
-- Copied from http://lua-users.org/wiki/CopyTable
function NeedToKnow.deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function NeedToKnow.Update()
    if (UnitExists("player")) then
        for groupID = 1, NEEDTOKNOW.MAXGROUPS do
            NeedToKnow.Group_Update(groupID)
        end
    end
end

function NeedToKnow.Show(bShow)
    NeedToKnow_Visible = bShow
    for groupID = 1, NEEDTOKNOW.MAXGROUPS do
        local groupName = "NeedToKnow_Group"..groupID
        local group = _G[groupName]
        local groupSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]
        
        if (NeedToKnow_Visible and groupSettings.Enabled) then
            group:Show()
        else
            group:Hide()
        end
    end
end

do
    local executiveFrame = CreateFrame("Frame", "NeedToKnow_ExecutiveFrame")
    executiveFrame:SetScript("OnEvent", NeedToKnow.ExecutiveFrame_OnEvent)
    executiveFrame:RegisterEvent("ADDON_LOADED")
    executiveFrame:RegisterEvent("PLAYER_LOGIN")
    executiveFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
    executiveFrame:RegisterEvent("COMMENTATOR_ENTER_WORLD")
end



-- ------
-- GROUPS
-- ------

function NeedToKnow.Group_Update(groupID)
    local groupName = "NeedToKnow_Group"..groupID
    local group = _G[groupName]
    local groupSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]

    for barID = 1, groupSettings.NumberBars do
        local barName = groupName.."Bar"..barID
        local bar = _G[barName] or CreateFrame("Frame", barName, group, "NeedToKnow_BarTemplate")
        bar:SetID(barID)

        if ( barID > 1 ) then
            bar:SetPoint("TOP", _G[groupName.."Bar"..(barID-1)], "BOTTOM", 0, -NeedToKnow_Settings.BarSpacing)
        else
            bar:SetPoint("TOPLEFT", group, "TOPLEFT")
        end

        NeedToKnow.Bar_Update(groupID, barID)

        if ( not groupSettings.Enabled ) then
            NeedToKnow.ClearScripts(bar)
        end
    end
    for barID = groupSettings.NumberBars+1, NEEDTOKNOW.MAXBARS do
        local bar = _G[groupName.."Bar"..barID]
        if ( bar ) then
            bar:Hide()
            NeedToKnow.ClearScripts(bar)
        end
    end

    local resizeButton = _G[groupName.."ResizeButton"]
    resizeButton:SetPoint("BOTTOMRIGHT", groupName.."Bar"..groupSettings.NumberBars, "BOTTOMRIGHT", 8, -8)
    if ( NeedToKnow_Settings["Locked"] ) then
        resizeButton:Hide()
    else
        resizeButton:Show()
    end

    -- Early enough in the loading process (before PLAYER_LOGIN), we might not
    -- know the position yet
    if groupSettings.Position then
        group:ClearAllPoints()
        local point, relativePoint, xOfs, yOfs = unpack(groupSettings.Position)
        group:SetPoint(point, UIParent, relativePoint, xOfs, yOfs)
        group:SetScale(groupSettings.Scale)
    end
    
    if ( NeedToKnow_Visible and groupSettings.Enabled ) then
        group:Show()
    else
        group:Hide()
    end
end



-- ----
-- BARS
-- ----

-- Called when the configuration of the bar has changed, when the addon
-- is loaded or when ntk is locked and unlocked
function NeedToKnow.Bar_Update(groupID, barID)
    local barName = "NeedToKnow_Group"..groupID.."Bar"..barID
    local bar = _G[barName]
    local background = _G[barName.."Background"]
    bar.spark = _G[barName.."Spark"]
    bar.text = _G[barName.."Text"]
    bar.time = _G[barName.."Time"]
    bar.bar1 = _G[barName.."Texture"]

    local groupSettings = NeedToKnow_Settings["Spec"][NEEDTOKNOW.CURRENTSPEC]["Groups"][groupID]
    local barSettings = groupSettings["Bars"][barID]
    bar.auraName = barSettings.AuraName
    if ( barSettings.BuffOrDebuff == "BUFFCD" or
         barSettings.BuffOrDebuff == "TOTEM" or
         barSettings.BuffOrDebuff == "USABLE" or
         barSettings.BuffOrDebuff == "CASTCD") 
    then
        barSettings.Unit = "player"
    end
    
    -- Look for certain magic "spell" names
    barSettings.bAutoShot = nil
    if ( barSettings.BuffOrDebuff == "CASTCD" ) then
        for barSpell in bar.auraName:gmatch("([^,]+),*") do
            barSpell = strtrim(barSpell)
            
            if ( barSpell == "Auto Shot" or
                 barSpell == NEEDTOKNOW.AUTO_SHOT or
                 barSpell == "75" ) 
            then
                barSettings.bAutoShot = true
            end
        end
    end
    
    bar.settings = barSettings
    bar.unit = barSettings.Unit
    bar.nextUpdate = GetTime() + NEEDTOKNOW.UPDATE_INTERVAL

    bar.fixedDuration = tonumber(groupSettings.FixedDuration)

    bar.max_value = 1
    SetStatusBarValue(bar,bar.bar1,1)
    bar.bar1:SetTexture(NeedToKnow.LSM:Fetch("statusbar", NeedToKnow_Settings["BarTexture"]))
    if ( bar.bar2 ) then
        bar.bar2:SetTexture(NeedToKnow.LSM:Fetch("statusbar", NeedToKnow_Settings["BarTexture"]))
    end
    local fontPath = NeedToKnow_Settings["BarFont"]
    if ( fontPath ) then
        -- TODO: I'd like to get that 12 from something rather than hard-code it
        bar.text:SetFont(fontPath, 12)
        bar.time:SetFont(fontPath, 12)
    end
    
    bar:SetWidth(groupSettings.Width)
    bar.text:SetWidth(groupSettings.Width-60)
    NeedToKnow.SizeBackground(bar, barSettings.show_icon)

    background:SetHeight(bar:GetHeight() + 2*NeedToKnow_Settings["BarPadding"])
    background:SetVertexColor(unpack(NeedToKnow_Settings["BkgdColor"]))

    -- Set up the Visual Cast Time overlay.  It isn't a part of the template 
    -- because most bars won't use it and thus don't need to pay the cost of
    -- a hidden frame
    if ( barSettings.vct_enabled ) then
        if ( nil == bar.vct ) then
            bar.vct = bar:CreateTexture(barName.."VisualCast", "ARTWORK")
            bar.vct:SetPoint("TOPLEFT", bar, "TOPLEFT")
        end
        local argb = barSettings.vct_color
        bar.vct:SetTexture(argb.r, argb.g, argb.b, argb.a )
        bar.vct:SetBlendMode("ADD")
        bar.vct:SetHeight(bar:GetHeight())
    elseif (nil ~= bar.vct) then
        bar.vct:Hide()
    end
    
    if ( barSettings.show_icon ) then
        if ( not bar.icon ) then
            bar.icon = bar:CreateTexture(bar:GetName().."Icon", "ARTWORK")
        end
        local size = bar:GetHeight()
        bar.icon:SetWidth(size)
        bar.icon:SetHeight(size)
        bar.icon:ClearAllPoints()
        bar.icon:SetPoint("TOPRIGHT", bar, "TOPLEFT", -NeedToKnow_Settings["BarPadding"], 0)
        bar.icon:Show()
    elseif (bar.icon) then
        bar.icon:Hide()
    end

    if ( NeedToKnow_Settings["Locked"] ) then
        -- Set up the bar to be functional
        bar:EnableMouse(0)
        local enabled = barSettings.Enabled
        if ( enabled and  barSettings.BuffOrDebuff == "BUFFCD" ) then
            local dur = tonumber(barSettings.buffcd_duration)
            if (not dur or dur < 1) then
                print("Internal cooldown bar watching",barSettings.AuraName,"did not set a cooldown duration.  Disabling the bar")
                enabled = false
            end
        end
        
        if ( enabled ) then
            NeedToKnow.SetScripts(bar)
            -- Events were cleared while unlocked, so need to check the bar again now
            NeedToKnow.Bar_AuraCheck(bar)
        else
            NeedToKnow.ClearScripts(bar)
            bar:Hide()
        end
    else
        NeedToKnow.ClearScripts(bar)
        -- Set up the bar to be configured
        bar:EnableMouse(1)

        bar.bar1:SetVertexColor(barSettings.BarColor.r, barSettings.BarColor.g, barSettings.BarColor.b)
        bar.bar1:SetAlpha(barSettings.BarColor.a)
        bar:Show()
        bar.spark:Hide()
        bar.time:Hide()
        if ( bar.icon ) then
            bar.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end
        if ( bar.vct ) then
            bar.vct:SetWidth( bar:GetWidth() / 16)
            bar.vct:Show()
        end
        if ( bar.bar2 ) then
            bar.bar2:Hide()
        end
        
        local txt=""
        if ( barSettings.show_mypip ) then
            txt = txt.."* "
        end

        if ( barSettings.show_text ) then
            if "" ~= barSettings.show_text_user then
                txt = barSettings.show_text_user
            else
                txt = txt .. bar.auraName
            end

            if ( barSettings.append_cd
                 and (barSettings.BuffOrDebuff == "CASTCD"
                   or barSettings.BuffOrDebuff == "BUFFCD") )
            then
                txt = txt .. " CD"
            elseif ( barSettings.append_usable
                 and barSettings.BuffOrDebuff == "USABLE" )
            then
                txt = txt .. " Usable"
            end
            if ( barSettings.bDetectExtends == true ) then
                txt = txt .. " + 3s"
            end
        end
        bar.text:SetText(txt)

        if ( barSettings.Enabled ) then
            bar:SetAlpha(1)
        else
            bar:SetAlpha(0.4)
        end
    end
end

function NeedToKnow.SetScripts(bar)
    bar:SetScript("OnEvent", NeedToKnow.Bar_OnEvent)
    bar:SetScript("OnUpdate", NeedToKnow.Bar_OnUpdate)

    if ( "TOTEM" == bar.settings.BuffOrDebuff ) then
        bar:RegisterEvent("PLAYER_TOTEM_UPDATE")
    elseif ( "CASTCD" == bar.settings.BuffOrDebuff ) then
        if ( bar.settings.bAutoShot ) then
            bar:RegisterEvent("START_AUTOREPEAT_SPELL")
            bar:RegisterEvent("STOP_AUTOREPEAT_SPELL")
        end
        bar:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    elseif ( "USABLE" == bar.settings.BuffOrDebuff ) then
        bar:RegisterEvent("SPELL_UPDATE_USABLE")
    elseif ( "mhand" == bar.settings.Unit or "ohand" == bar.settings.Unit ) then
        bar:RegisterEvent("UNIT_INVENTORY_CHANGED")
    elseif ( bar.unit == "targettarget" ) then
        -- WORKAROUND: PLAYER_TARGET_CHANGED happens immediately, UNIT_TARGET every couple seconds
        bar:RegisterEvent("PLAYER_TARGET_CHANGED")
        bar:RegisterEvent("UNIT_TARGET")
        -- WORKAROUND: Don't get UNIT_AURA for targettarget
        bar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        bar:RegisterEvent("UNIT_AURA")
        if ( bar.unit == "focus" ) then
            bar:RegisterEvent("PLAYER_FOCUS_CHANGED")
        elseif ( bar.unit == "target" ) then
            bar:RegisterEvent("PLAYER_TARGET_CHANGED")
        end
    end
    
    if bar.settings.bDetectExtends or NeedToKnow.is_DK then
        bar:RegisterEvent("UNIT_SPELLCAST_SENT")
    end
    if not bar.settings.blink_ooc then
        bar:RegisterEvent("PLAYER_REGEN_DISABLED")
        bar:RegisterEvent("PLAYER_REGEN_ENABLED")
    end
end

function NeedToKnow.ClearScripts(bar)
    bar:SetScript("OnEvent", nil)
    bar:SetScript("OnUpdate", nil)
    bar:UnregisterEvent("PLAYER_TARGET_CHANGED")
    bar:UnregisterEvent("PLAYER_FOCUS_CHANGED")
    bar:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    bar:UnregisterEvent("PLAYER_TOTEM_UPDATE")
    bar:UnregisterEvent("UNIT_AURA")
    bar:UnregisterEvent("UNIT_INVENTORY_CHANGED")
    bar:UnregisterEvent("UNIT_TARGET")
    bar:UnregisterEvent("UNIT_SPELLCAST_SENT")
    bar:UnregisterEvent("PLAYER_REGEN_DISABLED")
    bar:UnregisterEvent("PLAYER_REGEN_ENABLED")
    bar:UnregisterEvent("START_AUTOREPEAT_SPELL")
    bar:UnregisterEvent("STOP_AUTOREPEAT_SPELL")
    bar:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end

function NeedToKnow.Bar_OnSizeChanged(self)
    if (self.bar1.cur_value) then SetStatusBarValue(self, self.bar1, self.bar1.cur_value) end
    if (self.bar2) then SetStatusBarValue(self, self.bar2, self.bar2.cur_value, self.bar1.cur_value) end
end

function NeedToKnow.Bar_OnEvent(self, event, ...)
    if ( event == "COMBAT_LOG_EVENT_UNFILTERED") then
        local combatEvent = select(2, ...)

        if ( NEEDTOKNOW.AURAEVENTS[combatEvent] ) then
            local guidTarget = select(6, ...)
            if ( guidTarget == UnitGUID(self.unit) ) then
                local idSpell, nameSpell = select(9, ...)
                if (self.auraName:find(idSpell) or
                     self.auraName:find(nameSpell)) 
                then 
                    NeedToKnow.Bar_AuraCheck(self)
                end
            end
        elseif ( combatEvent == "UNIT_DIED" ) and ( select(6, ...) == UnitGUID(self.unit) ) then
            NeedToKnow.Bar_AuraCheck(self)
        end 
    elseif ( event == "PLAYER_TOTEM_UPDATE"  ) or
           ( event == "ACTIONBAR_UPDATE_COOLDOWN" ) or
           ( event == "SPELL_UPDATE_USABLE" ) or
           ( event == "PLAYER_REGEN_ENABLED"  ) or
           ( event == "PLAYER_REGEN_DISABLED"  )
    then
        NeedToKnow.Bar_AuraCheck(self)
    elseif ( event == "UNIT_AURA" ) and ( select(1, ...) == self.unit ) then
        NeedToKnow.Bar_AuraCheck(self)
    elseif ( event == "UNIT_INVENTORY_CHANGED" and select(1, ...) == "player" ) then
        NeedToKnow.Bar_AuraCheck(self)
    elseif ( event == "PLAYER_TARGET_CHANGED" ) or ( event == "PLAYER_FOCUS_CHANGED" ) then
        NeedToKnow.Bar_AuraCheck(self)
    elseif ( event == "UNIT_TARGET" and select(1, ...) == "target" ) then 
        NeedToKnow.Bar_AuraCheck(self)
    elseif ( event == "UNIT_SPELLCAST_SENT" ) then
        local unit, spell = select(1, ...)
        if ( self.settings.bDetectExtends ) then
            if unit == "player" and self.buffName == spell then
                local r = NeedToKnow.last_cast[spell]
                if ( r and r.state == 0 ) then
                    r.state = 1
                    NeedToKnow.nSent = NeedToKnow.nSent + 1
                    NeedToKnow_ExecutiveFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
                end
            end
        end
        if NeedToKnow.is_DK then
            -- TODO: I hate that DKs have to pay this memory cost for every "spell" they ever cast
            if unit == "player" then
                if not NeedToKnow.last_sent then
                    NeedToKnow.last_sent = {}
                end
                NeedToKnow.last_sent[spell] = GetTime()
            end
        end
    elseif ( event == "START_AUTOREPEAT_SPELL" ) then
        self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    elseif ( event == "STOP_AUTOREPEAT_SPELL" ) then
        self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    elseif ( event == "UNIT_SPELLCAST_SUCCEEDED" ) then
        local caster, spell = select(1,...)
        if ( self.settings.bAutoShot and caster == "player" and spell == NEEDTOKNOW.AUTO_SHOT ) then
            local interval = UnitRangedDamage("player")
            self.tAutoShotCD = interval
            self.tAutoShotExpires = GetTime() + interval
            NeedToKnow.Bar_AuraCheck(self)
        end
    end
end

-- AuraCheck calls on this to compute the "text" of the bar
-- It is separated out like this in part to be hooked by other addons
function NeedToKnow.ComputeBarText(buffName, count, extended)
    local text
    if ( count > 1 ) then
        text = buffName.."  ["..count.."]"
    else
        text = buffName
    end
    if ( extended and extended > 1 ) then
        text = text .. string.format(" + %.0fs", extended)
    end
    return text
end

-- Called by NeedToKnow.UpdateVCT, which is called from AuraCheck and possibly 
-- by Bar_Update depending on vct_refresh. In addition to refactoring out some 
-- code from the long AuraCheck, this also provides a convenient hook for other addons
function NeedToKnow.ComputeVCTDuration(bar)
    local vct_duration = 0
    
    local spellToTime = bar.settings.vct_spell
    if ( nil == spellToTime or "" == spellToTime ) then
        spellToTime = bar.buffName
    end
    local _, _, _, _, _, _, castTime = GetSpellInfo(spellToTime)

    if ( castTime ) then
        vct_duration = castTime / 1000
        bar.vct_refresh = true
    else
        bar.vct_refresh = false
    end
    
    if ( bar.settings.vct_extra ) then
        vct_duration =  vct_duration + bar.settings.vct_extra
    end
    return vct_duration
end

function NeedToKnow.UpdateVCT(bar)
    local vct_duration = NeedToKnow.ComputeVCTDuration(bar)

    local dur = bar.fixedDuration or bar.duration
    if ( dur ) then
        vct_width =  (vct_duration * bar:GetWidth()) / dur
        if (vct_width > bar:GetWidth()) then
            vct_width = bar:GetWidth() 
        end
    else
        vct_width = 0
    end

    if ( vct_width > 1 ) then
        bar.vct:SetWidth(vct_width)
        bar.vct:Show()
    else
        bar.vct:Hide()
    end
end

function NeedToKnow.SizeBackground(bar, i_show_icon)
    local background = _G[bar:GetName() .. "Background"]
    local bgWidth = bar:GetWidth() + 2*NeedToKnow_Settings["BarPadding"]
    local y = NeedToKnow_Settings["BarPadding"]
    local x = -y
    background:ClearAllPoints()

    if ( i_show_icon ) then
        local iconExtra = bar:GetHeight() + NeedToKnow_Settings["BarPadding"]
        bgWidth = bgWidth + iconExtra
        x = x - iconExtra
    end
    background:SetWidth(bgWidth)
    background:SetPoint("TOPLEFT", bar, "TOPLEFT", x, y)
end

function NeedToKnow.CreateBar2(bar)
    if ( not bar.bar2 ) then
        local n = bar:GetName() .. "Bar2"
        bar.bar2 = bar:CreateTexture(n, "BORDER")
        bar.bar2:SetPoint("TOPLEFT", bar.bar1, "TOPRIGHT")
        bar.bar2:SetPoint("BOTTOM", bar, "BOTTOM")
        bar.bar2:SetWidth(bar:GetWidth())
    end
end

function NeedToKnow.ConfigureVisibleBar(bar, count, extended)
    local text = ""
    if ( bar.settings.show_icon and bar.iconPath and bar.icon ) then
        bar.icon:SetTexture(bar.iconPath)
        bar.icon:Show()
        NeedToKnow.SizeBackground(bar, true)
    elseif bar.icon then
        bar.icon:Hide()
        NeedToKnow.SizeBackground(bar, false)
    end

    bar.bar1:SetVertexColor(bar.settings.BarColor.r, bar.settings.BarColor.g, bar.settings.BarColor.b)
    bar.bar1:SetAlpha(bar.settings.BarColor.a)
    if ( bar.max_expirationTime and bar.max_expirationTime ~= bar.expirationTime ) then 
        NeedToKnow.CreateBar2(bar)
        bar.bar2:SetTexture(bar.bar1:GetTexture())
        bar.bar2:SetVertexColor(bar.settings.BarColor.r, bar.settings.BarColor.g, bar.settings.BarColor.b)
        bar.bar2:SetAlpha(bar.settings.BarColor.a * 0.5)
        bar.bar2:Show()
    elseif (bar.bar2) then
        bar.bar2:Hide()
    end
    
    local txt = ""
    if ( bar.settings.show_mypip ) then
        txt = txt .. "* "
    end

    if ( bar.settings.show_text ) then
        local n = bar.buffName
        if "" ~= bar.settings.show_text_user then
            local idx=0
            for un in bar.settings.show_text_user:gmatch("([^,]+),*") do
                idx=idx+1
                n = un
                if idx == bar.idxName then 
                    break
                end
            end
            n = strtrim(n)
        end
        local c = count
        if not bar.settings.show_count then
            c = 1
        end
        txt = txt .. NeedToKnow.ComputeBarText(n, c, extended)
    end
    if ( bar.settings.append_cd 
         and (bar.settings.BuffOrDebuff == "CASTCD" 
           or bar.settings.BuffOrDebuff == "BUFFCD") ) 
    then
        txt = txt .. " CD"
    elseif (bar.settings.append_usable and bar.settings.BuffOrDebuff == "USABLE" ) then
        txt = txt .. " Usable"
    end
    bar.text:SetText(txt)
        
    -- Is this an aura with a finite duration?
    local vct_width = 0
    if ( bar.duration > 0 ) then
        -- Configure the main status bar
        local duration = bar.fixedDuration or bar.duration
        bar.max_value = duration

        -- Determine the size of the visual cast bar
        if ( bar.settings.vct_enabled ) then
            NeedToKnow.UpdateVCT(bar)
        end
        
        -- Force an update to get all the bars to the current position (sharing code)
        -- This will call UpdateVCT again, but that seems ok
        bar.nextUpdate = -NEEDTOKNOW.UPDATE_INTERVAL
        NeedToKnow.Bar_OnUpdate(bar, 0)

        bar.time:Show()
    else
        -- Hide the time text and spark for auras with "infinite" duration
        bar.max_value = 1
        SetStatusBarValue(bar,bar.bar1,1)
        if bar.bar2 then SetStatusBarValue(bar,bar.bar2,1) end

        bar.time:Hide()
        bar.spark:Hide()

        if ( bar.vct ) then
            bar.vct:Hide()
        end
    end
end

function NeedToKnow.ConfigureBlinkingBar(bar)
    local settings = bar.settings
    if ( not bar.blink ) then
        bar.blink=true
        bar.blink_phase=1
        bar.bar1:SetVertexColor(settings.MissingBlink.r, settings.MissingBlink.g, settings.MissingBlink.b)
        bar.bar1:SetAlpha(settings.MissingBlink.a)
    end
    bar.text:SetText(settings.blink_label)
    bar.time:Hide()
    bar.spark:Hide()
    bar.max_value = 1
    SetStatusBarValue(bar,bar.bar1,1)
    
    if ( bar.icon ) then
        bar.icon:Hide()
        NeedToKnow.SizeBackground(bar, false)
    end
    if ( bar.bar2 ) then
        bar.bar2:Hide()
    end
end

function NeedToKnow.GetUtilityTooltips()
    if ( not NeedToKnow_Tooltip1 ) then
        for idxTip = 1,2 do
            local ttname = "NeedToKnow_Tooltip"..idxTip
            local tt = CreateFrame("GameTooltip", ttname)
            tt:SetOwner(UIParent, "ANCHOR_NONE")
            tt.left = {}
            -- Most of the tooltip lines share the same text widget,
            -- But we need to query the third one for cooldown info
            tt.right1 = tt:CreateFontString()
            tt.right1:SetFontObject(GameFontNormal)
            tt.right3 = tt:CreateFontString()
            tt.right3:SetFontObject(GameFontNormal)
            for i = 1, 30 do
                tt.left[i] = tt:CreateFontString()
                tt.left[i]:SetFontObject(GameFontNormal)
                if i ~= 3 then
                    tt:AddFontStrings(tt.left[i], tt.right1)
                else
                    tt:AddFontStrings(tt.left[i], tt.right3)
                end
            end 
         end
    end
    local tt1,tt2 = NeedToKnow_Tooltip1, NeedToKnow_Tooltip2
    
    tt1:ClearLines()
    tt2:ClearLines()
    return tt1,tt2
end

function NeedToKnow.DetermineTempEnchantFromTooltip(i_invID)
    local tt1,tt2 = NeedToKnow.GetUtilityTooltips()
    
    tt1:SetInventoryItem("player", i_invID)
    local n,h = tt1:GetItem()

    tt2:SetHyperlink(h)
    
    -- Look for green lines present in tt1 that are missing from tt2
    local nLines1, nLines2 = tt1:NumLines(), tt2:NumLines()
    local i1, i2 = 1,1
    while ( i1 <= nLines1 ) do
        local txt1 = tt1.left[i1]
        if ( txt1:GetTextColor() ~= 0 ) then
            i1 = i1 + 1
        elseif ( i2 <= nLines2 ) then
            local txt2 = tt2.left[i2]
            if ( txt2:GetTextColor() ~= 0 ) then
                i2 = i2 + 1
            elseif (txt1:GetText() == txt2:GetText()) then
                i1 = i1 + 1
                i2 = i2 + 1
            else
                break
            end
        else
            break
        end
    end
    if ( i1 <= nLines1 ) then
        local line = tt1.left[i1]:GetText()
        local paren = line:find("[(]")
        if ( paren ) then
            line = line:sub(1,paren-2)
        end
        return line
    end    
end



-- Looks at the tooltip for the given spell to see if a cooldown 
-- is listed with a duration in seconds.  Longer cooldowns don't
-- need this logic, so we don't need to do unit conversion
function NeedToKnow.DetermineShortCooldownFromTooltip(spell)
    if not NeedToKnow.short_cds then
        NeedToKnow.short_cds = {}
    end
    if not NeedToKnow.short_cds[spell] then
        -- Figure out what a cooldown in seconds should look like
        local ref = SecondsToTime(10):lower()
        local unit_ref = ref:match("10 (.+)")

        -- Get the number and unit of the cooldown from the tooltip
        local tt1 = NeedToKnow.GetUtilityTooltips()
        tt1:SetHyperlink( GetSpellLink(spell) )
        local cd = tt1.right3:GetText()
        local n_cd, unit_cd 
        if cd then 
            cd = cd:lower()
            n_cd, unit_cd = cd:match("(%d+) (.+) ")
        end  

        -- unit_ref will be "|4sec:sec;" in english, so do a find rather than a ==
        if not n_cd then 
            -- If we couldn't parse the tooltip, assume there's no cd
            NeedToKnow.short_cds[spell] = 0
        elseif unit_ref:find(unit_cd) then
            NeedToKnow.short_cds[spell] = tonumber(n_cd)
        else
            -- Not a short cooldown.  Record it as a minute
            NeedToKnow.short_cds[spell] = 60
        end
    end

    return NeedToKnow.short_cds[spell]
end


-- Called whenever the state of auras on the bar's unit may have changed
function NeedToKnow.Bar_AuraCheck(bar)
    local buffName, count, duration, expirationTime, caster, iconPath
    local idxName = 0
    local all_stacks
    local settings = bar.settings
    local bUnitExists, isWeapon
    if ( settings.BuffOrDebuff == "CASTCD" or
         settings.BuffOrDebuff == "BUFFCD" or
         settings.BuffOrDebuff == "USABLE" or
         settings.BuffOrDebuff == "TOTEM" ) 
    then
        bUnitExists = true
    else
        if ( "mhand" == settings.Unit or 
             "ohand" == settings.Unit ) 
        then
            isWeapon = true
            bUnitExists = true
        else
            bUnitExists = UnitExists(bar.unit)
        end
    end

    -- Determine if the bar should be showing anything
    if ( bUnitExists ) then                
             
        local mainHandEnchantName, mainHandEnchantRank, offHandEnchantName, offHandEnchantRank
        local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges
        if ( isWeapon ) then
            hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
            if ( hasMainHandEnchant and "mhand" == settings.Unit ) then
               mainHandEnchantName, mainHandEnchantRank = NeedToKnow.DetermineTempEnchantFromTooltip(16)
            end
            if ( hasOffHandEnchant and "ohand" == settings.Unit ) then
               offHandEnchantName, offHandEnchantRank = NeedToKnow.DetermineTempEnchantFromTooltip(17)
            end
        end

        for barSpell in bar.auraName:gmatch("([^,]+),*") do
            idxName = idxName + 1
            local barSpell = strtrim(barSpell)
            local filter = settings.BuffOrDebuff
            local _, nDigits = barSpell:find("^%d+")
            local isSpellID = ( nDigits == barSpell:len() )

            if ( settings.BuffOrDebuff == "TOTEM" ) then
                local spellName, spellRank, spellIconPath
                if ( isSpellID ) then
                    spellName, spellRank, spellIconPath = GetSpellInfo(barSpell)
                end
                for iSlot=1, 4 do
                    local haveTotem, totemName, startTime, totemDuration, totemIcon = GetTotemInfo(iSlot)
                    local sComp = barSpell
                    if isSpellID then sComp = spellName end
                    if ( totemName and totemName:find(sComp) ) then
                        -- WORKAROUND: The startTime reported here is both cast to an int and off by 
                        -- a latency meaning it can be significantly low.  So we cache the GetTime 
                        -- that the totem actually appeared, so long as GetTime is reasonably close to 
                        -- startTime (since the totems may have been out for awhile before this runs.)
                        if ( not NeedToKnow.totem_drops[iSlot] or 
                             NeedToKnow.totem_drops[iSlot] < startTime ) 
                        then
                            local precise = GetTime()
                            if ( precise - startTime > 1 ) then
                                precise = startTime + 1
                            end
                            NeedToKnow.totem_drops[iSlot] = precise
                        end
                        buffName = totemName
                        duration = totemDuration
                        expirationTime = NeedToKnow.totem_drops[iSlot] + duration
                        iconPath = totemIcon
                        count = 1
                        caster = "player"
                        break
                    end
                end
            elseif isWeapon then
                if ( "mhand" == settings.Unit and mainHandEnchantName and mainHandEnchantName:find(barSpell) ) then
                    buffName = mainHandEnchantName
                    count = mainHandCharges
                    if ( count < 1 ) then count = 1 end
                    duration = 1800
                    expirationTime = GetTime() + mainHandExpiration/1000
                    caster = "player"
                elseif ( "ohand" == settings.Unit and offHandEnchantName and offHandEnchantName:find(barSpell) ) then 
                    buffName = offHandEnchantName
                    count = offHandCharges
                    if ( not count or count < 1 ) then count = 1 end
                    duration = 1800
                    expirationTime = GetTime() + offHandExpiration/1000
                    caster = "player"
                end
            elseif settings.BuffOrDebuff == "CASTCD" then
                local spellName=barSpell, spellRank, spellIconPath
                local spellPower=0
                if isSpellID or NeedToKnow.is_DK then
                    spellName, spellRank, spellIconPath, _, _, spellPower = GetSpellInfo(barSpell)
                end
                if ( settings.bAutoShot and (barSpell == "Auto Shot" or barSpell == NEEDTOKNOW.AUTO_SHOT or barSpell == "75") ) then
                    local tNow = GetTime()
                    if ( bar.tAutoShotExpires and bar.tAutoShotExpires > tNow ) then
                        buffName = NEEDTOKNOW.AUTO_SHOT
                        count = 1
                        duration = bar.tAutoShotCD
                        expirationTime = bar.tAutoShotExpires
                        caster = "player"
                    end
                else
                    local tNow = GetTime()
                    local start, cd_len, should_cooldown = GetSpellCooldown(barSpell)
                    local is_spell = true
                    if not start then
                        start, cd_len = GetItemCooldown(barSpell)
                        is_spell = false
                    end

                    if is_spell and start and start > 0 then
                        if 0 == should_cooldown then 
                            -- Filter out conditions like Stealth while stealthed
                            start = nil
                        elseif spellPower == 5 then -- Rune
                            -- Filter out rune cooldown artificially extending the cd
                            if cd_len <= 10 then
                                if bar.expirationTime and tNow < bar.expirationTime then
                                    -- We've already seen the correct CD for this; keep using it
                                    start = bar.expirationTime - bar.duration
                                    cd_len = bar.duration
                                elseif NeedToKnow.last_sent and NeedToKnow.last_sent[barSpell] and NeedToKnow.last_sent[barSpell] > (tNow - 1.5) then
                                    -- We think the spell was just cast, and a CD just started but it's short.
                                    -- Look at the tooltip to tell what the correct CD should be. If it's supposed
                                    -- to be short (Ghoul Frenzy, Howling Blast), then start a CD bar
                                    cd_len = NeedToKnow.DetermineShortCooldownFromTooltip(barSpell)
                                    if cd_len == 0 or cd_len > 10 then
                                        start = nil
                                    end
                                else
                                    start = nil
                                end
                            end
                        end
                    end

                    -- filter out the GCD, we only care about actual spell CDs
                    if cd_len <= 1.5 then
                        if not bar.expirationTime or bar.expirationTime < tNow then
                            start = nil
                        else
                            start = bar.expirationTime - bar.duration
                            cd_len = bar.duration
                        end
                    end

                    if start and cd_len then
                        local tEnd = start + cd_len
                        if ( tEnd > tNow + 0.1 ) then
                            if is_spell then
                                buffName, _, iconPath = GetSpellInfo(barSpell)
                            else
                                buffName, _, _, _, _, _, _, _, _, iconPath = GetItemInfo(barSpell)
                            end
                            if not buffName then buffName = barSpell end

                            count = 1
                            duration = cd_len
                            expirationTime = tEnd
                            cast = "player"
                        end
                    end
                end
            elseif settings.BuffOrDebuff == "USABLE" then
                local _, nDigits = barSpell:find("^%d+")
                local isSpellID = ( nDigits == barSpell:len() )
                local key = barSpell
                if ( isSpellID ) then key = tonumber(barSpell) end
                if ( not key ) then key = "" end
                local spellName
                spellName, _, iconPath = GetSpellInfo(key)
                if ( spellName ) then
                    local isUsable, notEnoughMana = IsUsableSpell(spellName)
                    if (isUsable or notEnoughMana) then
                        duration = settings.usable_duration
                        buffName = spellName
                        count = 1
                        local tNow = GetTime()
                        if ( not bar.expirationTime or 
                             (bar.expirationTime > 0 and bar.expirationTime < tNow - 0.01) ) 
                        then
                            duration = settings.usable_duration
                            expirationTime = tNow + duration
                        else
                            duration = bar.duration
                            expirationTime = bar.expirationTime
                        end
                    end
                end
            else
                if settings.OnlyMine then
                    filter = filter .. "|PLAYER"
                end
                
                if isSpellID then
                    -- WORKAROUND: The second parameter to UnitAura can't be a spellid, so I have 
                    --             to walk them all
                    local barID = tonumber(barSpell)
                    local j = 1
                    while true do
                        local buffRank, spellID
                        buffName, buffRank, iconPath, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura(bar.unit, j, filter)
                        if (not buffName) then
                            break
                        end

                        if (spellID == barID) then 
                            break
                        else 
                            duration = nil
                        end
                        j=j+1
                    end
                else
                    buffName, _ , iconPath, count, _, duration, expirationTime, caster = UnitAura(bar.unit, barSpell, nil, filter)
                end
            end
            
            if ( duration ) then
                if not count or count < 1 then
                    count = 1
                end

                if ( settings.show_all_stacks ) then
                    if ( not all_stacks ) then
                        all_stacks = 
                        {
                          min = 
                          {
                            buffName = "", 
                            duration = 0, 
                            expirationTime = 0, 
                            iconPath = "",
                            caster = ""
                          },
                          max = 
                          {
                            duration = 0, 
                            expirationTime = 0, 
                          },
                          total = 0
                        }
                    end

                    all_stacks.total = all_stacks.total + count
                    if ( 0 == all_stacks.min.expirationTime or all_stacks.min.expirationTime > expirationTime ) then
                        all_stacks.min.idxName = idxName
                        all_stacks.min.buffName = buffName
                        all_stacks.min.caster = caster
                        all_stacks.min.duration = duration
                        all_stacks.min.expirationTime = expirationTime
                        all_stacks.min.iconPath = iconPath
                    end
                    if ( 0 == all_stacks.max.expirationTime or all_stacks.max.expirationTime < expirationTime ) then
                        all_stacks.max.duration = duration
                        all_stacks.max.expirationTime = expirationTime
                    end 
                else
                    break 
                end
            end
        end
    end
    
    if ( all_stacks ) then
        idxName = all_stacks.min.idxName
        buffName = all_stacks.min.buffName
        caster = all_stacks.min.caster
        duration = all_stacks.max.duration
        expirationTime = all_stacks.min.expirationTime
        iconPath = all_stacks.min.iconPath
        count = all_stacks.total
    end
    
    -- There is an aura this bar is watching! Set it up
    duration = tonumber(duration)
    if ( settings.BuffOrDebuff == "BUFFCD" ) then
        local tNow = GetTime()
        count = 1 -- Seeing the charges on the CD bar violated least surprise for me
        if ( duration ) then
            local tStart = expirationTime - duration
            duration = tonumber(settings.buffcd_duration)
            expirationTime = tStart + duration
            if ( expirationTime <= tNow ) then
                duration = nil
            end
        elseif ( bar.expirationTime and bar.expirationTime > tNow + 0.1 ) then
            duration = bar.duration
            expirationTime = bar.expirationTime
            buffName = bar.buffName
            iconPath = bar.iconPath        
        end
    end
    
    if ( duration ) then
        -- Handle duration increases
        local extended
        if (settings.bDetectExtends) then
            local curStart = expirationTime - duration
            local guidTarget = UnitGUID(bar.unit)
            if ( not NeedToKnow.last_cast[buffName] ) then
                NeedToKnow.last_cast[buffName] = { state=0 }
            end
            local r = NeedToKnow.last_cast[buffName] 
            
            if ( not r[guidTarget] ) then
                r[guidTarget] = { time=curStart, dur=duration }
            elseif ( r[guidTarget].dur == 0 ) then
                r[guidTarget].dur = duration
            else
                local rStart = r[guidTarget]
                extended = expirationTime - rStart.time - rStart.dur
                if ( extended > 1 ) then
                    duration = rStart.dur 
                end
            end
        end

        --bar.duration = tonumber(bar.fixedDuration) or duration
        bar.duration = duration

        bar.expirationTime = expirationTime
        bar.idxName = idxName
        bar.buffName = buffName
        bar.iconPath = iconPath
        if ( all_stacks and all_stacks.max.expirationTime ~= expirationTime ) then
            bar.max_expirationTime = all_stacks.max.expirationTime
        else
            bar.max_expirationTime = nil
        end

        -- Mark the bar as not blinking before calling ConfigureVisibleBar, 
        -- since it calls OnUpdate which checks bar.blink
        bar.blink=false
        NeedToKnow.ConfigureVisibleBar(bar, count, extended)
        bar:Show()
    else
        if (settings.bDetectExtends and bar.buffName) then
            if ( NeedToKnow.last_cast[bar.buffName] ) then
                local guidTarget = UnitGUID(bar.unit)
                if guidTarget then
                    local r = NeedToKnow.last_cast[bar.buffName]
                    r[guidTarget] = nil
                end
            end
        end
        bar.buffName = nil
        bar.duration = nil
        bar.expirationTime = nil
        
        local bBlink = false
        if settings.blink_enabled and settings.MissingBlink.a > 0 and bUnitExists and not UnitIsDead(bar.unit) then
            bBlink = (bar.unit == "player") or
                     (settings.BuffOrDebuff == "HELPFUL") == (nil ~= UnitIsFriend("player", bar.unit))
        end
        if ( bBlink and not settings.blink_ooc ) then
            if not UnitAffectingCombat("player") then
                bBlink = false
            end
        end
        if ( bBlink and settings.blink_boss ) then
            local lvl = UnitLevel(bar.unit)
            if not lvl or lvl > 0 then
                bBlink = false
            end
        end
        if ( bBlink ) then
            NeedToKnow.ConfigureBlinkingBar(bar)
            bar:Show()
        else    
            bar.blink=false
            bar:Hide()
        end
    end
end

function NeedToKnow.Fmt_SingleUnit(i_fSeconds)
    return string.format(SecondsToTimeAbbrev(i_fSeconds))
end

function NeedToKnow.Fmt_TwoUnits(i_fSeconds)
  if ( i_fSeconds < 6040 ) then
      local nMinutes, nSeconds
      nMinutes = floor(i_fSeconds / 60)
      nSeconds = floor(i_fSeconds - nMinutes*60)
      return string.format("%02d:%02d", nMinutes, nSeconds)
  else
      string.format(SecondsToTimeAbbrev(i_fSeconds))
  end
end

function NeedToKnow.Fmt_Float(i_fSeconds)
  return string.format("%0.1f", i_fSeconds)
end

function NeedToKnow.Bar_OnUpdate(self, elapsed)
    local now = GetTime()
    if ( now > self.nextUpdate ) then
        self.nextUpdate = now + NEEDTOKNOW.UPDATE_INTERVAL

        if ( self.blink ) then
            self.blink_phase = self.blink_phase + NEEDTOKNOW.UPDATE_INTERVAL
            if ( self.blink_phase >= 2 ) then
                self.blink_phase = 0
            end
            local a = self.blink_phase
            if ( a > 1 ) then
                a = 2 - a
            end

            self.bar1:SetVertexColor(self.settings.MissingBlink.r, self.settings.MissingBlink.g, self.settings.MissingBlink.b)
            self.bar1:SetAlpha(self.settings.MissingBlink.a * a)
            return
        end
        
        -- WORKAROUND: Although the existence of the enchant is correct at UNIT_INVENTORY_CHANGED
        -- the expiry time is not yet correct.  So we update the expiration every update :(
        local origUnit = self.settings.Unit
        if ( origUnit == "mhand" ) then
            -- The expiry time doesn't update right away, so we have to poll it
            local mhEnchant, mhExpire = GetWeaponEnchantInfo()
            if ( mhExpire ) then
                self.expirationTime = GetTime() + mhExpire/1000
            end
        elseif ( origUnit == "ohand" ) then
            local _, _, _, ohEnchant, ohExpire = GetWeaponEnchantInfo()
            if ( ohExpire ) then
                self.expirationTime = GetTime() + ohExpire/1000
            end
        end
        
        if ( self.duration > 0 ) then
            local duration = self.fixedDuration or self.duration
            local bar1_timeLeft = self.expirationTime - GetTime()
            if ( bar1_timeLeft < 0 ) then
                if ( self.settings.BuffOrDebuff == "CASTCD" or
                     self.settings.BuffOrDebuff == "BUFFCD" )
                then
                    NeedToKnow.Bar_AuraCheck(self)
                    return
                end
                bar1_timeLeft = 0
            end
            SetStatusBarValue(self, self.bar1, bar1_timeLeft);
            if ( self.settings.show_time ) then
                local fn = NeedToKnow[self.settings.TimeFormat]
                local oldText = self.time:GetText()
                local newText
                if ( fn ) then
                    newText = fn(bar1_timeLeft)
                else 
                    newText = string.format(SecondsToTimeAbbrev(bar1_timeLeft))
                end
                
                if ( newText ~= oldText ) then
                    self.time:SetText(newText)
                end
            else
                self.time:SetText("")
            end
            
            if ( self.settings.show_spark and bar1_timeLeft <= duration ) then
                self.spark:SetPoint("CENTER", self, "LEFT", self:GetWidth()*bar1_timeLeft/duration, 0)
                self.spark:Show()
            else
                self.spark:Hide()
            end
            
            if ( self.max_expirationTime ) then
                local bar2_timeLeft = self.max_expirationTime - GetTime()
                SetStatusBarValue(self, self.bar2, bar2_timeLeft, bar1_timeLeft)
            end
            
            if ( self.vct_refresh ) then
                NeedToKnow.UpdateVCT(self)
            end
        end
    end
end 
