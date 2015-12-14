gamestate.room = {}
gamestate.worldmap = {}
gamestate.WM = {}
gamestate.goalX = nil
gamestate.goalY = nil

local minimap = require 'GUI.minimap'

gamestate.showMinimapTransitioncolumn = nil
gamestate.showMinimapTransitionrow = nil
gamestate.showMinimapTransitionCountDown = 0
gamestate.showMinimapTransitionCountDownDef = 1
local leftOpen =  love.graphics.newImage('graphics/entity/door/doorLeftOpen.png')
local rightOpen = love.graphics.newImage('graphics/entity/door/doorRightOpen.png')
local leftClosed = love.graphics.newImage('graphics/entity/door/doorLeftClosed.png')
local rightClosed = love.graphics.newImage('graphics/entity/door/doorRightClosed.png')


local upClosed =  love.graphics.newImage('graphics/entity/door/doorUpClosed.png')
local upOpen = love.graphics.newImage('graphics/entity/door/doorUpOpen.png')
local downClosed = love.graphics.newImage('graphics/entity/door/doorDownClosed.png')
local downOpen = love.graphics.newImage('graphics/entity/door/doorDownOpen.png')


require 'collision'
function addLevelOne()
	gamestate.WM.newMiniPart("levels/1_3_1.lua", 3, 1)
	gamestate.WM.newMiniPart("levels/1_3_2_hallway.lua", 3, 2)
	gamestate.WM.newMiniPart("levels/1_3_3.lua", 3, 3)
	gamestate.WM.newMiniPart("levels/1_2_3.lua", 2, 3)
	gamestate.WM.newMiniPart("levels/1_1_3.lua", 1, 3)
	minimap:update()
	gamestate.room.isGoal = false
	gamestate.worldmap[3][1].isGoal = true
end
function shift(direction)
	
	-- this seems to work
	if direction == "left" then
		local min = 999999999
		local max = 0
		local rooms = {}
		for k,v in pairs(gamestate.worldmap) do -- v is a row, k a collum
					if type(v) == type({})   then
						
			if v[gamestate.me.worldY] ~= nil then
				rooms[v[gamestate.me.worldY]] = k
				if k<min then
					min = k
				end
				if k>max then
					max = k
				end
			end
		end
		end
		for k,v in pairs(rooms) do
			local ok = v
				if(v-1)<min then
					v = max
				else
					v=v-1
				end
				if ok == gamestate.me.worldX then
	
					gamestate.me.worldX = v
				end
				gamestate.worldmap[v][gamestate.me.worldY] = k
				k.x = v
		end
			gamestate.showMinimapTransitionrow = gamestate.me.worldX
	end

	if direction == "right" then
			local min = 999999999
		local max = 0
		local rooms = {}
		for k,v in pairs(gamestate.worldmap) do -- v is a row, k a collum
					if type(v) == type({})   then
						
			if v[gamestate.me.worldY] ~= nil then
				rooms[v[gamestate.me.worldY]] = k
				if k<min then
					min = k
				end
				if k>max then
					max = k
				end
			end
		end
		end
		for k,v in pairs(rooms) do
			local ok = v
				if(v+1)>max then
					v = min
				else
					v=v+1
				end
				if ok == gamestate.me.worldX then
					gamestate.me.worldX = v
				end
				gamestate.worldmap[v][gamestate.me.worldY] = k
				 k.x = v

		end
				gamestate.showMinimapTransitionrow = gamestate.me.worldX

	end
	if direction == "down" then
			local min = 999999999
		local max = 0
		print("X"..gamestate.me.worldX)
		local rooms = {}
		for k,v in pairs(gamestate.worldmap[gamestate.me.worldX]) do -- v is a row, k a collum
					if type(v) == type({})   then
						print(k..":"..v.loc)
				rooms[v] = k
				if k<min then
					min = k
				end
				if k>max then
					max = k
				end
			end
		end
		for k,v in pairs(rooms) do
			local ok = v
				if(v-1)<min then
					v = max
				else
					v=v-1
				end
				if ok == gamestate.me.worldY then
					gamestate.me.worldY = v
				end
				gamestate.worldmap[gamestate.me.worldX][v] = k
				k.y = v
		end
		gamestate.showMinimapTransitioncolumn = gamestate.me.worldY

	end

	if direction == "up" then
	local min = 999999999
		local max = 0
		local rooms = {}
		for k,v in pairs(gamestate.worldmap[gamestate.me.worldX]) do -- v is a row, k a collum
					if type(v) == type({})   then
						
				rooms[v] = k
				if k<min then
					min = k
				end
				if k>max then
					max = k
				end
			end
		
		end
		for k,v in pairs(rooms) do
			local ok = v
				if(v+1)>max then
					v = min
				else
					v=v+1
				end
				if ok == gamestate.me.worldY then
					gamestate.me.worldY = v
				end
				gamestate.worldmap[gamestate.me.worldX][v] = k
				k.y = v
		end
				gamestate.showMinimapTransitioncolumn = gamestate.me.worldY

	end
	gamestate.me.worldX = gamestate.room.x
	gamestate.me.worldY = gamestate.room.y
	resetDoors(gamestate.me.worldX,gamestate.me.worldY)
	minimap.update()
		print (gamestate.me.worldX,gamestate.me.worldY)
gamestate.showMinimapTransitionCountDown = gamestate.showMinimapTransitionCountDownDef
end
function printMap()
	print("---" .. gamestate.me.worldX..":"..gamestate.me.worldY)
	for k, v in pairs(gamestate.worldmap) do
		if type(v) == type({}) then
		for kk, vv in pairs(v) do
			print(k..":"..kk..":::"..vv.loc.."   ")
	end
end
	print("")
	end
end
function addDoors(tile)
	   local lay = tile.map.layers.doors
	   if lay == nil then
	   		error ("WRONG LEVEL FORMATTING: doors layer missing")
	   	end
	   	tile.left = nil
	   	tile.right = nil
	   	tile.up = nil
	   	tile.down = nil
	   for k,v in pairs(lay.objects) do
	   	
	   	if (v.name) == "left" then
	   		tile.left = {}
	   		tile.left.x = v.x
	   		tile.left.y = v.y
			tile.leftDoor = addLineToWorld({x=tile.left.x+2,y=tile.left.y-tile_height},{x=tile.left.x+2,y=tile.left.y+128},tile.world)

	   	end
	   	if (v.name) == "right" then
			tile.right = {}
	   		tile.right.x = v.x
	   		tile.right.y = v.y

	   						tile.rightDoor = addLineToWorld({x=2+tile.right.x+tile_width-2,y=tile.right.y-tile_height},{x=tile.right.x+tile_width-2,y=tile.right.y+128},tile.world)

	   	end
	   	if (v.name) == "up" then
			tile.up = {}
	   		tile.up.x = v.x
	   		tile.up.y = v.y

	   				tile.upDoor = addLineToWorld({x=tile.up.x,y=tile.up.y},{x=tile.up.x+64,y=tile.up.y},tile.world)

	   	end
	   	if (v.name) == "down" then
			tile.down = {}
	   		tile.down.x = v.x
	   		tile.down.y = v.y

	   				tile.downDoor = addLineToWorld({x=tile.down.x,y=tile.down.y+64},{x=tile.down.x+64,y=tile.down.y+64},tile.world)

	   	end
	   end
end
function resetDoors(xco,yco)

gamestate.room.toUp = false
gamestate.room.toDown = false
gamestate.room.toLeft = false
gamestate.room.toRight = false

	if gamestate.room.left then
		if(checkDoor(xco,yco,"left")) then
			gamestate.room.toLeft = true
		end
	end
	if gamestate.room.right then
		if(checkDoor(xco,yco,"right")) then
			gamestate.room.toRight = true
		end
	end
	if gamestate.room.up then
		if(checkDoor(xco,yco,"up")) then
			gamestate.room.toUp = true
		end
	end
	if gamestate.room.down then
		if(checkDoor(xco,yco,"down")) then
			gamestate.room.toDown = true
		end
	end
end

-- Load a room
function gamestate.WM.newMiniPart(mapfile,xco,yco)
	local newTile = {}
	newTile.map = sti.new(mapfile)
	newTile.name = mapfile
	newTile.loc = xco..":"..yco
	newTile.x = xco
	newTile.y = yco
	newTile.world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
    newTile.world:setCallbacks(collide, endCollide,nil,postSolve)
	addDoors(newTile)

	findLinesAndSegments(newTile.map.layers.col,newTile.world)
	newTile.objects={}
	newTile.enemies = {}
	newTile.killFixtures = {}

	getObjects(newTile.map.layers.objects,newTile.world,newTile)
	if (gamestate.worldmap[xco] == nil) then
		gamestate.worldmap[xco] = {}
	end
	gamestate.worldmap[xco][yco] = newTile
	lx = newTile.map.width * tile_width
	ly = newTile.map.height* tile_height
	addLineToWorld({x=0,y=0},{x=0,y=ly},newTile.world)
	addLineToWorld({x=0,y=ly},{x=lx,y=ly},newTile.world)
	addLineToWorld({x=lx,y=ly},{x=lx,y=0},newTile.world)
	addLineToWorld({x=0,y=0},{x=lx,y=0},newTile.world)

	return newTile
end



function recycleBody(direction,body,fixture)
	local mx=0
	local my=0

	if direction == "left" then
  mx = gamestate.room.left.x+2*tile_width
  my = gamestate.room.left.y
  	end
if direction == "right" then
  mx = gamestate.room.right.x-2*tile_width
  my = gamestate.room.right.y
  	end
  	if direction == "up" then
  mx = gamestate.room.up.x
  my = gamestate.room.up.y+tile_height
  	end
  	if direction == "down" then
  mx = gamestate.room.down.x
  my = gamestate.room.down.y-tile_height
  	end
	 	local me = {}
	  me.body = body
	  me.fixture = fixture
	  
	  gamestate.me=me

  
	gamestate.me.dx = 0
  	gamestate.me.dy = 0

  --findSolidTiles(gamestate.map)
    gamestate.me.img =  love.graphics.newImage( "graphics/character.png" )

end
function addPlayer(direction)
	local mx=0
	local my=0

	if direction == "left" then
  mx = gamestate.room.left.x+2*tile_width
  my = gamestate.room.left.y
  	end
if direction == "right" then
  mx = gamestate.room.right.x-2*tile_width
  my = gamestate.room.right.y
  	end
  	if direction == "up" then
  mx = gamestate.room.up.x
  my = gamestate.room.up.y+tile_height
  	end
  	if direction == "down" then
  mx = gamestate.room.down.x
  my = gamestate.room.down.y-tile_height
  	end
	 	local me = {}
	  me.body = love.physics.newBody(gamestate.room.world, mx, my, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	  me.body:setFixedRotation(true)
	  me.shape = love.physics.newRectangleShape(48,120) --the ball's shape has a radius of 20
	  me.fixture = love.physics.newFixture(me.body, me.shape, 1) -- Attach fixture to body and give it a density of 1.
	  me.fixture:setRestitution(0) --let the ball bounce
	  gamestate.me=me
	me.body:setLinearDamping(me.body:getLinearDamping()*10)
  
	gamestate.me.dx = 0
  	gamestate.me.dy = 0

  --findSolidTiles(gamestate.map)
    gamestate.me.img =  love.graphics.newImage( "graphics/character.png" )

end
-- direction is the direction from which you entered the room
-- xco and yco are the coordinates of the room you want to enter. 
-- This function does NOT check if your move is sensible (ie, possible from where you are right now)
function gamestate.WM.resetRoom(xco,yco)
if gamestate.worldmap[xco] == nil then
		error("Room row not found"..xco)
	end

	local daRoom = gamestate.worldmap[xco][yco]
	if(daRoom == nil) then
		error("ROOMuh DOES NOT EXIST"..xco..":"..yco)
	end
	local from = gamestate.room.from

	print(daRoom.map)
		gamestate.WM.newMiniPart(daRoom.name,xco,yco)




	gamestate.WM.enterRoom(xco,yco,from)



end
function gamestate.WM.enterRoom(xco, yco, direction)
	-- first find the room
	if gamestate.worldmap[xco] == nil then
		error("Room row not found"..xco)
	end
	if gamestate.me ~= nil then
	gamestate.me.body:destroy()
end
	gamestate.room = gamestate.worldmap[xco][yco]
	if(gamestate.room == nil) then
		error("ROOM DOES NOT EXIST"..xco..":"..yco)
	end
	gamestate.room.from = direction
	addPlayer(direction)

	resetDoors(xco,yco)
	-- first set the doors opened or closed

	-- only difference is in callback actually, so just add walls.
        --addLineToWorld({x=},vv,ww)

	if gamestate.room == nil then
		error ("Room not found")
		return
	end

	 gamestate.cam:setWorld(0,0,gamestate.room.map.width*tile_width,gamestate.room.map.height*tile_height)
	if gamestate.room.left then
		if(checkDoor(xco,yco,"left")) then
			gamestate.room.toLeft = true
		end

	end
	if gamestate.room.right then
		if(checkDoor(xco,yco,"right")) then
			gamestate.room.toRight = true
		end

			
	end
	if gamestate.room.up then
		if(checkDoor(xco,yco,"up")) then
			gamestate.room.toUp = true
		end

	
	end
	if gamestate.room.down then
		if(checkDoor(xco,yco,"down")) then
			gamestate.room.toDown = true
		end

	
	end
	
	-- move player to right position

	gamestate.me.worldX = xco
	gamestate.me.worldY = yco

	minimap.update()
end
function checkRoom(xco,yco)
	

	if(gamestate.worldmap[xco] == nil) then

		return false
	end
	
	return gamestate.worldmap[xco][yco] ~= nil
end
function drawDoors()
	if gamestate.room.left then
		if gamestate.room.toLeft then
		love.graphics.draw(leftOpen,gamestate.room.left.x,gamestate.room.left.y-tile_height)
	else
		love.graphics.draw(leftClosed,gamestate.room.left.x,gamestate.room.left.y-tile_height)

	end

	end
	if gamestate.room.right then
	if gamestate.room.toRight then
		love.graphics.draw(rightOpen,gamestate.room.right.x,gamestate.room.right.y-tile_height)
	else
		love.graphics.draw(rightClosed,gamestate.room.right.x,gamestate.room.right.y-tile_height)

	end

	end
	if gamestate.room.up then
	if gamestate.room.toUp then
		love.graphics.draw(upOpen,gamestate.room.up.x,gamestate.room.up.y)
	else
		love.graphics.draw(upClosed,gamestate.room.up.x,gamestate.room.up.y)

	end

	end
	if gamestate.room.down then

	if gamestate.room.toDown then
		love.graphics.draw(downOpen,gamestate.room.down.x,gamestate.room.down.y)
	else
		love.graphics.draw(downClosed,gamestate.room.down.x,gamestate.room.down.y)

	end
	end
end
function checkDoor(xco,yco,direction)
	if (direction =="left") then
		if not checkRoom(xco-1, yco)  then
			return false
		end
		return gamestate.worldmap[xco][yco].left and gamestate.worldmap[xco-1][yco].right

	else
	end
	if (direction =="right") then
		if not checkRoom(xco+1, yco)  then
			return false
		end
		return gamestate.worldmap[xco][yco].right and gamestate.worldmap[xco+1][yco].left
	else
	end
	if (direction =="up") then
		if not checkRoom(xco, yco+1)  then
			return false
		end
		return gamestate.worldmap[xco][yco].up and gamestate.worldmap[xco][yco+1].down
	else
	end
	if (direction =="down") then
		if not checkRoom(xco, yco-1)  then
			return false
		end
		return gamestate.worldmap[xco][yco].down and gamestate.worldmap[xco][yco-1].up
	else
	end
end