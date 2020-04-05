-- Русский (Russian)
--------------------
if (GetLocale() == "ruRU") then
FIZ_TXT = {}

-- Binding names
BINDING_HEADER_FACTIONIZER	= "Factionizer"
BINDING_NAME_SHOWCONFIG		= "Show options window"
BINDING_NAME_SHOWDETAILS	= "Отображение детальной информации о репутации"

-- help
FIZ_TXT.help		= "Инструментарий работы с репутацией"
FIZ_TXT.command		= "Could not parse command"
FIZ_TXT.usage		= "Использование"
FIZ_TXT.helphelp	= "Показывает этот текст помощи"
FIZ_TXT.helpabout	= "Показывает информацию об авторе"
FIZ_TXT.helpstatus	= "Показывает текущие настройки"
FIZ_TXT.help_urbin	= "стальные аддоны от Urbin"
FIZ_TXT.helpphase	= "Определение текущей стадии (1=Святилище, 2=Оружейная, 3=Харбор)"
FIZ_TXT.helpsubphase	= "Определение под-стадии (1=Строится, 2=Построено)"
-- about
FIZ_TXT.by		= "by"
FIZ_TXT.version		= "Версия"
FIZ_TXT.date		= "Date"
FIZ_TXT.web		= "Website"
FIZ_TXT.slash		= "Slash command"
FIZ_TXT.urbin		= "Другие оддоны от Urbin'а"
-- status
FIZ_TXT.status		= "Статус"
FIZ_TXT.disabled	= "выключено"
FIZ_TXT.enabled		= "включено"
FIZ_TXT.statMobs	= "Показывать мобов [М]"
FIZ_TXT.statQuests	= "Показывать квесты [К]"
FIZ_TXT.statInstances	= "Показывать инсты [Д]"
FIZ_TXT.statItems	= "Показывать вещи [В]"
FIZ_TXT.statMissing	= "Показывать недостающую репутацию"
FIZ_TXT.statDetails	= "Показывать окно расширенной информации"
FIZ_TXT.statChat	= "Детальное сообщение чата"
FIZ_TXT.statSuppress	= "Гасить оригинальное сообщение в чате"
FIZ_TXT.statPreview	= "Отображать предпросмотр в окне репутации"
-- XML UI elements
FIZ_TXT.showQuests	= "Квесты"
FIZ_TXT.showInstances	= "Подземелья"
FIZ_TXT.showMobs	= "Мобы"
FIZ_TXT.showItems	= "Вещи"
FIZ_TXT.showAll		= "Показать все"
FIZ_TXT.showNone	= "Скрыть все"
FIZ_TXT.expand		= "Развернуть"
FIZ_TXT.collapse	= "Свернуть"
FIZ_TXT.supressNoneFaction	= "Убрать исключения фракции"
FIZ_TXT.supressNoneGlobal	= "Убрать все исключения"
FIZ_TXT.suppressHint	= "Кликните правой кнопкой, чтобы исключить квест из списка"
-- options dialog
FIZ_TXT.showMissing	= "Показывать недостающую репутацию во фрейме репутации"
FIZ_TXT.extendDetails	= "Показывать окно детальной информации о репутации"
FIZ_TXT.gainToChat	= "Писать детальное сообщение повышения репутации в чат"
FIZ_TXT.suppressOriginalGain = "Заменять стандартное сообщение повышения репутации"
FIZ_TXT.showPreviewRep	= "Показывать репутацию, которая может быть получена в окне репутации"
FIZ_TXT.defaultChatFrame	= "Использовать окно чата по умолчанию"
FIZ_TXT.chatFrame		= "Использовать окно чата: %d (%s)"
FIZ_TXT.usingDefaultChatFrame	= "Используется окно чата по умолчанию"
FIZ_TXT.usingChatFrame		= "Используется окно чата"
-- various LUA
FIZ_TXT.options		= "Опции"
FIZ_TXT.orderByStanding = "Сортировать по репе"
FIZ_TXT.lookup		= "Looking up faction "
FIZ_TXT.lookup2		= ""
FIZ_TXT.allFactions	= "Listing all factions"
FIZ_TXT.missing		= "(до повышения)"
FIZ_TXT.missing2	= "Не хватает"
FIZ_TXT.heroic		= "Героик"
FIZ_TXT.normal		= "Нормал"
-- FIZ_ShowFactions
FIZ_TXT.faction		= "Фракция"
FIZ_TXT.is		= "is"
FIZ_TXT.withStanding	= "with standing"
FIZ_TXT.needed		= "needed"
FIZ_TXT.mob		= "[Моб]"
FIZ_TXT.limited		= "is limited to"
FIZ_TXT.limitedPl	= "are limited to"
FIZ_TXT.quest		= "[Квест]"
FIZ_TXT.instance	= "[Данж]"
FIZ_TXT.items		= "[Вещь]"
FIZ_TXT.unknown		= "is not known to this player"
-- ReputationDetails
FIZ_TXT.currentRep	= "Текущая репутация"
FIZ_TXT.neededRep	= "Необходимо набрать"
FIZ_TXT.missingRep	= "Недостающая репутация"
FIZ_TXT.repInBag	= "Репутация в сумках"
FIZ_TXT.repInBagBank	= "Репутация в сумках и банке"
FIZ_TXT.repInQuest	= "Репутация в квестах"
FIZ_TXT.factionGained	= "Увеличено за сессию"
FIZ_TXT.noInfo		= "Информация по этой фракции/репутации не найдена."
FIZ_TXT.toExalted	= "Нужно до превозношения"
-- to chat
FIZ_TXT.stats		= " (Всего: %s%d, Осталось: %d)"
-- UpdateList
FIZ_TXT.mobShort	= "[М]"
FIZ_TXT.questShort	= "[К]"
FIZ_TXT.instanceShort	= "[Д]"
FIZ_TXT.itemsShort	= "[В]"
FIZ_TXT.mobHead		= "Рост репутации за убийство этого моба"
FIZ_TXT.questHead	= "Рост репутации за выполнение этого квеста"
FIZ_TXT.instanceHead	= "Рост репутации за прохождение подземелья"
FIZ_TXT.itemsHead	= "Рост репутации за нахождение вещи"
FIZ_TXT.mobTip		= "Каждый раз убивая этого моба, вы увеличиваете репутацию. Продолжая в том же духе, вы достигните следующего уровня."
FIZ_TXT.questTip	= "Каждый раз выполняя этот повторяемый квест, вы увеличиваете репутацию. Продолжая в том же духе, вы достигните следующего уровня."
FIZ_TXT.instanceTip	= "Каждый раз проходя подземелье, вы увеличиваете репутацию. Продолжая в том же духе, вы достигните следующего уровня."
FIZ_TXT.itemsName	= "Вещей на руках"
FIZ_TXT.itemsTip	= "Каждый раз сдавая перечисленные вещи, вы увеличиваете репутацию. Продолжая в том же духе, вы достигните следующего уровня."
FIZ_TXT.allOfTheAbove	= "Всего %d за квесты выше"
FIZ_TXT.questSummaryHead = FIZ_TXT.allOfTheAbove
FIZ_TXT.questSummaryTip	= "Эта запись показывает, резюме все квесты, перечисленных выше.\r\nЭто полезно, когда все квесты ежедневные и можно посчитать сколько дней необходимо до получения нужного уровня репутации."
FIZ_TXT.complete	= "завершен"
FIZ_TXT.active		= "Активен"
FIZ_TXT.inBag		= "В сумках"
FIZ_TXT.turnIns		= "Сдать:"
FIZ_TXT.reputation	= "Репутация:"
FIZ_TXT.inBagBank	= "В сумках и банке"
FIZ_TXT.questCompleted	= "Квест выполнен"
FIZ_TXT.timesToDo	= "Сделать раз:"
FIZ_TXT.instance2	= "Подземелье:"
FIZ_TXT.mode		= "Режим:"
FIZ_TXT.timesToRun	= "Сделать ранов:"
FIZ_TXT.mob2		= "Моб:"
FIZ_TXT.location	= "Локация:"
FIZ_TXT.toDo		= "Сделать:"
FIZ_TXT.quest2		= "Квест:"
FIZ_TXT.itemsRequired	= "Вещей необходимо"
FIZ_TXT.maxStanding	= "Повторять до достижения"
-- SSO phases
FIZ_TXT.sso_warning	= "Вы еще не определили на какой стадии находится Армия Расколотого Солнца. На большинстве серверов все стадии пройдены, чтобы быстро указать это - введите в чате '/fz sso all'"
FIZ_TXT.sso_status	= "Статус Армии Расколотого Солнца"
FIZ_TXT.sso_unknown	= "Не известно"
FIZ_TXT.sso_main	= "Основная стадия"
FIZ_TXT.sso_phase2b	= "Стадия 2B"
FIZ_TXT.sso_phase3b	= "Стадия 3B"
FIZ_TXT.sso_phase4b	= "Стадия 4B"
FIZ_TXT.sso_phase4c	= "Стадия 4C"
FIZ_TXT.phase1		= "Стадия 1: имеется Святилище"
FIZ_TXT.phase2		= "Стадия 2: имеется Оружейная"
FIZ_TXT.phase3		= "Стадия 3: имеется Харбор"
FIZ_TXT.phase4		= "Стадия 4: Последний удар"
FIZ_TXT.phase2bWaiting	= "Ожидается, что Святилище будет построено"
FIZ_TXT.phase2bActive	= "Строится портал"
FIZ_TXT.phase2bDone	= "Портал построен"
FIZ_TXT.phase3bWaiting	= "Ожидается, что Оружейная будет построена"
FIZ_TXT.phase3bActive	= "Строится Кузня и Горн"
FIZ_TXT.phase3bDone	= "Горн и Кузня построены"
FIZ_TXT.phase4Waiting	= "жидается, что Харбор будет построен"
FIZ_TXT.phase4bActive	= "Строится Монумент павших"
FIZ_TXT.phase4bDone	= "Монумент павших построен"
FIZ_TXT.phase4cActive	= "Строится лаборатория"
FIZ_TXT.phase4cDone	= "Лаборатория построена"
-- skills
FIZ_TXT.skillHerb	= "Травничество"
FIZ_TXT.skillSkin	= "Снятие шкур"
FIZ_TXT.skillMine	= "Горное дело"
FIZ_TXT.skillFish	= "Рыбная ловля"
FIZ_TXT.skillCook	= "Кулинария"
FIZ_TXT.skillAid	= "Первая помощь"
FIZ_TXT.skillAlch	= "Алхимия"
FIZ_TXT.skillSmith	= "Кузнечное дело"
FIZ_TXT.skillEnch	= "Наложение чар"
FIZ_TXT.skillEngi	= "Инженерное дело"
FIZ_TXT.skillJewel	= "Ювелирное дело"
FIZ_TXT.skillLw	= "Кожевничество"
FIZ_TXT.skillTail	= "Портняжное дело"

-- Tooltip
FIZ_TXT.elements = {}
FIZ_TXT.elements.name = {}
FIZ_TXT.elements.tip = {}

FIZ_TXT.elements.name.FIZ_ShowMobsButton	= FIZ_TXT.showMobs
FIZ_TXT.elements.tip.FIZ_ShowMobsButton		= "Нажмите кнопку, чтобы видеть мобов, за убийство которых растет репутация."
FIZ_TXT.elements.name.FIZ_ShowQuestButton	= FIZ_TXT.showQuests
FIZ_TXT.elements.tip.FIZ_ShowQuestButton	= "Нажмите кнопку, чтобы видеть квесты, за выполнение которых растет репутация."
FIZ_TXT.elements.name.FIZ_ShowItemsButton	= FIZ_TXT.showItems
FIZ_TXT.elements.tip.FIZ_ShowItemsButton	= "Нажмите кнопку, чтобы видеть вещи, за сдачу которых растет репутация."
FIZ_TXT.elements.name.FIZ_ShowInstancesButton	= FIZ_TXT.showInstances
FIZ_TXT.elements.tip.FIZ_ShowInstancesButton	= "Нажмите кнопку, чтобы видеть подземелья, за зачистку которых растет репутация."

FIZ_TXT.elements.name.FIZ_ShowAllButton		= FIZ_TXT.showAll
FIZ_TXT.elements.tip.FIZ_ShowAllButton		= "Нажмите эту кнопку чтобы выбрать все 4 элемента.\r\nБудут показаны мобы, квесты, вещи и подземелья для выбранной фракции."
FIZ_TXT.elements.name.FIZ_ShowNoneButton	= FIZ_TXT.showNone
FIZ_TXT.elements.tip.FIZ_ShowNoneButton		= "Нажмите эту кнопку чтобы снять выделение с 4 элементов.\r\nВ результате ничего не будет показано. Неожиданно, да? ;-)."

FIZ_TXT.elements.name.FIZ_ExpandButton		= FIZ_TXT.expand
FIZ_TXT.elements.tip.FIZ_ExpandButton		= "Нажмите тут, чтобы развернуть все квесты. Будут показаны необходимые для квеста вещи."
FIZ_TXT.elements.name.FIZ_CollapseButton	= FIZ_TXT.collapse
FIZ_TXT.elements.tip.FIZ_CollapseButton		= "Нажмите тут, чтобы свернуть все квесты. Угадайте что произойдет. :-)"

FIZ_TXT.elements.name.FIZ_EnableMissingBox		= FIZ_TXT.showMissing
FIZ_TXT.elements.tip.FIZ_EnableMissingBox		= "Включение этого параметра позволит смотреть недостающую репутацию в окне репутации"
FIZ_TXT.elements.name.FIZ_ExtendDetailsBox		= FIZ_TXT.extendDetails
FIZ_TXT.elements.tip.FIZ_ExtendDetailsBox		= "Включение этого параметра позволит смотреть детальную информацию по выбранной фракции.\r\nВ окне будут показаны рекомендуемые квесты, мобы, шмотки и прочая полезная информация"
FIZ_TXT.elements.name.FIZ_GainToChatBox			= FIZ_TXT.gainToChat
FIZ_TXT.elements.tip.FIZ_GainToChatBox			= "Включение этого параметра будет показывать полный список фракций с которыми повысилась репутация.\r\nЭто отличается от стандартного уведомления тем, что будет показана не только основная фракция."
FIZ_TXT.elements.name.FIZ_SupressOriginalGainBox	= FIZ_TXT.suppressOriginalGain
FIZ_TXT.elements.tip.FIZ_SupressOriginalGainBox		= "Включение этого параметра позволит не отображать стандартные сообщени о росте репутации.\r\nИмеет смысл включать, если включен предыдущий пункт."
FIZ_TXT.elements.name.FIZ_ShowPreviewRepBox		= FIZ_TXT.showPreviewRep
FIZ_TXT.elements.tip.FIZ_ShowPreviewRepBox		= "Включите этот параметр, чтобы показать репутацию которую можно получить путем сдачи пунктов и завершия квестов в окне репутации."
end
