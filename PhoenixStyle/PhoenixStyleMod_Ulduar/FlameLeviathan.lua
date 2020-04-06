--рейдростер на леви
function zagrraidroster()
for i = 1,40 do local name,rank,subgroup = GetRaidRosterInfo(i) local biluje=0
if (subgroup == 2) then
for i,levinik in ipairs(namelevi1) do if levinik == " " then if(biluje==0)then namelevi1[i]=name biluje=1 end end end
elseif (subgroup == 3) then
for i,levinik in ipairs(namelevi2) do if levinik == " " then if(biluje==0)then namelevi2[i]=name biluje=1 end end end
elseif (subgroup == 5) then
for i,levinik in ipairs(namelevi3) do if levinik == " " then if(biluje==0)then namelevi3[i]=name biluje=1 end end end
elseif (subgroup == 4) then
for i,levinik in ipairs(namelevi4) do if levinik == " " then if(biluje==0)then namelevi4[i]=name biluje=1 end end end
end
end
end




--резет рейда и релод 
function PSF_reloadraidlevi()
if GetNumRaidMembers() > 0 then
namelevi1={" ",
" ",
" ",
" ",
" ",
}
namelevi2={" ",
" ",
" ",
" ",
" ",
}
namelevi3={" ",
" ",
" ",
" ",
" ",
}
namelevi4={" ",
" ",
" ",
" ",
" ",
}
if (levi1var==nil or levi1var=={}) then levi1var={1,
2,
3,
}
end
if (levi2var==nil or levi2var=={}) then levi2var={1,
2,
3,
4,
5,
}
end
if (levi3var==nil or levi3var=={}) then levi3var={1,
}
end
if (levi4var==nil or levi4var=={}) then levi4var={1,
2,
3,
4,
5,
6,
}
end
psleviaddtextfr()
zagrraidroster()
namelevi4[6]=namelevi3[levi3var[1]]
openmenuLevi11()
openmenuLevi12()
openmenuLevi13()
openmenuLevi21()
openmenuLevi22()
openmenuLevi23()
openmenuLevi24()
openmenuLevi25()
openmenuLevi31()
openmenuLevi41()
openmenuLevi42()
openmenuLevi43()
openmenuLevi44()
openmenuLevi45()
openmenuLevi46()
openmenulevichat1()
openmenulevichat2()
PSFmain8_Button442:Show()
PSFmain8_Button443:Show()
if(pslevibot) then PSFmain8_Button446:Show() else PSFmain8_Button444:Show() end
PSFmain8_Button445:Show()
else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psnotinraid)
end
end






function openmenuLevi11()
if not DropDownMenuLevi11 then
CreateFrame("Frame", "DropDownMenuLevi11", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi11,159,-55,namelevi1,levi1var[1],1,1)
end

function openmenuLevi12()
if not DropDownMenuLevi12 then
CreateFrame("Frame", "DropDownMenuLevi12", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi12,272,-55,namelevi1,levi1var[2],1,2)
end

function openmenuLevi13()
if not DropDownMenuLevi13 then
CreateFrame("Frame", "DropDownMenuLevi13", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi13,385,-55,namelevi1,levi1var[3],1,3)
end


function changeotherlevi11(changelevi, changelevi2)
if(levi1var[1]==changelevi)then levi1var[1]=changelevi2 openmenuLevi11()
elseif(levi1var[2]==changelevi)then levi1var[2]=changelevi2 openmenuLevi12()
elseif(levi1var[3]==changelevi)then levi1var[3]=changelevi2 openmenuLevi13()
end
end


function changeotherlevi21(changelevi, changelevi2)
if(levi2var[1]==changelevi)then levi2var[1]=changelevi2 openmenuLevi21()
elseif(levi2var[2]==changelevi)then levi2var[2]=changelevi2 openmenuLevi22()
elseif(levi2var[3]==changelevi)then levi2var[3]=changelevi2 openmenuLevi23()
elseif(levi2var[4]==changelevi)then levi2var[4]=changelevi2 openmenuLevi24()
elseif(levi2var[5]==changelevi)then levi2var[5]=changelevi2 openmenuLevi25()
end
end


function changeotherlevi41(changelevi, changelevi2)
if(levi4var[1]==changelevi)then levi4var[1]=changelevi2 openmenuLevi41()
elseif(levi4var[2]==changelevi)then levi4var[2]=changelevi2 openmenuLevi42()
elseif(levi4var[3]==changelevi)then levi4var[3]=changelevi2 openmenuLevi43()
elseif(levi4var[4]==changelevi)then levi4var[4]=changelevi2 openmenuLevi44()
elseif(levi4var[5]==changelevi)then levi4var[5]=changelevi2 openmenuLevi45()
elseif(levi4var[6]==changelevi)then levi4var[6]=changelevi2 openmenuLevi46()
end
end



function openmenuLevi21()
if not DropDownMenuLevi21 then
CreateFrame("Frame", "DropDownMenuLevi21", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi21,120,-81,namelevi2,levi2var[1],2,1)
end



function openmenuLevi22()
if not DropDownMenuLevi22 then
CreateFrame("Frame", "DropDownMenuLevi22", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi22,205,-81,namelevi2,levi2var[2],2,2)
end


function openmenuLevi23()
if not DropDownMenuLevi23 then
CreateFrame("Frame", "DropDownMenuLevi23", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi23,70,-260,namelevi2,levi2var[3],2,3)
end



function openmenuLevi24()
if not DropDownMenuLevi24 then
CreateFrame("Frame", "DropDownMenuLevi24", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi24,225,-260,namelevi2,levi2var[4],2,4)
end



function openmenuLevi25()
if not DropDownMenuLevi25 then
CreateFrame("Frame", "DropDownMenuLevi25", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi25,380,-260,namelevi2,levi2var[5],2,5)
end


function openmenuLevi31()
if not DropDownMenuLevi31 then
CreateFrame("Frame", "DropDownMenuLevi31", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi31,170,-131,namelevi3,levi3var[1],3,1)
end



--десант


function openmenuLevi41()
if not DropDownMenuLevi41 then
CreateFrame("Frame", "DropDownMenuLevi41", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi41,85,-210,namelevi4,levi4var[1],4,1)
end

function openmenuLevi42()
if not DropDownMenuLevi42 then
CreateFrame("Frame", "DropDownMenuLevi42", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi42,198,-210,namelevi4,levi4var[2],4,2)
end

function openmenuLevi43()
if not DropDownMenuLevi43 then
CreateFrame("Frame", "DropDownMenuLevi43", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi43,311,-210,namelevi4,levi4var[3],4,3)
end

function openmenuLevi44()
if not DropDownMenuLevi44 then
CreateFrame("Frame", "DropDownMenuLevi44", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi44,85,-235,namelevi4,levi4var[4],4,4)
end

function openmenuLevi45()
if not DropDownMenuLevi45 then
CreateFrame("Frame", "DropDownMenuLevi45", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi45,198,-235,namelevi4,levi4var[5],4,5)
end

function openmenuLevi46()
if not DropDownMenuLevi46 then
CreateFrame("Frame", "DropDownMenuLevi46", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmake(DropDownMenuLevi46,311,-235,namelevi4,levi4var[6],4,6)
end


function PSF_buttonlevi1rep()
PSF_getnamelevi()
psfchatsendreports(wherereportlevichat1, psullevitxt1, psullevitxt2..", {rt5}"..nick[1]..", {rt2}"..nick[2]..", {rt6}"..nick[3].." "..psulleviinfo3, psullevitxt3..", "..nick[4]..", "..nick[5].." "..psulleviinfo5..".", psullevitxt4, psullevitxt5.." "..nick[6].." "..psulleviinfo8..".")
end


function PSF_buttonlevi2rep()
PSF_getnamelevi()
psfchatsendreports(wherereportlevichat2, psullevitxt6..": {rt4}"..nick[7]..", {rt3}"..nick[8]..", {rt1}"..nick[9].." ("..psullevitxt8..").", psullevitxt6..": {rt4}"..nick[10]..", {rt3}"..nick[11]..", {rt1}"..nick[12]..".", psulleviinfo11.." "..nick[13].." {rt4} "..psullevito.." {rt5}.   "..nick[14].." {rt3} "..psullevito.." {rt2}.   "..nick[15].." {rt1} "..psullevito.." {rt6}.")
end



function PSF_getnamelevi()
pslocaleuldalevi()
for i = 1,3 do
if levi1var[i]==1 then nick[i]=namelevi1[1]
elseif levi1var[i]==2 then nick[i]=namelevi1[2]
elseif levi1var[i]==3 then nick[i]=namelevi1[3]
elseif levi1var[i]==4 then nick[i]=namelevi1[4]
elseif levi1var[i]==5 then nick[i]=namelevi1[5] end
end

for i = 1,2 do
if levi2var[i]==1 then nick[i+3]=namelevi2[1]
elseif levi2var[i]==2 then nick[i+3]=namelevi2[2]
elseif levi2var[i]==3 then nick[i+3]=namelevi2[3]
elseif levi2var[i]==4 then nick[i+3]=namelevi2[4]
elseif levi2var[i]==5 then nick[i+3]=namelevi2[5] end
end

nick[6]=namelevi3[levi3var[1]]

for i = 1,6 do
if levi4var[i]==1 then nick[i+6]=namelevi4[1]
elseif levi4var[i]==2 then nick[i+6]=namelevi4[2]
elseif levi4var[i]==3 then nick[i+6]=namelevi4[3]
elseif levi4var[i]==4 then nick[i+6]=namelevi4[4]
elseif levi4var[i]==5 then nick[i+6]=namelevi4[5]
elseif levi4var[i]==6 then nick[i+6]=namelevi4[6] end
end

for i = 1,3 do
if levi2var[i+2]==1 then nick[i+12]=namelevi2[1]
elseif levi2var[i+2]==2 then nick[i+12]=namelevi2[2]
elseif levi2var[i+2]==3 then nick[i+12]=namelevi2[3]
elseif levi2var[i+2]==4 then nick[i+12]=namelevi2[4]
elseif levi2var[i+2]==5 then nick[i+12]=namelevi2[5] end
end

end



function openmenulevichat1()
if not DropDownMenulevichat1 then
CreateFrame("Frame", "DropDownMenulevichat1", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmakechat(DropDownMenulevichat1,103,-162,wherereportlevichat1,1)
end

function openmenulevichat2()
if not DropDownMenulevichat2 then
CreateFrame("Frame", "DropDownMenulevichat2", PSFmain8, "UIDropDownMenuTemplate")
end
pslevidropmakechat(DropDownMenulevichat2,103,-292,wherereportlevichat2,2)
end



function PSF_buttonlevi1wisp()

PSF_getnamelevi()
for i = 1,40 do local name,rank,subgroup = GetRaidRosterInfo(i) if subgroup==1 then
if name==nil then else SendChatMessage("PhoenixStyle > "..pslevirol1, "WHISPER", nil, name) end
elseif subgroup==2 then
if (name==nick[1] or name==nick[2] or name==nick[3] or name==nil) then else SendChatMessage("PhoenixStyle > "..pslevirol2, "WHISPER", nil, name) end
elseif subgroup==5 then
if (name==nick[6] or name==nil) then else SendChatMessage("PhoenixStyle > "..pslevirol3, "WHISPER", nil, name) end
end --ifsubg
end --fori
if nick[1]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol4.." {rt5}, "..pslevirol5, "WHISPER", nil, nick[1]) end
if nick[2]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol4.." {rt2}, "..pslevirol5, "WHISPER", nil, nick[2]) end
if nick[3]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol4.." {rt6}, "..pslevirol5, "WHISPER", nil, nick[3]) end

if nick[4]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol6, "WHISPER", nil, nick[4]) end
if nick[5]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol6, "WHISPER", nil, nick[5]) end

if nick[13]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol7.." {rt4} "..pslevirol8.." {rt5}.", "WHISPER", nil, nick[13]) end
if nick[14]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol7.." {rt3} "..pslevirol8.." {rt2}.", "WHISPER", nil, nick[14]) end
if nick[15]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol7.." {rt1} "..pslevirol8.." {rt6}.", "WHISPER", nil, nick[15]) end

if nick[7]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol9.." {rt5} "..pslevirol11.." "..nick[13].." "..pslevirol13, "WHISPER", nil, nick[7]) end
if nick[8]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol9.." {rt2} "..pslevirol11.." "..nick[14].." "..pslevirol13, "WHISPER", nil, nick[8]) end
if nick[9]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol9.." {rt6} "..pslevirol11.." "..nick[15].." "..pslevirol13, "WHISPER", nil, nick[9]) end
if nick[10]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol10.." {rt5} "..pslevirol12.." "..nick[13].." "..pslevirol13, "WHISPER", nil, nick[10]) end
if nick[11]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol10.." {rt2} "..pslevirol12.." "..nick[14].." "..pslevirol13, "WHISPER", nil, nick[11]) end
if nick[12]==" " then else SendChatMessage("PhoenixStyle > "..pslevirol10.." {rt6} "..pslevirol12.." "..nick[15].." "..pslevirol13, "WHISPER", nil, nick[12]) end

end



function PSF_buttonleviautobotoff()
PSFmain8_Button446:Hide()
PSFmain8_Button444:Show()
pslevibot=false
ifwaslevi=0
leviboyinterr=0
timetocheck=0
timelastlevireload=0
kakayavisadka=1
out("|cff99ffffPhoenixStyle|r - "..pslevibot1.." |cffff0000"..pslevibotoff.."|r")
end


function PSF_buttonleviautoboton()
if(IsRaidOfficer()==1) then
if (isbattlev==0) then
if (GetNumRaidMembers() > 8) then

PSFmain8_Button444:Hide()
PSFmain8_Button446:Show()
pslevibot=true
out("|cff99ffffPhoenixStyle|r - "..pslevibot1.." |cff00ff00"..psleviboton.."|r "..psleviboton2)

else out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psleviboterr1) end --конец проверки на 8 тел
else out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psleviboterr2) end --конец проверки на бой
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psleviboterr3)
end--raidoff
end


function psfleverezetwin()
out ("|cff99ffffPhoenixStyle|r - "..pslevibotwin)
PSFmain8_Button446:Hide()
PSFmain8_Button444:Show()
pslevibot=false
ifwaslevi=0
leviboyinterr=0
timetocheck=0
timelastlevireload=0
kakayavisadka=1
end

function psfleverezetvipe()
out ("|cff99ffffPhoenixStyle|r - "..pslevibotwipe)
ifwaslevi=0
leviboyinterr=0
timetocheck=0
timelastlevireload=0
kakayavisadka=1
end

function psflevimarksdown()
for i = 1,6 do
SetRaidTarget(nick[i+6], 0)
end
end


function pslevidropmake(aa,ww,hh,ii,ss,qq,ee)

aa:ClearAllPoints()
aa:SetPoint("TOPLEFT", ww, hh)
aa:Show()

local items = ii

local function OnClick(self)
UIDropDownMenu_SetSelectedID(aa, self:GetID())

if qq==1 then
changeotherlevi11(self:GetID(), levi1var[ee])
levi1var[ee]=self:GetID()
elseif qq==2 then
changeotherlevi21(self:GetID(), levi2var[ee])
levi2var[ee]=self:GetID()
elseif qq==3 then
if(self:GetID()==1)then namelevi4[6]=namelevi3[1] levi3var[1]=1
elseif(self:GetID()==2)then namelevi4[6]=namelevi3[2] levi3var[1]=2
elseif(self:GetID()==3)then namelevi4[6]=namelevi3[3] levi3var[1]=3
elseif(self:GetID()==4)then namelevi4[6]=namelevi3[4] levi3var[1]=4
elseif(self:GetID()==5)then namelevi4[6]=namelevi3[5] levi3var[1]=5
end
openmenuLevi41()
openmenuLevi42()
openmenuLevi43()
openmenuLevi44()
openmenuLevi45()
openmenuLevi46()
elseif qq==4 then
changeotherlevi41(self:GetID(), levi4var[1])
levi4var[1]=self:GetID()

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

UIDropDownMenu_Initialize(aa, initialize)
UIDropDownMenu_SetWidth(aa, 70);
UIDropDownMenu_SetButtonWidth(aa, 85)
UIDropDownMenu_SetSelectedID(aa, ss)
UIDropDownMenu_JustifyText(aa, "LEFT")
end

function psleviaddtextfr()
if psllleeevvi==nil then
psllleeevvi=1

--группы
local pstabtodraw={psulleviinfo1,psulleviinfo2,psulleviinfo4,psulleviinfo6,psulleviinfo7,psulleviinfo9,psulleviinfo10,psulleviinfo11}
local p=-41
for i=1,8 do
local t = PSFmain8:CreateFontString()
t:SetFont(GameFontNormalSmall:GetFont(), 10)
t:SetPoint("TOPLEFT",16,p)
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(pstabtodraw[i])
t:SetJustifyH("LEFT")
p=p-25
if i==5 then p=p-55 end
end

--3 надписи
local pstabtodraw={psulleviinfo3,psulleviinfo5,psulleviinfo8}
local p={{493,-66},{311,-91},{276,-141}}
for i=1,3 do
local t = PSFmain8:CreateFontString()
t:SetFont(GameFontNormalSmall:GetFont(), 10)
t:SetPoint("TOPLEFT",p[i][1],p[i][2])
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(pstabtodraw[i])
t:SetJustifyH("LEFT")
end

--сообщ в чат
for i=1,2 do
local t = PSFmain8:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",16,-41-130*i)
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(psulsendto)
t:SetJustifyH("LEFT")
end

--на
for i=1,3 do
local t = PSFmain8:CreateFontString()
t:SetFont(GameFontNormalSmall:GetFont(), 10)
t:SetPoint("TOPLEFT",41+155*i,-271)
t:SetTextColor(GameFontNormal:GetTextColor())
t:SetText(psullevito)
t:SetJustifyH("CENTER")
end


--значки
local d={{5,155,-59},{2,268,-59},{6,381,-59},{4,176,-264},{5,211,-264},{3,331,-264},{2,366,-264},{1,486,-264},{6,521,-264},{4,80,-214},{4,80,-239},{3,195,-214},{3,195,-239},{1,307,-214},{1,307,-239}}
for i=1,15 do
local t = PSFmain8:CreateTexture(nil,"OVERLAY")
t:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_"..d[i][1])
t:SetPoint("TOPLEFT",d[i][2],d[i][3])
t:SetWidth(20)
t:SetHeight(20)
end


end
end