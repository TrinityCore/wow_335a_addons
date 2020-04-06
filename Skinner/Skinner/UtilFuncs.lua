local aName, Skinner = ...
local _G = _G

local function makeString(t)

	if type(t) == "table" then
		if type(rawget(t, 0)) == "userdata" and type(t.GetObjectType) == "function" then
			return ("<%s:%s:%s>"):format(tostring(t), t:GetObjectType(), t:GetName() or "(Anon)")
		end
	end

	return tostring(t)

end
local function makeText(a1, ...)

	local tmpTab = {}
	local output = ""

	if a1:find("%%") and select('#', ...) >= 1 then
		for i = 1, select('#', ...) do
			tmpTab[i] = makeString(select(i, ...))
		end
		output = output .. " " .. a1:format(unpack(tmpTab))
	else
		tmpTab[1] = output
		tmpTab[2] = a1
		for i = 1, select('#', ...) do
			tmpTab[i+2] = makeString(select(i, ...))
		end
		output = table.concat(tmpTab, " ")
	end

	return output

end
local function printIt(text, frame, r, g, b)

	(frame or DEFAULT_CHAT_FRAME):AddMessage(text, r, g, b, 1, 5)

end
--[===[@debug@
function printTS(...)
	print(("[%s.%03d]"):format(date("%H:%M:%S"), (GetTime() % 1) * 1000), ...)
end
function Skinner:Debug(a1, ...)

	local output = ("|cff7fff7f(DBG) %s:[%s.%03d]|r"):format(aName, date("%H:%M:%S"), (GetTime() % 1) * 1000)

	printIt(output.." "..makeText(a1, ...), self.debugFrame)

end
--@end-debug@]===]
--@non-debug@
function Skinner:Debug() end
--@end-non-debug@

function Skinner:CustomPrint(r, g, b, a1, ...)

	local output = ("|cffffff78"..aName..":|r")

	printIt(output.." "..makeText(a1, ...), nil, r, g, b)

end

function Skinner:SetupCmds()

	-- define some helpful slash commands (ex Baddiel)
	self:RegisterChatCommand("rl", function(msg) ReloadUI() end)
	self:RegisterChatCommand("lo", function(msg) Logout() end)
	self:RegisterChatCommand("pl", function(msg) local itemLink = select(2, GetItemInfo(msg)) local pLink = gsub(itemLink, "|", "||") print(msg, "is", pLink) end)
	self:RegisterChatCommand("ft", function(msg) local lvl, fName = "Parent", GetMouseFocus() print(makeText("Frame is %s, %s, %s", fName, fName:GetFrameLevel(), fName:GetFrameStrata())) while fName:GetParent() do fName = fName:GetParent() print(makeText("%s is %s, %s, %s", lvl, fName, (fName:GetFrameLevel() or "<Anon>"), (fName:GetFrameStrata() or "<Anon>"))) lvl = (lvl:find("Grand") and "Great" or "Grand")..lvl end end)
	self:RegisterChatCommand("si", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus(), true, false) end)
	self:RegisterChatCommand("sid", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus(), true, true) end)
	self:RegisterChatCommand("sib", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus(), false, false) end)
	self:RegisterChatCommand("sp", function(msg) return Spew and Spew("xyz", _G[msg]) end)

end

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function safecall(funcName, LoD, quiet)
	-- handle errors from internal functions
	local success, err = xpcall(function() return Skinner[funcName](Skinner, LoD) end, errorhandler)
	if quiet then
--		print(funcName, success, err)
		return success, err
	end
	if not success then
		if Skinner.db.profile.Errors then
			Skinner:CustomPrint(1, 0, 0, "Error running", funcName)
		end
	end
end

function Skinner:add2Table(table, value)

    table[#table + 1] = value

end

function Skinner:checkAndRun(funcName, quiet)
--	self:Debug("checkAndRun:[%s]", funcName or "<Anon>")

	if type(self[funcName]) == "function" then
		return safecall(funcName, nil, quiet)
	else
		if not quiet and self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, "function ["..funcName.."] not found in "..aName)
		end
	end

end

function Skinner:checkAndRunAddOn(addonName, LoD, addonFunc)

	if not addonFunc then addonFunc = addonName end

--    self:Debug("checkAndRunAddOn:[%s, %s, %s, %s, %s]", addonName, LoD, IsAddOnLoaded(addonName), IsAddOnLoadOnDemand(addonName), type(self[addonFunc]))

	-- don't skin any Addons whose skins are flagged as disabled
	if self.db.profile.DisabledSkins[addonName] then
		if self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, addonName, "not skinned, flagged as disabled")
		end
		return
	end

	if not IsAddOnLoaded(addonName) then
		-- deal with Addons under the control of an LoadManager
		if IsAddOnLoadOnDemand(addonName) and not LoD then
--			self:Debug(addonName, "is managed by a LoadManager, converting to LoD status")
			self.lmAddons[addonName:lower()] = addonFunc -- store with lowercase addonname (AddonLoader fix)
		-- Nil out loaded Skins for Addons that aren't loaded
		elseif self[addonFunc] then
			self[addonFunc] = nil
--			self:Debug(addonFunc, "skin unloaded as Addon not loaded")
		end
	else
		-- check to see if AddonSkin is loaded when Addon is loaded
		if not LoD and not self[addonFunc] then
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, addonName, "loaded but skin not found in the SkinMe directory")
			end
		elseif type(self[addonFunc]) == "function" then
--			self:Debug("checkAndRunAddOn#2:[%s, %s]", addonFunc, self[addonFunc])
			safecall(addonFunc, LoD)
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, "function ["..addonFunc.."] not found in "..aName)
			end
		end
	end

end

function Skinner:changeShield(shldReg, iconReg)

	shldReg:SetTexture([[Interface\CastingBar\UI-CastingBar-Arena-Shield]])
	shldReg:SetTexCoord(0, 1, 0, 1)
	shldReg:SetWidth(46)
	shldReg:SetHeight(46)
	-- move it behind the icon
	shldReg:ClearAllPoints()
	shldReg:SetPoint("CENTER", iconReg, "CENTER", 9, -1)

end

function Skinner:findFrame(height, width, children)
	-- find frame by matching children's object types

	local frame
	local obj = EnumerateFrames()

	while obj do

		if obj:IsObjectType("Frame") then
			if obj:GetName() == nil then
				if obj:GetParent() == nil then
--					self:Debug("UnNamed Frame's H, W: [%s, %s]", obj:GetHeight(), obj:GetWidth())
					if ceil(obj:GetHeight()) == height and ceil(obj:GetWidth()) == width then
						local kids = {}
						for _, child in pairs{obj:GetChildren()} do
							kids[#kids + 1] = child:GetObjectType()
						end
						local matched = 0
						for _, c in pairs(children) do
							for _, k in pairs(kids) do
								if c == k then matched = matched + 1 end
							end
						end
						if matched == #children then
							frame = obj
							break
						end
					end
				end
			end
		end

		obj = EnumerateFrames(obj)
	end

	return frame

end

function Skinner:findFrame2(parent, objType, ...)
--[===[@alpha@
	assert(parent, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if not parent then return end

--	self:Debug("findFrame2: [%s, %s, %s, %s, %s, %s, %s]", parent, objType, select(1, ...) or nil, select(2, ...) or nil, select(3, ...) or nil, select(4, ...) or nil, select(5, ...) or nil)

	local frame

	for _, child in pairs{parent:GetChildren()} do
		if child:GetName() == nil then
			if child:IsObjectType(objType) then
				if select("#", ...) > 2 then
					-- base checks on position
					local point, relativeTo, relativePoint, xOfs, yOfs = child:GetPoint()
					xOfs = ceil(xOfs)
					yOfs = ceil(yOfs)
--					self:Debug("UnNamed Object's Point: [%s, %s, %s, %s, %s]", point, relativeTo, relativePoint, xOfs, yOfs)
					if  point         == select(1, ...)
					and relativeTo    == select(2, ...)
					and relativePoint == select(3, ...)
					and xOfs          == select(4, ...)
					and yOfs          == select(5, ...) then
						frame = child
						break
					end
				else
					-- base checks on size
					local height, width = ceil(child:GetHeight()), ceil(child:GetWidth())
-- 					self:Debug("UnNamed Object's H, W: [%s, %s]", height, width)
					if  height == select(1, ...)
					and width  == select(2, ...) then
						frame = child
						break
					end
				end
			end
		end
	end

	return frame

end

function Skinner:findFrame3(name, element)
--[===[@alpha@
	assert(name, "Unknown object\n"..debugstack())
--@end-alpha@]===]

--	self:Debug("findFrame3: [%s, %s]", name, element)

	local frame

	for _, child in pairs{UIParent:GetChildren()} do
		if child:GetName() == name then
			if child[element] then
				frame = child
				break
			end
		end
	end

	return frame

end

function Skinner:getChild(obj, childNo)
--[===[@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if obj and childNo then return (select(childNo, obj:GetChildren())) end

end

function Skinner:getRegion(obj, regNo)
--[===[@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	if obj and regNo then return (select(regNo, obj:GetRegions())) end

end

function Skinner:isAddonEnabled(addonName)

	return (select(4, GetAddOnInfo(addonName))) -- in brackets so only one value is returned

end

function Skinner:isDropDown(obj)
--[===[@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@]===]

	local objTexName
	if obj:GetName() then objTexName = _G[obj:GetName().."Left"] end

	if obj:IsObjectType("Frame")
	and objTexName
	and objTexName.GetTexture
	and objTexName:GetTexture():find("CharacterCreate") then
		return true
	else
		return false
	end

end

function Skinner:isVersion(addonName, verNoReqd, actualVerNo)
--	self:Debug("isVersion: [%s, %s, %s]", addonName, verNoReqd, actualVerNo)

	local hasMatched = false

	if type(verNoReqd) == "table" then
		for _, v in ipairs(verNoReqd) do
			if v == actualVerNo then
				hasMatched = true
				break
			end
		end
	else
		if verNoReqd == actualVerNo then hasMatched = true end
	end

	if not hasMatched and self.db.profile.Warnings then
		local addText = ""
		if type(verNoReqd) ~= "table" then addText = "Version "..verNoReqd.." is required" end
		self:CustomPrint(1, 0.25, 0.25, "Version", actualVerNo, "of", addonName, "is unsupported.", addText)
	end

	return hasMatched

end

function Skinner:reParentSB(button, parent)

	if not self.modBtns then return end -- UIButtons not being skinned therefore no need to do this

	-- change the parent of the skin button
	-- 1. to prevent Animation causing gradient 'whiteout' (e.g. BNToast frame)
	self.sBut[button]:SetParent(parent)

end

function Skinner:reParentSF(frame, parent)

	-- change the parent of the skin frame
	-- 1. to prevent Animation causing gradient 'whiteout' (e.g. Alert frames)
	-- 2. to prevent other child frames from appearing behind the skin frame (e.g. LFD random cooldown)
	self.skinFrame[frame]:SetParent(parent or UIParent)
	-- hook Show and Hide methods
	self:SecureHook(frame, "Show", function(this) self.skinFrame[this]:Show() end)
	self:SecureHook(frame, "Hide", function(this) self.skinFrame[this]:Hide() end)
	if not frame:IsShown() then self.skinFrame[frame]:Hide() end

end

function Skinner:resizeTabs(frame)

	local fN = frame:GetName()
	local tabName = fN.."Tab"
	local nT
	-- get the number of tabs
	nT = ((frame == CharacterFrame and not CharacterFrameTab2:IsShown()) and 4 or frame.numTabs)
--	self:Debug("rT: [%s, %s]", tabName, nT)
	-- accumulate the tab text widths
	local tTW = 0
	for i = 1, nT do
		tTW = tTW + _G[tabName..i.."Text"]:GetWidth()
	end
	-- add the tab side widths
	local tTW = tTW + (40 * nT)
	-- get the frame width
	local fW = frame:GetWidth()
	-- calculate the Tab left width
	local tlw = (tTW > fW and (40 - (tTW - fW) / nT) / 2 or 20)
	-- set minimum left width
	tlw = ("%.2f"):format(tlw >= 6 and tlw or 5.5)
-- 	self:Debug("resizeTabs: [%s, %s, %s, %s, %s]", fN, nT, tTW, fW, tlw)
	-- update each tab
	for i = 1, nT do
		_G[tabName..i.."Left"]:SetWidth(tlw)
		PanelTemplates_TabResize(_G[tabName..i], 0)
	end

end

function Skinner:updateSBTexture()

	-- get updated colour/texture
	local sb = self.db.profile.StatusBar
	self.sbColour = {sb.r, sb.g, sb.b, sb.a}
	self.sbTexture = self.LSM:Fetch("statusbar", sb.texture)

	for statusBar, tab in pairs(self.sbGlazed) do
		statusBar:SetStatusBarTexture(self.sbTexture)
		for k, tex in pairs(tab) do
			tex:SetTexture(self.sbTexture)
			if k == bg then tex:SetVertexColor(sb.r, sb.g, sb.b, sb.a) end
		end
	end

end

-- This function was copied from WoWWiki
-- http://www.wowwiki.com/RGBPercToHex
function Skinner:RGBPercToHex(r, g, b)

--	Check to see if the passed values are strings, if so then use some default values
	if type(r) == "string" then r, g, b = 0.8, 0.8, 0.0 end

	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0

	return ("%02x%02x%02x"):format(r*255, g*255, b*255)

end

local function round2(num, ndp)

  return tonumber(("%." .. (ndp or 0) .. "f"):format(num))

end

function Skinner:ShowInfo(obj, showKids, noDepth)

--[===[@alpha@
	assert(obj, "Unknown object ShowInfo\n"..debugstack())
--@end-alpha@]===]

	if not obj then return end

	local showKids = showKids or false

	local function showIt(fmsg, ...)

		printIt("dbg:"..makeText(fmsg, ...), Skinner.debugFrame)

	end

	local function getRegions(object, lvl)

		for i = 1, object:GetNumRegions() do
			local v = select(i, object:GetRegions())
			showIt("[lvl%s-%s : %s : %s : %s : %s : %s]", lvl, i, v, v:GetObjectType() or "nil", v.GetWidth and round2(v:GetWidth(), 2) or "nil", v.GetHeight and round2(v:GetHeight(), 2) or "nil", v:GetObjectType() == "Texture" and ("%s : %s"):format(v:GetTexture() or "nil", v:GetDrawLayer() or "nil") or "nil")
		end

	end

	local function getChildren(frame, lvl)

		if not showKids then return end
		if type(lvl) == "string" and lvl:find("-") == 2 and noDepth then return end

		for i = 1, frame:GetNumChildren() do
			local v = select(i, frame:GetChildren())
			local objType = v:GetObjectType()
			showIt("[lvl%s-%s : %s : %s : %s : %s : %s]", lvl, i, v, v.GetWidth and round2(v:GetWidth(), 2) or "nil", v.GetHeight and round2(v:GetHeight(), 2) or "nil", v:GetFrameLevel() or "nil", v:GetFrameStrata() or "nil")
			if objType == "Frame"
			or objType == "Button"
			or objType == "StatusBar"
			or objType == "Slider"
			or objType == "ScrollFrame"
			then
				getRegions(v, lvl.."-"..i)
				getChildren(v, lvl.."-"..i)
			end
		end

	end

	showIt("%s : %s : %s : %s : %s", obj, round2(obj:GetWidth(), 2) or "nil", round2(obj:GetHeight(), 2) or "nil", obj:GetFrameLevel() or "nil", obj:GetFrameStrata() or "nil")

	showIt("Started Regions")
	getRegions(obj, 0)
	showIt("Finished Regions")
	showIt("Started Children")
	getChildren(obj, 0)
	showIt("Finished Children")

end
