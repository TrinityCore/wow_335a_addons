-- Author: Shurshik
-- http://phoenix-wow.ru

function psficecrown()

pslocaleicecrownuim()
pslocaleicecrownbossm()

if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="zhTW" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" then
pslocaleicecrownui()
pslocaleicecrownboss()
end


	if whererepiccchat==nil then whererepiccchat={"raid", "sebe"} end
	icbossselected=1


psicboss={psicbosschoose, psicclordm, psiccdeathwhisper, psiccgunshipevent, psiccsaurfang, psiccfestergut, psiccrotface, psiccputricide, psiccbloodprince, psiccbloodqueenlana, psiccvalithria, psiccsindragosa, psicclichking}

psicdescription={psicchoosebosstxt, psicclordmtitle, psiccdeathtitle, psiccgunshiptitle, psiccsaurfangtitle, psicctitle5, psicctitle6, psicctitle7,psicctitle8,psicctitle9,psicctitle10,psicctitle11,psicctitle12}

psicmenu={{psicmoduleon.." \""..psicicecrownname.."\""}, {psicbossswitch, psiccanons11,psiccanons12,psiccanons13}, {psicbossswitch, psiccanons21,psiccanons22,psiccanons23,psiccanons24,psiccanons25,psiccanons26,psiccanons27,psiccanons28}, {psicbossswitch, psiccgunship51}, {psicbossswitch, psiccanons41,psiccanons42,psiccanons43,psiccanons44,psiccanons45,psiccanons46}, {psicbossswitch,psiccbossfail51,psiccbossfail52,psiccbossfail53,psiccbossfail54,psiccbossfail55,psiccbossfail56}, {psicbossswitch,psiccbossfail61,psiccbossfail62}, {psicbossswitch,psiccbossfail71,psiccbossfail72,psiccbossfail73,psiccbossfail74,psiccbossfail75,psiccbossfail76,psiccbossfail77},{psicbossswitch,psiccbossfail81,psiccbossfail82,psiccbossfail83,psiccbossfail84,psiccbossfail85},{psicbossswitch,psiccbossfail91,psiccbossfail92,psiccbossfail93},{psicbossswitch,psiccbossfail101,psiccbossfail102,psiccbossfail103,psiccbossfail104,psiccbossfail105},{psicbossswitch,psiccbossfail111,psiccbossfail112,psiccbossfail113,psiccbossfail114,psiccbossfail115,psiccbossfail116,psiccbossfail117,psiccbossfail118},{psicbossswitch,psiccbossfail121,psiccbossfail122,psiccbossfail124,psiccbossfail125,psiccbossfail126,psiccbossfail127,psiccbossfail128,psiccbossfail129}}


psicscetchik=0

psiccschet=0
psiccschet2=0
psiccschet3=0
psiccschet4=0
psiccschet5=0

psicclanacaststart=GetSpellInfo(72981)
psiccbandagehealer=GetSpellInfo(45544)


psiccdeletlocal()


--options by default
psicgalochkidef={{1}, {1,1,1,1}, {1,1,1,1,0,1,1,1,1}, {1,1}, {1,1,1,1,1,0,1}, {1,1,1,1,1,1,1},{1,1,1},{1,1,1,1,1,0,0,1},{1,0,1,1,1,1},{1,1,1,1},{1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1},{1,1,1,0,1,1,1,0,1}}
--chat by default
psicchatchosdef={{0}, {0,1,1,1}, {0,1,1,1,1,1,1,2,1}, {0,1}, {0,1,1,2,1,2,1}, {0,1,1,1,1,1,2},{0,1,1},{0,1,1,1,1,2,2,1},{0,2,1,1,1,1},{0,1,2,1},{0,1,1,1,1,1},{0,1,1,1,1,1,1,1,1},{0,1,1,2,2,1,1,2,1}}

psicdopmodchatdef={"raid", "raid", "raid"}
if psicsaurfgalk==nil then psicsaurfgalk={1,1,1,1,1,1} end

	if psiccsaurf==nil then psiccsaurf={"HealerA","HealerB","HealerC","HealerD","HealerA","","",""} end
	if(psicctekver == nil) then psicctekver = 0 end

--damage count variabiles
psiccdamagenames={{},{},{}}
psiccdamagevalues={{},{},{}}
psiccswitchnames={{},{},{}}
psiccswitchtime={{},{},{}}
psicceventsnames={{},{},{}}
psicccombatinfo={}
psiccindexboss={}
psiccindexclass={{},{},{}}
psiccprofinabom={{},{},{}}


psvalkidtable={}
psvalkidtabletim1={}
psvalkidtabletim2={}

psvalkidtable50={}


if psicclanaignorlist==nil then psicclanaignorlist={} end
if psicclanaignorlist2==nil then psicclanaignorlist2={} end
if psiccdmg3==nil then psiccdmg3=4 end
if psicclanaga==nil then psicclanaga=true end
if psicclanamarkref==nil then psicclanamarkref={} end
if psicclanamarkref2==nil then psicclanamarkref2={} end

if psiccprofgal1==nil then psiccprofgal1=false end
if psiccprofgal2==nil then psiccprofgal2=true end
if psiccprofgal22==nil then psiccprofgal22=true end
if psiccprofgal23==nil then psiccprofgal23=true end
if psiccprofgal3==nil then psiccprofgal3=true end
if psiccprofgal5==nil then psiccprofgal5=false end
if psiccprofignorlist1==nil then psiccprofignorlist1={} end
if psiccprofignorlist2==nil then psiccprofignorlist2={} end
if psiccprofchb==nil then psiccprofchb={1,0,0,0,0,0,0} end
if psiccproftimer==nil then psiccproftimer=8 end
psiccinst="0"

psficcsaurtxtset={psficcsaurtxtset1,psficcsaurtxtset2,psficcsaurtxtset3,psficcsaurtxtset4,psficcsaurtxtset5,psficcsaurtxtset6}
psficcsaurtxtset1=nil
psficcsaurtxtset2=nil
psficcsaurtxtset3=nil
psficcsaurtxtset4=nil
psficcsaurtxtset5=nil
psficcsaurtxtset6=nil

psiccnewveranoncet={psiccnewveranoncet1,psiccnewveranoncet2,psiccnewveranoncet3}
psiccnewveranoncet1=nil
psiccnewveranoncet2=nil
psiccnewveranoncet3=nil

if psicccombatsvqu==nil then psicccombatsvqu=20 end

if psicczonetimevar==nil then psicczonetimevar=0 end

if psiccsavedfails==nil then psiccsavedfails={{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}} end

if GetRealZoneText()==pszoneicecrowncit then
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
	this:RegisterEvent("PLAYER_REGEN_DISABLED")
	this:RegisterEvent("PLAYER_REGEN_ENABLED")
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	this:RegisterEvent("ADDON_LOADED")
	this:RegisterEvent("CHAT_MSG_MONSTER_YELL")


end



--онапдейт
function pscicconupdate(curtime)


--remove chat filter
if psiccchatfiltime and curtime>psiccchatfiltime+2 then
psiccchatfiltime=nil
ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", psiccChatFilter)
end


--announce delay for phasing
if psiccrepupdate and curtime>psiccrepupdate then
psiccrepupdate=nil
psiccwipereport()
end

--hunter die delay

if psicchunterdiedelay and curtime>psicchunterdiedelay then
psicchunterdiedelay=nil
--deathwisper
if psicchunterdiedelayboss==1 then
for tyu=1,#psicchunterdiedelaytable do
	for euu = 1,GetNumRaidMembers() do local name, _, _, _, _, _, _, _, isDead = GetRaidRosterInfo(euu)
		if (name==psicchunterdiedelaytable[tyu] and isDead) then
			psiccladydeathghostcheck(psicchunterdiedelayarg1, psicchunterdiedelaytable[tyu],8)
		end
	end
end

psicchunterdiedelayarg1=nil
end
--


psicchunterdiedelaytable=nil
psicchunterdiedelayboss=nil
end

--мигалка на профе

if psiccprofmigatmark1 and curtime>psiccprofmigatmark1 then

psiccprofmigatmark1=curtime+1
psiccprofmigatmark2=psiccprofmigatmark2+1
if psiccprofmigatmark2>10 then
psiccprofmigatmark2=nil
psiccprofmigatmark1=nil
psiccprofwispchuma22=nil
else
if IsRaidOfficer()==1 and psiccprofwispchuma22 and UnitExists(psiccprofwispchuma22) then
if psiccprofmigatmark2==1 or psiccprofmigatmark2==3 or psiccprofmigatmark2==5 or psiccprofmigatmark2==7 or psiccprofmigatmark2==9 then
SetRaidTarget(psiccprofwispchuma22, 7)
end
if psiccprofmigatmark2==2 or psiccprofmigatmark2==4 or psiccprofmigatmark2==6 or psiccprofmigatmark2==8 or psiccprofmigatmark2==10 then
SetRaidTarget(psiccprofwispchuma22, 8)
end
end


end
end


--putri
if pstimerclearsceneic and GetTime()>pstimerclearsceneic+18 then
		pstimerclearsceneic=nil
		if psiccm then
			psiccm:Remove()
		end
end

if psiccttime and pspatimplon and pstimerclearsceneic and GetTime()-pspatimplon>psiccttime-1 then
	psiccttime=nil
	if psiccm then
		psiccm:SetColor(1.0, 0, 0, 1)
	end
end


--valithria
if pstempvalitpull30 and curtime>pstempvalitpull30+35 then
pstempvalitpull30=nil
end

if pstempvalitpull30 and curtime>pstempvalitpull30+30 then
pscheckwipe1(4,8)
if pswipetrue then
	pstempvalitpull30=nil
else
	local bilbaf=0
	for i=1,GetNumRaidMembers() do
		if UnitName("raid"..i.."-target") and UnitName("raid"..i.."-target")==psiccvalithria then
			if UnitBuff("raid"..i.."-target", GetSpellInfo(43017)) then
				i=41
				bilbaf=1
				pstempvalitpull30=nil
			else
				bilbaf=2
			end
		end
	end

	if bilbaf==2 then
		local bilmag=0
		for ii=1,GetNumRaidMembers() do
			local name, _, _, _, _, claass = GetRaidRosterInfo(ii)
			if claass=="MAGE" and UnitIsDeadOrGhost(name)==nil and UnitAffectingCombat(name) then
				bilmag=1
			end
		end

		if bilmag==1 then
			if(psicgalochki[11][1]==1 and psicgalochki[11][5]==1)then
				local ampli=GetSpellInfo(43017)
				pszapuskanonsa(whererepiccchat[psicchatchoose[11][5]], "{rt8}"..psiccbossfail104t.." ".."\124cff71d5ff\124Hspell:43017\124h["..ampli.."]\124h\124r")
			end
			if pstempvalitpull302 and pstempvalitpull302<3 then
				pstempvalitpull302=pstempvalitpull302+1
				pstempvalitpull30=GetTime()
			else
				pstempvalitpull30=nil
			end
		else
			pstempvalitpull30=nil
		end
	end
end




end



--держу марки свои

if (psiccsauractiv and IsRaidOfficer()==1 and (isbattlev==1 or (isbattlev==0 and UnitIsDead("player")))) then


		if psicnextupdsaur==nil then psicnextupdsaur=curtime+2 end
	if curtime>psicnextupdsaur then
	psicnextupdsaur=curtime+1.5
	local i=1
		--держу марки
	if psicsaurfgalk and psicsaurfgalk[6]==1 then
		while i<8 do

		if psicsaufmmarkshas[i]=="" then else
			if UnitExists(psicsaufmmarkshas[i]) and (GetRaidTargetIndex(psicsaufmmarkshas[i])==nil or (GetRaidTargetIndex(psicsaufmmarkshas[i]) and GetRaidTargetIndex(psicsaufmmarkshas[i])~=i)) then
		SetRaidTarget(psicsaufmmarkshas[i], i)
			end
		end
		i=i+1
		end
	end


		--проверяю рагу босса

					if psiccmarkinsnospam==nil then
		local i=1
		while i<=GetNumRaidMembers() do
			if UnitName("raid"..i.."-target")==psiccsaurfang then
				--получает инфо о его раге, если больше 80 проверяем мертвых хилеров и репортим
				if UnitPower("raid"..i.."-target", 3)>79 and UnitPower("raid"..i.."-target", 3)<98 then
				psiccsaurfresheal()
				psiccmarkincomming()
				psiccmarkinsnospam=1
				end
			i=40
			end
		i=i+1
		end
					end

	end

end

if psicclanatimer and psicclanatimer>GetTime() and IsRaidOfficer()==1 and #psicclanamarkref>0 then
if psicnextupdlana==nil then psicnextupdlana=curtime+2 end

if curtime>psicnextupdlana then
psicnextupdlana=curtime+2

for i=1,#psicclanamarkref do
	if psicclanamarkref[i] then
		if UnitExists(psicclanamarkref[i]) and (GetRaidTargetIndex(psicclanamarkref[i])==nil or (GetRaidTargetIndex(psicclanamarkref[i]) and GetRaidTargetIndex(psicclanamarkref[i])~=psicclanamarkref2[i])) then
		SetRaidTarget(psicclanamarkref[i], psicclanamarkref2[i])
		end
	end

end



end
end


--saurfadds / lk check targets
if (psiccvalk2 or psiccvalk1) and psiccozzetimebegin and psvalheroicswitch==nil then

	if psiccnexttargetlook and curtime>psiccnexttargetlook then

psiccnexttargetlook=psiccnexttargetlook+0.1

if psiccswitchnames[1][#psiccswitchnames[1]] and psicclkvalkname then

for i=1,#psiccswitchnames[1][#psiccswitchnames[1]] do
	if psiccswitchtime[1][#psiccswitchnames[1]][i]=="--" then

			if UnitName(psiccswitchnames[1][#psiccswitchnames[1]][i].."-target")==psicclkvalkname then
				--считаем время
				local psswichspeed=math.ceil((GetTime()-psiccozzetimebegin)*10)/10
				psswichspeed=math.ceil((psswichspeed)*10)/10
				psiccswitchtime[1][#psiccswitchnames[1]][i]=psswichspeed
			end
	end
end

end

	end

if psiccvalk2 then
if curtime>psiccozzetimebegin+35 then
psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psiccsaurfaddscount=nil
psiccschet4=0

if(psicgalochki[5][1]==1 and psicgalochki[5][6]==1 and GetRealZoneText()==pszoneicecrowncit)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[5][6]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end

end
end


if psiccvalk1 then
if curtime>psiccozzetimebegin+45 then
psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psicclkvalkcount=nil
psiccschet=0
table.wipe(psvalkidtable)
table.wipe(psvalkidtable50)

if(psicgalochki[13][1]==1 and psicgalochki[13][4]==1 and GetRealZoneText()==pszoneicecrowncit)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[13][4]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end

end
end


end --saurf/lk adds

--delete valkyr after 2 sec not target
if #psvalkidtabletim2>0 then
	if psdelaytimcheck==nil then
		psdelaytimcheck=curtime+0.3
	end
	if curtime>psdelaytimcheck then
		psdelaytimcheck=curtime+0.3
		for ttr=1,#psvalkidtabletim2 do
			if psvalkidtabletim2[ttr] and curtime>psvalkidtabletim2[ttr]+2 then
				if #psvalkidtable>0 then
					for ttf=1,#psvalkidtable do
						if psvalkidtable[ttf] and psvalkidtable[ttf]==psvalkidtabletim1[ttr] then
							if #psvalkidtable50>0 then
								local rrrrr=0
								for tvb=1,#psvalkidtable50 do
									if psvalkidtable50[tvb]==psvalkidtable[ttf] then
										rrrrr=1
									end
								end
								if rrrrr==0 then
									table.insert(psvalkidtable50,psvalkidtable[ttf])
								end									
							else
								table.insert(psvalkidtable50,psvalkidtable[ttf])
							end

							table.remove(psvalkidtable,ttf)
							ttf=100
						end
					end
				end
			table.remove(psvalkidtabletim1,ttr)
			table.remove(psvalkidtabletim2,ttr)
if #psvalkidtable==0 then

psiccschet=0
table.wipe(psvalkidtable)
table.wipe(psvalkidtable50)
table.wipe(psvalkidtabletim1)
table.wipe(psvalkidtabletim2)

local psiccostalos=math.ceil(GetTime()-psiccozzetimebegin)

if GetRaidDifficulty()==1 or GetRaidDifficulty()==3 then
psicceventsnames[1][#psicceventsnames[1]]=psicceventsnames[1][#psicceventsnames[1]]..", "..psiccozzen4.." "..psiccostalos.." "..pssec
else
psicceventsnames[1][#psicceventsnames[1]]=psicceventsnames[1][#psicceventsnames[1]]..", "..psiccozzen4.." "..psiccostalos.." "..pssec
end

psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psicclkvalkcount=nil

if(psicgalochki[13][1]==1 and psicgalochki[13][4]==1 and GetRealZoneText()==pszoneicecrowncit)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[13][4]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end

--ыыырепорт

if(psicgalochki[13][1]==1 and psicgalochki[13][9]==1 and GetRealZoneText()==pszoneicecrowncit)then
strochkadamageout="{rt1}"..psiccbossfail129t.." #"..psiccschet5.." "..psiccbossfail129t2
reportfromtridamagetables(whererepiccchat[psicchatchoose[13][9]],10)
end

table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)




end


			end
		end
	end
end



if psiccvalktimertarg then
	if pstempdelayval==nil then pstempdelayval=curtime+0.5
	end
	if pstempdelayval and curtime>pstempdelayval then
		pstempdelayval=curtime+0.5

			for i=1, GetNumRaidMembers() do
				if UnitInVehicle("raid"..i) then
					local bil=0
					if #psiccvalktimertargtabl>0 then
						for ii=1,#psiccvalktimertargtabl do
							if psiccvalktimertargtabl[ii]==UnitName("raid"..i) then
								bil=1
							end
						end
					end
					if bil==0 then

local imya=UnitName("raid"..i)

						table.insert(psiccvalktimertargtabl,imya)

						if psiccinst and psiccinst=="25, "..psiccheroic and #psiccvalktimertargtabl==3 then
							psiccvalktimertarg=curtime-9
						end

						if psiccinst and psiccinst=="10, "..psiccheroic and #psiccvalktimertargtabl==1 then
							psiccvalktimertarg=curtime-9
						end

					end
				end
			end


	end
end

if psiccvalktimertarg and curtime>psiccvalktimertarg+8 then
psiccvalktimertarg=nil
pstempdelayval=nil

	if psiccvalktimertargtabl and #psiccvalktimertargtabl>0 then
		local texx=""
		for i=1,#psiccvalktimertargtabl do
			if string.len(texx)>1 then
				texx=texx.." "
			end
			texx=texx..psiccvalktimertargtabl[i]
		end
		if GetRaidDifficulty()==1 or GetRaidDifficulty()==3 then
		psicceventsnames[1][#psicceventsnames[1]]=psicclkvalkir.." #"..psiccschet5.." ("..texx..")"
		else
		psicceventsnames[1][#psicceventsnames[1]]=psicclkvalkir3.." #"..psiccschet5.." ("..texx..")"
		end
	end
table.wipe(psiccvalktimertargtabl)
end
			



--check hp valkyr heroic
if #psvalkidtable>0 then
	if psdelayhpcheck==nil then
		psdelayhpcheck=curtime+0.3
	end
	if curtime>psdelayhpcheck then
		psdelayhpcheck=curtime+0.3
		for ttg=1,GetNumRaidMembers() do
			if UnitName("raid"..ttg.."-target")==psicclkvalkname then
				local percenthp=UnitHealth("raid"..ttg.."-target")*100/UnitHealthMax("raid"..ttg.."-target")
				if percenthp<=51 then
					if #psvalkidtable>0 then
						for ppl=1,#psvalkidtable do
							if psvalkidtable[ppl] and psvalkidtable[ppl]==UnitGUID("raid"..ttg.."-target") then

								if #psvalkidtable50>0 then
									local rrrrr=0
									for tvb=1,#psvalkidtable50 do
										if psvalkidtable50[tvb]==psvalkidtable[ppl] then
											rrrrr=1
										end
									end
									if rrrrr==0 then
										table.insert(psvalkidtable50,psvalkidtable[ppl])
									end									
								else
									table.insert(psvalkidtable50,psvalkidtable[ppl])
								end


								table.remove(psvalkidtable,ppl)
							end
						end
					end
					if #psvalkidtabletim1>0 then
						for eed=1,#psvalkidtabletim1 do
							if psvalkidtabletim1[eed] and psvalkidtabletim1[eed]==UnitGUID("raid"..ttg.."-target") then
								table.remove(psvalkidtabletim1,eed)
								table.remove(psvalkidtabletim2,eed)
							end
						end
					end
				end
				--тут вставить таймер для меньше 61%
				if percenthp>51 and percenthp<61 then
					if #psvalkidtable>0 then
						for ppl=1,#psvalkidtable do
							if psvalkidtable[ppl] and psvalkidtable[ppl]==UnitGUID("raid"..ttg.."-target") then
								if #psvalkidtabletim1>0 then
									local byyl=0
									for rrt=1,#psvalkidtabletim1 do
										if psvalkidtabletim1[rrt]==UnitGUID("raid"..ttg.."-target") then
											psvalkidtabletim2[rrt]=curtime
											byyl=1
										end
									end
									if byyl==0 then
										table.insert(psvalkidtabletim1,UnitGUID("raid"..ttg.."-target"))
										table.insert(psvalkidtabletim2,curtime)
									end
								else
									table.insert(psvalkidtabletim1,UnitGUID("raid"..ttg.."-target"))
									table.insert(psvalkidtabletim2,curtime)
								end
							end
						end
					end
				end

			end
		end
		if #psvalkidtable==0 then
psiccschet=0
table.wipe(psvalkidtable)
table.wipe(psvalkidtable50)
table.wipe(psvalkidtabletim1)
table.wipe(psvalkidtabletim2)

local psiccostalos=math.ceil(GetTime()-psiccozzetimebegin)

if GetRaidDifficulty()==1 or GetRaidDifficulty()==3 then
psicceventsnames[1][#psicceventsnames[1]]=psicceventsnames[1][#psicceventsnames[1]]..", "..psiccozzen4.." "..psiccostalos.." "..pssec
else
psicceventsnames[1][#psicceventsnames[1]]=psicceventsnames[1][#psicceventsnames[1]]..", "..psiccozzen4.." "..psiccostalos.." "..pssec
end

psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psicclkvalkcount=nil


if(psicgalochki[13][1]==1 and psicgalochki[13][4]==1 and GetRealZoneText()==pszoneicecrowncit)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[13][4]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end
--ыыырепорт
if(psicgalochki[13][1]==1 and psicgalochki[13][9]==1 and GetRealZoneText()==pszoneicecrowncit)then
strochkadamageout="{rt1}"..psiccbossfail129t.." #"..psiccschet5.." "..psiccbossfail129t2
reportfromtridamagetables(whererepiccchat[psicchatchoose[13][9]],10)
end

table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)
		end
	end
end


--lk check targets ONLY heroic mode
if psiccvalk1 and psiccozzetimebegin and psvalheroicswitch and #psvalkidtable>0 then

	if psiccnexttargetlook and curtime>psiccnexttargetlook then

psiccnexttargetlook=psiccnexttargetlook+0.1

if psiccswitchnames[1][#psiccswitchnames[1]] and psicclkvalkname then

for i=1,#psiccswitchnames[1][#psiccswitchnames[1]] do
	if psiccswitchtime[1][#psiccswitchnames[1]][i]=="--" then

			if UnitName(psiccswitchnames[1][#psiccswitchnames[1]][i].."-target")==psicclkvalkname then
				--проверяем норм ли ид
				local iidd=0
				for op=1,#psvalkidtable do
					if psvalkidtable[op]==UnitGUID(psiccswitchnames[1][#psiccswitchnames[1]][i].."-target") then
						iidd=1
					end
				end
				--считаем время
				if iidd==1 then
				local psswichspeed=math.ceil((GetTime()-psiccozzetimebegin)*10)/10
				psswichspeed=math.ceil((psswichspeed)*10)/10
				psiccswitchtime[1][#psiccswitchnames[1]][i]=psswichspeed
				end
			end
	end
end

end

	end


if psiccvalk1 then
if curtime>psiccozzetimebegin+45 then
psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psicclkvalkcount=nil
psiccschet=0
table.wipe(psvalkidtable)
table.wipe(psvalkidtable50)
table.wipe(psvalkidtabletim1)
table.wipe(psvalkidtabletim2)

if(psicgalochki[13][1]==1 and psicgalochki[13][4]==1 and GetRealZoneText()==pszoneicecrowncit)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[13][4]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end
--ыыырепорт
if(psicgalochki[13][1]==1 and psicgalochki[13][9]==1 and GetRealZoneText()==pszoneicecrowncit)then
strochkadamageout="{rt1}"..psiccbossfail129t.." #"..psiccschet5.." "..psiccbossfail129t2
reportfromtridamagetables(whererepiccchat[psicchatchoose[13][9]],10)
end

table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)

end
end


end --lk heroic check



--festergut
if psiccfastertimer then
if curtime>psiccfastertimer then
psiccfestergutaoealarm()
end
end

--putricide chuma

--with debuff
if psiccprofwispchuma1 and psprofbaaaaddebuf and curtime<psprofbaaaaddebuf+5 and curtime>psprofbaaaaddebuf+2 and psiccprofwispchuma2 and psiccfirstmarkprofwisp then
if psiccchatfiltime==nil then
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", psiccChatFilter)
psiccchatfiltime=GetTime()
else
psiccchatfiltime=GetTime()
end
local cchat="raid"
if IsRaidOfficer()==1 then
cchat="raid_warning"
end
psiccprofwispchuma22=psiccprofwispchuma2
psiccprofmigatmark1=GetTime()
psiccprofmigatmark2=0
local plagueleft=""
local psdeb1 = GetSpellInfo(70911)

if UnitDebuff(psiccprofwispchuma2, psdeb1) then
local _, _, _, _, _, _, expirationTime = UnitDebuff(psiccprofwispchuma2, psdeb1)
plagueleft="("..psiccleft..": "..(math.ceil((expirationTime-GetTime())*10)/10)..") "
end

local psdeb2 = GetSpellInfo(70953)

local chumeonme="?"
chumeonme=(math.ceil((curtime-psprofbaaaaddebuf)*10)/10)

--тут все анонсы
			if psiccprofchumanorm==nil then

if psiccprofgal2 then
		SendChatMessage(psiccprofchumt1.." "..chumeonme.." "..pssec.." + "..psdeb2.." "..psiccprofchumt2.." ("..psiccfirstmarkprofwisp..")", "WHISPER", nil, psiccprofwispchuma2)

		if UnitName("player")~=psiccprofwispchuma2 then
		print (psiccmsgsentto.." "..psiccprofwispchuma2..".")
		end
end
if psiccprofgal22 then

		SendChatMessage("{rt2} "..psiccrepchumchat1..psiccprofwispchuma2.." - "..chumeonme.." "..pssec.." "..plagueleft.."+ "..psdeb2.." "..psiccprofchumt2.." ("..psiccfirstmarkprofwisp..")", cchat)
end

if psiccprofgal23 then
		psdelayprofmod=GetTime()+30

		SendChatMessage(psiccprofmodopt23go.." "..plagueleft, "WHISPER", nil, psiccfirstmarkprofwisp)
		if UnitName("player")~=psiccfirstmarkprofwisp then
		print (psiccmsgsentto.." "..psiccfirstmarkprofwisp..".")
		end
end
			end



psiccprofwispchuma1=nil
psprofbaaaaddebuf=nil
psiccprofwispchuma2=nil

end



--no debuff
if psiccprofwispchuma1 and curtime>psiccprofwispchuma1 then
psiccprofwispchuma1=nil
local plagueleft=""

local psdeb1 = GetSpellInfo(70911)

if UnitDebuff(psiccprofwispchuma2, psdeb1) then
local name, _, _, _, _, _, expirationTime = UnitDebuff(psiccprofwispchuma2, psdeb1)
local cchat="raid"
if IsRaidOfficer()==1 then
cchat="raid_warning"
end
	if expirationTime and expirationTime-GetTime()>3 then

if psiccprofgal2 or psiccprofgal22 or psiccprofgal23 then
if psiccchatfiltime==nil then
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", psiccChatFilter)
psiccchatfiltime=GetTime()
else
psiccchatfiltime=GetTime()
end
psiccprofwispchuma22=psiccprofwispchuma2
psiccprofmigatmark1=GetTime()
psiccprofmigatmark2=0

plagueleft="("..psiccleft..": "..(math.ceil((expirationTime-GetTime())*10)/10)..") "

end

				if psiccprofchumanorm==nil then

if psiccprofgal2 then
			if psiccfirstmarkprofwisp then
		SendChatMessage(psiccprofchumt1.." "..psiccproftimer.." "..pssec.." "..psiccprofchumt2.." ("..psiccfirstmarkprofwisp..")", "WHISPER", nil, psiccprofwispchuma2)
			else
		SendChatMessage(psiccprofchumt1.." "..psiccproftimer.." "..pssec.." "..psiccprofchumt2, "WHISPER", nil, psiccprofwispchuma2)
			end
		if UnitName("player")~=psiccprofwispchuma2 then
		print (psiccmsgsentto.." "..psiccprofwispchuma2..".")
		end
end
if psiccprofgal22 then

	if psiccprofgal23 then
		if psiccfirstmarkprofwisp then
		SendChatMessage("{rt2} "..psiccrepchumchat1..psiccprofwispchuma2.." - "..psiccproftimer.." "..pssec.." "..plagueleft..psiccprofchumt2.." ("..psiccfirstmarkprofwisp..")", cchat)
		else
		SendChatMessage("{rt8} {rt2} {rt8} "..psiccrepchumchat1..psiccprofwispchuma2.." - "..psiccproftimer.." "..pssec.." "..plagueleft..psiccprofchumt2.." ("..string.upper(psiccunknown)..")", cchat)
		end
	else
		SendChatMessage("{rt2} "..psiccrepchumchat1..psiccprofwispchuma2.." - "..psiccproftimer.." "..pssec.." "..plagueleft..psiccprofchumt2, cchat)
	end
end

if psiccprofgal23 then
	if psiccfirstmarkprofwisp then
		psdelayprofmod=GetTime()+30

		SendChatMessage(psiccprofmodopt23go.." "..plagueleft, "WHISPER", nil, psiccfirstmarkprofwisp)
		if UnitName("player")~=psiccfirstmarkprofwisp then
		print (psiccmsgsentto.." "..psiccfirstmarkprofwisp..".")
		end
	end
end
				end

	end
end


psiccprofwispchuma2=nil
end


--putricide targets check
if psiccquantooze and #psiccquantooze>0 then

	if psiccnexttargetlook and curtime>psiccnexttargetlook then

psiccnexttargetlook=psiccnexttargetlook+0.1

local psminus=0
if psiccquantooze and #psiccquantooze==2 then
psminus=1
end

if psiccswitchnames[1][#psiccswitchnames[1]-psminus] then

for i=1,#psiccswitchnames[1][#psiccswitchnames[1]-psminus] do
	if psiccswitchtime[1][#psiccswitchnames[1]-psminus][i]=="--" then

			if UnitName(psiccswitchnames[1][#psiccswitchnames[1]-psminus][i].."-target")==psiccquantooze[1] then
				--считаем время
				local psswichspeed=math.ceil((GetTime()-psiccozzetimebegin)*10)/10
				psswichspeed=math.ceil((psswichspeed)*10)/10
				psiccswitchtime[1][#psiccswitchnames[1]-psminus][i]=psswichspeed
			end
	end
end

end



end
end --putricide


--putricide targets check 2 oozze
if psiccquantooze and #psiccquantooze==2 then

	if psiccnexttargetlook222 and curtime>psiccnexttargetlook222 then

psiccnexttargetlook222=psiccnexttargetlook222+0.1

local psminus=0
--if psiccquantooze and #psiccquantooze==2 then
--psminus=1
--end

if psiccswitchnames[1][#psiccswitchnames[1]-psminus] then

for i=1,#psiccswitchnames[1][#psiccswitchnames[1]-psminus] do
	if psiccswitchtime[1][#psiccswitchnames[1]-psminus][i]=="--" then

			if UnitName(psiccswitchnames[1][#psiccswitchnames[1]-psminus][i].."-target")==psiccquantooze[2] then
				--считаем время
				local psswichspeed=math.ceil((GetTime()-psiccozzetimebegin)*10)/10
				psswichspeed=math.ceil((psswichspeed)*10)/10
				psiccswitchtime[1][#psiccswitchnames[1]-psminus][i]=psswichspeed
			end
	end
end

end



end
end --putricide


--council targets check
if psicccouncildeb2 and psiccozzetimebegin then

	if psiccnexttargetlook and curtime>psiccnexttargetlook then

psiccnexttargetlook=psiccnexttargetlook+0.1

if psiccswitchnames[1][#psiccswitchnames[1]] then

for i=1,#psiccswitchnames[1][#psiccswitchnames[1]] do
	if psiccswitchtime[1][#psiccswitchnames[1]][i]=="--" then

			if UnitName(psiccswitchnames[1][#psiccswitchnames[1]][i].."-target")==psicccouncildeb2 then
				--считаем время
				local psswichspeed=math.ceil((GetTime()-psiccozzetimebegin)*10)/10
				psswichspeed=math.ceil((psswichspeed)*10)/10
				psiccswitchtime[1][#psiccswitchnames[1]][i]=psswichspeed
			end
	end
end

end

	end

if curtime>psiccozzetimebegin+15 then
psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()

if(psicgalochki[9][1]==1 and psicgalochki[9][2]==1 and GetRealZoneText()==pszoneicecrowncit)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[9][2]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end

end


end --council


--the lk  defile target
if psicclichupdate and curtime>psicclichupdate+0.2 and curtime<psicclichupdate+1.5 then
if psiccotloj==nil then psiccotloj=GetTime() end
	if curtime>=psiccotloj then
		psiccotloj=psiccotloj+0.15

		local i=1
		while i<=GetNumRaidMembers() do
			if UnitName("raid"..i.."-target")==psicclichking then
				if UnitName("raid"..i.."-target-target") then
				psicclichdelfireon=UnitName("raid"..i.."-target-target")
				psicclichupdate=nil
				i=40
				psiccotloj=nil
				end
			end
		i=i+1
		end
	end
if psicclichdelfireon==nil then
psicclichdelfireon=psiccunknown
end
end --lk




--the lich king defile
if pslichdefile and curtime>pslichdefile then
pslichdefile=nil



if #vezaxname2>0 then

		if psiccschet2>3 then

if(psicgalochki[13][1]==1 and psicgalochki[13][3]==1 and GetRealZoneText()==pszoneicecrowncit)then


	if psiccschet2<11 or psiccdefsecs>5 then
strochkavezcrash="{rt8} "..psiccfailtxt122.." #"..psiccschet3.." ("..psicclichdelfireon..") - "..psiccschet2..": "
reportafterboitwotab(whererepiccchat[psicchatchoose[13][3]], nil, vezaxname2, vezaxcrash2, 1, 10)
	elseif psiccdefsecs<6 then
strochkavezcrash="{rt8} "..psiccfailtxt122.." #"..psiccschet3.." ("..psicclichdelfireon..") - "..psiccschet2..", "..psiccfirst.." "..psiccdefsecs.." "..psiccticks..": "
reportafterboitwotab(whererepiccchat[psicchatchoose[13][3]], nil, vezaxname2, vezaxcrash2, 1, 10)
	end

end

if psicgalochki[13][1]==1 and GetRealZoneText()==pszoneicecrowncit and ((psicgalochki[13][3]==1 and whererepiccchat[psicchatchoose[13][3]]~=whererepiccchat[psicchatchoose[13][8]] and psicgalochki[13][8]==1) or (psicgalochki[13][3]==0 and psicgalochki[13][8]==1)) then

	if psiccschet2<11 or psiccdefsecs>5 then
strochkavezcrash="{rt8} "..psiccfailtxt122.." #"..psiccschet3.." ("..psicclichdelfireon..") - "..psiccschet2..": "
reportafterboitwotab(whererepiccchat[psicchatchoose[13][8]], nil, vezaxname2, vezaxcrash2, 1, 10)
	elseif psiccdefsecs<6 then
strochkavezcrash="{rt8} "..psiccfailtxt122.." #"..psiccschet3.." ("..psicclichdelfireon..") - "..psiccschet2..", "..psiccfirst.." "..psiccdefsecs.." "..psiccticks..": "
reportafterboitwotab(whererepiccchat[psicchatchoose[13][8]], nil, vezaxname2, vezaxcrash2, 1, 10)
	end

end

		else
if(psicgalochki[13][1]==1 and psicgalochki[13][8]==1 and GetRealZoneText()==pszoneicecrowncit)then
strochkavezcrash="{rt7} "..psiccfailtxt122.." #"..psiccschet3.." ("..psicclichdelfireon..") - "..psiccschet2..": "
reportafterboitwotab(whererepiccchat[psicchatchoose[13][8]], nil, vezaxname2, vezaxcrash2, 1, 10)
end
		end


else
if(psicgalochki[13][1]==1 and psicgalochki[13][8]==1 and GetRealZoneText()==pszoneicecrowncit)then
pszapuskanonsa(whererepiccchat[psicchatchoose[13][8]], "{rt7} "..psiccfailtxt122.." #"..psiccschet3.." ("..psicclichdelfireon.."): "..psiccfailtxt1222..".")
end
end

table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
psiccschet2=0
psiccidofdefile=nil
psiccdefsecs=3
psiccdefsecsarg=nil

end

--syndragosa tombs
if psiccsyndratime and curtime>psiccsyndratime then
psiccsyndratime=nil
if #psiccsindmarks2>0 then
	table.sort(psiccsindmarks)
	table.sort(psiccsindmarks2)
	local psstringa=psiccfailtxt11412
	if #psiccsindmarks>1 then psstringa=psiccfailtxt1141
	end

	for i=1,#psiccsindmarks do
		psstringa=psstringa..psiccsindmarks[i]
		if i==#psiccsindmarks then
			psstringa=psstringa..". "
		else
			psstringa=psstringa..", "
		end
	end
	psstringa=psstringa..psiccfailtxt1142

	for i=1,#psiccsindmarks2 do
		psstringa=psstringa..psiccsindmarks2[i]
		if i==#psiccsindmarks2 then
			psstringa=psstringa.."."
		else
			psstringa=psstringa..", "
		end
	end

if(psicgalochki[12][1]==1 and psicgalochki[12][5]==1)then
pszapuskanonsa(whererepiccchat[psicchatchoose[12][5]], "{rt8} "..psstringa)
end

end
psiccsindmarks=nil
psiccsindmarks2=nil
end


end


function psficecrownonevent()


if event == "PLAYER_REGEN_DISABLED" then
if psbilresnut==1 then
else
--обнулять все данные при начале боя тут:

psvalkidtable={}
psvalkidtable50={}
psvalkidtabletim1={}
psvalkidtabletim2={}
psvalheroicswitch=nil
psicscetchik=0
psiccschet=0
psiccschet2=0
psiccschet3=0
psiccschet4=0
psiccschet5=0
psiccbossblocked=nil
psiccraiderinmc=nil
psiccnickinmc=nil
psiccfastertimer=nil
psiccsharon=nil
psicccouncildeb=nil
psicccouncildeb2=nil
psiccnexttargetlook=nil
psiccozzetimebegin=nil
psiccvalk1=nil
psiccvalk2=nil
psicclkvalkcount=nil
psiccsaurfaddscount=nil
psiccprofchumapull1=nil
psiccprofchumanorm=nil
psiccinst="0"
local _, _, pppl, _, _, dif = GetInstanceInfo()
if pppl and (pppl==1 or pppl==3) then
psiccinst="10"
end
if pppl and (pppl==2 or pppl==4) then
psiccinst="25"
end
if dif and dif==1 then
psiccinst=psiccinst..", "..psiccheroic
end
if psiccfestertrig and GetTime()>psiccfestertrig+25 then
psiccfestertrig=nil
end
if (psiccprofnodelete==nil or (psiccprofnodelete and GetTime()>psiccprofnodelete+15)) then
psiccprofnodelete=nil
psiccprofcountdamage1=nil
psiccprofcountdamage2=nil
psiccprofcountdamage3=nil
end

--валькирии репорт
if psvalkidtable50 and #psvalkidtable50>0 then
if(psicgalochki[13][1]==1 and psicgalochki[13][9]==1)then
strochkadamageout="{rt1}"..pscoltwinshield5
reportfromtridamagetables(whererepiccchat[psicchatchoose[13][9]],10)
end

table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)
table.wipe(psvalkidtable50)
end
--


--модуль саурфа
	if psiccsauractiv then
table.wipe(psicsaurfhealstattbl)
table.wipe(psicsaufmmarkshas)
psicsaufmmarkshas={"","","","","","","",""}
psmarksoff("raid")
psiccmarkinsnospam=nil
for i=1,8 do
if psiccsaurf[i]=="" then
table.insert(psicsaurfhealstattbl,0)
else
table.insert(psicsaurfhealstattbl,1)
end
end

--проверка вылетевших до боя за 15 сек и обн таблицы
--psiccbeforecombatleave
if psiccbeforecombatleave and #psiccbeforecombatleave>0 then
	for i=1,#psiccbeforecombatleave do
		if GetTime()-tonumber(string.sub(psiccbeforecombatleave[i], 1, string.find(psiccbeforecombatleave[i], "+")-1))<40 then
			for j=1,8 do
				if psiccsaurf[j]==string.sub(psiccbeforecombatleave[i], string.find(psiccbeforecombatleave[i], "+")+1) then
					if psicsaurfhealstattbl[j]==1 then
						psicsaurfhealstattbl[j]=6
					end
				end
			end
		end
	end
psiccbeforecombatleave=nil
end




	end

end
end


if event == "PLAYER_REGEN_ENABLED" then

	if(wasornoladydeath)then iccladydeathboyinterr=1 end
	if(wasornosaurfang)then iccsaurfangboyinterr=1 end
	if(wasornolordm)then icclordmboyinterr=1 end
	if(wasornogunship)then iccgunshipboyinterr=1 end
	if(wasornorotface)then iccrotfaceboyinterr=1 end
	if(wasornofestergut)then iccfestergutboyinterr=1 end
	if(wasornoprof)then iccprofboyinterr=1 end
	if(wasornosovet)then iccsovetboyinterr=1 end
	if(wasornolana)then icclanaboyinterr=1 end
	if(wasornovalytria)then iccvalytriaboyinterr=1 end
	if(wasornosindra)then iccsindraboyinterr=1 end
	if(wasornolk)then icclkboyinterr=1 end


end

if event == "CHAT_MSG_MONSTER_YELL" then
--prof pull
if ((arg1==psiccputricidepully or ((GetLocale() == "deDE" or GetLocale() == "frFR") and arg1 and string.find(string.lower(arg1),string.lower(psiccputricidepully)))) and arg2==psiccputricide) then
proficcyellwasseen=GetTime()
psicclanaisbatle2=1
psiccproftimeaply1=nil
psiccproftimeaply2=nil
psiccproftimeaply3=nil

if psicgalochki[8][1]==1 then

psiccprofcountdamage1=1
psiccprofcountdamage2=1
psiccprofnodelete=GetTime()
psabomtrack=1

psiccupdatetable(psiccinfo71,1)

psciccrezetdmgshow()

end
end

--valitria pull
if arg1==psiccvalitriapull or (GetLocale() == "frFR" and arg1 and string.find(string.lower(arg1),string.lower(psiccvalitriapull))) then
wasornovalytria=1
psiccvalitrifailspirit1={}
psiccvalitrifailspirit2={}
psiccvalpriest=1
pstempvalitpull30=GetTime()
pstempvalitpull302=0
end



end


if event == "CHAT_MSG_CHANNEL_LEAVE" then
for i=1,8 do
if psiccsaurf[i]==arg2 then
if psicsaufmmarkshas[i]=="" then
psicsaurfhealstattbl[i]=6
else
	if psicsaurfhealstattbl[i]==3 then
if psicsaurfgalk[5]==1 then
SendChatMessage(psiccsaurf[i].." "..psiccsaurdisc1.." >> {rt"..i.."}"..psicsaufmmarkshas[i].." <<", "raid_warning")
end
psicsaurfhealstattbl[i]=6
	end
end
end
end

--если я не в бою то запись в спец таблицу
if UnitIsDead("player")==nil and isbattlev==0 then
	if psiccbeforecombatleave==nil then psiccbeforecombatleave={} end
local bililinet=0
if #psiccbeforecombatleave>0 then
	for i=1,#psiccbeforecombatleave do
		if string.sub(psiccbeforecombatleave[i], string.find(psiccbeforecombatleave[i], "+")+1)==arg2 then
			bililinet=1
		end
	end
if bililinet==0 then
table.insert(psiccbeforecombatleave, GetTime().."+"..arg2)
end

else
table.insert(psiccbeforecombatleave, GetTime().."+"..arg2)
end
end


end


if event == "CHAT_MSG_CHANNEL_JOIN" then
for i=1,8 do
if psiccsaurf[i]==arg2 and psicsaurfhealstattbl[i]==6 then
	if psicsaufmmarkshas[i]=="" then
psicsaurfhealstattbl[i]=2
	else
psicsaurfhealstattbl[i]=3
	end
end
end

--если не в бою и вернулся хил удалить
if UnitIsDead("player")==nil and isbattlev==0 and psiccbeforecombatleave then
	local i=1
	while i<=#psiccbeforecombatleave do
		if string.sub(psiccbeforecombatleave[i], string.find(psiccbeforecombatleave[i], "+")+1)==arg2 then
			table.remove(psiccbeforecombatleave, i)
			i=90
		end
	i=i+1
	end
end

end

if event == "ZONE_CHANGED_NEW_AREA" then

psicclanaisbatle=nil
psicclanaisbatle2=nil

if (icclordmboyinterr) then
psficclorlmafterf()
psficclordmresetall()
end

if (iccladydeathboyinterr) then
psficcladydeathafterf()
psficcladydeathresetall()
end

if (iccsaurfangboyinterr) then
psficcsaurfangafterf()
psficcsaurfangresetall()
end

if (iccgunshipboyinterr) then
psficcgunshipafterf()
psficcgunshipresetall()
end

if (iccrotfaceboyinterr) then
psficcrotfaceafterf()
psficcrotfaceresetall()
end

if (iccfestergutboyinterr) then
psficcfestergutafterf()
psficcfestergutresetall()
end

if (iccprofboyinterr) then
psficcprofafterf()
psficcprofresetall()
end

if (iccsovetboyinterr) then
psficcsovetafterf()
psficcsovetresetall()
end

if (icclanaboyinterr) then
psficclanaafterf()
psficclanaresetall()
end

if (iccvalytriaboyinterr) then
psficcvalytriaafterf()
psficcvalytriaresetall()
end

if (iccsindraboyinterr) then
psficcsindraafterf()
psficcsindraresetall()
end

if (icclkboyinterr) then
psficclkafterf()
psficclkresetall()
end

if GetRealZoneText()==pszoneicecrowncit then
PhoenixStyleMod_Icecrown:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
else
PhoenixStyleMod_Icecrown:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

end



if event == "ADDON_LOADED" then

if arg1=="PhoenixStyleMod_Icecrown" then


if psicobnovperemen==nil then
psicobnovperemen=1

if psicgalochki==nil then psicgalochki={} end

for i,srtabl in ipairs(psicgalochkidef) do

	if psicgalochki[i]==nil then psicgalochki[i]=psicgalochkidef[i]
	end

	for j,stabl2 in ipairs(psicgalochkidef[i]) do
	if psicgalochki[i][j]==nil then
	psicgalochki[i][j]=psicgalochkidef[i][j]
	end
	end
end


if psicchatchoose==nil then psicchatchoose={} end

for ii,srtabl in ipairs(psicchatchosdef) do

	if psicchatchoose[ii]==nil then psicchatchoose[ii]=psicchatchosdef[ii]
	end

	for jj,stabl2 in ipairs(psicchatchosdef[ii]) do
	if psicchatchoose[ii][jj]==nil or psicchatchosdef[ii][jj]==0 then
	psicchatchoose[ii][jj]=psicchatchosdef[ii][jj]
	end

	if psicchatchoose[ii][jj]==0 and psicchatchosdef[ii][jj]~=0 then
	psicchatchoose[ii][jj]=psicchatchosdef[ii][jj]
	end
	end
end


for u,strabl in ipairs(psicdopmodchatdef) do

	if psicdopmodchat==nil then psicdopmodchat={} end

	if psicdopmodchat[u]==nil then psicdopmodchat[u]=psicdopmodchatdef[u]
	end
end
psicdopmodchatdef=nil

if psicsaurfgalk and psicsaurfgalk[6]==nil then psicsaurfgalk[6]=1 end

end



--NEW announce
	if 10-psicctekver>0 then
--ыытемпыытест
if psicgalochki[12][7] and psicgalochki[12][7]==1 then
psicgalochki[12][8]=1
end


		if psicctekver>0 then
print ("|cff99ffffPhoenixStyle|r - "..pscolnewveranonce1)
		end
local psvercoll=(10-psicctekver)
if psvercoll>3 then psvercoll=3 end

while psvercoll>0 do
		if psicctekver>0 then
out ("|cff99ffffPhoenixStyle|r - "..psiccnewveranoncet[psvercoll])
		end
psvercoll=psvercoll-1
end
	end

psicctekver=10 --ТЕК ВЕРСИЯ!!! и так выше изменить цифру что отнимаем, всего 3 раза


end
end


if GetNumRaidMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

--прерваные бои

if (icclordmboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
elseif(arg7 == psicclordm) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (iccladydeathboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
elseif (arg7 == psiccdeathwhisper or arg4 == psiccdeathwhisper) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (iccsaurfangboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
elseif(arg7 == psiccsaurfang) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (iccgunshipboyinterr) then
if(timetocheck==0) then timetocheck=arg1+8
elseif(arg9==69679 or arg9==70609 or arg9==71371 or arg9==69678 or arg9==69399 or arg9==69400 or arg9==70172 or arg9==70173 or arg9==72539) then timetocheck=arg1+8
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (iccrotfaceboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
elseif (arg7 == psiccrotface or arg4 == psiccrotface) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (iccfestergutboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
elseif (arg7 == psiccfestergut or arg4 == psiccfestergut) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (iccprofboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
elseif (arg7 == psiccputricide or arg4 == psiccputricide) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (iccsovetboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
elseif (arg7 == psiccprincename or arg7 == psiccprincename2 or arg7==psiccprincename3 or arg4 == psiccprincename or arg4 == psiccprincename2 or arg4==psiccprincename3) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (icclanaboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
elseif (arg7 == psiccbloodqueenlana or arg4 == psiccbloodqueenlana) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (iccvalytriaboyinterr) then
if(timetocheck==0) then timetocheck=arg1+8
elseif (arg7 == psiccvalithria or arg4 == psiccvalithria) then timetocheck=arg1+8
elseif(arg1>timetocheck)then
local iccbuffvalitria=GetSpellInfo(70766)
if UnitDebuff(UnitName("player"), iccbuffvalitria) then
timetocheck=arg1+8
else
psiccwipereport()
end
end
end

if (iccsindraboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
elseif (arg7 == psiccsindragosa or arg4 == psiccsindragosa or arg7==psiccsindraadd) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psiccwipereport()
end
end

if (icclkboyinterr) then
if(timetocheck==0) then timetocheck=arg1+5
local psspel1=GetSpellInfo(68981)
local psspel2=GetSpellInfo(69099)
elseif (arg7 == psicclichking or arg4 == psicclichking or arg10==psspel1 or arg10==psspel2 or arg9==69382) then timetocheck=arg1+7
elseif(arg1>timetocheck)then
psiccwipereport()
end
end


--report after bosskill
if arg2=="UNIT_DIED" then
if arg7==psicclordm or arg7==psiccdeathwhisper or arg7==psiccfestergut or arg7==psiccrotface or arg7==psiccputricide or arg7==psiccprincename or arg7==psiccbloodqueenlana or arg7==psiccsindragosa then
--festergut
if arg7==psiccfestergut then
psiccfastertimer=nil
end
--sovet
if psiccozzetimebegin and arg7==psiccprincename then
psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
end
--all
psiccwipereport()
end
end


--костяной шип
if arg2=="SPELL_AURA_APPLIED" and arg9==69065 then
--if arg2=="SPELL_SUMMON" and (arg9==69062 or arg9==72670 or arg9==72669) then
psficclordmapp(arg3, arg1)
end

if arg2=="SPELL_AURA_REMOVED" and arg9==69065 then
psficclordmrem(arg3, arg1, arg7)
end

--лорд дебаф
if arg2 == "SPELL_AURA_APPLIED" and (arg9==70823 or arg9==69146 or arg9==70824 or arg9==70825) then
psficclordniibs(arg7)
end

--ледишопот
--if (arg2=="SPELL_PERIODIC_DAMAGE" or (arg2=="SPELL_PERIODIC_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==71001 or arg9==72108 or arg9==72109 or arg9==72110) then
--psficcladynoobs()
--end
if arg2=="SPELL_DISPEL" and arg12==71237 then
psficcladynoobs()
end


if (arg2=="SPELL_DISPEL" or arg2=="SPELL_STOLEN") and arg12==70674 then
psficcladynoobs3()
end


if arg2=="SPELL_AURA_APPLIED" and arg9==71289 then
if psiccraiderinmc==nil or (psiccraiderinmc and GetTime()>psiccraiderinmc+3) then
psiccraiderinmc=GetTime()
psiccnickinmc={}
table.insert(psiccnickinmc,arg7)
psiccldwtable1={} --время
psiccldwtable2={} --ник кто бил
psiccldwtable3={} --ник кого били
psiccldwtable4={} --урон
else
table.insert(psiccnickinmc,arg7)
end
end

if psiccnickinmc and arg2=="SPELL_AURA_REMOVED" and arg9==71289 then
psiccldwremtimer=arg1+0.2
if psiccldwremtimername==nil then psiccldwremtimername={}
end
table.insert(psiccldwremtimername,arg7)
end

--damagecount
if psiccraiderinmc and GetTime()<psiccraiderinmc+12.5 and psiccldwtable1 and psbossblock==nil then
	if arg4==nil or (psiccnickinmc[1] and arg4==psiccnickinmc[1]) or (psiccnickinmc[2] and arg4==psiccnickinmc[2]) or (psiccnickinmc[3] and arg4==psiccnickinmc[3]) or arg4==psiccdeathwhisper then else

			if (psiccnickinmc[1] and arg7==psiccnickinmc[1]) or (psiccnickinmc[2] and arg7==psiccnickinmc[2]) or (psiccnickinmc[3] and arg7==psiccnickinmc[3]) then

		if arg2=="SPELL_PERIODIC_DAMAGE" then
			table.insert(psiccldwtable1,GetTime())
			table.insert(psiccldwtable2,arg4)
			table.insert(psiccldwtable3,arg7)
			table.insert(psiccldwtable4,arg12)
		addtotwodamagetables(arg4, arg12)
		psdamagetwotablsort1()
			if arg13 and arg13>0 then
				psiccldwsomeonedie(arg7)
			end
		end

		if arg2=="SPELL_DAMAGE" then
			table.insert(psiccldwtable1,GetTime())
			table.insert(psiccldwtable2,arg4)
			table.insert(psiccldwtable3,arg7)
			table.insert(psiccldwtable4,arg12)
		addtotwodamagetables(arg4, arg12)
		psdamagetwotablsort1()
			if arg13 and arg13>0 then
				psiccldwsomeonedie(arg7)
			end
		end

		if arg2=="SWING_DAMAGE" then
			table.insert(psiccldwtable1,GetTime())
			table.insert(psiccldwtable2,arg4)
			table.insert(psiccldwtable3,arg7)
			table.insert(psiccldwtable4,arg9)
		addtotwodamagetables(arg4, arg9)
		psdamagetwotablsort1()
			if arg10 and arg10>0 then
				psiccldwsomeonedie(arg7)
			end
		end


		if arg2=="RANGE_DAMAGE" then
			table.insert(psiccldwtable1,GetTime())
			table.insert(psiccldwtable2,arg4)
			table.insert(psiccldwtable3,arg7)
			table.insert(psiccldwtable4,arg12)
		addtotwodamagetables(arg4, arg12)
		psdamagetwotablsort1()
			if arg13 and arg13>0 then
				psiccldwsomeonedie(arg7)
			end
		end
			end
	end


end

if psiccldwremtimer and arg1 and arg1>psiccldwremtimer then
psiccldwremtimer=nil
for i=1,#psiccldwremtimername do
	if psiccnickinmc then
		local j=1
		while j<=#psiccnickinmc do
			if psiccnickinmc[j]==psiccldwremtimername[i] then
				table.remove(psiccnickinmc,j)
				j=50
			end
		j=j+1
		end
	end
end

psiccldwremtimername=nil
end


--lady deathwisp... ghost
if psiccschet4==0 and arg2=="SPELL_SUMMON" and arg9==71426 and psbossblock==nil then
psiccschet4=1002
wasornoladydeath=1
psiccladyghost=arg7
psiccldghosttrigid={}
psiccldghosttrigname={}

psiccldghostdmgtime={}
psiccldghostdmgid={}
psiccldghostdmgname={}

table.wipe(psiccldghosttrigid)
table.wipe(psiccldghosttrigname)
table.wipe(psiccldghostdmgtime)
table.wipe(psiccldghostdmgid)
table.wipe(psiccldghostdmgname)
end

if psiccschet4==1002 then

if (arg2=="SWING_DAMAGE" or arg2=="SWING_MISSED") and arg4==psiccladyghost then
table.insert(psiccldghosttrigid, arg3)
table.insert(psiccldghosttrigname, arg7)
if psicgalochki[3][1]==1 and psicgalochki[3][8]==1 then
if UnitSex(arg7) and UnitSex(arg7)==3 then
pszapuskanonsa(whererepiccchat[psicchatchoose[3][8]], arg7.." "..psiccanons27ftxtfem)
else
pszapuskanonsa(whererepiccchat[psicchatchoose[3][8]], arg7.." "..psiccanons27ftxt)
end
end

end

if arg2=="SPELL_DAMAGE" and (arg9==72010 or arg9==71544 or arg9==72011 or arg9==72012) then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
table.insert(psiccldghostdmgtime, arg1)
table.insert(psiccldghostdmgid, arg3)
table.insert(psiccldghostdmgname, arg7)
end
end

if arg2=="UNIT_DIED" then

if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,9)
if pswipetrue then
psiccwipereport()
else
psiccladydeathghostcheck(arg1,arg7,5,1)
end
end
end
end



end


--gunship event
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==69687 or arg9==69680 or arg9==69688 or arg9==69689) then
psficcgunshipnoobs()
end




--saurfang adds
if (arg2=="SPELL_CAST_SUCCESS" and (arg9==72173 or arg==72356 or arg==72357 or arg==72358 or arg==72172) and (pslastvalktime==nil or (pslastvalktime and arg1>pslastvalktime))) then
pslastvalktime=arg1+5

if psiccozzetimebegin then
psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psiccsaurfaddscount=nil
psiccschet4=0

if(psicgalochki[5][1]==1 and psicgalochki[5][6]==1)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[5][6]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end
end


if psiccvalk2==nil then
psiccvalk2=1
psiccupdatetable(psiccinfo141,4)
end

--создание ников и проверка их таргета, запуск онапдейт функции на 30 сек
psicclkvalkname=psiccsaurfadd
psiccsaurfaddscount=1

table.insert(psiccdamagenames[1],{})
table.insert(psiccdamagevalues[1],{})

--запись эвента
if GetRaidDifficulty()==1 or GetRaidDifficulty()==3 then
psiccschet4=2
else
psiccschet4=5
end
table.insert(psicceventsnames[1],psiccsauraddev.." #"..(#psicceventsnames[1]+1))

psicccheckswitch2(psiccsaurfadd)


psciccrezetdmgshow()
end

--считаем урон в аддов
if psiccsaurfaddscount then

if arg7==psicclkvalkname then

if arg2=="DAMAGE_SHIELD" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
iccadddamagetables(arg4, arg12, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="SPELL_PERIODIC_DAMAGE" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
iccadddamagetables(arg4, arg12, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="SPELL_DAMAGE" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
iccadddamagetables(arg4, arg12, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="RANGE_DAMAGE" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue or arg4==psiccprofadd then

iccadddamagetables(arg4, arg12, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="SWING_DAMAGE" then
if arg9 then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
iccadddamagetables(arg4, arg9, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="UNIT_DIED" then

psiccschet4=psiccschet4-1

	if psiccschet4==0 then
local psiccostalos=math.ceil(GetTime()-psiccozzetimebegin)

psicceventsnames[1][#psicceventsnames[1]]=psiccsauraddev.." #"..#psicceventsnames[1]..", "..psiccozzen4.." "..psiccostalos.." "..pssec


psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psiccsaurfaddscount=nil

if(psicgalochki[5][1]==1 and psicgalochki[5][6]==1)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[5][6]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end
	end

end --юнит дай


end

end

--саурфанг кольцо крови
if arg2=="SPELL_CAST_START" and (arg9==73058 or arg9==72378) and psiccbossblocked==nil and psbossblock==nil then
psicccouncildebsaur=arg1+7
psiccschet3=0
psiccsaurfonblood=""
end

if (arg2=="SPELL_MISSED" or arg2=="SPELL_DAMAGE") and (arg9==72438 or arg9==72380 or arg9==72439 or arg9==72440) and psicccouncildebsaur and psicccouncildebsaur>arg1 then
psficcsaurfangnoobscircle()
end

if psicccouncildebsaur and arg1>psicccouncildebsaur then
psicccouncildebsaur=nil
psiccsaurfdetectblood()
end


--саурфанг адды
if (arg2=="SWING_DAMAGE" or arg2=="SWING_MISSED") and arg4==psiccsaurfadd and psiccbossblocked==nil then
psficcsaurfangnoobs()
end

--саурфанг метка
if arg2 == "SPELL_AURA_APPLIED" and arg9==72293 then
if psicgalochki[5][4]==1 and psiccbossblocked==nil and psbossblock==nil then
psficcsaurfangafterf(1)
end

psiccsaurfmarkon(arg7)
end

--смерть при модуле саурфанга
if psiccsauractiv then
if arg2=="UNIT_DIED" then
if psiccsaurfdeldie==nil then
psiccsaurfdeldie=arg1
psiccsaurfdeldietabl={arg7}
else
table.insert(psiccsaurfdeldietabl,arg7)
end
end
end

if psiccsaurfdeldie and arg1>psiccsaurfdeldie+0.5 then
psiccsaurfdeldie=nil
for iii=1,#psiccsaurfdeldietabl do
psicconbosssaurdead(psiccsaurfdeldietabl[iii])
end
psiccsaurfdeldietabl=nil
end

--смерть саурфанга
if arg2=="UNIT_DIED" and arg7==psiccsaurfang and psbossblock==nil then
psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psiccsaurfaddscount=nil
psiccschet4=0
psiccwipereport()
end

--saurfang boss heal
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==72447 or arg9==72448 or arg9==72449 or arg9==72409) and psiccbossblocked==nil and psbossblock==nil then
wasornosaurfang=1
addtotwotables2(arg7)
vezaxsort2()
end

--Festergut
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==71288 or arg9==69244 or arg9==72276 or arg9==72277 or arg9==73173 or arg9==73174) and psiccfestertrig then
psficcfestergutnoobs1()
end

--Festergut Vile Gas cast
if arg2=="SPELL_CAST_SUCCESS" and (arg9==71218 or arg9==72272 or arg9==72273 or arg9==73019 or arg9==73020 or arg9==69240) and psiccfestertrig then
psficcfestergutnoobs2()
end

--Festergut Vile Gas apply
if arg2=="SPELL_AURA_APPLIED" and (arg9==71218 or arg9==72272 or arg9==72273 or arg9==73019 or arg9==73020 or arg9==69240) and psiccfestertrig then
psficcfestergutnoobs3()
end

--Festergut spore cast
if arg2=="SPELL_CAST_SUCCESS" and (arg9==71221 or arg9==69278) then
psficcfestergutnoobs4()
end


--Rotface1
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==69507 or arg9==71213 or arg9==73189 or arg9==73190) then
psficcrotfacenoobs1()
end

--Rotface2
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==71209 or arg9==69833 or arg9==73029 or arg9==73030) then
psficcrotfacenoobs2()
end


--festergut trigger

if arg9==72551 or arg9==72214 or arg9==72552 or arg9==72553 then
psiccfestertrig=GetTime()
end



--Putricide1
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==70853 or arg9==72297 or arg9==72458 or arg9==72548 or arg9==72549 or arg9==72550 or arg9==72873 or arg9==72874) then
if psiccfestertrig then
psficcfestergoo1()
elseif psicclanaisbatle2 then
psficcprofnoobs1()
end
end


--проф чума модуль
if arg2=="SPELL_AURA_REMOVED" and (arg9==72854 or arg9==72855 or arg9==72856 or arg9==70911) then
if (psiccprofactiv or psiccprofgal5) and psiccprofchumanorm==nil then
psiccprofmigatmark1=nil
psiccprofmigatmark2=nil
psiccprofwispchuma22=nil
--psprofbaaaaddebuf=nil
if(IsRaidOfficer()==1) then
SetRaidTarget(arg7, 0)
--psdelayprofmod=GetTime()-1
end

if pstimerclearsceneic then
	pstimerclearsceneic=nil
		if psiccm then
			psiccm:Remove()
		end
		if iccm then
			iccm:Remove()
		end
end

end

for i = 1,GetNumRaidMembers() do local name = GetRaidRosterInfo(i)
	if UnitExists(name) and GetRaidTargetIndex(name) and GetRaidTargetIndex(name)>0 and GetRaidTargetIndex(name)~=8 then
		SetRaidTarget(name, 0)
	end
end
end

if arg2=="SPELL_AURA_APPLIED" and (arg9==72854 or arg9==72855 or arg9==72856 or arg9==70911) then
if (psiccprofactiv or psiccprofgal5) and psiccprofchumanorm==nil then
psiccprofmigatmark1=nil
psiccprofmigatmark2=nil
psiccprofwispchuma22=nil
psiccprofsendonemes=1
psprofbaaaaddebuf=nil
psiccfirstmarkprofwisp=nil
if(IsRaidOfficer()==1) then
SetRaidTarget(arg7, 8)
end
end

pspatimplon=GetTime()
end



if (psiccprofactiv or psiccprofgal5) and arg2=="SPELL_AURA_APPLIED" and (arg9==72854 or arg9==72855 or arg9==72856 or arg9==70911) and psiccprofchumanorm==nil then

if psiccprofchumapull1==nil then
psiccprofchumapull1=1
local nam=UnitName("player")
if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" then nam="00"..UnitName("player") end
if IsRaidOfficer()==1 then nam="0"..nam end
SendAddonMessage("PSiccprof", nam, "RAID")
end

	psdelayprofmod=GetTime()

if(IsRaidOfficer()==1) then
SetRaidTarget(arg7, 1)
end

if psiccprofgal2==true or psiccprofgal22==true or psiccprofgal23==true then
psiccprofwispchuma1=GetTime()+psiccproftimer
psiccprofwispchuma2=arg7
end

local psdeb1 = GetSpellInfo(70911) --безуд
local _, _, _, _, _, _, expirati3 = UnitDebuff(psiccprofwispchuma2, psdeb1)


if psiccprofgal23 and psiccproftimer>5 and expirati3 and expirati3-GetTime()>5 then
	local psdeb2 = GetSpellInfo(70953) --острая
	local _, _, _, _, _, _, expirati2 = UnitDebuff(psiccprofwispchuma2, psdeb2)

	if expirati2 and expirati2-GetTime()>5 then
		psprofbaaaaddebuf=GetTime()
	end
end
	

end


if (psiccprofactiv or psiccprofgal5) and psiccprofchumanorm==nil and (arg2=="SPELL_PERIODIC_DAMAGE" or arg2=="SPELL_PERIODIC_MISSED") and (arg9==72854 or arg9==72855 or arg9==72856 or arg9==70911) then

if psiccfirstmarkprofwisp and UnitExists(psiccfirstmarkprofwisp) then

local psdeb1 = GetSpellInfo(70911) --безуд
local psdeb2 = GetSpellInfo(70953) --острая
local psdebsliz1 = GetSpellInfo(70447) --зеленый
local psdebsliz2 = GetSpellInfo(70672) --оранж слизь


		local _, _, _, _, _, _, expirati = UnitDebuff(psiccfirstmarkprofwisp, psdeb2)
		if UnitIsDeadOrGhost(psiccfirstmarkprofwisp)==nil and (UnitDebuff(psiccfirstmarkprofwisp, psdeb2)==nil or (expirati and expirati-GetTime()<5)) and UnitDebuff(psiccfirstmarkprofwisp, psdeb1)==nil and UnitDebuff(psiccfirstmarkprofwisp, psdebsliz1)==nil and UnitDebuff(psiccfirstmarkprofwisp, psdebsliz2)==nil then
		else
			psdelayprofmod=GetTime()-40
		end
end

--проверка держим череп
if psiccprofwispchuma2 and UnitExists(psiccprofwispchuma2) and (GetRaidTargetIndex(psiccprofwispchuma2)==nil or (GetRaidTargetIndex(psiccprofwispchuma2) and GetRaidTargetIndex(psiccprofwispchuma2)~=8)) then
			if(IsRaidOfficer()==1) then
			SetRaidTarget(psiccprofwispchuma2, 8)
			end
end

--проверка держим 1 метку
if psiccprofgal23 and psiccfirstmarkprofwispl then
	local imekta=0
	for po=1,#psiccprofchb do
		if imekta==0 then
			if psiccprofchb[po] and psiccprofchb[po]>0 then
				imekta=po
			end
		end
	end


	if imekta>0 then
		if UnitExists(psiccfirstmarkprofwispl) and (GetRaidTargetIndex(psiccfirstmarkprofwispl)==nil or (GetRaidTargetIndex(psiccfirstmarkprofwispl) and GetRaidTargetIndex(psiccfirstmarkprofwispl)~=imekta)) then
			SetRaidTarget(psiccfirstmarkprofwispl, imekta)
		end
	end
end



if psdelayprofmod==nil or (psdelayprofmod and GetTime()>psdelayprofmod+1.5) then

psdelayprofmod=GetTime()
psiccprofmodwork()
if psiccputrnil==nil then
psunmarkallraiders=nil
end

end
end

if (psiccprofactiv or psiccprofgal5) and arg2=="UNIT_DIED" and arg7==psiccputricide then
if psiccprofgal5==false then
psficcprofmodoff()
end
psunmarkallraiders=GetTime()+2
psiccputrnil=1
end

if (arg2=="SPELL_SUMMON" and (arg9==70311 or arg9==71503)) then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
pspaabom=arg4
end
end

--if there is no yell - enable module

if arg2=="SPELL_SUMMON" and (arg9==70311 or arg9==71503) and ((proficcyellwasseen==nil or (proficcyellwasseen and GetTime()>proficcyellwasseen+600)) or psicclanaisbatle2==nil) then

psicclanaisbatle2=1
psiccproftimeaply1=nil
psiccproftimeaply2=nil
psiccproftimeaply3=nil

if psicgalochki[8][1]==1 then

psiccprofcountdamage1=1
psiccprofcountdamage2=1
psiccprofnodelete=GetTime()
psabomtrack=1

psiccupdatetable(psiccinfo71,1)

psciccrezetdmgshow()

end

end



--module avaible only after yell

if psicclanaisbatle2 then



--putricide plague

if arg2=="SPELL_CAST_SUCCESS" and (arg9==72855 or arg9==72854 or arg9==72856 or arg9==70911) then
pschumaprofdelay=GetTime()
end

if arg2=="SPELL_AURA_APPLIED" and (arg9==72855 or arg9==72854 or arg9==72856 or arg9==70911) then

if psiccproftimeaply1==nil then psiccproftimeaply1={} end
if psiccproftimeaply2==nil then psiccproftimeaply2={} end
if psiccproftimeaply3==nil then psiccproftimeaply3={} end

local psdeb=GetSpellInfo(70953)
local psstack=0

if UnitDebuff(arg7, psdeb) then
local name, _, _, count, _, _, expirationTime = UnitDebuff(arg7, psdeb)
	if expirationTime and expirationTime-GetTime()>5 then
		if count then
			psstack=count
		end
	end
end

table.insert(psiccproftimeaply1,1,GetTime())
table.insert(psiccproftimeaply2,1,arg7)
table.insert(psiccproftimeaply3,1,psstack)

psiccproftimeaply1[5]=nil
psiccproftimeaply2[5]=nil
psiccproftimeaply3[5]=nil

if pschumaprofdelay and GetTime()>pschumaprofdelay+3 then
	if psstack>0 then
		pschumaproffail=GetTime()
		pschumaproffail2=arg7
		pschumaproffail3=psstack
	end
end

end



if pschumaprofdelay and GetTime()>pschumaprofdelay+3 and arg2=="SPELL_AURA_REMOVED" and (arg9==72855 or arg9==72854 or arg9==72856 or arg9==70911) then
if pschumaproffail and GetTime()<pschumaproffail+1.5 then

		local psstringa="{rt8} "..arg7.." "..psicchehas3.." "..pschumaproffail2.." ("..psicchehas22..": "..pschumaproffail3..")"

		if(psicgalochki[8][1]==1 and psicgalochki[8][5]==1)then
			pszapuskanonsa(whererepiccchat[psicchatchoose[8][5]], psstringa)
		end
end
pschumaproffail=nil
pschumaproffail2=nil
pschumaproffail3=nil
end




if psiccproftimeaply1 and arg2=="SPELL_PERIODIC_DAMAGE" and (arg9==72855 or arg9==72854 or arg9==72856 or arg9==70911) and arg13 and arg13>0 and psbossblock==nil then

local i=1
while i<=#psiccproftimeaply1 do
	if psiccproftimeaply2[i]==arg7 then
		local psswichspeed=math.ceil((GetTime()-psiccproftimeaply1[i])*10)/10
		local psstringa=""
if UnitSex(arg7) and UnitSex(arg7)==3 then
psstringa="{rt8} "..arg7.." "..psiccfailtxt11511fem.." \124cff71d5ff\124Hspell:"..arg9.."\124h["..arg10.."]\124h\124r "..psiccza.." "..psswichspeed.." "..pssec
else
psstringa="{rt8} "..arg7.." "..psiccfailtxt11511.." \124cff71d5ff\124Hspell:"..arg9.."\124h["..arg10.."]\124h\124r "..psiccza.." "..psswichspeed.." "..pssec
end

		if psiccproftimeaply3[i]>0 then
			local psdeb=GetSpellInfo(70953)
			psstringa=psstringa.." "..psicchehas.." \124cff71d5ff\124Hspell:70953\124h["..psdeb.."]\124h\124r ("..psicchehas22..": "..psiccproftimeaply3[i]..")"
		end
		if(psicgalochki[8][1]==1 and psicgalochki[8][8]==1)then
			pszapuskanonsa(whererepiccchat[psicchatchoose[8][8]], psstringa)
		end
		i=10
	end
i=i+1
end


end


--Putricide2
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==71279 or arg9==72621 or arg9==72622 or arg9==72459) then
psficcprofnoobs2()
end

--Putricide3
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==72456 or arg9==72868 or arg9==70346 or arg9==72869) then
psficcprofnoobs3()
end

--whois in abominator
if (psabomtrack and arg2=="SPELL_SUMMON" and (arg9==70311 or arg9==71503)) then
psabomtrack=nil
psunitisplayer(arg3,arg4)
if psunitplayertrue then
table.insert(psiccprofinabom[1],arg4)
end
end

--scanning combatlog for ooze spawn
if psiccprofcountdamage1 and (psoozewaskilled1==nil or (psoozewaskilled1 and arg1>psoozewaskilled1)) then
if arg4==psiccputricideadd1 or arg7==psiccputricideadd1 then
--ooze found! here begin to scan raid targets
psiccprofcountdamage3=1
psiccprofcountdamage1=nil
psoozewaskilled1=nil


table.insert(psiccquantooze,psiccputricideadd1) --имя слизи что бьем


table.insert(psiccdamagenames[1],{})
table.insert(psiccdamagevalues[1],{})

table.insert(psicceventsnames[1],psiccozzen1.." #"..(#psicceventsnames[1]+1).." "..psiccozzen2)
psiccozzetime1=arg1


--проверяем таргеты
psicccheckswitch(psiccputricideadd1)

psciccrezetdmgshow()


end
end

if psiccprofcountdamage2 and (psoozewaskilled2==nil or (psoozewaskilled2 and arg1>psoozewaskilled2)) then
if arg4==psiccputricideadd2 or arg7==psiccputricideadd2 then
psiccprofcountdamage3=1
psiccprofcountdamage2=nil
psoozewaskilled2=nil
table.insert(psiccquantooze,psiccputricideadd2)
table.insert(psiccdamagenames[1],{})
table.insert(psiccdamagevalues[1],{})

table.insert(psicceventsnames[1],psiccozzen1.." #"..(#psicceventsnames[1]+1).." "..psiccozzen3)

psiccozzetime2=arg1

--проверяем таргеты
psicccheckswitch(psiccputricideadd2)

psciccrezetdmgshow()

end
end


--countdamage to ooze
if psiccprofcountdamage3 then

if arg7==psiccputricideadd1 or arg7==psiccputricideadd2 then

local psminusbattle=0
if #psiccquantooze==2 and arg7==psiccquantooze[1] then
psminusbattle=1
end

if arg2=="DAMAGE_SHIELD" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue or arg4==psiccprofadd then
iccadddamagetables(arg4, arg12, psminusbattle)
iccdamagetablsort(psminusbattle)
end
end
end

if arg2=="SPELL_PERIODIC_DAMAGE" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue or arg4==psiccprofadd then
iccadddamagetables(arg4, arg12, psminusbattle)
iccdamagetablsort(psminusbattle)
end
end
end

if arg2=="SPELL_DAMAGE" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue or arg4==psiccprofadd then
iccadddamagetables(arg4, arg12, psminusbattle)
iccdamagetablsort(psminusbattle)
end
end
end

if arg2=="RANGE_DAMAGE" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue or arg4==psiccprofadd then
iccadddamagetables(arg4, arg12, psminusbattle)
iccdamagetablsort(psminusbattle)
end
end
end

if arg2=="SWING_DAMAGE" then
if arg9 then
psunitisplayer(arg3,arg4)
if psunitplayertrue or arg4==psiccprofadd then
iccadddamagetables(arg4, arg9, psminusbattle)
iccdamagetablsort(psminusbattle)
end
end
end

if arg2=="UNIT_DIED" then
local psminusb=0
if #psiccquantooze==2 and arg7==psiccquantooze[1] then
psminusb=1
end

if arg7==psiccputricideadd1 then
local psiccostalos=math.ceil(arg1-psiccozzetime1)
psicceventsnames[1][#psicceventsnames[1]-psminusb]=psiccozzen1.." #"..(#psicceventsnames[1]-psminusb).." "..psiccozzen2..", "..psiccozzen4.." "..psiccostalos.." "..pssec
psoozewaskilled1=arg1+5
psiccprofcountdamage1=1
end

if arg7==psiccputricideadd2 then
local psiccostalos=math.ceil(arg1-psiccozzetime2)
psicceventsnames[1][#psicceventsnames[1]-psminusb]=psiccozzen1.." #"..(#psicceventsnames[1]-psminusb).." "..psiccozzen3..", "..psiccozzen4.." "..psiccostalos.." "..pssec
psoozewaskilled2=arg1+5
psiccprofcountdamage2=1
end

psciccrezetdmgshow()

	if #psiccquantooze==2 then
		psiccnexttargetlook=GetTime()+0.1
		psiccozzetimebegin=GetTime()
		if(psicgalochki[8][1]==1 and psicgalochki[8][6]==1)then
		psciccreportdmgshown(whererepiccchat[psicchatchoose[8][6]],psiccdmg1,#psicceventsnames[1]-1,psiccdmg3,false,1,1)
		end
	else
		psiccnexttargetlook=nil
		psiccozzetimebegin=nil
		if(psicgalochki[8][1]==1 and psicgalochki[8][6]==1)then
		psciccreportdmgshown(whererepiccchat[psicchatchoose[8][6]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
		end
	end


--удаляю слизнь 1
local i=1
while i<=#psiccquantooze do
if psiccquantooze[i]==arg7 then
table.remove(psiccquantooze,i)
i=5
end
i=i+1
end



end --юнит дай

end
end

end --конец профа


--bloodcouncil3
if arg2=="SPELL_CAST_START" and arg9==72040 then
--шар полетел
psiccsharon=1
psiccschet=GetTime()
table.wipe(vezaxname)
table.wipe(vezaxcrash)
end

if ((arg2=="SPELL_DAMAGE" or arg2=="SPELL_MISSED") and psiccsharon and (arg9==71708 or arg9==72785 or arg9==72786 or arg9==72787)) then
--шар сбивали
psficccouncilnoobs(arg7)
end

if (arg2=="SPELL_CAST_SUCCESS" and psiccsharon and (arg9==72789 or arg9==71393 or arg9==72790 or arg9==72791)) then
--взрыв, 2-3 секунды смотрю результат и репорчу мб
psiccsharon=arg1+3
psiccschet2=GetTime()
end


if (arg2=="SPELL_DAMAGE" and psiccsharon and (arg9==72789 or arg9==71393 or arg9==72790 or arg9==72791)) then
if arg13 and arg13>0 then
--убило кого!
psicccouncilkilled1()
end
end

if psiccsharon and psiccsharon>1 and arg1>psiccsharon then
psicccouncilrezet()
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==72815 or arg9==72816 or arg9==72817 or arg9==72038) then
psficcsovetnoobaoe()
end


if arg2=="SPELL_AURA_APPLIED_DOSE" and (arg9==72998 or arg9==72999) and psbossblock==nil then
psficcsovetdose1()
if psbossblock==nil then
psficcsovetdose11(arg7,arg13)
end
end

if arg2=="SPELL_AURA_APPLIED" and (arg9==72998 or arg9==72999) and psbossblock==nil then
psficcsovetdose11(arg7,1)
end

if psiccsinddebuf1 and arg2=="SPELL_DAMAGE" and (arg9==73001 or arg9==72998 or arg9==72999) and arg13 and arg13>0 and arg12>1000 and psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
psiccsovetdose2()
end
end


--bloodcouncil

if (arg2=="SPELL_AURA_REMOVED" and (arg9==70981 or arg9==70952 or arg9==70982 or arg9==70983)) then
psicccouncildeb=arg1+3
end

if (arg2=="SPELL_AURA_APPLIED" and (arg9==70981 or arg9==70952 or arg9==70982 or arg9==70983) and psicccouncildeb and arg1<=psicccouncildeb) then

psicccouncildeb=nil

if psicccouncildeb2==nil then
--1 смена за бой, подготовить таблицы
psicccouncildeb2=arg7
psiccupdatetable(psiccinfo81,2)
end

--создание ников и проверка их таргета, запуск онапдейт функции на 15 сек
psicccouncildeb2=arg7 --кого бить

table.insert(psiccdamagenames[1],{})
table.insert(psiccdamagevalues[1],{})

--запись эвента

table.insert(psicceventsnames[1],psicccounc1.." #"..(#psicceventsnames[1]+1).." ("..psicccouncildeb2..")")

psicccheckswitch2(psicccouncildeb2)


psciccrezetdmgshow()
end



--Lana'thel

if arg2=="SPELL_CAST_SUCCESS" and arg10==psicclanacaststart then
psicclanaisbatle=1
end

	if psicclanaisbatle then

if arg2=="SPELL_CAST_SUCCESS" and arg9==71336 then
icclananoob1()
end

if arg2=="SPELL_AURA_APPLIED" and arg9==71340 then
icclananoob2()
end

if arg2=="SPELL_AURA_REMOVED" and arg9==71340 then
icclananoob3()
end

if arg2=="SPELL_CAST_SUCCESS" and arg9==71772 then
psicccouncildeb=arg1+10
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==71481 or arg9==71482 or arg9==71483 or arg9==71447) and psicccouncildeb and psicccouncildeb>arg1 then
psficclananoobff()
end


--mark off from vampyr
if (arg2=="SPELL_CAST_SUCCESS" and (arg9==71729 or arg9==71475 or arg9==71476 or arg9==71477 or arg9==71726 or arg9==71727 or arg9==71728 or arg9==70946)) then
--if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==71729 or arg9==71475 or arg9==71476 or arg9==71477 or arg9==71726 or arg9==71727 or arg9==71728 or arg9==70946) then
if psicgalochki[10][1]==1 then

if psiccschet4==0 then psiccschet4=psiccschet4+1 end

psiccschet4=psiccschet4+1

--if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" then

if psiccschet4==6 or psiccschet4==7 or psiccschet4==14 or psiccschet4==15 then
print (psiccvampyrnm..psiccschet4)
end
if psiccschet4==8 or psiccschet4==16 then
out (psiccvampyrnm..psiccschet4)
end

--end

end

if(IsRaidOfficer()==1) then
if psicclanaga==false then
psicczapusk10=nil
end
for i=1,#psicclanamarkref do
	if psicclanamarkref[i] then
	if string.lower(psicclanamarkref[i])==string.lower(arg7) then
	table.remove(psicclanamarkref,i)
	table.remove(psicclanamarkref2,i)
	end
	end
end
SetRaidTarget(arg7, 0)
end
end

	end --end lana


--valitria
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==71746 or arg9==72019 or arg9==72020 or arg9==70702) then
psficcvalytrianoobs1()
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==71743 or arg9==71086 or arg9==72029 or arg9==72030) then
psficcvalytrianoobs2()
end

--bandage healers
if psiccvalpriest and arg2=="SPELL_PERIODIC_HEAL" and arg7==psiccvalithria and arg10==psiccbandagehealer then
psvalytrihealcount()
end


--priest spirit
if psiccvalpriest and psiccschet3>0 and arg1>psiccschet3 then
psiccschet=0
psiccschet2=0
psiccschet3=0
end

if psiccschet3>0 and psiccschet3>arg1 and psiccvalpriest and arg2=="SPELL_AURA_APPLIED" and arg9==47788 and arg7==psiccvalithria then
psiccvalitriapristnoob()
psiccschet=0
psiccschet2=0
psiccschet3=0
end


if psiccvalpriest and arg2=="SPELL_AURA_APPLIED" and arg9==47788 and arg7==psiccvalithria then
psiccschet=arg1
psiccschet3=0
psficcvalytrianoobs3()
end

if psiccvalpriest and arg2=="SPELL_AURA_REMOVED" and arg9==47788 and arg7==psiccvalithria and psiccschet>0 then
psiccschet2=arg1
	if psiccschet2-psiccschet<9.6 then
	psiccschet3=arg1+2
	else
	psiccschet=0
	psiccschet2=0
	psiccschet3=0
	end

end



--sindragosa
if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==70123 or arg9==71048 or arg9==71049 or arg9==71047) then
psficcsindranoobs1(arg6,arg7)
end

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==71053 or arg9==71054 or arg9==71055 or arg9==69845) then
psficcsindranoobs2(arg6,arg7)
end

if arg2=="SPELL_AURA_APPLIED_DOSE" and (arg9==70127 or arg9==72528 or arg9==72529 or arg9==72530) then
psficcsindranoobs3()
end

if arg2=="SPELL_CAST_START" and arg9==69712 and psbossblock==nil then
psiccsindmarks={}
psiccsindmarks2={}
table.wipe(psiccsindmarks)
table.wipe(psiccsindmarks2)
end

if psiccsindmarks and arg2=="SPELL_AURA_APPLIED" and arg9==70126 then
table.insert(psiccsindmarks,arg7)
end

if psiccsindmarks and (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and arg9==70157 then
psiccsindratoombsnoobs1()
end

if arg2=="SPELL_AURA_APPLIED_DOSE" and arg9==69766 and psbossblock==nil then
psiccsindradebnoob1()
end

if psiccsinddebuf1 and arg2=="SPELL_DAMAGE" and (arg9==71044 or arg9==69770 or arg9==71045 or arg9==71046) and arg13 and arg13>0 and psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
psiccsindradebnoob2()
end
end

if psiccsinddebufunk1 and #psiccsinddebufunk1>0 and arg2=="SPELL_DAMAGE" and arg9==70157 and arg13 and arg13>0 and psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
psiccsindradebnoobice2()
end
end


if arg2=="SPELL_AURA_APPLIED_DOSE" and (arg9==72528 or arg9==70128 or arg9==72529 or arg9==72530 or arg9==70127) and psbossblock==nil then
psiccsindradebtainctv1(arg7,arg13,arg1,arg6)
end

if arg2=="SPELL_AURA_APPLIED" and (arg9==72528 or arg9==70128 or arg9==72529 or arg9==72530 or arg9==70127) and psbossblock==nil then
psiccsindradebtainctv1(arg7,1,arg1)
psiccschet=5
psiccschet2=20
end

--кол-во дебафов счетчик
if arg2=="SPELL_AURA_APPLIED" and arg9==69762 then
psficcsindranoobs44(arg6,arg7)
end

--friendly damage 1 phase
if arg2=="SPELL_AURA_APPLIED" and arg9==69762 and psiccschet~=5 then
psficcsindrabufup(arg6,arg7)
psiccschet2=10
end

if psiccschet2==10 and arg2=="SPELL_DAMAGE" and (arg9==71044 or arg9==71045 or arg9==71046 or arg9==69770) then
psficcsindrabufup2(arg4,arg7,arg12,arg6,arg3)
end

--friendly damage 3 phase
if arg2=="SPELL_AURA_APPLIED" and arg9==69762 and psiccschet==5 then
psficcsindrabufupphase3(arg6,arg7)
--psiccschet2=20
end

if psiccschet2==20 and arg2=="SPELL_DAMAGE" and (arg9==71044 or arg9==71045 or arg9==71046 or arg9==69770) then
psficcsindrabufupphase32(arg4,arg7,arg12,arg6,arg3)
end



--the lich king
if arg2=="SPELL_CAST_START" and arg9==72762 and psbossblock==nil and pslichdefile==nil then
psiccidofdefile=nil
psiccdefsecsarg=nil
psiccschet2=0
psicclichupdate=GetTime()
psicclichdelfireon=psiccunknown
end

if arg2=="SPELL_SUMMON" and arg9==72762 and psbossblock==nil and pslichdefile==nil then
psiccidofdefile=arg6
psiccdefsecs=3
psiccdefsecsarg=arg1+4
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)
psiccdefsecsargoffic1=GetTime()+1.3
psiccdefsecsargoffic2=GetTime()+2.3
psiccdefsecsargoffic3=GetTime()+3.3
psiccschet2=0
psiccdefspawn=1
pslichdefile=GetTime()+10
psicclichupdate=nil
psiccschet3=psiccschet3+1
if psbossblock==nil then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornolk=1
end
end
end

if ((arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==72754 or arg9==73708 or arg9==73709 or arg9==73710)) then
psficclknoobs1()
if pslichdefile and GetTime()<pslichdefile then
psficclknoobs2()
end
end

--the LK valkyr
if (arg2=="SPELL_SUMMON" and arg9==69037) then
if (pslastvalktime==nil or (pslastvalktime and arg1>pslastvalktime)) then
pslastvalktime=arg1+5


if psiccinst and string.find(psiccinst,psiccheroic) then
psvalheroicswitch=1
end

if psiccozzetimebegin then
psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psicclkvalkcount=nil
psiccschet=0
table.wipe(psvalkidtable)
table.wipe(psvalkidtable50)

if(psicgalochki[13][1]==1 and psicgalochki[13][4]==1 and GetRealZoneText()==pszoneicecrowncit)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[13][4]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end

--ыыырепорт
if(psicgalochki[13][1]==1 and psicgalochki[13][9]==1 and GetRealZoneText()==pszoneicecrowncit)then
strochkadamageout="{rt1}"..psiccbossfail129t.." #"..psiccschet5.." "..psiccbossfail129t2
reportfromtridamagetables(whererepiccchat[psicchatchoose[13][9]],10)
end

table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)

end

psiccschet5=psiccschet5+1


if psiccvalk1==nil then
psiccvalk1=1
psiccupdatetable(psiccinfo131,3)
end

--создание ников и проверка их таргета, запуск онапдейт функции на 30 сек
psicclkvalkname=arg7
psicclkvalkcount=1

table.insert(psiccdamagenames[1],{})
table.insert(psiccdamagevalues[1],{})

--запись эвента
if GetRaidDifficulty()==1 or GetRaidDifficulty()==3 then
psiccschet=1
table.insert(psicceventsnames[1],psicclkvalkir.." #"..psiccschet5)
else
psiccschet=3
table.insert(psicceventsnames[1],psicclkvalkir3.." #"..psiccschet5)
end
psiccvalktimertarg=GetTime()
psiccvalktimertargtabl={}
table.wipe(psiccvalktimertargtabl)

psicccheckswitch2(arg7.."notzero", 2.5)


psciccrezetdmgshow()
end

if psiccinst and string.find(psiccinst,psiccheroic) then
table.insert(psvalkidtable,arg6)
end

end

--считаем урон в валькирии
if psicclkvalkcount then


if arg7==psicclkvalkname then

local countdmg=1
if psiccinst and string.find(psiccinst,psiccheroic) then
countdmg=0
if #psvalkidtable>0 then
	for yh=1,#psvalkidtable do
		if arg6==psvalkidtable[yh] then
			countdmg=1
		end
	end
end
end

	if countdmg==1 then

if arg2=="DAMAGE_SHIELD" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
iccadddamagetables(arg4, arg12, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="SPELL_PERIODIC_DAMAGE" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
iccadddamagetables(arg4, arg12, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="SPELL_DAMAGE" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
iccadddamagetables(arg4, arg12, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="RANGE_DAMAGE" then
if arg12 then
psunitisplayer(arg3,arg4)
if psunitplayertrue or arg4==psiccprofadd then

iccadddamagetables(arg4, arg12, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="SWING_DAMAGE" then
if arg9 then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
iccadddamagetables(arg4, arg9, 0)
iccdamagetablsort(0)
end
end
end

if arg2=="UNIT_DIED" then

psiccschet=psiccschet-1

	if psiccschet==0 then
local psiccostalos=math.ceil(GetTime()-psiccozzetimebegin)

if GetRaidDifficulty()==1 or GetRaidDifficulty()==3 then
psicceventsnames[1][#psicceventsnames[1]]=psicceventsnames[1][#psicceventsnames[1]]..", "..psiccozzen4.." "..psiccostalos.." "..pssec
else
psicceventsnames[1][#psicceventsnames[1]]=psicceventsnames[1][#psicceventsnames[1]]..", "..psiccozzen4.." "..psiccostalos.." "..pssec
end

psiccozzetimebegin=nil
psiccnexttargetlook=nil
psciccrezetdmgshow()
psicclkvalkcount=nil

if(psicgalochki[13][1]==1 and psicgalochki[13][4]==1)then
psciccreportdmgshown(whererepiccchat[psicchatchoose[13][4]],psiccdmg1,#psicceventsnames[1],psiccdmg3,false,1,1)
end
	end

end --юнит дай


	end

end

end

--счетчик для лишнего урона в валькирий

if psicclkvalkcount and #psvalkidtable50>0 then

local kount=0
if arg6 then
for t=1,#psvalkidtable50 do
	if psvalkidtable50[t]==arg6 then
		kount=1
	end
end
end

	if kount==1 then


if arg2=="SPELL_DAMAGE" then
if arg9==58735 or arg9==10444 or arg9==1680 or arg9==44949 or arg9==55262 or arg9==25504 or arg9==57975 or arg9==47520 or arg9==55362 or arg9==57965 or arg9==51690 or arg9==53190 or arg9==48480 or arg9==50590 then else
if arg12==nil then else
				--ПЕТЫ ТОЖЕ СЧИТАЮТСЯ!
--psunitisplayer(arg3,arg4)
--if psunitplayertrue then
addtotridamagetables(arg4, arg12,1)
psdamagetritablsort1()
--end
end
end
end
if arg2=="RANGE_DAMAGE" then
if arg12==nil then else
--psunitisplayer(arg3,arg4)
--if psunitplayertrue then
addtotridamagetables(arg4, arg12,1)
psdamagetritablsort1()
--end
end
end

--белые атаки отключены при счете:
--if arg2=="SWING_DAMAGE" then
--if arg9==nil then else
--addtotridamagetables(arg4, arg9,1)
--psdamagetritablsort1()
--end
--end

	end

end





--lk heal debuf
if arg2=="SPELL_AURA_APPLIED" and (arg9==68980 or arg9==74325 or arg9==74326 or arg9==74327) then
psicclkneedheal=arg7
psicclktime8=arg1
psicclkhealcount=1
end


if arg2=="SPELL_AURA_REMOVED" and (arg9==68980 or arg9==74325 or arg9==74326 or arg9==74327) then
psicclkhealcount=nil
if UnitName("player")==arg7 then
pszapuskdelayphasing=pszapuskdelayphasing+2.5
end
end


if psicclkhealcount then

if arg2=="SPELL_HEAL" and arg7==psicclkneedheal then

psunitisplayer(arg3,arg4)
if psunitplayertrue then

if arg12-arg13>0 then
addtotwodamagetables(arg4, arg12-arg13)
psdamagetwotablsort1()
if wasornolk then
addtotwodamagetables3(arg4, arg12-arg13)
psdamagetwotablsort3()
end
end
end
end

if arg2=="SPELL_PERIODIC_HEAL" and arg7==psicclkneedheal then
psunitisplayer(arg3,arg4)
if psunitplayertrue then
if arg12-arg13>0 then
addtotwodamagetables(arg4, arg12-arg13)
psdamagetwotablsort1()
if wasornolk then
addtotwodamagetables3(arg4, arg12-arg13)
psdamagetwotablsort3()
end
end
end
end

end

if psicclktime8 and arg2=="UNIT_DIED" and arg7==psicclkneedheal then

if(psicgalochki[13][1]==1 and psicgalochki[13][6]==1)then
if psdamagename2 and #psdamagename2>0 then
local pstm=math.ceil((arg1-psicclktime8)*10)/10
strochkadamageout="{rt8}"..psicclkneedheal.." "..psicclkdiedharv.." "..pstm.." "..pssec.." "..psicclkdiedharv2..": "
reportfromtwodamagetables(whererepiccchat[psicchatchoose[13][6]], 1)
else
local pstm=math.ceil((arg1-psicclktime8)*10)/10
pszapuskanonsa(whererepiccchat[psicchatchoose[13][6]], "{rt8}"..psicclkneedheal.." "..psicclkdiedharv.." "..pstm.." "..pssec.." "..psicclkdiedharv2..": "..psicclkdiedharv3..".")
end
end

if psicgalochki[13][1]==1 and ((psicgalochki[13][6]==1 and whererepiccchat[psicchatchoose[13][5]]~=whererepiccchat[psicchatchoose[13][6]] and psicgalochki[13][5]==1) or (psicgalochki[13][6]==0 and psicgalochki[13][5]==1)) then
if psdamagename2 and #psdamagename2>0 then
local pstm=math.ceil((arg1-psicclktime8)*10)/10
strochkadamageout="{rt8}"..psicclkneedheal.." "..psicclkdiedharv.." "..pstm.." "..pssec.." "..psicclkdiedharv2..": "
reportfromtwodamagetables(whererepiccchat[psicchatchoose[13][5]], 1)
else
local pstm=math.ceil((arg1-psicclktime8)*10)/10
pszapuskanonsa(whererepiccchat[psicchatchoose[13][5]], "{rt8}"..psicclkneedheal.." "..psicclkdiedharv.." "..pstm.." "..pssec.." "..psicclkdiedharv2..": "..psicclkdiedharv3..".")
end
end

psicclktime8=nil
psicclkneedheal=nil
psicclkhealcount=nil
table.wipe(psdamagename2)
table.wipe(psdamagevalue2)

end


if psicclktime8 and arg1>psicclktime8+8 then

if(psicgalochki[13][1]==1 and psicgalochki[13][5]==1)then
if psdamagename3 and #psdamagename3>0 then
strochkadamageout="{rt1}"..psicclkdiedharv4.." "..psicclkneedheal.." "..psicclkdiedharv5..": "
reportfromtwodamagetables(whererepiccchat[psicchatchoose[13][5]], false, 7)
else
pszapuskanonsa(whererepiccchat[psicchatchoose[13][5]], "{rt1}"..psicclkdiedharv4.." "..psicclkneedheal.." "..psicclkdiedharv5..": "..pcicccombat4)
end
end

psicclktime8=nil
psicclkneedheal=nil
psicclkhealcount=nil
table.wipe(psdamagename2)
table.wipe(psdamagevalue2)

end

if arg2=="SPELL_AURA_APPLIED" and (arg9==70503 or arg9==73806 or arg9==73807 or arg9==73808) then
if psbossblock==nil then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornolk=1
psiccschet4=psiccschet4+1
end
end
end

if wasornolk and (arg9==72350 or arg9==72351 or arg9==70063) and arg2=="SPELL_AURA_APPLIED" and (psicclichnotspamrep==nil or (psicclichnotspamrep and GetTime()>psicclichnotspamrep+100)) then
psicclichnotspamrep=GetTime()
psiccwipereport()
end



end --цитадели
end --КОНЕЦ ОНЕВЕНТ


function PSF_closeallpricecrown()
PSFmainic1:Hide()
PSFiccsaurf:Hide()
PSFiccdamageinfo:Hide()
PSFicclana:Hide()
PSFiccprofframe:Hide()
PSFiccaftercombinfoframe:Hide()
PSFiccaddonno:Hide()
end


function PSF_buttonicecrown2()
PSF_closeallpr()
PSFmainic1:Show()
openbossic()
openchatic()
openchatic2()
if psfirstloadic==nil then psfirstloadic=1 pssozdanietextic() end
pszapuskmenuic()
--размер поправляем
PSFmainic1_Text3:SetFont(GameFontNormal:GetFont(), 14)
PSFmainic1_Text4:SetFont(GameFontNormal:GetFont(), 14)
end


function openbossic()
if not DropDownMenubossic then
CreateFrame("Frame", "DropDownMenubossic", PSFmainic1, "UIDropDownMenuTemplate")
end

DropDownMenubossic:ClearAllPoints()
DropDownMenubossic:SetPoint("TOPLEFT", 8, -20)
DropDownMenubossic:Show()

local items={}

	if icbossselected==1 and psicgalochki[1][1]==0 then
items = {psicmoduleoff}
	else
items = psicboss
	end

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenubossic, self:GetID())

icbossselected=self:GetID()
pszapuskmenuic()


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


UIDropDownMenu_Initialize(DropDownMenubossic, initialize)
UIDropDownMenu_SetWidth(DropDownMenubossic, 160)
UIDropDownMenu_SetButtonWidth(DropDownMenubossic, 175)
UIDropDownMenu_SetSelectedID(DropDownMenubossic,icbossselected)
UIDropDownMenu_JustifyText(DropDownMenubossic, "LEFT")
end


function openchatic()
if not DropDownchatic then
CreateFrame("Frame", "DropDownchatic", PSFmainic1, "UIDropDownMenuTemplate")
end

DropDownchatic:ClearAllPoints()
DropDownchatic:SetPoint("TOPLEFT", 430, -10)
DropDownchatic:Show()

local items = bigmenuchatlist

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownchatic, self:GetID())

if self:GetID()>8 then
whererepiccchat[1]=psfchatadd[self:GetID()-8]
else
whererepiccchat[1]=bigmenuchatlisten[self:GetID()]
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

bigmenuchat2(whererepiccchat[1])
if bigma2num==0 then
whererepiccchat[1]=bigmenuchatlisten[1]
bigma2num=1
end

UIDropDownMenu_Initialize(DropDownchatic, initialize)
UIDropDownMenu_SetWidth(DropDownchatic, 85)
UIDropDownMenu_SetButtonWidth(DropDownchatic, 100)
UIDropDownMenu_SetSelectedID(DropDownchatic, bigma2num)
UIDropDownMenu_JustifyText(DropDownchatic, "LEFT")
end


function openchatic2()
if not DropDownchatic2 then
CreateFrame("Frame", "DropDownchatic2", PSFmainic1, "UIDropDownMenuTemplate")
end

DropDownchatic2:ClearAllPoints()
DropDownchatic2:SetPoint("TOPLEFT", 430, -33)
DropDownchatic2:Show()

local items = bigmenuchatlist

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownchatic2, self:GetID())

if self:GetID()>8 then
whererepiccchat[2]=psfchatadd[self:GetID()-8]
else
whererepiccchat[2]=bigmenuchatlisten[self:GetID()]
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

bigmenuchat2(whererepiccchat[2])
if bigma2num==0 then
whererepiccchat[2]=bigmenuchatlisten[1]
bigma2num=1
end

UIDropDownMenu_Initialize(DropDownchatic2, initialize)
UIDropDownMenu_SetWidth(DropDownchatic2, 85)
UIDropDownMenu_SetButtonWidth(DropDownchatic2, 100)
UIDropDownMenu_SetSelectedID(DropDownchatic2, bigma2num)
UIDropDownMenu_JustifyText(DropDownchatic2, "LEFT")
end


function pszapuskmenuic()
psspryatatvseic()

if icbossselected==1 and psicgalochki[1][1]==1 then
--rezet button avaible
tpsicinforezet:Show()
PSFmainic1_Buttonrez:Show()
else
tpsicinforezet:Hide()
PSFmainic1_Buttonrez:Hide()
end


if psicgalochki[icbossselected][1]==1 then psiccchbtfr[1]:SetChecked() psiccchbtfr[1]:Show() elseif psicgalochki[icbossselected][1]==0 then psiccchbtfr[1]:SetChecked(false) psiccchbtfr[1]:Show() end
	if psicgalochki[icbossselected][1]==1 then

--цифры, радиобаттоны

for i=2,9 do

	if psicgalochki[icbossselected][i] and psicgalochki[icbossselected][i]==1 then

		psiccchbtfr[i]:SetChecked() psiccchbtfr[i]:Show()

		if psicchatchoose[icbossselected][i]==0 then else
			psicctablecifr[i]:Show()
			psicctableradiobut1[i]:Show()
			psicctableradiobut2[i]:Show()
			if psicchatchoose[icbossselected][i]==1 then
				psicctablecifr[i]:SetText("|cff00ff001|r")
				psicctableradiobut1[i]:SetChecked()
				psicctableradiobut2[i]:SetChecked(false)
			end
			if psicchatchoose[icbossselected][i]==2 then
				psicctablecifr[i]:SetText("|cffff00002|r")
				psicctableradiobut1[i]:SetChecked(false)
				psicctableradiobut2[i]:SetChecked()
			end
		end
	elseif psicgalochki[icbossselected][i] and psicgalochki[icbossselected][i]==0 then
			psiccchbtfr[i]:SetChecked(false) psiccchbtfr[i]:Show()
	end
end


	end


if psicmenu[icbossselected][1] then tpsicinfo1:SetText(psicmenu[icbossselected][1]) end
	if psicgalochki[icbossselected][1]==1 then
if psicgalochki[icbossselected][2] and psicmenu[icbossselected][2] then tpsicinfo2:SetText(psicmenu[icbossselected][2]) end
if psicgalochki[icbossselected][3] and psicmenu[icbossselected][3] then tpsicinfo3:SetText(psicmenu[icbossselected][3]) end
if psicgalochki[icbossselected][4] and psicmenu[icbossselected][4] then tpsicinfo4:SetText(psicmenu[icbossselected][4]) end
if psicgalochki[icbossselected][5] and psicmenu[icbossselected][5] then tpsicinfo5:SetText(psicmenu[icbossselected][5]) end
if psicgalochki[icbossselected][6] and psicmenu[icbossselected][6] then tpsicinfo6:SetText(psicmenu[icbossselected][6]) end
if psicgalochki[icbossselected][7] and psicmenu[icbossselected][7] then tpsicinfo7:SetText(psicmenu[icbossselected][7]) end
if psicgalochki[icbossselected][8] and psicmenu[icbossselected][8] then tpsicinfo8:SetText(psicmenu[icbossselected][8]) end
if psicgalochki[icbossselected][9] and psicmenu[icbossselected][9] then tpsicinfo9:SetText(psicmenu[icbossselected][9]) end
	end

if icbossselected==1 then fpsicinfom1:SetText("    "..psicicecrownname.." - "..psicmaintitle) else fpsicinfom1:SetText("    "..psicicecrownname.." - "..psicboss[icbossselected]) end

tpsicinfom2:SetText(psicdescription[icbossselected])


if icbossselected==1 and psicgalochki[1][1]==0 then
tpsicinfom2:SetText("|cffff0000"..psicmodulenotena.."|r")
openbossic()
end

end


function psspryatatvseic()
tpsicinfo1:SetText(" ")
tpsicinfo2:SetText(" ")
tpsicinfo3:SetText(" ")
tpsicinfo4:SetText(" ")
tpsicinfo5:SetText(" ")
tpsicinfo6:SetText(" ")
tpsicinfo7:SetText(" ")
tpsicinfo8:SetText(" ")
tpsicinfo9:SetText(" ")
tpsicinfom2:SetText(" ")
for i=1,9 do
psicctablecifr[i]:Hide()
psicctableradiobut1[i]:Hide()
psicctableradiobut2[i]:Hide()
psiccchbtfr[i]:Hide()
end
end

function PSFcheckic(nrmenu)
if psicgalochki[icbossselected][nrmenu]==1 then psicgalochki[icbossselected][nrmenu]=0 else psicgalochki[icbossselected][nrmenu]=1 end
	if nrmenu==1 then
	pszapuskmenuic()
	end

	if icbossselected==1 and psicgalochki[1][1]==1 then
	openbossic()
	end
pszapuskmenuic()

end

function pssozdanietextic()

--мейн титул
fpsicinfom1:SetText("    "..psicicecrownname.." - "..psicmaintitle)


--текст и фреймы возле чекбатонов
tpsicinfo1 = PSFmainic1:CreateFontString()
psicdrowbuttx(tpsicinfo1,-108)

tpsicinfo2 = PSFmainic1:CreateFontString()
psicdrowbuttx(tpsicinfo2,-131)

tpsicinfo3 = PSFmainic1:CreateFontString()
psicdrowbuttx(tpsicinfo3,-154)

tpsicinfo4 = PSFmainic1:CreateFontString()
psicdrowbuttx(tpsicinfo4,-177)

tpsicinfo5 = PSFmainic1:CreateFontString()
psicdrowbuttx(tpsicinfo5,-200)

tpsicinfo6 = PSFmainic1:CreateFontString()
psicdrowbuttx(tpsicinfo6,-223)

tpsicinfo7 = PSFmainic1:CreateFontString()
psicdrowbuttx(tpsicinfo7,-246)

tpsicinfo8 = PSFmainic1:CreateFontString()
psicdrowbuttx(tpsicinfo8,-269)

tpsicinfo9 = PSFmainic1:CreateFontString()
psicdrowbuttx(tpsicinfo9,-292)


--описание босса
tpsicinfom2 = PSFmainic1:CreateFontString()
tpsicinfom2:SetFont(GameFontNormal:GetFont(), 12)
tpsicinfom2:SetPoint("TOPLEFT",25,-57)
tpsicinfom2:SetWidth(565)
tpsicinfom2:SetHeight(45)
tpsicinfom2:SetText(" ")
tpsicinfom2:SetJustifyH("LEFT")
tpsicinfom2:SetJustifyV("CENTER")


--rezet text
tpsicinforezet = PSFmainic1:CreateFontString()
tpsicinforezet:SetFont(GameFontNormal:GetFont(), 12)
tpsicinforezet:SetPoint("TOPLEFT",71,-137)
tpsicinforezet:SetWidth(515)
tpsicinforezet:SetHeight(45)
tpsicinforezet:SetText(tpsicinforezettxt)
tpsicinforezet:SetJustifyH("LEFT")
tpsicinforezet:SetJustifyV("TOP")


--пассивные модули
tpsicpasmod = PSFmainic1:CreateFontString()
tpsicpasmod:SetFont(GameFontNormal:GetFont(), 14)
tpsicpasmod:SetPoint("TOPLEFT",25,-312)
tpsicpasmod:SetWidth(565)
tpsicpasmod:SetHeight(15)
tpsicpasmod:SetText("|cff00ff00"..psicpasmodtxt.."|r")
tpsicpasmod:SetJustifyH("LEFT")

--цифры
psicctablecifr={}
psicctableradiobut1={}
psicctableradiobut2={}
psiccchbtfr={}

for jj=1,9 do
local c = PSFmainic1:CreateFontString()
c:SetFont(GameFontNormal:GetFont(), 15)
c:SetPoint("TOPLEFT",38,-85-23*jj)
c:SetWidth(30)
c:SetHeight(15)
c:SetJustifyH("LEFT")
table.insert(psicctablecifr, c)

--radio buttons
local r = CreateFrame("CheckButton", nil, PSFmainic1, "SendMailRadioButtonTemplate")
r:SetPoint("TOPLEFT", 12, -84-jj*23)
r:SetScript("OnClick", function(self) psiccradiobuttchange(1,jj) end )
table.insert(psicctableradiobut1, r)


local t = CreateFrame("CheckButton", nil, PSFmainic1, "SendMailRadioButtonTemplate")
t:SetPoint("TOPLEFT", 24, -84-jj*23)
t:SetScript("OnClick", function(self) psiccradiobuttchange(2,jj) end )
table.insert(psicctableradiobut2, t)

--checkbuttons
local q = CreateFrame("CheckButton", nil, PSFmainic1, "OptionsCheckButtonTemplate")
q:SetWidth("25")
q:SetHeight("25")
q:SetPoint("TOPLEFT", 47, -80-jj*23)
q:SetScript("OnClick", function(self) PSFcheckic(jj) end )
table.insert(psiccchbtfr, q)

end



end

function psicdrowbuttx(aa,bb)
	if GetLocale() == "deDE" then
aa:SetFont(GameFontNormal:GetFont(), 10)
	else
aa:SetFont(GameFontNormal:GetFont(), 10)
	end
aa:SetPoint("TOPLEFT",71,bb)
aa:SetWidth(555)
aa:SetHeight(15)
aa:SetText(" ")
aa:SetJustifyH("LEFT")
end

function psiccradiobuttchange(tt,jj)
psicchatchoose[icbossselected][jj]=tt

if psicchatchoose[icbossselected][jj]==1 then
	psicctablecifr[jj]:SetText("|cff00ff001|r")
	psicctableradiobut1[jj]:SetChecked()
	psicctableradiobut2[jj]:SetChecked(false)
end
if psicchatchoose[icbossselected][jj]==2 then
	psicctablecifr[jj]:SetText("|cffff00002|r")
	psicctableradiobut1[jj]:SetChecked(false)
	psicctableradiobut2[jj]:SetChecked()
end

end

function psiccallrezet()
if psiccrezdelay==nil or (psiccrezdelay and GetTime()>psiccrezdelay+10) then
out("|cff99ffffPhoenixStyle|r - |cffff0000"..psattention.."|r "..psiccrezonemore)
psiccrezdelay=GetTime()
else
out("|cff99ffffPhoenixStyle|r - "..psiccrezcompl)

whererepiccchat={"raid", "sebe"}
psicgalochki=psicgalochkidef
psicchatchoose=psicchatchosdef
psicdopmodchat=psicdopmodchatdef
psicsaurfgalk={1,1,1,1,1,1}
psiccsaurf={"HealerA","HealerB","HealerC","HealerD","HealerA","","",""}
psiccdmg3=4
openchatic()
openchatic2()
psiccprofgal5=false

end
end

function psicccheckclassm(psname)
psiccclassfound=nil
local _, rsctekclass = UnitClass(psname)
				if rsctekclass then
rsctekclass=string.lower(rsctekclass)

if rsctekclass=="warrior" then psiccclassfound="|CFFC69B6D"
elseif rsctekclass=="deathknight" then psiccclassfound="|CFFC41F3B"
elseif rsctekclass=="paladin" then psiccclassfound="|CFFF48CBA"
elseif rsctekclass=="priest" then psiccclassfound="|CFFFFFFFF"
elseif rsctekclass=="shaman" then psiccclassfound="|CFF1a3caa"
elseif rsctekclass=="druid" then psiccclassfound="|CFFFF7C0A"
elseif rsctekclass=="rogue" then psiccclassfound="|CFFFFF468"
elseif rsctekclass=="mage" then psiccclassfound="|CFF68CCEF"
elseif rsctekclass=="warlock" then psiccclassfound="|CFF9382C9"
elseif rsctekclass=="hunter" then psiccclassfound="|CFFAAD372"
end
				end
end


function psiccdeletlocal()
psiccdeathtitle=nil
psiccsaurfangtitle=nil
psiccanons11=nil
psiccanons12=nil
psiccanons13=nil
psiccanons21=nil
psiccanons22=nil
psiccanons23=nil
psiccanons24=nil
psiccanons25=nil
psiccanons26=nil
psiccanons27=nil
psiccanons28=nil
psiccanons41=nil
psiccanons42=nil
psiccanons43=nil
psiccanons44=nil
psiccgunship51=nil
psicchoosebosstxt=nil
psicclordmtitle=nil
psiccgunshiptitle=nil
psiccbossfail61=nil
psiccbossfail62=nil
psiccbossfail71=nil
psiccbossfail72=nil
psiccbossfail73=nil
psiccbossfail74=nil
psiccbossfail75=nil
psiccbossfail51=nil
psiccbossfail52=nil
psiccbossfail53=nil
psiccbossfail54=nil
psiccbossfail55=nil
psiccbossfail56=nil
psicctitle5=nil
psicctitle6=nil
psicctitle7=nil
psicctitle8=nil
psiccbossfail81=nil
psiccbossfail82=nil
psiccbossfail83=nil
psiccbossfail84=nil
psiccbossfail85=nil
psicctitle9=nil
psiccbossfail91=nil
psiccbossfail92=nil
psiccbossfail93=nil
psicctitle10=nil
psicctitle11=nil
psicctitle12=nil
psiccbossfail101=nil
psiccbossfail102=nil
psiccbossfail103=nil
psiccbossfail104=nil
psiccbossfail111=nil
psiccbossfail112=nil
psiccbossfail113=nil
psiccbossfail114=nil
psiccbossfail115=nil
psiccbossfail116=nil
psiccbossfail117=nil
psiccbossfail121=nil
psiccbossfail122=nil
psiccbossfail124=nil
psiccbossfail125=nil
psiccbossfail126=nil
psiccbossfail127=nil
psiccbossfail128=nil
psiccbossfail76=nil
psiccbossfail77=nil
psiccanons45=nil
psiccanons46=nil
end



function psiccwipereport()

	if pszapuskdelayphasing>0 then
	psiccrepupdate=pszapuskdelayphasing
	pszapuskdelayphasing=0
	if psiccrepupdate>5 then psiccrepupdate=5 end
	psiccrepupdate=psiccrepupdate+GetTime()
	else

		if psiccrepupdate==nil then

if (wasornolordm) then
psficclorlmafterf()
psficclordmresetall()
end

if (wasornoladydeath) then
psficcladydeathafterf()
psficcladydeathresetall()
end

if (wasornosaurfang) then
psficcsaurfangafterf()
psficcsaurfangresetall()
end

if (wasornogunship) then
psficcgunshipafterf()
psficcgunshipresetall()
end

if (wasornorotface) then
psficcrotfaceafterf()
psficcrotfaceresetall()
end

if (iccfestergutboyinterr) then
psficcfestergutafterf()
psficcfestergutresetall()
end

if (wasornoprof) then
psficcprofafterf()
psficcprofresetall()
end

if (wasornosovet) then
psficcsovetafterf()
psficcsovetresetall()
end

if (wasornolana) then
psficclanaafterf()
psficclanaresetall()
end

if (wasornovalytria) then
psficcvalytriaafterf()
psficcvalytriaresetall()
end

if (wasornosindra) then
psficcsindraafterf()
psficcsindraresetall()
end

if (wasornolk) then
psficclkafterf()
psficclkresetall()
end

		end

	end

psbossblock=GetTime()

end

function psiccsindraaddon()
if IsAddOnLoaded("Sindragosa_IceTombMonitor") then
SINDRA_Command()
PSF_buttonsaveexit()
print("|cff00ff00Sindragosa_IceTombMonitor|r > "..psiccsindraaddontxt..".")
else
out("|cff00ff00Sindragosa_IceTombMonitor|r > |cffff0000"..psiccnotinstalled.."!|r")

PSF_closeallpr()
PSFiccaddonno:Show()

if ttfggdgvsfar==nil then
ttfggdgvsfar = PSFiccaddonno:CreateFontString()
ttfggdgvsfar:SetWidth(550)
ttfggdgvsfar:SetHeight(150)
ttfggdgvsfar:SetFont(GameFontNormal:GetFont(), 12)
ttfggdgvsfar:SetPoint("TOPLEFT",20,-100)
ttfggdgvsfar:SetText(psleftmenu1.." |cffff0000"..psiccnotinstalled.."!|r\r\n\r\n|cff00ff00Sindragosa_IceTombMonitor|r > "..psiccsindraaddontxt..".\r\n\r\n"..psraaddonanet2)
ttfggdgvsfar:SetJustifyH("CENTER")
ttfggdgvsfar:SetJustifyV("TOP")
end


end
end


function psiccChatFilter(self, event, msg, author, ...)
if msg and self then
msg=string.lower(msg)
	if msg:find(string.lower(psiccprofpreptotake)) or msg:find(string.lower(pscanttakeplag)) or msg:find(string.lower(psiccprofchumt1)) or msg:find(string.lower(psiccprofmodopt23go)) or msg:find(string.lower(psicclanawhisp1)) or msg:find(string.lower(psicclanawhisp2)) then
	return true

	end
end
end