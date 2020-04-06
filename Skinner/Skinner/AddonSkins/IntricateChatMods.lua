if not Skinner:isAddonEnabled("IntricateChatMods") then return end
-- thanks to ichik

function Skinner:IntricateChatMods()

	local function skinBCMCopyFrame()

		self:skinScrollBar{obj=BCMCopyScroll}
		self:addSkinFrame{obj=BCMCopyFrame}

		for i = 1, NUM_CHAT_WINDOWS do
			self:Unhook(_G["BCMButtonCF"..i], "OnClick")
		end
	end

	for i = 1, NUM_CHAT_WINDOWS do
		self:SecureHookScript(_G["BCMButtonCF"..i], "OnClick", function(this)
			skinBCMCopyFrame()
		end)
	end

end
