
local HideTooltip, ShowTooltip, GS, G = Panda.HideTooltip, Panda.ShowTooltip, Panda.GS, Panda.G
local auc = LibStub("tekAucQuery")


local server = GetRealmName().." "..UnitFactionGroup("player")
local UNK, ICONS = "Interface\\Icons\\INV_Misc_QuestionMark", {
	STA = "Spell_Nature_UnyeildingStamina", RES = "Spell_Holy_ChampionsGrace",
	AGI = "Spell_Holy_BlessingOfAgility", AP = "Spell_Holy_FistOfJustice", STR = "Spell_Nature_Strength", DAM = "Ability_Gouge",
	ARM = "INV_Misc_ArmorKit_25", BLKR = "Ability_Warrior_DefensiveStance", BLKV = "INV_Shield_04", DEF = "Ability_Defend", DOD = "Spell_Nature_Invisibilty",
	INT = "Spell_Holy_MagicalSentry", SPI = "Spell_Holy_DivineSpirit", SP = "Spell_Holy_MindVision",
	BEAST = "Ability_Druid_FerociousBite", ELEM = "Spell_Frost_SummonWaterElemental", DEMON = "Spell_Shadow_DemonicTactics",
	RALL = "Spell_Frost_WizardMark", RFR = "Spell_Frost_FrostWard", RSH = "Spell_Shadow_AntiShadow", RFI = "Spell_Fire_FireArmor", RAR = "Spell_Nature_StarFall", RNA = "Spell_Nature_ResistNature",
	FIP = "Spell_Fire_FireBolt02", FRP = "Spell_Frost_FrostBolt02", SHP = "Spell_Shadow_ShadowBolt",
	HP = "INV_Potion_51", MP = "INV_Potion_72", HMP = "INV_Potion_79", MPR = "Spell_Magic_ManaGain",
	STAT = "Spell_ChargePositive", EXP = "Spell_Holy_BlessingOfStrength", SPE = "Spell_Fire_BurningSpeed",
	HIT = "Ability_Marksmanship", CRIT = "Ability_Rogue_KidneyShot",
	MONGOOSE = "Spell_Nature_UnrelentingStorm", BERSERK = "Spell_Shadow_DeathPact", FROST = "Spell_Frost_FrostShock", UNHOLY = "Spell_Shadow_CurseOfMannoroth", CRUSADER = "Spell_Holy_WeaponMastery",
	FIERY = "Spell_Fire_Immolation", WINTER = "Spell_Frost_FrostNova", LIFESTEAL = "Spell_Shadow_LifeDrain", SOULFROST = "Spell_Holy_ConsumeMagic", SUNFIRE = "Ability_Mage_FireStarter",
	FISH = "INV_Misc_Fish_09", HERB = "INV_Misc_Flower_02", MINE = "Trade_Mining", SKIN = "INV_Misc_Pelt_Wolf_01", MOUNT = "INV_Misc_Crop_02", THREAT = "Spell_Nature_Reincarnation",
	GATHER = "Trade_Herbalism", HASTE = "Ability_Hunter_RunningShot", STL = "Ability_Stealth", FADE = "Spell_Magic_LesserInvisibilty",
	SPEN = "Spell_Nature_StormReach", APEN = "Ability_Rogue_Rupture", PARRY = "Ability_Parry", GIANT = "Ability_Racial_Avatar", UNDEAD = "Spell_Shadow_DarkSummoning"
}


local function OnEvent(self)
	if not self.id then return end
	local count = GetItemCount(self.id)
	self.count:SetText(count > 0 and count or "")
	if self.text then
		local auc_price = auc[self.id]
		local craft_price = not self.notcrafted and GetReagentCost and GetReagentCost(self.id)
		local price = auc_price and craft_price and Panda.showprofit and (auc_price - craft_price) or auc_price
		if price and price < 100 then price = nil end
		self.text:SetText(GS(price))
	end


	if ForSaleByOwnerDB then
		local count, name = 0, GetItemInfo(self.id)
		for char,vals in pairs(ForSaleByOwnerDB[server]) do count = count + (vals[name] or 0) end
		self.ahcount:SetText(count ~= 0 and count or "")
	end
end


local function OnHide(self) self:UnregisterEvent("BAG_UPDATE") end
local function OnShow(self)
	self:RegisterEvent("BAG_UPDATE")
	OnEvent(self)
end


function Panda.CraftMacro(name, id, extra)
	local linkfunc, linktoken = extra and "GetTradeSkillRecipeLink" or "GetTradeSkillItemLink", extra and "enchant:" or "item:"
	return "/run if IsShiftKeyDown() then ChatEdit_InsertLink(select(2, GetItemInfo("..id.."))) end\n"..
		"/stopmacro [mod:shift]\n"..
		"/run CloseTradeSkill()\n/cast "..name.."\n"..
		"/run for i=1,GetNumTradeSkills() do local l = "..linkfunc.."(i) if l and l:match('"..linktoken..(extra or id)..(extra and "" or ":").."') then "..
			"TradeSkillFrame_SetSelection(i); DoTradeSkill(i, IsAltKeyDown() and select(3, GetTradeSkillInfo(i)) or 1) end end\n"..
		"/run if not IsAltKeyDown() then CloseTradeSkill() end"
end


function Panda.ButtonFactory(parent, id, secure, notext, extra, ...)
	local extraid, extraicon = (extra or ""):match("(%d*):?(%S*)")
	local customicon = extraicon ~= "" and extraicon

	local f = CreateFrame(secure and "CheckButton" or "Frame", id == 6948 and "MassMill" or nil, parent, secure and "SecureActionButtonTemplate")
	local texture = GetItemIcon(id)
	f.id = id
	if extraid and extraid ~= "" then f.extra, f.tiplink = extraid, "spell:"..extraid end

	f:SetHeight(32)
	f:SetWidth(32)
	if not secure then f:EnableMouse() end
	if select("#", ...) > 0 then f:SetPoint(...) end
	f:SetScript("OnEnter", ShowTooltip)
	f:SetScript("OnLeave", HideTooltip)
	f:SetScript("OnShow", OnShow)
	f:SetScript("OnHide", OnHide)
	f:SetScript("OnEvent", OnEvent)

	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints(f)
	icon:SetTexture(texture and (customicon and ("Interface\\Icons\\".. ICONS[customicon]) or texture) or UNK)
	f.icon = icon

	if not notext then
		f.text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		f.text:SetPoint("TOP", icon, "BOTTOM")
	end

	local count = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
	count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
	f.count = count

	f.ahcount = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
	f.ahcount:SetPoint("TOPRIGHT", icon, "TOPRIGHT", -2, -2)

	if secure then
		if type(secure) == "function" then
			secure(f)
		else
			f:SetAttribute("type", "macro")
			f:SetAttribute("macrotext", Panda.CraftMacro(secure, id, f.extra))
		end
	end

	if f:IsVisible() then OnShow(f) end

	return f
end


function Panda.RefreshButtonFactory(parent, tradeskill, ...)
	local b = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
	b:SetPoint(...)
	b:SetWidth(80) b:SetHeight(22)

	-- Fonts --
	b:SetDisabledFontObject(GameFontDisable)
	b:SetHighlightFontObject(GameFontHighlight)
	b:SetNormalFontObject(GameFontNormal)

	-- Textures --
	b:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	b:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	b:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	b:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	b:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	b:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	b:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	b:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	b:GetHighlightTexture():SetBlendMode("ADD")

	b:SetText("Refresh")
	b:SetAttribute("type", "macro")
	b:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast "..tradeskill.."\n/run CloseTradeSkill()")

	return b
end
