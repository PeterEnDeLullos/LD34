local Theme = {}

Theme.Button = {}

function Theme.bgColor()
    return 242, 242, 223
end

local function pColor()
    return 245, 233, 105
end

local function pColorHover()
    return 10, 10, 10
end

function Theme.Button.draw(self)
    love.graphics.setColor(pColor())
    if self.down then love.graphics.setColor(pColorHover()) end
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.print(self.text, self.x, self.y, 0, 1, 1, 10, 10)
    love.graphics.setColor(255, 255, 255)
end

return Theme