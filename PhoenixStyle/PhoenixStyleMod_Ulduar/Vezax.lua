function psfvezaxheal()
if arg2 == "SPELL_AURA_APPLIED" then
metkaonwho = arg7
wasornovezax=1
sumheal=0
end

if arg2 == "SPELL_HEAL" then
sumheal = sumheal+arg12
if(arg12 > 60000) then
wasdebuffgena="{rt1} "..psulvezax1
wasdebufgena=true
end
end


if arg2 == "SPELL_AURA_REMOVED" then
timehealvez=arg1
timehealvez=timehealvez+3
end
end


function psfvezaxreportheal()
if(thisaddononoff and bosspartul[1]==1 and bosspartul2[1]==1) then

vezaxobrezanie(sumheal)

pszapuskanonsa(whererepbossulda[1], "{rt7}"..metkaonwho.." "..psulvezax2.." "..psveztempheal.." "..psulhp..". "..wasdebuffgena.."")
end


if (sumheal>topvezaxheal3) then
topvezaxheal3=sumheal
topvezaxname3=metkaonwho

if(wasdebufgena) then topvezaxdeb3=psulvezax3 else topvezaxdeb3="" end
if (topvezaxheal3>topvezaxheal2) then
local topchange2=topvezaxheal2
local topchange3=topvezaxdeb2
local topchange=topvezaxname2
topvezaxheal2=topvezaxheal3
topvezaxname2=topvezaxname3
topvezaxdeb2=topvezaxdeb3
topvezaxheal3=topchange2
topvezaxname3=topchange
topvezaxdeb3=topchange3

if (topvezaxheal2>topvezaxheal1) then 
local topchange2=topvezaxheal1
local topchange=topvezaxname1
local topchange3=topvezaxdeb1
topvezaxheal1=topvezaxheal2
topvezaxname1=topvezaxname2
topvezaxdeb1=topvezaxdeb2
topvezaxheal2=topchange2
topvezaxname2=topchange
topvezaxdeb2=topchange3
end
end
end
timehealvez=0
sumheal = 0
metkaonwho = ""
wasdebufgena=false
wasdebuffgena=""
end

function psfvezaxcrash()
	if arg4 == psulgeneralvezax then 
psunitisplayer(arg6,arg7)
if psunitplayertrue then
wasornovezax=1
addtotwotables(arg7)
vezaxsort1()



if(bosspartul[1]==1 and bosspartul2[1]==1) then
spelllink = "\124cff71d5ff\124Hspell:"..arg9.."\124h["..arg10.."]\124h\124r"
pszapuskanonsa(whererepbossulda[1], "{rt8}"..arg7.." "..psulvezax4.." "..spelllink.." > "..arg12.." "..psulhp..".")
end
end
end
end


function psfvezaxafterf()
if(thisaddononoff and bosspartul[1]==1) then
if (topvezaxheal1>0) then

vezaxobrezanie(topvezaxheal1)

pszapuskanonsa(whererepbossulda[1], "{rt6}"..psulvezax5, true)
pszapuskanonsa(whererepbossulda[1], "1. "..topvezaxname1.." - "..psveztempheal.." "..psulhp..". "..topvezaxdeb1.."", true)

if (topvezaxheal2>0) then
vezaxobrezanie(topvezaxheal2)

pszapuskanonsa(whererepbossulda[1], "2. "..topvezaxname2.." - "..psveztempheal.." "..psulhp..". "..topvezaxdeb2.."", true)

if (topvezaxheal3>0) then
vezaxobrezanie(topvezaxheal3)
pszapuskanonsa(whererepbossulda[1], "3. "..topvezaxname3.." - "..psveztempheal.." "..psulhp..". "..topvezaxdeb3.."", true)
end end
end

strochkavezcrash="{rt8}"..psulvezax6

reportafterboitwotab(whererepbossulda[1], true, vezaxname, vezaxcrash)

end
end

function psfvezaxrezetall()
wasornovezax=0
timetocheck=0
	sumheal=0
	topvezaxname1="text"
	topvezaxname2="text"
	topvezaxname3="text"
	topvezaxheal1=0
	topvezaxheal2=0
	topvezaxheal3=0
	metkaonwho = "text"
	timehealvez=0
vezaxboyinterr=0
table.wipe(vezaxname)
table.wipe(vezaxcrash)
end

function vezaxobrezanie(chtoobrez)
pshealstring=""
pshealstring=chtoobrez
psveztempheal=""
	if string.len(pshealstring) > 3 then
	psveztempheal=string.sub(pshealstring, 1, string.len(pshealstring)-3) psveztempheal=psveztempheal.."k"
	else
	psveztempheal=pshealstring
	end

end