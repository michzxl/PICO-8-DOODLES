pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
█=1000
dt=0.0333
t=0



for i=0,7 do
	pal(i*2,i+8,1)
	pal(i*2+1,i+8+128,1)
end

cls()

::♥::
t+=dt

for i=1,1300 do
	local x,y=rnd(128)-64,rnd(128)-48

	local c=1*((x-t*8)/64+y/128-t/10) 
		+1*flr((x-t*8)/64)
		+t*1*flr((y)/64)
  +(sin((y-sin(x/(128*sin(t/16)))*1)/32-t)*1>0 and 7 or 0)
	
	if t%12>4 and t%12<8 then
		c=c*x/256
	elseif t%12>8 then
		c=c*x/128
		c=c+y/32
		c=c+sin(x/128)*2
	end
	
	c=((y-3)/64-flr((y)/64)<1/12 and flr(t)*2+1 or c)
	c=((x-t*8-3)/64-flr((x-t*8)/64)<1/16 
			and flr(t)*2
			or ((x-t*8-3)/64-flr((x-t*8)/64)<1/8
					and flr(t)*2+1
					or c))
	
	
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
oddddododooooooa9a9999ppppqptp9999999p9999ttptp9p9p9p99ppppppppppppppepepepepepe999papapaqaaaaaaauquuuqqaaaauaauauuqqqaqqqqqqqqq
odddooodooooooooa999999ppqpq9999999999999t9tt9p99p9p99p9ppppppppppppeeepppepppepe9paaa9aqpqaauaaaauuuuaquaauauuauuquqaqaqqfqqqqq
oodooooooooooooaoa999a9qpqq999999999999999tp99999999999pppppppppppppeepppppppppe999aaa99pqaaufuaaaaquaauauaauqauaquqqqaqqqqqqqqq
ooooooooooooooooaa99a9q9q9q999999999999999999999999999pppppppppppppppeppppppppppa99aaa9pppaqauaaaaaaqaaauaaaqaqaqaaqqqqfqqqqqqqq
ooooooooooooooooa9a99a9qqq99999999999999999p999999999ppppppppppppepppp8ppppppppapa9aaappppqaqaaaaaaaaaaaaaaaaqafaaqaqqqqqqqqqqqq
oooooooooooooooo9a999paqqq9q99999999999999e999999p99ppppppppepppppppppppppppppppap99a99ppppqaaaaaaaafqaqafaaqqaaqqaqaqqqqqqqqqqf
ooooooooooooo9o9999a99pqqqq9q9999p9999999p9p999999p9pppppppeppppppppppppppppppppp99999fqpqaaaaaqaaafqaqafaqaqaaaaqqaqaqqqqqqqqqq
oooooooooooooo9oo9a9a9ppqq9q99999999p999p99999p9pp9p99ppppppppppppppppppepppppppp9a999qpqpqaaaaaaaaaaaaaaaaqqqaaaaafaqqqqqqqqqqq
oodooooooooooooooo9a999qpq999999999999999999999pp9999p9eppepppepepppppppppppp9pp9a9a99pqpqppaaaaaaaaaaaaaaaqqqaaaqfaqqqqqqqqqqqq
ooooooooooooooooo9a9a99qq99999e99t999999999e99pp9999p9pppppppppppeppppppppppppppp9a99p9apppaaaaaaaaaaaaaaaqfaaqqfaffqqqqqqqqqqqq
ooooooooooooooo99a9aaaqpq9999te99999999999e99e99p999ppppppppppppppeppppppeppppppp99999a9apqaaaaaaaaaaaafaffaaaaqafaafqqfqqqqfqqq
oooooooooooooo9999aaaaaqpp9e9e99999999999e99e9999e9ppppppppppppppepeppppppppppppaa99999apqpqaaaaaafaafaaaafqaaaafaaaafqqfqqqqfqq
oooodoooooooodo99a9aaa9ppep99999999e999999e99e99eepppppeepepepppppepppppppppp9ppaaa999p9qpqaaaaaaaaaaafaaaafaaaaqqaaaqqqqfqqqqqq
ooodooodoooodo999aa9999pept999t99t99e99t9e9999eeepppppeepepeeepppppppppppepp9pppaaa9999ppqppaaaaaaaaafaaaafaqaaqqaqaqqqqqqfqqqqq
ooddoooododod9o9a9a999paptpt9ttette99t99t9e999eeeeppeeepeppeepeppepepppeepupp9ppaa9999appppafaaaauaaaaaaafafaqffqqaqqqqqfqqqqqqq
oooodoodooodod9d9a9a9papapqqtttttt9t99tt9te99eeeepeeeeeeppeppepeeeeppppppapep9ea9a99aapappquaaaaaauaaaaafafffffqfqqqfqqfqqfqqqqf
ooooodddodoooodoa9a99p9apqqq9tttttt9ttttte9e9eeepepeeeeeeeppepeepeepepppppepee9ea99a9aaqpquqafaauaaaaaauaffaffffqqqqqqqqfqqfqqfq
ooododdddodoooo9oa99p9p9qpq9t9tttttttttttte9eeeeepeeeeeeeeeepeepeppeppeppppepee999a9aaaqqqqauafuauuaaqaauaafaffffqqqqqqfqfqfffqf
ooooddddddddoddo9999999ppqet9ttttttttttteeeeeeeeeeeeeeeeeeeeeeeepeepeepepeppeeee999aaaqaqpquauuufuuuuauuaffafffffffffqfffqffffff
dodddddddddddddd99999pappptetettttttttteeeeteeeeeeeeeeeeeeeeeeeeeeeeeeeeepeeeeee99999aaaqqpuuuufuuuuuufufuffffffffffffffffffffff
ddddddddddddddddd9999apapqptetttttttteteteteteeeeeeeeeeeeaeeeeeeeeeeeeeeeeeeeeee9a99a9aqaqpuuuuufuuuufufufufufufffffffffffffffff
dddddddddddddddd9999aaaqqpqtttttttttttetetetteeeeeeeeeeepeeeeeeeeeeeeeeeeeeeeee9a9aaaapaqpuuuufuuffuuuffuufufufuffffffffffffffff
dddddddddddddddd999aaaaaqqttttttttttettetetteteeeeeeeeepepeeeeeeeeeeeeeeeeeeeeee9aaaaa9qqfuuufufquuuuuuufuffufufffffffffffqffffq
ddddddddddddddddd9a9aaaqppttettttttetpeptteeteeeeeeeeeeepeeeeeeeeeeeepeeeeeeeeeeaaaaaaqqqquuquuuuquuuuufufuufuquffffffffffffffff
dddddoddddddddddd99a999qppttttttttetetptptteeeeeeeeeeeeeepeeeeeeeepepeeeeeeeeeeeeaaaaaaqququuuuuquuuuufffufuufufffffffffffffffff
ddddoddddddddddddaa9a9a9qptttttttppttptetttteeeeeeeeeeeeeeeeeepepeeeepeeeeeeeeee99aaaapppququuuqufuuuuufffufufffffffffffffffffff
ddddddddddddddddaaaa9a9appqqtttttpttttetttteepeeeeeeeeeepeeeeeeeeeeeeeeeeeeeepee99aa9a9pquququuufufuuuuufffuffqfqfffffffffffffff
ddddddddddddddddaaa999appqqqqtttttpttpetetpeeeepeeepeeeeeeeeeeeeeeeeaeeeeeeeeee9ea9aa99ppququuuuuuufuuuqfffqfqfqqqfffffqffffffff
dddddddododdddddda9a99a9ppqqttttttttttpeteeeeepeeeeeepeeepeeeeeepeepeeeeepeeee9e9aa999ppqqpuuuuuuuuuquufqfqfqffqqqffffqqffffffff
ddddddooddoddodd99a9aa9apqqqtttpttttttetpttpepepeeeepepeeeeeeeepepepppeepeeee9e9a9a99ppqpqqquuuuuuuquuuufqfqffffqfqfqqffffqffqfq
dddddddddddood99999a99apqqqqqtttttt9ttpettptpepepeppepeepeeeeeeepepeppppeeeeeeee9a99apapqqpquuuuuuququuuqfqfqffffqfqqffffffqqfqf
ddddddddddoodo99999999pppqqqqt9ttt9ttptppptpepeppppppeppeepeeeeeepepepppeeeeeeee999aaapaqpppquuuuuquuquqqqfqfqfqffqqfffffqqqqqff
oddddddddoododo99999999qqpqqpptpt9999tptppppppppppppppppppeeppeeppuepepppeeeepe9p99aaaapqpppuuuuuquuuuqqqqqfqfqfqfqqqffqqqqqqqfq
ooooodddoooodo9o99999aqpqqqpeppp99999ptpppppepppppppppppppepepppppppeppppppepppp99aaaa9qpqpaauuuufuuuaqquqqqqqqqfqqqqqqqqfqqqqqf
ooooooooooododoo99a9a9aqpqpqpepp9999pppppppppppppppppppppppepppppppppppppppppppppa9aaaq9qpqaaaquqqqaaqauquqqqqqqqqqfqqqqqqqqqqqq
oooooooooooodoo9oa9a9apppqqp9pp9p99p99pppppppppppppppppppppppppppppppuppppppppppa9aaa9aqpqpqaaqqaqaqaaqfuqqqqqqqqqqqqqqqqqqqqqqq
oooooooooooooooo99a99a9pqpq9p9999pp9999pppppppppppppppppppppppppepppppppppppappp9aaaaa9pppqaaaaaqaqaqqqqqqqqqfqqqqqqqqqqqqqqqqqq
ooooooooooooooo9999aa9aapqpp99999ppp99pppppppppppppppppppppppppppuppppppuppapppp99aaa9appqpqaaqqaqaaqaqqqqqqfqqqqqqqqqqqqqqqqqqq
ooodoooooooooo9o9aa9aaaqappp9999p99ppppppppppppppppppppppppppppppppppppppppp9pp99aaa9a9aqpqaqaaafaaaaqaqqqqqqqqqqqqqqqqqqqqqqqfq
ooootoooooooo9o9o9aa99qaqqppp9999999ppppppppppppppppeppppppppppppppppppppppuppp99aaa9aappqaqaaaaaqaaqaqqqqqqqqqqqqqfqqfqqqqqqqqq
ooooooooooooo9oo9a999apqqqppp999p99eppppppeppppppppppppppppppppppppppppupppppppp99aaaaaappqaaaaqfqaqaqqfqbqfqqqqqqqqqqqqqqqqqqqq
dooooooooooooo9o9999a9aaqpq99p99ppepppppeppppppppppppppppppppppppeppppeppppppppp99a9aaapppqaaafqqaqaqqqqfqqfqqqqqqqqqqqqqqqqqqqq
ooooooooodooooo999aaaaaaaq9999999ppepppppppppppppppppeppppppppppepeppppppppppppp9a9apapaqqfqaaafaaaqqqqfqqqqqqqqqfqqqqqqqfqqqqqq
ooooooooooooooo99aaaaaaaaq999p99ppepppppppppppppppepepeppppppppppppppppuppppppppa9a9apaqqqqfqaaaaaqqqqfqqqqqqqqffffqfqqqqqvqqqqq
oooooooooooooooo9aaaapqaqpq99e9ppepppppppppepppppppepepppppppppppppppppppppppupapa99p9pqqqfqaaaqaafqqqqqqqqqqqfqfqqfqqqqqqqqqqqq
oooootooooooooo9a9a9a9pqpqp9e9p9pepepppeeppeppppppppeepppppepppppppppppppppppp9paa99ap9pqpqaaaaaqaqfqqqfqqqqqfqfqqqqqfqqqqqqqqqf
oodddoooooooooooaa9a9a9ppqee9e9peeepeppeepepepepppppeeepppeppppppppeppppppppppp9a9aa9appppqaaaaaaqfqqffqfqqqqqfqfqqffqqbqffqqqff
qoddppoooqoqoo9oaaa9a9aqqpqepeqeeeeppqepeppppppepppepeppqeppppppppappqpppepepeeq9a9aap9ppqpqaaaapppqfqppqfqqqqqpqqfqfffqfffqpqfq
oqppppqoqoqoqpo9aaaa9aqaqqppqqpqpeppqqqpppppqpppepppeppqpqpppppppqpqqpqqppepppqpq9a9a9p9ppqqqfapqpppqppppqqpqfpqqfqpqfpqfpfpqqqp
qppppppqqqpqpppq9aaaa9aaqpqqpqqpppppqqqppppqpqpppqppppppqpppppppqpqqqqqpqppppppqqq9a9p9pppqqqppqpqpqpqpppqqqpppqpqpqppqpqpppqpqq
pqpppqqqqqppppqpq9aap9aqaqppqqpqpqpqpqppppqpqqpqqpqpqpppqppppqqppqpqqqpqpppppppqqq9aappppppqppqpqpqpqpqqpqqqqpqpqppppqpqpqpppqpp
qpppqqqqqqpppppqp9p99pqaqppppqqpqpqqqppqpqpqqpqpqqpqpqpqpqppqqqqqpqpqpqpqpqpqpp9q9aaaappppppqqqqpqpqqqqpqpqqpqpqpqppqpqpqpqppppp
pppqpqqqqqqqp9pqp99a99pqppppqqqqpqqqqpqpqpqppqpqppqpqpqpqppqpqqqpqpppppqpqpqpq9999aaa9apqppqpqqqppqqqqpqpqppqpqpqpqpqqpppqpqppqq
ppqpqppqqqqqqpqpq9a9ap9pqppppqqpqppqpppqppppppqpqqpqpqppppqqqpppqppqppqpqpqpqp99999aaa9apqppqpqpqqqqqpppqpqppqpqpqpqpqppppqpqqqq
pppqppqpqpqqpppqpa9a99aqqqpppqpqqpppppppppppqqpqqqqpppqppqqqqpppppqpqppqqpppppp9q99aaaapqpqqpqpqqqqqppppqqqpppqpppqpqqqppppqpqqq
pppppppqqqppeeeea9a99a9qqqpfppqqqqpfpfpfpfpqpqqqqqffpqpqppqqppppfppqppqqqqpppfpq9qaaaapqpqqqq8qqqqrppppqqq8qp8pppp8qqqqp8pppq8pr
eeeeeeeqqqpeeeeeea99a9apqpfpfffqqqfffffffpfpqpfqqfffffqpfpppffpfpfpfpqfqqpqpfff9qa9aa9apqqqq8q88q8pr8pppq8q88p8ppp888qp8p8rp8888
peepeeeeqpeeeeee9e9a9apqppqffffqffffffffffqfpfqfqffffffffqqffffpfqffffqffqpffffff9a9aapappq888888888888r88888888p888r8r888888888
eepeeeepepeeeeeee99aaa9pqqfqffqfqfffqffffffqfqfffqfffffffffqfffqffqfffffffffffff9f9a9pappp888r88888r88r888888888888r888888888888
epepeeeepeeeeee9e9aaa9aqqqqqfffffffqfqffffffqffffqqfffqfffqffffffffqffqffffffffff99999pppp8888888888888r8888rr888rr8888888888r88
eepepeeeeeee9eee99aaaaaqqqqqqfffffffqqfffffffffffffffqqffffqqffffffqqqfqfffqffff999999prppp8888888888888r88r8888rrrrr88rrr8888r8
peeepeeepeeeeeee99aaaaaaqpqqfqfffffqffqfqffffffffffffqfqfffffffffffqqfqqfqffqff999a99ppapprr88888888888r8r888888rrrr8rrrr88888r8
eeepeeeeppeeeeee9a9a9aaqpqpqfqqqffqqqqfqffqfqfqqfqffqfqfffffffffqffqfqffqfqffqf99a9a9papapr8r88888r8r888r888888rrrr888rr8r88888r
eeeeeeeepepeepe9e9a9a99qppqfqfqfqfqqqfqqqffqfqqqqfqqfqfffffqfffqffqfqffqfqffffqf9aa9a9papqqr8r888r8r88888r888rrrrr88888rr8r88r88
eepepeepepeepppe999aa9pppqpqfqqqqqqqqqqqfqffqqqqfqqqqfqfffqqqfqqqqfqqqqfqqfffqf9a9aa9a9pqqqqrrr8r88rr88rr8888r8rr8r888rrrr8rr8r8
peppeppepeepeppp9a9a9aaappqqqqqqqqqqqqqqqfqqqqqqqqqqqqqqqqqqqqqqqqqqfqqqqqffff9f9a9aa99qpqqrrr8r88r88r8rrr88r8r8rr8rrrrrrrrrrrrr
eppppppppppeppppaaa9aaaaqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqfqfqqqqqffqfqf9a9a9p9qqqrrrr8rr8rr8rrr8rrrr8rrrrrrrrrrrrrrrrr
ppppppppppppppppaaa999aqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqfqqqqqqqqfqfq99a999qqqqrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
ppppppppppppppppaaa99apqqqpqqqqqqqqqqfqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq9q9qaqaaaaapqqqrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
pppppppppppppppp9a99apqpqpqqqqqqqfqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqaaaaaaapqrqrrrrrrrrrrrrrrrr8rrrrrrrrrrrrrrrrrrr
ppppppppppepppppp9999a9qpqqqqqqqqqfqqqqqqqqqqqqqqfqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqaaaaaapppqrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
pppppppppppppppp9a9aa9a9pqfqqqqqfqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqaa9pa9ppqrqrrrrrrrrrrr8rrrrrrrrrrr8rrrrrrrrrrrr
ppppppppppppp9paapapaaapqfqqqqqqqqqqqqqqqqqqqqqqqqqqqqqfqqqqqqqqqqqqqqqqqqvqqqqqa9apa9a9prqrrrrrrrrrrrrrrrrrrrrrrrrrrrr8rrrr8rrr
ppppppppppppppapaa9a9a9qpqqqqqqqqqqqqqqqqqqqqfqqqqqfqqqqfqqqqqqqqqfqqqqqqqqfqqqqqaaapa9ppqqqrrrrrrrr8rrrrrrrrrrrrrrr8r8rrrrrrrrr
epppppeppppppppaa9999aa9qfpqqqqfqqqqqqqqfqqfqqqqqqqqqqqfqqqqqqqqqqqqqqqqqqfqqqqqqaaaa99pqqqqrrrrrrrrrrrrrrrrrrr8rrrrr8rrrrrrrrr8
pppppepppppppp9p9a99apapqpfqqqffqqqfqqqqqfqqfqqqfqqqqqqqqqqfqqqqqqfqqqqqqqqfqqqqaaaa99p9pqq8rrrr8rrrrrrrrrrrrrrrr8rrrrr8rrrrrrrr
pppppppppepppap9a9a99apqpqqqfqfqqqfqqfqqfqqqqqqqfqqqqqqqfqffffqqffqqqqfqqqqqqqqa9aa9999appprrrr8rrrrrrrrrrrrrrrr8rrrrrrrrrrr8rrr
ppppppppppppapaaaa99apapqpffqfqqqqqfqqfqqqqqqqqqqfqqqqqffffqfqqqqqqqqqqfqqqqqqq9aaa99papapprrr8r8rr8r8rrrrrrrr8rrrrrrrrrrrrrr8rr
ppppepepppppppaaaa9apappqppfqqqfqqfqfqqqqqqqqqqfqqqqqqffffqfqfqqqqqqqqfqfqqqvqb9aaa9a99appp8r8r8r8rrrrrrrrrrrrr8rrrr888rrrrrrr8r
pppppppppppppapaaaa9aapqqqpqqqfqffqfqffqqffqfqfqqfqqqffqqfqqqqfqffqfqfqqqqfqqb9b9a9a9apqpp888r8r8rrrrrrr8r88rr888rrr88r8rr8rr8r8
pppppppeppppppa9a99aa9aqqqppqfffffffffffffffffqfqqfqffqqqqfqfqqfqffffqqfqqqqbbb99999apqpqp88r8r8rrrrr8r8r888888888rr8r8rr8r88888
pepppppeeuppu99999a99aapqqpfffffffffffffffffffffffqffffqqfqfqffffffqqqqqqfqvqbb999a999pqp8p88r8r88r8888r8888888888r8r8r88r888888
eeeeepeueeeu9999aa9aaapaqqqfffffffffffffffffffffffffffffffffffffffqfqfqffqfqvbv99a9a999qpqq888888888888888888888888r888888888888
eeeeeeeeeeeeuu9aaaaa9aapqqqffffqfffffffffffffffffffffffffffffffffffqffffvfvvbv9vaaa999q9qqqq888888888888888888888888888888888888
eeeeeeeeeeeue9u9aa9aa9pqpqpffffffffffffffffffffffffffffffffffffffqfffffffffvvvv9aaa9999qpqq8888888888888888888888888888888888888
eeeeeeeeeuueuu9uaaaa9pqpqfqffffffffffffffffffqffffffffffffffffffffbffffffffvvvvv9a999pppqpq8888888888888888888888888888888888888
eeeeeeeuuuuuuuu9aaa9aapqppfffffqffffffffffffqfffffffffffffffffffffffffffffvvvvvvv99999pqpqqq888888888888888888888888888888888888
eeeeeeeaeuuuuuu99a9a99apppffffffffffffffffffffffffffffffffffqfffffffffffffvvvvvv999a99qpqqqq88888888888888888888888888888888888r
eeeeeeeeueuuuuu9aaa99p9ppfpfffffffffffqffffffffffffffffqfffffffqffqffffffvvvvvv9aaa9aapqpqqq8888888888888r888r888888888888888888
eeeeeeeueuuuuuu9aaa9p9p9qqffffffffffqfffffffffffffffffffqffffffffqffffffvvvvbvvvaaaaa9aqprq888888888888888r8r88r888888888888888r
eeeeeeueueuuuu999a99ap9qqqqffffffffqfqfffffqffffffqffffffqfffffffffffffvvvvvvvvvaaa99aqpqp88888888888888888r88888888888888r88888
eepeeeeueuuuuu99999a9appqqqqfqffffffqfffffffffffqfqffffffqqfqfffqqffffbfvvvvvbv99a9999pqprp88888r88888888888888888888rr8888r888r
epeeeeaeuuuuuuu99999apaqpqqqqqqffffqfqfffffqfffffqffffffqffqffffqffffqfbvvvvvvbva9a9999ppp8pr888888888888888r8r888888rr888rrr8rr
epeeeaeuuuuuuuua99999ap9qppqfqfqffqfqfqffffqfffffqqfffqqffqfqffqfqffqfvvvvvvbvv99a99999ppppr8r88r888888888r88r8r8r888r8888rrrrrr
pepeaaauuuuuuuauua99ap9pppqfqfffqffqfqffffqffffffffffffqqqfqffqfqqqqbvbvvvvbvvv9999999p9ppp888r8r8888888888rr8rrr88888888r8rrrrr
eppaeaaauuuauauuuuaapapqppqqffffffqfqffqfqfqffffffqffqqqqqqqfffqqqqqvbvbvbbvvvv9a9999p9ppq8888888r88r88888r8rr88rr888r88r8rrrrrr
ppaeauauauauauauua9aap9ppppqfffqfqfqqqqfqfqqqfffqqfqqqqqqqqffffffqqqfvbbbvbbvvva9a99a9ppqpq8888r88rr8r888r8r88888888rrrr8r8r8rrr
papauauauauauauua9aaaapppppqqfqqqfqqqqfqfqqqqqfqqqqqqqqqqqqfqqffqfqfbfbbvbvbvvv9a99a9aarpqp8rrr8rrrrr8r8rrr8rr888888rrrrr8r8r8rr
ppaaauaaaaaaaauauaaaaaappppqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqfqqbfbbbbvbbbvb99999aaaapqpprrrrrrrrrr8r8rrrrrrrr88rrrrrrr8r8rrr
ppaaaaaaaaaaaaau9a9aaa9appqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqbbbbbbbbbbbbbb999aa9aaqqpqrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
ppaaaaaaaaaaaaaaa9a9aaappqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqbbbbbbbbbbbbb9aaaaaqaqq8rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
pppaaaaaaaaaaaaa9999aaaqpqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqbbbbbbbbbbbbb99aaa99aqqqrqrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
ppaaaaaaaaaaaaaa99999aqpqpqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqvqqqbqbbbbbbbbbbbbb9aaap99qqqqrqrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
aaaaaaaaaaaaaaa9a99999pqpqpqqqqqqqqqqqqqqqqqqqqqqfqqqqqqqqqqqqbqbbbbbbbbbbbbbbbba9a9a999qprqrrrrrrrrr8rrrrr8rrrr8rr8rrrrrrrrrorc
uaaaaaaaaaaaaaaa9a9a99appppqqqqqqqqqqqqqqqqfqqqqqqfqqqqqqqqqqqqbbbbbbbbbbbbbbbbbba9a9a9qppprrrrrrrrrrrrrrrrrrrrrrrrrrrr8rrrrrrro
aaaaaaaauaaaaaaaa9a9aapappfqqqqqqqqfqqfqqqqqqqqqqqqqqqqqqqqqqqqqbbvbbbbbbbbbbbbba9a9a9qpqqprrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr8r
paaaaaaaauaaaaaa99aa99apppqqqqqqfqfffqqfqqfqqqqqqqqqqqqqqqqqqqqqbvbbbbbbvbbbbb9b9aaa999qqpqpr8r88rrrrrrrrrrrrrrrrrrrrrrrrrrrrrro
apaaaaaauauaaaaa9aaa9appqqfqqqqqqqqfqfqqqqqqqqqqfqqffqqqqqqqqqqvvbbbbbvbbbbbbbbbaaaa99p9pqqqrrrr8r8rrrrrrrrrrrrrr8rrr8rrrr8rrrrc
paaaaaaaauaaaaaaaaaaapaqqqqfqqqfqqqqfqqfqqfqqqqfqqfffqqqqfqqqbvbbbbbbbbbbbbbbbbbbaa99papqqqqrrrr88rrrrrr8r8rrrrr8r8r8rrrrrr8rrco
uaaaaaaaaaaaaaaa9aaa9apqqqfqfqfqqqqfqqqqqfqfqffqqfqfqqqqffqqqbbbbbbbbbbbbbbbbbbbb9a9aapapqqrrrr8888rrrr8rrrrrrr8r8r8r8rrr88r8coc
uuauaaaaaauaaua9a9a9apqqqqfqqqqqfqfqffqffqfqfffffqfqfqqqfffqbbbbbbbbbbvbbbbbb99b9a9a9aapqpqrrrrr8888r88rrrrrrr8r8rrr888r88rrrrco
pauapaqquqaauau99aaaappqqfqpqqqqqqqffqfffpffppfqffpqqfqfqfqpqbbvpbvpqpbvbbbbvp99aaa9aap9qqrrrrrpq88p8pp8rrrrrprpqrqr8qrprorrqoro
pqqpqqqqqqqpaup99aaa9apapppqpqqqqqqqqfqfpfpqppqpqpqpqffqpqqqppqppppqpqppppbpqqp9aaaaa9aqpqqqrpqqpqpqpqppprrqq8pqpqrqqpqrppqqqqqo
qqqqpqqqqqqpqpq999a9a9apappppppppqqppqppqpqpqppqqppqpppppqqqpqpqqpppqppppppqqqq99a9a9aqpqpqqqqppqpqpqpqpqpqqqqqpqqqppqppqppqqqpq
qqqpqqqqpqpqpqpq9a9a99pappppppppppppqppqpqpqqqpqpqppqqppqpqpppqqpqpppppppppqqqp9q999appqpppqqpqppqpqqqqqpqqqqqqqqqqppppqpqppqpqp
qqpppqqppppqqpq9a9a9999apppppppppppqpqqpqppqqqqqqppqqqqppqpppqqpqpqpppppppppqpqq9qa999qpqppppqqqqpqqpqqqpppqqqqqqqqqqpppqpppppqq
qqqpqppqppqpqpp99a9999apapppppppqppqqqpqqpppqqqqqqqpqqppqpppqqqqqqpqppppppppqqppqaaa999qpqpppqqqpqppqpqppppppqqqqqqqqqpqpqppqqpq
qqpqpqqqqqpqpqppa9a999pappppqppqpqqpqqqqpqpppqqqqppqpppqpqqpqqqqqqqpqpqppppqpqp9aaaa99paqpqpppqpqpqppppppppppqqqqqpqqpqpqppqpqqp
ppqpqpqqqpqpqppq9aa9999ppppqpqqpqqqqqqqqqpppqqqqqqpppqpqqqpqpqpqqqpqpqpqppqpqpqp9aa999apaqppqppqpqpppppppqppppqqqqpppqpqppppqpqp
vppqppvqvvvqqqv9qa9a9aaappppq8pq8qqpqqqqpp88pqqqqq8pqpqpqpooqprpqpppqpqppppqqqpqa99999papppq9qqpqp9ppp9pqpqppppqqpqpppqqpppppqpp
pvvppvqvqvvqvv9v9aa9aaaaaprr8p88q8pq888p88888ppqq8p88q8qooooorpoppoooopppooqooqa9a9aap9ppppqq9pq99p9p999pqp9psq9qqp99pqpqpppppss
vvvvvvvqvvvvqvvva9999aaaprrrr888888r88r8r8888888r88888ooroooo8ooooooooooooooooo9a9aaaa9pppqpqp99999999999999999q999999pqppppppps
qvvvvvvvvvvbvvv9v9999aapqpqr8888888888888r8888r88r888ooooooooooooooooooooooooooo9o9aa9a9q99q9s999999999999999999999999pppppppppp
qvvvvvvvvvvvbvvv99a9apaqpqpq8888888r888888888r8r888888ooo8ooooooooooooooooooooooo9999aaqpq9999s99s999s999999999999s99p9ppp9ppppp
bqvvvvvvvvvqvbv9va9aaap9qpq888888888r8888r8888888888oorrrorooooooocooooooooooooo99999aaaqpq9999s99999999999999999s9s99p9pspppppd
qvbvvvvvvvbvvvbv9vaa9a9ppqrq888888r8888888r88888888oooorroooooooooccooooooocoooo9a9999apaqs99999999999s99s999999999p9s9pspppppdp
bbvvvvvvvbvvbvv9v999ap9qqpqr88888r8r8888888r888r88orooroooooooooocccccoccoooooooa9ap9ppapsss99999999s99999s9s99999p9p9p9pdpppdpp
qbvbvbvvbvbvv9b9999999qqqqrrr888r8rrr8r88rr8rrrrrrroorocoooooooooccccocoocooooo9oa99p9pppssss99ss9ss9s9999ss9999s99p9p9pdpdsdppp
