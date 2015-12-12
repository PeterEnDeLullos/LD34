local minimap = require 'GUI.minimap'
sti = require "sti"
local gamera =  require 'gamera.gamera'

-- ALL data of game
gamestate = {}
GS = require 'hump.gamestate'
require 'state_playing'
require 'level'
debug = true
GRAV = 1300

back = {}
require 'music'

tile_width = 64
tile_height = 64

lines = {}
objects = {}
local function addBlock(x,y,w,h,gamestate)
  local block = {x=x,y=y,w=w,h=h,ctype="aa"}
  gamestate.n_blocks =gamestate.n_blocks +1
  block.isWall = true
  gamestate.blocks["a"..gamestate.n_blocks] = block
  gamestate.jump = true
  gamestate.world:add(block, x,y,w,h)
  return block
end
function addLineToWorld(op,vv,ww)
         line = {}
line.body = love.physics.newBody(ww, op.x, op.y, "static") --place the body in the center of the world and make it dynamic, so it can move around
line.shape = love.physics.newEdgeShape(0,0,vv.x-op.x,vv.y-op.y)
  --line.shape = love.physics.newPolygonShape(0,0,   vv.x-op.x,vv.y-op.y   ,vv.x-op.x+8,vv.y-op.x+8   ,op.x+8,op.y+8) --the ball's shape has a radius of 20
  line.fixture = love.physics.newFixture(line.body,line.shape, 1) -- Attach fixture to body and give it a density of 1.
  line.fixture:setRestitution(0) --let the ball bounce
  end
function findLinesAndSegments(layer, ww)

  for k,v in pairs(layer.objects) do
    for kk,vv in pairs(v.polyline) do
      if op ~= nil then
         -- local shape = splash.seg(op.x,op.y,vv.x-op.x,vv.y-op.y)
        addLineToWorld(op,vv,ww)

 
     -- lines[#lines+1] = gamestate.world:add({}, shape)
      

      end
        op = vv
    end
    op = nil
  end
end

function love.load()
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
    gamestate.cam = gamera.new(0,-100,20000,20000)
i = 0

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
 
  gamestate.worldmap.newMiniPart("example_map.lua",1,1)

  gamestate.worldmap.enterRoom(1,1,"left")

  --local shape = splash.aabb(150,50,50, 50)
     GS.registerEvents()
    GS.switch(gamestate.playing)
end


function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end


