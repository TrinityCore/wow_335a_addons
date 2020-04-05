local _G = _G
local PitBull4 = _G.PitBull4

local DEBUG = PitBull4.DEBUG
local expect = PitBull4.expect

-- Constants -----------------------------------------------------------------
-- how long in seconds it would take to go from 100% to 0% opacity (or the other way around)
local FADE_TIME = 0.5

-- how many opacity points can change in one second
local OPACITY_POINTS_PER_SECOND = 1 / FADE_TIME
------------------------------------------------------------------------------

local FaderModule = PitBull4:NewModuleType("fader", {
	enabled = true,
})

-- a dictionary of module to a dictionary of frame to final opacity level
local module_to_frame_to_opacity = {}
local module_to_frame_to_priority = {}

-- a set of frames that should be checked for opacity changes
local changing_frames = {}

--- Return how opaque a frame will be once animation completes.
-- @param frame the Unit Frame to check.
-- @usage local opacity = PitBull4:GetFinalFrameOpacity(frame)
-- @return a number within [0, 1]
function PitBull4:GetFinalFrameOpacity(frame)
	if DEBUG then
		expect(frame, 'typeof', 'frame')
	end
	
	local layout_db = frame.layout_db
	local unit = frame.unit
	
	local low = layout_db.opacity_max
	local max_priority
	for module, frame_to_opacity in pairs(module_to_frame_to_opacity) do
		local frame_to_priority = module_to_frame_to_priority[module]
		local priority = frame_to_priority[frame]
		local opacity = frame_to_opacity[frame]
		if priority and (not max_priority or priority > max_priority) then
			low = layout_db.opacity_max
			max_priority = priority
		end
		if opacity and opacity < low and (not priority or not max_priority or priority >= max_priority) then 
			low = opacity
		end
	end
	return low
end

local timerFrame = CreateFrame("Frame")
timerFrame:SetScript("OnUpdate", function(self, elapsed)
	local opacity_delta = elapsed * OPACITY_POINTS_PER_SECOND
	for frame in pairs(changing_frames) do
		if not frame:IsVisible() then
			changing_frames[frame] = nil
		else
			local final_opacity = PitBull4:GetFinalFrameOpacity(frame)
			local current_opacity = frame:GetAlpha()
		
			if final_opacity ~= current_opacity then
				local result_opacity
				if not frame.layout_db.opacity_smooth then
					result_opacity = final_opacity
				elseif final_opacity < current_opacity then
					result_opacity = current_opacity - opacity_delta
					if result_opacity < final_opacity then
						result_opacity = final_opacity
					end
				else
					result_opacity = current_opacity + opacity_delta
					if result_opacity > final_opacity then
						result_opacity = final_opacity
					end
				end
			
				frame:SetAlpha(result_opacity)
				if result_opacity == final_opacity then
					changing_frames[frame] = nil
				end
			else
				changing_frames[frame] = nil
			end
		end
	end
	if not next(changing_frames) then
		timerFrame:Hide()
	end
end)
timerFrame:Hide()

function PitBull4:RecheckAllOpacities()
	timerFrame:Show()
	for frame in PitBull4:IterateFrames() do
		changing_frames[frame] = true
	end
end

--- Handle the frame being hidden
-- @param frame the Unit Frame hidden.
-- @usage MyModule:OnHide(frame)
function FaderModule:OnHide(frame)
	if DEBUG then
		expect(frame, 'typeof', 'frame')
	end

	-- No point in removing the opacity change, it'll be set anyway
	-- when the frame is shown.
	return
end

--- Remove any opacity value for this module.
-- @param frame the Unit Frame to clear
-- @usage MyModule:ClearFrame(frame)
-- @return false, since :UpdateLayout isn't required for this type of module
function FaderModule:ClearFrame(frame)
	if DEBUG then
		expect(frame, 'typeof', 'frame')
	end
	
	local frame_to_opacity = module_to_frame_to_opacity[self]
	local frame_to_priority = module_to_frame_to_priority[self]
	if not frame_to_opacity and not frame_to_priority then
		return false
	end
	
	local update = false

	if frame_to_opacity[frame] then
		frame_to_opacity[frame] = nil
		update = true
	end

	if frame_to_priority[frame] then
		frame_to_priority[frame] = nil
		update = true
	end

	if update then
		changing_frames[frame] = true
		timerFrame:Show()
	end
	
	return false
end

--- Call the :GetOpacity function on the fader module regarding the given frame.
-- The lowest opacity from the highest priority module will be used on the frame.
-- @param the module
-- @param frame the frame to get the opacity of
-- @usage local opacity, priority = call_opacity_function(MyModule, someFrame)
-- @return opacity nil or a number within [0, 1]
-- @return priority nil (treated as zero) or a number
local function call_opacity_function(self, frame)
	if not self.GetOpacity then
		return nil, nil
	end
	
	local layout_db = frame.layout_db
	
	local opacity_min = layout_db.opacity_min
	local opacity_max = layout_db.opacity_max
	
	local value, priority
	-- Extra frame.unit test here is a workaround for the same root issue
	-- as we have in BarModules.  See ticket 475.
	if frame.guid and frame.unit then
		value, priority = self:GetOpacity(frame)
	end
	if not value or value >= opacity_max or value ~= value then
		return opacity_max, priority
	elseif value < opacity_min then
		return opacity_min, priority
	else
		return value, priority
	end
end

--- Update the opacity value for the current module
-- @param frame the Unit Frame to update
-- @usage MyModule:UpdateStatusBar(frame)
-- @return false, since :UpdateLayout isn't required for this type of module
function FaderModule:UpdateFrame(frame)
	if DEBUG then
		expect(frame, 'typeof', 'frame')
	end
	
	local frame_to_opacity = module_to_frame_to_opacity[self]
	if not frame_to_opacity then
		frame_to_opacity = {}
		module_to_frame_to_opacity[self] = frame_to_opacity
	end
	local frame_to_priority = module_to_frame_to_priority[self]
	if not frame_to_priority then
		frame_to_priority = {}
		module_to_frame_to_priority[self] = frame_to_priority
	end
	
	local opacity, priority = call_opacity_function(self, frame)
	if not opacity then
		return self:ClearFrame(frame)
	end
	if not priority then
		priority = 0
	end
	
	if frame_to_opacity[frame] ~= opacity or frame_to_priority[frame] ~= priority then
		frame_to_opacity[frame] = opacity
		frame_to_priority[frame] = priority
		changing_frames[frame] = true
		timerFrame:Show()
	end
	
	return false
end
