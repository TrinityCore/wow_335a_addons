--This file is part of Game Master Genie.
--Copyright 2011-2014 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

GMGenie.Tickets = {};

-- config
GMGenie.Tickets.perPage = 10;

-- vars
GMGenie.Tickets.pages = 1;
GMGenie.Tickets.tickets = 0;
GMGenie.Tickets.onlineTickets = 0;
GMGenie.Tickets.currentPage = 1;
GMGenie.Tickets.currentTicket = { ["num"] = 0, ["ticketId"] = 0, ['name'] = "", ["message"] = "" };
GMGenie.Tickets.order = "ticketId";
GMGenie.Tickets.ascDesc = false;
GMGenie.Tickets.messageOpen = false;
GMGenie.Tickets.done = 0;
GMGenie.Tickets.syncList = {};
GMGenie.Tickets.loadingOnline = false;
--GMGenie.Tickets.Colours = { ["onlineUnread"] = "ffbfbfff", ["onlineRead"] = "ffffffff", ["offlineUnread"] = "ff5f5f80", ["offlineRead"] = "ff808080" };
GMGenie.Tickets.Colours = { ["current"] = "ffffffff", ["onlineUnread"] = "ffbfbfff", ["onlineRead"] = "ff5f5f7f", ["offlineUnread"] = "ffff0000", ["offlineRead"] = "ff7f0000" };

-- ticket list
GMGenie.Tickets.list = {};
GMGenie.Tickets.read = {};
GMGenie.Tickets.idToNum = {};

function GMGenie.Tickets.onLoad()
    Chronos.scheduleRepeating('ticketrefresh', 60, GMGenie.Tickets.refresh);
    GMGenie.Tickets.refresh();
    GMGenie.Tickets.done = GMGenie_SavedVars.ticketsDone;
end

-- refresh ticket list & schedule next refresh
function GMGenie.Tickets.refresh()
    if not GMGenie.Tickets.tempList then
        -- create empty list
        GMGenie.Tickets.tempList = {};
        GMGenie.Tickets.idToNum = {};
        GMGenie.Tickets.tickets = 0;
        GMGenie.Tickets.onlineTickets = 0;
        GMGenie.Tickets.loadingOnline = false;
        -- get ticket list
        SendChatMessage(".ticket list", "GUILD");
        -- schedule next refresh
        Chronos.scheduleByName('ticketreupdate', 3, GMGenie.Tickets.update);
    elseif GMGenie.Tickets.loadingOnline then
        SendChatMessage(".ticket onlinelist", "GUILD");
        Chronos.scheduleByName('ticketreupdate', 3, GMGenie.Tickets.update);
    end
end

-- add ticket from chat list to the addon list
function GMGenie.Tickets.listTicket(ticketId, name, createStr, createStamp, lastModifiedStr, lastModifiedStamp)
    local ticketInfo = { ["ticketId"] = ticketId, ["name"] = name, ["createStr"] = createStr, ["createStamp"] = createStamp, ["lastModifiedStr"] = lastModifiedStr, ["lastModifiedStamp"] = lastModifiedStamp, ["assignedTo"] = "", ['online'] = GMGenie.Tickets.loadingOnline };
    if GMGenie.Tickets.tempList and not GMGenie.Tickets.idToNum[ticketId] and not GMGenie.Tickets.loadingOnline then
        -- add to temp list if page is being refreshed
        table.insert(GMGenie.Tickets.tempList, ticketInfo);
        GMGenie.Tickets.tickets = GMGenie.Tickets.tickets + 1;
        GMGenie.Tickets.idToNum[ticketId] = GMGenie.Tickets.tickets;
    elseif GMGenie.Tickets.tempList and GMGenie.Tickets.loadingOnline then
        GMGenie.Tickets.onlineTickets = GMGenie.Tickets.onlineTickets + 1;
        if GMGenie.Tickets.idToNum[ticketId] then
            GMGenie.Tickets.tempList[GMGenie.Tickets.idToNum[ticketId]] = ticketInfo;
        else
            table.insert(GMGenie.Tickets.tempList, ticketInfo);
            GMGenie.Tickets.tickets = GMGenie.Tickets.tickets + 1;
            GMGenie.Tickets.idToNum[ticketId] = GMGenie.Tickets.tickets;
        end
    end
    -- if no new tickets come in the chat for 1 second, update the list
    Chronos.scheduleByName('ticketreupdate', 0.25, GMGenie.Tickets.update);
end

-- set assignedTo for a ticket
function GMGenie.Tickets.setAssigned(ticketId, assignedTo)
    -- ticket list currently being refreshed or not?
    if GMGenie.Tickets.tempList and GMGenie.Tickets.idToNum[ticketId] then
        GMGenie.Tickets.tempList[GMGenie.Tickets.idToNum[ticketId]]["assignedTo"] = assignedTo;
    elseif GMGenie.Tickets.idToNum[ticketId] then
        GMGenie.Tickets.list[GMGenie.Tickets.idToNum[ticketId]]["assignedTo"] = assignedTo;
    else
        Chronos.schedule(0.2, GMGenie.Tickets.setAssigned, ticketId, assignedTo);
    end
end

-- update ticket list
function GMGenie.Tickets.update()
    -- Check onlines too?
    if not GMGenie.Tickets.loadingOnline then
        GMGenie.Tickets.loadingOnline = true;
        GMGenie.Tickets.refresh();
    else
        GMGenie.Tickets.loadingOnline = false;

        -- move temp list to current list and empty temp list
        if GMGenie.Tickets.tempList then
            GMGenie.Tickets.list = GMGenie.Tickets.tempList;
            GMGenie.Tickets.tempList = nil;
        end
        -- calc number of pages
        if GMGenie_SavedVars.showOfflineTickets then
            GMGenie.Tickets.pages = math.ceil(GMGenie.Tickets.tickets / GMGenie.Tickets.perPage);
        else
            GMGenie.Tickets.pages = math.ceil(GMGenie.Tickets.onlineTickets / GMGenie.Tickets.perPage);
        end
        -- allways at least 1 page
        if GMGenie.Tickets.pages < 1 then
            GMGenie.Tickets.pages = 1;
        end
        -- does the page currently being viewed still exist?
        if GMGenie.Tickets.currentPage > GMGenie.Tickets.pages then
            GMGenie.Tickets.currentPage = GMGenie.Tickets.pages;
        end
        -- order ticket list
        GMGenie.Tickets.sort();
    end
end

-- change ordering for ticket list
function GMGenie.Tickets.changeOrder(order)
    if GMGenie.Tickets.order == order then
        if GMGenie.Tickets.ascDesc then
            GMGenie.Tickets.ascDesc = false;
        else
            GMGenie.Tickets.ascDesc = true;
        end
    else
        GMGenie.Tickets.order = order;
        GMGenie.Tickets.ascDesc = false;
    end
    GMGenie.Tickets.currentPage = 1;
    GMGenie.Tickets.sort();
end

-- order ticket list
function GMGenie.Tickets.sort()
    if GMGenie.Tickets.ascDesc then
        table.sort(GMGenie.Tickets.list, function(a, b) return a[GMGenie.Tickets.order] > b[GMGenie.Tickets.order] end);
    else
        table.sort(GMGenie.Tickets.list, function(a, b) return a[GMGenie.Tickets.order] < b[GMGenie.Tickets.order] end);
    end

    -- update idToNum table
    GMGenie.Tickets.idToNum = {};
    for ticketNum, ticketInfo in ipairs(GMGenie.Tickets.list) do
        GMGenie.Tickets.idToNum[ticketInfo["ticketId"]] = ticketNum;
    end

    -- update the ticket window
    GMGenie.Tickets.updateView();
end

-- update the ticket window
function GMGenie.Tickets.updateView()
    -- Page x of y (z tickets)
    local offlineCount = GMGenie.Tickets.tickets - GMGenie.Tickets.onlineTickets;

    local plural = { ["total"] = "s", ["online"] = "s", ["offline"] = "s" };
    if GMGenie.Tickets.onlineTickets == 1 then
        plural["online"] = "";
    end
    if offlineCount == 1 then
        plural["offline"] = "";
    end
    if GMGenie.Tickets.tickets == 1 then
        plural["total"] = "";
    end

    GMGenie_Tickets_Main_Info_Text:SetText(GMGenie.Tickets.tickets .. " ticket" .. plural["total"] .. " (|c" .. GMGenie.Tickets.Colours["onlineUnread"] .. GMGenie.Tickets.onlineTickets .. " online,|r |c" .. GMGenie.Tickets.Colours["offlineUnread"] .. offlineCount .. " offline|r), " .. GMGenie.Tickets.done .. " done");
    GMGenie_Tickets_Main_Info_Page:SetText("Page " .. GMGenie.Tickets.currentPage .. " of " .. GMGenie.Tickets.pages);

    GMGenie_Hud_Tickets:SetText("Tickets (|c" .. GMGenie.Tickets.Colours["onlineUnread"] .. GMGenie.Tickets.onlineTickets .. "|r / |c" .. GMGenie.Tickets.Colours["offlineUnread"] .. offlineCount .. "|r)");

    -- previous page
    if (GMGenie.Tickets.currentPage == 1) then
        GMGenie_Tickets_Main_Previous:Disable();
    else
        GMGenie_Tickets_Main_Previous:Enable();
    end

    -- next page
    if (GMGenie.Tickets.currentPage == GMGenie.Tickets.pages) then
        GMGenie_Tickets_Main_Next:Disable();
    else
        GMGenie_Tickets_Main_Next:Enable();
    end

    -- start and end of the list on the current page
    local minTicket = 1 + ((GMGenie.Tickets.currentPage - 1) * GMGenie.Tickets.perPage);
    local maxTicket = GMGenie.Tickets.currentPage * GMGenie.Tickets.perPage;
    local num = 1;
    local i = 0;

    -- reset num
    GMGenie.Tickets.currentTicket["num"] = 0;

    -- loop through tickets
    for ticketNum, ticketInfo in ipairs(GMGenie.Tickets.list) do
        -- Show ticket?
        if ticketInfo["online"] or GMGenie_SavedVars.showOfflineTickets then
            i = i + 1;
            if i >= minTicket and i <= maxTicket then
                -- colour in list
                local colour;
                if ticketInfo["ticketId"] == GMGenie.Tickets.currentTicket["ticketId"] then
                    colour = GMGenie.Tickets.Colours["current"];
                else
                    if GMGenie.Tickets.read[ticketInfo["ticketId"]] then
                        if ticketInfo["online"] then
                            colour = GMGenie.Tickets.Colours["onlineRead"];
                        else
                            colour = GMGenie.Tickets.Colours["offlineRead"];
                        end
                    else
                        if ticketInfo["online"] then
                            colour = GMGenie.Tickets.Colours["onlineUnread"];
                        else
                            colour = GMGenie.Tickets.Colours["offlineUnread"];
                        end
                    end
                end

                -- set ticket info
                getglobal("TicketStatusButton" .. num .. "_ticketId"):SetText("|c" .. colour .. ticketInfo["ticketId"] .. "|r");
                getglobal("TicketStatusButton" .. num .. "_name"):SetText("|c" .. colour .. ticketInfo["name"] .. "|r");
                getglobal("TicketStatusButton" .. num .. "_createStr"):SetText("|c" .. colour .. ticketInfo["createStr"] .. "|r");
                getglobal("TicketStatusButton" .. num .. "_lastModifiedStr"):SetText("|c" .. colour .. ticketInfo["lastModifiedStr"] .. "|r");
                getglobal("TicketStatusButton" .. num .. "_assignedTo"):SetText("|c" .. colour .. ticketInfo["assignedTo"] .. "|r");
                getglobal("TicketStatusButton" .. num):Show();

                getglobal("TicketStatusButton" .. num).ticketId = ticketInfo["ticketId"];

                -- number on the ticket window
                num = num + 1;
            end
        end
    end
    if num <= GMGenie.Tickets.perPage then
        for num = num, GMGenie.Tickets.perPage do
            getglobal("TicketStatusButton" .. num):Hide();
        end
    end
end

-- next page
function GMGenie.Tickets.goToNext()
    if GMGenie.Tickets.currentPage < GMGenie.Tickets.pages then
        GMGenie.Tickets.currentPage = GMGenie.Tickets.currentPage + 1;
        GMGenie.Tickets.updateView();
    end
end

-- previous page
function GMGenie.Tickets.goToPrevious()
    if GMGenie.Tickets.currentPage > 1 then
        GMGenie.Tickets.currentPage = GMGenie.Tickets.currentPage - 1;
        GMGenie.Tickets.updateView();
    end
end

-- mark ticket as read
function GMGenie.Tickets.markAsRead(ticketId)
    GMGenie.Tickets.read[ticketId] = true;
    GMGenie.Tickets.updateView();
end

-- mark ticket as unread
function GMGenie.Tickets.markAsUnread(ticketId)
    GMGenie.Tickets.ReadTickets[ticketId] = false;
end

function GMGenie.Tickets.isOpen()
    local frame = GMGenie_Tickets_Main;
    if (frame) then
        return frame:IsVisible();
    end
end

-- hide or show ticket window
function GMGenie.Tickets.toggle(showOffline)
    if GMGenie.Tickets.isOpen() then
        -- hide window
        GMGenie_Tickets_Main:Hide();
    else
        if showOffline and not GMGenie_SavedVars.showOfflineTickets then
            GMGenie.Tickets.toggleOfflineTickets();
        end
        -- refresh ticket list and initiate auto-refresh
        GMGenie.Tickets.onLoad();
        -- show window
        GMGenie_Tickets_Main:Show();
    end
end

-- load ticket
function GMGenie.Tickets.loadTicket(ticketId, num)
    if (GMGenie.Tickets.currentTicket["ticketId"] and GMGenie.Tickets.currentTicket["ticketId"] == ticketId) then
        GMGenie.Tickets.close();
        return;
    else
        if GMGenie.Tickets.idToNum[ticketId] then
            if GMGenie.Tickets.list[GMGenie.Tickets.idToNum[ticketId]]["name"] then
                -- update current ticket
                GMGenie.Tickets.currentTicket = { ["num"] = num, ["ticketId"] = ticketId, ["name"] = GMGenie.Tickets.list[GMGenie.Tickets.idToNum[ticketId]]["name"], ["comment"] = "", ["message"] = "Loading..." };
                -- set title and loading text
                GMGenie_Tickets_View_Title_Text:SetText(GMGenie.Tickets.currentTicket["name"] .. "'s Ticket");
                GMGenie.Tickets.showMessage();
                -- hide reading frame UNUSED ATM
                --GMGenie_Tickets_View_Ticket_Reading:Hide();
                -- get ticket
                SendChatMessage(".ticket viewid " .. ticketId, "GUILD");
                -- open spy
                if GMGenie_SavedVars.useSpy then
                    GMGenie.Spy.spy(GMGenie.Tickets.currentTicket["name"]);
                end
                -- mark as read
                GMGenie.Tickets.markAsRead(ticketId);
                -- toggle frame
                GMGenie_Tickets_View:Show();
                if GMGenie_SavedVars.swapTicketWindows then
                    GMGenie.Tickets.toggle();
                end
                -- chronos schedule and send message
                Chronos.scheduleRepeating('ticketSync', 30, GMGenie.Tickets.sync);
                GMGenie.Tickets.sync();
                GMGenie.Tickets.displaySync()
                return;
            end
        end
    end
    Chronos.schedule(0.2, GMGenie.Tickets.loadTicket, ticketId, num);
end

function GMGenie.Tickets.displaySync()
    local names = {};
    local num = 0;
    for name, ticketId in pairs(GMGenie.Tickets.syncList) do
        if tonumber(ticketId) == tonumber(GMGenie.Tickets.currentTicket["ticketId"]) then
            table.insert(names, name);
            num = num + 1;
        end
    end

    if num > 0 then
        local text = "";
        for index, name in ipairs(names) do
            text = text .. name;
            if index == (num - 1) then
                text = text .. " and ";
            elseif index < (num - 1) then
                text = text .. ", ";
            end
        end
        GMGenie_Tickets_View_Sync_Names:SetText(text);
        GMGenie_Tickets_View_Ticket:SetHeight(150);
        GMGenie_Tickets_View_Ticket_Frame:SetHeight(150);
        GMGenie_Tickets_View_Ticket_Frame_Text:SetHeight(150);
        GMGenie_Tickets_View_Sync:Show();
    else
        GMGenie_Tickets_View_Ticket:SetHeight(173);
        GMGenie_Tickets_View_Ticket_Frame:SetHeight(173);
        GMGenie_Tickets_View_Ticket_Frame_Text:SetHeight(173);
        GMGenie_Tickets_View_Sync:Hide();
    end
end

function GMGenie.Tickets.sync()
    SendAddonMessage("GMGenie_Sync", GMGenie.Tickets.currentTicket["ticketId"], "GUILD");
end

function GMGenie.Tickets.syncMessage(name, ticketId)
    if UnitName("player") ~= name then
        if not (GMGenie.Tickets.syncList[name] and GMGenie.Tickets.syncList[name] == ticketId) then
            GMGenie.Tickets.syncList[name] = ticketId;
            if ticketId == 0 then
                Chronos.unscheduleByName('ticketSync' .. name);
            else
                Chronos.scheduleByName('ticketSync' .. name, 35, GMGenie.Tickets.syncMessage, name, 0);
            end
            GMGenie.Tickets.displaySync();
        else
            Chronos.scheduleByName('ticketSync' .. name, 35, GMGenie.Tickets.syncMessage, name, 0);
        end
    end
end

function GMGenie.Tickets.loadComment(comment)
    GMGenie.Tickets.currentTicket["comment"] = comment;
    GMGenie.Tickets.showMessage();
end

function GMGenie.Tickets.showMessage()
    GMGenie_Tickets_View_Ticket_Frame_Text:SetText(GMGenie.Tickets.currentTicket["message"]);
    GMGenie_Tickets_View_Comment:SetText(GMGenie.Tickets.currentTicket["comment"]);
end

function GMGenie.Tickets.close()
    if GMGenie.Spy.currentRequest["name"] == GMGenie.Tickets.currentTicket["name"] then
        GMGenie_Spy_InfoWindow:Hide();
    end
    SendAddonMessage("GMGenie_Sync", "0", "GUILD");
    Chronos.unscheduleRepeating('ticketSync');
    GMGenie_Tickets_View:Hide();
    GMGenie.Tickets.currentTicket = { ["num"] = 0, ["ticketId"] = 0, ['name'] = "" };
    if GMGenie_SavedVars.swapTicketWindows then
        GMGenie.Tickets.toggle();
    end
    GMGenie.Tickets.updateView();
end

-- read ticket
function GMGenie.Tickets.readTicket(ticketId, message)
    if GMGenie.Tickets.currentTicket["ticketId"] == ticketId then
        GMGenie.Tickets.currentTicket["message"] = message;
        GMGenie.Tickets.showMessage();
        return true;
    end
    return false;
end

-- set comment
function GMGenie.Tickets.comment(ticketId, comment)
    if GMGenie.Tickets.currentTicket["ticketId"] == ticketId then
        GMGenie.Tickets.currentTicket["comment"] = comment;
        GMGenie.Tickets.showMessage();
        return true;
    end
    return false;
end

--add line to ticket
function GMGenie.Tickets.addLine(message)
    GMGenie.Tickets.currentTicket["message"] = GMGenie.Tickets.currentTicket["message"] .. "\n" .. message;
    GMGenie.Tickets.showMessage();
end

function GMGenie.Tickets.delete()
    SendChatMessage(".ticket close " .. GMGenie.Tickets.currentTicket["ticketId"], "GUILD");
    SendChatMessage(".ticket del " .. GMGenie.Tickets.currentTicket["ticketId"], "GUILD");
    GMGenie.Tickets.done = GMGenie.Tickets.done + 1;
    GMGenie_SavedVars.ticketsDone = GMGenie.Tickets.done;
    local offlineCount = GMGenie.Tickets.tickets - GMGenie.Tickets.onlineTickets;
    GMGenie.Tickets.close();
    GMGenie.Tickets.refresh();
end

function GMGenie.Tickets.assignToSelf()
    SendChatMessage(".ticket assign " .. GMGenie.Tickets.currentTicket["ticketId"] .. " " .. UnitName("player"), "GUILD");
end

function GMGenie.Tickets.assign()
    GMGenie_Tickets_AssignPopup:Show();
    GMGenie_Tickets_AssignPopup_GMName:SetText("");
end

function GMGenie.Tickets.assignTo()
    GMGenie_Tickets_AssignPopup:Hide();
    SendChatMessage(".ticket assign " .. GMGenie.Tickets.currentTicket["ticketId"] .. " " .. GMGenie_Tickets_AssignPopup_GMName:GetText(), "GUILD");
end

function GMGenie.Tickets.unassign()
    SendChatMessage(".ticket unassign " .. GMGenie.Tickets.currentTicket["ticketId"], "GUILD");
end

function GMGenie.Tickets.setComment()
    SendChatMessage(".ticket comment " .. GMGenie.Tickets.currentTicket["ticketId"] .. " " .. GMGenie_Tickets_View_Comment:GetText(), "GUILD");
end

function GMGenie.Tickets.toggleSpy()
    if GMGenie_Spy_InfoWindow:IsVisible() and GMGenie.Tickets.currentTicket["name"] == GMGenie.Spy.currentRequest["name"] then
        GMGenie_Spy_InfoWindow:Hide();
    else
        GMGenie.Spy.spy(GMGenie.Tickets.currentTicket["name"]);
    end
end

-- add slash command to open.close ticket widnow
SLASH_TICKETS1 = "/tickets";
SlashCmdList["TICKETS"] = GMGenie.Tickets.toggle;

local frame = CreateFrame("FRAME");
frame:RegisterEvent("CHAT_MSG_ADDON");

function frame:OnEvent(event, arg1)
    if event == "CHAT_MSG_ADDON" and (arg1 == "GMGenie_TicketSync" or arg1 == "GMGenie_Sync") then
        GMGenie.Tickets.syncMessage(arg4, arg2);
    end
end

frame:SetScript("OnEvent", frame.OnEvent);