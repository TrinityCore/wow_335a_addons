local _G = _G
local PitBull4 = _G.PitBull4
local PitBull4_Controls = {}
PitBull4.Controls = PitBull4_Controls
local DEBUG = PitBull4.DEBUG
local expect = PitBull4.expect

local cache = {}

local control__index = {}

-- animation group to stick unused animation objects since you can't parent
-- them to anything but an AnimationGroup
local frame = CreateFrame("Frame")
local animation_cache = frame:CreateAnimationGroup()

-- functions to call when deleting specific types of controls
local delete_funcs = {}

local default_font, default_font_size = ChatFontNormal:GetFont()
function delete_funcs:FontString()
	self:SetText("")
	self:SetJustifyH("CENTER")
	self:SetJustifyV("MIDDLE")
	self:SetNonSpaceWrap(true)
	self:SetTextColor(1, 1, 1, 1)
	self:SetFont(default_font, default_font_size, nil)
	self:SetFontObject(nil)
end
function delete_funcs:Texture()
	self:SetTexture([[Interface\Buttons\WHITE8X8]])
	self:SetVertexColor(0, 0, 0, 0)
	self:SetBlendMode("BLEND")
	self:SetDesaturated(false)
	self:SetTexCoord(0, 1, 0, 1)
	if self.SetTexCoordModifiesRect then
		-- pre 3.3.3 texture tiling code
		self:SetTexCoordModifiesRect(false)
	else
		-- 3.3.3 and newer texture tiling code
		self:SetHorizTile(false)
		self:SetVertTile(false)
	end
end
local function delete_animations(...)
	for i=1,select('#',...) do
		local animation = select(i,...)
		if animation.Delete then
			animation:Delete()
		else
			animation:SetParent(animation_cache)
			animation:Stop()
		end
	end
end
function delete_funcs:AnimatedTexture()
	local ag = self.ag
	ag:SetScript("OnEvent",nil)
	ag:SetScript("OnFinished",nil)
	ag:SetScript("OnLoop",nil)
	ag:SetScript("OnPause",nil)
	ag:SetScript("OnPlay",nil)
	ag:SetScript("OnStop",nil)
	ag:SetScript("OnUpdate",nil)
	ag:Stop()
	delete_animations(ag:GetAnimations())
	delete_funcs.Texture(self)
end
function delete_funcs:Animation()
	self:SetScript("OnEvent",nil)
	self:SetScript("OnFinished",nil)
	self:SetScript("OnPause",nil)
	self:SetScript("OnPlay",nil)
	self:SetScript("OnStop",nil)
	self:SetScript("OnUpdate",nil)
	self:SetOrder(1)
	self:SetDuration(0)
	self:SetMaxFramerate(0)
	self:SetSmoothing("NONE")
	self:SetStartDelay(0)
	self:SetEndDelay(0)
	self:SetParent(animation_cache)
	self:Stop()
end
function delete_funcs:Alpha()
	self:SetChange(0)
	delete_funcs.Animation(self)
end
function delete_funcs:StatusBar()
	self:SetStatusBarColor(1, 1, 1, 1)
	self:SetStatusBarTexture(nil)
	self:SetValue(1)
	self:SetOrientation("HORIZONTAL")
end
function delete_funcs:Cooldown()
	self:SetReverse(false)
end

--- Delete a frame, putting it back in the pool to be recycled.
-- Don't hold onto a frame after you've deleted it, there could be double-free
-- issues later
-- @name control:Delete
-- @usage control = control:Delete()
-- @return nil
function control__index:Delete()
	local kind = self.kind
	
	if self.onDelete then
		self:onDelete()
		self.onDelete = nil
	end
	
	if self.extraDelete then
		self:extraDelete()
		self.extraDelete = nil
	end
	
	if delete_funcs[kind] then
		delete_funcs[kind](self)
	end
	
	--[[
	if kind ~= "Texture" and kind ~= "FontString" and not _G.OmniCC and customKind == kind and _G.UnitClassBase then
		if self:GetNumRegions() > 0 then
			error(("Deleting a frame of type %q that still has %d regions"):format(kind, self:GetNumRegions()), 2)
		end
		if self:GetNumChildren() > 0 then
			error(("Deleting a frame of type %q that still has %d children"):format(kind, frame:GetNumChildren()), 2)
		end
	end
	]]

	if self.ClearAllPoints then
		self:ClearAllPoints()
		self:SetPoint("LEFT", UIParent, "RIGHT", 1e5, 0)
	end
	if self.Hide then
		self:Hide()
	end
	if self.SetBackdrop then
		self:SetBackdrop(nil)
	end
	if kind ~= "Alpha" and kind ~= "Animation" and kind ~= "AnimatedTexture" then
		self:SetParent(UIParent)
	end
	if self.SetAlpha then
		self:SetAlpha(0)
	end
	if self.SetHeight then
		self:SetHeight(0)
		self:SetWidth(0)
	end
	local cache_kind = cache[kind]
	if cache_kind[self] then
		error(("Double-free frame syndrome of type %q"):format(kind), 2)
	end
	cache_kind[self] = true
	return nil
end

-- create a very basic control, properly handling Textures and FontStrings.
local function create_control(kind, name, inheritTemplate, parent)
	if kind == "Texture" then
		return parent:CreateTexture(name, "BACKGROUND")
	end
	if kind == "FontString" then
		return parent:CreateFontString(name, "BACKGROUND")
	end
	if kind == "AnimatedTexture" then
		local texture = parent:CreateTexture(name, "BACKGROUND")
		texture.ag = texture:CreateAnimationGroup()
		return texture
	end
	if kind == "Animation" or kind == "Alpha" then
		return parent:CreateAnimation(kind, name)
	end
	return CreateFrame(kind, name, parent, inheritTemplate)
end

-- return a control from the cache if possible, otherwise create a new one and return that
local function get_or_create_control(cache_kind, kind, realKind, inheritTemplate, onCreate, parent)
	local control = next(cache_kind)
	
	if control then
		cache_kind[control] = nil
		return control
	end
	
	local name
	local i = 0
	repeat
		i = i + 1
		name = "PitBull4_" .. kind .. "_" .. i
	until not _G[name]
	
	local control = create_control(realKind, name, inheritTemplate, parent)
	if onCreate then
		onCreate(control)
	end
	for k, v in pairs(control__index) do
		control[k] = v
	end
	control.kind = kind
	return control
end

-- fetch a control of the given type and apply the standard settings to it
local function fetch_control(kind, parent, isCustom, ...)
	if DEBUG then
		expect(kind, 'typeof', 'string')
		expect(parent, 'typeof', 'frame')
	end
	
	local cache_kind = cache[kind]
	if not cache_kind then
		cache_kind = {}
		cache[kind] = cache_kind
	end
	
	local realKind, onCreate, onRetrieve, onDelete, inheritTemplate
	realKind = kind
	if isCustom then
		realKind, onCreate, onRetrieve, onDelete, inheritTemplate = ...
	end
	
	local control = get_or_create_control(cache_kind, kind, realKind, inheritTemplate, onCreate, parent)
	control:SetParent(parent)
	if control.ClearAllPoints then
		control:ClearAllPoints()
	end
	if control.SetAlpha then
		control:SetAlpha(1)
	end
	if kind == "Texture" or kind == "AnimatedTexture" then
		control:SetTexture(nil)
		control:SetVertexColor(1, 1, 1, 1)
	end
	if kind == "Texture" or kind == "FontString" or kind == "AnimatedTexture" then
		control:SetDrawLayer((...))
	end
	if control.SetScale then
		control:SetScale(1)
	end
	if control.Show then
		control:Show()
	end
	if onRetrieve then
		onRetrieve(control, select(6, ...)) -- onRetrieve
	end
	control.onDelete = onDelete
	return control
end

--- Make a frame
-- @param parent frame the frame is parented to
-- @usage local frame = PitBull4.Controls.MakeFrame(someFrame)
-- @return a Frame object
function PitBull4.Controls.MakeFrame(parent)
	if DEBUG then
		expect(parent, 'typeof', 'frame')
	end
	
	return fetch_control("Frame", parent)
end

--- Make a texture
-- @param parent frame the texture is parented to
-- @param layer the art layer of the texture
-- @usage local texture = PitBull4.Controls.MakeTexture(someFrame, "BACKGROUND")
-- @return a Texture object
function PitBull4.Controls.MakeTexture(parent, layer)
	if DEBUG then
		expect(parent, 'typeof', 'frame')
		expect(layer, 'typeof', 'string;nil')
	end

	return fetch_control("Texture", parent, false, layer)
end

--- Make an animated texture
-- @param parent frame the animated texture is parented to
-- @param layer the art layer of the texture
-- @usage local texture = PitBull4.Controls.MakeAnimatedTexture(someFrame, "BACKGROUND")
-- @return a AnimatedTexture object
function PitBull4.Controls.MakeAnimatedTexture(parent, layer)
	if DEBUG then
		expect(parent, 'typeof', 'frame')
		expect(layer, 'typeof', 'string;nil')
	end

	return fetch_control("AnimatedTexture", parent, false, layer)
end

--- Make an Animation object
-- @param parent animation group the animation is parented to
-- @usage local anim = PitBull4.Controls.MakeAnimation(self.ag)
-- @return an Animation object
function PitBull4.Controls.MakeAnimation(parent)
	if DEBUG then
		expect(parent, 'frametype', 'AnimationGroup')
	end

	return fetch_control('Animation', parent, false)
end

--- Make an Alpha animation object
-- @param parent animation group the animation is parented to
-- @usage local anim = PitBull4.Controls.MakeAlpha(self.ag)
-- @return an Alpha object
function PitBull4.Controls.MakeAlpha(parent)
	if DEBUG then
		expect(parent, 'frametype', 'AnimationGroup')
	end

	return fetch_control('Alpha', parent, false)
end

--- Make a font string
-- @param parent frame the font string is parented to
-- @param layer the art layer of the font string
-- @usage local fs = PitBull4.Controls.MakeFontString(someFrame, "BACKGROUND")
-- @return a FontString object
function PitBull4.Controls.MakeFontString(parent, layer)
	if DEBUG then
		expect(parent, 'typeof', 'frame')
		expect(layer, 'typeof', 'string;nil')
	end
	
	return fetch_control("FontString", parent, false, layer)
end

--- Make a PlayerModel
-- @param parent frame the frame is parented to
-- @usage local frame = PitBull4.Controls.MakePlayerModel(someFrame)
-- @return a PlayerModel object
function PitBull4.Controls.MakePlayerModel(parent)
	if DEBUG then
		expect(parent, 'typeof', 'frame')
	end
	
	return fetch_control("PlayerModel", parent)
end

--- Make a DressUpModel
-- @param parent frame the frame is parented to
-- @usage local frame = PitBull4.Controls.MakePlayerModel(someFrame)
-- @return a PlayerModel object
function PitBull4.Controls.MakeDressUpModel(parent)
	if DEBUG then
		expect(parent, 'typeof', 'frame')
	end
	
	return fetch_control("DressUpModel", parent)
end

--- Make a Cooldown
-- @param parent frame the frame is parented to
-- @usage local frame = PitBull4.Controls.MakeCooldown(someFrame)
-- @return a Cooldown object
function PitBull4.Controls.MakeCooldown(parent)
	if DEBUG then
		expect(parent, 'typeof', 'frame')
	end
	
	return fetch_control("Cooldown", parent)
end

--- Make a Button
-- @param parent frame the frame is parented to
-- @usage local frame = PitBull4.Controls.MakeButton(someFrame)
-- @return a Button object
function PitBull4.Controls.MakeButton(parent)
	if DEBUG then
		expect(parent, 'typeof', 'frame')
	end
	
	return fetch_control("Button", parent)
end

--- Make a new control type
-- @param name name of your control type
-- @param frameType the real frame type to base upon
-- @param onCreate function to call when initially creating the control
-- @param onRetrieve function to call every time the control is requested
-- @param onDelete function to call when the frame is deleted
-- @param inheritTemplate the Blizzard template(s) to inherit from
-- @usage PitBull4.Controls.MakeNewControlType("BetterStatusBar", "StatusBar", function(control) end, function(control) end, function(control) end)
function PitBull4.Controls.MakeNewControlType(name, frameType, onCreate, onRetrieve, onDelete, inheritTemplate)
	if DEBUG then
		expect(name, 'typeof', 'string')
		expect(PitBull4_Controls["Make" .. name], 'typeof', 'nil')
		expect(frameType, 'typeof', 'string')
		expect(onCreate, 'typeof', 'function')
		expect(onRetrieve, 'typeof', 'function')
		expect(onDelete, 'typeof', 'function')
		expect(inheritTemplate, 'typeof', 'nil;string')
	end
	
	PitBull4_Controls["Make" .. name] = function(parent, ...)
		return fetch_control(name, parent, true, frameType, onCreate, onRetrieve, onDelete, inheritTemplate, ...)
	end
end
