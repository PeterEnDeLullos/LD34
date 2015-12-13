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
    local dx = self.x1 -self.x2
    local dy = self.y1- self.y2
    local dyx = dy/dx
    if (character.x -self.x1 )*dyx +character.y > self.resetY-tile_height+10 then
        self.body.body:setY(-1000)
                print("BELOW")

    else
        print("ABOVE")
        self.body.body:setY(self.resetY)
    end

end

function upOnly:draw()

end
