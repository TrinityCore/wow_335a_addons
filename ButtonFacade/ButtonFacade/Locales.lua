--[[
	Project.: ButtonFacade
	File....: Locales.lua
	Version.: 328
	Author..: StormFX
]]

-- This contents of this file are automatically generated.
-- Please use the localization application on WoWAce.com to submit translations.
-- http://www.wowace.com/projects/buttonfacade/localization/

-- Get the private table.
local _, ns = ...

-- Hard-code enUS/enGB.
ns.L = {
	["ADDON_INFO"] = "This section allows you adjust skin settings on a per-add-on basis. You can also adjust the settings of individual groups, bars and buttons of the add-on if available. Note that changes here only affect the selected elements and are saved by the add-on.",
	["AddOns"] = "AddOns",
	["Apply skin to all buttons registered with %s."] = "Apply skin to all buttons registered with %s.",
	["Apply skin to all buttons registered with %s: %s."] = "Apply skin to all buttons registered with %s: %s.",
	["Apply skin to all buttons registered with %s: %s/%s."] = "Apply skin to all buttons registered with %s: %s/%s.",
	["Backdrop Settings"] = "Backdrop Settings",
	["BF_INFO"] = "ButtonFacade, with its associated library, is a small add-on that allows for the dynamic skinning of button-based add-ons.",
	["Border Colors"] = "Border Colors",
	["Checked"] = "Checked",
	["Color"] = "Color",
	["Curse"] = "Curse",
	["Custom"] = "Custom",
	["Debuff"] = "Debuff",
	["Disabled"] = "Disabled",
	["Disease"] = "Disease",
	["Enable"] = "Enable",
	["Enable the backdrop."] = "Enable the backdrop.",
	["Enchant"] = "Enchant",
	["Equipped"] = "Equipped",
	["Flash"] = "Flash",
	["GLOBAL_INFO"] = "This section allows you adjust the skin settings globally. Note that while changes here will affect all registered elements, ButtonFacade only saves changes made at this level.",
	["Global Settings"] = "Global Settings",
	["Gloss Settings"] = "Gloss Settings",
	["Highlight"] = "Highlight",
	["Magic"] = "Magic",
	["Normal"] = "Normal",
	["Opacity"] = "Opacity",
	["Poison"] = "Poison",
	["Profiles"] = "Profiles",
	["Pushed"] = "Pushed",
	["Reset All Colors"] = "Reset All Colors",
	["Reset all colors to their defaults."] = "Reset all colors to their defaults.",
	["Set the backdrop color."] = "Set the backdrop color.",
	["Set the border color for curses."] = "Set the border color for curses.",
	["Set the border color for custom types."] = "Set the border color for custom types.",
	["Set the border color for debuffs that cannot be removed."] = "Set the border color for debuffs that cannot be removed.",
	["Set the border color for diseases."] = "Set the border color for diseases.",
	["Set the border color for equipped items."] = "Set the border color for equipped items.",
	["Set the border color for magic."] = "Set the border color for magic.",
	["Set the border color for poisons."] = "Set the border color for poisons.",
	["Set the border color for weapon enchants."] = "Set the border color for weapon enchants.",
	["Set the color of the checked texture."] = "Set the color of the checked texture.",
	["Set the color of the disabled texture."] = "Set the color of the gloss texture.",
	["Set the color of the flash texture."] = "Set the color of the flash texture.",
	["Set the color of the gloss texture."] = "Set the color of the gloss texture.",
	["Set the color of the highlight texture."] = "Set the color of the highlight texture.",
	["Set the color of the normal texture."] = "Set the color of the normal texture.",
	["Set the color of the pushed texture."] = "Set the color of the pushed texture.",
	["Set the intensity of the gloss."] = "Set the intensity of the gloss.",
	["Set the skin."] = "Set the skin.",
	["Skin"] = "Skin",
	["Custom"] = "Custom",
	["State Colors"] = "State Colors",
}

-- Automatically inject all other locales.
do
	local LOC = GetLocale()
	if LOC == "deDE" then
ns.L["ADDON_INFO"] = "Hier kannst Du die Skin-Einstellungen für jedes Addon einzeln festlegen. Du kannst zusätzlich auch die Einstellungen einzelner Gruppen, Balken und Buttons, falls möglich, anpassen."
ns.L["AddOns"] = "AddOns"
ns.L["Apply skin to all buttons registered with %s."] = "Skin auf allen Buttons für %s anwenden."
ns.L["Apply skin to all buttons registered with %s: %s."] = "Skin auf allen Buttons für %s: %s anwenden."
ns.L["Apply skin to all buttons registered with %s: %s/%s."] = "Skin auf allen Buttons für %s: %s/%s anwenden."
ns.L["Backdrop Settings"] = "Hintergrund Einstellungen"
ns.L["BF_INFO"] = "ButtonFacade ist ein kleines Addon, dass das dynamisches Texturieren, auf Buttons basierter Addons ermöglicht."
ns.L["Checked"] = "Ausgewählt"
ns.L["Color"] = "Farbe"
ns.L["Disabled"] = "Deaktiviert"
ns.L["Enable"] = "Aktivieren"
ns.L["Enable the backdrop."] = "Den Hintergrund an- oder ausschalten."
ns.L["Equipped"] = "Angelegt"
ns.L["Flash"] = "Leuchten"
ns.L["GLOBAL_INFO"] = "Hier kannst Du die allgemeinen Skin-Einstellungen anpassen. Alle Änderungen werden sich auf alle aufgelisteten Elemente auswirken."
ns.L["Global Settings"] = "Allgemeine Einstellungen"
ns.L["Gloss Settings"] = "Glanz Einstellung"
ns.L["Highlight"] = "Hervorheben"
ns.L["Normal"] = "Normal"
ns.L["Opacity"] = "Transparenz"
ns.L["Profiles"] = "Profile"
ns.L["Pushed"] = "Gedrückt"
ns.L["Reset All Colors"] = "Alle Farben zurücksetzen"
ns.L["Set the intensity of the gloss."] = "Die Stärke des Glanz-Effekts festlegen."
ns.L["Set the skin."] = "Skin festlegen."
ns.L["Skin"] = "Skin"
ns.L["State Colors"] = "Status Farben"
ns.L["ToC/Allows the dynamic skinning of button-based add-ons."] = "Erlaubt das dynamische Texturieren, von Addons die auf Buttons basieren."

	elseif LOC == "esES" then
ns.L["ADDON_INFO"] = "Esta sección le permite ajustar la configuración de las texturas para cada addon base. También puede ajustar la configuración para cada uno de los grupos, barras y botones del addon, si éste lo permite."
ns.L["AddOns"] = "AddOns"
ns.L["Apply skin to all buttons registered with %s."] = "Aplicar textura a todos los botones registrados con %s."
ns.L["Apply skin to all buttons registered with %s: %s."] = "Aplicar textura a todos los botones registrados con %s: %s."
ns.L["Apply skin to all buttons registered with %s: %s/%s."] = "Aplicar textura a todos los botones registrados con %s: %s/%s."
ns.L["BF_INFO"] = "ButtonFacade es un pequeño addon que permite el texturizado dinámico de los botones base de los addons."
ns.L["Checked"] = "Revisado"
ns.L["Disabled"] = "Borde Desactivado"
ns.L["Enable the backdrop."] = "Muestra el fondo."
ns.L["Equipped"] = "Equipado"
ns.L["Flash"] = "Destello"
ns.L["GLOBAL_INFO"] = "Esta sección te permite ajustar las opciones de texturas globales. Cualquier cambio que hagas aquí afectará a todos los elementos registrados."
ns.L["Global Settings"] = "Ajustes Globales"
ns.L["Highlight"] = "Resaltado"
ns.L["Normal"] = "Borde Normal"
ns.L["Profiles"] = "Perfiles"
ns.L["Pushed"] = "Borde Pulsado"
ns.L["Reset All Colors"] = "Restablecer Colores"
ns.L["Set the intensity of the gloss."] = "Establece la intensidad del brillo."
ns.L["Set the skin."] = "Establece la textura."
ns.L["Skin"] = "Textura"
ns.L["ToC/Allows the dynamic skinning of button-based add-ons."] = "Permite el texturizado dinámico de los botones base de los addons."

	elseif LOC == "esMX" then
ns.L["ADDON_INFO"] = "Esta sección le permite ajustar la configuración de las texturas para cada addon base. También puede ajustar la configuración para cada uno de los grupos, barras y botones del addon, si éste lo permite."
ns.L["AddOns"] = "AddOns"
ns.L["Apply skin to all buttons registered with %s."] = "Aplicar piel a todos los botones registrados con %s."
ns.L["Apply skin to all buttons registered with %s: %s."] = "Aplicar piel a todos los botones registrados con %s: %s."
ns.L["Apply skin to all buttons registered with %s: %s/%s."] = "Aplicar textura a todos los botones registrados con %s: %s/%s."
ns.L["BF_INFO"] = "ButtonFacade es un pequeño addon que permite el texturizado dinámico de los botones base de los addons."
ns.L["Checked"] = "Marcado"
ns.L["Disabled"] = "Borde Desactivado"
ns.L["Enable the backdrop."] = "Muestra el fondo."
ns.L["Equipped"] = "Equipado"
ns.L["Flash"] = "Destello"
ns.L["GLOBAL_INFO"] = "Esta sección te permite ajustar las opciones de texturas globales. Cualquier cambio que hagas aquí afectará a todos los elementos registrados."
ns.L["Global Settings"] = "Ajustes Globales"
ns.L["Highlight"] = "Resaltado"
ns.L["Normal"] = "Borde Normal"
ns.L["Profiles"] = "Perfiles"
ns.L["Pushed"] = "Borde Pulsado"
ns.L["Reset All Colors"] = "Restablecer Colores"
ns.L["Set the intensity of the gloss."] = "Establece la intensidad del brillo."
ns.L["Set the skin."] = "Establece la textura."
ns.L["Skin"] = "Textura"
ns.L["ToC/Allows the dynamic skinning of button-based add-ons."] = "Permite el texturizado dinámico de los botones base de los addons."

	elseif LOC == "frFR" then
ns.L["ADDON_INFO"] = "Cette section vous permet de modifier les paramètres du skin addon par addon. Vous pouvez également modifier les paramètres des groupes individuels, des barres et des boutons de l'addon si disponibles. Notez que les changements effectués ici affectent uniquement les éléments sélectionnés et sont sauvegardés par l'addon lui-même."
ns.L["AddOns"] = " AddOns"
ns.L["Apply skin to all buttons registered with %s."] = "Applique le skin à tous les boutons enregistrés avec %s."
ns.L["Apply skin to all buttons registered with %s: %s."] = "Applique le skin à tous les boutons enregistrés avec %s : %s."
ns.L["Apply skin to all buttons registered with %s: %s/%s."] = "Applique le skin à tous les boutons enregistrés avec %s : %s/%s."
ns.L["Backdrop Settings"] = "Paramètres du fond"
ns.L["BF_INFO"] = "ButtonFacade, avec sa bibliothèque associée, est un petit addon qui permet de skinner dynamiquement les addons basés sur des boutons."
ns.L["Checked"] = "Coché"
ns.L["Color"] = "Couleur"
ns.L["Disabled"] = "Désactivé"
ns.L["Enable"] = "Activer"
ns.L["Enable the backdrop."] = "Affiche le fond."
ns.L["Equipped"] = "Équipé"
ns.L["Flash"] = "Flash"
ns.L["GLOBAL_INFO"] = "Cette section vous permet de modifier globalement les paramètres du skin. Notez que, bien que les changements effectués ici affecteront tous les éléments enregistrés, ButtonFacade sauvegardera uniquement les changements effectués au niveau global."
ns.L["Global Settings"] = "Paramètres globaux"
ns.L["Gloss Settings"] = "Paramètres du vernis"
ns.L["Highlight"] = "Surbrillance"
ns.L["Normal"] = "Normal"
ns.L["Opacity"] = "Opacité"
ns.L["Profiles"] = "Profils"
ns.L["Pushed"] = "Enfoncé"
ns.L["Reset All Colors"] = "Réinit. toutes les couleurs"
ns.L["Set the intensity of the gloss."] = "Définit l'intensité du vernis."
ns.L["Set the skin."] = "Définit le skin."
ns.L["Skin"] = "Skin"
ns.L["State Colors"] = "Couleurs d'état"
ns.L["ToC/Allows the dynamic skinning of button-based add-ons."] = "Permet de skinner dynamiquement les addons basés sur des boutons."

	elseif LOC == "koKR" then
ns.L["ADDON_INFO"] = "이 항목은 스킨 설정을 기본적으로 각 애드온별로 조절할 수 있도록 합니다. 따라서 가능하다면 독립적인 애드온의 그룹, 바 및 버튼의 설정을 조절할 수 있습니다. 여기 변경사항은 선택된 구성요소에 한해 영향을 미치게 되고, 그 변경사항은 애드온 자체에 의해 저장된다는 점에 유의하십시요. "
ns.L["AddOns"] = "애드온"
ns.L["Apply skin to all buttons registered with %s."] = "%s에 등록된 모든 버튼에 스킨을 적용합니다."
ns.L["Apply skin to all buttons registered with %s: %s."] = "%s의 %s에 등록된 모든 버튼에 스킨을 적용합니다."
ns.L["Apply skin to all buttons registered with %s: %s/%s."] = "%s의 %s의 %s에 등록된 모든 버튼에 스킨을 적용합니다."
ns.L["Backdrop Settings"] = "바탕 설정"
ns.L["BF_INFO"] = "ButtonFacade는 그 자체의 관련된 라이브러리와 더불어, 버튼 기반의 애드온에 동적인 스킨을 씌워줄 수 있도록 하기 위한 작은 애드온입니다."
ns.L["Border Colors"] = "테두리 색상"
ns.L["Checked"] = "선택된"
ns.L["Color"] = "색상"
ns.L["Curse"] = "저주"
ns.L["Debuff"] = "약화 효과"
ns.L["Disabled"] = "비활성화된"
ns.L["Disease"] = "질병"
ns.L["Enable"] = "활성화"
ns.L["Enable the backdrop."] = "바탕을 활성화합니다."
ns.L["Enchant"] = "무기 강화"
ns.L["Equipped"] = "착용된"
ns.L["Flash"] = "번쩍임"
ns.L["GLOBAL_INFO"] = "이 항목은 스킨 설정을 공통으로 조절할 수 있도록 합니다. 여기가 변경되는 동안에 그것은 등록된 모든 구성요소에 영향을 미치게 되며, ButtonFacade는 이 공통 레벨에서 만들어진 변경사항만을 저장한다는 점에 유의하십시요. "
ns.L["Global Settings"] = "공통 설정"
ns.L["Gloss Settings"] = "번들거림 설정"
ns.L["Highlight"] = "강조된"
ns.L["Magic"] = "마법"
ns.L["Normal"] = "보통의"
ns.L["Opacity"] = "불투명도"
ns.L["Poison"] = "독"
ns.L["Profiles"] = "프로필"
ns.L["Pushed"] = "눌려진"
ns.L["Reset All Colors"] = "모든 색상 초기화"
ns.L["Reset all colors to their defaults."] = "모든 색상을 그것의 기본값으로 초기화 합니다."
ns.L["Set the backdrop color."] = "바탕 색상을 설정합니다."
ns.L["Set the border color for curses."] = "저주에 대한 테두리 색상을 설정합니다."
ns.L["Set the border color for debuffs that cannot be removed."] = "해제 불가능한 약화 효과에 대한 테두리 색상을 설정합니다."
ns.L["Set the border color for diseases."] = "질병에 대한 테두리 색상을 설정합니다."
ns.L["Set the border color for equipped items."] = "착용된 아이템에 대한 테두리 색상을 설정합니다."
ns.L["Set the border color for magic."] = "마법에 대한 테두리 색상을 설정합니다."
ns.L["Set the border color for poisons."] = "독에 대한 테두리 색상을 설정합니다."
ns.L["Set the border color for special types."] = "별도 유형의 버튼에 대한 테두리 색상을 설정합니다."
ns.L["Set the border color for weapon enchants."] = "무기 강화에 대한 테두리 색상을 설정합니다."
ns.L["Set the color of the checked texture."] = "선택된 버튼 텍스처의 색상을 설정합니다."
ns.L["Set the color of the disabled texture."] = "비활성화된 버튼 텍스처의 색상을 설정합니다."
ns.L["Set the color of the flash texture."] = "번쩍임 텍스처의 색상을 설정합니다."
ns.L["Set the color of the gloss texture."] = "번들거림 텍스처의 색상을 설정합니다."
ns.L["Set the color of the highlight texture."] = "강조된 버튼 텍스처의 색상을 설정합니다."
ns.L["Set the color of the normal texture."] = "보통의 버튼 텍스처의 색상을 설정합니다."
ns.L["Set the color of the pushed texture."] = "눌려진 버튼 텍스처의 색상을 설정합니다."
ns.L["Set the intensity of the gloss."] = "번들거림의 농도를 설정합니다."
ns.L["Set the skin."] = "스킨을 설정합니다."
ns.L["Skin"] = "스킨"
ns.L["Special"] = "별도의 유형"
ns.L["State Colors"] = "상태 색상"
ns.L["ToC/Allows the dynamic skinning of button-based add-ons."] = "버튼 기반의 애드온에 동적인 스킨을 씌워줄 수 있도록 합니다."

	elseif LOC == "ruRU" then
ns.L["ADDON_INFO"] = "Эта секция позволяет вам настроить скин для каждого аддона отдельно. Вы также можете настроить скин для отдельных групп, баров и кнопок."
ns.L["AddOns"] = "Настройки аддона"
ns.L["Apply skin to all buttons registered with %s."] = "Применить шкурку ко всем кнопкам, зарегистрированным аддоном %s."
ns.L["Apply skin to all buttons registered with %s: %s."] = "Применить шкурку ко всем кнопкам зарегистрированным с %s: %s."
ns.L["Apply skin to all buttons registered with %s: %s/%s."] = "Применить шкурку ко всем кнопкам зарегистрированным с %s: %s/%s."
ns.L["BF_INFO"] = "ButtonFacade - это небольшой аддон, позволяющий динамически изменять вид различных кнопок."
ns.L["Checked"] = "Проверенный"
ns.L["Disabled"] = "Отключить края"
ns.L["Enable the backdrop."] = "Переключение фона."
ns.L["Equipped"] = "Задействованный"
ns.L["Flash"] = "Сверкание"
ns.L["GLOBAL_INFO"] = "Эта секция позволяет вам настроить скин для всего сразу. Любые изменения повлияют на все зарегистрированные элементы."
ns.L["Global Settings"] = "Общие настройки"
ns.L["Highlight"] = "Выделение"
ns.L["Normal"] = "Нормальные края"
ns.L["Profiles"] = "Профили"
ns.L["Pushed"] = "Вдавленные края"
ns.L["Reset All Colors"] = "Сбросить цвета"
ns.L["Set the intensity of the gloss."] = "Установите силу блеска."
ns.L["Set the skin."] = "Укажите скин."
ns.L["Skin"] = "Шкурки"
ns.L["ToC/Allows the dynamic skinning of button-based add-ons."] = "Позволяет динамически менять оформление аддонов, использующих кнопки."

	elseif LOC == "zhCN" then
ns.L["ADDON_INFO"] = "这里可以调整每个插件的皮肤设置。也可以调整插件可用的设置单独分组，动作条和按钮。注意：这里更改只影响已选择元素和插件自身已保存的。"
ns.L["AddOns"] = "插件"
ns.L["Apply skin to all buttons registered with %s."] = "将皮肤应用到所有注册给%s的按钮上。"
ns.L["Apply skin to all buttons registered with %s: %s."] = "将皮肤应用到所有注册给%s：%s的按钮上。"
ns.L["Apply skin to all buttons registered with %s: %s/%s."] = "将皮肤应用到所有注册给%s：%s/%s的按钮上。"
ns.L["Backdrop Settings"] = "背景设置"
ns.L["BF_INFO"] = "ButtonFacade，和其相关的库，是更改按钮动态皮肤的小型插件。"
ns.L["Checked"] = "已选中"
ns.L["Color"] = "颜色"
ns.L["Disabled"] = "已禁用"
ns.L["Enable"] = "启用"
ns.L["Enable the backdrop."] = "启用背景。"
ns.L["Equipped"] = "已装备"
ns.L["Flash"] = "闪光"
ns.L["GLOBAL_INFO"] = "这里可以调整全局皮肤设置。注意：这里的任何更改将影响所有已注册的元素，ButtonFacade 只保存全局级别的更改。"
ns.L["Global Settings"] = "全局设置"
ns.L["Gloss Settings"] = "光泽设置"
ns.L["Highlight"] = "高亮"
ns.L["Normal"] = "正常"
ns.L["Opacity"] = "不透明度"
ns.L["Profiles"] = "配置文件"
ns.L["Pushed"] = "加粗"
ns.L["Reset All Colors"] = "重置全部颜色"
ns.L["Set the intensity of the gloss."] = "设置光泽深度。"
ns.L["Set the skin."] = "设置皮肤。"
ns.L["Skin"] = "皮肤"
ns.L["State Colors"] = "状态颜色"
ns.L["ToC/Allows the dynamic skinning of button-based add-ons."] = "允许按钮插件使用动态皮肤。"

	elseif LOC == "zhTW" then
ns.L["ADDON_INFO"] = "這裡可以調整每個插件的皮膚設定。也可以調整插件可用的設定單獨分組，動作條和按鈕。注意：這裡更改只影響已選擇元素和插件自身已保存的。"
ns.L["AddOns"] = "插件"
ns.L["Apply skin to all buttons registered with %s."] = "將皮膚套用到所有註冊給%s的按鈕上。"
ns.L["Apply skin to all buttons registered with %s: %s."] = "將皮膚套用到所有註冊給%s：%s的按鈕上。"
ns.L["Apply skin to all buttons registered with %s: %s/%s."] = "將皮膚套用到所有註冊給%s：%s/%s的按鈕上。"
ns.L["Backdrop Settings"] = "背景設定"
ns.L["BF_INFO"] = "ButtonFacade，和其相關的庫，是更改按鈕動態皮膚的小型插件。"
ns.L["Checked"] = "已選中"
ns.L["Color"] = "顏色"
ns.L["Disabled"] = "已禁用"
ns.L["Enable"] = "啟用"
ns.L["Enable the backdrop."] = "啟用背景。"
ns.L["Equipped"] = "已裝備"
ns.L["Flash"] = "閃光"
ns.L["GLOBAL_INFO"] = "這裡可以調整全局皮膚設定。注意：這裡的任何更改將影響所有已註冊的元素，ButtonFacade 只保存全局級別的更改。"
ns.L["Global Settings"] = "全局設定"
ns.L["Gloss Settings"] = "光澤設定"
ns.L["Highlight"] = "高亮"
ns.L["Normal"] = "正常"
ns.L["Opacity"] = "不透明度"
ns.L["Profiles"] = "設定檔"
ns.L["Pushed"] = "加粗邊框"
ns.L["Reset All Colors"] = "重設顏色"
ns.L["Set the intensity of the gloss."] = "設定光澤強度。"
ns.L["Set the skin."] = "設定皮膚。"
ns.L["Skin"] = "皮膚"
ns.L["State Colors"] = "狀態顏色"
ns.L["ToC/Allows the dynamic skinning of button-based add-ons."] = "允許按鈕插件使用動態皮膚。"

	end
end
