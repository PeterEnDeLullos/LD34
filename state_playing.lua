gamestate.playing  = {} -- previously: Gamestate.new()


function drawObject(v, r, g, b)
    
    local _,x, y, x2, y2 = gamestate.room.world:unpackShape(v)
    love.graphics.setColor(r, g, b, 255)
    love.graphics.line(x, y, x+x2, y+y2)
  
end


function gamestate.playing:update(dt)
	if gamestate.nextRoom  ~= nil then
		gamestate.WM.enterRoom(gamestate.nextRoom.x,gamestate.nextRoom.y,gamestate.nextRoom.dir)
		gamestate.nextRoom = nil
	end
     gamestate.room.world:update(dt) --this puts the world into motion
    gamestate.cam:setPosition(math.floor(gamestate.me.body:getX()),math.floor(gamestate.me.body:getY()))
  --here we are going to create some keyboard events
  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    gamestate.me.body:applyForce(400, 0)
  end
  if love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    gamestate.me.body:applyForce(-400, 0)
  end
  if love.keyboard.isDown("up")  then --press the up arrow key to set the ball in the air
    gamestate.me.body:applyForce(0, -800)
    jump = jump - 1
  end
  if love.keyboard.isDown("down")  then
  	if gamestate.me.wantsToGoDown then
  	gamestate.nextRoom={x=gamestate.me.worldX, y=gamestate.me.worldY-1,dir="up"}
  else
  	
  end


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
    if love.keyboard.isDown("c") then
      if not action then
        action = true
      print("ACTION")
      for k,v in pairs(gamestate.room.objects) do
        table.foreach(v,print)
        local dx = gamestate.me.body:getX() - v.x
        local dy = gamestate.me.body:getY() - v.y
          if math.sqrt(dx*dx + dy*dy)< 120 then
            print("AC")
            v:action()
          end
      end
    end
  else
    action = false
    end
end
function gamestate.playing:draw()
 gamestate.cam:draw(function(l,t,w,h)
gamestate.room.map:draw()

 love.graphics.draw( gamestate.me.img,gamestate.me.body:getX()-16, gamestate.me.body:getY()-16 )

    -- love.graphics.circle("fill",175,75,math.sqrt(0.5*50*0.5*50+0.5*50*0.5*50))
    if(gamestate.room.map.layers["foreground"]) then
     gamestate.room.map.layers["foreground"].draw()
 end
if(debug) then
   debugWorldDraw(gamestate.room.world,l,t,w,h)
end
	--- ugly hack
end)

    minimap.draw()

 love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )).."LOC"..gamestate.room.loc, 10, 10)

end