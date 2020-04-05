-- Author: Shurshik
-- http://phoenix-wow.ru

function nxraonload()

nxralocale()
nxralocaleui()
nxralocaleboss()



	nxramexna=0
	nxratimer1=0
	nxrabosskilled=0
	nxraonycast=GetSpellInfo(17086)

	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	this:RegisterEvent("PLAYER_REGEN_DISABLED")
	this:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	this:RegisterEvent("ADDON_LOADED")




nxraspisokach25={
"1859",
"2140",
"2183",
"2179",
"2185",
"2048",
"4407"
}

nxraspisokach10={
"1858",
"1997",
"2182",
"2178",
"2184",
"2047",
"4404"
}


if (nxraspisokon==nil) then
nxraspisokon={}
end


end

--онапдейт
function nxra_OnUpdate()

if nxrafobiaend and GetTime()>nxrafobiaend then
nxramexna=0
nxramakeachlink(1)
pseareportfailnoreason()
nxrafobiaend=nil
end

if racnxnotinnax and GetTime()>racnxnotinnax+120 then
racnxnotinnax=nil
nxramexna=0
nxrafobiaend=nil
end

end




function nxraonevent()



if event == "PLAYER_REGEN_DISABLED" then
if rabilresnut==1 then
else
--обнулять все данные при начале боя тут:


nxratimer1=0



end

end


if event == "ZONE_CHANGED_NEW_AREA" then


if GetRealZoneText()==pseazonenax and nxramexna==1 then
racnxnotinnax=nil
elseif nxramexna==1 and racnxnotinnax==nil then
racnxnotinnax=GetTime()
end


nxrabosskilled=0

end

if event == "ADDON_LOADED" then
	if arg1=="RaidAchievement_Naxxramas" then
for i=1,#nxraspisokach25 do
if nxraspisokon[i]==nil or nxraspisokon[i]=="" then nxraspisokon[i]="yes" end
end
	end
end

if event == "CHAT_MSG_RAID_BOSS_EMOTE" then

if string.find(arg1, nxraonyemote)==nil then else
if arg2==nxraonyxiab then
ratime1=GetTime()

end end



end


if GetNumRaidMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

--по 2 ачиву таймер
if nxratimer1>0 then
if arg1>nxratimer1+1.5 then
nxratimer1=0
nxrafailnoreason(2)
end end


if arg2=="UNIT_DIED" and arg7==nxraanubrekan then
if nxraspisokon[1]=="yes" then
nxrafobiaend=GetTime()+1200
nxramexna=1
end
end

if arg2=="UNIT_DIED" and arg7==nxrameksna then
nxramexna=0
end

if arg2=="SPELL_AURA_REMOVED" and arg9==54100 then
if nxraspisokon[2]=="yes" and raachdone1 then
raachdone1=nil
nxratimer1=arg1
end
end

if arg2=="UNIT_DIED" and arg7==nxrafaerlin then
if nxraspisokon[2]=="yes" then
nxratimer1=0
end
end

if arg2=="UNIT_DIED" and arg7==nxraloatheb then
if nxraspisokon[3]=="yes" and raachdone1 then
raachdone1=nil
nxrabosskilled=1
end
end

if arg2=="UNIT_DIED" and arg7==nxraspore then
if nxraspisokon[3]=="yes" and raachdone1 and nxrabosskilled==0 then
nxrafailnoreason(3)
end
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==28085 or arg==28059) then
if nxraspisokon[4]=="yes" and raachdone1 then
nxrafailnoreason(4)
end
end

if arg2=="UNIT_DIED" and arg7==nxrakeladd then
if nxraspisokon[5]=="yes" and raachdone1 then
ratime1=ratime1+1
if ratime1>17 then
nxraachcompl(5)
end
end
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and arg9==57591 and GetRaidRosterInfo(GetNumRaidMembers())==arg7 and rabattlev==1 then
if nxraspisokon[6]=="yes" and raachdone1 then
--проверка на ачивку у себя!
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
_, _, _, nxrasarto = GetAchievementInfo(2047)
elseif GetInstanceDifficulty()==2 or GetInstanceDifficulty()==4 then
_, _, _, nxrasarto = GetAchievementInfo(2048)
end
if (nxrasarto) then else
nxramyfail(6)
end
end
end

if ((arg2=="SPELL_DAMAGE" or arg2=="SPELL_MISSED") and arg10==nxraonycast and GetTime()-ratime1<14) then
if nxraspisokon[7]=="yes" and raachdone1 then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
nxrafailnoreason(7, arg7)
end
end
end





end
end --КОНЕЦ ОНЕВЕНТ

function nxra_closeallpr()
nxramain6:Hide()
end


function nxra_button2()
PSFea_closeallpr()
nxramain6:Show()
openmenureportnxra()



if (nxranespamit==nil) then

nxraspislun= # nxraspisokach25
nxracbset={}
for i=1,nxraspislun do
local _, nxraName, _, _, _, _, _, _, _, nxraImage = GetAchievementInfo(nxraspisokach25[i])

local nxrawheresk=string.find(nxraName, "25")
if nxrawheresk==nil then nxrawheresk=string.find(nxraName, "10") end
nxraName=string.sub(nxraName, 1, nxrawheresk-3)


if i>10 then
l=280
j=i-10
else
l=0
j=i
end

--картинка
local t = nxramain6:CreateTexture(nil,"OVERLAY")
t:SetTexture(nxraImage)
t:SetWidth(24)
t:SetHeight(24)
t:SetPoint("TOPLEFT",l+45,-14-j*30)

--текст
local f = CreateFrame("Frame",nil,nxramain6)
f:SetFrameStrata("DIALOG")
f:SetWidth(250)
f:SetHeight(15)

local t = f:CreateFontString(Name)
t:SetFont(GameFontNormal:GetFont(), 11)
t:SetAllPoints(f)
t:SetText(nxraName)
t:SetJustifyH("LEFT")

f:SetPoint("TOPLEFT",l+73,-18-j*30)
f:Show()

--чекбатон
local c = CreateFrame("CheckButton", nil, nxramain6, "OptionsCheckButtonTemplate")
c:SetWidth("25")
c:SetHeight("25")
c:SetPoint("TOPLEFT", l+20, -14-j*30)
c:SetScript("OnClick", function(self) nxragalka(i) end )
table.insert(nxracbset, c)

end --for i
nxranespamit=1
end --nespam


nxragalochki()




end --конец бутон2


function nxragalochki()
for i=1,7 do
if(nxraspisokon[i]=="yes")then nxracbset[i]:SetChecked() else nxracbset[i]:SetChecked(false) end
end
end

function nxragalka(nomersmeni)
if nxraspisokon[nomersmeni]=="yes" then nxraspisokon[nomersmeni]="no" else nxraspisokon[nomersmeni]="yes" end
end

function nxra_buttonchangeyn(yesno)
nxraspislun= # nxraspisokach25
for i=1,nxraspislun do
nxraspisokon[i]=yesno
end
nxragalochki()
end

function nxra_button1()
nxraspislun= # nxraspisokach25
for i=1,nxraspislun do
if nxraspisokon[i]=="yes" then nxraspisokon[i]="no" else nxraspisokon[i]="yes" end
end
nxragalochki()
end


function openmenureportnxra()
if not DropDownMenureportnxra then
CreateFrame("Frame", "DropDownMenureportnxra", nxramain6, "UIDropDownMenuTemplate")
end
rachatdropm(DropDownMenureportnxra,5,7)
end