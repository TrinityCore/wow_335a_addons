
function Skinner:SanityBags()
	if not self.db.profile.ContainerFrames.skin then return end

	local function skinSanityBags()

		for _, v in pairs(SanityBags.bags) do
			if not v.frame.skinned then
				Skinner:applySkin(v.frame)
				local sc = _G[v.frame:GetName().."SearchContainer"]
				Skinner:applySkin(sc)
				local fc = _G[v.frame:GetName().."FilterContainer"]
				Skinner:applySkin(fc)
				local sb = _G[v.frame:GetName().."StatusBar"]
				Skinner:glazeStatusBar(sb, 0)
				local sbt = _G[sb:GetName().."BagFullFrameTexture"]
				Skinner:RawHook(sbt, "SetTexture", function() end, true)
				local sbbgt = _G[sb:GetName().."BagFullFrameBGTexture"]
				Skinner:RawHook(sbbgt, "SetTexture", function() end, true)
				Skinner:skinScrollBar(StatusBar)
				Skinner:RawHook(v.frame, "SetBackdropColor", function() end, true)
				Skinner:RawHook(v.frame, "SetBackdropBorderColor", function() end, true)
				v.frame.skinned = true
			end
		end

	end

	self:SecureHook(SanityBags, "CreateBag", function(opts, bagType)
		skinSanityBags()
	end)

	skinSanityBags()

end
