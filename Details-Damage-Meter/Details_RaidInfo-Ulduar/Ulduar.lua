--[[
=====================================================================================================
	Siege of Orgrimmar Mobs and Spells Ids for Details
=====================================================================================================
--]]

local Loc = LibStub ("AceLocale-3.0"):GetLocale ("Details_RaidInfo-Ulduar")

local _details = 		_G._details

local ulduar = {

	id = 530,
	ej_id = 530,
	
	name = Loc ["STRING_RAID_NAME"],
	
	icons = "Interface\\AddOns\\Details_RaidInfo-Ulduar\\images\\boss_faces",
	
	icon = "Interface\\LFGFrame\\UI-LFG-BACKGROUND-Ulduar",
	
	is_raid = true,

	backgroundFile = {file = [[Interface\LFGFrame\UI-LFG-BACKGROUND-Ulduar]], coords = {0, 1, 256/1024, 840/1024}},
	backgroundEJ = [[Interface\EncounterJournal\UI-EJ-LOREBG-SiegeofOrgrimmar]],
	
	boss_names = { 
		-- The Siege of Ulduar
			"Flame Leviathan",
			"Ignis the Furnace Master",
			"Razorscale",
			"XT-002 Deconstructor",
		-- The Antechamber of Ulduar
			"The Assembly of Iron",
			"Kologarn",
			"Auriaya",
		-- The Keepers of Ulduar
			"Hodir",
			"Thorim",
			"Freya",
			"Mimiron",
		-- The Descent into Madness
			"General Vezax",
			"Yogg-Saron",
		-- Supermassive
			"Algalon the Observer"
	},
	
	find_boss_encounter = function()
		--> find Assembly of Iron (this encounter doesn't have a boss frames before Assembly of Iron comes into in play)
		if (_details.table_current and _details.table_current[1] and _details.table_current[1]._ActorTable) then
			for _, damage_actor in ipairs (_details.table_current[1]._ActorTable) do
				local serial = tonumber (damage_actor.serial:sub (9, 12), 16)
				if (serial == 73909) then --Archmage Aethas Sunreaver
					return 5 --> Assembly of Iron boss index
				end
			end
		end
	end,
	
	encounter_ids = {
		--> Ids by Index
			852, 849, 866, 867, 881, 864, 856, 850, 846, 870, 851, 865, 853, 869,
		-- The Siege of Ulduar
			[852] = 1, -- Flame Leviathan
			[849] = 2, -- Ignis the Furnace Master
			[866] = 3, -- Razorscale
			[867] = 4, -- XT-002 Deconstructor
		-- The Antechamber of Ulduar
			[881] = 5, -- Assembly of Iron
			[864] = 6, -- Kologarn
			[856] = 7, -- Auriaya
		-- The Keepers of Ulduar
			[850] = 8, -- Hodir
			[846] = 9, -- Thorim
			[870] = 10, -- Freya
			[851] = 11, -- Mimiron
		-- The Descent Into Madness
			[865] = 12, -- General Vezax
			[853] = 13, -- Yogg-Saron
		-- Supermassive
			[869] = 14, -- Algalon
	},
	
	encounter_ids2 = {
		-- The Siege of Ulduar
			[1602] = 1, -- Flame Leviathan
			[1598] = 2, -- Ignis the Furnace Master
			[1624] = 3, -- Razorscale
			[1604] = 4, -- XT-002 Deconstructor
		-- The Antechamber of Ulduar
			[1622] = 5, -- Assembly of Iron
			[1600] = 6, -- Kologarn
			[1606] = 7, -- Auriaya
			[1603] = 8, -- Hodir
		-- The Keepers of Ulduar
			[1595] = 9, -- Thorim
			[1594] = 10, -- Freya
			[1599] = 11, -- Mimiron
		-- The Descent Into Madness
			[1601] = 12, -- General Vezax
			[1593] = 13, -- Yogg-Saron
			[1623] = 14, -- Algalon
	},
	
	boss_ids = {
		-- The Siege of Ulduar
			[33113]	= 1,	-- Flame Leviathan
			[33118]	= 2,	-- Ignis the Furnace Master
			[33186]	= 3,	-- Razorscale
			[33293]	= 4,	-- XT-002 Deconstructor
		
		-- The Antechamber of Ulduar
			[32867]	= 5,	-- Assembly of Iron
			[32927]	= 5,	-- Assembly of Iron
			[32857]	= 5,	-- Assembly of Iron
			[32930]	= 6,	-- Kologarn
			[33515]	= 7,	-- Auriaya
		
		-- The Keepers of Ulduar
			[32845]	= 8,	-- Hodir
			[32865]	= 9, -- Thorim
			[32906]	= 10, -- Freya
			[33432]	= 11, -- Mimiron
		
		-- The Descent Into Madness
			[33271]	= 12, -- General Vezax
			[33288]	= 13, -- Yogg-Saron
			[32871]	= 14, -- Algalon
	},
	
	trash_ids = {
		-- Flame Leviathan
		[34164] = true, -- Mechagnome Battletank
		[34234] = true, -- Runeforged Sentry
		[33572] = true, -- Steelforged Defender
		[33237] = true, -- Ulduar Colossus
		
		-- Razorscale
		[72655] = true, --Fragment of Pride
		[72658] = true, --Amalmated Hubris
		[72662] = true, --Vanity
		[72663] = true, --Arrogance
		[72661] = true, --Zeal
		
		--XT-002 Deconstructor
		[72791] = true, --lingering corruption
		
		--Assembly of Iron
		--[72367] = true, --dragonmaw tidal shaman
		--[72354] = true, --dragonmaw bonecrusher
		[72365] = true, --dragonmaw canoner
		[72350] = true, --dragonmaw elite grunt
		--[72351] = true, --dragonmaw flamebarer
		
		--> shamans
		[72412] = true, -- korkron grunt
		[72150] = true, -- kro kron shadowmage
		[72451] = true, --
		[72455] = true, --
		[72490] = true, --overseer mojka
		[72434] = true, --tresure guard
		[72421] = true, --korkron overseer
		[72452] = true, --dire wolf
		[72496] = true, --overseer thathung
		[72562] = true, --poison bolt toten
		
		--> nazgrim
		[72131] = true, -- blind blade master
		[72191] = true, -- overlord runthak
		[72194] = true, -- hellscreen demolisher
		[72564] = true, -- doom lord
		[71771] = true, -- korkron arcweaver
		[71772] = true, -- korkron assassin
		[71773] = true, -- krokron warshaman
		[71770] = true, -- krokron iron blade
		--[71715] = true, -- orgrimmar faithful -- also is used in nazgrim encounter
		
		--> Thorim
		[72728] = true, --korkron blood axe
		[72784] = true, --korkron gunner
		[72903] = true, --korkron siegemaster
		[72744] = true, --korkron skullspliter
		[72768] = true, --korkron warwolf
		[72770] = true, --korkron darkfarseer
		
		--> Freya
		[73904] = true, --korkron iron sentinel
		[73742] = true, --thresher turret
		[73767] = true, --korkron shrederer
		[73775] = true, --war master kragg
		[73152] = true, --storeroom guard
		
		--> blackfuse
		[73539] = true, --korkron den mother
		[73541] = true, --korkron wolf puppy
		[73194] = true, --korkron iron scorpion
		--
		[72981] = true, --aggron
		[72964] = true, --gorodan
		[72986] = true, --shanna sparkfizz
		[73091] = true, --blackfuse sellsword
		[73095] = true, --blackfuse enginer
		
		--> thok
		--73195 --krokon jailer
		[73188] = true, --captive cave bat
		[73184] = true, --starved yeti
		[73185] = true, --enraged mushan beast
		[73223] = true, --pterrodax
		
		--> paragons
		[72954] = true, --korthik guard
		[72929] = true, --srathik amber master
		[73012] = true, --klaxxi skirmisher
		[72927] = true, --kovok

		--> garrosh
		[73414] = true, --korkron reaper
		[73452] = true, --harbinger of y'shaarj
		[73415] = true, --ichor of y'shaarj
		
		
		
	},
	
	encounters = {
	
------------> Flame Leviathan ------------------------------------------------------------------------------
		[1] = {
			
			boss =	"Flame Leviathan",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\leviathan]],

			spell_mechanics =	{
						[62911] = {0x8, 0x40}, --> Thorim's Hammer
						[62533] = {0x8, 0x40}, --> Hodir's Fury
						[62909] = {0x8, 0x40}, -->  Mimiron's Inferno
						[62396] = {0x20}, --> Flame Vents
						[62400] = {0x2}, --> Missile Barrage
						[62376] = {0x80}, --> Battering Ram
						[62374] = {0x80}, --> Pursued
					},
			
			phases = {
				--> phase 1 - Tears of the Vale
				{
					spells = {
							62911, --> Thorim's Hammer
							62533, --> Hodir's Fury
							62909, --> Mimiron's Inferno
							62396, --> Flame Vents
							62400, --> Missile Barrage
							62376, --> Battering Ram
							62374, --> Pursued
						},
						
					adds = {
						33113, --> Flame Leviathan
						34275, --> Ward of Life
						33387, --> Writhing Lasher
						33142, --> Leviathan Defense Turret
						33365, --> Thorim's hammer
						33367, --> Freya's Ward
						33370, --> Mimiron's Inferno
						33212, --> Hodir's Fury
					}
				},
				--> phase 2 - Split
				--[[{
					spells = {
							143459, --> Sha Residue (speed mod over players near sha puddle, trigger on death)
							143540, --> Congealing (speed mod over contaminated puddle)
							143524, --> Purified Residue (full health trigger for contaminated puddle)
							143498, --> Erupting Sha
							143460, --> Sha Pool
							143286, --> Seeping Sha
							143297, --> Sha Splash
							145377, --> Erupting Wate
							143460 --> Sha Pool (H)
						},
						
					adds = {
						71603, --> Sha Puddle
						71604, --> Contaminated Puddle
						71642, --> Congealed Sha
					}
				} ]]--
			}
		}, --> end of Immerseus 
		
		
------------> Ignis the Furnace Master ------------------------------------------------------------------------------
		[2] = {

			boss =	"Ignis the Furnace Master",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\ignis]],

			--[[combat_end = {2, {	71479, -- He Softfoot
							71480, -- Sun Tenderheart
							71475, -- Rook Stonetoe
						}}, ]]
			
			spell_mechanics =	{
						[62680] = {0x4000}, --> Flame Jets (10)
						[63472] = {0x4000}, --> Flame Jets (25)
						[62546] = {0x8}, --> Scorch (10)
						[63474] = {0x8}, --> Scorch (25)
						[62488] = {}, --> Activate Construct
						[62382] = {0x1000}, --> Brittle (10)
						[67114] = {0x1000}, --> Brittle (25)
						[62717] = {0x1}, --> Slag Pot (10)
						[63477] = {0x1}, --> Slag Pot (25)
						
					},
		

		
			continuo = {
						62680, --> Flame Jets (10)
						63472, --> Flame Jets (25)
						62546, --> Scorch (10)
						63474, --> Scorch (25)
						62488, --> Activate Construct
						62382, --> Brittle (10)
						67114, --> Brittle (25)
						62717, --> Slag Pot (10)
						63477, --> Slag Pot (25)
			},
		
			phases = {
				{
					--> phase 1 - 
					spells = {
							--> no spell, is all continuo
						},
					adds = 	{
							33118, -- Ignis the Furnace Master
							33121, -- Iron Construct
						}
				}			
			} 
	
		}, --> end of Ignis the Furnace Master
		
------------> Razorscale ------------------------------------------------------------------------------

		[3] = {
			boss =	"Razorscale",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\razorscale]],
			
			combat_end = {1, 33186},
			encounter_start = {delay = 0},
			equalize = true,
			
			spell_mechanics =	{
						[64709] = {0x8}, --> Devouring Flame (10)
						[64734] = {0x8}, --> Devouring Flame (25)
						[63317] = {0x40}, --> Flame Breath (10)
						[64021] = {0x40}, --> Flame Breath (25)
						[63815] = {0x1}, --> Fireball
						[64771] = {0x10000, 0x100}, --> Fuse Armor
						[51876] = {0x2}, --> Stormstrike
						[63808] = {0x40}, --> Whirlwind
						[63809] = {0x2}, --> Lightning Bolt
						[64758] = {0x2}, --> Chain Lightning
			},
			
			continuo = {
						64709, --> Devouring Flame (10)
						64734, -->  Devouring Flame (25)
						63815, --> Fireball
						63317, -->  Flame Breath (10)
						64021, -->  Flame Breath (25)
			},
			
			phases = {
				{ -- flying phase
					adds = 	{
							33186, --> Razorscale
							
							33846, --> Dark Rune Sentinel
							33388, --> Dark Rune Guardian
							33453, --> Dark Rune Watcher
					},
					spells = {
						51876, --> Stormstrike
						63808, --> Whirlwind
						63809, --> Lightning Bolt
						64758, --> Chain Lightning
					},
				},
				{ -- grounded phase
					adds = {
						33186, --> Razorscale
					},
					spells = {
						64771, --> Fuse Armor
					},
				}
			}

		}, --> end of Razorscale
		
------------> XT-002 Deconstructor ------------------------------------------------------------------------------	
		[4] = {
			boss =	"XT-002 Deconstructor",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\xt]],
			
			combat_end = {1, 33293},
			
			spell_mechanics = {
				[63024] = {0x200}, --> Gravity Bomb
				[64234] = {0x200}, --> Gravity Bomb
				[63018] = {0x1}, --> Searing Light
				[65121] = {0x1}, --> Searing Light
				[62776] = {0x1}, --> Tympanic Tantrum
				[62834] = {0x40}, --> Boom
				[8374] = {0x4}, --> Arcing Smash
				[5568] = {0x4}, --> Trample
				[10966] = {0x4}, --> Uppercut
				[46262] = {0x8, 0x1}, --> Void Zone
				[64227] = {0x4}, --> Spark Damage
				[64236] = {0x4}, --> Spark Damage
			},
			
			continuo = {
				63024, --> Swelling Pride
				64234, --> Reaching Attack 
				63018, --> Wounded Pride (not a damage)
				65121, --> Mark of Arrogance
				62776, --> Bursting Pride
				62834, --> Projection
				8374, --> Mark of Arrogance
				5568, --> Bursting Pride
				10966, --> Projection
				46262, --> Mark of Arrogance
				64227, --> Bursting Pride
				64236, --> Projection
			},
			
			phases = { 
				{ --> phase 1
					adds = {
						33293, --> XT-002 Deconstructor
						34004, --> Life Spark
						33329, --> Heart
						33343, --> Scrapbot
						33344, --> Pummeler
						33346, --> Boombot
						} 
				}
			}
		}, --> end of XT-002 Deconstructor
		
------------> Assembly of Iron ------------------------------------------------------------------------------	
		[5] = {
			boss =	"The Iron Council",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\ironcouncil]],

			combat_end = {2, {
						32867, --
						32927, --
						32857, --
						}},
			
			spell_mechanics = {
			
				[61890] = {0x1, 0x100}, -- Poison-Tipped Blades (Korgra the Snake)
				[63498] = {0x8}, -- Poison Cloud (Korgra the Snake)
				[61903] = {0x200}, -- Curse of Venom (Korgra the Snake)
				[63493] = {0x1}, -- Venom Bolt Volley (Korgra the Snake)
				[63495] = {0x40}, -- Arcing Smash (Lieutenant Krugruk)
				[64637] = {0x200}, -- Curse of Venom (Korgra the Snake)
				[61888] = {0x1}, -- Venom Bolt Volley (Korgra the Snake)
				
				[62274] = {0x1, 0x100}, -- Poison-Tipped Blades (Korgra the Snake)
				[63489] = {0x8}, -- Poison Cloud (Korgra the Snake)
				[61973] = {0x200}, -- Curse of Venom (Korgra the Snake)
				[62269] = {0x1}, -- Venom Bolt Volley (Korgra the Snake)
				[63490] = {0x40}, -- Arcing Smash (Lieutenant Krugruk)
				[62054] = {0x200}, -- Curse of Venom (Korgra the Snake)
				[63491] = {0x1}, -- Venom Bolt Volley (Korgra the Snake)
				
				[61879] = {0x1, 0x100}, -- Poison-Tipped Blades (Korgra the Snake)
				[63479] = {0x8}, -- Poison Cloud (Korgra the Snake)
				[61869] = {0x200}, -- Curse of Venom (Korgra the Snake)
				[63481] = {0x1}, -- Venom Bolt Volley (Korgra the Snake)
				[61915] = {0x40}, -- Arcing Smash (Lieutenant Krugruk)
				[63483] = {0x200}, -- Curse of Venom (Korgra the Snake)
				[61887] = {0x1}, -- Venom Bolt Volley (Korgra the Snake)
				[63486] = {0x1, 0x100}, -- Poison-Tipped Blades (Korgra the Snake)
			},			
			continuo = {
				-- Steelbreaker
				61890, --> High Voltage (10)
				63498, -->  High Voltage (25)
				61903, -->  Fusion Punch (10)
				63493, -->  Fusion Punch (25)
				61911, -->  Static Disruption (10)
				63495, -->  Static Disruption (25)
				64637, -->  Overwhelming Power (10)
				61888, -->  Overwhelming Power (25)				
				-- Runemaster Molgeim
				62274, --> Shield of Runes (10)
				63489, -->  Shield of Runes (25)
				61973, -->  Rune of Power
				62269, -->  Rune of Death (10)
				63490, -->  Rune of Death (25)
				62054, -->  Lightning Blast	(10)
				63491, -->  Lightning Blast (25)
				-- Stormcaller Brundir
				61879, --> SPELL_CHAIN_LIGHTNING_10
				63479, -->  SPELL_CHAIN_LIGHTNING_25
				61869, -->  SPELL_OVERLOAD_10
				63481, -->  SPELL_OVERLOAD_25
				61915, -->  SPELL_LIGHTNING_WHIRL_10
				63483, -->  SPELL_LIGHTNING_WHIRL_25
				61887, -->  SPELL_LIGHTNING_TENDRILS_10
				63486, -->  SPELL_LIGHTNING_TENDRILS_25
			},
			
			phases = { 
				{ --> phase 1: Bring Her Down!
					adds = {
							32867, --Steelbreaker
							32927, --Runemaster Molgeim
							32857, --Stormcaller Brundir
							32958, --Lightning Elemental
						},
					spells = {							
						}
				},
			}
		}, --> end of Assembly of Iron
		
------------> Kologarn ------------------------------------------------------------------------------	
		[6] = {
			boss =	"Kologarn",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\kologarn]],
			combat_end = {1, 32930},
			
			spell_mechanics = {
						[144464] = {0x100}, --> Flame Vents
						[144467] = {0x100, 0x1}, -->  Ignite Armor
						[144791] = {0x1, 0x200, 0x40}, -->   Engulfed Explosion
						[144218] = {0x40}, --> Borer Drill
						[144459] = {0x1}, --> Laser Burn
						--[144439] = {}, -->Ricochet
						[144483] = {0x1}, --> Seismic Activity
						[144484] = {0x1}, --> Seismic Activity
						[144485] = {0x1, 0x40}, --> Shock Pulse 
						[144154] = {0x2000}, --> Demolisher Cannons 
						[144316] = {0x2000}, --> Mortar Blast
						[144918] = {0x40, 0x80}, --> Cutter Laser
						[144498] = {0x8, 0x200}, --> Explosive Tar 
						[144327] = {}, --> Ricochet 
						[144919] = {}, --> Tar Explosion
			},
			
			continuo = {
	63356, -- SPELL_OVERHEAD_SMASH_10				=
	64003, -- SPELL_OVERHEAD_SMASH_25				=
	63573, -- SPELL_ONEARMED_OVERHEAD_SMASH_10	=
	64006, -- SPELL_ONEARMED_OVERHEAD_SMASH_25	=
	62030, -- SPELL_PETRIFYING_BREATH_10			=
	63980, -- SPELL_PETRIFYING_BREATH_25			=
	63716, -- SPELL_STONE_SHOUT_10				=
	64005, -- SPELL_STONE_SHOUT_25				=

	63347, -- SPELL_FOCUSED_EYEBEAM_10			=
	63977, -- SPELL_FOCUSED_EYEBEAM_25			=
	63676, -- SPELL_FOCUSED_EYEBEAM_RIGHT			= -- NPC -> KOLOGARN
	63352, -- SPELL_FOCUSED_EYEBEAM_LEFT			= -- KOLOGARN -> NPC

	63629, -- SPELL_ARM_DEAD_10					=
	63979, -- SPELL_ARM_DEAD_25					=
	63821, -- SPELL_RUBBLE_FALL_10				=
	64001, -- SPELL_RUBBLE_FALL_25				=
	64753, -- SPELL_ARM_RESPAWN_VISUAL			=

	63766, -- SPELL_ARM_SWEEP_10					=
	63983, -- SPELL_ARM_SWEEP_25					=

	62166, -- SPELL_STONE_GRIP_10					=
	63981, -- SPELL_STONE_GRIP_25					=
	62056, -- SPELL_RIDE_RIGHT_ARM_10				=
	63985, -- SPELL_RIDE_RIGHT_ARM_25				=

	63818, -- SPELL_RUBBLE_ATTACK_10				=
	63978, -- SPELL_RUBBLE_ATTACK_25				=
			},
			
			phases = { 
				{ --> phase 1: Pressing the Attack: Assault Mode
					adds = {
						32930, --> Kologarn
						32934, --> Right Arm
						32933, --> Left Arm
						33768, --> Rubble
					},
					spells = {
					}
				},
			},
			
		}, --> end of Kologarn
		
------------> Auriaya ------------------------------------------------------------------------------	
		[7] = {
			boss =	"Auriaya",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\auriaya]],
			combat_end = {1, 33515},

			spell_mechanics = {
				[144303] = {0x1}, --Swipe
			},
			
			continuo = {
				64386, -- SPELL_TERRIFYING_SCREECH			=
				64389, -- SPELL_SENTINEL_BLAST_10				=
				64678, -- SPELL_SENTINEL_BLAST_25				=
				64422, -- SPELL_SONIC_SCREECH_10				=
				64688, -- SPELL_SONIC_SCREECH_25				=
				64396, -- SPELL_GUARDIAN_SWARM				=
				47008, -- SPELL_ENRAGE						=
				64449, -- SPELL_ACTIVATE_FERAL_DEFENDER		=

				64666, -- SPELL_SAVAGE_POUNCE_10				=
				64374, -- SPELL_SAVAGE_POUNCE_25				=
				64375, -- SPELL_RIP_FLESH_10					=
				64667, -- SPELL_RIP_FLESH_25					=
				64369, -- SPELL_STRENGTH_OF_THE_PACK			=

				64455, -- SPELL_FERAL_ESSENCE					=
				64478, -- SPELL_FERAL_POUNCE_10				=
				64669, -- SPELL_FERAL_POUNCE_25				=
				64496, -- SPELL_FERAL_RUSH_10					=
				64674, -- SPELL_FERAL_RUSH_25					=
				64458, -- SPELL_SEEPING_FERAL_ESSENCE_10		=
				64676, -- SPELL_SEEPING_FERAL_ESSENCE_25		=
			},
			
			phases = { 
				{ --> phase 1: 
					adds = {
						33515, --> Earthbreaker Haromm
						34035, --> Feral Defender
						34014, --> Sanctum Sentry
					},
					spells = {
						--> 
					}
				},
			},
			
		}, --> end of Auriaya
		
------------> Hodir ------------------------------------------------------------------------------	
		[8] = {
			boss =	"Hodir",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\hodir]],

			combat_end = {1, 32845},
			
			spell_mechanics = {
				[143494] = {0x100}, --Sundering Blow
			},
			
			continuo = {
				62038, -- SPELL_BITING_COLD_BOSS_AURA			=
				62039, -- SPELL_BITING_COLD_PLAYER_AURA		=
				62188, -- SPELL_BITING_COLD_DAMAGE			=

				62469, -- SPELL_FREEZE						=

				61968, -- SPELL_FLASH_FREEZE_CAST				=
				62226, -- SPELL_FLASH_FREEZE_INSTAKILL		=
				61969, -- SPELL_FLASH_FREEZE_TRAPPED_PLAYER	=
				61990, -- SPELL_FLASH_FREEZE_TRAPPED_NPC		=
				62148, -- SPELL_FLASH_FREEZE_VISUAL			=
				65705, -- SPELL_SAFE_AREA						=
				62464, -- SPELL_SAFE_AREA_TRIGGERED			=
				
				62227, -- SPELL_ICICLE_BOSS_AURA				=
				63545, -- SPELL_ICICLE_TBBA					=

				62234, -- SPELL_ICICLE_VISUAL_UNPACKED		=
				62462, -- SPELL_ICICLE_VISUAL_PACKED			=
				62453, -- SPELL_ICICLE_VISUAL_FALLING			=
				62236, -- SPELL_ICICLE_FALL_EFFECT_UNPACKED	=
				62460, -- SPELL_ICICLE_FALL_EFFECT_PACKED		=
				62457, -- SPELL_ICE_SHARDS_SMALL				=
				65370, -- SPELL_ICE_SHARDS_BIG				=
				62463, -- SPELL_SNOWDRIFT						=

				62478, -- SPELL_FROZEN_BLOWS_10				=
				63512, -- SPELL_FROZEN_BLOWS_25				=

				-- Helpers:
				63499, -- SPELL_PRIEST_DISPELL_MAGIC			=
				62809, -- SPELL_PRIEST_GREAT_HEAL				=
				61923, -- SPELL_PRIEST_SMITE					=

				62793, -- SPELL_DRUID_WRATH					=
				62807, -- SPELL_DRUID_STARLIGHT_AREA_AURA		=

				61924, -- SPELL_SHAMAN_LAVA_BURST				=
				65123, -- SPELL_SHAMAN_STORM_CLOUD_10			=
				65133, -- SPELL_SHAMAN_STORM_CLOUD_25			=
				63711, -- SPELL_SHAMAN_STORM_POWER_10			=
				65134, -- SPELL_SHAMAN_STORM_POWER_25			=

				61909, -- SPELL_MAGE_FIREBALL					=
				64528, -- SPELL_MAGE_MELT_ICE					=
				62823, -- SPELL_MAGE_CONJURE_TOASTY_FIRE		=
				62819, -- SPELL_MAGE_SUMMON_TOASTY_FIRE		=
				62821, -- SPELL_MAGE_TOASTY_FIRE_AURA			=
				65280, -- SPELL_SINGED						=
				
			},
			
			phases = { 
				{ --> phase 1: 
					adds = {
						32845, --Hodir
						32938, -- Flash Freeze NPC
						32926, -- Flash Freeze Player
					},
					spells = {
						--> 
					}
				},
			},
			
		}, --> end of Hodir
		
------------> Thorim ------------------------------------------------------------------------------	
		[9] = {
			boss =	"Thorim",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\thorim]],

			combat_end = {1, 32865},
			
			spell_mechanics = {
						[142861] = {0x200}, --Ancient Miasma
			},
			
			continuo = {
					-- THORIM
					62393, -- SPELL_LIGHTNING_DESTRUCTION				=
					62276, -- SPELL_SHEATH_OF_LIGHTNING				=
					62042, -- SPELL_STORMHAMMER						=
					62560, -- SPELL_BERSERK_FRIENDS					=
					62131, -- SPELL_CHAIN_LIGHTNING_10				=
					64390, -- SPELL_CHAIN_LIGHTNING_25				=
					62130, -- SPELL_UNBALANCING_STRIKE				=
					26662, -- SPELL_BERSERK							=

					62016, -- SPELL_CHARGE_ORB						=
					63238, -- SPELL_LIGHTNING_PILLAR_P1				=

					62186, -- SPELL_LIGHTNING_ORB_VISUAL				=
					62466, -- SPELL_LIGHTNING_CHARGE_DAMAGE			=
					62279, -- SPELL_LIGHTNING_CHARGE_BUFF				=
					62976, -- SPELL_LIGHTNING_PILLAR_P2				=
					62278, -- SPELL_LIGHTNING_ORB_CHARGER				=
					
					-- SIF
					62507, -- SPELL_TOUCH_OF_DOMINION					=
					64778, -- SPELL_SIF_TRANSFORM						=
					64324, -- SPELL_SIF_CHANNEL_HOLOGRAM				=
					62601, -- SPELL_FROSTBOLT							=
					62604, -- SPELL_FROSTBOLT_VALLEY					=
					62577, -- SPELL_BLIZZARD_10						=
					62603, -- SPELL_BLIZZARD_25						=
					62605, -- SPELL_FROST_NOVA						=

					-- DARK RUNE ACOLYTE
					62334, -- SPELL_GREATER_HEAL_10					=
					62442, -- SPELL_GREATER_HEAL_25					=
					62335, -- SPELL_HOLY_SMITE_10						=
					62443, -- SPELL_HOLY_SMITE_25						=
					62333, -- SPELL_RENEW_10							=
					62441, -- SPELL_RENEW_25							=

					-- CAPTURED MERCENARY SOLDIER
					62318, -- SPELL_BARBED_SHOT						=
					40652, -- SPELL_WING_CLIP							=
					16496, -- SPELL_SHOOT								=

					-- CAPTURED MERCENARY CAPTAIN
					62317, -- SPELL_DEVASTATE							=
					62444, -- SPELL_HEROIC_STRIKE						=

					-- JORMUNGAR BEHEMOTH
					62315, -- SPELL_ACID_BREATH_10					=
					62415, -- SPELL_ACID_BREATH_25					=
					62316, -- SPELL_SWEEP_10							=
					62417, -- SPELL_SWEEP_25							=

					-- IRON RING GUARD
					62331, -- SPELL_IMPALE_10							=
					62418, -- SPELL_IMPALE_25							=
					64151, -- SPELL_WHIRLING_TRIP						=

					-- IRON HONOR GUARD
					62332, -- SPELL_SHIELD_SMASH_10					=
					62420, -- SPELL_SHIELD_SMASH_25					=
					42724, -- SPELL_CLEAVE							=
					48639, -- SPELL_HAMSTRING							=

					-- DARK RUNE WARBRINGER
					62320, -- SPELL_AURA_OF_CELERITY					=
					62322, -- SPELL_RUNIC_STRIKE						=

					-- DARK RUNE EVOKER
					62327, -- SPELL_RUNIC_LIGHTNING_10				=
					62445, -- SPELL_RUNIC_LIGHTNING_25				=
					62328, -- SPELL_RUNIC_MENDING_10					=
					62446, -- SPELL_RUNIC_MENDING_25					=
					62321, -- SPELL_RUNIC_SHIELD_10					=
					62529, -- SPELL_RUNIC_SHIELD_25					=

					-- DARK RUNE CHAMPION
					32323, -- SPELL_CHARGE							=
					35054, -- SPELL_MORTAL_STRIKE						=
					15578, -- SPELL_WHIRLWIND							=

					-- DARK RUNE COMMONER
					62326, -- SPELL_LOW_BLOW							=
					38313, -- SPELL_PUMMEL							=

					-- RUNIC COLOSSUS
					62613, -- SPELL_COLOSSUS_CHARGE_10				=
					62614, -- SPELL_COLOSSUS_CHARGE_25				=
					62338, -- SPELL_RUNIC_BARRIER						=
					62339, -- SPELL_SMASH								=
					62057, -- SPELL_RUNIC_SMASH_LEFT					=
					62058, -- SPELL_RUNIC_SMASH_RIGHT					=
					62465, -- SPELL_RUNIC_SMASH_DAMAGE				=

					-- ANCIENT RUNE GIANT
					62526, -- SPELL_RUNE_DETONATION					=
					62942, -- SPELL_RUNIC_FORTIFICATION				=
					62411, -- SPELL_STOMP_10							=
					62413, -- SPELL_STOMP_25							=

					-- TRAPS
					64972, -- SPELL_LIGHTNING_FIELD					=
					62241, -- SPELL_PARALYTIC_FIELD_FIRST				=
					63540, -- SPELL_PARALYTIC_FIELD_SECOND			=
			},
			
			phases = { 
				{ --> phase 1: Might of the Kor'kron
					adds = {
						32865, --Thorim
						
						32886, -- NPC_DARK_RUNE_ACOLYTE_I
						32885, -- NPC_CAPTURED_MERCENARY_SOLDIER_ALLY	
						32883, -- NPC_CAPTURED_MERCENARY_SOLDIER_HORDE	
						32908, -- NPC_CAPTURED_MERCENARY_CAPTAIN_ALLY		
						32907, -- NPC_CAPTURED_MERCENARY_CAPTAIN_HORDE	
						32882, -- NPC_JORMUNGAR_BEHEMOT					
						-- ARENA PHASE
						32877, -- NPC_DARK_RUNE_WARBRINGER				 
						32878, -- NPC_DARK_RUNE_EVOKER					 
						32876, -- NPC_DARK_RUNE_CHAMPION					 
						32904, -- NPC_DARK_RUNE_COMMONER					

						-- GAUNTLET
						32874, -- NPC_IRON_RING_GUARD						
						32872, -- NPC_RUNIC_COLOSSUS						
						32873, -- NPC_ANCIENT_RUNE_GIANT					 
						33110, -- NPC_DARK_RUNE_ACOLYTE_G					
						32875, -- NPC_IRON_HONOR_GUARD				
						
						
					},
					spells = {
					}
				},
			},
			
		}, --> end of Thorim
		
------------> Freya ------------------------------------------------------------------------------	
		[10] = {
			boss =	"Freya",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\freya]],

			combat_end = {1, 32906},
			spell_mechanics = {
				--Lightweight Crates -> Mogu Crates
				[145218] = {0x10, 0x20}, --Harden Flesh (Animated Stone Mogu)
			},
			
			continuo = {
					-- FREYA
					62528, -- SPELL_TOUCH_OF_EONAR_10						=
					62892, -- SPELL_TOUCH_OF_EONAR_25						=
					62519, -- SPELL_ATTUNED_TO_NATURE						=
					62870, -- SPELL_SUMMON_LIFEBINDER						=
					62623, -- SPELL_SUNBEAM_10							=
					62872, -- SPELL_SUNBEAM_25							=
					64648, -- SPELL_NATURE_BOMB_FLIGHT					=
					64587, -- SPELL_NATURE_BOMB_DAMAGE_10					=
					64650, -- SPELL_NATURE_BOMB_DAMAGE_25					=
					32567, -- SPELL_GREEN_BANISH_STATE					=
					47008, -- SPELL_BERSERK								=

					-- HARD MODE
					62437, -- SPELL_GROUND_TREMOR_FREYA_10				=
					62859, -- SPELL_GROUND_TREMOR_FREYA_25				=
					62862, -- SPELL_IRON_ROOTS_FREYA_10					=
					62439, -- SPELL_IRON_ROOTS_FREYA_25					=
					62861, -- SPELL_IRON_ROOTS_FREYA_DAMAGE_10			=
					62438, -- SPELL_IRON_ROOTS_FREYA_DAMAGE_25			=
					62451, -- SPELL_UNSTABLE_SUN_FREYA_DAMAGE_10			=
					62865, -- SPELL_UNSTABLE_SUN_FREYA_DAMAGE_25			=
					62216, -- SPELL_UNSTABLE_SUN_VISUAL					=


					-- ELDERS
					62467, -- SPELL_DRAINED_OF_POWER						=
					62483, -- SPELL_STONEBARK_ESSENCE						=
					62484, -- SPELL_IRONBRANCH_ESSENCE					=
					62485, -- SPELL_BRIGHTLEAF_ESSENCE					=
					
					-- BRIGHTLEAF
					62239, -- SPELL_BRIGHTLEAF_FLUX						=
					62240, -- SPELL_SOLAR_FLARE_10						=
					64087, -- SPELL_SOLAR_FLARE_25						=
					62211, -- SPELL_UNSTABLE_SUN_BEAM_AURA				=
					62209, -- SPELL_PHOTOSYNTHESIS						=
					62217, -- SPELL_UNSTABLE_SUN_DAMAGE_10				=
					62922, -- SPELL_UNSTABLE_SUN_DAMAGE_25				=
					
					-- IRONBRANCH
					62310, -- SPELL_IMPALE_10								=
					62928, -- SPELL_IMPALE_25								=
					62275, -- SPELL_IRON_ROOTS_10							=
					62929, -- SPELL_IRON_ROOTS_25							=
					62283, -- SPELL_IRON_ROOTS_DAMAGE_10					=
					62930, -- SPELL_IRON_ROOTS_DAMAGE_25					=
					62285, -- SPELL_THORN_SWARM_10						=
					62931, -- SPELL_THORN_SWARM_25						=
					
					-- STONEBARK
					62344, -- SPELL_FISTS_OF_STONE						=
					62325, -- SPELL_GROUND_TREMOR_10						=
					62932, -- SPELL_GROUND_TREMOR_25						=
					62337, -- SPELL_PETRIFIED_BARK_10						=
					62933, -- SPELL_PETRIFIED_BARK_25						=

					-- SNAPLASHER
					62664, -- SPELL_HARDENED_BARK_10						=
					64191, -- SPELL_HARDENED_BARK_25						=

					-- ANCIENT WATER SPIRIT
					62653, -- SPELL_TIDAL_WAVE_10							=
					62935, -- SPELL_TIDAL_WAVE_25							=
					62654, -- SPELL_TIDAL_WAVE_DAMAGE_10					=
					62936, -- SPELL_TIDAL_WAVE_DAMAGE_25					=
					62655, -- SPELL_TIDAL_WAVE_AURA						=

					-- STORM LASHER
					62648, -- SPELL_LIGHTNING_LASH_10						=
					62939, -- SPELL_LIGHTNING_LASH_25						=
					62649, -- SPELL_STORMBOLT_10							=
					62938, -- SPELL_STORMBOLT_25							=

					-- ANCIENT CONSERVATOR
					62532, -- SPELL_CONSERVATOR_GRIP						=
					62589, -- SPELL_NATURE_FURY_10						=
					63571, -- SPELL_NATURE_FURY_25						=
					62541, -- SPELL_POTENT_PHEROMONES						=
					62538, -- SPELL_HEALTHY_SPORE_VISUAL					=
					62566, -- SPELL_HEALTHY_SPORE_SUMMON					=

					-- DETONATING LASHER
					62598, -- SPELL_DETONATE_10							=
					62937, -- SPELL_DETONATE_25							=
					62608, -- SPELL_FLAME_LASH							=
			},
			
			phases = { 
				{ --> phase 1:
					adds = {
						32906, --Freya
						32919, -- NPC_STORM_LASHER		
						33202, -- NPC_ANCIENT_WATER_SPIRIT	
						32916, -- NPC_SNAPLASHER	
						33203, -- NPC_ANCIENT_CONSERVATOR
						33215, -- NPC_HEALTHY_SPORE
						32918, -- NPC_DETONATING_LASHER
					},
					spells = {
					}
				}
			},
			
		}, --> end of Freya

------------> Mimiron ------------------------------------------------------------------------------	
		[11] = {
			boss =	"Mimiron",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\mimiron]],
			
			combat_end = {1, 33432},
			
			spell_mechanics = {
				[143426] = {0x100}, --Fearsome Roar

			},
			
			continuo = {
					-- PHASE 1:
					65026, -- SPELL_NAPALM_SHELL_25							=
					63666, -- SPELL_NAPALM_SHELL_10							=

					64529, -- SPELL_PLASMA_BLAST_25							=
					62997, -- SPELL_PLASMA_BLAST_10							=

					63631, -- SPELL_SHOCK_BLAST								=

					63027, -- SPELL_PROXIMITY_MINES							=
					63009, -- SPELL_MINE_EXPLOSION_25							=
					66351, -- SPELL_MINE_EXPLOSION_10							=

					-- PHASE 2:
					64533, -- SPELL_HEAT_WAVE									=

					64064, -- SPELL_ROCKET_STRIKE_AURA						=


					63382, -- SPELL_RAPID_BURST								=
					64531, -- SPELL_RAPID_BURST_DAMAGE_25_1					=
					64532, -- SPELL_RAPID_BURST_DAMAGE_25_2					=
					63387, -- SPELL_RAPID_BURST_DAMAGE_10_1					=
					64019, -- SPELL_RAPID_BURST_DAMAGE_10_2					=
					64840, -- SPELL_SUMMON_BURST_TARGET						=

					63414, -- SPELL_SPINNING_UP								=

					-- PHASE 3:
					64535, -- SPELL_PLASMA_BALL_25							=
					63689, -- SPELL_PLASMA_BALL_10							=

					64436, -- SPELL_MAGNETIC_CORE								=
					64438, -- SPELL_SPINNING									=

					63811, -- SPELL_SUMMON_BOMB_BOT							=
					63801, -- SPELL_BB_EXPLODE								=

					63295, -- SPELL_BEAM_GREEN								=
					63292, -- SPELL_BEAM_YELLOW								=
					63294, -- SPELL_BEAM_BLUE									=

					-- PHASE 4:
					64352, -- SPELL_HAND_PULSE_10_R							=
					64537, -- SPELL_HAND_PULSE_25_R							=
					64348, -- SPELL_HAND_PULSE_10_L							=
					64536, -- SPELL_HAND_PULSE_25_L							=
			},
			
			phases = { 
				{ --> phase 1: A Cry in the Darkness 
					adds = {
						33432, --> Leviathan MKII (Mimiron)
						33651, --> VX-001
						33670, --> ACU
						33836, --> Bomb Bot
						34057, --> Assault Bot
						33855, --> Junk Bot
						34147, --> Emergency Fire Bot
					},
					spells = {
					}
				},
			},
			
		}, --> end of Mimiron
		
------------> General Vezax ------------------------------------------------------------------------------	
		[12] = {
			boss =	"General Vezax",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\vezax]],

			combat_end = {1, 33271},
			
			spell_mechanics = {
						[144335] = {0x8}, --Matter Purification Beam
			},
			
			continuo = {
				62660, -- SPELL_VEZAX_SHADOW_CRASH					=
				62659, -- SPELL_VEZAX_SHADOW_CRASH_DMG				=
				63277, -- SPELL_VEZAX_SHADOW_CRASH_AREA_AURA			=
				65269, -- SPELL_VEZAX_SHADOW_CRASH_AURA				=

				62661, -- SPELL_SEARING_FLAMES						=

				62662, -- SPELL_SURGE_OF_DARKNESS						=

				63276, -- SPELL_MARK_OF_THE_FACELESS_AURA				=
				63278, -- SPELL_MARK_OF_THE_FACELESS_EFFECT			=

				62692, -- SPELL_AURA_OF_DESPAIR_1						=
				64848, -- SPELL_AURA_OF_DESPAIR_2						=
				68415, -- SPELL_CORRUPTED_RAGE						=
				64646, -- SPELL_CORRUPTED_WISDOM						=
				30823, -- SPELL_SHAMANISTIC_RAGE						=
				31876, -- SPELL_JUDGEMENTS_OF_THE_WISDOM_RANK_1		=

				63081, -- SPELL_SUMMON_SARONITE_VAPORS				=
				63338, -- SPELL_SARONITE_VAPORS_DMG					=
				63337, -- SPELL_SARONITE_VAPORS_ENERGIZE				=
				63323, -- SPELL_SARONITE_VAPORS_AURA					=
				63322, -- SPELL_SARONITE_VAPORS_DUMMYAURA				=

				63319, -- SPELL_SARONITE_ANIMUS_FORMATION_VISUAL		=
				63145, -- SPELL_SUMMON_SARONITE_ANIMUS				=
				63364, -- SPELL_SARONITE_BARRIER						=
				63420, -- SPELL_PROFOUND_DARKNESS						=
			},
			
			phases = { 
				{ --> phase 1: 
					adds = {
						33271, --General Vezax
						33488, --Saronite Vapors
						33524, --Saronite Animus

					},
					spells = {
						
					}
				}
			},
			
		}, --> end of General Vezax
		
------------> Yogg-Saron ------------------------------------------------------------------------------	
		[13] = {
			boss =	"Yogg-Saron",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\yogg]],
			
			combat_end = {1, 33288},

			spell_mechanics = {
				[142931] = {}, --Exposed Veins
				[143939] = {}, --Gouge
				[143941] = {}, --Mutilate
				[142232] = {}, --Death from Above 

			},
			
			continuo = {
				65206, -- SPELL_DESTABILIZATION_MATRIX		=
				65210, -- SPELL_DESTABILIZATION_MATRIX_ATTACK	=
				63288, -- SPELL_SANITY_WELL_VISUAL			=
				64169, -- SPELL_SANITY_WELL_BUFF				=
				64174, -- SPELL_PROTECTIVE_GAZE				= // COOLDOWN 25 SECS BEFORE NEXT USE
				64175, -- SPELL_HODIR_FLASH_FREEZE			=
				64170, -- SPELL_CONJURE_SANITY_WELL			=

				64171, -- SPELL_TITANIC_STORM_PASSIVE			=
				64162, -- SPELL_WEAKENED						=

				-- GLOBAL
				63786, -- SPELL_SANITY_BASE					=
				63050, -- SPELL_SANITY						=
				64166, -- SPELL_EXTINGUISH_ALL_LIFE			=
				63084, -- SPELL_CLOUD_VISUAL					=
				63031, -- SPELL_SUMMON_GUARDIAN_OF_YS			=
				63120, -- SPELL_INSANE1						=
				64464, -- SPELL_INSANE2						=
				64554, -- SPELL_INSANE_PERIODIC				= // this checks if player dc'ed and insanes him instantly after logging in

				-- SARA P1
				63138, -- SPELL_SARAS_FAVOR                       =
				63747, -- SPELL_SARAS_FAVOR_TARGET_SELECTOR       =
				63134, -- SPELL_SARAS_BLESSING                    =
				63745, -- SPELL_SARAS_BLESSING_TARGET_SELECTOR    =
				63147, -- SPELL_SARAS_ANGER                       =
				63744, -- SPELL_SARAS_ANGER_TARGET_SELECTOR       =
				64775, -- SPELL_SHADOWY_BARRIER				    =

				-- GUARDIANS OF YOGG-SARON
				62714, -- SPELL_SHADOW_NOVA					=
				63038, -- SPELL_DARK_VOLLEY					=

				-- SARA P2
				63795, -- SPELL_SARA_PSYCHOSIS_10				=
				65301, -- SPELL_SARA_PSYCHOSIS_25				=
				63830, -- SPELL_MALADY_OF_THE_MIND			=
				63881, -- SPELL_MALADY_OF_THE_MIND_TRIGGER	=
				63802, -- SPELL_BRAIN_LINK					=
				63803, -- SPELL_BRAIN_LINK_DAMAGE				=
				63804, -- SPELL_BRAIN_LINK_OK					=

				63886, -- SPELL_DEATH_RAY_DAMAGE_VISUAL		=
				63893, -- SPELL_DEATH_RAY_ORIGIN_VISUAL		=
				63882, -- SPELL_DEATH_RAY_WARNING				=
				63883, -- SPELL_DEATH_RAY_DAMAGE				=
				63884, -- SPELL_DEATH_RAY_DAMAGE_REAL			=

				-- YOGG-SARON P2
				63894, -- SPELL_SHADOW_BARRIER				=
				64022, -- SPELL_KNOCK_AWAY					=

				-- TENTACLES
				64384, -- SPELL_VOID_ZONE_SMALL				=
				64017, -- SPELL_VOID_ZONE_LARGE				=
				64144, -- SPELL_TENTACLE_ERUPT				=

				-- CRUSHER TENTACLE
				64146, -- SPELL_CRUSH							=
				64145, -- SPELL_DIMINISH_POWER				=
				57688, -- SPELL_FOCUSED_ANGER					=

				-- CONSTRICTOR TENTACLE
				64123, -- SPELL_LUNGE							=
				64125, -- SPELL_SQUEEZE_10					=
				64126, -- SPELL_SQUEEZE_25					=

				-- CORRUPTOR TENTACLE
				64156, -- SPELL_APATHY						=
				64153, -- SPELL_BLACK_PLAGUE					=
				64157, -- SPELL_CURSE_OF_DOOM					=
				64152, -- SPELL_DRAINING_POISON				=

				-- MISC
				64012, -- SPELL_REVEALED_TENTACLE				=
				64184, -- SPELL_IN_THE_MAWS_OF_THE_OLD_GOD	=

				-- BRAIN OF YOGG-SARON
				64173, -- SPELL_SHATTERED_ILLUSION			=
				64059, -- SPELL_INDUCE_MADNESS				=
				64361, -- SPELL_BRAIN_HURT_VISUAL				=

				-- PORTALS
				63997, -- SPELL_TELEPORT_TO_CHAMBER			=
				63998, -- SPELL_TELEPORT_TO_ICECROWN			=
				63989, -- SPELL_TELEPORT_TO_STORMWIND			=
				63992, -- SPELL_TELEPORT_BACK					=
				63993, -- SPELL_CANCEL_ILLUSION_AURA			=

				-- LAUGHING SKULL AND INFLUENCE TENTACLE AND OTHERS
				64167, -- SPELL_LUNATIC_GAZE					=
				63305, -- SPELL_GRIM_REPRISAL					=
				64039, -- SPELL_GRIM_REPRISAL_DAMAGE          =
				63037, -- SPELL_DEATHGRASP					=

				-- YOGG-SARON P3
				64163, -- SPELL_LUNATIC_GAZE_YS				=
				64189, -- SPELL_DEAFENING_ROAR				=
				64465, -- SPELL_SHADOW_BEACON					=

				-- IMMORTAL GUARDIAN
				64195, -- SPELL_SIMPLE_TELEPORT				=
				65294, -- SPELL_EMPOWERED						=
				64161, -- SPELL_EMPOWERED_PASSIVE				=
				64159, -- SPELL_DRAIN_LIFE_10					=
				64160, -- SPELL_DRAIN_LIFE_25					=
				64497, -- SPELL_RECENTLY_SPAWNED				=
			},
			
			phases = { 
				{ --> phase 1: 
					adds = {
						33288, --Yogg-Saron
						33136, -- NPC_GUARDIAN_OF_YS					=
						33288, -- NPC_YOGG_SARON						=
						33890, -- NPC_BRAIN_OF_YOGG_SARON	

						33966, -- NPC_CRUSHER_TENTACLE				= // 50 secs ?
						33983, -- NPC_CONSTRICTOR_TENTACLE			= // 15-20 secs ?
						33985, -- NPC_CORRUPTOR_TENTACLE				= // 30-40 secs ?

						33943, -- NPC_INFLUENCE_TENTACLE				=
						--33882, -- NPC_DEATH_ORB						=
						--34072, -- NPC_DESCEND_INTO_MADNESS			=
						--33990, -- NPC_LAUGHING_SKULL					=

						33988, -- NPC_IMMORTAL_GUARDIAN				=

						--33716, -- NPC_CONSORT_FIRST					=
						--33720, -- NPC_CONSORT_LAST					=
						--33536, -- NPC_ALEXTRASZA						=
						--33535, -- NPC_MALYGOS							=
						--33523, -- NPC_NELTHARION						=
						--33495, -- NPC_YSERA							=

						-- ICECROWN ILLUSION
						--33567, -- NPC_DEATHSWORN_ZEALOT				=
						--33441, -- NPC_LICH_KING						=
						--33442, -- NPC_IMMOLATED_CHAMPION				=

						-- STORMWIND ILLUSION
						--33433, -- NPC_SUIT_OF_ARMOR					=
						--33436, -- NPC_GARONA							=
						--33437, -- NPC_KING_LLANE						=
					},
					spells = {
						
					}
				}
			},
			
		}, --> end of Paragons of the Klaxxi
		
------------> Algalon ------------------------------------------------------------------------------	
		[14] = {
			boss =	"Algalon",
			portrait = [[Interface\AddOns\Details_RaidInfo-Ulduar\images\algalon]],

			combat_end = {1, 32871},
			equalize = true,
			
			spell_mechanics = {
			},
			
			continuo = {
				64443, -- Big Bang
				62301, -- Cosmic Smash
				64559, -- Arcane Barrage
				64122, -- Black Hole Explosion
				64395, -- Quantum Strike
				64412, -- Phase Punch
			},
			
			phases = { 
				{ --> phase 1: 
					adds = {
						32871, --Algalon
						33052, --Living Constellation
						32955, --Collapsing Star
						34097, --Unleashed Dark Matter
						
					},
					spells = {
					}
				},
			},
			
		}, --> end of Algalon
		
	} --> End Ulduar
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

_details:InstallEncounter (ulduar)
