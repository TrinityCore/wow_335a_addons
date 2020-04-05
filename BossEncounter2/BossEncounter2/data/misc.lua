local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                          Misc data                             **
-- --------------------------------------------------------------------

local ALWAYS_TRUE_FUNC = function() return true; end;

local tooltipEnter = function(self)
    if ( self.tooltipText ) then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1);
    end
    if ( self.tooltipRequirement ) then
        GameTooltip:AddLine(self.tooltipRequirement, "", 1.0, 1.0, 1.0);
        GameTooltip:Show();
    end
end;

local tooltipLeave = function(self)
    GameTooltip:Hide();
end;

-- --------------------------------------------------------------------
-- **                         Misc functions                         **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> PtsToRank(pts)                                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> pts: the amount of points.                                    *
-- ********************************************************************
-- * Converts a given amount of points in a rank.                     *
-- * Returned value can be: "S", "A", "B", "C", "D", "E".             *
-- ********************************************************************
function Root.PtsToRank(pts)
    if pts > 300 then return "S"; end
    if pts < 100 then return "E"; end
    if pts < 150 then return "D"; end
    if pts < 200 then return "C"; end
    if pts < 250 then return "B"; end
    return "A";
end

-- ********************************************************************
-- * Root -> SetPointsText(fontString, pts[, threshold])              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> fontString: the font string that sees its text adjusted.      *
-- * >> pts: the points amount to display.                            *
-- * >> threshold: the threshold before turning the text in yellow.   *
-- ********************************************************************
-- * Displays "X pts" on a font string.                               *
-- ********************************************************************
function Root.SetPointsText(fontString, pts, threshold)
    local text = Root.FormatLoc("PtsAmount", pts);
    if ( not threshold ) or ( pts <= threshold ) then
        text = "|cffffffff"..text.."|r";
    end
    fontString:SetText(text);
end

-- ********************************************************************
-- * Root -> GetNumFreeBagSlots()                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the number of free bag slots the local player has.           *
-- ********************************************************************
function Root.GetNumFreeBagSlots()
    local totalFree, freeSlots, bagFamily = 0;
    for i=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        freeSlots, bagFamily = GetContainerNumFreeSlots(i);
        if ( bagFamily == 0 ) then
            totalFree = totalFree + freeSlots;
        end
    end
    return totalFree;
end

-- ********************************************************************
-- * Root -> LinearInterpolation(table, index)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> table: the table containing incomplete values.                *
-- * This table should be read-only.                                  *
-- * >> index: the index you wish to read. If it is not found, it     *
-- * will be linearly interpolated.                                   *
-- ********************************************************************
-- * Returns a value from a table, or interpolate it if it's missing. *
-- ********************************************************************
function Root.LinearInterpolation(table, index)
    -- Got a value for given level. Return it.
    if ( table[index] ) then
        return table[index];
  else
        local i, maxIndex;
        maxIndex = table.maxIndex;
        if ( not maxIndex ) then
            for i in pairs(table) do
                if type(i) == "number" then
                    maxIndex = max(maxIndex or 0, i);
                end
            end
        end
        table.maxIndex = maxIndex or 0;

        -- Interpolate linearly.
        local lastStepValue, nextStepValue = nil, nil;
        local lastStepIndex, nextStepIndex = index, index;

        while ( lastStepIndex > 1 ) and ( not lastStepValue ) do
            lastStepIndex = lastStepIndex - 1;
            if ( table[lastStepIndex] ) then lastStepValue = table[lastStepIndex]; end
        end
        while ( nextStepIndex < maxIndex ) and ( not nextStepValue ) do
            nextStepIndex = nextStepIndex + 1;
            if ( table[nextStepIndex] ) then nextStepValue = table[nextStepIndex]; end
        end

        if ( lastStepValue and nextStepValue ) then
            local valueDelta = nextStepValue - lastStepValue;
            local indexDelta = nextStepIndex - lastStepIndex;
            if ( indexDelta > 0 ) then
                local progression = (index - lastStepIndex) / indexDelta;
                return math.floor(lastStepValue + (nextStepValue - lastStepValue) * progression);
            end
        end

        return nil;
    end
end

-- ********************************************************************
-- * Root -> MakeDraggable(frame, [conditionFunc,                     *
-- *                       startHandler, stopHandler])                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> frame: the frame that is to be made draggable.                *
-- * >> conditionFunc: the function that will be called to            *
-- * determinate if the dragging is allowed. The frame itself will    *
-- * be passed to the function as argument. It must return a boolean. *
-- * If you input nil, the dragging will be always allowed.           *
-- * >> startHandler: whether you want to use your own special        *
-- * handler for the dragging. If this argument is not nil, the       *
-- * conditionFunc argument will have no effect.                      *
-- * >> stopHandler: same thing as above except it is the stop        *
-- * dragging handler.                                                *
-- ********************************************************************
-- * Quickly make a frame draggable.                                  *
-- ********************************************************************
function Root.MakeDraggable(frame, conditionFunc, startHandler, stopHandler)
    frame:EnableMouse(true);
    frame:RegisterForDrag("LeftButton");
    frame:SetMovable(true);

    if type(startHandler) == "function" then
        frame:SetScript("OnDragStart", startHandler);
  else
        frame.DRAG_CONDITION = conditionFunc or ALWAYS_TRUE_FUNC;
        frame:SetScript("OnDragStart", function(self) if self:DRAG_CONDITION() then self:StartMoving(); end end);
    end
    if type(stopHandler) == "function" then
        frame:SetScript("OnDragStop", stopHandler);
  else
        frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); end);
    end
end

-- ********************************************************************
-- * Root -> GetItemID(itemLink or itemString)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> itemLink/itemString: the item link or item string.            *
-- ********************************************************************
-- * Get the item ID of the item designated by the given itemLink or  *
-- * itemString.                                                      *
-- ********************************************************************
function Root.GetItemID(itemLink)
    if type(itemLink) ~= "string" then return nil; end

    local found, _, itemString = string.find(itemLink, "^|c%x+|H(.+)|h%[.*%]");
    itemString = itemString or itemLink;

    local _, itemID = strsplit(":", itemString);
    return tonumber(itemID or "") or nil;
end

-- ********************************************************************
-- * Root -> SetAllPointsSecure(secureFrame, frame[, extraLevel])     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> secureFrame: the secure frame that has its points set.        *
-- * >> frame: the frame the secure frame will overlap with.          *
-- * >> extraLevel: the frame level added to the secure frame.        *
-- ********************************************************************
-- * Make a secure frame overlap with a normal frame without          *
-- * protecting the frame. CANNOT BE CALLED IN COMBAT.                *
-- ********************************************************************
function Root.SetAllPointsSecure(secureFrame, frame, extraLevel)
    if type(secureFrame) ~= "table" or type(frame) ~= "table" then return; end
    extraLevel = extraLevel or 0;

    local scale = frame:GetEffectiveScale() / UIParent:GetScale();
    secureFrame:SetWidth(frame:GetWidth());
    secureFrame:SetHeight(frame:GetHeight());
    secureFrame:SetScale(scale);
    secureFrame:SetFrameStrata(frame:GetFrameStrata());
    secureFrame:SetFrameLevel(frame:GetFrameLevel()+extraLevel);

    local x, y = frame:GetCenter();
    if ( x and y ) then
        secureFrame:ClearAllPoints();
        secureFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
    end
end

-- ********************************************************************
-- * Root -> SetTooltip(frame, title, explanation)                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> frame: the frame whose tooltip is set.                        *
-- * >> title: the title of the tooltip.                              *
-- * >> explanation: the explanation of the tooltip.                  *
-- ********************************************************************
-- * Quick way to set up a tooltip for a frame.                       *
-- * Pass the magic string "KEEP" to keep a tooltip portion unchanged.*
-- ********************************************************************
function Root.SetTooltip(frame, title, explanation)
    if ( title == "KEEP" ) then title = frame.tooltipText; end
    if ( explanation == "KEEP" ) then explanation = frame.tooltipRequirement; end

    frame.tooltipText = title;
    frame.tooltipRequirement = explanation;

    if ( not frame.tooltipHandler ) then
        frame.tooltipHandler = true;

        -- Install handlers
        if ( frame:GetScript("OnEnter") ) then
            frame:HookScript("OnEnter", tooltipEnter);
      else
            frame:SetScript("OnEnter", tooltipEnter);
        end
        if ( frame:GetScript("OnLeave") ) then
            frame:HookScript("OnLeave", tooltipLeave);
      else
            frame:SetScript("OnLeave", tooltipLeave);
        end
    end
end

-- ********************************************************************
-- * Root -> MapDistance(x1, y1, x2, y2)                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> x1, y1: first point coordinates.                              *
-- * >> x2, y2: second point coordinates.                             *
-- ********************************************************************
-- * Get the 2D distance between 2 map points.                        *
-- * Distance is adjusted so X has the same weight as Y.              *
-- ********************************************************************
function Root.MapDistance(x1, y1, x2, y2)
    return (((x2 - x1)/1.0)^2 + ((y2 - y1)/1.5)^2)^0.5;
end