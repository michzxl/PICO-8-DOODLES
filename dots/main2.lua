function _init()
	cls()

	t = rnd(1000)
	maxs = 0
	mins = 2
	ssum = 0
	ti = 0

	fr = 200
	ep = thrower(
		vec(64,64),
		3,
		200,
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
		local d = vec.frompolar(
			fflr(
				fflr(y/32,0.0625) 
				+ sgn((x-64 + 32*ct16))
					* sgn(y-64 + 32*st16)
					* fflr(x/32, 1/32) 
				+ t/8
			,0.5) 
			+ ct16,
			st12
		)
		self.grav = d:norm(0.1 / d:sqrmagn())
	end
	ep:set_area(true,16,16)
	ep.factory.drwoverride = function(self)
		--fillp(0b1111000011110000.1)
		
		local x,y=self.pos.x,self.pos.y
		local v = sin(self.vel:norm():ang() + t/4)*1.2+1
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

	t+=1/30
	ti += 1

	ep.pos = vec(64+32*cos(t/16),64)
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
end
