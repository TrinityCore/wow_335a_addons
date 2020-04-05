
local panel = Panda.panel:NewPanel(true)
local NAME, _, MILLICON = GetSpellInfo(51005)
local NAME2 = GetSpellInfo(45357)
local inks = "39469 39774 43115 43116 43117 43118 43118 43119 43120 43121 43122 43123 43124 43125 43126 43127"
panel:RegisterFrame(NAME, Panda.PanelFactory(45357,
[[39151   0   39469   0     0    2447   765  2449   0     0     0     0     0     0     0    6948
  39334 43103 39774 43115   0     785  2450  2452  3820  2453
  39338 43104 43116 43117   0    3369  3355  3356  3357
  39339 43105 43118 43119   0    3818  3821  3358  3819
  39340 43106 43120 43121   0    4625  8831  8836  8838  8845  8839  8846
  39341 43107 43122 43123   0   13464 13463 13465 13466 13467
  39342 43108 43124 43125   0   22785 22786 22787 22789 22790 22791 22792 22793
  39343 43109 43126 43127   0   36901 36903 36904 36905 36906 36907 37921 39970
]], function(id, frame) if id == 6948 and not GetSpellInfo((GetSpellInfo(45357))) then frame:Hide() end end, function(frame)
	frame:SetAttribute("type", "macro")
	if frame.id == 6948 then
		frame.icon:SetTexture(MILLICON)
		frame.id = nil
		frame.tiptext = "Mass Mill\nThis will mill any available herb.\nTo use in a macro: '/click MassMill'"
		frame:SetAttribute("macrotext", "/cast "..NAME.."\n/use item:"..table.concat({2447, 765, 2449, 785, 2450, 2452, 3820, 2453, 3369, 3355, 3356, 3357, 3818, 3821, 3358, 3819, 4625, 8831, 8836, 8838, 8845, 8839, 8846,
			13464, 13463, 13465, 13466, 13467, 22785, 22786, 22787, 22789, 22790, 22791, 22792, 22793, 36901, 36903, 36904, 36905, 36906, 36907, 37921, 39970}, "\n/use item:"))
	elseif inks:match(frame.id) then
		frame:SetAttribute("macrotext", Panda.CraftMacro(NAME2, frame.id))
	else
		frame:SetAttribute("macrotext", "/cast "..NAME.."\n/use item:"..frame.id)
	end
end))

