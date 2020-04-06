if not Skinner:isAddonEnabled("BankItems") then return end

function Skinner:BankItems()
	if not self.db.profile.BankFrame then return end

	self:SecureHook("BankItems_CreateFrames", function()
		-- Bank Frame
		self:skinButton{obj=BankItems_CloseButton, cb=true}
		self:skinButton{obj=BankItems_GuildBankButton}
		self:skinButton{obj=BankItems_OptionsButton}
		self:skinDropDown{obj=BankItems_UserDropdown}
		self:addSkinFrame{obj=BankItems_Frame, kfs=true, x1=10, y1=-10, x2=-3, y2=6}
		-- container frames
		local BAGNUMBERS = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 100, 101, 102, 103, -2} -- Equipped is 100, Mail is 101, Currency is 102, AH is 103, Keyring is -2
		for _, v in pairs(BAGNUMBERS) do
			self:skinButton{obj=_G["BankItems_ContainerFrame"..v.."CloseButton"], cb=true}
			self:addSkinFrame{obj=_G["BankItems_ContainerFrame"..v], kfs=true, x1=6, y1=-5, x2=-3}
		end
		-- GuildBank Frame
		self:skinDropDown{obj=BankItems_GuildDropdown}
		self:skinButton{obj=BankItems_GBFrame_CloseButton, cb=true}
		self:addSkinFrame{obj=BankItems_GBFrame, kfs=true, y1=-11}
		for _, child in pairs{BankItems_GBFrame:GetChildren()} do
			if not child:IsObjectType("Button") then
				if floor(child:GetWidth()) == 42 and ceil(child:GetHeight()) == 50 then
					self:keepFontStrings(child) -- remove tab texture
				end
			end
		end
		self:Unhook("BankItems_CreateFrames")
	end)
	
-->>--	Export/Search Frame
	self:skinScrollBar{obj=BankItems_ExportFrame_Scroll}
	self:skinDropDown{obj=BankItems_ExportFrame_SearchDropDown}
	self:skinEditBox{obj=BankItems_ExportFrame_SearchTextbox, regs={9}}
	self:skinButton{obj=BankItems_ExportFrameButton}
	self:skinButton{obj=BankItems_ExportFrame_ResetButton}
	self:addSkinFrame{obj=BankItems_ExportFrame, kfs=true}

end
