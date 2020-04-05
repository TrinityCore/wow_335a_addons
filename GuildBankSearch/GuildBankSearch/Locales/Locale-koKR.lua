--[[****************************************************************************
  * GuildBankSearch by Saiket, originally by Harros                            *
  * Locales/Locale-koKR.lua - Localized string constants (ko-KR) by            *
  *   freshworks.                                                              *
  ****************************************************************************]]


if ( GetLocale() == "koKR" ) then
	GuildBankSearchLocalization = setmetatable( {
		FILTER = "필터";
		CLEAR = "삭제";

		NAME = "이름:";
		QUALITY = "품질:";
		ITEM_LEVEL = "아이템 레벨:";
		REQUIRED_LEVEL = "필요 레벨:";

		ITEM_CATEGORY = "아이템 분류";
		TYPE = "종류:";
		SUB_TYPE = "부-종류:";
		SLOT = "슬롯:";

		ALL = "|cffcccccc(모두)|r";
	}, { __index = GuildBankSearchLocalization; } );
end
