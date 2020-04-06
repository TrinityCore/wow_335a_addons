if not Skinner:isAddonEnabled("tekBlocks") then return end

function Skinner:tekBlocks()

	--	register for LDB callback when a new dataobject is created and tekBlocks is loaded
	LibStub("LibDataBroker-1.1").RegisterCallback(Skinner, "LibDataBroker_DataObjectCreated", "skinBlocks")
--	Skinner:Debug("Registered LDB callback for tekBlocks")

	self:skinBlocks("ftt")
	
end

local skinCnt
function Skinner:skinBlocks(...) -- event, name, dataobj

	local event = select(1, ...)
	local name = select(2, ...)
	local dataobj = select(3, ...)
	
--	self:Debug("tekBlocks:[%s, %s, %s]", event, name, dataobj)
	
	if event ~= "ftt"
	and dataobj
	and not dataobj.text
	then
		return -- no text, therefore no button
	end
	
	skinCnt = 0
	
	-- skin any existing data objects
	for _, child in pairs{UIParent:GetChildren()} do
		if child:IsObjectType("Button")
		and child.IconUpdate
		and not self.skinned[child]
		then
--			Skinner:Debug("skinBlocks, button found:[%s]", child)
			self:applySkin(child)
			skinCnt = skinCnt + 1
		end
	end
	
	-- if no new dataobjects found and not first time through then try again later
	if skinCnt == 0
	and event ~= "ftt"
	then
--		self:Debug("skinBlocks, schedule timer: [%s, %s, %s]", event, name, dataobj)
		self:ScheduleTimer("skinBlocks", 0.1, ...)
	end
	
end
