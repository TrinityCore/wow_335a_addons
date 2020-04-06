function psficcsindranoobs1(nr,ttr)
if psbossblock==nil then

psunitisplayer(nr,ttr)
if psunitplayertrue then

pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornosindra=1
addtotwotables(ttr)
vezaxsort1()
end
end
end
end

--1 phase
function psficcsindrabufup(nr,nk)
if psbossblock==nil then
psunitisplayer(nr,nk)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornosindra=1
addtotridamagetables(nk,0,1)
end
end
end
end


function psficcsindrabufup2(nk4,nk7,nk12,nr1,nr2)
if psbossblock==nil and nk4~=nk7 then

psunitisplayer(nr1,nk7)
if psunitplayertrue then

psunitisplayer(nr2,nk4)
if psunitplayertrue then


pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornosindra=1
addtotridamagetables(nk4,nk12,0)
end
end
end
end
end

--3 phase
function psficcsindrabufupphase3(nr,nk)
if psbossblock==nil then
psunitisplayer(nr,nk)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornosindra=1
addtotridamagetablesphase3(nk,0,1)
end
end
end
end


function psficcsindrabufupphase32(nk4,nk7,nk12,nr1,nr2)
if psbossblock==nil and nk4~=nk7 then

psunitisplayer(nr1,nk7)
if psunitplayertrue then

psunitisplayer(nr2,nk4)
if psunitplayertrue then

pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornosindra=1
addtotridamagetablesphase3(nk4,nk12,0)
end
end
end
end
end

function addtotridamagetablesphase3(nicktoadd, damagetoadd, count)

if (psdamagenamep3==nil or psdamagenamep3=={}) then psdamagenamep3 = {} end
if (psdamagevaluep3==nil or psdamagevaluep3=={}) then psdamagevaluep3 = {} end
if (psdamagerazp3==nil or psdamagerazp3=={}) then psdamagerazp3 = {} end
local bililine=0
for i,getcrash in ipairs(psdamagenamep3) do 
if getcrash == nicktoadd then psdamagevaluep3[i]=psdamagevaluep3[i]+damagetoadd psdamagerazp3[i]=psdamagerazp3[i]+count bililine=1
end end
if(bililine==0)then
table.insert(psdamagenamep3,nicktoadd) 
table.insert(psdamagevaluep3,damagetoadd)
table.insert(psdamagerazp3,count)
end

end




function psficcsindranoobs2(nr,yyt)
if psbossblock==nil then
psunitisplayer(nr,yyt)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornosindra=1
addtotwotables2(yyt)
vezaxsort2()
end
end
end
end


function psficcsindranoobs44(nr,yyt)
if psbossblock==nil then
psunitisplayer(nr,yyt)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornosindra=1
addtotwotables4(yyt)
vezaxsort4()
end
end
end
end


function psficcsindranoobs3()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
wasornosindra=1

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

function psiccsindratoombsnoobs1()
psiccsyndratime=GetTime()+3
psunitisplayer(arg6,arg7)
if psunitplayertrue then
local bililinet=0
for i=1,#psiccsindmarks do
	if arg7==psiccsindmarks[i] then bililinet=1
	end
end

		if bililinet==0 then
local bilininet2=0
for i=1,#psiccsindmarks2 do
	if arg7==psiccsindmarks2[i] then bilininet2=1
	end
end
if bilininet2==0 then
table.insert(psiccsindmarks2,arg7)
end

		end

end
end

function psiccsindradebnoob1()
if psiccsinddebuf1==nil then psiccsinddebuf1={} end
if psiccsinddebuf2==nil then psiccsinddebuf2={} end
if psiccsinddebuf3==nil then psiccsinddebuf3={} end
wasornosindra=1
local bililinet=0
for i=1,#psiccsinddebuf1 do
	if psiccsinddebuf1[i]==arg7 then
		bililinet=1
		psiccsinddebuf2[i]=arg13
		psiccsinddebuf3[i]=arg1
	end
end

if bililinet==0 then
table.insert(psiccsinddebuf1, arg7)
table.insert(psiccsinddebuf2, arg13)
table.insert(psiccsinddebuf3, arg1)
end
end

function psiccsindradebnoob2()
local psstringa=""
local tainstven=GetSpellInfo(72528)

local percent=15
local _, _, _, _, _, dif = GetInstanceInfo()
if dif and dif==1 then
percent=20
end

if UnitSex(arg7) and UnitSex(arg7)==3 then
psstringa="{rt8} "..arg7.." "..psiccfailtxt11511fem.." \124cff71d5ff\124Hspell:"..arg9.."\124h["..arg10.."]\124h\124r "..psiccfailtxt11512
else
psstringa="{rt8} "..arg7.." "..psiccfailtxt11511.." \124cff71d5ff\124Hspell:"..arg9.."\124h["..arg10.."]\124h\124r "..psiccfailtxt11512
end

for i=1,#psiccsinddebuf1 do
	if psiccsinddebuf1[i]==arg4 then


		if arg1-psiccsinddebuf3[i]<9 then
			psstringa=psstringa..arg4.." (x"..psiccsinddebuf2[i]..")"
		else
			psstringa=psstringa..arg4.." (x1)"
		end



		if psiccsinddebufunk1 and #psiccsinddebufunk1>0 then
		local biltutne=0
			for oo=1,#psiccsinddebufunk1 do
				if psiccsinddebufunk1[oo]==arg7 then
					if arg1-psiccsinddebufunk2[oo]<8 then
					biltutne=1
					psstringa=psstringa.." + "..tainstven.." (x"..psiccsinddebufunk3[oo]..", "..(psiccsinddebufunk3[oo]*percent).."%) > "..(arg12-arg13).." ("..psiccoverdmg..": "..arg13..")"
					end
				end
			end

			if biltutne==0 then
			psstringa=psstringa.." + "..tainstven.." (x0, 0%) > "..(arg12-arg13).." ("..psiccoverdmg..": "..arg13..")"
			end



		else
		psstringa=psstringa.." > "..(arg12-arg13).." ("..psiccoverdmg..": "..arg13..")"
		end


if(psicgalochki[12][1]==1 and psicgalochki[12][6]==1)then
		pszapuskanonsa(whererepiccchat[psicchatchoose[12][6]], psstringa)
end
	end
end
end


function psiccsindradebnoobice2()
local psstringa=""
local tainstven=GetSpellInfo(72528)

local percent=15
local _, _, _, _, _, dif = GetInstanceInfo()
if dif and dif==1 then
percent=20
end

if UnitSex(arg7) and UnitSex(arg7)==3 then
psstringa="{rt8} "..arg7.." "..psiccfailtxt11511fem.." \124cff71d5ff\124Hspell:"..arg9.."\124h["..arg10.."]\124h\124r "
else
psstringa="{rt8} "..arg7.." "..psiccfailtxt11511.." \124cff71d5ff\124Hspell:"..arg9.."\124h["..arg10.."]\124h\124r "
end



for oo=1,#psiccsinddebufunk1 do
	if psiccsinddebufunk1[oo]==arg7 then
		if arg1-psiccsinddebufunk2[oo]<8 then
		psstringa=psstringa..tainstven.." (x"..psiccsinddebufunk3[oo]..", "..(psiccsinddebufunk3[oo]*percent).."%) > "..(arg12-arg13).." ("..psiccoverdmg..": "..arg13..")"

			if(psicgalochki[12][1]==1 and psicgalochki[12][6]==1)then
				pszapuskanonsa(whererepiccchat[psicchatchoose[12][6]], psstringa)
			end


		end
	end
end


end


function psiccsindradebtainctv1(nik,deb,tim,nr)
psunitisplayer(nr,nik)
if psunitplayertrue then
if psiccsinddebufunk1==nil then psiccsinddebufunk1={} end --ник
if psiccsinddebufunk2==nil then psiccsinddebufunk2={} end --время
if psiccsinddebufunk3==nil then psiccsinddebufunk3={} end --деб
wasornosindra=1
local bililinet=0
for i=1,#psiccsinddebufunk1 do
	if psiccsinddebufunk1[i]==arg7 then
		bililinet=1
		psiccsinddebufunk2[i]=tim
		psiccsinddebufunk3[i]=deb
	end
end

if bililinet==0 then
table.insert(psiccsinddebufunk1,nik)
table.insert(psiccsinddebufunk2,tim)
table.insert(psiccsinddebufunk3,deb)
end
end
end


function psiccsindrsort1()

if psdamagename and #psdamagename>0 then

local tablsort1={}
local tablsort2={}
local tablsort3={}
local psicctablsort4={}

for jj=1,#psdamagename do
	table.insert(tablsort1,psdamagename[jj])
	table.insert(tablsort2,psdamagevalue[jj])
	table.insert(tablsort3,psdamageraz[jj])
end



table.wipe(psdamagename) 
table.wipe(psdamagevalue)
table.wipe(psdamageraz)



for i=1,#tablsort1 do

	table.insert(psdamagename,tablsort1[i])
	table.insert(psdamagevalue,tablsort2[i])
	table.insert(psdamageraz,tablsort3[i])

	local sredn=0
	if tablsort3[i] and tablsort3[i]>0 then
	sredn=tablsort2[i]/tablsort3[i]
	end

	table.insert(psicctablsort4,sredn)



	local vzxnnw= #psdamagename

		if vzxnnw>0 then
	while vzxnnw>1 do
	if psicctablsort4[vzxnnw]>psicctablsort4[vzxnnw-1] then
	local vezaxtempv1=psdamagevalue[vzxnnw-1]
	local vezaxtempv2=psdamagename[vzxnnw-1]
	local vezaxtempv3=psdamageraz[vzxnnw-1]
	local vezaxtempv4=psicctablsort4[vzxnnw-1]
	psdamagevalue[vzxnnw-1]=psdamagevalue[vzxnnw]
	psdamagename[vzxnnw-1]=psdamagename[vzxnnw]
	psdamageraz[vzxnnw-1]=psdamageraz[vzxnnw]
	psicctablsort4[vzxnnw-1]=psicctablsort4[vzxnnw]
	psdamagevalue[vzxnnw]=vezaxtempv1
	psdamagename[vzxnnw]=vezaxtempv2
	psdamageraz[vzxnnw]=vezaxtempv3
	psicctablsort4[vzxnnw]=vezaxtempv4
	end
	vzxnnw=vzxnnw-1
	end
		end


end


tablsort1=nil
tablsort2=nil
tablsort3=nil
psicctablsort4=nil

end
end

function psiccsindrsortp31()

if psdamagenamep3 and #psdamagenamep3>0 then

local tablsort1={}
local tablsort2={}
local tablsort3={}
local psicctablsort4={}

for jj=1,#psdamagenamep3 do
	table.insert(tablsort1,psdamagenamep3[jj])
	table.insert(tablsort2,psdamagevaluep3[jj])
	table.insert(tablsort3,psdamagerazp3[jj])
end



table.wipe(psdamagenamep3) 
table.wipe(psdamagevaluep3)
table.wipe(psdamagerazp3)



for i=1,#tablsort1 do

	table.insert(psdamagenamep3,tablsort1[i])
	table.insert(psdamagevaluep3,tablsort2[i])
	table.insert(psdamagerazp3,tablsort3[i])

	local sredn=0
	if tablsort3[i] and tablsort3[i]>0 then
	sredn=tablsort2[i]/tablsort3[i]
	end

	table.insert(psicctablsort4,sredn)



	local vzxnnw= #psdamagenamep3

		if vzxnnw>0 then
	while vzxnnw>1 do
	if psicctablsort4[vzxnnw]>psicctablsort4[vzxnnw-1] then
	local vezaxtempv1=psdamagevaluep3[vzxnnw-1]
	local vezaxtempv2=psdamagenamep3[vzxnnw-1]
	local vezaxtempv3=psdamagerazp3[vzxnnw-1]
	local vezaxtempv4=psicctablsort4[vzxnnw-1]
	psdamagevaluep3[vzxnnw-1]=psdamagevaluep3[vzxnnw]
	psdamagenamep3[vzxnnw-1]=psdamagenamep3[vzxnnw]
	psdamagerazp3[vzxnnw-1]=psdamagerazp3[vzxnnw]
	psicctablsort4[vzxnnw-1]=psicctablsort4[vzxnnw]
	psdamagevaluep3[vzxnnw]=vezaxtempv1
	psdamagenamep3[vzxnnw]=vezaxtempv2
	psdamagerazp3[vzxnnw]=vezaxtempv3
	psicctablsort4[vzxnnw]=vezaxtempv4
	end
	vzxnnw=vzxnnw-1
	end
		end


end


tablsort1=nil
tablsort2=nil
tablsort3=nil
psicctablsort4=nil

end
end

function reportfromtridamagetablesp3(inwhichchat,maxpers,qq,bojinterr,iccra,norep)
if psdamagevaluep3 and psdamagevaluep3[1]>0 then

if (psdamagenamep3==nil or psdamagenamep3=={}) then psdamagenamep3 = {} end
if (psdamagevaluep3==nil or psdamagevaluep3=={}) then psdamagevaluep3 = {} end
if (psdamagerazp3==nil or psdamagerazp3=={}) then psdamagerazp3 = {} end
local strochkavezcrash2=""
local psinfoshieldtempdamage=""
local vzxnn= # psdamagenamep3
local pstochki=""
if(vzxnn>0)then
if vzxnn>maxpers then vzxnn=maxpers pstochki=", ..." else pstochki="." end
for i = 1,vzxnn do


			if psdamagevaluep3[i] and psdamagevaluep3[i]>0 then

	if (string.len(psdamagevaluep3[i])) > 3 then
	psinfoshieldtempdamage=string.sub(psdamagevaluep3[i], 1, string.len(psdamagevaluep3[i])-3) psinfoshieldtempdamage=psinfoshieldtempdamage.."k"
	else
	psinfoshieldtempdamage=psdamagevaluep3[i]
	end
			end

if i==vzxnn then

			if psdamagevaluep3[i] and psdamagevaluep3[i]>0 then
	if (string.len(strochkadamageout) > 230 and qq==nil) then strochkavezcrash2=strochkavezcrash2..psdamagenamep3[i].." ("..psinfoshieldtempdamage.." - "..psdamagerazp3[i]..")"..pstochki else strochkadamageout=strochkadamageout..psdamagenamep3[i].." ("..psinfoshieldtempdamage.." - "..psdamagerazp3[i]..")"..pstochki end
			end
		pszapuskanonsa(inwhichchat, strochkadamageout,bojinterr,nil,iccra,norep)

if (string.len(strochkavezcrash2) > 3 and qq==nil) then pszapuskanonsa(inwhichchat, strochkavezcrash2, bojinterr,nil,iccra,norep) end
else
			if psdamagevaluep3[i] and psdamagevaluep3[i]>0 then
	if (string.len(strochkadamageout) > 230 and qq==nil) then
		strochkavezcrash2=strochkavezcrash2..psdamagenamep3[i].." ("..psinfoshieldtempdamage.." - "..psdamagerazp3[i].."), "
	else
	strochkadamageout=strochkadamageout..psdamagenamep3[i].." ("..psinfoshieldtempdamage.." - "..psdamagerazp3[i].."), "
	end
			end
end
end
end

end
end


function psficcsindraafterf()

psiccsindrsort1()
psiccsindrsortp31()

if(psicgalochki[12][1]==1 and psicgalochki[12][2]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt111
reportafterboitwotab(whererepiccchat[psicchatchoose[12][2]], true, vezaxname, vezaxcrash, 1, 7)
end

if(psicgalochki[12][1]==1 and psicgalochki[12][3]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt112
reportafterboitwotab(whererepiccchat[psicchatchoose[12][3]], true, vezaxname2, vezaxcrash2, 1, 7)
end

if(psicgalochki[12][1]==1 and psicgalochki[12][4]==1)then
strochkavezcrash="{rt1} "..psiccfailtxt113
reportafterboitwotab(whererepiccchat[psicchatchoose[12][4]], true, vezaxname3, vezaxcrash3, 1, 7)
end

if psiccinst=="10" or psiccinst=="25" then else
if(psicgalochki[12][1]==1 and psicgalochki[12][7]==1)then
strochkadamageout="{rt4} "..psiccbossfail116f
reportfromtridamagetables(whererepiccchat[psicchatchoose[12][7]],12,1,true)
end
end

if psiccinst=="10" or psiccinst=="25" then else
if(psicgalochki[12][1]==1 and psicgalochki[12][8]==1)then
strochkadamageout="{rt4} "..psiccbossfail116f3
reportfromtridamagetablesp3(whererepiccchat[psicchatchoose[12][8]],12,1,true)
end
end

if(psicgalochki[12][1]==1 and psicgalochki[12][9]==1)then
strochkavezcrash="{rt7} "..psiccbossfail118t
reportafterboitwotab(whererepiccchat[psicchatchoose[12][9]], true, vezaxname4, vezaxcrash4, 1, 10)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then
psicclastsaverep=GetTime()
psiccsavinginf(psiccsindragosa)

strochkavezcrash="{rt7} "..psiccfailtxt111
reportafterboitwotab(whererepiccchat[psicchatchoose[12][2]], true, vezaxname, vezaxcrash, 1, 15,0,1)
strochkavezcrash="{rt7} "..psiccfailtxt112
reportafterboitwotab(whererepiccchat[psicchatchoose[12][3]], true, vezaxname2, vezaxcrash2, 1, 15,0,1)
strochkavezcrash="{rt1} "..psiccfailtxt113
reportafterboitwotab(whererepiccchat[psicchatchoose[12][4]], true, vezaxname3, vezaxcrash3, nil, 20,0,1)

if psiccinst=="10" or psiccinst=="25" then else
strochkadamageout="{rt4} "..psiccbossfail116f
reportfromtridamagetables(whererepiccchat[psicchatchoose[12][7]],15,nil,true,0,1)
end

if psiccinst=="10" or psiccinst=="25" then else
strochkadamageout="{rt4} "..psiccbossfail116f3
reportfromtridamagetablesp3(whererepiccchat[psicchatchoose[12][8]],15,nil,true,0,1)
end

strochkavezcrash="{rt7} "..psiccbossfail118t
reportafterboitwotab(whererepiccchat[psicchatchoose[12][9]], true, vezaxname4, vezaxcrash4, 1, 15,0,1)

psiccrefsvin()
end

end


function psficcsindraresetall()
wasornosindra=nil
iccsindraboyinterr=nil
timetocheck=0
table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)
psiccsinddebuf1=nil
psiccsinddebuf2=nil
psiccsinddebuf3=nil
psiccsinddebufunk1=nil
psiccsinddebufunk2=nil
psiccsinddebufunk3=nil
psdamagename=nil
psdamagevalue=nil
psdamageraz=nil
psdamagenamep3=nil
psdamagevaluep3=nil
psdamagerazp3=nil
psiccschet=0
psiccschet2=0
end