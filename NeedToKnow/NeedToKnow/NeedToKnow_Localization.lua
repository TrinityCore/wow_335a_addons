--[[ 

If you want to be super helpful, you can translate this stuff into whatever non-enUS language you happen to know and we'll credit you.  Please post the translations as a ticket on CurseForge.com (http://wow.curseforge.com/addons/need-to-know/tickets/) or email them to us (lieandswell@yahoo.com). 

Thanks a bunch!  

--]]

NEEDTOKNOW = {};

-- Define defaults in enUS
    NEEDTOKNOW.BAR_TOOLTIP1 = "NeedToKnow";
    NEEDTOKNOW.BAR_TOOLTIP2 = "Right click bars to configure. More options in the Blizzard interface options menu. Type /needtoknow to lock and enable.";

    NEEDTOKNOW.RESIZE_TOOLTIP = "Click and drag to change size";

    NEEDTOKNOW.BARMENU_ENABLE = "Enable bar";
    NEEDTOKNOW.BARMENU_CHOOSENAME = "Choose buff/debuff to time";
    NEEDTOKNOW.CHOOSENAME_DIALOG = "Enter the name of the buff or debuff to time with this bar"
    NEEDTOKNOW.CHOOSE_OVERRIDE_TEXT = "Normally, the name of the aura/item/spell that activated the bar is displayed.  By entering text here, you can override that text with something else.  Leave this blank to use the default behavior."
    NEEDTOKNOW.BARMENU_CHOOSEUNIT = "Unit to monitor";
    NEEDTOKNOW.BARMENU_PLAYER = "Player";
    NEEDTOKNOW.BARMENU_TARGET = "Target";
    NEEDTOKNOW.BARMENU_FOCUS = "Focus";
    NEEDTOKNOW.BARMENU_PET = "Pet";
    NEEDTOKNOW.BARMENU_VEHICLE = "Vehicle";
    NEEDTOKNOW.BARMENU_TARGETTARGET = "Target of Target";
    NEEDTOKNOW.BARMENU_BUFFORDEBUFF = "Bar Type";
    NEEDTOKNOW.BARMENU_SPELLID = "Use SpellID";
    NEEDTOKNOW.BARMENU_HELPFUL = "Buff";
    NEEDTOKNOW.BARMENU_HARMFUL = "Debuff";
    NEEDTOKNOW.BARMENU_ONLYMINE = "Only show if cast by self";
    NEEDTOKNOW.BARMENU_BARCOLOR = "Bar color";
    NEEDTOKNOW.BARMENU_CLEARSETTINGS = "Clear settings";

    NEEDTOKNOW.UIPANEL_SUBTEXT1 = "These options allow you to customize NeedToKnow's timer bars.";
--    NEEDTOKNOW.UIPANEL_SUBTEXT2 = "Bars work when locked. When unlocked, you can move/size bar groups and right click individual bars for more settings. You can also type '/needtoknow' or '/ntk' to lock/unlock.";
    NEEDTOKNOW.UIPANEL_BARGROUP = "Group ";
    NEEDTOKNOW.UIPANEL_NUMBERBARS = "Number of bars";
    NEEDTOKNOW.UIPANEL_FIXEDDURATION = "Max bar duration";
    NEEDTOKNOW.UIPANEL_LOCK = "Lock";
    NEEDTOKNOW.UIPANEL_UNLOCK = "Unlock";
    NEEDTOKNOW.UIPANEL_TOOLTIP_ENABLEGROUP = "Show and enable this group of bars";
    NEEDTOKNOW.UIPANEL_TOOLTIP_FIXEDDURATION = "Set the maximum length of bars for this group (in seconds).  Leave empty to set dynamically per bar.";
    NEEDTOKNOW.UIPANEL_TOOLTIP_BARTEXTURE = "Choose the texture graphic for timer bars";
    NEEDTOKNOW.CMD_RESET = "reset";

	NEEDTOKNOW.UIPANEL_CONFIGMODE = "Config mode";
	NEEDTOKNOW.UIPANEL_CONFIGMODE_TOOLTIP = "Unlock timer bars and make them configurable";
	NEEDTOKNOW.UIPANEL_PLAYMODE = "Play mode";
	NEEDTOKNOW.UIPANEL_PLAYMODE_TOOLTIP = "Lock and enable timer bars, making them click-through";

    NEEDTOKNOW.UIPANEL_APPEARANCE = "Appearance";
    NEEDTOKNOW.UIPANEL_BACKGROUNDCOLOR = "Background color";
    NEEDTOKNOW.UIPANEL_BARSPACING = "Bar spacing";
    NEEDTOKNOW.UIPANEL_BARPADDING = "Bar padding";
    NEEDTOKNOW.UIPANEL_BARTEXTURE = "Bar texture";
    NEEDTOKNOW.UIPANEL_BARFONT = "Bar font";
    NEEDTOKNOW.UIPANEL_FONT = "Font";

    NEEDTOKNOW.BARMENU_TOTEM = "Totem";
    NEEDTOKNOW.BARMENU_CASTCD = "Spell Cooldown";
    NEEDTOKNOW.BARMENU_BUFFCD = "Internal Cooldown";
    NEEDTOKNOW.BARMENU_USABLE = "Spell Usable";
    NEEDTOKNOW.CMD_HIDE = "hide";
    NEEDTOKNOW.CMD_SHOW = "show";
    NEEDTOKNOW.BARMENU_TIMEFORMAT = "Time Format"; 
    NEEDTOKNOW.FMT_SINGLEUNIT = "Single unit (2 m)";
    NEEDTOKNOW.FMT_TWOUNITS = "Minutes and seconds (01:10)";
    NEEDTOKNOW.FMT_FLOAT = "Fractional Seconds (70.1)";
    NEEDTOKNOW.BARMENU_VISUALCASTTIME = "Visual Cast Time";
    NEEDTOKNOW.BARMENU_VCT_ENABLE = "Enable for this bar";
    NEEDTOKNOW.BARMENU_VCT_COLOR = "Overlay color";
    NEEDTOKNOW.BARMENU_VCT_SPELL = "Choose cast time by spell";
    NEEDTOKNOW.BARMENU_VCT_EXTRA = "Set additional time";
    NEEDTOKNOW.BARMENU_MAIN_HAND = "Main Hand";
    NEEDTOKNOW.BARMENU_OFF_HAND = "Off Hand";
    NEEDTOKNOW.CHOOSE_VCT_SPELL_DIALOG = "Enter the name of a spell (in your spellbook) whose cast time will determine the base length of the visual cast time.  If left blank, the aura name will be used as the spell name.  To force this to be 0, type 0.";
    NEEDTOKNOW.CHOOSE_VCT_EXTRA_DIALOG = "Enter an amount of seconds that will be added to the cast time of the spell.  Ex: 1.5";
    NEEDTOKNOW.CHOOSE_BLINK_TITLE_DIALOG = "Enter the text to display on the bar when it is blinking.";
    NEEDTOKNOW.BUFFCD_DURATION_DIALOG = "Enter the cooldown duration triggered by the buffs watched by this bar.";
    NEEDTOKNOW.USABLE_DURATION_DIALOG = "Enter the cooldown duration triggered by the abilities watched by this bar.";
    

-- replace with translations, if available
if ( GetLocale() == "deDE" ) then
    -- by sp00n and Fxfighter EU-Echsenkessel
    NEEDTOKNOW.BAR_TOOLTIP1 = "NeedToKnow"; 
    NEEDTOKNOW.BAR_TOOLTIP2 = "Rechtsklick auf einen Balken für Einstellungen. Mehr Optionen sind im Blizzard Interface vorhanden. Zum Festsetzen und Aktivieren /needtoknow oder /ntk eingeben.";
    NEEDTOKNOW.RESIZE_TOOLTIP = "Klicken und ziehen, um die Größe zu ändern";
    NEEDTOKNOW.BARMENU_ENABLE = "Leiste aktivieren";
    NEEDTOKNOW.BARMENU_CHOOSENAME = "Buff/Debuff auswählen";
    NEEDTOKNOW.CHOOSENAME_DIALOG = "Name des Buffs/Debuffs für diesen Balken angeben"
    NEEDTOKNOW.BARMENU_CHOOSEUNIT = "Betroffene Einheit";
    NEEDTOKNOW.BARMENU_PLAYER = "Spieler";
    NEEDTOKNOW.BARMENU_TARGET = "Ziel";
    NEEDTOKNOW.BARMENU_FOCUS = "Fokus";
    NEEDTOKNOW.BARMENU_PET = "Begleiter (Pet)";
    NEEDTOKNOW.BARMENU_VEHICLE = "Vehicle";
    NEEDTOKNOW.BARMENU_TARGETTARGET = "Ziel des Ziels";
    NEEDTOKNOW.BARMENU_BUFFORDEBUFF = "Buff oder Debuff?";
    NEEDTOKNOW.BARMENU_HELPFUL = "Buff";
    NEEDTOKNOW.BARMENU_HARMFUL = "Debuff";
    NEEDTOKNOW.BARMENU_ONLYMINE = "Nur Anzeigen wenn es selbst gezaubert wurde";
    NEEDTOKNOW.BARMENU_BARCOLOR = "Farbe des Balken";
    NEEDTOKNOW.BARMENU_CLEARSETTINGS = "Einstellungen löschen";
    NEEDTOKNOW.UIPANEL_SUBTEXT1 = "Diese Einstellungen ändern die Anzahl und die Gruppierung der Balken.";
    NEEDTOKNOW.UIPANEL_SUBTEXT2 = "Die Darstellung funktioniert auch bei festgesetzen Balken. Wenn sie freigesetzt sind, können die Gruppierungen verschoben und deren Größe verändert werden. Ein Rechtsklick auf einen Balken zeigt weitere Einstellungsmöglichkeiten an. '/needtoknow' oder '/ntk' kann ebenfalls zum Festsetzen und Freistellen verwendet werden.";
    NEEDTOKNOW.UIPANEL_BARGROUP = "Gruppe ";
    NEEDTOKNOW.UIPANEL_NUMBERBARS = "Anzahl der Balken";
    NEEDTOKNOW.UIPANEL_FIXEDDURATION = "Max bar duration";
    NEEDTOKNOW.UIPANEL_BARTEXTURE = "Balkentextur";
    NEEDTOKNOW.UIPANEL_BACKGROUNDCOLOR = "Background color";
    NEEDTOKNOW.UIPANEL_BARSPACING = "Bar spacing";
    NEEDTOKNOW.UIPANEL_BARPADDING = "Bar padding";
    NEEDTOKNOW.UIPANEL_LOCK = "AddOn sperren";
    NEEDTOKNOW.UIPANEL_UNLOCK = "AddOn entsperren";
    NEEDTOKNOW.UIPANEL_TOOLTIP_ENABLEGROUP = "Diese Gruppierung aktivieren und anzeigen";
    NEEDTOKNOW.UIPANEL_TOOLTIP_FIXEDDURATION = "Set the maximum length of bars for this group (in seconds).  Leave empty to set dynamically per bar.";
    NEEDTOKNOW.UIPANEL_TOOLTIP_BARTEXTURE = "Die Textur für die Balken auswählen";
    NEEDTOKNOW.CMD_RESET = "reset";
 
elseif ( GetLocale() == "koKR" ) then
    -- by metalchoir
    NEEDTOKNOW.BAR_TOOLTIP1 = "NeedToKnow";
    NEEDTOKNOW.BAR_TOOLTIP2 = "우?�릭: 메뉴 불러오기\n세부옵션? �기본 ?�터페?�스 설정?�서 가능\n/ntk 명령어로 잠근 후? �애드온 사용가능";
    NEEDTOKNOW.RESIZE_TOOLTIP = "드래그: ?�기 변경";
    NEEDTOKNOW.BARMENU_ENABLE = "바 사용";
    NEEDTOKNOW.BARMENU_CHOOSENAME = "입력: 주문 ?�름";
    NEEDTOKNOW.CHOOSENAME_DIALOG = "바? �표시할 버프 ?�는 디버프? �?�름? �입력하세요"
    NEEDTOKNOW.BARMENU_CHOOSEUNIT = "유닛 선?";
    NEEDTOKNOW.BARMENU_PLAYER = "�본?";
    NEEDTOKNOW.BARMENU_TARGET = "�대?";
    NEEDTOKNOW.BARMENU_FOCUS = "�주시대?";
    NEEDTOKNOW.BARMENU_PET = "�펫";
    NEEDTOKNOW.BARMENU_VEHICLE = "탈것";
    NEEDTOKNOW.BARMENU_TARGETTARGET = "대?�? �대?";
    NEEDTOKNOW.BARMENU_BUFFORDEBUFF = "�선?: �버프/디버프";
    NEEDTOKNOW.BARMENU_SPELLID = "사용 주문 ID";
    NEEDTOKNOW.BARMENU_HELPFUL = "버프";
    NEEDTOKNOW.BARMENU_HARMFUL = "디버프";
    NEEDTOKNOW.BARMENU_ONLYMINE = "?�신? �시전한 것만 보여줌";
    NEEDTOKNOW.BARMENU_BARCOLOR = "바 색?";
    NEEDTOKNOW.BARMENU_CLEARSETTINGS = "�설정 초기화";
    NEEDTOKNOW.UIPANEL_SUBTEXT1 = "아래? �옵션?�서 타?�머? �그룹과 ? �그룹별 바 갯수를 설정하실 수 있습니다.";
    NEEDTOKNOW.UIPANEL_SUBTEXT2 = "바는 잠근 후? �작?�합니다. 풀렸? �때 바? �?�?�과 ?�기 조절, 그리고 ?�?�? �바? �우?�릭? �함으로? �설정? �하실 수 있습니다. '/needtoknow' ?�는 '/ntk' 명령어를 통해서? �잠금/품 전환? �가능합니다.";
    NEEDTOKNOW.UIPANEL_BARGROUP = "그룹 ";
    NEEDTOKNOW.UIPANEL_NUMBERBARS = "바 갯수";
    NEEDTOKNOW.UIPANEL_FIXEDDURATION = "Max bar duration";
    NEEDTOKNOW.UIPANEL_BARTEXTURE = "바 ?�스처";
    NEEDTOKNOW.UIPANEL_BARSPACING = "바 간격";
    NEEDTOKNOW.UIPANEL_BARPADDING = "배경 ?�기";
    NEEDTOKNOW.UIPANEL_BACKGROUNDCOLOR = "배경 색?";
    NEEDTOKNOW.UIPANEL_LOCK = "�잠금";
    NEEDTOKNOW.UIPANEL_UNLOCK = "풀림";
    NEEDTOKNOW.UIPANEL_TOOLTIP_ENABLEGROUP = "? �그룹? �바를 표시/사용합니다.";
    NEEDTOKNOW.UIPANEL_TOOLTIP_FIXEDDURATION = "Set the maximum length of bars for this group (in seconds).  Leave empty to set dynamically per bar.";
    NEEDTOKNOW.UIPANEL_TOOLTIP_BARTEXTURE = "바 ?�스처를 선?�하세요";
    NEEDTOKNOW.CMD_RESET = "초기화";
 
elseif ( GetLocale() == "ruRU" ) then
    -- by Vlakarados
    NEEDTOKNOW.BAR_TOOLTIP1 = "NeedToKnow";
    NEEDTOKNOW.BAR_TOOLTIP2 = "Клик правой кнопкой мыши по полосе для настройки. Больше настроек в Интерфейс / Модификации / NeedToKnow меню. Ввести /needtoknow или /ntk для блокировки и включения.";
    NEEDTOKNOW.RESIZE_TOOLTIP = "Кликнуть и тащить для изменения размера";
    NEEDTOKNOW.BARMENU_ENABLE = "Включить полосу";
    NEEDTOKNOW.BARMENU_CHOOSENAME = "Выбрать бафф/дебафф для слежения";
    NEEDTOKNOW.CHOOSENAME_DIALOG = "Введите название баффа/дебаффа для слежения"
    NEEDTOKNOW.BARMENU_CHOOSEUNIT = "Юнит слежения";
    NEEDTOKNOW.BARMENU_PLAYER = "Игрок";
    NEEDTOKNOW.BARMENU_TARGET = "Цель";
    NEEDTOKNOW.BARMENU_FOCUS = "Фокус";
    NEEDTOKNOW.BARMENU_PET = "Питомец";
    NEEDTOKNOW.BARMENU_VEHICLE = "Средство передвижения";
    NEEDTOKNOW.BARMENU_TARGETTARGET = "Цель цели";
    NEEDTOKNOW.BARMENU_BUFFORDEBUFF = "Бафф или дебафф?";
    NEEDTOKNOW.BARMENU_SPELLID = "Используйте удостоверение личности произношения по буквам";
    NEEDTOKNOW.BARMENU_HELPFUL = "Бафф";
    NEEDTOKNOW.BARMENU_HARMFUL = "Дебафф";
    NEEDTOKNOW.BARMENU_ONLYMINE = "Показывать только наложенные мной";
    NEEDTOKNOW.BARMENU_BARCOLOR = "Цвет полосы";
    NEEDTOKNOW.BARMENU_CLEARSETTINGS = "Очистить настройки";
    NEEDTOKNOW.UIPANEL_SUBTEXT1 = "Эти настройки позволяют настроить бафф/дебафф полосы слежения.";
    NEEDTOKNOW.UIPANEL_SUBTEXT2 = "Полосы работают только когда заблокированы группы. Можно менять размер и перемещать группы полос и кликнуть правой кнопкой мыши для изменения индивидуальных настроек. Ввести '/needtoknow' или '/ntk' to блокировки/разблокировки.";
    NEEDTOKNOW.UIPANEL_BARGROUP = "Группа ";
    NEEDTOKNOW.UIPANEL_NUMBERBARS = "Количество полос";
    NEEDTOKNOW.UIPANEL_FIXEDDURATION = "Максимальное время на полосе";
    NEEDTOKNOW.UIPANEL_BARTEXTURE = "Текcтура полоc";
    NEEDTOKNOW.UIPANEL_BARSPACING = "Промежуток полоc";
    NEEDTOKNOW.UIPANEL_BARPADDING = "Уплотнение полоc";
    NEEDTOKNOW.UIPANEL_BACKGROUNDCOLOR = "Цвет фона";
    NEEDTOKNOW.UIPANEL_LOCK = "Заблокировать";
    NEEDTOKNOW.UIPANEL_UNLOCK = "Разблокировать";
    NEEDTOKNOW.UIPANEL_TOOLTIP_ENABLEGROUP = "Показать и включить эту группу полос";
    NEEDTOKNOW.UIPANEL_TOOLTIP_FIXEDDURATION = "Указать максимальное время пробега полосы в секундах. Оставить пустым для динамического времени для каждой полойы (полное время = длительность баффа/дебаффа).";
    NEEDTOKNOW.UIPANEL_TOOLTIP_BARTEXTURE = "Выбрать текстуру для полос.";
    NEEDTOKNOW.CMD_RESET = "Сброс";

elseif ( GetLocale() == "zhCN" ) then
	-- by wowui.cn
    NEEDTOKNOW.BAR_TOOLTIP1 = "NeedToKnow";
    NEEDTOKNOW.BAR_TOOLTIP2 = "右键点击计时条配置. 更多的选项在暴雪界面选项菜单里. 输入 /needtoknow 来锁定并启用.";
    NEEDTOKNOW.RESIZE_TOOLTIP = "点击和拖动来修改计时条尺寸";
    NEEDTOKNOW.BARMENU_ENABLE = "启用计时条";
    NEEDTOKNOW.BARMENU_CHOOSENAME = "选择需要计时的Buff/Debuff";
    NEEDTOKNOW.CHOOSENAME_DIALOG = "输入在这个计时条内计时的Buff或Debuff的精确名字"
    NEEDTOKNOW.BARMENU_CHOOSEUNIT = "需要监视的单位";
    NEEDTOKNOW.BARMENU_PLAYER = "玩家";
    NEEDTOKNOW.BARMENU_TARGET = "目标";
    NEEDTOKNOW.BARMENU_FOCUS = "焦点";
    NEEDTOKNOW.BARMENU_PET = "宠物";
    NEEDTOKNOW.BARMENU_VEHICLE = "载具";
    NEEDTOKNOW.BARMENU_TARGETTARGET = "目标的目标";
    NEEDTOKNOW.BARMENU_BUFFORDEBUFF = "Buff还是Debuff?";
    NEEDTOKNOW.BARMENU_BUFF = "Buff";
    NEEDTOKNOW.BARMENU_DEBUFF = "Debuff";
    NEEDTOKNOW.BARMENU_ONLYMINE = "仅显示自身施放的";
    NEEDTOKNOW.BARMENU_BARCOLOR = "计时条颜色";
    NEEDTOKNOW.BARMENU_CLEARSETTINGS = "清除设置";
    NEEDTOKNOW.UIPANEL_SUBTEXT1 = "这些选项允许你自定义Buff/Debuff计时条.";
    NEEDTOKNOW.UIPANEL_SUBTEXT2 = "计时条锁定后才能正常工作. 当解锁时, 你可以移动或修改计时条分组的大小, 右键点击单独的计时条可以进行更多的设置. 你也可以输入 '/needtoknow' 或 '/ntk' 来锁定/解锁.";
    NEEDTOKNOW.UIPANEL_BARGROUP = "分组 ";
    NEEDTOKNOW.UIPANEL_NUMBERBARS = "计时条数量";
    NEEDTOKNOW.UIPANEL_FIXEDDURATION = "计时条最大持续时间";
    NEEDTOKNOW.UIPANEL_BARTEXTURE = "计时条材质";
    NEEDTOKNOW.UIPANEL_BARSPACING = "计时条空距";
    NEEDTOKNOW.UIPANEL_BARPADDING = "计时条间距";
    NEEDTOKNOW.UIPANEL_BACKGROUNDCOLOR = "背景颜色";
    NEEDTOKNOW.UIPANEL_LOCK = "锁定";
    NEEDTOKNOW.UIPANEL_UNLOCK = "解锁";
    NEEDTOKNOW.UIPANEL_TOOLTIP_ENABLEGROUP = "显示并启用这个分组的计时条";
    NEEDTOKNOW.UIPANEL_TOOLTIP_FIXEDDURATION = "设置这个分组计时条的最大长度 (按秒数).  留空为每个计时条设置不同的数值.";
    NEEDTOKNOW.UIPANEL_TOOLTIP_BARTEXTURE = "选择计时条的材质图像.";
    NEEDTOKNOW.CMD_RESET = "重置";

elseif ( GetLocale() == "zhTW" ) then
	-- by wowui.cn
    NEEDTOKNOW.BAR_TOOLTIP1 = "NeedToKnow";
    NEEDTOKNOW.BAR_TOOLTIP2 = "右鍵點擊計時條配置. 更多的選項在暴雪介面選項菜單裏. 輸入 /needtoknow 來鎖定並啟用.";
    NEEDTOKNOW.RESIZE_TOOLTIP = "點擊和拖動來修改計時條尺寸";
    NEEDTOKNOW.BARMENU_ENABLE = "啟用計時條";
    NEEDTOKNOW.BARMENU_CHOOSENAME = "選擇需要計時的Buff/Debuff";
    NEEDTOKNOW.CHOOSENAME_DIALOG = "輸入在這個計時條內計時的Buff或Debuff的精確名字"
    NEEDTOKNOW.BARMENU_CHOOSEUNIT = "需要監視的單位";
    NEEDTOKNOW.BARMENU_PLAYER = "玩家";
    NEEDTOKNOW.BARMENU_TARGET = "目標";
    NEEDTOKNOW.BARMENU_FOCUS = "焦點";
    NEEDTOKNOW.BARMENU_PET = "寵物";
    NEEDTOKNOW.BARMENU_VEHICLE = "載具";
    NEEDTOKNOW.BARMENU_TARGETTARGET = "目標的目標";
    NEEDTOKNOW.BARMENU_BUFFORDEBUFF = "Buff還是Debuff?";
    NEEDTOKNOW.BARMENU_BUFF = "Buff";
    NEEDTOKNOW.BARMENU_DEBUFF = "Debuff";
    NEEDTOKNOW.BARMENU_ONLYMINE = "僅顯示自身施放的";
    NEEDTOKNOW.BARMENU_BARCOLOR = "計時條顏色";
    NEEDTOKNOW.BARMENU_CLEARSETTINGS = "清除設置";
    NEEDTOKNOW.UIPANEL_SUBTEXT1 = "這些選項允許妳自定義Buff/Debuff計時條.";
    NEEDTOKNOW.UIPANEL_SUBTEXT2 = "計時條鎖定後才能正常工作. 當解鎖時, 妳可以移動或修改計時條分組的大小, 右鍵點擊單獨的計時條可以進行更多的設置. 妳也可以輸入 '/needtoknow' 或 '/ntk' 來鎖定/解鎖.";
    NEEDTOKNOW.UIPANEL_BARGROUP = "分組 ";
    NEEDTOKNOW.UIPANEL_NUMBERBARS = "計時條數量";
    NEEDTOKNOW.UIPANEL_FIXEDDURATION = "計時條最大持續時間";
    NEEDTOKNOW.UIPANEL_BARTEXTURE = "計時條材質";
    NEEDTOKNOW.UIPANEL_BARSPACING = "計時條空距";
    NEEDTOKNOW.UIPANEL_BARPADDING = "計時條間距";
    NEEDTOKNOW.UIPANEL_BACKGROUNDCOLOR = "背景顏色";
    NEEDTOKNOW.UIPANEL_LOCK = "鎖定";
    NEEDTOKNOW.UIPANEL_UNLOCK = "解鎖";
    NEEDTOKNOW.UIPANEL_TOOLTIP_ENABLEGROUP = "顯示並啟用這個分組的計時條";
    NEEDTOKNOW.UIPANEL_TOOLTIP_FIXEDDURATION = "設置這個分組計時條的最大長度 (按秒數).  留空為每個計時條設置不同的數值.";
    NEEDTOKNOW.UIPANEL_TOOLTIP_BARTEXTURE = "選擇計時條的材質圖像.";
    NEEDTOKNOW.CMD_RESET = "重置";

end

