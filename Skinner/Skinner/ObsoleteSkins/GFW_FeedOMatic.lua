
function Skinner:GFW_FeedOMatic()

	self:keepRegions(FOM_OptionsFrame, {11,12})
	-- move the Heading text
	self:moveObject(self:getRegion(FOM_OptionsFrame, 11), nil, nil, "-", 6)
	self:applySkin(FOM_OptionsFrame)
	self:applySkin(FOM_Options_General)
	self:keepRegions(FOM_SaveForCookDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:skinEditBox(FOM_KeepOpenSlots)
	self:applySkin(FOM_Options_FoodChoice)
	self:applySkin(FOM_Options_FeedWarning)
	self:applySkin(FOM_Options_FeedNotification)
	self:applySkin(FOM_Options_KeyBindings)

end
