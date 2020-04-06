if not Skinner:isAddonEnabled("Producer") then return end

function Skinner:Producer()

	local function refresh(obj)

		obj.frame:SetBackdrop(Skinner.Backdrop[1])
		local bCr, bCg, bCb, bCa = unpack(Skinner.bColour)
		local bbCr, bbCg, bbCb, bbCa = unpack(Skinner.bbColour)
		obj.frame:SetBackdropColor(bCr, bCg, bCb, bCa)
		obj.frame:SetBackdropBorderColor(bbCr, bbCg, bbCb, bbCa)

	end

	-- skin the frames
	self:applySkin{obj=Producer.CharFrame.frame}
	self:applySkin{obj=Producer.SelectFrame.frame}

	-- hook their refresh function
	self:SecureHook(Producer.CharFrame, "Refresh", function(this)
		refresh(this)
	end)
	self:SecureHook(Producer.SelectFrame, "Refresh", function(this)
		refresh(this)
	end)

end
