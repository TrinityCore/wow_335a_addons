-- Author: Shurshik
-- version: 1.4961
-- http://phoenix-wow.ru

function PhoenixStyle_OnLoad()

pslocalem()
pslocaleuim()
pslocalezonem()
if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="zhTW" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" then
pslocale()
pslocaleui()
pslocalezone()
end

PSFprepareUI()

	psversion=1.4961
	if PS_Settings==nil then PS_Settings = {PSMinimapPos = -16} end
	if psminibutenabl==nil then psminibutenabl=true end
	timertopull=0
	howmuchwaitpull=0
	pspullactiv=0
	isbattlev=0
	timetocheck=0
	timeeventr=0
	truemark={"false","false","false","false","false","false","false","false"}
	autorefmark=false
	psfnotoffvar=0
	pstimeruraid=0
	psbilresnut=0
	pszapuskdelayphasing=0

	psmylogin=GetTime()


	psmsgtimestart=0
	psmsgtimestart42=0
	psmsgtimestart43=0
	psmsgwaiting=0
	psmsgwaiting42=0
	psmsgwaiting43=0
	psmsgmychat=""
	psmsgmychat42=""
	psmsgmychat43=""
	pscanannouncetable={}
	pscanannouncetable42={}
	pscanannouncetable43={}
	psannouncewait={}
	psannouncewait42={}
	psannouncewait43={}
	psnotanonsemore=0
	psnotanonsemorenormal=0
	psnotanonsemorenormal2=0
	bigmenuchatlisten={"raid", "raid_warning", "officer", "party", "guild", "say", "yell", "sebe"}
	if (vezaxname==nil) then vezaxname = {} end
	if (vezaxcrash==nil) then vezaxcrash = {} end
	if (vezaxname2==nil) then vezaxname2 = {} end
	if (vezaxcrash2==nil) then vezaxcrash2 = {} end
	if (vezaxname3==nil) then vezaxname3 = {} end
	if (vezaxcrash3==nil) then vezaxcrash3 = {} end
	if (vezaxname4==nil) then vezaxname4 = {} end
	if (vezaxcrash4==nil) then vezaxcrash4 = {} end
	if psoldvern==nil then psoldvern=0 end
	if psversionday==nil then psversionday=0 end

	SLASH_PHOENIXSTYLEFAILBOT1 = "/fen"
	SLASH_PHOENIXSTYLEFAILBOT2 = "/feniks"
	SLASH_PHOENIXSTYLEFAILBOT3 = "/phoenix"
	SLASH_PHOENIXSTYLEFAILBOT4 = "/phoenixstyle"
	SLASH_PHOENIXSTYLEFAILBOT5 = "/фен"
	SLASH_PHOENIXSTYLEFAILBOT6 = "/феникс"
	SlashCmdList["PHOENIXSTYLEFAILBOT"] = PhoenixStyleFailbot_Command




	if(secrefmark == nil) then secrefmark = 1 end
	if(thisaddononoff == nil) then thisaddononoff=true end
	if(thisaddonwork==nil) then thisaddonwork=true end
	if(psfnopromrep==nil) then psfnopromrep=false end
	if pssetmarknew==nil then pssetmarknew={{},{},{},{},{},{},{},{}} end

	PhoenixStyleFailbot:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	PhoenixStyleFailbot:RegisterEvent("PLAYER_REGEN_DISABLED")
	PhoenixStyleFailbot:RegisterEvent("PLAYER_REGEN_ENABLED")
	PhoenixStyleFailbot:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	PhoenixStyleFailbot:RegisterEvent("CHAT_MSG_ADDON")
	PhoenixStyleFailbot:RegisterEvent("PLAYER_ALIVE")
	PhoenixStyleFailbot:RegisterEvent("ADDON_LOADED")
	PhoenixStyleFailbot:RegisterEvent("CHAT_MSG_PARTY")
	PhoenixStyleFailbot:RegisterEvent("CHAT_MSG_RAID")
	PhoenixStyleFailbot:RegisterEvent("CHAT_MSG_RAID_WARNING")
	PhoenixStyleFailbot:RegisterEvent("CHAT_MSG_OFFICER")
	PhoenixStyleFailbot:RegisterEvent("CHAT_MSG_GUILD")

end







function PSF_OnUpdate()

	local CurrentTimepull = GetTime()


if pszonechangedalldel and CurrentTimepull>pszonechangedalldel+4 then
pszonechangedalldel=nil
pszonechangedall()
end


--пуллтаймер онапдейт
if pspullactiv then

if(timertopull>0 or pspullactiv==1)then


	if (DelayTimepull == nil)then
		DelayTimepull = GetTime()+howmuchwaitpull
	end


		if (CurrentTimepull >= DelayTimepull) then
			local someerrorsecpull=CurrentTimepull-DelayTimepull

if timertopull==0 then
SendChatMessage(">>> "..psattack.." <<<", "raid_warning")
pspullactiv=0
timertopull=0
DelayTimepull=nil
else
			SendChatMessage(psattackin.." "..timertopull.." "..pssec, "raid_warning")
end
			

if timertopull >14.2 then
DelayTimepull = DelayTimepull-someerrorsecpull+5
timertopull=10
elseif timertopull>9.2 then
DelayTimepull = DelayTimepull-someerrorsecpull+3
timertopull=7
elseif timertopull >6.2 then
DelayTimepull = DelayTimepull-someerrorsecpull+2
timertopull=5

elseif timertopull >5.5 then
DelayTimepull = DelayTimepull-someerrorsecpull+2
timertopull=4

elseif timertopull >4.2 then
DelayTimepull = DelayTimepull-someerrorsecpull+2
timertopull=3

elseif timertopull >3.2 then
DelayTimepull = DelayTimepull-someerrorsecpull+1
timertopull=3

elseif timertopull >2.2 then
DelayTimepull = DelayTimepull-someerrorsecpull+1
timertopull=2
elseif timertopull >1.2 then
DelayTimepull = DelayTimepull-someerrorsecpull+1
timertopull=1
elseif timertopull >0.2 then
DelayTimepull = DelayTimepull-someerrorsecpull+1
timertopull=0
pspullactiv=1
else
timertopull=0


end --timertopull>17


		end
end
end --конец по пулу

--задержка аннонса

if psmsgtimestart42>0 and CurrentTimepull>psmsgtimestart42+0.4 then
psmsgtimestart42=0
SendAddonMessage("PhoenixStyle", "myname:"..psnamemsgsend.."++mychat:"..psmsgmychat42.."++", "RAID")
end

if psmsgtimestart43>0 and CurrentTimepull>psmsgtimestart43+0.4 then
psmsgtimestart43=0
SendAddonMessage("PhoenixStyle", "myname:"..psnamemsgsend.."++mychat:"..psmsgmychat43.."++", "RAID")
end


if psmsgtimestart>0 and CurrentTimepull>psmsgtimestart+0.4 then
psmsgtimestart=0

--тут отправка в аддон канал инфы

	if pssendinterboj==nil then
SendAddonMessage("PhoenixStyle", "myname:"..psnamemsgsend.."++mychat:"..psmsgmychat.."++", "RAID")
	else
SendAddonMessage("PhoenixStyle", "myname:"..psnamemsgsend.."++mychat:"..psmsgmychat.."++fightend++", "RAID")
	end

end




--Допанонсы
if psmsgwaiting42>0 and CurrentTimepull>psmsgwaiting42+1.7 then
psmsgwaiting42=0
table.sort(pscanannouncetable42)
--тут аннонс и обнуление всех таблиц

local bililine=0
for i,cc in ipairs(bigmenuchatlisten) do 
if string.lower(cc) == string.lower(psmsgmychat42) then bililine=1
end end
if pscanannouncetable42[1]==psnamemsgsend then

	if bililine==1 then

for i=1,#psannouncewait42 do
SendChatMessage(psannouncewait42[i], psmsgmychat42)
if psanounsesrazuchek==1 then psanonceinst=1 end
end
	else

local nrchatmy=GetChannelName(psmsgmychat42)
		if nrchatmy>0 then
for i=1,#psannouncewait42 do
SendChatMessage(psannouncewait42[i], "CHANNEL",nil,nrchatmy)
if psanounsesrazuchek==1 then psanonceinst=1 end
end
		end
	end

end

table.wipe(psannouncewait42)
table.wipe(pscanannouncetable42)
psanounsesrazuchek=nil

end

--Допанонсы
if psmsgwaiting43>0 and CurrentTimepull>psmsgwaiting43+1.7 then
psmsgwaiting43=0
table.sort(pscanannouncetable43)
--тут аннонс и обнуление всех таблиц

local bililine=0
for i,cc in ipairs(bigmenuchatlisten) do 
if string.lower(cc) == string.lower(psmsgmychat43) then bililine=1
end end
if pscanannouncetable43[1]==psnamemsgsend then

	if bililine==1 then

for i=1,#psannouncewait43 do
SendChatMessage(psannouncewait43[i], psmsgmychat43)
if psanounsesrazuchek==1 then psanonceinst=1 end
end
	else

local nrchatmy=GetChannelName(psmsgmychat43)
		if nrchatmy>0 then
for i=1,#psannouncewait43 do
SendChatMessage(psannouncewait43[i], "CHANNEL",nil,nrchatmy)
if psanounsesrazuchek==1 then psanonceinst=1 end
end
		end
	end

end

table.wipe(psannouncewait43)
table.wipe(pscanannouncetable43)
psanounsesrazuchek=nil

end


if psmsgwaiting>0 and CurrentTimepull>psmsgwaiting+1.7 then
psmsgwaiting=0
table.sort(pscanannouncetable)
--тут аннонс и обнуление всех таблиц

local bililine=0
for i,cc in ipairs(bigmenuchatlisten) do 
if string.lower(cc) == string.lower(psmsgmychat) then bililine=1
end end
if pscanannouncetable[1]==psnamemsgsend then

	if bililine==1 then

for i=1,#psannouncewait do
SendChatMessage(psannouncewait[i], psmsgmychat)
--если анонсю я, и далее будут инстанс анонсы
if psanounsesrazuchek==1 then psanonceinst=1 end
end

	else

local nrchatmy=GetChannelName(psmsgmychat)
		if nrchatmy>0 then
for i=1,#psannouncewait do
SendChatMessage(psannouncewait[i], "CHANNEL",nil,nrchatmy)
if psanounsesrazuchek==1 then psanonceinst=1 end
end
		end
	end

end

table.wipe(psannouncewait)
table.wipe(pscanannouncetable)
psanounsesrazuchek=nil

end

--конец задержки аннонсов



--autoref marks


if (autorefmark) then

if (CurrentTimepull>timeeventr) then
if(IsRaidOfficer()==1) then

		local timetocheck=0
		if psdelaydeathcheck==nil or (psdelaydeathcheck and GetTime()>psdelaydeathcheck+5) then
			psdelaydeathcheck=GetTime()
			timetocheck=1
		end

		for i=1,8 do
		if truemark[i]=="true" then
			local metka=0
			for ij=1,#pssetmarknew[i] do
				if metka==0 and pssetmarknew[i][ij] and UnitExists(pssetmarknew[i][ij]) then
					if timetocheck==1 then
						local oj=1
						while oj<=GetNumRaidMembers() do
							local name2, _, _, _, _, _, _, online, isDead = GetRaidRosterInfo(oj)

							if name2 and pssetmarknew[i][ij] and string.lower(name2)==string.lower(pssetmarknew[i][ij]) then
								if online==nil then
									psdelaydeathcheck=GetTime()-10
								end
								if (online and isDead==nil and UnitIsDeadOrGhost(name2)==nil) then
									if GetRaidTargetIndex(pssetmarknew[i][ij])==nil or (GetRaidTargetIndex(pssetmarknew[i][ij]) and GetRaidTargetIndex(pssetmarknew[i][ij])~=i) then
										SetRaidTarget(pssetmarknew[i][ij], i)
									end
									metka=1
									ij=98
								end
								oj=96
							end
							oj=oj+1
						end
					else
						if UnitIsDeadOrGhost(pssetmarknew[i][ij])==nil then
							if GetRaidTargetIndex(pssetmarknew[i][ij])==nil or (GetRaidTargetIndex(pssetmarknew[i][ij]) and GetRaidTargetIndex(pssetmarknew[i][ij])~=i) then
								SetRaidTarget(pssetmarknew[i][ij], i)
							end
							metka=1
							ij=98
						end
					end
				end
			end
		end
		end


else
if (spammvar==nil) then
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psmarkserror)
spammvar=1
end
--отключаю
PSF_buttonoffmark()
end
timeeventr=CurrentTimepull+secrefmark
end
end

--мое инфо
if psshushinfo then
if CurrentTimepull>psshushinfo then
psshushinfo=nil
end
end


if psunmarkallraiders and CurrentTimepull>psunmarkallraiders then
psunmarkallraiders=nil
if(IsRaidOfficer()==1) then

for i = 1,GetNumRaidMembers() do local name = GetRaidRosterInfo(i)
	if UnitExists(name) and GetRaidTargetIndex(name) and GetRaidTargetIndex(name)>0 then
		SetRaidTarget(name, 0)
	end
end

end
end






end








function PhoenixStyle_OnEvent()

if event == "PLAYER_ALIVE" then
psbilresnut=1
end


if event == "CHAT_MSG_ADDON" then

--получение данных при задержке аннонса1
if arg1=="PhoenixStyle" and psmsgwaiting>0 then
local _,psstriniz1=string.find(arg2, "mychat:")
if psstriniz1==nil then else
local psstrfine1=string.find(arg2, "++", psstriniz1)
if string.lower(string.sub(arg2, psstriniz1+1, psstrfine1-1))==string.lower(psmsgmychat) or (string.sub(arg2, psstriniz1+1, psstrfine1-1)=="raid" and psmsgmychat=="raid_warning") or (string.sub(arg2, psstriniz1+1, psstrfine1-1)=="raid_warning" and psmsgmychat=="raid")  then

--вырезаем ник
local _,psstriniz2=string.find(arg2, "myname:")
if psstriniz2==nil then else
local psstrfine2=string.find(arg2, "++", psstriniz2)

local psbililinet=0
for i,getcrash in ipairs(pscanannouncetable) do 
if getcrash == string.sub(arg2, psstriniz2+1, psstrfine2-1) then psbililinet=1
end end
if(psbililinet==0)then
table.insert(pscanannouncetable,string.sub(arg2, psstriniz2+1, psstrfine2-1))
end

end
end
end
end
--конец получения данных о аннонсе1

--стоп аддона
if arg1=="PSstop" and arg2=="stop" and (arg4=="Шуршик" or arg4=="Шурши") then
if UnitName("player")~= arg4 and thisaddonwork then
out("|cff99ffffPhoenixStyle|r - "..psaddonmy.." |cffff0000"..psaddonoff.."|r.")
thisaddonwork=false
end
end

--получение данных при задержке аннонса2
if arg1=="PhoenixStyle" and psmsgwaiting42>0 then

local _,psstriniz1=string.find(arg2, "mychat:")
if psstriniz1==nil then else
local psstrfine1=string.find(arg2, "++", psstriniz1)
if string.lower(string.sub(arg2, psstriniz1+1, psstrfine1-1))==string.lower(psmsgmychat42) or (string.sub(arg2, psstriniz1+1, psstrfine1-1)=="raid" and psmsgmychat42=="raid_warning") or (string.sub(arg2, psstriniz1+1, psstrfine1-1)=="raid_warning" and psmsgmychat42=="raid")  then

--вырезаем ник
local _,psstriniz2=string.find(arg2, "myname:")
if psstriniz2==nil then else
local psstrfine2=string.find(arg2, "++", psstriniz2)

local psbililinet=0
for i,getcrash in ipairs(pscanannouncetable42) do 
if getcrash == string.sub(arg2, psstriniz2+1, psstrfine2-1) then psbililinet=1
end end
if(psbililinet==0)then
table.insert(pscanannouncetable42,string.sub(arg2, psstriniz2+1, psstrfine2-1))
end

end
end
end
end
--конец получения данных о аннонсе2

--получение данных при задержке аннонса3
if arg1=="PhoenixStyle" and psmsgwaiting43>0 then

local _,psstriniz1=string.find(arg2, "mychat:")
if psstriniz1==nil then else
local psstrfine1=string.find(arg2, "++", psstriniz1)
if string.lower(string.sub(arg2, psstriniz1+1, psstrfine1-1))==string.lower(psmsgmychat43) or (string.sub(arg2, psstriniz1+1, psstrfine1-1)=="raid" and psmsgmychat43=="raid_warning") or (string.sub(arg2, psstriniz1+1, psstrfine1-1)=="raid_warning" and psmsgmychat43=="raid")  then

--вырезаем ник
local _,psstriniz2=string.find(arg2, "myname:")
if psstriniz2==nil then else
local psstrfine2=string.find(arg2, "++", psstriniz2)

local psbililinet=0
for i,getcrash in ipairs(pscanannouncetable43) do 
if getcrash == string.sub(arg2, psstriniz2+1, psstrfine2-1) then psbililinet=1
end end
if(psbililinet==0)then
table.insert(pscanannouncetable43,string.sub(arg2, psstriniz2+1, psstrfine2-1))
end

end
end
end
end
--конец получения данных о аннонсе3



--аддон аннонсит конец боя
--if arg1=="PhoenixStyle" and psmsgwaiting==0 then
if arg1=="PhoenixStyle" then
if string.find(arg2, "fightend") then
psnotanonsemore=GetTime()
local _,psstriniz1=string.find(arg2, "mychat:")
local psstrfine1=string.find(arg2, "++", psstriniz1)
psnotanonsemorechat=string.lower(string.sub(arg2, psstriniz1+1, psstrfine1-1))
end
end

if arg1=="PhoenixStyle" then
local _,psstriniz1=string.find(arg2, "mychat:")
local psstrfine1=string.find(arg2, "++", psstriniz1)
if (psmsgwaiting42==0 or (psmsgwaiting42>0 and psmsgmychat42~=string.lower(string.sub(arg2, psstriniz1+1, psstrfine1-1)))) and (psmsgwaiting43==0 or (psmsgwaiting43>0 and psmsgmychat43~=string.lower(string.sub(arg2, psstriniz1+1, psstrfine1-1)))) then
	if GetTime()>psnotanonsemorenormal+2 then
psnotanonsemorenormal=GetTime()
psnotanonsemorenormalchat=string.lower(string.sub(arg2, psstriniz1+1, psstrfine1-1))
	else
psnotanonsemorenormal2=GetTime()
psnotanonsemorenormalchat2=string.lower(string.sub(arg2, psstriniz1+1, psstrfine1-1))
	end
end
end
--конец

--получение инфы о запуске таймера
if arg1=="PhoenixStyle-pull" then
if arg4==UnitName("player") then else

pstimeruraid=GetTime()+tonumber(arg2)

end
end
--конец


--отправка моей инфы
if arg1=="PhoenixStyle_info" and arg2=="info" then
local psa1=0
local psa2=0
local psa3=0
local psa4=1
local psa5=0
local psa6=""
if thisaddonwork then psa1=1 end
if thisaddononoff then psa2=1 end
if psfnopromrep then psa3=1 end
if rscversion then psa5=rscversion end
if psicgalochki==nil then psa4=9 else if psicgalochki[1][1]==0 then psa4=0 end end
if psa4==0 or psa4==1 then
psa6="-"..whererepiccchat[1]..","..whererepiccchat[2]
end
SendAddonMessage("PhoenixStyle_info2", UnitName("player").." v."..psversion.." "..psa1..psa2..psa3.." rsc:"..psa5.." icc:"..psa4..psa6, arg3)
end

if arg1=="PSverwhips" and arg3=="WHISPER" then
local psa1=0
local psa2=0
local psa3=0
local psa4=1
local psa5=0
local psa6=""
if thisaddonwork then psa1=1 end
if thisaddononoff then psa2=1 end
if psfnopromrep then psa3=1 end
if rscversion then psa5=rscversion end
if psicgalochki==nil then psa4=9 else if psicgalochki[1][1]==0 then psa4=0 end end
if psa4==0 or psa4==1 then
psa6="-"..whererepiccchat[1]..","..whererepiccchat[2]
end
SendAddonMessage("PSverwhips2", UnitName("player").." v."..psversion.." "..psa1..psa2..psa3.." rsc:"..psa5.." icc:"..psa4..psa6, "WHISPER", arg4)
end

if arg1=="PSverwhips2" and arg3=="WHISPER" then
print(arg2)
end


--получение моей инфы
if arg1=="PhoenixStyle_info2" and psshushinfo then
if arg4==UnitName("player") then else
print (arg2)
end
end


--отключение автомарок
if arg1=="PS-marksoff" and arg2=="off" then
psautoupmarkssetoff()
end

if arg1=="PS-myvers" then

if tonumber(arg2)>psversion then

		if tonumber(arg2)-psversion>0.0007 then
	if psverschech2==nil and isbattlev==0 then
	psverschech2=1
psoldvern=tonumber(arg2)
if psoldvern>psversion then
PSFmain3_Textoldv:Show()
end
if tonumber(arg2)-psversion>0.004 then
print ("|cff99ffffPhoenixStyle|r - "..psnewversfound2)
else
local _, _, day = CalendarGetDate()
if psversionday==day then else
print ("|cff99ffffPhoenixStyle|r - "..psnewversfound)
psversionday=day
end
end
	end
		end


elseif tonumber(arg2)<psversion then
if pslastsendbinf==nil or (pslastsendbinf and GetTime()>pslastsendbinf+60) then
SendAddonMessage("PS-myvers", psversion, arg3)
pslastsendbinf=GetTime()
end
end
end

--инфо о профе
if arg1=="PSiccprof" and arg4~=UnitName("player") then
if IsAddOnLoaded("PhoenixStyleMod_Icecrown") then psiccprofcheckspam(arg2) end
end


end

	


if event == "PLAYER_REGEN_DISABLED" then


	timetocheck=0
	psfnotoffvar=0
	isbattlev=1
	psanonceinst=nil
if psbossblock and GetTime()-psbossblock>8 then
psbossblock=nil
end
	pszapuskdelayphasing=0



end
	

if event == "PLAYER_REGEN_ENABLED" then

	isbattlev=0

end


if event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_WARNING" or event == "CHAT_MSG_OFFICER" or event == "CHAT_MSG_GUILD" then

if arg1 then
if string.lower(arg1)=="вайп" or string.lower(arg1)=="wipe" or string.lower(arg1)=="dfqg" or string.lower(arg1)=="цшзу" or string.lower(arg1)=="wipe." or string.lower(arg1)=="!wipe" or string.lower(arg1)=="вайпаемся" or string.lower(arg1)=="вайп." or string.lower(arg1)=="ваип" then

local psgood=0

	for i = 1,GetNumRaidMembers() do local name,rank = GetRaidRosterInfo(i)
	if (rank > 0 and arg2==name) then psgood=1 end end

if psgood==1 then
if IsAddOnLoaded("PhoenixStyleMod_Icecrown") then psiccwipereport() end
end



end
end

end

if event == "ZONE_CHANGED_NEW_AREA" then
pszonechangedalldel=GetTime()
end


if event == "ADDON_LOADED" then

if arg1=="PhoenixStyle" then
if psoldvern>psversion then
PSFmain3_Textoldv:Show()
end

PSFmain3_Textver:SetText("ver-"..psversion.." (release)")

psmapbuttreflesh()

end
end

if event == "CHANNEL_UI_UPDATE" then
--если открыт фрейм тогда обновить картинку
if PSFmainchated:IsShown() then
openremovechat()
openaddchat()
else
	PhoenixStyleFailbot:UnregisterEvent("CHANNEL_UI_UPDATE")
end
end



if(lalaproverka==nil)then
--chechtekzone()
pszonechangedalldel=GetTime()-3
lalaproverka=1
end






if GetNumRaidMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

--обнулить проверку реса
if psbilresnut==1 then
if pstimeresnut==nil then
pstimeresnut=arg1+3
end
if arg1>pstimeresnut then psbilresnut=0 pstimeresnut=nil end
end



end







end --конец основной функции аддона











--==============================МЕНЮ===================================


function PhoenixStyleFailbot_Command(msg)
	local cmd, subCmd = PhoenixStyleFailbot_GetCmd(msg)


	if(string.lower(cmd)=="пулл" or string.lower(cmd)=="pull" or string.lower(cmd)=="атака" or string.lower(cmd)=="ataka" or string.lower(cmd)=="attack" or string.lower(cmd)=="pul" or string.lower(cmd)=="пул") then
			local val, crp = PhoenixStyleFailbot_GetCmd(subCmd)
			if (val=="2" or val=="3" or val=="4" or val=="5" or val=="6" or val=="7" or val=="8" or val=="9" or val=="10" or val=="11" or val=="12" or val=="13" or val=="14" or val=="15" or val=="16" or val=="17" or val=="18" or val=="19" or val=="20") then
if(IsRaidOfficer()==1) then
if pspullactiv==0 and thisaddonwork then

	timertopull=tonumber(val)

end
pslocaletimersm()
if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="zhTW" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" then
pslocaletimers()
end
psfpullbegin()
else

out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrornotofficer)
end --конец проверки на промоут



else

if pspullactiv==1 then
psfcancelpull()
else
print("|cff99ffffPhoenixStyle|r - "..pserrormenutimer1.."\n "..pserrormenutimer2)
end
end

	--конец пулла
	elseif(string.lower(cmd)=="rezet" or string.lower(cmd)=="reset" or string.lower(cmd)=="resetpos" or string.lower(cmd)=="резет" or string.lower(cmd)=="сбросить" or string.lower(cmd)=="res" or string.lower(cmd)=="rez") then

	PSFmain1:ClearAllPoints()
	PSFmain1:SetPoint("CENTER",UIParent,"CENTER")
PSFmain1:Hide()
PSFmain2:Hide()
PSF_closeallpr()

PSFmain1:Show()
PSFmain2:Show()
PSFmain3:Show()


	--wipe
	elseif(string.lower(cmd)=="wipe" or string.lower(cmd)=="вайп" or string.lower(cmd)=="результат" or string.lower(cmd)=="dfqg" or string.lower(cmd)=="цшзу" or string.lower(cmd)=="ваип") then

if IsAddOnLoaded("PhoenixStyleMod_Icecrown") then psiccwipereport() end

	--lanatel
	elseif(string.lower(cmd)=="vampyr" or string.lower(cmd)=="vampyric" or string.lower(cmd)=="vampyrs" or string.lower(cmd)=="food" or string.lower(cmd)=="еда" or string.lower(cmd)=="еду" or string.lower(cmd)=="вампир" or string.lower(cmd)=="вампиры") then

if IsAddOnLoaded("PhoenixStyleMod_Icecrown") then psicclanafoodmark() else out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psiccnoloaderr2)

end

	else

PSFmain1:Hide()
PSFmain2:Hide()
PSF_closeallpr()

PSFmain1:Show()
PSFmain2:Show()
PSFmain3:Show()






	end
end
function PhoenixStyleFailbot_GetCmd(msg)
	if(msg) then
		local a,b,c = strfind(msg, "(%S+)")
		if(a) then
			return c, strsub(msg, b+2)
		else	
			return ""
		end
	end
end


function PSF_buttonaddon()
PSF_closeallpr()
PSFmain3:Show()
end

function PSF_buttonautomark()
PSF_closeallpr()
PSFmain4_Button20:Hide()
PSFmain4_Button22:Hide()
PSFmain4_Textmark1:Hide()
PSFmain4_Textmark2:Hide()
psfautomarldraw()
PSFmain4:Show()
if(autorefmark) then PSFmain4_Button22:Show() PSFmain4_Textmark1:Show() else PSFmain4_Button20:Show() PSFmain4_Textmark2:Show() end
framewasinuse2=1

end

function PSF_buttontimers()
PSF_closeallpr()
if(thisaddonwork)then
pslocaletimersm()
if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="zhTW" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" then
pslocaletimers()
end
PSFmain5:Show()
psftimecrepol()
framewasinuse3=1
else
PSFmain10:Show()
end
end


function PSF_buttonulda()
PSF_closeallpr()
if(thisaddonwork)then
if IsAddOnLoaded("PhoenixStyleMod_Ulduar")==nil then
LoadAddOn("PhoenixStyleMod_Ulduar")
if IsAddOnLoaded("PhoenixStyleMod_Ulduar") then
print("|cff99ffffPhoenixStyle|r - "..psmoduleload.." "..psleftmenu5.."!")
end
end

if IsAddOnLoaded("PhoenixStyleMod_Ulduar") then
PSF_buttonulda2()
else
PSF_closeallpr()
PSFmain12:Show()
end
else
PSFmain10:Show()
end
end


function PSF_buttonkolizei()
PSF_closeallpr()
if(thisaddonwork)then
if IsAddOnLoaded("PhoenixStyleMod_Coliseum")==nil then
LoadAddOn("PhoenixStyleMod_Coliseum")
if IsAddOnLoaded("PhoenixStyleMod_Coliseum") then
print("|cff99ffffPhoenixStyle|r - "..psmoduleload.." "..psleftmenu6.."!")
end
end

if IsAddOnLoaded("PhoenixStyleMod_Coliseum") then
PSF_buttonkolizei2()
else
PSF_closeallpr()
PSFmain12:Show()
end
else
PSFmain10:Show()
end
end

function PSF_buttonicecrown()
PSF_closeallpr()
if(thisaddonwork)then
if IsAddOnLoaded("PhoenixStyleMod_Icecrown")==nil then
LoadAddOn("PhoenixStyleMod_Icecrown")
if IsAddOnLoaded("PhoenixStyleMod_Icecrown") then
	if psicgalochki[1][1]==0 then else
print("|cff99ffffPhoenixStyle|r - "..psmoduleload.." "..psleftmenu7.."!")
	end
end
end

if IsAddOnLoaded("PhoenixStyleMod_Icecrown") then
PSF_buttonicecrown2()
else
PSF_closeallpr()
PSFmain12:Show()
end
else
PSFmain10:Show()
end
end

function PSF_rscopen(oo)
PSF_closeallpr()
if rscversion and rscversion>1.09 then

if oo==1 then
rscwindow2()
end

if oo==2 then
rscwindow3()
end


else
PSFerrorframeuniq:Show()

if psftxterruniq==nil then
	psftxterruniq = PSFerrorframeuniq:CreateFontString()
	psftxterruniq:SetFont(GameFontNormal:GetFont(), 15)
	psftxterruniq:SetWidth(555)
	psftxterruniq:SetHeight(100)
	psftxterruniq:SetJustifyH("CENTER")
	psftxterruniq:SetJustifyV("TOP")
	psftxterruniq:SetPoint("CENTER",0,50)
end

psftxterruniq:SetText(psfneedrscaddon.." |cffff0000"..psfneedrscaddonver11.."|r\n\n"..psraaddonanet2)

end
end

function PSF_potionscheck(nn)

if nn then
PSF_buttonsaveexit()
PSFmain1:Show()
PSFmain2:Show()
else
PSF_closeallpr()
end


PSFpotioncheckframe:Show()
PSFpotioncheckframe_CheckButton1:Hide()
PSFpotioncheckframe_CheckButton2:Hide()
PSFpotioncheckframe_Button10:Hide()
PSFpotioncheckframe_Button11:Hide()
PSFpotioncheckframe_Button20:Hide()
PSFpotioncheckframe_Button30:Hide()
PSFpotioncheckframe_Button40:Hide()

if rscversion then
psfpotioncheckshow()
end
end


function PSF_closeallpr()
if IsAddOnLoaded("PhoenixStyleMod_Coliseum") then PSF_closeallprColiseum() end
if IsAddOnLoaded("PhoenixStyleMod_Ulduar") then PSF_closeallprUlduar() end
if IsAddOnLoaded("PhoenixStyleMod_Icecrown") then PSF_closeallpricecrown() end
PSFmain3:Hide()
PSFmain4:Hide()
PSFmain5:Hide()
PSFmain10:Hide()
PSFmain12:Hide()
PSFmainchated:Hide()
PSFmainrano:Hide()
PSFpotioncheckframe:Hide()
PSFerrorframeuniq:Hide()
PSFrscflask:Hide()
PSFrscbuff:Hide()
end

function out(text)
DEFAULT_CHAT_FRAME:AddMessage(text)
UIErrorsFrame:AddMessage(text, 1.0, 1.0, 0, 1, 10)
end



function PSFifreporton()
if (PSFmain3_CheckButton1:GetChecked()) then
		if(thisaddononoff)then
			else
			thisaddononoff=true
			out("|cff99ffffPhoenixStyle|r - "..pswarnings.." |cff00ff00"..pswarningson.."|r.")
			end
			else
			if(thisaddononoff)then
			out("|cff99ffffPhoenixStyle|r - "..pswarnings.." |cffff0000"..pswarningsoff.."|r.")
			thisaddononoff=false
		end
	end
psmapbuttreflesh()
end

function PSFminimaponoff()
if (PSFmain3_CheckButton4:GetChecked()) then
psminibutenabl=true
else
psminibutenabl=false
PS_MinimapButton:Hide()
end
psmapbuttreflesh()
end

function psautomarchangeno(numr)
truemark[numr]="false"
table.wipe(pssetmarknew[numr])
psautoupok[numr]:SetText("|cffff0000-|r")
end

--СОХРАНИЕ ИЗМЕНЕНИЙ
function PSF_buttonsaveexit()
if (framewasinuse2)then

if psfautomebtable then
for uu=1,8 do
	if psfautomebtable[uu]:GetText() == "" then psautomarchangeno(uu) else
	psmarksisinraid(psfautomebtable[uu]:GetText(), 0, uu)
	end
end
end

psdatrumark=0
for i=1,8 do
if truemark[i]=="true" then psdatrumark=1 end
end
if(autorefmark and psdatrumark==0) then
autorefmark=false
out("|cff99ffffPhoenixStyle|r - "..psmarkreflesh.." |cffff0000"..psmarkrefleshoff.."|r.")
end

end

if (framewasinuse11)then
	if (PSFmain11_primyogg:GetText() == "") then primyogg="" else
	primyogg=PSFmain11_primyogg:GetText()
	end
end

if frameanubused then pscolanubsave() frameanubused=nil end
if framesaurfused and psiccsauractiv==nil then psiccsaurfsave() framesaurfused=nil end

if rscframeuse3 then
rscsavenicks3()
rscframeuse3=nil
end



PSF_closeallpr()
PSFmain1:Hide()
PSFmain2:Hide()
framewasinuse2=nil
framewasinuse3=nil
framewasinuse4=nil
framewasinuse5=nil
framewasinuse8=nil
framewasinuse9=nil
framewasinuse11=nil
rscframeuse1=nil
end


--НАСТРОЙКА данных при загрузке окна настроек
function PSF_showoptions()
	if showopttime1==nil then
showopttime1=1
if psfchatadd==nil then psfchatadd={} end
bigmenuchatlist = {
pschatlist1,
pschatlist2,
pschatlist3,
pschatlist4,
pschatlist5,
pschatlist6,
pschatlist7,
pschatlist8,
}

if #psfchatadd>0 then
for i=1,#psfchatadd do
table.insert(bigmenuchatlist,psfchatadd[i])
end
end

	end

	framewasinuse2=nil
	framewasinuse3=nil
	framewasinuse4=nil
	framewasinuse5=nil
	framewasinuse8=nil --номерация дальше совпадает
	framewasinuse9=nil
	framewasinuse11=nil

if (thisaddononoff) then PSFmain3_CheckButton1:SetChecked() else PSFmain3_CheckButton1:SetChecked(false) end
if (thisaddonwork) then PSFmain3_CheckButton2:SetChecked() else PSFmain3_CheckButton2:SetChecked(false) end
if (psfnopromrep) then PSFmain3_CheckButton3:SetChecked() else PSFmain3_CheckButton3:SetChecked(false) end
if (psminibutenabl) then PSFmain3_CheckButton4:SetChecked() else PSFmain3_CheckButton4:SetChecked(false) end

if psfautomebtable then
for uy=1,8 do
local nicks=""
if #pssetmarknew[uy]>0 then
     for h=1,#pssetmarknew[uy] do
          if string.len(nicks)>1 then
               nicks=nicks..", "
          end
          nicks=nicks..pssetmarknew[uy][h]
     end
end
psfautomebtable[uy]:SetText(nicks)
end
end

end


function PSFvkladdon()
	if (PSFmain3_CheckButton2:GetChecked()) then
		if(thisaddonwork)then
			else
			thisaddonwork=true
			out("|cff99ffffPhoenixStyle|r - "..psaddonmy.." |cff00ff00"..psaddonon2.."|r.")
			pszonechangedall()
			end
			else
			if(thisaddonwork)then
			out("|cff99ffffPhoenixStyle|r - "..psaddonmy.." |cffff0000"..psaddonoff.."|r.")
			thisaddonwork=false
			psmylogin=GetTime()
			if IsAddOnLoaded("PhoenixStyleMod_Icecrown") then psiccwipereport() end
		end
end
psmapbuttreflesh()
end

function PSFrepnopromchange()
	if (PSFmain3_CheckButton3:GetChecked()) then
		if(psfnopromrep)then
			else
			psfnopromrep=true
			out("|cff99ffffPhoenixStyle|r - "..psaddonrepnoprom2)
			end
			else
			if(psfnopromrep)then
			out("|cff99ffffPhoenixStyle|r - "..psaddonrepnoprom3)
			psfnopromrep=false
		end
end end

function bigmenuchat2(bigma2)
bigma2num=0
for i,cchat in ipairs(bigmenuchatlisten) do 
if string.lower(cchat) == string.lower(bigma2) then bigma2num=i
end end
if bigma2num==0 then
for i,cchat in ipairs(psfchatadd) do 
if string.lower(cchat) == string.lower(bigma2) then bigma2num=i+8
end end
end
end


function PSF_RAaddon()
PSF_closeallpr()
if IsAddOnLoaded("RaidAchievement")==nil then
--нету аддона
PSFmainrano:Show()

else
--есть аддон

PSF_buttonsaveexit()

PSFeamain1:Show()
PSFeamain2:Show()
PSFeamain3:Show()

end

end



function vezaxsort1()
local vzxnn= # vezaxname
while vzxnn>1 do
if vezaxcrash[vzxnn]>vezaxcrash[vzxnn-1] then
local vezaxtemp1=vezaxcrash[vzxnn-1]
local vezaxtemp2=vezaxname[vzxnn-1]
vezaxcrash[vzxnn-1]=vezaxcrash[vzxnn]
vezaxname[vzxnn-1]=vezaxname[vzxnn]
vezaxcrash[vzxnn]=vezaxtemp1
vezaxname[vzxnn]=vezaxtemp2
end
vzxnn=vzxnn-1
end
end

function vezaxsort2()
local vzxnn= # vezaxname2
while vzxnn>1 do
if vezaxcrash2[vzxnn]>vezaxcrash2[vzxnn-1] then
local vezaxtemp1=vezaxcrash2[vzxnn-1]
local vezaxtemp2=vezaxname2[vzxnn-1]
vezaxcrash2[vzxnn-1]=vezaxcrash2[vzxnn]
vezaxname2[vzxnn-1]=vezaxname2[vzxnn]
vezaxcrash2[vzxnn]=vezaxtemp1
vezaxname2[vzxnn]=vezaxtemp2
end
vzxnn=vzxnn-1
end
end

function vezaxsort3()
local vzxnn= # vezaxname3
while vzxnn>1 do
if vezaxcrash3[vzxnn]>vezaxcrash3[vzxnn-1] then
local vezaxtemp1=vezaxcrash3[vzxnn-1]
local vezaxtemp2=vezaxname3[vzxnn-1]
vezaxcrash3[vzxnn-1]=vezaxcrash3[vzxnn]
vezaxname3[vzxnn-1]=vezaxname3[vzxnn]
vezaxcrash3[vzxnn]=vezaxtemp1
vezaxname3[vzxnn]=vezaxtemp2
end
vzxnn=vzxnn-1
end
end

function vezaxsort4()
local vzxnn= # vezaxname4
while vzxnn>1 do
if vezaxcrash4[vzxnn]>vezaxcrash4[vzxnn-1] then
local vezaxtemp1=vezaxcrash4[vzxnn-1]
local vezaxtemp2=vezaxname4[vzxnn-1]
vezaxcrash4[vzxnn-1]=vezaxcrash4[vzxnn]
vezaxname4[vzxnn-1]=vezaxname4[vzxnn]
vezaxcrash4[vzxnn]=vezaxtemp1
vezaxname4[vzxnn]=vezaxtemp2
end
vzxnn=vzxnn-1
end
end

function PSFprepareUI()
bossmodtext1=pstimersinfo2.." |cff00ff00BigWigs    DBM    DXE    RaidWatch2|r"
end


function reportafterboitwotab(inwhichchat, bojinterr, tabln, tablc, qq, maxpers,iccsv,norep,skobki)

local strochkavezcrash2=""
if (tabln==nil or tabln=={}) then tabln = {} end
if (tablc==nil or tablc=={}) then tablc = {} end
local vzxnn= # tabln
local pstochki=""
if(vzxnn>0)then
if maxpers==nil then maxpers=25 end
if vzxnn>maxpers then vzxnn=maxpers pstochki=", ..." else pstochki="." end
for i = 1,vzxnn do

if i==vzxnn then
	if (string.len(strochkavezcrash) > 230 and qq==nil) then
		if skobki then
		strochkavezcrash2=strochkavezcrash2..tabln[i]..pstochki
		else
		strochkavezcrash2=strochkavezcrash2..tabln[i].." ("..tablc[i]..")"..pstochki
		end
	else
		if skobki then
		strochkavezcrash=strochkavezcrash..tabln[i]..pstochki
		else
		strochkavezcrash=strochkavezcrash..tabln[i].." ("..tablc[i]..")"..pstochki
		end
	end
		pszapuskanonsa(inwhichchat, strochkavezcrash, bojinterr,nil,iccsv,norep)
			if (string.len(strochkavezcrash2) > 3 and qq==nil) then pszapuskanonsa(inwhichchat, strochkavezcrash2, bojinterr,nil,iccsv,norep) end
else
	if (string.len(strochkavezcrash) > 230 and qq==nil) then
		if skobki then
		strochkavezcrash2=strochkavezcrash2..tabln[i]..", "
		else
		strochkavezcrash2=strochkavezcrash2..tabln[i].." ("..tablc[i].."), "
		end
	else
		if skobki then
		strochkavezcrash=strochkavezcrash..tabln[i]..", "
		else
		strochkavezcrash=strochkavezcrash..tabln[i].." ("..tablc[i].."), "
		end
	end
end
end
end

end



function psfwipecheck()
psnumdead=0
for i = 1,GetNumRaidMembers() do local name,rank,subgroup,level,class,fileName,zone,online,isDead = GetRaidRosterInfo(i) if (isDead==1 and subgroup<6) then
psnumdead=psnumdead+1
end end
end

function pscheckwipe1(numd10,numd25)
local psnumdead=0
pswipetrue=nil

if pswipecheckdelay==nil or (pswipecheckdelay and GetTime()>pswipecheckdelay+2) then
pswipecheckdelay=GetTime()


local psnumgrup=2
	if GetRaidDifficulty()==2 or GetRaidDifficulty()==4 then
	psnumgrup=5
	end
for i = 1,GetNumRaidMembers() do local nameee,_,subgroup,_,_,_,_,_,isDead = GetRaidRosterInfo(i) if ((isDead==1 or UnitIsDeadOrGhost(nameee)==1) and subgroup<=psnumgrup) then
psnumdead=psnumdead+1
end end

if ((psnumgrup==2 and psnumdead>=numd10) or (psnumgrup==5 and psnumdead>=numd25)) then
pswipetrue=1
end


end --delay

end


function addtotwotables(nicktoadd)

local bililine=0
for i,getcrash in ipairs(vezaxname) do 
if getcrash == nicktoadd then vezaxcrash[i]=vezaxcrash[i]+1 bililine=1
end end
if(bililine==0)then
table.insert(vezaxname,nicktoadd) 
table.insert(vezaxcrash,1) 
end

end

function addtotwotables2(nicktoadd)

local bililine=0
for i,getcrash in ipairs(vezaxname2) do 
if getcrash == nicktoadd then vezaxcrash2[i]=vezaxcrash2[i]+1 bililine=1
end end
if(bililine==0)then
table.insert(vezaxname2,nicktoadd) 
table.insert(vezaxcrash2,1) 
end

end

function addtotwotables3(nicktoadd)

local bililine=0
for i,getcrash in ipairs(vezaxname3) do 
if getcrash == nicktoadd then vezaxcrash3[i]=vezaxcrash3[i]+1 bililine=1
end end
if(bililine==0)then
table.insert(vezaxname3,nicktoadd) 
table.insert(vezaxcrash3,1) 
end

end


function addtotwotables4(nicktoadd)

local bililine=0
for i,getcrash in ipairs(vezaxname4) do 
if getcrash == nicktoadd then vezaxcrash4[i]=vezaxcrash4[i]+1 bililine=1
end end
if(bililine==0)then
table.insert(vezaxname4,nicktoadd) 
table.insert(vezaxcrash4,1) 
end

end



function chechtekzone()

--ульдуар

if GetRealZoneText()==pszoneulduar then
if IsAddOnLoaded("PhoenixStyleMod_Ulduar")==nil and wasuldatryload==nil then
wasuldatryload=1
local loaded, reason = LoadAddOn("PhoenixStyleMod_Ulduar")
if loaded then
print("|cff99ffffPhoenixStyle|r - "..psmoduleload.." "..psleftmenu5.."!")
else
print("|cff99ffffPhoenixStyle|r - "..psmodulenotload.." "..psleftmenu5.."!")
end
end
end

--Испытание крестоносца

if GetRealZoneText()==pszonecoliseum then
if IsAddOnLoaded("PhoenixStyleMod_Coliseum")==nil and wascoliseumtryload==nil then
wascoliseumtryload=1
local loaded, reason = LoadAddOn("PhoenixStyleMod_Coliseum")
if loaded then
print("|cff99ffffPhoenixStyle|r - "..psmoduleload.." "..psleftmenu6.."!")
else
print("|cff99ffffPhoenixStyle|r - "..psmodulenotload.." "..psleftmenu6.."!")
end
end
end

--цлк

if GetRealZoneText()==pszoneicecrowncit then

	if psverschech1 then
if (UnitInRaid("player")) then
SendAddonMessage("PS-myvers", psversion, "raid")
end
	end

if IsAddOnLoaded("PhoenixStyleMod_Icecrown")==nil and wasicecrowntryload==nil then
wasicecrowntryload=1
local loaded, reason = LoadAddOn("PhoenixStyleMod_Icecrown")
if loaded then
print("|cff99ffffPhoenixStyle|r - "..psmoduleload.." "..psleftmenu7.."!")
else
print("|cff99ffffPhoenixStyle|r - "..psmodulenotload.." "..psleftmenu7.."!")
end
end
end

end

function psfnotofficer()
if (psfnotoffvar==0)then
psfnotoffvar=1
print("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psfnotofficerspam)
end
end


function addtotridamagetables(nicktoadd, damagetoadd, count)

if (psdamagename==nil or psdamagename=={}) then psdamagename = {} end
if (psdamagevalue==nil or psdamagevalue=={}) then psdamagevalue = {} end
if (psdamageraz==nil or psdamageraz=={}) then psdamageraz = {} end
local bililine=0
for i,getcrash in ipairs(psdamagename) do 
if getcrash == nicktoadd then psdamagevalue[i]=psdamagevalue[i]+damagetoadd psdamageraz[i]=psdamageraz[i]+count bililine=1
end end
if(bililine==0)then
table.insert(psdamagename,nicktoadd) 
table.insert(psdamagevalue,damagetoadd)
table.insert(psdamageraz,count)
end

end

function addtotwodamagetables(nicktoadd, damagetoadd)

if (psdamagename2==nil or psdamagename2=={}) then psdamagename2 = {} end
if (psdamagevalue2==nil or psdamagevalue2=={}) then psdamagevalue2 = {} end
local bililine=0
for i,getcrash in ipairs(psdamagename2) do 
if getcrash == nicktoadd then psdamagevalue2[i]=psdamagevalue2[i]+damagetoadd bililine=1
end end
if(bililine==0)then
table.insert(psdamagename2,nicktoadd) 
table.insert(psdamagevalue2,damagetoadd)
end

end

function addtotwodamagetables3(nicktoadd, damagetoadd)

if (psdamagename3==nil or psdamagename3=={}) then psdamagename3 = {} end
if (psdamagevalue3==nil or psdamagevalue3=={}) then psdamagevalue3 = {} end
local bililine=0
for i,getcrash in ipairs(psdamagename3) do 
if getcrash == nicktoadd then psdamagevalue3[i]=psdamagevalue3[i]+damagetoadd bililine=1
end end
if(bililine==0)then
table.insert(psdamagename3,nicktoadd) 
table.insert(psdamagevalue3,damagetoadd)
end

end

function psdamagetritablsort1()
local vzxnnw= # psdamagename
while vzxnnw>1 do
if psdamagevalue[vzxnnw]>psdamagevalue[vzxnnw-1] then
local vezaxtempv1=psdamagevalue[vzxnnw-1]
local vezaxtempv2=psdamagename[vzxnnw-1]
local vezaxtempv3=psdamageraz[vzxnnw-1]
psdamagevalue[vzxnnw-1]=psdamagevalue[vzxnnw]
psdamagename[vzxnnw-1]=psdamagename[vzxnnw]
psdamageraz[vzxnnw-1]=psdamageraz[vzxnnw]
psdamagevalue[vzxnnw]=vezaxtempv1
psdamagename[vzxnnw]=vezaxtempv2
psdamageraz[vzxnnw]=vezaxtempv3
end
vzxnnw=vzxnnw-1
end
end

function psdamagetwotablsort1()
local vzxnnw= # psdamagename2
while vzxnnw>1 do
if psdamagevalue2[vzxnnw]>psdamagevalue2[vzxnnw-1] then
local vezaxtempv1=psdamagevalue2[vzxnnw-1]
local vezaxtempv2=psdamagename2[vzxnnw-1]
psdamagevalue2[vzxnnw-1]=psdamagevalue2[vzxnnw]
psdamagename2[vzxnnw-1]=psdamagename2[vzxnnw]
psdamagevalue2[vzxnnw]=vezaxtempv1
psdamagename2[vzxnnw]=vezaxtempv2
end
vzxnnw=vzxnnw-1
end
end

function psdamagetwotablsort3()
local vzxnnw= # psdamagename3
if psdamagename3 and # psdamagename3>1 then
while vzxnnw>1 do
if psdamagevalue3[vzxnnw]>psdamagevalue3[vzxnnw-1] then
local vezaxtempv1=psdamagevalue3[vzxnnw-1]
local vezaxtempv2=psdamagename3[vzxnnw-1]
psdamagevalue3[vzxnnw-1]=psdamagevalue3[vzxnnw]
psdamagename3[vzxnnw-1]=psdamagename3[vzxnnw]
psdamagevalue3[vzxnnw]=vezaxtempv1
psdamagename3[vzxnnw]=vezaxtempv2
end
vzxnnw=vzxnnw-1
end
end
end


function reportfromtridamagetables(inwhichchat,maxpers,qq,bojinterr,iccra,norep)

if (psdamagename==nil or psdamagename=={}) then psdamagename = {} end
if (psdamagevalue==nil or psdamagevalue=={}) then psdamagevalue = {} end
if (psdamageraz==nil or psdamageraz=={}) then psdamageraz = {} end
local strochkavezcrash2=""
local psinfoshieldtempdamage=""
local vzxnn= # psdamagename
local pstochki=""
if(vzxnn>0)then
if vzxnn>maxpers then vzxnn=maxpers pstochki=", ..." else pstochki="." end
for i = 1,vzxnn do


			if psdamagevalue[i] and psdamagevalue[i]>0 then

	if (string.len(psdamagevalue[i])) > 3 then
	psinfoshieldtempdamage=string.sub(psdamagevalue[i], 1, string.len(psdamagevalue[i])-3) psinfoshieldtempdamage=psinfoshieldtempdamage.."k"
	else
	psinfoshieldtempdamage=psdamagevalue[i]
	end
			end

if i==vzxnn then

			if psdamagevalue[i] and psdamagevalue[i]>0 then
	if (string.len(strochkadamageout) > 230 and qq==nil) then strochkavezcrash2=strochkavezcrash2..psdamagename[i].." ("..psinfoshieldtempdamage.." - "..psdamageraz[i]..")"..pstochki else strochkadamageout=strochkadamageout..psdamagename[i].." ("..psinfoshieldtempdamage.." - "..psdamageraz[i]..")"..pstochki end
			end
		pszapuskanonsa(inwhichchat, strochkadamageout,bojinterr,nil,iccra,norep)

if (string.len(strochkavezcrash2) > 3 and qq==nil) then pszapuskanonsa(inwhichchat, strochkavezcrash2, bojinterr,nil,iccra,norep) end
else
			if psdamagevalue[i] and psdamagevalue[i]>0 then
	if (string.len(strochkadamageout) > 230 and qq==nil) then
		strochkavezcrash2=strochkavezcrash2..psdamagename[i].." ("..psinfoshieldtempdamage.." - "..psdamageraz[i].."), "
	else
	strochkadamageout=strochkadamageout..psdamagename[i].." ("..psinfoshieldtempdamage.." - "..psdamageraz[i].."), "
	end
			end
end
end
end

end


function reportfromtwodamagetables(inwhichchat, qq, dmggood, numrrep, bojinterr,iccra,norep)

local strochkavezcrash2=""
if (psdamagename2==nil or psdamagename2=={}) then psdamagename2 = {} end
if (psdamagevalue2==nil or psdamagevalue2=={}) then psdamagevalue2 = {} end
local vzxnn= # psdamagename2
local psinfoshieldtempdamage=""
local pstochki=""
if(vzxnn>0)then
if numrrep then else numrrep=18 end
if vzxnn>numrrep then vzxnn=numrrep pstochki=", ..." else pstochki="." end
for i = 1,vzxnn do

			if dmggood==nil or psdamagevalue2[i]>dmggood then

	if (string.len(psdamagevalue2[i])) > 3 then
	psinfoshieldtempdamage=string.sub(psdamagevalue2[i], 1, string.len(psdamagevalue2[i])-3) psinfoshieldtempdamage=psinfoshieldtempdamage.."k"
	else
	psinfoshieldtempdamage=psdamagevalue2[i]
	end

			end

if i==vzxnn then

			if dmggood==nil or psdamagevalue2[i]>dmggood then
if (string.len(strochkadamageout) > 230 and qq==nil) then strochkavezcrash2=strochkavezcrash2..psdamagename2[i].." ("..psinfoshieldtempdamage..")"..pstochki else strochkadamageout=strochkadamageout..psdamagename2[i].." ("..psinfoshieldtempdamage..")"..pstochki end
			end

		pszapuskanonsa(inwhichchat, strochkadamageout, bojinterr,nil,iccra,norep)
if (string.len(strochkavezcrash2) > 3 and qq==nil) then pszapuskanonsa(inwhichchat, strochkavezcrash2, bojinterr,nil,iccra,norep) end
else

			if dmggood==nil or psdamagevalue2[i]>dmggood then
	if (string.len(strochkadamageout) > 230 and qq==nil) then
		strochkavezcrash2=strochkavezcrash2..psdamagename2[i].." ("..psinfoshieldtempdamage.."), "
	else
	strochkadamageout=strochkadamageout..psdamagename2[i].." ("..psinfoshieldtempdamage.."), "
	end
			end

end



end
end

end

function reportfromtwodamagetables3(inwhichchat, bojinterr, skokre,iccra,norep)

local strochkavezcrash2=""
if (psdamagename3==nil or psdamagename3=={}) then psdamagename3 = {} end
if (psdamagevalue3==nil or psdamagevalue3=={}) then psdamagevalue3 = {} end
local vzxnn= # psdamagename3
local psinfoshieldtempdamage=""
local pstochki=""
if(vzxnn>0)then
if vzxnn>skokre then vzxnn=skokre pstochki=", ..." else pstochki="." end
for i = 1,vzxnn do

	if (string.len(psdamagevalue3[i])) > 3 then
	psinfoshieldtempdamage=string.sub(psdamagevalue3[i], 1, string.len(psdamagevalue3[i])-3) psinfoshieldtempdamage=psinfoshieldtempdamage.."k"
	else
	psinfoshieldtempdamage=psdamagevalue3[i]
	end

if i==vzxnn then
if string.len(strochkadamageout) > 230 then strochkavezcrash2=strochkavezcrash2..psdamagename3[i].." ("..psinfoshieldtempdamage..")"..pstochki else strochkadamageout=strochkadamageout..psdamagename3[i].." ("..psinfoshieldtempdamage..")"..pstochki end

		pszapuskanonsa(inwhichchat, strochkadamageout, bojinterr,nil,iccra,norep)
if string.len(strochkavezcrash2) > 3 then pszapuskanonsa(inwhichchat, strochkavezcrash2, bojinterr,nil,iccra,norep) end
else
	if string.len(strochkadamageout) > 230 then
		strochkavezcrash2=strochkavezcrash2..psdamagename3[i].." ("..psinfoshieldtempdamage.."), "
	else
	strochkadamageout=strochkadamageout..psdamagename3[i].." ("..psinfoshieldtempdamage.."), "
	end

end
end
end

end


function pszapuskanonsa(kudarep, chtorep, bojinterr, vajnreport, addicc, norep)

--saving boss info for icc module
if addicc then
if psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30)) then
if addicc>5 then
psiccsavedfails[addicc][1]=chtorep
else
local uu=5
while uu<=#psiccsavedfails do
	if psiccsavedfails[uu][1]=="0" then
		psiccsavedfails[uu][1]=chtorep
		uu=100
	end
uu=uu+1
end

end
psicclastsaverep=GetTime()
end
end

if norep==nil then



if thisaddononoff and kudarep and chtorep then

if kudarep=="sebe" then

if (string.find(chtorep, "{")==1) then
	if (string.find(chtorep, "} ")) then
		DEFAULT_CHAT_FRAME:AddMessage("- "..string.sub(chtorep, string.find(chtorep, "}")+2))
	else
		DEFAULT_CHAT_FRAME:AddMessage("- "..string.sub(chtorep, string.find(chtorep, "}")+1))
	end
else
DEFAULT_CHAT_FRAME:AddMessage(chtorep)
end

else
--if(IsRaidOfficer()==1 or psfnopromrep) then
if((kudarep=="raid" or kudarep=="raid_warning") and IsRaidOfficer()==nil and psfnopromrep==false) then
psfnotofficer()
else

		if (bojinterr and ((GetTime()<psnotanonsemore+70 and psnotanonsemorechat and (psnotanonsemorechat==kudarep or (psnotanonsemorechat=="raid_warning" and kudarep=="raid") or (psnotanonsemorechat=="raid" and kudarep=="raid_warning"))) or GetTime()<psmylogin+180)) then
		else

		if ((bojinterr==nil or bojinterr==false) and (GetTime()<psnotanonsemorenormal+2 and psnotanonsemorenormalchat and (psnotanonsemorenormalchat==kudarep or (psnotanonsemorenormalchat=="raid_warning" and kudarep=="raid") or (psnotanonsemorenormalchat=="raid" and kudarep=="raid_warning")))) then
		else

		if ((bojinterr==nil or bojinterr==false) and (GetTime()<psnotanonsemorenormal2+2 and psnotanonsemorenormalchat2 and (psnotanonsemorenormalchat2==kudarep or (psnotanonsemorenormalchat2=="raid_warning" and kudarep=="raid") or (psnotanonsemorenormalchat2=="raid" and kudarep=="raid_warning")))) then
		else

--проверка нестандартного чата
local bililine=0
for i,cc in ipairs(bigmenuchatlisten) do
if cc == kudarep then bililine=1
end end

if bililine==0 then
if GetChannelName(kudarep)==0 then
JoinPermanentChannel(kudarep)
ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, kudarep)
end
end

	if (bililine==1 or (bililine==0 and GetChannelName(kudarep)>0)) then

--3 Типа анонсов, после боя, по ходу боя в 1 канал, по ходу боя в 2 канал

--после боя
if bojinterr then

if psmsgwaiting==0 then
if bojinterr then pssendinterboj=1 else pssendinterboj=nil end
if vajnreport then psanounsesrazuchek=1 end
psmsgtimestart=GetTime()
psmsgwaiting=GetTime()
psmsgmychat=kudarep --мой чат в который идет аннонс
psnamemsgsend=UnitName("player")
if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" then psnamemsgsend="00"..psnamemsgsend end
if IsRaidOfficer()==1 then psnamemsgsend="0"..psnamemsgsend end
table.wipe(pscanannouncetable)
table.insert(pscanannouncetable, psnamemsgsend)
end

table.insert (psannouncewait, chtorep)

elseif (psmsgwaiting42==0 and (psmsgwaiting43==0 or (psmsgwaiting43>0 and psmsgmychat43~=kudarep))) or (psmsgwaiting42>0 and psmsgmychat42==kudarep) then

if psmsgwaiting42==0 then
if vajnreport then psanounsesrazuchek=1 end
psmsgtimestart42=GetTime()
psmsgwaiting42=GetTime()
psmsgmychat42=kudarep
psnamemsgsend=UnitName("player")
if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" then psnamemsgsend="00"..psnamemsgsend end
if IsRaidOfficer()==1 then psnamemsgsend="0"..psnamemsgsend end
table.wipe(pscanannouncetable42)
table.insert(pscanannouncetable42, psnamemsgsend)
end

table.insert (psannouncewait42, chtorep)


else

if psmsgwaiting43==0 then
if vajnreport then psanounsesrazuchek=1 end
psmsgtimestart43=GetTime()
psmsgwaiting43=GetTime()
psmsgmychat43=kudarep
psnamemsgsend=UnitName("player")
if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" then psnamemsgsend="00"..psnamemsgsend end
if IsRaidOfficer()==1 then psnamemsgsend="0"..psnamemsgsend end
table.wipe(pscanannouncetable43)
table.insert(pscanannouncetable43, psnamemsgsend)
end

table.insert (psannouncewait43, chtorep)

end


	end



		end
		end
		end

--else
--psfnotofficer()
end
end

end --thisaddononoff

end --norep

end




function PS_MinimapButton_Reposition()
	PS_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(PS_Settings.PSMinimapPos)),(80*sin(PS_Settings.PSMinimapPos))-52)
end

function PS_MinimapButton_DraggingFrame_OnUpdate()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70
	ypos = ypos/UIParent:GetScale()-ymin-70

	PS_Settings.PSMinimapPos = math.deg(math.atan2(ypos,xpos))
	PS_MinimapButton_Reposition()
end

--arg1="LeftButton", "RightButton"
function PS_MinimapButton_OnClick()

GameTooltip:Hide()

	if PSFmain1:IsShown() then
PSF_buttonsaveexit()
	else
PSFmain1:Hide()
PSFmain2:Hide()
PSF_closeallpr()
PSFmain1:Show()
PSFmain2:Show()
PSFmain3:Show()
	end

end


function PS_MinimapButton_OnEnter(self)
	if (self.dragging) then
		return
	end
	GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT")
	PS_MinimapButton_Details(GameTooltip)
end


function PS_MinimapButton_Details(tt, ldb)
	tt:SetText("PhoenixStyle")

end

function psver(cchat)
psshushinfo=GetTime()+7
local psa1=0
local psa2=0
local psa3=0
local psa4=1
local psa5=0
local psa6=""
if thisaddonwork then psa1=1 end
if thisaddononoff then psa2=1 end
if psfnopromrep then psa3=1 end
if rscversion then psa5=rscversion end
if psicgalochki==nil then psa4=9 else if psicgalochki[1][1]==0 then psa4=0 end end
if psa4==0 or psa4==1 then
psa6="-"..whererepiccchat[1]..","..whererepiccchat[2]
end
print (UnitName("player").." v."..psversion.." "..psa1..psa2..psa3.." rsc:"..psa5.." icc:"..psa4..psa6)
if cchat==nil then
SendAddonMessage("PhoenixStyle_info", "info", "raid")
else
SendAddonMessage("PhoenixStyle_info", "info", cchat)
end
end

function psmapbuttreflesh()
if pstextffgdgdf==nil then
pstextffgdgdf=1

tpsicon = PS_MinimapButton:CreateTexture(nil,"MEDIUM")
tpsicon:SetTexture("Interface\\AddOns\\PhoenixStyle\\icon_phoenix_e")
tpsicon:SetWidth(21)
tpsicon:SetHeight(21)
tpsicon:SetPoint("TOPLEFT",7,-6)
PS_MinimapButton.texture = tpsicon
end


	if psminibutenabl then
PS_MinimapButton:Show()

	if IsAddOnLoaded("SexyMap") then
	else
	PS_MinimapButton_Reposition()
	end

if thisaddononoff and thisaddonwork then
tpsicon:SetTexture("Interface\\AddOns\\PhoenixStyle\\icon_phoenix_e")
else
tpsicon:SetTexture("Interface\\AddOns\\PhoenixStyle\\icon_phoenix_d")
end
	else
	PS_MinimapButton:Hide()
	end
end


function psfautomarldraw()
if psfautomarkdaw1==nil then
psfautomarkdaw1=1
PSFmain4_Timerref:SetValue(secrefmark)

psfautomebtable={}
local psebf1 = CreateFrame("EditBox", "pseb1", PSFmain4,"InputBoxTemplate")
pseditframecreat(psebf1,-130,1)
local psebf2 = CreateFrame("EditBox", "pseb2", PSFmain4,"InputBoxTemplate")
pseditframecreat(psebf2,-155,2)
local psebf3 = CreateFrame("EditBox", "pseb3", PSFmain4,"InputBoxTemplate")
pseditframecreat(psebf3,-180,3)
local psebf4 = CreateFrame("EditBox", "pseb4", PSFmain4,"InputBoxTemplate")
pseditframecreat(psebf4,-205,4)
local psebf5 = CreateFrame("EditBox", "pseb5", PSFmain4,"InputBoxTemplate")
pseditframecreat(psebf5,-230,5)
local psebf6 = CreateFrame("EditBox", "pseb6", PSFmain4,"InputBoxTemplate")
pseditframecreat(psebf6,-255,6)
local psebf7 = CreateFrame("EditBox", "pseb7", PSFmain4,"InputBoxTemplate")
pseditframecreat(psebf7,-280,7)
local psebf8 = CreateFrame("EditBox", "pseb8", PSFmain4,"InputBoxTemplate")
pseditframecreat(psebf8,-305,8)

local t2 = PSFmain4:CreateFontString()
t2:SetWidth(280)
t2:SetHeight(400)
t2:SetFont(GameFontNormal:GetFont(), 13)
t2:SetPoint("TOPLEFT",280,-25)
t2:SetText(psautomarktxtinf.."\r\n\r\n\r\n"..psautomarnewinfo)
t2:SetJustifyH("LEFT")
t2:SetJustifyV("TOP")

psautoupok={}

local psautoupok1 = PSFmain4:CreateFontString()
table.insert(psautoupok,psautoupok1)
psautoupok2 = PSFmain4:CreateFontString()
table.insert(psautoupok,psautoupok2)
psautoupok3 = PSFmain4:CreateFontString()
table.insert(psautoupok,psautoupok3)
psautoupok4 = PSFmain4:CreateFontString()
table.insert(psautoupok,psautoupok4)
psautoupok5 = PSFmain4:CreateFontString()
table.insert(psautoupok,psautoupok5)
psautoupok6 = PSFmain4:CreateFontString()
table.insert(psautoupok,psautoupok6)
psautoupok7 = PSFmain4:CreateFontString()
table.insert(psautoupok,psautoupok7)
psautoupok8 = PSFmain4:CreateFontString()
table.insert(psautoupok,psautoupok8)



for i=1,8 do
local t = PSFmain4:CreateTexture(nil,"OVERLAY")
t:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_"..i)
t:SetPoint("TOPLEFT",27,-106-i*25)
t:SetWidth(20)
t:SetHeight(20)
psautoupokfunc(psautoupok[i],i)
end
end
end

function psautoupokfunc(ttt,y)
ttt:SetWidth(80)
ttt:SetHeight(40)
ttt:SetFont(GameFontNormal:GetFont(), 13)
ttt:SetPoint("TOPLEFT",230,-108-25*y)
ttt:SetText("|cffff0000-|r")
ttt:SetJustifyH("LEFT")
ttt:SetJustifyV("TOP")
end


function pseditframecreat(a,b,nr)
a:SetAutoFocus(false)
a:SetHeight(20)
a:SetWidth(170)
a:SetPoint("TOPLEFT", 57, b)
a:Show()
a:SetScript("OnTabPressed", function(self) if psfautomebtable[nr+1] then psfautomebtable[nr+1]:SetFocus() psfautomebtable[nr+1]:HighlightText() else psfautomebtable[1]:SetFocus() psfautomebtable[1]:HighlightText() end end )
a:SetScript("OnEnterPressed", function(self) psautomarunfoc() end )

local nicks=""
if #pssetmarknew[nr]>0 then
	for h=1,#pssetmarknew[nr] do
		if string.len(nicks)>1 then
			nicks=nicks..", "
		end
		nicks=nicks..pssetmarknew[nr][h]
	end
end

a:SetText(nicks)
table.insert(psfautomebtable,a)
end

function psautoupmarkssetoff()
if (autorefmark) then
timeeventr=0
PSF_buttonoffmark()
end
end

function psmarksoff(where)
if where==nil then
SendAddonMessage("PS-marksoff", "off", "raid")
else
SendAddonMessage("PS-marksoff", "off", where)
end
end

function psfpotioncheckshow()
rscframeuse1=1
PSFpotioncheckframe_Text1:Hide()
PSFpotioncheckframe_Text2:Hide()
PSFpotioncheckframe_Text3:Hide()
PSFpotioncheckframe_CheckButton1:Show()
PSFpotioncheckframe_CheckButton2:Show()
if rscversion and rscversion>1.004 then
PSFpotioncheckframe_Buttonrezet:Show()
end
rsc_showoptions()
rscrefleshinfo(1)
if rsclocpot16==nil then
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psrscoldvers)
end

end


function psfchatsendreports(chat, nnn1, nnn2, nnn3, nnn4, nnn5, nnn6, nnn7, nnn8, nnn9, nnn10,nnn11,nnn12, whisp)
if nnn1==nil then nnn1=" " end
if nnn2==nil then nnn2=" " end
if nnn3==nil then nnn3=" " end
if nnn4==nil then nnn4=" " end
if nnn5==nil then nnn5=" " end
if nnn6==nil then nnn6=" " end
if nnn7==nil then nnn7=" " end
if nnn8==nil then nnn8=" " end
if nnn9==nil then nnn9=" " end
if nnn10==nil then nnn10=" " end
if nnn11==nil then nnn11=" " end
if nnn12==nil then nnn12=" " end
local nnn={nnn1,nnn2,nnn3,nnn4,nnn5,nnn6,nnn7,nnn8,nnn9,nnn10,nnn11,nnn12}
for i=1,12 do
if string.len(nnn[i])>3 then

if chat=="sebe" then
DEFAULT_CHAT_FRAME:AddMessage(nnn[i])
elseif chat=="whisper" then

SendChatMessage(nnn[i], "WHISPER", nil, whisp)

else
local bililine=0
for i,cc in ipairs(bigmenuchatlisten) do 
if cc == chat then bililine=1
end end


	if bililine==1 then

		SendChatMessage(nnn[i], chat)
	else


local nrchatmy=GetChannelName(chat)
		if nrchatmy==0 then
	JoinPermanentChannel(chat)
	ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, chat)
	nrchatmy=GetChannelName(chat)
		end
if nrchatmy>0 then
SendChatMessage(nnn[i], "CHANNEL",nil,nrchatmy)
end

	end
end


end
end
end

function psslidertimerefmark()
secrefmark = PSFmain4_Timerref:GetValue()
local text=""
if GetLocale() == "ruRU" then
text=psmarkinfo1.." "..secrefmark.." "..pssec
else
text=psmarkinfo1.." "..secrefmark
end
PSFmain4_Textin:SetText(text)
if (autorefmark) then
timeeventr=GetTime()+secrefmark
end
end

function pszonechangedall()
chechtekzone()

	if psverschech1==nil then
psverschech1=1
if (UnitInRaid("player")) then
SendAddonMessage("PS-myvers", psversion, "raid")
end

if IsInGuild() then
SendAddonMessage("PS-myvers", psversion, "guild")
end
	end
end

function PSF_marksoffsetaut()
if autorefmark then
PSF_buttonoffmark()
end
psunmarkallraiders=GetTime()+1
end


function psunitisplayer(id,name)
psunitplayertrue=nil

if UnitInRaid(name) then
psunitplayertrue=1
else
	if GetNumRaidMembers()>0 then
		for i=1,GetNumRaidMembers() do
			if UnitGUID("raid"..i) and UnitGUID("raid"..i)==id then
			psunitplayertrue=1
				i=41
			end
		end
	end

end
end