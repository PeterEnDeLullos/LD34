
Enemy = Class{
    init = function(self,x,y,newTile,ww)
    self.size = 32
    print(ww)
    self.health = 1
    self.img = love.graphics.newImage('graphics/entity/enemy/walking.png')
    local g = anim8.newGrid(64, 128, self.img:getWidth(), self.img:getHeight())
    self.animation = anim8.newAnimation(g('1-10',1), 0.1)
    self.x = x+0.5*self.size
    self.y = y-0.5*self.size
    self.af = 0
    self.body = addSquareToWorld(self.x,self.y,56,120,ww,"dynamic")
    self.body.body:setFixedRotation(true)
    self.body.body:setMass(self.body.body:getMass()*10)
    newTile.enemies[self.body.fixture]=self
    newTile.killFixtures[self.body.fixture] = self

    self.speed = 100
    self.corner = -45
    end
}

function Enemy.action(self)
	print("do_action")
	if self.af <0 then
	shift(self.direction)
	self.af = 0.1
	gamestate.room.direction =self.direction
            self.body.body:setLinearVelocity(self.speed,0)

end

end
function Enemy:getRay(RR)
    return function (fixture, x, y, xn, yn, fraction)
        self[RR] = self[RR] -1
        return 1
end
end 
function Enemy:update(dt)
    if self.health <= 0 then
        if not self.zz then
            self.zz = true
  
                self.body.body:setFixedRotation(false)
                self.body.body:destroy()
                gamestate.ENEMYKILLED = true
                addLevelTwo()
        end
           --       self.x = self.body.body:getX()
          --  self.y = self.body.body:getY()+56
    else
            self.animation:update(dt)

    local dx, dy = self.body.body:getLinearVelocity()
    if  math.ceil(dx) <1 or self.leftRayFound > 0 and self.rightRayFound > 0 then
         if not self.idle  then
        self.idle = true
        self.speed = self.speed* -1
    end
    else
        self.idle = nil
    end
    local x = self.body.body:getX()
    local y  =  self.body.body:getY()
    
    self.leftRayFound = 1
    gamestate.room.world:rayCast( x-0.25*tile_width,y,x-0.25*tile_width,y+180, self:getRay( "leftRayFound") )
    self.rightRayFound = 1
    gamestate.room.world:rayCast( x+0.25*tile_width,y,x+0.25*tile_width,y+180, self:getRay("rightRayFound") )
    self.body.body:setLinearVelocity(self.speed,dy)
    end 
end
function Enemy:draw()
    if self.health <= 0 then
    self.animation:draw(self.img,self.x-32,self.y-4,0.5*math.pi)
else
    if self.speed > 0 then
    self.animation:draw(self.img,self.body.body:getX()-32,self.body.body:getY()-68,0,1,1)
else
    self.animation:draw(self.img,self.body.body:getX()+32,self.body.body:getY()-68,0,-1,1)
end

end
    
end
function Enemy:hit(dmg)
    self.health=self.health -dmg
    print("Hit Enemy for " .. dmg..", health left:" .. self.health)

    if(self.health <= 0) then
           gamestate.room.killFixtures[self.body.fixture] = nil

        print("DEAD")
    end
end