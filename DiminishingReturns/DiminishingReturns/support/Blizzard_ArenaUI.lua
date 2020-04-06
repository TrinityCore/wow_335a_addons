local addon = DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('Blizzard_ArenaUI', function()

	local db = addon.db:RegisterNamespace('Blizzard_ArenaUI', {profile={
		enabled = true,
		iconSize = 16,
		direction = 'LEFT',
		spacing = 2,
		anchorPoint = 'RIGHT',
		relPoint = 'LEFT',
		xOffset = -4,
		yOffset = -2,
	}})

	local function GetDatabase() 
		return db.profile, db
	end

	addon:RegisterFrameConfig(addon.L['Blizzard: arena enemies'], GetDatabase)

	local function SetupFrame(frame)
		return addon:SpawnFrame(frame, frame, GetDatabase)
	end

	for i = 1,5 do
		addon:RegisterFrame('ArenaEnemyFrame'..i, SetupFrame)
	end
	
end)

