local Routes = LibStub("AceAddon-3.0"):GetAddon("Routes", 1)
if not Routes then return end

local SourceName = "Cartographer"
local L = LibStub("AceLocale-3.0"):GetLocale("Routes")

------------------------------------------
-- setup
Routes.plugins[SourceName] = {}
local source = Routes.plugins[SourceName]

do
	local loaded = true
	local function IsActive() -- Can we gather data?
		local CN = (Cartographer and Cartographer:HasModule("Notes")) and Cartographer:GetModule("Notes")
		return CN and loaded
	end
	source.IsActive = IsActive

	-- stop loading if the addon is not enabled, or
	-- stop loading if there is a reason why it can't be loaded ("MISSING" or "DISABLED")
	local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(SourceName)
	if not enabled or (reason ~= nil) then
		loaded = false
		return
	end
end

------------------------------------------
-- functions

-- Cartographer comes with this library
local BZ  = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
local BZR = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()

-- XXX ugly! :(
local translate_type = {}
local function UpdateTranslationTables()
	-- See if these libraries exist
	translate_type.Herbalism = LibStub:GetLibrary("Babble-Herbs-2.2", 1)
	translate_type.Mining = LibStub:GetLibrary("Babble-Ore-2.2", 1)
	translate_type.Fishing = LibStub:GetLibrary("Babble-Fish-2.2", 1)
	local AL = LibStub:GetLibrary("AceLocale-2.2", 1)
	if AL then
		translate_type.Treasure = AL:new("Cartographer_Treasure") -- Get the AceLocale registered translation table for Treasure
	end
	translate_type.ExtractGas = LibStub("Babble-Gas-2.2", 1)
end

local amount_of = {}
local function Summarize(data, zone)
	zone = BZR[zone] or zone
	UpdateTranslationTables()

	local CN = (Cartographer and Cartographer:HasModule("Notes")) and Cartographer:GetModule("Notes")
	for db_type, db_data in pairs(CN.externalDBs) do
		-- get the babble localization for this db type
		local LN = translate_type[db_type]
		-- if this is a valid node db as specified in translate_type[]
		if LN then
			for k in pairs(amount_of) do amount_of[k] = nil end
			-- only look for data for this currentzone
			if db_data[zone] then
				-- count the unique values (structure is: location => item)
				if db_type == "Treasure" then
					for _,node in pairs(db_data[zone]) do
						amount_of[node.title] = (amount_of[node.title] or 0) + 1
					end
				else
					for _,node in pairs(db_data[zone]) do
						amount_of[node] = (amount_of[node] or 0) + 1
					end
				end
				-- XXX Localize these strings
				-- store combinations with all information we have
				for node,count in pairs(amount_of) do
					local translatednode = LN:HasTranslation(node) and LN[node] or node
					data[ ("%s;%s;%s;%s"):format(SourceName, db_type, node, count) ] = ("%s - %s (%d)"):format(L[SourceName..db_type], translatednode, count)
				end
			end
		end
	end
	return data
end
source.Summarize = Summarize

-- returns the english name, translated name for the node so we can store it was being requested
-- also returns the type of db for use with auto show/hide route
local function AppendNodes(node_list, zone, db_type, node_type)
	zone = BZR[zone] or zone

	local CN = (Cartographer and Cartographer:HasModule("Notes")) and Cartographer:GetModule("Notes")
	if CN and CN.externalDBs[db_type] then
		-- Find all of the notes
		for loc, t in pairs(CN.externalDBs[db_type][zone]) do
			-- convert coordID from Cart format to GM format
			local x, y = (loc % 10001)/10000, floor(loc / 10001)/10000
			loc = floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)

			-- And are of a selected type - store
			if db_type == "Treasure" and t.title == node_type then
				tinsert( node_list, loc )
			elseif t == node_type then
				tinsert( node_list, loc )
			end
		end
	end
	local LN = translate_type[db_type]
	local translatednode = LN:HasTranslation(node_type) and LN[node_type] or node_type -- fallback on english name if translation doesn't exist
	return node_type, translatednode, db_type
end
source.AppendNodes = AppendNodes

local function RockNoteSetEvent(namespace, event, zone, x, y, node, db_type)
	local coord = floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
	zone = BZ[zone] or zone
	Routes:InsertNode(zone, coord, node)
end

local function RockNoteDeleteEvent(namespace, event, zone, x, y, node, db_type)
	local coord = floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
	zone = BZ[zone] or zone
	Routes:DeleteNode(zone, coord, node)
end

local function Ace2NoteSetEvent(zone, x, y, node, db_type)
	local coord = floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
	zone = BZ[zone] or zone
	Routes:InsertNode(zone, coord, node)
end

local function Ace2NoteDeleteEvent(zone, x, y, node, db_type)
	local coord = floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
	zone = BZ[zone] or zone
	Routes:DeleteNode(zone, coord, node)
end

-- This is a dummy table used to embed AceEvent-2.0 or LibRockEvent-1.0 in it
-- without needing to register a new addon object (which is just a table anyway)
local callback = {}
if Cartographer.AddEventListener then -- User is using the Rock version of Cartographer
	Rock("LibRockEvent-1.0"):Embed(callback)
elseif Cartographer.RegisterEvent then
	AceLibrary("AceEvent-2.0"):embed(callback) -- this is not a typo! it is a small e!
end

local function AddCallbacks()
	if Cartographer.AddEventListener then
		callback:AddEventListener(Cartographer_Notes.name, "NoteSet", RockNoteSetEvent)
		callback:AddEventListener(Cartographer_Notes.name, "NoteDeleted", RockNoteDeleteEvent)
	elseif Cartographer.RegisterEvent then
		callback:RegisterEvent("CartographerNotes_NoteSet", Ace2NoteSetEvent)
		callback:RegisterEvent("CartographerNotes_NoteDeleted", Ace2NoteDeleteEvent)
	end
end
source.AddCallbacks = AddCallbacks

local function RemoveCallbacks()
	if Cartographer.AddEventListener then
		callback:RemoveEventListener(Cartographer_Notes.name, "NoteSet")
		callback:RemoveEventListener(Cartographer_Notes.name, "NoteDeleted")
	elseif Cartographer.RegisterEvent then
		callback:UnregisterEvent("CartographerNotes_NoteSet")
		callback:UnregisterEvent("CartographerNotes_NoteDeleted")
	end
end
source.RemoveCallbacks = RemoveCallbacks

-- vim: ts=4 noexpandtab
