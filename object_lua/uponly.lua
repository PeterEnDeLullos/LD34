upOnly = Class{
    init = function(self,x,y,x2,y2,newTile,ww)
    self.x1 = x
    self.y1 = y
    self.x2 = x2
    self.fall_through = -1
    self.y2 = y2
    newTile.objects[#newTile.objects+1]=self
    if newTile.upOnlyList == nil then
        newTile.upOnlyList = {}
    end
    newTile.upOnlyList [#newTile.upOnlyList+1] = self
    self.af = 0

    self.world = ww
     self.body = addLineToWorld({x=self.x1,y=self.y1},{x=self.x2,y=self.y2},ww,true)
     self.body.rev = self
     self.resetY = self.body.body:getY()
    self.direction = direction
    self.corner = -45
    end
}

function upOnly.action(self)
	


end

function upOnly:update(dt)
    local dx = self.x2 -self.x1
    local dy = self.y1- self.y2
    local dyx = dy/dx

    if (character.x -self.x1 )*dyx +character.y > self.resetY-tile_height+4 or self.fall_through > 0 then
        self.body.body:setY(-1000)

    else
        self.body.body:setY(self.resetY)
    end
    if self.fall_through > 0 then
        self.fall_through = self.fall_through -dt
    end

end
function upOnly:setFallThrough()
        self.fall_through = 0.7
end
function upOnly:draw()

end
function upOnly:dist()
    local x1,x2 = self.x1, self.x2
    local y1,y2 = self.y1, self.y2
    local x3,y3 = gamestate.me.body:getX(), gamestate.me.body:getY()+64
    --(x1,y1, x2,y2, x3,y3): # x3,y3 is the point
    local px = x2-x1
    local py = y2-y1

    local something = px*px + py*py

    local u =  ((x3 - x1) * px + (y3 - y1) * py) / (something)

    if u > 1 then
        u = 1
    elseif u < 0 then
        u = 0
    end

    local x = x1 + u * px
    local y = y1 + u * py

    local  dx = x - x3
    local dy = y - y3

    -- Note: If the actual distance does not matter,
    -- if you only want to compare what this function
    -- returns to other results of this function, you
    -- can just return the squared distance instead
    -- (i.e. remove the sqrt) to gain a little performance


    return  dx*dx+dy*dy



end
function getNearestUpOnly()
    local min = 1000000000000
    local found = nil
    if gamestate.room.upOnlyList == nil then
        return nil
    end
    for k,v in pairs(gamestate.room.upOnlyList) do
        local dist = v:dist()
        if dist < min then
            min = dist
            found = v
            
        end
    end
    if min < 800 then

        return found
    end
    return nil

end