--[[################### FFHelp.lua #####################
    # Follow Felankor
    # By Felankor
    #
    # IMPORTANT: I do not mind people looking at my code
    # to learn from it. If you use any parts of my code
    # please give me credit in your comments. I will
    # do the same if I ever use any code from another
    # AddOn. Thanks.
    ###################################################]]--

local FFSlashHelpSelected = 0;
local FFWhisperHelpSelected = nil;
    
function FF_HelpDialog_OnShow()

   
end

function FFSlashScrollBar_Update()
  local SlashLine = nil; -- 1 through 8 of our window to scroll
  local SlashLinePlusOffset = nil; -- an index into our data calculated from the scroll offset
  local FFSlashHighlighted = false;
    
    FauxScrollFrame_Update(FFSlashScrollBar,table.getn(FFSLASH_HELP_LIST_COMMANDS_TABLE),8,16);
    
    for SlashLine=1,8 do
        SlashLinePlusOffset = SlashLine + FauxScrollFrame_GetOffset(FFSlashScrollBar);
        
        if SlashLinePlusOffset <= table.getn(FFSLASH_HELP_LIST_COMMANDS_TABLE) then
            getglobal("FFSlashEntry"..SlashLine.."ButtonTextName"):SetText(FF_ColourText(FFSLASH_HELP_LIST_COMMANDS_TABLE[SlashLinePlusOffset], "blue"));
            
            if (FFSlashHelpSelected == SlashLinePlusOffset) then
                --Show selection highlight
                FFHelp_ShowHighlight("FFSlashEntry"..SlashLine);
                FFSlashHighlighted = true;
            elseif (FFSlashHighlighted == false) then
                --Hide selection highlight
                FFHelp_HideSlashHighlight();
            end
            
            getglobal("FFSlashEntry"..SlashLine):Show();
        else
            getglobal("FFSlashEntry"..SlashLine):Hide();
        end
        
    end
  
end

function FFWhisperScrollBar_Update()
  local WhispLine = nil; -- 1 through 8 of our window to scroll
  local WhispLinePlusOffset = nil; -- an index into our data calculated from the scroll offset
  local FFWhisperHighlighted = false;
    
    FauxScrollFrame_Update(FFWhisperScrollBar,table.getn(FFWHISP_COMMAND_LIST),8,16);
    
    for WhispLine=1,8 do
        WhispLinePlusOffset = WhispLine + FauxScrollFrame_GetOffset(FFWhisperScrollBar);
        
        if WhispLinePlusOffset <= table.getn(FFWHISP_COMMAND_LIST) then
            getglobal("FFWhispEntry"..WhispLine.."ButtonTextName"):SetText(FF_ColourText(FFWHISP_COMMAND_LIST[WhispLinePlusOffset], "blue"));
            
            if (FFWhisperHelpSelected == WhispLinePlusOffset) then
                --Show selection highlight
                FFHelp_ShowHighlight("FFWhispEntry"..WhispLine);
                FFWhisperHighlighted = true;
            elseif (FFWhisperHighlighted == false) then
                --Hide selection highlight
                FFHelp_HideWhisperHighlight();
            end
            
            getglobal("FFWhispEntry"..WhispLine):Show();
        else
            getglobal("FFWhispEntry"..WhispLine):Hide();
        end
        
    end
    
end

function FFHelp_Selected(ButtonName)

    if (string.sub(ButtonName, 1, string.len("FFSlashEntry")) == "FFSlashEntry") then
        if (getglobal(ButtonName.."ButtonTextName"):GetText() > "") then --if the button from the list that was clicked has text on it
            FFSlashHelpSelected = (FauxScrollFrame_GetOffset(FFSlashScrollBar) + string.sub(ButtonName, (string.len("FFSlashEntry") + 1), string.len(ButtonName))); --Get the number of the button
            FF_lblSlashDescriptionLabel:SetText(FFHELPDIALOG_SLASH_COMMAND_HELP[FFSlashHelpSelected]);
            FFHelp_ShowHighlight(ButtonName);
        else
            FFHelp_DeselectButton(); --Deselect the selected button
        end
        
    elseif(string.sub(ButtonName, 1, string.len("FFWhispEntry")) == "FFWhispEntry") then
        if (getglobal(ButtonName.."ButtonTextName"):GetText() > "") then --if the button from the list that was clicked has text on it
            FFWhisperHelpSelected = (FauxScrollFrame_GetOffset(FFWhisperScrollBar) + string.sub(ButtonName, (string.len("FFWhispEntry") + 1), string.len(ButtonName))); --Get the number of the button
            FF_lblWhisperDescriptionLabel:SetText(FFHELPDIALOG_WHISPER_HELP[FFWhisperHelpSelected]);
            
            FFHelp_ShowHighlight(ButtonName);
        else
            FFHelp_DeselectButton(); --Deselect the selected player
        end
        
    end
    
end

function FFHelp_DeselectButton()

    if (string.sub(ButtonName, 1, string.len("FFSlashEntry")) == "FFSlashEntry") then
        FFSlashHelpSelected = nil;--Deselect the selected player
    elseif (string.sub(ButtonName, 1, string.len("FFWhispEntry")) == "FFWhispEntry") then
        FFWhisperHelpSelected = nil;--Deselect the selected player
    end
    
    FFHelp_HideHighlight(); --Hide the highlight
end

function FFHelp_ShowHighlight(ButtonName)
    --Highlight the selected command
    if (string.sub(ButtonName, 1, string.len("FFSlashEntry")) == "FFSlashEntry") then
        FFSlashHighlight:ClearAllPoints();
        FFSlashHighlight:SetPoint("TOPLEFT", ButtonName, "TOPLEFT", 0, 0);
        FFSlashHighlight:Show();
    elseif (string.sub(ButtonName, 1, string.len("FFWhispEntry")) == "FFWhispEntry") then
        FFWhisperHighlight:ClearAllPoints();
        FFWhisperHighlight:SetPoint("TOPLEFT", ButtonName, "TOPLEFT", 0, 0);
        FFWhisperHighlight:Show();
    end
    
end

function FFHelp_HideSlashHighlight()

    FFSlashHighlight:Hide(); --Hide the highlight
    
end

function FFHelp_HideWhisperHighlight()

    FFWhisperHighlight:Hide(); --Hide the highlight

end