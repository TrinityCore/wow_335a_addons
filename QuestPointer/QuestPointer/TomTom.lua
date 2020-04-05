local myname, ns = ...
local myfullname = GetAddOnMetadata(myname, "Title")

local f
function ns:AutoTomTom()
	if not (TomTom and TomTom.AddZWaypoint and TomTom.RemoveWaypoint) then
		return
	end
	if not self.db.autoTomTom then
		return f and f:Hide()
	end
	if not f then
		local tomtompoint
		local t = 0
		f = CreateFrame("Frame")
		f:SetScript("OnUpdate", function(self, elapsed)
			t = t + elapsed
			if t > 3 then -- this doesn't change very often at all; maybe more than 3 seconds?
				t = 0
				if tomtompoint then
					tomtompoint = TomTom:RemoveWaypoint(tomtompoint)
				end
				local closest = ns:ClosestPOI()
				if closest then
					tomtompoint = TomTom:AddZWaypoint(closest.c, closest.z, closest.x * 100, closest.y * 100, closest.title, false, false, false, false, false, true)
				end
			end
		end)
	end
	f:Show()
end
