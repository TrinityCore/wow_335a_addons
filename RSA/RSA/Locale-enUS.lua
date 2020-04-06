local L = LibStub("AceLocale-3.0"):NewLocale("RSA", "enUS", true)

-- Option Header Descriptions
L.Spell_Options = "Settings for individual spells. Select the spell you want to configure from the drop down list."
L.Reminder_Options = "Options for reminding you when certain buffs are missing."


-- Repeated Options
L["Announce In:"] = true
L["Local"] = true
L["Spell Options"] = true
L["Reminder Options"] = true
L["Custom Channel"] = true
L["Channel Name"] = true
L["Raid"] = true
L["Party"] = true
L["Say"] = true
L["Whisper"] = true
L["Raid / Party"] = true
L["Message"] = true
L["Start"] = true
L["End"] = true
L["Successful"] = true
L["Resisted"] = true
L["Immune"] = true
L["Chat Window"] = true
L["Reminder Spell"] = true
L["Spell to check:"] = true
L["Enabling Options"] = true
L["Enable in Primary Specialisation"] = true
L["Enable in Secondary Specialisation"] = true
L["Disable in PvP"] = true
L["Warning Intervals"] = true
L["Check Interval"] = true
L["Remind Interval"] = true
L["Reminder Locations"] = true
L["Raid Warning Frame"] = true


-- Repeated Descriptions
L["Sends to Raid if you're in a raid, or party if you're in a party."] = true
L["Sends to say if you are ungrouped."] = true
L.SpellDescNoTarget = "Here you can set a custom message to announce upon using this spell. You may use:\nSPELL for the spell."
L.SpellDescTarget = "Here you can set a custom message to announce upon using this spell. You may use:\nSPELL for the spell.\nTARGET for the target."
L.SpellDescHeal = "Here you can set a custom message to announce upon using this spell. You may use:\nSPELL for the spell.\nTARGET for the target.\nAMOUNT for the amount healed."
L.SpellDescMissable = "Here you can set a custom message to announce upon using this spell. You may use:\nSPELL for the spell.\nTARGET for the target.\nMISSTYPE for the type of resist."
L.SpellDescInterrupt = "Here you can set a custom message to announce upon using this spell. You may use:\nSPELL for the spell.\nTARGET for the target.\nTARCAST for the spell you interrupt.\nMISSTYPE for the type of resist."
L.SpellDescDispel = "Here you can set a custom message to announce upon using this spell. You may use:\nSPELL for the spell.\nTARGET for the target.\nAURA for the (de)buff removed."
L.DescSpellStartSuccess = "The message played when the spell lands successfully."
L.DescSpellStartCastingMessage = "The message played upon casting the spell."
L.DescSpellEndCastingMessage = "The message played upon the spell ending."
L.DescSpellEndResist = "The message played on resists."
L.DescSpellEndImmune = "The message played when the target is immune."
L.DescSpellRemindName = "Enter the name of the spell you wish to be reminded of.\n|cffFF0000WARNING:|r If you do not enter the name of the spell accurately, it will not work."
L["Turns off the spell reminders while you have PvP active."] = true
L["Enables reminding of missing buffs while in your Primary Talent Specialisation"] = true
L["Enables reminding of missing buffs while in your Secondary Talent Specialisation"] = true
L["How often you want to check for missing buffs."] = true
L["How often you want to be reminded about missing buffs."] = true
L["Sends reminders to your Raid Warning frame at the center of the screen."] = true
L["Sends reminders to your default chat window."] = true
