if not Skinner:isAddonEnabled("Livestock") then return end

function Skinner:Livestock()

	local mCnt = 5
	local lType = {["CRITTER"] = "Critter", ["LAND"] = "Land", ["FLYING"] = "Flying"}
	local function skinMenu(kind, cnt)

		local mFrame = _G["Livestock"..lType[kind].."Menu"..cnt]
		if mFrame and not Skinner.skinned[mFrame] then self:addSkinFrame{obj=mFrame} end
		
	end
	-- hook this to handle menu rebuilds
	self:SecureHook(Livestock, "BuildMenu", function(kind)
		for i = 1, mCnt do
			skinMenu(kind, i)
		end
	end)
	
	-- main frame
	self:skinButton{obj=LivestockCritterMenuButton}
	self:skinButton{obj=LivestockLandMountMenuButton}
	self:skinButton{obj=LivestockFlyingMountMenuButton}
	self:skinButton{obj=LivestockMenuFrameClose, cb=true, sap=true}
	self:addSkinFrame{obj=LivestockMenuFrame}
	-- sub frames
	for i = 1, mCnt do
		for kind, _ in pairs(lType) do
			skinMenu(kind, i)
		end
	end
	-- model frame
	self:addSkinFrame{obj=LivestockModelFrame}

end
