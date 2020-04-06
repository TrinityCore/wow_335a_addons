if not Skinner:isAddonEnabled("Collectinator") then return end

function Skinner:Collectinator()

	-- skin the frame
	self:SecureHook(Collectinator, "DisplayFrame", function(this)
		Collectinator.bgTexture:SetAlpha(0)
		self:moveObject{obj=this.Frame.mode_button, y=-9}
		self:skinDropDown{obj=Collectinator_DD_Sort}
		self:skinEditBox{obj=Collectinator_SearchText, regs={9}}
		self:glazeStatusBar(this.Frame.progress_bar, 0)
		self:skinScrollBar{obj=Collectinator_CollectibleScrollFrame}
		self:addSkinFrame{obj=this.Frame, y1=-9, x2=2, y2=-4}
		self:addSkinFrame{obj=this.Flyaway, kfs=true, bg=true, x2=2}
		-- tooltips
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then CollectinatorSpellTooltip:SetBackdrop(self.Backdrop[1]) end
			self:SecureHookScript(CollectinatorSpellTooltip, "OnShow", function(this)
				self:skinTooltip(this)
			end)
		end
		--	minus/plus buttons
		for _, btn in pairs(this.PlusListButton) do
			self:skinButton{obj=btn, mp2=true, plus=true}
			btn.text:SetJustifyH("CENTER")
		end
		self:Unhook(Collectinator, "DisplayFrame")
	end)
	
	-- TextDump frame
	self:skinScrollBar{obj=CollectinatorCopyScroll}
	self:addSkinFrame{obj=CollectinatorCopyFrame}

	-- button on PetPaperDoll frame
	self:skinButton{obj=Collectinator.ScanButton}

end
