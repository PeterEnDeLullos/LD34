gamestate.warp  = {} -- previously: Gamestate.new()




function gamestate.warp:update(dt)
    if gamestate.warp.dt == nil then
        gamestate.warp.dt =1
    end

    gamestate.warp.dt = gamestate.warp.dt - dt
    if  gamestate.warp.dt < 0 then
        gamestate.warp.dt = nil

        GS.switch(gamestate.playing)
    end
    --here we are going to create some keyboard events
end
function gamestate.warp:draw()
    local dx = 0
    local dy = 0
    if gamestate.warp.direction =="left" then
         dx  = -0.5
    end
    if gamestate.warp.direction =="right" then
         dx  = 0.5
    end
    if gamestate.warp.direction =="up" then
         dy = -0.5
    end
    if gamestate.warp.direction =="down" then
         dy = 0.5
    end
    if gamestate.warp.dt > 0.5 then
        love.graphics.scale(1+dx*(1-gamestate.warp.dt) ,1+dy*(1-gamestate.warp.dt))
    else
        love.graphics.scale(1+dx*(gamestate.warp.dt) ,1+dy*(gamestate.warp.dt))
    end
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

end
