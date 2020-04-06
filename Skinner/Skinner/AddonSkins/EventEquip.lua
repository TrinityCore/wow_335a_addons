if not Skinner:isAddonEnabled("EventEquip") then return end

function Skinner:EventEquip()
	if not self.db.profile.GearManager then return end

	-- find the button on the GearManagerDialog
	-- hook the OnMouseDown script
	for i = GearManagerDialog:GetNumChildren(), 1, -1 do
		local child = select(i, GearManagerDialog:GetChildren())
		if ceil(child:GetWidth()) == 22 and ceil(child:GetHeight()) == 22 then
			self:SecureHookScript(child, "OnMouseDown", function(this)
				self:addSkinFrame{obj=EEOptions, kfs=true, x1=1, y1=1, x2=-3, y2=-4}
				self:Unhook(child, "OnMouseDown")
			end)
			break
		end
	end

end
