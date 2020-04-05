--[[############## FFMinimapButton.lua #################
    # Follow Felankor
    # By Felankor
    #
    # IMPORTANT: I do not mind people looking at my code
    # to learn from it. If you use any parts of my code
    # please give me credit in your comments. I will
    # do the same if I ever use any code from another
    # AddOn. Thanks.
    ###################################################]]--

function FF_UpdateMinimapButton()

    if (FF_Options["Enabled"] == 0) then
        FF_MinimapButtonIcon:SetTexture("Interface\\AddOns\\FollowFelankor\\Images\\FF_MinimapDisabled");
    elseif (FF_Options["Enabled"] == 1) then
        
        if (FF_SemiEnabled == 1) then
            FF_MinimapButtonIcon:SetTexture("Interface\\AddOns\\FollowFelankor\\Images\\FF_MinimapSemiEnabled");
        else
            FF_MinimapButtonIcon:SetTexture("Interface\\AddOns\\FollowFelankor\\Images\\FF_MinimapEnabled");
        end
        
    end
    
    if (FF_Options["ShowMinimapButton"] == 0) then --If the minimap button is set to hide
        FF_MinimapButtonFrame:Hide();
    else
        FF_MinimapButtonFrame:Show();
    end
    
    FF_MinimapButtonFrame:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", (54 - (78 * cos(FF_Options["MinimapPosition"]))), (78 * sin(FF_Options["MinimapPosition"])) - 55);

end

function FF_MinimapButtonMoving()
    local MouseX, MouseY = GetCursorPosition();
    local MinX, MinY = Minimap:GetLeft(), Minimap:GetBottom();

    MouseX = MinX-MouseX/UIParent:GetScale()+70;
    MouseY = MouseY/UIParent:GetScale()-MinY-70;

    FF_Options["MinimapPosition"] = (math.deg(math.atan2(MouseY, MouseX)));
    FF_UpdateStatus();
end