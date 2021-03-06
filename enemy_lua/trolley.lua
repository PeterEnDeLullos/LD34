
Trolley = Class{
    init = function(self,x,y,newTile,ww)
    self.size = 32
    print(ww)
    self.health = 10000000
    self.img = love.graphics.newImage('graphics/entity/trolley/trolley.png')
    local g = anim8.newGrid(64, 128, self.img:getWidth(), self.img:getHeight())
    self.animation = anim8.newAnimation(g('1-2',1), 0.1)
    self.x = x+0.5*self.size
    self.y = y-0.5*self.size
    
    self.af = 0
    self.body = addSquareToWorld(self.x,self.y,56,120,ww,"dynamic")
    self.body.body:setFixedRotation(true)
    self.body.body:setMass(self.body.body:getMass()*10)
    newTile.enemies[self.body.fixture]=self
    self.speed = 100
    self.corner = -45
    self.noRayFound = false
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
function Trolley:getRay(RR)
    return function (fixture, x, y, xn, yn, fraction)
        self[RR] = self[RR] -1
        return 1
end
end 
function Trolley:update(dt)
    self.animation:update(dt)
    local dx, dy = self.body.body:getLinearVelocity()
    if math.abs(dx)<1 or self.leftRayFound > 0 and self.rightRayFound > 0 then
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

function Trolley:draw()

    self.animation:draw(self.img,self.body.body:getX()-32,self.body.body:getY()-68)
    
end
function Trolley:hit(dmg)
    self.health=self.health -dmg
    print("Hit Trolley for " .. dmg..", health left:" .. self.health)

    if(self.health <= 0) then
        self.health = 100000000
    end
end