
function PSF_iccsaurfang()
	if psicgalochki[1][1]==1 then
PSF_closeallpr()
PSFiccsaurf:Show()
framesaurfused=1

PSFiccsaurf_Textmark2:Hide()
PSFiccsaurf_Textmark22:Hide()
PSFiccsaurf_Button2:Hide()
PSFiccsaurf_Button22:Hide()

if psiccsauractiv then
PSFiccsaurf_Textmark22:Show()
PSFiccsaurf_Button22:Show()
else
PSFiccsaurf_Textmark2:Show()
PSFiccsaurf_Button2:Show()
end


if psfsaurfdaw1==nil then
psfsaurfdaw1=1
PSFiccsaurf_Textmark22:SetFont(GameFontNormal:GetFont(), 15)
PSFiccsaurf_Textmark2:SetFont(GameFontNormal:GetFont(), 15)
for i=1,8 do
local t = PSFiccsaurf:CreateTexture(nil,"OVERLAY")
t:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_"..i)
t:SetPoint("TOPLEFT",27,-75-i*25)
t:SetWidth(20)
t:SetHeight(20)
end

psicsaurfedittable={}
local psebf1 = CreateFrame("EditBox", "psebs1", PSFiccsaurf,"InputBoxTemplate")
pseditframecreats(psebf1,-100,1)
local psebf2 = CreateFrame("EditBox", "psebs2", PSFiccsaurf,"InputBoxTemplate")
pseditframecreats(psebf2,-125,2)
local psebf3 = CreateFrame("EditBox", "psebs3", PSFiccsaurf,"InputBoxTemplate")
pseditframecreats(psebf3,-150,3)
local psebf4 = CreateFrame("EditBox", "psebs4", PSFiccsaurf,"InputBoxTemplate")
pseditframecreats(psebf4,-175,4)
local psebf5 = CreateFrame("EditBox", "psebs5", PSFiccsaurf,"InputBoxTemplate")
pseditframecreats(psebf5,-200,5)
local psebf6 = CreateFrame("EditBox", "psebs6", PSFiccsaurf,"InputBoxTemplate")
pseditframecreats(psebf6,-225,6)
local psebf7 = CreateFrame("EditBox", "psebs7", PSFiccsaurf,"InputBoxTemplate")
pseditframecreats(psebf7,-250,7)
local psebf8 = CreateFrame("EditBox", "psebs8", PSFiccsaurf,"InputBoxTemplate")
pseditframecreats(psebf8,-275,8)

local t = PSFiccsaurf:CreateFontString()
t:SetWidth(550)
t:SetHeight(75)
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",20,-15)
t:SetText(psiccsaufinfo)
t:SetJustifyH("LEFT")

--чекбатоны
for i=1,6 do
local c = CreateFrame("CheckButton", nil, PSFiccsaurf, "OptionsCheckButtonTemplate")
c:SetWidth("25")
c:SetHeight("25")
c:SetPoint("TOPLEFT", 240, -130-i*30)
c:SetScript("OnClick", function(self) psfsaurfgalki(i) end )
if psicsaurfgalk[i]==1 then
c:SetChecked()
end

--текст
local t = PSFiccsaurf:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 10)
t:SetText(psficcsaurtxtset[i])
t:SetPoint("TOPLEFT",265,-134-i*30)
t:SetJustifyH("LEFT")
t:SetWidth(320)
t:SetHeight(15)



end



end

psiccsaursettext8()

openmenureporticcsaurf()

	else
	out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicmodulenotena)
	end
end

function pseditframecreats(a,b,nr)
a:SetAutoFocus(false)
a:SetHeight(21)
a:SetWidth(140)
a:SetPoint("TOPLEFT", 57, b)
a:Show()
a:SetScript("OnTabPressed", function(self) if psicsaurfedittable[nr+1] then psicsaurfedittable[nr+1]:SetFocus() psicsaurfedittable[nr+1]:HighlightText() else psicsaurfedittable[1]:SetFocus() psicsaurfedittable[1]:HighlightText() end end )
a:SetScript("OnEnterPressed", function(self) psiccsauredcclfocus() end )
table.insert(psicsaurfedittable,a)
end



function psiccsaurfsave()
if psiccsauractiv==nil then
for tt=1,8 do
psiccsv4(psicsaurfedittable[tt]:GetText(), tt)
end
end
end


function psiccsv4(tt, nn)
if tt==" " or tt=="  " or tt=="   " then tt="" end
psiccsaurf[nn]=tt
if psiccsaurf[nn]=="" then else
if psiccsauractiv and UnitInRaid(psiccsaurf[nn])==nil then
out("|cff99ffffPhoenixStyle|r - |cffff0000"..psattention.."|r '|CFF00FF00"..psiccsaurf[nn].."|r' - "..psnotfoundinr)
end
end
end


function psiccsaursettext8()
for ty=1,8 do
psicsaurfedittable[ty]:SetText(psiccsaurf[ty])
end
end

function PSF_iccsaursend()
psiccsaurfsave()
psiccsaursettext8()
for i=1,8 do
	if psiccsaurf[i]=="" then else

psfchatsendreports(psicdopmodchat[1], "{rt"..i.."} "..psiccsaurf[i])

	end
end
psiccsauredcclfocus()
end



function openmenureporticcsaurf()
if not DropDownMenureporticcsaurf then
CreateFrame("Frame", "DropDownMenureporticcsaurf", PSFiccsaurf, "UIDropDownMenuTemplate")
end

DropDownMenureporticcsaurf:ClearAllPoints()
DropDownMenureporticcsaurf:SetPoint("TOPLEFT", 12, -314)
DropDownMenureporticcsaurf:Show()

local items = bigmenuchatlist

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenureporticcsaurf, self:GetID())

if self:GetID()>8 then
psicdopmodchat[1]=psfchatadd[self:GetID()-8]
else
psicdopmodchat[1]=bigmenuchatlisten[self:GetID()]
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

bigmenuchat2(psicdopmodchat[1])
	if bigma2num==0 then
psicdopmodchat[1]=bigmenuchatlisten[1]
bigma2num=1
	end

UIDropDownMenu_Initialize(DropDownMenureporticcsaurf, initialize)
UIDropDownMenu_SetWidth(DropDownMenureporticcsaurf, 70);
UIDropDownMenu_SetButtonWidth(DropDownMenureporticcsaurf, 85)
UIDropDownMenu_SetSelectedID(DropDownMenureporticcsaurf,bigma2num)
UIDropDownMenu_JustifyText(DropDownMenureporticcsaurf, "LEFT")
end


function psficcsaurfon()
psiccsaurfsave()
psiccsauredcclfocus()

if(IsRaidOfficer()==1) then

local psiccerr=0
local psiccschet=0

for i=1,8 do
if psiccsaurf[i]=="" then
else
if UnitInRaid(psiccsaurf[i]) then psiccschet=psiccschet+1 else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..psattention.."|r '|CFF00FF00"..psiccsaurf[i].."|r' - "..psnotfoundinr)
psiccerr=1
end
end
end


if psiccerr==0 then
	if psiccschet>1 then

--включается модуль

PhoenixStyleMod_Icecrown:RegisterEvent("CHAT_MSG_CHANNEL_LEAVE")
PhoenixStyleMod_Icecrown:RegisterEvent("CHAT_MSG_CHANNEL_JOIN")
psiccsauractiv=1

psmarksoff("raid")

PSFiccsaurf_Textmark11:Show()

out("|cff99ffffPhoenixStyle|r - "..psiccsaurfang..": |cff00ff00"..psmoduletxton.."|r")

--блок изменений ников
for tg=1,8 do
psicsaurfedittable[tg]:SetScript("OnTextChanged", function(self) self:SetText(psiccsaurf[tg]) end )
end


psicsaurfhealstattbl={}
table.wipe(psicsaurfhealstattbl)
psicsaufmmarkshas={}
table.wipe(psicsaufmmarkshas)
psicsaufmmarkshas={"","","","","","","",""}

for i=1,8 do

if psiccsaurf[i]=="" then
psicsaurfhealstattbl[i]=0
else
psicsaurfhealstattbl[i]=1
end
end


PSFiccsaurf_Textmark22:Show()
PSFiccsaurf_Button22:Show()
PSFiccsaurf_Textmark2:Hide()
PSFiccsaurf_Button2:Hide()


	else
	out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psiccsaurerrstr1)
	end
end


else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrornotofficer)
end

end


function psficcsaurfoff()
psiccsaurfsave()
psiccsauredcclfocus()

psiccsauractiv=nil
psiccmarkinsnospam=nil

PSFiccsaurf_Textmark11:Hide()

psiccbeforecombatleave=nil

out("|cff99ffffPhoenixStyle|r - "..psiccsaurfang..": |cffff0000"..psmoduletxtoff.."|r")

--разблок
for yy=1,8 do
psicsaurfedittable[yy]:SetScript("OnTextChanged", function(self) end )
end

PhoenixStyleMod_Icecrown:UnregisterEvent("CHAT_MSG_CHANNEL_LEAVE")
PhoenixStyleMod_Icecrown:UnregisterEvent("CHAT_MSG_CHANNEL_JOIN")

PSFiccsaurf_Textmark22:Hide()
PSFiccsaurf_Button22:Hide()
PSFiccsaurf_Textmark2:Show()
PSFiccsaurf_Button2:Show()
psicsaufmmarkshas=nil
psicsaurfhealstattbl=nil

end

function psfsaurfgalki(ii)
if psicsaurfgalk[ii]==1 then psicsaurfgalk[ii]=0 else psicsaurfgalk[ii]=1 end
end


--фейлбот:
function psficcsaurfangnoobs()
if psbossblock==nil then
pscheckwipe1(2,4)
	if pswipetrue and wasornosaurfang and psicgalochki[5][3]==1 then
		psiccbossblocked=1
		psficcsaurfangafterf()
		psficcsaurfangresetall()
	else
wasornosaurfang=1
addtotwotables(arg7)
vezaxsort1()
	end
end
end


function psficcsaurfangnoobscircle()

if psbossblock==nil and psiccbossblocked==nil then
pscheckwipe1(2,4)
	if pswipetrue and wasornosaurfang and psicgalochki[5][3]==1 then
		psiccbossblocked=1
		psficcsaurfangafterf()
		psficcsaurfangresetall()
	else
wasornosaurfang=1

psiccschet3=psiccschet3+1
psiccsaurfonblood=psiccsaurfonblood..arg7.." "

	end
end
end

function psiccsaurfdetectblood()
if psiccbossblocked==nil and psbossblock==nil then

if psiccbloodq==nil then psiccbloodq=0 end

if psiccschet3>psiccbloodq then
psiccbloodq=psiccschet3
psiccbloodn=psiccsaurfonblood
end
end
end


function psficcsaurfangafterf(ttemp)
if(psicgalochki[5][1]==1 and psicgalochki[5][2]==1)then
if #vezaxname>0 then
	if ttemp then
strochkavezcrash="{rt7} "..psiccsaurfail1
if psicgalochki[5][4]==1 then
reportafterboitwotab(whererepiccchat[psicchatchoose[5][4]], false, vezaxname, vezaxcrash, 1)
end
	else
strochkavezcrash="{rt7} "..psiccsaurfail1
reportafterboitwotab(whererepiccchat[psicchatchoose[5][2]], true, vezaxname, vezaxcrash, 1)
	end
end
end

if #vezaxname2>0 and psicgalochki[5][1]==1 and psicgalochki[5][5]==1 and ttemp==nil then
strochkavezcrash="{rt8} "..psiccsaurfail2
reportafterboitwotab(whererepiccchat[psicchatchoose[5][5]], true, vezaxname2, vezaxcrash2, 1,5)
end

if psicgalochki[5][1]==1 and psicgalochki[5][7]==1 and ttemp==nil and psiccbloodq then
if psiccbloodq==1 then
pszapuskanonsa(whererepiccchat[psicchatchoose[5][7]], "{rt3} "..psiccanons46failtxt..psiccbloodq, true)
else
pszapuskanonsa(whererepiccchat[psicchatchoose[5][7]], "{rt3} "..psiccanons46failtxt..psiccbloodq.." - "..psiccbloodn, true)
end
end

if psiccsavfile and ttemp==nil and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then

psicclastsaverep=GetTime()
psiccsavinginf(psiccsaurfang)
strochkavezcrash="{rt7} "..psiccsaurfail1
reportafterboitwotab(whererepiccchat[psicchatchoose[5][2]], true, vezaxname, vezaxcrash, 1,15,0,1)

strochkavezcrash="{rt8} "..psiccsaurfail2
reportafterboitwotab(whererepiccchat[psicchatchoose[5][5]], true, vezaxname2, vezaxcrash2, 1,5,0,1)

if psiccbloodq==1 then
pszapuskanonsa(whererepiccchat[psicchatchoose[5][7]], "{rt3} "..psiccanons46failtxt..psiccbloodq, true,nil,0,1)
else
pszapuskanonsa(whererepiccchat[psicchatchoose[5][7]], "{rt3} "..psiccanons46failtxt..psiccbloodq.." - "..psiccbloodn, true,nil,0,1)
end

psiccrefsvin()
end

end


function psficcsaurfangresetall()
wasornosaurfang=nil
timetocheck=0
iccsaurfangboyinterr=nil
psiccbloodn=nil
psiccbloodq=nil
psiccschet3=0
psiccsaurfonblood=nil
psicccouncildebsaur=nil
table.wipe(vezaxname)
table.wipe(vezaxcrash)

table.wipe(vezaxname2)
table.wipe(vezaxcrash2)

end

--енд фейлбота

function psiccsaurfmarkon(im)
if psiccsauractiv==1 then
psiccschet5=psiccschet5+1

if psiccschet5==1 then
psiccsaurfmarkslog={}
table.wipe(psiccsaurfmarkslog)
table.insert(psiccsaurfmarkslog,im)
else
table.insert(psiccsaurfmarkslog,im)
end

--проверка не реснули ли хила
psiccsaurfresheal()
--проверка онлайн хилеров
psiccsaurfallonlineorno()

psiccmarkinsnospam=nil
local i=1
local psicmetkafind=0
while i<9 do
if psicsaurfhealstattbl[i]==1 then
--хилер готов
psicmetkafind=1

if psicsaurfgalk[1]==1 then
SendChatMessage(psiccschet5.." "..psiccsaurmatka.." >> {rt"..i.."}"..im.."! << "..psiccsaurithael.." - "..psiccsaurf[i], "raid_warning")
end

if psicsaurfgalk[2]==1 then
SendChatMessage("PhoenixStyle > "..psiccsuarhealit.." {rt"..i.."}"..im, "WHISPER", nil, psiccsaurf[i])
end

SetRaidTarget(im, i)

psicsaufmmarkshas[i]=im

psicsaurfhealstattbl[i]=3

i=20
end

i=i+1
end

--все хилеры заняты
if psicmetkafind==0 then
--хилеры не готовы, проверяем уронивших
local i=1
while i<9 do
if psicsaurfhealstattbl[i]==2 then
--хилер готов
if UnitIsDead(psiccsaurf[i])==nil then
psicmetkafind=1

if psicsaurfgalk[1]==1 then
SendChatMessage(psiccschet5.." "..psiccsaurmatka.." >> {rt"..i.."}"..im.."! << "..psiccsaurithael.." - "..psiccsaurf[i], "raid_warning")
end

if psicsaurfgalk[2]==1 then
SendChatMessage("PhoenixStyle > "..psiccsuarhealit.." {rt"..i.."}"..im, "WHISPER", nil, psiccsaurf[i])
end

SetRaidTarget(im, i)

psicsaufmmarkshas[i]=im

psicsaurfhealstattbl[i]=3

i=20
end
end

i=i+1
end

--вообще все хилеры заняты
--выдать марку сообщить что нет хилера

if psicmetkafind==0 then
local nashelmet=0

local i=1
while i<9 do
	if psiccsaurf[i]=="" and psicsaufmmarkshas[i]=="" then
nashelmet=1
if psicsaurfgalk[1]==1 then
SendChatMessage("{rt8} "..psiccschet5.." "..psiccsaurmatka.." >> {rt"..i.."}"..im.."! << "..psiccsaurnohealer, "raid_warning")
end

psicsaurfhealstattbl[i]=4
SetRaidTarget(im, i)
psicsaufmmarkshas[i]=im
i=20
	end
i=i+1
end

if nashelmet==0 then
--нет места свободным меткам без хилов, проверяем хилеров что не лечат
local i=1
while i<9 do
	if psicsaufmmarkshas[i]=="" then

	nashelmet=1
	local prichina=psiccsaurdisc2
	if psicsaurfhealstattbl[i]==5 then prichina=psiccsaurdied end
	if psicsaurfgalk[5]==1 then
	SendChatMessage("{rt8} "..psiccschet5.." "..psiccsaurmatka.." >> {rt"..i.."}"..im.."! << "..psiccsaurithael.." "..psiccsaurf[i].." ("..prichina.."). "..psiccsaurhelp, "raid_warning")
	end
	SetRaidTarget(im, i)
	psicsaufmmarkshas[i]=im
	i=20
	end
i=i+1
end
end

if nashelmet==0 then
	if psicsaurfgalk[5]==1 then
	SendChatMessage("{rt8} "..psiccschet5.." "..psiccsaurmatka.." >>> "..im.."! <<< "..psiccsaurerr1, "raid_warning")
	end
end



end
end





end
end


function psicconbosssaurdead(im)
local psiccscheck22=1
--проверка хилеров
for i=1,8 do
if psiccsaurf[i]==im then
psicsaurfhealstattbl[i]=5
psfwipecheck()
		if psiccscheck22 then
		psicscetchik=psicscetchik+1
		psiccscheck22=nil
		end
	if psicsaufmmarkshas[i]=="" or psiccsaurf[i]==psicsaufmmarkshas[i] then else
if psicsaurfgalk[5]==1 then
if psicscetchik<4 and psnumdead<6 then
SendChatMessage(im.." "..psiccsaurerr2.." >> {rt"..i.."}"..psicsaufmmarkshas[i].." <<", "raid_warning")
end
end
	end

end
end

--проверка меток
for i=1,8 do
if psicsaufmmarkshas[i]==im then


for uu = 1,GetNumRaidMembers() do local name, _, _, _, _, _, _, _, isDead = GetRaidRosterInfo(uu)

	if (name==im and isDead) then




psfwipecheck()

if psicsaurfhealstattbl[i]==3 then
psicsaurfhealstattbl[i]=2
end

psicsaufmmarkshas[i]=""
if psicsaurfgalk[5]==1 then
if psicscetchik<4 and psnumdead<6 then
if psiccsaurf[i]=="" then else

local nrmetki=0
if psiccsaurfmarkslog and #psiccsaurfmarkslog>0 then
	for tt=1,#psiccsaurfmarkslog do
		if psiccsaurfmarkslog[tt]==im then
			nrmetki=tt
		end
	end
end
if UnitSex(im) and UnitSex(im)==3 then
SendChatMessage("{rt8} "..psiccsaurf[i].." "..psiccsaurhealfail1.." - "..nrmetki.." "..im.." "..psiccdeadf.."!", "raid")
else
SendChatMessage("{rt8} "..psiccsaurf[i].." "..psiccsaurhealfail1.." - "..nrmetki.." "..im.." "..psiccdeadm.."!", "raid")
end

end
end
end
SetRaidTarget(im, 0)


	end
end


end
end

--смерть босса
if im==psiccsaurfang then
psficcsaurfoff()
psunmarkallraiders=GetTime()+2
end

end


function psiccsaurfresheal()
for i=1,8 do
if psicsaurfhealstattbl[i]==5 then
if UnitIsDead(psiccsaurf[i])==nil then
if psicsaufmmarkshas[i]=="" then
psicsaurfhealstattbl[i]=1
else
psicsaurfhealstattbl[i]=3
end end end end
end


function psiccmarkincomming()

--проверка не реснули ли хила
psiccsaurfresheal()
--проверка онлайн хилеров
psiccsaurfallonlineorno()

local i=1
local psicmetkafind=0
while i<9 do
if psicsaurfhealstattbl[i]==1 then
--хилер готов
psicmetkafind=1

if psicsaurfgalk[3]==1 then
SendChatMessage(psiccsaurmetkainc.." - "..(psiccschet5+1)..", "..psiccsaurf[i].." "..psiccsaurbeready, "raid")
end

if psicsaurfgalk[4]==1 then
SendChatMessage("PhoenixStyle > "..psiccsaurbeready2, "WHISPER", nil, psiccsaurf[i])
end
i=20
end

i=i+1
end


--все хилеры заняты
if psicmetkafind==0 then
--хилеры не готовы, проверяем уронивших
local i=1
while i<9 do
if psicsaurfhealstattbl[i]==2 then
--хилер готов
if UnitIsDead(psiccsaurf[i])==nil then
psicmetkafind=1

if psicsaurfgalk[3]==1 then
SendChatMessage(psiccsaurmetkainc.." - "..(psiccschet5+1)..", "..psiccsaurf[i].." "..psiccsaurbeready, "raid")
end

if psicsaurfgalk[4]==1 then
SendChatMessage("PhoenixStyle > "..psiccsaurbeready2, "WHISPER", nil, psiccsaurf[i])
end
i=20
end
end

i=i+1
end


if psicmetkafind==0 then
--сказать что хил еще не выбран

if psicsaurfgalk[3]==1 then
SendChatMessage(psiccsaurerr3, "raid")
end

end
end


end


function psiccsaurfallonlineorno()

for i = 1,GetNumRaidMembers() do
local psnname, _, _, _, _, _, _, pssonline = GetRaidRosterInfo(i)
	for j=1,8 do
		if psiccsaurf[j]==psnname then
			if (pssonline==nil and (psicsaurfhealstattbl[j]==1 or psicsaurfhealstattbl[j]==2 or psicsaurfhealstattbl[j]==3)) then
			psicsaurfhealstattbl[j]=6
			end
		end
	end
end
end

function psiccsauredcclfocus()
for ii=1,8 do
psicsaurfedittable[ii]:ClearFocus()
end
end