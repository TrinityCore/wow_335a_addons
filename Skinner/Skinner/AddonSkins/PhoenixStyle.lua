if not Skinner:isAddonEnabled("PhoenixStyle") then return end

local x1, y1 = -2, -4
function Skinner:PhoenixStyle()

	-- shield monitor
	self:addSkinFrame{obj=PScolishieldmini}
	-- Main Panel buttons
	self:skinAllButtons{obj=PSFmain1}
	-- Menu (on LHS)
	self:addSkinFrame{obj=PSFmain2, y1=-4}
	-- Addon
	self:addSkinFrame{obj=PSFmain3, x1=x1, y1=y1}
	-- Autoupdate marks
	self:skinEditBox{obj=PSFmain4_secrefmark2}
	self:skinEditBox{obj=PSFmain4_setmark10}
	self:skinEditBox{obj=PSFmain4_setmark20}
	self:skinEditBox{obj=PSFmain4_setmark30}
	self:skinEditBox{obj=PSFmain4_setmark40}
	self:skinEditBox{obj=PSFmain4_setmark50}
	self:skinEditBox{obj=PSFmain4_setmark60}
	self:skinEditBox{obj=PSFmain4_setmark70}
	self:skinEditBox{obj=PSFmain4_setmark80}
	self:addSkinFrame{obj=PSFmain4, x1=x1, y1=y1}
	-- Timers
	self:skinEditBox{obj=PSFmain5_timertopull1, x=-5}
	self:skinEditBox{obj=PSFmain5_timerpereriv1, x=-5}
	self:skinEditBox{obj=PSFmain5_timersvoi1, x=-5}
	self:skinEditBox{obj=PSFmain5_timersvoi2, x=-5}
	-- remove divider lines
	self:SecureHook("psftimecrepol", function()
		self:keepFontStrings(PSFmain5)
		self:Unhook("psftimecrepol")
	end)
	self:addSkinFrame{obj=PSFmain5, kfs=true, x1=x1, y1=y1}
	-- Error frame
	self:addSkinFrame{obj=PSFmain12, x1=x1, y1=y1}
	-- Potions check
	self:addSkinFrame{obj=PSFpotioncheckframe, x1=x1, y1=y1}
	-- Raid Achievements
	self:addSkinFrame{obj=PSFmainrano, x1=x1, y1=y1}
	-- Chat options
	self:SecureHook("openaddchat", function()
		self:skinDropDown{obj=DropDownaddchat}
		self:Unhook("openaddchat")
	end)
	self:SecureHook("openremovechat", function()
		self:skinDropDown{obj=DropDownremovechat}
		self:Unhook("openremovechat")
	end)
	self:addSkinFrame{obj=PSFmainchated, x1=x1, y1=y1}

	-- skin minimap button
	if self.db.profile.MinimapButtons then
		self:addSkinButton{obj=PS_MinimapButton, parent=PS_MinimapButton, sap=true}
	end

end

function Skinner:PhoenixStyleMod_Coliseum()

	self:skinDropDown{obj=DropDownMenuTwins}
	self:skinDropDown{obj=DropDownMenujarax}
	self:skinDropDown{obj=DropDownMenuzveri}
	self:addSkinFrame{obj=PSFmain7, kfs=true, x1=x1, y1=y1}

	-- hook this to skin the dropdown
	self:SecureHook("PSF_colshieldinfoopen", function()
		self:skinDropDown{obj=DropDownMenureportinfoshield}
		self:Unhook("PSF_colshieldinfoopen")
	end)
	self:addSkinFrame{obj=PSFmainshieldinfo, x1=x1, y1=y1}
	-- TwinValkyrs options
	self:skinEditBox{obj=PSTwinValmenu_width1}
	PSTwinValmenu_width1:SetWidth(PSTwinValmenu_width1:GetWidth() + 3)
	self:skinEditBox{obj=PSTwinValmenu_heigh1}
	self:addSkinFrame{obj=PSTwinValmenu, y1=-4, y2=2}

	-- Anub'arak frame
	self:skinEditBox{obj=PSFmainanub_pala10}
	self:skinEditBox{obj=PSFmainanub_pala20}
	self:skinEditBox{obj=PSFmainanub_pala30}
	self:skinEditBox{obj=PSFmainanub_pala40}
	self:skinEditBox{obj=PSFmainanub_heal10}
	self:skinEditBox{obj=PSFmainanub_heal20}
	self:skinEditBox{obj=PSFmainanub_heal30}
	self:skinEditBox{obj=PSFmainanub_heal40}
	self:skinEditBox{obj=PSFmainanub_heal50}
	self:skinEditBox{obj=PSFmainanub_heal60}
	self:skinEditBox{obj=PSFmainanub_heal70}
	self:skinEditBox{obj=PSFmainanub_heal80}
	self:SecureHook("openmenuanub", function()
		self:skinDropDown{obj=DropDownMenuAnub}
		self:Unhook("openmenuanub")
	end)
	self:SecureHook("openmenuanub2", function()
		self:skinDropDown{obj=DropDownMenuAnub2}
		self:Unhook("openmenuanub2")
	end)
	self:addSkinFrame{obj=PSFmainanub, x1=x1, y1=y1}

end

function Skinner:PhoenixStyleMod_Ulduar()

	self:addSkinFrame{obj=PSFmain8, x1=x1, y1=y1}

	self:skinDropDown{obj=DropDownMenuGeneral}
	self:skinDropDown{obj=DropDownMenuMimiron}
	self:skinDropDown{obj=DropDownMenuStal}
	self:skinDropDown{obj=DropDownMenuHodir}
	self:skinDropDown{obj=DropDownMenuAlg}
	self:skinDropDown{obj=DropDownMenuxt}
	self:skinDropDown{obj=DropDownMenutorim}
	self:addSkinFrame{obj=PSFmain6, kfs=true, x1=x1, y1=y1}

	self:skinEditBox{obj=PSFmain11_primyogg}
	self:addSkinFrame{obj=PSFmain11, x1=x1, y1=y1}

end

function Skinner:PhoenixStyleMod_Icecrown()

	self:skinDropDown{obj=DropDownMenubossic}
	self:skinDropDown{obj=DropDownchatic}
	self:skinDropDown{obj=DropDownchatic2}
	self:addSkinFrame{obj=PSFmainic1, kfs=true, x1=x1, y1=y1}
	
	-- Deathbringer Saurfang module
	self:skinEditBox{obj=PSFiccsaurf_heal10}
	self:skinEditBox{obj=PSFiccsaurf_heal20}
	self:skinEditBox{obj=PSFiccsaurf_heal30}
	self:skinEditBox{obj=PSFiccsaurf_heal40}
	self:skinEditBox{obj=PSFiccsaurf_heal50}
	self:skinEditBox{obj=PSFiccsaurf_heal60}
	self:skinEditBox{obj=PSFiccsaurf_heal70}
	self:skinEditBox{obj=PSFiccsaurf_heal80}
	self:SecureHook("openmenureporticcsaurf", function()
		self:skinDropDown{obj=DropDownMenureporticcsaurf}
		self:Unhook("openmenureporticcsaurf")
	end)
	self:addSkinFrame{obj=PSFiccsaurf, x1=x1, y1=y1}
	
	-- Blood Queen Lana'thel module
	self:skinEditBox{obj=PSFicclana_edbox1}
	self:skinEditBox{obj=PSFicclana_edbox2}
	self:addSkinFrame{obj=PSFicclana, x1=x1, y1=y1}
	
	-- Damage/Switch info module
	self:SecureHook("openicccombarchoose", function()
		self:skinDropDown{obj=DropDownicccombarchoose}
		self:Unhook("openicccombarchoose")
	end)
	self:SecureHook("openicceventchoose", function()
		self:skinDropDown{obj=DropDownicceventchoose}
		self:Unhook("openicceventchoose")
	end)
	self:SecureHook("openiccquantname", function()
		self:skinDropDown{obj=DropDowniccquantname}
		self:Unhook("openiccquantname")
	end)
	self:SecureHook("openicclogchat", function()
		self:skinDropDown{obj=DropDownicclogchat}
		self:Unhook("openicclogchat")
	end)
	self:addSkinFrame{obj=PSFiccdamageinfo, x1=x1, y1=y1}

end
