--[[
Name: RatingBuster koKR locale
Revision: $Revision: 282 $
Translated by:
- Slowhand, 7destiny, kcgcom, fenlis
]]

local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "koKR")
if not L then return end
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: L["Show Item ID"] = true,
-- After:  L["Show Item ID"] = "아이템 ID 표시",
---------------
-- Waterfall --
---------------
L["RatingBuster Options"] = "RatingBuster 설정"
L["Waterfall-1.0 is required to access the GUI."] = "GUI를 표시하려면 Waterfall-1.0 라이브러리가 필요합니다!"
L["Enabled"] = "사용"
L["Suspend/resume this addon"] = "이 애드온 중지/다시 시작"
---------------------------
-- Slash Command Options --
---------------------------
L["Always"] = "항상"
L["ALT Key"] = "ALT 키"
L["CTRL Key"] = "CTRL 키"
L["SHIFT Key"] = "SHIFT 키"
L["Never"] = "표시 안함"
L["General Settings"] = "일반 설정"
L["Profiles"] = "프로필"
-- /rb win
L["Options Window"] = "설정창"
L["Shows the Options Window"] = "설정창을 보여줍니다."
-- /rb hidebzcomp
L["Hide Blizzard Item Comparisons"] = "기본 아이템 비교 숨김"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "툴팁에 블리자드의 기본 아이템 비교를 숨깁니다."
-- /rb statmod
L["Enable Stat Mods"] = "기본 능력치에 가중치 적용"
L["Enable support for Stat Mods"] = "기본 능력치에 특성이나 버프, 태세(형상, 폼)등에 의한 가중치를 적용합니다."
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "방어행동 점감 효과 사용"
L["Dodge, Parry, Hit Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "회피, 무기 막기, 빗맞힘 수치를 현재 능력치에서 점감 효과를 적용하여 계산합니다."
-- /rb itemid
L["Show ItemID"] = "아이템 ID 표시"
L["Show the ItemID in tooltips"] = "툴팁에 아이템 ID를 표시합니다."
-- /rb itemlevel
L["Show ItemLevel"] = "아이템 레벨 표시"
L["Show the ItemLevel in tooltips"] = "툴팁에 아이템 레벨을 표시합니다."
-- /rb usereqlv
L["Use Required Level"] = "최소 요구 레벨 사용"
L["Calculate using the required level if you are below the required level"] = "레벨이 낮아 사용하지 못하는 경우 최소 요구 레벨에 따라 계산합니다."
-- /rb level
L["Set Level"] = "레벨 설정"
L["Set the level used in calculations (0 = your level)"] = "계산에 적용할 레벨을 설정합니다. (0 = 자신의 레벨)"
---------------------------------------------------------------------------
-- /rb rating
L["Rating"] = "전투 숙련도"
L["Options for Rating display"] = "전투 숙련도 표시에 대한 설정입니다."
-- /rb rating show
L["Show Rating Conversions"] = "전투 숙련도 계산 표시"
L["Show Rating conversions in tooltips"] = "툴팁에 전투 숙련도를 전투 능력치로 계산하여 표시합니다."
-- /rb rating spell
--L["Show Spell Hit/Haste"] = true
--L["Show Spell Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating physical
--L["Show Physical Hit/Haste"] = true
--L["Show Physical Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating detail
L["Show Detailed Conversions Text"] = "세부적인 전투 숙련도 계산 표시"
L["Show detailed text for Resilience and Expertise conversions"] = "탄력도와 숙련을 세부적인 전투 능력치로 계산해서 표시합니다."
-- /rb rating def
L["Defense Breakdown"] = "방어 숙련 세분화"
L["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "방어 숙련을 치명타 감소, 빗맞힘, 회피, 무기 막기, 방패 막기로 계산해서 표시합니다."
-- /rb rating wpn
L["Weapon Skill Breakdown"] = "무기 숙련 세분화"
L["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "무기 숙련을 치명타, 적중, 회피 무시, 무기 막기 무시, 방패막기 무시로 계산해서 표시합니다."
-- /rb rating exp
L["Expertise Breakdown"] = "숙련 세분화"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "숙련을 회피 무시와 무기 막기 무시로 계산해서 표시합니다."
---------------------------------------------------------------------------
-- /rb rating color
L["Change Text Color"] = "글자 색상 변경"
L["Changes the color of added text"] = "추가된 글자의 색상을 변경합니다."
-- /rb rating color pick
L["Pick Color"] = "색상"
L["Pick a color"] = "색상을 선택합니다."
-- /rb rating color enable
L["Enable Color"] = "색상 사용"
L["Enable colored text"] = "글자에 색상을 적용합니다."
---------------------------------------------------------------------------
-- /rb stat
L["Stat Breakdown"] = "능력치"
L["Changes the display of base stats"] = "기본 능력치의 표시 방법을 변경합니다."
-- /rb stat show
L["Show Base Stat Conversions"] = "기본 능력치 계산 표시"
L["Show base stat conversions in tooltips"] = "툴팁에 기본 능력치를 전투 능력치로 계산하여 표시합니다."
---------------------------------------------------------------------------
-- /rb stat str
L["Strength"] = "힘"
L["Changes the display of Strength"] = "힘의 표시 방법을 변경합니다."
-- /rb stat str ap
L["Show Attack Power"] = "전투력 표시"
L["Show Attack Power from Strength"] = "힘에 의한 전투력을 표시합니다."
-- /rb stat str block
L["Show Block Value"] = "피해 방어량 표시"
L["Show Block Value from Strength"] = "힘에 의한 피해 방어량을 표시합니다."
-- /rb stat str dmg
L["Show Spell Damage"] = "주문 공격력 표시"
L["Show Spell Damage from Strength"] = "힘에 의한 주문 공격력을 표시합니다."
-- /rb stat str heal
L["Show Healing"] = "치유량 표시"
L["Show Healing from Strength"] = "힘에 의한 치유량을 표시합니다."
-- /rb stat str parry
L["Show Parry"] = "무기 막기"
L["Show Parry from Strength"] = "힘에 의한 무기 막기를 표시합니다."
---------------------------------------------------------------------------
-- /rb stat agi
L["Agility"] = "민첩성"
L["Changes the display of Agility"] = "민첩성의 표시 방법을 변경합니다."
-- /rb stat agi crit
L["Show Crit"] = "치명타 표시"
L["Show Crit chance from Agility"] = "민첩성에 의한 치명타 확률을 표시합니다."
-- /rb stat agi dodge
L["Show Dodge"] = "회피 표시"
L["Show Dodge chance from Agility"] = "민첩성에 의한 회피율을 표시합니다."
-- /rb stat agi ap
L["Show Attack Power"] = "전투력 표시"
L["Show Attack Power from Agility"] = "민첩성에 의한 전투력을 표시합니다."
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "원거리 전투력 표시"
L["Show Ranged Attack Power from Agility"] = "민첩성에 의한 원거리 전투력을 표시합니다."
-- /rb stat agi armor
L["Show Armor"] = "방어도 표시"
L["Show Armor from Agility"] = "민첩성에 의한 방어도를 표시합니다."
-- /rb stat agi heal
L["Show Healing"] = "치유량 표시"
L["Show Healing from Agility"] = "민첩성에 의한 치유량을 표시합니다."
---------------------------------------------------------------------------
-- /rb stat sta
L["Stamina"] = "체력"
L["Changes the display of Stamina"] = "체력의 표시 방법을 변경합니다."
-- /rb stat sta hp
L["Show Health"] = "생명력 표시"
L["Show Health from Stamina"] = "체력에 의한 생명력을 표시합니다."
-- /rb stat sta dmg
L["Show Spell Damage"] = "주문 공격력 표시"
L["Show Spell Damage from Stamina"] = "체력에 의한 주문 공격력을 표시합니다."
-- /rb stat sta heal
L["Show Healing"] = "치유량 표시"
L["Show Healing from Stamina"] = "체력에 의한 치유량을 표시합니다."
-- /rb stat sta ap
L["Show Attack Power"] = "전투력 표시"
L["Show Attack Power from Stamina"] = "체력에 의한 전투력을 표시합니다."
---------------------------------------------------------------------------
-- /rb stat int
L["Intellect"] = "지능"
L["Changes the display of Intellect"] = "지능 표시방법을 변경합니다."
-- /rb stat int spellcrit
L["Show Spell Crit"] = "주문 극대화 표시"
L["Show Spell Crit chance from Intellect"] = "지능에 의한 주문 극대화율 표시"
-- /rb stat int mp
L["Show Mana"] = "마나 표시"
L["Show Mana from Intellect"] = "지능에 의한 마나량을 표시합니다."
-- /rb stat int dmg
L["Show Spell Damage"] = "주문 공격력 표시"
L["Show Spell Damage from Intellect"] = "지능에 의한 주문 공격력을 표시합니다."
-- /rb stat int heal
L["Show Healing"] = "치유량 표시"
L["Show Healing from Intellect"] = "지능에 의한 치유량을 표시합니다."
-- /rb stat int mp5
L["Show Mana Regen"] = "마나 회복 표시"
L["Show Mana Regen while casting from Intellect"] = "지능에 의한 시전중 마나 회복량을 표시합니다."
-- /rb stat int mp5nc
L["Show Mana Regen while NOT casting"] = "비시전중 마나 회복 표시"
L["Show Mana Regen while NOT casting from Intellect"] = "지능에 의한 비시전중 마나 회복량을 표시합니다."
-- /rb stat int rap
L["Show Ranged Attack Power"] = "원거리 전투력 표시"
L["Show Ranged Attack Power from Intellect"] = "지능에 의한 원거리 전투력을 표시합니다."
-- /rb stat int armor
L["Show Armor"] = "방어도 표시"
L["Show Armor from Intellect"] = "지능에 의한 방어도를 표시합니다."
-- /rb stat int ap
L["Show Attack Power"] = "전투력 표시"
L["Show Attack Power from Intellect"] = "지능에 의한 전투력을 표시합니다."
---------------------------------------------------------------------------
-- /rb stat spi
L["Spirit"] = "정신력"
L["Changes the display of Spirit"] = "정신력의 표시방법을 변경합니다."
-- /rb stat spi mp5
L["Show Mana Regen"] = "마나 회복 표시"
L["Show Mana Regen while casting from Spirit"] = "정신력에 의한 시전중 마나 회복량을 표시합니다."
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "비시전중 마나 회복 표시"
L["Show Mana Regen while NOT casting from Spirit"] = "정신력에 의한 비시전중 마나 회복량을 표시합니다."
-- /rb stat spi hp5
L["Show Health Regen"] = "생명력 회복 표시"
L["Show Health Regen from Spirit"] = "정신력에 의한 (비전투중) 생명력 회복량을 표시합니다."
-- /rb stat spi dmg
L["Show Spell Damage"] = "주문 공격력 표시"
L["Show Spell Damage from Spirit"] = "정신력에 의한 주문 공격력을 표시합니다."
-- /rb stat spi heal
L["Show Healing"] = "치유량 표시"
L["Show Healing from Spirit"] = "정신력에 의한 치유량을 표시합니다."
-- /rb stat spi spellcrit
L["Show Spell Crit"] = "주문 극대화 표시"
L["Show Spell Crit chance from Spirit"] = "정신력에 의한 주문 극대화를 표시합니다."
---------------------------------------------------------------------------
-- /rb stat armor
L["Armor"] = "방어도"
L["Changes the display of Armor"] = "방어도의 표시방법을 변경합니다."
-- /rb stat armor ap
L["Show Attack Power"] = "전투력 표시"
L["Show Attack Power from Armor"] = "방어도에 의한 전투력을 표시합니다."
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = "능력치 요약"
L["Options for stat summary"] = "능력치 요약에 대한 설정입니다."
-- /rb sum show
L["Show Stat Summary"] = "능력치 요약 표시"
L["Show stat summary in tooltips"] = "툴팁에 능력치 요약을 표시합니다."
-- /rb sum ignore
L["Ignore Settings"] = "제외 설정"
L["Ignore stuff when calculating the stat summary"] = "능력치 요약 계산에서 제외시킬 항목들을 설정합니다."
-- /rb sum ignore unused
L["Ignore Undesirable Items"] = "원하지 않는 아이템 제외"
L["Hide stat summary for undesirable items"] = "원하지 않는 아이템의 능력치를 숨깁니다."
-- /rb sum ignore quality
L["Minimum Item Quality"] = "최소 아이템 품질"
L["Show stat summary only for selected quality items and up"] = "선택한 품질 아이템의 이상인 능력치를 표시합니다."
-- /rb sum ignore armor
L["Armor Types"] = "방어구 유형"
L["Select armor types you want to ignore"] = "제외를 원하는 방어구 유형을 선택합니다."
-- /rb sum ignore armor cloth
L["Ignore Cloth"] = "제외 - 천"
L["Hide stat summary for all cloth armor"] = "모든 천 방어구의 능력치를 숨깁니다."
-- /rb sum ignore armor leather
L["Ignore Leather"] = "제외 - 가죽"
L["Hide stat summary for all leather armor"] = "모든 가죽 방어구의 능력치를 숨깁니다."
-- /rb sum ignore armor mail
L["Ignore Mail"] = "제외 - 사슬"
L["Hide stat summary for all mail armor"] = "모든 사슬 방어구의 능력치를 숨깁니다."
-- /rb sum ignore armor plate
L["Ignore Plate"] = "제외 - 판금"
L["Hide stat summary for all plate armor"] = "모든 판금 방어구의 능력치를 숨깁니다."
-- /rb sum ignore equipped
L["Ignore Equipped Items"] = "착용 아이템 제외"
L["Hide stat summary for equipped items"] = "능력치 요약 계산에 착용한 아이템은 포함시키지 않습니다."
-- /rb sum ignore enchant
L["Ignore Enchants"] = "마법부여 제외"
L["Ignore enchants on items when calculating the stat summary"] = "능력치 요약 계산에 아이템에 부여한 마법부여를 포함시키지 않습니다."
-- /rb sum ignore gem
L["Ignore Gems"] = "보석 제외"
L["Ignore gems on items when calculating the stat summary"] = "능력치 요약 계산에 아이템에 장착한 보석을 포함시키지 않습니다."
-- /rb sum ignore prismaticSocket
L["Ignore Prismatic Sockets"] = "다색 보석 홈 제외"
L["Ignore gems in prismatic sockets when calculating the stat summary"] = "능력치 요약 계산에 다색 보석 홈을 포함시키지 않습니다."
-- /rb sum diffstyle
L["Display Style For Diff Value"] = "차이값 표시 방식"
L["Display diff values in the main tooltip or only in compare tooltips"] = "기본 툴팁 또는 비교 툴팁에 차이나는 수치를 표시합니다."
-- /rb sum space
L["Add Empty Line"] = "구분선 추가"
L["Add a empty line before or after stat summary"] = "능력치 요약 앞/뒤에 구분선을 추가합니다."
-- /rb sum space before
L["Add Before Summary"] = "요약 앞에 추가"
L["Add a empty line before stat summary"] = "능력치 요약 앞에 구분선을 추가합니다."
-- /rb sum space after
L["Add After Summary"] = "요약 뒤에 추가"
L["Add a empty line after stat summary"] = "능력치 요약 뒤에 구분선을 추가합니다."
-- /rb sum icon
L["Show Icon"] = "아이콘 표시"
L["Show the sigma icon before summary listing"] = "요약 목록 앞에 시그마 아이콘을 표시합니다."
-- /rb sum title
L["Show Title Text"] = "제목 표시"
L["Show the title text before summary listing"] = "요약 목록 앞에 제목을 표시합니다."
-- /rb sum showzerostat
L["Show Zero Value Stats"] = "제로 능력치 표시"
L["Show zero value stats in summary for consistancy"] = "통일되게 보이도록 대한 요약에 제로값의 능력치를 표시합니다."
-- /rb sum calcsum
L["Calculate Stat Sum"] = "능력치 합계 계산"
L["Calculate the total stats for the item"] = "아이템에 대한 총 능력치를 계산합니다."
-- /rb sum calcdiff
L["Calculate Stat Diff"] = "능력치 차이 계산"
L["Calculate the stat difference for the item and equipped items"] = "선택한 아이템과 착용한 아이템의 능력치 차이를 계산합니다."
-- /rb sum sort
L["Sort StatSummary Alphabetically"] = "능력치 요약 정렬"
L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "능력치 요약을 알파벳순으로 정렬합니다, 능력치별로 정렬하려면 비활성화하세요.(기본, 물리, 주문, 방어)"
-- /rb sum avoidhasblock
L["Include Block Chance In Avoidance Summary"] = "방어행동 (Avoidance) 요약에 방패 막기 포함"
L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "방어행동 (Avoidance) 요약에 방패박기를 포함시킵니다. 회피, 무기 막기, 빗맞힘만 포함시키려면 비활성화하세요."
---------------------------------------------------------------------------
-- /rb sum basic
L["Stat - Basic"] = "능력치 - 기본"
L["Choose basic stats for summary"] = "기본 능력치를 선택합니다."
-- /rb sum basic hp
L["Sum Health"] = "생명력 합계"
L["Health <- Health, Stamina"] = "생명력 <- 생명력, 체력"
-- /rb sum basic mp
L["Sum Mana"] = "마나 합계"
L["Mana <- Mana, Intellect"] = "마나 < 마나, 지능"
-- /rb sum basic mp5
L["Sum Mana Regen"] = "마나 회복 합계"
L["Mana Regen <- Mana Regen, Spirit"] = "마나 회복 <- 마나 회복, 정신력"
-- /rb sum basic mp5nc
L["Sum Mana Regen while not casting"] = "비시전중 마나 회복"
L["Mana Regen while not casting <- Spirit"] = "비시전중 마나 회복 <- 정신력"
-- /rb sum basic hp5
L["Sum Health Regen"] = "생명력 회복 합계"
L["Health Regen <- Health Regen"] = "생명력 회복 <- 생명력 회복"
-- /rb sum basic hp5oc
L["Sum Health Regen when out of combat"] = "비전투중 생명력 회복"
L["Health Regen when out of combat <- Spirit"] = "비전투중 생명력 회복 <- 정신력"
-- /rb sum basic str
L["Sum Strength"] = "힘 합계"
L["Strength Summary"] = "힘 요약"
-- /rb sum basic agi
L["Sum Agility"] = "민첩성 합계"
L["Agility Summary"] = "민첩성 요약"
-- /rb sum basic sta
L["Sum Stamina"] = "체력 합계"
L["Stamina Summary"] = "체력 요약"
-- /rb sum basic int
L["Sum Intellect"] = "지능 합계"
L["Intellect Summary"] = "지능 요약"
-- /rb sum basic spi
L["Sum Spirit"] = "정신력 합계"
L["Spirit Summary"] = "정신력 요약"
---------------------------------------------------------------------------
-- /rb sum physical
L["Stat - Physical"] = "능력치 - 물리"
L["Choose physical damage stats for summary"] = "물리 공격력 능력치를 선택합니다."
-- /rb sum physical ap
L["Sum Attack Power"] = "전투력 합계"
L["Attack Power <- Attack Power, Strength, Agility"] = "전투력 <- 전투력, 힘, 민첩성"
-- /rb sum physical rap
L["Sum Ranged Attack Power"] = "원거리 전투력 합계"
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "원거리 전투력 <- 원거리 전투력, 지능, 전투력, 힘, 민첩성"
-- /rb sum physical fap
L["Sum Feral Attack Power"] = "야성 전투력 합계"
L["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "야성 전투력 <- 야성 전투력, 전투력, 힘, 민첩성"
-- /rb sum physical hit
L["Sum Hit Chance"] = "적중률 합계"
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "적중률 <- 적중도, 무기 숙련도"
-- /rb sum physical hitrating
L["Sum Hit Rating"] = "적중도 합계"
L["Hit Rating Summary"] = "적중도 요약"
-- /rb sum physical crit
L["Sum Crit Chance"] = "치명타율 합계"
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "치명타율 <- 치명타 적중도, 민첩성, 무기 숙련도"
-- /rb sum physical critrating
L["Sum Crit Rating"] = "치명타 적중도 합계"
L["Crit Rating Summary"] = "치명타 적중도 요약"
-- /rb sum physical haste
L["Sum Haste"] = "가속율 합계"
L["Haste <- Haste Rating"] = "가속율 <- 공격 가속도"
-- /rb sum physical hasterating
L["Sum Haste Rating"] = "공격 가속도 합계"
L["Haste Rating Summary"] = "공격 가속도 요약"
-- /rb sum physical rangedhit
L["Sum Ranged Hit Chance"] = "원거리 적중률 합계"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "원거리 적중률 <- 적중도, 무기 숙련도, 원거리 적중도"
-- /rb sum physical rangedhitrating
L["Sum Ranged Hit Rating"] = "원거리 적중도 합계"
L["Ranged Hit Rating Summary"] = "원거리 적중도 요약"
-- /rb sum physical rangedcrit
L["Sum Ranged Crit Chance"] = "원거리 치명타율 합계"
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "원거리 치명타율 <- 치명타 적중도, 민첩성, 무기 숙련도, 치명타 적중도"
-- /rb sum physical rangedcritrating
L["Sum Ranged Crit Rating"] = "원거리 치명타 적중도 합계"
L["Ranged Crit Rating Summary"] = "원거리 치명타 적중도 요약"
-- /rb sum physical rangedhaste
L["Sum Ranged Haste"] = "원거리 공격 가속율 합계"
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "원거리 공격 가속율 <- 공격 가속도, 원거리 가속율"
-- /rb sum physical rangedhasterating
L["Sum Ranged Haste Rating"] = "원거리 공격 가속도 합계"
L["Ranged Haste Rating Summary"] = "원거리 공격 가속도 요약"
-- /rb sum physical maxdamage
L["Sum Weapon Max Damage"] = "무기 최대 공격력 합계"
L["Weapon Max Damage Summary"] = "무기 최대 공격력 요약"
-- /rb sum physical ignorearmor
L["Sum Ignore Armor"] = "방어도 무시 합계"
L["Ignore Armor Summary"] = "방어도 무시 요약"
-- /rb sum physical arp
L["Sum Armor Penetration"] = "방어도 관통력 합계"
L["Armor Penetration Summary"] = "방어도 관통력 요약"
-- /rb sum physical weapondps
--L["Sum Weapon DPS"] = true
--L["Weapon DPS Summary"] = true
-- /rb sum physical wpn
L["Sum Weapon Skill"] = "무기 숙련 합계"
L["Weapon Skill <- Weapon Skill Rating"] = "무기 숙련 <- 무기 숙련도"
-- /rb sum physical exp
L["Sum Expertise"] = "숙련 합계"
L["Expertise <- Expertise Rating"] = "숙련 <- 숙련도"
-- /rb sum physical exprating
--L["Sum Expertise Rating"] = true
--L["Expertise Rating Summary"] = true
-- /rb sum physical arprating
L["Sum Armor Penetration Rating"] = "방어도 관통도 합계"
L["Armor Penetration Rating Summary"] = "방어도 관통도 요약"
---------------------------------------------------------------------------
-- /rb sum spell
L["Stat - Spell"] = "능력치 - 주문"
L["Choose spell damage and healing stats for summary"] = "주문 공격력과 치유량 능력치를 선택합니다."
-- /rb sum spell dmg
L["Sum Spell Damage"] = "주문 공격력 합계"
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "주문 공격력 <- 주문 공격력, 지능, 정신력, 체력"
-- /rb sum spell dmgholy
L["Sum Holy Spell Damage"] = "신성 주문 공격력 합계"
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "신성 주문 공격력 <- 신성 주문 공격력, 주문 공격력, 지능, 정신력"
-- /rb sum spell dmgarcane
L["Sum Arcane Spell Damage"] = "비전 주문 공격력 합계"
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "비전 주문 공격력 <- 비전 주문 공격력, 주문 공격력, 지능"
-- /rb sum spell dmgfire
L["Sum Fire Spell Damage"] = "화염 주문 공격력 합계"
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "화염 주문 공격력 <- 화염 주문 공격력, 주문 공격력, 지능, 체력"
-- /rb sum spell dmgnature
L["Sum Nature Spell Damage"] = "자연 주문 공격력 합계"
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "자연 주문 공격력 <- 자연 주문 공격력, 주문 공격력, 지능"
-- /rb sum spell dmgfrost
L["Sum Frost Spell Damage"] = "냉기 주문 공격력 합계"
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "냉기 주문 공격력 <- 냉기 주문 공격력, 주문 공격력, 지능"
-- /rb sum spell dmgshadow
L["Sum Shadow Spell Damage"] = "암흑 주문 공격력 합계"
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "암흑 주문 공격력 <- 암흑 주문 공격력, 주문 공격력, 지능, 정신력, 체력"
-- /rb sum spell heal
L["Sum Healing"] = "치유량 합계"
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "치유량 <- 치유량, 지능, 정신력, 민첩성, 힘"
-- /rb sum spell crit
L["Sum Spell Crit Chance"] = "주문 극대화율 합계"
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "주문 극대화율 <- 주문 극대화 적중도, 지능"
-- /rb sum spell hit
L["Sum Spell Hit Chance"] = "주문 적중율 합계"
L["Spell Hit Chance <- Spell Hit Rating"] = "주문 적중율 <- 주문 적중도"
-- /rb sum spell haste
L["Sum Spell Haste"] = "주문 가속 합계"
L["Spell Haste <- Spell Haste Rating"] = "주문 가속 <- 주문 가속도"
-- /rb sum spell pen
L["Sum Penetration"] = "주문 관통력 합계"
L["Spell Penetration Summary"] = "주문 관통력 요약"
-- /rb sum spell hitrating
L["Sum Spell Hit Rating"] = "주문 적중도 합계"
L["Spell Hit Rating Summary"] = "주문 적중도 요약"
-- /rb sum spell critrating
L["Sum Spell Crit Rating"] = "주문 극대화 적중도 합계"
L["Spell Crit Rating Summary"] = "주문 극대화 적중도 요약"
-- /rb sum spell hasterating
L["Sum Spell Haste Rating"] = "주문 가속도"
L["Spell Haste Rating Summary"] = "주문 가속도 요약"
---------------------------------------------------------------------------
-- /rb sum tank
L["Stat - Tank"] = "능력치 - 방어"
L["Choose tank stats for summary"] = "방어 능력치를 선택합니다."
-- /rb sum tank armor
L["Sum Armor"] = "방어도 합계"
L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "방어도 <- 아이템 방어도, 방어도 보너스, 민첩성, 지능"
-- /rb sum tank blockvalue
L["Sum Block Value"] = "피해 방어량 합계"
L["Block Value <- Block Value, Strength"] = "피해 방어량 <- 피해 방어량, 힘"
-- /rb sum tank dodge
L["Sum Dodge Chance"] = "회피율 합계"
L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "회피율 <- 회피 숙련도, 민첩성, 방어 숙련도"
-- /rb sum tank parry
L["Sum Parry Chance"] = "무기 막기 확률 합계"
L["Parry Chance <- Parry Rating, Defense Rating"] = "무기 막기 확률 <- 무기 막기 숙련도, 방어 숙련도"
-- /rb sum tank block
L["Sum Block Chance"] = "방패 막기 확률 합계"
L["Block Chance <- Block Rating, Defense Rating"] = "방패 막기 확률 <- 방패 막기 숙련도, 방어 숙련도"
-- /rb sum tank avoidhit
L["Sum Hit Avoidance"] = "빗맞힘 합계"
L["Hit Avoidance <- Defense Rating"] = "빗맞힘 <- 방어 숙련도"
-- /rb sum tank avoidcrit
L["Sum Crit Avoidance"] = "치명타 감소 합계"
L["Crit Avoidance <- Defense Rating, Resilience"] = "치명타 감소 <- 방어 숙련도, 탄력도"
-- /rb sum tank neglectdodge
L["Sum Dodge Neglect"] = "회피 무시 합계"
L["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "회피 무시 <- 숙련도, 무기 숙련도"
-- /rb sum tank neglectparry
L["Sum Parry Neglect"] = "무기 막기 무시 합계"
L["Parry Neglect <- Expertise, Weapon Skill Rating"] = "무기 막기 무시 <- 숙련도, 무기 숙련도"
-- /rb sum tank neglectblock
L["Sum Block Neglect"] = "방패 막기 무시 합계"
L["Block Neglect <- Weapon Skill Rating"] = "방패 막기 무시 <- 무기 숙련도"
-- /rb sum tank resarcane
L["Sum Arcane Resistance"] = "비전 저항력 합계"
L["Arcane Resistance Summary"] = "비전 저항력 요약"
-- /rb sum tank resfire
L["Sum Fire Resistance"] = "화염 저항력 합계"
L["Fire Resistance Summary"] = "화염 저항력 요약"
-- /rb sum tank resnature
L["Sum Nature Resistance"] = "자연 저항력 합계"
L["Nature Resistance Summary"] = "자연 저항력 요약"
-- /rb sum tank resfrost
L["Sum Frost Resistance"] = "냉기 저항력 합계"
L["Frost Resistance Summary"] = "냉기 저항력 요약"
-- /rb sum tank resshadow
L["Sum Shadow Resistance"] = "암흑 저항력 합계"
L["Shadow Resistance Summary"] = "암흑 저항력 요약"
-- /rb sum tank dodgerating
L["Sum Dodge Rating"] = "회피 숙련도 합계"
L["Dodge Rating Summary"] = "회피 숙련도 요약"
-- /rb sum tank parryrating
L["Sum Parry Rating"] = "무기 막기 합계"
L["Parry Rating Summary"] = "무기 막기 숙련도 요약"
-- /rb sum tank blockrating
L["Sum Block Rating"] = "방패 막기 숙련도 합계"
L["Block Rating Summary"] = "방어 막기 숙련도 요약"
-- /rb sum tank res
L["Sum Resilience"] = "탄력 합계"
L["Resilience Summary"] = "탄력 요약"
-- /rb sum tank def
L["Sum Defense"] = "방어 숙련 합계"
L["Defense <- Defense Rating"] = "방어 숙련 <- 방어 숙련도"
-- /rb sum tank tp
L["Sum TankPoints"] = "탱킹 점수 (TankPoint) 합계"
L["TankPoints <- Health, Total Reduction"] = "탱킹 점수 (TankPoint) <- 생명력, 총 피해감소"
-- /rb sum tank tr
L["Sum Total Reduction"] = "총 피해감소 합계"
L["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "총 피해감소 <- 방어도, 회피, 무기 막기, 방패 막기, 피해 방어량, 방어 숙련, 탄력, 빗맞힘(자신), 치명타 감소, 몹강타, 피해감소 효과"
-- /rb sum tank avoid
L["Sum Avoidance"] = "총 방어행동 합계"
L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "방어행동 (Avoidance) <- 회피, 무기 막기, 빗맞힘, 방패 막기(선택적)"
---------------------------------------------------------------------------
-- /rb sum gemset
L["Gem Set"] = "보석 설정"
L["Select a gem set to configure"] = "보석 설정의 구성을 선택합니다."
L["Default Gem Set 1"] = "기본 보석 설정 1"
L["Default Gem Set 2"] = "기본 보석 설정 2"
L["Default Gem Set 3"] = "기본 보석 설정 3"
-- /rb sum gem
L["Auto fill empty gem slots"] = "빈 보석 슬롯을 자동으로 채웁니다."
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
L["ItemID or Link of the gem you would like to auto fill"] = "자동으로 채우고 싶은 보석의 아이템ID & 링크를 입력하세요."
L["<ItemID|Link>"] = "<아이템ID|링크>"
L["|cffffff7f%s|r is now set to |cffffff7f[%s]|r"] = "현재 |cffffff7f%s|r에 |cffffff7f[%s]|r 설정"
L["Invalid input: %s. ItemID or ItemLink required."] = "잘못된 입력값 : %s. 아이템ID 나 아이템 링크가 필요합니다."
L["Queried server for Gem: %s. Try again in 5 secs."] = "서버에 보석 조회중: %s. 5초 후 다시하세요."
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META
-- /rb sum gem2
L["Second set of default gems which can be toggled with a modifier key"] = true
L["Can't use the same modifier as Gem Set 3"] = true
-- /rb sum gem2 key
L["Toggle Key"] = "전환 키"
L["Use this key to toggle alternate gems"] = "대체 보석으로 전환하는데 사용할 키"
-- /rb sum gem3
L["Third set of default gems which can be toggled with a modifier key"] = true
L["Can't use the same modifier as Gem Set 2"] = true


-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "아이템레벨: "
L["ItemID: "] = "아이템ID: "
-----------------------
-- Matching Patterns --
-----------------------
-- Items to check --
--------------------
-- [Potent Ornate Topaz]
-- +6 Spell Damage, +5 Spell Crit Rating
--------------------
-- ZG enchant
-- +10 Defense Rating/+10 Stamina/+15 Block Value
--------------------
-- [Glinting Flam Spessarite]
-- +3 Hit Rating and +3 Agility
--------------------
-- ItemID: 22589
-- [Atiesh, Greatstaff of the Guardian] warlock version
-- Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.
--------------------
-- [Brilliant Wizard Oil]
-- Use: While applied to target weapon it increases spell damage by up to 36 and increases spell critical strike rating by 14 . Lasts for 30 minutes.
----------------------------------------------------------------------------------------------------
-- I redesigned the tooltip scanner using a more locale friendly, 2 pass matching matching algorithm.
--
-- The first pass searches for the rating number, the patterns are read from L["numberPatterns"] here,
-- " by (%d+)" will match strings like: "Increases defense rating by 16."
-- "%+(%d+)" will match strings like: "+10 Defense Rating"
-- You can add additional patterns if needed, its not limited to 2 patterns.
-- The separators are a table of strings used to break up a line into multiple lines what will be parsed seperately.
-- For example "+3 Hit Rating, +5 Spell Crit Rating" will be split into "+3 Hit Rating" and " +5 Spell Crit Rating"
--
-- The second pass searches for the rating name, the names are read from L["statList"] here,
-- It will look through the table in order, so you can put common strings at the begining to speed up the search,
-- and longer strings should be listed first, like "spell critical strike" should be listed before "critical strike",
-- this way "spell critical strike" does get matched by "critical strike".
-- Strings need to be in lower case letters, because string.lower is called on lookup
--
-- IMPORTANT: there may not exist a one-to-one correspondence, meaning you can't just translate this file,
-- but will need to go in game and find out what needs to be put in here.
-- For example, in english I found 3 different strings that maps to CR_CRIT_MELEE: "critical strike", "critical hit" and "crit".
-- You will need to find out every string that represents CR_CRIT_MELEE, and so on.
-- In other languages there may be 5 different strings that should all map to CR_CRIT_MELEE.
-- so please check in game that you have all strings, and not translate directly off this table.
--
-- Tip1: When doing localizations, I recommend you set debugging to true in RatingBuster.lua
-- Find RatingBuster:SetDebugging(false) and change it to RatingBuster:SetDebugging(true)
-- or you can type /rb debug to enable it in game
--
-- Tip2: The strings are passed into string.find, so you should escape the magic characters ^$()%.[]*+-? with a %
L["numberPatterns"] = {
	{pattern = "(%d+)만큼", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterNumber",},
	--{pattern = "grant.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	--{pattern = "add.-(%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID:24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
L["separators"] = {
	"/", " and ", ",", "%. ", " for ", "&", ":",
	-- Fix for [Mirror of Truth]
	-- Equip: Chance on melee and ranged critical strike to increase your attack power by 1000 for 10 secs.
	-- 1000 was falsely detected detected as ranged critical strike
	"increase your",
}
--[[ Rating ID
CR_WEAPON_SKILL = 1;
CR_DEFENSE_SKILL = 2;
CR_DODGE = 3;
CR_PARRY = 4;
CR_BLOCK = 5;
CR_HIT_MELEE = 6;
CR_HIT_RANGED = 7;
CR_HIT_SPELL = 8;
CR_CRIT_MELEE = 9;
CR_CRIT_RANGED = 10;
CR_CRIT_SPELL = 11;
CR_HIT_TAKEN_MELEE = 12;
CR_HIT_TAKEN_RANGED = 13;
CR_HIT_TAKEN_SPELL = 14;
CR_CRIT_TAKEN_MELEE = 15;
CR_CRIT_TAKEN_RANGED = 16;
CR_CRIT_TAKEN_SPELL = 17;
CR_HASTE_MELEE = 18;
CR_HASTE_RANGED = 19;
CR_HASTE_SPELL = 20;
CR_WEAPON_SKILL_MAINHAND = 21;
CR_WEAPON_SKILL_OFFHAND = 22;
CR_WEAPON_SKILL_RANGED = 23;
CR_EXPERTISE = 24;
--
SPELL_STAT1_NAME = "힘"
SPELL_STAT2_NAME = "민첩성"
SPELL_STAT3_NAME = "체력"
SPELL_STAT4_NAME = "지능"
SPELL_STAT5_NAME = "정신력"
--]]
L["statList"] = {
	{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
	{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
	{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
	{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
	{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
	{pattern = "방어 숙련도", id = CR_DEFENSE_SKILL},
	{pattern = "회피 숙련도", id = CR_DODGE},
	{pattern = "방패 막기 숙련도", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "무기 막기 숙련도", id = CR_PARRY},

	{pattern = "주문 극대화 적중도", id = CR_CRIT_SPELL},
	{pattern = "주문의 극대화 적중도", id = CR_CRIT_SPELL},
--		{pattern = "spell critical rating", id = CR_CRIT_SPELL},
--		{pattern = "spell crit rating", id = CR_CRIT_SPELL},
	{pattern = "원거리 치명타 적중도", id = CR_CRIT_RANGED},
	{pattern = "원거리 치명타", id = CR_CRIT_RANGED}, -- [Heartseeker Scope]
--		{pattern = "ranged critical hit rating", id = CR_CRIT_RANGED},
--		{pattern = "ranged critical rating", id = CR_CRIT_RANGED},
--		{pattern = "ranged crit rating", id = CR_CRIT_RANGED},
	{pattern = "치명타 적중도", id = CR_CRIT_MELEE},
	{pattern = "근접 치명타 적중도", id = CR_CRIT_MELEE},
	{pattern = "critical rating", id = CR_CRIT_MELEE},
--		{pattern = "crit rating", id = CR_CRIT_MELEE},

	{pattern = "주문 적중도", id = CR_HIT_SPELL},
	{pattern = "원거리 적중도", id = CR_HIT_RANGED},
	{pattern = "적중도", id = CR_HIT_MELEE},

	{pattern = "탄력도", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating

	{pattern = "주문 가속도", id = CR_HASTE_SPELL},
	{pattern = "주문 시전 가속도", id = CR_HASTE_SPELL},
	{pattern = "원거리 공격 가속도", id = CR_HASTE_RANGED},
	{pattern = "공격 가속도", id = CR_HASTE_MELEE},
	{pattern = "가속도", id = CR_HASTE_MELEE}, -- [Drums of Battle]

	{pattern = "무기 숙련도", id = CR_WEAPON_SKILL},
	{pattern = "숙련도", id = CR_EXPERTISE},
	{pattern = "숙련", id = CR_EXPERTISE}, -- WotLK beta Gem

	{pattern = "근접 공격 회피", id = CR_HIT_TAKEN_MELEE},
	{pattern = "방어구 관통력", id = CR_ARMOR_PENETRATION},	--armor penetration rating
	{pattern = string.lower(ARMOR), id = ARMOR},
	--[[
	{pattern = "dagger skill rating", id = CR_WEAPON_SKILL},
	{pattern = "sword skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed swords skill rating", id = CR_WEAPON_SKILL},
	{pattern = "axe skill rating", id = CR_WEAPON_SKILL},
	{pattern = "bow skill rating", id = CR_WEAPON_SKILL},
	{pattern = "crossbow skill rating", id = CR_WEAPON_SKILL},
	{pattern = "gun skill rating", id = CR_WEAPON_SKILL},
	{pattern = "feral combat skill rating", id = CR_WEAPON_SKILL},
	{pattern = "mace skill rating", id = CR_WEAPON_SKILL},
	{pattern = "polearm skill rating", id = CR_WEAPON_SKILL},
	{pattern = "staff skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed axes skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed maces skill rating", id = CR_WEAPON_SKILL},
	{pattern = "fist weapons skill rating", id = CR_WEAPON_SKILL},
	--]]
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "치명타 $value%"
L["$value% Spell Crit"] = "극대화 $value%"
L["$value% Dodge"] = "회피 $value%"
L["$value HP"] = "생명력 $value"
L["$value MP"] = "마나 $value"
L["$value AP"] = "전투력 $value"
L["$value RAP"] = "원거리 $value"
L["$value Dmg"] = "주문력 $value"
L["$value Heal"] = "치유량 $value"
L["$value Armor"] = "방어도 $value"
L["$value Block"] = "방피량 $value"
L["$value MP5"] = "$value MP5"
L["$value MP5(NC)"] = "$value MP5(비시전)"
L["$value HP5"] = "$value HP5"
L["$value to be Dodged/Parried"] = "회피/막음 $value"
L["$value to be Crit"] = "치명타 적중 $value"
L["$value Crit Dmg Taken"] = "치명타 피해 $value"
L["$value DOT Dmg Taken"] = "DoT 피해 $value"
L["$value% Parry"] = "무막 $value%"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "주문 $value"

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "능력치 요약"