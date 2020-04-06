function psficcprofnoobs1()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornoprof=1
addtotwotables(arg7)
vezaxsort1()
if(psicgalochki[8][1]==1 and psicgalochki[8][7]==1)then
if UnitSex(arg7) and UnitSex(arg7)==3 then
pszapuskanonsa(whererepiccchat[psicchatchoose[8][7]], "{rt8} "..arg7.." - "..psiccbossfailtext76fem)
else
pszapuskanonsa(whererepiccchat[psicchatchoose[8][7]], "{rt8} "..arg7.." - "..psiccbossfailtext76)
end
end
end
end
end
end

function psficcprofnoobs2()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornoprof=1
addtotwotables2(arg7)
vezaxsort2()
end
end
end
end

function psficcprofnoobs3()
if psbossblock==nil then
psunitisplayer(arg6,arg7)
if psunitplayertrue then
pscheckwipe1(4,8)
if pswipetrue then
psiccwipereport()
else
wasornoprof=1
addtotwotables3(arg7)
vezaxsort3()
end
end
end
end


function psficcprofafterf()
if psiccfestertrig==nil then

if(psicgalochki[8][1]==1 and psicgalochki[8][3]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt72
reportafterboitwotab(whererepiccchat[psicchatchoose[8][3]], true, vezaxname2, vezaxcrash2, 1, 7)
end

if(psicgalochki[8][1]==1 and psicgalochki[8][4]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt73
reportafterboitwotab(whererepiccchat[psicchatchoose[8][4]], true, vezaxname3, vezaxcrash3, 1, 7)
end

if(psicgalochki[8][1]==1 and psicgalochki[8][2]==1)then
strochkavezcrash="{rt7} "..psiccfailtxt71
reportafterboitwotab(whererepiccchat[psicchatchoose[8][2]], true, vezaxname, vezaxcrash, 1, 7)
end

if psiccsavfile and (psicclastsaverep==nil or (psicclastsaverep and (GetTime()<psicclastsaverep+3 or GetTime()>psicclastsaverep+30))) then
psicclastsaverep=GetTime()
psiccsavinginf(psiccputricide)
strochkavezcrash="{rt7} "..psiccfailtxt72
reportafterboitwotab(whererepiccchat[psicchatchoose[8][3]], true, vezaxname2, vezaxcrash2, 1, 15,0,1)
strochkavezcrash="{rt7} "..psiccfailtxt73
reportafterboitwotab(whererepiccchat[psicchatchoose[8][4]], true, vezaxname3, vezaxcrash3, 1, 15,0,1)
strochkavezcrash="{rt7} "..psiccfailtxt71
reportafterboitwotab(whererepiccchat[psicchatchoose[8][2]], true, vezaxname, vezaxcrash, nil, 25,0,1)
psiccrefsvin()
end

end
end


function psficcprofresetall()
if psiccfestertrig==nil then
wasornoprof=nil
timetocheck=0
iccprofboyinterr=nil
table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
psiccproftimeaply1=nil
psiccproftimeaply2=nil
psiccproftimeaply3=nil
psicclanaisbatle2=nil
end
end






function psiccprofmenu()
	if psicgalochki[1][1]==1 then
PSF_closeallpr()
PSFiccprofframe:Show()

if (psiccprofgal1) then PSFiccprofframe_CheckButton1:SetChecked() else PSFiccprofframe_CheckButton1:SetChecked(false) end
if (psiccprofgal2) then PSFiccprofframe_CheckButton2:SetChecked() else PSFiccprofframe_CheckButton2:SetChecked(false) end
if (psiccprofgal22) then PSFiccprofframe_CheckButton22:SetChecked() else PSFiccprofframe_CheckButton22:SetChecked(false) end
if (psiccprofgal23) then PSFiccprofframe_CheckButton23:SetChecked() else PSFiccprofframe_CheckButton23:SetChecked(false) end
if (psiccprofgal3) then PSFiccprofframe_CheckButton3:SetChecked() else PSFiccprofframe_CheckButton3:SetChecked(false) end
if (psiccprofgal5) then PSFiccprofframe_CheckButton5:SetChecked() else PSFiccprofframe_CheckButton5:SetChecked(false) end

if psflanadrawpr==nil then
psflanadrawpr=1

local t = PSFiccprofframe:CreateFontString()
t:SetWidth(550)
t:SetHeight(150)
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",20,-15)
t:SetText(psiccprofmarkinfo)
t:SetJustifyH("LEFT")
t:SetJustifyV("TOP")

psiccigntxtprogvis1 = PSFiccprofframe:CreateFontString()
psiccigntxtprogvis1:SetWidth(550)
psiccigntxtprogvis1:SetHeight(20)
psiccigntxtprogvis1:SetFont(GameFontNormal:GetFont(), 12)
psiccigntxtprogvis1:SetPoint("TOPLEFT",20,-145)
psiccigntxtprogvis1:SetText(psiccprofmarkinfo2)
psiccigntxtprogvis1:SetJustifyH("LEFT")
psiccigntxtprogvis1:SetJustifyV("TOP")

psiccigntxtprogvis = PSFiccprofframe:CreateFontString()
psiccigntxtprogvis:SetWidth(550)
psiccigntxtprogvis:SetHeight(20)
psiccigntxtprogvis:SetFont(GameFontNormal:GetFont(), 12)
psiccigntxtprogvis:SetPoint("TOPLEFT",20,-265)
psiccigntxtprogvis:SetText(psiccprofmarkinfo3)
psiccigntxtprogvis:SetJustifyH("LEFT")
psiccigntxtprogvis:SetJustifyV("TOP")


psiccprofign = PSFiccprofframe:CreateFontString()
psiccprofign:SetWidth(350)
psiccprofign:SetHeight(65)
psiccprofign:SetFont(GameFontNormal:GetFont(), 11)
psiccprofign:SetPoint("TOPLEFT",20,-310)
psiccprofign:SetText(psicclananomarlist)
psiccprofign:SetJustifyH("LEFT")
psiccprofign:SetJustifyV("TOP")

psiccprofign2 = PSFiccprofframe:CreateFontString()
psiccprofign2:SetWidth(350)
psiccprofign2:SetHeight(65)
psiccprofign2:SetFont(GameFontNormal:GetFont(), 11)
psiccprofign2:SetPoint("TOPLEFT",20,-190)
psiccprofign2:SetText(psiccprofnomarlist3)
psiccprofign2:SetJustifyH("LEFT")
psiccprofign2:SetJustifyV("TOP")

--infotactic
psiccproftact = PSFiccprofframe:CreateFontString()
psiccproftact:SetWidth(300)
psiccproftact:SetHeight(100)
psiccproftact:SetFont(GameFontNormal:GetFont(), 12)
psiccproftact:SetPoint("TOPLEFT",50,-275)
psiccproftact:SetText(psiccproftacttxt1)
psiccproftact:SetJustifyH("LEFT")
psiccproftact:SetJustifyV("TOP")

psiccproftact2 = PSFiccprofframe:CreateFontString()
psiccproftact2:SetWidth(300)
psiccproftact2:SetHeight(100)
psiccproftact2:SetFont(GameFontNormal:GetFont(), 12)
psiccproftact2:SetPoint("TOPLEFT",50,-130)
psiccproftact2:SetText(psiccproftacttxt2)
psiccproftact2:SetJustifyH("LEFT")
psiccproftact2:SetJustifyV("TOP")

psiccprofdrowtable1={}
psiccprofdrowtable2={}

--онентерпрессед
PSFiccprofframe_edbox1:SetScript("OnEnterPressed", function(self) psiccignlistaddprof() end )
PSFiccprofframe_edbox2:SetScript("OnEnterPressed", function(self) psiccignlistaddprof2() end )


--чума
local a = PSFiccprofframe:CreateTexture(nil,"OVERLAY")
a:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8")
a:SetPoint("TOPLEFT",384,-120)
a:SetWidth(22)
a:SetHeight(22)

local aa = PSFiccprofframe:CreateFontString()
aa:SetWidth(50)
aa:SetHeight(20)
aa:SetFont(GameFontNormal:GetFont(), 16)
aa:SetPoint("TOPLEFT",390,-123)
aa:SetText("\=")

local aa2 = PSFiccprofframe:CreateFontString()
aa2:SetWidth(230)
aa2:SetHeight(20)
aa2:SetFont(GameFontNormal:GetFont(), 12)
aa2:SetPoint("TOPLEFT",384,-165)
aa2:SetJustifyH("LEFT")
aa2:SetText(psiccprofusemark)


local aaname, _, aaicon=GetSpellInfo(72855)
local aaa = PSFiccprofframe:CreateTexture(nil,"OVERLAY")
aaa:SetTexture(aaicon)
aaa:SetWidth(22)
aaa:SetHeight(22)
aaa:SetPoint("TOPLEFT",425,-120)

local aaa2 = PSFiccprofframe:CreateFontString()
aaa2:SetFont(GameFontNormal:GetFont(), 11)
aaa2:SetText(aaname)
aaa2:SetJustifyH("LEFT")
aaa2:SetPoint("TOPLEFT",448,-126)


--marks
for i=1,6 do
local o = PSFiccprofframe:CreateTexture(nil,"OVERLAY")
o:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_"..i)
o:SetPoint("TOPLEFT",359+25*i,-189)
o:SetWidth(20)
o:SetHeight(20)
table.insert(psiccprofdrowtable1,o)

--checkbuttons
local q = CreateFrame("CheckButton", nil, PSFiccprofframe, "UICheckButtonTemplate")
q:SetWidth("25")
q:SetHeight("25")
q:SetPoint("TOPLEFT",357+25*i,-210)
q:SetScript("OnClick", function(self) PSFiccprofmg(i) end )
table.insert(psiccprofdrowtable2, q)
end
PSFiccprofmg()


--txt timer
psiccproftimtxt = PSFiccprofframe:CreateFontString()
psiccproftimtxt:SetWidth(200)
psiccproftimtxt:SetHeight(40)
psiccproftimtxt:SetFont(GameFontNormal:GetFont(), 11)
psiccproftimtxt:SetPoint("TOPLEFT",390,-270)
psiccproftimtxt:SetJustifyH("LEFT")
psiccproftimtxt:SetJustifyV("TOP")

--txt timer2
psiccproftimtxt2 = PSFiccprofframe:CreateFontString()
psiccproftimtxt2:SetWidth(200)
psiccproftimtxt2:SetHeight(40)
psiccproftimtxt2:SetFont(GameFontNormal:GetFont(), 11)
psiccproftimtxt2:SetPoint("TOPLEFT",390,-301)
psiccproftimtxt2:SetJustifyH("LEFT")
psiccproftimtxt2:SetJustifyV("TOP")

--txt timer3
psiccproftimtxt3 = PSFiccprofframe:CreateFontString()
psiccproftimtxt3:SetWidth(200)
psiccproftimtxt3:SetHeight(40)
psiccproftimtxt3:SetFont(GameFontNormal:GetFont(), 11)
psiccproftimtxt3:SetPoint("TOPLEFT",390,-332)
psiccproftimtxt3:SetJustifyH("LEFT")
psiccproftimtxt3:SetJustifyV("TOP")


getglobal("PSFiccprofframe_TimerHigh"):SetText("30")
getglobal("PSFiccprofframe_TimerLow"):SetText("3")
PSFiccprofframe_Timer:SetMinMaxValues(3, 30)
PSFiccprofframe_Timer:SetValueStep(1)
if psiccproftimer<3 then psiccproftimer=7 end
PSFiccprofframe_Timer:SetValue(psiccproftimer)
psiccslidertime()

--on off

if psiccprofgal5 then
psiccprofactiv=1
PSFiccprofframe_Textmarkon:Show()
PSFiccprofframe_Buttonon:Hide()
PSFiccprofframe_Textmarkoff:Hide()
PSFiccprofframe_Buttonoff:Show()
else
psiccprofactiv=nil
PSFiccprofframe_Textmarkon:Hide()
PSFiccprofframe_Buttonon:Show()
PSFiccprofframe_Textmarkoff:Show()
PSFiccprofframe_Buttonoff:Hide()
end


PSFiccprofframe_Textmarkoff:SetFont(GameFontNormal:GetFont(), 15)
PSFiccprofframe_Textmarkon:SetFont(GameFontNormal:GetFont(), 15)


end

psiccreflignorlistprof()
psfprofgalchang(1)
psfprofgalchang(3)

	else
	out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicmodulenotena)
	end
end





function psiccslidertime()
psiccproftimer = PSFiccprofframe_Timer:GetValue()
local prpr="|cff00ff00"..psiccproftimer.."|r"
local text=psiccprofmodopt2..prpr.." "..pssec
psiccproftimtxt:SetText(text)
local text2=psiccprofmodopt22..prpr.." "..pssec
psiccproftimtxt2:SetText(text2)
local text3=psiccprofmodopt23..prpr.." "..psiccprofmodopt23a
psiccproftimtxt3:SetText(text3)
end


function PSFiccprofmg(nr)

if nr then
	if (psiccprofdrowtable2[nr]:GetChecked()) then
		psiccprofchb[nr]=1
	else
		psiccprofchb[nr]=0
	end
end

for i=1,6 do
	if psiccprofchb[i]==1 then
		psiccprofdrowtable1[i]:SetAlpha(1)
		psiccprofdrowtable2[i]:SetChecked()
	else
		psiccprofdrowtable1[i]:SetAlpha(0.2)
		psiccprofdrowtable2[i]:SetChecked(false)
	end

end

end



function psiccreflignorlistprof()
if #psiccprofignorlist1==0 then
psiccprofign:SetText(psicclananomarlist..psicclananomarlist2)
else
table.sort(psiccprofignorlist1)
local pslist=""
for i=1,#psiccprofignorlist1 do
psicccheckclassm(psiccprofignorlist1[i])
if psiccclassfound then
pslist=pslist..psiccclassfound..psiccprofignorlist1[i].."|r"
else
pslist=pslist..psiccprofignorlist1[i]
end
	if i==#psiccprofignorlist1 then
	pslist=pslist.."."
	else
	pslist=pslist..", "
	end
end
psiccprofign:SetText(psicclananomarlist..pslist)
end


if #psiccprofignorlist2==0 then
psiccprofign2:SetText(psicclananomarlist3..psicclananomarlist2)
else
table.sort(psiccprofignorlist2)
local pslist=""
for i=1,#psiccprofignorlist2 do
psicccheckclassm(psiccprofignorlist2[i])
if psiccclassfound then
pslist=pslist..psiccclassfound..psiccprofignorlist2[i].."|r"
else
pslist=pslist..psiccprofignorlist2[i]
end
	if i==#psiccprofignorlist2 then
	pslist=pslist.."."
	else
	pslist=pslist..", "
	end
end
	if psiccprofgal1 then
psiccprofign2:SetText(psiccprofnomarlist23..pslist)
	else
psiccprofign2:SetText(psicclananomarlist3..pslist)
	end
end

end


function psiccignlistaddprof()
if string.len(PSFiccprofframe_edbox1:GetText())>1 then
local bililinet=0
for i=1,#psiccprofignorlist1 do
if string.lower(psiccprofignorlist1[i])==string.lower(PSFiccprofframe_edbox1:GetText()) then bililinet=1
end
end

if bililinet==0 then
table.insert(psiccprofignorlist1,PSFiccprofframe_edbox1:GetText())
out ("|cff99ffffPhoenixStyle|r - |cff00ff00'"..PSFiccprofframe_edbox1:GetText().."'|r "..psicclanaerrprof3)
psiccreflignorlistprof()
else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r '"..PSFiccprofframe_edbox1:GetText().."' - "..psicclanaerr2)
end
PSFiccprofframe_edbox1:SetText("")

else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr1)
PSFiccprofframe_edbox1:SetText("")
end
end


function psiccignlistremprof()
if string.len(PSFiccprofframe_edbox1:GetText())>1 then
local bililinet=0
for i=1,#psiccprofignorlist1 do
if psiccprofignorlist1[i] and PSFiccprofframe_edbox1:GetText() then
if string.lower(psiccprofignorlist1[i])==string.lower(PSFiccprofframe_edbox1:GetText()) then
bililinet=1
table.remove(psiccprofignorlist1,i)
out ("|cff99ffffPhoenixStyle|r - |cffff0000'"..PSFiccprofframe_edbox1:GetText().."'|r "..psicclanaerr4)
psiccreflignorlistprof()
PSFiccprofframe_edbox1:SetText("")
end
end
end

if bililinet==0 then
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r '"..PSFiccprofframe_edbox1:GetText().."' "..psicclanaerr5)
end

else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr1)
PSFiccprofframe_edbox1:SetText("")
end
end



function psiccignlistaddprof2()
if string.len(PSFiccprofframe_edbox2:GetText())>1 then
local bililinet=0
for i=1,#psiccprofignorlist2 do
if string.lower(psiccprofignorlist2[i])==string.lower(PSFiccprofframe_edbox2:GetText()) then bililinet=1
end
end

if bililinet==0 then
table.insert(psiccprofignorlist2,PSFiccprofframe_edbox2:GetText())
out ("|cff99ffffPhoenixStyle|r - |cff00ff00'"..PSFiccprofframe_edbox2:GetText().."'|r "..psicclanaerrprof13)
psiccreflignorlistprof()
else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r '"..PSFiccprofframe_edbox2:GetText().."' - "..psicclanaerr2)
end
PSFiccprofframe_edbox2:SetText("")

else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr1)
PSFiccprofframe_edbox2:SetText("")
end
psfprofgalchang(1)
end


function psiccignlistremprof2()
if string.len(PSFiccprofframe_edbox2:GetText())>1 then
local bililinet=0
for i=1,#psiccprofignorlist2 do
if psiccprofignorlist2[i] and PSFiccprofframe_edbox2:GetText() then
if string.lower(psiccprofignorlist2[i])==string.lower(PSFiccprofframe_edbox2:GetText()) then
bililinet=1
table.remove(psiccprofignorlist2,i)
out ("|cff99ffffPhoenixStyle|r - |cffff0000'"..PSFiccprofframe_edbox2:GetText().."'|r "..psicclanaerr4)
psiccreflignorlistprof()
PSFiccprofframe_edbox2:SetText("")
end
end
end

if bililinet==0 then
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r '"..PSFiccprofframe_edbox2:GetText().."' "..psicclanaerr5)
end

else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psicclanaerr1)
PSFiccprofframe_edbox2:SetText("")
end
psfprofgalchang(1)
end




function psiccprofmodwork()

psiccfirstmarkprofwispl=nil

if(thisaddonwork and (psicgalochki==nil or psicgalochki[1][1]==1)) then
--if(IsRaidOfficer()==1) then

--на чуме мало времени
local normcont=1

	if psiccprofwispchuma2 then
local psideb1 = GetSpellInfo(70911)
local _, _, _, _, _, _, expirationTime = UnitDebuff(psiccprofwispchuma2, psideb1)
local timean=5
if psiccprofwispchuma1 and psiccprofwispchuma1-GetTime()>2 and psiccprofwispchuma1-GetTime()<20 then
timean=(psiccprofwispchuma1-GetTime())+3
end

if expirationTime==nil or (expirationTime and expirationTime-GetTime()<timean) then
normcont=2
end
	else
		normcont=2	
	end

if normcont==1 then



firstmarkset=1


local psgropcheck=2
if GetInstanceDifficulty()==2 or GetInstanceDifficulty()==4 then
psgropcheck=5
end

local psdeb1 = GetSpellInfo(70911) --безуд
local psdeb2 = GetSpellInfo(70953) --острая


local psdebsliz1 = GetSpellInfo(70447) --зеленый
local psdebsliz2 = GetSpellInfo(70672) --оранж слизь


local usemarks={}

for tt=1,6 do
	if psiccprofchb[tt]==1 then
		table.insert(usemarks,tt)
	end
end


--проверка версии настройки


if #usemarks>0 then
if psiccprofgal1==true then
if #psiccprofignorlist2>0 then
--марчить ток список приоритета


local j=1
for i = 1,GetNumRaidMembers() do local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
	if (subgroup <= psgropcheck and online and isDead==nil and UnitIsDeadOrGhost(name)==nil) then
		if UnitDebuff(name, psdeb1) then

				if UnitExists(name) and (GetRaidTargetIndex(name)==nil or (GetRaidTargetIndex(name) and GetRaidTargetIndex(name)~=8)) then
			if(IsRaidOfficer()==1) then
			SetRaidTarget(name, 8)
			end
				end

		end

		if UnitDebuff(name, psdebsliz1) or UnitDebuff(name, psdebsliz2) then
			if UnitExists(name) and GetRaidTargetIndex(name) and GetRaidTargetIndex(name)>0 then
				if usemarks and #usemarks>0 then
					for tr=1,#usemarks do
						if GetRaidTargetIndex(name)==usemarks[tr] then
							if(IsRaidOfficer()==1) then
							SetRaidTarget(name, 0)
							end
						end
					end
				end
			end
		end

		local bililinet=0
		for yy=1,#psiccprofignorlist2 do
			if string.lower(psiccprofignorlist2[yy])==string.lower(name) then
				bililinet=1
			end
		end
	if bililinet==1 then
		local _, _, _, _, _, _, expirati = UnitDebuff(name, psdeb2)
		if (UnitDebuff(name, psdeb2)==nil or (expirati and expirati-GetTime()<5)) and UnitDebuff(name, psdeb1)==nil and UnitDebuff(name, psdebsliz1)==nil and (pspaabom==nil or (pspaabom and name~=pspaabom)) and UnitDebuff(name, psdebsliz2)==nil then
		--метим если j меньше табл

			if j<=#usemarks then
					if UnitExists(name) and (GetRaidTargetIndex(name)==nil or (GetRaidTargetIndex(name) and GetRaidTargetIndex(name)~=usemarks[j])) then
				if(IsRaidOfficer()==1) then
				SetRaidTarget(name, usemarks[j])
				end
						if firstmarkset then
							firstmarkset=nil
							psiccfirstmarkprofwispl=name
						end
					elseif UnitExists(name) then
						if firstmarkset then
							firstmarkset=nil
							psiccfirstmarkprofwispl=name
						end
					end
				j=j+1
			end
		end

	end

	end
end







end
elseif psiccprofgal3==true then
--марчить по ренджу - игнор список

local pstable1={}
local pstablerange1={}
SetMapToCurrentZone()
local locx1=0
local locy1=0

local j=1
for i = 1,GetNumRaidMembers() do local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
	if (subgroup <= psgropcheck and online and isDead==nil and UnitIsDeadOrGhost(name)==nil) then
		if UnitDebuff(name, psdeb1) then
			locx1,locy1=GetPlayerMapPosition(name)

				if UnitExists(name) and (GetRaidTargetIndex(name)==nil or (GetRaidTargetIndex(name) and GetRaidTargetIndex(name)~=8)) then
			if(IsRaidOfficer()==1) then
			SetRaidTarget(name, 8)
			end
				end

		end

		if UnitDebuff(name, psdebsliz1) or UnitDebuff(name, psdebsliz2) then
			if UnitExists(name) and GetRaidTargetIndex(name) and GetRaidTargetIndex(name)>0 then
				if usemarks and #usemarks>0 then
					for tr=1,#usemarks do
						if GetRaidTargetIndex(name)==usemarks[tr] then
							if(IsRaidOfficer()==1) then
							SetRaidTarget(name, 0)
							end
						end
					end
				end
			end
		end

		local _, _, _, _, _, _, expirati = UnitDebuff(name, psdeb2)
		if (UnitDebuff(name, psdeb2)==nil or (expirati and expirati-GetTime()<5)) and UnitDebuff(name, psdeb1)==nil and UnitDebuff(name, psdebsliz1)==nil and (pspaabom==nil or (pspaabom and name~=pspaabom)) and UnitDebuff(name, psdebsliz2)==nil then

			local bililinet=0
			for yy=1,#psiccprofignorlist1 do
				if string.lower(psiccprofignorlist1[yy])==string.lower(name) then
					bililinet=1
				end
			end

			if bililinet==0 then
				table.insert(pstable1,name)
			end
		end

	end
end

if locx1>0 and #pstable1>0 then

for e=1,#pstable1 do
	local locx2, locy2 = GetPlayerMapPosition(pstable1[e])
	if locx2>0 then
		local rasst=math.sqrt(math.pow((locx1-locx2),2)+math.pow((locy1-locy2),2))
		table.insert(pstablerange1, rasst)

	else
		table.insert(pstablerange1, 0)
	end
end

end


--сортировка по ренджу
psdamagename3=nil
psdamagevalue3=nil

for q=1,#pstablerange1 do

	if pstablerange1[q]>0 then

	addtotwodamagetables3(pstable1[q],pstablerange1[q])
	psdamagetwotablsort3()

	end

end

	if psdamagevalue3 and #psdamagevalue3>0 then

local uu=#psdamagevalue3
while uu>0 do
--метим если j меньше табл
	if j<=#usemarks then
		if UnitExists(psdamagename3[uu]) and (GetRaidTargetIndex(psdamagename3[uu])==nil or (GetRaidTargetIndex(psdamagename3[uu]) and GetRaidTargetIndex(psdamagename3[uu])~=usemarks[j])) then
			if(IsRaidOfficer()==1) then
			SetRaidTarget(psdamagename3[uu], usemarks[j])
			end
						if firstmarkset then
							firstmarkset=nil
							psiccfirstmarkprofwispl=psdamagename3[uu]
						end
		elseif UnitExists(psdamagename3[uu]) then
						if firstmarkset then
							firstmarkset=nil
							psiccfirstmarkprofwispl=psdamagename3[uu]
						end
		end
		j=j+1
	else
		uu=0
	end
uu=uu-1
end

psdamagename3=nil
psdamagevalue3=nil

	end



else
--приоритет + игнор список

local pstable1={}

local j=1
for i = 1,GetNumRaidMembers() do local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
	if (subgroup <= psgropcheck and online and isDead==nil and UnitIsDeadOrGhost(name)==nil) then
		if UnitDebuff(name, psdeb1) then

				if UnitExists(name) and (GetRaidTargetIndex(name)==nil or (GetRaidTargetIndex(name) and GetRaidTargetIndex(name)~=8)) then
			if(IsRaidOfficer()==1) then
			SetRaidTarget(name, 8)
			end
				end


		end

		if UnitDebuff(name, psdebsliz1) or UnitDebuff(name, psdebsliz2) then
			if UnitExists(name) and GetRaidTargetIndex(name) and GetRaidTargetIndex(name)>0 then
				if usemarks and #usemarks>0 then
					for tr=1,#usemarks do
						if GetRaidTargetIndex(name)==usemarks[tr] then
							if(IsRaidOfficer()==1) then
							SetRaidTarget(name, 0)
							end
						end
					end
				end
			end
		end

		local _, _, _, _, _, _, expirati = UnitDebuff(name, psdeb2)
		if (UnitDebuff(name, psdeb2)==nil or (expirati and expirati-GetTime()<5)) and UnitDebuff(name, psdeb1)==nil and UnitDebuff(name, psdebsliz1)==nil and (pspaabom==nil or (pspaabom and name~=pspaabom)) and UnitDebuff(name, psdebsliz2)==nil then

			local bililinet=0
			for yy=1,#psiccprofignorlist1 do
				if string.lower(psiccprofignorlist1[yy])==string.lower(name) then
					bililinet=1
				end
			end

			if bililinet==0 then
				table.insert(pstable1,name)
			end
		end

	end
end




--сортировка по приорити листу

if #pstable1>1 then

local ii=#psiccprofignorlist2
while ii>0 do
	local mm=1
	while mm<=#pstable1 do
		if psiccprofignorlist2[ii] and pstable1[mm] then
			if string.lower(psiccprofignorlist2[ii])==string.lower(pstable1[mm]) then
				table.remove(pstable1,mm)
				table.insert(pstable1,1,psiccprofignorlist2[ii])
				mm=50
			end
		end
	mm=mm+1
	end
ii=ii-1
end
end


for oo=1,#pstable1 do
--метим если j меньше табл
	if j<=#usemarks then
		if UnitExists(pstable1[oo]) and (GetRaidTargetIndex(pstable1[oo])==nil or (GetRaidTargetIndex(pstable1[oo]) and GetRaidTargetIndex(pstable1[oo])~=usemarks[j])) then
			if(IsRaidOfficer()==1) then
			SetRaidTarget(pstable1[oo], usemarks[j])
			end
						if firstmarkset then
							firstmarkset=nil
							psiccfirstmarkprofwispl=pstable1[oo]
						end

		elseif UnitExists(pstable1[oo]) then
						if firstmarkset then
							firstmarkset=nil
							psiccfirstmarkprofwispl=pstable1[oo]
						end
		end
		j=j+1
	end
end



end
end

--else
--out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrornotofficer)
--psficcprofmodoff()
--end

--end перенес за вывод функции




--вывод сообщ.

if psiccprofgal23 and psiccprofwispchuma1 then
if psiccchatfiltime==nil then
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", psiccChatFilter)
psiccchatfiltime=GetTime()
else
psiccchatfiltime=GetTime()
end
	if psiccprofsendonemes then
		psiccprofsendonemes=nil
		if psiccfirstmarkprofwispl then
			SendChatMessage("{rt1} >>> "..psiccfirstmarkprofwispl.." <<< "..psiccprofpreptotake, "raid")
			SendChatMessage(psiccprofpreptotake, "WHISPER", nil, psiccfirstmarkprofwispl)
			psdelayprofmod=GetTime()+30

		else
			SendChatMessage("{rt8}{rt8} "..psiccprofnotfo, "raid")
			psdelayprofmod=GetTime()-10
		end
	else
		if psiccfirstmarkprofwisp==nil and psiccfirstmarkprofwispl then
			SendChatMessage("{rt1} >>> "..psiccfirstmarkprofwispl.." <<< "..psiccprofpreptotake, "raid")
			SendChatMessage(psiccprofpreptotake, "WHISPER", nil, psiccfirstmarkprofwispl)
			psdelayprofmod=GetTime()+30

		elseif psiccfirstmarkprofwisp and psiccfirstmarkprofwispl and psiccfirstmarkprofwisp~=psiccfirstmarkprofwispl then
			SendChatMessage("{rt1} >>> "..psiccfirstmarkprofwispl.." <<< "..psiccprofpreptotake.." {rt8} "..(string.upper(psiccprofpreptotake2)), "raid")
			SendChatMessage(psiccprofpreptotake, "WHISPER", nil, psiccfirstmarkprofwispl)
			psdelayprofmod=GetTime()+30

		elseif psiccfirstmarkprofwisp and psiccfirstmarkprofwispl and psiccfirstmarkprofwisp==psiccfirstmarkprofwispl then
			psdelayprofmod=GetTime()+30
		elseif psiccfirstmarkprofwispl==nil then
			psdelayprofmod=GetTime()-10
		end
	end
elseif psiccprofgal23 and psiccprofwispchuma1==nil and psiccprofsendonemes==nil and psiccfirstmarkprofwisp and psiccfirstmarkprofwispl and psiccfirstmarkprofwisp~=psiccfirstmarkprofwispl and psiccprofwispchuma22 then
--смена цели после сообщ что пора забирать
SendChatMessage("{rt8}{rt8}{rt8} "..psiccfirstmarkprofwisp.." "..pscanttakeplag, "WHISPER", nil, psiccprofwispchuma22)
SendChatMessage("{rt8}{rt8}{rt8} "..psiccfirstmarkprofwisp.." "..pscanttakeplag, "raid")


end
psiccfirstmarkprofwisp=psiccfirstmarkprofwispl

end --normcont
end
end
--func



function psfprofgalchang(nr)
if nr==1 then
if (PSFiccprofframe_CheckButton1:GetChecked()) then
	if #psiccprofignorlist2>3 then
		psiccprofgal1=true
		PSFiccprofframe_Button11:Hide()
		PSFiccprofframe_Button22:Hide()
		psiccigntxtprogvis:Hide()
		psiccprofign:Hide()
		PSFiccprofframe_edbox1:Hide()
		PSFiccprofframe_CheckButton3:Hide()
		psiccproftact:Show()
	else
		psiccprofgal1=false
		if (psiccprofgal1) then PSFiccprofframe_CheckButton1:SetChecked() else PSFiccprofframe_CheckButton1:SetChecked(false) end
		out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psiccprofnotenough)
		PSFiccprofframe_Button11:Show()
		PSFiccprofframe_Button22:Show()
		psiccigntxtprogvis:Show()
		psiccprofign:Show()
		PSFiccprofframe_edbox1:Show()
		PSFiccprofframe_CheckButton3:Show()
		psiccproftact:Hide()
	end
else
		psiccprofgal1=false
		PSFiccprofframe_Button11:Show()
		PSFiccprofframe_Button22:Show()
		psiccigntxtprogvis:Show()
		psiccprofign:Show()
		PSFiccprofframe_edbox1:Show()
		PSFiccprofframe_CheckButton3:Show()
		psiccproftact:Hide()
end

end
if nr==2 then
if (PSFiccprofframe_CheckButton2:GetChecked()) then
psiccprofgal2=true
else
psiccprofgal2=false
end
end

if nr==22 then
if (PSFiccprofframe_CheckButton22:GetChecked()) then
psiccprofgal22=true
else
psiccprofgal22=false
end
end

if nr==23 then
if (PSFiccprofframe_CheckButton23:GetChecked()) then
psiccprofgal23=true
else
psiccprofgal23=false
end
end

if nr==5 then
if (PSFiccprofframe_CheckButton5:GetChecked()) then
psiccprofgal5=true
if psiccprofactiv then else
psficcprofmodon()
end
else
psiccprofgal5=false
end
end

if nr==3 then
if (PSFiccprofframe_CheckButton3:GetChecked()) then
		psiccprofgal3=true
		PSFiccprofframe_Button1:Hide()
		PSFiccprofframe_Button2:Hide()
		psiccigntxtprogvis1:Hide()
		psiccprofign2:Hide()
		PSFiccprofframe_edbox2:Hide()
		PSFiccprofframe_CheckButton1:Hide()
		psiccproftact2:Show()
else
		psiccprofgal3=false
		PSFiccprofframe_Button1:Show()
		PSFiccprofframe_Button2:Show()
		psiccigntxtprogvis1:Show()
		psiccprofign2:Show()
		PSFiccprofframe_edbox2:Show()
		PSFiccprofframe_CheckButton1:Show()
		psiccproftact2:Hide()
end

end

if PSFiccprofframe_CheckButton1:GetChecked() or PSFiccprofframe_CheckButton3:GetChecked() then
PSFiccprofframe_CheckButtonorig:Hide()
else
PSFiccprofframe_CheckButtonorig:Show()
end


psiccreflignorlistprof()
end


function psficcprofmodon()
--if(IsRaidOfficer()==1) then
psiccprofactiv=1
out("|cff99ffffPhoenixStyle|r - "..psiccputricide..": |cff00ff00"..psmoduletxton.."|r")
PSFiccprofframe_Textmarkon:Show()
PSFiccprofframe_Buttonon:Hide()
PSFiccprofframe_Textmarkoff:Hide()
PSFiccprofframe_Buttonoff:Show()
if autorefmark then PSF_buttonoffmark() end
--else
--out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pserrornotofficer)
--end
end

function psficcprofmodoff()
psiccprofactiv=nil
PSFiccprofframe_Textmarkon:Hide()
PSFiccprofframe_Buttonon:Show()
PSFiccprofframe_Textmarkoff:Show()
PSFiccprofframe_Buttonoff:Hide()
psiccprofgal5=false
if (psiccprofgal5) then PSFiccprofframe_CheckButton5:SetChecked() else PSFiccprofframe_CheckButton5:SetChecked(false) end
out("|cff99ffffPhoenixStyle|r - "..psiccputricide..": |cffff0000"..psmoduletxtoff.."|r")
end

function psiccprofcheckspam(ttt)
if psiccprofchumanorm==nil then
local nam=UnitName("player")
if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" then nam="00"..UnitName("player") end
if IsRaidOfficer()==1 then nam="0"..nam end
local tablecheckprof={}
table.insert(tablecheckprof,nam)
table.insert(tablecheckprof,ttt)
table.sort(tablecheckprof)
if tablecheckprof[1]~=nam then
psiccprofchumanorm=1
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psiccprofmanyaddons)
end


end
end