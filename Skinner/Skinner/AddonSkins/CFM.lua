if not Skinner:isAddonEnabled("CFM") then return end

function Skinner:CFM()

-->>-- Import frame
	self:SecureHook("CFM_Import", function(this)
		self:addSkinFrame{obj=CFM_ImportFrame}
		self:skinEditBox{obj=CFM_ImportProfileBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:skinEditBox{obj=CFM_ImportHeaderBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:skinEditBox{obj=CFM_ImportFrameBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:Unhook("CFM_Import")
	end)
	
-->>-- Config frame(s)
	self:SecureHook("CFM_GUI", function(this)
		self:addSkinFrame{obj=CFM_Config}
		-- Scroll panel
		self:addSkinFrame{obj=CFM_ScrollFrame}
		-- dont skin scrollbar it moves to the right !
		-- Properties panel
		self:addSkinFrame{obj=CFM_PropFrame}
		for _, label in pairs{"Width", "Height", "Scale", "Level", "Alpha"} do
			self:skinEditBox{obj=_G["CFM_"..label.."Box"], regs={9}, noHeight=true, noWidth=true, noInsert=true}
			self:skinButton{obj=_G["CFM_"..label.."_Minus"], mp2=true}
			self:skinButton{obj=_G["CFM_"..label.."_Plus"], mp2=true, plus=true, noWidth=true}
		end
		self:skinDropDown{obj=CFM_FromBox}
		self:skinDropDown{obj=CFM_ToBox}
		self:skinDropDown{obj=CFM_StrataBox}
		self:skinEditBox{obj=CFM_ChangeParentBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		-- Adder panel
		self:addSkinFrame{obj=CFM_FrameAdder}
		self:skinEditBox{obj=CFM_FrameBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:skinEditBox{obj=CFM_ParentBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		-- Mover panel
		self:addSkinFrame{obj=CFM_Mover}
		for _, label in pairs{"X", "Y"} do
			self:skinEditBox{obj=_G["CFM_"..label.."Box"], regs={9}, noHeight=true, noWidth=true, noInsert=true}
			self:skinButton{obj=_G["CFM_Mover_"..label.."Minus"], mp2=true}
			self:skinButton{obj=_G["CFM_Mover_"..label.."Plus"], mp2=true, plus=true}
		end
		-- Mouseover panel
		self:addSkinFrame{obj=CFM_MouseInfoFrame, y2=-2}
		self:Unhook("CFM_GUI")
	end)

end
