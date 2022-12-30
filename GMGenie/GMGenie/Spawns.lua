--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie.Spawns = {};

GMGenie.Spawns.direction = { forwardBackward = 1, leftRight = 1, upDown = 1, rotate = 1 };
GMGenie.Spawns.waitingForGps = 0;
GMGenie.Spawns.waitingForObject = false;
GMGenie.Spawns.waitingForObjectDelete = false;
GMGenie.Spawns.currentCoords = {};
GMGenie.Spawns.macroScheduleTime = 0;

function GMGenie.Spawns.onLoad()
    UIDropDownMenu_Initialize(GMGenie_Spawns_Main_ForwardBackward_Dropdownbuttons, GMGenie.Spawns.loadDropdownForwardBackward, "MENU");
    UIDropDownMenu_Initialize(GMGenie_Spawns_Main_LeftRight_Dropdownbuttons, GMGenie.Spawns.loadDropdownLeftRight, "MENU");
    UIDropDownMenu_Initialize(GMGenie_Spawns_Main_UpDown_Dropdownbuttons, GMGenie.Spawns.loadDropdownUpDown, "MENU");
    UIDropDownMenu_Initialize(GMGenie_Spawns_Main_Rotate_Dropdownbuttons, GMGenie.Spawns.loadDropdownRotate, "MENU");
    UIDropDownMenu_Initialize(GMGenie_Spawns_Main_Object_Dropdownbuttons, GMGenie.Spawns.loadObjectDropdown, "MENU");
    UIDropDownMenu_Initialize(GMGenie_Spawns_Main_Npc_Dropdownbuttons, GMGenie.Spawns.loadNpcDropdown, "MENU");
    GMGenie.Spawns.Hyperlink.onLoad();
end

function GMGenie.Spawns.loadDropdownForwardBackward(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'forward';
    info.func = GMGenie.Spawns.setForwardBackward;
    info.value = 1;
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'backward';
    info.func = GMGenie.Spawns.setForwardBackward;
    info.value = -1;
    UIDropDownMenu_AddButton(info, level);
end

function GMGenie.Spawns.setForwardBackward(self)
    CloseDropDownMenus();
    GMGenie.Spawns.direction.forwardBackward = self.value;
    GMGenie.Spawns.updateView();
end

function GMGenie.Spawns.loadDropdownLeftRight(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'left';
    info.func = GMGenie.Spawns.setLeftRight;
    info.value = 1;
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'right';
    info.func = GMGenie.Spawns.setLeftRight;
    info.value = -1;
    UIDropDownMenu_AddButton(info, level);
end

function GMGenie.Spawns.setLeftRight(self)
    CloseDropDownMenus();
    GMGenie.Spawns.direction.leftRight = self.value;
    GMGenie.Spawns.updateView();
end

function GMGenie.Spawns.loadDropdownUpDown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'up';
    info.func = GMGenie.Spawns.setUpDown;
    info.value = 1;
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'down';
    info.func = GMGenie.Spawns.setUpDown;
    info.value = -1;
    UIDropDownMenu_AddButton(info, level);
end

function GMGenie.Spawns.setUpDown(self)
    CloseDropDownMenus();
    GMGenie.Spawns.direction.upDown = self.value;
    GMGenie.Spawns.updateView();
end

function GMGenie.Spawns.loadDropdownRotate(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Rotate left';
    info.func = GMGenie.Spawns.setRotate;
    info.value = 1;
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Rotate right';
    info.func = GMGenie.Spawns.setRotate;
    info.value = -1;
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Face north';
    info.func = GMGenie.Spawns.setRotate;
    info.value = 0;
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Face east';
    info.func = GMGenie.Spawns.setRotate;
    info.value = 90;
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Face south';
    info.func = GMGenie.Spawns.setRotate;
    info.value = 180;
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Face west';
    info.func = GMGenie.Spawns.setRotate;
    info.value = 270;
    UIDropDownMenu_AddButton(info, level);
end

function GMGenie.Spawns.setRotate(self)
    CloseDropDownMenus();
    GMGenie.Spawns.direction.rotate = self.value;
    GMGenie.Spawns.updateView();
end

function GMGenie.Spawns.updateView()
    if GMGenie.Spawns.direction.forwardBackward == 1 then
        GMGenie_Spawns_Main_ForwardBackward_Direction:SetText('forward');
    else
        GMGenie_Spawns_Main_ForwardBackward_Direction:SetText('backward');
    end

    if GMGenie.Spawns.direction.leftRight == 1 then
        GMGenie_Spawns_Main_LeftRight_Direction:SetText('left');
    else
        GMGenie_Spawns_Main_LeftRight_Direction:SetText('right');
    end

    if GMGenie.Spawns.direction.upDown == 1 then
        GMGenie_Spawns_Main_UpDown_Direction:SetText('up');
    else
        GMGenie_Spawns_Main_UpDown_Direction:SetText('down');
    end

    if GMGenie.Spawns.direction.rotate == 1 then
        GMGenie_Spawns_Main_Rotate_Direction:SetText('Rotate left');
        GMGenie_Spawns_Main_Rotate_Amount:Show();
    elseif GMGenie.Spawns.direction.rotate == -1 then
        GMGenie_Spawns_Main_Rotate_Direction:SetText('Rotate right');
        GMGenie_Spawns_Main_Rotate_Amount:Show();
    elseif GMGenie.Spawns.direction.rotate == 0 then
        GMGenie_Spawns_Main_Rotate_Direction:SetText('Face north');
        GMGenie_Spawns_Main_Rotate_Amount:Hide();
    elseif GMGenie.Spawns.direction.rotate == 90 then
        GMGenie_Spawns_Main_Rotate_Direction:SetText('Face east');
        GMGenie_Spawns_Main_Rotate_Amount:Hide();
    elseif GMGenie.Spawns.direction.rotate == 180 then
        GMGenie_Spawns_Main_Rotate_Direction:SetText('Face south');
        GMGenie_Spawns_Main_Rotate_Amount:Hide();
    elseif GMGenie.Spawns.direction.rotate == 270 then
        GMGenie_Spawns_Main_Rotate_Direction:SetText('Face west');
        GMGenie_Spawns_Main_Rotate_Amount:Hide();
    end

    if not GMGenie.Spawns.currentCoords.x then
        GMGenie_Spawns_Main_Coords_X:SetText('X:');
    else
        local x = tostring(GMGenie.Spawns.currentCoords.x);
        if string.len(x) > 10 then
            x = string.sub(x, 1, 10);
        end
        GMGenie_Spawns_Main_Coords_X:SetText('X: ' .. x);
    end

    if not GMGenie.Spawns.currentCoords.y then
        GMGenie_Spawns_Main_Coords_Y:SetText('Y:');
    else
        local y = tostring(GMGenie.Spawns.currentCoords.y);
        if string.len(y) > 10 then
            y = string.sub(y, 1, 10);
        end
        GMGenie_Spawns_Main_Coords_Y:SetText('Y: ' .. y);
    end

    if not GMGenie.Spawns.currentCoords.z then
        GMGenie_Spawns_Main_Coords_Z:SetText('Z:');
    else
        local z = tostring(GMGenie.Spawns.currentCoords.z);
        if string.len(z) > 10 then
            z = string.sub(z, 1, 10);
        end
        GMGenie_Spawns_Main_Coords_Z:SetText('Z: ' .. z);
    end

    if not GMGenie.Spawns.currentCoords.o then
        GMGenie_Spawns_Main_Coords_O:SetText('O:');
    else
        local o = tostring(GMGenie.Spawns.currentCoords.o);
        if string.len(o) > 10 then
            o = string.sub(o, 1, 10);
        end
        GMGenie_Spawns_Main_Coords_O:SetText('O: ' .. o);
    end
end

function GMGenie.Spawns.clearFocus()
    GMGenie_Spawns_Main_ForwardBackward_Amount:ClearFocus();
    GMGenie_Spawns_Main_LeftRight_Amount:ClearFocus();
    GMGenie_Spawns_Main_UpDown_Amount:ClearFocus();
    GMGenie_Spawns_Main_Rotate_Amount:ClearFocus();
    GMGenie_Spawns_Main_Npc_Id:ClearFocus();
    GMGenie_Spawns_Main_Object_Id:ClearFocus();
    GMGenie_Spawns_Macro_Macro_Frame_Text:ClearFocus();
end



function GMGenie.Spawns.initiateMove(option)
    GMGenie.Spawns.currentSpawnOption = option;
    if not (GMGenie.Spawns.currentCoords.x and GMGenie.Spawns.currentCoords.y and GMGenie.Spawns.currentCoords.z and GMGenie.Spawns.currentCoords.o and GMGenie.Spawns.currentCoords.map) then
        SendChatMessage(".gps", "GUILD");
        GMGenie.Spawns.waitingForGps = 1;
    else
        GMGenie.Spawns.move(GMGenie.Spawns.currentCoords.x, GMGenie.Spawns.currentCoords.y, GMGenie.Spawns.currentCoords.z, GMGenie.Spawns.currentCoords.o);
    end
    GMGenie.Spawns.clearFocus();
end

function GMGenie.Spawns.setMap(map)
    GMGenie.Spawns.currentCoords.map = map;
end

function GMGenie.Spawns.move(x, y, z, o)

    local forwardBackward = GMGenie_Spawns_Main_ForwardBackward_Amount:GetText();
    if not forwardBackward or forwardBackward == "" then
        forwardBackward = 0;
    end
    local leftRight = GMGenie_Spawns_Main_LeftRight_Amount:GetText();
    if not leftRight or leftRight == "" then
        leftRight = 0;
    end
    local upDown = GMGenie_Spawns_Main_UpDown_Amount:GetText();
    if not upDown or upDown == "" then
        upDown = 0;
    end
    local rotate = GMGenie_Spawns_Main_Rotate_Amount:GetText();
    if not rotate or rotate == "" then
        rotate = 0;
    end

    forwardBackward = tonumber(forwardBackward) * GMGenie.Spawns.direction.forwardBackward;
    leftRight = tonumber(leftRight) * GMGenie.Spawns.direction.leftRight;
    upDown = tonumber(upDown);
    rotate = tonumber(rotate);

    x = tonumber(x);
    y = tonumber(y);
    z = tonumber(z);
    o = deg(tonumber(o));

    if GMGenie.Spawns.currentSpawnOption == -1 then
        forwardBackward = -1 * forwardBackward;
        leftRight = -1 * leftRight;
        upDown = -1 * upDown;
        rotate = -1 * rotate;
    elseif GMGenie.Spawns.currentSpawnOption == 1 then
        Chronos.scheduleByName('spawnobject', 0.25, GMGenie.Spawns.object, GMGenie_Spawns_Main_Object_Id:GetText());
    elseif GMGenie.Spawns.currentSpawnOption == 2 then
        Chronos.scheduleByName('spawnnpc', 0.25, GMGenie.Spawns.npc, GMGenie_Spawns_Main_Npc_Id:GetText());
    end

    local tempO = o;
    if GMGenie.Spawns.currentSpawnOption == -1 then
        if GMGenie.Spawns.direction.rotate == 1 or GMGenie.Spawns.direction.rotate == -1 then
            tempO = o + (rotate * GMGenie.Spawns.direction.rotate);
        else
            tempO = GMGenie.Spawns.direction.rotate;
        end
    end

    x = x + ((cos(tempO) * forwardBackward) + (cos(270 - tempO) * leftRight));
    y = y + ((sin(tempO) * forwardBackward) - (sin(270 - tempO) * leftRight));
    z = z + (upDown * GMGenie.Spawns.direction.upDown);

    if GMGenie.Spawns.direction.rotate == 1 or GMGenie.Spawns.direction.rotate == -1 then
        o = o + (rotate * GMGenie.Spawns.direction.rotate);
    else
        o = GMGenie.Spawns.direction.rotate;
    end

    o = rad(o);

    GMGenie.Spawns.currentCoords.x = x;
    GMGenie.Spawns.currentCoords.y = y;
    GMGenie.Spawns.currentCoords.z = z;
    GMGenie.Spawns.currentCoords.o = o;

    SendChatMessage(".go xyz " .. x .. " " .. y .. " " .. z .. " " .. GMGenie.Spawns.currentCoords.map .. " " .. o, "GUILD");
    GMGenie.Spawns.updateView();
end

function GMGenie.Spawns.object(objectId)
    if not objectId or objectId == "" then
        return false;
    end
    objectId = tonumber(objectId);

    SendChatMessage(".gobject add " .. objectId, "GUILD");
end

function GMGenie.Spawns.npc(npcId)
    if not npcId or npcId == "" then
        return false;
    end
    npcId = tonumber(npcId);

    SendChatMessage(".npc add " .. npcId, "GUILD");
end

function GMGenie.Spawns.resetCoords()
    GMGenie.Spawns.currentCoords = {};
    GMGenie.Spawns.updateView();
end

function GMGenie.Spawns.targetObject()
    GMGenie.Spawns.waitingForObject = true;
    SendChatMessage(".gobject target", "GUILD");
end

function GMGenie.Spawns.deleteObject(name, guid, id)
    GMGenie.Spawns.waitingForObjectDelete = true;
    SendChatMessage(".gobject del " .. guid, "GUILD");
    GMGenie.showGMMessage("Deleting object: " .. name .. " GUID: " .. guid .. " ID: " .. id);
end

function GMGenie.Spawns.deleteNpc()
    SendChatMessage(".npc del");
end

function GMGenie.Spawns.toggleMacroWindow()
    local frame = GMGenie_Spawns_Macro;
    if frame:IsVisible() then
        frame:Hide();
    else
        frame:Show();
    end
end

function GMGenie.Spawns.scheduleGo(forwardBackward, leftRight, upDown, rotate, rotateDir, option, id)
    Chronos.schedule(GMGenie.Spawns.macroScheduleTime, GMGenie.Spawns.go, forwardBackward, leftRight, upDown, rotate, rotateDir, option, id)
    GMGenie.Spawns.macroScheduleTime = 1 + GMGenie.Spawns.macroScheduleTime;
end

function GMGenie.Spawns.go(forwardBackward, leftRight, upDown, rotate, rotateDir, option, id)
    GMGenie.Spawns.direction = { forwardBackward = 1, leftRight = 1, upDown = 1, rotate = rotateDir };
    GMGenie_Spawns_Main_ForwardBackward_Amount:SetText(forwardBackward);
    GMGenie_Spawns_Main_LeftRight_Amount:SetText(leftRight);
    GMGenie_Spawns_Main_UpDown_Amount:SetText(upDown);
    GMGenie_Spawns_Main_Rotate_Amount:SetText(rotate);

    GMGenie_Spawns_Main_Object_Id:SetText("");
    GMGenie_Spawns_Main_Npc_Id:SetText("");
    if option == 1 then
        GMGenie_Spawns_Main_Object_Id:SetText(id);
    elseif option == 2 then
        GMGenie_Spawns_Main_Npc_Id:SetText(id);
    end

    GMGenie.Spawns.updateView();
    GMGenie.Spawns.clearFocus();

    GMGenie.Spawns.initiateMove(option);

    GMGenie.Spawns.macroScheduleTime = 2 + GMGenie.Spawns.macroScheduleTime;
end

function GMGenie.Spawns.runMacro()
    GMGenie.Spawns.macroScheduleTime = 0;
    local macroText = GMGenie_Spawns_Macro_Macro_Frame_Text:GetText();
    macroText = string.gsub(macroText, "go", "GMGenie.Spawns.scheduleGo");
    GMGenie.showGMMessage("Running spawn macro, do not interfere!");
    RunScript(macroText);
end

function GMGenie.Spawns.toggle()
    local frame = GMGenie_Spawns_Main;
    if frame:IsVisible() then
        frame:Hide();
    else
        frame:Show();
    end
end

function GMGenie.Spawns.loadObjectDropdown(self, level)
    local objectsTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.objects);
    for index, name in pairs(objectsTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = GMGenie.Spawns.selectObject;
        info.value = GMGenie_SavedVars.objects[name];
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Presets";
    info.func = GMGenie.Spawns.showOptions;
    UIDropDownMenu_AddButton(info, level);
end

function GMGenie.Spawns.loadNpcDropdown(self, level)
    local npcsTemp = GMGenie.pairsByKeys2(GMGenie_SavedVars.npcs);
    for index, name in pairs(npcsTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = GMGenie.Spawns.selectNpc;
        info.value = GMGenie_SavedVars.npcs[name];
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Presets";
    info.func = GMGenie.Spawns.showOptions;
    UIDropDownMenu_AddButton(info, level);
end

function GMGenie.Spawns.selectObject(self)
    CloseDropDownMenus();
    GMGenie_Spawns_Main_Object_Id:SetText(self.value);
end

function GMGenie.Spawns.selectNpc(self)
    CloseDropDownMenus();
    GMGenie_Spawns_Main_Npc_Id:SetText(self.value);
end



GMGenie.Spawns.Hyperlink = {};
GMGenie.Spawns.Hyperlink.name = '';
GMGenie.Spawns.Hyperlink.id = '';
GMGenie.Spawns.Hyperlink.type = '';

function GMGenie.Spawns.Hyperlink.onLoad()
    UIDropDownMenu_Initialize(GMGenie_Spawns_Hyperlink_Menu, GMGenie.Spawns.Hyperlink.loadMenu, "MENU");
end

function GMGenie.Spawns.Hyperlink.loadMenu(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = GMGenie.Spawns.Hyperlink.name;
    info.fontObject = GenieFontNormalSmall;
    UIDropDownMenu_AddButton(info, level);

    if GMGenie.Spawns.Hyperlink.type == "gameobject_entry" or GMGenie.Spawns.Hyperlink.type == "creature_entry" then
        local name;
        if GMGenie.Spawns.Hyperlink.type == "gameobject_entry" then
            name = 'gameobject';
        else
            name = 'creature';
        end

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Spawn ' .. name .. ' here';
        info.func = GMGenie.Spawns.Hyperlink.spawnHere;
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Add ' .. name .. ' to presets';
        info.func = GMGenie.Spawns.Hyperlink.addPreset;
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'List spawned ' .. name .. 's';
        info.func = GMGenie.Spawns.Hyperlink.list;
        UIDropDownMenu_AddButton(info, level);
    elseif GMGenie.Spawns.Hyperlink.type == "gameobject" or GMGenie.Spawns.Hyperlink.type == "creature" then
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Go to ' .. GMGenie.Spawns.Hyperlink.type;
        info.func = GMGenie.Spawns.Hyperlink.goTo;
        UIDropDownMenu_AddButton(info, level);

        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Remove ' .. GMGenie.Spawns.Hyperlink.type;
        info.func = GMGenie.Spawns.Hyperlink.remove;
        UIDropDownMenu_AddButton(info, level);
    end

    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Close menu';
    UIDropDownMenu_AddButton(info, level);
end

function GMGenie.Spawns.Hyperlink.spawnHere()
    if GMGenie.Spawns.Hyperlink.type == "gameobject_entry" then
        SendChatMessage(".gob add " .. GMGenie.Spawns.Hyperlink.id, "GUILD");
    elseif GMGenie.Spawns.Hyperlink.type == "creature_entry" then
        SendChatMessage(".npc add " .. GMGenie.Spawns.Hyperlink.id, "GUILD");
    else
        GMGnie.showGMMessage("Could not spawn link type " .. GMGenie.Spawns.Hyperlink.type);
    end
end

function GMGenie.Spawns.Hyperlink.addPreset()
    if GMGenie.Spawns.Hyperlink.type == "gameobject_entry" then
        GMGenie_SavedVars.objects[GMGenie.Spawns.Hyperlink.name] = GMGenie.Spawns.Hyperlink.id;
    elseif GMGenie.Spawns.Hyperlink.type == "creature_entry" then
        GMGenie_SavedVars.npcs[GMGenie.Spawns.Hyperlink.name] = GMGenie.Spawns.Hyperlink.id;
    else
        GMGnie.showGMMessage("Could not add preset for link type " .. GMGenie.Spawns.Hyperlink.type);
    end
end

function GMGenie.Spawns.Hyperlink.list()
    if GMGenie.Spawns.Hyperlink.type == "gameobject_entry" then
        SendChatMessage(".list object " .. GMGenie.Spawns.Hyperlink.id, "GUILD");
    elseif GMGenie.Spawns.Hyperlink.type == "creature_entry" then
        SendChatMessage(".list creature " .. GMGenie.Spawns.Hyperlink.id, "GUILD");
    else
        GMGnie.showGMMessage("Could not list link type " .. GMGenie.Spawns.Hyperlink.type);
    end
end

function GMGenie.Spawns.Hyperlink.goTo()
    if GMGenie.Spawns.Hyperlink.type == "gameobject" then
        SendChatMessage(".go object " .. GMGenie.Spawns.Hyperlink.id, "GUILD");
    elseif GMGenie.Spawns.Hyperlink.type == "creature" then
        SendChatMessage(".go creature " .. GMGenie.Spawns.Hyperlink.id, "GUILD");
    else
        GMGnie.showGMMessage("Could not port to link type " .. GMGenie.Spawns.Hyperlink.type);
    end
end

function GMGenie.Spawns.Hyperlink.remove()
    if GMGenie.Spawns.Hyperlink.type == "gameobject" then
        SendChatMessage(".gob delete " .. GMGenie.Spawns.Hyperlink.id, "GUILD");
    elseif GMGenie.Spawns.Hyperlink.type == "creature" then
        SendChatMessage(".npc delete " .. GMGenie.Spawns.Hyperlink.id, "GUILD");
    else
        GMGnie.showGMMessage("Could not remove link type " .. GMGenie.Spawns.Hyperlink.type);
    end
end

function GMGenie.Spawns.Hyperlink.toggle(link, text)
    if not link or link == GMGenie.Spawns.Hyperlink.link then
        GMGenie.Spawns.Hyperlink.name = '';
        GMGenie.Spawns.Hyperlink.id = '';
        GMGenie.Spawns.Hyperlink.type = '';
    else
        local type, id = strsplit(":", link);
        GMGenie.Spawns.Hyperlink.type = type;
        GMGenie.Spawns.Hyperlink.id = id;
        GMGenie.Spawns.Hyperlink.name = string.match(text, "%[(.*)%]");
    end
    ToggleDropDownMenu(1, nil, GMGenie_Spawns_Hyperlink_Menu, 'cursor', 0, 0);
end

local Saved_SetItemRef = SetItemRef;
function SetItemRef(link, text, button, chatFrame)
    if (strsub(link, 1, 16) == "gameobject_entry") or (strsub(link, 1, 14) == "creature_entry") or (strsub(link, 1, 10) == "gameobject") or (strsub(link, 1, 8) == "creature") then
        GMGenie.Spawns.Hyperlink.toggle(link, text);
        return;
    end
    Saved_SetItemRef(link, text, button, chatFrame);
end

-- add slash command to open/close builder widnow
SLASH_SPAWNS1 = "/builder";
SLASH_SPAWNS2 = "/spawns";
SlashCmdList["SPAWNS"] = GMGenie.Spawns.toggle;