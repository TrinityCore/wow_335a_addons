function psficcfestergutnoobs1()
if psbossblock==nil then

psunitisplayer(arg6,arg7)
if psunitplayertrue then

psunitisplayer(arg3,arg4)
if psunitplayertrue then

pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornofestergut=1
addtotwotables3(arg7)
vezaxsort3()
addtotwotables3(arg4)
vezaxsort3()
end
end
end
end
end


function psficcfestergoo1()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornofestergut=1
addtotwotables4(arg7)
vezaxsort4()
if(psicgalochki[6][1]==1 and psicgalochki[6][7]==1)then
if UnitSex(arg7) and UnitSex(arg7)==3 then
pszapuskanonsa(whererepiccchat[psicchatchoose[6][7]], "{rt8} "..arg7.." - "..psiccbossfailtext76fem)
else
pszapuskanonsa(whererepiccchat[psicchatchoose[6][7]], "{rt8} "..arg7.." - "..psiccbossfailtext76)
end
end
end
end
end
end


function psficcfestergutnoobs2()
if psbossblock==nil then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornofestergut=1
psiccschet=psiccschet+1
end
end
end

function psficcfestergutnoobs3()
if psbossblock==nil then
	if psiccschet>0 then
	psiccschet=psiccschet-1
	else
	psiccschet2=psiccschet2+1
	end
end
end


function psficcfestergutnoobs4()
psiccschet3=psiccschet3+1
if psiccschet3==3 then
psiccfastertimer=GetTime()+19
psiccschet3=0
end
end


function psficcfestergutafterf()
if(psicgalochki[6][1]==1 and psicgalochki[6][3]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt52
reportafterboitwotab(whererepiccchat[psicchatchoose[6][3]], true, vezaxname3, vezaxcrash3, 1, 7)
end

if(psicgalochki[6][1]==1 and psicgalochki[6][2]==1)then
pszapuskanonsa(whererepiccchat[psicchatchoose[6][2]], "{rt7} "..psiccfailtxt51..psiccschet2, true)
end

if(psicgalochki[6][1]==1 and psicgalochki[6][6]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt71
reportafterboitwotab(whererepiccchat[psicchatchoose[6][6]], true, vezaxname4, vezaxcrash4, 1, 7)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then
if psiccfestertrig then

psicclastsaverep=GetTime()
psiccsavinginf(psiccfestergut)

pszapuskanonsa(whererepiccchat[psicchatchoose[6][2]], "{rt7} "..psiccfailtxt51..psiccschet2, true,nil,0,1)


strochkavezcrash="{rt7} "..psiccfailtxt52
reportafterboitwotab(whererepiccchat[psicchatchoose[6][3]], true, vezaxname3, vezaxcrash3, nil, 15,0,1)

strochkavezcrash="{rt7} "..psiccfailtxt71
reportafterboitwotab(whererepiccchat[psicchatchoose[6][6]], true, vezaxname4, vezaxcrash4, nil, 20,0,1)

psiccrefsvin()
end
end

end


function psficcfestergutresetall()
wasornofestergut=nil
timetocheck=0
iccfestergutboyinterr=nil
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)
psiccschet2=0
psiccschet=0
psiccschet3=0
psiccfastertimer=nil
end


function psiccfestergutaoealarm()
psiccfastertimer=nil

local psgropcheck=2
local psdebname=GetSpellInfo(72103)
local psdebname2=GetSpellInfo(69290)
local pstabl1={}
local pstabl2={}
local pstabl3={}

if GetRaidDifficulty()==2 or GetRaidDifficulty()==4 then
psgropcheck=5
end
local inst="normal"
local _, _, _, _, _, dif = GetInstanceInfo()
if dif and dif==1 then
inst="heroic"
end

--4 вкл и норм инст, или 4 вкл, 5 откл, и героик инст
if psicgalochki[6][1]==1 and psicgalochki[6][4]==1 and (inst=="normal" or (psicgalochki[6][5]==0 and inst=="heroic")) then

for i = 1,GetNumRaidMembers() do local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
	if (subgroup <= psgropcheck and online and isDead==nil and UnitIsDeadOrGhost(name)==nil) then
		local _, _, _, stack = UnitDebuff(name, psdebname)
			if stack==nil then stack=0 end
		if UnitDebuff(name, psdebname2) then
		stack=stack+1
		end

		if stack==0 then
		table.insert(pstabl1,name)
		elseif stack==1 then
		table.insert(pstabl2,name)
		end
	end
end

local pstxttmp="{rt8} "..psiccfailtxt53

if #pstabl1>0 then
for i=1,#pstabl1 do
pstxttmp=pstxttmp..pstabl1[i].." (0), "
end
end

if #pstabl2>0 then
for i=1,#pstabl2 do
	if i==#pstabl2 then
pstxttmp=pstxttmp..pstabl2[i].." (1)."
	else
pstxttmp=pstxttmp..pstabl2[i].." (1), "
	end
end
end

if #pstabl1>0 or #pstabl2>0 then
pszapuskanonsa(whererepiccchat[psicchatchoose[6][4]], pstxttmp)
end

elseif psicgalochki[6][1]==1 and psicgalochki[6][5]==1 and inst=="heroic" then
--hard


for i = 1,GetNumRaidMembers() do local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
	if (subgroup <= psgropcheck and online and isDead==nil and UnitIsDeadOrGhost(name)==nil) then
		local _, _, _, stack = UnitDebuff(name, psdebname)
			if stack==nil then stack=0 end
		if UnitDebuff(name, psdebname2) then
		stack=stack+1
		end

		if stack==0 then
		table.insert(pstabl1,name)
		elseif stack==1 then
		table.insert(pstabl2,name)
		elseif stack==2 then
		table.insert(pstabl3,name)
		end
	end
end

--local pstxttmp="{rt8} "..psiccfailtxt53
if #pstabl1>0 or #pstabl2>0 or #pstabl3>0 then
pszapuskanonsa(whererepiccchat[psicchatchoose[6][5]],"{rt8} "..psiccfailtxt53)
end

if #pstabl1>0 then
local pstxttmp="0: "
for i=1,#pstabl1 do
	if #pstabl1==i then
pstxttmp=pstxttmp..pstabl1[i].."."
	else
pstxttmp=pstxttmp..pstabl1[i]..", "
	end
end
pszapuskanonsa(whererepiccchat[psicchatchoose[6][5]], pstxttmp)
end

if #pstabl2>0 then
local pstxttmp="1: "
for i=1,#pstabl2 do
	if #pstabl2==i then
pstxttmp=pstxttmp..pstabl2[i].."."
	else
pstxttmp=pstxttmp..pstabl2[i]..", "
	end
end
pszapuskanonsa(whererepiccchat[psicchatchoose[6][5]], pstxttmp)
end

if #pstabl3>0 then
local pstxttmp="2: "
for i=1,#pstabl3 do
	if i==#pstabl3 then
pstxttmp=pstxttmp..pstabl3[i].."."
	else
pstxttmp=pstxttmp..pstabl3[i]..", "
	end
end
pszapuskanonsa(whererepiccchat[psicchatchoose[6][5]], pstxttmp)
end

--if #pstabl1>0 or #pstabl2>0 or #pstabl3>0 then
--pszapuskanonsa(whererepiccchat[psicchatchoose[6][5]], pstxttmp)
--end


end


end