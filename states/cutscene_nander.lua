	gamestate.cutscene = {}
gamestate.cutscene.bgImg = love.graphics.newImage('graphics/cutscenebackground.png')
gamestate.cutscene.sentences = {}
gamestate.cutscene.next = gamestate.playing
-- sentence : {text = "STRING", character = cutSceneCharacter, dt = time}
function gamestate.cutscene.start(sentences,Xnext)
	gamestate.cutscene.sentences = sentences
	gamestate.cutscene.counter = 1
	if gamestate.cutscene.sentences[gamestate.cutscene.counter] ~= nil then
    	GS.switch(gamestate.cutscene)
	else
		if Xnext == nil then
gamestate.cutscene.next = gamestate.playing
	else
		gamestate.cutscene.next = Xnext

		end
		print("Invalid sentences")
	end
	
end
function gamestate.cutscene:update(dt)
	
	gamestate.cutscene.sentences[gamestate.cutscene.counter].dt  = gamestate.cutscene.sentences[gamestate.cutscene.counter].dt  - dt
	if gamestate.cutscene.sentences[gamestate.cutscene.counter].dt  <= 0 then
		gamestate.cutscene.counter = gamestate.cutscene.counter +1
	end
	if gamestate.cutscene.sentences[gamestate.cutscene.counter] == nil then
  	  GS.switch(gamestate.cutscene.next)
	end
    --here we are going to create some keyboard events
end
function gamestate.cutscene.drawScene()
	-- draw background
	love.graphics.draw(gamestate.cutscene.bgImg,1,400)
	--draw character
	if gamestate.cutscene.sentences[gamestate.cutscene.counter]~= nil then
		if gamestate.cutscene.sentences[gamestate.cutscene.counter].character ~= nil then
			gamestate.cutscene.sentences[gamestate.cutscene.counter].character()
		end
		if gamestate.cutscene.sentences[gamestate.cutscene.counter].character ~= nil then
			local pFont = love.graphics.getFont()
			love.graphics.setFont(love.graphics.newFont(18))
			love.graphics.print(gamestate.cutscene.sentences[gamestate.cutscene.counter].text,200,450)
		end
		  
	end
	--draw text
end
function gamestate.cutscene:draw()
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
        gamestate.cutscene.drawScene()

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )).."LOC"..gamestate.room.loc, 10, 10)

end
gamestate.cutscene.meImg = love.graphics.newImage('graphics/cutscene/me.png')
gamestate.cutscene.renderMe = function ()
	local x = 60
	local y = 420
	love.graphics.draw(gamestate.cutscene.meImg,x,y,0,2,2)
end

gamestate.cutscene.openingScene = {{text="Bla bla bla first day bellboy Hilbert Hotel.",character=gamestate.cutscene.renderMe,dt=1}}