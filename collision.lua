function collideWithPlayer(a,b,col)

print("AA")
			if(gamestate.room.leftDoor and b == gamestate.room.leftDoor.fixture ) then
				print("left")
				if (gamestate.room.toLeft == true) then
					print("ENABLED")
					gamestate.nextRoom={x=gamestate.me.worldX-1, y=gamestate.me.worldY,dir ="right"}
				end
			end
			if(gamestate.room.rightDoor and b == gamestate.room.rightDoor.fixture ) then
				print("RIGHT")
				if (gamestate.room.toRight) then
					gamestate.nextRoom={x=gamestate.me.worldX+1, y=gamestate.me.worldY,dir="left"}
				end
			end
			if(gamestate.room.upDoor and b == gamestate.room.upDoor.fixture ) then
				if (gamestate.room.toUp) then

					gamestate.nextRoom={x=gamestate.me.worldX, y=gamestate.me.worldY+1,dir="down"}
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