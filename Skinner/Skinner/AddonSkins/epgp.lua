if not Skinner:isAddonEnabled("epgp") then return end

function Skinner:epgp()

	local epgpUI = EPGP and EPGP:GetModule("ui", true)
	if not epgpUI then return end

	local function skinEPGPUI()
	
		Skinner:skinSlider(EPGPScrollFrameScrollBar)
		EPGPScrollFrameScrollBarBorder:SetAlpha(0)
		
		local sf = Skinner:getChild(EPGPFrame, 6) -- standings frame
		local tf = Skinner:getChild(sf, 4) -- table frame
		-- tabs
		for _, v in pairs(tf.headers) do
			Skinner:keepRegions(v, {5, 6}) -- N.B. regions 5 & 6 are highlight/text
			Skinner:applySkin{obj=v}
		end
		Skinner:addSkinFrame{obj=EPGPFrame, kfs=true, x1=10, y1=-12, x2=-33, y2=71}
		
		-- Side Frame
		Skinner:skinDropDown{obj=EPGPSideFrameGPControlDropDown}
		Skinner:skinDropDown{obj=EPGPSideFrameEPControlDropDown}
		Skinner:skinEditBox{obj=EPGPSideFrameGPControlEditBox, regs={9}}
		Skinner:skinEditBox{obj=EPGPSideFrameEPControlOtherEditBox, regs={9}}
		Skinner:skinEditBox{obj=EPGPSideFrameEPControlEditBox, regs={9}}
		Skinner:moveObject{obj=self:getRegion(EPGPSideFrame, 2), y=-6}
		Skinner:addSkinFrame{obj=EPGPSideFrame, kfs=true, x1=3, y1=-6, x2=-5, y2=6}
		-- Side Frame2
		Skinner:skinDropDown{obj=EPGPSideFrame2EPControlDropDown}
		Skinner:skinEditBox{obj=EPGPSideFrame2EPControlOtherEditBox, regs={9}}
		Skinner:skinEditBox{obj=EPGPSideFrame2EPControlEditBox, regs={9}}
		Skinner:addSkinFrame{obj=EPGPSideFrame2, kfs=true, x1=3, y1=-6, x2=-5, y2=6}
		-- Log Frame
		Skinner:addSkinFrame{obj=EPGPLogRecordScrollFrame:GetParent()}
		Skinner:addSkinFrame{obj=EPGPLogFrame, kfs=true, x1=3, y1=-6, x2=-5, y2=2}
		-- ExportImport Frame
		Skinner:skinScrollBar{obj=EPGPExportScrollFrame}
		Skinner:addSkinFrame{obj=EPGPExportImportFrame, kfs=true}
		
	end
	
	if not EPGPFrame then
		self:SecureHook(epgpUI, "OnEnable", function()
--			self:Debug("EPGP_UI_OnEnable")
			skinEPGPUI()
			self:Unhook(EPGPFrame, "Show")
		end)
	else
		self:SecureHook(EPGPFrame, "Show", function(this)
--			self:Debug("EPGPFrame_Show")
			skinEPGPUI()
			self:Unhook(EPGPFrame, "Show")
		end)
	end
		
end
