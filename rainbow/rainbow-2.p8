pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function fflr(a,unit)
	return flr(a/unit)*unit
end

t=0
smpl=1000

for i=0,7 do
	pal(i,i+8+128,1)
end

cls()
::♥::
t+=1/30

local st16=sin(t/16)

for i=1,1000 do
	local x,y=rnd(128),rnd(128)

	if x<64+32*sin(t/8) then
		local c=16 
		+ x / (32 + 16*st16) 
		+ sin((y+200)/8/(x+32)) 
		+ t/3

		local diff=c-flr(c)

		c=flr(c)
		+0.75*flr(x/64+y/16-t)

		c=c%8+8
		if diff<0.3 then
			c-=8
		end
		
		circ(x,y,1,c)
	else
		local c=16
		
		+ (x) / (32 + 16*st16) 
		+ sin((y+200)/4/(x+32))/4
		+ t/3

		local diff=c-flr(c)

		c=flr(c)
		+0.75*flr(x/64+y/16-t)

		c=c%8+8
		if diff>0.5+0.2*sin(t/8) then
			c-=8
		end
		
		circ(x,y,1,c)
	end

	
end

flip() goto ♥
__label__
ooffooofooofooofvooooooooooooooooooo8f8fooo888888888p88888888pppppp9999999999a9aqaqaqrarrbaaabbbbbabrbbbbbsbscbcccscbcccccctcttt
foffofofofofofovffooooooooooooooooo8o8f8oo888888888888888p88p8ppppp999999999a9aq9qaqrarrbrbbbbbbbabbbbbbbbbsbscccccscccccctctctt
foffofofofofoooffofoooooooooooofffoo888o8o888888p8888888p8p98ppppp9p99999999aa99qa9rarrbrbbbbbbbbbbbbbbbbbbbssccccccscccccctcctc
foffofo8ofofofof8foo8ooooooooooffof88o8888o888888p8888888p88pppppp99p9q9999aaaa9a9aararrbabbbbbbbbbbbbbbbbssssscsccccccccccctttt
ooofooo8ooo8ooo8ooo8o8ooooooooooo88f88o88888p88888p88888888pppppp9q9q9q9aa9aaaaaaaarararabbbbbrbbbbbbbbbbsbsssbssccccccccccttttt
88fff88888888888oo8o8ooooooooooo8888o88o88888888888888888888pppppq9q9q9aa9a9aaaaaaaarrrarbbbbarbbbabbbbbsbsbbbsbcscssccccccctttc
8ff8f888888888888888oooooooooooo888888888888888888888888888p8pqpqqqaa9qaaa9aaaaaaaaarrrrbbbbaarbbrbbbbbbbsbrbsbcscccsscccccccccc
888f888888888888888ooo8o8ooooooo88888888888888p8988898889998pqqqqqqaaaaaaaaqaaaaaaarrrrrrbbrrrbrbbbbbbbbsbsbbbsscccccccccccccccc
8888888888888888888oo8o8o8o8ooo8888888888888898988p9889999q9qqq9qaaqaqaqaaaaaaaaaararrrrrbrbrbrbbbbbbbbbbsbbscsbcccccccccccccccc
888888888888888888888o8o8ooo8po88888888o88888898898888899qqq9q9qaaaaqqaaaaaaaaaaaarrrrarrrbrbrbrbbbbbbbbsssscscscccccccccsccctct
o888888888888888888888o8oo88o8poo888888988888889889988999qqqq9qqqaaqqaaaaaaaaaaaarrrarrrrrrrrbbbbbbbbbbbbssbscssbcsccccccccctttc
8888888888888888p88888ooo8oo8op88888889898p888889999999999q9qqqqqaqaaaaaaaaaaaaaarrrrrrrrrbarbbbbbbbbbbsssbsbscscscccsccscsctttt
888888888888888888888o888ooo88888888pp8989p8989999999999999qqqqqqqaqaaaaaaaaaaaaaararrrrrbrbbbbbrbbbbbssssbbssscsccccccscccctttc
88888888888888888888p8888p88888888898898999p89999999999999999qqqqqqaqaaaaaaaaaaaaararrrrabbrbbbbbrbbbbbssbbsscssccccscscccctcttt
8888888888888888888p8p88p8p888899p9898899999999999999999999999qqaqqqaaqaqaaaaaaaararrrrarrbbrbbbbbbbbbbbbbrbcscscccccccccccctcct
8888888888889888888898889p8898989p998pp999999999999999999q999q9aqaqaaaaaqaaaaaaaaarrrrrrarbrbbbbbbbbbbbbsbbbscsbscccccccccsccctt
88888888888989888888888899898989999999pp9p9999999999999999q9q9qqaqqqaaaaaaaaaaaararrrrarrbbbbbbbrbbbbbbsbsbsssbscccccccccccccttt
888888888888989998888p89999898999p999p99p999999999999999999q9qqqqqqqaaaaaaaaaaararrrrarrabbbbbbbbrbbbbbssbbsssscscbccccccccctctt
8888889888888999998988pp9999999999999999999999999999999999q9qqqqqqaqaaqaaaaaaaaarrarararrrbbbbbbbbbbbbsbssbbsssscbcbccccccccctct
o8889888888899999998999pp99999999pp9999999999999999999999q9qqqqqqaqaaaaaaaaaaaaararaaaraarbrbrbbabbbbbbssbsbsbssbcbcbccccccccctd
8o99899889999999999999999999999999p99999998999999999999999q9qqqqqqaqaaqaaaaaaaaaaraarrarrbrbrbbabbbbbbbsbsbsssbcbscbctccccccccct
o898989999999999999999999999999999pp99999999p9999999999q9q999qqqqqqqaaaaaaaaaaaaaaarrrrabrbrarbbbbbbbbbbsbsssscbccsctccccccdcccd
o9998999999999999999p999999999999999999999999999999999q9q9q9qqqqqqqaaaaqaaaaaaaaaaarrrarabarrbbbbbbbbbbbbsbssbbcccccctccdddddddd
9o9999999999999999999p999999999999999999999999999999999q9qqq9qqqqqaaaaaaaaaaaqaaaarararabrrrrbbbbbbbbbbbbbssbsbccccctccccdddddud
o9999999999999999999999999999999999999999999999999999999qqqqqqqqqqqaaaaaaaaaaaaaarararbbrbrrrrbbbbbbsbbbccbbsbccccscctccdddddudu
9999999999999999999999999999999p9999p999999999999999999q9qqqq9qqqqqaaaaqaaaaaaaaaaraaarabrarrbrbbbbbbcbcsscscscccscctccdcddtddud
p99999999999999999999999999999999999999999999999999999q9qqqqqqq9qqaaqaqaaaaaaaaaaraaaaaaarrrbsbbbbcbbbbsssscscscccdtcddcdddddddu
ppp9999999999999999999999999999999999999999999999999999qq9qqqq9q9aqaaqaqaaaaaaaararaabrrbrrbbbbbbcbbbbcbsscscstctttdddddddddddud
pp99999999999999999999999999999999999999999999999999999q9q9q9qq9qqaaqaaaqaaraaaaaraaarrbrbrbbbsbcbbbbbbcccstttdttttddddddddddddu
p99999999999999p9999999999999999999999999999999999999999q999qqqqqaaqaaaaaaaaaaabaaaaaarrbbrbbbccbcbbbbcccctttttddtddddddtddddddd
p999999999999999999999999999999999999999999999999999999999q9qqqqaqaaaaaaaaaaaabaaaabbabbbrbsbcbsccccccccccttttddtddddddddddddddd
999999999999999999999999999999p99999999999999999999999q9q9qq9qqqqaqaaaaaaaaaabaaaaabbbsbbbsbcbcbssccccccctcttcttdddddddddddddudd
p9999999999999999999999999999p99999999999999999999999q9q9qqqq9qqaqaqaaqarabababbaababsbsrbbsccbccccccccctcttttcdtddddddddddddddu
pp9999999999999999999999999999999999999999999999999a99q9qqqqaqqqqaqaaaararabaabbbbabsbssscccbsccccccccccctctttdtdddddddddddddduu
p9999999999999999999999999999999999999999999999999999q9q9qqq9aqqqaqararrrababaabbrbsbsbssccccccccccccccccctctttddddddddddddddduu
pp9999999999999999999999999999999999999999999999999999qqqqqqq9qaaqarararabababbbbbrbssssssccccccccccccccccctctttdddddddddddddddu
ppp999999999999999999999p9999999999999999999999999999999qaqqaqaqaararrrbabbabbbbbbbssbsssscscccccccccccccctttcctddtdddddddddddde
8ppp99999999999999999999999999999999999999999999999999qq9qq9qqqaqrabbrrarabbbbbbbbssssssscccsccccccccccctttttctddddtddddddddeded
p8p99999999999999999999999999999999999999999999999999qqqaqqqqqqqrbbbbbbbabbbbbbbbbsssbssscccccccccccccttctttttttddudddddddeudede
8p99999999999999999999999999999999a9999999999999a9999qqqqqqqqqrqbrbbbbbbbbbbbbbbssbsbssscscccsccccccccddtctttttttuddddudedeeedev
89999999999999999999999999999999999999999999999a9a99a9q9aqqqqrqrabbbbbrbbbbbbbbsbssbssscccscscccccccccctdtctcttdtuuddueeeeeueuve
8p99999999999999999999999999999999a9999999999999aa999r9arqqqrrbrbrbbbbbbbbbbbbbbssbssssccccccccccccccccctctctdduduuueueeeeeeedev
8pp999999999999999999999999999999q99a9a999999999aa99rrrarrqrrbbbrbrbbbbbbbbbbbbbbbbcbssscccccccccccccccccccdcuudueueueeeeeeeeeue
88p999999999a999999999999999999999q99a9a9a9a9999a9a9rrrrrrrrrbbbbbbbbbbbbbbbbbbbbbbbsbsscscccccccccctcccdcdcuduueueueeeeeeeeeuev
8p9p999999999a999999999999999999999a99aaa9aaa999aa9arrrrrrarrrbrbbbrbbbbbbbbbbbbbbbbssssccccccccccccccccduddduuuueueeeeeeeeeeevv
9pp999999999a9999a99a9999999999999a9aaaaaaaaaa9aaaaaarrrrrrrrrrbbbbbbbbbbbbbbbbcbbbsbscsscscccdctccddcccuduuduuuuuueeeeeueeeeevv
8pp99999999999999aa99999999a999aaa9aaaaaaaaaaaaaaaaaarrrrarrrrrrbbbbbbbbbbbbbbcbbbcbscssssscccdddtddddcdduuduueuuudueueeeueeeeev
98999999a99a99999999999aa9a9aaaaaaaaaaaaaaaaaaaaaaaaaarrarrrrrrrrbbbbbbbbbbbbbbbbbcbsstsstctcdddddddddddddduueueeuuuueeeeeeeeeee
8889999aa9a9999999999a9a9a9aaaaaaaaaaaaaaaaaaaaaaaaaarrararrrrrrbbbbbbbbbbbbbbbbbbcsbssttctcdddddddddddddduduueeeeuueeeeeeeeeeef
888p9qaa9a99999aa99aa9aaa9aaaaaaaaaaaaaaaaaaaaaaaaaararrarrrrrrarbbbbrbbbbbbcbbbbstcscttctctdddtddddddddddduuudeeuuuueeueeeeeeee
888999aa999a9a9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaraarrrrrrarrbbbrbbsbcbcbbcbststcttctctttdtdtdddddddddduduueueuuueeeueeeeeve
98p999999999a9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaarrrrrrbrbbbbbbsbsccbccbccstcctctdtdtttttddddddddddduuuuueeuueeeeeeeeevev
99q9a99a999a9aaaaaaaaaaaaaaaaaaaaaaaaaaaaababaaaaaaarabrarrrrbrbsbbbscbscsbcbccccccctctttdtttttddddddddddduuuuuueueuueeeeeeeeeve
999a9aa9a9a9aaaaaaaaaaaaaaaaaaaaaaaaaaabaaabaaaabaararrrrrrrbrbsbbsbccccscsbccccccccctctctttttddddddddddduuuuuuuuedueeeeeeeeeeff
9999a9aaaaaaaaaraaraaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaararrrsrbrbbbbsbcbccccccccccccccccccttcttdddddddddddduduudduuueueeeeeeeeeffev
999a9aaaaaaaaarrrraraaaaaaaaaaaaaaaaaaaaaaaaaaaabaararrrsrsrsbbbsbcbcccbccccccccccttccttttttttddddddddddduuuudeueeuueeeveveeffvf
999aaaaaaaaaaarrrarraaaaaaaaaaaaaaaaaaaaaaaaaabbaaarrrbrbsrsssbscsccccccccccccccccttttctdcdttdddddddddddduuuueueeveefevfffefeffv
99qqaaaaaaaaaarrrrraraaaaaaaaaaaaaaaaaaaabaaabaaaararbrbbbbsssccscsscccccccccccccctttctdtdtddtdddddddduddduuuueuveefefeffffefffv
999qqaqaaaaarrrrrrrraaaaaaaaaaaaaaaaaaaababababbabarbrbbbsbsscccccsccccccccccccccctcctctdtddtdtdddddddddddeuueuvvvfefeffffffffff
999qaqaaaaararrrrraraaaaaraaabaaaaaaaaaabbabbbsbbsbssssssbssssccccccccccscccccccttcttcttcddtdtdddddddddddeeveuvvvvfffffffffffffv
999qqaaaaaaarrrarrrbaaaararabababaabbarbbbbbbsssbbssssssssssscsccccccccscccccccccctttttttttddddddddedddedevvvevvvfffffffffffffff
99q9qaaaaaaarrrbrrrarraarraaabaaabbbbbbbbbbbbssssbsbssssssssbbcscccccccscccccccccctttttdtttdddddddedddddeevvvvevffffffffffffffff
999qqaaaaaaarrrarrrrrrrraraabaababbbbbbbbbbbbbssbssssbsssssbsccsccscccccccccdcccccctttdtduttddeduddeddddevevvvvvfffvfvffefefffff
99qqaaaaaaaarrrrbrrrrrrrrabbabbabbbbbbbbbbbsbbssssssbsssssbsccccsccccccccccccdcccccctttdutuueededueueddevevvvvvfvfefvfefffffffff
999qqaabaabaarrsrbrrrrrrrrbbbbbbbbbbbbbbbbsbsbsssssbsssssssbsccscsccccccdccdcccccdctttuuuuueeeedeueeeeeeevevvvevfvfefeffffffffff
999aqaraaaabrrrrsrbbsrsrsbbbbbbbbbbbbbbbbbbsbbbssbsbbssssscsscscsccccccccccccccccdttttduueueeedeeeeeeeeeeeveevvevfefeffefffffffv
9999rqabaaabbrrsrsrssssssssbbbbbbbbbbbbbsbbbbbsbssbbssssscsssscscctctccdcccdcdccdcuttdddeeeueeeeeeeeeeeeevevvvvvvvffvfffefffffff
a99a9ababababssssrssssssssbsbbsbbbbbbbbsbsbbbbbssssbcssssscsscstscccctccccccdccdcudududdeeeeeeeeeeeeeeeeeevevvvvvfffffffffffffff
pa99rbabababbbsssssssssssssbbsbsbbbbbbbbsbsbbsbbsssbbsssssssccccctctccdcdcdddddcddutudddueeeeeeeeeeeeeeeeevevvvuvvfffvffffffffof
a9aaqrbabbbbbbsssssbssssssssssssbbbbbbbbbsbssbscssbsscsssssccccdccccddcddddddddddddddudddueeuueeeeeeeeeeevvvevvvvfvfvfvffffffofo
9a9qaqbbbbbbbssssssssssssssssssssbbbbbbbsbssbsbssssssssssscsccdcdcccdddddddddddddddduuudeuuuuueeeeeeeeeeevvvvvvvvvfuffffffffffof
q9aaqrbbbbbbssssssssssssssssssssbbbbbbbsbsbsssssssbsssssstsctdtdcdctddddddddddddddduuuueueuuueueeeeedeeeeeveevvvffefffffffffffff
qaaaabbbbbbbsssssbsssssbssssssbcbbbbscsbscscsssssstcsstsssttdtdddddddddddddddddddduuuuddeuueeueeeeeeeeeeevvvvvvffffffffeffffffvf
9qaarabbbbbbssssbsbssssssssssscbcsbsbsbsbsbbssssscstctsssstctdtddddtddddddddtddddduuudduddeeeeeeeeeeeeeeevvvevvffffffffffffffffo
qaaaabbbbbbbbssbsssssssssssssscsscsbscbssssbcsstcstctctsstttdtdddddddddddddddddddduudduudueeeeeeeeeeeeeeeeeevevvffefffffffffffof
qaaaabbbbbbbbssssssssssssbsssssssscbcbsbssstcctcttttttttttttcdtdddddddddddddddddduduuduuedueeeeeeeeeeeeeveevevvfffffvfffffeffffo
qaaaaarbbbbbsbsssssssssscscsssssstssccbststtttcttttttttttttdtttttddddddddddddddddduuduueueeueeeeeeeeeeeeeveevvvffffvfffffffeffff
qqaaarrbbbbbbsssssssststssstcsstssscstctcttttcttttttttttttttddttttdddddddddddddddduduuuueeueeeeeeeeeeeeeveeeevvvfvffveffffffffff
qaaarrrbbbbbcssssssststssssstsssttcstctttcctctccttctcttdtttddtdtddddddddddddddddddduuuuudueeueeeeeeeeueeeueevvvvvfefffffffffffff
9qararbbbbbcscscssssctstssstststttttttttttcccctctcttttdtdtddddtdddddddddddddddddddduuuueuueeedeeeeeeueeeevevvvvvvvfffffffffffffo
q9qarrrbbbcbcsccsssssctttttstttttttttctttcccctttcttttttdtdtdddttddddtdtddddddddddduuuueueueeeeeeeeeeeeeevvvevvvvfvfvffffffffffof
9qqarrrbbcbcbscctssscttttttttttttcttctctcttccttttctttdttdtdddcdcdddddddddddddddddduuuuueuueeueeeeeeeeeevvvvvevefvfvfvffvffffffff
9qbqarsrcccbsbtttttttttttttttttttctctcctttttccttttttdtdttddddddddddddddddddddddduuduuuuuueeeeueeeeeeeeeevveeeevvfvfvffffefffffof
aqqbrrrcscccbttttttttttctcttttttctctttttttttttcttttttdttttddtddddddddddddcdddududuuuduuueeeeuueeeeeeeeeeeeeeevevvfefvffffffffofo
qaqbrrrccccccttttttttttttcttttttccttttttttttccttttttttttttdtdddddddddddtddddddududdduuuuueeeuueeeeeeeeeeeevevevvfefvfvffffffffof
aqbrbrcccccccctttttttdtttttttttcttctttttcttttttttttttttttdddddddddddddtdddddddddddduduuuuueeeedeeeeeeeeeevevvvvvvfefvffffff8ffff
rarbbssccccccttttcttdtdttttttttttttttttcttttttttttttttdtdddddddtddddddddddddddddduuuuuuuudeeeeeeeeeeeeeeeevvevvvvefvfffofof88f8f
aarbsbsccccccctttttttddttdtttttttttttttttttttttttttttdtdtdddddddtddddddddddddddduduuuuueeueeeueeeeveeefeeevevvvfvfffffofff8888f8
arbrbssscccccttttttttddddddtttttttttttttttttttttttttttdtdcdddddddddddddddddddddududuuueeeeueueueeeefeveeeveveefvffffff8fof88888f
abrbbbsssccccttttttttddddddttttttttttttctttttttttttttttdtddddddddddddddddddddduuuduuuuueeueueeeeeefefeeeveveevffvoff8888f8888888
arbbbbbscccccctctttttddtddttttttttttttcttttttttttttcdttddtdddtdddddddddddddddduuuduuueueueueeueeeeefeefeevfeeffvfvf8f8888o888888
rarbbbbcccccccttttttdtddtdttdttttttttttttttttttctttdtdddddtdttdddddddtdddddddddudduuuueueuuuueeveeeeeeefffefffo8v8ff888888888888
arbbbbbscccccttttttttddtdttdtdttttctttttttttttctcttddtdddtdttttddddddduddddddudduuuueuueueevueuefeeeeeeffffffo8o8f88888888888888
aarbbbbccccccctttttttdtdtttddtdttttttttttttdttddctddddtdtdttdtdddddddddddddduduuduuuueeeeuevvuevfeefeeeffooofoo8o888888888888888
aaabbbbcccccccttttttdtdtdddtdddttttdttttttdtdddddtdddddtdtddtddddddddddddddddudduduuedueueuvvvveefeefeffooooofoooo8888888o888888
aabbbbsbccccccctttttddtdddddtdtdttdtdttttdtddcddttddddtttddtddddddddddddddddddddduuuuuvuefvvffefeefffffffooofofoo8o88f8888888888
aarbbsbsccccccttcttdtddddddddtdtdttdttttdtddcddtddtdtttttdtddddddddddddddddddeudeduuvvuffffffffeffffffffffofofoofo8888o888888p88
arrrbbsccccccttttttdddddddddtdtddtttttdttdddddtdtddttttddddttddddddddddededddueudeueuvvfffvffffffffffffffffoffofofof8o8888888888
aarrbbbbccccccttttdtdddddddddtddtdtdtdtdttdddddddtttdtdtdddtdtddddddddedddedddueeeeuvvvffffvffvvfffffffffffffofofooo88888888888p
aaarbbbbsccccccttttddddtdddddddtdtdddtdttttdddddddtdtdtdddddddddddddddeddddddeveeevvvvvvffffffffvfffffffffooofofooo88888888888p8
aarbrbbbscccccttttdtddddtdodddddtdddddtddtttdddddttddtdtddddddddddddddeddddedvevvevvvvvfvffffffffvfffffffoooooo8fo8888888888888p
ararbrbscsccctcttttdtddddddddddtdtddddddddtctddddtdtdddddduddddedddddededeedeevvevvvvvfvfvfvfvffffffffffffoofofoo8o8888888888889
aarrrbbbscccccttttdtdddddddddtddtdtdddddddttdtdddtddddddddduedeeeddeddeeeeeeeeeevvvvvvvfvfvvvfffffffffffffooofo8oo88889888888899
arrrrbbssscccccttttddtddddtdtdddddtdddtddtdtdddddududddudduudeeeeeedeeeeeeeeeveevevvevvvfvffffffffffffffofoooooopoo8888998888899
aarrbbssssccccctttttdddtdtddddddduddddtdtdddtttdudeddeudduddedeeeeeeeeeeueeeeevvevevvvffvffffffffffffffo8ooooooo8pop898988888989
aaarbbbssccccccttttdddtdtddddddduddddddudddddttededdedueudeedeeeeeeeeeeeeeeeeveevvvvvffffvvffffffofffff8o8ooooo8o89p999998889899
aaaabbbbsccccccttttddddududdddduudduddddudddudeuedeudeeueeeeeeeeeeeeeeeeeeeeeeeevevvvfffvvfvffffofffff8f888o88oo89p9999999999999
aaarbbbsbsccccttttttdddtddddddddduddedduuddedeueueueeeeeeeeeeeeeeeeeeeeeeeeeeeeevvevfffffvvfvffffffffff88fo8oopopp9999999p99999p
aarrrbbbssccctttttttdddddddddddudddedeeudeeeeeeueeeueeeeeeeeueeeeeeeeeeeeeeeeeevvvvvvvffvffvfffffffff888f8foppoppp9999p9p9p99999
aaarbbbssscccdtttttdtdtdddddddddddddeeedeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeveevvvvvvvffoffffffff888888pf8pppp8ppp9p99p9p999999
aaaabbbsssccccttttttdtdddddddddudddeeeeedeeeeeueeeeeeeeeeeeeeeeeeeeeeeeeeeeevevveevvvvfvffffffff8888888p8p8ppppppp9p99p989p99999
baaaabbbssccccctttddtduddddeddeeedeeeeeeeeeeeeeeeeeeeueeeeeeeeeeeeeeeeeeeeeffvvevevvvvvfof8fff8ff8888888p8p8pppp8p999p999p999999
aaarrbbbbscccdcutdtdddddedeeeeueeeeueeueeueeeeeeeeeeeueeeeeeeeeeeeeeeeeeeeeeeeevvvfvvfvof88888f8o88888888p8pppppp999p99999999999
aarrrbbbscscccccuudddddedeeeeeeeeeeeeueeueueeeeeeeeeeeueeeeueeeeeeeeeeefeeeeeeevvvvovfof8f8888888888888888pp8pppp99999p999999999
aaarrbbbsscccccctuueddedeueeeeeeeeeeeeeueuueeeueeeueeeeeeeeeeeeeeeeeeeeefeeeffvfvvvvfofof888888888888888p88ppppp9999999999999999
aaarbrbbcsccccctduuueeueeeueeeeeeeeeeeeeeeeeeeeeeeeueeeeeeeeeeeeeeeefeeeefefevfvovooff888o88fo888888888p8pp8p8p9p999999p9q999999
baaarcbcscsddcuduuuuuueeeeeueeeeeeeeeeeeeeeeeeeeeeeeveeeeeveeeeeeeefeeeefffeofvfooofo8888888of888o888888pppp8p9p989999p999999999
ababcbcccsddddduduuuuueueeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeveefeeeffffefffffoofooofofo88o8888o8888888888pppp8p99p999999999999999
babbbcccctdddddduuuuueueeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffefeefffffffffffofofoooooo8o88888o888888888888pp8p9p9999q999999999a9a
bbbbsscccctddddduuuuueeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeveeeeefffefeffffffffffffoffooooo8o8o888o888888888888pppp9p999p9999999a9a9aaa
bbbsbscccctdddduuuuueeueeeeeeeeeeeeeeeeefeeeeeefeeefefeeeeffffeffffffffffooffoffooooo8o8o88o8888888p8888ppppp99999qq999999a9aaaa
bbbbssccccdddddduuuueueeeeeeeeeeeeeeeeeeeeeeeeeeffeefffeefffffffffffffffooooooooooooo8o888o88o8888889888pppp9pp999a99qaqaaaaaaaa
bbbbsbsccctdddddduuueeeeeeeeeeeeeeeefeeeeeeffeefeefffffffffffffffffffffffooooooooooo8888888888o8888998889pp9qp9p9a9aqaqaaqaaaaaa
bbbbbsccctttddddduueeeeeeeefeeeeeeeeeffeeefffffeffeffffffffffffffffffffffffoooooooo888888888888888p9889899pqpqqqqqaaaqaqaaaaaaaa
bbbbssscctttdddeuuueeeeeeeveeeeeeeeeefeeeeffffffffffffffffffffffffffffffffofoooooo8o88o8p8p88888889888899999qqqqqqaaaqqaaaaaaaaa
bbbbssccctttddddeuueeeeeeefeeeeeeeeeefeeeffffvfffffffffffffffffffffffffffofoffooooo88o8p888888888p89889999qqqqqqqqaaaqaqaaaaaaaa
bbbbbccccctdddddduuueefeeeefefeeefeefffeffffvfffffffffffffffffffffofffffffoffofoooo8o88p888888p8899999999qqqqqqaaaqaqaaaaaaaaaar
bbbbbcccccctdddduuuuvvefeeeefefeffffffvffffvfvfffffffffffffffffffff8ffffffffofoooooo8888888888989899999999qqq9aaaaaqaaaaaaaaaara

