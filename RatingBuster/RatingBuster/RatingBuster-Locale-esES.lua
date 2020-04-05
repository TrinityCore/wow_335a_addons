--[[
Name: RatingBuster esES locale
Revision: $Revision: 282 $
Translated by:
- carahuevo@Curse
- kaiemg
]]

local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "esES")
if not L then return end
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: L["Show Item ID"] = true,
-- After:  L["Show Item ID"] = "顯示物品編號",
---------------
-- Waterfall --
---------------
L["RatingBuster Options"] = "Opciones RatingBuster"
L["Waterfall-1.0 is required to access the GUI."] = "Se requiere Waterfall para acceder a la GUI."
L["Enabled"] = "Activado"
L["Suspend/resume this addon"] = "Parar/Continuar este accesorio"
---------------------------
-- Slash Command Options --
---------------------------
--L["General Settings"] = true
--L["Profiles"] = true
-- /rb optionswin
L["Options Window"] = "Ventana opciones"
L["Shows the Options Window"] = "Muestra la ventana de opciones"
-- /rb statmod
L["Enable Stat Mods"] = "Habilitar Stat Mods"
L["Enable support for Stat Mods"] = "Habilita el soporte para Stat Mods"
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "Habilita evitacion de rendimientos decrecientes"
L["Dodge, Parry, Hit Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "Rendimientos decrecientes"
-- /rb itemid
L["Show ItemID"] = "Mostrar ItemID"
L["Show the ItemID in tooltips"] = "Mostrar ItemID en los tooltips"
-- /rb itemlevel
L["Show ItemLevel"] = "Mostrar NivelItem"
L["Show the ItemLevel in tooltips"] = "Muestra el NivelItem en los tooltips"
-- /rb usereqlv
L["Use Required Level"] = "Usar nivel requerido"
L["Calculate using the required level if you are below the required level"] = "Calcular apartir del nivel requerido si estas por debajo"
-- /rb setlevel
L["Set Level"] = "Establecer nivel"
L["Set the level used in calculations (0 = your level)"] = "Establece el nivel usado en los caculos (0=tu nivel)"
-------------------------------------------------------------------------------
-- /rb rating
L["Rating"] = "Indices"
L["Options for Rating display"] = "Opciones de visualizacion de indices"
-- /rb rating show
L["Show Rating Conversions"] = "Mostrar conversion de indices"
L["Show Rating conversions in tooltips"] = "Mostrar conversion de indices en tooltips"
-- /rb rating spell
--L["Show Spell Hit/Haste"] = true
--L["Show Spell Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating physical
--L["Show Physical Hit/Haste"] = true
--L["Show Physical Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating detail
L["Show Detailed Conversions Text"] = "Mostrar texto detallado conversiones"
L["Show detailed text for Resilience and Expertise conversions"] = "Mostrar texto detallado de conversiones de Temple y Pericia"
-- /rb rating def
L["Defense Breakdown"] = "Desglose Defensa"
L["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "Convierte Defensa en evitar Critico, evitar Golpe, Esquivar, Parar y Bloquear"
-- /rb rating wpn
L["Weapon Skill Breakdown"] = "Desglose Habilidad arma"
L["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Convierta Habilidad arma en Critico, Golpe, falla Esquivar, y fallo Bloquear"
-- /rb rating exp -- 2.3.0
L["Expertise Breakdown"] = "Desglose Pericia"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Convierte Pericia en fallo Esquivar y fallo Parar"
---------------------------------------------------------------------------
-- /rb rating color
L["Change Text Color"] = "Cambiar color texto"
L["Changes the color of added text"] = "Cambia el color del texto anadido"
-- /rb rating color pick
L["Pick Color"] = "Coge color"
L["Pick a color"] = "Coge un color"
-- /rb rating color enable
L["Enable Color"] = "Habilitar color"
L["Enable colored text"] = "Habilitar texto coloreado"
---------------------------------------------------------------------------------------
-- /rb stat
L["Stat Breakdown"] = "Desglose Estadisticas"
L["Changes the display of base stats"] = "Cambia la visualizacion de las estad. base"
-- /rb stat show
L["Show Base Stat Conversions"] = "Mostrar conversiones estad. base"
L["Show base stat conversions in tooltips"] = "Muestra las conversiones de estad. base en los tooltip"
-----------------------------------------------------------------------------------------
-- /rb stat str
L["Strength"] = "Fuerza"
L["Changes the display of Strength"] = "Cambia la visualizacion de Fuerza"
-- /rb stat str ap
L["Show Attack Power"] = "Motrar Poder Ataque"
L["Show Attack Power from Strength"] = "Motrar Poder Ataque de Fuerza"
-- /rb stat str block
L["Show Block Value"] = "Mostrar Valor Bloqueo"
L["Show Block Value from Strength"] = "Muestra el Valor Bloqueo de Fuerza"
-- /rb stat str dmg
L["Show Spell Damage"] = "Mostrar Dano Hech"
L["Show Spell Damage from Strength"] = "Muestra el Dano de Hechizo de Fuerza"
-- /rb stat str heal
L["Show Healing"] = "Mostrar Sanacion"
L["Show Healing from Strength"] = "Muestra la Sanacion de Fuerza"
-- /rb stat str parry
L["Show Parry"] = "Mostrar Parada"
L["Show Parry from Strength"] = "Muestra Parada de Fuerza"
---------------------------------------------------------------------------
	-- /rb stat agi
L["Agility"] = "Agilidad"
L["Changes the display of Agility"] = "Cambia la visualizacion de Agilidad"
-- /rb stat agi crit
L["Show Crit"] = "Mostrar Crit"
L["Show Crit chance from Agility"] = "Muestra la prob. de critico de Agilidad"
-- /rb stat agi dodge
L["Show Dodge"] = "Mostrar Esquivar"
L["Show Dodge chance from Agility"] = "Muestra la prob. de Esquivar de Agilidad"
-- /rb stat agi ap
L["Show Attack Power"] = "Mostrar Poder Ataque"
L["Show Attack Power from Agility"] = "Muestra Poder de Ataque de Agilidad"
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "Mostrar Poder Ataque Dist"
L["Show Ranged Attack Power from Agility"] = "Muestra Poder de Ataque a distancia de Agilidad"
-- /rb stat agi armor
L["Show Armor"] = "Mostrar Armadura"
L["Show Armor from Agility"] = "Muestra la Armadura de Agilidad"
-- /rb stat agi heal
L["Show Healing"] = "Mostrar Sanacion"
L["Show Healing from Agility"] = "Muestra Sanacion de Agilidad"
----------------------------------------------------------------------------
-- /rb stat sta
L["Stamina"] = "Aguante"
L["Changes the display of Stamina"] = "Cambia la visualizacion de Aguante"
-- /rb stat sta hp
L["Show Health"] = "Mostrar Salud"
L["Show Health from Stamina"] = "Muestra la Salud de Aguante"
-- /rb stat sta dmg
L["Show Spell Damage"] = "Mostrar Dano Hech"
L["Show Spell Damage from Stamina"] = "Muestra el Dano de Hechizo de Aguante"
-- /rb stat sta heal
L["Show Healing"] = "Mostrar Sanacion"
L["Show Healing from Stamina"] = "Muestra sanacion de Aguante"
-- /rb stat sta ap
L["Show Attack Power"] = "Mostrar Poder de Ataque"
L["Show Attack Power from Stamina"] = "Muestra Poder de Ataque de Aguante"
---------------------------------------------------------------------------
-- /rb stat int
L["Intellect"] = "Intelecto"
L["Changes the display of Intellect"] = "Cambia la visualizacion de Intelecto"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Mostrar Crit Hech"
L["Show Spell Crit chance from Intellect"] = "Muestra la prob. de Crit. de Hechizo de Intelecto"
-- /rb stat int mp
L["Show Mana"] = "Mostrar Mana"
L["Show Mana from Intellect"] = "Muestra el Mana de Intelecto"
-- /rb stat int dmg
L["Show Spell Damage"] = "Mostrar Dano Hech"
L["Show Spell Damage from Intellect"] = "Muestra el Dano de Hechizo de Intelecto"
-- /rb stat int heal
L["Show Healing"] = "Mostrar Sanacion"
L["Show Healing from Intellect"] = "Muestra la Sanacion de Intelecto"
-- /rb stat int mp5
L["Show Mana Regen"] = "Mostrar Regen.Mana"
L["Show Mana Regen while casting from Intellect"] = "Muestra la Regen.Mana de Intelecto"
-- /rb stat int mp5nc
--L["Show Mana Regen while NOT casting"] = true
--L["Show Mana Regen while NOT casting from Intellect"] = true
-- /rb stat int rap
L["Show Ranged Attack Power"] = "Mostrar Poder Ataque Dist"
L["Show Ranged Attack Power from Intellect"] = "Muestra el Poder Ataque Dist de Intelecto"
-- /rb stat int armor
L["Show Armor"] = "Mostrar Armadura"
L["Show Armor from Intellect"] = "Muestra la Armadura de Intelecto"
-- /rb stat int ap
L["Show Attack Power"] = "Mostrar Poder de Ataque"
L["Show Attack Power from Intellect"] = "Muestra Poder de Ataque de Intelecto"
-------------------------------------------------------------------------------------
-- /rb stat spi
L["Spirit"] = "Espiritu"
L["Changes the display of Spirit"] = "Cambia la visualizacion de Espiritu"
-- /rb stat spi mp5
L["Show Mana Regen"] = "Mostrar Regen.Mana"
L["Show Mana Regen while casting from Spirit"] = "Muestra la Regen.Mana de Espiritu"
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "Mostrar Regen.Mana NO lanzando"
L["Show Mana Regen while NOT casting from Spirit"] = "Muestra la Regen.Mana NO lanzando de Espiritu"
-- /rb stat spi hp5
L["Show Health Regen"] = "Mostrar Regen.Salud"
L["Show Health Regen from Spirit"] = "Muestra la Regen. de Salud de Espiritu"
-- /rb stat spi dmg
L["Show Spell Damage"] = "Mostrar Dano Hech"
L["Show Spell Damage from Spirit"] = "Muestra el Dano de Hechizos de Espiritu"
-- /rb stat spi heal
L["Show Healing"] = "Mostrar Sanacion"
L["Show Healing from Spirit"] = "Muestra la Sanacion de Espiritu"
----------------------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = "Resumen Estad"
L["Options for stat summary"] = "Opciones de Resumen Estad."
-- /rb sum show
L["Show Stat Summary"] = "Mostrar Resumen Estad"
L["Show stat summary in tooltips"] = "Muestra el Resumen de Estad. en los tooltips"
-- /rb sum ignore
L["Ignore Settings"] = "Ignorar opciones"
L["Ignore stuff when calculating the stat summary"] = "Ignorar los datos cuando se calcule el resumen de estad."
-- /rb sum ignore unused
--L["Ignore Undesirable Items"] = true
--L["Hide stat summary for undesirable items"] = true
-- /rb sum ignore quality
--L["Minimum Item Quality"] = true
--L["Show stat summary only for selected quality items and up"] = true
-- /rb sum ignore armor
--L["Armor Types"] = true
--L["Select armor types you want to ignore"] = true
-- /rb sum ignore armor cloth
--L["Ignore Cloth"] = true
--L["Hide stat summary for all cloth armor"] = true
-- /rb sum ignore armor leather
--L["Ignore Leather"] = true
--L["Hide stat summary for all leather armor"] = true
-- /rb sum ignore armor mail
--L["Ignore Mail"] = true
--L["Hide stat summary for all mail armor"] = true
-- /rb sum ignore armor plate
--L["Ignore Plate"] = true
--L["Hide stat summary for all plate armor"] = true
-- /rb sum ignore equipped
L["Ignore Equipped Items"] = "Ignorar items equipados"
L["Hide stat summary for equipped items"] = "Ocultar resumen estad. para los items equipados"
-- /rb sum ignore enchant
L["Ignore Enchants"] = "Ignorar encantamientos"
L["Ignore enchants on items when calculating the stat summary"] = "Ignorar encantamientos en items cuando  se calcule el resumen de estad."
-- /rb sum ignore gem
L["Ignore Gems"] = "Ignorar gemas"
L["Ignore gems on items when calculating the stat summary"] = "Ignorar gemas en items cuando  se calcule el resumen de estad."
-- /rb sum diffstyle
L["Display Style For Diff Value"] = "Mostrar estilo para el valor de diferencia"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Mostrar diferencia valores en el tooltip principal o solo en los de comparacion"
-- /rb sum space
L["Add Empty Line"] = "Anadir linea vacia"
L["Add a empty line before or after stat summary"] = "Anade una linea vacia antes o despues del resumen"
-- /rb sum space before
L["Add Before Summary"] = "Anadir antes del resumen"
L["Add a empty line before stat summary"] = "Anade una linea vacia antes del resumen"
-- /rb sum space after
L["Add After Summary"] = "Anadir despues del resumen"
L["Add a empty line after stat summary"] = "Anade una linea vacia despues del resumen"
-- /rb sum icon
L["Show Icon"] = "Mostrar icono"
L["Show the sigma icon before summary listing"] = "Muestra el icono de sumatorio antes del listado resumen"
-- /rb sum title
L["Show Title Text"] = "Mostrar texto titulo"
L["Show the title text before summary listing"] = "Muestra el titulo antes del listado resumen"
-- /rb sum showzerostat
L["Show Zero Value Stats"] = "Mostrar estad. valor cero"
L["Show zero value stats in summary for consistancy"] = "Muestra las estad. de valor cero por consistencia"
-- /rb sum calcsum
L["Calculate Stat Sum"] = "Calcula suma de estad."
L["Calculate the total stats for the item"] = "Calcula el total de las estad. para el item"
-- /rb sum calcdiff
L["Calculate Stat Diff"] = "Calcular dif. estad."
L["Calculate the stat difference for the item and equipped items"] = "Calcula la diferencia para el item y los items equipados"
-- /rb sum sort
L["Sort StatSummary Alphabetically"] = "Ordenar estad. alfabeticamente"
L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "Ordena alfabeticamente el resumen, deshabilita para ordenar de acuerdo a la estad. (basica, fisica, hechizo, tanque)"
-- /rb sum avoidhasblock
L["Include Block Chance In Avoidance Summary"] = "Incluir prob. de bloqueo en resumen de Eludir"
L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "Incluye prob. de bloqueo en resumen de Eludir, Deshabilita para solo esquivar, parar y fallar"
----------------------------------------------------------------------------------------
-- /rb sum basic
L["Stat - Basic"] = "Estad. - Basica"
L["Choose basic stats for summary"] = "Escoge las estad. basicas para el resumen"
-- /rb sum basic hp
L["Sum Health"] = "Suma salud"
L["Health <- Health, Stamina"] = "Salud <- Salud, Aguante"
-- /rb sum basic mp
L["Sum Mana"] = "Suma Mana"
L["Mana <- Mana, Intellect"] = "Mana <- Mana, Intelecto"
-- /rb sum basic mp5
L["Sum Mana Regen"] = "Suma Mana regenerado"
L["Mana Regen <- Mana Regen, Spirit"] = "Suma Mana reg <- Mana Regen, Espiritu"
-- /rb sum basic mp5nc
L["Sum Mana Regen while not casting"] = "Res. Regen. mana mientras no se lanza"
L["Mana Regen while not casting <- Spirit"] = "Regen. mana mientras no se lanza <- Espiritu"
-- /rb sum basic hp5
L["Sum Health Regen"] = "Res. Regen. salud"
L["Health Regen <- Health Regen"] = "Regen. salud <- Regen. salud"
-- /rb sum basic hp5oc
L["Sum Health Regen when out of combat"] = "Res. Regen. salud fuera de combate"
L["Health Regen when out of combat <- Spirit"] = "Regen. salud fuera de combate <- Espiritu"
-- /rb sum basic str
L["Sum Strength"] = "Res. Fuerza"
L["Strength Summary"] = "Resumen Fuerza"
-- /rb sum basic agi
L["Sum Agility"] = "Res. Agilidad"
L["Agility Summary"] = "Resumen Agilidad"
-- /rb sum basic sta
L["Sum Stamina"] = "Res. Aguante"
L["Stamina Summary"] = "Resumen Aguante"
-- /rb sum basic int
L["Sum Intellect"] = "Res. Intelecto"
L["Intellect Summary"] = "Resumen Intelecto"
-- /rb sum statcomp spi
L["Sum Spirit"] = "Res. Espiritu"
L["Spirit Summary"] = "Resumen Espiritu"
----------------------------------------------------------------------------------------
-- /rb sum physical
L["Stat - Physical"] = "Datos - Fisicas"
L["Choose physical damage stats for summary"] = "Escoge datos de dano fisico para resumen"
-- /rb sum physical ap
L["Sum Attack Power"] = "Res. Poder Ataque"
L["Attack Power <- Attack Power, Strength, Agility"] = "Poder Ataque <- Poder Ataque, Fuerza, Agilidad"
-- /rb sum physical rap
L["Sum Ranged Attack Power"] = "Res. P.Ataque Distancia"
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "P.Ataque Distancia <- P.Ataque Distancia, Intelecto, P.Ataque, Fuerza, Agilidad"
-- /rb sum physical fap
L["Sum Feral Attack Power"] = "Res. P.Ataque feral"
L["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "P.Ataque feral <- P.Ataque feral, P.Ataque, Fuerza, Agilidad"
-- /rb sum physical hit
L["Sum Hit Chance"] = "Res. prob. Golpe"
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "prob. Golpe <- Indice Golpe, Indice pericia"
-- /rb sum physical hitrating
L["Sum Hit Rating"] = "Res. Indice Golpe"
L["Hit Rating Summary"] = "Resumen Indice Golpe"
-- /rb sum physical crit
L["Sum Crit Chance"] = "Res. Prob. Crit."
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "Prob.Crit <- Crit, Agilidad, Indice Pericia"
-- /rb sum physical critrating
L["Sum Crit Rating"] = "Res. Indice Critico"
L["Crit Rating Summary"] = "Resumen Indice Critico"
-- /rb sum physical haste
L["Sum Haste"] = "Res. Celeridad"
L["Haste <- Haste Rating"] = "Resumen Celeridad"
-- /rb sum physical hasterating
L["Sum Haste Rating"] = "Res. Indice Celeridad"
L["Haste Rating Summary"] = "Resumen Indice Celeridad"
-- /rb sum physical rangedhit
L["Sum Ranged Hit Chance"] = "Res. Prob. Golpe a Distancia"
-- L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = true
-- /rb sum physical rangedhitrating
L["Sum Ranged Hit Rating"] = "Res. Indice Golpe a Distancia"
-- L["Ranged Hit Rating Summary"] = true
-- /rb sum physical rangedcrit
L["Sum Ranged Crit Chance"] = "Res. Prob. Critico a Distancia"
-- L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = true
-- /rb sum physical rangedcritrating
-- L["Sum Ranged Crit Rating"] = true
-- L["Ranged Crit Rating Summary"] = true
-- /rb sum physical rangedhaste
-- L["Sum Ranged Haste"] = true
-- L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = true
-- /rb sum physical rangedhasterating
-- L["Sum Ranged Haste Rating"] = true
-- L["Ranged Haste Rating Summary"] = true
-- /rb sum physical maxdamage
L["Sum Weapon Max Damage"] = "Res. Max Dano Arma"
L["Weapon Max Damage Summary"] = "Resumen de Maximo Dano Arma"
-- /rb sum physical ignorearmor
L["Sum Ignore Armor"] = "Res. Ignorar armadura"
L["Ignore Armor Summary"] = "Resumen de Ignorar Armadura"
-- /rb sum physical arp
L["Sum Armor Penetration"] = "Res. Penetracion Armadura"
L["Armor Penetration Summary"] = "Resumen de Penetracion Armadura"
-- /rb sum physical weapondps
--L["Sum Weapon DPS"] = true
--L["Weapon DPS Summary"] = true
-- /rb sum physical wpn
L["Sum Weapon Skill"] = "Res. Habilidad Arma"
L["Weapon Skill <- Weapon Skill Rating"] = "Habilidad Arma <- Indice Habilidad Arma"
-- /rb sum physical exp -- 2.3.0
L["Sum Expertise"] = "Res. Pericia"
L["Expertise <- Expertise Rating"] = "Pericia <- Indice Pericia"
-- /rb sum physical exprating
--L["Sum Expertise Rating"] = true
--L["Expertise Rating Summary"] = true
-- /rb sum physical arprating
L["Sum Armor Penetration Rating"] = "Res. Indice Penetracion Armadura"
L["Armor Penetration Rating Summary"] = "Resumen Indice Penetracion de Armadura"
----------------------------------------------------------------------------------------
-- /rb sum spell
L["Stat - Spell"] = "Datos - Hechizo"
L["Choose spell damage and healing stats for summary"] = "Escoge datos de dano y sanacion de hechizo para resumen"
-- /rb sum spell dmg
L["Sum Spell Damage"] = "Res. Dano Hech."
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Dano Hech. <- Dano Hech., Intelecto, Espiritu, Aguante"
-- /rb sum spell dmgholy
L["Sum Holy Spell Damage"] = "Res. Dano Hech. Sagrado"
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Dano Hech. Sagrado <- Dano Hech. Sagrado, Dano Hech., Intelecto, Espiritu"
-- /rb sum spell dmgarcane
L["Sum Arcane Spell Damage"] = "Res. Dano Hech. Arcano"
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Dano Hech. Arcano <- Dano Hech. Arcano, Dano Hech., Intelecto"
-- /rb sum spell dmgfire
L["Sum Fire Spell Damage"] = "Res. Dano Hech. Fuego"
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Dano Hech. Arcano <- Dano Hech. Arcano, Dano Hech., Intelecto, Aguante"
-- /rb sum spell dmgnature
L["Sum Nature Spell Damage"] = "Res. Dano Hech. Naturaleza"
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Dano Hech. Naturaleza <- Dano Hech. Naturaleza, Dano Hech., Intelecto"
-- /rb sum spell dmgfrost
L["Sum Frost Spell Damage"] = "Res. Dano Hech. Frio"
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Dano Hech. Frio <- Dano Hech. Frio, Dano Hech., Intelecto"
-- /rb sum spell dmgshadow
L["Sum Shadow Spell Damage"] = "Res. Dano Hech. Sombras"
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Dano Hech. Sombras <- Dano Hech. Sombras, Dano Hech., Intelecto, Espiritu, Aguante"
-- /rb sum spell heal
L["Sum Healing"] = "Res. Sanacion"
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Sanacion <- Sanacion, Intelecto, Espiritu, Agilidad, Fuerza"
-- /rb sum spell crit
L["Sum Spell Crit Chance"] = "Res. prob. Critico Hech."
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "prob. Critico Hech. <- Indice Critico Hech., Intelecto"
-- /rb sum spell hit
L["Sum Spell Hit Chance"] = "Res. prob. Golpe Hech."
L["Spell Hit Chance <- Spell Hit Rating"] = "prob. Golpe Hech. <- Indice Golpe Hech."
-- /rb sum spell haste
L["Sum Spell Haste"] = "Res. velocidad Hech."
L["Spell Haste <- Spell Haste Rating"] = "Velocidad Hech. <- Indice Velocidad Hech."
-- /rb sum spell pen
L["Sum Penetration"] = "Res. Penetracion"
L["Spell Penetration Summary"] = "Resument Penetracion Hechizo"
-- /rb sum spell hitspellrating
L["Sum Spell Hit Rating"] = "Res. Golpe Hech."
L["Spell Hit Rating Summary"] = "Resumen Golpe Hech."
-- /rb sum spell critspellrating
L["Sum Spell Crit Rating"] = "Res. Indice Critico Hech."
L["Spell Crit Rating Summary"] = "Resumen Indice Critico Hech."
-- /rb sum spell hastespellrating
L["Sum Spell Haste Rating"] = "Res. Indice Velocidad Hech."
L["Spell Haste Rating Summary"] = "Resumen Indice Velocidad Hech."
----------------------------------------------------------------------------------------
-- /rb sum tank
L["Stat - Tank"] = "Datos - Tanque"
L["Choose tank stats for summary"] = "Escoge datos de tanque para resumen"
-- /rb sum tank armor
L["Sum Armor"] = "Res. Armadura"
L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "Armadura <- Armadura de items, Armadura de bonus, Agilidad, Intelecto"
-- /rb sum tank blockvalue
L["Sum Block Value"] = "Res. Valor Bloqueo"
L["Block Value <- Block Value, Strength"] = "Valor Bloqueo <- Valor Bloqueo, Fuerza"
-- /rb sum tank dodge
L["Sum Dodge Chance"] = "Res. prob. Esquivar"
L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "Prob. Esquivar <- Indice Esquivar, Agilidad, Indice Defensa"
-- /rb sum tank parry
L["Sum Parry Chance"] = "Res. prob. Parar"
L["Parry Chance <- Parry Rating, Defense Rating"] = "Prob. Parar <- Indice Parar, Indice Defensa"
-- /rb sum tank block
L["Sum Block Chance"] = "Res. prob Bloqueo"
L["Block Chance <- Block Rating, Defense Rating"] = "Prob. Bloqueo <- Indice Bloqueo, Indice Defensa"
-- /rb sum tank avoidhit
L["Sum Hit Avoidance"] = "Res. Elusion golpe"
L["Hit Avoidance <- Defense Rating"] = "Elusion golpe <- Indice Defensa"
-- /rb sum tank avoidcrit
L["Sum Crit Avoidance"] = "Res. Elusion Critico"
L["Crit Avoidance <- Defense Rating, Resilience"] = "Elusion Critico <- Indice Defensa, Temple"
-- /rb sum tank neglectdodge
L["Sum Dodge Neglect"] = "Res. fallo Esquivar"
L["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "Fallo Esquivar <- Pericia, Indice habilidad arma"
-- /rb sum tank neglectparry
L["Sum Parry Neglect"] = "Res. fallo Parar"
L["Parry Neglect <- Expertise, Weapon Skill Rating"] = "Fallo Parar <- Pericia, Indice habilidad arma"
-- /rb sum tank neglectblock
L["Sum Block Neglect"] = "Res. fallo Bloquear"
L["Block Neglect <- Weapon Skill Rating"] = "Fallo Bloquear <- Indice habilidad arma"
-- /rb sum tank resarcane
L["Sum Arcane Resistance"] = "Res. Resist. Arcana"
L["Arcane Resistance Summary"] = "Resumen Resistencia Arcana"
-- /rb sum tank resfire
L["Sum Fire Resistance"] = "Res. Resist. Fuego"
L["Fire Resistance Summary"] = "Resumen Resistencia Fuego"
-- /rb sum tank resnature
L["Sum Nature Resistance"] = "Res. Resist. Naturaleza"
L["Nature Resistance Summary"] = "Resumen Resistencia Naturaleza"
-- /rb sum tank resfrost
L["Sum Frost Resistance"] = "Res. Resist. Frio"
L["Frost Resistance Summary"] = "Resumen Resistencia Frio"
-- /rb sum tank resshadow
L["Sum Shadow Resistance"] = "Res. Resist. Sombras"
L["Shadow Resistance Summary"] = "Resumen Resistencia Sombras"
-- /rb sum tank dodgerating
L["Sum Dodge Rating"] = "Res. Indice Esquivar"
L["Dodge Rating Summary"] = "Resumen Indice Esquivar"
-- /rb sum tank parryrating
L["Sum Parry Rating"] = "Res. Indice Parar"
L["Parry Rating Summary"] = "Resumen Indice Parar"
-- /rb sum tank blockrating
L["Sum Block Rating"] = "Res. Indice Bloquear"
L["Block Rating Summary"] = "Resumen Indice Bloquear"
-- /rb sum tank res
L["Sum Resilience"] = "Res. Temple"
L["Resilience Summary"] = "Resumen Temple"
-- /rb sum tank def
L["Sum Defense"] = "Res. Defensa"
L["Defense <- Defense Rating"] = "Defensa <- Indice Defensa"
-- /rb sum tank tp
L["Sum TankPoints"] = "Res. Ptos. Tanque"
L["TankPoints <- Health, Total Reduction"] = "Ptos. Tanque <- Salud, Total Reduccion"
-- /rb sum tank tr
L["Sum Total Reduction"] = "Res. Total Reduccion"
L["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "Total Reduccion <- Armadura, Esquivar, Parar, Bloquear, Valor bloqueo, Defensa, Temple, FalloEnemigo, CriticoEnemigo, AplastamientoEnemigo, Modifics.DanoRecibido"
-- /rb sum tank avoid
L["Sum Avoidance"] = "Res. Elusion"
L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "Elusion <- Esquivar, Parar, FalloEnemigo, Bloqueo(Opcional)"
----------------------------------------------------------------------------------------
-- /rb sum gemset
-- L["Gem Set"] = true
-- L["Select a gem set to configure"] = true
-- L["Default Gem Set 1"] = true
-- L["Default Gem Set 2"] = true
-- L["Default Gem Set 3"] = true
-- /rb sum gem
L["Auto fill empty gem slots"] = "Rellena automaticamente los huecos de gemas"
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
--L["ItemID or Link of the gem you would like to auto fill"] = true
--L["<ItemID|Link>"] = true
--L["|cffffff7f%s|r is now set to |cffffff7f[%s]|r"] = true
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
L["ItemLevel: "] = "NivelItem"
L["ItemID: "] = "IDItem"
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
	{pattern = " (%d+)", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
	{pattern = "Otorga.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "Aumenta.-(%d+) p.", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	{pattern = "Mejora.-(%d+) p.", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [????????] +6?????5??
}
L["separators"] = {
	"/", " y ", ",", "%. ", " durante ", "&"
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
	{pattern = "tu \195\173ndice de defensa", id = CR_DEFENSE_SKILL},
	{pattern = "tu \195\173ndice de esquivar", id = CR_DODGE},
	{pattern = "tu \195\173ndice de bloqueo", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "tu \195\173ndice de parada", id = CR_PARRY},

	{pattern = "tu \195\173ndice de golpe cr\195\173tico", id = CR_CRIT_SPELL},
	{pattern = "tu\195\173ndice de golpe cr\195\173tico", id = CR_CRIT_RANGED},
	{pattern = "tu \195\173ndice de golpe cr\195\173tico", id = CR_CRIT_MELEE},
	--{pattern = "tu \195\173ndice de golpe", id = CR_CRIT_MELEE},

	{pattern = "tu \195\173ndice de golpe", id = CR_HIT_SPELL},
	{pattern = "tu \195\173ndice de golpe a distancia", id = CR_HIT_RANGED},
	{pattern = "tu \195\173ndice de golpe cuerpo a cuerpo", id = CR_HIT_MELEE},
	{pattern = "tu \195\173ndice de golpe", id = CR_HIT_MELEE},

	{pattern = "tu \195\173ndice de temple", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating

	{pattern = "tu \195\173ndice de celeridad", id = CR_HASTE_SPELL},
	{pattern = "tu \195\173ndice de celeridad a distancia", id = CR_HASTE_RANGED},
	{pattern = "tu \195\173ndice de celeridad con cuerpo a cuerpo", id = CR_HASTE_MELEE},
	{pattern = "tu \195\173ndice de celeridad", id = CR_HASTE_MELEE},
	{pattern = "Aumenta el \195\173ndice de celeridad de los miembros del grupo cercanos hasta", id = CR_HASTE_MELEE}, -- [Drums of Battle]

	{pattern = "tu \195\173ndice de habilidad", id = CR_WEAPON_SKILL},
	{pattern = "tu \195\173ndice de pericia", id = CR_EXPERTISE},

	{pattern = "tu \195\173ndice de evasion de golpes cuerpo a cuerpo", id = CR_HIT_TAKEN_MELEE},
	{pattern = "tu \195\173ndice de evasion", id = CR_HIT_TAKEN_MELEE},
	{pattern = "tu índice de penetración de armadurap", id = CR_ARMOR_PENETRATION},
	{pattern = string.lower(ARMOR), id = ARMOR},
	--[[
	{pattern = "\195\173ndice de habilidad con dagas", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con espadas", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con espadas de dos manos", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con hachas", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con arcos", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con ballesta", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con armas de fuego", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad en combate feral", id = CR_WEAPON_SKILL},
	{pattern = "tu \195\173ndice de habilidad con mazas", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con armas de asta", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con bastones", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con hachas de dos manos", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad con mazas de dos manos", id = CR_WEAPON_SKILL},
	{pattern = "\195\173ndice de habilidad sin armas", id = CR_WEAPON_SKILL},
	--]]
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "$value% Crit"
L["$value% Spell Crit"] = "$value% Crit hechizos"
L["$value% Dodge"] = "$value% Esquivar"
L["$value HP"] = "$value Vida"
L["$value MP"] = "$value Mana"
L["$value AP"] = "$value P.At"
L["$value RAP"] = "$value P.At Dist"
L["$value Dmg"] = "$value Dano"
L["$value Heal"] = "$value Sanacion"
L["$value Armor"] = "$value Armadura"
L["$value Block"] = "$value Bloqueo"
L["$value MP5"] = "$value Mana/5sec"
L["$value MP5(NC)"] = "$value Mana/5sec(SL)"
L["$value HP5"] = "$value Vida/5sec"
L["$value to be Dodged/Parried"] = "$value Esquivado/Parado"
L["$value to be Crit"] = "$value recibir Crit"
L["$value Crit Dmg Taken"] = "$value Dano crit recib"
L["$value DOT Dmg Taken"] = "$value Dano por tiempo recib"
L["$value% Parry"] = "$value Parada"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value Hech."

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "Resumen estad."


local MX = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "esMX")
for k, v in pairs(L) do
	MX[k] = v
end