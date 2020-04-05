--[[
	OmniCC Full
		A featureful version of OmniCC
		Cooldown text should work on absolutely everything.  Pulses will work on anything that I can determine the icon of
--]]

local SML = LibStub('LibSharedMedia-3.0') --shared media library
local CURRENT_VERSION = GetAddOnMetadata('OmniCC', 'Version') --the addon's current version
local L = OMNICC_LOCALS --localized strings

local DAY, HOUR, MINUTE, SHORT = 86400, 3600, 60, 5 --values for time
local ICON_SIZE = 36 --the normal size of an icon
local timers = {}
local pulses = {}
local showers = {}
local activePulses = {}

--this was a fun constant to come up with
--the anniversary date for wow
local WOW_EPOCH = time{year = 2008, month = 11, day = 23, hour = 2, min = 0, sec = 0}

--omg speed constants
local _G = _G
local floor = math.floor
local format = string.format
local time = time

--[[
	Addon Loading
--]]

OmniCC = CreateFrame('Frame')
OmniCC:SetScript('OnEvent', function(self) self:Enable() end)
OmniCC:RegisterEvent('PLAYER_LOGIN')

function OmniCC:Enable()
	self.sets = self:InitDB()

	self:CheckVersion()

	self:HookCooldown()

	--setup the options menu hook
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f:SetScript('OnShow', function(self)
		LoadAddOn('OmniCC_Options')
		self:SetScript('OnShow', nil)
	end)

	--load slash commands
	SlashCmdList['OmniCCCOMMAND'] = function()
		if LoadAddOn('OmniCC_Options') then
			InterfaceOptionsFrame_OpenToCategory('OmniCC')
		end
	end
	SLASH_OmniCCCOMMAND1 = '/omnicc'
	SLASH_OmniCCCOMMAND2 = '/occ'
end

function OmniCC:InitDB()
	local db = _G['OmniCCDB']

	--no settings, load defaults
	if not(db and db.version) then
		db = {
			font = SML:GetDefault('font'), --what font to use
			fontOutline = 'OUTLINE', --what outline to use on fonts
			fontSize = 18, --the base font size to use at a scale of 1

			showModel = true, --show the cooldown model or not
			useMMSS = false, --use MM:SS format for cooldowns under 3 minutes

			minScale = 0.5, --the minimum scale we want to show cooldown counts at, anything below will be hidden
			minDuration = 3, --the minimum duration we want to show cooldowns for, anything below will not show a timer
			minFinishEffectDuration = 30, --the minimum duration a cooldown should have for completion effects
			tenthsOfSecondsThreshold = 2,

			style = {
				short = {r = 1, g = 0, b = 0, s = 1.25}, -- <= 5 seconds
				secs = {r = 1, g = 1, b = 0.4, s = 1}, -- < 1 minute
				mins = {r = 0.8, g = 0.8, b = 0.9, s = 0.9}, -- >= 1 minute
				hrs = {r = 0.8, g = 0.8, b = 0.9, s = 0.8}, -- >= 1 hr
				days = {r = 0.8, g = 0.8, b = 0.9, s = 0.65}, -- >= 1 day
			},

			version = CURRENT_VERSION,
		}

		_G['OmniCCDB'] = db
	end

	return db
end

function OmniCC:CheckVersion()
	local cMajor, cMinor, cBugfix = CURRENT_VERSION:match('(%w+)%.(%w+)%.(%w+)')
	local major, minor, bugfix = self.sets.version:match('(%w+)%.(%w+)%.(%w+)')

	if major ~= cMajor then
		self:LoadDefaults()
	elseif minor ~= cMinor then
		self:UpdateSettings(minor, bugfix)
	end

	if self.sets.version ~= CURRENT_VERSION then
		self:UpdateVersion()
	end
end

function OmniCC:UpdateSettings(minor, bugfix)
	self.sets.tenthsOfSecondsThreshold = 2
end

function OmniCC:UpdateVersion()
	self.sets.version = CURRENT_VERSION
	self:Print(format(L.Updated, self.sets.version))
end

do
	--hook the cooldown function (effectively enable the addon)
	--we inherit CooldownFrameTemplate here to prevent a crash issue
	local function HideTimer(self)
		local timer = timers[self]
		if timer then
			timer:Hide()
		end
	end

	function OmniCC:HookCooldown()
		local methods = getmetatable(CreateFrame('Cooldown', nil, nil, 'CooldownFrameTemplate')).__index
		hooksecurefunc(methods, 'SetCooldown', function(self, start, duration)
			if self.noCooldownCount then
				HideTimer(self)
			else
				self:SetAlpha(OmniCC.sets.showModel and 1 or 0)
				if start > 0 and duration > OmniCC.sets.minDuration then
					OmniCC:StartTimer(self, start, duration)
				else
					HideTimer(self)
				end
			end
		end)
	end
end


--[[
	Timer Code
--]]

function OmniCC:StartTimer(cooldown, start, duration)
	local timer = timers[cooldown] or self:CreateTimer(cooldown)

	--[[
		voodoo formula
		basically: start is based on the time since you've booted your computer
		if the elapsed time of a cooldown is longer than the time since you've rebooted, then crazy things happen
		blizzard instead passes start as when the cooldown started, relative to the wow anniversary date
		this should handle cooldowns under that case
	--]]
	if (start - GetTime()) > duration then
		local secondsSinceAnniversary = time() - WOW_EPOCH
		local elapsed = secondsSinceAnniversary - start
		start = GetTime() - elapsed
	end

	if timer then
		if not showers[cooldown] then
			self:CreateShower(cooldown)
		end

		timer.start = start
		timer.duration = duration

		timer.shouldPulse = duration > self:GetMinEffectDuration()
		timer.nextUpdate = 0
		timer:Show()
	end
end

--shower: a frame used to properly show and hide timer text without forcing the timer to be parented to the cooldown frame (needed for hiding the cooldown frame)
do
	local function Shower_OnShow(self)
		local cooldown = self:GetParent()
		local timer = timers[cooldown]
		if timer.wasShown and not cooldown.noCooldownCount then
			timer:Show()
		end
	end

	local function Shower_OnHide(self)
		local timer = timers[self:GetParent()]
		if timer:IsShown() then
			timer.wasShown = true
			timer:Hide()
		end
	end

	function OmniCC:CreateShower(cooldown)
		--controls the visibility of the timer
		local shower = CreateFrame('Frame', nil, cooldown)
		shower:SetScript('OnShow', Shower_OnShow)
		shower:SetScript('OnHide', Shower_OnHide)

		showers[cooldown] = shower

		return shower
	end
end

do
	--timer, the frame with cooldown text
	local function Timer_OnUpdate(self, elapsed)
		if self.nextUpdate <= 0 then
			OmniCC:UpdateTimer(self, elapsed)
		else
			self.nextUpdate = self.nextUpdate - elapsed
		end
	end

	function OmniCC:CreateTimer(cooldown)
		local timer = CreateFrame('Frame', nil, cooldown:GetParent())
		timer:SetFrameLevel(cooldown:GetFrameLevel() + 5) --make sure the timer is on top of things like the cooldown model
		timer:SetAllPoints(cooldown)
		timer:SetToplevel(true)
		timer:Hide()
		timer:SetScript('OnUpdate', Timer_OnUpdate)

		local text = timer:CreateFontString(nil, 'OVERLAY')
		text:SetPoint('CENTER', 0, 1)
		timer.text = text

		-- parent icon, used for shine stuff
		local parent = cooldown:GetParent()
		if parent then
			if parent.icon then
				timer.icon = parent.icon
			else
				local name = parent:GetName()
				if name then
					timer.icon = _G[name .. 'Icon'] or _G[name .. 'IconTexture']
				end
			end
		end

		timers[cooldown] = timer

		return timer
	end
end

function OmniCC:UpdateTimer(timer)
	local rScale = timer:GetEffectiveScale() / UIParent:GetEffectiveScale()
	local iconScale = floor(timer:GetWidth() + 0.5) / ICON_SIZE --icon sizes seem to vary a little bit, so this takes care of making them round to whole numbers

	if iconScale*rScale < self:GetMinScale() or iconScale == 0 then
		timer.toNextUpdate = 1
		timer.text:Hide()
	else
		local remain = timer.duration - (GetTime() - timer.start)
		local shouldShowText = false

		if self:UseTenthsOfSeconds() then
			shouldShowText = remain >= 0
		else
			shouldShowText = floor(remain + 0.5) > 0
		end

		if shouldShowText then
			local time, nextUpdate = self:GetFormattedTime(remain)
			local font, size, r, g, b, outline = self:GetFormattedFont(remain)
			local text = timer.text

			--do another check for too small fonts
			if floor(size * iconScale) > 0 then
				text:SetFont(font, size * iconScale, outline)
				text:SetText(time)
				text:SetTextColor(r, g, b)
				text:Show()
				timer.nextUpdate = nextUpdate
			else
				timer.nextUpdate = 1
			end
		else
			timer:Hide()

			if timer.shouldPulse and self.OnFinishCooldown then
				self:OnFinishCooldown(timer)
			end
		end
	end
end

function OmniCC:UpdateAllTimers()
	for _,timer in pairs(timers) do
		timer.nextUpdate = 0
	end
end


--[[ Format Functions ]]--

--the cooldown duration necessary to display tenths of seconds
function OmniCC:GetTenthsOfSecondsThreshold()
	return self.sets.tenthsOfSecondsThreshold or 2
end

function OmniCC:GetFormattedTime(s)
	if s >= DAY then
		return format('%dd', floor(s/DAY + 0.5)), s % DAY
	elseif s >= HOUR then
		return format('%dh', floor(s/HOUR + 0.5)), s % HOUR
	elseif s >= MINUTE then
		if s <= MINUTE*3 and self:UsingMMSS() then
			return format('%d:%02d', floor(s/60), s % MINUTE), s - floor(s)
		end
		return format('%dm', floor(s/MINUTE + 0.5)), s % MINUTE
	end
	if self:UseTenthsOfSeconds() and s < self:GetTenthsOfSecondsThreshold() then
		return format('%.1f', s), (s * 100 - floor(s * 100))/100
	end
	return floor(s + 0.5), (s * 100 - floor(s * 100))/100
end

function OmniCC:GetFormattedFont(s)
	local style = self.sets.style
	local fontSize = self.sets.fontSize
	local outline = self.sets.fontOutline

	if s > DAY then
		style = style.days
	elseif s > HOUR then
		style = style.hrs
	elseif s > MINUTE then
		style = style.mins
	elseif s > SHORT then
		style = style.secs
	else
		style = style.short
	end
	return self:GetFont(), fontSize * style.s, style.r, style.g, style.b, outline
end


--[[
	Configuration Functions
--]]


--font style selector
function OmniCC:SetFont(font)
	self.sets.font = font
	self:UpdateAllTimers()
end

--wrapper for shared media library
--gets the path to the font we're using
function OmniCC:GetFont()
	return SML:Fetch(SML.MediaType['FONT'], self.sets.font)
end

--get the name of the font we're using (used for the options menu)
function OmniCC:GetFontName()
	return self.sets.font
end


--font size selector
function OmniCC:SetFontSize(fontSize)
	if fontSize then
		self.sets.fontSize = fontSize
		self:UpdateAllTimers()
	end
end

function OmniCC:GetFontSize()
	return self.sets.fontSize
end

function OmniCC:SetFontOutline(outline)
	self.sets.fontOutline = outline
	self:UpdateAllTimers()
end

function OmniCC:GetFontOutline()
	return self.sets.fontOutline
end


--text format settings
function OmniCC:SetDurationColor(duration, r, g, b)
	local style = self.sets.style
	if duration and style[duration] then
		style[duration].r = r
		style[duration].g = g
		style[duration].b = b
		self:UpdateAllTimers()
	end
end

function OmniCC:SetDurationScale(duration, scale)
	local style = self.sets.style
	if duration and style[duration] then
		style[duration].s = scale
		self:UpdateAllTimers()
	end
end

function OmniCC:GetDurationFormat(duration)
	local style = self.sets.style
	if duration and style[duration] then
		local style = style[duration]
		return style.r, style.g, style.b, style.s
	end
end


--minum scale of icon to show text
function OmniCC:SetMinScale(scale)
	if scale then
		self.sets.minScale = scale
		self:UpdateAllTimers()
	end
end

function OmniCC:GetMinScale()
	return self.sets.minScale
end


--minimum duration toggle
function OmniCC:SetMinDuration(duration)
	if duration then
		self.sets.minDuration = duration
	end
end

function OmniCC:GetMinDuration()
	return self.sets.minDuration
end


--show cooldown models toggle
function OmniCC:SetShowModels(enable)
	self.sets.showModel = enable
end

function OmniCC:ShowingModels()
	return self.sets.showModel
end

--mmss format thingy
function OmniCC:SetUseMMSS(enable)
	self.sets.useMMSS = enable
	self:UpdateAllTimers()
end

function OmniCC:UsingMMSS()
	return self.sets.useMMSS
end

--min effect duration
function OmniCC:SetMinEffectDuration(duration)
	self.sets.minFinishEffectDuration = duration
end

function OmniCC:GetMinEffectDuration()
	return self.sets.minFinishEffectDuration or 30
end

--tenths of seconds display
function OmniCC:UseTenthsOfSeconds()
	return self.sets.useTenthsOfSeconds
end

function OmniCC:SetUseTenthsOfSeconds(enable)
	self.sets.useTenthsOfSeconds = enable or false
end


--[[
	Utility Functions
--]]

function OmniCC:Print(...)
	print('|cFF33FF99OmniCC|r', ...)
end

function OmniCC:CreateClass(type, parentClass)
	local class = CreateFrame(type)
	class.mt = {__index = class}

	if parentClass then
		class = setmetatable(class, {__index = parentClass})
		class.super = parentClass
	end

	function class:Bind(o)
		return setmetatable(o, self.mt)
	end

	return class
end
