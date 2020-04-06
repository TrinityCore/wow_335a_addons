-- Author: Shurshik
-- http://phoenix-wow.ru

function psfUlduar()


pslocaleulduar()
pslocaleulduarui()
pslocaleuldaboss()

nick={" ",
" ",
" ",
" ",
" ",
" ",
" ",
" ",
" ",
" ",
" ",
" ",
" ",
" ",
" ",
}
if yoggspisokp==nil then yoggspisokp={} end
yoggspisokraid={"пусто",
}

	arg9 = "text"
	arg10 = "text"
	timealgaloncast=0
	metkaonwho = "text"
	pslevibot=false
	timelastlevireload=0
	kakayavisadka=1
	sumheal=0
	timebuff1=0
	timebuff2=0
	timerez1=0
	spammvar=0
	whodispeled1="0"
	topvezaxname1="text"
	topvezaxname2="text"
	topvezaxname3="text"
	topvezaxheal1=0
	topvezaxheal2=0
	topvezaxheal3=0
	topvezaxdeb1=""
	topvezaxdeb2=""
	topvezaxdeb3=""
	wasdebufgena=false
	wasdebuffgena=""
	timehealvez=0
	timelastnapalm=0
	ifwasnapalm1=0
	timenapalm2=0
	napalmnumnoobs={}
	ifthiswassovet=0
	timebuff3=0
	fromwhodispeled="0"

	if whererepbossulda==nil then whererepbossulda={"raid","raid","raid","raid","raid","raid","raid"} end
	if bosspartul==nil then bosspartul={1,1,1,1,1,1,1} end
	if bosspartul2==nil then bosspartul2={1,1,1,1,1} end
	if(wherereportlevichat1==nil) then wherereportlevichat1="raid" end
	if(wherereportlevichat2==nil) then wherereportlevichat2="raid" end
	if(wherereportyogg==nil) then wherereportyogg="raid" end
	if(primyogg==nil) then primyogg="" end


if GetRealZoneText()==pszoneulduar then
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
	this:RegisterEvent("PLAYER_REGEN_DISABLED")
	this:RegisterEvent("PLAYER_REGEN_ENABLED")
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA")



end






function psfUlduaronevent()

if event == "PLAYER_REGEN_DISABLED" then

	vezaxboyinterr=0
	leviboyinterr=0
	alginterr=0
	xtboyinterr=0
	torimboyinterr=0
	whodispeled1="0"
	timebuff1=0
	timebuff2=0
	timebuff3=0
	timerez1=0
	spammvar=0
	ifwasnapalm1=0
	timelastnapalm=0
	timenapalm2=0
	napalmnumnoobs={}
	ifthiswassovet=0
	timebuff3=0
	fromwhodispeled="0"
	kolyoggaddov=0
	psyoggstrajtime=0

end

if event == "PLAYER_REGEN_ENABLED" then
	if(wasornovezax==1) then vezaxboyinterr=1 end
	if(ifwaslevi==1) then leviboyinterr=1 end
	if(wasornoalg==1)then alginterr=1 end
	if(wasornoxt==1)then xtboyinterr=1 end
	if(wasornotorim==1)then torimboyinterr=1 end
end

if event == "ZONE_CHANGED_NEW_AREA" then

if(leviboyinterr==1)then
psflevirezetvipe()
psflevimarksdown()
end

if (vezaxboyinterr==1) then
psfvezaxafterf()
psfvezaxrezetall()
end

if (alginterr==1) then
psfalgreport()
psfalgrezetall()
end

if (xtboyinterr==1) then
psfxtafterf()
psfxtresetall()
end

if (torimboyinterr==1) then
psftorimafterf()
psftorimresetall()
end


if GetRealZoneText()==pszoneulduar then
PhoenixStyleMod_Ulduar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
else
PhoenixStyleMod_Ulduar:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

end



if GetNumRaidMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

--ЛЕВИАФАН АВТОБОТ
if(pslevibot and ifwaslevi==0) then
if (arg4==psulleviafanchik or arg7==psulleviafanchik) and (arg2=="SPELL_CAST_SUCCESS" or arg2=="SPELL_DAMAGE" or arg2=="SPELL_PERIODIC_DAMAGE" or arg2=="SPELL_MISSED") then
ifwaslevi=1
PSF_getnamelevi()
SendChatMessage(psullevitxt6..": {rt4}"..nick[7]..", {rt3}"..nick[8]..", {rt1}"..nick[9].." >>>"..pslevidesgogo.."<<<", "raid_warning")
SetRaidTarget(nick[7], 4)
SetRaidTarget(nick[8], 3)
SetRaidTarget(nick[9], 1)
end
end

if(leviboyinterr==1)then
if(timetocheck==0) then timetocheck=arg1+5
elseif(arg7 == psulleviafanchik or arg4 == psulleviafanchik) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psflevirezetvipe()
psflevimarksdown()
end
end

--перезагрузка
if (pslevibot and ifwaslevi==1) then
if arg9==62475 and arg2=="SPELL_AURA_APPLIED" and arg7==psulleviafanchik then
PSF_getnamelevi()
SendChatMessage(psulleviinfo11.." "..nick[13].." {rt4} "..psullevito.." {rt5}.   "..nick[14].." {rt3} "..psullevito.." {rt2}.   "..nick[15].." {rt1} "..psullevito.." {rt6}.", "raid")
if(kakayavisadka==1) then kakayavisadka=2 elseif (kakayavisadka==2) then kakayavisadka=1 end
end
end

if (pslevibot and ifwaslevi==1) then
if arg9==62475 and arg2=="SPELL_AURA_REMOVED" and arg7==psulleviafanchik then
--перезагрузка закончилась
PSF_getnamelevi()
timelastlevireload=arg1+6
if(kakayavisadka==1) then
SendChatMessage(psullevitxt6..": {rt4}"..nick[7]..", {rt3}"..nick[8]..", {rt1}"..nick[9].." >>>"..pslevidesgogo.."<<<", "raid_warning")
for i = 1,3 do
if nick[i+6]==" " then else SendChatMessage("PhoenixStyle > "..pslevitimetodie, "WHISPER", nil, nick[i+6]) end
end
elseif(kakayavisadka==2) then
SendChatMessage(psullevitxt7..": {rt4}"..nick[10]..", {rt3}"..nick[11]..", {rt1}"..nick[12].." >>>"..pslevidesgogo.."<<<", "raid_warning")
for i = 1,3 do
if nick[i+9]==" " then else SendChatMessage("PhoenixStyle > "..pslevitimetodie, "WHISPER", nil, nick[i+9]) end
end
end --какаявысадка

end
end

if (pslevibot and ifwaslevi==1 and arg2=="UNIT_DIED" and arg7==psulleviafanchik) then
psfleverezetwin()
psflevimarksdown()
end


--вешать марки на десант
if (timelastlevireload>0) then
if (timelastlevireload>arg1) then
PSF_getnamelevi()
timelastlevireload=0
if(kakayavisadka==1)then
SetRaidTarget(nick[7], 4)
SetRaidTarget(nick[8], 3)
SetRaidTarget(nick[9], 1)
elseif(kakayavisadka==2) then
SetRaidTarget(nick[10], 4)
SetRaidTarget(nick[11], 3)
SetRaidTarget(nick[12], 1)
end

end
end



if (vezaxboyinterr==1) then
if(timetocheck==0) then timetocheck=arg1+5
elseif(arg7 == psulgeneralvezax or arg7 == psulsaronite) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psfvezaxafterf()
psfvezaxrezetall()
end
end


if (alginterr==1) then
if(timetocheck==0) then timetocheck=arg1+5
elseif(arg7 == psulalgalon) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psfalgreport()
psfalgrezetall()
end
end

if (xtboyinterr==1) then
if(timetocheck==0) then timetocheck=arg1+5
elseif(arg7 == psyoggfail1 or arg7 == psyoggfail2 or arg7 == psyoggfail3 or arg4 == psyoggfail1 or arg4 == psyoggfail2 or arg4 == psyoggfail3) then timetocheck=arg1+8
elseif(arg1>timetocheck)then
psfxtafterf()
psfxtresetall()
end
if(arg2=="UNIT_DIED" and arg7==psyoggfail2) then
psfxtafterf()
psfxtresetall()
end
end



if (torimboyinterr==1) then
if(timetocheck==0) then timetocheck=arg1+5
elseif(arg7 == psultorim) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psftorimafterf()
psftorimresetall()
end
end



--АЛГАЛОН
if arg2 == "SPELL_CAST_START" and (arg9 == 64584 or arg9 == 64443) then
timealgaloncast=arg1+8
end

if (arg9 == 62169 or arg9 == 62168) and arg2 == "SPELL_AURA_APPLIED" then
algalonname=arg4
if(timealgaloncast==0) then
psfalgalon()
end
end

if (timealgaloncast>0) then
if (arg1>timealgaloncast) then
timealgaloncast=0
end
end


--марка отхила везакса
if (arg9 == 63276 or arg9 == 63278) then
psfvezaxheal()
end


--проверка таймер на хил Везакса марки
if (wasornovezax==1 and timehealvez > 0) then
if (arg1>timehealvez) then
psfvezaxreportheal()
end end


--Везакс краш
if arg9 == 62659 and (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) then
psfvezaxcrash()
end

--Йогг сарон
if (arg9 == 63884 or arg9 == 63891) and (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) then
psfxtnoob()
end

if arg9 == 64168 and arg2 == (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) then
psfxtnoob2()
end

if arg9 == 64164 and arg2 == (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) then
psfxtnoob3()
end



--молнии на ториме
if arg9 == 62466 and (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) then
psftorimnoob()
end

--Совет диспел мт
if (arg9 == 63493 or arg12 == 63493 or arg9==61903 or arg12==61903) then
psfsovetdis()
end


--таймер после диспела на совете
if (ifthiswassovet==1) then
if timebuff3>0 and arg1>timebuff3 then
psfsovettimeaft()
end end 


--МИМИРОН проверка на получение 2+ напалмов
if (arg9 == 65026 or arg9 ==63666) then
psfmimidetectnoob()
end



--часть под мимирона
if (timenapalm2>0) then
if ifwasnapalm1==1 and arg1>timenapalm2 then
psfmimireportnoob()
end
end



--ходир попадание в заморозку
if isbattlev == 1 and (arg9 == 61969 or arg9 == 61990) then
psfhodirnoob()
end




--йогг счет аддов

if thisaddononoff and bosspartul[6]==1 and bosspartul2[4]==1 then


if arg2=="SPELL_DAMAGE" and arg9==65719 and arg7==psyoggfail3 then
kolyoggaddov=kolyoggaddov+1

if kolyoggaddov==5 or kolyoggaddov==6 then
if(whererepbossulda[6]=="sebe")then
DEFAULT_CHAT_FRAME:AddMessage("- "..psulyoggguard1.." "..(8-kolyoggaddov))
else
	if kolyoggaddov==5 then
pszapuskanonsa(whererepbossulda[6], psulyoggguard1.." "..(8-kolyoggaddov), nil, 1)
	elseif kolyoggaddov==6 then

if psanonceinst then
psyogginstango(psulyoggguard1.." "..(8-kolyoggaddov))
end

	end
end
end

if kolyoggaddov==7 then

if(whererepbossulda[6]=="sebe")then
DEFAULT_CHAT_FRAME:AddMessage("- "..psulyoggguard1.." "..(8-kolyoggaddov))
else
if(IsRaidOfficer()==1 or psfnopromrep) then
	if (whererepbossulda[6]=="raid" and IsRaidOfficer()==1) then
if psanonceinst then
SendChatMessage(psulyoggguard1.." "..(8-kolyoggaddov), "raid_warning")
end
	else
if psanonceinst then
psyogginstango(psulyoggguard1.." "..(8-kolyoggaddov))
end

	end
else psfnotofficer() end
end

end

if kolyoggaddov==8 then

if(whererepbossulda[6]=="sebe")then
DEFAULT_CHAT_FRAME:AddMessage("- "..psulyoggguard2)
else
if(IsRaidOfficer()==1 or psfnopromrep) then
	if (whererepbossulda[6]=="raid" and IsRaidOfficer()==1) then
if psanonceinst then
SendChatMessage(psulyoggguard2, "raid_warning")
end
	else
if psanonceinst then
psyogginstango(psulyoggguard2)
end

	end
else psfnotofficer() end
end

end
end



--смерть адда

if arg2=="UNIT_DIED" and arg7==psyoggfail4 and kolyoggaddov<8 then
psyoggstrtime2=arg1+1
psyoggstrajtime=1
end

--таймер

if psyoggstrajtime==1 then

if arg2=="SPELL_DAMAGE" and arg9==65719 and arg7==psyoggfail3 then
psyoggstrajtime=0
end
if arg1>psyoggstrtime2 then
psyoggstrajtime=0
if (whererepbossulda[6]=="raid" and IsRaidOfficer()==1) then
pszapuskanonsa("raid_warning", "{rt8}"..psulyoggguard3)
else
pszapuskanonsa(whererepbossulda[6], "{rt8}"..psulyoggguard3)
end
end

end

end --конец йогга аддов



end --ульдуара

end --КОНЕЦ ОНЕВЕНТ



function openmenugeneral()
if not DropDownMenuGeneral then
CreateFrame("Frame", "DropDownMenuGeneral", PSFmain6, "UIDropDownMenuTemplate")
end
pscreatedropul(DropDownMenuGeneral,130,-31,1)
end

function openmenumimiron()
if not DropDownMenuMimiron then
CreateFrame("Frame", "DropDownMenuMimiron", PSFmain6, "UIDropDownMenuTemplate")
end
pscreatedropul(DropDownMenuMimiron,130,-80,2)
end

function openmenustal()
if not DropDownMenuStal then
CreateFrame("Frame", "DropDownMenuStal", PSFmain6, "UIDropDownMenuTemplate")
end
pscreatedropul(DropDownMenuStal,130,-129,3)
end

function openmenuhodir()
if not DropDownMenuHodir then
CreateFrame("Frame", "DropDownMenuHodir", PSFmain6, "UIDropDownMenuTemplate")
end
pscreatedropul(DropDownMenuHodir,130,-178,4)
end


function openmenualg()
if not DropDownMenuAlg then
CreateFrame("Frame", "DropDownMenuAlg", PSFmain6, "UIDropDownMenuTemplate")
end
pscreatedropul(DropDownMenuAlg,130,-227,5)
end


function openmenuxt()
if not DropDownMenuxt then
CreateFrame("Frame", "DropDownMenuxt", PSFmain6, "UIDropDownMenuTemplate")
end
pscreatedropul(DropDownMenuxt,130,-276,6)
end

function openmenutorim()
if not DropDownMenutorim then
CreateFrame("Frame", "DropDownMenutorim", PSFmain6, "UIDropDownMenuTemplate")
end
pscreatedropul(DropDownMenutorim,130,-325,7)
end


function PSF_closeallprUlduar()
PSFmain6:Hide()
PSFmain8:Hide()
PSFmain11:Hide()
end


function PSF_buttonulda2()
PSF_closeallpr()
openmenugeneral()
openmenumimiron()
openmenustal()
openmenuhodir()
openmenualg()
openmenuxt()
openmenutorim()
psfuldraw()
psfcheckbossescolors()
PSFmain6:Show()
framewasinuse4=1
end


function PSF_buttonleviafan()
PSF_closeallpr()
PSFmain8:Show()
framewasinuse8=1
end

function PSF_buttonyogg()
PSF_closeallpr()
PSFmain11:Show()
framewasinuse11=1
psyoggwisps=1
if (portalboss) then openmenuyogg11() end
end

function PSFizmulda(nn)
if bosspartul[nn]==0 then bosspartul[nn]=1 else bosspartul[nn]=0 end
psfcheckbossescolors()
end

function PSFizmulda1(nn)
if bosspartul2[nn]==0 then bosspartul2[nn]=1 else bosspartul2[nn]=0 end
end


function psfuldraw()
if psfuldraw1==nil then
psfuldraw1=1

--вкл
for i=1,7 do
local t = PSFmain6:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",20,10-49*i)
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(psulvkl)
t:SetJustifyH("LEFT")
end

--канал чата
for i=1,7 do
local t = PSFmain6:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",70,10-49*i)
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(psulchatch)
t:SetJustifyH("LEFT")
end


psulbosstxt1 = PSFmain6:CreateFontString()
psulbosstxt2 = PSFmain6:CreateFontString()
psulbosstxt3 = PSFmain6:CreateFontString()
psulbosstxt4 = PSFmain6:CreateFontString()
psulbosstxt5 = PSFmain6:CreateFontString()
psulbosstxt6 = PSFmain6:CreateFontString()
psulbosstxt7 = PSFmain6:CreateFontString()
local psfbosstemmp={psulbosstxt1,psulbosstxt2,psulbosstxt3,psulbosstxt4,psulbosstxt5,psulbosstxt6,psulbosstxt7}
for i=1,7 do
psulcreatbosstxt(psfbosstemmp[i], i)
end

--описание
local pstabtodraw2={psulbossinfo1,psulbossinfo2,psulbossinfo3,psulbossinfo4,psulbossinfo5,psulbossinfo6,psulbossinfo7}
for i=1,7 do
local t = PSFmain6:CreateFontString()
t:SetWidth(450)
t:SetHeight(15)
t:SetFont(GameFontNormal:GetFont(), 10)
t:SetPoint("TOPLEFT",140,32-49*i)
t:SetTextColor(1,1,1,1)
t:SetText(pstabtodraw2[i])
t:SetJustifyH("LEFT")
end

--после боя
local pstabtodraw2={psulonlyattheend,nil,psulonlyattheendstal,nil,psulonlyattheend,psulonlyattheendyogg1,psulonlyattheend}
for i=1,7 do
if pstabtodraw2[i] then
local t = PSFmain6:CreateFontString()
	if GetLocale() == "deDE" then
t:SetFont(GameFontNormal:GetFont(), 10)
	else
t:SetFont(GameFontNormal:GetFont(), 12)
	end
t:SetPoint("TOPLEFT",275,10-49*i)
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(pstabtodraw2[i])
t:SetJustifyH("LEFT")
end
end

--рысочка
for i=1,7 do
local t = PSFmain6:CreateTexture(nil,"OVERLAY")
t:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Divider")
t:SetPoint("TOP",24,-10-49*i)
t:SetWidth(250)
t:SetHeight(15)
end

--чекбатон1
PSFmain6_CheckButton201 = CreateFrame("CheckButton", nil, PSFmain6, "UICheckButtonTemplate")
PSFmain6_CheckButton202 = CreateFrame("CheckButton", nil, PSFmain6, "UICheckButtonTemplate")
PSFmain6_CheckButton203 = CreateFrame("CheckButton", nil, PSFmain6, "UICheckButtonTemplate")
PSFmain6_CheckButton204 = CreateFrame("CheckButton", nil, PSFmain6, "UICheckButtonTemplate")
PSFmain6_CheckButton205 = CreateFrame("CheckButton", nil, PSFmain6, "UICheckButtonTemplate")
PSFmain6_CheckButton206 = CreateFrame("CheckButton", nil, PSFmain6, "UICheckButtonTemplate")
PSFmain6_CheckButton207 = CreateFrame("CheckButton", nil, PSFmain6, "UICheckButtonTemplate")
local psulchbaton1={PSFmain6_CheckButton201,PSFmain6_CheckButton202,PSFmain6_CheckButton203,PSFmain6_CheckButton204,PSFmain6_CheckButton205,PSFmain6_CheckButton206,PSFmain6_CheckButton207}
for i=1,7 do
psulsozdcb1(psulchbaton1[i],45,16-49*i,i)
end



end
end

function psulcreatbosstxt(rt, i)
rt:SetWidth(125)
rt:SetHeight(15)
rt:SetFont(GameFontNormal:GetFont(), 12)
rt:SetPoint("TOPLEFT",20,30-49*i)
rt:SetText(" ")
rt:SetJustifyH("LEFT")
end




function pscreatedropul(fff,xx,yy,cc)

fff:ClearAllPoints()
fff:SetPoint("TOPLEFT", xx, yy)
fff:Show()

local items = bigmenuchatlist

local function OnClick(self)
UIDropDownMenu_SetSelectedID(fff, self:GetID())

if self:GetID()>8 then
whererepbossulda[cc]=psfchatadd[self:GetID()-8]
else
whererepbossulda[cc]=bigmenuchatlisten[self:GetID()]
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

bigmenuchat2(whererepbossulda[cc])
if bigma2num==0 then
whererepbossulda[cc]=bigmenuchatlisten[1]
bigma2num=1
end

UIDropDownMenu_Initialize(fff, initialize)
UIDropDownMenu_SetWidth(fff, 85)
UIDropDownMenu_SetButtonWidth(fff, 100)
UIDropDownMenu_SetSelectedID(fff, bigma2num)
UIDropDownMenu_JustifyText(fff, "LEFT")
end



function psfcheckbossescolors()
local psfzelkras={
{PSFmain6_CheckButton201,psulbosstxt1,psulgeneralvezax},
{PSFmain6_CheckButton202,psulbosstxt2,psulmimiron},
{PSFmain6_CheckButton203,psulbosstxt3,psulsovet},
{PSFmain6_CheckButton204,psulbosstxt4,psulhodir},
{PSFmain6_CheckButton205,psulbosstxt5,psulalgalon2},
{PSFmain6_CheckButton206,psulbosstxt6,psulxt02},
{PSFmain6_CheckButton207,psulbosstxt7,psulthorim2},
}
for i=1,7 do
if(bosspartul[i]==1)then psfzelkras[i][1]:SetChecked() psfzelkras[i][2]:SetText("|cff00ff00"..psfzelkras[i][3].."|r") else psfzelkras[i][2]:SetText("|cffff0000"..psfzelkras[i][3].."|r") psfzelkras[i][1]:SetChecked(false) end
end
if(bosspartul2[3]==1)then PSFmain6_CheckButton215:SetChecked(false) else PSFmain6_CheckButton215:SetChecked() end
if(bosspartul2[4]==1)then PSFmain6_CheckButton216:SetChecked(false) else PSFmain6_CheckButton216:SetChecked() end
if(bosspartul2[1]==1)then PSFmain6_CheckButton211:SetChecked(false) else PSFmain6_CheckButton211:SetChecked() end
if(bosspartul2[5]==1)then PSFmain6_CheckButton217:SetChecked(false) else PSFmain6_CheckButton217:SetChecked() end
if(bosspartul2[2]==1)then PSFmain6_CheckButton213:SetChecked(false) else PSFmain6_CheckButton213:SetChecked() end
end

function pslevidropmakechat(aa,ww,hh,ee,ii)
aa:ClearAllPoints()
aa:SetPoint("TOPLEFT", ww, hh)
aa:Show()
local items = bigmenuchatlist
local function OnClick(self)
UIDropDownMenu_SetSelectedID(aa, self:GetID())

local oo="raid"
if self:GetID()>8 then
oo=psfchatadd[self:GetID()-8]
else
oo=bigmenuchatlisten[self:GetID()]
end

if ii==1 then
wherereportlevichat1=oo
elseif ii==2 then
wherereportlevichat2=oo
elseif ii==3 then
wherereportyogg=oo
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

bigmenuchat2(ee)
if bigma2num==0 then
local ooo=bigmenuchatlisten[1]
if ii==1 then
wherereportlevichat1=ooo
elseif ii==2 then
wherereportlevichat2=ooo
elseif ii==3 then
wherereportyogg=ooo
end
bigma2num=1
end

UIDropDownMenu_Initialize(aa, initialize)
UIDropDownMenu_SetWidth(aa, 85);
UIDropDownMenu_SetButtonWidth(aa, 100)
UIDropDownMenu_SetSelectedID(aa,bigma2num)
UIDropDownMenu_JustifyText(aa, "LEFT")
end

function psulsozdcb1(c,ww,hh,oo)
c:SetWidth("25")
c:SetHeight("25")
c:SetPoint("TOPLEFT", ww, hh)
c:SetScript("OnClick", function(self) PSFizmulda(oo) end )
end


function psyogginstango(rep)
local bililine=0
for i,cc in ipairs(bigmenuchatlisten) do 
if cc == whererepbossulda[6] then bililine=1
end end

	if bililine==1 then
SendChatMessage(rep, whererepbossulda[6])
	else
local nrchatmy=GetChannelName(whererepbossulda[6])
		if nrchatmy==0 then
	JoinPermanentChannel(whererepbossulda[6])
	ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, whererepbossulda[6])
	nrchatmy=GetChannelName(whererepbossulda[6])
		end
if nrchatmy>0 then
SendChatMessage(rep, "CHANNEL",nil,nrchatmy)
end
	end
end