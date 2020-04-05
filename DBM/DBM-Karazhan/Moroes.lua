local mod	= DBM:NewMod("Moroes", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 175 $"):sub(12, -3))
mod:SetCreatureID(15687)
mod:RegisterCombat("yell", L.DBM_MOROES_YELL_START)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local warningVanishSoon		= mod:NewSoonAnnounce(29448, 2)
local warningVanish			= mod:NewSpellAnnounce(29448, 3)
local warningGarrote		= mod:NewTargetAnnounce(37066, 4)
local warningGouge			= mod:NewTargetAnnounce(29425, 4)
local warningBlind			= mod:NewTargetAnnounce(34694, 3)
local warningMortalStrike	= mod:NewTargetAnnounce(29572, 2)
local warningManaBurn		= mod:NewCastAnnounce(29405, 3, nil, false)
local warningGreaterHeal	= mod:NewCastAnnounce(35096, 3, nil, false)
local warningHolyLight		= mod:NewCastAnnounce(29562, 3, nil, false)

local timerVanishCD			= mod:NewCDTimer(31, 29448)
local timerGouge			= mod:NewTargetTimer(6, 29425)
local timerBlind			= mod:NewTargetTimer(10, 34694)
local timerMortalStrike		= mod:NewTargetTimer(5, 29572)

local lastVanish = 0

function mod:OnCombatStart(delay)
	timerVanishCD:Start(-delay)
	warningVanishSoon:Schedule(31-delay)
	lastVanish = 0
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(29405) then
		warningManaBurn:Show()
	elseif args:IsSpellID(35096) then
		warningGreaterHeal:Show()
	elseif args:IsSpellID(29562) then
		warningHolyLight:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29448) then
		warningVanish:Show()
		lastVanish = GetTime()
	elseif args:IsSpellID(29425) then
		warningGouge:Show(args.destName)
		timerGouge:Show(args.destName)
	elseif args:IsSpellID(34694) then
		warningBlind:Show(args.destName)
		timerBlind:Show(args.destName)
	elseif args:IsSpellID(29572) then
		warningMortalStrike:Show(args.destName)
		timerMortalStrike:Show(args.destName)
	elseif args:IsSpellID(37066) then
		warningGarrote:Show(args.destName)
		if (GetTime() - lastVanish) < 20 then--firing this event here instead, since he does garrote as soon as he comes out of vanish.
			timerVanishCD:Start()
			warningVanishSoon:Schedule(26)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(34694) then
		timerBlind:Cancel(args.destName)
	end
end