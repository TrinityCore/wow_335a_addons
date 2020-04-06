if not Skinner:isAddonEnabled("LazyAFK") then return end

function Skinner:LazyAFK()

	-- hook this function to skin the frame
	self:SecureHook("frame_OnUpdate", function(this, ...)
       	self:addSkinFrame{obj=this, x1=8, y1=-11, x2=-11, y2=4}
		self:Unhook("frame_OnUpdate")
	end)

end
