local G = require 'love.graphics'

local mm = {}
mm.map = {}
mm.location = {x=0,y=0}
mm.size = {}

local A, B, C, D, E = 0, 6, 10, 16, 20

function mm.setup(width, height)
    mm.location.x = gamestate.worldmap.xco
    mm.location.y = gamestate.worldmap.yco
    mm.width = width
    mm.height = height
    mm.canvas = G.newCanvas(width, height)
end

function mm.update()
    mm.location.x = gamestate.worldmap.xco
    mm.location.y = gamestate.worldmap.yco

    for i,v in ipairs(gamestate.worldmap) do
        mm.map[i] = {}
        for j,vv in ipairs(v) do
            mm.map[i][j] = makeAbstract(vv)
        end
    end
    G.push('all')
    mm.canvas = G.newCanvas()
    G.setCanvas(mm.canvas)

    G.setLineStyle('rough')
    G.setColor(255,255,255)
    G.setLineJoin('miter')

    for i, v in ipairs(mm.map) do
        G.translate(0, E)
        G.push()
        for  j, d in ipairs(v) do
            G.translate(E, 0)
            d:draw()
            if mm.map[i+1] and mm.map[i+1][j] then d:drawTunnel(mm.map[i+1][j], "right") else d:fixInserts('right') end
            if mm.map[i][j+1] then d:drawTunnel(mm.map[i][j+1], "down") else d:fixInserts('down') end
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

function abstractTile:draw(x, y)
    line = {}
    lines = {}
    line={A,C, A,D}
    if self.right then table.insert(line, B) table.insert(line, D)
        table.insert(lines, line) line = {C, D} end
    table.insert(line, D) table.insert(line, D)
    if self.down then table.insert(line, D) table.insert(line, C)
        table.insert(lines, line) line = {D, B} end
    table.insert(line, D) table.insert(line, A)
    if self.left and not x == 1 then table.insert(line, C) table.insert(line, A)
        table.insert(lines, line) line = {B, A} end
    table.insert(line, A) table.insert(line, A)
    if self.up and not y == 1 then table.insert(line, A) table.insert(line, B) 
    else
        table.remove(lines[1] or line) table.remove(lines[1] or line)
        lines[1] = lines[1] or {}
        while #line > 0 do
            table.insert(lines[1], table.remove(line))
        end
        table.insert(lines[1], A) table.insert(lines[1], D)
    end
    for _, line in ipairs(lines) do
        G.line(line)
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
                G.line(E, B, E, C)
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
                G.line(B,E,C,E)
            end
        else
            G.line(B,D,C,D)
        end
    end
end

function abstractTile:__index(key)
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
    abstract.up = tile.up ~= nil
    abstract.down = tile.down ~= nil
    abstract = setmetatable(abstract, abstractTile)
    abstract.__index = abstractTile
    return abstract
end

return mm