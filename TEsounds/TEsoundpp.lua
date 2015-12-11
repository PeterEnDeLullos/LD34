require "TEsounds/TEsound"

--[[
	our own addendum to the TEsound Love Library
]]--

function TEsound.playSource(source, tags, volume, pitch, func)
	if type(source) == "table" then
		assert(#source > 0, "List of sources must have at least one sound")
		source = source[math.random(#source)]
	end
	if not (type(source) == "userdata" and source:type() == "Source") then
		error("you must give me a source")
	end

	table.insert(TEsound.channels, {
		source,
		func,
		{volume or 1, pitch or 1},
		tags=(type(tags) == "table" and tags or {tags})
	})
	local s = TEsound.channels[#TEsound.channels]
	s[1]:play()
	s[1]:setVolume( (volume or 1) * TEsound.findVolume(tags) * (TEsound.volumeLevels.all or 1) )
	s[1]:setVolume( (pitch or 1) * TEsound.findPitch(tags) * (TEsound.pitchLevels.all or 1) )
	return #TEsound.channels
end

function TEsound.playLoopingSource(source, tags, n, volume, pitch)
	return TEsound.play( source, tags, volume, pitch,
		(not n or n > 1) and
		function(d)
			TEsound.playLoopingSource(source, tags, (n and n - 1), d[1], d[2])
		end
	)
end