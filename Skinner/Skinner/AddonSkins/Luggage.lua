if not Skinner:isAddonEnabled("Luggage") then return end

function Skinner:Luggage()
	if not self.db.profile.ContainerFrames.skin then return end
	
	-- hook this to skin new Tabbed Frames aka BagBar
	self:RawHook(Luggage.TabbedFrame, "New", function(this, ...)
		local newTF = self.hooks[this].New(this, ...)
		self:applySkin(newTF.frame)
		return newTF
	end, true)
	-- hook this to skin new Tabbed Frame Tab
	self:SecureHook(Luggage.TabbedFrame, "AddTab", function(this, icon, name)
		for i = 1, #this.tabButtons do
			if this.tabButtons[i].tabName == name then
				self:keepRegions(this.tabButtons[i], {7, 8, 9})  -- N.B. region 7 is the Text, 8 is the highlight, 9 is the icon
			end
		end
	end)
	-- hook this to skin new Bags
	self:RawHook(Luggage.Bag, "New", function(this, ...)
		local newBag = self.hooks[this].New(this, ...)
		self:applySkin(newBag.frame)
		return newBag
	end, true)
	-- hook this to skin the Options Frame
	self:SecureHook(Luggage, "CreateDialog", function(this)
--		self:Debug("Luggage_CD")
		self:ShowInfo(this.dialog.frame)
		self:removeRegions(this.dialog.frame, {10, 11, 12}) -- Header Textures
		self:applySkin(this.dialog.statusbg)
		self:applySkin(this.dialog.frame)
		self:Unhook(Luggage, "CreateDialog")
	end)

	self:skinDropDown(Luggage.dropdown)
	-- skin existing BagBars
	for i = 1, #Luggage.bagbars do
		local tF = Luggage.bagbars[i].tabbedFrame
		self:applySkin(tF.frame)
		-- skin existing tabs
		for j = 1, #tF.tabButtons do
			self:keepRegions(tF.tabButtons[j], {7, 8, 9})  -- N.B. region 7 is the Text, 8 is the highlight, 9 is the icon
		end
		-- skin existing Bags
		for bag in pairs(Luggage.bagbars[i].bags) do
			self:applySkin(bag.frame)
		end
	end

end
