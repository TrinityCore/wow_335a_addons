if not Skinner:isAddonEnabled("Dominos") then return end

function Skinner:Dominos()

	-- hook to skin the configHelper panel
	self:SecureHook(Dominos, "ShowConfigHelper", function()
		self:skinButton{obj=DominosConfigHelperDialogExitConfig} -- this is a CheckButton object
		self:addSkinFrame{obj=DominosConfigHelperDialog, kfs=true, y1=4, y2=4, nb=true}
		self:Unhook(Dominos, "ShowConfigHelper")
	end)
	-- hook this to skin first menu displayed and its dropdown
	self:RawHook(Dominos, "NewMenu", function(this, id)
--		self:Debug("Dominos_NewMenu: [%s, %s]", this, id)
		local menu = self.hooks[this].NewMenu(this, id)
		if not self.skinned[menu] then
			self:addSkinFrame{obj=menu, x1=6, y1=-8, x2=-8, y2=6}
			self:SecureHookScript(menu, "OnShow", function(this)
				if this.dropdown then
					self:skinDropDown{obj=this.dropdown}
				end
				self:Unhook(menu, "OnShow")
			end)
		end
		self:Unhook(Dominos, "NewMenu")
		return menu
	end, true)
	
end

function Skinner:Dominos_Config()

	-- hook the create menu function
	self:SecureHook(Dominos.Menu, "New", function(this, name)
--		self:Debug("D.M.N:[%s, %s]", this, name)
		local panel = _G["DominosFrameMenu"..name]
		if not self.skinned[panel] then
			self:addSkinFrame{obj=panel, x1=6, y1=-8, x2=-8, y2=6}
		end
	end)
	-- hook the show panel function to skin dropdowns/editboxes & scrollbars
	self:SecureHook(Dominos.Menu, "ShowPanel", function(this, name)
--		self:Debug("D.M.SP:[%s, %s]", this, name)
		self:skinAllButtons{obj=_G[this:GetName()..name], x1=-1, x2=1}
		if this.dropdown then
			self:skinDropDown{obj=this.dropdown}
		end
		local stEB = _G[this:GetName()..name.."StateText"]
		if stEB then
			self:skinEditBox{obj=stEB, regs={9}, y=10}
		end
		if this.panels[2].scroll then
			self:skinScrollBar{obj=this.panels[2].scroll}
		end
	end)	

end
