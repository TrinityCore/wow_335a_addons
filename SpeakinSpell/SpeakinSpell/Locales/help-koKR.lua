-- Author      : RisM
-- Create Date : 5/21/2009 10:56:30 PM

-- Korean localization file for koKR.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local HELPFILE = AceLocale:NewLocale("SpeakinSpell_HELPFILE", "koKR", false)
if not HELPFILE then return end

SpeakinSpell:PrintLoading("Locales/help-koKR.lua")

----------------------------------------------------------------------------------------
--[[ The format of each page is as follows:
	["Chapter Title"] = "내용"
--]]
----------------------------------------------------------------------------------------
HELPFILE.PAGES = {

----------------------------------------------------------------------------------------
["1. SpeakinSpell이란?"] = {
order = 1,
Summary = "About SpeakinSpell",
Contents = [[

재미 그리고/또는 유용함, SpeakSpell은 아이템, 지속효과, 그외의 이벤트, 그리고 사용자 정의 매크로 뿐만 아니라 마법과 다른 능력들을 사용할 때 채팅상에 알림으로 무작위 문구들을 사용할 수 있습니다.

모든 직업군에서 작동합니다. 많은 다른 상황들에서 대해서도 설정이 가능합니다.

Curse 다운로드 페이지
http://wow.curse.com/downloads/wow-addons/details/speakinspell.aspx

Project 홈페이지:
http://www.wowace.com/projects/speakinspell/

다른 추가사항 요청이나 버그들을 이곳에 보내주시기 바랍니다
http://www.wowace.com/projects/speakinspell/create-ticket/

제작자 : Stonarius(Antonidas)
독일어 번역 : LeXiN
한국어 번역 : 배신자협회,호드머리(달라란)
베타 테스팅 : Meneldill(Antonidas)

그리고 많은 다른 훌륭한 애드온들로부터 많은 아이디어를 제공받았습니다. (아래 감사말을 보세요)
]],
},

----------------------------------------------------------------------------------------
["2. 기본 사용법"] = {
order = 2,
Summary = "Getting Started with SpeakinSpell",
Contents = [[

몇개의 쉬운 단계들로 SpeakinSpell를 설정하는 방법

1. 로그인을 하시고 당신의 케릭을 플레이하세요

2. 당신이 SpeakinSpell를 이용하여 알리고 싶어하는 능력들을 활성화하고, 다른 지속효과들을 발생시키고, 다른 감지할 수 있는 이벤트들을 직면하세요.

3. 인터페이스 옵션창에 띄우기 위해 "/마법알림"을 입력하세요.

4. 새로운 마법 또는 다른 이벤트들에 대한 설정을 만들기 위해 "새로 만들기..."를 클릭하거나 "/마법알림 만들기"를 입력하세요.

5. 목록에서 마법 또는 이벤트를 선택하고 "선택된 이벤트 만들기" 버튼을 클릭하세요. 당신은 마법 또는 이벤트 설정 페이지로 이동할 것입니다.

6. 당신의 구미에 맞게 설정을 바꾸고 당신이 원하는 만큼 많은 문구들을 적으세요. 이제 당신이 해당 마법을 시전하거나 해당 이벤트를 만날때마다, SpeakinSpell은 해당 마법, 이벤트에 대해서 당신이 지정한 채널이나 다른 규칙을 사용하여 정해놓은 많은 문구들 중 하나를 무작위로 전송할 것입니다.

7. 당신이 더이상 새로운 알림 아이디어가 바닥날때까지 반복하세요.
]],
},

----------------------------------------------------------------------------------------
["3. 특징"] = {
order = 3,
Summary = "Overview of All Features",
Contents = [[

사용자 정의 문구들의 목록(당신을 위해 몇몇 초기설정도 예로써 함께 제공됩니다)에서 무작위로 선택을 통해 "이벤트들"의 다양함을 감지, 그것들을 자동으로 알릴 수 있습니다. 다음을 포함합니다. :
- 당신이 시전하는 마법들
- 다른 직업군에 대한 모든 능력들(전사의 영웅의 일격 또한 기술적으로 "마법"으로 간주합니다.) 
- 당신의 행동바에 있는 당신이 장비할 수 있는 어떤 것
- 아이템들
- 지속효과들 (당신이 당신자신으로 부터 받은 버프들)
- 그외 이벤트들 (Login, etc)
- 당신이 "/마법알림 매크로 어떤것"을 입력할때마다

마법당 100개 이상의 문구들을 입력할 수 있습니다.

각 마법당 문구들을 무작위로 당신이 선택하는 어떠한 채팅 채널로 지정할 수 있습니다.

다른 시나리오로 다른 채널 옵션들을 지원합니다. : 단독플레이, 파티, 공대, 전장, 그리고 투기장.

인터페이스 옵션창을 통해서 모든 설정이 가능합니다.

모든 직업군의 많은 마법들에 대한 재미있는 기본 문구들을 포함합니다.

당신의 모든 설정들은 해당 케릭터에만 적용됩니다. 모든 사용자 정의 문구들과 다른 설정들은 케릭터별로 독립적으로 저장됩니다.

<플레이어>, <대상>, <대상직업>, <대상종족>, 그리고 기타등등과 같은 많은 대체 변수들을 지원합니다.

한줄에 두번 주어지는 마법에 대해서는 같은 문구로 절대 말하지 않습니다.

한가지 마법사용 알림에 대하여 무작위 확률을 설정할 수 있습니다. 이것은 마법당 사용자가 설정할 수 있는 퍼센트 확률입니다. 이것은 롤플레잉 목적 또는 당신이 채팅상에 생성하는 마법유발량을 조절하므로써 스펨적 요소를 줄이는데 유용하게 사용될 수 있습니다.

각 전투 그리고/또는 각 대상에 대한 이벤트 알림을 제한 하는 설정이 가능합니다. -- Translation Kor 3.2.0.04 Complete

각 마법별로 마법알림들에 쿨타임을 사용하도록 설정할 수 있습니다. 이것은 빈번히 사용되는 마법들의 경우 너무 자주 마법이 시전됨을 알리는 것을 방지할 수 있습니다.

당신의 마법 대상에게 귓속말로 문구를 전달할 수 있습니다. 이것은 부활, 자극, 파워 주입계열 마법들에 유용하게 사용될 수 있습니다.

당신이 당신의 "매크로들"에 대해 칭찬을 받을때 "/마법알림 광고"를 사용함으로써 당신의 친구에게 SpeakinSpell에 관해서 말할 수 있습니다. 무작위 광고문구들 중 몇개는 재미있습니다. 그렇습니다. 이것은 채팅상에서 무작위 문구들을 살포하는 애드온입니다. 그리고, 이것은 이것이 무작위 문구들을 살포할 수 있는 능력이 있다는 것을 광고하는 문구들을 전송하는 한 형태입니다. "/마법알림 광고"에 대한 더 많은 향상된 옵션들에 대해서는 게임상에서 "/마법알림 도움말" 사용하시기 바랍니다.

Login과 같은 "9. 그외의 이벤트들"의 감지. 완벽한 목록에 대해서는 게임상에서 "/마법알림 도움말"을 입력하세요

사용자 정의 매크로. 무작위 문구들로 알릴 수 있도록 설정할 수 있는 "_ 매크로 어떤것"이라 불리우는 가짜 마법 이벤트를 SpeakinSpell이 감지하도록 하기 위해서는 "/마법알림 매크로 어떤것"을 입력하세요. 이것은 무작위로 전쟁외침, 인사, 작별인사, 또는 당신이 정의하고 싶어하는 어떤것에 대해서 사용될 수 있습니다.
]],
},

----------------------------------------------------------------------------------------
["4. 슬러쉬 명령어"] = {
order = 4,
Summary = "/ss commands",
Contents = [[

/마법알림 - 옵션을 보여줍니다.
/마법알림 옵션 - 옵션을 보여줍니다.

/마법알림 도움말 - 이 도움말을 보여줍니다.
/마법알림 만들기 - 새로운 이벤트에 대한 메세지 설정을 만들기 위한 새로 만들기... 인터페이스를 엽니다.
/마법알림 메세지 - 당신의 현재 세팅을 편집하기 위한 메세지 설정 인터페이스를 엽니다.

/마법알림 초기화 - 모든 설정을 초기화합니다.

/마법알림 광고 - 당신의 친구들에게 이 애드온에 관하여 말합니다 (기본 채널을 사용합니다)
/마법알림 광고 /파 - 당신의 파티원들에게 이 애드온에 관하여 말합니다. (/말(일반) or /공(공격대) 또한 작동합니다)
/마법알림 광고 /귓 케릭명 - 당신의 친구 케릭명에게 이 애드온에 관하여 말합니다. 케릭명이 없을 경우 대상이 지정되어있다면 대상에게 귓속말을 합니다. 대상마저 없다면 자신에게 귓속말을 합니다.

/마법알림 매크로 <어떤것> - 소위 "내가 작성했을 때: /마법알림 매크로 <어떤것>"이라 불리우는 이벤트를 활성화합니다. 또한 "8. 사용자 매크로"에서도 볼 수 있습니다.

/ss testallsubs
- reports the value of all possible substitutions for the current event

/ss memory
- shows how much memory SpeakinSpell is using

/ss import
- open the Import New Data interface

/ss colors
- open the color options interface

]],
},

----------------------------------------------------------------------------------------
["5. 변수"] = {
order = 5,
Summary = "A comprehensive list of all substitutions you can use in your speeches, such as <target>, <caster>, <spellname>, etc.",
Contents = [[

각 무작위 메세지는 SpeakinSpell에 의해 자동으로 당신에게 제공되는 마법을 시전하는 플레이어, 마법의 대상, 그리고 몇몇 다른 정보들을 참조합니다.

다음은 이 형식을 사용하기 위해 당신이 무작위 메세지에 넣을 수 있는 완성된 변수목록이다.

<플레이어>
- 당신의 이름

<플레이어칭호>					-- <playertitle> Translation Kor 3.2.0.04 Complete
- 당신의 현재 칭호, 예를 들어 "탐험가"		-- <playertitle> explain Translation Kor 3.2.0.04 Complete

<시전자>
- 마법이나 효과를 시전하는 사람 또는 존재의 이름
- 항상 <플레이어>와 같지는 않다.

<대상>
- 당신이 마법을 시전하는 대상의 이름
- 가능한한 종종, 이것은 당신이 시전하는 마법의 실질적인 대상이 될것이다 (당신이 현재 선택한 대상일 필요는 없다.)

<대상직업>
- 당신의 대상의 직업, 예를 들어 "<대상직업>에게 시전합니다" 라고 하면 "성기사에게 시전합니다"가 됩니다.

<대상종족>
- 당신의 대상의 종족, 예를 들어 "<대상종족>에게 시전합니다" 라고 하면 "드워프에게 시전합니다"가 됩니다.

<주시대상>
- 주시대상의 이름 (/주시 or /focus)

<마법이름>
- 당신이 시전하고 있는 마법이 완성된 이름 (마법레벨은 포함되지 않습니다)

<마법등급>
- 마법의 등급
- 좀더 광범위한 유연성을 위해서 이 대체변수에는 괄호를 포함하지는 않습니다, 그래서 기본사용은 "<마법이름> (<마법등급>)" -> "낚시 (거장)" 또는 "전력 질주 (레벨 3)"이 될것입니다.

<소환수>
- 당신의 전투펫의 이름 (애완동물에 대한 사용이 아닙니다)
- 와우 LUA API 제한 때문에, 이 대체변수는 당신의 펫을 소환할때 작동하지는 않습니다. 이것은 단지 당신의 펫이 이미 소환된 후에만 작동합니다.

<TM>
- 상표 표시, 예를 들어 Stonarius의 마법과자™

<C>
- Copyright 표시, 예를 들어 Copyright © 2008

<R>
- 등록상표 표시, 예를 들어 Speak & Spell ® 은 Texas Instruments(또는 최소한 내가 가정할 수 있는)의 등록상표이다.

<무작위진영> -- <randomfaction> Translation Kor 3.2.0.04 Complete 
- 각 진영들(예를 들어 : 호드, 얼라이언스, 신도레이, 등등 80개 이상의 진영들)의 이름이 무작위로 선정될 것입니다.
- "<무작위진영>의 영광을 위하여!" 라고 문구를 작성하면 "잔달라 부족의 영광을 위하여!" 또는 많은 다른 무작위 진영들에 대한 문구가 될 수 있습니다.
- 무작위 진영들의 목록은 지속적으로 추가될 것입니다.

<무작위조롱> -- <randomtaunt> Translation Kor 3.2.0.04 Complete
- 모욕적인 이름(예를 들어 : 겁쟁이, 바보, 멍청이 등등)이 선정될 것입니다.
- "<무작위조롱> 죽어라!" 라고 문구를 작성하면 "멍청이 죽어라!" 또는 "겁쟁이 죽어라!" 또는 다른 많은 것이 될 수 있습니다.

==> <번역자 주석: <무작위진영> 과 <무작위조롱> 은 해당 로케일에서 임의적으로 제작자가 넣는것입니다. 서버에서 읽어들이는 것이 아닙니다. 따라서, 이 부분은 제가 임의로 몇개만 설정했습니다.>

<새줄> -- <newline> Translation Kor 3.2.0.04 Complete

- 이것은 글이 한줄 이상일때 문구를 나눌 수 있습니다. 그래서 당신은 동시에 두개의 문구를 알릴 수 있습니다.
- "호드를 위하여!<새줄>/환호" 는 당신이 선택한 채널에 "호드를 위하여!"를 알리고 나서, 동시에 "/환호" 를 수행합니다.

<서버> -- <realm> Translation Kor 3.2.0.04 Complete
- 당신이 속해 있는 서버명

<지역> -- <zone> Translation Kor 3.2.0.04 Complete
- 당신이 현재 있는 상위 지역, 장소, 위치명. 예를 들어 "달라란"

<하위지역> -- <subzone> Translation Kor 3.2.0.04 Complete
- 당신이 현재 속한 상위지역 아래의 하위지역영. 예를 들어 "명예의 골짜기"
- 일반적으로 이것은 당신의 미니맵 보여지는 지역명과 일치할 것입니다.

]],
},

----------------------------------------------------------------------------------------
["6. 변수 - 확장"] = {
order = 6,
Summary = "How to avoid talking about yourself in the third-person by using advanced substitution forms like <target|me>",
Contents = [[

<대상|나>
<대상|나자신>
<대상|____>

제3자에게 자기자신에 관해서 말하는 것을 피하기 위해 특정한 대체 문구를 허용합니다.

이것은 대상이 만약 자기자신이 아니라면 <대상> 처럼 작동합니다. 만일 대상이 자기자신일 경우 자기이름 대신 | 뒤에 사용되는 문구로 바뀝니다.

예를 들어, 사제가 신의 권능: 보호막을 알릴 경우, SpeakinSpell 문구는 "당황하지 마시오! 나는 피해로부터 <대상|나자신>을/를 보호하고 있습니다" 라고 씁니다.

당신이 당신의 친구 Stonarius에게 신의 권능: 보호막을 시전할때, 그것은 "당황하지 마시오! 나는 피해로부터 Stonarius을/를 보호하고 있습니다."가 될것입니다.

그리고 당신이 당신자신에게 시전할때에는, 당신 자신의 이름을 사용하는 대신에 "당황하지 마시오! 나는 나자신을 피해로부터 나자신을/를 보호하고 있습니다."라고 말할 것입니다.

<시전자|나>
<시전자|____>

만약 당신이 시전자라면 위와같이 쓸 수 있습니다.
]],
},

----------------------------------------------------------------------------------------
["7. Possessive Forms"] = {
order = 7,
Summary = "How to make SpeakinSpell use the correct possessive forms for names ending in 's'",
Contents = [[

Every substitution supports a possessive form, which will use the proper apostrophe for Stonarius' or Meneldill's, including:
<player's>
<focus'>
<pet's>
<selected's>
<mouseover's>
<randomfaction's>

... actually everything else too.

If the name ends in an S, it's possessive form will be like Stonarius', otherwise it will be like Meneldill's

If you are watching out for <third person|me> you can write <target's|mine>
]],
},

----------------------------------------------------------------------------------------
["8. Gender"] = {
order = 8,
Summary = "How to show male or female words in substitutions, based on the gender of your target",
Contents = [[

To refer to the gender of a substitution, use the * star symbol, followed by the text you want to show for a male and a female

Here is an example
The target is <target*male*female>

Combined with "third person or me" logic, we can write
<caster*he*she|I> cast a spell!

Possessive forms also work
<mouseover's*his*her|my> target is <mouseovertarget*a boy*a girl|me... hey!>

The male text always comes first, and then the female.  It's not sexist; it was arbitrary.

It chooses male or female text based on the gender of the unit whose name would otherwise be used.

If the gender is unknown or neutral, it will use the name instead.

]],
},

----------------------------------------------------------------------------------------
["9. <target> Info"] = {
order = 9,
Summary = [[Why doesn't it use the correct <target> name sometimes?

What if I'm focus casting?

What if I have the tank targetted but then use Healbot to raid heal someone else?]],
Contents = [[

왜 당신은 때때로 올바른 <대상> 이름을 사용하지 않으십니까?
만일 내가 주시대상에게 시전한다면 어떻게 될까요?
만일 내가 탱커를 대상으로 하고 있는데 공대힐을 하고 있다면 어떻게 될까요?

와우 인터페이스는 대상과 마법시전에 여러가지 방식을 제공합니다. 대상을 선택하고 마법을 시전하는 것은 그 여러가지 방식중 하나일 뿐입니다(기본은 대상에게 시전하는것). 잠시 마법을 먼저 클릭하고 나서 특별 커서를 얻은 다음 대상플레이어 또는 몹을 클릭하거나 주시대상시전(/focus,/주시)사용, 또는 매크로, 또는 대상과 자신의 마법들과 능력들을 시전하는 다른 애드온들을 통해 마법시전하는 여러가지 다른 방식들에 대해서 고려해봅시다.

SpeakingSpell은 당신의 <대상> 이름을 제공하는데에 있어 기본UI에 구축되어 있는 매크로의 %t를 사용하는 것과 같이 가능한한 자주 당신의 실질적인 마법대상을 사용할 것입니다. 그리고 그것은 당신이 당연히 예상하고 있는 것입니다.

그러나, 몇몇 경우에서, 마법이 시전되는 것이 SpeakinSpell에 통보될때 블리자드의 와우 LUA API가 마법대상정보를 제공하지 않습니다.

이러한 경우, SpeakinSpell은 최선의 추측을 해야합니다. 그것은 다음 단서들로부터 대상이름을 사용하려 할것입니다(이러한 순서로):

1) 마법시전이벤트 통지에서 제공하는 대상이름(만일 유효하다면, 그것은 실질적인 마법대상이 될것입니다)
2) 그렇지 않으면 만일 당신이 무엇인가를 선택했다면(UnitName("target") API), 당신이 현재 선택한 대상에게서 정보를 얻으려 할 것입니다.
3) 그렇지 않으면 만일 당신이 주시대상을 설정했다면(UintName("focus") API), 당신의 주시대상에게서 정보를 얻으려 할 것입니다.
4) 그렇지 않으면 자신에게 시전하는 것으로 간주하고 당신 자신의 이름을 사용할 것입니다.(UnitName("Player") API)

이 방식이 당신의 마법대상의 올바른 이름을 추론하는데에 높은 확률을 얻을 수 있습니다. 그러나, 그것이 와우내에서 다양한 방식의 마법시전이 존재하므로 100% 보장되지는 않습니다.

만일 당신이 대상없이 시전할 수 있는 마법들이나, 블리자드의 간단한 버그를 이용한 어떤 마법을 시전할 경우, 당신은 <대상>을 주의해서 사용해야 합니다. 그리고 <시전자>, <플레이어>, 그리고 <주시대상>과 같은 대체변수들이 당신의 문구들을 올바르게 만드는데 매우 유용하다는 것을 고려하시기 바랍니다.

이러한 제한은 또한 <대상종족>과 <대상직업>에도 적용됩니다.
]],
},

----------------------------------------------------------------------------------------
["10. Custom Macros"] = {
order = 10,
Summary = "How to create custom Speech Events",
Contents = [[

당신은 버튼클릭으로 무작위로 전쟁외침, 인사, 작별인사, 당신이 써놓은 농담목록, 또는 당신이 원하는 어떤 것을 외칠 수 있도록 SpeakinSpell을 사용할 수 있습니다.

SpeakinSpell 사용자 매크로는 어떠한 마법, 능력 또는 다른 감지된 이벤트와 같은 무작위 문구를 채팅상에서 사용하는 것과 같이 이벤트의 한종류로 알릴 수 있습니다.

당신은 다음과 같이 입력함으로써 사용자 매크로들을 만들고 사용할 수 있습니다.
/마법알림 매크로 내가 부르고 싶은 나의 매크로중 어떤것

만일 이것이 당신이 최초로 이러한 특정 매크로를 입력했던 것이라면, SpeakinSpell은 당신에게 이 이벤트에 대한 새로운 메세지 설정을 만들 수 있도록 할 것입니다.

만일 당신이 이미 "사용자 작성 이벤트: /마법알림 매크로 something" 이벤트에 대해서 메세지 설정을 만들었다면, "/마법알림 매크로 something"을 입력하는 것은 그 이벤트를 발생시키고 마법 이벤트와 같은 당신의 메세지중 하나를 말할 것입니다.

당신은 어떤 다른 매크로 명령들을 가지고 있던 가지고 있지 않던지 매크로에서(/m, /매) "/마법알림 매크로 something"을 넣을 수 있습니다.

(번역자 주석 : 여기서 의도하는 사용자 매크로에 대한 이야기는 사용자가 임의로 SpeakinSpell에서 인식할 수 있는 이벤트를 만들 수 있다는 것입니다. 예를 들어, "/마법알림 매크로 이벤트발생테스트" 이런식으로 입력한 후에 "/마법알림 만들기" 부분으로 가면 "/마법알림 매크로 이벤트발생테스트" 라는 것이 하나 추가되어있을 것입니다.
그것에 대해서 해당 세팅을 한 후에 자신의 매크로 중에 "/마법알림 매크로 이벤트발생테스트" 라는 문구를 하나 넣어두면 해당 매크로를 쓸때 "/마법알림 매크로 이벤트발생테스트"라는 것도 실행이 될것이고 그것이 실행될때 SpeakinSpell에 설정되어 있는 문구를 알리는 것입니다.)
]],
},

----------------------------------------------------------------------------------------
["11. 그외의 이벤트들"] = {
order = 11,
Summary = "A list of other Speech Events that SpeakinSpell can announce.",
Contents = [[

SpeakinSpell can also detect a variety of events which are not directly tied to casting spells.

There are several kinds of these other events, which fall into event type categories other than those used for the different kinds of spell events.

The following event types and specific events are currently supported:

-- Chat Events -- 
These events are triggered when someone says something to you in the chat

Chat Event: Whispered While In-Combat
- allows you to auto-reply with a randomized comment, for example "/r sorry can't talk right now, busy fighting with <selected>"
- <target> is the target of the event, meaning you, the player, who was the target of the whisper
- <caster> is the author of the message whispered to you
- <text> is a special substitution supported for this event only, and is the contents of the whisper.
- This can be used to relay the whisper into party chat for example "/p <caster> whispered me to say: <text>"
- This event will NOT be announced when you send a whisper to yourself

Chat Event: a guild member said "ding"
Chat Event: a party member said "ding"
- Searching for the word "ding" in the chat messages is not case-sensitive
- <caster> is the player who said "ding"
- For the guild chat version of this event, <target> is the name of the guild.  N/A to party chat.


-- Combat Events --
These events are miscellaneous combat-related events that are not directly tied to any of the other spell casting based events.

Combat Event: Entering Combat
Combat Event: Exiting Combat
- Theses two events are detected whenever you enter or exit the state of being "in combat" technically based on the WoW LUA API events PLAYER_REGEN_ENABLED and PLAYER_REGEN_DISABLED.

Combat Event: Yellow Damage (<damagetype>)
Combat Event: White Damage (<damagetype>)
- This is a group of events, Signalled when you score white or yellow damage with any spell, ability, or auto-attack
- Technically based on the Blizzard API event: COMBAT_LOG_EVENT_UNFILTERED, with eventtype="SPELL_DAMAGE" (yellow hits) or "SWING_DAMAGE" (white hits)
- <damagetype> is a string composed of all of the following that apply (in this order): 
- Crushing, Critical, Resisted, Blocked, Absorbed, Glancing, Killing Blow
- If none of those apply, then it will be a simple "Hit"
- example event name: "Combat Event: Yellow Damage (Critical, Killing Blow)" but many other permutations are also possible
- In addition to all standard substitutions, the following substitution values may also be used for these events:
- <damage> is the amount of damage dealt
- <school> is physical, arcane, fire, etc.
- <damagetype> has a substitution value that matches the <damagetype> in the event name
- <overkill> is a number >= 0 (<damagetype> will include "Killing Blow" only if overkill>0)
- <name> and <eventname> have the value "Yellow Damage (<damagetype>)"
- likewise, <displayname> is "Combat Event: Yellow Damage (<damagetype>)"
- however, <spellname> and <spelllink> will specify the spell or ability that was used to deal this damage
- all other standard substitutions apply as usual


-- NPC Interaction --
These events are related to interacting with NPCs and similar game objects such as mailboxes and barber chairs.

NPC: Open Gossip Window
- Signalled when right-clicking on most interactive NPCs
- Implemented by the Blizzard API notification event: GOSSIP_SHOW
- Many NPCs do not show this gossip window if they only offer a single option, but this event will fire in many of those cases anyway, though not 100% reliably unless there are 2 or more options in the gossip window

NPC: Talk to Vendor
- Signalled when you open an NPC vendor interface
- This event is sometimes preceded by the "NPC: Open Gossip Window" event, but not always

NPC: Talk to Trainer
- Signalled when you talk to a class trainer or profession trainer
- This event is usually preceded by the "NPC: Open Gossip Window" event, but not always

NPC: Talk to Flight Master
- Signalled when you open the "taxi map" interface from a Flight Master NPC
- This event is sometimes preceded by the "NPC: Open Gossip Window" event, but not always

NPC: Quest Greeting
- Fired when talking to an NPC that offers or accepts more than one quest, i.e. has more than one active or available quest. 
- This event is sometimes preceded by the "NPC: Open Gossip Window" event, but not always

NPC: Open Mailbox
- Signalled when you open the mailbox interface

NPC: Enter Barber Chair
NPC: Exit Barber Chair
- These events are announced when opening and closing the barber shop interface


-- Achievement Events --
These are signalled when someone earns an achievement

Achievement Earned by Me
- Announces when you earn an achievement.
- Supports the following event-specific substitutions (a bit more than the other achievement events):
- <achievement> is the name of the achievement
- <desc> describes the achievement
- <reward> is the reward (may be an empty string)
- <points> is how many points the achievement was worth
- <spelllink> creates a clickable link to the achievement info, as with a spell event

Achievement Earned by Someone Nearby
Achievement Earned by A Guild Member
- <target> and <caster> are the name of the player who earned the achievement
- example uses include "/t <caster> grats!", "/s grats <caster>", and "/congrats <caster>"
- For these events, <achievement> and <desc> use the same value as <spelllink>
- <reward> and <points> are not supported for these events, as they are when announcing your own achievements.


-- Misc. Events --
These miscellaneous events do not seem to fall into any other category

Misc. Event: SpeakinSpell Loaded
- This pseudo spell event is detected at login or whenever you reload your UI.

Misc. Event: Level Up
- Signalled when you level up

Misc. Event: a player sent me a rez
- Signalled when you are prompted to accept the rez
- <caster> is the caster of the rez spell
- <target> is you
- <spellname> and <spelllink> is unfortunately "a player sent me a rez"

Misc. Event: Open Trade Window
- Signalled when you open a trade window with another player
- <caster> is you
- <target> is the <selected> trade partner

Misc. Event: Changed Zone
Misc. Event: Changed Sub-Zone
- These two events are detected as you move around the world map.
- The Zone is the larger map region.  The Sub-Zone name is the smaller area, and what is usually displayed on your minimap.
- This applies to entering and exiting instances

Misc. Event: Begin /follow
Misc. Event: End /follow
- Announced when you begin or end auto-follow using the "/follow" command
- <target> is the name of the player you're following
]],
},

----------------------------------------------------------------------------------------
["12. Emotes"] = {
order = 12,
Summary = "How to use voice emotes and other slash commands in speeches",
Contents = [[

If you select Emote as a channel in the drop-down list, that represents the emote channel, which is equivalent to typing "/e makes strange gestures"

SpeakinSpell also supports the game's built-in voice emotes and other slash commands.

Just type them into your speeches with the slash at the beginning of a line like you normally would
/roar
/attacktarget
/yes
etc.

You can also use chat channel slash commands like /p to override the channel rules for a single speech.
/p usually I spam this macro in the /say channel, but this one message belongs in party chat
/2 this lets me spam global channel 2 in response to a SpeakinSpell event
etc.

You can also use SpeakinSpell to trigger itself by entering /ss commands into an event's random speeches
/ss macro fire spells
etc.

Other addons' commands usually work too
/wt
/qh settings
etc.

Any slash command supported by the game, or that you could use in a macro, will typically work.

Due to a limitation imposed by Blizzard, you can't use this feature to execute /cast and some other secure commands, because that could potentially be used for botting.  SpeakinSpell will show you a warning if you attempt to do this.
]],
},

----------------------------------------------------------------------------------------
["13. 변경 내역"] = {
order = 13,
Summary = "Where to look for the change history",
Contents = [[

중요사항 수준에 대한 완성된 버전 내역을 확인하려면 \Interface\Addons\SpeakinSpell\ChangeLog.txt를 참조하시기 바랍니다.

코드파일 수준에 대한 좀더 자세한 변경 내역을 확인하려면 웹사이트의 변경문서들을 확인하시기 바랍니다
다음 링크에서 "Changes"를 클릭하세요
http://wow.curse.com/downloads/wow-addons/details/speakinspell.aspx
]],
},

----------------------------------------------------------------------------------------
["14. 버전 숫자"] = {
order = 14,
Summary = "How to Interpret the Version Number",
Contents = [[

The current version number is displayed on the General Settings screen, and show in the chat when you login.

버전 숫자를 해석하는 방법

SpeakinSpell 버전숫자는 SpeakinSpell이 작성되고 테스트 되는 와우 클라이언트 버전 숫자로 작성되며, SpeakinSpell의 버전숫자 증가는 다음을 따릅니다.

예를 들어, SpeakinSpell 버전 3.0.0.05는 와우 클라이언트 버전 3.0.3에서 작성되었으며, 그 와우버전에서 5번째 릴리즈입니다.

와우 3.1.0이 나왔을때 다음 SpeakinSpell 릴리즈는 SpeakinSpell v3.1.0.01이 될것입니다.
]],
},

----------------------------------------------------------------------------------------
["15. 비영어 게임 클라이언드"] = {
order = 15,
Summary = "Does SpeakinSpell work in my language?",
Contents = [[

다른 언어에서 SpeakinSpell를 설치하는 방법

만일 SpeakinSpell이 아직 당신의 모국어로 지역화 하지 않았다할지라도, 걱정하지 마세요, 그것은 여전히 당신에게 작동할 수 있습니다.

핵심은 어떤 직업의 어떤 마법에서도 작동될 수 있고 또한 와우게임클라이언트의 어떠한 비영어 버전에서도 작동될수 있도록 개념을 설계합니다. 물론 슬러쉬 명령어들과 옵션 인터페이스에서의 이름들은 또한 영어로 표현할 것이며, 뿐만 아니라 초기 예시 마법설정과 무작위 문구들도 영어로 표현할 것입니다. 그러나, 사용자 선택 마법과 이벤트들을 감지하는 핵심 기능과 사용자 정의 문구들을 가지고 그것들을 알리는 것은 어떠한 언어에서도 그 기능을 수행할 것입니다.
]],
},

----------------------------------------------------------------------------------------
["16. 기원 이야기"] = {
order = 16,
Summary = [[The Origins of SpeakinSpell
(or... Lame Story of a Thanksgiving Dream)]],
Contents = [[

SpeakinSpell의 기원
(또는... 감사하는 마음에 대한 엉성한 이야기)


SpeakinSpell이라는 이름은 미국 Midwest에 있는 일반적 언어형태에 한 방식이고, 또한 일반적으로 아제로스의 드워프들에 의해 사용되어지기도 한다. 그리고 여기서, 우리는 "ing"로 끝나는 말에서 'g'를 빼고 Speaking 대신에 Speakin' 이라고 말하는 경향이 있다. 그래서 Speakin' Spell은 말하는 마법이다.

SpeakinSpell은 또한 1980년대 초반에 내가 자라면서 가지고 놀았던 교육적인 어린이 장난감을 참조하여 의도되었다.

http://en.wikipedia.org/wiki/Speak_&_Spell_(게임)

SpeakinSpell은 전적으로 내가 온라인상에서 발견했던 Ace3 라이브러리들과 지침서들을 사용하고, 코드조각들의 몇가지 예와 Titan, Omen, 그리고 Recount로 부터 애드온 구조 개념을 따르면서 작성되었다. (내가 높이 평가하는 모든 애드온들)

그것은 직업 특화 애드온인 법사용 Cryolysis 또는 흑마용 Necrosis에게서 영감을 얻었다. 저자의 메인 케릭터는 법사(Stonarius(Antonidas))이고, 나(저자)는 Cryolisis2의 무작위 문구형태, 특히 내자신이 부억에 있는 음식상자에 쓰여있는 광고문구들에게서 대부분 영감을 얻어 작성한 무작위 문구들를 사용하는 원기회복(법사마법)알림을 쓰면서 사용하는 유머를 매우 좋아했다.(예를 들어 중앙에 "이것은 불가능한 도전!™"이라고 쓰여진 박스. 심각하게 당신을 놀리는게 아니라, 그들이 불가능한 도전 이라는 단어를 상표화 하였다.)

불행하게도, Cryolysis2는 와우 3.0이 출시되었을때 깨져버렸고, 나는 무작위 문구 형태가 업데이트 되어 재작성된 Cryolysis3에서 새로운 저자에 의해 복구될 계획이 없었다는 것에 실망했다. 무언가 그것에 관해 행해져야만 했다...

나는 또한 Cryolysis2에서 내 자신의 사용자 무작위 문구들을 작성하는 것을 더 좋아했다. 그러나, 내가 LUA 파일들을 편집해야 하는것이 유일한 방식이었고, 거기서 나는 애드온의 업데이트된 새로운 버전을 설치할 때마다 내가 변경했던 것들을 잃을 수 밖에 없었고, 그것은 물론 LUA파일이 덮어씌워 지면서 내가 변경한 것들을 파괴하는 것이었다.

그래서 나는 변경문구들이 LUA 코드를 지원함에 있어서 변경문구들 부터 안전한 SavedVariable 파일에 저장되는 방식(패치와 패치 사이에서 애드온들이 작동되는 것이 유지될 필요가 있는)을 사용하므로써 결과적으로 미래의 패치가 내가 시간을 들여 마법을 시전할때 사용되는 가능한한 가장 채치있게 만든 사용자 문구들이 파괴되지 않도록 하면서 문구들을 편집할 수 있는 게임상 인터페이스를 계획했다.

나는 또한 (Cryolysis2에 있는) 다중 알림들이 5인 파티에서 좋을 수 있는 반면, 그것들이 25인 공격대에서 같은 전투를 통해 같은 몹을 20번 정도 양변하는 내가 종종 그것좀 꺼 달라고 요청받은 그러한 상황에서는 매우 짜증나게 된다는 것을 발견하게 되었다.

나는 오랜 시간동안,아마 거의 1년정도, 그러한 애드온을 만드는 것에 관해 계획했으나,  배움의 굴곡에 직면하는 것을 걱정했다. 내가 C++에 10년정도 경험이 있다 할지라도 LUA 프로그래밍을 배우는 것은 3.0 패치 이후 성기사를 플레이하는 방법을 다시 배우는 것과 같고, 나는 단지 그것을 다루는 것 같이 느껴지지 않았다. 그러나, 그러던 어느날 나는 우연히 Speak & Spell 장난감에 관해 생각하게 되었고, 애드온의 이름을 Speakin' Spell이라 지으며, "좋아, 이름은 그걸로 정하고, 이제 절대적으로 그러한 애드온을 만들어야만 한다."라고 생각하게 되었다. 그리고 다음날 2008년 추수감사절의 오랜 주말이 시작되었고, 나에게 많은 시간이 주어졌다...

그래서 SpeakinSpell은 탄생되었다.

SpeakinSpell를 사용에 대해서 당신께 감사합니다. 이것은 Mannabiscuitalicious!™ 입니다. :p
]],
},

----------------------------------------------------------------------------------------
["17. 감사말"] = {
order = 17,
Summary = [[SpeakinSpell is brought to you by an educational children's toy, the letter 'R', and contributions from players like you...]],
Contents = [[

SpeakinSpell was created by |cff33ff99Stonarius of Antonidas|r

Additional coding by...
- Duerma

Primary Beta Testing, Arena Team Pwnage, Key Grip...
- Meneldill

Translators who help me in so many other ways...
- leXin for the German deDE
- troth75 for the Korean koKR

Many of the default speeches were blatantly stolen from...
- Cryolysis2
- Necrosis
- LunarSphere
- Ultimate Warcraft Battlecry Generator

Thanks for the open license guys!  I hope you like what I did with it.

Additional Content Packs Written by...
- Stonarius
- Meneldill
- leXin
- troth75
- Folji
- Dire Lemming

Special thanks to the authors of these addons that I used for copy-paste... *Ahem* I mean example code...
- Titan
- Omen
- Recount
- Healbot 
- Mountiful
- the WowAce libs

Additional thanks to...
- Blizzard Entertainment for this great game! ... hire me??
- The community on the wowace forums
- curse.com
- Microsoft Visual Studio, SubVersioN, and TortoiseSVN
- Texas Instruments for enabling E.T. to phone home
- The Order of the Stick
- Mom and Dad
- YOU!!

SpeakinSpell is made from 83% Recycled Materials.

No animals were harmed in the making of this addon.

... Well, the hunter popped a sheep with his aoe, but I resheeped with my /cast [target=focus] macro, and automatically said "Baaah! sheeped again <target>?!" and it was all good...
]],
},

----------------------------------------------------------------------------------------
} -- end HELPFILE.PAGES


-- if the user types in an invalid "/ss foo" it will open this help page to show the valid /ss commands
HELPFILE.SLASH_COMMANDS = 4

