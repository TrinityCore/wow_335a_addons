if GetLocale() ~= "ruRU" then return end

-- ru translations provided by McFLY aka mukha521
CappingLocale:CreateLocaleTable({
	-- battlegrounds
	["Alterac Valley"] = "Альтеракская долина",
	["Arathi Basin"] = "Низина Арати",
	["Warsong Gulch"] = "Ущелье Песни Войны",
	["Eye of the Storm"] = "Око Бури",
	["Wintergrasp"] = "Озеро Ледяных Оков",
	--["Isle of Conquest"] = true,

	-- options menu
	["Auto Quest Turnins"] = "Авто сдача квестов",
	["Bar"] = "Полоса",
	["Width"] = "Ширина",
	["Height"] = "Высота",
	["Texture"] = "Текстура",
	["Map Scale"] = "Масштаб карты",
	["Hide Border"] = "Скрыть кромку",
	["Port Timer"] = "Время телепортации",
	["Wait Timer"] = "Время ожидания",
	["Show/Hide Anchor"] = "Показать/скрыть якорёк",
	["Narrow Map Mode"] = "Обрезанная карта",
	--["Narrow Anchor Left"] = true,
	["Test"] = "Тест",
	["Flip Growth"] = "Перевернуть",
	--["Single Group"] = true,
	["Move Scoreboard"] = "Переместить табло",
	["Spacing"] = "Расстояние",
	["Request Sync"] = "Запросить синхронизацию",
	["Fill Grow"] = "Заполнять выростая",
	["Fill Right"] = "Заполнять направо",
	["Font"] = "Шрифт",
	["Time Position"] = "Расположение времени",
	["Border Width"] = "Ширина кромки",
	["Send to BG"] = "Писать в BG",
	["Send to SAY"] = "Писать в SAY",
	["Cancel Timer"] = "Отменить Таймер",
	["Move Capture Bar"] = "Переместить Таймер Захвата",
	--["Move Vehicle Seat"] = true,

	-- etc timers
	["Port: %s"] = "На БГ: %s", -- bar text for time remaining to port into a bg
	["Queue: %s"] = "Очередь: %s",
	["Battle Begins"] = "Начало сражения", -- bar text for bg gates opening
	["1 minute"] = "1 минута",
	["60 seconds"] = "60 секунд",
	["30 seconds"] = "30 секунд",
	["15 seconds"] = "15 секунд",
	["One minute until"] = "Одна минута до",
	--["Forty five seconds"] = true,
	["Thirty seconds until"] = "через 30 секунд",
	["Fifteen seconds until"] = "Пятнадцать секунд до",
	--["has begun"] = true, -- start of arena key phrase
	["%s: %s - %d:%02d"] = "%s: %s - через %d:%02d", -- chat message after shift left-clicking a bar

	-- AB
	["Bases: (%d+)  Resources: (%d+)/(%d+)"] = "Базы: (%d+) Ресурсы: (%d+)/(%d+)", -- arathi basin scoreboard
	["has assaulted"] = "штурмует",
	["claims the"] = "через ([1]?%s?)минуту",
	["has taken the"] = "захватил",
	["has defended the"] = "отразил",
	["Final: %d - %d"] = "Финал: %d - %d", -- final score text
	["wins %d-%d"] = "выиграет %d-%d", -- final score chat message

	-- WSG
	["was picked up by (.+)!"] = "(.+) несет флаг Орды!",
	["was picked up by (.+)!2"] = "Флаг Альянса у (.+)!",
	["dropped"] = "уронил",
	["captured the"] = "захватил",
	["Flag respawns"] = "Появление Флагов",
	["%s's flag carrier: %s (%s)"] = "%s Флагоносец: %s (%s)",

	-- AV
	 -- NPC
	["Smith Regzar"] = "Кузнец Регзар",
	["Murgot Deepforge"] = "Мургот Подземная Кузня",
	["Primalist Thurloga"] = "Старейшина Турлога",  -- same as default
	["Arch Druid Renferal"] = "Верховный друид Дикая Лань",
	["Stormpike Ram Rider Commander"] = "Командир наездников на баранах из клана Грозовой Вершины",
	["Frostwolf Wolf Rider Commander"] = "Командир наездников на волках из клана Северного Волка",

	 -- patterns
	--["Upgrade to"] = true, -- the option to upgrade units in AV
	--["Wicked, wicked, mortals!"] = true, -- what Ivus says after being summoned
	--["Ivus begins moving"] = true,
	--["WHO DARES SUMMON LOKHOLAR"] = true, -- what Lok says after being summoned
	--["The Ice Lord has arrived!"] = true,
	--["Lokholar begins moving"] = true,


	-- EotS
	["^(.+) has taken the flag!"] = "^(.+) захватывает флаг!",
	["Bases: (%d+)  Victory Points: (%d+)/(%d)"] = "Базы: (%d+)  Очки победы: (%d+)/(%d)",

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