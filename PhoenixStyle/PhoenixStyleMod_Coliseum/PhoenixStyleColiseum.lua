-- Author: Shurshik
-- http://phoenix-wow.ru

function psfColiseum()

pslocalecoliseum()
pslocalecoliseumui()
pslocalecoliseumboss()


	psdamagvalkyes=0
	psvalbitnada="0"
	psnoobibiyut="0"
	psshieldon=0
	psshieldamount=0
	psschitupal=0
	psfirsteventshield=0
	psjxshieldon=0
	psjxpausareport=0
	psjxpausareport2=0
	psvaltable={}
	psvalnextshtime=0
	psvaltimetableadd=0


	if(wherereporttwins == nil) then wherereporttwins = "raid" end
	if(wherereportzveri == nil) then wherereportzveri = "raid" end
	if(wherereportjarax == nil) then wherereportjarax = "raid" end
	if(wherereportinfshield==nil) then wherereportinfshield="raid" end
	if(wherereportanub==nil) then wherereportanub="raid" end
	if(wherereportanub2==nil) then wherereportanub2="raid" end
	if(twinspart == nil) then twinspart = true end
	if(twinspart2 == nil) then twinspart2 = false end
	if(twinspart3 == nil) then twinspart3 = true end
	if(twinspart4 == nil) then twinspart4 = false end
	if(zveripart == nil) then zveripart = true end
	if(jaraxpart == nil) then jaraxpart = true end
	if(jaraxpart2 == nil) then jaraxpart2 = false end
	if(pswelwidth == nil) then pswelwidth = 150 end
	if(pswelheight == nil) then pswelheight = 80 end
	if(pscoltekver == nil) then pscoltekver = 0 end
	if psanubheal==nil then psanubheal={"","","DBM-healerA","DBM-healerB","DBM-healerC","DBM-healerD","DBM-healerE",""} end
	if psanubbop==nil then psanubbop={"BoP-A","BoP-B","BoP-C","BoP-D"} end

if (psgalochki==nil) then
psgalochki={"yes",
"yes",
"yes"
}
end

if GetRealZoneText()==pszonecoliseum then
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	this:RegisterEvent("PLAYER_TARGET_CHANGED")
end
	this:RegisterEvent("PLAYER_REGEN_DISABLED")
	this:RegisterEvent("PLAYER_REGEN_ENABLED")
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	this:RegisterEvent("ADDON_LOADED")



end

function PSFcoli_OnUpdate()

local pstwtimenow=GetTime()

if psshieldon==1 and twvalboss1==nil then

--чо делать со щитом


if psschitupal==1 then
if(psgalochki[2]=="yes")then
tdamsh:SetText(pscolkick)
end

--цифры таймера щит упал
psvalkastitsa=GetTime()-psvaltimebcastGT
psvalostalos=15-psvalkastitsa
psvalostalos=math.ceil(psvalostalos*10)/10
if(psgalochki[1]=="yes")then
if math.ceil(psvalostalos)==psvalostalos then
tdamsh2:SetText(psvalostalos..".0 / 15.0")
else
tdamsh2:SetText(psvalostalos.." / 15.0")
end
end

--рисунок1
psvelcastbar:SetWidth(psvalkastitsa*(PScolishieldmini:GetWidth()-8)/15)

--рисунок2
psvelshieldbar:SetWidth(PScolishieldmini:GetWidth()-8)



else -- ЕСТЬ ИЛИ НЕТУ ЩИТ


--цифры щита
if(psgalochki[2]=="yes")then
psstavtochku(psshieldamount-psdamagvalkyes)
tdamsh:SetText(psstinga2)
end


--цифры таймера
psvalkastitsa=GetTime()-psvaltimebcastGT
psvalostalos=15-psvalkastitsa
psvalostalos=psvalostalos*10
psvalostalos=math.ceil(psvalostalos)
psvalostalos=psvalostalos/10
if(psgalochki[1]=="yes")then
if math.ceil(psvalostalos)==psvalostalos then
tdamsh2:SetText(psvalostalos..".0 / 15.0")
else
tdamsh2:SetText(psvalostalos.." / 15.0")
end
end


--рисунок1
psvelcastbar:SetWidth(psvalkastitsa*(PScolishieldmini:GetWidth()-8)/15)

--рисунок2

if psdamagvalkyes==0 then
psvelshieldbar:SetWidth(0.01)
else
psvelshieldbar:SetWidth(psdamagvalkyes*(PScolishieldmini:GetWidth()-8)/psshieldamount)
end


--цвет
if psvelshieldbar:GetWidth()>psvelcastbar:GetWidth() then
psvelshieldbar.texture:SetAllPoints(psvelshieldbar)
psvelshieldbar.texture:SetTexture(0, 1, 0, 0.3)
else
psvelshieldbar.texture:SetAllPoints(psvelshieldbar)
psvelshieldbar.texture:SetTexture(1, 0, 0, 0.3)
end




end

if psvelcastbar:GetWidth()>((PScolishieldmini:GetWidth()-8)+PScolishieldmini:GetWidth()*0.1) then
psshieldon=0
PScolishieldmini:Hide()
psvelcastbar:Hide()
psvelshieldbar:Hide()
end

end --иф щит есть (валькирии)


--ДЖАРАКСУС

if psjxshieldon==1 then



--цифры щита
if(psgalochki[2]=="yes")then
psstavtochku(psshieldamount-psdamagvalkyes)
tdamsh:SetText(psstinga2)
end

--цифры таймера
psvalkastitsa=GetTime()-psvaltimebcastGT
psvalostalos=psjxshieldtime-psvalkastitsa
psvalostalos=psvalostalos*10
psvalostalos=math.ceil(psvalostalos)
psvalostalos=psvalostalos/10
if(psgalochki[1]=="yes")then
if math.ceil(psvalostalos)==psvalostalos then
tdamsh2:SetText(psvalostalos..".0 / "..psjxshieldtime..".0")
else
tdamsh2:SetText(psvalostalos.." / "..psjxshieldtime..".0")
end
end


--рисунок1
psvelcastbar:SetWidth(psvalkastitsa*(PScolishieldmini:GetWidth()-8)/psjxshieldtime)

--рисунок2
if psdamagvalkyes==0 then
psvelshieldbar:SetWidth(0.01)
else
psvelshieldbar:SetWidth(psdamagvalkyes*(PScolishieldmini:GetWidth()-8)/psshieldamount)
end

--цвет
if psvelshieldbar:GetWidth()>psvelcastbar:GetWidth() then
psvelshieldbar.texture:SetAllPoints(psvelshieldbar)
psvelshieldbar.texture:SetTexture(0, 1, 0, 0.3)
else
psvelshieldbar.texture:SetAllPoints(psvelshieldbar)
psvelshieldbar.texture:SetTexture(1, 0, 0, 0.3)
end


if psvelcastbar:GetWidth()>((PScolishieldmini:GetWidth()-8)+PScolishieldmini:GetWidth()*0.1) then
psjxshieldon=0
PScolishieldmini:Hide()
psvelcastbar:Hide()
psvelshieldbar:Hide()
end



end --конец джараксуса


if psvalnextshtime==0 then else
if GetTime()>psvalnextshtime then
psvalnextshtime=0
--анонс


if (twinspart) then
	if (wherereporttwins=="raid" and IsRaidOfficer()==1) then
pszapuskanonsa("raid_warning", psvalannouncenextabsh)
	else
pszapuskanonsa(wherereporttwins, psvalannouncenextabsh)
	end
end

end
end --конец анонса валькирий


--ПРОВЕРКА ТАРГЕТОВ РЕЙДА!

if psshieldon==1 and pstwtimenow>pscolnexttargchecktime then
pscolnexttargchecktime=pstwtimenow+0.1
for i=1,#pstwraidroster do
	if pstwtimeswitch[i]=="--" then
			if UnitName(pstwraidroster[i].."-target")==psvalbitnada then
				if twinspart4 then
		local pstwdebcheck=GetSpellInfo(67178)
		if psvalbitnada==pscotwinsvalkyr2 then pstwdebcheck=GetSpellInfo(67224) end
		if UnitDebuff(pstwraidroster[i], pstwdebcheck) then
		--считаем время
		local psswichspeed=math.ceil((GetTime()-psvaltimebcastGT)*10)/10
		pstwtimeswitch[i]=psswichspeed
		end
				else
				--считаем время
				local psswichspeed=math.ceil((GetTime()-psvaltimebcastGT)*10)/10
				pstwtimeswitch[i]=psswichspeed
				end
			end
	end
end



end --конец проверки таргетов

--проверка таргетов у тех кто бил нужную, на 1,2,3,4 сек

if psshieldon==1 and pstwtimenow>pscolnexttargcheck0 and psvaltimebcastGT>pstwtimenow-3.5 then
pscolnexttargcheck0e=pstwtimenow+1
for i=1,#pstwraidroster do
	if pstwtimeswitch[i]==0 then
			if UnitName(pstwraidroster[i].."-target")==psvalbitnada then
				if twinspart4 then
		local pstwdebcheck=GetSpellInfo(67178)
		if psvalbitnada==pscotwinsvalkyr2 then pstwdebcheck=GetSpellInfo(67224) end
		if UnitDebuff(pstwraidroster[i], pstwdebcheck)==nil then
		pstwtimeswitch[i]="--"
		end
				end

			else
		pstwtimeswitch[i]="--"
			end
	end
end


end --конец проверки таргетов2


end



function psfColiseumonevent()


if event == "PLAYER_REGEN_DISABLED" then
if psbilresnut==1 then
else
--обнулять все данные при начале боя тут:

	twinboyinterr=0
	jaraxusinterr=0
	psdamagvalkyes=0
	psvalbitnada="0"
	psnoobibiyut="0"
	psshieldon=0
	psjxshieldon=0
	pstttest=0
	psschitupal=0
	psfirsteventshield=0
	psjxpausareport=0
	psjxpausareport2=0
	table.wipe(psvaltable)
	psvalnextshtime=0
if PScolishieldmini:IsShown() then
PScolishieldmini:Hide()
psvelcastbar:Hide()
psvelshieldbar:Hide()
end

end
end

if event == "PLAYER_REGEN_ENABLED" then

	if(wasornotwins) then twinboyinterr=1 end
	if(wasornojara) then jaraxusinterr=1 end

end

if event == "ADDON_LOADED" then
if arg1=="PhoenixStyleMod_Coliseum" then

	if 3-pscoltekver>0 then
		if pscoltekver>0 then
print ("|cff99ffffPhoenixStyle|r - "..pscolnewveranonce1)
		end
local psvercoll=(3-pscoltekver)
if psvercoll>3 then psvercoll=3 end

while psvercoll>0 do
		if pscoltekver>0 then
out ("|cff99ffffPhoenixStyle|r - "..pscolnewveranoncet[psvercoll])
		end
psvercoll=psvercoll-1
end
	end

pscoltekver=3 --ТЕК ВЕРСИЯ!!! и так выше изменить цифру что отнимаем, всего 3 раза
end
end


if event == "ZONE_CHANGED_NEW_AREA" then

PScolishieldmini:Hide()
psvelcastbar:Hide()
psvelshieldbar:Hide()
psvalnextshtime=0

--твины
if (twinboyinterr==1) then
psftwinsafterf()
psftwinsrezetall()
end

--джара
if (jaraxusinterr==1) then
psfjaraxafterf()
psfjaraxrezetall()
end


if GetRealZoneText()==pszonecoliseum then
PhoenixStyleMod_Coliseum:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
PhoenixStyleMod_Coliseum:RegisterEvent("PLAYER_TARGET_CHANGED")
else
PhoenixStyleMod_Coliseum:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
PhoenixStyleMod_Coliseum:UnregisterEvent("PLAYER_TARGET_CHANGED")
end

end


if event == "PLAYER_TARGET_CHANGED" and twvalboss1==nil then
if psshieldon==1 and psgalochki[3]=="yes" then
if UnitName("target")==nil then
--красный
tdamsh3:SetText("|cffff0000"..psvalbitnada.."|r")
elseif UnitName("target")==psvalbitnada then
--зеленый
tdamsh3:SetText("|cff00ff00"..psvalbitnada.."|r")
else
--красный
tdamsh3:SetText("|cffff0000"..psvalbitnada.."|r")
end
end
end


if GetNumRaidMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

--твины
if (twinboyinterr==1) then
if(timetocheck==0) then timetocheck=arg1+5
elseif(arg7 == pscotwinsvalkyr or arg7 == pscotwinsvalkyr2) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psftwinsafterf()
psftwinsrezetall()
end
end

--джара
if (jaraxusinterr==1) then
if(timetocheck==0) then timetocheck=arg1+5
elseif(arg7 == pscojaraboss or arg4 == pscojaraboss) then timetocheck=arg1+5
elseif(arg1>timetocheck)then
psfjaraxafterf()
psfjaraxrezetall()
end
end


if (arg9 == 67173 or arg9 == 65808 or arg9 == 67172 or arg9 == 67174 or arg9 == 67239 or arg9 == 67238 or arg9 == 65795 or arg9 == 67240) then
if arg2 == "SPELL_DAMAGE" then
psftwinseat()
end

if arg2 == "SPELL_MISSED" then
psftwinseat2()
end
end

--звери
if arg9 == 66734 and arg2 == "SPELL_DAMAGE" then
zverinoobreport()
end

if (twinspart) then


--проверка 4 и 8 действия
if arg2=="SPELL_CAST_START" and (arg9==67208 or arg9==66046 or arg9==67206 or arg9==67207) then
psvaladdability(3)
end

if arg2=="SPELL_CAST_START" and (arg9==67184 or arg9==66058 or arg9==67182 or arg9==67183) then
psvaladdability(4)
end

if arg2=="SPELL_CAST_START" and (arg9==67305 or arg9==65875 or arg9==67303 or arg9==67304) then
psvaladdability(1)
end

if arg2=="SPELL_CAST_START" and (arg9==65876 or arg9==67306 or arg9==67307 or arg9==67308) then
psvaladdability(2)
end





--интерапт, валькирии
if (arg12==67303 or arg12==65875 or arg12==65876 or arg12==67304 or arg12==67305 or arg12==67306 or arg12==67307 or arg12==67308) then
if arg2=="SPELL_INTERRUPT" and psshieldon==1 then
psshieldon=0
psschitupal=0
psvalskokaostalos=arg1-psvaltimebegincast
psvalskokaostalos=math.ceil(psvalskokaostalos*100)/100
psvalskokaostalos=15-psvalskokaostalos
psvalskokaostalos=math.ceil(psvalskokaostalos*100)/100

if pstttest==0 then
--вывод в окно
psfcoltwinsinfoout(1, arg4, psvalskokaostalos)
if (twinspart3) then
pszapuskanonsa(wherereporttwins, "{rt1}"..arg4.." "..pscoltwinshield1.." "..psvalskokaostalos.." "..pscoltwinshield2)
strochkadamageout="{rt7}"..pscoltwinshield5
reportfromtridamagetables(wherereporttwins,6,1)

if twinspart4 then
pszapuskanonsa(wherereporttwins, "{rt2}"..pscolvalchntxt2)
else
pszapuskanonsa(wherereporttwins, "{rt2}"..pscolvalchntxt1)
end

reportfromtwodamagetablestwin(wherereporttwins)
end
pstttest=1
end
table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)
table.wipe(psdamagename2)
table.wipe(psdamagevalue2)
table.wipe(pstwraidroster)
table.wipe(pstwtimeswitch)
psdamagvalkyes=0
if twvalboss1==nil then
PScolishieldmini:Hide()
psvelcastbar:Hide()
psvelshieldbar:Hide()
tdamsh3:SetText(" ")
end
end

end



--отслеживание каста!
if (arg9==67303 or arg9==65875 or arg9==65876 or arg9==67304 or arg9==67305 or arg9==67306 or arg9==67307 or arg9==67308) then

if arg2=="SPELL_CAST_START" then
if (psdamagename==nil or psdamagename=={}) then psdamagename = {} end
if (psdamagevalue==nil or psdamagevalue=={}) then psdamagevalue = {} end
if (psdamageraz==nil or psdamageraz=={}) then psdamageraz = {} end
if (psdamagename2==nil or psdamagename2=={}) then psdamagename2 = {} end
if (psdamagevalue2==nil or psdamagevalue2=={}) then psdamagevalue2 = {} end
table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)
table.wipe(psdamagename2)
table.wipe(psdamagevalue2)
pstttest=0
psdamagvalkyes=0
psschitupal=0
psvaltimebegincast=arg1
psvaltimebcastGT=GetTime()
if twvalboss1==nil then
PSF_colshieldmini()
	if psgalochki[3]=="yes" then

if UnitName("target")==nil then
--красный
tdamsh3:SetText("|cffff0000"..arg4.."|r")
elseif UnitName("target")==arg4 then
--зеленый
tdamsh3:SetText("|cff00ff00"..arg4.."|r")
else
--красный
tdamsh3:SetText("|cffff0000"..arg4.."|r")
end
	else
	tdamsh3:SetText("")
	end
end

pstwsozdtabltime(arg4)

psshieldon=1

end


if arg2=="SPELL_HEAL" and psshieldon==1 then
psshieldon=0
psschitupal=0
local psschitaostalos=psshieldamount-psdamagvalkyes
if pstttest==0 then
if psschitaostalos<0 then psschitaostalos=0 end
--вывод в окно
psfcoltwinsinfoout(2, psschitaostalos)
if (twinspart3) then
pszapuskanonsa(wherereporttwins, "{rt8}"..pscoltwinshield3.." "..psschitaostalos.." "..pscoltwinshield4)
end
pstttest=1
end
if (twinspart3 and thisaddononoff) then
strochkadamageout="{rt7}"..pscoltwinshield5
reportfromtridamagetables(wherereporttwins,6,1)

if twinspart4 then
pszapuskanonsa(wherereporttwins, "{rt2}"..pscolvalchntxt2)
else
pszapuskanonsa(wherereporttwins, "{rt2}"..pscolvalchntxt1)
end

reportfromtwodamagetablestwin(wherereporttwins)
end
table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)
table.wipe(psdamagename2)
table.wipe(psdamagevalue2)
table.wipe(pstwraidroster)
table.wipe(pstwtimeswitch)
psdamagvalkyes=0
if twvalboss1==nil then
tdamsh3:SetText("")
PScolishieldmini:Hide()
psvelcastbar:Hide()
psvelshieldbar:Hide()
end
end


end --конец арг9 каста

--Отслеживание какой щит!
if (arg9==67258 or arg9==67256 or arg9==65874 or arg9==67257) then
if arg2=="SPELL_AURA_APPLIED" then
psvaladdability(1)
psvalbitnada=arg4
psschitupal=0
psnoobibiyut=pscotwinsvalkyr
if (arg9==67258) then psshieldamount=1200000 end
if (arg9==67256) then psshieldamount=700000 end
if (arg9==65874) then psshieldamount=175000 end
if (arg9==67257) then psshieldamount=300000 end
end
if arg2=="SPELL_AURA_REMOVED" then
psschitupal=1
end
end

if (arg9==67261 or arg9==67259 or arg9==65858 or arg9==67260) then
if arg2=="SPELL_AURA_APPLIED" then
psvaladdability(2)
psvalbitnada=arg4
psschitupal=0
psnoobibiyut=pscotwinsvalkyr2
if (arg9==67261) then psshieldamount=1200000 end
if (arg9==67259) then psshieldamount=700000 end
if (arg9==65858) then psshieldamount=175000 end
if (arg9==67260) then psshieldamount=300000 end
end
if arg2=="SPELL_AURA_REMOVED" then
psschitupal=1
end
end


--Счет урона в НУЖНУЮ тетку
if(psshieldon==1 and arg7==psvalbitnada) then
if arg2=="SPELL_PERIODIC_MISSED" then
if arg12=="ABSORB" then
psdamagvalkyes=psdamagvalkyes+arg13
psunitisplayer(arg3,arg4)
if psunitplayertrue then
addtotwodamagetables(arg4, arg13)
psdamagetwotablsort1()
end

end
end
if arg2=="SPELL_MISSED" then
if arg12=="ABSORB" then
psdamagvalkyes=psdamagvalkyes+arg13
psunitisplayer(arg3,arg4)
if psunitplayertrue then
addtotwodamagetables(arg4, arg13)
psdamagetwotablsort1()
end

end
end
--учитывать ретриков под гневом
if arg2=="SPELL_DAMAGE" then
if arg17 and arg17>0 then
psdamagvalkyes=psdamagvalkyes+arg17
psunitisplayer(arg3,arg4)
if psunitplayertrue then
addtotwodamagetables(arg4, arg17)
psdamagetwotablsort1()
end

end
end
if arg2=="SWING_DAMAGE" then
if arg14 and arg14>0 then
psdamagvalkyes=psdamagvalkyes+arg14
psunitisplayer(arg3,arg4)
if psunitplayertrue then
addtotwodamagetables(arg4, arg14)
psdamagetwotablsort1()
end

end
end
if arg2=="RANGE_MISSED" then
if arg12=="ABSORB" then
psdamagvalkyes=psdamagvalkyes+arg13
psunitisplayer(arg3,arg4)
if psunitplayertrue then
addtotwodamagetables(arg4, arg13)
psdamagetwotablsort1()
end

end
end
if arg2=="SWING_MISSED" then
if arg9=="ABSORB" then
psdamagvalkyes=psdamagvalkyes+arg10
psunitisplayer(arg3,arg4)
if psunitplayertrue then
addtotwodamagetables(arg4, arg10)
psdamagetwotablsort1()
end

end
end

end

--СЧЕТ УРОНА НЕ В ТУ ТЕТКУ
if(psshieldon==1 and arg7==psnoobibiyut) then
if arg1>psvaltimebegincast+1.8 then
if arg2=="SPELL_DAMAGE" then
if arg9==58735 or arg9==10444 or arg9==1680 or arg9==44949 or arg9==55262 or arg9==25504 or arg9==57975 or arg9==47520 or arg9==55362 or arg9==57965 or arg9==51690 or arg9==53190 or arg9==48480 or arg9==50590 then else
if arg12==nil then else
psunitisplayer(arg3,arg4)
if psunitplayertrue then
addtotridamagetables(arg4, arg12,1)
psdamagetritablsort1()
end
end
end
end
if arg2=="RANGE_DAMAGE" then
if arg12==nil then else
psunitisplayer(arg3,arg4)
if psunitplayertrue then
addtotridamagetables(arg4, arg12,1)
psdamagetritablsort1()
end
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
end--конец валькирий


--смерть валькирии при активном щите
if arg2=="UNIT_DIED" and arg7==pscotwinsvalkyr and psshieldon==1 then
psshieldon=0
PScolishieldmini:Hide()
psvelcastbar:Hide()
psvelshieldbar:Hide()
end


--ДЖАРАКСУС

if jaraxpart then

if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12 and arg12=="ABSORB")) and (arg9==68718 or arg9==66496 or arg9==68716 or arg9==68717) then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
wasornojara=1
addtotwotables(arg7)
vezaxsort1()
end
end


--вешает дебафф
if arg2=="SPELL_AURA_APPLIED" and (arg9==67051 or arg9==66237 or arg9==67049 or arg9==67050) then

if arg9==67051 then
psshieldamount=85000
psjxshieldtime=12
end
if arg9==66237 then
psshieldamount=30000
psjxshieldtime=15
end
if arg9==67049 then
psshieldamount=60000
psjxshieldtime=15
end
if arg9==67050 then
psshieldamount=40000
psjxshieldtime=12
end

psvaltimebcastGT=GetTime()
psjxshieldon=1
wasornojara=1
psdamagvalkyes=0
psvalbitnada=arg7
if (psdamagename2==nil or psdamagename2=={}) then psdamagename2 = {} end
if (psdamagevalue2==nil or psdamagevalue2=={}) then psdamagevalue2 = {} end
table.wipe(psdamagename2)
table.wipe(psdamagevalue2)
PSF_colshieldmini()
if psgalochki[3]=="yes" then tdamsh3:SetText(arg7) else tdamsh3:SetText("") end

end



--сняли дебафф
if arg2=="SPELL_AURA_REMOVED" and psjxshieldon==1 and (arg9==67051 or arg9==66237 or arg9==67049 or arg9==67050) then
psjxpausareport=arg1+0.5
psjxpausareport2=1
psjxshieldon=0
tdamsh3:SetText("")
PScolishieldmini:Hide()
psvelcastbar:Hide()
psvelshieldbar:Hide()

end



--считаем хил
if(arg7==psvalbitnada and (psjxshieldon==1 or psjxpausareport2==1)) then


if arg2=="SPELL_HEAL" then
psdamagvalkyes=psdamagvalkyes+arg14
psunitisplayer(arg3,arg4)
if psunitplayertrue and arg14>0 then
addtotwodamagetables(arg4, arg14)
psdamagetwotablsort1()
addtotwodamagetables3(arg4, arg14)
psdamagetwotablsort3()
end
end

if arg2=="SPELL_PERIODIC_HEAL" then
psdamagvalkyes=psdamagvalkyes+arg14
psunitisplayer(arg3,arg4)
if psunitplayertrue and arg14>0 then
addtotwodamagetables(arg4, arg14)
psdamagetwotablsort1()
addtotwodamagetables3(arg4, arg14)
psdamagetwotablsort3()
end
end

end


--пауза и репорт
if psjxpausareport2==1 then

if arg2=="SPELL_AURA_APPLIED" and (arg9==67061 or arg9==66242 or arg9==67059 or arg9==67060) then
psjxpausareport2=0
psjxpausareport=0

--РЕПОРТ ФЕЙЛА
if (jaraxpart) then
pszapuskanonsa(wherereportjarax, "{rt8}"..pscoljaraloc1.." "..psvalbitnada.." "..pscolwasnthealed.."!")
end
strochkadamageout="{rt2}"..pscolhealili..": "
reportfromtwodamagetables(wherereportjarax)
table.wipe(psdamagename2)
table.wipe(psdamagevalue2)

end

if arg1>psjxpausareport then
--НОРМАЛ РЕПОРТ
psjxpausareport2=0
psjxpausareport=0

if (thisaddononoff and jaraxpart2 and jaraxpart) then

strochkadamageout="{rt2}"..pscoljaraloc2.." ("..psvalbitnada..") "..pscolhealili2..": "
reportfromtwodamagetables(wherereportjarax, 1, 2999)
table.wipe(psdamagename2)
table.wipe(psdamagevalue2)
end



end


end


end --джараксуса




end --колизея
end --КОНЕЦ ОНЕВЕНТ

function PSF_closeallprColiseum()
PSFmain7:Hide()
PSFmainshieldinfo:Hide()
PSFmainanub:Hide()
end


function PSF_buttonkolizei2()
PSF_closeallpr()
PSFmain7:Show()
framewasinuse5=1
openmenutwins()
openmenuzveri()
openmenujarax()
psfcoldraw()
if(twinspart)then PSFmain7_CheckButton201:SetChecked() else pscolbosstxt2:SetText("|cffff0000"..pscoliboss1.."|r") PSFmain7_CheckButton201:SetChecked(false) end
if(zveripart)then PSFmain7_CheckButton202:SetChecked() else pscolbosstxt1:SetText("|cffff0000"..pscoliboss2.."|r") PSFmain7_CheckButton202:SetChecked(false) end
if(jaraxpart)then PSFmain7_CheckButton203:SetChecked() else pscolbosstxt3:SetText("|cffff0000"..pscoliboss3.."|r") PSFmain7_CheckButton203:SetChecked(false) end
if(twinspart2)then PSFmain7_CheckButton212:SetChecked(false) else PSFmain7_CheckButton212:SetChecked() end
if(jaraxpart2)then PSFmain7_CheckButton213:SetChecked(false) else PSFmain7_CheckButton213:SetChecked() end
if(twinspart3)then PSFmain7_CheckButton2122:SetChecked() else PSFmain7_CheckButton2122:SetChecked(false) end
if(twinspart4)then PSFmain7_CheckButton2123:SetChecked() else PSFmain7_CheckButton2123:SetChecked(false) end

end

function PSFizmcoli1()
	if (PSFmain7_CheckButton201:GetChecked()) then
	twinspart=true pscolbosstxt2:SetText("|cff00ff00"..pscoliboss1.."|r")
	else
	twinspart=false pscolbosstxt2:SetText("|cffff0000"..pscoliboss1.."|r")
end end
function PSFizmcoli2()
	if (PSFmain7_CheckButton202:GetChecked()) then
	zveripart=true pscolbosstxt1:SetText("|cff00ff00"..pscoliboss2.."|r")
	else
	zveripart=false pscolbosstxt1:SetText("|cffff0000"..pscoliboss2.."|r")
end end
function PSFizmcoli3()
	if (PSFmain7_CheckButton203:GetChecked()) then
	jaraxpart=true pscolbosstxt3:SetText("|cff00ff00"..pscoliboss3.."|r")
	else
	jaraxpart=false pscolbosstxt3:SetText("|cffff0000"..pscoliboss3.."|r")
end end
function PSFizmcoli12()
	if (PSFmain7_CheckButton212:GetChecked()) then
	twinspart2=false
	else
	twinspart2=true
end end
function PSFizmcoli13()
	if (PSFmain7_CheckButton213:GetChecked()) then
	jaraxpart2=false
	else
	jaraxpart2=true
end end

function openmenutwins()
if not DropDownMenuTwins then
CreateFrame("Frame", "DropDownMenuTwins", PSFmain7, "UIDropDownMenuTemplate")
end
pscreatedropmcol(DropDownMenuTwins,"TOPLEFT",130,-80,wherereporttwins,1)
end

function openmenujarax()
if not DropDownMenujarax then
CreateFrame("Frame", "DropDownMenujarax", PSFmain7, "UIDropDownMenuTemplate")
end
pscreatedropmcol(DropDownMenujarax,"TOPLEFT",130,-179,wherereportjarax,2)
end

function openmenuzveri()
if not DropDownMenuzveri then
CreateFrame("Frame", "DropDownMenuzveri", PSFmain7, "UIDropDownMenuTemplate")
end
pscreatedropmcol(DropDownMenuzveri,"TOPLEFT",130,-31,wherereportzveri,3)
end


function PSF_colshieldmini()
PScolishieldmini:Show()
psvelcastbar:Show()
psvelshieldbar:Show()
if (psfcolishieldspamno==nil) then

--ВРЕМЕННО ДЛЯ СМЕНЫ ВЕРСИИ
if #psgalochki == 2 then
table.insert(psgalochki, "yes")
if pswelheight<80 then pswelheight=80 end
end

psvelshieldbar.texture = psvelshieldbar:CreateTexture()
tdamsh = PScolishieldmini:CreateFontString("pscolshield")
tdamsh:SetFont(GameFontNormal:GetFont(), 22)
tdamsh:SetWidth(120)
tdamsh:SetHeight(15)
if(psgalochki[2]=="yes")then
tdamsh:SetText(pscolshield)
end
tdamsh:SetJustifyH("RIGHT")
PScolishieldmini.texture = tdamsh
	if(psgalochki[3]=="yes")then
tdamsh:SetPoint("BOTTOMLEFT",-5,34)
	else
tdamsh:SetPoint("BOTTOMLEFT",-5,9)
	end



tdamsh2 = PScolishieldmini:CreateFontString("pscolshield")
tdamsh2:SetFont(GameFontNormal:GetFont(), 15)
tdamsh2:SetWidth(110)
tdamsh2:SetHeight(15)
if(psgalochki[1]=="yes")then
tdamsh2:SetText(pscolcast11)
end
tdamsh2:SetJustifyH("RIGHT")
PScolishieldmini.texture = tdamsh2
tdamsh2:SetPoint("TOPLEFT",0,-6)



tdamsh3 = PScolishieldmini:CreateFontString("pscolnick")
tdamsh3:SetFont(GameFontNormal:GetFont(), 17)
tdamsh3:SetWidth(PScolishieldmini:GetWidth()-15)
tdamsh3:SetHeight(15)
if(psgalochki[3]=="yes")then
tdamsh3:SetText(pscolnick)
end
tdamsh3:SetJustifyH("LEFT")
PScolishieldmini.texture = tdamsh3
tdamsh3:SetPoint("BOTTOMLEFT",8,9)


psfcolishieldspamno=1
end
pschangewidth()
end


function PSFifreportvalksheld()
if (PSFmain7_CheckButton2122:GetChecked()) then
	if(twinspart3)then else twinspart3=true end
else
	if(twinspart3)then twinspart3=false end
end
end

function PSFcheckportswitch()
if (PSFmain7_CheckButton2123:GetChecked()) then
	if(twinspart4)then else twinspart4=true end
else
	if(twinspart4)then twinspart4=false end
end
end


function pschangewidth()
PScolishieldmini:SetWidth(pswelwidth)
tdamsh3:SetWidth(PScolishieldmini:GetWidth()-15)

if psgalochki[1]=="no" then tdamsh2:SetText("") else tdamsh2:SetText(pscolcast11) end
if psgalochki[2]=="no" then tdamsh:SetText("") else tdamsh:SetText(pscolshield) end
if psgalochki[3]=="no" then tdamsh3:SetText("") else tdamsh3:SetText(pscolnick) end

	if(psgalochki[3]=="yes")then
tdamsh:SetPoint("BOTTOMLEFT",-5,34)
	else
tdamsh:SetPoint("BOTTOMLEFT",-5,9)
	end
PScolishieldmini:SetHeight(pswelheight)

		if(psgalochki[3]=="yes")then
	psvelcastbar:SetHeight((PScolishieldmini:GetHeight()-34)*(20/46))
	psvelshieldbar:SetHeight((PScolishieldmini:GetHeight()-34)*(26/46))
	psvelshieldbar:SetPoint("BOTTOMLEFT",4,29)
		else
	psvelcastbar:SetHeight((PScolishieldmini:GetHeight()-8)*(20/46))
	psvelshieldbar:SetHeight((PScolishieldmini:GetHeight()-8)*(26/46))
	psvelshieldbar:SetPoint("BOTTOMLEFT",4,4)
		end



if psshieldon==0 and psjxshieldon==0 then
psvelcastbar:SetWidth((PScolishieldmini:GetWidth()-8)-PScolishieldmini:GetWidth()*0.3)
psvelshieldbar:SetWidth(PScolishieldmini:GetWidth()-8)
end

end



function PSF_colshieldminiopen()
PSTwinValmenu:Show()
PSF_colshieldmini()


psvelcastbar:SetWidth((PScolishieldmini:GetWidth()-8)-PScolishieldmini:GetWidth()*0.3)
psvelshieldbar:SetWidth(PScolishieldmini:GetWidth()-8)

psvelshieldbar.texture:SetAllPoints(psvelshieldbar)
psvelshieldbar.texture:SetTexture(0, 1, 0, 0.3)



if (pstwcolishieldspamno2==nil) then
pstwdamsh3 = PSTwinValmenu:CreateFontString("")
pstwdamsh3:SetFont(GameFontNormal:GetFont(), 11)
pstwdamsh3:SetWidth(180)
pstwdamsh3:SetHeight(15)
pstwdamsh3:SetText("")
pstwdamsh3:SetJustifyH("TOP")
pstwdamsh3:SetPoint("TOP",0,-96)


pstwdamsh4 = PSTwinValmenu:CreateFontString("")
pstwdamsh4:SetFont(GameFontNormal:GetFont(), 11)
pstwdamsh4:SetWidth(180)
pstwdamsh4:SetHeight(15)
pstwdamsh4:SetText("")
pstwdamsh4:SetJustifyH("TOP")
pstwdamsh4:SetPoint("TOP",0,-156)

pstwcolishieldspamno2=1
end

pstwrelookmenu()

end


function PSTVgalka(nomersmeni)
if psgalochki[nomersmeni]=="yes" then psgalochki[nomersmeni]="no" else psgalochki[nomersmeni]="yes" end

pstwrelookmenu()
PSF_colshieldmini()
end


function PSTWdefault()
psgalochki={"yes",
"yes",
"yes"
}
pswelwidth = 150
pswelheight = 80
PSF_colshieldmini()
pstwrelookmenu()


		PScolishieldmini:ClearAllPoints()
		PScolishieldmini:SetPoint("CENTER",UIParent,"CENTER",-200,-75)
end

function pstwrelookmenu()
--перепроверяем галочки и прописываем все



if(psgalochki[1]=="yes")then PSTwinValmenu_CheckButton1:SetChecked() else PSTwinValmenu_CheckButton1:SetChecked(false) end
if(psgalochki[2]=="yes")then PSTwinValmenu_CheckButton2:SetChecked() else PSTwinValmenu_CheckButton2:SetChecked(false) end
if(psgalochki[3]=="yes")then PSTwinValmenu_CheckButton3:SetChecked() else PSTwinValmenu_CheckButton3:SetChecked(false) end

if PSTwinValmenu_CheckButton1:GetChecked()==nil and PSTwinValmenu_CheckButton2:GetChecked()==nil and PSTwinValmenu_CheckButton3:GetChecked()==nil then
pstwdamsh3:SetText("("..pstwbetween.." |cff00ff0030|r "..pstwand.." 999)")
pstwdamsh4:SetText("("..pstwbetween.." |cff00ff0030|r "..pstwand.." 999)")
elseif PSTwinValmenu_CheckButton1:GetChecked()==nil and PSTwinValmenu_CheckButton2:GetChecked()==nil then
pstwdamsh3:SetText("("..pstwbetween.." |cff00ff00110|r "..pstwand.." 999)")
pstwdamsh4:SetText("("..pstwbetween.." |cff00ff0050|r "..pstwand.." 999)")
if pswelwidth<110 then pswelwidth=110 end
if pswelheight<50 then pswelheight=50 end
elseif PSTwinValmenu_CheckButton3:GetChecked()==nil then
pstwdamsh3:SetText("("..pstwbetween.." |cffff0000150|r "..pstwand.." 999)")
pstwdamsh4:SetText("("..pstwbetween.." |cff00ff0050|r "..pstwand.." 999)")
if pswelwidth<150 then pswelwidth=150 end
if pswelheight<50 then pswelheight=50 end
else
pstwdamsh3:SetText("("..pstwbetween.." |cffff0000150|r "..pstwand.." 999)")
pstwdamsh4:SetText("("..pstwbetween.." |cffff000080|r "..pstwand.." 999)")
if pswelwidth<150 then pswelwidth=150 end
if pswelheight<80 then pswelheight=80 end
end

--едитбоксы
PSTwinValmenu_width1:SetText(pswelwidth)
PSTwinValmenu_heigh1:SetText(pswelheight)


end

function PSTwinValApply()
PScolishieldmini:Show()
psvelcastbar:Show()
psvelshieldbar:Show()
if PSTwinValmenu_width1:GetNumber()>29 and PSTwinValmenu_width1:GetNumber()<1000 then pswelwidth=PSTwinValmenu_width1:GetNumber() end
if PSTwinValmenu_heigh1:GetNumber()>29 and PSTwinValmenu_heigh1:GetNumber()<1000 then pswelheight=PSTwinValmenu_heigh1:GetNumber() end
pstwrelookmenu()
pschangewidth()
PSTwinValmenu_width1:ClearFocus()
PSTwinValmenu_heigh1:ClearFocus()
end


function psstavtochku(psstinga)

if string.len(psstinga)>6 then
psstinga2=string.sub(psstinga, 1, 1).."."..string.sub(psstinga, 2, 4).."."..string.sub(psstinga, 5)
elseif string.len(psstinga)>3 then
psstinga2=string.sub(psstinga, 1, string.len(psstinga)-3).."."..string.sub(psstinga, string.len(psstinga)-2)
else
psstinga2=psstinga
end

end

function PSF_colshieldinfoopen()
PSF_closeallpr()
PSFmainshieldinfo:Show()
openmenureportinfoshield()
end

--джара репорт
function psfjaraxafterf()
if(thisaddononoff and jaraxpart) then

strochkadamageout="{rt1} "..pscoljaraloc3..": "
reportfromtwodamagetables3(wherereportjarax, true, 7)

strochkavezcrash="{rt7} "..pscoljaraloc44
reportafterboitwotab(wherereportjarax, true, vezaxname, vezaxcrash, 1, 7)

end
end


function psfjaraxrezetall()
wasornojara=nil
timetocheck=0
jaraxusinterr=0
table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(psdamagename3)
table.wipe(psdamagevalue3)
end


function psvaladdability(nrabil)
bililine=0
for i,getcrash in ipairs(psvaltable) do 
if getcrash == nrabil then bililine=1 end
end
if(bililine==0)then
		if GetTime()>psvaltimetableadd then
		psvaltimetableadd=GetTime()+10
table.insert(psvaltable,nrabil)
	if #psvaltable==3 then
	psvalcheckandrep()
	end

	if #psvaltable==4 then
	table.wipe(psvaltable)
	end
		end
end
end


function psvalcheckandrep()
table.sort(psvaltable)
if psvaltable[1]==2 then
psvalannouncenextabsh="{rt6} "..pscolvalnxtabloc1.." - "..pscolvalnxtabloc2.."! "..pscolvalbeprepare.." >>"..pscotwinsvalkyr2.."<<"
psvalnextshtime=GetTime()+20
elseif psvaltable[2]==3 then
psvalannouncenextabsh="{rt6} "..pscolvalnxtabloc1.." - "..pscolvalnxtabloc3.."! "..pscolvalbeprepare.." >>"..pscotwinsvalkyr.."<<"
psvalnextshtime=GetTime()+20
end

end


function psfcoldraw()
if psfcoldraw1==nil then
psfcoldraw1=1

--вкл
local p=-39
for i=1,3 do
local t = PSFmain7:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",20,p)
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(psulvkl)
t:SetJustifyH("LEFT")
p=p-49
if i==2 then p=p-50 end
end

--канал чата
local p=-39
for i=1,3 do
local t = PSFmain7:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",70,p)
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(psulchatch)
t:SetJustifyH("LEFT")
p=p-49
if i==2 then p=p-50 end
end

pscolbosstxt1 = PSFmain7:CreateFontString()
pscolcreatbosstxt(pscolbosstxt1, 1, -19)
pscolbosstxt2 = PSFmain7:CreateFontString()
pscolcreatbosstxt(pscolbosstxt2, 2, -68)
pscolbosstxt3 = PSFmain7:CreateFontString()
pscolcreatbosstxt(pscolbosstxt3, 3, -167)


--описание
local pstabtodraw2={pscoliinfoboss2,pscoliinfoboss1,pscoliinfoboss3}
local p=-19
for i=1,3 do
local t = PSFmain7:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 10)
t:SetPoint("TOPLEFT",140,p)
t:SetTextColor(1,1,1,1)
t:SetText(pstabtodraw2[i])
t:SetJustifyH("LEFT")
p=p-49
if i==2 then p=p-50 end
end

--после боя
local pstabtodraw2={psulonlyattheendsharof,psulonlyattheendval2,pscolvalsmena,psulrepjara}
local p=-88
for i=1,4 do
if pstabtodraw2[i] then
local t = PSFmain7:CreateFontString()
	if GetLocale() == "deDE" then
t:SetFont(GameFontNormal:GetFont(), 10)
	else
t:SetFont(GameFontNormal:GetFont(), 12)
	end
t:SetPoint("TOPLEFT",275,p)
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(pstabtodraw2[i])
t:SetJustifyH("LEFT")
if i==1 or i==2 then p=p-25 else p=p-49 end
end
end

--рысочка
local p=-59
for i=1,3 do
local t = PSFmain7:CreateTexture(nil,"OVERLAY")
t:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Divider")
t:SetPoint("TOP",24,p)
t:SetWidth(250)
t:SetHeight(15)
p=p-49
if i==1 then p=p-50 end
end



end
end

function pscolcreatbosstxt(rt, i, p)
local pstabtodraw={pscoliboss2,pscoliboss1,pscoliboss3}
rt:SetFont(GameFontNormal:GetFont(), 12)
rt:SetPoint("TOPLEFT",20,p)
rt:SetText("|cff00ff00"..pstabtodraw[i].."|r")
rt:SetJustifyH("LEFT")
end

function pscreatedropmcol(aa,bb,cc,dd,ee,nn)
aa:ClearAllPoints()
aa:SetPoint(bb, cc, dd)
aa:Show()

local items = bigmenuchatlist

local function OnClick(self)
UIDropDownMenu_SetSelectedID(aa, self:GetID())

local oo=bigmenuchatlisten[self:GetID()]
if self:GetID()>8 then
oo=psfchatadd[self:GetID()-8]
else
oo=bigmenuchatlisten[self:GetID()]
end

if nn==1 then
wherereporttwins=oo
elseif nn==2 then
wherereportjarax=oo
elseif nn==3 then
wherereportzveri=oo
elseif nn==4 then
wherereportinfshield=oo
elseif nn==5 then
wherereportanub=oo
elseif nn==6 then
wherereportanub2=oo
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
if nn==1 then
wherereporttwins=ooo
elseif nn==2 then
wherereportjarax=ooo
elseif nn==3 then
wherereportzveri=ooo
elseif nn==4 then
wherereportinfshield=ooo
elseif nn==5 then
wherereportanub=ooo
elseif nn==6 then
wherereportanub2=ooo
end
bigma2num=1
	end


UIDropDownMenu_Initialize(aa, initialize)
UIDropDownMenu_SetWidth(aa, 85);
UIDropDownMenu_SetButtonWidth(aa, 100)
UIDropDownMenu_SetSelectedID(aa, bigma2num)
UIDropDownMenu_JustifyText(aa, "LEFT")
end


--создание таблиц времени и проверка таргетов всего рейда, +0.2 сек к след проверке

function pstwsozdtabltime(psboss)
if (pstwraidroster==nil or pstwraidroster=={}) then pstwraidroster = {} end
if (pstwtimeswitch==nil or pstwtimeswitch=={}) then pstwtimeswitch = {} end
table.wipe(pstwraidroster)
table.wipe(pstwtimeswitch)

local psgrups=5
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
psgrups=2
end

for i=1,GetNumRaidMembers() do local psname,pssubgroup = GetRaidRosterInfo(i)
	if pssubgroup <= psgrups then
table.insert(pstwraidroster,(GetRaidRosterInfo(i)))
		if UnitName(psname.."-target")==psboss then
		--таргет совпадает, проверяем дебаф
			if twinspart4 then
			--проверяем дебаф
				local pstwdebcheck=GetSpellInfo(67178)
				if psboss==pscotwinsvalkyr2 then pstwdebcheck=GetSpellInfo(67224) end
				if UnitDebuff(psname, pstwdebcheck)==nil then
				table.insert(pstwtimeswitch,"--")
				else
				table.insert(pstwtimeswitch,0)
				end
			else
			--откл, дебаф не проверять
			table.insert(pstwtimeswitch,0)
			end
		else
		--таргет фейл
		table.insert(pstwtimeswitch,"--")
		end
	end
end

--таблицы записаны, до след проверки 0.2 сек
pscolnexttargchecktime=GetTime()+0.2
pscolnexttargcheck0=GetTime()+1


end


function psfcolshopen12()
if twvalboss1 then
TWINVALKYRMFRAME_Command()
else
PSF_colshieldminiopen()
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..psattention.."|r "..pscoltwinvaladd)
end
end