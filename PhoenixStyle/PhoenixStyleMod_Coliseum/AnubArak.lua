function PSF_buttonanub()
PSF_closeallpr()
PSFmainanub:Show()
frameanubused=1
openmenuanub()
openmenuanub2()

if psfanubdaw1==nil then
psfanubdaw1=1
for i=1,8 do
local t = PSFmainanub:CreateTexture(nil,"OVERLAY")
t:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_"..i)
t:SetPoint("TOPLEFT",27,-75-i*25)
t:SetWidth(20)
t:SetHeight(20)
end

--BoP img
local _, _, aaicon=GetSpellInfo(10278)
local t = PSFmainanub:CreateTexture(nil,"OVERLAY")
t:SetTexture(aaicon)
t:SetWidth(24)
t:SetHeight(24)
t:SetPoint("TOPLEFT",360,-118)

local t2 = PSFmainanub:CreateFontString()
t2:SetFont(GameFontNormal:GetFont(), 15)
t2:SetText("|CFFF48CBAPaladins|r")
t2:SetJustifyH("LEFT")
t2:SetPoint("TOPLEFT",385,-123)

for i=1,2 do
local t3 = PSFmainanub:CreateFontString()
t3:SetFont(GameFontNormal:GetFont(), 14)
t3:SetText("|cff00ff00"..i.."|r")
t3:SetJustifyH("LEFT")
t3:SetPoint("TOPLEFT",274,-125-i*30)
end

for i=1,5 do
local t3 = PSFmainanub:CreateFontString()
t3:SetFont(GameFontNormal:GetFont(), 11)
t3:SetText("|cff00ff00<DBM|r")
t3:SetJustifyH("LEFT")
t3:SetPoint("TOPLEFT",200,-131-i*25)
end

PSFmainanub_heal10:SetText(psanubheal[1])
PSFmainanub_heal20:SetText(psanubheal[2])
PSFmainanub_heal30:SetText(psanubheal[3])
PSFmainanub_heal40:SetText(psanubheal[4])
PSFmainanub_heal50:SetText(psanubheal[5])
PSFmainanub_heal60:SetText(psanubheal[6])
PSFmainanub_heal70:SetText(psanubheal[7])
PSFmainanub_heal80:SetText(psanubheal[8])

PSFmainanub_pala10:SetText(psanubbop[1])
PSFmainanub_pala20:SetText(psanubbop[2])
PSFmainanub_pala30:SetText(psanubbop[3])
PSFmainanub_pala40:SetText(psanubbop[4])

local t = PSFmainanub:CreateFontString()
t:SetWidth(550)
t:SetHeight(45)
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetPoint("TOPLEFT",20,-20)
t:SetText(pscolanubtit2)
t:SetJustifyH("LEFT")


end



end


function pscolanubsave()
anubtxts(PSFmainanub_heal10:GetText(), 1)
anubtxts(PSFmainanub_heal20:GetText(), 2)
anubtxts(PSFmainanub_heal30:GetText(), 3)
anubtxts(PSFmainanub_heal40:GetText(), 4)
anubtxts(PSFmainanub_heal50:GetText(), 5)
anubtxts(PSFmainanub_heal60:GetText(), 6)
anubtxts(PSFmainanub_heal70:GetText(), 7)
anubtxts(PSFmainanub_heal80:GetText(), 8)
anubtxts(PSFmainanub_pala10:GetText(), 9)
anubtxts(PSFmainanub_pala20:GetText(), 10)
anubtxts(PSFmainanub_pala30:GetText(), 11)
anubtxts(PSFmainanub_pala40:GetText(), 12)
end


function anubtxts(tt, nn)
if tt==" " or tt=="  " or tt=="   " then tt="" end
if nn>8 then
psanubbop[nn-8]=tt
else
psanubheal[nn]=tt
end
end



function openmenuanub()
if not DropDownMenuAnub then
CreateFrame("Frame", "DropDownMenuAnub", PSFmainanub, "UIDropDownMenuTemplate")
end
pscreatedropmcol(DropDownMenuAnub,"TOPLEFT",80,-350,wherereportanub,5)
end

function openmenuanub2()
if not DropDownMenuAnub2 then
CreateFrame("Frame", "DropDownMenuAnub2", PSFmainanub, "UIDropDownMenuTemplate")
end
pscreatedropmcol(DropDownMenuAnub2,"TOPLEFT",377,-220,wherereportanub2,6)
end


function PSF_colanubsend()
pscolanubsave()
for i=1,8 do
	if psanubheal[i]=="" then else

psfchatsendreports(wherereportanub, "{rt"..i.."} "..psanubheal[i])

	end
end
pscolclearfoc()
end


function PSF_colanubsend2()
pscolanubsave()

psfchatsendreports(wherereportanub2, "{rt8} "..pscolkiteanub, "1: "..psanubbop[1].." - "..psanubbop[2], "2: "..psanubbop[3].." - "..psanubbop[4])
pscolclearfoc()
end


function PSF_colanubmark()
pscolanubsave()
pscolclearfoc()
		if(IsRaidOfficer()==1) then
for i=1,8 do
	if psanubheal[i]=="" then else
if UnitInRaid(psanubheal[i]) then
	SetRaidTarget(psanubheal[i], i)
else
out("|cff99ffffPhoenixStyle|r - |cffff0000"..psattention.."|r '|CFF00FF00"..psanubheal[i].."|r' - "..psnotfoundinr)
end
	end
end
		else out("|cff99ffffPhoenixStyle|r - |cffff0000"..pserror.."|r "..psnopermissmark)
		end
end

function pscolclearfoc()
PSFmainanub_heal10:ClearFocus()
PSFmainanub_heal20:ClearFocus()
PSFmainanub_heal30:ClearFocus()
PSFmainanub_heal40:ClearFocus()
PSFmainanub_heal50:ClearFocus()
PSFmainanub_heal60:ClearFocus()
PSFmainanub_heal70:ClearFocus()
PSFmainanub_heal80:ClearFocus()
PSFmainanub_pala10:ClearFocus()
PSFmainanub_pala20:ClearFocus()
PSFmainanub_pala30:ClearFocus()
PSFmainanub_pala40:ClearFocus()
end