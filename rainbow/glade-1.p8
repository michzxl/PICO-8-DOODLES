pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
t=0
█=1000
function sqr(a) return a*a end
cls()
::♥::
t+=0.0333

for i=1,█ do
	y=rnd(128)-64
	x=rnd(128)-64
	
	c=x/16+sin((y)/128/5)
	c=c+flr(x/20+y/26)
	c=c+sin(x/64)
	c=c+t
	
	c=c%8+8
	
	circ(x+64,y+64,1,c)
end

flip() goto ♥
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
fffffffeffffef8888888999999a9a9aabbbbccccccccdddddddedeeeeeeeeeeeeeeeeeefeffffffffffff8f88888aaaaaaabbbbbbcbccccdcdddddddddddddd
fffffffffffe8888888889999999a9abbbbbcccccccddcdddddddeeeeeeeeeeeeeeeeeeeeffffffffffff8f8888899aaaaaaabbbbbccccccdddddddddddddddd
ffffffffffef888888888999999999bbbbbcccccccddddddddddeeeeeeeeeeeedeeeeeddfeffffffffffff8888898aaaaaaabbbbbccccccddddddddddddddddd
fffffffffef888888808999999999bbbbbbbccccccdddddddddeeeeeeeeeeeeeeeeedefefffffeffffffffff88989aaaaaabbbbbbbccccccdddddddddddddddd
ffffffffff8888888f888999999999bbbbbcbccccccdddddddeeeeeeeedeeeeeeeedefefffffffffffffff88888999aaaabbbbbbbbcccccdddcddddddddddddd
fffffffff8f888888888888999999b9bbbbcccccccccdddddeeeeeeeeeedeeeeeeeefefffffffffffffff8f8899999aaaaababbbbccccdcddddddddddddddddd
ffffffef8f88888888888889999999bbbbcbcccccccddddddeeeeeeeeeeeeeeeeeefefefffffffffffffff8f99999aaaaaaaabbbbccddcdddddddddddddddddd
fffffffef888888f88888889999a9bbabbbcccccccdcddedeeeeeeeeeeeeeeeeedefffeffffeffffffffff99999999aaaaaaaabbbbcbddddddddddddddddddde
ffffff88888888f888888889999aabbbbbbbcbcccccdcedeeeeeeeeeeeeeeeeeeeffffffffffeffffffff98999999aaaaaababbbbbbdddddddddddddddddddee
fffff8888888f88888888889999aababbbbbbccccccccdeeeeeeeeeeeeeeeeeeeffffffffffffffffffff8999999aaaaaababbbbbbbddddddddddddddddddeee
ffff8888888888888888889999aaaabbbbbbcccccccceeeeeeeeeeeeeeeeeeeefeffefffffffffffffff888899999aaaaaababbbbbcdddddddddddddddddddee
fffff88888888888888888999aaaabbbbbbbcccccccceeeeeeeeeeeeeeeeeeefefffffefeeefffffffff888999999aaaaaaaaabbbcddddddddddddddddddeeee
fffff88888888888888888999aaababbbbbbcccccccedeeeeeeeeeeeeeeeeeeefffffefefefffffffff88898999999aaaaaaaabccdcdddddddddddddddddeeee
eff88f8888888888888888999aaaababbbbbbccc0cdeedeeeeeeeeeeeeeeeeeeefffffefffffffffff8888899999999aaaaaaacbccdccddddddddddddddeeeee
f8f88888888888888f888889a9aaabbbbbbbccbccdcdedddeeeeeeeeeeeeeeeffffffefffffffffff88888899999999aaaaabbacccccddddddddddddddedeeee
8f888888888888888888889aaa9ababbbbbbccccccdeddeeeeeeeeeeeeeeefffffffeffffffffffff8888880999999aaaaababccccccddddddddddddddeeeeee
f88f88888888888888888999aaaaababbbbbbcccdddddeeeeeeeeeeeeeeefffffffefffffffffffff8888889999999aaaaaabbcccccccddddddddddddeeeeeee
8888f8f88888888888898999aaaaaaabbbbbbccddddddeeeeeeeeeeeeeeeeffffffeffffffffffff888888989999999aa0aabcbcccccdddddddddddddeeeeeee
88f8888f888888f888889999aaaaaabbbbbbbccdddddddeeeeeeeeeeeeeefffffffffffffffeffe8888888899999999aaabacbcccccdcdddddddddddeeeeeeee
8888888888888f888899999aaaaaabbbbbbbbcdcdddddeeeeeeeeeedeeefffffffffffffeefffef8888888889999999aaaabbcccccccdcdddddddddeeeeeeeee
888888f8f8888888899999a9aaaabbbbbbbbbdcdddddedeeeeeeeeeeeeffffffeffffffeffeff888888888899999999aaabbbcccccccccddddddddeeeeeeeeee
88888f8f8888888989999a9a9aaaabbbabbbdcdddddededeeeeeeeeefefffffefeffffffefffff88888888899999999aabbbbbccccccccddddddddeeeeeeeeed
8f88fff888888899999999a9aaaaaaabbbbccdddddddedeeeeeeeeefefffffefeffffffefefff8f8888888999989999abbbbbbcccccccddddddedeeeeeeeeeee
f8888fff888f88899999999aaaaaaaabbbbbddddddddddeeedeeeeeefffffffffeffffefeffff88888888889889999a9bbbbbcbcccccddddddeeeeeeeeeeeeee
888888f8f88888999999999aaaaaaaabbcbdcddddddddddeeeeeeeeffffffffffffffffefeff88888888888989999a9bbbbbbccccccccddddddeeeeeeeeeeeed
88888fff8888f99999999999aaaaaaaacbccddddddddddeeeeeeefffffffffffffffffefeeff888888888888999999abbbbbcbcccccccdddddeeeeeeeeeeeeee
8888fffff8888999999999999aaaaaabcccccdddddddddeeeeeefffffffffffffffffeeeeef888888888888989998aaabbbbbcbcccccdcdddcdeeeeeeeeeeee0
888fffff8f88f9999999999a9aaaaabcbcccccdddddddedeeeefeffffffffffffffffeee8ff8888888888888889a9aaabbbbbbcbcccccdcdeeeeeeeeeeeeeeee
8fffffff88f98899999999a9a9aaaacbccccccddddddeeedeefffffffffffefffffffee8f8f888888888888889a9aaabbbbbbbbcccccccdeeeeeeeeeeeeeeeee
f8ffff88f89899899999999a9aa9aabccccccdddddddeeeeefeffffffffffff0feffeeff8fff888888888889889aaabbbbbbbbcccccccdeceeeeeeeeeeeeeeee
8fff88f88ff9999999999999aaaaabbccccccddddddeeeeedeffffffffffffffefffffff8fff88888888889898aaaabbbbbbbcccccccdddeeeeeeeeeeeeeeeee
ff88888888899999999999999aaabbbbcccccdddddddeeedefffffffffffffffeefffff8f8ff88888888888989aaaaabbbbbbcccccccddddeeeeededeeeeeeee
f8f888888898999999999999aaabbbbcbcccdddddddddedefffffefffffffffeffef8fff8ff8f888888888889a9aaababbbbbbcccccccddeeeeeeedeeeeeeeed
0f8f8888888989999999999aaabbbbcbcccdddddddddddeffffffffffffffffffff8f8ffffff888888888889a9aaaaabbbbbccbcccccdeddeeeeedeeeedeeefe
8888f8f8988899899899999aaaabbbbcccccdddddddddddefffffffffffffffffff888fffff88888888888989a9aaaababbcbccccccddeedeeeeeeeeeeeeefff
88888f998988989999999999aabbbbccccccccdddddddddeffeffffeffffffffe88f8f88fff888f8888889899aaaaaabbbbbcbbcccddddeddeeeeeeeeeeeefff
888899899888899999999999abbbbcbccccccdddddddddefffefffffffffffff8888f8888f8f8f8888889899a9aaaabbbbbbbcbccddddeddeeeeeeeeeeeeffff
8f898998888888999999999a9abbbbcbccccdddddddeedfffffffffffffffffef88888888ff8f8888889999aaaaaabbbbbbbbbccddddedeeeeeeedeeeeefefff
f8f9988888888889999999a9abbbbbbccccccdddddeeeeffffffffffffffffefe8888f88ff8088888898999aaaaaaabbbbbbbbcccddddeddeeeeeeeeeeeeffff
8f9999888888888999999a9abbbbbbcccccccdddddeeeeffffffffffffffff888f88f8fffff8f88888899999aaaaaaaabbbbbbdcdddddddededeeeeeeeeeffff
f99998988888888999999aaaabbbbbccccccdddddeeeeeefeffffffffffff8f8888ffffffffff888889999999aaaaaaaabbbbdddddddddededeeeeeeeeefffff
f9998988888888889999aaaaabbbbbbccccccddcdeeeeeeffffffffffffe888888f8ffffffff8f88989999999aaaaaaabbbbbcdddddddedeeeeeeeeeeeeffffe
99998888888888898999aaaaabbbbbbbbccccccdeeeeeeefffffefffffff8888888ffffffffff8ff899999999aaaaaaabbbbcbcdddddd0eeeeeeeeeeeeffffff
899888888888888898aa9aaaabbbbbbcccccccceeeeeeeeffffffffffff8888888fffffffffffff999899999a9aaaaaabbbcbccddddddeeeeeedeeefeffffffe
9989888888888898899aaaaaabbbbbcbcccccccceeeeeefeffffffffff888888f8ffffffffffff99999899999aaaaaabbbbcccdcddddddeedeeeeefeffffffff
9898888888888889999aaaaaabbbbbbccccccceceeedeeeffffffeffffe888888f8ffffffffff889999999999aaaaaabbbcccccdddddddddeeeeeeeffffffffe
898888888888889989aaaaaababbbbbbbcccccceeeeeeeffeffffffeff888888888fffffffff88898999999999aaaaaabcccccddddddddddedeeeeffffffffff
888888888888898998aaaaaaabbbbbbbbccccceeeeeeefefffeffffff8888888f8f8fffffffff888999999999a9aaaaabcccccdddddddddddeefefeeffffffee
989888888888889999aaaaaaaabbabbbcccccddeeeeeeefffffefff8f88888888f8fffffffff888989999999a9aaaaaacccccdcdddddddddddfefefffffffffe
898988888888888a9aaaaaaaabaabbbbccddddeeeeeeeeeeffefef8f8888f88888fffffffff88888909999999aaaaaacccccccddddddddeddedfffffffffffff
98988888888888a9aaaaaaaababbbbbccddddddeeeeeeeeefefefef8888f88888fffffffff88888999999999999aaabacccccddddddddedeeeeffffffffeffff
888888888888898a9aaaaaaaababbbbcccddddeeeeeeeeeeefefe8f888888888ffffffffff888889998999999a9aababbccccdddddddddedefffffffffeffffe
9888888888888899aaaaaaaaaababbbccccdddeeeeeeeeeeeeee8f888888888f8ffffffff888888898999999a9a9abbbccccdcdddddddddefeffffffffffffef
89888888888899999aaaaaaaaaabbbbbccdddddeeeeeeeeeefe888f888888888f8fffff888888888898999999a9abbbcbccccdccddddddedefeffffefefffffe
988888888889899999aaaaaaaaaabbbbccddddeeeeeeeeeefee888888888888f8ffffff88888888889999999a9ababbcccccccccdddddddedeffffffffffffef
98888888889999999aaaa9aaababbbbcddddddeeeeeeeeeeef8f888888f8fff888ffff8888888888989999999a9abbcbcccccccdddddddedeffeffffffffffff
89888888899999999aaaaaaababbbbcdddddddeeeeeeeeeef8888888888ffff888ff8888888888888999999999abbbbcbcccccdcdddddddeeeeffffffffffefe
988888889999999999aaaaaaababcccdddddddeeeeeeeeeee8888888888f8f8f8fff88888888888888899999a9bbbbbbbccccdcdcdcddeeeeeefffffffffffef
88888889899999999aaaaaaaaabcbcccdddddddeeeeeeeeeff88888888f8f888fffff888888888888889999a9abbbbbbbcccccdddcdeeeeeeeeffffffffffeee
888888889999999999aaaaaaabcbcccccdddddeeeeeeeeefefff8888888888f8ffff88888888888888999999abbbbbbbbbccccdcdcdeeeeeeeeffffefefeeeee
888888899999999999aaaaa9bcbcccccccddddddeeeeeefeffff8f8888888f8fff8888888888888888999999aabbbbbbbccccccdcdeeeeeeffefffffefefefff
8888889899999999999aaaaaabcccccccddddddddeeeeeffff0ff8f88888f8fff88888888888888889899a9aaaabbbbbcbccccccdedeeeeffffefffffefefeff
8888898999999999a99aaaaabccbcccccddddddeeeeeffffffff8888888f888f8f888888888888888899aaaaaaaabbbbbcccccccddeeeeeeffefefffeeefefff
888899999999999a9a99aaabcbccccccccddddedeeefefffffff888888888888f88888888888888889889aaaaaabbbbbbccccccdddeeeeeeeefeffffffefefff
8898899999999999a99aaabbbccccccccddddddedeeefffffff8f8888888f88f88888888888888888888aaaaaaabbbbbbbccccccdeeeeeeeeeefefffff8effff
899999999999999999aaaaabbccccccccdddddddeeefffffff8f8ff88f8888f88888888888888888998aaaaaaaabbbbbbccccccddeeeeeeeeeeefeffffe8ffff
8899999999999999999aabbbbbccccccccddddddeeeffffff8f8f8f8f88888888888888888888889999aaaaaaaabbbbbbbccccddddeeeeeeeeeeefeefe8fffff
8999999999999999999aaabbbbcccccccddddddefeffffffff8f88ff88888f88888888888888888899aaa9aaaaabbbbbbcccdddedeeeeeeeeeeeeeeeee8fffff
999999999999999999aabbbbbbbcccccdddddddfefffffffff8f8f8fff88f888888888888888888889aaaaaaaababbbbccccddddeeeeeeeeeeeeeeeeeff8ffff
99999999999999999a9babbbbbccccccddddddddfefffffff8f888f8f8f888888888888888888889999aaaaaaaabbbbbbccdcddddeeeeeeeeeeeeeeeffffffff
999999999999999999abbbbbbbbccccccddddddeefffffffff88f88f8f8f88888888888888888889999aaaaaaaaabbbbccccddddeeeeeeeeeeefee88f8ffffff
999999999999999999babbbbbbbcccccddddddedeefffffff8f888f888f888888888888888888898999aaaaaaaaabbbbbcdddddeeeeeeeeeeefef8888f8fffff
999999999999999999abbbbbbbbbcccccddddedeefefffffff8fff88f888888888888888888889899999aa9aaaaaabbbcddddddedeeeeeeeeeefe888f8ffffff
99999999999999999abbbbbbbbbbbccccddddeeefffffffffff8ff8f8f8888888888888888889899999aaaaaaaababbbccddddddedeeeeeeeeee8f8fffffffff
99999999999999999aabbabbbbcbccccccddeeeeeffefffffffffff8888888888888888888898999999aaaaaaababbbccccdddddeeeeeeeeeeeef8ffffffffff
9999999999999999aabbbbbbbcbccccccddeeeeeeffffffffffffff888888888888888888888999999a9aaaaaaabbabcccdddddddeeeeeeeeeffffffffffffff
99999999999999aa0aabbabbbbcccccccceeeeeeffffffffffffff9888888888888888888899999999aaaaaaaaabbbccccdddddddeeeeeeeeeffffffffffffff
9999999999999aaaa0ababbbbbbbcccccceeeeeeeffffffffffff9899888888888888888899999999aaaaaaaaaabbccccccddddddeeeeeeeefeffff0ffffffff
999999999999aaaaaaaabbbbbbbccccccddeeeeefeffffffffffff9989888888888888898999999999aaaaaaaababcccccddddddedeeeeeefeffffffffffffff
99999999999aaaaaaaaaabbbbbbcccccddddeeeeeffffffffffff88898888888888888899999999999999aaaaaabccccccddddddeeeeeeefefffffffffffffff
99999999999aaaaaaaaabababbbbccccdddeeeeeefffffffff8f8889888888888888889899999999999aaaaaaaacccccccdddddededeeeefffffffffffffffff
9999999999a9aaaaaaaaabbbbbbcccddddeeeeeefefffffff888889898888888888888899999999999a9aaaaaabccccccccdddddeeeeee0effffffffffffffff
99999999999aaaaaaaaabbbbbbcccccddededeeeeffffffff8888889888888888888888899999999999aaaaaababcccccccddddeeeeeeeefffffffffffffffff
99999999aaaaaaaaaaaabbbbbbbcccddddeeeeeefffffffff888888888888888888888999999999999aaaaaaaabbccccccdcddddeeeeffffffffffffffffffff
9999999a9aaaaa9aaaabbbbbbbbcccdddedeeeeeeffffffff888888888888888888898999999999999aaaaabaabccccccccddddddeefffffffffffffffffffff
99999999aaaaaaaaaababbbbbbbccddddddeeeeeeeffffff88888888888888888888999999999999999a9aaabbbcccccccdddddddeefffffffffffffffffffff
9999999aaaaaaaaaaaabaabbbbcbccddddddeeeeefefff8888888888888888888889999999999999999a9aaabbbbccccccddddddedfffffffffffffffffffff8
9999999aaaaaaaaaaaaaabbbbccdddddddeeeeeeeefeff88888888888f888888899999999999999999a9ababbbbbccccccddddddefffffffffffffffffffff88
999999aaaaaaaaaaaaaabbbbccdddddddeeeeeeeeefff88888888888888888889999999999999999999a9bbbbbbccccccddddddedeffefffffffffffffff8888
9999aaaaaaaaaaaaaaababbacccddddddeeeeeeeefe8ff888888888888888888999999999999999999999abbbbbbccccccddddddeefefffffffffffffff8f888
999aaaaaaaaaaaaaaaaabbacccdcddddddeeeeeeee8e88888888888888888888999999999999999999a9abbbbbbbccccccdcddddeeefeffffffffffffff88888
999aaaaaaaaaaaaaaaaabbcccccdcddddddeeeeeefe888f888888888888888999999999999999999999aabbbbbbbcccccdcddddeeefeffffffffffffff8f8888
999aaaaaaaaaaaaaaaaabbccccccddddddedeeeeee88888888888888888888899999999999999999999aaabbbbbbccccccddddeeefeffffffffffffffff88888
99aaaaaaaaaaaaaaaaabacbccccdcddddddeeeeee888888888888888888889999999999999999999a9aaababbbbbbcccccddddeeeefefffffffffffffff8888f
aaaaaaaaaaaaaaaaaaaacbccccccdcddddddeeee8e8888888888888888889999999999999999999a9aaababbbbbbccccccddedeeeefefffffffffff88f888888
aaaaaaaaaaaaaa9aaaabbccccccccddddddeeeefe88888888888888888898999999999999999999aaaaaabbbbbbbccccccdeeeeeefefffffffffff8888888888
aaaaaaaa0aaaaaaaaababcbcccccccddddeeeefff8f8f888888888888889999999999999999999a9aaaabbbbbbbbcccccdddeeeeeefefffffffffff888888888
9aaaaaaaaaaaaaaaaaabccccccccccdddedeeeffff88888888888888889999999999999999999aaaaaaaabbbbbbbccccccddeeee0eefffffffffff8888888888
aaaaaaaaaaaaaaaabaabcccccccccdddddeddfefff8888888888888888899999999999999999a9aaaaaaabbbbbbbbccccddeeeeeeeeffffffffffff888888888
aaaaaaaaaaaaaaababbbbcbcccccdcddddddfdfff888888888888889889999999999999999999aaaaaaababbbbbbbcccddeeeeeeeeeefffffff8ff8888888888
aaaaaaaaaaaaaaaabbbbbbcbcccccddddddfffff888888888888889899999999999999999998aaaaaaaaabbbbbbbbccddedeeeeeeeffffffff8f888888888888
aaaaaaaaaaaaaababbbbbcbccccccdcdddfdfffff8888f8888888889999999999999999999aaaaaaaaaaaabbbbbbcccdddedeeeeefffffeff8f8888888888888
aaa9aaaaaaaaababbbbbcbccccccccdcdddfffffff88f8888888889999999999999999999a9aaaaaaaaaabbbbbbbccdddddeeeeeeeffffffff8f888888888888
aaaaaaaaaaaaabbbbbbbbcbcccccddddeeefffffff88888888888999999999999999999999aaaaa9aaaaabbbbbbbdddddddeeeeeeeffffff8888888888888888
aaaaaaaaaaaabbbbbbbbbbcccccdddddeeeffffffff88888888899999999999999999999a9aaaaaaaaaaaabbbbbbbddddddeeeeeeeffffff8888888888888888
aaaaaaaaaaabbbbbbbbbbcccccccdddeeefefffffff8888888889999999999999999999a8aaaaaaaaaaaaaabbbbbccddddddeedeeeefffff8888888888888888
aaaaaaaa9aabbbbbbbbbbbccccccdddeeeefffffffff8888888989999999999999999999a9aaaaaaaaaaaabbbbbccddddddddeeeeefffff8f888888888888888
aaaaaaaaaabbbbbbbbbbbbccccccdddeeeefeffffffff88888989999999999999999999a9aaa9aaaaaaaaabbbbbccdddddddeeeeeeefffff8888888888888888
aaaaaaaaababbbbbbbbbbcbccccccddeeeeeffffff88f888888999999999999999999999aaaaaaaaaaaaaabbbcccccdddddddeeeeeffff888888888888888888
aaaaaaaaaabbbbbbbabbbbccccccddeeeeefeffff8888888889999999999999999999a999aaaaaaaaaaaababcccccdcddcddeeeeeeeff8888888888888888888
aaaaaaaaabbbbbbbbbbbbbcccccddddeeeeefeffff8888889999999999999999999a9aaaaaaaaaaaaaaababbbccccdcdddddeeeeeee888888888888888888888
aaaaaabbbabbbbbbbbbbbbcccccddddeeeeeefffffff888999999999999999999999aaaaaaaaaaaaaaaaabbbacccdcdddddeeedeeee888888888888888888888
aaaaaabbbbbbbbbbbbbbbbbccccddddeeeeefffffffff89999999999999999999999aaaaaaaaaaaaaaaaaaabbbcccddddddeeeeeeefe88888888888888888888
aaaaaaabbbbbbbabbbbbbbcbcccdddeeeeeeeffffffff99999999999999999999a9aaaaaaaaaaaaaaaaaaacbbccccddddddeeeeeefff88888888888888888889
aa9abaaabbbbbbbbbbbbbbbccddcdeeeeeeeffffffff99999999999999999999aaaaaaaaaaaaaaaaaaaaacbccccccdddddddeeeeffff88888888888888888999
aaababbbabbbbbbbbbbbbbbcddddeeeeeeeeffffffff9999999999999999999a9aaaaa9aaaaaaaaaaaaaaacbbcccccdddddedeefeff8888f8888888888889999
aaaabbbbbbbbbbbbbbbbbbccdddddeeeeeeeefffffff899999999999999999a9aaaaaaa9aaaaaaaaaaaaabbcccccccddddddeeeffff888888888888888889998
aaaaabbbbbbbbbbbbbbbbbcddddddeeeeeeeffffff88999999999999999999aaaaaaaa9aaaaaaaaaaaaabbcbcccccdcdddddedefffff88888888888888899999
ababbbbbbbbbabbbbbbbbcbddddddeeeeeeeeffffff9999999999999999999aaaaaaaaaaaaaaaaaaaabbbcbcccccccdddddddeffffff88888888888889899999
bbbbbbbabbbbbbbbbbbbbbdcddddedeeeeeeffffff8899999999999999999aaaa9aaaaaaaaaa9aaaabbbbbccccccccddddddfffffff888f8888f888898999999
bbabbbababbbbbbbbbbbbbcddddddeddeeeefffff8888999999999999999aaaaaaaaaaaaaaaaaaaa9bbbbbbccccccccddddddffffff888888808888989999999
bbbabababbabbbbbbbbbccddddddddeeeeefeff88888999999999999999a9aaaaaaaaaaaaaaa9aaabbbbbbcccccccccdddddffffff8f88888888888999999999
abbbababbbbabbbbbbbcccdddddddeeeeeeeffff888999999999999999aaa9aaaaaaa9aaaaa9ababbbbbbbccccccccddddeffffffff888888888888999999999
bbbbbbbbbbbbabbbbbbbccddddddddeeeeeeeff8889899999999999999aaaaaaaaaaaa9aa9aaaabbbbbbbbbbccccccddddeffffffff888888888889999999999
abbbbbbbbbbbbbbbbbcccdddddddddeeeeeeef8888898999999999999a9aaaaaaaaaa9aa9a9aabbbbbbbbbbccccccdddddeeffffff8888888888999999999999
bbbbbbbbbbbbbbbbbc0cccddddddddeeeeeeeff88888989999999999a9aaaaaaaa9aaa99a9aaabbbbbbbbbbccccccddddeeefffffff888888889999999899999
bbbbbbbbbbbbbbbcbccbcccccddddedeeeeff8888888898999999999aaaaaaaaaaaaaa99999abbbbbbbbbbbbccccccdeeeeeeffffff888888889999999999999
bbbbbbabbaaaabcbccccccccddddddeeeefef888888888999999999a9aaaaaaaaa9aa99999abababbabbbbbbbbcccccceeeeeeffff8f88888898999999999999

