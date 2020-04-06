function icclananoob1()
if psbossblock==nil then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
psiccschet=1
psiccschet2=0
psiccschet3=0
wasornolana=1
psicclalanames=""
end
end
end


function icclananoob2()
if psiccschet==1 then
psiccschet2=psiccschet2+1
psiccschet3=GetTime()
if string.len(psicclalanames)>1 then psicclalanames=psicclalanames..", " end
psicclalanames=psicclalanames..arg7

end
end


function icclananoob3()
psiccschet=0
psiccschet2=psiccschet2-1

if psiccschet2==0 and psiccschet3>0 then
if psiccbonetime==nil then psiccbonetime={1000,"0",0,"0"} end

if psbossblock==nil then
local bonekilled=GetTime()-psiccschet3
	if bonekilled<psiccbonetime[1] then
	psiccbonetime[1]=bonekilled
	psiccbonetime[2]=psicclalanames
	end
	if bonekilled>psiccbonetime[3] then
	psiccbonetime[3]=bonekilled
	psiccbonetime[4]=psicclalanames
	end

	if(psicgalochki[10][1]==1 and psicgalochki[10][3]==1)then
	bonekilled=math.ceil(bonekilled*10)/10
	pszapuskanonsa(whererepiccchat[psicchatchoose[10][3]], "{rt7}"..psiccfailtxt92.." "..bonekilled.." "..pssec.." ("..psicclalanames..").")
	end
end

psicclalanames=nil

end
end

function psficclananoobff()
if psbossblock==nil then

psunitisplayer(arg6,arg7)
if psunitplayertrue then

psunitisplayer(arg3,arg4)
if psunitplayertrue then

pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornolana=1
addtotwotables(arg7)
vezaxsort1()
addtotwotables(arg4)
vezaxsort1()
end
end
end
end
end


function psficclanaafterf()
if(psicgalochki[10][1]==1 and psicgalochki[10][2]==1)then
if psiccbonetime then
psiccbonetime[1]=math.ceil(psiccbonetime[1]*10)/10
psiccbonetime[3]=math.ceil(psiccbonetime[3]*10)/10
pszapuskanonsa(whererepiccchat[psicchatchoose[10][2]], "{rt4}"..psiccfailtxt91..": "..psiccbonetime[1].." "..pssec.." ("..psiccbonetime[2].."), "..psiccfailtxt911..": "..psiccbonetime[3].." "..pssec.." ("..psiccbonetime[4]..").", 1)
end
end

if(psicgalochki[10][1]==1 and psicgalochki[10][4]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt93
reportafterboitwotab(whererepiccchat[psicchatchoose[10][4]], true, vezaxname, vezaxcrash, 1, 7)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then
psicclastsaverep=GetTime()
psiccsavinginf(psiccbloodqueenlana)
if psiccbonetime then
pszapuskanonsa(whererepiccchat[psicchatchoose[10][2]], "{rt4}"..psiccfailtxt91..": "..psiccbonetime[1].." "..pssec.." ("..psiccbonetime[2].."), "..psiccfailtxt911..": "..psiccbonetime[3].." "..pssec.." ("..psiccbonetime[4]..").", 1,nil,0,1)
end
strochkavezcrash="{rt7} "..psiccfailtxt93
reportafterboitwotab(whererepiccchat[psicchatchoose[10][4]], true, vezaxname, vezaxcrash, nil, 20,0,1)

psiccrefsvin()
end

end


function psficclanaresetall()
wasornolana=nil
timetocheck=0
icclanaboyinterr=nil
psiccschet=0
psiccschet2=0
psiccschet3=0
psicclalanames=nil
psiccbonetime=nil
table.wipe(vezaxname)
table.wipe(vezaxcrash)
end


function psicclanamenu()
	if psicgalochki[1][1]==1 then
PSF_closeallpr()
PSFicclana:Show()

if (psicclanaga) then PSFicclana_CheckButton1:SetChecked() else PSFicclana_CheckButton1:SetChecked(false) end

if psflanadraw1==nil then
psflanadraw1=1

local t = PSFicclana:CreateFontString()
t:SetWidth(550)
t:SetHeight(150)
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",20,-15)
t:SetText(psicclanamarkinfo)
t:SetJustifyH("LEFT")
t:SetJustifyV("TOP")

local r = PSFicclana:CreateFontString()
r:SetWidth(550)
r:SetHeight(20)
r:SetFont(GameFontNormal:GetFont(), 12)
r:SetPoint("TOPLEFT",20,-200)
r:SetText(psicclanamarkinfo2)
r:SetJustifyH("LEFT")
r:SetJustifyV("TOP")

local s = PSFicclana:CreateFontString()
s:SetWidth(550)
s:SetHeight(20)
s:SetFont(GameFontNormal:GetFont(), 12)
s:SetPoint("TOPLEFT",20,-305)
s:SetText(psicclanamarkinfo3)
s:SetJustifyH("LEFT")
s:SetJustifyV("TOP")

PSFicclana_edbox1:SetScript("OnEnterPressed", function(self) psiccignlistadd() end )
PSFicclana_edbox2:SetScript("OnEnterPressed", function(self) psiccignlistadd2() end )


psicclanaign = PSFicclana:CreateFontString()
psicclanaign:SetWidth(550)
psicclanaign:SetHeight(45)
psicclanaign:SetFont(GameFontNormal:GetFont(), 11)
psicclanaign:SetPoint("TOPLEFT",20,-245)
psicclanaign:SetText(psicclananomarlist)
psicclanaign:SetJustifyH("LEFT")
psicclanaign:SetJustifyV("TOP")

psicclanaign2 = PSFicclana:CreateFontString()
psicclanaign2:SetWidth(550)
psicclanaign2:SetHeight(35)
psicclanaign2:SetFont(GameFontNormal:GetFont(), 11)
psicclanaign2:SetPoint("TOPLEFT",20,-350)
psicclanaign2:SetText(psicclananomarlist3)
psicclanaign2:SetJustifyH("LEFT")
psicclanaign2:SetJustifyV("TOP")
end


psiccreflignorlist()
	else
	out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicmodulenotena)
	end

end



function psiccreflignorlist()
if #psicclanaignorlist==0 then
psicclanaign:SetText(psicclananomarlist..psicclananomarlist2)
else
table.sort(psicclanaignorlist)
local pslist=""
for i=1,#psicclanaignorlist do
psicccheckclassm(psicclanaignorlist[i])
if psiccclassfound then
pslist=pslist..psiccclassfound..psicclanaignorlist[i].."|r"
else
pslist=pslist..psicclanaignorlist[i]
end
	if i==#psicclanaignorlist then
	pslist=pslist.."."
	else
	pslist=pslist..", "
	end
end
psicclanaign:SetText(psicclananomarlist..pslist)
end


if #psicclanaignorlist2==0 then
psicclanaign2:SetText(psicclananomarlist3..psicclananomarlist2)
else
table.sort(psicclanaignorlist2)
local pslist=""
for i=1,#psicclanaignorlist2 do
psicccheckclassm(psicclanaignorlist2[i])
if psiccclassfound then
pslist=pslist..psiccclassfound..psicclanaignorlist2[i].."|r"
else
pslist=pslist..psicclanaignorlist2[i]
end
	if i==#psicclanaignorlist2 then
	pslist=pslist.."."
	else
	pslist=pslist..", "
	end
end
psicclanaign2:SetText(psicclananomarlist3..pslist)
end

end


function psiccignlistadd()
if string.len(PSFicclana_edbox1:GetText())>1 then
local bililinet=0
for i=1,#psicclanaignorlist do
if string.lower(psicclanaignorlist[i])==string.lower(PSFicclana_edbox1:GetText()) then bililinet=1
end
end

if bililinet==0 then
table.insert(psicclanaignorlist,PSFicclana_edbox1:GetText())
out ("|cff99ffffPhoenixStyle|r - |cff00ff00'"..PSFicclana_edbox1:GetText().."'|r "..psicclanaerr3)
psiccreflignorlist()
else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r '"..PSFicclana_edbox1:GetText().."' - "..psicclanaerr2)
end
PSFicclana_edbox1:SetText("")

else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr1)
PSFicclana_edbox1:SetText("")
end
end


function psiccignlistrem()
if string.len(PSFicclana_edbox1:GetText())>1 then
local bililinet=0
for i=1,#psicclanaignorlist do
if psicclanaignorlist[i] and PSFicclana_edbox1:GetText() then
if string.lower(psicclanaignorlist[i])==string.lower(PSFicclana_edbox1:GetText()) then
bililinet=1
table.remove(psicclanaignorlist,i)
out ("|cff99ffffPhoenixStyle|r - |cffff0000'"..PSFicclana_edbox1:GetText().."'|r "..psicclanaerr4)
psiccreflignorlist()
PSFicclana_edbox1:SetText("")
end
end
end

if bililinet==0 then
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r '"..PSFicclana_edbox1:GetText().."' "..psicclanaerr5)
end

else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr1)
PSFicclana_edbox1:SetText("")
end
end



function psiccignlistadd2()
if string.len(PSFicclana_edbox2:GetText())>1 then
local bililinet=0
for i=1,#psicclanaignorlist2 do
if string.lower(psicclanaignorlist2[i])==string.lower(PSFicclana_edbox2:GetText()) then bililinet=1
end
end

if bililinet==0 then
table.insert(psicclanaignorlist2,PSFicclana_edbox2:GetText())
out ("|cff99ffffPhoenixStyle|r - |cff00ff00'"..PSFicclana_edbox2:GetText().."'|r "..psicclanaerr13)
psiccreflignorlist()
else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r '"..PSFicclana_edbox2:GetText().."' - "..psicclanaerr2)
end
PSFicclana_edbox2:SetText("")

else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr1)
PSFicclana_edbox2:SetText("")
end
end


function psiccignlistrem2()
if string.len(PSFicclana_edbox2:GetText())>1 then
local bililinet=0
for i=1,#psicclanaignorlist2 do
if psicclanaignorlist2[i] and PSFicclana_edbox2:GetText() then
if string.lower(psicclanaignorlist2[i])==string.lower(PSFicclana_edbox2:GetText()) then
bililinet=1
table.remove(psicclanaignorlist2,i)
out ("|cff99ffffPhoenixStyle|r - |cffff0000'"..PSFicclana_edbox2:GetText().."'|r "..psicclanaerr4)
psiccreflignorlist()
PSFicclana_edbox2:SetText("")
end
end
end

if bililinet==0 then
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r '"..PSFicclana_edbox2:GetText().."' "..psicclanaerr5)
end

else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr1)
PSFicclana_edbox2:SetText("")
end
end




function psicclanafoodmark()
if(thisaddonwork and (psicgalochki==nil or psicgalochki[1][1]==1)) then
if(IsRaidOfficer()==1) then
if psicczapusk10==nil or GetTime()>psicczapusk10 then
psicczapusk10=GetTime()+10
psmarksoff()
table.wipe(psicclanamarkref)
table.wipe(psicclanamarkref2)
psicclanatimer=GetTime()+70
psicnextupdlana=GetTime()+2

local psgropcheck=2
if GetInstanceDifficulty()==2 or GetInstanceDifficulty()==4 then
psgropcheck=5
end

local psdeb1 = GetSpellInfo(70877)
local psdeb2 = GetSpellInfo(70867)


local bezum=0
local pstable1={} --vampyr
local pstable2={} --food
for i = 1,GetNumRaidMembers() do local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
	if (subgroup <= psgropcheck and online and isDead==nil) then
		local bililinet=0
		if UnitDebuff(name, psdeb1) then
		bezum=bezum+1
		bililinet=1
		end

		if UnitDebuff(name, psdeb2) then
		bililinet=1
		table.insert(pstable1, name)
		end



		if bililinet==0 then
			for i=1,#psicclanaignorlist do
				if string.lower(psicclanaignorlist[i])==string.lower(name) then bililinet=1
				end
			end
		end

		if bililinet==0 then
		table.insert(pstable2, name)
		end

	end
end

--сортировка еды по витаминам

if #pstable2>1 then
local ii=#psicclanaignorlist2
while ii>0 do
	local mm=1
	while mm<=#pstable2 do
		if psicclanaignorlist2[ii] and pstable2[mm] then
			if string.lower(psicclanaignorlist2[ii])==string.lower(pstable2[mm]) then
				table.remove(pstable2,mm)
				table.insert(pstable2,1,psicclanaignorlist2[ii])
				mm=50
			end
		end
	mm=mm+1
	end
ii=ii-1
end
end



if #pstable1>8 then
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr9)
else

local k=1
if bezum>0 and psicclanaga then
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr10)
psicczapusk10=nil
for i=1,#pstable2 do
SetRaidTarget(pstable2[i], k)
table.insert(psicclanamarkref,pstable2[i])
table.insert(psicclanamarkref2,k)
k=k+1
end
end


local j=1
if psicclanaga==false then
for i=1,#pstable2 do
SetRaidTarget(pstable2[i], j)
table.insert(psicclanamarkref,pstable2[i])
table.insert(psicclanamarkref2,j)
j=j+1
end
	if #pstable2>0 then
out ("|cff99ffffPhoenixStyle|r - "..psicclanaerr6)
	else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr8)
	end
end

if psicclanaga and bezum==0 then
if #pstable1>0 then
if #pstable2>0 then
--тут основная функция


--сортирую милишников по таблицам в начале таблицы
for tr=1,#pstable1 do
	if pstable1[tr] then
		local _, uclass = UnitClass(pstable1[tr])
		if uclass=="ROGUE" or uclass=="WARRIOR" or uclass=="DEATHKNIGHT" then
			table.insert(pstable1,1,pstable1[tr])
			table.remove(pstable1,tr+1)
		end
	end
end


if #pstable1>1 then
	for gb=1,#pstable2 do
		if gb<=#pstable1 then
			local _, uuclass = UnitClass(pstable2[gb])
			if uuclass=="ROGUE" or uuclass=="WARRIOR" or uuclass=="DEATHKNIGHT" then
				table.insert(pstable2,1,pstable2[gb])
				table.remove(pstable2,gb+1)
				dd=100
			end
		end
	end
end



if (#pstable1==#pstable2 or (#pstable2>8 and #pstable1==8)) then

local m=1
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", psiccChatFilter)
psiccchatfiltime=GetTime()
for i=1,#pstable2 do
if m<9 then
SetRaidTarget(pstable2[i], m)


SendChatMessage("PhoenixStyle > "..psicclanawhisp1.." {rt"..m.."}"..pstable2[i], "WHISPER", nil, pstable1[i])
SendChatMessage("PhoenixStyle > {rt"..m.."}"..psicclanawhisp2.." "..pstable1[i].."!", "WHISPER", nil, pstable2[i])
table.insert(psicclanamarkref,pstable2[i])
table.insert(psicclanamarkref2,m)
m=m+1
end
end


if #pstable1==8 and #pstable2>8 and #pstable2<14 then
local morfood=""
for i=9,#pstable2 do
morfood=morfood..pstable2[i].." "
end
SendChatMessage("PhoenixStyle > "..psicclanasendm.." "..psicclanasendm5..morfood, "raid_warning")
else
SendChatMessage("PhoenixStyle > "..psicclanasendm, "raid_warning")
end


elseif #pstable1>#pstable2 then

local m=1
local nofood=""
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", psiccChatFilter)
psiccchatfiltime=GetTime()
for i=1,#pstable1 do
	if pstable2[i] then
SetRaidTarget(pstable2[i], m)

SendChatMessage("PhoenixStyle > "..psicclanawhisp1.." {rt"..m.."}"..pstable2[i], "WHISPER", nil, pstable1[i])
SendChatMessage("PhoenixStyle > {rt"..m.."}"..psicclanawhisp2.." "..pstable1[i].."!", "WHISPER", nil, pstable2[i])
table.insert(psicclanamarkref,pstable2[i])
table.insert(psicclanamarkref2,m)
m=m+1
	else
SendChatMessage(psicclanawhisp3, "WHISPER", nil, pstable1[i])
nofood=nofood..pstable1[i].." "
	end
end

SendChatMessage("PhoenixStyle > "..psicclanasendm.." "..psicclanasendm2..nofood, "raid_warning")


elseif #pstable1<#pstable2 then

local m=1
local morfood=""
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", psiccChatFilter)
psiccchatfiltime=GetTime()
for i=1,#pstable2 do
	if pstable1[i] then
SetRaidTarget(pstable2[i], m)

SendChatMessage("PhoenixStyle > "..psicclanawhisp1.." {rt"..m.."}"..pstable2[i], "WHISPER", nil, pstable1[i])
SendChatMessage("PhoenixStyle > {rt"..m.."}"..psicclanawhisp2.." "..pstable1[i].."!", "WHISPER", nil, pstable2[i])
table.insert(psicclanamarkref,pstable2[i])
table.insert(psicclanamarkref2,m)
m=m+1
	else
if m<9 then
SetRaidTarget(pstable2[i], m)
table.insert(psicclanamarkref,pstable2[i])
table.insert(psicclanamarkref2,m)
morfood=morfood.."{rt"..m.."}"..pstable2[i].." "
m=m+1
end
	end
end

SendChatMessage("PhoenixStyle > "..psicclanasendm.." "..psicclanasendm3..morfood, "raid_warning")


end

else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr12)
end
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr11)
psicczapusk10=nil
end
end




end --вампиров меньше 9



else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr7)
end
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrornotofficer)
end
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psaddonofmodno)
end
end


function psfgalchang()
if (PSFicclana_CheckButton1:GetChecked()) then
psicclanaga=true
else
psicclanaga=false
end
end