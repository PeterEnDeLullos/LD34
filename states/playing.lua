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


    character.update(dt)

      for k,v in pairs(gamestate.room.objects) do
        v:update(dt,k)
    end
    for k,e in pairs(gamestate.room.enemies) do
        e:update(dt,k)
    end
    character.dx,character.dy = gamestate.me.body:getLinearVelocity()

    gamestate.room.world:update(dt) --this puts the world into motion
    character.fall_through = false
    gamestate.cam:setPosition( math.ceil(gamestate.me.body:getX()), 

    math.ceil(gamestate.me.body:getY()))
    --here we are going to create some keyboard events
end
function gamestate.playing:draw()
    gamestate.cam:draw(function(l,t,w,h)
        gamestate.room.map:draw()

    drawDoors()

      for k,v in pairs(gamestate.room.objects) do
        v:draw()
    end
    for k,e in pairs(gamestate.room.enemies) do
        e:draw()
    end
        character.draw()

        -- love.graphics.circle("fill",175,75,math.sqrt(0.5*50*0.5*50+0.5*50*0.5*50))
        if(gamestate.room.map.layers["foreground"]) then
            gamestate.room.map.layers["foreground"].draw()
        end
        if(debug) then
            love.graphics.push('all')
            debugWorldDraw(gamestate.room.world,l,t,w,h)
            love.graphics.pop()
        end
        --- ugly hack
    end)

    minimap.draw()

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )).."LOC"..gamestate.room.loc, 10, 10)

end