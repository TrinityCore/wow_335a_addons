if not Skinner:isAddonEnabled("Skada") then return end

function Skinner:Skada()

	local function changeSettings(db)

		db.barcolor = CopyTable(Skinner.db.profile.StatusBar)
		db.bartexture = db.bartexture == "Empty" and db.bartexture or db.barcolor.texture -- change if not "Empty" texture
		db.barcolor.texture = nil -- remove texture element
		-- background settings
		db.background.texture = Skinner.db.profile.BdTexture
		db.background.margin = Skinner.db.profile.BdInset
		db.background.borderthickness = Skinner.db.profile.BdEdgeSize
		db.background.bordertexture = Skinner.db.profile.BdBorderTexture
		db.background.color = Skinner.db.profile.Backdrop

	end
	local function skinFrame(win)

		-- skin windows if required
		if win.db.enablebackground
		and not Skinner.skinFrame[win.bargroup.bgframe]
		then
			Skinner:addSkinFrame{obj=win.bargroup.bgframe}
			win.bargroup.bgframe:SetBackdrop(nil)
			win.bargroup.bgframe.SetBackdrop = function() end
		end

	end
	local barDisplay = Skada:GetModule("BarDisplay", true)
	if barDisplay then
		-- hook this to skin new frames
		self:SecureHook(barDisplay, "ApplySettings", function(this, win)
			skinFrame(win)
		end)
	end

	-- change the default settings
	changeSettings(Skada.windowdefaults)

	-- change existing ones
	for i, win in pairs(Skada:GetWindows()) do
		changeSettings(win.db)
		skinFrame(win)
		-- apply these changes
		win.display:ApplySettings(win)
	end

end
