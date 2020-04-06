function psficcrotfacenoobs1()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornorotface=1
addtotwotables(arg7)
vezaxsort1()
end
end
end
end

function psficcrotfacenoobs2()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornorotface=1
addtotwotables2(arg7)
vezaxsort2()
end
end
end
end


function psficcrotfaceafterf()
if(psicgalochki[7][1]==1 and psicgalochki[7][2]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt61
reportafterboitwotab(whererepiccchat[psicchatchoose[7][2]], true, vezaxname, vezaxcrash, 1, 7)
end

if(psicgalochki[7][1]==1 and psicgalochki[7][3]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt62
reportafterboitwotab(whererepiccchat[psicchatchoose[7][3]], true, vezaxname2, vezaxcrash2, 1, 7)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then

psicclastsaverep=GetTime()
psiccsavinginf(psiccrotface)
strochkavezcrash="{rt7} "..psiccfailtxt61
reportafterboitwotab(whererepiccchat[psicchatchoose[7][2]], true, vezaxname, vezaxcrash, nil, 15,0,1)
strochkavezcrash="{rt7} "..psiccfailtxt62
reportafterboitwotab(whererepiccchat[psicchatchoose[7][3]], true, vezaxname2, vezaxcrash2, nil, 15,0,1)

psiccrefsvin()
end

end


function psficcrotfaceresetall()
wasornorotface=nil
timetocheck=0
iccrotfaceboyinterr=nil
table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
end