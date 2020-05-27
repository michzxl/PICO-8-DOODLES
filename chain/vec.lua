_vec={
    set=function(self,x,y,z)
        self.x=x
        self.y=y
        self.z=z
    end,
    setv=function(self,v)
        self.x=v.x
        self.y=v.y
        self.z=v.z
    end,
    norm = function(p)
        return p / #p
    end,
    constrain = function(self,anchor,dist)
        return (self - anchor):norm() * dist + anchor
    end,
    constrain_min = function(self,anchor,dist)
        local v = self - anchor
        return #v<dist and self:constrain(anchor,dist) or self
    end,
    constrain_max = function(self,anchor,dist)
        local v = self - anchor
        return #v>dist and self:constrain(anchor,dist) or self
    end,
    copy = function(self)
        return vec(self.x,self.y,self.z)
    end,
    cross = function(A, B)
        return vec(
            A.y*B.z - A.z*B.y,
            A.z*B.x - A.x*B.z,
            A.x*B.y - A.y*B.x
        )
    end
}

_mtt_vec={
    __index=_vec,
    __add=function(p1,p2)
        return vec(p1.x+p2.x,p1.y+p2.y,p1.z+p2.z)
    end,
    __sub=function(p1,p2)
        return vec(p1.x-p2.x,p1.y-p2.y,p1.z-p2.z)
    end,
    __mul=function(p,a)
        if type(a)=="number" then
            return vec(p.x*a,p.y*a,p.z*a)
        else return nil end
    end,
    __div=function(p,a)
        if type(a)=="number" then
            return vec(p.x/a,p.y/a,p.z/a)
        else return nil end
    end,
    __unm=function(p)
        return vec(-p.x,-p.y,-p.z)
    end,
    __len=function(p)
        return sqrt(sqr(p.x)+sqr(p.y)+sqr(p.z))
    end,
}

function vec(x,y,z)
    x,y,z=x or 0, y or 0, z or 0
    local v={x=x,y=y,z=z}
    setmetatable(v,_mtt_vec)
    return v
end