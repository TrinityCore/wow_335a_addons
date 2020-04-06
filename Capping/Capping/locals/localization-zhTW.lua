if GetLocale() ~= "zhTW" then return end

--translate by BestSteve
CappingLocale:CreateLocaleTable({
	-- battlegrounds
	["Alterac Valley"] = "奧特蘭克山谷", 
	["Arathi Basin"] = "阿拉希盆地", 
	["Warsong Gulch"] = "戰歌峽谷",
	["Eye of the Storm"] = "暴風之眼",
	["Wintergrasp"] = "冬握湖",
	["Isle of Conquest"] = "征服之島",
	
	-- options menu
	["Auto Quest Turnins"] = "自動回報任務",
	["Bar"] = "狀態條",
	["Width"] = "寬度",
	["Height"] = "高度",
	["Texture"] = "紋理",
	["Map Scale"] = "地圖縮放",
	["Hide Border"] = "隱藏邊框",
	["Port Timer"] = "傳送計時",
	["Wait Timer"] = "等待計時條",
	["Show/Hide Anchor"] = "顯示/隱藏錨點",
	["Narrow Map Mode"] = "精簡地圖模式",
	--["Narrow Anchor Left"] = true,
	["Test"] = "測試",
	["Flip Growth"] = "反轉增長",
	--["Single Group"] = true,
	["Move Scoreboard"] = "重設記分板位置",
	["Spacing"] = "間隔",
	["Request Sync"] = "要求同步",
	["Fill Grow"] = "填充增長",
	["Fill Right"] = "填充右部",
	["Font"] = "字型",
	["Time Position"] = "時間位置",
	["Border Width"] = "邊緣寬度",
	["Send to BG"] = "發送到戰場頻道",
	["Send to SAY"] = "發送到說",
	["Cancel Timer"] = "取消計時條",
	["Move Capture Bar"] = "復位計時條",
	--["Move Vehicle Seat"] = true,
	
	-- etc timers
	["Port: %s"] = "傳送: %s", -- bar text for time remaining to port into a bg
	["Queue: %s"] = "佇列: %s",
	["Battle Begins"] = "開始", -- bar text for bg gates opening
	["1 minute"] = "1分鐘",
	["60 seconds"] = "60秒",
	["30 seconds"] = "30秒",
	["15 seconds"] = "15秒",
	["One minute until"] = "一分鐘",
	--["Forty five seconds"] = true,
	["Thirty seconds until"] = "三十秒",
	["Fifteen seconds until"] = "十五秒",
	--["has begun"] = true, -- start of arena key phrase
	["%s: %s - %d:%02d"] = "%s: %s - 還有 %d:%02d", -- chat message after shift left-clicking a bar
	
	-- AB	
	["Bases: (%d+)  Resources: (%d+)/(%d+)"] = "基地:(%d+) 資源:(%d+)/(%d+)", -- arathi basin scoreboard
	["has assaulted"] = "突襲了",
	["claims the"] = "攻佔了",
	["has taken the"] = "奪取了",
	["has defended the"] = "守住了",
	["Final: %d - %d"] = "估計最終比數: %d - %d", -- final score text
	["wins %d-%d"] = "勝利 (%d-%d)", -- final score chat message
	
	-- WSG
	["was picked up by (.+)!"] = "被(.+)拔掉了!",
	--["was picked up by (.+)!2"] = true,
	["dropped"] = "丟掉了",
	["captured the"] = "佔據了",
	["Flag respawns"] = "旗幟已重置",
	["%s's flag carrier: %s (%s)"] = "%s的旗幟攜帶者: %s (%s)", -- chat message
	
	-- AV
	 -- NPC
	["Smith Regzar"] = "鐵匠雷格薩",
	["Murgot Deepforge"] = "莫高特·深爐",
	["Primalist Thurloga"] = "原獵者瑟魯加",
	["Arch Druid Renferal"] = "大德魯伊雷弗拉爾",
	["Stormpike Ram Rider Commander"] = "雷矛山羊騎兵指揮官",
	["Frostwolf Wolf Rider Commander"] = "霜狼騎兵指揮官",

	 -- patterns
	["Upgrade to"] = "升級成", -- the option to upgrade units in AV
	["Wicked, wicked, mortals!"] = "邪惡,太邪惡了,人類!", -- what Ivus says after being summoned
	["Ivus begins moving"] = "伊弗斯開始移動",
	["WHO DARES SUMMON LOKHOLAR"] = "誰敢召喚冰雪之王洛克霍拉?", -- what Lok says after being summoned
	["The Ice Lord has arrived!"] = "冰雪之王來了!",
	["Lokholar begins moving"] = "洛克霍拉開始移動",
	
	-- EotS
	["^(.+) has taken the flag!"] = "^(.+)已經奪走了旗幟!",
	["Bases: (%d+)  Victory Points: (%d+)/(%d+)"] = "基地:(%d+) 勝利點數:(%d+)/(%d+)",

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
