-----------------------------------------------------------------
-- Header
-----------------------------------------------------------------
	do
		BreadCrumbs = CreateFrame("Frame", "BreadCrumbs", UIParent); --Creates a new UI frame called "BreadCrumbs"
		
		BreadCrumbs.Name = "BreadCrumbs";
		
		BreadCrumbs.Version = GetAddOnMetadata(BreadCrumbs.Name, "Version");
		BreadCrumbs.sVersionType = GetAddOnMetadata(BreadCrumbs.Name, "X-VersionType");
		BreadCrumbs.LoadedStatus = {}; -- Says what stage the addon loading is at.
		BreadCrumbs.LoadedStatus["Initialized"] = false;
	end;
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Libraries
-----------------------------------------------------------------
	local ZMC, L; -- Registering local variables outside hider do
	do
		BreadCrumbs.Astrolabe = DongleStub("Astrolabe-0.4-QuestHelper_ZAS")
		BreadCrumbs.AceHook = LibStub("AceHook-3.0");
		
		L = LibStub("AceLocale-3.0"):GetLocale(BreadCrumbs.Name, false)
		ZMC = LibStub("LibZasMsgCtr-0.2");
		ZMC:Initialize(BreadCrumbs, BreadCrumbs.Name, ZMC.COLOUR_ORANGE, 1) -- Initialize the debugging/messaging library's settings for this addon (CallingAddon, AddonName, DefaultColour1, Debug_Frame, DefaultColour2, DefaultErrorColour, DefaultMsgFrame)
	end;
-----------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------------
-- DEFAULTS and Variable declarations
----------------------------------------------------------------------------------------------------------------------
	local minimapParent, lastX, lastY; -- Pulling local declaration outside hider do
	do
		--------------------------------------------------------------------------
		-- Colour/Opacity defaults
		--------------------------------------------------------------------------
			--------------------------------------------------------
			-- Minimap
			--------------------------------------------------------
				-----------------------------------------
				-- Minimap Colour 1
				-----------------------------------------
					BreadCrumbs.MinimapColour1Default_Red = 1;
					BreadCrumbs.MinimapColour1Default_Green = 0;
					BreadCrumbs.MinimapColour1Default_Blue = 0;
					BreadCrumbs.MinimapColour1Default_TextureOpacity = 1;
				-----------------------------------------
				
				
				
				
				-----------------------------------------
				-- Minimap Colour 2
				-----------------------------------------
					BreadCrumbs.MinimapColour2Default_Red = 0;
					BreadCrumbs.MinimapColour2Default_Green = 0.145;
					BreadCrumbs.MinimapColour2Default_Blue = 1;
					BreadCrumbs.MinimapColour2Default_TextureOpacity = 0;
				-----------------------------------------
			--------------------------------------------------------
			
			
			
			
			
			--------------------------------------------------------
			-- HUD
			--------------------------------------------------------
				-----------------------------------------
				-- HUD Colour 1
				-----------------------------------------
					BreadCrumbs.HUDColour1Default_Red = 1;
					BreadCrumbs.HUDColour1Default_Green = 0;
					BreadCrumbs.HUDColour1Default_Blue = 0;
					BreadCrumbs.HUDColour1Default_TextureOpacity = 0.4;
				-----------------------------------------
				
				
				
				
				-----------------------------------------
				-- HUD Colour 2
				-----------------------------------------
					BreadCrumbs.HUDColour2Default_Red = 1;
					BreadCrumbs.HUDColour2Default_Green = 0;
					BreadCrumbs.HUDColour2Default_Blue = 0;
					BreadCrumbs.HUDColour2Default_TextureOpacity = 0.2;
				-----------------------------------------
			--------------------------------------------------------
		--------------------------------------------------------------------------
		
		
		
		
		
		--------------------------------------------------------
		-- Arrays for Storing Gradiant Changes
		--------------------------------------------------------
			BreadCrumbs.aryRedMiniMap = {};
			BreadCrumbs.aryGreenMiniMap = {};
			BreadCrumbs.aryBlueMiniMap = {};
			BreadCrumbs.aryTextureOpacityMiniMap = {};
			
			BreadCrumbs.aryRedHUD = {};
			BreadCrumbs.aryGreenHUD = {};
			BreadCrumbs.aryBlueHUD = {};
			BreadCrumbs.aryTextureOpacityHUD = {};
		--------------------------------------------------------
		
		minimapParent = Minimap -- Store a reference to the minimap parent
		lastX, lastY = 0,0; -- Starting values
		
		BreadCrumbs.DistBetweenPointsDefault = 10;
		
		BreadCrumbs.MinimapSizeOfPoints1Default_Width = 4;
		BreadCrumbs.MinimapSizeOfPoints1Default_Height = 4;
		BreadCrumbs.MinimapSizeOfPoints2Default_Width = 4;
		BreadCrumbs.MinimapSizeOfPoints2Default_Height = 4;
		
		BreadCrumbs.HUDSizeOfPoints1Default_Width = 30;
		BreadCrumbs.HUDSizeOfPoints1Default_Height = 30;
		BreadCrumbs.HUDSizeOfPoints2Default_Width = 30;
		BreadCrumbs.HUDSizeOfPoints2Default_Height = 30;
		
		BreadCrumbs.DefaultNumPoints = 40; -- Default number of points to store (The more the longer the trail will be)
		
		BreadCrumbs.CurGradiantOffset = 0; -- Stores the offset between the points and which one is the last placed point (end of trail next to you)
		
		BreadCrumbs.HiddenTexture = "";
		BreadCrumbs.DefaultTexture = "Interface\\AddOns\\BreadCrumbs\\Artwork\\PointBlob.tga";
		
		BreadCrumbs.Default_MinimapColour1_Name = "to"; -- This is the default for MinimapColour1_Name
		BreadCrumbs.Default_HUDColour1_Name = "to"; -- This is the default for HUDColour1_Name
		
		BreadCrumbs.Default_LastNumToHide =  3;
		BreadCrumbs.Default_Hidden = false;
		BreadCrumbs.Default_Dropping = true;
		BreadCrumbs.Default_Enabled = true;
		BreadCrumbs.Default_MinimapGradiant = true;
		BreadCrumbs.Default_HUDColourGradiant = false;
		BreadCrumbs.Default_DontDropWhenDead = true;
		BreadCrumbs.Default_ResetOnReload = true;
		BreadCrumbs.Default_RepairInterfaceOptionsFrameStrata = "HIGH";
		BreadCrumbs.Default_RepairInterfaceOptionsFrameStrataTog = true;
	end;
----------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------
-- KeyBinding Variables
-----------------------------------------------------------------
	do
		BINDING_HEADER_BREADCRUMBS = "BreadCrumbs";
		BINDING_NAME_BreadCrumbs_ToggleAddon = L["Enable/Disable BreadCrumbs"];
		BINDING_NAME_BreadCrumbs_ToggleBreadDrop = L["Start/Stop Dropping BreadCrumbs"];
		BINDING_NAME_BreadCrumbs_ToggleHideBread = L["Hide/Show BreadCrumbs"];
		BINDING_NAME_BreadCrumbs_ToggleDropWhenDead = L["Start/Stop Dropping BreadCrumbs when Dead"];
	end;
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Local Functions
-----------------------------------------------------------------
	local function TableCount(tab) -- TableCount: Counts table members
		if (tab == nil) then -- return 0
			return 0;
		else
			local n=0;
			
			for _ in pairs(tab) do
				n=n+1;
			end;
			
			return n;
		end;
	end;
-----------------------------------------------------------------

function BreadCrumbs:OnEvent(event)
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:OnEvent("..tostring(event)..") self.LoadedStatus[Initialized] = "..tostring(self.LoadedStatus["Initialized"]).." arg1 = "..tostring(arg1),true,DebugTxt);
	
	if (event == "ADDON_LOADED" and self.LoadedStatus["Initialized"] == false and arg1 == "BreadCrumbs") then
		ZMC:Msg(self, "event == ADDON_LOADED and self.LoadedStatus[Initialized] == false and arg1 == BreadCrumbs",true,DebugTxt);
		
		self:Initialize();
	end;
end;

function BreadCrumbs:VarInit() -- Initialize the variables
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:VarInit()",true,DebugTxt);
	
	BreadCrumbs_Options = BreadCrumbs_Options or {}; -- Initializes BreadCrumbs_Options if it doesn't already exist
	BreadCrumbs_Options["NumPoints"] = BreadCrumbs_Options["NumPoints"] or self.DefaultNumPoints; -- Initializes BreadCrumbs_Options["NumPoints"] with the default value if it doesn't already exist
	if (BreadCrumbs_Options["NumPoints"] < 2) then BreadCrumbs_Options["NumPoints"] = 2; end; -- Ensures there are at lest 2 points to stop /0 errors
	
	--------------------------------------------------------------------------
	-- Colour, Opacity & Width
	--------------------------------------------------------------------------
		--------------------------------------------------------
		-- Minimap
		--------------------------------------------------------
			-----------------------------------------
			-- Minimap Colour 1
			-----------------------------------------
				BreadCrumbs_Options.MinimapColour1 = BreadCrumbs_Options.MinimapColour1 or {};
				BreadCrumbs_Options.MinimapColour1.Red = BreadCrumbs_Options.MinimapColour1.Red or self.MinimapColour1Default_Red;
				BreadCrumbs_Options.MinimapColour1.Green = BreadCrumbs_Options.MinimapColour1.Green or self.MinimapColour1Default_Green;
				BreadCrumbs_Options.MinimapColour1.Blue = BreadCrumbs_Options.MinimapColour1.Blue or self.MinimapColour1Default_Blue;
				BreadCrumbs_Options.MinimapColour1.TextureOpacity = BreadCrumbs_Options.MinimapColour1.TextureOpacity or self.MinimapColour1Default_TextureOpacity;
			-----------------------------------------
			
			
			
			
			-----------------------------------------
			-- Minimap Colour 2
			-----------------------------------------
				BreadCrumbs_Options.MinimapColour2 = BreadCrumbs_Options.MinimapColour2 or {};
				BreadCrumbs_Options.MinimapColour2.Red = BreadCrumbs_Options.MinimapColour2.Red or self.MinimapColour2Default_Red;
				BreadCrumbs_Options.MinimapColour2.Green = BreadCrumbs_Options.MinimapColour2.Green or self.MinimapColour2Default_Green;
				BreadCrumbs_Options.MinimapColour2.Blue = BreadCrumbs_Options.MinimapColour2.Blue or self.MinimapColour2Default_Blue;
				BreadCrumbs_Options.MinimapColour2.TextureOpacity = BreadCrumbs_Options.MinimapColour2.TextureOpacity or self.MinimapColour2Default_TextureOpacity;
			-----------------------------------------
			
			
			
			
			-----------------------------------------
			-- Minimap Width 1 & 2
			-----------------------------------------
				BreadCrumbs_Options.MinimapSizeOfPoints1_Width = BreadCrumbs_Options.MinimapSizeOfPoints1_Width or self.MinimapSizeOfPoints1Default_Width;
				BreadCrumbs_Options.MinimapSizeOfPoints2_Width = BreadCrumbs_Options.MinimapSizeOfPoints2_Width or self.MinimapSizeOfPoints2Default_Width;
			-----------------------------------------
			
			
			
			
			-----------------------------------------
			-- Minimap Height 1 & 2
			-----------------------------------------
				BreadCrumbs_Options.MinimapSizeOfPoints1_Height = BreadCrumbs_Options.MinimapSizeOfPoints1_Height or self.MinimapSizeOfPoints1Default_Height;
				BreadCrumbs_Options.MinimapSizeOfPoints2_Height = BreadCrumbs_Options.MinimapSizeOfPoints2_Height or self.MinimapSizeOfPoints2Default_Height;
			-----------------------------------------
		--------------------------------------------------------
		
		
		
		
		
		--------------------------------------------------------
		-- HUD
		--------------------------------------------------------
			-----------------------------------------
			-- HUD Colour 1
			-----------------------------------------
				BreadCrumbs_Options.HUDColour1 = BreadCrumbs_Options.HUDColour1 or {};
				BreadCrumbs_Options.HUDColour1.Red = BreadCrumbs_Options.HUDColour1.Red or self.HUDColour1Default_Red;
				BreadCrumbs_Options.HUDColour1.Green = BreadCrumbs_Options.HUDColour1.Green or self.HUDColour1Default_Green;
				BreadCrumbs_Options.HUDColour1.Blue = BreadCrumbs_Options.HUDColour1.Blue or self.HUDColour1Default_Blue;
				BreadCrumbs_Options.HUDColour1.TextureOpacity = BreadCrumbs_Options.HUDColour1.TextureOpacity or self.HUDColour1Default_TextureOpacity;
			-----------------------------------------
			
			
			
			
			-----------------------------------------
			-- HUD Colour 2
			-----------------------------------------
				BreadCrumbs_Options.HUDColour2 = BreadCrumbs_Options.HUDColour2 or {};
				BreadCrumbs_Options.HUDColour2.Red = BreadCrumbs_Options.HUDColour2.Red or self.HUDColour2Default_Red;
				BreadCrumbs_Options.HUDColour2.Green = BreadCrumbs_Options.HUDColour2.Green or self.HUDColour2Default_Green;
				BreadCrumbs_Options.HUDColour2.Blue = BreadCrumbs_Options.HUDColour2.Blue or self.HUDColour2Default_Blue;
				BreadCrumbs_Options.HUDColour2.TextureOpacity = BreadCrumbs_Options.HUDColour2.TextureOpacity or self.HUDColour2Default_TextureOpacity;
			-----------------------------------------
			
			
			
			
			-----------------------------------------
			-- HUD Width 1 & 2
			-----------------------------------------
				BreadCrumbs_Options.HUDSizeOfPoints1_Width = BreadCrumbs_Options.HUDSizeOfPoints1_Width or self.HUDSizeOfPoints1Default_Width;
				BreadCrumbs_Options.HUDSizeOfPoints2_Width = BreadCrumbs_Options.HUDSizeOfPoints2_Width or self.HUDSizeOfPoints2Default_Width;
			-----------------------------------------
			
			
			
			
			-----------------------------------------
			-- HUD Height 1 & 2
			-----------------------------------------
				BreadCrumbs_Options.HUDSizeOfPoints1_Height = BreadCrumbs_Options.HUDSizeOfPoints1_Height or self.HUDSizeOfPoints1Default_Height;
				BreadCrumbs_Options.HUDSizeOfPoints2_Height = BreadCrumbs_Options.HUDSizeOfPoints2_Height or self.HUDSizeOfPoints2Default_Height;
			-----------------------------------------
		--------------------------------------------------------
	--------------------------------------------------------------------------
	
	BreadCrumbs_Options.DistBetweenPoints = BreadCrumbs_Options.DistBetweenPoints or self.DistBetweenPointsDefault;
	BreadCrumbs_Options.LastNumToHide = BreadCrumbs_Options.LastNumToHide or self.Default_LastNumToHide;
	BreadCrumbs_Options.MovementHistory = BreadCrumbs_Options.MovementHistory or {};
	
	
	if (BreadCrumbs_Options.Hidden == nil) then -- Initializes BreadCrumbs_Options.Hidden with the default value of self.Default_Hidden if it doesn't already exist
		BreadCrumbs_Options.Hidden = self.Default_Hidden;
	end;
	
	if (BreadCrumbs_Options.Dropping == nil) then -- Initializes BreadCrumbs_Options.Dropping with the default value of self.Default_Dropping if it doesn't already exist
		BreadCrumbs_Options.Dropping = self.Default_Dropping;
	end;
	
	if (BreadCrumbs_Options["Enabled"] == nil) then -- Initializes BreadCrumbs_Options["Enabled"] with the default value of self.Default_Enabled if it doesn't already exist
		BreadCrumbs_Options["Enabled"] = self.Default_Enabled;
	end;
	
	if (BreadCrumbs_Options["MinimapGradiant"] == nil) then -- Initializes BreadCrumbs_Options["MinimapGradiant"] with the default value of self.Default_MinimapGradiant if it doesn't already exist
		BreadCrumbs_Options["MinimapGradiant"] = self.Default_MinimapGradiant;
	end;
	
	if (BreadCrumbs_Options["HUDColourGradiant"] == nil) then -- Initializes BreadCrumbs_Options["HUDColourGradiant"] with the default value of self.Default_HUDColourGradiant if it doesn't already exist
		BreadCrumbs_Options["HUDColourGradiant"] = self.Default_HUDColourGradiant;
	end;
	
	if (BreadCrumbs_Options["DontDropWhenDead"] == nil) then -- Initializes BreadCrumbs_Options["DontDropWhenDead"] with the default value of self.Default_DontDropWhenDead if it doesn't already exist
		BreadCrumbs_Options["DontDropWhenDead"] = self.Default_DontDropWhenDead;
	end;
	
	if (BreadCrumbs_Options["ResetOnReload"] == nil) then -- Initializes BreadCrumbs_Options["ResetOnReload"] with the default value of self.Default_ResetOnReload if it doesn't already exist
		BreadCrumbs_Options["ResetOnReload"] = self.Default_ResetOnReload;
	end;
	
	if (BreadCrumbs_Options["RepairInterfaceOptionsFrameStrata"] == nil) then -- Initializes BreadCrumbs_Options.RepairInterfaceOptionsFrameStrata with the default value of self.Default_RepairInterfaceOptionsFrameStrata if it doesn't already exist
		BreadCrumbs_Options["RepairInterfaceOptionsFrameStrata"] = self.Default_RepairInterfaceOptionsFrameStrata;
	end;
	
	if (BreadCrumbs_Options["RepairInterfaceOptionsFrameStrataTog"] == nil) then -- Initializes BreadCrumbs_Options["RepairInterfaceOptionsFrameStrataTog"] with the default value of self.Default_RepairInterfaceOptionsFrameStrataTog if it doesn't already exist
		BreadCrumbs_Options["RepairInterfaceOptionsFrameStrataTog"] = self.Default_RepairInterfaceOptionsFrameStrataTog;
	end;
	
	
	
	
	
	
	if (BreadCrumbs_Options["CurrentDBVersion"] == nil) then -- Initializes BreadCrumbs_Options["CurrentDBVersion"] with the default value of self.Version if it doesn't already exist
		BreadCrumbs_Options["CurrentDBVersion"] = self.Version;
	end;
	
	
	
	
	
	
	if BreadCrumbs_Options.Hidden then
		BreadCrumbs_Options.Texture = self.HiddenTexture;
	else
		BreadCrumbs_Options.Texture = self.DefaultTexture;
	end;
	
	
	
	self.last_update = 0 -- Resets the time since the last update was performed
	self.LoadedStatus["AddonVariables"] = true;
end

function BreadCrumbs:Initialize() -- Initialize the addon
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:Initialize()",true,DebugTxt);
	
	self:UnregisterEvent("ADDON_LOADED");
	
	self:VarInit(); -- Initialize the variables
	
	--- Slash Command Handler
	SLASH_BreadCrumbs1 = "/BC";
	SLASH_BreadCrumbs2 = "/BreadCrumbs";
	SlashCmdList["BreadCrumbs"] = function(msg)
		self:SlashCmdHandler(msg);
	end;
	
	if not self.UpdateFrame then
		self.UpdateFrame = CreateFrame("Frame")
		self.UpdateFrame:SetScript("OnUpdate", function(frame, elapsed) BreadCrumbs:Update(frame, elapsed); end)
	end
	
	if (HudMapCluster) then -- If the SexyMap HUD exists then hook it's show and hide scripts
		self.AceHook:HookScript(HudMapCluster, "OnShow", function() BreadCrumbs:HudMapCluster_OnShow(); end)
		self.AceHook:HookScript(HudMapCluster, "OnHide", function() BreadCrumbs:HudMapCluster_OnHide(); end)
	end;
	
	if not(BreadCrumbs_Options["CurrentDBVersion"] == self.Version) then -- Checks if the current DBVersion is the same as the current version and if not
		-- All old DB are currently compatable with newer ones so all SHOULD be OK
		BreadCrumbs_Options["CurrentDBVersion"] = self.Version; -- Set the CurrentDBVersion version to this DB version
		
		ZMC:Msg(self, "WARNING: You have updated BreadCrumbs to a new version. If you have any trouble try resetting the settings to default using the command '/bc reset'.", false, DebugTxt, true); -- Warn the user that they have updated to a newer version of BreadCrumbs so if they have problems they should reset all the BC settings
	end;
	
	ZMC:Msg(self, "BreadCrumbs_Options.ResetOnReload = "..tostring(BreadCrumbs_Options["ResetOnReload"]).." (TableCount(BreadCrumbs_Options[MovementHistory]) == 0) = "..tostring((TableCount(BreadCrumbs_Options["MovementHistory"]) == 0)).."", true, DebugTxt);
	self:AddInterfaceOptions(); -- Creates and adds the options window to the Bliz interface tab
	
	if ((TableCount(BreadCrumbs_Options["MovementHistory"]) == 0) or BreadCrumbs_Options["ResetOnReload"]) then -- Initializes self.Points if it doesn't already exist
		ZMC:Msg(self, "No points so generate them", true, DebugTxt);
		self:GeneratePoints(); -- Creates the frames (points) that will be used as the points on the map
	else -- There are already points so just restart 
		ZMC:Msg(self, "There are already points so just restart", true, DebugTxt);
		self:ReAddPoints(); -- Removes and then readds the points to the minimap etc...
	end;
	
	if BreadCrumbs_Options.Hidden then
		ZMC:Msg(self, L["WARNING: BreadCrumb trail Hidden!"],false,DebugTxt,true);
	end;
	
	if not(BreadCrumbs_Options.Dropping) then
		ZMC:Msg(self, L["WARNING: BreadCrumb dropping disabled!"],false,DebugTxt,true);
	end;
	
	if not(BreadCrumbs_Options["Enabled"]) then
		ZMC:Msg(self, L["WARNING: Addon disabled!"],false,DebugTxt,true);
	end;
	
	self:TogAddon(BreadCrumbs_Options["Enabled"]);
	
	self.LoadedStatus["Initialized"] = true;
	
	ZMC:Msg(self, L["Loaded"]);
end;

function BreadCrumbs:CalGradiant(Value1, Value2, NumPoints) -- Calculates the gradiant between two values
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:CalGradiant(Value1 = "..tostring(Value1)..", Value2 = "..tostring(Value2)..", NumPoints = "..tostring(NumPoints).."))",true,DebugTxt);
	
	------------------------------------
	-- Calculate Differences
	------------------------------------
		local Diff = Value1 - Value2;
	------------------------------------
	
	
	
	
	
	------------------------------------
	-- Calculate Steps
	------------------------------------
		local Step = Diff / (NumPoints - 1); -- -1 is used as we want the number of changes from the lowest value to highest NOT the number of points (To prevent /0 errors you can't have less than 2 points!)
	------------------------------------
	
	
	ZMC:Msg(self, "Diff = "..tostring(Diff).." Step = "..tostring(Step).."", true, DebugTxt);
	
	
	------------------------------------
	-- Clear Arrays
	------------------------------------
		local returnAry = {};
	------------------------------------
	
	
	
	
	------------------------------------
	-- Sets up values for first loop
	------------------------------------
		local CurentValue = Value1;
	------------------------------------
	
	
	
	
	
	------------------------------------------------
	-- Loop for every point required
	------------------------------------------------
		for i=1, NumPoints do
			returnAry[i] = CurentValue;
			
			-- ZMC:Msg(self, "i = "..tostring(i).." CurentValue = "..tostring(CurentValue).."", true, DebugTxt);
			
			if (i == (NumPoints - 1)) then -- This is the final loop so don't bother calculating it
				-- ZMC:Msg(self, "i == (NumPoints - 1)", true, DebugTxt);
				
				CurentValue = Value2;
			else
				-- ZMC:Msg(self, "not(i == (NumPoints - 1))", true, DebugTxt);
				
				CurentValue = CurentValue - Step;
			end;
		end;
	------------------------------------------------
	
	return returnAry; -- Return the array
end;

function BreadCrumbs:UpdateGradiants() -- Updates the gradiants with any new colours/transparancys
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:UpdateGradiants()",true,DebugTxt);
	
	------------------------------------------------------------------------------------------------------
	-- Update MinimapGradiant if required
	------------------------------------------------------------------------------------------------------
		if (BreadCrumbs_Options.MinimapGradiant) then -- Minimap Gradiant is enabled so calculate them
			self.aryRedMiniMap = self:CalGradiant(BreadCrumbs_Options.MinimapColour1.Red, BreadCrumbs_Options.MinimapColour2.Red, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of Red
			self.aryGreenMiniMap = self:CalGradiant(BreadCrumbs_Options.MinimapColour1.Green, BreadCrumbs_Options.MinimapColour2.Green, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of Green
			self.aryBlueMiniMap = self:CalGradiant(BreadCrumbs_Options.MinimapColour1.Blue, BreadCrumbs_Options.MinimapColour2.Blue, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of Blue
			self.aryTextureOpacityMiniMap = self:CalGradiant(BreadCrumbs_Options.MinimapColour1.TextureOpacity, BreadCrumbs_Options.MinimapColour2.TextureOpacity, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of Opacity
		end;
	------------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------------
	-- Update HUDGradiant if required
	------------------------------------------------------------------------------------------------------
		if (BreadCrumbs_Options.HUDGradiant) then -- HUD Gradiant is enabled so calculate them
			self.aryRedHUD = self:CalGradiant(BreadCrumbs_Options.HUDColour1.Red, BreadCrumbs_Options.HUDColour2.Red, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of Red
			self.aryGreenHUD = self:CalGradiant(BreadCrumbs_Options.HUDColour1.Green, BreadCrumbs_Options.HUDColour2.Green, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of Green
			self.aryBlueHUD = self:CalGradiant(BreadCrumbs_Options.HUDColour1.Blue, BreadCrumbs_Options.HUDColour2.Blue, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of Blue
			self.aryTextureOpacityHUD = self:CalGradiant(BreadCrumbs_Options.HUDColour1.TextureOpacity, BreadCrumbs_Options.HUDColour2.TextureOpacity, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of Opacity
		end;
	------------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------------
	-- Update MinimapSizeGradiant if required
	------------------------------------------------------------------------------------------------------
		if (BreadCrumbs_Options.MinimapSizeGradiant) then -- Minimap Size Gradiant is enabled so calculate them
			self.aryMinimapWidth = self:CalGradiant(BreadCrumbs_Options.MinimapSizeOfPoints1_Width, BreadCrumbs_Options.MinimapSizeOfPoints2_Width, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of the Width
			self.aryMinimapHeight = self:CalGradiant(BreadCrumbs_Options.MinimapSizeOfPoints1_Height, BreadCrumbs_Options.MinimapSizeOfPoints2_Height, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of the Height
		end;
	------------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------------
	-- Update HUDSizeGradiant if required
	------------------------------------------------------------------------------------------------------
		if (BreadCrumbs_Options.HUDSizeGradiant) then -- HUD Size Gradiant is enabled so calculate them
			self.aryHUDWidth = self:CalGradiant(BreadCrumbs_Options.HUDSizeOfPoints1_Width, BreadCrumbs_Options.HUDSizeOfPoints2_Width, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of the Width
			self.aryHUDHeight = self:CalGradiant(BreadCrumbs_Options.HUDSizeOfPoints1_Height, BreadCrumbs_Options.HUDSizeOfPoints2_Height, BreadCrumbs_Options["NumPoints"]) -- Calculates the gradiant between two values of the Height
		end;
	------------------------------------------------------------------------------------------------------
end;

function BreadCrumbs:ReAddPoints() -- Removes and then readds the points to the minimap etc...
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:ReAddPoints()",true,DebugTxt);
	
	self:GeneratePoints(false); -- Creates the frames that will be used as the points on the map
	self:UpdatePoints() -- Updates the Colour/Opacity and Size of all of the points
	self.Astrolabe:RemoveAllMinimapIcons(); -- Clear any and all points already on the minimap
	
	--------------------------------------------------------------------------------------------
	-- Loop though all points
	--------------------------------------------------------------------------------------------
		for name, value in pairs(self.Points) do
			posX = BreadCrumbs_Options.MovementHistory[name]["x"];
			posY = BreadCrumbs_Options.MovementHistory[name]["y"];
			curZone = BreadCrumbs_Options.MovementHistory[name]["zone"];
			continentIndex = BreadCrumbs_Options.MovementHistory[name]["continentIndex"];
			zoneIndex = BreadCrumbs_Options.MovementHistory[name]["zoneIndex"];
			
			ZMC:Msg(self, "Loop num = "..tostring(name).." - continentIndex = "..tostring(continentIndex)..", zoneIndex = "..tostring(zoneIndex)..", posX = "..tostring(posX)..", posY = "..tostring(posY).."", true, DebugTxt);
			
			if not((posX == 0) and (posY == 0)) then -- If this point is not 0x0 (which is not imposible but very unlikely and more likely an old instance or viewing another zone on the map) then assume it's valid and add it!
				ZMC:Msg(self, "Point OK Adding...", true, DebugTxt);
				
				local result = self.Astrolabe:PlaceIconOnMinimap(self.Points[name], continentIndex, zoneIndex, posX, posY);
				
				if (result == 0) then -- All OK
					ZMC:Msg(self, "Added icon to minimap.  Icon # = "..tostring(name).."| result = "..tostring(result).."",true,DebugTxt);
				else -- There was an error!
					ZMC:Msg(self, "There was an error trying to add icon to minimap.  Icon # = "..tostring(name).."| result = "..tostring(result).."",true,DebugTxt);
				end;
			end;
		end;
	--------------------------------------------------------------------------------------------
end;

function BreadCrumbs:GeneratePoints(bWipePoints) -- Creates the frames that will be used as the points on the map
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:GeneratePoints()",true,DebugTxt);
	
	self.Astrolabe:RemoveAllMinimapIcons(); -- Removes all minimap icons
	
	if not(bWipePoints == false) then
		self:WipePoints(); -- Removes all history
	end;
	
	self.Points = {}; -- Wipe and initialize the array to store the points
	
	self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
	
	--------------------------------------------------------------------------------------------
	-- Generate the specified number of points and populate them with current value sets
	--------------------------------------------------------------------------------------------
		for i=1, BreadCrumbs_Options["NumPoints"] do -- Loop for every point required
			---------------------------------------------------------------
			-- Set colours, Opacity, Width and Height etc... for this point
			---------------------------------------------------------------
				local Red, Green, Blue, TextureOpacity, Width, Height
				if (MinimapCluster:IsShown()) then -- Minimap is shown so use it's values
					if (BreadCrumbs_Options.MinimapGradiant) then -- Gradiant is enabled so use it
						Red = self.aryRedMiniMap[i];
						Green = self.aryGreenMiniMap[i];
						Blue = self.aryBlueMiniMap[i];
						TextureOpacity = self.aryTextureOpacityMiniMap[i];
					else -- Minimap Gradiant is disabled so use first points values
						Red = BreadCrumbs_Options.MinimapColour1.Red;
						Green = BreadCrumbs_Options.MinimapColour1.Green;
						Blue = BreadCrumbs_Options.MinimapColour1.Blue;
						TextureOpacity = BreadCrumbs_Options.MinimapColour1.TextureOpacity;
					end;
					
					if (BreadCrumbs_Options.MinimapSizeGradiant) then -- SizeGradiant is enabled so use it
						Width = self.aryMinimapWidth[i];
						Height = self.aryMinimapHeight[i];
					else
						Width = BreadCrumbs_Options.MinimapSizeOfPoints1_Width;
						Height = BreadCrumbs_Options.MinimapSizeOfPoints1_Height;
					end;
				else -- The Minimap is not shown so assume the HUD is and use that's values
					if (BreadCrumbs_Options.HUDGradiant) then -- Gradiant is enabled so use it
						Red = self.aryRedHUD[i];
						Green = self.aryGreenHUD[i];
						Blue = self.aryBlueHUD[i];
						TextureOpacity = self.aryTextureOpacityHUD[i];
					else -- HUD Gradiant is disabled so use first points values
						Red = BreadCrumbs_Options.HUDColour1.Red;
						Green = BreadCrumbs_Options.HUDColour1.Green;
						Blue = BreadCrumbs_Options.HUDColour1.Blue;
						TextureOpacity = BreadCrumbs_Options.HUDColour1.TextureOpacity;
					end;
					
					if (BreadCrumbs_Options.HUDSizeGradiant) then -- Gradiant is enabled so use it
						Width = self.aryHUDWidth[i];
						Height = self.aryHUDHeight[i];
					else
						Width = BreadCrumbs_Options.HUDSizeOfPoints1_Width;
						Height = BreadCrumbs_Options.HUDSizeOfPoints1_Height;
					end;
				end;
			---------------------------------------------------------------
			
			local Point = CreateFrame("Frame", nil, minimapParent); -- Create the frame that will be the point on the minimap
			Point:SetFrameLevel(Minimap:GetFrameLevel()); -- Sets the frame level (this says if its on front of or behind other frames)
			Point:SetWidth(Width); -- Sets frame's Width (will likely be changed later in the code)
			Point:SetHeight(Height); -- Sets frame's Height (will likely be changed later in the code)
			local texture = Point:CreateTexture(nil, "OVERLAY"); -- Creates a textrue for the frame
			Point.texture = texture; -- Attaches the texture to the frame
			texture:SetAllPoints(Point); -- ???? Maybe this makes the texture stretch across all of the frame?
			texture:SetTexture(BreadCrumbs_Options.Texture); -- Sets the texture(image file) of the texture... (this could get confusing! ;-))
			-- texture:SetTexCoord(0, 1, 0, 1); -- ???? Don't know what this is for as it was copied from another addon... doesn't seem to do anything so removed!
			texture:SetVertexColor(Red, Green, Blue, TextureOpacity) -- Sets the colour (Red, Green, Blue, TextureOpacity)
			Point:Hide(); -- Hides the frame until it is needed
			self.Points[i] = Point
		end;
	--------------------------------------------------------------------------------------------
end;

function BreadCrumbs:SlashCmdHandler(msg) -- Slash Command Handler
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "Initialize",true,DebugTxt);
	ZMC:Msg(self, "msg = '"..tostring(msg).."'",true,DebugTxt);
	
	ZMC:Msg(self, "strlower(strsub(msg,1,8) = "..tostring(strlower(strsub(msg,1,8))),true,DebugTxt);
	
	if (msg == nil or msg == "") then
		if BreadCrumbs_Options.Hidden then
			ZMC:Msg(self, L["Trail is Hidden"],false,DebugTxt,true);
		else
			ZMC:Msg(self, L["Trail is Visable"],false,DebugTxt);
		end;
		
		if (BreadCrumbs_Options.Dropping) then
			ZMC:Msg(self, L["BreadCrumb Dropping Enabled"],false,DebugTxt);
		else
			ZMC:Msg(self, L["BreadCrumb Dropping Disabled"],false,DebugTxt,true);
		end;
		
		if (BreadCrumbs_Options["Enabled"]) then
			ZMC:Msg(self, L["is Enabled"],false,DebugTxt);
		else
			ZMC:Msg(self, L["is Disabled"],false,DebugTxt,true);
		end;
		
		if (BreadCrumbs_Options["DontDropWhenDead"]) then
			ZMC:Msg(self, L["Don't Drop When Dead Enabled"],false,DebugTxt);
		else
			ZMC:Msg(self, L["Don't Drop When Dead Disabled"],false,DebugTxt,true);
		end;
		
		ZMC:Msg(self, L["Use '/bc options' to open up the Addon's Options screen"], false, DebugTxt);
	elseif ((strlower(strsub(msg,1,7)) == "options") or (strlower(strsub(msg,1,6)) == "config")) then -- This is the macro checking in...
		ZMC:Msg(self, L["Opening BreadCrumbs Options Panel"]);
		
		InterfaceOptionsFrame_OpenToCategory("BreadCrumbs");
	elseif(strlower(strsub(msg,1,5)) == "reset") then -- This is the macro checking in...
		ZMC:Msg(self, L["Reloading Defaults"]);
		
		StaticPopup_Show ("ResetBCSettings"); -- Shows the Reset BreadCrumbs Settings warning question dialog box
	elseif(strlower(strsub(msg,1,6)) == "enable") then -- This is the macro checking in...
		ZMC:Msg(self, L["Enableing BreadCrumbs"]);
		
		self:TogAddon(true);
	elseif(strlower(strsub(msg,1,7)) == "disable") then -- This is the macro checking in...
		ZMC:Msg(self, L["Disabling BreadCrumbs"]);
		
		self:TogAddon(false);
	else
		ZMC:Msg(self, "Message not known = '"..tostring(msg).."'",true,Debugtxt);
	end;
end;

function BreadCrumbs:Update(frame, elapsed) -- Runs all the time (thousands of times a second!) and if the use has moved enough adds a new point
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "BreadCrumbs:Update()",true,DebugTxt);
	
	if (not(BreadCrumbs_Options["Enabled"]) or (self.LoadedStatus["Initialized"] == false) or not(BreadCrumbs_Options.Dropping) or ((UnitIsDeadOrGhost("player") == 1) and BreadCrumbs_Options["DontDropWhenDead"])) then -- Addon is disabled so exit
		return;
	end;
	
	-- update our zone info
	local curZone = GetRealZoneText()
	if (not curZone or curZone == "") then 
		curZone = nil
		return
	end
	
	self.last_update = self.last_update + elapsed -- Calculates how long since it last updated
	-- ZMC:Msg(self, "self.UpdateFrame - OnUpdate",true,DebugTxt);
	-- ZMC:Msg(self, "elapsed = "..tostring(elapsed),true,DebugTxt);
	-- ZMC:Msg(self, "last_update = "..tostring(self.last_update),true,DebugTxt);
	
	if self.last_update > 0.1 then -- Ensures that it doesn't update to often
		-- ZMC:Msg(self, "BreadCrumbs:Update() - last_update > 0.5",true,DebugTxt);
		
		self.last_update = 0

		local zoneIndex = GetCurrentMapZone();
		local continentIndex = GetCurrentMapContinent();
		local DistBetweenPoints = BreadCrumbs_Options.DistBetweenPoints;
		-- ZMC:Msg(self, "zoneIndex = "..tostring(zoneIndex).."",true,DebugTxt);
		-- ZMC:Msg(self, "continentIndex = "..tostring(continentIndex).."",true,DebugTxt);
		
		
		-- ZMC:Msg(self, "pc = "..tostring(continentIndex)..", pz = "..tostring(zoneIndex), true, DebugTxt);
		-- local d, dx, dy = self.Astrolabe:ComputeDistance(pc, pz, px, py, node.c, node.z, node.x, node.y);
		
		
		-----------------------------------------------------------------
		-- Store the players current position on the map in the next slot
		----------------------------------------------------------------
			-- Get current player position
			local posX, posY = GetPlayerMapPosition("player");
			
			-- ZMC:Msg(self, "posX = "..tostring(posX),true,DebugTxt);
			-- ZMC:Msg(self, ", posY = "..tostring(posY),true,DebugTxt);
			-- ZMC:Msg(self, " curZone = "..tostring(curZone).."",true,DebugTxt);
			-- ZMC:Msg(self, "",true,DebugTxt);
			
			local PrevMovementHistorySlot;
			if ((BreadCrumbs_Options.NextMovementHistorySlot - 1) < 1) then
				PrevMovementHistorySlot = BreadCrumbs_Options["NumPoints"];
			else 
				PrevMovementHistorySlot = BreadCrumbs_Options.NextMovementHistorySlot - 1;
			end;
			
			if (((posX == 0) or (posY == 0) or GetCurrentMapZone() == 0)) then -- If position is 0, the player changed the worldmap to another zone, just keep the old values
				-- ZMC:Msg(self, "posX = "..tostring(posX).." posY = "..tostring(posY).." GetCurrentMapZone() = "..tostring(GetCurrentMapZone()).."",true,DebugTxt);
				-- ZMC:Msg(self, "The player changed the worldmap to another zone, don't do anything",true,DebugTxt);
			else -- Coords look ok
				-- ZMC:Msg(self, "DistBetweenPoints = "..tostring(DistBetweenPoints).."",true,DebugTxt);
				
				local prevX = BreadCrumbs_Options.MovementHistory[PrevMovementHistorySlot]["x"] or 0;
				local prevY = BreadCrumbs_Options.MovementHistory[PrevMovementHistorySlot]["y"] or 0;
				local prevCont = BreadCrumbs_Options.MovementHistory[PrevMovementHistorySlot]["continentIndex"] or 0;
				local prevZoneIndex = BreadCrumbs_Options.MovementHistory[PrevMovementHistorySlot]["zoneIndex"] or 0;
				
				local curPlayerCont = continentIndex;
				local curPlayerZoneIndex = zoneIndex;
				local curPlayerX = posX;
				local curPlayerY = posY;
				
				local Dist, distX, distY = self.Astrolabe:ComputeDistance(curPlayerCont, curPlayerZoneIndex, curPlayerX, curPlayerY, prevCont, prevZoneIndex, prevX, prevY);
				
				Dist = Dist or (DistBetweenPoints + 1); -- Make sure the distance is never nil! If it is asume it is a long way (likely another planet!) so make it DistBetweenPoints + 1...
				
				if ((Dist > DistBetweenPoints)) then
					-- ZMC:Msg(self, "Diference IS great enough!",true,DebugTxt);
					-- ZMC:Msg(self, "PrevMovementHistorySlot = "..tostring(PrevMovementHistorySlot).."", true, DebugTxt);
					-- ZMC:Msg(self, "BreadCrumbs_Options.MovementHistorySlot = "..tostring(BreadCrumbs_Options.NextMovementHistorySlot),true,DebugTxt);
					
					BreadCrumbs_Options.MovementHistory[BreadCrumbs_Options.NextMovementHistorySlot]["x"] = posX;
					BreadCrumbs_Options.MovementHistory[BreadCrumbs_Options.NextMovementHistorySlot]["y"] = posY;
					BreadCrumbs_Options.MovementHistory[BreadCrumbs_Options.NextMovementHistorySlot]["zone"] = curZone;
					BreadCrumbs_Options.MovementHistory[BreadCrumbs_Options.NextMovementHistorySlot]["continentIndex"] = continentIndex;
					BreadCrumbs_Options.MovementHistory[BreadCrumbs_Options.NextMovementHistorySlot]["zoneIndex"] = zoneIndex;
					
					local result = self.Astrolabe:RemoveIconFromMinimap(self.Points[BreadCrumbs_Options.NextMovementHistorySlot])
					-- if not(result == 0) then -- There was an error!
						-- ZMC:Msg(self, "There was an error trying to remove an icon from the minimap as it doesn't exist. Icon # = "..tostring(BreadCrumbs_Options.NextMovementHistorySlot).."| result = "..tostring(result).."",true,DebugTxt);
					-- end;
					
					local result = self.Astrolabe:PlaceIconOnMinimap(self.Points[BreadCrumbs_Options.NextMovementHistorySlot], continentIndex, zoneIndex, posX, posY);
					-- if not(result == 0) then -- There was an error!
						-- ZMC:Msg(self, "There was an error trying to add icon to minimap.  Icon # = "..tostring(BreadCrumbs_Options.NextMovementHistorySlot).."| result = "..tostring(result).."",true,DebugTxt);
					-- end;
					
					-- ZMC:Msg(self, "BreadCrumbs_Options.NextMovementHistorySlot = "..tostring(BreadCrumbs_Options.NextMovementHistorySlot),true,DebugTxt);
					
					if (BreadCrumbs_Options.NextMovementHistorySlot < BreadCrumbs_Options["NumPoints"]) then
						BreadCrumbs_Options.NextMovementHistorySlot = BreadCrumbs_Options.NextMovementHistorySlot + 1;
					else
						BreadCrumbs_Options.NextMovementHistorySlot = 1;
					end;
					
					-- ZMC:Msg(self, "BreadCrumbs_Options.NextMovementHistorySlot = "..tostring(BreadCrumbs_Options.NextMovementHistorySlot),true,DebugTxt);
					
					if (BreadCrumbs_Options.MinimapGradiant or BreadCrumbs_Options.HUDGradiant) then
						self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
					end;
				-- else
					-- ZMC:Msg(self, "Diference not great enough! xDif = "..tostring(xDif).." yDif = "..tostring(yDif).."",true,DebugTxt);
				end;
			end;
			
			-- ZMC:Msg(self, "xDif = "..tostring(xDif),true,DebugTxt);
			-- ZMC:Msg(self, "yDif = "..tostring(yDif),true,DebugTxt);
		-----------------------------------------------------------------
	end;
end;

function BreadCrumbs:HudMapCluster_OnShow() -- Runs when the SexyMapHUD is shown
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:HudMapCluster_OnShow()",true,DebugTxt);
	
	if (not(BreadCrumbs_Options["Enabled"])) then -- Addon is disabled so exit
		return;
	end;
	
	BreadCrumbs:SetMinimapObject(HudMapCluster)
end;

function BreadCrumbs:HudMapCluster_OnHide() -- Runs when the SexyMapHUD is hidden
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:HudMapCluster_OnHide()",true,DebugTxt);
	
	if (not(BreadCrumbs_Options["Enabled"])) then -- Addon is disabled so exit
		return;
	end;
	
	BreadCrumbs:SetMinimapObject(Minimap)
end;

function BreadCrumbs:SetMinimapObject(minimap) -- Moves the trail between the minimap and SexyMap HUD as required
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:SetMinimapObject(minimap = "..tostring(minimap)..")",true,DebugTxt);
	
	if (Minimap == minimap) then
		ZMC:Msg(self, "To Minimap",true,DebugTxt);
		
		for pointNum, waypoint in pairs(self.Points) do
			waypoint:SetParent(minimap)
			-- waypoint:SetWidth(BreadCrumbs_Options.MinimapSizeOfPoints1_Width); -- Sets frame's Width (will likely be changed later in the code)
			-- waypoint:SetHeight(BreadCrumbs_Options.MinimapSizeOfPoints1_Height); -- Sets frame's Height (will likely be changed later in the code)
			-- waypoint.texture:SetVertexColor(BreadCrumbs_Options.MinimapColour1.Red, BreadCrumbs_Options.MinimapColour1.Green, BreadCrumbs_Options.MinimapColour1.Blue, BreadCrumbs_Options.MinimapColour1.TextureOpacity) -- Sets the colour (Red, Green, Blue, TextureOpacity)
		end
		
		self:UpdatePoints(true); -- Updates the Colour/Opacity and Size of all of the points
	else
		ZMC:Msg(self, "From Minimap",true,DebugTxt);
		
		for pointNum, waypoint in pairs(self.Points) do
			waypoint:SetParent(minimap)
			-- waypoint:SetWidth(BreadCrumbs_Options.HUDSizeOfPoints1_Width); -- Sets frame's Width (will likely be changed later in the code)
			-- waypoint:SetHeight(BreadCrumbs_Options.HUDSizeOfPoints1_Height); -- Sets frame's Height (will likely be changed later in the code)
			-- waypoint.texture:SetVertexColor(BreadCrumbs_Options.HUDColour1.Red, BreadCrumbs_Options.HUDColour1.Green, BreadCrumbs_Options.HUDColour1.Blue, BreadCrumbs_Options.HUDColour1.TextureOpacity) -- Sets the colour (Red, Green, Blue, TextureOpacity)
		end
		
		self:UpdatePoints(false); -- Updates the Colour/Opacity and Size of all of the points
	end
	
	minimapParent = minimap
	self.Astrolabe:SetMinimapObject(minimap);
	self.Astrolabe.processingFrame:SetParent(minimap)
end

function BreadCrumbs:AddInterfaceOptions() -- Creates and adds the options window to the Bliz interface tab
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:AddInterfaceOptions()",true,DebugTxt);
	
	if (BreadCrumbs_Options.RepairInterfaceOptionsFrameStrataTog) then
		-- ZMC:Msg(self, "Repair InterfaceOptionsFrame Strata ENABLED", true,DebugTxt);
		InterfaceOptionsFrame:SetFrameStrata(BreadCrumbs_Options.RepairInterfaceOptionsFrameStrata); -- Repair InterfaceOptionsFrame Strata as other addon's make it above dialogs!!! You know who you are "LibBetterBlizzOptions"
	-- else
		-- ZMC:Msg(self, "Repair InterfaceOptionsFrame Strata DISABLED", true,DebugTxt);
	end;
	
	local sVersion; -- Sets the string for version infomation
	if (self.sVersionType == "ALPHA") then -- If this is a ALPHA version then
		sVersion = ZMC.COLOUR_RED..L["Version"]..": "..tostring(self.Version).." "..L["ALPHA"]..ZMC.COLOUR_CLOSE
	elseif (self.sVersionType == "BETA") then -- If this is a BETA version then
		sVersion = ZMC.COLOUR_ORANGE..L["Version"]..": "..tostring(self.Version).." "..L["BETA"]..ZMC.COLOUR_CLOSE
	else
		sVersion = self.ZMC_DefaultColour1..L["Version"]..": "..tostring(self.Version)..ZMC.COLOUR_CLOSE
	end;
	
	self.ResetVisable = false; -- Ensures the reset button is disabled!
	
	---------------------------------------------------------
	-- Reset Settings Static Popup Dialog
	---------------------------------------------------------
		StaticPopupDialogs["ResetBCSettings"] = {
			text = L["Are you sure you want to reset ALL BreadCrumbs Settings to default?"],
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				self:ResetAllSettings(); -- Deletes all settings and restarts UI
			end,
			OnCancel = function()
				self.ResetVisable = false; -- Disables the button again
				LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Refreshes Options Window
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
	---------------------------------------------------------
	
	local Options = {
		type = "group",
		childGroups = "tab",
		name = "BreadCrumbs("..self.ZMC_DefaultColour1.."Zasurus"..ZMC.COLOUR_CLOSE..") "..sVersion,
		desc = L["These options allow you to configure various aspects of BreadCrumbs."],
		args = {
			Enabled = { -- Creates and Sets Up the Addon Enable Toggle
				type = "toggle",
				name = L["BreadCrumbs Enabled (KeyBinding Available)"],
				desc = L["Turns BreadCrumbs On/Off. If you don't plan to use it for a long time or just don't want to use it on this toon your better disabling it via the 'Addon' menu on the toon selection screen to save memory."],
				order = 1,
				get = function(info)
					return BreadCrumbs_Options["Enabled"];
				end,
				set = function(info, value)
					self:TogAddon(value);
				end,
				width = "full",
			},
			Drop = { -- Creates and Sets Up the Addon Drop Toggle
				type = "toggle",
				name = L["Drop Breadcrumbs (KeyBinding Available)"],
				desc = L["Drop BreadCrumbs On/Off. This starts and stops the dropping of breadcrumbs."],
				order = 2,
				get = function(info)
					return BreadCrumbs_Options["Dropping"];
				end,
				set = function(info, value)
					self:TogBreadDrop(value);
				end,
				width = "full",
			},
			HideTog = { -- Creates and Sets Up the Addon Hide Toggle
				type = "toggle",
				name = L["Hide Breadcrumbs (KeyBinding Available)"],
				desc = L["Hides or Unhides the breadcrumbs. This doesn't stop the dropping just hides them."],
				order = 3,
				get = function(info)
					return BreadCrumbs_Options["Hidden"];
				end,
				set = function(info, value)
					self:TogHideBread(value);
				end,
				width = "full",
			},
			ResetOnReload = { -- Creates and Sets Up the Addon "Reset points on reload/load" Toggle
				type = "toggle",
				name = L["Reset Trail on Load/Reload"],
				desc = L["Enable to start a fresh trail every time the addon is loaded/reloaded."],
				order = 4,
				get = function(info)
					return BreadCrumbs_Options["ResetOnReload"];
				end,
				set = function(info, value)
					BreadCrumbs_Options["ResetOnReload"] = value;
				end,
				width = "full",
			},
			DontDropWhenDead = { -- Creates and Sets Up the Addon "Don't Drop when Dead" Toggle
				type = "toggle",
				name = L["Don't Drop Breadcrumbs when Dead (KeyBinding Available)"],
				desc = L["Enable to stops dropping BreadCrumbs when you die so you don't have a useless trail from the grave and lose your berings!"],
				order = 5,
				get = function(info)
					return BreadCrumbs_Options["DontDropWhenDead"];
				end,
				set = function(info, value)
					self:TogDropWhenDead(value);
				end,
				width = "full",
			},
			DistBetweenPoints = { -- Creates and Sets Up the DistBetweenPoints slider
				type = "range",
				name = L["Space Between Points"],
				desc = L["This slider specifies how close together the points are that make up the line. Closer together gives a better looking line but makes it shorter."].."\n\n"..self.ZMC_DefaultColour1..L["NOTE: This will also affect the length of the line so you may need to also adjust the number of points used for the line."].."\n\n"..L["Also this will only affect new BreadCrumbs and not your existing trail."].."|r",
				order = 6,
				min = 1,
				max = 100,
				step = 1,
				get = function(info)
					return BreadCrumbs_Options["DistBetweenPoints"];
				end,
				set = function(info, value)
					BreadCrumbs_Options["DistBetweenPoints"] = value;
				end,
				
			},
			NumberOfPoints = { -- Creates and Sets Up the NumberOfPoints slider
				type = "range",
				name = L["Number of Points"],
				desc = L["This slider specifies how many points are used to create the line and therefore how long it will be."].."\n\n"..self.ZMC_DefaultColour1..L["NOTE: Use this and the spacing one to crate the line you want."].."\n\n"..L["ALSO this will reset your BreadCrumbs(remove your trail)! So ensure you make a note of which way you have come from."].."|r\n\n"..self.ZMC_DefaultErrorColour..L["WARNING! Setting this higher MAY slow the game down!"].."|r",
				order = 7,
				min = 2, -- Can't be <2!
				max = 100,
				step = 1,
				get = function(info)
					return BreadCrumbs_Options["NumPoints"];
				end,
				set = function(info, value)
					if (BreadCrumbs_Options["NumPoints"] == value) then -- If no change then don't do anything!
						ZMC:Msg(self, "BreadCrumbs_Options.NumPoints == value",true,DebugTxt);
						return;
					end;
					
					BreadCrumbs_Options["NumPoints"] = value; -- Set the number of points to the ones specified
					
					self:GeneratePoints(); -- Recreate the new number of points
					
					if (HudMapCluster) then
						ZMC:Msg(self, "HudMapCluster Exists!",true,DebugTxt);
						
						if (HudMapCluster:IsShown()) then
							ZMC:Msg(self, "and HudMapCluster is Shown!",true,DebugTxt);
							
							HudMapCluster:Hide(); -- Hide the SexyMap's HUD
							HudMapCluster:Show(); -- Now Show the SexyMap's HUD again to reset everything.
						-- else
							-- ZMC:Msg(self, "and HudMapCluster is NOT Shown!",true,DebugTxt);
						end;
					-- else
						-- ZMC:Msg(self, "HudMapCluster Does NOT Exist!",true,DebugTxt);
					end;
				end,
			},
			LastNumToHide = { -- Creates and Sets Up the LastNumToHide slider
				type = "range",
				name = L["Hide Closest # Points"],
				desc = L["This slider specifies how many of the closest points to the player (if any) should be hidden."].."\n\n"..L["This is to help prevent the players arrow from being covered."],
				order = 8,
				min = 1,
				max = 50,
				step = 1,
				get = function(info)
					return BreadCrumbs_Options["LastNumToHide"];
				end,
				set = function(info, value)
					BreadCrumbs_Options.LastNumToHide = value;
					
					self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
					
					self:UpdatePoints();
				end,
			},
			---------------------------------------------------------------------------------------------------------------------------------
			-- Minimap
			---------------------------------------------------------------------------------------------------------------------------------
				MinimapGroup = {
					type = "group",
					name = "Minimap",
					order = 9,
					args = {
						---------------------------------------------------------------------------------------------------------------------------------
						-- First Point's Colour/Opacity for the Minimap
						---------------------------------------------------------------------------------------------------------------------------------
							MinimapColour2 = { -- Creates and Sets Up the Last Point's Colour/Opacity for the Minimap
								type = "color",
								name = L["to"],
								desc = L["This sets the Colour & Opacity level of the last point that make up the BreadCrumbs when on the Minimap."],
								order = 1,
								hasAlpha = true,
								width = "half",
								get = function(info)
									local Red = BreadCrumbs_Options.MinimapColour2.Red;
									local Green = BreadCrumbs_Options.MinimapColour2.Green;
									local Blue = BreadCrumbs_Options.MinimapColour2.Blue;
									local TextureOpacity = BreadCrumbs_Options.MinimapColour2.TextureOpacity;
									
									return Red, Green, Blue, TextureOpacity;
								end,
								set = function(info, Red, Green, Blue, TextureOpacity)
									ZMC:Msg(self, "MinimapColour2 - setFunc(Red = "..tostring(Red)..", Green = "..tostring(Green)..", Blue = "..tostring(Blue)..", TextureOpacity = "..tostring(TextureOpacity)..")", true, DebugTxt);
									BreadCrumbs_Options.MinimapColour2.Red = Red;
									BreadCrumbs_Options.MinimapColour2.Green = Green;
									BreadCrumbs_Options.MinimapColour2.Blue = Blue;
									BreadCrumbs_Options.MinimapColour2.TextureOpacity = TextureOpacity;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
								end,
								hidden = function()
									ZMC:Msg(self, "return not(BreadCrumbs_Options.MinimapGradiant("..tostring(BreadCrumbs_Options.MinimapGradiant).."));", true, DebugTxt);
									return not(BreadCrumbs_Options.MinimapGradiant);
								end,
							},
							MinimapColour1 = { -- Creates and Sets Up the First Point's Colour/Opacity for the Minimap
								type = "color",
								name = L["Colour/Opacity (Minimap)"],
								desc = L["This sets the Colour & Opacity level of the first point (or all if gradiant is disabled) that make up the BreadCrumbs when on the Minimap."],
								order = 2,
								hasAlpha = true,
								width = "double",
								get = function(info)
									local Red = BreadCrumbs_Options.MinimapColour1.Red;
									local Green = BreadCrumbs_Options.MinimapColour1.Green;
									local Blue = BreadCrumbs_Options.MinimapColour1.Blue;
									local TextureOpacity = BreadCrumbs_Options.MinimapColour1.TextureOpacity;
									
									return Red, Green, Blue, TextureOpacity;
								end,
								set = function(info, Red, Green, Blue, TextureOpacity)
									ZMC:Msg(self, "MinimapColour1 - setFunc", true, DebugTxt);
									BreadCrumbs_Options.MinimapColour1.Red = Red;
									BreadCrumbs_Options.MinimapColour1.Green = Green;
									BreadCrumbs_Options.MinimapColour1.Blue = Blue;
									BreadCrumbs_Options.MinimapColour1.TextureOpacity = TextureOpacity;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
								end,
							},
							MinimapGradiant = { -- Creates and Sets Up the Minimap Gradiant Toggle
								type = "toggle",
								name = L["Gradiant"],
								desc = L["Gradually change the colour/transparancy between the first and last point on the Minimap"],
								order = 3,
								get = function(info)
									return BreadCrumbs_Options["MinimapGradiant"];
								end,
								set = function(info, value)
									self:TogMiniGrad(value);
								end,
								width = "full",
							},
							-- if (BreadCrumbs_Options.MinimapGradiant) then -- Minimap Gradiant is disabled so disable options
								-- self.OptionsPanel.MinimapColour2:Enable(); -- Enable the colour picker for the last point as it's needed now.
								-- self.OptionsPanel.MinimapColour2:Show(); -- Show the colour picker for the last point as it's needed now.
								-- panel.MinimapColour1:SetPoint("TOPLEFT", panel.MinimapColour2, "TOPRIGHT", 15, 0); -- Move the First colour picker to the right of the second one
							-- else
								-- self.OptionsPanel.MinimapColour2:Disable(); -- Disable the colour picker for the last point as it's not needed any more.
								-- panel.MinimapColour2:Hide();
								-- panel.MinimapColour1:SetPoint("TOPLEFT", panel.MinimapColour2, "TOPLEFT", 0, 0);
							-- end;
						---------------------------------------------------------------------------------------------------------------------------------
						
						---------------------------------------------------------------------------------------------------------------------------------
						-- Minimap Size Settings
						---------------------------------------------------------------------------------------------------------------------------------
							MinimapSizeOfPoints2 = { -- Creates and Sets Up the MinimapSizeOfPoints2 slider
								type = "range",
								name = L["Last Point Size to -->"],
								desc = L["This slider specifies the size of the first point on the minimap is."],
								order = 4,
								min = 1,
								max = 50,
								step = 1,
								get = function(info)
									return BreadCrumbs_Options["MinimapSizeOfPoints2_Width"];
								end,
								set = function(info, value)
									BreadCrumbs_Options.MinimapSizeOfPoints2_Width = value;
									BreadCrumbs_Options.MinimapSizeOfPoints2_Height = value;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints();
								end,
								hidden = function()
									ZMC:Msg(self, "return not(BreadCrumbs_Options.MinimapSizeGradiant("..tostring(BreadCrumbs_Options.MinimapSizeGradiant).."));", true, DebugTxt);
									return not(BreadCrumbs_Options.MinimapSizeGradiant);
								end,
							},
							MinimapSizeOfPoints1 = { -- Creates and Sets Up the MinimapSizeOfPoints1 slider
								type = "range",
								name = L["Size(Minimap)"],
								desc = L["This slider specifies how big the last point on the minimap is."],
								order = 5,
								min = 1,
								max = 50,
								step = 1,
								get = function(info)
									return BreadCrumbs_Options["MinimapSizeOfPoints1_Width"];
								end,
								set = function(info, value)
									BreadCrumbs_Options.MinimapSizeOfPoints1_Width = value;
									BreadCrumbs_Options.MinimapSizeOfPoints1_Height = value;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints();
								end,
							},
							MinimapSizeGradiant = { -- Creates and Sets Up the Minimap Size Gradiant Toggle
								type = "toggle",
								name = L["Gradiant"],
								desc = L["Gradually change the size between the first and last point on the Minimap"],
								order = 6,
								get = function(info)
									return BreadCrumbs_Options["MinimapSizeGradiant"];
								end,
								set = function(info, value)
									self:TogMinimapSizeGrad(value);
								end,
								width = "full",
							},
						---------------------------------------------------------------------------------------------------------------------------------
					},
				},
			---------------------------------------------------------------------------------------------------------------------------------
			
			
			
			---------------------------------------------------------------------------------------------------------------------------------
			-- SexyMap HUD
			---------------------------------------------------------------------------------------------------------------------------------
				HUDGroup = {
					type = "group",
					name = "SexyMapHUD",
					order = 10,
					args = {
						---------------------------------------------------------------------------------------------------------------------------------
						-- First Point's Colour/Opacity for the HUD
						---------------------------------------------------------------------------------------------------------------------------------
							HUDColour2 = { -- Creates and Sets Up the Last Point's Colour/Opacity for the HUD
								type = "color",
								name = L["to"],
								desc = L["This sets the Colour & Opacity level of the last point that make up the BreadCrumbs when on the Minimap."],
								order = 1,
								hasAlpha = true,
								width = "half",
								get = function(info)
									local Red = BreadCrumbs_Options.HUDColour2.Red;
									local Green = BreadCrumbs_Options.HUDColour2.Green;
									local Blue = BreadCrumbs_Options.HUDColour2.Blue;
									local TextureOpacity = BreadCrumbs_Options.HUDColour2.TextureOpacity;
									
									return Red, Green, Blue, TextureOpacity;
								end,
								set = function(info, Red, Green, Blue, TextureOpacity)
									ZMC:Msg(self, "HUDColour2 - setFunc", true, DebugTxt);
									BreadCrumbs_Options.HUDColour2.Red = Red;
									BreadCrumbs_Options.HUDColour2.Green = Green;
									BreadCrumbs_Options.HUDColour2.Blue = Blue;
									BreadCrumbs_Options.HUDColour2.TextureOpacity = TextureOpacity;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
								end,
								hidden = function()
									ZMC:Msg(self, "return not(BreadCrumbs_Options.HUDGradiant("..tostring(BreadCrumbs_Options.HUDGradiant).."));", true, DebugTxt);
									return not(BreadCrumbs_Options.HUDGradiant);
								end,
							},
							HUDColour1 = { -- Creates and Sets Up the First Point's Colour/Opacity for the HUD
								type = "color",
								name = L["Colour/Opacity (Minimap)"],
								desc = L["This sets the Colour & Opacity level of the first point (or all if gradiant is disabled) that make up the BreadCrumbs when on the Minimap."],
								order = 2,
								hasAlpha = true,
								width = "double",
								get = function(info)
									local Red = BreadCrumbs_Options.HUDColour1.Red;
									local Green = BreadCrumbs_Options.HUDColour1.Green;
									local Blue = BreadCrumbs_Options.HUDColour1.Blue;
									local TextureOpacity = BreadCrumbs_Options.HUDColour1.TextureOpacity;
									
									return Red, Green, Blue, TextureOpacity;
								end,
								set = function(info, Red, Green, Blue, TextureOpacity)
									ZMC:Msg(self, "HUDColour1 - setFunc", true, DebugTxt);
									BreadCrumbs_Options.HUDColour1.Red = Red;
									BreadCrumbs_Options.HUDColour1.Green = Green;
									BreadCrumbs_Options.HUDColour1.Blue = Blue;
									BreadCrumbs_Options.HUDColour1.TextureOpacity = TextureOpacity;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
								end,
							},
							HUDGradiant = { -- Creates and Sets Up the HUD Gradiant Toggle
								type = "toggle",
								name = L["Gradiant"],
								desc = L["Gradually change the colour/transparancy between the first and last point on the HUD"],
								order = 3,
								get = function(info)
									return BreadCrumbs_Options["HUDGradiant"];
								end,
								set = function(info, value)
									self:TogHUDGrad(value);
								end,
								width = "full",
							},
						---------------------------------------------------------------------------------------------------------------------------------
						
						
						---------------------------------------------------------------------------------------------------------------------------------
						-- HUD Size Settings
						---------------------------------------------------------------------------------------------------------------------------------
							HUDSizeOfPoints2 = { -- Creates and Sets Up the HUDSizeOfPoints2 slider
								type = "range",
								name = L["Last Point Size to -->"],
								desc = L["This slider specifies how big the points on the SexyMapHUD are."],
								order = 4,
								min = 1,
								max = 50,
								step = 1,
								get = function(info)
									return BreadCrumbs_Options["HUDSizeOfPoints2_Width"];
								end,
								set = function(info, value)
									BreadCrumbs_Options.HUDSizeOfPoints2_Width = value;
									BreadCrumbs_Options.HUDSizeOfPoints2_Height = value;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints();
								end,
								hidden = function()
									ZMC:Msg(self, "return not(BreadCrumbs_Options.HUDSizeGradiant("..tostring(BreadCrumbs_Options.HUDSizeGradiant).."));", true, DebugTxt);
									return not(BreadCrumbs_Options.HUDSizeGradiant);
								end,
							},
							MinimapSizeOfPoints1 = { -- Creates and Sets Up the MinimapSizeOfPoints1 slider
								type = "range",
								name = L["Size(SexyMapHUD)"],
								desc = L["This slider specifies the size of the first point (or all if Gradian is diabled) on the SexyMapHUD."],
								order = 5,
								min = 1,
								max = 50,
								step = 1,
								get = function(info)
									return BreadCrumbs_Options["HUDSizeOfPoints1_Width"];
								end,
								set = function(info, value)
									BreadCrumbs_Options.HUDSizeOfPoints1_Width = value;
									BreadCrumbs_Options.HUDSizeOfPoints1_Height = value;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints();
								end,
							},
							MinimapSizeGradiant = { -- Creates and Sets Up the HUD Size Gradiant Toggle
								type = "toggle",
								name = L["Gradiant"],
								desc = L["Gradually change the size between the first and last point on the SexyMapHUD"],
								order = 6,
								get = function(info)
									return BreadCrumbs_Options["HUDSizeGradiant"];
								end,
								set = function(info, value)
									self:TogHUDSizeGrad(value);
								end,
								width = "full",
							},
						---------------------------------------------------------------------------------------------------------------------------------	
					},
					hidden = function()
						if (HudMapCluster) then -- If SexyMapHUD exists show this options if now hide it!
							ZMC:Msg(self, "SexyMapHUD found so enabling the options for it", true, DebugTxt);
							return false;
						else
							ZMC:Msg(self, "SexyMapHUD missing disable the options for it", true, DebugTxt);
							return true;
						end;
					end,
				},
			---------------------------------------------------------------------------------------------------------------------------------
			
			
			
			---------------------------------------------------------------------------------------------------------------------------------
			-- Others
			---------------------------------------------------------------------------------------------------------------------------------
				OtherGroup = {
					type = "group",
					name = "Other Settings",
					order = 11,
					args = {
						EnableReset = { -- Creates and Sets Up the HUD Size Gradiant Toggle
							type = "toggle",
							name = L["Enable Reset"],
							desc = L["This enables the reset button (so you don't click it by acident!)"],
							order = 1,
							get = function(info)
								return self.ResetVisable;
							end,
							set = function(info, value)
								self.ResetVisable = value;
							end,
						},
						ResetButton = { -- Creates and Sets up the Reset Settings Button
							type = "execute",
							name = L["Reset Settings"],
							desc = L["This resets ALL BreadCrumbs settings back to there defaults (Like a fresh install)!"].."\n\n"..ZMC.COLOUR_ORANGE..L["WARNING! This will reload the UI!"]..ZMC.COLOUR_CLOSE,
							order = 2,
							func = function(info)
								StaticPopup_Show ("ResetBCSettings"); -- Shows the Reset BreadCrumbs Settings warning question dialog box
							end,
							disabled = function(info)
								return not(self.ResetVisable);
							end,
						},
						RepairInterfaceStrata = { -- Creates and Sets Up the Interface Strata Repair Toggle
							type = "toggle",
							name = L["Repair Interface Strata"],
							desc = L["This repairs the InterfaceOptionsFrame's Strata back to: '"]..ZMC.COLOUR_RED..tostring(BreadCrumbs_Options.RepairInterfaceOptionsFrameStrata)..ZMC.COLOUR_CLOSE..L["' default normally '"]..ZMC.COLOUR_ORANGE..tostring(self.Default_RepairInterfaceOptionsFrameStrata)..ZMC.COLOUR_CLOSE..L["') as some addon's (you know who you are 'LibBetterBlizzOptions-1.0') make it so high no other frame can be ontop of it!"].."\n\n"..ZMC.COLOUR_ORANGE..L["The UI will need reloading for this to take affect!"]..ZMC.COLOUR_CLOSE,
							order = 3,
							width = "double",
							get = function(info)
								return BreadCrumbs_Options.RepairInterfaceOptionsFrameStrataTog;
							end,
							set = function(info, value)
								BreadCrumbs_Options.RepairInterfaceOptionsFrameStrataTog = value;
							end,
						},
					},
				},
			---------------------------------------------------------------------------------------------------------------------------------
		},
	};
	
	------------------------------------------------------------------------------
	-- Uses the options table just created to 
	------------------------------------------------------------------------------
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(self.Name, Options) -- Registers the "options" table ready to be used
		self.BCOptionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BreadCrumbs", "BreadCrumbs") -- Refreshes the open window (encase an external function changes the "options" table)
	------------------------------------------------------------------------------
end;

function BreadCrumbs:UpdatePoints(MinimapShown) -- Updates the Colour/Opacity and Size of all of the points
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:UpdatePoints("..tostring(MinimapShown)..")",true,DebugTxt);
	
	if (MinimapShown == nil) then
		MinimapShown = MinimapCluster:IsShown();
	else
		MinimapShown = MinimapShown
	end;
	
	ZMC:Msg(self, "MinimapShown = "..tostring(MinimapShown).."", true, DebugTxt);
	
	--------------------------------------------------------------------------------------------
	-- Loop though all points
	--------------------------------------------------------------------------------------------
		for name, value in pairs(self.Points) do
			-- ZMC:Msg(self, "CurrentPoint = "..tostring(name).." BreadCrumbs_Options.NextMovementHistorySlot = "..tostring(BreadCrumbs_Options.NextMovementHistorySlot).."", true, DebugTxt);
			-- ZMC:Msg(self, "", true, DebugTxt);
			local CurrentSlot = (BreadCrumbs_Options.NextMovementHistorySlot - 1)
			if (CurrentSlot < 1) then
				CurrentSlot = CurrentSlot + BreadCrumbs_Options["NumPoints"]
			end;
			
			numGradPoint = (CurrentSlot - (name - 1))
			-- ZMC:Msg(self, "Point = "..tostring(name).." numGradPoint = "..tostring(numGradPoint).." CurrentSlot = "..tostring(CurrentSlot).."", true, DebugTxt);
			if (numGradPoint < 1) then
				numGradPoint = numGradPoint + BreadCrumbs_Options["NumPoints"]
			end;
			
			-- ZMC:Msg(self, "CurrentPoint = "..tostring(name).." numGradPoint = "..tostring(numGradPoint).."", true, DebugTxt);
			
			---------------------------------------------------------------
			-- Set colours, Opacity, Width and Height etc... for this point
			---------------------------------------------------------------
				local Red, Green, Blue, TextureOpacity, Width, Height
				if (MinimapShown) then -- Minimap is shown so use it's values
					if (BreadCrumbs_Options.MinimapGradiant) then -- Minimap Gradiant is enabled so use it
						Red = self.aryRedMiniMap[numGradPoint];
						Green = self.aryGreenMiniMap[numGradPoint];
						Blue = self.aryBlueMiniMap[numGradPoint];
						TextureOpacity = self.aryTextureOpacityMiniMap[numGradPoint];
					else -- Minimap Gradiant is disabled so use first points values
						Red = BreadCrumbs_Options.MinimapColour1.Red;
						Green = BreadCrumbs_Options.MinimapColour1.Green;
						Blue = BreadCrumbs_Options.MinimapColour1.Blue;
						TextureOpacity = BreadCrumbs_Options.MinimapColour1.TextureOpacity;
					end;
					
					if (BreadCrumbs_Options.MinimapSizeGradiant) then -- Size Gradiant is enabled so use it
						Width = self.aryMinimapWidth[numGradPoint];
						Height = self.aryMinimapHeight[numGradPoint];
					else -- Size Gradiant is disabled so use the first points values
						Width = BreadCrumbs_Options.MinimapSizeOfPoints1_Width;
						Height = BreadCrumbs_Options.MinimapSizeOfPoints1_Height;
					end;
				else -- The Minimap is not shown so assume the HUD is and use that's values
					if (BreadCrumbs_Options.HUDGradiant) then -- HUD Gradiant is enabled so use it
						Red = self.aryRedHUD[numGradPoint];
						Green = self.aryGreenHUD[numGradPoint];
						Blue = self.aryBlueHUD[numGradPoint];
						TextureOpacity = self.aryTextureOpacityHUD[numGradPoint];
					else -- HUD Gradiant is disabled so use first points values
						Red = BreadCrumbs_Options.HUDColour1.Red;
						Green = BreadCrumbs_Options.HUDColour1.Green;
						Blue = BreadCrumbs_Options.HUDColour1.Blue;
						TextureOpacity = BreadCrumbs_Options.HUDColour1.TextureOpacity;
					end;
					
					if (BreadCrumbs_Options.HUDSizeGradiant) then -- Size Gradiant is enabled so use it
						Width = self.aryHUDWidth[numGradPoint];
						Height = self.aryHUDHeight[numGradPoint];
					else -- Size Gradiant is disabled so use the first points values
						Width = BreadCrumbs_Options.HUDSizeOfPoints1_Width;
						Height = BreadCrumbs_Options.HUDSizeOfPoints1_Height;
					end;
				end;
			---------------------------------------------------------------
			
			
			
			if (numGradPoint < BreadCrumbs_Options.LastNumToHide) then -- If this is within the last specified number to hide then make it transparent
				-- ZMC:Msg(self, "MAKE INVISIBLE! - (numGradPoint( = "..tostring(numGradPoint)..") - BreadCrumbs_Options.NumPoints( = "..tostring(BreadCrumbs_Options["NumPoints"])..")) < BreadCrumbs_Options.LastNumToHide( = "..tostring(BreadCrumbs_Options.LastNumToHide).."))", true, DebugTxt);
				TextureOpacity = 0; -- Make transparent
			-- else
				-- ZMC:Msg(self, "LEAVE IT! - numGradPoint( = "..tostring(numGradPoint)..") < (BreadCrumbs_Options.LastNumToHide( = "..tostring(BreadCrumbs_Options.LastNumToHide)..") + 1)", true, DebugTxt);
			end;
			
			ZMC:Msg(self, "TextureOpacity = "..tostring(TextureOpacity)..", Red = "..tostring(Red)..", Green = "..tostring(Green)..", Blue = "..tostring(Blue).."", true, DebugTxt);
			
			---------------------------------------------------------------
			-- Store the new value for this point
			---------------------------------------------------------------
				value:SetWidth(Width); -- Sets frame's Width (will likely be changed later in the code)
				value:SetHeight(Height); -- Sets frame's Height (will likely be changed later in the code)
				value.texture:SetVertexColor(Red, Green, Blue, TextureOpacity) -- Sets the colour (Red, Green, Blue, TextureOpacity)
			---------------------------------------------------------------
		end;
	--------------------------------------------------------------------------------------------
end;

function BreadCrumbs:WipePoints() -- Removes all minimap icons
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:WipePoints()",true,DebugTxt);
	
	BreadCrumbs_Options.NextMovementHistorySlot = 1 -- Stores the next slot number for the position
	
	BreadCrumbs_Options.MovementHistory = {};
	for i=1, BreadCrumbs_Options["NumPoints"] do
		BreadCrumbs_Options.MovementHistory[i] = {}
		BreadCrumbs_Options.MovementHistory[i]["x"] = 0
		BreadCrumbs_Options.MovementHistory[i]["y"] = 0
	end;
	
	self.Astrolabe:RemoveAllMinimapIcons(); -- Removes all minimap icons
end;

function BreadCrumbs:TogAddon(value) -- Enables or Disables BreadCrumbs
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:TogAddon(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value has been passed so just invert the current one
		if BreadCrumbs_Options["Enabled"] == true then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value == true) then -- True passed so enable addon
		if (BreadCrumbs_Options["Enabled"] == false) then
			self:WipePoints(); -- Removes all minimap icons
			
			ZMC:Msg(self, L["Enabled."],false,DebugTxt);
		end;
		
		BreadCrumbs_Options["Enabled"] = true;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
	elseif (value == false) then -- False passed so enable addon
		BreadCrumbs_Options["Enabled"] = false;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
		
		self:WipePoints(); -- Removes all minimap icons
		
		ZMC:Msg(self, L["Disabled."],false,DebugTxt,true);
	else
		ZMC:Msg(self, "ERROR value not specified",true,DebugTxt,true);
	end;
end;

function BreadCrumbs:TogBreadDrop(value) -- Starts/Stops dropping a trail. (This won't delete or hide the existing trail)
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:TogBreadDrop(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value given so just toggle it to the opposite of it's current state
		if (BreadCrumbs_Options.Dropping) then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value) then -- Value specifed as true so turn it on
		BreadCrumbs_Options.Dropping = true;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
		
		ZMC:Msg(self, L["Started dropping BreadCrumbs"],false,DebugTxt);
	else -- Value specified and it's not true so assume it's false and turn it off
		BreadCrumbs_Options.Dropping = false;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
		
		ZMC:Msg(self, L["Stopped dropping BreadCrumbs"],false,DebugTxt,true);
	end;
end;

function BreadCrumbs:TogMiniGrad(value) -- Turns Gradiant on/off for the Minimap points
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:TogMiniGrad(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value given so just toggle it to the opposite of it's current state
		if (BreadCrumbs_Options.MinimapGradiant) then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value) then -- Value specifed as true so turn it on
		if (not(BreadCrumbs_Options.MinimapGradiant)) then -- Only do anything if the tog has changed
			ZMC:Msg(self, "BreadCrumbs_Options.MinimapGradiant = true;", true, DebugTxt);
			BreadCrumbs_Options.MinimapGradiant = true;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			-- if (self.OptionsPanel.MinimapColour2) then
				-- self.OptionsPanel.MinimapColour2:Enable(); -- Enable the colour picker for the last point as it's needed now.
				-- self.OptionsPanel.MinimapColour2:Show();
				
				-- self.OptionsPanel.MinimapColour1:SetPoint("TOPLEFT", self.OptionsPanel.MinimapColour2, "TOPRIGHT", 15, 0);
			-- end;
			
			self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
			
			self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
			
			ZMC:Msg(self, L["Enabled Minimap Gradiant"],false,DebugTxt);
		else
			ZMC:Msg(self, "value = "..tostring(value).." BreadCrumbs_Options.MinimapGradiant = "..tostring(BreadCrumbs_Options.MinimapGradiant).."", true, DebugTxt);
		end;
	else -- Value specified and it's not true so assume it's false and turn it off
		if (BreadCrumbs_Options.MinimapGradiant) then -- Only do anything if the tog has changed
			ZMC:Msg(self, "BreadCrumbs_Options.MinimapGradiant = false;", true, DebugTxt);
			BreadCrumbs_Options.MinimapGradiant = false;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			-- if (self.OptionsPanel.MinimapColour2) then
				-- self.OptionsPanel.MinimapColour2:Disable(); -- Disable the colour picker for the last point as it's not needed any more.
				-- self.OptionsPanel.MinimapColour2:Hide();
				
				-- self.OptionsPanel.MinimapColour1:SetPoint("TOPLEFT", self.OptionsPanel.MinimapColour2, "TOPLEFT", 0, 0);
			-- end;
			
			self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
			
			ZMC:Msg(self, L["Disabled Minimap Gradiant"],false,DebugTxt,true);
		else
			ZMC:Msg(self, "value = "..tostring(value).." BreadCrumbs_Options.MinimapGradiant = "..tostring(BreadCrumbs_Options.MinimapGradiant).."", true, DebugTxt);
		end;
	end;
end;

function BreadCrumbs:TogHUDGrad(value) -- Turns Gradiant on/off for the HUD points
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:TogHUDGrad(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value given so just toggle it to the opposite of it's current state
		if (BreadCrumbs_Options.HUDGradiant) then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value) then -- Value specifed as true so turn it on
		if (not(BreadCrumbs_Options.HUDGradiant)) then -- Only do anything if the tog has changed
			BreadCrumbs_Options.HUDGradiant = true;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			-- if (self.OptionsPanel.HUDColour2) then
				-- self.OptionsPanel.HUDColour2:Enable(); -- Enable the colour picker for the last point as it's needed now.
				-- self.OptionsPanel.HUDColour2:Show();
				
				-- self.OptionsPanel.HUDColour1:SetPoint("TOPLEFT", self.OptionsPanel.HUDColour2, "TOPRIGHT", 15, 0);
			-- end;
			
			self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
			
			self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
			
			ZMC:Msg(self, L["Enabled Sexymap HUD Gradiant"],false,DebugTxt);
		else
			ZMC:Msg(self, "value = "..tostring(value).." BreadCrumbs_Options.HUDGradiant = "..tostring(BreadCrumbs_Options.HUDGradiant).."", true, DebugTxt);
		end;
	else -- Value specified and it's not true so assume it's false and turn it off
		if (BreadCrumbs_Options.HUDGradiant) then -- Only do anything if the tog has changed
			BreadCrumbs_Options.HUDGradiant = false;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			-- if (self.OptionsPanel.HUDColour2) then
				-- self.OptionsPanel.HUDColour2:Disable(); -- Disable the colour picker for the last point as it's not needed any more.
				-- self.OptionsPanel.HUDColour2:Hide();
				
				-- self.OptionsPanel.HUDColour1:SetPoint("TOPLEFT", self.OptionsPanel.HUDColour2, "TOPLEFT", 0, 0);
			-- end;
			
			self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
			
			ZMC:Msg(self, L["Disabled Sexymap HUD Gradiant"],false,DebugTxt,true);
		else
			ZMC:Msg(self, "value = "..tostring(value).." BreadCrumbs_Options.HUDGradiant = "..tostring(BreadCrumbs_Options.HUDGradiant).."", true, DebugTxt);
		end;
	end;
end;

function BreadCrumbs:TogHUDSizeGrad(value) -- Turns Size Gradiant on/off for the HUD points
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:TogHUDSizeGrad(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value given so just toggle it to the opposite of it's current state
		if (BreadCrumbs_Options.HUDSizeGradiant) then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value) then -- Value specifed as true so turn it on
		if (not(BreadCrumbs_Options.HUDSizeGradiant)) then -- Only do anything if the tog has changed
			BreadCrumbs_Options.HUDSizeGradiant = true;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			-- if (self.OptionsPanel.HUDSizeOfPoints2) then
				-- self.OptionsPanel.HUDSizeOfPoints2:Enable(); -- Enable the size slider for the last point as it's needed now.
				-- self.OptionsPanel.HUDSizeOfPoints2:Show();
				
				-- self.OptionsPanel.HUDSizeOfPoints1:SetPoint("TOPLEFT", self.OptionsPanel.HUDSizeOfPoints2, "TOPRIGHT", 15, 0);
			-- end;
			
			self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
			
			self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
			
			ZMC:Msg(self, L["Enabled Sexymap HUD Size Gradiant"],false,DebugTxt);
		else
			ZMC:Msg(self, "value = "..tostring(value).." BreadCrumbs_Options.HUDSizeGradiant = "..tostring(BreadCrumbs_Options.HUDSizeGradiant).."", true, DebugTxt);
		end;
	else -- Value specified and it's not true so assume it's false and turn it off
		if (BreadCrumbs_Options.HUDSizeGradiant) then -- Only do anything if the tog has changed
			BreadCrumbs_Options.HUDSizeGradiant = false;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			-- if (self.OptionsPanel.HUDSizeOfPoints2) then
				-- self.OptionsPanel.HUDSizeOfPoints2:Disable(); -- Disable the size slider for the last point as it's not needed any more.
				-- self.OptionsPanel.HUDSizeOfPoints2:Hide();
				
				-- self.OptionsPanel.HUDSizeOfPoints1:SetPoint("TOPLEFT", self.OptionsPanel.HUDSizeOfPoints2, "TOPLEFT", 0, 0);
			-- end;
			
			self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
			
			ZMC:Msg(self, L["Disabled Sexymap HUD Size Gradiant"],false,DebugTxt,true);
		else
			ZMC:Msg(self, "value = "..tostring(value).." BreadCrumbs_Options.HUDSizeGradiant = "..tostring(BreadCrumbs_Options.HUDSizeGradiant).."", true, DebugTxt);
		end;
	end;
end;

function BreadCrumbs:TogMinimapSizeGrad(value) -- Turns Size Gradiant on/off for the Minimap points
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:TogMinimapSizeGrad(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value given so just toggle it to the opposite of it's current state
		if (BreadCrumbs_Options.MinimapSizeGradiant) then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value) then -- Value specifed as true so turn it on
		if (not(BreadCrumbs_Options.MinimapSizeGradiant)) then -- Only do anything if the tog has changed
			BreadCrumbs_Options.MinimapSizeGradiant = true;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			-- if (self.OptionsPanel.MinimapSizeOfPoints2) then
				-- self.OptionsPanel.MinimapSizeOfPoints2:Enable(); -- Enable the size slider for the last point as it's needed now.
				-- self.OptionsPanel.MinimapSizeOfPoints2:Show();
				
				-- self.OptionsPanel.MinimapSizeOfPoints1:SetPoint("TOPLEFT", self.OptionsPanel.MinimapSizeOfPoints2, "TOPRIGHT", 15, 0);
			-- end;
			
			self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
			
			self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
			
			ZMC:Msg(self, L["Enabled Minimap Size Gradiant"],false,DebugTxt);
		else
			ZMC:Msg(self, "value = "..tostring(value).." BreadCrumbs_Options.MinimapSizeGradiant = "..tostring(BreadCrumbs_Options.MinimapSizeGradiant).."", true, DebugTxt);
		end;
	else -- Value specified and it's not true so assume it's false and turn it off
		if (BreadCrumbs_Options.MinimapSizeGradiant) then -- Only do anything if the tog has changed
			BreadCrumbs_Options.MinimapSizeGradiant = false;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			-- if (self.OptionsPanel.MinimapSizeOfPoints2) then
				-- self.OptionsPanel.MinimapSizeOfPoints2:Disable(); -- Disable the size slider for the last point as it's not needed any more.
				-- self.OptionsPanel.MinimapSizeOfPoints2:Hide();
				
				-- self.OptionsPanel.MinimapSizeOfPoints1:SetPoint("TOPLEFT", self.OptionsPanel.MinimapSizeOfPoints2, "TOPLEFT", 0, 0);
			-- end;
			
			self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
			
			ZMC:Msg(self, L["Disabled Minimap Size Gradiant"],false,DebugTxt,true);
		else
			ZMC:Msg(self, "value = "..tostring(value).." BreadCrumbs_Options.MinimapSizeGradiant = "..tostring(BreadCrumbs_Options.MinimapSizeGradiant).."", true, DebugTxt);
		end;
	end;
end;

function BreadCrumbs:TogHideBread(value) -- Hides/unhides the trail. (This won't delete the trail and it will still be making one in the background unless it's stopped)
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:TogHideBread(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value given so just toggle it to the opposite of it's current state
		ZMC:Msg(self, "value == nil", true, DebugTxt);
		
		if (BreadCrumbs_Options["Hidden"]) then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value) then -- Value specifed as true so turn it on
		ZMC:Msg(self, "value == "..tostring(value), true, DebugTxt);
		
		if (BreadCrumbs_Options["Hidden"] == false) then -- Only unhide it if it's hidden... (lets you call this to unhide it knowing it won't do anything if not required)
			BreadCrumbs_Options["Hidden"] = true;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			for name, value in pairs(self.Points) do
				value.texture:SetTexture(BreadCrumbs.HiddenTexture)
			end;
			
			ZMC:Msg(self, L["Hidden"],false,DebugTxt,true);
		end;
	else -- Value specified and it's not true so assume it's false and turn it off
		ZMC:Msg(self, "value == "..tostring(value), true, DebugTxt);
		
		if (BreadCrumbs_Options["Hidden"] == true) then -- Only hide it if it's visable... (lets you call this to hide it knowing it won't do anything if not required)
			BreadCrumbs_Options["Hidden"] = false;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			for name, value in pairs(self.Points) do
				value.texture:SetTexture(BreadCrumbs_Options.Texture)
			end;
			
			ZMC:Msg(self, L["Unhidden"],false,DebugTxt);
		end;
	end;
end;

function BreadCrumbs:TogDropWhenDead(value) -- Stops/Starts dropping a trail when you are dead. (This won't delete or hide the existing trail)
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:TogDropWhenDead(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value given so just toggle it to the opposite of it's current state
		ZMC:Msg(self, "value == nil", true, DebugTxt);
		
		if (BreadCrumbs_Options["DontDropWhenDead"]) then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value) then -- Value specifed as true so turn it on
		ZMC:Msg(self, "value == "..tostring(value), true, DebugTxt);
		
		if (BreadCrumbs_Options["DontDropWhenDead"] == false) then -- Only change if needed... (lets you call this function knowing it won't do anything if not required)
			BreadCrumbs_Options["DontDropWhenDead"] = true;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			ZMC:Msg(self, L["Don't Drop When Dead Enabled"],false,DebugTxt);
		end;
	else -- Value specified and it's not true so assume it's false and turn it off
		ZMC:Msg(self, "value == "..tostring(value), true, DebugTxt);
		
		if (BreadCrumbs_Options["DontDropWhenDead"] == true) then -- Only hide it if it's visable... (lets you call this to hide it knowing it won't do anything if not required)
			BreadCrumbs_Options["DontDropWhenDead"] = false;
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
			
			ZMC:Msg(self, L["Don't Drop When Dead Disabled"],false,DebugTxt,true);
		end;
	end;
end;

function BreadCrumbs:ResetAllSettings() -- Deletes all settings and restarts UI
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	ZMC:Msg(self, "BreadCrumbs:ResetAllSettings()",true,DebugTxt);
	
	self:TogAddon(false); -- Disables BreadCrumbs to ensure it doesn't error
	BreadCrumbs_Options = nil; -- Wipes the settings
	ReloadUI(); -- Reloads the UI so BreadCrumbs reinitialize correctly
end;

BreadCrumbs:RegisterEvent("ADDON_LOADED"); -- BCatch when this addon has finished loading
BreadCrumbs:SetScript("OnEvent", BreadCrumbs.OnEvent);