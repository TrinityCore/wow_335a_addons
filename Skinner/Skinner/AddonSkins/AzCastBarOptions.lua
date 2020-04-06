if not Skinner:isAddonEnabled("AzCastBarOptions") then return end

function Skinner:AzCastBarOptions()

	self:RawHook(AzOptionsFactory, "GetObject", function(this, type)
		local obj = self.hooks[AzOptionsFactory].GetObject(this, type)
		if type == "Slider" then
			self:skinEditBox{obj=obj.edit, regs={9}, noHeight=true}
		end 
		return obj
	end, true)

	local f = AzCastBarOptions
	-- Options frame
	self:skinScrollBar{obj=f.scroll}
	self:addSkinFrame{obj=f.outline}
	self:skinScrollBar{obj=f.scroll2}
	self:addSkinFrame{obj=f.outline2}
	self:addSkinFrame{obj=f}
	-- skin any existing EditBoxes
	for i = 1, 5 do
		local eb = _G["AzOptionsFactoryEditBox"..i]
		if eb then
			self:skinEditBox{obj=eb, regs={9}, noHeight=true}
		end
	end
	
	-- Profiles frame
	local p = f.profilesFrame
	self:addSkinFrame{obj=p.outline}
	self:skinEditBox{obj=p.edit, regs={9}, noHeight=true}
	self:addSkinFrame{obj=p}
	
end
