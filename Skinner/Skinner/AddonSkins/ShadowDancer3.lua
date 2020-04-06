if not Skinner:isAddonEnabled("ShadowDancer3") then return end

function Skinner:ShadowDancer3()

	local obj = IGAS.GUI.CreateFrame("Frame", "ShadowDancer3")
	self:SecureHook(obj, "OpenGUI", function()
		local gui = obj.Parent:GetChild("ShadowDancer3_GUI")
-- 		self:Debug("sd3 OpenGUI:[%s, %s]", obj, gui)
		self:applySkin(gui.__UI)
		-- get children to skin
		local tabG = gui:GetChild("Tab")
		local tabCon = tabG.__HeaderContainer
		local summaryT = tabCon:GetChild("TabButton"..1)
		local weaponT = tabCon:GetChild("TabButton"..2)
		local skillT = tabCon:GetChild("TabButton"..3)
		local summaryF = summaryT.__Container.__UI
		local summaryCon = summaryT.Container
		local weaponF = weaponT.__Container.__UI
		local weaponCon = weaponT.Container
		local skillF = skillT.__Container.__UI
		local skillCon = skillT.Container
		local dd
		-- Summary Tab
		dd = summaryCon:GetChild("LockMode")
		self:applySkin(dd.__UI)
		self:applySkin(dd.__List.__UI)
		self:applySkin(summaryF)
		-- Weapon Tab
		for _, v in pairs{"WeaponName", "WpsMain", "WpsOff", "WpsRange", "WpsAmmo"} do
			dd = weaponCon:GetChild(v)
			if dd.__List then
				self:applySkin(dd.__UI)
				self:applySkin(dd.__List.__UI)
			end
		end
		self:applySkin(weaponF)
		-- Skill Tab
		for _, v in pairs{"Time", "SkillName"} do
			dd = skillCon:GetChild(v)
			if dd.__List then
				self:applySkin(dd.__UI)
				self:applySkin(dd.__List.__UI)
			end
		end
		for _, v in pairs{"Action_", "Wps1_", "Wps2_"} do
			for i = 1, 10 do
				dd = skillCon.Sets:GetChild(v..i)
				if dd and dd.__List then
					self:applySkin(dd.__UI)
					self:applySkin(dd.__List.__UI)
				end
			end
		end
		self:applySkin(skillF)
		self:Unhook(obj, "OpenGUI")
	end)

end
