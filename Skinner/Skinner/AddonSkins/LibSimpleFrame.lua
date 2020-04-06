-- This is a Library

function Skinner:LibSimpleFrame()

	local lsf = LibStub("LibSimpleFrame-Mod-1.0")

	local function skinFrames()
		for name, frame	in pairs(lsf.registry) do
			if not Skinner.skinFrame[frame] then self:addSkinFrame{obj=frame} end
		end
	end
	
	self:SecureHook(lsf, "New", function(this, ...)
		skinFrames()
	end)
	-- skin existing frames
	skinFrames()
	
end
