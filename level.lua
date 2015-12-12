gamestate.room = {}
gamestate.worldmap = {}
require 'collision'
function gamestate.worldmap.newMiniPart(mapfile,xco,yco)
	local newTile = {}
	newTile.map = sti.new("example_map.lua")
	newTile.name = mapfile
	newTile.world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
    newTile.world:setCallbacks(collide, endCollide,nil,nil)
	   local lay = newTile.map.layers.doors
	   if lay == nil then
	   		error ("WRONG LEVEL FORMATTING: doors layer missing")
	   	end
	   for k,v in pairs(lay.objects) do
	   	
	   	if (v.name) == "left" then
	   		newTile.left = {}
	   		newTile.left.x = v.x
	   		newTile.left.y = v.y

	   	end
	   	if (v.name) == "right" then
			newTile.right = {}
	   		newTile.right.x = v.x
	   		newTile.right.y = v.y
	   	end
	   	if (v.name) == "up" then
			newTile.up = {}
	   		newTile.up.x = v.x
	   		newTile.up.y = v.y
	   	end
	   	if (v.name) == "down" then
			newTile.down = {}
	   		newTile.down.x = v.x
	   		newTile.down.y = v.y
	   	end
	   end
	findLinesAndSegments(newTile.map.layers.col,newTile.world)
	if (gamestate.worldmap[xco] == nil) then
		gamestate.worldmap[xco] = {}
	end
	gamestate.worldmap[xco][yco] = newTile
	return newTile
end
function addPlayer(direction)
	local mx=0
	local my=0

	if direction == "left" then
  mx = gamestate.room.left.x+64
  my = gamestate.room.left.y
  	end
if direction == "right" then
  mx = gamestate.room.right.x-64
  my = gamestate.room.right.y
  	end
  	if direction == "up" then
  mx = gamestate.room.up.x
  my = gamestate.room.up.y+128
  	end
  	if direction == "down" then
  mx = gamestate.room.down.x
  my = gamestate.room.down.y-128
  	end
	 	local me = {}
	 	print(direction)
  me.body = love.physics.newBody(gamestate.room.world, mx, my, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  me.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
  me.fixture = love.physics.newFixture(me.body, me.shape, 1) -- Attach fixture to body and give it a density of 1.
  me.fixture:setRestitution(0) --let the ball bounce
  gamestate.me=me
  
	gamestate.me.dx = 0
  	gamestate.me.dy = 0
  --findSolidTiles(gamestate.map)
    gamestate.me.img =  love.graphics.newImage( "graphics/character.png" )
end
-- direction is the direction from which you entered the room
-- xco and yco are the coordinates of the room you want to enter. 
-- This function does NOT check if your move is sensible (ie, possible from where you are right now)

function gamestate.worldmap.enterRoom(xco, yco, direction)
	-- first find the room
	if gamestate.me ~= nil then
	gamestate.me.body:destroy()
end
	if gamestate.worldmap[xco] == nil then
		error("Room row not found")
	end

	gamestate.room = gamestate.worldmap[xco][yco]
	print(gamestate.room.name)
	if gamestate.room == nil then
		error ("Room not found")
		return
	end
	if gamestate.room.left then
		if(checkDoor(xco,yco,"left")) then
			gamestate.room.toLeft = true
			print("LEFT")

		end
		gamestate.room.leftDoor = addLineToWorld({x=gamestate.room.left.x,y=gamestate.room.left.y},{x=gamestate.room.left.x,y=gamestate.room.left.y+128},gamestate.room.world)
		print("ADDING LEFT DOOR")
	end
	if gamestate.room.right then
		if(checkDoor(xco,yco,"right")) then
			gamestate.room.toRight = true
		end
				gamestate.room.rightDoor = addLineToWorld({x=gamestate.room.right.x,y=gamestate.room.right.y},{x=gamestate.room.right.x,y=gamestate.room.right.y+128},gamestate.room.world)

	end
	if gamestate.room.up then
		if(checkDoor(xco,yco,"up")) then
			gamestate.room.toUp = true
		end
		gamestate.room.upDoor = addLineToWorld({x=gamestate.room.up.x,y=gamestate.room.up.y},{x=gamestate.room.up.x+64,y=gamestate.room.up.y},gamestate.room.world)
	end
	if gamestate.room.down then
		if(checkDoor(xco,yco,"down")) then
			gamestate.room.toDown = true
		end
		gamestate.room.downDoor = addLineToWorld({x=gamestate.room.down.x,y=gamestate.room.down.y},{x=gamestate.room.down.x+64,y=gamestate.room.down.y},gamestate.room.world)
	end
	addPlayer(direction)

	-- first set the doors opened or closed

	-- only difference is in callback actually, so just add walls.
        --addLineToWorld({x=},vv,ww)

	
	-- move player to right position

	gamestate.me.worldX = xco
	gamestate.me.worldY = yco
end
function checkRoom(xco,yco)
	

	if(gamestate.worldmap[xco] == nil) then

		return false
	end
	
	return gamestate.worldmap[xco][yco] ~= nil
end
function checkDoor(xco,yco,direction)
	if (direction =="left") then
		if not checkRoom(xco-1, yco)  then
			print("No room left")
			return false
		end
		return gamestate.worldmap[xco][yco].left and gamestate.worldmap[xco-1][yco].right

	else
	print("No door left")
	end
	if (direction =="right") then
		if not checkRoom(xco+1, yco)  then
			return false
		end
		return gamestate.worldmap[xco][yco].right and gamestate.worldmap[xco+1][yco].left
	else
		print("No door right")
	end
	if (direction =="up") then
		if not checkRoom(xco, yco+1)  then
			return false
		end
		return gamestate.worldmap[xco][yco].up and gamestate.worldmap[xco][yco+1].down
	else
		print("No door up")
	end
	if (direction =="down") then
		if not checkRoom(xco, yco-1)  then
			print("NU")
			return false
		end
		return gamestate.worldmap[xco][yco].down and gamestate.worldmap[xco][yco-1].up
	else
		print("No door down")
	end
end