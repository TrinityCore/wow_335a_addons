function MyBuffz()
	local bFrame = CreateFrame("Frame","MyBuffz",UIParent,"MyBuffz")
	bFrame:SetFrameStrata("BACKGROUND")
	bFrame:SetPoint("CENTER",0,0)
	bFrame:Show()
	
	MBZText1 = bFrame:CreateFontString("urmomshawt1", "OVERLAY", "TextStatusBarText");
	--MBZText1:SetPoint("TOPLEFT", bFrame, "TOPLEFT", 0, 0);
	MBZText1:SetPoint("TOP", bFrame, "TOP", 0, 0);
	
	MBZText2 = bFrame:CreateFontString("urmomshawt2", "OVERLAY", "TextStatusBarText");
	--MBZText2:SetPoint("TOPLEFT", bFrame, "TOPLEFT", 0, 0);
	--MBZText2:SetJustifyH("LEFT")
	MBZText2:SetPoint("TOP", bFrame, "TOP", 0, 0);
	MBZText2:SetJustifyH("CENTER")
	
	bFrame:SetScript("OnEvent", BuffzDisplay);
	bFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	bFrame:RegisterEvent("ADDON_LOADED");
	bFrame:RegisterEvent("UNIT_AURA");
	bFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	bFrame:RegisterEvent("UNIT_INVENTORY_CHANGED");
	bFrame:RegisterEvent("PLAYER_UPDATE_RESTING");
	bFrame:RegisterEvent("PLAYER_UNGHOST");
	bFrame:RegisterEvent("PLAYER_ALIVE");
	bFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
	bFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
end


function BuffzDisplay()
	if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
		if MBZ == nil then
			MBZSetDefault()
		end
	end
	local bString = " "
	local wString = " "
	local inCombat	= UnitAffectingCombat("PLAYER");
	local level = UnitLevel("PLAYER")
	if((not IsResting() or MBZ.Resting == "on") and (inCombat == 1 or (inCombat ~= 1 and MBZ.Combat == "off")) and not UnitIsDeadOrGhost("PLAYER")) then
		----Death Knight----
		if select(2, UnitClass('player')) == "DEATHKNIGHT" then
			if MBZ.DK.Horn == "on" then
				if inCombat==1 then
					bString = buffDouble(65,"Horn of Winter","Horn of Winter","Strength of Earth",bString);
				end
			end
			if MBZ.DK.Shield == "on" then
				bString = buffTalent("Bone Shield",3,26,bString)
			end
		end
		----Druid----
		if select(2, UnitClass('player')) == "DRUID" then
			if MBZ.Druid.Mark == "on" then
				bString = buffDouble(0,"Mark of the Wild","Mark of the Wild","Gift of the Wild",bString);
			end
			if MBZ.Druid.Thorns == "on" then
				local isBuffed = UnitAura("Player","Thorns");
				if isBuffed == nil then
					bString = bString.."\nThorns"
				end
			elseif MBZ.Druid.Thorns == "bear" then
				local isBuffed1 = UnitAura("Player","Bear Form");
				local isBuffed2 = UnitAura("Player","Dire Bear Form");
				if isBuffed1 ~= nil or isBuffed2 ~= nil then
					local isBuffed = UnitAura("Player","Thorns");
					if isBuffed == nil then
						bString = bString.."\nThorns"
					end
				end
			end
		end
		----Hunter----
		if select(2, UnitClass('player')) == "HUNTER" then
			if(level >= 4) then
				local isBuffed1 = UnitAura("Player","Aspect of the Monkey");
				local isBuffed2 = UnitAura("Player","Aspect of the Hawk");
				local isBuffed3 = UnitAura("Player","Aspect of the Beast");
				local isBuffed4 = UnitAura("Player","Aspect of the Wild");
				local isBuffed5 = UnitAura("Player","Aspect of the Dragonhawk");
				local isBuffed6 = UnitAura("Player","Aspect of the Viper");
				local isBuffed7 = UnitAura("Player","Aspect of the Cheetah");
				local isBuffed8 = UnitAura("Player","Aspect of the Pack");
				if isBuffed8 ~= nil then
					if MBZ.Hunter.WarningC == "on" then
						wString = "Aspect of the Pack Active"
					end
				elseif isBuffed7 ~= nil then
					if MBZ.Hunter.WarningC == "on" then
						wString = "Aspect of the Cheetah Active"
					end
				elseif isBuffed6 ~= nil then
					if MBZ.Hunter.WarningV == "on" then
						wString = "Aspect of the Viper Active"
					end
				elseif isBuffed1 == nil and isBuffed2 == nil and isBuffed3 == nil and isBuffed4 == nil and isBuffed5 == nil then
					if MBZ.Hunter.Aspect == "on" then
						bString = bString.."\nAspect"
					end
				end
			end
			if MBZ.Hunter.Trueshot == "on" then
				local _,_,_,_,currentRank = GetTalentInfo(2,19)
				if currentRank ~= 0 then
					bString = buffTriple(0,"Trueshot Aura","Trueshot Aura","Abomination's Might","Unleashed Rage",bString);
				end
			end
			if MBZ.Hunter.Ammolow > 0 then
				local ammoSlot = GetInventorySlotInfo("AmmoSlot");
				local ammoCount = GetInventoryItemCount("player", ammoSlot);
				if ((ammoCount == 1) and (not GetInventoryItemTexture("player", ammoSlot))) then
					wString = wString.."\nNo Ammo Equiped"
				elseif (ammoCount <= MBZ.Hunter.Ammolow) then
					wString = wString.."\nLow Ammo: "..ammoCount
				end
			end
		end
		----Mage----
		if select(2, UnitClass('player')) == "MAGE" then
			if MBZ.Mage.Int == "on" then
				bString = buffTriple(0,"Intellect","Arcane Intellect","Arcane Brilliance","Dalaran Brilliance",bString);
			end
			if MBZ.Mage.Armor == "on" then
				bString = buffQuad(0,"Mage Armor","Frost Armor","Ice Armor","Molten Armor","Mage Armor",bString);
			end
		end
		----Paladin----
		if select(2, UnitClass('player')) == "PALADIN" then
			if MBZ.Paladin.Seal == "on" then
				local isBuffed1 = UnitAura("Player","Seal of Command");
				local isBuffed2 = UnitAura("Player","Seal of Righteousness");
				local isBuffed3 = UnitAura("Player","Seal of Justice");
				local isBuffed4 = UnitAura("Player","Seal of Light");
				local isBuffed5 = UnitAura("Player","Seal of Wisdom");
				local isBuffed6 = UnitAura("Player","Seal of Vengeance");
				local isBuffed7 = UnitAura("Player","Seal of Corruption");
				if isBuffed1 == nil and isBuffed2 == nil and isBuffed3 == nil and isBuffed4 == nil and isBuffed5 == nil and isBuffed6 == nil and isBuffed7 == nil then
					bString = bString.."\nSeal"
				end
			end
			if MBZ.Paladin.RF == "on" then
				bString = buffSingle(16,"Righteous Fury",bString)
			end
		end
		----Priest----
		if select(2, UnitClass('player')) == "PRIEST" then
			if MBZ.Priest.Fort == "on" then
				bString = buffDouble(0,"Fortitude","Power Word: Fortitude","Prayer of Fortitude",bString);
			end
			if MBZ.Priest.Spirit == "on" then
				bString = buffTriple(30,"Spirit","Divine Spirit","Prayer of Spirit","Fel Intelligence",bString);
			end
			if MBZ.Priest.Shadow == "on" then
				bString = buffDouble(30,"Shadow Protection","Shadow Protection","Prayer of Shadow Protection",bString);
			end
			if MBZ.Priest.IF == "on" then
				bString = buffSingle(12,"Inner Fire",bString);
			end
			if MBZ.Priest.VE == "on" then
				bString = buffTalent("Vampiric Embrace",3,14,bString)
			end
			if MBZ.Priest.SForm == "on" then
				bString = buffTalent("Shadowform",3,19,bString)
			end
		end
		----Rogue----
		if select(2, UnitClass('player')) == "ROGUE" then
			if MBZ.Rogue.Weapon == "on" then
				bString = buffWeapon(20,bString);
			end
		end
		----Shaman----
		if select(2, UnitClass('player')) == "SHAMAN" then
			if MBZ.Shaman.Shield == "on" then
				bString = buffDouble(8,"Water/Lightning Shield","Lightning Shield","Water Shield",bString);
			end
			if MBZ.Shaman.Weapon == "on" then
				bString = buffWeapon(0,bString);
			end
		end
		----Warlock----
		if select(2, UnitClass('player')) == "WARLOCK" then
			if MBZ.Warlock.Armor == "on" then
				bString = buffTriple(0,"Fel/Demon Armor","Fel Armor","Demon Armor","Demon Skin",bString);
			end
			if MBZ.Warlock.SL == "on" then
				if(not IsMounted() and not UnitInVehicle("PLAYER")) then
					bString = buffTalent("Soul Link",2,9,bString)
				end
			end
			if MBZ.Warlock.Weapon == "on" then
				bString = buffWeapon(28,bString);
			end
		end
		----Warrior----
		if select(2, UnitClass('player')) == "WARRIOR" then
			if MBZ.Warrior.Shout == "on" then
				if inCombat==1 then
					local isBuffed1,_,_,_,_,_,_,isMine1 = UnitAura("Player","Battle Shout");
					local isBuffed2,_,_,_,_,_,_,isMine2 = UnitAura("Player","Commanding Shout");
					local isBuffed3,_,_,_,_,_,_,isMine3 = UnitAura("Player","Blessing of Might");
					local isBuffed4,_,_,_,_,_,_,isMine4 = UnitAura("Player","Greater Blessing of Might");
					if((isBuffed1 ~= nil and (isBuffed2 ~= nil or isBuffed3 ~= nil or isBuffed4 ~= nil)) or isMine1 == "player" or isMine2 == "player") then
					else
						bString = bString.."\nShout"
					end
				end
			end
		end
		----General----
		if MBZ.Flask == "on" then
			bString = buffQuad(80,"Flask","Flask of Stoneblood","Flask of Pure Mojo","Flask of Endless Rage","Flask of the Frost Wyrm",bString);
		elseif MBZ.Flask == "raid" then
			local inInstance, instanceType = IsInInstance();
			if (inInstance and (instanceType == "raid") and level == 80) then
				bString = buffQuad(80,"Flask","Flask of Stoneblood","Flask of Pure Mojo","Flask of Endless Rage","Flask of the Frost Wyrm",bString);
			end
		end
	end
	
	
	--Set Text
	wString = "\n\n|c000000ff"..wString.."|r"
	MBZText1:SetText("Missing Buffs:")
	MBZText1:SetFont("Fonts\\FRIZQT__.TTF",15,"OUTLINE")
	bLen = string.len(bString)
	if(bLen >= 3) then
		MBZText1:SetTextColor(1, 0, 0, 1);
	else
		MBZText1:SetTextColor(1, 0, 0, 0);
	end
	MBZText2:SetText(bString..wString)
	MBZText2:SetTextColor(0, 1, 1, 1);
	MBZText2:SetFont("Fonts\\MORPHEUS.TTF",20,"OUTLINE")
end





-- Buff Check Functions
function buffSingle(lvl,bName,bString)
	local level = UnitLevel("PLAYER")
	if(level >= lvl) then
		local isBuffed = UnitAura("Player",bName);
		if isBuffed == nil then
			bString = bString.."\n"..bName
		end
	end
	return bString;
end

function buffDouble(lvl,bName,bName1,bName2,bString)
	local level = UnitLevel("PLAYER")
	if(level >= lvl) then
		local isBuffed1 = UnitAura("Player",bName1);
		local isBuffed2 = UnitAura("Player",bName2);
		if isBuffed1 == nil and isBuffed2 == nil then
			bString = bString.."\n"..bName
		end
	end
	return bString;
end

function buffTriple(lvl,bName,bName1,bName2,bName3,bString)
	local level = UnitLevel("PLAYER")
	if(level >= lvl) then
		local isBuffed1 = UnitAura("Player",bName1);
		local isBuffed2 = UnitAura("Player",bName2);
		local isBuffed3 = UnitAura("Player",bName3);
		if isBuffed1 == nil and isBuffed2 == nil and isBuffed3 == nil then
			bString = bString.."\n"..bName
		end
	end
	return bString;
end

function buffQuad(lvl,bName,bName1,bName2,bName3,bName4,bString)
	local level = UnitLevel("PLAYER")
	if(level >= lvl) then
		local isBuffed1 = UnitAura("Player",bName1);
		local isBuffed2 = UnitAura("Player",bName2);
		local isBuffed3 = UnitAura("Player",bName3);
		local isBuffed4 = UnitAura("Player",bName4);
		if isBuffed1 == nil and isBuffed2 == nil and isBuffed3 == nil and isBuffed4 == nil then
			bString = bString.."\n"..bName
		end
	end
	return bString;
end

function buffTalent(bName,bTab,bLoc,bString)
	local name, iconPath, tier, column, currentRank = GetTalentInfo(bTab,bLoc)
	if currentRank ~= 0 then
		local isBuffed = UnitAura("Player",bName);
		if isBuffed == nil then
			bString = bString.."\n"..bName
		end
	end
	return bString;
end

function buffWeapon(lvl, bString)
	local level = UnitLevel("PLAYER")
	if(level >= lvl) then
		local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo();
		local hasWeapon = OffhandHasWeapon();
		if hasMainHandEnchant == nil then
			bString = bString.."\nWeapon Buff (Main)"
		end
		if hasWeapon ~= nil then
			if hasOffHandEnchant == nil then
				bString = bString.."\nWeapon Buff (Off)"
			end
		end
	end
	return bString;
end
--End of Buff Check Functions


--[[
Currently Tracked Buffs:
Death Knight
- Horn of Winter (Combat Only)
- Bone Shield
Druid
- Mark of the Wild
- Thorns (Only in Bear Form)
Hunter
- Trueshot Aura
- Aspects
- Warning for Cheetah/Pack/Viper
Mage
- Intellect
- Frost/Ice/Molten/Mage Armor
Paladin
- Righteous Fury (If Blessing of Sanc. Talented)
- Seal
Priest
- Fortitude
- Spirit
- Shadow Protection
- Inner Fire
- Vampiric Embrace
- Shadowform
Rogue
- Poisons
Shaman
- Water/Lightning Shield
- Weapon Buff
Warlock
- Fel/Demon Armor
- Soul Link
- Weapon Buff
Warrior
- Battle/Commanding Shout (Combat Only)
--]]


--[[
Change Log:
Trueshot Aura - Now check's for Abomination's Might and Unleashed Rage
Slash commands.
--]]