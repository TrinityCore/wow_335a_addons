
function Skinner:KLHThreatMeter()

-- Skin supplied by arkan, Thanks

	-- backdrop
	bd = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	}

	-- i forbid you to change border color...
	klhtm.raidtable.setcolour = function() end

	-- sex up the header
	for k, v in pairs(klhtm.raidtable.instances) do
		i = klhtm.raidtable.instances[k]
		self:applySkin(i.gui.table, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header)
		self:applySkin(i.gui.header.identifier, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header.options, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header.setmt, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header.minimise, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header.close, nil, nil, nil, nil, bd)
	end

	-- all option frames are deferred creation, therefore skin them just after they are created
	-- options menu section buttons not created on load so let's hijack their creation, ugly yes?
	self:SecureHook(klhtm.helpmenu, "showsection", function(sectionname)
--		self:Debug("HelpMenu_showsection: [%s]", sectionname)
		local mrt = klhtm.menuraidtable
		if sectionname == "raidtable"  and not self.skinned[mrt] then
			self:applySkin(mrt.mainframe)
			self:applySkin(mrt.mainframe.button)
			for index,value in pairs(klhtm.helpmenu.button) do
				if (type(value) == "table") then
				self:applySkin(klhtm.helpmenu.button[index], nil, nil, nil, nil, bd)
				end
			end
		end
		if sectionname == "raidtable-colour" and not self.skinned[mrt.colourframe] then
			self:applySkin(mrt.colourframe)
			self:applySkin(mrt.colourframe.button1)
			self:applySkin(mrt.colourframe.button2)
			self:applySkin(mrt.colourframe.button3)
		end
		if sectionname == "raidtable-layout" and not self.skinned[mrt.layoutframe] then
			self:applySkin(mrt.layoutframe)
			self:applySkin(mrt.layoutframe.button1)
			self:applySkin(mrt.layoutframe.button2)
			self:applySkin(mrt.layoutframe.button3)
			self:applySkin(mrt.layoutframe.button4)
		end
		if sectionname == "raidtable-filter" and not self.skinned[mrt.filterframe] then
			self:applySkin(mrt.filterframe)
		end
		if sectionname == "raidtable-misc" and not self.skinned[mrt.miscframe] then
			self:applySkin(mrt.miscframe)
		end
		local mmt = klhtm.menumythreat
		if sectionname == "mythreat" and not self.skinned[mmt.mainframe] then
			self:applySkin(mmt.mainframe)
			self:applySkin(mmt.mainframe.reset)
			self:applySkin(mmt.mainframe.update)
			self:applySkin(mmt.mainframe.mytable)
		end
		local me = klhtm.menuerror
		if sectionname == "errorlog" and not self.skinned[me.frame] then
			self:applySkin(me.frame)
			self:applySkin(me.frame.button1)
			self:applySkin(me.frame.button2)
			self:applySkin(me.frame.button3)
			self:applySkin(me.frame.button4)
		end
	end)

	-- skin the weird ass options window
	self:applySkin(klhtm.helpmenu.sections.raidtable.frame.button)
	self:applySkin(klhtm.menuhome.frame)
	self:applySkin(klhtm.error.frame)
	self:applySkin(klhtm.menudiag.frame)

	-- skin the copy box because i'm anal-retentive
	self:SecureHook(klhtm.gui, "showcopybox", function(text)
		self:applySkin(klhtm.gui.copybox)
		self:applySkin(klhtm.gui.copybox.button)
		self:Unhook(klhtm.gui, "showcopybox")
	end)

end
