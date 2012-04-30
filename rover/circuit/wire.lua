local class = require("rover/class")
local config = require("rover/config")

Wire = class({ type = "wire" })

function Wire:init(lead, world, mouse, active)
  self.head = lead
  self.tail = nil

  self.world = world
  self.mouse = mouse
  self.active = active
  self.timeSince = 0

  self.offsetX = 0
  self.offsetY = 0

  mouse:register("update", function (mx, my)
    if self.active then
      self.offsetX = mx
      self.offsetY = my
    end
  end)

  mouse:register("mousereleased", function (mx, my, button)
    if button == "l" then
      if self.active then
        self.active = false
        self.offsetX = 0
        self.offsetY = 0
      end
    end
  end)
end

function Wire:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setLineStyle("smooth")
  love.graphics.setLineWidth(2)

  if self.fired then
    love.graphics.setColor(255,0,0)
  else
    love.graphics.setColor(255, 255, 255)
  end

  if self.tail then
    love.graphics.line(self.head:getX(), self.head:getY(), self.tail:getX(), self.tail:getY())
  elseif self.active then
    love.graphics.line(self.head:getX(), self.head:getY(), self.offsetX, self.offsetY)
  end

  love.graphics.setColor(0,0,0)
end

function Wire:update(dt)
  self.timeSince = self.timeSince + dt
  if self.fired and self.timeSince > config.SIGNAL_LIFE then
    self.fired = nil
  end
end

function Wire:fire(id)
  assert(id)
  self.fired = true
  self.timeSince = 0
  if self.head and self.head.id ~= id then
    self.head:fire(self.id)
  elseif self.tail and self.tail.id ~= id then
    self.tail:fire(self.id)
  end
end

return Wire
