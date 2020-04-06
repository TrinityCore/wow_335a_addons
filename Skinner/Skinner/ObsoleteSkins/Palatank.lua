
function Skinner:Palatank()

	self:applySkin(Palatank_PP_Frame)
	self:applySkin(Palatank_Aura_Frame)
	Palatank_Frame:SetHeight(Palatank_Frame:GetHeight() + 5)
	self:moveObject(Palatank_Frame_Text, nil, nil, "+", 2)
	self:applySkin(Palatank_Frame)
	self:applySkin(Palatank_RF_Frame)
	self:applySkin(Palatank_AD_Frame)
	self:moveObject(Palatank_Info_Frame_Name_Text, "+", 4, nil, nil)
	self:applySkin(Palatank_Info_Frame)
	self:applySkin(Palatank_Spell_Frame)

-->>--	Menu Frame
	self:keepFontStrings(Palatank_Menu_Frame)
	self:applySkin(Palatank_Menu_Frame)

end
