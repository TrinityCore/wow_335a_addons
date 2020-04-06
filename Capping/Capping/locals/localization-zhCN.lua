if GetLocale() ~= "zhCN" then return end

--translate by BestSteve
CappingLocale:CreateLocaleTable({
	-- battlegrounds
	["Alterac Valley"] = "奥特兰克山谷", 
	["Arathi Basin"] = "阿拉希盆地", 
	["Warsong Gulch"] = "战歌峡谷",
	["Eye of the Storm"] = "风暴之眼",
	["Wintergrasp"] = "冬拥湖",
	["Isle of Conquest"] = "征服之岛",
	
	-- options menu
	["Auto Quest Turnins"] = "自动完成任务",
	["Bar"] = "计时条",
	["Width"] = "宽度",
	["Height"] = "高度",
	["Texture"] = "材质",
	["Map Scale"] = "地图缩放",
	["Hide Border"] = "隐藏边框",
	["Port Timer"] = "传送计时条",
	["Wait Timer"] = "等待计时条",
	["Show/Hide Anchor"] = "显示/隐藏锚点",
	["Narrow Map Mode"] = "精简地图模式",
	--["Narrow Anchor Left"] = true,
	["Test"] = "测试",
	["Flip Growth"] = "反向",
	--["Single Group"] = true,
	["Move Scoreboard"] = "重新设置记分板位置",
	["Spacing"] = "间隔",
	["Request Sync"] = "要求同步",
	["Fill Grow"] = "填充增长",
	["Fill Right"] = "填充右部",
	["Font"] = "字体",
	["Time Position"] = "时间位置",
	["Border Width"] = "边缘宽度",
	["Send to BG"] = "发送到战场频道",
	["Send to SAY"] = "发送到说",
	["Cancel Timer"] = "取消计时条",
	["Move Capture Bar"] = "复位计时条",
	--["Move Vehicle Seat"] = true,
	
	-- etc timers
	["Port: %s"] = "传送：%s", -- bar text for time remaining to port into a bg
	["Queue: %s"] = "队列中：%s",
	["Battle Begins"] = "战斗即将开始", -- bar text for bg gates opening
	["1 minute"] = "1分钟",
	["60 seconds"] = "60秒",
	["30 seconds"] = "30秒",
	["15 seconds"] = "15秒",
	["One minute until"] = "一分钟",
	--["Forty five seconds"] = true,
	["Thirty seconds until"] = "三十秒",
	["Fifteen seconds until"] = "十五秒",
	--["has begun"] = true, -- start of arena key phrase
	["%s: %s - %d:%02d"] = "%s:%s - 剩余 %d:%02d", -- chat message after shift left-clicking a bar
	
	-- AB	
	["Bases: (%d+)  Resources: (%d+)/(%d)"] = "基地：(%d+) 资源：(%d+)/(%d)", -- arathi basin scoreboard
	["has assaulted"] = "突袭了",
	["claims the"] = "攻占了",
	["has taken the"] = "夺取了",
	["has defended the"] = "守住了",
	["Final: %d - %d"] = "最终：%d - %d", -- final score text
	["wins %d-%d"] = "胜利 %d - %d", -- final score chat message
	
	-- WSG
	["was picked up by (.+)!"] = "旗帜被([^%s]+)拔起了！",
	["dropped"] = "丢掉了",
	["captured the"] = "夺取",
	["Flag respawns"] = "旗帜即将刷新",
	["%s's flag carrier: %s (%s)"] = "%s的旗子携带者：%s (%s)", -- chat message
	
	-- AV
	 -- NPC
	["Smith Regzar"] = "铁匠雷格萨",
	["Murgot Deepforge"] = "莫高特·深炉",
	["Primalist Thurloga"] = "指挥官瑟鲁加",
	["Arch Druid Renferal"] = "大德鲁伊雷弗拉尔",
	["Stormpike Ram Rider Commander"] = "雷矛山羊骑兵指挥官",
	["Frostwolf Wolf Rider Commander"] = "霜狼骑兵指挥官",

	 -- patterns
	["Upgrade to"] = "升级到", -- the option to upgrade units in AV
	["Wicked, wicked, mortals!"] = "邪恶，太邪恶了，人类", -- what Ivus says after being summoned
	["Ivus begins moving"] = "伊弗斯开始移动",
	["WHO DARES SUMMON LOKHOLAR"] = "谁敢召唤冰雪之王洛克霍拉？", -- what Lok says after being summoned
	["The Ice Lord has arrived!"] = "冰雪之王到来！",
	["Lokholar begins moving"] = "洛克霍拉开始移动",
	
	-- EotS
	["^(.+) has taken the flag!"] = "^(.+)夺走了旗帜！",
	["Bases: (%d+)  Victory Points: (%d+)/(%d)"] = "基地：(%d+) 胜利点数：(%d+)/(%d)",

	-- IoC
	 -- node keywords (text is also displayed on timer bar)
	--["Alliance Keep"] = true,
	--["Horde Keep"] = true,
	 -- Siege Engine keyphrases
	--["Goblin"] = true,  -- Horde mechanic name keyword
	--["seaforium bombs"] = true,  -- start (after capturing the workshop)
	--["It's broken"] = true,  -- start again (after engine is destroyed)
	--["halfway"] = true,  -- middle
})
