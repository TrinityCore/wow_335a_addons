function icramakeachlink(icraidboss)
if GetInstanceDifficulty()==1 or GetInstanceDifficulty()==3 then
achlinnk=GetAchievementLink(icraspisokach10[icraidboss])
end
if GetInstanceDifficulty()==2 or GetInstanceDifficulty()==4 then
achlinnk=GetAchievementLink(icraspisokach25[icraidboss])
end
end


--общий для фейлов с 1 удара
function icrafailnoreason(icranrach, prichina, quant)
if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
raachdone1=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
icramakeachlink(icranrach)
pseareportfailnoreason(prichina, quant)
end