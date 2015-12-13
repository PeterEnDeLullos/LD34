obj_types = {}
require 'object_lua.chest'
require 'object_lua.lever'
require 'object_lua.uponly'
local function addBlock(x,y,w,h,gamestate)
  local block = {x=x,y=y,w=w,h=h,ctype="aa"}
  gamestate.n_blocks =gamestate.n_blocks +1
  block.isWall = true
  gamestate.blocks["a"..gamestate.n_blocks] = block
  gamestate.jump = true
  gamestate.world:add(block, x,y,w,h)
  return block
end
function addSquareToWorld(x,y,w,h,ww)
         line = {}
line.body = love.physics.newBody(ww, x, y, "static") --place the body in the center of the world and make it dynamic, so it can move around
line.shape = love.physics.newRectangleShape(w,h)
  --line.shape = love.physics.newPolygonShape(0,0,   vv.x-op.x,vv.y-op.y   ,vv.x-op.x+8,vv.y-op.x+8   ,op.x+8,op.y+8) --the ball's shape has a radius of 20
  line.fixture = love.physics.newFixture(line.body,line.shape, 1) -- Attach fixture to body and give it a density of 1.
  line.fixture:setRestitution(0) --let the ball bounce
  return line
  end
function addLineToWorld(op,vv,ww)
         line = {}
line.body = love.physics.newBody(ww, op.x, op.y, "static") --place the body in the center of the world and make it dynamic, so it can move around
line.shape = love.physics.newEdgeShape(0,0,vv.x-op.x,vv.y-op.y)
  --line.shape = love.physics.newPolygonShape(0,0,   vv.x-op.x,vv.y-op.y   ,vv.x-op.x+8,vv.y-op.x+8   ,op.x+8,op.y+8) --the ball's shape has a radius of 20
  
  line.fixture = love.physics.newFixture(line.body,line.shape, 1) -- Attach fixture to body and give it a density of 1.
  if ow then
    line.fixture.oneway = true
end
  line.fixture:setRestitution(0) --let the ball bounce
  return line
  end
function findLinesAndSegments(layer, ww)

  for k,v in pairs(layer.objects) do
    for kk,vv in pairs(v.polyline) do
      if op ~= nil then
         -- local shape = splash.seg(op.x,op.y,vv.x-op.x,vv.y-op.y)
        local oneway = true
        local l = addLineToWorld(op,vv,ww, oneway)

 
     -- lines[#lines+1] = gamestate.world:add({}, shape)
      

      end
        op = vv
    end
    op = nil
  end
end
function newObject(x,y,meta)

end
function getObjects(layer, ww,newTile)

  upOnly (100,140,400,140,newTile,ww)
  if layer == nil then
    return
  end
  for k,v in pairs(layer.objects) do
    if(v.type =="chest") then
      Chest(v.x,v.y,ww,newTile,v.properties)
    end
    if(v.type =="lever") then
      Lever(v.x,v.y,ww,newTile,v.properties.direction)
    end



  end
end
function getEnemies(layer, ww)
    
end