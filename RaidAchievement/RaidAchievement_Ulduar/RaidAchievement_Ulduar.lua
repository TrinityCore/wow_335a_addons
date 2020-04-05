-- Author: Shurshik
-- http://phoenix-wow.ru

function psfeaUlduar()

psealocaleulduar()
psealocaleulduarui()
psealocaleuldaboss()


	pseahodirlook=false

if GetRealZoneText()==pseazoneulduar then
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
	this:RegisterEvent("PLAYER_REGEN_DISABLED")
	this:RegisterEvent("ADDON_LOADED")
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA")




pseaspisokach25={
"2926",
"2921",
"2932",
"2948",
"2960",
"2956",
"3007",
"3077",
"2968",
"2962",
"2965",
"2972",
"3237",
"2997",
"3010"
}
pseaspisokach10={
"2925",
"2919",
"2931",
"2947",
"2959",
"2955",
"3006",
"3076",
"2967",
"2961",
"2963",
"2971",
"2989",
"2996",
"3008"
}


if (preaspisokon==nil) then
preaspisokon={}
end


end


function PSFea_OnUpdate(elapsedps)

local pseaCurrentTimepull = GetTime()

	if (pseaDelayTimepull == nil)then
		pseaDelayTimepull = GetTime()+0.5
	end


if (pseahodirlook)then
if (pseaCurrentTimepull >= pseaDelayTimepull) then
pseaDelayTimepull = pseaCurrentTimepull+0.15

--ходир по таймеру чекаем

if (pseaspellname1 and thisraidtableea) then

local i=1

while i<=#thisraidtableea do

local _, _, _, stack = UnitDebuff(thisraidtableea[i], pseaspellname1)
if stack==nil then else
if stack>2 then
pseafailnoreason(9, thisraidtableea[i],1)
if ramanyachon and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
pseahodirlook=false
end
i=90
end
end
i=i+1

end --конец таблицы
end --nil


end
end --pseahodirlook


end




function psfeaUlduaronevent()

if event == "ADDON_LOADED" then
	if arg1=="RaidAchievement_Ulduar" then
for i=1,#pseaspisokach25 do
if preaspisokon[i]==nil or preaspisokon[i]=="" then preaspisokon[i]="yes" end
end
	end
end


if event == "PLAYER_REGEN_DISABLED" then
if rabilresnut==1 then

else
--обнулять все данные при начале боя тут:


pseahodirlook=false



end
end

if event == "ZONE_CHANGED_NEW_AREA" then

pseahodirlook=false
if GetRealZoneText()==pseazoneulduar then
this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
else
this:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

end




if GetNumRaidMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then


if arg2=="SPELL_AURA_APPLIED" and arg9==62383 then
if preaspisokon[1]=="yes" and raachdone1 then
pseaignis1()
end
end

if arg2=="SPELL_CAST_START" and arg9==62666 then
if preaspisokon[2]=="yes" and raachdone1 then
psearazor1()
end
end

if arg2=="SPELL_HEAL" and arg9==62832 then
if preaspisokon[3]=="yes" and raachdone1 then
pseafailnoreason(3)
end
end

if ((arg2=="SPELL_DAMAGE" or arg2=="SPELL_MISSED") and (arg9==61916 or arg9==63482 or arg9==61879 or arg9==63479)) then
if preaspisokon[4]=="yes" and raachdone1 then
pseafailnoreason(4)
rabilresnut=1
end
end

if preaspisokon[5]=="yes" and raachdone2 then
if arg2=="SPELL_CAST_SUCCESS" and (arg9==63821 or arg9==64001) then
pseakologarn1()
end
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and (arg12=="ABSORB" or arg12=="RESIST"))) and (arg9==63346 or arg9==63976) then
if preaspisokon[6]=="yes" and raachdone1 then
pseafailnoreason(6, arg7)
end
end

if arg2=="UNIT_DIED" and arg7==pseaauriayaadd then
if preaspisokon[7]=="yes" and raachdone1 then
pseafailnoreason(7)
end
end

if arg2=="SPELL_AURA_REMOVED" and arg9==64455 then
if preaspisokon[8]=="yes" and raachdone2 then
--pseaachcompl(8)
raachdone2=nil
pseamakeachlink(8)

if (wherereportraidach=="sebe") then
DEFAULT_CHAT_FRAME:AddMessage("- "..achlinnk.." "..pseatrebulda2)
else
if IsRaidOfficer()==nil and wherereportraidach=="raid_warning" then
razapuskanonsa("raid", "{rt1} "..achlinnk.." "..pseatrebulda2)
else
razapuskanonsa(wherereportraidach, "{rt1} "..achlinnk.." "..pseatrebulda2)
end
end

end
end

if preaspisokon[9]=="yes" and raachdone1 then
if arg2=="SPELL_CAST_SUCCESS" and (arg9==62038 or arg9==62039) then
thisraidtableea = {}
for i = 1,GetNumRaidMembers() do local name,subgroup = GetRaidRosterInfo(i) if subgroup <= 5 then table.insert(thisraidtableea,(GetRaidRosterInfo(i))) end end
pseahodirlook=true
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
pseaspellname1 = GetSpellInfo(62038)
end
if GetInstanceDifficulty()==2 or GetInstanceDifficulty()==4 then
pseaspellname1 = GetSpellInfo(62039)
end
end
if arg2=="SPELL_DAMAGE" and arg9==62188 then
pseahodirlook=true
raachdone1=nil
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
pseaspellname1 = GetSpellInfo(62038)
end
if GetInstanceDifficulty()==2 or GetInstanceDifficulty()==4 then
pseaspellname1 = GetSpellInfo(62039)
end
end
end

if arg2=="SPELL_AURA_APPLIED" and (arg9==61990 or arg9==61969) then
if preaspisokon[10]=="yes" and raachdone2 then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
pseafailnoreason2(10, arg7)
end
end
end

if arg2=="UNIT_DIED" then
if preaspisokon[11]=="yes" and raachdone3 then
for i,whodead in ipairs(pseahodiradds) do if whodead == arg7 then pseafailnoreason3(11) end end
end
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and (arg12=="ABSORB" or arg12=="RESIST"))) and arg9==62466 then
if preaspisokon[12]=="yes" and raachdone1 then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
pseafailnoreason(12, arg7)
end
end
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and (arg12=="ABSORB" or arg12=="RESIST"))) and arg9==63801 and arg4==pseamimironadd then
if preaspisokon[13]=="yes" and raachdone1 then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
pseafailmimiron1(arg7)
end
end
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and (arg12=="ABSORB" or arg12=="RESIST"))) and arg9==63041 then
if preaspisokon[13]=="yes" and raachdone2 then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
pseafailmimiron2(arg7)
end
end
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and (arg12=="ABSORB" or arg12=="RESIST"))) and (arg9==63009 or agr9==66351) then
if preaspisokon[13]=="yes" and raachdone3 then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
pseafailmimiron3(arg7)
end
end
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and (arg12=="ABSORB" or arg12=="RESIST"))) and arg9==62659 then
if preaspisokon[14]=="yes" and raachdone1 then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
pseafailnoreason(14, arg7)
end
end
end

if arg2=="SPELL_AURA_APPLIED" and arg9==63120 then
if preaspisokon[15]=="yes" and raachdone1 then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
pseafailnoreason(15, arg7)
end
end
end





end --ульды
end --КОНЕЦ ОНЕВЕНТ

function PSFea_closeallprUlduar()
PSFeamain7:Hide()
end


function PSFea_buttonulda2()
PSFea_closeallpr()
PSFeamain7:Show()
openmenureportra()



if (pseanespamit==nil) then

pseaspislun= # pseaspisokach25
ulracbset={}
for i=1,pseaspislun do
local _, pseaName, _, _, _, _, _, _, _, pseaImage = GetAchievementInfo(pseaspisokach25[i])

pseawheresk=string.find(pseaName, "25")
if pseawheresk==nil then pseawheresk=string.find(pseaName, "10") end
pseaName=string.sub(pseaName, 1, pseawheresk-3)

if i>10 then
l=280
j=i-10
else
l=0
j=i
end

--картинка
local t = PSFeamain7:CreateTexture(nil,"OVERLAY")
t:SetTexture(pseaImage)
t:SetWidth(24)
t:SetHeight(24)
t:SetPoint("TOPLEFT",l+45,-14-j*30)

--текст
local f = CreateFrame("Frame",nil,PSFeamain7)
f:SetFrameStrata("DIALOG")
f:SetWidth(250)
f:SetHeight(15)

local t = f:CreateFontString(Name)
t:SetFont(GameFontNormal:GetFont(), 11)
t:SetAllPoints(f)
t:SetText(pseaName)
t:SetJustifyH("LEFT")

f:SetPoint("TOPLEFT",l+73,-18-j*30)
f:Show()

--чекбатон
local c = CreateFrame("CheckButton", nil, PSFeamain7, "OptionsCheckButtonTemplate")
c:SetWidth("25")
c:SetHeight("25")
c:SetPoint("TOPLEFT", l+20, -14-j*30)
c:SetScript("OnClick", function(self) PSFeauldagalka(i) end )
table.insert(ulracbset, c)

pseawheresk=nil

end --for i
pseanespamit=1
end --nespam


pseauldagalochki()




end --конец бутоннульда2


function pseauldagalochki()
for i=1,15 do
if(preaspisokon[i]=="yes")then ulracbset[i]:SetChecked() else ulracbset[i]:SetChecked(false) end
end
end

function PSFeauldagalka(nomersmeni)
if preaspisokon[nomersmeni]=="yes" then preaspisokon[nomersmeni]="no" else preaspisokon[nomersmeni]="yes" end
end

function PSFea_buttonuldachangeyn(yesno)
pseaspislun= # pseaspisokach25
for i=1,pseaspislun do
preaspisokon[i]=yesno
end
pseauldagalochki()
end

function PSFea_buttonulda1()
pseaspislun= # pseaspisokach25
for i=1,pseaspislun do
if preaspisokon[i]=="yes" then preaspisokon[i]="no" else preaspisokon[i]="yes" end
end
pseauldagalochki()
end


function openmenureportra()
if not DropDownMenureportra then
CreateFrame("Frame", "DropDownMenureportra", PSFeamain7, "UIDropDownMenuTemplate")
end
rachatdropm(DropDownMenureportra,5,7)
end