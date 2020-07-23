pico-8 cartridge // http://www.pico-8.com
version 21
__lua__
--another bad dream
--by ???
t=0
ti=0
dt=1/30

cls()
::⌂::
ti+=1
t+=dt

for i=1,500 do
	x,y=rnd(128),rnd(128)
	p=pget(x-2*sgn(x-64),y)
	if p>0 and p~=7 then
		circ(x,y,1,p)
	elseif p==7 then
		circ(x,y,1,t%2+1)
	end
end

k=1/6
s={}
c={}
for i=0,6 do
	for a=0,1,k do
		a1=a+t/12
		a2=a1+k+t/8+i/8
		s[a1]=sin(a1)
		c[a1]=cos(a1)
		s[a2]=sin(a2)
		c[a2]=cos(a2)
	end
end
s[t/4]=sin(t/4)

for i=0,6 do
	cx=64
	cy=128/6*i
	cy=(cy-64)*(cos(t/16)/4+1/4+1)+64
	di=-abs(12*(i-3))+36-18
	ps={}
	for a=0,1,k do
		a1=a+t/12
		a2=a1+k+t/8+i/8
		sa1,ca1=s[a1],c[a1]
		sa2,ca2=s[a2],c[a2]
		if i%2==0 then
			d=32+di+c[a1]*16+s[t/4]*4
		else
			d=32+di+s[a1]*16+s[t/4]*4
		end
		
		add(ps,{
			cx+d*ca1,
			cy+d*sa1*(3/12+cos(t/16)/12),
			cx+d*ca2,
			cy+d*sa2*(1/6+cos(t/16)/12),
		})
		
	end
	for p in all(ps) do
		line(p[1],p[2]+1,p[3],p[4]+1,8)
	end
	for p in all(ps) do
		line(p[1],p[2],p[3],p[4],7)
		line(p[1],p[2]-1,p[3],p[4]-1,7)
	end
end

flip()goto ⌂
