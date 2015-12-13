Suitcase = Class{
	init = function(self,x,y,newTile,ww)
	self.x = x+0.5*tile_width
	self.y = y-0.5*tile_height
	self.world = ww
	    self.img = love.graphics.newImage('graphics/entity/suitcase/one.png')
	    self.rot = 0
	 self.body = addSquareToWorld(self.x,self.y,tile_width,tile_height,ww)
	 self.body.rev = self
	 newTile.objects[#newTile.objects+1]=self
	 gamestate.suitcase = self
	end
}
function Suitcase:action()

end
function Suitcase:update(dt)
	self.rot = self.rot + dt
end
function Suitcase:draw()
	love.graphics.draw(self.img,self.x,self.y,self.rot, 1, 1, 64 / 2, 60 / 2)
end
