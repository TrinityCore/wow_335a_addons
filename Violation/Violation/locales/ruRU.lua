local L = AceLibrary("AceLocale-2.2"):new("Violation")
-- Translated by StingerSoft
L:RegisterTranslations("ruRU", function() return {
	-- Reporting menu
	["Report"] = "Сообщить",
	["Report your current data to a channel."] = "Сообщать в канал о ваших текущих данных",
	["Send %s data."] = "Выслать данные по %s",

	["Whisper"] = "Шепнуть",
	["Whisper the data to someone."] = "Шепнуть о данных кому-нибудь",
	["Player"] = "Игроку",
	["Whisper the data to the specified player."] = "Шепнуть о данных определённому игроку.",
	["<playerName>"] = "<playerName>",
	["Say"] = "Сказать",
	["Print to say."] = "Просто сказать",
	["Guild"] = "Гильдия",
	["Print to the guild channel."] = "Вывести в канал гильдии",
	["Officer"] = "Офицерам",
	["Print to the officer channel."] = "Вывести в канал офицерам",
	["Party"] = "В группу",
	["Print to the party channel."] = "Вывести в канал группы",
	["Raid"] = "В рейд",
	["Print to the raid channel."] = "Вывести в канал рейда",
	["Lines"] = "Строк",
	["Maximum number of lines to print."] = "Максимальное число строк допустимое в выводе данных",
	["Print to channel %q."] = "Вывести в канал %q.",
	["Send reports to %s."] = "Выслать отчет в %s.",

	-- Main option menu
	["Minimap icon"] = "Иконка у мини-карты",
	["Toggle the minimap icon."] = "Вкл/Выкл отображение иконки у мини-карты",
	["Track"] = "Отслеживать",
	["What data types to track."] = "Какие типы данных отслеживать",
	["Toggle whether to track %q."] = "Вкл/Выкл отслеживание %q.",
	["Text"] = "Текст",
	["What data to show on the panel, if available."] = "Какие данные отображать на панели, если доступные.",
	["Tooltip"] = "Подсказка",
	["What data to show in the tooltip."] = "Какие данные отображать в подсказке.",
	["Colors"] = "Окраска",
	["Assign colors to the different data types."] = "Назначения цветов для различных типов данных.",
	["What color to use for the %q data type."] = "Цвет для %q типа данных.",
	["Toggle whether to display data from %q in the tooltip."] = "Вкл/Выкл отображение данных из %q в подсказке.",
	["Toggle whether to display data from %q on the panel."] = "Вкл/Выкл отображение данных из %q на панели.",

	["Reset"] = "Сброс",
	["Options for when to reset the data."] = "Настройки сброса данных.",
	["Reset now"] = "Сбросить сейчас",
	["Immediately resets your data."] = "Мгновенно сбрасывает данные.",
	["Auto-reset"] = "Авто-сброс",
	["Entering combat"] = "Вступая в бой",
	["Automatically reset the data when entering combat."] = "Автоматически сбрасывает данные когда вы вступаете в бой",
	["Leaving combat"] = "Выходя из боя",
	["Automatically reset the data when leaving combat."] = "Автоматически сбрасывает данные когда вы выходите из боя",
	["Print on reset"] = "Вывести и сбросить",
	["Prints your current data locally when your data is reset."] = "Вывести ваши текущие данные для вас лично при сбросе данных",
	
	["Windows"] = "Окна",
	["Window options."] = "настройки окна.",
	["Create new window"] = "Создать новое окно",
	["Creates a new bar window display."] = "Создание нового окна для вывода определённых данных.",
	["Show windows"] = "Показывать окна.",
	["Toggles all windows on or off."] = "Вкл/Выкл отображение всех окон.",
	["Show in group"] = "Показывать в группе",
	["Automatically show windows when you are grouped."] = "Автоматически отображать окно когда вы вступаете/находитесь в группе",
	["Default texture"] = "Стандартная текстура",
	["Set the default bar texture for windows."] = "Установка стандартной текстуры для окна.",
	["Show tooltips"] = "Показывать подсказку",
	["Toggle whether to show detailed information when you hover the window."] = "Вкл/Выкл отображение детальной информации при наведении курсора мыши на окно.",

	["Merge pets"] = "Объединять питомцев",
	["Merge pet data with master."] = "Объединять данные питомцев с их хозяевами.",

	-- Window options
	["Options for window %d. %s."] = "Настройки окна %d. %s.",
	["Show"] = "Показать",
	["Show window."] = "Показать окно.",
	["Lock"] = "Заблокировать",
	["Lock window."] = "Заблокировать окно.",
	["Use module color"] = "Исп. цвет модуля",
	["Use module color for the window header."] = "Использовать цвет модуля для заголовка окна.",
	["Color"] = "Цвет",
	["Use a custom window color for the header."] = "Использовать пользовательский цвет окна для заголовка",
	["Use default texture"] = "Исп. стандартную текстуру",
	["Use the default bar texture."] = "Использовать текстуру полосы заданную по умолчанию.",
	["Texture"] = "Текстура",
	["Set a custom bar texture to use for this window."] = "Установка пользовательской текстуры для использования в данном окне.",
	["Simple bar values"] = "Простые значения полос",
	["Toggles including percentage and rank information in the bar display."] = "Вкл/Выкл отображение информации о уровне и процентах в полосках.",
	["Scale"] = "Масштаб",
	["Set the window scale."] = "Установка масштаба окна.",
	["Reset module"] = "Сбросить модуль",
	["Reset the associated modules data."] = "Сбросить модуль и его данные",
	["Delete"] = "Удалить",
	["Delete this window."] = "Удалить данное окно.",
	
	["Columns"] = "Колонки",
	["Toggle which columns should be visible in this window."] = "Вкл/Выкл отображения колонок в данном окне.",
	["Rank"] = "Уровень",
	["Name"] = "Имя",
	["Value"] = "Значение",
	["Percent"] = "Процент",

	-- Prints and tooltip
	["%s has been disabled, since it is not compatible with the latest module API."] = "%s был отключен, поскольку он не совместим с последними версиями модулей API.",
	["No modules running, please enable one or more from the configuration menu."] = "	Нет запущенных модулей, пожалуйста, включите один или более из конфигурационного меню",
	["|cffeda55fClick|r to toggle the bar display. |cffeda55fShift-Click|r to reset."] = "|cffeda55fКлик|r переключает отображение полос. |cffeda55fShift-Клик|r выполняет сброс.",
	["#"] = "#",
	["Resetting data as requested by %s."] = "Сброс данных в соответствии с просьбой %s",
	["Only the group leader or an officer can do that."] = "Сделать это, может только лидер группы или офицер.",
	["No windows are configured to be shown."] = "Нет окон настроенных для отображения.",
	["Module"] = "Модуль",
} end)
