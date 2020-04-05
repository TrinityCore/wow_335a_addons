--[[
=====================================================================================================
	Siege of Orgrimmar Mobs and Spells Ids for Details
=====================================================================================================
--]]

local Loc = LibStub ("AceLocale-3.0"):GetLocale ("Details_RaidInfo-VoA")

local _details = 		_G._details

local voa = {

	id = 533,
	ej_id = 533,
	
	name = Loc ["STRING_RAID_NAME"],
	
	icons = "Interface\\AddOns\\Details_RaidInfo-VoA\\images\\boss_faces",
	
	icon = "Interface\\AddOns\\Details_RaidInfo-VoA\\images\\icon256x128",
	
	is_raid = true,

	backgroundFile = {file = [[Interface\AddOns\Details_RaidInfo-VoA\images\icon256x128]], coords = {0, 1, 256/1024, 840/1024}},
	backgroundEJ = [[Interface\EncounterJournal\UI-EJ-LOREBG-SiegeofOrgrimmar]],
	
	boss_names = { 
			"Archavon the Stone Watcher",
			"Emalon the Storm Watcher",
			"Koralon the Flame Watcher",
			"Toravon the Ice Watcher",
	},
	
	find_boss_encounter = function()
		--> find galakras (this encounter doesn't have a boss frames before galakras comes into in play)
		if (_details.table_current and _details.table_current[1] and _details.table_current[1]._ActorTable) then
			for _, damage_actor in ipairs (_details.table_current[1]._ActorTable) do
				local serial = tonumber (damage_actor.serial:sub (9, 12), 16)
				if (serial == 73909) then --Archmage Aethas Sunreaver
					return 5 --> galakras boss index
				end
			end
		end
	end,
	
	encounter_ids = {
		--> Ids by Index
			852, 849, 866, 867,
		-- Vale of Eternal Sorrows
			[852] = 1, -- Flame Leviathan
			[849] = 2, -- Ignis the Furnace Master
			[866] = 3, -- Norushen
			[867] = 4, -- Sha of Pride
	},
	
	encounter_ids2 = {
		-- Vale of Eternal Sorrows
			[1602] = 1, -- Flame Leviathan
			[1598] = 2, -- Ignis the Furnace Master
			[1624] = 3, -- Norushen
			[1604] = 4, -- Sha of Pride
	},
	
	boss_ids = {
		-- The Siege of VoA
			[31125]	= 1,	-- Archavon
			[33993]	= 2,	-- Emalon
			[35013]	= 3,	-- Koralon
			[38433]	= 4,	-- Toravon
	},
	
	trash_ids = {
		-- Flame Leviathan
		[32353] = true, -- Archavon
		[34015] = true, -- Tempest
		[35143] = true, -- Flame
		[38482] = true, -- Frost
	},
	
	encounters = {
	
------------> Archavon ------------------------------------------------------------------------------
		[1] = {
			
			boss =	"Archavon the Stone Watcher",
			portrait = [[Interface\AddOns\Details_RaidInfo-VoA\images\archavon]],

			spell_mechanics =	{
						[58678] = {0x1}, --> Rock Shards
						[58960] = {0x40}, --> Leap 10
						[60894] = {0x40}, -->  Leap 25
						[58663] = {0x100}, --> Stomp 10
						[60880] = {0x100}, --> Stomp 25
						[58666] = {0x1}, --> Impale 10
						[60882] = {0x1}, --> Impale 25
					},
			
			phases = {
				--> phase 1 - Tears of the Vale
				{
					spells = {
							58678, --> Thorim's Hammer
							58960, --> Hodir's Fury
							60894, --> Mimiron's Inferno
							58663, --> Flame Vents
							60880, --> Missile Barrage
							58666, --> Battering Ram
							60882, --> Pursued
						},
						
					adds = {
						31125, --> Archavon
					}
				},
			}
		}, --> end of Immerseus 
		
		
------------> Emalon ------------------------------------------------------------------------------
		[2] = {

			boss =	"Emalon the Storm Watcher",
			portrait = [[Interface\AddOns\Details_RaidInfo-VoA\images\emalon]],
			combat_end = {1, 33993},
			spell_mechanics =	{
						[64217] = {0x1000}, --> Overcharged
						[64219] = {0x200}, --> Overcharged Blast
						[64218] = {0x200}, --> Overcharge
						[64213] = {0x2000}, --> Chain Lightning
						[64215] = {0x2000}, --> Chain Lightning
						[64216] = {0x80}, --> Lightning Nova
						[65279] = {0x80}, --> Lightning Nova
					},
		

		
			continuo = {
						64217, --> Flame Jets (10)
						64219, --> Flame Jets (25)
						64218, --> Scorch (10)
						64213, --> Scorch (25)
						64215, --> Activate Construct
						64216, --> Brittle (10)
						65279, --> Brittle (25)
			},
		
			phases = {
				{
					--> phase 1 - 
					spells = {
							--> no spell, is all continuo
						},
					adds = 	{
							33993, -- Emalon
							33998, -- Tempest Minion
						}
				}			
			} 
	
		}, --> end of Ignis the Furnace Master
		
------------> Koralon ------------------------------------------------------------------------------

		[3] = {
			boss =	"Koralon the Flame Watcher",
			portrait = [[Interface\AddOns\Details_RaidInfo-VoA\images\koralon]],
			
			combat_end = {1, 35013},
			encounter_start = {delay = 0},
			equalize = true,
			
			spell_mechanics =	{
						[67329] = {0x1}, --> Burning Breath
						[67332] = {0x8}, --> Flaming Cinder
						[67333] = {0x200}, --> Meteor Fists
			},
			
			continuo = {
						67333, --> Meteor Fists
						67329, -->  Devouring Flame (25)
						67332, --> Fireball
			},
			
			phases = {
				{ -- flying phase
					adds = 	{
							35013, --> Koralon
					},
					spells = {
					},
				},
			}

		}, --> end of Razorscale
		
------------> Toravon ------------------------------------------------------------------------------	
		[4] = {
			boss =	"Toravon the Ice Watcher",
			portrait = [[Interface\AddOns\Details_RaidInfo-VoA\images\toravon]],
			
			combat_end = {1, 38433},
			
			spell_mechanics = {
				[63024] = {0x10}, --> Freezing Ground
				[64234] = {0x1000}, --> Frozen Orb
				[63018] = {0x1, 0x10000}, --> Whiteout
				[65121] = {0x200}, --> Frozen Mallet
				[62776] = {0x1000}, --> Frozen Orb Damage
				[72120] = {0x1}, --> Frostbite
			},
			
			continuo = {
				63024, --> Swelling Pride
				64234, --> Reaching Attack 
				63018, --> Wounded Pride (not a damage)
				65121, --> Mark of Arrogance
				62776, --> Bursting Pride
				72120, --> Frostbite
			},
			
			phases = { 
				{ --> phase 1
					adds = {
						38433, --> XT-002 Deconstructor
						38456, --> Frozen Orb
						38461, --> Frozen Orb Stalker
						} 
				}
			}
		}, --> end of XT-002 Deconstructor
				
	} --> End SoO
}

--[[
				[0x1] = "|cFF00FF00"..Loc ["STRING_HEAL"].."|r", 
				[0x2] = "|cFF710000"..Loc ["STRING_LOWDPS"].."|r", 
				[0x4] = "|cFF057100"..Loc ["STRING_LOWHEAL"].."|r", 
				[0x8] = "|cFFd3acff"..Loc ["STRING_VOIDZONE"].."|r", 
				[0x10] = "|cFFbce3ff"..Loc ["STRING_DISPELL"].."|r", 
				[0x20] = "|cFFffdc72"..Loc ["STRING_INTERRUPT"].."|r", 
				[0x40] = "|cFFd9b77c"..Loc ["STRING_POSITIONING"].."|r", 
				[0x80] = "|cFFd7ff36"..Loc ["STRING_RUNAWAY"].."|r", 
				[0x100] = "|cFF9a7540"..Loc ["STRING_TANKSWITCH"] .."|r", 
				[0x200] = "|cFFff7800"..Loc ["STRING_MECHANIC"].."|r", 
				[0x400] = "|cFFbebebe"..Loc ["STRING_CROWDCONTROL"].."|r", 
				[0x800] = "|cFF6e4d13"..Loc ["STRING_TANKCOOLDOWN"].."|r", 
				[0x1000] = "|cFFffff00"..Loc ["STRING_KILLADD"].."|r", 
				[0x2000] = "|cFFff9999"..Loc ["STRING_SPREADOUT"].."|r", 
				[0x4000] = "|cFFffff99"..Loc ["STRING_STOPCAST"].."|r",
				[0x8000] = "|cFFffff99"..Loc ["STRING_FACING"].."|r",
				[0x10000] = "|cFFffff99"..Loc ["STRING_STACK"].."|r",
--]]

_details:InstallEncounter (voa)
