local addon = DiminishingReturns
if not addon then return end

local function SetupNameplates(LibNameplate)
	local db = addon.db:RegisterNamespace('Nameplates', {profile={
		enabled = true,
		iconSize = 16,
		direction = 'RIGHT',
		spacing = 2,
		anchorPoint = 'TOP',
		relPoint = 'BOTTOM',
		xOffset = 0,
		yOffset = 0,
	}})

	local function GetDatabase()
		return db.profile, db
	end

	local function GetNameplateGUID(self)
		return LibNameplate:GetGUID(self.anchor) or nil
	end
	
	local function OnNameplateEnable(self)
		LibNameplate.RegisterCallback(self, "LibNameplate_FoundGUID", "UpdateGUID")
		LibNameplate.RegisterCallback(self, "LibNameplate_RecycleNameplate", "UpdateGUID")
	end

	local function OnNameplateDisable(self)
		LibNameplate.UnregisterAllCallbacks(self)
	end

	addon:RegisterFrameConfig('Nameplates', GetDatabase)

	local seen = {}
	LibNameplate.RegisterCallback(addon, 'LibNameplate_NewNameplate', function(_ , nameplate)
		if seen[nameplate] then return end
		seen[nameplate] = true
		addon:Debug("Creating DR frame for new nameplate")
		return addon:SpawnGenericFrame(nameplate, GetDatabase, GetNameplateGUID, OnNameplateEnable, OnNameplateDisable, 'noCooldown', true)
	end)
end

local function TestLibNameplate()
	local lib, minor = LibStub('LibNameplate-1.0', true)
	if lib then
		addon:Debug("Found LibNameplate-1.0", minor)
		addon:UnregisterEvent('ADDON_LOADED', TestLibNameplate)
		return SetupNameplates(lib)
	end
end
addon:RegisterEvent('ADDON_LOADED', TestLibNameplate)
