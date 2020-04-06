local addon = DiminishingReturns
if not addon then return end

local	db
	
addon:RegisterAddonSupport('Stuf', function()

	local defaults = {
		enabled = true,
		iconSize = 24,
		direction = 'RIGHT',
		spacing = 2,
		anchorPoint = 'TOPLEFT',
		relPoint = 'BOTTOMLEFT',
		xOffset = 0,
		yOffset = -4,
	}

	db = addon.db:RegisterNamespace('StellarUF', {profile={
		target = defaults,
		focus = defaults,
		arena = defaults, -- should find better one
	}})

	local function RegisterFrame(unit)
		local function GetDatabase() return db.profile[unit], db end
		addon:RegisterFrameConfig('STUF: '..addon.L[unit], GetDatabase)
		addon:RegisterFrame('Stuf.units.'..unit, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end

	RegisterFrame('target')
	RegisterFrame('focus')
	
end)

