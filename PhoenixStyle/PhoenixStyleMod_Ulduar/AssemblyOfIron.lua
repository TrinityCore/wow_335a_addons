function psfsovetdis()
if arg2 == "SPELL_AURA_APPLIED" then
timebuff2=0
timebuff3=0
whodispeled1="0"
timerez1=0
timebuff1=arg1
ifthiswassovet=1
fromwhodispeled="0"
else end

if arg2 == "SPELL_DISPEL" then
whodispeled1=arg4
else end

if arg2 == "SPELL_AURA_REMOVED" then
timebuff2=arg1
timebuff3=timebuff2+0.5
timerez1=timebuff2-timebuff1
timerez1=math.ceil(timerez1*1000)/1000
fromwhodispeled=arg7
end end

function psfsovettimeaft()
if(bosspartul[3]==1) then
if whodispeled1=="0" then
pszapuskanonsa(whererepbossulda[3], "{rt7} '"..psulsovetbuff.."' "..psulsovetfrom.." "..fromwhodispeled.." "..psulsovetnotd.." "..timerez1.." "..pssec)
else
if(timerez1>1)then
pszapuskanonsa(whererepbossulda[3], "{rt8} "..whodispeled1.." "..psulsovetsnyal.." '"..psulsovetbuff.."' "..psulsovetfrom.." "..fromwhodispeled.." "..psulsovetin.." "..timerez1.." "..pssec)
else
if (bosspartul2[2]==1) then
pszapuskanonsa(whererepbossulda[3], "{rt6} "..whodispeled1.." "..psulsovetsnyal.." '"..psulsovetbuff.."' "..psulsovetfrom.." "..fromwhodispeled.." "..psulsovetin.." "..timerez1.." "..pssec)
end
end
end
end
timebuff2=0
timebuff3=0
whodispeled1="0"
fromwhodispeled="0"
end