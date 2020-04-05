--[[****************************************************************************
  * GuildBankSearch by Saiket, originally by Harros                            *
  * Locales/Locale-zhTW.lua - Localized string constants (zhTW) by jyuny1.     *
  ****************************************************************************]]


if ( GetLocale() == "zhTW" ) then
	GuildBankSearchLocalization = setmetatable( {
		FILTER = "物品搜索";
		CLEAR = "清除";

		NAME = "名稱:";
		QUALITY = "品質:";
		ITEM_LEVEL = "物品等級:";
		REQUIRED_LEVEL = "需要等級:";

		ITEM_CATEGORY = "分類物品";
		TYPE = "類別:";
		SUB_TYPE = "副類別:";
		SLOT = "欄位:";

		ALL = "|cffcccccc(所有)|r";
	}, { __index = GuildBankSearchLocalization; } );
end
