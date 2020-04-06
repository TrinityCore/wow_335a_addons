if not Skinner:isAddonEnabled("MakeRocketGoNow") then return end

function Skinner:MakeRocketGoNow()

	for _, child in pairs{UIParent:GetChildren()} do
		if not self.skinFrame[child]
		and child:IsObjectType("Button")
		and child:GetName() == nil
		then
			if child.GetBackdropBorderColor then
				local r, g, b ,a = child:GetBackdropBorderColor()
				if r and r > 0 then
					r = format("%.1f", r)
					g = format("%.1f", g)
					b = format("%.1f", b)
					a = format("%.1f", a)
					if r == "1.0" and g == "1.0" and b == "0.5" and a == "0.5" then
						self:addSkinFrame{obj=child}
						child:SetFrameLevel(child:GetFrameLevel() + 5)
						break
					end
				end
			end
		end
	end

end
