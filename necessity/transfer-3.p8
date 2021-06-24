pico-8 cartridge // http://www.pico-8.com
version 30
__lua__

pal({
		1+128,
		1,
		12+128,
		13,
		13,
		13+128,
		2,
		2+128,
		1+128,
		1,
		12+128,
		13,
		13,
		13+128,
		2,
		2+128,
	}, 1)

local t,ti,dt=0,0,1/30
local c,s=cos,sin
local s2=sqrt(2)
::♥::
t+=dt
ti+=1

t = t%36

local j = t%8<4
local jk = j and 12 or 2
local sk = 64*64*s2*s2
local ct24 = cos(t/24)

local spr = sin(t/8)*0.5+0.5

for i=1,1300 do
	local a,r=rnd(1),sqrt(rnd(sk))
	local x,y=64+r*c(a),64+r*s(a)

	local okay = (r/32-t/8-x/64 + y/64)

	local p=sin(a * (ct24 + 1))
	  * cos(a+sin((x)/1000)-t/16)
	  * (1-0.1*cos(t/8))
	  
	  + spr*1*okay
	  + (1-spr)*1*(okay\1)

	local diff = p&0x0.ffff
	local fill
	if diff<0.25 then
		fill = 0b1111101011110101
	elseif diff<0.5 then
		fill = 0b1010010110100101
	elseif diff<0.75 then
		fill = 0b1010000001010000
	else
		fill = 0
	end
	fillp(fill)
	circ(x,y,1,p\1+(p-1)\1*16)
	
end

print("\#0"..t,0,0,7)

flip() goto ♥
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
aaaa96fd6d16cb4805433323222211111111111111111010000000000000000fffedcb8686212222222121111212111111111111111111222222222222222333
baaaa7b6db62edd7843433323222111111111111111111000000000000000000ffdcdcb861322222222111111111111111111111111112222222222222223333
bba9ba64682e2e7d79433333222211111111111111111110000000000000000ffffdca8d83332222221121111111111111111111111112222252222222222333
bb9b9bf64d42edd7644433322222111111111111111111110000000000000000ffded7c804332222321111211111111111111111111111222222222222222233
bab98fcfc4abdb76764443322222211121111111111111110000000000000000fefd7c7054432222222112111111111111111111111112222222222222222223
bba8a2fcea4abd4767444323222222121111111111111110100000000000000fffeee75544423222222221211111111111111111111121222222222222233323
bbba882e1ea642a7645443323222222111111111111111110000000000000000feeec89643432332222222211111111111111111111112222222222222333333
bbbba883ea64649676453433222222111111111111111111000000000000000fffed8c8e34323334222121211111111111111111111212122222222222233333
bbbb9a3832a649b96566733332222221111111111111111100000000000000fffeded1e743232333221212121111112111111111112122222222222222223333
cbb9b9837a0b3b9b8665433332222222111111111111111110000000000000ffffeda91474323233222121212111121111111111111222222222222222232333
cbbb98a8b7d3b3c788544333232222212111111111111111111000000000000ffffada9845c32332222222121111111111111111111122222222222222323333
cbbc8a8c8ddd3c3c798443333232222212111111111111111110000000000000fffeaa8545533332222221211111111111111111112112222222222222233333
bcbbb8a8dd6de3c4ef684433332222222111111111111111110000000000000ffffca84454753322222312111111111111111111122222222222222222233333
cbbbbaad0dd65d504664643332222222221111111111111111110000000000ffffcdc48644333332223221121111111111111111222222222222222223233333
ccbbb987d065d5a50656464333222222221111111111111111111000000000ffffdcdb6263432332222222212111211111111112122212222222222233333333
ccbbb89444a7e67cc7656443423222232211111111111111111100000000000ffffc7ef664323222222222221111111111111111222222222222222233333333
ccbba984447a7e6776666744332222222121111111111111111100000000000ffec7cf5fa6322322222222222211111111111111222222222222222223333233
ccbab8984ca7e67cc6666444333322222211111111111111111011000000000fefec77f56a232322222222222211111111111112222222222222222222233343
dbcbaa8494c82f01cf6674433333322222221111111111111111101000000000feee785655323232222222222221111111111112222222222222222222332434
ccbaaaa84588f51c178774433333322222222111111111111111110000000000fffe9dd545333322222222222221211111111112222222222222222222223343
cccbaa8969ec5857cd776534333322222222111111111111111110000000000ffff9992454233222222222222212111111111112222222222222222222233343
cccccba666cec57c797676434333222222222111111111111111100000000000ffd999da44333332222222222221211111111222222222222222222222323434
cddcba99666c68f71c676444333322222222121111111111111110000000000ffffd9b6444433322222222222222211111112122222222222222222223233344
ddcbcb9997565642c1f656444332322222212111111111111111111000500000fffeb6b644363222222222222222121111221222222222222222222222333334
dcccbab9797568a826866564434322222222111111111111111111110000000f0fdecb6656433322232222222222212112212222222222222222222222333343
ccccbbab97858a8a8898665434332222222211111111111111111110000000f0fded806565333322222222222222121221121222222222222222222222333334
cccbcbba9855d8a809896665433332222222211111111111111111100000000ffede060655333232222222222222212221212222222222222222222223334343
ccccbcbc9a5d504c6098665443333322222222111111111111111110000000fffeec506753533322222222222222221222122222222222222222222232343434
dccccbcbb9a50a01c4868645443335332222221111111111111111100000000fe5eac57773333322222222222222212121222222222222222222222223334444
ddccbcbb998650aa1dea6554434343232222222121111111111111111000000fffeb0b0734333322222222222222221212222222222222222222222223334444
dcdccbcb98956aa1beaea85444353222222222121111111111111111110005fffefeb0cd53443222222222222222222121222222222222222222222233333445
ddccccccb999795bebeb8754445333222222222111111111111111111000000fffed19d654532222222222222222222212122222222222222222222323333335
dddccccba9899a14beb8b8744443332222222222111111111111111100000000ede19f9545323222222222222222222111112222222222222222222233334355
ddddccbcb898614146cb8779445433322222222211111111111111111100000ffecdfbf444432333222222222222222211111221222222222222222333343445
dddddccbcba696144cdcd8a665433323222222222111111111111111111000f0fcfcbfb644433333222222222222222212112122112222222222223333334454
ddddddccbaba6673d0cd8a8a765333323222222222121111111111111100000fffcccb6563433322223222222222221221111211112222222222233333333545
ddddddcbbbaa974d3d10a9a7645533433222222222222111111111111110000f0ebcc2e634333222222222222222211111111111122222222222223333333354
ddddddccbca9a454dddb9a9646443333222222222222211111111111111000f0ffc09c2143333222222222222222111111111111122222222222223333333536
dedddddccccab8454db0b997644643343222222222222111111111111101000ffc09096633332222222222222222111111111111212222222222222333344352
eedddddcdcac8a84933bb4ba7474434333232222222221111111111111101000ffc0966663333222222222222222111111111111121222222222222222434425
eeedddcdcccaa8a775304bd8574444333332222222221111111111111111000fffe4846636333222222222222222111111111111112222222222222223242455
eedddddcccccba775a0d0d8d8554448333222222222222111111111111100000fef2489543333222322222222211111111111111121222222222223332324345
eeeddddddcccdbaba5a0dad877754d333332222222222111111111111110000feee83a5443432322222222221121111111151111112212211222233333244535
eeeeedddddcdcab8da4daaaa7765564432222222222222111111111111101000ee8d835434343222222222212111111111111111111121122122223323344453
eeeeeddddddccc8c89d91d24b65664642322222222222211111111111111010f0ed8d54543322222222222221111111111111111111112222222222232344438
eeeeeededdccccc8969192d2b565594632322222222222211111111111111000ffccc75433332222222222211111111111111111111111222112222323334447
eeeeeeeedddcccccc9a91426b97677433322222222222221111111111111100ffccccc443334232222222211111111111111111111111111212222223224447a
eeeeeeeedddcccdca966ec669797643433322422222222212111111111110000decec64443323232222221111111111111111111111111111222212333444497
eeeeeeeeedddcccc96966ecdcb766543332322222222222212111111111110000de7676433332322222211111111111111111111111111112112122333444989
eeeeeeeeeedeccccc967ecdcbc66655343322222222222222121111111111000eece76444332222222212111111111111111111111111111111221223424589d
eefeeeeeeeeeecdcca777acdeb8668543482222222222222222111111111110eeeaca444432222222212111111111111111111111111111111212223234545d6
efeeeeeeeeeeedcddba78ad2397676754322222222222222222111111111110fe37054444332222221211111111111111111111111111111111211223234564d
fefeeeeeeeeeeddddcb8b8232369677534222222222222222222111111111110f707054333322222111111111111111111111111111111111112222223343664
ffeeeefeeeeeeeddcdcbbba23816965433222222222221222122121111111100de70543333222221111111111111111111111111111111111112222213436283
fffeffeeeeeeededdcdbbbb5818165433332222222211212121221221111111fed9e563333222211111111111111111111111111111111111112222222362858
fffffffeefeeeeddddddbbbbf418665433322222222211112121122211211111dcd565333322122111111111111111111111111111111111111121222233658d
ffffffeefeeeeeeedddddcbf4f45c654333222222221112112111111222211100dcd533333212111111111111111111011110111001111110111111221432ad8
fffffffffffeeefeedddcccefa775c44433222222111121111111111122111100a7533232212111111111111000100010000101010010110100111122424a8ad
ffffffffffffffeffedecccedc7278744322222221111111111111511112210107573332112111111101110000000000000000010000100100011112224a8a82
ffffffffffffffffffeeecededd78787333222221111111111111111111222101d7343212111110110001000000000000000000000000000000010122232a8ad
ffffffffffffffffffffeededd878813432a2221111111111111111111122111d434332111011100000000000000000000000000000000000000010121032a0d
fffffffffffffffffffffeeefde871e13522221111101101000011111111111565432201101011000000000000000000000000000000000000000010101434d1
fffffffffffffffffffffeeffefe5c1382521211000000000000000111010116460020100100000000000000000000000000000000000000000000010343f31f
ffffffffffffff0fffffffffffefc5c8322011f00000000000f0000010f000c4640ff100f0ff0000f000f000000f00000f0000f0f0f0f00000e0cc00323f34ff
fffffffffffff0fff0fffffff0f00c51220f0ffe00f00f00ff0ff00fff0ffcd14fffeffffffff0ff0f0f0f0f00fff0fff0ffffff0fef0fe00e0cccc523204022
fff000ffffff0f00000ff00f0f00001c12f0fdfefe0ff0ff0fff0fefedffad1d1eeeffefffeffeffeefffffffffffffffffffffefefeeedeeeeccc5d52750222
0000000f00f0f0f000000000000011111a9f9fefefedefeffeeffeeededada01eeddeefeeeeeefeeeeeffffffffffffffeffffefeeeefdedeeeeced5b7655322
0000000000000f000000000000000111a0a988fefddddedeeeeeeeededdaa0deeedddeedeeeeeeefeeffeeffffefffeeeeefeefeeeeeeededeabebdb39565432
000000000000000000000000000011122a058884dadcddcddeedccdc8aa1a140eddddddededeeeeeeeeeeeefefeefeefeeeeeedfeeddeddddafabebd90952d35
000000000000000000000000011111225556384529cdccdcaacc8cc89a0a14dffddddddddddddedeeeeeeeeeeeeeeeeefefeededededddddbfae95dcdeb508d2
000000000000000000000000111112234553e47f969c596aaaa8c8898930254fffddddddddddddededdeeeeeeedeeeedeeeeeddceedbddda87e936cdcd555d44
00000000005000000000010111111134342538fbf9056696aa47872893435454ffedddddddddddddddddeedeedddeedddeeedececdbbbda8a873636cda555584
000000000000000000001111111111234353858f5070561813147ff54d3a35400efdddddddddddeddddddddddddddddddceedddcccbbbc7a87c6c64b8ea45555
0000000000000000000111111112122234445855458961e831349f0d59e3a320ffeddddddddddddeddddddddddddddddcecdcdcccc9bc7676c6c2cb8b8404553
00000000000000000001111111212223434465635818918e834940d0dece82120feeddddddcdcddddddddddddddddddddccddcddc999c676d6adcd4b80645333
000000000000000000111111111222323444464b8b8c3848f8f4960d3ce85821feeeeddddcdcdcddddddccddddcddddddcbcdbdba999bc6d6adad9d705353333
0000000000000010111111111222222333543556b9c3c3c42fc0c96383c585110eeeddddddcccdcddcdccccdccdccdcccbcbbbba9894ba07d9ad9d707b443332
00000000000001111111111122222233353556659b9c3e42f20c0dd636974340ffeedddddcccccdcdcccccdccccccccccdbdbbb989494da01a9c99e764444333
000000000000111111111111122222333354666659aae7ef1fa1d6db597973010feeedddcdcccccdcccdccdcccdccbccbaabcba998946ad547099996a6444343
00000000011111111111111112222223333456655a7a8e91f11e1db9b597333110fedddddcccccccccccbdcccbcdbabbaaaabc9a9fda215475f099e66a846433
000000001111111111111111222222233345463665a7a9b91781e99b965523111feeeddddcdccccccccbcbccbbbbaba9aaab8839edfd1015505f816664484433
000100101111111111111122222222233434546656767a9b7899ac898653522100efedddddcdccccccbcbcabbbbb9a9a9a98838e4ed2d195050fa86664744433
0010111111111111111112122222223333434445666667578999958866651211000eeeddddcccccccbbbbabaaba9b989a9865834e84d287950caf96665444433
010101111111111111111122222222333244444435657774799977545544211100feeeeddccccccccbbbdbabba9b9898b8656547848247810aaca67654454343
101011111111111111111122222222232434444355567777069776455454311110feeeedccccdbccbbabbaab99b9a988a6625484a8945889aaaa676545444433
11111111111111111111122222222223334343344555373564666563454321110fffeedddcccbcbbcabaaaaaa99a9a887b262a4afac908b8aaa9a65654444333
11111111111111111111112122222333333434335555445466465653343221110fffeeedddcccbbcbcaabaaa8899a7378f7284dfaf90c08baaba757564443333
1111111111111111111111121222323333334334355444464665453323222111ffffeeddddcccbbbbba9aaa888895373f7f24d5df40c0c2a9a98875654433333
1111111111111111111112212222233333333343535344446354544432222111fffffdddddcccbbbba9a99aa888595361f8895d54b60c4b2a986898456433333
1111111111111111111121222222223333332234353354444435444342321210ffffeddddcdcbbbbaaa99879a855597028287954b9465b2bca68694544433333
11111111111111111111122222222223333332334445454444443434332321010fffedddddccbbbbaaaa878669555307078297917494efb1a286756444443433
111111111111111111122122222222223333333344445444443443433232111010fefedddccccbdaaaba986666653070737079f7174113ad1a96556444334333
1111111111111111112122222222222233333334343444444443323332222111f0ffeddddcccbcbaaac9a6a644118807aa070f9f71116aaaa766564443334333
11111111111111111112222222222222333333334333234344433333322212100f0feedddcccbbbaac8a6a644451878aaaa070facf1f3aaa7a66654443333433
111111111111111111212222222222222333333333333434343333333221211000ffeeddcdcbcbaaa8a766444512782daa393e0c01f1a77996b6656454333333
1111111111111111111222222222222222232333333333433333333322221110000feeeddcccbbaa8c7674442837875cde9390ac6f1a77776766454643433333
111111111111111111122222222222222232323333333332333233332221210000feeeeddddcbab8c8b7664f2218080d3f1916cdbdf9a7777654544433333333
111111111111111111222222222222222223233333333333232322323212100000feeeedddcccbab8b9666f2f2e180d813818ddbdb9b9b786545445433343332
111111111111111111222222222222222222233333333333323222232221010000ffeeedddcccab9b965644f261ef68181b8d8ddbd7988986554554433434333
11111111111111111122222222222222222322333333333323232222222110100fffffedddccaa9b7856544460a14f081f808dfac0d898865555554343343332
1111111111111111122222222222222222323223323222322232322212111101f0fffeeedcccaaa787754bf02a1a10d0f40f0facac7e89675555444433333332
1111111111111111112222222222222222232223232223231323222222111110000ffeeedcccaa8a7770bdbf0eafda0d5ff0ffcac78766767554444433333323
11111111111111111222222222222222222222223323233132322222222110110000feeeddccaaa897090bd0bffffd33c5dff98877787e674554444353333332
1111111111111111222222222222222222222223233232322322222222111110000fefededdbba9a49902e0b09f5f47c505d98888779a5747444443434333332
111111111111111122222222222222222222222232232322222222222111101000fffeeeddcba994b4e2e2d09e5f5747d50b2988878a5a574544434353333322
11111111111111122222222222222222222222222232222222222122111111010f0fefeedcbcb97945ae2c4de9e5047dcdb1b88678aaa5557444453434333322
111111111111112222222222222222222222222222222222222212211111111000fffefeddcbac964657c4e472d637eeddcb8b67676c65644444443333333322
11111111111101222222222222222222222222222222222222222212111111000fffffededdaaac464496e4e2d2363eaacd8a876768665444444434333333333
111111111111111222222220222222222222222222222222222221221111100000fffeeeddcaaaaa44b639e512d63c1aaaf18a66e56554544633343433333333
1111111111111112222222222222222222222212222222222222222121110100000fffeedddcaaa51536b3e15178c1caa303c606585855444333334333333233
1111111111111112222222222222222222222222222222222222222211111000000fffeeddddcc81516b6efe12525c39e97c376d756574544433343433332322
1111111111111112222222222222222222222222222222222221222211111100000ffeeeeddcb8681536b9e939258b6087877777a66655445333434333333222
111111111111112222222222222222222222222222222222221222210111111000f0ffeedddca6867855f155910158d808787775655544444333343333332422
1111111111111222222222222222222222222222222222222222212111111111000ffefeedcaaa57852f1f15c6d3d8bd8686775a555444444533434333334222
1111111111111222222222222222222222222222222222222121121211111110000fffeeeedaa5852292f12cdd3d898b76687555555544544333343333333222
222111111111122222222222212222222222222222221122121211211111010000f0feeeeedba8581929e2e2c3d3989767678555555464343333334333332322
22211121111112212222222222222222122222222222111221212111111000000000feeedddbb98122952322f098c99976675654564443334333334343332222
221212121111212222222222222222212222222222222121221212111110000000000ffdeddc9d6b2b22323b5989819996756545454433333333333432323222
22212211212212212222222222222212222221222222221212122111111000000000ffffdeccc6c6f20323c69398559997555684544343334333333323232222
22222121121222221122222212222221222222112222221121212111111101000000fffeedcc9c6f50f0fcf9c97581097a555758444433343333333232322222
22222212212111211112222222222222222221111222211112121111111111100f00fffeddd9d9a3ffdf7f2c975787aaa5554545444433333333333324242223
222222222211111111122222222122122221212121221211222111111111111000ffffefedda9a37bd2d32b8c77878a8a5555454445433333333333233233332
222222222222111111112222222111222222122212212111222111111111010000fffefeeeabab7bfbd21b2b7978858a56564744444543333333332222222222
2222222222211111111111222211122222222222221211111211110110101110000fffeeeddab4b6bf21d1b8979f585854665447445443433434332222222222
22222222222211111111111212111222122122221121111111111110010111100000fefeddcd4b4a671d1d858775f58545454444443434334343333222222222
2222222222221111111111112111212111121121111111111111110111100100000f0feeecdcd4b371d1dab87779886854594444334343333432232222322222
22222222222111111111111111121211111121111111111111111110111000000000fffeeecd7c70371da26bb797388655544453433434333322222222222222
5222222222211111111111111111211111111111111111111111110101000000f00fffefeedcd703d2c2214ba5758e5665444444373343433332232222222222
