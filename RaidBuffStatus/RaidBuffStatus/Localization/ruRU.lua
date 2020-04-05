﻿local L = LibStub("AceLocale-3.0"):NewLocale("RaidBuffStatus", "ruRU")
if not L then return end

-- To help with missing translations please go here:
-- http://www.wowace.com/addons/raidbuffstatus/localization/


--BuffOptionsWindow - The window opened from the top right button on the main dashboard which configures which buffs to show on the dashboard.
L["Buff Options"] = "Опции баффов"
L["Is a buff"] = "Бафф"
L["Is a warning"] = "Предупреждение"
L["Report on Boss"] = "Отчет на Боссе"
L["Report on Trash"] = "Отчет на Монстрах"
L["Show on dashboard"] = "Показывать на табло"
L["Show/Report in combat"] = "Отчет в бою"




--CrowdControlWarnings - The messages about crowd control breakage.
L["Non-tank %s broke %s on %s%s%s"] = "Не-танк %s снимает %s с %s|3-1(%s)%s" -- Needs review
L["Non-tank %s broke %s on %s%s%s with %s"] = "%6$s не-танка |3-1(%1$s) снимает %2$s с %3$s|3-1(%4$s)%5$s" -- Needs review
L["%s broke %s on %s%s%s"] = "%s снимает %s с %s|3-1(%s)%s" -- Needs review
L["%s broke %s on %s%s%s with %s"] = "%6$s |3-1(%1$s) снимает %2$s с %3$s|3-1(%4$s)%5$s" -- Needs review




--Messages -- General messages in whisper, tooltips, raid report, main dashboard buttons, etc.
L["AFK"] = "AFK"
L["Agil"] = "Лов"
L["alpha"] = "alpha"
L["Alt-Click on a party buff will cast on someone missing that buff."] = "Alt-Клик по групповому баффу, чтобы применить его на игрока, на котором отсутствует этот бафф."
L["Alt-Click on a self buff will renew that buff."] = "Alt-Клик по self-баффу, чтобы обновить его."
L["Aspect Cheetah/Pack On"] = "Дух гепарда/стаи"
L["Aspect of the Cheetah or Pack is on"] = "Дух гепарда или Дух стаи"
L["Battle Elixir"] = "Боевой эликсир"
L["beta"] = "beta"
L["Black Temple"] = "Черный храм"
-- L["Blessing of Kings, with this raid configuration, is better at least partly provided by Drums of the Forgotten Kings thus allowing other blessings to be used."] = ""
-- L["Blessing of Wisdom will be overwritten by Shaman totems as points spent in Restorative Totems is greater than Improved Blessing of Wisdom."] = ""
L["BoK"] = "BoK"
L["BoM"] = "BoM"
L["BoS"] = "BoS"
L["Boss"] = "Босс"
L["BoW"] = "BoW"
L["Buffers: "] = "Бафферы: "
L["Cast by:"] = "Применил(а):"
-- L["Check Pally Power for: "] = ""
L["Click buffs to disable and enable."] = "Клик по баффу для включения/выключения."
L["Click to toggle the RBS dashboard"] = "Кликните левой кнопкой для отображения табло RBS"
L["Ctrl-Click Boss or Trash to whisper all those who need to buff."] = "Ctrl+щелчок мышью, чтобы прошептать всем, кто должен баффнуть" -- Needs review
L["Ctrl-Click buffs to whisper those who need to buff."] = "Ctrl-Клик по баффу, чтобы шепнуть игрокам, нуждающихся в баффе."
L["Dead"] = "Мертв"
L["Death Knight Aura"] = "Аура рыцаря смерти"
L["Death Knight is missing an Aura"] = "На рыцаре смерти отсутствует аура"
L["Death Knight Presence"] = "Власть Рыцаря смерти"
L["Different Zone"] = "Другая локация"
L["(Earthliving)"] = "(Жизнь Земли)"
L["expecting"] = "ожидание"
L["(Firestone)"] = "(Камень огня)"
L["Fish Feast about to expire!"] = "Рыбный пир скоро пропадет!"
L["(Flametongue)"] = "(Язык пламени)"
L["Flasked or Elixired but slacking"] = "Игрок использует настой или эликсир из TBC" -- Needs review
L["Flask or two Elixirs"] = "Настой или два эликсира"
L["(Frostbrand)"] = "(Ледяное клеймо)"
L["Got"] = "Получил"
L["Gruul's Lair"] = "Логово Груула"
L["Guardian Elixir"] = "Охранный эликсир"
L["Has buff: "] = "Имеет бафф: "
L[" has set us up a Refreshment Table"] = " ставит Стол с Яствами"
L[" has set us up a Repair Bot"] = "  создал ремонтного робота"
L[" has set us up a Soul Well"] = " создает источник душ" -- Needs review
L["Healer %s has died!"] = "Лекарь %s умирает!"
L["Health less than 80%"] = "Здоровье меньше, чем 80%"
L["Hunter Aspect"] = "Духи охотника"
L["Hunter has no aspect at all"] = "У охотника нет духа"
L["Hyjal Summit"] = "Вершина Хиджала"
L["[IMMUNE]"] = "[Невосприимчивость]"
L["Int"] = "Инт"
L["Item count: "] = "Предметов:"
L["Low durability"] = "Низкая прочность"
L["Low durability (35% or less)"] = "Низкая прочность (35% или ниже)"
L["Mage is missing a Mage Armor"] = "На маге отсутствует Магический доспех"
L["Mana less than 80%"] = "Мана меньше, чем 80%"
L["MANY!"] = "МНОГИЕ!"
L["Melee DPS %s has died!"] = "Боец ближнего боя %s умирает!" -- Needs review
L["Missing "] = "Отсутствует "
L["Missing a Battle Elixir"] = "Отстутствует боевой эликсир"
L["Missing a Flask or two Elixirs"] = "Отсутствует настой или два эликсира"
L["Missing a Guardian Elixir"] = "Отсутствует охранный эликсир"
L["Missing a scroll"] = "Отсутствует свиток"
L["Missing a temporary weapon buff"] = "Отсутствует временный бафф оружия"
L["Missing buff: "] = "Отстутствует бафф: "
L["Missing buffs (Boss): "] = "Отсутствующие баффы (Босс): "
L["Missing buffs (Trash): "] = "Отсутствующие баффы(Треш): "
L["Missing or not working oRA: "] = "Не работает/отсутствует аддон oRA2: " -- Needs review
L["Missing Vigilance"] = "Отсутствует Бдительность"
L["No"] = "Нет"
L["No buffs needed! (Boss)"] = "Все бафы на месте! (Босс)"
L["No buffs needed! (Trash)"] = "Все бафы на месте! (Треш)"
L["No Soulstone detected"] = "Камни душ отсутствуют"
L["Not Well Fed"] = "Нет баффа от еды"
L["Offline"] = "Вышел из сети"
L["Out of range"] = "Вне зоны действия"
L["Paladin Aura"] = "Аура паладина"
L["Paladin blessing"] = "Паладинское благословение"
L["Paladin Different Aura - Group"] = "Paladin Different Aura - Group"
L["Paladin has Crusader Aura"] = "У паладина активна Аура воина Света"
L["Paladin has no Aura at all"] = "У паладина нет ауры"
L["Paladin has Shadow Resistance Aura AND Shadow Protection"] = "На паладине активна Аура сопротивления темной магии И Защита от темной магии"
L["Paladin missing Seal"] = "Недостающие печати паладина света" -- Needs review
-- L["Paladin %s has left the raid and had Pally Power blessings assigned to them"] = ""
L["Paladins missing Pally Power: "] = "Паладины без Pally Power:"
L["Pally Power missing: "] = "Отсутствует PallyPower: "
L["Player has a wrong Paladin blessing"] = "На игрока наложено неверное благословение"
L["Player has health less than 80%"] = "Количетво здоровья игрока меньше, чем 80%"
L["Player has mana less than 80%"] = "Количество маны игрока меньше, чем 80%"
L["Player is AFK"] = "Игрок отсутствует"
L["Player is Dead"] = "Игрок мертв"
L["Player is in a different zone"] = "Игрок находится в другой локации"
L["Player is missing at least one Paladin blessing"] = "На игроке отсутствует по крайней мере одно благословение паладина"
L["Player is Offline"] = "Игрок вышел из сети"
L["Please relog or reload UI to update the item cache."] = "Пожайлуста переавторизуйтесь или перезагрузите UI, чтобы обновить кеш предметов" -- Needs review
L["( Poison ?[IVX]*)"] = "( Яд ?[IVX]*)"
L["prepares a Fish Feast!"] = "готовит рыбный пир!"
L["Press Escape -> Interface -> AddOns -> RaidBuffStatus for more options."] = "Нажмите Escape -> Interface -> AddOns -> RaidBuffStatus для просмотра опций."
L["Prot"] = "Защ"
L["Protection Paladin with no Righteous Fury"] = "Protection-паладин без Праведного неистовства"
L["PVP is On"] = "PVP включено"
L["PVP On"] = "PVP on"
L["R"] = "Г"
L["Ranged DPS %s has died!"] = "Боец дальнего боя %s умирает!" -- Needs review
L["RBS Dashboard Help"] = "Помощь для табло RBS"
L["RBS Tank List"] = "Список танков RBS"
L["Refreshment Table about to expire!"] = "Стол с яствами скоро пропадет!"
L["Remind me later"] = "Напомнить позже"
L["(Remove buff)"] = "(Удалить бафф)"
L["Remove this button from this dashboard in the buff options window."] = "Удалите с табло эту кнопку в опциях окна."
L["Repair Bot about to expire!"] = "Ремонтный робот скоро пропадет!"
L["[RESIST]"] = "[Сопротивление]"
L["Right-click to open the addons options menu"] = "Кликните правой кнопкой для открытия меню опций аддона"
L["(Rockbiter)"] = "(Камнедробитель)"
-- L["Sanctuary is assigned in Pally Power but no one has the spec to do it."] = ""
L["Scan"] = "Сканирование"
L["%s cast %s on %s"] = "%s применяет %s на |3-3(%s)"
L["Scroll"] = "Свиток"
L["Seal"] = "Печать"
L["Serpentshrine Cavern"] = "Змеиное святилище"
L["Shadow Resistance Aura AND Shadow Protection"] = "Аура сопротивления темной магии И Защита от темной магии"
L["%s has a newer (%s) version of RBS (%s) than you (%s)"] = "%s имеет более новую (%s) версию RBS (%s) чем у вас (%s)"
L["Shift-Click buffs to report on only that buff."] = "Shift-Клик по баффу для отчета по данному баффу."
-- L["%s is setting Pally Power for %s but they are not in the raid/party"] = ""
L["Slackers: "] = "Слакеры: "
L["Slacking Paladins"] = "Слакающие паладины"
L["Someone has a Soulstone or not"] = "Есть ли у кого-нибудь Камни душ"
L["Soul Well about to expire!"] = "Источник душ скоро исчезнет!" -- Needs review
L["(Spellstone)"] = "(Камень чар)"
L["Spi"] = "Дух"
L["Sta"] = "Внс"
L["Stamina increased by 40"] = "Выносливость увеличена на 40"
L["Str"] = "Сила"
L["Sunwell Plateau"] = "Плато Солнечного Колодца"
L["Tank missing Earth Shield"] = "На танке отсутствует Щит земли"
L["Tank missing Thorns"] = "На танке отсутствуют Корни"
L["Tank %s has died!"] = "Танк %s умирает!"
L["Tank with "] = "Танк с "
L["Tempest Keep"] = "Крепость Бурь"
L["The above default button actions can be reconfigured."] = "Указанные выше стандартные действия кнопок могут быть переконфигурированы."
-- L["The following have inappropriate Paladin blessings: "] = ""
L["There are more Paladins than different Auras in group"] = "Паладинов в группе больше, чем различных аур"
-- L["This is the first time RaidBuffStatus has been activated since installation or settings were reset. Would you like to visit the Buff Wizard to help you get RBS buffs configured? If you are a raid leader then you can click No as the defaults are already set up for you."] = ""
L["Trash"] = "Треш"
L["(Ward of Shielding)"] = "(оберег)"
L["Warning: "] = "Предупреждения: "
L["Warnings: "] = "Предупреждения: "
L["Weapon buff"] = "Бафф оружия"
L["Well Fed but slacking"] = "Сыт но слакает"
L["(Windfury)"] = "(Неистовство ветра)"
-- L["Wintergrasp"] = ""
L["Wrong flask for this zone"] = "Неверный настой для этой локации"
L["Wrong Paladin blessing"] = "Неверное благословение"
L["You need to be leader or assistant to do this"] = "Вы должны быть лидером или ассистентом, чтобы сделать это"




--Options - Command line and standard Blizzard addon interface options.
L["Alive"] = "Живые"
L["Allow raiders to use level 70 TBC flasks and elixirs"] = "Позволить рейдерам использовать настои и эликсиры 70-ого уровня из TBC"
L["Allow raiders to use level 70 TBC flasks and elixirs that are just as good as WotLK flasks and elixirs"] = "Позволить рейдерам использовать эликсиры и настои 70-ого уровня из TBC, схожие по качеству с эликсирами и настоями WotLK"
L["Alt-left click"] = "Alt+клик левой кнопкой"
L["Alt-right click"] = "Alt+клик правой кнопкой"
-- L["Always hide the Boss R Trash buttons"] = ""
L["Announce to raid warning when a Fish Feast is prepared"] = "Извещать рейд о приготовлении Рыбного пира."
L["Announce to raid warning when a Refreshment Table is prepared"] = "Извещать рейд о приготовлении Стола с яствами."
L["Announce to raid warning when a Repair Bot is prepared"] = "Сообщить в объявление рейду когда поставлен ремонтный робот" -- Needs review
L["Announce to raid warning when a Soul Well is prepared"] = "Объявлять рейду о создании источника душ" -- Needs review
-- L["Anti spam"] = ""
L["Appearance"] = "Внешний вид"
L["Automatically configures the dashboard buffs and configuration defaults for your class or raid leading role"] = "Автоматически настраивает табло баффов и настраивает стандарты для вашего класса или роли лидера"
L["Automatically show the dashboard when you join a battleground"] = "Автоматически показывать табло при попадании на поле боя"
L["Automatically show the dashboard when you join a party"] = "Автоматически показывать табло при вступлении в группу"
L["Automatically show the dashboard when you join a raid"] = "Автоматически показывать табло при вступлении в рейд"
L["Automatically whisper anyone missing a Healthstone when your Soul Well expire warnings appear"] = "Автоматически шептать игрокам, не имеющим камней здоровья, при появлении предупреждения о скором исчезании источника душ"
-- L["Automatically whisper anyone missing Well Fed when your Fish Feast expire warnings appear"] = ""
L["Background colour"] = "Цвет фона"
L["Border colour"] = "Цвет краев"
L["Bosses only"] = "Bosses only"
L["Buff those missing buff"] = "Баффнуть"
L["Buff Wizard"] = "Мастер баффов" -- Needs review
L["CC-break warnings"] = "Предупреждения о сбитии контроля"
L["Combat"] = "Бой"
L["Combat options"] = "Опции боя"
L["Consumable options"] = "Опции расходуемых предметов"
-- L["Core raid buffs"] = ""
L["Ctrl-left click"] = "Ctrl+клик левой кнопкой"
L["Ctrl-right click"] = "Ctrl+правый клик"
-- L["Danielbarron broke Sheep on The Lich King with Hand of Reckoning"] = ""
L["Darinia ninjaed my target (The Lich King) with Taunt"] = "Darinia ninjaed my target (Lich King) with Taunt" -- Needs review
L["Darinia taunted my mob (The Lich King) with Taunt"] = "Darinia taunted my mob (Lich King) with Taunt" -- Needs review
L["Darinia taunted my target (The Lich King) with Taunt"] = "Darinia спровоцировала мою цель (Lich King) Провокацией" -- Needs review
L["Dashboard columns"] = "Колонки табло"
L["Dashboard mouse button actions options"] = "Опции действий кнопок мыши для табло"
L["Death warnings"] = "Сообщения о смертях"
L["Disable scan in combat"] = "Отключить сканирование в бою"
L["DPS mana"] = "Мана DPS"
-- L["Dumb assignment"] = ""
L["Enable/disable buff check"] = "Вкл/Откл проверку баффа"
L["Enable tank warnings including taunts, failed taunts and mob stealing"] = "Включить сообщения о провокациях, неудачных провокациях и краже мобов"
L["Enable tank warnings including taunts, failed taunts and mob stealing only on bosses"] = "Включить оповещения танка включая провокации, неудачные провокации и похищение существа, только на боссах"
L["Enable warning messages when players die"] = "Включить оповещение смерти игроков"
L["Enable warnings when Crowd Control is broken by tanks and non-tanks"] = "Включить предупреждения о сбитии контроля танками и не-танками" -- Needs review
L["Enable warnings when Misdirection or Tricks of the Trade is cast"] = "Включить оповещение о применении перенаправления или маленьких хитростей"
-- L["Feast auto whisper"] = ""
L["Fish Feast"] = "Рыбный пир"
L["Food announce"] = "Извещение о еде" -- Needs review
L["Food raid warning announcement options for things like Fish Feasts"] = "Извещение рейда в канал объявлений о еде такой как Рыбный пир."
L["Good food only"] = "Только хорошая еда" -- Needs review
L["Good TBC"] = "Хорошие настои/эликсиры из TBC"
L["Healer death"] = "Смерть лекаря" -- Needs review
L["Healer mana"] = "Мана хилеров"
L["Healers alive"] = "Живые хилеры"
L["Healer Stormsnow has died!"] = "Лекарь Stormsnow умирает!" -- Needs review
L["Hide and show the buff report dashboard."] = "Показать/скрыть табло отчета по баффам"
-- L["Hide Boss R Trash"] = ""
L["Hide dashboard during combat"] = "Скрыть табло во время боя"
L["Hide in combat"] = "Скрыть в бою"
L["Hide the buff report dashboard."] = "Скрыть табло отчета по баффам."
L["Highlight my buffs"] = "Подсвечивать мои баффы"
L["Hightlight currently missing buffs on the dashboard for which you are responsible including self buffs and buffs which you are missing that are provided by someone else. I.e. show buffs for which you must take action"] = "Подсвечивать на табло баффы, за которые вы отвечаете, включая self-баффы, т.е. баффы, требующие действия от вас"
L["How MANY?"] = "Насколько МНОГО?"
L["If a Paladin is missing Pally Power then fall back to not using Pally Power"] = "Если Pally Power отсутствует у паладина, тогда отменить использование Pally Power. "
L["If Pally Power is detected then use that for working out who has not buffed, i.e. which Paladins are slacking"] = "Если обнаружен Pally Power в использовании, а кто-то осталься без баффа, то значит паладины слакают."
L["Ignore groups 6 to 8"] = "Игнорировать группы с 6 по 8"
L["Ignore groups 6 to 8 when reporting as these are for subs"] = "Игнорировать группы с 6 по 8 при отчете"
L["[IMMUNE] Danielbarron FAILED TO TAUNT their target (The Lich King) with Hand of Reckoning"] = "Danielbarron FAILED TO TAUNT his target (Lich King) with Hand of Reckoning" -- Needs review
L["In range"] = "В зоне действия"
-- L["Just check buffs as Pally Power has assigned them and don't complain when something is sub-optimal"] = ""
L["Just my buffs"] = "Только мои баффы" -- Needs review
L["Left click"] = "Клик левой кнопкой"
L["Melee DPS Danielbarron has died!"] = "Боец ближнего боя Danielbarron умирает!" -- Needs review
L["Melee DPS death"] = "Смерть бойца ближнего боя" -- Needs review
L["Minimap icon"] = "Иконка у мини-карты"
L["Misdirection warnings"] = "Оповещать о перенаправлении"
L["Mouse buttons"] = "Кнопки мыши" -- Needs review
L["Move with Alt-click"] = "Перемещение Alt-кликом"
L["Ninja taunts"] = "Ninja taunts"
L["None"] = "Не назначено"
L["Non-tank breaks CC"] = "Не-танк сбивает контроль"
-- L["Non-tank Glamor broke Hex on The Lich King with Moonfire"] = ""
L["NON-TANK Tanagra taunted my target (The Lich King) with Growl"] = "NON-TANK Tanagra taunted my target (Lich King) with Growl" -- Needs review
L["Non-tank taunts my target"] = "Провокации моей цели не-танками"
L["Number of columns to display on the dashboard"] = "Количество колонок, отображаемых на табло"
L["Only allow food that is 40 Stamina and other stats.  I.e. only allow the top quality food with highest stats"] = "Позволять только еду, прибавляющую 40 к выносливости и какой-либо другой характеристике, т.е. только еду наилучшего качества с наивысшими характеристиками"
L["Only if all have it"] = "Только если это есть у всех"
L["Only me"] = "Только я"
-- L["Only show the buffs for which your class is responsible for.  This configuration can be used like a buff-bot where one simply right clicks on the buffs to cast them"] = ""
-- L["Only show the core class raid buffs"] = ""
-- L["Only show when you and only you break Crowd Control so you can say 'Now I don't believe you wanted to do that did you, ehee?'"] = ""
L["Only use tank list"] = "Использовать только список танков"
-- L["Only use the tank list and ignore spec when there is a tank list for determining if someone is a tank or not"] = ""
L["Options for setting the quality requirements of consumables"] = "Опции для установки требуемого качества расходуемых предметов"
L["Options for the integration of Pally Power"] = "Опции интеграции с Pally Power"
-- L["Options to do with configuring the tank list"] = ""
L["Other taunt fails"] = "Неудачные провокации другими людьми"
L["Pally Power"] = "Pally Power"
L["Play a sound"] = "Проиграть звук"
L["Play a sound when a healer dies"] = "Проигрывать звук при смерти лекаря" -- Needs review
L["Play a sound when a melee DPS dies"] = "Проигрывать звук при смерти бойца ближнего боя" -- Needs review
L["Play a sound when a non-tank breaks Crowd Control"] = "Проигрывать звуковой сигнал, когда не-танк сбивает контроль"
L["Play a sound when a ranged DPS dies"] = "Проигрывать звук при смерти бойца дальнего боя" -- Needs review
L["Play a sound when a tank breaks Crowd Control"] = "Проигрывать звуковой сигнал, когда танк сбивает контроль"
L["Play a sound when a tank dies"] = "Проигрывать звук при смерти танка" -- Needs review
L["Play a sound when Misdirection or Tricks of the Trade is cast"] = "Проиграть звук когда применяется перенаправление или маленькие хитрости"
-- L["Play a sound when one of your taunts fails due to resist"] = ""
L["Play a sound when one of your taunts fails due to the target being immune"] = "Проигрывать звук при неудаче ваших провокаций" -- Needs review
L["Play a sound when other people's taunts to your target fail"] = "Проигрывать звук при неудачных провокациях вашей цели другими людьми"
L["Play a sound when someone else targets a mob and taunts that mob which is targeting you"] = "Проигрывать звук при провокации другими игроками моба, целью которого являетесь вы"
L["Play a sound when someone else taunts your target"] = "Проигрывать звук при провокации вашей цели кем-либо"
L["Play a sound when someone else taunts your target which is targeting you"] = "Прогирывать звук при провокации другими игроками вашей цели, целью которой являетесь вы"
L["Play a sound when someone else who is not a tank taunts your target"] = "Проигрывать звук при провокации вашей цели кем-либо, не являющимся танком"
L["Raid health"] = "Здоровье рейда"
L["Raid leader"] = "Лидер рейда"
L["Raid mana"] = "Мана рейда"
L["Raid Status Bars"] = "Полосы статуса рейда"
L["Ranged DPS death"] = "Смерть бойца дальнего боя" -- Needs review
-- L["Ranged DPS Garmann has died!"] = ""
L["Refreshment Table"] = "Стол с яствами"
L["Repair Bot"] = "Ремонтный робот"
L["Reporting"] = "Сообщения"
L["Reporting options"] = "Опции сообщений"
L["Report missing to raid"] = "Сообщить рейду об отсутствии"
L["Report to officer channel"] = "Отчет в канал офицеров"
L["Report to officers"] = "Отчет офицерам"
L["Report to /raid or /party who is not buffed to the max."] = "Сообщить в чат рейда или группы, на ком отсутствуют нужные баффы."
L["Report to raid/party"] = "Отчет для рейда/группы"
L["Report to raid/party - requires raid assistant"] = "Отчет для рейда/группы - требуются права ассистента"
L["Report to self"] = "Отчет для себя"
L["Require the Alt buton to be held down to move the dashboard window"] = "Требовать зажатие Alt для перемещения табло"
-- L["[RESIST] Danielbarron FAILED TO TAUNT their target (The Lich King) with Hand of Reckoning"] = ""
L["[RESIST] Darinia FAILED TO TAUNT my target (The Lich King) with Taunt"] = "Darinia FAILED TO TAUNT my target (Lich King) with Taunt" -- Needs review
L["Right click"] = "Клик правой кнопкой"
L["Seconds between updates"] = "Секунд между обновлениями"
L["Select which action to take when you click with the left mouse button over a dashboard buff check"] = "Выберите действие при клике левой кнопкой мыши по табло"
L["Select which action to take when you click with the left mouse button with Alt held down over a dashboard buff check"] = "Выберите действие при клике левой кнопкой мыши с зажатой клавишей Alt по табло"
L["Select which action to take when you click with the left mouse button with Ctrl held down over a dashboard buff check"] = "Выберите действие при клике левой кнопкой мыши с зажатой клавишей Ctrl по табло"
L["Select which action to take when you click with the left mouse button with Shift held down over a dashboard buff check"] = "Выберите действие при клике левой кнопкой мыши с зажатой клавишей Shift по табло"
L["Select which action to take when you click with the right mouse button over a dashboard buff check"] = "Выберите действие при клике правой кнопкой мыши по табло"
L["Select which action to take when you click with the right mouse button with Alt held down over a dashboard buff check"] = "Выберите действие при клике правой кнопкой мыши с зажатой клавишей Alt по табло"
L["Select which action to take when you click with the right mouse button with Ctrl held down over a dashboard buff check"] = "Выберите действие при клике правой кнопкой мыши с зажатой клавишей Ctrl по табло"
L["Select which action to take when you click with the right mouse button with Shift held down over a dashboard buff check"] = "Выберите действие при клике правой кнопкой мыши с зажатой клавишей Shift по табло"
L["Set how many seconds between dashboard raid scan updates"] = "Назначить количество секунд между сканированиями рейда"
L["Set N - the number of people missing a buff considered to be \"MANY\". This also affects reagent buffing"] = "Назначить N - количество игроков с отсутствующим баффом, расценивающееся, как \"МНОГО\". This also affects reagent buffing"
L["Shift-left click"] = "Shift+клик левой кнопкой"
L["Shift-right click"] = "Shift+клик правой кнопкой"
L["Shorten names"] = "Сокращать имена"
L["Shorten names in the report to reduce channel spam"] = "Сокращать имена в отчетах, чтобы уменьшить спам в каналах"
L["Short missing blessing"] = "Сокращенные отсутствующие благословения"
L["Show group number"] = "Показывать номер группы"
L["Show in battleground"] = "Показывать на поле боя"
L["Show in party"] = "Показывать в группе"
L["Show in raid"] = "Показывать в рейде"
L["Show the buff report dashboard."] = "Показать табло отчета по баффам."
L["Show the group number of the person missing a party/raid buff"] = "Показывать номер группы игрока, на котором отсутствует групповой/рейдовый бафф"
L["Skin and minimap options"] = "Шкурки и опции мини-карты"
-- L["Skip buff checking during combat. You can manually initiate a scan by pressing Scan on the dashboard"] = ""
L["Soul Well"] = "Источник душ" -- Needs review
L["Status bars to show raid, dps, tank health, mana, etc"] = "Полосы статуса для отображения здоровья/маны рейда/танков/хилеров/DPS"
L["Tank breaks CC"] = "Танк сбивает контроль"
L["Tank Danielbarron has died!"] = "Танк Danielbarron умирает!" -- Needs review
L["Tank death"] = "Смерть танка" -- Needs review
L["Tank health"] = "Здоровье танков"
L["Tank list"] = "Список танков"
L["Tanks alive"] = "Живые танки"
L["Tank warnings"] = "Сообщения для танков"
L["Tank warnings about taunts, failed taunts and mob stealing including accidental taunts from non-tanks"] = "Сообщения о провокациях, неудачных провокациях и краже мобов"
L["Taunts to my mobs"] = "Провокации моих мобов"
L["Taunts to my target"] = "Провокации моей цели"
L["TBC flasks and elixirs"] = "Настои и эликсиры из TBC"
L["Tells you when someone in your party, raid or guild has a newer version of RBS installed"] = "Сообщить вам если кто-нибудь из группы, рейда, или гильдии имеет более новую версию RBS"
L["Test"] = "Тест"
L["Test what the warning is like"] = "Тестирование объявления"
L["The average DPS mana percent"] = "Средний процент маны DPS"
L["The average healer mana percent"] = "Средний процент маны хилеров"
L["The average party/raid health percent"] = "Средний процент здоровья участников группы/рейда"
L["The average party/raid mana percent"] = "Средний процент маны участников группы/рейда"
L["The average tank health percent"] = "Средний процент здоровья танков"
L["The Buff Wizard automatically configures the dashboard buffs and configuration defaults for your class or raid leading role."] = "Мастер баффов автоматически настраивает табло баффов и подгоняет стандарты для вашего класса или роли лидера."
L["The percentage of healers alive in the raid"] = "Процент живых хилеров в рейде"
L["The percentage of people alive in the raid"] = "Процент живых участников рейда"
L["The percentage of people dead in the raid"] = "Процент людей, погибших в рейде"
L["The percentage of people within 40 yards range"] = "Процент людей, в радиусе 40 метров"
L["The percentage of tanks alive in the raid"] = "Процент живых танков в рейде"
-- L["This is the default configuration in which RBS ships out-of-the-box.  It gives you pretty much anything a raid leader would need to see on the dashboard"] = ""
L["Toggle to display a minimap icon"] = "Показать/скрыть иконку у мини-карты"
L["Use Pally Power"] = "Использовать Pally Power"
L["Version announce"] = "Сообщать о версии"
-- L["Wait before announcing to see if others have announced first in order to reduce spam"] = ""
L["Warning messages when players die"] = "Оповещение смерти игроков"
L["Warnings when Crowd Control is broken by tanks and non-tanks"] = "Сообщения о снятии контроля танками и не-танками"
L["Warnings when Misdirection or Tricks of the Trade is cast"] = "Оповещать о применении перенаправления или маленьких хитростей"
L["Warnings when someone else targets a mob and taunts that mob which is targeting you"] = "Сообщение о провокации другими игроками моба, целью которого являетесь вы"
L["Warnings when someone else taunts your target"] = "Сообщение о провокации вашей цели кем-либо"
L["Warnings when someone else taunts your target who is not a tank"] = "Сообщение о провокации вашей цели кем-либо, не являющимся танком"
L["Warns when a non-tank breaks Crowd Control"] = "Предупреждать когда не-танк сбивает контроль"
L["Warns when a tank breaks Crowd Control"] = "Предупреждать когда танк сбивает контроль"
L["Warns when other people's taunts to your target fail"] = "Сообщение о неудачных провокациях вашей цели другими людьми"
L["Warns when someone else taunts your target which is targeting you"] = "Сообщение о провокации другими игроками вашей цели, целью которой являетесь вы"
-- L["Warns when your taunts fail due to resist"] = ""
L["Warns when your taunts fail due to the target being immune"] = "Сообщение о неудаче ваших провокаций" -- Needs review
L["Warn to party"] = "Сообщать группе"
L["Warn to party when a healer dies"] = "Сообщать группе, когда умирает целитель" -- Needs review
L["Warn to party when a melee DPS dies"] = "Сообщать группе, когда умирает мили DPS" -- Needs review
L["Warn to party when a non-tank breaks Crowd Control"] = "Сообщать группе о снятии контроля не-танком"
L["Warn to party when a ranged DPS dies"] = "Оповестить в группу о смерти бойца дальнего боя"
L["Warn to party when a tank breaks Crowd Control"] = "Сообщать группе о снятии контроля танком"
L["Warn to party when a tank dies"] = "Сообщать группе, когда умирает танк" -- Needs review
-- L["Warn to party when one of your taunts fails due to resist"] = ""
L["Warn to party when one of your taunts fails due to the target being immune"] = "Сообщать группе о неудаче ваших провокаций" -- Needs review
L["Warn to party when other people's taunts to your target fail"] = "Сообщать группе о неудачных провокациях вашей цели другими людьми"
L["Warn to party when someone else targets a mob and taunts that mob which is targeting you"] = "Сообщать группе о провокации другими игроками моба, целью которого являетесь вы"
L["Warn to party when someone else taunts your target"] = "Сообщать группе о провокации вашей цели кем-либо"
L["Warn to party when someone else taunts your target which is targeting you"] = "Сообщать группе о провокации другими игроками вашей цели, целью которой являетесь вы"
L["Warn to party when someone else who is not a tank taunts your target"] = "Сообщать группе о провокации вашей цели кем-либо, не являющимся танком"
L["Warn to raid chat"] = "Сообщать в рейд" -- Needs review
L["Warn to raid chat when a healer dies"] = "Сообщать рейду, когда умирает целитель" -- Needs review
L["Warn to raid chat when a melee DPS dies"] = "Сообщать рейду, когда умирает мили DPS" -- Needs review
L["Warn to raid chat when a non-tank breaks Crowd Control"] = "Сообщать в канал рейда о снятии контроля не-танком."
L["Warn to raid chat when a ranged DPS dies"] = "Оповестить в рейд о смерти бойца дальнего боя"
L["Warn to raid chat when a tank breaks Crowd Control"] = "Сообщать рейду о снятии контроля танком"
L["Warn to raid chat when a tank dies"] = "Сообщать рейду, когда умирает танк" -- Needs review
-- L["Warn to raid chat when one of your taunts fails due to resist"] = ""
L["Warn to raid chat when one of your taunts fails due to the target being immune"] = "Сообщать в чат рейда о неудачах ваших провокаций" -- Needs review
L["Warn to raid chat when other people's taunts to your target fail"] = "Сообщать рейду о неудачах провокации вашей цели другими людьми"
L["Warn to raid chat when someone else targets a mob and taunts that mob which is targeting you"] = "Сообщать рейду о провокации другими игроками моба, целью которого являетесь вы"
L["Warn to raid chat when someone else taunts your target"] = "Сообщать рейду о провокации вашей цели кем-либо"
L["Warn to raid chat when someone else taunts your target which is targeting you"] = "Сообщать рейду о провокации вашей цели, целью которой являетесь вы, другими людьми"
L["Warn to raid chat when someone else who is not a tank taunts your target"] = "Сообщать рейду о провокации вашей цели кем-либо, не являющимся танком"
L["Warn to raid warning"] = "Объявлять рейду"
L["Warn to self"] = "Сообщение для себя"
L["Warn to self when a healer dies"] = "Предупреждать себя, когда умирает целитель"
L["Warn to self when a melee DPS dies"] = "Информировать себя, когда умирает мили DPS" -- Needs review
L["Warn to self when a non-tank breaks Crowd Control"] = "Информировать себя когда не-танк сбивает контроль" -- Needs review
L["Warn to self when a ranged DPS dies"] = "Оповестить себя о смерти бойца дальнего боя"
L["Warn to self when a tank breaks Crowd Control"] = "Информировать себя когда танк сбивает контроль" -- Needs review
L["Warn to self when a tank dies"] = "Информировать себя, когда умирает танк" -- Needs review
L["Warn to self when Misdirection or Tricks of the Trade is cast"] = "Сообщить себе когда применяется перенаправление или маленькие хитрости"
-- L["Warn to self when one of your taunts fails due to resist"] = ""
L["Warn to self when one of your taunts fails due to the target being immune"] = "Сообщение для себя о неудаче ваших провокаций" -- Needs review
L["Warn to self when other people's taunts to your target fail"] = "Сообщение для себя о неудачных провокациях вашей цели другими людьми"
L["Warn to self when someone else targets a mob and taunts that mob which is targeting you"] = "Сообщать для себя о провокации другими игроками моба, целью которого являетесь вы"
L["Warn to self when someone else taunts your target"] = "Сообщение для себя о провокации вашей цели кем-либо"
L["Warn to self when someone else taunts your target which is targeting you"] = "Сообщение для себя провокации другими игроками вашей цели, целью которой являетесь вы"
L["Warn to self when someone else who is not a tank taunts your target"] = "Сообщение для себя о провокации вашей цели кем-либо, не являющимся танком"
L["Warn using raid warning when a healer dies"] = "Объявлять рейду, когда умирает целитель" -- Needs review
L["Warn using raid warning when a melee DPS dies"] = "Объявлять рейду, когда умирает боец ближнего боя"
L["Warn using raid warning when a non-tank breaks Crowd Control"] = "Объявлять рейду о снятии контроля не-танком"
L["Warn using raid warning when a ranged DPS dies"] = "Объявлять рейду, когда умирает боец дальнего боя"
L["Warn using raid warning when a tank breaks Crowd Control"] = "Объявлять рейду о снятии контроля танком"
L["Warn using raid warning when a tank dies"] = "Объявлять рейду, когда умирает танк "
L["Warn using raid warning when one of your taunts fails due to resist"] = "Объявлять рейду о неудаче ваших провокаций из-за сопротивление"
L["Warn using raid warning when one of your taunts fails due to the target being immune"] = "Объявлять рейду о неудаче ваших провокаций в результате невосприимчивости цели к ней"
L["Warn using raid warning when other people's taunts to your target fail"] = "Объявлять рейду о неудачных провокациях вашей цели другими людьми"
L["Warn using raid warning when someone else targets a mob and taunts that mob which is targeting you"] = "Объявлять рейду о провокации другими игроками моба, целью которого являетесь вы"
L["Warn using raid warning when someone else taunts your target"] = "Объявлять рейду о провокации вашей цели кем-либо"
L["Warn using raid warning when someone else taunts your target which is targeting you"] = "Объявлять рейду о провокации другими игроками вашей цели, целью которой являетесь вы"
L["Warn using raid warning when someone else who is not a tank taunts your target"] = "Объявлять рейду о провокации вашей цели кем-либо, не являющимся танком"
L["Warn when a healer dies"] = "Оповестить о смерти лекаря"
L["Warn when a melee DPS dies"] = "Оповестить о смерти бойца ближнего боя"
L["Warn when a ranged DPS dies"] = "Оповестить о смерти бойца дальнего боя"
L["Warn when a tank dies"] = "Оповестить о смерти танка"
-- L["Well auto whisper"] = ""
L["When at least N people are missing a raid buff say MANY instead of spamming a list"] = "Если по крайней мере на N игроках отсутствует рейдовый бафф, отображать МНОГО вместо перечисления всего списка"
L["When many say so"] = "Отображать \"много\""
L["When showing the names of the missing Paladin blessings, show them in short form"] = "Отображать отсутствующие благословения в сокращенной форме"
-- L["When there are multiple people who can provide a missing buff such as Fortitude then only whisper one of them at random who is in range rather than all of them"] = ""
L["When whispering and at least N people are missing a raid buff say MANY instead of spamming a list"] = "Если по крайней мере на N игроках отсутствует бафф, шептать МНОГО вместо перечисления всего списка"
L["Whisper buffers"] = "Шепнуть бафферам"
L["Whisper many"] = "Шептать \"много\""
-- L["Whisper only one"] = ""
L["Your taunt immune-fails"] = "Неудачи ваших провокаций" -- Needs review
-- L["Your taunt resist-fails"] = ""




--RaidStatusBars - The bars showing alive/mana/etc on the main dashboard.
L["Dead healers"] = "Мертвые лекари"
L["Dead tanks"] = "Мертвые танки"
L["I see dead people"] = "Я вижу мёртвого игрока"
L["n/a"] = "n/a"




--TalentsWindow - Messages and buttons in the talents window which is the window opened by clicking top left button on the dashboard.
L["Affliction"] = "Колдовство"
L["Arcane"] = "Тайная магия"
L["Arms"] = "Оружие"
L["Assassination"] = "Убийство"
L["Balance"] = "Баланс"
L["Beast Mastery"] = "Чувство зверя"
L["Blood"] = "Кровь"
L["Class"] = "Класс"
L["Combat"] = "Бой"
L["Demonology"] = "Демонология"
L["Destruction"] = "Разрушение"
L["Discipline"] = "Послушание"
L["Dual wield"] = "Бой двумя оружиями"
L["Elemental"] = "Укрощение стихии"
L["Enhancement"] = "Совершенствование"
L["Feral Combat"] = "Сила зверя"
L["Fire"] = "Огонь"
L["Frost"] = "Лед"
L["Fury"] = "Неистовство"
L["Has Aura Mastery"] = "Имеется Мастер аур"
L["Healer"] = "Хилер"
L["Holy"] = "Свет"
L["Hybrid"] = "Гибрид"
L["Improved Health Stone level 1"] = "Улучшенный камень здоровья, Уровень 1"
L["Improved Health Stone level 2"] = "Улучшенный камень здоровья, Уровень 2"
L["Marksmanship"] = "Стрельба"
L["Melee DPS"] = "Мили DPS"
L["Name"] = "Имя"
L["Protection"] = "Защита"
L["Ranged DPS"] = "Рендж DPS"
L["Refresh"] = "Обновить"
L["Restoration"] = "Исцеление"
L["Retribution"] = "Возмездие"
L["Role"] = "Роль"
L["Shadow"] = "Темная магия"
L["Spec"] = "Спек"
L["Specialisations"] = "Специализации"
L["Subtlety"] = "Скрытность"
L["Survival"] = "Выживание"
L["Talent Specialisations"] = "Специализация в талантах"
L["Tank"] = "Танк"
L["Unholy"] = "Нечестивость"




--TankTauntWarnings - The messages about tank taunts.
-- L["NON-TANK %s taunted my boss target (%s%s%s) with %s"] = ""
-- L["NON-TANK %s taunted my target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO NINJA my boss target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO NINJA my target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO TAUNT my boss target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO TAUNT my target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO TAUNT their boss target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO TAUNT their target (%s%s%s) with %s"] = ""
-- L["%s ninjaed my boss target (%s%s%s) with %s"] = ""
-- L["%s ninjaed my target (%s%s%s) with %s"] = ""
-- L["%s taunted my boss mob (%s%s%s) with %s"] = ""
-- L["%s taunted my boss target (%s%s%s) with %s"] = ""
-- L["%s taunted my mob (%s%s%s) with %s"] = ""
-- L["%s taunted my target (%s%s%s) with %s"] = ""

