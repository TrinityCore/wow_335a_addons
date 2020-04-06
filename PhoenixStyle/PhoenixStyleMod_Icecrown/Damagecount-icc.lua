function iccadddamagetables(nicktoadd, damagetoadd, minus)

local bililine=0
for i,getcrash in ipairs(psiccdamagenames[1][#psiccdamagenames[1]-minus]) do 
if getcrash == nicktoadd then psiccdamagevalues[1][#psiccdamagevalues[1]-minus][i]=psiccdamagevalues[1][#psiccdamagevalues[1]-minus][i]+damagetoadd bililine=1
end end
if(bililine==0)then
table.insert(psiccdamagenames[1][#psiccdamagenames[1]-minus],nicktoadd) 
table.insert(psiccdamagevalues[1][#psiccdamagevalues[1]-minus],damagetoadd)
end

end



function iccdamagetablsort(minus)
local vzxnnw= #psiccdamagenames[1][#psiccdamagenames[1]-minus]
while vzxnnw>1 do
if psiccdamagevalues[1][#psiccdamagevalues[1]-minus][vzxnnw]>psiccdamagevalues[1][#psiccdamagevalues[1]-minus][vzxnnw-1] then
local vezaxtempv1=psiccdamagevalues[1][#psiccdamagevalues[1]-minus][vzxnnw-1]
local vezaxtempv2=psiccdamagenames[1][#psiccdamagenames[1]-minus][vzxnnw-1]
psiccdamagevalues[1][#psiccdamagevalues[1]-minus][vzxnnw-1]=psiccdamagevalues[1][#psiccdamagevalues[1]-minus][vzxnnw]
psiccdamagenames[1][#psiccdamagenames[1]-minus][vzxnnw-1]=psiccdamagenames[1][#psiccdamagenames[1]-minus][vzxnnw]
psiccdamagevalues[1][#psiccdamagevalues[1]-minus][vzxnnw]=vezaxtempv1
psiccdamagenames[1][#psiccdamagenames[1]-minus][vzxnnw]=vezaxtempv2
end
vzxnnw=vzxnnw-1
end
end



function psicccheckswitch(psgoodtarget)

local psgrups=5
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
psgrups=2
end

table.insert(psiccswitchnames[1],{})
table.insert(psiccswitchtime[1],{})

table.insert(psiccindexclass[1],{})

if #psiccquantooze==1 then
--норм проверка таргетов и запуск онапдейт функции !

for i=1,GetNumRaidMembers() do local psname, _, pssubgroup = GetRaidRosterInfo(i)
	if pssubgroup <= psgrups then
table.insert(psiccswitchnames[1][#psiccswitchnames[1]],(GetRaidRosterInfo(i)))

local rsccodeclass=0
local _, rsctekclass = UnitClass(psname)
				if rsctekclass then
rsctekclass=string.lower(rsctekclass)

if rsctekclass=="warrior" then rsccodeclass=1
elseif rsctekclass=="deathknight" then rsccodeclass=2
elseif rsctekclass=="paladin" then rsccodeclass=3
elseif rsctekclass=="priest" then rsccodeclass=4
elseif rsctekclass=="shaman" then rsccodeclass=5
elseif rsctekclass=="druid" then rsccodeclass=6
elseif rsctekclass=="rogue" then rsccodeclass=7
elseif rsctekclass=="mage" then rsccodeclass=8
elseif rsctekclass=="warlock" then rsccodeclass=9
elseif rsctekclass=="hunter" then rsccodeclass=10
end
				end

table.insert(psiccindexclass[1][#psiccindexclass[1]],rsccodeclass)


		if UnitName(psname.."-target")==psgoodtarget then
		--таргет совпадает
		table.insert(psiccswitchtime[1][#psiccswitchtime[1]],0)
		else
		--таргет фейл
		table.insert(psiccswitchtime[1][#psiccswitchtime[1]],"--")
		end
	end
end

psiccozzetimebegin=GetTime()
psiccnexttargetlook=GetTime()+0.1


elseif #psiccquantooze==2 then
--создать таблицу но всем прочерки

psiccnexttargetlook=GetTime()+0.2

for i=1,GetNumRaidMembers() do local psname,_,pssubgroup = GetRaidRosterInfo(i)
	if pssubgroup <= psgrups then
table.insert(psiccswitchnames[1][#psiccswitchnames[1]],(GetRaidRosterInfo(i)))

local rsccodeclass=0
local _, rsctekclass = UnitClass(psname)
				if rsctekclass then
rsctekclass=string.lower(rsctekclass)

if rsctekclass=="warrior" then rsccodeclass=1
elseif rsctekclass=="deathknight" then rsccodeclass=2
elseif rsctekclass=="paladin" then rsccodeclass=3
elseif rsctekclass=="priest" then rsccodeclass=4
elseif rsctekclass=="shaman" then rsccodeclass=5
elseif rsctekclass=="druid" then rsccodeclass=6
elseif rsctekclass=="rogue" then rsccodeclass=7
elseif rsctekclass=="mage" then rsccodeclass=8
elseif rsctekclass=="warlock" then rsccodeclass=9
elseif rsctekclass=="hunter" then rsccodeclass=10
end
				end

table.insert(psiccindexclass[1][#psiccindexclass[1]],rsccodeclass)

		if UnitName(psname.."-target")==psgoodtarget then
		--таргет совпадает
		table.insert(psiccswitchtime[1][#psiccswitchtime[1]],0)
		else
		--таргет фейл
		table.insert(psiccswitchtime[1][#psiccswitchtime[1]],"--")
		end
	end
end

psiccozzetimebegin222=GetTime()
psiccnexttargetlook222=GetTime()+0.1


end
end


function psicccheckswitch2(psgoodtarget,psdelay)
if psdelay then else psdelay=0 end

local psgrups=5
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
psgrups=2
end

table.insert(psiccswitchnames[1],{})
table.insert(psiccswitchtime[1],{})

table.insert(psiccindexclass[1],{})


for i=1,GetNumRaidMembers() do local psname, _, pssubgroup = GetRaidRosterInfo(i)
	if pssubgroup <= psgrups then
table.insert(psiccswitchnames[1][#psiccswitchnames[1]],(GetRaidRosterInfo(i)))

local rsccodeclass=0
local _, rsctekclass = UnitClass(psname)
				if rsctekclass then
rsctekclass=string.lower(rsctekclass)

if rsctekclass=="warrior" then rsccodeclass=1
elseif rsctekclass=="deathknight" then rsccodeclass=2
elseif rsctekclass=="paladin" then rsccodeclass=3
elseif rsctekclass=="priest" then rsccodeclass=4
elseif rsctekclass=="shaman" then rsccodeclass=5
elseif rsctekclass=="druid" then rsccodeclass=6
elseif rsctekclass=="rogue" then rsccodeclass=7
elseif rsctekclass=="mage" then rsccodeclass=8
elseif rsctekclass=="warlock" then rsccodeclass=9
elseif rsctekclass=="hunter" then rsccodeclass=10
end
				end

table.insert(psiccindexclass[1][#psiccindexclass[1]],rsccodeclass)


		if UnitName(psname.."-target")==psgoodtarget then
		--таргет совпадает
		table.insert(psiccswitchtime[1][#psiccswitchtime[1]],0)
		else
		--таргет фейл
		table.insert(psiccswitchtime[1][#psiccswitchtime[1]],"--")
		end
	end
end

psiccozzetimebegin=GetTime()+psdelay
psiccnexttargetlook=GetTime()+0.1+psdelay

end



function psiccdamageinfoopen()
--открыть фрейм просто, если инфы нет - написать об этом
PSF_closeallpr()
PSFiccdamageinfo:Show()
openicccombarchoose()
openicceventchoose()
openiccquantname()
openicclogchat()

--создать текст фреймы
if psiccerelghg==nil then
psiccerelghg=1

--текст
local f = CreateFrame("Frame",nil,PSFiccdamageinfo)
f:SetFrameStrata("DIALOG")
f:SetWidth(560)
f:SetHeight(95)

psiccdmgtxt1 = f:CreateFontString()
psiccdmgtxt1:SetFont(GameFontNormal:GetFont(), 11)
psiccdmgtxt1:SetAllPoints(f)
psiccdmgtxt1:SetText(" ")
psiccdmgtxt1:SetJustifyH("LEFT")
psiccdmgtxt1:SetJustifyV("TOP")

f:SetPoint("TOPLEFT",20,-100)


local r = CreateFrame("Frame",nil,PSFiccdamageinfo)
r:SetFrameStrata("DIALOG")
r:SetWidth(560)
r:SetHeight(75)

psiccdmgtxt2 = r:CreateFontString()
psiccdmgtxt2:SetFont(GameFontNormal:GetFont(), 11)
psiccdmgtxt2:SetAllPoints(r)
psiccdmgtxt2:SetText(" ")
psiccdmgtxt2:SetJustifyH("LEFT")
psiccdmgtxt2:SetJustifyV("BOTTOM")
r:SetPoint("TOPLEFT",20,-280)

end

psiccdmgshow(psiccdmg1,psiccdmg2,psiccdmg3)

end


function openicccombarchoose()
if not DropDownicccombarchoose then
CreateFrame("Frame", "DropDownicccombarchoose", PSFiccdamageinfo, "UIDropDownMenuTemplate")
end

DropDownicccombarchoose:ClearAllPoints()
DropDownicccombarchoose:SetPoint("TOPLEFT", 10, -45)
DropDownicccombarchoose:Show()

local items = {pcicccombat1,pcicccombat2,pcicccombat3}
for i=1,3 do
if psicccombatinfo[i]==nil then items[i]=nil
end
end
if #psicccombatinfo == 0 then
table.wipe(items)
items = {pcicccombat4}
end

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownicccombarchoose, self:GetID())

if #psicccombatinfo>0 then
psiccdmg1=self:GetID()
psiccdmg2=nil
openicceventchoose()
psiccdmgshow(psiccdmg1,psiccdmg2,psiccdmg3)
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

if psiccdmg1==nil and #psicccombatinfo>0 then
psiccdmg1=1
end

UIDropDownMenu_Initialize(DropDownicccombarchoose, initialize)
UIDropDownMenu_SetWidth(DropDownicccombarchoose, 115)
UIDropDownMenu_SetButtonWidth(DropDownicccombarchoose, 130)
if psiccdmg1 then
UIDropDownMenu_SetSelectedID(DropDownicccombarchoose, psiccdmg1)
else
UIDropDownMenu_SetSelectedID(DropDownicccombarchoose, 1)
end
UIDropDownMenu_JustifyText(DropDownicccombarchoose, "LEFT")
end





function openicceventchoose()
if not DropDownicceventchoose then
CreateFrame("Frame", "DropDownicceventchoose", PSFiccdamageinfo, "UIDropDownMenuTemplate")
end

DropDownicceventchoose:ClearAllPoints()
DropDownicceventchoose:SetPoint("TOPLEFT", 190, -45)
DropDownicceventchoose:Show()



local items = {pcicccombat4}

if psiccdmg1 and #psicceventsnames[psiccdmg1]>0 then
items=psicceventsnames[psiccdmg1]
end


local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownicceventchoose, self:GetID())

if psiccdmg1 and #psicceventsnames[psiccdmg1]>0 then
psiccdmg2=self:GetID()
psiccdmgshow(psiccdmg1,psiccdmg2,psiccdmg3)
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

if psiccdmg2==nil and psiccdmg1 and #psicceventsnames[psiccdmg1]>0 then
psiccdmg2=1
end

UIDropDownMenu_Initialize(DropDownicceventchoose, initialize)
UIDropDownMenu_SetWidth(DropDownicceventchoose, 175)
UIDropDownMenu_SetButtonWidth(DropDownicceventchoose, 190)
if psiccdmg2 then
UIDropDownMenu_SetSelectedID(DropDownicceventchoose, psiccdmg2)
else
UIDropDownMenu_SetSelectedID(DropDownicceventchoose, 1)
end
UIDropDownMenu_JustifyText(DropDownicceventchoose, "LEFT")
end


function openiccquantname()
if not DropDowniccquantname then
CreateFrame("Frame", "DropDowniccquantname", PSFiccdamageinfo, "UIDropDownMenuTemplate")
end

DropDowniccquantname:ClearAllPoints()
DropDowniccquantname:SetPoint("TOPLEFT", 430, -45)
DropDowniccquantname:Show()

local items = {psiccall, "5", "7", "10", "12", "15", "17", "20"}

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDowniccquantname, self:GetID())

psiccdmg3=self:GetID()
psiccdmgshow(psiccdmg1,psiccdmg2,psiccdmg3)

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

if psiccdmg3==nil then
psiccdmg3=4
end

UIDropDownMenu_Initialize(DropDowniccquantname, initialize)
UIDropDownMenu_SetWidth(DropDowniccquantname, 65)
UIDropDownMenu_SetButtonWidth(DropDowniccquantname, 80)
UIDropDownMenu_SetSelectedID(DropDowniccquantname, psiccdmg3)
UIDropDownMenu_JustifyText(DropDowniccquantname, "LEFT")
end


function openicclogchat()
if not DropDownicclogchat then
CreateFrame("Frame", "DropDownicclogchat", PSFiccdamageinfo, "UIDropDownMenuTemplate")
end

DropDownicclogchat:ClearAllPoints()
DropDownicclogchat:SetPoint("TOPLEFT", 10, -230)
DropDownicclogchat:Show()

local items = bigmenuchatlist

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownicclogchat, self:GetID())

if self:GetID()>8 then
psicdopmodchat[2]=psfchatadd[self:GetID()-8]
else
psicdopmodchat[2]=bigmenuchatlisten[self:GetID()]
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

bigmenuchat2(psicdopmodchat[2])
	if bigma2num==0 then
psicdopmodchat[2]=bigmenuchatlisten[1]
bigma2num=1
	end

UIDropDownMenu_Initialize(DropDownicclogchat, initialize)
UIDropDownMenu_SetWidth(DropDownicclogchat, 85)
UIDropDownMenu_SetButtonWidth(DropDownicclogchat, 100)
UIDropDownMenu_SetSelectedID(DropDownicclogchat, bigma2num)
UIDropDownMenu_JustifyText(DropDownicclogchat, "LEFT")
end



function psiccdmgshow(ar1,ar2,ar3)
if psiccdmgtxt1 then
if ar1==nil or ar2==nil then
psiccdmgtxt1:SetText(pcicccombat4)
psiccdmgtxt2:SetText(psiccinfonodata)
else

psiccdmgtxt1:SetText(" ")
psiccdmgtxt2:SetText(" ")

--определяем тип боя
if psiccindexboss[ar1]==1 or psiccindexboss[ar1]==3 or psiccindexboss[ar1]==4 then


--проф & lich king & saurfang
local psstrochka="|CFFFFFF00"..psicceventsnames[ar1][ar2].." "..psiccdmgfrom..": |r"
local maxnick=#psiccdamagenames[ar1][ar2]
local items = {psiccall, 5, 7, 10, 12, 15, 17, 20}
local psinfoshieldtempdamage=0
local pstochki="."


if psiccdmg3==1 then else
if items[psiccdmg3]<maxnick then
maxnick=items[psiccdmg3]
pstochki=", ..."
end
end



if #psiccdamagenames[ar1][ar2]>0 then
for i = 1,maxnick do

	if (string.len(psiccdamagevalues[ar1][ar2][i])) > 3 then
	psinfoshieldtempdamage=string.sub(psiccdamagevalues[ar1][ar2][i], 1, string.len(psiccdamagevalues[ar1][ar2][i])-3) psinfoshieldtempdamage=psinfoshieldtempdamage.."k"
	else
	psinfoshieldtempdamage=psiccdamagevalues[ar1][ar2][i]
	end

local pstimesw="??"
local rsccodeclass=0

	for j=1,#psiccswitchnames[ar1][ar2] do
		if psiccswitchnames[ar1][ar2][j]==psiccdamagenames[ar1][ar2][i] then pstimesw=psiccswitchtime[ar1][ar2][j] rsccodeclass=psiccindexclass[ar1][ar2][j]
		end
	end

--abom
if psiccindexboss[ar1]==1 then
if pstimesw=="??" and psiccdamagenames[ar1][ar2][i]==psiccprofadd then

	for j=1,#psiccswitchnames[ar1][ar2] do
		if psiccswitchnames[ar1][ar2][j]==psiccprofinabom[ar1][1] then pstimesw=psiccswitchtime[ar1][ar2][j]
		end
	end

end
end


local colorname=psiccdamagenames[ar1][ar2][i]

local tablecolor={"|CFFC69B6D","|CFFC41F3B","|CFFF48CBA","|CFFFFFFFF","|CFF1a3caa","|CFFFF7C0A","|CFFFFF468","|CFF68CCEF","|CFF9382C9","|CFFAAD372"}

if rsccodeclass==nil then rsccodeclass=0 end

if rsccodeclass>0 then
colorname=tablecolor[rsccodeclass]..psiccdamagenames[ar1][ar2][i].."|r"
end


if i==maxnick then
	psstrochka=psstrochka..colorname.." ("..psinfoshieldtempdamage.." - "..pstimesw.."s)"..pstochki
	psiccdmgtxt1:SetText(psstrochka)
	psiccdmgtxt2:SetText(psicccombatinfo[ar1])
else
	psstrochka=psstrochka..colorname.." ("..psinfoshieldtempdamage.." - "..pstimesw.."s), "
end
end

end



end-- prof







--определяем тип боя
if psiccindexboss[ar1]==2 then


--council
local psstrochka="|CFFFFFF00"..psicceventsnames[ar1][ar2]..": |r"
local maxnick=0
for i=1,#psiccswitchtime[ar1][ar2] do
if psiccswitchtime[ar1][ar2][i]=="--" then else maxnick=maxnick+1
end
end
local items = {psiccall, 5, 7, 10, 12, 15, 17, 20}
local pstochki="."


if psiccdmg3==1 then else
if items[psiccdmg3]<maxnick then
maxnick=items[psiccdmg3]
pstochki=", ..."
end
end


psicccouncilsort(ar1,ar2)


if #pscounciltablesort1>0 then
for i = 1,maxnick do

local pstimesw="??"
local rsccodeclass=0

rsccodeclass=pscounciltablesort3[i]
pstimesw=pscounciltablesort2[i]

if rsccodeclass==nil then rsccodeclass=0 end

local colorname=pscounciltablesort1[i]

local tablecolor={"|CFFC69B6D","|CFFC41F3B","|CFFF48CBA","|CFFFFFFFF","|CFF1a3caa","|CFFFF7C0A","|CFFFFF468","|CFF68CCEF","|CFF9382C9","|CFFAAD372"}

if rsccodeclass>0 then
colorname=tablecolor[rsccodeclass]..pscounciltablesort1[i].."|r"
end


if i==maxnick then
	psstrochka=psstrochka..colorname.." ("..pstimesw.."s)"..pstochki
	psiccdmgtxt1:SetText(psstrochka)
	psiccdmgtxt2:SetText(psicccombatinfo[ar1])
else
	psstrochka=psstrochka..colorname.." ("..pstimesw.."s), "
end

end
end

table.wipe(pscounciltablesort1)
table.wipe(pscounciltablesort2)
table.wipe(pscounciltablesort3)


end-- council




end
end
end


function psciccrezetdmgshow()
psiccdmg1=nil
psiccdmg2=nil
openicccombarchoose()
openicceventchoose()
openiccquantname()
psiccdmgshow(psiccdmg1,psiccdmg2,psiccdmg3)
end





function psciccreportdmgshown(chat,ar1,ar2,ar3,boy,quant,zapusk)
if ar1==nil then ar1=psiccdmg1 end
if ar2==nil then ar2=psiccdmg2 end
if ar3==nil then ar3=psiccdmg3 end

if ar1 and ar2 then


--определяем тип боя
if psiccindexboss[ar1]==1 or psiccindexboss[ar1]==3 or psiccindexboss[ar1]==4 then


--проф & lich king & saurfang
local psstrochkab="{rt4} "..psicceventsnames[ar1][ar2].." "..psiccdmgfrom2
local psstrochka=""
local psstrochka2=""
local maxnick=#psiccdamagenames[ar1][ar2]
local items = {psiccall, 5, 7, 10, 12, 15, 17, 20}
local psinfoshieldtempdamage=0
local pstochki="."

if boy then
	if ar1==1 then
		psstrochkab=psstrochkab.." ("..pcicccombat1.."):"
	elseif ar1==2 then
		psstrochkab=psstrochkab.." ("..pcicccombat2.."):"
	elseif ar1==3 then
		psstrochkab=psstrochkab.." ("..pcicccombat3.."):"
	end
else
psstrochkab=psstrochkab..":"
end


if ar3==1 then else
if items[ar3]<maxnick then
maxnick=items[ar3]
pstochki=", ..."
end
end



if #psiccdamagenames[ar1][ar2]>0 then
for i = 1,maxnick do

	if (string.len(psiccdamagevalues[ar1][ar2][i])) > 3 then
	psinfoshieldtempdamage=string.sub(psiccdamagevalues[ar1][ar2][i], 1, string.len(psiccdamagevalues[ar1][ar2][i])-3) psinfoshieldtempdamage=psinfoshieldtempdamage.."k"
	else
	psinfoshieldtempdamage=psiccdamagevalues[ar1][ar2][i]
	end

local pstimesw="??"


	for j=1,#psiccswitchnames[ar1][ar2] do
		if psiccswitchnames[ar1][ar2][j]==psiccdamagenames[ar1][ar2][i] then pstimesw=psiccswitchtime[ar1][ar2][j]
		end
	end

--abom
if psiccindexboss[ar1]==1 then
if pstimesw=="??" and psiccdamagenames[ar1][ar2][i]==psiccprofadd then

	for j=1,#psiccswitchnames[ar1][ar2] do
		if psiccswitchnames[ar1][ar2][j]==psiccprofinabom[ar1][1] then pstimesw=psiccswitchtime[ar1][ar2][j]
		end
	end

end
end


if i==maxnick then
	if string.len(psstrochka)>230 and quant==2 then
	psstrochka2=psstrochka2..psiccdamagenames[ar1][ar2][i].." ("..psinfoshieldtempdamage.." - "..pstimesw.."s)"..pstochki
	else
	psstrochka=psstrochka..psiccdamagenames[ar1][ar2][i].." ("..psinfoshieldtempdamage.." - "..pstimesw.."s)"..pstochki
	end
	if zapusk then
	pszapuskanonsa(chat, psstrochkab)
	pszapuskanonsa(chat, psstrochka)
	pszapuskanonsa(chat, psstrochka2)
	else
	psfchatsendreports(chat, psstrochkab, psstrochka, psstrochka2)
	end
else
	if string.len(psstrochka)>230 and quant==2 then
	psstrochka2=psstrochka2..psiccdamagenames[ar1][ar2][i].." ("..psinfoshieldtempdamage.." - "..pstimesw.."s), "
	else
	psstrochka=psstrochka..psiccdamagenames[ar1][ar2][i].." ("..psinfoshieldtempdamage.." - "..pstimesw.."s), "
	end
end
end

end



end-- prof


--определяем тип боя
if psiccindexboss[ar1]==2 then


--council
local psstrochka="{rt4}"..psicceventsnames[ar1][ar2]
local psstrochka2=""
local maxnick=0
for i=1,#psiccswitchtime[ar1][ar2] do
if psiccswitchtime[ar1][ar2][i]=="--" then else maxnick=maxnick+1
end
end
local items = {psiccall, 5, 7, 10, 12, 15, 17, 20}
local pstochki="."


if psiccdmg3==1 then else
if items[psiccdmg3]<maxnick then
maxnick=items[psiccdmg3]
pstochki=", ..."
end
end

if boy then
	if ar1==1 then
		psstrochka=psstrochka.." ("..pcicccombat1.."): "
	elseif ar1==2 then
		psstrochka=psstrochka.." ("..pcicccombat2.."): "
	elseif ar1==3 then
		psstrochka=psstrochka.." ("..pcicccombat3.."): "
	end
else
psstrochka=psstrochka..": "
end


psicccouncilsort(ar1,ar2)


if #pscounciltablesort1>0 then
for i = 1,maxnick do

local pstimesw="??"

pstimesw=pscounciltablesort2[i]

if i==maxnick then
	if string.len(psstrochka)>230 and quant==2 then
	psstrochka2=psstrochka2..pscounciltablesort1[i].." ("..pstimesw.."s)"..pstochki
	else
	psstrochka=psstrochka..pscounciltablesort1[i].." ("..pstimesw.."s)"..pstochki
	end
	if zapusk then
	pszapuskanonsa(chat, psstrochka)
	pszapuskanonsa(chat, psstrochka2)
	else
	psfchatsendreports(chat, psstrochka, psstrochka2)
	end
else
	if string.len(psstrochka)>230 and quant==2 then
	psstrochka2=psstrochka2..pscounciltablesort1[i].." ("..pstimesw.."s), "
	else
	psstrochka=psstrochka..pscounciltablesort1[i].." ("..pstimesw.."s), "
	end
end

end
end

table.wipe(pscounciltablesort1)
table.wipe(pscounciltablesort2)
table.wipe(pscounciltablesort3)


end-- council



end
end

function psdamginforezet()
if isbattlev==0 then

psiccdamagenames={{},{},{}}
psiccdamagevalues={{},{},{}}
psiccswitchnames={{},{},{}}
psiccswitchtime={{},{},{}}
psicceventsnames={{},{},{}}
psiccindexclass={{},{},{}}
psiccprofinabom={{},{},{}}

table.wipe(psicccombatinfo)
table.wipe(psiccindexboss)



psciccrezetdmgshow()




else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psiccnorezetincombat)
end
end


function psiccupdatetable(info,nr)

if psiccquantooze==nil then psiccquantooze={} end
table.wipe(psiccquantooze)

--переносим предыдущее инфо
table.insert(psiccdamagenames,1,{})
psiccdamagenames[4]=nil

table.insert(psiccdamagevalues,1,{})
psiccdamagevalues[4]=nil

table.insert(psiccswitchnames,1,{})
psiccswitchnames[4]=nil

table.insert(psiccswitchtime,1,{})
psiccswitchtime[4]=nil

table.insert(psicceventsnames,1,{})
psicceventsnames[4]=nil

table.insert(psicccombatinfo,1,info)
psicccombatinfo[4]=nil

table.insert(psiccindexboss,1,nr)
psiccindexboss[4]=nil

table.insert(psiccindexclass,1,{})
psiccindexclass[4]=nil

table.insert(psiccprofinabom,1,{})
psiccprofinabom[4]=nil

end


function psicccouncilsort(ar1,ar2)
pscounciltablesort1={}
pscounciltablesort2={}
pscounciltablesort3={}
table.wipe(pscounciltablesort1)
table.wipe(pscounciltablesort2)
table.wipe(pscounciltablesort3)

for i=1,#psiccswitchtime[ar1][ar2] do
if psiccswitchtime[ar1][ar2][i]=="--" then else
table.insert(pscounciltablesort1,psiccswitchnames[ar1][ar2][i])
table.insert(pscounciltablesort2,psiccswitchtime[ar1][ar2][i])
table.insert(pscounciltablesort3,psiccindexclass[ar1][ar2][i])


local vzxnn= #pscounciltablesort1
while vzxnn>1 do
if pscounciltablesort2[vzxnn]<pscounciltablesort2[vzxnn-1] then
local vezaxtemp1=pscounciltablesort2[vzxnn-1]
local vezaxtemp2=pscounciltablesort1[vzxnn-1]
local vezaxtemp3=pscounciltablesort3[vzxnn-1]
pscounciltablesort2[vzxnn-1]=pscounciltablesort2[vzxnn]
pscounciltablesort1[vzxnn-1]=pscounciltablesort1[vzxnn]
pscounciltablesort3[vzxnn-1]=pscounciltablesort3[vzxnn]
pscounciltablesort2[vzxnn]=vezaxtemp1
pscounciltablesort1[vzxnn]=vezaxtemp2
pscounciltablesort3[vzxnn]=vezaxtemp3
end
vzxnn=vzxnn-1
end


end
end

end