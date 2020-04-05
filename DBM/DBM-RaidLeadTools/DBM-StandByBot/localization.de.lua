
if GetLocale() ~= "deDE" then return end

local L = DBM_StandbyBot_Translations

L.InRaidGroup		= "Bitte verlasse erst die Schlachtgruppe bevor du dich Standby meldest."
L.LeftRaidGroup 	= "Du hast die Schlachtgruppe verlassen. Bitte vergiss nicht dich Standby zu melden indem du \"!sb\" an mich flüsterst."
L.AddedSBUser		= "Du bist nun Standby. Bitte sei Verfügbar bis du benötigt wirst oder von der Liste entfernt wurdest."
L.UserIsAllreadySB	= "Entschuldigung, aber du bist schon Standby. Wenn du dich von der SB Liste löschen willst verwende \"!sb off\"."
L.NotStandby		= "Entschuldigung, du bist nicht Standby, um dich SB zu melden bitte \"!sb\" an mich flüstern."
L.NoLongerStandby	= "Du bist nun nichtmehr Standby. Du warst für %d Stunden und %d Minuten Standby."
L.PostStandybyList	= "Aktuell Standby:"

L.Local_AddedPlayer	= "[SB]: %s nun auf Standby."
L.Local_RemovedPlayer	= "[SB]: %s ist nichtmehr auf Standby."
L.Local_CantRemove	= "Der Spieler konnte nicht entfernt werden."
L.Local_CleanList	= "Die SB Liste wurde geleert aufgrund einer Aufforderung von %s."

L.Current_StandbyTime	= "Standby Zeiten vom %s:"
L.DateTimeFormat	= "%c"

L.History_OnJoin	= "[%s]: %s ist nun SB"
L.History_OnLeave	= "[%s]: %s ist nichtmehr SB nach %s Min"
L.SB_History_Saved	= "Die Standbyliste wurde gespeichert unter ID %s."
L.SB_History_NotSaved	= "Kein Spieler war Standby -> es wurde keine History gespeichert"

L.SB_History_Line	= "[ID=%d] Schlachtzug vom %s mit %d Spielern"


-- GUI
L.TabCategory_Standby	= "Standby-Bot"
L.AreaGeneral		= "Allgemeine Standby-Bot Einstellungen"
L.Enable		= "Aktiviere Standby-Bot (!sb)"
L.SendWhispers		= "Informiere spieler über SB beim Verlasen der Schlachtgruppe"
L.AreaStandbyHistory	= "Standby History"
L.NoHistoryAvailable	= "Es gibt aktuell keine gespeicherten Schlachtgruppe"

L.SB_Documentation	= [[Dieses Standby Modul erlaubt es Raidleadern spieler zu verwalten die aktuell nicht mitraiden können da beispielsweise der Schlachtzug voll ist. Alle angegebenen Befehle können im Gildenchat eingegeben werden.

!sb               - zeigt die aktuellen SB Spieler
!sb times         - zeigt die Zeiten der Spieler an
!sb add <nick>    - fügt einen neuen Spieler manuell hinzu
!sb del <nick>    - löscht einen Spieler manuell
!sb save          - sichert die Schlachtgruppe und beendet SB
!sb reset         - löscht unwiederbringlich alle SB Daten
!sb history [id]  - Zeigt die vergangenen SB Listen

Spieler die sich Standby melden wollen müssen '!sb' an den Spieler flüstern der dieses Mod verwendet bzw. denjenigen der im Gildenchat auf '!sb' reagiert. Eine Bestätigung wird an den Spieler verschickt. Um sich von der SB Liste zu löschen muss man '!sb off' flüstern.
]]

L.Button_ShowClients		= "Zeige SB-Bot Versionen"
L.Local_NoRaid			= "Du musst in einem Schlachtzug sein um diese Funktion zu nutzen."


