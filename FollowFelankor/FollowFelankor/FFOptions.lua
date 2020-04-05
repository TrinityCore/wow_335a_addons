--[[################# FFOptions.lua ####################
    # Follow Felankor
    # A World of Warcraft UI AddOn
    # By Felankor
    #
    # IMPORTANT: I do not mind people looking at my code
    # to learn from it. If you use any parts of my code
    # please give me credit in your comments. I will
    # do the same if I ever use any code from another
    # AddOn. Thanks.
    ###################################################]]--
    
function FFOptions_OnLoad(panel)

    --Add the FFOptions frame to the WoW options interface
    panel.name = FFMSG_ADDON_NAME;
    panel.okay = function (self) FFOptions_OK_OnClick(); end;
    panel.cancel = function (self) FFOptions_Cancel_OnClick(); end;
    panel.default = function (self) FFOptions_Defaults_OnClick(self); end;
    InterfaceOptions_AddCategory(panel);
    
end

function FFOptionsAnnouncements_OnLoad(panel)

    --Add FFOptionsAnnouncements frame to the WoW options interface
    panel.name = FFOPTIONS_ANNOUNCEMENTS_PANEL;
    panel.parent = FFMSG_ADDON_NAME;
    panel.okay = function (self) FFOptions_OK_OnClick(); end;
    panel.cancel = function (self) FFOptions_Cancel_OnClick(); end;
    panel.default = function (self) FFOptionsAnnouncements_Defaults_OnClick(self); end;
    InterfaceOptions_AddCategory(panel);
    
end

function FFOptions_Load()

    --Check/Uncheck the check boxes to display the current settings
    
    --FFOptions Panel
    FFOptions_Check_Enable:SetChecked(FF_Options['Enabled']);
    FFOptions_Check_AIR:SetChecked(FF_Options['AllowInviteRequests']);
    FFOptions_Check_AAP:SetChecked(FF_Options['AllowAutoAcceptParty']);
    FFOptions_Check_AAR:SetChecked(FF_Options['AllowAcceptResurrect']);
    FFOptions_Check_PFWB:SetChecked(FF_Options['PreventFollowWhenBusy']);
    FFOptions_Check_PSI:SetChecked(FF_Options['ShowPartyStatusIcons']);
    FFOptions_Check_AEC:SetChecked(FF_Options['AllowEmoteCommand']);
    FFOptions_EnableLogging:SetChecked(FF_Options['EnableLogging']);
    FFOptions_Check_EMMB:SetChecked(FF_Options['ShowMinimapButton']);
    
    --FFOptionsAnnouncements Panel
    FFOptionsAnnouncements_Check_AA:SetChecked(FF_Options_Announcements['AnnounceAll']);
    FFOptionsAnnouncements_Check_AFStart:SetChecked(FF_Options_Announcements['AnnounceFollowStart']);
    FFOptionsAnnouncements_Check_AFStop:SetChecked(FF_Options_Announcements['AnnounceFollowStop']);
    FFOptionsAnnouncements_Check_AAFK:SetChecked(FF_Options_Announcements['AnnounceAFK']);
    FFOptionsAnnouncements_Check_AR:SetChecked(FF_Options_Announcements['AnnounceResurrection']);
    FFOptionsAnnouncements_Check_AAI:SetChecked(FF_Options_Announcements['AnnounceAutoInvite']);
    FFOptionsAnnouncements_Check_AAIR:SetChecked(FF_Options_Announcements['AnnounceRequestInviteForFriend']);
    FFOptionsAnnouncements_Check_SCN:SetChecked(FF_Options_Announcements['StatusCheckNotify']);
    
    FF_ToggleAnnounceSubMenus();
    
end

function FF_ToggleAnnounceSubMenus()

    --If Announce All check box is checked, disable individual announcement check boxes and vice versa

    if (FFOptionsAnnouncements_Check_AA:GetChecked() == 1) then
        FFOptionsAnnouncements_Check_AFStart:Enable();
        FFOptionsAnnouncements_Check_AFStop:Enable();
        FFOptionsAnnouncements_Check_AAFK:Enable();
        FFOptionsAnnouncements_Check_AR:Enable();
        FFOptionsAnnouncements_Check_AAI:Enable();
        FFOptionsAnnouncements_Check_AAIR:Enable();
        FFOptionsAnnouncements_Check_SCN:Enable();
    else
        FFOptionsAnnouncements_Check_AFStart:Disable();
        FFOptionsAnnouncements_Check_AFStop:Disable();
        FFOptionsAnnouncements_Check_AAFK:Disable();
        FFOptionsAnnouncements_Check_AR:Disable();
        FFOptionsAnnouncements_Check_AAI:Disable();
        FFOptionsAnnouncements_Check_AAIR:Disable();
        FFOptionsAnnouncements_Check_SCN:Disable();
    end

end
    
function FFOptions_OK_OnClick(panel)

    --Save the new settings
    --FFOptions Panel
    FF_Options['Enabled'] = FFGetChecked(FFOptions_Check_Enable);
    FF_Options['AllowInviteRequests'] = FFGetChecked(FFOptions_Check_AIR);
    FF_Options['AllowAutoAcceptParty'] = FFGetChecked(FFOptions_Check_AAP);
    FF_Options['AllowAcceptResurrect'] = FFGetChecked(FFOptions_Check_AAR);
    FF_Options['PreventFollowWhenBusy'] = FFGetChecked(FFOptions_Check_PFWB);
    FF_Options['ShowPartyStatusIcons'] = FFGetChecked(FFOptions_Check_PSI);
    FF_Options['AllowEmoteCommand'] = FFGetChecked(FFOptions_Check_AEC);
    FF_Options['EnableLogging'] = FFGetChecked(FFOptions_EnableLogging);
    FF_Options['ShowMinimapButton'] = FFGetChecked(FFOptions_Check_EMMB);
    
    --FFOptionsAnnouncement Panel
    FF_Options_Announcements['AnnounceAll'] = FFGetChecked(FFOptionsAnnouncements_Check_AA);
    FF_Options_Announcements['AnnounceFollowStart'] = FFGetChecked(FFOptionsAnnouncements_Check_AFStart);
    FF_Options_Announcements['AnnounceFollowStop'] = FFGetChecked(FFOptionsAnnouncements_Check_AFStop);
    FF_Options_Announcements['AnnounceAFK'] = FFGetChecked(FFOptionsAnnouncements_Check_AAFK);
    FF_Options_Announcements['AnnounceResurrection'] = FFGetChecked(FFOptionsAnnouncements_Check_AR);
    FF_Options_Announcements['AnnounceAutoInvite'] = FFGetChecked(FFOptionsAnnouncements_Check_AAI);
    FF_Options_Announcements['AnnounceRequestInviteForFriend'] = FFGetChecked(FFOptionsAnnouncements_Check_AAIR);
    FF_Options_Announcements['StatusCheckNotify'] = FFGetChecked(FFOptionsAnnouncements_Check_SCN);

    FF_UpdateStatus();
    
end

function FFOptions_Cancel_OnClick(panel)
    FFOptions_Load(); --Refresh the panel to show the original settings
end

function FFOptions_Defaults_OnClick(panel)

    --Restore default options

    for key, value in pairs(FF_Options_Defaults) do
    
        if (FF_Options[key]) then
            FF_Options[key] = value;
        end
        
    end
    
    FFOptions_Load(); --Refresh the panel to show the new settings
    FF_UpdateStatus();

end

function FFOptionsAnnouncements_Defaults_OnClick(panel)

    --Restore default options

    for key, value in pairs(FF_Options_Announcements_Defaults) do
    
        if (FF_Options_Announcements[key]) then
            FF_Options_Announcements[key] = value;
        end
        
    end
    
    FFOptionsAnnouncements_OnShow(panel); --Refresh the panel

end

function FFGetChecked(CheckBox)

    if CheckBox:GetChecked() == 1 then
        return 1;
    else
        return 0;
    end

end