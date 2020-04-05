if select(2, UnitClass("player")) ~= "PRIEST" then return end
local GetSpellInfo = GetSpellInfo
local UnitExists = UnitExists
local UnitIsFriend = UnitIsFriend
local UnitIsUnit = UnitIsUnit
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitPowerMax = UnitPowerMax
local math_min = math.min

function DrDamage:PlayerData()
	--Health Updates
	self.TargetHealth = { [1] = 0.501, [2] = 0.351, [0.351] = GetSpellInfo(32379) }
	--Shadowfiend
	self.ClassSpecials[GetSpellInfo(34433)] = function()
		return 0.5 * UnitPowerMax("player",0), false, true
	end
	--Dispersion
	self.ClassSpecials[GetSpellInfo(47585)] = function()
		return 0.36 * UnitPowerMax("player",0), false, true
	end
	--Dispel Magic
	self.ClassSpecials[GetSpellInfo(527)] = function()
		if self:HasGlyph(55677) then
			local heal
			if UnitExists("target") and UnitIsFriend("target","player") then
				heal = 0.03 * UnitHealthMax("target")
			else
				heal = 0.03 * UnitHealthMax("player")
			end
			return heal, true
		end
	end	
--GENERAL
	self.Calculation["PRIEST"] = function ( calculation, ActiveAuras, Talents )
		if ActiveAuras["Shadowform"] then
			--Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * 1.15
		end
	end
--TALENTS
	local daicon = "|T" .. select(3,GetSpellInfo(47515)) .. ":16:16:1:-1|t"
	self.Calculation["Divine Aegis"] = function( calculation, value )
		if calculation.canCrit then
			calculation.extraCrit = value * ((self:GetSetAmount( "Tier 9 - Healing" ) >= 4) and 1.1 or 1) / (calculation.sHits or 1)
			calculation.extraChanceCrit = true
			calculation.extraName = daicon
		end
	end
	self.Calculation["Improved Flash Heal"] = function( calculation, value )
		local target = calculation.target
		if target and UnitHealth(target) ~= 0 and (UnitHealth(target) / UnitHealthMax(target)) <= 0.5 then
			calculation.critPerc = calculation.critPerc + value
		end
	end
	self.Calculation["Test of Faith"] = function( calculation, value )
		local target = calculation.target
		if target and UnitHealth(target) ~= 0 and (UnitHealth(target) / UnitHealthMax(target)) <= 0.5 then
			calculation.dmgM = calculation.dmgM * (1 + value)
		end
	end
--ABILITIES
	self.Calculation["Mind Blast"] = function ( calculation, ActiveAuras, Talents )
		if ActiveAuras["Shadow Word: Pain"] and Talents["Twisted Faith"] then
			--Multiplicative - 3.3.3
 			calculation.dmgM = calculation.dmgM * (1 + Talents["Twisted Faith"])
		end
	end
	self.Calculation["Mind Flay"] = function ( calculation, ActiveAuras, Talents )
		--This is to cancel out using 3 spell hits, so we can use the Blizzard tooltip values instead of dividing with 3
		calculation.bDmgM = (1/3)
		if ActiveAuras["Shadow Word: Pain"] then
			if Talents["Twisted Faith"] then --(multiplicative - 3.3.3)
 				calculation.dmgM = calculation.dmgM * (1 + Talents["Twisted Faith"])
 			end
 			--Glyph of Mind Flay
			--BUG: 3.3.3
			--Stacks additively with Twisted Faith but multiplicatively with Darkness
 			if self:HasGlyph(55687) then
 				calculation.dmgM_Add = calculation.dmgM_Add + 0.1 - 0.1 * (Talents["Twisted Faith"] or 0) + 0.1 * (Talents["Darkness"] or 0)
 			end
		end
		if self:GetSetAmount( "Tier 9 - Damage" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
		if self:GetSetAmount( "Tier 10 - Damage" ) >= 4 then
			calculation.castTime = 2.49
		end
	end
	self.Calculation["Shadow Word: Pain"] = function ( calculation, ActiveAuras )
		if ActiveAuras["Shadowform"] then
			calculation.canCrit = true
			calculation.critM = calculation.critM + 0.5
		end
		if self:GetSetAmount( "Tier 10 - Damage" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Vampiric Touch"] = function ( calculation, ActiveAuras )
		if ActiveAuras["Shadowform"] then
			calculation.canCrit = true
			calculation.critM = calculation.critM + 0.5
			calculation.customHaste = true
		end
		if self:GetSetAmount( "Tier 9 - Damage" ) >= 2 then
			calculation.eDuration = calculation.eDuration + 6
		end
		if self:GetSetAmount( "Tier 10 - Damage" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Devouring Plague"] = function ( calculation, ActiveAuras, Talents )
		if ActiveAuras["Shadowform"] then
			calculation.canCrit = true
			calculation.critM = calculation.critM + 0.5
			calculation.customHaste = true
		end
		if Talents["Improved Devouring Plague"] then
			calculation.dmgM_dd = Talents["Improved Devouring Plague"]
			calculation.hybridDotDmg = (calculation.minDam + calculation.maxDam) / 2
			calculation.spellDmgM_dot = calculation.spellDmgM
			calculation.canCrit = true
		end
		if self:GetSetAmount( "Tier 8 - Damage" ) >= 2 then
			calculation.dmgM_custom = true
			local dmgM = calculation.dmgM_dot * calculation.dmgM * (1 + calculation.dmgM_Add + calculation.dmgM_dot_Add)
			calculation.dmgM_dot_Add = calculation.dmgM_dot_Add + 0.15
			calculation.dmgM_dot = calculation.dmgM_dot * calculation.dmgM * (1 + calculation.dmgM_Add + calculation.dmgM_dot_Add)
			calculation.dmgM = dmgM
		end
		if self:GetSetAmount( "Tier 10 - Damage" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Renew"] = function ( calculation, _, Talents )
		if Talents["Empowered Renew"] then
			calculation.dmgM_dd = Talents["Empowered Renew"]
			--Multiplicative - 3.3.3
			if self:GetSetAmount( "Tier 9 - Healing" ) >= 4 then
				calculation.dmgM_dd = calculation.dmgM_dd * 1.1
			end
			calculation.hybridDotDmg = ((calculation.minDam + calculation.maxDam) / 2)
			calculation.spellDmgM_dot = calculation.spellDmgM
			calculation.canCrit = true
		end
		--Glyph of Renew
		if self:HasGlyph(55674) then
			calculation.eDuration = calculation.eDuration - 3
			--BUG: Talent effect are reduced? (Spiritual Healing, Twin Disciplines, Improved Renew. NOT Focused Power, Blessed Resilience)
			if Talents["Empowered Renew"] then
				calculation.dmgM_custom = true
				calculation.dmgM_dot = calculation.dmgM_dot * calculation.dmgM * (1 + (4/5) * (calculation.dmgM_Add + calculation.dmgM_dot_Add))
				calculation.dmgM = calculation.dmgM * (1 + calculation.dmgM_Add + calculation.dmgM_dd_Add) 			
			else
				calculation.dmgM_Add = calculation.dmgM_Add * (4/5)
			end		
		end		
	end
	self.Calculation["Holy Nova"] = function( calculation )
		--Glyph of Holy Nova (additive - 3.3.3)
		if self:HasGlyph(55683) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Lightwell"] = function( calculation )
		--Glyph of Lightwell (TODO: A/M?)
		if self:HasGlyph(55673) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Shadow Word: Death"] = function( calculation )
		--Glyph of Shadow Word: Death (multiplicative - 3.3.3)
		if self:HasGlyph(55682) then
			if UnitHealth("target") ~= 0 and (UnitHealth("target") / UnitHealthMax("target")) <= 0.35 then
				calculation.dmgM = calculation.dmgM * 1.1
			end
		end
		if self:GetSetAmount( "Tier 7 - Damage" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 10
		end
	end
	self.Calculation["Smite"] = function( calculation, ActiveAuras )
		--Glyph of Smite (multiplicative - 3.3.3)
		if self:HasGlyph(55692) and ActiveAuras["Holy Fire"] then
 			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Prayer of Healing"] = function( calculation )
		--Glyph of Prayer of Healing
		if self:HasGlyph(55680) then
			calculation.hybridDotDmg = 0.2 * 0.5 * (calculation.minDam + calculation.maxDam)
			calculation.spellDmgM_dot = 0.2 * calculation.spellDmgM
			calculation.eDuration = 6
			calculation.sTicks = 3
		end
		if self:GetSetAmount( "Tier 8 - Healing" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 10
		end
	end
	local glyph = GetSpellInfo(52817)
	local glyphicon = "|TInterface\\Icons\\INV_Glyph_MajorPriest:16:16:1:-1|t"
	self.Calculation["Power Word: Shield"] = function( calculation, _, Talents )
		--TODO: 4T10 A/M?
		--PW: Shield - (1 + 0.05 * IPWS) * (1 + 0.02 * SpiritualHealing + 0.01 * Twin Disciplines + 0.02 * Focused Power). NOTE: Blessed Resilience doesn't apply.
		local pwsMod = self.healingMod * (calculation.dmgM_absorb or 1) * (1 + (Talents["Improved Power Word: Shield"] or 0)) * (1 + (Talents["Spiritual Healing"] or 0) + (Talents["Twin Disciplines"] or 0) + (Talents["Focused Power"] or 0) + (self:GetSetAmount( "Tier 10 - Healing" ) >= 4 and 0.05 or 0))
		local auraMod = calculation.dmgM
		calculation.dmgM_custom = true
		calculation.dmgM = pwsMod
		--Glyph of Power Word: Shield -- (1 + 0.05 * IPWS + 0.01 * Twin Disciplines) * (1 + 0.01 * Blessed Resilience) * (1 + 0.02 * Focused Power). NOTE: Spiritual Healing doesn't apply.
		if self:HasGlyph(55672) then
			--TODO: 4T10 A/M?
			local glyphMod = (1 + (Talents["Improved Power Word: Shield"] or 0) + (Talents["Twin Disciplines"] or 0) + (self:GetSetAmount( "Tier 10 - Healing" ) >= 4 and 0.05 or 0)) * (1 + (Talents["Blessed Resilience"] or 0)) * (1 + (Talents["Focused Power"] or 0))
			calculation.extraCrit = (0.2 / pwsMod) * auraMod * glyphMod
			calculation.extraCanCrit = true
			calculation.extraName = glyph
			if Talents["Divine Aegis Bonus"] then
				calculation.extraName = glyphicon .. "+" .. daicon
				calculation.extraCritEffect = Talents["Divine Aegis Bonus"] * ((self:GetSetAmount( "Tier 9 - Healing" ) >= 4) and 1.1 or 1)
			end
		end
	end
	self.Calculation["Circle of Healing"] = function( calculation )
		--Glyph of Circle of Healing
		if self:HasGlyph(55675) then
			calculation.aoe = calculation.aoe + 1
		end
		--TODO: Additive/multiplicative?
		if self:GetSetAmount( "Tier 10 - Healing" ) >= 4 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end		
	end
	self.Calculation["Divine Hymn"] = function( calculation )
		calculation.dmgM = calculation.dmgM * 1.1
		if calculation.targets > 1 then
			calculation.sHits = calculation.sHits * math_min(3, calculation.targets)
		end
	end
	self.Calculation["Prayer of Mending"] = function( calculation )
		if self:GetSetAmount( "Tier 7 - Healing" ) >= 2 then
			calculation.sHits = calculation.sHits + 1
		end
		--Multiplicative - 3.3.3
		if self:GetSetAmount( "Tier 9 - Healing" ) >= 2 then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Flash Heal"] = function( calculation )
		if self:GetSetAmount( "Tier 10 - Healing" ) >= 2 then
			--TODO: Support DA + set bonus?
			if calculation.extraCrit then
				calculation.extraCrit = nil
				calculation.extraChanceCrit = nil
			end
			calculation.extraAvg = (1/3)
			calculation.extraChance = (1/3)
			calculation.extraTicks = 3
			calculation.extraName = "2T10"
		end
	end
--SETS
	self.SetBonuses["Tier 7 - Damage"] = { 40454, 40456, 40457, 40458, 40459, 39521, 39523, 39528, 39529, 39530 }
	self.SetBonuses["Tier 7 - Healing"] = { 40445, 40447, 40448, 40449, 40450, 39514, 39515, 39517, 39518, 39519  }
	self.SetBonuses["Tier 8 - Damage"] = { 46163, 46165, 46168, 46170, 46172, 45391, 45392, 45393, 45394, 45395 }
	self.SetBonuses["Tier 8 - Healing"] = { 46188, 46190, 46193, 46195, 46197, 45386, 45387, 45388, 45389, 45390 }
	self.SetBonuses["Tier 9 - Damage"] = { 48072, 48073, 48074, 48075, 48076, 48097, 48098, 48099, 48100, 48101, 48078, 48077, 48081, 48079, 48080, 48085, 48086, 48082, 48084, 48083, 48095, 48096, 48092, 48094, 48093, 48088, 48087, 48091, 48089, 48090 }
	self.SetBonuses["Tier 9 - Healing"] = { 47914, 47936, 47980, 47981, 47982, 48067, 48068, 48069, 48070, 48071, 48065, 48066, 48064, 48063, 48062, 48058, 48057, 48059, 48060, 48061, 47984, 47983, 47985, 47986, 47987, 48035, 48037, 48033, 48031, 48029 }
	self.SetBonuses["Tier 10 - Damage"] = { 50392, 50391, 50396, 50393, 50394, 51255, 51184, 51256, 51183, 51257, 51182, 51258, 51181, 51259, 51180 }
	self.SetBonuses["Tier 10 - Healing"] = { 50766, 50765, 50769, 50768, 50767, 51260, 51179, 51261, 51178, 51262, 51177, 51263, 51176, 51264, 51175 }
--AURA
--Player
	--Shadowform
	self.PlayerAura[GetSpellInfo(15473)] = { School = "Shadow", ActiveAura = "Shadowform", ID = 15473 }
	--Shadow Weaving
	self.PlayerAura[GetSpellInfo(15258)] =  { School = "Shadow", Value = 0.02, Apps = 5, ID = 15258 }
	--Borrowed time
	self.PlayerAura[GetSpellInfo(59891)] = { Update = true }	
	--Surge of Light
	self.PlayerAura[GetSpellInfo(33151)] = { Update = true }
	--Serendipity
	self.PlayerAura[GetSpellInfo(63730)] = { Spells = { 2060, 596 }, Update = true }
	--Inner Focus
	self.PlayerAura[GetSpellInfo(14751)] =  { School = "All", Value = 25, ModType = "critPerc", ID = 14751, NoManual = true }
--Target
	--Grace
	self.TargetAura[GetSpellInfo(47516)] =  { School = "Healing", Value = 0.03, Apps = 3, SelfCastBuff = true, ID = 47516 }
	--Shadow Word: Pain
	self.TargetAura[GetSpellInfo(589)] = { ActiveAura = "Shadow Word: Pain", Spells = { 8092, 15407 }, ID = 589 }
	--Holy Fire
	self.TargetAura[GetSpellInfo(14914)] = { Spells = 585, ActiveAura = "Holy Fire", ID = 14914 }
	--Divine Hymn
	self.TargetAura[GetSpellInfo(64844)] =  { School = "Healing", Value = 0.1, Not = "Divine Hymn", NoManual = true }
--Custom
	--Weakened Soul
	self.TargetAura[GetSpellInfo(6788)] = { Spells = { 53007, 2061, 2060 }, ID = 6788, ModType =
		function( calculation, _, Talents )
			if Talents["Renewed Hope"] and calculation.healingSpell then
				calculation.critPerc = calculation.critPerc + Talents["Renewed Hope"]
			end
		end
	}

	--SPELLS
	self.spellInfo = {
		--TODO: Verify Coefficients of Divine Hymn, (Lesser Heal, Heal)
		[GetSpellInfo(15407)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK (NONE)
					["Name"] = "Mind Flay",
					[0] = { School = "Shadow", canCrit = true, castTime = 3, SPBonus = 0.771, sHits = 3, Channeled = true, NoDownrank = true },
					[1] = { 45, 45, spellLevel = 20, },
					[2] = { 108, 108, spellLevel = 28, },
					[3] = { 159, 159, spellLevel = 36, },
					[4] = { 222, 222, spellLevel = 44, },
					[5] = { 282, 282, spellLevel = 52, },
					[6] = { 363, 363, spellLevel = 60, },
					[7] = { 450, 450, spellLevel = 68, },
					[8] = { 492, 492, spellLevel = 74, },
					[9] = { 588, 588, spellLevel = 80, },
		},
		[GetSpellInfo(2944)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK (NONE)
					["Name"] = "Devouring Plague",
					[0] = { School = "Shadow", eDot = true, Leech = 0.15, eDuration = 24, SPBonus = 1.4792, Cooldown = 24, sTicks = 3, DotLeech = true, NoDownrank = true },
					[1] = { 152, 152, spellLevel = 20, },
					[2] = { 272, 272, spellLevel = 28, },
					[3] = { 400, 400, spellLevel = 36, },
					[4] = { 544, 544, spellLevel = 44, },
					[5] = { 712, 712, spellLevel = 52, },
					[6] = { 904, 904, spellLevel = 60, },
					[7] = { 1088, 1088, spellLevel = 68, },
					[8] = { 1144, 1144, spellLevel = 73, },
					[9] = { 1376, 1376, spellLevel = 79, },
		},
		[GetSpellInfo(589)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Shadow Word: Pain",
					[0] = { School = "Shadow", eDot = true, eDuration = 18 , SPBonus = 1.098, sTicks = 3, Downrank = 6 },
					[1] = { 30, 30, spellLevel = 4, },
					[2] = { 60, 60, spellLevel = 10, },
					[3] = { 120, 120, spellLevel = 18, },
					[4] = { 210, 210, spellLevel = 26, },
					[5] = { 330, 330, spellLevel = 34, },
					[6] = { 462, 462, spellLevel = 42, },
					[7] = { 606, 606, spellLevel = 50, },
					[8] = { 768, 768, spellLevel = 58, },
					[9] = { 906, 906, spellLevel = 65, Downrank = 4 },
					[10] = { 1116, 1116, spellLevel = 70, Downrank = 4 },
					[11] = { 1176, 1176, spellLevel = 75, },
					[12] = { 1380, 1380, spellLevel = 80, },
		},
		[GetSpellInfo(34914)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Vampiric Touch",
					[0] = { School = "Shadow", eDot = true, SPBonus = 2, eDuration = 15, sTicks = 3, },
					[1] = { 450, 450, spellLevel = 50, Downrank = 9 },
					[2] = { 600, 600, spellLevel = 60, Downrank = 9 },
					[3] = { 650, 650, spellLevel = 70, Downrank = 4 },
					[4] = { 735, 735, spellLevel = 75, Downrank = 4 },
					[5] = { 850, 850, spellLevel = 80, },
		},
		[GetSpellInfo(32379)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Shadow Word: Death",
					[0] = { School = "Shadow", canCrit = true, Cooldown = 12, },
					[1] = { 450, 522, spellLevel = 62, Downrank = 7 },
					[2] = { 572, 664, spellLevel = 70, Downrank = 4 },
					[3] = { 639, 741, spellLevel = 75, Downrank = 4 },
					[4] = { 750, 870, spellLevel = 80, },
		},
		[GetSpellInfo(8092)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Mind Blast",
					[0] = { School = "Shadow", canCrit = true, Cooldown = 8, BaseIncrease = true, },
					[1] = { 39, 43, 3, 3, spellLevel = 10, },
					[2] = { 72, 78, 4, 5, spellLevel = 16, },
					[3] = { 112, 120, 5, 6, spellLevel = 22, },
					[4] = { 167, 177, 7, 7, spellLevel = 28, },
					[5] = { 217, 231, 8, 8, spellLevel = 34, },
					[6] = { 279, 297, 9, 10, spellLevel = 40, },
					[7] = { 346, 366, 10, 11, spellLevel = 46, },
					[8] = { 425, 449, 12, 12, spellLevel = 52, },
					[9] = { 503, 531, 13, 13, spellLevel = 58, },
					[10] = { 557, 587, 14, 15, spellLevel = 63, },
					[11] = { 708, 748, 12, 13, spellLevel = 69, Downrank = 4 },
					[12] = { 837, 883, 16, 16, spellLevel = 74, },
					[13] = { 992, 1048, 5, 5, spellLevel = 79, },
		},
		[GetSpellInfo(17)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Power Word: Shield",
					[0] = { School = { "Holy", "Healing" }, SPBonus = 0.8068, Cooldown = 4, NoDPS = true, NoDoom = true, BaseIncrease = true, NoSchoolTalents = true, NoTypeTalents = true },
					[1] = { 44, 44, 4, 4, spellLevel = 6, },
					[2] = { 88, 88, 6, 6, spellLevel = 12, },
					[3] = { 158, 158, 8, 8, spellLevel = 18, },
					[4] = { 234, 234, 10, 10, spellLevel = 24, },
					[5] = { 301, 301, 11, 11, spellLevel = 30, },
					[6] = { 381, 381, 13, 13, spellLevel = 36, },
					[7] = { 484, 484, 15, 15, spellLevel = 42, },
					[8] = { 605, 605, 17, 17, spellLevel = 48, },
					[9] = { 763, 763, 19, 19, spellLevel = 54, },
					[10] = { 942, 942, 21, 21, spellLevel = 60, },
					[11] = { 1125, 1125, 18, 18, spellLevel = 65, Downrank = 4 },
					[12] = { 1265, 1265, 20, 20, spellLevel = 70, Downrank = 4 },
					[13] = { 1920, 1920, 30, 30, spellLevel = 75, },
					[14] = { 2230, 2230, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(2054)] = {
					--BASE OK, INCREASE OK, COEFFICIENT X
					["Name"] = "Heal",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 3, BaseIncrease = true,  },
					[1] = { 295, 341, 12, 12, spellLevel = 16, },
					[2] = { 429, 491, 16, 16, spellLevel = 22, },
					[3] = { 566, 642, 20, 20, spellLevel = 28, },
					[4] = { 712, 804, 22, 23, spellLevel = 34, },
		},
		[GetSpellInfo(2050)] = {
					--BASE OK, INCREASE OK, COEFFICIENT X
					["Name"] = "Lesser Heal",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 2.5, BaseIncrease = true, },
					[1] = { 46, 56, 1, 2, castTime = 1.5, spellLevel = 1, },
					[2] = { 71, 85, 5, 6, castTime = 2, spellLevel = 4, },
					[3] = { 135, 157, 8, 8, spellLevel = 10, },
		},
		[GetSpellInfo(2060)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Greater Heal",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 3, BaseIncrease = true, Downrank = 5 },
					[1] = { 899, 1013, 25, 26, spellLevel = 40, },
					[2] = { 1149, 1289, 29, 29, spellLevel = 46, },
					[3] = { 1437, 1609, 33, 33, spellLevel = 52, },
					[4] = { 1798, 2006, 37, 38, spellLevel = 58, },
					[5] = { 1966, 2194, 40, 41, spellLevel = 60, },
					[6] = { 2074, 2410, 33, 34, spellLevel = 63, Downrank = 4 },
					[7] = { 2396, 2784, 37, 38, spellLevel = 68, Downrank = 4 },
					[8] = { 3395, 3945, 52, 53, spellLevel = 73, },
					[9] = { 3950, 4590, 30, 31, spellLevel = 78, },
		},
		[GetSpellInfo(596)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Prayer of Healing",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 3, SPBonus = 0.2798 * 1.88, BaseIncrease = true, AoE = 5, Downrank = 9 },
					[1] = { 301, 321, 11, 12, spellLevel = 30, },
					[2] = { 444, 472, 14, 15, spellLevel = 40, },
					[3] = { 657, 695, 18, 18, spellLevel = 50, },
					[4] = { 939, 991, 21, 22, spellLevel = 60, },
					[5] = { 997, 1053, 22, 23, spellLevel = 60, },
					[6] = { 1246, 1316, 19, 20, spellLevel = 68, Downrank = 7 },
					[7] = { 2091, 2209, 18, 19, spellLevel = 76, },
		},
		[GetSpellInfo(34861)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Circle of Healing",
					[0] = { School = { "Holy", "Healing" }, sFactor = 0.5, canCrit = true, BaseIncrease = true, AoE = 5, Downrank = 4 },
					[1] = { 343, 379, 4, 5, spellLevel = 50, },
					[2] = { 403, 445, 5, 6, spellLevel = 56, },
					[3] = { 458, 506, 5, 6, spellLevel = 60, },
					[4] = { 518, 572, 6, 7, spellLevel = 65, },
					[5] = { 572, 632, 7, 8, spellLevel = 70, },
					[6] = { 825, 911, 7, 8, spellLevel = 75, },
					[7] = { 958, 1058, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(2061)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Flash Heal",
					[0] = { School = { "Holy", "Healing" }, SPBonus = 0.8068, canCrit = true, BaseIncrease = true, Downrank = 3 },
					[1] = { 193, 237, 9, 10, spellLevel = 20, },
					[2] = { 258, 314, 11, 11, spellLevel = 26, },
					[3] = { 327, 393, 12, 13, spellLevel = 32, },
					[4] = { 400, 478, 14, 14, spellLevel = 38, },
					[5] = { 518, 616, 16, 17, spellLevel = 44, },
					[6] = { 644, 764, 18, 19, spellLevel = 52, },
					[7] = { 812, 958, 21, 21, spellLevel = 58, },
					[8] = { 913, 1059, 18, 19, spellLevel = 61, Downrank = 4 },
					[9] = { 1101, 1279, 20, 21, spellLevel = 67, Downrank = 4 },
					[10] = { 1578, 1832, 40, 40, spellLevel = 73, Downrank = 5 },
					[11] = { 1887, 2193, 9, 10, spellLevel = 79, },
		},
		[GetSpellInfo(19236)] = {
					--BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK (Except levels 1-4)
					["Name"] = "Desperate Prayer",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, Cooldown = 120, NoDoom = true, SelfHeal = true, BaseIncrease = true, },
					[1] = { 263, 325, 0, 0, spellLevel = 20, },
					[2] = { 447, 543, 0, 0, spellLevel = 26, },
					[3] = { 588, 708, 0, 0, spellLevel = 34, },
					[4] = { 834, 994, 38, 39, spellLevel = 42, }, -- 872-1033 in-game
					[5] = { 1101, 1305, 0, 0, spellLevel = 50, NoDownrank = true },
					[6] = { 1324, 1562, 0, 0, spellLevel = 58, NoDownrank = true },
					[7] = { 1601, 1887, 0, 0, spellLevel = 66, NoDownrank = true },
					[8] = { 3111, 3669, 0, 0, spellLevel = 73, NoDownrank = true },
					[9] = { 3716, 4384, 0, 0, spellLevel = 80, NoDownrank = true },
		},
		[GetSpellInfo(139)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Renew",
					[0] = { School = { "Holy", "Healing" }, eDot = true, eDuration = 15, sTicks = 3, },
					[1] = { 45, 45, spellLevel = 8, },
					[2] = { 100, 100, spellLevel = 14, },
					[3] = { 175, 175, spellLevel = 20, },
					[4] = { 245, 245, spellLevel = 26, },
					[5] = { 315, 315, spellLevel = 32, },
					[6] = { 400, 400, spellLevel = 38, },
					[7] = { 510, 510, spellLevel = 44, },
					[8] = { 650, 650, spellLevel = 50, },
					[9] = { 810, 810, spellLevel = 56, },
					[10] = { 970, 970, spellLevel = 60, },
					[11] = { 1010, 1010, spellLevel = 65, Downrank = 4, },
					[12] = { 1110, 1110, spellLevel = 70, Downrank = 4, },
					[13] = { 1235, 1235, spellLevel = 75, },
					[14] = { 1400, 1400, spellLevel = 80, },
		},
		[GetSpellInfo(32546)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Binding Heal",
					[0] = { School = { "Holy", "Healing" }, SPBonus = 0.8068, canCrit = true, BaseIncrease = true, Downrank = 7 },
					[1] = { 1042, 1338, 13, 14, spellLevel = 64, },
					[2] = { 1619, 2081, 12, 12, spellLevel = 72, },
					[3] = { 1952, 2508, 7, 8, spellLevel = 78, },
		},
		[GetSpellInfo(33076)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Prayer of Mending",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, SPBonus = 4.034, Cooldown = 10, sHits = 5, NoDPS = true, NoPeriod = true, NoDownrank = true },
					[1] = { 800, 800, spellLevel = 68, },
					[2] = { 905, 905, spellLevel = 74, },
					[3] = { 1043, 1043, spellLevel = 79, },
		},
		[GetSpellInfo(585)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Smite",
					[0] = { School = "Holy", canCrit = true, castTime = 2.5, BaseIncrease = true, },
					[1] = { 13, 17, 2, 3, castTime = 1.5, spellLevel = 1, },
					[2] = { 25, 31, 3, 3, castTime = 2, spellLevel = 6, },
					[3] = { 54, 62, 4, 5, spellLevel = 14, },
					[4] = { 91, 105, 6, 7, spellLevel = 22, },
					[5] = { 150, 170, 8, 8, spellLevel = 30, },
					[6] = { 212, 240, 10, 10, spellLevel = 38, },
					[7] = { 287, 323, 11, 12, spellLevel = 46, },
					[8] = { 371, 415, 13, 14, spellLevel = 54, },
					[9] = { 405, 453, 17, 17, spellLevel = 61, },
					[10] = { 545, 611, 16, 17, spellLevel = 69, Downrank = 4 },
					[11] = { 604, 676, 20, 20, spellLevel = 74, Downrank = 4 },
					[12] = { 707, 793, 6, 6, spellLevel = 79, },
		},
		[GetSpellInfo(14914)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Holy Fire",
					[0] = { School = "Holy", canCrit = true, castTime = 2, Cooldown = 10, eDuration = 7, sTicks = 1, SPBonus = 0.5711, dotFactor = 0.168, BaseIncrease = true, Downrank = 6 },
					[1] = { 102, 128, 6, 6, hybridDotDmg = 21, spellLevel = 20, },
					[2] = { 137, 173, 10, 11, hybridDotDmg = 28, spellLevel = 24, },
					[3] = { 200, 252, 12, 12, hybridDotDmg = 42, spellLevel = 30, },
					[4] = { 267, 339, 13, 14, hybridDotDmg = 56, spellLevel = 36, },
					[5] = { 348, 440, 15, 15, hybridDotDmg = 70, spellLevel = 42, },
					[6] = { 430, 546, 17, 18, hybridDotDmg = 91, spellLevel = 48, },
					[7] = { 529, 671, 19, 20, hybridDotDmg = 112, spellLevel = 54, },
					[8] = { 639, 811, 20, 21, hybridDotDmg = 126, spellLevel = 60, },
					[9] = { 705, 895, 14, 15, hybridDotDmg = 147, spellLevel = 66, Downrank = 4 },
					[10] = { 732, 928, 16, 16, hybridDotDmg = 287, spellLevel = 72, Downrank = 4 },
					[11] = { 890, 1130, 10, 10, hybridDotDmg = 350, spellLevel = 78, },
		},
		[GetSpellInfo(15237)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Holy Nova",
					["Text1"] = GetSpellInfo(15237),
					["Text2"] = GetSpellInfo(37455), 
					[0] = { School = { "Holy", "Healing", "Holy Nova Heal" }, canCrit = true, SPBonus = 0.1609 * 1.88, BaseIncrease = true, AoE = 5, Downrank = 6  },
					[1] = { 52, 60, 2, 3, spellLevel = 20, },
					[2] = { 86, 98, 3, 3, spellLevel = 28, },
					[3] = { 121, 139, 3, 4, spellLevel = 36, },
					[4] = { 161, 188, 4, 4, spellLevel = 44, },
					[5] = { 235, 272, 4, 4, spellLevel = 52, },
					[6] = { 302, 350, 5, 6, spellLevel = 60, },
					[7] = { 384, 446, 6, 6, spellLevel = 68, },
					[8] = { 611, 709, 6, 7, spellLevel = 75, },
					[9] = { 713, 827, 0, 0, spellLevel = 80, },
			["Secondary"] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Holy Nova",
					["Text1"] = GetSpellInfo(15237),
					["Text2"] = GetSpellInfo(48360),					
					[0] = { School = { "Holy", "Holy Nova Damage" }, canCrit = true, SPBonus = 0.1609, BaseIncrease = true, AoE = true, Downrank = 6  },
					[1] = { 28, 32, 1, 2, spellLevel = 20, },
					[2] = { 50, 58, 2, 3, spellLevel = 28, },
					[3] = { 76, 88, 3, 4, spellLevel = 36, },
					[4] = { 106, 123, 4, 4, spellLevel = 44, },
					[5] = { 140, 162, 6, 6, spellLevel = 52, },
					[6] = { 181, 210, 7, 7, spellLevel = 60, },
					[7] = { 242, 280, 8, 9, spellLevel = 68, },
					[8] = { 333, 387, 8, 8, spellLevel = 75, },
					[9] = { 398, 462, 0, 0, spellLevel = 80, },
			}
		},
		[GetSpellInfo(724)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Lightwell",
					[0] = { School = { "Holy", "Healing" }, Cooldown = 180, SPBonus = 1.878, eDot = true, eDuration = 6, sTicks = 2, Stacks = 10, Downrank = 4 },
					[1] = { 801, 801, spellLevel = 40, },
					[2] = { 1164, 1164, spellLevel = 50, },
					[3] = { 1599, 1599, spellLevel = 60, Downrank = 6 },
					[4] = { 2361, 2361, spellLevel = 70, },
					[5] = { 3915, 3915, spellLevel = 75, },
					[6] = { 4620, 4620, spellLevel = 80, },
		},
		[GetSpellInfo(64843)] = {
					--BASE OK, INCREASE OK, COEFFICIENT X, DOWNRANK OK
					["Name"] = "Divine Hymn",
					[0] = { School = { "Holy", "Healing" }, castTime = 8, sHits = 4, SPBonus = 3.5 / 3 * 1.88, Cooldown = 480, Channeled = true, canCrit = true },
					[1] = { 3024, 3342, spellLevel = 80 },
		},
		[GetSpellInfo(48045)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Mind Sear",
					[0] = { School = "Shadow", sHits = 5, castTime = 5, SPBonus = 1.4305, canCrit = true, Channeled = true, AoE = true },
					[1] = { 183, 197, spellLevel = 75, },
					[2] = { 212, 228, spellLevel = 80, },
		},
		[GetSpellInfo(53007)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK(?)
					["Name"] = "Penance",
					[0] = { School = { "Holy", "Healing" }, Cooldown = 12, canCrit = true, sHits = 3, castTime = 2, SPBonus = 0.857 * 1.88, Channeled = true },
					[1] = { 670, 756, spellLevel = 60, Downrank = 9 },
					[2] = { 805, 909, spellLevel = 70, Downrank = 4 },
					[3] = { 1278, 1442, spellLevel = 75 },
					[4] = { 1484, 1676, spellLevel = 80 },
			["Secondary"] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Penance",
					[0] = { School = "Holy", Cooldown = 12, canCrit = true, sHits = 3, castTime = 2, SPBonus = 0.6876, Channeled = true, },
					[1] = { 240, 240, spellLevel = 60, Downrank = 9 },
					[2] = { 292, 292, spellLevel = 70, Downrank = 4 },
					[3] = { 333, 333, spellLevel = 75 },
					[4] = { 375, 375, spellLevel = 80 },
			}
		},
	}

	self.talentInfo = {
	--SHADOW:
		--Darkness (additive - 3.3.3)
		[GetSpellInfo(15259)] = { 	[1] = { Effect = 0.02, Spells = "Shadow" }, 
									[2] = { Effect = 0.02, Spells = "Mind Flay", ModType = "Darkness" }, },
		--Shadow Focus
		[GetSpellInfo(15260)] = { 	[1] = { Effect = 1, Spells = "Shadow", ModType = "hitPerc" }, },
		--Improved Shadow Word: Pain (additive - 3.3.3)
		[GetSpellInfo(15275)] = { 	[1] = { Effect = 0.03, Spells = "Shadow Word: Pain" }, },
		--Improved Mind Blast
		[GetSpellInfo(15273)] = { 	[1] = { Effect = -0.5, Spells = "Mind Blast", ModType = "cooldown" }, },
		--Mind Melt
		[GetSpellInfo(14910)] = {	[1] = { Effect = 2, Spells = { "Mind Blast", "Mind Flay", "Mind Sear" }, ModType = "critPerc", },
									[2] = { Effect = 3, Spells = { "Shadow Word: Pain", "Devouring Plague", "Vampiric Touch" } , ModType = "critPerc", }, },
		--Improved Devouring Plague (additive - 3.3.3)
		[GetSpellInfo(63625)] = {	[1] = { Effect = 0.05, Spells = "Devouring Plague" },
									[2] = { Effect = 0.10, Spells = "Devouring Plague", ModType = "Improved Devouring Plague", }, },
		--Shadow Power
		[GetSpellInfo(33221)] = { 	[1] = { Effect = 0.1, Spells = { "Mind Blast", "Shadow Word: Death", "Mind Flay" }, ModType = "critM", }, },
		--Misery (multiplicative - 3.3.3)
		[GetSpellInfo(33191)] = {	[1] = { Effect = 0.05, Spells = { "Mind Blast", "Mind Flay", "Mind Sear" }, ModType = "SpellDamage", Multiply = true }, },
		--Twisted Faith (multiplicative - 3.3.3)
		[GetSpellInfo(47573)] = {	[1] = { Effect = 0.02, Spells = { "Mind Flay", "Mind Blast" }, ModType = "Twisted Faith" }, },
	--HOLY:
		--Improved Renew (additive - 3.3.3)
		[GetSpellInfo(14908)] = { 	[1] = { Effect = 0.05, Spells = "Renew" }, },
		--Searing Light (additive - 3.3.3)
		[GetSpellInfo(14909)] = { 	[1] = { Effect = 0.05, Spells = { "Smite", "Holy Fire", "Penance", "Holy Nova Damage" } }, },
		--Spiritual Healing (additive - 3.3.3)
		[GetSpellInfo(14898)] = {	[1] = { Effect = 0.02, Spells = "Healing", },
									[2] = { Effect = 0.02, Spells = "Power Word: Shield", ModType = "Spiritual Healing" }, },
		--Blessed Resilience (multiplicative, additive on Lightwell - 3.3.3)
		[GetSpellInfo(33142)] = {	[1] = { Effect = 0.01, Spells = "Healing", Not = "Lightwell", Multiply = true, },
									[2] = { Effect = 0.01, Spells = "Lightwell" },
									[3] = { Effect = 0.01, Spells = "Power Word: Shield", ModType = "Blessed Resilience" }, },
		--Empowered Healing (additive - 3.3.3)
		[GetSpellInfo(33158)] = { 	[1] = { Effect = 0.08, Spells = "Greater Heal", ModType = "SpellDamage", },
									[2] = { Effect = 0.04, Spells = { "Flash Heal", "Binding Heal" }, ModType = "SpellDamage", }, },
		--Empowered Renew (multiplicative - 3.3.3)
		[GetSpellInfo(63534)] = {	[1] = { Effect = 0.05, Spells = "Renew", ModType = "SpellDamage", Multiply = true, },
									[2] = { Effect = 0.05, Spells = "Renew", ModType = "Empowered Renew", }, },
		--Divine Providence (additive - 3.3.3 - Checked Holy Nova and PoM)
		[GetSpellInfo(47562)] = { 	[1] = { Effect = 0.02, Spells = { "Circle of Healing", "Binding Heal", "Divine Hymn", "Holy Nova Heal", "Prayer of Healing", "Prayer of Mending" }, },
									[2] = { Effect = -0.6, Spells = "Prayer of Mending", ModType = "cooldown" }, },
		--Test of Faith (multiplicative - 3.3.3)
		[GetSpellInfo(47558)] = {	[1] = { Effect = 0.04, Spells = "Healing", ModType = "Test of Faith", }, },
	--DISCIPLINE:
		--Improved Power Word: Shield (multiplicative - 3.3.3)
		[GetSpellInfo(14748)] = { 	[1] = { Effect = 0.05, Spells = "Power Word: Shield", ModType = "Improved Power Word: Shield", Multiply = true }, },
		--Twin Disciplines (additive - 3.3.3, applies to Mind Flay, not Mind Sear)
		[GetSpellInfo(47586)] = { 	[1] = { Effect = 0.01, Spells = { "Shadow Word: Pain", "Renew", "Holy Nova", "Prayer of Mending", "Devouring Plague", "Shadow Word: Death", "Desperate Prayer", "Circle of Healing", "Penance", "Mind Flay" }  },
									[2] = { Effect = 0.01, Spells = "Power Word: Shield", ModType = "Twin Disciplines" }, },
		--Focused Power (multiplicative, additive on PW:S and Lightwell - 3.3.3)
		[GetSpellInfo(33190)] = {	[1] = { Effect = 0.02, Spells = "All", Not = "Lightwell", Multiply = true },
									[2] = { Effect = 0.02, Spells = "Lightwell" },
									[3] = { Effect = 0.02, Spells = "Power Word: Shield", ModType = "Focused Power" }, },
		--Soul Warding
		[GetSpellInfo(63574)] = {	[1] = { Effect = -4, Spells = "Power Word: Shield", ModType = "cooldown" }, },
		--Improved Flash Heal
		[GetSpellInfo(63504)] = {	[1] = { Effect = { 4, 7, 10 }, Spells = "Flash Heal", ModType = "Improved Flash Heal" }, },
		--Renewed Hope
		[GetSpellInfo(57472)] = {	[1] = { Effect = 2, Spells = { "Flash Heal", "Greater Heal", "Penance" }, ModType = "Renewed Hope" }, },
		--Borrowed Time (additive - 3.3.3)
		[GetSpellInfo(52795)] = {	[1] = { Effect = 0.08, Spells = "Power Word: Shield", ModType = "SpellDamage" }, },
		--Divine Aegis
		[GetSpellInfo(47515)] = {	[1] = { Effect = 0.1, Spells = "Healing", Not = "Lightwell", ModType = "Divine Aegis", },
									[2] = { Effect = 0.1, Spells = "Power Word: Shield", ModType = "Divine Aegis Bonus" }, },
		}
end