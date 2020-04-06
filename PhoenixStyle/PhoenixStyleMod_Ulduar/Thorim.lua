function psftorimnoob()
psunitisplayer(arg6,arg7)
if psunitplayertrue then
wasornotorim=1
addtotwotables(arg7)
vezaxsort1()

if(bosspartul[7]==1 and bosspartul2[5]==1)then
pszapuskanonsa(whererepbossulda[7], "{rt7} "..arg7.." "..psultorimtext1)
end
end
end

function psftorimafterf()
if(bosspartul[7]==1)then
strochkavezcrash="{rt7}"..psultorimtext2
reportafterboitwotab(whererepbossulda[7], true, vezaxname, vezaxcrash)
end

end


function psftorimresetall()
wasornotorim=0
timetocheck=0
torimboyinterr=0
table.wipe(vezaxname)
table.wipe(vezaxcrash)
end