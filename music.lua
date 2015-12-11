local _ = require 'TEsounds/TEsoundpp'
local audio = require 'love.audio'

local Queue = {}

function Queue:pop()
	self.current = self.next
	self.next = self.current[2] or self.onEnd
	return self.current[1], self.current[3], self.current[4]
end

function Queue:append(item, name, callback)
	local node = { item, nil , name, callback}
	if not self.next then
		self.next = node
	else
		self.last[2] = node
	end
	self.last = node
end

function Queue:setLoopStart(item, name)
	if not item then item = self.next end
	self.onEnd = item
	return item
end

function Queue:type()
	return "Queue"
end

function Queue:empty()
	self.next = nil
	self.last = nil
	self.current = nil
	self.onEnd = nil
end

function Queue.__index(table, key)
	return Queue[key]
end


local Loaded = {}

function Loaded.__index(table, key)
	table[key] = { audio.newSource(key), key, 0 }
	return table[key]
end

function Loaded.__newindex(table, key, value)
	rawset(table, key, value)
	print("Successfully loaded '" .. key .. "'")
end

function Loaded:type() return "Loaded" end


local Fade = {}

function Fade:getVolume()
	return (self[2] * (self[4] - self[3]) / self[1]) + self[3] 
end

function Fade:update(dt)
	self[2] = self[2] + dt
end

function Fade.__index(table, key)
	return Fade[key]
end

function Fade:type() return "Fade" end


local Player = {}

function Player:start(filename, volume, pitch, callback)
	self.playing = self.playing + 1
	self.loaded[filename][3] = TEsound.playSource(
		self.loaded[filename][1], 
		self.tag,
		volume or TEsound.findVolume(self.tag),
		pitch or TEsound.findPitch(self.tag),
		function(d) 
			self.playing = self.playing - 1 
			self.loaded[filename][3] = 0
			if callback then return callback(d) end
		end)
end

function Player:load(filename)
	local a = self.playing[filename]
end

function Player:pause()
	TEsound.pause(self.tag)
	self.dormant = self.playing
	self.playing = 0
end

function Player:resume()
	TEsound.resume(self.tag)
	self.playing = self.playing + self.dormant
	self.dormant = 0
end

function Player:stop()
	TEsound.stop(self.tag)
	self.playing = 0
end

function Player:enqueue(filename, play, callback)
	self.queue:append(self.loaded[filename], filename, callback)
	if play and not self.playing then self.playNext() end
end

function Player:crossFadeTo(otherplayer, time)
	self:fadeTo(time, 0)
	otherplayer:fadeTo(time, self:getVolume(), 0)
end

function Player:fadeTo(time, volume, start)
	self.fade = setmetatable({time, 0, start or self:getVolume(), volume}, Fade)
	if self.playing == 0 then self:playNext() end
end


--[[ 
	TODO: add directional fades 
]]--

function Player:update(dt)
	if not self.playing then return end

	if self.fade then
		self.fade:update(dt)
		TEsound.volume(self.tag, self.fade:getVolume())
	end
end

function Player:playNext(callback)
	if not self.queue.next then return end
	local src, name, call = self.queue:pop()
	callback = callback or call
	self:start(name, nil, nil, function(d)
		self:playNext()
		if callback then return callback(d) end
	end)
end

function Player:getVolume()
	return TEsound.findVolume(self.tag)
end

function Player.__index(table, key)
	return Player[key]
end

function Player:type() return "Player" end


local Music = setmetatable({}, { 
	__index = function(table, key)
		table[key] = setmetatable({
			loaded=setmetatable({}, Loaded ), 
			fade=nil,
			playing=0,
			dormant=0,
			queue=setmetatable({
				next=nil,
				last=nil,
				onEnd=nil
			},Queue),
			tag=key
		}, Player) 
		print("Successfully created music player '" .. key .. "'")
		return table[key]
	end
})

if _REQUIREDNAME == nil then
	_G.Music = Music
else
	_g[_REQUIREDNAME] = Music
end

return Music