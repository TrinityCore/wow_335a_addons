if not Skinner:isAddonEnabled("LilSparkysWorkshop") then return end

function Skinner:LilSparkysWorkshop()

	local lswEvt
	
	local function skinpb()
	
		-- search through LSW.parentFrame backwards looking for the progressBar
		for i = LSW.parentFrame:GetNumChildren(), 1, -1 do
			local child = select(i, LSW.parentFrame:GetChildren())
			if child:GetWidth() == 310 and child:GetHeight() == 30 then
				Skinner:CancelTimer(lswEvt, true)
				Skinner:applySkin(child)
				lswEvt = nil
				break
			end
		end
		
	end
	
	-- start a timer to skin the progressBar
	lswEvt = Skinner:ScheduleRepeatingTimer(skinpb, 0.1)
	
end
