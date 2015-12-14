CutSceneTrigger = Class{
	init = function(self,x,y,newTile,ww,scene,dist)
	self.x = x+0.5*tile_width
	self.y = y-0.5*tile_height
	self.scene =scene
	self.displayed = false
	if dist == nil then
		dist = 16000
	end
	self.dist = tonumber(dist)
	print(self.dist)
	 newTile.objects[#newTile.objects+1]=self
	end
}


function CutSceneTrigger:update(dt)
	dx = self.x - gamestate.me.body:getX()
	dy = self.y - gamestate.me.body:getY()
	print(self.dist.."<"..math.abs(dx*dx+dy*dy))
	if not self.displayed and  self.dist > math.abs(dx*dx+dy*dy) then
		self.displayed = true
		gamestate.cutscene.start( gamestate.cutscene[self.scene])
		
		
	end
end
function CutSceneTrigger:draw()

end

