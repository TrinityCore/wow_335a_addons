--[[****************************************************************************
  * GuildBankSearch by Saiket, originally by Harros                            *
  * Locales/Locale-frFR.lua - Localized string constants (fr-FR) by Nodd.      *
  ****************************************************************************]]


if ( GetLocale() == "frFR" ) then
	GuildBankSearchLocalization = setmetatable( {
		FILTER = "Filtrer";
		CLEAR = "RàZ";

		NAME = "Nom:";
		QUALITY = "Qualité:";
		ITEM_LEVEL = "iLevel:";
		REQUIRED_LEVEL = "Level requis:";

		ITEM_CATEGORY = "Categorie d'objet";
		TYPE = "Type:";
		SUB_TYPE = "Sous-type:";
		SLOT = "Emplacement:";

		ALL = "|cffcccccc(Tout)|r";
	}, { __index = GuildBankSearchLocalization; } );
end
