--[[
	Tests for the combuctor set api thingy
--]]

local CombuctorSet = Combuctor:GetModule('Sets')

local function printSets()
	for i, set in CombuctorSet:GetParentSets() do
		ChatFrame1:AddMessage(format('set %d: %s', i, set.name))
		for j, subset in CombuctorSet:GetChildSets(set.name) do
			ChatFrame1:AddMessage(format('subset %d: %s', j, subset.name))
		end
	end
end

--set tests
ChatFrame1:AddMessage('register set tests..')
CombuctorSet:Register('bacon') --should work
CombuctorSet:Register('bacon') --should perform an update

for i = 1, 10 do
	CombuctorSet:Register('testSet' .. i)
end

--subset test
ChatFrame1:AddMessage('register subset tests..')
CombuctorSet:RegisterSubSet('cheese', 'bacon') --should also work
CombuctorSet:RegisterSubSet('cheese', 'bacon') --should perform an update

CombuctorSet:RegisterSubSet('delicious', 'bacon') --should also work
--	CombuctorSet:RegisterSubSet('bacon', 'cheese') --cannot have cheese without bacon

--set and subset iterator tests
ChatFrame1:AddMessage('set iterator test...')
printSets()

--unregister set test
ChatFrame1:AddMessage('set removal test...')
for i = 1, 10 do
	CombuctorSet:Unregister('testSet' .. i)
end
printSets()

--unregister subset test
ChatFrame1:AddMessage('subset removal test...')
CombuctorSet:Unregister('delicious', 'bacon')
printSets()

--unregister set with subsets test
ChatFrame1:AddMessage('set with subsets removal test...')
CombuctorSet:Unregister('bacon')
printSets()

ChatFrame1:AddMessage('tests complete')