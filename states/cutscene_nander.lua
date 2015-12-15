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
	local scene  = gamestate.cutscene.sentences[gamestate.cutscene.counter] 
	if scene == nil then 
	  	  GS.switch(gamestate.cutscene.next)
	  	  return
 	end
	if scene.dt ~= nil then

		if love.keyboard.isDown("return") then

			if scene.AUTOSKIP then
				gamestate.cutscene.counter = gamestate.cutscene.counter +1
				scene.AUTOSKIP = false
				print("AN")
			end
		else
			scene.AUTOSKIP = true
		end

		scene.dt  = scene.dt  - dt
		if scene.dt  <= 0 then
			gamestate.cutscene.counter = gamestate.cutscene.counter +1
		end
	if gamestate.cutscene.sentences[gamestate.cutscene.counter] == nil then
  	  GS.switch(gamestate.cutscene.next)
	end
	else
		if scene.options then
			if scene.selected == nil then
				scene.selected = 1
			end
			if love.keyboard.isDown("1","2","3","4") then
		gamestate.cutscene.counter = gamestate.cutscene.counter +1

			end	
		end
	end
    --here we are going to create some keyboard events
end
function gamestate.cutscene.drawScene()
	-- draw background
	love.graphics.draw(gamestate.cutscene.bgImg,1,400)
	--draw character
	local sc =gamestate.cutscene.sentences[gamestate.cutscene.counter]
	if sc~= nil then
		if sc.character ~= nil then
			sc.character()
		end
		if sc.character ~= nil then
			local pFont = love.graphics.getFont()
			love.graphics.setFont(love.graphics.newFont(18))
			if sc.text ~= nil then
			love.graphics.print(sc.text,200,450)
			love.graphics.setFont(pFont)
			end
			if sc.options ~= nil then
				for i=1,#sc.options do
				love.graphics.print(i..".  "..sc.options[i],200,400+24*i)
			end
			end

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
gamestate.cutscene.phoneImg = love.graphics.newImage('graphics/cutscene/phone.png')
gamestate.cutscene.employeeBoss = love.graphics.newImage('graphics/cutscene/employeeBoss.png')

gamestate.cutscene.renderMe = function ()
	local x = 60
	local y = 420
	love.graphics.draw(gamestate.cutscene.meImg,x,y,0,2,2)
end

gamestate.cutscene.renderEmployeeBoss = function ()
	local x = 700
	local y = 420
	love.graphics.draw(gamestate.cutscene.employeeBoss,x,y,0,-2,2)
end
gamestate.cutscene.renderMeStartCombat = function ()
	gamestate.cutscene.renderMe()
	character.hasSuitcase = true

end
gamestate.cutscene.replaceMustacheMan = function()
	Enemy(mustacheMan.x,mustacheMan.y,gamestate.room,gamestate.room.world)
	mustacheMan.body.body:setY(-100000)
	end
gamestate.cutscene.phone = function ()
	local x = 700
	local y = 420
	love.graphics.draw(gamestate.cutscene.phoneImg,x,y,0,2,2)
end

gamestate.cutscene.mustache = love.graphics.newImage('graphics/cutscene/mustache.png')
gamestate.cutscene.renderMustache = function ()
	local x = 700
	local y = 420
	love.graphics.draw(gamestate.cutscene.mustache,x,y,0,-2,2)
end
gamestate.cutscene.controls = {{text="I'm the bellboy at Hilbert's new hotel..",character=gamestate.cutscene.renderMe,dt=1},
{text="This hotel is different from the previous Hilbert's Hotel.",character=gamestate.cutscene.renderMe,dt=1},
{text="It doesn't start at infinite size,\n but rather, it grows with customer demand.",character=gamestate.cutscene.renderMe,dt=1},
{text="To prevent customers from ever having to switch rooms,\n the hotel rooms can shift left-to-right and up-down.",character=gamestate.cutscene.renderMe,dt=1},
{text="As a bellboy I need to walk around.\n You tell me what to do with the arrow keys", character=gamestate.cutscene.renderMe,dt=1},
{text="If you're in a hurry, you can press "..controls.dash.." to dash.",character=gamestate.cutscene.renderMe,dt=1},
{text="Press enter to skip converstations!.",character=gamestate.cutscene.renderMe,dt=1}}
gamestate.cutscene.openingScene = {{text="My first day as a bellboy Hilbert Hotel.",character=gamestate.cutscene.renderMe,dt=1},
{text="Still not busy yet.",character=gamestate.cutscene.renderMe,dt=1},
{text="Ring Ring.",character=gamestate.cutscene.phone,dt=1},
{text="Hello?",character=gamestate.cutscene.renderMe,dt=1},
{text="Why isn't my suitcase delivered to my room yet?",character=gamestate.cutscene.phone,dt=1},
{text="I'm sorry, I'll get on it right away.",character=gamestate.cutscene.renderMe,dt=1},
{text="Click.",character=gamestate.cutscene.phone,dt=1},
{text="I'll need to go to the luggage depot first.\n It's in the room right above this one..",character=gamestate.cutscene.renderMe,dt=1}}


gamestate.cutscene.lever = {{text="Ah, a lever.",character=gamestate.cutscene.renderMe,dt=1},
{text="Press "..controls.action.." to activate levers",character=gamestate.cutscene.renderMe,dt=1},
{text="This moves rows and columns of the hotel." ,character=gamestate.cutscene.renderMe,dt=1},
{text="If you're ever lost,\n you can look at the minimap in the topleft corner.." ,character=gamestate.cutscene.renderMe,dt=1},
{text="It shows you as a square, your goal as an X (X marks the spot)\n and the known levers as arrows..." ,character=gamestate.cutscene.renderMe,dt=1}}


gamestate.cutscene.suitCaseFound = {{text="I found his suitcase. Now I need to bring it to his room..",character=gamestate.cutscene.renderMe,dt=1},
{text="The hotel has grown to add his room to it.",character=gamestate.cutscene.renderMe,dt=1}}
gamestate.cutscene.rememberDash = {{text="Who on earth designed this room?..",character=gamestate.cutscene.renderMe,dt=1},
{text="Remember, you can dash by pressing "..controls.dash.."..",character=gamestate.cutscene.renderMe,dt=1}}


gamestate.cutscene.delivery = {{text="Here's your suitcase sir ..",character=gamestate.cutscene.renderMe,dt=1},
{text="That took way too long.",character=gamestate.cutscene.renderMustache,dt=1},
{text="I'm sorry sir, I just started working here.",character=gamestate.cutscene.renderMe,dt=1},
{text="I'll file a complaint with your manager .",character=gamestate.cutscene.renderMustache,dt=1},
{text="I don't think that's reasonable.",character=gamestate.cutscene.renderMe,dt=1},
{text="I don't care about what you think!",character=gamestate.cutscene.renderMustache,dt=1},
{options={"Hit him in the face","Hit him in the face, gently", "Hit him in the face, sarcastically","Hit him in the face -ironically-"},character=gamestate.cutscene.renderMeStartCombat},
{text="-- To attack with a suitcase, press " .. controls.attack.."! --",character=gamestate.cutscene.renderMe,dt=1},
{text="",dt=0,character = gamestate.cutscene.replaceMustacheMan}}

gamestate.cutscene.explainGoingDown = {{text="To go down a hole, press "..controls.down..".",character=gamestate.cutscene.renderMe,dt=1}}


gamestate.cutscene.PickupSuitcase = {{text="I found the suitcase. Let's see, where to bring it.. ",character=gamestate.cutscene.renderMe,dt=1}}