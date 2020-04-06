
function Skinner:InstanceMaps()
	if not self.db.profile.WorldMap.skin then return end

	local IM = LibStub:GetLibrary("AceAddon-3.0", true):GetAddon("InstanceMaps", true)
	local IML = IM and IM:GetModule("Loot", true)
	local IMB = IM and IM:GetModule("Browse", true)

	if IML then
		self:SecureHook(IML, "UpdateViewer", function()
			self:applySkin(InstanceMaps_LootViewer)
			InstanceMaps_LootViewer:SetFrameLevel(InstanceMaps_Notes_Button1:GetFrameLevel() + 1 )
			InstanceMaps_LootViewer.SetBackdropColor = function() end
			InstanceMaps_LootViewer.SetBackdropBorderColor = function() end
			self:moveObject(self:getChild(InstanceMaps_LootViewer, 1), "+", 2, "+", 2)
			self:Unhook(IML, "UpdateViewer")
		end)

	-->>-- Tooltip
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then InstanceMaps_Loot_ScanTooltip:SetBackdrop(self.backdrop) end
			self:skinTooltip(InstanceMaps_Loot_ScanTooltip)
		end
	end

	if IMB then
		self:SecureHook(IMB, "WorldMapFrame_Show", function()
			self:skinDropDown(InstanceMaps_Browse_Dropdown)
			if IsAddOnLoaded("Cartographer") then
				self:moveObject(InstanceMaps_Browse_Dropdown, "+", 50, nil, nil)
			end
			self:Unhook(IMB, "WorldMapFrame_Show")
		end)
	end

end
