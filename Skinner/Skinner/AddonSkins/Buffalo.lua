if not Skinner:isAddonEnabled("Buffalo") then return end

function Skinner:Buffalo()

	if not LibStub("LibButtonFacade", true) then
		for i = 0, 31 do
			local frame = _G["BFLayout"..i]
			self:applySkin(frame)
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", "BuffaloButton"..i, "TOPLEFT", -2, 2)
			frame:SetPoint("BOTTOMRIGHT", "BuffaloButton"..i, "BOTTOMRIGHT", 2, -2)
			local icon = _G["BuffaloButton"..i.."Icon"]
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", "BFLayout"..i, "TOPLEFT", 5, -5)
			icon:SetPoint("BOTTOMRIGHT", "BFLayout"..i, "BOTTOMRIGHT", -5, 5)
		end
		for i = 0, 15 do
			local frame = _G["DFLayout"..i]
			self:applySkin(frame)
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", "DebuffaloButton"..i, "TOPLEFT", -2, 2)
			frame:SetPoint("BOTTOMRIGHT", "DebuffaloButton"..i, "BOTTOMRIGHT", 2, -2)
			local icon = _G["DebuffaloButton"..i.."Icon"]
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", "DFLayout"..i, "TOPLEFT", 5, -5)
			icon:SetPoint("BOTTOMRIGHT", "DFLayout"..i, "BOTTOMRIGHT", -5, 5)
		end
		for i = 0, 1 do
			local frame = _G["WBLayout"..i]
			self:applySkin(frame)
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", "WeaponBuffaloButton"..i, "TOPLEFT", -2, 2)
			frame:SetPoint("BOTTOMRIGHT", "WeaponBuffaloButton"..i, "BOTTOMRIGHT", 2, -2)
			local icon = _G["WeaponBuffaloButton"..i.."Icon"]
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", "WBLayout"..i, "TOPLEFT", 5, -5)
			icon:SetPoint("BOTTOMRIGHT", "WBLayout"..i, "BOTTOMRIGHT", -5, 5)
		end
	end

end
