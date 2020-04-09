-- Korean localization file for koKR.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("SpeakinSpell", "koKR", false)
if not L then return end

SpeakinSpell:PrintLoading("Locales/Locale-koKR.lua")

-------------------------------------------------------------------------------
-- SLASH COMMANDS (do not include the leading /)
-------------------------------------------------------------------------------


-- "/SpeakinSpell" prefix and abbreviations
L["speakinspell"] = "마법알림"
L["ss"] = "마법알림"

-- parameters for "/ss something"
L["options"]	= "옵션"		-- /ss options
L["reset"]		= "초기화"		-- /ss reset
L["help"]		= "도움말"		-- /ss help
L["create"]	= "만들기"		-- /ss create
L["messages"]	= "메세지"		-- /ss messages
--L["macro"]		= "매크로"		-- /ss macro
L["macro"]		= strlower(MACRO) -- /ss macro
L["colors"]		= strlower(COLORS) -- /ss colors

L["advertise"]	= "광고"		-- /ss advertise
L["ad "]		= "광고 "	-- used in /ss ad /w playername (if playername is omitted, applies to selected target) -- Korean change (ommit one blank and change /ㅈ to /귓)
L["ad /s"]		= "광고 /말"	-- /ss ad /s -- Korean change (change /ㄴ to /말 for /say)
L["ad /p"]		= "광고 /파"		-- /ss ad /p -- Korean change (change /ㅔ to /파 for /party)
L["ad /ra"]	= "광고 /공"	-- /ss ad /ra


-------------------------------------------------------------------------------
-- CHAT CHANNEL NAMES
-------------------------------------------------------------------------------
-- These channel names are displayed as drop-down list options in the GUI


L["SAY"]			= "일반 (/s)"
L["PARTY"]			= "파티 (/p)"
L["RAID"]			= "공격대 (/ra)"
L["BATTLEGROUND"]	= "전장 (/bg)"
L["EMOTE"]			= "감정표현 (/em)"
L["YELL"]			= "외침 (/y)"
L["RAID_WARNING"]	= "공격대 경보 (/rw)"
L["Silent"]			= "침묵" -- messages are disabled
L["GUILD"]			= "길드 (/g)" -- Translation Kor 3.2.0.04 Complete
L["SPEAKINSPELL CHANNEL"]	= "혼자보기 (SpeakinSpell:)" -- Translation Kor 3.2.0.04 Complete
L["SELF RAID WARNING CHANNEL"] = "Self-Only Raid Warning"
L["RAID_BOSS_WHISPER"]	= "Boss Whisper"
L["MYSTERIOUS VOICE"]="[Mysterious Voice] whispers:"
L["COMM TRAFFIC RX"]	= "Comm Traffic Received (Rx)"
L["COMM TRAFFIC TX"]	= "Comm Traffic Sent (Tx)"


-------------------------------------------------------------------------------
-- SUBSTITUTION TABLE
-------------------------------------------------------------------------------
-- These are the substitution variables which may be used in random speeches


L["target"] = "대상"
L["focus"] = "주시대상"
L["targetclass"] = "대상직업"
L["targetrace"] = "대상종족"
L["player"] = "플레이어"
L["caster"] = "시전자"
L["spellname"] = "마법이름"
L["spellrank"] = "마법등급"
L["spelllink"] = "마법링크"
L["pet"] = "소환수"


-------------------------------------------------------------------------------
-- Event Types
-------------------------------------------------------------------------------


-- the types of events, as they appear in the list of detected events

-- label of the list under Message Settings
L["Select a Speech Event"] = "마법 또는 다른 이벤트를 선택하시오"
L["Select a spell from the list to configure the random announcements for that spell."] = "마법에 쓰여질 무작위 문구들을 설정하려면 목록에서 마법을 선택하시오."
-- different tooltip used for the same kind of list under Create New
L["This is a list of all the detected spells, abilities, items, and procced effects which SpeakinSpell has seen you cast or receive recently."] = [[이것은 최근에 당신이 시전했거나 받았던 마법, 능력, 아이템 기타 등등 중 SpeakinSpell이 감지한 것들의 목록입니다.]]

-- prefixes used in the list of spells
L["Misc. Event: "] = "시스템 이벤트: "-- ..eventname
L["When I Type: /ss "] = "사용자 작성 이벤트: /마법알림 "-- ..input ==> "User Macro Event: /ss macro something"
L["When I buff myself with: "] = "자신의 마법 시전으로 인한 버프: "--..spellname ==> Improved
L["When I debuff myself with: "] = "자신의 마법 시전으로 인한 디버프: "--..spellname ==> Improved
L["When someone else buffs me with: "] = "타인의 마법 시전으로 인한 버프: "--..spellname ==> Improved
L["When someone else debuffs me with: "] = "타인의 마법 시전으로 인한 디버프: "--..spellname ==> Improved
L["When I Start Casting: "] = "자신의 마법 시전: "--..spellname (rank) ==> Improved

L["_ Show All Types of Events _"] = "_ 모든 형태의 이벤트를 보여줌 _"
L["Misc. Events"] = "시스템 이벤트"
L["/ss macro things you type"] = "/마법알림 매크로" -- Korean Change "macro" --> "매크로"
L["Self Buffs (includes procs)"] = "자신의 버프들 (지속효과 포함)" -- ==> Improved
L["Self Debuffs"] = "자신의 디버프들" -- ==> Improved
L["Buffs from Others (includes totems)"] = "타인으로부터의 버프들 (토템 포함)"--..spellname ==> Improved
L["Debuffs from Others"] = "타인으로부터의 디버프들"--..spellname ==> Improved
L["Spells, Abilities, and Items (Start Casting)"] = "자신이 시전한 마법과 능력들 (아이템 포함)" --does this include items? ==> Yes..I include and improve now..Sorry..I Omitted..==> Improved

-- The names of "EVENT" type events themselves
L["SpeakinSpell Loaded"]	= "SpeakingSpell 메모리 탑재" -- Add Korean Translation Complete ==> None is Proper Korean Expression for "Loaded". So add word "memory"(Korean word "메모리"). "메모리 탑재" is similar expression "Loaded"
L["Entering Combat"]		= "전투 시작" -- Add Korean Translation Complete (v3.1.3.05)
L["Exiting Combat"]			= "전투 종료" -- Add Korean Translation Complete (v3.1.3.05)
L["Changed Zone"]			= "지역 변경" -- Translation Kor v3.2.0.04 complete
L["Changed Sub-Zone"]		= "하위지역 변경" -- Translation Kor v3.2.0.04 complete


-------------------------------------------------------------------------------
-- OPTIONS GUI LABELS AND TOOLTIPS
-------------------------------------------------------------------------------


L["General Settings"] = "일반 설정"
L["General Settings for SpeakinSpell"] = "SpeakinSpell에 대한 일반 설정"

L["Message Settings"] = "메세지 설정"
L["Create New..."] = "새로 만들기..."
L["SpeakinSpell Help"] = "SpeakinSpell 도움말"

L["Click here to create settings for a new spell, ability, effect, macro, or other event"] = "새로운 마법, 능력, 효과, 매크로, 또는 다른 이벤트를 위한 설정을 만들려면 이곳을 클릭하시오"

L["Stop SpeakinSpell from announcing the selected spell or event"] = "선택한 마법 또는 이벤트 알림을 비활성화 한다"

L["Enable Automatic SpeakinSpell Event Announcements"] = "SpeakinSpell 활성화"

L[
[[Enable this option to make SpeakinSpell show you (and only you) all of your own spell casting events and other events that can be announced.

This includes any spell, ability, item, /ss macro things, or automatically obtained effect (e.g. Trinkets or Talents) that you cast or use.]]
] = 
[[당신 스스로 또는 타인에 의한 감지된 모든 이벤트를 볼 수 있도록 하기 위해서는 이 옵션을 활성화 시키시오.  이것은 당신이 시전하거나 사용한 어떠한 마법, 능력, 아이템, 또는 자동획득효과(예를 들어, 장신구 또는 특성)도 전부 포함한다.  이것은 아이템에 의해 시전된 마법이름은 일반적으로 아이템이름 자체가 아니기 때문에 이를 알아내는데 유용할 수 있다.]]

L["Show Debugging Messages (verbose)"] = "디버깅 메세지 표시 (장문)"

L["Remove the selected spell from the list"] = "선택된 마법을 목록에서 삭제합니다"

L["Select the channel to use for this spell, while..."] = "... 에 있을때 이 마법알림에 사용할 채널을 선택하시오."

L["In a Battleground"] = "전장"
L["Select which channel to use for this spell while in a Battleground"] = "전장에 있는 동안 이 마법알림을 위해 어떤 채널을 사용할지 선택하시오"

L["In a Raid"] = "공격대"

L["Select which channel to use for this spell while in a Raid"] = "공격대에 있는 동안 이 마법알림을 위해 어떤 채널을 사용할지 선택하시오"

L["In a Party"] = "파티"
L["Select which channel to use for this spell while in a Party"] = "파티에 있는 동안 이 마법알림을 위해 어떤 채널을 사용할지 선택하시오"

L["By yourself"] = "단독플레이"
L["Select which channel to use for this spell while playing solo"] = "단독플레이를 하는 동안 이 마법알림을 위해 어떤 채널을 사용할지 선택하시오"

L["In Arena"] = "투기장"
L["Select which channel to use for this spell while playing in the Arena"] = "투기장에 있는 동안 이 마법알림을 위해 어떤 채널을 사용할지 선택하시오"

L["In Wintergrasp"] = "겨울손아귀 호수 전투중에" -- Translation Kor v3.2.0.04 complete
L[
[[Select which channel to use for this spell while playing in a Wintergrasp battle.  This only applies during an active battle.]]
] = [[겨울손아귀 호수 전투중에 있는 동안 이 마법알림을 위해 어떤 채널을 사용할지 선택하시오

이 시나리오는 단지 겨손전투가 진행될때에만 적용됩니다 - 현재 겨손전투가 진행중이 아닐때에는 공대, 파티 또는 단독플레이 옵션들이 적용될 것입니다.

겨울손아귀 호수에 있는지의 여부를 감지하는 것은 번역된 텍스트에 의존한다는 것을 알아두시기 바랍니다. 따라서 만일 SpeakinSpell이 아직 당신의 언어로 번역되어있지 않다면, 겨울손아귀 호수 전투들은 공대 시나리오 옵션을 사용할것입니다.]] -- Translation Kor v3.2.0.04 complete

L["Whisper the message to your <target>"] = "대상에게 메세지를 귓속말로 보내기"  
L[
[[Enable whispering the announcement to the friendly <target> of your spell.

Non-spell Speech Events also have a <target>. This uses the same target as the <target> substitution, and will not whisper to yourself.]]
] = [[
당신의 마법대상에게 귓속말로 메세지를 전달하도록 활성화 한다. 당신 자신에게 마법을 사용할 경우에는 대상이 선택되어있다 할지라도 귓속말을 보내지 않는다.
]]

L["Random Chance (%)"] = "이 마법에 대한 문구를 얼마나 자주 알리고 싶은가?"
L[
[[You have a random chance to say a message each time you use the selected spell, based on this selected percentage.

100% will always speak. 0% will never speak.]]
] = [[
선택된 확률를 기반으로 선택마법을 사용할때 문구 알림 확률을 얻습니다. 예를 들어 100%로 설정하면 항상 알리고, 0%로 설정하면 한번도 알리지 않습니다.
]]

L["Cooldown (seconds)"] = "마법에 대한 알림 쿨타임 (초)"
L["To prevent SpeakinSpell from speaking in the chat too often for this spell, you can set a cooldown for how many seconds must pass before SpeakinSpell will announce this spell again."] = [[
SpeakinSpell이 해당 마법에 대해서 너무 자주 채팅상에 알리는 것을 막아줍니다. 설정된 쿨타임이 지난 이후에만 해당 마법을 다시 알릴 것입니다.]]

L["Select a Category of Events"] = "이벤트의 종류를 선택하시오." -- Korean Translation (add v3.1.3.03)
L["Show only this kind of event in the list below"] = "아래 목록에서 선택된 이벤트 종류만을 보여줍니다." -- Korean Translation (add v3.1.3.03)

L["Select the new spell event you want to announce in chat above, then push this button"] = "위에서 당신이 채팅상에서 알리고 싶은 새로은 마법 또는 이벤트를 선택하고 이 버튼을 누르시오"

L["Random Speech <number>"] = "무작위 문구 <number>" -- the %d will be replaced with a number 1 to 50
L[
[[Write an announcement for this event.

Duplicates of speeches listed above will not be accepted]]
] = "여기에 말하고 싶은 재미있는 문구들을 입력하시오"


-------------------------------------------------------------------------------
-- ADDON MESSAGES (not random speeches - these are system/runtime messages)
-------------------------------------------------------------------------------


L["Default settings restored"] = "기본 설정 복구"


L["WARNING: can't execute protected command: <text>"] = "경고: 실행 보호 명령어는 할 수 없습니다 : <text>" -- Add Korean Translation Complete (v3.1.3.06)

L["Any Rank"] = "등급 무관" -- Translation Kor v3.2.0.04 complete


-- unlike other substitution variables, this definition needs the wrapping <> in the text to the right of the = sign
L["<newline>"] = "<새줄>" -- Translation Kor v3.2.0.04 Complete

L["realm"]		= "서버" -- Translation Kor v3.2.0.04 Complete
L["zone"]			= "지역" -- Translation Kor v3.2.0.04 Complete
L["subzone"]		= "하위지역" -- Translation Kor v3.2.0.04 Complete
L["playertitle"]	= "플레이어칭호" -- Translation Kor v3.2.0.04 Complete

L["Wintergrasp GetZoneText"] = "겨울손아귀 호수" -- the name of the zone exactly as it is returned by the GetZoneText() API -- Translation Kor v3.2.0.04 Complete


L["Limit once per combat"] = "전투당 한번으로 제한" -- Translation Kor v3.2.0.04 Complete
L["Do not announce this event more than once until you either leave combat, or enter combat."] = [[전투 시작 또는 전투 종료 둘중 하나가 이루어질때까지 해당 이벤트는 한번만 알립니다.]] -- Translation Kor v3.2.0.04 Complete

L["Limit once per <target>"] = "<대상> 이름당 한번으로 제한" -- Translation Kor v3.2.0.04 Complete
L[
[[Do not announce this event more than once in a row for the same <target> name.

Note that for spells and events that only ever target you, you're name will never change, so this would limit the announcement to once per login session.]]
] = [[같은 <대상> 이름에 대해서 한번만 해당 이벤트를 알립니다. 

당신만을 대상으로 하는 마법이나 이벤트의 경우는 당신의 이름이 절대 바뀌지 않으므로 당신이 로그인 하고 나서 딱 한번만 알린다는 것을 고려하시기 바랍니다.]] -- Translation Kor v3.2.0.04 Complete


------------------------------------------
---------- oldversions.lua      ----------
------------------------------------------
-- [buildlocales.py copy]

-- Localization of this file has to be careful because some localized strings
-- were used as functional table keys and may be required to match old data
--
-- If the L[] value is in source data, then it must be preserved forever in
--		order to be able to find matching data in old saved data
-- If the L[] value is a destination value, then it may use the newest value
--		which can freely be changed in order to perfect the translation
--		or change the way the UI looks
-- If the L[] value is not used in data at all because it is a status message
--		then it may be changed freely
-- Old transtions need to be saved following this naming convention
-- For locale files that didn't exist yet in these older versions, use English

-- DO NOT CHANGE! -- the value of L["/macro"] in release 3.1.2.05
L["3.1.2.05 /macro"] = "macro"--verified from SVN, koKR didn't exist yet, so use english

-- DO NOT CHANGE! -- the <newline> substitution key word from 3.2.2.02
L["3.2.2.02 <newline>"] = "<새줄>" --verified from SVN

-- DO NOT CHANGE! -- display names for some event hooks in 3.2.2.14
L["3.2.2.14 Entering Combat"] = "전투 시작" --verified from SVN
L["3.2.2.14 Exiting Combat"] = "전투 종료" --verified from SVN
L["3.2.2.14 Whispered While In-Combat"] = "Whispered While In-Combat" --verified from SVN, had not been transated yet

-- REFERENCED OUTSIDE THIS FILE (authorized list) --
-- These are expected overlaps with other code files
-- The following warnings will be auto-detected by the script
-- The dominant translations used elsewhere in the UI may be used, and freely changed
--L["SpeakinSpell Loaded"] already defined under:SpeakinSpell.lua
--L["<newline>"] already defined under:gui/currentmessages.lua
--L["macro "] already defined under:slashcommands.lua

-- OK TO CHANGE --
-- the remaining definitions below are auto-generated
-- they may be changed freely to provide the best possible translation

-- [buildlocales.py end of copy]
