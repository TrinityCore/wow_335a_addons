--[[################ FFWhisperLog.lua ###################
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
    
function FFWhisperLog_OnShow()
    if (FF_Options["WhisperLogSettings"]["OrderBy"] == "Date") then
        
        if (FF_Options["WhisperLogSettings"]["Order"] == "Asc") then
            FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_DATE_SORT_DESC);
            FFWhisperLog_SortDateButton:SetText(FFWHISPLOG_DATE_SORT_ASC);
        elseif (FF_Options["WhisperLogSettings"]["Order"] == "Desc") then
            FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_DATE_SORT_ASC);
            FFWhisperLog_SortDateButton:SetText(FFWHISPLOG_DATE_SORT_DESC);
        end
        
    elseif (FF_Options["WhisperLogSettings"]["OrderBy"] == "Command") then
        
        if (FF_Options["WhisperLogSettings"]["Order"] == "Asc") then
            FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_COMMAND_SORT_DESC);
            FFWhisperLog_SortCommandButton:SetText(FFWHISPLOG_COMMAND_SORT_ASC);
        elseif (FF_Options["WhisperLogSettings"]["Order"] == "Desc") then
            FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_COMMAND_SORT_ASC);
            FFWhisperLog_SortCommandButton:SetText(FFWHISPLOG_COMMAND_SORT_DESC);
        end
        
    elseif (FF_Options["WhisperLogSettings"]["OrderBy"] == "Name") then
        
        if (FF_Options["WhisperLogSettings"]["Order"] == "Asc") then
            FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_NAME_SORT_DESC);
            FFWhisperLog_SortNameButton:SetText(FFWHISPLOG_NAME_SORT_ASC);
        elseif (FF_Options["WhisperLogSettings"]["Order"] == "Desc") then
            FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_NAME_SORT_ASC);
            FFWhisperLog_SortNameButton:SetText(FFWHISPLOG_NAME_SORT_DESC);
        end
        
    elseif (FF_Options["WhisperLogSettings"]["OrderBy"] == "Authorised") then
        
        if (FF_Options["WhisperLogSettings"]["Order"] == "Asc") then
            FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_AUTHORISED_SORT_DESC);
            FFWhisperLog_SortAuthorisedButton:SetText(FFWHISPLOG_AUTHORISED_SORT_ASC);
        elseif (FF_Options["WhisperLogSettings"]["Order"] == "Desc") then
            FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_AUTHORISED_SORT_ASC);
            FFWhisperLog_SortAuthorisedButton:SetText(FFWHISPLOG_AUTHORISED_SORT_DESC);
        end
        
    end
    
    FFWhisperLogScrollBar_Update();
    
end

function LogWhisper(LogCommand, LogSender, LogAuth)

    if ((LogCommand ~= "") and (LogCommand ~= nil)) then --If the command is not empty
        FF_Whisper_Log[(table.getn(FF_Whisper_Log)+1)] = { ["Date"]=date("%d/%m/%y").." "..date("%H:%M"), ["Command"]=LogCommand, ["Name"]=LogSender, ["Authorised"]=LogAuth };
    end

end

function FFWhisperLogScrollBar_Update()
   local LogLine = nil; -- 1 through 8 of our window to scroll
   local LogLinePlusOffset = nil; -- an index into our data calculated from the scroll offset
  
   FauxScrollFrame_Update(FFWhisperLogScrollBar,table.getn(FF_Whisper_Log),8,16);
   
   --Sort the table in the chosen order by the chosen column (e.g. Player names alphabetically)
   if (FF_Options["WhisperLogSettings"]["Order"] == "Desc") then
      FF_SortTableDescending(FF_Whisper_Log, FF_Options["WhisperLogSettings"]["OrderBy"]);
   else
      FF_SortTableAscending(FF_Whisper_Log, FF_Options["WhisperLogSettings"]["OrderBy"]);
   end
   
   FFWhisperLog_HighlightHeader();
  
   for LogLine=1,8 do
      LogLinePlusOffset = LogLine + FauxScrollFrame_GetOffset(FFWhisperLogScrollBar);
      
      if LogLinePlusOffset <= table.getn(FF_Whisper_Log) then
         getglobal("FFLogDate"..LogLine.."ButtonTextName"):SetText(FF_ColourText(FF_Whisper_Log[LogLinePlusOffset]["Date"], "white"));
         getglobal("FFLogCommand"..LogLine.."ButtonTextName"):SetText(FF_ColourText(FF_Whisper_Log[LogLinePlusOffset]["Command"], "white"));
         getglobal("FFLogName"..LogLine.."ButtonTextName"):SetText(FF_ColourText(FF_Whisper_Log[LogLinePlusOffset]["Name"], "white"));
         getglobal("FFLogAuthorised"..LogLine.."ButtonTextName"):SetText(FF_ColourText(FF_Whisper_Log[LogLinePlusOffset]["Authorised"], "white"));
         getglobal("FFLogDate"..LogLine):Show();
         getglobal("FFLogCommand"..LogLine):Show();
         getglobal("FFLogName"..LogLine):Show();
         getglobal("FFLogAuthorised"..LogLine):Show();
      else
         getglobal("FFLogDate"..LogLine):Hide();
         getglobal("FFLogCommand"..LogLine):Hide();
         getglobal("FFLogName"..LogLine):Hide();
         getglobal("FFLogAuthorised"..LogLine):Hide();
      end
      
   end

end

function FFWhisperLog_SortDate()
    if (FFWhisperLog_SortDateButton:GetText() == FFWHISPLOG_DATE_SORT_ASC) then
        FF_Options["WhisperLogSettings"]["OrderBy"] = "Date";
        FF_Options["WhisperLogSettings"]["Order"] = "Desc";
        FFWhisperLog_SortDateButton:SetText(FFWHISPLOG_DATE_SORT_DESC);
        FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_DATE_SORT_ASC);
        FFWhisperLogScrollBar_Update();
    else
        FF_Options["WhisperLogSettings"]["OrderBy"] = "Date";
        FF_Options["WhisperLogSettings"]["Order"] = "Asc";
        FFWhisperLog_SortDateButton:SetText(FFWHISPLOG_DATE_SORT_ASC);
        FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_DATE_SORT_DESC);
        FFWhisperLogScrollBar_Update();
    end
    
end

function FFWhisperLog_SortCommand()
    if (FFWhisperLog_SortCommandButton:GetText() == FFWHISPLOG_COMMAND_SORT_DESC) then
        FF_Options["WhisperLogSettings"]["OrderBy"] = "Command";
        FF_Options["WhisperLogSettings"]["Order"] = "Asc";
        FFWhisperLog_SortCommandButton:SetText(FFWHISPLOG_COMMAND_SORT_ASC);
        FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_COMMAND_SORT_DESC);
        FFWhisperLogScrollBar_Update();
    else
        FF_Options["WhisperLogSettings"]["OrderBy"] = "Command";
        FF_Options["WhisperLogSettings"]["Order"] = "Desc";
        FFWhisperLog_SortCommandButton:SetText(FFWHISPLOG_COMMAND_SORT_DESC);
        FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_COMMAND_SORT_ASC);
        FFWhisperLogScrollBar_Update();
    end
    
end

function FFWhisperLog_SortName()
    if (FFWhisperLog_SortNameButton:GetText() == FFWHISPLOG_NAME_SORT_DESC) then
        FF_Options["WhisperLogSettings"]["OrderBy"] = "Name";
        FF_Options["WhisperLogSettings"]["Order"] = "Asc";
        FFWhisperLog_SortNameButton:SetText(FFWHISPLOG_NAME_SORT_ASC);
        FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_NAME_SORT_DESC);
        FFWhisperLogScrollBar_Update();
    else
        FF_Options["WhisperLogSettings"]["OrderBy"] = "Name";
        FF_Options["WhisperLogSettings"]["Order"] = "Desc";
        FFWhisperLog_SortNameButton:SetText(FFWHISPLOG_NAME_SORT_DESC);
        FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_NAME_SORT_ASC);
        FFWhisperLogScrollBar_Update();
    end
    
end

function FFWhisperLog_SortAuthorised()
    if (FFWhisperLog_SortAuthorisedButton:GetText() == FFWHISPLOG_AUTHORISED_SORT_DESC) then
        FF_Options["WhisperLogSettings"]["OrderBy"] = "Authorised";
        FF_Options["WhisperLogSettings"]["Order"] = "Asc";
        FFWhisperLog_SortAuthorisedButton:SetText(FFWHISPLOG_AUTHORISED_SORT_ASC);
        FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_AUTHORISED_SORT_DESC);
        FFWhisperLogScrollBar_Update();
    else
        FF_Options["WhisperLogSettings"]["OrderBy"] = "Authorised";
        FF_Options["WhisperLogSettings"]["Order"] = "Desc";
        FFWhisperLog_SortAuthorisedButton:SetText(FFWHISPLOG_AUTHORISED_SORT_DESC);
        FFWhisperLog_lblSortedLabel:SetText(FFWHISPLOG_SORTED_BY_LABEL.."\n"..FFWHISPLOG_AUTHORISED_SORT_ASC);
        FFWhisperLogScrollBar_Update();
    end
    
end

function FFWhisperLog_HighlightHeader()
    local FFWhisperLog_Headers = { { "Date", FFWHISPLOG_DATE_HEADER }, { "Name", FFWHISPLOG_NAME_HEADER }, { "Command", FFWHISPLOG_COMMAND_HEADER }, { "Authorised", FFWHISPLOG_AUTHORISED_HEADER }, };

    for i=1, table.getn(FFWhisperLog_Headers) do
        if (FF_Options["WhisperLogSettings"]["OrderBy"] == FFWhisperLog_Headers[i][1]) then
            getglobal("FFWhisperLog_lbl"..FFWhisperLog_Headers[i][1].."Label"):SetText(FF_ColourText(FFWhisperLog_Headers[i][2], "green"));
        else
            getglobal("FFWhisperLog_lbl"..FFWhisperLog_Headers[i][1].."Label"):SetText(FFWhisperLog_Headers[i][2]);
        end
        
    end
    
end

function FFWhisperLog_ClearLog()
    FF_Whisper_Log = {}; --Clear the log
    FFWhisperLogScrollBar_Update();
    
end