--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaPurchase", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0"
)

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
local AceGUI = LibStub:GetLibrary( "AceGUI-3.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Purchase"
AJM.settingsDatabaseName = "JambaPurchaseProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-purchase"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Purchase"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		autoBuy = false,
		autoBuyOverflow = true,
		messageArea = JambaApi.DefaultMessageArea(),
		autoBuyItems = {}
	},
}

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = 'group',
		childGroups  = "tab",
		get = "JambaConfigurationGetSetting",
		set = "JambaConfigurationSetSetting",
		args = {
			--[[
			popout = {
				type = "input",
				name = L["PopOut"],
				desc = L["Show the purchase settings in their own window."],
				usage = "/jamba-purchase popout",
				get = false,
				set = "ShowPopOutWindow",
			},
			]]--
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the purchase settings to all characters in the team."],
				usage = "/jamba-purchase push",
				get = false,
				set = "JambaSendSettings",
			},
		},
	}
	return configuration
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Purchase Management.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	AJM.settingsControl.checkBoxAutoBuy:SetValue( AJM.db.autoBuy )
	AJM.settingsControl.checkBoxAutoBuyOverflow:SetValue( AJM.db.autoBuyOverflow )
	AJM.settingsControl.editBoxTag:SetText( AJM.autoBuyItemTag )
	AJM.settingsControl.editBoxAmount:SetText( AJM.autoBuyAmount )
	AJM.settingsControl.dropdownMessageArea:SetValue( AJM.db.messageArea )	
	AJM.settingsControl.checkBoxAutoBuyOverflow:SetDisabled( not AJM.db.autoBuy )
	AJM.settingsControl.editBoxItem:SetDisabled( not AJM.db.autoBuy )
	AJM.settingsControl.editBoxTag:SetDisabled( not AJM.db.autoBuy )
	AJM.settingsControl.editBoxAmount:SetDisabled( not AJM.db.autoBuy )
	AJM.settingsControl.buttonRemove:SetDisabled( not AJM.db.autoBuy )
	AJM.settingsControl.buttonAdd:SetDisabled( not AJM.db.autoBuy )
	AJM:SettingsScrollRefresh()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.autoBuy = settings.autoBuy
		AJM.db.autoBuyOverflow = settings.autoBuyOverflow
		AJM.db.messageArea = settings.messageArea
		AJM.db.autoBuyItems = JambaUtilities:CopyTable( settings.autoBuyItems )
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateOptions( top )
	-- Position and size constants.
	local buttonControlWidth = 105
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local left2 = left + halfWidth + horizontalSpacing
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Purchase Items"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxAutoBuy = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		halfWidth, 
		left, 
		movingTop, 
		L["Auto Buy Items"],
		AJM.SettingsToggleAutoBuyItems
	)	
	AJM.settingsControl.checkBoxAutoBuyOverflow = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		halfWidth, 
		left2, 
		movingTop, 
		L["Overflow"],
		AJM.SettingsToggleAutoBuyItemsOverflow
	)	
	movingTop = movingTop - checkBoxHeight	
	AJM.settingsControl.highlightRow = 1
	AJM.settingsControl.offset = 1
	local list = {}
	list.listFrameName = "JambaPurchaseSettingsFrame"
	list.parentFrame = AJM.settingsControl.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = headingWidth
	list.rowHeight = 20
	list.rowsToDisplay = 8
	list.columnsToDisplay = 3
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 60
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 10
	list.columnInformation[2].alignment = "RIGHT"	
	list.columnInformation[3] = {}
	list.columnInformation[3].width = 30
	list.columnInformation[3].alignment = "LEFT"		
	list.scrollRefreshCallback = AJM.SettingsScrollRefresh
	list.rowClickCallback = AJM.SettingsRowClick
	AJM.settingsControl.list = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControl.list )
	movingTop = movingTop - list.listHeight - verticalSpacing
	AJM.settingsControl.buttonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControl, 
		buttonControlWidth, 
		left, 
		movingTop,
		L["Remove"],
		AJM.SettingsRemoveClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Add Item"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.editBoxItem = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControl,
		headingWidth,
		left,
		movingTop,
		L["Item (drag item to box from your bags)"]
	)
	AJM.settingsControl.editBoxItem:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedItem )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControl.editBoxTag = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControl,
		halfWidth,
		left,
		movingTop,
		L["Tag"]
	)
	AJM.settingsControl.editBoxTag:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedTag )
	AJM.settingsControl.editBoxAmount = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControl,
		halfWidth,
		left2,
		movingTop,
		L["Amount"]
	)
	AJM.settingsControl.editBoxAmount:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedAmount )
	movingTop = movingTop - editBoxHeight		
	AJM.settingsControl.buttonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControl, 
		buttonControlWidth, 
		left, 
		movingTop, 
		L["Add"],
		AJM.SettingsAddClick
	)
	movingTop = movingTop -	buttonHeight	
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Purchase Messages"], movingTop, false )
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
	local bottomOfSettings = SettingsCreateOptions( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfSettings )
end

-------------------------------------------------------------------------------------------------------------
-- Settings Callbacks.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControl.list.listScrollFrame, 
		AJM:GetItemsMaxPosition(),
		AJM.settingsControl.list.rowsToDisplay, 
		AJM.settingsControl.list.rowHeight
	)
	AJM.settingsControl.offset = FauxScrollFrame_GetOffset( AJM.settingsControl.list.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControl.list.rowsToDisplay do
		-- Reset.
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )		
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[3].textString:SetText( "" )
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[3].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )			
		AJM.settingsControl.list.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControl.offset
		if dataRowNumber <= AJM:GetItemsMaxPosition() then
			-- Put data information into columns.
			local itemInformation = AJM:GetItemAtPosition( dataRowNumber )
			AJM.settingsControl.list.rows[iterateDisplayRows].columns[1].textString:SetText( itemInformation.name )
			AJM.settingsControl.list.rows[iterateDisplayRows].columns[2].textString:SetText( itemInformation.amount )
			AJM.settingsControl.list.rows[iterateDisplayRows].columns[3].textString:SetText( itemInformation.tag )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControl.highlightRow then
				AJM.settingsControl.list.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
end

function AJM:SettingsRowClick( rowNumber, columnNumber )		
	if AJM.settingsControl.offset + rowNumber <= AJM:GetItemsMaxPosition() then
		AJM.settingsControl.highlightRow = AJM.settingsControl.offset + rowNumber
		AJM:SettingsScrollRefresh()
	end
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsSetMessageArea( event, value )
	AJM.db.messageArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoBuyItems( event, checked )
	AJM.db.autoBuy = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoBuyItemsOverflow( event, checked )
	AJM.db.autoBuyOverflow = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsRemoveClick( event )
	StaticPopup_Show( "JAMBAPURCHASE_CONFIRM_REMOVE_AUTO_BUY_ITEM" )
end

function AJM:SettingsEditBoxChangedItem( event, text )
	AJM.autoBuyItemLink = text
	AJM:SettingsRefresh()
end

function AJM:SettingsEditBoxChangedTag( event, text )
	if not text or text:trim() == "" or text:find( "%W" ) ~= nil then
		AJM:Print( L["Item tags must only be made up of letters and numbers."] )
		return
	end
	AJM.autoBuyItemTag = text
	AJM:SettingsRefresh()
end

function AJM:SettingsEditBoxChangedAmount( event, text )
	if not text or text:trim() == "" or text:find( "^(%d+)$" ) == nil then
		AJM:Print( L["Amount to buy must be a number."] )
		return
	end
	AJM.autoBuyAmount = text
	AJM:SettingsRefresh()
end

function AJM:SettingsAddClick( event )
	if AJM.autoBuyItemLink ~= nil and AJM.autoBuyItemTag ~= nil then
		AJM:AddItem( AJM.autoBuyItemLink, AJM.autoBuyItemTag, AJM.autoBuyAmount )
		AJM.autoBuyItemLink = nil
		AJM.settingsControl.editBoxItem:SetText( "" )
		AJM:SettingsRefresh()
	end
end

-------------------------------------------------------------------------------------------------------------
-- Popup Dialogs.
-------------------------------------------------------------------------------------------------------------

-- Initialize Popup Dialogs.
local function InitializePopupDialogs()
	StaticPopupDialogs["JAMBAPURCHASE_CONFIRM_REMOVE_AUTO_BUY_ITEM"] = {
        text = L["Are you sure you wish to remove the selected item from the auto buy items list?"],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveItem()
		end,
    }
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	AJM.autoBuyItemTag = JambaApi.AllTag()
	AJM.autoBuyItemLink = nil
	AJM.autoBuyAmount = 20
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Initialise the popup dialogs.
	InitializePopupDialogs()		
	-- Populate the settings.
	AJM:SettingsRefresh()
	-- Create a standalone window for the purchase.
	--[[
	AJM.standaloneWindow = AceGUI:Create( "Window" )
	AJM.standaloneWindow:Hide()
	AJM.standaloneWindow:SetTitle( "Jamba-Purchase" )
	AJM.standaloneWindow:SetLayout( "Fill" )
	AJM.standaloneWindow:AddChild( AJM.settingsControl.widgetSettings )
	AJM.standaloneWindow:SetHeight( 410 )
	AJM.standaloneWindow:SetWidth( 410 )
	AJM.standaloneWindow.frame:SetFrameStrata( "HIGH" )
	]]--
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM:RegisterEvent( "MERCHANT_SHOW" )
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-------------------------------------------------------------------------------------------------------------
-- JambaPurchase functionality.
-------------------------------------------------------------------------------------------------------------

function AJM:ShowPopOutWindow()
	--AJM.standaloneWindow:Show()
end

function AJM:GetItemsMaxPosition()
	return #AJM.db.autoBuyItems
end

function AJM:GetItemAtPosition( position )
	return AJM.db.autoBuyItems[position]
end

function AJM:AddItem( itemLink, itemTag, amountToBuy )
	-- Get some more information about the item.
	local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo( itemLink )
	-- If the item could be found.
	if name ~= nil then
		local itemInformation = {}
		itemInformation.link = itemLink
		itemInformation.name = name
		itemInformation.tag = itemTag
		itemInformation.amount = amountToBuy
		table.insert( AJM.db.autoBuyItems, itemInformation )
		AJM:SettingsRefresh()			
		AJM:SettingsRowClick( 1, 1 )
	end	
end

function AJM:RemoveItem()
	table.remove( AJM.db.autoBuyItems, AJM.settingsControl.highlightRow )
	AJM:SettingsRefresh()
	AJM:SettingsRowClick( 1, 1 )		
end

function AJM:MERCHANT_SHOW()
	if AJM.db.autoBuy == true then
		AJM:DoMerchantAutoBuy()
	end
end

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
end

function AJM:DoMerchantAutoBuy()
	-- Flags will be set if the character does not have enough bag space or money.
	local outOfBagSpace = false
	local outOfMoney = false
	local outOfOtherCurrency = false
	-- Iterate all the wanted items...
	for position, itemInfoTable in pairs( AJM.db.autoBuyItems ) do	
		local maxItemAmount = tonumber( itemInfoTable.amount )
		local itemTag = itemInfoTable.tag
		local itemLink = itemInfoTable.link
		-- Does this character have the item tag?  No, don't buy.
		if JambaApi.DoesCharacterHaveTag( AJM.characterName, itemTag ) then
			-- Does the merchant have the item in stock?
			itemIndexMerchant = AJM:DoesMerchantHaveItemInStock( itemLink )
			if itemIndexMerchant ~= nil then
				-- Yes, item is in stock, how many does the character need?
				local amountNeeded = AJM:GetAmountNeededForItemTopUp( itemLink, maxItemAmount )
				-- Need more than 0 items, buy them.
				if amountNeeded > 0 then
					-- Attempt to buy the items.
					local noFreeBagSpace, notEnoughMoney, notEnoughOtherCurrency = AJM:BuyItemFromMerchant( itemIndexMerchant, amountNeeded )
					-- Set flags if problems occurred.
					if noFreeBagSpace then
						outOfBagSpace = true		
					end
					if notEnoughMoney then
						outOfMoney = true
					end
					if notEnoughOtherCurrency then 
						outOfOtherCurrency = true
					end
				end
			end
		end
	end
	-- If there was a problem, tell the master.
	if outOfBagSpace then
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["I do not have enough space in my bags to complete my purchases."] )			
	end
	if outOfMoney then
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["I do not have enough money to complete my purchases."] )
	end
	if outOfOtherCurrency then
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["I do not have enough other currency to complete my purchases."] )
	end	
end

function AJM:DoesMerchantHaveItemInStock( itemLink )
	-- The index of the item to be found in the merchants inventory; initially nil, not found.
	local indexOfItemToFind = nil 
	-- Get the name of the item to find from the item link.
	local itemNameToFind = GetItemInfo( itemLink )
	-- How many items does the merchant have?
	local numberMerchantItems = GetMerchantNumItems()
	-- Iterate all the merchants items...
	for merchantIndex = 1, numberMerchantItems do
		-- Is there an item link for this item.
		local merchantItemLink = GetMerchantItemLink( merchantIndex )
		if merchantItemLink then
			-- Yes, get the item name.
			local itemNameMerchant = GetItemInfo( merchantItemLink )
			if itemNameMerchant == itemNameToFind then
				indexOfItemToFind = merchantIndex
				break
			end
		end
	end
	-- Return the index into the merchants inventory of the item.
	return indexOfItemToFind
end

function AJM:GetAmountNeededForItemTopUp( itemLink, maxItemAmount )
	-- The amount of the item needed to top up the item.
	local amountNeeded = 0
	-- How much of this item does the character have in it's bags?
	local amountInBags = GetItemCount( itemLink )
	-- Does the character need more?
	if amountInBags < maxItemAmount then
		-- Yes, how much more?
		amountNeeded = maxItemAmount - amountInBags
	end
	-- Return the amount needed.
	return amountNeeded	
end

function AJM:BuyItemFromMerchant( itemIndexMerchant,amountToBuy )
	-- Flags will be set if the character does not have enough bag space or money.
	local noFreeBagSpace = false
	local notEnoughMoney = false
	local notEnoughOtherCurrency = false
	-- Processing variables.
	local buyThisAmount = 0
	local amountLeftToBuy = amountToBuy
	local actualAmountToBuy = 0
	local costToBuy = 0
	local moneyAvailable = 0
	-- Get information about the item from the merchant.
	local name, texture, price, itemsPerStack, numberAvailable, isUsable, extendedCost = GetMerchantItemInfo( itemIndexMerchant )	
	local maximumCanBuyAtATime = GetMerchantItemMaxStack( itemIndexMerchant )
	-- Loop buying stacks from the merchant until the required number has been purchased.
	repeat
		-- Still need to buy more than the maximum?
		if amountLeftToBuy >= (maximumCanBuyAtATime * itemsPerStack) then
			-- Yes, buy the maximum amount.
			buyThisAmount = (maximumCanBuyAtATime * itemsPerStack)
		else
			-- No, just buy the amount left.
			buyThisAmount = amountLeftToBuy
		end
		-- Attempt to buy this amount from the merchant; although actual amount bought may differ,
		-- depending on merchant stock and over buy flag.
		-- How many does the merchant have left?
		numberAvailable = select( 5, GetMerchantItemInfo( itemIndexMerchant ) )
		-- Calculate how many to buy depending on the stacksize and whether over buying is allowed.
		actualAmountToBuy = buyThisAmount / itemsPerStack
		if AJM.db.autoBuyOverflow == true then
			actualAmountToBuy = ceil(actualAmountToBuy)
		else
			actualAmountToBuy = floor(actualAmountToBuy)
		end
		-- If requesting more than the number available, then just buy as much as possible.
		-- If numberAvailable is -1 then there is unlimited stock available.
		if numberAvailable ~= -1 then
			if actualAmountToBuy > numberAvailable then
				actualAmountToBuy = numberAvailable 
			end
		end
		-- Does the character have enough money?
		costToBuy = actualAmountToBuy * price
		moneyAvailable = GetMoney()
		if moneyAvailable < costToBuy then			
			notEnoughMoney = true
		end
		-- Is there enough free space for this item in the characters bags?				
		--TODO - need to find items family type and compare to each container.
		--freeSlots, itemFamily = GetContainerNumFreeSlots(bagIndex)
		-- Buy from the merchant, if there is a valid amount to buy and the character has enough money.
		if (actualAmountToBuy > 0) and (not notEnoughMoney) then
			BuyMerchantItem( itemIndexMerchant, actualAmountToBuy )
		end				
		-- How much left to buy?
		amountLeftToBuy = amountLeftToBuy - buyThisAmount
	until amountLeftToBuy == 0
	-- TODO
	-- Return the success flags.
	return noFreeBagSpace, notEnoughMoney, notEnoughOtherCurrency
end
