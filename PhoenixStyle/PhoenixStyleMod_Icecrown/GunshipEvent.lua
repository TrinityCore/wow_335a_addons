function psficcgunshipnoobs()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornogunship=1
addtotwotables(arg7)
vezaxsort1()
end
end
end
end


function psficcgunshipafterf()
if(psicgalochki[4][1]==1 and psicgalochki[4][2]==1)then
strochkavezcrash="{rt7} "..psiccgunshipfail1
reportafterboitwotab(whererepiccchat[psicchatchoose[4][2]], true, vezaxname, vezaxcrash, 1, 6)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then

psicclastsaverep=GetTime()
psiccsavinginf(psiccgunshipevent)
strochkavezcrash="{rt7} "..psiccgunshipfail1
reportafterboitwotab(whererepiccchat[psicchatchoose[4][2]], true, vezaxname, vezaxcrash, nil, 20,0,1)
psiccrefsvin()

end

end


function psficcgunshipresetall()
wasornogunship=nil
timetocheck=0
iccgunshipboyinterr=nil
table.wipe(vezaxname)
table.wipe(vezaxcrash)
end