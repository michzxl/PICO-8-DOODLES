p = {
  mode = "player",
  x = 56,
  y = 56,
  vx = 0,
  vy = 0,
  acc = 0.15,
  brake = -0.15,
  anim = 0,
  anim_len = 2,
  anim_spd = 20,
  max = 1,
  fac = 0,
  upd = nil,
  drw = nil,
  shadow=nil,
  next = nil,
  prev = nil
}
d = {
  left = 0,
  right = 1,
  up = 2,
  down = 3,
  z = 4,
  o = 4,
  x = 5
}
bins={}
bin_size=10
bounds = {
  flower=flower_bounds,
  grass=flower_bounds
}
points = {} --table
flowers = nil --linked list. 
entities = nil --linked list
gravity = 0.10
x_mod, y_mod = 2, 2
z_factor = 0.5
flower_amt = 6
flower_timer = 0
flower_timer_max = 60
flower_anim = 0
flower_types = 5
grass_types = 4
sqrt2 = 1.4
cen = 60
lerpt = 0.2
_mx, _my = 0, 0
mx, my = 0, 0
launch_theta = 0.075
flowers_planted = 0
camera_x, camera_y = 0, 0
proximity = 4
acc = false


function _init()
  
  poke(0x5f2d, 1)
  
  --add "toggle debug" to pause menu
  menuitem(1, "toggle debug", toggle_debug)
  
  load_cartdata()
  
  if not acc then
    z_factor = z_factor * 2
  end
  
  p.upd = move_player
  p.drw = draw_player
  p.shadow=draw_player_shadow
  add_entity(p)
  add_entity(new_trunk(30, 30, 2))
  add_entity(new_trunk(60, 60, 5))
end

function _update60()
  mouse()
  keyboard()
  
  foreach(points, update_point)
  
  update_flower_timer()
  local ptr = flowers
  while ptr ~= nil do
    ptr.upd(ptr)
    ptr = ptr.next
  end
  
  input()
  
  local ptr = entities
  while ptr ~= nil do
    ptr.upd(ptr)
    ptr = ptr.next
  end
end

function _draw()
  cls()
  rectfill(0, 0, 127, 127, 3)
  
  camera((p.x - cen) + flr(lerp(0, mx - cen, lerpt)), (p.y - cen) + flr(lerp(0, my - cen, lerpt)))
  camera_x = peek(0x5f28) + peek(0x5f29) * 256
  camera_y = peek(0x5f2a) + peek(0x5f2b) * 256
  
  map(0, 0)

  local ptr=entities
  while ptr~=nil do
    ptr.shadow(ptr)
    ptr=ptr.next
  end

  -- draw flowers
  local ptr = flowers
  while ptr ~= nil do
    ptr.drw(ptr)
    ptr = ptr.next
  end
  
  --draw seeds and entities at same time.
  local i = 1
  local ptr = entities
  while ptr ~= nil do
    local y = ptr.y
    while points[i] ~= nil and points[i].y < y do
      draw_seed(points[i])
      i = i + 1
    end
    ptr.drw(ptr)
    ptr = ptr.next
  end
  
  while points[i] ~= nil do
    draw_seed(points[i])
    i = i + 1
  end
  
  -- draw mouse
  camera()
  palt()
  sspr(15, 47, 10, 10, mx - 5, my - 5)
  
  if debug then draw_debug() end
end

function toggle_debug()
  debug = not debug
  dset(0, (dget(0) + 1) % 2)
end

function load_cartdata()
  cartdata("wildflower")
  debug = (dget(0) == 1)
end

function draw_debug()
  color((stat(7) < stat(8)) and 8 or 7)
  print("" .. stat(7) .. "/" .. stat(8))
  color((stat(1) > 0.999) and 8 or 7)
  print("cpu: " .. stat(1))
  color((stat(0) >= 2048) and 8 or (stat(0) >= 1024 and 9 or 7))
  print("mem:" .. flr(stat(0)) .. " / " .. "2048 kIb")
  color(7)
  print("flowers: " .. flowers_planted)
  print("mouse (abs): " .. _mx + camera_x .. " " .. _my + camera_y)
end

function superspr(sp, x, y, trans, w, h)
  palt(0, false)
  palt(trans, true)
  spr(sp, x, y, w, h)
  palt()
end

function dist(x1, y1, x2, y2)
  return sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

function sqr_dist(x1,y1,x2,y2)
  return (y2-y1)^2 + (x2-x1)^2
end

function manhattan_dist(x1, y1, x2, y2)
  return abs(x2 - x1) + abs(y2 - y1)
end

function on_screen(mx, my, buffer)
  local x = mx - camera_x
  local y = my - camera_y
  return (0 - buffer) <= x and x <= (127 + buffer) and (0 - buffer) <= y and y <= (127 + buffer)
end

function flower_collision(fl, prox)
  local ptr = fl.prev
  while ptr ~= nil do
    if abs(ptr.y - fl.y) > prox then break end
    if manhattan_dist(ptr.x, ptr.y, fl.x, fl.y) <= prox then return true end
    ptr = ptr.prev
  end
  
  ptr = fl.next
  while ptr ~= nil do
    if abs(ptr.y - fl.y) > prox then break end
    if manhattan_dist(ptr.x, ptr.y, fl.x, fl.y) <= prox then return true end
    ptr = ptr.next
  end
  
  return false
end

function update_flower_timer()
  flower_timer = (flower_timer + 1) % flower_timer_max
  if flower_timer == 0 then flower_anim = (flower_anim + 1) % 2 end
end

function calc_facing()
  local a = p.vx > p.vy
  local b = abs(p.vx) > abs(p.vy)
  if p.vx == 0 and p.vy == 0 then return p.fac end
  if not a and b then return 0 end
  if a and b then return 1 end
  if a and not b then return 2 end
  if not a and not b then return 3 end
end

function lerp(v0, v1, t)
  return (1 - t) * v0 + t * v1
end

function keyboard()
  key = stat(31)
end

function mouse()
  local p_mx, p_my = _mx, _my
  _mx, _my = stat(32), stat(33)
  local nmx = mx + (_mx - p_mx)
  local nmy = my + (_my - p_my)
  nmx = mid(5, nmx, 123)
  nmy = mid(5, nmy, 123)
  mx = nmx
  my = nmy
  
  _mb = stat(34)
  _mbld, _mbrd = false, false
  _mbld = _mbl == 0 and band(0x1, _mb) > 0
  _mbl = band(0x1, _mb)
  _mbrd = _mbr == 0 and band(0x2, _mb) > 0
  _mbr = band(0x2, _mb)
end

function input()
  local l, r, u, dn = btn(d.left), btn(d.right), btn(d.up), btn(d.down)
  
  --accounts for diagonal movement,
  --moves in each axis by 1/sqrt(2), the hypotenuse of which is 1.
  if l and u then
    p.vx = p.vx - 1 / sqrt2 * p.acc
    p.vy = p.vy - 1 / sqrt2 * p.acc
  elseif u and r then
    p.vx = p.vx + 1 / sqrt2 * p.acc
    p.vy = p.vy - 1 / sqrt2 * p.acc
  elseif r and dn then
    p.vx = p.vx + 1 / sqrt2 * p.acc
    p.vy = p.vy + 1 / sqrt2 * p.acc
  elseif dn and l then
    p.vx = p.vx - 1 / sqrt2 * p.acc
    p.vy = p.vy + 1 / sqrt2 * p.acc
  else
    if l then p.vx = p.vx - p.acc end
    if r then p.vx = p.vx + p.acc end
    if u then p.vy = p.vy - p.acc end
    if dn then p.vy = p.vy + p.acc end
  end
  
  if _mbld or btn(d.z) then
    launch_handful("seed", flower_amt)
  end
  if _mbrd then
    launch_radial("seed", 20, 1, 30)
  end
end

function move_player(pl)
  pl.x = pl.x + pl.vx
  pl.y = pl.y + pl.vy
  
  --snipped from "Shodo" by @onariman
  --https://www.lexaloffle.com/bbs/?tid=2033
  local prev
  if pl.vx ~= 0 then
    prev = pl.vx
    pl.vx = pl.vx + pl.vx * pl.brake
    pl.vx = mid(-1 * pl.max, pl.vx, pl.max)
    if prev * pl.vx < 0 then pl.vx = 0 end
  end
  if pl.vy ~= 0 then
    prev = pl.vy
    pl.vy = pl.vy + pl.vy * pl.brake
    pl.vy = mid(-1 * pl.max, pl.vy, pl.max)
    if prev * pl.vy < 0 then pl.vy = 0 end
  end
  
  pl.fac = calc_facing()
  
  del_entity(pl)
  add_entity(pl)
end

function draw_player(p)
  if abs(p.vx) <= 0.001 and abs(p.vy) <= 0.001 then
    superspr(19, p.x - 4, p.y - 4, 3, 1, 1)
  else
    superspr(0 + (2 * p.fac) + (p.anim / p.anim_spd), p.x - 4, p.y - 4, 3, 1, 1)
  end
  p.anim = (p.anim + 1) % (p.anim_len * p.anim_spd)
end

function draw_flower(fl)
  local x = fl.x
  local y = fl.y
  local st = fl.state
  if st == 0 then
    rect(x, y, x, y, 11)
  elseif st == 1 then
    sspr(40 + 3 * fl.sp, 32, 3, 4, x-1, y-2)
  elseif st == 2 then
    --sspr(40 + 3 * fl.sp, 36 + 4 * flower_anim, 3, 4, x - 1, y - 2)
    sspr(40 + 3 * fl.sp, 36, 3, 4, x - 1, y - 2)
  end
end

function draw_grass(fl)
  local x = fl.x
  local y = fl.y
  sspr(40 + 3 * (fl.state == 2 and 1 or 0) + 3 * fl.sp, 44 + (4 * flower_anim), 3, 4, x - 1, y - 2)
end

function draw_seed(po)
  local x, y = po.x, po.y - z_factor * po.z
  local ay=po.y
  rect(x, y, x, y, (pget(x, y) == 3) and 11 or 3)
  rect(x,ay,x,ay,1)
end

function update_point(po)
  po.vz = po.vz - gravity
  
  po.x = po.x + po.vx
  po.y = po.y + po.vy
  po.z = po.z + po.vz
  
  if po.z <= 0 then
    plant_point(po)
  end
end

function update_flower(flower)
  if flower.state ~= 2 then
    flower.growth = flower.growth + 1
    if flower.growth >= flower.grow then
      flower.growth = 0
      flower.state = flower.state + 1
    end
  end
end

function update_grass(grass)
  grass.growth = grass.growth + 1
  if grass.growth >= grass.grow then
    grass.growth = 0
    grass.state = grass.state + 1
    if grass.state > 1 then
      grass.state = 1
      if flr(rnd(100))+1 <= 5 then
        grow_grass(grass)
      end
    end
  end
end

function launch_handful(mode, count)
  for i = 1, count do
    local r1 = x_mod * (flr(rnd(11)) + 1 - 6)
    local r2 = y_mod * (flr(rnd(11)) + 1 - 6)
    if acc then
      launch_point_accurate(p.x, p.y, launch_theta, mx + camera_x + r1, my + camera_y + r2, mode)
    else
      launch_point_approx(p.x, p.y, launch_theta, mx + camera_x + r1, my + camera_y + r2, mode)
    end
  end
end

function launch_radial(mode, count, dist_min, dist_max)
  for i = 1, count do
    local lat_theta = rnd(1)
    local dist = flr(rnd(dist_max - dist_min + 1)) + dist_min
    
    if acc then
      launch_point_accurate(p.x, p.y, launch_theta, p.x + dist * cos(lat_theta), p.y + dist * sin(lat_theta))
    else
      launch_point_approx(p.x, p.y, launch_theta, p.x + dist * cos(lat_theta), p.y + dist * sin(lat_theta))
    end
  end
end

function launch_point_approx(_x, _y, _th, _xf, _yf, _mode)
  --this assumes theta is 0.15 constant
  local d = dist(_x, _y, _xf, _yf)
  local s = sqrt(gravity * d)
  local lat_th = atan2(_xf - _x, _yf - _y)
  local lat_s = s * 0.8

  local vx=lat_s * cos(lat_th)
  local vy=lat_s * sin(lat_th)
  local vz = s * 0.65

  add_point(_mode, _x, _y, 0, vx, vy, vz)
end

function launch_point_accurate(_x, _y, _th, _xf, _yf, _mode)
  local d = dist(_x, _y, _xf, _yf) --calc lateral distance
  local s = sqrt((-1 * gravity * d) / (sin(2 * _th))) --launch speed
  local lat_th = atan2(_xf - _x, _yf - _y) --lateral theta (theta of <x,y>)
  local lat_s = s * sin(_th) --lateral launch speed (i.e. ~<vx,vy>)
  local vx = lat_s * cos(lat_th)
  local vy = lat_s * sin(lat_th)
  local vz = s * cos(_th)
  add_point(_mode, _x, _y, 0, vx, vy, vz)
end

function add_point(_mode, _x, _y, _z, _vx, _vy, _vz)
  local pl = {
    mode = _mode,
    x = _x,
    y = _y,
    z = _z,
    vx = _vx,
    vy = _vy,
    vz = _vz
  }
  add(points, pl)
  return pl
end

function plant_point(p)
  local plant
  local gen = flr(rnd(100)) + 1
  
  if gen <= 35 then
    plant = new_grass(p)
  else
    plant = new_flower(p)
  end
  
  del(points, p)
  
  add_flower(plant)
  return plant
end

function grow_grass(flower)
  local dx, dy = flr(rnd(4)) + 4, flr(rnd(4)) + 4
  dx = dx * (flr(rnd(3)) - 1)
  dy = dy * (flr(rnd(3)) - 1)
  local x, y = flower.x + dx, flower.y + dy
  plant_point({ x = x, y = y })
end

function new_flower(p)
  local flower = {
    mode = "flower",
    x = p.x,
    y = p.y,
    sp = flr(rnd(flower_types)),
    state = 0,
    growth = 0,
    grow = 60 * 2 * (rnd(2) + 1) / 2,
    upd = update_flower,
    drw = draw_flower,
    bins={}
  }
  return flower
end

function new_grass(p)
  local grass = {
    mode = "grass",
    x = p.x,
    y = p.y,
    sp = flr(rnd(grass_types)),
    state = 0,
    growth = 0,
    grow = 60 * 2 * (rnd(2) + 1) / 2,
    upd = update_grass,
    drw = draw_grass,
    bins={}
  }
  return grass
end

function add_flower(fl)
  if flowers == nil then --create list
    flowers = fl
  elseif flowers.y > fl.y then --insert at head
    fl.next = flowers
    flowers.prev = fl
    flowers = fl
  else
    local ptr = flowers
    while ptr ~= nil do
      if fl.y > ptr.y then
        if ptr.next == nil then --insert at tail
          ptr.next = fl
          fl.prev = ptr
          break
        elseif fl.y <= ptr.next.y then --insert in-between...
          if sqr_dist(fl.x, fl.y, ptr.next.x, ptr.next.y) <= proximity^2 then return end
          fl.next = ptr.next
          fl.prev = ptr
          ptr.next.prev = fl
          ptr.next = fl
          break
        end
      end
      ptr = ptr.next
    end
  end
  
  if flower_collision(fl, proximity) then del_flower(fl) return end
  
  flowers_planted = flowers_planted + 1
  return flowers
end

function del_flower(fl)
  if fl.prev == nil and fl.next == nil then --make empty list
    flowers = nil
  elseif fl.prev == nil then --head
    flowers = fl.next
    fl.next = nil
    flowers.prev = nil
  elseif fl.next == nil then --tail
    fl.prev.next = nil
    fl.prev = nil
  else --who cares
    fl.prev.next = fl.next
    fl.next.prev = fl.prev
    fl.prev = nil
    fl.next = nil
  end
  return fl
end

function randy(lo, hi)
  return flr(rnd(hi - lo + 1)) + low
end

function new_trunk(_x, _y, _h)
  local tree = {
    mode = "trunk",
    x = _x,
    y = _y,
    height = _h,
    upd = update_trunk,
    drw = draw_trunk,
    shadow=draw_trunk_shadow,
    next = nil,
    prev = nil
  }
  return tree
end

function add_entity(e)
  e.next = nil
  e.prev = nil
  if entities == nil then --create list
    entities = e
    e.next, e.prev = nil, nil
  elseif entities.y > e.y then --insert at head
    e.next = entities
    entities.prev = e
    entities = e
    e.prev = nil
  else
    local ptr = entities
    while ptr ~= nil do
      if ptr == e then
      elseif e.y > ptr.y then
        if ptr.next == nil then --insert at tail
          ptr.next = e
          e.prev = ptr
          return entities
        elseif e.y <= ptr.next.y then --insert in-between...
          e.next = ptr.next
          e.prev = ptr
          ptr.next.prev = e
          ptr.next = e
          return entities
        end
      end
      ptr = ptr.next
    end
  end
  return entities
end

function del_entity(e)
  if e.prev == nil and e.next == nil then --make empty list
    entities = nil
  elseif e.prev == nil then --head
    entities = e.next
    e.next = nil
    entities.prev = nil
  elseif e.next == nil then --tail
    local prev = e.prev
    prev.next = nil
    e.prev = nil
  else
    local prev = e.prev
    local next = e.next
    prev.next = e.next
    next.prev = e.prev
  end
  return e
end

function draw_trunk_shadow(t)
  local r=5
  --circfill(t.x+8+2,t.y+2,r,1)
  rectfill(t.x+r+8+2,t.y-r+2,t.x+r+max(12,-8+8*t.height),t.y+r+2,1)
  circfill(t.x+max(20,8*t.height),t.y+2,r,1)
end

function draw_player_shadow(pl)
  --circfill(pl.x,pl.y+1,2,1)
  rectfill(pl.x,pl.y+1,pl.x+4,pl.y+3,1)
  rectfill(pl.x,pl.y+2,pl.x+5,pl.y+2,1)
end

function draw_trunk(t)
  if not trunk_on_screen(t) then return end

  local mod = 0
  if overlap_player(t.x, t.y - 8 * t.height - 3, t.x + 15, t.y) then
    mod = 4
  end
  
  local x = t.x
  local y = t.y
  local h = t.height
  local currh = y
  if h <= 0 then return end
  local base, trunk, head, top, trunk_col, head_col = 224, 226, 210, 194, 208, 192

  spr(base + mod, x, currh, 2, 1)
  currh = currh - 8

  if h == 1 then
    spr(head_col + mod, x, currh, 2, 1)
    spr(top + mod, x, currh - 8, 2, 1)
  else
    spr(trunk_col + mod, x, currh, 2, 1)
    currh = currh - 8
  
    for i = 1, h - 1 do
      spr(trunk + mod, x, currh, 2, 1)
      currh = currh - 8
    end
    
    spr(top + mod, x, currh, 2, 2)
  end
end

function trunk_on_screen(t)
  local y2 = t.y + 8
  local y1 = y2 - (8 * (t.height + 2)) - 1
  local x1 = t.x
  local x2 = t.x + 16
  
  return on_screen(x1, y1, 2) or on_screen(x1, y2, 2)
      or on_screen(x2, y1, 2) or on_screen(x2, y2, 2)
end

function overlap_player(x1, y1, x2, y2)
  local px1, py1, px2, py2 = p.x - 3, p.y, p.x, p.y + 8
  if (x1 > px2 or px1 > x2) then return false end
  if (y1 > py2 or py1 > y2) then return false end
  return true
end

function update_trunk(t)
end

function init_bin(x,y)
  if bins[x] == nil then
    bins[x]={}
  end
  
  if bins[x][y] == nil then
    bins[x][y]={elem=nil,next=nil}
  end
end

function make_item(elem, mode, bounds)
  local item = {
    elem = elem,
    next = nil
  }
  return item
end

function init_elem_bin(elem,x,y)
  if elem.bins[x] == nil then
    elem.bins[x]={}
  end
  
  if elem.bins[x][y] == nil then
    elem.bins[x][y]={elem=nil,next=nil}
  end
end

function put_in_bins(elem)
  --get bounds of element
  local bounds = elem.bounds(elem)
  
  --loop through all bins the element intersects with.
  for x=bins_index(bounds.x1),bins_index(bounds.x2) do
    for y=bins_index(bounds.x1),bins_index(bounds.x2) do
      
      --make bin item from element
      local item = make_item(elem)
      
      --add item to bin's & element's bin array
      add_to_bin(item,x,y)
      add_to_elem_bin(item,elem,x,y)
    end
  end
end

function add_to_elem_bin(item,elem,x,y)
  init_elem_bin(elem,x,y)
  elem.bins[x][y]=item
end

function add_to_bin(item,x,y)
  --initialize bin, if not already.
  init_bin(x,y)
  
  --head of bin's list
  local ptr = bins[x][y]
  
  --if empty list...
  if ptr==nil or ptr.elem==nil then
    bins[x][y]=item
    item.next=nil
    return item
  end
  
  --loop until ptr is last element of list
  while ptr.next~=nil do
    ptr=ptr.next
  end
  
  --attach item to end of list
  ptr.next=item
  item.next=nil
  
  return item
end

function flower_bounds(fl)
  local x1=fl.x-proximity
  local y1=fl.y-proximity
  local x2=x1+2+proximity
  local y2=y1+3+proximity
  
  return {x1=x1,y1=y1,x2=x2,y2=y2}
end

function bins_index(n)
  return flr(n/bin_size)
end
