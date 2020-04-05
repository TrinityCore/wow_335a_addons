local L = LibStub("AceLocale-3.0"):NewLocale("oRA3", "zhCN")
if not L then return end

-- Generic
L["Name"] = "oRA3"
L["Checks"] = "检查"
L["Disband Group"] = "解散团队"
L["Disbands your current party or raid, kicking everyone from your group, one by one, until you are the last one remaining.\n\nSince this is potentially very destructive, you will be presented with a confirmation dialog. Hold down Control to bypass this dialog."] = "解散当前的小队或团队, 会将所有人踢出队伍, 直到只省下你一个人. 由于潜在的危险, 你会看到一个确认框. 按住CTRL跳过确认."
L["Options"] = "选项"
L["<oRA3> Disbanding group."] = "<oRA3>正在解散团队"
L["Are you sure you want to disband your group?"] = "你确认要解散团队么?"
L["Click to open/close oRA3"] = "打开/关闭 oRA3"
L["Unknown"] = "未知"

-- Core
L["You can configure some options here. All the actual actions are done from the panel at the RaidFrame."] = "你可以在这里调整设置, 所有实际操作都在团队面板进行"
L.uiHidden = "你正在战斗中.\noRA3 面板暂时被关闭.\n\n脱离战斗后恢复."

-- Ready check module
L["The following players are not ready: %s"] = "下列队员未准备好:%s"
L["Ready Check (%d seconds)"] = "就位确认还有%d秒结束"
L["Ready"] = "准备好"
L["Not Ready"] = "未准备好"
L["No Response"] = "未确认"
L["Offline"] = "离线"
L["Play a sound when a ready check is performed."] = "就绪检查时播放提示音效"
L["GUI"] = "面板"
L["Show the oRA3 Ready Check GUI when a ready check is performed."] = "就绪检查时显示oRA3的就绪检查面板"
L["Auto Hide"] = "自动隐藏"
L["Automatically hide the oRA3 Ready Check GUI when a ready check is finished."] = "就绪检查完毕后自动隐藏面板"

-- Durability module
L["Durability"] = "耐久度"
L["Average"] = "平均"
L["Broken"] = "损坏"
L["Minimum"] = "最少"

-- Resistances module
L["Resistances"] = "抗性"
L["Frost"] = "冰霜"
L["Fire"] = "火焰"
L["Shadow"] = "暗影"
L["Nature"] = "自然"
L["Arcane"] = "奥术"

-- Resurrection module
L["%s is ressing %s."] = "%s正在复活%s"

-- Invite module
L["Invite"] = "邀请"
L["All max level characters will be invited to raid in 10 seconds. Please leave your groups."] = "公告：公会中所有满级玩家会被在10秒内被邀请，请保持没有队伍！"
L["All characters in %s will be invited to raid in 10 seconds. Please leave your groups."] = "公告：公会中所有在%s的玩家会被在10秒内被邀请，请保持没有队伍！"
L["All characters of rank %s or higher will be invited to raid in 10 seconds. Please leave your groups."] = "公告：公会中所有会阶在%s以上的玩家会被在10秒内被邀请，请保持没有队伍！" 
L["<oRA3> Sorry, the group is full."] = "抱歉，队伍已满。"
L["Invite all guild members of rank %s or higher."] = "邀请公会中所有会阶在%s以上的玩家"
L["Keyword"] = "组队关键字"
L["When people whisper you the keywords below, they will automatically be invited to your group. If you're in a party and it's full, you will convert to a raid group. The keywords will only stop working when you have a full raid of 40 people. Setting a keyword to nothing will disable it."] = "当有人密语以下关键字后, 他将会被自动邀请加入你的队伍. 如果你不在一个小队或队伍已达到上限, 插件将自动转换为团队. 团队满40人后此功能会失效. 留空为禁止"
L["Anyone who whispers you this keyword will automatically and immediately be invited to your group."] = "任何人密语你这个关键字会被邀请至你的队伍"
L["Guild Keyword"] = "工会关键字"
L["Any guild member who whispers you this keyword will automatically and immediately be invited to your group."] = "任何工会成员密语这个关键字会被邀请至你的队伍"
L["Invite guild"] = "公会邀请"
L["Invite everyone in your guild at the maximum level."] = "邀请公会中满级的玩家"
L["Invite zone"] = "地区邀请"
L["Invite everyone in your guild who are in the same zone as you."] = "邀请公会中在指定地区的玩家"
L["Guild rank invites"] = "会阶邀请"
L["Clicking any of the buttons below will invite anyone of the selected rank AND HIGHER to your group. So clicking the 3rd button will invite anyone of rank 1, 2 or 3, for example. It will first post a message in either guild or officer chat and give your guild members 10 seconds to leave their groups before doing the actual invites."] = "自动邀请会阶高于等于所选等级的工会成员，按下该按钮会自动在工会和官员频道发送要求10秒内离队待组的消息，10秒后自动开始组人"

-- Promote module
L["Demote everyone"] = "降级所有人"
L["Demotes everyone in the current group."] = "降级在目前群组的所有人"
L["Promote"] = "提升"
L["Mass promotion"] = "批量提升"
L["Everyone"] = "所有人"
L["Promote everyone automatically."] = "自动提升所有人"
L["Guild"] = "公会"
L["Promote all guild members automatically."] = "自动提升团队中的工会玩家"
L["By guild rank"] = "会阶"
L["Individual promotions"] = "单独提升"
L["Note that names are case sensitive. To add a player, enter a player name in the box below and hit Enter or click the button that pops up. To remove a player from being promoted automatically, just click his name in the dropdown below."] = "注意，玩家名字区分大小写。添加自动提升玩家只需敲入名字后按回车或者旁边的按钮。在下拉列表中选中一个玩家就可以删除该玩家的自动提升。"
L["Add"] = "添加"
L["Remove"] = "删除"

-- Cooldowns module
L["Cooldowns"] = "冷却"
L["Monitor settings"] = "监视器设置"
L["Show monitor"] = "显示"
L["Lock monitor"] = "锁定"
L["Show or hide the cooldown bar display in the game world."] = "是否显示冷却监视器"
L["Note that locking the cooldown monitor will hide the title and the drag handle and make it impossible to move it, resize it or open the display options for the bars."] = "锁定后将隐藏监视器的标题并将无法拖曳, 设置大小, 打开设置."
L["Only show my own spells"] = "只显示我的法术冷却"
L["Toggle whether the cooldown display should only show the cooldown for spells cast by you, basically functioning as a normal cooldown display addon."] = "是否只显示你自己释放的法术的冷却, 这将是一个普通的法术冷却插件."
L["Cooldown settings"] = "冷却选项"
L["Select which cooldowns to display using the dropdown and checkboxes below. Each class has a small set of spells available that you can view using the bar display. Select a class from the dropdown and then configure the spells for that class according to your own needs."] = "通过下拉列表选择你想要监视的技能冷却。每个职业都有一套可用的监视的技能冷却列表，根据需要取舍。"
L["Select class"] = "选择职业"
L["Never show my own spells"] = "不显示我的法术"
L["Toggle whether the cooldown display should never show your own cooldowns. For example if you use another cooldown display addon for your own cooldowns."] = "冷却显示器将不显示你的法术冷却. 例如你用冷却监视插件时可以勾选本项."

-- monitor
L["Cooldowns"] = "冷却"
L["Right-Click me for options!"] = "右键打开设置"
L["Bar Settings"] = "计时条设置"
L["Spawn test bar"] = "显示测试计时条"
L["Use class color"] = "使用职业颜色"
L["Height"] = "高度"
L["Scale"] = "缩放"
L["Texture"] = "材质"
L["Icon"] = "图标"
L["Show"] = "显示"
L["Duration"] = "时间"
L["Unit name"] = "名字"
L["Spell name"] = "技能"
L["Short Spell name"] = "技能缩写"
L["Label Align"] = "标签位置"
L["Left"] = "左"
L["Right"] = "右"
L["Center"] = "中间"
L["Grow up"] = "向上递增"

-- Zone module
L["Zone"] = "地区"

-- Loot module
 L["Leave empty to make yourself Master Looter."] = "留空表示设置你自己为拾取者"
 
-- Tanks module
L["Tanks"] = "坦克"
L.tankTabTopText = "点击下方列表将其设为坦克. 将鼠标移动到按钮上可看到操作提示."

L["Top List: Sorted Tanks. Bottom List: Potential Tanks."] = "顶部名单: 排序主坦克. 底部名单: 可能主坦克."
-- L["Remove"]?is defined above
L.deleteButtonHelp = "从坦克名单移除。"
L["Blizzard Main Tank"] = "内建主坦克"
L.tankButtonHelp = "切换是否这坦克应该为内建主坦克。"
L["Save"] = "储存"
L.saveButtonHelp = "储存坦克在你个人名单。只要你在团队里面有这玩家，他就会被编排作为个人坦克。"
L["What is all this?"] = "到底怎麽回事?"
L.tankHelp = "在置顶名单的人是你个人排序的坦克。他们并不分享给团队，并且任何人可以拥有不同的个人坦克名单。在置底名单点选一个名称增加他们到你个人坦克名单。\n\n在盾图示上点击就会让那人成为内建主坦克。内建坦克是团队所有人中所共享并且你必须被晋升来做切换。\n\n在名单出现的坦克基於某些人让他们成为内建坦克，当他们不再是内建主坦克就会从名单移除。\n\n在这期间使用检查标记来储存。下一次团队里有那人，他会自动的被设定为个人坦克。"
L["Sort"] = "排序"
L["Click to move this tank up."] = "点击往上移动坦克。"
L["Show"] = "显示"
L.showButtonHelp = "在你个人的坦克排列中显示这个坦克. 此项只对本地有效, 不会影响团队中其他人的配置"

