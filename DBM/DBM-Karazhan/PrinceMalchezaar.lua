local mod	= DBM:NewMod("Prince", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 172 $"):sub(12, -3))
mod:SetCreatureID(15690)
--mod:RegisterCombat("yell", L.DBM_PRINCE_YELL_PULL)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_MONSTER_YELL"
)

local warnPhase2				= mod:NewPhaseAnnounce(2)
local warnPhase3				= mod:NewPhaseAnnounce(3)
local warningNovaCast			= mod:NewCastAnnounce(30852, 3)
local warningInfernalSoon		= mod:NewSoonAnnounce(37277, 2)
local warningInfernal			= mod:NewSpellAnnounce(37277, 3)
local warningEnfeeble			= mod:NewTargetAnnounce(30843, 4)
local warningAmpMagic			= mod:NewTargetAnnounce(39095, 3)
local warningSWP				= mod:NewTargetAnnounce(30898, 2, nil, false)

local specWarnEnfeeble			= mod:NewSpecialWarningYou(37277)
local specWarnNova				= mod:NewSpecialWarningRun(30852, mod:IsMelee())

local timerNovaCast				= mod:NewNextTimer(2, 30852)
local timerNextInfernal			= mod:NewNextTimer(45, 37277)
local timerEnfeeble				= mod:NewBuffActiveTimer(8, 30843)

local phase	= 0
local enfeebleTargets = {}
local firstInfernal = false

local function showEnfeebleWarning()
	warningEnfeeble:Show(table.concat(enfeebleTargets, "<, >"))
	table.wipe(enfeebleTargets)
end

function mod:OnCombatStart(delay)
	phase = 1
	timerNextInfernal:Start(40-delay)
	table.wipe(enfeebleTargets)
	firstInfernal = false
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(30852) then
		warningNovaCast:Show()
		timerNovaCast:Start()
		specWarnNova:Show()
	end
end

function mod:Infernals()
	warningInfernal:Show()
	if Phase == 3 then
		timerNextInfernal:Start(22.5)
	else		
		timerNextInfernal:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(30854, 30898) then
		warningSWP:Show(args.destName)
	elseif args:IsSpellID(39095) then
		warningAmpMagic:Show(args.destName)
	elseif args:IsSpellID(30843) then
		enfeebleTargets[#enfeebleTargets + 1] = args.destName
		timerEnfeeble:Start()
		if args:IsPlayer() then
			specWarnEnfeeble:Show()
		end
		self:Unschedule(showEnfeebleWarning)
		self:Schedule(0.3, showEnfeebleWarning)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_PRINCE_YELL_INF1 or msg == L.DBM_PRINCE_YELL_INF2 then
		warningInfernalSoon:Schedule(11.5)
		self:ScheduleMethod(18.5, "Infernals")--Infernal actually spawns 18.5sec after yell.
		if not firstInfernal then
			timerNextInfernal:Start(18.5)
			firstInfernal = true
		end
		if Phase == 3 then
			timerNextInfernal:Update(3.5, 22.5)--we attempt to update bars to show 18.5sec left. this will more than likely error out, it's not tested.
		else		
			timerNextInfernal:Update(26.5, 45)--we attempt to update bars to show 18.5sec left. this will more than likely error out, it's not tested.
		end
	elseif msg == L.DBM_PRINCE_YELL_P3 then
		phase = 3
		warnPhase3:Show()
	elseif msg == L.DBM_PRINCE_YELL_P2 then
		warnPhase2:Show()
	end
end
