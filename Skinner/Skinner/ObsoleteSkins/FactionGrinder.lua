
function Skinner:FactionGrinder()

-->>--	FactionGrinder SettingsFrame
	self:keepFontStrings(FactionGrinderSettingsFrame)
	FG_SettingsFrameHeaderBox:Hide()
	FGScrollChild_Background:Hide()
	self:moveObject(FG_CloseSettings, "+", 6, "+", 6)
	self:moveObject(FG_SettingsFrameHeader, nil, nil, "-", 6)
	self:keepFontStrings(FGScrollFrame)
	self:skinScrollBar(FGScrollFrame)
	self:keepFontStrings(FactionGrinderGeneralSettingsFrame)
	self:applySkin(FactionGrinderGeneralSettingsFrame)
	self:applySkin(FactionGrinderSettingsFrame)

-->>--	Faction Frames
	for frame, _ in pairs(FactionGrinderSettings["Show"]) do
--		self:Debug("skinFGFrame: [%s]", frame)
		if _G[frame] then self:applySkin(_G[frame]) end
	end
	for _, abbrev in pairs(FactionGrinderSettings["Abbreviations"]) do
--		self:Debug("skinFGFrame#2: [%s]", abbrev)
		self:keepFontStrings(_G[abbrev.."ToRepUpFrame"])
		self:applySkin(_G[abbrev.."ToRepUpFrame"])
		self:keepFontStrings(_G[abbrev.."_SB_ActualRep"])
		self:keepFontStrings(_G[abbrev.."_SB_RepWithItems"])
		self:glazeStatusBar(_G[abbrev.."_SB_ActualRep"], 0)
		self:glazeStatusBar(_G[abbrev.."_SB_RepWithItems"], 0)
		local tt = _G[abbrev.."ToolTip"]
		if not self:IsHooked(tt, "OnShow") then
			if self.db.profile.Tooltips.style == 3 then tt:SetBackdrop(self.backdrop) end
			self:RawHookScript(tt, "OnShow", function(this)
				self.hooks[this].OnShow(this)
				self:skinTooltip(this)
			end)
		end
	end
-->>--	Other adjustments
	CenarionCircleGrinderDisplayFrame:SetWidth(CenarionCircleGrinderDisplayFrame:GetWidth() + 10)

end
