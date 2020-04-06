function psfmimidetectnoob()
if arg2 == "SPELL_AURA_APPLIED" then
psunitisplayer(arg6,arg7)
if psunitplayertrue then

timelastnapalm=arg1
if(ifwasnapalm1==0)then
timenapalm2=timelastnapalm+1.1
ifwasnapalm1=1
end
table.insert(napalmnumnoobs,arg7)
end
end

if arg2 == "SPELL_AURA_REMOVED" then
	SetRaidTarget(arg7, 0)
end end

function psfmimireportnoob()
if(thisaddononoff and bosspartul[2]==1) then

mimiskokanubov= # napalmnumnoobs
if mimiskokanubov==1 then
SetRaidTarget(napalmnumnoobs[1], 7)
elseif mimiskokanubov==2 then
SetRaidTarget(napalmnumnoobs[1], 7)
SetRaidTarget(napalmnumnoobs[2], 1)
pszapuskanonsa(whererepbossulda[2], "{rt8}"..psulnapalmgot.." "..mimiskokanubov..": {rt7}"..napalmnumnoobs[1]..", {rt1}"..napalmnumnoobs[2]..".")
elseif mimiskokanubov>2 then
SetRaidTarget(napalmnumnoobs[1], 7)
SetRaidTarget(napalmnumnoobs[2], 1)
SetRaidTarget(napalmnumnoobs[3], 2)
mimispisokot4 = ", "
if napalmnumnoobs[4]==nil then
mimispisokot4 = "."
mimispisokot4 = mimispisokot4..table.concat(napalmnumnoobs, ", ", 4)
end
pszapuskanonsa(whererepbossulda[2], "{rt8}"..psulnapalmgot.." "..mimiskokanubov..": {rt7}"..napalmnumnoobs[1]..", {rt1}"..napalmnumnoobs[2]..", {rt2}"..napalmnumnoobs[3]..mimispisokot4)
end
end

ifwasnapalm1=0
timenapalm2=0
timelastnapalm=0
table.wipe(napalmnumnoobs)
end