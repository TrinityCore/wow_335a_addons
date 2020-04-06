function psftwinseat()
psunitisplayer(arg6,arg7)
if psunitplayertrue then
wasornotwins=1
addtotwotables(arg7)
vezaxsort1()
end
end

function psftwinseat2()
psunitisplayer(arg6,arg7)
if psunitplayertrue then
wasornotwins=1
addtotwotables2(arg7)
vezaxsort2()
end
end


function psftwinsafterf()
if(thisaddononoff and twinspart) then
	if twinspart2 then
strochkavezcrash="{rt8} "..pscotwinsinfo
reportafterboitwotab(wherereporttwins, true, vezaxname, vezaxcrash)
strochkavezcrash="{rt1} "..pscotwinsinfo2
reportafterboitwotab(wherereporttwins, true, vezaxname2, vezaxcrash2)
	end

end
end


function psftwinsrezetall()
wasornotwins=nil
timetocheck=0
psvalnextshtime=0
twinboyinterr=0
table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
end




--вывод в окно
function psfcoltwinsinfoout(psout1, psout2, psout3)

--сбор инфы

--обнуление таблиц
if (psstrochkainfoshield1==nil or psstrochkainfoshield1=={}) then psstrochkainfoshield1 = {} end
if (psstrochkainfoshield2==nil or psstrochkainfoshield2=={}) then psstrochkainfoshield2 = {} end
if (psstrochkainfoshield3==nil or psstrochkainfoshield3=={}) then psstrochkainfoshield3 = {} end
if (psstrochkainfoshield4==nil or psstrochkainfoshield4=={}) then psstrochkainfoshield4 = {} end
if (psnikividelyat==nil or psnikividelyat=={}) then psnikividelyat = {} end

PSFmainshieldinfo_text1:Hide()




if (zapuskpervijshidingo==nil)then
zapuskpervijshidingo=1
psfcolshieldsozdat()
end


--1 щит вайпаем таблицы, убираем весь текст, убираем кнопки
if psfirsteventshield==0 then
table.wipe(psstrochkainfoshield1)
table.wipe(psstrochkainfoshield2)
table.wipe(psstrochkainfoshield3)
table.wipe(psstrochkainfoshield4)
table.wipe(psnikividelyat)
psfirsteventshield=1
tshinfo11:SetText(" ")
tshinfo12:SetText(" ")
tshinfo13:SetText(" ")
tshinfo21:SetText(" ")
tshinfo22:SetText(" ")
tshinfo23:SetText(" ")
tshinfo31:SetText(" ")
tshinfo32:SetText(" ")
tshinfo33:SetText(" ")
tshinfo41:SetText(" ")
tshinfo42:SetText(" ")
tshinfo43:SetText(" ")
PSFmainshieldinfo_Buttonsend1:Hide()
PSFmainshieldinfo_Buttonsend2:Hide()
PSFmainshieldinfo_Buttonsend3:Hide()
PSFmainshieldinfo_Buttonsend4:Hide()
openpodsvetkavalkyr()
end


--смотрим какой щит

psshieldinfostrochka= (# psstrochkainfoshield1)+1
if psshieldinfostrochka>4 then else




if psout1==1 then
psstrochkainfoshield1[psshieldinfostrochka]=pscolvalinfloc1.." #"..psshieldinfostrochka.." - "..psvalbitnada..". "..pscolvalinfloc2.." "..psout3.." "..pscolvalinfloc3.." ("..psout2..")"

	if psshieldinfostrochka==1 then tshinfo11:SetText("|CFFFFFF00"..pscolvalinfloc4.." #1 - "..psvalbitnada..". "..pscolvalinfloc2.." "..psout3.." "..pscolvalinfloc3.." ("..psout2..")|r")
	elseif psshieldinfostrochka==2 then tshinfo21:SetText("|CFFFFFF00"..pscolvalinfloc4.." #2 - "..psvalbitnada..". "..pscolvalinfloc2.." "..psout3.." "..pscolvalinfloc3.." ("..psout2..")|r")
	elseif psshieldinfostrochka==3 then tshinfo31:SetText("|CFFFFFF00"..pscolvalinfloc4.." #3 - "..psvalbitnada..". "..pscolvalinfloc2.." "..psout3.." "..pscolvalinfloc3.." ("..psout2..")|r")
	elseif psshieldinfostrochka==4 then tshinfo41:SetText("|CFFFFFF00"..pscolvalinfloc4.." #4 - "..psvalbitnada..". "..pscolvalinfloc2.." "..psout3.." "..pscolvalinfloc3.." ("..psout2..")|r")
	end
else

psstrochkainfoshield1[psshieldinfostrochka]=pscolvalinfloc1.." #"..psshieldinfostrochka.." - "..psvalbitnada..". "..pscolvalinfloc5.." - "..psout2.." "..psulhp.."."

	if psshieldinfostrochka==1 then tshinfo11:SetText("|CFFFFFF00"..pscolvalinfloc4.." #1 - "..psvalbitnada..". |cffff0000"..pscolvalinfloc5.."|r - "..psout2.." "..psulhp..".|r")
	elseif psshieldinfostrochka==2 then tshinfo21:SetText("|CFFFFFF00"..pscolvalinfloc4.." #2 - "..psvalbitnada..". |cffff0000"..pscolvalinfloc5.."|r - "..psout2.." "..psulhp..".|r")
	elseif psshieldinfostrochka==3 then tshinfo31:SetText("|CFFFFFF00"..pscolvalinfloc4.." #3 - "..psvalbitnada..". |cffff0000"..pscolvalinfloc5.."|r - "..psout2.." "..psulhp..".|r")
	elseif psshieldinfostrochka==4 then tshinfo41:SetText("|CFFFFFF00"..pscolvalinfloc4.." #4 - "..psvalbitnada..". |cffff0000"..pscolvalinfloc5.."|r - "..psout2.." "..psulhp..".|r")
	end

end


--вторая строчка

local vzxnn= # psdamagename
local psinfoshieldtemp=""
local psinfoshieldtempdamage=""
if(vzxnn>0)then
if vzxnn>6 then vzxnn=6 pstochki=", ..." else pstochki=". " end
for i = 1,vzxnn do
	if (string.len(psdamagevalue[i])) > 3 then
	psinfoshieldtempdamage=string.sub(psdamagevalue[i], 1, string.len(psdamagevalue[i])-3) psinfoshieldtempdamage=psinfoshieldtempdamage.."k"
	else
	psinfoshieldtempdamage=psdamagevalue[i]
	end
if i==vzxnn then
psinfoshieldtemp=psinfoshieldtemp..psdamagename[i].." ("..psinfoshieldtempdamage.." - "..psdamageraz[i]..")"..pstochki
else
psinfoshieldtemp=psinfoshieldtemp..psdamagename[i].." ("..psinfoshieldtempdamage.." - "..psdamageraz[i].."), "
end
psaddnickvidelenie(psdamagename[i])

end
end --табл не пуста
psstrochkainfoshield2[psshieldinfostrochka]=psinfoshieldtemp



--третья строчка + отображение 2 и 3 на фрейме + отображение кнопок
local vzxnn= # psdamagename2
if psshieldamount==1200000 then psnormdpsshield=80000 elseif psshieldamount==700000 then psnormdpsshield=40000 elseif psshieldamount==300000 then psnormdpsshield=50000 else psnormdpsshield=30000 end
local psinfoshieldtemp=""
local psinfoshieldtemp2=""
local psinfoshieldtempframe=""
local psinfoshieldtempdamage=""
local pstemptimeswich="?"
if(vzxnn>0)then
for i = 1,vzxnn do
	if (string.len(psdamagevalue2[i])) > 3 then
	psinfoshieldtempdamage=string.sub(psdamagevalue2[i], 1, string.len(psdamagevalue2[i])-3) psinfoshieldtempdamage=psinfoshieldtempdamage.."k"
	else
	psinfoshieldtempdamage=psdamagevalue2[i]
	end

	for j=1,#pstwraidroster do
		if pstwraidroster[j]==psdamagename2[i] then pstemptimeswich=pstwtimeswitch[j]
		end
	end

if i==vzxnn then

	if string.len(psinfoshieldtemp) < 125 then
	psinfoshieldtemp=psinfoshieldtemp..psdamagename2[i].." ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s). "
	else
	psinfoshieldtemp2=psinfoshieldtemp2..psdamagename2[i].." ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s). "
	end

	if psdamagevalue2[i]>=psnormdpsshield then
	psinfoshieldtempframe=psinfoshieldtempframe.."|cff00ff00"..psdamagename2[i].."|r ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s). "
	else
	psinfoshieldtempframe=psinfoshieldtempframe.."|cffff0000"..psdamagename2[i].."|r ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s). "	
	end

else
--для вывода
	if string.len(psinfoshieldtemp) < 125 then
	psinfoshieldtemp=psinfoshieldtemp..psdamagename2[i].." ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s), "
	else
	psinfoshieldtemp2=psinfoshieldtemp2..psdamagename2[i].." ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s), "
	end
--для фрейма
	if psdamagevalue2[i]>=psnormdpsshield then
	psinfoshieldtempframe=psinfoshieldtempframe.."|cff00ff00"..psdamagename2[i].."|r ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s), "
	else
	psinfoshieldtempframe=psinfoshieldtempframe.."|cffff0000"..psdamagename2[i].."|r ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s), "	
	end

end
psaddnickvidelenie(psdamagename2[i])


end -- for i
end
psstrochkainfoshield3[psshieldinfostrochka]=psinfoshieldtemp
psstrochkainfoshield4[psshieldinfostrochka]=psinfoshieldtemp2




--вывод 2 , 3 и кнопок

local pstxtbegin=pscolvalchntxt1
if twinspart4 then pstxtbegin=pscolvalchntxt2 end

if psshieldinfostrochka==1 then
	PSFmainshieldinfo_Buttonsend1:Show()
	tshinfo12:SetText("|cffff0000"..pscolvalinfloc6..":|r "..psstrochkainfoshield2[1])
	tshinfo13:SetText("|CFFFFFF00"..pstxtbegin.."|r"..psinfoshieldtempframe)
elseif psshieldinfostrochka==2 then
	PSFmainshieldinfo_Buttonsend2:Show()
	tshinfo22:SetText("|cffff0000"..pscolvalinfloc6..":|r "..psstrochkainfoshield2[2])
	tshinfo23:SetText("|CFFFFFF00"..pstxtbegin.."|r"..psinfoshieldtempframe)
elseif psshieldinfostrochka==3 then
	PSFmainshieldinfo_Buttonsend3:Show()
	tshinfo32:SetText("|cffff0000"..pscolvalinfloc6..":|r "..psstrochkainfoshield2[3])
	tshinfo33:SetText("|CFFFFFF00"..pstxtbegin.."|r"..psinfoshieldtempframe)
elseif psshieldinfostrochka==4 then
	PSFmainshieldinfo_Buttonsend4:Show()
	tshinfo42:SetText("|cffff0000"..pscolvalinfloc6..":|r "..psstrochkainfoshield2[4])
	tshinfo43:SetText("|CFFFFFF00"..pstxtbegin.."|r"..psinfoshieldtempframe)
end

openpodsvetkavalkyr()
psallbluoff()



end --5 щит мы игнорим
end



--создать
function psfcolshieldsozdat()


--создание полос

fshinfo11 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo11 = fshinfo11:CreateFontString(Name)
fshcreate(fshinfo11,tshinfo11,465,15,12,120,-15)

fshinfo12 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo12 = fshinfo12:CreateFontString(Name)
fshcreate(fshinfo12,tshinfo12,570,15,9,20,-32)

fshinfo13 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo13 = fshinfo13:CreateFontString(Name)
fshcreate(fshinfo13,tshinfo13,570,40,9,20,-44)

--2

fshinfo21 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo21 = fshinfo21:CreateFontString(Name)
fshcreate(fshinfo21,tshinfo21,465,15,12,120,-103)

fshinfo22 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo22 = fshinfo22:CreateFontString(Name)
fshcreate(fshinfo22,tshinfo22,570,15,9,20,-120)

fshinfo23 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo23 = fshinfo23:CreateFontString(Name)
fshcreate(fshinfo23,tshinfo23,570,40,9,20,-132)

--3

fshinfo31 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo31 = fshinfo31:CreateFontString(Name)
fshcreate(fshinfo31,tshinfo31,465,15,12,120,-191)

fshinfo32 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo32 = fshinfo32:CreateFontString(Name)
fshcreate(fshinfo32,tshinfo32,570,15,9,20,-208)

fshinfo33 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo33 = fshinfo33:CreateFontString(Name)
fshcreate(fshinfo33,tshinfo33,570,40,9,20,-220)

--4

fshinfo41 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo41 = fshinfo41:CreateFontString(Name)
fshcreate(fshinfo41,tshinfo41,465,15,12,120,-279)

fshinfo42 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo42 = fshinfo42:CreateFontString(Name)
fshcreate(fshinfo42,tshinfo42,570,15,9,20,-296)

fshinfo43 = CreateFrame("Frame",nil,PSFmainshieldinfo)
tshinfo43 = fshinfo43:CreateFontString(Name)
fshcreate(fshinfo43,tshinfo43,570,40,9,20,-308)

end


function openmenureportinfoshield()
if not DropDownMenureportinfoshield then
CreateFrame("Frame", "DropDownMenureportinfoshield", PSFmainshieldinfo, "UIDropDownMenuTemplate")
end
pscreatedropmcol(DropDownMenureportinfoshield,"BOTTOMLEFT",198,7,wherereportinfshield,4)
end


function openpodsvetkavalkyr()
if not DropDownMenupodsvetkavalkyr then
CreateFrame("Frame", "DropDownMenupodsvetkavalkyr", PSFmainshieldinfo, "UIDropDownMenuTemplate")
end

DropDownMenupodsvetkavalkyr:ClearAllPoints()
DropDownMenupodsvetkavalkyr:SetPoint("BOTTOMLEFT", 113, 7)
DropDownMenupodsvetkavalkyr:Show()

pstemptableval={}
table.wipe(pstemptableval)
for i=1,# psnikividelyat do
table.insert (pstemptableval, psnikividelyat[i])
end
table.insert(pstemptableval, 1, pscolvalselectpl)

local items = pstemptableval

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenupodsvetkavalkyr, self:GetID())

if self:GetID()==1 then
psallbluoff()
else
psallbluoff()
psallbluon(self:GetID())
end

end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end


UIDropDownMenu_Initialize(DropDownMenupodsvetkavalkyr, initialize)
UIDropDownMenu_SetWidth(DropDownMenupodsvetkavalkyr, 70);
UIDropDownMenu_SetButtonWidth(DropDownMenupodsvetkavalkyr, 85)
UIDropDownMenu_SetSelectedID(DropDownMenupodsvetkavalkyr,1)
UIDropDownMenu_JustifyText(DropDownMenupodsvetkavalkyr, "LEFT")
end




function PSF_colshieldinfsend(nmknopki)

local pstxtbegin=pscolvalchntxt1
if twinspart4 then pstxtbegin=pscolvalchntxt2 end

psfchatsendreports(wherereportinfshield, psstrochkainfoshield1[nmknopki], "{rt7} "..pscolvalinfloc6..": "..psstrochkainfoshield2[nmknopki], "{rt2} "..pstxtbegin..psstrochkainfoshield3[nmknopki],psstrochkainfoshield4[nmknopki])

end

function psaddnickvidelenie(nicktoadd)
local bililine=0
for i,getcrash in ipairs(psnikividelyat) do 
if getcrash == nicktoadd then bililine=1
end end
if(bililine==0)then
table.insert(psnikividelyat,nicktoadd)
table.sort(psnikividelyat)
end
end



function psblustring1(stringa, vibor)
psblunovastringa=""

psblushtoischem=psnikividelyat[vibor-1].." "
local striniz, strfine = string.find(stringa, psblushtoischem)

if striniz==nil then
psblunovastringa=stringa
else
psblunovastringa=string.sub(stringa, 1, striniz-1).."|CFF000FFF"..string.sub(stringa, striniz, strfine-1).."|r"..string.sub(stringa, strfine)

end
end


function psblustring2(stringa, vibor)
psblunovastringa=""

psblushtoischem=psnikividelyat[vibor-1].."|"
local striniz, strfine = string.find(stringa, psblushtoischem)

if striniz==nil then
psblunovastringa=stringa
else

psblunovastringa=string.sub(stringa, 1, striniz-11).."|CFF000FFF"..string.sub(stringa, striniz)

end
end


function psbluoffstring1(stringa)
psblunovastringa=""

local striniz, strfine = string.find(stringa, "|CFF000FFF")

if striniz==nil then
psblunovastringa=stringa
else

local striniz2, strfine2 = string.find(stringa, "|r", strfine)
psblunovastringa=string.sub(stringa, 1, striniz-1)..string.sub(stringa, strfine+1, striniz2-1)..string.sub(stringa, strfine2+1)

end
end


function psbluoffstring2(stringa)
psblunovastringa=""

local striniz, strfine = string.find(stringa, "|CFF000FFF")

if striniz==nil then
psblunovastringa=stringa
else

local striniz2, strfine2 = string.find(stringa, "|r", strfine)

	if string.find(stringa, "k", strfine2+2)==nil then
--красный
psblunovastringa=string.sub(stringa, 1, striniz-1).."|cffff0000"..string.sub(stringa, strfine+1)
	else

if string.find(stringa, "k", strfine2+2)>string.find(stringa, " ", strfine2+2) then
psblunovastringa=string.sub(stringa, 1, striniz-1).."|cffff0000"..string.sub(stringa, strfine+1)
--красный
else
local striniz3 = string.find(stringa, "k", strfine2)

if tonumber(string.sub(stringa, strfine2+3, striniz3-1))*1000>=psnormdpsshield then
--зеленый
psblunovastringa=string.sub(stringa, 1, striniz-1).."|cff00ff00"..string.sub(stringa, strfine+1)
else
--красный
psblunovastringa=string.sub(stringa, 1, striniz-1).."|cffff0000"..string.sub(stringa, strfine+1)
end
end
	end


end
end

function psallbluoff()
if zapuskpervijshidingo then
psbluoffstring1(tshinfo12:GetText())
tshinfo12:SetText(psblunovastringa)
psbluoffstring1(tshinfo22:GetText())
tshinfo22:SetText(psblunovastringa)
psbluoffstring1(tshinfo32:GetText())
tshinfo32:SetText(psblunovastringa)
psbluoffstring1(tshinfo42:GetText())
tshinfo42:SetText(psblunovastringa)

psbluoffstring2(tshinfo13:GetText())
tshinfo13:SetText(psblunovastringa)
psbluoffstring2(tshinfo23:GetText())
tshinfo23:SetText(psblunovastringa)
psbluoffstring2(tshinfo33:GetText())
tshinfo33:SetText(psblunovastringa)
psbluoffstring2(tshinfo43:GetText())
tshinfo43:SetText(psblunovastringa)
end
end



function psallbluon(nomero4eg)
if zapuskpervijshidingo then

psblustring1(tshinfo12:GetText(), nomero4eg)
tshinfo12:SetText(psblunovastringa)
psblustring1(tshinfo22:GetText(), nomero4eg)
tshinfo22:SetText(psblunovastringa)
psblustring1(tshinfo32:GetText(), nomero4eg)
tshinfo32:SetText(psblunovastringa)
psblustring1(tshinfo42:GetText(), nomero4eg)
tshinfo42:SetText(psblunovastringa)

psblustring2(tshinfo13:GetText(), nomero4eg)
tshinfo13:SetText(psblunovastringa)
psblustring2(tshinfo23:GetText(), nomero4eg)
tshinfo23:SetText(psblunovastringa)
psblustring2(tshinfo33:GetText(), nomero4eg)
tshinfo33:SetText(psblunovastringa)
psblustring2(tshinfo43:GetText(), nomero4eg)
tshinfo43:SetText(psblunovastringa)

end
end


function fshcreate(ff,tt,w1,h1,f1,w2,h2)
ff:SetFrameStrata("DIALOG")
ff:SetWidth(w1)
ff:SetHeight(h1)
tt:SetFont(GameFontNormal:GetFont(), f1)
tt:SetAllPoints(ff)
tt:SetText(" ")
tt:SetJustifyH("LEFT")
ff:SetPoint("TOPLEFT",w2,h2)
ff:Show()
end



function reportfromtwodamagetablestwin(inwhichchat, qq)

local strochkavezcrash2=""
local strochkadamageout=""
local pstemptimeswich="?"
if (psdamagename2==nil or psdamagename2=={}) then psdamagename2 = {} end
if (psdamagevalue2==nil or psdamagevalue2=={}) then psdamagevalue2 = {} end
if (pstwraidroster==nil or pstwraidroster=={}) then pstwraidroster = {} end
if (pstwtimeswitch==nil or pstwtimeswitch=={}) then pstwtimeswitch = {} end
local vzxnn= # psdamagename2
local psinfoshieldtempdamage=""
local pstochki=""
if(vzxnn>0)then
if vzxnn>18 then vzxnn=18 pstochki=", ..." else pstochki="." end
for i = 1,vzxnn do

	if (string.len(psdamagevalue2[i])) > 3 then
	psinfoshieldtempdamage=string.sub(psdamagevalue2[i], 1, string.len(psdamagevalue2[i])-3) psinfoshieldtempdamage=psinfoshieldtempdamage.."k"
	else
	psinfoshieldtempdamage=psdamagevalue2[i]
	end
--запись времени
	for j=1,#pstwraidroster do
		if pstwraidroster[j]==psdamagename2[i] then pstemptimeswich=pstwtimeswitch[j]
		end
	end

if i==vzxnn then
if (string.len(strochkadamageout) > 220 and qq==nil) then strochkavezcrash2=strochkavezcrash2..psdamagename2[i].." ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s)"..pstochki else strochkadamageout=strochkadamageout..psdamagename2[i].." ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s)"..pstochki end

		pszapuskanonsa(inwhichchat, strochkadamageout)
if (string.len(strochkavezcrash2) > 3 and qq==nil) then pszapuskanonsa(inwhichchat, strochkavezcrash2) end
else
	if (string.len(strochkadamageout) > 220 and qq==nil) then
		strochkavezcrash2=strochkavezcrash2..psdamagename2[i].." ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s), "
	else
	strochkadamageout=strochkadamageout..psdamagename2[i].." ("..psinfoshieldtempdamage.." - "..pstemptimeswich.."s), "
	end

end
end
end

end