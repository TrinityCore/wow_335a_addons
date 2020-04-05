function MBZSetDefault()
	MBZ = {["Combat"] = "on", ["Resting"] = "off", ["Flask"] = "raid"}
	MBZ.DK = {["Horn"] = "on", ["Sheild"] = "on"}
	MBZ.Druid = {["Mark"] = "on", ["Thorns"] = "bear"}
	MBZ.Hunter = {["Aspect"] = "on", ["Trueshot"] = "on", ["Ammolow"] = 3000, ["WarningC"] = "on", ["WarningV"] = "on"}
	MBZ.Mage = {["Int"] = "on", ["Armor"] = "on"}
	MBZ.Paladin = {["Seal"] = "on", ["RF"] = "off"}
	MBZ.Priest = {["Fort"] = "on", ["Spirit"] = "on", ["Shadow"] = "on", ["IF"] = "on", ["VE"] = "on", ["SForm"] = "on"}
	MBZ.Rogue = {["Weapon"] = "on"}
	MBZ.Shaman = {["Weapon"] = "on", ["Shield"] ="on"}
	MBZ.Warlock = {["Armor"] = "on", ["SL"] = "on", ["Weapon"] = "on"}
	MBZ.Warrior = {["Shout"] = "on"}
end


--Options
SLASH_MBZ1, SLASH_MBZ2 = '/mbz', '/mybuffz';
function SlashCmdList.MBZ(msg, editbox)
	msg	= string.lower(msg);
	local command, rest = msg:match("^(%S*)%s*(.-)$");
	if command == "flask" then
		if rest == "" then
			print("Flask Tracking is set to |cffff0000"..MBZ.Flask.."|r") 
		elseif rest == "off" or rest == "on" or rest == "raid" then
			print("Flask Tracking set to |cffff0000"..rest.."|r") 
			MBZ.Flask = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz flask raid|on|off|r")
		end
	elseif command == "combat" then
		if rest == "" then
			print("Combat only is set to |cffff0000"..MBZ.Combat.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Combat only set to |cffff0000"..rest.."|r") 
			MBZ.Combat = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz combat on|off|r")
		end
	elseif command == "resting" then
		if rest == "" then
			print("While resting is set to |cffff0000"..MBZ.Resting.."|r") 
		elseif rest == "off" or rest == "on" then
			print("While resting set to |cffff0000"..rest.."|r") 
			MBZ.Resting = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz resting on|off|r")
		end
	elseif command == "horn" then
		if rest == "" then
			print("Track Horn of Winter is set to |cffff0000"..MBZ.DK.Horn.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Horn of Winter set to |cffff0000"..rest.."|r") 
			MBZ.DK.Horn = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz horn on|off|r")
		end
	elseif command == "shield" and select(2, UnitClass('player')) == "DEATHKNIGHT" then
		if rest == "" then
			print("Track Bone Shield is set to |cffff0000"..MBZ.DK.Shield.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Bone Shield set to |cffff0000"..rest.."|r") 
			MBZ.DK.Shield = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz shield on|off|r")
		end
	elseif command == "mark" then
		if rest == "" then
			print("Track Mark is set to |cffff0000"..MBZ.Druid.Mark.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Mark set to |cffff0000"..rest.."|r") 
			MBZ.Druid.Mark = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz mark on|off|r")
		end
	elseif command == "thorns" then
		if rest == "" then
			print("Thorns Tracking is set to |cffff0000"..MBZ.Druid.Thorns.."|r") 
		elseif rest == "off" or rest == "on" or rest == "bear" then
			print("Thorns Tracking set to |cffff0000"..rest.."|r") 
			MBZ.Druid.Thorns = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz thorns bear|on|off|r")
		end
	elseif command == "trueshot" then
		if rest == "" then
			print("Track Trueshot Aura is set to |cffff0000"..MBZ.Hunter.Trueshot.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Trueshot Aura set to |cffff0000"..rest.."|r") 
			MBZ.Hunter.Trueshot = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz trueshot on|off|r")
		end
	elseif command == "aspect" then
		if rest == "" then
			print("Track Aspects is set to |cffff0000"..MBZ.Hunter.Aspect.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Aspects set to |cffff0000"..rest.."|r") 
			MBZ.Hunter.Aspect = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz aspect on|off|r")
		end
	elseif command == "cheetah" then
		if rest == "" then
			print("Warn on Cheetah/Pack is set to |cffff0000"..MBZ.Hunter.WarningC.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Warn on Cheetah/Pack set to |cffff0000"..rest.."|r") 
			MBZ.Hunter.WarningC = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz cheetah on|off|r")
		end
	elseif command == "viper" then
		if rest == "" then
			print("Warn on Viper is set to |cffff0000"..MBZ.Hunter.WarningV.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Warn on Viper set to |cffff0000"..rest.."|r") 
			MBZ.Hunter.WarningV = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz viper on|off|r")
		end
	elseif command == "ammo" then
		rest = tonumber(rest)
		if rest == "" then
			print("Low Ammo amount is set to |cffff0000"..MBZ.Hunter.Ammolow.."|r") 
			print('|cffff0000/mbz ammo #|r "Where # = a number.  Set to 0 to turn off.  Example: /mbz ammo 3000"')
		elseif rest >= 0 then
			print("Low Ammo amount set to |cffff0000"..rest.."|r") 
			MBZ.Hunter.Ammolow = rest
			BuffzDisplay()
		end
	elseif command == "int" then
		if rest == "" then
			print("Track Arcane Intellect is set to |cffff0000"..MBZ.Mage.Int.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Arcane Intellect set to |cffff0000"..rest.."|r") 
			MBZ.Mage.Int = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz int on|off|r")
		end
	elseif command == "armor" and select(2, UnitClass('player')) == "MAGE" then
		if rest == "" then
			print("Track Mage Armors is set to |cffff0000"..MBZ.Mage.Armor.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Mage Armors set to |cffff0000"..rest.."|r") 
			MBZ.Mage.Armor = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz armor on|off|r")
		end
	elseif command == "aura" then
		if rest == "" then
			print("Track Auras is set to |cffff0000"..MBZ.Paladin.Aura.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Auras Intellect set to |cffff0000"..rest.."|r") 
			MBZ.Paladin.Aura = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz aura on|off|r")
		end
	elseif command == "rf" then
		if rest == "" then
			print("Track Righteous Fury is set to |cffff0000"..MBZ.Paladin.RF.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Righteous Fury set to |cffff0000"..rest.."|r") 
			MBZ.Paladin.RF = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz rf on|off|r")
		end
	elseif command == "fort" then
		if rest == "" then
			print("Track Fortitude is set to |cffff0000"..MBZ.Priest.Fort.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Fortitude set to |cffff0000"..rest.."|r") 
			MBZ.Priest.Fort = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz fort on|off|r")
		end
	elseif command == "spirit" then
		if rest == "" then
			print("Track Divine Spirit is set to |cffff0000"..MBZ.Priest.Spirit.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Divine Spirit set to |cffff0000"..rest.."|r") 
			MBZ.Priest.Spirit = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz spirit on|off|r")
		end
	elseif command == "shadow" then
		if rest == "" then
			print("Track Shadow Protection is set to |cffff0000"..MBZ.Priest.Shadow.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Shadow Protection set to |cffff0000"..rest.."|r") 
			MBZ.Priest.Shadow = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz shadow on|off|r")
		end
	elseif command == "if" then
		if rest == "" then
			print("Track Inner Fire is set to |cffff0000"..MBZ.Priest.IF.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Inner Fire set to |cffff0000"..rest.."|r") 
			MBZ.Priest.IF = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz if on|off|r")
		end
	elseif command == "ve" then
		if rest == "" then
			print("Track Vampiric Embrace is set to |cffff0000"..MBZ.Priest.VE.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Vampiric Embrace set to |cffff0000"..rest.."|r") 
			MBZ.Priest.VE = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz ve on|off|r")
		end
	elseif command == "sform" then
		if rest == "" then
			print("Track Shadowform is set to |cffff0000"..MBZ.Priest.SForm.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Shadowform set to |cffff0000"..rest.."|r") 
			MBZ.Priest.SForm = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz sform on|off|r")
		end
	elseif command == "weapon" and select(2, UnitClass('player')) == "ROGUE" then
		if rest == "" then
			print("Track Poisons is set to |cffff0000"..MBZ.Rogue.Weapon.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Poisons set to |cffff0000"..rest.."|r") 
			MBZ.Rogue.Weapon = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz weapon on|off|r")
		end
	elseif command == "weapon" and select(2, UnitClass('player')) == "SHAMAN" then
		if rest == "" then
			print("Track Weapon Buffs is set to |cffff0000"..MBZ.Shaman.Weapon.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Weapon Buffs set to |cffff0000"..rest.."|r") 
			MBZ.Shaman.Weapon = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz weapon on|off|r")
		end
	elseif command == "shield" and select(2, UnitClass('player')) == "SHAMAN" then
		if rest == "" then
			print("Track Lightning/Water Shield is set to |cffff0000"..MBZ.Shaman.Shield.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Lightning/Water Shield set to |cffff0000"..rest.."|r") 
			MBZ.Shaman.Shield = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz shield on|off|r")
		end
	elseif command == "weapon" and select(2, UnitClass('player')) == "WARLOCK" then
		if rest == "" then
			print("Track Weapon Buffs is set to |cffff0000"..MBZ.Warlock.Weapon.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Weapon Buffs set to |cffff0000"..rest.."|r") 
			MBZ.Warlock.Weapon = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz weapon on|off|r")
		end
	elseif command == "armor" and select(2, UnitClass('player')) == "WARLOCK" then
		if rest == "" then
			print("Track Warlock Armors is set to |cffff0000"..MBZ.Warlock.Armor.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Warlock Armors set to |cffff0000"..rest.."|r") 
			MBZ.Warlock.Armor = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz armor on|off|r")
		end
	elseif command == "sl" then
		if rest == "" then
			print("Track Soul Link is set to |cffff0000"..MBZ.Warlock.SL.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Soul Link set to |cffff0000"..rest.."|r") 
			MBZ.Warlock.SL = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz sl on|off|r")
		end
	elseif command == "shout" then
		if rest == "" then
			print("Track Shouts is set to |cffff0000"..MBZ.Warrior.Shout.."|r") 
		elseif rest == "off" or rest == "on" then
			print("Track Shouts set to |cffff0000"..rest.."|r") 
			MBZ.Warrior.Shout = rest
			BuffzDisplay()
		else
			print("|cffff0000/mbz shout on|off|r")
		end
	elseif command == "reset" then
		MBZSetDefault()
		print("|cffff0000All options returned to default settings.|r")
	else --Command List
		print("|cff3399ffMyBuffz Commands:|r");
		print('|cffff0000/mbz flask raid|on|of|r "Track flasks (raid = only when in a raid instance)?"')
		print('|cffff0000/mbz combat on|of|r "Only track buffs during combat?"')
		print('|cffff0000/mbz resting on|of|r "Track buffs while resting?"')
		if select(2, UnitClass('player')) == "DEATHKNIGHT" then
			print('|cffff0000/mbz horn on|of|r "Track Horn of Winter?"')
			print('|cffff0000/mbz shield on|of|r "Track Bone Shield?"')
		end
		if select(2, UnitClass('player')) == "DRUID" then
			print('|cffff0000/mbz mark on|of|r "Track Mark of the Wild?"')
			print('|cffff0000/mbz thorns on|of|bear|r "Track Thorns (bear = only in bear form)?"')
		end
		if select(2, UnitClass('player')) == "HUNTER" then
			print('|cffff0000/mbz trueshot on|of|r "Track Trueshot Aura?"')
			print('|cffff0000/mbz aspect on|of|r "Track Aspects?"')
			print('|cffff0000/mbz cheetah on|of|r "Show warning for Cheetah/Pack active?"')
			print('|cffff0000/mbz viper on|of|r "Show warning for Viper active?"')
			print('|cffff0000/mbz ammo #|r "Low ammo warning amount? Example: /mbz ammo 4000 (Set to 0 to turn off)"')
		end
		if select(2, UnitClass('player')) == "MAGE" then
			print('|cffff0000/mbz int on|of|r "Track Arcane Intellect?"')
			print('|cffff0000/mbz armor on|of|r "Track Mage Armors?"')
		end
		if select(2, UnitClass('player')) == "PALADIN" then
			print('|cffff0000/mbz aura on|of|r "Track Paladin Aura?"')
			print('|cffff0000/mbz rf on|of|r "Track Righteous Fury?"')
		end
		if select(2, UnitClass('player')) == "PRIEST" then
			print('|cffff0000/mbz fort on|of|r "Track Fortitude?"')
			print('|cffff0000/mbz spirit on|of|r "Track Divine Spirit?"')
			print('|cffff0000/mbz shadow on|of|r "Track Shadow Protection?"')
			print('|cffff0000/mbz if on|of|r "Track Inner Fire?"')
			print('|cffff0000/mbz ve on|of|r "Track Vampiric Embrace?"')
			print('|cffff0000/mbz sform on|of|r "Track Shadow Form?"')
		end
		if select(2, UnitClass('player')) == "ROGUE" then
			print('|cffff0000/mbz weapon on|of|r "Track Poisons?"')
		end
		if select(2, UnitClass('player')) == "SHAMAN" then
			print('|cffff0000/mbz weapon on|of|r "Track Weapon Buffs?"')
			print('|cffff0000/mbz shield on|of|r "Track Water/Lightning Shield?"')
		end
		if select(2, UnitClass('player')) == "WARLOCK" then
			print('|cffff0000/mbz armor on|of|r "Track Warlock Armors?"')
			print('|cffff0000/mbz sl on|of|r "Track Soul Link?"')
			print('|cffff0000/mbz weapon on|of|r "Track Weapon Buffs?"')
		end
		if select(2, UnitClass('player')) == "WARRIOR" then
			print('|cffff0000/mbz shout on|of|r "Track Shouts?"')
		end
		print('|cffff0000/mbz reset|r "Reset *ALL* options back to default."')
	end
end