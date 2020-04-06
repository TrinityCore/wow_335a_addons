if not Skinner:isAddonEnabled("BossNotes") then return end

function Skinner:BossNotes()

	self:skinDropDown{obj=BossNotesInstanceDropDown}
	self:skinDropDown{obj=BossNotesEncounterDropDown}
	self:skinScrollBar{obj=BossNotesSourceListScrollFrame}
	self:skinScrollBar{obj=BossNotesNoteScrollFrame}
	self:skinDropDown{obj=BossNotesChatDropDown}
	self:addSkinFrame{obj=BossNotesFrame, kfs=true, x1=10, y1=-12, x2=-32, y2=71}

-->>-- Personal Notes Editor
	self:addSkinFrame{obj=BossNotesPersonalNotesEditorScrollFrameBackground}
	self:skinScrollBar{obj=BossNotesPersonalNotesEditorScrollFrame}
	self:addSkinFrame{obj=BossNotesPersonalNotesEditor}

-->>-- Personal Notes Context Menu
	self:addSkinFrame{obj=BossNotesPersonalNotesContextMenu}

end
