function psficcvalytrianoobs1()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornovalytria=1
addtotwotables(arg7)
vezaxsort1()
end
end
end
end

function psficcvalytrianoobs2()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornovalytria=1
addtotwotables2(arg7)
vezaxsort2()
end
end
end
end

function psficcvalytrianoobs3()
if psbossblock==nil then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
addtotwotables3(arg4)
vezaxsort3()
end
end
end


function psiccvalitriapristnoob()

local bililine=0
for i,getcrash in ipairs(psiccvalitrifailspirit1) do 
if getcrash == arg4 then
local pstimelocal=math.ceil((10-(psiccschet2-psiccschet))*10)/10
pstimelocal=math.ceil((psiccvalitrifailspirit2[i]+pstimelocal)*10)/10
psiccvalitrifailspirit2[i]=pstimelocal bililine=1
end end
if(bililine==0)then
table.insert(psiccvalitrifailspirit1,arg4)
local pstimelocal=math.ceil((10-(psiccschet2-psiccschet))*10)/10
table.insert(psiccvalitrifailspirit2,pstimelocal) 
end

local vzxnn= # psiccvalitrifailspirit1
while vzxnn>1 do
if psiccvalitrifailspirit2[vzxnn]>psiccvalitrifailspirit2[vzxnn-1] then
local vezaxtemp1=psiccvalitrifailspirit2[vzxnn-1]
local vezaxtemp2=psiccvalitrifailspirit1[vzxnn-1]
psiccvalitrifailspirit2[vzxnn-1]=psiccvalitrifailspirit2[vzxnn]
psiccvalitrifailspirit1[vzxnn-1]=psiccvalitrifailspirit1[vzxnn]
psiccvalitrifailspirit2[vzxnn]=vezaxtemp1
psiccvalitrifailspirit1[vzxnn]=vezaxtemp2
end
vzxnn=vzxnn-1
end

end


function psvalytrihealcount()
if psbossblock==nil and arg12 and arg4 then
addtotwodamagetables3(arg4, arg12)
psdamagetwotablsort3()
end
end


function psficcvalytriaafterf()
if(psicgalochki[11][1]==1 and psicgalochki[11][2]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt101
reportafterboitwotab(whererepiccchat[psicchatchoose[11][2]], true, vezaxname, vezaxcrash, 1, 7)
end

if(psicgalochki[11][1]==1 and psicgalochki[11][3]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt102
reportafterboitwotab(whererepiccchat[psicchatchoose[11][3]], true, vezaxname2, vezaxcrash2, 1, 7)
end

if(psicgalochki[11][1]==1 and psicgalochki[11][4]==1 and psiccvalpriest)then
strochkavezcrash="{rt1} "..psiccfailtxt103
reportafterboitwotab(whererepiccchat[psicchatchoose[11][4]], true, vezaxname3, vezaxcrash3, 1, 7)
end

if(psicgalochki[11][1]==1 and psicgalochki[11][4]==1 and psiccvalpriest)then
strochkavezcrash="{rt8} "..psiccfailtxt1032
reportafterboitwotab(whererepiccchat[psicchatchoose[11][4]], true, psiccvalitrifailspirit1, psiccvalitrifailspirit2, 1, 7)
end

if(psicgalochki[11][1]==1 and psicgalochki[11][6]==1)then
strochkadamageout="{rt5} "..psiccbossfail105t
reportfromtwodamagetables3(whererepiccchat[psicchatchoose[11][6]], true, 7)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then

psicclastsaverep=GetTime()
psiccsavinginf(psiccvalithria)
strochkavezcrash="{rt7} "..psiccfailtxt101
reportafterboitwotab(whererepiccchat[psicchatchoose[11][2]], true, vezaxname, vezaxcrash, nil, 15,0,1)
strochkavezcrash="{rt7} "..psiccfailtxt102
reportafterboitwotab(whererepiccchat[psicchatchoose[11][3]], true, vezaxname2, vezaxcrash2, nil, 15,0,1)
strochkavezcrash="{rt1} "..psiccfailtxt103
reportafterboitwotab(whererepiccchat[psicchatchoose[11][4]], true, vezaxname3, vezaxcrash3, nil, 15,0,1)
if psiccvalpriest then
strochkavezcrash="{rt8} "..psiccfailtxt1032
reportafterboitwotab(whererepiccchat[psicchatchoose[11][4]], true, psiccvalitrifailspirit1, psiccvalitrifailspirit2, 1, 7,0,1)
strochkadamageout="{rt5} "..psiccbossfail105t
reportfromtwodamagetables3(whererepiccchat[psicchatchoose[11][6]], true, 10,0,1)
end

psiccrefsvin()
end



end


function psficcvalytriaresetall()
wasornovalytria=nil
iccvalytriaboyinterr=nil
timetocheck=0
psiccvalpriest=nil
table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
if psdamagename3 then
table.wipe(psdamagename3)
end
if psdamagevalue3 then
table.wipe(psdamagevalue3)
end
psiccvalitrifailspirit1=nil
psiccvalitrifailspirit2=nil
psiccschet=0
psiccschet2=0
psiccschet3=0
end