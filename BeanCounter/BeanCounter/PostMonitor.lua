--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: 5.7.4568 (KillerKoala)
	Revision: $Id: PostMonitor.lua 4496 2009-10-08 22:15:46Z Nechckn $
	URL: http://auctioneeraddon.com/

	PostMonitor - Records items posted up for auction

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
LibStub("LibRevision"):Set("$URL: http://svn.norganna.org/auctioneer/branches/5.7/BeanCounter/PostMonitor.lua $","$Rev: 4496 $","5.1.DEV.", 'auctioneer', 'libs')

--[[Most of this code is from BC classic]]--
local libName = "BeanCounter"
local libType = "Util"
local lib = BeanCounter
local private, print, get, set, _BC = lib.getLocals()

local function debugPrint(...)
    if get("util.beancounter.debugPost") then
        private.debugPrint("PostMonitor",...)
    end
end

-------------------------------------------------------------------------------
-- Called before StartAuction()
-------------------------------------------------------------------------------
function private.preStartAuctionHook(_, _, minBid, buyoutPrice, runTime)
	
	local name, texture, count, quality, canUse, price = GetAuctionSellItemInfo()
	--debugPrint("1",minBid, buyoutPrice,"Prehook Fired, starting auction creation", name)
	
	if (name and count and price) then
		--Look in the bags find the locked item so we can get the itemlink
		local itemLink
		for bagID = 0, 4 do
			local bagSlots = GetContainerNumSlots(bagID)
			for  slot = 1, bagSlots do
				local  _, _, locked, _, _ = GetContainerItemInfo(bagID, slot)
				if locked then
					itemLink = GetContainerItemLink(bagID, slot)
				end
			end
		end
				
		local deposit = CalculateAuctionDeposit(runTime)
		private.addPendingPost(itemLink, name, count, minBid, buyoutPrice, runTime, deposit)
	end
end

-------------------------------------------------------------------------------
-- Adds a pending post to the queue.
-------------------------------------------------------------------------------
function private.addPendingPost(itemLink, name, count, minBid, buyoutPrice, runTime, deposit)
	-- Add a pending post to the queue.
	local pendingPost = {}
	pendingPost.itemLink = itemLink
	pendingPost.name = name
	pendingPost.count = count
	pendingPost.minBid = minBid
	pendingPost.buyoutPrice = buyoutPrice
	pendingPost.runTime = runTime
	pendingPost.deposit = deposit
	table.insert(private.PendingPosts, pendingPost)
	--debugPrint("2",minBid, buyoutPrice, "private.addPendingPost() - Added pending post", itemLink)

	-- Register for the response events if this is the first pending post.
	if (#private.PendingPosts == 1) then
		private.postEventFrame:RegisterEvent("CHAT_MSG_SYSTEM")
		private.postEventFrame:RegisterEvent("UI_ERROR_MESSAGE")
	end
end

-------------------------------------------------------------------------------
-- Removes the pending post from the queue.
-------------------------------------------------------------------------------
function private.removePendingPost()
	if (#private.PendingPosts > 0) then
		-- Remove the first pending post.
		local post = private.PendingPosts[1]
		table.remove(private.PendingPosts, 1)
		
		-- Unregister for the response events if this is the last pending post.
		if (#private.PendingPosts == 0) then
			private.postEventFrame:UnregisterEvent("CHAT_MSG_SYSTEM")
			private.postEventFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		end

		return post
	end

	-- No pending post to remove!
	return nil
end

-------------------------------------------------------------------------------
-- Called when a post is accepted by the server.
-------------------------------------------------------------------------------
function private.onAuctionCreated()
	local post = private.removePendingPost()
	-- Add to sales database
	if post and post.itemLink then
		local itemID = lib.API.decodeLink(post.itemLink)
		local text = private.packString(post.count, post.minBid, post.buyoutPrice, post.runTime, post.deposit, time(),"")
		
		private.databaseAdd("postedAuctions", post.itemLink, nil, text)
		
		--debugPrint("3", post.minBid, post.buyoutPrice, #private.PendingPosts,  "Added", post.itemLink, "to the postedAuctions DB")
	elseif post and not post.itemLink then
		debugPrint("ItemLink failure for teh following auction.")
		debugPrint(post.name, post.count, post.minBid, post.buyoutPrice, post.runTime, post.deposit)
	end
end

-------------------------------------------------------------------------------
-- Called when a post is rejected by the server.
-------------------------------------------------------------------------------
function private.onPostFailed()
	private.removePendingPost()
end

-------------------------------------------------------------------------------
-- Use event scripts instead of function hooks to know when a auction has been accepted
-- OnEvent handler these are unhooked when not needed
-------------------------------------------------------------------------------
function private.postEvent(_, event, message)
	if event == "CHAT_MSG_SYSTEM" and message == ERR_AUCTION_STARTED and private.PendingPosts then
		private.onAuctionCreated()
	elseif event == "UI_ERROR_MESSAGE" and message == ERR_NOT_ENOUGH_MONEY then
		private.onPostFailed()
	end
end
private.postEventFrame = CreateFrame("Frame")
private.postEventFrame:SetScript("OnEvent", private.postEvent)

