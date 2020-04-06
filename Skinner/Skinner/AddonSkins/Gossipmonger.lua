if not Skinner:isAddonEnabled("Gossipmonger") then return end

function Skinner:Gossipmonger()

	self:keepFontStrings(Gossipmonger_MirrorFrame_GreetingScrollFrame)
	self:skinScrollBar(Gossipmonger_MirrorFrame_GreetingScrollFrame)
	self:applySkin(Gossipmonger_MirrorFrame)

end
