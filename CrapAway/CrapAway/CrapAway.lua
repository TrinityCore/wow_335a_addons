function caInit()
	this:RegisterEvent("MERCHANT_SHOW");
end

function caEvent()
	if event=="MERCHANT_SHOW" then
		local qstr="";
		local i=0;
		local _,caClass=UnitClass("player");
		repeat
			if not(GetContainerNumSlots(i)==nil)then
				caslots=GetContainerNumSlots(i);

				j=1;
				repeat
					calink=GetContainerItemLink(i,j);
					if not(calink==nil)then                        
						_,_,caQuality,_,_,caType,caSubtype,_,_,_=GetItemInfo(calink);
						if(caQuality==0)then
							UseContainerItem(i,j);
						end

					end
					j=j+1;
				until j>=caslots+1;
			end
			i=i+1;
		until i>=5
	end
end