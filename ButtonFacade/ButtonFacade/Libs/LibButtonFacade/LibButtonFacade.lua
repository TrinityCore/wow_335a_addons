--[[
	Project.: LibButtonFacade
	File....: LibButtonFacade.lua
	Version.: 329
	Author..: StormFX, JJ Sheets
]]

-- [ Set Up ] --

local LBF
local assert = assert
do
	local major, minor = "LibButtonFacade", 30305
	local LS = assert(LibStub,major.." requires LibStub.")
	LBF = LS:NewLibrary(major,minor)
end
if not LBF then return end

-- [ Locals ] --

local error, pairs, print, setmetatable, type, unpack = error, pairs, print, setmetatable, type, unpack

-- Error Handling -- 

local E_PRE = "|cffffff99<LBF Debug>|r "
local E_ARG = "Bad argument to method '%s'. '%s' must be a %s."
local E_TPL = "Invalid template reference by skin '%s'. Skin '%s' does not exist."

local debug = false

-- Throws an error if debug mode is enabled.
local function Debug(e,...)
	if debug == true then
		local msg = (E_PRE..e):format(...)
		error(msg,3)
	end
end

function LBF:Debug()
	if not debug then
		debug = true
		print(E_PRE.."|cff00ff00enabled|r.")
	else
		debug = false
		print(E_PRE.."|cffff0000disabled|r.")
	end
end
-- [ Call Backs ] --

local FireGuiCB

do
	local callbacks = {}
	-- Fires all registered GUI call-backs.
	function FireGuiCB(Addon,Group,Button)
		for i = 1, #callbacks do
			local v = callbacks[i]
			v.cb(v.arg,Addon,Group,Button)
		end
	end
	-- Registers a GUI call-back.
	function LBF:RegisterGuiCallback(callback,arg)
		callbacks[#callbacks+1] = {cb = callback, arg = arg}
	end
end

local FireSkinCB

do
	local callbacks = {}
	-- Fires all call-backs registered for the specified add-on.
	function FireSkinCB(Addon,SkinID,Gloss,Backdrop,Group,Button,Colors)
		Addon = Addon or "ButtonFacade"
		local args = callbacks[Addon]
		if args then
			for arg, callback in pairs(args) do
				callback(arg and arg,SkinID,Gloss,Backdrop,Group,Button,Colors)
			end
		end
	end
	-- Registers a skin call-back for the specified add-on.
	function LBF:RegisterSkinCallback(Addon,callback,arg)
		local arg = callback and arg or false
		callbacks[Addon] = callbacks[Addon] or {}
		callbacks[Addon][arg] = callback
	end
end

-- [ Default Settings ] --

-- Texture Coordinates
local TexCoords = {0,1,0,1}

-- Draw Layers
local DrawLayers = {
	Backdrop = "BACKGROUND",
	Icon = "BORDER",
	Pushed = "BACKGROUND",
	Flash = "OVERLAY",
	Normal = "BORDER",
	Disabled = "ARTWORK",
	Checked = "ARTWORK",
	Border = "OVERLAY",
	Highlight = "HIGHLIGHT",
	AutoCastable = "BORDER",
	Gloss = "OVERLAY",
	HotKey = "OVERLAY",
	Count = "OVERLAY",
	Name = "OVERLAY",
}

-- Non-special Case Layers
local LayerTypes = {
	Icon = "Icon",
	Flash = "Texture",
	Cooldown = "Frame",
	AutoCast = "Frame",
	AutoCastable = "Texture",
	HotKey = "Text",
	Count = "Text",
	Name = "Text",
}

-- Parent Levels - Represents the frame the layer is parented to (via Button.__LBF_Level)
local Levels = {
	Backdrop = 1,
	Icon = 1,
	Pushed = 3,
	Flash = 1,
	Cooldown = 2,
	Normal = 3,
	Disabled = 3,
	Checked = 3,
	Border = 3,
	Highlight = 3,
	AutoCast = 4,
	AutoCastable = 5,
	Gloss = 5,
	HotKey = 5,
	Count = 5,
	Name = 5,
}

-- Frame Offsets
local Offsets = {
	[1] = -2,
	[2] = -1,
	[4] = 1,
	[5] = 2,
}

-- Border Colors
local Borders = {
	Action = {0,1,0,0.35},
	None = {0.8,0,0,0.8},
	Magic = {0.2,0.6,1,0.8},
	Curse = {0.6,0,1,0.8},
	Poison = {0,0.6,0,0.8},
	Disease = {0.6,0.4,0,0.8},
	Enchant = {0.6,0.4,0.8,0.8},
	Custom = {0,0,1,0.8},
}

-- [ Validation ] -- 

local function IsType(Type)
	if Type and Borders[Type] then
		return true
	end
end

-- [ Coloring ] --

local SetBorderColor

do
	local hooked = {}
	local loopcheck = {}
	-- Hook to catch changes to the border color in the default UI.
	local function Hook_SetVertexColor(Region,r,g,b,a)
		if Region.__LBF_Disabled then return end
		if loopcheck[Region] then loopcheck[Region] = nil return end
		loopcheck[Region] = true
		r = Region.__LBF_R or r
		g = Region.__LBF_G or g
		b = Region.__LBF_B or b
		a = Region.__LBF_A or a or 1
		Region:SetVertexColor(r,g,b,a)
	end
	-- Sets the border color.
	function SetBorderColor(Region,r,g,b,a)
		Region.__LBF_Disabled = nil
		Region.__LBF_R, Region.__LBF_G, Region.__LBF_B, Region.__LBF_A = r, g, b, a
		if not hooked[Region] then
			hooksecurefunc(Region,"SetVertexColor",Hook_SetVertexColor)
			hooked[Region] = true
		end
		Region:SetVertexColor(r,g,b,a)
	end
end

-- Returns the layer's color table.
local function GetLayerColor(SkinLayer,Colors,Layer,Alpha)
	local color = Colors[Layer] or SkinLayer.Color
	if type(color) == "table" then
		return color[1] or 1, color[2] or 1, color[3] or 1, Alpha or color[4] or 1
	else
		return 1, 1, 1, Alpha or 1
	end
end

-- Returns the border's color table.
local function GetBorderColor(Type,Colors,SkinLayer)
	local r, g, b, a = unpack(Borders[Type])
	if type(SkinLayer.Colors) == "table" then
		local c = SkinLayer.Colors[Type]
		if type(c) == "table" then
			r = c[1] or r
			g = c[2] or g
			b = c[3] or b
			a = c[4] or a
		end
	end
	if type(Colors.Borders) == "table" then
		local c = Colors.Borders[Type]
		if type(c) == "table" then
			r = c[1] or r
			g = c[2] or g
			b = c[3] or b
			a = c[4] or a
		end
	end
	return r, g, b, a
end

-- [ Default Layers ] --

-- [ Normal ] --

local SkinNormalLayer

do
	local base = {}
	local hooked = {}
	-- Hook to catch changes to the normal texture.
	local function Hook_SetNormalTexture(Button,Texture)
		local region = Button.__LBF_Normal
		local normal = Button:GetNormalTexture()
		if Button.__LBF_NoNormal then
				normal:SetTexture("")
				normal:Hide()
			return
		end
		if Texture == "Interface\\Buttons\\UI-Quickslot2" then
			if normal ~= region then
				normal:SetTexture("")
				normal:Hide()
			end
			region:SetTexture(Button.__LBF_NormalSkin.Texture or "")
			region.__LBF_UseEmpty = nil
		elseif Texture == "Interface\\Buttons\\UI-Quickslot" then
			if normal ~= region then
				normal:SetTexture("")
				normal:Hide()
			end
			region:SetTexture(Button.__LBF_NormalSkin.EmptyTexture or Button.__LBF_NormalSkin.Texture or "")
			region.__LBF_UseEmpty = true
		end
	end
	-- Skins the Normal layer.
	function SkinNormalLayer(Skin,Button,ButtonData,xScale,yScale,Colors)
		local skin = Skin.Normal
		local region
		if skin.Static and ButtonData.Normal ~= false then
			region = ButtonData.Normal or Button:GetNormalTexture()
			if region then
				region:SetTexture("")
				region:Hide()
				Button.__LBF_NoNormal = true
			end
			region = base[Button] or Button:CreateTexture()
			base[Button] = region
		else
			region = ButtonData.Normal or Button:GetNormalTexture()
			if base[Button] then base[Button]:Hide() end
		end
		if not region then return end
		Button.__LBF_Normal = region
		if region:GetTexture() == "Interface\\Buttons\\UI-Quickslot" or region.__LBF_UseEmpty then
			region:SetTexture(skin.EmptyTexture or skin.Texture)
		else
			region:SetTexture(skin.Texture)
		end
		if not hooked[Button] then
			hooksecurefunc(Button,"SetNormalTexture",Hook_SetNormalTexture)
			hooked[Button] = true
		end
		Button.__LBF_NormalSkin = skin
		region:Show()
		if skin.Hide or ButtonData.Normal == false then
			region:SetTexture("")
			region:Hide()
			return
		end
		region:SetBlendMode(skin.BlendMode or "BLEND")
		region:SetDrawLayer(DrawLayers.Normal)
		region:SetWidth((skin.Width or 36) * (skin.Scale or 1) * xScale)
		region:SetHeight((skin.Height or 36) * (skin.Scale or 1) * yScale)
		region:ClearAllPoints()
		region:SetPoint("CENTER",Button,"CENTER",skin.OffsetX or 0,skin.OffsetY or 0)
		region:SetVertexColor(GetLayerColor(skin,Colors,"Normal"))
	end
	-- Gets the Normal texture.
	function LBF:GetNormalTexture(Button)
		return Button.__LBF_Normal or Button:GetNormalTexture()
	end
	-- Gets the Normal vertex color.
	function LBF:GetNormalVertexColor(Button)
		local region = self:GetNormalTexture(Button)
		if region then return region:GetVertexColor() end
	end
	-- Sets the Normal vertex color.
	function LBF:SetNormalVertexColor(Button,r,g,b,a)
		local region = self:GetNormalTexture(Button)
		if region then return region:SetVertexColor(r,g,b,a) end
	end
end

-- [ Border ] --

local SkinBorderLayer

do
	local border = {}
	-- Skins the border layer.
	function SkinBorderLayer(Skin,Button,ButtonData,xScale,yScale,Colors)
		local name = Button:GetName()
		local region = ButtonData.Border or name and _G[name.."Border"]
		if not region then return end
		local skin = Skin.Border
		if skin.Hide or ButtonData.Border == false then
			region:SetTexture("")
			region:Hide()
			return
		end
		border[Button] = region
		local parent = Button.__LBF_Level[Levels.Border]
		region:SetParent(parent or Button)
		region:SetTexture(skin.Texture)
		region:SetTexCoord(unpack(skin.TexCoords or TexCoords))
		region:SetBlendMode(skin.BlendMode or "BLEND")
		region:SetDrawLayer(DrawLayers.Gloss)
		region:SetWidth((skin.Width or 36) * (skin.Scale or 1) * xScale)
		region:SetHeight((skin.Height or 36) * (skin.Scale or 1) * yScale)
		region:ClearAllPoints()
		region:SetPoint("CENTER",Button,"CENTER",skin.OffsetX or 0,skin.OffsetY or 0)
		local type = Button.__LBF_Type
		if IsType(type) then
			SetBorderColor(region,GetBorderColor(type,Colors,skin))
		else
			region.__LBF_Disabled = true
		end
	end
	function LBF:SetBorderColor(Button,r,g,b,a)
		local region = border[Button]
		if region and Button.__LBF_Type == "Custom" then
			SetBorderColor(region,r,g,b,a)
		end
	end
end

-- [ Highlight ] --

-- Skins the Highlight layer.
local function SkinHighlightLayer(Skin,Button,ButtonData,xScale,yScale,Colors)
	local skin = Skin.Highlight
	local region = ButtonData.Highlight or Button:GetHighlightTexture()
	if not region then return end
	if skin.Hide or ButtonData.Highlight == false then
		region:SetTexture("")
		region:Hide()
		return
	end
	region:SetTexture(skin.Texture)
	region:SetBlendMode(skin.BlendMode or "BLEND")
	region:SetDrawLayer(DrawLayers.Highlight)
	region:SetWidth((skin.Width or 36) * (skin.Scale or 1) * xScale)
	region:SetHeight((skin.Height or 36) * (skin.Scale or 1) * yScale)
	region:ClearAllPoints()
	region:SetPoint("CENTER",Button,"CENTER",skin.OffsetX or 0,skin.OffsetY or 0)
	region:SetVertexColor(GetLayerColor(skin,Colors,"Highlight"))
end

-- [ Pushed ] --

-- Skins the Pushed layer.
local function SkinPushedLayer(Skin,Button,ButtonData,xScale,yScale,Colors)
	local skin = Skin.Pushed
	local region = ButtonData.Pushed or Button:GetPushedTexture()
	if not region then return end
	if skin.Hide or ButtonData.Pushed == false then
		region:SetTexture("")
		region:Hide()
		return
	end
	region:SetTexture(skin.Texture)
	region:SetDrawLayer(DrawLayers.Pushed)
	region:SetWidth((skin.Width or 36) * (skin.Scale or 1) * xScale)
	region:SetHeight((skin.Height or 36) * (skin.Scale or 1) * yScale)
	region:ClearAllPoints()
	region:SetPoint("CENTER",Button,"CENTER",skin.OffsetX or 0,skin.OffsetY or 0)
	region:SetBlendMode(skin.BlendMode or "BLEND")
	region:SetVertexColor(GetLayerColor(skin,Colors,"Pushed"))
end

-- [ Disabled ] --

-- Skins the Disabled layer.
local function SkinDisabledLayer(Skin,Button,ButtonData,xScale,yScale,Colors)
	local skin = Skin.Disabled
	local region = ButtonData.Disabled or Button:GetDisabledTexture()
	if not region then return end
	if skin.Hide or ButtonData.Disabled == false then
		region:SetTexture("")
		region:Hide()
		return
	end
	region:SetTexture(skin.Texture)
	region:SetBlendMode(skin.BlendMode or "BLEND")
	region:SetDrawLayer(DrawLayers.Disabled)
	region:SetWidth((skin.Width or 36) * (skin.Scale or 1) * xScale)
	region:SetHeight((skin.Height or 36) * (skin.Scale or 1) * yScale)
	region:ClearAllPoints()
	region:SetPoint("CENTER",Button,"CENTER",skin.OffsetX or 0,skin.OffsetY or 0)
	region:SetVertexColor(GetLayerColor(skin,Colors,"Disabled"))
end

-- [ Checked ] --

-- Skins the checked layer.
local function SkinCheckedLayer(Skin,Button,ButtonData,xScale,yScale,Colors)
	local skin = Skin.Checked
	local region = ButtonData.Checked or Button:GetCheckedTexture()
	if not region then return end
	if skin.Hide or ButtonData.Checked == false then
		region:SetTexture("")
		region:Hide()
		return
	end
	region:SetTexture(skin.Texture)
	region:SetBlendMode(skin.BlendMode or "BLEND")
	region:SetWidth((skin.Width or 36) * (skin.Scale or 1) * xScale)
	region:SetHeight((skin.Height or 36) * (skin.Scale or 1) * yScale)
	region:ClearAllPoints()
	region:SetPoint("CENTER",Button,"CENTER",skin.OffsetX or 0,skin.OffsetY or 0)
	region:SetVertexColor(GetLayerColor(skin,Colors,"Checked"))
end

-- [ Custom Layers ] --

-- [ Backdrop ] --

local RemoveBackdropLayer,SkinBackdropLayer

do
	local backdrop = {}
	local cache = {}
	-- Removes the backdrop layer.
	function RemoveBackdropLayer(Button)
		local region = backdrop[Button]
		backdrop[Button] = nil
		if region then
			region:Hide()
			cache[#cache+1] = region
		end
	end
	-- Skins the backdrop layer.
	function SkinBackdropLayer(Skin,Button,xScale,yScale,Colors)
		local skin = Skin.Backdrop
		local region
		local index = #cache
		if backdrop[Button] then
			region = backdrop[Button]
		elseif index > 0 then
			region = cache[index]
			cache[index] = nil
		else
			region = Button:CreateTexture(nil,"BACKGROUND")
		end
		backdrop[Button] = region
		local parent = Button.__LBF_Level[Levels.Backdrop]
		region:SetParent(parent or Button)
		region:Show()
		region:SetTexture(skin.Texture)
		region:SetTexCoord(unpack(skin.TexCoords or TexCoords))
		region:SetBlendMode(skin.BlendMode or "BLEND")
		region:SetDrawLayer(DrawLayers.Backdrop)
		region:SetWidth((skin.Width or 36) * (skin.Scale or 1) * xScale)
		region:SetHeight((skin.Height or 36) * (skin.Scale or 1) * yScale)
		region:ClearAllPoints()
		region:SetPoint("CENTER",Button,"CENTER",skin.OffsetX or 0,skin.OffsetY or 0)
		region:SetVertexColor(GetLayerColor(skin,Colors,"Backdrop"))
	end
	-- Gets the backdrop layer.
	function LBF:GetBackdropLayer(Button)
		return backdrop[Button]
	end
end

-- [ Gloss ] --

local RemoveGlossLayer,SkinGlossLayer

do
	local gloss = {}
	local cache = {}
	-- Removes the gloss layer.
	function RemoveGlossLayer(Button)
		local layer = gloss[Button]
		gloss[Button] = nil
		if layer then
			layer:Hide()
			cache[#cache+1] = layer
		end
	end
	-- Skins the gloss layer.
	function SkinGlossLayer(Skin,Button,xScale,yScale,Colors,Alpha)
		local skin = Skin.Gloss
		local region
		local index = #cache
		if gloss[Button] then
			region = gloss[Button]
		elseif index > 0 then
			region = cache[index]
			cache[index] = nil
			region:SetParent(Button)
		else
			region = Button:CreateTexture(nil,"OVERLAY")
		end
		gloss[Button] = region
		local parent = Button.__LBF_Level[Levels.Gloss]
		region:SetParent(parent or Button)
		region:Show()
		region:SetTexture(skin.Texture)
		region:SetTexCoord(unpack(skin.TexCoords or TexCoords))
		region:SetBlendMode(skin.BlendMode or "BLEND")
		region:SetDrawLayer(DrawLayers.Gloss)
		region:SetVertexColor(GetLayerColor(skin,Colors,"Gloss",Alpha))
		region:SetWidth((skin.Width or 36) * (skin.Scale or 1) * xScale)
		region:SetHeight((skin.Height or 36) * (skin.Scale or 1) * yScale)
		region:ClearAllPoints()
		region:SetPoint("CENTER",Button,"CENTER",skin.OffsetX or 0,skin.OffsetY or 0)
	end
	-- Gets the gloss layer.
	function LBF:GetGlossLayer(Button)
		return gloss[Button]
	end
end

-- [ Non-Special-Case Layers ] --

local SkinLayer

do
	-- Skins a non-special-case layer.
	function SkinLayer(Skin,Button,Layer,Region,xScale,yScale,Colors)
	-- btnlayer = btnlayer
		local skin = Skin[Layer]
		local type = LayerTypes[Layer]
		if skin.Hide then
			if type == "Texture" then
				Region:SetTexture("")
			end
			Region:Hide()
			return
		end
		Region:SetWidth((skin.Width or 36) * (skin.Scale or 1) * xScale)
		Region:SetHeight((skin.Height or 36) * (skin.Scale or 1) * yScale)
		Region:ClearAllPoints()
		Region:SetPoint("CENTER",Button,"CENTER",skin.OffsetX or 0,skin.OffsetY or 0)
		local parent = Button.__LBF_Level[Levels[Layer]]
		if type == "Texture" then
			Region:SetParent(parent or Button)
			Region:SetTexture(skin.Texture)
			Region:SetTexCoord(unpack(skin.TexCoords or TexCoords))
			Region:SetBlendMode(skin.BlendMode or "BLEND")
			Region:SetDrawLayer(DrawLayers[Layer])
			Region:SetVertexColor(GetLayerColor(skin,Colors,Layer))
		elseif type == "Icon" then
			Region:SetParent(parent or Button)
			Region:SetTexCoord(unpack(skin.TexCoords or TexCoords))
			Region:SetDrawLayer(DrawLayers[Layer])
		elseif type == "Text" then
			Region:SetParent(parent or Button)
			Region:SetDrawLayer(DrawLayers[Layer])
			Region:SetTextColor(GetLayerColor(skin,Colors,Layer))
		elseif type == "Frame" then
			local level = Button:GetFrameLevel()
			Region:SetFrameLevel(level + Offsets[Levels[Layer]])
		end
	end
end

-- [ Skins ] --

local Skins = {}
local SkinList = {}

do
	-- Adds a skin to the skin tables.
	function LBF:AddSkin(SkinID,SkinData,Replace)
		if type(SkinID) ~= "string" then
			Debug(E_ARG,"AddSkin","SkinID","string")
			return
		end
		if Skins[SkinID] and not Replace then
			return
		end
		if type(SkinData) ~= "table" then
			Debug(E_ARG,"AddSkin","SkinData","table")
			return
		end
		if SkinData.Template then
			if Skins[SkinData.Template] then
				setmetatable(SkinData,{__index=Skins[SkinData.Template]})
			else
				Debug(E_TPL,SkinID,SkinData.Template)
				return
			end
		end
		Skins[SkinID] = SkinData
		SkinList[SkinID] = SkinID
	end
	-- Returns the specified skin.
	function LBF:GetSkin(SkinID)
		return Skins[SkinID]
	end
	-- Returns the skin data table.
	function LBF:GetSkins()
		return Skins
	end
	-- Returns the skin list.
	function LBF:ListSkins()
		return SkinList
	end
end

local ApplySkin

do
	local hooked = {}
	local empty = {}
	-- Hook to automatically adjust the button's additional frames.
	local function Hook_SetFrameLevel(Button,Level)
		local base = Level or Button:GetFrameLevel()
		for k,v in pairs(Offsets) do
			local frame = Button.__LBF_Level[k]
			if frame then
				frame:SetFrameLevel(base + v)
			end
		end
	end
	-- Applies a skin to a button.
	function ApplySkin(SkinID,Gloss,Backdrop,Colors,Button,ButtonData)
		if not Button then return end
		local name = Button:GetName()
		Button.__LBF_Level = Button.__LBF_Level or {}
		-- Level 1: Frame to parent the background texture and icon to.
		if not Button.__LBF_Level[1] then
			local frame1 = CreateFrame("Frame",nil,Button)
			Button.__LBF_Level[1] = frame1
		end
		-- Level 2: Cooldown. This places it above the icon but under the "normal" texture.
		ButtonData.Cooldown = ButtonData.Cooldown or name and _G[name.."Cooldown"]
		if ButtonData.Cooldown then
			Button.__LBF_Level[2] = ButtonData.Cooldown
		end
		-- Level 3: The Button frame.
		Button.__LBF_Level[3] = Button
		-- Level 4: The AutoCast frame.
		ButtonData.AutoCast = ButtonData.AutoCast or name and _G[name.."Shine"]
		if ButtonData.AutoCast then
			Button.__LBF_Level[4] = ButtonData.AutoCast
		end
		-- Level 5: Frame to parent the text layers and AutoCastable/Gloss textures to.
		if not Button.__LBF_Level[5] then
			local frame5 = CreateFrame("Frame",nil,Button)
			Button.__LBF_Level[5] = frame5
		end
		if not hooked[Button] then
			hooksecurefunc(Button,"SetFrameLevel",Hook_SetFrameLevel)
			hooked[Button] = true
		end
		local level = Button:GetFrameLevel()
		if level < 4 then
			level = 4
		end
		Button:SetFrameLevel(level)
		if type(Gloss) ~= "number" then
			Gloss = Gloss and 1 or 0
		end
		Colors = Colors or empty
		local xScale = (Button:GetWidth() or 36) / 36
		local yScale = (Button:GetHeight() or 36) / 36
		local skin = Skins[SkinID or "Blizzard"] or Skins["Blizzard"]
		for layer in pairs(LayerTypes) do
			if ButtonData[layer] == nil then
				ButtonData[layer] = name and _G[name..layer]
			end
			local region = ButtonData[layer]
			if region then
				SkinLayer(skin,Button,layer,region,xScale,yScale,Colors)
			end
		end
		SkinNormalLayer(skin,Button,ButtonData,xScale,yScale,Colors)
		SkinHighlightLayer(skin,Button,ButtonData,xScale,yScale,Colors)
		SkinPushedLayer(skin,Button,ButtonData,xScale,yScale,Colors)
		SkinDisabledLayer(skin,Button,ButtonData,xScale,yScale,Colors)
		SkinBorderLayer(skin,Button,ButtonData,xScale,yScale,Colors)
		if Button:GetObjectType() == "CheckButton" then
			SkinCheckedLayer(skin,Button,ButtonData,xScale,yScale,Colors)
		end
		if Backdrop and not skin.Backdrop.Hide then
			SkinBackdropLayer(skin,Button,xScale,yScale,Colors)
		else
			RemoveBackdropLayer(Button)
		end
		if Gloss > 0 and not skin.Gloss.Hide then
			SkinGlossLayer(skin,Button,xScale,yScale,Colors,Gloss)
		else
			RemoveGlossLayer(Button)
		end
	end
end

-- [ Groups ] --

-- Returns a group ID. IE: Addon, Addon_Group or Addon_Group_Button.
local function RegID(Addon,Group,Button)
	local id = "ButtonFacade"
	if Addon then
		id = Addon
		if Group then
			id = id.."_"..Group
			if Button then
				id = id.."_"..Button
			end
		end
	end
	return id
end

local Groups = {}
local GroupMT

-- Creates and returns a group.
local function NewGroup(Addon,Group,Button)
	if not Group then Button = nil end
	local o = {
		Addon = Addon,
		Group = Group,
		Button = Button,
		RegID = RegID(Addon,Group,Button),
		SkinID = "Blizzard",
		Gloss = false,
		Backdrop = false,
		Borders = false,
		Colors = {},
		Buttons = {},
		SubList = not Button and {} or nil,
	}
	setmetatable(o,GroupMT)
	Groups[o.RegID] = o
	if Addon then
		local a = Groups["ButtonFacade"] or NewGroup()
		o.Parent = a
		a:AddSubGroup(Addon)
	end
	if Group then
		local a = Groups[Addon] or NewGroup(Addon)
		o.Parent = a
		a:AddSubGroup(Group)
		if Button then
			local ag = Groups[Addon.."_"..Group] or NewGroup(Addon,Group)
			o.Parent = ag
			ag:AddSubGroup(Button)
		end
	end
	return o
end

-- Returns a group.
function LBF:Group(Addon,Group,Button)
	local group = Groups[RegID(Addon,Group,Button)] or NewGroup(Addon,Group,Button)
	return group
end

-- Returns a list of add-ons.
function LBF:ListAddons()
	local group = self:Group()
	return group.SubList
end

-- Returns a list of groups registered to an add-on.
function LBF:ListGroups(Addon)
	return Groups[Addon].SubList
end

-- Returns a list of buttons registered to a group.
function LBF:ListButtons(Addon,Group)
	return Groups[Addon.."_"..Group].SubList
end
do
	local reverse = {}
	-- Group Metatable
	GroupMT = {
		__index = {
			-- [ Button ] --
			-- Adds a button to the group.
			AddButton = function(self,Button,ButtonData,Type)
				if type(Button) ~= "table" then
					Debug(E_ARG,"AddButton","Button","table")
					return
				end
				if reverse[Button] == self then return end
				if reverse[Button] then
					reverse[Button]:RemoveButton(Button,true)
				end
				reverse[Button] = self
				ButtonData = ButtonData or {}
				self.Buttons[Button] = ButtonData
				self:SetButtonType(Button,Type,true)
				ApplySkin(self.SkinID,self.Gloss,self.Backdrop,self.Colors,Button,ButtonData)
			end,
			-- Removes a button from the group and optionally reskins it.
			RemoveButton = function(self,Button,noReskin)
				if not Button then return end
				local btndata = self.Buttons[Button]
				reverse[Button] = nil
				if btndata and not noReskin then
					ApplySkin("Blizzard",false,false,nil,Button,btndata)
				end
				self.Buttons[Button] = nil
			end,
			-- Sets a button's type and optionally reskins it.
			SetButtonType = function(self,Button,Type,noReskin)
				if not Button then return end
				if IsType(Type) then
					Button.__LBF_Type = Type
					self.Borders = true
				else
					Button.__LBF_Type = nil
				end
				local btndata = self.Buttons[Button]
				if btndata and not noReskin then
					ApplySkin(self.SkinID,self.Gloss,self.Backdrop,self.Colors,Button,self.Buttons[Button])
				end
			end,
			-- Deletes the current group.
			Delete = function(self,noReskin)
				local sl = self.SubList
				if sl then
					for k in pairs(sl) do
						Groups[k]:Delete()
					end
				end
				for k in pairs(self.Buttons) do
					reverse[k] = nil
					if not noReskin then
						ApplySkin("Blizzard",false,false,nil,k,self.Buttons[k])
					end
					self.Buttons[k] = nil
				end
				self.Parent:RemoveSubGroup(self)
				Groups[self.RegID] = nil
			end,
			-- [ Skin ] --
			-- Updates the groups's skin with the new data and then applies it.
			Skin = function(self,SkinID,Gloss,Backdrop,Colors)
				self.SkinID = SkinID and SkinList[SkinID] or self.SkinID
				if type(Gloss) ~= "number" then
					Gloss = Gloss and 1 or 0
				end
				self.Gloss = Gloss
				self.Backdrop = Backdrop and true or false
				if type(Colors) == "table" then
					self.Colors = Colors
				end
				for k in pairs(self.Buttons) do
					ApplySkin(self.SkinID,self.Gloss,self.Backdrop,self.Colors,k,self.Buttons[k])
				end
				FireSkinCB(self.Addon,self.SkinID,self.Gloss,self.Backdrop,self.Group,nil,self.Colors)
				local sl = self.SubList
				if sl then
					for k in pairs(sl) do
						Groups[k]:Skin(SkinID,Gloss,Backdrop,Colors)
					end
				end
			end,
			-- Updates the group's skin data without applying the new skin.
			SetSkin = function(self,SkinID,Gloss,Backdrop,Colors)
				self.SkinID = SkinID and SkinList[SkinID] or self.SkinID
				if type(Gloss) ~= "number" then
					Gloss = Gloss and 1 or 0
				end
				self.Gloss = Gloss
				self.Backdrop = Backdrop and true or false
				if type(Colors) == "table" then
					self.Colors = Colors
				end
				FireSkinCB(self.Addon,self.SkinID,self.Gloss,self.Backdrop,self.Group,self.Button,self.Colors)
			end,
			-- Reskins the group.
			ReSkin = function(self)
				self:Skin(self.SkinID,self.Gloss,self.Backdrop,self.Colors)
			end,
			-- [ Internal ] --
			-- Adds a sub-group to a group.
			AddSubGroup = function(self,SubGroup)
				if self.RegID == "ButtonFacade" then
					self.SubList[SubGroup] = SubGroup
				else
					self.SubList[self.RegID.."_"..SubGroup] = SubGroup
				end
				FireGuiCB(self.Addon,self.Group,self.Button)
			end,
			-- Removes a sub-group from a group.
			RemoveSubGroup = function(self,SubGroup)
				local r = SubGroup.RegID
				self.SubList[r] = nil
				FireGuiCB(self.Addon,self.Group,self.Button)
			end,
			-- [ GUI ] --
			-- Returns a layer's color.
			GetLayerColor = function(self,Layer)
				local skin = Skins[self.SkinID or "Blizzard"] or Skins["Blizzard"]
				return GetLayerColor(skin[Layer],self.Colors,Layer)
			end,
			-- Sets a layer's color and optionally reskins the group.
			SetLayerColor = function(self,Layer,r,g,b,a)
				if r then
					self.Colors[Layer] = {r,g,b,a}
				else
					self.Colors[Layer] = nil
				end
				if not noReskin then self:ReSkin() end
			end,
			-- Returns a border type's color.
			GetBorderColor = function(self,Type)
				local skin = Skins[self.SkinID or "Blizzard"] or Skins["Blizzard"]
				return GetBorderColor(Type,self.Colors,skin.Border)
			end,
			-- Sets a border type's color and optionally reskins the group.
			SetBorderColor = function(self,Type,r,g,b,a,noReskin)
				self.Colors.Borders = self.Colors.Borders or {}
				if r then
					self.Colors.Borders[Type] = {r,g,b,a}
				else
					self.Colors.Borders[Type] = nil
				end
				if not noReskin then self:ReSkin() end
			end,
			-- Resets a layer's colors.
			ResetColors = function(self,noReskin)
				local c = self.Colors
				for k in pairs(c) do c[k] = nil end
				local sl = self.SubList
				if sl then
					for k in pairs(sl) do
						Groups[k]:ResetColors(true)
					end
				end
				if not noReskin then self:Skin() end
			end,
		}
	}
end

-- [ Default Skin ] --

LBF:AddSkin("Blizzard",{
	Backdrop = {
		Width = 34,
		Height = 35,
		Texture = [[Interface\Buttons\UI-EmptySlot]],
		OffsetY = -0.5,
		TexCoords = {0.2,0.8,0.2,0.8},
	},
	Icon = {
		Width = 36,
		Height = 36,
	},
	Pushed = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\Buttons\UI-Quickslot-Depress]],
	},
	Flash = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\Buttons\UI-QuickslotRed]],
	},
	Cooldown = {
		Width = 36,
		Height = 36,
	},
	Normal = {
		Width = 66,
		Height = 66,
		Texture = [[Interface\Buttons\UI-Quickslot2]],
		EmptyTexture = [[Interface\Buttons\UI-Quickslot]],
		OffsetY = -1,
	},
	Disabled = {
		Width = 66,
		Height = 66,
		Texture = [[Interface\Buttons\UI-Quickslot2]],
		OffsetY = -1,
	},
	Checked = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\Buttons\CheckButtonHilight]],
		BlendMode = "ADD",
	},
	Border = {
		Width = 62,
		Height = 62,
		Texture = [[Interface\Buttons\UI-ActionButton-Border]],
		BlendMode = "ADD",
	},
	Highlight = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\Buttons\ButtonHilight-Square]],
		BlendMode = "ADD",
	},
	AutoCast = {
		Width = 36,
		Height = 36,
	},
	AutoCastable = {
		Width = 58,
		Height = 58,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Gloss = {
		Hide = true
	},
	HotKey = {
		Width = 36,
		Height = 10,
		OffsetX = -2,
		OffsetY = 11,
	},
	Count = {
		Width = 36,
		Height = 10,
		OffsetX = -2,
		OffsetY = -11,
	},
	Name = {
		Width = 36,
		Height = 10,
		OffsetY = -11,
	},
})
LBFG = Groups