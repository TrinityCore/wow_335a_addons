--[[################ FFEvents.lua ######################
    # Follow Felankor
    # A World of Warcraft UI AddOn
    # By Felankor
    #
    # IMPORTANT: I do not mind people looking at my code
    # to learn from it. If you use any parts of my code
    # please give me credit in your comments. I will
    # do the same if I ever use any code from another
    # AddOn. Thanks.
    ###################################################]]--
   
--[[#########################################
    #          Mount Functions
    #########################################]]
    
function FF_UpdateMounts()
    
    local englishFaction, localizedFaction = UnitFactionGroup("player");
    
    local FFNewNumMounts = GetNumCompanions("MOUNT");
    
    if FFNewNumMounts > 0 then --If the player has atleast one mount
        
        if FFNewNumMounts > FF_NumMounts then --If there is a new mount since the last time we checked
         
            for i=1, FFNewNumMounts do
                local creatureID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("MOUNT", i);
                
                local MountIdentified = false;
                
                local FFMountTooltip = CreateFrame("GameTooltip");
                local FFMountTooltipText = "";
                
                --Create font strings on the new tooltip frame
                local FFTooltipLines = {}
                for i=1, 40 do
                    FFTooltipLines[i] = FFMountTooltip:CreateFontString(); --Create a font string
                    FFMountTooltip:AddFontStrings(FFTooltipLines[i], FFMountTooltip:CreateFontString()); --Add the font string to the tooltip
                end
                
                FFMountTooltip:SetOwner(UIParent, "ANCHOR_NONE"); --You need to set an owner for the tooltip before it can be used
                FFMountTooltip:SetHyperlink("spell:"..creatureSpellID); --Fill the new tooltip with the spell details
                
                FFMountTooltipText = FFTooltipLines[FFMountTooltip:NumLines()]:GetText(); --Get the last line of text from the tooltip (I.e. the mount's description)

                --Sometimes we seem to get empty strings
                if FFMountTooltipText > "" then
                    
                    --Check if it is a flying mount
                    if strfind(FFMountTooltipText, FFMOUNTS_FLYING_SEARCH1) or strfind(FFMountTooltipText, FFMOUNTS_FLYING_SEARCH2) then
                        
                        --Check if it is a fast or slow flying mount
                        if strfind(FFMountTooltipText, FFMOUNTS_FAST_FLYING_SEARCH) then
                            table.insert(FF_FlyingMounts, i); --Add the companion id of the mount to FF_FlyingMounts
                        else
                            table.insert(FF_SlowFlyingMounts, i); --Add the companion id of the mount to FF_SlowFlyingMounts
                        end
                        
                    elseif strfind(FFMountTooltipText, FFMOUNTS_SWIMMING_SEARCH) then
                        table.insert(FF_SwimmingMounts, i); --Add the companion id of the mount to FF_SwimmingMounts
                    elseif strfind(FFMountTooltipText, FFMOUNTS_FLY_AND_GROUND_SEARCH) then --These mounts can be used in both flying and non flying ares (E.g. Celestial Steed)
                        table.insert(FF_FlyingMounts, i); --Add the companion id of the mount to FF_FlyingMounts
                        table.insert(FF_GroundMounts, i); --Add the companion id of the mount to FF_GroundMounts
                    else --If it's not a flying or swimming mount it must be a ground mount
                        
                        --Check if it is a fast or slow ground mount
                        if strfind(FFMountTooltipText, FFMOUNTS_FAST_GROUND_SEARCH) then
                            table.insert(FF_GroundMounts, i); --Add the companion id of the mount to FF_GroundMounts
                        else
                            table.insert(FF_SlowGroundMounts, i); --Add the companion id of the mount to FF_SlowGroundMounts
                        end
                        
                    end --End: if strfind(FFMountTooltipText, FFMOUNTS_FLYING_SEARCH) then
                    
                end --End: if FFMountTooltipText > "" then
                
            end --End: for i=1, FFNewNumMounts do
            
            FF_NumMounts = 0; --Reset the counter
            --Add up the total number of mounts identified
            FF_NumMounts = FF_NumMounts + table.getn(FF_FlyingMounts);
            FF_NumMounts = FF_NumMounts + table.getn(FF_SlowFlyingMounts);
            FF_NumMounts = FF_NumMounts + table.getn(FF_GroundMounts);
            FF_NumMounts = FF_NumMounts + table.getn(FF_SlowGroundMounts);
            FF_NumMounts = FF_NumMounts + table.getn(FF_SwimmingMounts);
            
        end --End: if FFNewNumMounts > FF_NumMounts then
        
    end --End: if FFNewNumMounts > 0 then
    
end

function FF_MountGround(sender)
   
    if IsMounted() == 1 then --If the player is mounted
        
        if IsFlying() == 1 then --If the player is flying
            FF_SendWhisper(FFMSG_FLYING, sender);
        else
            Dismount();
        end
        
    else
        
        if FF_Static_Ground_Mount ~= "" then --If the user has set a static ground mount
            
            for i=1, GetNumCompanions("MOUNT") do --For every mount the user has
                
                local creatureID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("MOUNT", i); --Get information about the mount
                
                if (string.lower(FF_Static_Ground_Mount) == string.lower(creatureName)) then --If the creature is found
                    CallCompanion("MOUNT", i);
                else --If the creature was not found
                    FF_Static_Ground_Mount = ""; --Clear the static ground mount
                    FF_MountRandomGround(sender); --Use a random mount instead
                end
                
            end
                
        elseif table.getn(FF_GroundMounts) > 0 then
            
            if IsSwimming() == 1 and table.getn(FF_SwimmingMounts) > 0 then --If the player is swimming and has swimming mount(s)
                CallCompanion("MOUNT", FF_SwimmingMounts[math.random(table.getn(FF_SwimmingMounts))]);
            else
                CallCompanion("MOUNT", FF_GroundMounts[math.random(table.getn(FF_GroundMounts))]);
            end
            
        elseif table.getn(FF_SlowGroundMounts) > 0 then
            
            if IsSwimming() == 1 and table.getn(FF_SwimmingMounts) > 0 then --If the player is swimming and has swimming mount(s)
                CallCompanion("MOUNT", FF_SwimmingMounts[math.random(table.getn(FF_SwimmingMounts))]);
            else
                CallCompanion("MOUNT", FF_SlowGroundMounts[math.random(table.getn(FF_SlowGroundMounts))]);
            end
            
        else
            FF_SendWhisper(FFMSG_NOMOUNTS, sender);
        end
        
    end
    
end


function FF_MountRandomGround(sender)
   
    if IsMounted() == 1 then --If the player is mounted
        
        if IsFlying() == 1 then --If the player is flying
            FF_SendWhisper(FFMSG_FLYING, sender);
        else
            Dismount();
        end
        
    else
        
        if IsSwimming() == 1 and table.getn(FF_SwimmingMounts) > 0 then --If the player is swimming and has swimming mount(s)
            CallCompanion("MOUNT", FF_SwimmingMounts[math.random(table.getn(FF_SwimmingMounts))]);
        else
            
            if table.getn(FF_GroundMounts) > 0 then
                CallCompanion("MOUNT", FF_GroundMounts[math.random(table.getn(FF_GroundMounts))]);
            elseif table.getn(FF_SlowGroundMounts) > 0 then
                CallCompanion("MOUNT", FF_SlowGroundMounts[math.random(table.getn(FF_SlowGroundMounts))]);
            else
                FF_SendWhisper(FFMSG_NOMOUNTS, sender);
            end
            
        end
        
    end
    
end

function FF_MountFlying(sender)
    
    if IsMounted() == 1 then --If the player is mounted
        
        if IsFlying() == 1 then --If the player is flying
            FF_SendWhisper(FFMSG_FLYING, sender);
        else
            Dismount();
        end
        
    else
        
        if IsFlyableArea() == 1 then
            
            if FF_Static_Flying_Mount ~= "" then --If the user has set a static flying mount
                
                for i=1, GetNumCompanions("MOUNT") do --For every mount the user has
                
                    local creatureID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("MOUNT", i); --Get information about the mount
                    
                    if (string.lower(FF_Static_Flying_Mount) == string.lower(creatureName)) then --If the creature is found
                        CallCompanion("MOUNT", i);
                    else --If the creature was not found
                        FF_Static_Flying_Mount = ""; --Clear the static flying mount
                        FF_MountRandomFlying(sender); --Use a random mount instead
                    end
                    
                end
                
            elseif table.getn(FF_FlyingMounts) > 0 then    
                CallCompanion("MOUNT", FF_FlyingMounts[math.random(table.getn(FF_FlyingMounts))]);
            elseif table.getn(FF_SlowFlyingMounts) > 0 then
                CallCompanion("MOUNT", FF_SlowFlyingMounts[math.random(table.getn(FF_SlowFlyingMounts))]);
            else
                FF_SendWhisper(FFMSG_NOMOUNTS, sender);
            end
            
        else
            FF_SendWhisper(FFMSG_CANT_FLY_HERE, sender);
        end
        
    end
    
end

function FF_MountRandomFlying(sender)
    
    if IsMounted() == 1 then --If the player is mounted
        
        if IsFlying() == 1 then --If the player is flying
            FF_SendWhisper(FFMSG_FLYING, sender);
        else
            Dismount();
        end
        
    else
        
        if IsFlyableArea() == 1 then
        
            if table.getn(FF_FlyingMounts) > 0 then    
                CallCompanion("MOUNT", FF_FlyingMounts[math.random(table.getn(FF_FlyingMounts))]);
            elseif table.getn(FF_SlowFlyingMounts) > 0 then
                CallCompanion("MOUNT", FF_SlowFlyingMounts[math.random(table.getn(FF_SlowFlyingMounts))]);
            else
                FF_SendWhisper(FFMSG_NOMOUNTS, sender);
            end
            
        else
            FF_SendWhisper(FFMSG_CANT_FLY_HERE, sender);
        end
        
    end
    
end