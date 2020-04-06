if not Skinner:isAddonEnabled("EggTimer") then return end

function Skinner:EggTimer()

	self:addSkinFrame{obj=EggTimerCalendarPrompt, kfs=true, hdr=true, y1=5}

end
