
local L = Panda.locale


local WEAPONS = [[
	38780 38794 38821 38848 38870 38917 38772 38796 38822 38845 38869
  38880 38947 38995 38879 38920 44453 44466 38896 38922 38919 38992 44463
  38883 38963 38884 38918 38788 38874 38781 38875
  38878 38877 38946 38921 38991 44467 45060 45056
  38876 38838 38868 38872 38873 38871 38925 38927 38926 38924 38923
  44493 38965 38998 43987 38972 46098 44497 46026 38779 38813 38814 38840 38988 38981
]]
local SPELLID = 7411
local AVELLUM1, AVELLUM2, AVELLUM3 = 38682, 37602, 43145
local WVELLUM1, WVELLUM2, WVELLUM3 = 29249, 39350, 43146
local NAME = GetSpellInfo(SPELLID)
local function NoSpelltips(id, f) f.tiplink = nil end
local function MakeMacro(frame)
	local id, extra = frame.id, frame.extra

	if extra then
		return "/run if IsShiftKeyDown() then ChatEdit_InsertLink(select(2, GetItemInfo("..id.."))) end\n"..
			"/stopmacro [mod:shift]\n/run CloseTradeSkill()\n/cast "..NAME.."\n"..
			"/run for i=1,GetNumTradeSkills() do local l = GetTradeSkillRecipeLink(i) if l and l:match('enchant:"..extra.."') then "..
				"TradeSkillFrame_SetSelection(i); DoTradeSkill(i) end end CloseTradeSkill()\n"..
			"/use item:"..(WEAPONS:match(id) and WVELLUM3 or AVELLUM3)
	end

	return "/run if IsShiftKeyDown() then ChatEdit_InsertLink(select(2, GetItemInfo("..id.."))) end\n"..
		"/stopmacro [mod:shift]\n/run CloseTradeSkill()\n/cast "..NAME.."\n"..
		"/run local chantname = GetItemInfo("..id.."):match(\""..L["Scroll of (.+)$"].."\") for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == chantname then TradeSkillFrame_SetSelection(i); DoTradeSkill(i) end end CloseTradeSkill()\n"..
		"/use item:"..(WEAPONS:match(id) and WVELLUM3 or AVELLUM3)
end


Panda.panel:RegisterFrame(L["All Wrath"], Panda.PanelFactory(SPELLID,
[[38976:AGI       38943:SPE  39006:SPE 44449:AP    44469:AP    38966:STA    38961:SPI  38974:HMP      38986:HIT 0 0 0 0 0 0 38954:DEF 44455:INT
  38984:44598:EXP 38987:STAT 38902:STA 38971:AP    44815:AP    38968:INT    38997:SP   44470:60767:SP 38980:SPI
  38955:HP        39005:HP   39002:DEF 38912:MP    38962:MPR   38989:STAT   44465:STAT 38975:RES
  38959:AGI       44457:AGI  39001:ARM 44456:HASTE 39003:HASTE 38973:SPEN   39004:FADE 38993:STL      38978:DEF      0              0               0       38969:RFI   38977:RSH   38982:RAR 38956:RNA 38950:RFR
  38967:AGI       38964:AP   44458:AP  38953:HIT   38951:EXP   38990:THREAT 38979:SP        0         50816:FISH   38960:GATHER     0               0         0           0         38992:AP  44463:AP  38981:UNDEAD
  38995:AGI       44453:AP   44466:AP  38963:SPI   38991:SP    44467:SP     44493:BERSERK 38965:FIERY 43987:UNHOLY 38972:CRUSADER 46098:LIFESTEAL 44497:HIT 46026:PARRY 38988:GIANT   0       45060:SP  45056:SP
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Boots"], Panda.PanelFactory(SPELLID,
[[38786:AGI 38807:AGI 38844:AGI 38863:AGI 37603:AGI 38976:AGI 0 38943:SPE   0       44449:AP  44469:AP
  38785:STA 38810:STA 38830:STA 38862:STA 38909:STA 38966:STA 0 38944:SPE 39006:SPE
  38819:SPI 38864:SPI 38961:SPI   0       38908:HMP 38974:HMP 0 38837:SPE   0       45628:HIT 38910:HIT 38986:HIT
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Bracer"], Panda.PanelFactory(SPELLID,
[[38768:DEF 38811:DEF 38842:DEF 38899:DEF   0       38984:44598:EXP   0             38898:STAT 38987:STAT
  38771:STA 38793:STA 38812:STA 38849:STA 38855:STA 38902:STA       44947:62256:STA   0        38679:HP
  38778:STR 38797:STR 38817:STR 38846:STR 38854:STR 38897:STR         0             38938:AP   38971:AP 44815:AP   0            38777:AGI
  38803:INT 38829:INT 38852:INT 38937:INT 38968:INT   0             38882:SP        38900:SP   38903:SP 38997:SP 44470:60767:SP
  38774:SPI 38783:SPI 38809:SPI 38832:SPI 38853:SPI 38980:SPI         0             38881:MPR  38901:MPR
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Chest"], Panda.PanelFactory(SPELLID,
[[38766:HP   38773:HP   38782:HP   38808:HP   38833:HP   38866:HP   38911:HP 38955:HP  39005:HP 0 38767:DEF 38798:DEF 38999:DEF 39002:DEF
  38769:MP   38776:MP   38799:MP   38818:MP   38841:MP   38867:MP   38912:MP   0         0      0 38929:MPR 38962:MPR   0       38928:SPI
	38804:STAT 38824:STAT 38847:STAT 38865:STAT 38913:STAT 38989:STAT 44465:STAT 0         0      0 38930:RES 38975:RES
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Cloak"], Panda.PanelFactory(SPELLID,
[[38789:AGI   38835:AGI   38940:AGI  38959:AGI  44457:AGI   0         0       0 0 0 0 0 0 38770:RALL 38826:RALL 38858:RALL 38915:RALL
  38775:ARM   38790:ARM   38806:ARM  38825:ARM  38859:ARM 38914:ARM 39001:ARM 0 0 0 0 0 0 38784:RFI  38815:RFI  38891:RFI  38969:RFI
    0           0           0          0          0         0         0       0 0 0 0 0 0   0        38795:RSH  38942:RSH  38977:RSH
    0           0         38939:SPEN 38894:FADE 38893:STL 39000:DEF 38895:DOD 0 0 0 0 0 0   0          0        38941:RAR  38982:RAR
  44456:HASTE 39003:HASTE 38973:SPEN 39004:FADE 38993:STL 38978:DEF   0       0 0 0 0 0 0   0          0        38892:RNA  38956:RNA
    0           0           0          0          0         0         0       0 0 0 0 0 0   0          0          0        38950:RFR
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Gloves"], Panda.PanelFactory(SPELLID,
[[38850:MOUNT 0       38802:FISH 50816:FISH 38823:SKIN 38801:HERB 38834:HERB 38800:MINE 38831:MINE 38960:GATHER
  38827:AGI 38856:AGI 38890:AGI  38967:AGI    0        38836:STR  38857:STR  38933:STR    0          38934:AP  38964:AP     44458:AP
  38932:HIT 38953:HIT    0       38931:CRIT   0        38951:EXP    0        38851:HASTE    0       38885:THREAT 38990:THREAT
  38888:FIP 38887:FRP 38886:SHP    0        38889:SP   38936:SP   38935:SP   38979:SP
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Shield"], Panda.PanelFactory(SPELLID,
[[38787:STA 38805:STA 38828:STA 38861:STA 38945:STA    0          0   38949:RES
  38791:ARM   0       38904:BLKV  0       38820:BLKR 38906:BLKR   0   38954:DEF
  38792:SPI 38816:SPI 38839:SPI 38860:SPI   0        38905:INT  44455:INT
  38843:RFR   0       38907:RALL
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Weapon"], Panda.PanelFactory(SPELLID,
[[38780:DAM 38794:DAM 38821:DAM 38848:DAM 38870:DAM 38917:DAM 0   0        0      0 0   0       38772:DAM 38796:DAM 38822:DAM 38845:DAM 38869:DAM
  38880:AGI 38947:AGI 38995:AGI   0       38879:STR 38920:STR 0 44453:AP 44466:AP 0 0 38896:AGI 38922:AGI   0       38919:AP  38992:AP 44463:AP
  38883:SPI 38963:SPI   0       38884:INT 38918:INT   0       0   0        0      0 0   0       38788:SPI 38874:SPI   0       38781:INT 38875:INT
  38878:SP  38877:SP  38946:SP  38921:SP  38991:SP  44467:SP  0   0        0      0 0   0         0         0         0       45060:SP  45056:SP
  38876:WINTER  38838:FIERY 38868:FROST 38872:UNHOLY 38873:CRUSADER 38871:LIFESTEAL   0       38925:MONGOOSE 38927:LIFESTEAL 38926:MPR 38924:SOULFROST 38923:SUNFIRE
  44493:BERSERK 38965:FIERY 38998:FROST 43987:UNHOLY 38972:CRUSADER 46098:LIFESTEAL 44497:HIT 46026:PARRY      0               0       38779:BEAST     38813:BEAST 38814:ELEM 38840:DEMON 38988:GIANT 0 38981:UNDEAD
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))
