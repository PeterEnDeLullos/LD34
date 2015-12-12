local G = require 'love.graphics'

local mm = {}
mm.map = {}
mm.l = {x=0,y=0}
mm.size = {w=0,h=0}

local A, B, C, D, E = 0, 6, 10, 16, 20

function mm.setup(width, height)
    mm.size.w = width
    mm.size.h = height
    mm.canvas = G.newCanvas(width, height)
end

function mm.update()
    for i,v in ipairs(gamestate.worldmap) do
        mm.map[i] = {}
        for j,vv in ipairs(v) do
            mm.map[i][j] = makeAbstract(vv)
        end
    end

    mm.map[gamestate.me.worldX][gamestate.me.worldY].active = true


    G.push('all')
    mm.canvas = G.newCanvas()
    G.setCanvas(mm.canvas)

    G.setLineStyle('rough')
    G.setColor(255,255,255)
    G.setLineJoin('miter')
    G.translate(-mm.l.x * E + mm.size.w / 2,-mm.l.y * E + mm.size.h / 2)

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
    -- G.translate()
    G.setCanvas()
    G.pop()
end

function mm.draw()
    G.draw(mm.canvas, 0, 0)
end

local abstractTile = {}

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

    if self.active then
        G.line(B, B, B, C, C, C, C, B, B, B)
    end
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
            G.line(D, B, D, C)
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
            G.line(B,D,C,D)
        end
    end
end

function abstractTile.__index(table, key)
    if type(abstractTile[key] == 'function') then
        return function( ... ) abstractTile[key]( ... ) end
    else
        return abstractTile[key]
    end
end

function makeAbstract(tile)
    local abstract = {}
    abstract.left = tile.left ~= nil 
    abstract.right = tile.right ~= nil
    abstract.up = tile.down ~= nil
    abstract.down = tile.up ~= nil
    abstract.active = false
    abstract = setmetatable(abstract, abstractTile)
    abstract.__index = abstractTile
    return abstract
end

return mm