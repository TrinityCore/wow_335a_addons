--[[
	Auctioneer - ScanData
	Version: 5.7.4568 (KillerKoala)
	Revision: $Id: ScanData.lua 4496 2009-10-08 22:15:46Z Nechckn $
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

local libType, libName = "Util", "ScanData"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local print,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()

local data

private.cache = {}
function lib.Processor(callbackType, ...)
	if (callbackType == "tooltip") then
		private.ProcessTooltip(...)
	elseif (callbackType == "scanstats") then
		private.cache = {}
	end
end

--[[ Local functions ]]--
local Const = AucAdvanced.Const

local itemWorth = {}
local colorDist = {
	exact = { red=0, orange=0, yellow=0, green=0, blue=0 },
	suffix = { red=0, orange=0, yellow=0, green=0, blue=0 },
	base = { red=0, orange=0, yellow=0, green=0, blue=0 },
    stack = { },
	all = { red=0, orange=0, yellow=0, green=0, blue=0 },
}
local tmp = {}
function lib.Colored(doIt, counts, alt, shorten)
	local n=0
	if (counts.blue > 0) then
		n=n+1
		if shorten and counts.blue>=1000 then
			tmp[n] = format("|cff3399ff%dk|r", floor(counts.blue/1000+0.5))
		else
			tmp[n] = format("|cff3399ff%d|r", counts.blue)
		end
	end
	if (counts.green > 0) then
		n=n+1
		if shorten and counts.green>=1000 then
			tmp[n] = format("|cff33ff44%dk|r", floor(counts.green/1000+0.5))
		else
			tmp[n] = format("|cff33ff44%d|r", counts.green)
		end
	end
	if (counts.yellow > 0) then
		n=n+1
		if shorten and counts.yellow>=1000 then
			tmp[n] = format("|cffffff00%dk|r", floor(counts.yellow/1000+0.5))
		else
			tmp[n] = format("|cffffff00%d|r", counts.yellow)
		end
	end
	if (counts.orange > 0) then
		n=n+1
		if shorten and counts.orange>=1000 then
			tmp[n] = format("|cffff9900%dk|r", floor(counts.orange/1000+0.5))
		else
			tmp[n] = format("|cffff9900%d|r", counts.orange)
		end
	end
	if (counts.red > 0) then
		n=n+1
		if shorten and counts.red>=1000 then
			tmp[n] = format("|cffff0000%dk|r", floor(counts.red/1000+0.5))
		else
			tmp[n] = format("|cffff0000%d|r", counts.red)
		end
	end
	local text = table.concat(tmp, " / ", 1, n)
	if alt then
		if text then
			text = "( "..text.." )"
		else
			text = alt
		end
	end
	return text
end

function lib.GetImageCounts(hyperlink, maxPrice, items)
	local scandata = AucAdvanced.Scan.GetScanData()

	local itemID, itemSuffix, itemFactor
	if type(hyperlink) == "number" then
		itemID = hyperlink
		itemSuffix = 0
		itemFactor = 0
	else
		local iType, iID, iSuffix, iFactor = AucAdvanced.DecodeLink(hyperlink)
		if iType == "item" then
			itemID = iID
			itemSuffix = iSuffix
			itemFactor = iFactor
		end
	end

	local totalBid, totalBuy = 0

	local n = #(scandata.image)
	local v, vID, vSuffix, vFactor, vSig, vLink, vLevel, vPer, vColor, vBid, vBuy, _
	for i=1, n do
		v = scandata.image[i]
		vID = v[Const.ITEMID]
		if (vID == iID) then
			vSuffix = v[Const.SUFFIX]
			vFactor = v[Const.FACTOR]
			vCount = v[Const.COUNT]

			if (vSuffix == iSuffix) then
				if (vFactor == iFactor) then
					vBid = v[Const.PRICE]
					vBuy = v[Const.BUYOUT]

					local matched = false
					if (maxPrice) then
						if (vBuy and vBuy > 0 and vBuy < maxPrice) then
							totalBuy = totalBuy + count
							matched = true
						elseif (not maxPrice or vBid < maxPrice) then
							totalBid = totalBid + count
							matched = true
						end
					else
						if (vBuy and vBuy > 0) then
							totalBuy = totalBuy + 1
							matched = true
						else
							totalBid = totalBid + 1
							matched = true
						end
					end
					if items and matched then
						table.insert(items, v)
					end
				end
			end
		end
	end

	return totalBuy, totalBid
end

function lib.GetDistribution(hyperlink)

	local iType, iID, iSuffix, iFactor = AucAdvanced.DecodeLink(hyperlink)
	local sig = strjoin(":", iID, iSuffix, iFactor)
	if private.cache[sig] then return unpack(private.cache[sig]) end

	local scandata = AucAdvanced.Scan.GetScanData()

	local calcLevel, doColor, myColors
    myColors = {}
	for k,v in pairs(colorDist) do
		myColors[k] = {}
		for c,n in pairs(v) do
			myColors[k][c] = 0
		end
	end
    while (#itemWorth>0) do table.remove(itemWorth) end

	local exact, suffix, base = 0,0,0

    if (AucAdvanced.Modules.Util and AucAdvanced.Modules.Util.PriceLevel) then
        calcLevel = AucAdvanced.Modules.Util.PriceLevel.CalcLevel
	else
        -- Don't have functions to calculate color code.
        return exact, suffix, base, myColors
    end

	local n = #(scandata.image)
	local v, vID, vSuffix, vFactor, vSig, vLink, vLevel, vPer, vColor, vBid, vBuy, _
	for i=1, n do
		v = scandata.image[i]
		vID = v[Const.ITEMID]
		if (vID == iID) then
			vSuffix = v[Const.SUFFIX]
			vFactor = v[Const.FACTOR]
			vCount = v[Const.COUNT]

			if (calcLevel) then
				vLink = v[Const.LINK]
				vBid = v[Const.PRICE]
				vBuy = v[Const.BUYOUT]
				vSig = ("%d:%d:%d"):format(vID, vSuffix, vFactor)
				vLevel, vPer, _,_,_, vColor, itemWorth[vSig] = calcLevel(vLink, vCount, vBid, vBuy, itemWorth[vSig])
			end

			if (vSuffix == iSuffix) then
				if (vFactor == iFactor) then
					exact = exact + vCount
					if (vColor) then
						myColors.exact[vColor] = myColors.exact[vColor] + vCount
					end
				else
					suffix = suffix + vCount
					if (vColor) then
						myColors.suffix[vColor] = myColors.suffix[vColor] + vCount
					end
				end
			else
				base = base + vCount
				if (vColor) then
					myColors.base[vColor] = myColors.base[vColor] + vCount
				end
			end
			if (vColor) then
				myColors.all[vColor] = myColors.all[vColor] + vCount
                -- Set up colours per stack size as well.
                if not myColors.stack[vCount] then myColors.stack[vCount] =  { red=0, orange=0, yellow=0, green=0, blue=0 } end
                myColors.stack[vCount][vColor] = myColors.stack[vCount][vColor] + vCount
			end
		end
	end

	private.cache[sig] = {exact, suffix, base, myColors}
	return exact, suffix, base, myColors
end

function private.ProcessTooltip(tooltip, name, hyperlink, quality, quantity, cost)
	local getter = AucAdvanced.Settings.GetSetting
	if not getter("scandata.tooltip.display") then return  end

	tooltip:SetColor(0.3, 0.9, 0.8)

	local full = false
	if (getter("scandata.tooltip.modifier") and IsShiftKeyDown()) then
		full = true
	end

	local doColor = true
	local exact, suffix, base, dist = lib.GetDistribution(hyperlink)
    local stacksize

	if full and (base+suffix+exact > 0) then
		tooltip:AddLine("Items in image:")
		if (exact > 0) then
			tooltip:AddLine("  |cffddeeff"..exact.."|r exact "..lib.Colored(doColor, dist.exact, "matches"))
		end
		if (suffix > 0) then
			tooltip:AddLine("  |cffddeeff"..suffix.."|r suffix "..lib.Colored(doColor, dist.suffix, "matches"))
		end
		if (base > 0) then
			tooltip:AddLine("  |cffddeeff"..base.."|r base "..lib.Colored(doColor, dist.base, "matches"))
		end
        if (dist.stack) then
            for stackSize, stackColor in pairs(dist.stack) do
                tooltip:AddLine("  Stacks of "..stackSize.."  "..lib.Colored(doColor, stackColor, "in image"))
            end
        end
	elseif base+suffix+exact > 0 then
		if (suffix+base > 0) then
			tooltip:AddLine("|cffddeeff"..exact.." +"..(suffix+base).."|r matches "..lib.Colored(doColor, dist.all, "in image"))
		else
            tooltip:AddLine("|cffddeeff"..exact.."|r matches "..lib.Colored(doColor, dist.exact, "in image"))
		end
	else
		tooltip:AddLine("No matches in image.")
	end
end

function lib.Unpack(realm)
	if not (AucScanData and AucScanData.scans) then return end
	if not realm then realm = GetRealmName() end
	local sData = AucScanData.scans[realm]
	if not sData then return end

	for faction, fData in pairs(sData) do
		if fData.image and type(fData.image) == "string" then
			if fData.image ~= "rope" then
				fData.ropes = { fData.image }
			end

			fData.image = {}
			for pos, rope in ipairs(fData.ropes) do
				local loader, err = loadstring(rope)
				if (loader) then
					local items = loader()
					for pos, item in ipairs(items) do
						tinsert(fData.image, item)
					end
				else
					print("Error loading scan image: {{", err, "}}")
					fData.image = nil --clear the image, so we're not left with a string where we expect a table.
				end
			end

			collectgarbage()
		end
	end
end

function lib.OnLoad()
	lib.Unpack()
end

function lib.OnUnload()
	local StringRope = LibStub:GetLibrary("StringRope")
	local rope = StringRope:New(-1)

	local maxLen = 2^22

	if not (AucScanData and AucScanData.scans) then return end

	-- Convert all image data to loadstring strings
	for server, sData in pairs(AucScanData.scans) do
		for faction, fData in pairs(sData) do
			if fData.image and type(fData.image) == "table" then
				fData.ropes = {}
				rope:Add("return {")
				local fCount = #fData.image
				for i = 1, fCount do
					local item = fData.image[i]
					if item and type(item) == "table" then
						rope:Add("{")
						local pos = 1
						while item[pos] or item[pos+1] or item[pos+2] or item[pos+3] do
							local v = item[pos]
							if v == nil then
								rope:Add("nil,")
							else
								local t = type(v)
								if t == "string" then
									rope:Add(("%q,"):format(v))
								elseif t == "number" then
									rope:Add(v..",")
								elseif t == "boolean" then
									rope:Add(tostring(v)..",")
								else
									rope:Add("nil--[["..t.."]],")
								end
							end
							pos = pos + 1
						end
						rope:Add("},")
					elseif item == nil then
						rope:Add("nil,")
					else
						rope:Add("nil--[["..type(item).."]],")
					end
					if rope.len and rope.len > maxLen then
						rope:Add("}");
						tinsert(fData.ropes, rope:Get())
						rope:Clear()
						rope:Add("return {")
					end
				end
				rope:Add("}")
				fData.image = "rope"
				tinsert(fData.ropes, rope:Get())
				rope:Clear()
			end
		end
	end
end

AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.7/Auc-ScanData/ScanData.lua $", "$Rev: 4496 $")
