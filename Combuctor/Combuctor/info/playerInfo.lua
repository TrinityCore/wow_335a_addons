--[[
	player.lua
		Generic methods for accessing player information
--]]


--[[ Player Info ]]--

local Combuctor = LibStub('AceAddon-3.0'):GetAddon('Combuctor')
local PlayerInfo = {}
Combuctor.PlayerInfo = PlayerInfo

local CURRENT_PLAYER = UnitName('player')

function PlayerInfo:IsCached(player)
	return player ~= CURRENT_PLAYER
end

function PlayerInfo:GetMoney(player)
	local money = 0
	if self:IsCached(player) then
		if BagnonDB then
			money = BagnonDB:GetMoney(player)
		end
	else
		money = GetMoney()
	end
	return money
end

function PlayerInfo:AtBank()
	return Combuctor.BagEvents:AtBank()
end