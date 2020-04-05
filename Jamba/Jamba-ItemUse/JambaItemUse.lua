--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaItemUse", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceTimer-3.0"
)

-- Get the Jamba Utilities Library.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
AJM.SharedMedia = LibStub( "LibSharedMedia-3.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-ItemUse"
AJM.settingsDatabaseName = "JambaItemUseProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-item-use"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Item Use"]

-- Jamba key bindings.
BINDING_HEADER_JAMBAITEMUSE = L["Jamba-Item-Use"]
BINDING_NAME_JAMBAITEMUSE1 = L["Item 1"]
BINDING_NAME_JAMBAITEMUSE2 = L["Item 2"]
BINDING_NAME_JAMBAITEMUSE3 = L["Item 3"]
BINDING_NAME_JAMBAITEMUSE4 = L["Item 4"]
BINDING_NAME_JAMBAITEMUSE5 = L["Item 5"]
BINDING_NAME_JAMBAITEMUSE6 = L["Item 6"]
BINDING_NAME_JAMBAITEMUSE7 = L["Item 7"]
BINDING_NAME_JAMBAITEMUSE8 = L["Item 8"]
BINDING_NAME_JAMBAITEMUSE9 = L["Item 9"]
BINDING_NAME_JAMBAITEMUSE10 = L["Item 10"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		showItemUse = true,
		showItemUseOnMasterOnly = true,
		hideItemUseInCombat = false,
		borderStyle = L["Blizzard Tooltip"],
		backgroundStyle = L["Blizzard Dialog Background"],
		itemUseScale = 1,
		itemUseTitleHeight = 15,
		itemUseVerticalSpacing = 4,
		itemUseHorizontalSpacing = 2,
		itemsAreStackedVertically = false,
		numberOfItems = 5,
		messageArea = JambaApi.DefaultMessageArea(),
		items = {},
		framePoint = "CENTER",
		frameRelativePoint = "CENTER",
		frameXOffset = 0,
		frameYOffset = 0,
		frameAlpha = 1.0,
		frameBackgroundColourR = 1.0,
		frameBackgroundColourG = 1.0,
		frameBackgroundColourB = 1.0,
		frameBackgroundColourA = 1.0,
		frameBorderColourR = 1.0,
		frameBorderColourG = 1.0,
		frameBorderColourB = 1.0,
		frameBorderColourA = 1.0,		
	},
}

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = 'group',
		args = {	
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the item use settings to all characters in the team."],
				usage = "/jamba-item-use push",
				get = false,
				set = "JambaSendSettings",
			},											
			hide = {
				type = "input",
				name = L["Hide Item Bar"],
				desc = L["Hide the item bar panel."],
				usage = "/jamba-item-use hide",
				get = false,
				set = "HideItemUseCommand",
			},	
			show = {
				type = "input",
				name = L["Show Item Bar"],
				desc = L["Show the item bar panel."],
				usage = "/jamba-item-use show",
				get = false,
				set = "ShowItemUseCommand",
			},							
		},
	}
	return configuration
end

local function DebugMessage( ... )
	--AJM:Print( ... )
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Variables used by module.
-------------------------------------------------------------------------------------------------------------

AJM.globalFramePrefix = "JambaItemUse"
AJM.itemContainer = {}
AJM.itemUseCreated = false	
AJM.itemSize = 40
AJM.refreshItemUseControlsPending = false
AJM.refreshUpdateItemsInBarPending = false
AJM.refreshUpdateBindingsPending = false
AJM.maximumNumberOfItems = 10

-------------------------------------------------------------------------------------------------------------
-- Item Bar.
-------------------------------------------------------------------------------------------------------------

local function CanDisplayItemUse()
	local canShow = false
	if AJM.db.showItemUse == true then
		if AJM.db.showItemUseOnMasterOnly == true then
			if JambaApi.IsCharacterTheMaster( AJM.characterName ) == true then
				canShow = true
			end
		else
			canShow = true
		end
	end
	return canShow
end

local function CreateJambaItemUseFrame()
	-- The frame.
	local frame = CreateFrame( "Frame", "JambaItemUseWindowFrame", UIParent )
	frame.parentObject = AJM
	frame:SetFrameStrata( "LOW" )
	frame:SetToplevel( true )
	frame:SetClampedToScreen( true )
	frame:EnableMouse()
	frame:SetMovable( true )	
	frame:RegisterForDrag( "LeftButton" )
	frame:SetScript( "OnDragStart", 
		function( this ) 
			if IsAltKeyDown() == 1 then
				this:StartMoving() 
			end
		end )
	frame:SetScript( "OnDragStop", 
		function( this ) 
			this:StopMovingOrSizing() 
			point, relativeTo, relativePoint, xOffset, yOffset = this:GetPoint()
			AJM.db.framePoint = point
			AJM.db.frameRelativePoint = relativePoint
			AJM.db.frameXOffset = xOffset
			AJM.db.frameYOffset = yOffset
		end	)	
	frame:ClearAllPoints()
	frame:SetPoint( AJM.db.framePoint, UIParent, AJM.db.frameRelativePoint, AJM.db.frameXOffset, AJM.db.frameYOffset )
	frame:SetBackdrop( {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
		tile = true, tileSize = 10, edgeSize = 10, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	} )
	-- Create the title for the item bar frame.
	local titleName = frame:CreateFontString( "JambaItemUseWindowFrameTitleText", "OVERLAY", "GameFontNormal" )
	titleName:SetPoint( "TOP", frame, "TOP", 0, -5 )
	titleName:SetTextColor( 1.00, 1.00, 1.00 )
	titleName:SetText( L["Items"] )
	frame.titleName = titleName
	-- Set transparency of the the frame (and all its children).
	frame:SetAlpha(AJM.db.frameAlpha)
	-- Set the global frame reference for this frame.
	JambaItemUseFrame = frame
	AJM:SettingsUpdateBorderStyle()	
	AJM.itemUseCreated = true
end

local function UpdateJambaItemUseDimensions()
	local frame = JambaItemUseFrame
	if AJM.db.itemsAreStackedVertically == true then
		frame:SetWidth( 6 + (AJM.db.itemUseHorizontalSpacing * 3) + AJM.itemSize )
		frame:SetHeight( AJM.db.itemUseTitleHeight + (AJM.itemSize * AJM.db.numberOfItems) + (AJM.db.itemUseVerticalSpacing * 4) )
	else
		frame:SetWidth( 6 + (AJM.db.itemUseHorizontalSpacing * (3 + AJM.db.numberOfItems-1)) + (AJM.itemSize * AJM.db.numberOfItems) )
		frame:SetHeight( AJM.db.itemUseTitleHeight + AJM.itemSize + (AJM.db.itemUseVerticalSpacing * 4) )
	end
	frame:SetScale( AJM.db.itemUseScale )
end

function AJM:ShowItemUseCommand()
	AJM.db.showItemUse = true
	AJM:SetItemUseVisibility()
	AJM:SettingsRefresh()
end

function AJM:HideItemUseCommand()
	AJM.db.showItemUse = false
	AJM:SetItemUseVisibility()
	AJM:SettingsRefresh()
end

function AJM:SetItemUseVisibility()
	if CanDisplayItemUse() == true then
		JambaItemUseFrame:ClearAllPoints()
		JambaItemUseFrame:SetPoint( AJM.db.framePoint, UIParent, AJM.db.frameRelativePoint, AJM.db.frameXOffset, AJM.db.frameYOffset )
		JambaItemUseFrame:SetAlpha(AJM.db.frameAlpha)
		JambaItemUseFrame:Show()
	else
		JambaItemUseFrame:Hide()
	end	
end

function AJM:SettingsUpdateBorderStyle()
	local borderStyle = AJM.SharedMedia:Fetch( "border", AJM.db.borderStyle )
	local backgroundStyle = AJM.SharedMedia:Fetch( "background", AJM.db.backgroundStyle )
	local frame = JambaItemUseFrame
	frame:SetBackdrop( {
		bgFile = backgroundStyle, 
		edgeFile = borderStyle, 
		tile = true, tileSize = frame:GetWidth(), edgeSize = 10, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	} )
	frame:SetBackdropColor( AJM.db.frameBackgroundColourR, AJM.db.frameBackgroundColourG, AJM.db.frameBackgroundColourB, AJM.db.frameBackgroundColourA )
	frame:SetBackdropBorderColor( AJM.db.frameBorderColourR, AJM.db.frameBorderColourG, AJM.db.frameBorderColourB, AJM.db.frameBorderColourA )		
end

function AJM.ItemOnPreClick( itemContainerFrame )
	local itemId = AJM.db.items[itemContainerFrame.itemNumber]
	if itemId ~= nil then
		local itemCount = GetItemCount( itemId, false, true )
		if itemCount == 0 then
			local name, link, quality, itemLevel, requiredLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo( itemId )
			AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["I do not have X."]( name ) )
		end
	end
end

function AJM.ItemOnPostClick( itemContainerFrame )
	if InCombatLockdown() == 1 then
		AJM.refreshUpdateItemsInBarPending = true
		return
	end
	AJM:ScheduleTimer( "UpdateItemsInBar", 1 )
end

function AJM.ItemOnReceiveDrag( itemContainerFrame )
	local infoType, itemId, itemLink = GetCursorInfo()
	if infoType == "item" then
		AJM.db.items[itemContainerFrame.itemNumber] = itemId
		AJM:JambaSendSettings()
		AJM:SettingsRefresh()
	end
	return ClearCursor()
end

function AJM.ItemOnDragStart( itemContainerFrame )
	local itemId = AJM.db.items[itemContainerFrame.itemNumber]
	if itemId ~= nil then
		PickupItem( itemId )
		local containerButtonName = AJM.globalFramePrefix.."ContainerButton"..itemContainerFrame.itemNumber
		local containerButtonIcon = _G[containerButtonName.."Icon"]
		local containerButtonText = _G[containerButtonName.."Name"]
		containerButtonIcon:SetTexture( "" )
		containerButtonText:SetText( "" )
	end
end

function AJM.ItemOnDragStop( itemContainerFrame )
	AJM.db.items[itemContainerFrame.itemNumber] = nil
	AJM:JambaSendSettings()
	AJM:SettingsRefresh()
end

function AJM:UpdateItemsInBar()
	for iterateItems = 1, AJM.maximumNumberOfItems, 1 do
		local itemContainer = AJM.itemContainer[iterateItems]
		if itemContainer == nil then
			AJM:CreateJambaItemUseItemContainer( iterateItems, parentFrame )
			itemContainer = AJM.itemContainer[iterateItems]
		end
		local containerButton = itemContainer["container"]
		local containerButtonName = AJM.globalFramePrefix.."ContainerButton"..iterateItems
		local containerButtonIcon = _G[containerButtonName.."Icon"]
		local containerButtonText = _G[containerButtonName.."Name"]
		local itemId = AJM.db.items[iterateItems]
		if itemId ~= nil then
			local name, link, quality, itemLevel, requiredLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo( itemId )
			local itemCount = GetItemCount( itemId, false, true )
			containerButton:SetAttribute( "item", name )
			containerButtonIcon:SetTexture( texture )
			if itemCount == 0 then
				containerButtonIcon:SetDesaturated( true )
			else
				containerButtonIcon:SetDesaturated( false )
			end
			containerButtonIcon:Show()
			containerButtonText:SetText( itemCount )
		else
			containerButton:SetAttribute( "item", "" )
			containerButtonIcon:Hide()
			containerButtonText:SetText( "" )
		end
	end
end

function AJM:CreateJambaItemUseItemContainer( itemNumber, parentFrame )
	AJM.itemContainer[itemNumber] = {}
	local itemContainer = AJM.itemContainer[itemNumber]
	local containerButtonName = AJM.globalFramePrefix.."ContainerButton"..itemNumber
	local containerButton = CreateFrame( "Button", containerButtonName, parentFrame, "ActionButtonTemplate,SecureActionButtonTemplate" )
	containerButton.itemNumber = itemNumber
	containerButton:SetAttribute( "type", "item" )
	containerButton:RegisterForDrag( "LeftButton", "RightButton" )
	containerButton:SetScript( "OnReceiveDrag", AJM.ItemOnReceiveDrag )
	containerButton:SetScript( "OnDragStart", AJM.ItemOnDragStart )
	containerButton:SetScript( "OnDragStop", AJM.ItemOnDragStop )
	containerButton:SetScript( "PreClick", AJM.ItemOnPreClick )
	containerButton:SetScript( "PostClick", AJM.ItemOnPostClick )
	itemContainer["container"] = containerButton	
end

function AJM:RefreshItemUseControls()
	if InCombatLockdown() == 1 then
		AJM.refreshItemUseControlsPending = true
		return
	end
	local parentFrame = JambaItemUseFrame
	local positionLeft
	local positionTop
	for iterateItems = 1, AJM.maximumNumberOfItems, 1 do
		local itemContainer = AJM.itemContainer[iterateItems]
		if itemContainer ~= nil then
			local containerButton = itemContainer["container"]
			containerButton:Hide()
		end
	end
	for iterateItems = 1, AJM.db.numberOfItems, 1 do
		local itemContainer = AJM.itemContainer[iterateItems]
		if itemContainer == nil then
			AJM:CreateJambaItemUseItemContainer( iterateItems, parentFrame )
			itemContainer = AJM.itemContainer[iterateItems]
		end
		local containerButton = itemContainer["container"]
		if AJM.db.itemsAreStackedVertically == true then
			positionLeft = 6
			positionTop = -AJM.db.itemUseTitleHeight - (AJM.db.itemUseVerticalSpacing * 2) - ((iterateItems-1) * AJM.itemSize)
		else
			positionLeft = 6 + (AJM.itemSize * (iterateItems-1)) + (AJM.db.itemUseHorizontalSpacing * (iterateItems-1))
			positionTop = -AJM.db.itemUseTitleHeight - (AJM.db.itemUseVerticalSpacing * 2)
		end
		containerButton:SetWidth( AJM.itemSize )
		containerButton:SetHeight( AJM.itemSize )
		containerButton:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		containerButton:Show()
	end	
	UpdateJambaItemUseDimensions()
end

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateOptions( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local mediaHeight = JambaHelperSettings:GetMediaHeight()
	local sliderHeight = JambaHelperSettings:GetSliderHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( true )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local column2left = left + halfWidth
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Item Use Options"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.displayOptionsCheckBoxShowItemUse = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Show Item Bar"],
		AJM.SettingsToggleShowItemUse
	)
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxShowItemUseOnlyOnMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Only On Master"],
		AJM.SettingsToggleShowItemUseOnlyOnMaster
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxHideItemUseInCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Hide Item Bar In Combat"],
		AJM.SettingsToggleHideItemUseInCombat
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing	
	AJM.settingsControl.displayOptionsItemUseNumberOfItems = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Number Of Items"]
	)
	AJM.settingsControl.displayOptionsItemUseNumberOfItems:SetSliderValues( 1, AJM.maximumNumberOfItems, 1 )
	AJM.settingsControl.displayOptionsItemUseNumberOfItems:SetCallback( "OnValueChanged", AJM.SettingsChangeNumberOfItems )
	movingTop = movingTop - sliderHeight - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Appearance & Layout"], movingTop, true )
	movingTop = movingTop - headingHeight	
	AJM.settingsControl.displayOptionsCheckBoxStackVertically = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Stack Items Vertically"],
		AJM.SettingsToggleStackVertically
	)
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsItemUseScaleSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Scale"]
	)
	AJM.settingsControl.displayOptionsItemUseScaleSlider:SetSliderValues( 0.5, 2, 0.01 )
	AJM.settingsControl.displayOptionsItemUseScaleSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeScale )
	movingTop = movingTop - sliderHeight - verticalSpacing
	AJM.settingsControl.displayOptionsItemUseTransparencySlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Transparency"]
	)
	AJM.settingsControl.displayOptionsItemUseTransparencySlider:SetSliderValues( 0, 1, 0.01 )
	AJM.settingsControl.displayOptionsItemUseTransparencySlider:SetCallback( "OnValueChanged", AJM.SettingsChangeTransparency )
	movingTop = movingTop - sliderHeight - verticalSpacing
	--[[
	AJM.settingsControl.displayOptionsItemUseItemSize = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Item Size"]
	)
	AJM.settingsControl.displayOptionsItemUseItemSize:SetSliderValues( 5, 50, 1 )
	AJM.settingsControl.displayOptionsItemUseItemSize:SetCallback( "OnValueChanged", AJM.SettingsChangeItemSize )
	movingTop = movingTop - sliderHeight - verticalSpacing	
	]]--
	AJM.settingsControl.displayOptionsItemUseMediaBorder = JambaHelperSettings:CreateMediaBorder( 
		AJM.settingsControl, 
		halfWidth, 
		left, 
		movingTop,
		L["Border Style"]
	)
	AJM.settingsControl.displayOptionsItemUseMediaBorder:SetCallback( "OnValueChanged", AJM.SettingsChangeBorderStyle )
	AJM.settingsControl.displayOptionsBorderColourPicker = JambaHelperSettings:CreateColourPicker(
		AJM.settingsControl,
		halfWidth,
		column2left + 15,
		movingTop - 15,
		L["Border Colour"]
	)
	AJM.settingsControl.displayOptionsBorderColourPicker:SetHasAlpha( true )
	AJM.settingsControl.displayOptionsBorderColourPicker:SetCallback( "OnValueConfirmed", AJM.SettingsBorderColourPickerChanged )
	movingTop = movingTop - mediaHeight - verticalSpacing
	AJM.settingsControl.displayOptionsItemUseMediaBackground = JambaHelperSettings:CreateMediaBackground( 
		AJM.settingsControl, 
		halfWidth, 
		left, 
		movingTop,
		L["Background"]
	)
	AJM.settingsControl.displayOptionsItemUseMediaBackground:SetCallback( "OnValueChanged", AJM.SettingsChangeBackgroundStyle )
	AJM.settingsControl.displayOptionsBackgroundColourPicker = JambaHelperSettings:CreateColourPicker(
		AJM.settingsControl,
		halfWidth,
		column2left + 15,
		movingTop - 15,
		L["Background Colour"]
	)
	AJM.settingsControl.displayOptionsBackgroundColourPicker:SetHasAlpha( true )
	AJM.settingsControl.displayOptionsBackgroundColourPicker:SetCallback( "OnValueConfirmed", AJM.SettingsBackgroundColourPickerChanged )	
	movingTop = movingTop - mediaHeight - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Messages"], movingTop, true )
	movingTop = movingTop - headingHeight	
	AJM.settingsControl.dropdownMessageArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Message Area"] 
	)
	AJM.settingsControl.dropdownMessageArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownMessageArea:SetCallback( "OnValueChanged", AJM.SettingsSetMessageArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing				
	return movingTop	
end

local function SettingsCreate()
	AJM.settingsControl = {}
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControl, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	local bottomOfOptions = SettingsCreateOptions( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfOptions )	
end

-------------------------------------------------------------------------------------------------------------
-- Settings Populate.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	-- Values.
	AJM.settingsControl.displayOptionsCheckBoxShowItemUse:SetValue( AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsCheckBoxShowItemUseOnlyOnMaster:SetValue( AJM.db.showItemUseOnMasterOnly )
	AJM.settingsControl.displayOptionsCheckBoxHideItemUseInCombat:SetValue( AJM.db.hideItemUseInCombat )
	AJM.settingsControl.displayOptionsItemUseNumberOfItems:SetValue( AJM.db.numberOfItems )
	AJM.settingsControl.displayOptionsCheckBoxStackVertically:SetValue( AJM.db.itemsAreStackedVertically )
	AJM.settingsControl.displayOptionsItemUseScaleSlider:SetValue( AJM.db.itemUseScale )
	AJM.settingsControl.displayOptionsItemUseTransparencySlider:SetValue( AJM.db.frameAlpha )
	AJM.settingsControl.displayOptionsItemUseMediaBorder:SetValue( AJM.db.borderStyle )
	AJM.settingsControl.displayOptionsItemUseMediaBackground:SetValue( AJM.db.backgroundStyle )
	AJM.settingsControl.dropdownMessageArea:SetValue( AJM.db.messageArea )
	AJM.settingsControl.displayOptionsBackgroundColourPicker:SetColor( AJM.db.frameBackgroundColourR, AJM.db.frameBackgroundColourG, AJM.db.frameBackgroundColourB, AJM.db.frameBackgroundColourA )
	AJM.settingsControl.displayOptionsBorderColourPicker:SetColor( AJM.db.frameBorderColourR, AJM.db.frameBorderColourG, AJM.db.frameBorderColourB, AJM.db.frameBorderColourA )
	-- State.
	AJM.settingsControl.displayOptionsCheckBoxShowItemUseOnlyOnMaster:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsCheckBoxHideItemUseInCombat:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsItemUseNumberOfItems:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsCheckBoxStackVertically:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsItemUseScaleSlider:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsItemUseTransparencySlider:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsItemUseMediaBorder:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsItemUseMediaBackground:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.dropdownMessageArea:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsBackgroundColourPicker:SetDisabled( not AJM.db.showItemUse )
	AJM.settingsControl.displayOptionsBorderColourPicker:SetDisabled( not AJM.db.showItemUse )		
	if AJM.itemUseCreated == true then
		AJM:RefreshItemUseControls()
		AJM:SettingsUpdateBorderStyle()
		AJM:SetItemUseVisibility()
		AJM:UpdateItemsInBar()
	end
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsToggleShowItemUse( event, checked )
	AJM.db.showItemUse = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHideItemUseInCombat( event, checked )
	AJM.db.hideItemUseInCombat = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowItemUseOnlyOnMaster( event, checked )
	AJM.db.showItemUseOnMasterOnly = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleStackVertically( event, checked )
	AJM.db.itemsAreStackedVertically = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeNumberOfItems( event, value )
	AJM.db.numberOfItems = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeScale( event, value )
	AJM.db.itemUseScale = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeTransparency( event, value )
	AJM.db.frameAlpha = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeBorderStyle( event, value )
	AJM.db.borderStyle = value
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeBackgroundStyle( event, value )
	AJM.db.backgroundStyle = value
	AJM:SettingsRefresh()
end

function AJM:SettingsSetMessageArea( event, value )
	AJM.db.messageArea = value
	AJM:SettingsRefresh()
end

function AJM:OnMasterChanged( message, characterName )
	AJM:SettingsRefresh()
end

function AJM:SettingsBackgroundColourPickerChanged( event, r, g, b, a )
	AJM.db.frameBackgroundColourR = r
	AJM.db.frameBackgroundColourG = g
	AJM.db.frameBackgroundColourB = b
	AJM.db.frameBackgroundColourA = a
	AJM:SettingsRefresh()
end

function AJM:SettingsBorderColourPickerChanged( event, r, g, b, a )
	AJM.db.frameBorderColourR = r
	AJM.db.frameBorderColourG = g
	AJM.db.frameBorderColourB = b
	AJM.db.frameBorderColourA = a
	AJM:SettingsRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
	-- Create the item use frame.
	CreateJambaItemUseFrame()
	AJM:RefreshItemUseControls()
	AJM:SettingsUpdateBorderStyle()
	AJM:SetItemUseVisibility()
	AJM:UpdateItemsInBar()
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM:RegisterEvent( "PLAYER_REGEN_ENABLED" )
	AJM:RegisterEvent( "PLAYER_REGEN_DISABLED" )
	AJM:RegisterEvent( "BAG_UPDATE" )
	AJM.SharedMedia.RegisterCallback( AJM, "LibSharedMedia_Registered" )
    AJM.SharedMedia.RegisterCallback( AJM, "LibSharedMedia_SetGlobal" )	
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_MASTER_CHANGED, "OnMasterChanged" )
	AJM:RefreshItemUseControls()
	AJM:UpdateItemsInBar()
	AJM.keyBindingFrame = CreateFrame( "Frame", nil, UIParent )
	AJM:RegisterEvent( "UPDATE_BINDINGS" )		
	AJM:UPDATE_BINDINGS()	
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.showItemUse = settings.showItemUse
		AJM.db.showItemUseOnMasterOnly = settings.showItemUseOnMasterOnly
		AJM.db.hideItemUseInCombat = settings.hideItemUseInCombat
		AJM.db.borderStyle = settings.borderStyle
		AJM.db.backgroundStyle = settings.backgroundStyle
		AJM.db.itemUseScale = settings.itemUseScale
		AJM.db.itemUseTitleHeight = settings.itemUseTitleHeight
		AJM.db.itemUseVerticalSpacing = settings.itemUseVerticalSpacing
		AJM.db.itemUseHorizontalSpacing = settings.itemUseHorizontalSpacing
		AJM.db.itemsAreStackedVertically = settings.itemsAreStackedVertically
		AJM.db.numberOfItems = settings.numberOfItems
		AJM.db.messageArea = settings.messageArea
		AJM.db.items = JambaUtilities:CopyTable( settings.items )
		AJM.db.frameAlpha = settings.frameAlpha
		AJM.db.framePoint = settings.framePoint
		AJM.db.frameRelativePoint = settings.frameRelativePoint
		AJM.db.frameXOffset = settings.frameXOffset
		AJM.db.frameYOffset = settings.frameYOffset
		AJM.db.frameBackgroundColourR = settings.frameBackgroundColourR
		AJM.db.frameBackgroundColourG = settings.frameBackgroundColourG
		AJM.db.frameBackgroundColourB = settings.frameBackgroundColourB
		AJM.db.frameBackgroundColourA = settings.frameBackgroundColourA
		AJM.db.frameBorderColourR = settings.frameBorderColourR
		AJM.db.frameBorderColourG = settings.frameBorderColourG
		AJM.db.frameBorderColourB = settings.frameBorderColourB
		AJM.db.frameBorderColourA = settings.frameBorderColourA				
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

function AJM:PLAYER_REGEN_ENABLED()
	if AJM.db.hideItemUseInCombat == true then
		AJM:SetItemUseVisibility()
	end
	if AJM.refreshItemUseControlsPending == true then
		AJM:RefreshItemUseControls()
		AJM.refreshItemUseControlsPending = false
	end
	if AJM.refreshUpdateItemsInBarPending == true then
		AJM:UpdateItemsInBar()
		AJM.refreshUpdateItemsInBarPending = false
	end
	if AJM.refreshUpdateBindingsPending == true then
		AJM:UPDATE_BINDINGS()
		AJM.refreshUpdateBindingsPending = false
	end
end

function AJM:PLAYER_REGEN_DISABLED()
	if AJM.db.hideItemUseInCombat == true then
		JambaItemUseFrame:Hide()
	end
end

function AJM:BAG_UPDATE()
	if InCombatLockdown() == nil then
		AJM:UpdateItemsInBar()
	end
end

function AJM:UPDATE_BINDINGS()
	if InCombatLockdown() == 1 then
		AJM.refreshUpdateBindingsPending = true
		return
	end
	ClearOverrideBindings( AJM.keyBindingFrame )
	for iterateItems = 1, AJM.maximumNumberOfItems, 1 do
		local containerButtonName = AJM.globalFramePrefix.."ContainerButton"..iterateItems
		local key1, key2 = GetBindingKey( "JAMBAITEMUSE"..iterateItems )		
		if key1 then 
			SetOverrideBindingClick( AJM.keyBindingFrame, false, key1, containerButtonName ) 
		end
		if key2 then 
			SetOverrideBindingClick( AJM.keyBindingFrame, false, key2, containerButtonName ) 
		end	
	end
end

function AJM:LibSharedMedia_Registered()
end

function AJM:LibSharedMedia_SetGlobal()
end

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
end
