-- By Zisu (http://www.curse-gaming.com/en/profile-122056.html)
local L = LibStub("AceLocale-3.0"):NewLocale("HealOrganizer", "zhTW", false)

if L then
	L["CLOSE"] = "關閉";
	L["RESET"] = "重置";
	L["RAID"] = "團隊";
	L["CHANNEL"] = "頻道";
	L["DISPEL"] = "驅魔";
	L["MT"] = "MT";
	L["HEAL"] = "治療";
	L["DECURSE"] = "解咒";
	L["REMAINS"] = "剩餘";
	L["ARRANGEMENT"] = "安排";
	L["BROADCAST"] = "廣播";
	L["OPTIONS"] = "選項";
	L["STATS"] = "狀態";
	L["PALADIN"] = "聖騎士";
	L["DRUID"] = "德魯伊";
	L["PRIEST"] = "牧師";
	L["SHAMAN"] = "薩滿";
	L["PALADINS"] = "聖騎士";
	L["DRUIDS"] = "德魯伊";
	L["PRIESTS"] = "牧師";
	L["SHAMANS"] = "薩滿";
	L["HEALARRANGEMENT"] = "治療安排";
	L["FFA"] = "尚未安排"; -- was der rest machen darf
	L["NO_CHANNEL"] = "在廣播治療安排前你必須先加入頻道 %q";
	L["NOT_IN_RAID"] = "你不在一個團隊中";
	L["FREE"] = "空";
	L["EDIT_LABEL"] = "新增標籤到小隊 %u";
	L["SHOW_DIALOG"] = "顯示/隱藏對話框";
	L["LABELS"] = "標籤";
	L["SAVEAS"] = "另存為";
	L["SET_SAVEAS"] = "輸入新組合的名稱";
	L["SET_DEFAULT"] = "預設";
	L["SET_CANNOT_DELETE_DEFAULT"] = "你不能刪除預設組合";
	L["SET_CANNOT_SAVE_DEFAULT"] = "你不能覆寫預設組合";
	L["SET_ALREADY_EXISTS"] = "組合 %q 已存在";
	L["SET_TO_MANY_SETS"] = "你的設定不能超過32組";
	L["AUTOSORT_DESC"] = "小隊自動排序";
	L["REPLY_NO_ARRANGEMENT"] = "你沒有被安排到工作";
	L["REPLY_ARRANGEMENT_FOR"] = "你被安排到 %s";
	L["AUTOFILL"] = "自動補滿";
	L["MSG_HEAL_FOR_ARRANGEMENT"] = "使用密語 'heal' 查詢對你的安排工作。";
	L["WHISPER"] = "密語告知補系對他們的安排工作";
	L["ARRANGEMENT_FOR"] = "你的安排工作: %s";
end