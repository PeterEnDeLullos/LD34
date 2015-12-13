character = {}
character.EPS = 1
character.jump= 2
character.jumpLose = false
character.image = nil
character.animation = nil
character.images = {}
character.dir = 1
character.dashCount = -0.1
character.dashWait = -0.1
character.dx = 0
character.dy = 0
character.animations = {}
character.vel = 200
function character.load()
  local image = love.graphics.newImage('graphics/entity/player/walking/walking_bellboy.png')
  local g = anim8.newGrid(64, 128, image:getWidth(), image:getHeight())
  local animation = anim8.newAnimation(g('1-10',1), 0.1)
  character.images.walking = image
  character.animations.walking = animation
  character.animation = character.animations.walking
  character.image = character.images.walking
  		character.animation:flipH()

end
function character.handle_inputs(dt)
		 	local x,y = gamestate.me.body:getLinearVelocity()
		 	--- death counter for window
		 	local moved = false
	if gamestate.DC == nil then
			gamestate.DC = 0.5
		end
	if love.keyboard.isDown("escape") then
		gamestate.DC = gamestate.DC - dt
		if gamestate.DC < 0 then
love.event.quit( )
	end
	else
		gamestate.DC = 0.5
	end

	 if love.keyboard.isDown("z") and character.dashCount < 0  and character.dashWait < 0 then
	 	character.dashCount = 0.8
	 	print("DASH")
	 end
	 if character.dashCount >= 0 then
	 	    gamestate.me.body:setLinearVelocity(-character.vel*2*character.dir, y)

	 	    moved = true
	 	character.dashCount = character.dashCount - dt
	 	character.dashWait = 2
	 	 else


	 	if character.dashWait >=0 then
	 	   --gamestate.me.body:setLinearVelocity(-character.vel*character.dir, y)

	 	character.dashWait = character.dashWait -dt

	end
end
  		 	local x,y = gamestate.me.body:getLinearVelocity()
	 if love.keyboard.isDown("right") and x <= 1.5*character.vel then --press the right arrow key to push the ball to the right
    gamestate.me.body:setLinearVelocity(character.vel, y)
    character.dashCount = -1
    moved = true
  end
  if love.keyboard.isDown("left") and x >= -1.5*character.vel then --press the left arrow key to push the ball to the left
  	moved = true
  	character.dashCount = -1
    gamestate.me.body:setLinearVelocity(-character.vel, y)
  end
  if not moved then
	gamestate.me.body:setLinearVelocity((1-5*dt)*x, y)
end
  		 	local x,y = gamestate.me.body:getLinearVelocity()

  if love.keyboard.isDown("up") and character.jump >0  then --press the up arrow key to set the ball in the air
  	if character.jumpLose then
    gamestate.me.body:setLinearVelocity(x, -400)
    character.jump = character.jump - 1
    character.jumpLose = false
	end
else
character.jumpLose = true
  
end
  if love.keyboard.isDown("down")  then
  	if gamestate.me.wantsToGoDown then
  	gamestate.nextRoom={x=gamestate.me.worldX, y=gamestate.me.worldY-1,dir="up"}
  else
  	
  
end


  end
  if math.abs(y) <= character.EPS  and character.standStill == true then
  	character.jump = 2
  end
    	character.standStill = false

  if love.keyboard.isDown("a")  then
  	if not lp then
  		lp = true
  		    shift("left")
  		      		printMap()

  		end
  		else
  			lp = false

    end
      if love.keyboard.isDown("d")  then
    if not awea then
      awea = true
          shift("right")
                printMap()

      end
      else
        awea = false

    end
    if love.keyboard.isDown("w")  then
    if not yy then
      yy = true
          shift("up")
                printMap()

      end
      else
        yy = false

    end
    if love.keyboard.isDown("s")  then
    if not sp then
      sp = true
          shift("down")
                printMap()

      end
      else
        sp = false

    end
    if love.keyboard.isDown("c") then
      if not action then
        action = true
      print("ACTION")
      for k,v in pairs(gamestate.room.objects) do
        table.foreach(v,print)
        local dx = gamestate.me.body:getX() - v.x
        local dy = gamestate.me.body:getY() - v.y
          if math.sqrt(dx*dx + dy*dy)< 160 then
            print("AC")
            v:action()
          end
      end
    end
  else
    action = false
    end
end
function character.update(dt)
	character.x = gamestate.me.body:getX()
	character.y = gamestate.me.body:getY()
	character.handle_inputs(dt)
	character.animation:update(dt*character.dx/100)

end
function character.draw(dt)
	local x,y = gamestate.me.body:getLinearVelocity()
	local TE = character.EPS
	
	if math.abs(x) > TE and (x  * character.dir > 0) then
		character.animation:flipH()
		character.dir =  character.dir * -1
	end
	character.animation:draw(character.image,gamestate.me.body:getX()-0.5*tile_width, gamestate.me.body:getY()-tile_height )

end


