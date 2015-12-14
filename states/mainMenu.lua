local mainMenu = {}
local Theme = require 'GUI.Theme'

function mainMenu:draw()
    love.graphics.setBackgroundColor(Theme.bgColor())    
    mainMenu.Header:draw()
    for _,v in ipairs(mainMenu.buttons) do
        v:draw()
    end
end

function mainMenu:update(dt)
     if love.keyboard.isDown("return") then
        GS.push(gamestate.playing)
     end

    self.Header:draw()
    for _, v in ipairs(mainMenu.buttons) do
        v:update()
        if v.pressed then
            v.callback()
        end
    end
end

mainMenu.Header = UI.Textarea(100, 0, 500, 50, {extensions = {Theme.Textarea}, _text='Hilbérts Hotel', font=love.graphics.newFont('graphics/font/Titania-Shadow.ttf', 40)})

mainMenu.buttons = {}

table.insert(mainMenu.buttons, UI.Button(10, 10, 90, 90, {extensions = {Theme.Button}, text='Play', callback = function() mainMenu:startPlaying() end }))
-- table.insert(mainMenu.buttons, UI.Button(10, 30, 90, 10, {extensions = {Theme.Button}, text='Settings'}))
-- table.insert(mainMenu.buttons, UI.Button(10, 50, 90, 10, {extensions = {Theme.Button}, text='Help'}))
-- table.insert(mainMenu.buttons, UI.Button(10, 70, 90, 10, {extensions = {Theme.Button}, text='Info'}))
table.insert(mainMenu.buttons, UI.Button(10, 110, 90, 90, {extensions = {Theme.Button}, text='Exit', callback = function() mainMenu:quit() end }))

function mainMenu:startPlaying()
    GS.push(gamestate.playing)
end

function mainMenu:options()
    GS.push(gamestate.options)
end

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