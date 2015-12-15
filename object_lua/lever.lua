Lever = Class{
    init = function(self,x,y,newTile,ww,direction)
    self.x = x+0.5*tile_width
    self.y = y-0.5*tile_height
    self.img = love.graphics.newImage('graphics/entity/lever/lever.png')
    local g = anim8.newGrid(64, 64, self.img:getWidth(), self.img:getHeight())
    self.animation = anim8.newAnimation(g('1-2',1), 1)

    newTile.objects[#newTile.objects+1]=self
    self.af = 0
    self.direction = direction
    self.corner = -45
    end
}

function Lever.action(self)
	

	if self.af <=0 then
	shift(self.direction)
	self.af = 1
    gamestate.warp.direction = self.direction
	gamestate.room.direction =self.direction
            GS.switch(gamestate.warp)

end

end

function Lever:update(dt)
    if self.af >= 0 then
    	self.af = self.af - dt
    	self.animation:gotoFrame(2)
	else	
		self.animation:gotoFrame(1)
    end


end

function Lever:draw()
	self.animation:draw(self.img,self.x,self.y-32)
end
