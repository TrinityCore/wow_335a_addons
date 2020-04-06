local AceOO = AceLibrary("AceOO-2.0")
local PlayerInfo = AceOO.Class(IceTargetInfo)

local EPSILON = 0.5

PlayerInfo.prototype.mainHandEnchantTimeSet = 0
PlayerInfo.prototype.mainHandEnchantEndTime = 0
PlayerInfo.prototype.offHandEnchantTimeSet = 0
PlayerInfo.prototype.offHandEnchantEndTime = 0

-- Constructor --
function PlayerInfo.prototype:init()
	PlayerInfo.super.prototype.init(self, "PlayerInfo", "player")
end

function PlayerInfo.prototype:GetDefaultSettings()
	local settings = PlayerInfo.super.prototype.GetDefaultSettings(self)

	settings["enabled"] = false
	settings["vpos"] = -100
	settings["hideBlizz"] = false

	return settings
end

function PlayerInfo.prototype:GetOptions()
	local opts = PlayerInfo.super.prototype.GetOptions(self)

	opts["hideBlizz"] = {
		type = "toggle",
		name = "Hide Blizzard Buff Frame",
		desc = "Hides Blizzard buffs frame and disables all events related to it",
		get = function()
			return self.moduleSettings.hideBlizz
		end,
		set = function(value)
			self.moduleSettings.hideBlizz = value
			if (value) then
				self:HideBlizz()
			else
				self:ShowBlizz()
			end
		end,
		disabled = function()
			return not self.moduleSettings.enabled
		end,
		order = 41
	}

	return opts
end

function PlayerInfo.prototype:CreateFrame(redraw)
	PlayerInfo.super.prototype.CreateFrame(self, redraw)

	self.frame.menu = function()
		ToggleDropDownMenu(1, nil, PlayerFrameDropDown, "cursor")
	end
end

function PlayerInfo.prototype:CreateIconFrames(parent, direction, buffs, type)
	local buffs = PlayerInfo.super.prototype.CreateIconFrames(self, parent, direction, buffs, type)

	for i = 1, IceCore.BuffLimit do
		if (self.moduleSettings.mouseBuff) then
			buffs[i]:SetScript("OnMouseUp", function( self, button)
				if( button == "RightButton" ) then
					if buffs[i].type == "mh" then
						CancelItemTempEnchantment(1)
					elseif buffs[i].type == "oh" then
						CancelItemTempEnchantment(2)
					else
						CancelUnitBuff("player", i)
					end
				end
			end)
		else
			buffs[i]:SetScript("OnMouseUp", nil)
		end
	end

	return buffs
end

function PlayerInfo.prototype:Enable(core)
	PlayerInfo.super.prototype.Enable(self, core)

	if (self.moduleSettings.hideBlizz) then
		self:HideBlizz()
	end

	self:ScheduleRepeatingEvent(self.elementName, self.UpdateBuffs, 1, self, self.unit, true)
end

function PlayerInfo.prototype:ShowBlizz()
	BuffFrame:Show()
	TemporaryEnchantFrame:Show()

	BuffFrame:RegisterEvent("UNIT_AURA");
end


function PlayerInfo.prototype:HideBlizz()
	BuffFrame:Hide()
	TemporaryEnchantFrame:Hide()

	BuffFrame:UnregisterAllEvents()
end

function PlayerInfo.prototype:UpdateBuffs(unit, fromRepeated)
	if unit and unit ~= self.unit then
		return
	end

	if not fromRepeated then
		PlayerInfo.super.prototype.UpdateBuffs(self)
	end

	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges
		= GetWeaponEnchantInfo()

	local startingNum = 0

	for i=1, IceCore.BuffLimit do
		if not self.frame.buffFrame.buffs[i]:IsVisible()
			or self.frame.buffFrame.buffs[i].type == "mh"
			or self.frame.buffFrame.buffs[i].type == "oh" then
			if startingNum == 0 then
				startingNum = i
			end
		end

		if self.frame.buffFrame.buffs[i]:IsVisible() then
			if (self.frame.buffFrame.buffs[i].type == "mh" and not hasMainHandEnchant)
				or (self.frame.buffFrame.buffs[i].type == "oh" and not hasOffHandEnchant) then
				self.frame.buffFrame.buffs[i]:Hide()
			end
		end
	end

	if hasMainHandEnchant or hasOffHandEnchant then
		local CurrTime = GetTime()

		if hasMainHandEnchant then
			if self.mainHandEnchantEndTime == 0 or
				abs(self.mainHandEnchantEndTime - (mainHandExpiration/1000)) > CurrTime - self.mainHandEnchantTimeSet + EPSILON then
				self.mainHandEnchantEndTime = mainHandExpiration/1000
				self.mainHandEnchantTimeSet = CurrTime
			end

			if not self.frame.buffFrame.buffs[startingNum]:IsVisible() or self.frame.buffFrame.buffs[startingNum].type ~= "mh" then
				self:SetUpBuff(startingNum,
					GetInventoryItemTexture(self.unit, GetInventorySlotInfo("MainHandSlot")),
					self.mainHandEnchantEndTime,
					CurrTime + (mainHandExpiration/1000),
					true,
					mainHandCharges,
					"mh")
			end

			startingNum = startingNum + 1
		end

		if hasOffHandEnchant then
			if self.offHandEnchantEndTime == 0 or
				abs(self.offHandEnchantEndTime - (offHandExpiration/1000)) > abs(CurrTime - self.offHandEnchantTimeSet) + EPSILON then
				self.offHandEnchantEndTime = offHandExpiration/1000
				self.offHandEnchantTimeSet = CurrTime
			end

			if not self.frame.buffFrame.buffs[startingNum]:IsVisible() or self.frame.buffFrame.buffs[startingNum].type ~= "oh" then
				self:SetUpBuff(startingNum,
					GetInventoryItemTexture(self.unit, GetInventorySlotInfo("SecondaryHandSlot")),
					self.offHandEnchantEndTime,
					CurrTime + (offHandExpiration/1000),
					true,
					offHandCharges,
					"oh")
			end

			startingNum = startingNum + 1
		end
		
		for i=startingNum, IceCore.BuffLimit do
			if self.frame.buffFrame.buffs[i]:IsVisible() then
				self.frame.buffFrame.buffs[i]:Hide()
			end
		end

		local direction = self.moduleSettings.buffGrowDirection == "Left" and -1 or 1
		self.frame.buffFrame.buffs = self:CreateIconFrames(self.frame.buffFrame, direction, self.frame.buffFrame.buffs, "buff")
	end
end

-- Load us up
IceHUD.PlayerInfo = PlayerInfo:new()
