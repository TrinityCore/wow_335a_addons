if not Skinner:isAddonEnabled("TheCollector") then return end

function Skinner:TheCollector()

	self:getChild(TheCollectorFrame, 2):Hide() -- button in TLH corner
	self:skinFFToggleTabs("TheCollectorFrameTab", 3)
	self:skinScrollBar{obj=TheCollectorFrameScrollFrame}
	self:getChild(TheCollectorFrameStatusBar, 1):SetAlpha(0) -- border texture
	self:glazeStatusBar(TheCollectorFrameStatusBar, 0)
	self:keepFontStrings(TheCollectorFrameHeaderFrame)
	self:addSkinFrame{obj=TheCollectorFrame, kfs=true, x1=4, y1=-5, x2=-5, y2=-10}
--[=[
-->>-- Model frame (not currently used)
	self:makeMFRotatable(TheCollectorModel)
	TheCollectorModel:SetBackdrop(nil)
	self:addSkinFrame{obj=TheCollectorModelFrame}
--]=]
	
	-- m/p buttons
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("TheCollectorScrollFrameUpdate", function()
			for i = 1, COLLECTOR_NUM_ITEMS_TO_DISPLAY do
				self:checkTex(_G["TheCollectorFrameScrollFrameHeader"..i])
			end
		end)
	end
	for i = 1, COLLECTOR_NUM_ITEMS_TO_DISPLAY do
		self:skinButton{obj=_G["TheCollectorFrameScrollFrameHeader"..i], mp=true}
	end
	
end
