--[[

Last modified by eddie2 @ 2010-07-25T17:38:29Z

--]]
local L = LibStub("AceLocale-3.0"):GetLocale("Magnet", true)
local Magnet = LibStub("AceAddon-3.0"):GetAddon("Magnet")

local options = {
		type = "group",
		name = "Magnet",
		childGroups = "tab",
		get = function(info)
			return Magnet.db.char[info[#info]]
		end,
		set = function(info, value)
			Magnet.db.char[info[#info]] = value
		end,
		args = {   
			config = {
				type = "execute",
				name = L["Open GUI"],
				desc = L["Opens the configuration panel"],
				guiHidden = true,
				func = function()
					InterfaceOptionsFrame:Hide()
					LibStub("AceConfigDialog-3.0"):SetDefaultSize("Magnet", 620, 660)
					LibStub("AceConfigDialog-3.0"):Open("Magnet")
				end
			},
		   logo = {
		      order = 1,
		      type = "description",
		      name = "",
		      image = [[Interface\Addons\Magnet\magnet]],
		      imageWidth = 256,
		      imageHeight = 128,
		      imageCoords = { 0, 1, 0, 1 },
		   },
		   s1 = {
		      order = 2,
		      type = 'header',
		      name = L["Magnet options"],
		      cmdHidden = true
		   },
		   general = {
			   type = "group",
		   	name = L["General"],
		   	order = 3,
		   	args = {
					verbose = {
						order = 1,
						type = 'toggle',
						width = "full",
						name = L["Show verbose messages in the chat frame"],
						desc = L["Prints detailed messages in the chat frame if, what, when and why it loots"],
						get = function() return Magnet.db.char.verbose end,
						set = function(info,v) 
							if(v) then 
								Magnet:Print("Verbose output enabled")
							else
								Magnet:Print("Verbose output disabled")
							end  
							Magnet.db.char.verbose = v 
						end
					},
				   enable = {
						name = L["Enable"],
						desc = L["Enable Magnet"],
						order = 2,
						type = "toggle",
						set = function(info,val)
							if(val) then
								Magnet:Enable()
							else
								Magnet:Disable()
							end
						end,
						get = function() return Magnet:IsEnabled() end,
					},
					attractList = {
						order = 3,
						type = 'execute',
						name = L["Show attract list"],
						desc = L["Shows the list of current items to attract"],
						guiHidden = true,
						get = function()
							local tempList = Magnet.db.char.items
							for item in pairs(tempList) do
								if(not tempList[item]) then tempList[item] = nil end
							end
							return tempList
						end,
						func = function()
							Magnet:Print(L["Attract list"]..":")
							for item in pairs(Magnet.db.char.items) do
								if (Magnet.db.char.items[item] == true) then Magnet:Print(item) end
							end
						end
					},
					repelList = {
						order = 4,
						type = 'execute',
						name = L["Show repel list"],
						desc = L["Shows the list of current items to repel"],
						guiHidden = true,
						get = function()
							local tempList = Magnet.db.char.items
							for item in pairs(tempList) do
								if(tempList[item]) then tempList[item] = nil end
							end
							return tempList
						end,
						func = function()
							Magnet:Print(L["Repel list"]..":")
							for item in pairs(Magnet.db.char.items) do
								if (Magnet.db.char.items[item] == false) then Magnet:Print(item) end
							end
						end
					},
					clear = {
						order = 4,
						type = 'execute',
						name = L["Clear item list"],
						desc = L["Will clear the list of current items to search and autoloot for. THIS IS NOT UNDOABLE."],
						func = function() Magnet.db.char.items = {}; Magnet:Print(L["Magnet list cleared. It's empty now."]) end
					},
					autoClose = {
						order = 6,
						type = 'toggle',
						name = L["Auto close loot window"],
						width = "full",
						desc = L["Automatically closes the loot window when there are no more worthy loots"],
					},
					autoClearList = {
						order = 7,
						type = 'toggle',
						name = L["Auto clear list"],
						desc = L["Automatically removes an item from the attract/repel list if that item is attracted/repelled by quality."],
					},
					lootGold = {
						order = 8,
						type = 'toggle',
						name = L["Attract money"],
						desc = L["Attract money"],
					},
					lootQuest = {
						order = 9,
						type = 'toggle',
						name = L["Attract quest items"],
						desc = L["Attracts items if you are on a quest that requires it."],
					},
					autoConfirmBoP = {
				  		order = 10,
						type = 'toggle',
						name = "Auto confirm Bind on Pickup items",
						width = "full",
						desc = "Confirm Bind on Pickup items automatically (only when Magnet is looting the item)",
					},
					showToolTipInfo = {
				  		order = 11,
						type = 'toggle',
						name = "Show tooltip information",
						desc = "Show information in the tooltip if the item is attracted/repelled",
					},
					farmMode = {
				  		order = 12,
						type = 'toggle',
						name = "Enable farm mode",
						desc = "Farm mode loots all items. Afterwards, your bags are scannd and anything that should be repelled is destroyed",
					},
					group1 = {
						name = "Skills",
						desc = "Attract all items when performing a tradeskill or gathering skill.",
						type = "group",
						inline = true,
						order = 13,
						args = {
							attractFishLoot = {
								order = 1,
								type = 'toggle',
								name = "Fishing",
								desc = L["Automatically attract fishing loot. Overrides any repel settings!"],
							},
							attractMining = {
								order = 2,
								type = 'toggle',
								name = "Mining",
								desc = "Attracts mined items",		
							},
							attractProspecting = {
								order = 3,
								type = 'toggle',
								name = "Prospecting",
								desc = "Attracts prospected items",		
							},
							attractGathering = {
								order = 4,
								type = 'toggle',
								name = "Herbalism",
								desc = "Attracts items gathered from Herbalism",		
							},
							attractDisenchant = {
								order = 5,
								type = 'toggle',
								name = "Disenchant",
								desc = "Attracts disenchanted items",
							},
							attractMilling = {
								order = 6,
								type = 'toggle',
								name = "Milling",
								desc = "Attracts milled items",
							}, 
							attractSkinning = {
								order = 7,
								type = 'toggle',
								name = "Skinning",
								desc = "Attracts skinned items",
							},
							attractPickPocket = {
								order = 8,
								type = 'toggle',
								name = "Pick Pocket",
								desc = "Attracts pick pocketed items",
								disabled = function() local _, englishClass = UnitClass("player"); return englishClass ~= "ROGUE"; end,
							},
							attractEngineering = {
								order = 9,
								type = 'toggle',
								name = "Engineering",
								desc = "Attracts salvaged",
							},
                            useSkillMode = {
								order = 10,
								type = 'toggle',
								name = "Skillmode",
								desc = "Attracts all items when you can use a tradeskill on the creature (such as skinning and mining)",
							},
						},
					},	
					attractReagents = {
						order = 14,
						disabled = false,
						type = 'toggle',
						set = function(info, value) Magnet.db.char.attractReagents = value; Magnet:UpdateIngredientsCache(); end,
						name = "Attract reagents",
						desc = "Attracts items that are needed for tradeskills",	
					},				  
					reagentThreshold = {
						order = 15,
						type = 'range',
						name = "Reagent threshold",
						desc = "Tradeskill difficulty threshold",
						min = 0,
						max = 4,
						step = 1,
						set = function(info, value) Magnet.db.char.reagentThreshold = value; Magnet:UpdateIngredientsCache(); end,
						disabled = function() return not Magnet.db.char.attractReagents end,
					},				
					minimumPrice = {
						order = 16,
						type = 'toggle',
						name = "Use minimum price filter",
						desc = "Attracts any item above the minimum price (overrides repel settings)",
						width = "full"
					},
					useStackPrice = {
						order = 17,
						type = 'toggle',
						name = "Use stack prices",
						desc = "Use stack prices for the price filter",
						disabled = function() return not Magnet.db.char.minimumPrice end,
						
					}, 
					gold = {
						order = 18,
						disabled = function() return not Magnet.db.char.minimumPrice end,
						type = 'input',
						name = "Gold",
						desc = "Amount of gold",
						width = "half",
						validate = function(info, value) return value ~= nil and tonumber(value) >= 0 end,
						get = function() return Magnet.db.char.gold end,
						set = function(info, value) Magnet.db.char.gold = value end
					},
					silver = {
						order = 19,
						disabled = function() return not Magnet.db.char.minimumPrice end,
						type = 'input',
						name = "Silver",
						desc = "Amount of silver",
						width = "half",
						validate = function(info, value) return value ~= nil and tonumber(value) >= 0 and tonumber(value) < 100 end,
						get = function() return Magnet.db.char.silver end,
						set = function(info, value) Magnet.db.char.silver = value end
					},
					copper = {
						order = 20,
						disabled = function() return not Magnet.db.char.minimumPrice end,
						type = 'input',
						name = "Copper",
						desc = "Amount of copper",
						width = "half",
						validate = function(info, value) return value ~= nil and tonumber(value) >= 0 and tonumber(value) < 100 end,
						get = function() return Magnet.db.char.copper end,
						set = function(info, value) Magnet.db.char.copper = value end
					},
				},
			},
            itemList = {
                type = "group",
                name = "Items",
                order = 9,
                args = {
                    attractListRemove = {
                        order = 1,
                        type = "select",
                        name = "Attracting",
                        desc = "Select an item to remove it from the attract list",
                        style = "dropdown",
                        width = "full",
                        values = function()
							local tempList = {}
							for item in pairs(Magnet.db.char.items) do
								if(Magnet.db.char.items[item]) then tempList[item] = item end
							end
							return tempList
						end,                        
                        set = function(info,key,v)
                            Magnet:Print(("Removed %s"):format(key)) 
                            Magnet.db.char.items[key] = nil
                        end,
                        get = function() return false end,
                    },
                    
                    repelListRemove = {
                        order = 2,
                        type = "select",
                        name = "Repelling",
                        desc = "Select an item to remove it from the repel list",
                        style = "dropdown",
                        width = "full",
                        values = function()
							local tempList = {}
							for item in pairs(Magnet.db.char.items) do
								if(not Magnet.db.char.items[item]) then tempList[item] = item end
							end
							return tempList
						end,                        
                        set = function(info,key,v)
                            Magnet:Print(("Removed %s"):format(key)) 
                            Magnet.db.char.items[key] = nil 
                        end,
                        get = function() return false end,
                    },
                },
            },
			solo = {
				type = "group",
				name = L["Solo options"],
				order = 9,
				args = {
					lootQuality = {
						order = 1,
						type = "multiselect",
						name = L["Attract by item quality"],
						desc = L["Attract items by their quality"],
						values = Magnet.constants.qualityOptions,
						get = function(info,key) return Magnet.db.char.lootQuality[key] end,
						set = function(info,key,v) Magnet:SetLootQuality(key,v, 's') end,
					},
					lootQualityRepel = {
						order = 2,
						type = "multiselect",
						name = L["Repel by item quality"],
						desc = L["Repel items by their quality"],
						values = Magnet.constants.qualityOptions,
						get = function(info,key) return Magnet.db.char.lootQualityRepel[key] end,
						set = function(info,key,v) Magnet:SetLootQualityRepel(key,v, 's') end,
					},
				},
			},
		   party = {
		   	type = "group",
		   	name = L["Party options"],
		   	order = 10,
				args = {
					lootQuality = {
						order = 1,
						type = "multiselect",
						name = L["Attract by item quality"],
						desc = L["Attract items by their quality"],
						values = Magnet.constants.qualityOptions,
						get = function(info,key) return Magnet.db.char.party.lootQuality[key] end,
						set = function(info,key,v) Magnet:SetLootQuality(key,v, 'p') end,
					},
					lootQualityRepel = {
						order = 2,
						type = "multiselect",
						name = L["Repel by item quality"],
						desc = L["Repel items by their quality"],
						values = Magnet.constants.qualityOptions,
						get = function(info,key) return Magnet.db.char.party.lootQualityRepel[key] end,
						set = function(info,key,v) Magnet:SetLootQualityRepel(key,v, 'p') end,
					}, 		
				},
		   },
		   raid = {
		   	type = "group",
		   	name = L["Raid options"],
		   	order = 11,
				args = {
					lootQuality = {
						order = 1,
						type = "multiselect",
						name = L["Attract by item quality"],
						desc = L["Attract items by their quality"],
						values = Magnet.constants.qualityOptions,
						get = function(info,key) return Magnet.db.char.raid.lootQuality[key] end,
						set = function(info,key,v) Magnet:SetLootQuality(key,v, 'r') end,
					},
					lootQualityRepel = {
						order = 2,
						type = "multiselect",
						name = L["Repel by item quality"],
						desc = L["Repel items by their quality"],
						values = Magnet.constants.qualityOptions,
						get = function(info,key) return Magnet.db.char.raid.lootQualityRepel[key] end,
						set = function(info,key,v) Magnet:SetLootQualityRepel(key,v, 'r') end,
					}, 		
				},
		   },
		   repel = {
		      order = 10,
		      type = 'input',
		      name = L["Repel item"],
		      desc = L["Adds a new item to the repel list"],
		      guiHidden = true,
		      usage = "<item name>",
		      get  = false,
		      set  = function(info,v)
					local found, _, itemText = string.find(v, "^|c%x.+|h%[(.+)%]|h|r")
					if (itemText == nil) then itemText = v end
					Magnet:Print("Repelling "..string.lower(itemText))
					Magnet.db.char.items[string.lower(itemText)] = false
				end
		   },
		   remove = {
		      order = 11,
		      type = 'input',
		      name = L["Remove item"],
		      desc = L["Removes an item from the attract or repel list"],
		      guiHidden = true,
		      usage = "<item name>",
		      get  = false,
		      set  = function(info,v)
					local found, _, itemText = string.find(v, "^|c%x.+|h%[(.+)%]|h|r")
					if (itemText == nil) then itemText = v end
					Magnet:Print("Removing "..string.lower(itemText))
					Magnet.db.char.items[string.lower(itemText)] = nil
				end
		   },
		   attract = {
		      order = 12,
		      type = 'input',
		      name = L["Attract item"],
		      desc = L["Adds a new item to the attracted items list"],
		      usage = "<item name>",
		      guiHidden = true,
		      get  = false,
		      set  = function(info,v)
					local found, _, itemText = string.find(v, "^|c%x.+|h%[(.+)%]|h|r")
					if (itemText == nil) then itemText = v end
					Magnet:Print("Magnetizing "..string.lower(itemText))
					Magnet.db.char.items[string.lower(itemText)] = true
				end
		   },
		},
	}
	
function Magnet:CreateOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Magnet", options, "magnet")
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Magnet", "Magnet")
end
