if not Skinner:isAddonEnabled("Gatherer") then return end

function Skinner:Gatherer()

-->>-- Report Frame
	local frame = GathererReportFrame
	self:skinEditBox(frame.SearchBox, {9})
	self:applySkin(frame.Results)
	self:keepFontStrings(frame.Results.Scroll)
	self:skinScrollBar(frame.Results.Scroll)
	self:skinEditBox(frame.Actions.SendEdit, {9})
	self:applySkin(frame)

	-- SharingBlacklist ScrollFrame
	self:keepFontStrings(Gatherer_SharingBlacklist_ScrollFrame)
	self:skinScrollBar(Gatherer_SharingBlacklist_ScrollFrame)
	
end
