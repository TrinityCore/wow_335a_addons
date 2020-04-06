if not Skinner:isAddonEnabled("tabDB") then return end
-- many thanks to DefectiveUser

function Skinner:tabDB()

	if ( libTab ) then
		if ( libTab.Data.TabDBtabs ) then  -- version 2.0a1
			for k, v in pairs(tabDB_tabFrames) do
				local tabId = libTab.Data.TabDBtabs.tab["fid_"..v.Frame]
				local tabObj = _G["libTabTabDBtabs"..tabId]
				self:removeRegions(tabObj, {1})
				if ( v.Frame == "LFDParentFrame" ) then
					libTab.Data.TabDBtabs.tab[tabId].offsetX = 0 -- We no longer need an offset for this frame when using Skinner
				end
			end
		elseif ( libTab.Data.TestTabs ) then  -- version 2.0a
			for k, v in pairs(tabDB_tabFrames) do
				local tabId = libTab.Data.TestTabs.tab["fid_"..v.Frame]
				local tabObj = _G["libTabTestTabs"..tabId]
				self:removeRegions(tabObj, {1})
				if ( v.Frame == "LFDParentFrame" ) then
					libTab.Data.TestTabs.tab[tabId].offsetX = 0 -- Same as above
				end
			end
		end
	else
		for i = 1, TABDB_MAX_TABS do  -- version 1.0a
			self:removeRegions(_G["tabDBtab"..i], {1}) -- N.B. other regions are icon and highlight
		end
	end

end
