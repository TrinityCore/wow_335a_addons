function psficcladynoobs()
if psbossblock==nil then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
pscheckwipe1(4,9)
if pswipetrue then
psiccwipereport()
else
wasornoladydeath=1
addtotwotables(arg4)
vezaxsort1()
end
end
end
end

function psficcladynoobs3()
if psbossblock==nil then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
pscheckwipe1(4,9)
if pswipetrue then
psiccwipereport()
else
wasornoladydeath=1
addtotwotables3(arg4)
vezaxsort3()
end
end
end
end

function psiccladydeathghostcheck(pstm, psnm,ttt,classch)
if psiccldghostdmgname then
if classch then

local _, classhunt = UnitClass(psnm)

if classhunt and classhunt=="HUNTER" then

if psicchunterdiedelay==nil then
psicchunterdiedelay=GetTime()+3
psicchunterdiedelaytable={psnm}
psicchunterdiedelayboss=1
psicchunterdiedelayarg1=pstm+3
else
psicchunterdiedelay=GetTime()+3
table.insert(psicchunterdiedelaytable,psnm)
psicchunterdiedelayarg1=pstm+3
end

else
psiccladydeathghostcheck(pstm, psnm,ttt)
end


else

local pstableid={}
local pstablename={}

for i=1,#psiccldghostdmgname do
	if psiccldghostdmgname[i]==psnm then
		if pstm-psiccldghostdmgtime[i]<ttt then
			table.insert(pstableid,psiccldghostdmgid[i])
		end
	end
end

if #pstableid>0 then
for i=1,#pstableid do
	local j=1
	while j<=#psiccldghosttrigid do
		if psiccldghosttrigid[j]==pstableid[i] then
			table.insert(pstablename,psiccldghosttrigname[j])
			j=1000
		end
		if j==#psiccldghosttrigid and pstablename[i]==nil then
			pstablename[i]=psiccunknown
		end
	j=j+1
	end
end

local psstringa=""

if GetTime()-psiccschet2<3 then
psiccschet3=psiccschet3+1
else
psiccschet3=0
end
psiccschet2=GetTime()

	if psiccschet3<=4 then
if #pstableid==1 then
if UnitSex(pstablename[1]) and UnitSex(pstablename[1])==3 then
if UnitSex(psnm) and UnitSex(psnm)==3 then
psstringa="{rt8} "..psnm.." "..psiccfailtxt11511fem.." 1 "..psiccldfail261fem..pstablename[1]
else
psstringa="{rt8} "..psnm.." "..psiccfailtxt11511.." 1 "..psiccldfail261fem..pstablename[1]
end
else
psstringa="{rt8} "..psnm.." "..psiccfailtxt11511.." 1 "..psiccldfail261..pstablename[1]
end
else
if UnitSex(psnm) and UnitSex(psnm)==3 then
psstringa="{rt8} "..psnm.." "..psiccfailtxt11511fem.." "..#pstableid.." "..psiccldfail262
else
psstringa="{rt8} "..psnm.." "..psiccfailtxt11511.." "..#pstableid.." "..psiccldfail262
end
	for i=1,#pstablename do
		psstringa=psstringa..pstablename[i]
		if i==#pstablename then
			psstringa=psstringa.."."
		else
			psstringa=psstringa..", "
		end
	end
end


if(psicgalochki[3][1]==1 and psicgalochki[3][7]==1) then
pszapuskanonsa(whererepiccchat[psicchatchoose[3][7]], psstringa)
end

end
	end
end
end
end

function psiccldwsomeonedie(im)

if psiccldwtable1 and #psiccldwtable1>0 then
psdamagename3=nil
psdamagevalue3=nil

for i=1,#psiccldwtable3 do
	if psiccldwtable3[i]==im then
		if GetTime()-psiccldwtable1[i]<15 then
			addtotwodamagetables3(psiccldwtable2[i], psiccldwtable4[i])
			psdamagetwotablsort3()
		end
	end
end

if psicgalochki[3][1]==1 and psicgalochki[3][4]==1 and psdamagename3 and #psdamagename3>0 then
if UnitSex(im) and UnitSex(im)==3 then
strochkadamageout="{rt8}"..im.." "..psiccladyfail3fem
else
strochkadamageout="{rt8}"..im.." "..psiccladyfail3
end
reportfromtwodamagetables3(whererepiccchat[psicchatchoose[3][4]], nil, 5)
end
psdamagename3=nil
psdamagevalue3=nil


end
end


function psficcladydeathafterf()
if(psicgalochki[3][1]==1 and psicgalochki[3][2]==1)then
strochkavezcrash="{rt3} "..psiccladyfail1
reportafterboitwotab(whererepiccchat[psicchatchoose[3][2]], true, vezaxname, vezaxcrash, 1, 7)
end


if(psicgalochki[3][1]==1 and psicgalochki[3][9]==1)then
strochkavezcrash="{rt3} "..psiccladyfail14
reportafterboitwotab(whererepiccchat[psicchatchoose[3][9]], true, vezaxname3, vezaxcrash3, 1, 7)
end

if(psicgalochki[3][1]==1 and psicgalochki[3][3]==1 and psdamagename2 and #psdamagename2>0)then
strochkadamageout="{rt4} "..psiccladyfail2
reportfromtwodamagetables(whererepiccchat[psicchatchoose[3][3]],1,nil,8,true)
end

if(psicgalochki[3][1]==1 and psicgalochki[3][5]==1 and psiccldghostdmgname and #psiccldghostdmgname>0) then
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
for i=1,#psiccldghostdmgname do
addtotwotables2(psiccldghostdmgname[i])
vezaxsort2()
end
strochkavezcrash="{rt7} "..psiccldfail24
reportafterboitwotab(whererepiccchat[psicchatchoose[3][5]], true, vezaxname2, vezaxcrash2, 1, 7)
end

if(psicgalochki[3][1]==1 and psicgalochki[3][6]==1 and psiccldghosttrigname and #psiccldghosttrigname>0) then
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
for i=1,#psiccldghosttrigname do
addtotwotables2(psiccldghosttrigname[i])
vezaxsort2()
end
strochkavezcrash="{rt1} "..psiccldfail25
reportafterboitwotab(whererepiccchat[psicchatchoose[3][6]], true, vezaxname2, vezaxcrash2, 1, 10)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then


psicclastsaverep=GetTime()
psiccsavinginf(psiccdeathwhisper)

strochkavezcrash="{rt3} "..psiccladyfail1
reportafterboitwotab(whererepiccchat[psicchatchoose[3][2]], true, vezaxname, vezaxcrash, 1, 10,0,1)

strochkavezcrash="{rt3} "..psiccladyfail14
reportafterboitwotab(whererepiccchat[psicchatchoose[3][9]], true, vezaxname3, vezaxcrash3, 1, 10,0,1)

if psdamagename2 and #psdamagename2>0 then
strochkadamageout="{rt4} "..psiccladyfail2
reportfromtwodamagetables(whererepiccchat[psicchatchoose[3][3]],1,nil,10,true,0,1)
end

if psiccldghostdmgname and #psiccldghostdmgname>0 then

table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
for i=1,#psiccldghostdmgname do
addtotwotables2(psiccldghostdmgname[i])
vezaxsort2()
end
strochkavezcrash="{rt7} "..psiccldfail24
reportafterboitwotab(whererepiccchat[psicchatchoose[3][5]], true, vezaxname2, vezaxcrash2, 1, 15,0,1)


table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
for i=1,#psiccldghosttrigname do
addtotwotables2(psiccldghosttrigname[i])
vezaxsort2()
end
strochkavezcrash="{rt1} "..psiccldfail25
reportafterboitwotab(whererepiccchat[psicchatchoose[3][6]], true, vezaxname2, vezaxcrash2, nil, 25,0,1)

end


psiccrefsvin()
end



end


function psficcladydeathresetall()
wasornoladydeath=nil
timetocheck=0
iccladydeathboyinterr=nil
table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
if psdamagename2 then
table.wipe(psdamagename2)
table.wipe(psdamagevalue2)
end
psiccraiderinmc=nil
psiccnickinmc=nil
psiccldwtable1=nil
psiccldwtable2=nil
psiccldwtable3=nil
psiccldwtable4=nil

if psiccschet4==1002 then
psiccschet4=1
psiccschet3=0
psiccschet2=0
table.wipe(psiccldghosttrigid)
table.wipe(psiccldghosttrigname)
table.wipe(psiccldghostdmgtime)
table.wipe(psiccldghostdmgid)
table.wipe(psiccldghostdmgname)
psiccladyghost=nil
psiccldghosttrigid=nil
psiccldghosttrigname=nil
psiccldghostdmgtime=nil
psiccldghostdmgid=nil
psiccldghostdmgname=nil
end

end