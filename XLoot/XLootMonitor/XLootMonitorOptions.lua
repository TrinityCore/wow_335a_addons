local L = AceLibrary("AceLocale-2.2"):new("XLootMonitor")
local XL = AceLibrary("AceLocale-2.2"):new("XLoot")

local _G = getfenv(0)

local hcolor = "|cFF77BBFF"
local specialmenu = "|cFF44EE66"

function XLootMonitor:DoOptions()
	local db = self.db.profile

	self.opts = {
		header = {
			type = "header",
			icon = "Interface\\GossipFrame\\VendorGossipIcon",
			iconWidth = 24,
			iconHeight = 24,
			name = hcolor..L["optMonitor"].."  |c88888888"..self.revision,
			order = 1
		},
		lock = {
			type = "toggle",
			name = L["optLockAll"],
			desc = L["optLockAll"],
			get = function()
				return db.lock
				end,
			set = function(v)
				db.lock = v
				end,
			order = 2
		},
		options = {
			type = "execute",
			name = XL["optOptions"],
			desc = XL["descOptions"],
			func = function() self:OpenMenu(UIParent) end,
			order = 100,
			guiHidden = true
		},
		mspacer = {
			type = "header",
			order = 3
		},
		display = {
			type = "group",
			name = "|cFF44EE66"..L["Display Options"],
			desc = "|cFF44EE66"..L["Display Options"],
			args = { },
			order = 10
		},
		qualitythreshold = {
			type = "text",
			name = L["optQualThreshold"],
			desc = L["descQualThreshold"],
			get = function() return XLoot.opts_qualitykeys[db.qualitythreshold+1] end,
			set = function(v) db.qualitythreshold = XLoot:optGetKey(XLoot.opts_qualitykeys, v) - 1 end,
			validate = XLoot.opts_qualitykeys,
			order = 15
		},
		selfqualitythreshold = {
			type = "text",
			name = L["optSelfQualThreshold"],
			desc = L["descSelfQualThreshold"],
			get = function() return XLoot.opts_qualitykeys[db.selfqualitythreshold+1] end,
			set = function(v) db.selfqualitythreshold = XLoot:optGetKey(XLoot.opts_qualitykeys, v) - 1 end,
			validate = XLoot.opts_qualitykeys,
			order = 16
		},
		money = {
			type = "toggle",
			name = L["optMoney"],
			desc = L["descMoney"],
			set = function(v) db.money = v end,
			get = function() return db.money end,
			order = 17,
		},
		rollchoices = {
			type = "toggle",
			name = L["Show group roll choices"],
			desc = L["Show group roll choices"],
			set = function(v) db.rollchoices = v end,
			get = function() return db.rollchoices end,
			order = 18
		},
		rollwins = {
			type = "toggle",
			name = L["Show winning group loot"],
			desc = L["Show winning group loot"],
			set = function(v) db.rollwins = v end,
			get = function() return db.rollwins end,
			order = 19
		},
		yourtotals = {
			type = "toggle",
			name = L["Show totals of your items"],
			desc = L["Show totals of your items"],
			set = function(v) db.yourtotals = v end,
			get = function() return db.yourtotals end,
			order = 20,
		},
		modulespacer = {
			type = "header",
			order = 70,
		},
		moduleheader = {
			type = "header",
			name = hcolor..L["catModules"],
			icon = "Interface\\GossipFrame\\TaxiGossipIcon",
			order = 71,
		},
		history = {
			type = "execute",
			name = specialmenu..L["moduleHistory"],
			desc = specialmenu..L["moduleHistory"],
			icon = "Interface\\GossipFrame\\TrainerGossipIcon",
			func = function() 
							self.dewdrop:Open(UIParent,
							'children', function(level, value, valueN_1, valueN_2, valueN_3, valueN_4) self:BuildHistory(level, value) end,
							'cursorX', true,
							'cursorY', true
						)
			end,
			order = 75,
		},
		
		historycustom = {
			type = "group",
			name = specialmenu..L["History custom export"],
			desc = specialmenu..L["History custom export"],
			args = {
				item = {
					type =  "text",
					name = L["Item lines"],
					desc = L["The format of each item record"],
					usage = L["\n[time] - timestamp\n[ftime] - formatted time (24-hour)\n[name] - item name\n[id] - item id\n[count] - number of the item recieved\n[player] - name of the recipient\n[class] - class of the player"],
					get = function() return db.history.customitem end,
					set = function(v) db.history.customitem = v end,
					order = 1
				},
				money = { 
					type = "text", 
					name = L["Gold lines"],
					desc = L["The format of each gold record"],
					usage = L["\n[time] - timestamp\n[ftime] - formatted time\n[count] - the amount of copper recieved\n[fcount] - labeled gold/silver/copper amount"],
					get = function() return db.history.customcoin end,
					set = function(v) db.history.customcoin = v end,
					order = 5
				}
			},
			order = 80
		},
		
		xlootspacer = {
			type = "header",
			order = 90
		},
		xlootoptions =  {
			name = specialmenu..XL["guiTitle"],
			desc = specialmenu..XL["guiTitle"],
			icon = "Interface\\GossipFrame\\BinderGossipIcon",
			desc = XL["guiTitle"],
			type = "execute",
			order = 95,
			func = function() XLoot:OpenMenu(UIParent) end
		},
	}

	if not XLoot.opts.args.pluginspacer then
		XLoot.opts.args.pluginspacer = {
			type = "header",
			order = 85
		}
	end
	
	XLoot.opts.args.monitor =  {
		name = specialmenu..L["optMonitor"],
		desc = L["descMonitor"],
		icon = "Interface\\GossipFrame\\BinderGossipIcon",
		type = "group",
		order = 86,
		args = self.opts
	}

	XLoot.opts.args.history = {
		type = "execute",
		name = specialmenu..L["moduleHistory"],
		desc = specialmenu..L["moduleHistory"],
		icon = "Interface\\GossipFrame\\TrainerGossipIcon",
		func = function() 
						self.dewdrop:Open(UIParent,
						'children', function(level, value, valueN_1, valueN_2, valueN_3, valueN_4) self:BuildHistory(level, value) end,
						'cursorX', true,
						'cursorY', true
					)
		end,
		order = 87,
	}

	self.fullopts = { type = "group", args = self.opts }
	self:RegisterChatCommand({ "/xlm", "/xlootmonitor" }, self.fullopts)
end

function XLootMonitor:AddTestItem(title, func)
	if not self.testfuncs then self.testfuncs = { func }
	else table.insert(self.testfuncs, func) end
	if not self.opts.advanced then 
		self.opts.advanced = {
			type = "group",
			name = "|c77AAAAAA"..XL["optAdvanced"],
			desc = XL["descAdvanced"],
			args = { },
			order = 20
		}
	end
	if not self.opts.advanced.args.test then 
		self.opts.advanced.args.test = {
			type = "group",
			name = "|cFFFF5522Test handlers",
			desc = "If you're using this, kill yourself now <3.",
			args = { },
			order = 1
		}
	end
	if not self.opts.advanced.args.autotest then
		self.opts.advanced.args.autotest = {
			type = "toggle",
			name = "|cFFFF5522Stress-test handlers",
			desc = "If you're using this, you're most likely profiling. Again, kill yourself now. <3. Also. |cFFFF0000This WILL lag you out for a few moments.|r",
			set = function() 
								for it = 1, 25 do
									for key, func in ipairs(self.testfuncs) do
										func()
									end
								end
							end,
			get = function() end,
		}
	end
	if not self.opts.advanced.args.test.args[title] then
		self.opts.advanced.args.test.args[title] = {
			type = "toggle",
			name = title,
			desc = title,
			set = func,
			get = function() return false end,
		}
	end
end