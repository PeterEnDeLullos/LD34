local G = require 'love.graphics'

local mm = {}
mm.map = {}
mm.location = {x=0,y=0}
mm.size = {}

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
        G.translate(0, 10)
        G.push()
        for  j, d in ipairs(v) do
            G.translate(10, 0)
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
    line={0,4, 0,6}
    if self.right then table.insert(line, 2) table.insert(line, 6)
        table.insert(lines, line) line = {4, 6} end
    table.insert(line, 6) table.insert(line, 6)
    if self.down then table.insert(line, 6) table.insert(line, 4)
        table.insert(lines, line) line = {6, 2} end
    table.insert(line, 6) table.insert(line, 0)
    if self.left and not x == 1 then table.insert(line, 4) table.insert(line, 0)
        table.insert(lines, line) line = {2, 0} end
    table.insert(line, 0) table.insert(line, 0)
    if self.up and not y == 1 then table.insert(line, 0) table.insert(line, 2) 
    else
        table.remove(lines[1] or line) table.remove(lines[1] or line)
        lines[1] = lines[1] or {}
        while #line > 0 do
            table.insert(lines[1], table.remove(line, 1))
        end
        table.insert(lines[1], 0) table.insert(lines[1], 6)
    end
    for _, line in ipairs(lines) do
        G.line(line)
    end
end

function abstractTile:fixInserts(direction)
    if direction == "down" then 
        G.line(6,2,6,4)
    else
        G.line(2,6,4,6)
    end
end

function abstractTile:drawTunnel(other, direction)
    if direction == "down" then
        if self.down then
            if other.up then
                G.line(6,2,10,2)
                G.line(6,4,10,4)
            else
                G.line(10, 2, 10, 4)
            end
        else
            G.line(6, 2, 6, 4)
        end
    else
        if self.right then
            if other.left then
                G.line(2,6,2,10)
                G.line(4,6,4,10)
            else
                G.line(2,10,4,10)
            end
        else
            G.line(2,6,4,6)
        end
    end
end

function abstractTile:__index(key)
    if type(abstractTile[key] == 'function') then
        return function( ... ) abstractTile[key](...) end
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