
Dummy = Class{
    init = function(self,x,y,newTile,ww,name)
    self.size = 32
    print(ww)
    self.health = 2
    self.img = love.graphics.newImage('graphics/entity/enemy/walking.png')
    local g = anim8.newGrid(64, 128, self.img:getWidth(), self.img:getHeight())
    self.animation = anim8.newAnimation(g('1-10',1), 0.1)
    self.x = x+0.5*self.size
    self.y = y-0.5*self.size
    self.name = name
    self.af = 0
    self.body = addSquareToWorld(self.x,self.y,56,120,ww)
    self.body.body:setFixedRotation(true)
    self.body.body:setMass(self.body.body:getMass()*10)
    newTile.enemies[self.body.fixture]=self
    newTile.killFixtures[self.body.fixture] = self
    mustacheMan = self
    self.speed = 100
    self.corner = -45
    end
}

function Dummy.action(self)
	print("do_action")
	if self.af <0 then
	shift(self.direction)
	self.af = 0.1
	gamestate.room.direction =self.direction
            self.body.body:setLinearVelocity(self.speed,0)

end

end

function Dummy:update(dt)
   
end
function Dummy:draw()

    self.animation:draw(self.img,self.body.body:getX()-32,self.body.body:getY()-68)

    
end
function Dummy:hit(dmg)
    
end