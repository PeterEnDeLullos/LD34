
Trolley = Class{
    init = function(self,x,y,newTile,ww)
    self.size = 32
    print(ww)
    self.img = love.graphics.newImage('graphics/trolley2.png')

    self.x = x+0.5*self.size
    self.y = y-0.5*self.size
    newTile.enemies[#newTile.enemies+1]=self
    self.af = 0
    self.body = addSquareToWorld(self.x,self.y,56,120,ww,"dynamic")
    self.body.body:setFixedRotation(true)
    self.body.body:setMass(self.body.body:getMass()*10)
    self.speed = 100
    self.corner = -45
    end
}

function Trolley.action(self)
	print("do_action")
	if self.af <0 then
	shift(self.direction)
	self.af = 0.1
	gamestate.room.direction =self.direction
            self.body.body:setLinearVelocity(self.speed,0)

end

end

function Trolley:update(dt)
    local dx, dy = self.body.body:getLinearVelocity()

    if dy > 1  or dx*self.speed <200 then
        self.speed = self.speed* -1
    end
        self.body.body:setLinearVelocity(self.speed,dy)
end

function Trolley:draw()
    love.graphics.draw(self.img,self.body.body:getX()-32,self.body.body:getY()-68)
end