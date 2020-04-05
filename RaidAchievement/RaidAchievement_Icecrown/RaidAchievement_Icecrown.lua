-- Author: Shurshik
-- http://phoenix-wow.ru

function icraonload()

icralocale()
icralocaleui()
icralocaleboss()


	icratimer1=0
	icrabosskilled=0
	icratavleach={}
	rsciccbuffvalitria=GetSpellInfo(70766)

if GetRealZoneText()==pseazoneic then
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
	this:RegisterEvent("PLAYER_REGEN_DISABLED")
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	this:RegisterEvent("ADDON_LOADED")
	this:RegisterEvent("CHAT_MSG_MONSTER_YELL")



icraspisokach25={
"4610",
"4613",
"4615",
"4614",
"4616",
"4617",
"4619",
"4620",
"4622"
}

icraspisokach10={
"4534",
"4537",
"4577",
"4538",
"4578",
"4582",
"4579",
"4580",
"4581"
}


if (icraspisokon==nil) then
icraspisokon={}
end


end


function icra_OnUpdate(icracurtime)

--1 boss
if icbonerefact then

		if icranextupd==nil then icranextupd=GetTime()+3 end

if icracurtime>icranextupd then
	icranextupd=icracurtime+0.5


if #icratavleach==0 then
icbonerefact=nil
else
--проверяем время
local i=1
while i<=#icratavleach do
	if icracurtime>tonumber(string.sub(icratavleach[i], 1, string.find(icratavleach[i], "+")-1))+7.9 then
	--фейл описать тут и удалить все переменные
	icrafailnoreason(1, string.sub(icratavleach[i], string.find(icratavleach[i], "+")+1, string.find(icratavleach[i], "!")-1))
	icbonerefact=nil
	table.wipe(icratavleach)
	i=90
	end
i=i+1
end


end
end

end --1 boss


--Valithria
if rsciccportalopen and raachdone1 then
		if icranextupd==nil then icranextupd=GetTime()+0.3 end

if icracurtime>icranextupd then
icranextupd=icracurtime+0.3

--создание табл и вкл сканирования
if rsciccportalspawnwait and icracurtime>rsciccportalopen+10 then
rsciccportalspawnwait=nil
rsciccinportal={}
table.wipe(rsciccinportal)
thisraidtableea = {}
for i = 1,GetNumRaidMembers() do local name,subgroup = GetRaidRosterInfo(i) if subgroup <= 5 then table.insert(thisraidtableea,(GetRaidRosterInfo(i))) end end
end


--сканирование
if rsciccinportal and icracurtime>rsciccportalopen+13 and icracurtime<rsciccportalopen+30 then

for i=1,#thisraidtableea do
	if thisraidtableea[i] then
		if UnitDebuff(thisraidtableea[i], rsciccbuffvalitria) then
			table.insert(rsciccinportal,thisraidtableea[i])
			table.remove(thisraidtableea,i)
		end
	end
end

end

--антисканирование
if rsciccinportal and icracurtime>rsciccportalopen+13 and icracurtime<rsciccportalopen+30 then

for i=1,#rsciccinportal do
	if rsciccinportal[i] then
		if UnitInRaid(rsciccinportal[i]) and UnitDebuff(rsciccinportal[i], rsciccbuffvalitria)==nil then
			table.insert(thisraidtableea,rsciccinportal[i])
			rsciccinportal[i]="qqqqqqtest"
		end
	end
end

end



--проверка и репорт, обнуление всего

if rsciccinportal and icracurtime>rsciccportalopen+31 then
local qport=8
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
qport=3
end

	if #rsciccinportal>=qport then
	else
--фейл ачива и обнуление всего
if icraspisokon[7]=="yes" and raachdone1 and GetRealZoneText()==pseazoneic then
icrafailnoreason(7, #rsciccinportal.." "..raiccof.." "..qport.." "..raiccused)
end


	end

thisraidtableea=nil
rsciccinportal=nil
rsciccportalopen=nil
rsciccportalspawnwait=nil



end



end
end --valithria



end


function icraonevent()



if event == "PLAYER_REGEN_DISABLED" then
if rabilresnut==1 then
else
--обнулять все данные при начале боя тут:

icratimer1=0
table.wipe(icratavleach)

end

end


if event == "ZONE_CHANGED_NEW_AREA" then

icrabosskilled=0
thisraidtableea=nil
rsciccinportal=nil
rsciccportalopen=nil
rsciccportalspawnwait=nil

if GetRealZoneText()==pseazoneic then
this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
else
this:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

end

if event == "ADDON_LOADED" then
	if arg1=="RaidAchievement_Icecrown" then
for i=1,#icraspisokach25 do
if icraspisokon[i]==nil or icraspisokon[i]=="" then icraspisokon[i]="yes" end
end
	end
end

if event == "CHAT_MSG_MONSTER_YELL" then

if (arg1==icravalitriayell1 or (GetLocale() == "frFR" and arg1 and string.find(string.lower(arg1),string.lower(icravalitriayell1)))) and raachdone1 and icraspisokon[7]=="yes" then
if rsciccportalopen==nil then
rsciccportalopen=GetTime()
rsciccportalspawnwait=1
else


if rsciccinportal and icracurtime>rsciccportalopen+26 then
local qport=8
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
qport=3
end

	if #rsciccinportal>=qport then

	else
--фейл ачива и обнуление всего
if icraspisokon[7]=="yes" and raachdone1 and GetRealZoneText()==pseazoneic then
icrafailnoreason(7, #rsciccinportal.." "..raiccof.." "..qport.." "..raiccused)
end


	end

thisraidtableea=nil
rsciccinportal=nil
rsciccportalopen=nil
rsciccportalspawnwait=nil

end


rsciccportalopen=GetTime()
rsciccportalspawnwait=1
end
end

if (arg1==icravalitriayell2 or (GetLocale() == "frFR" and arg1 and string.find(arg1,icravalitriayell2))) and raachdone1 and icraspisokon[7]=="yes" then
thisraidtableea=nil
rsciccinportal=nil
rsciccportalopen=nil
rsciccportalspawnwait=nil
end



end






if GetNumRaidMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

--ТУТ АЧИВЫ


if icraspisokon[1]=="yes" and raachdone1 then
if arg2=="SPELL_AURA_APPLIED" and arg9==69065 then
--if arg2=="SPELL_SUMMON" and (arg9==69062 or arg9==72670 or arg9==72669) then --arg7 на арг4
table.insert(icratavleach, GetTime().."+"..arg7.."!"..arg3)
icbonerefact=1
end

if arg2=="SPELL_AURA_REMOVED" and arg9==69065 then
--удалить с таблицы
local i=1
while i<=#icratavleach do
	if string.sub(icratavleach[i], string.find(icratavleach[i], "!")+1)==arg3 then
		if GetTime()>tonumber(string.sub(icratavleach[i], 1, string.find(icratavleach[i], "+")-1))+7.9 then
		icrafailnoreason(1, string.sub(icratavleach[i], string.find(icratavleach[i], "+")+1, string.find(icratavleach[i], "!")-1))
		icbonerefact=nil
		table.wipe(icratavleach)
		i=90
		else
		table.remove(icratavleach, i)
		i=90
		end
	end
i=i+1
end


if #icratavleach==0 then
icbonerefact=nil
end
end

--player die in bone
if arg2=="UNIT_DIED" and #icratavleach>0 then
	local i=1
	while i<=#icratavleach do
		if string.sub(icratavleach[i], string.find(icratavleach[i], "+")+1, string.find(icratavleach[i], "!")-1)==arg7 then
			if GetTime()>tonumber(string.sub(icratavleach[i], 1, string.find(icratavleach[i], "+")-1))+7.9 then
				icrafailnoreason(1, string.sub(icratavleach[i], string.find(icratavleach[i], "+")+1, string.find(icratavleach[i], "!")-1))
				icbonerefact=nil
				table.wipe(icratavleach)
				i=90
			else
				table.remove(icratavleach, i)
				i=90			
			end
		end
	i=i+1
	end

if #icratavleach==0 then
icbonerefact=nil
end
end

end

if arg2=="SPELL_CAST_START" and arg9==72293 then
if icraspisokon[2]=="yes" and raachdone1 then
ratime1=ratime1+1
if ratime1==3 and (GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3) then
icrafailnoreason(2)
end
if ratime1==5 and (GetInstanceDifficulty()==2 or GetInstanceDifficulty()==4) then
icrafailnoreason(2)
end
end
end

if arg2=="SPELL_AURA_APPLIED_DOSE" and arg13>2 and (arg9==72103 or arg9==72102 or arg9==72101 or arg9==69291) then
if icraspisokon[3]=="yes" and raachdone1 then
icrafailnoreason(3, arg7)
end
end

if arg2=="SPELL_CAST_START" and (arg9==71209 or arg9==69832 or arg9==69839 or arg9==69833) then
if icraspisokon[4]=="yes" and raachdone1 then
icrafailnoreason(4)
end
end

if (arg2=="SPELL_CAST_START" or arg2=="SPELL_CAST_SUCCESS") and (arg9==70539 or arg9==72457 or arg9==72875 or arg9==72876) then
if icraspisokon[5]=="yes" and raachdone1 then
icrafailnoreason(5)
end
end

if arg2=="SPELL_DAMAGE" and (arg4==icracouncilboss1 or arg4==icracouncilboss2 or arg4==icracouncilboss3 or arg9==71393 or arg9==72790 or arg9==72791 or arg9==72789 or arg9==72052 or arg9==72800 or arg9==72801 or arg9==72802) then
if icraspisokon[6]=="yes" and raachdone1 then

local icrsdmg=25000
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then icrsdmg=23000 end
if arg12>icrsdmg then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
icrafailnoreason(6, arg7, arg12)
end
end
end end


if arg2=="SPELL_AURA_APPLIED_DOSE" and arg13>5 and (arg9==70127 or arg9==72530 or arg9==72529 or arg9==72528 or arg9==70128) then
if icraspisokon[8]=="yes" and raachdone1 then
raunitisplayer(arg6,arg7)
if raunitplayertrue then
icrafailnoreason(8, arg7, "patch 3.3.3")
end
end
end

if (arg2=="SPELL_AURA_APPLIED") and (arg9==70503 or arg9==73806 or arg9==73807 or arg9==73808) then
if icraspisokon[9]=="yes" and raachdone1 then
icrafailnoreason(9)
end
end


end
end --КОНЕЦ ОНЕВЕНТ

function icra_closeallpr()
icramain6:Hide()
end


function icra_button2()
PSFea_closeallpr()
icramain6:Show()
openmenureporticra()



if (icranespamit==nil) then

icraspislun= # icraspisokach25
icracbset={}

for i=1,icraspislun do
local _, icraName, _, _, _, _, _, _, _, icraImage = GetAchievementInfo(icraspisokach25[i])

	if icraName then
local icrawheresk=string.find(icraName, "25")
if icrawheresk==nil then icrawheresk=string.find(icraName, "10") end
icraName=string.sub(icraName, 1, icrawheresk-3)
	end

if i>10 then
l=280
j=i-10
else
l=0
j=i
end

--картинка
local t = icramain6:CreateTexture(nil,"OVERLAY")
t:SetTexture(icraImage)
t:SetWidth(24)
t:SetHeight(24)
t:SetPoint("TOPLEFT",l+45,-14-j*30)

--текст
local f = CreateFrame("Frame",nil,icramain6)
f:SetFrameStrata("DIALOG")
f:SetWidth(250)
f:SetHeight(15)

local t = f:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 11)
t:SetAllPoints(f)
t:SetText(icraName)
t:SetJustifyH("LEFT")

f:SetPoint("TOPLEFT",l+73,-18-j*30)
f:Show()

--чекбатон
local c = CreateFrame("CheckButton", nil, icramain6, "OptionsCheckButtonTemplate")
c:SetWidth("25")
c:SetHeight("25")
c:SetPoint("TOPLEFT", l+20, -14-j*30)
c:SetScript("OnClick", function(self) icragalka(i) end )
table.insert(icracbset, c)

end --for i
icranespamit=1
end --nespam


icragalochki()




end --конец бутон2


function icragalochki()
for i=1,#icraspisokach25 do
if(icraspisokon[i]=="yes")then icracbset[i]:SetChecked() else icracbset[i]:SetChecked(false) end
end
end

function icragalka(nomersmeni)
if icraspisokon[nomersmeni]=="yes" then icraspisokon[nomersmeni]="no" else icraspisokon[nomersmeni]="yes" end
end

function icra_buttonchangeyn(yesno)
icraspislun= # icraspisokach25
for i=1,icraspislun do
icraspisokon[i]=yesno
end
icragalochki()
end

function icra_button1()
icraspislun= # icraspisokach25
for i=1,icraspislun do
if icraspisokon[i]=="yes" then icraspisokon[i]="no" else icraspisokon[i]="yes" end
end
icragalochki()
end


function openmenureporticra()
if not DropDownMenureporticra then
CreateFrame("Frame", "DropDownMenureporticra", icramain6, "UIDropDownMenuTemplate")
end
rachatdropm(DropDownMenureporticra,5,7)
end