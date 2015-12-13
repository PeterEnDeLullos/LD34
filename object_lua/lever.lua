Lever = Class{
	init = function(self,x,y,ww,newTile,direction)
	self.x = x+0.5*tile_width
	self.y = y-0.5*tile_height
	newTile.objects[#newTile.objects+1]=self
	self.af = 0
	self.direction = direction
	self.corner = -45
	end
}
function Lever.action(self)
	print("do_action")
	if self.af <0 then
	shift(self.direction)
	self.af = 0.1
	gamestate.room.direction =self.direction
end
end
function Lever:update(dt)
	self.af = self.af - dt
end
function Lever:draw()

end
