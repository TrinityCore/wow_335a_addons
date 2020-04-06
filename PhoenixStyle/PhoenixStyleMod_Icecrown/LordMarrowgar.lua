function psficclordmapp(idbone, bonetime)
if psbossblock==nil then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornolordm=1
if psicctablebones==nil then psicctablebones={} end
table.insert(psicctablebones, bonetime.."+"..idbone)
end
end
end



function psficclordmrem(idbone, bonetime, raidnick)
if psbossblock==nil and psicctablebones and #psicctablebones>0 then

local i=1
while i<=#psicctablebones do
	if string.sub(psicctablebones[i], string.find(psicctablebones[i], "+")+1)==idbone then
		if psiccbonetime==nil then psiccbonetime={1000,"0",0,"0"}
		end
		local bonekilled=bonetime-tonumber(string.sub(psicctablebones[i], 1, string.find(psicctablebones[i], "+")-1))
			if bonekilled<psiccbonetime[1] then
			psiccbonetime[1]=bonekilled
			psiccbonetime[2]=raidnick
			end
			if bonekilled>psiccbonetime[3] then
			psiccbonetime[3]=bonekilled
			psiccbonetime[4]=raidnick
			end
				if(psicgalochki[2][1]==1 and psicgalochki[2][3]==1)then
				bonekilled=math.ceil(bonekilled*10)/10
				local lolmark=7
					if bonekilled>=8 then lolmark=8 end
				pszapuskanonsa(whererepiccchat[psicchatchoose[2][3]], "{rt"..lolmark.."}"..psicclordann3..bonekilled.." "..pssec.." ("..raidnick..").")
				end
	table.remove(psicctablebones, i)
	i=90
	end
i=i+1
end
end
end


function psficclorlmafterf()
if(psicgalochki[2][1]==1 and psicgalochki[2][2]==1)then
if psiccbonetime then
psiccbonetime[1]=math.ceil(psiccbonetime[1]*10)/10
psiccbonetime[3]=math.ceil(psiccbonetime[3]*10)/10
pszapuskanonsa(whererepiccchat[psicchatchoose[2][2]], "{rt6}"..psicclordann1..psiccbonetime[1].." "..pssec.." ("..psiccbonetime[2].."), "..psicclordann2..psiccbonetime[3].." "..pssec.." ("..psiccbonetime[4]..").", 1)
end
end

if(psicgalochki[2][1]==1 and psicgalochki[2][4]==1)then
strochkavezcrash="{rt5} "..psicclordfail13
reportafterboitwotab(whererepiccchat[psicchatchoose[2][4]], true, vezaxname, vezaxcrash, 1, 5)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then
psicclastsaverep=GetTime()
psiccsavinginf(psicclordm)
if psiccbonetime then
pszapuskanonsa(whererepiccchat[psicchatchoose[2][2]], "{rt6}"..psicclordann1..psiccbonetime[1].." "..pssec.." ("..psiccbonetime[2].."), "..psicclordann2..psiccbonetime[3].." "..pssec.." ("..psiccbonetime[4]..").", 1,nil,0,1)
end
strochkavezcrash="{rt5} "..psicclordfail13
reportafterboitwotab(whererepiccchat[psicchatchoose[2][4]], true, vezaxname, vezaxcrash, nil, 15,0,1)


psiccrefsvin()
end


end


function psficclordmresetall()
wasornolordm=nil
timetocheck=0
icclordmboyinterr=nil
psicctablebones=nil
psiccbonetime=nil
table.wipe(vezaxname)
table.wipe(vezaxcrash)
end

--debuff check
function psficclordniibs(nname)
if psbossblock==nil then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
if UnitInRaid(nname) then
addtotwotables(nname)
vezaxsort1()
end
end
end
end