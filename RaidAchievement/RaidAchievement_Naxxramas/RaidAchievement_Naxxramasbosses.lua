--личный фейл
function nxramyfail(nxranrach)
local ratemp=""

if ramanyachon and raquantrepeatachtm==0 and raquantrepdone>2 then
ratemp=" #"..(raquantrepdone-1)
end

if ramanyachon and raquantrepeatachtm>0 and raquantrepdone>1 then
ratemp=" #"..raquantrepdone
end

if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
raachdone1=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
nxramakeachlink(nxranrach)
out(achlinnk.." |cffff0000"..pseatreb4.."|r"..ratemp)
end


function nxramakeachlink(nxraidboss)
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
achlinnk=GetAchievementLink(nxraspisokach10[nxraidboss])
end
if GetInstanceDifficulty()==2 or GetInstanceDifficulty()==4 then
achlinnk=GetAchievementLink(nxraspisokach25[nxraidboss])
end
end


--общий для выполненого с 1 события
function nxraachcompl(nxranrach)
raachdone1=nil
nxramakeachlink(nxranrach)
pseareportallok()
end

--общий для фейлов с 1 удара
function nxrafailnoreason(nxranrach, prichina)
if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
raachdone1=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
nxramakeachlink(nxranrach)
pseareportfailnoreason(prichina)
end