local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");
local Anchor = Root.GetOrNewModule("Anchor");
local Engine = Root.GetOrNewModule("Engine");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Anchor Mode Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- When you ask BossEncounter to edit your anchors, BE2 will try to trigger
-- the anchor edit mode "boss" module. It is a null boss module that is here
-- especially to make sure no real boss module will get fired while messing
-- with the anchors.
-- It also allows to coordinate the tools used to change the anchors.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        ["CopyLayoutExplain"] = "Enter the name of the character whose layout is to be imported.\n\nBe careful, the system is case sensitive.\n\nIf the system does not recognize a character, try logging in on this character first then try again.",
        ["CopySuccess"] = "Importation from %s successful !",
        ["CopyFailed"] = "The importation has failed.",
        ["Explanation"] = "You are in a special mode allowing you to change the position of BossEncounter2 widgets. Exit this mode once you have made your changes to be able to activate boss modules.",
    },
    ["frFR"] = {
        ["CopyLayoutExplain"] = "Entrez le nom du personnage à partir duquel vous souhaitez importer la configuration des gadgets.\n\nAttention, les majuscules et les minuscules doivent être respectées.\n\nSi le système ne reconnaît pas un personnage, essayez d'abord de vous connecter sur ce personnage.",
        ["CopySuccess"] = "Importation à partir |2 %s réussie !",
        ["CopyFailed"] = "L'importation a échoué.",
        ["Explanation"] = "Vous êtes dans un mode spécial vous permettant de changer la position des gadgets de BossEncounter2. Quittez ce mode une fois les changements effectués pour pouvoir enclencher des modules de boss.",
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "AnchorMode";

-- --------------------------------------------------------------------
-- **                       Definition stuff                         **
-- --------------------------------------------------------------------

Root[THIS_MODULE] = {
    -- --------------------------------------------------------------------
    -- **                            Properties                          **
    -- --------------------------------------------------------------------

    running = false, -- Never set this to true.
    data = nil, -- Never set this.
    status = nil,

    openTimer = false,

    -- --------------------------------------------------------------------
    -- **                             Handlers                           **
    -- --------------------------------------------------------------------

    OnStart = function(self)
        Shared.OnStart(self);

        StaticPopupDialogs["BE2_COPY_LAYOUT"] = {
	    text = self:Localize("CopyLayoutExplain"),
	    button1 = OKAY,
            button2 = CANCEL,
            timeout = 0,
            whileDead = 1,
            hasEditBox = 1,
            maxLetters = 24,

            OnAccept = function(self)
                local editBox = getglobal(self:GetName().."EditBox");
                local text = Root[THIS_MODULE]:ConvertText(editBox:GetText());
                Root[THIS_MODULE]:ExecuteCopy(text);
            end,
            OnCancel = function(self) Engine:TriggerSpecialModule(THIS_MODULE); end,
            OnShow = function(self)
                getglobal(self:GetName().."EditBox"):SetFocus();
                getglobal(self:GetName().."EditBox"):SetText("");
                getglobal(self:GetName().."Button1"):Disable();
            end,
            OnHide = function(self)
                if ( ChatFrameEditBox:IsVisible() ) then
                    ChatFrameEditBox:SetFocus();
                end
                getglobal(self:GetName().."EditBox"):SetText("");
            end,
            EditBoxOnTextChanged = function(self)
                local editBox = self;
                local text = Root[THIS_MODULE]:ConvertText(editBox:GetText());
                local button = getglobal(self:GetParent():GetName().."Button1");

                if ( Root[THIS_MODULE]:CheckProfileExists(text) ) then
		    button:Enable();
	        else
		    button:Disable();
		end
            end,
        };
    end,

    OnTrigger = function(self)
        if not self:TriggerMe() then return false; end

        self.openTimer = false;
        self.status = "RUNNING";

        -- Set up the anchor control frame
        self.AnchorControlFrame = Manager:GetAnchorControlFrame();
        self.AnchorControlFrame:Open();

        -- Set up each anchor ghost
        local i, anchorGhost;
        self.data.AnchorGhost = {};
        for i=1, Anchor:GetNumAnchors() do
            anchorGhost = Manager:GetFreeAnchorGhost();
            if ( anchorGhost ) then
                local anchorID = select(5, Anchor:GetAnchorInfo(i));
                anchorGhost:Activate(anchorID);
                tinsert(self.data.AnchorGhost, anchorGhost);
            end
        end

        -- And put some clothes
        Root.Print(self:Localize("Explanation"), true);
        Root.Music.Play("ANCHORMODE");

        return true;
    end,

    OnFinish = function(self)
        if not ( self.running ) then return; end

        self.AnchorControlFrame:Close();

        local i, anchorGhost;
        for i=1, #self.data.AnchorGhost do
            self.data.AnchorGhost[i]:Save();
            self.data.AnchorGhost[i]:Remove();
        end

        Root.Music.Stop();

        self:KillMe();
    end,

    OnFailed = function(self)
        self:OnFinish();
    end,

    OnUpdate = function(self, elapsed)
        if ( self.running ) then return; end

        if type(self.openTimer) == "number" then
            self.openTimer = max(0, self.openTimer - elapsed);
            if ( self.openTimer == 0 ) then
                self.openTimer = false;
                Engine:TriggerSpecialModule(THIS_MODULE);
            end
        end
    end,

    OnCopyQuery = function(self)
        -- Display the popup
        StaticPopup_Show("BE2_COPY_LAYOUT");

        -- And remove meanwhile the anchor mode.
        self:OnFinish();
    end,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    CheckProfileExists = function(self, name)
        local i, num, profileName;
        num = Root.Save.GetNumProfiles();
        for i=1, num do
            profileName = select(1, Root.Save.GetProfileInfo(i));
            if ( profileName == name ) then
                return true;
            end
        end
        return false;
    end,

    ConvertText = function(self, text)
        if ( not text ) then return ""; end
        if type(text) ~= "string" then return ""; end
        if ( #text == 0 ) then return ""; end

        --[[
        local firstChar = string.sub(text, 1, 1);
        local rest = string.sub(text, 2, #text) or "";

        firstChar = string.upper(firstChar);
        rest = string.lower(rest);
        ]]

        return text; -- firstChar..rest;
    end,

    ExecuteCopy = function(self, sourceCharacter)
        local resultMsg = "";
        local success = Anchor:CopyLayout(sourceCharacter);

        if ( success ) then
            Root.Sound.Play("NEWRECORD");
            resultMsg = self:FormatLoc("CopySuccess", sourceCharacter);
      else
            resultMsg = self:Localize("CopyFailed");
        end

        self:NotifyMe(resultMsg, 0.500, 4.000, true);
        self:AskDelayedTrigger(5);
    end,

    AskDelayedTrigger = function(self, timer)
        if ( self.running ) then return; end

        self.openTimer = timer;
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
end