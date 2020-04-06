if not Skinner:isAddonEnabled("GnomeWorks") then return end

function Skinner:GnomeWorks() --r45

	local function skinFrame()

		-- GnomeWorks.MainWindow
		self:keepFontStrings(GnomeWorks.MainWindow.title)
		self:skinDropDown{obj=GnomeWorksGrouping}
		self:glazeStatusBar(GnomeWorks.levelStatusBar, 0, nil)
		self:skinEditBox{obj=GnomeWorks.searchBoxFrame}
		self:addSkinFrame{obj=GnomeWorks.MainWindow, kfs=true, y1=3, x2=3}
		self:addSkinFrame{obj=GnomeWorks.skillFrame, x1=-3, y1=2, x2=2, y2=-2}
		self:addSkinFrame{obj=GnomeWorks.detailFrame, x1=-2, y1=2, x2=2, y2=-2}
		self:addSkinFrame{obj=GnomeWorks.reagentFrame, x1=-2, y1=2, x2=2, y2=-2}
		for _, child in pairs{GnomeWorks.controlFrame.QueueButtons:GetChildren()} do
			if child:IsObjectType("EditBox") then
				self:skinEditBox{obj=child, noHeight=true, noWidth=true	}
			end
		end
		-- GnomeWorks.QueueWindow
		-- Dock Tab
		self:addSkinButton{obj=GnomeWorks.QueueWindow.dockTab, bg=true, y1=-6, x2=-3, y2=6}
		self:getRegion(GnomeWorks.QueueWindow.dockTab, 1):SetTexture(nil)
		-- ScrollFrame
		local sf = self:getChild(self:getChild(GnomeWorks.QueueWindow, 4), 1)
		self:addSkinFrame{obj=sf, y1=2, x2=2, y2=-6}
		self:addSkinFrame{obj=GnomeWorks.QueueWindow, kfs=true, y1=3, x2=3}

	end
	if self.modBtns then
		-- hook this to skin buttons
		self:RawHook(GnomeWorks, "CreateButton", function(this, ...)
			local btn = self.hooks[this].CreateButton(this, ...)
			for _, state in pairs{"Disabled", "Up", "Down"} do
				btn.state[state]:DisableDrawLayer("BACKGROUND")
			end
			self:applySkin{obj=btn, bd=Skinner.Backdrop[6]}
			return btn
		end, true)
	end
	-- hook this to hide backdrops
	self:RawHook(GnomeWorks.Window, "SetBetterBackdrop", function(this, frame, ...)
		self.hooks[this].SetBetterBackdrop(this, frame, ...)
		for k, v in pairs(frame.backDrop) do
			if type(v) == "table" and k:find("texture") then
				v:SetAlpha(0)
			end
		end
	end, true)
	GnomeWorks.Window.SetBetterBackdropColor = function() end
	-- hook this to skin ScrollBars
	self:RawHook(GnomeWorks, "CreateScrollingTable", function(this, ...)
		local frame = self.hooks[this].CreateScrollingTable(this, ...)
		self:skinScrollBar{obj=frame}
		local scrollBar = _G[frame:GetName().."ScrollBar"]
		self:getRegion(self:getChild(scrollBar, 3), 1):SetTexture(nil) -- remove scroll bar trough
		return frame
	end, true)
	-- hook this to skin frames
	if not GnomeWorks.MainWindow then
		self:SecureHook(GnomeWorks, "Initialize", function(this)
			skinFrame()
			self:Unhook(GnomeWorks, "Initialize")
		end)
	else
		skinFrame()
	end

end
