function psficclknoobs1()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornolk=1
if psiccdefspawn and psicclichdelfireon and arg7==psicclichdelfireon then
psiccdefspawn=nil
else
addtotwotables(arg7)
vezaxsort1()
end
end
end
end
end

function psficclknoobs2()
if psiccidofdefile and psiccidofdefile==arg3 then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
psiccschet2=psiccschet2+1


if psiccdefsecsarg and psiccdefsecsarg<=arg1 then
if psiccschet2<11 then
psiccdefsecsarg=arg1+0.75
psiccdefsecs=psiccdefsecs+1
end
end


	if (psiccdefsecsarg and psiccdefsecsarg>=arg1) then
		addtotwotables2(arg7)
		vezaxsort2()
	end
end
end
end


function psficclkafterf()

	if psiccschet3>4 then
if(psicgalochki[13][1]==1 and psicgalochki[13][2]==1)then
strochkavezcrash="{rt4} "..psiccfailtxt121
reportafterboitwotab(whererepiccchat[psicchatchoose[13][2]], true, vezaxname, vezaxcrash, 1, 7)
end
	end

if(psicgalochki[13][1]==1 and psicgalochki[13][6]==1)then
strochkadamageout="{rt5} "..psicclkdiedharv6
reportfromtwodamagetables3(whererepiccchat[psicchatchoose[13][6]], true, 6)
end

if(psicgalochki[13][1]==1 and psicgalochki[13][7]==1)then
if psiccschet4>0 then
pszapuskanonsa(whererepiccchat[psicchatchoose[13][7]], "{rt6}"..psicclkfailduh..psiccschet4..".", true)
end
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then
psicclastsaverep=GetTime()
psiccsavinginf(psicclichking)
strochkavezcrash="{rt4} "..psiccfailtxt121
reportafterboitwotab(whererepiccchat[psicchatchoose[13][2]], true, vezaxname, vezaxcrash, nil, 20,0,1)
strochkadamageout="{rt5} "..psicclkdiedharv6
reportfromtwodamagetables3(whererepiccchat[psicchatchoose[13][6]], true, 10,0,1)
if psiccschet4>0 then
pszapuskanonsa(whererepiccchat[psicchatchoose[13][7]], "{rt6}"..psicclkfailduh..psiccschet4..".", true,nil,0,1)
end
psiccrefsvin()
end


end


function psficclkresetall()
wasornolk=nil
icclkboyinterr=nil
timetocheck=0
table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(psdamagename3)
table.wipe(psdamagevalue3)
psiccschet4=0
end