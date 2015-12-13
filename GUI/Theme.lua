local Theme = {}

Theme.Button = {}

function Theme.bgColor()
    return 242, 242, 223
end

local function pColor()
    return 0, 0, 0
end

local function pColorHover()
    return 10, 10, 10
end

function Theme.Button.draw(self)
    love.graphics.setColor(pColor())
    if self.down then love.graphics.setColor(pColorHover()) end
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(255,255,255)
end

function Theme.update(self)

end

return Theme