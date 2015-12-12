Lever = Class{
	init = function(self,x,y,ww,newTile,direction)
	self.x = x+0.5*tile_width
	self.y = y-0.5*tile_height
	newTile.objects[#newTile.objects+1]=self
	self.direction = direction
	end
}
function Lever.action(self)
	print("do_action")
	shift(self.direction)
end
function Lever:update(dt)
	
end
function Lever:draw()

end
