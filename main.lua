local sti = require "sti"
local gamera =  require 'gamera.gamera'
EPS = 3
XMINSP = 10
gamestate = {}
debug = true
zz = {}
GRAV = 1300
back = {}
require 'music'

tile_width =32
lines = {}
objects = {}
tile_height=32
local function addBlock(x,y,w,h,gamestate)
  local block = {x=x,y=y,w=w,h=h,ctype="aa"}
  gamestate.n_blocks =gamestate.n_blocks +1
  block.isWall = true
  gamestate.blocks["a"..gamestate.n_blocks] = block
  gamestate.jump = true
  gamestate.world:add(block, x,y,w,h)
  return block
end
function findLinesAndSegments(layer)

  for k,v in pairs(layer.objects) do
    for kk,vv in pairs(v.polyline) do
      if op ~= nil then
         -- local shape = splash.seg(op.x,op.y,vv.x-op.x,vv.y-op.y)
        print(vv.x-op.x,vv.y-op.y)


          line = {}
line.body = love.physics.newBody(world, op.x, op.y, "static") --place the body in the center of the world and make it dynamic, so it can move around
line.shape = love.physics.newEdgeShape(0,0,vv.x-op.x,vv.y-op.y)
  --line.shape = love.physics.newPolygonShape(0,0,   vv.x-op.x,vv.y-op.y   ,vv.x-op.x+8,vv.y-op.x+8   ,op.x+8,op.y+8) --the ball's shape has a radius of 20
  line.fixture = love.physics.newFixture(line.body,line.shape, 1) -- Attach fixture to body and give it a density of 1.
  line.fixture:setRestitution(0) --let the ball bounce
     -- lines[#lines+1] = gamestate.world:add({}, shape)
      

      end
        op = vv
    end
    op = nil
  end
  print (#lines)
end

function love.load()
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
 
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  gamestate.map = sti.new("example_map.lua")
    gamestate.cam = gamera.new(0,-100,20000,20000)
i = 0
  local t = {}
  t.track = "music/theme_loop.wav"
  local n = {}
  n.track =  "music/themeloop.wav"
  t.next = n
  n.next = t
  track = t
  play()
  


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

   findLinesAndSegments(gamestate.map.layers.col)

  --local shape = splash.aabb(150,50,50, 50)
 
end

function love.update(dt)
     world:update(dt) --this puts the world into motion
    gamestate.cam:setPosition(objects.ball.body:getX(),objects.ball.body:getY())
  --here we are going to create some keyboard events
  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    objects.ball.body:applyForce(400, 0)
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    objects.ball.body:applyForce(-400, 0)
  elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
    objects.ball.body:applyForce(0, -800)
  end
end

function drawObject(v, r, g, b)
    
    local _,x, y, x2, y2 = gamestate.world:unpackShape(v)
    love.graphics.setColor(r, g, b, 255)
    love.graphics.line(x, y, x+x2, y+y2)
  
end



function love.draw()
  gamestate.cam:draw(function(l,t,w,h)
gamestate.map:draw()
 love.graphics.draw( gamestate.me.img,gamestate.me.body:getX()-16, gamestate.me.body:getY()-16 )
     for k,v in pairs (lines) do
        drawObject(v,0,255,0)
     end

    -- love.graphics.circle("fill",175,75,math.sqrt(0.5*50*0.5*50+0.5*50*0.5*50))
end)


 love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

  
end


function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end


