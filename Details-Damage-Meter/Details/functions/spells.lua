do

	local _details = 		_G._details
	
	_details.PotionList = {
		[53908] = true, -- Potion of Speed
		[53909] = true, -- Potion of Wild Magic
		[28494] = true, -- Insane Strength Potion
		[53762] = true, -- Indestructible Potion
		[43186] = true, -- Runic Mana Potion
		[28499] = true, -- Super Mana Potion
	}
	
	_details.SpecSpellList = {
		
	}
	
	_details.ClassSpellList = {

		--death knight
		
			[50977]	=	"DEATHKNIGHT", --  Death Gate
			[48265]	=	"DEATHKNIGHT", --  Unholy Presence
			[61999]	=	"DEATHKNIGHT", --  Raise Ally
			[47541]	=	"DEATHKNIGHT", -- Death Coil
			[48721]	=	"DEATHKNIGHT", -- Blood Boil
			[42650]	=	"DEATHKNIGHT", -- Army of the Dead
			[45524]	=	"DEATHKNIGHT", -- Chains of Ice
			[57330]	=	"DEATHKNIGHT", -- Horn of Winter
			[45462]	=	"DEATHKNIGHT", -- Plague Strike
			[85948]	=	"DEATHKNIGHT", -- Fthisring Strike
			[56815]	=	"DEATHKNIGHT", -- Rune Strike
			[63560]	=	"DEATHKNIGHT", -- Dark Transformation
			[49222]	=	"DEATHKNIGHT", -- Bone Shield
			[45477]	=	"DEATHKNIGHT", -- Icy Touch
			[43265]	=	"DEATHKNIGHT", -- Death and Decay
			[77575]	=	"DEATHKNIGHT", -- Outbreak
			[51271]	=	"DEATHKNIGHT", -- Pillar of Frost
			[48792]	=	"DEATHKNIGHT", -- Icebound Fortitude
			[55050]	=	"DEATHKNIGHT", -- Heart Strike
			[55233]	=	"DEATHKNIGHT", -- Vampiric Blood
			[49576]	=	"DEATHKNIGHT", -- Death Grip
			[56222]	=	"DEATHKNIGHT", -- Dark Command
			[73975]	=	"DEATHKNIGHT", -- Necrotic Strike
			[45529]	=	"DEATHKNIGHT", -- Blood Tap
			[50842]	=	"DEATHKNIGHT", -- Pestilence
			[48743]	=	"DEATHKNIGHT", -- Death Pact
			[47528]	=	"DEATHKNIGHT", -- Mind Freeze
			[3714]	=	"DEATHKNIGHT", -- Path of Frost
			[48263]	=	"DEATHKNIGHT", -- Blood Presence
			[49039]	=	"DEATHKNIGHT", -- Lichborne
			[49028]	=	"DEATHKNIGHT", -- Dancing Rune Weapon
			[47568]	=	"DEATHKNIGHT", -- Empower Rune Weapon
			[96268]	=	"DEATHKNIGHT", -- Death's Advance
			[49016]	=	"DEATHKNIGHT", -- Unholy Frenzy
			[49206]	=	"DEATHKNIGHT", -- Summon Gargoyle
			[48266]	=	"DEATHKNIGHT", -- Frost Presence
			[45902]	=	"DEATHKNIGHT", -- Blood Strike
			[77535]	=	"DEATHKNIGHT", --Blood Shield(heal)
			[45470]	=	"DEATHKNIGHT", --Death Strike(heal)
			[53365]	=	"DEATHKNIGHT", --Unholy Strength(heal)
			[48707]	=	"DEATHKNIGHT", -- Anti-Magic Shell(heal)
			[48982]	=	"DEATHKNIGHT", --rune tap
			[49020]	=	"DEATHKNIGHT", --obliterate
			[49143]	=	"DEATHKNIGHT", --frost strike
			[55095]	=	"DEATHKNIGHT", --frost fever
			[55078]	=	"DEATHKNIGHT", --blood plague
			[49184]	=	"DEATHKNIGHT", --howling blast
			[49998]	=	"DEATHKNIGHT", --death strike
			[55090]	=	"DEATHKNIGHT",--scourge strike
			[47632]	=	"DEATHKNIGHT",--death coil
			
		--druid
		
			[80965]	=	 "DRUID", --  Skull Bash
			[16689]	=	 "DRUID", --  Nature's Grasp
			[102417]	=	 "DRUID", --  Wild Charge
			[5229]	=	 "DRUID", --  Enrage
			[78675]	=	 "DRUID", --  Solar Beam
			[102351]	=	 "DRUID", --  Cenarion Ward
			[9005]	=	 "DRUID", --  Pounce
			[114282]	=	 "DRUID", --  Treant Form
			[5215]	=	 "DRUID", --  Prowl
			[52610]	=	 "DRUID", --  Savage Roar
			[22570]	=	 "DRUID", --  Maim
			[102401]	=	 "DRUID", --  Wild Charge
			[33831]	=	 "DRUID", --  Force of Nature
			[102355]	=	 "DRUID", --  Faerie Swarm
			[102706]	=	 "DRUID", --  Force of Nature
			[16914]	=	 "DRUID", --  Hurricane
			[2908]	=	 "DRUID", --  Soothe
			[62078]	=	 "DRUID", --  Swipe
			[6785]	=	 "DRUID", --  Ravage
			[106898]	=	 "DRUID", --  Stampeding Roar
			[33891]	=	 "DRUID", --  Incarnation: Tree of Life
			[102359]	=	 "DRUID", --  Mass Entanglement
			[108293]	=	 "DRUID", --  Heart of the Wild
			[5211]	=	 "DRUID", --  Mighty Bash
			[102795]	=	 "DRUID", --  Bear Hug
			[108291]	=	 "DRUID", --  Heart of the Wild		
			[18562]	=	 "DRUID", --Swiftmend
			[106922]	=	 "DRUID", -- Might of Ursoc
			[132158]	=	 "DRUID", -- Nature's Swiftness
			[33763]	=	 "DRUID", -- Lifebloom
			[1126]	=	 "DRUID", -- Mark of the Wild
			[6807]	=	 "DRUID", -- Maul
			[33745]	=	 "DRUID", -- Lacerate
			[145205]	=	 "DRUID", -- Wild Mushroom
			[77761]	=	 "DRUID", -- Stampeding Roar
			[102791]	=	 "DRUID", -- Wild Mushroom: Bloom
			[16953]	=	 "DRUID", -- Primal Fury
			[102693]	=	 "DRUID", -- Force of Nature
			[145518]	=	 "DRUID", -- Genesis
			[22812]	=	 "DRUID", -- Barkskin
			[770]	=	 "DRUID", -- Faerie Fire
			[106951]	=	 "DRUID", -- Berserk
			[124974]	=	 "DRUID", -- Nature's Vigil
			[105697]	=	 "DRUID", -- Virmen's Bite
			[5225]	=	 "DRUID", -- Track Humanoids
			[102280]	=	 "DRUID", -- Displacer Beast
			[102543]	=	 "DRUID", -- Incarnation: King of the Jungle
			[1850]	=	 "DRUID", -- Dash
			[77764]	=	 "DRUID", -- Stampeding Roar
			[22568]	=	 "DRUID", -- Ferocious Bite	
			[779]	=	 "DRUID", -- Swipe
			[147349]	=	 "DRUID", -- Wild Mushroom
			[77758]	=	 "DRUID", -- Thrash
			[108294]	=	 "DRUID", -- Heart of the Wild
			[106830]	=	 "DRUID", -- Thrash
			[108292]	=	 "DRUID", -- Heart of the Wild
			[768]	=	 "DRUID", -- Cat Form
			[127538]	=	 "DRUID", -- Savage Roar
			[61336]	=	 "DRUID", -- Survival Instincts
			[114236]	=	 "DRUID", -- Shred!
			[146323]	=	 "DRUID", -- Inward Contemplation
			[22842]	=	 "DRUID", -- Frenzied Regeneration
			[108238]	=	 "DRUID", -- Renewal
			[16979]	=	 "DRUID", -- Wild Charge
			[50334]	=	 "DRUID", -- Berserk
			[102558]	=	 "DRUID", -- Incarnation: Son of Ursoc
			[6795]	=	 "DRUID", -- Growl
			[48505]	=	 "DRUID", -- Starfall
			[78674]	=	 "DRUID", -- Starsurge
			[102560]	=	 "DRUID", -- Incarnation: Chosen of Elune
			[112071]	=	 "DRUID", -- Celestial Alignment
			[61391]	=	 "DRUID", -- Typhoon
			[24858]	=	 "DRUID", -- Moonkin Form
			[136086]	=	 "DRUID", -- Archer's Grace
			[127663]	=	 "DRUID", -- Astral Communion
			[49376]	=	 "DRUID", -- Wild Charge
			[62606]	=	 "DRUID", -- Savage Defense
			[80964]	=	 "DRUID", -- Skull Bash
			[1822] 	=	"DRUID", --rake
			[1079] 	=	"DRUID", --rip
			[5221] 	=	"DRUID", --shred
			[33876]	=	"DRUID", --mangle
			[33878]	=	"DRUID", --mangle(energy)
			[102545]	=	"DRUID", --ravage!
			[33878]	=	"DRUID", --mangle(energy gain)
			[17057]	=	"DRUID", --bear form(energy gain)
			[16959]	=	"DRUID", --primal fury(energy gain)
			[5217]	=	"DRUID", --tiger's fury(energy gain)
			[68285]	=	"DRUID", --leader of the pack(mana)
			[5176]	=	"DRUID", --wrath
			[93402]	=	"DRUID", --sunfire
			[2912]	=	"DRUID", --starfire
			[8921]	=	"DRUID", --moonfire
			[81070]	=	"DRUID", --eclipse
			[29166]	=	"DRUID", --innervate
			[774]	=	"DRUID", --rejuvenation
			[44203]	=	"DRUID", --tranquility
			[48438]	=	"DRUID", --wild growth
			[81269]	=	"DRUID", --shiftmend
			[102792]	=	"DRUID", --wind moshroom: bloom
			[5185]	=	"DRUID", --healing touch
			[8936]	=	"DRUID", --regrowth
			[33778]	=	"DRUID", --lifebloom
			[48503]	=	"DRUID", --living seed
			[50464]	=	"DRUID", --nourish

		--hunter
			[19503]	=	"HUNTER",--  Scatter Shot HUNTER
			[61847]	=	"HUNTER",--  Aspect of the Dragonhawk HUNTER
			[53271]	=	"HUNTER",--  Master's Call HUNTER
			[20736]	=	"HUNTER",--  Distracting Shot HUNTER
			[1543]	=	"HUNTER",--  Flare HUNTER
			[63672]	=	"HUNTER",-- Black Arrow
			[117050]	=	"HUNTER",-- Glaive Toss
			[49001]	=	"HUNTER",-- Serpent Sting
			[781]	=	"HUNTER",-- Disengage
			[34026]	=	"HUNTER",-- Kill Command
			[34600]	=	"HUNTER",-- Snake Trap
			[49048]	=	"HUNTER",-- Multi-Shot
			[3045]	=	"HUNTER",-- Rapid Fire
			[883]	=	"HUNTER",-- Call Pet
			[19574]	=	"HUNTER",-- Bestial Wrath
			[19263]	=	"HUNTER",-- Deterrence
			[49067]	=	"HUNTER",-- Explosive Trap
			[49012]	=	"HUNTER",-- Wyvern Sting
			[13159]	=	"HUNTER",-- Aspect of the Pack
			[49050]	=	"HUNTER",-- Aimed Shot
			[13809]	=	"HUNTER",-- Frost Trap
			[49052]	=	"HUNTER",-- Steady Shot
			[34490]	=	"HUNTER",-- Silencing Shot
			[53209]	=	"HUNTER",-- Chimera Shot
			[5116]	=	"HUNTER",-- Concussive Shot
			[53338]	=	"HUNTER",--'s Mark
			[34477]	=	"HUNTER",-- Misdirection
			[19801]	=	"HUNTER",-- Tranquilizing Shot
			[2641]	=	"HUNTER",-- Dismiss Pet
			[5118]	=	"HUNTER",-- Aspect of the Cheetah
			[19577]	=	"HUNTER",-- Intimidation			
			[49045]	=	"HUNTER",-- Arcane Shot
			[60053]	=	"HUNTER",-- Explosive Shot
			[61006]	=	"HUNTER",-- Kill Shot
		
		--mage
			[108839]	=	"MAGE",--  Ice Floes
			[7302]	=	"MAGE",--  Frost Armor
			[31661]	=	"MAGE",--  Dragon's Breath
			[53140]	=	"MAGE",--  Teleport: Dalaran
			[11417]	=	"MAGE",--  Portal: Orgrimmar
			[42955]	=	"MAGE",--  Conjure Refreshment
			[44457]	=	"MAGE",-- Living Bomb
			[1953]	=	"MAGE",-- Blink
			[108843]	=	"MAGE",-- Blazing Speed
			[131078]	=	"MAGE",-- Icy Veins
			[12043]	=	"MAGE",-- Presence of Mind
			[108978]	=	"MAGE",-- Alter Time
			[55342]	=	"MAGE",-- Mirror Image
			[84714]	=	"MAGE",-- Frozen Orb
			[45438]	=	"MAGE",-- Ice Block
			[115610]	=	"MAGE",-- Timeral Shield
			[110960]	=	"MAGE",-- Greater Invisibility
			[110959]	=	"MAGE",-- Greater Invisibility
			[11129]	=	"MAGE",-- Combustion
			[11958]	=	"MAGE",-- Cold Snap
			[61316]	=	"MAGE",-- Dalaran Brilliance
			[112948]	=	"MAGE",-- Frost Bomb
			[2139]	=	"MAGE",-- Counterspell
			[80353]	=	"MAGE",-- Time Warp
			[2136]	=	"MAGE",-- Fire Blast
			[7268]	=	"MAGE",-- Arcane Missiles
			[111264]	=	"MAGE",-- Ice Ward
			[114923]	=	"MAGE",-- Nether Tempest
			[2120]	=	"MAGE",-- Flamestrike
			[44425]	=	"MAGE",-- Arcane Barge
			[12042]	=	"MAGE",-- Arcane Power
			[1459]	=	"MAGE",-- Arcane Brilliance
			[127140]	=	"MAGE",-- Alter Time
			[116011]	=	"MAGE",-- Rune of Power
			[116014]	=	"MAGE",-- Rune of Power
			[132627]	=	"MAGE",-- Teleport: Vale of Eternal Blossoms
			[31687]	=	"MAGE",-- Summon Water Elemental
			[3567]	=	"MAGE",-- Teleport: Orgrimmar
			[30449]	=	"MAGE",-- Spellsteal
			[44572]	=	"MAGE",-- Deep Freeze
			[113724]	=	"MAGE",-- Ring of Frost
			[132626]	=	"MAGE",-- Portal: Vale of Eternal Blossoms
			[12472]	=	"MAGE",-- Icy Veins
			[116]	=	"MAGE",--frost bolt
			[30455]	=	"MAGE",--ice lance
			[84721]	=	"MAGE",--frozen orb
			[1449]	=	"MAGE",--arcane explosion
			[113092]	=	"MAGE",--frost bomb
			[115757]	=	"MAGE",--frost new
			[44614]	=	"MAGE",--forstfire bolt
			[42208]	=	"MAGE",--blizzard
			[11426]	=	"MAGE",--Ice Barrier(heal)
			[11366]	=	"MAGE",--pyroblast
			[133]	=	"MAGE",--fireball
			[108853]	=	"MAGE",--infernoblast
			[2948]	=	"MAGE",--scorch
			[30451]	=	"MAGE",--arcane blase
			[12051]	=	"MAGE",--evocation
			
		--paladin
		
			[31850] 	= 	"PALADIN", -- Ardent Defender
			[31842] 	= 	"PALADIN", -- Divine Favor
			[1044] 	= 	"PALADIN", -- Hand of Freedom
			[114039] 	= 	"PALADIN", -- Hand of Purity
			[4987] 	= 	"PALADIN", -- Cleanse
			[136494] 	= 	"PALADIN", -- Word of Glory
			[54428] 	= 	"PALADIN", -- Divine Plea
			[7328] 	= 	"PALADIN", -- Redemption
			[116467] 	= 	"PALADIN", -- Consecration
			[31801] 	= 	"PALADIN", -- Seal of Truth
			[20165] 	= 	"PALADIN", -- Seal of Insight
			[20473]	=	"PALADIN",-- Holy Shock
			[114158]	=	"PALADIN",-- Light's Hammer
			[85673]	=	"PALADIN",-- Word of Glory
			[85499]	=	"PALADIN",-- Speed of Light
			[84963]	=	"PALADIN",-- Inquisition
			[31884]	=	"PALADIN",-- Avenging Wrath
			[24275]	=	"PALADIN",-- Hammer of Wrath
			[114165]	=	"PALADIN",-- Holy Prism
			[20925]	=	"PALADIN",-- Sacred Shield
			[53563]	=	"PALADIN",-- Beacon of Light
			[633]	=	"PALADIN",-- Lay on Hands
			[88263]	=	"PALADIN",-- Hammer of the Righteous
			[53595]	=	"PALADIN",-- Hammer of the Righteous
			[53600]	=	"PALADIN",-- Shield of the Righteous
			[26573]	=	"PALADIN",-- Consecration
			[119072]	=	"PALADIN",-- Holy Wrath
			[105593]	=	"PALADIN",-- Fist of Justice
			[114163]	=	"PALADIN",-- Eternal Flame
			[62124]	=	"PALADIN",-- Reckoning
			[121783]	=	"PALADIN",-- Emancipate
			[98057]	=	"PALADIN",-- Grand Crusader
			[642]	=	"PALADIN",-- Divine Shield
			[122032]	=	"PALADIN",-- Exorcism
			[20217]	=	"PALADIN",-- Blessing of Kings
			[96231]	=	"PALADIN",-- Rebuke
			[105809]	=	"PALADIN",-- Holy Avenger
			[25780]	=	"PALADIN",-- Righteous Fury
			[115750]	=	"PALADIN",-- Blinding Light
			[31821]	=	"PALADIN",-- Devotion Aura
			[53385]	=	"PALADIN",-- Divine Storm
			[20154]	=	"PALADIN",-- Seal of Righteousness
			[19740]	=	"PALADIN",-- Blessing of Might
			[148039]	=	"PALADIN",-- Sacred Shield
			[82326]	=	"PALADIN",-- Divine Light
			[35395]	=	"PALADIN",--cruzade strike
			[879]	=	"PALADIN",--exorcism
			[85256]	=	"PALADIN",--templar's verdict
			[20167]	=	"PALADIN",--seal of insight(mana)
			[31935]	=	"PALADIN",--avenger's shield
			[20271]	=	"PALADIN", --judgment
			[35395]	=	"PALADIN", --cruzader strike
			[81297]	=	"PALADIN", --consacration	
			[31803]	=	"PALADIN", --censure
			[65148]	=	"PALADIN", --Sacred Shield
			[20167]	=	"PALADIN", --Seal of Insight
			[86273]	=	"PALADIN", --illuminated healing
			[85222]	=	"PALADIN", --light of dawn
			[53652]	=	"PALADIN", --beacon of light
			[82327]	=	"PALADIN", --holy radiance
			[119952]	=	"PALADIN", --arcing light
			[25914]	=	"PALADIN", --holy shock
			[19750]	=	"PALADIN", --flash of light

		--priest
			[19236] 	= 	"PRIEST", -- Desperate Prayer
			[47788] 	= 	"PRIEST", -- Guardian Spirit
			[81206] 	= 	"PRIEST", -- Chakra: Sanctuary
			[62618] 	= 	"PRIEST", -- Power Word: Barrier
			[32375] 	= 	"PRIEST", -- Mass Dispel
			[32546] 	= 	"PRIEST", -- Binding Heal			
			[126135] 	= 	"PRIEST", -- Lightwell
			[81209] 	= 	"PRIEST", -- Chakra: Chastise
			[81208] 	= 	"PRIEST", -- Chakra: Serenity
			[2006] 	= 	"PRIEST", -- Resurrection
			[1706] 	= 	"PRIEST", -- Levitate			
			[73510] 	= 	"PRIEST", -- Mind Spike
			[127632] 	= 	"PRIEST", -- Cascade
			[108921] 	= 	"PRIEST", -- Psyfiend
			[88625] 	= 	"PRIEST", -- Holy Word: Chastise
			[121135]	=	"PRIEST", -- Cascade
			[122121]	=	"PRIEST", -- Divine Star
			[110744]	=	"PRIEST", -- Divine Star
			[8122]	=	"PRIEST", -- Psychic Scream
			[81700]	=	"PRIEST", -- Archangel
			[123258]	=	"PRIEST", -- Power Word: Shield
			[48045]	=	"PRIEST", -- Mind Sear
			[49821]	=	"PRIEST", -- Mind Sear
			[123040]	=	"PRIEST", -- Mindbender
			[121536]	=	"PRIEST", -- Angelic Feather
			[121557]	=	"PRIEST", -- Angelic Feather
			[88685]	=	"PRIEST", -- Holy Word: Sanctuary
			[88684]	=	"PRIEST", -- Holy Word: Serenity
			[33076]	=	"PRIEST", -- Prayer of Mending
			[32379]	=	"PRIEST", -- Shadow Word: Death
			[129176]	=	"PRIEST", -- Shadow Word: Death
			[586]	=	"PRIEST", -- Fade
			[120517]	=	"PRIEST", -- Halo
			[64901]	=	"PRIEST", -- Hymn of Hope
			[64843]	=	"PRIEST", -- Divine Hymn
			[64844]	=	"PRIEST", -- Divine Hymn
			[34433]	=	"PRIEST", -- Shadowfiend
			[120644]	=	"PRIEST", -- Halo
			[15487]	=	"PRIEST", -- Silence
			[89485]	=	"PRIEST", -- Inner Focus
			[109964]	=	"PRIEST", -- Spirit Shell
			[129197]	=	"PRIEST", -- Mind Flay(Insanity)
			[112833]	=	"PRIEST", -- Spectral Guise
			[47750]	=	"PRIEST", -- Penance
			[33206]	=	"PRIEST", -- Pain Suppression
			[15286]	=	"PRIEST", -- Vampiric Embrace
			[588]	=	"PRIEST", -- Inner Fire
			[21562]	=	"PRIEST", -- Power Word: Fortitude
			[73413]	=	"PRIEST", -- Inner Will
			[10060]	=	"PRIEST", -- Power Infusion
			[2050]	=	"PRIEST", -- Heal
			[15473]	=	"PRIEST", -- Shadowform
			[108920]	=	"PRIEST", -- Void Tendrils
			[47585]	=	"PRIEST", -- Dispersion
			[123259]	=	"PRIEST", -- Prayer of Mending
			[34650]	=	"PRIEST", --mana leech(pet)
			[589]	=	"PRIEST", --shadow word: pain
			[34914]	=	"PRIEST", --vampiric touch
			[34919]	=	"PRIEST", --vampiric touch(mana)
			[15407]	=	"PRIEST", --mind flay
			[8092]	=	"PRIEST", --mind blast
			[15290]	=	"PRIEST",-- Vampiric Embrace
			[127626]	=	"PRIEST",--devouring plague(heal)
			[2944]	=	"PRIEST",--devouring plague(damage)
			[585]	=	"PRIEST", --smite
			[47666]	=	"PRIEST", --penance
			[14914]	=	"PRIEST", --holy fire
			[81751]	=	"PRIEST",  --atonement
			[47753]	=	"PRIEST",  --divine aegis
			[33110]	=	"PRIEST", --prayer of mending
			[77489]	=	"PRIEST", --mastery echo of light
			[596]	=	"PRIEST", --prayer of healing
			[34861]	=	"PRIEST", --circle of healing
			[139]	=	"PRIEST", --renew
			[120692]	=	"PRIEST", --halo
			[2060]	=	"PRIEST", --greater heal
			[110745]	=	"PRIEST", --divine star
			[2061]	=	"PRIEST", --flash heal
			[88686]	=	"PRIEST", --santuary
			[17]		=	"PRIEST", --power word: shield
			[64904]	=	"PRIEST", --hymn of hope
			[129250]	=	"PRIEST", --power word: solace
		
		--rogue
			[74001] 	= 	"ROGUE", -- Combat Readiness
			[14183] 	= 	"ROGUE", -- Premeditation
			[108211] 	= 	"ROGUE", -- Leeching Poison
			[5761] 	= 	"ROGUE", -- Mind-numbing Poison
			[8679] 	= 	"ROGUE", -- Wound Poison
			
			[137584] 	= 	"ROGUE", -- Shuriken Toss
			[137585] 	= 	"ROGUE", -- Shuriken Toss Off-hand
			[1833] 	= 	"ROGUE", -- Cheap Shot
			[121733] 	= 	"ROGUE", -- Throw
			[1776] 	= 	"ROGUE", -- Gouge
			[108212]	=	"ROGUE", -- Burst of Speed
			[27576]	=	"ROGUE", -- Mutilate Off-Hand
			[1329]	=	"ROGUE", -- Mutilate
			[5171]	=	"ROGUE", -- Slice and Dice
			[2983]	=	"ROGUE", -- Sprint
			[1966]	=	"ROGUE", -- Feint
			[36554]	=	"ROGUE", -- Shadowstep
			[31224]	=	"ROGUE", -- Cloak of Shadows
			[1784]	=	"ROGUE", -- Stealth
			[84617]	=	"ROGUE", -- Revealing Strike
			[13750]	=	"ROGUE", -- Adrenaline Rush
			[121471]	=	"ROGUE", -- Shadow Blades
			[121473]	=	"ROGUE", -- Shadow Blade
			[1752]	=	"ROGUE", -- Sinister Strike
			[51690]	=	"ROGUE", -- Killing Spree
			[121474]	=	"ROGUE", -- Shadow Blade Off-hand
			[1766]	=	"ROGUE", -- Kick
			[76577]	=	"ROGUE", -- Smoke Bomb
			[5277]	=	"ROGUE", -- Evasion
			[137619]	=	"ROGUE", -- Marked for Death
			[8647]	=	"ROGUE", -- Expose Armor
			[79140]	=	"ROGUE", -- Vendetta
			[51713]	=	"ROGUE", -- Shadow Dance
			[2823]	=	"ROGUE", -- Deadly Poison
			[115191]	=	"ROGUE", -- Stealth
			[108215]	=	"ROGUE", -- Paralytic Poison
			[14185]	=	"ROGUE", -- Preparation
			[2094]	=	"ROGUE", -- Blind
			[121411]	=	"ROGUE", -- Crimson Tempest
			[53]		= 	"ROGUE", --backstab
			[8680]	= 	"ROGUE", --wound pouson
			[2098]	= 	"ROGUE", --eviscerate
			[2818]	=	"ROGUE", --deadly poison
			[113780]	=	"ROGUE", --deadly poison
			[51723]	=	"ROGUE", --fan of knifes
			[111240]	=	"ROGUE", --dispatch
			[703]	=	"ROGUE", --garrote
			[1943]	=	"ROGUE", --rupture
			[114014]	=	"ROGUE", --shuriken toss
			[16511]	=	"ROGUE", --hemorrhage
			[89775]	=	"ROGUE", --hemorrhage
			[8676]	=	"ROGUE", --amcush
			[5374]	=	"ROGUE", --mutilate
			[32645]	=	"ROGUE", --envenom
			[1943]	=	"ROGUE", --rupture
			[73651]	=	"ROGUE", --Recuperate(heal)
			[35546]	=	"ROGUE", --combat potency(energy)
			[98440]	=	"ROGUE", --relentless strikes(energy)
			[51637]	=	"ROGUE", --venomous vim(energy)
			
		--shaman
			[51886] 	= 	"SHAMAN", -- Cleanse Spirit
			[98008] 	= 	"SHAMAN", -- Spirit Link Totem
			[8177] 	= 	"SHAMAN", -- Grounding Totem
			[8143] 	= 	"SHAMAN", -- Tremor Totem
			[108273] 	= 	"SHAMAN", -- Windwalk Totem
			[51514] 	= 	"SHAMAN", -- Hex
			[73682] 	= 	"SHAMAN", -- Unleash Frost
			[8033] 	= 	"SHAMAN", -- Frostbrand Weapon
			[114074] 	= 	"SHAMAN", -- Lava Beam
			[120668]	=	"SHAMAN", --Stormlash Totem
			[2894]	=	"SHAMAN", -- Fire Elemental Totem
			[2825]	=	"SHAMAN", -- Bloodlust
			[114049]	=	"SHAMAN", -- Ascendance
			[73680]	=	"SHAMAN", -- Unleash Elements
			[5394]	=	"SHAMAN", -- Healing Stream Totem
			[108280]	=	"SHAMAN", -- Healing Tide Totem
			[3599]	=	"SHAMAN", -- Searing Totem
			[73920]	=	"SHAMAN", -- Healing Rain
			[2645]	=	"SHAMAN", -- Ghost Wolf
			[16166]	=	"SHAMAN", -- Elemental Mastery
			[108281]	=	"SHAMAN", -- Ancestral Guidance
			[108270]	=	"SHAMAN", -- Stone Bulwark Totem
			[108285]	=	"SHAMAN", -- Call of the Elements
			[115356]	=	"SHAMAN", -- Stormblast
			[60103]	=	"SHAMAN", -- Lava Lash
			[51533]	=	"SHAMAN", -- Feral Spirit
			[17364]	=	"SHAMAN", -- Stormstrike
			[16188]	=	"SHAMAN", -- Ancestral Swiftness
			[2062]	=	"SHAMAN", -- Earth Elemental Totem
			[8024]	=	"SHAMAN", -- Flametongue Weapon
			[51485]	=	"SHAMAN", -- Earthgrab Totem
			[331]	=	"SHAMAN", -- Healing Wave
			[61882]	=	"SHAMAN", -- Earthquake
			[52127]	=	"SHAMAN", -- Water Shield
			[77472]	=	"SHAMAN", -- Greater Healing Wave
			[108269]	=	"SHAMAN", -- Capacitor Totem
			[79206]	=	"SHAMAN", -- Spiritwalker's Grace
			[57994]	=	"SHAMAN", -- Wind Shear
			[108271]	=	"SHAMAN", -- Astral Shift
			[30823]	=	"SHAMAN", --istic Rage
			[77130]	=	"SHAMAN", -- Purify Spirit
			[58875]	=	"SHAMAN", -- Spirit Walk
			[36936]	=	"SHAMAN", -- Totemic Recall
			[51730]	=	"SHAMAN", -- Earthliving Weapon
			[8056]	=	"SHAMAN", -- Frost Shock
			[88765]	=	"SHAMAN", --rolling thunder(mana)
			[51490]	=	"SHAMAN", --thunderstorm(mana)
			[82987]	=	"SHAMAN", --telluric currents glyph(mana)
			[101033]	=	"SHAMAN", --resurgence(mana)
			[51505]	=	"SHAMAN", --lava burst
			[8050]	=	"SHAMAN", --flame shock
			[117014]	=	"SHAMAN", --elemental blast
			[403]	=	"SHAMAN", --lightning bolt
			[45284]	=	"SHAMAN", --lightning bolt
			[421]	=	"SHAMAN", --chain lightining
			[32175]	=	"SHAMAN", --stormstrike
			[25504]	=	"SHAMAN", --windfury
			[8042]	=	"SHAMAN", --earthshock
			[26364]	=	"SHAMAN", --lightning shield
			[117014]	=	"SHAMAN", --elemental blast
			[73683]	=	"SHAMAN", --unleash flame
			[51522]	=	"SHAMAN", --primal wisdom(mana)
			[63375]	=	"SHAMAN", --primal wisdom(mana)
			[114942]	=	"SHAMAN", --healing tide
			[73921]	=	"SHAMAN", --healing rain
			[1064]	=	"SHAMAN", --chain heal
			[52042]	=	"SHAMAN", --healing stream totem
			[61295]	=	"SHAMAN", --riptide
			[51945]	=	"SHAMAN", --earthliving
			[114083]	=	"SHAMAN", --restorative mists
			[8004]	=	"SHAMAN", --healing surge
			
		--warlock
			[80240] 	= 	"WARLOCK", -- Havoc
			[112921] 	= 	"WARLOCK", -- Summon Abyssal
			[48020] 	= 	"WARLOCK", -- Demonic Circle: Teleport
			[111397] 	= 	"WARLOCK", -- Blood Horror
			[112869] 	= 	"WARLOCK", -- Summon Observer
			[1454] 	= 	"WARLOCK", -- Life Tap
			[112868] 	= 	"WARLOCK", -- Summon Shivarra
			[112869] 	= 	"WARLOCK", -- Summon Observer
			[120451] 	= 	"WARLOCK", -- Flames of Xoroth
			[29893] 	= 	"WARLOCK", -- Create Soulwell
			[114189] 	= 	"WARLOCK", -- Health Funnel
			[112866] 	= 	"WARLOCK", -- Summon Fel Imp
			[108683] 	= 	"WARLOCK", -- Fire and Brimstone
			[688] 	= 	"WARLOCK", -- Summon Imp
			[112092] 	= 	"WARLOCK", -- Shadow Bolt
			[113861] 	= 	"WARLOCK", -- Dark Soul: Knowledge
			[103967] 	= 	"WARLOCK", -- Carrion Swarm
			[112870] 	= 	"WARLOCK", -- Summon Wrathguard
			[104316] 	= 	"WARLOCK", -- Imp Swarm
			[17962]	=	"WARLOCK", -- Conflagrate
			[108359]	=	"WARLOCK", -- Dark Regeneration
			[110913]	=	"WARLOCK", -- Dark Bargain
			[105174]	=	"WARLOCK", -- Hand of Gul'dan
			[697]	=	"WARLOCK", -- Summon Voidwalker
			[6201]	=	"WARLOCK", -- Create Healthstone
			[146739]	=	"WARLOCK", -- Corruption
			[109151]	=	"WARLOCK", -- Demonic Leap
			[104773]	=	"WARLOCK", -- Unending Resolve
			[103958]	=	"WARLOCK", -- Metamorphosis
			[119678]	=	"WARLOCK", -- Soul Swap
			[6229]	=	"WARLOCK", -- Twilight Ward
			[74434]	=	"WARLOCK", -- Soulburn
			[30283]	=	"WARLOCK", -- Shadowfury
			[113860]	=	"WARLOCK", -- Dark Soul: Misery
			[108503]	=	"WARLOCK", -- Grimoire of Sacrifice
			[104232]	=	"WARLOCK", -- Rain of Fire
			[6353]	=	"WARLOCK", -- Soul Fire
			[689]	=	"WARLOCK", -- Drain Life
			[17877]	=	"WARLOCK", -- Shadowburn
			[113858]	=	"WARLOCK", -- Dark Soul: Instability
			[1490]	=	"WARLOCK", -- Curse of the Elements
			[114635]	=	"WARLOCK", -- Ember Tap
			[27243]	=	"WARLOCK", -- Seed of Corruption
			[131623]	=	"WARLOCK", -- Twilight Ward
			[6789]	=	"WARLOCK", -- Mortal Coil
			[111400]	=	"WARLOCK", -- Burning Rush
			[124916]	=	"WARLOCK", -- Chaos Wave
			[1120]	=	"WARLOCK", -- Drain Soul
			[109773]	=	"WARLOCK", -- Dark Intent
			[112927]	=	"WARLOCK", -- Summon Terrorguard
			[1122]	=	"WARLOCK", -- Summon Infernal
			[108416]	=	"WARLOCK", -- Sacrificial Pact
			[5484]	=	"WARLOCK", -- Howl of Terror
			[29858]	=	"WARLOCK", -- Soulshatter
			[18540]	=	"WARLOCK", -- Summon Doomguard
			[89420]	=	"WARLOCK", -- Drain Life
			[20707]	=	"WARLOCK", -- Soulstone
			[132413]	=	"WARLOCK", -- Shadow Bulwark
			[109466]	=	"WARLOCK", -- Curse of Enfeeblement
			[48018]	=	"WARLOCK", -- Demonic Circle: Summon
			[77799]	=	"WARLOCK", --fel flame
			[63106]	=	"WARLOCK", --siphon life
			[1454]	=	"WARLOCK", --life tap
			[103103]	=	"WARLOCK", --malefic grasp
			[980]	=	"WARLOCK", --agony
			[30108]	=	"WARLOCK", --unstable affliction
			[172]	=	"WARLOCK", --corruption	
			[48181]	=	"WARLOCK", --haunt	
			[29722]	=	"WARLOCK", --incenerate
			[348]	=	"WARLOCK", --Immolate
			[116858]	=	"WARLOCK", --Chaos Bolt
			[114654]	=	"WARLOCK", --incinerate
			[108686]	=	"WARLOCK", --immolate
			[108685]	=	"WARLOCK", --conflagrate
			[104233]	=	"WARLOCK", --rain of fire
			[103964]	=	"WARLOCK", --touch os chaos
			[686]	=	"WARLOCK", --shadow bolt
			[114328]	=	"WARLOCK", --shadow bolt glyph
			[140719]	=	"WARLOCK", --hellfire
			[104027]	=	"WARLOCK", --soul fire
			[603]	=	"WARLOCK", --doom
			[108371]	=	"WARLOCK", --Harvest life
			
		--warrior
			[2565] 	= 	"WARRIOR", -- Shield Block
			[2457] 	= 	"WARRIOR", -- Battle Stance
			[12328] 	= 	"WARRIOR", -- Sweeping Strikes
			[114192] 	= 	"WARRIOR", -- Mocking Banner
			[12323] 	= 	"WARRIOR", -- Piercing Howl
			[122475] 	= 	"WARRIOR", -- Throw
			[845] 	= 	"WARRIOR", -- Cleave
			[5246] 	= 	"WARRIOR", -- Intimidating Shout
			[7386] 	= 	"WARRIOR", -- Sunder Armor
			[107566] 	= 	"WARRIOR", -- Staggering Shout
			[86346]	=	"WARRIOR", -- Colossus Smash
			[18499]	=	"WARRIOR", -- Berserker Rage
			[107570]	=	"WARRIOR", -- Storm Bolt
			[1680]	=	"WARRIOR", -- Whirlwind
			[85384]	=	"WARRIOR", -- Raging Blow Off-Hand
			[85288]	=	"WARRIOR", -- Raging Blow
			[100]	=	"WARRIOR", -- Charge
			[7384]	=	"WARRIOR", -- Overpower
			[23881]	=	"WARRIOR", -- Bloodthirst
			[118000]	=	"WARRIOR", -- Dragon Roar
			[50622]	=	"WARRIOR", -- Bladestorm
			[46924]	=	"WARRIOR", -- Bladestorm
			[6673]	=	"WARRIOR", -- Battle Shout
			[103840]	=	"WARRIOR", -- Impending Victory
			[5308]	=	"WARRIOR", -- Execute
			[57755]	=	"WARRIOR", -- Heroic Throw
			[871]	=	"WARRIOR", -- Shield Wall
			[97462]	=	"WARRIOR", -- Rallying Cry
			[118038]	=	"WARRIOR", -- Die by the Sword
			[114203]	=	"WARRIOR", -- Demoralizing Banner
			[52174]	=	"WARRIOR", -- Heroic Leap
			[1719]	=	"WARRIOR", -- Recklessness
			[114207]	=	"WARRIOR", -- Skull Banner
			[1715]	=	"WARRIOR", -- Hamstring
			[107574]	=	"WARRIOR", -- Avatar
			[46968]	=	"WARRIOR", -- Shockwave
			[6343]	=	"WARRIOR", -- Thunder Clap
			[12292]	=	"WARRIOR", -- Bloodbath
			[64382]	=	"WARRIOR", -- Shattering Throw
			[114028]	=	"WARRIOR", -- Mass Spell Reflection
			[55694]	=	"WARRIOR", -- Enraged Regeneration
			[6552]	=	"WARRIOR", -- Pummel
			[6572]	=	"WARRIOR", -- Revenge
			[112048]	=	"WARRIOR", -- Shield Barrier
			[23920]	=	"WARRIOR", -- Spell Reflection
			[12975]	=	"WARRIOR", -- Last Stand
			[355]	=	"WARRIOR", -- Taunt
			[102060]	=	"WARRIOR", -- Disrupting Shout

			[100130]	=	"WARRIOR", --wild strike
			[96103]	=	"WARRIOR", --raging blow
			[12294]	=	"WARRIOR", --mortal strike
			[1464]	=	"WARRIOR", --Slam
			[23922]	=	"WARRIOR", --shield slam
			[20243]	=	"WARRIOR", --devastate
			[11800]	=	"WARRIOR", --dragon roar
			[115767]	=	"WARRIOR", --deep wounds
			[109128]	=	"WARRIOR", --charge
			[11294]	=	"WARRIOR", --mortal strike
			[109128]	=	"WARRIOR", --charge
			[12880]	=	"WARRIOR", --enrage
			[29842]	=	"WARRIOR", --undribled wrath
	}
	
	_details.CrowdControlSpells = {

		--death knight
			[96294]	= true, --chains of ice

		--druid
			--hibernate
			[2637]	= true, --hibernate
			[339]	= true, --entangling toots

		--hunter
			[3355]	= true, --freezing trap
			[60202] = true, -- Freezing Arrow
			[24335]	= true, --wyvern sting
			[136634]	= true, --narrow escape
			[4167]	= true, --web(spider)
			[19503]	= true, --scatter shot
			
		--mage
			[118]	= true, --polymorph sheep
			[61305]	= true, --polymorph black cat
			[28272]	= true, --polymorph pig
			[61721]	= true, --polymorph rabbit
			[61780]	= true, --polymorph turkey
			[28271]	= true, --polymorph turtle
			[122]	= true, --frost new
			[33395]	= true, --freeze
			[82691]	= true, --ring of frost
		
		--paladin
			[20066]	= true, --repentance
		--priest
			--shackle undead
			[8122]	= true, --psychic scream
			[9484]	= true, --shackle undead
			
		--rogue
			[2094]	= true, --blind
			[1776]	= true, --gouge
			[6770]	= true, --sap
			[408]	= true, --kidney shot
			[1833]	= true, --cheap shot
		
		--shaman
			[51514]	= true, --hex
			[64695]	= true, --earthgrab(earthgrab totem)
			[76780]	= true, --bind elemental
		
		--warlock
			[6358]	= true, --seduction(succubus)
			[6215]	= true, --fear
			[17928]	= true, --howl of terror
		
		--warrior
			[5246]	= true, --intimidating shout
	}

	_details.AbsorbSpells = {
			-- Death Knight
			[48707] = 5, -- Anti-Magic Shell(DK) Rank 1 -- Does not currently seem to show tracable combat log events. It shows energizes which do not reveal the amount of damage absorbed
			[51052] = 10, -- Anti-Magic Zone(DK)( Rank 1(Correct spellID?)
				-- Does DK Spell Deflection show absorbs in the CL?
			[51271] = 20, -- Unbreakable Armor(DK)
			[77535] = 10, -- Blood Shield(DK)
			-- Druid
			[62606] = 10, -- Savage Defense proc.(Druid) Tooltip of the original spell doesn't clearly state that this is an absorb, but the buff does.
			-- Mage
			[11426] = 60, -- Ice Barrier(Mage) Rank 1
			[13031] = 60,
			[13032] = 60,
			[13033] = 60,
			[27134] = 60,
			[33405] = 60,
			[43038] = 60,
			[43039] = 60, -- Rank 8
			[6143] = 30, -- Frost Ward(Mage) Rank 1
			[8461] = 30, 
			[8462] = 30,  
			[10177] = 30,  
			[28609] = 30,
			[32796] = 30,
			[43012] = 30, -- Rank 7
			[1463] = 60, --  Mana shield(Mage) Rank 1
			[8494] = 60,
			[8495] = 60,
			[10191] = 60,
			[10192] = 60,
			[10193] = 60,
			[27131] = 60,
			[43019] = 60,
			[43020] = 60, -- Rank 9
			[543] = 30 , -- Fire Ward(Mage) Rank 1
			[8457] = 30,
			[8458] = 30,
			[10223] = 30,
			[10225] = 30,
			[27128] = 30,
			[43010] = 30, -- Rank 7
			-- Paladin
			[58597] = 6, -- Sacred Shield(Paladin) proc(Fixed, thanks to Julith)
			-- Priest
			[17] = 30, -- Power Word: Shield(Priest) Rank 1
			[592] = 30,
			[600] = 30,
			[3747] = 30,
			[6065] = 30,
			[6066] = 30,
			[10898] = 30,
			[10899] = 30,
			[10900] = 30,
			[10901] = 30,
			[25217] = 30,
			[25218] = 30,
			[48065] = 30,
			[48066] = 30, -- Rank 14
			[47509] = 12, -- Divine Aegis(Priest) Rank 1
			[47511] = 12,
			[47515] = 12, -- Divine Aegis(Priest) Rank 3(Some of these are not actual buff spellIDs)
			[47753] = 12, -- Divine Aegis(Priest) Rank 1
			[54704] = 12, -- Divine Aegis(Priest) Rank 1
			[47788] = 10, -- Guardian Spirit (Priest)(50 nominal absorb, this may not show in the CL)
			-- Warlock
			[7812] = 30, -- Sacrifice(warlock) Rank 1
			[19438] = 30,
			[19440] = 30,
			[19441] = 30,
			[19442] = 30,
			[19443] = 30,
			[27273] = 30,
			[47985] = 30,
			[47986] = 30, -- rank 9
			[6229] = 30, -- Shadow Ward(warlock) Rank 1
			[11739] = 30,
			[11740] = 30,
			[28610] = 30,
			[47890] = 30,
			[47891] = 30, -- Rank 6
			-- Consumables
			[29674] = 86400, -- Lesser Ward of Shielding
			[29719] = 86400, -- Greater Ward of Shielding(these have infinite duration, set for a day here :P)
			[29701] = 86400,
			[28538] = 120, -- Major Holy Protection Potion
			[28537] = 120, -- Major Shadow
			[28536] = 120, --  Major Arcane
			[28513] = 120, -- Major Nature
			[28512] = 120, -- Major Frost
			[28511] = 120, -- Major Fire
			[7233] = 120, -- Fire
			[7239] = 120, -- Frost
			[7242] = 120, -- Shadow Protection Potion
			[7245] = 120, -- Holy
			[6052] = 120, -- Nature Protection Potion
			[53915] = 120, -- Mighty Shadow Protection Potion
			[53914] = 120, -- Mighty Nature Protection Potion
			[53913] = 120, -- Mighty Frost Protection Potion
			[53911] = 120, -- Mighty Fire
			[53910] = 120, -- Mighty Arcane
			[17548] = 120, --  Greater Shadow
			[17546] = 120, -- Greater Nature
			[17545] = 120, -- Greater Holy
			[17544] = 120, -- Greater Frost
			[17543] = 120, -- Greater Fire
			[17549] = 120, -- Greater Arcane
			[28527] = 15, -- Fel Blossom
			[29432] = 3600, -- Frozen Rune usage(Naxx classic)
			-- Item usage
			[36481] = 4, -- Arcane Barrier(TK Kael'Thas) Shield
			[57350] = 6, -- Darkmoon Card: Illusion
			[17252] = 30, -- Mark of the Dragon Lord(LBRS epic ring) usage
			[25750] = 15, -- Defiler's Talisman/Talisman of Arathor Rank 1
			[25747] = 15,
			[25746] = 15,
			[23991] = 15,
			[31000] = 300, -- Pendant of Shadow's End Usage
			[30997] = 300, -- Pendant of Frozen Flame Usage
			[31002] = 300, -- Pendant of the Null Rune
			[30999] = 300, -- Pendant of Withering
			[30994] = 300, -- Pendant of Thawing
			[31000] = 300, -- 
			[23506]= 20, -- Arena Grand Master Usage(Aura of Protection)
			[12561] = 60, -- Goblin Construction Helmet usage
			[31771] = 20, -- Runed Fungalcap usage
			[21956] = 10, -- Mark of Resolution usage
			[29506] = 20, -- The Burrower's Shell
			[4057] = 60, -- Flame Deflector
			[4077] = 60, -- Ice Deflector
			[39228] = 20, -- Argussian Compass(may not be an actual absorb)
			-- Item procs
			[27779] = 30, -- Divine Protection - Priest dungeon set 1/2  Proc
			[11657] = 20, -- Jang'thraze(Zul Farrak) proc
			[10368] = 15, -- Uther's Strength proc
			[37515] = 15, -- Warbringer Armor Proc
			[42137] = 86400, -- Greater Rune of Warding Proc
			[26467] = 30, -- Scarab Brooch proc
			[26470] = 8, -- Scarab Brooch proc(actual)
			[27539] = 6, -- Thick Obsidian Breatplate proc
			[28810] = 30, -- Faith Set Proc Armor of Faith
			[54808] = 12, -- Noise Machine proc Sonic Shield 
			[55019] = 12, -- Sonic Shield(one of these too ought to be wrong)
			[64411] = 15, -- Blessing of the Ancient(Val'anyr Hammer of Ancient Kings equip effect)
			[64413] = 8, -- Val'anyr, Hammer of Ancient Kings proc Protection of Ancient Kings
			-- Misc
			[40322] = 30, -- Teron's Vengeful Spirit Ghost - Spirit Shield
			-- Boss abilities
			[65874] = 15, -- Twin Val'kyr's Shield of Darkness 175000
			[67257] = 15, -- 300000
			[67256] = 15, -- 700000
			[67258] = 15, -- 1200000
			[65858] = 15, -- Twin Val'kyr's Shield of Lights 175000
			[67260] = 15, -- 300000
			[67259] = 15, -- 700000
			[67261] = 15, -- 1200000
	}
	
	_details.DefensiveCooldownSpellsNoBuff = {
		
		[20594] = {120, 8, 1}, --racial stoneform
		
		[6262] = {120, 1, 1}, --healthstone
		[47875] = {120, 1, 1}, --healthstone
		
		--["DEATHKNIGHT"] = {},
		[48707] = {45, 5, 1}, -- Anti-Magic Shell
		[48743] = {120, 0, 1}, --Death Pact
		[51052] = {120, 3, 0}, --Anti-Magic Zone
		
		--["DRUID"] = {},
		[48477] = {480, 8, 0}, --Tranquility
		[22842] = {0, 0, 1}, --Frenzied Regeneration
		
		--["HUNTER"] = {},
		
		--["MAGE"] = {},
		
		--["PALADIN"] = {},
		[633]	=	{600, 0}, --Lay on Hands
		[31821]	=	{180, 6, 0},-- Devotion Aura
		[64205] = {180, 6, 0}, -- Divine Guardian(Sacrifice)
		
		--["PRIEST"] = {},
		[62618] = {180, 10, 0}, --Power Word: Barrier
		[109964] = {60, 10, 0}, --Spirit Shell
		[64843] = {180, 8, 0}, --Divine Hymn
		
		--["ROGUE"] = {},
		[76577] = {180, 0, 0}, --Smoke Bomb
		
		--["SHAMAN"] = {},
		[16190]	=	{300, 12}, -- Mana Tide Totem
		[2825] = {300, 40, 0}, -- Bloodlust
		
		--["WARLOCK"] = {108416, 6229},
		[47860] = {180, 1, 1}, -- Twilight Ward  1 = self
		
		--["WARRIOR"] = {},
		[97462]	= {180, 10}, -- Rallying Cry
	}
	
	_details.DefensiveCooldownSpells = {
	
		--> spellid = {cooldown, duration}
		
		-- Death Knigh 
		[55233] = {60, 10}, -- Vampiric Blood
		[49222] = {60, 300}, -- Bone Shield
		[48792] = {180, 12}, -- Icebound Fortitude
		[48743] = {120, 0}, -- Death Pact
		[49039] = {12, 10}, -- Lichborne
		["DEATHKNIGHT"] = {55233, 49222, 48707, 48792, 48743, 49039, 48743, 51052},

		-- Druid
		[61336] = {180, 12}, -- Survival Instincts
		[22812] = {60, 12}, -- Barkskin
		["DRUID"] = {61336, 22812, 740, 22842},
		
		-- Hunter
		[19263] = {120, 5}, -- Deterrence
		["HUNTER"] = {19263},
		
		-- Mage
		[45438] = {300, 12}, -- Ice Block
		["MAGE"] = {45438},
		
		-- Paladin
		[498] = {60, 10}, -- Divine Protection
		[642] = {300, 12}, -- Divine Shield
		[6940] = {120, 12}, -- Hand of Sacrifice
		[10278] = {300, 10}, -- Hand of Protection
		[1038] = {120, 10}, -- Hand of Salvation
		["PALADIN"] = {64205, 498, 642, 6940, 10278, 1038, 48788, 31821},

		-- Priest
		[15286] = {180, 15}, -- Vampiric Embrace
		[47788] = {180, 10}, -- Guardian Spirit
		[47585] = {120, 6}, -- Dispersion
		[33206] = {180, 8}, -- Pain Suppression
		["PRIEST"] = {15286, 47788, 47585, 33206, 62618, 64843},
		
		-- Rogue
		[1966] = {1.5, 5}, -- Feint
		[31224] = {60, 5}, -- Cloak of Shadows
		[5277] = {180, 15}, -- Evasion
		["ROGUE"] = {1966, 31224, 5277, 76577},
		
		-- Shaman
		[30823] = {60, 15}, -- Shamanistic Rage
		[32182] = {300, 40}, -- Heroism
		["SHAMAN"] = {30823, 16198, 2825, 32182},
		
		-- Warlock
		[47891] = {30, 30}, -- Shadow Ward
		["WARLOCK"] = {47860},

		-- Warrior
		[871] = {180, 12}, -- Shield Wall
		[12975] = {180, 20}, -- Last Stand
		[23920] = {25, 5}, -- Spell Reflection
		[2565] 	= {90, 6}, -- Shield Block
		[112048]	= {90, 6}, -- Shield Barrier
		["WARRIOR"] = {871, 12975, 23920, 114203, 114028, 97462}

	}

	_details.HarmfulSpells = {
		
		--death knight
		[49020] 	= 	true, -- obliterate
		[49143] 	=	true, -- frost strike
		[55095] 	= 	true, -- frost fever
		[55078] 	= 	true, -- blood plague
		[49184] 	= 	true, -- howling blast
		[49998] 	= 	true, -- death strike
		[55090] 	= 	true, -- scourge strike
		[47632] 	= 	true, -- death coil
		[108196]	=	true, --Death Siphon
		[47541]	=	true, -- Death Coil
		[48721]	=	true, -- Blood Boil
		[42650]	=	true, -- Army of the Dead
		[130736]	=	true, -- Soul Reaper
		[45524]	=	true, -- Chains of Ice
		[45462]	=	true, -- Plague Strike
		[85948]	=	true, -- Fthisring Strike
		[56815]	=	true, -- Rune Strike
		[45477]	=	true, -- Icy Touch
		[43265]	=	true, -- Death and Decay
		[77575]	=	true, -- Outbreak
		[115989]	=	true, -- Unholy Blight
		[55050]	=	true, -- Heart Strike
		[114866]	=	true, -- Soul Reaper
		[73975]	=	true, -- Necrotic Strike
		[130735]	=	true, -- Soul Reaper
		[50842]	=	true, -- Pestilence
		[45902]	=	true, -- Blood Strike
		[108194]	=	true, --  Asphyxiate
		[77606]	=	true, --  Dark Simulacrum
		
		--druid
		[80965]	=	 true, --  Skull Bashs
		[78675]	=	 true, --  Solar Beam
		[22570]	=	 true, --  Maim
		[33831]	=	 true, --  Force of Nature
		[102706]	=	 true, --  Force of Nature
		[102355]	=	 true, --  Faerie Swarm
		[16914]	=	 true, --  Hurricane
		[2908]	=	 true, --  Soothe
		[62078]	=	 true, --  Swipe
		[106996]	=	 true, --  Astral Storm
		[6785]	=	 true, --  Ravage
		[33891]	=	 true, --  Incarnation: Tree of Life
		[102359]	=	 true, --  Mass Entanglement
		[5211]	=	 true, --  Mighty Bash
		[102795]	=	 true, --  Bear Hug
		[1822] 	= 	true, --rake
		[1079] 	= 	true, --rip
		[5221] 	= 	true, --shred
		[33876] 	=	true, --mangle
		[102545] 	= 	true, --ravage!
		[5176]	=	true, --wrath
		[93402]	=	true, --sunfire
		[2912]	=	true, --starfire
		[8921]	=	true, --moonfire
		[6807]	=	 true, -- Maul
		[33745]	=	 true, -- Lacerate
		[770]	=	 true, -- Faerie Fire
		[22568]	=	 true, -- Ferocious Bite
		[779]	=	 true, -- Swipe
		[77758]	=	 true, -- Thrash
		[106830]	=	 true, -- Thrash
		[114236]	=	 true, -- Shred!
		[48505]	=	 true, -- Starfall
		[78674]	=	 true, -- Starsurge
		[80964]	=	 true, -- Skull Bash	
		
		--hunter
		[19503]	=	true,--  Scatter Shot
		[109259]	=	true,--  Powershot
		[20736]	=	true,--  Distracting Shot
		[131900]	=	true, --a murder of crows
		[118253]	=	true, --serpent sting
		[77767]	=	true, --cobra shot
		[3044]	=	true, --arcane shot
		[53301]	=	true, --explosive shot
		[120361]	=	true, --barge
		[53351]	=	true, --kill shot
		[3674]	=	true,-- Black Arrow
		[117050]	=	true,-- Glaive Toss
		[1978]	=	true,-- Serpent Sting
		[34026]	=	true,-- Kill Command		
		[2643]	=	true,-- Multi-Shot
		[109248]	=	true,-- Binding Shot
		[149365]	=	true,-- Dire Beast
		[120679]	=	true,-- Dire Beast		
		[3045]	=	true,-- Rapid Fire
		[19574]	=	true,-- Bestial Wrath
		[19386]	=	true,-- Wyvern Sting
		[19434]	=	true,-- Aimed Shot
		[120697]	=	true,-- Lynx Rush
		[56641]	=	true,-- Steady Shot
		[34490]	=	true,-- Silencing Shot
		[53209]	=	true,-- Chimera Shot
		[82928]	=	true,-- Aimed Shot!
		[5116]	=	true,-- Concussive Shot
		[147362]	=	true,-- Counter Shot
		[19801]	=	true,-- Tranquilizing Shot
		[82654]	=	true,-- Widow Venom
		
		--mage
		[116]	=	true, --frost bolt
		[30455]	=	true, --ice lance
		[84721]	=	true, --frozen orb
		[1449]	=	true, --arcane explosion
		[113092]	=	true, --frost bomb
		[115757]	=	true, --frost new
		[44614]	=	true, --forstfire bolt
		[42208]	=	true, --blizzard
		[11366]	=	true, --pyroblast
		[133]	=	true, --fireball
		[108853]	=	true, --infernoblast
		[2948]	=	true, --scorch
		[30451]	=	true, --arcane blase
		[44457]	=	true,-- Living Bomb
		[84714]	=	true,-- Frozen Orb
		[11129]	=	true,-- Combustion
		[112948]	=	true,-- Frost Bomb
		[2139]	=	true,-- Counterspell
		[2136]	=	true,-- Fire Blast
		[7268]	=	true,-- Arcane Missiles
		[114923]	=	true,-- Nether Tempest
		[2120]	=	true,-- Flamestrike
		[44425]	=	true,-- Arcane Barge
		[44572]	=	true,-- Deep Freeze
		[113724]	=	true,-- Ring of Frost
		[31661]	=	true,--  Dragon's Breath
		
		--monk
		[107428]	=	true, --rising sun kick
		[100784]	=	true, --blackout kick
		[132467]	=	true, --Chi wave	
		[107270]	=	true, --spinning crane kick
		[100787]	=	true, --tiger palm
		[132463]	=	true, -- shi wave
		[100780]	=	true, -- Jab
		[115698]	=	true, -- Jab
		[108557]	=	true, -- Jab
		[115693]	=	true, -- Jab
		[101545]	=	true, -- Flying Serpent Kick
		[122470]	=	true, -- Touch of Karma
		[117418]	=	true, -- Fists of Fury
		[113656]	=	true, -- Fists of Fury
		[115098]	=	true, -- Chi Wave
		[117952]	=	true, -- Crackling Jade Lightning
		[115078]	=	true, -- Paralysis
		[116705]	=	true, -- Spear Hand Strike
		[116709]	=	true, -- Spear Hand Strike
		[101546]	=	true, -- Spinning Crane Kick
		[116847]	=	true, -- Rushing Jade Wind
		[115181]	=	true, -- Breath of Fire
		[121253]	=	true, -- Keg Smash
		[124506]	=	true, -- Gift of the Ox
		[124503]	=	true, -- Gift of the Ox
		[124507]	=	true, -- Gift of the Ox
		[115080]	=	true, -- Touch of Death
		[119381]	=	true, -- Leg Sweep
		[115695]	=	true, -- Jab
		[137639]	=	true, -- Storm, Earth, and Fire
		[115073]	=	true, -- Spinning Fire Blossom
		[115008]	=	true, -- Chi Torpedo
		[121828]	=	true, -- --Chi Torpedo 
		[115180]	=	true, -- Dizzying Haze
		[123986]	=	true, -- Chi Burst
		[130654]	=	true, -- Chi Burst
		[148135]	=	true, -- Chi Burst
		[119392]	=	true, -- Charging Ox Wave
		[116095]	=	true, -- Disable
		[115687]	=	true, -- Jab		
		[117993]	=	true, -- Chi Torpedo
		
		--paladin
		[35395]	=	true,--cruzade strike
		[879]	=	true,--exorcism
		[85256]	=	true,--templar's verdict
		[31935]	=	true,--avenger's shield
		[20271]	=	true, --judgment
		[35395]	=	true, --cruzader strike
		[81297]	=	true, --consacration
		[31803]	=	true, --censure
		[20473]	=	true,-- Holy Shock	
		[114158]	=	true,-- Light's Hammer
		[24275]	=	true,-- Hammer of Wrath
		[88263]	=	true,-- Hammer of the Righteous
		[53595]	=	true,-- Hammer of the Righteous
		[53600]	=	true,-- Shield of the Righteous
		[26573]	=	true,-- Consecration
		[119072]	=	true,-- Holy Wrath
		[105593]	=	true,-- Fist of Justice
		[122032]	=	true,-- Exorcism
		[96231]	=	true,-- Rebuke
		[115750]	=	true,-- Blinding Light
		[53385]	=	true,-- Divine Storm
		[116467] 	= 	true, -- Consecration
		[31801] 	= 	true, -- Seal of Truth
		[20165] 	= 	true, -- Seal of Insight
		
		--priest
		[589]	=	true, --shadow word: pain
		[34914]	=	true, --vampiric touch
		[15407]	=	true, --mind flay
		[8092]	=	true, --mind blast
		[15290]	=	true,-- Vampiric Embrace
		[2944]	=	true,--devouring plague(damage)
		[585]	=	true, --smite
		[47666]	=	true, --penance
		[14914]	=	true, --holy fire
		[48045]	=	true, -- Mind Sear
		[49821]	=	true, -- Mind Sear		
		[32379]	=	true, -- Shadow Word: Death
		[129176]	=	true, -- Shadow Word: Death
		[120517]	=	true, -- Halo
		[120644]	=	true, -- Halo
		[15487]	=	true, -- Silence
		[129197]	=	true, -- Mind Flay(Insanity)
		[108920]	=	true, -- Void Tendrils
		[73510] 	= 	true, -- Mind Spike
		[127632] 	= 	true, -- Cascade
		[108921] 	= 	true, -- Psyfiend
		[88625] 	= 	true, -- Holy Word: Chastise
		
		--rogue
		[53]		= 	true, --backstab
		[2098]	= 	true, --eviscerate
		[51723]	=	true, --fan of knifes
		[111240]	=	true, --dispatch
		[703]	=	true, --garrote
		[1943]	=	true, --rupture
		[114014]	=	true, --shuriken toss
		[16511]	=	true, --hemorrhage
		[89775]	=	true, --hemorrhage
		[8676]	=	true, --amcush
		[5374]	=	true, --mutilate
		[32645]	=	true, --envenom
		[1943]	=	true, --rupture
		[27576]	=	true, -- Mutilate Off-Hand
		[1329]	=	true, -- Mutilate
		[84617]	=	true, -- Revealing Strike
		[1752]	=	true, -- Sinister Strike
		[121473]	=	true, -- Shadow Blade
		[121474]	=	true, -- Shadow Blade Off-hand
		[1766]	=	true, -- Kick
		[8647]	=	true, -- Expose Armor
		[2094]	=	true, -- Blind
		[121411]	=	true, -- Crimson Tempest
		[137584] 	= 	true, -- Shuriken Toss
		[137585] 	= 	true, -- Shuriken Toss Off-hand
		[1833] 	= 	true, -- Cheap Shot
		[121733] 	= 	true, -- Throw
		[1776] 	= 	true, -- Gouge		

		--shaman
		[51505]	=	true, --lava burst
		[8050]	=	true, --flame shock
		[117014]	=	true, --elemental blast
		[403]	=	true, --lightning bolt
		[45284]	=	true, --lightning bolt
		[421]	=	true, --chain lightining
		[32175]	=	true, --stormstrike
		[25504]	=	true, --windfury
		[8042]	=	true, --earthshock
		[26364]	=	true, --lightning shield
		[117014]	=	true, --elemental blast
		[73683]	=	true, --unleash flame
		[115356]	=	true, -- Stormblast
		[60103]	=	true, -- Lava Lash
		[17364]	=	true, -- Stormstrike
		[61882]	=	true, -- Earthquake
		[57994]	=	true, -- Wind Shear
		[8056]	=	true, -- Frost Shock
		[114074] 	= 	true, -- Lava Beam

		--warlock
		[77799]	=	true, --fel flame
		[63106]	=	true, --siphon life
		[103103]	=	true, --malefic grasp
		[980]	=	true, --agony
		[30108]	=	true, --unstable affliction
		[172]	=	true, --corruption	
		[48181]	=	true, --haunt	
		[29722]	=	true, --incenerate
		[348]	=	true, --Immolate
		[116858]	=	true, --Chaos Bolt
		[114654]	=	true, --incinerate
		[108686]	=	true, --immolate
		[108685]	=	true, --conflagrate
		[104233]	=	true, --rain of fire
		[103964]	=	true, --touch os chaos
		[686]	=	true, --shadow bolt
		[114328]	=	true, --shadow bolt glyph
		[140719]	=	true, --hellfire
		[104027]	=	true, --soul fire
		[603]	=	true, --doom
		[108371]	=	true, --Harvest life
		[17962]	=	true, -- Conflagrate
		[105174]	=	true, -- Hand of Gul'dan
		[146739]	=	true, -- Corruption
		[30283]	=	true, -- Shadowfury
		[104232]	=	true, -- Rain of Fire
		[6353]	=	true, -- Soul Fire
		[689]	=	true, -- Drain Life
		[17877]	=	true, -- Shadowburn
		[1490]	=	true, -- Curse of the Elements
		[27243]	=	true, -- Seed of Corruption
		[6789]	=	true, -- Mortal Coil
		[124916]	=	true, -- Chaos Wave
		[1120]	=	true, -- Drain Soul
		[5484]	=	true, -- Howl of Terror
		[89420]	=	true, -- Drain Life
		[109466]	=	true, -- Curse of Enfeeblement
		[112092] 	= 	true, -- Shadow Bolt
		[103967] 	= 	true, -- Carrion Swarm
		
		--warrior
		[100130]	=	true, --wild strike
		[96103]	=	true, --raging blow
		[12294]	=	true, --mortal strike
		[1464]	=	true, --Slam
		[23922]	=	true, --shield slam
		[20243]	=	true, --devastate
		[11800]	=	true, --dragon roar
		[115767]	=	true, --deep wounds
		[109128]	=	true, --charge
		[11294]	=	true, --mortal strike
		[29842]	=	true, --undribled wrath
		[86346]	=	true, -- Colossus Smash
		[107570]	=	true, -- Storm Bolt
		[1680]	=	true, -- Whirlwind
		[85384]	=	true, -- Raging Blow Off-Hand
		[85288]	=	true, -- Raging Blow
		[7384]	=	true, -- Overpower
		[23881]	=	true, -- Bloodthirst
		[118000]	=	true, -- Dragon Roar
		[50622]	=	true, -- Bladestorm
		[46924]	=	true, -- Bladestorm
		[103840]	=	true, -- Impending Victory
		[5308]	=	true, -- Execute
		[57755]	=	true, -- Heroic Throw
		[1715]	=	true, -- Hamstring
		[46968]	=	true, -- Shockwave
		[6343]	=	true, -- Thunder Clap
		[64382]	=	true, -- Shattering Throw
		[6552]	=	true, -- Pummel
		[6572]	=	true, -- Revenge
		[102060]	=	true, -- Disrupting Shout
		[12323] 	= 	true, -- Piercing Howl
		[122475] 	= 	true, -- Throw
		[845] 	= 	true, -- Cleave
		[5246] 	= 	true, -- Intimidating Shout
		[7386] 	= 	true, -- Sunder Armor
		[107566] 	= 	true, -- Staggering Shout
	}
	
	_details.MiscClassSpells = {
		--death knight
		[49576]	=	true, -- Death Grip
		[56222]	=	true, -- Dark Command
		[47528]	=	true, -- Mind Freeze(interrupt)
		[123693]	=	true, -- Plague Leech(consume plegue, get 2 deathrunes)
		[3714]	=	true, -- Path of Frost
		[48263]	=	true, -- Blood Presence
		[47568]	=	true, -- Empower Rune Weapon
		[57330]	=	true, -- Horn of Winter(buff)
		[45529]	=	true, -- Blood Tap
		[96268]	=	true, -- Death's Advance(walk faster)
		[48266]	=	true, -- Frost Presence
		[50977]	=	true, --  Death Gate
		[108199]	=	true, --  Gorefiend's Grasp
		[108201]	=	true, --  Desecrated Ground
		[48265]	=	true, --  Unholy Presence
		[61999]	=	true, --  Raise Ally	
		
		--druid
		[16689]	=	 true, --  Nature's Grasp
		[102417]	=	 true, --  Wild Charge
		[5229]	=	 true, --  Enrage
		[9005]	=	 true, --  Pounce
		[114282]	=	 true, --  Treant Form
		[5215]	=	 true, --  Prowl
		[52610]	=	 true, --  Savage Roar
		[102401]	=	 true, --  Wild Charge
		[102793]	=	 true, --  Ursol's Vortex
		[106898]	=	 true, --  Stampeding Roar
		[132158]	=	 true, -- Nature's Swiftness(misc)
		[1126]	=	 true, -- Mark of the Wild(buff)
		[77761]	=	 true, -- Stampeding Roar
		[77764]	=	 true, -- Stampeding Roar
		[16953]	=	 true, -- Primal Fury
		[102693]	=	 true, -- Force of Nature
		[145518]	=	 true, -- Genesis
		[5225]	=	 true, -- Track Humanoids
		[102280]	=	 true, -- Displacer Beast
		[1850]	=	 true, -- Dash
		[108294]	=	 true, -- Heart of the Wild
		[108292]	=	 true, -- Heart of the Wild
		[768]	=	 true, -- Cat Form
		[127538]	=	 true, -- Savage Roar
		[16979]	=	 true, -- Wild Charge
		[49376]	=	 true, -- Wild Charge
		[6795]	=	 true, -- Growl
		[61391]	=	 true, -- Typhoon
		[24858]	=	 true, -- Moonkin Form
		[81070]	=	true, --eclipse
		[29166]	=	true, --innervate
		
		--hunter
		[781]	=	true,-- Disengage
		[82948]	=	true,-- Snake Trap
		[82939]	=	true,-- Explosive Trap
		[82941]	=	true,-- Ice Trap
		[883]	=	true,-- Call Pet 1
		[83242]	=	true,-- Call Pet 2
		[83243]	=	true,-- Call Pet 3
		[83244]	=	true,-- Call Pet 4
		[2641]	=	true,-- Dismiss Pet
		[82726]	=	true,-- Fervor
		[13159]	=	true,-- Aspect of the Pack
		[109260]	=	true,-- Aspect of the Iron Hawk
		[1130]	=	true,--'s Mark
		[5118]	=	true,-- Aspect of the Cheetah
		[34477]	=	true,-- Misdirection
		[19577]	=	true,-- Intimidation
		[83245]	=	true,--  Call Pet 5
		[51753]	=	true,--  Camouflage
		[13165]	=	true,--  Aspect of the Hawk
		[53271]	=	true,--  Master's Call
		[1543]	=	true,--  Flare
		
		--mage
		[1953]	=	true,-- Blink
		[108843]	=	true,-- Blazing Speed
		[55342]	=	true,-- Mirror Image
		[110960]	=	true,-- Greater Invisibility
		[110959]	=	true,-- Greater Invisibility
		[11958]	=	true,-- Cold Snap
		[61316]	=	true,-- Dalaran Brilliance
		[1459]	=	true,-- Arcane Brilliance
		[116011]	=	true,-- Rune of Power
		[116014]	=	true,-- Rune of Power
		[132627]	=	true,-- Teleport: Vale of Eternal Blossoms
		[31687]	=	true,-- Summon Water Elemental
		[3567]	=	true,-- Teleport: Orgrimmar
		[30449]	=	true,-- Spellsteal
		[132626]	=	true,-- Portal: Vale of Eternal Blossoms
		[12051]	=	true, --evocation
		[108839]	=	true,--  Ice Floes
		[7302]	=	true,--  Frost Armor
		[53140]	=	true,--  Teleport: Dalaran
		[11417]	=	true,--  Portal: Orgrimmar
		[42955]	=	true,--  Conjure Refreshment
		
		--monk
		[109132]	=	true, -- Roll(neutral)
		[115313]	=	true, -- Summon Jade Serpent Statue
		[116781]	=	true, -- Legacy of the White Tiger
		[115921]	=	true, -- Legacy of the Emperor
		[119582]	=	true, -- Purifying Brew
		[126892]	=	true, -- Zen Pilgrimage
		[121827]	=	true, -- Roll
		[115315]	=	true, -- Summon Black Ox Statue
		[115399]	=	true, -- Chi Brew
		[101643]	=	true, -- Transcendence
		[115546]	=	true, -- Provoke
		[115294]	=	true, -- Mana Tea
		[116680]	=	true, -- Thunder Focus Tea
		[115070]	=	true, -- Stance of the Wise Serpent
		[115069]	=	true, -- Stance of the Sturdy Ox
		
		--paladin
		[85499]	=	true,-- Speed of Light
		[84963]	=	true,-- Inquisition
		[62124]	=	true,-- Reckoning
		[121783]	=	true,-- Emancipate
		[98057]	=	true,-- Grand Crusader
		[20217]	=	true,-- Blessing of Kings
		[25780]	=	true,-- Righteous Fury
		[20154]	=	true,-- Seal of Righteousness
		[19740]	=	true,-- Blessing of Might
		[54428] 	= 	true, -- Divine Plea --misc
		[7328] 	= 	true, -- Redemption
		
		--priest
		[8122]	=	true, -- Psychic Scream
		[81700]	=	true, -- Archangel
		[586]	=	true, -- Fade
		[121536]	=	true, -- Angelic Feather
		[121557]	=	true, -- Angelic Feather
		[64901]	=	true, -- Hymn of Hope
		[89485]	=	true, -- Inner Focus
		[112833]	=	true, -- Spectral Guise
		[588]	=	true, -- Inner Fire
		[21562]	=	true, -- Power Word: Fortitude
		[73413]	=	true, -- Inner Will
		[15473]	=	true, -- Shadowform
		[126135] 	= 	true, -- Lightwell
		[81209] 	= 	true, -- Chakra: Chastise
		[81208] 	= 	true, -- Chakra: Serenity
		[2006] 	= 	true, -- Resurrection
		[1706] 	= 	true, -- Levitate
		
		--rogue
		[108212]	=	true, -- Burst of Speed(misc)
		[5171]	=	true, -- Slice and Dice
		[2983]	=	true, -- Sprint
		[36554]	=	true, -- Shadowstep
		[1784]	=	true, -- Stealth
		[115191]	=	true, -- Stealth
		[2823]	=	true, -- Deadly Poison
		[108215]	=	true, -- Paralytic Poison
		[14185]	=	true, -- Preparation
		[74001] 	= 	true, -- Combat Readiness
		[14183] 	= 	true, -- Premeditation
		[108211] 	= 	true, -- Leeching Poison
		[5761] 	= 	true, -- Mind-numbing Poison
		[8679] 	= 	true, -- Wound Poison
		
		--shaman
		[73680]	=	true, -- Unleash Elements(misc)
		[3599]	=	true, -- Searing Totem
		[2645]	=	true, -- Ghost Wolf
		[108285]	=	true, -- Call of the Elements
		[8024]	=	true, -- Flametongue Weapon
		[51730]	=	true, -- Earthliving Weapon
		[51485]	=	true, -- Earthgrab Totem
		[108269]	=	true, -- Capacitor Totem
		[79206]	=	true, -- Spiritwalker's Grace
		[58875]	=	true, -- Spirit Walk
		[36936]	=	true, -- Totemic Recall
		[8177] 	= 	true, -- Grounding Totem
		[8143] 	= 	true, -- Tremor Totem
		[108273] 	= 	true, -- Windwalk Totem
		[51514] 	= 	true, -- Hex
		[73682] 	= 	true, -- Unleash Frost
		[8033] 	= 	true, -- Frostbrand Weapon
		
		--warlock
		[697]	=	true, -- Summon Voidwalker
		[6201]	=	true, -- Create Healthstone
		[109151]	=	true, -- Demonic Leap
		[103958]	=	true, -- Metamorphosis
		[119678]	=	true, -- Soul Swap
		[74434]	=	true, -- Soulburn
		[108503]	=	true, -- Grimoire of Sacrifice
		[111400]	=	true, -- Burning Rush
		[109773]	=	true, -- Dark Intent
		[112927]	=	true, -- Summon Terrorguard
		[1122]	=	true, -- Summon Infernal
		[18540]	=	true, -- Summon Doomguard
		[29858]	=	true, -- Soulshatter
		[20707]	=	true, -- Soulstone
		[48018]	=	true, -- Demonic Circle: Summon
		[80240] 	= 	true, -- Havoc
		[112921] 	= 	true, -- Summon Abyssal
		[48020] 	= 	true, -- Demonic Circle: Teleport
		[111397] 	= 	true, -- Blood Horror
		[112869] 	= 	true, -- Summon Observer
		[1454] 	= 	true, -- Life Tap
		[112868] 	= 	true, -- Summon Shivarra
		[112869] 	= 	true, -- Summon Observer
		[120451] 	= 	true, -- Flames of Xoroth
		[29893] 	= 	true, -- Create Soulwell
		[112866] 	= 	true, -- Summon Fel Imp
		[108683] 	= 	true, -- Fire and Brimstone
		[688] 	= 	true, -- Summon Imp
		[112870] 	= 	true, -- Summon Wrathguard
		[104316] 	= 	true, -- Imp Swarm
		
		--warrior
		[18499]	=	true, -- Berserker Rage(class)
		[100]	=	true, -- Charge
		[6673]	=	true, -- Battle Shout
		[52174]	=	true, -- Heroic Leap
		[355]	=	true, -- Taunt
		[2457] 	= 	true, -- Battle Stance
		[12328] 	= 	true, -- Sweeping Strikes
		[114192] 	= 	true, -- Mocking Banner
		
	}
	
	_details.DualSideSpells = {
		[114165]	=	true,-- Holy Prism(paladin)
		[47750]	=	true, -- Penance(priest)
	}
	
	_details.AttackCooldownSpells = {
		--death knight
		[49016]	=	true, -- Unholy Frenzy(attack cd)
		[49206]	=	true, -- Summon Gargoyle(attack cd)
		[49028]	=	true, -- Dancing Rune Weapon(attack cd)
		[51271]	=	true, -- Pillar of Frost(attack cd)
		[63560]	=	true, -- Dark Transformation(pet)
		
		--druid
		[106951]	=	 true, -- Berserk(attack cd)
		[124974]	=	 true, -- Nature's Vigil(attack cd)
		[102543]	=	 true, -- Incarnation: King of the Jungle
		[50334]	=	 true, -- Berserk
		[102558]	=	 true, -- Incarnation: Son of Ursoc
		[102560]	=	 true, -- Incarnation: Chosen of Elune
		[112071]	=	 true, -- Celestial Alignment
		[127663]	=	 true, -- Astral Communion
		[108293]	=	 true, --  Heart of the Wild(attack cd)
		[108291]	=	 true, --  Heart of the Wild
		
		--hunter
		[131894]	=	true,-- A Murder of Crows(attack cd)
		[121818]	=	true,-- Stampede(attack cd)
		[82692]	=	true,-- Focus Fire
		[120360]	=	true,-- Barge
		
		--mage
		[80353]	=	true,-- Time Warp
		[131078]	=	true,-- Icy Veins
		[12472]	=	true,-- Icy Veins
		[12043]	=	true,-- Presence of Mind
		[108978]	=	true,-- Alter Time
		[127140]	=	true,-- Alter Time
		[12042]	=	true,-- Arcane Power
		
		--monk
		[116740]	=	true, -- Tigereye Brew(attack cd?)
		[123904]	=	true, -- Invoke Xuen, the White Tiger
		[115288]	=	true, -- Energizing Brew
		
		--paladin
		[31884]	=	true,-- Avenging Wrath
		[105809]	=	true,-- Holy Avenger
		[31842] 	= 	true, -- Divine Favor
		
		--priest
		[34433]	=	true, -- Shadowfiend
		[123040]	=	true, -- Mindbender
		[10060]	=	true, -- Power Infusion
		
		--rogue
		[13750]	=	true, -- Adrenaline Rush(attack cd)
		[121471]	=	true, -- Shadow Blades
		[137619]	=	true, -- Marked for Death
		[79140]	=	true, -- Vendetta
		[51690]	=	true, -- Killing Spree
		[51713]	=	true, -- Shadow Dance
		
		--shaman
		[120668]	=	true, --Stormlash Totem(attack cd)
		[2894]	=	true, -- Fire Elemental Totem
		[2825]	=	true, -- Bloodlust
		[114049]	=	true, -- Ascendance
		[16166]	=	true, -- Elemental Mastery
		[51533]	=	true, -- Feral Spirit
		[16188]	=	true, -- Ancestral Swiftness
		[2062]	=	true, -- Earth Elemental Totem
		
		--warlock
		[113860]	=	true, -- Dark Soul: Misery(attack cd)
		[113858]	=	true, -- Dark Soul: Instability
		[113861] 	= 	true, -- Dark Soul: Knowledge
		
		--warrior
		[1719]	=	true, -- Recklessness(attack cd)
		[114207]	=	true, -- Skull Banner
		[107574]	=	true, -- Avatar
		[12292]	=	true, -- Bloodbath
	}
	
	_details.HelpfulSpells = {
		--death knight
		[45470] = true, -- Death Strike(heal)
		[77535] = true, -- Blood Shield(heal)
		[53365] = true, -- Unholy Strength(heal)
		[48707] = true, -- Anti-Magic Shell(heal)
		[48982] = true, -- rune tap
		[48743]	=	true, -- Death Pact(heal)
		
		--druid
		[33878] =	true, --mangle(energy gain)
		[17057] =	true, --bear form(energy gain)
		[16959] =	true, --primal fury(energy gain)
		[5217] = true, --tiger's fury(energy gain)
		[68285] =	true, --leader of the pack(mana)
		[774]	=	true, --rejuvenation
		[44203]	=	true, --tranquility
		[48438]	=	true, --wild growth
		[81269]	=	true, --shiftmend
		[5185]	=	true, --healing touch
		[8936]	=	true, --regrowth
		[33778]	=	true, --lifebloom
		[48503]	=	true, --living seed
		[50464]	=	true, --nourish	
		[18562]	=	 true, --Swiftmend(heal)
		[33763]	=	 true, -- Lifebloom(heal)

		
		--hunter
		
		--mage
		[11426]	=	true, --Ice Barrier(heal)
		
		--paladin
		[20925]	=	true,-- Sacred Shield
		[53563]	=	true,-- Beacon of Light
		[633]	=	true,-- Lay on Hands
		[642]	=	true,-- Divine Shield
		[31821]	=	true,-- Devotion Aura
		[82326]	=	true,-- Divine Light
		[20167]	=	true,--seal of insight(mana)
		[65148]	=	true, --Sacred Shield
		[20167]	=	true, --Seal of Insight
		[53652]	=	true, --beacon of light
		[25914]	=	true, --holy shock
		[19750]	=	true, --flash of light
		[31850] 	= 	true, -- Ardent Defender --defensive cd
		[1044] 	= 	true, -- Hand of Freedom --helpful
		[4987] 	= 	true, -- Cleanse
		
		--priest
		[19236] 	= 	true, -- Desperate Prayer
		[47788] 	= 	true, -- Guardian Spirit
		[81206] 	= 	true, -- Chakra: Sanctuary
		[62618] 	= 	true, -- Power Word: Barrier
		[32375] 	= 	true, -- Mass Dispel
		[32546] 	= 	true, -- Binding Heal
		[33110]	=	true, --prayer of mending
		[596]	=	true, --prayer of healing
		[34861]	=	true, --circle of healing
		[139]	=	true, --renew
		[2060]	=	true, --greater heal
		[2061]	=	true, --flash heal
		[17]		=	true, --power word: shield
		[64904]	=	true, --hymn of hope
		[33076]	=	true, -- Prayer of Mending
		[15286]	=	true, -- Vampiric Embrace
		[2050]	=	true, -- Heal
		
		--rogue
		[35546]	=	true, --combat potency(energy)
		[31224]	=	true, -- Cloak of Shadows(cooldown)
		[1966]	=	true, -- Feint(helpful)
		[76577]	=	true, -- Smoke Bomb
		[5277]	=	true, -- Evasion
		
		--shaman
		[88765]	=	true, --rolling thunder(mana)
		[51490]	=	true, --thunderstorm(mana)
		[82987]	=	true, --telluric currents glyph(mana)
		[51522]	=	true, --primal wisdom(mana)
		[63375]	=	true, --primal wisdom(mana)
		[1064]	=	true, --chain heal
		[52042]	=	true, --healing stream totem
		[61295]	=	true, --riptide
		[51945]	=	true, --earthliving
		[8004]	=	true, --healing surge
		[5394]	=	true, -- Healing Stream Totem(heal)
		[73920]	=	true, -- Healing Rain
		[331]	=	true, -- Healing Wave
		[52127]	=	true, -- Water Shield
		[77472]	=	true, -- Greater Healing Wave
		[30823]	=	true, --Shamanistic Rage
		[77130]	=	true, -- Purify Spirit
		[51886] 	= 	true, -- Cleanse Spirit
		
		--warlock
		[6229]	=	true, -- Twilight Ward
		[114189] 	= 	true, -- Health Funnel

		--warrior
		[871]	=	true, -- Shield Wall
		[55694]	=	true, -- Enraged Regeneration
		[23920]	=	true, -- Spell Reflection
		[12975]	=	true, -- Last Stand
		[2565] 	= 	true, -- Shield Block
	}
	
	_details.RaidBuffsSpells = {
	--Bosses
		--Buffs
	[62807] = true, --> Starlight
	[65134] = true, --> Storm Power 25
	[63711] = true, --> Storm Power 10
	[62821] = true, --> Toasty Fire
		--Debuffs
	[64320] = true, --> Rune of Power
	[65724] = true, --> Empowered Dark    
	[65748] = true, --> Empowered Light
	-- Raid
	[49016] = true, --> Hysteria
	[10060] = true, --> Power Infusion
	[57933] = true, --> Tricks of the Trade
	[1038] = true, --> Hand of Salvation
	
	}

	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	_details.SpellOverwrite = {
		--[124464] = {name = GetSpellInfo(124464) .. "(" .. Loc["STRING_MASTERY"] .. ")"}, --> shadow word: pain mastery proc(priest)
	}
	
	function _details:IsCooldown(spellid)
		return _details.DefensiveCooldownSpellsNoBuff[spellid] or _details.DefensiveCooldownSpells[spellid]
	end

	_details.spells_school = {
		[1] = {name = "Physical", formated = "|cFFFFFF00Physical|r", hex = "FFFFFF00", rgb = {255, 255, 0}, decimals = {1.00, 1.00, 0.00}},
		[2] = {name = "Holy", formated = "|cFFFFE680Holy|r", hex = "FFFFE680", rgb = {255, 230, 128}, decimals = {1.00, 0.90, 0.50}},
		[4] = {name = "Fire", formated = "|cFFFF8000Fire|r", hex = "FFFF8000", rgb = {255, 128, 0}, decimals = {1.00, 0.50, 0.00}},
		[8] = {name = "Nature", formated = "|cFF4DFF4DNature|r", hex = "FF4DFF4D", rgb = {77, 255, 77}, decimals = {0.30, 1.00, 0.30}},
		[16] = {name = "Frost", formated = "|cFF80FFFFFrost|r", hex = "FF80FFFF", rgb = {128, 255, 255}, decimals = {0.50, 1.00, 1.00}},
		[32] = {name = "Shadow", formated = "|cFF8080FFShadow|r", hex = "FF8080FF", rgb = {128, 128, 255}, decimals = {0.50, 0.50, 1.00}},
		[64] = {name = "Arcane", formated = "|cFFFF80FFArcane|r", hex = "FFFF80FF", rgb = {255, 128, 255}, decimals = {1.00, 0.50, 1.00}},
		[3] = {name = "Holystrike", formated = "|cFFFFE680Holy|r + |cFFFFFF00Physical|r"},
		[5] = {name = "Flamestrike", formated = "|cFFFF8000Fire|r + |cFFFFFF00Physical|r"},
		[6] = {name = "Holyfire", formated = "|cFFFF8000Fire|r + |cFFFFE680Holy|r"},
		[9] = {name = "Stormstrike", formated = "|cFF4DFF4DNature|r + |cFFFFFF00Physical|r"},
		[10] = {name = "Holystorm", formated = "|cFF4DFF4DNature|r + |cFFFFE680Holy|r"},
		[12] = {name = "Firestorm", formated = "|cFF4DFF4DNature|r + |cFFFF8000Fire|r"},
		[17] = {name = "Froststrike", formated = "|cFF80FFFFFrost|r + |cFFFFFF00Physical|r"},
		[18] = {name = "Holyfrost", formated = "|cFF80FFFFFrost|r + |cFFFFE680Holy|r"},
		[20] = {name = "Frostfire", formated = "|cFF80FFFFFrost|r + |cFFFF8000Fire|r"},
		[24] = {name = "Froststorm", formated = "|cFF80FFFFFrost|r + |cFF4DFF4DNature|r"},
		[33] = {name = "Shadowstrike", formated = "|cFF8080FFShadow|r + |cFFFFFF00Physical|r"},
		[34] = {name = "Shadowlight(Twilight)", formated = "|cFF8080FFShadow|r + |cFFFFE680Holy|r"},
		[36] = {name = "Shadowflame", formated = "|cFF8080FFShadow|r + |cFFFF8000Fire|r"},
		[40] = {name = "Shadowstorm(Plague)", formated = "|cFF8080FFShadow|r + |cFF4DFF4DNature|r"},
		[48] = {name = "Shadowfrost", formated = "|cFF8080FFShadow|r + |cFF80FFFFFrost|r"},
		[65] = {name = "Spellstrike", formated = "|cFFFF80FFArcane|r + |cFFFFFF00Physical|r"},
		[66] = {name = "Divine", formated = "|cFFFF80FFArcane|r + |cFFFFE680Holy|r"},
		[68] = {name = "Spellfire", formated = "|cFFFF80FFArcane|r + |cFFFF8000Fire|r"},
		[72] = {name = "Spellstorm", formated = "|cFFFF80FFArcane|r + |cFF4DFF4DNature|r"},
		[80] = {name = "Spellfrost", formated = "|cFFFF80FFArcane|r + |cFF80FFFFFrost|r"},
		[96] = {name = "Spellshadow", formated = "|cFFFF80FFArcane|r + |cFF8080FFShadow|r"},
		[28] = {name = "Elemental", formated = "|cFF80FFFFFrost|r + |cFF4DFF4DNature|r + |cFFFF8000Fire|r"},
		[124] = {name = "Chromatic", formated = "|cFFFF80FFArcane|r + |cFF8080FFShadow|r + |cFF80FFFFFrost|r + |cFF4DFF4DNature|r + |cFFFF8000Fire|r"},
		[126] = {name = "Magic", formated = "|cFFFF80FFArcane|r + |cFF8080FFShadow|r + |cFF80FFFFFrost|r + |cFF4DFF4DNature|r + |cFFFF8000Fire|r + |cFFFFE680Holy|r"},
		[127] = {name = "Chaos", formated = "|cFFFF80FFArcane|r + |cFF8080FFShadow|r + |cFF80FFFFFrost|r + |cFF4DFF4DNature|r + |cFFFF8000Fire|r + |cFFFFE680Holy|r + |cFFFFFF00Physical|r"},
	}
	
	function _details:GetSpellSchoolName(school)
		return _details.spells_school[school] and _details.spells_school[school].name or ""
	end
	function _details:GetSpellSchoolFormatedName(school)
		return _details.spells_school[school] and _details.spells_school[school].formated or ""
	end
	
	function _details:GetCooldownList(class)
		class = class or select(2, UnitClass("player"))
		return _details.DefensiveCooldownSpells[class]
	end
	
end