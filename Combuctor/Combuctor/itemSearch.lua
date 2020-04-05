--[[
	ItemSearch
		An item text search engine of some sort

	Grammar:
		<search> 			:=	<intersect search>
		<intersect search> 	:=	<union search> & <union search> ; <union search>
		<union search>		:=	<negatable search>  | <negatable search> ; <negatable search>
		<negatable search> 	:=	!<primitive search> ; <primitive search>
		<primitive search>	:=	<tooltip search> ; <quality search> ; <type search> ; <text search>
		<tooltip search>	:=  bop ; boa ; bou ; boe ; quest
		<quality search>	:=	q:<text> ; q:<digit>
		<type search>		:=	t:<text>
		<text search>		:=	<text>
--]]


local ItemSearch = {}
Combuctor.ItemSearch = ItemSearch

function ItemSearch:Find(itemLink, search)
	if not search then
		return true
	end

	if not itemLink then
		return false
	end

	if search:match('\124') then
		return self:FindUnionSearch(itemLink, strsplit('\124', search))
	end
	return self:FindUnionSearch(itemLink, search)
end

function ItemSearch:FindUnionSearch(itemLink, ...)
	for i = 1, select('#', ...) do
		local search = select(i, ...)
		if search and search ~= '' then
			if search:match('\038') then
				if self:FindIntersectSearch(itemLink, strsplit('\038', search)) then
					return true
				end
			else
				if self:FindIntersectSearch(itemLink, search) then
					return true
				end
			end
		end
	end
	return false
end

function ItemSearch:FindIntersectSearch(itemLink, ...)
	for i = 1, select('#', ...) do
		local search = select(i, ...)
		if search and search ~= '' then 
			if not self:FindNegatableSearch(itemLink, search) then
				return false
			end
		end
	end
	return true
end

function ItemSearch:FindNegatableSearch(itemLink, search)
	local negatedSearch = search:match('^\033(.+)$')
	if negatedSearch then
		return not self:FindPrimitiveSearch(itemLink, negatedSearch)
	end
	return self:FindPrimitiveSearch(itemLink, search)
end

function ItemSearch:FindPrimitiveSearch(itemLink, search)
	if not search then
		return false
	end

	local tSearch = self:IsTooltipSearch(search)
	if tSearch then
		return self:FindTooltipSearch(itemLink, tSearch)
	end

	local qSearch = self:IsQualitySearch(search)
	if qSearch then
		return self:FindQualitySearch(itemLink, qSearch)
	end

	local tSearch = self:IsTypeSearch(search)
	if tSearch then
		return self:FindTypeSearch(itemLink, tSearch)
	end

	return self:FindTextSearch(itemLink, search)
end


--[[
	'Primitive' Searches
--]]

local function search_IsInText(search, ...)
	for i = 1, select('#', ...) do
		local text = select(i, ...)
		text = text and tostring(text):lower()
		if text and (text == search or text:match(search)) then
			return true
		end
	end
	return false
end


--tooltip
local tooltipSearches = {
	['boe'] = ITEM_BIND_ON_EQUIP,
	['bop'] = ITEM_BIND_ON_PICKUP,
	['bou'] = ITEM_BIND_ON_USE,
	['quest'] = ITEM_BIND_QUEST,
	['boa'] = ITEM_BIND_TO_ACCOUNT
}

local tooltipScanner = _G['CombuctoTooltipScanner'] or CreateFrame('GameTooltip', 'CombuctoTooltipScanner', UIParent, 'GameTooltipTemplate')

local function link_FindSearchInTooltip(itemLink, search)
	local result = false

	tooltipScanner:SetOwner(UIParent, 'ANCHOR_NONE')
	tooltipScanner:SetHyperlink(itemLink)

	if tooltipScanner:NumLines() > 1 and _G[tooltipScanner:GetName() .. 'TextLeft2']:GetText() == search then
		result = true
	elseif tooltipScanner:NumLines() > 2 and _G[tooltipScanner:GetName() .. 'TextLeft3']:GetText() == search then
		result = true
	end

	tooltipScanner:Hide()
	return result
end

function ItemSearch:FindTooltipSearch(itemLink, tSearch)
	return tSearch and link_FindSearchInTooltip(itemLink, tSearch)
end

function ItemSearch:IsTooltipSearch(search)
	return tooltipSearches[search]
end


--quality q:(.+)
function ItemSearch:FindQualitySearch(itemLink, qSearch)
	local name, link, quality = GetItemInfo(itemLink)
	if not name then
		return false
	end

	local qSearchNum = tonumber(qSearch)
	if qSearchNum then
		return qSearchNum == quality
	end

	local qualityDesc = _G['ITEM_QUALITY' .. quality .. '_DESC']
	if qualityDesc then
		return qSearch == qualityDesc:lower()
	end

	return false
end

function ItemSearch:IsQualitySearch(search)
	return search and search:match('^q:(.+)$')
end


--typeSearch t:(.+)
function ItemSearch:FindTypeSearch(itemLink, tSearch)
	local name, link, quality, iLevel, reqLevel, type, subType, maxStack, equipSlot = GetItemInfo(itemLink)
	if not name then
		return false
	end
	return search_IsInText(tSearch, type, subType, _G[equipSlot])
end

function ItemSearch:IsTypeSearch(search)
	return search and search:match('^t:(.+)$')
end


--basic text search
function ItemSearch:FindTextSearch(itemLink, search)
	return search_IsInText(search, (GetItemInfo(itemLink)))
end