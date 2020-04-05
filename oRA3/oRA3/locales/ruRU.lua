local L = LibStub("AceLocale-3.0"):NewLocale("oRA3", "ruRU")
if not L then return end

-- Generic
L["Name"] = "Имя"
L["Checks"] = "Проверка"
L["Disband Group"] = "Распустить группу"
L["Disbands your current party or raid, kicking everyone from your group, one by one, until you are the last one remaining.\n\nSince this is potentially very destructive, you will be presented with a confirmation dialog. Hold down Control to bypass this dialog."] = "Распустить вашу текущую группу или рейд, исключая каждого из вашей группы пока вы не останетесь один.\n\nВам будет представлено диалоговое окно подтверждения. Удерживайте Control чтобы избежать этого диалога."
L["Options"] = "Настройки"
L["<oRA3> Disbanding group."] = "<oRA3> группа распущена."
L["Are you sure you want to disband your group?"] = "Вы действительно хотите распустить вашу группу?"
L["Unknown"] = "Неизвестно"

-- Core

L["Open with raid pane"] = "Открыть с панелью рейда"
L.toggleWithRaidDesc = "Автоматически открывает и закрывает панель вместе с панелью рейда. Если вы отключите данную опцию, вы сможете открыть панель oRA3 используя назначения клавиш или слэш командой, такой как |cff44ff44/radur|r."
L["Show interface help"] = "Показать справку по интерфейсу"
L.showHelpTextsDesc = "Интерфейс оRA3 полон полезных текстов, справки, предназначенной для более точного описания того, что происходит и что из себя представляют различные элементы интерфейса. Отключив данную опцию, они будут убраны, тем самым ограничивая беспорядок на каждой панели. |cffff4411Для некоторых панелей, требуется перезагрузка интерфейса.|r"

L["Slash commands"] = "Слаш команды"
L.slashCommands = [[
oRA3 имеет ряд слаш команд, которые помогут вам с рейдами. В случае, если вы не были знакомы со старым CTRA, здесь есть немного информации. Все команды имеют различные сокращения. Для удобства, в некоторых случаях есть альтернотивное описание.

|cff44ff44/radur|r - Открывает список Прочности.
|cff44ff44/razone|r - Открывает список Pон.
|cff44ff44/rares|r - Открывает список Сопротивления.
|cff44ff44/radisband|r - Мгновенно распускает рейде без всяческой проверки.
|cff44ff44/raready|r - Провести проверку готовности.
|cff44ff44/rainv|r - Приглосить всю гильдию в вашу группу.
|cff44ff44/razinv|r - Приглосить участников гильдии из тойже зоны что и вы.
|cff44ff44/rarinv <rank name>|r - Приглосить участников гильдии с заданным званием.
]]

-- Ready check module
L["The following players are not ready: %s"] = "Следующие игроки не готовы: %s"
L["Ready Check (%d seconds)"] = "Проверка готовности (%d секунд)"
L["Ready"] = "Готов"
L["Not Ready"] = "Не готов"
L["No Response"] = "Нет ответа"
L["Offline"] = "Вышел из сети"
L["Play a sound when a ready check is performed."] = "Проиграть звук при выполнении проверки готовности."
L["Show window"] = "Показать окно"
L["Show the window when a ready check is performed."] = "Показать окно проверки готовности при выполнении проверки."
L["Hide window when done"] = "Скрыть окно при завершении"
L["Automatically hide the window when the ready check is finished."] = "Автоматически скрывать окно проверки готовности после завершения проверки."
L["Hide players who are ready"] = "Скрыть тех кто готов"
L["Hide players that are marked as ready from the window."] = "Скрывать тех игроков которые помечены как готовы."

-- Durability module
L["Durability"] = "Прочность"
L["Average"] = "Среднее"
L["Broken"] = "Сломан"
L["Minimum"] = "Минимум"

-- Resistances module
L["Resistances"] = "Сопротивление"
L["Frost"] = "Лёд"
L["Fire"] = "Огонь"
L["Shadow"] = "Тёмная"
L["Nature"] = "Природа"
L["Arcane"] = "Тайная"

-- Invite module
L["Invite"] = "Пригласить"
L["All max level characters will be invited to raid in 10 seconds. Please leave your groups."] = " Через 10 секунд, все персонажи максимального уровня будут приглашены в рейд. Пожалуйста, выйдите из своих групп."
L["All characters in %s will be invited to raid in 10 seconds. Please leave your groups."] = " Через 10 секунд , все персонажи в %s, будут приглашены в рейд. Пожалуйста, выйдите из своих групп."
L["All characters of rank %s or higher will be invited to raid in 10 seconds. Please leave your groups."] = " Через 10 секунд, все персонажи со званием %s и выше, будут приглашены в рейд. Пожалуйста, выйдите из своих групп."
L["<oRA3> Sorry, the group is full."] = "<oRA3> Извините, группа уже набрана."
L["Invite all guild members of rank %s or higher."] = "Пригласить всех участников гильдии со званием %s и выше."
L["Keyword"] = "Ключевое слово"
L["When people whisper you the keywords below, they will automatically be invited to your group. If you're in a party and it's full, you will convert to a raid group. The keywords will only stop working when you have a full raid of 40 people. Setting a keyword to nothing will disable it."] = "Когда игрок вам шепнёт ключевое слово приведённое ниже, он будет автоматически приглашен в вашу группу. Если вы находитесь в группе, и она полностью заполнена, вам нужно будет преобразовать её в рейд. Ключевые слова перестанут работать только тогда, когда у вас будет полный рейд из 40 человек. Для отключения приглашений, оставьте поле ключевых слов пустым."
L["Anyone who whispers you this keyword will automatically and immediately be invited to your group."] = "Каждый кто шепнёт вам данное ключевое слово будет автоматически и немедленно приглашен в вашу группу\рейд."
L["Guild Keyword"] = "Кл.слово для гильдии"
L["Any guild member who whispers you this keyword will automatically and immediately be invited to your group."] = "Любой участник гильдии, который шепнёт вам данное ключевое слово будет автоматически и немедленно приглашен в вашу группу\рейд."
L["Invite guild"] = "Пригласить гильдию"
L["Invite everyone in your guild at the maximum level."] = "Пригласить всех с вашей гильдии с максимальным уровнем."
L["Invite zone"] = "Пригласить с зоны"
L["Invite everyone in your guild who are in the same zone as you."] = "Пригласить всех с вашей гильдии кто находиться в такой же зоне что и вы."
L["Guild rank invites"] = "Пригласить по рангу гильдии"
L["Clicking any of the buttons below will invite anyone of the selected rank AND HIGHER to your group. So clicking the 3rd button will invite anyone of rank 1, 2 or 3, for example. It will first post a message in either guild or officer chat and give your guild members 10 seconds to leave their groups before doing the actual invites."] = "При нажатии любой из кнопок ниже, пригласит любого из выбранных званий и выше в вашу группу. К примеру нажав кнопку 3, пригласит всех кто со званием 1, 2 или 3. Изначально будет выведено сообщение в канал гильдии или офицерский канал, что даст членам вашей гильдии 10 секунд, для того чтобы они покинули свои группы, прежде чем вы начнёте приглашать их."

-- Promote module
L["Demote everyone"] = "Разжаловать всех"
L["Demotes everyone in the current group."] = "Разжаловать всех в текущей группе."
L["Promote"] = "Повысить"
L["Mass promotion"] = "Масс повышение"
L["Everyone"] = "Всех"
L["Promote everyone automatically."] = "Произвести всех автоматически"
L["Guild"] = "Гильдия"
L["Promote all guild members automatically."] = "Произвести всех участников гильдии автоматически"
L["By guild rank"] = "По рангу гильдии"
L["Individual promotions"] = "Индивидуальное повышение"
L["Note that names are case sensitive. To add a player, enter a player name in the box below and hit Enter or click the button that pops up. To remove a player from being promoted automatically, just click his name in the dropdown below."] = "Помните, что имена чувствительны к регистру. Чтобы добавить игрока, введите имя игрока в поле ниже и нажмите Enter или нажмите на кнопку, что появиться при вводе. Чтобы удалить игрока из автоматического повышения, нажмите на его имя в раскрывающимся списке ниже."
L["Add"] = "Добавить"
L["Remove"] = "Удалить"

-- Cooldowns module
L["Open monitor"] = "Открыть монитор"
L["Cooldowns"] = "Перезарядки"
L["Monitor settings"] = "Настройки мониторинга"
L["Show monitor"] = "Показать мониторинг"
L["Lock monitor"] = "Фиксировать мониторинг"
L["Show or hide the cooldown bar display in the game world."] = "Показать или скрыть панель восстановлений в игравом мире."
L["Note that locking the cooldown monitor will hide the title and the drag handle and make it impossible to move it, resize it or open the display options for the bars."] = "Помните, что блокировка мониторинга восстановления скроет заголовок и якорь для перемещения, что сделает его невозможным для перемещения, изменения размера или открытия панели настроек."
L["Only show my own spells"] = "Показывать только мои заклинания"
L["Toggle whether the cooldown display should only show the cooldown for spells cast by you, basically functioning as a normal cooldown display addon."] = "Переключение отображения восстановления только для заклинаний применённых вами, в противоположном случаи, будет функционировать как обычный аддон для отображения восстановлений."
L["Cooldown settings"] = "Настройки восстановлений"
L["Select which cooldowns to display using the dropdown and checkboxes below. Each class has a small set of spells available that you can view using the bar display. Select a class from the dropdown and then configure the spells for that class according to your own needs."] = "Выберите, какие восстановления отображать, с помощью раскрывающегося блока и ячеек ниже. Каждый класс имеет небольшой набор доступных заклинаний, которые можно просматривать используя панель отображения. Выберите один класс из раскрывающегося блока, а затем настроить заклинания для этого класса в соответствии с вашими потребностями."
L["Select class"] = "Выберите класс"
L["Never show my own spells"] = "Не показывать мои способности"
L["Toggle whether the cooldown display should never show your own cooldowns. For example if you use another cooldown display addon for your own cooldowns."] = "Отключает отображение восстановлений ваших способностей. К примеру если для отображения восстановлений ваших способностей вы используете другой аддон."

-- monitor
L["Cooldowns"] = "Перезарядки"
L["Right-Click me for options!"] = "[Правый-клик] открывает настройки."
L["Bar Settings"] = "Настройка панели"
L["Spawn test bar"] = "Запустить тест панель"
L["Use class color"] = "Окраска класса"
L["Custom color"] = "Свой цвет"
L["Height"] = "Высота"
L["Scale"] = "Масштаб"
L["Texture"] = "Текстура"
L["Icon"] = "Иконка"
L["Show"] = "Показать"
L["Duration"] = "Длительность"
L["Unit name"] = "Персонаж"
L["Spell name"] = "Заклинание"
L["Short Spell name"] = "Сокр. заклинание"
L["Label Align"] = "Выравнивать"
L["Left"] = "Влево"
L["Right"] = "Вправо"
L["Center"] = "По центру"
L["Grow up"] = "Рост вверх"

-- Zone module
L["Zone"] = "Зона"

-- Loot module
L["Leave empty to make yourself Master Looter."] = "Оставьте пустыми чтобы сделать себя ответственным за добычу."
L["Let oRA3 to automatically set the loot mode to what you specify below when entering a party or raid."] = "Позволяет oRA3 автоматически установить режим обыска, который вы укажите ниже, при присоединении к группе или рейду."
L["Set the loot mode automatically when joining a group"] = "Установить режим обыска автоматически при присоединении к группе."
 
-- Tanks module
L["Tanks"] = "Танки"
L.tankTabTopText = "Кликните по игрокам из нижнего списка чтобы пометить их как личные танки. Если вам требуется справка по параметрам, наведите курсор мыши на знак вопроса."
-- L["Remove"] is defined above
L.deleteButtonHelp = "Удалить из списка танков."
L["Blizzard Main Tank"] = "Главный \"танк\" Blizzard"
L.tankButtonHelp = "Переключение обозначения танка как Главный \"танк\" Blizzard."
L["Save"] = "Сохр."
L.saveButtonHelp = "Сохроняет этого танка в вашем личном списке. В любое время когда вы будите в одной группе с этим игроком он будет указан в качестве личного танка."
L["What is all this?"] = "Что все это значит?"
L.tankHelp = "Игроки в верхнем списке это ваши личные танки. Они не показываются рейду, и каждый может иметь свой личный список танков. Кликая по именам в нижнем списке они будут добавляться в ваш личный список.\n\nНажимая на иконку щита, это будет означать что эта персона является Главным \"танком\" Blizzard. Танки Blizzard видны всему рейду и для их переключение нужно иметь соответствующие полномочия в рейде.\n\nТанки, которые фигурируют в списке благодаря кому-то еще делает их Blizzard МТ, они будет удалены из списка, когда они больше не будут значится как Blizzard МТ.\n\nИспользуйте зеленую галочку, чтобы сохранить танков между сессиями. Следующий раз, когда вы будите в рейде с этим человеком, он будет автоматически установлен в качестве личного танка."
L["Sort"] = "Сорт."
L["Click to move this tank up."] = "Кликните чтобы передвинуть этого танка вверх."
L["Show"] = "Показать"
L.showButtonHelp = "Показывать этого танка в вашем личном отсортированом дисплее танков. Этот параметр имеет только локальный эффект и не изменит статуса танков для кого-либо из вашей группы."
