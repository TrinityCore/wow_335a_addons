
GcdHackTracker = LibStub("AceAddon-3.0"):NewAddon("GcdHackTracker", "AceEvent-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("GcdHackTracker", true)

local version_ght_major = "0"
local version_ght_minor = "3"
local version_ght_fix = "0"

-- if this value is undercut, the GCD hack has been found
GCD_ALERT_VALUE = 1.3

-- value for the over time calculation
GCD_BALANCE_VALUE = 1.9

-- max entries of the log table per player
GCD_LOG_MAXENTRIES = 50

-- the last amount of log events to look at and divided by for the overall calculation and local shouting
GCD_NOTICE_TRESHOLD = 8

-- all spells, that benefit from the gcd hack
GCD_SPELL_CHECKS = {
	
	-- WARRIOR
	-- bladestorm only first hit
	[47486]		= true,		-- Mortal Strike
	[1680]		= true,		-- Whirlwind
	[47471]		= true,		-- Execute
	[57755]		= true,		-- Heroic Throw
	[12323]		= true,		-- Piercing Howl
	[1715]		= true,		-- Hamstring
	[5246]		= true,		-- Intimidating Shout
	[47465]		= true,		-- Rend
	[47440]		= true,		-- Commanding Shout
	[47436]		= true,		-- Battle Shout
	[47437]		= true,		-- Demoralizing Shout
	[7386]		= true,		-- Sunder Armor
	
	-- HUNTER
	[49050]		= true,		-- Aimed Shot
	[53209]		= true,		-- Chimera Shot
	[49045]		= true,		-- Arcane Shot
	[19503]		= true,		-- Scatter Shot
	[60192]		= true,		-- Freezing Arrow
	[49001]		= true,		-- Serpent Sting
	[14311]		= true,		-- Freezing Trap
	[13809]		= true,		-- Frost Trap
	[34600]		= true,		-- Snake Trap
	[53338]		= true,		-- Hunter's Mark
	[19801]		= true,		-- Tranquilizing Shot
	[5116]		= true,		-- Concurssive Shot
	[1543]		= true,		-- Flare
	[49056]		= true,		-- Immolation Trap
	[49067]		= true,		-- Explosive Trap
	[3043]		= true,		-- Scorpid Sting
	[3034]		= true,		-- Viper Sting
}

-- contains spells that have a special behaviour and make the next spell ignored.
GCD_IGNORE_CHECKS = {
	[49052]		= true,		-- Steady Shot
}

----
-- on itialize method.
function GcdHackTracker:OnInitialize()
	
	GcdHackTrackerData = GcdHackTrackerData or {
		enabled = true,
		shout = 1, -- 1 = guild, 2 = raid, 4 = party
		track = 1, -- 1 = everywhere, ...
		debug = false,
		busted = {}, -- all tracked players are here
	}
	
	self.watching = {} -- contains names of people who are to track
	self.log = {} -- saves the temporary logs
	self.noticed = {} -- storing player names, so the user won't be bothered every event
	self.watchee = "" -- name of the current watched
	self.temps = {} -- saves all temporary events of certain player
	
	self.gui = GHT_Gui:new()
	
	-- self.gui:createTrackFrame() TODO
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

----
-- tracks the combat log for all successful spell casts.
-- furthermore the spells are checked for potential gcd hack abuse, listed in GCD_SPELL_CHECKS list.
-- @param event
-- @param ... see http://www.wowwiki.com/API_COMBAT_LOG_EVENT
function GcdHackTracker:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...)
	
	if (type ~= "SPELL_CAST_SUCCESS") then
		return
	end
	
	if (GCD_SPELL_CHECKS[spellId]) then
		
		local dest, crit = "", ""
		if (destName) then dest = " -> " .. destName end
		if (critical) then crit = "(critical) " end
		
		local log = "[0.000] " .. sourceName .. " -> " .. spellName .. dest
		
		if (self.watching[sourceName]) then	
			-- add name to watch list, if already there -> touché
			
			local time, spell = strsplit(";", self.watching[sourceName])
				
			--if ((timestamp - time) < GCD_ALERT_VALUE) then
			if ((timestamp - time) < GCD_BALANCE_VALUE) then
				
				local gcd = floor(((timestamp - time))*1000)/1000
				
				local msg = "|cff5eafe8<GHT>|r " .. sourceName .. " > " .. gcd .. " sec GCD! (" .. spell .. " -> " .. spellName .. ")"
				local avgGcd = nil
				if (self.noticed[sourceName] and self.noticed[sourceName] >= GCD_NOTICE_TRESHOLD) then
					
					-- check overall
					avgGcd = self:calculateOverallGcd(sourceName)
					
					if (avgGcd < GCD_ALERT_VALUE) then
						local msg = "|cff5eafe8<GHT>|r " .. sourceName .. L.RUN_BUSTED .. L.RUN_AVGCOOLDOWN .. avgGcd .. " sec through " .. GCD_NOTICE_TRESHOLD .. " records."
						
						print(msg)
						self.noticed[sourceName] = 0
						
					end
				else
					if (not self.noticed[sourceName]) then 
						self.noticed[sourceName] = 1 
					else
						self.noticed[sourceName] = self.noticed[sourceName] + 1
					end
				end
				
				-- TODO shouting according to shout property
				
				local newlog = "[" .. gcd .. "] " .. sourceName .. " -> " .. spellName .. dest
				self.log[sourceName] = self.log[sourceName] .. ";" .. newlog .. ";" .. GetZoneText() .. ";" .. date("%m/%d/%y %H:%M:%S") .. ";" .. gcd
				
				if (not self.temps[sourceName]) then
					self.temps[sourceName] = {}
				end
				
				-- save only suspicious occurences
				if (avgGcd and avgGcd < GCD_ALERT_VALUE) then
					if (not GcdHackTrackerData.busted[sourceName]) then
						GcdHackTrackerData.busted[sourceName] = {}
					end
					
					for i = #self.temps[sourceName], #self.temps[sourceName] - GCD_NOTICE_TRESHOLD + 1, -1 do
						table.insert(GcdHackTrackerData.busted[sourceName], self.temps[sourceName][i])
					end
				end
				table.insert(self.temps[sourceName], self.log[sourceName])
				self.log[sourceName] = log
				
				-- to keep the temporary table as small as needed
				if (#self.temps[sourceName] > GCD_NOTICE_TRESHOLD) then
					table.remove(self.temps[sourceName], 1)
				end
				
				-- setting newest watched skill
				self.watching[sourceName] = timestamp .. ";" .. spellName
			else
				
				-- if GCD is fine, renew name
				self.watching[sourceName] = timestamp .. ";" .. spellName
				self.log[sourceName] = log
			end
			
		else
			
			self.watching[sourceName] = timestamp .. ";" .. spellName
			self.log[sourceName] = log
		end
			
	end
	
end

function GcdHackTracker:cutString(str)
	return strsplit(";", str)
end

----
-- registers the COMBAT_LOG_EVENT_UNFILTERED if the tracker is enabled, otherwise removes it.
-- @param val boolean
function GcdHackTracker:registerLogEvents(val)
	
	if (val) then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

----
-- gives out the current addon version as <major.minro.fix>.
-- @return formatted addon version
function GcdHackTracker:getVersion()
	
	return version_ght_major .. "." .. version_ght_minor .. "." .. version_ght_fix
end

----
-- shows the gui and if it hasn't been initialized it will be.
function GcdHackTracker:showGui()
	
	if (not self.gui.frame) then
		self.gui:createTrackFrame()
	else
		self.gui.frame:Show()
	end
	
	GHT_updateVerticalScrollFrame()
	self:updateDetails(nil)
	
end


----
-- global function for updating the vertical scroll frame that holds spotted names.
function GHT_updateVerticalScrollFrame()
	local index, cycle, i, size, max, buttons = 0, 1, 1, 0, 0, _G["GcdHackTracker"]:getButtonAmount()
	
	local offset = FauxScrollFrame_GetOffset(_G["GHTrackerProofs"])
	
	for k,v in pairs(GcdHackTrackerData.busted) do
		size = size + 1
	end
	
	FauxScrollFrame_Update(_G["GHTrackerProofs"], size, buttons, 20, nil, nil, nil, nil, nil, nil, true);
	
	index = offset + 1
	max = index + buttons
	for k,v in pairs(GcdHackTrackerData.busted) do
	
		if (cycle >= index and cycle < max) then
			
			_G["GHTrackerProofsEntry" .. i]:SetText(k);
			_G["GHTrackerProofsEntry" .. i]:Show();
					
			i = i + 1
			index = index + 1
		end
		
		cycle = cycle + 1
	end
	
	if (buttons - index > 0) then
		for j = buttons, index, -1 do
			_G["GHTrackerProofsEntry" .. j]:Hide();
		end
	end
	
end

----
-- update function for the detail scrolling frame.
function GHT_updateVerticalScrollDetailFrame()
	
	local t = _G["GcdHackTracker"]:getCurrentWatchee()
	local index, cycle, i, max = 1, 1, 1, 0
	
	if (t) then
		
		local offset = FauxScrollFrame_GetOffset(_G["GHTrackerDetail"])
		
		FauxScrollFrame_Update(_G["GHTrackerDetail"], #t, 4, 45, nil, nil, nil, nil, nil, nil, true);
		
		index = offset + 1
		max = index + 4
		for k,v in pairs(t) do
			
			if (cycle >= index and cycle < max) then
				
				local log1, log2, location, time, gcd = strsplit(";", v)
				
				_G["GHTrackerDetailHead" .. i]:SetText(time .. " in " .. location .. " (" .. gcd .. " sec)");
				_G["GHTrackerDetailHead" .. i]:Show();
				
				_G["GHTrackerDetailHead" .. i .. "Sub"]:SetText(log1);
				_G["GHTrackerDetailHead" .. i .. "Sub"]:Show()
				
				_G["GHTrackerDetailHead" .. i .. "SubSub"]:SetText(log2);
				_G["GHTrackerDetailHead" .. i .. "SubSub"]:Show()
				
				i = i + 1
				index = index + 1
			end
			
			cycle = cycle + 1
		end
		
	end
	
	-- hide unused text
	if (5 - index > 0) then
		for j = 5 - index, 1, -1 do
			_G["GHTrackerDetailHead" .. 5-j]:Hide()
			_G["GHTrackerDetailHead" .. 5-j .. "Sub"]:Hide()
			_G["GHTrackerDetailHead" .. 5-j .. "SubSub"]:Hide()
		end
	end
end


----
-- returns a whole list of the current watched player.
-- @return list
function GcdHackTracker:getCurrentWatchee()
	
	if (self.watchee ~= "") then
		return GcdHackTrackerData.busted[self.watchee]
	end
	return nil
end


----
-- returns the amount of buttons that can be hold in the scroll frame.
-- @return amount
function GcdHackTracker:getButtonAmount()
	return self.gui.buttons
end

----
-- updates the right side of the frame with detail information to the clicked player.
-- @param target player's name
function GcdHackTracker:updateDetails(target)
	if (target) then
		
		local t = GcdHackTrackerData.busted[target]
		local maxGcd, i = 0, 0
		
		self.gui.fldName:SetText(target)
		self.gui.fldEvidence:SetText(#t .. " (ø " .. self:calculateAverageGcd(t) .. " sec)")
		
		self.gui.btnDelete:Enable()
		self.gui.btnShout:Enable()
		
		self.watchee = target
		
	else
		self.gui.fldName:SetText("")
		self.gui.fldEvidence:SetText("")
		
		self.gui.btnDelete:Disable()
		self.gui.btnShout:Disable()
	end
	
	for i=1, self.gui.buttons do
		if (_G["GHTrackerProofsEntry" .. i]:IsShown() and _G["GHTrackerProofsEntry" .. i]:GetText() == target) then
			_G["GHTrackerProofsEntry" .. i]:GetFontString():SetTextColor(1, 1, 1)
		elseif (_G["GHTrackerProofsEntry" .. i]:IsShown() and _G["GHTrackerProofsEntry" .. i]:GetText()) then
			_G["GHTrackerProofsEntry" .. i]:GetFontString():SetTextColor(0.6, 0.6, 0.6)
		end
	end
	
	GHT_updateVerticalScrollDetailFrame()
end

----
-- deletes a selected entry from the list.
function GcdHackTracker:deleteEntry()
	
	GcdHackTrackerData.busted[self.watchee] = nil
	self.watchee = ""
	
	GHT_updateVerticalScrollFrame()
	self:updateDetails()
	
	print("|cff5eafe8<GHT>|r " .. L.RUN_DELETED)
end

----
-- sends a message with all the evidence of the selected player to the guild channel or self if not in a guild.
function GcdHackTracker:shoutEvidence()
	
	local t = GcdHackTrackerData.busted[self.watchee]
	local msg = self.watchee .. " " .. L.RUN_BUSTED .. L.RUN_AVGCOOLDOWN .. self:calculateAverageGcd(t) .. "sec. (" .. L.RUN_EVIDENCESMALL .. ": " .. #t .. ")"
	
	-- check if guild etc
	if (IsInGuild() == 1) then
		SendChatMessage("<GHT> " .. msg, "GUILD")
	else
		print(msg)
	end
end

----
-- calculates the average gcd from all entries.
-- @param t table of watched player
-- @return gcd in x.xxx format
function GcdHackTracker:calculateAverageGcd(t)
	local i, gcdTotal = 0, 0
	for k,v in pairs(t) do
		
		local _, _, _, _, gcd = strsplit(";", v)
		gcdTotal = gcdTotal + gcd
		i = i + 1
	end
	return floor(gcdTotal/i*1000)/1000
end

----
-- will be called after the close button has been pressed.
function GcdHackTracker:closeFrame()
	
	self.watchee = ""
	GHT_updateVerticalScrollFrame()
	self:updateDetails()
end

----
-- calculates the overall used gcd value of the omitted player.
-- @param nameplayer name
function GcdHackTracker:calculateOverallGcd(name)
	
	local t = self.temps[name]
	local gcd, i, total, num = 0, 0, 0, 0
	
	for i = #t, #t - GCD_NOTICE_TRESHOLD + 1, -1 do
		if (t[i]) then
			_, _, _, _, gcd = strsplit(";", t[i])
			total = total + tonumber(gcd)
			num = num + 1
		else
			print(i) -- TODO REMOVE
		end
	end
	
	return floor(total/num*1000)/1000
	
end