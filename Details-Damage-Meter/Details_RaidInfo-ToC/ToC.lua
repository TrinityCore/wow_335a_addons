--[[
=====================================================================================================
	Siege of Orgrimmar Mobs and Spells Ids for Details
=====================================================================================================
--]]

local Loc = LibStub ("AceLocale-3.0"):GetLocale ("Details_RaidInfo-ToC")

local _details = 		_G._details

local toc = {

	id = 544,
	ej_id = 544,
	
	name = Loc ["STRING_RAID_NAME"],
	
	icons = "Interface\\AddOns\\Details_RaidInfo-ToC\\images\\boss_faces",
	
	icon = "Interface\\LFGFrame\\UI-LFG-BACKGROUND-ArgentRaid",
	
	is_raid = true,

	backgroundFile = {file = [[Interface\LFGFrame\UI-LFG-BACKGROUND-ArgentRaid]], coords = {0, 1, 256/1024, 840/1024}},
	backgroundEJ = [[Interface\EncounterJournal\UI-EJ-LOREBG-SiegeofOrgrimmar]],
	
	boss_names = {
		"Beasts of Northrend",
		"Lord Jaraxxus",
		"Faction Champions",
		"Twin Val'kyr",
		"Anub'arak",
	},
	
	encounter_ids = {
		--> Ids by Index
			201, 202, 203, 204, 205,
		-- Trial of the Crusader
			[201] = 1, -- Beasts of Northrend
			[202] = 2, -- Lord Jaraxxus
			[203] = 3, -- Faction Champions
			[204] = 4, -- Twin Val'kyr
			[205] = 5, -- Anub'arak
	},
	
	encounter_ids2 = {
	},
	
	boss_ids = {
		-- The Siege of Ulduar
			[33113]	= 1,	-- Beasts of Northrend
			[33118]	= 2,	-- Lord Jaraxxus
			[33186]	= 3,	-- Faction Champions
			[33293]	= 4,	-- Twin Val'kyr
			[32867]	= 5,	-- Anub'arak
			[32927]	= 5,	-- Anub'arak
			[32857]	= 5,	-- Anub'arak
	},
	
	trash_ids = {
	},
	
	encounters = {
	
------------> Beasts of Northrend ------------------------------------------------------------------------------
		[1] = {
			
			boss =	"Beasts of Northrend",
			portrait = [[Interface\AddOns\Details_RaidInfo-ToC\images\Beasts]],

			spell_mechanics =	{
					},
			
			phases = {
				{
					spells = {
						-- Gormok
							62911, --> Thorim's Hammer
							66331, --> 66880, --> SPELL_IMPALE
							67648, --> SPELL_STAGGERING_STOMP
							66636, --> SPELL_RISING_ANGER
							66406, --> SPELL_SNOBOLLED
							66408, --> SPELL_BATTER
							66313, --> SPELL_FIRE_BOMB
							66318, --> SPELL_FIRE_BOMB_AURA
							66407, --> SPELL_HEAD_CRACK
						-- Jormungar 
							66880, --> SPELL_ACID_SPIT	
							66818, --> SPELL_ACID_SPEW	
							66901, --> SPELL_PARALYTIC_SPRAY
							66824, --> SPELL_PARALYTIC_BITE	

							66796, --> SPELL_FIRE_SPIT	
							66821, --> SPELL_MOLTEN_SPEW
							66902, --> SPELL_BURNING_SPRAY
							66879, --> SPELL_BURNING_BITE

							66881, --> SPELL_SLIME_POOL_DAMAGE
							66882, --> SPELL_SLIME_POOL_EFFECT
							66794, --> SPELL_SWEEP_0						
							67646, --> SPELL_SWEEP_1		
			
							66969, --> SPELL_CHURNING_GROUND				
						-- Icehowl
							66770, --> SPELL_FEROCIOUS_BUTT				
							67345, --> SPELL_WHIRL							
							66689, --> SPELL_ARCTIC_BREATH					

							66683, --> SPELL_MASSIVE_CRASH								
							66734, --> SPELL_TRAMPLE						
						},
						
					adds = {
						34796, --> NPC_GORMOK
						34799, --> NPC_DREADSCALE
						35144, --> NPC_ACIDMAW
						
						35176, --> NPC_SLIME_POOL
						34800, --> Snobold Vassal
					}
				},
			}
		}, --> end of Beasts of Northrend
		
		
------------> Lord Jaraxxus ------------------------------------------------------------------------------
		[2] = {

			boss =	"Lord Jaraxxus",
			portrait = [[Interface\AddOns\Details_RaidInfo-ToC\images\Jaraxxus]],


			spell_mechanics =	{
						
			},
		

		
			continuo = {
						62680, --> Flame Jets (10)
			},
		
			phases = {
				{
					--> phase 1 - 
					spells = {
						66532, --> SPELL_FEL_FIREBALL					,
						66528, --> SPELL_FEL_LIGHTNING					,
						66209, --> SPELL_TOUCH_OF_JARAXXUS				,
						66197, --> SPELL_LEGION_FLAME					,
						66201, --> SPELL_LEGION_FLAME_NPC_AURA			,
						67060, --> Burning Inferno

						66494, --> SPELL_FEL_STEAK						,
						66493, --> SPELL_FEL_STEAK_MORPH				,
						67903, --> Infernal Eruption
						66255, --> Infernal Eruption

						66378, --> SPELL_SHIVAN_SLASH					,
						66283, --> SPELL_SPINNING_PAIN_SPIKE			,
						66336, --> SPELL_MISTRESS_KISS					,
						},
					adds = 	{
							34780, -- Lord Jaraxxus
							34813, --> NPC_INFERNAL_VOLCANO				,
							34815, --> NPC_FEL_INFERNAL					,
							34825, --> NPC_NETHER_PORTAL					,
							34826, --> NPC_MISTRESS_OF_PAIN				,
						}
				}			
			} 
	
		}, --> end of Lord Jaraxxus
		
------------> Faction Champions ------------------------------------------------------------------------------

		[3] = {
			boss =	"Faction Champions",
			portrait = [[Interface\AddOns\Details_RaidInfo-ToC\images\Champions]],
			
			encounter_start = {delay = 0},
			equalize = true,
			
			spell_mechanics =	{
						[64709] = {0x8}, --> Devouring Flame (10)
			},
			
			continuo = {
			-- DRUID SPELLS
				66093, --> SPELL_LIFEBLOOM		 
				66066, --> SPELL_NOURISH		   
				66067, --> SPELL_REGROWTH		  
				66065, --> SPELL_REJUVENATION	  
				66068, --> SPELL_THORNS			
				66086, --> SPELL_TRANQUILITY	   
				65860, --> SPELL_BARKSKIN		  
				66071, --> SPELL_NATURE_GRASP	  
			-- SHAMAN SPELLS
				66055, --> SPELL_HEALING_WAVE		  
				66053, --> SPELL_RIPTIDE			   
				66056, --> SPELL_SPIRIT_CLEANSE		
				65983, --> SPELL_HEROISM			   
				65980, --> SPELL_BLOODLUST			 
				66054, --> SPELL_HEX				   
				66063, --> SPELL_EARTH_SHIELD		  
				65973, --> SPELL_EARTH_SHOCK		   
			-- PALADIN SPELLS
				68757, --> SPELL_HAND_OF_FREEDOM	 
				66010, --> SPELL_BUBBLE			  
				66116, --> SPELL_CLEANSE			 
				66113, --> SPELL_FLASH_OF_LIGHT	  
				66112, --> SPELL_HOLY_LIGHT		  
				66114, --> SPELL_HOLY_SHOCK		  
				66009, --> SPELL_HAND_OF_PROTECTION  
				66613, --> SPELL_HAMMER_OF_JUSTICE   
			-- PRIEST SPELLS
				66177, --> SPELL_RENEW			 
				66099, --> SPELL_SHIELD			
				66104, --> SPELL_FLASH_HEAL		
				65546, --> SPELL_DISPEL			
				66100, --> SPELL_MANA_BURN		 
				65543, --> SPELL_PSYCHIC_SCREAM	
			-- SHADOW PRIEST SPELLS
				65542, --> SPELL_SILENCE		   
				65490, --> SPELL_VAMPIRIC_TOUCH	
				65541, --> SPELL_SW_PAIN		   
				65488, --> SPELL_MIND_FLAY		 
				65492, --> SPELL_MIND_BLAST		
				65545, --> SPELL_HORROR			
				65544, --> SPELL_DISPERSION		
				16592, --> SPELL_SHADOWFORM		
			-- WARLOCK SPELLS
				65816, --> SPELL_HELLFIRE			  
				65810, --> SPELL_CORRUPTION			
				65814, --> SPELL_CURSE_OF_AGONY		
				65815, --> SPELL_CURSE_OF_EXHAUSTION   
				65809, --> SPELL_FEAR				  
				65819, --> SPELL_SEARING_PAIN		  
				65821, --> SPELL_SHADOW_BOLT		   
				65812, --> SPELL_UNSTABLE_AFFLICTION   
				65813, --> SPELL_UNSTABLE_AFFLICTION_DISPEL 
				67514, --> SPELL_SUMMON_FELHUNTER	  
			-- MAGE SPELLS
				65799, --> SPELL_ARCANE_BARRAGE	
				65791, --> SPELL_ARCANE_BLAST	  
				65800, --> SPELL_ARCANE_EXPLOSION  
				65793, --> SPELL_BLINK			 
				65790, --> SPELL_COUNTERSPELL	  
				65792, --> SPELL_FROST_NOVA		
				65807, --> SPELL_FROSTBOLT		 
				65802, --> SPELL_ICE_BLOCK		 
				65801, --> SPELL_POLYMORPH		 
			-- HUNTER SPELLS
				65883, --> SPELL_AIMED_SHOT		
				65871, --> SPELL_DETERRENCE		
				65870, --> SPELL_DISENGAGE		 
				65866, --> SPELL_EXPLOSIVE_SHOT	
				65880, --> SPELL_FROST_TRAP		
				65868, --> SPELL_SHOOT			 
				65867, --> SPELL_STEADY_SHOT	   
				66207, --> SPELL_WING_CLIP		 
				65877, --> SPELL_WYVERN_STING	  	  
			-- BALANCE DRUID SPELLS
				65862, --> SPELL_WRATH			 
				65856, --> SPELL_MOONFIRE		  
				65854, --> SPELL_STARFIRE		  
				65855, --> SPELL_INSECT_SWARM	  
				65857, --> SPELL_ENTANGLING_ROOTS  
				65863, --> SPELL_FAERIE_FIRE	   
				65859, --> SPELL_CYCLONE		   
				65861, --> SPELL_FORCE_OF_NATURE   
			-- WARRIOR SPELLS
				65947, --> SPELL_BLADESTORM			
				65930, --> SPELL_INTIMIDATING_SHOUT	
				65926, --> SPELL_MORTAL_STRIKE		 
				68764, --> SPELL_CHARGE				
				65935, --> SPELL_DISARM				
				65924, --> SPELL_OVERPOWER			 
				65936, --> SPELL_SUNDER_ARMOR		  
				65940, --> SPELL_SHATTERING_THROW	  
				65932, --> SPELL_RETALIATION		   
			-- DEATH KNIGHT SPELLS
				66019, --> SPELL_DEATH_COIL		    
				66047, --> SPELL_FROST_STRIKE		
				66023, --> SPELL_ICEBOUND_FORTITUDE  
				66021, --> SPELL_ICY_TOUCH		   
				66018, --> SPELL_STRANGULATE		 
			-- ROGUE SPELLS
				65955, --> SPELL_FAN_OF_KNIVES		 		 		 
				65956, --> SPELL_BLADE_FLURRY		  
				66178, --> SPELL_SHADOWSTEP			
				65954, --> SPELL_HEMORRHAGE			
				65957, --> SPELL_EVISCERATE			
			-- ENHANCE SHAMAN SPELLS
				65973, --> SPELL_EARTH_SHOCK_ENH   
				65974, --> SPELL_LAVA_LASH		 
				65970, --> SPELL_STORMSTRIKE	   
			-- RETRIBUTION PALADIN SPELLS
				66011, --> SPELL_AVENGING_WRATH		
				66003, --> SPELL_CRUSADER_STRIKE	   
				66010, --> SPELL_DIVINE_SHIELD		 
				66006, --> SPELL_DIVINE_STORM		  
				66007, --> SPELL_HAMMER_OF_JUSTICE_RET 
				66005, --> SPELL_JUDGEMENT_OF_COMMAND  
				66008, --> SPELL_REPENTANCE			
				66004, --> SPELL_SEAL_OF_COMMAND	   
			-- HUNTER PET SPELLS
				67793, --> SPELL_CLAW  
			},
			
			phases = {
				{
					adds = 	{
						34461, --> NPC_ALLIANCE_DEATH_KNIGHT						,
						34460, --> NPC_ALLIANCE_DRUID_BALANCE						,
						34469, --> NPC_ALLIANCE_DRUID_RESTORATION					,
						34467, --> NPC_ALLIANCE_HUNTER								,
						34468, --> NPC_ALLIANCE_MAGE								,
						34465, --> NPC_ALLIANCE_PALADIN_HOLY						,
						34471, --> NPC_ALLIANCE_PALADIN_RETRIBUTION				,
						34466, --> NPC_ALLIANCE_PRIEST_DISCIPLINE					,
						34473, --> NPC_ALLIANCE_PRIEST_SHADOW						,
						34472, --> NPC_ALLIANCE_ROGUE								,
						34463, --> NPC_ALLIANCE_SHAMAN_ENHANCEMENT					,
						34470, --> NPC_ALLIANCE_SHAMAN_RESTORATION					,
						34474, --> NPC_ALLIANCE_WARLOCK							,
						34475, --> NPC_ALLIANCE_WARRIOR							,

						34458, --> NPC_HORDE_DEATH_KNIGHT							,
						34451, --> NPC_HORDE_DRUID_BALANCE							,
						34459, --> NPC_HORDE_DRUID_RESTORATION						,
						34448, --> NPC_HORDE_HUNTER								,
						34449, --> NPC_HORDE_MAGE									,
						34445, --> NPC_HORDE_PALADIN_HOLY							,
						34456, --> NPC_HORDE_PALADIN_RETRIBUTION					,
						34447, --> NPC_HORDE_PRIEST_DISCIPLINE						,
						34441, --> NPC_HORDE_PRIEST_SHADOW							,
						34454, --> NPC_HORDE_ROGUE									,
						34455, --> NPC_HORDE_SHAMAN_ENHANCEMENT					,
						34444, --> NPC_HORDE_SHAMAN_RESTORATION					,
						34450, --> NPC_HORDE_WARLOCK								,
						34453, --> NPC_HORDE_WARRIOR								,
					},
					spells = {
					},
				},
			}

		}, --> end of Faction Champions
		
------------> Twin Val'kyr ------------------------------------------------------------------------------	
		[4] = {
			boss =	"Twin Val'kyr",
			portrait = [[Interface\AddOns\Details_RaidInfo-ToC\images\TwinValkyr]],
			
			combat_end = {1, 33293},
			
			spell_mechanics = {
				[63024] = {0x200}, --> Gravity Bomb
			},
			
			continuo = {
				65686, --> SPELL_LIGHT_ESSENCE         
				65811, --> SPELL_LIGHT_ESSENCE_2		
				65684, --> SPELL_DARK_ESSENCE          
				65827, --> SPELL_DARK_ESSENCE_2		

				65808, --> SPELL_UNLEASHED_DARK        
				65795, --> SPELL_UNLEASHED_LIGHT       
				67590, --> SPELL_POWERING_UP			
				65724, --> SPELL_EMPOWERED_DARK        
				65748, --> SPELL_EMPOWERED_LIGHT       

				66075, --> SPELL_LIGHT_TWIN_SPIKE      
				65766, --> SPELL_LIGHT_SURGE           
				65858, --> SPELL_LIGHT_SHIELD             
				66046, --> SPELL_LIGHT_VORTEX          
				67297, --> SPELL_LIGHT_TOUCH           

				66069, --> SPELL_DARK_TWIN_SPIKE       
				65768, --> SPELL_DARK_SURGE            
				65874, --> SPELL_DARK_SHIELD            
				66058, --> SPELL_DARK_VORTEX           
				67282, --> SPELL_DARK_TOUCH                  
			},
			
			phases = { 
				{ --> phase 1
					adds = {
							34497, --> NPC_LIGHTBANE									,
							34496, --> NPC_DARKBANE			
							34628, --> NPC_CONCENTRATED_DARK
							34630, --> NPC_CONCENTRATED_LIGHT
						} 
				}
			}
		}, --> end of Twin Val'kyr
		
------------> Anub'arak ------------------------------------------------------------------------------	
		[5] = {
			boss =	"Anub'arak",
			portrait = [[Interface\AddOns\Details_RaidInfo-ToC\images\Anubarak]],
			
			spell_mechanics = {
			
				[61890] = {0x1, 0x100}, -- Poison-Tipped Blades (Korgra the Snake)
			},			
			continuo = {
					-- Anub'arak
					66012, --> SPELL_FREEZING_SLASH						
					66013, --> SPELL_PENETRATING_COLD											
					66118, --> SPELL_LEECHING_SWARM			
					66240, --> SPELL_LEECHING_SWARM_DMG 
					66125,	-->	SPELL_LEECHING_SWARM_HEAL

					-- Anub'arak Pursue																	
					65919, --> SPELL_IMPALE								

					-- Scarab
					66092, --> SPELL_DETERMINATION							
					65774, --> SPELL_ACID_MANDIBLE							

					-- Burrow
					66969, --> SPELL_CHURNING_GROUND						

					-- Burrower
					66128, --> SPELL_SPIDER_FRENZY							
					67720, --> SPELL_EXPOSE_WEAKNESS						
					66134, --> SPELL_SHADOW_STRIKE					
			},
			
			phases = { 
				{
					adds = {
						34564, --> NPC_ANUBARAK	
						34606, --> NPC_FROST_SPHERE							
						34862, --> NPC_BURROW									
						34607, --> NPC_BURROWER								
						34605, --> NPC_SCARAB									
						34660, --> NPC_SPIKE																,
					},
					spells = {							
						}
				},
			}
		}, --> end of Anub'arak
		
	} --> End Trial of the Crusader
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

_details:InstallEncounter (toc)
