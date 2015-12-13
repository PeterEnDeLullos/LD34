
deathLine = Class{
    init = function(self,x,y,x2,y2,newTile,ww)
    self.x1 = x
    self.y1 = y
    self.x2 = x2
    self.fall_through = -1
    self.y2 = y2
    newTile.objects[#newTile.objects+1]=self
    self.af = 0

    self.world = ww
     self.body = addLineToWorld({x=self.x1,y=self.y1},{x=self.x2,y=self.y2},ww,true)
     self.body.rev = self
     self.resetY = self.body.body:getY()
    newTile.killFixtures[self.body.fixture] = self
    self.direction = direction
    self.corner = -45
    end
}

function deathLine.action(self)
	


end

function deathLine:update(dt)
  

end

function deathLine:draw()

end
