local _details = 		_G._details

--code from blizzard AlertFrames

function _details:PlayGlow(frame)
	frame:Show()
	
	frame.glow:Show()
	frame.glow.animIn:Play()
	frame.shine:Show()
	frame.shine.animIn:Play()
	
	PlaySound("LFG_Rewards", "master")
end