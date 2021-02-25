pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include dots2.lua
#include vec2.lua
#include maths2.lua
#include poly3.lua
#include subpixel2.lua
#include main4.lua

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000077777000077770007777000077777700777777000777700077007700777777000000770077007700770000007700070077007700777777007777700
00777700077007700770077007707700077000000770000007700770077007700007700000000770077077000770000007770770077707700770077007700770
07700770077777000770000007700770077777000777770007700000077007700007700000000770077770000770000007777770077777700770077007700770
07700770077007700770000007700770077000000770000007707770077777700007700000000770077770000770000007707070077777700770077007777700
07777770077007700770077007707700077777700770000007700770077007700007700007700770077077000770000007700070077077700770077007700000
07700770077777000077770007777000077777700770000000777770077007700777777000777700077007700777777007700070077007700777777007700000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700077777000077777007777770077007700770077007700070077007700770077007777770007777000007700000777700007777000000770007777770
07700770077007700777000000077000077007700770077007700070077007700770077000007700077007700077700007700770070007700007770007700000
07700770077007700077770000077000077007700770077007700070000770000077770000077000077077700007700000007700000777000077770007777700
07707770077777000000077000077000077007700777777007707070000770000007700000770000077707700007700000077000000007700770770000000770
07777700077077700000077000077000077007700077770007777770077007700007700007700000077007700007700000770000077007700777777007700770
00770770077007700777770000077000007777000007700007770770077007700007700007777770007777000077770007777770007777000000770000777700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700077777700077770000777700000000000000000000707000000770000070070000000000000000000000000000000000007777000007700000077000
07700000000007700770077007700770000000000000000000707000000770000777777000000000000000000000000000070000077007700007700000077000
07777700000077000077770000777770000000000000000000000000000770000070070000000000000000000077770000070000000077000000000000000000
07700770000770000770077000000770000000000000000000000000000770000070070007777770000000000000000007777700000770000000000000000000
07700770000770000770077000007700000770000007700000000000000000000777777000000000000000000077770000070000000000000007700000077000
00777700000770000077770000777000000770000007700000000000000770000070070000000000077777700000000000070000000770000007700000077000
00000000000000000000000000000000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000770000
00000000000000000077000000007700007777000007777000007700007700001a1a1a1a00077000000000000000000000000000000000000000000000000000
0000007007000000077000000000077000770000000007700007700000077000a077770100077000000000000000000000000000000000000000000000000000
00000700007000000770000000000770007700000000077000770000000077001770077a00077000000000000000000000000000000000000000000000000000
0000700000070000077000000000077000770000000007700770000000000770a000770100077000000000000000000000000000000000000000000000000000
00070000000070000770000000000770077000000000770007700000000007701007700a00077000000000000000000000000000000000000000000000000000
0070000000000700077000000000077007700000000077000077000000007700a000000100077000000000000000000000000000000000000000000000000000
07000000000000700770000000000770077000000000770000077000000770001007700a00077000000000000000000000000000000000000000000000000000
0000000000000000007700000000770007777000007777000000770000770000a1a1a1a100077000000000000000000000000000000000000000000000000000