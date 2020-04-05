if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_RaidTargetIcon requires PitBull4")
end

local L = PitBull4.L

local PitBull4_RaidTargetIcon = PitBull4:NewModule("RaidTargetIcon", "AceEvent-3.0", "AceTimer-3.0")

PitBull4_RaidTargetIcon:SetModuleType("indicator")
PitBull4_RaidTargetIcon:SetName(L["Raid target icon"])
PitBull4_RaidTargetIcon:SetDescription(L["Show an icon on the unit frame based on which Raid Target it is."])
PitBull4_RaidTargetIcon:SetDefaults({
	attach_to = "root",
	location = "edge_top",
	position = 1,
	[1] = true, -- Star 
	[2] = true, -- Circle 
	[3] = true, -- Diamond 
	[4] = true, -- Triangle 
	[5] = true, -- Moon
	[6] = true, -- Square
	[7] = true, -- Cross
	[8] = true, -- Skull
})

function PitBull4_RaidTargetIcon:OnEnable()
	self:RegisterEvent("RAID_TARGET_UPDATE")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
end

function PitBull4_RaidTargetIcon:GetTexture(frame)
	local unit = frame.unit
	
	local index = GetRaidTargetIndex(unit)
	
	if not index then
		return nil
	end

	-- Disabled
	if not self:GetLayoutDB(frame)[index] then
		return nil
	end
	
	return [[Interface\TargetingFrame\UI-RaidTargetingIcon_]] .. index
end

function PitBull4_RaidTargetIcon:GetExampleTexture(frame)
	local unit = frame.unit or frame:GetName()
	
	local index = unit:match(".*(%d+)")
	if index then
		index = index+0
	else
		index = 0
	end
	index = index + #unit + unit:byte()
	
	index = (index % 8) + 1
	
	-- Disabled
	if not self:GetLayoutDB(frame)[index] then
		return nil
	end
	
	return [[Interface\TargetingFrame\UI-RaidTargetingIcon_]] .. index
end

function PitBull4_RaidTargetIcon:RAID_TARGET_UPDATE()
	self:UpdateAll()
end

function PitBull4_RaidTargetIcon:PARTY_MEMBERS_CHANGED()
	self:ScheduleTimer("UpdateAll", 0.1)
end

PitBull4_RaidTargetIcon:SetLayoutOptionsFunction(function(self)
	local function get(info)
		return PitBull4.Options.GetLayoutDB(self)[info[#info]+0]
	end

	local function set(info,value)
		PitBull4.Options.GetLayoutDB(self)[info[#info]+0] = value

		PitBull4.Options.UpdateFrames()
	end

	return '1',{
		type = 'toggle',
		name = [[|TInterface\TargetingFrame\UI-RaidTargetingIcons:0:0:0:0:256:256:0:64:0:64|t |cfffff200]]..RAID_TARGET_1,
		desc = L["Show this raid target icon for this layout."],
		get = get,
		set = set,
	}, '2', {
		type = 'toggle',
		name = [[|TInterface\TargetingFrame\UI-RaidTargetingIcons:0:0:0:0:256:256:64:128:0:64|t |cfff99100]]..RAID_TARGET_2,
		desc = L["Show this raid target icon for this layout."],
		get = get,
		set = set,
	}, '3', {
		type = 'toggle',
		name = [[|TInterface\TargetingFrame\UI-RaidTargetingIcons:0:0:0:0:256:256:128:192:0:64|t |cffd338e5]]..RAID_TARGET_3,
		desc = L["Show this raid target icon for this layout."],
		get = get,
		set = set,
	}, '4', {
		type = 'toggle',
		name = [[|TInterface\TargetingFrame\UI-RaidTargetingIcons:0:0:0:0:256:256:192:256:0:64|t |cff0af200]]..RAID_TARGET_4,
		desc = L["Show this raid target icon for this layout."],
		get = get,
		set = set,
	}, '5', {
		type = 'toggle',
		name = [[|TInterface\TargetingFrame\UI-RaidTargetingIcons:0:0:0:0:256:256:0:64:64:128|t |cffb2d1df]]..RAID_TARGET_5,
		desc = L["Show this raid target icon for this layout."],
		get = get,
		set = set,
	}, '6', {
		type = 'toggle',
		name = [[|TInterface\TargetingFrame\UI-RaidTargetingIcons:0:0:0:0:256:256:64:128:64:128|t |cff00b5ff]]..RAID_TARGET_6,
		desc = L["Show this raid target icon for this layout."],
		get = get,
		set = set,
	}, '7', {
		type = 'toggle',
		name = [[|TInterface\TargetingFrame\UI-RaidTargetingIcons:0:0:0:0:256:256:128:192:64:128|t |cffff3d2a]]..RAID_TARGET_7,
		desc = L["Show this raid target icon for this layout."],
		get = get,
		set = set,
	}, '8', {
		type = 'toggle',
		name = [[|TInterface\TargetingFrame\UI-RaidTargetingIcons:0:0:0:0:256:256:192:256:64:128|t |cfff9f9f9]]..RAID_TARGET_8,
		desc = L["Show this raid target icon for this layout."],
		get = get,
		set = set,
	}
end)
