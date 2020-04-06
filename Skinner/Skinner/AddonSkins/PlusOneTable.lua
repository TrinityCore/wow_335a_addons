if not Skinner:isAddonEnabled("PlusOneTable") then return end

function Skinner:PlusOneTable()

-->>-- Frame1
	self:addSkinFrame{obj=Frame1, kfs=true}
-->>-- Toggle Window (LOOT ROLL TYPE)
	self:addSkinFrame{obj=ToggleWindow, kfs=true}
-->>-- Options Window (SAVE)
	self:addSkinFrame{obj=OptionsWindow, kfs=true}
-->>-- Loading Window (LOAD)
	self:addSkinFrame{obj=LoadingWindow, kfs=true}

end
