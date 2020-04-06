if not Skinner:isAddonEnabled("MoveAnything") then return end
-- thanks to sixthepaladin

function Skinner:MoveAnything()

	self:skinButton{obj=GameMenuButtonMoveAnything}
-->>-- Options frame
	self:skinScrollBar{obj=MAScrollFrame}
	MAScrollBorder:SetAlpha(0)
	self:addSkinFrame{obj=MAOptions, kfs=true, hdr=true}
	-- category buttons
	for i = 1, 17 do
		self:skinButton{obj=_G["MAMove"..i.."Reset"]}
	end
-->>-- Nudger frame
	self:skinAllButtons{obj=MANudger, x1=-1, x2=1}
	self:addSkinFrame{obj=MANudger, nb=true}

end
