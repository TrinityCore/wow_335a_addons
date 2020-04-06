local addon = DiminishingReturns
if not addon then return end

local	db
	
addon:RegisterAddonSupport('ShadowedUnitFrames', function()

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

	db = addon.db:RegisterNamespace('ShadowedUnitFrames', {profile={
		target = defaults,
		focus = defaults,
		arena = defaults, -- should find better one
	}})

	local function RegisterFrame(unit)
		local function GetDatabase() return db.profile[unit], db end
		addon:RegisterFrameConfig('SUF: '..addon.L[unit], GetDatabase)
		addon:RegisterFrame('SUFUnit'..unit, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end

	RegisterFrame('target')
	RegisterFrame('focus')
	
end)

-- ShadowedUF_Arena depends on SUF so it is loaded after and db would be initialized at that time
addon:RegisterAddonSupport('ShadowedUF_Arena', function()
	local function GetDatabase() return db.profile.arena, db end
	local function SetupFrame(frame)
		return addon:SpawnFrame(frame, frame, GetDatabase)
	end
	addon:RegisterFrameConfig('SUF: '..addon.L["Arena"], GetDatabase)
	for index = 1, 5 do
		addon:RegisterFrame('SUFHeaderarenaUnitButton'..index, SetupFrame)
	end
end)
	
