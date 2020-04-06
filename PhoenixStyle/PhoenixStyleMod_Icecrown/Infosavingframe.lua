psiccsavfile=1
function psiccaftcombop()
PSF_closeallpr()
PSFiccaftercombinfoframe:Show()

PSFiccaftercombinfoframe_edbox2:SetText("")
PSFiccaftercombinfoframe_Button2:Hide()
PSFiccaftercombinfoframe_Button1:Show()

if psflanadrawinf==nil then
psflanadrawinf=1

local v = PSFiccaftercombinfoframe:CreateFontString()
v:SetWidth(550)
v:SetHeight(20)
v:SetFont(GameFontNormal:GetFont(), 12)
v:SetPoint("TOPLEFT",25,-328)
v:SetJustifyH("LEFT")
v:SetJustifyV("TOP")
v:SetText(psiccwhispertxt)

local s = PSFiccaftercombinfoframe:CreateFontString()
s:SetWidth(550)
s:SetHeight(20)
s:SetFont(GameFontNormal:GetFont(), 12)
s:SetPoint("TOPLEFT",25,-277)
s:SetJustifyH("LEFT")
s:SetJustifyV("TOP")
s:SetText(psiccwhispertxt2)

psiccinfscroll = CreateFrame("ScrollFrame", "psiccinfscroll", PSFiccaftercombinfoframe, "UIPanelScrollFrameTemplate")
psiccinfscroll:SetPoint("TOPLEFT", PSFiccaftercombinfoframe, "TOPLEFT", 20, -60)
psiccinfscroll:SetHeight(210)
psiccinfscroll:SetWidth(545)

psiccinfframe = CreateFrame("EditBox", "psiccinfframe", psiccinfscroll)
psiccinfframe:SetPoint("TOPRIGHT", psiccinfscroll, "TOPRIGHT", 0, 0)
psiccinfframe:SetPoint("TOPLEFT", psiccinfscroll, "TOPLEFT", 0, 0)
psiccinfframe:SetPoint("BOTTOMRIGHT", psiccinfscroll, "BOTTOMRIGHT", 0, 0)
psiccinfframe:SetPoint("BOTTOMLEFT", psiccinfscroll, "BOTTOMLEFT", 0, 0)
psiccinfframe:SetScript("onescapepressed", function(self) psiccinfframe:ClearFocus() end)
psiccinfframe:SetFont(GameFontNormal:GetFont(), 12)
psiccinfframe:SetMultiLine()
psiccinfframe:SetAutoFocus(false)
psiccinfframe:SetHeight(555)
psiccinfframe:SetWidth(545)
psiccinfframe:Show()
psiccinfframe:SetText(pcicccombat4)

psiccinfscroll:SetScrollChild(psiccinfframe)
psiccinfscroll:Show()


--txt & slider
psiccbytimtxt = PSFiccaftercombinfoframe:CreateFontString()
psiccbytimtxt:SetWidth(200)
psiccbytimtxt:SetHeight(40)
psiccbytimtxt:SetFont(GameFontNormal:GetFont(), 12)
psiccbytimtxt:SetPoint("TOPLEFT",355,-15)
psiccbytimtxt:SetJustifyH("LEFT")
psiccbytimtxt:SetJustifyV("TOP")

getglobal("PSFiccaftercombinfoframe_Combatsvd1High"):SetText("30")
getglobal("PSFiccaftercombinfoframe_Combatsvd1Low"):SetText("3")
PSFiccaftercombinfoframe_Combatsvd1:SetMinMaxValues(3, 30)
PSFiccaftercombinfoframe_Combatsvd1:SetValueStep(1)
PSFiccaftercombinfoframe_Combatsvd1:SetValue(psicccombatsvqu)
psicccombqcha()


PSFiccaftercombinfoframe_edbox2:SetScript("OnTextChanged", function(self) if string.len(PSFiccaftercombinfoframe_edbox2:GetText())>1 then PSFiccaftercombinfoframe_Button2:Show() PSFiccaftercombinfoframe_Button1:Hide() else PSFiccaftercombinfoframe_Button2:Hide() PSFiccaftercombinfoframe_Button1:Show() end end )


end

openiccbosschsv()
openicclogfailchat()
psiccinfosvshow(psiccsv1)

end

function psicccombqcha()
psicccombatsvqu = PSFiccaftercombinfoframe_Combatsvd1:GetValue()
local text=psicctxtbysaved..psicccombatsvqu
psiccbytimtxt:SetText(text)
end


function openiccbosschsv()
if not DropDowniccbosschsv then
CreateFrame("Frame", "DropDowniccbosschsv", PSFiccaftercombinfoframe, "UIDropDownMenuTemplate")
end

DropDowniccbosschsv:ClearAllPoints()
DropDowniccbosschsv:SetPoint("TOPLEFT", 5, -20)
DropDowniccbosschsv:Show()

local items = {}

if #psiccsavedfails[1] == 0 then
table.wipe(items)
items = {pcicccombat4}
else

local text=""
local _, month, day, year = CalendarGetDate()
if month<10 then month="0"..month end
if day<10 then day="0"..day end
if year>2000 then year=year-2000 end
local text=month.."/"..day.."/"..year


table.wipe(items)
	for j=1,#psiccsavedfails[1] do
		local slojn=""
		if psiccsavedfails[3][j]~="0" then
			slojn=" ("..psiccsavedfails[3][j]..")"
		end

		if string.find(psiccsavedfails[2][j], text) then
			items[j]=psiccsavedfails[1][j]..slojn..", "..string.sub(psiccsavedfails[2][j],1,string.find(psiccsavedfails[2][j],",")-1)
		else
			items[j]=psiccsavedfails[1][j]..slojn..", "..psiccsavedfails[2][j]
		end
	end
end

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDowniccbosschsv, self:GetID())

psiccsv1=self:GetID()
psiccinfosvshow(psiccsv1)
psiccinfframe:HighlightText(0,0)
psiccinfframe:ClearFocus()
if string.len(PSFiccaftercombinfoframe_edbox2:GetText())>1 then PSFiccaftercombinfoframe_Button2:Show() PSFiccaftercombinfoframe_Button1:Hide() else PSFiccaftercombinfoframe_Button2:Hide() PSFiccaftercombinfoframe_Button1:Show() end


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

if psiccsv1==nil then
psiccsv1=1
end

UIDropDownMenu_Initialize(DropDowniccbosschsv, initialize)
UIDropDownMenu_SetWidth(DropDowniccbosschsv, 245)
UIDropDownMenu_SetButtonWidth(DropDowniccbosschsv, 260)
UIDropDownMenu_SetSelectedID(DropDowniccbosschsv, psiccsv1)
UIDropDownMenu_JustifyText(DropDowniccbosschsv, "LEFT")
end


function openicclogfailchat()
if not DropDownicclogfailchat then
CreateFrame("Frame", "DropDownicclogfailchat", PSFiccaftercombinfoframe, "UIDropDownMenuTemplate")
end

DropDownicclogfailchat:ClearAllPoints()
DropDownicclogfailchat:SetPoint("TOPLEFT", 10, -290)
DropDownicclogfailchat:Show()

local items = bigmenuchatlist

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownicclogfailchat, self:GetID())

if self:GetID()>8 then
psicdopmodchat[3]=psfchatadd[self:GetID()-8]
else
psicdopmodchat[3]=bigmenuchatlisten[self:GetID()]
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

bigmenuchat2(psicdopmodchat[3])
	if bigma2num==0 then
psicdopmodchat[3]=bigmenuchatlisten[1]
bigma2num=1
	end

UIDropDownMenu_Initialize(DropDownicclogfailchat, initialize)
UIDropDownMenu_SetWidth(DropDownicclogfailchat, 110)
UIDropDownMenu_SetButtonWidth(DropDownicclogfailchat, 125)
UIDropDownMenu_SetSelectedID(DropDownicclogfailchat, bigma2num)
UIDropDownMenu_JustifyText(DropDownicclogfailchat, "LEFT")
end



function psiccsavinginf(bosss)
if bosss==nil then bosss=psiccunknown end

--босс
table.insert(psiccsavedfails[1],1,bosss)

local text2=""
local _, month, day, year = CalendarGetDate()
if month<10 then month="0"..month end
if day<10 then day="0"..day end
if year>2000 then year=year-2000 end
local h,m = GetGameTime()
if h<10 then h="0"..h end
if m<10 then m="0"..m end
local text2=h..":"..m..", "..month.."/"..day.."/"..year

table.insert(psiccsavedfails[2],1,text2)

--hard normal
table.insert(psiccsavedfails[3],1,psiccinst)

--хз что пока
table.insert(psiccsavedfails[4],1,"0")

for i=5,#psiccsavedfails do
	if psiccsavedfails[i] then
	if #psiccsavedfails[i]<#psiccsavedfails[1] then
		table.insert(psiccsavedfails[i],1,"0")
	end
	end
end


for j=1,#psiccsavedfails do
	if #psiccsavedfails[j]>psicccombatsvqu then
		for tvb=(psicccombatsvqu+1),#psiccsavedfails[j] do
			psiccsavedfails[j][tvb]=nil
		end
	end
end

--запись в рск если есть
if rscversion and rscversion>1.003 then
rscbossfrompssave(bosss,h..":"..m)
end


end

function psiccrefsvin()
if PSFiccaftercombinfoframe then
psiccsv1=1
openiccbosschsv()
psiccinfosvshow(1)
end
end


function psiccinfosvshow(nr)
if PSFiccaftercombinfoframe and psiccinfframe then
if #psiccsavedfails[1]==0 then
psiccinfframe:SetText(pcicccombat4)
else
local text=""
for i=5,#psiccsavedfails do
	if psiccsavedfails[i][nr] then
		if psiccsavedfails[i][nr]~="0" then
			if (string.find(psiccsavedfails[i][nr], "{")==1) then
				if (string.find(psiccsavedfails[i][nr], "} ")) then
					text=text.."- "..string.sub(psiccsavedfails[i][nr], string.find(psiccsavedfails[i][nr], "} ")+2).."\r\n"
				else
					text=text.."- "..string.sub(psiccsavedfails[i][nr], string.find(psiccsavedfails[i][nr], "}")+1).."\r\n"
				end
			else
				text=text..psiccsavedfails[i][nr].."\r\n"
			end
		end
	end
end

if string.len(text)>5 then
psiccinfframe:SetText(text)
else
psiccinfframe:SetText(pcicccombat4)
end



end
end
end


function psiccsavedinforeport(nn)
--nn - 1 в чат, 2 в приват
if #psiccsavedfails[1]>0 then

local txtboss=psiccinfoabsv.." "



local text=""
local _, month, day, year = CalendarGetDate()
if month<10 then month="0"..month end
if day<10 then day="0"..day end
if year>2000 then year=year-2000 end
local text=month.."/"..day.."/"..year


		local slojn=""
		if psiccsavedfails[3][psiccsv1]~="0" then
			slojn=" ("..psiccsavedfails[3][psiccsv1]..")"
		end

		if string.find(psiccsavedfails[2][psiccsv1], text) then
			txtboss=txtboss..psiccsavedfails[1][psiccsv1]..slojn..", "..string.sub(psiccsavedfails[2][psiccsv1],1,string.find(psiccsavedfails[2][psiccsv1],",")-1)
		else
			txtboss=txtboss..psiccsavedfails[1][psiccsv1]..slojn..", "..psiccsavedfails[2][psiccsv1]
		end


if nn==1 then
psfchatsendreports(psicdopmodchat[3], txtboss, psiccsavedfails[5][psiccsv1], psiccsavedfails[6][psiccsv1], psiccsavedfails[7][psiccsv1], psiccsavedfails[8][psiccsv1], psiccsavedfails[9][psiccsv1], psiccsavedfails[10][psiccsv1], psiccsavedfails[11][psiccsv1], psiccsavedfails[12][psiccsv1],psiccsavedfails[13][psiccsv1],psiccsavedfails[14][psiccsv1],psiccsavedfails[15][psiccsv1])
end
if nn==2 then
psfchatsendreports("whisper", txtboss, psiccsavedfails[5][psiccsv1], psiccsavedfails[6][psiccsv1], psiccsavedfails[7][psiccsv1], psiccsavedfails[8][psiccsv1], psiccsavedfails[9][psiccsv1], psiccsavedfails[10][psiccsv1], psiccsavedfails[11][psiccsv1], psiccsavedfails[12][psiccsv1],psiccsavedfails[13][psiccsv1],psiccsavedfails[14][psiccsv1],psiccsavedfails[15][psiccsv1],PSFiccaftercombinfoframe_edbox2:GetText())
end


end
PSFiccaftercombinfoframe_edbox2:ClearFocus()
end

function pssvinforezet()
psiccsavedfails={{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}
psiccsv1=1
openiccbosschsv()
psiccinfosvshow(1)
end


function pssvinfoalltog(onlytoday)
if #psiccsavedfails[1]>0 then
local txttoshow=""

for i=1,#psiccsavedfails[1] do
	local text=""
	local _, month, day, year = CalendarGetDate()
	if month<10 then month="0"..month end
	if day<10 then day="0"..day end
	if year>2000 then year=year-2000 end
	local text=month.."/"..day.."/"..year


	local slojn=""
	if psiccsavedfails[3][i]~="0" then
		slojn=" ("..psiccsavedfails[3][i]..")"
	end

if onlytoday==nil or (onlytoday and string.find(psiccsavedfails[2][i], text)) then

	if i>1 then txttoshow=txttoshow.."\r\n\r\n" end

	txttoshow=txttoshow..psiccinfoabsv.." "

	if string.find(psiccsavedfails[2][i], text) then
		txttoshow=txttoshow..psiccsavedfails[1][i]..slojn..", "..string.sub(psiccsavedfails[2][i],1,string.find(psiccsavedfails[2][i],",")-1)
	else
		txttoshow=txttoshow..psiccsavedfails[1][i]..slojn..", "..psiccsavedfails[2][i]
	end
	txttoshow=txttoshow.."\r\n"

	local somethingadded=0

	for u=5,15 do
		if psiccsavedfails[u][i] and string.len(psiccsavedfails[u][i])>6 then
			somethingadded=1
			if (string.find(psiccsavedfails[u][i], "{")==1) then
				if (string.find(psiccsavedfails[u][i], "} ")) then
					txttoshow=txttoshow.."- "..string.sub(psiccsavedfails[u][i], string.find(psiccsavedfails[u][i], "} ")+2).."\r\n"
				else
					txttoshow=txttoshow.."- "..string.sub(psiccsavedfails[u][i], string.find(psiccsavedfails[u][i], "}")+1).."\r\n"
				end
			else
				txttoshow=txttoshow..psiccsavedfails[u][i].."\r\n"
			end
		end
	end

	if somethingadded==0 then
		txttoshow=txttoshow..pcicccombat4.."\r\n"
	end




end --onlytoday
end --for i

if string.len(txttoshow)>6 then
psiccinfframe:SetText(txttoshow)
else
psiccinfframe:SetText(pcicccombat4)
end

PSFiccaftercombinfoframe_Button1:Hide()
PSFiccaftercombinfoframe_Button2:Hide()
psiccinfframe:SetFocus()
psiccinfframe:HighlightText()



end
end