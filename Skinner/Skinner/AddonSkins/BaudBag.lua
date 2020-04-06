if not Skinner:isAddonEnabled("BaudBag") then return end

function Skinner:BaudBag()
	if not self.db.profile.ContainerFrames.skin then return end

	-- hook this to skin the bag frames
	self:SecureHook("BaudBagUpdateContainer", function(Container)
--		self:Debug("BBUC: [%s, %s]", Container, Container:GetName())
		local frame = Container:GetName()
		_G[frame.."BackdropTextures"]:Hide()
		if not self.skinned[Container] then
			self:skinButton{obj=_G[frame.."MenuButton"], mp=true, plus=true}
			self:skinAllButtons{obj=Container}
			self:addSkinFrame{obj=_G[frame.."Backdrop"], nb=true}
		end
	end)
	self:skinDropDown{obj=BaudBagContainerDropDown}
	self:addSkinFrame{obj=BBCont1_1BagsFrame}
	self:addSkinFrame{obj=BBCont2_1BagsFrame}

-->>-- Options Frame
	self:skinDropDown{obj=BaudBagOptionsSetDropDown}
	self:skinEditBox(BaudBagNameEditBox, {9})
	self:skinDropDown{obj=BaudBagOptionsBackgroundDropDown}
	self:addSkinFrame{obj=BaudBagOptionsFrame, kfs=true, hdr=true}

end
