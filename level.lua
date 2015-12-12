gamestate.room = {}
gamestate.worldmap = {}

function gamestate.worldmap.newMiniPart(mapfile,xco,yco)
	local newTile = {}
	newTile.map = sti.new("example_map.lua")
	newTile.world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
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
	if (gamestate.worldmap.xco == nil) then
		gamestate.worldmap.xco = {}
	end
	gamestate.worldmap.xco.yco = newTile
	return newTile
end

-- direction is the direction from which you entered the room
-- xco and yco are the coordinates of the room you want to enter. 
-- This function does NOT check if your move is sensible (ie, possible from where you are right now)

function gamestate.worldmap.enterRoom(xco, yco, direction)
	-- first find the room
	if gamestate.worldmap.xco == nil then
		error("Room row not found")
	end

	gamestate.room = gamestate.worldmap.xco.yco
	if gamestate.room == nil then
		error ("Room not found")
		return
	end




 	objects.ball = {}
  objects.ball.body = love.physics.newBody(gamestate.room.world, 50, 50, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
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

	-- first set the doors opened or closed

	-- only difference is in callback actually, so just add walls.
        --addLineToWorld({x=},vv,ww)

	
	-- move player to right position


end
function checkDoor(xco,yco,direction)

end