#!/usr/bin/lua

--[[
	Prefix to all files if this script is run from a subdir, for example
]]
local filePrefix = "../"

local files = {
	Parrot = { "Code/Parrot.lua", },
	Parrot_CombatEvents = { "Code/CombatEvents.lua", },
	Parrot_Display = { "Code/Display.lua", },
	Parrot_ScrollAreas = { "Code/ScrollAreas.lua", },
	Parrot_Suppressions = { "Code/Suppressions.lua", },
	Parrot_TriggerConditions = { "Code/TriggerConditions.lua", },
	Parrot_Triggers = { "Code/Triggers.lua", },
	Parrot_AnimationStyles = { "Data/AnimationStyles.lua", },
	Parrot_Auras = { "Data/Auras.lua", },
	Parrot_CombatEvents_Data = { "Data/CombatEvents.lua", },
	Parrot_CombatStatus = { "Data/CombatStatus.lua", },
	Parrot_Cooldowns = { "Data/Cooldowns.lua", },
	Parrot_Loot = { "Data/Loot.lua", },
	Parrot_TriggerConditions_Data = { "Data/TriggerConditions.lua", },
}

local function saveLocales(namespace, strings)
	local file = io.open("Strings/" .. namespace .. ".lua", "w")
	for i,v in ipairs(strings) do
		file:write(string.format("L[\"%s\"] = true\n", v))
	end
	file:close()
end

local function parseFile(filename)
	local strings = {}
	local file = io.open(string.format("%s%s", filePrefix or "", filename), "r")
	assert(file, "Could not open " .. filename)
	local text = file:read("*all")

	for match in string.gmatch(text, "L%[\"(.-)\"%]") do
		strings[match] = true
	end
	return strings
end

-- extract data from specified lua files
for namespace,files in pairs(files) do
	local filename = files[1]
	local strings = {}
	for i,v in pairs(files) do
		local strings2 = parseFile(v)
		for k in pairs(strings2) do
			strings[k] = true
		end
	end
	local work = {}
	for k,v in pairs(strings) do
		table.insert(work, k)
	end
	table.sort(work)
	saveLocales(namespace, work)
end