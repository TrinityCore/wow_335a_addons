
function Skinner:Bongos()

	local Bongos = LibStub:GetLibrary('AceAddon-3.0',true):GetAddon('Bongos3', true)
	if Bongos and Bongos.Menu then
		self:SecureHook(Bongos.Menu, "Create", function(this, name)
			self:applySkin(_G["Bongos3BarMenu"..name])
			end)
	end

end


function Skinner:Bongos_AB()

	local Bongos = LibStub:GetLibrary('AceAddon-3.0', true):GetAddon('Bongos3', true)
	local Action = Bongos and Bongos:GetModule('ActionBar', true)

	if Action and Action.Painter then
		self:SecureHook(Action.Painter, "CreateHelp", function()
			self:applySkin(BongosABHelpDialog)
			self:Unhook(Action.Painter, "CreateHelp")
			end)
	end

	if Action and Action.Bar then
		self:SecureHook(Action.Bar, "CreateMenu", function()
		for i = 1, select("#", Action.Bar.menu:GetChildren()) do
			local child = select(i, Action.Bar.menu:GetChildren())
				for i = 1, select("#", child:GetChildren()) do
					local grandchild = select(i, child:GetChildren())
					if grandchild:IsObjectType("EditBox") then self:skinEditBox(grandchild, {9}) end
				end
				if self:isDropDown(child) then self:skinDropDown(child) end
			end
			self:Unhook(Action.Bar, "CreateMenu")
			end)
	end

end

function Skinner:Bongos_Options()

	local function skinBO(frame)

		-- check all Options children
		for i = 1, select("#", frame:GetChildren()) do
			local child = select(i, frame:GetChildren())
			-- check all the grandchildren as well
			for i = 1, select("#", child:GetChildren()) do
				local grandchild = select(i, child:GetChildren())
				if grandchild:GetObjectType() == "ScrollFrame" then
					Skinner:removeRegions(grandchild)
					Skinner:skinScrollBar(grandchild)
				elseif Skinner:isDropDown(grandchild) then Skinner:skinDropDown(grandchild)
				end
			end
			if child:GetObjectType() == "Frame" then Skinner:applySkin(child) end
		end

	end

	local Bongos = LibStub:GetLibrary('AceAddon-3.0', true):GetAddon('Bongos3', true)
	if Bongos then skinBO(Bongos.Options) end
	local Action = Bongos and Bongos:GetModule('ActionBar', true)
	if Action then skinBO(Action.Options) end

end
