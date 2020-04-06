
function Skinner:DopieArenaInfo()

-->>--	Help Frame
	self:applySkin(DopieArenaInfoHelpFrame)
-->>--	Arean Info Frames
	self:applySkin(DopieArenaInfoFrame1)
	self:applySkin(DopieArenaInfoFrame2)
	self:applySkin(DopieArenaInfoFrame3)
	self:applySkin(DopieArenaInfoFrame4)
	self:applySkin(DopieArenaInfoFrame5)
-->>--	Config Quick Spell Frame
	self:applySkin(DopieArenaInfoConfigQuickSpell)
	for _, class in pairs({ "Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior" }) do
		local ebPrefix = "DopieArenaInfoConfigQuickSpell_"..class
		self:skinEditBox(_G[ebPrefix.."Name1"], {9})
		self:skinEditBox(_G[ebPrefix.."Macro1"], {9})
		self:skinEditBox(_G[ebPrefix.."Name2"], {9})
		self:skinEditBox(_G[ebPrefix.."Macro2"], {9})
	end
-->>--	Config Frame
	self:applySkin(DopieArenaInfoConfig)

end
