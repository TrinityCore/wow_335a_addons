local Root = BossEncounter2;

Root.NPCDatabase = { };

-- --------------------------------------------------------------------
-- **                          Database                              **
-- --------------------------------------------------------------------

-- Only put basic bosses that do not require specific modules.
-- Specific modules have to do a call to the Register method of the
-- NPC database to register their boss NPC in the NPC database.

local triggerInfo = {
    -- ****
    -- Test
    -- ****

    -- *******
    -- Classic
    -- *******

    -- ***
    -- TBC
    -- ***

    -- *****
    -- WotLK
    -- *****

    -- CoT4
    -- >>>>

    [26529] = { -- Meathook
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK1",
            ignoreCombatDelay = true,
        },
    },

    [26530] = { -- Salramm
        module = "BasicEncounter",
        extraTable = {
            music = "TIER7_TANKNSPANK1",
            ignoreCombatDelay = true,
        },
    },

    [26532] = { -- Epoch
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK2",
        },
    },

    [26533] = { -- Mal'Ganis
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_DPSRACE1",
            clearTrigger = {
                ["default"] = "Your journey has just begun",
                ["frFR"] = "Votre voyage",
            },
        },
    },

    [32273] = { -- Infinite corruptor
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MECHANICAL",
        },
    },

    -- Violet Hold
    -- >>>>>>>>>>>

    -- Main bosses

    [29315] = { -- Erekem
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK2",
        },
    },

    [29316] = { -- Moragg
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK1",
        },
    },

    [29313] = { -- Ichoron
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_SURVIVAL1",
        },
    },

    [29266] = { -- Xevozz
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_SURVIVAL2",
        },
    },

    [29312] = { -- Lavanthor
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_TANKNSPANK1",
        },
    },

    [29314] = { -- Zuramat
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_DPSRACE1",
        },
    },

    [31134] = { -- Cyanigosa
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MIGHT",
        },
    },

    -- Alt bosses (on wipes)

    [32230] = { -- Void lord (Zuramat)
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_DPSRACE1",
        },
    },

    [32237] = { -- Lava Hound (Lavanthor)
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_TANKNSPANK1",
        },
    },

    [32231] = { -- Ethereal Wind Trader (Xevozz)
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_SURVIVAL2",
        },
    },

    [32226] = { -- Arakkoa Windwalker (Erekem)
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK2",
        },
    },

    [32235] = { -- Chaos Watcher (Moragg)
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK1",
        },
    },

    [32234] = { -- Swirling Water Revenant (Ichoron)
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_SURVIVAL1",
        },
    },

    -- Utgarde Pinnacle
    -- >>>>>>>>>>>>>>>>

    [26668] = { -- Svala
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MIGHT",
        },
    },

    [26687] = { -- Gortok
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_DPSRACE1",
        },
    },

    [26693] = { -- Skadi
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_SURVIVAL1",
            preMusic = "PREPARATION_GENERAL",
            adds = {26893},
            timeOut = 180,
            ignoreWipe = true,
            ignoreLeaveCombat = true,
            ignoreAdds = true,
            engageTrigger = {
                ["default"] = "What mongrels dare intrude here",
                ["frFR"] = "Quels chiens osent s'introduire",
            },
        },
    },

    [26861] = { -- Ymiron
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_FINALBOSS",
            preMusic = "PREPARATION_GENERAL",
        },
    },

    -- Utgarde Keep
    -- >>>>>>>>>>>>

    [23953] = { -- Keleseth
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK2",
        },
    },

    [24200] = { -- Skarvald & Dalron (TODO: might want to flag none as main boss)
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK1",
            title = "Skarvald & Dalron",
            adds = {24201},
            ignoreAdds = false,
        },
    },

    [23954] = { -- Ingvar
        module = "BasicEncounter",
        extraTable = {
            timeOut = 60,
            music = "TIER4_FINALBOSS",
            preMusic = "PREPARATION_GENERAL",
            ignoreStandardClear = true,
            clearTrigger = {
                ["default"] = "No%! I can do",
                ["frFR"] = "Je peux faire",
            },
        },
    },

    -- Drak'Tharon Keep
    -- >>>>>>>>>>>>>>>>

    [26630] = { -- Trollgore 
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_DPSRACE2",
            safeEngage = true,
        },
    },

    [26631] = { -- Novos
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_EASY",
            timeOut = 240,
        },
    },

    [27483] = { -- Dred
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_SURVIVAL1",
        },
    },

    [26632] = { -- Tharon'ja
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_FINALBOSS",
        },
    },

    -- Gundrak
    -- >>>>>>>

    [29304] = { -- Slad'ran
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_SURVIVAL1",
        },
    },

    [29307] = { -- Drakkari Colossus
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_SURVIVAL2",
            timeOut = 180,
        },
    },

    [29305] = { -- Moorabi
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_DPSRACE1",
        },
    },

    [29306] = { -- Gal'darah
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_FINALBOSS",
            preMusic = "PREPARATION_GENERAL",
        },
    },

    [29932] = { -- Eck
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_EASY",
        },
    },

    -- Ahn'kahet
    -- >>>>>>>>>

    [29309] = { -- Nadox
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MIGHT",
        },
    },

    [29308] = { -- Teldaram
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_DPSRACE2",
            distanceChecker = 15,
        },
    },

    [29310] = { -- Jedoga
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK2",
            timeOut = 40,
            clearTrigger = {
                ["default"] = "Do not expect your sacrilege",
                ["frFR"] = "Ne croyez pas que votre",
            },
        },
    },

    [29311] = { -- Volazj
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MADNESS",
            preMusic = "PREPARATION_GENERAL",
            timeOut = 180,
        },
    },

    [30258] = { -- Amanitar
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK2",
        },
    },

    -- Azjol
    -- >>>>>

    [28684] = { -- Krik'thir the Gatewatcher (special module like tribunal ?)
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK1",
        },
    },

    [28921] = { -- Hadronox 
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MIGHT",
            safeEngage = true,
        },
    },

    [29120] = { -- Anub'arak (Azjol)
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_FINALBOSS",
            preMusic = "PREPARATION_BADGUY",
            timeOut = 180,
            healthThresholds = {
                { value = 0.75,
                  label = {
                      ["default"] = "Anub'arak burrows (1)",
                      ["frFR"] = "Anub'arak s'enfouit (1)",
                  },
                },
                { value = 0.50,
                  label = {
                      ["default"] = "Anub'arak burrows (2)",
                      ["frFR"] = "Anub'arak s'enfouit (2)",
                  },
                },
                { value = 0.25,
                  label = {
                      ["default"] = "Anub'arak burrows (3)",
                      ["frFR"] = "Anub'arak s'enfouit (3)",
                  },
                },
            },
        },
    },

    -- Nexus
    -- >>>>>

    [26731] = { -- Grand Magus Telestra
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_SURVIVAL1",
            timeOut = 180,
            healthThresholds = {
                { value = 0.50,
                  label = {
                      ["default"] = "Clones",
                      ["frFR"] = "Clones",
                  },
                },
            },
        },
    },

    [26763] = { -- Anomalus
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_SURVIVAL2",
            timeOut = 60,
            healthThresholds = {
                { value = 0.50,
                  label = {
                      ["default"] = "Chaotic Rift",
                      ["frFR"] = "Faille chaotique",
                  },
                },
            },
        },
    },

    [26794] = { -- Ormorok
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK2",
        },
    },

    [26796] = { -- Commander Stoutbeard (Horde)
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MIGHT",
        },
    },

    [26798] = { -- Commander Kolurg (Alliance)
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MIGHT",
        },
    },

    [26723] = { -- Keristrasza
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_FINALBOSS",
            preMusic = "PREPARATION_GENERAL",
            healthThresholds = {
                { value = 0.25,
                  label = {
                      ["default"] = "Keristrasza gets enraged",
                      ["frFR"] = "Keristrasza devient enragée",
                  },
                },
            },
        },
    },

    -- Halls of Lightning
    -- >>>>>>>>>>>>>>>>>>

    [28586] = { -- General Bjarngrim
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MIGHT",
        },
    },
    [28587] = { -- Volkhan
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_SURVIVAL2",
        },
    },
    [28546] = { -- Ionar
        module = "BasicEncounter",
        extraTable = {
            music = "TIER4_SURVIVAL3",
            distanceChecker = 6,
            timeOut = 50,
        },
    },
    -- Loken has his own speshul module.

    -- Halls of Stone
    -- >>>>>>>>>>>>>>

    [27977] = { -- Krystallus
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MIGHT",
            distanceChecker = 20,
        },
    },
    [27975] = { -- Maiden of Grief
        module = "BasicEncounter",
        extraTable = {
            music = "TIER5_DPSRACE1",
        },
    },
    [27978] = { -- Sjonnir the Ironshaper
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK2",
            preMusic = "PREPARATION_GENERAL",
            healthThresholds = {
                { value = 0.10,
                  label = {
                      ["default"] = "Dwarves arrival",
                      ["frFR"] = "Arrivée des nains",
                  },
                },
            },
        },
    },
    -- Tribunal has its own speshul module.

    -- Oculus
    -- >>>>>>

    [27654] = { -- Drakos the Interrogator
        module = "BasicEncounter",
        extraTable = {
            music = "TIER6_SURVIVAL1",
        },
    },
    [27447] = { -- Varos Cloudstrider
        module = "BasicEncounter",
        extraTable = {
            music = "TIER6_TANKNSPANK2",
        },
    },
    [27655] = { -- Mage-Lord Urom
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK3",
            safeEngage = true,
        },
    },
    -- Eregos has his own speshul module.

    -- Trial of the Champion
    -- >>>>>>>>>>>>>>>>>>>>>

    -- Champions have their own speshul module.
    [34928] = { -- Paletress
        module = "BasicEncounter",
        extraTable = {
            timeOut = 180,
            music = "TIER6_SURVIVAL2",
            title = "Paletress",
            clearAnimation = "ALTERNATE",
            clearTrigger = {
                ["default"] = "Excellent work",
                ["frFR"] = "beau travail",
            },
        },
    },
    [35119] = { -- Eadric
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK1",
            title = "Eadric",
            clearAnimation = "ALTERNATE",
            clearTrigger = {
                ["default"] = "I submit",
                ["frFR"] = "Je me rends",
            },
        },
    },
    -- Black Knight has his own speshul module.

    -- Forge of Souls
    -- >>>>>>>>>>>>>>

    [36497] = { -- Bronjahm
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_DPSRACE3",
            timeOut = 60,
            healthThresholds = {
                { value = 0.30,
                  label = {
                      ["default"] = "Soulstorm",
                      ["frFR"] = "Tempête d'âmes",
                  },
                },
            },
        },
    },
    -- Devourer of Souls has its own speshul module.

    -- Pit of Saron
    -- >>>>>>>>>>>>

    [36494] = { -- Garfrost
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_TANKNSPANK2",
            timeOut = 60,
            healthThresholds = {
                { value = 0.66,
                  label = {
                      ["default"] = "Phase 2",
                      ["frFR"] = "Phase 2",
                  },
                },
                { value = 0.33,
                  label = {
                      ["default"] = "Phase 3",
                      ["frFR"] = "Phase 3",
                  },
                },
            },
        },
    },

    [36476] = { -- Ick & Krick
        module = "BasicEncounter",
        extraTable = {
            music = "WORLD_SURVIVAL2",
        },
    },

    [36658] = { -- Tyrannus
        module = "BasicEncounter",
        extraTable = {
            music = "THEME_MIGHT",
            preMusic = "PREPARATION_BADGUY",
        },
    },

    -- Halls of Reflection
    -- >>>>>>>>>>>>>>>>>>>

    [38112] = { -- Falric
        module = "BasicEncounter",
        extraTable = {
            music = "TIER9_DPSRACE3",
            volatile = true,
        },
    },
    [38113] = { -- Marwyn
        module = "BasicEncounter",
        extraTable = {
            music = "TIER9_DPSRACE3",
            volatile = true,
        },
    },
    -- Escape the Lich King has its own speshul module.
}

-- --------------------------------------------------------------------
-- **                          Functions                             **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> NPCDatabase -> GetTriggerInfo(mobID)                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> mobID: the mob ID (not GUID! Mob ID is a component of GUID)   *
-- ********************************************************************
-- * Grabs eventual trigger info relevant to the given mob ID.        *
-- * Nil if no trigger is set for the given mob ID.                   *
-- ********************************************************************

function Root.NPCDatabase.GetTriggerInfo(mobID)
    if not mobID then return nil; end
    return triggerInfo[mobID] or nil;
end

-- ********************************************************************
-- * Root -> NPCDatabase -> Register(mobID, module, volatile, bypass) *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> mobID: the mob ID (not GUID! Mob ID is a component of GUID)   *
-- * >> module: the module name supposed to handle the encounter.     *
-- * >> volatile: specify whether the NPC spawns suddenly and so has  *
-- * to be fired whenever someone in the whole raid targets it.       *
-- * >> bypass: sets whether checks on the NPC are bypassed or not.   *
-- * Checks notably include "is the NPC enemy ?".                     *
-- ********************************************************************
-- * Register from an external way (such as within a boss module) a   *
-- * NPC ID to monitor. The associated module will be run whenever    *
-- * the local player targets a NPC with this ID. Volatile NPCs       *
-- * (see above) will fire the module if only 1 person in the raid    *
-- * targets this type of NPC.                                        *
-- ********************************************************************

function Root.NPCDatabase.Register(mobID, module, volatile, bypass)
    if not mobID then return nil; end
    triggerInfo[mobID] = {
        module = module,
        extraTable = nil,
        volatile = volatile,
        bypass = bypass,
    };
end
