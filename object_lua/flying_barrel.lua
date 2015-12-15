FlyingBarrel = Class{
	init = function(self,x,y,newTile,ww)
	self.x = x-0.5*tile_height
	self.y = y-0.5*tile_height
	self.world = ww
	 self.body = addCircleToWorld(self.x,self.y,tile_height/2,ww,"dynamic")
	 self.body.rev = self
	 newTile.objects[#newTile.objects+1]=self
	newTile.killFixtures[self.body.fixture] = self
	end
}
function FlyingBarrel:update(dt,i)
	local x, y = self.body.body:getLinearVelocity()
	if math.abs(x)<= 0.01*dt and math.abs(y) <=0.01*dt then
		gamestate.room.killFixtures[self.body.fixture] = nil
		gamestate.room.objects[i] = nil
		self.body.body:destroy()

	end
end
function FlyingBarrel:action()

	end
function FlyingBarrel:draw()
	love.graphics.circle("fill",self.body.body:getX(),self.body.body:getY(),tile_height/2)
end
