if not Skinner:isAddonEnabled("Quelevel") then return end

function Skinner:Quelevel()

	local QTHex = self:RGBPercToHex(self.HTr, self.HTg, self.HTb)

	local function colourText(tString)

		if tString then
			local f, l = tString:find("000000", 1, true) -- look for original colour strings
			if f then
				f = tString:sub(1, f - 1)
				l = tString:sub(l + 1, -1)
				tString = f .. QTHex .. l
			end
		end
		return tString

	end

	-- colour Gossip Panel quest text
	for i = 1, NUMGOSSIPBUTTONS do
		self:RawHook(_G["GossipTitleButton"..i], "SetFormattedText", function(this, fmt, ...)
			self.hooks[this].SetFormattedText(this, colourText(fmt), ...)
		end, true)
	end

	-- colour Quest Greeting Panel quest text
	for i = 1, MAX_NUM_QUESTS do
		self:RawHook(_G["QuestTitleButton"..i], "SetFormattedText", function(this, fmt, ...)
			self.hooks[this].SetFormattedText(this, colourText(fmt), ...)
		end, true)
	end

end
