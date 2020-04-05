--[[
	Auctioneer
	Version: 5.7.4568 (KillerKoala)
	Revision: $Id: CoreConst.lua 4553 2009-12-02 21:22:13Z Nechckn $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds statistical history to the auction data that is collected
	when the auction is scanned, so that you can easily determine what price
	you will be able to sell an item for at auction or at a vendor whenever you
	mouse-over an item in the game

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
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
if not AucAdvanced then return end

AucAdvanced.Const = {
	AucMinTimes = {
		0,
		1800, -- 30 mins
		7200, -- 2 hours
		43200, -- 12 hours
	},
	AucMaxTimes = {
		1800,  -- 30 mins
		7200,  -- 2 hours
		28800, -- 12 hours
		172800 -- 48 hours
	},
	AucTimes = {
		0,
		1800, -- 30 mins
		7200, -- 2 hours
		28800, -- 12 hours
		172800 -- 48 hours
	},
	
	InvTypes = {
		INVTYPE_HEAD = 1,
		INVTYPE_NECK = 2,
		INVTYPE_SHOULDER = 3,
		INVTYPE_BODY = 4,
		INVTYPE_CHEST = 5,
		INVTYPE_WAIST = 6,
		INVTYPE_LEGS = 7,
		INVTYPE_FEET = 8,
		INVTYPE_WRIST = 9,
		INVTYPE_HAND = 10,
		INVTYPE_FINGER = 11,
		INVTYPE_TRINKET = 12,
		INVTYPE_WEAPON = 13,
		INVTYPE_SHIELD = 14,
		INVTYPE_RANGEDRIGHT = 15,
		INVTYPE_CLOAK = 16,
		INVTYPE_2HWEAPON = 17,
		INVTYPE_BAG = 18,
		INVTYPE_TABARD = 19,
		INVTYPE_ROBE = 20,
		INVTYPE_WEAPONMAINHAND = 21,
		INVTYPE_WEAPONOFFHAND = 22,
		INVTYPE_HOLDABLE = 23,
		INVTYPE_AMMO = 24,
		INVTYPE_THROWN = 25,
		INVTYPE_RANGED = 26,
	},
	LINK = 1,
	ILEVEL = 2,
	ITYPE = 3,
	ISUB = 4,
	IEQUIP = 5,
	PRICE = 6,
	TLEFT = 7,
	TIME = 8,
	NAME = 9,
	TEXTURE = 10,
	COUNT = 11,
	QUALITY = 12,
	CANUSE = 13,
	ULEVEL = 14,
	MINBID = 15,
	MININC = 16,
	BUYOUT = 17,
	CURBID = 18,
	AMHIGH = 19,
	SELLER = 20,
	FLAG = 21,
	ID = 22,
	ITEMID = 23,
	SUFFIX = 24,
	FACTOR = 25,
	ENCHANT = 26,
	SEED = 27,

	FLAG_DIRTY = 1,
	FLAG_UNSEEN = 2,
	FLAG_FILTER = 4,

	CLASSES = { GetAuctionItemClasses() },
	SUBCLASSES = { },
	CLASSESREV = { }, -- Table mapping names to index in CLASSES table
	SUBCLASSESREV = { }, -- Table mapping from CLASS and SUBCLASSES names to index number in SUBCLASSES
}

for i = 1, #AucAdvanced.Const.CLASSES do
	AucAdvanced.Const.CLASSESREV[AucAdvanced.Const.CLASSES[i]] = i
	AucAdvanced.Const.SUBCLASSESREV[AucAdvanced.Const.CLASSES[i]] = {}
	AucAdvanced.Const.SUBCLASSES[i] = { GetAuctionItemSubClasses(i) }
	for j = 1, #AucAdvanced.Const.SUBCLASSES[i] do
		AucAdvanced.Const.SUBCLASSESREV[AucAdvanced.Const.CLASSES[i]][AucAdvanced.Const.SUBCLASSES[i][j]] = j	
	end
end

AucAdvanced.Defaults = {
	Scanner = "Simple",
}

AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.7/Auc-Advanced/CoreConst.lua $", "$Rev: 4553 $")
