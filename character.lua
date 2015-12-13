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
-- use == z
character.hasSuitcase = false -- x to use suitcase
character.hasUmbrella = false -- c to use umbrella
character.hasBarrel = false -- v to throw barrel
character.hasJetpack = false -- double jump replaced with jetpack!
character.attack_pressed = false
character.vel = 200
function character.load()
  local image = love.graphics.newImage('graphics/entity/player/walking/walking_bellboy.png')
  local g = anim8.newGrid(64, 128, image:getWidth(), image:getHeight())
  local animation = anim8.newAnimation(g('1-10',1), 0.1)
  character.images.walking = image
  character.animations.walking = animation
  character.animation = character.animations.walking
  character.image = character.images.walking

  character.attack_t = -1 -- timing of attack
  character.attack_c = -1 -- cooldown
  		character.animation:flipH()
end
function character.handle_move_inputs(dt)
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
  		 	local x,y = gamestate.me.body:getLinearVelocity()

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
	    if character.dir > 0 then 
	    character.rotate()
	end
  	end
  if love.keyboard.isDown("left") and x >= -1.5*character.vel then --press the left arrow key to push the ball to the left
  	moved = true
  	character.dashCount = -1
    gamestate.me.body:setLinearVelocity(-character.vel, y)
    if  character.dir < 0 then 
	    character.rotate()
	end
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
  	character.fall_through = true
  	if gamestate.me.wantsToGoDown then
  	gamestate.nextRoom={x=gamestate.me.worldX, y=gamestate.me.worldY-1,dir="up"}
  end


  end
   if math.abs(y) <= character.EPS  and character.standStill == true then
  	character.jump = 2
  end
    	character.standStill = false
    	character.moved = moved
end
function character.handle_debug_inputs(dt)
if love.keyboard.isDown("r")  then
  	if not az then
  		az = true
  		    gamestate.WM.resetRoom(gamestate.me.worldX,gamestate.me.worldY)

  		end
  		else
  			az = false

    end
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
end

function character.handle_attack_inputs(dt)
	if love.keyboard.isDown("x ") then  -- suitcase attack
		if not character.attack_pressed  then
		character.attack_t = 0.1
		character.attack_c = 0.1
		gamestate.room.world:rayCast(gamestate.me.body:getX(),gamestate.me.body:getY(), gamestate.me.body:getX()-character.dir*64, gamestate.me.body:getY(), character.attack)
		character.attack_pressed = true
	end
	else
		character.attack_pressed = false
	end
	if love.keyboard.isDown("c" ) then  -- umbrella attack
		if not character.attack_pressed  then
		character.attack_t = 0.1
		character.attack_c = 0.1
		gamestate.room.world:rayCast(gamestate.me.body:getX(),gamestate.me.body:getY(), gamestate.me.body:getX()-character.dir*64, gamestate.me.body:getY(), character.attack)
		character.attack_pressed = true
	end
	else
		character.attack_pressed = false
	end
	if love.keyboard.isDown("v") then  -- barrel attack
		if not character.attack_pressed  then
		character.attack_t = 0.1
		character.attack_c = 0.1
		-- add circle
		local fb = FlyingBarrel(gamestate.me.body:getX()-1.4*tile_width*character.dir,gamestate.me.body:getY(),gamestate.room,gamestate.room.world)
		fb.body.body:setLinearVelocity(-character.dir*300,-300)
		-- add movement to circle

		character.attack_pressed = true
	end
	else
		character.attack_pressed = false
	end

end
function character.handle_action_inputs(dt)

if love.keyboard.isDown("c") then
      if not action then
        action = true
      for k,v in pairs(gamestate.room.objects) do
        table.foreach(v,print)
        if v.x then
        	print(v.x-gamestate.me.body:getX())
        local dx = gamestate.me.body:getX() - v.x
        local dy = gamestate.me.body:getY() - v.y

          if math.sqrt(dx*dx + dy*dy)< 160 then
            v:action()
          end
      end
      end
    end
  else
    action = false
    end
end
function character.attack(fixture, x, y, xn, yn, fraction)
	local oth = gamestate.room.enemies[fixture]
	if(oth   ~= nil) then
		oth:hit(1)
	end
	return 1
end
function character.handle_inputs(dt)
		 	local x,y = gamestate.me.body:getLinearVelocity()

		 	--- death counter for window
		 	if character.attack_t < 0 then
		 		if(character.attack_c >0)then
		 			character.attack_c = character.attack_c - dt
		 		else
		 			character.handle_attack_inputs(dt)
		 		end
	
 
 	
    character.handle_action_inputs(dt)
	else
		-- raycast to check for enemies
		


		character.attack_t = character.attack_t - dt
	end
	character.handle_move_inputs(dt)
	character.handle_debug_inputs(dt)
end
function character.rotate()
	character.animation:flipH()
	character.dir =  character.dir * -1
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
	
	if math.abs(x) > TE and (x  * character.dir > 0) and not character.moved then
		character.rotate()
	end
	character.animation:draw(character.image,gamestate.me.body:getX()-0.5*tile_width, gamestate.me.body:getY()-tile_height )

end



