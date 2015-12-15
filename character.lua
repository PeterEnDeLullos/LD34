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
  character.suitcaseImage = love.graphics.newImage('graphics/entity/suitcase/one.png')
  character.umbrellaImage = love.graphics.newImage('graphics/entity/suitcase/one.png')





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

	 if love.keyboard.isDown(controls.dash) and character.dashCount < 0  and character.dashWait < 0 then
	 	character.dashCount = 0.8
	 end
	 if character.dashCount >= 0 then
	 	    gamestate.me.body:setLinearVelocity(-character.vel*2*character.dir, y)

	 	    moved = true
	 	character.dashCount = character.dashCount - dt
	 	character.dashWait = 1
	 	 else


	 	if character.dashWait >=0 then
	 	   --gamestate.me.body:setLinearVelocity(-character.vel*character.dir, y)

	 	character.dashWait = character.dashWait -dt

	end
end
  		 	local x,y = gamestate.me.body:getLinearVelocity()
  		
	 if love.keyboard.isDown(controls.right) and x <= 1.5*character.vel then --press the right arrow key to push the ball to the right
	    gamestate.me.body:setLinearVelocity(character.vel, y)
	    character.dashCount = -1
	    moved = true
	    if character.dir > 0 then 
	    character.rotate()
	end
  	end
  if love.keyboard.isDown(controls.left) and x >= -1.5*character.vel then --press the left arrow key to push the ball to the left
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

  if love.keyboard.isDown(controls.up) and character.jump >0  then --press the up arrow key to set the ball in the air
  	if character.jumpLose then
    gamestate.me.body:setLinearVelocity(x, -400)
    character.jump = character.jump - 1
    character.jumpLose = false
	end
else
character.jumpLose = true
  
end
  if love.keyboard.isDown(controls.down)  then
  	if not downPressed then
  	local uu = getNearestUpOnly()
  	if uu ~= nil then
  		uu:setFallThrough()
  	end
  	if gamestate.me.wantsToGoDown then
  	gamestate.nextRoom={x=gamestate.me.worldX, y=gamestate.me.worldY-1,dir="up"}
  end
  downPressed = true
end
else
	downPressed = false

  end
  
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

  		end
  		else
  			lp = false

    end
      if love.keyboard.isDown("d")  then
    if not awea then
      awea = true
          shift("right")

      end
      else
        awea = false

    end
    if love.keyboard.isDown("w")  then
    if not yy then
      yy = true
          shift("up")

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
	local onePressed = false
	if love.keyboard.isDown(controls.attack) and character.hasSuitcase then  -- suitcase attack
		if not character.attack_pressed  then
		character.attack_t = 0.1
		character.attack_c = 0.1
		gamestate.room.world:rayCast(gamestate.me.body:getX(),gamestate.me.body:getY(), gamestate.me.body:getX()-character.dir*64, gamestate.me.body:getY(), character.attack)
		character.attack_pressed = true
		character.weapon="suitcase"
	end
			onePressed = true

	end

	if love.keyboard.isDown(controls.shoot) and character.hasBarrel then  -- barrel attack
		if not character.attack_pressed  then
		character.attack_t = 0.1
		character.attack_c = 0.1
		-- add circle
		local fb = FlyingBarrel(gamestate.me.body:getX()-1.4*tile_width*character.dir,gamestate.me.body:getY(),gamestate.room,gamestate.room.world)
		fb.body.body:setLinearVelocity(-character.dir*300,-300)
		-- add movement to circle
	end
		onePressed = true

	end
		character.attack_pressed =  onPressed

end
function character.handle_action_inputs(dt)

if love.keyboard.isDown(controls.action) then

      if not action then
        action = true
      for k,v in pairs(gamestate.room.objects) do
        if v.x then
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
	if   character.attack_t > 0 then -- timing of attack
		if character.weapon =="suitcase" then
		love.graphics.draw(character.suitcaseImage ,-character.dir*32+gamestate.me.body:getX()-0.5*tile_width, gamestate.me.body:getY()-tile_height )
	end
	end

	character.animation:draw(character.image,gamestate.me.body:getX()-0.5*tile_width, gamestate.me.body:getY()-tile_height )

end



