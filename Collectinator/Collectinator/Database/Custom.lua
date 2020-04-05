-------------------------------------------------------------------------------
-- Custom.lua
-- Custom acquire data for all of Collectinator
-------------------------------------------------------------------------------
-- File date: 2010-07-05T19:49:20Z
-- File revision: @file-revision@
-- Project revision: @project-revision@
-- Project version: v1.0.4
-------------------------------------------------------------------------------
-- Format:
-- 	self:addLookupList(CustomDB, Rep ID, Rep Name)
-------------------------------------------------------------------------------
local MODNAME	= "Collectinator"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

--local L	= LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local BZ	= LibStub("LibBabble-Zone-3.0"):GetLookupTable()

function addon:InitCustom(DB)
	self:addLookupList(DB, 1, "World of Warcraft Trading Card Game", BZ["Booty Bay"])
	self:addLookupList(DB, 2, "Chicken Egg")
	self:addLookupList(DB, 3, "Learned from Oozing Bag, dropped by level 50 to 57 ooze & slime mobs", "Various Zones")
	self:addLookupList(DB, 4, "Bought from the Blizzard Store")
	self:addLookupList(DB, 5, "Burning Crusade Collector's Edition (EU)")
	self:addLookupList(DB, 6, "Promotional pet: Fansite contest giveaway (EU)") -- EU Contest, Pink Murloc
	self:addLookupList(DB, 7, "Promotional pet: iCoke (China)") -- Polar Bear Collar
	self:addLookupList(DB, 8, "Original Collector's Edition")
	self:addLookupList(DB, 9, "Learned randomly from Mr. Pinchy, caught via 430+ fishing nodes in Terokkar Forest.")
	self:addLookupList(DB, 10, "Burning Crusade Collector's Edition")
	self:addLookupList(DB, 11, "Wrath of The Lich King Collector's Edition")
	self:addLookupList(DB, 12, "World Wide Invitational (Korea)") -- Lucky Golden Pig
	self:addLookupList(DB, 13, "China Olypmics")
	self:addLookupList(DB, 14, "Obtained with an account bound to an authenticator.")
	self:addLookupList(DB, 15, "Take part in many Random Dungeon groups.")
	self:addLookupList(DB, 16, "Random drop from the Cracked Egg, which hatches from the Mysterious Egg.")
	self:addLookupList(DB, 17, "Arena: Earned the Vengeful Gladiator title in Season 3")
	self:addLookupList(DB, 18, "Outland daily fishing quest.")
	self:addLookupList(DB, 19, "Use an Amani Hex Stick on the frog for a chance to obtain Mojo.")
	self:addLookupList(DB, 20, "Arena: Earned the Merciless Gladiator title in Season 2")
	self:addLookupList(DB, 21, "Rewarded for doing either of the following: Participated in 200 3v3 2009 Arena Tournament games or participate in at least 50 rated Arena Pass games in the 2010 Arena Tournament")
	self:addLookupList(DB, 22, "Arena: Earned the Brutal Gladiator title in Season 4")
	self:addLookupList(DB, 23, "Original Epic Mount")
	self:addLookupList(DB, 24, "Promotional pet: Mountain Dew Game Fuel (Summer 2009).")
	self:addLookupList(DB, 25, "Arena: Earned the Deadly Gladiator title in Season 5")
	self:addLookupList(DB, 26, "Arena: Earned the Furious Gladiator title in Season 6")
	self:addLookupList(DB, 27, "Mob Drop is Horde-only.")	-- Sprite Darter Hatchling
	self:addLookupList(DB, 28, "Promotional pet: WoW/Battle.net Account Merger.")
	self:addLookupList(DB, 29, "Random drop off of trash in AQ 40.")
	self:addLookupList(DB, 30, "Arena: Earned the Gladiator title in Season 1")
	self:addLookupList(DB, 31, "Zul'Aman Timed Run.")
	self:addLookupList(DB, 32, "Arena: Earned the Relentless Gladiator title in Season 7")
	self:addLookupList(DB, 33, "Arena: Earned the Wrathful Gladiator title in Season 8")
	self:addLookupList(DB, 34, "Prepay your account by November 2009, on Taiwan servers.")
end

