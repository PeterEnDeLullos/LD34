
Thrower = Class{
    init = function(self,x,y,newTile,ww,direction) --direction: -1, 0, 1
    self.size = 32
    print(ww)
    self.health = 10000000
    self.img = love.graphics.newImage('graphics/entity/trolley/trolley.png')
    local g = anim8.newGrid(64, 128, self.img:getWidth(), self.img:getHeight())
    self.animation = anim8.newAnimation(g('1-2',1), 0.1)
    self.x = x+0.5*self.size
    self.y = y-0.5*self.size
    self.dir = direction
    self.af = 0
    self.body = addSquareToWorld(self.x,self.y,56,120,ww,"dynamic")
    self.body.body:setFixedRotation(true)
    self.body.body:setMass(self.body.body:getMass()*10)
    newTile.enemies[self.body.fixture]=self
    self.speed = 100
    self.corner = -45
    end
}

function Thrower.action(self)

end

function Thrower:update(dt)
   if self.timer == nil then
    self.timer = 0
end
    if self.timer <= 0 then
        self.timer = 4+dt
        local b = FlyingBarrel(self.x+1.5*self.dir*tile_width,self.y,gamestate.room,gamestate.room.world)
        b.body.body:setLinearVelocity(self.dir*300,300)
        end
    self.timer = self.timer - dt

end

function Thrower:draw()

    self.animation:draw(self.img,self.body.body:getX()-32,self.body.body:getY()-68)
    
end
function Thrower:hit(dmg)
    self.health=self.health -dmg
    print("Hit Trolley for " .. dmg..", health left:" .. self.health)

    if(self.health <= 0) then
        self.health = 100000000
    end
end