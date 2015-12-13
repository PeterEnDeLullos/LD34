
Circloid = Class{
    init = function(self,x,y,newTile,ww)
    self.size = 32
    print(ww)

    self.x = x+0.5*self.size
    self.y = y-0.5*self.size
    newTile.enemies[#newTile.enemies+1]=self
    self.af = 0
    self.body = addCircleToWorld(self.x,self.y,self.size,ww,"dynamic")
    self.speed = 100
    self.corner = -45
    newTile.killFixtures[self.body.fixture] = true
    end
}

function Circloid.action(self)
	print("do_action")
	if self.af <0 then
	shift(self.direction)
	self.af = 0.1
	gamestate.room.direction =self.direction
            self.body.body:setLinearVelocity(self.speed,0)

end

end

function Circloid:update(dt)
    local dx, dy = self.body.body:getLinearVelocity()
    if dy > 1  or dx*self.speed <200 then
        self.speed = self.speed* -1
    end
        self.body.body:setLinearVelocity(self.speed,dy)

end

function Circloid:draw()
    love.graphics.circle("fill",self.body.body:getX(),self.body.body:getY(),self.size)
end
