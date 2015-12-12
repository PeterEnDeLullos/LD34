Class = require 'hump.class'
require 'map_interpretation'
debugWorldDraw = require("debugWorldDraw")
sti = require "sti"
local gamera =  require 'gamera.gamera'

-- ALL data of game
gamestate = {}
GS = require 'hump.gamestate'
minimap = require 'GUI.minimap'
require 'state_playing'
require 'level'
debug = false
GRAV = 1300

back = {}
require 'music'

tile_width = 32
tile_height = 32

--lines = {}


function love.load()
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
    gamestate.cam = gamera.new(0,-100,20000,20000)


  --[[
    usage: Music.<Player>:play(filename)
    Music.<Player>:enqueue(filename) = queue a track
    Music.<player>.queue.setLoopStart() = set next track in queue to be the start of the loop, looping everything of the remaining queue.
    Music.<player>:playNext(<callback>) = start playing the queue, and optionally call callback when the first song has ended.
  ]]--
  Music.theme:enqueue("music/theme_loop.wav")
  Music.theme:enqueue("music/themeloop2.wav")
  Music.theme.queue:setLoopStart()

  Music.boss:enqueue("music/boss_intro.wav")
  Music.boss:enqueue("music/boss_loop.wav")
  Music.boss:enqueue("music/boss_loop.wav", nil, function(b) Music.boss:crossFadeTo(Music.theme, 20) end)

  --let's create a ball
 
  gamestate.WM.newMiniPart("levels/empty.lua",1,1)
  gamestate.WM.newMiniPart("example_map2.lua",0,1)
  gamestate.WM.newMiniPart("example_map_D.lua",1,2)

  minimap.update()

  --local shape = splash.aabb(150,50,50, 50)
    GS.registerEvents()
    GS.switch(gamestate.playing)
    printMap()
    shift("left")
    printMap()

end


function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end


