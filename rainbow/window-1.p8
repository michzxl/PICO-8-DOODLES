pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
█=1000
dt=0.0333
t=0

p={}
for i=1,#p do
	if p[i]~='' then
		pal(i,p[i],1)
	end
end

cls()

::♥::
t+=dt

for i=1,█ do
	x,y=rnd(128)-64,rnd(128)-48

	c=2*((x-t*8)/32+y/64-t/10) 
		+3*flr((x-t*8)/32)
		+t*3*flr((y)/32)
  +(sin((y-sin(x/(128*sin(t/16)))*3)/32-t)*8>0 and 7 or 0)
	
	c=c%8+8

	if t%12>4 and t%12<8 then
		c=c*x/128
		c=c%8+8
	elseif t%12>8 then
		c=c*x/64
		c=c+y/16
		c=c+sin(x/128)*2
		c=c%8+8
	end
	
	c=((x-t*8-3)/32-flr((x-t*8)/32)<1/32 and 7 or c)
	c=((y-3)/32-flr((y)/32)<1/32 and 7 or c)
	
	circ(x+64,y+48,1,c)
end

flip()goto ♥
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
9aaaaaaa877fefee8ededeeeeffeefeffff8f8ffff777abbbbfbababbbbbdcdccccccccc77788a8f8ff8f8988888898988888a87777d7ccdddcece8e8ee8eded
a99aaaaaaa777edeededeeeeeeefeeffffff8f7fff77aaaaabbababaabbbbdbccccccccc778888aff88f889888888888888989977777cbcccddce8efedeeaede
9999a9aaa7a777ed8ededfeeeffefefffff8f87ff77baaaaaabbaaaaaabbabcbcbcbccccd77889f8f88888c88888988888b899977777bcbcccccedfddddafeed
99999a9aaa7777ddeeeeeefeffffefeeeeffe8fe7e77bdbaadbbaeaaabbababcbcbdbccdc7a7888f8988898b8888f8888ba88998777c7bccccccc9dfdddfdfde
a99aa99ab7777ededeefefefefeffeeeefeefe8ee77bbbaaabbabacabaababbccbdbdbcc7c778f888f8888f8f8888f8b7f8888887777cceccccccccdcdddfded
99a9a9a9a777ededeeeeedfdeefeeeee8effefeeee7b79aaaaababccacbaabbbbbbdccccc7797ff8f8988f8f8f8ff888f9f88887877accccccccccccdcdddede
ba9aaa9a7f7e7edeeeeededeeeeeeeeeefeffefee777979ab9aabbccccaababbbbbccbcc7777ffff8ff888f8f8f8b8889f9999887877cccccccccecdcdcdedee
abaaba9ba777e7ddeeeeee9eefaeeeefeeffffe8f7bc79aa9a9abbbcbaaaabbbbbbcbcb777777ffff8ff888f8f898b898988987887777ceccccceceddcecdede
b9bb99a9777779ddd8dfede9dfffedfeeffefe8e777acaada9aabbcbabaaabbbcbcbcb7b7777f7fffffff888f8f8b9b89888888977777dceccccddde8ecedcfd
9b99999a777deddd8deeddddfdfededeeeefefe8f77baaeabaababbabababbbbbcbcbdb7779f7fff8fff8ff89f899b898888888897777cdcccccd8cce88dcfce
e99999a97777dddddededddedffeedfeeefef8ef7f7db7a8aaaab9abababbbbbcbbbdbbb7777ff8bf8f8ff8f999b98b89888988977e7fdcddccdccccc8ddeced
a9999a9a9777dddeddededeeeeefefe8effefefef7777c7aaaabaababadaaebebbbbbbbbb77778fffa8f8afaf9b8888889898888787fccbcccccddcc8dcdd8ee
9a99b9a997777dedf8fedddeeefefe8efaefe7efe777c7c8aabaabababaaea8bbbbbbcbb77777efffff8ff8fb8fb8f88889898878787dbcbcccdccdc8cccd8da
b9a99b9979777ddd8de8dddfeeeeefefffbefffefe7d7cacdcdaaadabbbcabbbbbbccbbb7777e8efffaf88f88f8ff8f88b8ba8a878777dbbccccddc8dccc8ddd
9c99b9d99777d7ded8de8dfed8eeeefeffefffffe777dacaadaaaaababadbebbbbbccbbbb777aefffffa888888fadf8888b888878777ecec0ccdccfdedc8dddd
c9799d7777f77ddd7787a77d7d77fee7fe7e7f77777777aaacaaaada7a7a7bbb7bbbb7bb7777bfff7f7f788887aa87887b8b8887777ffecf7cdcc7cedd7dddd7
9797777777777d7777777777d777777777e7f7777777777aa7ca7df7a7a777b777b77b77777777f777f777877777787777b8c8777777777777c77c77e7d77777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
e7777777d7777778b9777777779977797777ba7777777777ef7f77777777f77777f777f7777c777777bc77d777d777c7d7777777dd7a777777a7977777777777
7efefe7d7d77a78b899b7bab7999999797cbabab777777fefefff977878f9f9f8f7f8f7f7f77c77c7bcbccbdbd7ddc7c7dcd7dddddd7a7797a9979997997a9a7
effeefe7d7777aa8999bbabaa99999c9ccbbbabcb77787ffef8ff88888fff9f888f888f9f7f7dcacccbccbcbdbcdddcddcdcdddddd77798999a9999999999a9a
ffefeee777777a9ba9aaa9ab9a9b9caccbbbbcbbb77778ff8888f8ff8fffff888888898fff7d7acaccccccbdbcdcdddddecdddddd7777899999a9999a999a989
efeeeeee777777a9aaaa9a99b9abbaabcbbbbbbbb777fffff88ffffff8fff8f88888888f8f77acacccccccdccdcddcddddddeddd7a7797999999999a99999898
feeeeee777777a9aaaada9ab9ababababcbbbbbbb7777fffff8fffff88ffff8888888888f7777acbccccccccccdccdcdddddddd7d7a77999a9999999a999a989
eeeeeeef7777aaaaaaabbabbababbbabbcbcbbcb777777effff8ff8f889ff888888888887777c7bccccccccccdcdccdddddddddd77779a9999a9999aaaaaaa9a
eeeeeefe7777aaaaaaaaaaaabaaabbbbbbcbcbbb77777efeff8ff8f8f8f8f8888888988877777ccccccdcdccccdccdddddddddd7777a79a9999999999aaa9aa9
eeeeeee77777aa9aaaaaaaabaaaaabbbbbbcbcbbb7777eeffffffffff88f8f8888899987877dccccccccccccccdcccdddddddddd77778a9a99999999a9a9a9ad
eeeeee7e7777a9a9aaaaabbbbcaabbbbbbcbbbbbbb77efefffffffff8f88ff88888898987877ccccccccdcdcccccccddddddddd77777c899a9a999999aaa9a9a
ee9feee777777a99aaaababbbababbbbbbbbbbbbb7777eff8ffffffff88ffff888888887877ccccccccdcccdcccdcdcddddddddd77777999999999999aaaa9aa
eedeeeee777777aaaaaaababbbabbbbbbbbbbbbc77777fefef8fffff8888ff8888888989877cccccccccdcdcdcdddcdcddddddd7d7777799999999a9aaaaaaaa
edeeeeeee7777a9aaaaaaabbbbbbbbbbbbbbcbcb777787fefffe8ffff8ff888888888898787c7ccccccdcdcddddcddcdcddddedd7777799999999a9aaaaaaaaa
eeeeedeee77999a9a9baaabbbbbbbabbbbbbbcbb79777eefffffffffffff8f88888888888777c7ccccccdcccddccccdcd8dddddcd778989899999999aaaaaaaa
edeedede7e79999aaa9aababaabbabbbbbbbbbbbb77777eeffeefffffffff88f8888888887777ccccccdccccdccccdccdcddddcdcd778889899999999aa9a9aa
ddddedeeee779abaaaabaaaaababbbabbbbbbbbbb7777eeeeeeeefeffff8f888f89888887777ccccccccdccdccccddcdcdcdedccdc77988889b9a8999a9a9aaa
dddedeeee7e7b99baaaaaaaaaabababbbbbbbbbbb777eee8efeefefeff8f88fff888988777777ccccccccccdcccdcdccdcdcdddcc7779988899b88899999abaa
ddedeeeeee7a7a9aaaaacaaababcbbbbbbbbbbbb7f777eee8ef9eeeffffa8f8f8888888777777cbcccccccccccccdccccdcdddddc7777898988988888999aa9a
eddeddeee777a9a9aaaa9aaaabcbababbababb7b77777eefefefeeeeff8ff8f8888f888877777ccccecccccccccfccccccdcdddc7c77788988888888989a9aa9
deeddfde7777999abaa9d9aaaaaaaabaabaaabbb7777eeeefefffeeffffffffff8f8f88887777bcccbccccccdc8ccccccdccdcdbc7777898888888898999aa9a
eeeeeddee777999b9aaa9dcaaaaaaaaaaaaaaabb777eeeefe8efffffffafffff8f8f88888777c7ccbbbcccecdcccdcccdccccec77777878888898889999999a9
edddeded7e7a79c9b9aac9aaaaaaaaaaaaaaaabb77777ff88eeffff98f9f9ffff8888888787c7cbcbbccbccecdcdcdceccccccd7777778b988b8989999a9999b
ddddded7e7779b999aaa9a9aaaababaaaabbabab777777ef8efeff9ffffffaf8f8889ff787c7cbcbbbbbcbecccecdcdccccccdcd7779c98888899999999999ba
edddd8e77777b99a9caaa9a9aaaabaacabbababab7777efeeeeffffffffff8ff9fbfff8fe87e7cbbbbbbbcececcddccddcdddcdd77779888888989a9999999ac
ededeeee777777a9a9acaa9aaabbaaaaaaaeababbb77e7eeeeeefeffffffffaffffaf8f88777cbbbbbbccccecceccfc8cccdded7777779888898989a99999abd
dedeeeee7777777a9a9acaaaaabbbaaaaaeabbbbbb777e7eeee9efefffff9ffffafff8887777bbbbbccccccccecfccedcccdeee777779898b8b989999a999aa9
edefefe8777c779bb9a9aaaaabaaababa7abbbb7b77787efeeeefefffff9ffffff8f8f8987777bbcccecccccdcccfeeedcdeeee77777a89b8b9b9999a999999a
defdfefe777799999a9a9caaaaaaaaaadababbb77777788eeee8eff8ffff9fff8888f888e8777dbccccececdcccccfeefdddefdf77777a888899b999999999a9
8dd7d777e777799c99a97a7accb77aaaa7a7b77b7777777eee8e8f8f97f7f7f8778878888e777bcccc7de77ccc7c7c7eedddfd7d7777779888b99b999797aa9c
d7777777777777c7777777777777777a77777777777777777877e8f977787f77777787877777b77cc7d7777777c7c77777d777d777777a798777797779777a77
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777e7d7777777d77e7f77777f7f7f7777777777777b7b7c7c777777777c77b7777788777f777777f777777777777777777777777777d777777777
a77aaa7a77777ddded777ddd7de7efe7f7fff7fff77777777b77bbb7bbccc7cc7777c7cb7b77788887fff9788f7f77787997779977777dd7dddd7d7d77ded77e
9aaaaaa7a777d7dedededddfdffefefefffffffff7b77bbbbbbbbbcbbbccccccccccccccb778888888fff88888f999999999999977777ddddddddddddeededed
aaaaaaaa77777deedeededffffffffeffffffffff7777bbbbbbbbbbbbcccccccccccccccc7777888888f88888899999999999999977777ddddddddddeeeeeeee
aaaaaaa77777e7ededeedfefffffffffffffffff77777bbbbbbbbbbbccccccccccccccccc777778888888888999999999999999a77777ddddddddddddeeeeeee
aaaaaaab777e7deedeeefefffffffffffffffff887b77bbbbbbbbbbcbccccccbccccdcdc7777788888888889899999999999999aa7777dddddddddededeeeeee
aaaaaab7b7e7eedeeeeeefeeffffefffffffffff87777bbbbbbbbbbbccccccbccccccdc7d7f78888888888889999999999999999a77777dddddddddeeedeeeee
aaaaaabb7b7dddeeeeeeeffffffffffffffffffff7777bbbabbbbbbbbccccbcbccccccdd7d77888888888888999998999999999a777777ddddddddeeeeeeeeee
aaaaaaabb777deeeeeeeeefffffffffffffffbff87777bbbbbbbbcbcbcccccbcccccccddd77778888888888899998989989999a9a77777dddddddedeeeeeeeed
aa9aaab7777deeeeeeeeeefffffffffeffffff8887b7babbbbbbbbccbcbccccccccccdddd777778888888889999998989989999a7a7c7dddddddddedeeeeeeee
aaaaabaa7777eeedeeeeeeeffffffffffffffff8787bababbbabbbcbcbccccccccccdddd7d77778f888898989899999998989999a777c7cddddddddeeeeeeeee
aaaababb7777eeddeeeeeeffffffffffffffff888777babbbbbbbbbccccbccccccccddd7d77778ff888889898999999999999a9997777cdddddddeeeeeeeeeee
aaaa9bb7b777eeeeeeeeeeffffffffffffffff888777ababbabbbbbcccbcbcbccccdddcd7778ff88f8888898989989999999a9a977777dddddddeeeeedeeeeee
aaa9aabb7b77eeeeeeeeefffffffffffffffff887877b7bababbbbcbcbbbbbccbcccdddd77fff888888889899999989888999a9a77777dddddddeeeededeeeed
a9baababb777deeeeeeeefeffffefffffff88fff87777b7aacbbbbbcbbbbbbbdcbccddd77777ff888888989999999989889899a99777ccdccddddedeeddeeede
99aaaabab777edeeeeefeefeffefefefffff8f7f777777abaabbbbbbbbbbbbbcbccccd7d77777ff88888889999899898888999997777cccccddddeeeeeededed
999aaaabab777ddeedfeffefeefeeeeffffff7f7777777baacabbbbbbbbbbbbbccccddc7d777ff9f88888989989999a8889999999777dcccdcddedeeeeeeeede
99aabaaab77777ededffffffeefeeefeffffff77f7777a7caabbbbbbbbbbbbbcccdddd7d7d777ff88888999888899888888999997777cdcccddddeddedeeeede
99abaaaaa7777deedeeefffeffefeeefefffffff7f7777cababbbbbbbbbbbbbdbccdd7ccd777fff8888999988889888888999999977cccccccdddddddddedded
99aaaaaa7a777edeeeeeeeefeefeeeeefffffffffa7777baabcbbbbbbbbbbbbbbbccccccc7777fff8898998988888888989999997777cccccdddddddddddddde
aaaaaaaaa7777deefeeeefeeeeeeeeefffffffffffa77aacabbbcbbbbbbbbbbbbbcccccc7777f7f8888988888888889989999999977c7cccdddddddddedddddd
9aaaaaaa777d7deeeeeeeeeeeefeeefff8fffffff77caaaabcbcbcbbbbbbbbcbbcccccc778777fff8888888988888888999999997977c7cdddddedddddeddddf
aaaaaaaa7f77dfdeeeeeefeeeeefeffffffffff7777ccaaccbcbccbcbbbbbbbccccccccc8777f7f888988888889888888999999997777cdcddeddedddeddddde
aaaaaaaa77777ddeeeeeeeeeeeeeff8ffffffffff777aacbbbbbbccbbbbbbbcbcccccccc797f7f888889888888888889899a979997777dcdddddddddedfddded
ababaaaa77777deeeeeeeeeeeefee88fffffffffff77aabbbbbbbbbcbbbbbbbcccccccc7c797f9888888988888888a989999799999e7c7ddddddddeddddfdede
bbbaaaa777777eeeeeeeeeeeeeeeeefffffffffff7777aabbbbbbbcbcbbbbbdccccccc7c777f78888898988888888899a999979997777dddddddddddddddeede
bbaaaaaa777777eefeeefeeeeeeeeffffffffffff7777ababbbbbcbcbcbdbdddcccccdcc7777898888888888889889899a99997a77777deddddddeddddddeded
abaaaaaba7777edeeeeeefeeeeeeefffffff8fff7777b7abbbbbcbcbcbcbdcccccccccc7c7777888888888888988a899999999979777dcededededddddfddede
7a7aaaba7f77edee7eeeff7eefe7ffff7f78f77777c77bb7bcbcbcbcb7bdcc77cc7ccd7c77777778878898887888899999a999797977ce7ed7d7eddddedf7efe
7777777777777e7777e7777777777ff77777777777777b7b777b77777d7dd77777c7d77777777777787777777788779977977797977777e77d777777e7777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
eee7777f77777777777777777777b7b77777b7c7777777f7777777787777877f877f77777777777777777c77d7777dcd77d77e77e77779797977777777777777
eeee7efff77779a7a97a7a7777abab7bbbabbcbc77e77f7ffff7d78888e888f8f8f8f788777a7777cb77cccdcdc7dcdcddcde7ee77777797999797aa779a7977
eeeeeefff777779aaa8aaaaaaaabbbbbbabacbc7c77777ffffffdf888f88888f8e8f88977777c7bcbccccccbdcddddcddddddede777779799999faaaa9a9aa99
eeeeeeef777779aaaaaaaaabaabbbbbbbbaccccc77777ffffffefdf8f8f888888888897977777bcbcbccccddbdddddddddeddee7e7777799999f99aaa99aaaaa
eefeeeff7777aaaaaaaaaaaabbbb9abbbbbccccc7777efffffeff8d88f8888888888889777777cbcbccacddddddddddddedeedee77777799999a999aaaaaaaaa
efefeffff777aaaafaaaaaababb99bbbbbbbcbc777777effffffff8e88888888888888779777cbccddccdddddcddddddddeedeee7777799999a9a9aaaaaaa9aa
eefeeeffff787aaaaaaaaaaabbbbbbbbbbccbcbb77777ffffffffff8e8888f88888888897977bccdcdddbdddddcdddddddddeeeee7787999989a9aaaaaaaaaa8
eeeefd7fff7787aaa9aaabab9bbbbbbbbcbccbb777f77fffff888f888888e8f88888987897777cccdddbdbddddddddcddcdceeee7e7797999aa9aaaaaaaaaa8a
feefdff7f7777aaaaa99b9bbbbbbbbbbbbcbbbb7c7777ffff8888888888f88f8888989997777c7dcdcbdcdbddddddddccdceeeeee7797999a9aa9aaaaaaaaaa8
effffd7f77797aaaaa99bbbbbbbbbbbbbbbcbbcc7c7777f88f888f8888888f888889999977777ccdcdccdcddddddddddedeeeee7e77779999aa9aaaaaaaaaaaa
fdfffdff779799aaaaab9bbbbbbbbbcbcbccccbcc7dd7e8f888f88f8e888f88888999999977a7cdcdccdcddddddddddedeeeeeeee77787999998aaaa8aaaaaaa
ddfffffff7799aa9aa9abbbbbbbbbcbcbcccccc7c7d7f7e888e88f88f88f89888f99999999777cbddcccddbdcdddddddedeeceee7e78789999988aaaa8aaaaaa
dddfddff7799aaba8aabb9bbbbabbbcbcabccccc7c7f7fe8888ff8888f8e989889f98999977777cdcddddddbdbcdcddccccdecdde7f7878a9a8aa8aa89a8aaaa
dddddfd7f9899baba9b9bbbbbbbbbbbcacacccc7c777fe8e88ffff8888f8f9f8f99f99899a777cccddbdddddbddcdccceedededcdf7878a8a8a9aa8aa89a9aba
ddfdfdff7f997ababbaba9abbaabbbcbcccaccbc777778f8effffff88f8f8f8f9f99f9999977bcdcdbdbddddddddcdceeeededde7787798a8a9a98aa8a999bab
dfefdf7ef77797abab9a9baabbbbbbbbcccaabbb77777fffeffffffff8ff98fff989999999777dcdbdbddddddddcdceceededddde77797a8a8898989aa99baba
defef7ee779778babab9babbbbbbbbabaccbcbb777777ffffefffffffff989f99898f9989777bddbdbddddddcdccccdedddddddd7777779a8889999999aabba9
deeeeee7e7799b9aabaaababbabbbbaabcbcbcbb7777f7feeffffffffff89899998887899777ddddbcddddccdcdcddddddddcdddd7877979989999999a9aab9b
edeeee7e77977999bab9bab9bbaabbbbcbcbcbbb777e7feeffffffffffff8ff998f888899977dddbdbcdddcccdddcdddddddd7dd777877999999999999a9b9b9
eedeeee7e777779aabaaababbabcbbbabcbbbbbbb777ffffffffffffffff8f88888888f99977cdbdbcccdcdccdcdddddddddcdd777777999999989989999999b
deeeee7e777779aaaaaaaaaabbcacbababbababbb77e7ffeffffffffff88fff888888888977cbccdcbcbcdccccdcdddddddddddd777799999998999999999a99
eeeeeee7e777799aaaaaaaababacabbbbabbabbb7777e7effefffffff8f8f888888888888b7cccdcdcbcccccccdcddddddddddd7d7779999999999999a9aaaa9
deeeeeee7777999aaaaaaaaabaaababbababbbbb777e7efffffffff8ff8ff8888888888897b7c7bdcccccccccdddcdddddddeeed7777799899999999a9a9aaa9
eeeeeee7e7aaa999aaaaaaaaaaaaabbbbbbbbbbb77777effffffffffff88888888888889897b7bccccccccccccddcddddddeddee77777989999999999a9a9aaa
eeeeeeeefeaaaaaa9aaaaaaaaaaaabbbbabbbbbbb77777ffffffffff88888888888888889777b7bccccccccccddddddddddddeddd777989999999999a9a9aaaa
eeeeeefeef7aaaaaaaaaaaaaaaaabbabbbabbbbbb7777dfffffffff88888888888888788b77b7bccccccccdcdddddddddddddddded77799999999a999a9aaaaa
eeeeeeeef77aaaaaaaaaaaaabaabaabbbbbbbbbb7777fff8ffffff8f8888888888888887777bbccccccccdcdcdddddddd7dddedede778a9999999999a9a9aaaa
feeeeeeee7aaaaaaaaabaaaaaabbbbbbbbbbbbccb77f7fff8f88fff88888888888888898777cbcccccccccdddcdddddd0dddeeeee7e7aaa9af9999aaaa9a9aaa
e7eeeeee9777aaaa7a7ab7aa7bbbbbb7bbb7b7bccf77f777f87fffff8777888888888979777c77c7cccccc77777d7dddd77de7eeee77a77a99799aaaaaa97a77
7e77ee777777777777777777b77bbb777b7b7b7c777777777777fff87777778779887797777777777777c777777777de7777777ee7777777a79779aaa7777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777b77777777d7e777e777e7f7d7b7f7f7777877777bcc7777c777777b7777c777777c77777f77777977878d799797777aa777777b7777d7e79e77d7777777
bb9bbab7777d7eeeee7eee7e7ffffe7f7fef8e87877abcccc77cbcc9bab7bcccdc7cb7c7c777f7f7ff988878d89999797aaaaa9a77b7d7dd7e7eeeedee7eee77
bbb9bba77777eeeeeeeeeeeeeffff8effff8e8887777bbcccabbcc9c9bcbddcdcddbccdc7c777ff8ff88888e8e999999aaaaa9a9a77d7dddededeeeeeeeeeeee
bbabbabb77777efeeedeeceeffff8e8fff8f8888777bbbccccbcbcc9bccddddbddddbdddc777788f88988899e99999999aa99a9a7a77ddcddecdceddeeeeeeee
aaaaabbab777efefeeecfeeefffff8f8fff8f888779abfcccbccccc9ccccdddddddddddd777778888889f9999999999ae9a9a9aaa7777decdddcdcddbeeebdea
aaaabaab07777efbeecfffeffffe8f8fff888f8f79a9aa8cbccccccccccccdddddddddddd777778889998999999999a9aaaa9aa9a777deeeddeebdedfefedefe
eaabbbaa77b7efefbceeffeffefff8fff88888877777fba9cc9cbcc8cccccdddcdcddddd7777778d899999999999999aaaaaa9aa7777deeedeeeeedfdfefffef
bbabbba7777b7efaeecdfcfeffef8f88f88888f8777778bc9cccccbdacccdddcddddddd7d77778d8e899999999f999aaeaaa9aaa77777deeddeeeeedfdfffffe
bbbabbb777b7efeeffffdfbfff8ef88e8f8f8f8f87778bbccbccccc9daccdddcdcdddddd7d77878d8e9999e999999aaaafaaaaaaa9797eeeeceeedeeeeafffef
bb89bbbb777cfefffffffbfff8f888888888888877799bcbc9bccccdddab9dc9cdddddddd7777989e8999e899999a9aaf9a9afaaa797cdeeeeeeeeeeeeecebfc
b8bbbbbb7777cffffffefeffff88888888888888f799aabcab9ccccdddc9bcdcacdddddddd77989e99899888a99a9a8f8faaaa9a7777dceeeeeeeeeeedeeceff
8bbbbbbbb777cffffeefefffffbf88888f88888f877a7acacb9accdadccdbddddbcddcedd77779f99999898afaa9a9a88a9aaaa977777ceeeebeeeefeeefefef
99bbab8b77777cffecfefdffcbf8d88888d8888877a7a7fcb9b9abadacdbddddddcacece7777778899989f9faaea9a8ae9aaaa9a7777acceeeebdefefefefefe

