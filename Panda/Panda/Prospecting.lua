
local panel = Panda.panel:NewPanel(true)
local NAME = GetSpellInfo(31252)
panel:RegisterFrame(NAME, Panda.PanelFactory(25229,[[
 2770   818   774  1210   0     0     0     0     0     0   23077 21929 23112 23079 23117 23107 23424
 2771  1206  1705  1210   0    7909  3864  1529   0     0   23436 23439 23440 23437 23438 23441 23425
 2772  1529  1705  3864   0    7909  7910   0     0     0   36917 36929 36920 36932 36923 36926 36909
 3858  7910  7909  3864   0   12799 12361 12800 12364   0   36918 36930 36921 36933 36924 36927 36912
10620  7910 12799 12800 12364 12361   0     0     0     0   36919 36931 36922 36934 36925 36928 36910
  0   23077 21929 23112 23079 23117 23107

]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", "/cast "..NAME.."\n/use item:"..frame.id)
end))
