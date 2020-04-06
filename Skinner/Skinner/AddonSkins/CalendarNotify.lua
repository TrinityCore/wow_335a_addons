if not Skinner:isAddonEnabled("CalendarNotify") then return end

function Skinner:CalendarNotify()

	self:addSkinFrame{obj=CalendarButton:GetParent()}

end
