local revision = tonumber(string.sub("$Revision: 142 $", 12, -3)) or 1
if revision > ElkBuffBars.revision then ElkBuffBars.revision = revision end

local L = AceLibrary("AceLocale-2.2"):new("ElkBuffBars")

L:RegisterTranslations("enUS", function() return {
	TOOLTIP_BARGROUP = "bargroup",
	TOOLTIP_TYPE = "type",
	
	OPTIONS_OVERRIDES_NAME = "Override Settings",
	OPTIONS_OVERRIDES_DESC = "Change name and type for known buffs",
	OPTIONS_OVERRIDES_NAME_NAME = "Shown Name",
	OPTIONS_OVERRIDES_NAME_DESC = "Sets the name to show",
	OPTIONS_OVERRIDES_TYPE_NAME = "New Type",
	OPTIONS_OVERRIDES_TYPE_DESC = "Sets the new type",
	OPTIONS_OVERRIDES_TYPE_VALIDATE_DEFAULT = "default",
	OPTIONS_BARGROUPS_NAME = "Group Settings",
	OPTIONS_BARGROUPS_DESC = "Changes the settings for the bargroups",
	OPTIONS_NEWGROUP_NAME = "New Group",
	OPTIONS_NEWGROUP_DESC = "Creates a new bargroup",
	OPTIONS_GROUPSPACING_NAME = "Group Spacing",
	OPTIONS_GROUPSPACING_DESC = "Sets gap between anchored groups",
	OPTIONS_HIDEBLIZZARDBUFFS_NAME = "Hide Blizzard Buff Frame",
	OPTIONS_HIDEBLIZZARDBUFFS_DESC = "Toggles active hiding of the Blizzard buff frame",
	OPTIONS_HIDEBLIZZARDTENCH_NAME = "Hide Blizzard TEnch Frame",
	OPTIONS_HIDEBLIZZARDTENCH_DESC = "Toggles active hiding of the Blizzard tench frame",
	OPTIONS_HIDEBLIZZARDTRACKING_NAME = "Hide Minimap Tracking Frame",
	OPTIONS_HIDEBLIZZARDTRACKING_DESC = "Toggles active hiding of the minimap tracking frame",
	OPTIONS_GROUP_NAME = "Group %d",
	OPTIONS_GROUP_DESC = "Settings for Group %d",
	OPTIONS_GROUP_ANCHOR_NAME = "Show Anchor",
	OPTIONS_GROUP_ANCHOR_DESC = "Toggles Anchor",
	OPTIONS_GROUP_NAME_NAME = "Name",
	OPTIONS_GROUP_NAME_DESC = "Sets the group's name",
	OPTIONS_GROUP_BARLAYOUT_NAME = "Bar Layout",
	OPTIONS_GROUP_BARLAYOUT_DESC = "Sets the layout for this group's bars",
	OPTIONS_GROUP_BAR_NAME = "Bar",
	OPTIONS_GROUP_BAR_DESC = "Settings for the statusbar",
	OPTIONS_GROUP_BAR_SHOW_NAME = "Show Statusbar",
	OPTIONS_GROUP_BAR_SHOW_DESC = "Toggles display of the statusbar",
	OPTIONS_GROUP_BAR_TEXTURE_NAME = "Bar Texture",
	OPTIONS_GROUP_BAR_TEXTURE_DESC = "Sets the bar texture",
	OPTIONS_GROUP_BAR_COLOR_NAME = "Bar Color",
	OPTIONS_GROUP_BAR_COLOR_DESC = "Sets the color for the bar",
	OPTIONS_GROUP_BAR_BGSHOW_NAME = "Show Background",
	OPTIONS_GROUP_BAR_BGSHOW_DESC = "Toggles display of the bar background",
	OPTIONS_GROUP_BAR_BGCOLOR_NAME = "Background Color",
	OPTIONS_GROUP_BAR_BGCOLOR_DESC = "Sets the color for the bar's background",
	OPTIONS_GROUP_BAR_SPARK_NAME = "Spark",
	OPTIONS_GROUP_BAR_SPARK_DESC = "Toggles showing of the spark",
	OPTIONS_GROUP_BAR_DEBUFFCOLOR_NAME = "Debuff Coloring",
	OPTIONS_GROUP_BAR_DEBUFFCOLOR_DESC = "Toggles if the bar is colored by debuff type",
	OPTIONS_GROUP_BAR_LTRDIR_NAME = "Bar Direction LTR",
	OPTIONS_GROUP_BAR_LTRDIR_DESC = "Toggles if the bar depletes from left to right",
	OPTIONS_GROUP_BAR_TIMELESSFULL_NAME = "Full bars for timeless",
	OPTIONS_GROUP_BAR_TIMELESSFULL_DESC = "Toggles full bars for timeless buffs",
	OPTIONS_GROUP_ICON_NAME = "Icon",
	OPTIONS_GROUP_ICON_DESC = "Settings for the icon",
	OPTIONS_GROUP_ICON_POSITION_NAME = "Position",
	OPTIONS_GROUP_ICON_POSITION_DESC = "Sets icon showing",
	OPTIONS_GROUP_ICON_POSITION_HIDE = "hide",
	OPTIONS_GROUP_ICON_POSITION_LEFT = "Left Side",
	OPTIONS_GROUP_ICON_POSITION_RIGHT = "Right Side",
	OPTIONS_GROUP_ICON_STACK_SHOW_NAME = "Buff Stacks - Show",
	OPTIONS_GROUP_ICON_STACK_SHOW_DESC = "Toggles showing of buff stacks on the icon",
	OPTIONS_GROUP_ICON_STACK_ANCHOR_NAME = "Buff Stacks - Anchor",
	OPTIONS_GROUP_ICON_STACK_ANCHOR_DESC = "Sets the anchor for the buff stacks on the icon",
	OPTIONS_GROUP_ICON_STACK_FONT_NAME = "Buff Stacks - Font",
	OPTIONS_GROUP_ICON_STACK_FONT_DESC = "Sets the font for the buff stacks on the icon",
	OPTIONS_GROUP_ICON_STACK_FONTSIZE_NAME = "Buff Stacks - Font Size",
	OPTIONS_GROUP_ICON_STACK_FONTSIZE_DESC = "Sets the font size for the buff stacks on the icon",
	OPTIONS_GROUP_ICON_STACK_FONTCOLOR_NAME = "Buff Stacks - Font Color",
	OPTIONS_GROUP_ICON_STACK_FONTCOLOR_DESC = "Sets the font color for the buff stacks on the icon",
	OPTIONS_GROUP_TEXTTL_NAME = "Text topleft",
	OPTIONS_GROUP_TEXTTL_DESC = "Settings for the topleft text",
	OPTIONS_GROUP_TEXTTR_NAME = "Text topright",
	OPTIONS_GROUP_TEXTTR_DESC = "Settings for the topright text",
	OPTIONS_GROUP_TEXTBL_NAME = "Text bottomleft",
	OPTIONS_GROUP_TEXTBL_DESC = "Settings for the bottomleft text",
	OPTIONS_GROUP_TEXTBR_NAME = "Text bottomright",
	OPTIONS_GROUP_TEXTBR_DESC = "Settings for the bottomright text",
	OPTIONS_GROUP_TEXT_TEMPLATE_NAME = "Text shown",
	OPTIONS_GROUP_TEXT_TEMPLATE_DESC = "Sets the text which is shown",
	OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_HIDE = "Hide",
	OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAME = "Name",
	OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANK = "Name, Rank",
	OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMECOUNT = "Name, Count",
	OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANKCOUNT = "Name, Rank, Count",
	OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_RANK = "Rank",
	OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_COUNT = "Count",
	OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_TIMELEFT = "Time Left",
	OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_DEBUFFTYPE = "Debuff Type",
	OPTIONS_GROUP_TEXT_FONT_NAME = "Font",
	OPTIONS_GROUP_TEXT_FONT_DESC = "Sets the font",
	OPTIONS_GROUP_TEXT_FONTSIZE_NAME = "Font Size",
	OPTIONS_GROUP_TEXT_FONTSIZE_DESC = "Sets the font size",
	OPTIONS_GROUP_TEXT_FONTCOLOR_NAME = "Font Color",
	OPTIONS_GROUP_TEXT_FONTCOLOR_DESC = "Sets the font color",
	OPTIONS_GROUP_TEXT_ALIGNMENT_NAME = "Alignment",
	OPTIONS_GROUP_TEXT_ALIGNMENT_LEFT = "left",
	OPTIONS_GROUP_TEXT_ALIGNMENT_CENTER = "center",
	OPTIONS_GROUP_TEXT_ALIGNMENT_RIGHT = "right",
	OPTIONS_GROUP_TEXTTL_ALIGNMENT_DESC = "Sets the text alignment (only if topright text hidden)",
	OPTIONS_GROUP_TEXTBL_ALIGNMENT_DESC = "Sets the text alignment (only if bottomright text hidden)",
	OPTIONS_GROUP_ABBREVIATE_NAME = "Abbreviate Name",
	OPTIONS_GROUP_ABBREVIATE_DESC = "Abbreviate names longer than this (0 = disabled)",
	OPTIONS_GROUP_TIMEFORMAT_NAME = "Time Format",
	OPTIONS_GROUP_TIMEFORMAT_DESC = "Sets the format the time is shown in",
	OPTIONS_GROUP_PADDING_NAME = "Padding",
	OPTIONS_GROUP_PADDING_DESC = "Sets the padding for the text strings",
	OPTIONS_GROUP_TTIPANCHOR_NAME = "Tooltip Anchor",
	OPTIONS_GROUP_TTIPANCHOR_DESC = "Sets the anchor for tooltips",
	OPTIONS_GROUP_HEIGHT_NAME = "Height",
	OPTIONS_GROUP_HEIGHT_DESC = "Sets the bar hight",
	OPTIONS_GROUP_WIDTH_NAME = "Width",
	OPTIONS_GROUP_WIDTH_DESC = "Sets the bar Width",
	OPTIONS_GROUP_ALPHA_NAME = "Alpha",
	OPTIONS_GROUP_ALPHA_DESC = "Sets the group's alpha value",
	OPTIONS_GROUP_SCALE_NAME = "Scale",
	OPTIONS_GROUP_SCALE_DESC = "Sets the group's scale",
	OPTIONS_GROUP_BARSPACING_NAME = "Bar Spacing",
	OPTIONS_GROUP_BARSPACING_DESC = "Sets gap between bars",
	OPTIONS_GROUP_GROWUP_NAME = "Grow up",
	OPTIONS_GROUP_GROWUP_DESC = "Toggles direction of buffs",
	OPTIONS_GROUP_SORTING_NAME = "Sorting",
	OPTIONS_GROUP_SORTING_DESC = "Sets sorting of buffs",
	OPTIONS_GROUP_FILTER_NAME = "Filter",
	OPTIONS_GROUP_FILTER_DESC = "Sets the buffs to show",
	OPTIONS_GROUP_FILTER_TYPE_NAME = "Type",
	OPTIONS_GROUP_FILTER_TYPE_DESC = "Sets which types of buffs to show",
	OPTIONS_GROUP_FILTER_SELFCAST_NAME = "Self Cast Buffs",
	OPTIONS_GROUP_FILTER_SELFCAST_DESC = "Sets if and how to filter buffs you casted",
	OPTIONS_GROUP_FILTER_SELFCAST_VALIDATE_NOFILTER = "don't filter",
	OPTIONS_GROUP_FILTER_SELFCAST_VALIDATE_WHITELIST = "whitelist",
	OPTIONS_GROUP_FILTER_SELFCAST_VALIDATE_BLACKLIST = "blacklist",
	OPTIONS_GROUP_FILTER_TIMELESS_NAME = "Timeless Buffs",
	OPTIONS_GROUP_FILTER_TIMELESS_DESC = "Sets if and how to filter Timeless Buffs",
	OPTIONS_GROUP_FILTER_TIMELESS_VALIDATE_NOFILTER = "don't filter",
	OPTIONS_GROUP_FILTER_TIMELESS_VALIDATE_WHITELIST = "whitelist",
	OPTIONS_GROUP_FILTER_TIMELESS_VALIDATE_BLACKLIST = "blacklist",
	OPTIONS_GROUP_FILTER_TIMEMAXMIN_NAME = "Min. Timemax",
	OPTIONS_GROUP_FILTER_TIMEMAXMIN_DESC = "Sets a minimum duration for buffs to show.",
	OPTIONS_GROUP_FILTER_TIMEMAXMIN_USAGE = "time in seconds",
	OPTIONS_GROUP_FILTER_TIMEMAXMAX_NAME = "Max. Timemax",
	OPTIONS_GROUP_FILTER_TIMEMAXMAX_DESC = "Sets a maximum duration for buffs to show.",
	OPTIONS_GROUP_FILTER_TIMEMAXMAX_USAGE = "time in seconds",
	OPTIONS_GROUP_FILTER_NAME_WHITELIST_NAME = "White List",
	OPTIONS_GROUP_FILTER_NAME_WHITELIST_DESC = "Only show buffs on white list (disabled if empty)",
	OPTIONS_GROUP_FILTER_NAME_BLACKLIST_NAME = "Black List",
	OPTIONS_GROUP_FILTER_NAME_BLACKLIST_DESC = "Don't show buffs on black list",
	OPTIONS_GROUP_TARGET_NAME = "Target",
	OPTIONS_GROUP_TARGET_DESC = "Sets whos buffs to show",
	OPTIONS_GROUP_CLICKTHROUGH_NAME = "Disable Mouse",
	OPTIONS_GROUP_CLICKTHROUGH_DESC = "Disable mouse input to allow click-through",
	OPTIONS_GROUP_COPYLAYOUT_NAME = "Copy Layout",
	OPTIONS_GROUP_COPYLAYOUT_DESC = "Copys the layout from another bargroup",
	OPTIONS_GROUP_COPYLAYOUT_USAGE = "group id of the layout",
	OPTIONS_GROUP_RESETPOSITION_NAME = "Reset Position",
	OPTIONS_GROUP_RESETPOSITION_DESC = "Resets the bargroup's position to screen center",
	OPTIONS_GROUP_REMOVE_NAME = "Remove Group",
	OPTIONS_GROUP_REMOVE_DESC = "Removes the bargroup",
	
	CHATCOMMAND_CONFIG_DESC = "Shows the config menu",
}end)
