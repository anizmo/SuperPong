require "class"

Border = class()

function Border:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.startPosX = x
    self.startPosY = y
end

function Border:render()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

function Border:reset()
    self.x = self.startPosX
    self.y = self.startPosY
end
