local Root = BossEncounter2;

local Anchor = Root.GetOrNewModule("Anchor");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Provides ways to memorize where the users want their widgets to be placed.

Anchor.currentAnchors = { variable = { }, const = { } };

-- --------------------------------------------------------------------
-- **                           Methods                              **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Anchor:Register(id, shape, width, height)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> id: the unique ID to give to the new anchor.                  *
-- * >> shape: the shape of the ghost that will be shown in the       *
-- * configuration mode. Can be BOX or AXIS.                          *
-- * >> width: the width of the ghost.                                *
-- * >> height: the height of the ghost.                              *
-- * >> removable: set whether the user can change the "Enabled"      *
-- * flag for this anchor or not.                                     *
-- ********************************************************************
-- * Register a new anchor, creating it if not already present.       *
-- * Do not forget to set the anchor's constants with SetConstants    *
-- * method just after.                                               *
-- * Implementation warning: this method should only be called in the *
-- * OnStart handler of the GUI Manager.                              *
-- ********************************************************************

Anchor.Register = function(self, id, shape, width, height, removable)
    if type(self.currentAnchors.const[id]) == "table" then return; end

    local anchor = Root.Save.Get("anchor", id, "active");

    if type(anchor) ~= "table" then
        anchor = { enabled = true };
  else
        -- OK !
    end

    if ( anchor.enabled == nil ) then anchor.enabled = true; end

    Root.Save.Set("anchor", id, anchor, "active");
    self.currentAnchors.variable[id] = anchor;
    self.currentAnchors.const[id] = { shape = shape, width = width, height = height, removable = removable };

    -- Practical to iterate
    self.currentAnchors[#self.currentAnchors+1] = id;
end

-- ********************************************************************
-- * Anchor:SetConstants(id, defaultX, defaultY, label)               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> id: the ID of the anchor you are talking about.               *
-- * >> defaultX: the default X value that will be returned if the    *
-- * user doesn't place himself the entity's center on the screen.    *
-- * >> defaultY: the default Y value that will be returned if the    *
-- * user doesn't place himself the entity's center on the screen.    *
-- * >> label: the label of the entity in the configuration mode.     *
-- ********************************************************************
-- * Set constants of an anchor entity.                               *
-- * OnFailed handler of the affected module to be fired.             *
-- ********************************************************************

Anchor.SetConstants = function(self, id, defaultX, defaultY, label)
    if type(self.currentAnchors.const[id]) ~= "table" then return; end

    self.currentAnchors.const[id].defaultX = defaultX;
    self.currentAnchors.const[id].defaultY = defaultY;
    self.currentAnchors.const[id].label = label;
end

-- ********************************************************************
-- * Anchor:SetPosition(id, x, y, scale)                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> id: the ID of the anchor you are talking about.               *
-- * >> x: the new X value for the anchor. Between 0 and 1.           *
-- * >> y: the new Y value for the anchor. Between 0 and 1.           *
-- * >> scale: the new scale value for the anchor.                    *
-- * Use nil to mean "default position".                              *
-- ********************************************************************
-- * Set constants of an anchor entity.                               *
-- ********************************************************************

Anchor.SetPosition = function(self, id, x, y, scale)
    if type(self.currentAnchors.variable[id]) ~= "table" then return; end

    self.currentAnchors.variable[id].x = x;
    self.currentAnchors.variable[id].y = y;
    self.currentAnchors.variable[id].scale = scale;
end

-- ********************************************************************
-- * Anchor:Toggle(id, state)                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> id: the ID of the anchor you are talking about.               *
-- * >> state: whether to enable or not the anchor.                   *
-- * If state is "TOGGLE", the current enabled flag will be toggled.  *
-- ********************************************************************
-- * Set an anchor as enabled or disabled.                            *
-- ********************************************************************

Anchor.Toggle = function(self, id, state)
    if type(self.currentAnchors.variable[id]) ~= "table" then return; end

    local prevState = self.currentAnchors.variable[id].enabled;

    if ( state == "TOGGLE" ) then
        self.currentAnchors.variable[id].enabled = (not prevState);
  else
        self.currentAnchors.variable[id].enabled = state;
    end
end

-- ********************************************************************
-- * Anchor:BindToWidget(widget, id)                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> widget: the widget that gets the anchor.                      *
-- * >> id: the ID of the anchor that will be bound.                  *
-- ********************************************************************
-- * Bind an anchor to a widget table.                                *
-- ********************************************************************

Anchor.BindToWidget = function(self, widget, id)
    if type(self.currentAnchors.variable[id]) ~= "table" then return; end

    widget.anchorID = id;
end

-- ********************************************************************
-- * Anchor:GetNumAnchors()                                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the number of configurable anchors.                          *
-- * OnFailed handler of the affected module to be fired.             *
-- ********************************************************************

Anchor.GetNumAnchors = function(self)
    return #self.currentAnchors;
end

-- ********************************************************************
-- * Anchor:GetAnchorInfo(index or id or widget)                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> the index or id of the anchor.                                *
-- * It can also be conveniently the widget on which the anchor is    *
-- * bound, provided you have previously called BindToWidget method.  *
-- ********************************************************************
-- * Returns config about a registered anchor:                        *
-- * x, y, scale, id, shape, width, height, label, defaultX, defaultY *
-- ********************************************************************

Anchor.GetAnchorInfo = function(self, index)
    if type(index) == "number" then
        return self:GetAnchorInfo(self.currentAnchors[index]);

elseif type(index) == "string" then
        local var, const = self.currentAnchors.variable[index], self.currentAnchors.const[index];
        if ( var and const ) then
            return var.x or const.defaultX, var.y or const.defaultY, var.scale or 1, var.enabled ~= false, index, const.shape, const.width, const.height, const.label, const.defaultX, const.defaultY, const.removable;
        end

elseif type(index) == "table" then
        if ( index.anchorID ) then
            return self:GetAnchorInfo(index.anchorID);
        end
    end
    return nil, nil, 1, false, nil, "NONE", 0, 0, "INVALID", nil, nil;
end

-- ********************************************************************
-- * Anchor:CopyLayout(profileName)                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> profileName: the name of the profile whose layout is copied.  *
-- ********************************************************************
-- * Copy layout from another profile to the current profile.         *
-- * It is highly recommanded to close and restart the anchor mode    *
-- * when this method is called to acknowledge the changes.           *
-- * Return true if successful, false if not.                         *
-- ********************************************************************

Anchor.CopyLayout = function(self, profileName)
    -- Get the correct profile.
    local success = false;
    local i, num, name, server;
    num = Root.Save.GetNumProfiles();
    for i=1, num do
        name, server = Root.Save.GetProfileInfo(i);
        if ( name == profileName ) then
            success = Root.Save.SetModifiedProfile(i);
            break;
        end
    end
    if ( not success ) then return false; end

    local id, target, source;
    for id, target in pairs(self.currentAnchors.variable) do
        source = Root.Save.Get("anchor", id, "modified");
        target.x = source.x;
        target.y = source.y;
        target.scale = source.scale;
        target.enabled = source.enabled;
    end

    return true;
end