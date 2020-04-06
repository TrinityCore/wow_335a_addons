if not Skinner:isAddonEnabled("Carbonite") then return end

function Skinner:Carbonite()

	local lshift = bit.lshift
	local band = bit.band

	local function P_23(r, g, b, a)

		local clr = r*255
		clr = lshift(clr,8)+g*255
		clr = lshift(clr,8)+b*255
		clr = lshift(clr,8)+a*255
		return clr
	end

	local BdC = self.db.profile.Backdrop
	local bdClr = P_23(BdC.r, BdC.g, BdC.b, BdC.a)
	local BdBC = self.db.profile.BackdropBorder

	-- create skin entry
	Nx.Ski1["Skinner"] = {
		["Folder"] = "",
		["WinBrH"] = "WinBrH",
		["WinBrV"] = "WinBrV",
		["TabOff"] = "TabOff",
		["TabOn"] = "TabOn",
		["Backdrop"] = CopyTable(Skinner.backdrop),
		["BdCol"] = P_23(BdBC.r, BdBC.g, BdBC.b, BdBC.a),
		["BgCol"] = bdClr,
	}
	-- add entry to options
	for i, v in pairs(Nx.OpD) do
--		self:Debug("Carbonite: [%s, %s]", i, v.N)
		if v.N == "Skin" then
			table.insert(Nx.OpD[i], {N = "Skinner", F = "NXCmdSkin", Dat = "Skinner"})
			break
		end
	end

	local function onUpdate(win)

		local alpha, max = win.NxW.BaF, win.NxW.BAD
--		self:Debug("win_OnU: [%s, %s, %s]", win, alpha, max)
		if alpha >= max then win.tfade:Show()
		else win.tfade:Hide() end

	end

	-- skin Title frame
	self:addSkinFrame{obj=Nx.Tit.Frm, kfs=true}

	-- add a gradient to the existing frames
	for win, _ in pairs(Nx.Win.Win2) do
		self:applyGradient(win.Frm)
		win.Frm.tfade:Hide() -- hide the Gradient
		-- hook this to fade the frames' Gradient
		self:HookScript(win.Frm, "OnUpdate", function(this, ...)
			onUpdate(this)
		end)
	end
	-- add a gradient to the existing menu frames
	for men, _ in pairs(Nx.Men.Men1) do
		self:applyGradient(men.MaF)
	end

-->>-- Hooks
	-- hook this to manage the backdrop colour for fixed sized frames
	self:RawHook(Nx.Ski, "GFSBGC", function(this)
		return {BdC.r, BdC.g, BdC.b, BdC.a}
	end, true)
	-- hook this to add a Gradient to new frames
	self:RawHook(Nx.Win, "Cre", function(this, ...)
		local win = self.hooks[this].Cre(this, ...)
		self:applyGradient(win.Frm)
		win.Frm.tfade:Hide() -- hide the Gradient
		-- hook this to fade the frames' Gradient
		self:HookScript(win.Frm, "OnUpdate", function(this, ...)
			onUpdate(this)
		end)
		return win
	end)
	-- hook this to add a Gradient to new menu frames
	self:RawHook(Nx.Men, "Cre", function(this, ...)
		local men = self.hooks[this].Cre(this, ...)
		self:applyGradient(men.MaF)
		return men
	end)

	-- use Skinner skin
	Nx.Ski:Set("Skinner")

end
