--======================================================================================================================================================
-- Library: Zasurus' Message Control - Information & Instructions
--[[====================================================================================================================================================
	Origins:	 	I created this librarary from a series of functions I included in all
					of my addons as it was getting hard to keep the functions up todate in
					all of the addons. A library seemed a simple plug n play option.
					
	Description: 	This library is to control the displaying of messages to the user and also the
					control of debugging messages.
					
					It allows you to display debug messages on a spacific chat window (1-7)
					and easly turn them on/off for each function individually or/and store
					all messages from all functions into a debug log so you can debug a users
					function without them having to see all the messages and tell you whats
					going on!
	
	
	Use: 	1 - Include this file and LibStub within your addon's folder with it's own lua files.
			
			2 - Add this file to your TOC file BEFORE the .lua files that will use it are loaded!
			
			3 - Add "local ZMC = LibStub("LibZasMsgCtr-0.1");" to the top of your addon before using it's
				messageing function (this tells LibStub to load this library if it is not already loaded!)
			
			4 - Add the following line in the code that kicks of when your addon has loaded (variable's loaded e.g. EVERNT "ADDON_LOADED"). See index for more information...
				ZMC:Initialize(CallingAddon, AddonName, (Optional)DefaultColour1, (Optional)DebugFrameNumber, (Optional)DefaultColour2, (Optional)DefaultErrorColour, (Optional)DefaultMsgFrameNumber) -- Initialize the debugging/messaging library's settings for this addon (CallingAddon, AddonName, DefaultColour1, Debug_Frame, DefaultColour2, DefaultErrorColour, DefaultMsgFrame)
				
				Index:
					CallingAddon = This is your addon's frame or if you don't have one a table which every function in your addon can reference
					AddonName = This is the name of your addon (This MUST be the directory name of your addon)
					DefaultColour1 =		This is the colour that your addon's name and version will be in. You can ether use a html colour with "|c" on the
											start e.g. "|cffffff00" or for simplicity you can use the predefined colours included with this Library (see
											"Chat Frame Colours" below) e.g. ZMC.COLOUR_WHITE asumming "ZMC" is the local variable you put the library in with LibStub.
											THIS IS OPTIONAL. If no value is given "ZMC.COLOUR_WHITE" will be used.
					DebugFrameNumber =		This is the frame number your debug message will apear in. e.g. 1 will put them in the default chat frame and 7 will put
											them in the 7th chat window (7 is the most chat windows you can currently add in WoW! Also if the user doesn't have that 
											window the message won't be displayed!)
											THIS IS OPTIONAL. If no value is given 1 will be used.
					DefaultColour2 =		This is the colour that your addon's message text will be in. See DefaultColour1 above for help.
											THIS IS OPTIONAL. If no value is given "ZMC.COLOUR_GREEN" will be used.
					DefaultErrorColour =	This is the colour that your addon's error message text will be in. See DefaultColour1 above for help.
											THIS IS OPTIONAL. If no value is given "ZMC.COLOUR_RED" will be used.
					DefaultMsgFrameNumber =	This is the default frame that ALL none debug messages will go into unless overwritten in the message
											call function. See DebugFrameNumber for help.
											THIS IS OPTIONAL. If no value is given 1 will be used.
			
			10-	!!!!!!!!!!!!!!!!!!!!!!!!!! Add everything between THIS LINE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
								----------------------------------------------
								-- Library: "Zasurus' Message Control" Header
								-- Default: If DebugTxt is set to true all of
								-- the debug msgs in THIS function will apear!
								----------------------------------------------
								local DebugTxt = false;
								-- DebugTxt = true; -- Uncomment this to debug
								----------------------------------------------
				!!!!!!!!!!!!!!!! AND THIS LINE to the top of EVERY function in your addon/project. !!!!!!!!!!!!!!!!
				This could just be replaced with "local DebugTxt = false;" and then change the false to true when you want to debug but I find it's easyer to simply remove the commenting as NotePad++ has a shortcut for it!
			
			11 - To print a message use the line below:
				ZMC:Msg(CallingAddon, sMessage, bDebug, bDebugOn, bError, bSimple, FrameOverride)
				
				Index:
					CallingAddon =	This is the addon's frame (if you have all of your function inside the addon's frame "function Addonframename:SomeFunction()"
									then you can just use self for this) or the table you are using as it's frame
					sMessage = 		This is the string for the message it's self!
					bDebug =		This is whether this is a debug message or not.
									THIS IS OPTIONAL. If no value is given false will be used.
					bDebugOn =		This should always be DebugTxt if this is a debug message
									THIS IS OPTIONAL. If no value is given false will be used. If this message is a debug message and this value is left as nil
									then THIS MESSAGE WILL NEVER GET USED!
					bError =		This is whether this message is an error message or not (Will it use the text colour DefaultErrorColour or DefaultColour2).
									THIS IS OPTIONAL. If no value is given false will be used.
					bSimple =		If this is true the addon's name and version won't be added to the start of the message. (NOT RECORMENDED!)
									THIS IS OPTIONAL. If no value is given false will be used.
					FrameOverride =	This is an override for the default frame to use. E.G. 1 for the default chat frame
									THIS IS OPTIONAL. If no value is given the already set default for this message type will be used.
			
			Then when you want to display the debug messages from a specific function then simply uncomment the line in the
			"Zasurus' Message Control" Header at the top of that function that starting with "DebugTxt =..."! I have done it
			this way as it's quicker than changing the false to true on the first line for me as it's just a shortcut to uncomment a
			line in the text editor it use. But you could just put the first line in and change the false to a true when you wanted
			to debug that function...
			
			To store ALL messages in a HUGE Debug log (will get upto about 22MB before it stops logging due to a limit on the file size)
			ether run the command "/run ZMC:EnableDebugLog("CallingAddon");" where is the name of the addon to start debugging.
			
			To STOP storing debug messages type "/run ####_StoreDebugMsgs = false;" where #### is the name of your addon. E.G. "myAddon_StoreDebugMsgs"
			
			To STOP storing debug messages and DELETE the WHOLE debug log to free up memory type: "/run ZMC:WipeDebugLog("CallingAddon");" where is the name of the addon to stop debugging.
======================================================================================================================================================]]

	
-----------------------------------------------------------
-- Header
-----------------------------------------------------------
	local ZMC = LibStub:NewLibrary("LibZasMsgCtr-0.2", 1)
	
	if not ZMC then
	  return	-- already loaded and no upgrade necessary
	end
-----------------------------------------------------------




-----------------------------------------------------------
-- Defaults & Variable Declarations
-----------------------------------------------------------
	local MaxDebugLogEntrys = 200000; -- This is the maximum number of entries we will alow in the DebugLog. High values cause errors...
-----------------------------------------------------------


----------------------------------------------
-- Chat Frame Colours
----------------------------------------------
	do -- Colours
		--OK FOR MOST USERS--
		ZMC.COLOUR_WHITE		= "|cffffffff";
		ZMC.COLOUR_YELLOW		= "|cffffff00";
		ZMC.COLOUR_LTGREY		= "|caaaaaaaa";
		ZMC.COLOUR_MEDGRAY		= "|cff808080";
		ZMC.COLOUR_BLUEGREY		= "|cffa6a6ff";
		ZMC.COLOUR_LTBLUE		= "|cff00d7e4";
		ZMC.COLOUR_BLUE 		= "|cff3366ff";
		ZMC.COLOUR_TEAL			= "|cff00ffbb";
		ZMC.COLOUR_BLUGREEN		= "|cffa4d7ea";
		ZMC.COLOUR_LTGREEN		= "|cff70ff6d";
		ZMC.COLOUR_GREEN 		= "|cff00ff00";
		ZMC.COLOUR_PINK			= "|cffff00ff";
		ZMC.COLOUR_LTPURPLE		= "|cffb56dff";
		ZMC.COLOUR_PURPLE		= "|cffaa00ff";
		ZMC.COLOUR_RED 			= "|cffff0000";
		ZMC.COLOUR_ORANGE		= "|cffff9900";
		
		--DARK FOR MOST USERS--
		ZMC.COLOUR_DKGRAY		= "|cff555555";
		ZMC.COLOUR_DKBLUE		= "|cff0000ff";
		ZMC.COLOUR_DKPURPLE		= "|cff742fff";
		
		--TO DARK FOR MOST USERS--
		ZMC.COLOUR_DRKGREEN		= "|cff005000";
		ZMC.COLOUR_BROWN		= "|cff764e31";
		ZMC.COLOUR_BLACK		= "|c00000000";
		
		ZMC.COLOUR_CLOSE 		= "|r"; -- Used at end of text you want to have coloured to tell it to stop colouring text
	end;
----------------------------------------------


local function returnChatFrame(ChatFrameNumber) -- Given a number this returns the ChatFrame for that number. e.g. if 1 is given it will return ChatFrame1
	local FrameToReturn;
	if (ChatFrameNumber == 1) then
		FrameToReturn = ChatFrame1;
	elseif (ChatFrameNumber == 2) then
		FrameToReturn = ChatFrame2;
	elseif (ChatFrameNumber == 3) then
		FrameToReturn = ChatFrame3;
	elseif (ChatFrameNumber == 4) then
		FrameToReturn = ChatFrame4;
	elseif (ChatFrameNumber == 5) then
		FrameToReturn = ChatFrame5;
	elseif (ChatFrameNumber == 6) then
		FrameToReturn = ChatFrame6;
	elseif (ChatFrameNumber == 7) then
		FrameToReturn = ChatFrame7;
	else
		FrameToReturn = false;
	end;
	
	return FrameToReturn;
end;


function ZMC:Initialize(CallingAddon, AddonName, DefaultColour1, Debug_Frame, DefaultColour2, DefaultErrorColour, DefaultMsgFrame) -- Initialize the calling addon's settings
	assert(type(CallingAddon) == "table", "Bad argument #1 (CallingAddon) to 'Initialize' (table expected got "..tostring(type(CallingAddon))..")") -- Check that CallingAddon is a table (normally a frame but always reports as a table) and not null etc...
	
	assert(type(AddonName) == "string", "Bad argument #2 (AddonName) to 'Initialize' (string expected got "..tostring(type(AddonName))..")") -- Checks to ensure that a valid addon name has been passed
	CallingAddon.ZMC_AddonName = AddonName -- Stores the addon Name for the msg function;
	
	CallingAddon.ZMC_DefaultMsgFrame = DefaultMsgFrame or 1 -- Sets the frame that messages will be printed in by default (If not overwritten on calling msg function).
	CallingAddon.ZMC_Debug_Frame = Debug_Frame or CallingAddon.ZMC_DefaultMsgFrame -- Stores the addon Name for the msg function. This is what is printed at the start of the message;
	
	CallingAddon.ZMC_DefaultColour1 = DefaultColour1 or self.COLOUR_WHITE
	CallingAddon.ZMC_DefaultColour2 = DefaultColour2 or self.COLOUR_GREEN
	CallingAddon.ZMC_DefaultErrorColour = DefaultErrorColour or self.COLOUR_RED
	
	
	
	--------------------------------------------------------------------------------
	-- Initialize the addon's debug log variables encase they are stored in it's toc
	-- file. (If they arn't it doesn't matter they will just be lost on exit)
	--------------------------------------------------------------------------------
		local DebugLog = _G[CallingAddon.ZMC_AddonName.."_DebugLog"] -- Pulls back a local copy of the addon's DebugLog
		local StoreDebugMsgs = _G[CallingAddon.ZMC_AddonName.."_StoreDebugMsgs"] -- Pulls back a local copy of the addon's StoreDebugMsgs boolean
		
		DebugLog = DebugLog or {}; -- Initializes the DebugLog if it isn't initialized or is nil (We can't tell if it's in the toc file's "SavedVariablesPerCharacter" or "SavedVariables" list so if it's not it will just be lost on exit.
		
		-- Initializes the DebugLog if it isn't initialized or is nil (We can't tell if it's in the toc file's "SavedVariablesPerCharacter" or "SavedVariables" list so if it's not it will just be lost on exit.
		if (StoreDebugMsgs ~= true) then
			StoreDebugMsgs = false;
		end;
		
		_G[CallingAddon.ZMC_AddonName.."_DebugLog"] = DebugLog -- Stores the local copy back over the the addon's DebugLog (It's now definatly inishilized even if it's not going to be stored!)
		_G[CallingAddon.ZMC_AddonName.."_StoreDebugMsgs"] = StoreDebugMsgs -- Stores the local copy back over the the addon's StoreDebugMsgs boolean (It's now definatly inishilized even if it's not going to be stored!)
	--------------------------------------------------------------------------------
	
	
	
	----------------------------------------------------------------------------------------
	-- Debug log check. This checks to see if the debug log and warns the user if it's there
	----------------------------------------------------------------------------------------
		if (_G[CallingAddon.ZMC_AddonName.."_StoreDebugMsgs"]) then -- The DebugLog is enabled
			self:Msg(CallingAddon, "WARNING! The debuglog is on. This should only be on if an author has asked you to do this! To disable and wipe it type '/ZMC WipeDebugLog "..tostring(CallingAddon.ZMC_AddonName).."' to clear this log and reduce memory usage.", nil, nil, true);
		elseif #(_G[CallingAddon.ZMC_AddonName.."_DebugLog"]) > 0 then -- The DebugLog is disabled but the log file still exists
			self:Msg(CallingAddon, "WARNING! The debuglog is switched off BUT the log its self still exists! If you don't know what this is or if you don't need it then type '/ZMC WipeDebugLog "..tostring(CallingAddon.ZMC_AddonName).."' to clear this log and reduce memory usage.", nil, nil, true);
		-- else
			-- self:Msg(CallingAddon, "G[CallingAddon.ZMC_AddonName.._StoreDebugMsgs] = "..tostring(_G[CallingAddon.ZMC_AddonName.."_StoreDebugMsgs"]).."");
			-- self:Msg(CallingAddon, "#(_G[CallingAddon.ZMC_AddonName.._DebugLog]) = "..tostring(#(_G[CallingAddon.ZMC_AddonName.."_DebugLog"])).."");
		end;
	----------------------------------------------------------------------------------------
	
	CallingAddon.ZMC_Initialized = true; -- Say that this addon is Initialized
end;


function ZMC:Msg(CallingAddon, sMessage, bDebug, bDebugOn, bError, bSimple, FrameOverride) -- Controls the displaying of messages to the user and debugging messages.
	----------------------------------------------------------------------------------------
	-- Defaults and checks
	----------------------------------------------------------------------------------------
		local AddonDetails = "";
		local sFullMessage = "";
		local Msg_Frame = 1;
		local Debug_Frame = 1;
		
		local DefaultColour1 = self.COLOUR_WHITE
		local DefaultColour2 = self.COLOUR_GREEN
		local DefaultErrorColour = self.COLOUR_RED
		
		bError = bError or false;
		bDebug = bDebug or false;
		bDebugOn = bDebugOn or false;
		bSimple = bSimple or false;
		
		if (not((type(CallingAddon) ~= "table") or CallingAddon.ZMC_AddonName == nil)) then
			Msg_Frame = FrameOverride or CallingAddon.ZMC_DefaultMsgFrame; -- Stores the number of the frame to use as the  Message Frame to use from ether the one passed and if there isn't one then the default for this addon
			Debug_Frame = FrameOverride or CallingAddon.ZMC_Debug_Frame; -- Stores the number of the frame to use as the Debug Frame to use from ether the one passed and if there isn't one then the default for this addon
			
			DefaultColour1 = CallingAddon.ZMC_DefaultColour1 or self.COLOUR_WHITE
			DefaultColour2 = CallingAddon.ZMC_DefaultColour2 or self.COLOUR_GREEN
			DefaultErrorColour = CallingAddon.ZMC_DefaultErrorColour or self.COLOUR_RED
			
			if not(bSimple) then -- Addon HAS been initialized and simple mode is not wanted so use the addon's values.
				local AddonVersion = GetAddOnMetadata(CallingAddon.ZMC_AddonName, "Version");
				
				if AddonVersion then
					AddonDetails = tostring(CallingAddon.ZMC_AddonName).." V"..tostring(AddonVersion)..": ";
				else
					AddonDetails = tostring(CallingAddon.ZMC_AddonName)..": ";
				end;
			end;
		end;
		
		local Local_MsgFrame = returnChatFrame(Msg_Frame); -- Stores the Message Frame to use from ether the one passed and if there isn't one then the default for this addon
		if (Local_MsgFrame == false) then
			Local_MsgFrame = ChatFrame1;
		end;
		
		local Local_DebugFrame = returnChatFrame(Debug_Frame); -- Stores the Message Frame to use from ether the one passed and if there isn't one then the default for this addon
		if (Local_DebugFrame == false) then
			Local_DebugFrame = ChatFrame1;
		end;
		
		if (sMessage == nil) then
			error(AddonDetails.."Message function called with a nil value(No message sent to print)!");
		end;
	----------------------------------------------------------------------------------------
	
	
	
	
	
	
	----------------------------------------------------------------------------------------
	-- Sets the colour of the messages (error or normal)
	----------------------------------------------------------------------------------------
		if bError then
			sFullMessage = DefaultColour1..AddonDetails..self.COLOUR_CLOSE..DefaultErrorColour..tostring(sMessage)..self.COLOUR_CLOSE;
		else
			sFullMessage = DefaultColour1..AddonDetails..self.COLOUR_CLOSE..DefaultColour2..tostring(sMessage)..self.COLOUR_CLOSE;
		end;
	----------------------------------------------------------------------------------------
	
	
	
	
	
	
	--------------------------------------------------------------------------------------------
	-- Debug code that prints the debug messages in the window specified in the project header
	--------------------------------------------------------------------------------------------
		if bDebug and bDebugOn then -- This is a debug msg and the debug function for that function is turned on
			Local_DebugFrame:AddMessage(sFullMessage);
		end;
	--------------------------------------------------------------------------------------------
	
	
	
	
	--------------------------------------------------------------------------------------------
	-- Stores all messages in the debug log if it's turned on
	--------------------------------------------------------------------------------------------
		if (CallingAddon and CallingAddon.ZMC_AddonName and _G[CallingAddon.ZMC_AddonName.."_StoreDebugMsgs"] and (_G[CallingAddon.ZMC_AddonName.."_DebugLog"] ~= nil)) then
			local CurrentDebugLogNum = #(_G[CallingAddon.ZMC_AddonName.."_DebugLog"]); -- Gets the number of entrys in the debug log
			
			if CurrentDebugLogNum > MaxDebugLogEntrys then -- The array is HUGE! Stop debugging until this is deleted and inform the user
				_G[CallingAddon.ZMC_AddonName.."_StoreDebugMsgs"] = false; -- Stops storing the debug msgs
				
				self:Msg(CallingAddon, "WARNING: The DebugLog is HUGE! To prevent errors debugging has been switched off. If you wern't asked to turn it on by an author then you should run '/run ZMC:WipeDebugLog("..strchar(34)..tostring(CallingAddon.ZMC_AddonName)..strchar(34)..")' to clear this log and reduce memory usage.", nil, nil, true);
			else -- Log is not to big so add to it as normal
				if (_G[CallingAddon.ZMC_AddonName.."_DebugLog"][CurrentDebugLogNum + 1] == nil) then
					_G[CallingAddon.ZMC_AddonName.."_DebugLog"][CurrentDebugLogNum + 1] = {};
				end;
				
				_G[CallingAddon.ZMC_AddonName.."_DebugLog"][CurrentDebugLogNum + 1][time()] = sMessage
			end;
		end;
	--------------------------------------------------------------------------------------------
	
	
	
	
	
	
	--------------------------------------------------------------------------------------------
	-- Prints all normal messages in the normal chat window
	--------------------------------------------------------------------------------------------
		if (not bDebug) then -- If this is not a debug message
			Local_MsgFrame:AddMessage(tostring(sFullMessage)); --Print the message in a Main chat frame
		end;
	--------------------------------------------------------------------------------------------
end;


function ZMC:WipeDebugLog(CallingAddon) -- This function disables and wipes the debug log for the specified addon.
	if (type(CallingAddon) == "table") then
		if (type(CallingAddon.Name) == "string") then
			CallingAddon = CallingAddon.Name; -- Pull out the name of the calling function 
		else
			self:Msg(_G[CallingAddon], "ERROR: Argument #1 ('"..tostring(CallingAddon).."') for function ZMC:WipeDebugLog() is not a string or an addon frame with a .name variable that is a string. Can't get the name of the addon so can't disable debuggin for the addon!", nil, nil, true);
			
			return false;
		end;
	elseif (type(CallingAddon) ~= "string") then
		self:Msg(_G[CallingAddon], "ERROR: Argument #1 = '"..tostring(CallingAddon).."' for function ZMC:WipeDebugLog() is not valid! It should be the addon frame or it's name but it is of type '"..tostring(type(CallingAddon)).."'!", nil, nil, true);
		
		return false;
	end;
	
	if ((_G[CallingAddon.."_DebugLog"] ~= nil) and ((type(_G[CallingAddon.."_DebugLog"]) == "table") or (_G[CallingAddon.."_StoreDebugMsgs"] == true))) then
		_G[CallingAddon.."_StoreDebugMsgs"] = false; -- Stores the local copy back over the the addon's StoreDebugMsgs boolean (It's now definatly inishilized even if it's not going to be stored!)
		_G[CallingAddon.."_DebugLog"] = {}; -- Stores the local copy back over the the addon's DebugLog (It's now definatly inishilized even if it's not going to be stored!)
		
		self:Msg(_G[CallingAddon], "Debugging disabled and debuglog wiped");
		
		return true;
	else
		self:Msg(_G[CallingAddon], ZMC.COLOUR_ORANGE.."Warning: Addon: '"..tostring(CallingAddon).."' doesn't have a debug log and the debug logging is disabled or addon doesn't exist!"..self.COLOUR_CLOSE);
		
		return false;
	end;
end;


function ZMC:EnableDebugLog(CallingAddon)
	if (type(CallingAddon) == "table") then
		if (type(CallingAddon.Name) == "string") then
			CallingAddon = CallingAddon.Name; -- Pull out the name of the calling function 
		else
			self:Msg(CallingAddon, "ERROR: Argument #1 ('"..tostring(CallingAddon).."') for function ZMC:EnableDebugLog() is not a string or an addon frame with a .name variable that is a string. Can't get the name of the addon so can't disable debuggin for the addon!", nil, nil, true);
			
			return false;
		end;
	elseif (type(CallingAddon) ~= "string") then
		self:Msg(CallingAddon, "ERROR: Argument #1 = '"..tostring(CallingAddon).."' for function ZMC:EnableDebugLog() is not valid! It should be the addon frame or it's name but it is of type '"..tostring(type(CallingAddon)).."'!", nil, nil, true);
		
		return false;
	elseif (_G[CallingAddon] == nil) then
		self:Msg(CallingAddon, "ERROR: Argument #1 = '"..tostring(CallingAddon).."' for function ZMC:EnableDebugLog() is not valid! It should be the addon frame or it's name. The string you provided is not a valid frame name. Please check spelling and case as it is case sensitive. E.G. 'MyAddon' and 'myAddon' are not the same as the m is lower case in the second example.", nil, nil, true);
		
		return false;
	end;
	
	_G[CallingAddon.."_StoreDebugMsgs"] = true; -- Stores the local copy back over the the addon's StoreDebugMsgs boolean (It's now definatly inishilized even if it's not going to be stored!)
	_G[CallingAddon.."_DebugLog"] = _G[CallingAddon.."_DebugLog"] or {}; -- Stores the local copy back over the the addon's DebugLog (It's now definatly inishilized even if it's not going to be stored!)
	self:Msg(_G[CallingAddon], "Debugging enabled");
	
	return true;
end;


function ZMC:SlashCmdHandler(msg)
	if (msg == nil or msg == "") then
		self:Msg(nil, "BreadCrumbs is running");
	elseif (strlower(strsub(msg,1,14)) == "enabledebuglog") then
		--self:Msg(self, "EnableDebugLog("..tostring(msg)..")");
		local CallingAddonName = strsub(msg,16)
		self:EnableDebugLog(CallingAddonName);
	elseif (strlower(strsub(msg,1,12)) == "wipedebuglog") then
		--self:Msg(self, "EnableDebugLog("..tostring(msg)..")");
		local CallingAddonName = strsub(msg,14)
		self:WipeDebugLog(CallingAddonName);
	-- else
		-- self:Msg(self, "Message not known = '"..tostring(msg).."'",true,Debugtxt);
	end;
end;


do -- Slash Command Handler
	SLASH_ZMC1 = "/ZMC";
	SlashCmdList["ZMC"] = function(msg)
		ZMC:SlashCmdHandler(msg);
	end;
end;