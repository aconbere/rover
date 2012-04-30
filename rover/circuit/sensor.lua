local class = require("rover/class")
local config = require("rover/config")

local Sensor = class()

function Sensor:init(x, y, world, mouse)
  self.x = x
  self.y = y
  self.world = world
  self.mouse = mouse
  self.fired = false
  self.timeSince = 0

  self.world:addObject(self)
  self.lead = world:addObject(Lead.new(self, 10, 10, world, mouse))
end

function Sensor:update(dt)
  self.timeSince = self.timeSince + dt
  self.lead:update(dt)

  if self.timeSince > 6 then
    self.lead:fire(self.id)
    self.fired = true
    self.timeSince = 0
  elseif self.timeSince > config.SIGNAL_LIFE then
    self.fired = nil
  end
end

function Sensor:getX()
  return self.x
end

function Sensor:getY()
  return self.y
end

function Sensor:draw()
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("fill", self:getX(), self:getY(), 20, 20)
  love.graphics.setColor(0, 0, 0)
end

return Sensor
