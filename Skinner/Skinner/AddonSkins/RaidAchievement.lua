if not Skinner:isAddonEnabled("RaidAchievement") then return end

local x1, y1 = -2, -4
function Skinner:RaidAchievement()

-->>-- Main Frames
	self:skinAllButtons{obj=PSFeamain1}
	self:addSkinFrame{obj=PSFeamain2, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamain3, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamain12, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamain10, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamain11, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamainmanyach, x1=x1, y1=y1}

end

function Skinner:RaidAchievement_Icecrown()

	self:addSkinFrame{obj=icramain6, x1=x1, y1=y1}

	self:SecureHook("openmenureporticra", function()
		self:skinDropDown{obj=DropDownMenureporticra}
		self:Unhook("openmenureporticra")
	end)

end

function Skinner:RaidAchievement_Naxxramas()

	self:addSkinFrame{obj=nxramain6, x1=x1, y1=y1}

	self:SecureHook("openmenureportnxra", function()
		self:skinDropDown{obj=DropDownMenureportnxra}
		self:Unhook("openmenureportnxra")
	end)

end

function Skinner:RaidAchievement_Ulduar()

	self:addSkinFrame{obj=PSFeamain7, x1=x1, y1=y1}

	self:SecureHook("openmenureportra", function()
		self:skinDropDown{obj=DropDownMenureportra}
		self:Unhook("openmenureportra")
	end)

end

function Skinner:RaidAchievement_WotlkHeroics()

	self:addSkinFrame{obj=whramain6, x1=x1, y1=y1}

	self:SecureHook("openmenureportwhra", function()
		self:skinDropDown{obj=DropDownMenureportwhra}
		self:Unhook("openmenureportwhra")
	end)

end
