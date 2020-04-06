---------------------------------
---- Raeli's Spell Announcer ----
---------------------------------

RSA = LibStub("AceAddon-3.0"):NewAddon("RSA", "AceConsole-3.0") -- , "LibSink-2.0"
local L = LibStub("AceLocale-3.0"):GetLocale("RSA")


--[[
TO DO

PALADIN:
Test Guardian of Ancient Kings

PRIEST:
Test Leap of Faith
]]--


------------------
---- Defaults ----
------------------

local defaults = {
	global = {
	},
	profile = {
		General = {
			Class = "",
			Smart = {
				RaidParty = true,
				Say = false,
			},
			Local = {
				RaidWarn = true,
				Chat = true,
				--[[ Keep these like this for now. Need to research more about these and how to do this.
				MSBT = false,
				MSBT_Area = "",
				BW = "",
				DBM = "",
				]]--
			},
			GlobalCustomChannel = "MyCustomChannel",
		},
		Reminders = {
			DisableInPvP = true,
			EnableInSpec1 = true,
			EnableInSpec2 = false,
			ScrollWheel = {
				Enabled = false,
				WheelUp = "",
				WheelDown = "",
			},
			CheckInterval = 10,
			RemindInterval = 15,
			RemindChannels = {
				Chat = true,
				RaidWarn = true,
				--[[ Keep these like this for now. Need to research more about these and how to do this.
				MSBT = "",
				BW = "",
				DBM = "",
				]]--
			},
		},


		DeathKnight = {
			Reminders = {
				SpellName = "Horn of Winter",
			},
			Spells = {
				Army = {
					Messages = {
						Start = "Casting SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				AMS = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				DarkCommand = {
					Messages = {
						Start = "Taunted TARGET!",
						End = "TARGET MISSTYPE my Taunt!",
						Immune = "TARGET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				IceboundFortitude = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Strangulate = {
					Messages = {
						Start = "Strangulated TARGET's TARCAST!",
						End = "TARGET MISSTYPE my SPELL!",
						Immune = "TARTET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				DeathGrip = {
					Messages = {
						Start = "Death Gripped TARGET!",
						End = "TARGET MISSTYPE my SPELL!",
						Immune = "TARGET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				VampiricBlood = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				BoneShield = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
			},
		},
		Druid = {
			Reminders = {
				SpellName = "Mark of the Wild",
			},
			Spells = {
				SurvialInstincts = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Cyclone = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET ended!",
						Immune = "SPELL MISSTYPE on TARGET!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End					
				FrenziedRegeneration = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Hibernate = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET ended!",
						Immune = "SPELL MISSTYPE on TARGET!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End					
				Innervate = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				SkullBash = {
					Messages = {
						Start = "Interrupted TARGET's TARCAST!",
						End = "TARGET MISSTYPE my SPELL!",
						Immune = "TARGET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Growl = {
					Messages = {
						Start = "Taunted TARGET!",
						End = "TARGET MISSTYPE my Taunt!",
						Immune = "TARGET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End			
				
			},
		},
		Hunter = {
			Reminders = {
				SpellName = "Aspect of the Hawk",
			},
		},
		Mage = {
			Reminders = {
				SpellName = "Molten Armor",
			},
			Spells = {
				TimeWarp = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Spellsteal = {
					Messages = {
						Start = "Stole TARGET's AURA!",
						End = "TARGET resisted SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Polymorph = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET ended!",
						Immune = "SPELL MISSTYPE on TARGET!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End					
				FoodRitual = {
					Messages = {
						Start = "Casting SPELL, please assist!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Counterspell = {
					Messages = {
						Start = "Counterspelled TARGET's TARCAST!",
						End = "TARGET MISSTYPE my SPELL!",
						Immune = "TARTET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				
			},
		},
		Paladin = {
			Reminders = {
				SpellName = "Righteous Fury",
			},
			Spells = {
				ArdentDefender = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				AuraMastery = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				DivineProtection = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				Forbearance = {
					Messages = {
						Start = "",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--[[Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},]]--
				}, -- End
				DivineGuardian = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				HandOfFreedom = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				HandOfProtection = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				HandOfSacrifice = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				HandOfSalvation = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				LayOnHands = {
					Messages = {
						Start = "SPELL on TARGET for AMOUNT!",
						End = "",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				GoAK = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				Repentance = {
					Messages = {
						Start = "SPELL on TARGET!",
						End = "SPELL on TARGET has ended!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				Rebuke = {
					Messages = {
						Start = "Interrupted TARGET's TARCAST!",
						End = "TARGET MISSTYPE my SPELL!",
						Immune = "TARGET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				HandOfReckoning = {
					Messages = {
						Start = "Taunted TARGET!",
						End = "TARGET MISSTYPE my Taunt!",
						Immune = "TARGET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				RighteousDefense = {
					Messages = {
						Start = "Taunted TARGET!",
						End = "TARGET MISSTYPE my Taunt!",
						Immune = "TARGET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				Beacon = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET has ended!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End

			},
		},
		Priest = {
			Reminders = {
				SpellName = "Inner Fire",
			},
			Spells = {
				LeapOfFaith = {
					Messages = {
						Start = "Pulling TARGET to Me!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = true,
					Raid = false,
					Party = false,
					Smart = {
						RaidParty = false,
						Say = false,
					},
				}, -- End
				DivineHymn = {
					Messages = {
						Start = "SPELL activated!",
						End = "SPELL over!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				HymnOfHope = {
					Messages = {
						Start = "SPELL activated!",
						End = "SPELL over!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				FearWard = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET ended!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = true,
					Whisper = true,
					Raid = false,
					Party = false,
					Smart = {
						RaidParty = false,
						Say = false,
					},
				}, -- End
				Levitate = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = true,
					Raid = false,
					Party = false,
					Smart = {
						RaidParty = false,
						Say = false,
					},
				}, -- End	
				ShackleUndead = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET ended!",
						Immune = "SPELL MISSTYPE on TARGET!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End		
				DispelMagic = {
					Messages = {
						Start = "Dispelled AURA on TARGET!",
						End = "TARGET resisted SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End	
				GuardianSpirit = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET ended!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End	
				PainSuppression = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET ended!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End			
				Lightwell = {
					Messages = {
						Start = "SPELL activated!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End	
				PowerInfusion = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				
			},
		},
		Rogue = {
			Reminders = {
				SpellName = "",
			},
		},
		Shaman = {
			Reminders = {
				SpellName = "Water Shield",
			},
			Spells = {
				Hex = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET ended!",
						Immune = "SPELL MISSTYPE on TARGET!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End					
				Heroism = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End					
				BindElemental = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "SPELL on TARGET ended!",
						Immune = "SPELL MISSTYPE on TARGET!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End					
				WindShear = {
					Messages = {
						Start = "Interrupted TARGET's TARCAST!",
						End = "TARGET MISSTYPE my SPELL!",
						Immune = "TARTET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Purge = {
					Messages = {
						Start = "Purged TARGET's AURA!",
						End = "TARGET resisted SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				ManaTide = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
			},
		},
		Warlock = {
			Reminders = {
				SpellName = "Fel Armor",
			},
			Spells = {
				SoulWell = {
					Messages = {
						Start = "Casting SPELL, please assist!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				SummonStone = {
					Messages = {
						Start = "Casting SPELL, please assist!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				Suffering = {
					Messages = {
						Start = "Taunted TARGET!",
						End = "TARGET MISSTYPE my Taunt!",
						Immune = "TARGET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = true,
					Raid = false,
					Party = false,
					Smart = {
						RaidParty = false,
						Say = false,
					},
				}, -- End
				SingeMagic = {
					Messages = {
						Start = "SPELL on TARGET removed AURA!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = true,
					--Whisper = false,
					Raid = false,
					Party = false,
					Smart = {
						RaidParty = false,
						Say = false,
					},
				}, -- End
				Banish = {
					Messages = {
						Start = "Banished TARGET!",
						End = "SPELL on TARGET has ended!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				Fear = {
					Messages = {
						Start = "Fearing TARGET!",
						End = "SPELL on TARGET has ended!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				Seduce = {
					Messages = {
						Start = "Seducing TARGET!",
						End = "SPELL on TARGET has ended!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				SpellLock = {
					Messages = {
						Start = "Spell Locked TARGET's TARCAST!",
						End = "TARGET MISSTYPE my SPELL!",
						Immune = "TARTET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End
				Devour = {
					Messages = {
						Start = "Devoured TARGET's AURA!",
						End = "TARGET resisted SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End

			}, -- End Spells
		}, -- End Warlock
		Warrior = {
			Reminders = {
				SpellName = "Commanding Shout",
			},
			Spells = {
				EnragedRegeneration = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				ShatteringThrow = {
					Messages = {
						Start = "SPELL on TARGET!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				ShieldWall = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				ChallengingShout = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Pummel = {
					Messages = {
						Start = "Pummeled TARGET's TARCAST!",
						End = "TARGET MISSTYPE my SPELL!",
						Immune = "TARTET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Disarm = {
					Messages = {
						Start = "Disarmed TARGET!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				ShieldBlock = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				ShieldBash = {
					Messages = {
						Start = "Shield Bashed TARGET's TARCAST!",
						End = "TARGET MISSTYPE my SPELL!",
						Immune = "TARTET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Taunt = {
					Messages = {
						Start = "Taunted TARGET!",
						End = "TARGET MISSTYPE my Taunt!",
						Immune = "TARGET is MISSTYPE to my SPELL!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				Vigilance = {
					Messages = {
						Start = "SPELL cast on TARGET!",
						End = "",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
				LastStand = {
					Messages = {
						Start = "SPELL Activated!",
						End = "SPELL Faded!",
					},
					CustomChannel = {
						Enabled = false,
						Channel = "",
					},
					Local = false,
					--Whisper = false,
					Raid = true,
					Party = true,
					Smart = {
						RaidParty = true,
						Say = false,
					},
				}, -- End				
			},
		},
	}, -- End Profile
} -- End Defaults





-----------------
---- Options ----
-----------------
local Options = {
	type = "group",
	name = "Raeli's Spell Announcer",
	order = 0,
	childGroups = "tab",
	args = {
	--[[output = {
	type = "group",
	name = "This is for LibSink",
	},]]--
		Smart_Head = {
			type = "header",
			name = "Smart Channel Detection",
			order = 0,
		},
		Smart_RaidParty = {
			type = "toggle",
			name = "Smart Raid & Party",
			order = 1,
			desc = "When enabled, merges options to announce seperately to Raid and Party channels. It will automatically announce in a Raid if you're in a raid or Party if you're in a party or not at all.",
			get = function(info)
					return RSA.db.profile.General.Smart.RaidParty
				end,
			set = function (info, value)
					RSA.db.profile.General.Smart.RaidParty = value
				end,
		},
		Smart_RaidPartySay = {
			type = "toggle",
			name = "Smart Say",
			order = 2,
			hidden = function()
					return RSA.db.profile.General.Smart.RaidParty ~= true
				end,
			desc = "In addition to automatically detecting and announcing if you are in a Raid or Party, enabling this will let you set any option to additioanlly announce in Say if you are completely ungrouped.",
			get = function(info)
					return RSA.db.profile.General.Smart.Say
				end,
			set = function (info, value)
					RSA.db.profile.General.Smart.Say = value
				end,
		},
		---- End of Section ----
		Custom_Channel_Head = {
			type = "header",
			name = "Custom Channel Settings",
			order = 3,
		},
		Custom_Channel_Desc = {
			type = "description",
			name = "You can choose to set channels for individual spells in their own options, though for convenience, you can set the custom channel for all spells here, by clicking on the \"Set to All Spells\" Button.",
			order = 4,
		},
		Custom_Channel_Text = {
			type = "input",
			name = "Name:",
			desc = "Enter the name of the Custom Channel you wish to use.",
			order = 5,
			get = function(info)
					return RSA.db.profile.General.GlobalCustomChannel
				end,
			set = function(info, value)
					RSA.db.profile.General.GlobalCustomChannel = value
				end,
		},
		Custom_Channel_Set_Global = {
			type = "execute",
			name = "Set to all spells",
			desc = "|cffFF0000WARNING:|r Doing this will override any custom channels you have set on spells!",
			confirm = true,
			func = function()
						-- PALADIN
						RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.Forbearance.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel

						-- WARLOCK
						RSA.db.profile.Warlock.Spells.Soulstone.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.SoulWell.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.SummonStone.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.UnendingBreath.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.SingeMagic.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.Howl.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.DeathCoil.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
						RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Channel = RSA.db.profile.General.GlobalCustomChannel
					end,
			order = 6,
		},
		---- End of Section ----
		Local_Head = {
			type = "header",
			name = "Local Message Settings",
			order = 50,
		},
		Local_Desc = {
			type = "description",
			name = "Spells that are set \"local\" in their settings will be sent to one or more of the following places, here you can select which.",
			order = 51,
		},
		Local_Chat = {
			type = "toggle",
			name = "Chat Window",
			desc = "Sends spell messages set to local to your default Chat Window.",
			order = 52,
			get = function(info)
					return RSA.db.profile.General.Local.Chat
				end,
			set = function(info, value)
					RSA.db.profile.General.Local.Chat =  value
				end,
		},
		Local_RaidWarn = {
			type = "toggle",
			name = L["Raid Warning Frame"],
			desc = "Sends spell messages set to local to the Raid Warning Frame in the center of your screen.",
			order = 53,
			get = function(info)
					return RSA.db.profile.General.Local.RaidWarn
				end,
			set = function(info, value)
					RSA.db.profile.General.Local.RaidWarn =  value
				end,
		},
	},
}

local Profile = {
	type = "group",
	name = "Profile",
	order = 99,
	childGroups = "tab",
	args = {
		Profile = {
			type = "group",
			name = "Profile",
			order = 99,
			childGroups = "tab",
		},
	},
}

Reminders = {
	type = "group",
	name = L["Reminder Options"],
	desc = L.Reminder_Options,
	order = 1,
	childGroups = "tab",
	args = {
		Title = {
			type = "header",
			name = L["Reminder Spell"],
			order = 0,
		},

		DeathKnight = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "DEATHKNIGHT"
			end,
			get = function(info)
					return RSA.db.profile.DeathKnight.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.DeathKnight.Reminders.SpellName = value
				end,
		},
		Druid = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "DRUID"
			end,
			get = function(info)
					return RSA.db.profile.Druid.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.Druid.Reminders.SpellName = value
				end,
		},
		Hunter = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "HUNTER"
			end,
			get = function(info)
					return RSA.db.profile.Hunter.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.Hunter.Reminders.SpellName = value
				end,
		},		
		Mage = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "MAGE"
			end,
			get = function(info)
					return RSA.db.profile.Mage.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.Mage.Reminders.SpellName = value
				end,
		},		
		Paladin = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "PALADIN"
			end,
			get = function(info)
					return RSA.db.profile.Paladin.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.Paladin.Reminders.SpellName = value
				end,
		},
		Priest = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "PRIEST"
			end,
			get = function(info)
					return RSA.db.profile.Priest.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.Priest.Reminders.SpellName = value
				end,
		},
		Rogue = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "ROGUE"
			end,
			get = function(info)
					return RSA.db.profile.Rogue.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.Rogue.Reminders.SpellName = value
				end,
		},		
		Shaman = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "SHAMAN"
			end,
			get = function(info)
					return RSA.db.profile.Shaman.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.Shaman.Reminders.SpellName = value
				end,
		},
		Warlock = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "WARLOCK"
			end,
			get = function(info)
					return RSA.db.profile.Warlock.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.Warlock.Reminders.SpellName = value
				end,
		},
		Warrior = {
			type = "input",
			width = "full",
			name = L["Spell to check:"],
			desc = L.DescSpellRemindName,
			order = 1,
			hidden = function()
				return RSA.db.profile.General.Class ~= "WARRIOR"
			end,
			get = function(info)
					return RSA.db.profile.Warrior.Reminders.SpellName
				end,
			set = function(info, value)
					RSA.db.profile.Warrior.Reminders.SpellName = value
				end,
		},
		
		Title2 = {
			type = "header",
			name = L["Enabling Options"],
			order = 11,
		},
		DisableInPvP = {
			type = "toggle",
			name = L["Disable in PvP"],
			desc = L["Turns off the spell reminders while you have PvP active."],
			order = 12,
			get = function(info)
					return RSA.db.profile.Reminders.DisableInPvP
				end,
			set = function(info, value)
					RSA.db.profile.Reminders.DisableInPvP = value
				end,
		},
		EnableInSpec1 = {
			type = "toggle",
			name = L["Enable in Primary Specialisation"],
			desc = L["Enables reminding of missing buffs while in your Primary Talent Specialisation"],
			width = "full",
			order = 13,
			get = function(info)
					return RSA.db.profile.Reminders.EnableInSpec1
				end,
			set = function(info, value)
					RSA.db.profile.Reminders.EnableInSpec1 = value
				end,
		},
		EnableInSpec2 = {
			type = "toggle",
			name = L["Enable in Secondary Specialisation"],
			desc = L["Enables reminding of missing buffs while in your Secondary Talent Specialisation"],
			width = "full",
			order = 14,
			get = function(info)
					return RSA.db.profile.Reminders.EnableInSpec2
				end,
			set = function(info, value)
					RSA.db.profile.Reminders.EnableInSpec2 = value
				end,
		},
		Title3 = {
			type = "header",
			name = L["Warning Intervals"],
			order = 15,
		},
		CheckInterval = {
			type = "range",
			name = L["Check Interval"],
			desc = L["How often you want to check for missing buffs."],
			order = 16,
			width = "full",
			min = 1,
			max = 60,
			step = 0.5,
			get = function(info)
					return RSA.db.profile.Reminders.CheckInterval
				end,
			set = function(info, value)
					RSA.db.profile.Reminders.CheckInterval = value
				end,
		},
		RemindInterval = {
			type = "range",
			name = L["Remind Interval"],
			desc = L["How often you want to be reminded about missing buffs."],
			order = 17,
			width = "full",
			min = 1,
			max = 60,
			step = 0.5,
			get = function(info)
					return RSA.db.profile.Reminders.RemindInterval
				end,
			set = function(info, value)
					RSA.db.profile.Reminders.RemindInterval = value
				end,
		},
		Title4 = {
			type = "header",
			name = L["Reminder Locations"],
			order = 18,
		},
		Chat = {
			type = "toggle",
			name = L["Chat Window"],
			desc = L["Sends reminders to your default chat window."],
			order = 19,
			get = function(info)
					return RSA.db.profile.Reminders.RemindChannels.Chat
				end,
			set = function(info, value)
					RSA.db.profile.Reminders.RemindChannels.Chat = value
				end,
		},
		RaidWarn = {
			type = "toggle",
			name = L["Raid Warning Frame"],
			desc = L["Sends reminders to your Raid Warning frame at the center of the screen."],
			order = 20,
			get = function(info)
					return RSA.db.profile.Reminders.RemindChannels.RaidWarn
				end,
			set = function(info, value)
					RSA.db.profile.Reminders.RemindChannels.RaidWarn = value
				end,
		},
	},
}





Paladin = {
	type = "group",
	name = L["Spell Options"],
	desc = L.Spell_Options,
	order = 2,
	childGroups = "tree",
	hidden = function()
				return RSA.db.profile.General.Class ~= "PALADIN"
			end,
	args = {
		ArdentDefender = {
			type = "group",
			name = "Ardent Defender",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.ArdentDefender.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.ArdentDefender.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.ArdentDefender.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.ArdentDefender.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.ArdentDefender.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.ArdentDefender.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End = value
						end,
				},
			},
		},
		AuraMastery = {
			type = "group",
			name = "Aura Mastery",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.AuraMastery.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.AuraMastery.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.AuraMastery.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.AuraMastery.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.AuraMastery.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.AuraMastery.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.AuraMastery.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.AuraMastery.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.AuraMastery.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.AuraMastery.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End = value
						end,
				},
			},
		},
		DivineProtection = {
			type = "group",
			name = "Divine Protection",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineProtection.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineProtection.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineProtection.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineProtection.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.DivineProtection.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.DivineProtection.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineProtection.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineProtection.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End = value
						end,
				},
			},
		},
		Forbearance = {
			type = "group",
			name = "Forbearance",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Forbearance.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Forbearance.Local = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Forbearance.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.Forbearance.Messages.End = value
						end,
				},
			},
		},
		DivineGuardian = {
			type = "group",
			name = "Divine Guardian",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineGuardian.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineGuardian.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineGuardian.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineGuardian.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.DivineGuardian.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.DivineGuardian.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineGuardian.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineGuardian.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineGuardian.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.DivineGuardian.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End = value
						end,
				},
			},
		},
		HandOfFreedom = {
			type = "group",
			name = "Hand Of Freedom",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfFreedom.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfFreedom.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfFreedom.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.HandOfFreedom.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.HandOfFreedom.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End = value
						end,
				},
			},
		},
		HandOfProtection = {
			type = "group",
			name = "Hand Of Protection",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfProtection.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfProtection.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfProtection.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfProtection.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfProtection.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfProtection.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.HandOfProtection.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.HandOfProtection.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End = value
						end,
				},
			},
		},
		HandOfSacrifice = {
			type = "group",
			name = "Hand Of Sacrifice",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSacrifice.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSacrifice.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSacrifice.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.HandOfSacrifice.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.HandOfSacrifice.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End = value
						end,
				},
			},
		},
		HandOfSalvation = {
			type = "group",
			name = "Hand Of Salvation",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSalvation.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSalvation.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSalvation.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.HandOfSalvation.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.HandOfSalvation.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End = value
						end,
				},
			},
		},
		LayOnHands = {
			type = "group",
			name = "Lay On Hands",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.LayOnHands.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.LayOnHands.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.LayOnHands.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.LayOnHands.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.LayOnHands.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.LayOnHands.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.LayOnHands.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.LayOnHands.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.LayOnHands.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.LayOnHands.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.LayOnHands.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.LayOnHands.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescHeal,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start = value
						end,
				},
				--[[End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.LayOnHands.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.LayOnHands.Messages.End = value
						end,
				},]]--
			},
		},
		GoAK = {
			type = "group",
			name = "Guardian of Ancient Kings",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.GoAK.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.GoAK.Local = value
						end,
				},
				--[[Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.GoAK.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.GoAK.Whisper = value
						end,
				},]]--
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.GoAK.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.GoAK.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.GoAK.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.GoAK.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.GoAK.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.GoAK.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.GoAK.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.GoAK.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.GoAK.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.GoAK.Messages.End = value
						end,
				},
			},
		},
		Repentance = {
			type = "group",
			name = "Repentance",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Repentance.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Repentance.Local = value
						end,
				},
				--[[Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Repentance.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Repentance.Whisper = value
						end,
				},]]--
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Repentance.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Repentance.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.Repentance.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.Repentance.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Repentance.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Repentance.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Repentance.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.Repentance.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Repentance.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.Repentance.Messages.End = value
						end,
				},
			},
		},
		Rebuke = {
			type = "group",
			name = "Rebuke",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.Local = value
						end,
				},
				--[[Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.Whisper = value
						end,
				},]]--
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.Rebuke.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.Rebuke.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescInterrupt,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Successful"],
					desc = L.DescSpellStartSuccess,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["Resisted"],
					desc = L.DescSpellEndResist,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.Messages.End = value
						end,
				},
				Immune = {
					type = "input",
					width = "full",
					name = L["Immune"],
					desc = L.DescSpellEndImmune,
					order = 13,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune = value
						end,
				},
			},
		},
		HandOfReckoning = {
			type = "group",
			name = "Hand Of Reckoning",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.Local = value
						end,
				},
				--[[Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.Whisper = value
						end,
				},]]--
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.HandOfReckoning.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.HandOfReckoning.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescMissable,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Successful"],
					desc = L.DescSpellStartSuccess,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["Resisted"],
					desc = L.DescSpellEndResist,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End = value
						end,
				},
				Immune = {
					type = "input",
					width = "full",
					name = L["Immune"],
					desc = L.DescSpellEndImmune,
					order = 13,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune = value
						end,
				},
			},
		},
		RighteousDefense = {
			type = "group",
			name = "Righteous Defense",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.Local = value
						end,
				},
				--[[Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.Whisper = value
						end,
				},]]--
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.RighteousDefense.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.RighteousDefense.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescMissable,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Successful"],
					desc = L.DescSpellStartSuccess,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["Resisted"],
					desc = L.DescSpellEndResist,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End = value
						end,
				},
				Immune = {
					type = "input",
					width = "full",
					name = L["Immune"],
					desc = L.DescSpellEndImmune,
					order = 13,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune = value
						end,
				},
			},
		},
		Beacon = {
			type = "group",
			name = "Beacon Of Light",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Beacon.Local
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Beacon.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Beacon.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Beacon.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Beacon.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Beacon.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Paladin.Spells.Beacon.Party
							end,
					set = function (info, value)
								RSA.db.profile.Paladin.Spells.Beacon.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Beacon.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Paladin.Spells.Beacon.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Beacon.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.Beacon.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Paladin.Spells.Beacon.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Paladin.Spells.Beacon.Messages.End = value
						end,
				},

			},
		},




	},
}

Priest = {
	type = "group",
	name = L["Spell Options"],
	desc = L.Spell_Options,
	order = 2,
	childGroups = "tree",
	hidden = function()
				return RSA.db.profile.General.Class ~= "PRIEST"
			end,
	args = {
		LeapOfFaith = {
			type = "group",
			name = "Leap Of Faith",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.LeapOfFaith.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.LeapOfFaith.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Priest.Spells.LeapOfFaith.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.LeapOfFaith.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.LeapOfFaith.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.LeapOfFaith.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.LeapOfFaith.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.LeapOfFaith.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.LeapOfFaith.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.LeapOfFaith.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.LeapOfFaith.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.LeapOfFaith.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.LeapOfFaith.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.LeapOfFaith.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.LeapOfFaith.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.LeapOfFaith.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.LeapOfFaith.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start = value
						end,
				},
			},
		},
		DivineHymn = {
			type = "group",
			name = "Divine Hymn",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DivineHymn.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DivineHymn.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DivineHymn.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DivineHymn.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.DivineHymn.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DivineHymn.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DivineHymn.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DivineHymn.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DivineHymn.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.DivineHymn.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.DivineHymn.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DivineHymn.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DivineHymn.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DivineHymn.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DivineHymn.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DivineHymn.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.DivineHymn.Messages.End = value
						end,
				},
			},
		},
		HymnOfHope = {
			type = "group",
			name = "Hymn Of Hope",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.HymnOfHope.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.HymnOfHope.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.HymnOfHope.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.HymnOfHope.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.HymnOfHope.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.HymnOfHope.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.HymnOfHope.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.HymnOfHope.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.HymnOfHope.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.HymnOfHope.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.HymnOfHope.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.HymnOfHope.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.HymnOfHope.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.HymnOfHope.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.HymnOfHope.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End = value
						end,
				},
			},
		},
		FearWard = {
			type = "group",
			name = "Fear Ward",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.FearWard.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.FearWard.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Priest.Spells.FearWard.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.FearWard.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.FearWard.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.FearWard.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.FearWard.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.FearWard.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.FearWard.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.FearWard.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.FearWard.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.FearWard.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.FearWard.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.FearWard.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.FearWard.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.FearWard.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.FearWard.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.FearWard.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.FearWard.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Priest.Spells.FearWard.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.FearWard.Messages.End = value
						end,
				},
			},
		},
		Levitate = {
			type = "group",
			name = "Levitate",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Levitate.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Levitate.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Levitate.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Levitate.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Levitate.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Levitate.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.Levitate.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Levitate.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Levitate.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Levitate.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Levitate.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.Levitate.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.Levitate.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Levitate.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Levitate.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Levitate.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Levitate.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Levitate.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.Levitate.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Levitate.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.Levitate.Messages.End = value
						end,
				},
			},
		},
		ShackleUndead = {
			type = "group",
			name = "Shackle Undead",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.ShackleUndead.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.ShackleUndead.Local = value
						end,
				},
				--[[Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Priest.Spells.ShackleUndead.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.ShackleUndead.Whisper = value
						end,
				},]]--
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.ShackleUndead.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.ShackleUndead.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.ShackleUndead.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.ShackleUndead.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.ShackleUndead.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.ShackleUndead.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.ShackleUndead.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.ShackleUndead.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.ShackleUndead.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.ShackleUndead.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.ShackleUndead.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.ShackleUndead.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.ShackleUndead.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End = value
						end,
				},
			},
		},
		DispelMagic = {
			type = "group",
			name = "Dispel Magic",
			order = 11,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DispelMagic.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DispelMagic.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DispelMagic.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DispelMagic.Whisper = value
						end,
				},				
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DispelMagic.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DispelMagic.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input", 
					width = "full",  
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.DispelMagic.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DispelMagic.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DispelMagic.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DispelMagic.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DispelMagic.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.DispelMagic.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.DispelMagic.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DispelMagic.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DispelMagic.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DispelMagic.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.DispelMagic.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescDispel,
					order = 10,
				},
				Start = {
					type = "input", 
					width = "full",  
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start = value
						end,
				},
				End = {
					type = "input", 
					width = "full",  
					name = L["Resisted"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Priest.Spells.DispelMagic.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.DispelMagic.Messages.End = value
						end,
				},
			},
		},
		GuardianSpirit = {
			type = "group",
			name = "Guardian Spirit",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.GuardianSpirit.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.GuardianSpirit.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Priest.Spells.GuardianSpirit.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.GuardianSpirit.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.GuardianSpirit.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.GuardianSpirit.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.GuardianSpirit.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.GuardianSpirit.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.GuardianSpirit.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.GuardianSpirit.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.GuardianSpirit.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.GuardianSpirit.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.GuardianSpirit.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.GuardianSpirit.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.GuardianSpirit.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.GuardianSpirit.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.GuardianSpirit.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End = value
						end,
				},
			},
		},
		PainSuppression = {
			type = "group",
			name = "Pain Suppression",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PainSuppression.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PainSuppression.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PainSuppression.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PainSuppression.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PainSuppression.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PainSuppression.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.PainSuppression.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PainSuppression.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PainSuppression.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PainSuppression.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PainSuppression.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.PainSuppression.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.PainSuppression.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PainSuppression.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PainSuppression.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PainSuppression.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PainSuppression.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PainSuppression.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.PainSuppression.Messages.End = value
						end,
				},
			},
		},
		Lightwell = {
			type = "group",
			name = "Lightwell",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Lightwell.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Lightwell.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Lightwell.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Lightwell.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.Lightwell.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Lightwell.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Lightwell.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Lightwell.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Lightwell.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.Lightwell.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.Lightwell.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Lightwell.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Lightwell.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Lightwell.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.Lightwell.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.Lightwell.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.Lightwell.Messages.Start = value
						end,
				},
			},
		},
		PowerInfusion = {
			type = "group",
			name = "Power Infusion",
			order = 0,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PowerInfusion.Local
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PowerInfusion.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PowerInfusion.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PowerInfusion.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PowerInfusion.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PowerInfusion.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Priest.Spells.PowerInfusion.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PowerInfusion.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PowerInfusion.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PowerInfusion.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PowerInfusion.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Priest.Spells.PowerInfusion.Party
							end,
					set = function (info, value)
								RSA.db.profile.Priest.Spells.PowerInfusion.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PowerInfusion.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PowerInfusion.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PowerInfusion.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Priest.Spells.PowerInfusion.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End = value
						end,
				},
			},
		},
	},
}

Warlock = {
	type = "group",
	name = L["Spell Options"],
	desc = L.Spell_Options,
	order = 2,
	childGroups = "tree",
	hidden = function()
			return RSA.db.profile.General.Class ~= "WARLOCK"
		end,
	args = {
		SoulWell = {
			type = "group",
			name = "Soul Well",
			order = 1,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SoulWell.Local
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SoulWell.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SoulWell.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SoulWell.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input", 
					width = "full",  
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Warlock.Spells.SoulWell.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SoulWell.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SoulWell.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SoulWell.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SoulWell.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Warlock.Spells.SoulWell.Party
							end,
					set = function (info, value)
								RSA.db.profile.Warlock.Spells.SoulWell.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SoulWell.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SoulWell.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SoulWell.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SoulWell.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input", 
					width = "full",  
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start = value
						end,
				},
			},
		},
		SummonStone = {
			type = "group",
			name = "Summon Stone",
			order = 2,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SummonStone.Local
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SummonStone.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SummonStone.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SummonStone.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input", 
					width = "full",  
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Warlock.Spells.SummonStone.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SummonStone.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SummonStone.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SummonStone.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SummonStone.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Warlock.Spells.SummonStone.Party
							end,
					set = function (info, value)
								RSA.db.profile.Warlock.Spells.SummonStone.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SummonStone.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SummonStone.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SummonStone.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SummonStone.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescNoTarget,
					order = 10,
				},
				Start = {
					type = "input", 
					width = "full",  
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start = value
						end,
				},
			},
		},
		SingeMagic = {
			type = "group",
			name = "Imp: Singe Magic",
			order = 8,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SingeMagic.Local
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SingeMagic.Local = value
						end,
				},
				Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SingeMagic.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SingeMagic.Whisper = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SingeMagic.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SingeMagic.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input", 
					width = "full",  
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Warlock.Spells.SingeMagic.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SingeMagic.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SingeMagic.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SingeMagic.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SingeMagic.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Warlock.Spells.SingeMagic.Party
							end,
					set = function (info, value)
								RSA.db.profile.Warlock.Spells.SingeMagic.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SingeMagic.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SingeMagic.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SingeMagic.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SingeMagic.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescDispel,
					order = 10,
				},
				Start = {
					type = "input", 
					width = "full",  
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start = value
						end,
				},
			},
		},
		Banish = {
			type = "group",
			name = "Banish",
			order = 3,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Banish.Local
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Banish.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input", 
					width = "full",  
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Banish.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Banish.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Warlock.Spells.Banish.Party
							end,
					set = function (info, value)
								RSA.db.profile.Warlock.Spells.Banish.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Banish.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Banish.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Banish.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Banish.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input", 
					width = "full",  
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Banish.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Banish.Messages.Start = value
						end,
				},
				End = {
					type = "input", 
					width = "full",  
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Banish.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Banish.Messages.End = value
						end,
				},
			},
		},
		Fear = {
			type = "group",
			name = "Fear",
			order = 4,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Fear.Local
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Fear.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input", 
					width = "full",  
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Fear.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Fear.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Warlock.Spells.Fear.Party
							end,
					set = function (info, value)
								RSA.db.profile.Warlock.Spells.Fear.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Fear.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Fear.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Fear.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Fear.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input", 
					width = "full",  
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Fear.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Fear.Messages.Start = value
						end,
				},
				End = {
					type = "input", 
					width = "full",  
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Fear.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Fear.Messages.End = value
						end,
				},
			},
		},
		Seduce = {
			type = "group",
			name = "Succubus: Seduce",
			order = 9,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Seduce.Local
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Seduce.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input", 
					width = "full",  
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Seduce.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Seduce.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Warlock.Spells.Seduce.Party
							end,
					set = function (info, value)
								RSA.db.profile.Warlock.Spells.Seduce.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Seduce.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Seduce.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Seduce.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Seduce.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescTarget,
					order = 10,
				},
				Start = {
					type = "input", 
					width = "full",  
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Seduce.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Seduce.Messages.Start = value
						end,
				},
				End = {
					type = "input", 
					width = "full",  
					name = L["End"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Seduce.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Seduce.Messages.End = value
						end,
				},
			},
		},
		SpellLock = {
			type = "group",
			name = "Felhunter: Spell Lock",
			order = 10,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SpellLock.Local
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SpellLock.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input", 
					width = "full",  
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SpellLock.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SpellLock.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Warlock.Spells.SpellLock.Party
							end,
					set = function (info, value)
								RSA.db.profile.Warlock.Spells.SpellLock.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SpellLock.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SpellLock.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SpellLock.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.SpellLock.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescInterrupt,
					order = 10,
				},
				Start = {
					type = "input", 
					width = "full",  
					name = L["Successful"],
					desc = L.DescSpellStartSuccess,
					order = 11,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start = value
						end,
				},
				End = {
					type = "input", 
					width = "full",  
					name = L["Resisted"],
					desc = L.DescSpellEndResist,
					order = 12,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SpellLock.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.SpellLock.Messages.End = value
						end,
				},
				Immune = {
					type = "input", 
					width = "full",  
					name = L["Immune"],
					desc = L.DescSpellEndImmune,
					order = 13,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune = value
						end,
				},
			},
		},
		Devour = {
			type = "group",
			name = "Felhunter: Devour Magic",
			order = 11,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Devour.Local
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Devour.Local = value
						end,
				},
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input", 
					width = "full",  
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Devour.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Devour.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Warlock.Spells.Devour.Party
							end,
					set = function (info, value)
								RSA.db.profile.Warlock.Spells.Devour.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Devour.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Devour.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Devour.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Devour.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescDispel,
					order = 10,
				},
				Start = {
					type = "input", 
					width = "full",  
					name = L["Start"],
					desc = L.DescSpellStartCastingMessage,
					order = 11,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Devour.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Devour.Messages.Start = value
						end,
				},
				End = {
					type = "input", 
					width = "full",  
					name = L["Resisted"],
					desc = L.DescSpellEndCastingMessage,
					order = 12,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Devour.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Devour.Messages.End = value
						end,
				},
			},
		},
		Suffering = {
			type = "group",
			name = "Voidwalker: Suffering",
			order = 12,
			args = {
				Title = {
					type = "header",
					name = L["Announce In:"],
					order = 0,
				},
				Local = {
					type = "toggle",
					name = L["Local"],
					order = 1,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.Local
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Suffering.Local = value
						end,
				},
				--[[Whisper = {
					type = "toggle",
					name = L["Whisper"],
					order = 2,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.Whisper
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Suffering.Whisper = value
						end,
				},]]--
				CustomChannelEnabled = {
					type = "toggle",
					name = L["Custom Channel"],
					order = 3,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Enabled
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Enabled = value
						end,
				},
				CustomChannelName = {
					type = "input",
					width = "full",
					name = L["Channel Name"],
					order = 4,
					hidden = function()
							return RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Enabled == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Channel
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Channel = value
						end,
				},
				Raid = {
					type = "toggle",
					name = L["Raid"],
					order = 5,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == true
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.Raid
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Suffering.Raid = value
						end,
				},
				Party = {
					type = "toggle",
					name = L["Party"],
					order = 6,
					hidden = function()
								return RSA.db.profile.General.Smart.RaidParty == true
							end,
					get = function(info)
								return RSA.db.profile.Warlock.Spells.Suffering.Party
							end,
					set = function (info, value)
								RSA.db.profile.Warlock.Spells.Suffering.Party = value
							end,
				},
				---- Smart Raid / Party ----
				RaidParty = {
					type = "toggle",
					name = L["Raid / Party"],
					desc = L["Sends to Raid if you're in a raid, or party if you're in a party."],
					order = 7,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.Smart.RaidParty
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Suffering.Smart.RaidParty = value
						end,
				},
				Say = {
					type = "toggle",
					name = L["Say"],
					desc = L["Sends to say if you are ungrouped."],
					order = 8,
					hidden = function()
							return RSA.db.profile.General.Smart.RaidParty == false or RSA.db.profile.General.Smart.Say == false
						end,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.Smart.Say
						end,
					set = function (info, value)
							RSA.db.profile.Warlock.Spells.Suffering.Smart.Say = value
						end,
				},
				---- Custom Message ----
				Title2 = {
					type = "header",
					name = L["Message"],
					order = 9,
				},
				Description = {
					type = "description",
					name = L.SpellDescMissable,
					order = 10,
				},
				Start = {
					type = "input",
					width = "full",
					name = L["Successful"],
					desc = L.DescSpellStartSuccess,
					order = 11,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.Messages.Start
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Suffering.Messages.Start = value
						end,
				},
				End = {
					type = "input",
					width = "full",
					name = L["Resisted"],
					desc = L.DescSpellEndResist,
					order = 12,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.Messages.End
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Suffering.Messages.End = value
						end,
				},
				Immune = {
					type = "input",
					width = "full",
					name = L["Immune"],
					desc = L.DescSpellEndImmune,
					order = 13,
					get = function(info)
							return RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune
						end,
					set = function(info, value)
							RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune = value
						end,
				},
			},
		},
	},
}


--	},
--}
-- Add lib sink to config options.
--options.args.output = RSA:GetSinkAce3OptionsDataTable()





-----------------------
---- Ace functions ----
-----------------------

function RSA:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("RSADB", defaults) -- Setup Saved Variables
	
	-- Check what class we are and save it. Used to determine what options to show.
	local pClass = select(2, UnitClass("player"))
	self.db.profile.General.Class = pClass
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")	
	
	-- Register Various Options
	LibStub("AceConfig-3.0"):RegisterOptionsTable("RSA", Options) -- Register Options
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("RSA", "Raeli's Spell Announcer") -- Add options to Blizzard interface
	if pClass == "DEATHKNIGHT" then -- Load Class Options
--		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", DeathKnight) -- Register Options
--		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface	
	elseif pClass == "DRUID" then
--		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", Druid) -- Register Options
--		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface	
	elseif pClass == "HUNTER" then
--		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", Hunter) -- Register Options
--		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface	
	elseif pClass == "MAGE" then
--		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", Mage) -- Register Options
--		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface	
	elseif pClass == "PALADIN" then
		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", Paladin) -- Register Options
		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface	
	elseif pClass == "PRIEST" then
		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", Priest) -- Register Options
		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface	
	elseif pClass == "ROGUE" then
--		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", Rogue) -- Register Options
--		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface	
	elseif pClass == "SHAMAN" then
--		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", Shaman) -- Register Options
--		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface	
	elseif pClass == "WARLOCK" then
		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", Warlock) -- Register Options
		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface
	elseif pClass == "WARRIOR" then
--		LibStub("AceConfig-3.0"):RegisterOptionsTable("Spell Options", Warrior) -- Register Options
--		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spell Options", "Spell Options", "Raeli's Spell Announcer") -- Add options to Blizzard interface	
	end
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Reminders", Reminders) -- Register Options
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Reminders", "Buff Reminders", "Raeli's Spell Announcer") -- Add options to Blizzard interface		
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Profile", Profile) -- Register Options
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Profile", "Profile", "Raeli's Spell Announcer") -- Add options to Blizzard interface
	Profile.args.Profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db) -- Add profile management to Blizzard interface
	
	self:RegisterChatCommand("RSA", "ChatCommand") -- Register /RSA command

	--[[  LibSink - Output options to bigwigs etc.
	self:GetSinkAce3OptionsDataTable()
	self:SetSinkStorage(self.db.profile)
	]]--

end

function RSA:RefreshConfig()
	local pClass = select(2, UnitClass("player"))
		self.db.profile.class = pClass
end

function RSA:OnProfileEnable()
	self.db = self.db.profile
	local pClass = select(2, UnitClass("player"))
		self.db.profile.class = pClass
end

function RSA:ChatCommand(input)
	--if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory("Raeli's Spell Announcer")
	--else
--		LibStub("AceConfigCmd-3.0").HandleCommand(RSA, "RSA", "RSA", input)
	--end
end




--------------------------------
---- Announcement Functions ----
--------------------------------

local function Print_Self(message) -- Sends a message to your default chat window.
	_G.ChatFrame1:AddMessage("|cFFFF75B3RSA:|r " .. format(message))
end

local function Print_Raid_Smart(message) -- Sends a message to the raid if you're in a raid, or a party if you're in a party or nothing if you aren't in either.
	if GetNumRaidMembers() > 0 then
		SendChatMessage(format(message), "RAID", nil)
	elseif GetNumPartyMembers() > 0 then
		SendChatMessage(format(message), "PARTY", nil)
	end
end

local function Print_Raid(message)
	if GetNumRaidMembers() > 0 then
		SendChatMessage(format(message), "RAID", nil)
	end
end

local function Print_Party(message)
	if GetNumPartyMembers() > 0 and GetNumRaidMembers() == 0 then
		SendChatMessage(format(message), "PARTY", nil)
	end
end

local function Print_Channel(message, channel) -- Sends a message to the custom channel that the user defines.
	--if GetNumRaidMembers()>0 or GetNumPartyMembers()>0 then
		SendChatMessage(format(message), "CHANNEL", nil, GetChannelName(channel))
	--end
end

local function Print_Self_RW(message) -- Sends a message locally to the raid warning frame. Only visible to the user.
	local RWColor = {r=1, g=1, b=1}
	RaidNotice_AddMessage(RaidWarningFrame, "|cFFFF75B3RSA:|r " .. format(message), RWColor)
end

local function Print_RW(message) -- Sends a proper message to the raid warning frame.
	SendChatMessage(format(message), "RAID_WARNING", nil)
end

local function Print_Whisper(message, target) -- Sends a whisper to the target.
	SendChatMessage(format(message), "WHISPER", nil, target)
end

local function Print_Say(message)
	if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then
		SendChatMessage(format(message), "SAY", nil)
	end
end





-----------------------------
---- Combat Log Checking ----
-----------------------------

local CombatLogMonitor = CreateFrame("Frame", "RSA:CLM")
local pName = UnitName("player")

function RSA_String_Replace(str)
	return RSA_Replacements [str] or str
end
CombatLogMonitor:SetScript("OnEvent", function(_, _, _, event, _, source, _, _, dest, _, spellID, spellName, _, missType)
	local petName = UnitName("pet")
	if source == pName or source == petName then

		if event == "SPELL_AURA_APPLIED" then
--		Death Knights Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior

			if RSA.db.profile.General.Class == "DEATHKNIGHT" then -- Check Class, Set the Spell we're reminding about.
				ReminderSpell = RSA.db.profile.DeathKnight.Reminders.SpellName
			elseif RSA.db.profile.General.Class == "DRUID" then
				ReminderSpell = RSA.db.profile.Druid.Reminders.SpellName
			elseif RSA.db.profile.General.Class == "HUNTER" then
				ReminderSpell = RSA.db.profile.Hunter.Reminders.SpellName
			elseif RSA.db.profile.General.Class == "MAGE" then
				ReminderSpell = RSA.db.profile.Mage.Reminders.SpellName
			elseif RSA.db.profile.General.Class == "PALADIN" then
				ReminderSpell = RSA.db.profile.Paladin.Reminders.SpellName
			elseif RSA.db.profile.General.Class == "PRIEST" then
				ReminderSpell = RSA.db.profile.Priest.Reminders.SpellName
			elseif RSA.db.profile.General.Class == "ROGUE" then
				ReminderSpell = RSA.db.profile.Rogue.Reminders.SpellName
			elseif RSA.db.profile.General.Class == "SHAMAN" then
				ReminderSpell = RSA.db.profile.Shaman.Reminders.SpellName
			elseif RSA.db.profile.General.Class == "WARLOCK" then
				ReminderSpell = RSA.db.profile.Warlock.Reminders.SpellName
			elseif RSA.db.profile.General.Class == "WARRIOR" then
				ReminderSpell = RSA.db.profile.Warrior.Reminders.SpellName
			end
			if spellName == ReminderSpell and dest == pName then
				RSA_Reminder:SetScript("OnUpdate", nil)
				if RSA.db.profile.Reminders.RemindChannels.Chat == true then
					Print_Self(ReminderSpell .. " Refreshed!")
				end
				if RSA.db.profile.Reminders.RemindChannels.RaidWarn == true then
					Print_Self_RW(ReminderSpell .. " Refreshed!")
				end
			end
			
			-- PALADIN
			if spellID == 62124 then -- HAND OF RECKONING
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, "%a+", RSA_String_Replace))
						end
					end

				end
			end -- HAND OF RECKONING
			if spellID == 31790 then -- RIGHTEOUS DEFENSE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.RighteousDefense.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.RighteousDefense.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- RIGHTEOUS DEFENSE	
			if spellID == 70940 and dest == pName then -- DIVINE GUARDIAN
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.DivineGuardian.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.DivineGuardian.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.DivineGuardian.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.DivineGuardian.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.DivineGuardian.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineGuardian.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- DIVINE GUARDIAN		
			if spellID == 86150 or spellID == 86657 or spellID == 86674 or spellID == 86701 then -- GUARDIAN OF ANCIENT KINGS
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.GoAK.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.GoAK.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.GoAK.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.GoAK.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- GUARDIAN OF ANCIENT KINGS
			if spellID == 25771 then -- FORBEARANCE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.Forbearance.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.Forbearance.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.Forbearance.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.Forbearance.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.Forbearance.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.Forbearance.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.Forbearance.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Forbearance.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- FORBEARANCE			

			--PRIEST
			if spellID == 9484 then -- SHACKLE UNDEAD
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.ShackleUndead.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.ShackleUndead.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.ShackleUndead.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.ShackleUndead.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.ShackleUndead.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.ShackleUndead.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.ShackleUndead.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SHACKLE UNDEAD					
			
			-- WARLOCK
			if spellID == 17735 or spellID == 47990 then -- SUFFERING LATTER WRATH ONLY.
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Warlock.Spells.Suffering.Messages.Start ~= "" then
					if RSA.db.profile.Warlock.Spells.Suffering.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Suffering.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Suffering.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Suffering.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Suffering.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Start, "%a+", RSA_String_Replace))
						end
					end

				end
			end -- SUFFERING
			if spellID == 18647 then -- BANISH
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Warlock.Spells.Banish.Messages.Start ~= "" then
					if RSA.db.profile.Warlock.Spells.Banish.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Banish.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Banish.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Banish.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Banish.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- BANISH			
			if spellID == 5782 or spellID == 6215 then -- FEAR LATTER WRATH ONLY.
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Warlock.Spells.Fear.Messages.Start ~= "" then
					if RSA.db.profile.Warlock.Spells.Fear.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Fear.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Fear.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Fear.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Fear.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- FEAR
			if spellID == 6358 then -- SEDUCE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Warlock.Spells.Seduce.Messages.Start ~= "" then
					if RSA.db.profile.Warlock.Spells.Seduce.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Seduce.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Seduce.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Seduce.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Seduce.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SEDUCE				
			
		end -- IF EVENT IS SPELL_AURA_APPLIED



		
		if event == "SPELL_CAST_SUCCESS" then

			-- PALADIN
			if spellID == 31850 then -- ARDENT DEFENDER
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.ArdentDefender.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.ArdentDefender.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- ARDENT DEFENDER
			if spellID == 31821 then -- AURA MASTERY
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.AuraMastery.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.AuraMastery.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.AuraMastery.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.AuraMastery.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.AuraMastery.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AuraMastery.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- AURA MASTERY
			if spellID == 498 then -- DIVINE PROTECTION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.DivineProtection.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.DivineProtection.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.DivineProtection.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- DIVINE PROTECTION
			if spellID == 1044 then -- HAND OF FREEDOM
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfFreedom.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfFreedom.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HAND OF FREEDOM
			if spellID == 1022 or spellID == 10278 then -- HAND OF PROTECTION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfProtection.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfProtection.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HAND OF PROTECTION
			if spellID == 6940 then -- HAND OF SACRIFICE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HAND OF SACRIFICE
			if spellID == 1038 then -- HAND OF SALVATION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfSalvation.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfSalvation.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HAND OF SALVATION
			if spellID == 20066 then -- REPENTANCE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.Repentance.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.Repentance.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.Repentance.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.Repentance.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.Repentance.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- REPENTANCE
			if spellID == 53563 then -- BEACON OF LIGHT
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.Beacon.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.Beacon.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.Beacon.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.Beacon.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.Beacon.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- BEACON OF LIGHT

			-- PRIEST
			if spellID == 73325 then -- LEAP OF FAITH
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.LeapOfFaith.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.LeapOfFaith.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.LeapOfFaith.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.LeapOfFaith.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.LeapOfFaith.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.LeapOfFaith.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.LeapOfFaith.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.LeapOfFaith.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.LeapOfFaith.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- LEAP OF FAITH
			if spellID == 64843 then -- DIVINE HYMN
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.DivineHymn.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.DivineHymn.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Priest.Spells.DivineHymn.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.DivineHymn.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.DivineHymn.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.DivineHymn.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.DivineHymn.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.DivineHymn.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- DIVINE HYMN
			if spellID == 64901 then -- HYMN OF HOPE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.HymnOfHope.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.HymnOfHope.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Priest.Spells.HymnOfHope.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.HymnOfHope.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.HymnOfHope.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.HymnOfHope.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.HymnOfHope.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.HymnOfHope.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HYMN OF HOPE	
			if spellID == 6346 then -- FEAR WARD
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.FearWard.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.FearWard.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.FearWard.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.FearWard.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.FearWard.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.FearWard.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.FearWard.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.FearWard.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.FearWard.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- FEAR WARD
			if spellID == 1706 then -- LEVITATE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.Levitate.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.Levitate.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.Levitate.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.Levitate.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.Levitate.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.Levitate.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.Levitate.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.Levitate.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.Levitate.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- LEVITATE			
			if spellID == 47788 then -- GUARDIAN SPIRIT
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.GuardianSpirit.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.GuardianSpirit.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.GuardianSpirit.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.GuardianSpirit.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.GuardianSpirit.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.GuardianSpirit.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.GuardianSpirit.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.GuardianSpirit.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- GUARDIAN SPIRIT			
			if spellID == 33206 then -- PAIN SUPPRESSION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.PainSuppression.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.PainSuppression.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.PainSuppression.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.PainSuppression.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.PainSuppression.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.PainSuppression.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.PainSuppression.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.PainSuppression.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- PAIN SUPPRESSION			
			if spellID == 10060 then -- POWER INFUSION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.PowerInfusion.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.PowerInfusion.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.PowerInfusion.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.PowerInfusion.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.PowerInfusion.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.PowerInfusion.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.PowerInfusion.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.PowerInfusion.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- POWER INFUSION			
			
			-- WARLOCK
			if spellID == 58887 then -- SOUL WELL
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start ~= "" then
					if RSA.db.profile.Warlock.Spells.SoulWell.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.SoulWell.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Warlock.Spells.SoulWell.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.SoulWell.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.SoulWell.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.SoulWell.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.SoulWell.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.SoulWell.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.SoulWell.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SOUL WELL
			if spellID == 698 then -- SUMMONING STONE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start ~= "" then
					if RSA.db.profile.Warlock.Spells.SummonStone.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.SummonStone.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Warlock.Spells.SummonStone.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.SummonStone.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.SummonStone.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.SummonStone.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.SummonStone.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.SummonStone.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.SummonStone.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SUMMONING STONE					
		
		end -- IF EVENT IS SPELL_CAST_SUCCESS

		
		
		
		
		if event == "SPELL_SUMMON" then
		
			-- PRIEST
			if spellID == 724 then -- LIGHTWELL
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.Lightwell.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.Lightwell.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.Lightwell.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.Lightwell.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.Lightwell.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.Lightwell.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Priest.Spells.Lightwell.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.Lightwell.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.Lightwell.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.Lightwell.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.Lightwell.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.Lightwell.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.Lightwell.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.Lightwell.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.Lightwell.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.Lightwell.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.Lightwell.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- LIGHTWELL	
		
		end




		
		if event == "SPELL_INTERRUPT" then

			-- PALADIN
			if spellID == 85285 then -- REBUKE
				spellinfo = GetSpellInfo(spellID)
				extraspellinfo = GetSpellInfo(missType)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["TARCAST"] = extraspellinfo,}
				if RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.Rebuke.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.Rebuke.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.Rebuke.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- REBUKE

			-- WARLOCK
			if spellID == 19647 then -- SPELL LOCK
				spellinfo = GetSpellInfo(spellID)
				extraspellinfo = GetSpellInfo(missType)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["TARCAST"] = extraspellinfo,}
				if RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start ~= "" then
					if RSA.db.profile.Warlock.Spells.SpellLock.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.SpellLock.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.SpellLock.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.SpellLock.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.SpellLock.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SPELL LOCK

		end -- IF EVENT IS SPELL_INTERRUPT

		
		


		if event == "SPELL_HEAL" then

			if spellID == 633 or spellID == 48788 then -- LAY ON HANDS LATTER IS WRATH ONLY.
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["AMOUNT"] = missType,}
				if RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start ~= "" then
					if RSA.db.profile.Paladin.Spells.LayOnHands.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.LayOnHands.Whisper == true and dest ~= pName  then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.LayOnHands.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.LayOnHands.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.LayOnHands.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.LayOnHands.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- LAY ON HANDS

		end -- IF EVENT IS SPELL_HEAL

		
		
		

		if event == "SPELL_AURA_REMOVED" then

			-- PALADIN
			if spellID == 31850 then -- ARDENT DEFENDER
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.ArdentDefender.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.ArdentDefender.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- ARDENT DEFENDER
			if spellID == 31821 then -- AURA MASTERY
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.AuraMastery.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.AuraMastery.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.AuraMastery.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.AuraMastery.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.AuraMastery.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.AuraMastery.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AuraMastery.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.AuraMastery.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- AURA MASTERY
			if spellID == 498 then -- DIVINE PROTECTION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.DivineProtection.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.DivineProtection.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.DivineProtection.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- DIVINE PROTECTION
			if spellID == 25771 and dest == pName then -- FORBEARANCE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.Forbearance.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.Forbearance.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					--[[if RSA.db.profile.Paladin.Spells.Forbearance.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.Forbearance.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.Forbearance.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.Forbearance.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.Forbearance.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.Forbearance.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Forbearance.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.End, "%a+", RSA_String_Replace))
						end
					end]]--
				end
			end -- FORBEARANCE
			if spellID == 70940 and dest == pName then -- DIVINE GUARDIAN
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.DivineGuardian.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.DivineGuardian.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.DivineGuardian.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.DivineGuardian.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.DivineGuardian.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.DivineGuardian.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineGuardian.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivineGuardian.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- DIVINE GUARDIAN
			if spellID == 1044 then -- HAND OF FREEDOM
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfFreedom.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfFreedom.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HAND OF FREEDOM
			if spellID == 1022 or spellID == 10278 then -- HAND OF PROTECTION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfProtection.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfProtection.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, "%a+", RSA_String_Replace), dest)
							RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HAND OF PROTECTION
			if spellID == 6940 then -- HAND OF SACRIFICE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HAND OF SACRIFICE
			if spellID == 1038 then -- HAND OF SALVATION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfSalvation.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfSalvation.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HAND OF SALVATION
			if spellID == 86150 or spellID == 86657 or spellID == 86674 or spellID == 86701 then -- GUARDIAN OF ANCIENT KINGS
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.GoAK.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.GoAK.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.GoAK.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.GoAK.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- GUARDIAN OF ANCIENT KINGS
			if spellID == 20066 then -- REPENTANCE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.Repentance.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.Repentance.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.Repentance.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.Repentance.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.Repentance.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- REPENTANCE
			if spellID == 53563 then -- BEACON OF LIGHT
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Paladin.Spells.Beacon.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.Beacon.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.Beacon.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.Beacon.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.Beacon.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- BEACON OF LIGHT

			-- PRIEST
			if spellID == 64843 then -- DIVINE HYMN
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.DivineHymn.Messages.End ~= "" then
					if RSA.db.profile.Priest.Spells.DivineHymn.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.DivineHymn.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Priest.Spells.DivineHymn.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.DivineHymn.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.DivineHymn.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.DivineHymn.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.DivineHymn.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.DivineHymn.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.DivineHymn.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- DIVINE HYMN
			if spellID == 64901 then -- HYMN OF HOPE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End ~= "" then
					if RSA.db.profile.Priest.Spells.HymnOfHope.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.HymnOfHope.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Priest.Spells.HymnOfHope.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.HymnOfHope.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.HymnOfHope.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.HymnOfHope.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.HymnOfHope.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.HymnOfHope.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.HymnOfHope.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- HYMN OF HOPE			
			if spellID == 6346 then -- FEAR WARD
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.FearWard.Messages.End ~= "" then
					if RSA.db.profile.Priest.Spells.FearWard.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.FearWard.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.End, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.FearWard.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.FearWard.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.FearWard.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.FearWard.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.FearWard.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.FearWard.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.FearWard.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- FEAR WARD
			if spellID == 1706 then -- LEVITATE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.Levitate.Messages.End ~= "" then
					if RSA.db.profile.Priest.Spells.Levitate.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.Levitate.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.End, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.Levitate.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.Levitate.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.Levitate.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.Levitate.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.Levitate.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.Levitate.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.Levitate.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- LEVITATE				
			if spellID == 9484 then -- SHACKLE UNDEAD
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End ~= "" then
					if RSA.db.profile.Priest.Spells.ShackleUndead.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.ShackleUndead.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.ShackleUndead.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.ShackleUndead.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.ShackleUndead.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.ShackleUndead.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.ShackleUndead.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.ShackleUndead.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SHACKLE UNDEAD				
			if spellID == 47788 then -- GUARDIAN SPIRIT
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End ~= "" then
					if RSA.db.profile.Priest.Spells.GuardianSpirit.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.GuardianSpirit.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.GuardianSpirit.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.GuardianSpirit.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.GuardianSpirit.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.GuardianSpirit.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.GuardianSpirit.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.GuardianSpirit.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.GuardianSpirit.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- GUARDIAN SPIRIT
			if spellID == 33206 then -- PAIN SUPPRESSION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.PainSuppression.Messages.End ~= "" then
					if RSA.db.profile.Priest.Spells.PainSuppression.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.PainSuppression.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.End, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.PainSuppression.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.PainSuppression.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.PainSuppression.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.PainSuppression.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.PainSuppression.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.PainSuppression.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.PainSuppression.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- PAIN SUPPRESSION			
			if spellID == 10060 then -- POWER INFUSION
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End ~= "" then
					if RSA.db.profile.Priest.Spells.PowerInfusion.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.PowerInfusion.Whisper == true and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You",}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
					end
					if RSA.db.profile.Priest.Spells.PowerInfusion.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.PowerInfusion.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.PowerInfusion.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.PowerInfusion.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.PowerInfusion.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.PowerInfusion.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.PowerInfusion.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- POWER INFUSION	
			
			-- WARLOCK
			if spellID == 18647 then -- BANISH
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Warlock.Spells.Banish.Messages.End ~= "" then
					if RSA.db.profile.Warlock.Spells.Banish.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Banish.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Banish.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Banish.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Banish.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Banish.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Banish.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- BANISH
			if spellID == 5782 or spellID == 6215 then -- FEAR LATTER WRATH ONLY.
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Warlock.Spells.Fear.Messages.End ~= "" then
					if RSA.db.profile.Warlock.Spells.Fear.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Fear.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Fear.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Fear.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Fear.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Fear.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Fear.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- FEAR
			if spellID == 6358 then -- SEDUCE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest,}
				if RSA.db.profile.Warlock.Spells.Seduce.Messages.End ~= "" then
					if RSA.db.profile.Warlock.Spells.Seduce.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Seduce.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Seduce.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Seduce.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Seduce.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Seduce.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Seduce.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SEDUCE			
			
		end -- IF EVENT IS SPELL_AURA_REMOVED

		


		
		if event == "SPELL_DISPEL" then
		
			-- PRIEST
			if spellID == 527 then -- DISPEL MAGIC
				spellinfo = GetSpellInfo(spellID)
				extraspellinfo = GetSpellInfo(missType)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["AURA"] = extraspellinfo,}
				if RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start ~= "" then
					if RSA.db.profile.Priest.Spells.DispelMagic.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Priest.Spells.DispelMagic.Whisper == true and dest ~= pName and dest ~= pName and UnitIsPlayer(dest) and UnitIsFriend(pName, dest) then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You", ["AURA"] = extraspellinfo,}
						Print_Whisper(string.gsub(RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["AURA"] = extraspellinfo,}
					end
					if RSA.db.profile.Priest.Spells.DispelMagic.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Priest.Spells.DispelMagic.CustomChannel.Channel)
					end
					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Priest.Spells.DispelMagic.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Priest.Spells.DispelMagic.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Priest.Spells.DispelMagic.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Priest.Spells.DispelMagic.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Priest.Spells.DispelMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- DISPEL MAGIC			
			
		
			-- WARLOCK
			if spellID == 89808 then -- SINGE MAGIC
				spellinfo = GetSpellInfo(spellID)
				extraspellinfo = GetSpellInfo(missType)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["AURA"] = extraspellinfo,}
				if RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start ~= "" then
					if RSA.db.profile.Warlock.Spells.SingeMagic.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.SingeMagic.Whisper == true and dest ~= pName and dest ~= pName then
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = "You", ["AURA"] = extraspellinfo,}
						Print_Whisper(string.gsub(RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start, "%a+", RSA_String_Replace), dest)
						RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["AURA"] = extraspellinfo,}
					end
					if RSA.db.profile.Warlock.Spells.SingeMagic.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.SingeMagic.CustomChannel.Channel)
					end
					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.SingeMagic.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.SingeMagic.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.SingeMagic.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.SingeMagic.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.SingeMagic.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SINGE MAGIC
			if spellID == 19505 or spellID == 48011 then -- DEVOUR MAGIC LATTER WRATH ONLY.
				spellinfo = GetSpellInfo(spellID)
				extraspellinfo = GetSpellInfo(missType)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["AURA"] = extraspellinfo,}
				if RSA.db.profile.Warlock.Spells.Devour.Messages.Start ~= "" then
					if RSA.db.profile.Warlock.Spells.Devour.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.Start, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Channel)
					end
					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Devour.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Devour.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Devour.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.Start, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Devour.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.Start, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- DEVOUR MAGIC			
			
		end -- IF EVENT IS SPELL_DISPEL
		
		
		
		
		
		if event == "SPELL_DISPEL_FAILED" then
		
			if spellID == 19505 or spellID == 48011 then -- DEVOUR MAGIC LATTER WRATH ONLY.
				spellinfo = GetSpellInfo(spellID)
				extraspellinfo = GetSpellInfo(missType)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["AURA"] = extraspellinfo,}
				if RSA.db.profile.Warlock.Spells.Devour.Messages.End ~= "" then
					if RSA.db.profile.Warlock.Spells.Devour.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Devour.CustomChannel.Channel)
					end
					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Devour.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Devour.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Devour.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Devour.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Devour.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- DEVOUR MAGIC			
		
		end -- IF EVENT IS SPELL_DISPEL_FAILED
		
		
		
		
		
		if event == "SPELL_MISSED" and missType ~= "IMMUNE" then

			if spellID == 85285 then -- REBUKE
				spellinfo = GetSpellInfo(spellID)
				if missType == "MISS" then
					missinfo = "Missed"
				elseif missType ~= "MISS" then
					missinfo = "Resisted"
				end
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = missinfo,}
				if RSA.db.profile.Paladin.Spells.Rebuke.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.Rebuke.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.Rebuke.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.Rebuke.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- REBUKE
			if spellID == 62124 then -- HAND OF RECKONING
				spellinfo = GetSpellInfo(spellID)
				if missType == "MISS" then
					missinfo = "Missed"
				elseif missType ~= "MISS" then
					missinfo = "Resisted"
				end
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = missinfo,}
				if RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, "%a+", RSA_String_Replace))
						end
					end

				end
			end -- HAND OF RECKONING
			if spellID == 31789 then -- RIGHTEOUS DEFENSE
				spellinfo = GetSpellInfo(spellID)
				if missType == "MISS" then
					missinfo = "Missed"
				elseif missType ~= "MISS" then
					missinfo = "Resisted"
				end
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = missinfo,}
				if RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End ~= "" then
					if RSA.db.profile.Paladin.Spells.RighteousDefense.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.RighteousDefense.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- RIGHTEOUS DEFENSE

			-- WARLOCK
			if spellID == 19647 then -- SPELL LOCK
				spellinfo = GetSpellInfo(spellID)
				if missType == "MISS" then
					missinfo = "Missed"
				elseif missType ~= "MISS" then
					missinfo = "Resisted"
				end
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = missinfo,}
				if RSA.db.profile.Warlock.Spells.SpellLock.Messages.End ~= "" then
					if RSA.db.profile.Warlock.Spells.SpellLock.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.SpellLock.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.SpellLock.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.SpellLock.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.SpellLock.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.SpellLock.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.End, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SPELL LOCK
			if spellID == 17735 or spellID == 47990 then -- SUFFERING LATTER WRATH ONLY.
				spellinfo = GetSpellInfo(spellID)
				if missType == "MISS" then
					missinfo = "Missed"
				elseif missType ~= "MISS" then
					missinfo = "Resisted"
				end
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = missinfo,}
				if RSA.db.profile.Warlock.Spells.Suffering.Messages.End ~= "" then
					if RSA.db.profile.Warlock.Spells.Suffering.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Suffering.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.End, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.End, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Suffering.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Suffering.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.End, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Suffering.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.End, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Suffering.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.End, "%a+", RSA_String_Replace))
						end
					end

				end
			end -- SUFFERING			
			
		end -- IF EVENT IS SPELL_MISSED AND NOT IMMUNE

		
		


		if event == "SPELL_MISSED" and missType == "IMMUNE" then

			if spellID == 85285 then -- REBUKE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = "Immune",}
				if RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune ~= "" then
					if RSA.db.profile.Paladin.Spells.Rebuke.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.Rebuke.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.Rebuke.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- REBUKE
			if spellID == 62124 then -- HAND OF RECKONING
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = "Immune",}
				if RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune ~= "" then
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end

				end
			end -- HAND OF RECKONING
			if spellID == 31789 then -- RIGHTEOUS DEFENSE
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = "Immune",}
				if RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune ~= "" then
					if RSA.db.profile.Paladin.Spells.RighteousDefense.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Paladin.Spells.RighteousDefense.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune, "%a+", RSA_String_Replace), RSA.db.profile.Paladin.Spells.RighteousDefense.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.RighteousDefense.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.RighteousDefense.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- RIGHTEOUS DEFENSE

			-- WARLOCK
			if spellID == 19647 then -- SPELL LOCK
				spellinfo = GetSpellInfo(spellID)
				if missType == "MISS" then
					missinfo = "Missed"
				elseif missType ~= "MISS" then
					missinfo = "Resisted"
				end
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = missinfo,}
				if RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune ~= "" then
					if RSA.db.profile.Warlock.Spells.SpellLock.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.SpellLock.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.SpellLock.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.SpellLock.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.SpellLock.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.SpellLock.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.SpellLock.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.SpellLock.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
				end
			end -- SPELL LOCK
			if spellID == 17735 or spellID == 47990 then -- SUFFERING LATTER WRATH ONLY.
				spellinfo = GetSpellInfo(spellID)
				RSA_Replacements = {["SPELL"] = spellinfo, ["TARGET"] = dest, ["MISSTYPE"] = "Immune",}
				if RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune ~= "" then
					if RSA.db.profile.Warlock.Spells.Suffering.Local == true then
						if RSA.db.profile.General.Local.RaidWarn == true then
							Print_Self_RW(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.General.Local.Chat == true then
							Print_Self(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.Warlock.Spells.Suffering.Whisper == true then
						Print_Whisper(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune, "%a+", RSA_String_Replace), dest)
					end
					if RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Enabled == true then
						Print_Channel(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune, "%a+", RSA_String_Replace), RSA.db.profile.Warlock.Spells.Suffering.CustomChannel.Channel)
					end

					if (RSA.db.profile.General.Smart.RaidParty == true and RSA.db.profile.General.Smart.Say == true) then
						if RSA.db.profile.Warlock.Spells.Suffering.Smart.Say == true then
							Print_Say(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == true then
						if RSA.db.profile.Warlock.Spells.Suffering.Smart.RaidParty == true then
							Print_Raid_Smart(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end
					if RSA.db.profile.General.Smart.RaidParty == false then
						if RSA.db.profile.Warlock.Spells.Suffering.Party == true then
							Print_Party(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune, "%a+", RSA_String_Replace))
						end
						if RSA.db.profile.Warlock.Spells.Suffering.Raid == true then
							Print_Raid(string.gsub(RSA.db.profile.Warlock.Spells.Suffering.Messages.Immune, "%a+", RSA_String_Replace))
						end
					end

				end
			end -- SUFFERING			


		end -- IF EVENT IS SPELL_MISSED AND IS IMMUNE

		
		


	end -- IF SOURCE IS PLAYER

end) -- END ENTIRELY
CombatLogMonitor:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")




----------------------------------
---- Spell Reminder Functions ----
----------------------------------

--[[ Detect what talent spec we are ]]--
	local numTalents, maxTemp, returnIndex
	local tt = {}
function RSA_GetSpec() -- GetPrimarySpecInfo(player) gets player's talent spec.
	numTalents = 0
	tt = wipe(tt)
	local name, iconTexture, pointsSpent, background
	local level = UnitLevel("player");
	local hasSpec = not ( level > 0 and level < 10 )
	for i = 1, GetNumTalentTabs() do
	  local name, iconTexture, pointsSpent, background = GetTalentTabInfo(i)
	  if numTalents <= pointsSpent then
		 numTalents = pointsSpent
		 tt[i] = {name, iconTexture, pointsSpent, background}
		 returnIndex = i
	  end
	end
	-- returns name, iconTexture, pointsSpent, background
	if hasSpec and GetNumTalentTabs() > 0 then
	  return tt[returnIndex][1] -- Spec Name
	  --, tempTable[returnIndex][2], tempTable[returnIndex][3], tempTable[returnIndex][4]
	end
end

--[[ Spell Reminder ]]--
local ReminderTimeElapsed = 0.0
RSA_Reminder = CreateFrame("Frame", "RSA:R")
local function Reminder(self, elapsed)
	if RSA.db.profile.General.Class == "DEATHKNIGHT" then -- Check Class, Set the Spell we're reminding about.
		ReminderSpell = RSA.db.profile.DeathKnight.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "DRUID" then
		ReminderSpell = RSA.db.profile.Druid.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "HUNTER" then
		ReminderSpell = RSA.db.profile.Hunter.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "MAGE" then
		ReminderSpell = RSA.db.profile.Mage.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "PALADIN" then
		ReminderSpell = RSA.db.profile.Paladin.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "PRIEST" then
		ReminderSpell = RSA.db.profile.Priest.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "ROGUE" then
		ReminderSpell = RSA.db.profile.Rogue.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "SHAMAN" then
		ReminderSpell = RSA.db.profile.Shaman.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "WARLOCK" then
		ReminderSpell = RSA.db.profile.Warlock.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "WARRIOR" then
		ReminderSpell = RSA.db.profile.Warrior.Reminders.SpellName
	end
	if ReminderSpell == "" then return end
	if RSA.db.profile.Reminders.DisableInPvP == true and UnitIsPVP("player") then return end
	ReminderTimeElapsed = ReminderTimeElapsed + elapsed
	if ReminderTimeElapsed < RSA.db.profile.Reminders.RemindInterval then return end
	ReminderTimeElapsed = ReminderTimeElapsed - floor(ReminderTimeElapsed)
	local name = UnitBuff("player", ReminderSpell)
	if name == ReminderSpell then
		RSA_Reminder:SetScript("OnUpdate", nil)
	end
	if UnitIsDeadOrGhost("player") == 1 then return end
	if RSA.db.profile.Reminders.EnableInSpec1 == true then
		if GetActiveTalentGroup("player") == 1 then
			if RSA.db.profile.Reminders.RemindChannels.Chat == true then
				Print_Self(ReminderSpell .. " is Missing!")
			end
			if RSA.db.profile.Reminders.RemindChannels.RaidWarn == true then
				Print_Self_RW(ReminderSpell .. " is Missing!")
			end
		end
	end
	if RSA.db.profile.Reminders.EnableInSpec2 == true then
		if GetActiveTalentGroup("player") == 2 then
			if RSA.db.profile.Reminders.RemindChannels.Chat == true then
				Print_Self(ReminderSpell .. " is Missing!")
			end
			if RSA.db.profile.Reminders.RemindChannels.RaidWarn == true then
				Print_Self_RW(ReminderSpell .. " is Missing!")
			end
		end
	end
end

RSA_Monitor = CreateFrame("Frame", "RSA:M")
local MonitorTimeElapsed = 0.0
local function Monitor(self, elapsed)
	MonitorTimeElapsed = MonitorTimeElapsed + elapsed
	if MonitorTimeElapsed < RSA.db.profile.Reminders.CheckInterval then return end
	MonitorTimeElapsed = MonitorTimeElapsed - floor(MonitorTimeElapsed)
	if RSA.db.profile.General.Class == "DEATHKNIGHT" then -- Check Class, Set the Spell we're reminding about.
		ReminderSpell = RSA.db.profile.DeathKnight.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "DRUID" then
		ReminderSpell = RSA.db.profile.Druid.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "HUNTER" then
		ReminderSpell = RSA.db.profile.Hunter.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "MAGE" then
		ReminderSpell = RSA.db.profile.Mage.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "PALADIN" then
		ReminderSpell = RSA.db.profile.Paladin.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "PRIEST" then
		ReminderSpell = RSA.db.profile.Priest.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "ROGUE" then
		ReminderSpell = RSA.db.profile.Rogue.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "SHAMAN" then
		ReminderSpell = RSA.db.profile.Shaman.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "WARLOCK" then
		ReminderSpell = RSA.db.profile.Warlock.Reminders.SpellName
	elseif RSA.db.profile.General.Class == "WARRIOR" then
		ReminderSpell = RSA.db.profile.Warrior.Reminders.SpellName
	end
	if ReminderSpell == "" then return end
	local name = UnitBuff("player", ReminderSpell)
	if name ~= ReminderSpell then
		RSA_Reminder:SetScript("OnUpdate", Reminder)
	end
end
RSA_Monitor:SetScript("OnUpdate", Monitor)


--[[
		Reminders = {
			DisableInPvP = true,
			EnableInSpec1 = true,
			EnableInSpec2 = false,
			ScrollWheel = {
				Enabled = false,
				WheelUp = "",
				WheelDown = "",
			},
			CheckInterval = 10,
			RemindInterval = 15,
			RemindChannels = {
				Chat = true,
				RaidWarn = true,
				]]--

--[[local function Reminder(self, elapsed)
	if InCombatLockdown() then return end -- If we're in combat, do nothing.
	if SA.db.profile.PVPOnOff == true and UnitIsPVP("player") then return end -- If we want to disable in PVP and we are PVP active, do nothing.
	ReminderTimeElapsed = ReminderTimeElapsed + elapsed
	if ReminderTimeElapsed < SA.db.profile.RTime then return end
	ReminderTimeElapsed = ReminderTimeElapsed - floor(ReminderTimeElapsed)
	local name, rank, icon, count, debuffType, duration, expirationTime, source, isStealable = UnitBuff("player", ReminderSpell)
	if name == ReminderSpell then return end -- If the spell we're reminding about is up, stop reminding straight away.
	if UnitIsDeadOrGhost("player") == 1 then return	end
	if (SA.db.profile.pally.RF.RFR == true and SA.db.profile.pally.RF.RFOn == true and SA.db.profile.class == "PALADIN" and UnitIsDeadOrGhost("player") ~= 1)
	or (SA.db.profile.priest.IF.IFR == true and SA.db.profile.class == "PRIEST" and UnitIsDeadOrGhost("player") ~= 1)
	or (SA.db.profile.warlock.DemA.DemAR == true and SA.db.profile.class == "WARLOCK" and UnitIsDeadOrGhost("player") ~= 1)
	or (SA.db.profile.warlock.FelA.FelAR == true and SA.db.profile.class == "WARLOCK" and UnitIsDeadOrGhost("player") ~= 1) == true
	then
		Print_Self(ReminderSpell .. " is missing!")
	end
end]]--



--[[ Buff Check Delay ]]--
--[[
RSA_BuffMonitor = CreateFrame("Frame", "RSA_BuffMonitor")
local MonitorTimeElapsed = 0.0
local function Monitor(self, elapsed)
	if InCombatLockdown() then return end -- If we're in combat, do nothing.
	if RSA.db.profile.PVPOnOff == true and UnitIsPVP("player") then return end -- If we want to disable in PVP and we are PVP active, do nothing.
	MonitorTimeElapsed = MonitorTimeElapsed + elapsed
	if MonitorTimeElapsed < RSA.db.profile.CTime then return end -- If we haven't waited at least <Config Amount> seconds, then do nothing.
	MonitorTimeElapsed = MonitorTimeElapsed - floor(MonitorTimeElapsed)
	RSA_Reminder:SetScript("OnEvent", Reminder) -- Start the buff checker.
end--End Monitor Function
RSA_BuffMonitor:SetScript("OnUpdate", Monitor)]]--

--[[ Main Buff Checking Function ]]--

--[[
SA_Reminder = CreateFrame("Frame", "SA_Reminder")
local function Reminder(arg1, event, target)
	if InCombatLockdown() or UnitIsDeadOrGhost("player") then return end
	if SA.db.profile.PVPOnOff == true and UnitIsPVP("player") then return end -- If we want to disable in PVP and we are PVP active, do nothing.
	if SA.db.profile.class == "PALADIN" then -- Check we're a Paladin.
		if SA.db.profile.pally.RF.RFOn == true then -- Start Righteous Fury
			if (SA.db.profile.pally.RF.RFPD == true and SA_GetSpec(player) == "Protection") or (SA.db.profile.pally.RF.RFPD == false) then
			local name, rank, icon, count, debuffType, duration, expirationTime, source, isStealable = UnitBuff("player", "Righteous Fury")
				if name == "Righteous Fury" then -- Righteous Fury is up.
					SA_Reminder:SetScript("OnUpdate", nil)
				elseif name ~= "Righteous Fury" then
					ReminderSpell = "Righteous Fury"
					if SA.db.profile.pally.RF.RFR == true and not UnitIsDeadOrGhost("player") then
						SA_Reminder:SetScript("OnUpdate", Reminder)
					end
					if SA.db.profile.pally.RF.RFSW == true and not UnitIsDeadOrGhost("player") then
						SA_BindUpdate()
						UIParent:SetScript("OnMouseWheel", Rebinder)
						UIParent:EnableMouseWheel(1)
					end
				end
			elseif SA.db.profile.pally.RF.RFPD == true and SA_GetSpec(player) ~= "Protection" then
				SA_Reminder:SetScript("OnUpdate", nil)
			end
		end
	end -- End Paladin Section

	SA_Reminder:SetScript("OnEvent", nil)
end
SA_Reminder:RegisterEvent("UNIT_AURA")
SA_Reminder:RegisterEvent("PLAYER_REGEN_ENABLED")
SA_Reminder:RegisterEvent("ADDON_LOADED")
SA_Reminder:RegisterEvent("UNIT_MANA")
SA_Reminder:RegisterEvent("PLAYER_TALENT_UPDATE")]]--