-- This is a Library

function Skinner:Tablet()
	if not self.db.profile.Tooltips.skin then return end

	local frame
	
	local function skinTablet()

		if Tablet20Frame then
			frame = Tablet20Frame
			if not Skinner.skinned[frame] then
				Skinner:applySkin(frame)
				-- change these to stop the Backdrop colours from being changed
				frame.SetBackdropColor = function() end
				frame.SetBackdropBorderColor = function() end
			end
		end

		local i = 1
		while _G["Tablet20DetachedFrame"..i] do
			frame = _G["Tablet20DetachedFrame"..i]
			if not Skinner.skinned[frame] then
				Skinner:applySkin(frame)
				-- change these to stop the Backdrop colours from being changed
				frame.SetBackdropColor = function() end
				frame.SetBackdropBorderColor = function() end
			end
			i = i + 1
		end

	end

	self:SecureHook(LibStub("Tablet-2.0", true), "Open", function(tablet, parent)
		skinTablet()
	end)
	self:SecureHook(LibStub("Tablet-2.0", true), "Detach", function(tablet, parent)
		skinTablet()
	end)

	skinTablet()

end
