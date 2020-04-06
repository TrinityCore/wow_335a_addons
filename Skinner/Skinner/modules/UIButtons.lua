local _, Skinner = ...
local module = Skinner:NewModule("UIButtons", "AceHook-3.0")
local _G = _G

local db
local defaults = {
	profile = {
		UIButtons = false,
	}
}

local function __checkTex(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		nTex = Texture
		mp2 = minus/plus type 2
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object __cT\n"..debugstack())
--@end-alpha@]===]

	-- hide existing textures if they exist (GupCharacter requires this)
	if opts.obj:GetNormalTexture() then opts.obj:GetNormalTexture():SetAlpha(0) end
	if opts.obj:GetPushedTexture() then opts.obj:GetPushedTexture():SetAlpha(0) end
	if opts.obj:GetDisabledTexture() then opts.obj:GetDisabledTexture():SetAlpha(0) end

	local nTex = opts.nTex or opts.obj:GetNormalTexture() and opts.obj:GetNormalTexture():GetTexture() or nil
	local btn = opts.mp2 and opts.obj or Skinner.sBut[opts.obj]
	if not btn then return end -- allow for unskinned buttons

--	Skinner:Debug("__checkTex: [%s, %s, %s]", opts.obj, nTex, opts.mp2)

	if not opts.mp2 then btn:Show() end

	if nTex then
		if btn.skin then btn:Show() end -- Waterfall/tomQuest2
		if nTex:find("MinusButton") then
			btn:SetText(module.minus)
		elseif nTex:find("PlusButton") then
			btn:SetText(module.plus)
		else -- not a header line
			btn:SetText("")
			if not opts.mp2 then btn:Hide() end
		end
	else -- not a header line
		btn:SetText("")
		if not opts.mp2
		or btn.skin -- Waterfall/tomQuest2
		then
			btn:Hide()
		end
	end

end
function module:checkTex(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object cT\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.nTex = select(2, ...) and select(2, ...) or nil
		opts.mp2 = select(3, ...) and select(3, ...) or nil
	end
	__checkTex(opts)

end

-- characters used on buttons
module.mult = "×"
module.plus = "+"
module.minus = "-" -- using Hyphen-minus(-) instead of minus sign(−) for font compatiblity reasons
-- create font to use for Close Buttons
module.fontX= CreateFont("fontX")
module.fontX:SetFont([[Fonts\FRIZQT__.TTF]], 22)
module.fontX:SetTextColor(1.0, 0.82, 0)
-- create font to use for small blue Close Buttons (e.g. BNToastFrame)
module.fontSBX= CreateFont("fontSBX")
module.fontSBX:SetFont([[Fonts\FRIZQT__.TTF]], 14)
module.fontSBX:SetTextColor(0.2, 0.6, 0.8)
-- create font to use for Minus/Plus Buttons
module.fontP= CreateFont("fontP")
module.fontP:SetFont([[Fonts\ARIALN.TTF]], 16)
module.fontP:SetTextColor(1.0, 0.82, 0)
local btnTexNames = {"Left", "Middle", "Right", "_LeftTexture", "_MiddleTexture", "_RightTexture"}
function module:skinButton(opts)
--[[
	as = use applySkin rather than addSkinButton, used when text appears behind the gradient
	cb = close button
	cb2 = close button style 2 (based upon OptionsButtonTemplate)
	mp = minus/plus texture on a larger button
	mp2 = minus/plus button
	ob = other button, text supplied
	plus = use plus sign
	other options as per addSkinButton
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object skinButton\n"..debugstack())
--@end-alpha@]===]

	if not opts.obj then return end

	-- don't skin it twice
	if Skinner.sBut[opts.obj] then return end

	if opts.obj.GetNormalTexture and opts.obj:GetNormalTexture() then -- [UIPanelButtonTemplate/UIPanelCloseButton/... and derivatives]
		opts.obj:GetNormalTexture():SetAlpha(0)
		if opts.obj:GetPushedTexture() then opts.obj:GetPushedTexture():SetAlpha(0) end
		if opts.obj:GetDisabledTexture() then opts.obj:GetDisabledTexture():SetAlpha(0) end
	elseif opts.obj.left then -- ARL & Collectinator
		opts.obj.left:SetAlpha(0)
		opts.obj.middle:SetAlpha(0)
		opts.obj.right:SetAlpha(0)
	elseif opts.obj.LeftTexture then -- Outfitter
		opts.obj.LeftTexture:SetAlpha(0)
		opts.obj.MiddleTexture:SetAlpha(0)
		opts.obj.RightTexture:SetAlpha(0)
	else -- [UIPanelButtonTemplate2/... and derivatives]
		local objName = opts.obj:GetName()
		if objName then -- handle unnamed objects (e.g. Waterfall MP buttons)
			for _, tName in pairs(btnTexNames) do
				local bTex = _G[objName..tName]
				if bTex then bTex:SetAlpha(0) end
			end
		end
	end

	local x1, x2, y1, y2, btn
	local bW, bH = floor(opts.obj:GetWidth()), floor(opts.obj:GetHeight())
	if bW <= 20 and opts.cb then -- ArkInventory/Recount close buttons
		local adj = bW < 20 and bW + 1 or bW
--		print(opts.obj:GetParent():GetName(), bW, adj)
		opts.cb2 = opts.cb
		opts.cb = nil
		opts.x1, opts.y1, opts.x2, opts.y2 = bW - adj, 0, adj - bW, 0
	end
	if opts.cb then -- it's a close button
		opts.obj:SetNormalFontObject(module.fontX)
		opts.obj:SetText(module.mult)
		opts.obj:SetPushedTextOffset(-1, -1)
		if opts.sap then
			Skinner:addSkinButton{obj=opts.obj, parent=opts.obj, sap=true}
		else
			x1 = opts.x1 or bW == 32 and 6 or 4
			y1 = opts.y1 or bW == 32 and -6 or -4
			x2 = opts.x2 or bW == 32 and -6 or -4
			y2 = opts.y2 or bW == 32 and 6 or 4
			Skinner:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=Skinner.Backdrop[5]}, x1=x1, y1=y1, x2=x2, y2=y2}
		end
	elseif opts.cb2 then -- it's pretending to be a close button (e.g. ArkInventory/Recount/Outfitter)
		x1 = opts.x1 or 0
		y1 = opts.y1 or 0
		x2 = opts.x2 or 0
		y2 = opts.y2 or 0
		Skinner:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=Skinner.Backdrop[5]}, x1=x1, y1=y1, x2=x2, y2=y2}
		btn = Skinner.sBut[opts.obj]
		btn:SetNormalFontObject(module.fontX)
		btn:SetText(module.mult)
	elseif opts.cb3 then -- it's a small blue close button
		Skinner:adjWidth{obj=opts.obj, adj=-4}
		Skinner:adjHeight{obj=opts.obj, adj=-4}
		Skinner:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=Skinner.Backdrop[5], bba=0}, x1=2, y1=1, x2=2, y2=1}
		btn = Skinner.sBut[opts.obj]
		btn:SetNormalFontObject(module.fontSBX)
		btn:SetText(module.mult)
	elseif opts.mp then -- it's a minus/plus texture on a larger button
		Skinner:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=Skinner.Backdrop[6]}}
		btn = Skinner.sBut[opts.obj]
		btn:SetAllPoints(opts.obj:GetNormalTexture())
		btn:SetNormalFontObject(module.fontP)
		btn:SetText(opts.plus and module.plus or module.minus)
	elseif opts.mp2 then -- it's a minus/plus button (IOF has them on RHS)
		opts.obj:SetNormalFontObject(module.fontP)
		opts.obj:SetText(opts.plus and module.plus or module.minus)
		opts.obj:SetPushedTextOffset(-1, -1)
		if not opts.as then
			Skinner:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=Skinner.Backdrop[6]}, sap=true}
			module:SecureHook(opts.obj, "SetNormalTexture", function(this, nTex)
				module:checkTex{obj=this, nTex=nTex, mp2=true}
			end)
		else -- just skin it (used by Waterfall & tomQuest2)
			Skinner:applySkin{obj=opts.obj, bd=Skinner.Backdrop[6]}
			opts.obj.skin = true
		end
	elseif opts.ob then -- it's another type of button, text supplied (e.g. beql minimize)
		opts.obj:SetNormalFontObject(module.fontP)
		opts.obj:SetText(opts.ob)
		opts.obj:SetPushedTextOffset(-1, -1)
		if opts.sap then
			Skinner:addSkinButton{obj=opts.obj, parent=opts.obj, sap=true}
		else
			x1 = opts.x1 or bW == 32 and 6 or 4
			y1 = opts.y1 or bW == 32 and -6 or -4
			x2 = opts.x2 or bW == 32 and -6 or -4
			y2 = opts.y2 or bW == 32 and 6 or 4
			Skinner:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=Skinner.Backdrop[5]}, x1=x1, y1=y1, x2=x2, y2=y2}
		end
	else -- standard button (UIPanelButtonTemplate/UIPanelButtonTemplate2 and derivatives)
		aso = {bd=Skinner.Backdrop[bH > 18 and 5 or 6]} -- use narrower backdrop if required
		if not opts.as then
			x1 = opts.x1 or 1
			y1 = opts.y1 or -1
			x2 = opts.x2 or -1
			y2 = opts.y2 or -1
			Skinner:addSkinButton{obj=opts.obj, parent=opts.obj, aso=aso, bg=opts.bg, x1=x1, y1=y1, x2=x2, y2=y2}
		else
			Skinner:applySkin{obj=opts.obj, bd=aso.bd}
		end
	end
	-- centre text on button
	if btn then
		btn:GetFontString():SetAllPoints()
	elseif opts.obj:GetFontString() then -- StaticPopup buttons don't have a FontString
		opts.obj:GetFontString():SetAllPoints()
		-- centre highlight as well
		if opts.obj:GetHighlightTexture() then opts.obj:GetHighlightTexture():SetAllPoints() end
	end

end

local function getTexture(obj)

	if obj
	and obj:IsObjectType("Texture")
	then
		return obj:GetTexture()
	else
		return
	end

end
function module:isButton(obj, cb, blue)

	if obj:IsObjectType("Button")
	and obj.GetNormalTexture -- is it a true button
	and not obj.GetChecked -- and not a checkbutton
	and not obj.SetSlot -- and not a lootbutton
	then -- check textures are as expected
		local nTex = getTexture(obj:GetNormalTexture())
		if not cb then
			local oName = obj:GetName() or nil
			local lTex = oName and (getTexture(_G[oName.."Left"]) or getTexture(_G[oName.."_LeftTexture"])) or nil
			if nTex and nTex:find("UI-Panel-Button", 1, true)
			or nTex and nTex:find("UI-DialogBox", 1, true) -- StaticPopups
			or nTex and nTex:find("UI-Achievement", 1, true) -- AtlasLoot "new" style
			or obj.left and obj.left:GetTexture() and strfind(obj.left:GetTexture(), "UI-Panel-Button", 1, true) -- ARL & Collectinator
			or oName and lTex and lTex:find("UI-Panel-Button", 1, true)
			and not (oName:find("AceConfig") or oName:find("AceGUI")) -- ignore AceConfig/AceGui buttons
			then
				return true
			end
		elseif not blue then
			if nTex and nTex:find("UI-Panel-MinimizeButton", 1, true)
			then
				return true
			end
		else	
			if nTex and nTex:find("UI-Toast-CloseButton", 1, true)
			then
				return true
			end
		end
	end

	return false

end

local function __skinAllButtons(opts, bgen)
--[[
	Calling parameters:
		obj = object (Mandatory)
		bgen = generations of children to traverse
		other options as per skinButton
--]]
--[===[@alpha@
	assert(opts.obj, "Unknown object__sAB\n"..debugstack())
--@end-alpha@]===]
	if not opts.obj then return end

	-- maximum number of button generations to traverse
	bgen = bgen or (opts.bgen and opts.bgen or 3)

	for _, child in ipairs{opts.obj:GetChildren()} do
		if module:isButton(child) then -- normal button
			module:skinButton{obj=child, x1=opts.x1, y1=opts.y1, x2=opts.x2, y2=opts.y2}
		elseif module:isButton(child, true) then -- close button
			module:skinButton{obj=child, cb=true, sap=opts.sap}
		elseif module:isButton(child, true, true) then -- small blue close button
			module:skinButton{obj=child, cb3=true}
		elseif child:IsObjectType("Frame")
		and bgen > 0 then
			opts.obj=child
			__skinAllButtons(opts, bgen - 1)
		end
	end

end
function module:skinAllButtons(...)

	local opts = select(1, ...)

--[===[@alpha@
	assert(opts, "Unknown object sAB\n"..debugstack())
--@end-alpha@]===]

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
	end
	__skinAllButtons(opts)

end

function module:OnInitialize()

	self.db = Skinner.db:RegisterNamespace("UIButtons", defaults)
	db = self.db.profile

	-- convert any old settings
	if Skinner.db.profile.Buttons then
		db.UIButtons = Skinner.db.profile.Buttons
		Skinner.db.profile.Buttons = nil
	end

	if not db.UIButtons then self:Disable() end -- disable ourself

end

function module:GetOptions()

	local options = {
		type = "toggle",
		name = Skinner.L["UI Buttons"],
		desc = Skinner.L["Toggle the skinning of the UI Buttons, reload required"],
		get = function(info) return module.db.profile.UIButtons end,
		set = function(info, value) module.db.profile.UIButtons = value end,
	}
	return options

end
