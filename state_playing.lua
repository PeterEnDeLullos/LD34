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
  for k,v in pairs(gamestate.room.objects) do
    v:update(dt)
  end
     gamestate.room.world:update(dt) --this puts the world into motion
    gamestate.cam:setPosition(gamestate.me.body:getX(),gamestate.me.body:getY())
  --here we are going to create some keyboard events
 character.update(dt)
end
function gamestate.playing:draw()
 gamestate.cam:draw(function(l,t,w,h)
gamestate.room.map:draw()


character.draw()

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