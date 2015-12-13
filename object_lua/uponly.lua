upOnly = Class{
    init = function(self,x,y,x2,y2,newTile,ww)
    self.x1 = x
    self.y1 = y
    self.x2 = x2
    self.y2 = y2
    newTile.objects[#newTile.objects+1]=self
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
    print(character.x..":"..self.x1)
    print((character.x-self.x1) * dyx)
    print(character.y)
    print("ANS"..(character.x-self.x1) * dyx + character.y..">".. self.resetY.."-"..(tile_height+10).."="..(self.resetY-tile_height+10))

    if (character.x -self.x1 )*dyx +character.y > self.resetY-tile_height+10 then
        self.body.body:setY(-1000)

    else
        self.body.body:setY(self.resetY)
    end

end

function upOnly:draw()

end
