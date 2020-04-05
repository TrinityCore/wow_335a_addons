--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * _NPCScan.Overlay.WorldMap.lua - Canvas for the WorldMap.                   *
  ****************************************************************************]]


local L = _NPCScanLocalization.OVERLAY;
local Overlay = _NPCScan.Overlay;
local me = CreateFrame( "Frame", nil, WorldMapDetailFrame );
Overlay.WorldMap = me;

me.Label = L.MODULE_WORLDMAP;
me.AlphaDefault = 0.55;

me.Key = CreateFrame( "Frame", nil, WorldMapButton );
me.Toggle = CreateFrame( "CheckButton", "_NPCScanOverlayWorldMapToggle", WorldMapFrame, "OptionsCheckButtonTemplate" );

me.AchievementNPCNames = {};




--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap.Key:OnEnter                            *
  ****************************************************************************]]
do
	local Points = { "BOTTOMLEFT", "BOTTOMRIGHT", "TOPRIGHT" };
	local Point = 0;
	function me.Key:OnEnter ()
		local AnchorTarget = select( 2, self:GetPoint() );
		self:ClearAllPoints();
		self:SetPoint( Points[ Point % #Points + 1 ], AnchorTarget );
		Point = Point + 1;
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap.Key:Paint                              *
  ****************************************************************************]]
do
	local Count, Height, Width;
	local NPCNames = {};
	local function PaintKey ( self, PathData, FoundX, FoundY, R, G, B, NpcID )
		Count = Count + 1;
		local Line = self[ Count ];
		if ( not Line ) then
			Line = self.Body:CreateFontString( nil, "OVERLAY", "ChatFontNormal" );
			Line:SetPoint( "TOPLEFT", Count == 1 and self.Title or self[ Count - 1 ], "BOTTOMLEFT" );
			Line:SetPoint( "RIGHT", self.Title );
			Line:SetJustifyH( "LEFT" );
			self[ Count ] = Line;
		else
			Line:Show();
		end

		Line:SetText( L.MODULE_WORLDMAP_KEY_FORMAT:format( me.AchievementNPCNames[ NpcID ] or NPCNames[ NpcID ] or NpcID ) );
		Line:SetTextColor( R, G, B );

		Width = max( Width, Line:GetStringWidth() );
		Height = Height + Line:GetStringHeight();
	end
	local function MapHasNPCs ( Map )
		local MapData = Overlay.PathData[ Map ];
		if ( MapData ) then
			for NpcID in pairs( MapData ) do
				if ( Overlay.NPCsEnabled[ NpcID ] ) then
					return true;
				end
			end
		end
	end
	function me.Key:Paint ( Map )
		if ( MapHasNPCs( Map ) ) then
			Width = self.Title:GetStringWidth();
			Height = self.Title:GetStringHeight();
			Count = 0;

			-- Cache custom mob names
			for Name, NpcID in pairs( _NPCScan.OptionsCharacter.NPCs ) do
				NPCNames[ NpcID ] = Name;
			end
			Overlay.ApplyZone( self, Map, PaintKey );
			wipe( NPCNames );

			for Index = Count + 1, #self do
				self[ Index ]:Hide();
			end
			self:SetWidth( Width + 32 );
			self:SetHeight( Height + 32 );
			self:Show();
		else
			self:Hide();
		end
	end
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap:Paint                                  *
  ****************************************************************************]]
do
	local function PaintPath ( self, PathData, FoundX, FoundY, R, G, B, NpcID )
		Overlay.DrawPath( self, PathData, "ARTWORK", R, G, B );
		if ( FoundX ) then
			Overlay.DrawFound( self, FoundX, FoundY, Overlay.DetectionRadius / Overlay.GetZoneSize( Overlay.NPCMaps[ NpcID ] ), "OVERLAY", R, G, B );
		end
	end
	function me:Paint ( Map )
		Overlay.ApplyZone( self, Map, PaintPath );
	end
end


--[[****************************************************************************
  * Function: local MapUpdate                                                  *
  ****************************************************************************]]
local MapUpdate;
do
	local function OnUpdate ( self )
		self:SetScript( "OnUpdate", nil );

		local Map = GetMapInfo();
		if ( Map ~= self.MapLast ) then
			self.MapLast = Map;

			Overlay.TextureRemoveAll( self );
			self:Paint( Map );
			if ( self.Key ) then
				self.Key:Paint( Map );
			end
		end
	end
	function MapUpdate ( self, Force )
		if ( Force ) then
			self.MapLast = nil;
		end
		self:SetScript( "OnUpdate", OnUpdate );
	end
end


--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap.Toggle.setFunc                         *
  * Description: Toggles the module from the WorldMap frame.                   *
  ****************************************************************************]]
function me.Toggle.setFunc ( Enable )
	Overlay[ Enable == "1" and "ModuleEnable" or "ModuleDisable" ]( "WorldMap" );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap.Toggle:OnEnter                         *
  ****************************************************************************]]
function me.Toggle:OnEnter ()
	WorldMapTooltip:SetOwner( self, "ANCHOR_LEFT" );
	WorldMapTooltip:SetText( L.MODULE_WORLDMAP_TOGGLE_DESC, nil, nil, nil, nil, 1 );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap.Toggle:OnLeave                         *
  ****************************************************************************]]
function me.Toggle:OnLeave ()
	WorldMapTooltip:Hide();
end


--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap:OnShow                                 *
  ****************************************************************************]]
function me:OnShow ()
	MapUpdate( self );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap:OnEvent                                *
  ****************************************************************************]]
function me:OnEvent ()
	MapUpdate( self ); -- WORLD_MAP_UPDATE
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap:OnLoad                                 *
  ****************************************************************************]]
function me:OnLoad ()
	self:Hide();
	self:SetAllPoints();
	self:SetScript( "OnShow", me.OnShow );
	self:SetScript( "OnEvent", me.OnEvent );
end


--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap:Update                                 *
  ****************************************************************************]]
function me:Update ( Map )
	if ( not Map or Map == self.MapLast ) then
		MapUpdate( self, true );
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap:Disable                                *
  ****************************************************************************]]
function me:Disable ()
	self:UnregisterEvent( "WORLD_MAP_UPDATE" );
	self:Hide();
	if ( self.Key ) then
		self.Key:Hide();
	end
	Overlay.TextureRemoveAll( self );

	if ( self.Toggle ) then
		self.Toggle:SetChecked( false );
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.WorldMap:Enable                                 *
  ****************************************************************************]]
function me:Enable ()
	self:RegisterEvent( "WORLD_MAP_UPDATE" );
	self:Show();

	if ( self.Toggle ) then
		self.Toggle:SetChecked( true );
	end
end




--------------------------------------------------------------------------------
-- Function Hooks / Execution
-----------------------------

do
	local Key = me.Key;
	Key:SetPoint( "BOTTOMLEFT" );
	Key:SetScript( "OnEnter", Key.OnEnter );
	Key:OnEnter();
	Key:EnableMouse( true );
	Key:SetAlpha( 0.8 );
	Key:SetBackdrop( {
		edgeFile = [[Interface\AchievementFrame\UI-Achievement-WoodBorder]]; edgeSize = 48;
	} );
	Key.Body = CreateFrame( "Frame", nil, Key );
	Key.Body:SetPoint( "BOTTOMLEFT", 10, 10 );
	Key.Body:SetPoint( "TOPRIGHT", -10, -10 );
	Key.Body:SetBackdrop( {
		bgFile = [[Interface\AchievementFrame\UI-Achievement-AchievementBackground]];
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]]; edgeSize = 16;
		insets = { left = 3; right = 3; top = 3; bottom = 3; };
	} );
	Key.Body:SetBackdropBorderColor( 0.8, 0.4, 0.2 ); -- Light brown

	local TitleBackground = Key.Body:CreateTexture( nil, "BORDER" );
	TitleBackground:SetTexture( [[Interface\AchievementFrame\UI-Achievement-Title]] );
	TitleBackground:SetPoint( "TOPRIGHT", -5, -5 );
	TitleBackground:SetPoint( "LEFT", 5, 0 );
	TitleBackground:SetHeight( 18 );
	TitleBackground:SetTexCoord( 0, 0.9765625, 0, 0.3125 );
	TitleBackground:SetAlpha( 0.8 );

	local Title = Key.Body:CreateFontString( nil, "OVERLAY", "GameFontHighlightMedium" );
	Key.Title = Title;
	Title:SetAllPoints( TitleBackground );
	Title:SetText( L.MODULE_WORLDMAP_KEY );


	-- Create toggle button on the WorldMap
	local Toggle = me.Toggle;
	local Label = _G[ Toggle:GetName().."Text" ];
	Label:SetText( L.MODULE_WORLDMAP_TOGGLE );
	local LabelWidth = Label:GetStringWidth();
	Toggle:SetHitRectInsets( 4, 4 - LabelWidth, 4, 4 );
	Toggle:SetPoint( "RIGHT", WorldMapQuestShowObjectives, "LEFT", -LabelWidth - 8, 0 );
	Toggle:SetScript( "OnEnter", Toggle.OnEnter );
	Toggle:SetScript( "OnLeave", Toggle.OnLeave );


	-- Cache achievement NPC names
	for AchievementID, Achievement in pairs( _NPCScan.Achievements ) do
		for CriteriaID, NpcID in pairs( Achievement.Criteria ) do
			me.AchievementNPCNames[ NpcID ] = GetAchievementCriteriaInfo( CriteriaID );
		end
	end


	me:OnLoad();
	Overlay.ModuleRegister( "WorldMap", me );
end
