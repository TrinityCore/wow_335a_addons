--[[
	Auctioneer - AucClassic Statistics module
	Version: 5.7.4568 (KillerKoala)
	Revision: $Id: StatClassic.lua 4496 2009-10-08 22:15:46Z Nechckn $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds statistical history to the auction data that is collected
	when the auction is scanned, so that you can easily determine what price
	you will be able to sell an item for at auction or at a vendor whenever you
	mouse-over an item in the game

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
if not AucAdvanced then return end

local libType, libName = "Stat", "Classic"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local print,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()

local data

function private.makeData()
	if data then return end
	if (not AucAdvancedStatClassicData) then AucAdvancedStatClassicData = {} end
	data = AucAdvancedStatClassicData
end

function lib.CommandHandler(command, ...)
	if (not data) then private.makeData() end
	local myFaction = AucAdvanced.GetFaction()
	if (command == "help") then
		print("Help for Auctioneer Advanced - "..libName)
		local line = AucAdvanced.Config.GetCommandLead(libType, libName)
		print(line, "help}} - this", libName, "help")
		print(line, "import}} - import prices from AucClassic")
	elseif (command == "import") then
		lib.Import(...)
	end
end

function lib.Processor(callbackType, ...)
	if (not data) then private.makeData() end
	if (callbackType == "tooltip") then
		lib.ProcessTooltip(...)
	elseif (callbackType == "config") then
		--Called when you should build your Configator tab.
		private.SetupConfigGui(...)
	elseif (callbackType == "load") then
		lib.OnLoad(...)
	end
end

do
    -- Inverse Z table
    local inverseZ = {
        [1] = 0,
        [.4960*2] = .01*2,
        [.4920*2] = .02*2,
        [.4880*2] = .03*2,
        [.4840*2] = .04*2,
        [.4801*2] = .05*2,
        [.4761*2] = .06*2,
        [.4721*2] = .07*2,
        [.4681*2] = .08*2,
        [.4641*2] = .09*2,
        [.4602*2] = .10*2,
        [.4562*2] = .11*2,
        [.4522*2] = .12*2,
        [.4483*2] = .13*2,
        [.4443*2] = .14*2,
        [.4404*2] = .15*2,
        [.4364*2] = .16*2,
        [.4325*2] = .17*2,
        [.4286*2] = .18*2,
        [.4247*2] = .19*2,
        [.4207*2] = .20*2,
        [.4168*2] = .21*2,
        [.4129*2] = .22*2,
        [.4090*2] = .23*2,
        [.4052*2] = .24*2,
        [.4013*2] = .25*2,
        [.3974*2] = .26*2,
        [.3936*2] = .27*2,
        [.3897*2] = .28*2,
        [.3859*2] = .29*2,
        [.3821*2] = .30*2,
        [.3783*2] = .31*2,
        [.3745*2] = .32*2,
        [.3707*2] = .33*2,
        [.3669*2] = .34*2,
        [.3632*2] = .35*2,
        [.3594*2] = .36*2,
        [.3557*2] = .37*2,
        [.3620*2] = .38*2,
        [.3483*2] = .39*2,
        [.3446*2] = .40*2,
        [.3409*2] = .41*2,
        [.3372*2] = .42*2,
        [.3336*2] = .43*2,
        [.3300*2] = .44*2,
        [.3264*2] = .45*2,
        [.3228*2] = .46*2,
        [.3192*2] = .47*2,
        [.3156*2] = .48*2,
        [.3121*2] = .49*2,
        [.3085*2] = .50*2,
        [.3050*2] = .51*2,
        [.3015*2] = .52*2,
        [.2981*2] = .53*2,
        [.2946*2] = .54*2,
        [.2912*2] = .55*2,
        [.2877*2] = .56*2,
        [.2843*2] = .57*2,
        [.2810*2] = .58*2,
        [.2776*2] = .59*2,
        [.2743*2] = .60*2,
        [.2709*2] = .61*2,
        [.2676*2] = .62*2,
        [.2643*2] = .63*2,
        [.2611*2] = .64*2,
        [.2578*2] = .65*2,
        [.2546*2] = .66*2,
        [.2514*2] = .67*2,
        [.2483*2] = .68*2,
        [.2420*2] = .70*2,
        [.2266*2] = .75*2,
        [.2119*2] = .80*2,
        [.1977*2] = .85*2,
        [.1841*2] = .90*2,
        [.1711*2] = 1.0*2,
        [.1357*2] = 1.1*2,
        [.1151*2] = 1.2*2,
        [.0968*2] = 1.3*2,
        [.0808*2] = 1.4*2,
        [.0668*2] = 1.5*2,
        [.0548*2] = 1.6*2,
        [.0446*2] = 1.7*2,
        [.0359*2] = 1.8*2,
        [.0287*2] = 1.9*2,
        [.0228*2] = 2.0*2,
        [.0179*2] = 2.1*2,
        [.0139*2] = 2.2*2,
        [.0107*2] = 2.3*2,
        [.0082*2] = 2.4*2,
        [.0062*2] = 2.5*2,
        [.0047*2] = 2.6*2,
        [.0035*2] = 2.7*2,
        [.0026*2] = 2.8*2,
        [.0019*2] = 2.9*2,
        [.0013*2] = 3.0*2
    };

    -- Build the keys list (so we can use ipairs)
    local inverseZKeys = {};
    for k,v in pairs(inverseZ) do
        table.insert(inverseZKeys, k);
    end
    table.sort(inverseZKeys);

    local ipairs = ipairs;
    local sqrt = math.sqrt;
    local curve = AucAdvanced.API.GenerateBellCurve();

    function lib.GetItemPDF(link, key)
    	if not get("stat.classic.enable") then return end --disable classic if desired

        -- First, obtain price lookup
        local median, seen, confidence = lib.GetPrice(link, key);
        if not median or median == 0 or confidence == 0 then return; end
        -- Go through the inverse Z table and look for the nearest value that is less than the confidence
        local nearest = inverseZ[inverseZKeys[1]];
        for _, k in ipairs(inverseZKeys) do
            if inverseZ[k] > confidence then break; end
            nearest = inverseZ[k];
        end
		if not nearest or nearest == 0 then nearest = 0.1 end

        local stddev = median * nearest / sqrt(seen);   -- unbiased population estimate from inverse Z lookup
        curve:SetParameters(median, stddev);
        return curve, median - stddev * 3, median + stddev * 3;
    end
end


function lib.GetPrice(hyperlink, ahKey)
	if not get("stat.classic.enable") then return end --disable classic if desired

	if (not data) then private.makeData() end
	local linkType,itemId,property,factor,enchant = AucAdvanced.DecodeLink(hyperlink)
	if (linkType ~= "item") then return end
	if not ahKey then
		ahKey = AucAdvanced.GetFaction()
	end
	ahKey = ahKey:lower()
	local median, seen, confidence = 0, 0, 0.1
	local lastdata
	local ItemString = strjoin(":",itemId,property,enchant)
	local a, b, c = 0,0,0
	if Auctioneer and Auctioneer.Statistic and Auctioneer.Statistic.GetUsableMedian then
		median, seen = Auctioneer.Statistic.GetUsableMedian(ItemString, ahKey)
		--print(median, seen)
		if median and (median > 0) then
			confidence = 1 - math.exp(-seen/30)
			private.StoreData(ItemString, median, seen, ahKey)
		end
	else
		if not data[ahKey] then return end
		if not data[ahKey][ItemString] then return end
		median, seen, lastdata = strsplit(",", data[ahKey][ItemString])
		median = tonumber(median)
		seen = tonumber(seen)
		lastdata = tonumber(lastdata)
		confidence = 1 - math.exp(-seen/30)
		local age = time()
		age = 2^((age - lastdata)/300000)
		confidence = confidence/(age) --half confidence every week
	end

	return median, seen, confidence
end

function lib.GetPriceColumns()
	return "Median","Seen", "Confidence"
end

local array = {}
function lib.GetPriceArray(hyperlink, ahKey)
	if not get("stat.classic.enable") then return end --disable classic if desired

	-- Clean out the old array
	while (#array > 0) do table.remove(array) end

	-- Get our statistics
	local median, seen, confidence = lib.GetPrice(hyperlink, ahKey)

	-- These 3 are the ones that most algorithms will look for
	array.price = median
	array.seen = seen
	array.confidence = confidence

	-- Return a temporary array. Data in this array is
	-- only valid until this function is called again.
	return array
end

AucAdvanced.Settings.SetDefault("stat.classic.tooltip", false)
AucAdvanced.Settings.SetDefault("stat.classic.enable", true)
AucAdvanced.Settings.SetDefault("stat.classic.enable", true)

function private.SetupConfigGui(gui)
	local id = gui:AddTab(lib.libName, lib.libType.." Modules")
	--gui:MakeScrollable(id)

	gui:AddHelp(id, "what classic stats",
		"What are Classic stats?",
		"This module provides access to the older Classic stats. It is provided as a method to support an upgrade path. With both Auctioneer Classic and AucAdv enabled type\n |CFFFF0000/aadv stat classic import|r \nto import the statistics to AucAdv. This will import all of your old statistics and provide them in-game. Once this has been done, you can then turn off Classic Auctioneer, while still having access to your stats.")

	gui:AddControl(id, "Header",     0,    libName.." options")
	gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
	gui:AddControl(id, "Checkbox",   0, 1, "stat.classic.enable", "Enable Classic Stats")
	gui:AddTip(id, "Allow Stats from Auctioneer Classic to gather and return price data")
	gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
	gui:AddControl(id, "Checkbox",   0, 1, "stat.classic.tooltip", "Show classic stats in the tooltips?")
	gui:AddTip(id, "Toggle display of stats from the classic module on or off")

end

function lib.ProcessTooltip(tooltip, name, hyperlink, quality, quantity, cost, ...)
	-- In this function, you are afforded the opportunity to add data to the tooltip should you so
	-- desire. You are passed a hyperlink, and it's up to you to determine whether or what you should
	-- display in the tooltip.

	if not AucAdvanced.Settings.GetSetting("stat.classic.tooltip") then return end

	if not quantity or quantity < 1 then quantity = 1 end
	local median, seen, confidence = lib.GetPrice(hyperlink)

	tooltip:SetColor(0.3, 0.9, 0.8)

	if (median and median > 0) then
		tooltip:AddLine("AucClassic price: (x"..quantity..")", median*quantity)

		if (quantity > 1) then
			tooltip:AddLine("  (or individually)", median)
		end
		tooltip:AddLine("  Seen Count: |cffddeeff"..seen.."|r")
	end
end

function lib.OnLoad(addon)
	private.updater = CreateFrame("Frame", nil, UIParent)
	private.updater:SetScript("OnUpdate", private.OnUpdate)

	private.makeData()
end

function lib.ClearItem(hyperlink, ahKey)
	local linkType, itemID, property, factor, enchant = AucAdvanced.DecodeLink(hyperlink)
	if (linkType ~= "item") then
		return
	end
	local ItemString = strjoin(":",itemID,property,enchant)
	if not ahKey then ahKey = AucAdvanced.GetFaction() end
	ahKey = ahKey:lower()
	if (not data) then private.makeData() end
	if (data[ahKey]) then
		print(libType.."-"..libName..": clearing data for "..hyperlink.." for {{"..ahKey.."}}")
		data[ahKey][ItemString] = nil
	end
end

--[[ Local functions ]]--
local importstarted = false
function lib.ImportRoutine()
	importstarted = true
	if Auctioneer and Auctioneer.Statistic and Auctioneer.Statistic.GetUsableMedian then
		--local ahKey = AucAdvanced.GetFaction()
		--local ahKey = ahKey:lower()
		local ClassicData = {}
		if AuctioneerHistoryDB then
			ClassicData = AuctioneerHistoryDB
		else
			print("AuctioneerHistoryDB not found")
		end
		for ahKey, k in pairs(ClassicData) do
			if ClassicData[ahKey]["buyoutPrices"] then
				local i = 0
				print("Importing "..ahKey)
				for itemKey, v in pairs(ClassicData[ahKey]["buyoutPrices"]) do
					local median, seen = Auctioneer.Statistic.GetUsableMedian(itemKey, ahKey)
					if median and seen then
						private.StoreData(itemKey, median, seen, ahKey)
					end
					i = i + 1
					if ((i/200) == floor(i/200)) then
						if ((i/1000) == floor(i/1000)) then
							print("Auc-Stat-Classic: Imported "..i)--.." of "..#(ClassicData[ahKey]["buyoutPrices"]))
						end
						coroutine.yield()
					end
				end
				print("Auc-Stat-Classic: Finished importing "..i.." items for "..ahKey.." from AucClassic")
			else
				print("No data for "..ahKey.." available")
			end
		end
	else
		print("AucClassic must be loaded to import any data from it")
	end
	importstarted = false
end

local co = coroutine.create(lib.ImportRoutine)

function lib.Import()
	if (coroutine.status(co) ~= "suspended") then
		co = coroutine.create(lib.ImportRoutine)
	end
	if (coroutine.status(co) ~= "dead") then
		coroutine.resume(co)
	end
end

local flip, flop = false, false
function private.OnUpdate()
	if importstarted then
		if (coroutine.status(co) == "suspended") then
			flip = not flip
			if flip then
				flop = not flop
				if flop then
					lib.Import()
				end
			end
		end
	end
end

function private.DataLoaded()
	-- This function gets called when the data is first loaded. You may do any required maintenence
	-- here before the data gets used.

end


function private.StoreData(ItemString, median, seen, ahKey)
	if (not data) then private.makeData() end
	local now = time()
	if not ahKey then
		ahKey = AucAdvanced.GetFaction()
	end
	ahKey = ahKey:lower()
	local PriceString = strjoin(",", median, seen, time())
	--print(PriceString)
	if not data[ahKey] then data[ahKey] = {} end
	data[ahKey][ItemString] = PriceString
end

AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.7/Auc-Stat-Classic/StatClassic.lua $", "$Rev: 4496 $")
