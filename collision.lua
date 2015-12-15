function collideWithPlayer(a,b,col)
	if gamestate.suitcase.body.fixture== b then
		character.hasSuitcase = true
		gamestate.suitcase.body.body:destroy()
		gamestate.suitcase.body.fixture = nil
		gamestate.suitcase.y = -1000
		addLevelOne()
	end
	--character.standStill = true
	if(gamestate.room.killFixtures[b]) then
		GS.switch(gamestate.dead)
	end
	if(gamestate.room.leftDoor and b == gamestate.room.leftDoor.fixture ) then
		if (gamestate.room.toLeft == true) then
			gamestate.nextRoom={x=gamestate.me.worldX-1, y=gamestate.me.worldY,dir ="right"}
		end
	end
	if(gamestate.room.rightDoor and b == gamestate.room.rightDoor.fixture ) then
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
function postSolvePlayer(a,b,coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	character.jump = 1
end
function postSolve(a,b,coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)

	if a == gamestate.me.fixture then 
		postSolvePlayer(a,b,coll,normalimpulse1,tangentimpulse1,normalimpulse2,tangentimpulse2)
	end
	if b == gamestate.me.fixture then
		postSolvePlayer(b,a,coll,normalimpulse2,tangentimpulse2,normalimpulse1,tangentimpulse1)
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