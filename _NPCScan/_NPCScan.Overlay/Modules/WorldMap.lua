--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Modules/WorldMap.lua - Canvas for the WorldMapFrame.                       *
  ****************************************************************************]]


local L = _NPCScanOverlayLocalization;
local Overlay = select( 2, ... );
local me = Overlay.Modules.WorldMapTemplate.Embed( CreateFrame( "Frame", nil, WorldMapDetailFrame ) );

me.KeyMinScale = 0.5; -- Minimum effective scale to render the key at
me.KeyMaxSize = 1 / 3; -- If the key takes up more than this fraction of the canvas, hide it




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:KeyOnEnter                *
  ****************************************************************************]]
do
	local Points = { "BOTTOMLEFT", "BOTTOMRIGHT", "TOPRIGHT" };
	local Point = 0;
	function me:KeyOnEnter ()
		self:ClearAllPoints();
		self:SetPoint( Points[ Point % #Points + 1 ] );
		Point = Point + 1;
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:KeyPaint                  *
  ****************************************************************************]]
do
	local Count, Height, Width;
	local function KeyAddLine ( self, PathData, FoundX, FoundY, R, G, B, NpcID )
		Count = Count + 1;
		local Line = self[ Count ];
		if ( not Line ) then
			Line = self.Body:CreateFontString( nil, "OVERLAY", self.Font:GetName() );
			Line:SetPoint( "TOPLEFT", Count == 1 and self.Title or self[ Count - 1 ], "BOTTOMLEFT" );
			Line:SetPoint( "RIGHT", self.Title );
			self[ Count ] = Line;
		else
			Line:Show();
		end

		Line:SetText( L.MODULE_WORLDMAP_KEY_FORMAT:format( me.AchievementNPCNames[ NpcID ] or L.NPCS[ NpcID ] or NpcID ) );
		Line:SetTextColor( R, G, B );

		Width = max( Width, Line:GetStringWidth() );
		Height = Height + Line:GetStringHeight();
	end
	local function MapHasNPCs ( Map )
		local MapData = Overlay.PathData[ Map ];
		if ( MapData ) then
			if ( Overlay.Options.ShowAll ) then
				return true;
			end
			for NpcID in pairs( MapData ) do
				if ( Overlay.NPCsEnabled[ NpcID ] ) then
					return true;
				end
			end
		end
	end
	function me:KeyPaint ( Map )
		if ( MapHasNPCs( Map ) ) then
			Width = self.Title:GetStringWidth();
			Height = self.Title:GetStringHeight();
			Count = 0;

			Overlay.ApplyZone( self, Map, KeyAddLine );

			for Index = Count + 1, #self do
				self[ Index ]:Hide();
			end
			self:SetSize( Width + 32, Height + 32 );
			self:Show();
		else
			self:Hide();
		end
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:KeyParentValidateSize     *
  ****************************************************************************]]
function me:KeyParentValidateSize ()
	local Width, Height = self:GetSize();
	local KeyScale, KeyWidth, KeyHeight = self.Key:GetScale(), self.Key:GetSize();
	-- Hide if it covers too much of the canvas
	if ( KeyWidth * KeyScale > Width * me.KeyMaxSize or KeyHeight * KeyScale > Height * me.KeyMaxSize ) then
		self.Container:Hide(); -- KeyParent must remain visible so OnSizeChanged still fires
	else
		self.Container:Show();
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:KeyParentOnSizeChanged    *
  ****************************************************************************]]
function me:KeyParentOnSizeChanged ()
	self.Key:SetScale( max( 1, me.KeyMinScale / self:GetEffectiveScale() ) );
	me.KeyParentValidateSize( self );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:KeyOnSizeChanged          *
  ****************************************************************************]]
function me:KeyOnSizeChanged ()
	me.KeyParentValidateSize( self.KeyParent );
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap.ToggleSetFunc             *
  * Description: Toggles the module from the WorldMap frame.                   *
  ****************************************************************************]]
function me.ToggleSetFunc ( Enable )
	Overlay.Modules[ Enable == "1" and "Enable" or "Disable" ]( "WorldMap" );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:ToggleOnEnter             *
  ****************************************************************************]]
function me:ToggleOnEnter ()
	WorldMapTooltip:SetOwner( self, "ANCHOR_TOPLEFT" );
	WorldMapTooltip:SetText( L.MODULE_WORLDMAP_TOGGLE_DESC, nil, nil, nil, nil, 1 );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:ToggleOnLeave             *
  ****************************************************************************]]
function me:ToggleOnLeave ()
	WorldMapTooltip:Hide();
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:Paint                     *
  ****************************************************************************]]
function me:Paint ( ... )
	self.KeyPaint( self.KeyParent.Key, ... );
	return self.super.Paint( self, ... );
end

--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:OnEnable                  *
  ****************************************************************************]]
function me:OnEnable ( ... )
	self.Toggle:SetChecked( true );
	self.KeyParent:Show();
	return self.super.OnEnable( self, ... );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:OnDisable                 *
  ****************************************************************************]]
function me:OnDisable ( ... )
	self.Toggle:SetChecked( false );
	self.KeyParent:Hide();
	return self.super.OnDisable( self, ... );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:OnLoad                    *
  ****************************************************************************]]
function me:OnLoad ( ... )
	-- Add key frame to map
	local KeyParent = CreateFrame( "Frame", nil, WorldMapButton );
	self.KeyParent = KeyParent;
	KeyParent:Hide();
	KeyParent:SetAllPoints();
	KeyParent:SetScript( "OnSizeChanged", me.KeyParentOnSizeChanged );

	KeyParent.Container = CreateFrame( "Frame", nil, KeyParent );
	KeyParent.Container:SetAllPoints();

	local Key = CreateFrame( "Frame", nil, KeyParent.Container );
	KeyParent.Key, Key.KeyParent = Key, KeyParent;
	Key:SetScript( "OnEnter", self.KeyOnEnter );
	Key:SetScript( "OnSizeChanged", me.KeyOnSizeChanged );
	self.KeyOnEnter( Key ); -- Initialize starting point
	Key:EnableMouse( true );
	Key:SetBackdrop( {
		edgeFile = [[Interface\AchievementFrame\UI-Achievement-WoodBorder]]; edgeSize = 48;
	} );

	Key.Font = CreateFont( "_NPCScanOverlayWorldMapKeyFont" );
	Key.Font:SetFontObject( ChatFontNormal );
	Key.Font:SetJustifyH( "LEFT" );

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
	local Toggle = CreateFrame( "CheckButton", "_NPCScanOverlayWorldMapToggle", WorldMapFrame, "OptionsCheckButtonTemplate" );
	self.Toggle = Toggle;
	local Label = _G[ Toggle:GetName().."Text" ];
	Label:SetText( L.MODULE_WORLDMAP_TOGGLE );
	local LabelWidth = Label:GetStringWidth();
	Toggle:SetHitRectInsets( 4, 4 - LabelWidth, 4, 4 );
	Toggle:SetPoint( "RIGHT", WorldMapQuestShowObjectives, "LEFT", -LabelWidth - 8, 0 );
	Toggle:SetScript( "OnEnter", self.ToggleOnEnter );
	Toggle:SetScript( "OnLeave", self.ToggleOnLeave );
	Toggle.setFunc = self.ToggleSetFunc;


	-- Cache achievement NPC names
	self.AchievementNPCNames = {};
	for AchievementID in pairs( Overlay.Achievements ) do
		for Criteria = 1, GetAchievementNumCriteria( AchievementID ) do
			local Name, CriteriaType, _, _, _, _, _, AssetID = GetAchievementCriteriaInfo( AchievementID, Criteria );
			if ( CriteriaType == 0 ) then -- Mob kill type
				self.AchievementNPCNames[ AssetID ] = Name;
			end
		end
	end

	return self.super.OnLoad( self, ... );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.WorldMap:OnUnload                  *
  ****************************************************************************]]
function me:OnUnload ( ... )
	self.KeyParent:SetScript( "OnSizeChanged", nil );
	self.KeyParent.Key:SetScript( "OnEnter", nil );
	self.KeyParent.Key:SetScript( "OnSizeChanged", nil );

	self.Toggle:Hide();
	self.Toggle:SetScript( "OnEnter", nil );
	self.Toggle:SetScript( "OnLeave", nil );

	return self.super.OnUnload( self, ... );
end




Overlay.Modules.Register( "WorldMap", me, L.MODULE_WORLDMAP );