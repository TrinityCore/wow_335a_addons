local Root = BossEncounter2;

local Preload = Root.GetOrNewModule("Preload");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A miscellaneous module that makes sure common textures are put into
-- memory before combat, to avoid loading files during fights.

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local ALLOWED = true;

local fileList = { };

Preload.ready = false;
Preload.autoRun = nil;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Preload:Add(filename)                                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> filename: filename to the texture.                            *
-- ********************************************************************
-- * Add a new texture to be preloaded.                               *
-- ********************************************************************

Preload.Add = function(self, filename)
    if ( fileList[filename] ~= nil ) then
        -- Useless to register the same gfx file two times.
        return;
  else
        fileList[filename] = false;
    end
end

-- ********************************************************************
-- * Preload:Run()                                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Execute the pre-loading: query each texture file and put it in   *
-- * the memory before it is used.                                    *
-- ********************************************************************

Preload.Run = function(self)
    if ( not self.ready ) then return; end

    local texture, loaded;
    for texture, loaded in pairs(fileList) do
        if ( type(texture) == "string" ) and ( not loaded ) then
            self.texture:Show();
            self.texture:SetTexture(texture);
            self.texture:Hide();

            fileList[texture] = true;
        end
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

Preload.OnEnterWorld = function(self)
    if ( not self.ready ) and ( ALLOWED ) then
        self.autoRun = GetTime() + 15; -- preload stuff 15 sec after logging in.

        -- Create the dummy texture to force the loading of gfx files.
        local f = CreateFrame("Frame");
        self.texture = f:CreateTexture(nil, "BACKGROUND");
        self.texture:SetWidth(256);
        self.texture:SetHeight(256);
        self.texture:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 1, 1);
        self.texture:Hide();

        self.ready = true;
    end
end

Preload.OnUpdate = function(self)
    if self.autoRun and GetTime() > self.autoRun and ( not InCombatLockdown() ) then
        self.autoRun = nil;
        self:Run();
    end
end