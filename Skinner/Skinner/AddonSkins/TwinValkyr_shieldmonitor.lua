if not Skinner:isAddonEnabled("TwinValkyr_shieldmonitor") then return end

function Skinner:TwinValkyr_shieldmonitor()

	self:addSkinFrame{obj=TWcolishieldmini}
	-- Options frame
	self:addSkinFrame{obj=TwinValmenu, x=5, y1=-5, x2=-5, y2=4}
	self:skinButton{obj=TwinValmenu_Button1, x1=-1, y1=0, x2=1, y2=1, ty=0}
	self:skinButton{obj=TwinValmenu_Button2}
	self:skinButton{obj=TwinValmenu_Button3}
	self:skinEditBox{obj=TwinValmenu_width1, noHeight=true}
	self:adjWidth{obj=TwinValmenu_width1, adj=3}
	self:skinEditBox{obj=TwinValmenu_heigh1, noHeight=true}
	self:adjWidth{obj=TwinValmenu_heigh1 , adj=3}
	
end
