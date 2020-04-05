function pseaignis1()
if pseatime1==0 then pseatime1=arg1 else
psearex1=arg1-ratime1
if psearex1<4.8 then
pseamakeachlink(1)
pseareportallok()
raachdone1=nil
else
ratime1=arg1
end

end
end

function psearazor1()
ratime1=ratime1+1
if ratime1>2 then
raachdone1=nil
pseamakeachlink(2)
pseareportfailnoreason()
end
end

function pseakologarn1()
ratime1=ratime1+1
if ratime1==5 then
pseamakeachlink(5)
pseareportallok()
end
end

--общий для выполненого с 1 события
function pseaachcompl(pseanrach)
raachdone2=nil
pseamakeachlink(pseanrach)
pseareportallok()
end



--общий для фейлов с 1 удара
function pseafailnoreason(pseanrach, prichina,norezet)
if norezet==nil then
if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
raachdone1=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
end
pseamakeachlink(pseanrach)
pseareportfailnoreason(prichina)
end

--общий для фейлов с 1 удара но откл 2 ачив лист
function pseafailnoreason2(pseanrach, prichina)
if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
raachdone2=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
pseamakeachlink(pseanrach)
pseareportfailnoreason(prichina)
end

--общий для фейлов с 1 удара но откл 3 ачив лист
function pseafailnoreason3(pseanrach, prichina)
if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
raachdone3=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
pseamakeachlink(pseanrach)
pseareportfailnoreason(prichina)
end

function pseamakeachlink(pseaidboss)
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
achlinnk=GetAchievementLink(pseaspisokach10[pseaidboss])
end
if GetInstanceDifficulty()==2 or GetInstanceDifficulty()==4 then
achlinnk=GetAchievementLink(pseaspisokach25[pseaidboss])
end
end



function pseafailmimiron1(ktofail)
if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
raachdone1=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
pseamakeachlink(13)
pseareportfailmimi(pseamimifailloc1, ktofail)
end

function pseafailmimiron2(ktofail)
if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
raachdone2=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
pseamakeachlink(13)
pseareportfailmimi(pseamimifailloc2, ktofail)
end

function pseafailmimiron3(ktofail)
if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
raachdone3=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
pseamakeachlink(13)
pseareportfailmimi(pseamimifailloc3, ktofail)
end

function pseareportfailmimi(pseaotdamag, ktofail2)
local ratemp=""

if ramanyachon and raquantrepeatachtm==0 and raquantrepdone>2 then
ratemp=" #"..(raquantrepdone-1)
end

if ramanyachon and raquantrepeatachtm>0 and raquantrepdone>1 then
ratemp=" #"..raquantrepdone
end

if (wherereportraidach=="sebe") then
DEFAULT_CHAT_FRAME:AddMessage("- "..pseaotdamag.." "..achlinnk.." "..pseamimifailloc5.." ("..ktofail2..")."..ratemp)
else
	if pseashowfailreas==true then
if IsRaidOfficer()==nil and wherereportraidach=="raid_warning" then
razapuskanonsa("raid", "{rt8} "..pseaotdamag.." "..achlinnk.." "..pseamimifailloc5.." ("..ktofail2..")."..ratemp)
else
razapuskanonsa(wherereportraidach, "{rt8} "..pseaotdamag.." "..achlinnk.." "..pseamimifailloc5.." ("..ktofail2..")."..ratemp)
end
	else
if IsRaidOfficer()==nil and wherereportraidach=="raid_warning" then
razapuskanonsa("raid", "{rt8} "..pseaotdamag.." "..achlinnk.." "..pseamimifailloc5..ratemp)
else
razapuskanonsa(wherereportraidach, "{rt8} "..pseaotdamag.." "..achlinnk.." "..pseamimifailloc5..ratemp)
end
	end
end
end