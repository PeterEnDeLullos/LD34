local Theme = {}

Theme.Button = {}

function Theme.Button.draw(self)
    love.graphics.setColor(pColor())
    if self.down then love.graphics.setColor(pColorHover()) end
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(255,255,255)
end

local function pColor()
    return 0, 0, 0
end

local function pColorHover()
    return 10, 10, 10
end

return Theme