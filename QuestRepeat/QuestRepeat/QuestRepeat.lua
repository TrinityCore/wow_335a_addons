function initialize()
	MAX_VALUE = 1;
	iterator = nil;
	questName = "";
end

function QuestRepeat_OnLoad()
	initialize();
	this:RegisterEvent("GOSSIP_CLOSED");
	this:RegisterEvent("GOSSIP_SHOW");
	this:RegisterEvent("QUEST_COMPLETE");
	this:RegisterEvent("QUEST_PROGRESS");

	DEFAULT_CHAT_FRAME:AddMessage("QuestRepeat Enabled");

end 

function QuestRepeat_OnEvent()
	if (event == "GOSSIP_CLOSED") then
		if (iterator) then
			if (iterator < 1) then
				initialize();
			end
		end
	elseif (event == "PLAYER_TARGET_CHANGED") then
		initialize();
		this:UnregisterEvent("PLAYER_TARGET_CHANGED")
	elseif (event == "QUEST_PROGRESS") then
		if (IsQuestCompletable() and iterator == nil) then
			n = GetNumQuestItems();
			i = 0;	
			if (n ~= nil) then	
				if (n ~= 0) then
					MAX_VALUE = 999;
					while i < n do
						i = i + 1;
						local name, texture, numItems, quality, isUsable = GetQuestItemInfo("required",i);
						value = floor(Item_Check(name)/numItems)
						if (value < MAX_VALUE) then
							MAX_VALUE = value;
						end
					end
				end
			end
			this:RegisterEvent("GOSSIP_CLOSED")
			this:RegisterEvent("PLAYER_TARGET_CHANGED")
		elseif(iterator) then
			if (iterator > 0) then
				QuestProgressCompleteButton_OnClick();		
			end
		end
	elseif (event == "QUEST_DETAIL") then
		if (iterator) then
			if (iterator > 0 ) then
				QuestDetailAcceptButton_OnClick();
			end
		end
	elseif (event == "QUEST_COMPLETE") then
		if (MAX_VALUE > 1) then
			QuestFrameCompleteQuestButton:Hide();
			QuestRepeat:Show();
			if(GetTitleText() == questName) then
				if(iterator) then
					if(iterator > 0)then
						QuestRepeatInputBox:SetNumber(iterator);
						QuestRepeatCompleteButton_OnClick();
					else 
						initialize();
					end
				end
			else
				QuestRepeatInputBox:SetNumber(1);
				questName = GetTitleText();
			end
		else
			initialize()
			QuestFrameCompleteQuestButton:Show()
			QuestRepeat:Hide()
		end
	elseif (event == "GOSSIP_SHOW") then
		if (iterator) then
			if (iterator > 0) then
				if GetGossipAvailableQuests() then
					i = 0;
					for index, value in pairs({GetGossipAvailableQuests()}) do
						if( mod(index,2) ~= 0) then
							i = i + 1;
							if (value == questName) then
								SelectGossipAvailableQuest(i);
								break;
							end
						end
					end
				end
				if GetGossipActiveQuests() then
					i = 0;
					for index, value in pairs({GetGossipActiveQuests()}) do
						if( mod(index,2) ~= 0) then
							i = i + 1;
							if (value == questName) then
								SelectGossipActiveQuest(i);
								break;
							end
						end
					end				
				end
			end
		end
	end
end

function Item_Check(name)
	Count = 0;
    for bag = 4, 0, -1 do
        local size = GetContainerNumSlots(bag);
        if (size > 0) then
            -- for each slot in the bag
            for slot = 1, size do
                local texture, itemCount = GetContainerItemInfo(bag, slot);
                if (itemCount) then
		    local itemLink = GetContainerItemLink(bag,slot)
		    local _, _, itemCode = strfind(itemLink, "(%d+):")
		    local itemName, _, _, _, _, _ = GetItemInfo(itemCode)
 		    -- if the item has a name
	 	    if (itemName ~= "" and itemName ~= nil) then
                        if (itemName == name) then
                            Count = Count + itemCount;
                        end
                    end
                end
            end
        end
    end
    return Count;
end

function QuestRepeatAllButton_OnClick()
	QuestRepeatInputBox:SetNumber(MAX_VALUE);
	QuestRepeatCompleteButton_OnClick();
end

function QuestRepeatCompleteButton_OnClick()
	this:RegisterEvent("PLAYER_TARGET_CHANGED")
	questName = GetTitleText();
	MAX_VALUE = MAX_VALUE - 1
	iterator = QuestRepeatInputBox:GetNumber() - 1;
	QuestRewardCompleteButton_OnClick();

end

function QuestRepeatDecrement_OnClick()
	if (QuestRepeatInputBox:GetNumber() > 1) then
		QuestRepeatInputBox:SetNumber(QuestRepeatInputBox:GetNumber() - 1);
	end
end

function QuestRepeatIncrement_OnClick()
	if (QuestRepeatInputBox:GetNumber() < MAX_VALUE) then
		QuestRepeatInputBox:SetNumber(QuestRepeatInputBox:GetNumber() + 1);
	end
end
