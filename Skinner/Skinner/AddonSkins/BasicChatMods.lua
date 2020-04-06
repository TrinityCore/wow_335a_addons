if not Skinner:isAddonEnabled("BasicChatMods") then return end

function Skinner:BasicChatMods()

	if BCMCopyFrame then
	    self:skinScrollBar{obj=BCMCopyScroll}
	    self:addSkinFrame{obj=BCMCopyFrame}
	end
	
end
