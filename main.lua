Class = require 'hump.class'
require 'map_interpretation'
debugWorldDraw = require("debugWorldDraw")
sti = require "sti"
anim8 = require 'anim8.anim8'
 gamera =  require 'gamera.gamera'
Camera = require 'hump.camera'
-- ALL data of game
gamestate = {}
GS = require 'hump.gamestate'
UI = require 'thranduil'
Theme = require 'GUI.Theme'
minimap = require 'GUI.minimap'

require 'states.mainMenu'
--require 'states.helpMenu'
--require 'states.optionsMenu'
---require 'states.infoMenu'
require 'controls'
require 'states.playing'
require 'states.cutscene_nander'

require 'states.dead'
require 'states.warping'

require 'level'
debug = true
GRAV = 1300

require 'character'
back = {}
require 'music'

tile_width = 64
tile_height = 64

--lines = {}


function love.load()
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
    gamestate.cam = gamera.new(0,-0,1,1)
    jump = 2
    character.load()

    local pixelcode = [[
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
            vec4 texcolor = Texel(texture, texture_coords);
            return texcolor * color;
        }
    ]]
 
    local vertexcode = [[
        vec4 position( mat4 transform_projection, vec4 vertex_position )
        {
            return transform_projection * vertex_position;
        }
    ]]
 
    shader = love.graphics.newShader(pixelcode, vertexcode)



  --[[
    usage: Music.<Player>:play(filename)
    Music.<Player>:enqueue(filename) = queue a track
    Music.<player>.queue.setLoopStart() = set next track in queue to be the start of the loop, looping everything of the remaining queue.
    Music.<player>:playNext(<callback>) = start playing the queue, and optionally call callback when the first song has ended.
  ]]--
 -- Music.theme:enqueue("music/theme_loop.wav")
  --Music.theme:enqueue("music/themeloop2.wav")
  --Music.theme.queue:setLoopStart()

  --Music.boss:enqueue("music/boss_intro.wav")
  --Music.boss:enqueue("music/boss_loop.wav")
  --Music.boss:enqueue("music/boss_loop.wav", nil, function(b) Music.boss:crossFadeTo(Music.theme, 20) end)

  --let's create a ball
  --column, ball
  gamestate.WM.newMiniPart("levels/1_3_2_hallway.lua",0,1)

  gamestate.WM.newMiniPart("levels/0_start.lua",1,1)
 gamestate.WM.newMiniPart("levels/0_first_lever.lua", 2, 1)
  gamestate.WM.newMiniPart("levels/0_2_2_jumpway.lua", 2, 2)
  gamestate.WM.newMiniPart("levels/0_koffer.lua", 1, 2)
gamestate.worldmap[1][2].isGoal = true
  gamestate.WM.enterRoom(1, 1, 'left')

  minimap.setup(120,120)
  minimap.update()

  --local shape = splash.aabb(150,50,50, 50)
    GS.registerEvents()
    UI.registerEvents()


    GS.switch(gamestate.mainMenu)
    printMap()
    --shift("left")
    printMap()

end


function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end


