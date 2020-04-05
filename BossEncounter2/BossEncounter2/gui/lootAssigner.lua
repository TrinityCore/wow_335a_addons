local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");

local LootHelper = Root.GetOrNewModule("LootHelper");

Widgets["LootAssigner"] = { };
local LootAssigner = Widgets["LootAssigner"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local BAR_TEXTURE = Root.folder.."gfx\\AddBars";
local BAR_WIDTH = 148;

local DUMMY_TEXTURE = select(10, GetItemInfo(6948)) or "";
local DUMMY_NAME = select(1, GetItemInfo(6948)) or "???";

local TIME_OUT_EXECUTION = 10;
local CONFIRM_INCREMENT = 0.20;
local CONFIRM_DECREMENT_RATE = 0.05; -- Per second.

-- In sec.
local FADE_TIME = 0.50;
local CHECK_INTERVAL = 0.500;

local enum = { };

local INSERTNAME_FUNC = function(_, self, name)
                            if ( name == Root.Localise("LA-Random") ) then
                                local randomID = math.random(1, #self.list);
                                self.editBox:SetText(self.list[randomID]);
                          else
                                self.editBox:SetText(name);
                            end
                        end;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Start(lootID[, test])                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the loot assigner frame.                                *
-- * >> lootID: the ID of the loot to start assigning.                *
-- * >> test: set this if it is a test.                               *
-- * The frame will then not auto-close if you do not have the ML.    *
-- ********************************************************************
-- * Starts a loot assigner frame.                                    *
-- ********************************************************************
local function Start(self, lootID, test)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    local hasLoot = LootHelper:IsLootAvailable();
    if ( not hasLoot ) and ( not test ) then return; end

    self.status = "OPENING";
    self.timer = FADE_TIME;
    self.test = test;

    local texture = GetLootSlotInfo(lootID);
    self.itemLink = GetLootSlotLink(lootID);
    self.itemButton.icon:SetTexture(texture or DUMMY_TEXTURE);

    self.editBox:SetText("");
    self.assignee = "";

    self.executeTarget = "";
    self.executeState = "STANDBY";
    self:OutputMessage(Root.Localise("LA-EnterName"));

    self.disenchantTimer, self.disenchantTimerMax = LootHelper:GetDisenchantTimer(self:GetLink());
    self:SetBar(nil, 2);

    self:Check();

    local ofsX = 0;
    local ofsY = 0;
    local ID = self:GetID();

    ofsX = 300 * math.floor((ID-1)/3);
    ofsY = 300 - 150 * (math.fmod(ID-1, 3) + 1);

    self:ClearAllPoints();
    self:SetPoint("CENTER", self:GetParent(), "CENTER", ofsX, ofsY);
    self:Show();
    LootAssigner.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- * >> atOnce: if set, the loot assigner will be hidden instantly.   *
-- ********************************************************************
-- * Stops displaying the loot assigner.                              *
-- ********************************************************************
local function Remove(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    self.executeTarget = "";

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "CLOSING";
        self.timer = FADE_TIME;
    end
end

-- ********************************************************************
-- * self:Check()                                                     *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- ********************************************************************
-- * Check if the loot assigner should auto-destroy itself.           *
-- * Possible reason: master loot lost, loot no longer on the boss... *
-- ********************************************************************
local function Check(self)
    if type(self) ~= "table" then return; end

    self.nextCheck = CHECK_INTERVAL;

    -- Query disenchant
    if ( self.executeState == "STANDBY" ) then
        self.disenchant = LootHelper:GetDisenchant();
    end

    -- Master loot check
    if ( not LootHelper:HasMasterLoot() ) and ( not self.test ) then
        self:Remove();
        return;
    end

    -- Corpse no longer available check
    if ( not LootHelper:IsLootAvailable() ) and ( not self.test ) then
        self:Remove();
        return;
    end

    -- Search for the loot on the corpse
    local found = false;
    local i;
    for i=1, GetNumLootItems() do
        if ( GetLootSlotLink(i) == self:GetLink() ) then
            found = true;
        end
    end
    if ( not found ) and ( not self.test ) then
        self:Remove();
        return;
    end

    -- Execute check
    if ( self.executeState == "EXECUTING" ) and ( #self.executeTarget > 0 ) then
        local result = self:Execute();
        if ( result == 1 ) then
            self:Remove();
    elseif ( result == -1 ) then
            self:OutputMessage(Root.FormatLoc("LA-AssignNotFound", self.executeTarget));
            self.executeTarget = "";
        end
    end
end

-- ********************************************************************
-- * self:AssignDisenchant()                                          *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- ********************************************************************
-- * Decide to assign the loot to a disenchanter.                     *
-- ********************************************************************
local function AssignDisenchant(self)
    if type(self) ~= "table" then return; end

    local status, quality = LootHelper:GetLootStatus(self:GetLink(), self.disenchant);

    self:BeginConfirmation(self.disenchant);
    if ( quality <= 2 ) then
        self:Confirm(true, true);
    end
end

-- ********************************************************************
-- * self:AssignTo(name)                                              *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- ********************************************************************
-- * Assign the loot to the given person.                             *
-- * A confirmation will then be asked.                               *
-- ********************************************************************
local function AssignTo(self, name)
    if type(self) ~= "table" then return; end

    local status, quality = LootHelper:GetLootStatus(self:GetLink(), name);

    self:BeginConfirmation(name);
    if ( status == "OK" ) then
        self:Confirm(true, true);
elseif ( status == "UNUSABLE" ) then
        self:OutputMessage(Root.FormatLoc("LA-Unusable", name));
elseif ( status == "MERIT" ) then
        self:OutputMessage(Root.FormatLoc("LA-MeritLow", name));
    end
end

-- ********************************************************************
-- * self:BeginConfirmation(who)                                      *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- * >> who: who shall receive the loot.                              *
-- ********************************************************************
-- * Ask a confirmation to give the loot to.                          *
-- ********************************************************************
local function BeginConfirmation(self, who)
    if type(self) ~= "table" then return; end
    if ( self.executeState ~= "STANDBY" ) then return; end

    self.executeTarget = who;
    self.executeState = "CONFIRM";
    self:OutputMessage(Root.FormatLoc("LA-ConfirmAssign", who));

    self:CheckButtons();

    self.confirmLevel = 0;
    self:SetBar(nil, 1);
end

-- ********************************************************************
-- * self:Confirm(state[, atOnce])                                    *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- * >> state: if set, the loot is confirmed. If not, the             *
-- * confirmation is aborted. Several confirmations in a row are      *
-- * needed to validate the loot distribution.                        *
-- * >> atOnce: if true, the user will not have to spam confirm.      *
-- ********************************************************************
-- * Assign the loot to the given person.                             *
-- * A confirmation will then be asked.                               *
-- ********************************************************************
local function Confirm(self, state, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.executeState ~= "CONFIRM" ) then return; end

    if ( not state ) then
        self.executeState = "STANDBY";
        self:OutputMessage(Root.Localise("LA-EnterName"));
        self.editBox:SetText("");
        self.editBox:SetFocus();
        self.assignee = "";
        self:SetBar(nil, 2);
  else
        self.confirmLevel = min(1, self.confirmLevel + CONFIRM_INCREMENT);
        if ( atOnce ) or ( self.confirmLevel == 1 ) then
            self.executeState = "EXECUTING";
            self:OutputMessage(Root.Localise("LA-Executing"));
            self.editBox:SetText("");
            self.editBox:ClearFocus();

            self.timeOut = TIME_OUT_EXECUTION;
            self.timeOutMax = self.timeOut;
            self:SetBar(nil, 3);

            self.nextCheck = 0.5;
        end
    end

    self:CheckButtons();
end

-- ********************************************************************
-- * self:Execute()                                                   *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- ********************************************************************
-- * Execute the order issued by the user.                            *
-- * Returns -1 = candidate not found (important error !).            *
-- * Returns  0 = loot not found.                                     *
-- * Returns  1 = loot could be granted.                              *
-- ********************************************************************
local function Execute(self)
    if type(self) ~= "table" then return false; end

    local i, j;
    for i=1, GetNumLootItems() do
        if ( GetLootSlotLink(i) == self:GetLink() ) then
            for j=1, 40 do
                if ( GetMasterLootCandidate(j) == self.executeTarget ) then
                    GiveMasterLoot(i, j);
                    return 1;
                end
            end
            return -1;
        end
    end

    return 0;
end

-- ********************************************************************
-- * self:OutputMessage(text)                                         *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- * >> text: output a message on the loot assigner.                  *
-- ********************************************************************
-- * Output a message on the loot assigner, generally to explain why  *
-- * a loot can't be given.                                           *
-- ********************************************************************
local function OutputMessage(self, text)
    if type(self) ~= "table" then return; end

    self.messageText:SetText(text);
end

-- ********************************************************************
-- * self:IsFree()                                                    *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- ********************************************************************
-- * Determinate if the loot assigner is free of task.                *
-- ********************************************************************
local function IsFree(self)
    if type(self) ~= "table" then return false; end
 
    return (self.status == "STANDBY" or self.status == "CLOSING");
end

-- ********************************************************************
-- * self:GetLink()                                                   *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- ********************************************************************
-- * Get the item link of the item handled by the loot assigner.      *
-- ********************************************************************
local function GetLink(self)
    if type(self) ~= "table" then return ""; end
    return self.itemLink or "\124cffFFCC00\124Hitem:6948:0:0:0:0:0:0:0\124h[Hearthstone]\124h\124r";
end

-- ********************************************************************
-- * self:CheckButtons()                                              *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- ********************************************************************
-- * Set the messages and click authorizations on buttons.            *
-- ********************************************************************
local function CheckButtons(self)
    if type(self) ~= "table" then return; end

    if ( self.executeState == "STANDBY" ) then
        local assignee, disenchant = self.assignee, self.disenchant;

        if ( not assignee ) or ( #assignee == 0 ) then
            self.assignButton:Enable();
            self.assignButton:SetText(Root.Localise("LA-List"));
      else
            local uid = Root.Unit.GetUID(assignee);
            local ok = false;
            if ( uid ) then ok = UnitInRaid(uid) or UnitInParty(uid); end
            if ( ok ) then
                self.assignButton:Enable();
          else
                self.assignButton:Disable();
            end
            self.assignButton:SetText(Root.Localise("LA-Assign"));
        end
        if ( #disenchant == 0 ) or ( self.disenchantTimer > 0 ) then
            self.disenchantButton:Disable();
      else
            self.disenchantButton:Enable();
        end
        self.disenchantButton:SetText(Root.Localise("LA-Disenchant"));

elseif ( self.executeState == "CONFIRM" or self.executeState == "EXECUTING" ) then
        self.assignButton:SetText(Root.Localise("LA-Confirm"));
        self.disenchantButton:SetText(CANCEL);

        if ( self.executeState == "CONFIRM" ) then
            self.assignButton:Enable();
            self.disenchantButton:Enable();
      else
            self.assignButton:Disable();
            self.disenchantButton:Disable();
        end
    end

    if ( self.executeState == "EXECUTING" ) then
        self.disenchantText:SetText(Root.Localise("LA-TimeOut"));

elseif ( self.executeState == "CONFIRM" ) then
        self.disenchantText:SetText(Root.Localise("LA-ConfirmBar"));

elseif ( self.executeState == "STANDBY" ) then
        if ( self.disenchantTimer > 0 ) then
            self.disenchantText:SetText(Root.Localise("LA-DisenchantAuth"));
    elseif ( #self.disenchant == 0 ) then
            self.disenchantText:SetText(Root.Localise("LA-DisenchantNone"));
      else
            self.disenchantText:SetText(Root.FormatLoc("LA-DisenchantReady", self.disenchant));
        end
    end
end

-- ********************************************************************
-- * self:SetBar([percent, layout])                                   *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- * >> percent: if set, this is the new percent to set the bar at.   *
-- * >> layout: set the color of the bar.                             *
-- ********************************************************************
-- * Set the bar value and appearance.                                *
-- ********************************************************************
local function SetBar(self, percent, layout)
    if type(self) ~= "table" then return; end

    if ( percent ) then
        if ( percent > 0 ) then
            self.disenchantBar:SetWidth((BAR_WIDTH-1) * percent);
            self.disenchantBar:Show();
      else
            self.disenchantBar:Hide();
        end
    end

    if ( layout ) then
        self.disenchantBar:SetTexCoord(0, 1, (layout*8)/32, (layout*8+2)/32);
    end
end

-- ********************************************************************
-- * self:OpenNameList()                                              *
-- ********************************************************************
-- * >> self: the loot assigner.                                      *
-- ********************************************************************
-- * Open a dropdown containing an ordered list of all possible names.*
-- ********************************************************************
local function OpenNameList(self)
    if type(self) ~= "table" then return; end

    HideDropDownMenu(1);
    ToggleDropDownMenu(1, nil, self.dropDown, "cursor");
    PlaySound("igMainMenuOpen");
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function LootAssigner.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;
    self.test = false;
    self.itemLink = nil;
    self.nextCheck = CHECK_INTERVAL;
    self.timeOut = 0;
    self.timeOutMax = 1;
    self.assignee = "";
    self.disenchant = "";
    self.disenchantTimer = 0;
    self.disenchantTimerMax = 1;
    self.executeTarget = "";
    self.executeState = "STANDBY";
    self.confirmLevel = 0;
    self.list = { };

    -- Methods
    self.Start = Start;
    self.Remove = Remove;
    self.Check = Check;
    self.AssignDisenchant = AssignDisenchant;
    self.AssignTo = AssignTo;
    self.BeginConfirmation = BeginConfirmation;
    self.Confirm = Confirm;
    self.Execute = Execute;
    self.OutputMessage = OutputMessage;
    self.IsFree = IsFree;
    self.GetLink = GetLink;
    self.CheckButtons = CheckButtons;
    self.SetBar = SetBar;
    self.OpenNameList = OpenNameList;

    -- Children
    self.title = Root.CreateFontString(self, "OVERLAY", "Big", nil, "MIDDLE", "BOTTOM");
    self.title:SetHeight(32);
    self.title:SetPoint("BOTTOM", self, "TOP", 0, -8);
    self.title:SetText(Root.Localise("LootAssigner"));
    self.title:Show();

    self.disenchantButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.disenchantButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -8, 8);
    self.disenchantButton:SetWidth(104);
    self.disenchantButton:SetHeight(24);
    self.disenchantButton:SetScript("OnClick", LootAssigner.OnDisenchantButtonClick);
    self.disenchantButton:Show();

    self.assignButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.assignButton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -8, -46);
    self.assignButton:SetWidth(104);
    self.assignButton:SetHeight(24);
    self.assignButton:SetScript("OnClick", LootAssigner.OnAssignButtonClick);
    self.assignButton:Show();

    self.disenchantBar = self:CreateTexture(nil, "BORDER");
    self.disenchantBar:SetTexture(BAR_TEXTURE);
    self.disenchantBar:SetHeight(3);
    self.disenchantBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 8, 8);
    self.disenchantBar:Show();

    self.disenchantBg = self:CreateTexture(nil, "BACKGROUND");
    self.disenchantBg:SetTexture(BAR_TEXTURE);
    self.disenchantBg:SetTexCoord(0, 1, 0/32, 4/32);
    self.disenchantBg:SetWidth(BAR_WIDTH);
    self.disenchantBg:SetHeight(4);
    self.disenchantBg:SetPoint("TOPLEFT", self.disenchantBar, "TOPLEFT", 0, 0);
    self.disenchantBg:Show();

    self.disenchantText = Root.CreateFontString(self, "OVERLAY", "SmallYellow", nil, "LEFT", "TOP");
    self.disenchantText:SetWidth(148);
    self.disenchantText:ClearAllPoints();
    self.disenchantText:SetPoint("BOTTOMLEFT", self.disenchantBar, "TOPLEFT", 0, 0);
    self.disenchantText:Show();

    self.messageText = Root.CreateFontString(self, "OVERLAY", "SmallYellow", nil, "LEFT", "TOP");
    self.messageText:ClearAllPoints();
    self.messageText:SetPoint("TOPLEFT", self, "TOPLEFT", 50, -8);
    self.messageText:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -8, -40);
    self.messageText:Show();

    self.editBox = CreateFrame("EditBox", nil, self, "BossEncounter2_LootAssignerEditBoxTemplate");
    self.editBox:SetPoint("TOPLEFT", self, "TOPLEFT", 16, -42);

    self.itemButton = CreateFrame("Button", nil, self, "BossEncounter2_LootAssignerIconTemplate");
    self.itemButton:SetPoint("TOPLEFT", self, "TOPLEFT", 8, -8);

    self.dropDown = CreateFrame("Frame", self:GetName().."DropDown", self, "UIDropDownMenuTemplate");
    UIDropDownMenu_Initialize(self.dropDown, LootAssigner.InitializeDropDown, "MENU");

    -- Make draggable.
    Root.MakeDraggable(self, nil, nil, nil);

    -- Clamped!
    self:SetClampedToScreen(true);

    Root.SetBackdrop(self, "TOOLTIP");
end

function LootAssigner.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    local alpha = 1.00;

    -- Open/close
    if ( self.status == "OPENING" ) then
        self.timer = max(0, self.timer - elapsed);
        alpha = 1 - self.timer / FADE_TIME;
        if ( self.timer == 0 ) then self.status = "RUNNING"; end
    end
    if ( self.status == "CLOSING" ) then
        self.timer = max(0, self.timer - elapsed);
        alpha = self.timer / FADE_TIME;
        if ( self.timer == 0 ) then self:Remove(true); end
    end

    self.nextCheck = max(0, self.nextCheck - elapsed);
    if ( self.nextCheck == 0 ) then
        self:Check();
    end

    self:CheckButtons();

    -- Handle disenchant/confirm/time-out timers
    if ( self.executeState == "EXECUTING" ) then
        self.timeOut = max(0, self.timeOut - elapsed);
        self:SetBar(self.timeOut / self.timeOutMax);
        if ( self.timeOut == 0 ) then
            self:Remove();
        end
elseif ( self.executeState == "CONFIRM" ) then
        self.confirmLevel = max(0, self.confirmLevel - elapsed * CONFIRM_DECREMENT_RATE);
        self:SetBar(self.confirmLevel);

elseif ( self.executeState == "STANDBY" ) then
        if ( self.status == "RUNNING" ) then
            self.disenchantTimer = max(0, self.disenchantTimer - elapsed);
        end
        self:SetBar(self.disenchantTimer / self.disenchantTimerMax);
    end

    -- Application on the frame
    self:SetAlpha(alpha);
    self:SetScale(max(0.01, alpha));
end

function LootAssigner.OnDisenchantButtonClick(button, click)
    local self = button:GetParent(); -- self is the LootAssigner.

    if ( self.executeState == "STANDBY" ) then
        self:AssignDisenchant();
elseif ( self.executeState == "CONFIRM" ) then
        self:Confirm(false);
    end
end

function LootAssigner.OnAssignButtonClick(button, click)
    local self = button:GetParent(); -- self is the LootAssigner.

    if ( self.executeState == "STANDBY" ) then
        local assignee = self.assignee;
        if ( not assignee ) or ( #assignee == 0 ) then
            self:OpenNameList();
      else
            self:AssignTo(assignee);
        end
elseif ( self.executeState == "CONFIRM" ) then
        self:Confirm(true);
    end
end

function LootAssigner.OnEditBoxChanged(editBox)
    local self = editBox:GetParent(); -- self is the LootAssigner.

    -- Try to autocomplete the edit box
    -- TODO

    if ( self.executeState == "STANDBY" ) then
        self.assignee = editBox:GetText();
    end
    self:CheckButtons();
end

function LootAssigner.OnEditBoxEnter(editBox)
    local self = editBox:GetParent(); -- self is the LootAssigner.

    self.assignButton:Click();
end

function LootAssigner.PlayerNameAutocomplete(self, char)
    local text = self:GetText();
    local textLen = strlen(text);
    local i, name;

    if ( not text ) or ( textLen == 0 ) then return; end

    wipe(enum);
    Root.Unit.EnumerateRaid(enum);

    for i=1, #enum do
        name = UnitName(enum[i]);
        if ( name and (strfind(strupper(name), strupper(text), 1, 1) == 1) ) then
            self:SetText(name);
            if ( self:IsInIMECompositionMode() ) then
                self:HighlightText(textLen - strlen(char), -1);
          else
                self:HighlightText(textLen, -1);
            end
            return;
        end
    end
end

function LootAssigner.InitializeDropDown()
    local dropDown = UIDropDownMenu_GetCurrentDropDown();
    local frame = dropDown:GetParent();
    local list = frame.list;
    local i, nameList, name, info;

    wipe(enum);
    Root.Unit.EnumerateRaid(enum);
    wipe(list);

    for i=1, #enum do
        name = UnitName(enum[i]);
        if ( name ~= UNKNOWN ) then
            tinsert(list, name);
        end
    end

    -- Sort alphabetically the names.

    Root.Sort.ByName(list, false);

    -- Add special random command

    if ( #list > 0 ) then
        list[0] = Root.Localise("LA-Random");
    end

    -- Create the dropdown buttons.

    for i=0, #list do
        info              = UIDropDownMenu_CreateInfo();
        info.text         = list[i];
        info.func         = INSERTNAME_FUNC;
        info.arg1         = frame;
        info.arg2         = list[i];
        info.notCheckable = true;
        UIDropDownMenu_AddButton(info);
    end
end