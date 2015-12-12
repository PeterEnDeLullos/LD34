gamestate.playing  = {} -- previously: Gamestate.new()



function drawObject(v, r, g, b)
    
    local _,x, y, x2, y2 = gamestate.room.world:unpackShape(v)
    love.graphics.setColor(r, g, b, 255)
    love.graphics.line(x, y, x+x2, y+y2)
  
end


function gamestate.playing:update(dt)
     gamestate.room.world:update(dt) --this puts the world into motion
    gamestate.cam:setPosition(gamestate.me.body:getX(),gamestate.me.body:getY())
  --here we are going to create some keyboard events
  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    gamestate.me.body:applyForce(400, 0)
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    gamestate.me.body:applyForce(-400, 0)
  elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
    gamestate.me.body:applyForce(0, -800)
  end
  if love.keyboard.isDown("down")  then
  	if gamestate.me.wantsToGoDown then
  	gamestate.worldmap.enterRoom(gamestate.me.worldX, gamestate.me.worldY-1,"up")
  	print("MV")
  else
  	print("No down floor collided with")
  end
  end
end
function gamestate.playing:draw()
 gamestate.cam:draw(function(l,t,w,h)
gamestate.room.map:draw()
if(debug) then
   debugWorldDraw(gamestate.room.world,l,t,w,h)
end
 love.graphics.draw( gamestate.me.img,gamestate.me.body:getX()-16, gamestate.me.body:getY()-16 )
     for k,v in pairs (lines) do
        drawObject(v,0,255,0)
     end

    -- love.graphics.circle("fill",175,75,math.sqrt(0.5*50*0.5*50+0.5*50*0.5*50))
end)


 love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

end