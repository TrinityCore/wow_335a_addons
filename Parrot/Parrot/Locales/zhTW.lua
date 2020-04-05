
local L = LibStub("AceLocale-3.0"):NewLocale("Parrot", "zhTW")
if not L then return end

L["Control game options"] = "控制游戲選項"
L["Display realm in player names (in battlegrounds)"] = "顯示伺服器名稱（在戰場）"
L["Floating Combat Text of awesomeness. Caw. It'll eat your crackers."] = "絕妙的戰鬥記錄指示器。"
L["Game damage"] = "預設傷害"
L["Game healing"] = "預設治療"
L["Game options"] = "游戲選項"
L["General"] = "一般"
L["General settings"] = "一般設定"
L["Inherit"] = "繼承"
L["Load config"] = "加載配置"
L["Load configuration options"] = "加載配置選項"
L["Parrot"] = "Parrot"
L["Parrot Configuration"] = "Parrot 配置"
L["Show guardian events"] = "顯示守衛事件"
L["Show realm name"] = "顯示伺服器名稱"
L["Whether events involving your guardian(s) (totems, ...) should be displayed"] = "顯示所有與守衛（如：圖騰，…）相關的事件"
L[ [=[Whether Parrot should control the default interface's options below.
These settings always override manual changes to the default interface options.]=] ] = [=[Parrot 是否控制下面的默認介面選項。
這些設定總是覆蓋默認介面選項的手動更改。]=]
L["Whether to show damage over the enemy's heads."] = "是否在敵人頭上顯示傷害值。"
L["Whether to show healing over the enemy's heads."] = "是否在敵人頭上顯示治療量。"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_CombatEvents", "zhTW")
L["Abbreviate"] = "縮寫"
L["Add a new filter."] = "添加一個新過濾。"
L["Add a new throttle."] = "添加一個新流量控制"
L["Always hide skill names even when present in the tag"] = "在當前標籤總是隱藏技能名稱"
L["Always hide unit names even when present in the tag"] = "在當前標籤總是隱藏單位名稱"
L["Amount"] = "數值"
L[" ([Amount] absorbed)"] = "（吸收 [Amount]）"
L[" ([Amount] blocked)"] = "（格擋 [Amount]）"
L[" ([Amount] overheal)"] = "（過量治療 [Amount]）"
L[" ([Amount] overkill)"] = "（傷害溢出 [Amount]）"
L[" ([Amount] resisted)"] = "（抵抗 [Amount]）"
L[" ([Amount] vulnerable)"] = "（易傷 [Amount]）"
L["Arcane"] = "秘法"
L["Change event settings"] = "改變事件設定"
L["Classcolor names"] = "職業顏色名稱"
L["Color"] = "顏色"
L["Color by class"] = "職業著色"
L["Color names in the texts with the color of the class"] = "名稱文字以職業顏色著色"
L["Color of the text for the current event."] = "目前事件的文字顏色。"
L["Color unit names by class"] = "單位名稱使用職業顏色"
L["Critical hits/heals"] = "暴擊傷害/治療"
L["Crushing blows"] = "碾壓"
L["Custom font"] = "自訂字型"
L["Damage types"] = "傷害類型"
L["Disable CombatEvents when in a 10-man raid instance"] = "當10人團隊時禁用戰鬥事件"
L["Disable CombatEvents when in a 25-man raid instance"] = "當25人團隊時禁用戰鬥事件"
L["Disable in 10-man raids"] = "當10人副本時禁用"
L["Disable in 25-man raids"] = "當25人副本時禁用"
L["Do not shorten spell names."] = "不對法術名稱進行縮寫。"
L["Do not show heal events when 100% of the amount is overheal"] = "當100%的過量治療時不顯示治療事件"
L["Enabled"] = "啟用"
L["Enable the current event."] = "啟用目前事件。"
L["Enable to show crits in the sticky style."] = "允許將暴擊用粘附的風格顯示。"
L["Event modifiers"] = "事件修飾"
L["Events"] = "事件"
L["Filter incoming spells"] = "過濾承受法術"
L["Filter outgoing spells"] = "過濾輸出法術"
L["Filters"] = "過濾"
L["Filters that are applied to a single spell"] = "過濾單一法術"
L["Filters to be checked for a minimum amount of damage/healing/etc before showing."] = "過濾顯示小於特定值的傷害/治療/其他訊息。"
L["Filter when amount is lower than this value (leave blank to filter everything)"] = "小於此數值時過濾（留空過濾所有）"
L["Fire"] = "火焰"
L["Font face"] = "字型"
L["Font outline"] = "字型外框"
L["Font size"] = "字型大小"
L["Frost"] = "冰霜"
L["Frostfire"] = "霜火箭"
L["Froststorm"] = "霜暴之息"
L["Gift of the Wild => Gift of t..."] = "真言術: 韌 => 真言術...。"
L["Gift of the Wild => GotW."] = "真言術: 韌 => 韌。"
L["Glancing hits"] = "擦過"
L["Hide events used in triggers"] = "用於隱藏事件觸發"
L["Hide full overheals"] = "隱藏全部過量治療"
L["Hide realm"] = "隱藏伺服器名"
L["Hide realm in player names (in battlegrounds)"] = "隱藏玩家名稱伺服器名（在戰場）"
L["Hides combat events when they were used in triggers"] = "用於隱藏戰鬥事件觸發"
L["Hide skill names"] = "隱藏技能名稱"
L["Hide unit names"] = "隱藏單位名稱"
L["Holy"] = "神聖"
L["How or whether to shorten spell names."] = "是否或如何縮寫法術名稱。"
L["Incoming"] = "承受"
L["Incoming events are events which a mob or another player does to you."] = "承受事件是那些怪物或玩家對你造成的事件。"
L["Inherit"] = "繼承"
L["Inherit font size"] = "繼承字型大小"
L["Interval for collecting data"] = "間歇性收集數據"
L["Length"] = "長度"
L["Name or ID of the spell"] = "法術名稱或 ID"
L["Nature"] = "自然"
L["New filter"] = "新過濾"
L["New throttle"] = "新流量控制"
L["None"] = "無"
L["Notification"] = "提示"
L["Notification events are available to notify you of certain actions."] = "提示事件用來提醒你某個特定動作的觸發。"
L["Options for damage types."] = "傷害類型的選項。"
L["Options for event modifiers."] = "事件修飾的選項。"
L["Outgoing"] = "輸出"
L["Outgoing events are events which you do to a mob or another player."] = "輸出事件是那些你對怪物或玩家造成的事件。"
L["Overheals"] = "過量治療"
L["Overkills"] = "傷害溢出"
L["Partial absorbs"] = "部分吸收"
L["Partial blocks"] = "部分格擋"
L["Partial resists"] = "部分抵抗"
L["Physical"] = "物理"
L["Remove"] = "移除"
L["Remove filter"] = "移除過濾"
L["Remove throttle"] = "移除流量控制"
L["Scoll area where all events will be shown"] = "在滾動區域顯示所有事件"
L["Scroll area"] = "滾動區域"
L["Shadow"] = "暗影"
L["Shadowstorm"] = "暗影風暴"
L["Shorten spell names"] = "縮寫法術名稱"
L["Short Texts"] = "縮寫文本"
L["Show guardian events"] = "顯示守衛事件"
L["Sound"] = "音效"
L["Spell"] = "法術"
L["Spell filters"] = "法術過濾"
L["Spell throttles"] = "法術流量控制"
L["Sticky"] = "粘附"
L["Sticky crits"] = "暴擊粘附"
L["Style"] = "風格"
L["Tag"] = "標簽"
L["<Tag>"] = "<標簽>"
L["Tag to show for the current event."] = "標識顯示目前事件。"
L["Text"] = "文字"
L["<Text>"] = "<文字>"
L["[Text] (crit)"] = "[Text]（爆擊）"
L["[Text] (crushing)"] = "[Text]（碾壓）"
L["[Text] (glancing)"] = "[Text]（擦過）"
L["Text options"] = "文本選項"
L["The amount of damage absorbed."] = "被吸收的傷害量。"
L["The amount of damage blocked."] = "被格擋的傷害量。"
L["The amount of damage resisted."] = "被抵抗的傷害量。"
L["The amount of overhealing."] = "過量治療量。"
L["The amount of overkill."] = "傷害溢出量。"
L["The amount of vulnerability bonus."] = "易傷加成量。"
L["The length at which to shorten spell names."] = "需要進行法術名稱縮寫的長度。"
L["The normal text."] = "一般文字。"
L["Thick"] = "粗"
L["Thin"] = "細"
L["Throttle events"] = "事件節流"
L["Throttles that are applied to a single spell"] = "適用於一個單一法術的流量控制"
L["Throttle time"] = "流量控制時間"
L["Truncate"] = "截短"
L["Uncategorized"] = "未分類"
L["Use short throttle-texts (like \"2++\" instead of \"2 crits\")"] = "使用縮寫文本（例如“2++”代表“2致命一擊”）"
L["Vulnerability bonuses"] = "易傷加成"
L[ [=[What amount to filter out. Any amount below this will be filtered.
Note: a value of 0 will mean no filtering takes place.]=] ] = [=[需要過濾的值，低於該值將被過濾
注意：若過濾值為0則表示不進行過濾。]=]
L["What color this damage type takes on."] = "此傷害類型採用何種顏色。"
L["What color this event modifier takes on."] = "事件修飾採用何種顏色。"
L["What sound to play when the current event occurs."] = "目前事件發生時播放哪個音效。"
L["What text this event modifier shows."] = "事件修飾顯示什麼文字。"
L[ [=[What timespan to merge events within.
Note: a time of 0s means no throttling will occur.]=] ] = [=[合併事件的時間間隔（單位秒）
注意：0表示不進行節流顯示。]=]
L["Whether all events in this category are enabled."] = "是否所有事件在這個類別中啟用。"
L["Whether events involving your guardian(s) (totems, ...) should be displayed"] = "顯示所有與守衛（如：圖騰，…）相關的事件"
L["Whether the current event should be classified as \"Sticky\""] = "是否將目前事件以\"粘附\"方式顯示"
L["Whether this module is enabled"] = "是否啟用此模組"
L["Whether to color damage types or not."] = "是否為傷害類型上色。"
L["Whether to color event modifiers or not."] = "是否為事件修飾上色。"
L["Whether to enable showing this event modifier."] = "是否啟用事件修飾顯示。"
L["Whether to merge mass events into single instances instead of excessive spam."] = "是否將大量同類事件整合為一個單一事件而避免訊息氾濫。"
L["Which scroll area to use."] = "啟用哪個滾動區域。"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Display", "zhTW")
L["Enable icons"] = "啟用圖示"
L["How opaque/transparent icons should be."] = "圖示顯示的透明度。"
L["How opaque/transparent the text should be."] = "文字顯示的透明度。"
L["Icon transparency"] = "圖示透明度"
L["Master font settings"] = "主字型設置"
L["None"] = "無"
L["Normal font"] = "正常字型"
L["Normal font face."] = "正常字型。"
L["Normal font size"] = "正常字型大小"
L["Normal outline"] = "正常外框"
L["Set whether icons should be enabled or disabled altogether."] = "設置是否圖示要被一起顯示。"
L["Sticky font"] = "粘附字型"
L["Sticky font face."] = "粘附字型。"
L["Sticky font size"] = "粘附字型大小"
L["Sticky outline"] = "粘附外框"
L["Text transparency"] = "文字透明度"
L["Thick"] = "粗"
L["Thin"] = "細"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_ScrollAreas", "zhTW")
L["Add a new scroll area."] = "增加一個新的滾動區域。"
L["Animation style"] = "動畫效果"
L["Animation style for normal texts."] = "正常文字的動畫效果。"
L["Animation style for sticky texts."] = "粘附文字的動畫效果。"
L["Are you sure?"] = "是否確定？"
L["Center of screen"] = "螢幕中央"
L["Click and drag to the position you want."] = "拖動到你希望的位置。"
L["Configuration mode"] = "配置模式"
L["Create"] = "建立"
L["Custom font"] = "自訂字型"
L["Direction"] = "方向"
L["Direction for normal texts."] = "正常文字的方向。"
L["Direction for sticky texts."] = "粘附文字的方向。"
L["Disable"] = "停用"
L["Edge of screen"] = "螢幕邊緣"
L["Enter configuration mode, allowing you to move around the scroll areas and see them in action."] = "進入配置模式，讓你可以移動滾動區域並觀看效果。"
L["How fast the text scrolls by."] = "設置以多快的速度滾動。"
L["How large of an area to scroll."] = "滾動區域的大小。"
L["Icon side"] = "圖示位置"
L["Incoming"] = "承受"
L["Inherit"] = "繼承"
L["Left"] = "左"
L["Name"] = "名稱"
L["<Name>"] = "<名稱>"
L["Name of the scroll area."] = "滾動區域的名稱。"
L["New scroll area"] = "新增滾動區域"
L["None"] = "無"
L["Normal"] = "正常"
L["Normal font face"] = "正常字型"
L["Normal font outline"] = "正常字型外框"
L["Normal font size"] = "正常字型大小"
L["Normal inherit font size"] = "繼承正常字型大小"
L["Notification"] = "提示"
L["Options for this scroll area."] = "本滾動區域的選項。"
L["Options regarding scroll areas."] = "滾動區域的選項。"
L["Outgoing"] = "輸出"
L["Position: %d, %d"] = "位置：%d，%d"
L["Position: horizontal"] = "水平位置"
L["Position: vertical"] = "垂直位置"
L["Remove"] = "移除"
L["Remove this scroll area."] = "移除本滾動區域。"
L["Right"] = "右"
L["Scroll areas"] = "滾動區域"
L["Scroll area: %s"] = "滾動區域：%s"
L["Scrolling speed"] = "滾動速度"
L["Seconds for the text to complete the whole cycle, i.e. larger numbers means slower."] = "完成整個滾動循環的秒數，數字越大滾動越慢。"
L["Send"] = "發送"
L["Send a normal test message."] = "發送一條正常測試訊息。"
L["Send a sticky test message."] = "發送一條粘附測試訊息。"
L["Send a test message through this scroll area."] = "發送一條測試訊息到本滾動區域。"
L["Set the icon side for this scroll area or whether to disable icons entirely."] = "設置本滾動區域的圖示位置或是否完全停用圖示。"
L["Size"] = "大小"
L["Sticky"] = "粘附"
L["Sticky font face"] = "粘附字型"
L["Sticky font outline"] = "粘附字型外框"
L["Sticky font size"] = "粘附字型大小"
L["Sticky inherit font size"] = "繼承粘附字型大小"
L["Test"] = "測試"
L["The position of the box across the screen"] = "在螢幕上的水平位置"
L["The position of the box up-and-down the screen"] = "在螢幕上的垂直位置"
L["Thick"] = "粗"
L["Thin"] = "細"
L["Which animation style to use."] = "採用何種動畫效果。"
L["Which direction the animations should follow."] = "滾動動畫的方向。"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Suppressions", "zhTW")
L["Add a new suppression."] = "增加一個新的覆蓋事件。"
L["<Any text> or <Lua search expression>"] = "<任意文字>或<Lua 搜索表達式>"
L["Are you sure?"] = "是否確定？"
L["Create"] = "建立"
L["Edit"] = "編輯"
L["Edit search string"] = "編輯搜索字串"
L["List of strings that will be squelched if found."] = "列出的字串若找到則被覆蓋。"
L["Lua search expression"] = "Lua 搜索表達式"
L["New suppression"] = "新增覆蓋事件"
L["Remove"] = "移除"
L["Remove suppression"] = "移除覆蓋事件"
L["Suppressions"] = "覆蓋事件"
L["Whether the search string is a lua search expression or not."] = "是否搜索字串是一個 Lua 搜索表達式。"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Triggers", "zhTW")
L["Add a new primary condition"] = "增加一個新的主條件"
L["Add a new secondary condition"] = "增加一個新的次條件"
L["Are you sure?"] = "是否確定？"
L["Check every XX seconds"] = "每過 XX 秒檢查一次"
L["Classes"] = "職業"
L["Classes affected by this trigger."] = "本觸發條件所影響的職業。"
L["Cleanup Triggers"] = "刪除觸發條件"
L["Color"] = "顏色"
L["Color in which to flash"] = "閃螢顏色"
L["Color of the text for this trigger."] = "這個觸發條件的顯示文字顏色。"
L["Create"] = "建立"
L["Create a new trigger"] = "建立一個新的觸發條件"
L["Custom font"] = "自訂字型"
L["Delete all Triggers that belong to a different locale"] = "刪除所有不同本地化的觸發條件"
L["Enabled"] = "啟用"
L["Flash screen in specified color"] = "指定螢幕閃爍顏色"
L["Font face"] = "字型"
L["Font outline"] = "字型外框"
L["Font size"] = "字型大小"
L["Free %s!"] = "額外%s！"
L["Icon"] = "圖示"
L["Inherit"] = "繼承"
L["Inherit font size"] = "繼承字型大小"
L["Low Health!"] = "低血量！"
L["Low Mana!"] = "低法力！"
L["Low Pet Health!"] = "寵物低血量！"
L["New condition"] = "新增條件"
L["New trigger"] = "新增觸發條件"
L["None"] = "無"
L["Output"] = "輸出"
L["Primary conditions"] = "主條件"
L["Remove"] = "移除"
L["Remove a primary condition"] = "移除一個主條件"
L["Remove a secondary condition"] = "移除一個次條件"
L["Remove condition"] = "移除條件"
L["Remove this trigger completely."] = "徹底移除這個觸發條件。"
L["Remove trigger"] = "移除觸發條件"
L["%s!"] = "%s！"
L["Scroll area"] = "滾動區域"
L["Secondary conditions"] = "次條件"
L["Sound"] = "音效"
L["<Spell name> or <Item name> or <Path> or <SpellId>"] = "<法術名稱>或<物品名稱>或<路徑>或<法術 ID>"
L["Sticky"] = "粘附"
L["Test"] = "測試"
L["Test how the trigger will look and act."] = "測試觸發條件的效果。"
L["<Text to show>"] = "<顯示文字>"
L["The icon that is shown"] = "想要顯示的圖示"
L["The text that is shown"] = "想要顯示的文字"
L["Thick"] = "粗"
L["Thin"] = "細"
L["Trigger cooldown"] = "觸發冷卻"
L["Triggers"] = "觸發條件"
L["What sound to play when the trigger is shown."] = "觸發條件顯示時播放何種音效。"
L["When all of these conditions apply, the trigger will be shown."] = "當所有這些條件被滿足時，觸發條件將被顯示。"
L["When any of these conditions apply, the secondary conditions are checked."] = "當這些條件中的任一個滿足時，檢查次條件。"
L["Whether the trigger is enabled or not."] = "是否啟用這個觸發條件。"
L["Whether to show this trigger as a sticky."] = "是否將本觸發條件粘附顯示。"
L["Which scroll area to output to."] = "選擇輸出的滾動區域。"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_TriggerConditions", "zhTW")


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_AnimationStyles", "zhTW")
L["Action"] = "動作型"
L["Action Sticky"] = "動態粘附"
L["Alternating"] = "交錯"
L["Angled"] = "角度型"
L["Down, alternating"] = "向下，交錯"
L["Down, center-aligned"] = "向下，中對齊"
L["Down, clockwise"] = "向下，順時針"
L["Down, counter-clockwise"] = "向下，逆時針"
L["Down, left"] = "向下，向左"
L["Down, left-aligned"] = "向下，左對齊"
L["Down, right"] = "向下，向右"
L["Down, right-aligned"] = "向下，右對齊"
L["Horizontal"] = "橫移型"
L["Left"] = "左"
L["Left, clockwise"] = "向左，順時針"
L["Left, counter-clockwise"] = "向左，逆時針"
L["Parabola"] = "拋物線"
L["Pow"] = "震動型"
L["Rainbow"] = "彩虹型"
L["Right"] = "右"
L["Right, clockwise"] = "向右，順時針"
L["Right, counter-clockwise"] = "向右，逆時針"
L["Semicircle"] = "半圓型"
L["Sprinkler"] = "灑水型"
L["Static"] = "靜態型"
L["Straight"] = "直線型"
L["Up, alternating"] = "向上，交錯"
L["Up, center-aligned"] = "向上，中對齊"
L["Up, clockwise"] = "向上，順時針"
L["Up, counter-clockwise"] = "向上，逆時針"
L["Up, left"] = "向上，向左"
L["Up, left-aligned"] = "向上，左對齊"
L["Up, right"] = "向上，向右"
L["Up, right-aligned"] = "向上，右對齊"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Auras", "zhTW")
L["Amount"] = "數值"
L["Amount of stacks of the aura"] = "光環疊加層數"
L["Any"] = "任意"
L["Aura active"] = "光環啟動"
L["Aura fade"] = "光環消退"
L["Aura gain"] = "獲得光環"
L["Aura inactive"] = "光環未啟動"
L["Auras"] = "光環"
L["Aura stack gain"] = "獲得光環疊加"
L["Aura type"] = "光環類型"
L["Both"] = "双"
L["Buff"] = "增益"
L["Buff active"] = "增益啟動"
L["Buff fades"] = "增益消退"
L["Buff gains"] = "獲得增益"
L["Buff inactive"] = "增益未啟動"
L["<Buff name>"] = "<增益名稱>"
L["Buff name"] = "增益名稱"
L["<Buff name or spell id>"] = "<增益名稱或法術 ID>"
L["Buff name or spell id"] = "增益名稱或法術 ID"
L["<Buff name or spell id>,<Number of stacks>"] = "<增益名稱或法术 ID>,<疊加層數>"
L["Buff stack gains"] = "獲得增益疊加"
L["Debuff"] = "減益"
L["Debuff active"] = "減益啟動"
L["Debuff fades"] = "減益消退"
L["Debuff gains"] = "受到減益"
L["Debuff inactive"] = "減益未啟動"
L["<Debuff name>"] = "<減益名稱>"
L["<Debuff name or spell id>"] = "<減益名稱或法術 ID>"
L["Debuff stack gains"] = "獲得減益疊加"
L["Enemy buff fades"] = "敵對增益消退"
L["Enemy buff gains"] = "敵對獲得增益"
L["Enemy debuff fades"] = "敵對減益消退"
L["Enemy debuff gains"] = "敵對獲取減益"
L["Focus buff fade"] = "焦點目標增益消退"
L["Focus buff gain"] = "焦點目標獲得增益"
L["Focus debuff fade"] = "焦點目標減益消退"
L["Focus debuff gain"] = "焦點目標獲得減益"
L["Item buff active"] = "物品增益啟動"
L["Item buff fade"] = "物品增益消退"
L["Item buff fades"] = "物品增益消退"
L["Item buff gain"] = "獲得物品增益"
L["Item buff gains"] = "獲得物品增益"
L["<Item buff name>"] = "<物品增益名稱>"
L["Main hand"] = "主手"
L["New Amount of stacks of the buff."] = "新的增益疊加層數。"
L["New Amount of stacks of the debuff."] = "新的減益疊加層數。"
L["Off hand"] = "副手"
L["Only return true, if the Aura has been applied by yourself"] = "只有選定時，自身光環可用"
L["Own aura"] = "自身光環"
L["Pet buff fades"] = "寵物增益消退"
L["Pet buff gains"] = "寵物獲得增益"
L["Pet debuff fades"] = "寵物減益消退"
L["Pet debuff gains"] = "寵物獲得減益"
L["Self buff fade"] = "自身增益消退"
L["Self buff gain"] = "獲得自身增益"
L["Self buff stacks gain"] = "獲得自身增益疊加"
L["Self debuff fade"] = "自身減益消退"
L["Self debuff gain"] = "獲得自身減益"
L["Self item buff fade"] = "自身物品增益消退"
L["Self item buff gain"] = "獲得自身物品增益"
L["Spell"] = "法術"
L["Stack count"] = "堆疊數字"
L["Target buff fade"] = "目標增益消退"
L["Target buff gain"] = "目標獲得增益"
L["Target buff gains"] = "目標獲得增益"
L["Target buff stack gains"] = "目標獲得增益疊加"
L["Target debuff fade"] = "目標減益消退"
L["Target debuff gain"] = "目標獲得減益"
L["The enemy that gained the buff"] = "敵對獲得的增益"
L["The enemy that gained the debuff"] = "敵對獲得的減益"
L["The enemy that lost the buff"] = "敵對消退的增益"
L["The enemy that lost the debuff"] = "敵對消退的減益"
L["The name of the buff gained."] = "獲得增益的名稱。"
L["The name of the buff lost."] = "消退增益的名稱。"
L["The name of the debuff gained."] = "受到減益的名稱。"
L["The name of the debuff lost."] = "消退減益的名稱。"
L["The name of the item buff gained."] = "獲得物品增益的名稱。"
L["The name of the item buff lost."] = "消退物品增益的名稱。"
L["The name of the item, the buff has been applied to."] = "獲得物品增益的名稱。"
L["The name of the item, the buff has faded from."] = "消退物品增益的名稱。"
L["The name of the pet that gained the buff"] = "寵物獲得的增益名稱"
L["The name of the pet that gained the debuff"] = "寵物獲得的減益名稱"
L["The name of the pet that lost the buff"] = "寵物消退的增益名稱"
L["The name of the pet that lost the debuff"] = "寵物消退的減益名稱"
L["The name of the unit that gained the buff."] = "單位獲得增益的名稱。"
L["The number of stacks of the buff"] = "增益堆疊數字"
L["The unit that is affected"] = "受到影響的單位"
L["Type of the aura"] = "光環類型"
L["Unit"] = "單位"


-- L["The rank of the item buff gained."] = true -- not used anymore
-- L["The rank of the item buff lost."] = true -- not used anymore

L = LibStub("AceLocale-3.0"):NewLocale("Parrot_CombatEvents_Data", "zhTW")
L["Ability blocks"] = "技能格擋"
L["Ability dodges"] = "技能閃躲"
L["Ability misses"] = "技能未命中"
L["Ability parries"] = "技能招架"
L["Amount of the damage that was missed."] = "傷害減少量。"
L["Arcane"] = "秘法"
L["Avoids"] = "削減"
L["Combat status"] = "戰鬥狀態"
L["Combo point gain"] = "獲得連擊點"
L["Combo points"] = "連擊點"
L["Combo points full"] = "連擊點已滿"
L["Damage"] = "傷害"
L[" (%d crits)"] = "（%d次爆擊）"
L[" (%d gains)"] = "（獲得%d點）"
L[" (%d heal, %d crit)"] = "（%d次治療，%d次爆擊）"
L[" (%d heal, %d crits)"] = "（%d次治療，%d次爆擊）"
L[" (%d heals)"] = "（%d次治療）"
L[" (%d heals, %d crit)"] = "（%d次治療，%d次爆擊）"
L[" (%d heals, %d crits)"] = "（%d次治療，%d次爆擊）"
L[" (%d hit, %d crit)"] = "（%d次命中，%d次爆擊）"
L[" (%d hit, %d crits)"] = "（%d次命中，%d次爆擊）"
L[" (%d hits)"] = "（%d次命中）"
L[" (%d hits, %d crit)"] = "（%d次命中，%d次爆擊）"
L[" (%d hits, %d crits)"] = "（%d次命中，%d次爆擊）"
L["Dispel"] = "驅散"
L["Dispel fail"] = "驅散失敗"
L[" (%d losses)"] = "（失去%s點）"
L["Dodge!"] = "閃躲！"
L["DoTs and HoTs"] = "DoT 和 HoT"
L["Enter combat"] = "進入戰鬥"
L["Environmental damage"] = "環境傷害"
L["Evade!"] = "閃避！"
L["Experience gains"] = "獲得經驗"
L["Extra attacks"] = "額外攻擊"
L["Fire"] = "火焰"
L["Frost"] = "冰霜"
L["Heals"] = "治療"
L["Heals over time"] = "持續治療"
L["Holy"] = "神聖"
L["Honor gains"] = "獲得榮譽"
L["Immune!"] = "免疫！"
L["Incoming damage"] = "承受傷害"
L["Incoming heals"] = "受到治療"
L["Interrupt!"] = "打斷！"
L["Killing Blow!"] = "殺死！"
L["Killing blows"] = "殺死"
L["Leave combat"] = "脫離戰鬥"
L["Melee"] = "近戰"
L["Melee absorbs"] = "近戰吸收"
L["Melee blocks"] = "近戰格擋"
L["Melee damage"] = "近戰傷害"
L["Melee deflects"] = "物理卸除"
L["Melee dodges"] = "近戰閃躲"
L["Melee evades"] = "近戰閃避"
L["Melee immunes"] = "近戰免疫"
L["Melee misses"] = "近戰未命中"
L["Melee parries"] = "近戰招架"
L["Melee reflects"] = "物理反射"
L["Melee resists"] = "物理抵抗"
L["Miss!"] = "未命中！"
L["Misses"] = "未擊中"
L["Multiple"] = "多重"
L["Nature"] = "自然"
L["NPC killing blows"] = "殺死 NPC"
L["[Num] CP"] = "[Num]連擊點"
L["[Num] CP Finish It!"] = "[Num]連擊點 終結技！"
L["Other"] = "其他"
L["Outgoing damage"] = "輸出傷害"
L["Outgoing heals"] = "輸出治療"
L["Parry!"] = "招架！"
L["Pet ability blocks"] = "技能格擋（寵物）"
L["Pet ability dodges"] = "技能閃躲（寵物）"
L["Pet ability misses"] = "技能未命中（寵物）"
L["Pet ability parries"] = "技能招架（寵物）"
L["Pet Absorb!"] = "吸收！（寵物）"
L["(Pet) -[Amount]"] = "-[Amount]（寵物）"
L["(Pet) +[Amount]"] = "+[Amount]（寵物）"
L["Pet [Amount] ([Skill])"] = "[Amount]（[Skill]）（寵物）"
L["Pet Block!"] = "格擋！（寵物）"
L["Pet damage"] = "寵物傷害"
L["Pet Dodge!"] = "閃躲！（寵物）"
L["Pet Evade!"] = "閃避！（寵物）"
L["Pet heals"] = "治療（寵物）"
L["Pet heals over time"] = "寵物持續治療"
L["Pet Immune!"] = "免疫！（寵物）"
L["Pet melee"] = "近戰（寵物）"
L["Pet melee absorbs"] = "近戰吸收（寵物）"
L["Pet melee blocks"] = "近戰格擋（寵物）"
L["Pet melee damage"] = "近戰傷害（寵物）"
L["Pet melee deflects"] = "寵物物理卸除"
L["Pet melee dodges"] = "近戰閃躲（寵物）"
L["Pet melee evades"] = "近戰閃避（寵物）"
L["Pet melee immunes"] = "近戰免疫（寵物）"
L["Pet melee misses"] = "近戰未命中（寵物）"
L["Pet melee parries"] = "近戰招架（寵物）"
L["Pet melee reflects"] = "寵物物理反射"
L["Pet melee resists"] = "寵物物理抵抗"
L["Pet Miss!"] = "未命中！（寵物）"
L["Pet misses"] = "寵物未擊中"
L["Pet Parry!"] = "招架！（寵物）"
L["Pet Reflect!"] = "反射！（寵物）"
L["Pet Resist!"] = "抵抗！（寵物）"
L["Pet siege damage"] = "寵物攻城傷害"
L["Pet skill"] = "寵物技能"
L["Pet skill absorbs"] = "技能吸收（寵物）"
L["Pet skill blocks"] = "寵物技能格擋"
L["Pet skill damage"] = "寵物技能傷害"
L["Pet skill deflects"] = "寵物技能卸除"
L["Pet skill dodges"] = "寵物技能閃躲"
L["Pet skill DoTs"] = "寵物技能 DoTs"
L["Pet skill evades"] = "技能閃避（寵物）"
L["Pet skill immunes"] = "技能免疫（寵物）"
L["Pet skill interrupts"] = "寵物技能中斷"
L["Pet skill misses"] = "寵物技能未擊中"
L["Pet skill parries"] = "寵物技能招架"
L["Pet skill reflects"] = "技能反射（寵物）"
L["Pet skill resists"] = "寵物技能抵抗"
L["Pet skills"] = "寵物技能"
L["Pet spell resists"] = "技能抵抗（寵物）"
L["Physical"] = "物理"
L["Player killing blows"] = "殺死玩家"
L["Power change"] = "能量變化"
L["Power gain"] = "獲得能量"
L["Power gain/loss"] = "獲得/失去能量"
L["Power loss"] = "失去能量"
L["Reactive skills"] = "反應技能"
L["Reflect!"] = "反射！"
L["Reputation"] = "聲望"
L["Reputation gains"] = "獲得聲望"
L["Reputation losses"] = "失去聲望"
L["Resist!"] = "抵抗！"
L["%s!"] = "%s！"
L["Self heals"] = "自身治療"
L["Self heals over time"] = "自身治療持續時間"
L["%s failed"] = "%s失敗"
L["Shadow"] = "暗影"
L["Siege damage"] = "攻城傷害"
L["Skill absorbs"] = "技能吸收"
L["Skill blocks"] = "技能格擋"
L["Skill damage"] = "技能傷害"
L["Skill deflects"] = "技能卸除"
L["Skill dodges"] = "技能閃躲"
L["Skill DoTs"] = "技能 DoT"
L["Skill evades"] = "技能閃避"
L["Skill gains"] = "技能提升"
L["Skill immunes"] = "技能免疫"
L["Skill interrupts"] = "技能打斷"
L["Skill misses"] = "技能未擊中"
L["Skill parries"] = "技能招架"
L["Skill reflects"] = "技能反射"
L["Skill resists"] = "技能抵抗"
L["Skills"] = "技能"
L["Skills absorbs"] = "技能吸收"
L["Skills blocks"] = "技能格擋"
L["Skills dodges"] = "技能閃躲"
L["Skills evades"] = "技能閃避"
L["Skills immunes"] = "技能免疫"
L["Skills misses"] = "技能未擊中"
L["Skills parries"] = "技能招架"
L["Skills reflects"] = "技能反射"
L["Skills resists"] = "技能抵抗"
L["Skill your pet was interrupted in casting"] = "你的寵物正在施放技能被打斷"
L["Skill you were interrupted in casting"] = "在你施法中打斷的技能"
L["Spell resists"] = "法術抵抗"
L["Spell steal"] = "法術竊取"
L["%s stole %s"] = "%s竊取%s"
L["The ability or spell take away your power."] = "使用的技能或法術而失去能量。"
L["The ability or spell used to gain power."] = "為獲得能量而使用的技能或法術。"
L["The ability or spell your pet used."] = "寵物所使用的技能或法術。"
L["The amount of damage done."] = "造成的傷害量。"
L["The amount of experience points gained."] = "獲得的經驗點數。"
L["The amount of healing done."] = "受到的治療量。"
L["The amount of honor gained."] = "獲得的榮譽點數。"
L["The amount of power gained."] = "獲得能量數值。"
L["The amount of power lost."] = "失去能量數值。"
L["The amount of reputation gained."] = "獲得的聲望點數。"
L["The amount of reputation lost."] = "失去聲望的點數。"
L["The amount of skill points currently."] = "目前的技能點數。"
L["The character that caused the power loss."] = "令你失去能量的角色。"
L["The character that the power comes from."] = "為你提供能量的角色。"
L["The current number of combo points."] = "目前的連擊點數。"
L["The name of the ally that healed you."] = "治療你的盟友名稱。"
L["The name of the ally that healed your pet."] = "治療你寵物的盟友名稱。"
L["The name of the ally you healed."] = "你所治療的盟友名稱。"
L["The name of the enemy slain."] = "殺死的敵人名稱。"
L["The name of the enemy that attacked you."] = "攻擊你的敵人名稱。"
L["The name of the enemy that attacked your pet."] = "攻擊你寵物的敵人名稱。"
L["The name of the enemy you attacked."] = "你所攻擊的敵人名稱。"
L["The name of the enemy your pet attacked."] = "寵物攻擊的敵人名稱。"
L["The name of the faction."] = "勢力的名稱。"
L["The name of the spell or ability which provided the extra attacks."] = "導致額外攻擊的法術或技能名稱。"
L["The name of the spell that has been dispelled."] = "被驅散的法術名稱。"
L["The name of the spell that has been stolen."] = "被竊取的法術名稱。"
L["The name of the spell that has been used for dispelling."] = "驅散所使用的法術名稱。"
L["The name of the spell that has been used for stealing."] = "竊取所使用的法術名稱。"
L["The name of the spell that has not been dispelled."] = "未被驅散的法術名稱。"
L["The name of the unit from which the spell has been removed."] = "單位法術已被移除的名稱。"
L["The name of the unit from which the spell has been stolen."] = "單位法術已被偷取的名稱。"
L["The name of the unit from which the spell has not been removed."] = "單位法術未被移除的名稱。"
L["The name of the unit that dispelled the spell from you"] = "單位法術被你驅散的名稱"
L["The name of the unit that failed dispelling the spell from you"] = "單位法術未被你驅散的名稱"
L["The name of the unit that stole the spell from you"] = "單位法術被你偷取的名稱"
L["The name of the unit that your pet healed."] = "你寵物治療的單位名稱。"
L["The rank of the enemy slain."] = "被殺死的敵人級別。"
L["The skill which experienced a gain."] = "獲得提升的技能。"
L["The spell or ability that the ally healed your pet with."] = "治療你寵物的法術或技能。"
L["The spell or ability that the ally healed you with."] = "盟友用來治療你的法術名稱。"
L["The spell or ability that the enemy attacked your pet with."] = "敵人攻擊你寵物的法術或技能。"
L["The spell or ability that the enemy attacked you with."] = "敵人攻擊你所用的法術或技能。"
L["The spell or ability that the pet used to heal."] = "你寵物使用的治療法術或技能。"
L["The spell or ability that your pet used."] = "你寵物使用的法術或技能。"
L["The spell or ability that you used."] = "你所使用的法術或技能。"
L["The spell or ability used to slay the enemy."] = "用來殺死敵人的法術或技能。"
L["The spell you interrupted"] = "你打斷的技能"
L["The spell your pet interrupted"] = "你寵物所打斷的技能"
L["The type of damage done."] = "造成傷害的類型。"
L["The type of power gained (Mana, Rage, Energy)."] = "獲得能量的類型（法力，怒氣，能量）。"
L["The type of power lost (Mana, Rage, Energy)."] = "失去能量的類型（法力，怒氣，能量）。"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Cooldowns", "zhTW")
L["Click to remove"] = "單擊移除"
L["Cooldowns"] = "冷卻"
L["Divine Shield"] = "聖盾"
L["Fire traps"] = "火陷阱"
L["Frost traps"] = "冰陷阱"
L["Ignore"] = "忽略"
L["Ignore Cooldown"] = "忽略冷卻"
L["Item cooldown ready"] = "物品冷卻結束"
L["<Item name>"] = "<物品名稱>"
L["Judgements"] = "審判"
L["Minimum time the cooldown must have (in seconds)"] = "必備最小冷卻時間（秒）"
L["Shocks"] = "震擊"
L["Skill cooldown finish"] = "技能冷卻完成"
L["<Spell name>"] = "<法術名稱>"
L["[[Spell] ready!]"] = "[Spell]冷卻完成！"
L["Spell ready"] = "法術已準備好"
L["Spell usable"] = "法術可用"
L["%s Tree"] = "%s系"
L["The name of the spell or ability which is ready to be used."] = "冷卻完成的法術或技能名稱。"
L["Threshold"] = "閾值"
L["Traps"] = "陷阱"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_Loot", "zhTW")
L["Loot"] = "拾取"
L["Loot +[Amount]"] = "拾取 +[Amount]"
L["Loot items"] = "拾取物品"
L["Loot money"] = "拾取金錢"
L["Loot [Name] +[Amount]([Total])"] = "拾取[Name] +[Amount]（[Total]）"
L["Soul shard gains"] = "獲得靈魂碎片"
L["The amount of gold looted."] = "拾取金錢的數量。"
L["The amount of items looted."] = "物品數量。"
L["The name of the item."] = "物品名稱。"
L["The name of the soul shard."] = "靈魂碎片的名稱。"
L["The total amount of items in inventory."] = "背包中物品的總量。"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_TriggerConditions_Data", "zhTW")
L["Active talents"] = "啟用天賦"
L["Amount"] = "數值"
L["Amount of damage to compare with"] = "傷害數值對比"
L["Amount of health to compare"] = "血量數值對比"
L["Amount of power to compare"] = "能量數值對比"
L["Any"] = "任意"
L["Comparator Type"] = "對比類型"
L["Deathknight presence"] = "死亡騎士領域"
L["Druid Form"] = "德魯伊形態"
L["Enemy target health percent"] = "敵對目標血量百分比"
L["Friendly target health percent"] = "友方目標血量百分比"
L["Hostility"] = "敵對"
L["How to compare actual value with parameter"] = "對比實際參數值"
L["In a Group or Raid"] = "在小隊或團隊"
L["Incoming block"] = "承受格擋"
L["Incoming cast"] = "承受施法"
L["Incoming crit"] = "承受暴擊"
L["Incoming damage"] = "承受傷害"
L["Incoming dodge"] = "承受閃躲"
L["Incoming miss"] = "承受未命中"
L["Incoming parry"] = "承受招架"
L["In vehicle"] = "已載具"
L["Lua function"] = "Lua 函數"
L["Maximum target health percent"] = "最大目標血量百分比"
L["Minimum power amount"] = "最小能量數值"
L["Minimum power percent"] = "最小能量百分比"
L["Minimum target health"] = "最小目標血量"
L["Minimum target health percent"] = "最小目標血量百分比"
L["Miss type"] = "未命中類型"
L["Mounted"] = "已坐騎"
L["Not Deathknight presence"] = "沒有死亡騎士領域"
L["Not in Druid Form"] = "沒有處於德魯伊形態"
L["Not in vehicle"] = "未載具"
L["Not in warrior stance"] = "沒有處於戰士姿態"
L["Not mounted"] = "未坐騎"
L["Outgoing block"] = "產生格擋"
L["Outgoing cast"] = "進行施法"
L["Outgoing crit"] = "產生爆擊"
L["Outgoing damage"] = "輸出傷害"
L["Outgoing dodge"] = "產生閃躲"
L["Outgoing miss"] = "輸出未命中"
L["Outgoing parry"] = "產生招架"
L["Pet health percent"] = "寵物血量百分比"
L["Pet mana percent"] = "寵物法力百分比"
L["Power type"] = "能量類型"
L["Primary"] = "主天賦"
L["Reason for the miss"] = "未命中原因"
L["Secondary"] = "副天賦"
L["Self health percent"] = "自身血量百分比"
L["Self mana percent"] = "自身法力百分比"
L["<Skill name>"] = "<技能名稱>"
L["<Sourcename>,<Destinationname>,<Spellname>"] = "<施法者名稱>,<目標名稱>,<法術名稱>"
L["Successful spell cast"] = "法術施放成功"
L["Target is NPC"] = "目標為 NPC"
L["Target is player"] = "目標為玩家"
L["The unit that attacked you"] = "攻擊你的單位"
L["The unit that is affected"] = "受影響單位"
L["The unit that you attacked"] = "你攻擊的單位"
L["Type of power"] = "能量類型"
L["Unit"] = "單位"
L["Unit health"] = "單位血量"
L["Unit power"] = "單位能量"
L["Warrior stance"] = "戰士姿態"
L["Whether the unit should be friendly or hostile"] = "友好或敵對單位"


L = LibStub("AceLocale-3.0"):NewLocale("Parrot_CombatStatus", "zhTW")
L["-Combat"] = "-戰鬥"
L["+Combat"] = "+戰鬥"
L["Combat status"] = "戰鬥狀態"
L["Enter combat"] = "進入戰鬥"
L["In combat"] = "戰鬥中"
L["Leave combat"] = "離開戰鬥"
L["Not in combat"] = "非戰鬥"

