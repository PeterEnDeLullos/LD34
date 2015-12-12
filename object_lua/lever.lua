Lever = Class{
	init = function(self,x,y,ww,newTile)
	self.x = x+0.5*tile_width
	self.y = y-0.5*tile_height
	newTile.objects[#newTile.objects+1]=self
	end
}
function Lever:action()

end
function Lever:update(dt)
	
end
function Lever:draw()

end
