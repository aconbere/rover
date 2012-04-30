require('math')

local class  = require("rover/class")
local config = require("rover/config")
local Draggable = require("rover/draggable")

local Gate = class({ x = nil
                   , y = nil
                   , image = nil
                   })

function Gate:init(x, y, world, mouse)
  self.world = world
  self.mouse = mouse
  self.timeSince = 0

  self:setX(x)
  self:setY(y)

  Draggable(self, mouse)
end

function Gate:update(dt)
  self.timeSince = self.timeSince + dt

  if self.timeSince > config.SIGNAL_LIFE then
    self.fired = nil
    self.timeSince = 0
  end

  for _, lead in pairs(self.leads) do
    lead:update(dt)
  end
end

function Gate:fire(dt)
  self.timeSince = 0
  self.leads.output:fire(dt)
end

function Gate:height()
  return self.image:getHeight()
end

function Gate:width()
  return self.image:getWidth()
end

function Gate:draw()
  love.graphics.draw(self.image, self:getX(), self:getY(), 0, 1, 1, 0, 0)
end

function Gate:intersects(x, y)
  -- should be the equation for this triangle
  for i, lead in pairs(self.leads) do
    if lead:intersects(x,y) then
      return false
    end
  end
  return x > self:getX() and x < self:getX() + self:width() and
         y > self:getY() and y < self:getY() + self:height()
end

function Gate:setX(x)
  if x < 80 then
    self.__x = 80 
  elseif x > self.world.width then
    self.__x = self.world.width
  else
    self.__x = x
  end
end

function Gate:setY(y)
  if y < 0 then
    self.__y = 0
  elseif y > self.world.height then
    self.__y = self.world.height
  else
    self.__y = y
  end
end

function Gate:getX()
  return math.max(self.__x, 80)
end

function Gate:getY()
  return self.__y
end

function Gate:attachToWorld()
  self.world:addObject(self)
  for i, l in pairs(self.leads) do
    self.world:addObject(l)
  end
end

return Gate
