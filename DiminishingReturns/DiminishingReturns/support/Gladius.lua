local addon = DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('Gladius', function()

	local db = addon.db:RegisterNamespace('Gladius', {profile={
		enabled = true,
		iconSize = 32,
		direction = 'LEFT',
		spacing = 2,
		anchorPoint = 'TOPRIGHT',
		relPoint = 'TOPLEFT',
		xOffset = -10,
		yOffset = 0,
	}})

	local function GetDatabase() 
		return db.profile, db
	end

	addon:RegisterFrameConfig('Gladius', GetDatabase)

	local function SetupFrame(frame)
		return addon:SpawnFrame(frame:GetParent(), frame, GetDatabase)
	end

	local needHook = false
	for i = 1,5 do
		if not addon:RegisterFrame('GladiusButton'..i, SetupFrame) then
			needHook = true
		end
	end

	if needHook then
		hooksecurefunc(Gladius, 'UpdateAttribute', function(gladius, unit)
			addon.CheckFrame(gladius.buttons[unit].secure)
		end)
	end
	
end)

