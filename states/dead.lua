gamestate.dead  = {} -- previously: Gamestate.new()




function gamestate.dead:update(dt)
    if gamestate.dead.dt == nil then
        gamestate.dead.dt =1
    end
    gamestate.dead.dt = gamestate.dead.dt - dt
    if  gamestate.dead.dt < 0 then
        gamestate.dead.dt = nil
        gamestate.WM.resetRoom(gamestate.me.worldX,gamestate.me.worldY)

        GS.switch(gamestate.playing)
    end
    --here we are going to create some keyboard events
end
function gamestate.dead:draw()
    gamestate.cam:draw(function(l,t,w,h)
        gamestate.room.map:draw()


        character.draw()
      for k,v in pairs(gamestate.room.objects) do
        v:draw()
    end
    for k,e in pairs(gamestate.room.enemies) do
        e:draw()
    end
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
    love.graphics.print("U DEAD", 10, 30)

end