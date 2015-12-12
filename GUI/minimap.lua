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
end

function mm.update()
    mm.location.x = gamestate.worldmap.xco
    mm.location.y = gamestate.worldmap.yco

    for i,v in ipairs(gamestate.worldmap) do
        mm.map[i] = {}
        for j,v in ipairs(v) do
            mm.map[i][j] = makeAbstract(v)
        end
    end
end

function mm.draw()
    local canvas = G.newCanvas(width, height)
    G.push('all')
    G.setCanvas(canvas)

    G.setLineStyle('rough')
    G.setLineWidth(1)
    G.setLineJoin('miter')
    for i, v in ipairs(mm.map) do
        G.translate(0, 10)
        G.push()
        for  j, v in ipairs(mm.map[i]) do
            G.translate(10, 0)
            local tile = mm.map[i][j]
            tile:draw(i, j)
            if mm.map[i+1] and mm.map[i+1][j] then tile:drawTunnel(mm.map[i+1][j], "right") else tile:fixInserts('right') end
            if mm.map[i][j+1] then tile:drawTunnel(mm.map[i][j+1], "down") else tile:fixInserts('down') end
        end
        G.pop()
    end

    G.setCanvas()
    G.pop()
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
    for line in lines do
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


function makeAbstract(tile)
    local abstract = {}
    abstract.left = not not tile.left 
    abstract.right = not not tile.right 
    abstract.up = not not tile.up 
    abstract.down = not not tile.down  
    return setmetatable(abstract, abstractTile)
end

return mm