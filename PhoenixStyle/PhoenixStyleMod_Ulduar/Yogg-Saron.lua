function PSF_yogglastraid()
if GetNumRaidMembers() > 0 then
if (PSFmain11_primyogg:GetText() == "") then primyogg="" else
	primyogg=PSFmain11_primyogg:GetText()
	end
PSFmain11_CheckButton1:Show()
PSFmain11_CheckButton2:Show()
PSFmain11_CheckButton3:Show()
PSFmain11_CheckButton4:Show()
PSFmain11_CheckButton5:Show()
PSFmain11_Button2:Show()
PSFmain11_Button3:Show()
PSFmain11_Button4:Show()
PSFmain11_Button5:Show()
PSFmain11_Button6:Show()
PSFmain11_Button7:Show()
PSFmain11_primyogg:Show()
PSFmain11_primyogg:SetText(primyogg)

portalboss={"        1",
"     2    6",
"   3        7",
" 4 "..psulyoggboss.." 8",
"   5       9",
"      10",
}
portal1={"{rt8}"..psulyoggimg2,
"      4      5",
"  3              6",
"  2              7",
"      1      8",
"         ↑↑",
}
portal2={"{rt7}"..psulyoggimg3,
"             6",
"           4 5",
"   3     .     .      8",
" 1 2    .     .    7 9",
" ",
"           ↑↑",
}
portal3={"{rt4}"..psulyoggimg4,
"          4  5",
"       3        6",
"    2              7",
" ",
"       1        8",
"           ↑↑",
}
yoggspisokraid={psulyoggempty,
}
for i,mnogogrup2 in ipairs(yoggspisokp) do yoggraidadd(mnogogrup2)
if(mnogogrup2==1)then PSFmain11_CheckButton1:SetChecked() end
if(mnogogrup2==2)then PSFmain11_CheckButton2:SetChecked() end
if(mnogogrup2==3)then PSFmain11_CheckButton3:SetChecked() end
if(mnogogrup2==4)then PSFmain11_CheckButton4:SetChecked() end
if(mnogogrup2==5)then PSFmain11_CheckButton5:SetChecked() end
end

PSFreloadyoggmenu()
else
out ("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psnotinraid)
end
end


function PSF_yoggrezet()
PSFmain11_CheckButton1:SetChecked(false)
PSFmain11_CheckButton2:SetChecked(false)
PSFmain11_CheckButton3:SetChecked(false)
PSFmain11_CheckButton4:SetChecked(false)
PSFmain11_CheckButton5:SetChecked(false)
yoggvar=nil
yoggvar2=nil
primyogg=""
PSFmain11_primyogg:SetText(primyogg)
yoggspisokp={}
yoggspisokraid={psulyoggempty,
}
PSFreloadyoggmenu()
end


function PSF_yoggp1()
	if (PSFmain11_CheckButton1:GetChecked()) then
	yoggpadd(1)
	yoggraidadd(1)
	else
	yoggpremove(1)
	end
yoggtableraidref()
PSFreloadyoggmenu()
end
function PSF_yoggp2()
	if (PSFmain11_CheckButton2:GetChecked()) then
	yoggpadd(2)
	yoggraidadd(2)
	else
	yoggpremove(2)
	end
yoggtableraidref()
PSFreloadyoggmenu()
end
function PSF_yoggp3()
	if (PSFmain11_CheckButton3:GetChecked()) then
	yoggpadd(3)
	yoggraidadd(3)
	else
	yoggpremove(3)
	end
yoggtableraidref()
PSFreloadyoggmenu()
end
function PSF_yoggp4()
	if (PSFmain11_CheckButton4:GetChecked()) then
	yoggpadd(4)
	yoggraidadd(4)
	else
	yoggpremove(4)
	end
yoggtableraidref()
PSFreloadyoggmenu()
end
function PSF_yoggp5()
	if (PSFmain11_CheckButton5:GetChecked()) then
	yoggpadd(5)
	yoggraidadd(5)
	else
	yoggpremove(5)
	end
yoggtableraidref()
PSFreloadyoggmenu()
end




function yoggpadd(nomergr)
table.insert(yoggspisokp,nomergr)
end

function yoggpremove(nomergr)
for i,mnogogrup in ipairs(yoggspisokp) do if mnogogrup == nomergr then table.remove(yoggspisokp, i) end end
end

function yoggraidadd(nomergr)
for i = 1,40 do local name,rank,subgroup = GetRaidRosterInfo(i) if (subgroup == nomergr) then table.insert(yoggspisokraid,name) end end
end

function yoggtableraidref()
yoggspisokraid={psulyoggempty,
}
for i,mnogogrup in ipairs(yoggspisokp) do yoggraidadd(mnogogrup) end
end






function changeYoggraid(changeyogg, changeyogg2, changeyogg3)
local chtosovpalo
if(changeyogg==1) then
else
for i,mnogogrup3 in ipairs(yoggvar) do if mnogogrup3 == changeyogg then chtosovpalo=i yoggvar[i]=changeyogg2 yoggvar2[i]=changeyogg3 end end
end
if(chtosovpalo==1)then openmenuyogg1()
elseif(chtosovpalo==2)then openmenuyogg2()
elseif(chtosovpalo==3)then openmenuyogg3()
elseif(chtosovpalo==4)then openmenuyogg4()
elseif(chtosovpalo==5)then openmenuyogg5()
elseif(chtosovpalo==6)then openmenuyogg6()
elseif(chtosovpalo==7)then openmenuyogg7()
elseif(chtosovpalo==8)then openmenuyogg8()
elseif(chtosovpalo==9)then openmenuyogg9()
elseif(chtosovpalo==10)then openmenuyogg10()
end end


function PSFreloadyoggmenu()
yoggskokaraidspisok= # yoggspisokraid
if(yoggvar=={} or yoggvar==nil) then yoggvar = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11} end
if(yoggvar2=={} or yoggvar2==nil) then yoggvar2 = {45, 45, 45, 45, 45, 45, 45, 45, 45, 45} end
psyoggcretext()
openmenuyogg1()
openmenuyogg2()
openmenuyogg3()
openmenuyogg4()
openmenuyogg5()
openmenuyogg6()
openmenuyogg7()
openmenuyogg8()
openmenuyogg9()
openmenuyogg10()
openmenuyogg11()
openmenuyoggchat1()
end


function openmenuyogg1()
if not DropDownMenuYogg1 then
CreateFrame("Frame", "DropDownMenuYogg1", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg1,95,-95,1,1)
end

function openmenuyogg2()
if not DropDownMenuYogg2 then
CreateFrame("Frame", "DropDownMenuYogg2", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg2,50,-120,2,1)
end

function openmenuyogg3()
if not DropDownMenuYogg3 then
CreateFrame("Frame", "DropDownMenuYogg3", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg3,30,-145,3,1)
end

function openmenuyogg4()
if not DropDownMenuYogg4 then
CreateFrame("Frame", "DropDownMenuYogg4", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg4,10,-170,4,1)
end

function openmenuyogg5()
if not DropDownMenuYogg5 then
CreateFrame("Frame", "DropDownMenuYogg5", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg5,40,-195,5,1)
end

function openmenuyogg6()
if not DropDownMenuYogg6 then
CreateFrame("Frame", "DropDownMenuYogg6", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg6,140,-120,6,1)
end

function openmenuyogg7()
if not DropDownMenuYogg7 then
CreateFrame("Frame", "DropDownMenuYogg7", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg7,160,-145,7,1)
end

function openmenuyogg8()
if not DropDownMenuYogg8 then
CreateFrame("Frame", "DropDownMenuYogg8", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg8,180,-170,8,1)
end

function openmenuyogg9()
if not DropDownMenuYogg9 then
CreateFrame("Frame", "DropDownMenuYogg9", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg9,150,-195,9,1)
end

function openmenuyogg10()
if not DropDownMenuYogg10 then
CreateFrame("Frame", "DropDownMenuYogg10", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg10,95,-220,10,1)
end



function openmenuyogg11()
if not DropDownMenuYogg11 then
CreateFrame("Frame", "DropDownMenuYogg11", PSFmain11, "UIDropDownMenuTemplate")
end
psyoggdropmakechat(DropDownMenuYogg11,420,-235,11,2)
end




function openmenuyoggchat1()
if not DropDownMenuyoggchat1 then
CreateFrame("Frame", "DropDownMenuyoggchat1", PSFmain11, "UIDropDownMenuTemplate")
end
pslevidropmakechat(DropDownMenuyoggchat1,409,-30,wherereportyogg,3)
end

function PSF_yoggkart1()
yoggskokap= # portalboss
if(psyoggwisps>1) then
for i = 1,yoggskokap do
SendChatMessage(portalboss[i], "WHISPER", nil, yoggspisokraid[psyoggwisps])
end
else
for i = 1,yoggskokap do
psfchatsendreports(wherereportyogg, portalboss[i])
end
end
end

function PSF_yoggkart2()
yoggskokap= # portal1
if(psyoggwisps>1) then
for i = 1,yoggskokap do
SendChatMessage(portal1[i], "WHISPER", nil, yoggspisokraid[psyoggwisps])
end
else
for i = 1,yoggskokap do
psfchatsendreports(wherereportyogg, portal1[i])
end
end
end

function PSF_yoggkart3()
yoggskokap= # portal2
if(psyoggwisps>1) then
for i = 1,yoggskokap do
SendChatMessage(portal2[i], "WHISPER", nil, yoggspisokraid[psyoggwisps])
end
else
for i = 1,yoggskokap do
psfchatsendreports(wherereportyogg, portal2[i])
end
end
end

function PSF_yoggkart4()
yoggskokap= # portal3
if(psyoggwisps>1) then
for i = 1,yoggskokap do
SendChatMessage(portal3[i], "WHISPER", nil, yoggspisokraid[psyoggwisps])
end
else
for i = 1,yoggskokap do
psfchatsendreports(wherereportyogg, portal3[i])
end
end
end

function PSF_yoggsendnick()
if (PSFmain11_primyogg:GetText() == "") then primyogg="" else
	primyogg=PSFmain11_primyogg:GetText()
	end

for i = 1,10 do
psfchatsendreports(wherereportyogg, i.."  "..yoggspisokraid[yoggvar[i]])
end

if(primyogg=="") then else

psfchatsendreports(wherereportyogg, psulyoggprim2.." "..primyogg)

end
end


function psyoggdropmakechat(aa,ww,hh,nn,qq)
aa:ClearAllPoints()
aa:SetPoint("TOPLEFT", ww, hh)
aa:Show()

local items = yoggspisokraid

local function OnClick(self)
UIDropDownMenu_SetSelectedID(aa, self:GetID())

if qq==1 then
changeYoggraid(self:GetID(), yoggvar[nn], yoggvar2[nn])
yoggvar[nn]=self:GetID()
elseif qq==2 then
psyoggwisps=self:GetID()
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
if qq==1 then
if(yoggvar[nn]>yoggskokaraidspisok) then yoggvar2[nn]=yoggvar[nn] yoggvar[nn]=1 end
if(yoggskokaraidspisok>=yoggvar2[nn]) then yoggvar[nn]=yoggvar2[nn] yoggvar2[nn]=45 end
elseif qq==2 then
psyoggwisps=1
end

UIDropDownMenu_Initialize(aa, initialize)
UIDropDownMenu_SetWidth(aa, 70);
UIDropDownMenu_SetButtonWidth(aa, 85)
if qq==1 then
UIDropDownMenu_SetSelectedID(aa, yoggvar[nn])
elseif qq==2 then
UIDropDownMenu_SetSelectedID(aa, 1)
end
UIDropDownMenu_JustifyText(aa, "LEFT")
end


function psyoggcretext()
if psyyyooogg==nil then
psyyyooogg=1

--номера
local d={{150,-83},{57,-129},{37,-154},{17,-179},{47,-204},{246,-129},{266,-154},{286,-179},{256,-204},{147,-249}}
for i=1,10 do
local t = PSFmain11:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",d[i][1],d[i][2])
t:SetText("|cff00ff00"..i.."|r")
t:SetJustifyH("LEFT")
end







end
end