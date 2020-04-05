--[[################# FFBanList.lua ####################
    # Follow Felankor
    # By Felankor
    #
    # IMPORTANT: I do not mind people looking at my code
    # to learn from it. If you use any parts of my code
    # please give me credit in your comments. I will
    # do the same if I ever use any code from another
    # AddOn. Thanks.
    ###################################################]]--

local FFBanSelected = nil;
    
function FFBanList_OK_OnClick()
   FFBanList:Hide();
end

function FFBanList_OnShow()
    --Set the correct text on the sort button
    if (FF_Options["BanListOrder"] == "Desc") then
        FFBanList_SortButton:SetText(FFBANLIST_SORT_DESC);
    else
        FFBanList_SortButton:SetText(FFBANLIST_SORT_ASC);
    end
    
end

function FFBanListScrollBar_Update()
  local BanLine = nil; -- 1 through 8 of our window to scroll
  local BanLinePlusOffset = nil; -- an index into our data calculated from the scroll offset
  local FFHighlighted = false;
  
    FauxScrollFrame_Update(FFBanListScrollBar,table.getn(FF_Ban_List),8,16);
    
    --Sort the table alphabetically
    if (FF_Options["BanListOrder"] == "Desc") then
        FF_SortTableDescending(FF_Ban_List);
        FFBanList_lblBanListLabel:SetText(FFBANLIST_LABEL.." "..FFBANLIST_DESC..":");
    else
        FF_SortTableAscending(FF_Ban_List);
        FFBanList_lblBanListLabel:SetText(FFBANLIST_LABEL.." "..FFBANLIST_ASC..":");
    end
  
    for BanLine=1,8 do
        BanLinePlusOffset = BanLine + FauxScrollFrame_GetOffset(FFBanListScrollBar);
      
        if BanLinePlusOffset <= table.getn(FF_Ban_List) then
            getglobal("FFBan"..BanLine.."ButtonTextName"):SetText(FF_ColourText(FF_Ban_List[BanLinePlusOffset], "white"));
            
            if (FFBanSelected == BanLinePlusOffset) then
                --Show selection highlight
                FFBanList_ShowHighlight("FFBan"..BanLine);
                FFHighlighted = true;
            elseif (FFHighlighted == false) then
                --Hide selection highlight
                FFBanList_HideHighlight();
            end
            
            getglobal("FFBan"..BanLine):Show();
        else
            getglobal("FFBan"..BanLine):Hide();
        end
        
    end
  
end

function FFBanList_Sort()

    if (FFBanList_SortButton:GetText() == FFBANLIST_SORT_DESC) then
        FF_Options["BanListOrder"] = "Asc"; --Change the order setting to ascending
        FFBanList_SortButton:SetText(FFBANLIST_SORT_ASC); --Update the text on the button
    else
        FF_Options["BanListOrder"] = "Desc"; --Change the order setting to descending
        FFBanList_SortButton:SetText(FFBANLIST_SORT_DESC); --Update the text on the button
    end
    
    FFBanListScrollBar_Update();
end

function FFBanList_BanPlayer()
    local FFBanName = getglobal("FFBanList_EditBox"):GetText();

    FF_Ban_Player(FFBanName); --Ban the player
    FFBanList_UpdateBanButtons(); --Update the ban list buttons
    FFBanListScrollBar_Update(); --Update the ban list
    getglobal("FFBanList_EditBox"):SetText(""); --Clear the edit box
    getglobal("FFBanList_EditBox"):ClearFocus(); --Clear focus from the edit box
end

function FFBanList_UnBanPlayer()

    if (FFBanSelected ~= nil) then
        FF_UnBan_Player(FF_Ban_List[FFBanSelected]); --Unban the player
        FFBanList_DeselectPlayer(); --Deselect the selected player
        FFBanList_UpdateBanButtons(); --Update the ban list buttons
        FFBanListScrollBar_Update(); --Update the ban list
    end
    
end

function FFBanList_UnBanAll()
    FF_Ban_List = {}; --Clear the ban array
    FFBanList_DeselectPlayer(); --Deselect the selected player
    FFBanList_UpdateBanButtons(); --Update the ban buttons
    FFBanListScrollBar_Update(); --Update the ban list
end

function FFBanList_SelectPlayer(ButtonName)

    if (getglobal(ButtonName.."ButtonTextName"):GetText() > "") then --if the button from the list that was clicked has text on it
        FFBanSelected = (FauxScrollFrame_GetOffset(FFBanListScrollBar) + string.sub(ButtonName, (string.len("FFBan") + 1), string.len(ButtonName))); --Get the number of the banned user
        
        FFBanList_ShowHighlight(ButtonName);
    else
        FFBanList_DeselectPlayer(); --Deselect the selected player
    end
    
    FFBanList_UpdateBanButtons(); --Update the ban buttons
    
end

function FFBanList_DeselectPlayer()
    FFBanSelected = nil;--Deselect the selected player
    FFBanList_HideHighlight(); --Hide the highlight
end

function FFBanList_ShowHighlight(ButtonName)
    --Highlight the selected player
    FFBanList_Highlight:ClearAllPoints();
    FFBanList_Highlight:SetPoint("TOPLEFT", ButtonName, "TOPLEFT", 0, 0);
    FFBanList_Highlight:Show();
end

function FFBanList_HideHighlight()
    FFBanList_Highlight:Hide(); --Hide the highlight
end

function FFBanList_UpdateBanButtons()
    
    if (getglobal("FFBanList_EditBox"):GetText() == "") then --If theres no text in the editbox
        getglobal("FFBanList_BanButton"):Disable(); --Disable the ban button
    else
        getglobal("FFBanList_BanButton"):Enable(); --Enable the ban button
    end

    if (FFBanSelected ~= nil) then --If a player has been selected from the list
        getglobal("FFBanList_UnbanButton"):Enable(); --Enable the unban button
    else
        getglobal("FFBanList_UnbanButton"):Disable(); --Disable the unban button
    end
    
    if (table.getn(FF_Ban_List) >= 1) then --If there is one or more banned players
        getglobal("FFBanList_UnbanAllButton"):Enable(); --Enable the unban all button
    else
        getglobal("FFBanList_UnbanAllButton"):Disable(); --Disable the unban all button
    end
    
end