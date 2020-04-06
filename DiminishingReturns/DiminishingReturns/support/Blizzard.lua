local addon = DiminishingReturns
if not addon then return end

-- FrameXML is a internal fake to have this working like other support
addon:RegisterAddonSupport('FrameXML', function()
	
	local db = addon.db:RegisterNamespace('Blizzard', {profile={
		target = {
			enabled = true,
			iconSize = 16,
			direction = 'BOTTOM',
			spacing = 2,
			anchorPoint = 'TOPLEFT',
			relPoint = 'TOPRIGHT',
			xOffset = -25,
			yOffset = -20,
		},
		focus = {
			enabled = true,
			iconSize = 16,
			direction = 'RIGHT',
			spacing = 2,
			anchorPoint = 'TOPLEFT',
			relPoint = 'BOTTOMLEFT',
			xOffset = 14,
			yOffset = 28,
		},
	}})
	
	local function RegisterFrame(name, unit)
		local function GetDatabase() return db.profile[unit], db end
		addon:RegisterFrameConfig('Blizzard: '..addon.L[unit], GetDatabase)
		addon:RegisterFrame(name, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end

	RegisterFrame('TargetFrame', 'target')
	RegisterFrame('FocusFrame', 'focus')
end)

