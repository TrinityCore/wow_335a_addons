if select(2, UnitClass("player")) ~= "DRUID" then return end
local GetSpellInfo = GetSpellInfo
local GetCombatRatingBonus = GetCombatRatingBonus
local GetCritChance = GetCritChance
local IsEquippedItem = IsEquippedItem
local UnitExists = UnitExists
local UnitIsFriend = UnitIsFriend
local UnitIsUnit = UnitIsUnit
local UnitBuff = UnitBuff
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitPower = UnitPower
local UnitStat = UnitStat
local string_match = string.match
local math_floor = math.floor
local math_abs = math.abs
local UnitLevel = UnitLevel
local select = select
local tonumber = tonumber


function DrDamage:PlayerData()
	--Health updates
	self.TargetHealth = { [1] = 0.5, [0.5] = GetSpellInfo(774) }
	--Events
	local lastEnergy = 0
	local fbite = GetSpellInfo(22568)
	function DrDamage:UNIT_ENERGY(units)
		if units["player"] then
			local energy = UnitPower("player",3)
			if (energy < 65) and (lastEnergy > 65 or math_abs(energy - lastEnergy) >= 20) or (energy >= 65 and lastEnergy < 65) then
				lastEnergy = energy
				self:UpdateAB(fbite)
			end
		end
	end	
	--Innervate
	self.ClassSpecials[GetSpellInfo(29166)] = function()
		if UnitLevel("player") == 80 then
			if UnitExists("target") and UnitIsFriend("target","player") and self:HasGlyph(54832) then
				return 0.45 * 3496, nil, true
			else
				return (2.25 + (self:HasGlyph(54832) and 0.45 or 0)) * 3496, nil, true
			end
		end
	end
--GENERAL
	local tol, tol2 = GetSpellInfo(48371)
	local moonkin = GetSpellInfo(24858)
	local direbear = GetSpellInfo(9634)
	local bear = GetSpellInfo(5487)
	local cat = GetSpellInfo(768)
	local mas = GetSpellInfo(48412)
	self.Calculation["DRUID"] = function( calculation, ActiveAuras, Talents, spell, baseSpell )
		if calculation.healingSpell then
			if Talents["Master Shapeshifter"] and UnitBuff("player", tol, tol2) and calculation.spellName ~= "Lifebloom" then
				--Multiplicative - 3.3.3
				calculation.dmgM = calculation.dmgM * (1 + Talents["Master Shapeshifter"])
			end
			--Glyph of Frenzied Regeneration (multiplicative - 3.3.3)
			if ActiveAuras["Frenzied Regeneration"] and self:HasGlyph(54810) then
				calculation.dmgM = calculation.dmgM * 1.2
			end
		else
			if not baseSpell.Melee or baseSpell.Melee and calculation.school ~= "Physical" then
				if Talents["Naturalist"] then
					calculation.dmgM = calculation.dmgM / ( 1 + Talents["Naturalist"] )
				end
				if Talents["Master Shapeshifter"] and (UnitBuff("player", bear) or UnitBuff("player",direbear)) then
					calculation.dmgM = calculation.dmgM / (1 + Talents["Master Shapeshifter"])
				end
				if Talents["Improved Faerie Fire"] and ActiveAuras["Faerie Fire"] then
					calculation.critPerc = calculation.critPerc + 1 * Talents["Improved Faerie Fire"]
					if not ActiveAuras["+3% hit"] then
						calculation.hitPerc = calculation.hitPerc + 1 * Talents["Improved Faerie Fire"]
						ActiveAuras["+3% hit"] = true
					end
				end
			end
			if UnitBuff("player", moonkin) and Talents["Master Shapeshifter"] then
				calculation.dmgM = calculation.dmgM * (1 + Talents["Master Shapeshifter"])
			end
		end
	end
--TALENTS
	self.Calculation["Primal Gore (Rip)"] = function( calculation )
		calculation.NoCrits = false
	end
	self.Calculation["Primal Gore (Lacerate)"] = function( calculation )
		calculation.E_canCrit = true
	end
--ABILITIES
	self.Calculation["Attack"] = function( calculation, _, Talents )
		if Talents["Predatory Instincts"] and UnitBuff("player",cat) then
			calculation.critM = calculation.critM + Talents["Predatory Instincts"]
		end
	end
	self.Calculation["Lifebloom"] = function( calculation, _, Talents, _, baseSpell )
		if UnitExists("target") and not UnitIsUnit("target","player") then
			if UnitBuff("target",tol, tol2) and UnitBuff("target",mas) then
				calculation.dmgM = calculation.dmgM * 1.04
			elseif Talents["Master Shapeshifter"] and UnitBuff("player",tol, tol2) then
				calculation.dmgM_dot = calculation.dmgM_dot * (1 + Talents["Master Shapeshifter"])
			end
		else
			if Talents["Master Shapeshifter"] and UnitBuff("player",tol, tol2) then
				calculation.dmgM = calculation.dmgM * (1 + Talents["Master Shapeshifter"])
			end
		end
		--Glyph of Lifebloom
		if self:HasGlyph(54826) then
			calculation.eDuration = calculation.eDuration + 1
		end
		--Idol of Lush Moss
		if IsEquippedItem(40711) then
			calculation.hybridDotDmg = calculation.hybridDotDmg + 125 * baseSpell.dotFactor
		--Idol of the Emerald Queen
		elseif IsEquippedItem(27886) then
			calculation.hybridDotDmg = calculation.hybridDotDmg + 47 * baseSpell.dotFactor
		end
		if calculation.RelicBonus then
			calculation.finalMod = calculation.finalMod + calculation.RelicBonus * calculation.dmgM
		end
	end
	self.Calculation["Nourish"] = function( calculation, ActiveAuras )
		local hotCount = 0
		--Nourish bonus if Rejuvenation, Regrowth, Lifebloom, or Wild Growth are active on the target
		if ActiveAuras["Rejuvenation"] then hotCount = hotCount + 1 end
		if ActiveAuras["Regrowth"] then hotCount = hotCount + 1 end
		if ActiveAuras["Lifebloom"] then hotCount = hotCount + 1 end
		if ActiveAuras["Wild Growth"] then hotCount = hotCount + 1 end
		if hotCount > 0 then
			local bonus = 0
			if self:GetSetAmount( "T7 Resto" ) >= 4 then
				bonus = bonus + 0.05 * hotCount
			end
			--Glyph of Nourish (additive  3.3.3)
			if self:HasGlyph(62971) then
				bonus = bonus + 0.06 * hotCount
			end
			--Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1.2 + bonus)
		end
		if self:GetSetAmount("T9 Resto") >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Healing Touch"] = function( calculation )
		--Glyph of Healing Touch (additive - 3.3.3)
		if self:HasGlyph(54825) then
			calculation.dmgM_Add = calculation.dmgM_Add - 0.5
		end
	end
	local swiftmend = GetSpellInfo(18562)
	local rej_id = GetSpellInfo(774)
	local reg_id = GetSpellInfo(16561)
	self.Calculation["Swiftmend"] = function( calculation, ActiveAuras, Talents )
		local rej, reg, rej_rank, reg_rank
		local healingTarget = calculation.target
		if ActiveAuras["Rejuvenation"] then
			local index = ActiveAuras["Rejuvenation"]
			rej = (index > 0) and select(7,UnitBuff(healingTarget, index)) or 12
			rej_rank = (index > 0) and select(2,UnitBuff(healingTarget, index))
			rej_rank = rej_rank and tonumber(string_match(rej_rank,"%d+")) or 15
		end
		if ActiveAuras["Regrowth"] then
			local index = ActiveAuras["Regrowth"]
			reg = (index > 0) and select(7,UnitBuff(healingTarget, index)) or 21
			reg_rank = (index > 0) and select(2,UnitBuff(healingTarget, index))
			reg_rank = reg_rank and tonumber(string_match(reg_rank,"%d+")) or 12
		end
		if rej and reg then
			rej, reg = (rej <= reg), (reg < rej)
		end
		if rej then
			local spell = self.spellInfo[rej_id][rej_rank]
			calculation.minDam = (12/15) * spell[1]
			calculation.maxDam = calculation.minDam			
			calculation.spellDmgM = (12/15) * 1.88 * (1 + (Talents["Empowered Rejuvenation"] or 0))
			calculation.dmgM_Add = calculation.dmgM_Add + (Talents["Improved Rejuvenation"] or 0)
			calculation.tooltipName = swiftmend
			calculation.tooltipName2 = rej_id
		elseif reg then
			local baseSpell = self.spellInfo[reg_id][0]
			local spell = self.spellInfo[reg_id][reg_rank]
			calculation.minDam = (18/21) * spell.hybridDotDmg
			calculation.maxDam = calculation.minDam
			calculation.spellDmgM = (18/21) * baseSpell.dotFactor * (1 + (Talents["Empowered Rejuvenation"] or 0))
			calculation.tooltipName = swiftmend
			calculation.tooltipName2 = reg_id
		end
		if self:GetSetAmount("T8 Resto") >= 2 then
			--Additive/multiplicative?
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
	self.Calculation["Regrowth"] = function( calculation, ActiveAuras )
		--Glyph of Regrowth (multiplicative = 3.3.3)
		if ActiveAuras["Regrowth"] and self:HasGlyph(54743) then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Rejuvenation"] = function( calculation, ActiveAuras, _, spell )
		--Glyph of Rejuvenation (multiplicative - 3.3.3)
		if self:HasGlyph(54754) then
			local target = calculation.target
			if target and (UnitHealth(target) ~= 0) and (UnitHealth(target) / UnitHealthMax(target) < 0.5) then
				calculation.dmgM = calculation.dmgM * 1.5
			end
		end
		--Glyph of Rapid Rejuvenation
		if self:HasGlyph(71013) then
			calculation.customHaste = true
		end
		if self:GetSetAmount("T8 Resto") >= 4 then
			--Benefits from ToL, MaSh, Emp. Rej. No benefits: Genesis, Imp. rej and GoN
			calculation.extra = calculation.dmgM * ((3/(spell.eDuration or 12)) * (spell[1] + calculation.spellDmgM * calculation.spellDmg) * 0.5)
			calculation.extraName = "4T8"
		end
		if self:GetSetAmount("T9 Resto") >= 4 then
			calculation.canCrit = true
		end
	end
	self.Calculation["Wild Growth"] = function( calculation )
		if self:GetSetAmount("T10 Resto") >= 2 then
			calculation.bDmgM = calculation.bDmgM * (79/70)
		end
	end
	self.Calculation["Moonfire"] = function( calculation )
		--Glyph of Moonfire (additive - 3.3.3)
		if self:HasGlyph(54829) then
			--Bonuses/penalties are additive, applied directly to talent effects
			calculation.dmgM_dd_Add = calculation.dmgM_dd_Add + calculation.dmgM_Add - 0.9
			calculation.dmgM_dot_Add = calculation.dmgM_dot_Add + calculation.dmgM_Add + 0.75
			calculation.dmgM_Add = 0
		end
		if self:GetSetAmount("T9 Moonkin") >= 2 then
			calculation.hybridCanCrit = true
		end
	end
	self.Calculation["Starfall"] = function( calculation, _, _, spell, baseSpell )
		--Glyph of Focus (A/M? - currently doesn't matter)
		if self:HasGlyph(62080) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if calculation.targets > 1 then
			calculation.sHits = 20
			calculation.extra = spell.extraAoe
			calculation.extraDamage = baseSpell.ExtraSPBonus
			calculation.extraBonus = true
		end
	end
	self.Calculation["Wrath"] = function( calculation, ActiveAuras, Talents, spell )
		if ActiveAuras["Insect Swarm"] and Talents["Improved Insect Swarm"] then
			--Multiplcative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1 + (Talents["Improved Insect Swarm"] * 0.01))
		end
		if self:GetSetAmount("T7 Moonkin") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
		if self:GetSetAmount("T9 Moonkin") >= 4 then
			--Additive - 3.3.3
			calculation.dmgM_Add = calculation.dmgM_Add + 0.04
		end
		if self:GetSetAmount("T10 Moonkin") >= 4 then
			calculation.extraAvg = 0.07
			calculation.extraTicks = 2
			calculation.extraName = "4T10"
		end
	end
	self.Calculation["Starfire"] = function( calculation, ActiveAuras, Talents, spell )
		if ActiveAuras["Moonfire"] and Talents["Improved Insect Swarm"] then
			calculation.critPerc = calculation.critPerc + Talents["Improved Insect Swarm"]
		end
		--Idol of the Shooting Star, doesn't get talent bonus, only target debuffs
		if IsEquippedItem(40321) then
			calculation.finalMod = calculation.finalMod + 165 * calculation.dmgM / (1 + (Talents["Earth And Moon"] or 0))
		--Ivory Idol of the Moongoddess
		elseif IsEquippedItem(27518) then
			calculation.finalMod = calculation.finalMod + 55 * calculation.dmgM / (1 + (Talents["Earth And Moon"] or 0))
		end
		if self:GetSetAmount("T7 Moonkin") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
		if self:GetSetAmount("T9 Moonkin") >= 4 then
			--Additive - 3.3.3
			calculation.dmgM_Add = calculation.dmgM_Add + 0.04
		end
		if self:GetSetAmount("T10 Moonkin") >= 4 then
			calculation.extraAvg = 0.07
			calculation.extraTicks = 2
			calculation.extraName = "4T10"
		end
	end
	self.Calculation["Insect Swarm"] = function( calculation )
		--Glyph of Insect Swarm (additive - 3.3.3)
		if self:HasGlyph(54830) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.3
		end
		if self:GetSetAmount("T7 Moonkin") >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
 	self.Calculation["Maul"] = function( calculation, ActiveAuras, Talents, spell )
		if Talents["Rend and Tear"] and ActiveAuras["Bleeding"] then
			--Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1 + (0.04 * Talents["Rend and Tear"]))
		end
	end
	self.Calculation["Shred"] = function( calculation, ActiveAuras, Talents, spell )
		if Talents["Rend and Tear"] and ActiveAuras["Bleeding"] then
			--Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1 + (0.04 * Talents["Rend and Tear"]))
		end
	end
	self.Calculation["Ferocious Bite"] = function( calculation, ActiveAuras, Talents, spell )
		if Talents["Rend and Tear"] and ActiveAuras["Bleeding"] then
			calculation.critPerc = calculation.critPerc +  5 * Talents["Rend and Tear"]
		end
		if self:GetSetAmount( "T9 Feral" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
		calculation.maxCost = 30
	end	
	self.Calculation["Rip"] = function( calculation )
		--Glyph of Rip
		if self:HasGlyph(54818) then
			calculation.eDuration = calculation.eDuration + 4
		end
		if self:GetSetAmount( "T7 Feral" ) >= 2 then
			calculation.eDuration = calculation.eDuration + 2
		end
		if IsEquippedItem(39757) then --Idol of Worship
			local cp = calculation.Melee_ComboPoints
			calculation.minDam = calculation.minDam + 21 * cp
			calculation.maxDam = calculation.maxDam + 21 * cp
		elseif IsEquippedItem(28372) then --Idol of Feral Shadows
			local cp = calculation.Melee_ComboPoints
			calculation.minDam = calculation.minDam + 7 * cp
			calculation.maxDam = calculation.maxDam + 7 * cp
		end
		if self:GetSetAmount( "T9 Feral" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Faerie Fire (Feral)"] = function( calculation )
		if not UnitBuff("player",bear) and not UnitBuff("player",direbear) then
			calculation.zero = true
		end
	end
	self.Calculation["Mangle (Bear)"] = function( calculation, ActiveAuras )
		if ActiveAuras["Berserk"] then
			calculation.aoe = 3
		end
		--Glyph of Mangle (multiplicative with Savage Fury - 3.3.3)
		if self:HasGlyph(54813) then
			calculation.dmgM = calculation.dmgM * 1.1
		end
	end
	self.Calculation["Mangle (Cat)"] = function( calculation )
		--Glyph of Mangle (multiplicative with Savage Fury - 3.3.3)
		if self:HasGlyph(54813) then
			calculation.dmgM = calculation.dmgM * 1.1
		end
	end	
	self.Calculation["Force of Nature"] = function( calculation, ActiveAuras, Talents )
		--Crit: receives no bonus from crit rating or int. Depressed against higher level targets
		--Haste: receives no bonus from haste rating.
		--AP: receives no bonus from AP
		local spd = 1.8 / calculation.haste
		--Assume one second is wasted of the 30 second duration
		calculation.Hits = 3 * math_floor((29/spd) + 0.5)
		calculation.APBonus = 1/14 * 1.8
		local SP = calculation.spellDmg - (Talents["Lunar Guidance"] or 0) * select(2,UnitStat("player",4))
		if Talents["Improved Moonkin Form"] and UnitBuff("player", moonkin) then
			SP = SP - Talents["Improved Moonkin Form"] * select(2,UnitStat("player",5))
		end
		calculation.AP = math_floor( 642 + 0.57 * SP + 0.5 )
		calculation.critPerc = calculation.critPerc - GetCritChance() + 6.5
		calculation.hitPerc = calculation.hitPerc - GetCombatRatingBonus(6) + 8 * GetCombatRatingBonus(8) / 17
		calculation.expertise = math_floor(26 * GetCombatRatingBonus(8)/17 + 0.5)
		calculation.armorPen = 0
		calculation.minDam = calculation.minDam + 0.023 * SP
		calculation.maxDam = calculation.maxDam + 0.023 * SP
	end
	self.Calculation["Lacerate"] = function( calculation )
		if IsEquippedItem(27744) then --Idol of Ursoc
			calculation.extra = calculation.extra + 8
			calculation.minDam = calculation.minDam + 8
			calculation.maxDam = calculation.maxDam + 8
		end
		--TODO: Set bonuses A/M? - currently doesn't matter
		if self:GetSetAmount("T7 Feral" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.05
		end		
		if self:GetSetAmount("T9 Feral" ) >= 2 then
			calculation.dmgM_Extra_Add = calculation.dmgM_Extra_Add + 0.05
		end
		if self:GetSetAmount("T10 Feral") >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Swipe (Bear)"] = function( calculation )
		if self:GetSetAmount("T10 Feral") >= 2 then
			--TODO: A/M?
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end	
	self.Calculation["Rake"] = function( calculation )
		if self:GetSetAmount( "T9 Feral" ) >= 2 then
			calculation.E_eDuration = calculation.E_eDuration + 3
		end
		if self:GetSetAmount("T10 Feral") >= 4 then
			calculation.E_canCrit = true
		end
	end
--SETS
	self.SetBonuses["T7 Feral"] = { 40471, 40472, 40473, 40493, 40494, 39553, 39554, 39555, 39556, 39557 }
	self.SetBonuses["T7 Moonkin"] = { 40466, 40467, 40468, 40469, 40470, 39544, 39545, 39546, 39547, 39548 }
	self.SetBonuses["T7 Resto"] = { 40460, 40461, 40462, 40463, 40465, 39531, 39538, 39539, 39542, 39543 }
	self.SetBonuses["T8 Moonkin"] = { 46189, 46191, 46192, 46194, 45196, 45351, 45352, 45353, 45354, 46414 }
	self.SetBonuses["T8 Resto"] = { 46183, 46184, 46185, 46186, 46187, 45345, 45346, 45347, 45348, 45349 }
	self.SetBonuses["T9 Feral"] = { 48213, 48214, 48215, 48216, 48217, 48188, 48189, 48190, 48191, 48192, 48193, 48194, 48195, 48196, 48197, 48202, 48201, 48200, 48199, 48198, 48212, 48211, 48210, 48209, 48208, 48203, 48204, 48205, 48206, 48207 }
	self.SetBonuses["T9 Moonkin"] = { 48158, 48159, 48160, 48161, 48162, 48183, 48184, 48185, 48186, 48187, 48164, 48163, 48167, 48165, 48166, 48171, 48172, 48168, 48170, 48169, 48181, 48182, 48178, 48180, 48179, 48174, 48173, 48177, 48175, 48176 }
	self.SetBonuses["T9 Resto"] = { 48102, 48129, 48130, 48131, 48132, 48153, 48154, 48155, 48156, 48157, 48133, 48134, 48135, 48136, 48137, 48142, 48141, 48140, 48139, 48138, 48152, 48151, 48150, 48149, 48148, 48143, 48144, 48145, 48146, 48147 }
	self.SetBonuses["T10 Feral"] = { 50827, 50826, 50825, 50828, 50824, 51295, 51144, 51296, 51143, 51297, 51142, 51298, 51141, 51299, 51140 }
	self.SetBonuses["T10 Moonkin"] = { 50821, 50822, 50819, 50820, 50823, 51290, 51149, 51291, 51148, 51292, 51147, 51293, 51146, 51294, 51145 }
	self.SetBonuses["T10 Resto"] = { 50107, 50108, 50109, 50113, 50106, 51301, 51138, 51302, 51137, 51303, 51136, 51304, 51135, 51300, 51139 }
--RELICS
--Caster
	self.RelicSlot["Lifebloom"] = {
		--Savage, Hateful, Deadly, Furious, Relentless, Wrathful
		 42576, 188, 42577, 217, 42578, 246, 42579, 294, 42580, 376, 51423, 448,
		ModTypeAll = "RelicBonus", 
	}
	--Idol of Pure Thoughts (TODO: verify), Harold's Rejuvenating Broach, Idol of Rejuvenation
	self.RelicSlot["Rejuvenation"] = { 38366, 132, 25643, 86, 22398, 50, ModType1 = "Base" }
	--Idol of the Avian Heart, Idol of Health
	self.RelicSlot["Healing Touch"] = { 28568, 136, 22399, 100, ModType1 = "Base", ModType2 = "Base" }
	--Idol of Steadfast Renewal, Idol of the Avenger
	self.RelicSlot["Wrath"] = { 40712, 70, 31025, 25, ModType1 = "Base", ModType2 = "Base" }
	--Idol of the Moon
	self.RelicSlot["Moonfire"] = { 23197, 33 }
	--Idol of the Crying Wind
	self.RelicSlot["Insect Swarm"] = { 45270, 374 }
	--Idol of the Flourishing Life
	self.RelicSlot["Nourish"] = { 46138, 187 }
--Melee
	--Idol of the Ravenous Beast, Everbloom idol
	self.RelicSlot["Shred"] = { 40713, 203, 29390, 88, }
	--Idol of the Wild
	self.RelicSlot["Mangle (Cat)"] = { 28064, 24, }
	self.RelicSlot["Mangle (Bear)"] = { 28064, 51.75, }
	--Idol of Perspicacious Attacks, Idol of Brutality
	self.RelicSlot["Maul"] = { 38365, 120, 23198, 50 }
	self.RelicSlot["Swipe"] = { 38365, 24, 23198, 10 }
	--Idol of Ferocity, Idol of Savagery (Horde), Idol of Savagery (Alliance)
	self.RelicSlot["Rake"] = { 22397, 20, 27989, 30, 27990, 30 }
	self.RelicSlot["Claw"] = { 22397, 20, 27989, 30, 27990, 30 }
--AURA
--Player
	--Nature's Grace
	self.PlayerAura[GetSpellInfo(16880)] = { Update = true }
	--Rejuvenation
	self.PlayerAura[GetSpellInfo(774)] = { Update = true, Spells = { 50464, 18562 }, ID = 774 }
	--Regrowth
	self.PlayerAura[GetSpellInfo(16561)] = { Update = true, Spells = { 50464, 18562 }, ID = 16561 }
	--Lifebloom
	self.PlayerAura[GetSpellInfo(33763)] = { Update = true, Spells = 50464, ID = 33763 }
	--Wild Growth
	self.PlayerAura[GetSpellInfo(48438)] = { Update = true, Spells = 50464, ID = 48438 }
	--Frenzied Regeneration
	self.PlayerAura[GetSpellInfo(22842)] = { School = "Healing", ActiveAura = "Frenzied Regeneration", ID = 22842 }
	--Elune's Wrath (4p T8 Moonkin)
	self.PlayerAura[GetSpellInfo(64823)] = { Update = true, Spells = 2912 }
	--Wrath of Elune (Gladiator 4p set bonus for Starfire cast time)
	self.PlayerAura[GetSpellInfo(46833)] = self.PlayerAura[GetSpellInfo(64823)]	
	--Omen of Doom (2p proc from T10 Moonkin)
	--TODO: Additive or multiplicative?
	self.PlayerAura[GetSpellInfo(70721)] = { School = { ["Nature"] = true, ["Arcane"] = true }, Value = 0.15, ID = 70721 }	
--Target
	--Rejuvenation
	self.TargetAura[GetSpellInfo(774)] = { Spells = { 50464, 18562 }, ActiveAura = "Rejuvenation", Index = true, SelfCastBuff = true, ID = 774 }
	--Regrowth
	self.TargetAura[GetSpellInfo(16561)] = { Spells = { 50464, 18562, 8936 }, ActiveAura = "Regrowth", Index = true, SelfCastBuff = true, ID = 16561 }
	--Lifebloom
	self.TargetAura[GetSpellInfo(33763)] = { Spells = 50464, ActiveAura = "Lifebloom", SelfCastBuff = true, ID = 33763 }
	--Wild Growth
	self.TargetAura[GetSpellInfo(48438)] = { Spells = 50464, ActiveAura = "Wild Growth", SelfCastBuff = true, ID = 48438 }
	--Moonfire
	self.TargetAura[GetSpellInfo(8921)] = { Spells = 2912, ActiveAura = "Moonfire", ID = 8921 }
	--Insect Swarm
	self.TargetAura[GetSpellInfo(5570)] = { Spells = { 2912, 5176 }, ActiveAura = "Insect Swarm", ID = 5570 }
	--Master Shapeshifter
	self.TargetAura[GetSpellInfo(48412)] = { Update = true }
--Bleed effects
	--Deep Wound
	self.TargetAura[GetSpellInfo(43104)] = 	{ ActiveAura = "Bleeding", Manual = "Bleeding", ID = 59881 }
	--Rend
	self.TargetAura[GetSpellInfo(16403)] = 	self.TargetAura[GetSpellInfo(43104)]
	--Garrote
	self.TargetAura[GetSpellInfo(703)] = 	self.TargetAura[GetSpellInfo(43104)]
	--Rupture
	self.TargetAura[GetSpellInfo(1943)] = 	self.TargetAura[GetSpellInfo(43104)]
	--Lacerate
	self.TargetAura[GetSpellInfo(33745)] = 	self.TargetAura[GetSpellInfo(43104)]
	--Pounce
	self.TargetAura[GetSpellInfo(9005)] = 	self.TargetAura[GetSpellInfo(43104)]
	--Rip
	self.TargetAura[GetSpellInfo(1079)] = 	self.TargetAura[GetSpellInfo(43104)]
	--Rake
	self.TargetAura[GetSpellInfo(59881)] = 	self.TargetAura[GetSpellInfo(43104)]
	--Piercing Shots
	self.TargetAura[GetSpellInfo(53234)] = 	self.TargetAura[GetSpellInfo(43104)]
--Custom
	--Faerie Fire
	self.TargetAura[GetSpellInfo(770)].ActiveAura = "Faerie Fire"
	self.TargetAura[GetSpellInfo(770)].SelfCast = true
	--Savage Roar (needs to be divided out of spell modifiers)
	self.PlayerAura[GetSpellInfo(52610)] = { School = "Damage Spells", Caster = true, NoManual = true, ModType =
		function( calculation, _, _, index )
			if index then
				--Glyph of Savage Roar
				calculation.dmgM = calculation.dmgM / (1.3 + (self:HasGlyph(63055) and 0.03 or 0))
			end
		end
	}
	--Eclipse (Solar) - Wrath bonus
	self.PlayerAura[GetSpellInfo(48517)] = { Spells = 5176, ID = 48517, ModType =
		function( calculation )
			--Additive - 3.3.3
			calculation.dmgM_Add = calculation.dmgM_Add + 0.4 + ((self:GetSetAmount("T8 Moonkin" ) >= 2) and 0.07 or 0)
		end
	}
	--Eclipse (Lunar) - Stafire bonus
	self.PlayerAura[GetSpellInfo(48518)] = { Spells = 2912, ID = 48518, ModType =
		function( calculation )
				calculation.critPerc = calculation.critPerc + 40 + ((self:GetSetAmount("T8 Moonkin" ) >= 2) and 7 or 0)	
		end
	}	
	--Berserk
	self.PlayerAura[GetSpellInfo(50334)] = { ActiveAura = "Berserk", ID = 50334, ModType =
		function( calculation, _, _, index )
			if not index and calculation.requiresForm == 3 then
				calculation.actionCost = calculation.actionCost * 0.5
			end
		end
	}
	--Moonkin Aura
	self.PlayerAura[GetSpellInfo(24907)] = { School = "Spells", ID = 24907, Category = "+5% crit", SkipCategory = true, ModType =
		function( calculation, ActiveAuras, Talents, index )
			if not index then
				if not ActiveAuras["+5% crit"] then
					calculation.critPerc = calculation.critPerc + 5
				end
				if Talents["Improved Moonkin Form"] and not UnitBuff("player", moonkin) then
					calculation.spellDmg = calculation.spellDmg + Talents["Improved Moonkin Form"] * (calculation.spirit or select(2,UnitStat("player",5)))
					calculation.haste = calculation.haste * (1 + 0.1 * Talents["Improved Moonkin Form"])
					if Talents["Furor"] and Talents["Lunar Guidance"] then
						calculation.spellDmg = calculation.spellDmg + Talents["Lunar Guidance"] * Talents["Furor"] * (calculation.int or select(2,UnitStat("player",4)))
					end
				end
			end
			ActiveAuras["+5% crit"] = true
		end
	}

	self.spellInfo = {
		[GetSpellInfo(5176)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Wrath",
					[0] = { School = "Nature", canCrit = true, castTime = 2, BaseIncrease = true, Downrank = 6 },
					[1] = { 17, 19, 1, 2, castTime = 1.5, spellLevel = 1, },
					[2] = { 32, 36, 3, 4, castTime = 1.7, spellLevel = 6, },
					[3] = { 49, 57, 4, 5, spellLevel = 14, },
					[4] = { 68, 78, 6, 6, spellLevel = 22, },
					[5] = { 130, 148, 7, 8, spellLevel = 30, },
					[6] = { 169, 191, 9, 10, spellLevel = 38, },
					[7] = { 215, 241, 10, 11, spellLevel = 46, },
					[8] = { 306, 344, 12, 13, spellLevel = 54, },
					[9] = { 397, 447, 14, 15, spellLevel = 61, },
					[10] = { 431, 485, 10, 11, spellLevel = 69, Downrank = 4 },
					[11] = { 504, 568, 12, 12, spellLevel = 74, Downrank = 4 },
					[12] = { 553, 623, 4, 4, spellLevel = 79, },
		},
		[GetSpellInfo(27012)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Hurricane",
					[0] = { School = "Nature", canCrit = true, castTime = 10, sHits = 10, SPBonus = 1.28962, Channeled = true, BaseIncrease = true, AoE = true, Downrank = 6 },
					[1] = { 100, 100, 1, 2, spellLevel = 40, },
					[2] = { 142, 142, 1, 2, spellLevel = 50, },
					[3] = { 190, 190, 1, 2, spellLevel = 60, },
					[4] = { 303, 303, 2, 3, spellLevel = 70, },
					[5] = { 451, 451, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(5570)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Insect Swarm",
					[0] = { School = "Nature", SPBonus = 1.2, eDot = true, eDuration = 12, sTicks = 2, Downrank = 9 },
					[1] = { 144, 144, spellLevel = 30 },
					[2] = { 234, 234, spellLevel = 30 },
					[3] = { 372, 372, spellLevel = 40 },
					[4] = { 540, 540, spellLevel = 50 },
					[5] = { 744, 744, spellLevel = 60 },
					[6] = { 1032, 1032, spellLevel = 70, Downrank = 8 },
					[7] = { 1290, 1290, spellLevel = 80 },
		},
		[GetSpellInfo(8921)] = {
					--TODO: Coefficient: 0.1515 or 0.15?
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Moonfire",
					[0] = { School = "Arcane", canCrit = true, SPBonus = 0.15, dotFactor = 0.52, eDuration = 12, sTicks = 3, BaseIncrease = true },
					[1] = { 7, 9, 2, 3, hybridDotDmg = 12, spellLevel = 4, },
					[2] = { 13, 17, 4, 4, hybridDotDmg = 32, spellLevel = 10, },
					[3] = { 25, 31, 5, 6, hybridDotDmg = 52, spellLevel = 16, },
					[4] = { 40, 48, 7, 7, hybridDotDmg = 80, spellLevel = 22, },
					[5] = { 61, 73, 9, 9, hybridDotDmg = 124, spellLevel = 28, },
					[6] = { 81, 97, 10, 11, hybridDotDmg = 164, spellLevel = 34, },
					[7] = { 105, 125, 12, 12, hybridDotDmg = 212, spellLevel = 40, },
					[8] = { 130, 154, 13, 14, hybridDotDmg = 264, spellLevel = 46, },
					[9] = { 157, 185, 15, 15, hybridDotDmg = 320, spellLevel = 52, },
					[10] = { 189, 221, 16, 17, hybridDotDmg = 384, spellLevel = 58, },
					[11] = { 220, 258, 18, 18, hybridDotDmg = 444, spellLevel = 63, },
					[12] = { 305, 357, 15, 16, hybridDotDmg = 600, spellLevel = 70, Downrank = 4 },
					[13] = { 347, 407, 20, 20, hybridDotDmg = 684, spellLevel = 75, },
					[14] = { 406, 476, 0, 0, hybridDotDmg = 800, spellLevel = 80, },
		},
		[GetSpellInfo(2912)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Starfire",
					[0] = { School = "Arcane", canCrit = true, castTime = 3.5, BaseIncrease = true, Downrank = 6 },
					[1] = { 121, 149, 6, 6, spellLevel = 20, },
					[2] = { 189, 231, 9, 10, spellLevel = 26, },
					[3] = { 272, 328, 11, 12, spellLevel = 34, },
					[4] = { 370, 442, 13, 14, spellLevel = 42, },
					[5] = { 485, 575, 16, 17, spellLevel = 50, },
					[6] = { 615, 725, 18, 18, spellLevel = 58, },
					[7] = { 693, 817, 18, 19, spellLevel = 60, },
					[8] = { 818, 964, 13, 14, spellLevel = 67, Downrank = 4 },
					[9] = { 854, 1006, 16, 16, spellLevel = 72, Downrank = 4 },
					[10] = { 1028, 1212, 10, 10, spellLevel = 78, },
		},
		[GetSpellInfo(339)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Entangling Roots",
					[0] = { School = "Nature", eDot = true, eDuration = 27, sFactor = 0.5, sTicks = 3, NoDownrank = true },
					[1] = { 20, 20, spellLevel = 8, eDuration = 12, },
					[2] = { 50, 50, spellLevel = 18, eDuration = 15, },
					[3] = { 90, 90, spellLevel = 28, eDuration = 18, },
					[4] = { 140, 140, spellLevel = 38, eDuration = 21, },
					[5] = { 200, 200, spellLevel = 48, eDuration = 24, },
					[6] = { 270, 270, spellLevel = 58, },
					[7] = { 351, 351, spellLevel = 68, },
					[8] = { 423, 423, spellLevel = 78, },
		},
		[GetSpellInfo(467)] = {
					["Name"] = "Thorns",
					[0] = { School = "Nature", SPBonus = 0.033, NoDPM = true, NoDoom = true, NoDPS = true, NoCasts = true, NoHaste = true, NoMPS = true, NoNextDPS = true, Unresistable = true, NoDownrank = true },
					[1] = { 3, 3 },
					[2] = { 6, 6 },
					[3] = { 9, 9 },
					[4] = { 12, 12 },
					[5] = { 15, 15 },
					[6] = { 18, 18 },
					[7] = { 25, 25 },
					[8] = { 73, 73 },
		},
		[GetSpellInfo(50516)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Typhoon",
					[0] = { School = "Nature", canCrit = true, SPBonus = 0.193, Cooldown = 20, AoE = true, BaseIncrease = true, Downrank = 9 },
					[1] = { 400, 400, 29, 29, spellLevel = 50, },
					[2] = { 550, 550, 28, 28, spellLevel = 60, },
					[3] = { 735, 735, 13, 13, spellLevel = 70, Downrank = 4 },
					[4] = { 1010, 1010, 13, 13, spellLevel = 75, Downrank = 4 },
					[5] = { 1190, 1190, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(48505)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Starfall",
					[0] = { School = "Arcane", canCrit = true, SPBonus = 0.37 * 10, ExtraSPBonus = 0.012, eDot = true, eDuration = 10, sHits = 10, ExtraAoE = true, NoPeriod = true },
					[1] = { 144, 167, extraAoe = 25.5, spellLevel = 60, Downrank = 9 },
					[2] = { 324, 377, extraAoe = 57.5, spellLevel = 70, Downrank = 4 },
					[3] = { 474, 551, extraAoe = 84.5, spellLevel = 75, Downrank = 4 },
					[4] = { 562, 653, extraAoe = 100.5, spellLevel = 80, },
		},
		[GetSpellInfo(5185)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Healing Touch",
					[0] = { School = { "Nature", "Healing", }, canCrit = true, castTime = 3.0, BaseIncrease = true, Downrank = 5 },
					[1] = { 37, 51, 3, 4, castTime = 1.5, spellLevel = 1, },
					[2] = { 88, 112, 6, 7, castTime = 2, spellLevel = 8, },
					[3] = { 195, 243, 9, 10, castTime = 2.5, spellLevel = 14, },
					[4] = { 363, 445, 13, 14, spellLevel = 20, },
					[5] = { 490, 594, 15, 15, spellLevel = 26, },
					[6] = { 636, 766, 17, 17, spellLevel = 32, },
					[7] = { 802, 960, 19, 20, spellLevel = 38, },
					[8] = { 1199, 1427, 22, 23, spellLevel = 44, },
					[9] = { 1299, 1539, 25, 26, spellLevel = 50, },
					[10] = { 1620, 1912, 28, 29, spellLevel = 56, },
					[11] = { 1944, 2294, 31, 31, spellLevel = 60, },
					[12] = { 2026, 2392, 31, 32, spellLevel = 62, },
					[13] = { 2321, 2739, 28, 28, spellLevel = 69, },
					[14] = { 3223, 3805, 39, 40, spellLevel = 74, },
					[15] = { 3750, 4428, 11, 12, spellLevel = 79, },
		},
		[GetSpellInfo(774)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Rejuvenation",
					[0] = { School = { "Nature", "Healing", }, eDot = true, eDuration = 15, sTicks = 3, Downrank = 5 },
					[1] = { 40, 40, spellLevel = 4, },
					[2] = { 70, 70, spellLevel = 10, },
					[3] = { 145, 145, spellLevel = 16, },
					[4] = { 225, 225, spellLevel = 22, },
					[5] = { 305, 305, spellLevel = 28, },
					[6] = { 380, 380, spellLevel = 34, },
					[7] = { 485, 485, spellLevel = 40, },
					[8] = { 610, 610, spellLevel = 46, },
					[9] = { 760, 760, spellLevel = 52, },
					[10] = { 945, 945, spellLevel = 58, },
					[11] = { 1110, 1110, spellLevel = 60, },
					[12] = { 1165, 1165, spellLevel = 63, },
					[13] = { 1325, 1325, spellLevel = 69, Downrank = 4 },
					[14] = { 1490, 1490, spellLevel = 75, },
					[15] = { 1690, 1690, spellLevel = 80, },
		},
		[GetSpellInfo(8936)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Regrowth",
					[0] = { School = { "Nature", "Healing", }, canCrit = true, castTime = 2, SPBonus = 0.538996, dotFactor = 1.316, eDuration = 21, sTicks = 3, BaseIncrease = true },
					[1] = { 84, 98, 9, 9, hybridDotDmg = 98, spellLevel = 12, },
					[2] = { 164, 188, 12, 13, hybridDotDmg = 175, spellLevel = 18, },
					[3] = { 240, 274, 15, 16, hybridDotDmg = 259, spellLevel = 24, },
					[4] = { 318, 360, 18, 18, hybridDotDmg = 343, spellLevel = 30, },
					[5] = { 405, 457, 20, 21, hybridDotDmg = 427, spellLevel = 36, },
					[6] = { 511, 575, 23, 24, hybridDotDmg = 546, spellLevel = 42, },
					[7] = { 646, 724, 26, 27, hybridDotDmg = 686, spellLevel = 48, },
					[8] = { 809, 905, 30, 30, hybridDotDmg = 861, spellLevel = 54, },
					[9] = { 1003, 1119, 34, 34, hybridDotDmg = 1064, spellLevel = 60, },
					[10] = { 1215, 1355, 38, 39, hybridDotDmg = 1274, spellLevel = 65, },
					[11] = { 1710, 1908, 54, 54, hybridDotDmg = 1792, spellLevel = 71, },
					[12] = { 2234, 2494, 23, 24, hybridDotDmg = 2345, spellLevel = 77, },
		},
		[GetSpellInfo(740)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Tranquility",
					[0] = { School = { "Nature", "Healing", }, SPBonus = 2.152, castTime = 8, sHits = 4, Channeled = true, BaseIncrease = true, Downrank = 6, Cooldown = 480, AoE = true },
					[1] = { 351, 351, 13, 13, spellLevel = 30, },
					[2] = { 515, 515, 15, 15, spellLevel = 40, },
					[3] = { 765, 765, 20, 20, spellLevel = 50, },
					[4] = { 1097, 1097, 22, 22, spellLevel = 60, },
					[5] = { 1518, 1518, 18, 18, spellLevel = 70, Downrank = 4 },
					[6] = { 2598, 2598, 30, 30, spellLevel = 75, Downrank = 4 },
					[7] = { 3035, 3035, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(33763)] = {
					--NOTE: Only HoT part downranks
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK
					["Name"] = "Lifebloom",
					[0] = { School = { "Nature", "Healing" }, canCrit = true, eDuration = 7, sTicks = 1, SPBonus = 0.51623296, dotFactor = 0.66626, DotStacks = 3, Downrank = 7, HybridDownrank = true },
					[1] = { 480, 480, hybridDotDmg = 224, spellLevel = 64, },
					[2] = { 616, 616, hybridDotDmg = 287, spellLevel = 72, },
					[3] = { 776, 776, hybridDotDmg = 371, spellLevel = 80, },
		},
		[GetSpellInfo(48438)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					--TODO: Implement tick calculation differently?
					["Name"] = "Wild Growth",
					[0] = { School = { "Nature", "Healing" }, SPBonus = 1.5/3.5 * 1.88, eDot = true, eDuration = 7, sTicks = 1, Downrank = 4 },
					[1] = { 686, 686, spellLevel = 60, Downrank = 9 },
					[2] = { 861, 861, spellLevel = 70, },
					[3] = { 1239, 1239, spellLevel = 75, },
					[4] = { 1442, 1442, spellLevel = 80, },
		},
		[GetSpellInfo(50464)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Nourish",
					[0] = { School = { "Nature", "Healing" }, SPBonus = 0.6730494, canCrit = true, castTime = 1.5, },
					[1] = { 1883, 2187, spellLevel = 80, },
		},
		[GetSpellInfo(18562)] = {
					--BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Swiftmend",
					[0] = { School = { "Nature", "Healing" }, SPBonus = 0, canCrit = true, Cooldown = 15, NoDownrank = true },
					[1] = { 0, 0, spellLevel = 80, },
		},
		--Feral
		[GetSpellInfo(6807)] = {
					["Name"] = "Maul",
					[0] = { Melee = true, WeaponDamage = 1, requiresForm = 1, NextMelee = true, Bleed = true, Armor = true },
					[1] = { 18 },
					[2] = { 27 },
					[3] = { 37 },
					[4] = { 64 },
					[5] = { 103 },
					[6] = { 145 },
					[7] = { 192 },
					[8] = { 290 },
					[9] = { 472 },
					[10] = { 578 },
		},
		[GetSpellInfo(779)] = {
					["Name"] = "Swipe (Bear)",
					[0] = { Melee = true, requiresForm = 1, APBonus = 0.063, AoE = true },
					[1] = { 9 },
					[2] = { 13 },
					[3] = { 19 },
					[4] = { 37 },
					[5] = { 54 },
					[6] = { 76 },
					[7] = { 95 },
					[8] = { 108 },
		},
		[GetSpellInfo(62078)] = {
					["Name"] = "Swipe (Cat)",
					[0] = { Melee = true, WeaponDamage = 2.5, requiresForm = 3, AoE = true },
					[1] = { 0 },
		},
		[GetSpellInfo(1082)] = {
					["Name"] = "Claw",
					[0] = { Melee = true, WeaponDamage = 1, requiresForm = 3 },
					[1] = { 27 },
					[2] = { 39 },
					[3] = { 57 },
					[4] = { 88 },
					[5] = { 115 },
					[6] = { 190 },
					[7] = { 300 },
					[8] = { 370 },
		},
		[GetSpellInfo(1079)] = {
					["Name"] = "Rip",
					[0] = { Melee = true, NoCrits = true, ComboPoints = true, requiresForm = 3, eDuration = 12, Ticks = 2, APBonus = { 0.06, 0.12, 0.18, 0.24, 0.3 }, Bleed = true },
					[1] = { 42, PerCombo = 24 },
					[2] = { 66, PerCombo = 42 },
					[3] = { 90, PerCombo = 54 },
					[4] = { 138, PerCombo = 84, },
					[5] = { 192, PerCombo = 120, },
					[6] = { 270, PerCombo = 168, },
					[7] = { 426, PerCombo = 282, },
					[8] = { 582, PerCombo = 402, },
					[9] = { 774, PerCombo = 558, },
		},
		[GetSpellInfo(5221)] = {
					["Name"] = "Shred",
					[0] = { Melee = true, WeaponDamage = 2.25, requiresForm = 3, Bleed = true, Armor = true },
					[1] = { 54 },
					[2] = { 72 },
					[3] = { 99 },
					[4] = { 144 },
					[5] = { 180 },
					[6] = { 236 },
					[7] = { 405 },
					[8] = { 564.75 },
					[9] = { 666 },
		},
		[GetSpellInfo(1822)] = {
					["Name"] = "Rake",
					[0] = { Melee = true, APBonus = 0.01, ExtraDamage = 0.18, E_eDuration = 9, E_Ticks = 3, requiresForm = 3, Bleed = true, BleedExtra = true },
					[1] = { 17, Extra = 90 },
					[2] = { 26, Extra = 135 },
					[3] = { 46, Extra = 207 },
					[4] = { 64, Extra = 297 },
					[5] = { 90, Extra = 414 },
					[6] = { 139, Extra = 891 },
					[7] = { 176, Extra = 1074 },
		},
		[GetSpellInfo(22568)] = {
					["Name"] = "Ferocious Bite",
					[0] = { Melee = true, ComboPoints = true, APBonus = 0.07, PowerBonusAP = 1/410, requiresForm = 3 },
					[1] = { 50, 66, PerCombo = 36, PowerBonus = 0.7 },
					[2] = { 79, 103, PerCombo = 59, PowerBonus = 1.1 },
					[3] = { 122, 162, PerCombo = 92, PowerBonus = 1.5 },
					[4] = { 173, 223, PerCombo = 128, PowerBonus = 2 },
					[5] = { 199, 259, PerCombo = 147, PowerBonus = 2.1 },
					[6] = { 226, 292, PerCombo = 169, PowerBonus = 3.4 },
					[7] = { 334, 446, PerCombo = 236, PowerBonus = 7.7 },
					[8] = { 410, 550, PerCombo = 290, PowerBonus = 9.4 },
		},
		[GetSpellInfo(6785)] = {
					["Name"] = "Ravage",
					[0] = { Melee = true, WeaponDamage = 3.85, requiresForm = 3 },
					[1] = { 161.7 },
					[2] = { 238.7 },
					[3] = { 300.3 },
					[4] = { 377.3 },
					[5] = { 565.95 },
					[6] = { 1405.25 },
					[7] = { 1771 },
		},
		[GetSpellInfo(9005)] = {
					["Name"] = "Pounce",
					[0] = { Melee = true, NoCrits = true, APBonus = 0.18, requiresForm = 3, eDuration = 18, Ticks = 3, Bleed = true },
					[1] = { 270 },
					[2] = { 330 },
					[3] = { 450 },
					[4] = { 600 },
					[5] = { 2100 },
		},
		[GetSpellInfo(33878)] = {
					["Name"] = "Mangle (Bear)",
					[0] = { Melee = true, WeaponDamage = 1.15, requiresForm = 1, Cooldown = 6 },
					[1] = { 86.25 },
					[2] = { 120.75 },
					[3] = { 155.25 },
					[4] = { 251.85 },
					[5] = { 299 },
		},
		[GetSpellInfo(33876)] = {
					["Name"] = "Mangle (Cat)",
					[0] = { Melee = true, WeaponDamage = 2.00, requiresForm = 3, },
					[1] = { 198 },
					[2] = { 256 },
					[3] = { 330 },
					[4] = { 478 },
					[5] = { 566 },
		},
		[GetSpellInfo(22570)] = {
					["Name"] = "Maim",
					[0] = { Melee = true, WeaponDamage = 1, ComboPoints = true, requiresForm = 3, Cooldown = 10 },
					[1] = { 129, 129, PerCombo = 84 },
					[2] = { 224, 224, PerCombo = 158 },
		},
		[GetSpellInfo(33745)] = {
					["Name"] = "Lacerate",
					[0] = { Melee = true, APBonus = 0.01, ExtraDamage = 0.05, E_eDuration = 15, E_Ticks = 3, BleedExtra = true, requiresForm = 1 },
					[1] = { 31, Extra = 155 },
					[2] = { 70, Extra = 255 },
					[3] = { 88, Extra = 320 },
		},
		[GetSpellInfo(16857)] = {
					["Name"] = "Faerie Fire (Feral)",
					[0] = { Melee = true, SpellCrit = "Nature", SpellHit = true, APBonus = 0.15, requiresForm = 1 },
					[1] = { 1 },
		},
		[GetSpellInfo(33831)] = {
					["Name"] = "Force of Nature",
					[0] = { Melee = true, eDuration = 30, Cooldown = 180, Armor = true, Avoidable = true, NoGlobalMod = true, NoParry = true, Glancing = true, MeleeHaste = true, CustomHaste = true, BaseHaste = 1, NoNext = true, NoManualRatings = true },
					[1] = { 454, 669 },
		},
	}
	self.talentInfo = {
	--BALANCE:
		--Genesis (additive - 3.3.3)
		[GetSpellInfo(57810)] = {	[1] = { Effect = 0.01, Caster = true, Spells = { "Rejuvenation", "Insect Swarm", "Wild Growth", "Tranquility", "Hurricane", "Swiftmend" } },
									[2] = { Effect = 0.01, Caster = true, Spells = { "Lifebloom", "Moonfire", "Regrowth" }, ModType = "dmgM_dot_Add" }, },
		--Nature's Majesty
		[GetSpellInfo(35363)] = { 	[1] = { Effect = 2, Caster = true, Spells = { "Wrath", "Starfire", "Starfall", "Nourish", "Healing Touch" }, ModType = "critPerc", }, },
		--Improved Moonfire (additive - 3.3.3)
		[GetSpellInfo(16821)] = { 	[1] = { Effect = 5, Caster = true, Spells = "Moonfire", ModType = "critPerc", },
									[2] = { Effect = 0.05, Caster = true, Spells = "Moonfire", }, },
		--Brambles (additive/multiplicative - doesn't matter currently)
		[GetSpellInfo(16836)] = {	[1] = { Effect = 0.25, Caster = true, Spells = { "Entangling Roots", "Thorns" }, },
									[2] = { Effect = 0.05, Melee = true, Spells = "Force of Nature" }, },
		--Nature's Splendor
		[GetSpellInfo(57865)] = {	[1] = { Effect = 3, Caster = true, Spells = { "Moonfire", "Rejuvenation" }, ModType = "eDuration" },
									[2] = { Effect = 6, Caster = true, Spells = "Regrowth", ModType = "eDuration" },
									[3] = { Effect = 2, Caster = true, Spells = { "Insect Swarm", "Lifebloom" }, ModType = "eDuration" }, },
		--Vengeance (additive)
		[GetSpellInfo(16909)] = { 	[1] = { Effect = 0.1, Caster = true, Spells = { "Starfire", "Starfall", "Moonfire", "Wrath" }, ModType = "critM", }, },
		--Lunar Guidance
		[GetSpellInfo(33589)] = { 	[1] = { Effect = 0.04, Caster = true, Spells = "All", ModType = "Lunar Guidance" },
									[2] = { Effect = 0.04, Melee = true, Spells = "Force of Nature", ModType = "Lunar Guidance" }, NoManual = true },
		--Improved Insect Swarm (multiplicative - 3.3.3)
		[GetSpellInfo(57849)] = {	[1] = { Effect = 1, Caster = true, Spells = { "Starfire", "Wrath" }, ModType = "Improved Insect Swarm", }, },
		--Moonfury (additive - 3.3.3)
		[GetSpellInfo(16896)] = { 	[1] = { Effect = { 0.03, 0.06, 0.1 }, Caster = true, Spells = { "Starfire", "Moonfire", "Wrath" }, }, },
		--Balance of Power
		[GetSpellInfo(33592)] = { 	[1] = { Effect = 2, Caster = true, Spells = "All", ModType = "hitPerc" }, },
		--Improved Moonkin Form
		[GetSpellInfo(48384)] = { 	[1] = { Effect = 0.1, Caster = true, Spells = "All", ModType = "Improved Moonkin Form" },
									[2] = { Effect = 0.1, Melee = true, Spells = "Force of Nature", ModType = "Improved Moonkin Form" }, NoManual = true },
		--Improved Faerie Fire
		[GetSpellInfo(33600)] = { 	[1] = { Effect = 1, Caster = true, Spells = "All", ModType = "Improved Faerie Fire" }, },
		--Wrath of Cenarius (additive)
		[GetSpellInfo(33603)] = { 	[1] = { Effect = 0.04, Caster = true, Spells = "Starfire", ModType = "SpellDamage" },
									[2] = { Effect = 0.02, Caster = true, Spells = "Wrath", ModType = "SpellDamage"}, },
		--Gale Winds
		[GetSpellInfo(48488)] = {	[1] = { Effect = 0.15, Caster = true, Spells = { "Hurricane", "Typhoon" }, }, },
		--Earth and Moon (multiplicative - 3.3.3)
		[GetSpellInfo(48506)] = {	[1] = { Effect = 0.02, Caster = true, Spells = { "Moonfire", "Starfire", "Wrath", "Starfall", "Hurricane", "Typhoon", "Entangling Roots", "Insect Swarm", "Thorns" }, Multiply = true },
									[2] = { Effect = 0.02, Caster = true, Spells = "Starfire", ModType = "Earth And Moon" }, },
	--RESTORATION:
		--Furor
		[GetSpellInfo(17056)] = { 	[1] = { Effect = 0.02, Caster = true, Spells = "All", ModType = "Furor" }, NoManual = true },
		--Naturalist
		[GetSpellInfo(17069)] = { 	[1] = { Effect = 0.02, Spells = "All",  ModType = "Naturalist" }, NoManual = true },
		--Master Shapeshifter
		[GetSpellInfo(48411)] = {	[1] = { Effect = 0.02, Spells = "All", ModType = "Master Shapeshifter", }, NoManual = true },
		--Improved Rejuvenation (additive - 3.3.3)
		[GetSpellInfo(17111)] = { 	[1] = { Effect = 0.05, Caster = true, Spells = "Rejuvenation" },
									[2] = { Effect = 0.05, Caster = true, Spells = "Swiftmend", ModType = "Improved Rejuvenation" }, },
		--Gift of Nature (additive - 3.3.3)
		[GetSpellInfo(17104)] = { 	[1] = { Effect = 0.02, Caster = true, Spells = "Healing" }, },
		--Empowered Touch (additive - 3.3.3)
		[GetSpellInfo(33879)] = { 	[1] = { Effect = 0.2, Caster = true, Spells = "Healing Touch", ModType = "SpellDamage" },
									[2] = { Effect = 0.1, Caster = true, Spells = "Nourish", ModType = "SpellDamage" }, },
		--Nature's Bounty
		[GetSpellInfo(17074)] = { 	[1] = { Effect = 5, Caster = true, Spells = { "Regrowth", "Nourish" }, ModType = "critPerc" }, },
		--Empowered Rejuvenation (multiplicative - 3.3.3)
		[GetSpellInfo(33886)] = { 	[1] = { Effect = 0.04, Caster = true, Spells = { "Rejuvenation", "Regrowth", "Lifebloom", "Wild Growth", "Tranquility" }, ModType = "SpellDamage", Multiply = true, },
									[2] = { Effect = 0.04, Caster = true, Spells = { "Regrowth", "Lifebloom", }, ModType = "spellDmgM_dot", Multiply = true, },
									[3] = { Effect = 0.04, Caster = true, Spells = "Swiftmend", ModType = "Empowered Rejuvenation" }, },
		--Gift of the Earthmother
		[GetSpellInfo(51183)] = { 	[1] = { Effect = -0.03, Caster = true, Spells = "Lifebloom", ModType = "castTime" }, },
	--FERAL:
		--Feral Aggression (additive?)
		[GetSpellInfo(16858)] = { 	[1] = { Effect = 0.03, Melee = true, Spells = "Ferocious Bite", }, },
		--Feral Instinct (additive?)
		[GetSpellInfo(16947)] = {	[1] = { Effect = 0.1, Melee = true, Spells = { "Swipe (Bear)", "Swipe (Cat)" }, }, },
		--Savage Fury (additive?)
		[GetSpellInfo(16998)] = { 	[1] = { Effect = 0.1, Melee = true, Spells = { "Claw", "Rake", "Mangle (Cat)", "Mangle (Bear)", "Maul" }, }, },
		--Predatory Instincts
		[GetSpellInfo(33859)] = { 	[1] = { Effect = { 0.06, 0.14, 0.2 }, Melee = true, Spells = { "Swipe (Cat)", "Claw", "Rip", "Shred", "Rake", "Ferocious Bite", "Ravage", "Pounce", "Mangle (Cat)", "Maim"}, ModType = "critM" },
									[2] = { Effect = { 0.06, 0.14, 0.2 }, Melee = true, Spells = "Attack", ModType = "Predatory Instincts" }, },
		--Nurturing Instinct
		[GetSpellInfo(33872)] = { 	[1] = { Effect = 0.1, Caster = true, Spells = "Lifeblood", ModType = "Lifeblood Bonus" }, },
		--Improved Mangle
		[GetSpellInfo(48532)] = { 	[1] = { Effect = -0.5, Melee = true, Spells = "Mangle (Bear)", ModType = "cooldown" }, },
		--Rend and Tear (multiplicative - 3.3.3)
		[GetSpellInfo(48432)] = {	[1] = { Effect = 1, Melee = true, Spells = { "Maul", "Shred", "Ferocious Bite" }, ModType = "Rend and Tear", }, },
		--Primal Gore
		[GetSpellInfo(63503)] = {	[1] = { Effect = 1, Melee = true, Spells = "Lacerate", ModType = "Primal Gore (Lacerate)", },
									[2] = { Effect = 1, Melee = true, Spells = "Rip", ModType = "Primal Gore (Rip)" }, },
	}
end