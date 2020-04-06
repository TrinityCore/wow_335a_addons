function psficccouncilnoobs(nname)
if UnitInRaid(nname) then
addtotwotables(nname)
vezaxsort1()
end
end

function psicccouncilkilled1()
psiccsharon=nil
if #vezaxname>1 and psicgalochki[9][1]==1 and psicgalochki[9][3]==1 then
local pstempzap="{rt8} "..psiccfailtxt83
if psiccschet>0 and psiccschet2>0 then
local pstmtp=0
pstmtp=(psiccschet2-psiccschet)-3
pstmtp=math.ceil(pstmtp*10)/10
if pstmtp>1 and pstmtp<30 then
pstempzap=pstempzap.." ("..pstmtp.." "..pssec..")"
end
end

pstempzap=pstempzap..":"
pszapuskanonsa(whererepiccchat[psicchatchoose[9][3]], pstempzap)
strochkavezcrash=""
reportafterboitwotab(whererepiccchat[psicchatchoose[9][3]], false, vezaxname, vezaxcrash, 1, 10)
end
table.wipe(vezaxname)
table.wipe(vezaxcrash)
end

function psicccouncilrezet()
psiccsharon=nil
table.wipe(vezaxname)
table.wipe(vezaxcrash)
psiccschet=0
psiccschet2=0
end


function psficcsovetdose1()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornosovet=1

local bililine=0
for i,getcrash in ipairs(vezaxname3) do 
if getcrash == arg7 then
bililine=1
	if arg13>vezaxcrash3[i] then
	vezaxcrash3[i]=arg13
	end
end end
if(bililine==0)then
table.insert(vezaxname3,arg7) 
table.insert(vezaxcrash3,arg13) 
end

vezaxsort3()
end
end
end
end


function psficcsovetnoobaoe()
if psbossblock==nil then

psunitisplayer(arg6,arg7)
if psunitplayertrue then

psunitisplayer(arg3,arg4)
if psunitplayertrue then


pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornosovet=1
addtotwotables2(arg7)
vezaxsort2()
end
end
end
end
end



function psficcsovetdose11(im,kol)
if psiccsinddebuf1==nil then psiccsinddebuf1={} end
if psiccsinddebuf2==nil then psiccsinddebuf2={} end
local bililinet=0
for i=1,#psiccsinddebuf1 do
	if psiccsinddebuf1[i]==im then
		bililinet=1
		psiccsinddebuf2[i]=kol
	end
end

if bililinet==0 then
table.insert(psiccsinddebuf1, im)
table.insert(psiccsinddebuf2, kol)
end
end

function psiccsovetdose2()
local psstringa=""
if UnitSex(arg7) and UnitSex(arg7)==3 then
psstringa="{rt8} "..arg7.." "..psiccfailtxt11511fem.." \124cff71d5ff\124Hspell:"..arg9.."\124h["..arg10.."]\124h\124r , "
else
psstringa="{rt8} "..arg7.." "..psiccfailtxt11511.." \124cff71d5ff\124Hspell:"..arg9.."\124h["..arg10.."]\124h\124r , "
end

for i=1,#psiccsinddebuf1 do
	if psiccsinddebuf1[i]==arg4 then
		psstringa=psstringa..psicchehas22..": "..psiccsinddebuf2[i].." > "..(arg12-arg13).." ("..psiccoverdmg..": "..arg13..")"
if(psicgalochki[9][5]==1 and psicgalochki[9][5]==1)then
		pszapuskanonsa(whererepiccchat[psicchatchoose[9][5]], psstringa)
end
	end
end
end



function psficcsovetafterf()
if(psicgalochki[9][1]==1 and psicgalochki[9][4]==1)then
strochkavezcrash="{rt1} "..psiccfailtxt844
reportafterboitwotab(whererepiccchat[psicchatchoose[9][4]], true, vezaxname3, vezaxcrash3, 1, 7)
end
if(psicgalochki[9][1]==1 and psicgalochki[9][6]==1)then
strochkavezcrash="{rt7} "..psiccbossfail85f
reportafterboitwotab(whererepiccchat[psicchatchoose[9][6]], true, vezaxname2, vezaxcrash2, 1, 7)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then
psicclastsaverep=GetTime()
psiccsavinginf(psiccbloodprince)
strochkavezcrash="{rt1} "..psiccfailtxt844
reportafterboitwotab(whererepiccchat[psicchatchoose[9][4]], true, vezaxname3, vezaxcrash3, nil, 15,0,1)
strochkavezcrash="{rt7} "..psiccbossfail85f
reportafterboitwotab(whererepiccchat[psicchatchoose[9][6]], true, vezaxname2, vezaxcrash2, nil, 15,0,1)

psiccrefsvin()
end

end


function psficcsovetresetall()
wasornosovet=nil
timetocheck=0
iccsovetboyinterr=nil
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
psiccsinddebuf1=nil
psiccsinddebuf2=nil
end