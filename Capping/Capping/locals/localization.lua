local L = {
	-- battlegrounds
	["Alterac Valley"] = true,
	["Arathi Basin"] = true,
	["Warsong Gulch"] = true,
	["Eye of the Storm"] = true,
	["Wintergrasp"] = true,
	["Isle of Conquest"] = true,

	-- options menu
	["Auto Quest Turnins"] = true,
	["Bar"] = "Timer Bar",
	["Width"] = true,
	["Height"] = true,
	["Texture"] = true,
	["Map Scale"] = true,
	["Hide Border"] = true,
	["Port Timer"] = true,
	["Wait Timer"] = true,
	["Show/Hide Anchor"] = true,
	["Narrow Map Mode"] = true,
	["Narrow Anchor Left"] = true,
	["Test"] = true,
	["Flip Growth"] = "Flip Bar Stack",
	["Single Group"] = true,
	["Move Scoreboard"] = true,
	["Spacing"] = true,
	["Request Sync"] = true,
	["Fill Grow"] = true,
	["Fill Right"] = true,
	["Font"] = true,
	["Time Position"] = true,
	["Border Width"] = true,
	["Send to BG"] = true,
	["Send to SAY"] = true,
	["Cancel Timer"] = true,
	["Move Capture Bar"] = true,
	["Move Vehicle Seat"] = true,

	-- etc timers
	["Port: %s"] = true, -- bar text for time remaining to port into a bg
	["Queue: %s"] = true,
	["Battle Begins"] = true, -- bar text for bg gates opening
	["1 minute"] = true,
	["60 seconds"] = true,
	["30 seconds"] = true,
	["15 seconds"] = true,
	["One minute until"] = true,
	["Forty five seconds"] = true,
	["Thirty seconds until"] = true,
	["Fifteen seconds until"] = true,
	["has begun"] = true, -- start of arena key phrase
	["%s: %s - %d:%02d"] = true, -- chat message after shift left-clicking a bar

	-- AB
	["Bases: (%d+)  Resources: (%d+)/(%d+)"] = true, -- arathi basin scoreboard
	["has assaulted"] = true,
	["claims the"] = true,
	["has taken the"] = true,
	["has defended the"] = true,
	["Final: %d - %d"] = true, -- final score text
	["wins %d-%d"] = true, -- final score chat message

	-- WSG
	["was picked up by (.+)!"] = true,
	["was picked up by (.+)!2"] = true,
	["dropped"] = true,
	["captured the"] = true,
	["Flag respawns"] = true,
	["%s's flag carrier: %s (%s)"] = true, -- chat message

	-- AV
	 -- NPC
	["Smith Regzar"] = true,
	["Murgot Deepforge"] = true,
	["Primalist Thurloga"] = true,
	["Arch Druid Renferal"] = true,
	["Stormpike Ram Rider Commander"] = true,
	["Frostwolf Wolf Rider Commander"] = true,

	 -- patterns
	["Upgrade to"] = true, -- the option to upgrade units in AV
	["Wicked, wicked, mortals!"] = true, -- what Ivus says after being summoned
	["Ivus begins moving"] = true,
	["WHO DARES SUMMON LOKHOLAR"] = true, -- what Lok says after being summoned
	["The Ice Lord has arrived!"] = true,
	["Lokholar begins moving"] = true,

	-- EotS
	["^(.+) has taken the flag!"] = true,
	["Bases: (%d+)  Victory Points: (%d+)/(%d+)"] = true,
	
	-- IoC
	 -- node keywords (text is also displayed on timer bar)
	["Alliance Keep"] = true,
	["Horde Keep"] = true,
	 -- Siege Engine keyphrases
	["Goblin"] = true,  -- Horde mechanic name keyword
	["seaforium bombs"] = true,  -- start (after capturing the workshop)
	["It's broken"] = true,  -- start again (after engine is destroyed)
	["halfway"] = true,  -- middle
}

CappingLocale = L
function L:CreateLocaleTable(t)
	for k, v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

L:CreateLocaleTable(L)