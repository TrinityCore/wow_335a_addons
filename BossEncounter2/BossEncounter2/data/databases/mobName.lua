local Root = BossEncounter2;

Root.MobNameDatabase = { };

-- --------------------------------------------------------------------
-- **                          Database                              **
-- --------------------------------------------------------------------

-- Here are listed the names of important mobs.
-- This database purpose is to list important add names in the various encounters
-- so as to ease the process of making the add rows clickable.

local mobNames = {
    ["default"] = {
        [33329] = "Heart of the Deconstructor",

        [32897] = "Field Medic Penny",
        [33326] = "Field Medic Jessi",
        [32893] = "Missy Flamecuffs",
        [33327] = "Sissy Flamecuffs",
        [32901] = "Ellie Nightfeather",
        [33325] = "Eivi Nightfeather",
        [32900] = "Elementalist Avuun",
        [33328] = "Elementalist Mahfuun",
        [32948] = "Battle-Priest Eliza",
        [33330] = "Battle-Priest Gina",
        [32946] = "Veesha Blazeweaver",
        [33331] = "Amira Blazeweaver",
        [32941] = "Tor Greycloud",
        [33333] = "Kar Greycloud",
        [32950] = "Spiritwalker Yona",
        [33332] = "Spiritwalker Tara",

        [32919] = "Storm Lasher",
        [32916] = "Snaplasher",
        [33202] = "Ancient Water Spirit",
        [33203] = "Ancient Conservator",

        [33432] = "Leviathan Mk II",
        [33651] = "VX-001",
        [33670] = "Aerial Command Unit",

        [34796] = "Gormok the Impaler",
        [35144] = "Acidmaw",
        [34799] = "Dreadscale",
        [34797] = "Icehowl",

        [34826] = "Mistress of Pain",
        [34825] = "Nether Portal",
        [34813] = "Infernal Volcano",

        [36561] = "Onyxian Lair Guard",

        [36619] = "Bone Spike",
        [38712] = "Bone Spike",
        [38711] = "Bone Spike",

        [37697] = "Volatile Ooze",
        [37562] = "Gas Cloud",
    },

    ["frFR"] = {
        [33329] = "Coeur du déconstructeur",

        [32897] = "Infirmière militaire Penny",
        [33326] = "Infirmière militaire Jessi",
        [32893] = "Missy Crispeflamme",
        [33327] = "Sissy Crispeflamme",
        [32901] = "Ellie Plumenuit",
        [33325] = "Eivi Plumenuit",
        [32900] = "Elémentaliste Avuun",
        [33328] = "Elémentaliste Mahfuun",
        [32948] = "Prêtresse de bataille Eliza",
        [33330] = "Prêtresse de bataille Gina",
        [32946] = "Veesha Tissebrasier",
        [33331] = "Amira Tissebrasier",
        [32941] = "Tor Nuage-gris",
        [33333] = "Kar Nuage-gris",
        [32950] = "Marcheuse des esprits Yona",
        [33332] = "Marcheuse des esprits Tara",

        [32919] = "Flagellant des tempêtes",
        [32916] = "Flagellant mordant",
        [33202] = "Esprit de l'eau ancien",
        [33203] = "Ancien conservateur",

        [33432] = "Léviathan Mod. II",
        [33651] = "VX-001",
        [33670] = "Unité de commandement aérien",

        [34796] = "Gormok l'Empaleur",
        [35144] = "Gueule-d'acide",
        [34799] = "Ecaille-d'effroi",
        [34797] = "Glace-hurlante",

        [34826] = "Maîtresse de Douleur",
        [34825] = "Portail du Néant",
        [34813] = "Volcan infernal",

        [36561] = "Garde du repaire onyxien",

        [36619] = "Pointe d'os",
        [38712] = "Pointe d'os",
        [38711] = "Pointe d'os",

        [37697] = "Limon volatil",
        [37562] = "Nuage de gaz",
    },
};

-- --------------------------------------------------------------------
-- **                          Functions                             **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> MobNameDatabase -> GetFromID(mobID)                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> mobID: the mob ID (not GUID! Mob ID is a component of GUID)   *
-- ********************************************************************
-- * Grabs the localized mob name from a mob ID.                      *
-- ********************************************************************

function Root.MobNameDatabase.GetFromID(mobID)
    if not mobID then return nil; end
    local locale = mobNames[GetLocale()] or mobNames["default"];
    return locale[mobID];
end