pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	greens={
		7,
		7+128,
		10,
		10+128,
		11,
		11+128,
		3,
		3+128,
		1,
		1+128,
	}
	
	for i=1,#greens do
		pal(i-1,greens[#greens-i],1)
	end

	t=0
	dt=1/30
	ct=0
	
	for i=1,100 do
		x,y=xy()
		sset(x,y,0)
	end
	
	cls()
end

function _update()
	t+=dt
	ct+=1
	
	sspr(0,0,128,128,0,0)
	
	line(64,64,64+90*cos(t/20),64+90*sin(t/20),1)
	
	for i=1,200 do
		x,y=xy()
		sx(x,y,mid(0,sget(x,y)-3,10))
	end
	
	for i=1,300 do
		x,y=xy()
		x=x-x%6
		s=sget(x,y)
		if s~=0 then
			sset(x,y,mid(0,s-3,10))
			x4=x+6*cos(t/20)
			y4=y+6*sin(t/20)
			--x4=x+6*cos(atan2(x-64,y-64))
			--y4=y+6*sin(atan2(x-64,y-64))
			x4=x4-x4%6+(tl(t/16) and 0 or 6)
			sset(x4,y,2+sget(x4,y))
			sset(x4,y4,1+sget(x4,y4))
		end
	end
	
	for i=1,5 do
		x,y=xy()
		sset(x,y,1)
	end
	
	for i=1,5 do
		x,y=xy()
		sset(x-x%6,y,0)
	end
	
	for i=1,400 do
		x,y=xy()
		c=boxblur(x,y,3)
		circ(x,y,1,c)
	end
end
-->8
function sx(x,y,c)
	--sset(x  ,y  ,c)
	sset(x+1,y  ,c)
	sset(x-1,y  ,c)
	sset(x  ,y-1,c)
	sset(x  ,y+1,c)
end

function xy()
	return rnd(128),rnd(128)
end

function boxblur(x,y,w)
	local sum=0
	for ox=x-w/2,x+w/2 do
		for oy=y-w/2,y+w/2 do
			sum+=sget(ox,oy)
		end
	end
	return sum/w
end

function tl(t)
	return (3/8<t%1 and t%1<5/8)
end
__label__
111111311111111111j1jj13j11j3rarj131j11111j13j11b1111j3j11j1j1131j33j111111111111111111j11j1111111111111111111111111111111111111
11111111111111111r1j1j33r1111rjrr31111111r3rj331311j11j1j1jj31113jrj1j11111111111111111111111111111111111111111111111j1111111111
111111111111311111j1jj33b11111jr1131j11111q3331jrj111j3j11j1j111jjj1j1111111j1111j11j1111111111111111111111111111111131111111111
j111111111j111111r311113313111j1111j11111j3j11j13jjj1j31311jr1111jj1j111jj1111j1j11jjj1111111111111111111111111111111111111j1111
111111111j1j31j111j111j1331311j11111j111j1j1111jrj1111rj1311111131jj1j11j11111j11111j11j11111111j1111111111111111111111111111131
3111111111j3311111r11113333111311j1j11jj1j3j11j1jjj11jjjj111j11313bjj1111jj11jr11111jj11j11111111j11111111j11j111111111111111111
j1j111111111311111jj11j33j13111111j1jj1jj3j1j11j1j1111rjj111b1r131j31113jjjj11r1111111j111j11111j1111111111111111111111111111111
j111113jj11ra11111jj111jjjj111111j3jrjj131j11111jj1111jj1113311113311111jjj11jj11111j11j11311111111111111111j1111111111111111111
1j1111jj1j1131111131j1j11jj11jj111j1j1j1jj1jj11jrjj1113jj111r111j1rj11111jj11j31111jrj11j13311111j1111111j1111111111111111111111
j1111j31j1113111j1j11j11j11jjjjj111j3jj1j1r1jr1r3j3111jjj111j1111jqjj1113111jrar11jjj1j11j313111j1111j11111111111111111111111111
j1j11jbj1j1131j11j3j11jjjjjj1jj111j1jjjj1j1j11rjr3331rbjj111111111jj111j11111jrj111jjj11311j111jj1111111111111111111111111111111
jj1jj131j11jjj111jj1j11133j1jjr31j1j11j1j1j1111ra33111r3r1j1r11111r3j11131111jjj111j3j11131j111j31111111111111111111111111111111
jjjj1j1111j11111j1111111j11jj3j1jj1111111jrj111bjr1111jr111jj11111311113111111q111j1jj1111j111jjjj111111111111111111111j1111j111
q1jj1131j111j1111j11111111113jr13111j1j1jjjjj1bjbjj111b1111jjj111113113131311jr1111j13111j1j11jj31111111111111111111111111111111
3jj1j1rj111j1111jjj111111111131111j1jj111j3jj13bjj111jbj111jrj111131j113b313j11111111131j1j11jjj3j11j111111111111111111111j11111
jjj111j1j1j1j1jj1j311111311111j1111j31111j1111133jj1jjjrj111jjjj1111111j3j311j31111111111jjj11jjjj111j31111111111111111111111111
3jj1111j11jjjj11jj3111111111113111j13j11111111j1jjjjjjbjr11r3jj1j1j11113j111jj111j113r3113331j1jjj11j3331111j1111111111111111111
3jjj113111113j11j1j11111j11111111j1jj1j111111j1j1jj11jr3j1r1jj11133rj13111111j31111111j111311111j111jjr3j11111111111111111111111
jjj1111j1111jjjj1j1j1j111111113111j1jj1jj11111j1jj11j13j3j1rjj11313j111111111j3j11113111r13113jj3j11jjjj311j11111111111111111111
jjjj11jj11113j1111j1j1j111111111111j1jj1113j11jjj1j1jj3311r1r1j113j1j11131111jj1111111111rrj111jj1111jj31111j111j11j111111111111
jjjjjjjjj111j3j111jj11113111111111jjjj3j1131j11jrj1j1j3j311rb111133j11111111j1r11111j11111311111j1111j3j111111111111111111111111
3jjjjjr3jj111j3111rj1111111111j111jjr3jj1j1j11111111j1r3111b3b1111j1111j11111111111j111111111113qb1bj1j11111111111j111111j111111
3j11jjbjr11111j11111j1111j1111111jjj3jjjj1j11111j11111jj11bj3111113111113j111111111jj11111111j1jr1b11j3j111111111111111111111111
j1111j3j1j111j13113j1311j111113111jj31j111111111j1111jjj111bq11113r1111rj111113111jjj11111jj11j11j111jjj111111111111111111111111
3311jjjjj1j1r3113jj131j1j111111111j1b1j1j13111113111jjjj1111q31113j313j1j1111jj1111jj1111jjj1111jjjj1j3j111111111111j111j1111111
jjjjjjrj1j133r3jj1j11j1j3j1j111111j1jjjj1jj1111333131j3j1113jr1111j131j11j111j11111111111jjj111jrjj1j1j1j1111111j11j111111111111
jjjjjj31313333jj1jj111j1r3j1j1j111j13j11jjbj11j131311331113j3j111j311111311111j1111jr111jjjj1111j1111jjj111111111111111111111111
jjjjjjrj1113jjjj11j11j1j3j3j1j3111j1q3j11jjj1111r311j1b31113q1j1j11j11111j1111j111j1j3r11jj3j111j1111111111111111111111111111111
jj1j1jjj1113jj11j111jjj13r11jjj111jj3j31jj3jj111jj31113j1j313j111jj1j1j13j111111111j1r113j31111j1jj11111111111111111111111111111
11jjjjjjj1jj3jj11jjjjjjjr111jj3j11j1jjj113j3111ra3111133j1133jj1jjrj111jjrj1111111j13111j33111111jjj111111111111111131111j111111
j111jjjjjjrj3j1j1jjjjj1j311111j1j1113jj11b3311r1rj1113j331j3bj1j1jj1111jqjr11131111j11111j11111131j111111111111111311111j1111111
311111j1j11r3jj1j1jjj1j1j1111j1jj1111j11brq1111rj11113q3j11j3jj1j111111r3j113j1j11j1111111311111111111111111111111111111111111j1
j1111111j1j1qjj11jjjjj11311111jj1111j13jrbr1111j3j11j13j1j1jj11jjj11b1j131111j111111111111131111111j1111111111111111111111111111
1j1111111j1jjj1j1jrjjj1jjj1111311113jjj3jrrj11j131111j33j11311111j3b1j1j3j1111j113111j111r11111111j11111111111111111111111111111
j11111j1111jjj11jj3jjjj1j1j111jj113jj11j3j33j1jj31111jr1111j1111j171r1j1b11111133111111111b1111111111111111111111111111111131111
j11111311111jjjjjjj1j1jjjjjj1jr111133r11313j31jjjj11jj3jj1j1j1111r1r1111j3111111j1111111111111111111111111111111j111111111111111
11111111111131jjjj3j1jjjrjjj1j311111r1rj11j3111jjjj111jr1111111111j11111rjj131j111111111111111111111111j111111111111111111111111
111111r11111jj11jjjjjjjjjjj11131111j3rj11jr11111r111111111111111131j11j1jjjj131311111111111111111111111111j111111111111111111111
311111j1111131j111jjjjjj1jj111j111j1jj1j131311111111113rj111111131a1j11jbjj1111131313111111j111111111111111111111111111111111111
r11111j11111jj111111jjjjj1j1111111jjbjj111311111111111311111111113rj1j11r131j1111111331111j111111111111111111111111111111j111111
1j11113j111jj11111111jjjjjjj11j11jjj3jj1j1111111j111111j111131111111j1111j11111111131311111111111111113111j111111111111111111111
j1j11j31j111j1111j11111jjjjj1j1111jjjj1j11j1111j1j1111j1111111111j11111111111111113113111111111111111111111111111111111111111111
3111jjjj1111j111jjj111111jjjjjj111jjjj11111jj111jj111j31311111111111111111111111111111111111111111111131111111111111111111111111
j111jj3j111jj111jjr11111j11jjjjj1jjj311111jjj111nj1113j313111111j1j11j1111111111111111111111111111111111111111111111111111111111
11111jjjj1jjj1111jjj111111111j3jjjjjr11j11j1j11jj11111rj3111j11111111111111131111111111111j1111111111111111j11111111111111111111
j1j111jj1j1jr1311j31j11jj11113jjjjjjjjjj1111111j1j111jjj11111j111111111111111j1j1j1111111j1jj11111111111111111111111111111111111
jj111131j113331311jj11j1jj31113jjjjj1jj1113jj11j3111jjjj11311111j1111111j11111j1j1111111131j111111111111111111111111111111111111
jj1111jj1j1jj131111jjj1j33j3113111jjj11j11j3j11j3j111j3j1311j11j111j111j31j11jjjj111111111r111113111111111111111111111111111j111
jj1113b3j1j1j11111jjj11131311113111jjjj1jjr331j1j1j1j1j1j1311111111111j1j1111jrj311111111111111111111111111111111111111111111111
jj11113j111j33111jj111j1r111113111113jjjjjj3131j3j1jjj1j1j111111111j1j1j311111131j1311111111111111111111111111111111111111111111
jj1111311113r331jj1j11jj3j111jj11111b33jjjj3j131j111j1111111j1j111j1j1111111111111j111111111111111111111111111111111111111111111
j1j11131113rj311jjj11j1jjr1111111111j3j31jjj111j3111j1j11111rj1j11jj131j111111j111111111113111111111111j111111111111111111111111
3j11113j111331311jj111j3r1r1113j111j3131111jj11j111111j111j1jjj111jj1jj1j1111111111111111111111111111111111111111111111131111111
3j11133jj11133111j3j111r3r111j311113r1111131jjj1311jj1j1111jrjj111j1j11j111j1111111j11111111111111111111111111111111111111111111
jj11j3j31111311113j1j1jr0rj1j1r111313131111111jjj1jj1jr11111jj111j1j1jj131j1111j1111111111111j1111111111111111111111111111111111
1j1jjjr11111j111113j1j1rj3311bjb1113131311111111jjj1j111111131111131j11jjj111131jj1111111111111111111111111111111111j11111111r11
j1j1jjjjj111111113j1j113b3131r31111133311j11111bjbj11jj1j11j1j1111j111113jjj111111111111111111111111111111111111111j111111111111
1j131331j11jj1111j3j1131j111r1r31111j3j131j1111bar1j1j3j3j11r111111111111jj11jj1111111111111111111111111111111111111111111111111
331133j311j111111j3j1111311j1rjj3111j131131j11113r111jjjj31jr11111j11111j1j11111111j11111111111111111111111111111111111111111111
q3311j3j131jj11111j1j111b111j1r3111113j1j1b1j111a1111j3jjjj1rj11111111111j111111111111111j111111111111j11111j1111111111111111111
3j1j133j31333111113j111bnb111jj11111qjrj1jjj1j11br1113j13jjj3jj11111111111111131j11jjj111111111j1111jj11111111111111111111111111
j1j13133j111j11111jjjjj3b31j113j131jqr11jjj111j11111133311jjrj1111j111j1j1111j1j111jjjj111j111111111j1j11111j1111111111111111111
jj11133j1j13r111113jjjrj313111j1jjbqbr31jjj11111j11113r11jjjjj1111r13j1j111j11j11111jj1111j11111111j1j11111j11111111111111111111
jj1111r3j111j1111jjj1rjrq31111j1113br3r31j3j111j311131jj11jjj1jj11j311j113111j111111311111j111111111j1j11111j111111j111111111111
3111113111113j1111j1j1rjr111111j13r3rr3111j1j1j1rj111j3jjj1jr111j1311131j1j1jj3111j131111j3j1111j11111111111311111jj111111111111
311111111111r1111j1j1jjrr11111r1jr3rj13111jj33jjjj11113j11j131111111111j1j1j111j1j1jj11111j111111111111111111111111j111111111111
111111j11111j3111131j113j3j1111j11r333131j33j11jj1j11jj1111333111131111111111111j1j11111j1111111111111111111111111j1111111111111
11111111111j311111r1111jjj1j11111131bj31j13j111jrj111111113rar111111111111111111111111111131111131111131111131111111111111111111
j11111j11111r111113j1113rjj1j1j11113j1j11331111j31j1113111jj3j1111j1111111111111111131111jj11111j1111111111111111111111111111111
1111111111j13j1111r311333311111111111j1111j1111j1j1113111jjjjj1111111111r111111111j111j11111111111111111111111111111111j11111111
311111111j1jj1113r3r11133111113j11j131j11j11b11jj1j1313111jjjjj111111111111111311j11j111111111111111111111111111111111j1j1111111
b111113111jjr113j3rjr11j3111j1j1111j1j11j1jb31j1rj1113j111113j1111j11111j111j11j11131111113111j1j1111111111111111111111j1j111111
1j1111j11111111j313rj11jj1111jrj11jjj1111j1rb111111111j3111j3j11113jj11j111111j1j131111111111111111111111111111111111111j1111111
j1j11j11111111111j1j111jbj11jjjjj11j1j11313j1111131111jj3111jj113jjj1j11j111111j111111111111111j11111111111111111111111j11111111
3j11113111113j1111311111j1113jjjj111j1j1131j111111111jrjj131j1j1j3jjj111111111j111j11311j111111111111111111111111111111111111111
3j1111111111j1j1113111111111j1arj1111j1111jj11111311113jj113r1113jjj11111111jj11111j11111j1111j1111111j1111111111111111111111111
j1j1111111111j111111111111111jr1rj1jj1111jq1j1113j3111jj111j31111j3jj111111111j1111111111111111111j111j1j11111111111111111111111
1j11111111111111111111113111113r11jj1j11j3jjj1j1jj1111b1111j3111j1j11j111111111111111111111111111j11111j1j11111111111j1111111111
311111311111rj1j11111111j11111r11j1jj1j11j3jjj1jrj1111j111111j111jj111j1j1111131111111111111111131111131j111j11111j1111111111j11
311111111111j1j111111111111111111113jj111jjj11j1j31111111111311111111113j111111111111111111111111111111111111j111111111111111111
j11111j11111111111111111111111111111r1311131111jr31111j1111111111j11111j3jj1111111111111111111111111j1111111j1j11111111111111111
1111111111111111111111111j111jj11111311111311111311111j11111111111j1111131j11111111111111111111111111111111j3j111111111111111111
111j11111111111111311111j111j131111131j111j11111q1111j111111j111113111113j1111111111r11111111111111111111111j1111111111111111111
311111311111311111311111rj11jjjj1111j11111111111111111j111111111111111111111111111111j11111111111111111111111111j111111111111111
111111111111111111111111j1111131j11111111j11111111111j1jj111111111111111111111111111111111111111j1111111111111111111111111111111
111111111111111111111111111111111111111111311111r1111131111111111131111111111111111131111131111111111111111j111111111111311111j1
1111111111111111111111111j1111111111311111311111r111111j111111111111111111111111111j1j111111111131111111111111111111111111111111
1111111111111111111111113jj111j1111jj111j11j1111j1111111111111111111111111111111111j11111111111131311111111111111111111111111111
1111111111111111111j1111j11j111111j1j11111j1j1111j111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111j111111111j11111j1j111131j11111111131111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111311111111111j11113r3111j11111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111311111j1111r3r111111111111111j111111111111j1111111111111111111111111111111111111111111111111
111111111111111111111111111111111111311111111111r111111111111111j1311111j1111111111111111111111111111111111111111111111111111111
111111111111111111111111j11111j11111111111r11111r1111111111111111j11j11111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111113111j11j111111111111111111111111111111111111111111111111111111111111
1j1111111111111111111111111111111111311111111111111111111111j11111111111311111111111111111111111111111j1111111111111111111111111
j1j111111111111111111111r11111r1111111111131111131111111111jjj1111111111111111j1111111111111111111111111111111111111111111111111
1111111j111111111111111111111111111111111111111111111111111111111111111111111j1j11111111111111111111111111111111111111111111j111
11j1111111111111111111111111111111111111111111113j1111111111111111111111111111r11111j11111111111111111311111j1111111111111111111
1111111111111111111111113111111111111111111j111j31111111j111111111111111311111j11111111111j1111111111111111111111111111111111111
1111111111111111111111111111111111111111111jj1111111111111111j11111111111111111111111111111j111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111131111131111jr1j11111111111111111111111111111111111
1111111j11111111111111111111111111111111111111111111111111j1111111111111111111j111111111j1jj1111111111311111111111j1111111j11111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111j11j1111111111111111111111111111111111j
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111j111111111111111111111131111131111111111131111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111j11111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111j11
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111j111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111j11111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111j111111111111111111111111111111111111111111111111111j11111111111111111111111111111111111111
111111111111111j1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111j1111111111111111111111111111111111111111111111111111111111111111111111111111111j11111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111j1111111111111
1111111111111111j11111111111111j111111111111111111111111111111111111j11111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111j111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111j1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111j1111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111111111111111j111111111111111111111111111111111111111111111111111
11111111111111111j1111111111111111111111111111111111111111111111111111111111111111111111j111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111j11111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111j111111111111111111111111111111

