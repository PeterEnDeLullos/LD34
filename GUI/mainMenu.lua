local state_playing = require 'state_playing'

local mainMenu = {}

function mainMenu:draw(){
    love.graphics.getCanvas():clear()
    
    for _,v in ipairs(mainMenu.buttons) do
        v:draw()
    end
}

function mainMenu:update(dt)
    for _, v in ipairs(mainMenu.buttons) do
        v:update()
    end
end


mainMenu.buttons = {}

table.insert(mainMenu.buttons, UI.Button(10, 10, 90, 10, {extensions = {Theme.Button}, text='Play', callback=mainMenu:startPlaying }))
-- table.insert(mainMenu.buttons, UI.Button(10, 30, 90, 10, {extensions = {Theme.Button}, text='Settings'}))
-- table.insert(mainMenu.buttons, UI.Button(10, 50, 90, 10, {extensions = {Theme.Button}, text='Help'}))
-- table.insert(mainMenu.buttons, UI.Button(10, 70, 90, 10, {extensions = {Theme.Button}, text='Info'}))
table.insert(mainMenu.buttons, UI.Button(10, 90, 90, 10, {extensions = {Theme.Button}, text='Exit' callback=mainMenu:quit }))

function mainMenu:startPlaying()
    GS.push(gamestate.playing)
end

--[[
function mainMenu:options()
    GS.push(gamestate.options)
end
]]--

--[[
function mainMenu:help()
    GS.push(gamestate.help)
end
]]--

--[[
function mainMenu:info()
    GS.push(gamestate.info)
end
]]--

function mainMenu:quit()
    love.event.quit()
end



gamestate.mainMenu = mainMenu

return mainMenu