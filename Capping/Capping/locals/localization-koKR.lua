if GetLocale() ~= "koKR" then return end

--- ko translations initially provided by McKabi
CappingLocale:CreateLocaleTable({
	-- battlegrounds
	["Alterac Valley"] = "알터랙 계곡",
	["Arathi Basin"] = "아라시 분지",
	["Warsong Gulch"] = "전쟁노래 협곡",
	["Eye of the Storm"] = "폭풍의 눈",
	["Wintergrasp"] = "겨울손아귀 호수",
	["Isle of Conquest"] = "정복의 섬",
	
	-- options menu
	["Auto Quest Turnins"] = "퀘스트 자동 반납",
	["Bar"] = "막대",
	["Width"] = "너비",
	["Height"] = "높이",
	["Texture"] = "텍스처",
	["Map Scale"] = "지도 크기",
	["Hide Border"] = "테두리 숨기기",
	["Port Timer"] = "입장 시간",
	["Wait Timer"] = "대기 시간",
	["Show/Hide Anchor"] = "표식 보이기/감추기",
	["Narrow Map Mode"] = "좁은 지도 표시",
	["Narrow Anchor Left"] = "좌측 좁은 표식",
	["Test"] = "시험",
	["Flip Growth"] = "막대 위로 쌓기",
	["Single Group"] = "단일 그룹",
	["Move Scoreboard"] = "점수판 위치 바꾸기",
	["Spacing"] = "간격",
	["Request Sync"] = "동기화 요청",
	["Fill Grow"] = "성장방향 채우기",
	["Fill Right"] = "우측부터 채우기",
	["Font"] = "글꼴",
	["Time Position"] = "시간 위치",
	["Border Width"] = "테두리 너비",
	["Send to BG"] = "전장 대화 출력",
	["Send to SAY"] = "일반 대화 출력",
	["Cancel Timer"] = "시간 취소",
	["Move Capture Bar"] = "점령시간 바",
	["Move Vehicle Seat"] = "탑승 차량",

	-- etc timers
	["Port: %s"] = "입장: %s", -- bar text for time remaining to port into a bg
	["Queue: %s"] = "대기: %s",
	["Battle Begins"] = "전투 개시", -- bar text for bg gates opening
	["1 minute"] = "1분",
	["60 seconds"] = "60초",
	["30 seconds"] = "30초",
	["15 seconds"] = "15초",
	["One minute until"] = "1분 전",
	["Forty five seconds"] = "45초 전",
	["Thirty seconds until"] = "30초 전",
	["Fifteen seconds until"] = "15초 전",
	["has begun"] = "시작", -- start of arena key phrase
	["%s: %s - %d:%02d remaining"] = "%s: %s - %d:%02d 남았음", -- chat message after shift left-clicking a bar

	-- AB
	["Bases: (%d+)  Resources: (%d+)/(%d+)"] = "거점: (%d+)  자원: (%d+)/(%d+)", -- arathi basin scoreboard
	["has assaulted"] = "공격했습니다",
	["claims the"] = "넘어갈 것입니다",
	["has taken the"] = "점령했습니다",
	["has defended the"] = "방어했습니다",
	["Final: %d - %d"] = "종료: %d - %d", -- final score text
	["wins %d-%d"] = "승리 %d-%d", -- final score chat message

	-- WSG
	["was picked up by (.+)!"] = "([^ ]*)|1이;가; ([^!]*) 깃발을 손에 넣었습니다!",
	--["was picked up by (.+)!2"] = "([^ ]*)|1이;가; ([^!]*) 깃발을 손에 넣었습니다!2",
	["dropped"] = "([^ ]*)|1이;가; ([^!]*) 깃발을 떨어뜨렸습니다!",
	["captured the"] = "([^ ]*)|1이;가; ([^!]*) 깃발 쟁탈에 성공했습니다!",
	["Flag respawns"] = "새 깃발 생성",
	["%s's flag carrier: %s (%s)"] = "%s 깃발 운반자: %s (%s)", -- chat message

	-- AV
	 -- NPC
	["Smith Regzar"] = "대장장이 렉자르",
	["Murgot Deepforge"] = "멀고트 딥포지",
	["Primalist Thurloga"] = "원시술사 투를로가",
	["Arch Druid Renferal"] = "대드루이드 렌퍼럴",
	["Stormpike Ram Rider Commander"] = "스톰파이크 산양기병대 지휘관",
	["Frostwolf Wolf Rider Commander"] = "서리늑대 늑대기병대 지휘관",

	 -- patterns
	["Upgrade to"] = "추가 전리품", -- the option to upgrade units in AV
	---["Wicked, wicked, mortals!"] = true, -- what Ivus says after being summoned
	["Ivus begins moving"] = "이부스 이동 시작",
	---["WHO DARES SUMMON LOKHOLAR"] = true, -- what Lok says after being summoned
	["The Ice Lord has arrived!"] = "얼음 군주께서 당도하셨어요!",
	["Lokholar begins moving"] = "로크홀라 이동 시작",


	-- EotS
	["^(.+) has taken the flag!"] = "^(.+)|1이;가; 깃발을 차지했습니다!",
	["Bases: (%d+)  Victory Points: (%d+)/(%d)"] = "거점: (%d+)  승점: (%d+)/(%d)",

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

