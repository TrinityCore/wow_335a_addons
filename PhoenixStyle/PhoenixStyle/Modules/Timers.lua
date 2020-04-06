function psfpullbegin()

if(thisaddonwork)then
if(IsRaidOfficer()==1) then
if pspullactiv==0 then
if GetTime()>pstimeruraid then

pspullactiv=1
SendAddonMessage("PhoenixStyle-pull", timertopull, "RAID")

pstimermake(psattack, timertopull)

SendChatMessage(psattackin.." "..timertopull.." "..pssec, "raid_warning")

if timertopull > 17 then
howmuchwaitpull = timertopull-15
timertopull=15
elseif timertopull >13 then
howmuchwaitpull = timertopull-10
timertopull=10
elseif timertopull>9 then
howmuchwaitpull = timertopull-7
timertopull=7
elseif timertopull >6 then
howmuchwaitpull = timertopull-5
timertopull=5

elseif timertopull >5 then
howmuchwaitpull = timertopull-4
timertopull=4

elseif timertopull >4 then
howmuchwaitpull = timertopull-3
timertopull=3
elseif timertopull >0 then
howmuchwaitpull = 1
timertopull=timertopull-1
else



end --timertopull>17

else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrorcantdoanotherpullis)
timertopull=0
end--конец если запущен у кого в рейде таймер
else
psfcancelpull()
end--конец проверки на активный таймер
				else
				if (spammver==nil) then
				out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrornotofficer)
				spammvar=1
				end 
				end --конец проверки на промоут
else out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrorcantdo1)
end


end

function psfcancelpull()
SendChatMessage(psattack.." >>>"..pscanceled.."<<<", "raid_warning")
pspullactiv=0
timertopull=0
DelayTimepull=nil
pstimermake(psattack, timertopull+0.1,1)

end


function PSFbeginpullmenu()
if(thisaddonwork and IsRaidOfficer()==1 and pspullactiv==0)then
if(PSFmain5_timertopull1:GetNumber() > 1 and PSFmain5_timertopull1:GetNumber() < 21) then
timertopull=PSFmain5_timertopull1:GetNumber()
PSFmain5_timertopull1:ClearFocus()
PSF_buttonsaveexit()
psfpullbegin()
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pstimeerror1)
end
else
psfpullbegin()
end
end


function PSFbeginpereriv()
if(IsRaidOfficer()==1) then
if(PSFmain5_RadioButton251:GetChecked())then
--минут
if(PSFmain5_timerpereriv1:GetNumber() > 0 and PSFmain5_timerpereriv1:GetNumber() < 31) then
skokasecpereriv=PSFmain5_timerpereriv1:GetNumber()*60

SendChatMessage(pstimerstarts.." '"..pspereriv.."' -> "..PSFmain5_timerpereriv1:GetNumber().." "..psmin.." "..pstwobm, "raid_warning")

pstimermake(pspereriv2, skokasecpereriv)
PSFmain5_timerpereriv1:ClearFocus()


else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pstimeerror2)
end
else
--секунд

if(PSFmain5_timerpereriv1:GetNumber() > 29) then
skokasecpereriv=math.fmod (PSFmain5_timerpereriv1:GetNumber(), 60)
skokaminpereriv=math.floor (PSFmain5_timerpereriv1:GetNumber()/60)

SendChatMessage(pstimerstarts.." '"..pspereriv.."' -> "..skokaminpereriv.." "..psmin.." "..skokasecpereriv.." "..pssec.." "..pstwobm, "raid_warning")

pstimermake(pspereriv2, skokaminpereriv*60+skokasecpereriv)
PSFmain5_timerpereriv1:ClearFocus()

else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pstimeerror3)
end



end
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrornotofficer)
end
end


function PSFbegiowntimer()
nazvtimera=PSFmain5_timersvoi2:GetText()
if(nazvtimera=="")then nazvtimera=pstimernoname end
if(IsRaidOfficer()==1) then
if(PSFmain5_RadioButton253:GetChecked())then
--минут
if(PSFmain5_timersvoi1:GetNumber() > 0 and PSFmain5_timersvoi1:GetNumber() < 121) then
skokasecpereriv=PSFmain5_timersvoi1:GetNumber()*60

SendChatMessage(pstimerstarts.." '"..nazvtimera.."' -> "..PSFmain5_timersvoi1:GetNumber().." "..psmin.." "..pstwobm, "raid_warning")

pstimermake(nazvtimera, skokasecpereriv)
PSFmain5_timersvoi1:ClearFocus()
PSFmain5_timersvoi2:ClearFocus()


else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pstimeerror4)
end
else
--секунд

if(PSFmain5_timersvoi1:GetNumber() > 9) then
skokasecpereriv=math.fmod (PSFmain5_timersvoi1:GetNumber(), 60)
skokaminpereriv=math.floor (PSFmain5_timersvoi1:GetNumber()/60)


SendChatMessage(pstimerstarts.." '"..nazvtimera.."' -> "..skokaminpereriv.." "..psmin.." "..skokasecpereriv.." "..pssec.." "..pstwobm, "raid_warning")

pstimermake(nazvtimera, skokaminpereriv*60+skokasecpereriv)
PSFmain5_timersvoi1:ClearFocus()
PSFmain5_timersvoi2:ClearFocus()

else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pstimeerror5)
end



end
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrornotofficer)
end
end


function pstimermake(pstext, pstime,otmtimera)
local sender22=UnitName("player")

if(DBM)then
		DBM:CreatePizzaTimer(pstime, pstext, sender22)

else
		SendAddonMessage("DBMv4-Pizza", ("%s\t%s"):format(pstime, pstext), "RAID")
end

SendAddonMessage("BigWigs", "BWCustomBar "..pstime.." "..pstext, "RAID")
SendAddonMessage("DXE", "^1^SAlertsRaidBar^N"..pstime.."^S~`"..pstext.."^^", "RAID")
if otmtimera==nil then
SendAddonMessage("RW2","^1^SStartCommBar^F"..(math.random()*10).."^f-53^N"..pstime.."^S"..pstext.."^^", "RAID")
end

end


function psftimecrepol()
if pstttiimcr==nil then
pstttiimcr=1

--рысочка
local p={-46,-116,-166,-216}
for i=1,4 do
local t = PSFmain5:CreateTexture(nil,"OVERLAY")
t:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Divider")
t:SetPoint("TOP",20,p[i])
t:SetWidth(250)
t:SetHeight(15)
end

end
end