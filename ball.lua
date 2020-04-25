require "class"

Ball = class()

function Ball:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.ballDX = math.random(2) == 1 and 100 or -100
    self.ballDY = math.random(50,-50) * 1.5

    self.ballSpeedMultiplicationFactor = 1

    self.bounce = love.audio.newSource("bounce.ogg", "stream")
end

function Ball:reset()
    self.x = VIRTUAL_SCREEN_WIDTH/2
    self.y = VIRTUAL_SCREEN_HEIGHT/2
    self.ballDX = math.random(2) == 1 and 100 or -100
    self.ballDY = math.random(50,-50) * 1.5
    self.ballSpeedMultiplicationFactor = 1
end

function Ball:render()
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle('fill', self.x , self.y , self.width, self.height)
end

function Ball:update(dt)
    self.x = self.x + self.ballDX * dt
    self.y = self.y + self.ballDY * dt
end

function Ball:collides(objectOfCollision)
    if(self.x > objectOfCollision.x + objectOfCollision.width or self.x + self.width < objectOfCollision.x) then
        return false
    end

    if(self.y > objectOfCollision.y + objectOfCollision.height or self.y + self.height < objectOfCollision.y) then
        return false
    end

    love.audio.play(self.bounce)
    return true
end