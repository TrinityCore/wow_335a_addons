if not Skinner:isAddonEnabled("ElitistGroup") then return end

function Skinner:ElitistGroup()

	local eGrp = LibStub("AceAddon-3.0"):GetAddon("ElitistGroup", true)
	if eGrp then
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then ElitistGroupTooltip:SetBackdrop(self.Backdrop[1]) end
			self:SecureHookScript(ElitistGroupTooltip, "OnShow", function(this)
				self:skinTooltip(this)
			end)
		end
	end
-->>-- User Info frame
	local egUsr = eGrp:GetModule("Users", true)
	if not egUsr then return end
	self:SecureHook(egUsr, "CreateUI", function(this)
		self:Unhook(egUsr, "CreateUI")
		local frame = this.frame
		self:moveObject{obj=frame.title, y=-6}
		self:addSkinFrame{obj=frame, kfs=true}--, x1=10, y1=-12, x2=-32, y2=71}
		-- Database frame (pullout on RHS)
		self:skinEditBox{obj=this.databaseFrame.search, regs={9}}
		self:skinScrollBar{obj=this.databaseFrame.scroll}
		self:addSkinFrame{obj=this.databaseFrame, kfs=true}
		-- User data container
		self:addSkinFrame{obj=this.infoFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- Dungeon suggested container
		self:skinScrollBar{obj=this.dungeonFrame.scroll}
		self:addSkinFrame{obj=this.dungeonFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- Parent container
		self:addSkinFrame{obj=this.tabContainer, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- Equipment frame
		self:addSkinFrame{obj=this.equipmentFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- Achievement container
		self:skinScrollBar{obj=this.achievementsFrame.scroll}
		self:addSkinFrame{obj=this.achievementsFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- skin minus/plus buttons
		for i = 1, #this.achievementsFrame.rows do
			self:skinButton{obj=this.achievementsFrame.rows[i].toggle, mp2=true}
		end
		-- Notes container
		self:skinScrollBar{obj=this.notesFrame.scroll}
		self:addSkinFrame{obj=this.notesFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- extratooltip
		if self.db.profile.Tooltips.skin then
			local eSlots = this.equipmentFrame.equipSlots
			for i = 1, #eSlots do -- have to hook all of them as any will create the tooltip
				self:SecureHookScript(eSlots[i], "OnEnter", function(this)
					if ElitistGroupSuitationalTooltip then
						if self.db.profile.Tooltips.style == 3 then
							ElitistGroupSuitationalTooltip:SetBackdrop(self.Backdrop[1])
						end
						self:SecureHookScript(ElitistGroupSuitationalTooltip, "OnShow", function(this)
							self:skinTooltip(this)
						end)
						-- unhook them all
						for i = 1, #eSlots do
							self:Unhook(eSlots[i], "OnEnter")
						end
					end
				end)
			end
		end
	end)

-->>-- PartySummary frame
	local egPS = eGrp:GetModule("PartySummary", true)
	if not egPS then return end
	self:SecureHook(egPS, "CreateUI", function(this)
		self:Unhook(egPS, "CreateUI")
		local frame = this.frame
		self:moveObject{obj=frame.title, y=-6}
		self:addSkinFrame{obj=frame, kfs=true}
	end)

-->>-- RaidSummary frame
	local egRS = eGrp:GetModule("RaidSummary", true)
	if not egRS then return end
	self:SecureHook(egRS, "CreateUI", function(this)
		self:Unhook(egRS, "CreateUI")
		local frame = this.frame
		self:moveObject{obj=frame.title, y=-6}
		self:skinScrollBar{obj=frame.scroll}
		self:addSkinFrame{obj=frame, kfs=true}
	end)

-->>-- GroupRating frame
	local egGR = eGrp:GetModule("Notes", true)
	if not egGR then return end
	self:SecureHook(egGR, "CreateUI", function(this)
		self:Unhook(egGR, "CreateUI")
		local frame = this.frame
		self:moveObject{obj=frame.title, y=-6}
		self:skinScrollBar{obj=frame.scroll}
		self:addSkinFrame{obj=frame, kfs=true}
		for i = 1, 8 do
			self:skinEditBox{obj=frame.rows[i].comment, regs={9}}
		end
	end)

-->>-- Report frame
	local egR = eGrp:GetModule("Report", true)
	if not egR then return end
	self:SecureHook(egR, "CreateUI", function(this)
		self:Unhook(egR, "CreateUI")
		local frame = this.frame
		self:moveObject{obj=frame.title, y=-6}
		self:addSkinFrame{obj=frame, kfs=true}
		-- general config frame
		self:skinDropDown{obj=frame.generalFrame.levelFilter}
		self:skinDropDown{obj=frame.generalFrame.equipmentFilter}
		self:skinDropDown{obj=frame.generalFrame.enchantFilter}
		self:skinDropDown{obj=frame.generalFrame.gemFilter}
		self:skinDropDown{obj=frame.generalFrame.channelFilter}
		self:skinDropDown{obj=frame.generalFrame.matchFilters}
		self:addSkinFrame{obj=frame.generalFrame, kfs=true}
		-- class toggles frame
		self:addSkinFrame{obj=frame.classFrame, kfs=true}
	end)

end
