--
-- To add sounds to SBF:
--
-- 1. Exit WoW completely
-- 
-- 2. Copy the sound files you want to use to this directory
--    You can use .wav, .mp3, .ogg for sure
--    Other formats may well work, but I've not tested any others
-- 
-- 3. Add an entry in the list below, using this template:
-- 
--   { "AAA", [[Interface\AddOns\SatrinaBuffFrame\Media\XXX.YYY]] },
-- 
--  - Replace AAA with a label for the sound.  This name will be waht shows in the sound list
--  - Replace XXX.YYY with the name of the sound file you copied into the Media directory
-- 
-- 4. The Boing sound is given to show you what it should look like when you're done.  
--    Note that:
--    - the square braces [[ ]] are important, don't leave them out
--    - The curly braces { } are important, don't leave them out
--    - The comma at the end is important, don't leave it out
--    - On Windows it's not case sensitive.  It most probably is on Mac.
-- 
-- 5. Log in to WoW and you should see the sound in the dropdown list.  
--    - If you got an error, you screwed something up here.  
--    - Not all sound files are created equal.  Sometimes you'll get no error, but the sound 
--      won't play.  I have no idea what's up with that, so don't ask me
--    - SBF will register the sound with the SharedMedia Library, so it will be
--      available to all of your addons that use SharedMedia

SBF.sounds = {
 { "SBF Boing", [[Interface\AddOns\SatrinaBuffFrame\Media\boing.wav]] },

}