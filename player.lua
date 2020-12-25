--! file: player.lua

-- player class implements the player and movement

Player = Object:extend()

SPEED = 150

function Player:new(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = 0
    self.dy = 0
end

function Player:update(dt)
  self:checkMove(dt)
end

function Player:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.width/5, self.height/5)
end

function Player:checkMove(dt)
  if love.keyboard.isDown('up') then
        self.dy = -SPEED
        self.y = math.max(self.y + self.dy*dt, 0)
  end
  if love.keyboard.isDown('down') then
        self.dy = SPEED
        self.y = math.min(self.y + self.dy*dt, VIRTUAL_HEIGHT - 15)
  end
  if love.keyboard.isDown('left') then
        self.dx = -SPEED
        self.x = math.max(self.x + self.dx*dt, 0)
  end
  if love.keyboard.isDown('right') then
        self.dx = SPEED
        self.x = math.min(self.x + self.dx*dt, VIRTUAL_WIDTH - 15)
  end
end
