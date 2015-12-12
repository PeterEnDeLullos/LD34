gamestate.map = {}
gamestate.worldmap = {}

function gamestate.worldmap.newMiniPart(mapfile)
	local newTile = {}
	newTile.map = sti.new("example_map.lua")
	newTile.world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
	   local lay = gamestate.map.layers.doors
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
	return newTile
end

-- direction is the direction from which you entered the room
-- xco and yco are the coordinates of the room you want to enter. 
-- This function does NOT check if your move is sensible (ie, possible from where you are right now)

function gamestate.worldmap.enterRoom(xco, yco, direction)

	-- first set the doors opened or closed

	-- only difference is in callback actually, so just add walls.
       -- addLineToWorld({x=},vv,ww)

	
	-- move player to right position


end
