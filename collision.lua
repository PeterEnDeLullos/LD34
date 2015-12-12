function collideWithPlayer(a,b,col)

			if(gamestate.room.leftDoor and b == gamestate.room.leftDoor.fixture ) then
				if (gamestate.room.toLeft) then
					gamestate.worldmap.enterRoom(gamestate.me.worldX-1, gamestate.me.worldY,"right")
				end
			end
			if(gamestate.room.rightDoor and b == gamestate.room.rightDoor.fixture ) then
				if (gamestate.room.toRight) then
					gamestate.worldmap.enterRoom(gamestate.me.worldX+1, gamestate.me.worldY,"left")
				end
			end
			if(gamestate.room.upDoor and b == gamestate.room.upDoor.fixture ) then
				if (gamestate.room.toUp) then

					gamestate.worldmap.enterRoom(gamestate.me.worldX, gamestate.me.worldY+1,"down")
				end
			end
			if(gamestate.room.downDoor and b == gamestate.room.downDoor.fixture ) then
				if (gamestate.room.toDown) then
					gamestate.me.wantsToGoDown = true
					--gamestate.worldmap.enterRoom(gamestate.me.worldX, gamestate.me.worldY-1,"up")
					
					end
			end
end
function collide (a,b,coll)
	if a == gamestate.me.fixture then 
		collideWithPlayer(a,b,coll)
	end
	if b == gamestate.me.fixture then
		collideWithPlayer(b,a,coll)
	end
end

function endCollideWithPlayer(a,b,col)
			
			if(gamestate.room.downDoor and b == gamestate.room.downDoor.fixture ) then
				if (gamestate.room.toDown) then
					gamestate.me.wantsToGoDown = false
					
				end
			end
end


function endCollide(a,b,coll)
	if a == gamestate.me.fixture then 
		endCollideWithPlayer(a,b,coll)

	end
	if b == gamestate.me.fixture then
		endCollideWithPlayer(b,a,coll)
	end
end