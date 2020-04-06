function PSF_buttonoffmark()
PSFmain4_Button22:Hide()
PSFmain4_Textmark2:Show()
PSFmain4_Textmark1:Hide()
PSFmain4_Button20:Show()
if(autorefmark) then autorefmark=false out("|cff99ffffPhoenixStyle|r - "..psmarkreflesh.." |cffff0000"..psmarkrefleshoff.."|r.") end
psautomarunfoc()
for i=1,8 do
psautoupok[i]:SetText("|cffff0000-|r")
end
end

function PSF_buttonresetmark()
for i=1,8 do
	for j=1,#pssetmarknew[i] do
		if pssetmarknew[i][j] and UnitExists(pssetmarknew[i][j]) and GetRaidTargetIndex(pssetmarknew[i][j]) then
			SetRaidTarget(pssetmarknew[i][j], 0)
		end
	end
psfautomebtable[i]:SetText("")
psautoupok[i]:SetText("|cffff0000-|r")
end
pssetmarknew={{},{},{},{},{},{},{},{}}
truemark={"false","false","false","false","false","false","false","false"}
psautomarunfoc()
if(autorefmark) then out("|cff99ffffPhoenixStyle|r - "..psmarkreflesh.." |cffff0000"..psmarkrefleshoff.."|r.") end
autorefmark=false
PSFmain4_Button22:Hide()
PSFmain4_Textmark2:Show()
PSFmain4_Textmark1:Hide()
PSFmain4_Button20:Show()
end

function PSF_buttonbeginmark()
if(thisaddonwork) then
if(IsRaidOfficer()==1) then
for te=1,8 do
	if psfautomebtable[te]:GetText() == "" then psautomarchangeno(te) else
	psmarksisinraid(psfautomebtable[te]:GetText(), 1, te)
	end
end

 
psdatrumark=0
for i=1,8 do
if truemark[i]=="true" then psdatrumark=1 end
end

psautomarunfoc()

if (psdatrumark==1) then
if(IsRaidOfficer()==1) then
autorefmark=true
PSFmain4_Button20:Hide()
PSFmain4_Button22:Show()
PSFmain4_Textmark1:Show()
PSFmain4_Textmark2:Hide()
out("|cff99ffffPhoenixStyle|r - "..psmarkreflesh.." |cff00ff00"..psmarkrefleshon.."|r.")
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psnopermissmark)
end
else
if(autorefmark) then autorefmark=false out("|cff99ffffPhoenixStyle|r - "..psmarkreflesh.." |cffff0000"..psmarkrefleshoff.."|r.") else out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psnonickset) end
end
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psnopermissmark)
end
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psaddonofmodno)
end
end

function psmarksisinraid(chekat, trueli, nomir)
	if trueli==1 then
local spisoknikov={}

		local rsctemptext2=""
		local rsctemptext=chekat.." "
		while string.len(rsctemptext)>1 do
			if (string.find(rsctemptext," ") and string.find(rsctemptext," ")==1) or (string.find(rsctemptext,"%.") and string.find(rsctemptext,"%.")==1) or (string.find(rsctemptext,",") and string.find(rsctemptext,",")==1) then

				rsctemptext=string.sub(rsctemptext,2)

			else
				local a1=string.find(rsctemptext," ")
				local a2=string.find(rsctemptext,",")
				local a3=string.find(rsctemptext,"%.")
				local min=1000
				if a1 and a1<min then
				min=a1
				end
				if a2 and a2<min then
				min=a2
				end
				if a3 and a3<min then
				min=a3
				end
				if min==1000 then
					rsctemptext=""
				else
					if string.len(rsctemptext2)>1 then
						rsctemptext2=rsctemptext2..", "
					end
					table.insert(spisoknikov,string.sub(rsctemptext,1,min-1))
					rsctemptext2=rsctemptext2..string.sub(rsctemptext,1,min-1)
					rsctemptext=string.sub(rsctemptext,min)

				end
			end
		end
		psfautomebtable[nomir]:SetText(rsctemptext2)

if spisoknikov[1] then

if UnitInRaid(spisoknikov[1]) then
	table.wipe(pssetmarknew[nomir])
	pssetmarknew[nomir][1]=spisoknikov[1]
	truemark[nomir]="true"
	psautoupok[nomir]:SetText("|cff00ff00ok|r")

		if UnitExists(pssetmarknew[nomir][1]) and (GetRaidTargetIndex(pssetmarknew[nomir][1])==nil or (GetRaidTargetIndex(pssetmarknew[nomir][1]) and GetRaidTargetIndex(pssetmarknew[nomir][1])~=nomir)) then
			SetRaidTarget(pssetmarknew[nomir][1], nomir)
		end
	if #spisoknikov>1 then
		for uy=2,#spisoknikov do
			if UnitInRaid(spisoknikov[uy]) then
				table.insert(pssetmarknew[nomir],spisoknikov[uy])
			else
				out("|cff99ffffPhoenixStyle|r - '|CFF00FF00"..spisoknikov[uy].."|r' - "..psnotfoundinr)
				psautoupok[nomir]:SetText("|cff00ff00ok|r |cffff0000-|r")
				table.insert(pssetmarknew[nomir],spisoknikov[uy])
			end
		end
	end
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..psattention.."|r '|CFF00FF00"..spisoknikov[1].."|r' - "..psnotfoundinr.." "..format(psautomarnotu,nomir))
truemark[nomir]="false"
table.wipe(pssetmarknew[nomir])
for tg=1,#spisoknikov do
table.insert(pssetmarknew[nomir],spisoknikov[tg])
end
psautoupok[nomir]:SetText("|cffff0000-|r")
end

end


if #spisoknikov==0 then
truemark[nomir]="false"
table.wipe(pssetmarknew[nomir])
psautoupok[nomir]:SetText("|cffff0000-|r")
end




	else




local spisoknikov={}

		local rsctemptext2=""
		local rsctemptext=chekat.." "
		while string.len(rsctemptext)>1 do
			if (string.find(rsctemptext," ") and string.find(rsctemptext," ")==1) or (string.find(rsctemptext,"%.") and string.find(rsctemptext,"%.")==1) or (string.find(rsctemptext,",") and string.find(rsctemptext,",")==1) then

				rsctemptext=string.sub(rsctemptext,2)

			else
				local a1=string.find(rsctemptext," ")
				local a2=string.find(rsctemptext,",")
				local a3=string.find(rsctemptext,"%.")
				local min=1000
				if a1 and a1<min then
				min=a1
				end
				if a2 and a2<min then
				min=a2
				end
				if a3 and a3<min then
				min=a3
				end
				if min==1000 then
					rsctemptext=""
				else
					if string.len(rsctemptext2)>1 then
						rsctemptext2=rsctemptext2..", "
					end
					table.insert(spisoknikov,string.sub(rsctemptext,1,min-1))
					rsctemptext2=rsctemptext2..string.sub(rsctemptext,1,min-1)
					rsctemptext=string.sub(rsctemptext,min)

				end
			end
		end
		psfautomebtable[nomir]:SetText(rsctemptext2)


if spisoknikov[1] then

if UnitInRaid(spisoknikov[1]) then
	table.wipe(pssetmarknew[nomir])
	pssetmarknew[nomir][1]=spisoknikov[1]
if autorefmark then
	truemark[nomir]="true"
	psautoupok[nomir]:SetText("|cff00ff00ok|r")

		if UnitExists(pssetmarknew[nomir][1]) and (GetRaidTargetIndex(pssetmarknew[nomir][1])==nil or (GetRaidTargetIndex(pssetmarknew[nomir][1]) and GetRaidTargetIndex(pssetmarknew[nomir][1])~=nomir)) then
			SetRaidTarget(pssetmarknew[nomir][1], nomir)
		end
end
	if #spisoknikov>1 then
		for uy=2,#spisoknikov do
			if UnitInRaid(spisoknikov[uy]) then
				table.insert(pssetmarknew[nomir],spisoknikov[uy])
			else
				if autorefmark then
					out("|cff99ffffPhoenixStyle|r - '|CFF00FF00"..spisoknikov[uy].."|r' - "..psnotfoundinr)
					psautoupok[nomir]:SetText("|cff00ff00ok|r |cffff0000-|r")
				end
				table.insert(pssetmarknew[nomir],spisoknikov[uy])
			end
		end
	end
else
if autorefmark then
out("|cff99ffffPhoenixStyle|r - |cffff0000"..psattention.."|r '|CFF00FF00"..spisoknikov[1].."|r' - "..psnotfoundinr.." "..format(psautomarnotu,nomir))
end
truemark[nomir]="false"
table.wipe(pssetmarknew[nomir])
for tg=1,#spisoknikov do
table.insert(pssetmarknew[nomir],spisoknikov[tg])
end
psautoupok[nomir]:SetText("|cffff0000-|r")
end

end


if #spisoknikov==0 then
truemark[nomir]="false"
table.wipe(pssetmarknew[nomir])
psautoupok[nomir]:SetText("|cffff0000-|r")
end

	end
end





function openremovechat()
if not DropDownremovechat then
CreateFrame("Frame", "DropDownremovechat", PSFmainchated, "UIDropDownMenuTemplate")
end

DropDownremovechat:ClearAllPoints()
DropDownremovechat:SetPoint("TOPLEFT", 8, -241)
DropDownremovechat:Show()

local items = bigmenuchatlist

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownremovechat, self:GetID())

--тут делать чо та
pschcnumrem=1
PSFmainchated_Button20:Hide()
PSFmainchated_Button21:Show()

if self:GetID()>8 then
PSFmainchated_Button20:Show()
PSFmainchated_Button21:Hide()
pschcnumrem=self:GetID()
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

PSFmainchated_Button21:Show()
PSFmainchated_Button20:Hide()
pschcnumrem=1

UIDropDownMenu_Initialize(DropDownremovechat, initialize)
UIDropDownMenu_SetWidth(DropDownremovechat, 90)
UIDropDownMenu_SetButtonWidth(DropDownremovechat, 105)
UIDropDownMenu_SetSelectedID(DropDownremovechat, 1)
UIDropDownMenu_JustifyText(DropDownremovechat, "LEFT")
end



function openaddchat()
if not DropDownaddchat then
CreateFrame("Frame", "DropDownaddchat", PSFmainchated, "UIDropDownMenuTemplate")
end

DropDownaddchat:ClearAllPoints()
DropDownaddchat:SetPoint("TOPLEFT", 8, -136)
DropDownaddchat:Show()

--создание списка чата
pschc={}
table.wipe(pschc)
_,pschc[1],_,pschc[2],_,pschc[3],_,pschc[4],_,pschc[5],_,pschc[6],_,pschc[7],_,pschc[8],_,pschc[9],_,pschc[10]=GetChannelList()

local pschc2={}
table.wipe(pschc2)
pschc2[1],pschc2[2],pschc2[3],pschc2[4],pschc2[5],pschc2[6],pschc2[7],pschc2[8],pschc2[9],pschc2[10]=EnumerateServerChannels()
if #pschc2>0 then
	for i=1,#pschc2 do
		for j=1,#pschc do
		if pschc[j]==pschc2[i] then table.remove(pschc,j)
		end end
	end
end

	for i=8,#bigmenuchatlist do
		for j=1,#pschc do
		if pschc[j] and bigmenuchatlist[i] then if string.lower(pschc[j])==string.lower(bigmenuchatlist[i]) then table.remove(pschc,j) end end
		end
	end

PSFmainchated_Button10:Hide()
PSFmainchated_Button11:Hide()
tchataddtxt1:SetText(pschataddtxtset1)
if #pschc>0 then
PSFmainchated_Button10:Show()
pschcnum=1

else
PSFmainchated_Button11:Show()
pschcnum=0
tchataddtxt1:SetText("|cffff0000"..pschataddtxtset2.."|r")
pschc={pschatnothadd}
end



local items = pschc

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownaddchat, self:GetID())

if pschcnum==0 then
else
pschcnum=self:GetID()
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


UIDropDownMenu_Initialize(DropDownaddchat, initialize)
UIDropDownMenu_SetWidth(DropDownaddchat, 90)
UIDropDownMenu_SetButtonWidth(DropDownaddchat, 105)
UIDropDownMenu_SetSelectedID(DropDownaddchat, 1)
UIDropDownMenu_JustifyText(DropDownaddchat, "LEFT")
end



function PSF_chatedit()
PSF_closeallpr()
if(thisaddonwork)then
PSFmainchated:Show()
PhoenixStyleFailbot:RegisterEvent("CHANNEL_UI_UPDATE")

if psfchatedvar==nil then
psfchatedvar=1
local t = PSFmainchated:CreateFontString()
t:SetWidth(550)
t:SetHeight(45)
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",20,-20)
t:SetText(pschattitl2)
t:SetJustifyH("LEFT")

tchataddtxt1 = PSFmainchated:CreateFontString()
tchataddtxt1:SetWidth(550)
tchataddtxt1:SetHeight(30)
tchataddtxt1:SetFont(GameFontNormal:GetFont(), 12)
tchataddtxt1:SetPoint("TOPLEFT",20,-100)
tchataddtxt1:SetText(" ")
tchataddtxt1:SetJustifyH("LEFT")
tchataddtxt1:SetJustifyV("BOTTOM")


local t = PSFmainchated:CreateFontString()
t:SetWidth(550)
t:SetHeight(30)
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",20,-205)
t:SetText(pschetremtxt1)
t:SetJustifyH("LEFT")
t:SetJustifyV("BOTTOM")

end


openremovechat()
openaddchat()

else
PSFmain10:Show()
end

end


function PSF_addchatrep()
if #psfchatadd>4 then
out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..pschatmaxchan)
else
table.insert (bigmenuchatlist,pschc[pschcnum])
table.insert (psfchatadd,pschc[pschcnum])
--RA
if bigmenuchatlistea then
table.insert (bigmenuchatlistea,pschc[pschcnum])
table.insert (lowmenuchatlistea,pschc[pschcnum])
end

out("|cff99ffffPhoenixStyle|r - |cff00ff00"..pschc[pschcnum].."|r - "..pschataddsuc)
openremovechat()
openaddchat()
end
end

function PSF_remchatrep()
if pschcnumrem>8 then
out("|cff99ffffPhoenixStyle|r - |cffff0000"..bigmenuchatlist[pschcnumrem].."|r - "..pschatremsuc)
table.remove (bigmenuchatlist,pschcnumrem)
table.remove (psfchatadd,pschcnumrem-8)
--RA
if bigmenuchatlistea then
table.remove (bigmenuchatlistea,pschcnumrem)
table.remove (lowmenuchatlistea,pschcnumrem-2)
end
openremovechat()
openaddchat()
end
end

function psautomarunfoc()
for tg=1,8 do
psfautomebtable[tg]:ClearFocus()
end
end