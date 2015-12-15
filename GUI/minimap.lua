local G = require 'love.graphics'

local mm = {}
mm.map = {}
mm.l = {x=0,y=0}
mm.size = {w=100,h=100}
mm.canvas = {getDimensions=function()return 0,0 end }

local A, B, C, D, E, M = 0, 6, 10, 16, 20, 8

function mm.setup(width, height)
    mm.size.w = width
    mm.size.h = height
    mm.canvas = G.newCanvas(width, height)
end

function mm.update()
    mm.l.x = gamestate.me.worldX
    mm.l.y = gamestate.me.worldY

    local map = {}
    -- wie heeft dit geschreven?!?! Dit MOET hier gefixt worden, kan NIET elders in de code.
    for i,v in pairs(gamestate.worldmap) do
        if not map.lowest then 
            map.lowest = i 
        else
            map.lowest = math.min(map.lowest, i) 
        end
        map[i] = {}
        for j,vv in pairs(v) do
            if not map[i].lowest then 
                map[i].lowest = j 
            else
                map[i].lowest = math.min(map[i].lowest, j)
            end
            map[i][j] = makeAbstract(vv)
        end
    end

    mm.map = {}
    for i = map.lowest, #map do
        local v = map[i]
        mm.map[i - map.lowest + 1] = {}
        for j = v.lowest, #v do
            if i == gamestate.me.worldX and j == gamestate.me.worldY then
                v[j].type = 'active'
            end
            mm.map[i - map.lowest + 1][j - v.lowest + 1] = v[j]
        end
    end

    G.push('all')
    w, h = unpack({mm.canvas:getDimensions()} or {0, 0})
    mm.canvas = G.newCanvas(mm.size.w or 100, mm.size.h or 100)
    G.setCanvas(mm.canvas)
    mm.canvas:clear(0,0,0,51)

    G.setLineStyle('rough')
    G.setColor(255,255,255)
    G.setLineJoin('miter')

    local centerX = (mm.l.x + 0.5 - map.lowest + 1) * E
    local centerY = (mm.l.y + 0.5 - map[mm.l.x].lowest + 1) * E
    
    G.translate(0.5 * w, 0.5*h)
    G.rotate(-math.pi / 2)
    G.translate(-centerY,-centerX)
    
    for i, v in ipairs(mm.map) do
        local v = mm.map[i]
        G.translate(0, E)
        G.push()
        for  j, d in ipairs(v) do
            G.translate(E, 0)
            d:draw(i, j)
            if mm.map[i+1] ~= nil and mm.map[i+1][j] ~= nil then d:drawTunnel(mm.map[i+1][j], "right") else d:fixInserts("right") end
            if mm.map[i][j+1] ~= nil then d:drawTunnel(mm.map[i][j+1], "down") else d:fixInserts("down") end
        end
        G.pop()
    end
    G.setCanvas()
    G.pop()
end

function mm.draw()
    G.draw(mm.canvas, 0, 0)
end

local abstractTile = {}
abstractTile.render = setmetatable({}, {__index = function(table, key) 
    if not key == nil then 
        return function(...) 
            getraw(abstractTile.render, key)(...) 
        end 
    end 
    return function() end 
end })

function abstractTile:draw(x, y)
    line = {}
    lines = {}
    line={A,D}
    if self.right then table.insert(line, B) table.insert(line, D)
        table.insert(lines, line) line = {C, D} end
    
    table.insert(line, D) table.insert(line, D)

    if self.down then table.insert(line, D) table.insert(line, C)
        table.insert(lines, line) line = {D, B} end
    
    table.insert(line, D) table.insert(line, A)

    if self.left and x ~= 1 then table.insert(line, C) table.insert(line, A)
        table.insert(lines, line) line = {B, A} end
    
    table.insert(line, A) table.insert(line, A)

    if self.up and y ~= 1 then table.insert(line, A) table.insert(line, B) 
        table.insert(lines, line) line = {A, C} end
    
    table.insert(line, A) table.insert(line, D)

    table.insert(lines, line)
    for _, line in ipairs(lines) do
        G.line(line)
    end

    if self.type then
        
        abstractTile.render[self.type]()
    end
end

function abstractTile.render.active()
    G.line(B, B, B, C, C, C, C, B, B, B)
end 

function abstractTile.render.down()
    G.line(C, C, M, M, C, B)
    G.line(B, B, B - 2, B + 2, B, C)
end

function abstractTile.render.up()
    G.line(B, B, M, M, B, C)
    G.line(C, B, C + 2, B + 2, C, C)
end

function abstractTile.render.right()
    G.line(B, B, M, M, C, B)
    G.line(C, C, B + 2, C + 2, B, C)
end

function abstractTile.render.left()
    G.line(C, C, M, M, B, C)
    G.line(B, B, B + 2, B - 2, C, B)
end

function abstractTile.render.goal()
    G.line(C, C, B, B)
    G.line(C, B, B, C)
end


function abstractTile:fixInserts(direction)
    if direction == "down" then 
        G.line(D,B,D,C)
    else
        G.line(B,D,C,D)
    end
end

function abstractTile:drawTunnel(other, direction)
    if direction == "down" then
        if self.down then
            if other.up then
                G.line(D,B,E,B)
                G.line(D,C,E,C)
            else
                G.line(D, B, D, C)
            end
        else
            G.line(E, B, E, C)
        end
    else
        if self.right then
            if other.left then
                G.line(B,D,B,E)
                G.line(C,D,C,E)
            else
                G.line(B,D,C,D)
            end
        else
            G.line(B,E,C,E)
        end
    end
end

function abstractTile.__index(table, key)
    if key ~= nil and type(abstractTile[key] == 'function') then
        return function( ... ) abstractTile[key]( ... ) end
    elseif(key ~= nil) then
        return abstractTile[key]
    end
    return (function() return end)
end

function makeAbstract(tile)
    local abstract = {}
    abstract.left = tile.left ~= nil 
    abstract.right = tile.right ~= nil
    abstract.up = tile.down ~= nil
    abstract.down = tile.up ~= nil
    abstract.type = tile.direction
    if tile.isGoal then abstract.type = 'goal' end
    print(tile.direction)
    abstract = setmetatable(abstract, abstractTile)
    abstract.__index = abstractTile
    return abstract
end

return mm