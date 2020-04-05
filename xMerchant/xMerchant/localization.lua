--[[
	
	xMerchant
	Copyright (c) 2010, Nils Ruesch
	All rights reserved.
	
]]

local xm = select(2, ...);
local getlocale	= GetLocale();
local locale = {
	deDE = {
		["To browse item tooltips, too"] = "Gegenstandstooltip auch durchsuchen",
		["Requires Level (%d+)"] = "Benötigt Stufe (%d+)",
		["Level %d"] = "Stufe %d",
		["Requires .+ %- (.+)"] = "Benötigt .+ %- (.+)",
		["Requires (.+) %((%d+)%)"] = "Benötigt (.+) %((%d+)%)",
		["Requires (.+)"] = "Benötigt (.+)",
	},
	
	frFR = {
		["To browse item tooltips, too"] = "Chercher aussi dans les bulles d'aide", -- << Thanks to Tchao at WoWInterface
		["Requires Level (%d+)"] = "Niveau (%d+) requis",
		["Level %d"] = "Niveau %d",
		["Requires .+ %- (.+)"] = "Requiert .+ %- (.+)",
		["Requires (.+) %((%d+)%)"] = "(.+) %((%d+)%) requis",
		["Requires (.+)"] = "Requiert (.+)",
	},
	
	esES = {
		--["To browse item tooltips, too"] = "",					-- Need update!
		["Requires Level (%d+)"] = "Necesitas ser de nivel (%d+)",	-- Works?
		["Level %d"] = "Nivel %d",									-- Works?
		["Requires .+ %- (.+)"] = "Requiere .+: (.+)",				-- Works?
		["Requires (.+) %((%d+)%)"] = "Requiere (.+) %((%d+)%)",	-- Works?
		["Requires (.+)"] = "Requiere (.+)",						-- Works?
	},
	
	esMX = {
		--["To browse item tooltips, too"] = "",					-- Need update!
		["Requires Level (%d+)"] = "Necesitas ser de nivel (%d+)",	-- Works?
		["Level %d"] = "Nivel %d",									-- Works?
		["Requires .+ %- (.+)"] = "Requiere .+: (.+)",				-- Works?
		["Requires (.+) %((%d+)%)"] = "Requiere (.+) %((%d+)%)",	-- Works?
		["Requires (.+)"] = "Requiere (.+)",						-- Works?
	},
	
	ruRU = {
		--["To browse item tooltips, too"] = "",					-- Need update!
		["Requires Level (%d+)"] = "Требуется уровень: (%d+)",		-- Works?
		["Level %d"] = "Уровень %d",								-- Works?
		--["Requires .+ %- (.+)"] = "ITEM_REQ_REPUTATION: Требуется: %2$s со стороны |3-7(%1$s)", -- |3-7??
		["Requires (.+) %((%d+)%)"] = "Требуется: (.+) %((%d+)%)",	-- Works?
		["Requires (.+)"] = "Требуется (.+)",						-- Works?
	},
	
	zhCN = {
		--["To browse item tooltips, too"] = "",					-- Need update!
		["Requires Level (%d+)"] = "需要等级 (%d+)",					-- Works?
		["Level %d"] = "等级 %d",									-- Works?
		["Requires .+ %- (.+)"] = "需要 .+ %- (.+)",				-- Works?
		["Requires (.+) %((%d+)%)"] = "需要(.+)%((%d+)%)",			-- Works?
		["Requires (.+)"] = "需要(.+)",								-- Works?
	},
	
	zhTW = {
		--["To browse item tooltips, too"] = "",					-- Need update!
		["Requires Level (%d+)"] = "需要等级 (%d+)",					-- Works?
		["Level %d"] = "等级 %d",									-- Works?
		["Requires .+ %- (.+)"] = "需要 .+ %- (.+)",				-- Works?
		["Requires (.+) %((%d+)%)"] = "需要(.+)%((%d+)%)",			-- Works?
		["Requires (.+)"] = "需要(.+)",								-- Works?
	},
};

local L = setmetatable(locale[getlocale] or {}, {
	__index = function(t, i)
		return i;
	end
});
xm.L = L;
