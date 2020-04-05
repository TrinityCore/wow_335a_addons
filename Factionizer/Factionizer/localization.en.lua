-- Default (English)
--------------------

FIZ_TXT = {}

-- Binding names
BINDING_HEADER_FACTIONIZER	= "Factionizer"
BINDING_NAME_SHOWCONFIG		= "Show options window"
BINDING_NAME_SHOWDETAILS	= "Show reputation detail window"

-- help
FIZ_TXT.help		= "A tool to manage your reputation"
FIZ_TXT.command		= "Could not parse command"
FIZ_TXT.usage		= "Usage"
FIZ_TXT.helphelp	= "Show this help text"
FIZ_TXT.helpabout	= "Show author information"
FIZ_TXT.helpstatus	= "Show configuration status"
FIZ_TXT.help_urbin	= "List details about all addons by Urbin"
FIZ_TXT.helpphase	= "Defines the current main phase (1=Sanctum, 2=Armory, 3=Harbour)"
FIZ_TXT.helpsubphase	= "Defines the sub-phase (1=Building, 2=Built)"
-- about
FIZ_TXT.by		= "by"
FIZ_TXT.version		= "Version"
FIZ_TXT.date		= "Date"
FIZ_TXT.web		= "Website"
FIZ_TXT.slash		= "Slash command"
FIZ_TXT.urbin		= "Other addons by Urbin"
-- status
FIZ_TXT.status		= "Status"
FIZ_TXT.disabled	= "disabled"
FIZ_TXT.enabled		= "enabled"
FIZ_TXT.statMobs	= "Show Mobs [M]"
FIZ_TXT.statQuests	= "Show Quests [Q]"
FIZ_TXT.statInstances	= "Show Instances [D]"
FIZ_TXT.statItems	= "Show Items [I]"
FIZ_TXT.statMissing	= "Show missing reputation"
FIZ_TXT.statDetails	= "Show extended detail frame"
FIZ_TXT.statChat	= "Detailed chat message"
FIZ_TXT.statSuppress	= "Suppress original chat message"
FIZ_TXT.statPreview	= "Show preview rep in reputation frame"
-- XML UI elements
FIZ_TXT.showQuests	= "Show Quests"
FIZ_TXT.showInstances	= "Show Instances"
FIZ_TXT.showMobs	= "Show Mobs"
FIZ_TXT.showItems	= "Show Items"
FIZ_TXT.showAll		= "Show All"
FIZ_TXT.showNone	= "Show None"
FIZ_TXT.expand		= "Expand"
FIZ_TXT.collapse	= "Collapse"
FIZ_TXT.supressNoneFaction	= "Clear exclusion for faction"
FIZ_TXT.supressNoneGlobal	= "Clear exclusion for all"
FIZ_TXT.suppressHint	= "Right-click on a quest to exclude it from the summary"
-- options dialog
FIZ_TXT.showMissing	= "Show missing reputation in reputation frame"
FIZ_TXT.extendDetails	= "Show extended reputation detail frame"
FIZ_TXT.gainToChat	= "Write detailed faction gain messages to chat window"
FIZ_TXT.suppressOriginalGain = "Supress original faction gain messages"
FIZ_TXT.showPreviewRep	= "Show reputation that can be handed in in reputation frame"
FIZ_TXT.defaultChatFrame	= "Using default chat frame"
FIZ_TXT.chatFrame		= "Using chat frame %d (%s)"
FIZ_TXT.usingDefaultChatFrame	= "Now using default chat frame"
FIZ_TXT.usingChatFrame		= "Now using chat frame"
-- various LUA
FIZ_TXT.options		= "Options"
FIZ_TXT.orderByStanding = "Order by Standing"
FIZ_TXT.lookup		= "Looking up faction "
FIZ_TXT.lookup2		= ""
FIZ_TXT.allFactions	= "Listing all factions"
FIZ_TXT.missing		= "(to next)"
FIZ_TXT.missing2	= "Missing"
FIZ_TXT.heroic		= "Heroic"
FIZ_TXT.normal		= "Normal"
-- FIZ_ShowFactions
FIZ_TXT.faction		= "Faction"
FIZ_TXT.is		= "is"
FIZ_TXT.withStanding	= "with standing"
FIZ_TXT.needed		= "needed"
FIZ_TXT.mob		= "[Mob]"
FIZ_TXT.limited		= "is limited to"
FIZ_TXT.limitedPl	= "are limited to"
FIZ_TXT.quest		= "[Quest]"
FIZ_TXT.instance	= "[Instance]"
FIZ_TXT.items		= "[Items]"
FIZ_TXT.unknown		= "is not known to this player"
-- ReputationDetails
FIZ_TXT.currentRep	= "Current reputation"
FIZ_TXT.neededRep	= "Reputation needed"
FIZ_TXT.missingRep	= "Reputation missing"
FIZ_TXT.repInBag	= "Reputation in bag"
FIZ_TXT.repInBagBank	= "Reputation in bag & bank"
FIZ_TXT.repInQuest	= "Reputation in quests"
FIZ_TXT.factionGained	= "Gained this session"
FIZ_TXT.noInfo		= "No information available for this faction/reputation."
FIZ_TXT.toExalted	= "Reputation to exalted"
-- to chat
FIZ_TXT.stats		= " (Total: %s%d, Left: %d)"
-- UpdateList
FIZ_TXT.mobShort	= "[M]"
FIZ_TXT.questShort	= "[Q]"
FIZ_TXT.instanceShort	= "[D]"
FIZ_TXT.itemsShort	= "[I]"
FIZ_TXT.mobHead		= "Gain reputation by killing this mob"
FIZ_TXT.questHead	= "Gain reputation by doing this quest"
FIZ_TXT.instanceHead	= "Gain reputation by running this instance"
FIZ_TXT.itemsHead	= "Gain reputation by handing in items"
FIZ_TXT.mobTip		= "Each time you kill this mob, you gain reputation. Doing this often enough, will help you reach the next level."
FIZ_TXT.questTip	= "Each time you complete this repeatable or daily quest, you gain reputation. Doing this often enough, will help you reach the next level."
FIZ_TXT.instanceTip	= "Each time you run this instance, you gain reputation. Doing this often enough, will help you reach the next level."
FIZ_TXT.itemsName	= "Item hand-in"
FIZ_TXT.itemsTip	= "Each time you hand in the listed items, you will gain reputation. Doing this often enough, will help you reach the next level."
FIZ_TXT.allOfTheAbove	= "Summary of %d quests listed above"
FIZ_TXT.questSummaryHead = FIZ_TXT.allOfTheAbove
FIZ_TXT.questSummaryTip	= "This entry shows a summary of all the quests listed above.\r\nThis is useful assuming that all the quests listed are daily quests, as this will show you how many days it will take you to reach the next reputation level if you do all the daily quests each day."
FIZ_TXT.complete	= "complete"
FIZ_TXT.active		= "active"
FIZ_TXT.inBag		= "In bags"
FIZ_TXT.turnIns		= "Turn-ins:"
FIZ_TXT.reputation	= "Reputation:"
FIZ_TXT.inBagBank	= "In bags and bank"
FIZ_TXT.questCompleted	= "Quest completed"
FIZ_TXT.timesToDo	= "Times to do:"
FIZ_TXT.instance2	= "Instance:"
FIZ_TXT.mode		= "Mode:"
FIZ_TXT.timesToRun	= "Times to run:"
FIZ_TXT.mob2		= "Mob:"
FIZ_TXT.location	= "Location:"
FIZ_TXT.toDo		= "To do:"
FIZ_TXT.quest2		= "Quest:"
FIZ_TXT.itemsRequired	= "Items required"
FIZ_TXT.maxStanding	= "Yields reputation until"
-- SSO phases
FIZ_TXT.sso_warning	= "You have not yet defined what phase the Shattered Sun Offensive is at for this realm. On most servers all phases are finished, to quickly define this, type '/fz sso all'"
FIZ_TXT.sso_status	= "Shattered Sun Offensive Phase Status"
FIZ_TXT.sso_unknown	= "Unknown"
FIZ_TXT.sso_main	= "Main phase"
FIZ_TXT.sso_phase2b	= "Phase 2B"
FIZ_TXT.sso_phase3b	= "Phase 3B"
FIZ_TXT.sso_phase4b	= "Phase 4B"
FIZ_TXT.sso_phase4c	= "Phase 4C"
FIZ_TXT.phase1		= "Phase 1: Building Sun's Reach Sanctum"
FIZ_TXT.phase2		= "Phase 2: Buildung Sun's Reach Armory"
FIZ_TXT.phase3		= "Phase 3: Building Sun's Reach Harbor"
FIZ_TXT.phase4		= "Phase 4: Final Push"
FIZ_TXT.phase2bWaiting	= "Waiting for Sanctum to be built"
FIZ_TXT.phase2bActive	= "Building Sunwell Portal"
FIZ_TXT.phase2bDone	= "Sunwell Portal built"
FIZ_TXT.phase3bWaiting	= "Waiting for Armory to be built"
FIZ_TXT.phase3bActive	= "Building Anvil and Forge"
FIZ_TXT.phase3bDone	= "Anvil and Forge built"
FIZ_TXT.phase4Waiting	= "Waiting for Harbor to be built"
FIZ_TXT.phase4bActive	= "Building Monument of the Fallen"
FIZ_TXT.phase4bDone	= "Monument of the Fallen built"
FIZ_TXT.phase4cActive	= "Building Alchemy Lab"
FIZ_TXT.phase4cDone	= "Alchemy Lab built"
-- skills
FIZ_TXT.skillHerb	= "Herbalism"
FIZ_TXT.skillSkin	= "Skinning"
FIZ_TXT.skillMine	= "Mining"
FIZ_TXT.skillFish	= "Fishing"
FIZ_TXT.skillCook	= "Cooking"
FIZ_TXT.skillAid	= "First Aid"
FIZ_TXT.skillAlch	= "Alchemy"
FIZ_TXT.skillSmith	= "Blacksmithing"
FIZ_TXT.skillEnch	= "Enchanting"
FIZ_TXT.skillEngi	= "Engineering"
FIZ_TXT.skillJewel	= "Jewelcrafting"
FIZ_TXT.skillLw	= "Leatherworking"
FIZ_TXT.skillTail	= "Tailoring"

-- Tooltip
FIZ_TXT.elements = {}
FIZ_TXT.elements.name = {}
FIZ_TXT.elements.tip = {}

FIZ_TXT.elements.name.FIZ_ShowMobsButton	= FIZ_TXT.showMobs
FIZ_TXT.elements.tip.FIZ_ShowMobsButton		= "Check this button to see mobs you can kill to improve your reputation."
FIZ_TXT.elements.name.FIZ_ShowQuestButton	= FIZ_TXT.showQuests
FIZ_TXT.elements.tip.FIZ_ShowQuestButton	= "Check this button to see quests you can do to improve your reputation."
FIZ_TXT.elements.name.FIZ_ShowItemsButton	= FIZ_TXT.showItems
FIZ_TXT.elements.tip.FIZ_ShowItemsButton	= "Check this button to see items you can hand in to improve your reputation."
FIZ_TXT.elements.name.FIZ_ShowInstancesButton	= FIZ_TXT.showInstances
FIZ_TXT.elements.tip.FIZ_ShowInstancesButton	= "Check this button to see instances you can run to improve your reputation."

FIZ_TXT.elements.name.FIZ_ShowAllButton		= FIZ_TXT.showAll
FIZ_TXT.elements.tip.FIZ_ShowAllButton		= "Press this button to check all four of the checkboxes to the left.\r\nThis will show mobs, quests, items and instances that give you reputation for the currently selected faction."
FIZ_TXT.elements.name.FIZ_ShowNoneButton	= FIZ_TXT.showNone
FIZ_TXT.elements.tip.FIZ_ShowNoneButton		= "Press this button to deselect all four of the checkboxes to the left.\r\nThis will show you none of the ways to gain reputation for the currently selected faction."

FIZ_TXT.elements.name.FIZ_ExpandButton		= FIZ_TXT.expand
FIZ_TXT.elements.tip.FIZ_ExpandButton		= "Press this button to expand all entries in the list. This will show you the materials needed to hand in any item gathering quests."
FIZ_TXT.elements.name.FIZ_CollapseButton	= FIZ_TXT.collapse
FIZ_TXT.elements.tip.FIZ_CollapseButton		= "Press this button to collapse all entries in the list. This will hide the materials needed to hand in gathering quests."

FIZ_TXT.elements.name.FIZ_EnableMissingBox		= FIZ_TXT.showMissing
FIZ_TXT.elements.tip.FIZ_EnableMissingBox		= "Enable this setting to add the missing reputation points needed for the next reputation level behind the current standing of each faction in the reputation frame."
FIZ_TXT.elements.name.FIZ_ExtendDetailsBox		= FIZ_TXT.extendDetails
FIZ_TXT.elements.tip.FIZ_ExtendDetailsBox		= "Enable this setting to display an extended reputation detail frame.\r\nIn addition the information shown in the original detail frame, this will display the missing reputation needed to reach the next reputation level and a list of ways to gain this reputation by listing quests, mobs, items and instances that yield reputation for the chosen faction."
FIZ_TXT.elements.name.FIZ_GainToChatBox			= FIZ_TXT.gainToChat
FIZ_TXT.elements.tip.FIZ_GainToChatBox			= "Enable this setting to display reputation gained for all factions whenever you gain reputation.\r\nThis differs from the standard way of reporting reputation gain, as normally, only the gain with the main faction is listed."
FIZ_TXT.elements.name.FIZ_SupressOriginalGainBox	= FIZ_TXT.suppressOriginalGain
FIZ_TXT.elements.tip.FIZ_SupressOriginalGainBox		= "Enable this setting to suppress the standard reputation gain messages.\r\nThis makes sense if you have enabled the detailed faction gain messages, so you don't get identical listings from the standard and extended versions."
FIZ_TXT.elements.name.FIZ_ShowPreviewRepBox		= FIZ_TXT.showPreviewRep
FIZ_TXT.elements.tip.FIZ_ShowPreviewRepBox		= "Enable this setting to show the reputation you can gain by handing in items and completed quests as a grey bar overlaid over the normal reputation bar in the reputation frame."

