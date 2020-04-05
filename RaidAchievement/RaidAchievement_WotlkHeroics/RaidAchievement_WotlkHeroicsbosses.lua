--общий для выполненого с 1 события
function whraachcompl(whranrach)
whraachdone1=nil
whramakeachlink(whranrach)
whrareportallok()
end



--общий для фейлов с 1 удара
function whrafailnoreason(whranrach, prichina)
if ramanyachon and raquantrepeatachtm==0 and raquantrepeatach>=raquantrepdone then
raquantrepdone=raquantrepdone+1
else
whraachdone1=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
whramakeachlink(whranrach)
whrareportfailnoreason(prichina)
end

--мой фейл
function whramyfail(whranrach)
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
whraachdone1=false
if raquantrepeatach==raquantrepdone-1 and raquantrepeatachtm==0 then
raquantrepdone=raquantrepdone+1
end
end
whramakeachlink(whranrach)
out(achlinnk.." |cffff0000"..pseatreb4.."|r"..ratemp)
end


function whramakeachlink(whraidboss)
achlinnk=GetAchievementLink(whraspisokach5[whraidboss])
end

function whrareportfailnoreason(prichina2)
local ratemp=""

if ramanyachon and raquantrepeatachtm==0 and raquantrepdone>2 then
ratemp=" #"..(raquantrepdone-1)
end

if ramanyachon and raquantrepeatachtm>0 and raquantrepdone>1 then
ratemp=" #"..raquantrepdone
end

	if prichina2==nil then
if(wherereportpartyach=="sebe" or (GetNumPartyMembers()==0 and wherereportpartyach=="party"))then
DEFAULT_CHAT_FRAME:AddMessage("- "..achlinnk.." |cffff0000"..pseatreb4.."|r"..ratemp)
else
razapuskanonsa(wherereportpartyach, "{rt8} "..achlinnk.." "..pseatreb4..ratemp)
end
	else
if(wherereportpartyach=="sebe" or (GetNumPartyMembers()==0 and wherereportpartyach=="party"))then
DEFAULT_CHAT_FRAME:AddMessage("- "..achlinnk.." |cffff0000"..pseatreb4.."|r ("..prichina2..")."..ratemp)
else
	if pseashowfailreas==true then
razapuskanonsa(wherereportpartyach, "{rt8} "..achlinnk.." "..pseatreb4.." ("..prichina2..")."..ratemp)
	else
razapuskanonsa(wherereportpartyach, "{rt8} "..achlinnk.." "..pseatreb4..ratemp)
	end
end
	end

end

function whrareportallok()
if(wherereportpartyach=="sebe" or (GetNumPartyMembers()==0 and wherereportpartyach=="party"))then
DEFAULT_CHAT_FRAME:AddMessage("- "..achlinnk.." "..pseatreb2)
else
razapuskanonsa(wherereportpartyach, "{rt1} "..achlinnk.." "..pseatreb2)
end
end