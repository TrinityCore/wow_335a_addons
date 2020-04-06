if not Skinner:isAddonEnabled("Accomplishment") then return end

function Skinner:Accomplishment()

	self:addSkinFrame{obj=AccomplishmentFrame, kfs=true}
	self:moveObject{obj=self:getRegion(AccomplishmentFrame, 2), y=-4} -- Title

end
