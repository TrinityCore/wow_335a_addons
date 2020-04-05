-- Author: Shurshik
-- version: 1.036
-- http://phoenix-wow.ru

function PhoenixStyleEA_OnLoad()

psealocale()
psealocaleui()
psealocalezone()


	raversion=1.036
	raversshow="ver-"..raversion.." (release)"
	if(thisaddonworkea==nil) then thisaddonworkea=true end
	if pseashowfailreas==nil then pseashowfailreas=true end
	if pseashownewvervar==nil then pseashownewvervar=true end
	if(wherereportraidach==nil) then wherereportraidach="raid" end
	if(wherereportpartyach==nil) then wherereportpartyach="party" end
	rabigmenuchatlisten={"raid", "raid_warning", "officer", "party", "guild", "say", "yell", "sebe"}
	ralowmenuchatlisten={"party", "officer", "guild", "say", "yell", "sebe"}

	ramsgupdate=0
	ramsgtimestart=0
	ramsgwaiting=0
	ramsgmychat=""
	racanannouncetable={}
	raannouncewait={}

	rabilresnut=0
	raachdone1=true
	raachdone2=true
	raachdone3=true
	ratime1=0
	ratime2=0
	rabattlev=0
	if raquantrepeatach==nil then raquantrepeatach=5 end
	if raquantrepeatachtm==nil then raquantrepeatachtm=2 end
	raquantrepdone=1
	if raoldvern==nil then raoldvern=0 end


	SLASH_PHOENIXSTYLEEASYACH1 = "/RaidAchievement"
	SLASH_PHOENIXSTYLEEASYACH2 = "/raidach"
	SLASH_PHOENIXSTYLEEASYACH3 = "/rach"
	SLASH_PHOENIXSTYLEEASYACH4 = "/fena"
	SLASH_PHOENIXSTYLEEASYACH5 = "/фена"
	SLASH_PHOENIXSTYLEEASYACH6 = "/фениксач"
	SLASH_PHOENIXSTYLEEASYACH7 = "/рейдач"
	SLASH_PHOENIXSTYLEEASYACH8 = "/рач"
	SlashCmdList["PHOENIXSTYLEEASYACH"] = PHOENIXSTYLEEASYACH_Command




	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	this:RegisterEvent("CHAT_MSG_ADDON")
	this:RegisterEvent("PLAYER_ALIVE")
	this:RegisterEvent("PLAYER_REGEN_DISABLED")
	this:RegisterEvent("PLAYER_REGEN_ENABLED")
	this:RegisterEvent("ADDON_LOADED")


end



function ramain_OnUpdate()

local racurrenttime = GetTime()

if radelaybeforezonech and racurrenttime>radelaybeforezonech+5 then
radelaybeforezonech=nil
chechtekzoneea()
end


if ramanyachon and (raachdone1==false or raachdone2==false or raachdone3==false or whraachdone1==false) and raquantrepeatach>=raquantrepdone and radelaybeforerezetach==nil and raquantrepeatachtm>0 then
radelaybeforerezetach=GetTime()+raquantrepeatachtm
end

if radelaybeforerezetach and racurrenttime>radelaybeforerezetach then
radelaybeforerezetach=nil
raquantrepdone=raquantrepdone+1
if raachdone1==false then raachdone1=true end
if raachdone2==false then raachdone2=true end
if raachdone3==false then raachdone3=true end
if whraachdone1==false then whraachdone1=true end
end



									if ramsgupdate==1 then
if ramsgtimestart>0 and racurrenttime>ramsgtimestart+0.4 then
ramsgtimestart=0
--тут отправда в аддон канал инфы
SendAddonMessage("RaidAchievement", "myname:"..ranamemsgsend.."++mychat:"..ramsgmychat.."++", "RAID")
end

if ramsgwaiting>0 and racurrenttime>ramsgwaiting+1.5 then
ramsgwaiting=0
table.sort(racanannouncetable)
--тут аннонс и обнуление всех таблиц

local bililine=0
for i,cc in ipairs(rabigmenuchatlisten) do 
if string.lower(cc) == string.lower(ramsgmychat) then bililine=1
end end

if racanannouncetable[1]==ranamemsgsend then

	if bililine==1 then
for i=1,#raannouncewait do
SendChatMessage(raannouncewait[i], ramsgmychat)
end
	else

local nrchatmy=GetChannelName(ramsgmychat)
		if nrchatmy>0 then
for i=1,#raannouncewait do
SendChatMessage(raannouncewait[i], "CHANNEL",nil,nrchatmy)
end
		end
	end


end

table.wipe(raannouncewait)
table.wipe(racanannouncetable)
ramsgupdate=0


end
									end


end




function PhoenixStyleEA_OnEvent()


if event == "PLAYER_ALIVE" then
rabilresnut=1
end


if event == "CHAT_MSG_ADDON" then

if arg1=="RaidAchievement" and ramsgwaiting>0 then

local _,rastriniz1=string.find(arg2, "mychat:")
if rastriniz1==nil then else
local rastrfine1=string.find(arg2, "++", rastriniz1)
if string.lower(string.sub(arg2, rastriniz1+1, rastrfine1-1))==string.lower(ramsgmychat) then

--вырезаем ник
local _,rastriniz2=string.find(arg2, "myname:")
if rastriniz2==nil then else
local rastrfine2=string.find(arg2, "++", rastriniz2)

local rabililinet=0
for i,getcrash in ipairs(racanannouncetable) do 
if getcrash == string.sub(arg2, rastriniz2+1, rastrfine2-1) then rabililinet=1
end end
if(rabililinet==0)then
table.insert(racanannouncetable,string.sub(arg2, rastriniz2+1, rastrfine2-1))
end


end
end
end
end


--отправка моей инфы
if arg1=="RaidAchievement_info" and arg2=="info" then
local ratmp1=0
if pseashowfailreas then ratmp1=1 end
SendAddonMessage("RaidAchievement_info2", UnitName("player").." v."..raversion.." "..ratmp1.." "..wherereportraidach..wherereportpartyach, arg3)
end

if arg1=="RAverwhips" and arg3=="WHISPER" then
local ratmp1=0
if pseashowfailreas then ratmp1=1 end
SendAddonMessage("RAverwhips2", UnitName("player").." v."..raversion.." "..ratmp1.." "..wherereportraidach..wherereportpartyach, "WHISPER",arg4)
end

if arg1=="RAverwhips2" and arg3=="WHISPER" then
print(arg2)
end



--получение моей инфы
if arg1=="RaidAchievement_info2" and rashushinfo then
if GetTime()>rashushinfo then rashushinfo=nil else
if arg4==UnitName("player") then else
print (arg2)
end
end
end

if arg1=="RA-myvers" then
if tonumber(arg2)>raversion then

		if tonumber(arg2)-raversion>0.0009 then

raoldvern=tonumber(arg2)
if raoldvern>raversion then
PSFeamain3_Textoldv:Show()
end

	if raverschech2==nil and rabattlev==0 and pseashownewvervar then
	raverschech2=1
print ("|cff99ffffRaidAchievement|r - "..ranewversfound)
	end
		end


elseif tonumber(arg2)<raversion then
if ralastsendbinf==nil or (ralastsendbinf and GetTime()>ralastsendbinf+60) then
SendAddonMessage("RA-myvers", raversion, arg3)
ralastsendbinf=GetTime()
end
end
end


end


if event == "ZONE_CHANGED_NEW_AREA" then

radelaybeforezonech=GetTime()
	raachdone1=true
	raachdone2=true
	raachdone3=true
	ratime1=0
	ratime2=0
	raquantrepdone=1

	if raverschech1==nil then
raverschech1=1
if (UnitInRaid("player")) then
SendAddonMessage("RA-myvers", raversion, "raid")
end

if IsInGuild() then
SendAddonMessage("RA-myvers", raversion, "guild")
end
	end

end

if event == "ADDON_LOADED" then
if arg1=="RaidAchievement" then

if raoldvern>raversion then
PSFeamain3_Textoldv:Show()
end

end
end


if event == "PLAYER_REGEN_DISABLED" then
rabattlev=1

if rabilresnut==1 then
else
--обнулять все данные при начале боя тут:

	raachdone1=true
	raachdone2=true
	raachdone3=true
	ratime1=0
	ratime2=0
	raquantrepdone=1

end

end

if event == "PLAYER_REGEN_ENABLED" then

	rabattlev=0

end

if(lalaproverkaea==nil)then
radelaybeforezonech=GetTime()-3
lalaproverkaea=1
end




if GetNumRaidMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

--обнуление после реса
if rabilresnut==1 then
if ratimeresnut==nil then
ratimeresnut=arg1+4
end
if arg1>ratimeresnut then rabilresnut=0 ratimeresnut=nil end
end







end
end --конец основной функции аддона





--==========МЕНЮ==


function PHOENIXSTYLEEASYACH_Command(msg)


PSFeamain1:Hide()
PSFeamain2:Hide()
PSFea_closeallpr()

PSFeamain1:Show()
PSFeamain2:Show()
PSFeamain3:Show()

end


function PSFea_closeallpr()
if IsAddOnLoaded("RaidAchievement_Ulduar") then PSFea_closeallprUlduar() end
if IsAddOnLoaded("RaidAchievement_WotlkHeroics") then whra_closeallpr() end
if IsAddOnLoaded("RaidAchievement_Naxxramas") then nxra_closeallpr() end
if IsAddOnLoaded("RaidAchievement_Icecrown") then icra_closeallpr() end
PSFeamain3:Hide()
PSFeamain10:Hide()
PSFeamain11:Hide()
PSFeamain12:Hide()
PSFeamainmanyach:Hide()
end

--НАСТРОЙКА данных при загрузке окна настроек
function PSFea_showoptions()

	if rashowopttime1==nil then
rashowopttime1=1

bigmenuchatlistea = {
pseachatlist1,
pseachatlist2,
pseachatlist3,
pseachatlist4,
pseachatlist5,
pseachatlist6,
pseachatlist7,
pseachatlist8,
}

if psfchatadd then
if #psfchatadd>0 then
for i=1,#psfchatadd do
table.insert(bigmenuchatlistea,psfchatadd[i])
end
end
end


lowmenuchatlistea = {
pseachatlist4,
pseachatlist3,
pseachatlist5,
pseachatlist6,
pseachatlist7,
pseachatlist8,
}

if psfchatadd then
if #psfchatadd>0 then
for i=1,#psfchatadd do
table.insert(lowmenuchatlistea,psfchatadd[i])
end
end
end

	end


if (thisaddonworkea) then PSFeamain3_CheckButton1:SetChecked() else PSFeamain3_CheckButton1:SetChecked(false) end
if (pseashowfailreas) then PSFeamain3_CheckButton2:SetChecked() else PSFeamain3_CheckButton2:SetChecked(false) end
if (pseashownewvervar) then PSFeamain3_CheckButton3:SetChecked() else PSFeamain3_CheckButton3:SetChecked(false) end

	if IsAddOnLoaded("PhoenixStyle") and ralogocr==nil then
ralogocr=1
local t = PSFeamain3:CreateTexture(nil,"OVERLAY")
t:SetTexture("Interface\\AddOns\\PhoenixStyle\\phoenix_addon")
t:SetPoint("CENTER",0,-40)
	end

end



function PSFeavkladdon()
	if (PSFeamain3_CheckButton1:GetChecked()) then
		if(thisaddonworkea)then
			else
			thisaddonworkea=true
			chechtekzoneea()
			out("|cff99ffffRaidAchievement|r - "..pseaaddonmy.." |cff00ff00"..pseaaddonon2.."|r.")
		end
	else
			if(thisaddonworkea)then
			out("|cff99ffffRaidAchievement|r - "..pseaaddonmy.." |cffff0000"..pseaaddonoff.."|r.")
			thisaddonworkea=false
			end
end end

function PSFeavklshownames()
	if (PSFeamain3_CheckButton2:GetChecked()) then
		pseashowfailreas=true
	else
		pseashowfailreas=false
	end

end

function PSFeavklshownewver()
	if (PSFeamain3_CheckButton3:GetChecked()) then
		pseashownewvervar=true
	else
		pseashownewvervar=false
	end

end


function PSFea_buttonaddon()
PSFea_closeallpr()
PSFeamain3:Show()
end

function PSFea_buttonulda()
PSFea_closeallpr()
if(thisaddonworkea)then
if IsAddOnLoaded("RaidAchievement_Ulduar")==nil then
LoadAddOn("RaidAchievement_Ulduar")
if IsAddOnLoaded("RaidAchievement_Ulduar") then
print("|cff99ffffRaidAchievement|r - "..pseamoduleload.." "..psealeftmenu5.."!")
end
end
if IsAddOnLoaded("RaidAchievement_Ulduar") then
PSFea_buttonulda2()
else
PSFeamain12:Show()
end
else
PSFeamain10:Show()
end
end

function whra_button()
PSFea_closeallpr()
if(thisaddonworkea)then
if IsAddOnLoaded("RaidAchievement_WotlkHeroics")==nil then
LoadAddOn("RaidAchievement_WotlkHeroics")
if IsAddOnLoaded("RaidAchievement_WotlkHeroics") then
print("|cff99ffffRaidAchievement|r - "..pseamoduleload.." "..psealeftmenu4.."!")
end
end
if IsAddOnLoaded("RaidAchievement_WotlkHeroics") then
whra_button2()
else
PSFeamain12:Show()
end
else
PSFeamain10:Show()
end
end

function nxra_button()
PSFea_closeallpr()
if(thisaddonworkea)then
if IsAddOnLoaded("RaidAchievement_Naxxramas")==nil then
LoadAddOn("RaidAchievement_Naxxramas")
if IsAddOnLoaded("RaidAchievement_Naxxramas") then
print("|cff99ffffRaidAchievement|r - "..pseamoduleload.." "..psealeftmenu31.."!")
end
end
if IsAddOnLoaded("RaidAchievement_Naxxramas") then
nxra_button2()
else
PSFeamain12:Show()
end
else
PSFeamain10:Show()
end
end

function icra_button()
PSFea_closeallpr()
if(thisaddonworkea)then
if IsAddOnLoaded("RaidAchievement_Icecrown")==nil then
LoadAddOn("RaidAchievement_Icecrown")
if IsAddOnLoaded("RaidAchievement_Icecrown") then
print("|cff99ffffRaidAchievement|r - "..pseamoduleload.." "..psealeftmenu6.."!")
end
end
if IsAddOnLoaded("RaidAchievement_Icecrown") then
icra_button2()
else
PSFeamain12:Show()
end
else
PSFeamain10:Show()
end
end

function PSFea_buttonsaveexit()
PSFea_closeallpr()
PSFeamain1:Hide()
PSFeamain2:Hide()
end


function bigmenuchatea(bigma)
if bigma<9 then
	wherereporttempbigma=rabigmenuchatlisten[bigma]
	else wherereporttempbigma=psfchatadd[bigma-8]
end
end

function bigmenuchatea2(bigma2)
bigma2num=0
if (bigma2=="raid") then bigma2num=1
elseif (bigma2=="raid_warning") then bigma2num=2
elseif (bigma2=="officer") then bigma2num=3
elseif (bigma2=="party") then bigma2num=4
elseif (bigma2=="guild") then bigma2num=5
elseif (bigma2=="say") then bigma2num=6
elseif (bigma2=="yell") then bigma2num=7
elseif (bigma2=="sebe") then bigma2num=8
else
	if psfchatadd==nil or #psfchatadd==0 then
	bigma2num=0
	else
		for i=1,#psfchatadd do
			if string.lower(psfchatadd[i])==string.lower(bigma2) then
			bigma2num=i+8
			end
		end

	end
end
end

function lowmenuchatea(bigma)
if bigma<7 then
	wherereporttempbigma=ralowmenuchatlisten[bigma]
	else wherereporttempbigma=psfchatadd[bigma-6]
end
end

function lowmenuchatea2(bigma2)
bigma2num=0
if (bigma2=="party") then bigma2num=1
elseif (bigma2=="officer") then bigma2num=2
elseif (bigma2=="guild") then bigma2num=3
elseif (bigma2=="say") then bigma2num=4
elseif (bigma2=="yell") then bigma2num=5
elseif (bigma2=="sebe") then bigma2num=6
else
	if psfchatadd==nil or #psfchatadd==0 then
	bigma2num=0
	else
		for i=1,#psfchatadd do
			if string.lower(psfchatadd[i])==string.lower(bigma2) then
			bigma2num=i+6
			end
		end

	end
end
end



function chechtekzoneea()

--ульдуар
if GetRealZoneText()==pseazoneulduar then
if IsAddOnLoaded("RaidAchievement_Ulduar")==nil and wasuldatryloadea==nil then
wasuldatryloadea=1
local loaded, reason = LoadAddOn("RaidAchievement_Ulduar")
if loaded then
print("|cff99ffffRaidAchievement|r - "..pseamoduleload.." "..psealeftmenu5.."!")
else
print("|cff99ffffRaidAchievement|r - "..pseamodulenotload.." "..psealeftmenu5.."!")
end
end
end

--Накс Сарт
if GetRealZoneText()==pseazonenax or GetRealZoneText()==pseazonesart or GetRealZoneText()==pseazoneonya then
if IsAddOnLoaded("RaidAchievement_Naxxramas")==nil and wasnaxtryloadea==nil then
wasnaxtryloadea=1
local loaded, reason = LoadAddOn("RaidAchievement_Naxxramas")
if loaded then
print("|cff99ffffRaidAchievement|r - "..pseamoduleload.." "..psealeftmenu31.."!")
else
print("|cff99ffffRaidAchievement|r - "..pseamodulenotload.." "..psealeftmenu31.."!")
end
end
end

--Цитадель
if GetRealZoneText()==pseazoneic then
if IsAddOnLoaded("RaidAchievement_Icecrown")==nil and wasictryloadea==nil then
wasictryloadea=1
local loaded, reason = LoadAddOn("RaidAchievement_Icecrown")
if loaded then
print("|cff99ffffRaidAchievement|r - "..pseamoduleload.." "..psealeftmenu6.."!")
else
print("|cff99ffffRaidAchievement|r - "..pseamodulenotload.." "..psealeftmenu6.."!")
end
end
end

--героики
if (GetInstanceDifficulty()==2 and (string.find(pseaheroicslist, GetRealZoneText()) or GetRealZoneText()==pseaheroicslist2)) then

if GetNumPartyMembers()>1 then
SendAddonMessage("RA-myvers", raversion, "party")
end
if thisaddonwork then
SendAddonMessage("PS-myvers", psversion, "party")
end

if IsAddOnLoaded("RaidAchievement_WotlkHeroics")==nil and waswhtryloadea==nil then
waswhtryloadea=1
local loaded, reason = LoadAddOn("RaidAchievement_WotlkHeroics")
if loaded then
print("|cff99ffffRaidAchievement|r - "..pseamoduleload.." "..psealeftmenu4.."!")
else
print("|cff99ffffRaidAchievement|r - "..pseamodulenotload.." "..psealeftmenu4.."!")
end
end
end

end

function PSFea_PSaddon()
PSFea_closeallpr()
if IsAddOnLoaded("PhoenixStyle")==nil then
--нету аддона
PSFeamain11:Show()

else
--есть аддон
PSFeamain1:Hide()
PSFeamain2:Hide()

--загрузил
PSFmain1:Hide()
PSFmain2:Hide()
PSF_closeallpr()

PSFmain1:Show()
PSFmain2:Show()
PSFmain3:Show()

end
end




function out(text)
DEFAULT_CHAT_FRAME:AddMessage(text)
UIErrorsFrame:AddMessage(text, 1.0, 1.0, 0, 1, 10) 
end

function raver(cchat)
rashushinfo=GetTime()+7
local ratmp1=0
if pseashowfailreas then ratmp1=1 end
print (UnitName("player").." v."..raversion.." "..ratmp1.." "..wherereportraidach..wherereportpartyach)
if cchat==nil then
SendAddonMessage("RaidAchievement_info", "info", "raid")
else
SendAddonMessage("RaidAchievement_info", "info", cchat)
end
end


function pseareportfailnoreason(prichina2, qquant)
local ratemp=""

if ramanyachon and raquantrepeatachtm==0 and raquantrepdone>2 then
ratemp=" #"..(raquantrepdone-1)
end

if ramanyachon and raquantrepeatachtm>0 and raquantrepdone>1 then
ratemp=" #"..raquantrepdone
end


if pseashowfailreas==true then

	if prichina2==nil and qquant==nil then
if (wherereportraidach=="sebe") then
DEFAULT_CHAT_FRAME:AddMessage("- "..achlinnk.." |cffff0000"..pseatreb4.."|r"..ratemp)
else
if IsRaidOfficer()==nil and wherereportraidach=="raid_warning" then
razapuskanonsa("raid", "{rt8} "..achlinnk.." "..pseatreb4..ratemp)
else
razapuskanonsa(wherereportraidach, "{rt8} "..achlinnk.." "..pseatreb4..ratemp)
end
end
	elseif qquant==nil then
if (wherereportraidach=="sebe") then
DEFAULT_CHAT_FRAME:AddMessage("- "..achlinnk.." |cffff0000"..pseatreb4.."|r ("..prichina2..")."..ratemp)
else
if IsRaidOfficer()==nil and wherereportraidach=="raid_warning" then
razapuskanonsa("raid", "{rt8} "..achlinnk.." "..pseatreb4.." ("..prichina2..")."..ratemp)
else
razapuskanonsa(wherereportraidach, "{rt8} "..achlinnk.." "..pseatreb4.." ("..prichina2..")."..ratemp)
end
end
	else
if (wherereportraidach=="sebe") then
DEFAULT_CHAT_FRAME:AddMessage("- "..achlinnk.." |cffff0000"..pseatreb4.."|r ("..prichina2.." - "..qquant..")."..ratemp)
else
if IsRaidOfficer()==nil and wherereportraidach=="raid_warning" then
razapuskanonsa("raid", "{rt8} "..achlinnk.." "..pseatreb4.." ("..prichina2.." - "..qquant..")."..ratemp)
else
razapuskanonsa(wherereportraidach, "{rt8} "..achlinnk.." "..pseatreb4.." ("..prichina2.." - "..qquant..")."..ratemp)
end
end
	end

else

if (wherereportraidach=="sebe") then
DEFAULT_CHAT_FRAME:AddMessage("- "..achlinnk.." |cffff0000"..pseatreb4.."|r"..ratemp)
else
if IsRaidOfficer()==nil and wherereportraidach=="raid_warning" then
razapuskanonsa("raid", "{rt8} "..achlinnk.." "..pseatreb4..ratemp)
else
razapuskanonsa(wherereportraidach, "{rt8} "..achlinnk.." "..pseatreb4..ratemp)
end
end


end

end

function pseareportallok()
if (wherereportraidach=="sebe") then
DEFAULT_CHAT_FRAME:AddMessage("- "..achlinnk.." "..pseatreb2)
else
if IsRaidOfficer()==nil and wherereportraidach=="raid_warning" then
razapuskanonsa("raid", "{rt1} "..achlinnk.." "..pseatreb2)
else
razapuskanonsa(wherereportraidach, "{rt1} "..achlinnk.." "..pseatreb2)
end
end
end


function razapuskanonsa(kudarep, chtorep)
if kudarep and chtorep then

local bililine=0
for i,cc in ipairs(rabigmenuchatlisten) do 
if cc == kudarep then bililine=1
end end

if bililine==0 then
if GetChannelName(kudarep)==0 then
JoinPermanentChannel(kudarep)
ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, kudarep)
end
end

	if (bililine==1 or (bililine==0 and GetChannelName(kudarep)>0)) then


if ramsgwaiting==0 then
ramsgtimestart=GetTime()
ramsgwaiting=GetTime()
ramsgmychat=kudarep --мой чат в который идет аннонс
ramsgupdate=1 --запуск онапдейт таймера
ranamemsgsend=UnitName("player")
if UnitName("player")=="Шуршик" then ranamemsgsend="0"..ranamemsgsend end
if IsRaidOfficer()==1 then ranamemsgsend="0"..ranamemsgsend end
table.wipe(racanannouncetable)
table.insert(racanannouncetable, ranamemsgsend)
end

table.insert (raannouncewait, chtorep)
	end
end
end


function rachatdropm(aa,ww,hh)
aa:ClearAllPoints()
aa:SetPoint("BOTTOMLEFT", ww, hh)
aa:Show()
local items = bigmenuchatlistea
local function OnClick(self)
UIDropDownMenu_SetSelectedID(aa, self:GetID())

bigmenuchatea(self:GetID())
wherereportraidach=wherereporttempbigma
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

bigmenuchatea2(wherereportraidach)

if bigma2num==0 then
bigma2num=1
wherereportraidach="raid"
end

UIDropDownMenu_Initialize(aa, initialize)
UIDropDownMenu_SetWidth(aa, 90);
UIDropDownMenu_SetButtonWidth(aa, 105)
UIDropDownMenu_SetSelectedID(aa,bigma2num)
UIDropDownMenu_JustifyText(aa, "LEFT")
end

function PSFea_manyach()
PSFea_closeallpr()
if(thisaddonworkea)then
PSFeamainmanyach:Show()


--frames creating
if raframcremanycah==nil then
raframcremanycah=1

ramanyachoninfotxtt = PSFeamainmanyach:CreateFontString()
ramanyachoninfotxtt:SetWidth(550)
ramanyachoninfotxtt:SetHeight(200)
if GetLocale() == "deDE" then
ramanyachoninfotxtt:SetFont(GameFontNormal:GetFont(), 11)
else
ramanyachoninfotxtt:SetFont(GameFontNormal:GetFont(), 12)
end
ramanyachoninfotxtt:SetPoint("TOPLEFT",20,-15)
ramanyachoninfotxtt:SetText(ramanyachtitinfo.."|cff00ff00"..raquantrepeatachtm.."|r "..ramanyachtitinfo2)
ramanyachoninfotxtt:SetJustifyH("LEFT")
ramanyachoninfotxtt:SetJustifyV("TOP")


ramanyachoninfotxt = PSFeamainmanyach:CreateFontString()
ramanyachoninfotxt:SetWidth(550)
ramanyachoninfotxt:SetHeight(20)
ramanyachoninfotxt:SetFont(GameFontNormal:GetFont(), 12)
ramanyachoninfotxt:SetPoint("TOPLEFT",20,-160)
ramanyachoninfotxt:SetJustifyH("LEFT")
ramanyachoninfotxt:SetJustifyV("TOP")


PSFeamainmanyach_Textbig1:SetFont(GameFontNormal:GetFont(), 14)
PSFeamainmanyach_Textbig2:SetFont(GameFontNormal:GetFont(), 14)


PSFeamainmanyach_Textmarkoff:SetFont(GameFontNormal:GetFont(), 15)
PSFeamainmanyach_Textmarkon:SetFont(GameFontNormal:GetFont(), 15)

getglobal("PSFeamainmanyach_slider1High"):SetText("10")
getglobal("PSFeamainmanyach_slider1Low"):SetText("1")
PSFeamainmanyach_slider1:SetMinMaxValues(1, 10)
PSFeamainmanyach_slider1:SetValueStep(1)
PSFeamainmanyach_slider1:SetValue(raquantrepeatach)
rasliderch1()

getglobal("PSFeamainmanyach_slider2High"):SetText("5 "..pssec)
getglobal("PSFeamainmanyach_slider2Low"):SetText("0 "..pssec)
PSFeamainmanyach_slider2:SetMinMaxValues(0, 50)
PSFeamainmanyach_slider2:SetValueStep(1)
PSFeamainmanyach_slider2:SetValue(raquantrepeatachtm*10)
rasliderch2()

end


ramanyachclosefr()

if ramanyachon then
ramanyachonfr()
else
ramanyachofffr()
end




else
PSFeamain10:Show()
end
end


function ramanychon()
ramanyachon=true
ramanyachclosefr()
ramanyachonfr()
end


function ramanychoff()
ramanyachon=nil
ramanyachclosefr()
ramanyachofffr()
end

function ramanyachclosefr()
PSFeamainmanyach_Textmarkon:Hide()
PSFeamainmanyach_Textmarkoff:Hide()
PSFeamainmanyach_Buttonon:Hide()
PSFeamainmanyach_Buttonoff:Hide()
end

function ramanyachonfr()
PSFeamainmanyach_Textmarkon:Show()
PSFeamainmanyach_Buttonoff:Show()
rasliderch1()
rasliderch2()
raquantrepdone=1
end

function ramanyachofffr()
PSFeamainmanyach_Textmarkoff:Show()
PSFeamainmanyach_Buttonon:Show()
rasliderch1()
rasliderch2()
raquantrepdone=1
end

function rasliderch1()
raquantrepeatach = PSFeamainmanyach_slider1:GetValue()
local text=""
if ramanyachon then
text=text.."|cff00ff00"
else
text=text.."|cffff0000"
end
text=text..ramanyachtitinfoq..raquantrepeatach.." "..ramanyachtitinfoq2.."|r"
if ramanyachoninfotxt then
ramanyachoninfotxt:SetText(text)
PSFeamainmanyach_Textbig1:SetText(raquantrepeatach)
end
end

function rasliderch2()
raquantrepeatachtm = PSFeamainmanyach_slider2:GetValue()/10
if ramanyachoninfotxtt then
local text=""
if ramanyachon then
text=text.."|cff00ff00"
else
text=text.."|cffff0000"
end
if raquantrepeatachtm==0 then
ramanyachoninfotxtt:SetText(ramanyachtitinfo..text..raquantrepeatachtm.." "..pssec.." ("..ramodulnotblock..")|r "..ramanyachtitinfo2)
else
ramanyachoninfotxtt:SetText(ramanyachtitinfo..text..raquantrepeatachtm.." "..pssec.."|r "..ramanyachtitinfo2)
end
PSFeamainmanyach_Textbig2:SetText(raquantrepeatachtm.." "..pssec)
end
end


function raunitisplayer(id,name)
raunitplayertrue=nil

if UnitInRaid(name) or UnitInParty(name) then
raunitplayertrue=1
else
	if GetNumRaidMembers()>0 then
		for i=1,GetNumRaidMembers() do
			if UnitGUID("raid"..i) and UnitGUID("raid"..i)==id then
				raunitplayertrue=1
				i=41
			end
		end
	else
		if UnitGUID("player") and UnitGUID("player")==id then
			raunitplayertrue=1
		else
			for i=1,4 do
				if UnitGUID("party"..i) and UnitGUID("party"..i)==id then
					raunitplayertrue=1
				end
			end
		end
	end

end
end