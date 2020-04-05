--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * _NPCScan.Overlay.Config.lua - Adds a configuration pane to enable and      *
  *   disable display modules like the WorldMap and BattlefieldMinimap.        *
  ****************************************************************************]]


local Overlay = select( 2, ... );
local L = _NPCScanOverlayLocalization;
local me = CreateFrame( "Frame" );
Overlay.Config = me;

me.ShowAll = CreateFrame( "CheckButton", "_NPCScanOverlayConfigShowAllCheckbox", me, "InterfaceOptionsCheckButtonTemplate" );

local ModuleMethods = setmetatable( {}, getmetatable( me ) );
me.ModuleMeta = { __index = ModuleMethods; };

local IsChildAddOn = IsAddOnLoaded( "_NPCScan" );




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config.ModuleMeta.__index:AddControl            *
  ****************************************************************************]]
function ModuleMethods:AddControl ( Control )
	self[ #self + 1 ] = Control;
	Control:SetEnabled( self.Module.Registered and self.Enabled:GetChecked() );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config.ModuleMeta.__index:SetEnabled            *
  ****************************************************************************]]
do
	local function SetControlsEnabled ( Config, Enabled ) -- Enables/disables all registered controls
		for _, Control in ipairs( Config ) do
			Control:SetEnabled( Enabled );
		end
	end
	function ModuleMethods:SetEnabled ( Enabled )
		self.Enabled:SetChecked( Enabled );
		if ( self.Module.Registered ) then
			SetControlsEnabled( self, Enabled );
		end
	end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config.ModuleMeta.__index:Unregister            *
  ****************************************************************************]]
	function ModuleMethods:Unregister ()
		self.Enabled:SetEnabled( false );
		SetControlsEnabled( self, false );

		local Color = GRAY_FONT_COLOR;
		_G[ self:GetName().."Title" ]:SetTextColor( Color.r, Color.g, Color.b );
	end
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:ControlOnEnter                           *
  * Description: Shows the control's tooltip.                                  *
  ****************************************************************************]]
function me:ControlOnEnter ()
	if ( self.tooltipText ) then
		GameTooltip:SetOwner( self, "ANCHOR_TOPLEFT" );
		GameTooltip:SetText( self.tooltipText, nil, nil, nil, nil, 1 );
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:ModuleCheckboxSetEnabled                 *
  ****************************************************************************]]
function me:ModuleCheckboxSetEnabled ( Enable )
	( Enable and BlizzardOptionsPanel_CheckButton_Enable or BlizzardOptionsPanel_CheckButton_Disable )( self );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:ModuleSliderSetEnabled                   *
  ****************************************************************************]]
function me:ModuleSliderSetEnabled ( Enable )
	( Enable and BlizzardOptionsPanel_Slider_Enable or BlizzardOptionsPanel_Slider_Disable )( self );
end

--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config.ShowAll.setFunc                          *
  ****************************************************************************]]
function me.ShowAll.setFunc ( Enable )
	Overlay.SetShowAll( Enable == "1" );
end

--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:ModuleEnabledOnClick                     *
  ****************************************************************************]]
function me:ModuleEnabledOnClick ()
	local Enable = self:GetChecked() == 1;

	PlaySound( Enable and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff" );
	Overlay.Modules[ Enable and "Enable" or "Disable" ]( self:GetParent().Module.Name );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:ModuleAlphaOnValueChanged                *
  ****************************************************************************]]
function me:ModuleAlphaOnValueChanged ( Value )
	Overlay.Modules.SetAlpha( self:GetParent().Module.Name, Value );
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config.ModuleRegister                           *
  ****************************************************************************]]
do
	local LastFrame;
	function me.ModuleRegister ( Module, Label )
		local Frame = CreateFrame( "Frame", "_NPCScanOverlayModule"..Module.Name, me.ScrollChild, "OptionsBoxTemplate" );
		Frame.Module = Module;
		setmetatable( Frame, me.ModuleMeta );

		_G[ Frame:GetName().."Title" ]:SetText( Label );
		Frame:SetPoint( "RIGHT", me.ScrollChild:GetParent(), -4, 0 );
		if ( LastFrame ) then
			Frame:SetPoint( "TOPLEFT", LastFrame, "BOTTOMLEFT", 0, -16 );
		else
			Frame:SetPoint( "TOPLEFT", 4, -14 );
		end
		LastFrame = Frame;

		local Enabled = CreateFrame( "CheckButton", "$parentEnabled", Frame, "UICheckButtonTemplate" );
		Frame.Enabled = Enabled;
		Enabled:SetPoint( "TOPLEFT", 6, -6 );
		Enabled:SetSize( 26, 26 );
		Enabled:SetScript( "OnClick", me.ModuleEnabledOnClick );
		local Label = _G[ Enabled:GetName().."Text" ];
		Label:SetText( L.CONFIG_ENABLE );
		Enabled:SetHitRectInsets( 4, 4 - Label:GetStringWidth(), 4, 4 );
		Enabled.SetEnabled = me.ModuleCheckboxSetEnabled;

		local Alpha = CreateFrame( "Slider", "$parentAlpha", Frame, "OptionsSliderTemplate" );
		Frame.Alpha = Alpha;
		Alpha:SetPoint( "TOP", 0, -16 );
		Alpha:SetPoint( "RIGHT", -8, 0 );
		Alpha:SetPoint( "LEFT", Label, "RIGHT", 16, 0 );
		Alpha:SetMinMaxValues( 0, 1 );
		Alpha:SetScript( "OnValueChanged", me.ModuleAlphaOnValueChanged );
		Alpha.SetEnabled = me.ModuleSliderSetEnabled;
		local AlphaName = Alpha:GetName();
		_G[ AlphaName.."Text" ]:SetText( L.CONFIG_ALPHA );
		_G[ AlphaName.."Low" ]:Hide();
		_G[ AlphaName.."High" ]:Hide();
		Frame:AddControl( Alpha );

		Frame:SetHeight( Alpha:GetHeight() + 16 + 4 );
		return Frame;
	end
end


--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:default                                  *
  ****************************************************************************]]
function me:default ()
	Overlay.Synchronize();
end




local TableCreateBackup;
if ( IsChildAddOn ) then
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:TableSetHeader                           *
  ****************************************************************************]]
	local Args = {};
	local select = select;
	local function Append ( NewValue, ... ) -- Appends a value to a vararg list
		local Count = select( "#", ... );
		for Index = 1, Count do
			Args[ Index ] = select( Index, ... );
		end
		for Index = Count + 1, #Args do
			Args[ Index ] = nil;
		end
		Args[ Count + 1 ] = NewValue;
		return unpack( Args, 1, Count + 1 );
	end

	local SetHeaderBackup;
	function me:TableSetHeader ( ... )
		return SetHeaderBackup( self, Append( L.CONFIG_ZONE, ... ) );
	end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:TableSetSortHandlers                     *
  ****************************************************************************]]
	local SetSortHandlersBackup;
	function me:TableSetSortHandlers ( ... )
		return SetSortHandlersBackup( self, Append( true, ... ) ); -- Make map row sortable
	end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:TableAddRow                              *
  ****************************************************************************]]
	local AddRowBackup;
	function me:TableAddRow ( ... )
		local Map = Overlay.NPCMaps[ select( 4, ... ) ]; -- Arg 4 is NpcID
		if ( Map ) then
			return AddRowBackup( self, Append( Overlay.GetZoneName( Map ), ... ) );
		else
			return AddRowBackup( self, ... );
		end
	end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config:TableCreate                              *
  * Description: Hooks _NPCScan's "Search" table to add a zone column.         *
  ****************************************************************************]]
	local function HookTable ( Table, ... )
		if ( Table ) then -- Just created
			SetHeaderBackup = Table.SetHeader;
			SetSortHandlersBackup = Table.SetSortHandlers;
			AddRowBackup = Table.AddRow;
			Table.SetHeader = me.TableSetHeader;
			Table.SetSortHandlers = me.TableSetSortHandlers;
			Table.AddRow = me.TableAddRow;
		end
		return Table, ...;
	end
	function me:TableCreate ( ... )
		return HookTable( TableCreateBackup( self, ... ) );
	end
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Config.SlashCommand                             *
  * Description: Slash command chat handler to open the options pane.          *
  ****************************************************************************]]
function me.SlashCommand ()
	InterfaceOptionsFrame_OpenToCategory( me );
end




local Label = L[ IsChildAddOn and "CONFIG_TITLE" or "CONFIG_TITLE_STANDALONE" ];
me.name = Label;
me:Hide();

-- Pane title
me.Title = me:CreateFontString( nil, "ARTWORK", "GameFontNormalLarge" );
me.Title:SetPoint( "TOPLEFT", 16, -16 );
me.Title:SetText( Label );
local SubText = me:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" );
me.SubText = SubText;
SubText:SetPoint( "TOPLEFT", me.Title, "BOTTOMLEFT", 0, -8 );
SubText:SetPoint( "RIGHT", -32, 0 );
SubText:SetHeight( 32 );
SubText:SetJustifyH( "LEFT" );
SubText:SetJustifyV( "TOP" );
SubText:SetText( L.CONFIG_DESC );


me.ShowAll:SetPoint( "TOPLEFT", SubText, "BOTTOMLEFT", -2, -8 );
_G[ me.ShowAll:GetName().."Text" ]:SetText( L.CONFIG_SHOWALL );
me.ShowAll.tooltipText = L.CONFIG_SHOWALL_DESC;


-- Module options scrollframe
local Background = CreateFrame( "Frame", nil, me, "OptionsBoxTemplate" );
Background:SetPoint( "TOPLEFT", me.ShowAll, "BOTTOMLEFT", 0, -8 );
Background:SetPoint( "BOTTOMRIGHT", -32, 16 );
local Texture = Background:CreateTexture( nil, "BACKGROUND" );
Texture:SetTexture( 0, 0, 0, 0.5 );
Texture:SetPoint( "BOTTOMLEFT", 5, 5 );
Texture:SetPoint( "TOPRIGHT", -5, -5 );

local ScrollFrame = CreateFrame( "ScrollFrame", "_NPCScanOverlayScrollFrame", Background, "UIPanelScrollFrameTemplate" );
ScrollFrame:SetPoint( "TOPLEFT", 4, -4 );
ScrollFrame:SetPoint( "BOTTOMRIGHT", -4, 4 );

me.ScrollChild = CreateFrame( "Frame" );
ScrollFrame:SetScrollChild( me.ScrollChild );
me.ScrollChild:SetSize( 1, 1 );


if ( IsChildAddOn ) then
	Overlay.SafeCall( function ()
		me.parent = assert( _NPCScan.Config.name );
		TableCreateBackup = assert( _NPCScan.Config.Search.TableCreate );
		_NPCScan.Config.Search.TableCreate = me.TableCreate;
	end );
end
InterfaceOptions_AddCategory( me );

SlashCmdList[ "_NPCSCAN_OVERLAY" ] = me.SlashCommand;