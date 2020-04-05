local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");
local Manager = Root.GetOrNewModule("Manager");

Widgets["AnchorGhost"] = { };
local AnchorGhost = Widgets["AnchorGhost"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

local OPEN_TIME = 0.500;
local CLOSE_TIME = 0.500;

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Activate()                                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the anchor ghost.                                       *
-- * >> id: the anchor ID this anchor ghost will handle.              *
-- ********************************************************************
-- * Activate one anchor ghost.                                       *
-- ********************************************************************
local function Activate(self, id)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    -- Prepare the display vars
    self.status = "OPENING";
    self.timer = 0;

    -- Set the anchor ghost according to the anchor's properties.
    Anchor:BindToWidget(self, id);
    local x, y, scale, enabled, id, shape, width, height, label = Anchor:GetAnchorInfo(self);
    if ( not id ) then return; end

    self.label:SetText(label);
    self.shape = shape;
    self.x = x;
    self.y = y;
    self.scale = scale or 1;

    self:SetWidth(width);
    self:SetHeight(height);
    if ( shape == "BOX" ) then
        self:SetScale(self.scale);
    end

    -- And display the frame
    self:Show();
    AnchorGhost.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove([atOnce])                                            *
-- ********************************************************************
-- * >> self: the anchor ghost.                                       *
-- * >> atOnce: if set, the frame will be hidden instantly.           *
-- ********************************************************************
-- * Remove one anchor ghost.                                         *
-- ********************************************************************
local function Remove(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    AnchorGhost.OnDragStop(self); -- Cancel any dragging

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "CLOSING";
        self.timer = 0;
    end
end

-- ********************************************************************
-- * self:Save()                                                      *
-- ********************************************************************
-- * >> self: the anchor ghost.                                       *
-- ********************************************************************
-- * Save the anchor config of the anchor ghost to the real anchor.   *
-- ********************************************************************
local function Save(self)
    if type(self) ~= "table" then return; end

    local x, y, scale, enabled, id, shape, width, height, label, defaultX, defaultY, removable = Anchor:GetAnchorInfo(self);

    if ( not id ) then return; end

    local effectiveX, effectiveY, effectiveScale = self.x or 0, self.y or 0, self.scale or 1;
    defaultX = defaultX or -1;
    defaultY = defaultY or -1;

    -- If the widget is placed very close to the default position, consider the widget is at default position.
    if ( math.abs(defaultX - effectiveX) < 0.01 ) then effectiveX = nil; end
    if ( math.abs(defaultY - effectiveY) < 0.01 ) then effectiveY = nil; end
    if ( math.abs(1 - effectiveScale) < 0.01 ) then effectiveScale = nil; end

    Anchor:SetPosition(id, effectiveX, effectiveY, effectiveScale);

    if ( not removable ) then
        -- Widget not removable. Make sure the anchor is enabled.
        Anchor:Toggle(id, true);
    end
end

-- ********************************************************************
-- * self:RestoreDefaultPosition(axis)                                *
-- ********************************************************************
-- * >> self: the anchor ghost.                                       *
-- * The axis to restore. Can be "X", "Y" or "BOTH".                  *
-- ********************************************************************
-- * Change the position of the anchor ghost to the anchor's default  *
-- * position. You'll still have to call Save method to apply the     *
-- * change.                                                          *
-- ********************************************************************
local function RestoreDefaultPosition(self, axis)
    if type(self) ~= "table" then return; end

    local x, y, scale, enabled, id, shape, width, height, label, defaultX, defaultY, removable = Anchor:GetAnchorInfo(self);
    if ( not defaultX ) and ( not defaultY ) then return; end -- One coord can be nil, but the other cannot.

    if ( axis == "X" or axis == "BOTH" ) then
        self.x = defaultX or 0;
    end
    if ( axis == "Y" or axis == "BOTH" ) then
        self.y = defaultY or 0;
    end
end

-- ********************************************************************
-- * self:GetStatus()                                                 *
-- ********************************************************************
-- * >> self: the anchor ghost.                                       *
-- ********************************************************************
-- * Get the current internal status of one anchor ghost.             *
-- * Can be either OPENING, RUNNING, CLOSING or STANDBY.              *
-- ********************************************************************
local function GetStatus(self)
    if type(self) ~= "table" then return; end
    return self.status;
end

-- ********************************************************************
-- * self:ChangeScale(scale)                                          *
-- ********************************************************************
-- * >> self: the anchor ghost.                                       *
-- * >> scale: the new scale value.                                   *
-- ********************************************************************
-- * Change the scale value of an anchor.                             *
-- ********************************************************************
local function ChangeScale(self, scale)
    if type(self) ~= "table" then return; end
    self.scale = max(0.50, min(2.00, scale));
    self:SetScale(self.scale);
    -- AnchorGhost.OnDragStop(self);
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function AnchorGhost.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.00;
    self.isMoving = false;

    -- Methods
    self.Activate = Activate;
    self.Remove = Remove;
    self.Save = Save;
    self.RestoreDefaultPosition = RestoreDefaultPosition;
    self.ChangeScale = ChangeScale;
    self.GetStatus = GetStatus;

    -- Children
    self.label = Root.CreateFontString(self, "ARTWORK", "SmallWhite", nil, "MIDDLE", "MIDDLE");
    self.label:SetHeight(32);
    self.label:SetPoint("CENTER", self, "CENTER", 0, 0);
    self.label:Show();

    -- Configure dragging
    Root.MakeDraggable(self, nil, AnchorGhost.OnDragStart, AnchorGhost.OnDragStop);

    -- Clamped!
    self:SetClampedToScreen(true);

    Root.SetBackdrop(self, "OPTION");
end

function AnchorGhost.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    local alpha = 1.00;

    -- Open/close
    if ( self.status == "OPENING" ) then
        self.timer = min(OPEN_TIME, self.timer + elapsed);
        alpha = self.timer / OPEN_TIME;
        if ( self.timer == OPEN_TIME ) then self.status = "RUNNING"; end
    end
    if ( self.status == "CLOSING" ) then
        self.timer = min(CLOSE_TIME, self.timer + elapsed);
        alpha = 1 - self.timer / CLOSE_TIME;
        if ( self.timer == CLOSE_TIME ) then self:Remove(true); end
    end

    if ( self.status == "RUNNING" ) then
        local haveFocus = ( Manager:GetAnchorControlFrame():GetFocus() == self );
        if ( haveFocus ) then
            alpha = alpha * (0.70 + 0.30 * cos(GetTime() * 360 / 1));
        end
    end

    if ( not self.isMoving ) then
        self:ClearAllPoints();
        if ( self.shape == "BOX" ) then
            self:SetPoint("CENTER", UIParent, "CENTER", Root.PctToPx("X", self.x - 0.5) / self.scale, Root.PctToPx("Y", self.y - 0.5) / self.scale);
      else
            self:SetPoint("CENTER", UIParent, "CENTER", 0, Root.PctToPx("Y", self.y - 0.5));
        end
    end

    -- Application on the frame
    self:SetAlpha(alpha);
end

function AnchorGhost.OnDragStart(self)
    if ( self.status ~= "RUNNING" ) then return; end

    self:StartMoving();
    self.isMoving = true;

    Manager:GetAnchorControlFrame():SetFocus(self);
end

function AnchorGhost.OnDragStop(self)
    self:StopMovingOrSizing();
    self.isMoving = false;

    self.x, self.y = self:GetCenter();
    self.x = Root.PxToPct("X", self.x) * self.scale;
    self.y = Root.PxToPct("Y", self.y) * self.scale;
end