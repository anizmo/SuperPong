require "class"

Paddle = class()

function Paddle:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.startPosX = x
    self.startPosY = y

    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then 
        self.y = math.max(self.height, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_SCREEN_HEIGHT - self.height - 15, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.setColor(0,255,0)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:reset()
    self.x = self.startPosX
    self.y = self.startPosY
end
