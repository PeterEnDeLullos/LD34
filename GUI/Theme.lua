local Theme = {}

Theme.Button = {}
Theme.Textarea = {}

function Theme.bgColor()
    return 242, 242, 223
end

local function pColor()
    return 245, 233, 105
end

local function pColorHover()
    return 10, 10, 10
end

local function pTextColor()
    return 105, 175, 245
end

local function pHeaderColor()
    return 105, 175, 245
end

local headerFont = love.graphics.newFont('graphics/font/Titania-Regular.ttf', 20)

function Theme.Button.draw(self)
    love.graphics.setColor(245, 233, 105)
    if self.down then love.graphics.setColor(10, 10, 10) end
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(105, 175, 245)
    local pfont = love.graphics.getFont()
    love.graphics.setFont(headerFont)
    love.graphics.print(self.text, self.x, self.y, 0, 1, 1, -10, -10)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(pfont)
end

function Theme.Textarea.draw(self)
    love.graphics.setColor(105, 175, 245)
    love.graphics.print(self._text or ' ', self.x, self.y)
    love.graphics.setColor(255, 255, 255)
end

return Theme