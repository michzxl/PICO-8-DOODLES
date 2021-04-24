pico-8 cartridge // http://www.pico-8.com
version 30
__lua__

#include vec.lua
#include tex.lua
#include main_rend.lua

__gfx__
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fff77ffff77777ffff7777fff7777ffff777777ff777777fff7777fff77ff77ff777777ffffff77ff77ff77ff77ffffff77fff7ff77ff77ff777777ff77777ff
ff7777fff77ff77ff77ff77ff77f77fff77ffffff77ffffff77ff77ff77ff77ffff77ffffffff77ff77f77fff77ffffff777f77ff777f77ff77ff77ff77ff77f
f77ff77ff77777fff77ffffff77ff77ff77777fff77777fff77ffffff77ff77ffff77ffffffff77ff7777ffff77ffffff777777ff777777ff77ff77ff77ff77f
f77ff77ff77ff77ff77ffffff77ff77ff77ffffff77ffffff77f777ff777777ffff77ffffffff77ff7777ffff77ffffff77f7f7ff777777ff77ff77ff77777ff
f777777ff77ff77ff77ff77ff77f77fff777777ff77ffffff77ff77ff77ff77ffff77ffff77ff77ff77f77fff77ffffff77fff7ff77f777ff77ff77ff77fffff
f77ff77ff77777ffff7777fff7777ffff777777ff77fffffff77777ff77ff77ff777777fff7777fff77ff77ff777777ff77fff7ff77ff77ff777777ff77fffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff7777fff77777ffff77777ff777777ff77ff77ff77ff77ff77fff7ff77ff77ff77ff77ff777777fff7777fffff77fffff7777ffff7777ffffff77fff777777f
f77ff77ff77ff77ff777fffffff77ffff77ff77ff77ff77ff77fff7ff77ff77ff77ff77fffff77fff77ff77fff777ffff77ff77ff7fff77ffff777fff77fffff
f77ff77ff77ff77fff7777fffff77ffff77ff77ff77ff77ff77fff7ffff77fffff7777fffff77ffff77f777ffff77fffffff77fffff777ffff7777fff77777ff
f77f777ff77777fffffff77ffff77ffff77ff77ff777777ff77f7f7ffff77ffffff77fffff77fffff777f77ffff77ffffff77ffffffff77ff77f77fffffff77f
f77777fff77f777ffffff77ffff77ffff77ff77fff7777fff777777ff77ff77ffff77ffff77ffffff77ff77ffff77fffff77fffff77ff77ff777777ff77ff77f
ff77f77ff77ff77ff77777fffff77fffff7777fffff77ffff777f77ff77ff77ffff77ffff777777fff7777ffff7777fff777777fff7777ffffff77ffff7777ff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff7777fff777777fff7777ffff7777ffffffffffffffffffff7f7ffffff77fffff7ff7ffffffffffffffffffffffffffffffffffff7777fffff77ffffff77fff
f77ffffffffff77ff77ff77ff77ff77fffffffffffffffffff7f7ffffff77ffff777777ffffffffffffffffffffffffffff7fffff77ff77ffff77ffffff77fff
f77777ffffff77ffff7777ffff77777ffffffffffffffffffffffffffff77fffff7ff7ffffffffffffffffffff7777fffff7ffffffff77ffffffffffffffffff
f77ff77ffff77ffff77ff77ffffff77ffffffffffffffffffffffffffff77fffff7ff7fff777777ffffffffffffffffff77777fffff77fffffffffffffffffff
f77ff77ffff77ffff77ff77fffff77fffff77ffffff77ffffffffffffffffffff777777fffffffffffffffffff7777fffff7fffffffffffffff77ffffff77fff
ff7777fffff77fffff7777ffff777ffffff77ffffff77ffffffffffffff77fffff7ff7fffffffffff777777ffffffffffff7fffffff77ffffff77ffffff77fff
ffffffffffffffffffffffffffffffffffffffffff77ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff77ffff
ffffffffffffffffff77ffffffff77ffff7777fffff7777fffff77ffff77fffffafafafaffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffff7ff7fffffff77ffffffffff77fff77fffffffff77ffff77ffffff77fffa077770ff777777ffff77fffffffffffffffffffffffffffffffffffffffffff
fffff7ffff7ffffff77ffffffffff77fff77fffffffff77fff77ffffffff77ff1770077af777777fff7777ffffffffffffffffffffffffffffffffffffffffff
ffff7ffffff7fffff77ffffffffff77fff77fffffffff77ff77ffffffffff77fa000770ff777777ff77ff77fffffffffffffffffffffffffffffffffffffffff
fff7ffffffff7ffff77ffffffffff77ff77fffffffff77fff77ffffffffff77f1007700af777777ff77ff77fffffffffffffffffffffffffffffffffffffffff
ff7ffffffffff7fff77ffffffffff77ff77fffffffff77ffff77ffffffff77ffa000000ff777777ff777777fffffffffffffffffffffffffffffffffffffffff
f7ffffffffffff7ff77ffffffffff77ff77fffffffff77fffff77ffffff77fff1007700af777777ff77ff77fffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffff77ffffffff77fff7777fffff7777ffffff77ffff77ffffafafafafffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
__map__
0d0e3b0b0e150400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000