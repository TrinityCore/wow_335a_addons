--[[
Name: RatingBuster frFR locale (incomplete)
Revision: $Revision: 282 $
Translated by:
- Tixu@Curse, Silaor and renchap
]]

local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "frFR")
if not L then return end
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend NotePad++ or Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: L["Show Item ID"] = true,
-- After:  L["Show Item ID"] = "顯示物品編號",
---------------
-- Waterfall --
---------------
L["RatingBuster Options"] = "Options de RatingBuster"
L["Waterfall-1.0 is required to access the GUI."] = "Waterfall-1.0 est nécessaire pour accéder au GUI."
L["Enabled"] = "Activé"
L["Suspend/resume this addon"] = "Active ou non cet addon."
---------------------------
-- Slash Command Options --
---------------------------
L["Always"] = "Toujours"
L["ALT Key"] = "Touche ALT"
L["CTRL Key"] = "Touche CTRL"
L["SHIFT Key"] = "Touche MAJ"
L["Never"] = "Jamais"
L["General Settings"] = "Paramètres généraux"
L["Profiles"] = "Profiles"
-- /rb win
L["Options Window"] = "Options de la fenêtre"
L["Shows the Options Window"] = "Affiche la fenêtre des options"
-- /rb hidebzcomp
L["Hide Blizzard Item Comparisons"] = "Masquer la comparaison d'objet de Blizzard"
--L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = true -- à traduire
-- /rb statmod
L["Enable Stat Mods"] = "Activer les Stat Mods"
L["Enable support for Stat Mods"] = "Activer le support pour Stat Mods"
-- /rb avoidancedr
--L["Enable Avoidance Diminishing Returns"] = true -- à traduire
--L["Dodge, Parry, Hit Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = true -- à traduire
-- /rb itemid
L["Show ItemID"] = "Afficher l'ID de l'objet"
L["Show the ItemID in tooltips"] = "Affiche l'ID d'un objet dans l'infobulle."
-- /rb itemlevel
L["Show ItemLevel"] = "Afficher le niveau de l'objet"
L["Show the ItemLevel in tooltips"] = "Affiche le niveau de l'objet dans l'infobulle."
-- /rb usereqlv
L["Use Required Level"] = "Utiliser le niveau requis"
L["Calculate using the required level if you are below the required level"] = "Effectue les calculs en utilisant le niveau requis par l'objet si il n'est pas atteint."
-- /rb level
L["Set Level"] = "Définir le niveau"
L["Set the level used in calculations (0 = your level)"] = "Définir le niveau utilisé dans les calculs (0 = votre niveau)."
---------------------------------------------------------------------------
-- /rb rating
L["Rating"] = "Score"
L["Options for Rating display"] = "Options pour l'affichage des scores"
-- /rb rating show
L["Show Rating Conversions"] = "Afficher la conversion des scores"
L["Show Rating conversions in tooltips"] = "Affiche dans l'infobulle les gains apportés par le score."
-- /rb rating spell
--L["Show Spell Hit/Haste"] = true
--L["Show Spell Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating physical
--L["Show Physical Hit/Haste"] = true
--L["Show Physical Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating detail
--L["Show Detailed Conversions Text"] = true -- à traduire
--L["Show detailed text for Resilience and Expertise conversions"] = true -- à traduire
-- /rb rating def
--L["Defense Breakdown"] = true -- à traduire
--L["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = true
-- /rb rating wpn
--L["Weapon Skill Breakdown"] = true -- à traduire
--L["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = true -- à traduire
-- /rb rating exp
--L["Expertise Breakdown"] = true -- à traduire
--L["Convert Expertise into Dodge Neglect and Parry Neglect"] = true -- à traduire
---------------------------------------------------------------------------
-- /rb rating color
L["Change Text Color"] = "Modifier la couleur du texte"
--L["Changes the color of added text"] = true -- à traduire
-- /rb rating color pick
L["Pick Color"] = "Sélectionner une couleur"
L["Pick a color"] = "Choisissez une couleur"
-- /rb rating color enable
L["Enable Color"] = true
L["Enable colored text"] = true
---------------------------------------------------------------------------
-- /rb stat
--L["Stat Breakdown"] = true -- à traduire
L["Changes the display of base stats"] = "Modifie l'affichage des caractéristiques de base."
-- /rb stat show
L["Show Base Stat Conversions"] = "Afficher les conversions pour les statistiques de base"
L["Show base stat conversions in tooltips"] = "Affiche les conversions pour les statistiques de base dans l'infobulle."
---------------------------------------------------------------------------
-- /rb stat str
L["Strength"] = "Force"
L["Changes the display of Strength"] = "Modifie l'affichage de la force."
-- /rb stat str ap
L["Show Attack Power"] = "Afficher la puissance d'attaque"
L["Show Attack Power from Strength"] = "Affiche la puissance d'attaque apporté par la force."
-- /rb stat str block
L["Show Block Value"] = "Afficher le bloquage"
L["Show Block Value from Strength"] = "Affiche le bloquage apporté par la force."
-- /rb stat str dmg
L["Show Spell Damage"] = "Afficher les dégats des sorts"
L["Show Spell Damage from Strength"] = "Affiche le bonus de dégats des sorts apporté par la force."
-- /rb stat str heal
L["Show Healing"] = "Afficher les soins"
L["Show Healing from Strength"] = "Affiche le bonus aux soins apporté par la force."
-- /rb stat str parry
L["Show Parry"] = "Afficher la parade"
L["Show Parry from Strength"] = "Affiche la parade apporté par la force."
---------------------------------------------------------------------------
-- /rb stat agi
L["Agility"] = "Agilité"
L["Changes the display of Agility"] = "Modifie l'affichage de l'agilité"
-- /rb stat agi crit
L["Show Crit"] = "Afficher le critique"
L["Show Crit chance from Agility"] = "Affiche le pourcentage de critique apporté par l'agilité."
-- /rb stat agi dodge
L["Show Dodge"] = "Afficher l'esquive"
L["Show Dodge chance from Agility"] = "Affiche le pourcentage d'esquive apporté par l'agilité."
-- /rb stat agi ap
L["Show Attack Power"] = "Afficher la puissance d'attaque"
L["Show Attack Power from Agility"] = "Affiche la puissance d'attaque apporté par l'agilité."
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "Afficher la puissance d'attaque à distance"
L["Show Ranged Attack Power from Agility"] = "Affiche la puissance d'attaque à distance apporté par l'agilité."
-- /rb stat agi armor
L["Show Armor"] = "Afficher l'armure"
L["Show Armor from Agility"] = "Afficher l'armure apporté par l'agilité"
-- /rb stat agi heal
L["Show Healing"] = "Afficher les soins"
L["Show Healing from Agility"] = "Affiche la parade apporté par l'agilité."
---------------------------------------------------------------------------
-- /rb stat sta
L["Stamina"] = "Endurance"
L["Changes the display of Stamina"] = "Modifie l'affichage de l'endurance"
-- /rb stat sta hp
L["Show Health"] = "Afficher les points de vies"
L["Show Health from Stamina"] = "Affiche les points de vies apporté par l'endurance."
-- /rb stat sta dmg
L["Show Spell Damage"] = "Afficher les dégats des sorts"
L["Show Spell Damage from Stamina"] = "Affiche le bonus de dégats des sorts apporté par l'endurance."
-- /rb stat sta heal
L["Show Healing"] = "Afficher les soins"
L["Show Healing from Stamina"] = "Affiche les soins apporté par l'endurance."
-- /rb stat sta ap
L["Show Attack Power"] = "Afficher la puissance d'attaque"
L["Show Attack Power from Stamina"] = "Affiche la puissance d'attaque apporté par l'endurance."
---------------------------------------------------------------------------
-- /rb stat int
L["Intellect"] = "Intelligence"
L["Changes the display of Intellect"] = "Modifie l'affichage de l'intelligence"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Afficher le critique des sorts"
L["Show Spell Crit chance from Intellect"] = "Affiche le critique des sorts apporté par l'intelligence."
-- /rb stat int mp
L["Show Mana"] = "Afficher la mana"
L["Show Mana from Intellect"] = "Affiche la mana apporté par l'intelligence."
-- /rb stat int dmg
L["Show Spell Damage"] = "Afficher les dégats des sorts"
L["Show Spell Damage from Intellect"] = "Afficher les dégats des sorts apporté par l'intelligence."
-- /rb stat int heal
L["Show Healing"] = "Afficher les soins"
L["Show Healing from Intellect"] = "Affiche les soins apporté par l'intelligence."
-- /rb stat int mp5
L["Show Mana Regen"] = "Afficher la mana/5sec"
L["Show Mana Regen while casting from Intellect"] = "Affiche la mana/5sec apporté par l'intelligence."
-- /rb stat int mp5nc
L["Show Mana Regen while NOT casting"] = "Afficher la mana/5sec hors cast"
L["Show Mana Regen while NOT casting from Intellect"] = "Affiche la mana/sec hors cast apporté par l'intelligence."
-- /rb stat int rap
L["Show Ranged Attack Power"] = "Afficher la puissance d'attaque à distance"
L["Show Ranged Attack Power from Intellect"] = "Affiche la puissance d'attaque à distance apporté par l'intelligence."
-- /rb stat int armor
L["Show Armor"] = "Afficher l'armure"
L["Show Armor from Intellect"] = "Affiche l'armure apporté par l'intelligence."
-- /rb stat int ap
L["Show Attack Power"] = "Afficher la puissance d'attaque"
L["Show Attack Power from Intellect"] = "Affiche la puissance d'attaque apporté par l'intelligence."
---------------------------------------------------------------------------
-- /rb stat spi
L["Spirit"] = "Esprit"
L["Changes the display of Spirit"] = "Modifie l'affichage de l'esprit"
-- /rb stat spi mp5
L["Show Mana Regen"] = "Afficher la mana/5sec"
L["Show Mana Regen while casting from Spirit"] = "Affiche la mana/5sec apporté par l'esprit."
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "Afficher la mana/5sec hors cast"
L["Show Mana Regen while NOT casting from Spirit"] = "Affiche la mana/sec hors cast apporté par l'esprit."
-- /rb stat spi hp5
L["Show Health Regen"] = "Afficher la vie/5sec"
L["Show Health Regen from Spirit"] = "Affiche la vie/5sec apporté par l'esprit."
-- /rb stat spi dmg
L["Show Spell Damage"] = "Afficher les dégats des sorts"
L["Show Spell Damage from Spirit"] = "Afficher les dégats des sorts apporté par l'esprit."
-- /rb stat spi heal
L["Show Healing"] = "Afficher les soins"
L["Show Healing from Spirit"] = "Affiche les soins apporté par l'esprit."
-- /rb stat spi spellcrit
L["Show Spell Crit"] = "Afficher le critique des sorts"
L["Show Spell Crit chance from Spirit"] = "Affiche le critique des sorts apporté par l'esprit."
---------------------------------------------------------------------------
-- /rb stat armor
L["Armor"] = "Armure"
L["Changes the display of Armor"] = "Modifie l'affichage de l'armure"
-- /rb stat armor ap
L["Show Attack Power"] = "Afficher la puissance d'attaque"
L["Show Attack Power from Armor"] = "Affiche la puissance d'attaque apporté par l'armure"
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = true
L["Options for stat summary"] = true
-- /rb sum show
L["Show Stat Summary"] = true
L["Show stat summary in tooltips"] = true
-- /rb sum ignore
L["Ignore Settings"] = true
L["Ignore stuff when calculating the stat summary"] = true
-- /rb sum ignore unused
L["Ignore Undesirable Items"] = true
L["Hide stat summary for undesirable items"] = true
-- /rb sum ignore quality
L["Minimum Item Quality"] = true
L["Show stat summary only for selected quality items and up"] = true
-- /rb sum ignore armor
L["Armor Types"] = true
L["Select armor types you want to ignore"] = true
-- /rb sum ignore armor cloth
L["Ignore Cloth"] = true
L["Hide stat summary for all cloth armor"] = true
-- /rb sum ignore armor leather
L["Ignore Leather"] = true
L["Hide stat summary for all leather armor"] = true
-- /rb sum ignore armor mail
L["Ignore Mail"] = true
L["Hide stat summary for all mail armor"] = true
-- /rb sum ignore armor plate
L["Ignore Plate"] = true
L["Hide stat summary for all plate armor"] = true
-- /rb sum ignore equipped
L["Ignore Equipped Items"] = true
L["Hide stat summary for equipped items"] = true
-- /rb sum ignore enchant
L["Ignore Enchants"] = true
L["Ignore enchants on items when calculating the stat summary"] = true
-- /rb sum ignore gem
L["Ignore Gems"] = true
L["Ignore gems on items when calculating the stat summary"] = true
-- /rb sum ignore prismaticSocket
L["Ignore Prismatic Sockets"] = true
L["Ignore gems in prismatic sockets when calculating the stat summary"] = true
-- /rb sum diffstyle
L["Display Style For Diff Value"] = true
L["Display diff values in the main tooltip or only in compare tooltips"] = true
-- /rb sum space
L["Add Empty Line"] = true
L["Add a empty line before or after stat summary"] = true
-- /rb sum space before
L["Add Before Summary"] = true
L["Add a empty line before stat summary"] = true
-- /rb sum space after
L["Add After Summary"] = true
L["Add a empty line after stat summary"] = true
-- /rb sum icon
L["Show Icon"] = true
L["Show the sigma icon before summary listing"] = true
-- /rb sum title
L["Show Title Text"] = true
L["Show the title text before summary listing"] = true
-- /rb sum showzerostat
L["Show Zero Value Stats"] = true
L["Show zero value stats in summary for consistancy"] = true
-- /rb sum calcsum
L["Calculate Stat Sum"] = true
L["Calculate the total stats for the item"] = true
-- /rb sum calcdiff
L["Calculate Stat Diff"] = true
L["Calculate the stat difference for the item and equipped items"] = true
-- /rb sum sort
L["Sort StatSummary Alphabetically"] = true
L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = true
-- /rb sum avoidhasblock
L["Include Block Chance In Avoidance Summary"] = true
L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = true
---------------------------------------------------------------------------
-- /rb sum basic
L["Stat - Basic"] = "Stat - Basic"
L["Choose basic stats for summary"] = "Choisissez les statistiques de base pour le résumé."
-- /rb sum basic hp
L["Sum Health"] = "Cumul Vie"
L["Health <- Health, Stamina"] = "Vie <- Vie, Endu"
-- /rb sum stat mp
L["Sum Mana"] = "Cumul Mana"
L["Mana <- Mana, Intellect"] = "Mana <- Mana, Intel"
-- /rb sum stat ap
L["Sum Attack Power"] = "Cumul PA"
L["Attack Power <- Attack Power, Strength, Agility"] = "PA <- PA, Force, Agi"
-- /rb sum basic mp5
L["Sum Mana Regen"] = "Cumul Regen Mana"
L["Mana Regen <- Mana Regen, Spirit"] = "Regen Mana <- Regen Mana, Esprit"
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = "Cumul PA Dist"
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "PA Dist <- PA Dist, Intel, PA, Force, Agi"
-- /rb sum stat fap
L["Sum Feral Attack Power"] = "Cumul PA Farouche"
L["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "PA Farouche <- PA Farouche, PA, Force, Agi"
-- /rb sum stat dmg
L["Sum Spell Damage"] = "Cumul Dégats des Sorts"
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Dégats des Sorts <- Dégats des Sorts, Intel, Esprit, Endu"
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = "Cumul DS Sacré"
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "DS Sacré <- DS Sacré, DS, Intel, Esprit"
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = "Cumul DS Arcane"
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "DS Arcane <- DS Arcane, DS, Intel"
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = "Cumul DS Feu"
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "DS Feu <- DS Feu, DS, Intel, Endu"
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = "Cumul DS Nature"
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "DS Nature <- DS Nature, DS, Intel"
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = "Cumul DS Givre"
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "DS Givre <- DS Givre, DS, Intel"
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = "Cumul DS Ombre"
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "DS Ombre <- DS Ombre, DS, Intel, Esprit, Endu"
-- /rb sum stat heal
L["Sum Healing"] = "Cumul Soins"
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Soins <- Soins, Intel, Esprit, Agi, Force"
-- /rb sum stat hit
L["Sum Hit Chance"] = "Cumul Toucher"
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Toucher <- Toucher, Score Arme"
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = "Cumul Toucher des Sorts"
L["Spell Hit Chance <- Spell Hit Rating"] = "Toucher des Sorts <- Toucher des Sorts"
-- /rb sum stat crit
L["Sum Crit Chance"] = "Cumul Crit"
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "Crit <- %Crit, Agi, Comp Arme"
-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = "Cumul Crit Sorts"
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "Crit Sorts <- %Crit Sorts, Intel"
-- /rb sum stat mp5
L["Sum Mana Regen"] = "Cumul Regen Mana"
L["Mana Regen <- Mana Regen, Spirit"] = "Regen Mana <- Regen Mana, Esprit"
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = "Cumul Regen Mana HI"
L["Mana Regen while not casting <- Spirit"] = "Regen Mana HI <- Esprit"
-- /rb sum stat hp5
L["Sum Health Regen"] = "Cumul Regen Vie"
L["Health Regen <- Health Regen"] = "Regen Vie <- Regen Vie"
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = "Cumul Regen Vie HC"
L["Health Regen when out of combat <- Spirit"] = "Regen Vie HC <- Esprit"
-- /rb sum stat armor
L["Sum Armor"] = "Cumul Armure"
L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "Armure <- Armure Objets, Armure Bonus, Agi, Intel"
-- /rb sum stat blockvalue
L["Sum Block Value"] = "Cumul Dégats Bloqués"
L["Block Value <- Block Value, Strength"] = "Dégats Bloqués <- Dégats Bloqués, Force"
-- /rb sum stat dodge
L["Sum Dodge Chance"] = "Cumul Esquive"
L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "Esquive <- Score Esquive, Agi, Score Def"
-- /rb sum stat parry
L["Sum Parry Chance"] = "Cumul Parade"
L["Parry Chance <- Parry Rating, Defense Rating"] = "Parade <- Score Parade, Score Def"
-- /rb sum stat block
L["Sum Block Chance"] = "Cumul Bloquage"
L["Block Chance <- Block Rating, Defense Rating"] = "Bloquage <- Score Bloquage, Score Def"
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = "Cumul Raté"
L["Hit Avoidance <- Defense Rating"] = "Raté <- Score Def"
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = "Cumul Def Crit"
L["Crit Avoidance <- Defense Rating, Resilience"] = "Def Crit <- Score Def, Resilience"
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = "Cumul Ignore Esquive"
--L["Dodge Neglect <- Weapon Skill Rating"] = "Ignore Esquive <- Score Arme"
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = "Cumul Ignore Parade"
--L["Parry Neglect <- Weapon Skill Rating"] = "Ignore Parade <- Score Arme"
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = "Cumul Ignore Bloquage"
L["Block Neglect <- Weapon Skill Rating"] = "Ignore Bloquage <- Score Arme"
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = "Cumul RA"
L["Arcane Resistance Summary"] = "Résumé de la RA"
-- /rb sum stat resfire
L["Sum Fire Resistance"] = "Cumul RF"
L["Fire Resistance Summary"] = "Résumé de la Rf"
-- /rb sum stat resnature
L["Sum Nature Resistance"] = "Cumul RN"
L["Nature Resistance Summary"] = "Résumé de la RN"
-- /rb sum stat resfrost
L["Sum Frost Resistance"] = "Cumul RG"
L["Frost Resistance Summary"] = "Résumé de la RG"
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = "Cumul RO"
L["Shadow Resistance Summary"] = "Résumé de la RO"
-- /rb sum stat maxdamage
L["Sum Weapon Max Damage"] = "Cumul Dommage Arme Max"
L["Weapon Max Damage Summary"] = "Résumé du Dommage ax de l'Arme"
-- /rb sum stat weapondps
--L["Sum Weapon DPS"] = true
--L["Weapon DPS Summary"] = true
-- /rb sum statcomp
--L["Stat - Composite"] = "Stats - Composées"
--L["Choose composite stats for summary"] = "Choisir les Stats composées du résumé"
-- /rb sum statcomp str
L["Sum Strength"] = "Cumul Force"
L["Strength Summary"] = "Résumé de la Force"
-- /rb sum statcomp agi
L["Sum Agility"] = "Cumul Agi"
L["Agility Summary"] = "Résumé de l'Agilité"
-- /rb sum statcomp sta
L["Sum Stamina"] = "Cumul Endu"
L["Stamina Summary"] = "Résumé de l'Endurance"
-- /rb sum statcomp int
L["Sum Intellect"] = "Cumul Int"
L["Intellect Summary"] = "Résumé de l'Intelligence"
-- /rb sum statcomp spi
L["Sum Spirit"] = "Cumul Esprit"
L["Spirit Summary"] = "Résumé de l'Esprit"
-- /rb sum statcomp def
L["Sum Defense"] = "Cumul Def"
L["Defense <- Defense Rating"] = "Def <- Score def"
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = "Cumul Comp Arme"
L["Weapon Skill <- Weapon Skill Rating"] = "Comp Arme <- Score Arme"
-- /rb sum physical exprating
--L["Sum Expertise Rating"] = true
--L["Expertise Rating Summary"] = true
---------------------------------------------------------------------------
-- /rb sum gemset
L["Gem Set"] = "Set de gemme"
L["Select a gem set to configure"] = "Selectionnez un set de gemme à configurer."
L["Default Gem Set 1"] = "Set de gemme 1"
L["Default Gem Set 2"] = "Set de gemme 2"
L["Default Gem Set 3"] = "Set de gemme 3"
-- /rb sum gem
L["Auto fill empty gem slots"] = "Remplissage automatique des gemmes vides"
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
--L["ItemID or Link of the gem you would like to auto fill"] = true
L["<ItemID|Link>"] = "<ItemID|Lien>"
--L["|cffffff7f%s|r is now set to |cffffff7f[%s]|r"] = true
--L["Invalid input: %s. ItemID or ItemLink required."] = true
--L["Queried server for Gem: %s. Try again in 5 secs."] = true
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META
-- /rb sum gem2
--L["Second set of default gems which can be toggled with a modifier key"] = true
--L["Can't use the same modifier as Gem Set 3"] = true
-- /rb sum gem2 key
--L["Toggle Key"] = true
--L["Use this key to toggle alternate gems"] = true
-- /rb sum gem3
--L["Third set of default gems which can be toggled with a modifier key"] = true
--L["Can't use the same modifier as Gem Set 2"] = true

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "Niveau d'objet :"
L["ItemID: "] = "ID de l'objet :"
-----------------------
-- Matching Patterns --
-----------------------
-- Items to check --
--------------------
-- [Potent Ornate Topaz]
-- +6 Spell Damage, +5 Spell Crit Rating
--------------------
-- ZG enchant
-- +10 Defense Rating/+10 Stamina/+15 Block Value
--------------------
-- [Glinting Flam Spessarite]
-- +3 Hit Rating and +3 Agility
--------------------
-- ItemID: 22589
-- [Atiesh, Greatstaff of the Guardian] warlock version
-- Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.
--------------------
-- [Brilliant Wizard Oil]
-- Use: While applied to target weapon it increases spell damage by up to 36 and increases spell critical strike rating by 14 . Lasts for 30 minutes.
----------------------------------------------------------------------------------------------------
-- I redesigned the tooltip scanner using a more locale friendly, 2 pass matching matching algorithm.
--
-- The first pass searches for the rating number, the patterns are read from L["numberPatterns"] here,
-- " by (%d+)" will match strings like: "Increases defense rating by 16."
-- "%+(%d+)" will match strings like: "+10 Defense Rating"
-- You can add additional patterns if needed, its not limited to 2 patterns.
-- The separators are a table of strings used to break up a line into multiple lines what will be parsed seperately.
-- For example "+3 Hit Rating, +5 Spell Crit Rating" will be split into "+3 Hit Rating" and " +5 Spell Crit Rating"
--
-- The second pass searches for the rating name, the names are read from L["statList"] here,
-- It will look through the table in order, so you can put common strings at the begining to speed up the search,
-- and longer strings should be listed first, like "spell critical strike" should be listed before "critical strike",
-- this way "spell critical strike" does get matched by "critical strike".
-- Strings need to be in lower case letters, because string.lower is called on lookup
--
-- IMPORTANT: there may not exist a one-to-one correspondence, meaning you can't just translate this file,
-- but will need to go in game and find out what needs to be put in here.
-- For example, in english I found 3 different strings that maps to CR_CRIT_MELEE: "critical strike", "critical hit" and "crit".
-- You will need to find out every string that represents CR_CRIT_MELEE, and so on.
-- In other languages there may be 5 different strings that should all map to CR_CRIT_MELEE.
-- so please check in game that you have all strings, and not translate directly off this table.
--
-- Tip1: When doing localizations, I recommend you set debugging to true in RatingBuster.lua
-- Find RatingBuster:SetDebugging(false) and change it to RatingBuster:SetDebugging(true)
-- or you can type /rb debug to enable it in game
--
-- Tip2: The strings are passed into string.find, so you should escape the magic characters ^$()%.[]*+-? with a %
L["numberPatterns"] = {
	{pattern = " de (%d+)", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)[^%%]", addInfo = "AfterStat",},
	--{pattern = "grant.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar ID:18348, Assassination Armor set
	--{pattern = "add.-(%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone ID:23529
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID:24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [ç™¼å…‰çš„æš—å½±å“å¥ˆçŸ³] +6æ³•è¡“å‚·å®³åŠ5è€åŠ›
}
L["separators"] = {
	"/", " et ", ",", "%. ", " pour ", "&", ":",
	-- Fix for [Mirror of Truth]
	-- Equip: Chance on melee and ranged critical strike to increase your attack power by 1000 for 10 secs.
	-- 1000 was falsely detected detected as ranged critical strike
	"augmente votre",
}
--[[ Rating ID
CR_WEAPON_SKILL = 1;
CR_DEFENSE_SKILL = 2;
CR_DODGE = 3;
CR_PARRY = 4;
CR_BLOCK = 5;
CR_HIT_MELEE = 6;
CR_HIT_RANGED = 7;
CR_HIT_SPELL = 8;
CR_CRIT_MELEE = 9;
CR_CRIT_RANGED = 10;
CR_CRIT_SPELL = 11;
CR_HIT_TAKEN_MELEE = 12;
CR_HIT_TAKEN_RANGED = 13;
CR_HIT_TAKEN_SPELL = 14;
CR_CRIT_TAKEN_MELEE = 15;
CR_CRIT_TAKEN_RANGED = 16;
CR_CRIT_TAKEN_SPELL = 17;
CR_HASTE_MELEE = 18;
CR_HASTE_RANGED = 19;
CR_HASTE_SPELL = 20;
CR_WEAPON_SKILL_MAINHAND = 21;
CR_WEAPON_SKILL_OFFHAND = 22;
CR_WEAPON_SKILL_RANGED = 23;
CR_EXPERTISE = 24;
--
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
L["statList"] = {
	{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
	{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
	{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
	{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
	{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
	{pattern = "score de défense", id = CR_DEFENSE_SKILL},
	{pattern = "score d'esquive", id = CR_DODGE},
	{pattern = "score de blocage", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "score de parade", id = CR_PARRY},

	{pattern = "score de critique des sorts", id = CR_CRIT_SPELL},
	{pattern = "spell critical hit rating", id = CR_CRIT_SPELL},
	{pattern = "spell critical rating", id = CR_CRIT_SPELL},
	{pattern = "spell crit rating", id = CR_CRIT_SPELL},
	{pattern = "ranged critical strike rating", id = CR_CRIT_RANGED},
	{pattern = "ranged critical strike", id = CR_CRIT_RANGED}, -- [Heartseeker Scope]
	{pattern = "ranged critical hit rating", id = CR_CRIT_RANGED},
	{pattern = "ranged critical rating", id = CR_CRIT_RANGED},
	{pattern = "ranged crit rating", id = CR_CRIT_RANGED},
	{pattern = "critical strike rating", id = CR_CRIT_MELEE},
	{pattern = "critical hit rating", id = CR_CRIT_MELEE},
	{pattern = "critical rating", id = CR_CRIT_MELEE},
	{pattern = "crit rating", id = CR_CRIT_MELEE},

	{pattern = "spell hit rating", id = CR_HIT_SPELL},
	{pattern = "ranged hit rating", id = CR_HIT_RANGED},
	{pattern = "hit rating", id = CR_HIT_MELEE},

	{pattern = "resilience", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating

	{pattern = "spell haste rating", id = CR_HASTE_SPELL},
	{pattern = "ranged haste rating", id = CR_HASTE_RANGED},
	{pattern = "haste rating", id = CR_HASTE_MELEE},
	{pattern = "speed rating", id = CR_HASTE_MELEE}, -- [Drums of Battle]

	{pattern = "skill rating", id = CR_WEAPON_SKILL},
	{pattern = "expertise rating", id = CR_EXPERTISE},

	{pattern = "hit avoidance rating", id = CR_HIT_TAKEN_MELEE},
	{pattern = "armor penetration rating", id = CR_ARMOR_PENETRATION},
	{pattern = string.lower(ARMOR), id = ARMOR},
	--[[
	{pattern = "dagger skill rating", id = CR_WEAPON_SKILL},
	{pattern = "sword skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed swords skill rating", id = CR_WEAPON_SKILL},
	{pattern = "axe skill rating", id = CR_WEAPON_SKILL},
	{pattern = "bow skill rating", id = CR_WEAPON_SKILL},
	{pattern = "crossbow skill rating", id = CR_WEAPON_SKILL},
	{pattern = "gun skill rating", id = CR_WEAPON_SKILL},
	{pattern = "feral combat skill rating", id = CR_WEAPON_SKILL},
	{pattern = "mace skill rating", id = CR_WEAPON_SKILL},
	{pattern = "polearm skill rating", id = CR_WEAPON_SKILL},
	{pattern = "staff skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed axes skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed maces skill rating", id = CR_WEAPON_SKILL},
	{pattern = "fist weapons skill rating", id = CR_WEAPON_SKILL},
	--]]
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
--L["$value% Crit"] = true
L["$value% Spell Crit"] = "$value% Crit sorts"
L["$value% Dodge"] = "$value% Esquive"
L["$value HP"] = "$value% PV"
L["$value MP"] = "$value% PM"
L["$value AP"] = "$value% PA"
L["$value RAP"] = "$value% PA dist"
L["$value Dmg"] = "$value% Dégats"
L["$value Heal"] = "$value% Soins"
L["$value Armor"] = "$value% Armure"
L["$value Block"] = "$value% Blocage"
L["$value MP5"] = "$value% Mana/5sec"
L["$value MP5(NC)"] = "$value% Mana/5sec(NC)"
L["$value HP5"] = "$value% Vie/5sec"
L["$value to be Dodged/Parried"] = "$value% qui sont esquivés/parés"
L["$value to be Crit"] = "$value% qui sont crit"
L["$value Crit Dmg Taken"] = "$value% Crit dommage reçu"
L["$value DOT Dmg Taken"] = "$value% DOT dommage reçu"
L["$value% Parry"] = "$value% parer"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value% Sort"

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "Résumé des stats"