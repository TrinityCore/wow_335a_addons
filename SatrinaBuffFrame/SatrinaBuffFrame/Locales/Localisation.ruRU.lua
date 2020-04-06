-- Translated by StingerSoft
if ( GetLocale() == "ruRU" ) then
SBF.strings.DISABLE = "Демонтировать SBF для отключения"
SBF.strings.BUFFEXPIRE = "вот-вот истечет"
SBF.strings.BUFFNOTICE = "истек"
SBF.strings.VERSION = "версия %s"
SBF.strings.NEWPLAYER = "Новый игрок Satrina Buff Frames: "
SBF.strings.UPDATE = "Обновите Satrina Buff Frames до %.1f"
SBF.strings.RESET = "Данное обновление требует сброса всех сохраненных переменных - извените!"
SBF.strings.EXCLUDE = "Не отображать данный бафф"
SBF.strings.BUFFFRAME = "Отображать во фрейме баффов"
SBF.strings.NOFRAME = "Очистить фрейм"
SBF.strings.ALWAYSWARN = "Всегда предупреждать, при истечении"
SBF.strings.CANCEL = "Отменить данный бафф"
SBF.strings.DESTROYTOTEM = "Разрушить данный тотем"
SBF.strings.CONFIGERROR = "Ошибка загрузки фрейма конфигурации SBF: %s"
SBF.strings.DRAGTAB = "SBF %d"
SBF.strings.FRAMETITLE = "Фрейм баффов %d"
SBF.strings.ENCHANTS = "зачарование"
SBF.strings.DRAGTAB1 = "тащите чтобы передвинуть данный фрейм"
SBF.strings.DRAGTAB2 = "shift+клик чтобы выбрать данный фрейм"
SBF.strings.SHOWATBUFFRAME = "Фрейм баффов "
SBF.strings.TEMPENCHANT = "Temp Enchant %d"
SBF.strings.INVALIDBUFF = "Пытаться предупреждать о истечении недействительных баффов"
SBF.strings.OPTIONS = "Открывает настройки SBF"
SBF.strings.HIDE = "Скрыть стандартный фрейм баффов"
SBF.strings.DEFAULT = "Стандарт"
SBF.strings.DEFAULTFRAME = "Стандартный фрейм"

SBF.strings.MAGIC = "Магия"
SBF.strings.CURSE = "Проклятие"
SBF.strings.DISEASE = "Болезнь"
SBF.strings.POISON = "Яд"
SBF.strings.UNKNOWNBUFF = "Неизвестный бафф"
SBF.strings.BUFFERROR = "Ошибка SBF: не получилость вывести подсказку данного баффа"

SBF.strings.ERRBUFF_EXTENT = "Ошибка при получении размера для фрейма %d - фрейм не существует"

SBF.strings.OLDOPTIONS = "SBF Options устарели"
SBF.strings.OPTIONSVERSION = "Версия SBF Options |cff00ff66%s|r не соответствует версии SBF |cff00ff66%s|r"

SBF.strings.OF = "of"
SBF.strings.OFTHE = ""
SBF.strings.NA = "N/A"

SBF.strings.NOTRACKING = "Нет слежений"
SBF.strings.SPELL_COMBUSTION = "Возгорание"
SBF.strings.SPELL_FR_AURA = "Аура защиты от огня"

SBF.strings.SLASHTHROTTLE = "    |cff00ff66регулятор|r - [|cff00aaff%.2f|r] Изменение значение регулятора события (0.00-1.00)"
SBF.strings.INVALIDTHROTTLE = "Значение регулятора должно быть между 0 и 1"
SBF.strings.THROTTLECHANGED = "Значение регулятора |cff00aaff%.2f|r"

SBF.strings.SENTRYTOTEM = "Сторожевой тотем"  -- Keeps sentry totem from being destroyed when you click it

SBF.strings.SLASHHEADER = "|cff00ff66Satrina Buff Frames|r версия |cff00aaff%s|r"
SBF.strings.SLASHOPTIONS = {
  "    |cff00ff66options|r - Открывает настройки SBF",
  "    |cff00ff66hide|r - Скрыть стандартный фрейм баффов",
}

SBF.strings.buffTotems =  {
  "Тотем гнева",
  "Тотем защиты от огня",
  "Тотем языка пламени",
  "Тотем защиты от магии льда",
  "Тотем заземления",
  "Тотем защиты от сил природы",
  "Сторожевой тотем",
  "Тотем каменной кожи",
  "Тотем силы земли",
  "Тотем гнева воздуха",
  "Тотем неистовства ветра",
  "Тотем легкости воздуха", --?
  "Тотем стены ветра", --?
  "Тотем безветрия", --?
}
SBF.strings.sort = {
  "Нет",
  "Время - возрастание",
  "Время - убывание",
  "Название - возрастание",
  "Название - убывание",
  "Продолжительность - возрастание",
  "Продолжительность - убывание",
}
SBF.strings.sounds = {
  "Свист",
  "Звон",
  "Auction Bell",
  "Глухой звук",
  "Мурлок!",
}

end