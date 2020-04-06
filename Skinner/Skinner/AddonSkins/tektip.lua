-- This is a Library

function Skinner:tektip()

	local lib = LibStub("tektip-1.0")
	
	local function skinTT(ttip)
	
		if Skinner.db.profile.Tooltips.skin then
			if Skinner.db.profile.Tooltips.style == 3 then ttip:SetBackdrop(Skinner.Backdrop[1]) end
			Skinner:SecureHookScript(ttip, "OnShow", function(this)
				Skinner:skinTooltip(this)
			end)
		end
		
	end

	-- hook this to skin new tooltips
	self:RawHook(lib, "new", function(...)
		local ttip = self.hooks[lib].new(...)
		skinTT(ttip)
		return ttip
	end, true)
	
	-- skin existing tooltips
	for _, child in pairs{UIParent:GetChildren()} do
		if child:GetFrameStrata() == "TOOLTIP"
		and child.AddLine
		and child.Clear
		then
			skinTT(child)
		end
	end

end
