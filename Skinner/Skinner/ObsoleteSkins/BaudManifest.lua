
function Skinner:BaudManifest()

	local function skinDisplay(dispNo)

		local dName = _G["BaudManifestDisplay"..dispNo]
		local dNameSDD = _G["BaudManifestDisplay"..dispNo.."SortDropDown"]
		local dNameFDD = _G["BaudManifestDisplay"..dispNo.."FilterDropDown"]
		local dNameFEB = _G["BaudManifestDisplay"..dispNo.."FilterEditBox"]
		local dNameFEBT = _G["BaudManifestDisplay"..dispNo.."FilterEditBoxText"]
		Skinner:skinDropDown(dNameSDD)
		Skinner:skinDropDown(dNameFDD)
		Skinner:skinEditBox(dNameFEB, {9})
		Skinner:moveObject(dNameFEBT, "-", 30, "+", 0, dNameFEB)
		Skinner:keepFontStrings(dName)
		Skinner:applySkin(dName)

	end


-->>--	Bags
	skinDisplay(1)
	self:applySkin(BaudManifestDisplay1BagsFrame)
-->>--	Bank
	skinDisplay(2)
	self:applySkin(BaudManifestDisplay2BagsFrame)
-->>--	Characters
	skinDisplay(3)
	skinDisplay(4)
	self:applySkin(BaudManifestCharactersScrollBox)
	self:applySkin(BaudManifestCharacters, true)

-->>--	Options Frame
	self:keepFontStrings(BaudManifestOptions)
	self:skinDropDown(BaudManifestQualityDropDown0)
	self:skinDropDown(BaudManifestQualityDropDown1)
	self:skinDropDown(BaudManifestQualityDropDown2)
	self:skinDropDown(BaudManifestAutoSellDropDown)
	self:moveObject(BaudManifestVersionText, nil, nil, "-", 8)
	self:applySkin(BaudManifestOptions, true)

	BaudManifestUpdateBGTexture = function() end

end
