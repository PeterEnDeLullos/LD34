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
    world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
 
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  gamestate.map = sti.new("example_map.lua")
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

  --love.thread.newThread("music_thread.lua"):start()

  --let's create a ball
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 50, 50, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.ball.fixture:setRestitution(0) --let the ball bounce
  gamestate.me=objects.ball
  gamestate.me.x = 120
  gamestate.me.y = 50
  gamestate.me.dx = 0
  gamestate.me.dy = 0
  --findSolidTiles(gamestate.map)
    gamestate.me.img =  love.graphics.newImage( "graphics/character.png" )
  gamestate.worldmap.newMiniPart("example_map.lua")
   findLinesAndSegments(gamestate.map.layers.col,world)

  --local shape = splash.aabb(150,50,50, 50)
     GS.registerEvents()
    GS.switch(gamestate.playing)
end


function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end


