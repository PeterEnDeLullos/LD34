Chest = Class{
	init = function(self,x,y,ww,newTile)
	self.x = x+0.5*tile_width
	self.y = y-0.5*tile_height
	self.world = ww
	 self.body = addSquareToWorld(self.x,self.y,tile_width,tile_height,ww)
	 self.body.rev = self
	 newTile.objects[#newTile.objects+1]=self
	end
}
function Chest:update(dt)

end
function Chest:draw()

end
