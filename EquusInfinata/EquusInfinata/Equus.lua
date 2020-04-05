local VersionString = "v2.2.0"
EquusLoaded = 0
Equus_Mounts = {}
Equus_Pets = {}
Equus_FilterMountSpecies = {}
Equus_FilterSpeeds = {}
Equus_FilterPetSpecies = {}
EquusPetSendList = ""
EquusMountSendList = ""
local Equus_Defaults
EquusSelectedMountSpeciesNum = 1
EquusSelectedMountSpeedNum = 1
EquusSelectedMountPassengerNum = 1
EquusSelectedMountColourNum = 1
EquusSelectedPetSpeciesNum = 1
EquusSelectedPetTypeNum = 1
EquusSelectedPetColourNum = 1
local EquusTooltip
EquusTab = "CRITTER"
local EIdebug = 0
local EIallowupdate = 0
local EItablesdone = 0
local EIreagenthack = 0

Equus_InspectMounts = {}
Equus_InspectPets = {}
EquusInspectedMountSpeciesNum = 1
EquusInspectedMountSpeedNum = 1
EquusInspectedMountPassengerNum = 1
EquusInspectedMountColourNum = 1
EquusInspectedPetSpeciesNum = 1
EquusInspectedPetTypeNum = 1
EquusInspectedPetColourNum = 1

local EQUUS_ERRORS = {
	[SPELL_FAILED_NOT_MOUNTED] = true,
	[SPELL_FAILED_NOT_SHAPESHIFT] = true,
	[ERR_ATTACK_MOUNTED] = true,
}
local EQUUS_CASTDETECTION = {
	["UNIT_SPELLCAST_SUCCEEDED"] = true,
	["UNIT_SPELLCAST_FAILED"] = true,
	["UNIT_SPELLCAST_INTERRUPTED"] = true,
	["UNIT_SPELLCAST_FAILED_QUIET"] = true,
}

local EIprintstack = -1
local MessageString = ""
function EIprint(message)
   if(EIdebug == 1) then
		if(EIprintstack == -1) then
			MessageString=""
		end
      local stack, filler
      if not message then
	  	 DEFAULT_CHAT_FRAME:AddMessage(MessageString..tostring(message))
		 return false 
      end
      EIprintstack=EIprintstack+1
      
	  filler=string.rep(". . ",EIprintstack)
      
      if (type(message) == "table") then
	  	-- DEFAULT_CHAT_FRAME:AddMessage("its a table.  length="..EI_tcount(message))
	 	
		DEFAULT_CHAT_FRAME:AddMessage(MessageString.."{table} --> ")
		
	 	for k,v in pairs(message) do
			MessageString = filler.."["..k.."] = "
	    	EIprint(v)
	 	end
      elseif (type(message) == "userdata") then

      elseif (type(message) == "function") then
        DEFAULT_CHAT_FRAME:AddMessage(MessageString.." A Function()")
      elseif (type(message) == "boolean") then
            DEFAULT_CHAT_FRAME:AddMessage(MessageString..tostring(message))
      else
	  	 	DEFAULT_CHAT_FRAME:AddMessage(MessageString..tostring(message))
      end
      EIprintstack=EIprintstack-1
   end
end

function Equus_OnLoad()
	this:RegisterEvent("COMPANION_LEARNED");
	this:RegisterEvent("TAXIMAP_OPENED");
	this:RegisterEvent("CHAT_MSG_ADDON");
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	this:RegisterEvent("INSPECT_TALENT_READY");
	this:RegisterEvent("COMPANION_UPDATE");
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	
	--Register Slash Commands
	SLASH_EQUUS1 = "/equus"
	SLASH_EQUUS2 = "/ei"
	SlashCmdList["EQUUS"] = function(arg) Equus_Command(arg, false); end;
	
	BINDING_HEADER_EQUUSHDR = "Equus Infinata"
	BINDING_NAME_EQUUSBIND1 = "Equus 1"
	BINDING_NAME_EQUUSBIND2 = "Equus 2"
	BINDING_NAME_EQUUSBIND3 = "Equus 3"
	BINDING_NAME_EQUUSBIND4 = "Equus 4"
	BINDING_NAME_EQUUSBIND5 = "Equus 5"
	
	PetPaperDollFrameTab2:SetScript("OnClick", EIonclickpets)
	PetPaperDollFrameTab3:SetScript("OnClick", EIonclickmounts)
	
	CompanionModelFrameRotateLeftButton:SetPoint("TOPLEFT", "PetPaperDollFrame", "TOPRIGHT", -98, -40)
	CompanionModelFrameRotateRightButton:SetPoint("TOPLEFT", "PetPaperDollFrame", "TOPRIGHT", -71, -40)
	PetPaperDollFrame:SetScript("OnShow", EIdollframehack)
	INSPECTFRAME_SUBFRAMES[4] = "EquusInspectFrame"
	
	local petpanel = CreateFrame("Frame", "equusinspectpetpanel", EquusInspectFrame, "EquusRightPane_Template")
	petpanel:SetPoint("TOPLEFT",19,-72)
	petpanel:SetHeight(175)
	equusinspectpetpanelScrollPanel:SetHeight(165)
	equusinspectpetpanelScrollPanelScrollChildFrame:SetHeight(141)
	petpanel:SetBackdropColor(0,0,0,0.4)
	petpanel:Show()
	local previcon
	for i = 1,200 do
		local peticon = CreateFrame("Button", "equusinspeticon"..i, equusinspectpetpanelScrollPanelScrollChildFrame, "EquusInspIcon")
		if (i == 1) then
			peticon:SetPoint("topleft",9,1)
			previcon = peticon
		else
			peticon:SetPoint("TOPLEFT", previcon, "BOTTOMLEFT", 0, 0)
			previcon = peticon
		end
	end
	
	local mountpanel = CreateFrame("Frame", "equusinspectmountpanel", EquusInspectFrame, "EquusRightPane_Template")
	mountpanel:SetPoint("TOPLEFT",equusinspectpetpanel,"BOTTOMLEFT",0,5)
	mountpanel:SetHeight(175)
	equusinspectmountpanelScrollPanel:SetHeight(165)
	equusinspectmountpanelScrollPanelScrollChildFrame:SetHeight(141)
	mountpanel:SetBackdropColor(0,0,0,0.4)
	mountpanel:Show()
	EquusInspectFrame_Name:SetText("Equus Infinata "..VersionString);
	for i = 1,200 do
		local mounticon = CreateFrame("Button", "equusinsmounticon"..i, equusinspectmountpanelScrollPanelScrollChildFrame, "EquusInspIcon")
		if (i == 1) then
			mounticon:SetPoint("topleft",9,1)
			previcon = mounticon
		else
			mounticon:SetPoint("TOPLEFT", previcon, "BOTTOMLEFT", 0, 0)
			previcon = mounticon
		end
	end
	
	print("|c00ffff00EquusInfinata |rloaded.  '/equus help' for details")
end
function Equus_OnEvent(self, event, ...)
	if event == "COMPANION_LEARNED" then -- Rebuild selections array when user learns a new mount/pet
		if EquusLoaded ~= 1 then
			Equus_Loaded()
		end
		if EquusLoaded ~= 1 then return end
		Equus_CreateTables()
		Equus_Update()
	elseif event == "TAXIMAP_OPENED" then
		Dismount()
	elseif event == "CHAT_MSG_ADDON" then
		if arg1 == "EQUUS" then
			EIprint("|c00ff33ff"..event.."  |rarg1="..tostring(arg1).."  arg2="..tostring(arg2).."  arg3="..tostring(arg3).."  arg4="..tostring(arg4))
			Equus_AddonMsg(arg2,arg3,arg4)
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		if EquusLoaded ~= 1 then
			Equus_Loaded()
		end
		if EquusLoaded ~= 1 then return end
		if tonumber(Equus_Vars["Options"]["lastpet"]) ~= 0 and Equus_Vars["Options"]["lastpet"] ~= nil and not IsFlying() and not IsMounted() then
			CallCompanion("CRITTER", tonumber(Equus_Vars["Options"]["lastpet"]))
		end
	elseif event == "INSPECT_TALENT_READY" then
		Equus_InspectHooker()
	elseif event == "COMPANION_UPDATE" then
		EIprint("COMPANION_UPDATE")
		EIallowupdate = 1
	elseif event=="COMBAT_LOG_EVENT_UNFILTERED" and type=="SPELL_CAST_SUCCESS" then
		local checkGUID = select(3, ...)
		if UnitGUID("player")==checkGUID then
			local spellId = select(9, ...)
			if Equus_PetDataBySpell[tonumber(spellID)] then
				local temp
				for i=1,#GetNumCompanions("CRITTER") do
					_,_,temp,_,_ = GetCompanionInfo("CRITTER",i)
					if temp == spellID then
						temp = i
						break
					end
				end
				Equus_Vars["Options"]["lastpet"] = tonumber(temp)
			end
		end
	end
end
function Equus_Loaded()

	EIprint("|c00aaffccEquus_loaded() |rcalled.  EquusLoaded="..tostring(EquusLoaded))
	if EquusLoaded == 1 then return end
	
	Equus_MountHardcodeTable()
	Equus_PetHardcodeTable()
	Equus_CreateDefaults()
	Equus_LoadSavedVars()
	Equus_CreateTables()
	
	if EItablesdone == 0 then return end
	
	local button,tempbutton
	
	local parent = getglobal("EquusMainFrame")
	local rightpanel = CreateFrame("Frame", "equusrightpanel", parent, "EquusRightPane_Template")
	local rightscroll = getglobal("equusrightpanelScrollPanel")
	local rightscrollchild = getglobal("equusrightpanelScrollPanelScrollChildFrame")
	rightpanel:SetBackdropColor(0,0,0,0.4)
	rightpanel:Show()
	local paneltext = getglobal("EquusMainFrame_Name")
	paneltext:SetText("Equus Infinata "..VersionString);
	local scrolloffset = HSF_GetOffset(rightscroll);
	local fontstring
	
	EIonclickpets(1)
	CompanionModelFrame:ClearAllPoints()
	CompanionModelFrame:SetPoint("TOPLEFT",169,-80)
	CompanionModelFrame:SetWidth(174)
	CompanionModelFrame:SetHeight(114)
	CreateFrame("Frame", "EquusModelBorderFrame", PetPaperDollFrameCompanionFrame, "EquusBorderFrame")
	EquusModelBorderFrame:ClearAllPoints()
	EquusModelBorderFrame:SetPoint("TOPLEFT",165,-76)
	EquusModelBorderFrame:SetBackdropColor(0,0,0,0.4)
	EquusModelBorderFrame:Show()
	
	CreateFrame("Frame", "EquusPetSpeciesMenu", EquusMainFrame, "UIDropDownMenuTemplate")
	EquusPetSpeciesMenu:ClearAllPoints()
	EquusPetSpeciesMenu:SetPoint("TOPLEFT", -5, -8)
	EquusPetSpeciesMenu:Show()
	local species = {}
	local speciesother = 0
	for i=1,#Equus_Filters["PetSpecies"] do
		if Equus_FilterPetSpecies[Equus_Filters["PetSpecies"][i]] > 1 then
			species[#species + 1] = Equus_Filters["PetSpecies"][i]
		elseif Equus_FilterPetSpecies[Equus_Filters["PetSpecies"][i]] == 1 then
			speciesother = 1
		end
	end
	if speciesother == 1 then
		species[#species + 1] = "Other"
	end
	function EquusPetSpecMenuOnClick(self)
		UIDropDownMenu_SetSelectedID(EquusPetSpeciesMenu, self:GetID())
		EquusSelectedPetSpeciesNum = self:GetID()
		Equus_Update()
	end
	function EquusPetSpecMenuInit(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(species) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = EquusPetSpecMenuOnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_Initialize(EquusPetSpeciesMenu, EquusPetSpecMenuInit)
	UIDropDownMenu_SetWidth(EquusPetSpeciesMenu, 120);
	UIDropDownMenu_SetButtonWidth(EquusPetSpeciesMenu, 144)
	UIDropDownMenu_SetSelectedID(EquusPetSpeciesMenu, 1)
	UIDropDownMenu_JustifyText(EquusPetSpeciesMenu, "LEFT")
	
	CreateFrame("Frame", "EquusPetTypeMenu", EquusMainFrame, "UIDropDownMenuTemplate")
	EquusPetTypeMenu:ClearAllPoints()
	EquusPetTypeMenu:SetPoint("TOPLEFT", -5, -33)
	EquusPetTypeMenu:Show()
	function EquusPetTypeMenuOnClick(self)
		UIDropDownMenu_SetSelectedID(EquusPetTypeMenu, self:GetID())
		EquusSelectedPetTypeNum = self:GetID()
		Equus_Update()
	end
	function EquusPetTypeMenuInit(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(Equus_Filters["PetTypes"]) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = EquusPetTypeMenuOnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_Initialize(EquusPetTypeMenu, EquusPetTypeMenuInit)
	UIDropDownMenu_SetWidth(EquusPetTypeMenu, 120);
	UIDropDownMenu_SetButtonWidth(EquusPetTypeMenu, 144)
	UIDropDownMenu_SetSelectedID(EquusPetTypeMenu, 1)
	UIDropDownMenu_JustifyText(EquusPetTypeMenu, "LEFT")
	
	CreateFrame("Frame", "EquusPetColourMenu", EquusMainFrame, "UIDropDownMenuTemplate")
	EquusPetColourMenu:ClearAllPoints()
	EquusPetColourMenu:SetPoint("TOPLEFT", -5, -58)
	EquusPetColourMenu:Show()
	function EquusPetColourMenuOnClick(self)
		UIDropDownMenu_SetSelectedID(EquusPetColourMenu, self:GetID())
		EquusSelectedPetColourNum = self:GetID()
		Equus_Update()
	end
	function EquusPetColourMenuInit(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(Equus_Filters["Colours"]) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = EquusPetColourMenuOnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_Initialize(EquusPetColourMenu, EquusPetColourMenuInit)
	UIDropDownMenu_SetWidth(EquusPetColourMenu, 120);
	UIDropDownMenu_SetButtonWidth(EquusPetColourMenu, 144)
	UIDropDownMenu_SetSelectedID(EquusPetColourMenu, 1)
	UIDropDownMenu_JustifyText(EquusPetColourMenu, "LEFT")
	
	CreateFrame("Button", "EquusPetDismissButton", EquusMainFrame, "GameMenuButtonTemplate")
	EquusPetDismissButton:ClearAllPoints()
	EquusPetDismissButton:SetPoint("TOPLEFT", 10, -86)
	EquusPetDismissButton:Show()
	EquusPetDismissButton:SetText("Dismiss")
	EquusPetDismissButton:SetWidth(142)
	EquusPetDismissButton:SetHeight(21)
	EquusPetDismissButton:SetScript("OnClick", Equus_Dismiss)
	
	CreateFrame("Frame", "EquusMountSpeciesMenu", EquusMainFrame, "UIDropDownMenuTemplate")
	EquusMountSpeciesMenu:ClearAllPoints()
	EquusMountSpeciesMenu:SetPoint("TOPLEFT", -5, -8)
	EquusMountSpeciesMenu:Hide()
	local species = {}
	local speciesother = 0
	for i=1,#Equus_Filters["MountSpecies"] do
		if Equus_FilterMountSpecies[Equus_Filters["MountSpecies"][i]] > 1 then
			species[#species + 1] = Equus_Filters["MountSpecies"][i]
		elseif Equus_FilterMountSpecies[Equus_Filters["MountSpecies"][i]] == 1 then
			speciesother = 1
		end
	end
	if speciesother == 1 then
		species[#species + 1] = "Other"
	end
	function EquusMountSpecMenuOnClick(self)
		UIDropDownMenu_SetSelectedID(EquusMountSpeciesMenu, self:GetID())
		EquusSelectedMountSpeciesNum = self:GetID()
		Equus_Update()
	end
	function EquusMountSpecMenuInit(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(species) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = EquusMountSpecMenuOnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_Initialize(EquusMountSpeciesMenu, EquusMountSpecMenuInit)
	UIDropDownMenu_SetWidth(EquusMountSpeciesMenu, 120);
	UIDropDownMenu_SetButtonWidth(EquusMountSpeciesMenu, 144)
	UIDropDownMenu_SetSelectedID(EquusMountSpeciesMenu, 1)
	UIDropDownMenu_JustifyText(EquusMountSpeciesMenu, "LEFT")
	
	CreateFrame("Frame", "EquusMountSpeedMenu", EquusMainFrame, "UIDropDownMenuTemplate")
	EquusMountSpeedMenu:ClearAllPoints()
	EquusMountSpeedMenu:SetPoint("TOPLEFT", -5, -33)
	EquusMountSpeedMenu:Hide()
	function EquusMountSpeedMenuOnClick(self)
		UIDropDownMenu_SetSelectedID(EquusMountSpeedMenu, self:GetID())
		EquusSelectedMountSpeedNum = self:GetID()
		Equus_Update()
	end
	function EquusMountSpeedMenuInit(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(Equus_Filters["MountSpeeds"]) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = EquusMountSpeedMenuOnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_Initialize(EquusMountSpeedMenu, EquusMountSpeedMenuInit)
	UIDropDownMenu_SetWidth(EquusMountSpeedMenu, 120);
	UIDropDownMenu_SetButtonWidth(EquusMountSpeedMenu, 144)
	UIDropDownMenu_SetSelectedID(EquusMountSpeedMenu, 1)
	UIDropDownMenu_JustifyText(EquusMountSpeedMenu, "LEFT")
	
	CreateFrame("Frame", "EquusMountColourMenu", EquusMainFrame, "UIDropDownMenuTemplate")
	EquusMountColourMenu:ClearAllPoints()
	EquusMountColourMenu:SetPoint("TOPLEFT", -5, -58)
	EquusMountColourMenu:Hide()
	function EquusMountColourMenuOnClick(self)
		UIDropDownMenu_SetSelectedID(EquusMountColourMenu, self:GetID())
		EquusSelectedMountColourNum = self:GetID()
		Equus_Update()
	end
	function EquusMountColourMenuInit(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(Equus_Filters["Colours"]) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = EquusMountColourMenuOnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_Initialize(EquusMountColourMenu, EquusMountColourMenuInit)
	UIDropDownMenu_SetWidth(EquusMountColourMenu, 120);
	UIDropDownMenu_SetButtonWidth(EquusMountColourMenu, 144)
	UIDropDownMenu_SetSelectedID(EquusMountColourMenu, 1)
	UIDropDownMenu_JustifyText(EquusMountColourMenu, "LEFT")
	
	CreateFrame("Frame", "EquusMountPassengerMenu", EquusMainFrame, "UIDropDownMenuTemplate")
	EquusMountPassengerMenu:ClearAllPoints()
	EquusMountPassengerMenu:SetPoint("TOPLEFT", -5, -83)
	EquusMountPassengerMenu:Hide()
	function EquusMountPassengerMenuOnClick(self)
		UIDropDownMenu_SetSelectedID(EquusMountPassengerMenu, self:GetID())
		EquusSelectedMountPassengerNum = self:GetID()
		Equus_Update()
	end
	function EquusMountPassengerMenuInit(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(Equus_Filters["MountPassengers"]) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = EquusMountPassengerMenuOnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_Initialize(EquusMountPassengerMenu, EquusMountPassengerMenuInit)
	UIDropDownMenu_SetWidth(EquusMountPassengerMenu, 120);
	UIDropDownMenu_SetButtonWidth(EquusMountPassengerMenu, 144)
	UIDropDownMenu_SetSelectedID(EquusMountPassengerMenu, 1)
	UIDropDownMenu_JustifyText(EquusMountPassengerMenu, "LEFT")
	
	local previcon
	for i = 1,200 do
		local mounticon = CreateFrame("Button", "equusicon"..i, rightscrollchild, "EquusIcon")
		if (i == 1) then
			mounticon:SetPoint("topleft",9,1)
			previcon = mounticon
		else
			mounticon:SetPoint("TOPLEFT", previcon, "BOTTOMLEFT", 0, 0)
			previcon = mounticon
		end
	end
	
	EquusLoaded = 1
	EIprint("|c0000ff00 Loaded() successfully completed")
end

function EIdollframehack(self)
	if EquusLoaded ~= 1 then Equus_Loaded() end
	if EquusLoaded ~= 1 then return end
	Equus_Update()
	PetPaperDollFrame_OnShow(self)
end

function EquusOpenOptions()
	local panel = getglobal("EquusOptions")
	InterfaceOptionsFrame_OpenToCategory(panel)
end
function EquusOptions_OnLoad(panel)
	panel.name = "Equus Infinata"
	panel.okay = function (self) EquusOptions_Okay(); end;
	panel.cancel = function (self)  EquusOptions_Cancel();  end;
	InterfaceOptions_AddCategory(panel);
end
function EquusOptions_OnShow(panel)
	if EquusLoaded ~= 1 then
		Equus_Loaded()
	end
	if EquusLoaded ~= 1 then return end
	
	if EIreagenthack == 0 then
		CreateFrame("Frame", "EquusReagentMenu", panel, "UIDropDownMenuTemplate")
		EquusReagentMenu:ClearAllPoints()
		EquusReagentMenu:SetPoint("LEFT", "EquusOptFont7", "RIGHT")
		EquusReagentMenu:Show()
		function EquusReagentMenuOnClick(self)
			Equus_Vars["Options"]["reagents"] = self:GetID()
			UIDropDownMenu_SetSelectedID(EquusReagentMenu, Equus_Vars["Options"]["reagents"])
		end
		function EquusReagentMenuInit(self, level)
			local info = UIDropDownMenu_CreateInfo()
			info.text = "Never"
			info.value = 0
			info.func = EquusReagentMenuOnClick
			UIDropDownMenu_AddButton(info, level)
			info = UIDropDownMenu_CreateInfo()
			info.text = "Only If Available"
			info.value = 1
			info.func = EquusReagentMenuOnClick
			UIDropDownMenu_AddButton(info, level)
			info = UIDropDownMenu_CreateInfo()
			info.text = "Always"
			info.value = 2
			info.func = EquusReagentMenuOnClick
			UIDropDownMenu_AddButton(info, level)
		end
		UIDropDownMenu_Initialize(EquusReagentMenu, EquusReagentMenuInit)
		UIDropDownMenu_SetWidth(EquusReagentMenu, 130);
		UIDropDownMenu_SetButtonWidth(EquusReagentMenu, 154)
		UIDropDownMenu_JustifyText(EquusReagentMenu, "LEFT")
		UIDropDownMenu_SetSelectedID(EquusReagentMenu, Equus_Vars["Options"]["reagents"])
		EIreagenthack = 1
	end
	
	EquusOption_MergeFastFly:SetChecked(Equus_Vars.Options["mergefastfly"])
	EquusOption_Inspect:SetChecked(Equus_Vars.Options["inspect"])
	EquusKeybind1:SetText(Equus_Vars["Bindings"][1])
	EquusKeybind2:SetText(Equus_Vars["Bindings"][2])
	EquusKeybind3:SetText(Equus_Vars["Bindings"][3])
	EquusKeybind4:SetText(Equus_Vars["Bindings"][4])
	EquusKeybind5:SetText(Equus_Vars["Bindings"][5])
end
function EquusOptions_Okay()
	if EquusLoaded ~= 1 then
		Equus_Loaded()
	end
	if EquusLoaded ~= 1 then return end
	local checkbox = getglobal("EquusOption_MergeFastFly")
	Equus_Vars["Options"]["mergefastfly"] = checkbox:GetChecked() or 0
	checkbox = getglobal("EquusOption_Inspect")
	Equus_Vars["Options"]["inspect"] = checkbox:GetChecked() or 1
	if Equus_Vars["Options"]["inspect"] ~= 1 then
		local x = PanelTemplates_GetSelectedTab(InspectFrame)
		local haxx = getglobal(INSPECTFRAME_SUBFRAMES[x])
		PanelTemplates_SetNumTabs(InspectFrame, 3);
		InspectFrameTab4:Hide()
		PanelTemplates_SetTab(InspectFrame, 1);
		haxx:Hide()
		haxx = getglobal(INSPECTFRAME_SUBFRAMES[1])
		haxx:Show()
	end
	Equus_CreateMountTables()
	Equus_Update()
end
function EquusOptions_Cancel()
	if EquusLoaded ~= 1 then
		Equus_Loaded()
	end
	if EquusLoaded ~= 1 then return end
	EquusOption_MergeFastFly:SetChecked(Equus_Vars.Options["mergefastfly"])
	EquusOption_Inspect:SetChecked(Equus_Vars.Options["inspect"])
	UIDropDownMenu_SetSelectedID(EquusReagentMenu, Equus_Vars["Options"]["reagents"])
	EquusKeybind1:SetText(Equus_Vars["Bindings"][1])
	EquusKeybind2:SetText(Equus_Vars["Bindings"][2])
	EquusKeybind3:SetText(Equus_Vars["Bindings"][3])
	EquusKeybind4:SetText(Equus_Vars["Bindings"][4])
	EquusKeybind5:SetText(Equus_Vars["Bindings"][5])
end
function Equus_ResetSettings()
	Equus_Vars = nil
	ReloadUI()
end
function Equus_ResetPetCustomsZero()
	Equus_Vars["CustomsCRITTER"] = {}
	Equus_Update()
end
function Equus_ResetPetCustomsAll()
	Equus_Vars["CustomsCRITTER"] = {}
	for k,v in pairs(Equus_Pets) do
		Equus_Vars["CustomsCRITTER"][#Equus_Vars["CustomsCRITTER"]+1] = v
	end
	Equus_Update()
end
function Equus_ResetMountCustomsZero()
	Equus_Vars["CustomsMOUNT"] = {}
	Equus_Update()
end
function Equus_ResetMountCustomsAll()
	Equus_Vars["CustomsMOUNT"] = {}
	for k,v in pairs(Equus_Mounts) do
		Equus_Vars["CustomsMOUNT"][#Equus_Vars["CustomsMOUNT"]+1] = v
	end
	Equus_Update()
end
function Equus_KeybindEditBox(box,id)
	if Equus_Vars then
		local text = box:GetText()
		if text and text ~= nil and text ~= "" then
			Equus_Vars.Bindings[id] = text
		end
	end
end

function EIonclickmounts()
	
	EquusMainFrame:Show()
	
	EquusPetSpeciesMenu:Hide()
	EquusPetTypeMenu:Hide()
	EquusPetColourMenu:Hide()
	EquusPetDismissButton:Hide()
	
	EquusMountSpeciesMenu:Show()
	EquusMountSpeedMenu:Show()
	EquusMountColourMenu:Show()
	EquusMountPassengerMenu:Show()
	
	EquusTab = "MOUNT"
	Equus_Update()
	
	PetPaperDollFrame_SetTab(3)
	
end
function EIonclickpets(debugger)
	
	EquusMainFrame:Show()
	
	if debugger and debugger == 1 then
		PetPaperDollFrameCompanionFrame:DisableDrawLayer("BACKGROUND")
		CompanionSelectedName:Hide()
		CompanionPageNumber:Hide()
		CompanionSummonButton:Hide()
		for i = 1,12 do
			local hideme = getglobal("CompanionButton"..i)
			hideme:Hide();
		end
		CompanionPrevPageButton:Hide()
		CompanionNextPageButton:Hide()
	else
		if EquusLoaded ~= 1 then Equus_Loaded() end
		if EquusLoaded ~= 1 then return end
		
		EquusMountSpeciesMenu:Hide()
		EquusMountSpeedMenu:Hide()
		EquusMountColourMenu:Hide()
		EquusMountPassengerMenu:Hide()
		
		EquusPetSpeciesMenu:Show()
		EquusPetTypeMenu:Show()
		EquusPetColourMenu:Show()
		EquusPetDismissButton:Show()
		
		EquusTab = "CRITTER"
		
		Equus_Update();
	end
	PetPaperDollFrame_SetTab(2);
end

function Equus_CreateDefaults()
	Equus_Defaults = {
		["Options"] = {
			revision = 146,
			mergefastfly = 0,
			inspect = 1,
			lastpet = 0,
			reagents = 1,
		},
		["CustomsCRITTER"] = {},
		["CustomsMOUNT"] = {},
		["Bindings"] = {
			[1] = "mount",
			[2] = "mount fastground",
			[3] = "pet",
			[4] = "pet flying",
			[5] = "pet ground",
		},
	}
	Equus_Filters = {
		["MountSpeeds"] = {
			[1] = "AllSpeeds",
			[2] = "NoSpeed",
			[3] = "Swim",
			[4] = "SlowGround",
			[5] = "FastGround",
			[6] = "SlowFly",
			[7] = "FastFly",
			[8] = "UberFastFly",
			[9] = "Qiraji",
			[10] = "Changes",
			[11] = "ChangesGround",
			[12] = "ChangesFly",
		},
		["MountSpecies"] = {
			[1] = "AllSpecies",
			[2] = "Raptor",
			[3] = "Kodo",
			[4] = "Wolf",
			[5] = "Tiger",
			[6] = "Ram",
			[7] = "SkeletalHorse",
			[8] = "Horse",
			[9] = "Mechanostrider",
			[10] = "Elekk",
			[11] = "Hawkstrider",
			[12] = "Talbuk",
			[13] = "Mammoth",
			[14] = "Silithid",
			[15] = "Mechanical",
			[16] = "Bear",
			[17] = "Turtle",
			[18] = "WindRider",
			[19] = "Dragonhawk",
			[20] = "Gryphon",
			[21] = "Hippogryph",
			[22] = "NetherRay",
			[23] = "Netherdrake",
			[24] = "ProtoDrake",
			[25] = "Drake",
			[26] = "Frostwyrm",
			[27] = "Carpet",
			[28] = "Zhevra",
			[29] = "Raven",
			[30] = "Rooster",
			[31] = "SkeletalGryphon",
			[32] = "Phoenix",
			[33] = "FlyingHorse",
			[34] = "Unknown",
		},
		["MountPassengers"] = {
			[1] = "AllPassengers",
			[2] = "NoPassengers",
			[3] = "OnePassenger",
			[4] = "TwoPassengers",
		},
		["PetTypes"] = {
			[1] = "AllTypes",
			[2] = "Ground",
			[3] = "Flying",
			[4] = "Unknown",
		},
		["PetSpecies"] = {
			[1] = "AllSpecies",
			[2] = "Angel",
			[3] = "Bat",
			[4] = "Bear",
			[5] = "Bird",
			[6] = "Cat",
			[7] = "Chicken",
			[8] = "Crab",
			[9] = "Crawdad",
			[10] = "Crocolisk",
			[11] = "Darter",
			[12] = "Deer",
			[13] = "Demon",
			[14] = "Dog",
			[15] = "Dragon",
			[16] = "Dragonhawk",
			[17] = "Egg",
			[18] = "Elemental",
			[19] = "Elephant",
			[20] = "FloatingEye",
			[21] = "Frog",
			[22] = "Gnome",
			[23] = "Gorloc",
			[24] = "Gryphon",
			[25] = "Hippogryph",
			[26] = "Hound",
			[27] = "Humanoid",
			[28] = "Insect",
			[29] = "Kite",
			[30] = "Lamb",
			[31] = "Lich",
			[32] = "Mechanical",
			[33] = "Monkey",
			[34] = "Moth",
			[35] = "Murloc",
			[36] = "NetherRay",
			[37] = "Object",
			[38] = "Ooze",
			[39] = "Penguin",
			[40] = "Phoenix",
			[41] = "Pig",
			[42] = "Plant",
			[43] = "PrairieDog",
			[44] = "Rabbit",
			[45] = "Raptor",
			[46] = "Rat",
			[47] = "Scorpion",
			[48] = "Skull",
			[49] = "Skunk",
			[50] = "Snake",
			[51] = "Snowman",
			[52] = "SporeBat",
			[53] = "Turtle",
			[54] = "WindRider",
			[55] = "Wolf",
			[56] = "Wolpertinger",
			[57] = "Wolvar",
			[58] = "Wyrmling",
			[59] = "Unknown",
		},
		["Colours"] = {
			[1] = "AllColours",
			[2] = "Black",
			[3] = "Gray",
			[4] = "White",
			[5] = "Brown",
			[6] = "Red",
			[7] = "Orange",
			[8] = "Yellow",
			[9] = "Green",
			[10] = "Blue",
			[11] = "Purple",
			[12] = "Pink",
		},
	}
	
	local haxx = Equus_Filters
	Equus_Filters = {}
	for k,v in pairs(haxx) do
		Equus_Filters[k] = {}
		for i=1,#haxx[k] do
			Equus_Filters[k][i] = haxx[k][i]
		end
	end
	
end
function Equus_LoadSavedVars()
	if not Equus_Defaults then
		Equus_CreateDefaults()
	end
	if not Equus_Vars or Equus_Vars == {} then
		Equus_Vars = {}
		for i,_ in pairs(Equus_Defaults) do
			Equus_Vars[i] = {}
			for k,v in pairs(Equus_Defaults[i]) do
				Equus_Vars[i][k] = v
			end
		end
	elseif Equus_Vars["Options"]["revision"] < Equus_Defaults["Options"]["revision"] then
		local TempVars = Equus_Vars
		Equus_Vars = {}
		for i,_ in pairs(Equus_Defaults) do
			Equus_Vars[i] = {}
			for k,v in pairs(Equus_Defaults[i]) do
				Equus_Vars[i][k] = v
			end
		end
		for k,v in pairs(TempVars["Options"]) do
			if Equus_Vars["Options"][k] then
				Equus_Vars["Options"][k] = v
			end
		end
		if TempVars["Options"]["revision"] < 144 then
			print("EquusInfinata: Due to changes in v2.1.9, \"Checked\" selections have been reset")
			Equus_Vars["CustomsCRITTER"] = {}
			Equus_Vars["CustomsMOUNT"] = {}
		else
			if TempVars["CustomsCRITTER"] then
				for k,v in pairs(TempVars["CustomsCRITTER"]) do
					Equus_Vars["CustomsCRITTER"][k] = v
				end
			end
			if TempVars["CustomsMOUNT"] then
				for k,v in pairs(TempVars["CustomsMOUNT"]) do
					Equus_Vars["CustomsMOUNT"][k] = v
				end
			end
		end
		if TempVars["Options"]["revision"] >= 146 then
			for k,v in pairs(TempVars["Bindings"]) do
				if Equus_Vars["Bindings"][k] then
					Equus_Vars["Bindings"][k] = v
				end
			end
		end
		Equus_Vars["Options"]["revision"] = Equus_Defaults["Options"]["revision"]
	end
	
	EIprint(Equus_Vars.Options)
end

function Equus_Command(msg)
	if EquusLoaded ~= 1 then Equus_Loaded() end
	if EquusLoaded ~= 1 then return end
	if not msg then msg = "" end
	Cmd = msg
	
	if (Cmd == "help") then
		print("/ei pet - Summons a random companion pet")
		print("/ei mount - Summons a random mount")
		print("/ei pet <filter(s)> - Summons a companion pet from the given filter(s)")
		print("/ei mount <filter(s)> - Summons a mount from the given filter(s)")
		print("/ei dismiss - Dismisses your current companion pet")
		print("/ei reset - Makes Equus act like a brand new install.  Resets all saved settings, and RELOADS UI")
		print("You can also use the filter \"checked\" to limit random selections to just mounts/pets with a tick next to them in the Equus interface.")
	elseif (Cmd == "reset") then
		Equus_ResetSettings()
	elseif (Cmd == "debug") then
		EIdebug = 1 - EIdebug
		print("EIdebug = "..tostring(EIdebug))
	elseif (Cmd == "probe") then
		SendAddonMessage("EQUUS","PROBE","raid")
		SendAddonMessage("EQUUS","PROBE2","guild")
	elseif (Cmd == "dismiss") then
		Equus_Dismiss()
	elseif (strsub(Cmd,1,5) == "mount") then
		EIprint("|c000033aaMount command!")
		Equus_Mount(strsub(Cmd,7))
	elseif (strsub(Cmd,1,3) == "pet") then
		EIprint("|c000033aaPet command!")
		Equus_Pet(strsub(Cmd,5))
	else
		print("EquusInfinata: Command not recognised.")
	end
end
function Equus_Binding(num)
    if Equus_Vars.Bindings[num] then
        Equus_Command(Equus_Vars.Bindings[num])
    else
        Equus_Mount()
    end
end
function Equus_AddonMsg(arg2,arg3,arg4)
	if arg2 == "PROBE" and arg4 ~= UnitName("player") then
		SendAddonMessage("EQUUS","HERER "..arg4.." "..VersionString,"RAID")
	elseif arg2 == "PROBE2" then
		SendAddonMessage("EQUUS","HEREG "..arg4.." "..VersionString,"GUILD")
	elseif strsub(arg2,1,5) == "HERER" and strsub(arg2,7,strfind(arg2," ",7)-1) == UnitName("player") then
		print("Equus: "..arg4.." (raid) has "..strsub(arg2,strfind(arg2," ",7)+1))
	elseif strsub(arg2,1,5) == "HEREG" and strsub(arg2,7,strfind(arg2," ",7)-1) == UnitName("player") then
		print("Equus: "..arg4.." (guild) has "..strsub(arg2,strfind(arg2," ",7)+1))
	elseif arg2 == "INSPECT" then
		if EquusLoaded ~= 1 then Equus_Loaded() end
		if EquusLoaded ~= 1 then return end
		SendAddonMessage("EQUUS","INSPP "..EquusPetSendList,"WHISPER",arg4)
		SendAddonMessage("EQUUS","INSPM "..EquusMountSendList,"WHISPER",arg4)
	elseif strsub(arg2,1,5) == "INSPP" then
		local plist = ""
		arg2 = strsub(arg2,7)
		for i=1,strlen(arg2) do plist = plist..Equus_CodeToBin[strsub(arg2,i,i)] end
		local limit = min(strlen(plist),#Equus_PetPosToSpell)
		local x = "0"
		Equus_InspectPets = {}
		for i=1,limit do
			x = strsub(plist,i,i)
			if x == "1" then
				Equus_InspectPets[#Equus_InspectPets + 1] = Equus_PetPosToSpell[i]
			end
		end
	elseif strsub(arg2,1,5) == "INSPM" then
		local mlist = ""
		arg2 = strsub(arg2,7)
		for i=1,strlen(arg2) do mlist = mlist..Equus_CodeToBin[strsub(arg2,i,i)] end
		local limit = min(strlen(mlist),#Equus_MountPosToSpell)
		local x = "0"
		Equus_InspectMounts = {}
		for i=1,limit do
			x = strsub(mlist,i,i)
			if x == "1" then
				Equus_InspectMounts[#Equus_InspectMounts + 1] = Equus_MountPosToSpell[i]
			end
		end
		Equus_UpdateInspect()
	end
end

function Equus_Update()
	if EIallowupdate ~= 1 then return end
	if EItablesdone ~= 1 then Equus_CreateTables() end
	local rightscroll = getglobal("equusrightpanelScrollPanel")
	local rightscrollchild = getglobal("equusrightpanelScrollPanelScrollChild")
			
	local mountname, spellID, icon, button, height, mounttexture, checkbox, mounticon, peticon, speciesother
	local iconi=1
	local species = {}
	
	if EquusTab == "MOUNT" then
		for i = 1,#Equus_Filters["MountSpecies"] do
			if Equus_FilterMountSpecies[Equus_Filters["MountSpecies"][i]] > 1 then
				species[#species + 1] = Equus_Filters["MountSpecies"][i]
			elseif Equus_FilterMountSpecies[Equus_Filters["MountSpecies"][i]] == 1 then
				speciesother = 1
			end
		end
		if speciesother == 1 then
			species[#species + 1] = "Other"
		end
		
		panelname = species[EquusSelectedMountSpeciesNum]
		speedname = Equus_Filters["MountSpeeds"][EquusSelectedMountSpeedNum]
		passengername = Equus_Filters["MountPassengers"][EquusSelectedMountPassengerNum]
		colourname = Equus_Filters["Colours"][EquusSelectedMountColourNum]
		
		local mounts = {}
		for i = 1,#Equus_Mounts do
			if panelname == "AllSpecies" or Equus_MountDataBySpell[tostring(Equus_Mounts[i])]["species"] == panelname or ( panelname == "Other" and Equus_FilterMountSpecies[Equus_MountDataBySpell[tostring(Equus_Mounts[i])]["species"]] == 1 ) then
				if speedname == "AllSpeeds" or Equus_MountDataBySpell[tostring(Equus_Mounts[i])]["speed"] == speedname then
					if passengername == "AllPassengers" or Equus_MountDataBySpell[tostring(Equus_Mounts[i])]["passengers"] == passengername then
						if colourname == "AllColours" or Equus_MountDataBySpell[tostring(Equus_Mounts[i])]["colour1"] == colourname or Equus_MountDataBySpell[tostring(Equus_Mounts[i])]["colour2"] == colourname then
							mounts[#mounts + 1] = i
						end
					end
				end
			end
		end
		
		for i = 1,#mounts do
			if (not mounts[i]) then break end;
			 _, mountname, spellID, icon, _ = GetCompanionInfo("MOUNT", mounts[i])
			if not mountname then break end;
			loadmountspeed = Equus_MountDataBySpell[tostring(spellID)]["speed"]
			ridingskill = Equus_GetRidingSkill()
			if loadmountspeed == "NoSpeed" then
				mountspeed = "|cffffffffNormal"
			elseif loadmountspeed == "Swim" then
				mountspeed = "|cff2244ff60%"
			elseif loadmountspeed == "SlowGround" then
				mountspeed = "|cffbb880060%"
			elseif loadmountspeed == "FastGround" then
				mountspeed = "|cffbb8800100%"
			elseif loadmountspeed == "SlowFly" then
				mountspeed = "|cff6688ff150%"
			elseif loadmountspeed == "FastFly" then
				mountspeed = "|cff6688ff280%"
			elseif loadmountspeed == "UberFastFly" then
				mountspeed = "|cff6688ff310%"
			elseif loadmountspeed == "ChangesFly" then
				mountspeed = "|cff6688ffChanges"
			elseif loadmountspeed == "ChangesGround" then
				mountspeed = "|cffbb8800Changes"
			elseif loadmountspeed == "Changes" then
				mountspeed = "|cffffffffChanges"
			elseif loadmountspeed == "Qiraji" then
				mountspeed = "|cff44ff44100% (AQ)"
			else
				mountspeed = "|cffffffffUnknown"
			end
			
			mountspeed = mountspeed.."|r - "..Equus_MountDataBySpell[tostring(spellID)]["species"].." - "..Equus_MountDataBySpell[tostring(spellID)]["colour1"]
			if Equus_MountDataBySpell[tostring(spellID)]["colour2"] ~= nil then mountspeed = mountspeed.."/"..Equus_MountDataBySpell[tostring(spellID)]["colour2"] end
			
			mounticon = getglobal("equusicon"..iconi)
			mounticon:Show()
			mounticon.spell = spellID
			mounticon.id = Equus_MountDataBySpell[tostring(spellID)]["creatureid"]
			buttn = getglobal(mounticon:GetName().."_MountIcon")
			mounttexture = getglobal(mounticon:GetName().."_MountIcon_IconTexture")
			mountdisplayname = getglobal(mounticon:GetName().."_MountIcon_Name")
			mountdisplayspeed = getglobal(mounticon:GetName().."_MountIcon_Speed")
			mountcheckbox = getglobal(mounticon:GetName().."_Checkbox")
			
			buttn.link = GetSpellLink(spellID)
			mounttexture:SetTexture(icon)
			mountdisplayname:SetText(mountname)
			mountdisplayspeed:SetText(mountspeed)
			
			buttn:SetAttribute("type","spell")
			buttn:SetAttribute("spell",spellID)
			buttn:RegisterForDrag("LeftButton")
			buttn:SetScript("OnDragStart",Equus_OnDrag)
			
			local checker = 0
			for k,v in pairs(Equus_Vars["CustomsMOUNT"]) do
				if v == spellID then
					checker = 1
				end
			end
			mountcheckbox:SetChecked(checker)
			
			iconi=iconi+1
		end
		
		mounticon = getglobal("equusicon"..iconi)
		while(mounticon) do
			mounticon:Hide()
			mounticon.id = 0
			iconi=iconi+1
			mounticon = getglobal("equusicon"..iconi)
		end
		
		height = (#mounts * 48)
		
		EquusMainFrame_Count:SetText(#mounts.." mounts found");
	else
		for i = 1,#Equus_Filters["PetSpecies"] do
			if Equus_FilterPetSpecies[Equus_Filters["PetSpecies"][i]] > 1 then
				species[#species + 1] = Equus_Filters["PetSpecies"][i]
			elseif Equus_FilterPetSpecies[Equus_Filters["PetSpecies"][i]] == 1 then
				speciesother = 1
			end
		end
		if speciesother == 1 then
			species[#species + 1] = "Other"
		end
		
		panelname = species[EquusSelectedPetSpeciesNum]
		speedname = Equus_Filters["PetTypes"][EquusSelectedPetTypeNum]
		colourname = Equus_Filters["Colours"][EquusSelectedPetColourNum]
		
		local pets = {}
		for i = 1,#Equus_Pets do
			if panelname == "AllSpecies" or Equus_PetDataBySpell[Equus_Pets[i]]["species"] == panelname or ( panelname == "Other" and Equus_FilterPetSpecies[Equus_PetDataBySpell[Equus_Pets[i]]["species"]] == 1 ) then
				if speedname == "AllTypes" or Equus_PetDataBySpell[Equus_Pets[i]]["type"] == speedname then
					if colourname == "AllColours" or Equus_PetDataBySpell[Equus_Pets[i]]["colour1"] == colourname or Equus_PetDataBySpell[Equus_Pets[i]]["colour2"] == colourname then
						pets[#pets + 1] = i
					end
				end
			end
		end
		
		for i = 1,#pets do
			if (not pets[i]) then break end;
			 _, petname, spellID, icon, _ = GetCompanionInfo("CRITTER", pets[i])
			if not petname then break end;
			
			petspeed = Equus_PetDataBySpell[spellID]["type"].." "..Equus_PetDataBySpell[spellID]["species"].." - "..Equus_PetDataBySpell[spellID]["colour1"]
			if Equus_PetDataBySpell[spellID]["colour2"] ~= nil then petspeed = petspeed.."/"..Equus_PetDataBySpell[spellID]["colour2"] end
			
			peticon = getglobal("equusicon"..iconi)
			peticon:Show()
			peticon.spell = spellID
			peticon.id = Equus_PetDataBySpell[tonumber(spellID)]["creatureid"]
			buttn = getglobal(peticon:GetName().."_MountIcon")
			pettexture = getglobal(peticon:GetName().."_MountIcon_IconTexture")
			petdisplayname = getglobal(peticon:GetName().."_MountIcon_Name")
			petdisplayspeed = getglobal(peticon:GetName().."_MountIcon_Speed")
			petcheckbox = getglobal(peticon:GetName().."_Checkbox")
			
			buttn.link = GetSpellLink(spellID)
			pettexture:SetTexture(icon)
			petdisplayname:SetText(petname)
			petdisplayspeed:SetText(petspeed)
			
			buttn:SetAttribute("type","spell")
			buttn:SetAttribute("spell",spellID)
			buttn:RegisterForDrag("LeftButton")
			buttn:SetScript("OnDragStart",Equus_OnDrag)
			
			local checker = 0
			for k,v in pairs(Equus_Vars["CustomsCRITTER"]) do
				if v == spellID then
					checker = 1
				end
			end
			
			petcheckbox:SetChecked(checker)
			
			iconi=iconi+1
		end
		
		--EIprint("Hiding icons +"..iconi)
		peticon = getglobal("equusicon"..iconi)
		while(peticon) do
			peticon:Hide()
			peticon.id = 0
			iconi=iconi+1
			peticon = getglobal("equusicon"..iconi)
		end
		--EIprint("Hiding end icon "..iconi)
		
		height = (#pets * 48)
		
		EquusMainFrame_Count:SetText(#pets.." pets found");
	end
	
	HSF_Update(rightscroll, height, 370);
	HSF_SetOffset(rightscroll, 0);
	rightscroll.scrollBar:SetValue(0);
	
	Equus_OnClickRightButton(equusicon1)
end

function Equus_Mount(msg)
	EIprint("Equus_mount called.  Msg:"..msg)
	if EquusLoaded ~= 1 then Equus_Loaded() end
	if EquusLoaded ~= 1 then return end

	if (IsMounted()) then -- If player is already mounted dismount
		if IsFlying() then -- If player is flying don't dismount
			EIprint("NO dismount for you!")
			return
		else
			EIprint("dismount!")
			Dismount()
		end
	end
	if UnitClass("player") == "Druid" then
		_,name,_,_ = GetShapeshiftFormInfo(GetNumShapeshiftForms())
		if strfind(name,"Flight") then
			EIprint("NO dismissing Flight Form for you!")
		elseif GetShapeshiftForm() > 0 then
			EIprint("druid message!")
			print("EquusInfinata: Addons cannot cancel druid shapeshifts. Use \"/cancelform\" in your own macro")
			return
		end
	end
	
	local gospecies = {}
	local nospecies = {}
	local gospeed = {}
	local nospeed = {}
	local gopassenger = {}
	local nopassenger = {}
	local gocolour = {}
	local nocolour = {}
	local gocustom = 0
	local negatefix = 0
	if msg == nil or msg == "" then msg = "all" end
	if msg == "all" or msg == "checked" then
		gospecies = {"AllSpecies"}
		gopassenger = {"AllPassengers"}
		gocolour = {"AllColours"}
		if msg == "checked" then gocustom = 1 end
	elseif strfind(msg,"%s") then
		for Cmd in string.gmatch(msg,"[!%w]+") do
			if strsub(Cmd,0,1) == "!" and strlower(msg) ~= "all" then
				negatefix = 1
				Cmd = strsub(Cmd,2,strlen(Cmd))
			else
				negatefix = 0
			end
			if strlower(Cmd) == "checked" then gocustom = 1 end
			for i, panel in pairs(Equus_Filters["MountSpecies"]) do
				if (type(panel) == "string") then
					tmp = strlower(panel)
					Cmd = strlower(Cmd)
					if (Cmd == tmp) then
						if negatefix == 1 then nospecies[#nospecies+1] = panel else gospecies[#gospecies+1] = panel end
						break
					end
				end
			end
			for i, panel in pairs(Equus_Filters["MountSpeeds"]) do
				if (type(panel) == "string") then
					tmp = strlower(panel)
					Cmd = strlower(Cmd)
					if Cmd == tmp then
						if negatefix == 1 then nospeed[#nospeed+1] = panel else gospeed[#gospeed+1] = panel end
						break
					end
				end
			end
			for i, panel in pairs(Equus_Filters["MountPassengers"]) do
				if (type(panel) == "string") then
					tmp = strlower(panel)
					Cmd = strlower(Cmd)
					if Cmd == tmp then
						if negatefix == 1 then nopassenger[#nopassenger+1] = panel else gopassenger[#gopassenger+1] = panel end
						break
					end
				end
			end
			for i, panel in pairs(Equus_Filters["Colours"]) do
				if (type(panel) == "string") then
					tmp = strlower(panel)
					Cmd = strlower(Cmd)
					if Cmd == tmp then
						if negatefix == 1 then nocolour[#nocolour+1] = panel else gocolour[#gocolour+1] = panel end
						break
					end
				end
			end
		end
	else
		if strsub(msg,0,1) == "!" and strlower(msg) ~= "all" then
			negatefix = 1
			Cmd = strsub(msg,2,strlen(msg))
		else
			negatefix = 0
			Cmd = msg
		end
		if strlower(Cmd) == "checked" then gocustom = 1 end
		for i, panel in pairs(Equus_Filters["MountSpecies"]) do
			if (type(panel) == "string") then
				tmp = strlower(panel)
				Cmd = strlower(Cmd)
				if (Cmd == tmp) then
					if negatefix == 1 then nospecies[#nospecies+1] = panel else gospecies[#gospecies+1] = panel end
					break
				end
			end
		end
		for i, panel in pairs(Equus_Filters["MountSpeeds"]) do
			if (type(panel) == "string") then
				tmp = strlower(panel)
				Cmd = strlower(Cmd)
				if Cmd == tmp then
					if negatefix == 1 then nospeed[#nospeed+1] = panel else gospeed[#gospeed+1] = panel end
					break
				end
			end
		end
		for i, panel in pairs(Equus_Filters["MountPassengers"]) do
			if (type(panel) == "string") then
				tmp = strlower(panel)
				Cmd = strlower(Cmd)
				if Cmd == tmp then
					if negatefix == 1 then nopassenger[#nopassenger+1] = panel else gopassenger[#gopassenger+1] = panel end
					break
				end
			end
		end
		for i, panel in pairs(Equus_Filters["Colours"]) do
			if (type(panel) == "string") then
				tmp = strlower(panel)
				Cmd = strlower(Cmd)
				if Cmd == tmp then
					if negatefix == 1 then nocolour[#nocolour+1] = panel else gocolour[#gocolour+1] = panel end
					break
				end
			end
		end
	end
	
	local summontable = {}
	local firsttable = {}
	local secondtable = {}
	
	if gocustom == 1 then
		secondtable = Equus_Vars["CustomsMOUNT"]
	else
		secondtable = Equus_Mounts
	end
	
	if #gospecies == 0 then gospecies = {"AllSpecies"} end
	if #gopassenger == 0 then gopassenger = {"AllPassengers"} end
	if #gocolour == 0 then gocolour = {"AllColours"} end
	
	for i=1,#secondtable do
		for x = 1,#gospecies do
			if gospecies[x] == "AllSpecies" or Equus_MountDataBySpell[tostring(secondtable[i])]["species"] == gospecies[x] then
				firsttable[#firsttable + 1] = secondtable[i]
				break
			end
		end
	end
	if #firsttable < 1 then
		print("EquusInfinata: Cannot find a mount with specified filters")
		return
	end
	
	secondtable = {}
	for i = 1,#firsttable do
		for x = 1,#gopassenger do
			if gopassenger[x] == "AllPassengers" or Equus_MountDataBySpell[tostring(firsttable[i])]["passengers"] == gopassenger[x] then
				secondtable[#secondtable + 1] = firsttable[i]
				break
			end
		end
	end
	if #secondtable < 1 then
		print("EquusInfinata: Cannot find a mount with specified filters")
		return
	end
	
	firsttable = {}
	for i = 1,#secondtable do
		for x = 1,#gocolour do
			if gocolour[x] == "AllColours" or Equus_MountDataBySpell[tostring(secondtable[i])]["colour1"] == gocolour[x] or Equus_MountDataBySpell[tostring(secondtable[i])]["colour2"] == gocolour[x] then
				firsttable[#firsttable + 1] = secondtable[i]
				break
			end
		end
	end
	if #firsttable < 1 then
		print("EquusInfinata: Cannot find a mount with specified filters")
		return
	end
	
	local flyable = EIgetisflyable()
	local ridingskill = Equus_GetRidingSkill()
	if (#gospeed == 0 or gospeed == {"AllSpeeds"}) and #nospeed == 0 then
		gospeed = {}
		local speed,testspeed = 0
		for i = 1,#firsttable do
			testspeed = Equus_MountDataBySpell[tostring(firsttable[i])]["speed"]
			if flyable == true and testspeed == "UberFastFly" then if Equus_Vars.Options["mergefastfly"] == true then testspeed = 4 else testspeed = 5 end
			elseif flyable == true and testspeed == "FastFly" then testspeed = 4
			elseif flyable == true and testspeed == "SlowFly" then testspeed = 3
			elseif testspeed == "FastGround" then testspeed = 2
			elseif testspeed == "SlowGround" then testspeed = 1
			elseif testspeed == "Swim" or testspeed == "NoSpeed" then testspeed = 0
			elseif (testspeed == "Changes" or testspeed == "ChangesFly") and flyable == true then
				if ridingskill >= 300 then
					if Equus_FilterSpeeds["UberFastFly"] == 1 and Equus_Vars.Options["mergefastfly"] ~= true then
						testspeed = 5
					else
						testspeed = 4
					end
				elseif ridingskill >= 225 then
					testspeed = 3
				else
					testspeed = 0
				end
			elseif testspeed == "Changes" or testspeed == "ChangesGround" then
				if ridingskill >= 150 then
					testspeed = 2
				elseif ridingskill >= 75 then
					testspeed = 1
				else
					testspeed = 0
				end
			else testspeed = 0 end
			speed = max(speed, testspeed)
		end
		if speed == 5 then gospeed = {"UberFastFly"}
		elseif speed == 4 then gospeed = {"FastFly"}
		elseif speed == 3 then gospeed = {"SlowFly"}
		elseif speed == 2 then gospeed = {"FastGround"}
		elseif speed == 1 then gospeed = {"SlowGround"}
		else gospeed = {"AllSpeeds"} end
	elseif (#gospeed == 0 or gospeed == {"AllSpeeds"}) and #nospeed > 0 then gospeed = {"AllSpeeds"} end

	local tempspeed
	secondtable = {}
	for i = 1,#firsttable do
		for x = 1,#gospeed do
			tempspeed = Equus_MountDataBySpell[tostring(firsttable[i])]["speed"]
			if strsub(tempspeed,1,7) == "Changes" then
				if flyable == true and tempspeed ~= "ChangesGround" and Equus_FilterSpeeds["UberFastFly"] == 1 then tempspeed = "UberFastFly"
				elseif flyable == true and tempspeed ~= "ChangesGround" and ridingskill >= 300 then tempspeed = "FastFly"
				elseif flyable == true and tempspeed ~= "ChangesGround" and ridingskill >= 225 then tempspeed = "SlowFly"
				elseif tempspeed ~= "ChangesFly" and ridingskill >= 150 then tempspeed = "FastGround"
				elseif tempspeed ~= "ChangesFly" and ridingskill >= 75 then tempspeed = "SlowGround"
				elseif tempspeed ~= "ChangesFly" then tempspeed = "NoSpeed" end
			end
			if tempspeed == "UberFastFly" and Equus_Vars.Options["mergefastfly"] == true then tempspeed = "FastFly" end
			if gospeed[x] == "UberFastFly" and Equus_Vars.Options["mergefastfly"] == true then gospeed[x] = "FastFly" end
			if gospeed[x] == "AllSpeeds" or tempspeed == gospeed[x] then
				secondtable[#secondtable + 1] = firsttable[i]
				break
			end
		end
	end
	if #secondtable < 1 then
		print("EquusInfinata: Cannot find a mount with specified filters")
		return
	end
	
	local negatecounter = 0
	
	firsttable = {}
	for i = 1,#secondtable do
		if #nospecies > 0 then
			negatecounter = 0
			for x = 1,#nospecies do
				if Equus_MountDataBySpell[tostring(secondtable[i])]["species"] ~= nospecies[x] then
					negatecounter = negatecounter + 1
				end
			end
			if negatecounter == #nospecies then firsttable[#firsttable + 1] = secondtable[i] end
		else
			firsttable = secondtable
			break
		end
	end
	if #firsttable < 1 then
		print("EquusInfinata: Cannot find a mount with specified filters")
		return
	end
	
	secondtable = {}
	negatgecounter = 0
	for i = 1,#firsttable do
		if #nospeed > 0 then
			negatecounter = 0
			for x = 1,#nospeed do
				if Equus_MountDataBySpell[tostring(firsttable[i])]["speed"] ~= nospeed[x] then
					negatecounter = negatecounter + 1
				end
			end
			if negatecounter == #nospeed then secondtable[#secondtable + 1] = firsttable[i] end
		else
			secondtable = firsttable
			break
		end
	end
	if #secondtable < 1 then
		print("EquusInfinata: Cannot find a mount with specified filters")
		return
	end
	
	firsttable = {}
	negatecounter = 0
	for i = 1,#secondtable do
		if #nopassenger > 0 then
			negativecounter = 0
			for x = 1,#nopassenger do
				if Equus_MountDataBySpell[tostring(secondtable[i])]["passengers"] ~= nopassenger[x] then
					negatecounter = negatecounter + 1
				end
			end
			if negatecounter == #nopassenger then firsttable[#firsttable + 1] = secondtable[i] end
		else
			firsttable = secondtable
			break
		end
	end
	if #firsttable < 1 then
		print("EquusInfinata: Cannot find a mount with specified filters")
		return
	end
	
	negatecounter = 0
	for i = 1,#firsttable do
		if #nocolour > 0 then
			for x = 1,#nocolour do
				negativefilter = 0
				if Equus_MountDataBySpell[tostring(firsttable[i])]["colour1"] ~= nocolour[x] and Equus_MountDataBySpell[tostring(Equus_Mounts[firsttable[i]])]["colour2"] ~= nocolour[x] then
					negatecounter = negatecounter + 1
				end
			end
			if negatecounter == #nocolour then summontable[#summontable + 1] = firsttable[i] end
		else
			summontable = firsttable
			break
		end
	end
	if #summontable < 1 then
		print("EquusInfinata: Cannot find a mount with specified filters")
		return
	end
	
	local rand,mountnumber
	if(#summontable == 1) then
		rand = 1
	elseif(#summontable > 1) then
		rand = random(1,#summontable)
	end
	
	for i = 1,#Equus_Mounts do
		if Equus_Mounts[i] == summontable[rand] then
			mountnumber = i
			break
		end
	end
	
	CallCompanion("MOUNT", mountnumber)
	
end
function Equus_Pet(msg)
	EIprint("Equus_pet called.  Msg:"..msg)
	if EquusLoaded ~= 1 then Equus_Loaded() end
	if EquusLoaded ~= 1 then return end
	if IsFlying() then return end
	
	local gospecies = {}
	local nospecies = {}
	local gotype = {}
	local notype = {}
	local gocolour = {}
	local nocolour = {}
	local gocustom = 0
	local negatefix = 0
	if msg == nil or msg == "" then msg = "all" end
	if msg == "all" or msg == "checked" then
		gospecies = {"AllSpecies"}
		gotype = {"AllTypes"}
		gocolour = {"AllColours"}
		if msg == "checked" then gocustom = 1 end
	elseif strfind(msg,"%s") then
		for Cmd in string.gmatch(msg,"[!%w]+") do
			if strsub(Cmd,0,1) == "!" and strlower(msg) ~= "all" then
				negatefix = 1
				Cmd = strsub(Cmd,2,strlen(Cmd))
			else
				negatefix = 0
			end
			if strlower(Cmd) == "checked" then gocustom = 1 end
			for i, panel in pairs(Equus_Filters["PetSpecies"]) do
				if (type(panel) == "string") then
					tmp = strlower(panel)
					Cmd = strlower(Cmd)
					if (Cmd == tmp) then
						if negatefix == 1 then nospecies[#nospecies+1] = panel else gospecies[#gospecies+1] = panel end
						break
					end
				end
			end
			for i, panel in pairs(Equus_Filters["PetTypes"]) do
				if (type(panel) == "string") then
					tmp = strlower(panel)
					Cmd = strlower(Cmd)
					if Cmd == tmp then
						if negatefix == 1 then notype[#notype+1] = panel else gotype[#gotype+1] = panel end
						break
					end
				end
			end
			for i, panel in pairs(Equus_Filters["Colours"]) do
				if (type(panel) == "string") then
					tmp = strlower(panel)
					Cmd = strlower(Cmd)
					if Cmd == tmp then
						if negatefix == 1 then nocolour[#nocolour+1] = panel else gocolour[#gocolour+1] = panel end
						break
					end
				end
			end
		end
	else
		if strsub(msg,0,1) == "!" and strlower(msg) ~= "all" then
			negatefix = 1
			Cmd = strsub(msg,2,strlen(msg))
		else
			negatefix = 0
			Cmd = msg
		end
		if strlower(Cmd) == "checked" then gocustom = 1 end
		for i, panel in pairs(Equus_Filters["PetSpecies"]) do
			if (type(panel) == "string") then
				tmp = strlower(panel)
				Cmd = strlower(Cmd)
				if (Cmd == tmp) then
					if negatefix == 1 then nospecies[#nospecies+1] = panel else gospecies[#gospecies+1] = panel end
					break
				end
			end
		end
		for i, panel in pairs(Equus_Filters["PetTypes"]) do
			if (type(panel) == "string") then
				tmp = strlower(panel)
				Cmd = strlower(Cmd)
				if Cmd == tmp then
					if negatefix == 1 then notype[#notype+1] = panel else gotype[#gotype+1] = panel end
					break
				end
			end
		end
		for i, panel in pairs(Equus_Filters["Colours"]) do
			if (type(panel) == "string") then
				tmp = strlower(panel)
				Cmd = strlower(Cmd)
				if Cmd == tmp then
					if negatefix == 1 then nocolour[#nocolour+1] = panel else gocolour[#gocolour+1] = panel end
					break
				end
			end
		end
	end
	
	local summontable = {}
	local firsttable = {}
	local secondtable = {}
	
	if gocustom == 1 then
		secondtable = Equus_Vars["CustomsCRITTER"]
	else
		secondtable = Equus_Pets
	end
	
	if #gospecies == 0 then gospecies = {"AllSpecies"} end
	if #gotype == 0 then gotype = {"AllTypes"} end
	if #gocolour == 0 then gocolour = {"AllColours"} end
	
	for i=1,#secondtable do
		for x = 1,#gospecies do
			if gospecies[x] == "AllSpecies" or Equus_PetDataBySpell[secondtable[i]]["species"] == gospecies[x] then
				firsttable[#firsttable + 1] = secondtable[i]
				break
			end
		end
	end
	if #firsttable < 1 then
		print("EquusInfinata: Cannot find a pet with specified filters")
		return
	end
	
	secondtable = {}
	for i = 1,#firsttable do
		for x = 1,#gocolour do
			if gocolour[x] == "AllColours" or Equus_PetDataBySpell[firsttable[i]]["colour1"] == gocolour[x] or Equus_PetDataBySpell[firsttable[i]]["colour2"] == gocolour[x] then
				secondtable[#secondtable + 1] = firsttable[i]
				break
			end
		end
	end
	if #secondtable < 1 then
		print("EquusInfinata: Cannot find a pet with specified filters")
		return
	end
	
	firsttable = {}
	for i = 1,#secondtable do
		for x = 1,#gotype do
			if gotype[x] == "AllTypes" or Equus_PetDataBySpell[secondtable[i]]["type"] == gotype[x] then
				firsttable[#firsttable + 1] = secondtable[i]
			end
		end
	end
	if #firsttable < 1 then
		print("EquusInfinata: Cannot find a pet with specified filters")
		return
	end
	
	secondtable = {}
	local negatecounter = 0
	for i = 1,#firsttable do
		if #nospecies > 0 then
			for x = 1,#nospecies do
				if Equus_PetDataBySpell[firsttable[i]]["species"] ~= nospecies[x] then
					negatecounter = negatecounter + 1
				end
			end
			if negatecounter == #nospecies then secondtable[#secondtable + 1] = firsttable[i] end
		else
			secondtable = firsttable
			break
		end
	end
	if #secondtable < 1 then
		print("EquusInfinata: Cannot find a pet with specified filters")
		return
	end
	
	firsttable = {}
	negatecounter = 0
	for i = 1,#secondtable do
		if #notype > 0 then
			for x = 1,#notype do
				if Equus_PetDataBySpell[secondtable[i]]["passengers"] ~= nopassenger[x] then
					negatecounter = negatecounter + 1
				end
			end
			if negatecounter == #nopassenger then firsttable[#firsttable + 1] = secondtable[i] end
		else
			firsttable = secondtable
			break
		end
	end
	if #firsttable < 1 then
		print("EquusInfinata: Cannot find a pet with specified filters")
		return
	end
	
	secondtable = {}
	negatecounter = 0
	for i = 1,#firsttable do
		if #nocolour > 0 then
			for x = 1,#nocolour do
				if Equus_PetDataBySpell[firsttable[i]]["colour1"] ~= nocolour[x] and Equus_PetDataBySpell[firsttable[i]]["colour2"] ~= nocolour[x] then
					negatecounter = negatecounter + 1
				end
			end
			if negatecounter == #nocolour then secondtable[#secondtable + 1] = firsttable[i] end
		else
			secondtable = firsttable
			break
		end
	end
	if #secondtable < 1 then
		print("EquusInfinata: Cannot find a pet with specified filters")
		return
	end
	
	if Equus_Vars.Options["reagents"] == 3 then
		summontable = secondtable
	else
		for i=1,#secondtable do
			if Equus_PetDataBySpell[secondtable[i]]["reagent"] then
				if Equus_Vars.Options["reagents"] == 2 then
					local count = GetItemCount(Equus_PetDataBySpell[secondtable[i]]["reagent"])
					if count ~= nil and count > 0 then
						summontable[#summontable + 1] = secondtable[i]
					end
				end
			else
				summontable[#summontable + 1] = secondtable[i]
			end
		end
	end
	if #summontable < 1 then
		print("EquusInfinata: Cannot find a pet with specified filters")
		return
	end
	
	local rand,petnumber
	if(#summontable == 1) then
		rand = 1
	else
		rand = random(1,#summontable)
	end
	
	for i = 1,#Equus_Pets do
		if Equus_Pets[i] == summontable[rand] then
			petnumber = i
			break
		end
	end
	
	Equus_Vars["Options"]["lastpet"] = petnumber
	CallCompanion("CRITTER", petnumber)
	
end

function EIgetisflyable()
--Get the continent the player is on
	SetMapToCurrentZone()
	currentContinent = GetCurrentMapContinent()
	local zoneName = GetRealZoneText()
	local subZone = GetSubZoneText()
	local coldweatherflying, _ = IsUsableSpell("Cold Weather Flying") -- Does the player have Cold Weather Flying?
	
	if (IsFlyableArea() and zoneName ~= "Wintergrasp") or (zoneName == "Wintergrasp" and GetWintergraspWaitTime())then
		--If in Northrend but you don't have coldweather flying; flyable = false;
		if currentContinent == 4 and not coldweatherflying then
			EIprint("No cold weather flying found.")
			return false
		else
			--If you are in Wintergrasp or Dalaran and you are not in an subzone where flying is permitted; flyable = false;
			if zoneName == "Dalaran" and not strfind(subZone,"Krasus") then  
				EIprint("In dalaran - no flying")
				return false
			else
				--EIprint("Flyable area!  yey.")
				return true
			end
		end
	else
		EIprint("Not a flyable area.")
		return false
	end
end
function Equus_GetRidingSkill()
	for skillIndex = 1, GetNumSkillLines() do
		skillName, _, _, skillRank, _, _, _, _, _, _, _, _, _ = GetSkillLineInfo(skillIndex)
		if skillName == "Riding" then
			return skillRank
		end
	end
	return 0
end
function Equus_InspectHooker()
	if Equus_Vars["Options"]["inspect"] ~= 1 then return end
	if UnitIsPlayer("target") ~= 1 then return end
	local x,haxx
	if UnitFactionGroup("target") ~= UnitFactionGroup("player") then
		x = PanelTemplates_GetSelectedTab(InspectFrame)
		haxx = getglobal(INSPECTFRAME_SUBFRAMES[x])
		PanelTemplates_SetNumTabs(InspectFrame, 3);
		InspectFrameTab4:Hide()
		PanelTemplates_SetTab(InspectFrame, 1);
		haxx:Hide()
		haxx = getglobal(INSPECTFRAME_SUBFRAMES[1])
		haxx:Show()
		return
	else
		x = PanelTemplates_GetSelectedTab(InspectFrame)
		haxx = getglobal(INSPECTFRAME_SUBFRAMES[x])
		PanelTemplates_SetNumTabs(InspectFrame, 4);
		InspectFrameTab4:Show()
		PanelTemplates_SetTab(InspectFrame, 1);
		haxx:Hide()
		haxx = getglobal(INSPECTFRAME_SUBFRAMES[1])
		haxx:Show()
	end
	EquusInspectedMountSpeciesNum = 1
	EquusInspectedMountSpeedNum = 1
	EquusInspectedMountPassengerNum = 1
	EquusInspectedMountColourNum = 1
	EquusInspectedPetSpeciesNum = 1
	EquusInspectedPetTypeNum = 1
	EquusInspectedPetColourNum = 1
	Equus_InspectMounts = {}
	Equus_InspectPets = {}
	local name = GetUnitName("target",true)
	local test = strfind(name," ")
	if (test) then
		name = strsub(name,1,strfind(name," ")-1).."-"..strsub(name,strfind(name," ")+3)
	end
	SendAddonMessage("EQUUS","INSPECT","WHISPER",name)
	Equus_UpdateInspect()
end
function Equus_UpdateInspect()
	if Equus_Vars["Options"]["inspect"] ~= true then return end
	local iconi = 1
	for i = 1,#Equus_InspectPets do
		if (not Equus_InspectPets[i]) then break end;
		spellID = Equus_InspectPets[i]
		petname,_,icon,_,_,_,_,_,_ = GetSpellInfo(spellID)
		
		petspeed = Equus_PetDataBySpell[tonumber(spellID)]["type"].." "..Equus_PetDataBySpell[tonumber(spellID)]["species"].." - "..Equus_PetDataBySpell[tonumber(spellID)]["colour1"]
		if Equus_PetDataBySpell[tonumber(spellID)]["colour2"] ~= nil then petspeed = petspeed.."/"..Equus_PetDataBySpell[tonumber(spellID)]["colour2"] end
		
		peticon = getglobal("equusinspeticon"..iconi)
		peticon:Show()
		peticon.spell = spellID
		buttn = getglobal(peticon:GetName().."_MountIcon")
		pettexture = getglobal(peticon:GetName().."_MountIcon_IconTexture")
		petdisplayname = getglobal(peticon:GetName().."_MountIcon_Name")
		petdisplayspeed = getglobal(peticon:GetName().."_MountIcon_Speed")
		
		buttn.link = GetSpellLink(spellID)
		pettexture:SetTexture(icon)
		petdisplayname:SetText(petname)
		petdisplayspeed:SetText(petspeed)
		
		buttn:SetAttribute("type","spell")
		buttn:SetAttribute("spell",spellID)
		
		iconi=iconi+1
	end
	
	peticon = getglobal("equusinspeticon"..iconi)
	while(peticon) do
		peticon:Hide()
		peticon.id = 0
		iconi=iconi+1
		peticon = getglobal("equusinspeticon"..iconi)
	end
	
	local height = (#Equus_InspectPets * 48)
	
	if height > 0 then
		HSF_Update(equusinspectpetpanelScrollPanel, height, 165);
		HSF_SetOffset(equusinspectpetpanelScrollPanel, 0);
		equusinspectpetpanelScrollPanel.scrollBar:SetValue(0);
	end
	
	local iconi = 1
	for i = 1,#Equus_InspectMounts do
		if (not Equus_InspectMounts[i]) then break end;
		spellID = Equus_InspectMounts[i]
		mountname,_,icon,_,_,_,_,_,_ = GetSpellInfo(spellID)
		
		mountspeed = Equus_MountDataBySpell[spellID]["speed"].." "..Equus_MountDataBySpell[spellID]["species"].." - "..Equus_MountDataBySpell[spellID]["colour1"] --DEBUGME speed as %
		if Equus_MountDataBySpell[spellID]["colour2"] ~= nil then mountspeed = mountspeed.."/"..Equus_MountDataBySpell[spellID]["colour2"] end
		
		mounticon = getglobal("equusinsmounticon"..iconi)
		mounticon:Show()
		mounticon.spell = spellID
		buttn = getglobal(mounticon:GetName().."_MountIcon")
		mounttexture = getglobal(mounticon:GetName().."_MountIcon_IconTexture")
		mountdisplayname = getglobal(mounticon:GetName().."_MountIcon_Name")
		mountdisplayspeed = getglobal(mounticon:GetName().."_MountIcon_Speed")
		
		buttn.link = GetSpellLink(spellID)
		mounttexture:SetTexture(icon)
		mountdisplayname:SetText(mountname)
		mountdisplayspeed:SetText(mountspeed)
		
		buttn:SetAttribute("type","spell")
		buttn:SetAttribute("spell",spellID)
		
		iconi=iconi+1
	end
	
	mounticon = getglobal("equusinsmounticon"..iconi)
	while(mounticon) do
		mounticon:Hide()
		mounticon.id = 0
		iconi=iconi+1
		mounticon = getglobal("equusinsmounticon"..iconi)
	end
	
	local height = (#Equus_InspectMounts * 48)
	
	if height > 0 then
		HSF_Update(equusinspectmountpanelScrollPanel, height, 165);
		HSF_SetOffset(equusinspectmountpanelScrollPanel, 0);
		equusinspectmountpanelScrollPanel.scrollBar:SetValue(0);
	end
end
function Equus_Dismiss()
	DismissCompanion("CRITTER")
	Equus_Vars["Options"]["lastpet"] = 0
end

function Equus_CreateTables()
	if EIallowupdate ~= 1 then return end
	EIprint("Entering |c00ffff00 CreateTables")
	local mountnum = GetNumCompanions("MOUNT")
	local petnum = GetNumCompanions("CRITTER")
	local text,link,mountname,spellID,icon
	local ridingskill = Equus_GetRidingSkill()
	
	-- Empty the tables
	Equus_Mounts = {}
	Equus_Pets = {}

	-- Add the categories to the filter-fixxer tables
	for key,value in pairs(Equus_Filters.MountSpecies) do
		Equus_FilterMountSpecies[value] = 0
	end
	for key,value in pairs(Equus_Filters.PetSpecies) do
		Equus_FilterPetSpecies[value] = 0
	end
	for key,value in pairs(Equus_Filters.MountSpeeds) do
		Equus_FilterSpeeds[value] = 0
	end
	Equus_FilterMountSpecies["AllSpecies"] = 2
	Equus_FilterPetSpecies["AllSpecies"] = 2
	
	if(not EquusTooltip) then
		EquusTooltip = CreateFrame("GameTooltip", "EquusTooltip", nil, "GameTooltipTemplate") 
	end
	
	local spname,spellID,icon,species,speed,passengers,colour1,colour2,namefound,bugcatch
	EquusTooltip:SetOwner(WorldFrame,"ANCHOR_NONE")
	
	for i=1,mountnum do
		bugcatch = 0
		for bugcatch=0,10 do
			_, spname, spellID, icon, _ = GetCompanionInfo("MOUNT", i)
			if spellID ~= nil then break end
		end
		if bugcatch < 10 and spellID ~= nil then
			link = GetSpellLink(spellID)
			EquusTooltip:SetHyperlink(link) -- Set link for tooltip
			
			namefound = 0
			for x=1,#Equus_MountPosToSpell do
				if Equus_MountPosToSpell[x] == tostring(spellID) then
					namefound = 1
					break
				end
			end
		
			if namefound == 0 then
				if spname == nil then spname = "nil" end
				print("EquusInfinata: Error processing mount \""..spname.."\" (id:"..spellID.."). Please report this via Curse.com")
				Equus_MountDataBySpell[tostring(spellID)] = {}
				Equus_MountDataBySpell[tostring(spellID)]["pos"] = "fail"
				Equus_MountDataBySpell[tostring(spellID)]["name"] = spname
				Equus_MountDataBySpell[tostring(spellID)]["species"] = "Unknown"
				Equus_MountDataBySpell[tostring(spellID)]["speed"] = "NoSpeed"
				Equus_MountDataBySpell[tostring(spellID)]["passengers"] = "NoPassengers"
				Equus_MountDataBySpell[tostring(spellID)]["from"] = "Unknown"
				Equus_MountDataBySpell[tostring(spellID)]["faction"] = "N"
				Equus_MountDataBySpell[tostring(spellID)]["obtainable"] = "N"
				Equus_MountDataBySpell[tostring(spellID)]["colour1"] = "Black"
				Equus_MountDataBySpell[tostring(spellID)]["colour2"] = nil
				Equus_MountDataBySpell[tostring(spellID)]["got"] = "0"
			end
			
			Equus_Mounts[i] = spellID
			Equus_FilterMountSpecies[Equus_MountDataBySpell[tostring(spellID)]["species"]] = Equus_FilterMountSpecies[Equus_MountDataBySpell[tostring(spellID)]["species"]] + 1
			Equus_FilterSpeeds[Equus_MountDataBySpell[tostring(spellID)]["speed"]] = 1
			Equus_MountDataBySpell[tostring(spellID)]["got"] = "1"
			
		else
			print("EquusInfinata: Critical error processing mount in position \""..i.."\". This mount will not be displayed in your Equus interface. Please report this error via curse.com")
		end
		
	end
	
	for i=1,petnum do
		bugcatch = 0
		for bugcatch=0,10 do
			_, spname, spellID, icon, _ = GetCompanionInfo("CRITTER", i)
			if spellID ~= nil then break end
		end
		if bugcatch < 10 and spellID ~= nil then
			link = GetSpellLink(spellID)
			EquusTooltip:SetHyperlink(link) -- Set link for tooltip
			
			namefound = 0
			for x=1,#Equus_PetPosToSpell do
				if Equus_PetPosToSpell[x] == tostring(spellID) then
					namefound = 1
					break
				end
			end
		
			if namefound == 0 then
				if spname == nil then spname = "nil" end
				print("EquusInfinata: Error processing pet \""..spname.."\" (id:"..spellID.."). Please report this via Curse.com")
				Equus_PetDataBySpell[spellID] = {}
				Equus_PetDataBySpell[spellID]["name"] = spname
				Equus_PetDataBySpell[spellID]["species"] = "Unknown"
				Equus_PetDataBySpell[spellID]["type"] = "Unknown"
				Equus_PetDataBySpell[spellID]["pos"] = "fail"
				Equus_PetDataBySpell[spellID]["from"] = "Unknown"
				Equus_PetDataBySpell[spellID]["obtainable"] = "N"
				Equus_PetDataBySpell[spellID]["colour1"] = "Black"
				Equus_PetDataBySpell[spellID]["colour2"] = nil
				Equus_PetDataBySpell[spellID]["got"] = "0"
			end
			
			Equus_Pets[i] = spellID
			Equus_FilterPetSpecies[Equus_PetDataBySpell[spellID]["species"]] = Equus_FilterPetSpecies[Equus_PetDataBySpell[spellID]["species"]] + 1
			Equus_PetDataBySpell[spellID]["got"] = "1"
			
		else
			print("EquusInfinata: Critical error processing pet in position \""..i.."\". This pet will not be displayed in your Equus interface. Please report this error via curse.com")
		end
		
	end
	
	if EquusLoaded == 1 then
		local species = {}
		local speciesother = 0
		for i=1,#Equus_Filters["PetSpecies"] do
			if Equus_FilterPetSpecies[Equus_Filters["PetSpecies"][i]] > 1 then
				species[#species + 1] = Equus_Filters["PetSpecies"][i]
			elseif Equus_FilterPetSpecies[Equus_Filters["PetSpecies"][i]] == 1 then
				speciesother = 1
			end
		end
		if speciesother == 1 then
			species[#species + 1] = "Other"
		end
		function EquusPetSpecMenuOnClick(self)
			UIDropDownMenu_SetSelectedID(EquusPetSpeciesMenu, self:GetID())
			EquusSelectedPetSpeciesNum = self:GetID()
			Equus_Update()
		end
		function EquusPetSpecMenuInit(self, level)
			local info = UIDropDownMenu_CreateInfo()
			for k,v in pairs(species) do
				info = UIDropDownMenu_CreateInfo()
				info.text = v
				info.value = k
				info.func = EquusPetSpecMenuOnClick
				UIDropDownMenu_AddButton(info, level)
			end
		end
		UIDropDownMenu_Initialize(EquusPetSpeciesMenu, EquusPetSpecMenuInit)
		
		function EquusPetTypeMenuOnClick(self)
			UIDropDownMenu_SetSelectedID(EquusPetTypeMenu, self:GetID())
			EquusSelectedPetTypeNum = self:GetID()
			Equus_Update()
		end
		function EquusPetTypeMenuInit(self, level)
			local info = UIDropDownMenu_CreateInfo()
			for k,v in pairs(Equus_Filters["PetTypes"]) do
				info = UIDropDownMenu_CreateInfo()
				info.text = v
				info.value = k
				info.func = EquusPetTypeMenuOnClick
				UIDropDownMenu_AddButton(info, level)
			end
		end
		UIDropDownMenu_Initialize(EquusPetTypeMenu, EquusPetTypeMenuInit)
		
		function EquusPetColourMenuOnClick(self)
			UIDropDownMenu_SetSelectedID(EquusPetColourMenu, self:GetID())
			EquusSelectedPetColourNum = self:GetID()
			Equus_Update()
		end
		function EquusPetColourMenuInit(self, level)
			local info = UIDropDownMenu_CreateInfo()
			for k,v in pairs(Equus_Filters["Colours"]) do
				info = UIDropDownMenu_CreateInfo()
				info.text = v
				info.value = k
				info.func = EquusPetColourMenuOnClick
				UIDropDownMenu_AddButton(info, level)
			end
		end
		UIDropDownMenu_Initialize(EquusPetColourMenu, EquusPetColourMenuInit)
		
		local species = {}
		local speciesother = 0
		for i=1,#Equus_Filters["MountSpecies"] do
			if Equus_FilterMountSpecies[Equus_Filters["MountSpecies"][i]] > 1 then
				species[#species + 1] = Equus_Filters["MountSpecies"][i]
			elseif Equus_FilterMountSpecies[Equus_Filters["MountSpecies"][i]] == 1 then
				speciesother = 1
			end
		end
		if speciesother == 1 then
			species[#species + 1] = "Other"
		end
		function EquusMountSpecMenuOnClick(self)
			UIDropDownMenu_SetSelectedID(EquusMountSpeciesMenu, self:GetID())
			EquusSelectedMountSpeciesNum = self:GetID()
			Equus_Update()
		end
		function EquusMountSpecMenuInit(self, level)
			local info = UIDropDownMenu_CreateInfo()
			for k,v in pairs(species) do
				info = UIDropDownMenu_CreateInfo()
				info.text = v
				info.value = k
				info.func = EquusMountSpecMenuOnClick
				UIDropDownMenu_AddButton(info, level)
			end
		end
		UIDropDownMenu_Initialize(EquusMountSpeciesMenu, EquusMountSpecMenuInit)
		
		function EquusMountSpeedMenuOnClick(self)
			UIDropDownMenu_SetSelectedID(EquusMountSpeedMenu, self:GetID())
			EquusSelectedMountSpeedNum = self:GetID()
			Equus_Update()
		end
		function EquusMountSpeedMenuInit(self, level)
			local info = UIDropDownMenu_CreateInfo()
			for k,v in pairs(Equus_Filters["MountSpeeds"]) do
				info = UIDropDownMenu_CreateInfo()
				info.text = v
				info.value = k
				info.func = EquusMountSpeedMenuOnClick
				UIDropDownMenu_AddButton(info, level)
			end
		end
		UIDropDownMenu_Initialize(EquusMountSpeedMenu, EquusMountSpeedMenuInit)
		
		function EquusMountColourMenuOnClick(self)
			UIDropDownMenu_SetSelectedID(EquusMountColourMenu, self:GetID())
			EquusSelectedMountColourNum = self:GetID()
			Equus_Update()
		end
		function EquusMountColourMenuInit(self, level)
			local info = UIDropDownMenu_CreateInfo()
			for k,v in pairs(Equus_Filters["Colours"]) do
				info = UIDropDownMenu_CreateInfo()
				info.text = v
				info.value = k
				info.func = EquusMountColourMenuOnClick
				UIDropDownMenu_AddButton(info, level)
			end
		end
		UIDropDownMenu_Initialize(EquusMountColourMenu, EquusMountColourMenuInit)
		
		function EquusMountPassengerMenuOnClick(self)
			UIDropDownMenu_SetSelectedID(EquusMountPassengerMenu, self:GetID())
			EquusSelectedMountPassengerNum = self:GetID()
			Equus_Update()
		end
		function EquusMountPassengerMenuInit(self, level)
			local info = UIDropDownMenu_CreateInfo()
			for k,v in pairs(Equus_Filters["MountPassengers"]) do
				info = UIDropDownMenu_CreateInfo()
				info.text = v
				info.value = k
				info.func = EquusMountPassengerMenuOnClick
				UIDropDownMenu_AddButton(info, level)
			end
		end
		UIDropDownMenu_Initialize(EquusMountPassengerMenu, EquusMountPassengerMenuInit)
	end
	
	EquusMountSendList = ""
	EquusPetSendList = ""
	local mtemp = ""
	local ptemp = ""
	for i=1,#Equus_MountPosToSpell do
		mtemp = mtemp..Equus_MountDataBySpell[Equus_MountPosToSpell[i]]["got"]
	end
	for i=1,#Equus_PetPosToSpell do
		ptemp = ptemp..Equus_PetDataBySpell[tonumber(Equus_PetPosToSpell[i])]["got"]
	end
	
	local mfix,pfix = 0
	mfix = ceil(strlen(mtemp)/6)*6 - strlen(mtemp)
	pfix = ceil(strlen(ptemp)/6)*6 - strlen(ptemp)
	for i=1,mfix do mtemp = mtemp.."0" end
	for i=1,pfix do ptemp = ptemp.."0" end
	
	for i=1,(strlen(mtemp)/6) do
		EquusMountSendList = EquusMountSendList..Equus_BinToCode[strsub(mtemp,((i*6)-5),(i*6))]
	end
	for i=1,(strlen(ptemp)/6) do
		EquusPetSendList = EquusPetSendList..Equus_BinToCode[strsub(ptemp,((i*6)-5),(i*6))]
	end
	
	EItablesdone = 1
end

function Equus_OnCheckBox(self)
	if ( self:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		PlaySound("igMainMenuOptionCheckBoxOff");
	end
	BlizzardOptionsPanel_CheckButton_OnClick(self);
	local selfname = self:GetName()
	local name = strsub(selfname,1,strlen(selfname)-9)
	local button = getglobal(name)
	local spell = button.spell
	local temphack,temphacktable
	
	if self:GetChecked() then
		Equus_Vars["Customs"..EquusTab][#Equus_Vars["Customs"..EquusTab]+1] = spell
	else
		local temphackrem
		for i=1,#Equus_Vars["Customs"..EquusTab] do
			if Equus_Vars["Customs"..EquusTab][i] == spell then
				temphackrem = i
				break
			end
		end
		table.remove(Equus_Vars["Customs"..EquusTab],temphackrem)
	end
end
function Equus_OnDrag(self)
	if not self then return end
	local mountnumber = 0
	local name = self:GetAttribute("spell")
	local haxx
	if EquusTab == "MOUNT" then haxx = #Equus_Mounts else haxx = #Equus_Pets end
	for i = 1,haxx do
		_,_,temp,_,_ = GetCompanionInfo(EquusTab,i)
		if temp == name then
			mountnumber = i
			break
		end
	end
	ClearCursor();
	PickupCompanion(EquusTab, mountnumber);
end
function Equus_OnClick(self)
	local mountnumber
	local name = self:GetAttribute("spell")
	local haxx
	if EquusTab == "MOUNT" then haxx = #Equus_Mounts else haxx = #Equus_Pets end
	for i=1,haxx do
		_,_,temp,_,_ = GetCompanionInfo(EquusTab,i)
		if tonumber(temp) == tonumber(name) then
			mountnumber = i
			break
		end
	end
	DismissCompanion(EquusTab);
	if EquusTab == "CRITTER" then
		Equus_Vars["Options"]["lastpet"] = mountnumber
	end
	CallCompanion(EquusTab, mountnumber);
end
function Equus_OnModifiedClick(self)
	local name = self:GetAttribute("spell")
	if ( IsModifiedClick("CHATLINK") ) then
		if ( MacroFrame and MacroFrame:IsShown() ) then
			ChatEdit_InsertLink(name);
		else
			local spellLink = GetSpellLink(tonumber(name))
			ChatEdit_InsertLink(spellLink);
		end
	elseif ( IsModifiedClick("PICKUPACTION") ) then
		CompanionButton_OnDrag(self);
	end
end
function equusicon_OnEnter()
	--EIprint("ON enter breeched.  link="..this.link)
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
	GameTooltip:SetHyperlink(this.link)
	GameTooltip:Show()

end
function Equus_OnClickRightButton(button)
	local creature = button.id
	CompanionModelFrame:SetCreature(creature);
end



function PetPaperDollFrame_UpdateCompanions()
	return
end
