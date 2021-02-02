function _init()
	cls()
	poke(0x5f2d, 1)

	t = rnd(1000)
	maxs = 0
	mins = 2
	ssum = 0
	ti = 0

	fr = 200
	ep = thrower(
		vec(64,64),
		3,
		150,
		false,
		0,
		0.9
	)
	ep.factory.killspd = 0.01
	ep.factory.postupd = function(self)
		local ct16 = ct16
		local st16 = st16
		local ct12 = ct12
		local x,y = self.pos.x,self.pos.y

		if press_l then
			local a = (vec(64,64) - self.pos)
			self.vel = vec.frompolar(
				a:ang() + t/4 + 0.5,
				1.1
			)
			-- self.grav = vec()
		end
		if press_x then
			self.pos = vec(fflr(self.pos.x+8,24)+2*cos(self.pos.x/16),fflr(self.pos.y+8,16)+2*sin(self.pos.x/16))
			self.vel = vec()
			-- self.grav = vec()
		end
		if press_r then
			local pos = self.pos
			local goal = pos:fflr(16)
			if pos.x-goal.x>=1 then
				vel = vec(-1,0)
			elseif pos.y - goal.y>1 then
				vel = vec(0,-1)
			end
			if press_l then
				vel += self.vel
			end
			self.vel:set(vel)
		end

		local d = vec.frompolar(
			ct16 + fflr(x/8 + y/8, 1/8)*an ,
			1 + 0
		)
		self.grav = d:norm(0.5*aim:magn()/48 / d:sqrmagn())
		if press_z  then
			self.grav += aim/8 + vec.frompolar(fflr(x/32 + y/32, 1/8)*an/2,8)
		end
	end
	ep:set_area(true,16,16)
	ep.factory.drwoverride = function(self)
		--fillp(0b1111000011110000.1)
		
		local x,y=self.pos.x,self.pos.y
		local v = sin(self.vel:norm())*1.8+1
		if press_u then v = sin(self.vel:ang()/2+t/4)*2+1 end 
		if v>2 then
			pset(x,y-2,7)
			pset(x,y+2,7)
			pset(x-2,y,7)
			pset(x+2,y,7)
		else
			circ(x,y,v,7)
		end
		
		--fillp()
	end
end

function _update()
	ct16 = cos(t/16)
	ct12 = cos(t/12)
	st16 = sin(t/16)
	st12 = sin(t/12)

	press_z = btnp(4)
	press_x = btnp(5)
	press_l = btn(0)
	press_r = btn(1)
	press_u = btn(2)
	press_d = btn(3)

	t+=1/30
	ti += 1

	aim = vec(stat(32),stat(33)) - vec(64,64)
	an = (aim):ang() + 1/8

	ep.pos = vec(64,64)
	for e in all(DOTS.throwers) do 
		e:upd()
	end
end

function _draw()
	cls()

	for e in all(DOTS.throwers) do
		e:drw()
	end

	local s = stat(1)
	if s>maxs then maxs = s end
	if s<mins then mins = s end
	ssum += s

	print(#(DOTS.throwers[1].stones),0,0,7)
	print(t,0,6,7)
	print(stat(0),0,12,7)

	aim = vec(stat(32),stat(33))
	if not( aim.x<-1 or aim.y>127+1 or aim.y<-1 or aim.y>127+1 ) then
		local x,y = aim:xy()
		--fillp(0b1010010110100101.1)
		line(x-3,y-3,x+3,y+3,7)
		line(x+3,y-3,x-3,y+3,7)
		line(aim.y,64,64,aim.x/2+aim.y/2,7)
		line(64,aim.y,aim.x,64,7)
		--fillp()
		pset(x,y,0)
	end
end
