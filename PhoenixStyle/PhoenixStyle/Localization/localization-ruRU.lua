if GetLocale() == "ruRU" then


function pslocalezone()
pszonecoliseum				= "Испытание крестоносца"
pszoneulduar				= "Ульдуар"
pszoneicecrowncit			= "Цитадель Ледяной Короны"

end



function pslocale()


pserror					= "Ошибка!"
psattention				= "Внимание!"
psnotinraid				= "Вы должны находиться в рейде!"
pserrornotofficer			= "У вас нет прав на использование этой функции в рейде. Попросите повышения у Рейд Лидера."
psfnotofficerspam			= "У вас нет прав для отправки сообщений в чат, но объявления включены в аддоне."
pserrormenutimer1			= "Для запуска таймера атаки введите время между 2 и 20 сек."
pserrormenutimer2			= "пример: /фен атака 5, для отмены атаки введите /фен атака"
pserrorcantdo1				= "Не могу выполнить, все модули аддона отключены, включите аддон и повторите попытку."
psaddonon				= "Включить аддон"
psaddonrepon				= "Включить объявления аддона в чат"
psminibuttset				= "Отображать кнопку на мини-карте"
psaddonok				= "OK"
psmoduleload				= "Загружен модуль"
psmodulenotload				= "Не удалось загрузить модуль"
psmarkserror				= "У вас нет прав на использование меток в рейде. Хотя вы запустили модуль автообновления меток."
pswarnings				= "Оповещения в аддоне"
pswarningson				= "включены"
pswarningsoff				= "отключены"
psmarkreflesh				= "Автообновление меток"
psmarkrefleshoff			= "отключено"
psmarkrefleshon				= "включено"
pschatlist1				= "рейд"
pschatlist2				= "объявление рейду"
pschatlist3				= "офицер"
pschatlist4				= "группа"
pschatlist5				= "гильдия"
pschatlist6				= "сказать"
pschatlist7				= "крикнуть"
pschatlist8				= "только себе"
psaddonmy				= "Аддон"
psaddonon2				= "включен"
psaddonoff				= "отключен"
pssec					= "сек."
psmin					= "мин."
psaddonrepnoprom2			= "Теперь для отправки сообщений аддона в чат Вам не нужен статус помощника."
psaddonrepnoprom3			= "Теперь для отправки сообщений аддона в чат Вам необходимо иметь статус помощника."
psulhp					= "ХП"
psnotfoundinr				= "не найден в Вашем рейде."
pscolnewveranonce1			= "Модуль |cff00ff00успешно обновлен|r, последние изменения:"
psnewversfound				= "|cff00ff00ВНИМАНИЕ!|r В Вашем рейде/гильдии обнаружена новая версия аддона |cff00ff00'PhoenixStyle'|r, рекомендуется скачать обновление с curse.com или wowinterface.com"
psnewversfound2				= "|cff00ff00ВНИМАНИЕ!|r В Вашем рейде/гильдии обнаружена новая версия аддона |cff00ff00'PhoenixStyle'|r, Ваша версия |cffff0000СИЛЬНО УСТАРЕЛА|r, крайне рекомендуется скачать обновление с curse.com или wowinterface.com"
psrscoldvers				= "Ваша версия аддона 'RaidSlackCheck' - |cffff0000устарела!|r Скачайте обновление во избежании ошибок."
psiccnoloaderr2				= "Модуль 'Цитадель' не запущен. Опция пока не доступна."
psautomarnotu				= "Метка {rt%s} |cffff0000не будет|r обновляться!"
psautomarnewinfo			= "|cff00ff00Новинка!|r Теперь можно прописывать несколько ников на 1 метку (через запятую). Если первый человек умрет или выйдет из игры - метка автоматом будет поддерживаться на след. игроке из списка."



end



function pslocaleui()

pstimers				= "    Таймеры"
pstimersinfo1				= "При запуске таймера аддон создает в боссмодах глобальные полосы-таймеры для всего рейда"
pstimersinfo2				= "Доступные боссомоды:"
pstimersinfo9				= "Для таймера |cffffffffАтаки|r использовать: |cff00ff00/фен пулл 5|r"
pstimersinfo10				= "или: |cff00ff00/фен атака 5|r (цифра любая от 2 до 20 сек.)"
pstimersinfo11				= "или: введите секунды для таймера Атаки:"
pstimersinfo12				= "Таймер |cffffffffПерерыва|r!"
pstimersinfo13				= "введите время для таймера перерыва:"
pstimersinfo14				= "Создать |cffffffffсвой|r таймер"
pstimersinfo15				= "введите название:"
pstimersinfo16				= "время:"
pstimerbutton1				= "Запустить таймер атаки"
pstimerbutton2				= "Запустить таймер перерыва"
pstimerbutton3				= "Запустить свой таймер"
psminut					= "минут"
pssecund				= "секунд"
psleftmenu1				= "Аддон"
psleftmenu2				= "Автомаркование"
psleftmenu3				= "Таймеры"
psleftmenu5				= "Ульдуар"
psleftmenu6				= "Колизей"
psleftmenu7				= "Цитадель"
psmarks					= "    Автообновление меток на рейде"
psmarkinfo1				= "Частота обновления меток: раз в"
psmarkinfo2				= "Настроить обновление меток для:"
psmarkinfo3				= "Автообновление меток включено"
psmarkinfo4				= "Автообновление меток отключено"
psbuttonon				= "Включить"
psbuttonoff				= "Отключить"
psbuttonreset				= "Сбросить"
psuinomodule1				= "    Ошибка! Модуль не установлен!"
psuinomodule2				= "Произошла ошибка! Выбранный Вами модуль не установлен!"
psuierror				= "    Ошибка!"
psuierroraddonoff			= "Ошибка! Аддон отключен - данный модуль не доступен!"
psaddonofmodno				= "Аддон отключен, этот модуль не доступен."
psnopermissmark				= "У вас нет прав на использование меток в рейде."
psnonickset				= "Вы не ввели ниодного ника."
pssend					= "Отправить"
psulsendto				= "Сообщить в канал:"
psulvkl					= "вкл:"
psulchatch				= "канал чата:"
psulonlyattheend			= "- сообщать только по окончанию боя"
psulonlyattheendstal			= "- сообщать только если время > 1 сек."
psfserver				= "ru-Гордунни"
psaddonrepnoprom			= "объявлять в чат без статуса помощника"
psraaddonanet				= "Ошибка! Аддон 'RaidAchievement' не установлен"
psraaddonanet2				= "Вы можете скачать его с сайтов curse.com или wowinterface.com"
pscolshieldannonce			= "сообщ. в чат"
pscolcast11				= "время каста"
pswebsite				= "www.blacklotus.ru & www.phoenix-wow.ru"
pschatmaxchan				= "Максимально можно добавить 5 персональных каналов."
pschataddsuc				= "успешно добавлен в список каналов чата."
pschatremsuc				= "успешно удален со списка каналов чата."
pschataddfail				= "Нет доступных чатов для добавления в список."
pschatremfail				= "Каналы чата, установленные по умолчанию, удалять запрещено."
pschataddbut				= "Добавить"
pschatrembut				= "Удалить"
pschatopttitl				= "    Добавление и удаление дополнительных каналов чата в списке"
pschatchopt				= "Настройка каналов чата"
pschatnothadd				= "Нет доступных каналов"
pschataddtxtset1			= "Выберите в меню ниже нужный Вам канал чтобы |cff00ff00добавить|r его."
pschataddtxtset2			= "Доступных каналов для добавления нет, попробуйте присоединиться к ним: /join имя_канала."
pschattitl2				= "Вывод сообщений по умолчанию доступен для 8 общих каналов, здесь Вы можете добавлять и удалять персональные каналы, чтобы после выводить туда сообщения."
pschetremtxt1				= "Выберите в меню ниже нужный Вам канал чтобы |cffff0000удалить|r его (каналы установленные по умолчанию защищены от изменений)."
psmoduletxton				= "модуль включен"
psmoduletxtoff				= "модуль отключен"
psfpotchecklocal			= "Проверка зелий"
psfpotchecklocal2			= "    Проверка зелий"
psfneedrscaddon				= "Для отображения этого модуля требуется аддон 'RaidSlackCheck'"
rsclocrlslak				= "сообщ. слак Рейд Лидера"
rsclocpot2				= "0 выбранных зелий"
psfneedrscaddon2			= "Аддон отображает время использования зелий в рейде и тех, кто их не использует"
rsclocpot10				= "Кто пил"
rsclocpot11				= "Кто НЕ пил"
rscloccolor				= "цветные ники"
psmarkofftxt				= "Снять все метки с рейда"
psoldvertxt				= "(устаревшая)"
psfpotchecklocalt2			= "Проверка настоев"
psfpotchecklocalt3			= "Обн. баффов в бою"
psfneedrscaddonver11			= "версии 1.1 или выше"
psautomarktxtinf			= "Вы хотите поставить метки на игроков, но боитесь что один из босс-модов снимет их? Воспользуйтесь этим модулем! Он обновляет метки на игроках и не дает другим аддонам снимать их."



end



function pslocaletimers()

psattack				= "Атака"
psattackin				= "Атака через"
pscanceled				= "ОТМЕНЕНА!"
pstimeerror1				= "Введите число между 2 и 20 сек."
pstimeerror2				= "Таймер перерыва не может быть более получаса!"
pstimeerror3				= "Таймер перерыва не может быть менее 30 сек!"
pstimeerror4				= "Таймер не может быть более 2 часов!"
pstimeerror5				= "Таймер не может быть менее 10 сек!"
pstwobm					= "Время до окончания будет показано таймерами в BigWigs, DBM, DXE и RaidWatch2."
pstimerstarts				= "Запущен таймер"
pspereriv				= "ПЕРЕРЫВ"
pspereriv2				= "Перерыв"
pstimernoname				= "Без названия"
pserrorcantdoanotherpullis		= "Таймер 'Атаки' уже запущен другим аддоном!"


end

end