--[[

************************************************************************

ARL-Quest.lua

Quest data for all of Ackis Recipe List

************************************************************************

File date: 2009-09-28T08:12:03Z 
File revision: 2518 
Project revision: 2695
Project version: r2696

************************************************************************

Format:

	self:addLookupList(QuestDB,NPC ID, NPC Name, NPC Location, X Coord, Y Coord, Faction)

************************************************************************

Please see http://www.wowace.com/projects/arl/for more information.

License:
	Please see LICENSE.txt

This source code is released under All Rights Reserved.

************************************************************************

]]--

local MODNAME	= "Ackis Recipe List"
local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local L			= LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local BZ		= LibStub("LibBabble-Zone-3.0"):GetLookupTable()

function addon:InitQuest(QuestDB)

	self:addLookupList(QuestDB,22,L["Goretusk Liver Pie"],BZ["Westfall"],55.77,30.92,1)
	self:addLookupList(QuestDB,38,L["Westfall Stew"],BZ["Westfall"],55.77,30.92,1)
	self:addLookupList(QuestDB,90,L["Seasoned Wolf Kabobs"],BZ["Duskwood"],73.8,43.7,1)
	self:addLookupList(QuestDB,92,L["Redridge Goulash"],BZ["Redridge Mountains"],22.7,44.0,1)
	self:addLookupList(QuestDB,93,L["Dusky Crab Cakes"],BZ["Duskwood"],73.8,43.7,1)
	self:addLookupList(QuestDB,127,L["Selling Fish"],BZ["Redridge Mountains"],27.8,47.3,1)
	self:addLookupList(QuestDB,296,L["Ormer's Revenge"],BZ["Wetlands"],38.0,49.9,1)
	self:addLookupList(QuestDB,384,L["Beer Basted Boar Ribs"],BZ["Dun Morogh"],46.8,52.5,1)
	self:addLookupList(QuestDB,385,L["Crocolisk Hunting"],BZ["Loch Modan"],81.8,61.7,1)
	self:addLookupList(QuestDB,418,L["Thelsamar Blood Sausages"],BZ["Loch Modan"],34.8,49.1,1)
	self:addLookupList(QuestDB,429,L["Wild Hearts"],BZ["Silverpine Forest"],53.5,13.5,2)
	self:addLookupList(QuestDB,471,L["Apprentice's Duties"],BZ["Wetlands"],8.6,55.7,1)
	self:addLookupList(QuestDB,498,L["The Rescue"],BZ["Hillsbrad Foothills"],63.2,20.7,2)
	self:addLookupList(QuestDB,501,L["Elixir of Pain"],BZ["Hillsbrad Foothills"],61.5,19.2,2)
	self:addLookupList(QuestDB,555,L["Soothing Turtle Bisque"],BZ["Hillsbrad Foothills"],51.8,58.7,1)
	self:addLookupList(QuestDB,564,L["Costly Menace"],BZ["Hillsbrad Foothills"],52.4,56.0,1)
	self:addLookupList(QuestDB,703,L["Barbecued Buzzard Wings"],BZ["Badlands"],42.4,52.8,0)
	self:addLookupList(QuestDB,715,L["Liquid Stone"],BZ["Badlands"],25.8,44.4,0)
	self:addLookupList(QuestDB,769,L["Kodo Hide Bag"],BZ["Thunder Bluff"],44.1,44.6,2)
	self:addLookupList(QuestDB,862,L["Dig Rat Stew"],BZ["The Barrens"],55.3,31.8,2)
	self:addLookupList(QuestDB,1487,L["Deviate Eradication"],BZ["The Barrens"],45.8,36.3,0)
	self:addLookupList(QuestDB,1559,L["Flash Bomb Recipe"],BZ["Badlands"],42.4,52.8,0)
	self:addLookupList(QuestDB,1578,L["Supplying the Front"],BZ["Ironforge"],48.5,43.0,1)
	self:addLookupList(QuestDB,1582,L["Moonglow Vest"],BZ["Darnassus"],64.3,21.9,1)
	self:addLookupList(QuestDB,1618,L["Gearing Redridge"],BZ["Ironforge"],48.5,43.0,1)
	self:addLookupList(QuestDB,2178,L["Easy Strider Living"],BZ["Darkshore"],37.7,40.7,1)
	self:addLookupList(QuestDB,2203,L["Badlands Reagent Run II"],BZ["Badlands"],2.5,46.1,2)
	self:addLookupList(QuestDB,2359,L["Klaven's Tower"],BZ["Westfall"],68.4,70.0,1)
	self:addLookupList(QuestDB,2478,L["Mission: Possible But Not Probable"],BZ["The Barrens"],55.5,5.6,2)
	self:addLookupList(QuestDB,2501,L["Badlands Reagent Run II"],BZ["Loch Modan"],37.0,49.2,1)
	self:addLookupList(QuestDB,2751,L["Barbaric Battlements"],BZ["Orgrimmar"],78.0,21.4,2)
	self:addLookupList(QuestDB,2752,L["On Iron Pauldrons"],BZ["Orgrimmar"],78.0,21.4,2)
	self:addLookupList(QuestDB,2753,L["Trampled Under Foot"],BZ["Orgrimmar"],78.0,21.4,2)
	self:addLookupList(QuestDB,2754,L["Horns of Frenzy"],BZ["Orgrimmar"],78.0,21.4,2)
	self:addLookupList(QuestDB,2755,L["Joys of Omosh"],BZ["Orgrimmar"],78.0,21.4,2)
	self:addLookupList(QuestDB,2756,L["The Old Ways"],BZ["Orgrimmar"],80.7,23.4,2)
	self:addLookupList(QuestDB,2758,L["The Origins of Smithing"],BZ["Stormwind City"],63.0,36.9,1)
	self:addLookupList(QuestDB,2761,L["Smelt On, Smelt Off"],BZ["Stranglethorn Vale"],50.6,20.5,0)
	self:addLookupList(QuestDB,2762,L["The Great Silver Deceiver"],BZ["Stranglethorn Vale"],50.6,20.5,0)
	self:addLookupList(QuestDB,2763,L["The Art of the Imbue"],BZ["Stranglethorn Vale"],50.6,20.5,0)
	self:addLookupList(QuestDB,2771,L["A Good Head On Your Shoulders"],BZ["Tanaris"],51.5,28.7,0)
	self:addLookupList(QuestDB,2772,L["The World At Your Feet"],BZ["Tanaris"],51.5,28.7,0)
	self:addLookupList(QuestDB,2773,L["The Mithril Kid"],BZ["Tanaris"],51.5,28.7,0)
	self:addLookupList(QuestDB,2848,L["Wild Leather Shoulders"],BZ["Feralas"],30.6,42.7,1)
	self:addLookupList(QuestDB,2849,L["Wild Leather Vest"],BZ["Feralas"],30.6,42.7,1)
	self:addLookupList(QuestDB,2850,L["Wild Leather Helmet"],BZ["Feralas"],30.6,42.7,1)
	self:addLookupList(QuestDB,2851,L["Wild Leather Boots"],BZ["Feralas"],30.6,42.7,1)
	self:addLookupList(QuestDB,2852,L["Wild Leather Leggings"],BZ["Feralas"],30.6,42.7,1)
	self:addLookupList(QuestDB,2853,L["Master of the Wild Leather"],BZ["Feralas"],30.6,42.7,1)
	self:addLookupList(QuestDB,2855,L["Wild Leather Shoulders"],BZ["Feralas"],74.5,42.9,2)
	self:addLookupList(QuestDB,2856,L["Wild Leather Vest"],BZ["Feralas"],74.5,42.9,2)
	self:addLookupList(QuestDB,2857,L["Wild Leather Helmet"],BZ["Feralas"],74.5,42.9,2)
	self:addLookupList(QuestDB,2858,L["Wild Leather Boots"],BZ["Feralas"],74.5,42.9,2)
	self:addLookupList(QuestDB,2859,L["Wild Leather Leggings"],BZ["Feralas"],74.5,42.9,2)
	self:addLookupList(QuestDB,2860,L["Master of the Wild Leather"],BZ["Feralas"],74.5,42.9,2)
	self:addLookupList(QuestDB,3402,L["The Undermarket"],BZ["Searing Gorge"],41.0,74.8,0)
	self:addLookupList(QuestDB,4083,L["The Spectral Chalice"],BZ["Blackrock Depths"],0,0,0)
	self:addLookupList(QuestDB,4161,L["Recipe of the Kaldorei"],BZ["Teldrassil"],57.1,61.3,1)
	self:addLookupList(QuestDB,5124,L["Fiery Plate Gauntlets"],BZ["Winterspring"],61.0,38.7,0)
	self:addLookupList(QuestDB,5127,L["The Demon Forge"],BZ["Winterspring"],63.8,73.8,0)
	self:addLookupList(QuestDB,5305,L["Sweet Serenity"],BZ["Winterspring"],61.3,37.1,0)
	self:addLookupList(QuestDB,5306,L["Snakestone of the Shadow Huntress"],BZ["Winterspring"],61.3,37.1,0)
	self:addLookupList(QuestDB,5307,L["Corruption"],BZ["Winterspring"],61.3,37.2,0)
	self:addLookupList(QuestDB,5518,L["The Gordok Ogre Suit"],BZ["Dire Maul"],0,0,0)
	self:addLookupList(QuestDB,6032,L["Sacred Cloth"],BZ["Felwood"],65.7,2.9,0)
	self:addLookupList(QuestDB,6610,L["Clamlette Surprise"],BZ["Tanaris"],52.6,28.1,0)
	self:addLookupList(QuestDB,6622,L["Triage"],BZ["Arathi Highlands"],73.4,36.8,2)
	self:addLookupList(QuestDB,6624,L["Triage"],BZ["Dustwallow Marsh"],67.7,48.9,1)
	self:addLookupList(QuestDB,7321,L["Soothing Turtle Bisque"],BZ["Hillsbrad Foothills"],62.4,19.1,2)
	self:addLookupList(QuestDB,7493,L["The Journey Has Just Begun"],BZ["Orgrimmar"],51.0,76.5,2)
	self:addLookupList(QuestDB,7497,L["The Journey Has Just Begun"],BZ["Stormwind City"],67.2,85.5,1)
	self:addLookupList(QuestDB,7604,L["A Binding Contract"],BZ["Blackrock Depths"],0,0,0)
	self:addLookupList(QuestDB,7649,L["Enchanted Thorium Platemail: Volume I"],BZ["Dire Maul"],0,0,0)
	self:addLookupList(QuestDB,7650,L["Enchanted Thorium Platemail: Volume II"],BZ["Dire Maul"],0,0,0)
	self:addLookupList(QuestDB,7651,L["Enchanted Thorium Platemail: Volume III"],BZ["Dire Maul"],0,0,0)
	self:addLookupList(QuestDB,7653,L["Imperial Plate Belt"],BZ["Tanaris"],51.4,28.7,0)
	self:addLookupList(QuestDB,7654,L["Imperial Plate Boots"],BZ["Tanaris"],51.4,28.7,0)
	self:addLookupList(QuestDB,7655,L["Imperial Plate Bracer"],BZ["Tanaris"],51.4,28.7,0)
	self:addLookupList(QuestDB,7656,L["Imperial Plate Chest"],BZ["Tanaris"],51.4,28.7,0)
	self:addLookupList(QuestDB,7657,L["Imperial Plate Helm"],BZ["Tanaris"],51.4,28.7,0)
	self:addLookupList(QuestDB,7658,L["Imperial Plate Leggings"],BZ["Tanaris"],51.4,28.7,0)
	self:addLookupList(QuestDB,7659,L["Imperial Plate Shoulders"],BZ["Tanaris"],51.4,28.7,0)
	self:addLookupList(QuestDB,8313,L["Sharing the Knowledge"],BZ["Silithus"],38.0,45.3,0)
	self:addLookupList(QuestDB,8323,L["True Believers"],BZ["Silithus"],67.1,69.7,0)
	self:addLookupList(QuestDB,8586,L["Dirge's Kickin' Chimaerok Chops"],BZ["Tanaris"],52.6,28.1,0)
	self:addLookupList(QuestDB,8798,L["A Yeti of Your Own"],BZ["Winterspring"],60.9,37.7,0)
	self:addLookupList(QuestDB,9171,L["Culinary Crunch"],BZ["Ghostlands"],48.3,30.9,2)
	self:addLookupList(QuestDB,9249,L["40 Tickets - Schematic: Steam Tonk Controller"],BZ["Darkmoon Faire"],0,0,0)
	self:addLookupList(QuestDB,9356,L["Smooth as Butter"],BZ["Hellfire Peninsula"],49.2,74.8,0)
	self:addLookupList(QuestDB,9454,L["The Great Moongraze Hunt"],BZ["Azuremyst Isle"],49.8,51.9,1)
	self:addLookupList(QuestDB,9635,L["The Zapthrottle Mote Extractor!"],BZ["Zangarmarsh"],33.7,50.2,2)
	self:addLookupList(QuestDB,9636,L["The Zapthrottle Mote Extractor!"],BZ["Zangarmarsh"],68.6,50.2,1)
	self:addLookupList(QuestDB,10860,L["Mok'Nathal Treats"],BZ["Blade's Edge Mountains"],76.1,60.3,2)
	self:addLookupList(QuestDB,12889,L["The Prototype Console"],BZ["The Storm Peaks"],37.7,46.5,0)
	self:addLookupList(QuestDB,13571,L["Fletcher's Lost and Found"],BZ["Dalaran"],0,0,0)
	self:addLookupList(QuestDB,13087,L["Northern Cooking"],BZ["Howling Fjord"],58.2,62.1,1)
	self:addLookupList(QuestDB,13088,L["Northern Cooking"],BZ["Borean Tundra"],57.9,71.5,1)
	self:addLookupList(QuestDB,13089,L["Northern Cooking"],BZ["Howling Fjord"],78.7,29.5,2)
	self:addLookupList(QuestDB,13090,L["Northern Cooking"],BZ["Borean Tundra"],42.0,54.2,2)
	self:addLookupList(QuestDB,14151,L["Cardinal Ruby"],BZ["Dalaran"],42.5,32.1,0)

end
