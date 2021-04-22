DOTS = {
	stones = {},
	throwers = {},
}
__dots = DOTS

function makethrower(self, pos, freq, maxstones, burst, gravity, damp)
	local m = {}
	m.stones = {}
	m.deadqueue = {}

	m.pos = pos
	m.throwing = true
	m.freq = freq
	m.timer = 0
	m.maxstones = maxstones
	m.gravity = gravity or vec()
	m.damp = damp or vec.one()

	m.burst = burst
	m.burst_num = m.maxstones

	m.usepool = maxstones>=1
	m.pooled = false
	m.override_pool = true
	m.lifo = true
	m.pool = {}

	m.use_area = false
	m.area_width = 0
	m.area_height = 0

	m.factory = {
		col = 7,
		life = 30*3,
		life_spread = 0,
		ang = 0,
		ang_spread = 1,
		spd_init = 1,
		killspd = 0x0.001,
		spd_spread = 0,
		size_init = 0,
		size_spread = 0,
		updoverride = nil,
		postupd = nil,
		drwoverride = nil,
	}

	add(DOTS.throwers, m)
	setmetatable(m, _thrower)
	return m
end

thrower = {
	upd = function(self)
		self:throw()
		for p in all(self.stones) do
			p:upd()
			if p.dead then
				add(self.deadqueue, p)
			end
		end
		
		self:recycle()
	end,
	drw = function(self)
		for stn in all(self.stones) do
			stn:drw()
		end
	end,
	grabstone = function(self)
		local x,y = self.pos:xy()
		if self.use_area then
			local width,height = self.area_width,self.area_height
			x = x + flr(rnd(width)) - width / 2
			y = y + flr(rnd(height)) - height / 2
		end

		local stn = {}
		local lenpool = #self.pool
		if self.usepool and #self.stones + lenpool == self.maxstones then
			stn = self.pool[lenpool]
			deli(self.pool,lenpool)
		else
			stn = stone()
		end

		local fact = self.factory
		local override = self.override_pool
		local ang = fact.ang + rnd_spread(fact.ang_spread)
		local spd = fact.spd_init + rnd_spread(fact.spd_spread)
		local size = fact.size_init + rnd_spread(fact.size_spread)
		local life = fact.life + rnd_spread(fact.life_spread)
		stn:set(
			override and vec(x,y) or stn.pos,
			vec.frompolar(ang,spd),
			self.gravity,
			self.damp,
			fact.killspd,
			size,
			life,
			override and fact.col or stn.col
		)
		stn.updoverride = fact.updoverride
		stn.postupd = fact.postupd
		stn.drwoverride = fact.drwoverride
		stn.dead = nil
		return stn
	end,
	throw = function(self)
		if self.throwing then
			if self.burst then
				--TODO:
			else
				self.timer += self.freq
				if self.timer >= 1 then
					local amt = self:get_throw_amount(self.timer)
					for i=1,amt do
						self:addstone(self:grabstone())
					end
					
					self.timer -= amt
				end
			end
		end
	end,
	get_throw_amount = function(self, num)
		if (self.maxstones ~= 0 and #self.stones + flr(num) >= self.maxstones) then
			return self.maxstones - #self.stones
		end
		return flr(num)
	end,
	addstone = function(self, stn)
		add(self.stones, stn)
	end,
	delstone = function(self, stn)
		add(self.deadqueue, stn)
	end,
	recycle = function(self)
		for s in all(self.deadqueue) do
			if self.usepool then
				add(self.pool, s)
			end
			del(self.stones, s)
			del(DOTS.stones, s)
		end
		self.deadqueue = {}
	end,
	set_area = function(self,use,width,height)
		self.use_area = use
		self.area_width = width
		self.area_height = height
	end,
}
_thrower = {__index = thrower}
setmetatable(thrower, {
	__call = makethrower
})

function makestone(pos,vel,grav,damp,killspd,size,col)
	local stn = setmetatable({},_stone)
	add(DOTS.stones, stn)
	return stn:set(pos,vel,grav,damp,killspd,size,col)
end

stone = {
	set = function(stn,pos,vel,grav,damp,killspd,size,life,col)
		stn.pos = pos
		stn.vel = vel
		stn.grav = type(grav)=="number" and vec(0,grav,0) or grav
		stn.damp = damp
		stn.initspd = vel and vel:magn() or 0
		stn.killspd = killspd
		stn.size = size
		stn.col = col
		stn.life = life
		return stn
	end,
	drw = function(self)
		if (self.drwoverride) then return self:drwoverride() end
		if self.size < 1 then
			pset(self.pos.x,self.pos.y,self.col)
		else
			circ(self.pos.x,self.pos.y,1,self.col)
		end
	end,
	upd = function(self)
		if (self.updoverride) then 
			self:updoverride() 
			if self.postupd then self:postupd() end
			return 
		end
		local pos,vel,grav,damp = self.pos,self.vel,self.grav,self.damp
		
		vel:set(vel * damp + grav)
		pos:set(pos + vel)
		self.life -= 1
		if pos.x<0 or pos.x>127 or pos.y<0 or pos.y>127 then self.dead = true end
		if self.life<0  then self.dead = true end
		
		if (self.postupd) then self:postupd() end
	end,
}
_stone = {__index = stone}
setmetatable(stone, {
	__call = makestone
})

function rnd_spread(spread)
	return rnd(spread * sgn(spread)) * sgn(spread)
end