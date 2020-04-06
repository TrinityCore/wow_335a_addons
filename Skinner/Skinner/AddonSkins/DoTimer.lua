if not Skinner:isAddonEnabled("DoTimer") then return end

function Skinner:DoTimer_Options()

	local function skinEBs(frame)
		
		for i = 1, frame:GetNumChildren() do
			local child = select(i, frame:GetChildren())
--			Skinner:Debug("skinEBs: [%s, %s]", child, noSkin)
			if child:IsObjectType("EditBox") then self:skinEditBox(child, {9}, nil, nil, true)
			elseif child:IsObjectType("Frame") then skinEBs(child) end
		end
		
	end
	
	local function findPanel(tab, lvl)
		
		if lvl == 4 then return end -- only go 4 levels deep
		
		for k, v in pairs(tab) do
--			Skinner:Debug("findPanel: [%s, %s]", k, v)
			if k == "panel" then skinEBs(v) break
			elseif type(v) == "table" then findPanel(v, lvl + 1) end
		end
		
	end
	
	self:SecureHook(GUILib, "GenerateItem", function(this, module, frame, item, extras)
--		self:Debug("GUILib_GenerateItem: [%s, %s, %s, %s]", module, frame, item, extras)
		if strsub(item.type, 1, 7) == "editBox" then skinEBs(frame) end
	end)
	
	-- skin already created panel objects
	findPanel(GUILib.panels, 1)

end
