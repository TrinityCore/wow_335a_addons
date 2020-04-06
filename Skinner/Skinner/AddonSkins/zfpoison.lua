if not Skinner:isAddonEnabled("zfpoison") then return end

function Skinner:zfpoison()

	-- Main frame
	self:addSkinFrame{obj=zfpoisonframe1, sap=true}
	-- Dialog frame
	self:addSkinFrame{obj=where_zfpoison, sap=true}

end
