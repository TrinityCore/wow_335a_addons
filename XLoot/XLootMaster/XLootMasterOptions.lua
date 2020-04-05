local L = AceLibrary("AceLocale-2.2"):new("XLootMaster")

local hcolor = "|cFF77BBFF"
local specialmenu = "|cFF44EE66"

function XLootMaster:DoOptions() 
	local db = self.db.profile
	local announce = { "|cffff0000"..L["Never"].."|r" }
	for k, v in ipairs(XLoot.opts_qualitykeys) do
		announce[k+1] = v
	end
	XLootMaster.announcevalue = function(key) if key == 1 then return 'never' else return key - 2 end end
	XLoot.opts.args.master = {
		type = "group",
		name = "|cFF44EE66"..L["XLoot Master"],
		icon = "Interface\\GossipFrame\\BankerGossipIcon",
		desc = L["XLoot Master plugin, replacement for the standard Master Looter dropdown."],
		args = {
			mlheader = {
				type = "header",
				icon = "Interface\\GossipFrame\\BankerGossipIcon",
				name = hcolor.."XLoot Master".."  |c88888888"..self.revision,
				order = 1,
			},
			mlitemtip = {
				type = "toggle",
				name = L["Item tooltip"],
				desc = L["Show a tooltip for the ML item when mousing over it."],
				get = function() return db.mlitemtip end,
				set = function(v) db.mlitemtip = v end,
				order = 5
			},
			mlplayertip = {
				type = "toggle",
				name = L["Player tooltip"],
				desc = L["Show a tooltip for each player when mousing over them."],
				get = function() return db.mlplayertip end,
				set = function(v) db.mlplayertip = v end,
				order = 15
			},
			mldkp = {
				type = "toggle",
				disabled = true,
				name = L["Value utilities"],
				desc = L["Various tools such as tracking dkp assignments, broadcasting value along with assignment, and such. |cffff0000Doesn't do much yet.|r"],
				get = function() return db.mldkp end,
				set = function(v) db.mldkp = v end,
				order = 19
			},
			mlannounceself = {
				type = "toggle",
				name = L["Announce self-loot"],
				desc = L["Announce self-looted items"],
				get = function() return db.announceself end,
				set = function(v) db.announceself = v end,
				order = 19
			},
			mlannouncetext = {
				type = "text",
				name = L["Awarded item text"],
				desc = L["Default: |cffff0000[name] awarded [item][method]|r\n[name] is replaced with the name of the player, \n[item] with the item link, \n[method] with any special note (dkp, random), if it exists, eg: ' (Random)'."],
				usage = L["A string containing any of [range], [item], or [time]"],
				get = function() return db.announcemsg end,
				set = function(v) db.announcemsg = v end,
				order = 20
			},
			mlspacer2 = {
				type = "header",
				order = 21
			},
			mlannounceheader = {
				type = "header", 
				name = hcolor..L["Thresholds"],
				order = 22
			},
			mlthreshold = {
				type = "text",
				name = L["Confirmation threshold"],
				desc = L["The lowest quality of item to open the assignment confirmation window for."],
				get = function() return XLoot.opts_qualitykeys[db.mlthreshold+1] end,
				set = function(v) db.mlthreshold = XLoot:optGetKey(XLoot.opts_qualitykeys, v) - 1 end,
				validate = XLoot.opts_qualitykeys,
				order = 23
			},
			mldkpthreshold = {
				type = "text",
				disabled = true,
				name = L["Item value threshold"],
				desc = L["The lowest quality of item to open the assignment |cFF22EE22and value|r confirmation window for."],
				get = function() return XLoot.opts_qualitykeys[db.mldkpthreshold+1] end,
				set = function(v) db.mldkpthreshold = XLoot:optGetKey(XLoot.opts_qualitykeys, v) - 1 end,
				validate = XLoot.opts_qualitykeys,
				order = 24
			},
			group = {
				type = "text", 
				name = L["Announce to group..."],
				desc  = L["Announce to group..."],
				get = function() return announce[db.announce.group] end,
				set = function(v) db.announce.group = XLoot:optGetKey(announce, v) end,
				validate = announce,
				order = 25
			},
			rw = {
				type = "text", 
				name = L["Announce to /rw..."],
				desc  = L["Announce to /rw..."],
				get = function() return announce[db.announce.rw] end,
				set = function(v) db.announce.rw = XLoot:optGetKey(announce, v) end,
				validate = announce,
				order = 26
			},
			guild = {
				type = "text", 
				name = L["Announce to guild..."],
				desc = L["Announce to guild..."],
				get = function() return announce[db.announce.guild] end,
				set = function(v) db.announce.guild = XLoot:optGetKey(announce, v) end,
				validate = announce,
				order = 27
			},
			mlrandomspacer = {
				type = "header",
				order = 28
			},
			mlrandomheader = {
				type = "header",
				name = hcolor..L["Randomization"],
				order = 29
			},
			mlrandom = {
				type = "toggle",
				name = L["Random menu"],
				desc = L["Show the Random menu for loot distribution."],
				get = function() return db.mlrandom end,
				set = function(v) db.mlrandom = v end,
				order = 30
			},
			mlrolls = {
				type = "toggle",
				name = L["Capture /rolls"],
				desc = L["Capture party member /roll #'s"],
				get = function() return db.mlrolls end,
				set = function(v) db.mlrolls = v; self:RollHook() end,
				order = 35
			},
			mlshowall = {
				type = "toggle",
				disabled = not db.mlrolls,
				name = L["Show all rolls"],
				desc = L["If enabled, show all rolls during a request, even ones not matching set range."],
				get = function() return db.mlallrolls end,
				set = function(v) db.mlallrolls = v end,
				order = 40
			},
			mlrolltimeout = {
				type = "range",
				name = L["Roll timeout"],
				desc = L["Length of time to capture rolls"],
				get = function() return db.rolltimeout end,
				set = function(v) db.rolltimeout = v end,
				min = 10,
				max = 120,
				step = 5,
				order = 45
			},
			mlrollrange = {
				type = "range",
				name = L["Roll range"],
				desc = L["Range to request players to roll in"],
				get = function() return db.rollrange end,
				set = function(v) db.rollrange = v end,
				min = 50,
				max = 1000,
				step = 50,
				order = 50
			},
			mlrolltext = {
				type = "text",
				name = L["Roll request text"],
				desc = L["Default: |cffff0000Attention! Please /roll [range] for [item]. Ends in [time] seconds.|r\n[range] is replaced with the range you pick, \n[item] with the item link, \n[time] with seconds in countdown."],
				usage = L["A string containing any of [range], [item], or [time]"],
				get = function() return db.rollmsg end,
				set = function(v) db.rollmsg = v end,
				order = 55
			},
		},
		order = 87,
	}
	
	StaticPopupDialogs["CONFIRM_XLOOT_DKP_DISTRIBUTION"] = {
		text = TEXT(CONFIRM_LOOT_DISTRIBUTION..L[" Please enter the value of the item."]),
		button1 = TEXT(ACCEPT),
		button2 = TEXT(CANCEL),
		hasEditBox = 1,
		maxLetters = 12,
		OnAccept = function(self,data)
			local editBox = getglobal(self:GetParent():GetName().."EditBox");
			local text = editBox:GetText()
			if string.len(text) > 0 then data.method = "Value: "..text end
			data.value = text
			XLootMaster:AnnounceDistribution(data)
			GiveMasterLoot(LootFrame.selectedSlot, data.id);
		end,
		OnShow = function(self)
			getglobal(self:GetName().."EditBox"):SetFocus();
		end,
		OnHide = function(self)
			if ( ChatFrameEditBox:IsVisible() ) then
				ChatFrameEditBox:SetFocus();
			end
			getglobal(self:GetName().."EditBox"):SetText("");
		end,
		EditBoxOnEnterPressed = function(self)
			--local editBox = getglobal(self:GetParent():GetName().."EditBox")
			local text = self:GetText() --editBox:GetText()
			if string.len(text) > 0 then data.method = L["Value: "]..text end
			data.value = text
			GiveMasterLoot(LootFrame.selectedSlot, data.id)
			XLootMaster:AnnounceDistribution(data)
			self:GetParent():Hide();
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		timeout = 0,
		hideOnEscape = 1,
	}
	
	StaticPopupDialogs["CONFIRM_XLOOT_DISTRIBUTION"] = {
		text = TEXT(CONFIRM_LOOT_DISTRIBUTION),
		button1 = TEXT(YES),
		button2 = TEXT(NO),
		OnAccept = function(self,data)
			XLootMaster:AnnounceDistribution(data)
			GiveMasterLoot(LootFrame.selectedSlot, data.id);
		end,
		timeout = 0,
		hideOnEscape = 1,
	}
end